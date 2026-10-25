# Value/Type shape frontier

This is a std-only prototype of a reflection-style value API over heterogeneous erased values. It is isolated from the GPUI workspace and does not depend on GPUI Cargo targets.

Run the positive behavior suite, the expected compile failures, and the release smoke benchmark with:

```sh
cargo test --manifest-path tooling/api-experiments/value-shape-frontier/Cargo.toml --target-dir /tmp/gpui-value-shape-frontier-target
tooling/api-experiments/value-shape-frontier/check_compile_fail.sh
cargo run --release --manifest-path tooling/api-experiments/value-shape-frontier/Cargo.toml --target-dir /tmp/gpui-value-shape-frontier-target --bin bench
```

## Shape and path surface

A type opts in once by providing a `ValueShape::schema()` constant. The schema describes fields, nested types, enum variants, and container contents. This prototype writes that provider and its `Card::fields()` bundle by hand; a focused aggregate attribute or a compiler-supplied provider could generate them without changing the `Shape`, `DynValue`, `Path`, or `Query` protocols.

```rust
let payload_text = Card::fields().payload.then(Payload::fields().text);
assert_eq!(payload_text.get(&card), "before");

query::<Card>()
    .where_field(Card::fields().id, 7)
    .edit(erased.as_mut(), |id| *id += 1);

let mut value = DynValue::new(&mut card);
let mut text = value.field("payload")?.field("text")?;
*text.downcast_mut::<String>()? = "after".into();
```

Typed `Path<Root, Leaf>` stores direct getter function pointers, so the Rust type system carries both endpoints without `PhantomData`. `.then(...)` composes paths and keeps the intermediate type checked. `VariantPath<Root, Leaf>` provides a checked `Option` projection for fields that exist only on one enum variant. `MethodPath<Root, Args, Output>` provides the same typed endpoint discipline for callable methods. `FieldQuery::edit` downcasts the heterogeneous root by exact Rust type, tests the selected typed field, and lends only the field to the edit closure.

Dynamic access starts from `DynValue`, a borrow of a concrete value plus its static schema. Names resolve to fields; indices resolve into `Vec<T>` and `Option<T>`; enum schemas report the active variant and omit fields for inactive variants. `walk_mut` visits one borrowed node at a time. Holding a child borrow prevents asking its parent for another mutable child, and no pointer or borrow is retained in the schema.

Schemas use typed safe getter functions. No field offset, `transmute`, or unsafe code is used. `TypeId` plus `Shape::accepts` validates erased roots. The same protocol can be backed by stable generated metadata or experimental compiler field metadata, with the source of field descriptors kept outside consumer selectors.

## Evidence and limits

Six unit tests pass. The three rustc-negative fixtures are rejected with the expected diagnostics: E0499 for simultaneous mutable child borrows, E0308 for a typed path applied to the wrong root type, and E0515 for a dynamic child borrow escaping its parent. Inspect `compile_fail/src/bin/` to see each case.

One optimized smoke run on this host (2026-10-07, 2,000,000 iterations, reused row, identical checksums) three repeat runs ranged from **0.42–1.52 ns/op** for a typed path and **326.98–406.42 ns/op** for erased named-field lookup. A preceding run measured 0.42 ns/op and 244.42 ns/op, showing substantial noise at this scale. This is intentionally a tiny microbenchmark, not a stable performance estimate: the dynamic side checks an erased root and linearly resolves the field name through the schema. A production implementation would likely bind the name to a field handle once, and needs framework-level benchmarks before making a performance decision.

The design removes the need for per-capability registration and selector macros when the job is structural data access. It does not dynamically call arbitrary methods by name: methods remain typed `MethodPath`s. A safe erased method registry needs the method's argument, output, and borrowing contract in its schema; arbitrary trait implementations cannot be discovered from a type-level field schema alone. This experiment makes that boundary explicit instead of turning fields into trait behavior.
