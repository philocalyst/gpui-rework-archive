# Typed borrowed virtual-list API review

Audit base: `/root/gpui-ce3` at `d8b1f75a5d63ac002ba9da5c3306e1689a88668f` (exclusive `&mut Win` owner). Hummingbird comparison is pinned to `e15e8ba0ef6ff5445294030d373e3c8ccc7d780c` and the detailed source audit in [hummingbird-source-audit-luna.md](</root/designs/reactivity/rework/hummingbird-source-audit-luna.md>). This is a design review only; no production code was changed.

## Recommendation

Add one fixed-row-height virtual list as a *description-time borrowed source*, not as another renderer or persistent collection framework. Public callers pass a source by reference, a finite positive row height and finite explicit viewport height, plus a row builder. During one `Win` description, after list scroll offset and viewport are known, the implementation asks for keys/items only in the visible interval and bounded prefetch interval, builds those ordinary `El` rows, and drops the source borrow/builder before retaining the ordinary runtime nodes. Retain only list-level scroll/anchor state and the current realized keyed rows. Do not retain a borrowed closure, clone the parent model into each row, create `El`s for all items and clip them later, or create a separate GPU list packet.

For the first acceptance slice, use an explicit `viewport_height` (width remains normal flex), as the current `View::view(&self) -> El<'_>` has no viewport argument and `Runtime::describe_inner` flattens the view before Cephal layout. Do not guess a nested `h_full` height at description time. A future two-pass measured viewport can lift this limitation. This narrow API is sufficient to demonstrate the 250,000-ID list without huge spacer nodes or framework-wide layout changes.

## Source facts and constraints

The current element API owns every child `El` in a `Vec`, and `ChildSeq::Iter` eagerly appends iterator contents; lowering then flattens every node. The runtime rejects more than 100,000 drafts (`MAX_NODES`) before layout, so 250,000 row descriptions fail even if every offscreen row is transparent or clipped. References: [`El` and `child`](</root/gpui-ce3/reactivity/crates/gpui/src/element.rs:189>), [iterative flatten](</root/gpui-ce3/reactivity/crates/gpui/src/element.rs:338>), [`ChildSeq` iterator implementation](</root/gpui-ce3/reactivity/crates/gpui/src/element.rs:433>), and [`MAX_NODES`/flatten admission](</root/gpui-ce3/reactivity/crates/gpui/src/runtime.rs:27>), [runtime description](</root/gpui-ce3/reactivity/crates/gpui/src/runtime.rs:1027>). The virtual-list path must bypass building the offscreen `El`s; clipping alone does not reduce node count, description work, semantic-query work or retained memory.

Current site identity is `(parent identity, sibling ordinal, node kind)`, and an unkeyed sibling run survives only when the old and new child counts match. Prepend changes ordinals and count, so these nodes are deliberately reminted rather than silently retargeted (`runtime.rs:1093–1148`). That is correct for ordinary unkeyed children but cannot provide stable row identity under prepend/sort. Current `Target` is a window namespace plus non-reused identity (`identity.rs:10–46`). Keep this action capability separate from data identity.

The presented vector currently contains the whole description; query `visit/count/one` reads that vector, and hit testing filters by geometry at dispatch. A virtual list must publish only currently visible/actionable realized rows into the semantic and hit authority of an acknowledged presentation; offscreen prefetch rows may exist as retained render scratch but are not currently visible and cannot resolve as hit/query targets. See [`Presented`](</root/gpui-ce3/reactivity/crates/gpui/src/runtime.rs:290>) and [borrowed queries](</root/gpui-ce3/reactivity/crates/gpui/src/runtime/query.rs:61>).

Hummingbird's pinned table explicitly uses `Arc<Vec<Identifier>>` for the complete sorted result IDs but materializes row entities only over viewport plus bounded movement-adaptive prefetch, then prunes outside that range ([source lines 47–73](https://github.com/hummingbird-player/hummingbird/blob/e15e8ba0ef6ff5445294030d373e3c8ccc7d780c/src/ui/components/table.rs#L47-L73), [visible-range row construction](https://github.com/hummingbird-player/hummingbird/blob/e15e8ba0ef6ff5445294030d373e3c8ccc7d780c/src/ui/components/table.rs#L730-L790)). This validates the target workload. It does **not** require all 250,000 rows/details to be resident: list metadata can be O(N) IDs; row `El`s, routes and decoded per-row data should be bounded by viewport+overscan.

