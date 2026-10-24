# Testing philosophy

Favor a small suite that tests meaningful behavior and supports changing the
implementation. Choose tests for the confidence and diagnostic value they
provide.

Explicitly appraise both plausible bugs that current checks miss and
opportunities to delete, combine, or simplify tests. Strengthening the suite
alone does not complete the simplification appraisal. Aim for a smaller, more
orthogonal suite without losing useful confidence; neither appraisal has a
finding quota.

- Avoid
  [test-driven ossification](https://matklad.github.io/2021/05/31/how-to-test.html).
  Test features and behavior at stable boundaries. Changing the implementation
  should not require rewriting dozens of tests.
- Prefer real behavior through public interfaces. Component tests earn their
  place through independently checkable compositional properties or difficult
  diagnosis. Check what existing integration tests establish before adding one.
  - Monkeypatching often indicates an improperly designed interface.
- Make example tests data-driven with `pytest.mark.parametrize`. A little
  branching can support the same behavior or property while sharing meaningful
  test logic. Weigh that sharing against readability; split cases when combining
  them saves little and adds conditional machinery. Prefer a simpler expression
  when available, without requiring identical execution paths. Concentrate
  interaction with the implementation behind a well-designed testing helper when
  that makes the cases resilient to API changes.
- Prefer Hypothesis over hand-written examples when there is a useful property
  with a simple, independent oracle: round-trips, invariants, metamorphic
  relationships, or comparison with a simple reference implementation.
- Test code must be high quality. Use well-designed helpers and fixtures,
  readable assertions, and short smoke tests.
- Do not duplicate evidence already provided by type checking or other tests.
  More assertions and higher coverage do not by themselves justify a test.
- Argue a missing test from a concrete, plausible bug and why current checks
  miss it. Do not use mutation runs as evidence of test quality.

## Examples and boundaries

- A minibatch trainer test reuses an independently tested loss routine to
  calculate expected aggregate loss while checking batching and weighting. This
  can be sound: loss arithmetic is established by the component's own tests. A
  test of that arithmetic needs an independent oracle rather than calling the
  loss routine for both actual and expected results.
- A matrix routine accepts dense and sparse representations. A small
  construction branch can feed either representation into shared execution and
  correctness checks: it supports the same property. By contrast, an integer
  parser's success and failure cases may share little beyond the call. Separate
  parameterized tables avoid conditional assertion machinery when combining
  saves little.
- A command-line tool reads an environment variable because the job scheduler
  requires that interface. Although avoiding the dependency would normally be
  preferable, changing the scheduler's interface is outside this tool's control.
  Here, `monkeypatch.setenv` can reasonably supply a real external input while
  the test exercises the actual integration. That justification would not apply
  to patching an internal function merely to make the test easier to write.

No mocks by default, including at external boundaries. Exceptions must be rare
and specifically justified. Reaching into implementation internals couples tests
to the design and should prompt reconsideration of the design or test boundary.

## Checklist

- [ ] Tests live at the layer that owns the behavior. Assuming lower-layer
      guarantees hold, identify what the caller still needs to establish. Do not
      re-test a component's guarantees in each consumer.
- [ ] A missed bug prompts examination of existing properties, input strategies,
      and oracles before a bespoke regression test. Prefer strengthening an
      existing property or adding a parameterized row over creating a separate
      test. If a valid class of states is generated too rarely, prefer improving
      the generator to exercise that class regularly over pinning only one
      failing input.
- [ ] Spend generated examples on inputs and states likely to reveal plausible
      bugs. Do not add low-value dimensions such as arbitrary seeds without
      identifying what failure that variation could expose.
- [ ] Property tests have simple, independent oracles and meaningful input
      generation. Simplify strategies and assertions as well as the production
      code; use a compact table when a property's oracle becomes more complex
      than the behavior it establishes. A straightforward case may need only a
      smoke test.
- [ ] Fixtures and helpers make adding cases easy and keep tests resilient to
      implementation changes. They do not build a new harness for trivial
      behavior.
- [ ] Mocks and monkeypatching are flagged by default, including patches to
      configuration or external integrations. Accept an exception only with a
      concrete justification; do not treat the boundary itself as justification.
- [ ] Performance assertions measure the intended system behavior, rather than
      implementation proxies. Do not run mutation tests to assess suite quality.

Apply this philosophy to existing and newly added tests within the review scope.
Report actionable findings as DELETE, SIMPLIFY, PARAMETRIZE, HYPOTHESIS, or ADD.
Identify the tests and explain the smallest useful change. For an addition,
explain what existing checks fail to establish, why that matters, and why the
proposed test is proportionate. No additions is a valid conclusion.
