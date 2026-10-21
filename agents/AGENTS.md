## Machine-specific guidance


Before starting work, read `~/.agents/AGENTS.local.md` if it exists and treat it as additional
machine-specific guidance.

## Working Style

- Use Markdown for presentation when useful: bullets, tables, and other structure
  are all welcome.
- In chat, use Unicode/plain-text notation rather than raw LaTeX because the
  terminal does not render it. Use LaTeX when editing source files or when
  explicitly asked for a copy-paste snippet.
- Ask questions that need my answer through the question UI, not inside long prose.
- Show reviewable drafts or results as soon as possible while stating what remains
  unverified so I can respond with new directions without blocking on expensive
  verification. Redirect ongoing work if I provide feedback, but keep verifying
  if I do not.
- When I suggest changes, generalize the intent across the whole deliverable,
  including code, commits, and prose. Treat my edited prose as the template
  for structure, terminology, and level of detail. If feedback invalidates
  your approach, reconsider it before making another local repair.
- Never communicate externally through my identity or accounts. Operational actions
  are permitted; communicating as me is not.

### Task tracking

When working, maintain a small Markdown task ledger outside of the repository. Show me
the absolute path when creating this.

That task ledger should look like:

```markdown
# Active

* Task 1
* Task 2
* Task 3

# Inactive

* (Completed) Task 4
* (Blocked) Task 5
```

Each bullet should be a 1-2 sentence description of the task. The `Active` tasks should be
sorted in priority order. Add new requests to the list; apply implementation feedback to
existing tasks. Preserve earlier requests unless I explicitly cancel or replace them. Feel free to add
subtasks yourself.

Keep the same ledger across interruptions and compaction, preserving its path in context handoffs.
At the start of each turn, consult the ledger to see what should be worked on next.
Before finishing work, always check whether there are any outstanding tasks
left to do first. When reporting, report the status of all tasks (completed,
blocked, deferred, cancelled).

## Personal code preferences

- Do not push, unless explicitly asked to.
- Do not check or report remote state unless asked.
- Prefer the simplest straight-line implementation. Use the ladder inline code → function → class →
  protocol, moving up only for a real abstraction.
- Functions and classes are for *abstraction*, not *reuse*. Duplication is preferred to
  muddled or unclear abstraction boundaries.
  - Do not create helper functions just because they save a couple lines of code. Only create them
    if they represent a coherent boundary.
- Write comments, docstrings, and commit messages for *future* users without your context.
  - Be succinct. Future users want to know the important information quickly.
  - Do not restate the obvious or duplicate information in comments, docstrings, commit messages,
    names, and parameters.
  - Do not reference things that exist only in your context.
  - Write commit messages in Markdown, matching the user's existing commit style.
- Organize commits around coherent, independently reviewable ideas. Keep mechanical
  moves separate from behavioral changes when that makes review easier.
- Commit messages explain the problem, the idea connecting the changes, and why
  it helps. Avoid prose inventories of the diff.
  Retain useful benchmark evidence and material tradeoffs.
- Prefer jujutsu (`jj`) in repositories configured for it; otherwise use Git.
  - Report change IDs. Include git hashes only when needed for external systems.
  - Preserve change IDs when rewriting, but prioritize a coherent stack: split,
    fold, or abandon commits as needed. Do not duplicate commits.
  - `jj` history edits are recoverable through the oplog; never ask for approval before running them.
- Clean up only commits, workspaces, bookmarks, and temporary files created in the current task. Ask
  before removing pre-existing artifacts.
- Assume valid inputs in internal typed APIs; let operations fail naturally.
- Prefer keyword-only parameters when type checking cannot catch argument-order mistakes.
  If the same data travels across interfaces, consider a TypedDict, dataclass, named tuple,
  or an owning class according to the semantics and ownership of that data.


## Testing preferences

- Prefer real behavior through public interfaces and a small, mostly orthogonal
  suite. Choose tests for the confidence and diagnostic value they add, not coverage.
- Use component tests for independently checkable compositional properties or
  difficult diagnosis. Avoid duplicating behavior that end-to-end tests already
  exercise and make easy to diagnose.
- No mocks by default; exceptions should be rare and specifically justified.
  Needing implementation internals suggests reconsidering the design or test boundary.
- Performance is a system property requiring deliberately engineered benchmarks;
  ad-hoc unit tests of proxies do not establish speed.
- Make simple examples data-driven with compact `pytest.mark.parametrize` tables.
- Use Hypothesis for nontrivial properties with simple, independent oracles:
  round-trips, metamorphic relationships, invariants, inverses, idempotence,
  and comparison with a simple reference implementation.
- Write high-quality test code with well-designed helpers and fixtures that
  make cases easy to add and resilient to API changes.

## Files and background work

- Put scratch data in a uniquely named temporary directory. Remove only scratch artifacts created
  during the current task.
- Do not leave background loops or detached work running unless requested.
