---
name: design-doc
description:
  Write or revise a design document for a change before it is implemented, in
  the user's format (motivation, RFC 2119 requirements, design, competitive
  alternatives). Use when the user asks for a design doc, design, plan, or
  proposal for how something should work.
---

# Design doc

A design doc exists so the user can decide what to build. You are pitching it,
as a junior engineer would to a senior one: exploring, choosing, and justifying
are your work, and the user's part is to be convinced or to disagree. They read
it without the conversation, often without the code open, and possibly after
the code has moved. The guidance below follows from that reader; use judgment
where it does not reach.

[TEMPLATE.md](TEMPLATE.md), in the same directory as this file, gives the usual
sections. Add or drop sections as the design needs, and let the length follow
the decision: an unambiguous change may need under 100 words.

## What the reader needs

- **Why change anything.** How the code works today, what is wrong with it, and
  what that costs, grounded in the real code and use cases. A design can only
  be judged against its problems, so the motivation is the last place to cut.
- **What must hold.** Requirements separate what is needed from what merely
  exists. RFC 2119 keywords in upper case (MUST, SHOULD, MAY) force that
  distinction: which constraints are fixed, and which are preferences the
  design may trade away. Don't hallucinate requirements or blindly inherit
  them from the existing code: that narrows the design space without anyone
  having decided to.
- **What it would be like to use.** The user evaluates a design at its
  interface: signatures, data shapes, a few lines of calling code, who owns
  what, and how the parts work together. It should be concrete enough that they
  can object to a specific choice.
- **Whether it solves the problem.** Each part of the design should trace back
  to a problem or requirement and say what it removes as well as what it adds.
  Claims worth doubting need evidence aimed at that doubt, such as a prototype
  or a measurement, not an implementation of the design.
- **What else was possible.** Alternatives show the real tensions, but only if
  each could plausibly win or has actually been proposed; strawmen suggest the
  space was not explored. Recommend one, and say why and at what risk.

## The level of abstraction

Describe decisions, not edits. The code moves quickly, so anything that mirrors
it (lists of files, call sites, lines to change) goes stale within days, and an
implementer finds it faster by reading the code. What lasts is what the code
cannot tell them: the intended interfaces, the order of the work and why each
step is useful on its own, and the constraints that are not visible in the
code. One test is whether a sentence will still be true after unrelated commits
land.

A document can also fail by being too abstract: a sketch of aspirations that
names things without saying what they are gives the user nothing to evaluate.
When in doubt, be concrete about the interface and silent about the
implementation.

## Writing and revising

The document stands alone. The reader needs the design, not the history of how
it was reached, so leave out earlier drafts and the conversation. Use the
codebase's vocabulary: every new term is something the reader must learn before
they can assess the idea. Being succinct means cutting repetition, not
information.

The user iterates on these documents over many turns. Edit rather than rewrite,
so sections they have accepted stay as they were, and report what changed in
chat instead of pasting the document. Settle by investigation what
investigation can settle. Ask the user only for what only they can know, such
as goals, priorities, and constraints that are not in the code; a question they
could answer no better than you hands the work back to them.
