# Paint-only style updates: a retained command patch path

Research snapshot: 2026-10-21. The audited cleanroom source is GPUI commit
`cc4c3042826e88f42e07e9b58ff87972bdc494ed`. This is a proposal only; no
production source, build, or timing was changed/run for this note.

## Finding

A direct reactive color update can bypass `View` description, layout, text
shaping, the full `Presented` geometry vector, and Canvas command reconstruction.
The smallest coherent boundary is a typed **paint-only candidate** represented
as a short list of color changes to command groups already present in the latest
complete Canvas scene. It needs no per-node field, no parallel tree, and no
general dependency graph. Validate all destinations and conversions first,
reserve any bounded scratch, then apply the changes to canonical Canvas C in
one infallible O(k) commit. P remains the old acknowledged cohort until native
presentation succeeds; an eligible update leaves its geometry, role, hit
eligibility, focus, and semantic metadata unchanged.

This removes the O(N) GPUI preparation and renderer validation/binning passes.
It does not, by itself, remove all GPU pixel work: on targets without a proven
preserved-destination/age contract the renderer still has to redraw the full
surface. The current GPU `redraw` is whole-packet replay, not a color update or
partial repaint. Keep those two gains separate in code and measurements.

## Why the current path is expensive

`Runtime::patch` currently handles only visual text and semantic annotations.
Visual text changes invalidate shaped text, mark layout dirty, and enter the
ordinary presentation path. A paint-only style port would currently reach
`present_inner`, which may compute layout, allocates a candidate `Presented`
vector, visits every logical node, reconstructs Canvas draw commands, updates
metadata, and creates a `Prepared` cohort.

Canvas deliberately has a robust full-scene transaction: `Canvas::stage` builds
a separate pending Canvas, and `commit_with_damage` compares old and new
commands in painter order. `DisplayList::damage_from` is O(number of commands),
because its generic replacement API must detect geometry, clip, source, color,
clear, and command-count changes. The GPU `Renderer::render` clears packet
eligibility first, validates and repacks the entire scene, bins draws to tiles,
uploads draw records and indices, and creates a bind group. Its `redraw` skips
that preparation, but submits the whole target from the renderer's last admitted
packet; it does not apply a style delta.

Local source anchors: [`Runtime::patch` and `present_inner`](../crates/gpui/src/runtime.rs),
[`Canvas::stage`, `DisplayList::damage_from`, and draw-group append](../crates/canvas/src/canvas.rs),
and [`Renderer::render` / `redraw`](../crates/gpu/src/renderer.rs).

## Narrow eligibility rule

Start with `bg` and `fg` only. Route a changed sink directly only when all of
these hold:

1. The source's entire fanout for this publication consists of admitted
   paint-color sinks. A source also feeding text, metadata, dimensions, font,
   flow, transforms, images, or another layout/semantic property takes the
   existing full path. All destination conversions and validations complete
   before any destination changes.
2. No unrelated description, topology, layout, resize, scale, scroll, image,
   resource, or semantic change is pending. The source sink is still the same
   owner-qualified `(node identity, PropertyId)` binding installed with the
   current complete C. A stale or missing paint locator falls back to full
   presentation; it never guesses from a node's present-day traversal index.
3. The change preserves the exact alpha bits and the existing command topology.
   For the first slice, require nonzero alpha and identical alpha bits. This
   keeps the source command present and keeps `Presented::hittable` unchanged
   for `bg`. Alpha transitions can add/remove commands, change the background
   hit predicate, or create/destroy a Canvas command; they use full prepare.
   Opacity, image source, radius, clip, transform, and text/font changes are
   likewise outside this path.
4. Only premultiplied color words change. Geometry, inverse transform, clip,
   command ordering, draw source, glyph masks, image leases, color config,
   viewport, output format, renderer/device generation, and tile bins remain
   exactly those of the base packet. Any mismatch falls back to the full path.

Use the existing style schema's exact authoring equality before making a patch.
Under an inspector `Set`, update the source/base value but do not patch the
effective color; `Inherit` later reveals the newest base. A `bg` alpha change
must fall back even when both values are nontransparent, because the first
implementation should make the `hittable` proof simple and explicit. The later
optimization can relax that only after `Presented` hit semantics and semantic
publication are proved unchanged for the particular node.

