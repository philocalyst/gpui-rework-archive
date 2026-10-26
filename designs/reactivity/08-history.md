# 08 — History: The Model Records, The UI Tags

Status: **design of the `gpui_history` crate** — a library over the kernel's delta log, not
kernel law. The split is [07 §15](07-the-ladder.md): the kernel ships only sealed invertible
deltas, an opt-in per-turn delta log, `Origin` on transactions, and a gesture token; *this
crate* owns `Track`, the revision DAG, tagging, selective `undo_node`, Cmd-Z routing, the
union view, `FileStore` persistence, and Sudden Termination fsync. `impl History` is a library
trait; `gpui` links none of this (gate L6 audits the symbol table). Text-document undo stays
in the editor crate; this crate wraps that rope history as one `Track` — the
`QTextDocument`/`QUndoStack` split. 07's public spelling wins where they disagree on
authoring. [03-hybrid-plan.md](03-hybrid-plan.md) §1.6 and
[04-less-is-more.md](04-less-is-more.md) §12 are the decision record that this absorbs.

This is the answer to hole 10 ("undo is several stacks") and to Sudden Termination: **Cmd-Z is
a view over a recorded model, never a stack of closures.**

---

## 0 · The law

Quentin Mathe, on why Cocoa undo never serialised:

> Sudden Termination meant that you needed to persist undo state, and the simplest way of doing
> undo was having NSUndoManager capture a block, which doesn't lead to a nice serialisation
> model. We addressed this in EtoileUI / CoreObject by having the **model track prior states
> (and transitions, for redo and rebase-like operations)** and the **UI decide which ones wanted
> to be tagged as the result of pressing the undo button.**

That split is the whole architecture, restated as one law:

> **The model records. The UI tags.**
> Capture is automatic and is always a value. Tagging is presentation policy. Closures never
> enter the journal. An undo is an ordinary transaction with `Origin::Undo`.

NSUndoManager recorded *how to talk to the UI later*. CoreObject recorded *what the model
became, and how*. Apple started down this road with Core Data, then gave up. We take the
CoreObject split and encode it in traits that the ladder already produces for free: every
sealed `List` op, every journaled `Signal` write, every text splice, every dock delta is
already a `Delta`. The UI's job is to mark which of those are one press of Cmd-Z.

Consequences, each of which deletes a class of undo bug:

- **No blocks, no invocation trampolines, no "register the inverse by performing it."**
  Sudden Termination, process isolation, inspector time-travel, and collaboration all consume
  the same bytes.
- **Redo is retained forward transitions**, not a second recording of "whatever the undo
  just did." Branching and selective undo are transformations on that algebra, not a second
  history system.
- **Focus does not own history.** Focus *selects a track* — a view over the recorded DAG.
  A text field, a canvas, and a board can share one document's revisions and still have
  three Cmd-Z meanings.
- **Unused history costs nothing.** An owner that does not implement `History` allocates
  no track, no DAG, no coalescer. Ordinary mutation has no history tax.

---

## 1 · Two graphs, not one stack

CoreObject's load-bearing idea, kept verbatim: **history is two-level.**

| Graph | What a node is | What it is for | Analog |
|---|---|---|---|
| **Revision DAG** | a `Revision` — a state the model actually occupied, plus the `Delta` that produced it | never-lose-work, timeline UI, cheap copy, collaboration, crash recovery | git commits per persistent root |
| **Undo Track** | a `Node` — a *tagged* revision (or group of revisions) this activity considers one Cmd-Z | the Edit menu, per-field undo, per-canvas-stroke undo | CoreObject `COUndoTrack`; Yjs `UndoManager` |

A track is **not** the data. It is a cursor over the DAG plus a filter of which revisions
this activity tagged. Several tracks may view one DAG:

- the document timeline (every revision, including Silent);
- the user's Edit-menu track (tagged Points only);
- a field's IME-aware document lane;
- a canvas's stroke lane;
- an inspector's own track, which must never steal Cmd-Z from the document.

