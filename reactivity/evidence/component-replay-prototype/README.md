# Local component replay: bounded CPU qualification, no adoption

**NO ADOPTION or performance claim.** An actual public Source update can now re-describe one explicitly opted-in rectangle component without calling its parent, while preserving the tested full-root pixels and semantic identity/remint rules. This research feature is not an automatic optimization of legacy View/direct_component. Global producer work and substantial storage losses remain.

Protocol `fa52341cc08380f345832d1ba348d614cc03786d`; final executed source `a0bc93cd11148b1ac439deaf4a60608be3af25e8`. Build, focused public integration test, feature-off library compilation, strict Clippy and source guards pass. The final 39 records include 24 admitted ordinary grow updates, explicit fallbacks, failed-newer recovery and a deliberately wrong caller. Original legacy counterexamples also pass at the final source. GPUI is compiled as a non-test library with only `component-replay-lab`; dev canvas emission-trace/GPU packet-trace dependencies are compiled, but GPU execution is absent.

## Application contract and representation

The provisional API uses one static `LocalComponent`, `Sources::local_component(&DESCRIPTOR)` and `El::child_local(&DESCRIPTOR, self)`. The existing child model and ordinary `Win::set(CHILD.source(&GROW), value)` remain. The insertion evaluates the child and marks the closed composition during real lowering; no borrowed callback or diagnostic snapshot is retained. A static descriptor is shared by registration/insertion, unlike a copied const whose address need not identify one recipe.

The closed caller recipe admits absent width, literal Set(width), or a registered optional Source width. None means no write; Some(16) means an override. Explicit Set(24) is preserved even when initially equal to the child. External input changes use full root description. Registration additionally promises parent/sibling description independence and deterministic, read-only child description. An undeclared external read under a false promise is not generally detectable; it is not advertised as an automatic fallback. All indices and lifetimes remain checked safe Rust.

One occurrence directly beneath the owner root is admitted in a whole-scene plain-rectangle subset. Nonempty fanout, resources, handlers, text, lists, Reader projections, overrides, repeated/nested appearances and mismatched descriptors decline local admission. Unsupported new handler output falls back after a preview, visibly invoking parent once and child twice. This is not generic outside-resource/fanout preservation. Existing identities, component routes and namespace authority are reused; no parallel semantic identity registry is introduced.

The recorded origin carries exact predecessor/new source epochs, namespace, root/parent identity, recipe input revision, old/new ranges and actual reconciliation correspondence. It is an event capture for this experiment, not a generic production journal or GPU consumer. Pending authority becomes usable only after preparation; errors revoke it. An older complete Canvas acknowledgement cannot revive failed logical authority.

## Results and costs

| Initial grow update | Replay | Full-root control |
| --- | --- | --- |
| Parent/child calls | 0 / 1 | 1 / 1 |
| Small 4→5 nodes: described nodes | 3 | 5 |
| Large 260→261 nodes: described nodes | 3 | 261 |
| Large node payload written to replacement vector | 6,264 B, all 261 records | 261 records reconstructed |
| Large suffix parent checks / rewrites | 257 / 128 | Full reconciliation |
| Large identity index inputs | 261 | 261 |
| Large retained style payload | **25,056 B dense** | **741 B shared palette/index** |
| Large Source requested allocations | 268,628 B / 260 allocations | 574,465 B / 402 allocations |
| Large allocation-counter maximum within Source | 41,972 B | 198,032 B |
| Unchanged tiny grow value: Source allocations | **10,380 B / 53 allocations** | **5,720 B / 20 allocations** |

These are requested bytes and logical record writes, not hardware memory traffic, process RSS, timing or a speedup. The allocation-counter maximum is scoped to the measured Source operation, not total live application memory. Replay intentionally forces existing full layout/paint even for unchanged descriptions, explaining additional work in that control. No cost acceptance gate was run.

