# Composable shader paints

Use `gpui::shader` to build a paint with ordinary Rust helpers and GPUI's normal
element builders. A paint describes color; the element supplies its bounds,
rounded corners, border widths, dashes, clipping, opacity, and stacking order.

```rust
use gpui::{div, rgb, Styled};
use gpui::shader::{color, shader, Paint};

fn waves(phase: f32) -> Paint {
    shader(|pixel| {
        let wave = (pixel.uv().x() * 12.0 + phase).sin() * 0.5 + 0.5;
        color(rgb(0x315bff)).mix(color(rgb(0xf48bcb)), wave)
    })
}

let surface = waves(phase);
let panel = div()
    .rounded_xl()
    .bg(surface.opacity(0.8))
    .border_2()
    .border_color(surface);
```

`Paint` is one concrete type, including after composition. Conditional Rust
recipes, hover styles, and reusable settings structs therefore stay ordinary
GPUI code. Background paints run before children; border paints run after them.
Existing solid colors, gradients, and patterns keep their direct rendering path.

## Typed values and small helpers

The `shader` closure runs on the CPU to assemble symbolic values. Rust functions
can accept or return `Field<f32>`, `Field<[f32; 2]>`, and the other float vector
types. No source annotations, shader modules, root, or parameter handles are
needed. Numeric and vector fields remain distinct from `Paint` and predicates.

Methods borrow their inputs, and arithmetic supports borrowed fields, so a
shared intermediate does not require a chain of explicit clones. For example,
distance to a line segment can be an ordinary helper:

```rust
use gpui::shader::{constant, Field};

fn segment_distance(p: &Field<[f32; 2]>, a: [f32; 2], b: [f32; 2]) -> Field<f32> {
    let edge = constant([b[0] - a[0], b[1] - a[1]]);
    let a = constant(a);
    let offset = p - a;
    let projection = (offset.dot(&edge) / edge.dot(&edge)).clamp(0.0, 1.0);
    (offset - edge * projection).length()
}
```

The available math includes component arithmetic, trigonometry, min/max,
clamping, smoothstep, vector length/dot/normalization, comparisons, and fragment
derivatives. `predicate.select(when_true, when_false)` selects typed values per
fragment. An ordinary Rust `if` chooses a recipe on the CPU instead.

## Coordinates and composition

`pixel.uv()` spans the component's box from `(0, 0)` at the top-left to `(1, 1)`
at the bottom-right. `pixel.position()` and `pixel.size()` use local logical
pixels, independent of display scale. Border paints retain the entire box's
domain even when the renderer draws only narrow border regions.

| Operation | Meaning |
| --- | --- |
| `front.over(back)` | Premultiplied source-over composition |
| `paint.mix(other, amount)` | Premultiplied interpolation, including extrapolation |
| `paint.opacity(amount)` | Scale all color channels and alpha by clamped opacity |
| `paint.mask(amount)` | Apply clamped coverage to this subtree |
| `paint.map_uv(|uv| ...)` | Re-evaluate this subtree at transformed local UVs |

Mapping a composite maps its children. Mapping one child before composition
affects that child alone. Mapping preserves size, layout, hit testing, and the
element's geometric clip. Geometry and inherited opacity apply once after the
composed paint has evaluated. Mapped logical-pixel position is mapped UV times
the unchanged component size.

`color` accepts GPUI colors and straight RGBA arrays; `rgba` accepts symbolic
straight channels. Both use GPUI's sRGB channel convention and premultiply alpha
internally. Channel access on a paint returns straight RGB and alpha. This makes
separate taps practical for chromatic refraction without exposing alpha-storage
details.

## Real backdrop sampling

`backdrop().sample(uv)` samples the scene already painted behind this component.
Its coordinates use the same component-local UVs as `pixel.uv()`. The renderer
converts them to the capture's coordinates, including when the element is away
from the window origin. Logical-pixel offsets can be divided by `pixel.size()`.

```rust
use gpui::{div, rgb, Styled};
use gpui::shader::{backdrop, color, shader, vec2, Paint};

fn glass(phase: f32, displacement: f32) -> Paint {
    shader(|pixel| {
        let uv = pixel.uv();
        let bend = (uv.y() * 18.0 + phase).sin() * displacement;
        let refracted = &uv + vec2(bend / pixel.size().x(), 0.0);
        backdrop().sample(refracted).mix(color(rgb(0xffffff)), 0.08)
    })
}

let panel = div().rounded_xl().bg(glass(phase, 6.0));
```

A capture occurs at each ordered use, so a background excludes its own children
and a border can see them. A border's sides share one snapshot; they cannot
sample sides drawn earlier in the same border. Sampling clamps at viewport
edges. Backdrop samples are foreground paint values: they compose over the
existing scene rather than implicitly replacing it.

