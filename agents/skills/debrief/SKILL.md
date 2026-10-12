---
name: debrief
description: Audit friction across a completed session, then recommend the smallest set of durable improvements to the harness or codebase. Use for retrospectives and collaboration-improvement requests after substantive work.
---

# Debrief

Audit first, recommend second. Do not modify anything unless asked.

## 1. Audit the entire session

Inventory friction across the beginning, middle, and end before selecting
recommendations. Include repeated corrections, misleading results, abandoned
approaches, unnecessary work, delays, and unrequested changes. Group incidents
by cause, not merely similar symptoms.

For every substantial pattern, identify:

- **Evidence:** Concrete incidents; distinguish facts from inferred causes.
- **Cause:** User-context gaps, harness/tool limitations, codebase properties,
  or agent mistakes despite adequate guidance. Why did existing protections fail?
- **Disposition:** Was the cause fixed, only its consequences repaired, or neither?

Include patterns even when already fixed or unlikely to yield a recommendation.
State any missing context that limits coverage.

## 2. Select recommendations

Choose the smallest set of changes addressing the highest-impact remaining
causes. Prefer mechanical fixes and simplification over prose; prefer editing
or deleting instructions over adding them.

Existing guidance rules out duplicate instructions, not investigation of
repeated failures. Consider whether tooling or workflow could make it effective.
Add a persistent instruction only if the problem is likely to recur and the
wording would change a future decision.

Recommend only actionable changes to located targets the user controls. Do not
re-propose completed fixes or pad the list to reach a minimum count.

## Output

**Session audit:** Briefly report every substantial pattern with its evidence,
cause, and disposition. This is not a chronology or task-status summary.

**Recommendations:** Use **Harness** and **Codebase** subsections, highest priority
first. For each proposal give:

- **Addresses:** The audited pattern.
- **Change and where:** The concrete edit and inspected target; provide an exact
  diff for skills or agent instructions.
- **Why:** Expected benefit relative to ongoing cost.

If no changes are warranted, say “No changes recommended” and explain why.
Still provide the audit.
