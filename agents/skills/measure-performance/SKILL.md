---
name: measure-performance
description: >-
  Measure throughput or diagnose CPU/GPU bottlenecks and hangs in running jobs.
  Use for profiling, benchmark comparisons, utilization checks, and unexplained
  stalls.
---

# Measure performance

## Measure without perturbing

Prefer measurements that do not change what they measure: sampling profilers
like `py-spy`, utilization tools like `nvidia-smi` and `htop`, and existing
logs, counters, and timestamps (e.g. throughput from step-time logs).

Adding timers, synchronization, or logging to production code can change its
performance characteristics. Do it only when nothing lighter answers the
question, and say so when reporting.

## Match the measurement to the claim

Choose the measurement boundary from the question being investigated. State
what operation is timed, what work it completes, and what is excluded. Prefer
the real execution path at that boundary: omitted coordination, preparation,
or waiting can change which operation is actually the bottleneck.

Keep useful work and execution conditions comparable across runs; reconcile
differences before attributing a result to the change. Rates are comparable
only when their units represent comparable work.

Use narrower measurements to isolate causes. Their conclusions apply to the
measured boundary: speeding up a component does not establish that its caller
gets faster, because other work or resource contention may dominate. Measure
the caller when making a claim about the caller's performance.

## Work from profiles and hypotheses

- Always start by measuring the existing process. What are the bottlenecks?
  Where is time going? Report this to the user first (including flamegraphs,
  tables, theoretical formulas, etc).
- Attach a hypothesis to every change before making it: why should it improve
  performance, and what is the "best case" based on the measurements and simple
  roofline-like analysis? Prioritize the largest opportunities first.
- Measure uncertain or potentially material improvements at the agreed reporting
  boundary. For clearly beneficial, simple changes with obviously minor impact,
  run correctness checks and skip expensive before/after measurements.
- Negative results (where we see no speed-ups) are important for updating our
  mental model and forming better hypotheses in the future.

## Example: a slow training run

Training reaches 40% of the expected tokens/s. Swapping in a faster attention
kernel is a guess; a microbenchmark would show it 1.3× faster and still change
nothing end-to-end. Instead, sample the running job with `py-spy dump` and watch
`nvidia-smi`: GPU utilization oscillates, and stacks sit in the data loader's
tokenization. The hypothesis is an input-bound run whose best case is the GPU
step rate already visible in the step logs between stalls. Move tokenization to
preprocessing, then report end-to-end tokens/s before and after.
