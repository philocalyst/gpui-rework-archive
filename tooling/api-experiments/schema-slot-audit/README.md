# Schema slot audit

This isolated crate imports the current production value module directly from `crates/gpui/src/reflection/value.rs` by path and uses the same `inventory` crate version as GPUI. It also retains the earlier standalone prototype's concurrency tests. It does not build GPUI or edit production code.

Run the stress tests and release comparison with:

```sh
cargo test --manifest-path tooling/api-experiments/schema-slot-audit/Cargo.toml --target-dir /tmp/schema-slot-audit-target
sh tooling/api-experiments/schema-slot-audit/check_compile_fail.sh
cargo bench --manifest-path tooling/api-experiments/schema-slot-audit/Cargo.toml --target-dir /tmp/schema-slot-audit-target --bench discovery_allocations
```

The tests cover 64 simultaneous first callers, concurrent inventory discovery, old opaque handles upgraded through an inventory factory cached as a parent field, recursive inventory and provided-child resolution, opaque readers racing a describe call, retry after a panicking initializer, and a subprocess reproducer that confirms same-slot recursion stalls in `OnceLock::get_or_init` (the parent kills the child after 500 ms). Production's current value module tests also run because the source module is included directly. Compile-fail fixtures verify that a field or role registration for root `A` cannot be used to build a schema for `B`, and that typed field handles reject overlapping mutable borrows.

## Findings

Discovery has two factory paths. `Type::provide` stores a type's factory on its canonical slot without calling it. If no provider has supplied a factory, `Type::discover` lazily builds the inventory map of `TypeId` to factory and invokes the matching factory. The map stores function pointers; building it does not invoke a schema factory. Once invoked, `T::type_shape` publishes into the same slot, so previously held opaque handles and parent field descriptors observe the new shape.

The main correctness risk remains recursive initialization. Calling `Type::of::<Self>()` or `Type::discover::<Self>()` from inside that type's `build_type` can re-enter the same `OnceLock` and stall. The subprocess timeout test reproduces direct re-entry. The production recursive inventory test follows the generated path: the inventory factory starts root initialization, `ProvideShape` stores root and child factories only, and later sequence indexing resolves them after the root shape is published. It completes with one build. Panic recovery remains sound: a failed `OnceLock` initializer leaves the slot empty so a later caller can retry.

The inventory child test starts with an opaque handle, publishes a parent whose child factory uses `Type::discover`, and resolves the parent's field metadata. The field triggers the inventory factory exactly once; both the parent-cached child handle and the old opaque handle then report the described shape. A separate 32-thread test repeatedly discovers one inventory-backed type and observes exactly one `build_type` call.

## Allocation profile

The release harness imports the current production `value.rs` source and profiles allocation counts for first and repeated `Type::discover`, plus lazy provided sequence and child resolution. One run reported:

```text
first inventory discovery allocations:                 3 (old handle upgraded: true)
warm inventory discovery allocations:                 0 / 100000
first provided sequence and child resolution:          4
warm reflected field+index allocations:                0 / 100000
```

The first inventory total includes the linked factory map and schema initialization for this fixture. The warm samples show no per-call allocations after resolution. This harness makes no timing or prototype-versus-production performance claim.
