# Native trial of the qualified publication workspace — preregistration

No new production implementation and no native measurement at this checkpoint.
Candidate base 41a67473a0177fbb17df1f7b8e2f2f36dd6940f6 passes the complete local
112/112 point, six allocation, all correctness/work/header and negative-control
gates in independently verified dossier f7b3f60c70faf6d548fffda530d4de83b2570e34.
This trial asks whether the composed gains reach the actual native event loop.
It carries no new application API, example, shader, library or dependency change.
Unique worktree /home/user/gpui-native-workspace-lab, target
/home/user/gpui-native-workspace-target, external evidence
/home/user/gpui-native-workspace-evidence. All work stays local.

## Complete alternatives and qualification

Four variants: original control 20919cb160f6, prior static sparse c965a893364b,
new workspace candidate, and ZGX a3678578980e. Reuse the three exact preserved
native-profile ELFs only after checking immutable source inputs, profile, actual
bytes, shaders and recorded tests. The earlier profile diagnosis remains failed
at a7fbf5e2fe5807d1eb87021918d210e9d65a693e. Do not rerun or reinterpret it.
The new candidate compiles in its own fresh target. Freeze a clean source commit
before building; record all inputs, failures, Cargo JSON/freshness, generated
shader bytes embedded in the actual executable, and before/after guards.

Match the prior profile exactly: nightly-2026-10-23, opt3, fat LTO, one codegen
unit, debug0, no stripping, unwind, incremental false, explicit Rust flags
-C symbol-mangling-version=v0 --cfg tokio_unstable. Locked/offline. Run the same
17 app tests under this profile; inherited core qualification requires exact
production source equality. Record native whole-ELF/code sizes separately from
shipping lines, unchanged header/retained capacities, dependencies and shaders.

Untimed preflights: each of four variants gets an idle/tick190 frozen image plus
idle/stream/scroll/both runs. Require identical font bytes, 960x720 geometry,
normal exits, no native presentation/workload errors and correct operation flags.
All three GPUI tick190 captures must match exactly. Inspect the reference image
for content/geometry but do not invent cross-renderer pixel or AA equivalence.
Automatic modes retain existing deferred controls/cancellation; do not rewrite
the workload to improve cadence. Manual wheel/gesture equivalence remains open.

## Fixed native measurement and decision

128 fresh processes, four modes, eight balanced four-treatment Williams groups
per mode, eight seconds each. PROCESS_ORDER.json fixes every group/order before
building, seed20261107. No dropped/repeated observation or changed acceptance
rule. Preserve every process failure, including insufficient admitted work, and
complete the whole schedule. Execution failure is not a zero CPU measurement.

Record whole-run admitted updates and GPUI acknowledgement counts. All active
candidate and ZGX observations must meet the inherited 58–61 updates/second
cadence gate (464–488 in eight seconds). Older control/sparse failures remain
visible diagnostics and do not invalidate candidate/ZGX pairing. Only if all
candidate and ZGX observations qualify may active paired CPU-rate ratios be
interpreted. A failed member prevents the complete eight-pair ratio for that mode;
never select the passing subset. Do not normalize sampled CPU by whole-run ticks.

Sample process user+system CPU, including llvmpipe workers, from visible+1s to
visible+6s, require >=4.8s observed interval, and retain raw /proc samples, mean/
maximum RSS, final model logs and all launch/close commands. For each active mode,
the fixed local CPU superiority gate is median(candidate/ZGX paired CPU rates)
<=0.8. Report 10000 paired bootstrap resamples with seed20261107/type7 intervals;
the point threshold stays fixed. Candidate idle must admit zero updates and use
<=0.01 observed CPU cores in every sample interval. Record idle denominator zeros;
do not fabricate a ratio. All active and idle candidate gates are mandatory.
Reference count equality and cadence are distinct; report both. CPU intervals and
whole-run ticks have different boundaries, so this is not exact per-update cost.
RSS and cold-visible times are observations, not newly selected acceptance gates.

Use private X11 :94, scale1, the same staged DejaVu Sans file and software Vulkan
ICD, LP_NUM_THREADS=4. No builds, unrelated tests, allocation probes, source edits,
analysis or cleanup overlap timed observations. Source/profile/fixture/ELF guards,
frozen runner/analyzer/independent verifier and a complete evidence manifest are
required. Keep failed preflights/builds and all failure/fallback evidence. Preserve
source/evidence before reclaiming completed caches; prefer12GiB before a fresh
large build and enforce8GiB during it. Reap every owned process.

This local native gate does not close the physical GPU/two-hardware-class, scanout,
manual-input or render-quality gates. ZGX uses AutoVsync/default latency2 while
GPUI uses FIFO/latency1; keep both unchanged and document the difference. If the
candidate still misses cadence or CPU superiority, first investigate measured
native scheduling/presentation/driver costs, rather than asserting an async tree
runtime solves them. BBTree/Solid/Ripple research remains relevant to dependency
identity and publication lifetime; no cache-hit improvement is claimed here.
