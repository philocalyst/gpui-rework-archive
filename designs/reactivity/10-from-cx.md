# 10 — From `cx`: expressiveness, hard ports, references, types

Status: **working memo**, not a competing surface. Spellings follow
[07-the-ladder.md](07-the-ladder.md). The concept map for a mechanical rewrite is
[migration.md](migration.md) Part I. This file answers three questions that map does not:

1. Where was `cx` actually *more expressive* than the ladder, not just more verbose?
2. What in a Zed-shaped app is hardest to port, and why?
3. How do references exist at all once nothing takes a context?

It also restates the typing and data-structure decisions as they stand after the 07 / 05 /
`runtime/datastructures.md` / `runtime/memory.md` pass — those files moved while this packet
was being written.

**Scope.** This repo is GPUI, not the Zed application. The app-scale claims below are from
GPUI's own `Context` / `EntityMap` / `AsyncApp` (this tree) plus a read of upstream
`zed-industries/zed` `crates/workspace/src/workspace.rs` (~18.8k lines),
`crates/editor/src/{editor,element,display_map}.rs`, `crates/multi_buffer`, and
`crates/project`. The Zed app was stripped from gpui-ce; the patterns did not leave with it.

**Validation provenance.** §3 was line-validated against those upstream files and against a
second, *non-Zed* GPUI app — the Hummingbird music player
(`github.com/hummingbird-player/hummingbird`) — to check the design holds for an ordinary app,
not only Zed's special-case subsystems. Cited `file:line` numbers are from those real sources.
Two headline results: the design's viewport/model split and constructor-wiring inventory hold
*verbatim* against real code; and the biggest honest gap — text-engine describe-time compute —
was found the same way (§3.1/§3.8). Hummingbird also confirmed the high-frequency case works:
an audio engine pushing 40–60 position updates/sec drives the UI cleanly under the
dirty-on-write + value-wire model (a wire patches the progress port with no re-describe).

---

## 0 · What `cx` is

`Context<'a, T>` is two things glued together:

1. **A capability bag.** It `Deref`/`DerefMut`s to `App`, so a handler that needed *one*
   service (notify, spawn, open a window, read a global, hit the clipboard, mint a
   `FocusHandle`) took the whole process. `AsyncApp` is the same bag with a `Weak` to the
   `AppCell`, so it can cross `await`. `Window` is a third bag that is *not* a context —
   you still pass `cx` beside it.
2. **An identity token.** `Context<T>` knows *which* `Entity<T>` you are "in": `cx.entity()`,
   `cx.notify()`, `cx.emit()`, `cx.spawn(|this: WeakEntity<T>, cx| …)`, `cx.listener(…)`.
   Construction is `cx.new(|cx| T { … })` so the constructor can subscribe, spawn, and mint
   children *before `T` exists*.

That combination is the expressiveness. Deleting `cx` from signatures is not deleting
services; it is refusing to thread the process through every function in order to name
the current entity. Kernel-internal phase contexts (`LayoutCx`, `GeometryCx`, branded
arena views — [02](02-principles.md) P6, [migration.md](migration.md) Phase 2) still exist
*below* the authoring seam. Application handlers do not see them.

Today's graph, physically: every model and view lives in one `App`-owned `EntityMap`
(`Box<dyn Any>` keyed by `EntityId`). `Entity<T>` is an `Rc`-like handle that grants **no
access** without a live `&App`. Mutation **leases** the value out of the map for the
`update` closure; a reentrant read of the same id panics. Invalidation is
`cx.notify()` → whole window dirty, plus a separately wired `observe`/`subscribe` graph.
Render-time dependency discovery is a **diff of a global read-set** (`accessed_entities`),
not a stored graph ([01-problem.md](01-problem.md)).

---

## 1 · Capability inventory

Every public verb on `Context<T>` / `App`, and what replaces it. "Lost" means the ladder
has no honest equivalent and we should not pretend otherwise.

| Today | Becomes | Verdict |
|---|---|---|
| `cx.notify()` | deleted — a handler running *is* the dirty | easier, and the point |
| `cx.new(\|cx\| T { … })` | `T { … }` / `T::default()`; `Entity<T>` is a stored promotion | easier at the floor; see §2 construction |
| `entity.read(cx)` / `.update(cx, …)` | peek is *field access* (`Entity<T>: Deref` to committed state); poke is `entity.send(Verb.with(args))` | peek got **easier** than `cx`; poke is queued-not-reentrant by design (§2.7) |
| `cx.observe(&e, …)` | often nothing (view ports/starred reads already mean "re-render on change"); for *effects*: `e.on_change(Self::f)` (any-change, coalesced, committed state peeked via `Deref`) or, field-grain, `derived.on_change(Self::f)` on an equality-gated derived wire (delivers the new value); returns **no handle** | restored as a fire-and-forget verb, kernel-managed lifetime (§2.7, §6.4) |
| `cx.subscribe` / `cx.emit` + `EventEmitter` | `self.emit(E)` caught by `.child(&self.x).on(Host::method)` | same power, typed; no `Subscription` field |
| `cx.observe_global::<G>` / `cx.global::<G>()` | a shared `Entity<Model>` field — `self.settings.tab_size` via the deref, `settings.on_change(Self::changed)` (or field-grain `settings.tab_size.map(..).on_change(..)`) to react | TypeId ambient gone; the *convenience* is fully back (§2.7) |
| `cx.spawn` / `spawn_in` / `background_spawn` | `self.spawn(fut)` (Output=(), or chain `.then`) or a self-filling field: `self.x = Task::run(fut)` / `Task::blocking(data, work)` | fan-out closed: the `.then` handler coordinates via deref-peek + `send` (§2.7) |
| `cx.listener` / `cx.processor` | method path (`Button::tap`); routing by receiver type | easier |
| `cx.defer` / `defer_in` | turn protocol: effects after the transaction publishes | same job, not a user verb |
| `cx.on_release` / `observe_release` | `Drop` of a field (`Task`, `Entity`, `Signal`); pocket fence | **narrower** — no callback into a still-alive neighbor |
| `cx.on_focus` / `on_blur` / `on_focus_lost` / `FocusHandle` | `Target<K>` + `.focuses` / `.focus_default()` / `focus(t).or(Self::fallback)` | different; see §3 |
| `cx.observe_window_bounds/activation/appearance` | window chrome as `View` state / `WindowKind` | same, as ordinary fields |
| `cx.on_action` + `actions!` + key-context strings | `.shortcut(Key::S.primary())` on the control; `.on_key(chord.guard(Self::pred), …)` on a scope | predicates closed: typed guards — `fn(&Self) -> bool` or `&Signal<bool>` (07 §9) |
| `cx.open_window` | `self.open(WindowKind, View)` / `gpui::run` | easier |
| `cx.prompt`, clipboard, credentials, URL, haptic, notifications | effect calls (`self.haptic`, `self.announce`) or platform traits | same services, not on every signature |
| `with_element_state` / `ElementId` | a field on the `View` or a `List` row | **lost** — no element-local stash |
| `reserve_entity` / `Reservation` | still needed for cyclic `Entity` graphs — **unnamed on 07** | gap, §6 |
| `App::with_window(entity_id, …)` | "this entity's current window" reverse map | **lost as a primitive** |
| `observe_new_views` (Zed, not GPUI) | no process-wide constructor hook | **lost**; plugins are `AnyEntity` + host registration |

