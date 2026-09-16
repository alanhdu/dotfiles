---
name: debrief
description: Debrief a completed task with evidence-based proposals for improving the user's prompting, agent harness, or explored codebase. Use for retrospectives and collaboration-improvement requests after substantive work.
---

# Debrief

Identify the smallest set of changes that would materially improve future outcomes.
A debrief is an attribution and prioritization exercise, not a requirement to produce
new policy.

For each important source of friction, determine whether it came from:

- missing or ambiguous user context;
- a harness, tool, or workflow limitation;
- a codebase property that can be improved;
- the agent making a poor decision despite adequate context and instructions.

Choose the response that best addresses the cause:

- For an isolated execution mistake already covered by existing guidance, state that
  plainly. Do not recommend a persistent change.
- For task-specific insight, propose an acceptance criterion or verification step for
  that kind of task, without automatically adding it to shared instructions.
- For recurring and mechanically detectable problems, prefer tests, tooling,
  automation, or simplification over prose instructions.
- Recommend a persistent instruction change only when evidence suggests the issue
  will recur, existing guidance does not cover it, and the new text would change a
  future agent's decision enough to justify its attention cost.

Prefer replacing, consolidating, or deleting existing instructions over appending new
ones. Do not recommend changes merely to fill prompting, harness, and codebase
categories. It is valid—and often correct—to recommend no persistent changes.

Return only the highest-leverage proposals. For each proposal, give:

1. the observed evidence;
2. the underlying mechanism;
3. the concrete action; what specific change to the harness (`AGENTS.md`, skills,
   etc), the codebase, or the prompt?
   - For changes to `AGENTS.md` or `SKILL.md`, suggest concrete edits.
4. why that action is preferable to the alternatives.

When proposing an instruction change, identify the exact text it should replace or
remove. Do not create rules from hypothetical failure modes or use “only if this
recurs” as a holding area for speculative policy.

Do not:

- summarize or praise the completed work;
- report task status;
- disguise an agent execution mistake as a prompting problem;
- restate guidance that already exists;
- modify anything unless the user separately requests implementation.
