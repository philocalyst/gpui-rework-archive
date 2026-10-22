# Transactional paint substrate

Source `ab51133c84` adds a low-level canonical Canvas color transaction and an
opt-in GPU packet owner. It does not yet connect Signal/style fanout to GPUI
publication. That coupling must preserve source admission, exact complete-C
stamps, pending full candidates, old P semantics and native acknowledgement.

## Canvas transaction

Capture `paint_cursor()` immediately before a paint call and resolve it with
`paint_index(cursor)` immediately afterward. An empty/clipped call has no
index. A `PaintIndex` is a checked u32 painter-order group position, not a
semantic identity or lifecycle capability. A replacement scene can reuse its
position; the caller qualifies sink bindings with the admitted complete-scene
token. Index resolution and edit admission check the current group boundary
and reject image material (its private color lanes carry shape parameters).

`PaintEdit::new(index, Color)` converts one validated author color to immutable
premultiplied working words once. `Canvas::prepare_paint(&edits)` validates the
entire strictly increasing edit list, source materials and equal positive alpha
bits before changing anything. Its guard borrows Canvas exclusively and the
edits immutably. Dropping it changes nothing. `commit()` writes existing inline
or shared common color words in O(k), marks diagnostic pixels dirty if working
bits changed, and returns conservative damage. It allocates nothing, copies no
scene, retains no old color pages and changes no Canvas field or command stride.

The complete Canvas C is the commit target. Runtime already commits full Canvas
candidates before acknowledgement, so paint commits need no overlay/COW tree.
Pre-commit failure preserves prior C. After C commit, submission failure must
recover from latest complete C while acknowledged P remains the old geometry /
physical presentation. This substrate never acknowledges a native frame.

CPU output remains lazy. Paint edits do not invalidate geometry or resource
membership, but existing raster entry points still rebuild disposable CSR bins
using reused scratch allocations. No CPU bin-work or latency removal is claimed.

## Damage proof

The source evaluation domain of each edited command is unchanged: local shape,
transform, clip, glyph mask, material, painter order and alpha bits are fixed.
Outside its existing retained integer command bounds, the command is never
evaluated and cannot change any sample. An inline edit therefore uses exactly
those conservative bounds. Shared glyph placements all lie inside their common
clip after Canvas admission. Outward integer rounding of that clip, intersected
with the checked viewport, contains every evaluated pixel and costs O(1).
It may cover far more pixels than glyph ink; it avoids a glyph-count scan on
foreground edits.

Outside the union of those supports, changed sources are identical and every
unchanged layer is identical. Induction in source-over painter order preserves
all working samples there. Output conversion is pointwise with unchanged
configuration, so outside-support pixels are unchanged. The returned region is
not an external-buffer-age certificate: callers still need their existing
preserved-target/age proof. Full repaint remains required when that proof is
absent. Queued pending-candidate damage must be unioned by the runtime.

## Opt-in GPU owner

`PaintRenderer::new(Renderer)` owns a Renderer plus one active-site Vec. It has
shared Renderer diagnostics via Deref, but no DerefMut or mutable inner escape.
`into_inner()` consumes the map. Ordinary Renderer has no added fields or
allocation. Its ordinary render path uses an empty specialized observer.

`PaintRenderer::render(scene, target, requested_indices)` captures only requested
positions in the existing full-scene walk. It clears the old map and revokes
replay before any full-render mutation, including failures during resource
preparation. A site's color offset is installed only for a shared common word
or one inline command. Multi-placement ungrouped diagnostic groups decline
patching and require full rendering. Sites are not a second tree or retained
per-draw expansion. Capacity shrinks when more than four times current demand
and is released at zero requests.

`binding(index)` resolves once when installing an active sink. `PaintBinding`
is a u32 current-map position, also not a semantic/generation capability. A
copied binding can be in range after a later full render. `GpuPaintEdit` pairs
it with the Canvas edit; admission checks both the current map index and its
Canvas ordinal. The native complete-C token supplies exact cross-frame meaning.
Patch admission directly indexes only k sites; it performs no binary search or
scene traversal. Binding installation uses a binary search of the active map.

`prepare_paint(edits, target)` validates the whole ordered batch, target,
positive alpha and proof-color class, then lends a commit guard. Invalid target
validation preserves an existing valid packet. Drop changes nothing. Commit
moves the packet out before the first CPU/GPU record write: a panic cannot leave
old replay authority over partially changed words. It uploads only changed
16-byte color words, then uses the existing bindings to clear/draw/submit the
**whole target**. Ordered writes and submissions on this one serialized queue
preserve earlier in-flight frames. No duplicate GPU color pages or resource
reference increments are introduced by this ownership protocol. Queue/driver
internal staging allocations are not measured or claimed absent.

Opaque tile optimization is color-sensitive despite unchanged alpha. The
existing renderer excludes negative zero/subnormal channels from its
backdrop-independent full-tile certificates. An opaque rectangle patch into
that class is rejected conservatively; full preparation recomputes proofs.
Uniform tiles read the draw's current color word, so legal same-alpha colors
need no per-tile RGBA patch. Masks, rounded shapes, images, atlas, correction
records, indices, viewport, format and output globals otherwise remain intact.
Actual mode changes invalidate replay and the map. A resource failure does too.

## Evidence and scope

See `../evidence/paint-patch/` for source/artifact hashes, raw gates, layouts and
optimized code. Full parallel Canvas, 36 actual Vulkan cases, exclusive-borrow
compile failures and strict all-target Clippy pass. Queued A/patch-B/patch-C
without intervening polling matches forced full rebuild bytes in SDR and HDR.
A post-image-upload AtlasFull fixture proves map/replay revocation. Invalid
second edits, dropped guards, profiles/masks/overlap, HDR proof fallback and
preserved-buffer repair are covered.

Canvas stays 552 B and Renderer 872 B on this pinned target. The opt-in wrapper
is 896 B: one 24 B Vec header plus 12 B per reserved active site. Positional keys
are 4 B; Canvas/GPU edits are 20/24 B; each stack guard is 40 B. Canvas validation
and commit allocate zero bytes in the owner-thread counter fixture. These are
not whole-driver memory claims. No new dependencies, unsafe code, native host
changes or per-node/P/Runtime fields are added in this substrate.

The optimized ordinary render body has no paint-module callback calls. Opt-in
preparation has a separate specialized full-render body, so enabling both paths
has a code-size cost. There are no latency measurements or speed claims. A patch
removes CPU scene validation/binning/upload work in the GPU preparation path;
it still performs the same complete-target GPU sampling. Native token handling
and GPUI reactive publication remain the next integration slice.
