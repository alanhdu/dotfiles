# Test review

Look over the tests for opportunities to simplify them and strengthen their
bug detection. When the benefit of extra testing is small, prefer simplicity.

Report simplification before missed bugs, using DELETE, SIMPLIFY, PARAMETRIZE,
HYPOTHESIS or ADD. For ADD, explain why an existing property, parameter table
or generator cannot absorb the case clearly (this is often a signal of a poorly
designed test suite). Do not add test machinery merely to make a gap
observable. A justified decision to leave a gap untested is a successful
review.

## Checklist

- [ ] The suite conforms to the testing preferences in AGENTS.md; this
      checklist elaborates them.
- [ ] Tests exercise public interfaces at stable boundaries and avoid
      [test-driven ossification](https://matklad.github.io/2021/05/31/how-to-test.html):
      changing the implementation should not require rewriting dozens of tests.
- [ ] Every test lives at the right layer. Prefer end-to-end tests of the whole
      pipeline; component tests earn their place through independently
      checkable compositional properties or difficult diagnosis. Assuming
      lower-layer guarantees hold, identify what the caller still needs to
      establish. Do not re-test a component's guarantees in each consumer.
- [ ] Every test function and case earns its place through useful bug detection
      or diagnosis, not more assertions or coverage. It does not duplicate
      evidence from type checking or other tests; added cases target realistic,
      consequential bugs.
- [ ] Examples are data-driven (e.g. with `pytest.mark.parametrize`). Existing
      properties, generators, and tables are extended before tests are added;
      every new test function justifies why it cannot join one. If extending
      needs substantial machinery, reconsider the test design.
- [ ] Hypothesis is used where a useful property has a simple, independent
      oracle: round-trips, invariants, metamorphic relationships, or comparison
      with a simple reference implementation. Generation targets inputs and
      states likely to reveal plausible bugs, not low-value dimensions such as
      arbitrary seeds. Use a compact table when a property's oracle becomes
      complex.
- [ ] Examples, strategies, fixtures, and helpers use the simplest setup and
      readable assertions that establish the intended behavior. They make
      adding cases easy and stay resilient to implementation changes, without
      building a new harness for trivial behavior. Smoke tests stay short.
- [ ] No mocks or monkeypatching, including of configuration or external
      integrations, without a concrete justification; the boundary itself is
      not one. Mocks and reaching into internals couple tests to the design:
      suggest the design change that makes the code testable through its
      public interface.
- [ ] Performance assertions measure the intended system behavior, rather than
      implementation proxies. Do not run mutation tests to assess suite quality.

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
