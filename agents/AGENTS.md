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
- Show concrete, reviewable changes as soon as they exist, with checks passed
  and pending. Do not withhold them while expensive verification runs.
  Incorporate steering as it arrives; stop work and checks it makes obsolete.
- When I suggest changes, generalize the intent across the whole deliverable,
  including code, commits, and prose. Treat my edited prose as the template
  for structure, terminology, and level of detail. If feedback invalidates
  your approach, reconsider it before making another local repair.
- Never communicate externally through my identity or accounts. Operational actions
  are permitted; communicating as me is not.

### Verification

- Always run configured cheap global checks, such as linting, formatting, and
  type checking, after code changes.
- Distinguish iterative work from final verification. Most turns are
  iterations; they do not each require another expensive final verification pass.
- Choose tests for behavior the change could plausibly affect. Prefer relevant
  test files or cases over broad suites containing unrelated tests.
- Expensive checks need a concrete risk worth investigating. Explain that risk,
  show the change first, and run checks in the background when useful.
- Reuse passing checks while the relevant code and dependencies remain unchanged.
  History or message rewrites alone do not invalidate results.

### Task tracking

Maintain a small Markdown task ledger outside of the repository. Dislayy the absolute path upon creation.
It should look like:

```markdown
# Active

* Task 1
* Task 2
* Task 3

# Proposed

* Idea awaiting approval

# Inactive

* (Completed) Task 4
* (Blocked) Task 5
```

The ledger controls execution:

1. Rebuild the ledger when starting an independent task.
   For follow-ups, reconcile the existing ledger and retain unfinished work.
   Keep it limited to the current task.
2. After every message (including interruptions and follow-usp), your first action is to read
   and reconcile the ledger. Add new requests and apply corrections before any
   other investigation, edits, or tool calls.
3. Update entries in place under one Active, Proposed, and Inactive section.
   Active contains requested work and necessary dependencies; unapproved
   ideas go in Proposed. Move completed, blocked, deferred, or cancelled work
   to Inactive. Do not append follow-up sections or narrative history.
4. Keep the same ledger across interruptions and compaction, preserving its path in context handoffs.
5. Before handoff, reconcile the ledger and report every task’s status,
   including proposals and pending checks. Surface proposals promptly during
   work and repeat them at handoff. Without approval, leave them unpursued
   and continue the requested work.

## Personal code preferences

- Do not push, unless explicitly asked to.
- Do not check or report remote state unless asked.
- Surface broader rethinks and opportunities, but get approval before
  pursuing work beyond the request.
- Prefer the simplest straight-line implementation. Use the ladder inline code → function → class →
  protocol, moving up only for a real abstraction.
- Functions and classes are for *abstraction*, not *reuse*. Duplication is preferred to
  muddled or unclear abstraction boundaries.
  - Do not create helper functions just because they save a couple lines of code. Only create them
    if they represent a coherent boundary.
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


## Documentation

Documentation is maintained product content. Its value comes from helping
future readers use or change the code; its cost is the attention and upkeep
it requires. Preserve durable knowledge that readers cannot readily recover
from the code. Session context and temporary findings belong in the
conversation or scratch space unless preserving them is itself a requested
deliverable.

Each document should serve a clear reader need. A README is a short front
door: orientation and a starting point. API contracts belong near their
definitions; detailed explanations belong where readers need that detail.
Choose placement and depth from the document's purpose, rather than treating
a README as somewhere to put everything worth saying.

Prefer the smallest explanation that preserves necessary understanding.
More documentation is not inherently better, and completing work does not
create an obligation to document it.

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
- Keep me informed about background work and consume and report its results
  when it finishes. If automatic follow-up is unavailable, show the current
  result and block on completion without repeated polling or unrelated work.
