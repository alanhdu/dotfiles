---
name: measure-performance
description: >-
  Measure throughput or diagnose CPU/GPU bottlenecks and hangs in running jobs.
  Use for profiling, benchmark comparisons, utilization checks, and unexplained
  stalls.
---

# Measure performance

## Methodology and experiment design

- Use an existing benchmark or a user-approved reporting boundary; keep other
  proxies internal.
- Enumerate required rows/candidates, units, uncertainty and observed rejection
  criteria. Reconcile every cell; distinguish backend families from tuning variants.
- Match the production execution path, compilation/reuse contract and timed work.
  Verify a representative case against its source and generated artifacts before
  scaling. Preserve the contract across runs; reconcile changes before comparing.
- Reuse evidence, identify the next decision and reserve resources to finish.
  Stop methods that answer no remaining question; preserve any user-reserved
  selection decision.
- For a known fault with an available fix, test the ordinary corrected version
  before adding instrumentation; hold unrelated dependencies fixed.

## Measurement Procedure

Prefer light-weight measurements that do NOT require changing proxy code (like
`py-spy` or `nvidia-smi` or `htop`).  Use existing logs/counters/timestamps
to calculate relevant metrics (e.g. throughput) where possible.

Any changes to production code to profile has a high chance of changing the
performance characteristics and must be done carefully (and avoided where
possible)

## Optimization Procedure

Optimizations should be done in a profile-driven and hypothesis-driven way. General principles:

* Always start by measuring the existing process. What are the bottlenecks? Where is time going?
  Report this to the user first (including flamegraphs, tables, theoretical formulas, etc)
* Always estimate the "best case" improvements for any change first (e.g. based on the measurements and 
  simple roofline-like analyses). Prioritize the largest bottlenecks first (areas with the most
  opportunity for improvement)
* Measure uncertain or potentially material improvements at the agreed reporting
  boundary. For clearly beneficial, simple changes with obviously minor impact,
  run correctness checks and skip expensive before/after measurements.
* Every change should have a hypothesis attached to it: why do we expect this to improve performance?
  What is the "best case" we can expect (based on the measurements and roofline-like analysis)?
  Negative results (where we see no speed-ups) are important for updating our mental model and forming
  better hypotheses in the future.
