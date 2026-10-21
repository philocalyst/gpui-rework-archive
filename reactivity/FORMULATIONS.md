# Formulations that remove work

The following are concrete reductions, not a catalogue of exotic algorithms.
Each states the admitted domain, the identity, what disappears, and how to reject
it safely. Some have executable experiments; others are derivations awaiting
integration. [STATUS.md](STATUS.md) separates those cases. They complement the
representation in [DESIGN.md](DESIGN.md), rather than becoming separate runtimes.

## Share the program, store only instance differences

For N instances of a K-node component with F scalar fields, a fully expanded
representation pays O(N*K*F) values plus topology. Separate one immutable template
and field defaults from identity and sparse deviations:

```text
retained bytes = shared topology/defaults/recipes
               + instance descriptors
               + actual deviations and dynamic regions
               + independently varying layout/space/resource state
```

The last line matters: a shared topology does not make every layout, interaction
state or GPU allocation disappear. Hash filtering requires structural equality;
changing a value must not fragment an otherwise identical shape template. At
dense deviation rates, promote one typed lane to dense storage and preserve the
same target semantics. Byte-based hysteresis prevents promotion thrash.

The [template experiment](crates/template-lab/README.md) covers the first three
terms for scalar u32 data, including descriptor/vector capacities. It records
large repeated-static savings and small/dense losses. It does not establish the
memory of a complete rendered widget. Succinct navigation is not magically
constant time; the executable word-summary implementation has linear worst
cases. A hot navigation cache is an optional measured index, not a second tree.

Share static source-circuit plans similarly: constants have no node, a direct
wire has one destination edge, and fixed circuits share order/code while instances
store varying values. Only dynamic dependency sets pay edge discovery and cycle
maintenance. A generic heap allocation per graph relation is unnecessary.

## Keep positions implicit in virtual sequences

Let e[i] be a row's measured extent and g[i] its spacing. Its origin is:

```text
y[i] = group_origin + prefix_sum(e[j] + g[j], j < i)
```

Use a counted sequence tree with subtree extent sums, or a Fenwick index while
order is fixed. Editing row k changes O(log N) summaries; it does not write a new
transform into every later row. A viewport search finds the first visible row by
prefix extent, then streams visible origins. Splices/moves update the order tree
and keep List slot identity. Place shared row layout solutions at those origins.

Admit nonnegative finite extents with checked wide fixed units for this search
index. Zero extents require a tie rule. Negative overlap and arbitrary absolute
positioning use a different conservative spatial index; prefix monotonicity is
not true there. Source order and painter z-order remain distinct. Scroll anchoring
uses a stable slot plus local offset, not an unstable numerical row index.

Unmeasured rows use explicit estimated extents. On measurement, adjust the
prefix summary and preserve the chosen anchor under the documented policy.
Focus, selection, accessibility virtual children and pending actions retain
identity independently of offscreen geometry. Deep virtual offsets stay wide;
subtract viewport origin before narrowing. This removes an entire suffix-update
class without changing arbitrary-affine numeric semantics.

## Exact translations permit arbitrary regrouping

An exact lane admits fewer than 2^32 spaces and one i64 local translation per
axis in units of 1/256 pixel. Every partial path sum has magnitude below 2^95;
the difference of two such sums is below 2^96. i128 addition/subtraction cannot
overflow on this domain. Therefore a balanced tree, prefix scan or link-cut
preferred-path reshape returns the same result for every query/scheduling order.

Compute `wide_world(node) - wide_world(viewport)` first. Narrow that difference
only after a checked precision test. Converting both giant world positions to a
float before subtraction loses small movements. The
[exact translation experiment](crates/algebra-lab/EXACT.md) tests the extremes,
query reorder and viewport subtraction and inspects emitted carry chains.

This is an optional sparse-space specialization. Arbitrary fractional input is
not silently quantized; an application/animation using it explicitly chooses
the fixed grid and rounding at admission. Other translations and affine maps
retain the deterministic floating path or a separately certified representation.
The unrestricted affine splay experiment is rejected because f64 reassociation
changes a finite cancellation result on query alone.

## Pull a query into canonical geometry

For affine D(x)=A*x+t and local support h(K,u)=max(dot(x,u), x in K):

```text
h(D K,u) = h(K,transpose(A)*u) + dot(t,u)
```

