# Review handoff

Write the handoff for an agent with none of this context, possibly working on a
different version of the code and unable to ask follow-up questions.

Write it outside the repository, in a unique temporary directory or a path the
user names, and return that path. This keeps the handoff out of the working tree
and any automatic snapshots.

Anchor the report so it survives a tree that has moved:

- Record the review base: bookmark or branch, full commit ID, and the exact
  diff-stat command and output.
- Locate each finding by file path and symbol name, plus the property that is
  wrong. Do not rely on line numbers, hunks, or change IDs.
- State what each open finding assumes so the reader can check whether it still
  applies.

Use this order:

1. What the change sets out to do. The reader has not seen the conversation,
   pull request, or ticket.
2. What was already fixed.
3. What was rejected and why.
4. What remains open: the finding, the concrete change wanted, and confidence.
5. How to verify: exact commands and what a pass looks like.

Do not use reviewer numbering, refer to prior discussion, or identify which
reviewer found an issue.
