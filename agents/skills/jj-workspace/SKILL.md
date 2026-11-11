---
name: jj-workspace
description:
  Make a code change in an isolated, temporary jj workspace and hand back a
  bookmark without editing the user's working-copy files. Use when the user wants
  edits made off to the side in a jj repository.
---

# Isolated jj workspace workflow

Work in a temporary jj workspace and hand back a local bookmark. Commits are
visible from every workspace; keep file edits in the temporary workspace.

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
2. Add the workspace at the base:

   ```bash
   jj workspace add --no-colocate --name <slug> -r '<base>' <path>
   ```

   Use the existing target when continuing a stack; otherwise use the named
   base or `trunk()`.
   Use `--colocate` instead when Git metadata is needed (Git 2.42+).
3. Work inside it, following the repository's setup and verification instructions.
4. Describe the change and confirm with `jj status` that only intended files
   changed.
5. Set the requested bookmark to the intended commit and verify its target;
   reuse an existing bookmark when named.
6. Once the user has explicitly accepted the result or requests cleanup, confirm
   the workspace name refers to the exact temporary directory returned by
   `mktemp`, then run `jj workspace remove <slug>` from another workspace. This
   snapshots the target's working copy and removes its directory from disk.

## Dependencies and baseline comparisons

Ignored dependencies and generated environments are normally absent from a new
workspace. Reuse an existing environment only when the repository documents that
workflow and its paths remain valid from the temporary workspace. If the change
modifies dependency metadata or a lockfile, create or update an isolated
environment according to the repository's instructions.

Do not create a second workspace merely for a baseline comparison. If a baseline
is needed, measure the chosen base in this temporary workspace without rewriting
or contaminating the task stack, then return to the task revision.

## Report

Give the bookmark name and its tip change ID. For a stack, list each change ID
with its scope and provide `jj diff --from <base> --to <bookmark>` for reviewing
the complete result.
