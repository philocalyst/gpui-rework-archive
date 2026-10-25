# Module reflection frontier

This experiment tests a module-level declaration as the source of reflection metadata:

```rust
use module_reflection_frontier::Reflect;

#[reflect]
mod view {
    pub struct Counter { pub count: i32, label: String }

    impl Counter {
        pub fn increment(&mut self, by: i32) -> i32 { self.count += by; self.count }
    }
}

let value = Counter { count: 3, label: "ticks".into() };
let fields = Counter::fields();
assert_eq!(*fields.count.get(&value), 3); // inferred as &i32
```

The single attribute scans structs, enums, and impl blocks in the inline module. It emits typed
field handles (`Field<Counter, i32>`), field names, method signatures, implemented-trait names,
enum variant/field records, and a `Reflect`/`ElementSchema` implementation. Generic structs get
generic typed field records; no global cache or per-type registration constants are needed. The
generated descriptor fields inherit the source field visibility, and generated accessors are
lexically inside the module, so same-module code can reflect private fields while downstream code
cannot use those handles.

Method entries are discoverable signature metadata, not callable adapters. Signatures are retained
as strings so generic, async, borrowed, and otherwise non-object-safe methods are not silently
dropped. The macro reports an explicit error at associated constants/types because this prototype
does not model them. An attribute on an inline module can only see impl blocks in that module;
external impls and impls added after expansion are outside its view. Out-of-line modules receive a
direct diagnostic because their contents are unavailable to this attribute expansion.

`ElementSchema` is the automatic schema hook that an `Element` or `RenderOnce` derive could delegate
to. A production integration still needs the derive to call that hook; this prototype keeps the
reflection experiment independent of GPUI production macros.

Run the positive API/runtime checks with:

```sh
CARGO_TARGET_DIR=/tmp/gpui-module-frontier-target cargo test --offline \
  --manifest-path tooling/api-experiments/module-reflection-frontier/Cargo.toml
```

The compile-fail control is expected to fail at the associated type with the macro's diagnostic:

```sh
CARGO_TARGET_DIR=/tmp/gpui-module-frontier-target cargo check --offline \
  --manifest-path tooling/api-experiments/module-reflection-frontier/compile_fail/Cargo.toml
```
