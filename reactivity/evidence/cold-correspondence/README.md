# Live cold correspondence: useful compression, no adoption

Complete cold-node encoding is now emitted during the existing live reconciliation loop, using its accepted previous_index and existing semantic identity. **No snapshot reconstruction or new identity registry derives it.** Exact decoding and live pixels pass. This does not make structural updates local: the producer still describes, reconciles, rebuilds its index/layout where required, and paints the whole fixture. It also performs the separately charged codec/verification work.

**Decision:** this fixed-block relative-parent representation is not adopted. Relative parents reduce changed cold records, but provide no encoded-byte or ordinal-block rewrite advantage over the identical absolute-parent codec on these live cases. Shifted insertions rewrite every block. Raw tiny fallback protects payload only; headers/journals still lose against existing raw storage. High-entropy field cases also lose after metadata. The existing raw Node vector remains present in the actual experiment, so no production memory saving has occurred.

The bounded paint campaign remains **NOT ADMITTED**, single1024=1.103170; unchanged16B work does not explain that timing observation. A/B verdicts are unchanged. No timing, GPU upload reduction, hardware, ZGX, coherent shared memory or shipping claim follows this cold experiment.

## Encoding and identity scope

Canonical records contain all 24B of cold fields: u64 identity, packed u64 links (parent/ordinal/handler), u32 content and u32 component scope. Content includes resource/text slot indices, not the separate resource payloads or styles. Absolute and relative alternatives use the same 32-record, four-column unsigned base/bit-width codec; only parent bits change interpretation. Relative parents decode using known preorder rank. Raw escape preserves unprofitable blocks;0..8 rows use raw storage. Link fields remain packed into one column, so high ordinal/handler bits can dominate its width; these results do not rule out other field layouts.

Ordered correspondence runs are 12B each (old_start/new_start/len), with an explicit new-literal sentinel. They carry only identity and rank correspondence. Existing IdentityIndex still supplies semantic lookup; it has a 24B header and its existing arithmetic/run/sorted-entry heap. Rank→codec block is arithmetic, but subtree endpoints/affected-extent enumeration and renderer emission extents are not supplied by that fact. Source-version stamps here are logical source versions, not presentation tokens. Incomplete description revokes correspondence while retaining old codec stores; GPU publication authority remains the original renderer/token mechanism.

## Live storage and rewrite accounting

Columns below include each alternative store header, block directory and payload, plus the retained correspondence header/capacity and existing identity index. Baseline includes the existing raw Node Vec and that same index. Hypothetical replacement means removing that raw Vec; this has not happened. Actual diagnostic storage retains the raw Vec, all three alternative stores, fixed trial/statistics metadata, runs and the common identity index. It excludes unrelated layout/presentation/Canvas/renderer data and post-update diagnostic JSON; it is not whole-application memory.

| Case | Edit | Records | Runs | Existing raw + lookup B | Hypothetical absolute/relative + journal + lookup B | Actual raw mirror + three controls + trial + lookup B |
|---|---|---:|---:|---:|---:|---:|
| unkeyed-4 | insert | 13 | 3 | 408 | 284 / 284 | 2024 |
| unkeyed-4 | remove | 12 | 3 | 384 | 282 / 282 | 1972 |
| unkeyed-4 | move | 12 | 1 | 384 | 282 / 282 | 1972 |
| unkeyed-32 | insert | 41 | 3 | 1080 | 449 / 449 | 3698 |
| unkeyed-32 | remove | 40 | 3 | 1056 | 443 / 443 | 3638 |
| unkeyed-32 | move | 40 | 1 | 1056 | 443 / 443 | 3638 |
| unkeyed-256 | insert | 265 | 3 | 6456 | 1651 / 1651 | 16854 |
| unkeyed-256 | remove | 264 | 3 | 6432 | 1645 / 1645 | 16794 |
| unkeyed-256 | move | 264 | 1 | 6432 | 1645 / 1645 | 16794 |
| keyed-4 | insert | 17 | 3 | 504 | 304 / 304 | 2256 |
| keyed-4 | remove | 15 | 2 | 408 | 247 / 247 | 2094 |
| keyed-4 | move | 15 | 4 | 472 | 311 / 311 | 2158 |
| keyed-32 | insert | 45 | 3 | 1176 | 473 / 473 | 3938 |
| keyed-32 | remove | 43 | 2 | 1080 | 415 / 415 | 3774 |
| keyed-32 | move | 43 | 4 | 1144 | 479 / 479 | 3838 |
| keyed-256 | insert | 269 | 3 | 6552 | 1675 / 1675 | 17094 |
| keyed-256 | remove | 267 | 2 | 6456 | 1605 / 1605 | 16906 |
| keyed-256 | move | 267 | 4 | 6520 | 1669 / 1669 | 16970 |