## Proposed public contract (shape, not compiled API)

Keep the app-facing source statically typed and borrowed. One plausible narrow trait is:

```rust
pub trait ItemSource {
    type Key: Copy + Eq;
    type Item;

    fn len(&self) -> usize;
    fn key(&self, index: usize) -> Self::Key;
    fn get(&self, index: usize) -> &Self::Item;
}

pub struct UniformListSpec {
    pub viewport_height: f32, // logical units; finite and > 0
    pub row_height: f32,      // logical units; finite and > 0
    pub min_overscan: usize,  // default 5
    pub max_overscan: usize,  // always bounded; default = visible row count
}

pub fn list<'a, S, F>(
    id: ListId,
    source: &'a S,
    spec: UniformListSpec,
    row: F,
) -> VirtualList<'a, S, F>
where
    S: ItemSource,
    F: FnMut(S::Key, &'a S::Item) -> El<'a>;
```

The exact signature may change to match existing `ChildSeq`/`Element`, but preserve these laws:

* `ListId` identifies one list mount within its owner, is unique among simultaneously mounted lists, and is not inferred from row index. `ItemSource::Key` is unique in that list snapshot. For Hummingbird, a newtyped `i64` database row ID is a natural key. The source itself can hold its full ID vector; no per-row `Track` or parent `Model` cloning is needed.
* `row(key, &item)` executes only for `realized_range`; it may borrow the item and capture additional immutable app state for the duration of this one build. It is not retained after the list lowers to ordinary nodes. Item callbacks/actions carry the small stable key by value and mutate the owner through the existing `&mut Win` route. Data/detail fetches remain owned by the external app/inbox layer; this API does not invent async work.
* The list computes `visible_start = floor(offset / row_height)` and `visible_end = ceil((offset + viewport_height) / row_height)`, clamps to `len`, then extends by a bounded overscan. A useful default follows Hummingbird's policy: min five rows, increase with viewport rows and recent start-index movement, but cap at the viewport count or an explicit safe maximum. No operation visits all N rows except the source's own data-management update.
* Layout is the explicit list viewport height, not total content height. The apparent scroll extent is wide metadata `len * row_height` in `f64` (or checked integer/fixed-point units); no million-pixel spacer, child rect or parent transform is created.
* Native wheel/drag scrolling and tests call the same owner operation, for example `Win::scroll(list_target, delta)` and `Win::scroll_to(list_target, position)`. Runtime owns the current offset keyed by `(list mount identity, item-source incarnation)`, so input remains an exclusive `&mut Win` operation and no `Cell`/`RefCell` scroll handle is required. Return the ordinary `Commit`: scrolling changes the prepared/presentation epoch but not the app's data/source epoch. Restore APIs can set/read a serializable `ScrollPosition` explicitly. If the source count shrinks, clamp offset to `max(total_extent - viewport_height, 0)` before calculating the range; empty list is offset 0/range `0..0`. Resize updates the effective clip/viewport and clamps again before row materialization.

The fixed viewport is an intentional first gate. Later, nested auto-sized lists require a measured-layout pass that resolves list viewport heights before realization. Do not implement that future mechanism by guessing from the window size: a nested sidebar/list's viewport can be smaller than the window, and parent padding/headers consume height.

## Identity: stable key vs. actionable target

Use the source key as the stable identity for row state, selection, async row-data association, scroll anchoring and semantic reporting. A key's identity does not change when its index changes after sort, prepend or refresh. Descendant node identity is scoped by `(list mount, item key, local descendant identity)`, not `(list, index, child ordinal)`.

Keep `Target` as an opaque, window-qualified action capability for a currently acknowledged, visible row/descendant. Do not make a `Target` that went offscreen silently re-live when the same row is scrolled back: that would be capability ABA. A query on the new acknowledged frame mints/returns the current visible target; an old target that was removed or left the actionable sheet is stale. Stable row key survives; capability liveness does not. This preserves current stale-target semantics while providing keyed list identity.

Sorting/prepending may change the row's index, but its logical key stays the same. If product behavior needs the same top item to remain anchored through data reorder, preserve `(first_visible_key, intra_row_offset)` and resolve that key in the new source; raw absolute pixel offset is not equivalent. `index_of(key)` can be an optional source operation when an app needs anchor restoration or `scroll_to_key`; don't demand an O(N) lookup on every frame. When a key disappears, drop row-specific state and reject old targets.

## Wide scroll extent with local coordinates

