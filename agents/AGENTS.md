## Machine-specific guidance


Before starting work, read `~/.agents/AGENTS.local.md` if it exists and treat it as additional
machine-specific guidance.

## Working Style

- In chat, use Unicode/plain-text notation rather than raw LaTeX because the
  terminal does not render it. Use LaTeX when editing source files or when
  explicitly asked for a copy-paste snippet.
- Ask questions that need my answer through the question UI, not inside long prose.
- Show reviewable drafts or results as soon as possible while stating what remains
  unverified so I can respond with new directions without blocking on expensive
  verification. Redirect ongoing work if I provide feedback, but keep verifying
  if I do not.
- When I suggest changes, generalize the intent to the entire diff (code and commits
  I may not have had time to review yet). If feedback invalidates your
  approach, reconsider the approach before making another local repair
- Never communicate externally through my identity or accounts. Operational actions
  are permitted; communicating as me is not.

## Personal code preferences

- Do not push, unless explicitly asked to.
- Do not check or report remote state unless asked.
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
  - Report change IDs. Include git hashes only when needed for external systems.
  - Preserve change IDs. Do not duplicate commits.
  - `jj` history edits are recoverable through the oplog; never ask for approval before running them.
- Clean up only commits, workspaces, bookmarks, and temporary files created in the current task. Ask
  before removing pre-existing artifacts.
- Assume valid inputs in internal typed APIs; let operations fail naturally.


## Testing preferences
 
- Test helpers should represent a genuine testing or domain abstraction, not merely move assertions
  or setup out of sight.
- Prefer a small, mostly orthogonal test set over coverage-driven enumeration:
  - A large collection of narrow unit tests needs positive justification: each should cover a
    distinct plausible failure mode or provide signal that a compact table, property, or smoke test
    cannot.
  - Use compact `pytest.mark.parametrize` tables when exact inputs and outputs are simple enough to hard-code.
    - Keep cases separate when they isolate distinct failure modes or make failures easier to
      diagnose.
  - Use property-based tests for broader semantic properties. Prioritize properties that are both
    non-trivial *and* with an oracle that is obviously simple.
    - Examples include: round-trips (`decode(encode(x)) == x`), metamorphic properties (some
      relationship between `f(x)` and `g(x)` holds for all `x`), invariants, inverse relationships,
      mathematical properties (e.g. idempotence), reference testing (e.g. optimized vs brute force
      implementation), etc.
- Never add tests whose only purpose is checking an error message

## Files and background work

- Put scratch data in a uniquely named temporary directory. Remove only scratch artifacts created
  during the current task.
- Do not leave background loops or detached work running unless requested.
