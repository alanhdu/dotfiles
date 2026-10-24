# Architecture review

Start with the behavior and the responsibilities needed to provide it. Trace a
representative operation across callers, callees, state, and dependencies. Judge
whether the boundaries themselves make sense before considering local polish.
Assign responsibilities by purpose and each layer's contract.

## Checklist

- [ ] Each decision, invariant, and piece of state has a clear owner. Callers do
      not repair or reconstruct behavior that belongs in a lower layer.
- [ ] Dependencies flow in the intended direction. A layer does not reach into
      another's implementation to recover information its interface should
      supply.
- [ ] Layers have distinct responsibilities. Initialization, validation,
      selection, or computation is not repeated across boundaries without a
      reason.
- [ ] Files and modules live with the responsibilities they own. Durable shared
      behavior belongs in its owning package, rather than beside its first
      experiment or caller; experiment-specific behavior stays out of shared
      libraries.
- [ ] Interfaces express the information their callers need. Inspect actual
      callers' guarantees rather than inventing additional input states to
      handle.
- [ ] In a refactor, required behavior is preserved without treating legacy
      structure as a requirement. Consider moving, removing, or introducing a
      boundary when that clarifies ownership.
- [ ] Complexity attributed to performance has evidence from representative
      benchmarks. Identify missing evidence for the parent; do not run
      benchmarks.

Establish what the code actually does. Explicitly requested generality is a
requirement; a single implementation alone does not invalidate an extension
point.

## Example: placement depends on future intentions

A numerical method lives in an experiment module. Its interface is stable and
independent of that experiment, but it still has only one caller. Moving it into
a shared numerical package could give it a clearer owner, while also suggesting
that it is maintained for general use. The reviewer cannot know whether the user
intends that commitment. Surface the possibility and explain the tradeoff for
the user to decide; leave the code in place and continue the review. This is not
an established architectural defect or a reason to block other reviewers.

Explain the responsibility problem, its concrete consequence, and why changing
it would help. Then suggest a coherent redesign, briefly, including meaningful
tradeoffs or uncertainty. A well-motivated boundary change can matter more than
many local cleanups; do not bury it under edits to code it would replace. For
placement findings, explain the ownership or reader benefit rather than merely
imposing a preferred directory layout.