Union of tracks (CoreObject's "undo stack union view") is how a workspace Edit menu
presents "Undo Rename Column" vs "Undo Typing" vs "Undo Stroke" without those systems
knowing about each other: the focused track wins; the union is the fallback when focus
is on chrome that has no track.

```text
Revision DAG (per History owner / persistent root)
    r0 ──Δ1── r1 ──Δ2── r2 ──Δ3── r3
                     ╲
                      Δ2'── r2'     ← user typed after undo; the old r2–r3 path remains

Track "Edit menu"     :  (r1 tagged "Add column") → (r3 tagged "Move card")
Track "Title field"   :  (r2 tagged as text coalesced "Typing")
Track "Timeline UI"   :  every revision, scrubbable
```

Linear undo moves the track cursor toward the root. Redo moves it toward the head of
*this track's path*. A new edit after undo **forks the DAG** and the track follows the
new path; the abandoned path stays addressable for a timeline, for selective undo, and
for "redo the other thing" in a history panel. That is git plus an activity cursor, not
two stacks that destroy the future.

---

## 2 · The trait stack

The entire public surface is four traits. The enums they return (`Invertibility`, `ApplyError`,
`Conflict` / `ConflictReason`, `Tag`, `Origin`) are the fallible vocabulary — not a parallel
API. Nothing else is named in application code.

### 2.1 `Delta` — a value that happened

```rust,ignore
pub trait Delta: Clone + Serialize + DeserializeOwned + PartialEq + 'static {
    type Model: ?Sized;

    /// Apply this transition. Must be deterministic. Must not spawn tasks,
    /// talk to the network, or announce — those are effects, and effects are
    /// not undone (§11).
    fn apply(&self, model: &mut Self::Model) -> Result<(), ApplyError>;

    /// The inverse transition, self-contained. `invert().apply(after)` restores
    /// `before` byte-for-byte for `Invertibility::Exact`. The inverse carries
    /// whatever it needs (the old title, the taken row, the spliced text);
    /// it does not close over `model`.
    fn invert(&self) -> Self;

    /// Coalesce two adjacent deltas of the same kind into one. `Err` means
    /// "keep both" — the coalescer stores the pair. Used for typing bursts,
    /// slider scrubs, and stroke samples.
    fn compose(self, next: Self) -> Result<Self, (Self, Self)>;

    /// Operational transform: what this delta looks like after `concurrent`
    /// has already been applied (`ours == true` ⇒ we were first). Identity
    /// for commutative structural ops (slot-keyed List moves vs a rename of
    /// another row). Required for text and for selective undo of an old node
    /// whose later siblings share an address space.
    fn transform(&self, concurrent: &Self, ours: bool) -> Self;

    fn invertibility(&self) -> Invertibility { Invertibility::Exact }
}

pub enum ApplyError {
    /// Selective undo / rebase: later work depends on this node.
    Conflict(Conflict),
    /// `invertibility` is `Irreversible` (an external side effect).
    Irreversible,
    /// The model refused the transition (validation).
    Rejected { reason: SharedString },
}

pub struct Conflict {
    pub node: NodeId,
    pub reason: ConflictReason,
}

pub enum ConflictReason {
    DependsOn { later: NodeId },
    SlotGone,
    RangeDestroyed,
}

pub enum Invertibility {
    Exact,          // invert() is a perfect restoration
    Snapshot,       // invert() is a before-image; large, honest
    Coarse,         // invert() restores a checkpoint; finer points inside are lost
    Irreversible,   // must not be tagged as a Point; capture is still legal for the DAG
}
```

Sealed implementations the kernel already has — authors never write these:

| Source | `Delta` | Inverse | Compose |
|---|---|---|---|
| `List::push/take/insert_at/move_before` | `ListDelta<T>` (slot, index, item-or-none) | the complementary splice; **slots make this exact** | adjacent pushes compose; mixed ops don't |
| a signal write (`*cell = v` / in-place `DerefMut`, 07 §1) on a journaled cell | `Replace<T>` | `Replace(old)` | last write wins, old stays the oldest inverse |
| plain field via `commit().replace` | `FieldReplace<Sel, T>` | `mem::replace` both ways | same selector + same gesture |
| text document | `TextEditDelta` (range, old, new, revision) | swap old/new, transform carets | adjacent inserts at the caret compose |
| dock | `ChromeDelta` / `GridDelta` (already invertible in 06) | the documented inverse | same sash-id scrubs compose |
| canvas stroke | `StrokeDelta` (path id, added samples) / `EraseDelta` | remove those samples / restore | samples of one gesture compose |
| wildcard aggregate | `Checkpoint<M>` where `M: Clone` | restore the snapshot | never; it's already coarse |

A domain op that is not a sealed cell op implements `Delta` once. Cross-column
`move_card` *can* be `take` composed with `insert_at` (two List deltas, one tag) or
one `MoveCard { slot, from, to, index }` — the latter is nicer to serialise and to
show in a history panel. Both are legal; the kernel does not care.

**There is no `Box<dyn FnOnce()>` anywhere in this crate.** A test can assert
"this click produced exactly these deltas" with no window. The inspector's
time-travel slider is `Track::set_current`. Collaboration is `transform` against
a remote origin. Persistence is `Serialize`. One algebra, learned once.

### 2.2 `History` — opt-in, zero tax otherwise

```rust,ignore
pub trait History: Sized + 'static {
    /// Which activity this owner journals into by default.
    /// `MainHistory` is the Edit-menu scope; a document, canvas, or inspector
    /// names its own type so tracks cannot silently merge.
    type Scope: TrackScope = MainHistory;

    /// Optional: persist this owner's DAG across Sudden Termination.
    /// Default is in-memory, byte-budgeted, dropped with the owner.
    type Store: HistoryStore = MemoryStore;
}

pub struct MainHistory;
pub struct DocumentHistory;
pub struct CanvasHistory;
pub struct InspectorHistory;
```

Implementing the trait is the whole opt-in. The `Track` lives in a side table keyed
by the owner's generation — **the struct does not grow a field** unless the author
wants to hold a `TrackRef` for a timeline UI or for explicit serialisation.

```rust,ignore
impl History for Board {
    type Scope = MainHistory;
    type Store = FileStore;   // survives Sudden Termination; default is MemoryStore
}
```

A `Board` that does not implement `History` can still `push` and `set`. Those writes
are not captured. That is the 04 rule, kept: *ordinary mutation has no history tax.*
The compiler error for `board.undo()` on a non-`History` type names the trait.

### 2.3 `Track` — the Cmd-Z view

```rust,ignore
pub struct Track<M: History> { /* cursor, tagged nodes, coalesce state; Copy handle */ }

impl<M: History> Track<M> {
    pub fn undo(&mut self) -> Option<NodeId>;
    pub fn redo(&mut self) -> Option<NodeId>;
    /// Selective: invert one past node, transform later tagged nodes across
    /// that inverse, commit the result as a *new* revision. The DAG is not
    /// rewritten. This is CoreObject `undoNode:` and git-revert, not
    /// git-reset.
    pub fn undo_node(&mut self, id: NodeId) -> Result<NodeId, Conflict>;
    pub fn redo_node(&mut self, id: NodeId) -> Result<NodeId, Conflict>;
    pub fn current(&self) -> NodeId;
    pub fn set_current(&mut self, id: NodeId);   // timeline scrub; origin = Restore
    pub fn can_undo(&self) -> bool;
    pub fn can_redo(&self) -> bool;
    pub fn label(&self) -> Option<&str>;         // "Undo Move card" for the menu
    pub fn barrier(&mut self);                   // Yjs stopCapturing
    pub fn nodes(&self) -> impl Iterator<Item = TrackNode<'_>>;
}
```

`undo` / `redo` / `undo_node` are ordinary transactions with `Origin::Undo` /
`Origin::Redo`. Controls treat them as external edits under the echo rules;
IME composition is aborted or committed first (never a half-composed inverse).
The menu title is the current node's tag label, localisable.

### 2.4 `Tag` — the UI half of the law

```rust,ignore
pub enum Tag {
    /// Captured on the DAG, invisible to Cmd-Z. IME composition, in-flight
    /// drag, programmatic rebase, remote echo we did not originate.
    Silent,
    /// One press of Cmd-Z. The label is presentation, not identity.
    Point { label: Cow<'static, str> },
    /// Merge with the previous node if the coalesce key matches and no
    /// barrier has been hit. Typing, scrubbing, stroke sampling.
    Coalesce { key: CoalesceKey, label: Cow<'static, str> },
}

pub enum Origin {
    Local,          // this user's handler
    Remote(PeerId), // collaboration
    Undo,           // applying an inverse
    Redo,           // applying a retained forward
    Restore,        // timeline scrub / crash recovery
    System,         // layout restore, migration
}
```

Capture always happens (for a `History` owner). Tagging is how the UI answers
"is this the undo button?" The default tagger is the **gesture token** the
dispatcher already mints for capture/cancellation (04 §12): a click is one
`Point`; an IME session is `Silent` until commit, then one `Coalesce` keyed by
the field; a drag is `Silent` samples plus one `Point` on drop; a slider is
`Coalesce` keyed by the port.

Authors override tagging without touching capture:

```rust,ignore
fn add_column(&mut self) {
    self.columns.push(Column::default());          // captured automatically
}                                                  // tagged Point("Add column") from the click gesture

fn send(&mut self) {
    self.track().commit("Send", |board| {          // one Point, two lanes
        board.draft.clear();                       // document-lane inverse
        board.threads.insert_at(0, thread);        // structural inverse
    });
}
```

`commit(label, f)` is the only grouping primitive. It is a must-use builder if
called without a closure (`self.track().commit("Rename").replace(...)`);
forgetting the terminal is a compile warning, never commit-on-drop. Nested
`commit` inside `f` flattens: the outer label wins. There is no ambient
"transaction mode" on the app.

---

## 3 · Capture is automatic; the ladder is the generator

The sealed op set of 07 §1 is already invertible. History does not add a second
write path. It *listens*.

| Write | Captured when | Default tag |
|---|---|---|
| `list.push/take/insert_at/move_before/edit` | owner: `History` | gesture's tag (click → Point named from the handler) |
| a signal write (`*signal = v`, `*signal += 1`, autoderef `&mut` edits — 07 §1) | the cell is `.journaled()` **or** the owner is `History` and the cell is not `.ephemeral()` | Coalesce if the gesture says so, else Point |
| plain field assign in a handler | only inside `commit().replace(selector, value)` — plain `self.title = x` is *honestly not undoable* | the `commit` label |
| two-way control writeback | journaled cells only; IME composition is Silent until the IME protocol commits | Coalesce keyed by the field |
| `Task` / `spawn` / `Announce` / HTTP | **never** | — |
| remote apply | captured on the DAG with `Origin::Remote`; tracks that did not originate it do not tag it as their Cmd-Z | Silent on local tracks (Yjs `trackedOrigins`) |

The two signal marks are deliberate, and they are *types at rest*, not annotations
in the view:

```rust,ignore
filter: Signal<String>,                    // journaled if Board: History
playhead: Signal<f32>,                     // .ephemeral() in the constructor — scrubbing
                                           // the timeline is not Cmd-Z
title: Signal<String>,                     // .journaled() even if the owner isn't History
                                           // (a widget that owns its own tiny track)
```

Default for a `History` owner: cells are journaled, machine-rate ports are
ephemeral. The compiler error for `playhead` without `.ephemeral()` when it is
piped from `canvas().on_frame` is: "a live port cannot be a journaled cell;
mark it `.ephemeral()` or do not implement `History` on this owner." That is
the mix-path version of hole 10.

Plain fields stay plain. Making every `self.title =` magically undoable would
reintroduce NSUndoManager's "capture whatever happened" and would serialise
poorly (no selector). The `commit().replace` spelling is the honest opt-in for
a field that isn't a cell:

```rust,ignore
fn set_title(&mut self, t: String) {
    self.track().commit("Rename").replace(|b| &mut b.title, t);
}
```

Or promote `title` to `Signal<String>` and let capture do it. That is the
ladder, applied to history: **the type is the price, including the history
price.**

Nested writes (`get_mut(slot).cards.push`) emit an inner `ListDelta` and an
outer republish. The journal stores the inner delta; the outer republish is
derived on apply (07 §1 already prices that republish as one row). Selective
undo of the inner push does not need the outer delta.

---

## 4 · Routing: focus picks a track, not a stack

EtoileUI's useful idea, kept: a generic Undo control resolves the **nearest
exposed track**. A closer provider overrides. Libraries never name the host's
storage.

```rust,ignore
// App chrome. The focused descendant's track wins; union is the fallback.
desktop()
    .child(window(WindowKind::Document, &self.workspace).history::<MainHistory>())
    .child(window(WindowKind::Utility, &self.inspector).history::<InspectorHistory>())  // cannot steal Cmd-Z

menu_item("Undo")
    .on_select(history::undo)
    .shortcut(Key::Z.primary())
menu_item("Redo")
    .on_select(history::redo)
    .shortcut(Key::Z.primary().shift())
```

Resolution order, evaluated at key-down (not at view):

1. **IME composition** — if a composition is open, Cmd-Z first asks the IME
   protocol to cancel composition (platform law). That is not a track op.
2. **Focused document lane** — a `text_input` whose document implements
   `History<DocumentHistory>` (every editor buffer does). Typing undo stays
   in the field.
3. **Focused surface track** — an `Entity` that implements `History` (a
   canvas, a board, a sheet).
4. **Nearest ancestor exposure** — `.history::<Scope>()` on a window or pane.
5. **Union of exposed tracks in focus order** — the Edit menu's last resort,
   labelled with the winning node's `label()`.

A composer that *sends* is step-3: the handler runs on the owner and
`commit("Send")` tags both the document clear and the thread insert as one
Point. Cmd-Z after Send undoes Send, not the last keystroke — because Send
was a barrier. That is hole 10, closed, with one method.

Inspector, find bar, and hover-card internals expose `InspectorHistory` so
their own little edits (filter text in the inspector) are undoable *while
focused there* and invisible to the document track.

---

## 5 · Linear, selective, branching, rebase

Four operations, one DAG. Authors learn them in this order.

### 5.1 Linear undo / redo

`Track::undo` applies `current.delta.invert()` with `Origin::Undo`, moves the
cursor to the parent, and retains the forward delta on the redo path of *this
track*. `redo` applies the retained forward with `Origin::Redo`. This is the
Edit menu. It is O(delta apply), not O(document).

Coalesced typing is one node: Cmd-Z removes the burst, not one character —
unless the field's policy is per-grapheme (it isn't, by default; IME and
word-coalesce follow the platform). `barrier()` after a navigation or a
selection change matches ProseMirror / Lexical: the next insert is a new node.

