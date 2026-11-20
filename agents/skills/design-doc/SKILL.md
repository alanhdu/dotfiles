---
name: design-doc
description:
  Write or revise a design document for a change before it is implemented, in
  the user's format (motivation, RFC 2119 requirements, design, competitive
  alternatives). Use when the user asks for a design doc.
---

# Design doc

A design doc exists so the user can decide what to build. You are pitching the
design's shape, not the project, as a junior engineer would to a senior one:
exploring, choosing, and justifying are your work, and the user's part is to be
convinced or to disagree. They read it without the conversation, often without
the code open, and possibly after the code has moved. The guidance below
follows from that reader; use judgment where it does not reach.

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
  Claims the design rests on need evidence: measure before writing, so the user
  is not handed an unknown. Do not measure things that do not impact the
  design.
- **What else was possible.** Alternatives show the real tensions, but only if
  each could plausibly win or has actually been proposed; strawmen suggest the
  space was not explored. Recommend one, and say why and at what risk.


## The level of abstraction

Describe decisions, not edits. The code moves quickly, so anything that mirrors
it (lists of files, call sites, lines to change) goes stale within days, and an
implementer finds it faster by reading the code. What lasts is what the code
cannot tell them: the intended interfaces, the constraints that are not
visible in the code, and, when the end state is too large to land at once, the
stages of the migration and what part of the design each one delivers. One test
is whether a sentence will still be true after unrelated commits land.

Existing interfaces can change, but that must be balanced against the cost
of migration. Changing an existing interface with few, local users is cheap
while changing a widely-used interface requires a good justification to make
it worth the trouble.

A document can also fail by being too abstract: a sketch of aspirations that
names things without saying what they are gives the user nothing to evaluate.
When in doubt, be concrete about the interface and silent about the
implementation.

## Writing and revising

The document stands alone. The reader needs the design, not the history of how
it was reached, so leave out earlier drafts and the conversation. Use the
codebase's vocabulary, one noun per concept, and define each in the glossary:
every new term is something the reader must learn before they can assess the
idea. Being succinct means cutting repetition, not information.

Work from the merged code and what the user gives you. Do not read their other
design documents for content: some are stale, and some were deliberately
abandoned or never implemented. Do not describe their in-progress
implementation either: it changes as they iterate, so the document would be
wrong within hours.

The user iterates on these documents over many turns. Edit rather than rewrite,
so sections they have accepted stay as they were, and report what changed in
chat instead of pasting the document. Settle by investigation what
investigation can settle, before recommending as well as before asking: a
recommendation that later reverses was made too early. Ask the user (in the
chat) only for what only they can know, such as goals, priorities, and
constraints that are not in the code; a question they could answer no better
than you hands the work back to them.
