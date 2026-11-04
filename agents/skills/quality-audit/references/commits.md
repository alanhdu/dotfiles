# Commit review

Assess the resulting stack once the code is settled.

Inspect ordered messages and every commit's parent-relative patch, including
changes later removed or overwritten. A clean final tree does not establish
independent mergeability.

## Structure review

For each commit, return a compact table that accounts for every changed file.
`commit | purpose | changed symbols/path groups | disposition`.

Then ensure:

- [ ] Each commit has one responsibility. Separate independent changes, and
      mechanical moves from behavior changes when that aids review.
- [ ] Every commit avoids churn (e.g. reformatting, renaming) unless required by
      the change.
- [ ] Prerequisites and independent small fixes come first so they can merge
      first.
- [ ] Fixups are folded into their owning commits. Rejected experiments and task
      artifacts are excluded; maintained product content is not mistaken for an
      artifact.

## Example: an extraction and its motivating adoption

One commit extracts an existing numerical operation behind a shared interface
without changing behavior. The next adopts it in a second algorithm. Both pass
checks independently, but the extraction's motivation is much clearer alongside
the adoption. Prefer two commits in this case, with the extraction immediately
followed by the adoption: the changes remain separately reviewable while the
reason for the extraction stays close. Independent mergeability alone would not
justify scattering them across the stack.

## Message checklist

- [ ] Follow AGENTS.md and the repository's existing format, including subject
      conventions and wrapping. Identify configured message checks for the
      parent to run.
- [ ] Explain the concrete problem, core mechanism, and why it helps a future
      reader with the diff but none of the conversation. Do not catalogue edits.
- [ ] Use established terms; expand ad-hoc abbreviations and explain necessary
      concepts. Remove details that do not help assess or maintain the change.
- [ ] Performance claims have relevant before/after evidence and clear
      measurement conditions. Use consistent Markdown tables for comparisons
      across cases; a single simple measurement can be prose. Reuse the
      established measurement format.

Propose the coherent split, fold, reorder, or message correction and its
motivation. Leave history edits, message-check execution, and any needed
intermediate-state verification to the parent.
