# Changed solver outputs → placement/clip work

Source-only bounded next-cut report. No runs/builds. Companion: SOLVER-DEPENDENCY-CUT-20261026.md.

## Exact current placement inputs

`gpui/src/runtime.rs` present_walk (~3580–3700 in moving source):

```
parent_space = root_scale OR inherited wide CoordinateSpace
parent_space = parent_space.translated(-parent_viewport_offset.x, -offset.y)
space = parent_space.compose(translation(own layout.location))
                    .compose(own style.transform)
rect = (0,0, own layout.size.width,height)
```

Parent size, baseline, and overflow do NOT occur in child's world-space composition. Parent padding affects children only if solver changes their actual location. Parent allocation may change children's own solver sizes/locations; collect those actual writes, not infer all descendants moved.

CoordinateSpace keeps six **f64** intermediates and an `uncertain` bit (`core/geometry.rs:185–243`); final paint transform narrows to f32 only afterward. A wide parent can change below f32 precision but amplify in descendant composition. Therefore compare outgoing wide space, not Presented/Canvas f32 transform. Include uncertainty and bit-exact coefficient inputs for conservative cache identity; PartialEq includes uncertainty but treats signed zero equal. Never use old P geometry as old canonical C when ACK is delayed.

## Outgoing channels are independent

| changed output | own work | descendant propagation |
|---|---|---|
| local location/style transform | own world transform/bounds/primitive/hit | only if outgoing wide space changed |
| local size | own rect/primitive/content box; possible clip/viewport | NOT transform by itself; clip only when outgoing clipping changes |
| baseline only | solver parent baseline consumers | no world transform/clip edge by itself |
| scrollable overflow only | solver overflow consumers; own scroll extent | world transform only if clamped effective offset changes |
| text/content box | own text/image placement, primitive bounds | only actual child solver/location or clip outputs |
| parent identity/order/topology | actual reparent/ordering/publication linkage | structural fallback or proved repaired identity mapping |

A constraint INPUT is not a changed geometry OUTPUT. Current Layout→Placement transitive phase seeding speculates that output changed before solving. Remove that eager edge only together with actual solver-output facts and an honest conservative fallback for unresolved downstream work; otherwise this simply renames the old SCC as an all-descendant Placement closure.

## Actual clip inputs and branch conditions

The outgoing ClipFrame carries raster rectangular clip, hit/broad-phase clip, nested semantic chain, published-parent linkage, and List/Scroll membership bits. It is not one interchangeable rectangle.

- Root clip reads physical viewport/sample profile. Resize/scale/global pipeline changes need full conservative admission until globally indexed.
- List/ListItem/Scroll run `list::viewport_clip` on inherited raster/hit rectangles, **own world transform and size**, target dimensions. It rejects unsupported non-axis-aligned world transform, validates coordinate limits, lowers raster clip with sampled_rect_clip, and independently builds outward hit envelope (`runtime/list.rs:235+`). Keep these error/precision boundaries.
- clip_children appends rounded own rect/radius/world transform to existing chain. Chain can be inherited even when own clip_children false; viewport inside a chain also appends own rectangular clip.
- Changing an ordinary non-clipping box's size does not alter inherited child clips. Changing an active clip/viewport box's size may alter outgoing clip while world transform remains unchanged.
- ClipId values are freshly scene-local; pointer/ordinal/ClipId equality across C is NOT semantic equality. Compare immutable semantic chain descriptors or stable canonical clip resource identity+generation, not new IDs. Hit rect equality alone is insufficient (rounded shape/radius/nested chain may differ while envelope identical).
- Parent omitted/publication link and List/Scroll membership can change descendant semantic parent/visibility even with same space and clip envelope. Compare full logical parent identity, not shifted published ordinal, and retain visible_rows/target capability checks.
- .clip() is GPUI geometric clipping, NOT Cephal Overflow/Contain; it does not suppress solver overflow dependencies.

## Scroll is a separate value boundary

`runtime/scroll.rs::geometry:308–456` reads viewport layout size/scrollable_overflow, then (when Scroll exists) performs an additional whole-node wide-space/bounds pass, with resets at List/Scroll boundaries, to derive actual transformed descendant extents. Finally it clamps requested offset to min/max. Size/overflow/descendant-transform changes can move the effective offset even when no user scroll request changed; that offset then changes descendants' placement.

Do not claim this pass vanished with placement-SCC removal. First cut may preserve it explicitly. Next safe optimization requires actual nearest-scroll membership and changed old/new extent contributions; union/max shrink/removal needs retained owner contributions or conservative rescan of affected scroll subtree, not a delta-only max update.

## Bounded implementation sequence

