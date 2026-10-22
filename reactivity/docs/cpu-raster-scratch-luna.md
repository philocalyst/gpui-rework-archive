# Canvas-owned CPU raster scratch

Initial scratch-cost note against cleanroom main `0764b5d908ce777f2cb2b1ef6fdfba226aec057d`; the proof-cut follow-up below audits source pin `5f4db5f2886e6d72aefd585d21dd6543774f1393`. No production code or timing claims are included.

## Proposed boundary

Move `Canvas.offsets`, `Canvas.indices`, and `Canvas.cursor` into a lazily allocated private `RasterScratch`, owned by the `Canvas` that owns the corresponding `DisplayList`:

```rust
struct RasterScratch {
    offsets: Vec<usize>,
    indices: Vec<u32>,
    cursor: Vec<usize>,
    tile_bounds: [u16; 4], // all-zero sentinel means invalid
}

pub struct Canvas {
    // ...
    raster: Option<Box<RasterScratch>>,
}
```

The cache is valid only for the current command geometry/order and recorded tile envelope. `render_output` computes the same tile bounds it does today, then reuses the CSR arrays only when the cached `[u16; 4]` equals that envelope. Otherwise it first sets the cached key to `[0; 4]`, rebuilds offsets/counts/prefix sums/indices from the current `DisplayList`, then stores the real key only after construction. A nonempty requested tile envelope always has `left < right` and `top < bottom`, so it cannot equal the all-zero invalid sentinel; the empty-region early return does not build or key bins. This avoids a separate validity flag/generation. This cache belongs to the mutable owner; no token, external lineage map, sidecar, or second command tree is needed.

Invalidate before any accepted topology/order mutation: `Canvas::clear`, successful `fill_rect`/shape append, successful image append, successful text append, and `CanvasScene::commit`. For append paths, invalidate only after successful admission/reservation and immediately before appending; an unwind cannot leave bins apparently authoritative after a partial append. Keep capacity for reuse. Failed validation/admission and dropped `CanvasScene` candidates do not invalidate: they never change the current scene. `PaintCommit::commit` changes only common colors (`canvas/paint.rs:87-100`) and preserves geometry/order, so it keeps bins valid. `set_tile_proofs` changes the proof path but not CSR membership and also preserves bins. Canvas dimensions/configuration are fixed after construction; if a resize API is added, it must invalidate.

On an empty region, preserve the current valid cache and return as today. The empty-region fast path may still report retained bin capacity. Cache identity includes the *tile envelope*, not the pixel damage rectangle: CSR membership is defined at tile granularity. A different rectangle that rounds to the same tile envelope can reuse the same bins. Buffer age/damage remains owned by the native surface and is not part of this cache.

The existing `Frame` already borrows `DisplayList`, offsets, and indices (`canvas.rs:1536+`), while raster workers receive immutable frames and disjoint output slices. A `build_bins(&DisplayList, &mut RasterScratch, bounds)` helper can preserve this ownership model: finish preparation before constructing `Frame`, then borrow `self.commands` and `self.raster.as_deref()` as disjoint fields. No mutable cache access reaches a worker.

## Exact costs and bounds

`Canvas` originally carried three `Vec` headers (72 bytes); the measured implementation reduces `Canvas` from 552 to 488 bytes, a 64-byte cold reduction. `Option<Box<RasterScratch>>` is 8 bytes and `RasterScratch` is 80 bytes (three 24-byte `Vec` headers plus 8-byte bounds; no separate validity flag). Once allocated, the full owner-plus-scratch header cost is therefore 488+80=568 bytes, 16 bytes above the old 552-byte inline-header total, before vector payload/capacity. GPU-only recording allocates no scratch. The first CPU BGRX render measured three allocation requests totaling 152 bytes retained at the small test size (80-byte scratch object plus 72 bytes of vector payload); a warm repeat allocated zero. These are actual focused-test observations, not general memory or timing claims. `RenderStats` remains 96 bytes. Keep active and cold charges separate in the ledger.

Tiles are 16×16. The dimension contract admits each side up to 16,384 px and total pixels up to 16 Mi (`canvas.rs:6-8, 878-887`). Although each axis can reach 1,024 tiles, the pixel-area cap means the maximum product is only 66,528 tiles: for tile counts `a,b`, the smallest admitting pixel dimensions are `16(a-1)+1` by `16(b-1)+1`; maximizing `a*b` subject to their product ≤16 Mi and each count ≤1,024 gives 66×1,008. At 1280×800, the full envelope is 80×50 = 4,000 tiles. Thus `offsets` has at most 66,529 `usize` entries (532,232 bytes on x86-64); `cursor` at most 66,528 `usize` entries (532,224 bytes); and `indices` is bounded by `MAX_REFERENCES = 4,194,304` `u32`s (16,777,216 bytes). A loose simultaneous payload ceiling is 17,841,672 bytes, before allocator capacity rounding. Normal scenes are smaller; report actual `Vec::capacity`, not logical lengths. `MAX_COMMANDS = 65,536`, so command indices fit `u32`. Tile coordinates run 0 through 1,024 inclusive, so `[u16; 4]` is sufficient without narrowing assumptions about pixel-space coordinates.

