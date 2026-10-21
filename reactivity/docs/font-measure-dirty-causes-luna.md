# Font/text layout invalidation: exact dirty causes

Read-only review of cleanroom runtime at `b20a627b08` (2026-10-21), its retained layout adapter, and primary Yoga/Servo/Bevy material. No implementation or benchmark was run.

## Finding and smallest safe change

The runtime currently uses one `layout_dirty: BTreeSet<u64>` for two different reasons: the translated Cephal style changed, or a measured text answer changed. `layout_changed` includes `font_size`, while `layout_style` omits it. Text-value edits also enter the same set. In `present_inner`, every member is passed through `list::row_style`, `LayoutTree::set_style`, and then `mark_dirty`. The font/text-only call therefore rebuilds a derived `cephal::Style`, performs a Cephal style equality check that must return equal, and explicitly invalidates measurement anyway. `LayoutTree::set_style` already returns `false` before interning when styles compare equal; the redundant part is caller-side construction/comparison and unconditional invalidation through the style path, not a Cephal style-table allocation.

Track the reason at the existing dirty-source sites and merge it into the existing one dirty index, e.g. replace `BTreeSet<u64>` with `BTreeMap<u64, DirtyBits>` (`STYLE`, `MEASURE`). This adds no Runtime field or per-node retained lane; the B-tree value-slot cost must be measured against the current set before adopting. Alternatively, test an optional second set if the map has worse update cost. For each dirty identity:

* `STYLE`: build `row_style` and call `set_style`. If the style actually differs, that call already marks the node and its parent pending.
* `MEASURE` only: call `LayoutTree::mark_dirty` without constructing a Cephal style.
* Both bits: call `set_style`, then call `mark_dirty` only if `set_style` returned `false`. The latter can happen when an authored field difference maps to an equal Cephal style (including float `PartialEq` corner cases), and a concurrent text/font measurement change still must be invalidated. This avoids both the false-negative and a duplicate mark when style did change.

Make `layout_style_changed` compare the exact authored inputs that feed `layout_style` (`width`, `height`, `gap`, `padding`, `flow`), not `font_size`. Add `MEASURE` when the font size changes on a node with a text site, or when its text content changes. Text-site appearance/disappearance still takes the existing full `rebuild_layout` path because it adds/removes the measurement callback. Paint-only fields continue to avoid layout dirtiness.

Retain the current auto-width List repair: a changed parent's `Flow` can alter the synthesized grow/basis on an immediate List child. Only do the existing scan of `self.lists` when at least one `STYLE` cause exists, and add `STYLE` to those child List identities whose parent's flow changed. List-row y/height slot changes remain `STYLE` because `row_style` synthesizes absolute top/height. A font/text-only change must not trigger either derived List style refresh. A future inherited-font feature would change this dependency graph and must explicitly add descendants to `MEASURE`; current style resolution has no inherited font propagation.

This is work removal, not a layout fast-path claim: changed text and font still need shaping/measurement, and parent constraints/layout may change. The expected savings are the repeated `row_style` translation, Cephal style equality checks, and parent-list scan on measure-only edits. There is no extra retained field and the dirty map changes only when dirtiness already exists.

## Counterexamples the dirty-cause gate must reject

1. **Parent flow plus auto-width List:** change a parent from column to row while a child List has no explicit width. The child must receive synthesized `flex_grow=1` and zero basis. The style cause must still propagate to this child.
2. **Parent text measurement changes:** changing a text parent's font or content can change its intrinsic size and child constraints. It is `MEASURE`, and the layout engine must recompute dependent children through its existing scheduler/cache contracts.
3. **Virtual row slot moves:** scroll/replan can leave row identity stable but change synthesized absolute top/height. It is `STYLE`, not a measure-only event.
4. **Font on a textless node:** no text shaping depends on it in the current non-inheriting style model; it must not force layout. If a measured text site exists, font change must invalidate that measure even though `cephal::Style` is unchanged.
5. **Mixed text and width change on one identity before prepare:** OR both causes; apply style once. Keep the measure invalidation if `set_style` returns equal; if it returns changed, its node+parent invalidation covers the measurement too.
6. **Text site is added or removed:** use the existing rebuild path to install/remove `measure_marker`; a `MEASURE` bit alone cannot replace callback-topology maintenance.
7. **Presentation fails after invalidation:** dirty causes must remain available for retry; clear them only at the same successful-preparation point where `layout_dirty` is cleared today.

