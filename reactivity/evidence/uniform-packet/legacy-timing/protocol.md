# Legacy299c timing qualification v1: frozen v3 gates

This is a new campaign for sealed legacy candidate
299c6aca30c1245c15c2da6a5ccabb41dd435d17. It inherits the exact 26 cells,
fixed schedule, warmup/sample counts, deadlines and all correctness,
regression, maximum-frame and speed gates of the original frozen v3 protocol
at /tmp/gpui-gpu-frontier-evidence/protocol.md (SHA-256
6bc7ef00423e647fc80d00e8cb5fdbc817c1513f1b729240a9a2c5fc6afc43b6).
That failed campaign remains unchanged and is not replaced. This protocol is
frozen before measured execution. Calibration is functional evidence only;
its clocks cannot establish a timing claim. The comparator is actual shipping
GPU sources at 7a5e1619a27010ec63f6c27506a6d1fcd113f67c; every non-GPU
source stays pinned to 299c. Neither production renderer is modified for
observation. New output is /tmp/gpui-legacy-timing-evidence; existing campaigns
and all earlier archives are preserved.

Both binaries are rebuilt, not cargo-fresh, at the same physical source path
/tmp/gpui-legacy-timing-sol. Cargo.lock, root config, default SIMD + vulkan-tests,
offline locked dependency resolution, release opt-level=3, one build job, and
root v0/tokio flags are identical. RUSTFLAGS and CARGO_ENCODED_RUSTFLAGS are
unset. The exact prior qualified Nix Rust 1.97.1/cargo executable and version
guards are checked before builds and every runtime leg. Root's separate
Rust 1.101 provisioning is outside this comparison. No emit-stack-sizes is
appended for this timing fixture; previous static
cost evidence is separate. Exact source, fixture, compiler, fingerprint, command
and binary hashes are retained. Preserved binaries, never cargo-run, are executed.

The public Canvas/Renderer fixture uses a 512x256 target for every cell. SDR
uses Rgba8UnormSrgb/sRGB; HDR uses Rgba16Float/linear Display-P3 with signed and
above-one channels. Nine SDR cases are fixed: flat opaque; 24 real shaped text
labels without and with an opaque background; eight full translucent layers;
the same layers with a text tail; eight placements sharing one RGBA image with
a text tail; 24 partially covered rounded rectangles; 32,000 glyphs in 1,000
32-glyph groups; and 32,000 singleton glyph draws. Both 32K cases finish with
an opaque full-canvas rectangle to bound GPU overlap while preserving validation
and packet work. Four representative HDR cases repeat layers, layers with text,
shared image with text, and rounded partial geometry. There are 13 scene/format
cells, each with static and alternating 0/0.25-pixel translation, totaling 26.
Text shaping and Canvas recording happen before the clocks. Each cell owns a
fresh renderer and output texture. The image and TextSystem persist within one
process and are identical for both legs. Per-frame Renderer::render still runs
through its ordinary public API; no replay/token shortcut is added.

Calibration: one fresh process per binary, two frames per cell, all raw outputs
and logs retained. Calibration requires exact shipping/candidate readback
equality for every captured case/format/motion/frame. Failure does not permit
dropping a cell. Any fixture correction creates a new protocol version and
invalidates the entire calibration, retained as a failed attempt.

Qualification requires an explicit exclusive quiet GO from Root. No builds or
other benchmark tasks may overlap. Before the first measurement record this
protocol's SHA-256, UTC start, CPU governor, CPU count, driver, binary hashes,
root source guard, and process snapshot. The environment is Ryzen 3700X,
powersave, Mesa 26.1.4 llvmpipe software Vulkan without a render node. Results
cannot establish hardware GPU performance, startup, RSS, scanout, or foreign
runtime behavior. Retained vector/GPU resource counts are not measured RSS.

Run exactly 11 paired fresh-process repeats. Pair order is AB, BA, AB, BA, AB,
BA, AB, BA, AB, BA, AB, where A=shipping and B=candidate. A leg runs all 26
cells in the exact source order. Every cell runs exactly 3 warmup frames and
9 sampled frames (0..11), without trimming or retries. Record each frame's
host render/submit wall clock, separate device poll wall clock, their complete
total wall clock, full renderer Stats and ImageStats, including warmups. Raw
clocks use monotonic nanoseconds. Poll is a CPU/device synchronization wall
clock, not a GPU timestamp. Readbacks of frames 0,1,10,11 occur after the timed
interval and match bit for bit across each pair, including HDR half float bits.
Raw outputs and every stdout/stderr/failure remain available. Adapter creation,
shader pipeline setup, scene recording, readback, and CSV writes are outside
the frame clocks. Readbacks between frames follow the same fixed schedule.
Runtime source guards cover all tracked crate/vendor inputs, Cargo manifests,
lockfile, and the root config; historical evidence and benchmark-results files
are excluded from repeated hashing. The complete original tracked reactivity
manifest remains preserved in build metadata, including excluded evidence.

