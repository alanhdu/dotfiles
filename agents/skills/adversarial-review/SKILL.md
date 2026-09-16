---
name: adversarial-review
description: Use independent subagents to audit a major diff or commit stack for simplicity, documentation, tests, and commit organization, then act on findings. Use for explicit adversarial reviews, simplicity passes, test audits, or pre-merge audits.
---

# Adversarial review

Read the change with skeptical, uncontaminated eyes: a reviewer who was not in the conversation and
is skeptical about the code. Do not trust the code works, but do not artificially nitpick it either.
Act as if it came from a well-intentioned but significantly less skilled engineer.

Adversarial reviews are expensive. Invoke this skill automatically only for major changes; an
explicit user request always applies.

## Scope

Resolve the scope once, in the parent, before launching anything. Default to the
whole local stack relative to the repository's configured trunk; if the user
names commits, files, or a bookmark, review only those. If the user names a base
and a target, review exactly that range. Do not fetch merely to choose a base.

```
jj log -r 'trunk()..@' --no-graph -T 'change_id.short() ++ " " ++ description.first_line() ++ "\n"'
jj diff -r 'trunk()..@' --stat
```

For Git, first resolve the repository's local default or upstream branch, then
use `git log --oneline <base>..HEAD` and `git diff --stat <base>...HEAD`. Split
the changed paths into test files and everything else. Pass the explicit commit
list and file list to each reviewer: reviewers that each re-derive the scope
disagree about it when the tree moves under them, and pay for the rediscovery.

## Run the review

Launch three `code-reviewer` subagents concurrently, each with the scope, its own
file list, and its own questions. Do not seed a reviewer with your summary or
conclusions.

1. **Code quality** — simplicity and documentation, over the non-test files.
2. **Tests** — over the test files.
3. **Organization** — over the commit list and the paths, not the hunks.

A reviewer holding two dimensions will stop at a couple of findings from each
unless told otherwise, so require it to cover every file it was given and to
report each dimension explicitly, including a one-line "clean".

The reviewer is read-only and reports findings rather than editing. If a
dimension genuinely requires code execution, run it in the parent session and
use the result when deciding what to change.

### 1. Simplicity

- Does each new abstraction express a real contract or extension point?
  - Some abstractions are deliberate hooks for future work. Having one current
    implementation is evidence to examine, not a reason by itself to remove the
    abstraction.
  - Use the ladder inline code → function → class → protocol.
  - Prefer duplicating two or three lines to a helper that only removes that
    duplication.
- Does each function do one thing? Does a module now know something outside its
  responsibility?
- Is anything clever where straight-line code would work?
  - Is the code more complicated than the problem? Can it be shorter?
  - Are there footguns that a better API would prevent?

### 2. Documentation

- Keep a comment only if it helps a reader returning in two months without this
  conversation.
- Docstrings describe interfaces, not implementation, design history, or
  alternatives considered.
- Use the following ladder for docstrings: no docstring (for very
  simple/self-evident functions) -> one-liner -> Google-style `Args`,
  `Returns`, and `Raises`.
  - Tests need neither comments nor docstrings that repeat a descriptive name.
    Only add docstrings that add meaningful information
- Flag comments that paraphrase the following line.

### 3. Tests

- Apply the same simplicity standards to tests.
- Tests are simultaneously documentation *and* regression catchers. The goal
  is not to exhaustively hit 100% coverage. The goal is to identify and document
  *key* properties of the code we care about.
- Make sure every test is capable of catching real bugs. Do not write tests
  just for padding. The goal is not 100% coverage.
  - Would this test be how you actually find out it broke? If a training run,
    a loss curve, or a smoke job tells you first and faster, do not propose the
    test.
  - Flag tests that just duplicate the implementation
  - Flag tests that could only fail if a third-party library broke.
  - Check for unnecessarily slow and elaborate unit tests where a cheap
    end-to-end smoke test would carry more value.
- Combine tests that share expensive setup or express one behavior when that
  improves readability.
- Use the ladder smoke test -> single test -> parameterized test -> property based test
  depending on the complexity of the code and the power of the property we want
  to test.

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

## Act on findings

Unless asked otherwise, act on the findings.

- Treat a finding as evidence, not an order; state plainly which findings you reject and why.
- Fix findings that are obviously correct. If you are uncertain about the results, or if they
  trigger a major redesign ask the user before proceeding.
- Fix commit-shape findings by invoking the `restack` skill, not by hand-rolling
  `jj squash`/`jj rebase`. Fix placement findings directly, then let `restack`
  absorb the move into the commit it belongs to.
- After structural changes, rerun the affected review dimensions. Stop when
  they are clean or only explicitly rejected findings remain.

## Report

Keep the report short: what changed, what was rejected and why, and whether the
review converged or stopped early.

## Handoff document

Only on request. The reader is an agent with none of this context, possibly
working on a different version of the code, who cannot ask a follow-up
question.

Write it outside the repository -- a unique temporary directory, or a path the
user names -- and hand back that path. A file written into a jj tree is
automatically snapshotted into the current commit; a review handoff has landed
in the middle of live work this way before.

Anchor everything so it survives a tree that has moved:

- Record the base the review ran against: bookmark, the explicit commit ID, and
  the exact diff-stat command and output. That is how the reader works out which
  findings still apply to their version.
- Locate each finding by file path and symbol name, plus the property that is
  wrong. Never by line number, hunk, or change id -- all three are stale on
  arrival.
- For each open finding, say what it assumes is true, so the reader can check
  that against their own tree before acting.

Contents, in this order:

- What the change sets out to do, in a few lines. The reader has not seen the
  conversation, the PR, or the ticket.
- What was already fixed, so they do not redo it.
- What was rejected and why, so they do not re-raise it.
- What is still open: the finding, the concrete change wanted, and how strongly
  you hold it.
- How to verify: the exact commands, and what a pass looks like.

Write it for a stranger. No reviewer numbering, no "as discussed", no reference
to this session or to which subagent found what.