This representation adds one boxed allocation the first time the CPU path is used. Today the three `Vec`s allocate their payload on first render (`render_output`, `canvas.rs:1470-1488`) but their headers are already inline. The new cache should not add any per-render allocation after the initial capacities stabilize. Existing `RenderStats.bin_bytes` measures vector-capacity payload only (`canvas.rs:1529-1532`); keep that definition stable and account the scratch allocation/header separately in the retained-owner ledger rather than silently changing historical stats. Existing bin allocations use `Vec::resize` and may panic on allocator exhaustion; `try_pixels` only makes output-image allocation fallible (`canvas.rs:889-897, 1356-1364`). Do not imply `try_pixels` currently provides fallible bin allocation. If bins become fallibly reserved in this work, preserve old valid bins until all required reservations succeed, or leave the cache invalid and surface an error; that is a separate API/error-path change.

## Work this removes, and what it does not

On a cache hit, it removes both full `commands.iter()` visits in `render_output`, the offset-array zero/resize and prefix-sum pass, index-array zero/resize, and copying offsets into cursor (`canvas.rs:1470-1488`). It does not remove `render_band` work, per-tile `full_tile`/opaque-proof checks, sample tests, blend/encode, or writing destination pixels. Proof cuts must be recomputed after color edits; only same-alpha edits are admitted by `PaintCommit`, but keeping proof recomputation avoids another cache dimension and makes the proof invariant local (`paint.rs:144-190`). Tile-proof enable/disable remains a renderer option, not part of CSR membership.

For a successful paint-only update, geometry and painter order remain fixed by the exclusive prevalidated `PaintCommit`; the new colors still require rerasterization. The current cache miss path is exactly what a first render after a structural scene commit needs. Thus this primarily benefits repeated `render_bgrx_region` calls/diagnostic rerasterization after paint-only changes, not full GPUI presents that rebuild the display list each turn.

## Failure and lifecycle cases to test

1. Build full-frame bins; commit a same-alpha color change; render again; assert same pixels as uncached/reference and that bins remain valid. Include SDR, RGBA16F/HDR, and `-0.0`/subnormal RGB cases where supported; geometry indexing must not inspect RGB.
2. Build bins for one regional tile envelope; render another region mapping to the same envelope and verify cache reuse; then a region mapping to a different envelope and verify rebuild. Include an empty region between them.
3. Toggle `tile_proofs` after a cache hit: output must remain bit-identical to the existing noncached/reference path, and CSR remains reusable while proof statistics/path are recomputed.
4. `clear`, successful rectangle/image/text/rounded append, and `CanvasScene::commit` after a valid cache must force rebuild. Failed geometry, resource-limit admission, invalid image, and dropped staged scene must preserve old valid cache and output.
5. A structurally different scene with the same command count and tile envelope must never reuse old indices. Reorder and remove commands, including different image/glyph resources with identical bounds.
6. External BGRX regional rendering must not make the internal RGBA diagnostic image clean; after it, `try_pixels` must render current canonical colors and remain coherent. Conversely, a diagnostic `pixels` call followed by external render must not let external buffer age be mistaken for cache authority.
7. Empty command list/empty tile envelope, 1×N and N×1 shapes, exact 16-pixel boundaries, a near-maximal admitted tile grid (66×1008, dimensions 1041×16113), and MAX_REFERENCES/command-limit boundaries. Check capacity stats before/after to ensure `bin_bytes` reports retained vector payload even when invalid; separately account the boxed scratch header.

The initial CSR slice should not cache proof-cut starts. The follow-up below establishes that this is a separate, potentially valid optimization with a narrower invariant; it is not part of the scratch-cache correctness gate.

## Follow-up: exact opaque-cut cache invariant

At `5f4db5f2886e6d72aefd585d21dd6543774f1393`, `render_band` computes a per-tile `start` with `ordered.iter().rposition(...)` (`crates/canvas/src/canvas.rs:1711-1758`). A command qualifies only when `color[3] == 1.0`, its source is exactly `Rect`, and `full_tile(command, tile)` succeeds. `full_tile` reads the admitted rectangle, clip, map, and conservative integer bounds (`canvas.rs:2126+`); it does not read RGB or any resource payload. The returned value is the position *within that tile's ordered CSR slice*, and all earlier commands may be skipped because this is the last qualifying opaque full-tile rectangle in painter order.

For the existing `PaintCommit` API, that start is invariant under every accepted edit: `prepare_paint` rejects zero alpha and requires `edit.color[3].to_bits() == common.color[3].to_bits()` before `commit` writes only `Common.color` (`crates/canvas/src/canvas/paint.rs:87-100, 144-197`). Thus exact `alpha == 1.0` eligibility cannot change, while source, geometry, clip, bounds, resources, and painter order also remain fixed. HDR, negative-zero RGB, or other admitted RGB bit patterns do not enter the proof predicate. `set_tile_proofs` changes whether the proof is used, not its truth; a cached start can survive false→true toggles. Alpha-changing edits are rejected before mutation. This proves the cut is *not* inherently color-dependent for the currently admitted paint-only operation.

