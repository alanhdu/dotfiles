# Architecture review

## Checklist

- [ ] The design conforms to the design preferences in AGENTS.md; this
      checklist elaborates them.
- [ ] Every new type and function owns an independent decision, invariant, or
      contract that is worth more than the direct implementation. Flag
      unnecessary or premature abstraction, and valid abstractions that could
      move down the inline code → function → class → protocol ladder. Flag
      helpers that merely split one operation across files, making readers
      reconstruct its state and control flow across boundaries. Invariants,
      contracts, and implementations are not repeated across boundaries.
- [ ] Flag "false" abstractions that merely reuse code: every shared field
      and parameter has meaning in every supported use case. Prefer separate
      representations and some duplication over fields carried solely for
      another use case.
- [ ] Dependencies flow in the intended direction. A layer does not reach into
      another's implementation to recover information its interface should
      supply.
- [ ] Files and modules live with the responsibilities they own. Durable shared
      behavior belongs in its owning package, rather than beside its first
      experiment or caller; experiment-specific behavior stays out of shared
      libraries.
- [ ] Interfaces express the information their callers need. Inspect actual
      callers' guarantees rather than inventing additional input states to
      handle.

Establish what the code actually does. Explicitly requested generality is a
requirement; a single implementation alone does not invalidate an extension
point.

## Examples

### Tidy layers that are unnecessary

Checkpointing arrives as `CheckpointManager` → `CheckpointStore` →
`StorageBackend` protocol, with one `GCSBackend`. Each layer is small, typed,
and documented, and each method forwards to the next with the same arguments.
The layering looks clean, but no layer owns an independent decision: the
protocol has one implementation and no requested second backend, and the
manager adds nothing the store does not. Recommend one `save_checkpoint` and
`load_checkpoint` pair over the storage client, and name what would justify
reintroducing a backend boundary, such as a requested local-disk backend.

### A shared shape that is a false abstraction

SFT and RL trainers share a `TrainerConfig` with `lr`, `batch_size`,
`reward_model_path`, and `kl_coef`. The last two mean nothing for SFT, which must
carry and ignore them. Sharing saves two duplicated scalar fields and costs
every reader of the SFT trainer a question about rewards. Recommend separate
configs. A common base class for `lr` and `batch_size` is also unwarranted
unless some caller treats both trainers uniformly.

### Placement depends on future intentions

A numerical method lives in an experiment module. Its interface is stable and
independent of that experiment, but it still has only one caller. Moving it into
a shared numerical package could give it a clearer owner, while also suggesting
that it is maintained for general use. The reviewer cannot know whether the user
intends that commitment. Surface the possibility and explain the tradeoff for
the user to decide; leave the code in place and continue the review. This is not
an established architectural defect or a reason to block other reviewers.
