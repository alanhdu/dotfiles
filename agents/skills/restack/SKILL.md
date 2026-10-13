---
name: restack
description: In a jj repository, rebase and reshape a stack into atomic, independently mergeable commits with clear messages and no task artifacts. Use for "rebase onto trunk", "clean up the stack", "make the commits atomic", or after part of a stack has merged.
---

# Restack

Leave a stack that can be merged one commit at a time. Each commit should be
a single atomic, reviewable unit.

This workflow is for jj repositories. Determine the working-copy arrangement
before rewriting anything. Do not assume jj is colocated with Git or that a
workspace has a particular name. Preserve any workspace the user has identified
as protected.

## 1. Rebase

Unless otherwise prompted, rebase onto `trunk()`. Do not fetch merely to update
the base; the repository's configured trunk is the intended target.

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
will be split, folded, reordered, or abandoned.

- Preserve jj change IDs; do not duplicate commits.
- Order independent changes before their dependents. Split commits with multiple
  responsibilities, and fold fixups into the commit they correct with
  `jj squash --from <fixup> --into <parent> --use-destination-message`.
- Each commit must be reviewable and pass its relevant build and tests on its own.
- Apply every edit before resolving conflicts: put the changes in one commit on
  top of the stack and `jj absorb` it, or edit the target commits in sequence
  without testing in between. Then resolve each conflicted descendant once,
  bottom-up, leaving commits that rename or move files for last.

## 3. Rewrite messages

Make each message succinct and useful to someone who did not see the work:
explain what changed and why, follow the repository's style, and wrap paragraphs.

```text
jj describe -r <commit>
```

## 4. Clean up task artifacts

- Fold or abandon task-scoped review-fix commits after incorporating them.
- Abandon task-scoped experiment commits that were rejected.
- Forget and remove temporary workspaces created during this task.
- Delete only task-created bookmarks that are no longer needed.

Do not clean unrelated stale state merely because it is visible in `jj log` or
`jj workspace list`.

## 5. Verify

Verify once, after every edit and conflict resolution: run the relevant suite at
the stack tip and every intermediate commit whose content moved during a
fold, split, or reorder.

For checks that can use isolated checkouts, use
`jj run --ignore-changes -r '<selected-revisions>' -- <check-command>`, ensuring
imports and dependencies use each checkout.

After the final message rewrite, run any commit-message checks configured by the
repository or user environment and fix every reported problem.

Report the final stack one line per commit and list exactly what was abandoned
or removed.
