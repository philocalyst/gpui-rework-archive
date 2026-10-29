# Semantic identity to layout capability

**Trace only; no optimization, adoption or speed claim.** Existing semantic survival is lost at a specific conservative boundary: any ordered-identity topology change replaces the entire LayoutTree and every arena-qualified NodeId. The core already has retained topology, dirty propagation and query caches. Connecting those mechanisms safely requires ordered-child edits and correct measurement routing, not another semantic identity registry.

This isolated branch forks raw parent41a986b3f0dfe9e032944ecbedb4a13c824cdf91. The later address alternatives remain closed **NOT ADMITTED** at9e349796d694cf10d32eb19d8c42e528f8d77985; their private transports are not carried into this investigation. Protocol d70f6fe327b97898541fb7081728f18950c36efa; executed source c8118b37617768ecacd2e8d6d9d2f801cf669a3d. No pushes.

Eighteen ordinary public-Source frames match a fresh full producer/CPU renderer exactly: keyed4/keyed256/unkeyed4 initial/insert/remove/reorder, resource initial/replace/return, and constrained-text initial/narrow/return. No GPU was executed by this trace. The inherited mixed CPU/GPU48-byte gate remains **FAILED**, not relaxed, rerun or replaced by these CPU comparisons. Prior326-byte subtree-only damage and704-byte unchanged-cold/different-pixels witnesses remain constraints.

## Exact loss and existing controls

| Frame | Semantic survivors | New nodes | Reinserted layout nodes | Surviving layout handles | Compute / measure queries | Cause |
| --- | ---: | ---: | ---: | ---: | --- | --- |
| keyed256 insert |267|2|269|0|1 /0|topology only|
| keyed256 remove |267|0|267|0|1 /0|topology only|
| keyed256 reorder |267|0|267|0|1 /0|topology only|
| unkeyed4 reorder |12|0|0|12|0 /0|existing valid skip|
| resource replacement |3|0|0|3|1 /4|two explicit dirty measurements|
| ancestor width narrow |4|0|0|4|1 /2|one dirty ancestor; changed constraints|

The rebuild-reason bits are1=rebuild_layout,2=topology_changed,4=poisoned. Every structural keyed edit records exactly2, demonstrating that ordered identity/rank changed even without explicit rebuild/poison. In insertion,267 old capabilities are discarded,269 inserted and269 layouts written. Removal discards269 and inserts267; reorder discards/reinserts267. Full reconciliation/index/paint traversals remain. Core computed/cached answers in keyed insertion11/1, cheap leaf answers779; this is not269 expensive intrinsic cache misses. The267-node initial arena has only7 allocated caches, so preserving handles does not imply saving267 cache allocations.

Unkeyed reorder is already cheaper:12 semantic/layout handles persist, no layout compute or write occurs, yet704 pixel bytes change. Core layout/style equality cannot authorize reusing paint/resource output. This control must remain cheap in any candidate.

Resource replacement preserves all three handles and all own core Styles, but GPUI calls set_style and explicit mark_dirty for two identities. The compute records4 new answers,1 cached answer,4 measurement queries and1 changed layout write;905 pixel bytes change. The shared measure-marker pointer and core Style do not contain the external text/image values. A candidate retaining handles but omitting explicit dirty calls would lose existing measurement authority.

Changing only an ancestor width56→24 keeps all four handles. The text's core Style and text/font content remain unchanged, but its layout height changes65.376→147.096 and the following sibling's Y changes65.376→147.096. Root overflow changes too. Two measurement queries,5 computed/5 cached answers and4 layout writes occur;2,544 pixel bytes change. Returning width performs1 measurement query,4 computed/6 cached answers and4 writes. Thus surviving handle, cached-answer validity and permission to skip layout are different facts, and dependency effects escape the edited node's own style.

The original keyed following sibling identity10 likewise retains its own core Style while its layout changes on insertion/removal, outside the edited group. This is the same structural constraint behind the prior326-byte missing-damage witness; no new damage optimization is introduced.

## Measurement route and smallest seam

The current callback binary-searches `layout_nodes` for the measured NodeId. A fresh arena appends capabilities in preorder, making that vector sorted. Projecting surviving old handles into the new keyed reorder yields an **unsorted** sequence in both4/256 cases. Merely retaining those handles would invalidate the routing assumption. Semantic order must remain painter/child order; do not sort it to repair lookup.

