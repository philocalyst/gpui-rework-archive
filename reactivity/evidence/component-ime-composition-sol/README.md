# Component and IME composition review

Frozen shipping source: `3ab1d964981f44d503f1df9b4947c929c6742160`, sole direct parent `0e97be59c5a033f7ca146a45ab739477261ad900`. Unique worktree `/root/gpui-component-ime-review-sol-20261024`; unique default, native and Hummingbird targets. Main is untouched. The earlier `3fc07815a0ce389db54e492dd1d889c6fca10699` component candidate and evidence `a82c69a021653ef2dc3940886073f7c523100f0c`, including all actual Mac binaries, remain unchanged.

This applies the qualified feature delta deliberately to current IME-enabled Main. It adds no color redesign or component family. Textual conflicts were limited to the prelude, Linux accessibility test module declarations and Part serialization. The resolved source retains Length and IME exports, both real invalid/IME provider fixtures, and all marked_text/disabled/invalid fields with the correct serializer field count. Cleanly merged runtime files were reviewed semantically: input_index remains visible to IME and rejects effective disabled state; editing selection/Replace admission rejects disabled state; pre-patch and post-patch IME reconciliation/cancellation remain; style-only publication cannot discard canceled preedit removal. Focus indicators still damage through the existing acknowledged preparation path.

The protected closure checks **2,746 non-feature files** byte-for-byte against the parent, including Reader, Remote, standalone Hummingbird lock, all four Todo example files, Root IME files outside reviewed feature overlaps and the portable GPU oracle. Workspace lock merge adds only the component package/GPUI edge; existing parking_lot edges remain. `protected.json` records every protected hash and the explicit feature exceptions.

## Public regressions and actual behavior

The new component tests use the actual reusable Input and ordinary public Win, Source, ImeSession, semantic query and presentation APIs:

- Input.disabled revokes active preedit before ACK. P still exposes its previously acknowledged preview/mark and flags, while logical focus/edit authority rejects the disabled control. ACK exposes disabled+invalid true, removes the mark, and re-enabling does not revive the old stream. Explicit Enabled creates a fresh stream.
- Rebinding the same component identity to another registered source during preedit does not transfer the old source lease. A fresh stream edits the new field once.
- A valid disabled/invalid C remains eligible after a newer NaN dimension failure. ACK may display that C, but neither the failed logical owner nor the older IME session acquires action authority. Recovery retires the old target identity.
- A paint-only shared boolean cohort source change causes no owner rerun or re-description. It still cancels preedit and prepares its removal; late commits do not write the source.

The native projection regression uses ordinary public IME/source events and the actual AccessKit projector. Old P remains unchanged; after eligible C ACK, Invalid=True, disabled and read-only state agree, and Focus/SetValue/SetTextSelection/ReplaceSelectedText are absent. Existing native CJK wire coverage reads the real AT-SPI provider through preview, old candidate ACK, failure and commit. Invalid state/event wire coverage and the actual contained inspector entry/recovery fixture also pass.

Current IME source-epoch validity is conservative: even an unrelated paint-only source admission revokes the active stream. This composition preserves and tests that contract; it does not claim IME continuity through arbitrary source updates.

`disabled` currently belongs to semantic controls and their named-part descendants. A generic column/div disabled group is unsupported. The initial fixture tried column.disabled(BoolState), failed before mounting, and was corrected to the supported Input contract. **This is not ancestor-disabled group coverage.** Same-control source/style fallback and inheritance tests remain separate contracts. General form/group disabling is a meaningful future API gap.

## Local qualification

The exact local build guard is `232d9250c3a1820e68f173f6df6ba429adfac790f9dff5deea43550f8af9b8a0` over **2,100** inputs: .cargo, clippy/toolchain, standalone workspace manifest/lock, all first-party crates and vendors. All before/after guards match. The unused root workspace pair is supplemental for the Mac copy, whose guard covers 2,102 inputs; do not confuse the two scopes.

- Clean first-party dev packages, then complete default GPUI/component suite: **762 passed, zero failed, ten ignored**, 80 result groups including docs and the complete Todo cases.
- Strict default GPUI/component all-target clippy: pass, warnings denied.
- Actual native X11 GPUI unit executable: **267 passed, zero failed, 34 ignored**, including the new combined AccessKit case. Strict native GPUI/component all-target clippy passes.
- Hummingbird's own locked/offline all-target check passes, with a separate 2,153-input guard.
- Explicit ignored real AT-SPI invalid fixture: pass, with InvalidEntry state and StateChanged invalid-entry transitions.
- Explicit ignored Root CJK IME AT-SPI wire fixture: pass, with actual provider reads and normalized Winit IME callbacks.
- Explicit ignored native contained inspector entry fixture: pass, through real selection/draft/rejection/recovery/Apply/pixels/stale-target feedback.
- Actual native Halloween application builds; the executable and section measurement are frozen. This composition has no new physical Mac or Halloween screenshot claim. Earlier actual Halloween captures remain qualified to source 3fc.

No OS candidate engine is synthesized. X11 provider/native tests exercise real Window/CPU presentation and normalized callback routing; they establish neither hardware GPU performance nor display scanout latency. No permission/capture/AX retry or service restart is part of this work.

