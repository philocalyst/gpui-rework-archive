# Retained Reactive Style System

GPUI's chainable Tailwind-like API remains the authoring surface. Retention changes its cost model:
static style operations run when a node mounts or a structural rebuild changes them; reactive inputs
patch individual retained fields. The design does not depend on the compiler const-evaluating an
arbitrary builder chain.

## One surface for static and reactive values

```rust
div()
    .flex()
    .gap_2()
    .px_4()
    .bg(theme.surface)
    .w(sidebar_width)
    .hover(|s| s.bg(theme.surface_hover))
```

Methods accepting dynamic values take a sealed `impl Property<T>`. Literals ride the same
method: `impl Property<Length>` includes `i32`/`f32` as pixels, `impl Property<Color>` includes
`u32` (24-bit sRGB), `Color::Red`, tokens, and `&Signal<Color>`. The temporary concrete Rust
expression lives only in the mount blueprint and is deforested into its destination; there is no
universal stored `Value` enum or boxed property. A constant is stored directly with no graph node or
allocation. A scalar/generated-field `State<T>` installs a direct sink to that field cell: it does
**not** route through a parent model, run tracking, create a general graph node, or become a user
effect. A shared `scope.derive` result installs a tracked consumer; a sealed static style operator may
instead lower to a fused circuit. All paths compare using that field's equality policy, write
the resolved value, and emit its declared obligations.

At mount, a direct field sink reads once without tracking; a derived node runs in tracked
initialization; both install the value before layout. The retained node is fully allocated before
the observer is armed. Neither is an after-publication effect and neither can reenter an auxiliary
`with_element_state` borrow; later invalidations run as compact property consumers during settle.
After slab growth, direct-field mounting and update target zero per-binding heap allocations;
that is a benchmark gate, not an unsupported promise.

Static and reactive variants are not separate method families. A method call cannot silently freeze
a state read because a live value is represented by a state/computed handle, not by whether the
author remembered `move ||`.

## Generated schema, reviewed semantics

The style schema generates:

- stable field ids and typed slot accessors;
- literal storage/defaults and layer merge code;
- serialization/debug names;
- multiword dirty/generation masks sized from the field count;
- equality and interpolation adapters named by metadata.

Each field declares reviewed semantic metadata, for example:

```text
background_color: paint
opacity: composite | paint_fallback
width: layout
transform: placement | composite | hit_test | a11y_bounds
visibility: layout? | paint | hit_test | semantics
cursor: event_routing
```

A derive/proc macro can enforce that metadata is present and generate code; it cannot infer the
correct phase solely from a Rust field type or name. Fields with conditional consequences implement
a classifier over old/new values. Tests enumerate every field and verify a representative mutation
enters exactly the promised phases.

Do not assume one `u128` covers the system forever. Generated masks use inline words for the common
case and spill only if the schema grows.

## Layered cascade

Resolved style has ordered layers:

```text
defaults < inherited/theme < base builders/classes < interaction variants
         < inline reactive values < transition/animation override
```

Each layer owns a mask of fields it specifies and a mask changed this transaction. Resolution visits
only fields whose winning input might have changed. Removing a winning value reveals the next layer
without reconstructing unrelated style.

Inheritance maintains reverse users or subtree obligations depending on fanout. A commonly shared
resolved value may be interned, but interning is budgeted and equality remains correct without it.
Themes use specialized palette-token indirection: a field stores `PaletteToken` plus an opacity/
blend class where possible, and reverse use lists identify token consumers without 10,000 dynamic
closures. Changing a palette entry patches only its indexed users. A change that promotes opacity
from paint-only to an isolated/composite-sensitive class invalidates/reclassifies affected users
conservatively and counts the promotion. Arbitrary theme computation remains normal state/graph
work; there is no special durability type.

## Named looks

Iced's Catalog (`Theme + Status → widget::Style`) and Slint `states []` both exist because
authors should not restyle every hover/disabled layer by hand. We do **not** take a `Catalog`
trait (viral on custom themes) or a `states` language.

```rust
button("Save").look(Look::Accent)     // or .accent()
button("Delete").look(Look::Danger)
icon(Magnifier).colorize(theme.accent.on)
path("M10 10 H 90 V 90 H 10 Z").view_box(0, 0, 100, 100).fill(theme.fg)
```

A look is a TokenIndex **recipe**: fill + `on` pair, radius, and the hover/active/focused/disabled
variant layers. Fluent after `.look` still wins (last write in the base layer). `tw!("btn-accent")`
emits the same recipe. Omitting a look is legal — it is a builder method, not a constructor.

Fill ports take `Brush` (solid or gradient). `Color` is a solid brush. Type scale is rem
(`p_4` / `text_lg` already generate `rems(...)`; GPUI's `StyleRefinement` is the patch BSN
reinvented).

**Lengths.** `impl Property<Length>` includes `i32`/`f32` as px, `pct`, `rems`, ports, and
viewport units `vw` / `vh` / `vmin` / `vmax` (Bevy `Val`). Container queries stay named
ancestors (`cqi`, 06) — viewport is the window, not a query. `tw!("w-[50vw]")` may parse a
string; Length has no public `FromStr`. `clamp(min, max)` is a Length combinator (Slint).
Transform translation is the same bound (Bevy `UiTransform` in `Val`): `.translate(pct(10), 0)`
is presentation, not flow.

**Shadows.** Multiple `box-shadow`s, back-to-front, offsets/spread/blur as Length (Bevy
`BoxShadow(Vec)` / CSS). Sample budget is renderer-internal.

