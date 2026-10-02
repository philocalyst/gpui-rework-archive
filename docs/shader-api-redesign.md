# Component shader API redesign

The public abstraction should be a paint value, composed with the same fluent
builders as the rest of GPUI. A component chooses where that value is painted;
the value describes its color. Canvas is a separate consumer. wgsl-rs belongs
behind the interface, supplying an intermediate representation and WGSL emitter,
not a source language callers must learn.

The production interface is now implemented as `gpui::shader`; see the
[usage guide](shader-guide.md) for its current API and backend limits. This
document records the design reasoning and exploratory compiler probes. The
prototype timings below describe those probes, not production performance.

## One value, familiar destinations

```rust,ignore
let surface = waves(state.phase, state.tint);
let finish = surface.clone()
    .mix(color(rgb(0xff5f15)), 0.12)
    .opacity(0.9);

div()
    .rounded_xl()
    .bg(finish)
    .border_2()
    .border_color(surface)
    .child("A normal GPUI component")
```

Background and border accept the same concrete `Paint` value. Existing solid,
gradient and pattern builders retain their direct rendering paths. A procedural
paint uses the element's existing geometry, smoothing, border widths and dashes.
The background is painted before children; the border is painted after children.
There is no canvas callback, rectangle, root or parameter handle in this use.

All composed paints have the same public Rust type. State-dependent choices work
directly:

```rust,ignore
div().bg(if active { waves(phase, tint) } else { color(tint) })
```

Existing `when`, hover and style-refinement builders continue to work. Paint
transparency changes appearance; it does not change layout, pointer hit testing
or child clipping.

## Custom paint uses the same builder values

```rust,ignore
fn waves(phase: f32, tint: Hsla) -> Paint {
    shader(|pixel| {
        let amount = (pixel.uv().x() * 12.0 + phase).sin() * 0.5 + 0.5;
        color(tint).mix(color(rgb(0x246bff)), amount)
    })
}

let finish = waves(state.phase, state.tint)
    .over(color(rgb(0x101318)))
    .opacity(state.opacity);
```

The closure and helper execute in Rust to assemble typed symbolic values. Nothing
parses or transpiles their Rust source. Only operations on symbolic values become
shader operations: `phase.sin()` computes on the CPU, while
`(pixel.uv().x() + phase).sin()` computes per fragment. Helpers are ordinary Rust
functions; they need no annotations, shader modules, derives or capture rules.

The small vocabulary is `Paint`, scalar/vector values, and fragment coordinates.
Numeric operations return typed numeric values. Color construction returns a
paint. A raw vector cannot accidentally become a color or a mask. Methods such as
`sin`, `length`, `dot`, `smoothstep` and typed comparisons provide shader math
without another compiler-facing API. A later geometry library can add distance
and coverage types where they prevent real mistakes.

Keep the initial paint operations small:

| Builder | Meaning |
| --- | --- |
| `paint.mix(other, amount)` | Interpolate two colors |
| `foreground.over(background)` | Source-over composition |
| `paint.opacity(amount)` | Scale premultiplied color and alpha |
| `paint.mask(amount)` | Apply clamped scalar coverage to this paint |
| `paint.map_uv(mapping)` | Change this paint's normalized sampling coordinates |

These compose into one fragment program. They do not allocate intermediate
textures or capture children. More effects can be ordinary library functions
built from these values, rather than more component methods.

`mix` follows WGSL math and permits extrapolation; it does not silently clamp its
amount. Opacity and coverage clamp to `[0, 1]`. A caller can clamp a mix amount
explicitly when that is the desired behavior.

The fragment supplies normalized UV, local logical-pixel position, and size.
Coordinate conversions remain explicit. Reusable coordinate-dependent helpers
can accept the relevant vector, rather than capturing a canvas or root. Mapping
a composite changes both children; mapping one child before composing changes
only that child. A mapped clone leaves the original unchanged. Mapping changes
sampling, not the element's box, border geometry, hit testing or clip.