For the large edit, old/new extents are [1,3)→[1,4), root identity2 survives, and both new unkeyed children remint to261/262, matching full root. The following blue sibling survives and moves when width is absent; literal Set(24) keeps it in place. All positive paired comparisons are exact CPU pixels/layouts; successful ordinary comparisons also use a fresh full reconstruction. An omitted-caller mutant produces **1,152 wrong pixel bytes**, preserving the earlier counterexample.

Both alternatives still build sibling indices with260 count visits,261 prefix visits,260 address writes and2,088 B scratch. Replay additionally scans260 retained nodes for admission, writes261 styles, visits261 nodes for depth, and rebuilds the existing identity index. Its temporary child drafts reserve704 B, replacements72 B, child counts24 B; the origin correspondence retains96 B. Current research State is760 B including diagnostic counters/report/certificate headers. Static descriptor symbols are88 B; the optional trait-reference field in each component registration is16 B. These are component costs, not complete application storage.

The extra large-case style payload is24,315 B; with96 B correspondence it matches the24,411 B difference in measured retained-allocation delta on the initial grow. No timing/RSS share is inferred. The full control's style builder remains unchanged; the dense replay lane is a real loss, not a compressed representation.

## Authority, failures and limits

Tests exercise absent/literal/optional input, growth/removal/repeat, unrelated suffix scaling, repeated/legacy-extra/nested visual appearances, nested component boundary chains, outside binding, descriptor replacement, explicit revocation, owner-induced root remint and new handler fallback. Invalid optional width produces the same committed Property error, keeps older Canvas pixels eligible, and recovers by full remint. Depth rejection occurs before minting/consuming nodes; both paths report DepthLimit at129 and recover with identical identities. Whole-owner node/identity-limit diagnosis falls back to the original producer; exhaustion is source-audited, not exercised to u64 limits.

Failed attempts remain in `raw/`: first compilation failed on four interface/type errors; second passed CPU tests but failed Clippy on an unnecessary drop; third passed its bounded gates. Review then moved depth admission before mutation and retained original whole-owner limit diagnosis. Fourth and final gates pass. No previous observation is erased. GPU resource lifetime, concurrent GPU versions and the inherited mixed CPU/GPU exact-pixel FAILED gate are not qualified by these CPU tests.

**Observer scope:** [the earlier producer ledger](../producer-observer-ledger/README.md), seal `64fc4b385771e2e57574986a010a578c5db7fe53`, remains binding. Old absolute Source costs included experimental stores/verification and are not shipping GPUI. This new non-test experiment excludes those cfg(test) stores, but its Source allocation measurements still include research counters, origin capture and feature-specific storage. Capture cloning/serialization/verification and CPU pixel readbacks are outside Source. Before any later timing comparison, define a fresh configuration with diagnostics removed or explicitly scoped; do not subtract an estimated observer share or reinterpret earlier NOT ADMITTED gates.

## Requirement map

| Requirement | Current evidence |
| --- | --- |
| Contiguous Node storage and semantic identities | Existing production capabilities, with original lifetime/remint rules |
| Qualified local structural description origin | Implemented only under the new opt-in contract and rectangle subset |
| Generic partial reconciliation/dependency journal | Missing; linear splice/rank/style/index work remains |
| Layout/paint and nonlocal old/new damage | Existing global path retained as oracle; subtree-only damage is not authorized |
| Compression / semantic GPU emission mapping / shared-memory publication | Not supplied by this prototype |
| Text/image and in-flight GPU lifetime | Outside admission; no new qualification |
| End-to-end ZGX/hardware advantage | Unproven; no new timing or competitor measurement |

Inventory at final source:39,065 non-test library/build lines, +920 versus the raw38,145 baseline; this includes non-shipping feature/diagnostic code. The exercised integration ELF is11,497,416 B, not a shipping application-size result. Canonical executable hashes and all source/toolchain/profile guards are preserved. External canonical binaries remain on the research machine and are not embedded in Git. Run `python3 reactivity/evidence/component-replay-prototype/verify.py` for the committed evidence checks.
