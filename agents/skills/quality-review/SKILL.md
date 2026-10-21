---
name: quality-audit
description: Use only when the user explicitly requests a quality audit, simplicity pass, test audit, or pre-merge quality review. Perform one bounded audit and act on its findings. This is not a security-review skill.
---

# Quality audit

Read the change with skeptical, independent eyes. Do not assume the code works,
but do not manufacture findings or infer defects from missing context. Keep the
review focused on maintainability and change quality; do not present it as a
security audit.

## Scope

Resolve the scope once, in the parent, before launching anything. Default to the
whole local stack relative to the repository's configured trunk; if the user
names commits, files, or a bookmark, review only those. If the user names a base
and a target, review exactly that range. Do not fetch merely to choose a base.

For jj, export one file containing every commit's patch. Substitute the selected
base and target for `trunk()` and `@` when the user specifies them.

```bash
audit_dir=$(mktemp -d "${TMPDIR:-/tmp}/jj-audit.XXXXXX")
audit_base=$(jj --ignore-working-copy log -r 'trunk()' --no-graph -T 'commit_id')
audit_tip=$(jj --ignore-working-copy log -r '@' --no-graph -T 'commit_id')
jj --ignore-working-copy --color=never --no-pager log -r "$audit_base..$audit_tip" \
  --reversed --no-graph --patch --git \
  -T 'change_id.short() ++ " " ++ commit_id ++ " " ++ description.first_line() ++ "\n"' \
  > "$audit_dir/stack.patch"
jj --ignore-working-copy log -r "$audit_base..$audit_tip" --no-graph --name-only -T '' \
  | sort -u > "$audit_dir/files.txt"
```

Assign files from `files.txt`, including paths absent from the final diff. Give
reviewers `stack.patch`; inspect assigned hunks in each commit against its parent,
including intermediate changes absent from the aggregate diff.

For Git, resolve the selected base and target to commit hashes and create a
unique temporary audit directory. Export `git log --reverse -p <base>..<target>`
to `stack.patch` and `git log --format= --name-only <base>..<target> | sort -u`
to `files.txt`. Split the paths into test files and everything else, and pass the
pinned scope and assigned files to each reviewer.

## Run the review

Launch three `code-reviewer` subagents concurrently, each with the scope, its own
file list, and its own questions. Do not seed a reviewer with your summary or
conclusions.

1. **Code quality** — simplicity and documentation, over the non-test files.
2. **Tests** — changed tests and the relevant production changes: whether the
   tests add useful confidence and diagnosis at proportionate complexity.
   Require this subagent to read [the user's testing philosophy](references/test-review.md).
   Consider deletion, simplification, consolidation, and property tests where
   useful. A clean review need not propose any test changes.
3. **Organization** — over the commit list and the paths, not the hunks.

Require each reviewer to examine every assigned file and dimension. Do not
stop after finding a few easy improvements. Identify any unreviewed scope.

The reviewer is read-only and reports findings rather than editing. If a
dimension genuinely requires code execution, run it in the parent session and
use the result when deciding what to change.

### 1. Simplicity

- Explicitly requested generality is a requirement. Do not recommend narrowing
  it as a simplification.
- Does each new abstraction express a real contract or extension point?
  - Some abstractions are deliberate hooks for future work. Having one current
    implementation is evidence to examine, not a reason by itself to remove the
    abstraction.
  - Use the ladder inline code → function → class → protocol.
  - Prefer duplicating two or three lines to a helper that only removes that
    duplication.
- Trace new call boundaries. Flag forwarding-only layers, branch-selected algorithms,
  and repeated computation.
- For simplification tasks, distinguish documentation growth from code growth and
  identify the complexity removed before reporting a clean review.
- Is anything clever where straight-line code would work?
  - Is the code more complicated than the problem? Can it be shorter?
  - Are there footguns that a better API would prevent?

### 2. Documentation

- Keep a comment only if it helps a reader returning in two months without this
  conversation. Flag comments that paraphrase the following line.
- Docstrings describe interfaces, not implementation, design history, or
  alternatives considered. Use no docstring for self-evident functions, a
  one-liner when that suffices, and Google-style `Args`, `Returns`, and `Raises`
  when the interface needs more detail.
- Tests need no comment or docstring that repeats a descriptive name.

### 3. Tests

- Apply the same simplicity standards to tests. Tests document behavior and
  catch regressions; focus on key behaviors, not coverage totals.
- Apply the [testing philosophy](references/test-review.md) before proposing
  additions. Missing isolated coverage is not itself a finding.
- Check for slow, elaborate unit tests where a cheap end-to-end smoke test would
  provide more value.
- Treat a large collection of narrow unit tests as a warning sign. If many cases
  exercise the same contract and differ only in inputs and expected outputs,
  propose one compact `pytest.mark.parametrize` table. Keep separate tests when
  they isolate distinct failure modes or improve diagnosis.
- For complicated behavior with a broad input space, look for a non-trivial
  property with a simple, independent oracle. Prefer a property-based test over
  enumerating examples when such a property exists; otherwise keep the smallest
  useful set of examples or a smoke test.

### 4. Organization

Two questions: where the code lives, and whether the stack is mergeable one
commit at a time.

**Placement** belongs to this skill:

- Does the code live at the correct scope? Move durable shared work out of
  temporary or experiment-only locations; keep experiment-specific work out of
  shared library code.
- Is each file in the package it belongs to, or next to whatever needed it
  first?

**Commit structure** is exactly the `restack` bar. Point the reviewer at the
sibling skill's [`SKILL.md`](../restack/SKILL.md) and have it audit the stack
against sections 2-4: reshape, messages, and task artifacts.

Review every commit message against AGENTS.md from a future reader's
perspective. Make the problem, justification, and supporting evidence clear.
Resolve gaps through rewriting or additional verification, as appropriate.

## Act on findings

Unless asked otherwise, act on the findings.

Resolve every finding: fix it, reject it with a reason, or explicitly identify
it as unresolved.

- Treat a finding as evidence, not an order; state plainly which findings you reject and why.
- Fix findings that are obviously correct. If you are uncertain about the
  results, or if they trigger a major redesign, ask the user before proceeding.
- In a jj repository, fix commit-shape findings with the `restack` skill rather
  than hand-rolling the rewrite. In other repositories, use the native version
  control workflow. Fix placement findings first, then absorb them into the
  commit where they belong.

Keep the final response focused on consequential changes, unresolved findings,
unreviewed scope, and verification. Do not create a separate report unless asked.
Remove the task-owned audit directory when the user accepts the work or requests
cleanup.

## Handoff document

Only on request. Read [the handoff guidance](references/handoff.md) before
writing it.
