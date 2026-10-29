# Ordered cold extents: actual sharing, no adoption

Immutable encoded extents now survive live reconciliation in an actual CPU shadow store. The large keyed insertion produces115B of new relative payload instead of1,275B from the fixed-block codec, and retains2,392B across current/old logical versions versus3,683B absolute and13,024B raw. This is a concrete extent-preservation result, **not a complete update cost, GPU upload, latency or production memory win**.

**Decision: no adoption.** Relative encoding has a measured large-insertion benefit once unchanged physical extents can survive; the previous codec-only experiment did not show this. But it loses to absolute on encoded bytes for the smaller keyed cases because fragmentation forces full compaction, and on the large keyed reorder (78B versus57B). Its current-only image can also be larger. Tiny and high-entropy cases lose to raw. Existing raw storage/renderer remain the production baseline; no universal encoding is selected and no fallback threshold is retuned.

The existing bounded paint decision remains NOT ADMITTED (single1024=1.103170; unchanged16B work does not explain the timing observation). A/B verdicts remain sealed. No new paint/timing campaign, ZGX inference, coherent shared-memory claim or shipping change is made. All work is local.

## What is implemented

The same live reconciliation loop supplies accepted old rank, existing semantic identity and all24B cold fields (identity, packed parent/ordinal/handler, content, component scope). No old/new snapshot adapter recovers the savings. Existing correspondence runs and identity lookup stay separate controls, with their rebuild/storage costs charged. The original Node Vec and layout/style/resource tables remain.

Each16B ordered piece carries logical start, physical offset/length and an immutable Arc<Vec<u8>> block lease. A matching row may share bytes only when its identity and every interpreted cold field agree. Adjacent physical slices of the same block merge; changed rows flush new blocks before the next reused slice. The unchanged32-record codec uses raw escapes; scenes of at most8 rows use raw storage. Absolute and relative forms differ only in the parent interpretation.

Lookup uses binary search over piece starts, with a cached piece hit only inside its exact interval. The implementation still decodes every surviving old row, reconstructs the ordered directory and reserves16N bytes for its worst-case staging directory. A tight final directory is explicitly moved/copied and charged. If pieces exceed2*ceil(N/32)+2, the actual assembled store is decoded and compacted into fresh32-row blocks; discarded staging, extra block controls, scratch and directory work count. This bounds the final directory under the declared policy, not total producer work or arbitrary retained reader memory.

Current plus two old logical versions are retained. Shared blocks count once across all roots, but every root, directory, version lease and retained unused physical row counts. Allocation-counter verifies40B block control allocations (16B Arc control +24B Vec header),80B version allocations (64B Version +16B control), and the initial retained heap ledger in78 raw/absolute/relative boundary cells. These are requested allocation/capacity bytes, not allocator size classes, RSS or machine-code stack size.

## Live payload and retained-version results

R/A/D below mean raw immutable copies, absolute extents and relative-distance extents. New payload counts include discarded staging and compaction bytes; raw counts are canonical bytes copied. Retained totals include all currently owned logical versions, unique block payload/controls, version allocations and directory capacities, but exclude the separately shown state/trial metadata and common identity/run controls. Initial state has one version, insertion two, removal/reorder three. Fixed-block controls retain only their current image and must not be compared as if they implemented the same lifetime policy.

| Fixture | Edit | N | Newly copied/encoded payload B (R/A/D) | Retained version store B (R/A/D) | Current pieces (A/D) | Compactions (A/D) |
|---|---|---:|---|---|---|---|
| unkeyed-4 | insert | 13 | 312 / 98 / 56 | 760 / 531 / 433 | 4 / 3 | 0 / 0 |
| unkeyed-4 | remove | 12 | 288 / 95 / 53 | 1128 / 850 / 654 | 4 / 3 | 0 / 0 |
| unkeyed-4 | move | 12 | 288 / 0 / 0 | 1128 / 898 / 686 | 4 / 3 | 0 / 0 |
| unkeyed-32 | insert | 41 | 984 / 195 / 57 | 2104 / 818 / 640 | 4 / 4 | 0 / 0 |
| unkeyed-32 | remove | 40 | 960 / 192 / 54 | 3144 / 1234 / 878 | 4 / 4 | 0 / 0 |
| unkeyed-32 | move | 40 | 960 / 0 / 0 | 3144 / 1165 / 910 | 4 / 4 | 0 / 0 |
| unkeyed-256 | insert | 265 | 6360 / 1217 / 59 | 12856 / 3646 / 2168 | 11 / 11 | 0 / 0 |
| unkeyed-256 | remove | 264 | 6336 / 1214 / 56 | 19272 / 5476 / 2520 | 11 / 11 | 0 / 0 |
| unkeyed-256 | move | 264 | 6336 / 0 / 0 | 19272 / 4105 / 2552 | 11 / 11 | 0 / 0 |
| keyed-4 | insert | 17 | 408 / 107 / 209 | 928 / 554 / 455 | 4 / 1 | 0 / 1 |
| keyed-4 | remove | 15 | 360 / 99 / 178 | 1368 / 877 / 678 | 4 / 1 | 0 / 1 |
| keyed-4 | move | 15 | 360 / 57 / 165 | 1368 / 1022 / 678 | 4 / 1 | 0 / 1 |
| keyed-32 | insert | 45 | 1080 / 205 / 355 | 2272 / 852 / 856 | 4 / 2 | 0 / 1 |
| keyed-32 | remove | 43 | 1032 / 196 / 322 | 3384 / 1272 / 1279 | 4 / 2 | 0 / 1 |
| keyed-32 | move | 43 | 1032 / 57 / 309 | 3384 / 1288 / 1279 | 4 / 2 | 0 / 1 |
| keyed-256 | insert | 269 | 6456 / 1230 / 115 | 13024 / 3683 / 2392 | 11 / 15 | 0 / 0 |
| keyed-256 | remove | 267 | 6408 / 1218 / 91 | 19512 / 5517 / 2923 | 11 / 15 | 0 / 0 |
| keyed-256 | move | 267 | 6408 / 57 / 78 | 19512 / 4231 / 3249 | 11 / 17 | 0 / 0 |

