# Reflection discovery macro/runtime audit

This isolated crate copies the current GPUI reflection value runtime and `reflect_module` proc macro. It depends on the workspace-compatible `inventory = 0.3` version and uses a Cargo target in `/tmp`; it does not build the GPUI workspace.

Run it with:

```sh
cargo test --manifest-path tooling/api-experiments/discovery-macro-audit/Cargo.toml --target-dir /tmp/discovery-macro-audit-target
```

The current-source run passes 15 copied runtime unit tests, 29 integration cases, and one compile-fail doctest. Four tuple cases additionally cover cfg-removed first/middle/last fields, cfg_attr, empty payloads, mutable borrows, and borrowed generic tuples. The discovery cases cover std containers and aliases; same-named user container types; external and generic aliases; qself associated types; bare `Value::new` for nested Vec/Option and `Vec<String>`/`Option<u32>`; generic roots with nested wrappers; inventory discovery; partial containers and partial-to-full child-handle upgrades; recursive and mutually recursive structs; cfg-selected same-name aliases with an inactive alias to a missing type; private fields and a named `field_0`; lifetime binders, trait-object references, and `Box<dyn Trait>`; and concurrent discovery.

## Design observations

- Complete `Describe` impls for std wrappers require `T: Describe`; hidden sealed partial impls use `T: Any` and lazy `Type::discover::<T>` child factories.
- At field sites the macro probes the actual concrete type for complete `Describe`, then partial container support, then linked/opaque discovery. Its syntax walker only gathers visible type arguments to seed lazy factories; it does not expand aliases or infer container kind from names.
- `Describe::prepare_children` defaults to a no-op. Std wrappers force their child’s `type_shape()` before their own schema is published. Generated user schemas must keep the default so recursive `Box<Node>` graphs terminate.
- `TypeSnapshot` records the canonical slot and current shape pointer. The runtime test verifies a cached opaque child snapshot changes after a later `Describe` publication; a separate integration case verifies old partial child handles observe full metadata after `Type::of::<Vec<Item>>()`.

The tests confirm actual std containers and aliases are recognized regardless of spelling; same-named user types remain structs. External and generic aliases and qself associated types resolve through full child preparation. Partial containers retain their category around an opaque leaf, while `Box<dyn Trait>` remains opaque because sequence access currently requires sized `Any` children.

## Limits and risks

Unbounded generic children cannot receive full structural metadata unless a linked monomorphic registration exists or explicit `Type::of::<T>()` is called later. Partial containers preserve the wrapper kind while leaving such children opaque. Arbitrary third-party containers are not structurally classified automatically.

Preparation adds one cached `OnceLock` check per `Type::of` call and eagerly initializes fully described std-wrapper chains once. This correctness run does not quantify latency or allocations. Deeply nested wrappers increase cold initialization stack depth. Duplicate inventory registrations are safe for the current typed constructor because all entries for one concrete type resolve the same coherent `Describe` impl.

The final macro cleanup separates tuple-pattern generation from field descriptors and shares cfg-presence parsing with method generation. Ordinary tuples emit direct native getters; only conditional tuples require the cfg ladder. The copied sources were refreshed from production and the 15 unit tests, 29 integration tests, and compile-fail doctest passed again on October 8.

The harness also compiles the production `value_shapes` fixture, including unrelated local traits called `View`, `Element`, and `RenderOnce`, and a foreign trait imported under one of those names. Subject-hook import resolution is tested separately with `cargo test --manifest-path tooling/api-experiments/discovery-macro-audit/Cargo.toml -p discovery-macro-audit-macros --lib --target-dir /tmp/discovery-macro-audit-target`.

The final subject-import resolver has seven passing unit tests, including identity `self` imports, reversed alias chains, foreign aliases to `gpui`, conflicts, cfg ambiguity, and cycle rejection. Foreign inherent impls with the same final type name and foreign role aliases with a local namesake are covered by the production shape fixture.


## Native method lifetime audit

Fresh Luna reproductions exposed generated lifetime-name collisions, accidental receiver capture
inside returned function signatures, and artificial borrows of temporary descriptors by RPIT and
async returns. The production fix uses fresh lifetime binders, keeps nested `fn`/`Fn` elision
independent, binds explicit `'_` return lifetimes to the native receiver, and makes method
handles copyable values. The current audit passes three method tests plus one focused generic
return test alongside the discovery and tuple cases. The async case polls its future to completion.

The attribute still needs lifetime arguments written in method return types, such as `Chars<'_>`.
Native Rust accepts omitted `Chars` with a lifetime-style warning, but syntax alone cannot recover
an external type's missing lifetime arguments for a wrapper with multiple input lifetimes. That
case was reproduced with E0106 and remains a documented source-syntax limitation; the positive
fixtures use explicit arguments. This is separate from native callbacks, which have no generated
signature and use the original Rust method directly.

The bounded-type regression additionally verifies source `where` clauses survive on generated
field, variant, aggregate-method, and individual method descriptors for named structs, tuple
structs, and enums. The public `method_handles` fixture covers these bounds together with the
native lifetime regressions.
