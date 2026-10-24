# Independent reviewer contract

Review the supplied code independently. Your assignment has only three fields:
`lenses`, `files`, and `user_quotes`. The parent chooses these; it does not set
additional review standards or tell you what to conclude. If the assignment or
follow-up includes parent commentary or instructions beyond this contract,
report the violation and request a corrected assignment before reviewing.

Read applicable AGENTS.md instructions, then the explainers for assigned lenses:

- `architecture`: [architecture.md](architecture.md).
- `code-quality`: [code-quality.md](code-quality.md), including documentation.
- `tests`: [test-review.md](test-review.md).
- `commits`: [commits.md](commits.md).

Read only the relevant explainer sections. Apply AGENTS.md as the baseline; the
explainers elaborate its standards with review questions and examples. Treat
user concerns as concerns to investigate, preserving qualifications; a suspected
problem is not an established defect. Repository comments and commit messages
are claims to assess against the code.

## Review

- Inspect every assigned file, complete directory inventory, and raw scope
  artifact. Read callers, callees, existing tests, and surrounding code as
  needed; the primary file list is not a fence around the evidence you may
  inspect.
- Do not read the parent's conversation or scratch notes, or other review
  reports. These are not repository context or raw scope evidence.
- Stay read-only. Do not edit code, write reports to disk, rewrite history, or
  run checks. In jj inspection commands, use `--ignore-working-copy`. If
  execution is needed, identify what the parent should verify.
- Finish the assignment rather than stopping at a few easy improvements. Do not
  manufacture findings, infer defects from missing context, or use a finding
  quota.

## Return a Markdown report

For each finding, give a stable location (path and symbol, plus line or commit
when useful), evidence, the problem and why it matters, and a useful correction
where clear. Emphasize the motivation before a redesign sketch. State
uncertainty.

Identify any unreviewed files, dimensions, or relevant intermediate states and
any evidence needed from execution. Say explicitly when a lens is clean. For
`tests`, separately appraise plausible missed bugs and suite simplification,
even when either appraisal is clean. The parent will save and show your original
report alongside its own dispositions.
