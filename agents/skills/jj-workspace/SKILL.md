---
name: jj-workspace
description: Make a code change in an isolated, temporary jj workspace and hand back a bookmark without touching the user's working copy. Use when the user wants edits made off to the side in a jj repository.
---

# Isolated jj workspace workflow

Make a change in a temporary jj workspace, then hand it back as a bookmark
without touching the user's working copy. Workspaces share one repository and
store, so commits made in the temporary workspace are immediately visible
elsewhere.

## Conventions

- Follow the repository's bookmark naming convention. If none is discoverable,
  use a short descriptive name and avoid embedding personal information.
- Split work into atomic, focused commits and exclude incidental changes.
- Never push unless asked; deliver a local bookmark.
- Preserve the logical identity and topology implied by the user's requested
  operation. Do not create parallel bookmarks or commits unnecessarily.

## Steps

1. Create a unique temporary directory with
   `mktemp -d "${TMPDIR:-/tmp}/jj-workspace-<slug>.XXXXXX"`. Record the exact
   returned path.
2. Add the workspace with
   `jj workspace add --name <slug> --revision '<base>' <path>`, using `trunk()`
   for `<base>` if the user did not name one.
3. Work inside it. Follow the repository's setup and verification instructions;
   do not assume a language, source layout, environment manager, or toolchain.
4. Describe the change with a concise what-and-why message. Confirm with
   `jj status` that only intended files changed.
5. Hand back the change under the requested bookmark. Do not create a new
   bookmark when the user named an existing one.
6. Verify that the bookmark points at the intended commit.
7. Once the user has explicitly accepted the result or requests cleanup, verify
   that the bookmark points at the intended commit, forget the temporary
   workspace with `jj workspace forget <slug>`, then remove only the exact
   temporary directory returned by `mktemp`.

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

Give the bookmark name and the commit it points to. If the repository has a Git
remote and the user asks how to publish it, also give the appropriate push
command. Do not push unless asked.