Backdrop reads preserve insertion order across the whole target, including
non-overlapping components and explicit layers. Earlier content is available
even when sampled outside the component's bounds; later content is excluded.

An isolated filter group defines its own backdrop: sampling inside it sees
content already painted into that group, before the group is composited into
its parent. It does not capture the parent scene through the isolation boundary.

Pure procedural composition uses one fragment program without intermediate
textures. Backdrop reads require a coherent snapshot and a render-pass boundary.
The first read of a frame copies the full target. Between shader draws, the
renderer updates only the bounding region of changed pixels, using prepared
integer scissors. Other primitive batches and target switches conservatively
require a full refresh. The snapshot remains full-sized to support arbitrary
sample offsets without extra authoring rules. Ordered captures still have a
bandwidth and render-pass cost beyond an ordinary background.

## Values, compilation, and limits

Ordinary numbers and colors become uniforms, including numeric literals passed
to field operations. Rebuilding a recipe with different phase, tint, or opacity
reuses its program. `constant(value)` explicitly puts a value in the program
structure. Clones preserve shared uniform identity; separate inputs with equal
current values remain independent.

Keep a paint in component state when its inputs have not changed. All clones
share the immutable compiled result, including clones made before the first
compile. Rebuild the recipe when its CPU input values change; the structural
cache then reuses the program with a fresh uniform payload.

Compilation packs reachable uniforms, caches canonical structure before WGSL
lowering, and uses wgsl-rs's internal IR and emitter. The WGPU renderer validates
the complete program with Naga and caches device-owned pipelines. No public
authoring API exposes either compiler's representation.

Styles compile paints when painted. Call `paint.compile()` to inspect errors
before attaching one. Invalid values and excessive expression expansion are
rejected. Procedural style values are intentionally not serializable as JSON;
styles containing one report a serialization error.

This interface currently targets the WGPU renderer, including its headless
harness. GPUI's native Metal and Direct3D renderers do not support these paints. Check
`window.supports_shader_paint()` when choosing a backend-dependent style.
Arbitrary external textures, compute/storage programs, and a general content
effect destination are outside this initial interface. Existing blur filters
remain supported; this change does not deprecate them.

## Run the examples

```sh
cargo run -p gpui_ce_wgpu --example vercel_hero --features test-support -- \
  --headless --output /tmp/gpui-hero.png --time 3 --pointer 720 350 --size 1280 720

cargo run -p gpui_ce_wgpu --example shader_gallery --features test-support -- \
  --output /tmp/gpui-shader-gallery.png
```

The hero builds its triangle, lighting, and layered glow through the typed API.
The gallery demonstrates procedural backgrounds, shader borders, and glass
sampling real GPUI content. On macOS the examples use headless WGPU output.
`--size` specifies logical viewport dimensions; screenshot dimensions include
the platform's display scale.

## Verification and performance

Run the production GPU and public API checks, and the optimized benchmark:

```sh
cargo test -p gpui_ce_wgpu --features test-support --test shader_paints --test shader_api
cargo test -p gpui_ce_wgpu --features test-support --doc
cargo bench -p gpui_ce_wgpu --features test-support --bench paint -- paint_production
```

The benchmark separates CPU recipe construction from warm compilation, retained
handle use, GPU submission with completion, and GPU readback with completion.
Its 64-component scenes keep all components visible. GPU timings include host
submission and synchronization; they are not isolated GPU timestamps.

A short optimized Criterion run on an Apple M3 Pro measured a 31-node layered
recipe at about 1.90 µs to construct/drop and 4.77 µs to reconstruct and compile
against a warm structural cache. Retained compilation was about 4.7 ns with no
allocation. These are local CPU measurements, not frame-time guarantees. The
recipe used six packed uniform slots (96 bytes before backend alignment).

The same short local run measured 64 consecutive glass components at about
6.26 ms for a 256×256 target and 6.31 ms for a 1024×1024 target, including submit
and completion. Interleaving 63 ordinary one-pixel quads forces full refreshes:
that measured 6.38 ms and 7.76 ms respectively. The interleaved workload includes
those extra draws, and the small-target timing intervals overlap. The copied-byte
reduction is deterministic; these timings do not isolate its contribution or
remove the cost of 64 render-pass boundaries.

Backdrop paints need two reusable full-viewport textures in addition to the
presentation target. With an RGBA8 target that is eight bytes per physical
viewport pixel, plus four bytes per copied pixel. In the 256×256 benchmark with
64 consecutive 32×32 glass components, the snapshot copies 130,048 pixels
(508 KiB), compared with 4,194,304 pixels (16 MiB) for 64 full refreshes. Ordinary
primitive interleaving can require all 64 full refreshes. Pure paints allocate
neither texture, and shader composition itself creates no intermediate target.
Narrow border paints restrict fragment work to disjoint scissor bands that
preserve corner coverage.
