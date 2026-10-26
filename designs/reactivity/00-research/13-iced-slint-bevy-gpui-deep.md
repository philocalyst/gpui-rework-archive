# 13 — Iced, Slint, Bevy, GPUI: types, demos, internals

Status: **research.** Law lives in [07-the-ladder.md](../07-the-ladder.md) §17.5 / §17.8 / §17.9
and the contracts they name. This file is the source audit behind those bullets — types, demo
apps, and clever internals worth stealing, not a second public surface.

Pinned: Iced **0.14** (`iced-rs/iced` tree `0.14/`), Slint docs + interpreter internals (as
already mapped in [01-reactivity-implementations.md](01-reactivity-implementations.md)), Bevy
**0.17** UI / Feathers / BSN 0.19 notes, this checkout's `crates/gpui`.

---

## 1 · Iced 0.14

Iced is still Elm: `Program` + `Message` + whole-`view` rebuild. That incrementality is refused
(02-research). The **widget, layout, canvas, docking, and palette** types are independently
good, and several of them are more precise than our first steal pass.

### 1.1 Core types

**`Tree { tag, state, children }`.** Persistent widget state, keyed by `Tag` (`TypeId` of the
widget). `diff` recreates the whole subtree if the tag mismatches; `diff_children_custom` is
the keyed-list hook. This is Xilem/Iced *structural* identity (type of the widget at this
index), not our embedding-site identity. Steal the *behavior*: a type change remounts. Do not
steal Tag-as-the-author's-key — we already refused `.key()`.

**`Length { Fill, FillPortion(u16), Shrink, Fixed(f32) }`.** Flex portions are **integers**,
not `f32` grow. Helpers that are smarter than they look:

- `fill_factor()` — Fill = 1, FillPortion(n) = n, else 0.
- `fluid()` — Shrink/Fixed collapse to Shrink; Fill/FillPortion collapse to Fill. "Will this
  eat leftover space?"
- `enclose(other)` — a parent that must contain a child and match its fluidity (Fill if
  either is Fill).

Steal: `.grow(n: u16)` already. `fluid` / `enclose` are **Taffy-internal**, not public
methods. Do not add a second Length enum next to GPUI's `Length` / `DefiniteLength` /
`AbsoluteLength`.

**`Widget` trait.** `layout`, `draw`, `operate`, `update`, `mouse_interaction`, and
**`overlay()`** — a widget may return an `Element` that *escapes parent layout* (dropdowns,
color pickers). That is the origin of our overlay family: the widget that needs a popup owns
the overlay, layout does not grow a "dropdown slot." Steal the protocol shape. We already
have `popup().open` / placement graph; name Iced as the prior art so we do not invent a
second overlay pass.

**`Operation<T>` visitor.** Capability-typed walk: `container` / `scrollable` / `focusable` /
`text_input` / `text` / `custom`, plus `traverse` (skip children unless called). Post-describe
query/mutate by `Id` (scroll-to, focus, snapshot text). We refused an Elm operation pass as
the *app* event model. Honest: Operation is closer to a sealed `TargetRef` walk than to
Playwright strings. Steal for **inspector and `UiTest` only** — typed visitors over
capabilities, not `query("#foo")`.

**Canvas `Program`.** `State: Default + 'static` is *not* app state. `draw` → `Vec<Geometry>`;
`update` → `Option<Action<Message>>` (`Publish` / `Capture` / `RequestRedraw`). **`Cache`**
retains tessellated geometry across frames until `clear`. This is our `impl Canvas` + field
split already; steal **Cache as retained tessellation** (named, budgeted) and Action as the
discrete vs machine-rate split (`.on_commit` vs `.on_frame`). `Mesh2D` (the `geometry`
example) is a canvas primitive, not a new public noun.

**`Palette` / `Extended` / `Pair`.** `Palette` is a *small* struct: background, text, primary,
success, warning, danger — plus **named built-in tables** (LIGHT/DARK, Dracula, Nord,
Solarized, Gruvbox, Catppuccin, Ferra, …). `Extended::generate(palette)` expands each role
into weak/strong scales; `Pair { color, text }` runs `readable(bg, text)` so contrast is
*constructed*, not hoped. Seed path is Oklch (already stolen). Extra steals: **ship named
palette tables** (optional crate, not kernel), and **Pair construction always runs
`readable`**. Do not steal the eight-step `weakest…strongest` Background scale as public
tokens — three (weak / base / strong) is enough; eight is a generator internal.