### 5.2 Branching (the DAG doing its job)

After three undos, a new local edit does **not** destroy the redo path in the
DAG. It forks. The track's redo path is cleared (standard UX: a new action
kills Redo in the Edit menu) but the abandoned chain remains a branch
addressable by `NodeId`. A history panel can still `set_current` onto it.
Cheap copy of a document is a new persistent root whose DAG shares the
immutable prefix — CoreObject's O(1) copy, encoded as copy-on-write revisions.

This is why we do not store two stacks of closures. Stacks forget. DAGs don't.

### 5.3 Selective undo (`undo_node`)

CoreObject `undoNode:`: undo one past action and **keep later ones that still
make sense**. Algorithm:

1. Walk `id → current`. Transform each later delta against `id.delta.invert()`
   (`ours = false` on the later ones).
2. If a transform reports `Conflict` (the later edit *depends* on the undone
   one — deleting a row that a later rename addresses by a now-dead slot),
   stop. Return `Conflict { node, reason }`. The inspector names both nodes.
   We do **not** silently drop later work.
3. Apply the inverted-and-transformed chain as **one new revision** tagged
   `Point { "Undo {original label}" }` with `Origin::Undo`. The DAG grows;
   history is not rewritten. Redo of a selective undo is `redo_node` on that
   new node (which inverts the inverse-chain).

