# Typed property traversal and component-library composition

Read-only source audit of `/root/gpui-ce3/reactivity` at `8ea8b9d76abb76717bd84fc28a5d471ce69f5ed3` (2026-10-22). No production files, builds, tests, or timings were changed or run. External primary-source documentation was checked on 2026-10-22; versions are pinned in the source list below.

## Implementation review dispositions

This report is a proposal, not an implementation result. The active Sol spike
uses compact property-ID/operation actions and reads the value only after target
admission. Carrying `PropertyValue` in every action would enlarge boxed routes
and admission stack values even though the ordinary `Handler` header is already
boxed. Its measured baseline is `PropertyValue=28 B`,
`Contribution<PropertyValue>=28 B`, `Handler=16 B`, `El=176 B` and
`Inspector=24 B` on Linux x86_64; these are not portable ABI promises.

The first proposed panel uses 13 picker rows and one selected-family editor in
an ordinary scroll viewport, rather than materializing the report's 151-node
upper-bound layout. Step/cycle controls cover the value families but do not
provide arbitrary numeric, color or transform text entry. Full entry remains a
delivery requirement. A reusable contained tool owner must use the ordinary
typed source/input interface; an inspector-only field namespace or writer
bypassing that interface is not an acceptable shortcut.

ID-based edits infer the domain from the closed ID, so callers cannot supply a
separate wrong-domain argument. Test the actual wrong-kind boundary and the
Geometry Number row. Preserve authoring equality and Set presence through the
same canonical transaction. The source caps below are review triggers, not final
size predictions or permission to remove required behavior.

## Decision

The reflection gap is real, but the core already has a sound typed schema. `properties!` in [`property.rs`](</root/gpui-ce3/reactivity/crates/gpui/src/property.rs:360>) generates the selectors, metadata, defaults through typed accessors, validation, exact-value comparison, and ID dispatch from one declaration list. `PropertyValue` is already the closed erasure for the eight value categories. It is private, and there is no public `PropertyId` read/contribution/write path, so external tools can enumerate 13 `PropertyInfo` records but cannot traverse and edit their heterogeneous values.

The smallest useful change is to expose that existing closed value union at the deliberate inspector boundary and add three ID-based `Win` methods for logical read, contribution read, and validated contribution write. Reuse the existing generic `Contribution<PropertyValue>` for Set/Inherit; a second wrapper enum would add a public name without adding a state or invariant. Keep the typed `Property<T, D>` APIs as the ordinary application API. Both typed and ID-based writes must enter the same `Overrides` and destination paths. This gives an inspector one row per `PROPERTIES` entry, with one control implementation per `ValueKind`, without one selector branch in the inspector or a second metadata table.

Component composition is a separate issue. `Component<P, C>` composes parent-owned model state and projects handlers; `Sources` registers model fields and source dependencies. Neither is a visual component-style or theme-cascade abstraction. A component library should expose a typed appearance/configuration value and a typed behavior input. Its view lowers those values through the existing builders and `on_click` route. The inspector then edits the resulting node’s core properties using the runtime override layer. No reflection over arbitrary application fields is needed.

## What the implementation already guarantees

[`PropertyId`](</root/gpui-ce3/reactivity/crates/gpui/src/property.rs:17>) has 13 explicit IDs: Width, Height, Gap, Padding, FontSize, Foreground, Background, Flow, Transform, Align, Justify, Wrap, and CornerRadius. `PROPERTIES` contains references to those declarations; the property test asserts length 13 and checks unique names/IDs and metadata identity. There are 12 Style-destination properties and one Geometry-destination property. `ValueKind` has eight editor categories; `CornerRadius` is a Number in the Geometry domain, so an editor must use both `kind` and `destination`, not assume the kind determines the storage domain.

Each `Property<T, D>` is a single pointer to a private declaration. The declaration owns typed get/put, validation, and authoring equality. The `properties!` macro creates the selector constants and generated `PropertyId` validation/get/set branches. Corner radius is deliberately a separate typed Geometry selector. Existing compile-fail examples prevent forging a `Property` and prevent passing the wrong Rust type to a selector. `PropertyValue` already has exactly the dynamic cases an editor needs: `Dimension(Option<f32>)`, `Number(f32)`, `Color`, `Flow`, `Transform`, `Align`, `Justify`, and `Flag(bool)`. The enum is currently `pub(crate)` at [`property.rs:471`](</root/gpui-ce3/reactivity/crates/gpui/src/property.rs:471>).

