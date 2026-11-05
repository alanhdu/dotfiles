# Commit review

Assess the resulting stack once the code is settled, against
[AGENTS.md's commit guidance](../../../AGENTS.md#commits-and-version-control).
The checks and examples below elaborate it.

Inspect ordered messages and every commit's parent-relative patch, including
changes later removed or overwritten. A clean final tree does not establish that
every prefix of the stack is mergeable.

## Structure review

For each commit, return a compact table that accounts for every changed file.
`commit | purpose | changed symbols/path groups | disposition`.

Then ensure:

- [ ] Classify each hunk as a move, a required API adaptation, or a separate
      improvement. Unbundle independent improvements into separate commits.
      Mechanical commits preserve fixtures, assertions and contract details;
      put redesign and simplification in later commits.
- [ ] Purely mechanical moves and renames precede the commits that use them:
      they can merge without reviewers understanding the full refactor.
- [ ] Every commit avoids churn (e.g. reformatting, renaming) unless required by
      the change. Churn makes reviewing harder by creating diff noise.
- [ ] Fixups are folded into their owning commits. Otherwise, reviewers waste
      time on broken/bad commits and have to update our understanding later.

## Example: an extraction and its motivating adoption

One commit extracts an existing numerical operation behind a shared interface
without changing behavior. The next adopts it in a second algorithm. Both pass
checks with their prerequisites, but the extraction's motivation is much clearer
alongside the adoption. Prefer two commits in this case, with the extraction
immediately followed by the adoption: the changes remain separately reviewable
while the reason for the extraction stays close. Mergeable prefixes alone would
not justify scattering them across the stack.

## Message checklist

- [ ] Follow the linked guidance and repository format, including subject
      conventions and wrapping. Identify configured message checks for the
      parent to run.
- [ ] Explain the concrete problem and core mechanism, adding technical detail
      only where it helps assess or maintain the change. Expand ad-hoc
      abbreviations and explain necessary concepts.
- [ ] Performance claims have relevant before/after evidence and clear
      measurement conditions. Use consistent Markdown tables for comparisons
      across cases; a single simple measurement can be prose. Reuse the
      established measurement format.

Propose the coherent split, fold, reorder, or message correction and its
motivation. Leave history edits, message-check execution, and any needed
intermediate-state verification to the parent.
