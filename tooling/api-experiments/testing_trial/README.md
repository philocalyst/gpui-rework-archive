# Reflection and selector API trial

This isolated integration test exercises the public typed reflection and selector API from a
consumer crate. It is useful as a quick API-shape check while changing the reflection or selector
surface, without adding a test to `gpui`'s internal selector module.

The package enables GPUI's `test-support` feature so an external integration target can use
`TestAppContext` and `#[gpui::test]`. The test imports the public `SelectableElement`,
`ParentElement`, `InteractiveElement`, and `IntoElement` traits, renders a selected child, and
asserts its laid-out width after the borrowed `Styled` callback changes it.

Run just this test from the repository root:

```sh
CARGO_TARGET_DIR=/Users/mileswirht/.codex/worktrees/5226/gpui-ce3/target \
  cargo test --manifest-path tooling/api-experiments/testing_trial/Cargo.toml --test reflection_selector
```

The command passed on 2026-10-07: one integration test passed, including the headless render and
layout assertion.

For a production-like timing baseline, use the existing focused in-crate tests:

```sh
cargo test --locked -p gpui-ce --lib reflection::tests::forwards_methods_and_owned_builders_through_inherited_groups
cargo test --locked -p gpui-ce --lib selectors::tests::combines_class_conditions_with_scalar_ids
```

The reflection and selector Criterion benches require a longer optimized run and are intended for
performance measurement rather than per-edit feedback:

```sh
cargo bench -p gpui-ce --features bench-support --bench reflection
cargo bench -p gpui-ce --features bench-support --bench selectors
```
