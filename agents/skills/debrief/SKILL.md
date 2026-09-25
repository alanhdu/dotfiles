---
name: debrief
description: Debrief a completed task with evidence-based proposals for improving the user's prompting, agent harness, or explored codebase. Use for retrospectives and collaboration-improvement requests after substantive work.
---

# Debrief

Find the smallest set of changes that would most improve future outcomes. For each real source of
friction in the task, identify its cause — unclear user context, a harness or tool limitation, a
codebase property, or an agent mistake despite adequate guidance — and propose the fix that
addresses that cause most durably at the lowest ongoing cost.

- Prefer mechanical fixes (tests, tooling, simplification) over prose, and editing or deleting
  existing instructions over adding new ones. Every instruction costs future attention.
- Ground each proposal in something that actually happened, not a hypothetical.
- Proposing nothing is often correct. An agent mistake already covered by existing guidance
  warrants a plain acknowledgement, not a new rule.
- Suggest a persistent instruction only when the issue is likely to recur, existing guidance
  does not cover it, and the new wording would change a future decision.

Do not summarize the work, report status, or modify anything unless asked.

## Output

List the highest-priority changes first. If none are warranted, write "No changes recommended"
and briefly explain why.

### [Imperative summary of the change]

- **Evidence:** What happened in the task?
- **Cause:** What produced the friction?
- **Change:** What specific action would address it?
- **Where:** Prompt, instruction file, tool/workflow, or codebase. Name files and quote text to
  replace or remove when applicable.
- **Why this change:** Why is it worth the ongoing cost?
