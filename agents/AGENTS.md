## Machine-specific guidance

Before starting work, read @~/.agents/AGENTS.local.md if it exists and treat it
as additional machine-specific guidance.

## Working Style

- Start a reply with its content, not with agreement or reassurance. No sycophancy
- Ask questions that need my answer through the question UI and restate them in
  the chat reply, since the dialog can hide context. Include enough detail that
  I can answer without scrolling through earlier responses or investigating
  myself.
- Distinguish exploratory questions from corrective feedback using the
  conversation context, not sentence structure alone.
  - When I am exploring or trying to understand a design, answer before changing it.
    Pause dependent work while a genuine design decision remains unresolved, and
    continue independent work.
    "Why is X here?" carries an implicit direction: if there is a reason I want
    to hear it, and if there is none, fix X. It is not a blanket request to
    change X.
  - During an implementation task, corrective feedback is direction to act, even
    when phrased as a question: "Shouldn't this be one table?" or "Why isn't this
    using the existing helper?" Apply a clear correction, verify it, and show the
    result. Do not stop at agreeing or explaining what you would change.
- I do not want to micromanage, but I do want a say in high-level design.
  Decide implementation details yourself and tell me what you chose. Ask about
  choices that shape an interface, a data model, or the structure of the work,
  or that are expensive to reverse; when unsure which kind a choice is, pick an
  option, continue, and show the alternatives.
  - Ask for clarification when materially different interpretations remain and
    the conversation does not resolve them. Never fill a gap by inventing a
    requirement, constraint, or value: look it up or ask.
- Write math as LaTeX where it renders (e.g. Markdown docs, matplotlib labels)
  and as Unicode/plain text elsewhere, including chat (the terminal does not
  render LaTeX) and, preferably, code comments.
- Show concrete, reviewable changes as soon as they exist (with checks passed
  and pending) so I can give steering guidance quickly.
  - Distinguish iterative work from final verification. Most turns are
    iterations; they do not each require another expensive final verification
    pass.
  - Show a first draft's diff as soon as the fast checks (lint, type check)
    pass. Run slow verification (broad test runs, equivalence harnesses) only
    after I have seen the shape.
- Requests and requirements are cumulative: new steering adds to them unless I
  explicitly change one. Satisfy the full set before declaring completion.
- Apply my corrections to every analogous place (siblings, tests, docs, commit
  messages), not just the instance I pointed at.
- Stay within the request: list unrequested features, tests, tooling, and
  cleanups as proposals instead of doing them.
- Never communicate externally through my identity or accounts. Operational
  actions are permitted; communicating as me is not.
  - Do not push, pull, or fetch version-control remotes unless explicitly asked:
    pushing publishes as me, and pulling or fetching moves the base I am
    reasoning about. This does not restrict ordinary downloads.
- No hidden dependencies: adding a dependency or installing a new tool requires
  my explicit approval. A new dependency can be the right call, so propose it
  with what it buys us instead of working around its absence.
  - Installing or syncing a project's existing, trusted dependencies (for example,
    `uv sync`) is allowed without separate approval.
  - For new tools, prefer giving me installation commands to run myself.
  - This includes temporary installations and automatic downloads by installers.
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

My prompts often contain several requests, and I steer while work is in
progress. Before ending a turn, check every request made since the task began,
not only my latest message: each should be done, or reported as blocked or
waiting on my answer.

Once a task has more than a couple of parts, or I steer it mid-task, track this
in a small Markdown task ledger outside of the repository. Single questions and
one-step changes do not need one. Display the absolute path upon creation. Use
these sections:

```markdown
# Active

- Requested work or necessary dependency

# Proposed

- Unapproved idea, surfaced to me at the end of the turn

# Inactive

- (Completed/Blocked/Deferred/Cancelled) Task
```

The ledger survives compaction and shows me what is finished versus still in
progress:

1. Rebuild the ledger only when starting an independent task. Otherwise keep the
   same ledger and its unfinished work, including across interruptions and
   compaction, and preserve its path in context handoffs.
2. Keep the ledger updated whenever scope or status changes. Insert new steering
   into the task list in priority order before acting on it.
3. Update entries in place under one Active, Proposed, and Inactive section. Do
   not append other sections or narrative history.