## Smallest representation change

Keep `Node`, `Style`, `Presented`, and existing Canvas draw records unchanged
in size. Extend the existing cold style-binding destination with a paint
locator only for dynamic paint sinks. Use the command-order index at the start
of the paint call as `PaintSlot`: `order[slot]` already resolves to the inline
draw or grouped placement, and a grouped placement already resolves to its
shared `Common`. That makes the locator a checked `u32`, with no new Canvas
map and no new per-command key. Its validity follows the active binding table:
the runtime replaces that table atomically with the Canvas command order on a
successful full C, and color-only patches never reorder commands. Record it as
the current `order.len()` when the paint call emits its commands; an
empty/clipped call has no slot. Rebuild the active locator lane with a
replacement C and publish it only when that C is complete. A
hidden/internal indexed Canvas append API can return
`Option<PaintSlot>` without changing existing public `fill_rect`/`draw_text`
signatures.

Represent only the pre-commit candidate as a compact staging list:

```rust,ignore
struct PaintChange {
    slot: PaintSlot, // validated index into this C's color-bearing group
    color: Color,    // or the already-admitted premultiplied words
}

struct PaintCandidate {
    base: PresentationToken, // latest complete C, not P
    changes: Vec<PaintChange>, // sorted/coalesced by slot; latest value wins
    damage: DamageRegion,
}

```

Names are illustrative. The `base` token is the current complete-C token; the
paint locator itself is tied to the current Canvas order by the active binding
table. Validate a slot by checking
`slot < order.len()` and,
for a grouped command, that `group_ranges[common][0] == slot`; an inline command
is its own one-command group. This catches stale or malformed locations without
rebuilding a node-to-command map. After validation, apply the staging list
directly to private Canvas command groups as the C commit point, then mint the
ordinary new complete-presentation token. P remains unchanged until native
acknowledgement. `PreparedScene` therefore continues to borrow one canonical
scene; it needs no overlay cursor or patch-aware iterator. Before the commit
point, any error drops the staging list with no partial Canvas mutation; use
the full path when the patch is unsupported. If that full preparation also
fails before its Canvas commit, old C/P remain. After the color patch's C
commit, GPU admission or surface failure leaves the new complete C available
for the existing full-render recovery path while old P remains the last
acknowledged cohort. This matches the current full path, where successful
Canvas candidate commit precedes native submit and `Win::presented(token)`
later swaps P. No Canvas copy or rollback buffer is needed after C commits:
post-commit failure recovers by rendering that latest complete C.
Carry the ack bookkeeping without rebuilding rows: an active `Prepared`
candidate can store `Replace(Vec<Presented>)` for a preceding full candidate or
`Keep` when paint is the only pending change. If a full candidate is already
pending, preserve its rows while advancing the token and unioning damage. At
ack, `Replace` swaps rows; `Keep` retains current P. Both advance the source /
presentation stamp. This matters when another source update arrives before the
previous token is acknowledged; a paint-only update must not discard that
pending geometry candidate.

Damage must also accumulate from the still-unacknowledged candidate, just as
`present_inner` unions the prior `Prepared.damage`. Compute each changed slot's
support from its existing conservative command bounds before the color commit,
then union it with pending damage. The Canvas commit remains O(k); only the
existing `DamageRegion` representation is updated.

The active locator lane adds storage only for direct reactive paint sinks.
Expected incremental capacity is one small locator per bound paint property,
plus O(k) transient color changes during validation/commit. `Node` pays zero
bytes; a literal-only window pays no locator entries, per-frame allocation, or
patch pipeline. Make the active metadata's exact `size_of` and allocator
request part of the ledger before adoption.

Do not introduce `Arc` command chunks in the first version. A fixed-page COW
array would copy the page directory on every patch (O(N/page_size) pointer
copies), clone a whole page for one scalar, and retain old/new pages through
commit. That is avoidable here: the color patch is naturally a tiny validated
staging list, and canonical Canvas C remains the rollback source. A persistent tree would
add levels, allocations, and another ownership topology to save a small page
directory copy; only revisit it if measured patch staging or commit costs
justify it.

