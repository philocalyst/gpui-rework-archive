# Canvas-owned CPU raster scratch

Research note against cleanroom main `0764b5d908ce777f2cb2b1ef6fdfba226aec057d`; no production code or timing claims are included.

## Proposed boundary

Move `Canvas.offsets`, `Canvas.indices`, and `Canvas.cursor` into a lazily allocated private `RasterScratch`, owned by the `Canvas` that owns the corresponding `DisplayList`:

```rust
struct RasterScratch {
    offsets: Vec<usize>,
    indices: Vec<u32>,
    cursor: Vec<usize>,
    tile_bounds: [u16; 4], // 16px tile coordinates; 0..=1024 for admitted canvases
    valid: bool,
}

pub struct Canvas {
    // ...
    raster: Option<Box<RasterScratch>>,
}
```

The cache is valid only for the current command geometry/order and recorded tile envelope. `render_output` computes the same tile bounds it does today, then reuses the CSR arrays only when `valid && tile_bounds == cached.tile_bounds`. Otherwise it clears `valid`, rebuilds offsets/counts/prefix sums/indices from the current `DisplayList`, records the bounds, and marks valid after construction. This cache belongs to the mutable owner; no token, external lineage map, sidecar, or second command tree is needed.

Invalidate before any accepted topology/order mutation: `Canvas::clear`, successful `fill_rect`/shape append, successful image append, successful text append, and `CanvasScene::commit`. Keep capacity for reuse, but set `valid = false` before entering the mutation so an unwind cannot leave bins apparently authoritative after a partial append. Failed validation/admission and dropped `CanvasScene` candidates do not invalidate: they never change the current scene. `PaintCommit::commit` changes only common colors (`canvas/paint.rs:87-100`) and preserves geometry/order, so it keeps bins valid. `set_tile_proofs` changes the proof path but not CSR membership and also preserves bins. Canvas dimensions/configuration are fixed after construction; if a resize API is added, it must invalidate.

On an empty region, preserve the current valid cache and return as today. The empty-region fast path may still report retained bin capacity. Cache identity includes the *tile envelope*, not the pixel damage rectangle: CSR membership is defined at tile granularity. A different rectangle that rounds to the same tile envelope can reuse the same bins. Buffer age/damage remains owned by the native surface and is not part of this cache.

The existing `Frame` already borrows `DisplayList`, offsets, and indices (`canvas.rs:1536+`), while raster workers receive immutable frames and disjoint output slices. A `build_bins(&DisplayList, &mut RasterScratch, bounds)` helper can preserve this ownership model: finish preparation before constructing `Frame`, then borrow `self.commands` and `self.raster.as_deref()` as disjoint fields. No mutable cache access reaches a worker.

## Exact costs and bounds

`Canvas` currently carries three `Vec` headers (`canvas.rs:847-862`): 72 bytes on the measured x86-64 layout. Replacing those with `Option<Box<RasterScratch>>` is an 8-byte field, a 64-byte reduction in every cold `Canvas` on x86-64. The scratch object is approximately 88 bytes (three 24-byte `Vec` headers, 8-byte bounds, validity plus alignment). First CPU rasterization therefore adds one allocation and about 88 live bytes; relative to the old inline headers, activated instances are about 24 bytes larger before vector payload/capacity. GPU-only recording gets no scratch allocation. This is not an active CPU memory win; it moves the headers out of the cold owner and pays them only when CPU rasterization occurs. Validate concrete `size_of`/allocation counts in the implementation.

Tiles are 16×16. The dimension contract admits each side up to 16,384 px and total pixels up to 16 Mi (`canvas.rs:6-8, 878-887`), so the largest tile grid is 1,024×1,024 = 1,048,576 tiles. At 1280×800, the full envelope is 80×50 = 4,000 tiles. `offsets` has at most 1,048,577 `usize` entries (8,388,616 bytes on x86-64); `cursor` at most 1,048,576 `usize` entries (8,388,608 bytes); and `indices` is bounded by `MAX_REFERENCES = 4,194,304` `u32`s (16,777,216 bytes). The theoretical payload maximum is 33,554,440 bytes, before allocator capacity rounding. Normal scenes are smaller; report actual `Vec::capacity`, not logical lengths. `MAX_COMMANDS = 65,536`, so command indices fit `u32`. Tile coordinates run 0 through 1,024 inclusive, so `[u16; 4]` is sufficient without narrowing assumptions about pixel-space coordinates.

This representation adds one boxed allocation the first time the CPU path is used. Today the three `Vec`s allocate their payload on first render (`render_output`, `canvas.rs:1470-1488`) but their headers are already inline. The new cache should not add any per-render allocation after the initial capacities stabilize. Existing bin allocations use `Vec::resize` and may panic on allocator exhaustion; `try_pixels` only makes output-image allocation fallible (`canvas.rs:889-897, 1356-1364`). Do not imply `try_pixels` currently provides fallible bin allocation. If bins become fallibly reserved in this work, preserve old valid bins until all required reservations succeed, or leave the cache invalid and surface an error; that is a separate API/error-path change.

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
7. Empty command list/empty tile envelope, 1×N and N×1 shapes, exact 16-pixel boundaries, 16,384×1,024 and 1,024×16,384 admitted extremes, and MAX_REFERENCES/command-limit boundaries. Check capacity stats before/after to ensure `bin_bytes` reports the retained scratch even when invalid.

Do not cache proof-cut starts in this slice. They are color/material dependent and offer a smaller optimization target with stricter invariants; the owned CSR cache already eliminates the two command walks while retaining a simple proof oracle.

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
