---
name: quality-audit
description:
  Audit code, a diff, or a commit stack for architecture, code quality, tests,
  and commit structure using independent fresh-context reviewers, then resolve
  their findings. Use only when the user explicitly asks for a quality audit;
  each request authorizes one audit. Not a security review.
---

# Quality audit

The parent coordinates independent appraisals against AGENTS.md and the review
explainers, then resolves findings. The purpose is to make the requested code
or change easier to trust, understand, review, and maintain—not to improve
everything encountered. Apply the principles in the
[reviewer contract](references/reviewer.md) when choosing and implementing
remedies. A review with no findings is a valid result.

Audits are expensive and interrupt the user with findings, so each request
authorizes exactly one. Do not start an audit on your own initiative or repeat
one after applying fixes; propose a follow-up audit instead.

## Scope

Honor the requested code and review dimensions. Distinguish:

- **Existing code:** review the named files, package, or subsystem as it stands,
  including relevant tests. Inventory the whole requested scope; do not reduce
  the audit to recent changes or require a commit range.
- **A diff:** review the specified change against its base, with surrounding
  code.
- **A stack:** review ordered commits and messages, each parent-relative patch,
  and the resulting code. Include paths and intermediate changes absent from the
  aggregate diff.

For an unspecified change review, default to the local stack relative to the
configured trunk, including pending working-copy changes. Resolve revisions
locally; do not fetch for an audit. In Git, capture relevant staged, unstaged,
and untracked changes; in jj, snapshot pending changes before pinning revisions.

Assign reviewers repository paths, commits, or commit ranges. Pin revisions
to exact commit IDs so history edits cannot silently change the assignment.
Reviewers inspect the repository directly; export patches only when they
cannot access the relevant repository state.

## Select reviewers and order the work

Choose only the requested lenses. A full audit covers the applicable lenses
below; a tests-only request needs only tests. Each reviewer reads the shared
[reviewer contract](references/reviewer.md) and only its assigned explainers.

| Lens           | Focus                                                                | Explainer                                                    |
| -------------- | -------------------------------------------------------------------- | ------------------------------------------------------------ |
| `architecture` | Responsibilities, layering, state ownership, and module placement    | [architecture](references/architecture.md)                   |
| `code-quality` | Implementation, APIs, comments, and docstrings                       | [code quality and documentation](references/code-quality.md) |
| `tests`        | Plausible missed bugs and a simpler, more orthogonal suite           | [test review](references/test-review.md)                     |
| `commits`      | Incremental review and merging; useful, correctly formatted messages | [commits](references/commits.md)                             |

Include commits for existing code only when history is requested. Combine lenses
for small scopes or split large scopes by component or commit group, preserving
a view across boundaries. Architecture needs a distinct appraisal of the whole
affected path.

Order reviews by what could invalidate later work:

1. **Architecture first**, when included. Do not polish code likely to be
   replaced after correcting its responsibilities or boundaries.
2. **Code quality and tests** can run in parallel after any architecture
   appraisal. Defer only work that an unresolved architectural decision would
   invalidate; optional possibilities depending on future plans do not block it.
3. **Commit review** examines the final stack after accepted code changes. It
   need not wait for an unrelated component when its own scope is already
   stable.

Wait for reviewers sharing the same code to finish before editing it, or give
them isolated snapshots. Parallel appraisals must not observe each other's
fixes.

At an architectural finding, link the original report. Apply an obvious fix
within scope, then record the resulting revisions in the assignments for
subsequent code-quality and test reviewers. If there are multiple plausible
designs with meaningful tradeoffs, present the motivation and options and ask
for direction before edits or reviews of code that depends on that choice.
Review is interactive: the user need not specify all intentions in advance, and
the codebase cannot establish them all. As questions about upcoming capabilities
or acceptable constraints emerge, discuss the concrete alternatives and their
costs with the user. Continue unaffected work while resolving them. Do not
re-review settled stages merely because a later stage ran.

## Dispatch: three decisions only

Independent judgment requires shared intent. Give reviewers the user's relevant
goals, constraints, and settled decisions, including the purpose of milestones
in a stack. Preserve that context through the user's own words while withholding
the implementer's preferred conclusions. For reviewer dispatch, the parent may
decide **only**:

1. Which reviewers and lenses to launch.
2. Which repository paths, commits, or ranges each reviewer examines.
3. Which exact quotes from the user each reviewer receives.

The parent must not author review questions, emphasis, summaries, rationales,
hypotheses, acceptance criteria, expected findings, suggested fixes, or claims
about passing checks. Do not put that material in assignments or task names.

Launch fresh-context subagents that do not edit the shared code (Codex:
`fork_turns="none"`; Claude Code: the `code-reviewer` agent type). Use a
general-purpose role if a specialized role conflicts with this contract. If
independent delegation is unavailable, disclose that limitation.

Use this fixed dispatch envelope, substituting only the data fields and
`{skill_dir}`, the absolute path of the directory containing this file:

```text
Read {skill_dir}/references/reviewer.md and review this assignment:
{"lenses": [...], "scope": [...], "user_quotes": [...]}
```

In `scope`, use absolute repository paths or exact commit IDs and ranges;
include the repository path for revision assignments. Directory assignments
cover the complete requested inventory. Exported patches may be assigned when
repository state is inaccessible. Quotes are
verbatim, with qualifications and corrections preserved; use an empty list when
none apply. Do not paraphrase or select excerpts that reverse the user's
meaning. Never assign review reports, or a directory containing them or the
parent's scratch notes. Every follow-up is subject to the same restrictions.

## Resolve findings and expose reports

Save each dispatched assignment and each complete original response as Markdown
under `reports/` in the audit directory. Link every reviewer report when it
becomes available and again at handoff, including clean reviews and findings the
parent rejects. The user checks the parent's dispositions against them, so do
not replace, edit, or truncate reports to fit the parent's summary. Retain them
for follow-up; copying them into chat is unnecessary.

Before accepting a report, reconcile its coverage list against the assigned
paths and commits. Send back a report that skipped part of the scope.

Give every finding a disposition: fixed, rejected with a reason, or unresolved.
Before implementing a recommendation, independently check both the problem and
the proposed remedy against the user's goal, constraints, and applicable
standards. A valid problem can have a bad proposed fix: reject that fix without
dismissing the problem.

Report consequential changes, open decisions, unreviewed scope, independence
limitations, verification, and all report links. For a requested handoff
document, use [the handoff guidance](references/handoff.md).
