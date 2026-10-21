# Remove the per-compute layout-node lookup table

Read-only source audit of `/root/gpui-ce3/reactivity` at `6b543dab9b` (2026-10-21). No production edits or heavy build. This report is about one scratch map in `Runtime::present_inner`, not a proposal to weaken `NodeId` validation.

## Finding

Before each layout computation, `present_inner` always materializes:

```rust
layout_nodes.iter().enumerate().map(|(index, id)| (*id, index))
    .collect::<BTreeMap<_, _>>()
```

The measurement callback uses that map to turn a `NodeId` back into an index into `self.nodes`. The map is built even when there are no text sites and `LayoutTree` cannot invoke the callback at all. On x86_64 each entry carries a 16-byte `NodeId` plus an 8-byte `usize` payload before B-tree node slack/allocator overhead; at 100k layout nodes that is at least 2.4 MB of live map key/value payload rebuilt on every layout pass. That is temporary CPU/RAM, not retained Runtime state.

The simplest no-API-change candidate is to search the already-retained sorted `layout_nodes` vector:

```rust
let index = layout_nodes.binary_search(&id).expect("measurement ID belongs to this layout");
```

`NodeId` derives lexicographic `Ord` over `(arena, generation, index)`. GPUI rebuilds a fresh `LayoutTree` by inserting exactly one node for every `self.nodes` entry, in vector order. `Tree::insert` appends while the free list is empty, and this runtime never calls layout `remove` or `reparent`; so all IDs in a tree share arena and initial generation and have increasing indices. `layout_nodes` is consequently sorted. Binary search performs no allocation and exact full-ID comparison preserves arena and generation rejection. Its cost is O(log N) only for actual text-measure callback invocations, rather than building/allocating an O(N) map on every layout pass.

The stronger O(1) candidate is an additive borrowed adapter callback, e.g. `LayoutTree::compute_with_slot` whose callback receives `(NodeId, slot, MeasureInput)`. In `Engine::measure`, GPUI's callback ID is reconstructed by `node_for_layout_key`, which checks the current tree arena, generation, and live entry; only then should the adapter derive `tree.slot(id)` and pass it to the callback. This does not expose raw `NodeId.index`, accept any caller-supplied ID, or add a retained per-node lane. GPUI may index `self.nodes[slot]` directly and put a debug assertion on its local alignment invariant: `layout_nodes.get(slot) == Some(&id)`. The ordinary `compute_with(NodeId, ...)` API can remain for compatibility; the new method is additive.

For any reusable public slot API, document that `slot` is only the owning tree's current storage slot, not an identity/capability and not stable across remove/reinsert or tree rebuild. A slightly more self-documenting argument type could be `MeasureNode { id: NodeId, slot: usize }`; it still carries no authority beyond the callback. Do not add a raw `NodeId::index()` getter and then use only the truncated index: that would let foreign/stale-looking IDs collapse to a plausible GPUI vector offset without the full membership check.

## Exact invariant and boundaries

* `core::tree::NodeId` is `{ arena: u64, generation: u32, index: u32 }`, all private. `Tree::index` rejects wrong arena, dead entries, and generation mismatch. Removal bumps generation; a slot at generation exhaustion is retired rather than reused. Thus `(generation,index)` alone is not the public capability; the arena is part of identity.
* Layout's internal `EngineId` intentionally packs only generation and index. It never crosses the API boundary. `LayoutTree::compute_inner` validates its root. Internal keys come only from that tree. `Engine::node` reconstructs a `NodeId` with the current tree's arena and `Tree::node_for_layout_key` asserts it is live. The measurement callback therefore receives a checked node minted by the currently borrowed `LayoutTree`, not an arbitrary ID.
* GPUI inserts layout nodes only in the full rebuild branch, in `self.nodes` order, into a newly constructed `LayoutTree`. Same-topology updates change styles/measurement callbacks but do not remove/reparent nodes. Topology/identity changes set `topology_changed`; text-site appearance/disappearance sets `rebuild_layout`. Reconciliation reuses identities only under the same parent identity and ordinal/kind (or keyed List parent/key/kind), so reparenting that changes topology retires identity and triggers a rebuild. The current `layout_nodes`/`nodes` slot alignment therefore holds for this path.
* The adapter already owns the topology and validates complete IDs for public style/layout operations. The callback slot is computed internally from the checked ID; it must never become an alternate external lookup API.

## Why not build a map only when text exists?

Guarding the current map with `if !self.texts.is_empty()` is an easy partial fix. It eliminates the O(N) map cost for textless windows, but still builds a full-node map when a window has one measured text node, and recreates that table on every geometry or viewport layout pass. Since the existing `layout_nodes` vector already contains the complete key ordering, a binary search is less state and less work for sparse text. The slot callback removes both the scratch map and per-measure tree search while adding no retained storage.

## Framework evidence and limits

* Taffy's official `custom_tree_vec.rs` example stores layout nodes in a `Vec` and converts its own `NodeId` directly to a vector index (`usize::from(node_id)`) for layout and text/image measurement. This is a concrete UI-framework precedent for aligning an engine node identifier with dense app storage, but Taffy's example's ID model is not GPUI's arena+generation capability and should not be copied literally: [Taffy custom vector tree](https://github.com/DioxusLabs/taffy/blob/main/examples/custom_tree_vec.rs), read 2026-10-21; its documented tree API is [Taffy 0.14.0](https://docs.rs/taffy/0.14.0/taffy/tree/index.html).
* Bevy's entity docs explicitly distinguish `EntityIndex` from generation: a raw index is unique only among simultaneously live entities, while index+generation identify a particular entity. This is the relevant caution against replacing a validated capability with the low index bits: [Bevy ECS entity docs 0.20.0](https://docs.rs/bevy_ecs/0.20.0/bevy_ecs/entity/struct.Entity.html).
* Bevy's engineering note on table/sparse-set storage describes the extra entity-to-dense-location lookup/indirection of sparse sets and the faster contiguous iteration available once storage is aligned. This supports the data-layout tradeoff, not a GPUI benchmark result: [Bevy 0.5 storage discussion](https://bevy.org/news/bevy-0-5/).

These sources establish patterns, not expected GPUI speedups. The relevant local proof is the current insertion/lifecycle invariant above.

## Acceptance gate

Use a paired release build with the existing output/geometry oracle and isolate the map change. Measure `layout_runs`, `measure_calls`, allocation calls/bytes, and prepare p50/p95 for: a 100k-node textless tree with a geometry edit (the map currently does useless work), one measured node among 100k, dense text at 100k, repeated text edits, resize-only, and topology rebuild. Require identical geometry and draw results; core stale/foreign-ID tests remain unchanged. For binary search, assert `layout_nodes.windows(2).all(|p| p[0] < p[1])` on rebuild and assert every callback ID resolves to the corresponding GPUI slot. For the slot API, assert each callback's `(id, slot)` matches `layout_nodes[slot]`; add a core test that remove/reinsert reuses a slot with a different generation while the callback reports only the new live ID. The no-text case should show no lookup table or map allocation; do not claim the entire presentation becomes allocation-free because unrelated scene/layout scratch may still allocate.
