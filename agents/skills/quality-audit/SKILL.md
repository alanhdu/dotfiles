---
name: quality-audit
description:
  Run only when explicitly triggered by the user. Each trigger authorizes
  exactly one audit. Never autonomously initiate or repeat an audit,
  including follow-up audits after fixes. Obtain independent appraisals and
  act on their findings. This is not a security-review skill.
---

# Quality audit

The parent coordinates independent appraisals against AGENTS.md and the review
explainers, then resolves findings. A review with no findings is a valid result.
Understand and critique the code to improve it, as in code review; do not spend
review time defending or rationalizing the existing implementation.

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

Keep a raw scope manifest and any patches under `scope/` in a unique temporary
audit directory, separate from assignments and reports. Record paths and
versions mechanically, without the parent's commentary. Give reviewers access to
this evidence and repository context, even when their file assignments differ.

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

At an architectural finding, show the original report. Apply an obvious fix
within scope, then update the raw scope and launch the requested code-quality
and test reviewers on the resulting code. If there are multiple plausible
designs with meaningful tradeoffs, present the motivation and options and ask
for direction before edits or reviews of code that depends on that choice.
Review is interactive: the user need not specify all intentions in advance, and
the codebase cannot establish them all. As questions about upcoming capabilities
or acceptable constraints emerge, discuss the concrete alternatives and their
costs with the user. Continue unaffected work while resolving them. Do not
re-review settled stages merely because a later stage ran.

## Dispatch: three decisions only

Any framing the parent adds anchors reviewers on the parent's view, which
defeats an independent appraisal. For reviewer dispatch, the parent may decide
**only**:

1. Which reviewers and lenses to launch.
2. Which files each reviewer examines, including raw scope artifacts.
3. Which exact quotes from the user each reviewer receives.

The parent must not author review questions, emphasis, summaries, rationales,
hypotheses, acceptance criteria, expected findings, suggested fixes, or claims
about passing checks. Do not put that material in scope files or task names.

Launch fresh-context subagents that do not edit the shared code (Codex:
`fork_turns="none"`; Claude Code: the `code-reviewer` agent type). Use a
general-purpose role if a specialized role conflicts with this contract. If
independent delegation is unavailable, disclose that limitation.

Use this fixed dispatch envelope, substituting only the path and data fields:

```text
Read {skill_dir}/references/reviewer.md and review this assignment:
{"lenses": [...], "files": [...], "user_quotes": [...]}
```

Use absolute file or directory paths, including raw manifests or patches when
needed. Directory assignments cover the complete requested inventory. Quotes are
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

Give every finding a disposition: fixed, rejected with a reason, or unresolved.
The parent may summarize and disagree, but its decisions remain separate from
the original reports. Keep the parent's investigations and checks distinct from
the reviewer's evidence. Unless asked for findings without edits, act on
accepted findings within scope, subject to the architectural decision above.
"Only" restricting files or lenses does not itself prohibit fixes within that
scope. Use the restack skill for accepted jj commit-shape fixes.

Verify changes under AGENTS.md, including configured cheap global checks. Report
consequential changes, open decisions, unreviewed scope, independence
limitations, verification, and all report links. For a requested handoff
document, use [the handoff guidance](references/handoff.md).
