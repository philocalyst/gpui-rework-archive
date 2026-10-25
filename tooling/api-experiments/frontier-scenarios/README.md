# Frontier consumer scenarios

This package is an intentionally broad consumer-side compile fixture for the current typed
reflection and selector API. It concentrates on cases that are awkward to cover with the
ordinary `Styled`/custom trait examples: GAT membership, distinct lenses with the same trait
object target, generic reflected elements, captured theme state, one-shot components, extension
builders, and diamond supertraits.

From the repository root, the parent task should run:

```sh
cargo check --manifest-path tooling/api-experiments/frontier-scenarios/Cargo.toml --example frontier
cargo run --manifest-path tooling/api-experiments/frontier-scenarios/Cargo.toml --example frontier
```

The current API's shape is visible in the code: associated types and GATs can be registered for
membership, while callable reflection needs an object-safe trait view; keyed `Capability` handles
provide two projections to the same trait object; `Select::component` edits a `RenderOnce` value
before it is consumed; and a normal extension trait can package a theme callback. The diamond case
checks whether common ancestor methods are usable from a selector requiring the leaf trait.

No production API changes are made in this experiment directory.

## Validation

Both commands passed against the current checkout with `CARGO_TARGET_DIR` pointing at the
repository's `target` directory. `main` performs runtime assertions through `Capability::get_mut`
for both keyed fields, a generic `GenericNote<String>`, and a captured theme applied through its
capability. The selector callback examples compile without opening a window; their mutations run
when GPUI lays out a tree, so those remain compile-time scenarios here.
