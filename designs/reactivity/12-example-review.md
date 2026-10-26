# 12 — Example Review: Ceremony the Sketches Reveal

Status: audit of every sketch in [examples/](examples/) against 07's own promises, continuing
[11-consolidations.md](11-consolidations.md). The examples are where the design meets fingers;
several of them quietly reintroduce the diseases 07 was written to kill. Each finding names the
ceremony, the examples that exhibit it, and the simpler surface — with before/after where the
delta is large. [async_workbench.rs](examples/async_workbench.rs) is the pressure test, so it is
also the ceremony test: it currently fails.

---

## 1 · `RuntimeSet` threading is `cx` threading reborn

The single worst pattern in the corpus. 07 §7.0 is explicit: *"The default application installs
GPUI's existing runtime handles… `map_async` selects the default I/O lane; `map_async_on(runtime, f)`
…make **exceptional** affinity visible."* The workbench then threads runtime handles through
every constructor as if they were `cx`:

```rust,ignore
// async_workbench.rs today — count the runtime mentions
Workbench::restore(catalog, runtime, project, records, transport)
  → ItemPlacement::restore(slot, record, &catalog, &runtime, host)
    → catalog.try_restore_async_on(&runtime.io, slot, record.clone(), host)
  → DisplayPipeline::mount(logical, spec, request.runtime.cpu.share())
  → document.reader(..).try_map_async_on(&request.runtime.io, fetch_diagnostics)
  → PresenceSession::attach(presence.remote(), transport, runtime.io.share())
```

Every one of these is the *default* lane spelled in the *exceptional* form. Zed threaded `cx`
because reaching the one true App required it; this threads `RuntimeSet` because the example
forgot its own design. The fix is mechanical and cuts a parameter from five signatures:

```rust,ignore
// after — the application installed the runtimes once (§7.0); only an override names one
let surface     = catalog.restore(slot, record, host);          // default I/O lane
let main        = DisplayPipeline::mount(logical, spec);         // default CPU lane
let diagnostics = document.reader(MultiBuffer::analysis_input)
    .try_map_async(fetch_diagnostics);
// the ONE genuinely special case keeps its visible affinity:
let wrap = logical.map_on(&render_pool, Wraps::compute);
```

`Workbench` loses its `runtime: RuntimeSet` field; `ItemPlacement::restore` drops to three
parameters; `OwnedRestore` stops carrying `runtime`. Rule for every future example: **a runtime
handle appearing anywhere but `main()` (or one attributed override) is a bug in the sketch.**

Related naming: the producer-verb family is combinatorially exploding —
`map` / `map_async` / `try_map_async` / `map_async_on` / `compute` / `try_compute` /
`compute_on` / `try_restore_async_on`. Collapse the `_on` axis into one modifier on the producer
descriptor (`.on(&pool)`, shown above as `map_on` or `map_async(f).on(&pool)`) and the family
halves: `map`, `map_async`, `try_map_async`, `compute`, `try_compute`, `+ .on(_)`.
`try_restore_async_on` becomes `restore` (it is *obviously* async and fallible — the reader type
says so).

## 2 · The epoch dance: three examples hand-roll what the graph already does

[typeahead.rs](examples/typeahead.rs), [reach.rs](examples/reach.rs), and
[derived_observe.rs](examples/derived_observe.rs) all contain this shape:

```rust,ignore
epoch: u32,                                   // field
self.epoch += 1;                              // bump
let (remote, epoch) = (self.remote(), self.epoch);
tokio::spawn(async move {
    let result = backend::search(q).await;
    remote.send(Typeahead::results.with(epoch).with(result));
});
fn results(&mut self, epoch: u32, r: …) {
    if epoch != self.epoch { return; }        // manual stale rejection
    …
}
```

That is six pieces of bookkeeping — a field, a bump, a capture tuple, a spawn, a threading of the
epoch through the route, and a guard — to express "latest wins." But latest-wins stale rejection
is the *headline feature of §7.5's request stamps*. The flagship simple component hand-rolls the
machinery while the design's centerpiece sits unused one section over. This is the clearest
"drastically simpler" opportunity in the corpus, and it needs two small additions:

