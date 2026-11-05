## Machine-specific guidance

Before starting work, read @~/.agents/AGENTS.local.md if it exists and treat it
as additional machine-specific guidance.

## Working Style

- Ask questions that need my answer through the question UI and restate them in
  the chat reply, since the dialog can hide context.
- Treat my questions as questions, not implicit criticism. I often ask to
  understand how something works, and changing things in response makes it
  impossible to converge on a shared understanding. Answer so I can weigh the
  tradeoffs before implementation that the discussion may overturn; act directly
  only on clear improvements, and when unsure, answer and wait.
- Use Markdown for presentation when useful: bullets, tables, and other
  structure are all welcome.
- Write math as LaTeX where it renders (e.g. Markdown docs, matplotlib labels)
  and as Unicode/plain text elsewhere, including chat (the terminal does not
  render LaTeX) and, preferably, code comments.
- Show concrete, reviewable changes as soon as they exist (with checks passed
  and pending) so I can give steering guidance quickly.
  - Distinguish iterative work from final verification. Most turns are
    iterations; they do not each require another expensive final verification
    pass.
- Requirements are cumulative unless I explicitly change them. Satisfy the full
  set before declaring completion.
- Apply my corrections to every analogous place (siblings, tests, docs, commit
  messages), not just the instance I pointed at.
- Never communicate externally through my identity or accounts. Operational
  actions are permitted; communicating as me is not.
  - Do not push, pull, or fetch version-control remotes unless explicitly asked:
    pushing publishes as me, and pulling or fetching moves the base I am
    reasoning about. This does not restrict ordinary downloads.
- Put scratch data in a uniquely named temporary directory, so concurrent agents
  do not collide and the repository stays clean.
- Avoid introducing new jargon or shorthand unless I introduced the term first
  or it already exists in the codebase/context.
  - New vocabulary adds work before I can assess the idea.
- Summarize results succinctly in chat and keep temporary findings in brief
  scratch notes. I rarely read detailed reports, so write one only when I ask
  for it.

## Coding workflow

### Task tracking

Maintain a small Markdown task ledger outside of the repository. Display the
absolute path upon creation. Use these sections:

```markdown
# Active

- Requested work or necessary dependency

# Proposed

- Unapproved idea, surfaced to me at the end of the turn

# Inactive

- (Completed/Blocked/Deferred/Cancelled) Task
```

The ledger lets me steer mid-task without earlier requests being forgotten or
the work ending early, and shows me what is finished versus still in progress.
It controls execution:

1. Rebuild the ledger only when starting an independent task. Otherwise keep the
   same ledger and its unfinished work, including across interruptions and
   compaction, and preserve its path in context handoffs.
2. Keep the ledger updated whenever scope or status changes. As a rule of thumb,
   first insert new steering into the task list in priority order, then act on
   it. Reconcile before switching tasks.
3. Update entries in place under one Active, Proposed, and Inactive section. Do
   not append other sections or narrative history.
4. Before handoff, reconcile the ledger and report every task’s status,
   highlighting pending proposals, blocked tasks, and pending checks. You should
   have no active tasks. Defer a task only when I deferred it or it waits on my
   answer, never to end early.

### Verification

- Time matters here: do not spend time that can be avoided, and the earlier a
  correct result is obtained, the better.
  - Reuse passing checks while the relevant code and dependencies remain
    unchanged. History or message rewrites alone do not invalidate results.
- Lints, formatting, and type-checking are often "cheap enough" that they can
  run on the entire repo. Tests OTOH are often expensive and you should only run
  the plausbily impacted tests instead of the full CI suite.

## Coding Preferences

### Commits and version control

- Prefer jujutsu (`jj`) in repositories configured for it; otherwise use Git.
  - Report change IDs, which survive rewrites. Include git hashes only when
    needed for external systems or to identify an exact reviewed snapshot.
  - Preserve change IDs when rewriting, but prioritize a coherent stack: split,
    fold, or abandon commits as needed. Do not duplicate commits.
  - `jj` history edits are recoverable through the oplog; never ask for approval
    before running them.