The initial a4ef control remains on `codex/component-ime-initial-control-sol-20261024`, with its actual failed executable and matching source guards. The first Linux native command omitted x11, causing winit's unsupported-platform compile error; both failed command receipts survive. Corrected unchanged-source native,x11 gates pass. The first explicit IME wire attempt lacked org.a11y.Bus; its failure is retained, and the rerun uses Root's existing real AT-SPI launcher. No production edits were needed for these failures.

## Measured costs and retained artifacts

Shipping inventory: **37,490 core lines**, versus **35,851** in exact parent Main (**+1,639**); reusable component library **606** separately; vendor adaptation three production lines. Tests, examples, comments and evidence are excluded. Dependencies remain the qualified component-to-GPUI edge and existing Root dependencies, with no new composition dependency.

Actual cost fixtures ran from frozen executables.

| fixture | allocations | requested bytes | retained bytes |
|---|---:|---:|---:|
| snapshot description | 13 | 2,000 | 2,000 |
| direct description | 37 | 4,408 | 3,624 |
| snapshot mount | 420 | 164,786 | 28,724 |
| direct mount | 470 | 170,770 | 29,356 |
| party description | 58 | 7,808 | 7,448 |
| party window | 1,008 | 321,963 | 91,594 |

Both mounts and the party window retain/request eight more bytes than source 3fc, with no additional allocation. Description costs are unchanged. Direct-vs-snapshot retained difference remains 632 bytes.

The 100 direct checked updates remain 1,950 allocations/338,800 requested/zero retained bytes, zero owner reruns/descriptions, 100 source reads and 400 destination comparisons. Snapshot remains 5,750 allocations/1,821,800 requested/100 owner reruns/descriptions. Initial/final rasters are exactly equal (281,600 bytes each). This is not an allocation-free binding claim. Existing public layouts remain El 176, Style 88, PropertyValue 28 aligned 4, Button 192, Checkbox 536 and Input 360. The earlier explicitly charged ColorInput 80 and grouped private type-erasure/vector costs are unchanged.

The unoptimized native X11 application is **71,419,344 bytes**, `.text` **25,932,887**, SHA-256 `cc6e4254e49ac0ad78c97a669bae781674a5fe5d2f6edbc741564e5b7f294daa`: +174,136 whole ELF and +78,064 text bytes against source 3fc under the same dev debug0/incremental0 configuration. These are linked code costs, not optimized speed results.

`actual-frozen-executables.json` identifies all actual retained binaries outside targets. The compact key-executable archive additionally carries the actual IME/control/cohort/Reader contracts, both cost fixtures, native GPUI unit executable and native application, with source/hash manifests. All other full-suite executables remain external. `local-raw-receipts.tar.gz` and member hashes retain commands, output, guards and resolved failures; repeated identical files may be standard tar hardlinks. Native wire results include exact executable identity and reaped-process receipts.

The complete feature delta is 74 files, 175,703 compressed bytes, SHA-256 `5f9a3591b4683543082d448ab9a42a27d33c70da43e6b2864e8a7ab13fba7f6a`, at `/tmp/gpui-component-ime-mac-3ab1-sol/shipping-delta.tar.gz`. It is relative to exact 0e97, with no deletions. The complete Mac source overlay is 724,961 bytes, SHA-256 `8fca0d5505b8e27adbb5ba8191a3d4ca6cab3bc43bcc9216345109cdaecaecf4`, supplementing the immutable 5aff Mac base. Neither archive replaces Main wholesale.

Remaining reference coverage remains partial: 67 of 81 modules are unported and seven are partial. Rounded focus outlines, generic disabled groups, broader control families, full relative uniform-list viewport behavior and arbitrary component/theme reflection remain gaps. The public APIs are typed and macro free; bounded private type erasure/downcasts and per-group/member vectors remain charged. Direct typed color lowering is a subsequent review, not part of this source.


## Incomplete Darwin attempt and superseding configuration fix

The exact 3ab1 Darwin build was stopped during compilation when free storage crossed the enforced 20 GiB floor. All owned compiler processes were terminated and reaped; 2,102 source hashes remained identical. Its 62 fresh actual partial MachOs total 1,956,909,024 bytes and were frozen outside Cargo; none was executed. This is an incomplete build, with no Darwin test qualification claim. `darwin-incomplete/` preserves the floor failure, source/capsule receipts, exact partial executable hashes, initial oversized upload rejection and successful bounded retry. Subsequent authorized cleanup removed only 664 regenerable first-party Cargo cache files (243,680,494 bytes), with path/byte receipts retained remotely.

The standalone component entry point was then found to default to scalar: component disabled GPUI defaults but forwarded no simd feature. This is a material configuration gap even though the full GPUI/component suite enabled SIMD through feature unification. Rather than mutate this frozen source, successor 14006e63d086c29229679db5edc823bec8a7912f composes the feature onto Main fea3dc and adds component default=["simd"], simd=["gpui/simd"]. The successor verifies the actual standalone app closure and explicit scalar opt-out. The partial 3ab1 and prior qualified 3fc MachOs remain byte-preserved; any later lossless relocation is recorded by an appended receipt after independent Root verification, never by rewriting this attempt into a pass.