**`pane_grid`.** Binary split tree of panes; `State<T>` owns per-pane content; `split` /
`swap` / `resize(ratio in 0..1)`; drag-drop; **leeway** hit slop around splitters
(`spacing + leeway`); last-active pane; maximize. This is a **docking widget with a ratio
tree**, not CSS grid. 06 already split chrome vs editor grid. Steal the *interaction model*:
ratio splits, sash leeway, last-active, maximize — not Iced's single tree (VS Code taught us
two algebras).

**Other types worth naming**

| Type | What it is | Ours |
|---|---|---|
| `mouse_area` | hit without a button | compositor claims / `.on_hover` |
| `stack` | z-order children | overlay / `z` |
| `shader` widget | wgpu pass next to a widget | `impl Canvas` / `.shader(MyFx)` |
| `markdown` | document widget | 09 block tree, not a widget |
| `table` (0.14) | first-party table | Lattice (06), not Iced's |
| `themer` | nested theme | `token_scope` |
| `responsive(\|size\| …)` | size → subtree | named-ancestor container queries (06) |
| `Id` | operation target | branded `Id` / `TargetRef` |
| `debug` overlay | layout bounds | inspector |
| built-in icon font | iced-icons | `icon(Magnifier).colorize` |
| `Subscription` / `window::frames` / `time::every` | Elm event sources | `Task` + protocol; refuse |

### 1.2 Demo apps (`iced-rs/iced/examples`, 0.14)

These are the ones that actually teach a type, not "hello button":

| Example | What to steal / refuse |
|---|---|
| **`tour`** | widget catalog, native + web. Our L0 docs zoo. |
| **`pane_grid`** | sash drag, split, maximize, drag-drop panes. 06 interaction. |
| **`bezier_tool`** | Canvas Bézier + `Cache`. Discrete commit vs sample. |
| **`geometry`** | `Mesh2D` primitive. Canvas, not a leaf. |
| **`custom_widget`** | circle as a `Widget`. Ours: `impl Canvas` or a path leaf. |
| **`integration`** | Iced *inside* existing wgpu. Pocket/fence, not a kernel. |
| **`todos`** | Elm Message. Refuse the architecture; keep the UX. |
| **`download_progress`** | `Subscription` progress. Ours: field `Task` + a port. |
| **`clock` / `solar_system` / `game_of_life`** | canvas at frame rate. `.on_frame`. |
| **`styling` / `theme` / `themer`** | Catalog vs our `.look`. Nested theme = `token_scope`. |
| **`shader`** | custom wgpu. `#[gpu_shader]`. |
| **`markdown`** | document widget. 09. |
| **`table`** | first-party table. Lattice. |
| **`lazy` / `loading`** | placeholder while work runs. media.md placeholder; Task `.when`. |
| **`modal`** | overlay that captures. overlay protocol. |
| **`multi-window`** | `open(kind, view)`. |
| **`screenshot`** | test capture. `UiTest`. |
| **`pokemon` / `slider` / `svg` / `image`** | catalog coverage. |

### 1.3 Steal / refuse / miss (Iced)

**Steal:** integer `.grow(n)`; `fluid`/`enclose` internally; widget `overlay()` as overlay-family
origin; Operation as inspector/test visitor; canvas `Cache` + `Mesh2D` primitive; pane_grid
leeway / ratio / maximize / last-active; named shipped palettes; `Pair` always `readable`;
Oklch seed (already); `token_scope`; SDF quads renderer-internal; icon font.

**Refuse:** `Message` / `Element::map`; `Subscription` architecture; whole-view rebuild;
public `Catalog` trait; `responsive(|size|)` as a second query spelling.

**Honest miss:** `|theme, status| Style { … }` sees every state of one widget in one function.
`.look` closes it without Catalog.

---

## 2 · Slint

Slint's compiler-enforced pure bindings remain the reactivity teacher we will not copy as a
language. The **property, model, and flickable** types are the presentation teacher.

### 2.1 Binding model (the hole we closed)

Bindings are the default. **Overwritten bindings:** `foo.bar = 42` *breaks the binding
forever* (also `TextInput` typing). Two-way is `<=>`. `changed` is the imperative escape.
Pure contexts are compiler-enforced.

This is the MaybeSignal / Rosin hole. We refuse the language. Steal the **diagnostic**: if
anyone writes a signal in `view`, the error should read like Slint's — "this assignment
would break a live binding" — not a generic `&mut self` complaint. `IntoEditable` /
NeedsWriter already make the *controlled* case unrepresentable; the diagnostic is for the
author who thought `view` could `set`.

`in` / `out` / `in-out` on the component boundary is the same trichotomy as
`IntoWire` / emit / `IntoEditable`. Steal the vocabulary in docs; typestate already does
the job. `inherits Button` is widget subclassing — refuse (`.pipe` / composition).
`@children` is a default slot — we already take `impl IntoChildren`.

