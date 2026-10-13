---
name: jj
description: Use when operating in a jj repository to avoid importing Git assumptions into jj commands and workflows.
---

# jj

## Principles

Reason from jj's model, not Git's. Before using an unfamiliar command, flag,
template, or revset, check the installed version's `jj <command> --help` or
`jj help -k <topic>`. After a syntax error, read help before retrying.

- The working copy is a commit, and every jj command snapshots it first. When
  inspection must not record edits, pass `--ignore-working-copy` after the
  subcommand (`jj log --ignore-working-copy …`) so permission rules still match.
- Rewrite changes in place (`describe`, `squash`, `split`, `absorb`, `rebase`)
  so change IDs, bookmarks, and descendants follow. Do not rebuild a stack
  alongside the old one.
- Name revisions by change ID or bookmark. A commit ID names one snapshot, and
  reusing an obsolete one revives it as a divergent copy.
- Workspaces share one graph. A rewrite rebases every descendant, including
  other workspaces' `@`.
- Every operation is in `jj op log`. Recover with `jj undo` or
  `jj op restore`, not by hand.

## Observed mistakes

From about 20k jj calls in past Claude and Codex sessions:

- **Rewriting under another workspace.** If that workspace has edits not yet
  snapshotted, its next command reports a stale working copy, moves those edits
  into a divergent sibling, and removes them from disk. Before rewriting, check
  `jj log -r '(<revs>):: & working_copies()'`. If another workspace's `@`
  appears, stack on top or ask.
- **Leaving divergence.** Fix it with `jj converge --no-interactive`, then confirm
  `jj log -r 'divergent()'` is empty.
- **Git syntax.** `jj grep`, `jj diff --check`, `rev:path`, `jj op undo`,
  `jj diff -r A --to B`, `jj show <rev> -- <path>`, and `--stat --summary` all
  fail. Use `rg`, `jj file show -r`, `jj undo`, `--from A --to B`, and
  `jj diff -r <rev> <paths>`.
- **Template contexts.** The `evolog` template is a `CommitEvolutionEntry`, so use
  `commit.commit_id()`, not `commit_id`.
- **`jj resolve --list` exits nonzero when there are no conflicts**, which breaks
  `&&` chains. Use `jj log -r 'conflicts()'`.
- **Editors.** `squash` and `describe` open an editor without `-m` (or
  `--use-destination-message` for `squash`).
- **Forcing bookmarks.** "Refusing to move bookmark backwards or sideways" means
  the change was replaced instead of rewritten. Find out why before passing
  `--allow-backwards`.

Use [jj-workspace](../jj-workspace/SKILL.md) for isolated work and
[restack](../restack/SKILL.md) for reshaping stacks.
