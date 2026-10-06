# Element coordinate spaces

Apply a camera to ordinary elements with one style:

```rust
use gpui::{ElementTransform, div, point, px, prelude::*};

let camera = ElementTransform::default()
    .scale(1.5)
    .translate(point(px(40.), px(20.)));

let graph = div()
    .size_full()
    .overflow_hidden()
    .child(div().size_full().transform(camera).children(nodes));
```

The outer element establishes a fixed viewport. The inner element and all its
descendants share the camera. Text, icons, borders, paths, shadows and filters
follow it. Hover, clicks, wheel input and captured drags follow the same geometry.
The [100-node example](../crates/gpui/examples/learn/element_transforms.rs) includes
cursor-centered zoom, middle-button panning and draggable, individually rotated
nodes. Run it with `cargo run -p gpui-ce --example element_transforms`.

## Coordinates and composition

Transforms operate after layout. They do not change flex sizing, wrapping, layout
bounds or scroll extents. A listener receives positions in its element's layout
space, including the usual layout offset; positions are not relative to the
element's top left. `window.mouse_position()` reports that same space while the
listener runs. `window.window_mouse_position()` always returns the platform's
window coordinates. Wheel displacements are mapped as vectors, without adding
the camera's translation.

`ElementTransform` operations apply in the order written: scaling then translating
is a camera with a pan measured in parent coordinates. `origin(point(0.5, 0.5))`
rotates or scales about the element's center. `scale_axes` permits nonuniform
scaling and reflection, and `from_matrix` accepts arbitrary affine mappings,
including shear. Child transforms compose inside the parent's transform.

`window.coordinate_space()` exposes the shared mapping. Retain a clone to map
between layout and window points with `to_window` and `from_window`. The inverse
is optional: a collapsed or non-finite transform cannot receive pointer input.
Rectangle conversion deliberately returns a conservative enclosing rectangle,
appropriate for platform APIs and culling. Hit testing uses inverse point mapping
and exact clip rectangles instead.

Custom elements can use `window.with_element_transform(matrix, |window| ...)`
during both prepaint and paint. Retaining a space during prepaint and re-entering
it with `with_coordinate_space` also retains its ancestor clips. Re-entering
`CoordinateSpace::default()` is useful for a window-space overlay outside a
camera's clips. The common element lifecycle applies styled transforms, including
to transparent wrappers and custom styled canvases.

## One geometry model

[Issue #273](https://github.com/gpui-ce/gpui-ce/issues/273) asks for composable
element transforms across rendering, clipping, pointer coordinates, caret geometry
and accessibility. The closed proposals [#309](https://github.com/gpui-ce/gpui-ce/pull/309),
[#310](https://github.com/gpui-ce/gpui-ce/pull/310),
[#311](https://github.com/gpui-ce/gpui-ce/pull/311) and
[#312](https://github.com/gpui-ce/gpui-ce/pull/312) informed the requirements and
regression cases. This implementation keeps geometry in layout coordinates and
shares its mapping through the element lifecycle and renderer.

`CoordinateSpace` contains a forward matrix, a precomputed inverse, cached raster
density and a persistent chain of clipping scopes. Hitboxes, listeners, deferred draws and input handlers
retain this value. Consecutive clips in the same space merge; clips across different
spaces keep their original rectangles and fade distances. A new clip removes a
prefix of ancestors only when its four corners prove that its entire support lies
inside each ancestor's full-coverage fade inset. Numerical uncertainty retains the
ancestor. Cached views include
the space in their key, so changing an ancestor camera invalidates geometry that
was retained in the old space.
Retained-view comparisons first recognize an identical immutable scope, avoiding
a walk of its clip chain. Separately rebuilt equivalent scopes still compare
structurally.

Painting interns those scopes into a frame-local GPU table. Primitives carry a
small space ID through their content mask instead of duplicating a matrix on each
primitive. The GPU maps vertices forward, evaluates shapes and gradients locally,
and checks each ancestor clip through its inverse. CPU bounding boxes schedule and
cull draws; they do not replace rotated shapes or clips. Scene replay imports and
remaps space IDs, preserving cached content even when a new frame interns spaces
in a different order. Parent links skip mapping-only scopes: composed transforms
are stored once, while the coverage walk visits only clips and collapsed scopes.
Identity drawing retains the ordinary single-mask path.

Fragments recover layout coordinates from their existing interpolated clip
distances. Those distances are affine in the local point, and every vertex has
clip-space `w = 1`, so they carry the same information as an extra local-position
varying. This removes repeated inverse applications without expanding vertex
interfaces. The identity path still uses the original fragment position.

The same shader sources and scene ABI serve WGPU, native Metal and DirectX.
WGPU's downlevel transport encodes the coordinate table alongside primitive data.
Path rasterization, surface passes and filter encoder restarts preserve the table.
Blur uses the affine mapping's two local axes, so nonuniform scaling and rotation
produce an oriented blur rather than an isotropic blur at the largest scale.
Isolated content retains the fades already painted into its children. Compositing
rechecks the exact hard clips, avoiding a second multiplication of those fades.

IME discovers visual lines in layout coordinates before mapping the selected
caret rectangle to the window; rotation cannot turn positions on one line into
different lines. Character lookup maps in the opposite direction. Accessibility
maps each node's bounds once, including nodes owned by wrappers and synthetic
children. These platform rectangles conservatively enclose rotated content.

Glyphs, emoji and SVGs rasterize at the mapping's greatest stretch while keeping
their layout size. Density rounds upward to eighth steps and caps at eight times
the device scale to limit atlas churn and extreme allocations. Text beyond that
cap remains valid but can lose sharpness. LCD subpixel text is used only with an
identity linear mapping and integral device translation; other mappings use
grayscale coverage.
`raster_scale_for` also accounts for an intrinsic bitmap transform, composing
matrices before measuring stretch. Opposing anisotropic scales can cancel; multiplying
their independent maximum stretches would oversample. SVGs use this same policy
for their preexisting intrinsic transformation API.
Transformed sprite sampling clamps to the atlas tile's texel centers, preventing
bilinear filtering from pulling colors or coverage from an adjacent tile.

## Validation and measurements

The element tests exercise actual retained trees, input dispatch, captured drags,
cached views, IME and accessibility. Headless pixel tests exercise exact nested
rotated clips, replay remapping, transformed paths and backdrop effects, and
anisotropic content blur. ABI and generated-shader tests cover the native and
downlevel layouts. Native Metal has a separate rendered clip/fade regression.

See [the benchmark notes](element-transform-benchmarks.md) for reproducible CPU
and GPU workloads, measured results and their limits. Geometry microbenchmarks
isolate their operation; they are not full application frame-rate claims.
The [clip reduction experiment](element-clip-reduction-experiment.md) compares
convex-polygon compilation, whole-chain filtering and the adopted prefix rule.
Polygon compilation enlarged the representation and did not preserve independent
fade ramps; the smaller rule keeps the existing clip representation and shader ABI.

The WGPU border-background comparison for a 90° gradient has a known baseline
failure: the archived pre-transform source produces `[228, 159, 103, 255]` for
the border and `[225, 158, 102, 255]` for the fill at `(10, 10)`. The exact test
also fails on that baseline, so this deterministic gradient-dither difference is
not evidence of a transform regression. The comparison remains strict and its
tolerance has not been widened.