Slot identity is the reason this is tractable for structure: a rename of card
A and a move of card B commute, because both address `Slot<Card>`. Position-
based undo (indexes) is what made selective undo infamous; we do not use
indexes as identity. Text does need `transform` (operational transform on
ranges). Canvas strokes commute unless they share a path id.

The "You Don't Know Undo/Redo" bubbling algorithm is the fallback for
algebras that cannot transform: try to float the undone delta to the head by
adjacent transposes; on conflict, refuse. We implement that as
`Delta::transform` returning identity-or-conflict, not as a second system.

### 5.4 Rebase (collaboration and restore)

A remote `Origin::Remote` revision lands on the DAG. Local tracks that did
not originate it leave it `Silent`. If the local user has tagged nodes that
were concurrent, those nodes' deltas `transform` against the remote before
they next apply (standard OT / CRDT-adjacent). Conflict marks the local node
`Conflicted` in the track; Cmd-Z skips it and the inspector offers "undo
anyway (may lose remote)" — never auto-clobber.

Crash recovery (`Origin::Restore`) replays the DAG from the last checksummed
revision (CoreObject integrity checking). Incomplete IME / in-flight drag
were `Silent` and unpersisted; they do not come back as ghost Points. That
is the Sudden Termination story: **what was tagged and committed is on disk;
what was a block in NSUndoManager is gone, and we never stored blocks.**

