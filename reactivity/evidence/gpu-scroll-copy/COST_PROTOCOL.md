# Complete GPUI publication and GPU completion cost gate

Registered before cost measurements. Extend the52aff0e85903 protocol; retain its
20% scroll AND mixed minimum gain and5% control regression ceiling. Production
candidate49514e3cb6 (subsequent commits only tests/example visibility), baseline
4afe067fe3e243fac40369301321f44962aa808d. The identical test-only workload fixture and
cost harness are overlaid in a separate baseline worktree and target. No source
threshold tuning after results. Use the pinned content-fingerprint release flags,
private X11:94 and explicit CPU Vulkan/LP_NUM_THREADS=4. Complete both source guards,
strict Clippy, pixel and negative gates before timing. No compiler/test/allocation
probe/cleanup overlaps timed runs. Keep >=8GiB free.

This is the complete public model update/scene publication plus production native
packet bridge, offscreen GPU completion and ACK. It excludes swapchain presentation,
OS event dispatch, the producer thread and scanout. The exact stream case invokes
the same registered Source directly; owner cases invoke the unchanged UI-thread
Driver.owner. This micro gate only admits a native end-to-end trial. It is neither
a hardware GPU result nor a comparison against ZGX.

Cases, fixed order labels: scroll, both, stream, stream-owner, fractional,
flat-tiny, flat-full, list-tiny, list-flat, exposure. Actual native workload model, font and190 seed ticks
for the first five/exposure. Scroll delta14; fractional adds0.5 each tick after
Driver.owner so every requested delta14.5 must reject copy. Flat cases8x8 and512x512
change their registered fill source each frame. List controls have100K alternating
solid rows and no glyphs:16x16 viewport/4px rows/delta1 on32x32, and920x400
viewport/28px rows/delta14 on960x720. They exercise admitted reuse when raster
work is cheap; they remain5% regression controls. Exposure changes no source and
uses the same acknowledged token; do not describe exposure as an idle UI. Actual
native idle separately must remain zero timer ticks/one initial ACK (existing
native port correctness gate). No fabricated zero-operation idle latency score.

Each process runs exactly one case and implementation. Measure mount separately,
first complete render separately, then16 warmup operations and64 measured complete
operations. Include all lazy scratch allocation in first admitted warmup and report
all warmup samples, without mixing warmup into primary medians. Record per-frame
composited/copy pixels and retained image bytes, final source epoch and exact pixel
hash. After timing, compare the final complete image against an independent full GPU
renderer; canonical command/work and hash/epoch must match across implementations.
Candidate scroll/both must copy on all80 updates; fractional and text/flat controls
must never copy overlap. Exposure retains only the full presentation copy.

15 independent process pairs per case (300 timed processes), deterministic shuffle
seed20261027. Within each pair alternate candidate-first/control-first by pair index
and case index. Freeze the complete JSON job order before execution. Compute each
process median/p50/p95/p99 over64 measured frames; report paired candidate/control
ratios, medians and paired bootstrap95% intervals (10000 resamples, seed20261027).
Primary acceptance: median ratio<=0.80 for both scroll and both; every other case
median ratio<=1.05. Do not round a failure to the boundary. Report uncertainty even
if point gates pass. Cold mount/first-render, warmups and per-frame tails remain
separate reported costs, never silently excluded.

Before timing, run three correctness-only processes per case/implementation with
four measured operations. Preserve failures; use them only for oracles/counts, not
rankings. Run separate allocation processes after correctness, one per case/variant,
recording mount plus first-frame and20 operations (16warm+4) on the invoking thread.
Allocator bookkeeping cannot attribute other driver threads; report that limit.
Explicit GPU image/copy/repair counters supplement rather than replace allocation
records. Inventory production lines, headers, whole production ELF and relevant
function/stack sizes separately. No application API change is needed for reuse.
