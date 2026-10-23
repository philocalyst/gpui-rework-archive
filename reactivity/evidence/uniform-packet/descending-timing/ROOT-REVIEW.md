# Descending cursor: complete timing campaign, acceptance failed

The preregistered 11-pair AB/BA campaign completed all 22 fresh processes in
269.193 seconds. All 6,864 frames and 2,288 raw readbacks remain. Correctness
passes: every required paired image matches, and all 3,432 paired warm/cold
Stats/ImageStats rows match except the intended 2,048-byte cursor deletion.
No source, binary, compiler, quiet-window or deadline guard failed. Other teams
held all compilation, tests, native execution and source writes during capture.

**The complete per-cell regression gate fails. Memory-slice adoption therefore
fails.** Twenty-five of 26 cells fail at least one rule on both host and total
metrics. There are 93 failed rules: 48 ninth-sorted ratios exceed 1.01 and
45 maximum-frame ratios exceed 1.10. No cell has nine or more slower paired
medians; that does not cancel the other bounds. Only text-background SDR/static
passes both complete metric gates. Historical speed qualification also fails.

The median equal-cell geometric ratios are 0.9845815012 host and 0.9891284112
total, with seven and eight faster pairs respectively. These aggregates do not
offset individual failures. The largest host maximum-frame ratio is 3.9847314
for moving SDR layers in pair ten: 672,794 versus 168,843 ns. The largest total
maximum-frame ratio is 2.4548023 for moving SDR flat fill in pair six: 1,316,319
versus 536,222 ns. These compare the maximum sampled frame within each lane's
cell, as fixed before execution; they are not matching-frame-index ratios.

Root independently reopened all 11,442 payloads, 1,827,212,495 uncompressed
bytes, and all nineteen external artifact records. Root then reparsed all raw
CSVs without importing the agent's analyzer: all 52 metric/cell outcomes,
medians, ninth order statistics, maximum ratios and work-counter comparisons
agree. The independent report and implementation are included alongside the
sealed original campaign. Full source/configuration, exact matched binaries,
calibration, missing-readback control, first preflight text-audit failure and its
premeasurement correction remain preserved.

Shipping GPU remains `7a5e1619a27010ec63f6c27506a6d1fcd113f67c`.
Candidate `1c97566cf0a7140d4f258deab136342a609d5755` is not adopted. Its
separate storage/static correctness proof remains valid but does not establish
runtime nonregression. There was no retry, workload omission, threshold change
or post hoc sample exclusion. These llvmpipe wall clocks do not identify a unique
cause for the tails or establish hardware GPU behavior, startup, RSS or foreign
runtime performance.