Keyed256 insertion preserves263 of269 relative records in12 shared slices and encodes6 records into three new blocks (115B +120B block controls). Its15-piece directory writes491B of logical descriptor fields, including length coalescence, and moves240B into its tight allocation. It still point-decodes267 predecessors:9 directory searches/30 comparisons and258 cursor hits. It emits269 producer rows and reads72 fields in the encoder. It writes192B of32B Wire scratch records. These are instrumented logical bytes/operations, not hardware bus traffic or a constant-size publication descriptor.

The relative current image is2,168B versus2,044B absolute, despite the better two-version sharing total. It retains273 physical rows for269 current rows; four are inaccessible slack in still-leased blocks. The complete actual shadow experiment retains38,497B in the counted cold-node/index/control subset versus6,552B for the original raw Node Vec plus existing lookup. That actual sum includes the raw mirror, previous three fixed-block controls/journal/trial and all three new immutable-version alternatives; it is not a hypothetical replacement or whole-application memory saving.

Each new State is736B, including its fixed measurement counters and embedded optional Builder; the Builder is416B. History handle capacity is32B after insertion. Relative current/history plus that state is3160B. The shared existing identity index is72B and correspondence journal is72B for this insertion; neither disappears. Full per-case accounting is in raw/accounting-fixed-fresh/analysis.json.

The relative update reserves4,304B of staging descriptors and1,024B scratch. Its known version/directory peak is6680B before separately accounted builder/state, scratch,36B explicit encoder arrays and diagnostics. The on-producer memory ledger itself visits48 pieces and has1128B peak known heap scratch, including root lists; this diagnostic work is charged. Cross-control verification adds269 directory probes/1076 comparisons per relative alternative, plus raw oracle reads. It discovers no reuse. Post-update JSON/snapshot diagnostic allocations are outside the Source allocation scope.

Existing work remains global: insertion reconciles269 nodes, supplies269 entries to the existing identity-index constructor, rebuilds269 layout nodes and paints269 nodes. The measured full public Source allocation scope includes all controls/verification (537,888B/268 allocations in the first cohort; final observations are authoritative in analysis.json). It excludes post-update diagnostics and GPU/oracle operations. No allocation ratio is treated as a speedup. The original renderer still stages7,992B, validates71 draws and visits486 bins. None of the115B cold payload is consumed by that renderer.

## Fragmentation, tiny and entropy limits

The existing32-record permutation is preserved: it rebuilds its changed records rather than implying that insertion's three correspondence runs are a general bound. A65-record cold-field wrapper/leaf permutation is an additional bounded extent adversary, not a new public UI workload. Absolute and relative assembly reach32/48 pieces, over the frozen threshold8; both compact all65 records. Absolute initially encodes702B then322B more; relative416B then322B more. Thus payload production is1,024B/738B, with640B initial block controls plus120B compaction controls each. Relative metadata performs273 compaction-directory comparisons, writes833B of descriptor fields, and holds2,048B scratch. Forty-nine reusable relative rows did not prevent a complete compaction. No claim of bounded structural edit work follows.

Current-only storage, before experimental State/identity/journal metadata, already exposes tiny/high-entropy losses:

| Rows | Values | Existing raw Vec B | Raw version B | Absolute/relative version B |
|---|---|---:|---:|---:|
| 0 | repeated structure | 24 | 80 | 80 / 80 |
| 1 | repeated structure | 48 | 104 | 104 / 104 |
| 8 | repeated structure | 216 | 272 | 272 / 272 |
| 9 | high entropy | 240 | 296 | 354 / 354 |
| 257 | high entropy | 6192 | 6248 | 6642 / 6642 |