---

## 6 · Coalescing, gestures, IME, meta

### 6.1 Who coalesces

The coalescer is the track, not the delta. `Delta::compose` is the algebra;
the track decides *whether to ask*. Policy:

| Gesture | Tag | Compose key | Barrier when |
|---|---|---|---|
| Click / command | Point | — | always (one click, one node) |
| Typing in a journaled field | Coalesce | `(doc, field)` | selection change, focus loss, pause > platform threshold, explicit `barrier()` |
| IME composition | Silent (the marks) then one Coalesce on commit | the field | composition end / cancel |
| Slider / scrubber | Coalesce | the port | pointer-up, or `barrier()` if the app wants ticks |
| Drag of a row | Silent (preview) + Point on drop | — | drop / cancel |
| Canvas stroke | Coalesce samples | the path id | pointer-up |
| Programmatic burst | whatever `commit` says | the commit key | end of `commit` |

Yjs `captureTimeout` is a default pause threshold on typing, not a global
timer on the app. `Track::barrier` is `stopCapturing`. There is no
`beginCoalescing` / `endCoalescing` pair that can be leaked across frames;
the gesture token *is* the bracket, and it dies with the gesture.

### 6.2 Meta is not the model

Yjs and Lexical restore cursor and scroll on undo. Those are **not deltas**.
They are `Meta` on the track node: a small, serialisable bag the protocol
fills at tag time and reapplies at pop time.

```rust,ignore
pub struct Meta {
    pub selection: Option<StoredSelection>,  // document protocol, StaticRange
    pub focus: Option<Address>,              // 07 `.id` address, inert if gone
    pub scroll: Option<ScrollPin>,           // slot + offset, not pixels
    pub extras: TinyMap<MetaKey, Bytes>,     // app-level, budgeted
}
```

On undo/redo, meta restore runs *after* the delta apply, as a presentation
effect in the same turn. A miss (row gone, address unmounted) is 07 §10:
dropped and attributed, never a panic. Scroll pins use slot identity so a
transformed selective undo still lands in view.

Focus restore must not steal IME. If a composition is open in another field,
meta focus is deferred until composition ends.

### 6.3 Echo and IME

An undo is `Origin::Undo`. Two-way controls treat it as an external edit:
they write the restored value into the field and **do not** echo a new
journal entry (the track is already recording the inverse as Redo). IME
preempts: if the focused field is composing, Cmd-Z cancels composition
(first key-down rule in §4) rather than applying a document inverse into
the marked range. That is 03's echo rule, now with an origin enum instead
of a comment.

---

## 7 · Persistence, Sudden Termination, budgets

### 7.1 What hits disk

`History::Store = FileStore` (or a custom `HistoryStore`) serialises:

- the revision DAG as a sequence of checksummed, length-prefixed deltas
  (CoreObject: every commit carries a checksum; we do too);
- each track's cursor and tagged `NodeId`s;
- `Meta` bags;
- **not** ephemeral cells, Silent in-flight gestures, or effect leftovers.

Format is versioned, endian-independent, and stable across process invocations
so SCM merges of saved documents do not thrash (CoreObject's JSON/binary
lesson). Deltas that contain user bytes (text, images) are content-addressed
and interned; two identical inserts share storage.

`MemoryStore` is the default: a small-object arena, byte-budgeted, compacted
on owner teardown. A non-`History` owner allocates none of this.

### 7.2 Compaction

CoreObject listed "history compression" as unfinished. We specify the cheap
version:

- **Prefix freeze.** Revisions older than a persist-policy horizon (time,
  byte budget, or "last save") collapse to a single `Checkpoint` plus the
  live tagged nodes that still need invert. Timeline UI for frozen prefix
  is "Restore save from …", not per-keystroke.
- **Dead-branch trim.** Abandoned redo branches with no track cursor and no
  pinned `NodeId` (timeline selection, collaborative peek) drop under the
  same budget. Pins are retention reasons, identical to virtualizer pins.
- **Coalesce-in-place.** Adjacent `Replace` of the same cell in an already-
  tagged Coalesce node keep the oldest inverse and the newest forward.

A window that cannot present (occlusion, device loss) does not pin unbounded
history; the store's byte budget is independent of frame history (scheduler
already says this). Undo state is *model*, not *frame*.

### 7.3 Sudden Termination

On SIGKILL / `exit(0)` after a committed Point: the FileStore's last
checksummed revision is the recovery point. Un-checksummed tail is discarded
(it was not tagged, or the fsync had not returned). Recovery applies
`Origin::Restore`. The Edit menu's canUndo is correct after relaunch.

This is the entire reason deltas are values. A captured block cannot fsync.

---

## 8 · Collaboration without a second undo system

Yjs `UndoManager` + Lexical `@lexical/yjs` are the existence proof that
**per-origin tracks over a shared DAG** is the collaborative shape. We do
not ship a CRDT in GPUI. We ship the track/origin/transform seam so an
editor crate can plug one in.

Rules:

- Local tagged nodes carry `Origin::Local` (or a peer id that *is* us).
- Remote applies are DAG revisions with `Origin::Remote(peer)`. Local tracks
  do not tag them (Yjs `trackedOrigins`). Cmd-Z never "undoes the other
  user" unless the app explicitly calls `undo_node` on a remote node — and
  that is a *new local commit* that inverts-and-transforms, visible to
  everyone as this user's revert.
