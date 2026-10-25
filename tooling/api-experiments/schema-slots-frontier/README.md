# Late-bound schema slots frontier

A std-only architecture prototype for one immutable `TypeEntry` slot per `TypeId`. `Type` is a one-pointer handle. The entry owns one `OnceLock<Shape>`; first `Type::of<T: Describe>()` invokes the typed schema builder under that lock, so concurrent callers get one canonical shape and cannot leak competing builds. `Type::opaque<T>()` uses the same entry and does not need a later registry lookup for a handle already held by a caller: each `snapshot()` reads the slot directly. Snapshots carry both entry and optional shape identity, because the entry remains the same while its schema changes from absent to present.

`SchemaBuilder<T>` and `FieldDescriptor<T, Field>` carry the root type in Rust's type system. A builder can only accept fields for its own root. `Schema<T>::field` retains that proof, and `RoleRegistration<T>` cannot be reassigned to another root type. Mutable descriptors lend ordinary Rust borrows, so asking for two mutable field borrows from one root is rejected. The experiment keeps no root instances and uses no unsafe code.

`Vec<T>` and `Option<T>` descriptions store a child `Type` handle without forcing its shape. If the child is still opaque, that same child slot later upgrades when `Type::of::<T>()` is called. This avoids first-factory-wins behavior and recursion deadlocks: describe wrapper metadata without recursively requesting child completion. Shape completeness is a separate bit from `Kind`; for example a complete type may have `Kind::Opaque` via `SchemaBuilder::opaque().complete()`.

## Run

```sh
cargo test --manifest-path tooling/api-experiments/schema-slots-frontier/Cargo.toml --target-dir /tmp/schema-slots-frontier-target
tooling/api-experiments/schema-slots-frontier/check_compile_fail.sh
cargo bench --manifest-path tooling/api-experiments/schema-slots-frontier/Cargo.toml --target-dir /tmp/schema-slots-frontier-target --bench slots
```

The tests cover opaque-to-described upgrade, a cached `Vec<T>` child upgrading afterward, recursive wrapper initialization, one build across 24 concurrent callers, typed fields/roles, and snapshot transition identity. Three negative Rust fixtures fail as expected: wrong-root field descriptor, role alias to another root, and two simultaneous mutable borrows.

## Costs and limits

The hot `Type` handle is one pointer; `ShapeSnapshot` is two pointers (entry plus optional shape). Every type identity is stored in a process-global `Mutex<HashMap<TypeId, &'static TypeEntry>>`, and each entry is leaked for process lifetime. Thus acquiring a handle takes a global lock, while resolving a known handle's shape is a slot read. A completed shape currently allocates its field-name slice; each identity allocates one entry and each completed shape allocates at least one object/slice. The small benchmark does not count cold allocations.

On this host, the optimized smoke loop measured **2.33–4.47 ns/op across three smoke runs** for copying a `Type`, reading its snapshot, and inspecting one field-name slice (20 million iterations, 2026-10-08). This is not comparable to production's field-access Criterion benchmarks: it measures slot metadata resolution, not named lookup or value borrowing, and the isolated std-only crate deliberately does not depend on GPUI. No production comparison or allocation count is claimed. A useful decision requires matching operations in the production harness plus a cold-path allocation profile.

The API is deliberately incomplete: it prototypes structural field/root metadata, not production's full reflection/value behavior, enum/sequence APIs, dynamic path/query semantics, role adapters, generated descriptor integration, or a complete `Type::from_parts` bridge. It shows a promising cache and type-proof shape, with a global identity registry and intentional leaks that need measurement and design review before any production adoption.
