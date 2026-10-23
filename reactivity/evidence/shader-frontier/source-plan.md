# Renderer traversal deletion and shader frontier

This isolated candidate starts from
`51f38a3a9b7f62e6f45fbfcd9c95292eb98cb0df`. Its target directory is
`/tmp/gpui-shader-frontier-target`. No build or measurement has run: the initial
source work occurs during the Todo benchmark quiet hold. Source checkpoints
are fusion `dc8d462cab`, test/plan `331c8816c7`, and the separately reviewed
single-kernel control `dd7a83babd7df2359e2a2e8e1ead0a09c30db596`.

## First source checkpoint: fuse metadata and tile-reference emission

`RendererState::render_observed` originally makes three placement traversals:
admit/write records and count tile references; patch resource metadata; emit
reverse tile references. The middle traversal can disappear. The reverse pass
already reconstructs each exact variable-width record address. It can write
that record's resource metadata before emitting references to it.

The first pass and image/atlas preparation stay in their original order. No
resource upload precedes validation of every draw. Metadata patches are to
independent records, read immutable resource indexes after preparation and
preserve the fourth metadata word. Thus reverse patch order changes neither
the final words nor correction/common addresses. Prefix/range/reference
construction, tile certificates and submission ordering stay unchanged. No
allocation, field, public API or shader source changes are needed. This deletes
one group/placement decode traversal, not a tile-binning traversal: existing
`binning_tile_visits` still counts the same two tile visits.

The drafted public Canvas test queues four translated page states before any
readback. Both pages contain glyph runs, rounded panels and a shared image with
different material radii. A stationary inspector-shaped overlay is later in
the same scene. Inline/compact records and tile proofs use the same CPU pixel
oracle. This exercises real existing materials and rendering, **not** a new
custom shader or full interactive inspector API.

Before adoption, run the same added fixture on unchanged base and candidate,
then all existing GPU pixel, image reorder/growth, grouped records, paint/slot,
queued replay and failed-preparation cases. A temporary nonshipping observer
will compare complete CPU record/range/reference/correction bytes between
matched executables, including image offsets and compact shared addresses.
Count actual group/placement traversals separately from public statistics.
Preserve source/config/lock/compiler/feature fingerprints before and after.
Inspect linked render entry/callers, frame sizes and whole linked text with
identical release settings. Assert retained carrier layouts and allocation
controls rather than infer them from the absence of new fields. No speedup or
startup claim follows from deleting the traversal. Timing needs a separate
root grant and preregistered workload.

## Actual capability boundary

Current `gpui_gpu::shader::ui` is a fixed public typed compositor module. Its
host/WGSL layout test is not consumer-defined shader admission. The current
canonical scene admits solids, rounded solids, glyph masks and images. The
ordinary Graphics component and built-in inspector use those materials.
`Source::direct(Affine)` and an explicit Remote inbox support externally driven
transform animation; there is no integrated motion/frame-request or arbitrary
fragment/pipeline API in this core.

Legacy `shader-paint` at `b88e813f2451efbb898256ae6b21e011514c2aea`
has typed expression, foreign shader, custom pipeline and transition APIs.
Those use expression-node Arcs, compiled-program caching, per-layer tracking
and Entity/RefCell transition state. They are reference contracts, not an
owner design to copy wholesale. A CPU-generated Image alone would not provide
their GPU shader semantics.

Arbitrary fragments must execute in ordered composition. In the current
fullscreen sampled compositor that requires a closed shader program set in
the compositor or another pass/intermediate with an explicit ownership and
sampling contract. Merely exposing a WGSL callback does not resolve this.

## Separate bounded shader control

The fixed compositor links two complete ordered compositing paths: ordinary
sample-major (sixteen decodes per draw, two RGBA accumulators) and banked
draw-major (one decode per draw, sixteen RGBA colors). It also has duplicate
ordinary/banked record decoders. The bank-aware decoder correctly handles
nonbank records because the stored bank flag selects direct color bits.

One possible simpler control is a single four-sample-row compositor. Decode a
draw once for each row, update four sample colors, then reduce in the exact
existing row-major anchor/delta order. It would remove the duplicate decoder,
fragment path and scene-bank dispatch without a pipeline cache or owner. The
trade is explicit: ordinary live RGBA colors grow; banked record decodes grow.
Array indexing/register spills, generated WGSL/SPIR-V, native compiler code
size and all material/HDR zero/boundary pixels must decide whether it survives.
The parent approved this separate source control, implemented at `dd7a83babd`.
It is uncompiled. The CPU Globals bank-dispatch bit is removed; the private
packet bank certificate required for slot-edit admission stays intact. The
source delta is 24 physical insertions and 79 deletions, separately from the
fusion delta of 23 insertions and 33 deletions. These are not qualified
noncomment core line counts or a compiler cost measurement.

Qualification will compare three exact sources: unchanged base, fusion only,
and fusion plus the single kernel. All use identical root configuration,
compiler, lockfile, features, render fixture and device policy. Before any
shared target switch, clean the changed packages for the actual profile and
require fresh compilation in the recorded Cargo fingerprint. Unset generic
RUSTFLAGS and CARGO_ENCODED_RUSTFLAGS, use jobs1 and the isolated target.

First prove generated WGSL validation, complete existing pixel tests, the
queued page test, ordinary versus paint-bank agreement, sparse slot/paint
edits, negative-zero/HDR boundaries, image formats/sampling and transformed
fractional glyph/clip cases. Retain every initial failure. Rebuild the optional
artifact with its existing full ABI/guard/profile proof; no old SPIR-V result
qualifies new shader source. Both default and optional paths need strict and
Apple/MSVC library checks before integration.

Record generated WGSL and SPIR-V sizes/entry call graphs, byte-identical binding
layouts, host render/code/frame/layout bills and available native driver
compiler outputs. The important compiler question is whether four sample
colors remain registers or become indexed scratch, not merely whether Rust
source is shorter. Native compile duration and steady frame cost require a
separately granted quiet timing campaign. If the control fails the preregistered
pixel or performance gate, preserve the negative and reject this kernel rather
than retain a runtime fallback or another shader pipeline mode.

The source-pinned zgui comparison (`c077cd3bc2e63311e04ecc0e7b484c7e1192d595`)
uses ordered instanced quads, lazy Basic/Full pipelines and hardware blending.
It avoids this CPU CSR and gives custom fills their own pipelines, but its
analytic/raster coverage and effect boundaries differ from this compositor's
sixteen-sample linear-light contract. Replacing that contract needs explicit
product/API review, not an optimization label.