- Awareness (remote carets, follow) is overlay + meta, not history.
- Offline: the local FileStore *is* the DAG; on reconnect, remotes transform
  against the offline-tagged nodes. Conflict is §5.4.

Per-user persistent tracks (CoreObject collaboration) are `Track<M>` keyed
by `(owner, peer)`. The union view is the workspace Edit menu when focus
does not pick a more specific track.

---

## 9 · Effects, optimistic UI, and what is never undone

04's rule, sharpened:

> External effects are never falsely undone.

| Happened | In the DAG? | Cmd-Z does |
|---|---|---|
| `List`/`Signal`/text/dock/stroke mutation | yes, if `History` | invert |
| `Announce`, clipboard write, haptic | no | nothing (the announcement already spoke) |
| `Task::run` / HTTP / persist-to-server | no | nothing; completion handlers must be generation-checked (already 07) |
| Optimistic tag on a mutation | yes, with `Tag::Point` plus `Optimistic` flag | invert locally; if the server rejected, the inverse *is* the recovery |
| Window close / entity teardown | the owner's store persists if `FileStore`; otherwise the DAG dies with the owner | cannot undo a dropped `MemoryStore` — honest |

Optimistic UI is not a second state. It is a tagged apply whose `Meta`
records the request id. Server reject applies the inverse with
`Origin::System` and a Silent tag (the user already saw the optimistic
Point; a second Cmd-Z entry would be cruel). Server accept clears the
flag. Solid 2.0's "optimistic falls out of the graph" is this flag, not
a new cell type.

`FromResidual` on `Task` stays an effect. A handler that `?`s out does not
leave a half-tagged commit: `commit(label, f)` runs `f` on a draft of the
epoch and only tags if `f` returns `Ok`. Panic inside `f` rolls the draft
(04's panic-atomic, which requires a checkpoint — sampled in debug, not on
every click).

---

## 10 · Authoring: the spelling is the ladder plus three verbs

Application code names `History`, `commit`, `undo`/`redo`, and occasionally
`undo_node`. Everything else is a default.

### 10.1 Kanban — structural history for free

```rust,ignore
impl History for Board {
    type Scope = MainHistory;
}

impl Board {
    fn add_column(&mut self) { self.columns.push(Column::default()); }
    fn move_card(&mut self, drop: Drop<Slot<Card>, Slot<Column>>) {
        let card = self.columns.get_mut(drop.source).cards.take(drop.payload);
        self.columns.get_mut(drop.target).cards.insert_at(drop.index, drop.payload, card);
        // two List deltas, one click gesture → one Point, label from the handler
        // ("Move card") via #[track_caller] on the commit-default.
    }
}

menu_item("Undo")
    .on_select(history::undo::<MainHistory>)
    .shortcut(Key::Z.primary())
menu_item("Redo")
    .on_select(history::redo::<MainHistory>)
    .shortcut(Key::Z.primary().shift())
```

No inverse functions. No `NSUndoManager`. The drop is invertible because
slots are identity. Selective undo of "Add column" after a move that did
not use that column succeeds; after a move *into* that column, `Conflict`
names the move node.

### 10.2 Composer — the hole-10 spelling

```rust,ignore
impl History for Inbox { type Scope = MainHistory; }

impl Inbox {
    fn send(&mut self) {
        let body = self.draft.take();                  // document lane (text delta)
        self.track().barrier();                        // typing coalesces stop here
        self.threads.insert_at(0, Thread::from(body)); // structural
        self.track().tag("Send");                      // one Point covering both
    }
}
```

`take` on a journaled text cell + `insert_at` on the list, bracketed by
`barrier` + `tag`, is one Cmd-Z. Typing before Send undoes typing. After
Send, Cmd-Z undoes Send (thread disappears, draft restored, caret meta
restored into the composer). That is the product.

### 10.3 Canvas — strokes are a track, not a special case

```rust,ignore
impl History for Sketch {
    type Scope = CanvasHistory;
    type Store = FileStore;
}

impl Sketch {
    fn stroke_end(&mut self, s: Stroke) {
        self.paths.push(s);   // List<Stroke>; Coalesce samples already Silent;
                              // pointer-up tags Point("Stroke")
    }
}

canvas(&self.sketch)
    .on_stroke(Sketch::sample)     // live port, ephemeral; not journaled
    .on_commit(Sketch::stroke_end) // discrete; captured
    .history::<CanvasHistory>()    // Cmd-Z while the canvas is focused
```

100k strokes are a `List<Stroke>` plus a spatial index (07 §16). Undo of
the last stroke is `take(slot)` — O(1) apply, one damage region, no
element-grade per-datum services. Selective undo of an old stroke is a
slot take that commutes with later strokes on other slots. That is how
a drawing app scales history: **identity in the collection, not a command
object per sample.**

### 10.4 Text document — the document *is* a track

