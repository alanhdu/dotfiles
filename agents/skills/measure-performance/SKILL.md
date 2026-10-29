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
like `py-spy`, `nvidia-smi`, `htop`, and existing logs, counters, and timestamps
(e.g. throughput from step-time logs).

Adding timers, synchronization, or logging to production code can change its
performance characteristics. Do it only when nothing lighter answers the
question, and say so when reporting.

## Report end-to-end results

The goal is end-to-end performance of the real workload on its production
execution path, such as training-step tokens/s. Use an existing benchmark or a
reporting boundary the user agrees to. Keep inputs, compilation and warmup, and
hardware fixed across runs; reconcile any change before comparing.

Microbenchmarks and other proxies are useful internal tools for locating
bottlenecks and guiding work, but they are not the result. Report them only as
supporting evidence for an end-to-end number.

## Work from profiles and hypotheses

Optimizations should be done in a profile-driven and hypothesis-driven way.
General principles:

- Always start by measuring the existing process. What are the bottlenecks?
  Where is time going? Report this to the user first (including flamegraphs,
  tables, theoretical formulas, etc).
- Always estimate the "best case" improvements for any change first (e.g. based
  on the measurements and simple roofline-like analyses). Prioritize the
  largest bottlenecks first (areas with the most opportunity for improvement).
- Measure uncertain or potentially material improvements at the agreed reporting
  boundary. For clearly beneficial, simple changes with obviously minor impact,
  run correctness checks and skip expensive before/after measurements.
- Every change should have a hypothesis attached to it: why do we expect this to
  improve performance? What is the "best case" we can expect (based on the
  measurements and roofline-like analysis)? Negative results (where we see no
  speed-ups) are important for updating our mental model and forming better
  hypotheses in the future.

## Example: a slow training run

Training reaches 40% of the expected tokens/s. Swapping in a faster attention
kernel is a guess; a microbenchmark would show it 1.3× faster and still change
nothing end-to-end. Instead, sample the running job with `py-spy dump` and watch
`nvidia-smi`: GPU utilization oscillates, and stacks sit in the data loader's
tokenization. The hypothesis is an input-bound run whose best case is the GPU
step rate already visible in the step logs between stalls. Move tokenization to
preprocessing, then report end-to-end tokens/s before and after.
