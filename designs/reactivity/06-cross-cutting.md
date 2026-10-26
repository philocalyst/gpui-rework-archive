# 06 — Cross-Cutting Surfaces: Projections, Session Indexes, Protocols

Status: **companion to [07-the-ladder.md](07-the-ladder.md)** (authoring) and
[05-one-register.md](05-one-register.md) (proofs). History/undo is **not** a fifth
projection — it is [08-history.md](08-history.md). This revision folds in the higher-tier
research ([10-cross-cutting-higher-tier.md](00-research/10-cross-cutting-higher-tier.md)),
which corrected the first draft in eight places; the corrections are integrated below, not
appended.

## 0. The thesis, upgraded: projections, session indexes, protocols

The feedback pass identified the common shape of every top-tier gap: **coordination that spans
the architecture's deliberately local boundaries** — across siblings (selection), across two axes
(grids), across a hierarchy projection (trees), across mutable structural layout (docking),
across a pointer stream (gestures). The wrong fix is a second retained tree with its own
lifecycle (the classic drift failure). The fix this packet commits to has three nouns now, not
two:

> **A projection** is a read-only, incrementally maintained index over the manifest, updated by
> the same span splices the tape diff already emits — transactionally, in the same turn. It has
> no independent write path, so it cannot drift.
>
> **A session index** is a protocol-owned structure (SelectionGeometry, find MatchSet, DropGap,
> IME mark) leased from first protocol event to teardown, the way a drag preview is. It is not a
> projection: it has no meaning without its protocol, and PG2's oracle rebuilds it from protocol
> state + projections, not from the manifest alone.
>
> **A protocol** is a window-level state machine that owns cross-cutting interaction state and
> consumes projections. A primitive is elements + a projection + a protocol (+ its session
> indexes).

Projections are sum-tree-shaped (`gpui_sum_tree` already ships multi-dimension cursors — seek one
dimension, read another — exactly the right shape): O(log n) maintenance per splice, O(log n +
range) queries. Four projections cover the map:

| Projection | Summary per node | Serves |
|---|---|---|
| **FlowIndex** | text-run count, byte length, reading order | widget-tree selection/copy, a11y text order, find-in-UI |
| **Lattice** | two 1D extent sum-trees over the **visible arrangement** | grids, frozen panes, cell nav |
| **FlattenIndex** | expanded-subtree visible-row count | trees/outlines, scroll anchoring, type-select |
| **TokenIndex** | `(ScopeId, NameId)` → consuming slots | theme swap fanout |

Zero-cost rule, strengthened: a window with no `.selectable()`, no `grid()`, no `tree()`, no
theme tokens, and no live regions allocates **no** projection, claim table, or announcement
queue; and unused *protocols* cost zero too — session indexes never outlive their protocol.
First consumer leases; last drop reclaims.

One law the first draft under-stated, now normative: **the manifest is not the document.**
Editor buffers, multi-cursor selections, IME composition, and collaborative carets live on
*document* models (ropes, revisions) with their own algebras. Projections index what is
*presented*; they never become the model of what is *edited*. The two meet at overlay painting
and at "this subtree is one atom," nowhere else.

## 1. Cross-element text selection and copy

Select from the middle of one label to the middle of another three elements away, Cmd-C, get
verbatim text — what browsers do natively and nearly every Rust GUI punts.

**FlowIndex.** Shaped-paragraph facts already carry glyph↔byte source maps. The FlowIndex is a
sum-tree over the manifest's spans in *reading order* (the order the a11y tree already needs,
bidi-correct from shaping facts). A **flow position** is a generation-checked
`(span, run, byte, affinity)`; the protocol state is `(scope, anchor, focus)` — anchor and focus
are distinct from start and end because direction matters: shift-arrows and drag operate on
*focus*; copy serializes `[min, max]`.

**The composition law** (Flutter's `SelectionContainer` lesson, the decade browsers lost to
shadow-DOM selection):