### 2.2 `TouchArea.mouse-x` / `mouse-y`

Bindable properties that drive `Rectangle.x/y` every move. Machine-rate **property**
binding, not `fn(&mut Owner)`. Named elements (`ta := TouchArea {}` then `x: ta.mouse-x`)
are lexical ids in one component.

Steal the *shape*: pointer geometry is a **presentation fact you can wire**, not a cell the
view reads. Ours: a `GeometryRef` on the pointer (`pointer.local()`, `pointer.global()`),
consumed by the placement graph / a canvas `on_frame` / a follow node. Refuse
`Signal<Point>` of the mouse (that either re-describes at pointer rate or requires a `view`
read).

### 2.3 Units and clamp

`length / 1px` converts to int (truncate). `clamp(foo.x, 0px, 400px)`. Logical vs physical
px. GPUI already has `Pixels` / `Rems` / `Length` in `crates/gpui/src/geometry.rs` —
**no viewport units**. Bevy `Val::{Vw,Vh,VMin,VMax}` fills that gap (below). Steal `clamp`
as a Length combinator for layout math, not a view helper.

### 2.4 Models = our arrangements

`Model` + `VecModel` + adapters `FilterModel` / `MapModel` / `SortModel` / `ReverseModel`
with `ModelExt` chaining (`.filter().map().sort()`). **`unfiltered_row`** maps a filtered
index back to the source. **`reset()`** when the filter *closure environment* changes
(they captured a string and forgot to tell the model).

This *is* our arrangement pipeline. Name the steal: **Slint ModelExt is the spelling;
`unfiltered_row` is `Slot`.** Downstream consumers index the arrangement; identity is the
slot. Do not steal proxy-of-proxy (07 already refused QSortFilterProxy stacks). `reset()`
is our wildcard-arrangement rebuild when a bound cell publishes — already priced, already
counted.

### 2.5 Flickable `ChangeTracker` (the clever one)

Scroll viewport is kept in bounds when content geometry changes. **You cannot arm the
tracker initially — that is a binding loop** (geometry depends on viewport, viewport
depends on geometry). Delayed init: arm after the first layout.

Steal **by name**: geometry → source feedback (07 §18.1) uses **delayed arm** — do not
subscribe scroll-bounds until after the first presentation epoch. Cap exhaustion stays a
located fault. This is the concrete trick, not a new protocol.

### 2.6 Internals (already in 01-research, restated)

`PropertyTracker`, intrusive `DependencyListHead`, `BindingVTable`,
`remove_unused_properties`, compile-time loop detection, generativity in the interpreter
only, flat component allocation. Steal none of the DSL; steal "unused properties die" as
an inspector gauge (park-when-idle / leak gauges, already zgui).

`cache-rendering-hint` is an author switch for layers. Refuse — layers are earned (§6).
Opacity-as-layer is our earned composite. `Path` + viewBox, `colorize`, `image-fit`,
`font-metrics`, rem type scale, Palette pairs, `states []` as a bundle: already in 07
§17.5.

### 2.7 Demos

gallery, todo, printerdemo, carousel, energy-monitor, weather, memory, 7guis, plotter,
imagefilter, opengl_underlay. The ones that teach types: **gallery** (widget zoo +
styles), **printerdemo** (real chrome, 9-slice-ish panels), **carousel** (motion +
clip), **opengl_underlay** (native surface / pocket), **plotter** (path/canvas).

### 2.8 Steal / refuse / miss (Slint)

**Steal:** overwritten-binding diagnostic wording; pointer as `GeometryRef`; ModelExt
spelling + `unfiltered_row` = Slot; Flickable delayed-arm; `in`/`out`/`in-out` as docs
vocabulary; `clamp` on Length; opacity-as-earned-layer; presentation list already in
§17.5.

**Refuse:** `.slint`; `pure` keyword; `inherits`; `cache-rendering-hint`; `states []`;
two-way `<=>` as a third wire (IntoEditable is two-way when it must be).

**Honest miss:** one `states` block coordinating five properties on three children.
`.look(Disabled)` is the close.

---

## 3 · Bevy 0.17 UI / Feathers / BSN

ECS-as-UI-runtime is refused (Haalka/Jonmo, 06-competitive). The **Val / ImageNode /
UiMaterial** types are the presentation teacher this pass actually needed.

### 3.1 `Val` and `UiTransform`

```text
Val { Auto, Px, Percent, Vw, Vh, VMin, VMax }
```

