# Native private address publication

**No adoption or timing verdict.** Relative clip/common domains and stable draw references now reach actual GPU pixels from live emission/preparation events, independently of one another. The original raw renderer/shader remains the pixel oracle and practical serial control. The bounded encoding/lifetime gates pass; the inherited mixed exact CPU/GPU discrepancy remains **FAILED**, unchanged and not rerun. These are restricted prototype paths, not a production journal, compressed display tree, coherent-memory publisher or ZGX result.

Parent `41a986b3f0dfe9e032944ecbedb4a13c824cdf91`. See `PROTOCOL.md` for policies frozen before execution, `source.txt` for final executed source, and `raw/` for failures and corrected cohorts. All work stays on local/address-publication in its own worktree/target; no shipping adoption.

## Four complete alternatives

| Alternative | Representation and publication |
| --- | --- |
| Original raw full | Unchanged original shader/preparation; serially reused renderer and complete staged arrays. Practical control and independent final-pixel oracle. |
| Raw relocation | Original record/reference encoding; fresh private version, GPU predecessor-capacity copy, CPU predecessor-array clone, full preparation, global 16-byte dirty-block comparison, staged changed blocks. Same transport as the two experiments. |
| Relative domains | Raw-relocation transport. Clip indices interpreted through the exact version's clip base; compact common pointers use backward distances. Physical draw addresses and tile references remain unchanged. |
| Stable draws | Raw record/clip/common encoding. Existing semantic identity plus own-command ordinal resolves to a bounded dense handle; GPU directory maps it to that version's physical record. Reuse an old tile-list interval only after comparing the freshly prepared ordered stable contributors. No relative-domain combination. |

`Win::packet_keys` borrows live emission keys under its exact namespace/source/presentation authority. The adapter reads no JSON or diagnostic packet snapshots to construct updates. Keys preserve address identity only, never permission to reuse old layout, paint or resources. The existing semantic mapping and cold diagnostic mirrors remain attached to this test build and are charged in Source work; it is not generic production journal integration.

Preparation remains global. Every new scene traverses description/reconciliation/layout/paint; every draw is rebuilt and binned. Stable-list reuse first constructs the complete new CSR and compares all tile rows. The raw and relative dirty-block scans compare the entire new staged arrays against retained old arrays. The keyed insertion's 269-node producer work remains. The old 326-byte escaped-sibling damage counterexample and identical-cold/range-but-changed-pixel witness still prohibit granting dependency authority from range/storage equality.

## Measured work, not latency

All values below are bytes; complete per-frame accounting is in `raw/analysis.json`.

| Case / edit | Raw full staged | Raw relocation staged | Relative staged | Stable staged | GPU copied (raw/relative/stable) |
| --- | ---: | ---: | ---: | ---: | --- |
| keyed-4 insert | 1312 | 672 | 672 | 784 | 1312 / 1312 / 1312 |
| unkeyed-4 insert | 1336 | 680 | 680 | 824 | 1312 / 1312 / 1312 |
| keyed-256 insert | 7992 | 4440 | 4440 | 5052 | 9376 / 9376 / 9376 |
| keyed-256 move | 7872 | 96 | 96 | 332 | 9376 / 9376 / 10400 |
| mixed insert | 1320 | 1112 | 1048 | 1272 | 1696 / 1696 / 1696 |
| resources replace | 724 | 128 | 128 | 128 | 1056 / 1056 / 1056 |

For keyed256 insertion the stable instance domains are globals48 + records/directory3,632 + tile ranges64 + indices1,308 + corrections0 =5,052B. The directory contributes288 of those record bytes. It examines16 tile rows and159 contributor comparisons, writes71 directory entries, reuses9 lists and appends91 indices. Raw relocation domains are48 +3,344 +96 +952 +0 =4,440B. Both copy9,376 GPU bytes; CPU known-array copies are7,824B raw versus9,056B stable. Stable retains a1,024B superseded copied index allocation. Mixed relative domains are48 +704 +128 +168 =1,048B versus raw48 +768 +128 +168 =1,112B.

 Instance staged bytes include globals, records/directory, ranges, indices and corrections; image pixel and mask texture payloads are separate. GPU copies are real additional transfers of allocated predecessor capacities, not avoided staged bytes. Resource-map copying, guards, handle insertion movement, full directory writes, tile comparisons and scans remain separate counters.