```rust,ignore
reading_pane()
    .selectable(Select::Contain)       // scope root; the range cannot escape this subtree
    .child(chat_log(&self.messages))

code_block(&fence)
    .selectable(Select::Exclude)       // ONE flow atom to the parent; copies as alt text

impl ChatView {
    fn copied(&mut self, sel: SelectedText) -> Clipboard {
        Clipboard::rich(sel.markdown())        // optional interception; default is verbatim
    }
}
```

- `Select::Contain` clips the range to the subtree (CSS `user-select: contain`); nested `Exclude`
  punches an atom. **A nested selectable container — an editor, a form control — is one
  Selectable to its parent**, never a leak of its internals (the `getComposedRanges` re-scoping
  rule). Editors *puncture*: inside, the document protocol owns selection; outside, the whole
  editor is one atom.
- **SelectionGeometry is a session index**, not a FlowIndex query: disjoint rects (bidi, wraps,
  transforms) computed from **resident** selectables only, intersected with the drawable area,
  painted on the overlay lane. Drag = hit-test once on pointer-down, then focus + rect patches —
  zero owner Rust, zero materialization of off-screen ranges.
- **Live pins vs snapshots.** The protocol's endpoints are live and clamp under splices (browser
  behavior). Copy, find-highlight, and `AXSelectedText` take a **StaticRange** at the turn
  boundary; a structural splice must never mutate an in-flight clipboard payload. Off-screen copy
  materializes rows through the existing virtual-range request, bounded and async-for-huge.
- **The granularity algebra is complete, and it is one method**:
  `selection.modify(Alter::Extend, Dir::Forward, Gran::Word)` — character / word / line /
  paragraph / document. Mouse (double-click word, triple-click paragraph), keyboard, AT, and
  tests all call it; segmentation facts already exist in the text system.
- **IME preempts.** A marked (composition) range is a *third* range owned by the IME protocol on
  the focused atom; widget selection collapses at composition start and never echoes a write into
  the IME mid-composition (the WPF Pinyin bug, made unrepresentable by protocol precedence).
- The selection is a framework source: `selection::of(scope)` — wires and scopes consume it
  ("N characters selected" is free). Linux primary selection (middle-click) is a platform adapter
  on the same protocol with its own lifetime.

Zero-cost: no `.selectable()` in the window ⇒ no FlowIndex, no protocol, no geometry buffer.

Inline chips ([09-text.md](09-text.md)) are one FlowIndex unit each (U+FFFC). They copy as the
atom's replacement text, never the replacement character. They are not `Select::Exclude` unless
the chip itself is a nested Selectable (a mini-editor in a paragraph — puncture, v2).

## 2. 2D data grids

Excel's shape, not a list of lists: **one lattice, two scroll offsets, four clipped viewports
sharing cell facts.** Frozen panes are the same cells drawn in a clip that ignores one scroll
axis — never extra rows in the virtualizer.

```rust,ignore
grid()
    .columns(keyed(&self.columns).by(Col::id))
    .rows(virtualized(self.rows.filtered(&self.query)).by(Row::id))   // the ARRANGEMENT
    .cell(Self::cell)                              // fn(&Row, &Col) -> impl Element + '_
    .frozen_columns(1)
    .frozen_rows(1)
    .selection(&self.cells)                        // Signal<CellSel>
    .on_edit(Sheet::edit_cell)                     // punctures into the editor protocol

struct CellSel {
    anchor: CellRef,                               // (row_key, col_key) — DATA coordinates
    focus: CellRef,
    extra: KeySet<CellRef>,                        // cmd-click islands; usually empty
}
```

- **Lattice of the arrangement, never the store.** Filter/sort produce the visible arrangement
  (collections.md); the Lattice subscribes to *that* order. Freeze + filter + virtualization
  share one coordinate space or headers drift (the Syncfusion failure).
- **Never iterate the gap.** The resident set is `(frozen ∪ viewport_band) × (frozen ∪
  viewport_band)` — never `0..scroll_index` (Flutter's 20k-row pinned-pane jank). Scroll is two
  transform patches; the frozen row strip shares the body's x-transform (linked header scroll,
  compositor-side); PG4 asserts "frozen header at row 100k, then horizontal fling."
