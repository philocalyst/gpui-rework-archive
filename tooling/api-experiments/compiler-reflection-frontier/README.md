# Compiler reflection frontier

This is an isolated feasibility spike for the upstream nightly `type_info` compiler feature in `nightly-2026-09-30`. It is not part of a GPUI package/workspace and has no user-authored derive, declarative macro, or registration table.

## Confirmed

- `TypeId::fields(0)` reports the compiler's field count at compile time.
- `TypeId::field(0, CONST_INDEX)` returns compiler-generated field name, source index, exact `TypeId`, and layout offset. The test also confirms that this metadata exposes a private field name across the crate boundary. Const generic indices are required: these APIs are marked `rustc_comptime`, so a runtime field index cannot be passed.
- `TypeId::trait_info_of::<dyn Trait>()` succeeds/returns `None` at compile time. Its `TraitImpl::get_vtable()` can be assembled with a data pointer derived directly from `&mut T` into a native `&mut dyn Trait`; the resulting borrow does not outlive the original mutable borrow. The trait query is monomorphization-time compiler discovery, not dynamic lookup after runtime type erasure.

These APIs provide a real no-macro path to compile-time schema discovery and native trait-object vtable selection. However, they do **not** currently give a Rust function enough type-level expressivity to turn an arbitrary reflected field into a typed `&mut F` safely: field type metadata is a `TypeId`, and a runtime `F` cannot be projected from it. A `TypeId`-checked cast would also be unsafe for non-`'static` field types because lifetime parameters are erased. Generic const field indexes help specialize metadata but don't synthesize a Rust type projection.

## Important gaps and hazards

- `Type::of::<Pair>()` ICEs this exact nightly during const evaluation (rustc issue/bug, `rustc-ice-2026-10-07T17_37_48-23714.txt`). The `TypeId` field and trait APIs below work; direct `Type`/`TypeKind` reflection over this ADT does not yet pass this smoke test. `reflect::<T>()` is retained as the direct probe.
- `TypeId` generated through `Type::of` can contain IDs for types that do not outlive `'static`; upstream docs explicitly warn that passing these IDs into `TypeId`-consuming crates can break invariants. Do not erase lifetimes and use such IDs as a safe downcast proof.
- Offset access must not assume every reflected field admits a reference: enum fields may be inactive, union fields may not be initialized, and packed fields can be unaligned. A safe API needs a compiler-verified ADT-kind guard, active-variant tracking, alignment checks, and a sound aliasing model. This spike intentionally exposes metadata only.
- Native trait discovery must stay a compile-time query. A value erased into `dyn Any`/an external `TypeId` does not recover every original trait implementation; the compiler docs also characterize the separate `try_as_dyn` runtime conversion as best-effort with false negatives.
- The feature is unstable, compiler-version-specific, and currently uses `#![feature(type_info, try_as_dyn, ptr_metadata)]`.

## Run

The repo's default `rustc` is Homebrew stable, so explicitly select both nightly compiler tools and keep build output out of the repo:

```sh
CARGO_TARGET_DIR=/tmp/gpui-compiler-reflection-target \
RUSTC=/Users/mileswirht/.rustup/toolchains/nightly-2026-09-30-aarch64-apple-darwin/bin/rustc \
RUSTDOC=/Users/mileswirht/.rustup/toolchains/nightly-2026-09-30-aarch64-apple-darwin/bin/rustdoc \
rustup run nightly-2026-09-30 cargo test --manifest-path tooling/api-experiments/compiler-reflection-frontier/Cargo.toml --lib --tests
```

The runtime field-index restriction fixture can be checked with
`tooling/api-experiments/compiler-reflection-frontier/compile-fail/check.sh`. The release bench uses the compiler-resolved name/offset constants and compares them to identical hand-written literals; it measures equivalent residualized values, not a runtime reflection call.
