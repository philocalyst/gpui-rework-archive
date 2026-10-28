# Retained text composed with analytic gradients and immutable clip prefixes

Shipping source: `4c9f4a2b514f784319c0239812eb444c2081b3c2`. This isolated sparse tree composes Root clip/gradient source `d3e6885c6bab6a07fafcd3f4faae7cbb3023e0c7`, Root's exact cross-arena clip-content comparison through `948eff489aaa1f5d36a2514dc247884755b8e5c7`, and qualified text source `7c9fc3cf775544d4082fe7c6ce3e0bb8a3a0a407`. Main was not edited by this lane. Root owns adoption after review.

The scene retains the 14 B painter-indexed raster witness and one packed-glyph owner lease per admitted multi-glyph run. Pinned EcoVec 0.3.1 builds directly into its sole growable allocation and freezes without a copy or an outer Arc allocation. Singleton scenes stay inline. The owner and private 4 B MetricScale modules are byte-identical to the qualified text source. MetricScale multiplies only by exact normal power-of-two reciprocals; arbitrary 1.25, subnormal and exponent 254 scales keep direct division. Metadata `sources()`/`bounds()` scans skip glyph rectangle reconstruction; rounded gradient resource patching reconstructs only that material's local rectangle.

Gradient ownership remains ThinArc. Clip ownership remains an exclusive boxed arena and monotonic capability stamp. Generic `Into<Clip>`, complex-chain CPU/GPU fast-path declines, gradient sampler domain guards, the warm-capacity direct return from `71ed91f0ae`, and GPU draw-words/clip/material-tail ordering are preserved. Root's clip equality changes are imported unchanged, separately from text integration. [Semantic audit](semantic-audit.json) records 12 exact module identities.

The final combined gate enables x11/accessibility plus every Canvas/GPU feature, including parallel, SIMD, Vulkan tests and offline shader validation. Actual Cargo JSON executables run sequentially in the exclusive target, with SHA256 before and after execution and frozen source guards over 2,055 tracked build inputs. The full source 4aba run passes 1,020 tests in 105 harnesses (40 existing ignores). The final test-only 4c9 lint correction passes its two focused tests, strict all-target native/GPU Clippy, 33 doctests and 117 scalar/joint tests. Production bytes are identical; see [equivalence proof](production-equivalence.json).

The joint fixtures cover nested transformed clipping with gradients before and after text/image records at DPR 1/2/1.25, grouped/inline packets and tile proofs; exact borrowed metadata and owner lifetime after layout/service drop; rebuilt text/gradient clip scenes with empty unchanged damage and bounded changed-pixel support; and actual GPUI clipped-gradient/text candidates surviving failed newer preparation before presentation ACK. Full runtime suites cover presentation, rollback, selection, geometry, paint slots and patches. Actual generated WGSL is checked against Root and found verbatim inside the linked native/GPU ELFs.

All 48 density cohorts and 1,056 non-timing fields match qualified 7c9 exactly: geometry/pixel hashes, allocation requests and bytes, retained capacities, bin references and sample counts. All four GPU packet/readback records match too; 704 glyphs still require 25,088 B records and 33,760 B upload, 3,336 bin visits and 6,832,128 planned sample draws. The existing 32 B/glyph and 80 B/run GPU expansion remains. Timing columns in diagnostic probes are not a latency claim.

## Charged costs

The seven-library Syn/Tokei ledger, including the 50-line inline-call helper once and the GPU build script, is Root 948: 34,466 → composition: 34,530 first-party shipping lines (+64). This full combined source is +2,158 relative to Main 4ee’s 32,372, including Root's unrelated gradient/clip work. The complete new EcoVec dependency adds 2,315 non-test/non-comment shipping Rust lines; no mandatory transitive dependency is added. Total scoped source therefore grows. [Source ledger](shipping-lines.json.gz) and the separately charged [dependency ledger](owner-dependency-lines.json) retain the boundaries.

