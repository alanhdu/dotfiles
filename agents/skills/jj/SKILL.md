---
name: jj
description:
  Use when operating in a jj repository to avoid importing Git assumptions into
  jj commands and workflows.
---

# jj

## Principles

Reason from jj's model, not Git's. Before using an unfamiliar command, flag,
template, or revset, check the installed version's `jj <command> --help` or
`jj help -k <topic>`. After a syntax error, read help before retrying.

- The working copy is a commit; commands normally snapshot it first. When
  inspection must not record edits, pass `--ignore-working-copy` after the
  subcommand (`jj log --ignore-working-copy …`) so permission rules still match.
- Rewrite changes in place (`describe`, `squash`, `split`, `absorb`, `rebase`)
  so change IDs, bookmarks, and descendants follow. Do not rebuild a stack
  alongside the old one.
- Name revisions by change ID or bookmark. A commit ID names one snapshot, and
  reusing an obsolete one revives it as a divergent copy.
- Workspaces share one graph. A rewrite rebases every descendant, including
  other workspaces' `@`. Before rewriting, check
  `jj log --ignore-working-copy -r '(<revs>):: & working_copies()'`.
  If another workspace's `@` appears, stack on top or ask; rewriting beneath it
  can leave it stale and require reconciling unsnapshotted edits.
- Every operation is in `jj op log`. Recover with `jj undo` or `jj op restore`,
  not by hand or with `jj op undo`. Undo/redo across workspaces requires
  `--allow-cross-workspace`; inspect the operation before overriding this guard.

## Translating Git habits

These are recurring mistakes in agent command history. Translate the intent,
rather than substituting `jj` for `git`.

| Git command or habit | jj equivalent |
| --- | --- |
| `git diff A B` | `jj diff --from A --to B`; don't mix `-r` with `--to`. |
| `git show R:path` | `jj file show -r R path` for file contents. |
| `git show R -- path` | `jj diff -r R path` for that revision's patch. |
| `git grep pattern` | `rg pattern` on disk; `jj file search -r R --pattern pattern` in a revision. |
| `R^` / `R~N` | `first_parent(R)` / `first_parent(R, N)`; `R-` selects all parents. |
| `git diff --check` | No jj flag; use the repository's whitespace/lint checks. |

## Other pitfalls

- **Leaving divergence.** Fix it with `jj converge --no-interactive`, then
  confirm `jj log -r 'divergent()'` is empty.
- **Diff formats.** Choose `--stat` or `--summary`; they cannot be combined.
- **Template contexts.** The `evolog` template is a `CommitEvolutionEntry`, so
  use `commit.commit_id()`, not `commit_id`.
- **`jj resolve --list` exits nonzero when there are no conflicts**, which
  breaks `&&` chains. Use `jj log -r 'conflicts()'`.
- **Editors.** `squash` and `describe` open an editor without `-m` (or
  `--use-destination-message` for `squash`).
- **Forcing bookmarks.** "Refusing to move bookmark backwards or sideways" means
  the target isn't a forward move. Check whether the change was replaced instead
  of rewritten before passing `--allow-backwards`.

Use [jj-workspace](../jj-workspace/SKILL.md) for isolated work and
[restack](../restack/SKILL.md) for reshaping stacks.