250,000 rows × 32 logical pixels = 8,000,000 logical pixels. A naive single `translate(-scroll_y)` / row `translate(index * row_height)` pushes large values into f32 transforms and downstream geometry even though the visible window is only hundreds of pixels. For the virtual-list branch, represent absolute scroll as `(base_row: u64, intra_row: f64)` or checked `f64` units; derive a local origin at the first visible/realized row. For each realized row, compute in wide precision:

```text
local_y = (index - origin_row) * row_height - intra_row
```

Only then convert to f32, with admission that visible, hit-testable bounds/transforms and emitted draw geometry stay within the required `|coordinate|, extent < 1_000_000` domain. Clip to list viewport *and* window viewport before paint/query/hit publication. Scrollbar thumb position uses a ratio over wide total extent, not a huge child rect. This keeps every presented coordinate local while preserving a wide logical scroll range. This is a proposed invariant for the list path; source audit found finite f32 checks but no literal 1,000,000 coordinate cap in the current `gpui`, `canvas`, or `core` implementation, so the one-million bound must be treated as a requested geometry admission requirement, not an existing enforced policy.

Counterexample: layout all 250k children into an 8-million-pixel tall column and set a viewport clip. This still exceeds `MAX_NODES`, touches all rows every description, retains all row semantics, and submits large world-space transforms. Counterexample: use `f32` `offset` and compute `index as f32 * row_height - offset`; the two large nearly equal values lose subpixel precision through cancellation, particularly after long scrolling. Subtract integer row origin first, then convert the small local result.

## Semantic and input behavior

The semantic sheet is the exact acknowledged frame, not a theoretical list model. A `List` container can be semantically present, but row query/visit emits only rows intersecting the list clip and window viewport. Prefetch rows do not count as visible and do not receive actionable `Target`s. If presentation fails after scroll or data refresh, queries continue to describe the last acknowledged sheet under existing rules; new range keys do not gain click authority until the new scene is actually presented. A scroll input is routed to the nearest current scroll viewport, and pointer activation is hit-tested only against clipped visible realized nodes.

Required laws/tests:

1. `250_000` unique IDs with a 480px viewport and 32px rows materializes at most `ceil(480/32) + 2*max_overscan` rows, plus fixed list chrome; all 250k keys remain accessible through the borrowed source but no 250k row `El`s/targets are allocated.
2. Build the same list, scroll to middle/end, and assert only the calculated ranges are built; a prefetch limit holds under a jump from row 10 to row 200,000.
3. Activate key K, prepend a different key, sort/reverse, and refetch with unchanged K. The same domain key remains attached to its row/action/cache; index-based identity must fail this test. A removed K's target is stale and a newly inserted row cannot inherit it.
4. Scroll a row outside the visible interval but inside overscan: it must not be hit-testable or returned by `role/key/query` as visible. Then acknowledge the scrolled frame and verify visible semantics switch atomically with the presentation token.
5. Boundary arithmetic: empty list, one row, exact row boundary, fractional offset, offset at end, item count shrink, viewport-height shrink/grow, maximum allowed count/extent, and reject NaN/negative/zero row/viewport metrics before mutation. After every case, all emitted geometry satisfies the <1e6 bound.
6. Clone/allocation probes show no parent-model clones and row-builder invocation count is bounded by realized rows; repeatedly query visible rows via borrowed semantic APIs with zero allocation. `scroll` and `resize` update the same runtime and input path as native wheel events.

No blanket speed claim follows from these tests: at small N, building all rows may be simpler/faster. Acceptance must compare description/layout allocations and time at 100, 1k, 10k, and 250k IDs, with cold and warm scroll ranges; this feature's guaranteed win is bounded realized-node work/storage for the large-list regime, not a universal win.

## Pinned source references

* GPUI base commit: `d8b1f75a5d63ac002ba9da5c3306e1689a88668f` is the local `/root/gpui-ce3` revision, not asserted to be an upstream repository commit. Use the local file links above when reviewing implementation.
* Hummingbird exact table strategy: [pinned source and row-range code](https://github.com/hummingbird-player/hummingbird/blob/e15e8ba0ef6ff5445294030d373e3c8ccc7d780c/src/ui/components/table.rs#L730-L790).
* Hummingbird lazy file tree: [pinned tree states and flattening](https://github.com/hummingbird-player/hummingbird/blob/e15e8ba0ef6ff5445294030d373e3c8ccc7d780c/src/ui/library/files_view/tree.rs#L14-L78).
