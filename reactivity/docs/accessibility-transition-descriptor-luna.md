# Exact sparse accessibility transitions without a second tree

Research/review: 2026-10-21. Read-only review of the current `reactivity` source and the pinned AccessKit 0.25.1 / AccessKit Consumer 0.39.1 APIs. This narrows the earlier [incremental projection note](accessibility-incremental-luna.md) to the transition descriptor and its failure modes. No production code was changed.

## Recommendation

Use one latest-transition record, built only while a native accessibility adapter is active. During the existing `present_inner` preorder walk, compare each candidate `Presented` entry and its frozen semantic metadata with the corresponding acknowledged P entry. Keep only sorted changed P indices, capped at a small measured limit; switch to `Full` as soon as identity/parent/synthetic-child topology changes or the cap is crossed. The record is a transition, not a second tree: no node copies, hashes, identity map, or retained per-node dirty flag. Inactive presentation performs no semantic comparisons and retains no descriptor allocation. Activation always projects a complete current P.

The descriptor must be based on the last *acknowledged* P stamp. `latest_token` is set by `present_inner` before acknowledgement, so it can refer to an unacknowledged candidate while `presented` still contains the older P. It cannot prove the base of a delta. Store the acknowledged sequence in the runtime (`Option<NonZeroU64>`, 8 bytes; minted sequences already start at one, so `None` denotes no acknowledged token) and pair it with the existing `presentation_epoch` and size. The token's window namespace is constant within a runtime, so no second namespace field is needed. This small persistent cursor is preferable to allocating a cold state object and complicating candidate/ack paths.

Each transition is stamped:

```text
base = (acknowledged_sequence, presentation_epoch, presentation_size)
target = (candidate_or_metadata_sequence, target_epoch, target_size)
change = Full | Sparse(sorted P indices)
```

For a metadata-only publish, base and target sequence may match while epoch advances. For resize, relayout, scroll, or a new presentation with no source epoch advance, sequence changes even if epoch does not. `Bridge` may apply a sparse transition only when its published cursor exactly equals `base` and the descriptor target equals current acknowledged P. If an activation occurred, a transition was overwritten/coalesced, a candidate stamp is unavailable, a resize/size change cannot be handled sparsely, or any stamp mismatches, rebuild the full tree. One latest transition is sufficient: missing an intermediate update makes the next base differ from the adapter cursor and forces full projection.

## Exactness conditions

The current projection exposes role, effective name, description, value, list position/count, actions, tree focus and full window-physical bounds. It does not expose `Presented.bounds` (the viewport-clipped rect) or `hittable`; native bounds come from `Part::unclipped_bounds()`. Do not treat changes to those private fields as native changes, and do not omit a change to local rect or the flat absolute transform just because clipped bounds stayed the same.

While comparing old P to candidate P in the existing presentation pass, use these rules:

1. **Topology gate first.** Require equal P lengths and, at every slot, equal stable identity and equal parent slot. Since the identity sequence must also match, equal parent slot implies equal parent identity. Require equal synthetic-child shape for every slot: `part.value().is_some() || renamed_text(part)`. `renamed_text` is semantic: a text name override can replace a Label node with Group + odd-ID Label child. Any mismatch switches to full projection; this safely covers clipping membership changes, row-key replacement/reorder, reparent, insertion/deletion, and adding/removing the synthetic text child.
2. **Semantic field comparison.** For stable slots compare role/kind, frozen actions, text/value presence and bytes, effective name, description, list container count, and row position. `Set(None)` is meaningful and must compare as `None` against fallback text rather than being collapsed into “no annotation.” Comparing strings by contents is exact and avoids relying on `Arc` identity. A text/value change with a stable synthetic child still marks the owning P index; its emitted replacement must include the current synthetic odd-ID child and content.
3. **Geometry comparison.** Since the current AccessKit node stores an absolute physical envelope derived from `rect + flat transform`, compare local rect and each transform coefficient bitwise, and compare absent-map with absent-map as `None`. Do not compare the NaN sentinel `PresentedTransform` as a whole: NaN compares unequal to itself. Bitwise comparison intentionally allows conservative extra updates for signed-zero changes; it must not miss a representable geometry difference. Size change forces full projection because it also changes the root window node. Transform changes can be compared more tightly later against the final derived bounds, but only after exact consumer equivalence is tested.
4. **Bounded delta.** Keep indices in P preorder. Once a chosen cap is reached, discard the index vector and mark `Full`; continue only as needed to finish the already-required presentation. Select the cap from measured output cost, not an assumed percentage. This bounds active-only scratch, e.g. a 4,096-index limit is at most 16 KiB before vector capacity overhead. Full-tree fallback remains the expected winner for list scroll/high churn.

