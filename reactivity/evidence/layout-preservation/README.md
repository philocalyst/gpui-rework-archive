# Actual-correspondence layout preservation — bounded CPU gate passed, no adoption

Parent `160fd281de0c27a160d46d9d5a1da6bd89eb33ca` identified topology-only reconstruction discarding surviving semantic nodes' layout handles. This optional local feature preserves generational handles through actual reconciliation correspondence and existing core invalidation. It does not adopt the closed paint/address alternatives, replace the layout engine, alter application APIs, or qualify the complete contiguous CPU/GPU architecture. Serial raw GPU publication remains unchanged. The inherited mixed CPU/GPU 48-byte gate remains **FAILED** and was not rerun.

Protocol `706efbf51459f5bc6dd20a47ed201933305b7a00`; core implementation `625ff3eaf5368d18d184f9d00073312e0cb8faf0`; final executed integration `3c185abd0f` (full identity in source.txt). Core build/eight tests/strict Clippy passed. Final GPUI build, 84 layout/pixel frames across four selectors and fresh full reconstruction, four failure/routing cases, strict all-target Clippy, source guards and canonical executable verification passed. No timing was collected. This is bounded qualification of a feature-gated live producer path, not adoption or a performance verdict.

## Measured work

All cells use ordinary public `Win::set`. Automatic is the original reconstruction/retained algorithm within the same instrumented feature build; Forced reconstructs as an independent oracle, not the practical control. Ordered and Append share the validated core move primitive. Its refactor removes the old layout wrapper's duplicate validation; this shared change must not be attributed to ordered-before alone.

| Keyed 256-fillers insertion, 267→269 nodes | Automatic | Ordered | Append |
| --- | ---: | ---: | ---: |
| Surviving handles retained | 0 | 267 | 267 |
| Core node insertions | 269 | 2 | 2 |
| Actual sibling relinks | 0 (rebuild) | 1 | 2 |
| Move validation ancestor steps | 0 (rebuild) | 3 | 9 |
| Layout computed / cached / cheap answers | 11 / 1 / 779 | 8 / 7 / 9 | 8 / 7 / 9 |
| Changed layout writes | 269 | 7 | 7 |
| Requested Source allocation bytes / allocations | 581,024 / 272 | 423,504 / 193 | 423,504 / 193 |
| Source peak live delta | 183,344 | 183,344 | 183,344 |
| Known current layout payload | 84,312 | 80,424 | 80,424 |

The candidate still performs 269 reconciliation correspondence checks, 269 preflight checks, 267 old-handle removal checks, 269 new-handle writes and 269 sibling-order checks. Original description, identity-index construction, dependency comparisons and paint remain global. This is **not** a local structural journal or constant-time update. Preserving cached unaffected layout answers is the specific result.

The insertion plan owns 1,220 bytes (104-byte Plan, 1,076-byte rank vector, 40-byte used bitset); new handles require 4,304 bytes while the old 8,192-byte capacity remains live; the frontier is 200 bytes with nine pushes/pops. No measured-node route allocation occurs in this tree. Plan allocation counts include two vectors and a box. Plan bytes are temporary and dropped on successful commit/fallback. These capacities overlap during apply; Source peak also includes the rest of the producer and observers. No private old layout versions are retained by the candidate.

Removal preserves all 267 survivors, removes two core nodes and relinks none; ordered move preserves all 267 and relinks one. The append alternative relinks two and validates nine ancestors for this move versus ordered's three. This is a three-row local list, not a general bound on large permutations. Ordering still visits unrelated filler nodes. Core depth changes are zero in these live same-parent fixtures; separate core tests exercise actual cross-depth descendant updates.

The seven-node measured reorder preserves seven handles, builds a three-row qualified NodeId→rank route (96-byte capacity), performs three sort comparisons and six lookups/18 comparison steps. The fresh sorted-preorder route performs 24 comparison steps for six lookups. Subsequent content updates retain the reverse route without rebuilding it. Known current layout payload is **4,904 versus 4,824 bytes**, and Source peak **7,043 versus 7,007 bytes**: handle preservation is not a universal storage win. Unmeasured trees retain zero route capacity. Resource/ancestor-width controls add 3/4 correspondence checks but allocate no plan and preserve original measurement/dirty behavior.

The 344-byte experimental State, including work counters, is included in every selector's ledger. The core mutation counters add 40 bytes to LayoutTree versus the parent. Thus Automatic is not the feature-off shipping memory baseline. Known payload totals sum layout header, topology allocation, lanes, allocated cache payload, runtime handle capacity, experimental State/route/pending plan; exclude vendor style metadata, allocator overhead, external text/image resources, Canvas, full application and diagnostic snapshots. Much of the 3,888-byte insertion retained difference is the new exact-length handle vector replacing an 8,192-byte capacity, not compressed nodes. Source allocation includes existing test observers; capture/comparison/report allocation is separately recorded outside Source. No whole-process memory or latency inference follows these numbers.