Derivation substitutes D(x) into the dot product and maximizes over the unchanged
local set. No inverse is required, even if A is singular. A page retains canonical
local geometry/convex support once. Motion changes the query direction and offset;
it does not rotate an already-inflated AABB again.

An exact convex hull supplies arbitrary-direction support. A reduced outer
polygon supplies a conservative answer if reduction and outward rounding are
certified. Fixed directional samples need an outer-envelope construction and
error bound; interpolating sample values alone is unsafe. Enforce a device-space
looseness budget, rebuild from canonical geometry when exceeded and use full
damage on uncertainty. Test repeated rotations and near-singular shears.

The same canonical-frame principle applies to local hit indexes, field queries
and retained GPU geometry. It saves descendants only if downstream packets retain
their space/group identity. Otherwise report the flattening cost.

## Prove coverage before refining it

If an analytic distance field has an enclosing evaluation interval and Lipschitz
bound L, a tile of radius r is inside/outside whenever `d ± error ± L*r` lies
strictly on one side of zero. Interior tiles need no per-sample distance or edge
test; exterior tiles need no paint. Ordered fully opaque coverage also removes
the background commands for those tiles. Boundary tiles use the independent
refinement path.

The [coverage experiment](crates/coverage-lab/NOTES.md) uses outward f64 interval
operations, a certified inverse bound and explicit finite/conditioning admission
for boxes/circles. It compares complete plan+point-render work with an implicit
containment baseline, including allocation/work counters. Boundary-dense cases
lose; the general renderer must bypass proof setup below the measured grain.
Point-sample equality is evidence for culling/composition, not area-AA or font
quality. Backdrop reads prevent crossing an occlusion barrier.

## Push alpha-preserving linear filters into paint

Let v be premultiplied RGBA and let M be a linear four-component transform whose
last row preserves alpha. RGB bias proportional to alpha is also representable
by M. For source-over, a over b = a + (1-alpha(a))*b. Then:

```text
M(a over b) = M(a) + (1-alpha(a))*M(b)
            = M(a) over M(b)
```

Thus a compatible isolated group color filter can apply to its children's paint
parameters instead of requiring a full group image and postprocessing pass.
The group result can then compose over the unchanged external background. Merge
consecutive matrices into one paint transform. The saved work is the intermediate
target, its fill, read and synchronization, not just a few shader instructions.

Admit only declared alpha-preserving linear operations with no intervening
clamp, nonlinear transfer, quantization, backdrop dependence or incompatible blend
mode. Gamma conversion, alpha-changing filters, thresholding and arbitrary
color shaders do not satisfy the identity. Existing group opacity/isolation
obligations may still require the surface. Validate in the actual color format,
because intermediate UNORM clamping breaks the real-number proof. This is a
derived candidate, not an implemented renderer optimization.

This paint pushdown also assumes scalar coverage, or a proved commuting coverage
operator. LCD/component masks do not generally commute with a color matrix:
swapping RGB after a red-only coverage mask is different from swapping before
that mask. Keep the filter after component coverage, prove commutation for the
specific operators, or select grayscale. Include that counterexample in the
backend algebra tests. A scalar transmittance pair alone does not model arbitrary
component-alpha compositing.

## Fuse compatible Gaussian work; integrate rectangular shadows

On an infinite linear domain, normalized Gaussians compose by variance:

```text
G(sigma_a) * G(sigma_b) = G(sqrt(sigma_a² + sigma_b²))
```

Translation commutes with convolution. Compatible consecutive blur passes can
therefore become one pass, with shadow offset applied to placement. Intervening
clipping, resampling, nonlinear operations, changing edge policy or intermediate
format rounding break exact equivalence. Finite kernels must share a declared
error contract; two truncated reference kernels are not bit-identical to one
newly truncated ideal Gaussian.

For a solid axis-aligned rectangle [x0,x1]×[y0,y1], ideal Gaussian convolution of
its indicator is separable and has a closed form:

```text
alpha(x,y) = [Phi((x-x0)/sigma) - Phi((x-x1)/sigma)]
           * [Phi((y-y0)/sigma) - Phi((y-y1)/sigma)]
```

