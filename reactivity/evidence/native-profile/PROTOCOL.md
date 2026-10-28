# Matched-profile native diagnostic

Preregistered before compilation or measurements. This is an application-path
diagnostic, not an adoption trial or a replacement for any failed performance
gate. The two sparse-repair trials remain rejected. Native wheel/gesture parity,
render-quality equivalence, physical GPU and two-hardware-class gates stay open.

Use three independent worktrees and targets: corrected original plus qualified
deferred controls (6a3ae55a05a25fd12b53304d795fc1e0136af73f); static sparse repair
(5cec749179f43f50abc18d7512b7e90ae402bb0a) with that exact control example copied
over; pinned ZGX component adapter (a3678578980ef239058c557338ef9c544d356b0c).
Do not change production library code or the reference adapter. Check complete
source identities and preserve build artifacts/fingerprints before execution.
Compile all three with nightly-2026-10-23, release opt-level3, fat LTO, one
codegen unit, debug0, no stripping, unwind panic. Capture effective overrides,
commands and Cargo JSON. Fresh per-worktree targets; locked/offline builds.
Run the 17 GPUI public port tests for both compositions under the same profile.
Run the reference component example tests. Existing production qualification is
inherited by exact source equality, not claimed rerun. Shader identity remains
required. Check at least12GiB free before a fresh large build and8GiB throughout;
preserve evidence before removing only regenerable completed caches.

Native environment: owned X11 :94, 960x720 client, same DejaVu Sans file, scale1,
llvmpipe Vulkan, LP_NUM_THREADS=4. No physical-display performance claim. Keep
the reference wheel resampler enabled/default and GPUI defaults unchanged.
Automatic idle/stream/scroll/both workloads do not inject wheel/control events.
This narrower diagnostic does not qualify manual interaction equivalence.
No concurrent benchmark, native script, compilation or cleanup during timing.

Before timing: perform one untimed warm-up per executable/mode. Capture an
external native image for each executable at initial_ticks190, idle, including
client size/font receipts; record visible differences without relaxing exact
GPUI-internal image gates or claiming cross-renderer pixel equality. Check final
workload logs and native process cleanup. Preserve every failed preflight.

Then run six balanced groups per mode, each of the six executable permutations
once, shuffle seed20261101. Eight-second automatic workload lifetime per process.
GPUI emits WORKLOAD_FINISHED and remains open; the harness closes it after that
marker, requiring normal exit. ZGX closes itself. Capture /proc process CPU/RSS
samples throughout. Primary descriptive interval: first visible window +1s to
+6s (only endpoints actually observed while process lives). Report interval
length, CPU seconds, average/max sampled RSS and delivered ticks separately.
Report startup/whole-process values separately, including their different timer
start boundaries; never use them as equal-work per-frame latency. Record all
raw logs/samples, actual executable identity, order and environment. No trace
logging in timed runs, no selective repetition or acceptance threshold. A lost
process/short interval/wrong renderer/insufficient work is a failed observation,
preserved and excluded from ratio inference with explicit reason.

Aggregate medians and all paired ratios with uncertainty only as diagnostics;
unequal admitted work invalidates a performance ranking. CPU use of software
Vulkan includes rasterization and worker scheduling. Native submission/visible
cadence needs separate instrumentation; neither ticks nor host ACKs establish
physical presentation. A lower CPU result cannot establish a victory by itself.
Use these observations to choose the next architectural measurement, not tune
microbenchmarks until they pass. Keep everything local.