## Renderer packet and target safety

The current `GpuSurface` authorizes replay only when its private packet token
equals the current `PresentationToken`; public `PreparedScene` headers are not
an identity capability. `Renderer::Packet` binds the renderer's reusable
`draws`, `tiles`, `indices`, correction, and atlas resources. The regular
`render` invalidates replay eligibility before it clears or replaces those
shared buffers. This packet is the most recently admitted complete C; it is
not an immutable copy of acknowledged P. P authority stays in Runtime's
acknowledged `Presented`/semantic cohort and in pixels already accepted by the
native surface. A color patch must preserve that authority boundary:

1. Before mutating canonical Canvas C, validate the complete owner-side delta:
   current base token, every owner-qualified sink, every command slot and
   material, color conversion, damage support, physical size, color
   configuration, output format, device generation, and bounded scratch
   capacity. Any failure here leaves old C untouched and can use the ordinary
   full path.
2. Apply the already-validated colors to C as one infallible O(k) commit and
   mint the new complete-C token. C is now the recovery source even if a later
   renderer or surface operation fails; do not preserve a second Canvas copy
   merely until P acknowledgement.
3. At the private native boundary, revoke the old replay token before the
   first GPU-record mutation. Patch only the color words in the existing
   admitted draw-record buffer, update matching CPU record words, and reuse
   existing tile references, correction data, atlas, and bind group. The
   renderer's packet remains eligible only for the new token after successful
   patch submission. If patching, submission, or presentation fails, leave
   packet replay ineligible and recover from the retained latest complete C
   through ordinary full rendering. Never hand out an old token after an
   in-place GPU mutation.
4. The full `Renderer::render` traversal already knows each group's record
   word address. Retain those addresses in an active-only packet lane for
   `PaintSlot`s. A compact grouped record has one shared color word; the
   ungrouped diagnostic mode either records all glyph word addresses or
   declines the fast path and uses full render. Never infer an address by
   comparing color values.
5. Serialize patch preparation, queue writes, submit, native `present`, and
   token acknowledgement on the existing owner/render path. In this source,
   the UI native path calls `GpuSurface::render` then presents and calls
   `owner.presented(token)`; the owner does not expose a concurrent mutable
   renderer path. `wgpu::Queue::write_buffer` stages its transfer before the
   next submit, and ordered submits on one queue observe prior submissions.
   This is sufficient for a single serialized queue; it is not permission to
   mutate buffers concurrently or reuse a token after the write.

No separate old GPU page or old Canvas scene is required. The renderer packet
is an optimization for the latest complete C, not the immutable acknowledged
P. If presentation does not acknowledge the new token, the physical old P
remains the last published cohort; retry can redraw latest C. If the native
surface is lost, coordinate authority is revoked and a full render of latest C
is the recovery path. The only Canvas rollback boundary is before C commit:
prevalidation or source-admission failure leaves old C/P untouched, while a
post-commit GPU/surface failure follows normal latest-C recovery without
restoring old C. P/semantic cohort ownership remains unchanged until ack.

GPU shader submission is still expensive if it renders the entire target. It
can first retain complete-scene correctness while skipping CPU validation,
binning, uploads, and bind-group creation. A later damaged-target path is legal
only for a backend that proves loaded destination pixels and buffer age. On a
preserved target, damage is the union of the changed groups' existing
conservative bounds; redraw every command intersecting each damaged tile, in
the original painter order, after restoring the scene clear color in that tile.
Redrawing only the changed translucent command is wrong: it omits content below
it, and later translucent commands must be recomposited over the changed result.
If target contents/age are unknown, draw the full scene from the patched packet.

