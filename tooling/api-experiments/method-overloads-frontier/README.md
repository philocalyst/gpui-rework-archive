# Native method overload frontier

This isolated harness compiles the production module reflection macro and imports the runtime from `crates/gpui/src/reflection/value.rs`. It does not build the GPUI workspace. `sync-production.sh` copies current macro sources before every run.

The smoke test exercises a single idiomatic `.methods().same.call(...)` field across concrete specialized impls with different return types, cfg alternatives where only the second alternative is enabled, generic self types such as `Shaped<Vec<U>>`, and reordered generic self types such as `Pair<Y, X>`. Existing reflection shape and trait-role coverage is retained as a regression baseline.

Run with a separate target directory:

```sh
CARGO_TARGET_DIR=/tmp/method-overloads-frontier-target ./tooling/api-experiments/method-overloads-frontier/check.sh
```
