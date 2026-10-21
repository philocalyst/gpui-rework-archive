# Analytic rounded local geometry

This cut adds uniform circular corners to ordinary GPUI elements, Canvas solids
and immutable image placements. It uses the existing correlated 4 × 4 sample
lattice. It does not claim exact continuous area integration.

```rust
use gpui::{image, property::{Contribution, CORNER_RADIUS}, prelude::*};
// In View::view:
// image(&self.cover).size(128).rounded(12.0).name("Selected cover")
// In an ordinary owner turn:
// win.set_property(target, CORNER_RADIUS, Contribution::Set(8.0))?;
// win.set_property(target, CORNER_RADIUS, Contribution::Inherit)?;
```

`El::rounded(f32)` and `rounded_md()` (6 local units) affect this element's
background, own image placement and own coordinate hit region. They do not clip
descendants. A child visible in a parent's cutout remains independently hittable
and may bubble its action. Layout dimensions and text are unchanged. Radius is
finite and nonnegative, then clamped separately to half each painted rectangle's
local width and height. Zero, including negative zero, follows the existing
rectangular paint path. Exact authored bits remain available to inspection.

The rectangle has half-open outer bounds. Within it, the circle boundary is
closed. CPU paint and positive-radius input use the same f64 local predicate,
including the same inverse-transform expression. Painter order, ordinary clip,
color profile, HDR output and correlated layers retain their existing behavior.
Rounded commands never inherit the opaque rectangle/full-tile certificate.

## Immutable presentation authority

Radius declarations and inspector contributions live in cold owner geometry
state. Each complete candidate and acknowledged presentation owns its own sparse
radius column. Older P and an older complete candidate survive a failed newer
visual preparation. A semantic-only edit cannot relabel that failed visual
cohort. Acknowledgement promotes geometry with the rest of the existing sheet;
coordinate input reads only the acknowledged column.

Geometry freezing visits the sparse opted-in identities. Virtual-list filtering
uses the existing logical-to-published scratch and verifies the published
identity, since a skipped logical row's scratch index may name its ancestor.
Removal prunes overrides, and successful radius-free publication releases the
geometry box. There is no retained history of scrolled rows.

`Part::corner_radius()` exposes the frozen authored radius. Accessible bounds
remain conservative rectangles; native platform shape paths are not added by
this cut.

## Typed properties

`Property<T, D = Style>` remains one static declaration pointer. The sealed
`GeometryStyle` destination holds `CORNER_RADIUS` (property ID 13). Reflection
names the destination domain. A Style-only erased setter returns a typed
WrongDestination error for radius rather than applying a partial edit or
panicking. Existing ordinary selectors and generic default destination remain
source compatible. Static domain dispatch uses one owned call context and
capture-free closures; no Any or dynamic destination object is introduced.

A declaration now owns an exact-authoring comparator. f32, optional f32 and
Affine compare component bits; Color uses `same_authoring`; enums and bool use
ordinary equality. Numerical PartialEq is unchanged. This fixes inspector
Set(-0) losing author bits before geometry/style storage, while contribution
presence still distinguishes Set(default) from Inherit. Retained style interning
uses that same comparator protocol. Each static declaration pays one additional
function pointer in read-only data, not in elements or nodes.

## Canvas and GPU representation

The canonical source word remains u32. After the exact rectangle sentinel check,
a high-bit source carries the raw bits of a validated positive finite radius.
Image and filter tags move to bits 30 and 29; the resource index is below bit 29.
The 65,536-command ceiling bounds admitted resource indices, with compile-time
assertions documenting the disjoint domain. No command field or side table is
added.

Image material currently has no tint or per-placement opacity port. Its private
solid-color word was unused for sampling. It now carries `[radius, 0, 0, 1]`;
private damage comparison sees radius changes, while all public draw/group
views continue to report canonical white and expose the radius through
PreparedSource. Resource identity and pixel sharing are independent of radius.
A future tinted rounded image must use an explicit extended material record;
these same lanes cannot encode both capabilities.

GPU records retain their existing sizes: inline draw 96 bytes, shared common
80 bytes, compact placement 32 bytes and correction 32 bytes. Rounded solids
use the resource metadata word. Rounded images carry radius and normalization
in the existing color word, selected by image flag 16; a static assertion keeps
that bit disjoint from existing material flags 0–3. Rounded image groups fall
back to ordinary inline records when per-placement clamping could differ. No
variable record stride, additional binding, address lane, mask or radius table
is required.

The shader reconstructs corrected local coordinates with the existing two-float
arithmetic. It computes distances from the inner rectangle, applies an exact
power-of-two normalizer, and compares squared distances. It uses no sqrt or
smoothstep. Distance arithmetic, not only transformation, participates in
admission. Positive effective radius must be normal f32, and the conservative
local-magnitude/radius ratio must not exceed 2^20. The additional two-float
allowance passes through the existing 1/32-device-pixel error ceiling. These are
engineering bounds and tested adversaries, not a claim that every backend
classifies every circle tie identically to f64.

In particular, a small continuous boundary-position error does not bound the
difference in a discontinuous sample-membership decision: a sample arbitrarily
close to the circle can change one of the sixteen coverage bits. There is no
adaptive uncertain-circle lane or shader f64 fallback in this cut. Exact CPU/GPU
coverage assertions apply to the executed HDR fixture families, not all admitted
composed transforms. Precision rejection covers the declared numeric envelope;
it is not a per-sample proof that the sign of every squared-distance residual
matches CPU f64. This limitation must remain visible when extending the backend
precision contract.

CPU admission is intentionally broader. A positive subnormal radius is valid on
Canvas but returns located GPU Precision. The actual native Auto fixture
upgrades to GPU, applies such a radius, then falls back to CPU and compares the
entire fetched X11 window with the CPU oracle. Explicit GPU policy retains its
typed error behavior.

## Cost and limits

The final measured ledger is in `../evidence/rounded-geometry/`. There are no new
dependencies, unsafe blocks, bitmap masks or per-node resource leases. Ordinary
Style, El, Node and Presented strides do not grow. Existing metadata owners pay
one optional geometry pointer; radius-free owners do not allocate geometry.
Opted-in owners pay the geometry box plus sparse current/P/candidate entries and
inspector maps when used. Rounded plus named descriptions pay a second cold
allocation; this is charged rather than hidden in every annotation.

The first prototype used an image radius table and longer rare GPU records. It
is preserved at 90ac1f3291 for comparison. The final private lane interpretation
removes that table, header growth and extension allocation. No latency campaign
was run and no speed improvement is claimed. Uniform radius, conservative AT
rectangles, no descendant clipping, no border/stroke and the GPU numeric limits
above are deliberate scope limits.