External contracts informing this boundary: this cleanroom pins wgpu and
wgpu-hal 29.0.4. [`Queue::write_buffer`](https://docs.rs/wgpu/29.0.4/wgpu/struct.Queue.html#method.write_buffer)
executes before the next submit; ordered queue submissions observe prior
submissions ([`wgpu_hal::Queue`](https://docs.rs/wgpu-hal/29.0.4/wgpu_hal/trait.Queue.html));
these ordering rules do not establish presentation acknowledgement or buffer
age. That remains the native surface's capability and GPUI token protocol.

## Variable draw content and fallback cases

Text is the best first foreground case. A `draw_text_scaled` call emits one
shared `Common` for the entire visible glyph run and `Placement`s for the
variable number of raster masks. Changing `fg` preserves the glyph count,
positions, image/mask leases, and group order, so it changes one common color
word even for a long or complex run. The locator must refer to the group, not
one glyph or a guessed range. Empty/offscreen text may emit no group; retain an
explicit absent locator and treat a still-invisible source update as no pixel
damage. A later exposure/full presentation uses the latest logical style.

Rect backgrounds are also one inline command under the current GPUI paint
calls. Switching from no command to a visible command, transparent-hit fill,
or vice versa is not a color patch. Images, rounded-image material flags,
shapes, clips, list/scroll translations, and color-profile/surface changes can
alter source encoding, geometry, resource leases, bins, clear, or tone mapping;
they use the full scene path. Reordering commands invalidates all locators by
Canvas generation. A locator mismatch is a safe fallback, not a recoverable
index guess.

## Prior art: what transfers

Qt Quick documents the closest useful architectural precedent: it retains a
render scene graph and synchronizes changed `QQuickItem`s to scene-graph nodes
at a defined render-thread synchronization point. Its renderer retains buffers
between frames and updates the part represented by changed nodes. This validates
separating logical property change, retained draw representation, and renderer
submission. It is not a drop-in layout: it retains a separate scene graph/node
model and item-to-node synchronization, exactly the extra ordinary-node state
this slice avoids. See Qt 6.12's [scene graph overview](https://doc.qt.io/qt-6.12/qtquick-visualcanvas-scenegraph.html),
[default renderer](https://doc.qt.io/qt-6.12/qtquick-visualcanvas-scenegraph-renderer.html),
and [`QQuickItem::updatePaintNode`](https://doc.qt.io/qt-6.12/qquickitem.html#updatePaintNode).

Vello's current architecture (`linebender/vello` main snapshot
`65338c258f091883c6ab99b4e9b7d2b47caafb4a`) says its production CPU/GPU
Sparse Strips paths flatten and bin paths, retain coverage around boundaries,
and compact fully covered runs. This is relevant to bounded raster/intermediate
work, but it does not provide a GPUI node-to-color-slot delta protocol. Its
merged [PR #1759](https://github.com/linebender/vello/pull/1759), merge commit
`c33438626fbd307bdc7b158566c028d16355b1d7`, explains that coarse raster work
can make CPU preprocessing erase expected GPU gains and complicate filters;
the rewrite deliberately gives up that coarse tiling model for a simpler strip
submission path. The transferable lesson is to benchmark CPU scene preparation
separately and keep tile/sample proofs exact. Adding a second path/coverage
representation here would not remove the current O(N) command build and would
increase correctness and memory burden.

Source links pinned to the current snapshot: [Vello architecture](https://github.com/linebender/vello/blob/65338c258f091883c6ab99b4e9b7d2b47caafb4a/ARCHITECTURE.md)
and [PR #1759 merged revision](https://github.com/linebender/vello/commit/c33438626fbd307bdc7b158566c028d16355b1d7).

Do not substitute a tile cache, SDF, or Arc-per-node command tree for this
mechanism. SDF does not represent arbitrary glyph/image sources, exact
profile-tagged color, or the existing sampled-coverage oracle; tile caching
still must preserve painter order and restore the prior backdrop; Arc chunks
pay atomic traffic, page-directory copies, and old/new C retention. The
direct color word already sits at a stable command group. First patch that
word and retain the existing tile proof only if the source is eligible.

## Implementation and gate corpus

The narrow candidate is accepted only if all of these pass:

- **No-tax:** literal-only Elements, Nodes, Styles, Presented rows, and Canvas
  commands have unchanged size; a window with no reactive paint sink makes no
  locator allocation. Counters prove a paint patch visits only its changed
  destination(s), and records actual allocator requests/capacities for one,
  two, and many reactive paint sinks.
- **Output oracle:** bitwise/reference-image equality between a forced full
  repaint and a sequence of color patches for opaque SDR, Display P3/linear
  profiles, HDR linear premultiplied color, glyph masks, overlapping children,
  reflections, clips, and translucent layers. Keep exact colors and alpha bits;
  don't use hashes as proof.
- **Ordering and damage:** patch the lower of two overlapping translucent
  rectangles, then the upper, then both before one frame; result matches a
  full ordered redraw. Check old/new damage bounds, clip edges, outside-damage
  pixel preservation, and full-draw fallback when surface age is unknown.
- **Source authority:** exact equality is a no-op; source publication updates
  several same-color sinks atomically; mixed text+paint fanout uses full path;
  `Set` masks the update and later `Inherit` reveals the newest source base;
  stale generation, removed sink, duplicate update, or pre-commit validation
  failure never partially mutates C. Unsupported patch candidates fall back to
  full preparation; if it fails, prior C/P/token remain. A post-commit render
  failure keeps new C/token and old P, then recovers by full rendering.
- **Alpha/topology:** zero-to-positive and positive-to-zero `bg`/`fg`, hit
  eligibility transitions, empty string, clipped/offscreen glyph groups, and
  text/font/image/transform/resize/scroll changes all select the full path.
  Verify no `Presented` hit/semantic field changes on admitted fast updates.
- **Packet lifecycle:** A submitted baseline packet followed by a patch, a
  failed patch admission, an asynchronous device/surface fault, stale ack,
  lost surface, resize, renderer recreation, and retry. The old replay token is
  never accepted after any record mutation; after C commit, full rendering
  recovers from the latest canonical Canvas scene. Queue write and rendering
  must remain on the serialized renderer owner.
- **Accessible publication:** active AT observes no geometry/role/focus/action
  delta for the eligible color patch; the presentation/source stamp still
  advances only on successful ack. Failure retains the exact old semantic P.

## Benchmark plan

Use the already validated JustRach NanoUI, MyGo, and GPUI native fixtures and
their source-pinned manifests; do not change font, dimensions, or app paths in
the runner. Keep backend, display server, color profile, resolution, and AT
runtime state visible in every result. The previous application campaign used
Xvfb drawable updates, not scanout, compositor latency, or hardware-vsync, and
its cross-framework font/renderer differences must remain disclosed.

Build one identical control interaction per framework: click a fixed visible
swatch/control that changes only its own background or text color. For GPUI,
capture pre-port model/view invalidation and the direct `Signal<Color>` patch
candidate under the same visible fixture. Collect 100 fresh starts per cell
from spawn to the exact first-present marker, and 1,000 motion+press/release
clicks per cell from accepted press to the matching XDamage-confirmed marker
pixel. Keep startup and click endpoint clocks separate. Include `n`, p50/p95/p99,
all errors/outliers, and report startup-independent idle RSS/PSS/thread samples
only as diagnostics.

Use 0, 1,000, and 10,000 eager rows with the target control in the same
viewport, then a separate 250,000-item virtual-list cell only for frameworks
with the same keyed virtualization/visible-row contract. Do not force-equalize
overscan; report realized rows. Reuse the existing accepted input driver with
explicit executable SHA guards, exact PPM/text/geometry preflight, persistent
XDamage observer, and alternating baseline/candidate process order. Never
include the prepared-but-unmatched historical captures.

Add internal stage counters/timestamps: event received, source value frozen,
property compare/patch accepted, candidate token formed, changed color records
uploaded, tile/frame submit, `pre_present_notify`, native present, and exact
owner acknowledgement. A successful path should show zero `View` reruns,
zero layout computations, zero `Presented` row comparisons/allocations, zero
Canvas command reconstruction/diff, zero GPU scene validation/binning, and a
bounded color-word upload of `k` patch groups. Report full-target GPU samples
separately from preserved-target damaged-tile samples. The latter is a distinct
capability-gated result, not the presumed consequence of a color patch.