4. Before handoff, reconcile the ledger and report every task’s status,
   highlighting pending proposals, blocked tasks, and pending checks. Nothing
   should remain active: defer a task only when I deferred it or it waits on my
   answer.

### Verification

- Time matters here: do not spend time that can be avoided, and the earlier a
  correct result is obtained, the better.
  - Reuse passing checks while the relevant code and dependencies remain
    unchanged. History or message rewrites alone do not invalidate results.
- Lints, formatting, and type-checking are often "cheap enough" that they can
  run on the entire repo and on every commit of a stack. Tests OTOH are often
  expensive: run only the plausibly impacted tests instead of the full CI
  suite, and once at the end of a stack rather than on every commit.

## Coding Preferences

### Commits and version control

- Prefer jujutsu (`jj`) in repositories configured for it; otherwise use Git.
  - Report change IDs, which survive rewrites. Include git hashes only when
    needed for external systems or to identify an exact reviewed snapshot.
    Name commits by change ID, not by owner ("your commit"): agents often author
    commits on my bookmarks.
  - Preserve change IDs when rewriting, but prioritize a coherent stack: split,
    fold, or abandon commits as needed. Do not duplicate commits.
  - `jj` history edits are recoverable through the oplog; never ask for approval
    before running them.
- Structure commits so I can review and merge work incrementally:
  - Every prefix of the stack should be mergeable. No commit should need a later
    commit to work. Each prefix should build and pass its relevant tests.
  - Organize stacks at two levels:
    - jj bookmarks (roughly equivalent to Git branches) mark coherent
      milestones: each should deliver an understandable, usable capability.
      Each bookmark becomes one GitHub PR for external review, which has
      overhead; logical independence alone does not require another PR.
    - Commits are focused semantic steps within a milestone. I review commit
      by commit, so keep each individually reviewable and order them to build
      toward the milestone. Fewer bookmarks does not imply fewer commits.
  - Use parallel branches/bookmarks for milestones that can merge independently.
    If C depends on A and B, branch both from their common base, join them with
    a merge commit, and put C on top.
  - Ideally, factor out the easiest/simplest commits first so they can merge
    early while we go back and forth on the more complicated parts of the diff.
- Unbundle independent improvements into separate commits so each can be reviewed
  on its own. Separate mechanical moves from improvements: reviewers can skim
  a large mechanical diff for equivalence and scrutinize the improvements.
  Mixing them requires close correctness review of the entire diff.
  - As a rough rule of thumb, each commit should be entirely mechanical (e.g. a
    codemod or moving code without edits) or under 400 changed lines. Many
    exceptions are valid; judge coherence and reviewability.
- Write commit messages in Markdown, matching my existing commit style.
  - Lead with the purpose/motivation. Explain the idea and avoid cataloguing
    edits or work history.

### Design

- Question whether machinery needs to exist: eliminate accidental complexity
  before organizing it. Judge the simplicity of the whole operation by the
  concepts a reader must hold, not by line count.
- Functions and classes are for _abstraction_, not _reuse_: a new unit must mean
  something a reader understands without its callers. Duplication alone never
  justifies one; even then, share behavior only when changes should apply to
  every user.
- Prefer the simplest straight-line implementation. Use the ladder inline code →
  function → class → protocol, moving up only when the new unit owns an
  independent decision, invariant, or contract.
- Prefer fixes in the abstraction that owns the behavior. If a workaround
  crosses that boundary, explain the constraint that makes it necessary.
- Change existing code by editing it, never by rewriting it from scratch: a
  rewrite discards structure worth keeping (style, documentation, implicit
  contracts) and hides what actually changed.
  - Every change needs a reason. Large changes that have one are fine;
    renames, reformatting, and reshuffling without one bury the real change.
  - So does everything kept. Where code accreted instead of being designed,
    justify the final state from first principles, and keep backwards
    compatibility or legacy layers only for a reason. Still get there
    incrementally (no "big bang rewrites").

### Coding Style

- Assume valid inputs in internal APIs and let operations fail naturally. Check
  inputs only where an error would surface far from its cause or results would
  be silently wrong.
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
  for independently checkable compositional properties, failures that are
  difficult to diagnose in the end-to-end test, or test speed where end-to-end
  tests are slow.
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