Relative mixed insertion reduces staged instance payload by 64 bytes versus raw relocation. Stable keyed256 insertion reuses nine tile lists yet stages more total bytes than raw relocation. Its reorder is another counterexample: raw positional records need only 96 staged bytes, while stable semantic addressing also changes directory/order information. Saving shifted references alone does not establish lower complete publication cost.

The relative shader adds address arithmetic (clip base plus index*5; common base minus backdistance) under a mode branch. The stable shader adds a directory vec4u storage lookup on each `load_draw`, plus indexing/branching. These are source-level operations, not measured hardware cache misses or total shader invocations. The original shader is compiled independently. The alternative is generated at runtime by checked exact replacements; preserve its actual executed WGSL, transformer source and both artifacts. Spare globals lanes carry address bits through bitcast, not numeric float conversion/arithmetic. All modes still upload the 48-byte globals block, not a solitary 4-byte publication.

## Versions, resources and negative controls

A candidate owns four fresh mutable buffers. Four predecessor-copy commands are submitted before any patch writes. Its globals, records, directory, ordered ranges/indices, corrections, image suffix and mask atlas are bound to that private version; retained buffer handles alone are not treated as immutable content. Replacement/growth that did not receive the copy into that exact allocation requires a complete write. Superseded copied allocations are retained through Base and charged as orphan copies. Image pixels live in the private draw/image buffer. An atlas is shared only if all new mask keys already exist; otherwise a fresh private atlas prevents forks from overwriting old readers. Map capacity clones and resource-key examinations are charged. No borrowed CPU resource lease is described as a submitted GPU lifetime guarantee.

A predecessor update uses one copy submission, one staged-write flush, then one actual draw submission; initial/fallback uses flush plus draw. Original raw full uses one draw submission. These counts exclude readback submissions. Holding up to four private candidates permits deferred-oldest consumption without overwriting contents. Logical versions are drawn newest-to-oldest without intervening waits, then compared with independent original GPU images. This is not a claim of hardware completion callbacks arriving out of order, WSI presentation or scanout. Latest acknowledgement succeeds and older candidates are rejected despite valid old pixels; stale upload work is charged rather than erased.

63 candidate/oracle pixel comparisons pass; 42 stale acknowledgements are rejected and 21 latest accepted. Both actual wrong-version descriptor controls produce 3,226 differing bytes: old clip-base/new records and old directory-base/new records. Correct descriptors restore exact encoding equivalence, not cross-backend parity. The extra 128-update stable arena gate matches all 129 original GPU images, retains at most two versions, compacts at steps56 and112 and reclaims predecessors only after completion. The pure handle test exercises 4,096 admitted keys, exhaustion, duplicate and foreign namespace refusal. No handle recycling occurs in this experiment.

Banked paint and actual nonlowered parent clip chains explicitly fall back to raw and match the original GPU in six frames. Lowered raster-rectangle clips are admitted based on their actual encoding, not unused source metadata. Gradients remain unexercised. Generic nested clips, arbitrary resources, recovery/device loss, cross-context invalid inputs and production presentation are not newly qualified.

## Storage and allocation scope

Bytes across held candidate versions, except the single raw serial renderer and one shared handle allocator:

| Case / held versions | Raw-relocation GPU | Relative GPU | Stable GPU | Raw serial current GPU | Stable extra adapter / current CPU arrays / observer / handles |
| --- | ---: | ---: | ---: | ---: | --- |
| keyed-256 / 4 | 37697 | 37697 | 41793 | 9425 | 46164 / 60968 / 16480 / 3104 |
| mixed / 3 | 70768 | 70768 | 71536 | 67280 | 5236 / 6632 / 840 / 800 |
| resources / 4 | 266560 | 266560 | 266560 | 66640 | 4740 / 4368 / 608 / 128 |

 The private GPU ledger includes buffers, orphan copied allocations and unique atlas textures across all held versions. Add 16,384 bytes per held candidate target and one transient 16,384-byte readback. Test oracle textures/buffers, expected CPU images, diagnostic JSON and pipeline/driver state are separate. Raw control retains one serial renderer; it does not promise the same independently replayable old-version service as the candidates. Its storage is still the relevant practical baseline, not a hidden zero cost.