## Evidence from current code

* `runtime.rs::layout_changed` compares width/height/gap/padding/**font_size**/flow. `layout_style` converts width/height/gap/padding/flow and does not use `font_size`.
* `set_property` inserts `layout_dirty` on `layout_changed`, clears the cached `TextSite.shaped` when font size changes, updates `Node.style`, and then describes/presents.
* Reconciliation inserts `layout_dirty` on text replacement and on `layout_changed`; it separately clears `shaped` for font changes. Text-presence changes set `rebuild_layout`.
* The successful `present_inner` branch clears the dirty set only after publishing `Prepared`; failed preparation preserves retry state.
* `LayoutTree::set_style` returns immediately on equal Cephal style, before interning; on a differing style it marks the node dirty and queues the parent because flex parent algorithms read child style. `mark_dirty` invalidates a measured node (or its parent for cheap leaves). `compute_with` is explicitly the borrowed measurement seam; its docs require external inputs to mark measured nodes dirty before their answers change.
* `list::row_style` additionally synthesizes List flex grow/basis from parent flow and ListItem absolute position/height from its virtual slot. That is why a global “only compare style on width/height/etc” rule is unsafe unless these derived inputs remain covered.

## Primary implementation comparisons (what they do and do not establish)

* Yoga's incremental-layout documentation says style/children changes dirty a node and its ancestors; clean nodes are skipped only while parent constraints are unchanged. This supports cause propagation plus constraint validation, not skipping text measurement after text changes: [Yoga incremental layout](https://github.com/facebook/yoga/blob/main/website/docs/advanced/incremental-layout.mdx), current `main` source page read 2026-10-21.
* Servo's current `ServoRestyleDamage` exposes distinct `REPAINT`, stacking-context rebuild, overflow recalculation, and relayout damage flags, with propagation semantics. Its older layout overview describes a per-CSS-property damage map and explicitly says it currently keys on changed property, not value-dependent interactions. This backs the *shape* of impact classes and warns against claiming smart property-value elimination from a simple flag: [Servo damage API](https://doc.servo.org/style/servo/restyle_damage/struct.ServoRestyleDamage.html), [Servo layout overview (historical, as of 2016)](https://github.com/servo/servo/wiki/Layout-Overview).
* Bevy's official change-detection example demonstrates an equality gate (`set_if_neq`) because mutable access otherwise marks a component changed even for equal values. It does not provide a layout impact graph; here, current equality gates already avoid unchanged `Style` mutation, while this proposal separates two unequal causes: [Bevy change detection example](https://github.com/bevyengine/bevy/blob/main/examples/ecs/change_detection.rs), current `main` source page read 2026-10-21.

## Exact acceptance test and benchmark

First add counters for `layout_style_translations`, `layout_style_updates`, and dirty-cause counts (style-only, measure-only, mixed). Compare baseline and candidate with identical scene and output oracles. Cases: text-only replacement at 1k/10k/100k nodes; font-only edit on text and textless nodes; width-only; parent-flow flip around an auto-width List; List row-slot scroll; same-node text+width; failed prepare then retry. The candidate must preserve geometry, hit targets, semantic output, draw output, and measurement results byte-for-byte under the existing tests. On text/font-only edits, require zero style translations/updates and unchanged measurement calls relative to baseline; style update counts remain equal for true geometry/List changes. Gate on paired release-mode p50/p95 prepare time and allocation counts; do not accept if the new dirty-map footprint or dirty insertion cost erases wins on the common 1-site text edit. Include clean/idle windows to prove no retained per-node or per-window tax beyond the chosen dirty-index representation.