A rope already has revisions. `TextDocument: History<DocumentHistory>`
exposes that as a `Track`. The field's `text_input` does not own a second
stack. IME Silent-then-Coalesce is the document protocol talking to the
track, not the input widget inventing history. N viewports share the
document track (06's law); each viewport's caret is Meta, not a delta.

### 10.5 Libraries

A crate never names `Signal` (07 §5). It also never names `Track` unless
it *is* a document/canvas. A Typeahead's query edits are the host's
journaled cell (controlled) or the Typeahead's own tiny `History` if
uncontrolled — and that track is focused only while the popup is the
focus target, which for combobox it is *not* (active-descendant).
Uncontrolled typeahead query undo therefore rides the host track as
ordinary journaled writes, which is what users want: Cmd-Z in a page
search undoes the query, then undoes the page's last document edit,
in one Edit menu, because both tagged onto `MainHistory`.

---

## 11 · Inspector, tests, time-travel

The same snapshot protocol as 03/08-research: after publication, a
`UiSnapshot` can include the owner's `Track` (redacted deltas on
sensitive documents). The inspector:

- lists tagged nodes with labels, origins, invertibility;
- scrubs `set_current` on a debug track (does not mutate the user's
  Edit-menu cursor unless pinned);
- diffs two revisions as applied deltas (not as a DOM diff);
- shows why a selective undo `Conflict`ed (both nodes, the slot, the
  transform that failed);
- records coalesce keys and barriers so "why was this one Cmd-Z?" is
  answerable.

Tests:

```rust,ignore
ui.click(button("Add column"));
assert_eq!(board.track().label(), Some("Add column"));
ui.key(Key::Z.primary());
assert_eq!(board.columns.len(), 0);
assert!(board.track().can_redo());
assert_deltas!(last_event(), [ListDelta::Push { .. }]);  // no window required
```

The undo oracle (04, debug-sampled): checkpoint → apply → invert →
compare → redo → compare. Property tests randomise gesture sequences,
selective nodes, and concurrent remote transforms. Irreversible deltas
must refuse `Tag::Point` at tag time (located error).

---

## 12 · Performance

History is a model cost, not a frame cost. Gates still apply.

| Path | Budget | Honest fallback |
|---|---|---|
| Non-`History` owner | **zero** allocations, zero bytes, zero per-write work | — |
| Journaled `List` op | one small-object arena alloc per *tagged node*, not per op (coalesce folds) | — |
| Journaled signal write (`*cell = v`) | coalesce in place: oldest inverse + newest value, no per-keystroke alloc after the first | — |
| Linear undo/redo | apply one delta; damage as if the user had done the inverse | — |
| Selective undo | O(later tagged nodes × transform). Slot-keyed structure is O(1) transform (identity). Text is O(range). | `Conflict` rather than O(document) snapshot |
| Timeline scrub | apply checkpoint + forward deltas, or invert along the path, whichever is fewer; counted | Coarse checkpoint if prefix was frozen |
| FileStore fsync | after tagged Point, coalesced (not per keystroke). Typing fsyncs on barrier / pause / persist policy | MemoryStore if the owner didn't ask |
| 100k-stroke canvas | one `ListDelta::Push` per stroke, not per sample; samples live in the stroke value | — |
| Collaboration transform | only concurrent tagged nodes, not the whole DAG | — |

Counters (compiled in for tests/profile):

- deltas captured / tagged / coalesced / dropped-silent;
- invertibility mix (Exact / Snapshot / Coarse / Irreversible);
- undo / redo / undo_node / conflict;
- arena bytes, frozen-prefix bytes, pinned-branch bytes;
- fsync count and deferred-fsync age;
- transform count and conflict reasons;
- "history tax on a non-History owner" must stay **zero** (gate H0).

A journaled write must not run `view`, must not allocate GPU, and must not
wake unrelated tracks. The apply path of an undo is the same publish path
as a user edit — pockets, wires, and damage work as usual. That is why
undo is an ordinary transaction: **the fast path is the only path.**

---

## 13 · Edge cases (absorbed, not postponed)

From 03, 04, Yjs, CoreObject, ProseMirror, Lexical, and the adversarial
pass — each with a defined behaviour:

- **IME mid-undo.** §4 rule 1: cancel/commit composition first.
- **Undo during drag.** The drag session is Silent; Cmd-Z is ignored or
  cancels the drag (gesture DAG: undo is not a recognizer). Drop then
  tags. We do not invert a half-drop.
- **Undo of a row that currently has focus / IME.** Inverse unmounts the
  row; 07 §10 miss path; focus restores from Meta or to the list.
- **Undo of a running Task's trigger.** The mutation inverts; the Task
  is not cancelled unless the author stored it in a field that the
  inverse drops. Document this in the handler: `self.search` dropped →
  cancel. Do not invent "undo cancels all tasks."
- **Plugin entity undone.** `AnyEntity` removed from a `List<AnyEntity>`
  is a ListDelta; the plugin's own MemoryStore dies; its FileStore
  persists if it had one. Recover chrome is not in the journal.
- **Nested History owners.** Inner track wins while focused; outer
  records the inner's *committed Points* only if the inner's Scope
  equals the outer's (default: it doesn't). A board does not double-
  record a card's journaled title unless the card has no Scope of its
  own.
- **`.ephemeral()` cell written from a journaled handler.** The write
  is not captured. Mixing a playhead set with a list push in one
  click: only the push tags. Honest.
