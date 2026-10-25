# Graphics that preserve work across changes

The renderer should preserve the strongest invariant a change leaves intact.
A color change preserves coverage. A camera change preserves local geometry and
local hit indexes. A cached group's motion may preserve all local pixels. A
fully hidden region may require no pixel work. Reaching those cases directly
removes more work than choosing a faster universal raster kernel.

The current [transactional paint substrate](docs/paint-patch.md) checks a
complete batch before mutation, preserving command geometry, masks, resources
and exact-alpha tile certificates. [Registered GPUI sources](crates/gpui/PAINT_PATCH.md)
now drive those edits and native GPU color patches directly. The existing GPU
preparation walk records requested groups; patches retain admitted bins and
bindings but still draw the complete target. Coalesced token gaps can rebuild
that packet. The [combined core/paint checks](evidence/core-paint-integration/README.md)
cover exact full-GPU readback oracles, native transitions and both desktop
cross-target adapters.

The [CPU membership implementation](benchmarks/bin-miss/README.md) reads ordered
integer bounds without material/resource reconstruction and reuses a containing
cache for regional repairs. One immutable cache is borrowed by disjoint output
bands. Its lazy 80-byte owner reduces recording-only Canvas by 64 B and increases
active header storage by 16 B. The proposed shared paint/space-bank replacement
is a separate implementation spike: the current source path still writes k
bound destinations and its GPU map still performs per-site lookups. Persistent
GPU target repair and shared mutable-source slots remain unimplemented here.

Pixels still have to reach the display. SDF, analytic curves, sparse strips,
compute rendering and native retained composition are different ways to represent
and evaluate the scene before that point. The proposed backend contract admits
each without making every application pay for every implementation. The supporting
[graphics research](docs/graphics-research.md) pins sources and separates published
claims from local experiments.

## Keep geometry, coverage, paint and composition separate

Use one scene vocabulary with four independent dimensions:

| Dimension | Examples | Reuse key |
| --- | --- | --- |
| Local geometry | Box/corner recipe, path segments, glyph outline, image quad, shader domain | Shape/outline/metrics revision and local parameters |
| Coverage | Analytic primitive, sparse edge strips, hinted glyph mask, certified implicit field, exact edge refinement | Geometry, device-space footprint, fill/AA rule and clipping inputs |
| Paint | Solid/gradient/image/video/custom paint with linear color metadata | Paint parameters and resource generation |
| Composition | Source-over, isolated group opacity, blend/filter/backdrop pass, native/guest surface | Ordered dependency graph, clip/space and target generations |

Instances reference shared local geometry and typed paint/space slots. A paint
patch updates its slot without rebuilding coverage. Common primitives avoid path
flattening entirely. A path whose coverage changes keeps its outline and paint.
A platform group transform avoids app rasterization only when its content surface
or stable local primitive representation actually survives the update.

Coverage reuse does not imply occlusion-plan reuse. Retained bins, predecessor
cuts and effect summaries depend on resolved paint alpha, group opacity, clip
coverage, material opacity and backdrop/sample footprint. Changing an opaque
foreground to translucent must restore its background commands from the canonical
scene before drawing. Changing zero opacity to visible must admit the suppressed
work. RGBA/opacity schemas declare an impact ceiling including occlusion/region
dependencies; unchanged alpha can cut off that sub-impact at runtime. A typed
opaque RGB paint can avoid it. No source geometry/command is permanently deleted
merely because a disposable worklist proved it hidden for an earlier version.
Test opaque red over blue becoming half-alpha red: the result includes blue.

This factorization reduces shader/pipeline duplication. Shape evaluation produces
coverage; paint evaluation produces premultiplied linear color; composition obeys
the selected operation. Specialize hot combinations per packet/range so a giant
branching shader does not replace duplicated source with per-pixel dispatch.
Generated host/shader schemas define layouts, alignment, resource types and
validation once. A common expression format must remain inspectable and bounded;
it is not an unrestricted shader compiler hidden inside every widget.

## A small algebra removes complete passes

For one premultiplied source-over fragment, write `p` for its premultiplied color
and `t = 1 - alpha` for transmittance. Its action on a destination color is
`F(c) = p + t*c`. Ordered composition becomes:

```text
(p_a, t_a) compose (p_b, t_b) = (p_a + t_a*p_b, t_a*t_b)
```

This affine color action is associative in real arithmetic and ordered, so it
supports summaries and scans. The identity is transparent paint. A proven
fully-covered opaque fragment has zero transmittance and removes dependence on
everything behind it at those samples. A partial coverage mask is not an opaque
proof. Finite-precision grouping retains a specified order/format/error policy;
the matrix-path experiment already shows why real algebra alone is insufficient.

