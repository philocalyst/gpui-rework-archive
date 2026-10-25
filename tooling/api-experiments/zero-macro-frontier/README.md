# Zero-macro frontier

This std-only prototype asks how far ordinary Rust can go toward Go-style
reflection without user macros, per-trait annotations, or explicit handle
constants. It isolates runtime erasure and schema strategies; it does not
measure GPUI rendering or lifecycle behavior.

Run the correctness checks and optimized experiment with:

```sh
cargo test --manifest-path tooling/api-experiments/zero-macro-frontier/Cargo.toml --target-dir /tmp/gpui-zero-macro-frontier-target
cargo run --release --manifest-path tooling/api-experiments/zero-macro-frontier/Cargo.toml --target-dir /tmp/gpui-zero-macro-frontier-target
```

## What the prototype establishes

`Decorator::new(value).expose(|value| value as &mut dyn Trait).erase()` uses
the original ordinary trait impl. The projection is an ordinary function
pointer whose output type is `&mut dyn Trait`; Rust checks the impl at the call
site. There is no derived adapter on the data type, no registration attribute,
and no capability handle. The declaration still has to name each trait
projection because stable Rust has no API for enumerating all traits
implemented by a concrete type.

Three storage placements are executable. `Decorated<T>` carries its slots on
each erased value. `Factory<T>::new(...).wrap(value)` registers a reusable
caller-owned schema once and shares it among values. `Schema<T>::register`
models a process-global table keyed by concrete `T`. The caller-owned factory
lets independent call sites define different views for the same type and lets
selectors bind a slot once with `factory.bind::<dyn Trait>()`. The global table
has a first-registration-wins policy for an exact `T`, which couples otherwise
independent call sites and tests.

The correctness tests prove that the borrowed trait object mutates the original
field, a second trait on the same value remains independently selectable, an
inline projection needs no handle, two factories can define separate schemas
for the same concrete type, and an ordinary impl that was not exposed is not
discovered. After erasure, `Any` offers exact concrete downcasts only. It cannot
ask “does this value implement any trait I might name later?”

## API direction

The best zero-macro shape is a typed builder at the erasure boundary:

```rust,ignore
let factory = Factory::new(|schema| {
    schema.expose(|card| card as &mut dyn Focusable);
    schema.expose(|card| card as &mut dyn Titled);
});
let element = factory.wrap(Card { title: "Hello".into(), focused: false });
let focusable = factory.bind::<dyn Focusable>();
```

The builder keeps the concrete `Card` type until each projection is checked,
then shares function pointers and a type-erased payload. `.describe(...)` can
add names or field metadata alongside explicit projections; it cannot discover
ordinary fields or traits by itself. Preserve the inner element's
render/measure/paint behavior through a typed wrapper or retained component
boundary.

## Why other paths do not remove declarations

- A visitor or double-dispatch API changes who calls whom. The erased value
  still needs a type-specific `accept` implementation or a registry entry, so
  it shifts the per-type declaration rather than eliminating it.
- An HList can strongly type a caller-authored collection of capabilities, but
  Rust cannot synthesize that list from arbitrary trait impls. It helps compose
  known exposures; it is not reflection.
- A global schema registry can be initialized once per type, but the registry
  still needs an explicit factory/projection list. Its first-wins rule makes
  independent schemas for the same type conflict.
- Autoref specialization tricks only select methods during compilation where
  the concrete type and candidate traits are already known. A generic helper
  cannot conditionally form a trait object for an unlisted trait, and stable
  Rust has no general specialization facility to enumerate candidate bounds.
- Returning the erased value as `dyn Any` or storing its `TypeId` supports
  concrete downcasting, not trait-object conversion. The conversion requires a
  typed adapter at some boundary.

## Benchmark reading

Two final release runs on this host reported approximately 115–156 ns per
element for per-value exposure, 76–85 ns for factory lookup, and 45–50 ns for a
prebound factory slot. A statically-known direct call was about 0.6 ns. These
numbers only describe this std-only proof; the callback is boxed for every
element and the direct loop optimizes especially well. They show the direction:
resolve schema metadata before walking nodes. Production GPUI must measure its
own selector and lifecycle path before drawing performance conclusions.
