# SIMD formulations for the cleanroom renderer

This note compares leading SIMD libraries and renderer designs with the current
CPU canvas, then narrows them to formulations that can preserve the cleanroom's
scalar behavior. It is research and benchmark guidance, not a report of new
performance measurements. The reviewed repository baseline is `05af5841e1`
(`Borrow raster partitions and encode hit proofs inside existing storage`).
Relevant code is [canvas.rs](../crates/canvas/src/canvas.rs),
[samples.rs](../crates/canvas/src/canvas/samples.rs),
[bins.rs](../crates/canvas/src/canvas/bins.rs), and
[image_axis.rs](../crates/canvas/src/canvas/image_axis.rs).

## SIMD contract

Keep one algorithm with scalar and vector backends. The scalar backend defines
lane-by-lane operation order and edge behavior; vector code replaces that same
operation over independent lanes. Dispatch once while preparing raster state
or entering a raster phase, then call a monomorphized kernel. Do not detect CPU
features or indirect-dispatch per sample or pixel. This follows the useful part
of Highway's model: write portable operations, compile target-specific copies,
and dispatch at an outer entry point. Highway documents the first-call
detection cost of dynamic dispatch and recommends pointer-based entry points
rather than target-specific vector types
([dispatch guide](https://github.com/google/highway#static-and-dynamic-dispatch),
[quick reference](https://github.com/google/highway/blob/master/g3doc/quick_reference.md)).
Vello CPU similarly passes an explicit SIMD Level, including a scalar fallback,
through reusable renderer state
([Level](https://docs.rs/vello_cpu/latest/vello_cpu/enum.Level.html)).

The SIMD implementation must preserve command order, coverage values, sample
positions, blend formula, promotion behavior, final reduction order, and
absent-lane behavior. A backend that reassociates floating-point operations,
fuses multiply-adds, quantizes coverage, or changes reduction is a different
numerical mode and needs its own contract. Vello CPU makes such a tradeoff
explicit: speed mode uses u8/u16 arithmetic and quality mode uses f32, with
documented color-accuracy differences from quantization
([render modes](https://docs.rs/vello_cpu/latest/vello_cpu/enum.RenderMode.html),
[settings](https://docs.rs/vello_cpu/latest/vello_cpu/struct.RasterizerSettings.html)).
That is precedent for an opt-in precision mode, not proof of equivalence to
this renderer's current working-color behavior.

The active source-level spike uses fearless_simd 1.1.0 with one generic
operation and Fallback. Its candidates are four RGBA samples per f32x16
operation (AoS) and sixteen samples per channel over four vectors (SoA). Both
retain the 16-bit geometry coverage mask and scalar sample-major f64 mean fold.
Measurements are pending; this note makes no speedup claim.

## Strong prior art: classify, compact, then stream

simdjson's valuable idea is not “use a wide vector for every parser step.” Its
first stage classifies byte blocks in parallel, builds bit masks, and emits a
compact ordered list of structural positions; later traversal consumes that
index stream. The stage intentionally does not know full document structure.
The paper describes the staged approach and validation requirements
([Langdale and Lemire, 2019](https://arxiv.org/abs/1902.08318)); the current
source contains the structural indexer and UTF-8 lookup implementation
([indexer](https://github.com/simdjson/simdjson/blob/master/src/generic/stage1/json_structural_indexer.h),
[lookup4](https://github.com/simdjson/simdjson/blob/master/src/generic/stage1/utf8_lookup4_algorithm.h)).
The UTF-8 lookup algorithm uses byte classes and small in-register lookups to
check adjacent-byte relationships without a branch-heavy scalar state machine
([Keiser and Lemire](https://arxiv.org/abs/2010.03090)).

The cleanroom already uses the analogous representation at scene level:
RasterScratch builds a CSR tile-to-command index in painter order; rendering
visits contiguous ordinal slices. Cached full-tile coverage cuts skip opaque
prefixes, per-pixel sample masks store coverage without sixteen booleans, and
axis-aligned rectangle coverage factors into x and y masks combined with
integer bit operations. These are the “reduce work to a compact stream” moves
that transfer from simdjson. They do not imply a need for a second global SIMD
tape.

Two safe candidates:

1. **Widen independent mask construction.** For adjacent pixels, compute the
   same axis membership predicates into packed u16 coverage words, then combine
   with the current bitwise law. Admit only the fixed 4x4 lattice and the same
   finite inverse and rounding order. Preserve scalar results at inverse
   boundaries, signed zero, reflection, clips, and partial tiles. Start with
   solid rectangles and axis-aligned glyph mask addresses. Rounded geometry,
   transformed paths, and image texel sampling need separate kernels or scalar
   fallback inside the shared algorithm.
2. **Classify mask words before blend.** Zero means no sample work; all ones
   means uniform full coverage; repeated patterns can select a short form;
   remaining words need per-sample coverage. Keep the mask integer until a
   blend needs numeric coverage. It denotes geometric sample presence, not
   fractional glyph coverage or premultiplied source alpha.
3. **Gate sparse binary masks by population count.** For binary geometric
   masks with only a few set bits, iterate those sample indices and update
   their contiguous four-channel records with the same per-sample blend
   operation; use the wide masked kernel for denser masks. This can avoid
   arithmetic and stores to the other samples without building an index
   buffer. Admit only 0/1 geometry masks and keep the same painter order,
   f32 blend sequence, and untouched-lane bits. It does not apply to fractional
   glyph coverage or image coverage. A popcount plus branch and per-sample
   addressing costs several instructions; the threshold must be backend
   specific and measured against four-vector mask/select work. Storage stays
   at 64 f32 values (256 B) per mixed pixel; no sparse list is retained. For a
   sparse sample, the active record is 16 B, but the touched cache line and
   gather/load-store costs still count.

Do not materialize another SIMD-generated index list unless saved work exceeds
allocation, scan, and reread costs. Existing tile membership is reused when
display-list structure permits. simdjson demonstrates that compact output can
amortize a classifier when downstream work reuses it, not that all work should
be materialized.

## Sample blend: lane layout and complete costs

The scalar unit is one sample color with four f32 channels. For each ordered
command, blend applies source-over at that sample's coverage and skips the
write when coverage is not positive. A pixel is promoted from one uniform color
to sixteen independent sample colors only when coverage diverges; averaging
waits until all commands paint. sample_mean seeds from sample zero, accumulates
samples in order as f64 per channel, divides by 16, and narrows once. Changing
that fold can change output bits near rounding boundaries or lose signed-zero
behavior.

The sample plane is 16 RGBA colors = 64 f32 = 256 B per pixel, in addition to
the 16 B uniform color and one mixed-state bit (the 16x16 tile scratch in the
current implementation is 69,664 B). AoS and SoA have the same retained
sample-plane bytes. Promotion reads one 16 B uniform color and writes 256 B of
sample state; account for those writes, plus any temporary transpose, even
when the blend loop itself is faster.

### AoS: four RGBA samples per vector

Current storage is sample-major: a pixel owns 16 adjacent [f32; 4] records.
f32x16 maps to four consecutive RGBA samples. The kernel loads four samples,
broadcasts source channels, derives four coverage values from four mask groups,
and updates those independent samples; repeat four times per pixel. This
avoids transpose at promotion and leaves the scalar mean fold unchanged.
Inspect generated code for repeated broadcasts, mask unpack, and lane-select
instructions. Zero-coverage lanes must select the old destination, matching
the scalar skip-write path.

In the earlier sample-major AoS sketch, one four-sample step has twelve nominal
source-level float values live across destination color (4), anchor/source
color (4), and delta (4), not eight. Those are logical lanes, not a hardware
register count. Only optimized target assembly or compiler register reports
can establish actual registers and spills.

### SoA: sixteen samples per channel vector

Four f32x16 vectors hold R, G, B, and A across all sixteen samples. One coverage
vector is reused across the four channel operations. Promotion can splat four
channels, but existing AoS storage requires transpose/gather into planes.
Image blending produces sixteen optional RGBA source colors, which also have
to be converted to planes. A horizontal/tree reduction would change the
current ordered f64 fold; SoA must visit each sample in order and perform the
same f64 accumulation before narrowing. The current prototype preserves that
through an accessor, so count its loads and gathers in end-to-end runs.

Both forms represent the same 64 f32 values per pixel, but four vector-width
chunks across a pixel do not tell us machine register count; AoS may use one
vector chunk repeatedly while SoA keeps four planes live. Inspect optimized code
for spills, shuffles, repeated loads, broadcasts, mask extraction, and FMA.
f32x16 is an abstraction width, not proof of one hardware instruction; SSE2,
NEON, and wasm may split it. Record each target's actual code.

Vector arithmetic helps after source colors exist. It does not remove image
coordinate calculation, bounds checks, nearest/bilinear address generation,
clamp rules, decode/cache access, or sixteen source gathers. Compare complete
ImageNearest, ImageLinear, and rounded-image paths; a contiguous synthetic
blend is insufficient. Keep SIMD blending limited to solid/mask sources if
image gathers dominate.

The arithmetic admissibility boundary is:

- Preserve source-over evaluation order; do not silently use FMA when exact
  working-color bits are part of the scalar oracle.
- Select the old destination for absent/zero-coverage lanes. Do not rely on
  multiplication by zero; that can change NaN payloads or signed zero.
- Do not average samples before later commands. Coverage and source-over are
  correlated per sample.
- Preserve ordered f64 reduction unless an explicit numerical contract and
  error bound replace bitwise agreement.
- The geometry mask means occupancy on this fixed 4x4 lattice. Fractional
  glyph/image coverage remains f32; do not replace it by a bit mask or u8.

## Ownership, cache, and parallel work

Blend2D queues draw operations and lets each worker own an image band across
many commands. Its documentation says this keeps pixels hot in cache and
prevents writers from sharing pixels; it also warns small images may lose to
thread overhead and should be benchmarked synchronously
([multithreaded rendering](https://blend2d.com/doc/multithreaded-rendering.html)).
Vello Sparse Strips bins paths, keeps coverage near boundaries, and represents
fully covered regions compactly; CPU and GPU backends share preprocessing
([architecture](https://github.com/linebender/vello/blob/main/ARCHITECTURE.md)).
Vello's release notes show the continued interaction among SIMD generation,
image sampling, masks, and transparency hints
([releases](https://github.com/linebender/vello/releases)).

The cleanroom already owns each output tile once, retains tile command
references in painter order, and recursively splits disjoint row ranges. A
candidate is a bounded queue of tile-row bands large enough to amortize
scheduling and keep output rows and command spans hot. Do not atomically blend
pixels or sort translucent commands by material: source-over depends on order,
and floating-point reassociation is observable. Parallel private bin counts
plus reduction/prefix scan are admissible only if final tile ordinals remain
stable and scan/scratch costs are counted; sequential CSR construction may
remain cheaper for small dirty regions.

Compare contiguous-band ownership to dynamic scheduling of tiny tiles. Include
output alignment, scratch first-touch, false sharing at partition boundaries,
and retained membership reuse. SIMD and parallelism should use the same
single-writer partition.

## Library lessons and boundaries

| Library | Technique to borrow | Admissibility boundary |
| --- | --- | --- |
| [simdjson](https://github.com/simdjson/simdjson) | Block classification, bit masks, compact ordered indexes, carry state at boundaries. | Existing CSR and sample masks already do this at scene level. Add no new stream without producer/consumer evidence. |
| [simdutf](https://github.com/simdutf/simdutf) | Byte-class tables, adjacent-vector relationships, movemask/bitwise error aggregation, target implementations, fast valid-input path distinct from error reporting ([README](https://github.com/simdutf/simdutf)). | Text segmentation is not UTF validation. ASCII/property classification can filter work, but Unicode boundary context must still run. |
| [Highway](https://github.com/google/highway) | Portable operations, target builds, outer dispatch, vector-length-agnostic variants. | C++ reference rather than an automatic Rust dependency. Its std::simd comparison is advocacy, not independent evidence ([comparison](https://github.com/google/highway/blob/master/g3doc/std_simd_comparison.md)). |
| [Vello CPU](https://docs.rs/vello_cpu/latest/vello_cpu/) | Sparse strips, reusable state, explicit SIMD level/fallback, explicit speed/quality arithmetic modes. | Sparse geometry differs from this fixed sample oracle; borrow dispatch and ownership boundaries, not output equivalence. |
| [Blend2D](https://blend2d.com/) | Analytic rasterization, generated pixel pipelines, band-owned replay, explicit sync/async modes. | JIT specialization adds runtime/build/code-size costs. Its docs call multithreading experimental and leave thread count to callers. |

SWAR (SIMD within a register) also appears in Vello's compute renderer for
packing coverage/raster work into integer words
([fine shader](https://github.com/linebender/vello/blob/main/research/vello_shaders/shader/fine.wgsl)).
It is useful vocabulary for 4x4 occupancy masks and tiny lane-state classes,
but GPU packed arithmetic is not a CPU implementation or proof that float
sample state can be packed.

## Unicode selection: classify early, keep layout authoritative

The canvas text path shapes paragraphs, uses ICU4X grapheme segmentation for
canonical legal caret stops, maps byte offsets through shaped runs, and retains
affinity-aware visual stop geometry only for interactive layout
([planner](../crates/canvas/src/text/planner.rs),
[layout](../crates/canvas/src/text/layout.rs)). SIMD selection should consume
this prepared map, not infer caret stops from bytes, code points, or glyph IDs.

UAX #29 specifies grapheme, word, and sentence rules over Unicode properties,
constrained so they can use a small deterministic state machine. Extended
graphemes include combining sequences, regional-indicator pairing, emoji ZWJ,
spacing/prepend marks, and Indic conjunct rules; word/sentence boundaries may
not split graphemes. Some language word breaking needs dictionary tailoring
([UAX #29](https://unicode.org/reports/tr29/)). A safe SIMD design is to decode
and classify a block into compact property lanes, produce candidate boundary
masks, carry rule state across blocks, and let the same ICU/UAX segmenter
resolve candidates. ASCII runs can take a fast path. Independent block
segmentation without carry state or ICU's version/tailoring behavior is not
admissible.

UAX #9 bidi includes paragraph direction, explicit embedding/isolate handling,
weak and neutral resolution, bracket pairing, implicit levels, and visual
reordering ([UAX #9](https://unicode.org/reports/tr9/)). Paragraphs are a
useful outer partition; arbitrary character blocks are not. Shaping is separate
again: HarfBuzz documents contextual substitutions, joining, reordering, and
positioning, and distinguishes shaping clusters from grapheme clusters. Client
code must handle carets across ligatures and reordered glyphs
([shaping operations](https://harfbuzz.github.io/shaping-operations.html),
[clusters](https://harfbuzz.github.io/clusters.html)).

After shaping and legal caret mapping, vectorized selection can batch interval
comparisons and produce visual spans for paint/hit testing. Both endpoints
must be valid byte stops with upstream/downstream affinity; a logical
selection through mixed-direction text can yield multiple visual intervals.
Measure property classification, segmentation, map construction, span
generation, and hit testing together. Small maps may favor a scalar walk.

## What to benchmark and inspect

No timings or assembly were collected for this report because the active SIMD
spike is preparing matched whole-render runs. The deciding comparisons are:

1. **Kernel:** identical solid-color all-zero, all-full, repeated, alternating,
   and random masks. Record output bits and instruction/cycle counts. This is
   arithmetic evidence only.
2. **Promotion/reduction:** uniform pixels, first divergent coverage, and
   later overlap. Include ordered f64 means, exact bits, and scratch traffic.
   Compare AoS and SoA with transpose, gathers, and output reduction included.
3. **Whole scenes:** scalar/AoS/SoA on opaque rectangles, AA edges, dense glyph
   masks, nearest/linear images, mixed overlap, and transparency. Include
   command prep/binning, raster, decode/sampling, reduction, encoding,
   allocations, and warm/cold state. Report each scene; do not average away
   image or glyph regressions.
4. **Ownership:** worker-count sweeps on tiny dirty regions, full redraw, and
   large targets. Compare row recursion with fixed tile-row bands. Record
   imbalance, cache misses, scheduling cost, and frame latency.
5. **Codegen:** inspect baseline SSE2/NEON/wasm and the best host target for
   scalarization, spills, duplicate mask unpack, shuffles, FMA, horizontal
   reductions, source gathers, and dispatch calls in the hot loop. Store
   compiler, flags, level, CPU, and source revision with artifacts.

## Recommendations

1. Keep sparse tile commands, painter order, and single-writer tile-row
   ownership. Those already adopt the highest-value ideas from these libraries.
2. Compare AoS and per-pixel SoA in the active complete-render harness. Use
   generated code and exact f64 mean parity, not vector type names.
3. Prototype vector mask generation for contiguous axis-aligned spans only
   under the current inverse predicate. Retain packed u16 masks until a blend
   needs fractional numeric coverage.
4. Charge image address generation, gathers, decode, reduction, and output to
   the SIMD candidate. Keep image and glyph paths separately measured.
5. Apply Unicode SIMD to property classification/candidate masks only after
   UAX segmentation and shaping establish legal byte stops and visual caret
   maps. Vectorize selection geometry downstream of that map.

Batch independent work, keep order and ownership explicit, and preserve scalar
lane semantics through the complete path. SIMD should remove repeated
per-sample instructions or work that current scene certificates cannot already
eliminate; it should not add hidden precision, ordering, or allocation changes.
