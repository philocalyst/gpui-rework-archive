# Image integration evidence

Implementation: `b0ef87f8bfb7f51a35451cb8fa363981cc9a0ac0`, based on main
`5b0a38b222`. The later cached-cmap, viewport, route, Node24 and P56 experiments
are independent. This evidence does not attribute their costs to images.

Capture: 20 alternating image-free owner summary rows, 12 serial CPU image rows,
12 Vulkan image rows, plus every warm frame sample in the paired `.stderr` files.
The guarded serialized capture completed in **29.830 seconds**. Summary CSV line endings are normalized to LF, and assembly extracts strip
trailing display whitespace; captured process stdout/stderr
remain unchanged. All sources,
compiler version and binary SHA256 values are in
[the capture manifest](images-results/manifest.json); the pre-commit base plus
checksums identify the captured source. The committed implementation correspondence
is recorded separately in [the pin](images-results/implementation-pin.txt).
No production source changed after the capture. Benchmark/evidence files are a
separate commit from the implementation.

The runner pins the process and inherited workers to CPU2, uses fresh processes,
alternates pair order, checks the 0/8-byte Image capability markers and exact
owner output digests, checks image resource counts/payload sizes, checks zero
warm CPU allocations and zero stable GPU pixel uploads. Root/API/Luna paused
heavy work for this window. These are bounded fixtures, not whole-app or native
startup performance claims.

## Image-free floor and losses

[Owner raw summary](images-results/owner.csv), five pairs per case. Values below
are medians of process summaries; paired percentages use corresponding process
pairs, rather than a ratio of independent medians.

| Image-free case | Baseline → image mount µs | Baseline → turn p50 µs | Paired turn median | Mount allocations | Retained / peak delta |
|---|---:|---:|---:|---:|---:|
| Empty384×256 |605.173→617.784|386.348→387.938|+0.43%|42→42|+16 / +16B|
|12 text labels384×256 |2628.049→2608.948|1745.519→1755.509|+0.56%|559→559|+16 / +16B|

All five label turn pairs lose 0.30–2.61%. Empty turn pairs range from -0.20%
to +12.74%; the positive outliers are retained. Empty mount's paired median is
+1.83% with a -7.16%…+42.24% range; label mount's paired median is +0.54% with
-3.82%…+4.50% range. Small medians do not establish zero CPU cost. Per-process
p95/p99 and all frame values remain in the raw files; do not replace those tails
with the median p50.

