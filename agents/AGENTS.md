## Machine-specific guidance

Before starting work, read `~/.agents/AGENTS.local.md` if it exists and treat it as additional
machine-specific guidance.

## Working Style

- In chat, use Unicode/plain-text notation rather than raw LaTeX because the
  terminal does not render it. Use LaTeX when editing source files or when
  explicitly asked for a copy-paste snippet.

## Personal code preferences

- NEVER push to GitHub. Only the user may push to GitHub.
- Prefer the simplest straight-line implementation. Use the ladder inline code → function → class →
  protocol, moving up only for a real abstraction.
- Functions and classes are for *abstraction*, not *reuse*. Duplication is preferred to
  muddled or unclear abstraction boundaries.
  - Do not create helper functions just because they save a couple lines of code. Only create them
    if they represent a coherent boundary.
- Write comments, docstrings, and commit messages for *future* users without your context.
  - Be succinct. Future users want to know the important information quickly.
  - Do not restate the obvious or duplicate information in comments, docstrings, commit messages,
    names, and parameters.
  - Do not reference things that exist only in your context.
  - Write commit messages in Markdown, matching the user's existing commit style.
- Prefer jujutsu (`jj`) in repositories configured for it; otherwise use Git.
  - Preserve change IDs. Do not duplicate commits.
  - `jj` operations are recoverable through the oplog; never ask for approval before running them.
- Clean up only commits, workspaces, bookmarks, and temporary files created in the current task. Ask
  before removing pre-existing artifacts.


## Testing preferences

- Test helpers should represent a genuine testing or domain abstraction, not merely move assertions
  or setup out of sight.
- Prefer a small, mostly orthogonal test set over coverage-driven enumeration:
  - Use compact `pytest.mark.parametrize` tables when exact inputs and outputs are simple enough to
    hard-code.
    - Keep cases separate when they isolate distinct failure modes or make failures easier to
      diagnose.
  - Use property-based tests for broader semantic properties. Prioritize properties that are both
    non-trivial *and* with an oracle that is obviously simple.
    - Examples include: round-trips (`decode(encode(x)) == x`), metamorphic
      properties (some relationship between `f(x)` and `g(x)` holds for all
      `x`), invariants, inverse relationships, mathematical properties (e.g.
      idempotence), reference testing (e.g. optimized vs brute force
      implementation), etc.

## Files and background work

- Put scratch data in a uniquely named temporary directory. Remove only scratch artifacts created
  during the current task.
- Do not leave background loops or detached work running unless requested.