`FromStr` (`"10px"`, `"50%"`, `"10vw"`). Viewport units and vmin/vmax are **not** on our
fluent surface today. GPUI `Length` is `Auto | Definite(Absolute(px|rem) | Fraction)`.

Steal: `vw()` / `vh()` / `vmin()` / `vmax()` as Length. String parse **only** in `tw!` /
style files — not a public `FromStr` on Length (strings-are-not-chords analogue).

`UiTransform { translation: Val2, scale, rotation }` — transform offsets in **Val**
(move by 10% of me). Our presentation transform is after layout and currently thinks in
px. Steal: transform translation is `impl Property<Length>`, same as `.left`. Carefully
vs Taffy: this is presentation, not flow.

### 3.2 `ImageNode` — the richest image type in the survey

| Field / mode | What it is | Steal as |
|---|---|---|
| `color` | **multiply tint** (white = identity) | `.tint(brush)` on photos; **not** `colorize` |
| `colorize` (Slint) | alpha mask → brush | icons / SVG / mask images |
| `texture_atlas` | sprite sheet | `.atlas(id, index)` |
| `rect` | crop in texture space | `.crop(rect)` |
| `flip_x` / `flip_y` | — | `.flip(x, y)` |
| `NodeImageMode::Auto` | Taffy **measure fn** from texture size × scale | inherent size participates in layout |
| `Stretch` | ignore intrinsic | `Fit::Fill` |
| `Sliced(TextureSlicer)` | **9-slice** | `.slice(NineSlice { … })` |
| `Tiled { tile_x, tile_y, stretch_value }` | repeat | `.tile(Tile { x, y })` |
| `ImageNode::solid_color` | debug placeholder | tests / skeleton without a file |

`ImageMeasure`: Auto installs a measure fn; Stretch/Sliced/Tiled **clear** it. Steal that
split: object-fit Auto vs Stretch is measure vs ignore-intrinsic, not two shaders.

`TextureSlicer`: `border: BorderRect`, `center_scale_mode`, `sides_scale_mode`,
`max_corner_scale`. This is how every desktop chrome panel is drawn. We did not have it
on `image`. GPUI `svg` is not 9-slice.

`#[require(Node, ImageNodeSize, ContentSize)]` — required components, already stolen.

### 3.3 Shadows, materials, ghosts

**`BoxShadow(Vec<ShadowStyle>)`** back-to-front; offsets/spread/blur as **Val**.
`BoxShadowSamples(n)` quality knob on the camera. Steal: multiple shadows as schema
(CSS already); sample budget renderer-internal.

**`UiMaterial` + `MaterialNode`:** custom WGSL on a **layout Node** without a full canvas
(bind group 0 = view/globals). Mid-way between `.shader(MyFx)` and `impl Canvas`. Confirm
`.shader(MyFx)` as the isolated-pass spelling; MaterialNode is the prior art.

**`GhostNode`:** layout participant skipped for hit/some UI queries. Ours: fragments /
`IntoChildren` / spacers. Steal as *internal* (a layout-only wrapper must not mint a
tab stop). Do not add a public `ghost()` widget.

Also named, already mostly CSS: BackgroundGradient (linear/radial/conic — our `Brush`);
Outline vs Border; GlobalZIndex vs ZIndex; ScrollPosition; RelativeCursorPosition
(= pointer GeometryRef); Interaction; FocusPolicy; Display::None vs Visibility;
BoxSizing; AspectRatio; UiScale; `IsDefaultUiCamera`.

Feathers: ThemeToken, ThemedText opt-in (**refuse** — we inherit), InheritableFont,
icon constants, BSN `@caption` props (07 §17.8).

### 3.4 Examples (`bevyengine/bevy` `examples/ui/`, Feathers gallery)

`ui_texture_slice` (9-slice), `ui_texture_atlas`, `ui_material`, `box_shadow`,
`overflow`, `flex_layout`, `grid`, `z_index`, `transparency`, `relative_cursor_position`,
`scroll`, `tab_navigation`, `directional_navigation`, `ghost_nodes`, `viewport_debug`,
`feathers_gallery`. These are the demos that justify the types above; `button` / `text`
do not.

### 3.5 Steal / refuse / miss (Bevy)

**Steal:** viewport units; 9-slice / tiled / atlas / crop / flip; multiply tint vs
colorize; Auto measure vs Stretch; transform as Length; multi-shadow; UiMaterial =
`.shader` on a node; required components / BSN `#Name` (already); generic font families
(already).

**Refuse:** ECS World in `view`; ThemedText opt-in; `bsn!` as view language; public
`FromStr` on Length; GhostNode as a widget.

