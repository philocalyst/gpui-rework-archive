# Matched-profile native diagnosis — cadence gates fail

This completes a diagnostic, not adoption or a framework victory. All changes
remain local. No production library code or public application API changed.
Protocol20919cb160f6fcc5ab85eca607b97d4173739409 preceded compilation and timing.
Baseline is corrected original plus qualified deferred controls; sparse source
c965a893364b46f965c83d10e2cf94a46dac1304 copies that exact example onto rejected
static sparse repair. ZGX remains pinned a3678578980ef239058c557338ef9c544d356b0c.
Both older complete sparse performance verdicts remain failed.

## Native observations

72 fresh processes: four automatic modes, six balanced groups, all six executable
orders per mode, eight seconds each, seed20261101. All processes exit normally.
All36 active GPUI observations fail the preregistered58–61 updates/second gate;
all18 active ZGX observations complete479 updates. Idle18 observations pass.
No failed observation was repeated or dropped. No qualifying active paired CPU
ratios or bootstrap speedup claim can be inferred from this matrix.

| Mode | Baseline median updates | Sparse median updates | ZGX median updates | Baseline CPU cores | Sparse CPU cores | ZGX CPU cores |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| idle | 0 | 0 | 0 | 0.000 | 0.000 | 0.000 |
| stream | 330.5 | 453 | 479 | 3.667 | 0.575 | 0.128 |
| scroll | 243.5 | 241 | 479 | 3.850 | 3.859 | 0.075 |
| both | 144.5 | 144.5 | 479 | 3.889 | 3.890 | 0.147 |

Updates are whole eight-second workload admissions. CPU is observed process user+
system time over the approximately five-second interval from visible+1s to +6s,
including driver workers; one core means one CPU-second per wall second. These
columns have different measurement intervals and must not be divided into a
per-update cost. Total ticks do not identify exact work in the sampled interval.
Zero idle CPU means no increment at the OS tick resolution, not proof of zero
instructions. All raw samples, workload logs, host ACK counts and interval lengths
are preserved. ACKs are not physical scanout; some GPUI updates coalesce, and ZGX
has no presentation count in this unmodified adapter. Startup is excluded from
these rates; the applications start their workload clocks at different boundaries.

Median sampled mean RSS: baseline144.18MB idle/150.04–150.15MB active;
sparse144.22MB idle/149.88–150.24MB active; ZGX119.09MB idle/125.61–127.43MB active.
This is process resident memory on software Vulkan, not GPU memory or retained
core capacity. Exact distributions and maximum sampled RSS are in raw/analysis.json.

The text-only repair benefit survives in native CPU usage and admitted updates,
but it does not meet cadence. Scroll and mixed work still consume nearly four
cores and miss deadlines by much more. The next diagnostic must attribute time
to UI versus raster workers before prescribing another tree scheduler. These
observations alone do not identify a CPU call stack or prove a memory-cache cause.

## Qualification and environment

Same nightly1.101.0 toolchain, release opt3, fat LTO, one codegen unit, debug0,
no stripping, unwind panic, identical explicit Rust flags. Separate fresh targets;
locked/offline commands, effective environment, Cargo JSON, executable hashes,
fingerprints and before/after source guards are saved. Both GPUI compositions pass
17 public application tests; the reference component geometry/row-bound test passes.
Core production qualification is inherited by exact source equality. It is not a
new full-core test claim. The app example is byte-identical between GPUI variants.

Native executables: baseline22462304B, sparse22486408B, ZGX25152256B. Baseline's
previous differently configured binary was26339472B; this size reduction is a
profile effect. Existing shipping core counts36956/37372 are inherited, unchanged;
there is no new per-node/header/queue field. No dependency or shader was changed.
GPUI generated WGSL exactly matches the previously qualified typed shader and is
found in both executed ELFs. Reference shader files embedded whole are enumerated;
not every source shader is claimed linked as a standalone string.

Private X11 :94,960x720, scale1, identical staged DejaVu Sans SHA256
7da195a74c55bef988d0d48f9508bd5d849425c1770dba5d7bfc6ce9ed848954.
The Vulkan loader reports only a CPU device: llvmpipe LLVM20.1.2/Mesa25.2.8;
LP_NUM_THREADS=4. No /dev/dri exists. Software raster execution is included in
process CPU; this does not establish hardware GPU performance or display latency.

Fifteen untimed native preflights pass (one frozen image and four modes each).
GPUI baseline/sparse images at initial tick190 are pixel-identical. Reference
geometry/content match visibly, but glyph rasterization/blending differ; no
cross-renderer pixel identity or render-quality equivalence is claimed. GPUI's
untimed preflights overlapped the reference compile, explicitly excluded from
performance interpretation. All compilation/tests/preflights/cleanup ended before
the fixed timed matrix; scripts and source remained unchanged throughout timing.

Wheel events and control clicks are absent from these automatic modes. GPUI's
32px immediate line-wheel default and ZGX's40px resampled policy remain unchanged.
Manual wheel/gesture equivalence remains open; it has not been waived. On Linux,
reference uses AutoVsync/default maximum frame latency (2); GPUI uses FIFO/latency1.
The actual driver behavior and differing buffering must be investigated separately;
this matrix did not ablate them or declare their impact negligible.

## Preserved operational corrections

The first environment-freeze script failed because vulkaninfo is not installed.
Its source and partial receipts remain. A standalone read-only Vulkan loader query
completed the corrected receipt before timing. No GUI source, gate or sample was
changed. Pillow was unavailable for image comparison; installed ImageMagick reports
zero absolute-error pixels for the two GPUI captures. Completed inactive rlib/rmeta
caches were removed with hash journals to preserve >=12GiB before each fresh build
and >=8GiB throughout; no source, evidence or executed binary was deleted.

The new BBTree upstream diff and source pin are retained in raw. Its recent
value-update preservation of the append certificate supports investigating which
valid facts a display update discards. It does not imply that a custom async
runtime will accelerate a raster-bound application. Solid/Ripple readiness and
publication semantics remain as documented in the campaign, without new API or
changed progressive Reader semantics here. Hardware and quality gates remain open.
