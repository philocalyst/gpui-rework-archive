# Consumer trial

This package keeps API-shape examples isolated from the production crate. It contains six consumer
scenarios in `src/main.rs`: ordinary styled descendants, concrete and generic element queries,
a borrowed custom capability, composed builtin/custom requirements, and the `RenderOnce`
component/rendered-root boundary. `src/bin/concrete_downcast.rs` shows the new public borrowed
concrete downcast and typed `.of::<Type>()` alternatives. `src/bin/repeated_reflects_fail.rs`
retains the old repeated `.reflects(...)` failure. `src/bin/compositions_positive.rs` covers
positive tuple and `.and(...)` compositions.

## Evidence status

The original reflection API trial passed `cargo check` before the typed concrete and capability
projection APIs were introduced. It used `trait_set!`, `#[reflect_trait]`, and `#[derive(Reflect)]`;
its compile-fail probes confirmed that repeated `.reflects(...)` and concrete downcasting from the
then-current `ReflectedElement` were unavailable. Those results are historical evidence only.

The source now explores the current API (`select_mut`, `.of`, `.component`, `.capability`, and
`.and`). The first shared-target check reached the consumer binaries: `concrete_downcast` and
`compositions_positive` compiled with warnings, while `src/main.rs` exposed two consumer-only errors.
Those were fixed. An interim rerun stopped in the concurrently changing production macro crate,
before it compiled the updated main source. After the refactor stabilized, the shared-target check
passed for all default targets; explicit checks of both positive bins passed as well. The gated
negative produced the expected single E0599 at the repeated `.reflects(...)` call.

The positive fixture passed from the repository root with the production macro refactor stable:

```sh
CARGO_TARGET_DIR=/Users/mileswirht/.codex/worktrees/5226/gpui-ce3/target cargo check --manifest-path tooling/api-experiments/consumer_trial/Cargo.toml
CARGO_TARGET_DIR=/Users/mileswirht/.codex/worktrees/5226/gpui-ce3/target cargo check --manifest-path tooling/api-experiments/consumer_trial/Cargo.toml --bin concrete_downcast
```

The legacy repeated-reflects probe is intentionally expected to fail at its first chained call.
Tuple and `.and(...)` positive alternatives each passed explicitly. The shared target commands and
results were:

```sh
CARGO_TARGET_DIR=/Users/mileswirht/.codex/worktrees/5226/gpui-ce3/target cargo check --manifest-path tooling/api-experiments/consumer_trial/Cargo.toml --bin compositions_positive
CARGO_TARGET_DIR=/Users/mileswirht/.codex/worktrees/5226/gpui-ce3/target cargo check --manifest-path tooling/api-experiments/consumer_trial/Cargo.toml --features compile-fail --bin repeated_reflects_fail
```

The successful current-API checks emit dead-code warnings because these fixtures are compile-only.
The GPUI macro crate also reports unused `Ident` and `TraitItemFn` imports from the in-progress
refactor; neither warning blocked compilation.
