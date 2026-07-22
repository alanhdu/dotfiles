---
name: jj-workspace
description: Run a code change in an isolated, throwaway jj workspace (worktree) and hand back a bookmark, without touching the current working copy. Use whenever the user wants edits made off to the side in a jj repo.
---

# Isolated jj workspace workflow

Make a change in a temporary jj **workspace** (jj's worktree), then hand it back as a
**bookmark** (jj's branch) without touching the user's working copy. Workspaces share one
repo/store, so a commit made in the temp workspace is immediately visible elsewhere.

**Precondition:** only usable in a jj repo. Confirm `jj root` succeeds; if it fails, stop and
tell the user this skill needs a jj repository.

## Conventions
- Bookmark naming: `<person>-<descriptive-name>`, where `<person>` is the user's name (e.g. the
  local-part of their email). Omit the prefix if the user is unknown.
- Split the change into atomic, focused, easy-to-review commits; exclude incidental changes.
- Never push unless asked — deliver a local bookmark.

## Steps

1. **Create** the workspace off to the side. Use the session scratchpad dir (path in your
   system prompt) so it doesn't clutter the repo or its parent:
   `jj workspace add --name <slug> "<SCRATCHPAD>/<slug>"`
2. **Work** inside it — prefix every command with `cd "<SCRATCHPAD>/<slug>" &&` (Bash resets cwd
   between calls). Set up the environment if needed (may be slow the first time). Follow the
   repo's test conventions and verify the change works before handing it back.
3. **Describe** with a conventional commit message (what + why):
   `jj describe -m "<type>(<scope>): <summary>\n\n<body>"`
   Then confirm with `jj st` that only the intended files changed.
4. **Bookmark** it (run from anywhere — the store is shared). The temp workspace's commit is the
   revset `<slug>@`, so no need to look up a change id:
   `jj bookmark create <person>-<name> -r <slug>@`
   This does not touch the user's working copy.
5. **Clean up** once the user confirms done:
   `jj workspace forget <slug>` then `rm -rf "<SCRATCHPAD>/<slug>"`
   The bookmark survives (it references the commit). Verify: `jj workspace list` no longer shows `<slug>`, and `jj bookmark list` still shows the bookmark.

## Report back
Give the user the bookmark name, the commit it points at, and the command to push it later
(don't push unless asked), e.g. `jj git push -b <name>`.