**2a. Handler-spawned effects get stamps too.** Give the owner one spawn verb whose site is a
mount/owner-scoped cell with §7.5 admission — same tickets, same revocation on unmount:

```rust,ignore
fn changed(&mut self, q: String) {
    *self.open = true;
    self.search(Typeahead::results, backend::search(q));  // latest-wins by construction
}
fn results(&mut self, result: Result<Vec<Suggestion>, SearchError>) { … }  // no epoch param
```

One line replaces six; the `epoch` field, the capture tuple, and the guard all delete, in all
three examples. (`derived_observe.rs` already *claims* "latest-wins inside the task" — with no
mechanism shown; this is the mechanism.) The unstamped `tokio::spawn + remote.send` form remains
the honest floor for protocol streams (async_search's progress events are correct as written).

**2b. A `List` can follow a reader.** Typeahead can't use `query.try_map_async(search)` today
because its hits are a `List` with durable slots and an active-selection `Slot`. Bridge it:

```rust,ignore
hits: List<Suggestion>,                        // still the owner's storage
// in the constructor:
hits.follow(query.debounce(150.ms()).try_map_async(backend::search), |s| s.id);
```

`follow` reconciles each admitted result into the list by key — existing rows keep their slots
(selection, focus, edit state survive a refresh), and staleness/cancellation ride the reader's
stamps. With 2b, `Typeahead` loses `changed`, `results`, *and* the epoch machinery entirely; its
remaining handlers are pure selection logic. That is the "drastically simpler" version: the
component drops from ~110 lines to ~60, and none of the surviving lines are async bookkeeping.

## 3 · Delete `SharedString` from the public surface

`SharedString` existed because current GPUI rebuilds the element tree every frame and needed
clones to be cheap. The borrowed frame (07 §2.1) removed that reason: description **borrows**
`&str`, and the commit diff promotes a changed operand to owned storage — whatever interned
representation the kernel likes, invisibly. Yet the sketches still carry the type out of habit:

- `hello_world.rs`: `text: SharedString` — should be `String`;
- `typeahead.rs`: `SearchError::Network { detail: SharedString }` — should be `String`;
- `identity.rs`: `label: SharedString` — should be `String`;
- `creating_components.rs`: `label: impl Into<SharedString>` — should be `&str` (the helper
  borrows for the frame anyway; that is the whole point).

Application code should be **base Rust**: `String` in structs, `&str` at boundaries, `format!`
temporaries into the arena. `SharedString` (or whatever the interned retained form is) becomes a
kernel-internal type that never appears in a signature an application writes. 07 §2.1's sentence
"promoted (`&'f str` → `SharedString`)" stays true — it just names an implementation detail now.
The one honest exception is a rope/large-text snapshot crossing an ownership boundary, and those
already have their own handle types. Gate this: **no example and no public API mentions
`SharedString`.**

## 4 · Containers take children; `div()` is never glue

Two ceremonies compound in almost every sketch.

**4a. `.children((…))` is a mandatory extra call.** `text("hi")` and `button("Save")` take their
content directly, but every container spells `column().gap(8).children((…))`. Let container
constructors accept children as the argument, with builders unchanged for styling:

```rust,ignore
column((                       // was column().children((
    text(title).text_sm(),
    row((left, right)).gap(8), // was row().gap(8).children((
))
.gap(12)
```

This is pure sugar — `children()` remains for the styled-first ordering — but it removes one call
and one paren level from essentially every view in the corpus, and it makes the code read as the
tree it is.

**4b. The wrapper `div()`.** [pointer_follow.rs](examples/pointer_follow.rs) is the named
offender: `div().relative().size(pct(100), vh(100)).children((…))` exists only to hold children
and establish a positioning context. Two fixes together delete it:

- **The document root fills the window by default.** Every root in the corpus opens with
  `.size_full()` / `.size(500)` ceremony (`hello_world`, `text`, `uniform_list`, `reach`,
  `haptic`, …). A root should be full-bleed unless configured otherwise — the window already has
  the size.
- **`Window::document` accepts children, and absolute placement implies the context.** A
  `follow(…)`/`.pos(…)` child inside any container is positioned against that container without
  a `.relative()` incantation (the retained tree knows its containing block; CSS's opt-in is a
  compat wart, not a law worth copying).

```rust,ignore
// pointer_follow.rs after — no adapter struct (07 §2 already allows fn views), no wrapper div
fn loupe() -> Element<'static> {
    layers((
        text("Move around").pos(24, 24),
        follow(pointer::local()).offset(-12, -12).child(icon(Crosshair)),
        div().size(80, 80).bg(theme.accent).translate(pct(10), 0).rounded_full(),
    ))
}

fn main() {
    Application::run(Window::document(loupe).title("Follow").size(480, 320));
}
```

`layers(…)` is the honest name for "stacked children, painter's order" (the workbench already
uses `stack()` — pick **one** of `stack`/`layers` and delete the other). `div()` survives as the
styled-box primitive — `swatch` in hello_world is a legitimate `div` — but no example should ever
need it as *glue*. Note the sketch also shed 14 lines of `struct Loupe {}` + manual
`impl Default` + `impl View` adapter that 07 §2 had already made unnecessary; the examples must
use their own plan's floor.

## 5 · No parenthesized borrows in view code

`(&self.pos).project(|p| …)`, `(&self.hot).project(…)`, `(&editor.cursor).project(…)`,
`(&self.pocket).recover(…)` — the paren-wrapped borrow appears in four sketches and reads like a
compiler appeasement. The tuple form `(&a, &b).project(…)` legitimately needs the trait-on-tuple;
the single-source form does not. Give `Signal<T>`/`Reader<T>`/`Entity<T>` inherent `&self`
methods (`project`, `map`, `recover`) so the spelling is `self.pos.project(|p| …)` — the tuple
impl stays for genuine products. Zero semantic change; deletes a wart from the most-copied lines
in the corpus.

## 6 · One spawn story (and the `remote()` hole)

Across the corpus there are **three** idioms for "do async work from a handler":

| Example | Idiom |
|---|---|
| typeahead, reach, async_search | `tokio::spawn` + captured `self.remote()` + `remote.send(route)` |
| derived_observe | `self.spawn(future)` — a verb 07 never defines |
| async_workbench | `self.action(…).queue(…).then(…).catch(…)` — 07 §7.8's adapter, but invoked on `&mut self` in a handler where §7.8 mounts it on a *button* |

Pick the ladder and say it once: (1) `self.search`/stamped spawn from finding 2a for
latest-wins derived effects; (2) the §7.8 action adapter for user-triggered mutations with
queue/completion policy — and decide whether it is element-mounted, handler-invoked, or both,
because the examples currently disagree with the spec; (3) raw `runtime.spawn` + `Remote<T>`
only for protocol streams (presence, progress). `self.spawn` as a fourth unnamed thing dies.

Underneath sits a real hole: `ForegroundTaskDemo` in async_search calls `self.remote()` — but it
is a **plain contained field**, not an `Entity`. 07 defines `Remote<T>` for entities; if every
mounted owner is remotely addressable, the entity/contained distinction needs restating (what
does `Entity<T>` still buy? independent scheduling and shared ownership — fine, but then
`remote()`'s true requirement is "mounted owner," and 07 §9 should say so). If contained views
are *not* addressable, the example is wrong and the demo structs must be entities. Either answer
is fine; the corpus currently assumes one while the spec implies the other.

## 7 · The workbench's remaining ceremony, itemized

Beyond findings 1–6, `async_workbench.rs` carries five more patterns with cheaper forms:

**7a. Hand-rolled tab selection.** The workbench writes per-tab
`.selected(latest(&self.active).map(|active| active == Some(slot)))` — while
[docking.rs](examples/docking.rs) already shows the right shape:
`tabs(&self.tabs, …).active(self.active).on_select(Group::focus)`. The widget owns
selected-state, the `latest` policy, and the click route in one place. Two examples, two APIs for
the same widget; docking's wins. (`latest(x).map(|a| a == Some(slot))` also motivates the
combinator from 11 §1 — but the real fix is not spelling it per row at all.)

**7b. `ItemHost` assembly.** `ItemHost::new(project.share(), slot, Workbench::item_event)`
threads the item's back-channel through *construction*, per placement. The Close/Select/Save
events are child-to-host outputs — mount-scope wiring, not constructor wiring. Move the route to
the container: `tab_bodies(&self.items, …).on_item(Workbench::item_event)`, and let the host
record (project handle, slot) be assembled by the catalog/mount. `ItemPlacement::restore` then
takes `(slot, record)` and nothing else.

**7c. The boundary triple.** Every async region pays
`.loading(item_skeleton(&…)).failed(restore_failed.with(record.clone())).faulted(item_factory_fault)`.
§7.6 already routes unhandled failures to the application supervisor — so `.faulted` should
*default* (supervisor + standard fault badge), `.failed` should default to a standard retry card,
and the `.clone()` ceremony disappears because the failure handler already receives the request
stamp/provenance (§7.6's normalized record) rather than needing the record smuggled in by value.
Common spelling: `boundary().loading(item_skeleton).child(…)` — one policy stated, two inherited.

**7d. The phase sextuple, twice.** `editor_surface(&self.main).projection(…).layout(EditorKernel::layout)
.geometry(EditorKernel::geometry).paint(EditorKernel::paint).hit(EditorKernel::hit)
.input(EditorKernel::input).accessibility(EditorKernel::accessibility)` — verbatim again for the
minimap. A kernel is a *set* of phase functions; let it be one value:

```rust,ignore
const EDITOR: SurfacePhases<DisplayPipeline> = SurfacePhases {
    layout: EditorKernel::layout,
    geometry: EditorKernel::geometry,
    paint: EditorKernel::paint,
    hit: EditorKernel::hit,
    input: EditorKernel::input,
    accessibility: EditorKernel::accessibility,
};
editor_surface(&self.main).phases(EDITOR).target(host.editor_target)
editor_surface(&self.minimap).phases(EDITOR.without_input())
```

This is a struct of fn items — not the "trait to implement" §15.2 rightly rejected — and the
individual `.layout(…)` setters remain for one-off surfaces. Twelve chained calls become two.

**7e. The presence three-step.** `Entity::new(PresenceSession::new(route))` +
`PresenceSession::attach(presence.remote(), transport, runtime)` + a *stored*
`presence_snapshot: Reader<…>` field fed by `presence.reader(PresenceSession::snapshot)` — where
`snapshot()` **clones the snapshot on every read**. Three fixes: one constructor
(`PresenceSession::connect(transport, Workbench::apply_presence_batch) -> Entity<PresenceSession>`),
entity-as-source reads (`self.presence.snapshot` is a signal reached through the entity — 11 §1's
algebra makes it a source directly, so the stored `Reader` field deletes), and no clone-per-read
accessor at all. Struct fields: 8 → 6.

**7f. `effects.after_commit(Focus::claim(self.editor_target))`** — already 11 §12; the example is
the evidence: `self.editor_target.claim_focus()`.

## 8 · Naming

| Current | Problem | Proposal |
|---|---|---|
| `Drop<Color, Slot<Tile>>` (interactive.rs) | shadows `std::ops::Drop` — unusable name in Rust | `Dropped<T>` / `DropEvent<T>` |
| `List::reserve(|slot| …)` (workbench) | collides with `Vec::reserve` (capacity) in a type that derefs to `[T]` | `insert_with(|slot| …)` |
| `IntoPresence` (typeahead) vs `PresenceSession` (workbench) | two unrelated "presence" concepts in one API | widget one → `IntoVisibility`; collab keeps "presence" |
| `row_el()` (typeahead) | `_el` suffix because `row()` is taken — a naming collision made public | list rows are just containers; with finding 4a it's `row((…))` or a `list_row()` widget |
| `.pan(Pan::VERTICAL)` (uniform_list, image) vs `.overflow_scroll()` (text, animation) | two scroll vocabularies | one: `.scroll(Axis::Y)` / `.scroll(Axis::BOTH)` |
| `TargetHandle` + `impl TargetRef` + `Target<K>` (identity.rs) | three target-ish nouns; `TargetHandle` undefined | `Target<K>` + `AnyTarget`, params take `impl Into<AnyTarget>` |
| `decode_at(layout_size())` (image.rs) | looks like an ambient layout *read during describe* — a phase violation in a sketch | a token: `.decode_at(Decode::Layout)` vs `.decode_at(px(160))` |
| `.on_hover_enter(HapticExample::tap).with(style)` (haptic.rs) | `.with` chained on the **element**, but 07 §9 defines `.with` on the **route** | `.on_hover_enter(HapticExample::tap.with(style))` — one meaning, one receiver |
| `self.haptic(…)` / `self.announce(…)` ambient vs `clipboard: Clipboard` parameter | two capability styles with no stated rule | name the class once in §16.4: queued fire-and-forget *sinks* may be owner verbs; request/response *capabilities* are parameters |
| `theme.accent.on`, `pointer.local()` free variables | every sketch uses an ambient `theme` the plan never defines (and §16.5 bans ambient lookups) | define `theme` as the semantic-token namespace (const cascade keys, resolved at commit — a token, not a lookup) in 07 §16.5, or the examples contradict the plan |
| `try_restore_async_on` | verb + 3 suffixes | `restore` (finding 1) |
| `stack()` (workbench) vs `layers()` | pick one | `layers` reads as painter's order; either, but one |

## 9 · Type aliases the corpus is begging for

- **`Selected<T>`** — `Signal<Option<Slot<T>>>` appears in presenter, reach, and the workbench;
  docking has the unsignaled `Option<Slot<T>>`. reach.rs even carries the comment "was
  `Selected<T>`; this IS that alias." Reinstate it *as an alias only* —
  `type Selected<T> = Signal<Option<Slot<T>>>` — no new semantics, one household name for the
  most common compound type in the corpus. (The unsignaled form stays spelled out; promotion is
  then literally adding `Selected<…>`.)
- **`Prop<T>`** — helper signatures read `count: impl IntoProperty<i32> + 'a`
  (creating_components). A trait alias (`pub trait Prop<T>: IntoProperty<T> {}` + blanket impl)
  makes the library-helper shape `impl Prop<i32>` — or simply rename `IntoProperty` → `Prop`;
  the `Into` prefix conveys nothing the position doesn't.
- **Not** `El<'a>` for `Element<'a>` — the honest multi-borrow helper
  (`fn section<'a>(title: &'a str, content: Element<'a>) -> Element<'a>`) needs its named
  lifetime either way; an alias would only hide the one thing worth seeing.

## 10 · `#[reactive]` finally has a comparison

07 gate 3 promises that adding/removing `#[reactive]` changes only scheduling counters — but no
example shows the two forms side by side, so the promise is unfalsifiable by reading.
[presenter.rs](examples/presenter.rs) uses the macro without showing what it replaced.
[examples/reactive_compare.rs](examples/reactive_compare.rs) (new) is one component written
twice — the attribute form and the hand-lowered form with explicit ports and `project` regions —
with the lowering annotated read-for-read, plus the two things the macro deliberately does *not*
do (see through opaque helpers; discover async reads). That file is the right home for gate 3's
fixture when the API lands.

---

## Decision list

| # | Decision | Touches |
|---|---|---|
| 1 | Runtimes are installed, never threaded; `_on` family → one `.on(&pool)` modifier | workbench, 07 §7.0 naming |
| 2a | Stamped owner-spawn verb; epoch fields deleted | typeahead, reach, derived_observe |
| 2b | `List::follow(reader, key)` — keyed reconcile from a derived reader | typeahead; 07 §4.1 |
| 3 | `SharedString` becomes kernel-internal; public surface is `String`/`&str` | 4 examples, 07 §2.1 wording |
| 4 | Containers take children directly; root fills window; absolute placement needs no `.relative()`; `layers(…)` | every example; pointer_follow rewrite |
| 5 | Inherent `&self` combinators on single sources — no `(&x).project(…)` | 4 examples |
| 6 | Three-rung spawn ladder stated once; `remote()`-on-contained-owner decided | async_search, derived_observe, 07 §7.8/§9 |
| 7 | Workbench: widget-owned tab selection, container-level `on_item`, boundary defaults, `SurfacePhases` bundle, `PresenceSession::connect`, `claim_focus` | async_workbench |
| 8 | Naming table applied (Drop, reserve, IntoPresence, pan/scroll, targets, with-on-route, theme defined) | corpus-wide |
| 9 | `Selected<T>` alias; `IntoProperty` → `Prop` | 07 §4/§11 |
| 10 | reactive_compare.rs is gate 3's fixture | examples |