- **Irreversible in a `commit` group.** The whole group becomes
  `Invertibility::Coarse` (checkpoint the commit's before-state) or
  refuses to tag — author's choice on the commit builder,
  `.or_checkpoint()` vs `.require_exact()`. Default is checkpoint,
  counted.
- **Wrap of generation / NodeId.** Same as 03: wrap is terminal /
  epoch-renewal, never a reused valid id.
- **Menu label localisation.** Labels are keys (`"undo.move_card"`),
  not English strings baked into the DAG. CoreObject localisable
  history; we store keys, render through Fluent (Rosin's l10n lesson,
  without requiring CSS).
- **Primary clipboard / system undo (iOS shake, NSTextView).** Platform
  text fields that we do *not* own keep the platform stack. Puncture
  (06): inside a GPUI editor, we own it; a nested native field is one
  atom and Cmd-Z goes to AppKit/Win32. Do not double-stack.
- **Password / secure fields.** Deltas that contain secrets are
  `Redacted` in snapshots and FileStore-encrypted or not persisted.
  Inspector never prints them.
- **Redo after selective undo.** Redo undoes the selective node (the
  new commit), restoring the later chain as it was. It does not
  "re-do the original action" in isolation.
- **Cross-window.** Tracks are per owner, not per window. N viewports
  share the document track. Cmd-Z in either window undoes the
  document. Meta restore targets the window that issued the shortcut
  if that viewport still exists; else the first live viewport.

---

## 14 · What we steal, what we refuse

| Source | Steal | Refuse |
|---|---|---|
| **EtoileUI / CoreObject** | capture vs tag; DAG + tracks; selective `undoNode`; persistent checksummed deltas; O(1) cheap copy; union view; per-activity tracks | SQLite object DB as the UI runtime; pervasive UUID object graph; requiring a metamodel to get undo |
| **NSUndoManager** | grouping-by-runloop as a *default tagger* (our gesture token) | capturing blocks; inverse-by-performing; non-serialisable stacks |
| **Core Data** | undo tied to a managed object context (our `History` owner) | giving up on the split; context-wide coarse snapshots as the only mode |
| **Yjs UndoManager** | `trackedOrigins`; `captureTimeout` as typing pause; `stopCapturing`; stack-item meta (cursor) | CRDT as the GPUI kernel; JS `Set` of origin classes |
| **Lexical HistoryPlugin** | collaborative undo as an external track over the same document; IME-aware grouping | React plugin bag as the API |
| **ProseMirror** | barrier on selection change; `addToHistory: false` = our Silent / `.ephemeral()` | plugin-filter soup |
| **04 `commit().replace`** | must-use builder; `Change` trait for custom ops; oracle; Scope types | requiring a `Track` field on every struct; `Box<dyn Change>` as the common path (sealed deltas first) |
| **03 delta algebra** | one algebra for mutation, rollback, undo, collab, tests; `origin = Undo` echo | `Update` token virality |
| **Immer patches / Redux-undo** | forward+inverse patch pair as the stored node | wrapping the whole app state in a past/present/future lens |
| **git** | DAG, revert-not-reset for selective, branch after undo | forcing users to think in commits; rebasing as the Edit-menu UX |
| **React `useOptimistic` / Solid 2** | optimistic as a flag on a tagged apply | a second copy of the model |

---

## 15 · Gates

- **H0 — Zero tax.** A binary whose owners do not implement `History` has
  no track-arena symbols in the hot path; counters stay zero under a
  10k-click script. (The `History` trait's methods are not in the vtable
  of `View`.)
- **H1 — Round-trip oracle.** For every sealed delta: apply, invert,
  compare to checkpoint; redo, compare to after. Randomised groups.
  `Invertibility::Exact` failures are CI blockers.
- **H2 — Serialisation.** FileStore recover-after-kill restores tagged
  nodes, cursors, and meta; Silent in-flight gestures do not resurrect.
  Checksums catch torn writes.
- **H3 — Composer.** The §10.2 script: type, Cmd-Z (undo type), type,
  Send, Cmd-Z (undo Send, draft restored), Cmd-Shift-Z (redo Send).
  One Edit menu, two lanes, no second stack.
- **H4 — Selective.** Rename A, move B, `undo_node(rename)` keeps the
  move; `undo_node(add-column)` after a move *into* that column
  `Conflict`s with both nodes named.
- **H5 — IME / echo.** Composition open ⇒ Cmd-Z cancels composition
  and does not apply a document inverse into the mark. Undo of a
  committed edit does not start a new journal node from two-way
  writeback.
- **H6 — Canvas scale.** 100k strokes, undo last: one `ListDelta`, one
  damage region, no per-datum element work. Memory of the track is
  O(tagged strokes), not O(samples).
- **H7 — Collaboration origin.** Remote edits do not appear on the
  local track; `undo` after a remote insert still undoes the local
  user's last Point; transform conflicts surface as `Conflict`, not as
  silent clobber.
- **H8 — Routing.** Inspector window focused ⇒ inspector track;
  document focused ⇒ document track; chrome focused ⇒ union /
  MainHistory. trybuild: `history::undo` without an exposed track is
  a located error.
- **H9 — Secrets.** Redacted fields never appear in `UiSnapshot` or
  unencrypted FileStore. A test plants a password and greps the
  snapshot bytes.
- **H10 — Panic atomicity.** Debug-sampled checkpoint around `commit`;
  panic inside the closure publishes nothing and leaves the DAG
  unchanged. Release: the same, via the epoch draft (03), not via a
  second MVCC world.

Carried: 07 L5 (churn), 06 PG3 (fault injection mid-gesture — drag +
Cmd-Z), 05 G4 (freshness of restored values).