`PropertyInfo` is intentionally only metadata today: destination, ID, name, value kind, and impact. It does not contain an external setter, validator, parser, or impact claim. That is the right policy boundary. Do not add a second default/validator/impact array beside it. Default values already come from `Property::default_value()` and the destination’s `Default`; the editor can read the current effective value and the current `Inherit | Set` contribution instead of duplicating defaults.

The public testing surface is already strong for statically named properties: `Win::property`, `Win::contribution`, and `Win::set_property` accept `Property<T, D>` and `Contribution<T>` at [`runtime.rs:1324`](</root/gpui-ce3/reactivity/crates/gpui/src/runtime.rs:1324>). `PropertyDomain::dispatch` routes Style and Geometry at compile time. The missing piece is safe traversal when the selector is only known by iterating the public catalog.

`Overrides<D>` retains values only for nodes that have a contribution. It stores `Set(default)` even when the destination value is equal, and `Inherit` removes the contribution. During re-description or source publication, the current declaration updates the lower base while a masked override remains visible. Clearing it reveals the newest lower value. These rules are already tested in `property.rs` and `style_ports.rs`; they must remain true in the ID-based API.

The current Inspector is explicitly narrower. [`inspector.rs`](</root/gpui-ce3/reactivity/crates/gpui/src/runtime/inspector.rs:33>) has seven actions, of which the editing actions cover width and background only. It hard-codes `PANEL_NODES = 17`, a seven-variant `Caption` layout, width/height window-size refresh, and selected width/background reads at lines 217–315. [`docs/inspector.md`](</root/gpui-ce3/reactivity/crates/gpui/docs/inspector.md>) describes the same limitation. This is a panel/editor coverage gap, not a missing style declaration schema.

There are two state authorities. `Win::property` reads current logical style `L`; its API comment says the displayed sheet can lag after presentation failure. Inspector property edits resolve a current `Target` against that logical cohort. `Presented`/displayed bounds and transform are the acknowledged presentation `P`, and their inspector captions carry an epoch. A failed preparation may leave new logical property values with old displayed geometry. A catalog editor must read and write `L`, and label/display geometry from `P` separately. It must not take a `SnapshotNode` display value as authority for a property edit.

`Component<P, C>` is a borrowed model projection, as its module comment and fields show at [`component.rs:1`](</root/gpui-ce3/reactivity/crates/gpui/src/component.rs:1>): ID/name plus parent read/write functions; `view()` calls the child’s `View`, scopes its handlers, and creates the component boundary. `Sources` recursively registers/validates child field schemas, using cold boxed schema records at [`source.rs:567`](</root/gpui-ce3/reactivity/crates/gpui/src/source.rs:567>) and [`source.rs:685`](</root/gpui-ce3/reactivity/crates/gpui/src/source.rs:685>). Those boxes and `Any` checks are for owner schema/handler routing, not a property-editor hot path. Adding style reflection to `Sources` would conflate model-field editing with node-style editing.

Today there is no implemented theme cascade. The lower style is the resolved builder output and reactive style ports; inspector `Overrides` is a sparse per-target layer on top. Source colors are retained relationships in the style bank, but there is no public `Theme`, inherited token scope, or general `StylePatch` stack. `Style::DEFAULT` is the core fallback. The prior final design documents specify a richer theme cascade, but that plan is not the current runtime. The current `Flex` recipe is a useful typed-composition precedent for flow/gap/alignment/justification/wrap, not a general component-theme or reflection system.

## Proposed public editing boundary

Promote the existing enum to public visibility without changing its variants or layout, and reuse the existing generic contribution wrapper:

```rust,ignore
pub enum PropertyValue {
    Dimension(Option<f32>),
    Number(f32),
    Color(Color),
    Flow(Flow),
    Transform(Affine),
    Align(Align),
    Justify(Justify),
    Flag(bool),
}

impl Win {
    pub fn property_value(
        &self, target: Target, property: PropertyId,
    ) -> Result<PropertyValue, Error>;

    pub fn property_contribution(
        &self, target: Target, property: PropertyId,
    ) -> Result<Contribution<PropertyValue>, Error>;

    pub fn set_property_value(
        &mut self, target: Target, property: PropertyId,
        contribution: Contribution<PropertyValue>,
    ) -> Result<Commit, Error>;
}
```

These are additive tool APIs; ordinary application code continues to use `WIDTH`, `BACKGROUND`, `Contribution::Set(value)`, and compile-time type checking. The dynamic `Set` boundary is still closed to GPUI’s eight concrete value families. It is not `Any`, `TypeId`, a string setter, or an application-supplied callback.

The read method resolves the target to its current logical node and dispatches via `PropertyInfo.destination`. The contribution read queries the corresponding `Overrides` store. The setter first checks the `PropertyId`/`PropertyValue` pairing and validator through the declaration already generated by `properties!`; wrong kind, wrong destination, or invalid numeric input returns `PropertyError` before changing contribution presence, base values, or the source epoch. The accepted edit then uses the same shared sparse override update and impact path as `set_property`. Refactor the existing generic setter only as far as needed so the typed and erased entry points do not have separate validation, equality, reset, or base-update algorithms. In particular, setting a valid value equal to the current effective value must still store `Set(value)`.

Do not put strings in the setter API. `PropertyInfo.name` remains display text. Text/keyboard parsing, if an editor chooses to support it, belongs in a UI control that converts input to a `PropertyValue` before calling `Win::set_property_value`; the core setter never accepts names or parse callbacks. Better controls can emit `PropertyValue` directly.

A generic editor can be written once over the public schema:

```rust,ignore
for info in property::PROPERTIES {
    let value = win.property_value(target, info.id)?;
    let presence = win.property_contribution(target, info.id)?;
    property_row(info, value, presence, |edit| {
        win.set_property_value(target, info.id, edit)
    });
}
```

`property_row` has an exhaustive match on the eight `ValueKind` categories, not a match on `PropertyId`. A Dimension control includes explicit `Auto` (`Set(None)`) and a distinct `Inherit`/Reset action. Number controls submit their value to the canonical validator; they do not copy ranges or validation rules. Color, transform, enum, and bool controls construct the corresponding union variant. The property ID is carried in the action payload. Runtime validation remains authoritative: for example, `0` is allowed for gap and padding but invalid for font size, even though all are `Number`. The corner-radius row routes to Geometry by its destination even though its value is also `Number`.

The current `PropertyValue::PartialEq` is ordinary enum equality, while declaration equality intentionally preserves exact float bits and color profile. The setter must continue to use the selector’s `same_authoring` path; the UI must not decide whether an edit is a no-op by comparing its displayed value and dropping it. Presence is separately read through `Contribution<PropertyValue>`.

## Component-library style and behavior composition

Use explicit library-owned appearance structs and normal caller values. The libraries should not register core property IDs for their theme fields. Their view code maps each appearance field to the existing typed builder once, so core validation and impact remain centralized.

```rust,ignore
// action-button crate
#[derive(Clone, Copy)]
pub struct PrimaryAppearance {
    pub fill: Color,
    pub ink: Color,
    pub radius: f32,
}

pub fn primary<'a, M: 'static, S, H: IntoHandler<M, S>>(
    label: &'a str, appearance: PrimaryAppearance, on_activate: H,
) -> El<'a> {
    button(label)
        .bg(appearance.fill)
        .fg(appearance.ink)
        .rounded(appearance.radius)
        .on_click(on_activate)
}

// filter-chip crate exposes its own unrelated typed appearance and behavior.
// It lowers its Color/f32/Flow choices through `bg`, `fg`, `rounded`, `layout`, etc.

impl View for Screen {
    fn view(&self) -> El<'_> {
        row((
            action_button::primary(
                "Save", self.appearance.save, Screen::save,
            ),
            filter_chip::choice(
                "Open", self.appearance.open_filter, Screen::open_filter,
            ),
        ))
    }
}
```