Phi is the standard normal CDF. Evaluate the expression as a bounded analytic
paint over the shadow support instead of rasterizing a mask and allocating blur
targets. Sigma zero uses the rectangle path. Thin rectangles, cancellation in
the tails, fractional pixels and overlapping shadows are adversaries. Rounded
rectangles, paths, clipped shadows and anisotropic transformed kernels require
their own proof/refinement; this formula does not cover them.

The allowed error is in final premultiplied output, not a vague kernel radius.
For an unrenormalized separable Gaussian cut to ±R in each axis, discarded mass
is `1-(1-2Q(R/sigma))² <= 4Q(R/sigma)`, where Q=1-Phi. For input channels bounded
by C, the convolution error per channel is at most C times that mass. Include
CDF approximation, arithmetic and sampling errors. Propagate error through later
linear operators with their norms and through composition under its declared
range. HDR/unbounded custom values require a declared bound or the reference
path. Choose R/precision from the quality budget, not a universal magic constant.

Test Horner versus Estrin/rational/table CDF evaluation for accuracy, dependency
latency, throughput and code footprint. Share coefficients/rounding policy with
the shader reference. The mathematical pass elimination must survive quality
comparison before instruction tuning matters. These are derived candidates.

## Remove clips that cannot affect support

For a convex hard clip, proving all vertices of a child's conservative convex
support inside the clip proves the entire support is inside. The clip operation
can be omitted for that child/range. Pull the containment query into a canonical
space; include AA and effect support, not just the original path's vertices.

An antialiased clip can be removed only inside its full-coverage interior with
the required inset. Nonconvex masks, filter-dependent clips and uncertain support
retain the clip. Intersect repeated compatible hard convex clips once. Do not
replace multiplying soft ramps with the nearest hard boundary. Certificates are
keyed by clip, geometry, transform, effect and scale revisions.

## Damage only where the final result changes

Old union new support is the safe general movement bound. A stronger case exists
for one opaque constant-color axis-aligned rectangle translating over an otherwise
unchanged background: its common fully-covered interior is unchanged. Repair the
exposed old/new bands and changed AA boundary. The overlap needs no draw.
Texture coordinates, transparency, gradients, backdrop effects, different z-order
or a changing background invalidate that reduction.

An integer scroll of a retained image can copy/present a reusable rectangle and
repair exposed strips, provided overlap-copy semantics, source validity, effects,
target generation and the platform presentation contract are proven. Fractional
scroll can change every edge/glyph sample. Buffer age still requires accumulated
damage for the acquired image. Neither trick makes a newly acquired undefined
swapchain image contain useful pixels.

## Delete rollback by separating cache from publication

A cache is not authoritative state. Keeping Cephal's private mutable workspace
separate from an immutable published layout sheet removes the need to replay
inverse mutations after a candidate fails. Discard candidate outputs and clear
the touched cache closure; poison/recreate on an unbounded fault. The displayed
sheet continues to lease its own answers.

This is safe only if readers never consult the workspace as current presentation
and custom measurement has no hidden side effects. A cache entry's transitive
inputs must be revision-complete; an opaque custom measure disables shared hits
unless it declares/captures every dependency. Resource ownership cannot be hidden
in a disposable cache entry. Retained-versus-cold answers and failure injection
are the proof. This is a contract amendment, not generic source rollback.

## Share physical pages only when lifetimes agree

Immutable templates, shaders, font/asset data and cold serialized pages can use
read-only shared mappings with stable offset schemas. Different processes may
then share physical pages; report PSS and private dirty memory alongside RSS.
Rust object layouts, function pointers and process capabilities are not mmap ABI.

Scratch targets/pages with nonoverlapping lifetimes can alias storage within a
validated pass graph. Prove size/alignment, initialization, CPU borrow end,
device barriers and last GPU/OS release before reuse. Offset handles can permit
relocation only when no live reference points inside the mapping. `madvise`, page
decommit, custom allocators and remapping are experiments after those conditions,
not a way around Rust lifetimes or driver ownership. A zero allocator count does
not imply zero page faults, graphics memory or compositor storage.

## Admission discipline

Every candidate above has four gates: an enforceable input invariant; an
independent equivalence/quality oracle; complete operation and memory accounting;
and a simple fallback. Promote only the measured region where it wins, using
hysteresis and bounded caches. Keep scalar/direct paths so specialization never
becomes the minimum application cost. The aim is fewer retained facts and fewer
passes, with implementation complexity proportional to the work actually removed.