- **Cell cursor ≠ selection.** The ARIA grid pattern: one tab stop, arrows move the cursor;
  `CellSel` adds anchor+focus range extension (shift-arrows, shift-click) and copy-as-TSV of the
  logical range (bounded / async-for-huge). Enter-to-edit mounts an editor in the focus cell and
  `Select::Exclude`s it from the grid's FlowIndex. `aria-rowindex`/`colindex` are data
  coordinates, so they survive virtualization.
- **Sparse by construction.** Extents are O(rows + cols); cell facts exist only for non-empty or
  resident cells — a 100k×1k logical grid is never 10⁸ spans. Spanning cells are interval
  entries; arrows land on the origin; a11y has one owner per covered coordinate (04's rule).
- **Sash resize** is the VS Code `Sash` protocol: hover affordance, drag patches a width signal
  (machine-rate, wire), snap-to-min, double-click reset. Column reorder is a keyed splice in the
  column tree — the point of keying both axes.

Zero-cost: no `grid()` ⇒ no Lattice; identity is `(row_key, col_key)` with no `.key()` in cells.

## 3. Virtualized trees and outlines

NSOutlineView's pull model plus Zed's flatten, not SwiftUI `OutlineGroup` (which still can't
reliably select nested rows — the warning that "just flatten in the view" is not a primitive).

```rust,ignore
tree()
    .roots(&self.workspace.roots)
    .children_of(Node::children_state)     // fn(&N) -> Children<N>: PULL, not eager
    .expanded(&self.expanded)              // Signal<KeySet<NodeId>>; two-way with the protocol
    .marks(&self.marked)                   // Signal<KeySet<NodeId>>; cursor ≠ marked set
    .row(Self::node_row)
    .hover_expand(300.ms())
    .on_reorder(Workspace::move_node)      // Move { src: KeySet<NodeId>, dest: DropGap<NodeId> }

enum Children<'a, N> {
    Leaf,
    Ready(&'a [N]),
    Pending,        // one placeholder row with disclosure + spinner; pinned until Ready
}

struct DropGap<K> { parent: K, index: u32, onto: bool }
```

- **Children are pulled, and may be pending.** `node_modules` with 200k children cannot be
  materialized at expand; `Pending` is one row fact, the app's `Latest<Vec<Child>>` work edge
  (07) is the async story, and `Ready` arrives as one contiguous splice — the tree protocol
  spawns nothing.
- **FlattenIndex** summarizes visible-subtree row counts; expand/collapse is one splice; (row ↔
  key ↔ depth) is O(log n). Expand materializes only the visible band + overscan.
- **Scroll anchoring by key** — `(anchor_row_key, offset_within_row)` re-derived after each
  splice — handles inserts above; **keep-visible on expand** handles the focused row growing
  downward off-screen (autoscroll, NSOutlineView behavior). Both, not one.
- **Cursor ≠ marks.** Focus is one row; shift-arrows *mark* a `KeySet` that cut/copy/drag/trash
  consume — product-critical for an IDE panel. **Collapse rebases**: collapsing a parent moves
  cursor, marks, and any active drop target onto the parent or next visible row — never a
  dangling key (the `TVN_SELCHANGING`-style veto/rebase rule from collections.md, applied).
- **Drop is a gap, not a row.** `DropGap` geometry is a session index during drag, painted as a
  line or "onto folder"; hover-expand after a delay (Finder); concurrent model changes rebase the
  gap or reject.
- **Type-select** (NSOutlineView): a short-lived prefix query over FlattenIndex labels moves the
  cursor; it is not a command palette.

Zero-cost: no `tree()` ⇒ no FlattenIndex; DropGap dies with the drag.

## 4. Docking and panel management

**Two algebras, not one** — VS Code's lesson, adopted as the complexity cap (Theia/Phosphor's
fully-dynamic dock is explicitly rejected; Zed's three-edge dock is too weak to be the
primitive):