1. Add changed-output sink exactly where core Engine.set_unrounded_layout already compares old/new. Separate location, size/content box, overflow, and other solver outputs; no second full Layout mirror/scan. Size-only query answers need solver callback if claimed, not final-layout sink alone.
2. Use output-specific seeds rather than Layout→Placement for everything. Without exact output completeness, mark full canonical snapshot work; never let incomplete receipt enter slot-only path.
3. In the EXISTING present walk, compare outgoing wide-space and semantic clip contexts for visited affected boundaries. Initially reduce emitted dependency work without claiming traversal elimination. Actual subtree skipping needs retained OLD C contexts (not P), full identity/parent capability, exact material/text/resource membership, and reuse of immutable accepted group commands. Price any sparse context store; do not silently add48+bytes per logical node.
4. Only after exact accepted-context ownership exists, use a bounded frontier of affected roots. Skip child transform propagation when incoming context unchanged AND own solver/style inputs unchanged. Independently continue clip/semantic propagation if those outgoing contexts changed. Bound frontier/visited cells; overflow→full. No parallel private fixed-point.
5. Failed newer stages never mutate accepted context/group store; successful C atomically installs new context witnesses with batch/groups. Dropped stage, old eligible C ACK, viewport resize, and resource mutations retain existing rules.

## Required falsifiers

- Parent width/height changes but fixed-position/size child location and outgoing wide space unchanged: no all-descendant transform invalidation; full cold rows/layout/pixels exact.
- Same parent size but align/justify/sibling order changes child local location: child movement MUST occur.
- Parent size change with no clip vs active rounded clip: own geometry changes in both, outgoing clip only latter. Radius change with identical AABB still affects descendants.
- Root/local baseline-only change and visible-overflow-only vs Scroll boundary: no transform propagation unless actual position/effective offset changes.
- Shrinking Scroll content clamps offset and moves all visible descendants; changing offscreen extent without offset change must not fabricate movement. Remove max-contributing child control.
- Large f64 cancellation / near-equal f32 parent transform but different descendant output; rank-loss uncertainty, signed zero/nonfinite admission remain conservative.
- Nested List/Scroll/clip, omitted ListItem with descendants, shifted published ordinals: exact full logical identity, visibility and semantic parent checks.
- Pending C1 then C2 then failedC3 with P still C0: reuse against actual C base only, old eligible ACK remains valid; no context from P substituted.

Measure actual world/clip recompositions and frontier visits separately from full presentation/group lowering, solver LayoutStats, and raster work. No clean timing claim from source structure.

## 00:44 follow-up: no full f64 mirror prerequisite

Actual old storage is insufficient NOW: current Node links, Styles and LayoutTree are mutable working state; Prepared/Presented placements/bases are narrowed f32 and can omit rows, and P may lag accepted C. A first-write bounded BEFORE-image journal is enough for a narrow unchanged-topology cut, without per-node f64 storage:

- Capture earliest old local layout location (f32 pair) at solver changed-write sink BEFORE overwrite; old size/content fields only when needed for own/active clip reconstruction.
- Capture earliest old local style.transform at ordinary direct/mapped/coarse style write, and old radius/clip flag for changed geometric clip inputs.
- Retain journal through dropped/failed C; clear only after successful canonical publication. Earlier failed solve writes must already be captured; enabling/repairing mid-invalid cohort falls back until a complete baseline is established.
- Root accepted scale/global clip and effective viewport offsets need accepted-old before images too. Initial cut can conservatively fall back on topology changes, viewport/scroll participation/config changes, or budget exhaustion; no interaction-name dispatch.
- Reconstruct old and new root→affected paths simultaneously from CURRENT unchanged local inputs plus journaled OLD changed inputs. Full identity/parent capability must agree; no parent reconstruction from old published ordinal. Deterministic original composition order retains exact wide intermediates and uncertainty.
- Build bounded dirty-owner+ancestor set from actual changed writes; dedup shared ancestors. Walk existing retained core Tree children/next_sibling links, not a new topology. If inherited contexts are equal and child is outside dirty-ancestor set, skip its whole subtree. Context changes visit descendants until equality restores; own pending local changes still force relevant paths. `Tree::children/next_sibling/parent` are public checked full-capability APIs (tree.rs158–169); Preorder::skip_descendants exists crate-private, so no subtree-end array is required.
- Work memory O(changed locals + union of ancestor paths + depth), bounded by explicit visit/metadata budget, worst O(N) but never unconditional48bytes×N. Ancestor expansion may O(K·depth) before dedup; price/bound it and fall back. Do not claim a sublinear guarantee on tall chains.

The local BEFORE-image journal does NOT by itself permit skipping current full command/presentation reconstruction. Immutable accepted group reuse and output/semantic membership must independently qualify. Without that consumer, this only avoids redundant dependency/recomposition jobs; retain and price the conservative present walk.
