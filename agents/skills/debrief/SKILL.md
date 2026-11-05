---
name: debrief
description:
  Audit full sessions or selected mistakes and recommend durable improvements.
---

# Debrief

Recommend durable improvements to both the harness and the codebase based on
your experiences and findings.

## 1. Audit before synthesis

1. Extract summaries of the transcript using the `transcript.py`:

   ```sh
   python transcript.py <codex/claude> SESSION.jsonl CONTINUATION.jsonl --format=conversation > "$task_dir/conversation.md"
   python transcript.py <codex/claude> SESSION.jsonl CONTINUATION.jsonl --format=index > "$task_dir/index.tsv"
   ```

   Use Python 3.11+ with Pydantic 2 already installed (for example, a project’s
   `.venv/bin/python`), otherewise use `uv run` (which requires a writeable
   cache and network access on a cache miss).
   
   Save outputs beside the existing task scratch directory and inspect the saved
   outputs to avoid overflowing the tool-call output budget.

   Outputs declare each source path once as `file1`, `file2`, etc., and cite
   original JSONL lines as `file1:1256`. Original logs are under
   `~/.codex/sessions/` for Codex and
   `~/.claude/projects/<cwd-slug>/<session-id>.jsonl` for Claude, with subagent
   transcripts and persisted tool outputs under `<session-id>/`.

2. Read the entire conversation output to recover the user's requests,
   corrections, and the assistant's decisions. Then read the entire index
   output to check tool calls and outcomes, including failures, retries, and
   rework that never surfaced in the conversation. 
   
   Do NOT over index on the latest, most recent failure. We want to examine the
   full session.
   
3. Inventory every correction and substantial friction. Give each an ID (C1,
   C2, …) and cite its source messages or tool results. Split multi-part or
   repeated corrections into separate IDs. Distinguish errors from changes the
   user authorized.

## 2. Select recommendations

Based on the identified frictions and corrections, suggest changes to:

1. The codebase we are working on
   - This is also a chance to report on an proposals from your ledger
2. Missing tooling we could build
3. The user-controlled harness prompts, skills, and agent files.
   - We want to keep these files slim. Focus on clarifying ambiguities
     or reifying implicit context justifying the rules.

## 3. Output

**Session audit:** Report every substantial pattern with its evidence, cause,
and disposition. Do not substitute a link to the report or a status question for
it.

**Recommendations:** Use **Harness**, **Tooling**, and **Codebase**
subsections, highest priority first. For each proposal give:

- **Addresses:** The audited pattern.
- **Change and where:** The concrete edit and inspected target; provide an exact
  diff for skills or agent instructions.
- **Why:** Expected benefit relative to ongoing cost.

If no changes are warranted, say “No changes recommended” and explain why. Still
provide the audit.
