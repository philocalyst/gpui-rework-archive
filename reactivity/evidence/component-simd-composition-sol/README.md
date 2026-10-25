# Component / IME composition with ordinary SIMD defaults

Frozen shipping source: `14006e63d086c29229679db5edc823bec8a7912f`, sole parent `fea3dc224b440dd807cebd088cc959b8626668de`. Worktree: `/root/gpui-component-default-simd-sol-20261024`. Main is untouched. Shipping source and prior 3fc/a82, 3ab1, source capsules and actual executables remain fixed. This report records Linux qualification; Darwin qualification is pending and must not be inferred from earlier candidates.

This is the deliberate 74-file component/Length/typed-binding feature delta composed with Root's IME, Reader, Remote and portable GPU work. The only successor change against the 3ab1 feature formulation is component `default = ["simd"]`, forwarding `simd = ["gpui/simd"]`. GPUI's component dependency retains `default-features = false`, so explicit scalar opt-out still works. The actual standalone Halloween build resolves SIMD in GPUI, Canvas and GPU; a separate no-default-feature native example check resolves none of those SIMD features. Full GPUI/component feature unification alone would not establish this standalone contract.

The initial composition resolved three textual conflicts: prelude exports, Linux accessibility fixture module declarations, and Part serialization. Both Length and IME exports, real invalid/IME fixtures, and marked_text/disabled/invalid serializer fields survive. Runtime admission deliberately retains input_index visibility and effective disabled rejection, source/selection edit rejection, pre/post-patch IME reconciliation, cancellation, and preparation of removed preedit during style-only publication. Root's later private ASCII restart and its ordinary cost fixture are byte identical to this parent. `protected.json` records 2,747 non-feature files unchanged, including Reader/Remote, Hummingbird's parking_lot lock edge, Todo and GPU oracle. Root's still newer Todo checkpoint fixture is outside this source and must survive any later integration.

## Public behavior

The component crate supplies actual reusable Button, controlled Checkbox, Input, Label, Badge, form/layout helpers and semantic Oklch theme tokens. Halloween uses these components. Typed recipes and Checkbox root/indicator/label and Input frame/control parts remain ordinary closure transformations. Callers replace behavior through the same handler registration path, with last registration the sole authority. No macro, fabricated selector or test-only route is required.

```rust,ignore
Checkbox::new("Light the lanterns", &self.lanterns, &theme)
    .toggle(Self::LANTERNS)
    .disabled(&self.locked)
    .parts(|parts| parts.label(|element| element.font_size(15.)))
    .build();
Input::new(&self.title, "Gathering name", &theme)
    .invalid(&self.invalid)
    .disabled(&self.locked)
    .build();
```

BoolBinding evaluates its source/predicate once for an explicit semantic/appearance cohort. Public values are typed; the implementation still uses bounded private type erasure/downcasts and group/member vectors. Explicit ColorInput is 80 bytes, while PropInput<Color> remains 48. No universal static-dispatch or allocation-free claim is made. Ordinary by-value Rust branches remain snapshots and require registered field/component dependencies; direct bound values do not turn arbitrary Rust into a reactive language.

The ordinary component IME regressions prove disabling an input revokes active preedit before ACK, rebinding identity to another source does not transfer a lease, an older eligible disabled/invalid C may ACK after a newer failed candidate without acquiring edit authority, and paint-only cohort changes cannot retain a stale stream. Old P keeps its acknowledged mark/flags. The actual AccessKit projection agrees on Invalid=True, disabled/read-only state and absent edit/focus actions. Source-epoch admission remains conservative: even unrelated paint-only changes revoke IME; no arbitrary update-continuity claim is made.

Generic container/group disabled is unsupported. These tests cover the supported Input control and same-control style fallback, not ancestor-disabled groups. The failed initial container fixture and corrected semantic-control fixture remain preserved with source 3ab1.

## Linux qualification

All guards match before/after every compiler gate and after native runtime fixtures: 2,103 inputs, aggregate `c11641d94e223055708771bf55710b2fb7fef5025fa3ce23526e74d29a1f4a01`. Scope includes root and standalone Cargo pairs, .cargo/clippy/toolchain, crates and vendors. Reused owned default/native targets were explicitly cleaned for eight changed first-party packages in dev profile. Actual executables are frozen outside Cargo targets, with source/hash manifests. All owned compiler and fixture children were reaped.

