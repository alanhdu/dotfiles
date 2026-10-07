---
name: measure-performance
description: >-
  Measure throughput or diagnose CPU/GPU bottlenecks and hangs in running jobs.
  Use for profiling, benchmark comparisons, utilization checks, and unexplained
  stalls.
---

# Measure performance

Choose the least intrusive evidence that answers the user's question. State
the metric, workload, and comparison interval before interpreting a result.

1. Check existing logs, counters, and timestamps first. Derive throughput from
   recorded work and elapsed wall time; distinguish data tokens from model
   tokens and training time from evaluation or startup time. Compare equivalent
   intervals and hardware.
2. For CPU bottlenecks, sample the existing process with `py-spy top` or
   `py-spy record`. For an apparent hang, start with `py-spy dump -p <pid>`
   and inspect all relevant worker processes. A Python stack sample does not
   measure time spent inside GPU kernels.
3. For GPU behavior, inspect existing device telemetry (for example DCGM or
   `nvidia-smi`) before using a GPU profiler. Use Nsight Systems or Nsight
   Compute when kernel timing or SM activity is the unresolved question, and
   account for profiler overhead.
4. Keep the measured workload unchanged for the baseline. Add in-loop timers,
   CUDA synchronizations, profiler hooks, or new metric logging only when
   existing records and external tools cannot answer a specific question. If
   instrumentation is needed, isolate it from the baseline and measure its
   overhead.

Report the source, calculation, observed interval, and limits of the evidence.
If the data cannot support a claim about utilization or a bottleneck, say what
measurement would resolve it.
