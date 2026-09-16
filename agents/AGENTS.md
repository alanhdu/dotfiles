## Machine-specific guidance

Before starting work, read `~/.agents/AGENTS.local.md` if it exists and treat it as additional
machine-specific guidance.

## Collaboration

I like being in-the-loop. Optimize for end-to-end wall-clock time subject to correctness and safety.
Start safe long-latency operations as soon as their inputs are stable, overlap independent
workstreams, and prioritize delivering results that I can respond to first while running more
expensive checks in the background.

Use subagents when independent workstreams can run in parallel and are likely to reduce wall-clock
time or provide genuinely independent review. Work directly for simple, sequential, or
tightly-coupled tasks.

I run uncommitted local edits you can't see. Never assume the repository is all that exists.

## Personal code preferences

When writing code:

- NEVER push to GitHub. Only the user may push to GitHub.
- Prefer the simplest straight-line implementation. Use the ladder inline code → function → class →
  protocol, moving up only for a real abstraction.
- Functions and classes are for *abstraction*, not *reuse*. Duplication is preferred to
  muddled or unclear abstraction boundaries.
  - Do not create helper functions just because they save a couple lines of code. Only create them
    if they represent a coherent boundary.
- Write comments, docstrings, and commit messages primarily for *future* users without your context.
  - Be succinct. Future users want to know the important information quickly.
  - Do not restate the obvious or duplicate information in comments, docstrings, commit messages,
    names, and parameters.
  - Do not reference things that exist only in your context.
  - Format commit messages for readability. Match the user's existing commit style. Trivial changes
    can use one line; large, unobvious changes can use several paragraphs.
- Prefer jujutsu (`jj`) in repositories configured for it; otherwise use Git.
  - Preserve change IDs. Do not duplicate commits.
  - `jj` operations are recoverable through the oplog; never ask for approval before running them.
- Clean up only commits, workspaces, bookmarks, and temporary files created in the current task. Ask
  before removing pre-existing artifacts.

## Testing preferences

- Prefer a small, mostly orthogonal test set over coverage-driven enumeration:
  - Use compact `pytest.mark.parametrize` tables when exact inputs and outputs are simple enough to
    hard-code.
  - Use property-based tests for broad semantic or metamorphic properties.
  - Keep cases separate when they isolate distinct failure modes or make failures easier to
    diagnose.
- Test oracles must be obviously simpler than the production logic. Derive expected results directly
  from fixtures or independent invariants; do not reimplement the algorithm under test.
- Test helpers should represent a genuine testing or domain abstraction, not merely move assertions
  or setup out of sight.

## Files and background work

- Put scratch data in a uniquely named temporary directory. Remove only scratch artifacts created
  during the current task.
- Do not leave background loops or detached work running unless requested.