If a later slice caches starts, reuse the existing per-tile `cursor: Vec<usize>` after CSR scatter: initialize every tile to `usize::MAX` (unknown); on first raster of a tile, run the current `rposition`, store its relative start (including zero when there is no useful cut), and reuse it for later same-geometry paint renders. The maximum admitted command count is 65,536, so no valid relative position is the sentinel. A successful geometry/order mutation must invalidate before it changes commands: `clear`, successful rectangle/rounded append, image append, text append, and `CanvasScene::commit`. Invalidation only after admission/reservation but before append avoids stale authority if an append unexpectedly unwinds. Failed validation/admission and a dropped staged candidate do not change current commands and may preserve the cache. Paint commits and proof toggles preserve it. Any future mutable resource or alpha-edit API must either prove the same predicate invariant or invalidate the starts.

The cache key must cover the exact retained CSR envelope. A request inside that envelope can reuse CSR and cuts by translating tile coordinates through cached origin and row stride; a request extending outside it should rebuild the requested envelope. Do not force a full-canvas grid for a caller whose first render is a small region: that changes the existing region-only memory and work contract. If an ROI is a strict subset of the cached envelope, cuts are indexed by cached tile coordinates, not ROI-relative coordinates. Rendering one tile per output band gives each worker a disjoint mutable cut-row slice; immutable command/offset/index borrows remain separate. The current `Frame: Copy` cannot itself carry `&mut` cuts, so pass a separate mutable row/slice into each band. Rayon’s `ParallelSliceMut::par_chunks_mut` promises nonoverlapping mutable chunks: <https://docs.rs/rayon/latest/rayon/slice/trait.ParallelSliceMut.html.

This cut cache would remove the repeated per-tile reverse proof search after the first render of each tile; it does not by itself remove `RenderPool::render`'s separate `frame.commands.iter()` estimator (`canvas.rs:1678-1704`). Once cuts are known, a scheduler can get a cheap O(tile-count) proxy from `offsets[t+1] - offsets[t] - start[t]`, but `remaining_refs * TILE * TILE * 16` is a coarse upper-cost estimate, not equivalent to today's bounding-area estimate. It can schedule Rayon for a tiny, low-sample workload and lose to serial dispatch. Preserve or separately redesign the current uniform-fullscreen special case, and measure the crossover with sparse, dense, proof-heavy, and partial-region scenes before claiming a net win. On a cold tile, its cut remains unknown until raster; a coarse reference-count estimate avoids a second proof scan but may overestimate. There is no need to add a second per-command table or tag each CSR reference for this experiment.

Adversarial oracle cases for a future cut-cache implementation: compare pixels against `tile_proofs=false` after same-alpha recolors for opaque full-tile backgrounds followed by transparent/opaque overlays; include exact 16-pixel boundaries, axis-aligned reflections, clips that fail only one sample, non-axis-aligned maps rejected by proof, SDR and RGBA16F HDR, negative-zero/subnormal RGB. Assert unchanged `skipped_command_tiles` and cached relative starts across accepted edits; verify alpha edits fail without changing commands or cache. Then append/reorder/remove commands and change the cached tile envelope, including an empty ROI and a strict-subset ROI, to prove invalidation and origin/stride mapping. Run serial and parallel against the same byte oracle, including row partition edges and the final partial pixel band.

## Verification gate

First land correctness tests and exact allocation/layout ledgers. Then benchmark a matched control with: (a) first CPU raster, (b) repeated same-scene render, (c) one same-alpha paint update + regional repair, (d) one structural scene commit + render, (e) GPU-only `recording`/native path to verify no scratch allocation. Report CPU time, allocations, and retained capacity independently; no timing win is claimed by this proposal. Compare cached pixels byte-for-byte against the existing rebuild path for all admitted output formats and proof modes, and verify native surface damage/history remains unchanged.

## Source references

- Current Canvas fields and initialization: `crates/canvas/src/canvas.rs:847-920`.
- Command mutation paths: `Canvas::clear`/`fill_shape` at `crates/canvas/src/canvas.rs:995-1054`; image append at `1077-1150`; text append at `1171-1257`; staged scene commit at `2014-2100`.
- Bin rebuild, cache key source, frame construction, and stats: `crates/canvas/src/canvas.rs:1443-1533`.
- Frame ownership and tile work: `crates/canvas/src/canvas.rs:1536+`, `render_band` at `1711+`.
- Paint-only invariant: `crates/canvas/src/canvas/paint.rs:87-100, 144-197`.
- Region/BGRX API contract: `crates/canvas/src/canvas.rs:1380-1440`.
- Native buffer-age ownership: `crates/gpui/src/runtime.rs` (`render_preserved_bgrx`) and `crates/gpui/src/native.rs` (`present_cpu`); neither should be modified to validate this CPU cache.
