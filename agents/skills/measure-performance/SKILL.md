---
name: measure-performance
description: >-
  Measure throughput or diagnose CPU/GPU bottlenecks and hangs in running jobs.
  Use for profiling, benchmark comparisons, utilization checks, and unexplained
  stalls.
---

# Measure performance

## Methodology and reporting

Separate reporting metrics (which you hand to the user) and proxy metrics
(which can be cheaper metrics to guide internal work). Reporting metrics
should either use standard, existing benchmarks OR must be validated by the
user. Proxy metrics do not need to be approved by the user, but should never
be used when reporting results. Unapproved proxies guide internal work only.

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
* Ignore irrelevant optimizations that cannot possibly move-the-needle (e.g. <4% improvements),
  The exception is if you can identify many such small optimziations that can plausibly "stack"
  to yield a big improvement.
* Every change should have a hypothesis attached to it: why do we expect this to improve performance?
  What is the "best case" we can expect (based on the measurements and roofline-like analysis)?
  Negative results (where we see no speed-ups) are important for updating our mental model and forming
  better hypotheses in the future.