- Structure commits so I can review and merge work incrementally:
  - Every prefix of the stack should be mergeable. No commit should need a later
    commit to work. Each prefix should build and pass its relevant tests.
  - Use parallel branches or bookmarks for work I want reviewed and merged
    independently. Each may group multiple commits, including logically
    independent changes, in one PR: GitHub PRs have significant overhead, so
    logical independence alone does not require separate PRs. If C depends on
    branches A and B, start A and B from their common base, join them with a
    merge commit, and put C on top of that merge.
  - Ideally, factor out the easiest/simplest commits first so they can merge
    early while we go back and forth on the more complicated parts of the diff.
- As a rough rule of thumb, each commit should be entirely mechanical (e.g. a
  codemod or moving code without edits) or under 400 changed lines. Many
  exceptions are valid; judge coherence and reviewability.
- Write commit messages in Markdown, matching my existing commit style.
  - Lead with the purpose/motivation. Explain the idea and avoid cataloguing
    edits or work history.

### Design

- Functions and classes are for _abstraction_, not _reuse_. Duplication is
  preferred to muddled or unclear abstraction boundaries.
- Prefer the simplest straight-line implementation. Use the ladder inline code →
  function → class → protocol, moving up only when the new unit owns an
  independent decision, invariant, or contract.
- Prefer fixes in the abstraction that owns the behavior. If a workaround
  crosses that boundary, explain the constraint that makes it necessary.
- Always evolve existing code instead of rewriting from scratch. Existing code
  often contains many implicit properties we want to preserve (e.g. style,
  documentation, implicit contracts, etc).
  - In explicit redesign tasks, justify the final state from first principles
    rather than the previous design, and drop legacy behavior unless asked to
    keep it. Still get there incrementally (no "big bang rewrites").

### Coding Style

- Assume valid inputs in internal APIs and let operations fail naturally. Check
  inputs only where an error would surface far from its cause or results would
  be silently wrong.
- Prefer keyword-only parameters when type checking cannot catch argument-order
  mistakes.
- When the same data travels across several interfaces, consider a typed
  container for it to reduce plumbing.
- Pull ifs up and fors down: centralize control flow in callers and let callees
  operate on whole batches.
  - This keeps execution visible and lets each callee choose an efficient batch
    implementation.

### Documentation

- Write documentation and commit messages for future readers who lack the
  context of the current task.
- More documentation is not better, since it drains attention and requires
  upkeep.
  - Preserve durable knowledge that readers cannot readily recover from the
    code.
- Choose placement and depth from the document's purpose. Avoid duplication
  between documentation sources.
  - API contracts belong near their definitions; detailed explanations belong
    where readers need that detail.

### Testing preferences

The overall goal is to have a small and mostly orthogonal test suite. Hold test
code to the same design and readability bar as product code; in particular,
helpers and fixtures should make new cases easy to add.

- Bias towards end-to-end tests rather than component-level tests: they check
  behavior users rely on and survive refactoring. Component tests are justified
  for independently checkable compositional properties or failures that are
  difficult to diagnose in the end-to-end test.
  - Test through public interfaces. Mocks and monkeypatches couple tests to the
    implementation, so exceptions should be rare and specifically justified.
- Test behavior at the layer that owns it. Callers should test their own
  behavior rather than re-test guarantees provided below them.
- Prefer data-driven parameterized tests (`pytest.mark.parametrize` in Python)
  or property-based testing (via `hypothesis` in Python) over independent test
  functions, so a new case costs a line rather than a test.
  - Properties should have simple, independent oracles. For example:
    round-trips, metamorphic relationships, invariants, inverses, idempotence,
    and comparison with a simple reference implementation.
  - Bias towards strengthening existing tests with better properties or
    additional parameterized cases before adding new tests. If this is
    impossible, the test suite may be poorly designed.
- Avoid test-driven ossification where refactoring an API requires completely
  rewriting the tests.
