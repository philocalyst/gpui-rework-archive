# Native select inference experiment

This standalone, std-only crate tests whether `select` can mean “lend the matched native target to a callback” while the existing `select_mut` remains the erased-element escape hatch. It does not edit GPUI production code.

Run the positive tests, compile-fail probes, and release smoke benchmark with an isolated target directory:

```sh
CARGO_TARGET_DIR=/tmp/native-select-inference-target cargo test --manifest-path tooling/api-experiments/native-select-inference/Cargo.toml
CARGO_TARGET_DIR=/tmp/native-select-inference-target sh tooling/api-experiments/native-select-inference/check-compile-fail.sh
CARGO_TARGET_DIR=/tmp/native-select-inference-target cargo run --release --manifest-path tooling/api-experiments/native-select-inference/Cargo.toml
```

## Inference that compiles

The core candidate is one generic method. The closure's higher-ranked mutable reference is a loan scoped to each callback call, and its explicit parameter type determines `T`:

```rust
fn select<T: ?Sized + 'static, S, F>(&mut self, selector: S, callback: F)
where
    S: NativeSelector<T>,
    F: for<'a> FnMut(&'a mut T) -> (),
{ /* visit matches and call selector.project(node) */ }

root.select(Select::descendants().class("card"), |card: &mut Card| {
    card.count += 1;
});
```

For a structural selector, the class is runtime data and carries no type information, so the callback needs the annotation. `|card|` fails with E0282. That is the one unavoidable annotation in the requested expression; no `.of::<Card>()` or `.component::<Card>()` is needed.

A selector that itself carries a typed projection supplies enough information to infer the callback argument, including its field value type:

```rust
root.select(
    Select::descendants().class("card").field(Card::fields().title),
    |title| title.push('!'), // inferred as &mut String
);
```

`FieldSelect<Parent, Value>` implements `NativeSelector<Value>` only for its declared value type. A native role/capability selector can use the same mechanism and carry a generated/registered projection adapter; the experiment's `RoleSelect<dyn Titled>` proves inference for an unsized trait-object target too. An actual GPUI selector should reuse its capability table/adapters rather than add a second reflection system.

The model stores raw elements and a `ViewElement<Card>` authored-component wrapper in `Any`. `Select` checks the concrete value and then the pending authored view, so the same typed callback sees either representation before render. This is ordinary checked `Any::downcast_mut`, not layout casting. In production, component selection should route through `ViewElement<T>::pending_view_mut()` (or the current equivalent) and preserve the current wrapper-versus-rendered-root boundary.

## Safety and negative probes

`select_mut` stays the broad escape hatch. This std-only sketch uses `for<'a> FnMut(&'a mut dyn Any)` as its erased stand-in; production should preserve the existing reflected `ReflectedElement<Group>` lending signature. The typed method accepts no callback result, and its HRTB forbids safe code from retaining a matched borrow. `Root` keeps one exclusive borrow over its storage while visiting; trying to recursively call `root.select` from its callback is rejected by E0499. The `alias` and `escape` fixtures test those boundaries.

The typed closure is not a static proof that a runtime class contains a `Card`: the tree is heterogeneous and selector class matching is runtime-only. A wrong concrete target or a field selector whose `Parent` is absent safely fails its `Any` projection and skips the callback. The `wrong-root` behavior is covered by the unit test named `type_or_parent_mismatch_is_a_safe_non_match`; it cannot be a compile-time error without branding every root/query with a statically known shape. A wrong field *type* is rejected at compile time (`wrong-field`), because the field selector fixes `Value`.

The plain selector with an untyped closure is also an expected compile failure (`untyped`). The typed field and role selectors do infer an untyped closure parameter because their selector type has a unique target. All compile-fail cases are independent tiny consumer crates and are expected to fail compilation.

## Projection timing

The optimized executable compares a direct `&mut Card` callback projection with one `Any::downcast_mut::<Card>()` per iteration over 30 million iterations. This is only a smoke benchmark: it excludes tree traversal, element metadata, wrappers, selector matching, and adapter dispatch; single-run timings move with the host. A sample run on 2026-10-07 reported direct 10.41 ns/iteration and `Any` 19.66 ns/iteration (1.89x). Earlier runs reported 10.86/13.84 ns and 10.49/21.94 ns, so the ratio is too noisy to support a performance conclusion. It does show that the safe `Any` path compiles and runs; use the production Criterion benchmarks to judge any real overhead.

## Recommendation

Adopt the single `select<T, S, F>` shape if it matches the production `AnyElement` and component projection paths. Keep callback type annotations required only for untyped structural selectors; typed field/capability selectors infer from their target. Keep `select_mut` for low-level erased access. Do not add root branding based only on this prototype: it would add API type plumbing without proving runtime class membership in a heterogeneous tree. The experiment does not establish query/selector API naming beyond the tested signatures.
