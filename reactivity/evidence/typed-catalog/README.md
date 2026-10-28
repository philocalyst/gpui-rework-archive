# Typed catalog and inspector evidence

Frozen source layers, in order:

- `8ea8b9d76a`: production baseline.
- `9604f10c3f`: baseline instrumentation only; production unchanged.
- `ba48a22b90`: two independent component libraries and one/two-model client fixtures. No production edits. The future catalog acceptance test is intentionally uncompiled by the baseline bin build.
- `e51355fef4`: catalog facade and shared transaction; independently reviewable.
- `07a0698759`: expanded inspector and public behavior coverage.
- `579e956f30`: chosen-channel caption correction and actual native action/pixel oracle; final source under test.

The evidence commit adds no shipping source. All these controls precede main's separate lazy framebuffer constructor `83aab2dc88`; do not attribute that later memory reduction to this catalog.

## API and authority

`Win::property_value`, `property_contribution`, and `set_property_value` expose the existing immutable schema through `PropertyId` and `Contribution<PropertyValue>`. Destination comes from the declaration, not ValueKind. CornerRadius is Number with Geometry destination. Validation, authoring equality, impact, presence, source masking, and Set/Inherit remain the existing declaration/override transaction. Typed selectors are ordinary APIs and now have small fronts into the same transaction. No generated 13-way typed-setter dispatch or new metadata registry.

PropertyId, ValueKind, and PropertyValue are non-exhaustive tool boundaries. An unknown future family can be a read-only unsupported row (the external client demonstrates wildcard handling). IDs are not a serialized/persisted schema promise. There is no new serde format.

Actions carry compact property ID and operation tags; values are read and validated at admission. The inspector retains one selected property/component, not PropertyValue in each Handler. Its P geometry captions remain tied to prepared/acknowledged geometry, while logical property edits can survive failed preparation. Stale targets/control IDs are rejected through the same route as ordinary actions.

## Exact memory ledger (x86_64 Linux)

| Item | Baseline | Facade | Final panel |
|---|---:|---:|---:|
| PropertyInfo |24|24|24|
| PropertyValue / Contribution<PropertyValue>|28 /28|28 /28|28 /28|
| Declaration /13 catalog reference slots|56 /104|56 /104|56 /104|
| El /Handler /Node|176 /16 /40|176 /16 /40|176 /16 /40|
| Style /Presented /Admission|88 /80 /16|88 /80 /16|88 /80 /16|
| Runtime<Empty>, default features|1888|1888|1888|
| Metadata /Inspector|264 /24|264 /24|264 /24|
| InspectorAction /WindowAction|1 /1|1 /1|4 /4|
| Tool node count|17|17|28|
| Plain retained allocations /requested bytes|22 /1,797,636|22 /1,797,636|22 /1,797,636|
| Tool retained allocations /requested bytes|180 /1,844,392|180 /1,844,392|251 /1,856,862|
| Warm 100 unchanged tool resizes allocations /bytes|0 /0|0 /0|0 /0|

Static declarations remain 13*56 +104 =832 bytes. No per-node/header/static registry growth. Panel expansion costs +71 retained allocations/+12,470 requested retained bytes relative to the original panel, including fonts, shaping, layout and raster resources. The selected editor uses five replaced existing boxed window routes when choosing a property; this is opt-in tool work. Source-independent idle does no allocation. Measurements include the eager 1,792,000-byte headless framebuffer present on the matched base. Root separately owns frozen pre/post-83aab executable captures.

## Linked external clients

Both independent library crates expose their own typed appearance vocabulary and caller-supplied behavior. One uses radius and the other gap; caller sources lower through ordinary IntoProp. The executable workload is byte-identical across baseline and facade (`src/lib.rs`, both bins and library sources). Baseline source ba48 and facade e513 were built offline/locked, default GPUI features, release with debug=1. Raw section tables and compressed complete symbol lists are retained. Immutable binaries are at `/tmp/gpui-typed-catalog-evidence/{baseline,facade}/binaries`; their SHA256 records are committed, not the large binaries.

| Client | Baseline .text | Facade .text | Final panel .text | Final change |
|---|---:|---:|---:|---:|
| one external model |3,714,695|3,684,231|3,691,127|-23,568|
| two external models|3,852,343|3,805,463|3,813,751|-38,592|

Final panel costs +6,896/+8,288 linked text bytes relative to facade alone, even in these plain clients; header/heap costs remain unchanged. Outputs remain `13` and `13,13`. Baseline nm shows eight typed style-setter instantiations plus geometry per model (not literally 13, since Rust T is shared). Candidate uses one 3,665-byte shared ID core per model and smaller typed fronts. This is a linked-code result, not a runtime throughput claim. The first baseline build included dependencies while the facade build reused them: build elapsed logs are preserved but are NOT a valid compile-time comparison.

## Source ledger

Official counter: six first-party shipping libraries, including shipping build.rs and excluding tests/comments/blanks/docs/examples/labs/tools/evidence/vendor. It reads Git objects using an explicit commit, not worktree HEAD.

