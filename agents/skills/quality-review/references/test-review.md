# Testing philosophy

Favor a small suite that tests meaningful behavior and supports changing the
implementation. Choose tests for the confidence and diagnostic value they provide.

- Avoid [test-driven ossification](https://matklad.github.io/2021/05/31/how-to-test.html).
  Test features and behavior at stable boundaries. Changing the implementation
  should not require rewriting dozens of tests.
- Prefer real behavior through public interfaces. Component tests earn their
  place through independently checkable compositional properties or difficult
  diagnosis. Check what existing integration tests establish before adding one.
- Make example tests data-driven with `pytest.mark.parametrize`. Keep one
  execution/assertion path so adding an edge case means adding a row.
  Concentrate interaction with the implementation behind a well-designed
  testing helper when that makes the cases resilient to API changes.
- Prefer Hypothesis over hand-written examples when there is a useful property
  with a simple, independent oracle: round-trips, invariants, metamorphic
  relationships, or comparison with a simple reference implementation.
- Test code must be high quality. Use well-designed helpers and fixtures,
  readable assertions, and short smoke tests.
- Do not duplicate evidence already provided by type checking or other tests.
  More assertions and higher coverage do not by themselves justify a test.

## Examples and boundaries

- An integration test exercises the behavior and makes a component failure easy
  to locate: another component test is redundant, despite missing isolated coverage.
- A pipeline test uses the production encoder to calculate its expected output:
  independently test the encoder, because that test assumes its correctness.
- A mathematical invariant has a simple independent oracle: a component property
  test is often useful because the property can be established at that boundary.
- A numerical pipeline fails, but several encapsulated transformations could be
  responsible: focused component tests can materially improve diagnosis.
- Repeated evaluations are slow: benchmark representative evaluations. Checking
  file-open counts or omitted digest fields does not establish a speed improvement.

No mocks by default, including at external boundaries. Exceptions must be rare
and specifically justified. Reaching into implementation internals couples tests
to the design and should prompt reconsideration of the design or test boundary.

A subprocess invocation can be simple. Servers may be appropriate when testing
network behavior. Evaluate the machinery needed for the actual property; do not
invent a server and lifecycle harness merely to fill an isolated coverage gap.
Performance measurements need their own considered workloads and methodology.

Apply this philosophy to existing and newly added tests within the review scope.
Report actionable findings as DELETE, SIMPLIFY, PARAMETRIZE, HYPOTHESIS, or ADD.
Identify the tests and explain the smallest useful change. For an addition,
explain what existing checks fail to establish, why that matters, and why the
proposed test is proportionate. No additions is a valid conclusion.