```rust,ignore
struct Workspace {
    chrome: Workbench,                      // slots (sidebar/panel/status) + visibility + sizes
    editors: EditorGrid,                    // recursive splits of GroupId; sashes; locked groups
    groups: ComponentMap<GroupId, Tabs<ViewportId>>,
    viewports: ComponentMap<ViewportId, EditorView>,   // N viewports…
    documents: HashMap<DocId, Document>,               // …one model (§9)
    panels: ComponentMap<PanelId, Panel>,
}

impl View for Workspace {
    fn view(&self) -> impl Element + '_ {
        workbench(&self.chrome)
            .slot(Slot::Sidebar, dock_stack(&self.chrome.sidebar, |id| self.panels.element(id)))
            .slot(Slot::Panel,   dock_stack(&self.chrome.panel,   |id| self.panels.element(id)))
            .center(editor_grid(&self.editors).group(|gid| self.groups.element(gid)))
            .on_chrome(Workspace::chrome_changed)    // fn(&mut Self, ChromeDelta)
            .on_grid(Workspace::grid_changed)        // fn(&mut Self, GridDelta)
    }
}
```

- **`ChromeDelta`** (move view between slots, visibility, sizes) and **`GridDelta`** (split,
  merge, retab, lock, activate) are separate typed algebras — persistence, "reset layout," and
  "open to the side" policies stay sane because chrome and editor splits never share a tree.
  Both are delta algebras: serializable, invertible, testable ("this drag produced exactly
  `[Retab, Split]`"), journal-eligible.
- **The dock drag protocol** proposes deltas the app applies or vetoes; tab-drag *between*
  chrome and grid is legal (Explorer → Panel) and typed. **The sash protocol** is distinct:
  machine-rate width signal + snap + double-click reset + linked 2×2 corners — an interaction,
  not a `Resize` commit. **Iced `pane_grid` steals, onto this protocol not their tree:**
  split **ratio in 0..1** (not pixels — restore survives window size); sash **leeway**
  (hit target is `spacing + leeway`, visual sash stays thin); **last-active** pane (new
  splits / paste / focus land there); **maximize** one pane (the others keep their ratios,
  restore is one flag). Drag-drop of pane content is a `GridDelta`, same as today.
  Sketch: [docking.rs](examples/docking.rs).
- **Layout stores ids, never state.** Panels/editors are registered kinds; closing a split never
  drops `panels[id]`; restore **skips unserializable inputs** and adjusts sticky indexes
  (VS Code's `editorGroupModel` rule) instead of failing the whole layout.
- **Float is a native auxiliary window** with its own grid leaf (drag a tab out of the window),
  riding the existing portal/auxiliary-surface machinery — ids move; panel state does not clone.

## 5. Gesture recognition and conflict arbitration

**Three machines, composed — not predicate racing.** The first draft's "first predicate wins,
innermost breaks ties" loses tap-vs-double-tap (you cannot race a 300ms wait), nested scroll,
and machine-rate pan. The normative arbitration order:

1. **Static compositor claims** — `.pan(Pan::VERTICAL | HORIZONTAL | AUTO | NONE)`, the
   `touch-action` analog: the intersection along the hit path is declared *before* any event, so
   resident scroll starts on the motion lane without consulting recognizers at all. When the
   compositor takes the stream, recognizers receive `pointercancel`. This — not winning a race
   after 8px of slop — is what keeps list scroll at zero Rust.
2. **The failure DAG** — `swipe.after_failure_of::<Tap>()` / `requires_failure_of` (UIKit's
   `require(toFail:)`): *wait until the other fails*, evaluated lazily, both directions, once
   per attempt. Buffered motion replay (kept from the first draft) makes the wait cheap for
   continuous gestures; **delayed delivery of discrete actions** (`delaysTouchesBegan` analog)
   holds a child's tap until the DAG resolves.
3. **The nested-scroll pipeline** — scroll deltas are not a claimant: pre-scroll (ancestor may
   consume) → child consumes → post-scroll (ancestor takes the remainder), same for fling
   (Compose's `NestedScrollConnection`). Collapsing toolbars and swipe-on-a-card-in-a-list are
   pipeline problems, not conflicts.
4. **Pairwise, asymmetric simultaneity** — `rotate.simultaneous_with::<Pinch>()`; a third
   recognizer never silently joins.
5. **Innermost-wins** — only as the tie-break among still-`Possible` recognizers with no DAG
   edge.

```rust,ignore
list_region().pan(Pan::VERTICAL)                        // machine 1: compositor claim

message_row(msg)
    .gesture(Swipe::horizontal().on_commit(Inbox::archive.with(msg.id)))   // fails the pan on
    .gesture(LongPress::default().after_failure_of::<Tap>()                // horizontal dominance
        .on_commit(Inbox::context_menu.with(msg.id)))

canvas_view()
    .pan(Pan::NONE)                                     // a map owns all axes
    .gesture(Pinch::default().pipe(&self.zoom))
    .gesture(Rotate::default().simultaneous_with::<Pinch>().pipe(&self.rotation))
```

The recognizer set is closed (tap, long-press, drag, swipe, pinch, rotate, scroll) plus one
custom trait — no subclass zoo. **IME preempts the table** during composition (04's key-routing
law extended to pointers). Losers get typed `Cancelled { winner }`; momentum continues a claimed
gesture's velocity on the motion lane. The inspector shows the DAG and the pipeline accounting —
*waited-for-failure*, consumed/leftover deltas — not just "who claimed"; that trace is the
debugging surface every platform lacks.

Zero-cost: no `.gesture()` + default `pan(AUTO)` ⇒ empty DAG, no recognizer allocation, scroll
works.

## 6. Container and self-size queries

The web's hard-won rule, taken one step further than the first draft: **you never query
yourself** — a size query targets a *named ancestor* that declared containment on that axis. The
first draft's `.container()` on the querying card was self-size and reopened the cycle for
shrink-to-fit widths; named ancestors make self-query unrepresentable.

```rust,ignore
sidebar()
    .container("rail", Axis::Horizontal)   // containment declaration; mount-checked:
    .child(card()                          //   this axis is independent of children
        .when_container("rail", width::below(px(400.)),
            style().direction(Axis::Column).hide("meta"))
        .padding_x(cqi(4.))                // container-relative length: 4% of "rail"'s inline size
        .child(card_body(&self.item)))

virtual_list(...)
    .sticky_header(RowKind::Section)
    .when_scroll(ScrollState::Stuck, style().shadow(tokens::stuck_shadow()))
```

- Resolution is one top-down pass interleaved with layout: the container settles →
  `when_container` variants resolve → children lay out. No iteration; a `.container()` whose
  declared axis would depend on its children is a located mount error naming the constraint.
- **Container-relative lengths (`cqi`/`cqb`)** avoid the variant explosion for continuous
  scaling; they are layout inputs resolved after the container settles, same pass.
- **Scroll-state queries** (`Stuck`, `Snapped`, `Scrollable`) style sticky headers and
  scroll-driven variants from compositor/scroll facts — like `:hover`, not like layout — so the
  "shadow when stuck" case cannot be hacked into a layout cycle.
- Style-only queries need no containment (descendant style cannot affect ancestor style). Only
  the active variant exists (output-owned, as `responsive_style`).

## 7. Live-region accessibility

The shipping ARIA contract, not "patch text and hope":

- **The region must exist in the a11y tree before the change** — same-turn create-and-fill is
  silently dropped by real ATs. The framework owns hidden, always-mounted polite/assertive hosts
  per window; `Announce::polite("Saved")` (an ordinary effect value) writes them.
- **Announce a dedicated string, not child text.** AccessKit wants `Node::live()` + the node's
  `value`; walking descendant text yields "button Saved button." `.announce(&self.save_status)`
  is a wire into the semantic value only.
- **Mount is silent.** A status bar whose initial text is "Ready" says nothing on window open;
  only subsequent changes announce.
- **Atomicity and batching are explicit**: `.atomic()` (whole region vs delta; `role=status` ⇒
  polite+atomic, `role=log` ⇒ polite, not atomic), `.busy()` around a batch.
- **Coalesce across turns, per region**: rapid "Saved"×3 collapses to latest-wins under a
  per-region rate limit — VoiceOver queue-bombing is a bug class, not a style choice. Distinct
  concerns (status, errors, grid cell changes) get distinct regions so context survives.
- `aria-relevant` is not exposed (AT support is junk).

```rust,ignore
status_slot().live(Polite).atomic().announce(&self.save_status);
form.submit_errors().live(Assertive).atomic().announce(&self.errors);

fn saved(&mut self) -> Announce { Announce::polite("Saved") }
```

Zero-cost: no `.live()` and no `Announce` ⇒ no queue, no AccessKit live bits.

## 8. Theme-swap fanout

TokenIndex already beats CSS (browsers invalidate subtrees because they can't know who
`var()`-references a property; exact consumer sets are the correct end-state — the bloom-filter
skip is explicitly rejected as strictly worse). The corrections:

- **Tokens are scoped**: `TokenId = (ScopeId, NameId)` — editor chrome, buffer, and terminal
  palettes are different scopes, so a terminal tweak never walks editor consumers that share the
  name `danger`. `theme.swap(scope, table)` walks only that scope's changed names.
- **Paint vs layout tokens are tagged**, and the default theme profile carries a **CI gate:
  `layout_tokens_patched == 0`** on a theme flip — the counters cannot go green while the window
  secretly reflows.
- **Animating a token is a located error.** Theme swap is one turn, not a spring (root-scoped
  per-frame variable updates are the documented full-tree style-recalc killer). Animated color
  belongs on an element's own wire.
- Environment facts (dark mode, dynamic type) *select* a table; if the table identity didn't
  change, they are not 10k writes.

Authoring is unchanged: `theme::danger()` stays a late-bound value. Gate: 10k paint consumers =
10k slot patches, zero description, zero layout. Token *values* are tagged `Color`
([runtime/color.md](runtime/color.md)); mix/contrast live there, fanout lives here.

**Pairs, not orphan fills.** A role is `(fill, on)` — Slint Palette / Iced `Pair`. `theme.accent`
in a fill port is `fill`; `theme.accent.on` is the ink that is legal on it. Contrast is a CI
gate (color.md §5). `.look(Look::Accent)` applies the pair plus the widget's hover/active/disabled
layers from the same recipe. Tables (Fluent / Mac / dark) swap as a TokenIndex table, not a
widget fork.

**Seed generator (Iced 0.14 Oklch).** `Palette::generate(seed, Scheme::Dark)` produces a table
of pairs. Optional; hand-written tokens remain valid. Generation is not a frame, not a spring.

**Subtree scope.** `column().token_scope(Scope::Terminal)` is Iced's `themer`. A terminal
`danger` never walks editor consumers that share the name (already `TokenId = (ScopeId, NameId)`).

## 9. Protocols the map needs that are not new projections

Each rides existing projections; each is leased; none is a fifth always-on index.

- **Find-in-UI**: a `MatchSet { query, current, rects }` session index over FlowIndex, leased
  while the find bar is open. Highlight-all is overlay rects from resident matches; next/prev
  seeks the index and materializes virtualized hits through the same range request as copy —
  the search is over the *logical* flow, never just resident spans. A search generation rebases
  highlights the way selection endpoints clamp. Distinct overlay layer from selection.
- **Drag autoscroll**: pointer in an edge band during drag/selection continues scroll on the
  motion lane; the drag source and active drop target become **retention reasons** so the
  virtualizer cannot unmount them mid-gesture (collections.md's list, extended). Zero owner Rust
  per frame.
- **Roving focus**: one tab stop per composite (list/tree/grid); arrows move within, wired to
  FlattenIndex/Lattice coordinates; the focused key is pinned and focus restores by key across
  virtualization. The focus ring is an **overlay-lane stroke** (shadows clip to overflow; rings
  must not). `aria-activedescendant` only where platform focus must stay on an input (combobox).
- **N viewports, one document — stated as a law.** Split editors, cloned tabs, multibuffers,
  collaboration: `Document` owns the rope/revision; each `EditorView` owns scroll +
  `Vec<Selection>` + folds; overlay paints N carets from N view states. This is not docking and
  not FlowIndex; multi-cursor and column select live here, in the editor crate, sharing only
  overlay painting with §1.
- **History / undo tracks**: not a fifth projection. The revision DAG and activity tracks are
  [08-history.md](08-history.md); 06 only notes the seam. Dock `ChromeDelta` / `GridDelta` are
  already journal-eligible `Delta`s. Cmd-Z is routed by focus to the nearest exposed `Track`,
  the same way a context menu is opened from a target identity — never from a captured block.
  Gesture sessions (this section's drag / IME / sash) are `Silent` on the track until commit;
  Cmd-Z mid-drag cancels the gesture rather than inverting a half-drop (08 §13).
- **Context menus**: opened from a *target identity* (not just coordinates — AppKit's
  `menu(for:)` law), mounted through the overlay portal so they inherit theme/focus scope and
  cannot outlive their anchor; keyboard complete (arrows, typeahead, Shift-F10/Menu key,
  escape/click-outside/focus-loss dismissal). Overlay hit uses GPUI's existing
  `BlockMouseExceptScroll`: a modal that occludes clicks can still let the list under it
  wheel. It is not capture-everything.
- **Sticky headers**: a compositor clip+offset **pin of a span already in the list** — never a
  duplicate row; the pinned key is a retention reason; styled via scroll-state `Stuck` (§6),
  which is what keeps it out of layout.
- **Minimap / semantic zoom**: views over Lattice/FlattenIndex extent summaries; app-level, no
  new index.

## 10. Rejected (kept explicit so it stays rejected)

Unifying editor selection with FlowIndex; a second selection/a11y tree; quadtrees for grids
(two 1D sum-trees are the Excel answer); `contenteditable`'s two fighting selection systems;
Theia/Phosphor fully-dynamic docking; self-size container queries and unrestricted query
iteration; recognizer subclass zoos; predicate racing as arbitration; `aria-relevant`;
per-frame theme-token animation; bloom-filter token invalidation; Deep-Zoom/fill-handle/formula
graphs as framework primitives (sheet/editor crates own them).

## 11. Gates

- **PG1 — projections and protocols are leased.** Per-splice maintenance is O(log n) and
  counter-visible; a projection with no consumers costs zero (lazy build, dropped with last
  lease); **unused protocols and their session indexes cost zero**; MatchSet/Geometry/DropGap/
  ImeMark die with their protocol.
- **PG2 — no-drift oracle.** Dev builds rebuild each projection from scratch and compare (P10);
  session indexes rebuild from protocol state + projections. Divergence names the splice.
- **PG3 — protocol fault injection.** Selection, cell cursor, dock drag, sash, gesture DAG, find,
  IME: span retirement mid-gesture, window loss mid-selection, splice under an active anchor,
  collapse under cursor/marks/drop, compositor-steal (`pointercancel`) mid-recognition.
- **PG4 — the grid bar.** 100k×1k: scroll = two transform patches; frozen panes pixel-locked;
  **frozen header at row 100k then horizontal fling** stays on the compositor; the resident-set
  query never iterates the frozen-to-viewport gap.
- **PG5 — a11y equivalence.** FlowIndex order ≡ semantic-tree text order by construction, tested
  against the reference serializer — one order, two consumers, or the thesis failed.
- **PG6 — compositor claims.** A default `pan(VERTICAL)` list begins resident scroll on the
  motion lane without entering the recognizer DAG; `pan(NONE)` never emits a native pan;
  nested-scroll deltas are accounted pre/child/post in the work counters; a stolen stream
  delivers `pointercancel` exactly once.
