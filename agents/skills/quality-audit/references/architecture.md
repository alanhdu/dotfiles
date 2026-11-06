# Architecture review

## Principles

- **Simplification includes eliminating abstractions.** The existing design is
  not the starting assumption to defend. A refactor should reduce unnecessary
  concepts and coordination across the complete operation while preserving its
  required behavior.

- **Abstractions must repay their cognitive cost.** Encapsulation and composition
  justify that cost; reuse alone does not. Inline code → function → class →
  protocol is a useful ladder, not a rigid ranking.
  - YAGNI: two or three independent users reveal what an abstraction should be.
    Without them, a full abstraction is presumptively premature. Explicitly
    requested generality remains a requirement.

- **Sharing commits users to change together.** If a change should not apply to
  every user, shared implementation creates false coupling. Duplication is
  preferable. A common interface can still make sense without a common
  implementation; it does not automatically warrant a protocol.
  - **Example:** Billing and delivery address validators start identical. A new
    delivery restriction on PO boxes should not restrict billing.

- **Straight-line execution keeps choices local.** Selecting behavior at a
  boundary avoids tracking interleaved branches throughout an operation.
  Polymorphism serves this goal; it need not mean a framework. Python types in
  `A | B` can expose the same operations without a protocol. Repeated
  `isinstance` dispatch retains the branching; `is None` is a presence check.

- **Size estimates expose unexplained complexity.** A large departure from the
  expected implementation size needs an explanation: accidental complexity or
  essential constraints the estimate missed. Line count is a diagnostic, not a
  quota; readable duplication can be simpler than shorter shared code.

- **Intent determines requirements.** Existing callers establish what must work,
  not what can be dropped: private branches and planned work also count.
  Conversely, imagined users do not justify speculative machinery. Upcoming
  capabilities and acceptable constraints emerge through discussion; neither a
  prewritten brief nor the codebase can settle them all.
  - **Example:** Making published records immutable removes update propagation
    but excludes corrections in place. That tradeoff needs the user's decision.

## Review checklist and required evidence

Include the evidence below in the report. Mark an item inapplicable only with a concrete reason.

- [ ] **Elimination:** Describe the simplest direct algorithm for the required
      behavior without using the implementation's abstraction names. Compare
      the complete operation against it: which types, layers, modes, and
      coordination steps can disappear?

- [ ] **Abstractions:** Inventory every type, function, class, lifecycle step,
      and layer introduced or substantially changed in scope. For each, give:
      - Its location and responsibility.
      - The simplest alternative that removes it, such as inlining or using
        an existing construct.
      - A verdict: remove, simplify, or retain.
      - Concrete evidence from its implementation and callers supporting
        that verdict. For retention, explain what the alternative makes
        worse and why that matters to the requirements.
      Do not justify an abstraction merely by describing what it does.
      If a simpler alternative satisfies the requirements, report it as a
      simplification finding.

- [ ] **False coupling:** Identify shared behavior and the callers inspected.
      Explain whether those callers should change together; report exceptions.
      Ensure that every field of a class and every parameter to all
      functions/methods are always meaningful. Any "unused" fields are evidence
      of false coupling.

- [ ] **Ownership:** Identify authoritative state and any mirrored state or
      repeated conversions. Explain necessary duplication; report avoidable
      bookkeeping.

- [ ] **Control flow:** Trace one complete operation. Identify repeated choices
      and caller loops that could move to a boundary or become batch operations.

- [ ] **Layering:** Identify callers managing another layer's internal state,
      phases, or lifecycle. Explain whether each boundary reduces total
      complexity or merely relocates it.

- [ ] **Requirements:** Assess every requested outcome, including simplicity
      and performance. Explain unexpected implementation size through concrete
      required behavior or removable machinery; line counts alone do not suffice.

- [ ] **Placement:** Assess whether changed responsibilities belong where they
      live. Identify any experiment code promoted into maintained shared code
      and the requirement that justifies that placement.

Keep evidence compact, but preserve complete inventory coverage. Correctness
and performance findings do not substitute for the simplification analysis.
There is no finding quota.
