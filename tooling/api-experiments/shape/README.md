# Unified shape API experiment

This stand-alone workspace prototypes an element shape API that combines named-field descriptors,
capability membership, generic provider support, and selectors that compose requirements with
`.and::<Capability>()`. It does not modify the GPUI workspace manifest. Run the prototype with:

```sh
CARGO_TARGET_DIR=tooling/api-experiments/shape/target cargo run --release --manifest-path tooling/api-experiments/shape/Cargo.toml
```

A concrete type gets one derive, which emits a link-time inventory registration for non-generic types. Builtin `Styled` and `Parent` capabilities are detected when the
type implements the modeled traits. A custom capability stays explicit because Rust cannot
enumerate arbitrary trait implementations; the `Implements` bound makes the type opt in:

```rust
#[derive(Shape)]
#[shape(capabilities(cap::Draggable))]
struct Card { title: String, payload: String }
impl traits::Styled for Card {}
impl traits::Parent for Card {}
impl Implements<cap::Draggable> for Card {}

let query = Select::descendants().with::<cap::Styled>().and::<cap::Draggable>();
assert!(query.matches::<Card>());
let fields = Card::shape().fields; // descriptors are data, not trait method forwarding
```

Generic providers require an explicit registration list, including builtin capabilities, and an
`Implements<Capability>` proof for each custom capability. This
boundary is enforced by the derive and covered by a compile-fail fixture:

```sh
CARGO_TARGET_DIR=tooling/api-experiments/shape/target cargo check --manifest-path tooling/api-experiments/shape/compile_fail/Cargo.toml
```

The benchmark uses only `std::time::Instant`: first metadata initialization for a fresh type, then
warm metadata lookup plus two selector predicates over two million iterations. One optimized run
on 2026-10-07 reported 375 ns cold initialization and 30 ns per warm iteration. Treat these as
smoke measurements, not statistically controlled timings. They cannot be compared directly with
GPUI's production Criterion benches because they exclude element erasure, method adapters, selector
tree traversal, and framework setup.

## Recommendation and boundaries

Use one `#[derive(Shape)]` on the concrete element/provider to generate its field descriptors,
type identity, builtin membership, and a link-time registration hook. Keep capability adapters generated at
the capability trait declaration, where the macro has the trait's method signatures. The Shape
derive instantiates those typed adapters for capabilities listed on the type. This can replace the
concrete `Reflect` derive and `trait_set!` composition macro without claiming that a derive can
find arbitrary custom `impl Trait for T` declarations.

A generic escape hatch is necessary: concrete trait bounds can vary by monomorphization. Support
explicit `#[shape(capabilities(...))]` and a handwritten `ShapeProvider` for conditional or
hand-authored registrations. Runtime metadata should continue using `TypeId` identity, receiver
validation, and adapter identity checks. Registration should be process-owned and immutable so
selectors do not retain instance callbacks.

Keep field information separate from callable capabilities. A field descriptor may expose its
name and type and, where the concrete type opts in, typed field access; it does not imply forwarding
methods from a trait. A selector still acts on the concrete element surviving `IntoElement`
conversion. A `ViewElement<V>` and its rendered root therefore remain separate shapes.

