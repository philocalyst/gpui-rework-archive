# Build-time typed WGSL materialization

Source commit `418a3b9a28` is based on `8a157b3b47`. Three source files change:
GPU Cargo.toml adds the exact existing wgsl-rs beta6 validation dependency for
the host build, build.rs compiles the same src/shader.rs, and Renderer borrows
a generated include_str artifact. The typed public shader module and its API
remain available. No handwritten WGSL, unsafe code, global cache, backend
passthrough, or per-renderer retained state is added. WGPU still validates the
shader and pipeline for the actual backend.

The generated WGSL is 15,180 bytes, SHA256
`5af0c419683eb64b945b477d631583aca670b3a504a09f596f6ed4efa26cb1a5`.
It is byte-for-byte identical to the original runtime generation. Build-time
Naga validation checks that exact artifact; the existing storage-layout test
now parses the artifact and checks equality against typed regeneration.
Current Draw/Globals/Correction layouts remain 96/48/32 bytes with unchanged
offsets. Public typed definitions and renderer bytemuck writers are unchanged.

## Correctness and invalidation

- Eight GPU unit tests, all 40 actual Vulkan oracle tests, and one doctest pass;
  zero failures or ignored tests. The existing oracle includes images, glyphs,
  transforms, groups, clipping, HDR and paint bindings.
- GPU release all-feature all-target strict Clippy passes with -D warnings.
- A no-change build preserves the artifact mtime. A shader source edit and a
  newly added future child source file each trigger regeneration. Both probes
  are restored; artifact contents stay identical. The source directory watch
  is conservative and also regenerates for unrelated files under src.

## Allocation and linked-code controls

The external driver has separate ordinary-renderer and public-generator bins.
The ordinary executable does not reference the measurement generator, so it
can reveal dead stripping of the generation path. Separate target directories
and retained copies of the original and candidate executables and rlibs have
exact source/build/artifact hashes in the control records.

Original materialization makes 5,680 current-thread Rust allocations totaling
551,643 allocated bytes on every one of four direct generator calls. It
retains a 15,180-byte String and reaches 366,862 peak allocated bytes during
generation. Borrowing the included artifact makes zero allocations.

The guarded quiet capture alternates seven original/candidate fresh-process
pairs, with four Renderer::new calls per process, on CPU2 and llvmpipe Vulkan.
Every one of the 28 matched Renderer calls removes exactly 5,680 allocations
and 551,643 allocated bytes. First calls change 13,572 to 7,892 allocations
and 2,746,427 to 2,194,784 allocated bytes; subsequent calls change 13,548 to
7,868 and 2,741,659 to 2,190,016 bytes. Retained bytes and peak allocated bytes
are identical because later WGPU work sets the peak. These allocator counts
cover the calling Rust thread; native driver allocations and other threads
are outside this measurement.

The ordinary release executable changes 7,693,424 to 6,773,632 file bytes
(-919,792). Its .text changes 4,183,223 to 3,435,303 bytes (-747,920), while
.rodata changes 507,120 to 509,552 (+2,432). The public generator constructor
and Source::wgsl_source symbols are present in the original ordinary consumer
and absent in the candidate. The rlib grows 1,680,838 to 1,709,790 bytes
(+28,952): retaining the public generator API is explicitly charged. This is
the external driver's linked size, not a native GPUI application measurement.

## Timing limits

The renderer capture completes 14 processes / 56 calls in 5.723 seconds with
source, library and executable hashes checked before and after every process.
Instance, adapter and device setup are outside the Renderer::new measurement.
First-call medians are 86.433 ms original / 85.705 ms candidate; matched deltas
have median -0.618 ms and range -6.222 to +3.496 ms. Subsequent-call medians
are 82.687 / 81.725 ms; deltas have median -0.690 ms and range -5.930 to
+0.585 ms. These small noisy timings do not support an end-to-end GPU startup
speed claim. WGPU parsing and backend pipeline construction still run.

No native UI, spoken-screen-reader, physical-display, hardware-GPU, Apple,
or Windows execution is claimed by this slice. Root integration must run its
native and platform gates against the final merged source.

## Build and cache cost

The initial original fresh release build took 1m56s. The first candidate
build, seeded with original dependency artifacts, took 19.50s; those totals
are not directly comparable. That candidate build adds 24 host dependency or
build artifacts: 47 files / 132,802,199 logical bytes including separate rlib
and rmeta files. Its ordinary-consumer host build-script executable is
8,249,856 bytes at Cargo's default build-script opt-level 0. These are build
cache costs, not shipped application bytes. Public target dependencies remain.

A final coordinated quiet comparison cleans only gpui_gpu in each separate
target, retaining cached dependencies. One original/candidate pair takes
11.370 / 9.939 seconds wall. Cargo's rounded unit durations are original GPU
8.60s plus ordinary consumer 1.93s; candidate host script compile 0.99s,
script run 0.03s, GPU 8.14s, and ordinary consumer 0.61s. Both rebuilds produce
the exact previously frozen executable hashes. This is one observed rebuild
point, not a general compile-speed claim or a full cold-dependency comparison.
Raw HTML timings, commands, clean output, and process/pressure context remain.

The source-directory invalidation probes intentionally rebuild more broadly
than a single-file watcher. Their uncontrolled wall times are diagnostic and
are not used as comparative performance results. All temporary edits and the
child probe are restored before the final source guard.

`source-pins.json`, `frozen-controls.json`, and `baseline-artifacts.json`
connect source commits, source hashes, build JSON, retained rlibs/executables,
and generated text. Raw binaries and rlibs remain in the recorded isolated
`/tmp/gpui-wgsl-captures/frozen` paths; their hashes and sizes are committed.
`external-driver/` contains the exact external consumer and lockfile;
`capture.py` and `compile-control.py` are the actual measurement drivers.
They use fixed absolute paths that must be adapted deliberately elsewhere.
Source the recorded `native-env.sh`, set the isolated target and two jobs,
and run the recorded build/test commands. The timing driver creates its own
XDG runtime directory and pins CPU2; it does not use the stale DISPLAY value.