There are zero new image-free heap allocations in these fixtures, with exactly
16 extra retained bytes: one Runtime cold pointer and one pointer in its embedded
Canvas. Renderer separately adds8B when a GPU renderer exists. Candidate header
sizes are Image8, ImageState80, Runtime<()>2384 (2400 with the test's16B Page model), Canvas552, El176, Draft152, Style88,
Node40, Presented80; Node/Presented/El/Draft/Style are unchanged by this feature.
Main's separate compact P/Node branches require their own ledger.

[Actual linked code](images-results/linked-codegen.txt), not a standalone emitted
assembly proxy, shows serial raster explicit stack reservation73,144→73,208B
(+64), without another probe page. The image-only memo helper reserves6,232B,
initializes the6,144B memo once, and borrows it without the earlier6KiB construction
copy. HDR and straight-sRGB take the direct image helper, so they do not call or
initialize this memo. Ordinary image-free tiles do not call either image helper.
The exact1KiB immutable straight-sRGB byte table is shared read-only data, not a
per-image/per-worker allocation. P3/premultiplied input retains existing Color
conversion and matrix order.

Linked `size` totals (which include read-only font/Unicode data, not just code):
text7,905,224→7,943,456B (+38,232); data155,056→155,736B (+680);
bss4,955→7,027B (+2,072); total +40,984B. This is a real linked cost, not a
claim that the new1KiB table accounts for every byte.

## Actual image costs

[CPU raw summary](images-results/cpu.csv), three fresh processes each;12 measured
warm frames after3 warmups. The reported p95/p99 are both the maximum of those12
samples, not a statistically strong tail estimate. Raster covers the full
384×256 output, with independent allocator counts around each render, no dirty
output-cache shortcut and no hidden full linear image.

| Fixture | Distinct payload | Scene heap retained / peak | Warm CPU p50 / p95 µs | Warm allocations |
|---|---:|---:|---:|---:|
|Opaque flat control|0|448 /448B|71.112 /76.642|0|
|One128² source→256² cover|65,536B|66,236 /66,236B|46,952.523 /48,637.191|0|
|48 minified covers, shared source|65,536B|72,956 /76,156B|69,497.599 /70,046.661|0|
|48 minified covers, unique sources|3,145,728B|3,157,280 /3,157,280B|65,896.028 /66,617.014|0|

These serial CPU costs are substantial. Bilinear reconstruction and16 correlated
samples remain real work; packed storage does not make them free. The table and
scoped memo improve the formulation, but the earlier contended/unpaired preflights
are not a controlled proof of improvement. There is no general image speed claim.

The scene ledger includes the80B boxed ImageResources header and actual hash
allocation, not just payloads. For one resource the retained66,236B reconcile as
65,536 payload +56 image/Arc header +80 cold resource header +480 vector lanes
(including32B image handles) +84 actual hash allocation. Unique48 reconcile as
3,145,728 payload +2,688 image/Arc headers +80 cold header +7,680 lanes
(including512B image handles) +1,104 hash allocation. Canvas552 is separate stack/
owner header storage. Application/cohort leases are separate from this Canvas
constructor ledger; the64MiB scene limit does not cap their union. Allocator
measurements count requested live bytes, not malloc usable sizes, allocator
metadata or physical RSS/PSS.

[Vulkan raw summary](images-results/gpu.csv): llvmpipe/Mesa26.1.4, CPU adapter,
all inherited worker threads pinned to CPU2. Serialized submit+poll wall time,
not GPU timestamps or discrete GPU throughput. Three process medians:

| Fixture | Packed payload | WORDS buffer incl.prefix/padding | All GPU buffers | Cold image upload | Warm pixel upload | Wall p50 / p95 µs |
|---|---:|---:|---:|---:|---:|---:|
|Flat control|0|ordinary buffer|4,308B|0|0|1,321.910 /1,335.111|
|One cover|65,536B|65,792B|72,016B|65,536B|0|84,225.369 /84,304.591|
|Shared48|65,536B|73,728B|82,000B|65,536B|0|169,832.549 /171,768.153|
|Unique48|3,145,728B|3,153,920B|3,162,192B|3,145,728B|0|162,452.134 /163,026.946|

Targets, R8 glyph atlas, driver allocations and CPU resource/index state are
additional; buffer totals do not pretend to measure total GPU/driver residency.
RGBA8 is four bytes/texel, plus actual prefix/padding. HDR float input is explicitly
sixteen bytes/texel. There is no decoded GPU cache to hide a4× expansion. Live-set/
order or prefix changes currently reupload the live set; tests verify relocation,
reordering and mixed packed/float offsets. An image-free scene releases the image
index and restores ordinary draw-buffer residency. Old submissions retain buffer
leases.

The first flat process's cold first-render wall time was **1,200,363.843µs**;
the other two were7,430.387/7,343.985µs. This outlier is retained. Processes were
fresh, but the external Mesa shader disk cache was shared and not reset. No
baseline/candidate cold-driver pair was collected, so do not attribute that whole
cold difference to images or claim a native GPU startup result. Image GPU controls
are candidate-only absolute costs, not an image-free GPU regression comparison.

## Correctness gates and limits

[Checks and external log hashes](images-results/checks.json) record actual commands'
results. The implementation passed:

- Full Canvas parallel suite; focused release image/table/collision/alpha tests.
  Exact table oracle covers256 channel values×256 alpha values. Independent
  constant-image/solid and nearest/rectangle pixel oracles, transparent colored
  edge/linear-light behavior,64MiB rejection atomicity, resource leases, regional
  damage repair and1/2/4-worker exact output all pass.
- Full GPUI tests under `x11-minimal`; public borrowed image, layout/aspect/flex,
  stable clickable identity, profile/filter change and resource dedup tests.
  Release cohort tests cover failed newer preparation, older candidate ack,
  loss/recovery and acknowledged last-resource removal. Image-only owners do not
  initialize text services.
- All23 actual Vulkan tests passed together on final source, including mixed
  resource-offset/key-reorder coverage. Input profiles×alpha×filter×transforms,
  linear HDR and P3 output, partial word payloads, mixed float/packed offsets,
  stable upload0, prefix relocation and image-free cache release are covered.
  SDR tolerance≤1 byte/channel; HDR≤max(2e-6,1.5e-3×abs(CPU)); maximum observed
  HDR absolute error0.001953125. No universal bit-parity claim.
- Actual native X11 `ReferenceCpu` pointer/asset swap→ack→resize→suspend/resume→
  complete surface-fetch oracle passed again on final source (0.40s test phase),
  on a private Xvfb. Explicit CPU policy initialized no Wgpu instance.
- Strict all-target Clippy for GPUI X11+Wayland, Canvas parallel and Vulkan tests,
  formatting and diff whitespace checks pass. Normal accessible profiles include
  AT; this X11 pixel proof deliberately uses the minimal diagnostic profile.

No fresh macOS/Windows image-specific OS execution was performed here. Input
resource/native schema changes compile through portable code, but this evidence
is Linux X11/Vulkan. Native HDR negotiation, image decoding/I/O, ICC/EXIF,
animation, mipmaps and per-image tint/opacity are not implemented by this slice.

## Rejected preflights and reproduction

A shared target's Fresh root `release/libgpui.rlib` pointed to the old baseline:
`gpui::Image` failed to compile and the linked raster body matched baseline.
No timing rows were taken with that consumer. Touching the root lib alone then
exposed a stale dependency artifact. Both consumers were rebuilt in **distinct**
release targets, using only their own dependency search directories. The baseline
marker0 and candidate marker8 compile into each consumer; the manifest pins both
final binaries. Benchmark executables with the same Cargo example basename were
also copied to distinct names before capture. These rejected probes are not data
points or performance wins.

Rebuild baseline from5b0a38b222 with
`CARGO_TARGET_DIR=/tmp/gpui-images-baseline-release-target cargo build -p gpui --release --lib`.
Build candidate GPUI and CPU example in `/tmp/gpui-images-release-target`, then
compile `images-control.rs` against the matching root rlib and only its matching
`-L dependency` directory; candidate additionally uses `--cfg image_candidate`.
Use the same Rust toolchain/opt-level3 and allocation-counter rlib. The generator
in Canvas `evidence/image-transfer.rs` reproduces the frozen table from Color.
Build GPU `--example images --release --features vulkan-tests` and copy its binary
separately from Canvas's same-named example. The native/Vulkan environment used:

```
source /tmp/gpui-native-env.sh
python3 crates/gpui/evidence/run-images.py \
 --baseline /tmp/gpui-image-free-baseline --candidate /tmp/gpui-image-free-candidate \
 --cpu-images /tmp/gpui-image-cpu --gpu-images /tmp/gpui-image-gpu \
 --output /tmp/new-image-results --cpu 2
```

The helper supplies the pinned Rust/Vulkan loader and llvmpipe driver paths on
this machine; it is not a portable application dependency. Use a new output
directory and coordinate a quiet window. Raw files retain every process and warm
frame, so alternate summaries can be checked without recapturing or dropping
outliers.
