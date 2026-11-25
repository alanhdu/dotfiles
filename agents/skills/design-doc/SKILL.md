---
name: design-doc
description:
  Write or revise a design document for a change before it is implemented, in
  the user's format (motivation, RFC 2119 requirements, design, competitive
  alternatives). Use when the user asks for a design doc.
---

# Design doc

A design doc exists so the user can decide what to build. Argue the design, not
whether the project is worth doing. Exploring, choosing, and justifying are
your work: show enough of the design space that the user understands the
choices in it, then be opinionated about which option is best and why (and what
would change your mind).

[TEMPLATE.md](TEMPLATE.md), in the same directory as this file, gives the usual
sections. Add or drop sections as the design needs, and let the length follow
the decision: an unambiguous change may need under 100 words.

## What the reader needs

- **Why change anything.** How the code works today, what is wrong with it, and
  what that costs, grounded in the real code and use cases. A design can only
  be judged against its problems, so the motivation is the last place to cut.
  - Assume the reader has not read this part of the code. Introduce each
    existing class or function the design touches with what it does and its
    real signature before relying on its name.
- **What must hold.** Requirements separate what is needed from what merely
  exists. RFC 2119 keywords in upper case (MUST, SHOULD, MAY) force that
  distinction: which constraints are fixed, and which are preferences the
  design may trade away. Don't invent requirements or inherit them from
  existing code: either narrows the design space without anyone deciding to.
  - Existing interfaces can change, but say what is wrong with the current
    one, and balance the gain against the cost of migration. Changing an
    existing interface with few, local users is cheap while changing a
    widely-used interface requires a good justification to make it worth the
    trouble.
- **What the interfaces are, and why each exists.** The user evaluates a design
  at its interfaces. For each new or changed one, give:
  - **Its justification.** Which problem or requirement it answers, what a
    caller cannot do without it, and why nothing simpler or already existing
    does the job. Cut anything that has no such answer.
  - **Its concrete form.** Full signatures with types, data shapes, and a few
    lines of calling code: precise enough to object to a specific choice.
  - **Its room for named future work.** Future work the user names should need
    only additions, not rework. Say what each would add, and add nothing for it
    now.
- **What else was possible.** Alternatives expose the tensions in the design
  space, and give the user somewhere to go if they weigh the tradeoffs
  differently than you do. So each must be a choice someone could reasonably
  make: no strawmen, no variants that differ in a minor detail, and nothing
  another option beats on every count. Give each enough substance to be
  chosen: how it works and how it fares against each problem. Recommend one,
  and say why and at what risk.
  - When the user names a direction, work that one out in full first: they
    asked because they could not yet see its details, and a draft that
    recommends something else leaves their question unanswered. Recommend
    against it only on evidence you measured, and say so up front.
- When the end state is too large to land at once, describe intermediate
  milestones we can aim for that implement part (but not the whole) of the
  design to deliver value incrementally.

## Principles

- The user often reads the design doc days later, when the code, doc history,
  and conversation are out of context. Ensure the design doc makes sense
  stand-alone.
  - Describe decisions, not edits. The code moves quickly, so anything that
    mirrors it (lists of files, call sites, lines to change) goes stale within
    days, and an implementer finds it faster by reading the code. Focus on what
    lasts: the intended interfaces and the constraints that are not visible in
    the code.
- The user iterates on these documents over many turns. Report what changed in
  chat instead of pasting the document.
  - A changed decision should reach every passage that relied on the old one
    (a formula, a signature, a table cell), so no stale information is left
    for an implementer to follow.
  - Passages the change does not affect should stay as they were, so the
    user's acceptance of them is not invalidated.
- Use the codebase's vocabulary, one noun per concept, and define each in the
  glossary: every new term is something the reader must learn before they can
  assess the idea. Avoid extremely generic words like "row" or "table" that
  cause confusion because of how ambiguous they are.
- Split open questions by who can answer them. Empirical ones (how does X
  work, how fast is Y, what is the prior art) are yours: settle them before
  recommending to avoid wasting the user's time. Questions of values,
  priorities, and tradeoffs are the user's: surface them (in the chat) instead
  of guessing, and clarify an ambiguous request before designing around one
  reading of it.
  - Measurements are useful when they resolve a design tension or answer a
    specific question. Where the choice hinges on an empirical fact, measure it
    so the user is not handed an unknown. Benchmarking for completeness or "just
    in case" delays the document without changing the choice.
- Work from the merged code and what the user gives you. Do not read their other
  design documents for content: some are stale, and some were deliberately
  abandoned or never implemented. Do not describe their in-progress
  implementation either: it changes as they iterate, so the document would be
  wrong within hours.