The comparison must be semantic, not `Presented: PartialEq`: a raw-struct comparison would treat the absent-map NaN sentinel incorrectly, include `hittable`/clipped bounds that are not currently emitted, and miss cold metadata stored in the sidecar. A helper should compare exactly the public fields emitted by `projected_node`, with conservative bitwise geometry.

### Building a sparse AccessKit update

AccessKit `TreeUpdate` replaces each submitted node in full; order in `nodes` is irrelevant. Its contract says an unchanged field must be resent, adding a child requires the new child and updated parent, and removing a child requires an updated parent omitting it. Therefore a sparse update cannot contain a partial node patch. Pinned schema: [AccessKit 0.25.1 `TreeUpdate`](https://github.com/AccessKit/accesskit/blob/ce8164ba92995cfa86005b6259115e08c8244253/accesskit/src/lib.rs#L3208-L3235). Consumer application retains old and next states and computes changes in `update_and_process_changes`; it has no public API for GPUI to borrow an internal consumer node or diff mirror: [pinned Consumer tree source](https://github.com/AccessKit/accesskit/blob/ce8164ba92995cfa86005b6259115e08c8244253/accesskit_consumer/src/tree.rs#L620-L685).

For changed nodes, re-project the complete `Node`, including unchanged role/name/value/description/actions/bounds. Under the stable-topology gate, reconstruct every changed node's complete ordered children list. A no-map method is to add `SemanticSheet::len()` and `part_at(index)` and walk only the changed indices plus their P preorder subtrees. Direct children are the following slots whose `parent == changed_index`, stopping at the first later slot that is outside that subtree; append the node's synthetic odd-ID child in the same order as the existing full projector. A changed leaf then costs O(1) P access and one conversion; a changed non-leaf costs its subtree scan/list rebuild but avoids converting unrelated P nodes. If helper/API complexity outweighs the measured win, keep full-tree projection.

Always set `TreeUpdate.focus` to the latest focus that exists in the same acknowledged P, or root if no current P node is focused. A focus-only change is an empty node vector with the new focus. Focus is live and can change without P; it is not part of the frozen node delta. If a semantic delta is empty but its epoch advanced, the bridge still advances its local stamp even if it need not call AccessKit. It must not let the next transition appear to have a missing base.

## Metadata-only publication

`Runtime::publish_metadata` has three materially different paths. `Publish::All` freezes a new sidecar over P; `Publish::Identity` and `Publish::Field` patch one or more semantic entries. If there is an outstanding `Prepared`, metadata can be patched into `metadata.candidate` after its P comparison was made. The first exact implementation should mark that prepared transition `Full` on any such post-prepare patch. Otherwise the descriptor would omit a name/description/list change even though `acknowledge` publishes the patched candidate sidecar.

For a metadata-only publish with no outstanding candidate, exact sparse indices can be collected without a second tree:

- `Publish::All` already walks all current P entries to freeze metadata. Compare each entry's old and new effective semantic output during that same walk.
- `Publish::Identity` can do one P identity scan and record its index if visible; a clipped/unpresented identity yields no native node change.
- `Publish::Field` can collect affected identities from existing fanout destinations, then make one P pass comparing old/new effective output. Do not persist an identity set or index map.
- List count belongs to the list container node; row reorder/reindex changes `position_in_set` on every affected realized row. Compare these frozen values too. New/removed P rows still use the topology fallback.

If this metadata path proves too complex, mark metadata-only publications `Full`; that is exact, but it forfeits the sparse name-edit case. Never use `presentation_epoch` alone as a “nothing changed” test. If the prepared sidecar was mutated after candidate generation, force full even if metadata-only immediate publications are sparse.

## Lifecycle and adversarial cases

- **Repeated or missed acknowledgements:** `base != Bridge.published` forces full. A full transition can replace a lost delta; do not compose deltas without proof.
- **Candidate token before ack:** A failed or superseded preparation leaves old P authoritative. Do not stamp it with `latest_token`; retain the acknowledged sequence separately.
- **New token, same epoch:** resizing or list scroll can change P without source changes. Compare sequence and size; do not skip by epoch.
- **Same token, new epoch:** metadata publication can change names/descriptions/list metadata without a new visual token. Compare epoch and use an exact metadata delta or full fallback.
- **P size or scale:** size change uses full projection. Scale can change geometry while size and source epoch stay equal; the new sequence and per-node geometry comparison must catch it.
- **Synthetic text child:** changing a text name from equal-to-text to a different explicit name (or `Set(None)`) changes Label/Group shape. Force full. Changing text content with the same shape changes both the owner node as applicable and odd child; send them completely.
- **List viewport:** the visible row count can stay fixed while row identities change. Identity sequence catches that. A same-identity row reindex or same-row list count change is semantic metadata and must mark row/list nodes.
- **Focus to an unpresented node:** never publish an S-only target. Resolve focus against P; use root if absent.
- **Surface lost and restored:** `presentation_valid == false` revokes coordinate authority for a surface-lost P; it does not erase or mutate the native adapter's retained consumer tree. If the same P is re-acknowledged with unchanged token/epoch/size, republishing it is redundant. Do not add a validity generation or force a full projection without a concrete changed semantic field. A focus change during the invalid interval is live state: after P becomes valid, compare current focus with `Bridge.published.focus` and send the normal empty-node focus update if it differs. An A→B→A interval needs no update because B was never published to the native tree. A new Bridge still has `published == None` and correctly builds a full tree.
- **Inactive period:** do no node conversion and no transition-vector allocation. Activation request sets a pending idempotent bit and forces full current P, independent of any prior transition cursor. Deactivation discards scratch/cursor trust; the next activation is full.

## Cost and shipping gates

This removes native `Node` construction and AccessKit update allocation for unchanged P nodes. It does **not** eliminate the existing presentation walk or its layout/paint work; active presentation adds comparisons and bounded changed-index scratch. It also does not make AccessKit Consumer's retained full tree incremental by exposing it to GPUI. Measure total owner-turn and consumer update cost, not just count of calls to `projected_node`.

Gate on a pinned Consumer oracle: apply each sparse transition to `Tree::update_and_process_changes`, separately rebuild the complete tree from new P, and compare resolved role/name/value/description/actions/relationships/ordered children/focus/bounds. At 100k stable nodes, a one-leaf rename should convert one GPUI node (and any required text child), while a focus-only update converts zero. A changed non-leaf replacement must retain its full unchanged children. Repeated acknowledgement/missed transition, metadata patch-after-prepare, same-epoch resize/scroll, same-token metadata edit, list-count/reindex, and synthetic-child shape changes must either match full rebuild or deliberately fall back to full.

Benchmark inactive, activation, sparse leaf, sparse non-leaf, metadata edit, focus-only, and high-churn list scroll separately at 10k/100k P nodes. Record active comparison cost, changed-index bytes, GPUI node conversions/allocations, AccessKit consumer tree nodes touched, and p50/p95/p99 owner turn. Keep the full-tree path for the losing case; the optimization is worthwhile only if sparse stable updates repay the active comparison and child-list work.

The corresponding source seams are [runtime `Prepared`/`Presented` and `present_inner`/`acknowledge`](../../../gpui-ce3/reactivity/crates/gpui/src/runtime.rs), [metadata freezing/publication](../../../gpui-ce3/reactivity/crates/gpui/src/runtime/metadata.rs), [borrowed semantic sheet](../../../gpui-ce3/reactivity/crates/gpui/src/runtime/query.rs), and [native bridge](../../../gpui-ce3/reactivity/crates/gpui/src/native/accessibility.rs). Baseline framework/adapter and platform activation findings remain in [accessibility-frontier-luna.md](accessibility-frontier-luna.md).
