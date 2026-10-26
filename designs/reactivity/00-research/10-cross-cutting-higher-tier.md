# 10 — Higher-Tier Cross-Cutting: What 06 Still Misses

Research date: 2026-08-15. Companion to
[06-cross-cutting.md](../06-cross-cutting.md). 06's thesis is right and should
not be reopened: **projections of the manifest + window-level protocols, never a
second retained tree.** This note mines shipping systems for mechanisms 06 either
underspecified, collapsed into a weaker rule, or did not name. It is opinionated.
A laundry list of peer features is not an upgrade. The 05 DX/perf follow-up
(closures-as-scopes, `Ui` reuse, staged writes, effects, zero-cost 03 paths) is
[10-elegance-and-fast-paths.md](10-elegance-and-fast-paths.md).

## 0. What 06 already won, and the three upgrades it still needs

Won, keep:

- Four leased projections (FlowIndex, Lattice, FlattenIndex, TokenIndex) updated
  by the same span splices as the tape.
- Protocols as the generalization of 04's drag: capture, preview, cancel, commit;
  app Rust only at typed decision points.
- PG1–PG5 (O(log n) maintenance, no-drift oracle, fault injection, grid scroll
  bar, a11y order ≡ FlowIndex).

Three structural upgrades — not new projections:

1. **Session indexes die with the protocol.** SelectionGeometry, find MatchSet,
   drop-gap geometry, and IME marked ranges are *not* always-on projections.
   They are leased for the life of an active protocol the way a drag preview is.
   06's PG1 covers unused projections; it does not say unused *protocols* and
   their session indexes cost zero. They must.
2. **Do not unify editor ranges with FlowIndex.** Monaco, Zed, and xterm keep a
   document selection algebra (anchor/focus on a rope, N cursors, column mode,
   IME composition as a third range) separate from widget-tree text selection.
   06 §9's "collaborative cursors are N selection-protocol states" is the
   failure mode: it invites one range type to serve chat-log copy *and*
   multi-cursor editing. They share overlay-lane *painting*, not a model.
3. **Gesture arbitration is three relations, not predicate racing.** UIKit's
   failure DAG, Compose's nested-scroll delta pipeline, and CSS `touch-action`
   compositor claims are different machines. 06 collapsed them into "predicate
   racing with innermost-wins ties." That spelling will lose tap-vs-long-press,
   nested scroll, and machine-rate pan.

Zero-cost rule, restated: a window with no `.selectable()`, no `grid()`, no
`tree()`, no theme tokens, and no live regions allocates **no** FlowIndex,
Lattice, FlattenIndex, TokenIndex, claim table, or announcement queue. First
consumer leases; last drop reclaims. Session indexes never outlive their
protocol.

---

## 1. Cross-element text selection + copy

### The most elegant existing mechanism

Not the Selection API's `Range` (live, mutates under DOM edits, cannot cross
shadow trees). The composed-tree lesson plus Flutter's composition law:

