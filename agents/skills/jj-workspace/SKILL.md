---
name: jj-workspace
description: Make a code change in an isolated, temporary jj workspace and hand back a bookmark without touching the user's working copy. Use when the user wants edits made off to the side in a jj repository.
---

# Isolated jj workspace workflow

Work in a temporary jj workspace without touching the user's working copy.
Hand back a local bookmark; commits are visible from every workspace.

## Conventions

- Follow the repository's bookmark naming convention. If none is discoverable,
  use a short descriptive name. Bookmarks may be published as Git branches, so
  keep secrets and private information out of them; a public username is fine.
- Preserve the requested stack and bookmarks; avoid unnecessary parallel commits
  or bookmarks.

## Steps

1. Create a unique temporary directory with
   `mktemp -d "${TMPDIR:-/tmp}/jj-workspace-<slug>.XXXXXX"`. Record the exact
   returned path.
2. Add the workspace without snapshotting the current one, then move it onto
   the base:
   `jj workspace add --ignore-working-copy --no-colocate --name <slug> <path>; jj -R <path> new '<base>'`.
   With `--ignore-working-copy`, `add` ignores `--revision` and exits 1 after
   creating the workspace on the root commit; `new` fixes both. Use the
   existing target when continuing a stack; otherwise use the named base or
   `trunk()`. Use `--colocate` instead when Git metadata is needed (Git 2.42+).
3. Work inside it. Follow the repository's setup and verification instructions;
   do not assume a language, source layout, environment manager, or toolchain.
4. Describe the change and confirm with `jj status` that only intended files
   changed.
5. Set the requested bookmark to the intended commit and verify its target;
   reuse an existing bookmark when named.
6. Once the user has explicitly accepted the result or requests cleanup, forget
   the temporary workspace with `jj workspace forget <slug>`, then remove only
   the exact temporary directory returned by `mktemp`.

## Dependencies and baseline comparisons

Ignored dependencies and generated environments are normally absent from a new
workspace. Reuse an existing environment only when the repository documents
that workflow and its paths remain valid from the temporary workspace. If the
change modifies dependency metadata or a lockfile, create or update an isolated
environment according to the repository's instructions.

Do not create a second workspace merely for a baseline comparison. If a
baseline is needed, measure the chosen base in this temporary workspace without
rewriting or contaminating the task stack, then return to the task revision.

## Report

Give the bookmark name and its tip change ID. For a stack, list each
change ID with its scope and provide
`jj diff --from <base> --to <bookmark>` for reviewing the complete result.
