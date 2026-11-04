---
name: restack
description:
  In a jj repository, rebase and reshape a stack into atomic, independently
  mergeable commits with clear messages and no task artifacts. Use for "rebase
  onto trunk", "clean up the stack", "make the commits atomic", or after part of
  a stack has merged.
---

# Restack

Leave atomic, reviewable commits that can merge independently. Inspect the
workspace arrangement before rewriting; do not assume Git colocation or
workspace names. Preserve workspaces the user identified as protected.

## 1. Rebase

Unless otherwise prompted, rebase onto `trunk()`.

```text
jj rebase -d 'trunk()' -s <root-of-stack>
```

Run `jj log -r 'conflicts()'` repository-wide. Classify every result as
task-related or unrelated; resolve every task-related conflict and report
unrelated conflicts without modifying them.

Re-read the diff afterward because a clean rebase is not proof of correct
behavior.

## 2. Reshape the stack

Examine the existing commit stack and design a better commit structure. Present
the proposed stack in order. For each commit, list its responsibility, exact
files or hunks, and focused verification. Explicitly identify every commit that
will be split, folded, reordered, or abandoned. Then carry it out without
waiting.

- Order independent changes before their dependents. Put purely mechanical moves
  and renames before the commits that use them: they can merge without reviewers
  understanding the full refactor. Split commits with multiple responsibilities,
  and fold fixups into the commit they correct with
  `jj squash --from <fixup> --into <parent> --use-destination-message`.
- Each commit should build and pass its relevant tests on its own; step 5 says
  how much of that to verify.
- Apply every edit before resolving conflicts: put the changes in one commit on
  top of the stack and `jj absorb` it, or edit the target commits in sequence
  without testing in between. Then resolve each conflicted descendant once,
  bottom-up.

## 3. Rewrite messages

Follow AGENTS.md's commit-message guidance and wrap paragraphs.

```text
jj describe -r <commit> --stdin <<'EOF'
<message>
EOF
```

## 4. Clean up task artifacts

- Fold or abandon task-scoped review-fix commits after incorporating them.
- Abandon task-scoped experiment commits that were rejected.
- Forget temporary workspaces and delete bookmarks this task created and no
  longer needs. Unrelated stale state visible in `jj log` or `jj workspace list`
  is not yours to clean.

## 5. Verify

After completing edits and conflict resolution, verify as AGENTS.md describes.
Check intermediate commits for specific risks introduced by moving code, rather
than automatically repeating test suites across the stack.

For checks that can use isolated checkouts, use
`jj run --ignore-changes -r '<selected-revisions>' -- <check-command>`, ensuring
imports and dependencies use each checkout.

After the final message rewrite, run any commit-message checks configured by the
repository or user environment and fix every reported problem.

Report the final stack one line per commit and list exactly what was abandoned
or removed.