## Authority and counterexamples

Pending rank assignments are emitted after actual previous-node/component filtering; no snapshot mirror drives decisions. The plan binds exact predecessor PresentationToken (including window namespace), completed/source epochs, root capability and old length. Before mutation, all reused handles and their old/new parent correspondence are checked. Removing unused ancestors cannot delete an admitted survivor. Removed generations are checked against the actual current arena, including unkeyed shape-change remints. Working handles are installed for computation but committed authority is published only beside successful scene/epoch publication. Failed description, inner preparation and owner poison invalidate reuse; recovery reconstructs. Earlier coherent Canvas acknowledgement remains independent.

A failed-description test initially exposed a certificate-cleanup omission before the presentation catch boundary. Attempt `93a1e667e0` passed all 84 visual/layout frames but **failed** that authority assertion; the corrected describe-error invalidation is in the final source. The original invalid-transform fixture fails before layout mutation, so it does not by itself prove post-layout rollback. The measured-route fault exercises failure during layout: deliberately restoring obsolete sorted-preorder lookup after reorder causes caught `PresentationPanicked`; the older token remains acknowledgeable. A separate panicking core measurement poisons the layout and the next ordinary source update rebuilds to exact fresh layout/pixels. No rollback of mutable layout scratch is promised.

Resource changes keep own core styles equal yet still require four measurement queries and changed layout; ancestor width changes require new text measurements and move the following sibling. Unkeyed reorder can preserve all handles and skip layout while changing pixels. Ordered correspondence grants no paint, clip or resource reuse permission: topology_changed remains set through full paint. The prior 326-byte outside-group omitted-damage witness and identical-cold-bytes/different-pixels witness remain binding. The route mutant's failure is an error, not claimed wrong pixel output.

## Requirement matrix and architectural transfer

| Requirement | Status in this experiment |
| --- | --- |
| Contiguous preorder semantic Node storage; existing identity lookup | Existing, reconstructed on description; no new registry |
| Semantic→generational layout capability survival | Implemented for admitted same-parent correspondence; remints/removals checked |
| Cached layout answer validity | Existing engine dirty/style/ordered-child/constraint/measure rules retained; handle equality is insufficient |
| Direct source→local structural/dependency journal | Missing: full reconciliation, indices, ordering and paint still visit globally |
| Measured-node routing after handle reuse | Implemented qualified reverse route; O(M) construction plus sorting on structural apply |
| Semantic subtree→GPU output/dependency/resource closure | Missing; original raw publication unchanged |
| Compressed persistent CPU/GPU tree; coherent shared memory | Missing; no encoding/address alternative adopted |
| Submitted-GPU version/resource lifetime | Original path unchanged; CPU layout scratch is not an immutable GPU lease |
| Exact mixed CPU/GPU parity | Inherited FAILED gate remains open |
| Complete live cost / ZGX advantage | Unmeasured here; no adoption or competitor claim |

The BBTree research motivates preserving cache-local work and treating relocation invalidation explicitly; this test does not implement its async runtime, and independent suspended-memory work does not erase parent/layout dependencies. Solid/Ripple-style version authority transfers as exact predecessor and stale-work rejection, not reuse of stale layout answers. This experiment changes the live reconciliation→layout connection; it does not change the proposed compressed display-tree representation. A cost decision must charge all added scans/metadata and the complete original serial-raw endpoint, with unchanged-topology controls, rather than extrapolating from saved layout writes.

## Reproduction and preserved attempts

Run `python3 reactivity/evidence/layout-preservation/verify.py`. Full exact build/test commands, environment, source guards, Cargo freshness, canonical ELF paths/hashes and embedded unchanged WGSL are in raw. Final executable used nightly-2026-10-23, locked offline release, no default features, `x11-minimal,layout-preservation-lab`; CPU tests only. Shader inclusion is provenance, not GPU execution. Core inventory is 38,710 non-test first-party library lines versus parent 38,145 (+565 including optional experimental code). No unsafe code or Rc/Cell/RefCell ownership was introduced.

Preserve core-first PASS, integration-first compile failure (test-only borrowed-runtime mutability), integration-second authority failure, and integration-third PASS. The original root workspace is untouched; all changes remain local and unadopted. The dossier verifier checks manifests, executed frozen sources, canonical artifacts, gate outcomes, raw-pixel equality and reproducible analysis. It cannot turn these bounded fixtures into generic layout or hardware-GPU proof.