Actual TextLayout is 56 B versus Main 48 B, Shaped 64 B, TextSite and Option<TextSite> 80 B versus 72 B. The dense runtime text lane pays that additional 8 B per retained slot, including an unshaped slot. Canvas is 464 B versus Root/Main 488 B and DisplayList 264 B versus 288 B; the matched native Runtime header is 1,816 B versus Root 1,840 B. Retained multi-glyph commands remain 64 B versus Main 32 B; packed owner handles remain 16 B and GlyphBuffer 24 B. EcoVec's allocation includes a 16 B refcount/capacity header plus 12 B packed records. This is not a thin owner.

The historical matched full-planner/frame Main control below is retained from the qualified owner capsule; the current candidate's density fields were rechecked exactly. Values charge layout headers, shaping allocation payloads, actual scene capacities and Canvas header. Parser/service/raster-cache warmup, source strings, allocator metadata and RSS are outside that measurement region. The outer layout-array request is outside every variant, while its retained element storage is charged.

| Cohort | Cold requests Main / EcoVec | Retained bytes Main / EcoVec |
|---|---:|---:|
|32 solids |8 /8 |2408 /2448 |
|32 independent empty |64 /64 |2024 /2256 |
|32 independent singleton |106 /106 |5596 /6404 |
|32 independent pairs |112 /107 |7004 /7364 |
|32 independent triples |114 /108 |8284 /7812 |
|32 draws borrowing one long layout |29 /23 |27620 /13156 |
|32 independent unique long labels |164 /157 |47318 /29374 |
|32 all-clipped unique labels |128 /128 |12272 /13016 |

Warm frame admission remains allocation-free. Each pushed glyph still performs EcoVec's Acquire uniqueness check. Each admitted multi-glyph run still takes one shared-owner increment and later decrement; mask leases remain separate. Repeated labels do not deduplicate owners. Prior matched owner assembly grew the linked probe text by 1,168 B despite deleting first-party unsafe ownership, and MetricScale later added 160 B; those historical scopes are not a new full-composition code-size or speed claim. Previous strict-provenance owner Miri/borrow tests are separately pinned in the references, not newly rerun here.

## Failure and preservation record

The first compile at 296d559 rejected two newly added fixtures because their `draw_text_scaled` DPR argument was in the wrong position. Only those calls were corrected at 767ad54. That predecessor's full execution then passed 1,007 tests and failed one native header ledger: functional geometry and shared-editor checks passed, but its old hard-coded TextSite 72 B expectation observed 80 B. The final source explicitly charges and asserts 80 B. Both failures and their frozen input identities are retained. The later full 4aba execution passed 1,020 tests; its first strict gate rejected two constant-sized `chunks_exact(4)` calls in the new joint test. The final test-only 4c9 correction uses `as_chunks::<4>()` with the same complete-pixel partition. All other tracked paths are byte-identical. No production behavior was changed to suppress a failure.

All 105 predecessor ELFs (27,933,218,576 B) were atomically renamed after execution into `/tmp/gpui-text-composition-sol-frozen-initial`, with unchanged hashes, instead of copied. The full run's 105 ELFs are also preserved under `/tmp/gpui-text-composition-sol-frozen-full` by same-filesystem rename after successful execution hashes, preserving inode/content mtime without redundant bulk reads. Focused final-test identities and source pins are recorded separately. Builds use exact nightly 2026-10-23, rustc 7189d39d9, local jobs 2, the lane's exclusive target, and llvmpipe/Mesa 26.1.4. No remote jobs or pushes were used. All lane build/test jobs are reaped; frozen binaries remain available for Root review.

A separately recorded [next-owner hypothesis](next-owner-hypothesis.json) considers an existing ThinArc allocation with a fully charged raw glyph bound. Root reports a standalone known-bound prototype, but the integrated adapter is unimplemented and unqualified. Parley exposes paragraph-local raw bounds, so growth/copy or an additional counting pass must be charged. Strict-provenance qualification remains required; this does not change the shipping source.

The target began empty and was never shared across worktrees. Final full Cargo JSON reports `fresh=false` for all three production libraries and their library-test units. Future overlays should additionally use content freshness or package cleaning; build-script freshness and actual embedded shader identity require separate care. [Freshness record](cargo-freshness.json) retains the executed scope.