The scalar transmittance formula assumes scalar coverage/alpha. LCD/component
coverage needs its explicit component compositing contract; it cannot silently
reuse scalar summaries or color-filter pushdown. Backend packet typing carries
that distinction, with grayscale as a valid quality/capability fallback.

Lower equivalent operations before allocating intermediate targets:

- Transparent source-over contributes nothing when no side effect samples it.
- An opaque full-coverage overwrite needs no destination read for that region.
- Group opacity one needs no opacity-isolation pass if no other group obligation
  requires isolation; group opacity below one cannot be distributed across
  overlapping children arbitrarily.
- Zero-radius blur is an identity. A shadow with zero alpha contributes nothing.
- Identical inherited hard clips can share/intersect their local definition.
  Soft ramps multiply; replacing two ramps by a hard rectangle is incorrect.
- Consecutive compatible integer translations can update placement without
  regenerating local coverage; fractional translations can change it.
- A paint/shape operation wholly outside a conservative clip/support bound needs
  no draw/coverage allocation. Uncertain bounds retain the operation.

These identities are tested through the full blend/effect oracle. They cannot
remove an operation whose texture/shader side effects or destination/backdrop
sampling remain observable. The sealed built-in graph has declared effects;
an untrusted custom shader takes a conservative capability/footprint path.

[FORMULATIONS.md](FORMULATIONS.md) derives further candidates: alpha-preserving
linear filter pushdown removes group surfaces; compatible Gaussian fusion and
closed-form rectangular shadows remove mask/blur passes; support certificates
remove irrelevant clips. Their color, truncation-error and intermediate-format
restrictions are explicit. They remain proposed until integrated oracle and
backend-quality tests pass.

## Coverage as a proof with a refinement path

Let d be an exact signed distance, negative inside, and suppose its error at a
sample is bounded by epsilon and its Lipschitz constant is L. For every point
within radius r of that sample:

```text
d_true is in [d_sample - epsilon - L*r,
              d_sample + epsilon + L*r]
```

An interval strictly above zero proves exterior; strictly below zero proves
interior. Only a boundary interval needs edge work. A local exact SDF has L=1;
under an invertible world transform, an inverse-operator norm supplies a
conservative metric bound. Singular, ill-conditioned, overflowing or uncertified
cases refine/fall back. A claimed distance sample from arbitrary bilinear atlas
data does not automatically have a usable epsilon.

Use this classification at tile/strip/pixel footprint scales. Large flat regions
can become compact full spans; empty tiles disappear from worklists; only boundary
regions refine. Keep the canonical local field/outline and transform the query,
matching the local support-function formulation in [DESIGN.md](DESIGN.md). Avoid
building and resampling a fresh world-space distance texture on every motion.

The classifier does not define antialiasing by itself. A point `smoothstep` on
distance is not exact area coverage for arbitrary corners, small features,
curvature or anisotropic footprints. Boundary evaluation uses analytic integration,
exact/controlled edge evaluation, or a documented reference sampling error.
When quantization or field-generation error cannot be bounded, field rejection
is disabled; the outline remains authoritative.

Certificates are backend-numeric objects, keyed by geometry, parameter encoding,
space mapping, shader precision/FMA policy, coverage rule and scale. A CPU f64
interior proof alone cannot authorize a GPU f32 full tile: narrowing the radius
of a circle just larger than sqrt(2) can exclude a corner of [-1,1]². Include
outward error for parameter/matrix quantization, arithmetic, AA footprint and
sampling/filtering, or certify directly over the backend's admitted representation.
Otherwise refine/fall back. The same space revision does not by itself make two
numeric implementations evaluate the same geometry.

The executable coverage experiment examines a deliberately small analytic domain
first. Its certified tile decisions, distance evaluation counts, worklists and
sample-compositing oracle are evidence for the formulation. It is not a general
font/path rasterizer or a proof of arbitrary sampled SDF accuracy.

## Choose an evaluation family by retained content

Four implementation families consume the same recipe protocol:

1. **Analytic primitives and implicit curves.** Rectangles, circles, capsules,
   corners and gradients use small bounded formulas. Loop-Blinn-style curve
   equations can handle appropriate curve patches, while path winding,
   self-intersection, fill rules and clipping remain separate obligations.
2. **Sparse strips with a CPU or fragment fine stage.** Preprocess local edges,
   bin them, and retain compressed full runs plus boundary coverage. This is the
   practical non-compute vector path to compare with the current renderer.
3. **Compute count, scan, bin and fine evaluation.** Use dense work assignment
   when geometry/tile volume repays dispatch and scan costs. Counts, offsets and
   output capacity are bounded; overflow selects a tested fallback rather than
   truncating a scene.
4. **Implicit glyph/shape fields with outline refinement.** Reuse validated
   fields across an admitted scale range, keeping exact edge data and quality
   fallbacks. This can amortize repeated glyph/icon work without assuming one
   atlas resolution works for every font or transform.

