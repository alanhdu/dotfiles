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

## Experiment design

Before experimenting, identify what remains unknown and what evidence would
change the next decision. Choose the cheapest sufficient method.

Inspect existing evidence first. Pilot cost and variance before scaling;
reuse setup, artifacts and valid checks, and eliminate unnecessary work
inside the experiment. Size measurements to the required precision.
Stop when the question is resolved; repeat or expand only for a named
uncertainty or changed condition.

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
* Retain an optimization only when a material benefit is demonstrated at the
  agreed reporting boundary, with measurement uncertainty assessed.
* Every change should have a hypothesis attached to it: why do we expect this to improve performance?
  What is the "best case" we can expect (based on the measurements and roofline-like analysis)?
  Negative results (where we see no speed-ups) are important for updating our mental model and forming
  better hypotheses in the future.