The raw fallback protects payload, not the80B version allocation or State/lease metadata. A single row uses104B current-version storage versus48B for an existing raw Vec, even before any shared journal/identity/state overhead. High entropy varies exact cold fields within codec domains; it is not a claim of valid arbitrary resource references. No mirror, block slack or directory is omitted to manufacture a memory win.

## Lifetime and authority

An explicitly held older CPU reader remains exact after five updates, retirement from the two-version owner history, an incomplete candidate and owner drop. Its additional version/directory retention is measured together with unique shared blocks. Namespace or nonadvancing source epoch disables payload reuse; it does not implement GPU publication rejection. The logical store is not the renderer's exact-predecessor certificate. The held-reader fixture also has an8B guard Arc for the current version and an8B Weak observer in test stack state; the root allocation is counted once, and the Weak keeps that control allocation alive until its own drop. No GPU fences, text/image lifetime or coherent CPU/GPU shared memory have been established by these CPU leases.

The existing live token/oracle fixture still rejects stale acknowledgements and preserves the older eligible frame after failed newer preparation. All30 frames match CPU, independent fresh-window CPU and full GPU exactly. However, the inherited group-only damage mutant still produces326 wrong pixel bytes in all six insertion cases: moved overlapping siblings lie outside the semantic subtree. And unkeyed reorder shares all cold records with zero new compressed payload while704 pixel bytes change in all three sizes. Identity/cold equality authorizes storage sharing only, never layout, paint, clip, text/image or resource reuse.

## Requirement matrix and next architectural boundary

| Requirement | Status | Limit |
|---|---|---|
| Contiguous preorder CPU nodes and semantic identity lookup | Existing | Ranks/addresses rebuild; identity lifetime follows existing reconciliation/remint rules |
| Live correspondence without snapshot adapter | Implemented test seam | Every described node still traversed; no generic structural/dependency journal |
| Ordered encoded extent preservation | Implemented CPU shadow store | Binary directory lookup, split descriptors, O(N) staging and occasional full compaction |
| Lossless complete cold fields / raw fallback | Implemented, exact controls | Styles, layout and resource payloads are separate; total tiny overhead still loses |
| Multiple immutable versions and held-reader lifetime | Implemented CPU fixture | Owner history bounded; arbitrary external readers add retention; no GPU-fenced resource model |
| Semantic subtree-to-renderer emission extents | Missing | Cold pieces represent rows, not draw/group/clip/resource spans; subtree endpoints not materialized here |
| Layout/paint/overlap/resource dependency closure | Missing for local structural update | Existing complete producer and renderer remain authoritative; both semantic mutants constrain reuse |
| Shared-memory GPU publication / direct decoding | Missing | Original staged writes and retained ordered tiles unchanged |
| End-to-end cost / ZGX advantage for this store | Unmeasured | No timing, hardware or competitor claim |

The result supports retaining relative extents as a large-structural-edit candidate, with raw and absolute controls, not choosing them globally. The next useful seam is an explicit relation from existing semantic node identity/range to the commands actually emitted during the live complete paint pass, including inherited transform/clip and resource interpretation. That relation must be emitted where commands are recorded, not reconstructed from snapshots or inferred from cold equality. It should first expose the following sibling and overlapping contributors that require publication even when their cold extents are reused. Command/group/resource extents and dependency authority must remain distinct. This is the next connection to investigate, not a proposal to expand paint special cases or tune this codec.

## Reproduction and provenance

Protocol1b03d046bc8f6074866239677034aa4dd11dce92; parent8714afdf2e81803693172acd981127d521f478a1. Final executed sourceb6ed2130e6124279417c45f0741aa113861124a2. First sourceae1d47142e passed ordered/codec/live tests but strict Clippy rejected two manual slice-size expressions. The correction also charges verification-directory comparisons and the caller root-vector capacity explicitly. A subsequent attempt stopped before any build because free disk was below8GiB; the empty preflight is preserved. Only this experiment's completed build cache was reclaimed after verifying its canonical executable. Both source cohorts and cleanup receipts remain.

Final ordered4 tests, inherited codec4 tests and native structural fixture pass, as does strict Clippy. Source guards are unchanged, canonical ELFs are hashed, Cargo freshness is preserved and generated WGSL bytes are located inside the executed executable. Software Vulkan is llvmpipe; no physical display latency is measured. The source inventory is38,059 versus38,054 parent; conditional test initialization remains conservatively charged. All new store code is cfg(test), with no shipping application API or renderer change.

Run python3 verify.py in this directory. The manifest covers frozen sources, protocol, all successful/rejected evidence, analysis and this report. Canonical executable paths are external preserved artifacts and are hash-checked when available.