This is a shape for library APIs, not a claim that those example crates already exist. A real library can keep `Appearance` fields private and offer typed builder methods. Its default appearance is defined once by that library; app theme/caller values are explicit arguments or owner fields. The behavior is a typed method item/handler or a library-defined action enum, separate from style metadata. The caller can replace the handler when constructing the library view, and the existing `on_click`/component routing keeps its model receiver and owner scope. Do not reflect over or mutate private callbacks, and do not make a behavior override part of `PropertyValue`.

If a library value is reactive, use the existing property source forms and register the source in the owning `Sources` schema. The source is borrowed while `View` describes the element and retained downstream as an owner-relative `FieldId`; do not retain a model/Signal pointer. Component source ownership and schedule invalidation still follow the existing `.component`/`.direct_component` contract. A library theme should be passed to a component/view as typed data, or owned by the application/window model; it should not be a process-global singleton or a borrow kept beyond `View`.

A representative public fixture uses two ordinary libraries: a primary button library with `PrimaryAppearance { fill, ink, radius }` and a filter-chip library with `FilterAppearance { fill, ink, gap }`. The app supplies distinct appearance values and typed handlers to both. Tests find both elements via `Win::inspect`, edit their lowered `BACKGROUND`, `CORNER_RADIUS`, and `GAP` with the normal public `Win` APIs, change the source appearance under a masked contribution, and verify `Inherit` reveals the newly declared value. The behavior test clicks each control and proves its caller-selected action targets the right owner. The libraries need no derive, runtime registration, or copy of GPUI validators.

The current precedence/lifetime contract is therefore:

1. A library default or explicit app appearance is lowered as the current component declaration.
2. Reactive source updates change that declaration/base through the existing source path.
3. A per-window Inspector contribution masks that lower declaration for one logical target.
4. `Inherit` removes the Inspector contribution and exposes the newest lower declaration.

This is the current implemented layering. If the project wants an independent inherited theme layer between library default and app instance style, that is a separate product/API addition: define its owner, precedence, source version, reset rule, and two-window lifetime before implementing it. Do not label the current Inspector overlay as a theme cascade.

## Competing formulations

| Formulation | What it would look like | Advantages | Costs and rejection gate |
|---|---|---|---|
| **A. Closed catalog + public `PropertyValue` (recommended)** | Reuse `PROPERTIES`, expose the existing eight-case union and `Contribution<PropertyValue>`, add three ID-based `Win` methods. | One schema owns selectors, metadata, validation, equality, impact, and destination. Iteration is data-driven; editor code branches by value family. Dynamic values stay closed and owned. | Adds a dynamic boundary, so type mismatch becomes a runtime `PropertyError`; keep static selectors for ordinary app code. Reject if a new property requires changing both the declaration and a separate editor-per-property switch, or if an ID-based write can bypass the typed validator/base update. |
| **B. Generic typed visitor with fallback** | For example `trait PropertyVisitor { fn visit<T, D>(&mut self, p: Property<T, D>); fn unknown(&mut self, info: &PropertyInfo) {} }`, called once per selector. A downstream visitor handles typed values in generic code. | A compile-time consumer sees each real `Property<T,D>` and can specialize behavior without public type erasure. A default method can make the visitor tolerant of metadata-only rows. | A generic method makes the trait non-dyn-compatible; Rust’s trait-object contract excludes generic type parameters from dispatchable methods. A `Vec` of heterogeneous `Property<T,D>` still needs an enum or erased value. A concrete visitor can monomorphize per property/category/caller; this is not zero-cost and can duplicate editor/action code across two libraries. Reject unless a compiling two-library fixture demonstrates one row implementation, no erased value seam, acceptable linked text/build time, and no per-property dispatch in downstream code. The exact `PropertyValue` union already is the smaller runtime boundary. |
| **C. Derive-based reflection on `Style` or component config** | Derive Bevy `Reflect` or Facet on the style/config struct; inspect fields and possibly edit them reflectively. | Useful for general config editors, serialization, diffing, and opaque tool workflows. Optional derivation can be useful for library-owned configuration types. | Reflection describes Rust fields, not GPUI property policy. It does not automatically add `Contribution::Inherit`, `Impact`, runtime destination, validators, exact authoring equality, or `L`/`P` authority. Direct field mutation bypasses core property setters. Requires opt-in annotations/registration and adds runtime/codegen/compile costs. Reject as the core node-property path unless a derive can prove it routes all edits through the existing validated selector without exposing arbitrary app fields. |
| **D. Open trait-object/registry property extensions** | Libraries register `dyn PropertySpec` rows carrying IDs, get/set callbacks, value boxes, or type IDs. | Third-party plugins could add genuinely new runtime property types without rebuilding the GPUI schema. | This is a plugin/ABI design, not ordinary component composition. It introduces identity/version/registration order, type-erased payloads and callbacks, and a dynamic dispatch surface. It risks strings/`Any` and duplicate validation/impact definitions. Reject for the closed set of 13 renderer properties; revisit only at a real dynamic-plugin boundary with schema-versioning and cold-path isolation. |