CPU arrays, per-version Frame/Base allocations, sorted handle allocator, packet-observer capacity and older producer diagnostics are additional, overlapping categories must not be summed twice. The allocation counter records requested cumulative bytes/count and scoped net/peak deltas, not total process retained memory. Raw render allocation includes draw submission; candidate prepare includes copy and staging flush but its final draw is separate. These captures are stage diagnostics, not a fair complete allocation endpoint or latency result. Hash-map capacity counts are not exact allocator bytes. The timing endpoint must include candidate final submission and fenced retirement.

The stable directory is rebuilt for every version and retains all nonrecycled handles (limit4,096). The index arena clones previous entries and appends changed lists; its fixed bound is four times current dense entries plus1,024, then compaction rebuilds the dense current CSR. Fragmentation, scans, copies and compaction are not eliminated by stable references. The resource replacement fixture can hold four 64KiB atlases, while the original serial renderer retains reusable masks. No total memory/compression win follows.

## Gates and provenance

First source4f13c71b failed build on unstable iterator is_empty. Corrected0a48666b passed57-frame encoding trace but failed strict Clippy on tuple type complexity; its keyed fixtures still fell back. Admittedfbc5328e checked actual lowered clip encoding and named the borrow type; build/57-frame trace/Clippy passed. Bounded1ef2069d added the prescribed arena/handle/fallback gates; all passed. Final aff00547f22664b8396162cd0a2214c1b85ba1fe adds domain/allocation counters; all gates passed with unchanged exercised pixels. All five attempts are preserved separately. Final accounted source, input guards, checksum freshness, explicit release cleanup, canonical actual ELFs, original embedded WGSL and actual generated alternative are verified. Strict GPUI/GPU Clippy passes. No source edits during gates, no timing samples in this dossier. Conservative library inventory38,891 lines versus38,145 parent (+746), including feature-gated lab code; the normal shipping dependency does not enable address-lab. The test/dev feature also adds COPY_SRC usage to original-control buffers, so this artifact is not the shipping binary. Generated shader and canonical ELF bytes are recorded separately. The software Vulkan endpoint is llvmpipe on this local VM; no hardware GPU inference. Local incremental disk floor2GiB after scoped cleanup; Mothership unused, its8GiB floor unchanged.

## Requirement matrix

| Requirement | Status |
| --- | --- |
| Contiguous CPU preorder nodes / semantic identity | Existing, with reconstruction/remint and rank relocation limits unchanged |
| Live semantic identity→command→physical record | Implemented restricted test adapter from actual producer/preparation events, exact version binding |
| Relative prefix domains / stable draw directory GPU consumption | Implemented separately for admitted formats, full preparation still global |
| Old/new support and dependency closure | Existing full path retained; subtree-only counterexample remains; generic local journal missing |
| Versioned packet and exercised resource lifetime | Private GPU versions, deferred old consumption, fenced reclamation, text/image replacement exercised; generic resource/model coverage missing |
| Mixed exact CPU/GPU parity | FAILED inherited48-byte discrepancy, not rerun or relaxed |
| Local structural update without full description/layout/prep | Missing; all current global work explicitly retained |
| Lossless integrated compressed display tree | Missing; cold extent store remains separate and unadopted |
| Coherent shared-memory publication / constant total update | Missing; staged writes, full scans/copies and rendering work remain |
| Complete endpoint timing / production GPUI / ZGX advantage | No new timing yet; later separately frozen cost decision required |

The next decision is timing these complete alternatives, with tiny/raw controls and exact aggregation frozen prospectively. Neither relative prefix savings nor stable contributor references should be selected on changed-word counts alone.