**Honest miss:** BSN field patches after the helper erases to `Element`. `.pipe` / `+
Styled` is the close.

---

## 4 · GPUI internals (this checkout) — promote the verb

Do not rediscover these from Bevy/Iced. They already exist. Put a public verb on them
or keep them internal with a name in 07.

| Internal | Where | Public fate |
|---|---|---|
| `StyleRefinement` | `style.rs` / `div.rs` Interactivity | **is** BSN field merge. Keep; fluent + `.look` on top. |
| `rems()` / `font_size: rems(1.)` | geometry + style | Slint rem. Type scale stays rem. |
| table-driven `p_4` / `text_lg` | style macros | keep |
| `Length` / `DefiniteLength` / `AbsoluteLength` | `geometry.rs` ~3310–3650 | add `Vw/Vh/VMin/VMax`; no public `FromStr` (internal `TryFrom<&str>` already exists for theme files — keep it off the fluent surface) |
| `svg` elements | `svg.rs` | `icon` / `path` / `colorize` |
| `deferred` | `elements/deferred.rs` | measure-in-tree, paint-later. Placement graph / overlay paint order. Keep. |
| `anchored` | `elements/anchored.rs` | snap / flip to window. Placement `flip_within`. Keep. |
| `uniform_list` | `elements/uniform_list.rs` | becomes `virtual_list` + Lattice, not a range processor |
| `Hitbox` / `HitboxBehavior::{Normal, BlockMouse, BlockMouseExceptScroll}` | `window.rs` | compositor claims (06 pan). **Except-scroll** is the clever one — a modal that still lets the list under it wheel. Steal into overlay protocol. |
| `ElementId` variants | `window.rs:6660` | View / Integer / Name / Uuid / FocusHandle / NamedInteger / Path / CodeLocation / NamedChild / OpaqueId. Public ids are **branded enums**, not this kitchen sink. CodeLocation is the default embedding-site identity (we replaced `.key()`). NamedChild is `.at(Part)`. OpaqueId is text anchors (09). |
| `with_element_state::<S, _>(id)` | `div.rs` | TypeId + ElementId auxiliary state. **Replaced by fields.** Do not bring it back as a public hook. |
| `Interactivity` hover/focus/active style boxes | `div.rs` | retained variants. Keep. |
| tooltip delay | `div.rs` TooltipBuilder | `.intent(400.ms())` already |
| overflow / mask | `style.rs` | schema |
| `container_query` | `elements/container_query.rs` | 06 named-ancestor queries |
| entity `lease` (move to stack) | `entity_map.rs` | turn protocol; not a UI type |
| `cx.notify()` / coarse observe | app | the thing 07 deletes |

`deferred` + `anchored` composed (see `anchored.rs` tests) is already the overlay
pipeline: layout with the parent, paint after, snap to window. Iced `overlay()` is the
same idea with a worse name. Promote **deferred paint** as overlay paint order, not a
new widget.

---

## 5 · Cross-walk → law

| Finding | Lands in |
|---|---|
| 9-slice / tiled / atlas / crop / flip / tint vs colorize / Auto measure | media.md, 07 constructor table, examples/image_slice.rs |
| `vw`/`vh`/`vmin`/`vmax` | style/README, 07 §2 lengths, GPUI Length enum (design) |
| Transform translation as Length | style/README, 07 §16.3 |
| Multi-shadow | style schema |
| pane_grid leeway / ratio / maximize / last-active | 06 §4, 07 §17.9 |
| Overlay BlockMouseExceptScroll | 06 overlay / 07 §16.3 |
| Flickable delayed-arm | 07 §18.1 |
| Pointer as GeometryRef | 07 §16.3, examples/pointer_follow.rs |
| ModelExt / `unfiltered_row` = Slot | collections.md, 07 §4 |
| Canvas Cache / Mesh2D | 07 §15.2/§15.2.1 |
| Named palettes + Pair::readable | color.md |
| Overwritten-binding diagnostic | 07 §17.5 / §1 |
| Operation visitor | inspector / UiTest only |
| `fluid`/`enclose` | Taffy-internal |
| UiMaterial | `.shader(MyFx)` already |
| GhostNode | internal only |
| Message / Subscription / Catalog / bsn! / .slint | still refuse |

Demos we should be able to port as sketches (not compile against current GPUI):
Iced `pane_grid` + `bezier_tool`, Bevy `ui_texture_slice` + `relative_cursor_position`,
Slint gallery chrome. Worked sketches: [image_slice.rs](../examples/image_slice.rs),
[pointer_follow.rs](../examples/pointer_follow.rs), [docking.rs](../examples/docking.rs).
