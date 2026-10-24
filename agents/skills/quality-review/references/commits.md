# Commit review

Assess the resulting stack once the code is settled.

Inspect ordered messages and every commit's parent-relative patch, including
changes later removed or overwritten. A clean final tree does not establish
independent mergeability. For jj, sections 2–4 of the sibling
[restack skill](../../restack/SKILL.md) supply the commit-structure bar;
appraise without executing its rewriting workflow.

### Structure checklist

- [ ] Each commit has one coherent responsibility and is independently
      reviewable and mergeable, with prerequisites before their users.
- [ ] Necessary implementation and tests are present at each intermediate state.
      Identify a concrete dependency or failure when questioning this.
- [ ] Mechanical moves and behavioral changes are separate when that aids
      review. Unrelated renaming, formatting churn, and drive-by changes do not
      obscure the idea.
- [ ] Fixups are folded into their owning commits. Rejected experiments and task
      artifacts are excluded; maintained product content is not mistaken for an
      artifact.

### Example: an extraction and its motivating adoption

One commit extracts an existing numerical operation behind a shared interface
without changing behavior. The next adopts it in a second algorithm. Both pass
checks independently, but the extraction's motivation is much clearer alongside
the adoption. Prefer two commits in this case, with the extraction immediately
followed by the adoption: the changes remain separately reviewable while the
reason for the extraction stays close. Independent mergeability alone would not
justify scattering them across the stack.

### Message checklist

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
