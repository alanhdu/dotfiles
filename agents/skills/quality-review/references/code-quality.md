# Code quality and documentation

Assess whether the implementation expresses its responsibilities clearly. Apply
AGENTS.md preferences and the codebase's established terms and style. Simplicity
concerns the design and the reader's work, not an arbitrary line count.

## Implementation checklist

- [ ] Straight-line code is used where it expresses the behavior clearly.
      Control flow makes unconditional work and loop exit conditions apparent.
- [ ] Each function or class represents an abstraction, not merely reuse. A
      helper should express a coherent concept or contract; removing duplicate
      lines alone does not justify one.
- [ ] New abstractions earn their complexity. Consider missing, misplaced, and
      unnecessary abstractions; removing all abstractions is not the objective.
- [ ] Required generality is preserved. Avoid special cases based on exact
      object identity, implementation classes, or one benchmark's settings where
      the intended behavior is general. One implementation does not invalidate
      an extension point.
- [ ] Internal typed APIs rely on valid inputs and owning-layer guarantees
      rather than speculative defensive branches. Check actual callers when
      changing APIs.
- [ ] The simplification removes complexity rather than hiding it, moving it to
      callers, or compressing it into opaque expressions. Do not code golf.

If a problem comes from misplaced responsibilities, identify that boundary
instead of offering only a local workaround. Flag code likely to be replaced by
an architectural correction rather than polishing its details.

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