A plain typed `PropertyVisitor` can be useful as an internal compile-time adapter for a single operation, but it does not solve a runtime inspector catalog by itself: the inspector has to store/display/edit heterogeneous values and send edits back after the row is built. In Rust, that boundary has to be one of a closed value enum, a trait object, a family of per-property action variants, or a runtime type registry. The closed union already exists and matches the actual domain.

## External design evidence

Bevy Reflect 0.20.0 is an explicit reflection system, not automatic Rust field introspection. Its derive generates `Reflect`, `Typed`, `GetTypeRegistration`, and `FromReflect`; its base trait supports `dyn PartialReflect`, runtime field traversal, dynamic values, and a type registry. The docs require reflected fields/sub-elements and `Any + Send + Sync + 'static` for the full `Reflect` path. This is a viable opt-in application/configuration editor but does not encode GPUI’s per-property impact and reset semantics. [Bevy Reflect 0.20.0 overview](https://docs.rs/bevy_reflect/0.20.0/bevy_reflect/), [derive contract](https://docs.rs/bevy/0.20.0/bevy/reflect/derive.Reflect.html), [TypeRegistry](https://docs.rs/bevy/0.20.0/bevy/reflect/struct.TypeRegistry.html).

Facet 0.46.5 makes the invariant boundary particularly clear: `Poke::set` can replace a whole value, but mutating struct fields through `PokeStruct::set_field` requires `#[facet(pod)]`, because field writes may violate invariants. Its FAQ also says reflection trades speed for one shape usable across tooling and can reduce binaries in format-heavy applications; it does not claim reflection is faster than monomorphized serialization. Those are useful trade-offs for a general settings editor, not a reason to mutate `Style` fields around `Property::validate`. [Facet `Poke` 0.46.5](https://docs.rs/facet-reflect/0.46.5/facet_reflect/struct.Poke.html), [Facet FAQ](https://facet.rs/guide/faq/).

The current egui 0.37.0 API is an example of explicit scoped style composition: a `Ui` exposes mutable `Style`/`Visuals`, with changes applying to that UI and its subsequent children; `Context` can set broader styles. This gives component authors a direct caller-controlled customization surface. It does not offer GPUI’s retained logical target, contribution-presence, or presentation acknowledgment semantics, so copying its mutable style object would not replace the GPUI override layer. [egui `Ui::style_mut` 0.37.0](https://docs.rs/egui/0.37.0/egui/struct.Ui.html#method.style_mut), [egui `Style` 0.37.0](https://docs.rs/egui/0.37.0/egui/style/struct.Style.html).

Slint 1.18.1 exposes component/global properties through generated typed getters/setters and scopes globals to a component/window instance. Its widget style docs expose `Palette` and `StyleMetrics` to reusable components and select whole widget styles through its build/interpreter configuration. This is a useful precedent for explicit per-window theme ownership and public style inputs. GPUI should keep that data in its own model/window owner and typed component arguments, rather than adopting an ambient singleton that bypasses `Sources`. [Slint `Global` 1.18.1](https://docs.rs/slint/1.18.1/slint/trait.Global.html), [Slint widget styles](https://docs.slint.dev/latest/docs/slint/reference/std-widgets/style/), [Slint global language API](https://docs.slint.dev/latest/docs/slint/reference/language/globals/).

Rust’s object-safety/dyn-compatibility rules and generic monomorphization explain why a typed visitor is not an automatic zero-cost heterogeneous catalog. A method with generic type parameters is not dispatched through a trait object; a concrete generic visitor specializes code for the concrete types at its calls. Any claim that this improves linked code or compile time needs measurement. [Rust Reference: dyn compatibility](https://doc.rust-lang.org/reference/items/traits.html#dyn-compatibility), [Rust Book: generic monomorphization](https://doc.rust-lang.org/book/ch10-01-syntax.html#performance-of-code-using-generics).

## Smallest production slice and explicit budgets

1. Make `PropertyValue` public with its current variants; reuse the existing `Contribution<PropertyValue>` for Set and Inherit. Keep `PropertyInfo` fields unchanged. Keep the same 13-row static `PROPERTIES` table; do not add a second vtable/metadata table.
2. Add the three ID-based `Win` methods. Route IDs through `PropertyInfo.destination`, the existing sealed domain adapters, and the same sparse override transaction used by typed `Win::set_property`. Validation, exact equality, source-base changes, impact, target checks, and commit/presentation behavior remain owned by the current path.
3. Replace only the two hard-coded style-editor paths with a loop over `PROPERTIES`. Implement one editor per `ValueKind`; carry `PropertyId` and a `Contribution<PropertyValue>` in the window action. Keep the panel beside the app as it is now; do not build a copied app tree. Keep displayed `P` captions separate from editable logical `L` values.
4. Demonstrate two library-owned typed appearance structs and caller-supplied actions in an external integration fixture. Do not require application derives or macros. Keep behavior callbacks/actions separate from style values.

**Representation budget:** zero new bytes in `PropertyInfo`, `Property<T,D>`, `Style`, `El`, `Node`, `Presented`, `Runtime`, and ordinary metadata from the dynamic property facade. The existing size assertion says `Property<T,D>` is one pointer. `PropertyValue` already exists, so making it public changes no payload layout. `Contribution<PropertyValue>` is passed by value across the cold tool API; it is not stored per node. The existing `PROPERTIES` slice remains 13 references (104 bytes for reference slots on a 64-bit target), with zero added reference slots. These are structural budgets; Rust enum ABI size is not promised. Record `size_of::<PropertyValue>()` and `size_of::<Contribution<PropertyValue>>()` in a test on supported target profiles rather than inventing a portable byte size.

**Inspector storage budget:** no fields added to normal app nodes or presented nodes. For a fully visible 13-row panel, set a hard cap of 11 ordinary panel nodes per property row: one row container, one label, one current-value slot, up to six transform component controls, one Set/apply control, and one Inherit/reset control. Keep at most 8 fixed panel nodes for title/pick/selection/layout/parent/displayed-geometry captions. Thus the panel cap is `8 + 13 × 11 = 151` nodes, including its root, compared with today’s 17. This is a structural bound for the proposed row shape, not a measured memory or startup result. If editors require more, use a clipped/virtualized visible-row panel and count the actual retained nodes; do not add a second app shadow tree. Typed arbitrary text entry requires editor draft/input state and a parser at the UI boundary; that cost must be reported separately. A typed action/slider control avoids a string setter, but it is not a substitute for arbitrary numeric entry if the product requires it.

**Source-growth budget:** keep the core facade within 100 net production Rust lines across `property.rs`, runtime property accessors, and the shared override adapter. Keep catalog-driven editor/action additions within 200 net production lines beyond the current Inspector implementation, excluding tests and comments. These are review caps, not source-count measurements. If the generic-editor design exceeds them, report actual source and symbol growth before expanding scope. No new per-property declaration row is needed for traversal; adding a new core property still requires one library-owned declaration and typed builder, and only a new `ValueKind` requires one editor implementation.

## Public adversarial acceptance fixture

The initial slice should have an external integration test using only `gpui::property::PROPERTIES`, public `PropertyValue`/`Contribution<PropertyValue>`, `Win`, and `Target`:

- Iterate all 13 metadata records and round-trip one valid value per `ValueKind`, without matching on `PropertyId`. Assert every ID appears once and `info` points to the same record returned by `id.info()`.
- Check the Geometry `CornerRadius` row despite its Number kind. Reject wrong-kind values for each domain without changing the logical property, contribution map, source epoch, or another target.
- Submit invalid dimensions, negative gap/padding/radius, zero font size, and non-finite transform. Verify exact `PropertyError` reasons and atomic rejection. Verify `Width Set(None)` is explicit Auto and differs from `Inherit`.
- Set a contribution equal to the current resolved/default value and prove it remains `Set`. Change a lower source/theme value while masked, prove the displayed property remains overridden, then reset and prove the newest lower value appears.
- Mount two app-supplied library views with distinct styles/actions. Public inspection finds the nodes; style changes target only the chosen node, and clicks invoke only the selected caller behavior. Repeat with separate `Win`s and reject a foreign/stale target.
- Force a presentation preparation failure after an accepted logical edit. `property_value` and `property_contribution` must report logical `L`; displayed bounds/captions must remain tied to the old acknowledged `P` epoch until successful preparation/acknowledgment.
- Keep compile-fail coverage for the typed `Property<T,D>` API: wrong value type, forged selector, and Geometry selector used with Style. Add compile-fail proof that a library `El<'_>` borrow cannot escape its owner before a mutable update/await. The dynamic API intentionally runtime-checks a mismatched enum value, but it must never silently coerce it.
- Measure linked text size and compile time for one and two external library crates implementing the typed recipes. Generic visitor alternatives are rejected if they increase either beyond the accepted baseline without proving simpler public code or a measured runtime win. No such measurement was performed in this read-only task.

## Primary sources and local seams

External documentation versions: Bevy Reflect 0.20.0; Facet/facet-reflect 0.46.5; egui 0.37.0; Slint 1.18.1; Rust Reference/book pages checked 2026-10-22.

Local implementation and design references are pinned to the repository snapshot in the header: [`property.rs`](</root/gpui-ce3/reactivity/crates/gpui/src/property.rs:17>), [`runtime.rs`](</root/gpui-ce3/reactivity/crates/gpui/src/runtime.rs:1324>), [`runtime/geometry.rs`](</root/gpui-ce3/reactivity/crates/gpui/src/runtime/geometry.rs:1>), [`runtime/inspector.rs`](</root/gpui-ce3/reactivity/crates/gpui/src/runtime/inspector.rs:33>), [`component.rs`](</root/gpui-ce3/reactivity/crates/gpui/src/component.rs:1>), [`source.rs`](</root/gpui-ce3/reactivity/crates/gpui/src/source.rs:567>), and [`style.rs`](</root/gpui-ce3/reactivity/crates/gpui/src/style.rs:1>). The earlier final style plan’s layered cascade is in [`final/03-ports.md`](</root/designs/reactivity/final/03-ports.md:204>); the current Inspector scope is documented in [`docs/inspector.md`](</root/gpui-ce3/reactivity/crates/gpui/docs/inspector.md>).

## Editor hints and serialization boundary

`ValueKind` selects a reusable editor family; `PropertyId` selects the row; `PropertyInfo.name` supplies its label; `destination` distinguishes Geometry from Style. An application can filter visible rows with an explicit `PropertyId` allow-list without changing the core catalog or setter. Do not encode numeric min/max in a second editor table: validity varies within `Number` (zero gap is allowed while zero font size is rejected), so the existing selector validator remains authoritative. If the UI later needs non-authoritative affordance hints such as units or preferred step, add a small typed hint to the existing declaration/`PropertyInfo` in the same `properties!` source, then measure `PropertyInfo` and static-table size; do not add a parallel hint registry.

The explicit `PropertyId` values help identify rows, but `repr(u16)` plus display names is not a persistence contract: `PropertyId` has no serialization, versioning, or migration API. If saving inspector presets becomes a real requirement, define a separately versioned closed document format keyed by stable IDs, decode into `PropertyValue`, then run the same canonical setter validation. Do not put format callbacks or editor-only constraints into each `PropertyInfo` now.
