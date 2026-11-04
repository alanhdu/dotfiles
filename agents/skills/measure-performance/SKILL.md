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
like `py-spy`, utilization tools like `nvidia-smi` and `htop`, and existing logs,
counters, and timestamps (e.g. throughput from step-time logs).

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