Keyed256 insertion emits 269 records. Its new raw payload is 6,456B; either compressed payload is 1,275B, with 216B block-directory capacity and 40B store header. The journal has 36B live run payload in 48B capacity plus 24B header; existing identity lookup adds 72B (24B header + 48B runs). Thus hypothetical compressed replacement totals 1,675B versus 6,552B raw+lookup. Actual shadow/control storage is 17,094B. Source literal records are 48 canonical bytes, already included in encoded data, not an extra allocation.

Complete cold-record changes are 262 for raw/absolute versus 6 relative. This refines the earlier diagnostic 260-vs6 comparison: packed ordinal/content/scope fields were not all in that probe. Despite fewer changed records, all 1,275 encoded bytes plus the 216B new directory are produced and would be rewritten at ordinal block addresses after insertion. The descriptor/header/run costs are additional. This is a hypothetical dirty-byte comparison; **no new GPU staging path exists**.

Keyed256 reorder produces 1,253B of encoded data in both codecs, although only 158B differs at ordinal block addresses. Raw comparison would replace 6,408B. The emitter still constructs all blocks/directories, visits 267 producer records, and the existing path still rebuilds 267 layout nodes and paints 267 nodes. Do not convert dirty bytes into a producer-work or latency claim.

## Tiny, entropy and fragmentation counterexamples

The same test executable records 26 synthetic storage/roundtrip cases at 0/1/2/7/8/9/31/32/33/63/64/65/257 rows, both repeated-structure and high-entropy exact field values. High entropy varies identity, packed-link fields, content and scope within codec bit domains; these are not asserted valid UI/resource references. A separate compiler probe runs the existing IdentityIndex constructor on the same identity sequences and charges its actual header/heap. No new lookup table is proposed.

| Rows | Entropy | Raw Vec + existing lookup B | Raw control + journal + lookup B | Absolute/relative + journal + lookup B |
|---|---|---:|---:|---:|
| 0 | repeated structure | 48 | 88 | 88 / 88 |
| 0 | high | 48 | 88 | 88 / 88 |
| 1 | repeated structure | 72 | 160 | 160 / 160 |
| 1 | high | 72 | 160 | 160 / 160 |
| 8 | repeated structure | 240 | 328 | 328 / 328 |
| 8 | high | 336 | 424 | 424 / 424 |
| 9 | repeated structure | 264 | 352 | 246 / 246 |
| 9 | high | 372 | 460 | 486 / 486 |
| 32 | repeated structure | 816 | 904 | 374 / 374 |
| 32 | high | 1200 | 1288 | 1298 / 1298 |
| 257 | repeated structure | 6216 | 6304 | 2090 / 2090 |
| 257 | high | 9300 | 9388 | 9494 / 9494 |

For one row, raw payload is 24B in every mode, yet the complete counted replacement is 160B versus 72B baseline after common lookup. A raw payload fallback alone does not remove the 16B extra store-container header and 72B retained journal metadata. At nine high-entropy rows, the comparison is 486B versus 372B; at 257 it is 9,494B versus 9,300B. The added machinery has real losing cases. No post-result fallback tuning is applied.

Insertion happens to emit three runs in these fixtures; keyed removal emits two, unkeyed reorder one and keyed reorder four. A separate 32-record permutation emits 32 runs (384B payload/capacity plus 24B vector header). Three runs is not a general bound. Source literal references point into the new codec image; retired payload/lifetime processing is not implemented by correspondence alone.

## Producer, temporary and retained versions

