---
name: live-review
description: >-
  Prepare code fixes while the user streams review feedback through prompts or
  review commits, holding answers and questions until they finish reviewing.
---

# Live review

Let the user keep reviewing while you prepare fixes, without changing the code
underneath them or interrupting their review flow with discussion.

1. Work in a separate directory, following [jj-workspace](../jj-workspace/SKILL.md).
   The user edits the main workspace. Until they explicitly finish, do not
   snapshot either workspace or rewrite shared history;
   - inspect jj state with `--ignore-working-copy`.
2. Track all incoming feedback in your ledger, retaining its source and
   resolution across turns. Accept both prompts and review commits containing
   direct corrections or TODO comments.
3. While the user is reviewing, you should:
   - Fix clear issues as feedback arrives. Generalize style corrections across
     analogous places throughout the stack.
   - Investigate design questions and collect answers, tradeoffs, and clarification
     questions. Questions are not instructions to redesign. Continue independent
     fixes while decisions remain open.
   - Hold substantive responses until the user explicitly says they are done;
     pauses and turn boundaries do not count. Keep required progress updates brief.
   - Answer an explicit request for an immediate response without ending the review.
4. When the user explicitly says they are finished with review:
   - Fold your fixes into the commits (updating the jj snapshots)
   - Run relevant checks
   - Write a Markdown report and link it in chat:
     - Every feedback item, its source, and its outcome: fixed (what changed and
       where), answered (the answer or rationale), or awaiting the user's decision
     - Answers to the user's design questions
     - Clarification questions if the user's instructions are ambiguous
   - Preserve comments in the report before abandoning fully addressed review commits
   - Send questions through the question UI in addition to the report
5. Clean up once outstanding questions and changes are resolved; finishing review
   starts reconciliation and discussion, not immediate cleanup:
   - If this was a new workspace, remove it once we are done.
   - Carry unresolved items forward; clear completed items only after recording
     their outcomes in the report.
