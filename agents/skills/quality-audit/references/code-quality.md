# Code quality and documentation

Assess whether the implementation expresses its responsibilities clearly. Apply
AGENTS.md preferences and the codebase's established terms and style. Simplicity
concerns the design and the reader's work, not an arbitrary line count.

## Implementation checklist

- [ ] [Push ifs up and fors down](https://matklad.github.io/2023/11/15/push-ifs-up-and-fors-down.html)
      - Excessive branching (e.g. >=4 branches) is evidence that an abstraction
        is needed: promote the varying behavior up the inline code →
        function → class → protocol ladder, such as to polymorphism.
- [ ] Defensive checks exist only where an error would otherwise surface far
      from its cause (e.g. validating user input) or the code would silently
      return incorrect results. Do not check or coerce what types enforce or
      what would already fail with an obvious error, such as a dtype mismatch;
      document the intended input and let the caller provide it.
- [ ] We avoid deep indentation by introducing local variables where necessary.
      Avoid multiple consecutive new lines of just closing delimiters (like `),\n]\n}`).
- [ ] Code density is appropriate. Blocks of >15 lines of code are broken up with
      1-line comments and/or new lines.
- [ ] Functions that are called once are inlined, *unless* they represent a
      very important abstraction boundary (e.g. that is independently checked
      in tests).
- [ ] All parameters of every function/class compose. Setting a parameter does
      not magically cause other parameters to be ignored.

If a problem comes from misplaced responsibilities, identify that boundary
instead of offering only a local workaround. Flag code likely to be replaced by
an architectural correction rather than polishing its details.

## Example: which defensive checks earn their place

An attention function starts with `q = q.float().contiguous()`, then
`k = k.to(q.dtype)` and `v = v.to(q.dtype)`, and its callers cast again before
calling it. The `Tensor` type does not enforce dtype, but a mismatch already
fails in the matmul with an obvious error. Remove the casts, document the
expected dtype and layout, and let callers pass it.

Two checks in the same codebase do earn their place:

- **The error would surface far away.** A user-written `run_spec.yaml` without
  a `name` would otherwise fail at W&B initialization, after the image build
  and queue wait. Reject it when parsing the spec.
- **The result would be silently wrong.** A loss computed from `logits` of shape
  `(B, 1)` and `labels` of shape `(B,)` broadcasts to `(B, B)` and returns a
  plausible scalar. Check the shapes there.

## Example: similar optimization loops

Two optimization algorithms have similar convergence loops but different update
rules and state. A shared loop with callbacks would remove duplication, while
separate loops would keep each algorithm directly readable. Several
considerations matter together:

- Is there an inherent shared structure? If both loops are instances of the same
  mathematical process, such as Euler-style stepping in ODE and SDE solvers,
  sharing may express a real concept rather than a coincidence in the code.
- Is coupling desirable? When one loop changes, should the other receive the
  same change for the same reason? Sharing is less attractive when the
  algorithms should evolve independently.
- How much evidence supports the abstraction? With only two cases, lean toward
  keeping them separate unless the shared structure and desired coupling are
  clear. Three or more cases provide more evidence of a common abstraction,
  rather than automatically justifying one.
- Who controls execution? Even when sharing is warranted, callbacks transfer
  control from the individual algorithms into the shared loop. Prefer explicit
  loops driving a shared state machine or stepping abstraction over a framework
  driving callbacks.

The judgment could favor sharing while rejecting the proposed callback
interface. It does not require introducing a state-machine class; the
representation should earn its complexity too.

## Documentation checklist

- [ ] Comments explain durable knowledge a reader needs, not the next line of
      code or the conversation that produced it. Tests do not repeat their names
      in prose.
- [ ] Docstrings describe the interface, including non-obvious parameter
      meaning, shapes, units, or guarantees. They do not narrate implementation
      or design history.
- [ ] Use no docstring for self-evident functions and a one-liner when
      sufficient. Where interface detail is needed, use Google-style `Args`,
      `Returns`, and `Raises` sections as applicable, matching the project's
      conventions.
- [ ] A confusing explanation prompts examination of the API itself. Do not
      write a longer explanation to excuse an unnecessarily confusing interface.
- [ ] A README provides orientation and a starting point. Place detailed
      contracts near their definitions; avoid adding a report of completed work
      to product docs.