- **Scope = `user-select: contain`.** A selection cannot escape its containing
  element ([CSS UI 4 `user-select`](https://drafts.csswg.org/css-ui-4/#propdef-user-select);
  browsers implement `contain` as "the range is clipped to this subtree").
  Nested `none` punches holes; nested `all` is a triple-click magnet. 06's
  `.selectable()` is a scope root but does not specify *containment*, holes, or
  nested scopes.
- **Flattened walk is over the composed tree, with re-scoping at encapsulation
  boundaries.** `Selection.getComposedRanges()`
  ([W3C Selection API](https://www.w3.org/TR/selection-api/),
  [MDN](https://developer.mozilla.org/en-US/docs/Web/API/Selection/getComposedRanges))
  returns `StaticRange`s (snapshots) and, if a shadow root is not offered,
  **re-scopes the endpoint to the host**. That is the law for nested
  components: an editor, a form control, or a `Select::Exclude` subtree is one
  flow atom to the parent, never a leak of its internals.
- **A container is one Selectable to its parent.** Flutter's
  `SelectionContainer` / `MultiSelectableSelectionContainerDelegate`
  ([API](https://api.flutter.dev/flutter/widgets/MultiSelectableSelectionContainerDelegate-class.html))
  registers children, then presents a single `SelectedContentRange` and a
  combined `SelectionGeometry` (start/end points + **disjoint rects**,
  transforms applied, off-screen rects dropped) to the parent registrar.
  Geometry is a session index; the logical range is not.

Anchor and focus are distinct from start and end. Monaco's `ISelection`
(`selectionStart*` vs `position*`,
[docs](https://microsoft.github.io/monaco-editor/typedoc/interfaces/editor_editor_api.ISelection.html))
and the Selection API's `anchorNode`/`focusNode` encode direction. Shift-arrows
and drag-extend are operations on *focus*; copy serializes `[min, max]`.

### Failure modes 06 still has

- **No composition law.** Without "nested selectable is one atom," a chat
  bubble that contains an editor, a code span, or a button will either leak
  internal offsets into the parent FlowIndex or duplicate text on copy. Flutter
  got this right; browsers spent a decade on shadow-DOM selection because they
  didn't.
- **Live range vs snapshot.** 06's generation-checked pins are live protocol
  state. Copy, find-highlight, and a11y `AXSelectedText` need a *StaticRange*
  taken at the turn boundary. Structural splices clamp the live pins (06 says
  this); they must not mutate an in-flight clipboard payload.
- **SelectionGeometry is missing.** Painting "the rects of the range" is not a
  FlowIndex query. Bidi, line wraps, and transformed descendants produce
  disjoint rects. Flutter computes them from resident selectables only and
  intersects with the drawable area. 06 will either walk off-screen spans
  during a drag (blowing the zero-app-Rust rule) or paint nothing for bidi.
- **`contenteditable` is a trap.** The web has two systems that fight (document
  selection vs editing host). GPUI must keep **read-only FlowIndex selection**
  and **editor document selection** as different protocols that meet only at
  overlay painting and at "this subtree is one flow atom."
- **Granularity algebra is incomplete.** `Selection.modify(alter, direction,
  granularity)` (character / word / line / paragraph / sentence / document) is
  the keyboard/AT contract. Double-click word / triple-click paragraph is not
  the whole set.
- **Linux primary selection** (middle-click) is a second clipboard with
  different lifetime; Wayland/X11 already exist in this repo's platform layer.

### Cleverer spelling (still one register)

```rust,ignore
reading_pane()
    .selectable(Select::Contain)           // range cannot escape; default
    .child(chat_log(&self.messages))

code_block(&fence)
    .selectable(Select::Exclude)           // one flow atom to the parent
                                           // (copies as alt / "\n" / nothing)

impl ChatView {
    fn copied(&mut self, sel: SelectedText) -> Clipboard {
        Clipboard::rich(sel.markdown())    // optional; default is verbatim
    }
}
```

Protocol state is `(scope, anchor, focus)` where each endpoint is a
generation-checked `(span, run, byte, affinity)`. `Select::Contain` is the
scope. Nested `Exclude` / editing hosts contribute one atom whose copy string
is `alt` or a single newline (browser rule for replaced elements).

`SelectionGeometry` is a session index: resident rects for `[min, max]`,
recomputed from shaped-paragraph facts on the overlay lane during drag —
**zero owner Rust, zero FlowIndex materialization of off-screen ranges.**
Copy of an off-screen range is the existing virtual-range request (06),
producing a `StaticRange` payload, not a live pin.

Keyboard: `selection.modify(Alter::Extend, Dir::Forward, Gran::Word)` is the
one method; mouse, AT, and tests all call it.

### Perf / zero-cost

- Drag: hit-test → glyph map once on pointer-down; subsequent moves patch
  focus + overlay rects. No description, no layout.
- Geometry walks only *resident* selectables in the range (Flutter's drawable
  intersection). Off-screen is logical.
- No `.selectable()` in the window ⇒ no FlowIndex, no protocol, no geometry
  buffer.
- Find-in-page (below) leases a MatchSet; it does not keep a second FlowIndex.

---

## 2. 2D grids

### The most elegant existing mechanism

Excel/Sheets: **one lattice, two scroll offsets, four clipped viewports
sharing cell facts.** Frozen rows/cols are not extra rows in the virtualizer;
they are the same cells drawn in a clip that ignores one axis of scroll
([Sheets-style windowing](https://dev.to/zeeshanali0704/frontend-system-design-google-sheets-3pfl):
prefix sums per axis, transform-positioned recycled cells, frozen panes as
synchronized layers).

The WAI-ARIA [grid pattern](https://www.w3.org/WAI/ARIA/apg/patterns/grid/)
is the keyboard/a11y contract: **one tab stop for the whole grid** (roving
tabindex / `aria-activedescendant`), arrows move the *cell cursor*, selection
is a separate `aria-selected` set. `aria-rowindex` / `aria-colindex` are
**data coordinates**, not visual indexes — they survive virtualization.

Flutter's `TwoDimensionalViewport` + `TableView`
([two_dimensional_scrollables](https://github.com/flutter/packages/blob/main/packages/two_dimensional_scrollables/README.md))
is the closest toolkit implementation: dual offsets, pin rows/cols, merged
cells, lazy build. Its cautionary tale is the 20k-row pinned-pane jank
([flutter/flutter#161421](https://github.com/flutter/flutter/issues/161421),
fix [PR #180563](https://github.com/flutter/flutter/pull/180563)): iterating
children from index 0 to the viewport when a pinned row is present made the
"gap" between freeze and viewport O(n). **Never iterate the unpinned gap.**

### Failure modes 06 still has

- **Cell cursor ≠ range selection.** Excel's product is an *anchor+focus cell
  plus optional disjoint ranges*, then Enter-to-edit which *punctures* into an
  editor protocol. 06's `on_cell_activate` plus "cell-cursor protocol" will
  ship a file-browser, not a sheet. IDE data tables need at least range
  extend (shift-arrows, shift-click) and copy-as-TSV of the range.
- **Lattice of the arrangement, not the store.** Filtering/sorting then
  freezing is the Syncfusion failure
  ([freeze + filter + virtualization must share one coordinate space](https://www.syncfusion.com/blogs/post/freeze-panes-filtering-virtual-scrolling-angular-spreadsheets)).
  If Lattice is built on the raw `KeyedList` and the view is a filter
  arrangement, frozen headers drift and selection keys point at hidden rows.
  **Lattice is a projection of the visible arrangement.**
- **Pinned-pane iteration.** Four compositor clips is correct *only if*
  resident-set query is `(frozen ∪ viewport_band) × (frozen ∪ viewport_band)`
  and never `0..scroll_index`. PG4 must include "scroll to row 100_000 with
  frozen header = still two transform patches."
- **Spanning + keyboard.** Arrow into a span lands on the origin cell; tab
  order may differ from arrow order; a11y has one owner for the covered
  coordinates (04 already said this; 06's "interval entries" must inherit it).
- **Sparse cells.** A 100k×1k logical grid is not 10⁸ cell spans. Extents exist
  for empty rows; cell facts exist only for non-empty (or resident) cells.
- **Linked header scroll.** Horizontal scroll of the body must move the frozen
  *row* strip on the compositor (same x transform), not a second Rust scroll
  handler.

### Cleverer spelling

```rust,ignore
grid()
    .columns(keyed(&self.columns).by(Col::id))
    .rows(virtualized(self.rows.filtered(&self.query)).by(Row::id))
    .cell(Self::cell)
    .frozen_columns(1)
    .frozen_rows(1)
    .selection(&self.cells)                // Signal<CellSel>
    .on_edit(Sheet::edit_cell)             // punctures to editor protocol

struct CellSel {
    anchor: CellRef,                       // (row_key, col_key)
    focus: CellRef,
    extra: KeySet<CellRef>,                // cmd-click islands; often empty
}
```

`CellSel` is a framework source. Overlay paints the range from Lattice
coordinates of *resident* cells only. Copy walks the logical range (bounded /
async-for-huge, same as FlowIndex). Edit mounts an editor in the focus cell
and **excludes** that cell from the grid's text FlowIndex (Select::Exclude).

Sash-resize of a frozen boundary is the VS Code `Sash` protocol
([sash.ts](https://github.com/microsoft/vscode/blob/master/src/vs/base/browser/ui/sash/sash.ts)):
drag patches a column-width signal; double-click (`onDidReset`) restores
default; linked corner sashes for 2×2 are nice-to-have.

### Perf / zero-cost

- Scroll: two transform patches. Frozen strips share the axis they are *not*
  frozen on. Zero cell rebuild.
- No `grid()` ⇒ no Lattice.
- Empty cells: O(rows + cols) extent trees, not O(rows × cols) facts.
- Filter arrangement already exists in collections.md; Lattice subscribes to
  *that* order, not the base store.

---

## 3. Virtualized trees / outlines

### The most elegant existing mechanism

**NSOutlineView's data-source pull + type-select**, not SwiftUI
`OutlineGroup`. `OutlineGroup` still cannot reliably select nested rows inside
`NavigationSplitView` on macOS
([SO](https://stackoverflow.com/questions/73100261/navigationsplitview-on-macos-outlinegroup-elements-in-sidebar-not-selectable),
[Apple forums](https://developer.apple.com/forums/thread/722948)) — a warning
that "just flatten in the view" is not a primitive.

NSOutlineView does not own the hierarchy. It asks `isItemExpandable:`,
`numberOfChildrenOfItem:`, `child:ofItem:` and preserves expansion by *item
identity*. Type-select (`nextTypeSelectMatchFromItem:toItem:forString:`) is a
protocol over the flattened visible rows. Finder/Xcode add: drop *gap*
indicators, hover-to-expand with delay, marked-set vs cursor.

Zed's project panel is the in-house version of the same idea: `expanded_dir_ids`
+ `visible_entries` flatten, async `UpdateVisibleEntriesTask` so FS updates do
not block the frame
([DeepWiki panels](https://deepwiki.com/zed-industries/zed/3.5-panels-and-sidebar),
[project panel docs](https://zed.dev/docs/project-panel)). Worktree identity is
`ProjectEntryId` in a SumTree, not a path, not a flatten index
([Zed Decoded: Rope & SumTree](https://zed.dev/blog/zed-decoded-rope-sumtree)).

Win32 `TVM_SELECTITEM` / `TVN_SELCHANGING` (veto) is the "drop rebase or
reject" rule collections.md already has.

### Failure modes 06 still has

- **`.children(Node::children) -> &[Node]` is eager.** File trees cannot
  materialize 200k children of `node_modules` at expand. NSOutlineView and Zed
  are pull + async. 06 will either stall expand or force the app to pre-flatten.
- **Cursor ≠ marked set.** Zed: focus/cursor is one row; shift-arrows *mark* a
  set that cut/copy/trash/drag use. 06 only describes a cell-cursor sibling.
  Multi-select is product-critical for an IDE project panel.
- **Drop is a gap, not a row.** `(parent_key, index)` computed from a point
  *between* FlattenIndex rows, painted as a line (or "onto folder"). Hovering a
  collapsed folder for N ms expands it (Finder). Concurrent FS updates rebase
  the gap or reject (collections.md) — keep that, add the geometry.
- **Collapse containing the focus/drop-target.** Expansion KeySet is not
  enough: collapsing a parent must rebase cursor, marks, and drop onto the
  parent (or the next visible row), not leave a dangling key.
- **Keep-visible on expand.** If expanding the focused node would push it off
  the viewport, autoscroll (NSOutlineView does this). Anchor-by-key handles
  *inserts above*; it does not handle *the focused row growing downward off
  screen*.

### Cleverer spelling

```rust,ignore
tree()
    .roots(&self.workspace.roots)
    .children_of(Node::children_state)     // Leaf | Ready(&[Node]) | Pending
    .expanded(&self.expanded)              // Signal<KeySet<NodeId>>
    .marks(&self.marked)                   // Signal<KeySet<NodeId>>; protocol writes
    .row(Self::node_row)
    .hover_expand(300.ms())
    .on_reorder(Workspace::move_node)      // Move { src: KeySet<NodeId>, dest: DropGap<NodeId> }
    .on_typeahead(Workspace::reveal)       // optional; default is prefix-select

enum Children<N> {
    Leaf,
    Ready(&[N]),
    Pending,                               // row shows disclosure + spinner; pin until Ready
}

struct DropGap<K> { parent: K, index: u32, onto: bool }
```

FlattenIndex summaries stay `(visible_row_count, …)`. Pending children occupy
one placeholder row, not a fake subtree. When `Ready` arrives, one contiguous
splice — same as expand.

Typeahead is NSOutlineView type-select: a short-lived query over FlattenIndex
labels, moves the cursor, does not open a palette.

### Perf / zero-cost

- Expand: O(log n) FlattenIndex splice + materialize the *visible* band of new
  rows, not all 200 children if they overflow the viewport (overscan only).
- Pending: one row fact. The app's `Latest<Vec<Child>>` (07 work edge) is the
  async story; the tree protocol does not spawn tasks.
- No `tree()` ⇒ no FlattenIndex.
- DropGap geometry is a session index during drag.

---

## 4. Docking / panel management

### The most elegant existing mechanism

**VS Code's two algebras, not Zed's three-edge dock.**

1. **Workbench chrome** — fixed slots (activity bar, sidebar, auxiliary bar,
   panel, status bar) with visibility, size, and *view descriptors* that move
   between slots. Persisted. Drag a view from sidebar to panel
   ([Custom Layout](https://code.visualstudio.com/docs/configure/custom-layout)).
2. **Editor grid** — recursive `SerializableGrid` of editor groups, sashes,
   locked groups, empty groups, MRU. `ISerializedGrid` round-trips
   ([layout.ts](https://github.com/microsoft/vscode/blob/ae7dce46/src/vs/workbench/browser/layout.ts),
   [editorPart.ts](https://github.com/microsoft/vscode/blob/ae7dce46/src/vs/workbench/browser/parts/editor/editorPart.ts)).
   Sash: hover, drag, reset-on-double-click, linked corner sashes
   ([sash.ts](https://github.com/microsoft/vscode/blob/master/src/vs/base/browser/ui/sash/sash.ts)).

Zed's dock (left / right / bottom, panels implement `Panel`) is weaker and
must not be the primitive we copy. Theia/Phosphor DockPanel is the *more*
dynamic academic version; VS Code simplified it and that is the right
complexity cap.

AppKit `NSSplitView` is the sash + collapse ancestor, not a docking protocol.
`NavigationSplitView` is adaptive chrome (collapse to stack at compact size
class) — steal the *visibility enum*, not as a dock.

### Failure modes 06 still has

- **One `DockLayout` conflates chrome and editor splits.** An IDE needs both.
  Putting the terminal, the project panel, *and* split editors in one recursive
  Split/Tabs/Float tree makes persistence, "reset layout", and "open to the
  side" policies miserable. VS Code's split is exactly this lesson.
- **No sash protocol.** Resize as `DockDelta::Resize` is a commit; the
  *interaction* is a machine-rate width signal + snap-to-min + double-click
  reset. 06's drag protocol covers tab move, not sash.
- **No auxiliary window.** Float-via-portal is an overlay, not a native window
  with its own grid (VS Code auxiliary windows). Zed-class: drag a tab out of
  the window.
- **View descriptor vs instance.** Panels are registered kinds; layout stores
  ids; closing a split must not drop `panels[id]` (06 has this). Missing:
  **cannot-serialize** editors drop out of restore (VS Code
  `editorGroupModel` skips unsavable inputs and adjusts sticky indexes).
- **Locked groups / last-editor-close / empty group persistence** — IDE
  policy, must be deltas, not hardcoded.

### Cleverer spelling

```rust,ignore
struct Workspace {
    chrome: Workbench,                     // slots + vis + sizes; serializable
    editors: EditorGrid,                   // recursive splits of GroupId
    groups: ComponentMap<GroupId, Tabs<ViewportId>>,
    viewports: ComponentMap<ViewportId, EditorView>,
    documents: HashMap<DocId, Document>,   // N viewports, one model — § unnamed
    panels: ComponentMap<PanelId, Panel>,
}

impl View for Workspace {
    fn view(&self) -> Ui<'_> {
        workbench(&self.chrome)
            .slot(Slot::Sidebar, dock_stack(&self.chrome.sidebar, |id| self.panels.element(id)))
            .slot(Slot::Panel,   dock_stack(&self.chrome.panel,   |id| self.panels.element(id)))
            .center(editor_grid(&self.editors).group(|gid| self.groups.element(gid)))
            .on_chrome(Workspace::chrome_changed)   // fn(&mut Self, ChromeDelta)
            .on_grid(Workspace::grid_changed)       // fn(&mut Self, GridDelta)
    }
}
```

Two delta algebras, one drag protocol, one sash protocol. Tab-drag *between*
chrome and grid is allowed (VS Code: move Explorer to the Panel region) and
produces a typed delta the app can veto.

### Perf / zero-cost

- Sash drag: width signal → layout of the two adjacent leaves only, or a
  transform if the spine is elastic-enough. Not a description of the world.
- Apps without `workbench()` use ordinary splits; no chrome persistence.
- Float to native window: existing portal/auxiliary surface; the *grid leaf*
  moves ids, it does not clone panel state.

---

## 5. Gesture recognition + conflict arbitration

### The most elegant existing mechanism

**Three machines, composed.** UIKit is the gold standard for *discrete*
conflict; it is the wrong model for *nested scroll* and for *compositor pan*.

1. **Failure DAG (UIKit).** `require(toFail:)` /
   `shouldRequireFailure(of:)`
   ([docs](https://developer.apple.com/documentation/uikit/uigesturerecognizerdelegate/gesturerecognizer(_:shouldrequirefailureof:)))
   means *wait until the other recognizer fails*, not *first predicate wins*.
   Tap waits for double-tap to fail; long-press waits for tap to fail; a
   horizontal swipe waits for the scroll view's pan to fail. Simultaneous is a
   **pairwise, asymmetric** delegate
   ([shouldRecognizeSimultaneouslyWith](https://developer.apple.com/documentation/uikit/uigesturerecognizerdelegate/gesturerecognizer(_:shouldrecognizesimultaneouslywith:))):
   one side returning true is enough. `delaysTouchesBegan/Ended` holds the
   view's discrete action until the DAG resolves — 06's buffered-motion replay
   is the continuous analog; the discrete analog is missing.
2. **Nested scroll is a delta pipeline, not a claimant (Compose).**
   `NestedScrollConnection`: pre-scroll (parent may consume) → child consumes
   → post-scroll (parent takes remainder); same for fling
   ([Android docs](https://developer.android.com/develop/ui/compose/touch-input/scroll/nested-scroll-modifiers)).
   Treating scroll as a recognizer racing a drag will fight collapsing
   toolbars, nested lists, and "swipe on a card inside a scroller."
3. **Static compositor claims (CSS `touch-action` / Pointer Events).**
   Viewport pan/zoom **cannot** be suppressed by canceling a pointer event;
   they must be declared so the compositor can start scroll without waiting
   for JS ([Pointer Events L3](https://www.w3.org/TR/pointerevents3/),
   [MDN `touch-action`](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/touch-action)).
   Intersection of the hit path up to the first scroll container. When the
   UA takes the gesture it fires `pointercancel`. This is how selection-drag
   and map-pan stay machine-rate.

Blender's modal operator is the "once claimed, eat the stream until finish"
escape (maps to protocol capture). SwiftUI's
`highPriorityGesture` / `simultaneousGesture` / `GestureMask` are three
combinators — nicer *authoring* than a claim table, but they sit on UIKit's
DAG underneath and do not replace it.

### Failure modes 06 still has

- **Predicate racing loses tap vs double-tap vs long-press.** First-motion
  wins cannot wait 300 ms. Failure requirements exist specifically because
  racing is wrong.
- **Scroll-as-claimant fights nested scroll.** A card swipe inside a list
  needs: vertical delta goes to the list (pipeline); horizontal dominance
  fails the list's pan and claims the swipe (DAG). 06 has no pipeline.
- **No compositor-thread declaration.** If every pan waits on the claim
  table in app/interaction Rust, you have already lost the "scroll = transform
  patch" budget on touch. `touch-action` exists because that wait is illegal.
- **Simultaneity is not a set.** Pinch+rotate is pairwise. A third recognizer
  must not silently join.
- **IME and text-selection must preempt.** Platform/IME handling is first in
  04's key routing; the claim table must have the same law for pointer+keyboard
  during composition.

### Cleverer spelling

```rust,ignore
// Static claim (touch-action analog): compositor may take this axis
// without consulting recognizers. Intersection along the hit path.
list_region().pan(Pan::VERTICAL)

message_row(msg)
    .gesture(Swipe::horizontal().on_commit(Inbox::archive.with(msg.id)))
    .gesture(
        LongPress::default()
            .after_failure_of::<Tap>()
            .on_commit(Inbox::context_menu.with(msg.id)),
    )

canvas_view()
    .pan(Pan::NONE)                        // map: JS/recognizers own all axes
    .gesture(Pinch::default().pipe(&self.zoom))
    .gesture(Rotate::default().simultaneous_with::<Pinch>().pipe(&self.rotation))
```

Arbitration, in order, and this order is normative:

1. Static `pan()` mask of the hit path (compositor / resident-scroll lane).
2. Failure DAG among recognizers on that path (`after_failure_of`,
   `requires_failure_of` — both directions, lazily, once per attempt, as
   UIKit documents).
3. Nested-scroll pipeline for leftover **scroll** deltas (not a recognizer).
4. Pairwise simultaneity.
5. Innermost-wins only as a tie-break among recognizers that are still
   `Possible` with no DAG edge.

Inspect the DAG + pipeline, not only "who claimed." 06's inspectable claim
table is the right product instinct; the trace must show *waited-for-failure*,
not only winner.

### Perf / zero-cost

- Resident scroll stays on the motion lane **because `pan()` said so**, not
  because a recognizer lost a race after 8 px of slop.
- No `.gesture()` and default `pan(Pan::AUTO)` ⇒ empty DAG, no recognizer
  heap, scroll works.
- Losers get `Cancelled { winner }` + typed rubber-band (06); add
  `pointercancel` when the compositor stole the stream.

---

## 6. Container / self-size queries

### The most elegant existing mechanism

CSS Containment 3 / Conditional 5, with one harder rule than 06:

- **You never query yourself.** Size queries are against an *ancestor*
  container that has size containment on the queried axis
  ([CSS Containment L3](https://www.w3.org/TR/css-contain-3/),
  [MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/Guides/Containment/Container_queries)).
  `container-type: inline-size` contains the inline axis so children cannot
  feed back. `size` (both axes) collapses the block axis to 0 unless height is
  definite — the cycle made unrepresentable by collapse, not by retry.
- **Named containers** (`container-name`) skip nearest-unrelated wrappers.
- **Style queries** need no containment (descendant styles must not affect
  the ancestor's computed style). Cheap.
- **Scroll-state queries** (`stuck`, `snapped`, `scrollable`) in
  [CSS Conditional 5](https://drafts.csswg.org/css-conditional-5/) style
  sticky headers and scroll-driven variants **without a layout cycle**.

SwiftUI's `AnyLayout` + `@Environment(\.dynamicTypeSize)`
([AnyLayout](https://developer.apple.com/documentation/swiftui/anylayout),
[WWDC24](https://developer.apple.com/videos/play/wwdc2024/10074/)) is the
identity lesson: swapping HStack/VStack under Dynamic Type must **preserve
child identity** (06 already: only the active variant exists). The query
source is an environment fact, not a self-size.

### Failure modes 06 still has

- **`.container()` on the querying element is self-size.** 06 writes `card().container(Axis::Horizontal)` then
  `container_style(...)` on the *same* node. CSS forbids this because the
  card's width often *is* a function of its children (shrink-to-fit). A mount
  error for auto-width in a row is good; authors will still want "this card
  reflows in any slot," which is **query the parent slot**, not the card.
- **Only discrete variants.** `cqw` / `cqi` (length as % of container) is how
  real cards scale padding/type without a variant explosion. Discrete
  breakpoints + container-relative lengths are both needed; lengths are paint/
  layout facts, not extra variants.
- **No scroll-state.** Sticky styling and "show shadow when stuck" will get
  hacked as a layout query and reintroduce the cycle.
- **No named container.** A grid cell wrapping a card wrapping a title will
  query the wrong ancestor.

### Cleverer spelling

```rust,ignore
sidebar()
    .container("rail", Axis::Horizontal)   // named ancestor; inline-size containment
    .child(card()
        .when_container("rail", width::below(px(400.)),
            style().direction(Axis::Column).hide("meta"))
        .padding_x(cqi(4.))                // 4% of the named container's inline size
        .child(card_body(&self.item)))

virtual_list(...)
    .sticky_header(RowKind::Section)
    .when_scroll(ScrollState::Stuck, style().shadow(tokens::stuck_shadow()))
```

`.container(name, axis)` is a **containment declaration** (mount-checked:
that axis is independent of children). Queries hang off descendants via
`.when_container(name, …)`. Self-query is unrepresentable.

### Perf / zero-cost

- One top-down pass, 06's law, unchanged.
- Unnamed / unused containers: no extra facts. `cqi` is a layout input
  resolved after the container's size settles, same pass.
- Scroll-state is a compositor/scroll fact (like hover), not a layout
  invalidation, unless the variant includes layout bits (then it is the
  existing `.hovered_layout` tier).

---

## 7. Live-region a11y announcements

### The most elegant existing mechanism

ARIA live regions are *not* "patch text, AT speaks." The shipping contract:

- Politeness: `off` | `polite` | `assertive`
  ([MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Guides/Live_regions)).
  Assertive interrupts; use rarely.
- **`aria-atomic`**: announce the whole region vs the delta. `role="status"`
  implies polite+atomic; `role="alert"` implies assertive+atomic;
  `role="log"` is polite, not atomic; **`role="timer"` is live=off**.
- **`aria-busy`**: batch mutations, announce once.
- **The region must already exist in the a11y tree before the text
  changes.** Creating a node and filling it in the same turn is silently
  dropped by many ATs (the offscreen-polite-region pattern).
- **Do not announce initial mount.** Only subsequent changes.
- AccessKit: `Node::live()` + announce the node's **`value`**, not a walk of
  child text
  ([live-region support](https://github.com/RDMurray/accesskit/commit/a7ee1c9414cdeef0752212037b391c3ca322abad)).
  Apple maps assertive → `UIAccessibilityPriorityHigh`, polite → Low.

Sara Soueidan's write-up is the practical canon
([part 1](https://www.sarasoueidan.com/blog/accessible-notifications-with-aria-live-regions-part-1/)).

### Failure modes 06 still has

- **Text-fact patches of children as the announcement.** Labels, icons, and
  "button Saved button" doubling. AccessKit wants a dedicated string.
- **Mount-announce.** A status bar that starts with "Ready" will speak
  "Ready" on window open.
- **Same-turn create-and-fill.** `Announce::polite` as an effect is the
  right escape for event-shaped news; `.live()` on a *newly mounted* subtree
  is not.
- **Coalesce only within a turn.** Rapid "Saved" / "Saved" / "Saved" across
  turns queue-bombs VoiceOver. Need per-region rate limit + "latest wins."
- **One region for everything.** Grid cell-change, status, and errors must
  not share a queue (AT users lose cell context).
- **`aria-relevant` is junk.** AT support is inconsistent; do not expose it.

### Cleverer spelling

```rust,ignore
// Region exists for the window lifetime; first mount is silent.
status_slot()
    .live(Polite)
    .atomic()
    .announce(&self.save_status)           // dedicated string, wire-friendly

form.submit_errors().live(Assertive).atomic().announce(&self.errors);

fn saved(&mut self) -> Announce {          // no visual anchor; uses the
    Announce::polite("Saved")              // window's hidden polite host
}
```

Hidden polite/assertive hosts are framework-owned, always mounted, empty.
`Announce` writes them. Visual `.live()` regions still exist for logs
(`role=log`, not atomic). `busy()` around a batch of patches.

AccessKit adapter: set `live` + `value` to the announcement string; do not
rely on descendant text. Tests assert the platform-neutral queue (04 already).

### Perf / zero-cost

- No `.live()` and no `Announce` ⇒ no queue, no AccessKit live bits.
- Wires into `.announce(&Signal<String>)` patch the semantic value only.

---

## 8. Theme-swap fanout (10k consumers)

### The most elegant existing mechanism

06's TokenIndex **already beats CSS.** Browsers invalidate inherited custom
properties down the subtree because they cannot know who `var()`-references
them; WebKit is only now adding a bloom-filter skip for non-`var()`
descendants ([WebKit PR #60512](https://github.com/WebKit/WebKit/pull/60512)).
Exact consumer sets are the correct end-state; do not copy CSS inheritance.

The remaining lessons:

- **Paint vs geometry tokens.** A theme that touches spacing/font-size is a
  relayout, not a swap
  ([runtime theme switching](https://www.css-architecture.com/advanced-theming-dark-mode-implementation/runtime-theme-switching/)).
  Tag layout-impacting tokens in the index (06 does). Add a **CI fixture:
  default theme profile contains zero layout tokens**.
- **`inherits: false` analog is already TokenIndex** if (and only if) you
  never walk subtrees, only slots. Keep exact; skip bloom.
- **Do not animate theme tokens.** Root-scoped 60 fps variable updates are
  the documented frame killer
  ([Loke.dev](https://loke.dev/blog/css-variables-performance-root-updates),
  [web.dev `@property`](https://web.dev/blog/at-property-performance)).
  Theme swap is one turn, not a spring.
- **Scoped tables.** Editor chrome vs buffer vs terminal palettes are
  different TokenIndex scopes, not one global `:root`.
- SwiftUI Dynamic Type / `colorScheme` are **environment facts** that may
  *select* a table; they are not themselves 10k slot writes if the table
  identity did not change.

### Failure modes 06 still has

- One global token table, so a terminal-palette tweak walks editor consumers
  that share names (`danger`).
- No CI gate against layout tokens in the "theme flip" path, so PG-style
  counters can go green while the window reflows.
- Authors piping a theme token into a spring.

### Cleverer spelling

No authoring change: `theme::danger()` stays a late-bound value. Internally:

```text
TokenId = (ScopeId, NameId)
TokenIndex: TokenId → [slot]
theme.swap(scope, table) → walk only that scope's changed names
```

Layout-tagged names enter layout; paint-tagged names enter paint. Animating a
token is a located error (or a no-op with a diagnostic). Dev counter already
in 06: tokens-changed × slots-patched; add `layout_tokens_patched == 0` for
the default profile.

### Perf / zero-cost

- Unused theme scopes: no index entries.
- 10k paint consumers: 10k slot patches, zero description, zero layout.
  This is the gate.

---

## 9. Primitives 06 did not name that a Zed-class IDE actually needs

Each is a protocol (sometimes with a session index) on the existing
projections. None is a fifth always-on projection.

### Must-have (promote into 06)

**Find-in-page / incremental search over FlowIndex.** Browser find is a
document-global query; IDE find-in-file is a rope query; **find-in-UI** is a
FlowIndex query. Session index: `MatchSet { query, current, rects[] }` leased
while the find bar is open. Highlight-all is overlay rects from resident
matches; next/prev seeks the index (O(log n + 1)), materializes virtualized
hits through the same range request as copy. Do not search only resident
spans. Distinct overlay layer from selection (Chrome: find-highlight ≠
selection color).

**Drag autoscroll.** 04 already names it. During drag/selection, pointer in
an edge band of a scroll container continues scroll on the motion lane
(xterm's `_dragScroll*` in
[SelectionService](https://cdn.jsdelivr.net/npm/@xterm/xterm@6.0.0/src/browser/services/SelectionService.ts)
is the same idea). Pins the drag source; materializes newly visible drop
targets / selection geometry. **Zero owner Rust per frame.** Failure mode:
virtualizer unmounts the source because autoscroll moved it off-screen —
retention reasons in collections.md must include "active drag source/target."

**Tab stops / focus rings across virtualized content.** WAI-ARIA
[roving tabindex](https://www.w3.org/WAI/ARIA/apg/practices/keyboard-interface/):
one tab stop per composite (list/tree/grid), arrows move. 04's
`focus_group(Axis::Vertical)` is the spelling; 06 must *wire* it to
FlattenIndex/Lattice coordinates and **pin the focused key**. Focus ring is
an **overlay-lane stroke**, not a box-shadow (shadows clip to overflow;
rings must not). Restoration by key when the row is virtualized out and back.
`aria-activedescendant` is acceptable for combobox popups where DOM/platform
focus must stay on the input; prefer real focus for grids (APG: UA then
scrolls the focused cell into view).

**IME + selection coexistence.** Compose `TextFieldValue` holds
`text` + `selection` + **`composition: Option<TextRange>`**
([TextFieldState](https://developer.android.com/reference/kotlin/androidx/compose/foundation/text/input/TextFieldState));
writing text while composing without preserving composition is the WPF
Pinyin bug
([dotnet/wpf#6194](https://github.com/dotnet/wpf/issues/6194)).
IME marked range is a **third range**, not a selection. Selection collapses
at composition start; IME owns the mark; commit replaces the mark; **never
echo a document write into the IME mid-composition.** Claim-table law: IME
preempts. 04's `EditGesture` token is the right hook; 06's selection protocol
must yield.

**Split editors sharing a document.** N viewports, one model. Each
`EditorView` owns scroll + `Vec<Selection>` + local folds; `Document` owns
the rope/revision. VS Code editor groups; Zed multibuffers are the same
pattern with excerpts
([multibuffers](https://zed.dev/docs/multibuffers)). This is **not docking**
and **not FlowIndex**. Collab is this at N users. Overlay paints N carets
from N view states.

**Context menus with keyboard.** Flutter is migrating selection toolbars to
`OverlayPortal` so the menu inherits the source's theme/focus and cannot
outlive it
([OverlayPortal](https://api.flutter.dev/flutter/widgets/OverlayPortal-class.html),
[issue #185507](https://github.com/flutter/flutter/issues/185507)).
Protocol: open from a *target identity* (not only coordinates); focus moves
into a menu focus-scope; typeahead + arrows; Shift-F10 / Menu key; dismiss on
escape / click-outside / focus loss. AppKit `menu(for:)` is the targeting
law. Not a projection.

**Drop indicators in trees.** Session index on FlattenIndex (see §3).
Hover-expand with delay. Rebase or reject on concurrent model change.

**Sticky headers in lists.** CSS `position: sticky` is a **compositor
clip+offset of a span already in the list**, not a duplicate row. Flutter
`SliverPersistentHeader`. Pin the sticky key as a retention reason. Style via
scroll-state `Stuck` (§6), not a layout query. Failure: virtualizing the
sticky row out from under the pin.

### Nice-to-have (library or editor crate, not 06 substrate)

**Multi-cursor / block selection.** Monaco `Selection[]` + column mode;
xterm `SelectionMode.COLUMN` (alt-drag,
[PR #1538](https://github.com/xtermjs/xterm.js/pull/1538));
Zed alt-click / `cmd-d`. Lives on the **document** protocol, not FlowIndex.
The overlay lane already paints N ranges.

**Command palette / typeahead.** 04 already: `.searchable()` admits an
invoker to the palette; export is only for remappable names. Tree *type-select*
is NSOutlineView (must-have, §3). Do not conflate a command registry with
FlattenIndex.

**Treegrid (trees with columns).** VS Code SCM, Xcode. FlattenIndex ×
Lattice. Real, but not v1.

**Fill handle / formula bar.** Sheets. Reject for the framework; a sheet
crate may add them on CellSel.

**Linux primary clipboard.** Platform adapter on the selection protocol.

**`cqw` units.** Included as a container-query *length*, not a new primitive.

**Minimap.** 06 §9: Lattice/FlattenIndex extents drawn small. Yes, as a view
of existing summaries, not a new index.

**Linked 2×2 sashes, locked editor groups, empty-group persistence.** Editor
grid policy (nice deltas, not substrate).

**Collaborative cursors.** N document-selection states + collab CRDT. Overlay
only.

### Rejected overkill

| Temptation | Why reject |
|---|---|
| Unify editor selection with FlowIndex | Different algebras, IME, multi-cursor, affinity; share paint only |
| Second a11y tree | 06 thesis; AccessKit consumes the semantic projection |
| Quadtree for grids | Two 1D sum-trees suffice; Excel does not quadtree the sheet |
| Deep Zoom / Silverlight `MultiScaleImage` | Image-pyramid viewer, not an IDE primitive; pinch+canvas covers maps |
| Phosphor/Theia fully dynamic dock | VS Code's two algebras are the complexity cap |
| Unrestricted CQ iteration / self-size | CSS spent a decade proving this oscillates |
| Recognizer subclass zoo | Closed set (scroll, drag, swipe, long-press, pinch, rotate, tap) + one custom trait, as 04 said |
| `aria-relevant` | AT support is junk |
| Per-frame theme token animation | Documented full-tree style recalc |
| Semantic zoom as a framework widget (WinUI SemanticZoom) | App-level canvas + FlattenIndex grouping; not a primitive |
| `contenteditable` | Two fighting selection systems |
| Caret browsing (F7) | Nobody in the product set needs it |
| Bloom-filter token invalidation | Exact TokenIndex is strictly better |
| Excel fill-handle / formula graph | Sheet crate, not GPUI |
| PanGui `PositionRelativeTo` as a dock | Placement graph (08) already covers anchors; docking is deltas+sash |

**Slint / Iced / egui / Floem / Xilem** mostly *punt* this entire map: Slint
has no TreeView ([#505](https://github.com/slint-ui/slint/issues/505); community
flatten-with-depth), broken multiline selection
([#10496](https://github.com/slint-ui/slint/issues/10496)); Iced/egui are
per-widget selection; Floem has 1D virt; Xilem is early. Steal nothing except
the negative space: **do not ship a list and call it a tree.**

**PanGui / Lilt:** no unique answer for these eight gaps. PanGui's
relative placement is already in 08; Lilt is sampled motion, not arbitration
or selection.

---

## 10. The higher-tier gap map (opinionated)

### Must-have upgrades to 06 (do these, in roughly this order)

1. **Gesture trilogy.** Replace predicate racing with (a) static `pan()`
   claims, (b) UIKit failure DAG, (c) Compose nested-scroll pipeline.
   Inspect traces for "waited for failure."
2. **Selection composition law.** `Select::Contain` / `Exclude`; nested
   container is one Selectable; editors puncture; anchor≠focus;
   SelectionGeometry as a session index; StaticRange on copy.
3. **IME as a third range that preempts** the selection protocol.
4. **Lattice of the arrangement**; CellSel range (not only cursor); never
   iterate the frozen gap; sparse extents.
5. **Tree pull/async children**; marked set; DropGap session index;
   hover-expand; rebase on collapse.
6. **Workbench chrome ≠ editor grid**; sash protocol; serialize with
   skip-unsavable.
7. **Live regions:** dedicated announcement string, exist-before-change,
   silent mount, atomic/busy, hidden hosts, no `aria-relevant`.
8. **TokenIndex scopes** + paint-only default theme CI gate; never animate
   tokens.
9. **Find-in-page MatchSet** over FlowIndex (session index).
10. **Drag autoscroll** on the motion lane with virtualization pins.
11. **Roving focus + overlay focus ring** wired to FlattenIndex/Lattice.
12. **N viewports, one Document** (split editors) — named as a law, even if
    the editor crate owns the state.
13. **Context menu protocol** via overlay portal (identity-targeted).
14. **Sticky headers** as compositor pin + scroll-state, not a duplicate row.
15. **Container queries query named ancestors**, never self; add scroll-state
    and `cqi` lengths.
16. **PG1 extended:** unused *protocols* and session indexes cost zero;
    MatchSet/Geometry/DropGap die with their protocol.

### Nice-to-have (after the vertical slice)

Multi-cursor and column select (editor crate); command palette (already in
04); tree type-select; treegrid; minimap; auxiliary native windows; Linux
primary selection; locked editor groups; `cqw` as a length unit; collab
carets.

### Rejected

Unifying editor and FlowIndex selection; second trees; quadtrees; Deep Zoom;
Theia dock; self-size queries; recognizer zoos; `aria-relevant`; animated
theme tokens; semantic-zoom widget; contenteditable; bloom-filter tokens;
fill-handle.

---

## 11. Suggested 06 section deltas (spellings only)

Projections stay four. Add an explicit **session index** noun:

> A session index is a protocol-owned, incrementally updated structure
> leased from first protocol event to teardown (SelectionGeometry, MatchSet,
> DropGap, ImeMark). It is not a projection: it has no meaning without its
> protocol, and PG2's from-scratch oracle rebuilds it from protocol state +
> projections, not from the manifest alone.

Add a fifth gate:

- **PG6 — compositor claims.** A vertical list with default `pan(VERTICAL)`
  begins resident scroll on the motion lane without entering the recognizer
  DAG; a `pan(NONE)` canvas never emits a native pan; nested scroll deltas
  are accounted (pre/child/post) in the work counters.

Keep PG4, but add "frozen header at row 100k, then horizontal fling" as the
Flutter regression.

---

## Sources (selected)

**Browsers.** [Selection API](https://www.w3.org/TR/selection-api/);
[getComposedRanges](https://developer.mozilla.org/en-US/docs/Web/API/Selection/getComposedRanges);
[CSS UI `user-select`](https://drafts.csswg.org/css-ui-4/#propdef-user-select);
[CSS Containment L3](https://www.w3.org/TR/css-contain-3/);
[CSS Conditional 5](https://drafts.csswg.org/css-conditional-5/);
[CSS Scroll Anchoring](https://drafts.csswg.org/css-scroll-anchoring/);
[Pointer Events L3](https://www.w3.org/TR/pointerevents3/);
[touch-action](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/touch-action);
[ARIA live regions](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Guides/Live_regions);
[WAI-ARIA APG grid](https://www.w3.org/WAI/ARIA/apg/patterns/grid/);
[APG keyboard / roving tabindex](https://www.w3.org/WAI/ARIA/apg/practices/keyboard-interface/);
[WebKit custom-property skip](https://github.com/WebKit/WebKit/pull/60512).

**VS Code / Monaco / xterm.**
[SerializableGrid in layout.ts](https://github.com/microsoft/vscode/blob/ae7dce46/src/vs/workbench/browser/layout.ts);
[editorPart.ts](https://github.com/microsoft/vscode/blob/ae7dce46/src/vs/workbench/browser/parts/editor/editorPart.ts);
[Sash](https://github.com/microsoft/vscode/blob/master/src/vs/base/browser/ui/sash/sash.ts);
[Custom Layout](https://code.visualstudio.com/docs/configure/custom-layout);
[Monaco ISelection](https://microsoft.github.io/monaco-editor/typedoc/interfaces/editor_editor_api.ISelection.html);
[xterm SelectionService](https://cdn.jsdelivr.net/npm/@xterm/xterm@6.0.0/src/browser/services/SelectionService.ts);
[xterm column select](https://github.com/xtermjs/xterm.js/pull/1538).

**SwiftUI / UIKit / AppKit.**
[UIGestureRecognizer failure](https://developer.apple.com/documentation/uikit/uigesturerecognizerdelegate/gesturerecognizer(_:shouldrequirefailureof:));
[simultaneous recognition](https://developer.apple.com/documentation/uikit/uigesturerecognizerdelegate/gesturerecognizer(_:shouldrecognizesimultaneouslywith:));
[NavigationSplitView](https://developer.apple.com/documentation/swiftui/navigationsplitview);
[AnyLayout](https://developer.apple.com/documentation/swiftui/anylayout);
[NSOutlineView](https://developer.apple.com/documentation/appkit/nsoutlineview)
(type-select, data source pull).

**Compose / Flutter.**
[Nested scroll](https://developer.android.com/develop/ui/compose/touch-input/scroll/nested-scroll-modifiers);
[TextFieldState composition](https://developer.android.com/reference/kotlin/androidx/compose/foundation/text/input/TextFieldState);
[Snapshot](https://developer.android.com/reference/kotlin/androidx/compose/runtime/snapshots/Snapshot);
[SelectionArea / SelectableRegion](https://api.flutter.dev/flutter/widgets/SelectableRegion-class.html);
[MultiSelectableSelectionContainerDelegate](https://api.flutter.dev/flutter/widgets/MultiSelectableSelectionContainerDelegate-class.html);
[TwoDimensionalViewport](https://api.flutter.dev/flutter/widgets/TwoDimensionalViewport-class.html);
[pinned TableView jank](https://github.com/flutter/flutter/issues/161421);
[OverlayPortal](https://api.flutter.dev/flutter/widgets/OverlayPortal-class.html).

**Zed / GPUI.**
[Rope & SumTree](https://zed.dev/blog/zed-decoded-rope-sumtree);
[Project panel](https://zed.dev/docs/project-panel);
[Multibuffers](https://zed.dev/docs/multibuffers);
this repo's `gpui_sum_tree` (multi-dimension cursor: seek one dimension, read
another — the right shape for FlowIndex/Lattice/FlattenIndex).

**Sheets / CAD / Win32.**
[Sheets virtualization notes](https://dev.to/zeeshanali0704/frontend-system-design-google-sheets-3pfl);
[freeze+filter+virt coupling](https://www.syncfusion.com/blogs/post/freeze-panes-filtering-virtual-scrolling-angular-spreadsheets);
[Blender Outliner](https://developer.blender.org/docs/features/interface/outliner/);
[Win32 tree-view](https://learn.microsoft.com/en-us/windows/win32/controls/tree-view-controls).

**A11y / theme / others.**
[AccessKit live regions](https://github.com/RDMurray/accesskit/commit/a7ee1c9414cdeef0752212037b391c3ca322abad);
[Soueidan live regions](https://www.sarasoueidan.com/blog/accessible-notifications-with-aria-live-regions-part-1/);
[CSS theme swap cost](https://www.css-architecture.com/advanced-theming-dark-mode-implementation/runtime-theme-switching/);
[Slint TreeView gap](https://github.com/slint-ui/slint/issues/505);
[WPF IME composition echo](https://github.com/dotnet/wpf/issues/6194).