Vello's pinned architecture distinguishes its sparse-strip CPU/fragment paths
from its research compute renderer; that distinction is useful when choosing
compatibility and startup cost. [Vello architecture](https://github.com/linebender/vello/blob/7d70631ac848925972c85171dc064a803003f796/ARCHITECTURE.md).
Do not infer a backend design from an old crate name. Prototype adoption at a
versioned packet seam rather than merging its scene ownership into the core.

Measure complete work: local preprocessing, retained edges, tile references,
strip/field bytes, upload, dispatch, shading/compositing, synchronization and
presentation. An O(edges) prefix scan may lose to reusing a handful of dirty
strips. A tiny analytic primitive may lose if a general interpreter or worklist
is required before every pixel. A field can lose through atlas generation,
fallback rates and texture bandwidth even when its shader is short.

## Text is a geometry and quality problem

Keep shaping and editing independent from glyph coverage. Text layout owns
cluster mapping, bidi, ligatures, fallback, baseline, variation, inline atoms,
selection and IME. Glyph rendering cannot simplify those semantics away.
Shared shaping keys include all observed font/script/text/feature inputs; equal
string length is not a valid key. Layout answers can share metrics without
forcing identical text content or label state.

Choose glyph coverage by scale, transform and font quality requirements. Hinted
grayscale coverage is the baseline for small text. LCD coverage is capability-
dependent and cannot assume an opaque RGB panel or ignore compositor/color-space
rules. MSDF can preserve corners better than a scalar field, but small features,
overlapping contours and edge-coloring failures remain adversaries. Large
transformed type can use outline/analytic or validated field rendering. Color
emoji/images use their own resource path. Cache the chosen representation by
quality and input revisions and bound all atlases.

Slug's published outline method and MSDF research are algorithm references, not
licenses or proofs that a complete font stack can be replaced by one shader.
[Outline coverage](https://www.terathon.com/i3d2018_lengyel.pdf),
[MSDF source](https://github.com/Chlumsky/msdfgen).
Test low ppem stems, narrow counters, acute corners, fractional translation,
anisotropic scale, rotation, emoji/fallback and mixed scripts against the selected
reference. Hinting changes the intended outline at small scales; exact evaluation
of the unhinted outline does not reproduce it.

## Damage is a backward dependency query

A source change defines output support. Rendering it requires the ordered inputs
that can influence that support. The retained effect graph carries both forward
support and backward sampling/dependency maps. A blur dilates required input;
a shadow offsets and dilates it; displacement expands by its certified range;
a backdrop node depends on the intersecting scene behind it. Gaussian support
is mathematically infinite, so truncation uses a declared tail-error bound.

Compute affected output regions forward, then required predecessor regions
backward through the selected effect/clip/composition graph. Proven opaque
coverage terminates predecessor dependence per sample/tile. A conservative
unknown retains dependencies. This makes damage, occlusion and effect scheduling
one region-algebra problem rather than three independently maintained graphs.

Use compact exact rectangles while the set is small, then touched-word tiles or
row runs, then full-surface work when its complete cost is lower. Old and new
support are both required for movement/removal. Support includes AA, glyph edge,
filter and clip obligations. Bound error and overdraw are counted. The maximum
screen tile domain is a configuration/checked allocation limit, with a defined
coarser/full fallback for oversized surfaces.

Choose work granularity from measured cost, for example:

```text
cost(plan) = fixed dispatch cost
           + geometry/bins regenerated
           + coverage boundary work
           + destination pixels read/written
           + upload bytes and target transitions
           + expected lease/synchronization stalls
```

The cost model selects among semantically equivalent plans, with hysteresis and
caps. It does not turn estimated timings into correctness conditions. A bad
estimate may be slower; it must not omit a dependent pixel or allocate unbounded
scratch. Record full/partial/field/native-layer choices and fallback causes.

## Keep transforms local all the way to the backend

Scene packets reference immutable local primitives and sparse space/paint slots.
Changing one group transform updates its descriptor and outer support. Hit
testing maps into its local index; GPU evaluation uses that same transform
revision. Upload cost is proportional to changed descriptor ranges only if the
backend can retain the referenced geometry. Count any flatten/repack cost.

A cached layer or native visual can preserve rasterized local content across
motion. Earn a layer using reuse, coverage complexity, isolation needs and byte
budget. A short-lived tiny layer can cost more than direct drawing; a full-window
layer retains another full image. Opacity/filters/backdrop ordering determine
whether content is truly reusable. Promotion/demotion keeps semantic identity and
is inspected through normal work/lease counters.

Native composition offers a separate powerful lane: DirectComposition visuals,
Core Animation layers, or compatible compositor surfaces can retain content and
apply transforms outside the application's fine renderer. Their capabilities,
transaction timing, memory and surface interop differ. A native webview's
composition target can share that lane where supported; arbitrary child-window
interleaving cannot be assumed. Keep a single negotiated surface contract rather
than platform semantics leaking into component code.

## Presentation images have their own lifetime

At 3840 by 2160, one RGBA8 image is 33,177,600 bytes; RGBA16F doubles it. A
permanent full-size offscreen target adds another such allocation beyond the
swapchain/compositor images. Avoid requiring that image just because damage
tracking exists. Compare direct target repair, sparse retained tiles, cached
groups and a persistent full target under the same correctness contract.

Each acquired target has a generation and a known or unknown prior content age.
For a known age, repair the union of damage since that target's last coherent
frame. Retain only the bounded history required for the supported target ring.
Unknown age, exposure, resize, scale/format changes, recovery and device loss
force full repair or a copy from an explicitly accounted coherent source. A
partial-present hint does not make unwritten target contents valid.

DXGI dirty/scroll rectangles, Vulkan incremental-present hints, Wayland surface
damage and CAMetalLayer drawables provide different contracts. Wgpu's portable
surface interface does not automatically expose every platform's damage/age
mechanism. Advertise backend capabilities and preserve a correct fallback. Do
not infer a driver saved bandwidth because the application submitted rectangles.
[DXGI contract](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/ns-dxgi1_2-dxgi_present_parameters),
[Wayland protocol](https://wayland.freedesktop.org/docs/html/apa.html).

Bound frames in flight and queue depth separately from image count. More buffers
can reduce stalls but increase memory and latency. Reuse staging ranges, imported
textures and OS buffers only after their completion/release protocol for that
exact resource generation. Cross-window/device sharing and dma-buf/IOSurface
imports may avoid copies only for compatible formats, modifiers, devices and
fences. Report fallback conversion, readback and hidden compositor work.

## Share scratch by lifetime, not by optimistic aliasing

The effect plan knows which tile/strip/scan buffers overlap in time. Allocate
bounded pages/rings by lifetime classes and alias only non-overlapping uses.
Count/scan/fill separates output sizing from writes. GPU capacity overflow is a
status record with a valid recovery plan, not an out-of-bounds write or silent
primitive loss. New high-water pages are attributed to the operation that earns
them and can be evicted when unleased.

Keep code/fonts/devices/atlases/templates shared at their real scope. Demand-start
the GPU, font database and optional worker services. Read-only mapped asset or
template pages can remain shareable; use validated offset/length schemas and
leases, not serialized Rust object layouts. Cold regeneration can permit page
discard, but borrowed/live CPU/GPU memory cannot be reclaimed behind references.
Measure page faults, PSS/RSS, allocator payload, reserved stacks and GPU/compositor
allocations separately. A tiny ELF experiment is useful for understanding paging,
not an upper bound on a native graphics application's service cost.

## Color and effects remain explicit

Compose in the declared linear extended-sRGB working space with premultiplied
alpha. Tagged author colors and imported resources cross a single color-profile
boundary. SDR remains an efficient explicit tier; HDR/float16 surfaces are
negotiated with format and transfer metadata and do not double every target's
bytes by default. Coverage, paint alpha and premultiplication must agree at every
backend. ICC/CMS policy, video transfer/range/chroma siting and tone mapping are
resource/pass obligations, not ad hoc widget conversions.

Shaders declare local bounds, time/resource dependencies, sampling footprint and
output format. Unknown/unbounded footprints receive conservative damage and
isolation. A time-varying shader is active work with a deadline; a static shader
does not cause idle redraw. Media frame delivery updates a resource slot and
damage support with stamped leases, independent of owner re-description.

## Numerical and performance acceptance

Keep scalar coverage, full repaint, cold layout and reproducible coordinate
evaluation as independent oracles. The accelerated output must satisfy the
chosen coverage/color tolerance; fully certified interior/exterior classifications
must have no false decisions over the admitted domain. Uncertain classification
always refines. Domain/range checks are outside the hot certified formula where
possible and are tested at representational limits.

Measure tiny controls, dense text, wide transparent overlap, nested clips,
large paths, pathological tile bins, fractional scrolling, zoomed curves,
group-opacity interruption, blur/backdrop movement, 4K/multi-window, guest texture
imports, cold shader/font/device setup and idle. Include GPU completion and
compositor-visible latency where measurable. CPU submission time is not frame time.

The implementation order is analytic/reference coverage and the shared packet
schema; paint/space slots and typed impacts; sparse strips/dirty effect queries;
target-age repair and retained groups; then admitted field/compute/native
specializations. The selection gates include quality, first frame, idle, bytes,
p50/p99 and developer compile time. This builds one graphics contract with
replaceable kernels, while whole categories of repeated work disappear from the
common path.
