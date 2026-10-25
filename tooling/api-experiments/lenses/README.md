# Macro-free capability lens experiment

This package prototypes `Capability<Target, Key>` with no proc macros or generated adapter
tables. A consumer writes one `Lens<Target>` implementation per concrete target/capability pair.
The key's GAT returns a borrowed `dyn Trait` (including fixed associated-type bindings) whose
lifetime is tied to the erased receiver. Generic targets work by spelling the concrete type,
for example `Capability<Wrapper<String>, ValueLens>`.

Run the prototype and its compile-fail borrow check from the repository root:

```sh
cargo test --manifest-path tooling/api-experiments/lenses/Cargo.toml
cargo run --manifest-path tooling/api-experiments/lenses/Cargo.toml --example consumer
cargo run --manifest-path tooling/api-experiments/lenses/Cargo.toml --example registered_consumer
cargo run --release --manifest-path tooling/api-experiments/lenses/Cargo.toml --example bench
```

The timing example compares direct projection, the exact-target `Any` query, and the registered
trait query. It is a smoke benchmark, not a Criterion-quality result.

## Tradeoffs

- Safe borrowed query works because target type and key are compile-time parameters; no trait-object
  fat pointer is stored or reconstructed from erased data.
- The query recognizes one exact concrete type. It does not offer a type-erased “any element that
  implements `dyn Trait`” query or let a selector discover implementors. That requires a registry,
  generated/handwritten erased adapter, or scanning known target registrations.
- This requires one handwritten lens per `(concrete target, trait view)` pair. A blanket impl can
  reduce repetition for generic targets only when the same trait conversion is available uniformly.
- Non-object-safe traits remain usable for membership-only checks, but cannot produce a `dyn Trait`
  view. Generic methods and unconstrained associated types need an object-safe companion trait or a
  membership-only key.
- A tuple of mutable trait-object views is unsafe in general: two trait impls may refer to the same
  object and create aliased `&mut`s. The API intentionally returns one mutable view per borrow. A
  sound multi-view API must encode disjointness in a concrete split lens or expose sequential
  scoped callbacks. Merely composing keys does not establish disjointness.
- GPUI's current `AnyElement` keeps downcasting crate-private. Production adoption would need a
  crate-owned method that runs the typed capability query against its erased receiver; making the
  internal `Any` storage public is unnecessary.

The approach is useful for strongly typed consumer access when the target type is already known.
It is not a replacement for selector reflection, where matching a trait across many erased element
types is the central requirement. A minimal erased registry can still use this lens concept as its
per-concrete adapter implementation, but the registry cannot be eliminated by this API.

## Registered erased capabilities

`src/registry.rs` explores the erased-registry version. A concrete `Schema<E>` stores
`Box<dyn Any + Send + Sync>` adapters keyed by `TypeId::of::<RegistryCapability<Target, Key>>()`.
Each value is `Adapter<Target>`, and its function pointer is monomorphized for `E` and `Key`. The
pointer downcasts `&mut dyn Any` to `&mut E`, then calls `RegistryLens<E, Target>::project`. At
query time the typed key finds the adapter and the code downcasts it to exactly `Adapter<Target>`;
all pointer/lifetime work stays in safe Rust. Schemas are immutable and intended to be memoized
with `LazyLock`/`OnceLock` and shared by `Arc`.

This supports selector-style `has(capability)` across different concrete types: each element's
schema records which handles it supports, and `get(capability)` lends the corresponding `&mut dyn
Trait`. A `Key` type distinguishes two independent lenses with the same trait-object `Target` on
one element. Calls can be interleaved; Rust rejects a second mutable query while the first view is
still live. The tests exercise separate fields through separate keys and the same handle against
two concrete element types.

Associated types work when fixed on the target object, for example
`dyn Labelled<Label = String>`. Generic methods, generic associated types, and unconstrained
associated types remain membership-only unless the consumer defines an object-safe companion trait.
This prototype still has handwritten `RegistryLens` implementations and schema registration per
element type. It removes proc-macro generation, but the adapter table itself remains essential for
runtime discovery. For GPUI, the table should be part of the reflected element schema and built once
per concrete type; `AnyElement` can lend views through an internal method without exposing its
erased storage.