- Base:27,696 non-test code lines.
- Facade e513:27,782 (+86).
- Initial panel07a:27,992 (+210 from facade, inspector191 +shared Runtime readers19).
- Final579:28,017 (+321 from base; inspector216 +Runtime readers19 over facade). The chosen-channel fix adds25 lines and exceeds the original200-line inspector estimate by16; this is explicitly charged.
- External fixture non-test Rust:108 lines: two reusable library crates30, client model/workload61, executable fronts17. Their two library manifests add12 TOML lines. No new executable evidence/tool source outside this fixture.

## Coverage and controls

Seven schema tests cover the declarations and exact authoring/presence rules. Five external-library tests cover all13 ID rows, Number-to-Geometry dispatch, wrong kind/range/NaN/infinity atomic rejection, explicit Auto vs Inherit, equal-default presence, source changes under Set then latest value after Inherit, caller behavior, foreign-window/stale target rejection, and failed preparation logical/P separation. Existing typed compile-fail API tests remain in GPUI; the new external fixture does not claim an additional borrow compiler test.

Final579 gates:468 passed/25 ignored in66 x11 all-target test binaries, strict x11 all-target Clippy with `-D warnings`, five external tests, two default header/topology tests, 24 docs (including23 compile-fail), and the actual native test (4.47s). Native executable SHA256:`1d58a2e0a1485d0fdb48a95071d7cf92a4c37a7aa03ea50a3a70d097a6f2fe1a`; default header executable SHA256:`d8a374e0027ff78d3765f45d5b1286c6cdffeacf680bc069938645db519fff91`. Test-build-only existing unused example-function warnings appear in the raw x11 test log; strict Clippy passed. No Apple/MSVC candidate compile or runtime claim is made in this slice.

The14 ordinary inspector tests cover all13 chosen properties Set/Inherit; six transform components; every component in all five author color spaces; exact selected-channel captions; negative/alpha invalid-step feedback with unchanged source epoch and recovery; unchanged owner descriptions; pending-frame hit admission; and acknowledged geometry captions. Rejection feedback uses the canonical error kind. There is no copied property range/default table, and color constraints remain Color constructors.

The ignored native ReferenceCpu X11 test uses a real server window, real pointer press/release and scroll/ACK routing. It checks width Set/Inherit, sRGB channel pixels, rounded-corner pixels, translation pixels, rejected negative step feedback/recovery, stale-P pick rejection and later re-pick, with zero owner reruns/descriptions. Final logs/digests qualify the exact source; no foreign-platform runtime claim is made.

Earlier failing logs are kept: the initial public helper selected both title and scroll-root by the same name, producing AmbiguousElement; the corrected helper qualifies Role::ScrollView. Early rejection handling incorrectly propagated canonical validation to NativeHost; the final UI records compact feedback before writer admission. Those logs are controls, not candidate passes.

## Limits and next ownership seam

This panel has explicit step/cycle controls and component selection. It does not implement arbitrary numeric/color/transform text entry or pretend step buttons do so. Rich entry remains a delivery followup.

Current Component<P,C> projects from P, but inspector state lives outside app M in cold Metadata. A private WindowModel<M> can relocate the existing Metadata pointer without adding a pointer/header, but app Handler admission still requires Sources<M>/Any and cannot consume Sources<WindowModel<M>> without a source-adapter change. Automatically wrapping every app in a component would introduce ordinary-owner schema allocation. A reusable contained-owner source/admission adapter must retain app Sources<M> and opt-in tool Sources<T>, borrowing each owner into the same write/freeze/reconcile algorithm with explicit scopes/lifetimes; its cold costs and unified handler admission need a separate reviewed design. No inspector-only FieldId namespace or writer bypass was added.

## Commands

Environment: `/tmp/gpui-native-env.sh`, rustc1.97.1 (8bab26f4f), Cargo1.97.1, x86_64-unknown-linux-gnu, CARGO_BUILD_JOBS=2, CARGO_TARGET_DIR=/tmp/gpui-typed-catalog-target. Frozen Cargo.lock SHA256:4abbb04f9573a2e942f464c221ec02a9194928109a79f0f870dcdb16e9391780; GPUI manifest:e634aaf326e1c64d194dab19a7004b6f15f14e48f7eaaefb266b2167bd462234.

```sh
cargo test --offline --locked -p gpui --features x11 --all-targets
cargo clippy --offline --locked -p gpui --features x11 --all-targets -- -D warnings
cargo test --offline --locked -p gpui --lib runtime::inspector::tests -- --nocapture
cargo test --offline --locked --manifest-path evidence/typed-catalog/client-fixture/Cargo.toml
cargo build --offline --locked --release --bins --manifest-path evidence/typed-catalog/client-fixture/Cargo.toml
```

For native run, owned Xvfb114 was1280x800x24. DISPLAY=:114 and an intentionally unavailable session bus isolate optional provider noise; exact test: `native::inspector_tests::native_inspector_picks_and_edits_actual_application_without_owner_rerun --ignored --exact --nocapture`. Xvfb is stopped after the gate.

Original default baseline memory/schema logs are qualified to9604 and production8ea. The baseline default unit executable was not copied before rebuild; no later candidate hash is relabeled as it. Root instead owns the stronger frozen full-feature8ea/83aab executable pair.