Facet is relevant prior art for the data half of this design: its official crate docs describe a
single derive that generates a static `SHAPE` description of fields and layout, with separate
reflection crates for value access. GPUI's reflected trait adapters solve a different problem and
should remain a separate part of the shape registration. See [Facet crate docs](https://docs.rs/facet/latest/facet/)
and [Facet's explanation of static type data](https://facet.rs/guide/why/).

## Mapping from the current GPUI API

| Concern | Current surface | Proposed shape surface |
| --- | --- | --- |
| Concrete metadata | `#[derive(Reflect)]` + `Reflect::build_reflection` + `Element::reflection` forwarding | `#[derive(Shape)]` emits immutable shape data and concrete link registration; generic/handwritten providers implement `ShapeProvider` or list registrations |
| Builtin capabilities | Non-generic derives probe `Styled`, `InteractiveElement`, `StatefulInteractiveElement`, and `ParentElement`; generic derives enumerate every desired trait | Keep builtin discovery in the derive for concrete elements; use explicit per-monomorph registrations for generic providers |
| Custom callable method schema | `#[reflect_trait]` emits trait token and method-table adapter; membership-only traits use its alternate mode | Keep a single focused trait-schema attribute/macro: a type derive cannot generate a safe typed vtable without the trait's signatures |
| Combined query requirements | `trait_set![A, B, ...]` generates a static proof group | `Select::...with::<A>().and::<B>()` accumulates a generic `All<A, B>` requirement; provide `and_all` only if ergonomic arity becomes a real problem |
| Field information | Not part of element reflection today | Shape field descriptors are separate from callable capability methods and remain opt-in for sensitive access |
| Receiver identity | Runtime `TypeId` validation rejects a mismatched concrete receiver | Retain the same validation in shape adapters and preserve component/wrapper conversion boundaries |

The unification is worthwhile at the concrete type registration layer. Fully deleting the trait
schema macro would either lose generated method adapters or require unsafe, layout-based trait
casting. `trait_set!` is the easiest macro to remove: nested generic requirements compose normally
and preserve compile-time callable bounds. A type-level `All<A, B>` also composes selectors built
in separate functions without a generated opaque group.

## Comparison with GPUI's current one-derive query API

The production API uses `#[derive(gpui::Element)]` as the consumer-facing aggregate derive. Its
`#[element(style, children, interactive, stateful)]` field options delegate the element lifecycle
and selected builtin builder traits to a stored root; the same selections register the matching
builtin reflected capabilities. `#[reflect(...)]` on the element adds custom reflected traits or
capability projections. The aggregate derive expands the existing `Reflect` machinery internally,
so ordinary wrappers need one derive instead of hand-implementing `Element` and separately deriving
`Reflect`.

The shape-inspired ideas that fit this behavioral API are concrete link-time registration and
immutable type metadata, generic metadata per concrete monomorphization, automatic handling of a
known set of builtin capabilities, exact `TypeId` identity, and statically composed selector
requirements. Production concrete derives submit an inventory registration and memoize reflection
metadata; generic providers initialize metadata for their concrete `TypeId`. Selectors compose
trait groups with tuples or `.and(...)`, and concrete `of::<Type>()`, authored `component::<Type>()`,
and registered `capability(HANDLE)` are typed projections with distinct receiver semantics.

The Facet-like data description was not imported. GPUI reflection is designed around callable
behavior on an erased, mutable element, so fields are not enumerated or exposed as forwarded
methods. The custom `Capability<Target, Key>` route registers a typed function-pointer projection;
the `#[reflect_trait]` route generates method adapters from a declared trait schema. The consumer
chooses which one to register on each concrete element. This keeps two projections of the same trait
type distinct through `Key`, and ties the returned borrow to the callback/receiver rather than
retaining an element pointer in process-global metadata.

General trait-implementation enumeration remains incompatible with Rust's coherence and linking
model: `#[derive(Element)]` cannot discover arbitrary downstream `impl SomeTrait for MyElement`
blocks. GPUI's implicit path is deliberately limited to four declared builtin traits, with
reflection generated from their framework-owned schemas. Generic elements still need explicit
custom registrations because trait bounds can vary by monomorphization. A handwritten provider can
supply the same registrations when derive syntax is insufficient. Component wrappers and rendered
roots stay distinct receivers after conversion; reflection follows the concrete stored element.

In practical terms, the experiment's static `ShapeInfo` fields would be a separate opt-in feature,
not a substitute for GPUI's custom projections or generated trait vtables. The API-level win from
unification is one aggregate `Element` derive for lifecycle, selected builtin delegates, and
registration. The API-level win from generic selector composition is already represented by tuples
and `.and(...)`; `trait_set!` remains useful for a reusable named set, but it is not required for
one-off composition.

### Isolated rerun evidence

The release executable and compile-fail fixture were rerun with the experiment's own target
directory (`CARGO_TARGET_DIR=tooling/api-experiments/shape/target`). The release executable exited
successfully, reporting `shape_api_experiment::CardShape`, its three fields, and the `Styled`,
`Draggable`, and `Parent` capabilities. This run measured 459 ns for first metadata initialization
and 53.5 ns per warm metadata lookup plus two selector predicates over 2,000,000 iterations. The
fixture exited with code 101 and emitted exactly one intended diagnostic: generic `Shape` derives
require an explicit `#[shape(capabilities(...))]` registration list. Timings are single-run smoke
measurements and are not directly comparable with GPUI's Criterion benches.
