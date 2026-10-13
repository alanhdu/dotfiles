---
name: jj
description: Use when operating in a jj repository to avoid importing Git assumptions into jj commands and workflows.
---

# jj

## General principles

Reason from jj's state model before choosing commands. Do not assume Git flags,
branch behavior, or recovery procedures carry over. For unfamiliar operations,
check the installed command's help and matching documentation. After a syntax
error, check help before retrying or repeating the command across revisions.

Key differences:

- The working copy is already a commit. By default, even inspection commands
  snapshot edits and new non-ignored files. Use `--ignore-working-copy` when
  inspection must leave those edits unrecorded.
- `describe` changes a message; `new` starts the next change. A bookmark does
  not advance automatically when you create a new change.
- Change IDs follow rewrites; commit IDs identify snapshots. Rewrite existing
  changes to preserve their identity. Descendants are rebased automatically;
  inspect the resulting graph and bookmark targets.
- Workspaces share history and the operation log. Separate directories do not
  isolate ancestor rewrites or repository-wide recovery.

## Observed mistakes

Recurring failures in prior agent sessions:

- `jj diff --check` imported a Git flag; `jj show --stat --summary` combined
  alternative formats. Verify syntax rather than translating commands.
- `evolog` was given a `log` template. Check the command's template context.
- Automated squash opened an editor. Supply `-m` or `--use-destination-message`.

Use [jj-workspace](../jj-workspace/SKILL.md) for isolated work and
[restack](../restack/SKILL.md) for reshaping stacks.