`column().token_scope(Scope::Terminal)` nests a TokenIndex scope (Iced `themer`).

Hover/focus/active/group/peer/dark/reduced-motion/container variants are retained conditional
layers. Interaction state is produced by retained input/focus nodes. Toggling hover changes the
variant fields for the old/new target and emits their obligations; it does not run a global selector
scan.

Group/peer relationships are explicit retained edges with lifecycle ownership. Selector-like
variants that depend on descendants or siblings maintain invalidation indexes and declare their
scope. Complex CSS cascade/selector support, if added, is a separate engine contract—not implicit in
the utility method API.

## `tw!`

```rust
div().class(tw!("flex flex-col gap-2 px-4 hover:bg-red-500"))
```

`tw!` is a stable proc macro over a string literal. It tokenizes classes, validates names/variants/
arbitrary values, canonicalizes static payloads, and emits the same ordered schema operations as
fluent methods. Unknown or invalid classes are errors. Conflicts within one variant/layer use fluent
last-write semantics; `tw!(strict: "...")` rejects them with both spans for teams that want that
policy. Exact duplicates are removed. No nightly const-generic string support is needed.

Dynamic class strings use an explicitly slower `class_dynamic` API with parsing/cache behavior and
coarser invalidation stated in its name. They are not accepted by `tw!` and cannot silently bypass
validation.

## Transitions and animations

A transition observes a field's resolved target and owns an animation override. Classification is
field- and node-aware:

- color/brush changes repaint the fragment;
- isolated opacity/transform updates may be composite-only;
- a transform within declared travel bounds updates placement/order without re-emission;
- width/padding/font-size enters layout;
- enter/exit and FLIP use an explicit transition host with captured geometry.

Interpolating a layout value is not automatically FLIP. Filters, clips, blending, backdrop content,
and overlap can widen damage or prevent composite-only execution; fallback reasons are counted.

Interrupted transitions begin from the presented/interpolated value. Removing a node during exit
keeps a transition owner until completion/cancellation. Reduced motion snaps or substitutes
according to policy while preserving final state.

Active motion is not one general derived node per property. Timed, spring, keyframe, gesture, FLIP,
and structural programs lower to dense kind-segregated lanes for paint, transform/opacity,
placement, layout, shader uniforms/ranges, and structural tracks. Each lane samples one injected
monotonic frame clock, coalesces compact typed-port updates, and applies the destination's obligation
class. Interruption starts at the presented sample; springs declare velocity preservation/reset.
Inactive lanes are removed in O(1)/amortized O(1) with owner teardown. This preserves an ordinary
property API while avoiding graph allocation/scheduling or source-state writes at animation-frame
frequency.

Canvas/shader parameter derives use the same sealed port metadata: a uniform may be paint/composite,
a storage range may rebuild a retained canvas range, and a backdrop/pass dependency may widen
damage. The type/schema proves value and bind-layout compatibility; reviewed metadata and render-
graph validation determine obligation/hazard semantics. User shaders cannot silently classify
themselves as composite-only.

**Named filters vs custom shaders.** `.blur(5)` / `.backdrop_blur(12)` are style fields with
reviewed obligation metadata (paint / backdrop / composite fallback) — not a shader DSL on every
node. A custom WGSL pass is an isolated `.shader(MyFx)` or a typed retained temporal graph on the
same phase-capability element; both declare bounds, resources, and damage. See 07 §15.2/§15.2.1.

## Caching and memory

Cache static resolved styles, lowered layout/text/paint representations, and interpolation programs
by schema revision and relevant inputs. Every cache has a byte/entry budget and records hit,
eviction, and rebuild-after-eviction behavior. A field change invalidates only lowered
representations that consume it.

## Acceptance matrix

For every style field and variant, tests assert:

- fluent and `tw!` forms resolve identically;
- literal inputs allocate no reactive node;
- direct-field style sinks do not run tracking or a user effect and meet the allocation gate
  after slab growth;
- reactive updates touch one slot and emit exactly the declared initial obligations; conditional
  classifiers may conservatively promote downstream work based on old/new value, containment, and
  backend capability, with the promotion reason asserted separately;
- removing a layer reveals the correct lower winner;
- inheritance and group/peer changes reach exactly affected descendants;
- transition fast path and fallback render identically;
- palette token fanout and opacity-class promotion produce the counted minimal/conservative work;
- motion lanes match the reference program at identical timestamps across cadence/interruption and
  patch only the declared style/canvas/shader destinations;
- cache eviction changes performance only, never output;
- unknown/invalid classes fail at the source span; conflict ordering matches fluent calls and strict
  mode reports both spans.

## Text is three sheets, not one `TextStyle` bag

The fluent chain on a `div` still sets text. Completeness does not. [09-text.md](../09-text.md)
splits **font/shape**, **paragraph/wrap**, and **paint/decoration**, each field with the same
obligation metadata as above. `letter-spacing` is wrap; `underline-offset` is paint; `fill` may
be a `Background` (gradient text) without reshaping.

Do not grow `Styled` by one method per CSS longhand. Tailwind-worthy methods are listed in 09 §7;
skip-ink, hanging punctuation, autospace, and writing-mode are schema / paragraph builders.

Colors on text go through [runtime/color.md](../runtime/color.md): tokens and `Color`, not a
second `Hsla` path. macOS dilation is a paint-cache key, not a layout input, except when a
luminance change crosses a dilation band (counted).