Encoding is shadow work inside the actual public source update. The final draft count reserves payload/directories; no post-hoc snapshot supplies the records. Each compressed builder retains at most 32 Wire values (1,024B scratch), with 120B builder header and 36B explicit base/width stack arrays. The latter are explicit working arrays, not a machine-code stack-frame measurement. Per-cell old/new stores, headers, directories and scratch are recorded. For keyed256 insertion, old/new relative stores are 1,509B/1,531B; the known object-plus-scratch sum is 4,184B before separate 36B arrays/journal/common lookup. It is not a measured whole-process peak.

Each alternative point-decodes 267 surviving old records in that insertion. Block encoding reads 3,228 fields in each compressed alternative versus 1,076 raw fields; block-local roundtrip checks decode 269 records per compressed alternative. Cross-codec comparison then verifies 807 records. These verification walks are separate from emission and do not discover the apparent savings. Source-update allocation observations now include the codecs, controls and validation; they are not comparable to the earlier uninstrumented path as an optimization result.

The trial object is 1,056B and contains all fixed statistics/control headers; combined retained totals avoid counting its embedded store headers twice. JSON is produced only after update observation and is not retained by the producer. Pending candidate heap is reported on failed newer description. Old/new logical codec images are temporary owner-local versions; arbitrary overlapping GPU versions and fenced resource reclamation are not implemented here. Existing raw CPU mirrors, lookup rebuilds and whole-tree work remain explicit.

## Two decisive authority counterexamples

1. The inherited actual GPU mutant repairs only the edited group and omits the moved overlapping following sibling. It still produces 326 wrong pixel bytes in all six insertion cases. Subtree extent is not layout/damage closure.

2. Unkeyed reordering leaves every complete cold-node byte unchanged (zero raw/absolute/relative dirty bytes), while **704 pixel bytes change** in all three sizes. Color/style data lives elsewhere. Cold equality and identity correspondence cannot authorize paint, layout or resource reuse.

Thirty final live frames match current CPU, independent fresh-window CPU and full GPU oracles exactly. Existing token rejection and failed-newer/eligible-old behavior remain intact. Clip resources are preserved from the trace; text/image payload lifetime and renderer subtree extents remain open. No correspondence is attached to a GPU publication.

## Decision and unresolved representation choice

The executable producer connection is useful: identity survival now yields ordered correspondence without reconstructing snapshots. Compression of regular cold fields is measurable. However, this fixed ordinal-block representation does not preserve those savings through insertion, and its tiny fallback leaves metadata losses. It is not an integrated display tree or a selected production format.

The next representation question is whether an ordered retained chunk/piece description can preserve unchanged encoded extents across insertion while bounding run/directory fragmentation and all live versions. It must continue using existing semantic identity and charge live reconciliation/layout work. Absolute and raw controls remain necessary; relative displacements alone have not won this codec comparison. A separate node-to-Canvas/GPU emission extent and explicit layout/paint/clip/resource dependency authority are still needed before this can become the requested unified update architecture. The 326-byte and 704-byte counterexamples constrain every reuse proposal.

## Provenance

Protocol commit 1404f25077ec7f447218a72e581072ef354b79b9. First source f9fb837eaf7e75930e1dcfd6a116bd268a4d499f passed; fixed-metadata source c52bed37885634aa251d3d07149361e0a4409832 moved JSON outside the producer; final storage-observation source 4a0e4c7c2b8960aadc8cee01a9d6705bb99935a4 adds explicit storage logs/high-entropy link fields. All three cohorts preserve fresh executed ELFs, embedded identical shader bytes, clean source guards, codec/live tests and strict Clippy. No timings or acceptance thresholds were observed or retuned. Final source inventory 38,054 versus 38,047 parent is conservatively charged conditional test instrumentation; shipping behavior/API is unchanged.

Canonical executables are preserved; completed duplicate ELF/cache removal has manifests/receipts. One attempted older-metadata cleanup stopped before mutation because its age check failed; that target was left alone. The raw evidence contains earlier cohorts and final observations, analysis, existing-index probes and storage-reclamation receipts. The final verifier checks manifests, exact frame/mutant comparisons, run replay, storage accounting and the synthetic cost observations. All changes remain local.

Counter-label limitation: in the tiny raw branch the frozen `validation_decodes` field increments during raw serialization, not an additional block decode. Actual block-local decodes there are zero; the separately counted cross-codec record comparisons still execute. Storage figures and live cases (all larger than eight nodes) are unaffected. The raw observations are preserved without relabeling them silently.