`map_uv` operates in normalized coordinates and derives mapped logical-pixel
position from the unchanged fragment size. Logical offsets can be divided by
that size explicitly. The destination geometry and its clip remain unchanged.

The closure runs on the host. Its ordinary `if` chooses a recipe and can change
program structure. A typed `select` or `mix` expresses a per-fragment choice.
Do not imply arbitrary Rust loops, allocation or control flow execute on the GPU.

## Values change without changing code

Ordinary CPU numeric/color inputs become instance data by default. This includes
numbers passed to arithmetic and `.opacity()`. Rebuilding
`waves(new_phase, new_tint)` changes its payload, not its shader code or pipeline
key. Independent helper calls carry independent values. Cloning preserves an
immutable snapshot; no later update mutates an earlier draw.

Without inspecting Rust syntax, the builder cannot distinguish `* 12.0` from
`* phase`: both supply an `f32`. The coherent default is to treat both as instance
data. An explicit `constant(12.0)` opts into specialization or constant folding
when profiling justifies it. Constants belong to the code key; ordinary values do
not. This trades uniform bytes for predictable animation and simple authoring.
Dense packing and measurements are required before calling it cheap.

Cloning one scalar or paint shares its symbolic node and uniform identity. Two
separately constructed inputs with equal current values remain independent.
Dedupe constants and pure operations where safe; never merge instance inputs by
their current value or a user-facing field name.

Avoid generated setters for every parameter and a second named-parameter DSL.
Normal Rust settings structs can be destructured by a paint constructor.
Reconstruction fits GPUI's render model; retained-value optimizations should only
be added if measured construction costs require them.

## The private representation

Use closed immutable typed values backed by a private shared expression DAG.
Remove public graph ownership, not sharing. A concrete wrapper avoids exposed
generic composition types, runtime erasure calls and enormous Rust type trees.
There are no foreign-root or conflicting-handle errors when values compose.

Keep the lowerer narrow: traverse reachable nodes, assign canonical locals and
uniform slots, construct `wgsl_rs::ir` items/expressions, and let its renderer emit
WGSL. Validate the complete module with Naga. Rust wrappers and sealed
constructors enforce operand types; the IR is an untyped internal representation,
not a substitute for those guarantees. User helpers assemble values, so user
export names never enter the shader namespace.

This does not depend on wgsl-rs's shader generic specialization, source import
concatenation or blind name rewriting. There is no new Rust parser, proc macro,
shader module system, trait specializer or string arithmetic emitter in GPUI.

Memoize coordinate-dependent expressions by node identity **and sampling
context**. One shared paint under two mappings needs two evaluations of its
coordinate-dependent math. Its uniform leaves still share a binding by original
node identity. Globally rewriting UV nodes, or memoizing only by node identity,
breaks this case.

Sharing bounds work only within equivalent sampling contexts. A small shared DAG
that doubles differently mapped uses at each level can still require
exponentially many evaluations. Production limits must count expanded contexts
and emitted expressions, not just unique recipe nodes, and report a diagnostic
before excessive work or allocation. A small mapped-diamond probe records this
limit rather than claiming all shared graphs lower in linear time.

Code identity uses canonical structure, types, explicit constants, uniform
aliasing/layout and pipeline state. It excludes pointer addresses, temporary node
IDs and ordinary values. Verify full canonical equality on digest collisions.
Fresh builds with the same structure and different values find the same program.

Look up canonical structure before constructing IR, emitting source or validating
it. A GPU pipeline cache alone still leaves expensive CPU compilation on every
rebuild. The cached program should retain a binding plan from canonical input
occurrences to packed locations; fresh values use that plan without repeating
lowering. Measure canonical lookup and packing separately on this warm path. The
pre-production prototype established stable source without implementing this
cache. The production compiler now looks up canonical structure before lowering
and packs fresh values using the cached binding plan; cloned paint handles also
share their compilation memo.