- Full default GPUI/component: **763 passed, zero failed, ten ignored**, including docs and ordinary Reader unwind/first-poll/control trait, typed Length, inspector and binding contracts.
- Standalone component ordinary default: **43 passed, zero failed**.
- Native X11 GPUI unit: **268 passed, zero failed, 34 ignored**.
- Strict default and native GPUI/component all-target clippy: pass, warnings denied.
- Hummingbird's own locked/offline all-target check: pass in a fresh target, with a separate 2,156-input guard.
- Real ignored AT-SPI invalid-state/event fixture, CJK IME wire fixture, and contained inspector edit/rejection/recovery/pixel/stale-target fixture: one actual test each passed on the frozen native executable; its hash remained unchanged.
- Actual standalone SIMD Halloween application: pointer/Space/Enter/Tab controls reached acknowledged source epoch 9; resize to 960×700 ACKed; draft/focus/disabled/ready/resized screenshots are retained. Xvfb software display and ReferenceCpu presentation establish no physical Mac capture, hardware GPU performance or scanout claim.
- Explicit scalar opt-out native Halloween check: pass, actual GPUI/Canvas/GPU features verified without SIMD.

The complete default gate took 114.44 seconds after first-party package cleaning with cached dependencies; standalone component tests 9.31 seconds, native unit gate 59.67 seconds. These are actual local gate timings, not clean-room compiler performance comparisons. No TCC/AX/capture retry or service restart occurred.

## Shipping size and measured costs

Measured core: **37,502 non-test/comment shipping lines**, exact parent **35,863**, delta **1,639**. Reusable component library: **606** separately. Vendor adaptation: three production lines. Dependencies include the component-to-GPUI edge and existing Root dependencies; this successor adds feature forwarding and no dependency.

| fixture | allocations | requested bytes | retained bytes |
|---|---:|---:|---:|
| snapshot description | 13 | 2,000 | 2,000 |
| direct description | 37 | 4,408 | 3,624 |
| snapshot mount | 420 | 164,786 | 28,724 |
| direct mount | 470 | 170,770 | 29,356 |
| party description | 58 | 7,808 | 7,448 |
| party window | 1,008 | 321,963 | 91,594 |

The 100 direct checked updates use 1,950 allocations, 338,800 requested bytes, zero retained bytes, zero owner reruns/descriptions, 100 reads and 400 destination comparisons. Snapshot updates use 5,750 allocations and 1,821,800 requested bytes with 100 owner reruns/descriptions. Initial/final rasters match exactly (281,600 bytes each). Direct mount retains 632 bytes more than snapshot, reduced from the earlier b9 +1,280 baseline; transient grouping remains more expensive. Costs match 3ab1; no SIMD allocation reduction is claimed. A stock Button description itself allocates once and requests 56 bytes; its cold appearance storage is a real allocation.

Actual public layouts: El 176, Style 88, PropertyValue 28 aligned 4, Button 192, Checkbox 536, Input 360, Theme 192, Length/Option<Length> 8. A small rustc metadata probe also emits actual ColorInput 80, BoolState 16, BoolBinding 56, BoolColors 80, PropInput<Color> 48 and PropertyValue 28/alignment 4; its assembly and corrected probe-command failures are retained in `public-layout/`. The dev debug0/incremental0 native SIMD application is **72,176,256 bytes**, text **26,564,567**, SHA-256 `dfb00f66a6bc31671265bf60e31b7d4b21078a4c3e6ee56db18332e2bed59e13`. These are linked code costs, not optimized speed results.

## Handoff

`local-raw-receipts.tar.gz` and `local-members.json` retain 114 exact command/output/guard/helper members, using tar hardlinks for identical content. `actual-frozen-executables.json` identifies 98 actual retained executables. The eight-key-ELF archive is `/root/gpui-component-simd-sol-artifacts-20261024/qualified-14006-key-executables.tar.gz`, 96,441,014 bytes, SHA-256 `55300b3e416e9150d1212fef301b91bd017e33abf177b6ed801bcb28614bd1b8`.

The whole 74-file feature delta, no deletions, is `/tmp/gpui-component-simd-mac-14006-sol/shipping-delta.tar.gz`, 175,641 bytes, SHA-256 `769d2fa93dc0069a47939a7c2372f541e802652158810066babc8eb4b2c508a3`. It applies relative to fea3dc; it is not a replacement of Main. The Mac source overlay is 727,238 bytes, SHA-256 `dd0d8802dd3cb2238fdcb4285faf4620ee7baa88da6afca02916158b2b5a3638`, over the immutable 5aff Mac base, with exactly 2,103 guard files.

The earlier 3ab1 Mac attempt stopped during compilation at the 20 GiB floor; its 62 actual partial executables were never run. Prior 3fc qualification is independently valid for its own source. Owned actual MachOs are being losslessly relocated and independently verified to restore final-build headroom; no original executable is removed until Root verifies every destination hash. The incomplete transfer/watchdog receipts remain evidence, not qualification.

Reference coverage remains partial: 67 of 81 modules unported and seven partial. Rounded focus outlines, generic disabled groups, further real control families, full relative uniform-list viewport behavior and arbitrary component/theme reflection remain gaps. Direct typed color lowering is a later structural review, not part of this source.
