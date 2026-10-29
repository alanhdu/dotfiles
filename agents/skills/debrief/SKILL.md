---
name: debrief
description: Audit full sessions or selected mistakes and recommend durable improvements.
---

# Debrief

Audit first. Recommend changes; do not apply them.

## 1. Scope and reviewer

- **Full:** Entire session, including this debrief.
- **Targeted:** Selected mistakes, relevant instructions and consequences.

Use requested scope; otherwise ask through the question UI.
Full audits use a fresh subagent without inherited history (Codex:
`fork_turns="none"`; Claude Code: any agent type except `fork`). Pass this
skill, scope, unfiltered transcript and artifact paths;
exclude parent summaries, inventories, diagnoses and suggestions. The subagent
owns the audit and recommendations; relay all findings without filtering.
If unavailable, disclose it; do not substitute a parent audit.
Targeted audits may run in the parent.

## 2. Audit before synthesis

1. Read original messages/tool outcomes in scope; recover accessible history.
   Summaries/ledgers cannot substitute. State gaps. Raw transcripts are JSONL:
   Codex under `~/.codex/sessions/`; Claude Code at
   `~/.claude/projects/<cwd-slug>/<session-id>.jsonl`, with subagent
   transcripts and persisted tool outputs under `<session-id>/`.
2. Inventory every correction and substantial friction, including failures of
   this debrief. Give each an ID (C1, C2, …) and cite its source messages or
   tool results. Split multi-part or repeated corrections into separate IDs.
   Distinguish errors from changes the user authorized.
3. Check coverage: list every user message in scope with the IDs it raised, or
   why it raised none. Full audits cover the entire session. Verify the list
   against the transcript, programmatically where possible, before synthesizing.
4. Group the IDs by underlying cause. Cite evidence; explain failed protections,
   including ignored guidance. Distinguish observations from inferred causes and
   root fixes from repaired consequences.

## 3. Select recommendations

Recommend few changes to inspected, user-controlled targets.
Prefer mechanical fixes and net-neutral or smaller changes to code and prompts.
Rewrite, consolidate or delete before adding. Report net lines across affected
files, counting moved text. Justify growth only when smaller edits cannot retain
required behavior. Target the failed decision, not the incident's particulars;
check that the fix transfers to different tools and tasks. When existing guidance
already covers the failure, explain why it failed before proposing more wording.
Do not re-propose completed fixes.

## Output

**Session audit:** Report every substantial pattern with its evidence,
cause, and disposition. Do not substitute a link to the report or a status
question for it.

**Recommendations:** Use **Harness** and **Codebase** subsections, highest priority
first. For each proposal give:

- **Addresses:** The audited pattern.
- **Change and where:** The concrete edit and inspected target; provide an exact
  diff for skills or agent instructions.
- **Why:** Expected benefit relative to ongoing cost.

If no changes are warranted, say “No changes recommended” and explain why.
Still provide the audit.