---

## 2 · Where `cx` was more expressive

These are the places a Zed engineer will feel a *loss of reach*, not a loss of
boilerplate. Each one is a capability the bag gave you for free because every function
already held the process.

### 2.1 Peek and poke any entity from anywhere

```text
fn helper(buffer: &Entity<Buffer>, cx: &App) -> Snapshot {
    buffer.read(cx).snapshot(cx)
}
```

Any `&App` is a capability to read **every** live entity. Any `&mut Context<_>` is a
capability to `update` **any other** entity, lease it out of the map, and recurse. The
borrow checker is not in this picture; the lease panic is.

The ladder's replacement is the **aliasing law** (07 §3): a handler holding `&mut self`
cannot also be handed a reference *into* `self`. Cross-object mutation is either (a) a
handler *on that object's type* (receiver routing), (b) an `Emit` the owner catches, or
(c) a shared cell handed over with `.share()`. You cannot write `other.update(cx, …)`
from a random helper. That is the feature, and it is also the tax: code that today
walks `workspace → pane → item → editor → buffer → display_map` inside one `cx.update`
has to become a conversation between objects that already know each other as fields.

### 2.2 Construction-time graph wiring, including before `Self` exists

`Workspace::new` (upstream) is a constructor that, while `cx: &mut Context<Workspace>`
and *before* the struct is returned:

- `cx.subscribe_in(&project, window, …)` on a dozen `project::Event` variants
- `cx.observe_global::<SettingsStore>`
- `cx.new` for docks, status bar, modal/toast layers, pane, panel buttons
- `cx.subscribe_in(&center_pane, …, Self::handle_pane_event)`
- `cx.spawn_in` for serialization, leader updates, current-user
- `cx.observe_window_activation/bounds/appearance`
- `cx.on_focus_lost`
- `cx.emit(Event::WorkspaceCreated(weak_handle))`
- stores `weak_self: WeakEntity<Workspace>` on the struct it is about to return

`Editor::new` does the same at smaller scale: `_subscriptions: Vec<Subscription>` is
literally

```text
cx.observe(&buffer, Self::on_buffer_changed),
cx.subscribe(&buffer, Self::on_buffer_event),
cx.observe(&display_map, Self::on_display_map_changed),
cx.observe(&blink_manager, |_, _, cx| cx.notify()),
cx.observe_global::<SettingsStore>(Self::settings_changed),
cx.observe_window_activation(…),
```

plus a second `Vec` of *project* observes/subscribes that is `extend`ed after the
struct exists.

Two things here do not have a one-line replacement:

- **Subscribe before the value exists.** `cx.entity()` / `cx.weak_entity()` work in the
  constructor closure. The ladder needs no name for `self` here: `buffer.on_change(Self::persist)`
  / `project.on(Self::on_project)` are called in the constructor over plain `Entity` fields and
  **return no handle** (07 §6.4, [examples/reach.rs](examples/reach.rs)). Each link parks at
  construction and arms at mount against the entity that owns the observed handle as a field; the
  route's receiver type (`Self`) names that owner and is checked at the call, so no `weak_self` is
  threaded. What is *not* yet closed is a cycle of `Entity` **handles** (`Workspace` holds `Pane`
  holds `WeakEntity<Workspace>`) — that used `Reservation` + `weak_self`, and 07 does not yet name
  a public `WeakEntity` / `reserve` pair. `on_change` / receiver-routing removed most *reasons* for
  `weak_self` (an observer no longer needs a back-handle to fire); a genuine handle cycle is the
  residue — see §6.
- **Untyped observe.** `cx.observe(&blink_manager, |_, _, cx| cx.notify())` means "I
  don't care *what* changed; rerender me." The ladder has no such primitive on
  purpose: a starred read of a cell records a real edge; a parent of an `Entity`
  does not re-describe when the child publishes. "Notify me of anything" is exactly
  the coarse graph we are deleting. Porting it means naming the cells the observer
  actually needed. (For an *effect* rather than a re-render, `on_change` is the honest
  primitive — entity-grain, or field-grain over a derived wire; §6.4 / §2.7.)
  *Caveat on this exact example:* the blink manager is not an untyped-observe at
  all — it is a **timer** (`editor.rs:2434`), so "the cell it needed" is a clock,
  and the 07 answer is a motion/`Task` value (a repeating cursor-opacity program,
  07 §4), not `on_change` on a state cell. The example is real but mis-filed;
  cursor blink is animation, and animation is not observation.