The renderer owns device resources, pipeline caches, upload arenas and device
generations. Earlier draws retain independent uniform records. Cloning should be
cheap; assembling a new DAG and canonicalizing its structure are real CPU work.
An Arc allocation per operation may cost more than the existing mutable arena.
Measure it before choosing final storage; a compact private arena can replace the
prototype without changing this interface.

## What the compiler probes established

The workspace pins wgsl-rs at
`b2de16a1b81e67d76bc265c296184f882864badb`. Its `wgsl_rs::ir` re-export supplies
owned modules and WGSL rendering without another direct IR dependency.

The probes preserve limits that the adapter must account for:

1. Shared source imports deduplicate by identity, but independent imports both
   declaring `shade` collide.
2. `ir::rename_items` rewrites an expression referring to a same-named parameter
   while leaving its declaration unchanged. It is not a scope-aware linker.
3. One-level generic recipes validate, but nested specialization emits an
   unresolved `Over_shade`. This fails on the pinned revision and upstream main
   `1a6315d6`, checked on 1 October 2026.
4. The IR emitter preserves explicit parentheses but does not supply precedence
   parentheses for nested binary expressions. A correctly typed expression can
   become valid WGSL with different arithmetic. The adapter must preserve
   grouping with `Expr::Paren` or named locals. The GPU test caught incorrect
   source-over despite successful Naga validation.

The first three are limits of paths the new builder need not use. The fourth
requires a small emission adapter, not another compiler. The direct-IR builder
probe independently checks nesting, sharing, stable code under changing values,
coordinate mapping and actual GPU arithmetic.

General layout metadata does not prove uniform address-space compatibility for
nested structs or arrays. Encode explicitly and check the final layout through
Naga reflection. Do not copy arbitrary Rust structs or expose padding fields.

## Coverage, color and component integration

Use premultiplied color internally for interpolation and source-over. Define the
working color space consistently with GPUI's renderer, and convert at the target
boundary when it expects straight alpha. Color construction accepts normal GPUI
colors and performs the required conversion; users never premultiply manually.

Apply destination coverage once after the complete paint. Two opaque layers in
half-covered geometry must produce alpha one half. Masking each layer first would
produce three quarters. A user mask affects only its subtree and is separate
from the final geometry mask. Coverage and opacity scale all premultiplied
channels. Evaluate derivative coverage before divergent fragment discard.

Reuse existing quad coverage for ordinary/smoothed corners, unequal edge widths
and dashes. A generic rounded-rectangle SDF is not equivalent. Preserve the border
strip optimization so large borders do not shade their empty interiors; sampling
coordinates still refer to the whole element.

`Style.background` and `border_color` now both store `Fill`, with explicit
procedural branches in `Style::paint`. Calling only `Fill::color()` would
silently omit shader values. `Background` remains a packed `Copy` scene value;
owned shader descriptors stay outside it.

A concrete GPUI-owned `Paint` supports an explicit `From<Paint> for Fill`; avoid a
blanket recipe conversion overlapping the existing `Into<Background>` blanket.
Audit visibility, overflow clipping, equality/refinement, transitions,
serialization and inspectors. Executable paint needs an explicit serialization
policy. Also define diagnostics for invalid values, exceeded limits and
unsupported native backends: operand typing alone does not solve these failures.

## Verification and performance gates

The direct WGPU source-recipe fixture renders seven variants through one pipeline
and checks every pixel against CPU references. It covers independent updates,
repeated helpers, order, fractional coverage, overlap and premultiplied alpha.
It bypasses GPUI's style/scene integration; its counters do not establish
production performance.

For the new builder, require nested/shared-diamond tests, independent inputs
starting with equal values, stable code under updates, and differently mapped uses
of one paint. Validate complete modules with portable Naga capabilities and render
the builder's actual output. Measure construction, cloning, packing, lowering,
emission, cold compilation, warm submission and GPU execution separately.
Allocation count and retained bytes matter alongside time.

Run the experiments with:

```sh
cargo test -p gpui_ce_render --test shader_builder_probe
cargo test -p gpui_ce_render --test shader_generic_probe --test shader_recipe_probe
cargo test -p gpui_ce_wgpu --features test-support --test shader_recipe_gpu
```

The manual CPU harness is an ignored test; use an optimized build when measuring:

```sh
cargo test -p gpui_ce_render --release --test shader_builder_probe \
  benchmark_builder_phases_and_report_dag_size -- --ignored --nocapture
```

These exploratory GPU tests require an adapter and save galleries under `/tmp`.
They exercise compiler recipes directly. Production style integration is tested
separately in `gpui_wgpu/tests/shader_paints.rs`, and its builder permutations in
`gpui_wgpu/tests/shader_api.rs`. The production Criterion groups live in
`gpui_wgpu/benches/paint.rs`; the [usage guide](shader-guide.md) includes runnable
GPUI component examples.

One local optimized CPU run on 1 October 2026 produced these means. Construction
uses `realistic_recipe`; every other row uses a 24-level shared diamond. They are
different workloads and must not be summed as one paint cost.

| Phase | Per iteration |
| --- | ---: |
| Construct and drop the realistic recipe | 1.82 µs |
| Clone and drop the diamond's root Arc | 3 ns |
| Lower diamond IR and pack logical values | 89.90 µs |
| Emit diamond WGSL | 26.89 µs |
| Parse and validate diamond WGSL with Naga | 206.11 µs |

The diamond has 61 reachable nodes and 29 distinct dynamic parameter nodes packed
into eight vec4 slots, or 128 logical uniform bytes. This is not per-draw GPU allocation
after backend alignment. Its 1,896-byte node-payload lower bound excludes Arc
headers, allocator overhead, maps, cached programs and peak temporary storage.
Its emitted source is 4,417 bytes. Timings include temporary allocation/drop and
come from one run without variance or throughput evidence. They measure neither
WGPU pipeline creation nor GPU execution.

The measured lowering cost makes pre-IR reuse a requirement: repeating roughly
90 µs of uncached lowering for 1,000 such diamond paints costs roughly 90 ms
before submission, even with cached pipelines. Production construction, canonical
lookup, value encoding, upload alignment and retained/peak memory still need a
benchmark together.

Before replacing production behavior, require GPUI pixel parity for radii,
smoothing, asymmetric/dashed borders, opacity, clips, scale factors and nested
ordering. Benchmark independently bound components, stable pipeline counts during
animation, and border-area fragment work. Batch adjacent draws only when order is
preserved. Composition requires one program and no intermediate render target.

## Image effects and canvas

A paint produces color; an image effect samples content or a backdrop. Keep that
cost-bearing boundary explicit. Later `effect`/`backdrop_effect` destinations
can supply typed image inputs to the same builders. Sampling footprints, expanded
bounds, nested order, alpha, clipping and failure behavior need tests before this
can replace the current blur filters.

Paint layering never implies subtree capture. Same-paint composition covers many
decorations without more layer methods. Foreground decorations need defined
ordering and extent before adding a destination. Canvas retains its own lifecycle
and can consume these values later; it does not define their root or language.

## Influences

Adapt TypeGPU's typed composition and replaceable dependencies, Skia's shader
children and local transforms, SwiftUI's distinction between color and image
effects, and vgpu's internal identity/resource separation to GPUI's values.

- [TypeGPU functions](https://docs.swmansion.com/TypeGPU/apis/functions/)
- [TypeGPU slots](https://docs.swmansion.com/TypeGPU/apis/slots/)
- [Skia shader builder](https://api.skia.org/classSkRuntimeShaderBuilder.html)
- [SwiftUI layer effects](https://developer.apple.com/documentation/swiftui/view/layereffect(_:maxsampleoffset:isenabled:))
- [vgpu](https://github.com/vercel-labs/vgpu)
- [wgsl-rs source and crate structure](https://github.com/schell/wgsl-rs)