Deadlines: every calibration or measurement process has a fixed 240-second
wall deadline. The complete measured job has a 1,800-second deadline, starting
immediately before the first measured leg. A timeout, nonzero exit, changed
binary/source guard, missing frame, readback mismatch, adapter mismatch, or
quiet-window breach fails qualification. No retries, adaptive frame counts,
selective omissions, or replacement workloads are allowed. Earlier completed
data remain retained. A fatal process/guard failure or quiet breach stops
further legs after the current process is reaped; it produces failed/incomplete
analysis, never a replacement leg or successful shortened schedule. Guard
failures before/after a leg are persisted before analysis. The build metadata
itself joins protocol/runner/analyzer/build source in the frozen hash set;
compiler executable/version guards are checked alongside source/binary guards. A failed protocol needs a new explicitly identified run.

Analysis is fixed before timing. For each cell and metric, take the median of
its nine sampled frames in each process. Compute candidate/shipping ratio in
each of the 11 pairs, then the median ratio for the cell. Treat the 11 processes
as repeats; the nine frames are not 99 independent trials. For host and total
separately, compute each pair's equal-cell geometric mean ratio across all 26
cells, then its median over the 11 pairs. Poll is reported independently and
never relabeled device execution time.

Correctness gate: every required output is byte-identical and every source,
feature, format, adapter and frame guard holds. All frame counts and all cold
and warm uploads, retained buffers, vectors, atlas, and planned evaluations
are reported. Diagnostics whose meanings differ between source revisions are
explicitly labeled; counts do not substitute for elapsed time.

Independent regression gate, for every cell on host and total separately:
fewer than 9 of 11 paired median ratios may exceed 1, and the ninth sorted
paired median ratio must be <=1.01. In addition, every pair/cell's maximum
sampled candidate frame must be <=1.10 times its shipping maximum sampled
frame on both metrics. This independent frame-tail guard prevents a single
severe frame regression from disappearing in a median or aggregate speedup.
Independent speed gate: equal-cell geometric mean must improve by >=3% for
both host and total; each must be faster in >=10 of 11 paired process means.
Additionally at least three of the fixed scene families must improve total by
>=5% (median paired ratio <=0.95) and be faster in >=10 of 11 pairs in every
format/motion cell belonging to that family. Families are exactly the nine SDR
case names, with four HDR cases joining their matching family. This prevents
one favorable synthetic layer case from carrying adoption. These are explicit
engineering gates, not universal speed or statistical population claims.

A candidate is eligible only if correctness, regression and speed gates all
pass. Failure of any gate leaves 299c unadopted. The qualified static/source
costs remain charged: +142 core non-test/comment lines and +5,376 linked text
bytes versus shipping; +209 lines and +5,584 linked text versus experimental 277.
Render static frame is 1448 versus shipping 1416 / 277 1432; bin_draw 840 versus
824 in both controls. Legacy full ordinary warm uploads and +16 bytes per
shared group versus the rejected uniform ABI remain charged. These static
costs are retained from /tmp/gpui-legacy-coverage-evidence/cost-ledger.json;
this fixture does not rerun codegen or measure peak stack/RSS. No subsequent
implementation may enter the frozen binaries, sources, protocol or gates.

The whole-bounds certificate establishes implication to the existing rounded
CPU tile predicate under its documented strict host IEEE operation contract.
It does not establish target-independent WGSL IEEE parity or altered host
DAZ/FTZ behavior. GPU output correctness is established only by the qualified
adapter/readbacks; the inherited shader envelope remains a separate authority.
Luna's read-only audit /tmp/gpui-legacy-adversarial-luna/findings.md found no
demonstrated blocker under this contract. This qualification cannot broaden it.

Before measured execution, the analyzer must pass deterministic negative
controls. A synthetic 10% all-cell speedup passes all performance gates. One
cell regressed by 0.1% in all repeats must fail the independent regression gate
despite aggregate gains. One 4x candidate frame in one cell/pair must fail the
frame-tail gate despite median and aggregate gains. A missing frame, one raw
readback mismatch, one changed binary hash, and a deadline-expired incomplete
capture must each fail qualification. These checks do not establish runtime
renderer correctness. The deterministic complete schedule, runner/analyzer,
fixture, protocol and both binaries are SHA-256 pinned before timing; completed
data from an incomplete campaign are analyzed as descriptive partial evidence
and marked failed/incomplete, never padded into eleven pairs or retried.