### 2.3 Async that fans out across many entities

`cx.spawn_in(window, async move |this: WeakEntity<Workspace>, cx| { … })` is
expressive because `cx: &mut AsyncWindowContext` is still the whole bag after
`await`. The continuation can `this.update(cx, …)?`, then `project.update(cx, …)`,
then `window.update(cx, …)`, then `cx.open_window`. Liveness is `WeakEntity::upgrade`
→ `Result` / `.ok()`. GPUI enforces that the spawned closure does **not** hold a
strong `Entity` across suspension ([03-gpui-internals.md](00-research/03-gpui-internals.md)
§ async). That part we keep: `Task` never captures `&mut self`.

What we do **not** keep is "the continuation is a free function over the process."
`Task::run(fut, Self::done)` delivers `Output` to **one** receiver. A Zed git/LSP/
collaboration task that, on completion, patches a `Buffer`, an `Editor`, a
`Project` panel, and the window title is today one async block with four
`update`s. On the ladder it is either:

- one owner that *contains* the others as fields (then `Self::done` can touch them),
- an `Emit` / protocol message each owner catches,
- or several tasks, each aimed at one handler.

The first is the Workspace instinct (it already owns everybody). The second is the
honest split when the objects are independent surfaces. The third is what you write
when you were using `cx` as a bus.

### 2.4 Reverse lookup: entity → current window

`App::with_window(entity_id, |window, cx| …)` finds "the most recently rendered
window that referenced this entity." `observe_in` / `subscribe_in` /
`spawn_in` all *pin* a window at subscription time; `with_window` is the other
direction. Zed uses it so a model that is not a view (a `Project`, a `Buffer`) can
still reach *some* `Window` to spawn UI work.

The ladder's N-viewports law (07 §8 / §17.6) is the replacement *when you meant
it*: N windows hold the same `Entity<Project>` and present it. There is no
framework map from an arbitrary `EntityId` to "a window that happens to have
rendered me." UI work is requested by a `View` that already sits in a window, or
by `self.open(kind, view)`.

### 2.5 Globals, actions, and constructor hooks

- **`Global` by `TypeId`.** `SettingsStore::get_global(cx)`, `ThemeRegistry`,
  `WorkspaceDb`, `TrustedWorktrees`. Init-order is a runtime panic
  (`"no global registered of type …"`). The ladder allows theme/media *providers*
  as the only ambients; everything else is a field or a shared `Entity`. Settings
  become a shared model the workspace holds, not a process singleton the editor
  reaches through `cx`.
- **`register_action` + key-context strings.** Workspace is "the default global
  context" for actions (its own doc comment). `observe_new_views(|workspace, cx| workspace.register_action(Editor::new_file))` is a process-wide
  "when any Workspace is born, stuff these verbs into it." The ladder puts
  shortcuts on controls and `.on_key` on the narrowest owning scope. Chord
  *predicates* (`Editor && vim_mode == insert`) are not yet a named protocol —
  06's keymap story is chords on controls, not a string DSL. This is a real
  product gap, not just a spelling change.
- **Element-local state.** `with_element_state` + `ElementId` lets a stateless
  `Element` stash a `FocusHandle` / scroll / animation across frames without the
  `View` knowing. 07 deletes it: state lives in structs. `EditableTextElement`'s
  `WeakEntity` cache looked up each frame is the pattern that dies hardest —
  the editor widget *is* a `View` (or a field of one) with a `Target<TextInput>`.

### 2.6 What was *not* more expressive — just viral

`cx.notify()`, `cx.listener`, threading `&mut Window, &mut App` through `Render`,
and storing `Vec<Subscription>` are ceremony. They look like power because they
are on every signature. Replacing them is the easy half of the port
([migration.md](migration.md) steps 1–3).

### 2.7 The answers (now landed in 07 §3 / §9)

Each loss of reach above got a value-with-a-law, not an ambient:

