# Analytic backgrounds: first vertical slice

Unadopted implementation on `4b44b21a187c5029a83357eb03034cdad5aec141`.
This is a bounded vertical slice, not comprehensive CSS gradient support.

`Gradient::new(geometry, stops, extend, Interpolation::LinearSrgb)` prepares one
immutable analytic resource. `div().bg(&gradient)` borrows it for description.
Linear, elliptical radial, and conic geometry use coordinates relative to the
background rectangle. Element transforms move coverage and paint together;
uniform rounded corners and the current device rectangle clip use the existing
correlated 4 by 4 sample lattice. Conic turns increase clockwise from upward;
at the center the parameter follows the upward ray before start-angle rotation.

Stops are explicit, finite, ordered offsets, including offsets outside zero to
one and duplicates. The last duplicate wins at the exact stop; before the first
stop the first color wins. Pad extends endpoints, repeat wraps the last-minus-
first interval, reflect alternates its direction, including negative parameters.
Color conversion precedes premultiplication and interpolation. Extended and
negative RGB survive until the existing output conversion; exact author color
bits remain separately readable. Every material, even one with all alpha-one
stops, remains spatially varying and cannot take a uniform-solid certificate.

The constructor rejects fewer than two or more than 4,096 stops, decreasing
positions, positive subnormal intervals, offsets or authored geometry beyond
one million, degenerate geometry, and prepared coefficients above one trillion.
Repeat/reflect also reject zero periods and domains exceeding 2^20 periods over
the normalized rectangle. These are explicit numerical admission limits. They
are not CSS stop fixup or CSS degenerate-gradient averaging. CPU and WGSL share
prepared f32 coefficients and the interval search; coverage retains the current
f64 CPU and two-float GPU rules. The tested GPU tolerance is an oracle result,
not a portable theorem about transcendental functions or discontinuity ties.

`BACKGROUND` is one typed `Property<Brush, PaintStyle>`. Its value is either a
solid Color or a GradientKey; Style.bg holds the compiled solid arm and is
transparent while a gradient is selected. There is no second override property.
Existing color literals, direct signals, and mapped colors keep their builder
path. An inspector contribution is authoritative; its solid cache masks existing
color ports until Inherit. Solid contributions use the existing style override
lane; the cold resource bank stores only gradient overrides. Resolution selects
a gradient override, then an explicit solid override, then the declared gradient
or solid base. Inherit clears the contribution and reveals the latest declaration.
A plain solid setter never creates a gradient resource bank. A gradient key has private lanes and monotonic checked
64-bit identity, independent of allocator addresses. Setting a key validates
current-owner resource membership and the current target generation. Inspection
requires both a live target and its matching resolved key; it exposes geometry,
spread, interpolation, and every original stop. Keys are not serializable
capabilities or a persistence/replay format. Mounted inspection gives gradients
a read-only summary; solid background channels retain existing editors.

Resource ownership belongs to the existing cold SceneResources pointer, shared
with images. It deduplicates immutable resources, reuses unchanged leases across
descriptions, retains resources selected by live overrides, and prunes dead node
identities and unreferenced keys. Combined image and gradient payloads obey the
existing 64 MiB resource budget. Admission sorts the already-owned description
drafts by key, sums distinct resources together with live gradient override keys,
and finishes before mutating the preceding bank. Resource retention uses that key
ordering; a second in-place sort restores node order for reconciling declarations
in place. The new logical identity index is reused for liveness. The sparse
override-key set still allocates when needed, and sorting/work remains proportional
to the description. Ordinary owner-description allocations are not eliminated.
The old image presented/pending Vec leases have
been removed: production image queries used only logical resources, while Canvas
already owns the latest complete scene and the backend owns submitted buffers.
An eligible complete scene survives a failed newer source preparation; stale
ACKs still cannot publish another sequence's metadata.

A resource is one ThinArc allocation: an eight-byte public handle, an eight-byte
four-aligned key, a 24-byte allocation header, 48 bytes of packet headers and 64
bytes per stop. Each stop holds position/reciprocal, premultiplied base/delta,
and exact author Color words. Canonical Canvas takes one lease per distinct new
resource; draws borrow it. A staged replacement refers to predecessor keys and
moves their leases only at commit under its exclusive Canvas borrow, avoiding
warm refcount operations. Aborting leaves the predecessor intact. The GPU packs
these same words after its existing draw prefix and image tail, with no new
binding. Stable key sets, including permutations, upload zero resource bytes
while prefix capacity fits; changing a resource or growing the prefix uploads
the packed set again. This is not partial stop-range upload.

Ordinary Color, Style, Node, Destination, PropertyValue, PropInput and ElementExtra
size floors are asserted. Image-only cold Canvas and GPU resource headers each
pay an optional gradient pointer; gradient-only Canvas currently shares that
image resource envelope. SceneResources shrinks after removing redundant lease
vectors. Description drafts and borrowed prepared values are transient costs,
and linked code/stack growth must be charged separately from retained headers.
Fearless SIMD handles coverage; gradient parameter and interval evaluation is
currently scalar within each covered sample. No gradient stop Vec is cloned or
rebuilt per frame. Full owner description, scene lanes, binning, material lookup,
and output sampling still run when those operations are requested.

Remainder: interpolation in Oklab/Oklch/encoded or other spaces; hue routing and
missing-color-component rules; CSS omitted-stop fixup, hints, double positions
and degenerate averages; focal/two-circle radial geometry; arbitrary gradient
paint transforms independent of the element; gradient text and borders; rounded
descendant clip chains; exact-source mapped gradient replacement; mutable stop
editing and partial interval uploads; durable resource serialization/replay;
vectorized interval sampling and analytic AA. Dynamic stop replacement currently
constructs a new immutable resource and uses a legitimate owner rebuild.

Semantic references reviewed before implementation:

- [CSS Images 3](https://www.w3.org/TR/css-images-3/): stops, hard edges,
  premultiplied interpolation, repeating intervals, and CSS degenerate behavior.
- [CSS Images 4](https://www.w3.org/TR/css-images-4/): conic orientation and stops.
- [CSS Color 4](https://www.w3.org/TR/css-color-4/): explicit interpolation spaces,
  premultiplication and hue handling; broader modes remain unsupported here.
- [Skia GradientShader API](https://api.skia.org/classSkGradientShader.html) and
  [interval implementation](https://skia.googlesource.com/skia/+/a17799aa59f3fadd18729e1c76e41086fcaae9ca/src/shaders/gradients/SkGradientShader.cpp):
  explicit tiling/degenerate choices and hard-edge interval evaluation.