[SEAM.md](SEAM.md) audits existing insert/remove/reparent/style/measure/dirty/viewport/poison rules and proposes a bounded next experiment: carry the real reconciliation match into a pending rank→existing capability assignment, preserving exact remint rules; reuse the existing core topology/cache engine; insert/retire actual lifecycle changes; apply ordered-child/style/measurement invalidations. A measured-node-only reverse route can avoid a second all-node identity registry, but its construction, comparisons, capacity and lifetime must be charged. Existing append-only reparenting may turn a prefix insertion into many sibling moves; an ordered-before primitive versus append fallback needs explicit accounting. Neither is implemented or selected here.

Full reconstruction remains the failure/poison/unsupported-authority oracle. Old presented Canvas/sheet ownership remains distinct from mutable layout scratch. Full description and reconciliation may still be O(N); avoiding layout reinsertion would be a representation/caching result, not a generic local structural journal, closed damage set or constant GPU update.

## Measured storage and diagnostic cost

Keyed256 insertion's core payload: layout header664B, topology capacity14,336B, lane capacity57,856B, cache heap2,880B (8 caches), runtime handle-vector capacity8,192B; total known83,928B. Initial/removal/reorder have7 caches/2,520B and the same capacities. Ten active styles and one out-of-flow context are reported; style-table/control/allocator/context allocation details are not included in that total. No memory saving has been implemented.

The capture is deliberately expensive diagnostic data:269 rows×456B=122,664B capacity,4,544B child-capability capacity and112B header. Capturing requests131,240B in15 allocations, retains127,208B and peaks129,256B above entry; cumulative requests differ from retained capacity because child Vec growth is temporary. It traverses269 rows/268 edges and two cache-storage scans. Complete core Styles, layouts and qualified handles are copied only after Source; no capture is read by layout or a proposed optimized producer.

The offline identity comparison requests1,569,687B in13,437 allocations; report/JSON formatting2,865,398B in14,567 allocations. Their net deltas452,618B and695,918B are separate from capture storage and from Source. Both old/new captures and accumulated JSON/pixels are retained by this test; these are not production metadata, and no memory/locality claim is based on hiding them. The comparison explicitly counts old map inserts/new set inserts/new lookups/old membership checks and projected-vector capacity.

Actual keyed insertion Source requests581,024B in272 allocations, peak183,344B and net52,783B, including pre-existing test-only cold/semantic observers. Resource Source8,996B/92 allocations; width change20,740B/111. These are scoped allocation observations, not application memory or timings. The earlier complete software endpoint was completion-wait dominated; this trace does not establish producer latency dominance or a speedup.

## Gates and requirement status

Build,18-frame CPU trace, strict Clippy, full input guards, actual canonical ELF/freshness and embedded original-shader provenance pass. Shader verification is build provenance only because this trace does not execute GPU work. Core inventory remains38,145 lines: all added observation/capture code is test-only. Completed cost cache was transferred only after canonical/guard verification, then all seven first-party release packages cleaned. Local2GiB incremental floor; no Mothership use. All scripts/raw results/source/diff are sealed; verifier reconstructs the diagnostic assertions. No failed attempt in this cohort and no timing rerun.

| Requirement | Status |
| --- | --- |
| Contiguous semantic nodes / semantic identity | Existing, same lifetime/remint/rank limits |
| Actual semantic→layout capability loss | Traced at live topology/full-rebuild boundary |
| Handle retention through structural edits | Missing; proposed seam only |
| Retained layout queries/invalidation | Existing core and topology-unchanged GPUI path; not permission to skip on own-style equality |
| Ordered structural/dependency journal | Missing; full producer traversal retained |
| Measurement routing after handle-preserving reorder | Missing; current binary-search invariant would fail |
| Damage/resource/GPU publication closure | Unchanged full paths; nonlocal witnesses and generic gap remain |
| Integrated compression/shared publication/ZGX win | Missing; previous address alternatives closed NOT ADMITTED |

The next implementation should test this specific seam with full layout/producer oracles and charged order/dependency routing, rather than widening the renderer or adding a parallel semantic registry.
