#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["pydantic>=2,<3"]
# ///
"""Debrief input: uv run transcript.py {codex,claude} FILE... --format={conversation,index,users}."""

import argparse
import difflib
import json
from pathlib import Path

from pydantic import (
    AliasChoices,
    AliasPath,
    BaseModel,
    Field,
    JsonValue,
    ValidationError,
)


class Text(BaseModel):
    text: str


class Message(BaseModel):
    role: str
    content: str | list[dict[str, JsonValue]]
    channel: str | None = Field(default=None, validation_alias=AliasChoices("channel", "phase"))


class ToolCall(BaseModel):
    name: str
    call_id: str = Field(validation_alias=AliasChoices("call_id", "id"))
    arguments: JsonValue = Field(validation_alias=AliasChoices("arguments", "input"))


class ToolResult(BaseModel):
    call_id: str = Field(validation_alias=AliasChoices("call_id", "tool_use_id"))
    body: JsonValue = Field(validation_alias=AliasChoices("output", "content"))
    is_error: bool = False


class ToolOutput(BaseModel):
    body: JsonValue = Field(validation_alias=AliasChoices("output", "value", "content", "text"))
    exit_code: int | None = Field(
        default=None, validation_alias=AliasChoices("exit_code", "exitCode")
    )
    is_error: bool = Field(default=False, validation_alias=AliasChoices("is_error", "isError"))
    status: str | None = None


class Record(BaseModel):
    type: str
    payload: dict[str, JsonValue] = Field(
        default_factory=dict, validation_alias=AliasChoices("payload", "message")
    )
    is_meta: bool = Field(default=False, alias="isMeta")
    is_summary: bool = Field(default=False, alias="isCompactSummary")
    exit_code: int | None = Field(
        default=None,
        validation_alias=AliasChoices(
            AliasPath("toolUseResult", "exit_code"),
            AliasPath("toolUseResult", "exitCode"),
        ),
    )


class Entry(BaseModel):
    ref: str
    role: str
    text: str
    status: str = ""


def item(data: dict[str, JsonValue]) -> Message | Text | ToolCall | ToolResult | None:
    match data.get("type", "message"):
        case "message":
            return Message.model_validate(data)
        case "agent_message":
            return Message.model_validate({"role": "agent", "content": data["content"]})
        case "text" | "input_text" | "output_text":
            return Text.model_validate(data)
        case "function_call" | "custom_tool_call" | "tool_use":
            return ToolCall.model_validate(data)
        case "function_call_output" | "custom_tool_call_output" | "tool_result":
            return ToolResult.model_validate(data)
    return None


def output(value: JsonValue) -> tuple[str, list[str]]:
    if isinstance(value, str):
        try:
            value = json.loads(value)
        except json.JSONDecodeError:
            return value, []
    if isinstance(value, list):
        parts = [output(part) for part in value]
        return "\n".join(body for body, _ in parts), [s for _, statuses in parts for s in statuses]
    try:
        envelope = ToolOutput.model_validate(value)
    except ValidationError:
        return json.dumps(value, ensure_ascii=False), []
    body, statuses = output(envelope.body)
    status = envelope.model_dump(exclude={"body"}, exclude_none=True, exclude_defaults=True)
    return body, ([json.dumps(status)] if status else []) + statuses


def read_file(path: Path, provider: str, *, file_label: str) -> list[Entry]:
    entries = []
    for line, raw in enumerate(path.read_text().splitlines(), 1):
        if not raw.strip():
            continue
        ref = f"{file_label}:{line}"
        try:
            record = Record.model_validate_json(raw)
            wanted = ("response_item",) if provider == "codex" else ("user", "assistant")
            if record.type not in wanted:
                continue
            node = item(record.payload)
            role = ""
            if isinstance(node, Message):
                if node.channel == "analysis":
                    continue
                role = "context" if record.is_meta or record.is_summary else node.role
                blocks = (
                    [Text(text=node.content)]
                    if isinstance(node.content, str)
                    else [
                        item(b) or Text(text=f"[Non-text content: {b.get('type')}]")
                        for b in node.content
                        if b.get("type") not in ("thinking", "encrypted_content")
                    ]
                )
            else:
                blocks = [node]
            for block in blocks:
                if isinstance(block, Text):
                    entries.append(Entry(ref=ref, role=role, text=block.text))
                elif isinstance(block, ToolCall):
                    body = (
                        block.arguments
                        if isinstance(block.arguments, str)
                        else json.dumps(block.arguments, ensure_ascii=False)
                    )
                    entries.append(
                        Entry(ref=ref, role=f"call {block.name} {block.call_id}", text=body)
                    )
                elif isinstance(block, ToolResult):
                    body, status = output(block.body)
                    if block.is_error:
                        status.append("is_error=true")
                    if record.exit_code is not None:
                        status.append(f"exit_code={record.exit_code}")
                    entries.append(
                        Entry(
                            ref=ref,
                            role=f"result {block.call_id}",
                            text=body,
                            status=" | ".join(status),
                        )
                    )
        except ValidationError as error:
            raise ValueError(f"{path}:{line}: {error}") from error
    return entries


def conversation(entries: list[Entry]) -> None:
    instructions: dict[str, tuple[str, str]] = {}
    for entry in entries:
        if entry.role not in ("user", "assistant", "agent"):
            continue
        body = entry.text
        if entry.role == "user" and body.startswith("# AGENTS.md instructions"):
            heading = body.splitlines()[0]
            previous = instructions.get(heading)
            instructions[heading] = (entry.ref, body)
            if previous:
                old_ref, old = previous
                body = "".join(
                    difflib.unified_diff(
                        old.splitlines(True),
                        body.splitlines(True),
                        fromfile=old_ref,
                        tofile=entry.ref,
                        n=2,
                    )
                )
                body = body or f"Identical instructions to {old_ref}."
        print(f"## {entry.ref} {entry.role}\n\n{body}\n")


def index(entries: list[Entry]) -> None:
    for entry in entries:
        if entry.role not in ("user", "assistant", "agent", "system", "developer"):
            preview = " ".join(entry.text.split())[:100]
            print(f"{entry.ref}\t{entry.role}\t{entry.status}\t{preview}")


def users(entries: list[Entry], files: dict[str, str]) -> None:
    messages: dict[str, list[str]] = {}
    for entry in entries:
        if entry.role == "user":
            messages.setdefault(entry.ref, []).append(entry.text)
    print(
        json.dumps(
            {
                "files": files,
                "messages": [
                    {"ref": ref, "preview": " ".join("\n".join(blocks).split())[:100]}
                    for ref, blocks in messages.items()
                ],
            },
            ensure_ascii=False,
            indent=2,
        )
    )


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("provider", choices=("codex", "claude"))
    parser.add_argument("files", nargs="+", type=Path)
    parser.add_argument("--format", choices=("conversation", "index", "users"), required=True)
    args = parser.parse_args()
    entries = []
    try:
        files = {
            f"file{number}": str(path)
            for number, path in enumerate(dict.fromkeys(p.resolve() for p in args.files), 1)
        }
        for label, path in files.items():
            if args.format != "users":
                print(f"# {label}: {path}\n")
            entries.extend(read_file(Path(path), args.provider, file_label=label))
        if args.format == "users":
            users(entries, files)
        else:
            {"conversation": conversation, "index": index}[args.format](entries)
        if args.format != "users":
            print(f"# User messages: {len({e.ref for e in entries if e.role == 'user'})}")
    except (OSError, ValueError) as error:
        parser.exit(2, f"{error}\n")


if __name__ == "__main__":
    main()
