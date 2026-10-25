# Element query and reflection API checks

`python3 scripts/check-element-api.py` runs consumer-facing compile contracts for typed element
queries and inherited reflection. The eight positive fixtures are `value_queries`, `value_shapes`,
`tuple_shapes`, `method_handles`, `value_query_positions`, `element_query_api`, `trait_reflection`, and `entity_queries`. These are integration-test
consumers of GPUI's public API; query fixtures exercise headless draw/layout behavior as well as
compile-time types. The runner executes positive fixtures first, then serially asks `cargo rustc`
to compile cfg-gated negative cases. Each negative case must fail with its expected Rust
diagnostic markers. Where rustc versions use different codes for the same type mismatch, the
runner accepts either code and still checks the specific receiver or argument types. It uses Cargo's normal target directory and does not set `RUSTFLAGS`, so cfg
probes do not invalidate all dependencies.

Use `python3 scripts/check-element-api.py --compile-pass-only` to run all positive fixtures without
the compile-fail probes. While iterating on one negative case, use `--skip-positive --case
CASE_NAME`; the runner still compiles that one cfg variant through Cargo. The same commands are
available directly for a single target:

```sh
cargo test --locked -p gpui-ce --test element_query_api --no-default-features --features test-support
cargo rustc --locked -p gpui-ce --test element_query_api --no-default-features --features test-support -- --cfg query_missing_builtin
```

The shape fixtures additionally check imported and generic aliases, recursive containers, cfg fields,
trait-object leaves, canonical concurrent discovery, and partial-to-full upgrades. Tuple cases cover
conditional field positions, empty payloads, and native paths through borrowed generic values.
Method contracts cover colliding lifetime names, independent argument loans, pinned receivers,
higher-ranked function returns, copyable descriptors, and iterator/future returns from temporary
descriptors. Generic return lifetimes such as `Chars<'_>` and borrowed trait objects retain the
receiver lifetime.

The positive fixtures check tuple composition, chained `.and(...)`, mutable reflection, concrete
`.of::<Type>()` projection, authored `RenderOnce` component projection, and two keyed custom
capabilities with a fixed associated type. It mutates the two lenses in an interleaved sequence
and checks each stored value afterward. Its negative cases ensure a reflected view cannot call an
unrequested built-in trait, use an unknown custom token, gain callable methods from
membership-only reflection, escape or alias its mutable borrow, or be cloned into another
mutable alias. Additional macro/type checks reject a capability table bound to the wrong
`Reflect<Self>` receiver, a user trait that falsely claims the built-in `styled` marker, and a
capability key coerced from a `'static` function pointer to a higher-ranked one. A separate
selector target check prevents `Select::of` from changing the exact function-pointer type it
stores as its `TypeId` predicate.
The positive contracts also check a generic element whose lifecycle root, style delegate, and
child delegate have different types. Builder bounds follow the fields providing the behavior,
so the lifecycle root need not implement those builders.
The inherited reflection probes preserve existing guarantees for `Send` bounds, callable-token
visibility, method and associated-type access, schema aliases and identity, parent-schema proofs,
private parents, and rejection of callable traits whose parent is membership-only.
The runner currently checks 32 negative probes: ten for the query/capability API, nine for
inherited reflection, eleven for native value queries, and two for entity-query borrow escape and
aliasing. The value-query probes include wrong-root rejection for field, role, and `Describe`
schemas, plus a private-method access check.

Library regressions additionally verify that manually assembled runtime requirements cannot
weaken the static group's callable-table admission, including before `nth` counts matches.
See [`element-query-performance.md`](element-query-performance.md) for the production dispatch,
selector, and allocation workloads used alongside these contracts.

The focused library and macro lint check is:

```sh
cargo clippy --locked --no-deps -p gpui-ce -p gpui_ce_macros --lib \
  --no-default-features --features test-support -- -D warnings
cargo clippy --locked -p gpui-ce --no-deps --lib --bench selectors --bench reflection \
  --no-default-features --features bench-support,test-support -- -D warnings -A deprecated
```

The benchmark lint command limits linting to GPUI: enabling its benchmark dependencies also
exposes a pre-existing redundant clone at `gpui_ce_parley/src/text_system.rs:1921` in the base
stack. The benchmark configuration also enables existing profiler calls to `Atomic::fetch_update`,
deprecated by the measured nightly. The command allows that deprecation while denying other Rust
and Clippy warnings; it does not certify every dependency against the current nightly's lints.

## How this complements visual and mutation testing

The read-only infrastructure review used the sibling checkout at `/Users/mileswirht/.codex/worktrees/f239/gpui-ce3`: source review through `fdec165b0e`, followed by its final verification and performance documents at `938f29258c`. Its docs describe `Harness::run_all` and `ReportWriter` for application-owned captures and report collection, and `scripts/testing/pseudo_mutation.py` for isolated pseudo-mutation campaigns. The standard-library forge/report checks were rerun with `python3 -m unittest discover -s scripts/testing -p 'test_*.py'`: 58 tests passed and one platform-specific test was skipped.

That review covered the report/viewer sources, forge-adapter checks, and their focused Python tests. The viewer now hides inactive comparison images explicitly and recalculates wipe clipping after image fitting and resize. The Python tests validate report contents, publishing over localhost HTTP, and selected viewer source fragments; they do not execute browser layout or image interactions. This review therefore does not independently establish browser behavior for differing image extents, wipe positions, resize, or actual-pixel mode; those checks belong to the sibling task's browser validation.

For API iteration, run one positive integration target or one `--case` first; the full runner is a broader serial regression pass. The sibling `Harness` workflow can then exercise application-owned rendering at deterministic simulated times and save reports through `ReportWriter`, while pseudo-mutation campaigns test whether runtime assertions catch deliberate regressions. These serve different layers: compile contracts do not render a visual report, and the report workflow does not prove compile-time rejection. The Python forge/report tests cover report contents and localhost publishing; source-fragment assertions do not execute browser layout or image interactions, so they do not certify viewer behavior.

The final native API pass on October 8 ran 452 library tests, 32 consumer integration tests across eight fixtures, and 28 macro unit tests. All 32 rejection probes passed. The isolated discovery audit additionally runs copied runtime tests and production shape fixtures without rebuilding GPUI’s platform dependencies; use it for macro experiments, then rerun the public contracts before accepting a change.

The selector benchmark's `--allocations` command runs the warmed fixtures through Criterion
test mode, preserving callback/layout/paint assertions without profiling calibration on every
case. Timing runs continue to use the requested warmup and sample settings.