| Lost reach | Restored as | Law that makes it safe |
|---|---|---|
| Peek any entity (2.1) | **field access**: `Entity<T>: Deref` to committed state — `self.project.root`, `text_input(&self.buffer.text)` (a port wires straight into another entity's cell) | turn-ambient deref, single-threaded turn = no aliasing; no `DerefMut` (the write fix-it names `send`); in `view` a deref is a *recorded* entity-grain read (demote law, lint nudges a port) |
| Poke any entity (2.1) | `self.project.send(Project::rename.with(name))` — queued routed verb | FIFO after the current handler, same turn, before describe: no reentrancy, no lease panic; reads after `send` see pre-send state (hence not named `update`); dead receiver = attributed no-op |
| Constructor wiring / `_subscriptions` (2.2) | **two named verbs over a plain `Entity<T>` field**, called in the constructor: `buffer.on_change(Self::persist)` (any commit) and typed `buffer.on(Self::on_event)` (`Buffer: Emitter`); the channel is the *verb*, not an inferred payload type (07 §6.4) | no `Watched` wrapper and no underscore fields — **neither verb returns a handle**; constructible before `self` exists (no `weak_self`); the link parks at construction and arms at mount against the entity that owns `buffer` as a field — receiver type (`Self`) names that owner, checked at the call; torn down on that owner's unmount |
| Untyped observe (2.2) | `entity.on_change(Self::f)` — "it changed", coalesced per turn, committed state peeked via `Deref`; when you need finer than whole-entity, gate it with an equality-gated derived wire and `derived.on_change(Self::f)` (the LSP-on-language-change shape; [examples/derived_observe.rs](examples/derived_observe.rs)) | typed, priced, journal-visible; a bare value still wants a port, not an effect |
| Async fan-out (2.3) | the completion handler is the **coordinator**: patch `&mut self`, peek by field access, `send` the rest | one handler, four lines — reach without `AsyncApp` |
| Entity→window (2.4) | `Win` context param on handlers (filled like `Slot` from dispatch); effects already window-scoped | reverse *map* stays deleted (ill-posed under N viewports) |
| `get_global` convenience (2.5) | a settings *handle* is a field; `self.settings.tab_size` (the deref) | *more* convenient than `get_global`, no `TypeId` registry, no init-order panic |
| Key-context predicates (2.5) | `.on_key(Key::Escape.guard(Editor::in_insert_mode), …)` — `fn(&Self) -> bool` / `&Signal<bool>` guards on chords | evaluated at dispatch against committed state on the routed receiver; inspector shows which guard said no |

---

## 3 · Hardest Zed-shaped ports, ranked

Mechanical GPUI examples (`hello_world`, counters, `cx.spawn` demos) are not on
this list. These are.

### 1. The editor triangle — `Editor` × `MultiBuffer` × `DisplayMap` × `Project`

This is the hardest object in the product. An `Editor` is a viewport onto a
document it does not own. *(Validated against real `zed/crates/editor` — line
numbers below are from upstream `editor.rs`/`element.rs`/`display_map.rs`.)*
Construction wires exactly six observes/subscribes (`editor.rs:2431–2436`) plus
project/breakpoint/debug-session subscriptions. The harder fact: the editor's
whole **display computation runs during description**. `EditorElement` calls
`self.editor.update(cx, …)` **40+ times inside `layout`/`prepaint`/`paint`**
(`element.rs:273 … 8451`), and `editor.rs` calls `.snapshot()` 89× and
`display_map.update(…)` 30×. This is not scattered scratch mutation the 05 G5
audit picks off one at a time — it is the architecture.

On the ladder this *must* become the N-viewports law, not a bag of observes.
What the real code confirms, and what it forces the design to own:

- **Validated — the viewport/model split is real at the field level.**
  `buffer: Entity<MultiBuffer>` (`editor.rs:925`, the shared document) sits
  beside `selections: SelectionsCollection` (930) and
  `scroll_manager: ScrollManager` (936) as **plain fields** (viewport state).
  Exactly 07's split: scroll/caret/selections are viewport-local, text is the
  shared model. The document is `Entity<Buffer>`/`MultiBuffer` (09 / 07 §19).
- **Correction — `DisplayMap` today IS a third observed entity, and the design
  must say so.** `display_map: Entity<DisplayMap>` (`editor.rs:928`) is
  `cx.observe_in`'d at `2433`; it is a six-layer coordinate pipeline
  (`inlay → fold → tab → wrap → block → crease`, `display_map.rs:214`) whose
  `wrap_map: Entity<WrapMap>` (226) is *itself* an entity because soft-wrap is
  async. The honest 07 answer is not "not a third entity" but **an
  async-maintained derived projection**: a kernel-owned port behind the
  document with a background wrap stage, not an application `observe`. The
  design should name this "derived projection with an async stage" case
  explicitly rather than pretend it collapses to (a) pure-derived or (b)
  per-viewport.
- **`MultiBuffer` is a viewport onto *many* buffers.** It carries a
  `singleton: bool` fast path (`multi_buffer.rs:84`) and composes excerpts of
  several `Buffer`s. 07's single-`Buffer` story omits the excerpt layer; the
  design must model excerpt composition (a `List`-of-excerpts projection) and
  the singleton fast path, or the common one-file editor and the multi-file
  search/diff view will not share a spelling.
- Inlay hints / git blame / runnables are tasks on the editor or the document,
  completions routed to one handler, not `cx.observe(&task_inventory, |e, _, cx| e.refresh_runnables(cx))`.
- **The minimap is a second `Editor` entity rendered inside the first** during
  prepaint (`element.rs:1481`, `minimap_editor.update`). N-viewports must
  explicitly cover editor-in-editor — a viewport whose model is the same
  document at a different scale.

The conceptual shift stands — **an editor's `view` does not `read(cx)` a sibling
entity**; it passes `&self.doc` into `text_input(&self.doc)` and the surface
wires the cells. But the honest gap the real code exposes is **describe-time
compute**: folds/wraps/inlays → pixel layout genuinely runs during description,
and the pure app-level describe/write split cannot express it. The resolution is
the kernel `LayoutCx`/`GeometryCx` phase (02 P6, migration Phase 2): the editor's
display pipeline lives *below* the application authoring seam, as a
capability-scoped describe-phase, not as `view(&mut self)` restored. 07 §3.8
must say this in those words — "treat every hit as a bug" is right for
application views and wrong for the text engine, which needs the named phase.

### 2. Workspace as process-inside-a-window

`Workspace` is a window-root that is also an ECS: `Vec<Entity<Pane>>`,
`HashMap<EntityId, WeakEntity<Pane>>` (`panes_by_item`), three `Entity<Dock>`s,
`Entity<Project>`, `Entity<StatusBar>`, modal/toast layers, `FocusHandle`s,
`HashMap<EntityId, Subscription>` for dirty-item tracking, a `WeakEntity<Self>`,
and a `_subscriptions: Vec<Subscription>` that *is* the application graph.

Port in this order, or you will rewrite it twice:

1. Make `Workspace` a `View` whose fields are the docks / panes / project.
   `cx.notify` and the subscription vec go away; `view` re-describes; tape diffs.
2. Promote `Pane` / item hosts to `Entity` only where they need an independent
   surface (or a plugin boundary). Contained `Pane` is legal.
3. Replace `Item` / `AnyView` with `AnyEntity` + the pocket protocol (07 §5–6).
   The item registry (`ProjectItemRegistry` as a global, `cx.new(|cx| T::for_project_item(…))`)
   becomes a host table of factories, not a `TypeId` global.
4. Dirty-item subscriptions become the document's own `History` / a `Signal<bool>`
   the workspace wires, not `HashMap<EntityId, Subscription>`.

Docking itself is already specified (06, [examples/docking.rs](examples/docking.rs)):
two algebras, sash leeway, last-active, maximize. That is not the hard part. The
hard part is **items as type-erased, serializable, focusable, split-able
surfaces**.

### 3. Collaboration and other multi-writer models

`Buffer` is updated from the UI thread *and* from collaboration / LSP / git
tasks via `buffer.update(cx, …)`. Several `Editor`s and a project panel observe
it. This is the one place GPUI's lease model is doing real work: exclusive
mutable access to a shared object, from many call sites, without putting the
buffer inside any one view.

The ladder's answer is the same object as an `Entity<Buffer>` whose cells are
the rope / version. Writers are handlers on `Buffer` (`fn apply(&mut self, Edit)`),
aimed by tasks (`Task::run(rpc, Buffer::apply_remote)`), or `.share()`d cells.
Editors do not `update` the buffer; they emit edits or write through a bound
`text_input(&self.doc)`. Echo-safe two-way (origin + version, 07 §1 / 05) is
load-bearing here — collaboration *is* the echo case.

What we refuse: a public `entity.update(cx, …)` that any helper can call. If
collaboration needs a kernel-internal "apply this delta to this entity" entry,
it is a `Buffer` method, not a context method.

### 4. Settings as a global, and the observe_global fanout

Almost every Zed view `observe_global::<SettingsStore>` and re-reads
`EditorSettings::get_global(cx)` inside render. That is both ambient init-order
and a coarse invalidation ("any setting, rebuild me").

Replacement: a shared `Entity<Settings>` or a provider. Views that care
star-read or wire the specific field (`settings.tab_size`). Theme already has
TokenIndex (06) so a palette swap is not a view rerun. A "settings changed"
observe that calls `cx.notify()` is the thing we are not allowed to
reintroduce.

### 5. Keymap context predicates and workspace-global actions

`register_action(Editor::new_file)` on every workspace, plus context strings
(`"Editor"`, `"vim_mode == insert"`, descendant operators — see
`crates/gpui/src/keymap/context.rs`). 07 §9 puts chords on controls. Vim-mode
and "this action is live only while an editor is focused" need a **focus-scoped
command set**, not a string predicate language. Until that protocol exists in
06, this is the most likely place a port cheats by sneaking a bag back in.
Do not.

### 6. Workspace serialization / item persistence

`_items_serializer`, `serializable_items_tx`, `WorkspaceDb::global(cx)`,
throttled `cx.spawn` on bounds change. Persistence is 08 / `gpui_history`
`FileStore` plus whatever Zed already stores as JSON. The hard part is not
fsync; it is **identity of items across process restart** without `EntityId`
(generational, not stable) and without `ElementId` paths. Domain keys
(`List<Thread, ThreadId>`) and explicit item ids are the upgrade 07 already
named. `EntityId` must not be serialized. That is already true today; the
port has to keep it true without `cx.global::<WorkspaceDb>()`.

### 7. Focus restoration

`FocusHandle` is cloneable, stored on the view, compared by id, hooked with
`on_focus_lost` to pick a default. `RegionFocusHandles`, `titlebar_focus_handle`,
`dock_content_handle`. 07's `Target<K>` is Copy, 4 bytes, rebound every
describe, parks when unbound, `focus(t).or(Self::fallback)` for misses. The
port is mechanical **except** where Zed stores a `FocusHandle` to an element
that is not a field (element-local). Those become `Target` fields on the
owning struct.

### 8. `Render` that mutates

05 G5: audit real views for `&mut self` during description. Zed fails that audit
on contact, and so does a 50-file app. Two shapes, and they need **different**
answers — conflating them is the mistake:

1. **Application-view scratch — a bug, refactor it.** Real instances found in
   the Hummingbird music player: `render` clears a `focused` flag
   (`ui/artist_picker.rs:39`), flips `reclaim_focus` then focuses
   (`ui/library.rs:191`), flips `focus_pending` (`ui/equalizer/view.rs:3`). All
   three are the same pattern: a **focus-reclaim flag** mutated during render.
   The 07 answer is not interior scratch but the focus model itself — focus is a
   describe-time value (`focus(t)` / `focus_default()` on a `Target`), and the
   "reclaim after X" flag becomes a **post-commit focus effect**, not a bool
   read during describe. Name this pattern (`focus-reclaim flag`) in 07 §5; it
   is common precisely because `FocusHandle` had no describe-time spelling.
2. **Text-engine describe-time compute — NOT a bug, a named phase.** The editor's
   display pipeline mutates during `layout`/`prepaint` at architectural scale
   (§3.1: 40+ `editor.update` in `element.rs`, `display_map.update`,
   `.snapshot()`). This cannot become interior scratch — it is real layout work
   with a font-metric-dependent async wrap stage. It belongs in the kernel
   `LayoutCx`/`GeometryCx` phase (02 P6), below the application seam, as a
   capability-scoped describe-phase. "Treat every hit as a bug" applies to (1),
   not (2); giving `view` `&mut self` again is never the fix for either.

`cx.new` of child views from `render` and `with_element_state` caches are
sub-cases of (1): the child is a field/`Entity`, the cache is a `Target`/`Signal`
field. `with_element_state` shows up even in small apps as string-keyed
transient state (`window.use_keyed_state("eq-band-editor-focus", …)` in
Hummingbird's `ui/equalizer/band_editor.rs:30`); it becomes a `Target` field on
the owning struct — mechanical, but real work to unwind.

---

## 4 · How we track references without `cx`

`cx` was the resolver: a handle plus a context produced a `&T` / `&mut T`.
Without it, **a name has to mean something on its own**, and the only names
that can are ones the struct already holds or the describe frame just minted.

There are six kinds of name. None of them dereference through an ambient
runtime (02 P6, README: keys own nothing). Application code never writes
`Scope` / `Update` / `Read` — those are kernel-internal.

### 4.1 Fields are the graph

If `Editor` needs `Buffer`, it has a field `doc: Entity<Buffer>` (shared
surface) or `doc: Buffer` (contained). The parent that constructed both
*passed the handle in*. There is no later `cx` lookup of "the buffer for this
editor." Construction is ordinary Rust; the graph is the struct.

Cycles: a parent stores `Entity<Child>`; the child stores what it actually
needs (a `.share()`d cell, a `Target`, a `Slot`, an `Emit` upward). A child
that must call the parent stores nothing — it `self.emit(Picked)` and the
parent's `.on(Parent::picked)` is the back-edge. `weak_self` is the old
spelling of that back-edge. Prefer emit. If a true cycle of `Entity` handles
is required (workspace ↔ pane), that is the §6 `Weak` gap.

### 4.2 Cells and wires (the `observe` replacement)

`Signal<T>` is an owning cell **in the struct** (`!Clone`; `.share()` for a
second writer, `.reader()` for a Copy `SignalRef<T>`). On first bind it is
interned to a dense per-window `u32` slot; subscriber/dirty/revision state
lives in a side `WireTable`, not in the handle
([datastructures.md](runtime/datastructures.md) §1).

A describe-time `*self.count` records that slot in the enclosing producer's
**read-set** (inline-8 sorted `SmallVec<u32>`, merge-diffed, epoch-stamped
dedup — ds-lab `readset`). That *is* `accessed_entities`, narrowed from
entity-id to cell-id, and stored as reverse edges instead of recomputed by
set-difference around a full window render.

An ampersand `&self.count` into a property is a **wire**: source slot, target
port, last version. A publish patches the port and does not rerun Rust. This
replaces `cx.observe` for data. There is no `Subscription` to store; dropping
the producing span unsubscribes (intrusive links, O(1)).

### 4.3 Events (the `subscribe` replacement)

`self.emit(Picked(id))` climbs the mount path. An ancestor
`.child(&self.search).on(Workspace::picked)` is the subscription. The payload
**type** is the key (`TypeId`), not a handle. Nobody catching it is inert
(inspector-attributed), not an error. No `EventEmitter` trait, no
`Vec<Subscription>`.

### 4.4 Collection identity (the `EntityId` / `ElementId` replacement for rows)

`List<T>` mints a typed `Slot<T>` (`NonZeroU64` packed `[index:32 | gen:32]`,
8 B, `Option<Slot>` free, Copy regardless of `T`). Slots are item identity,
not position; they transfer across containers of the same `T` (drag a card,
caret survives). Domain keys (`List<Thread, ThreadId>`) are the optional
upgrade. Arrangements (filter/sort) index slots, never the filtered offset
(Slint `unfiltered_row`).

Handlers in a wired row route to *that row's* slot. `HashMap<EntityId, WeakEntity<Pane>>`
becomes `List<Pane>` plus `Slot<Pane>`, or a `ComponentMap`.

### 4.5 Element identity (the `FocusHandle` / `ElementId` replacement)

`Target<K>` is a Copy 4-byte name, a field next to the state it addresses,
bound once per describe (`.target(self.input)`), type-checked by `K`.
Unbound ⇒ claims park (`Miss`), never `Option` at the wiring site. Tests hold
the state and use the same names (`ui.click(ui.find)`). External drivers use
role+name locators. Cross-frame retention is `.handle()` → `TargetHandle`.
Embedding-site identity (`#[track_caller]`) covers static children; there is
no `.key()` on elements.

### 4.6 Work identity (the `WeakEntity` in `spawn` replacement)

A `Task` is a value. Store it in a field ⇒ drop/replace cancels. Don't ⇒
`self.spawn` logs it on the running handler's owner. The completion is an
ordinary handler; its receiver TypeId is the address. The future is `'static`
and owned — it cannot capture `&mut self`. That is the WeakEntity rule, as a
type error instead of a convention. Fan-out after completion is §2.3.

### 4.7 What a `view` is allowed to name

```text
&self.field            — a field of this owner (any of the four nouns)
*self.signal           — demoted, recorded read (rung 0)
&self.signal           — live wire
self.list[slot]        — Option, generational
self.child.emit / .on  — events along the mount path
Target / Slot / Entity — Copy or handle values this struct holds
```

It is not allowed to name "whatever `cx` can see." If a helper needs data, the
caller passes a reference or a `SignalRef`. If a row needs the owner, the
handler is `fn(&mut Owner, Slot<Item>)` and the slot is ambient **event
context**, not a lookup through `cx`.

---

## 5 · Fundamental typing decisions (as of 07)

07 wins where 02 / 03 / 05 / README still say `State<T>` keys, `Scope` /
`Update` / `Read`, `scoped`, `Ui<'a>`, or `view(&mut self)`. Those names are
kernel-internal or historical.

**Four public nouns, one spelling.** `T` / `Signal<T>` / `List<T>` (or `Vec<T>`
at the floor) / `Entity<T>`. You pass `&self.field` at every rung. Promotion
is a struct edit; gate L1 compiles the same `view` against both layouts.

**The star is now; the ampersand is live.** `Signal<T>: Deref<Target = T> +
DerefMut`. Writes are `*self.count += 1` and cannot compile in `view(&self)`.
A starred read in `view` is recorded (never the deleted `snapshot()`).
Inherent methods on `Signal` are a frozen semver set (`share`, `reader`,
`project`, `then`/`when`/`switch`, descriptors, `ephemeral`) so they do not
shadow `T`.

**Handlers return `()`.** Effects are calls into a per-dispatch sink:
`self.spawn`, `self.emit`, `self.announce`, `self.haptic`, `self.open`. The
one remaining ambient exists only for the duration of a dispatch and is
inspectable. No `-> Task`, no `Effects`, no `cx`.

**Routing is the first parameter's type.** `fn(&mut Owner, …)` vs
`fn(&mut RowItem, …)` vs `fn(&mut Selection, KeyEvent)` — lowering matches
the receiver to the owner, a wired cell, or the row slot. Ambiguity is a
located error. `.with(args)` binds trailing arguments only.

**Sealed conversion traits, erased at the call.** `IntoWire<T>`,
`IntoEditable<T>` (TwoWay vs Controlled), `IntoChildren`, `IntoLiveWire`.
No blanket `Source` impl beside `&T` (coherence). Public library helpers take
`impl IntoWire<T>`, never name `Signal` in a field. App helpers take ordinary
types.

**`Signal<T>` is `!Clone` and value-inline.** Pick-two: capability-free
`Signal::new`, `Copy`, cell lifetime tied to the field. We pick first +
third. `Entity<T>` is the remaining *handle* noun — Clone in the N-viewports
sense, independent dirty root, erasure (`AnyEntity`), age line, earned
compositor layer.

**Identity is not an annotation.** No `.key()`, no `#[derive(Id)]`, no
`ElementId`. Containers own slots; sites own `#[track_caller]`; wiring
identity is `Target<K>`.

**Macros are closed.** `tw!`, `asset!`, `#[gpu_shader]`, `#[derive(Canvas)]`.
No `rsx!`, no `#[widget]` that rewrites signatures.

### The typestate ledger

Typestates are rationed: each public one must delete a *runtime error class*, because
every typestate is also a type a user must read. The current ledger:

| Typestate | Deletes | Where |
|---|---|---|
| `Control<NeedsWriter>` (`#[must_use]`) | inert controlled inputs that compile and do nothing | 07 §5 |
| `Take<T>` (restore-on-drop) | lost items on bailed drops; the take-then-fail window | 07 §3 |
| `Editing<CellRef>` | grid edit sessions with no owner; orphaned IMEs | 06 / 07 §4 |
| `TargetHandle` (`Option` after unmount) | dangling cross-frame element references | 07 §5 |
| `Task` (parked → running → done; drop = cancel) | fire-and-forget leaks; cancellation-by-comment | 07 §3 |

Kernel-internal (never public): branded arena views (capabilities that cannot escape a
phase), the two-epoch publish tokens (a stage cannot write after its barrier), the
describe-phase frame, `Wire` install states. Considered and refused: typestate builders
for style (`NeedsWidth` — ceremony on every box), window specs (kind is a constructor
*argument*, the stronger fix), focus scopes (a scope without `initial_focus` defaults to
first-focusable, so the error class is empty), and a `Mounted` lifecycle state (deleted
outright — constructor-created `Task` fields park and auto-start at mount). The bar for
adding one stays: name the runtime bug it makes impossible.

---

## 6 · Fundamental data structures (as of the ds-lab)

Adopted representations, measured on M3 Pro / rustc 1.97.1. Re-run
`designs/reactivity/runtime/ds-lab` before treating ns as portable. Full
writeup: [runtime/datastructures.md](runtime/datastructures.md),
[runtime/memory.md](runtime/memory.md).

| Structure | Representation | Why |
|---|---|---|
| `Signal<T>` | `{ value: T, slot: Cell<u32> }` + side `WireTable` | 4 B overhead; unwired signals allocate nothing; `Deref` is a load |
| `Slot<T>` | `NonZeroU64` `[index\|gen]`, hand-written Copy (no `T: Copy`) | 8 B, free `Option`, ABA-safe |
| `List<T>` | contiguous `Vec<T>` + side slot directory (`pos_to_slot`, `SlotEntry`) | `Deref<[T]>` is honest; `get(slot)` O(1); splice identity-tax ~2–3× |
| Display store | flattened DFS (paint-order) SoA, 8 B hot record | ~44× vs pointer-chase AoS on full traversal; subtree = contiguous range |
| Tape span | 32 B, 128-bit hash, `==` confirm, intern by identity hasher | lowering dedup; SipHash intern tables are forbidden |
| Subscribers | intrusive slab default; CSR cache for high-fanout stable cells | O(1) unsub vs 7× faster publish on theme-scale fanout |
| Read-sets | inline-8 sorted `SmallVec<u32>` + merge-diff; epoch stamp dedup | ~11 ns, zero-alloc; bitsets lose (scan all slots) |
| Patch queue | dense-scatter dedup, no full sort | ~3.3 ns/patch |
| Hit / damage | tile-bucket index; 64 px damage bitset; Fenwick extents | |
| Handler dispatch | FxHash/identity `TypeId` map; 3-word inline closures | capture-free fn items are 0 B |
| Text | SSO 24 B `SharedString`; text holes write into a retained buffer | `format!` at the floor is bump-absorbed, not a heap cell |

**Memory law.** Steady-state (hover, scroll, typing into an existing field) allocates
**zero**. Novelty is page-granular from free lists. Caches have miss paths.
Intrusive lists everywhere on hot paths. History spills to disk. There is no
public memory annotation; `gpui::run(view).memory_budget(..)` is an app policy.

**What this deletes from today's EntityMap.** `Box<dyn Any>` per entity, atomic
refcounts on every handle, lease-out mutation, `accessed_entities` as a
whole-window `FxHashSet`, `SubscriberSet` of boxed closures keyed by
`EntityId` + `TypeId`. An `Entity<T>` that *is* a surface still needs a
generational identity and a pocket fence; it does not need to be the store
for every `Counter`.

---

## 7 · Open gaps (do not silently invent `cx` to close them)

These are places 07 is honest-but-incomplete relative to Zed's actual graph.
Closing them belongs in 07 / 06, not in a helper that takes `&mut App`.

1. **Cyclic `Entity` construction.** Today's `reserve_entity` + `weak_self`.
   Prefer emit-upward — and note `send`/receiver-routing removed most *reasons*
   for `weak_self` (a completion needs no handle to reach its owner). If a true
   cycle remains, the public name should be a `Weak<Entity<T>>`-shaped field
   with the same fallibility as `TargetHandle` (`Option` after drop), not a
   context method that mints ids. *Reality-check:* upstream `Workspace` stores
   `weak_self` and uses it **8×** (`workspace.rs:1374,1689,1846,2206,2610,6314,
   9131,14383`), plus `WeakEntity` fields for `maximized_pane`,
   `last_active_center_pane`, `panes_by_item` values, and a `Pane→Workspace`
   back-edge (`pane.rs:414`); no `Reservation` appears. So emit-upward covers the
   *callback* direction but not **forward queries** (a pane asking its workspace a
   question). This gap is bigger than "prefer emit" implies: 07 needs a real
   public `WeakEntity<T>` **field type** with defined drop semantics, not just an
   exhortation.
2. ~~Multi-entity task completion~~ — **closed** (§2.7): the completion handler
   coordinates via `read`/`send`; owning everybody as fields is no longer the
   only shape.
3. **Entity → window reverse map.** Deleted, deliberately; the `Win` context
   param (§2.7) covers "which window did this happen in."
4. **Process-wide `observe_new` / the item registry.** Plugin registration is a
   host table, not a constructor broadcast — `AnyEntity` + factories. *This is
   load-bearing and still un-designed:* upstream `ProjectItemRegistry`
   (`workspace.rs:841–960`) is a live `TypeId`-keyed factory **global**, the
   exact pattern 07 deletes, and every pane item is built through it. Until 07
   §5–6 names the `AnyEntity` + pocket-factory protocol concretely, a Workspace
   port has nowhere to put item construction and will reintroduce a global. Rank
   this as the #1 workspace blocker, above the mechanical subs.
5. ~~Key-context predicates~~ — **closed** (07 §9): typed `.guard(fn(&Self) ->
   bool)` guards on chords; Vim is guarded chords on the editor scope.
6. **`observe_release` into a neighbor.** `Drop` is not a callback into
   someone else. If pane-removal must tell workspace, that is `Emit(PaneGone)`
   from `Drop` via the sink — only legal if drop runs inside a turn. Otherwise
   the parent owns the child and already sees the splice.
7. **G5: `&mut` during describe.** Not one gap but two (§3.8): application-view
   focus-reclaim flags are bugs → the focus model; text-engine describe-time
   compute is a named kernel `LayoutCx` phase, not a bug. First-contact audit for
   the first; a design commitment for the second.
8. **Workspace-level collaboration presence sync.** Distinct from Buffer
   collaboration (§3.3, which is echo-safe cell writes). `Workspace` runs a
   *presence* protocol: `follower_states: HashMap<CollaboratorId, FollowerState>`
   plus a `leader_updates_tx` channel and an async `_apply_leader_updates` task
   (`workspace.rs:1398,1405–1410,6184–6250`) — when a peer scrolls or closes an
   item, this pane mirrors it. This is a small distributed system inside a view,
   and 07 has **no answer**: it is neither a value wire nor an `on_change`; it is
   an ordered remote command stream feeding `send`s. Likely shape: a `Task` that
   owns the channel and `send`s routed verbs, but the *identity mapping*
   (peer's item ↔ my item) needs domain keys (gap 9).
9. **Serialization identity without `EntityId`.** `EntityId` is generational and
   must never be serialized (already true today). Upstream keys persisted items
   by `(ProjectPath, item-key)` via `serializable_items_tx` /
   `WorkspaceDb`. 07 says "domain keys + explicit item ids are the upgrade" — but
   **what is the domain key for an `Editor`? a `Terminal`?** Restore must
   re-acquire the same item, scroll, and selection. Underspecified, and
   user-visible (mis-identify on restart = lost session). Needs a concrete
   `List<Item, DomainKey>` story per item type before the workspace port.

---

## 8 · The porting rule, in one paragraph

`cx` was a capability to *resolve* a handle against the process. The ladder
makes resolution unnecessary by making the graph local: fields, slots,
targets, wires, mount-path events, and tasks aimed at one receiver. Where Zed
used that capability as a **bus** (any entity, any window, any global, after
any `await`), the port is a redesign of who owns the conversation — not a
search-and-replace of `cx.notify()` for something else. Where Zed used it as
**ceremony** (listener, notify, subscription vec, `Render` signatures),
migration.md steps 1–3 are the whole job. The editor triangle, the workspace
item protocol, collaboration on `Buffer`, and settings/keymap ambients are
the first kind. Everything else is the second.

---

## 9 · Nightly, for users who opt in

The kernel is stable-Rust-only by release rule — nothing below is ever *required*. But an
application on nightly can smooth real edges of the surface:

- **`deref_patterns`** — match through `Deref` in patterns: `if let Some(s) = self.active`
  and `match self.mode { Mode::Edit => … }` without the star. Deletes star-insertion from
  the *read* side of storage promotion; when it stabilizes, the fix-it simply stops being
  needed in match positions.
- **`default_field_values`** — `struct Counter { count: Signal<usize> = Signal::new(0) }`:
  Views with non-`Default` cells lose their `fn new()` boilerplate; `..` construction
  works everywhere (and test setup via construction literals gets even shorter).
- **`gen` blocks** — hand-write `Stream`s for `Task::stream` with no helper crate.
- **`try_blocks`** — cluster fallible setup inside a handler before one `let-else`.
- Already stable and worth knowing: let-chains (2024) for guard stacks; precise capturing
  `use<..>` (which application code still never needs to write).

Note the asymmetry: nightly helps *reads* and *construction*; nothing on any channel makes
`x = v` overloadable, which is why the assignment star is handled by the machine fix-it
(07 §16.5), not syntax.
