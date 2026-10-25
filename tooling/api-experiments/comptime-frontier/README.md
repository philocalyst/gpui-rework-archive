# Comptime frontier

This is a small, isolated API experiment for “one opt-in, then inspect values” in Rust. The user surface is one attribute on an inline module and ordinary typed structs and impls:

```rust
use frontier_reflect::{reflect_module, view, Value};

#[reflect_module]
mod elements {
    pub struct Panel { pub opacity: f32, pub child: Child }
    pub struct Child { pub id: u32 }
    impl Panel { pub fn reset(&mut self) { self.opacity = 1.0; } }
}

let mut panel = elements::Panel { opacity: 0.4, child: elements::Child { id: 7 } };
let mut panel = view(&mut panel);
assert!(panel.set("opacity", Value::F32(0.8)));
assert!(panel.call("reset"));
let Value::Borrowed(child) = panel.get("child").unwrap() else { unreachable!() };
assert_eq!(child.downcast_ref::<elements::Child>().unwrap().id, 7);
```

The module attribute sees all inline structs and inherent impls together. It synthesizes a static self-describing `Type` for each struct, native typed field accessors for scalar fields, borrowed access to nested values, and invokers for public zero-argument `&mut self` methods. There are no per-type derives, trait-set declarations, or accessor constants. User-visible field and method names are strings because Rust cannot currently project a struct field selected by a string at the type level.

This is an executable shape prototype, not a polished general reflection system. It supports named fields of `'static` types and a small `Value` set (`f32`, `u32`, `bool`); nested fields can be borrowed and downcast. It only collects inherent methods with exactly `&mut self`, no arguments, and no return value. The attribute needs an inline module and sees syntax rather than resolved types, so it does not automatically join impls from other modules, resolve aliases, support generic structs, or discover trait methods. The macro crate uses `syn` and `quote`; the runtime API itself uses only `std`.

## What the neighboring models imply

Zig's advantage is semantic and compiler-level: [`@typeInfo(T)`](https://ziglang.org/documentation/master/#typeInfo) returns a tagged type description, `inline for` unrolls compile-time iteration, and [`@field(value, field.name)`](https://ziglang.org/documentation/master/#field) makes the reflection result usable for actual typed field access. The primary [Zig language reference](https://ziglang.org/documentation/master/#comptime) describes compile-time evaluation. This experiment approximates the result by having a single module macro generate ordinary typed closures. It cannot reproduce Zig's arbitrary compile-time computation or compiler-known dynamic field projection.

[Crabtime's documentation](https://docs.rs/crabtime/latest/crabtime/) describes a different tradeoff: it executes Rust code in a temporary compiled project and turns stdout into macro output. That gives a natural Rust-like metaprogramming language, but its macro sees source/inputs rather than Rust's fully resolved semantic type graph, and each expansion incurs a compilation/evaluation pipeline. It is useful for generation, but it does not itself make `TypeId` reveal struct fields.

Rust's [procedural macro reference](https://doc.rust-lang.org/reference/procedural-macros.html) confirms attribute macros operate on syntax token streams and replace the attributed item. A module-level attribute is therefore a practical single-opt-in way to batch inspect all declarations in an inline module, but still not compiler reflection. The stable [const-evaluation rules](https://doc.rust-lang.org/reference/const_eval.html) only permit a defined subset of expressions in const contexts, which is why ordinary `const fn` cannot substitute for Zig-style arbitrary comptime execution.

Zed's official [Rust support documentation](https://zed.dev/docs/languages/rust) describes its editor and rust-analyzer integration; it does not document a Zed-specific comptime facility. “Zig comptime” is the closest documented language model for the requested experience.

## Native nightly frontier

The installed `nightly-2026-09-30` source tree has a compiler reflection MVP in `core::mem::type_info` (`#![feature(type_info)]`, tracking issue 146922). `TypeId::of::<T>().fields(variant)` and `.field(variant, index)` expose field count, source name, exact field `TypeId`, and compiler offset in comptime-only operations. `TypeId::trait_info_of::<dyn Trait>()` returns the compiler's vtable for concrete implementations. Together, those are a plausible base for a single native `Value`/`Type` API with no registration, module attribute, per-type macro, or capability constants: construct a value view from the concrete type, walk compiler field metadata, and synthesize typed trait-object views from trait-info vtables.

That native path is much closer to Zig's semantics than this macro prototype. The remaining hard boundary is dynamic access: the field API reports offsets and types, so a general runtime view would need carefully encapsulated pointer arithmetic and valid trait-object metadata. The current type-info MVP exposes no inherent method list; trait vtables can provide a constrained route for method calls if the user-defined trait is the dispatch surface. The compiler-reflection prototype is separately owned by the parent task to avoid overlapping experiments.

This is a nightly-only, unstable MVP under [tracking issue #146922](https://github.com/rust-lang/rust/issues/146922), which still lists the RFC and design questions as open. Its in-tree docs warn that the no-`'static` `Type::of` path yields `TypeId`s whose use can violate assumptions in other crates. A later [soundness report](https://github.com/rust-lang/rust/issues/161493) specifically discusses lifetime confusion through that path and the dynamic trait-TypeId lookup. The safe exploration should stay within `'static` types and statically typed `trait_info_of::<dyn Trait>()`; avoid `Type::of` on lifetime-bearing types and `trait_info_of_trait_type_id` until the compiler team resolves that design.

## Run

```sh
CARGO_TARGET_DIR=/tmp/gpui-comptime-frontier-target \
  cargo run --manifest-path tooling/api-experiments/comptime-frontier/Cargo.toml \
  --release -p frontier-consumer
```

The release executable contains assertions for scalar reads/writes, nested field access, public method invocation, and private-method exclusion.
