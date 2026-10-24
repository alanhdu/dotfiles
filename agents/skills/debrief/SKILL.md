---
name: debrief
description: Audit friction across a completed session, then recommend the smallest set of durable improvements to the harness or codebase. Use for retrospectives and collaboration-improvement requests after substantive work.
---

# Debrief

Audit first, recommend second. Do not modify anything unless asked.

## 1. Audit the full session

1. Read all messages and tool outcomes. List corrections, wrong turns,
   frustrations, misleading results, unnecessary work, delays and unrequested
   changes before selecting recommendations.
2. Group incidents by underlying cause, not similar symptoms: missing context,
   harness limitations, codebase problems, or agent mistakes despite adequate
   guidance.
3. For each group, cite evidence, distinguish observations from inferred causes,
   explain why existing protections failed, and identify whether the cause was
   fixed, only its consequences repaired, or neither.

Include groups even when already fixed or unlikely to yield a recommendation.
State any unavailable session context that limits the audit.

## 2. Select recommendations

Choose the smallest set of changes addressing the highest-impact remaining
causes. Explain what generalizes beyond each incident; keep environment-specific
details in their owning layer. Prefer mechanical fixes and simplification over
prose; prefer editing or deleting instructions over adding them.

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
