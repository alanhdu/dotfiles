---
name: debrief
description:
  Audit a session transcript or selected mistakes and recommend durable
  improvements to the codebase, tooling, and agent instructions. Use when the
  user asks for a debrief, retrospective, or what went wrong in a session.
---

# Debrief

Recommend durable improvements to both the harness and the codebase based on
your experiences and findings.

## 1. Audit before synthesis

1. Extract summaries of the transcript using `transcript.py` (same directory as 
   this file). Write them to the task's scratch directory, creating a temporary
   one if none exists (`$task_dir` below):

   ```sh
   python <skill-dir>/transcript.py <codex|claude> SESSION.jsonl CONTINUATION.jsonl --format=conversation > "$task_dir/conversation.md"
   python <skill-dir>/transcript.py <codex|claude> SESSION.jsonl CONTINUATION.jsonl --format=index > "$task_dir/index.tsv"
   ```

   Use Python 3.11+ with Pydantic 2 already installed (for example, a project’s
   `.venv/bin/python`), otherwise use `uv run` (which requires a writeable
   cache and network access on a cache miss).

   Read the saved files rather than printing the script's output directly, which
   can exceed the tool-call output limit.

   Outputs declare each source path once as `file1`, `file2`, etc., and cite
   original JSONL lines as `file1:1256`. Original logs are under
   `~/.codex/sessions/` for Codex and
   `~/.claude/projects/<cwd-slug>/<session-id>.jsonl` for Claude, with subagent
   transcripts and persisted tool outputs under `<session-id>/`.

2. Read the entire conversation output to recover the user's requests,
   corrections, and the assistant's decisions. Then read the entire index
   output to check tool calls and outcomes, including failures, retries, and
   rework that never surfaced in the conversation.

   Examine the full session: the most recent failure is the easiest to recall
   but rarely the only one worth addressing.

3. Inventory every correction and substantial friction. Give each an ID (C1,
   C2, …) and cite its source messages or tool results. Split multi-part or
   repeated corrections into separate IDs. Distinguish errors from changes the
   user authorized.
   For each, find the instruction that should have prevented it (skills,
   AGENTS files, system prompt) and say why it didn't: absent, ambiguous, or
   outweighed by another instruction (name it). Absent is rare.

## 2. Select recommendations

Based on the identified frictions and corrections, suggest changes to:

1. The codebase we are working on
   - This is also a chance to report on any proposals from your ledger
2. Missing tooling we could build
3. The user-controlled harness prompts, skills, and agent files. Agents apply
   these by reasoning about what the user wants, so the best fix supplies the
   missing reasoning rather than a rule for the observed case.
   - Fix the instruction responsible by editing its text, not by appending.
     Several patterns often share one cause and one fix.
   - Keep hard rules for what is always true. A rule that is right only in the
     session that prompted it actively misleads future sessions where it is
     wrong.
   - Keep these files small: every line costs tokens and attention in every
     session, and dilutes the instructions that matter.
   - Where the user had already said it clearly, add nothing and explain what
     overrode it. Ask the user if there is ambiguity instead of guessing.

## 3. Output

**Session audit:** Report every substantial pattern with its evidence, cause,
and disposition. Do not substitute a link to the report or a status question for
it.

**Recommendations:** Use **Harness**, **Tooling**, and **Codebase**
subsections, highest priority first. For each proposal give:

- **Addresses:** The audited patterns and the instruction responsible.
- **Change and where:** The concrete edit and inspected target; provide an exact
  diff for skills or agent instructions.
- **Why:** Expected benefit relative to ongoing cost.

If no changes are warranted, say “No changes recommended” and explain why. Still
provide the audit.
