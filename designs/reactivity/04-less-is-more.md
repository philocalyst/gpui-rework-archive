# 04 — One View, Two Registers, One Retained Machine

Status: **superseded at the authoring seam.** The two-register receiver contract, `.key()`,
`.identity()`, and `view(&mut self)` below are replaced by
[05-one-register.md](05-one-register.md) (rationale) and [07-the-ladder.md](07-the-ladder.md)
(the normative surface). Everything below the authoring seam — pipeline, turn protocol, retained
machinery — still reads here. Do not learn API spellings from this file.

Original status: greenfield replacement candidate for the authoritative architecture. This proposal is
not constrained by GPUI source compatibility. It keeps the useful GPUI character—ordinary Rust
state, fluent elements, direct behavior, native rendering—and removes the contextual and retained
machinery that made the simple path feel less like Rust.

This is the sole implementation candidate. `03-hybrid-plan.md` and earlier approaches remain
research/decision history, not parallel architectures to keep polishing. Rung 1 can still reject
this candidate; until then, new implementation work targets only this model.

Nothing here is a performance claim until the gates in §17 pass.

## Executive decision

One programming model cannot be the best register for every UI.

Most application UI wants a **value register**: ordinary structs, `&self` description, `&mut self`
methods, ordinary `if`/`match`/iterators, and no dependency bookkeeping. Editors, timelines,
spreadsheets, animation systems, and unusually dense dashboards sometimes want a **source register**:
independently changing values, exact consumers, and update topology that survives description.

These are not two frameworks. They are two mutation/invalidation registers over one element
language, one ownership model, one output compiler, one renderer, one interaction protocol, and one
tooling surface:

```text
&mut owner revision ──┐
                     ├─ producer/span protocol ─ manifest ─ layout/text/paint/damage ─ present
source publication ───┘
```

The value register is complete without signals. Its producer is `FnMut() -> Ui` or
`View::view(&mut self)`: ordinary Rust control flow, ordinary mutable state, explicitly repeatable.
The runtime invokes it initially and when an owner event or a framework fact it read becomes due.
`time::wall().each(1.seconds())` therefore reruns it at exact second boundaries;
`time::frame()` explicitly requests presentation cadence. A producer that reads neither sleeps when
idle. The source register progressively narrows a hot field/property/region without changing the
component kind or element language.

This follows the central lesson of without.boats' [“The registers of
Rust”](https://without.boats/blog/the-registers-of-rust/): advanced control should be reified behind
a shared interface and entered because its benefit justifies its cognitive cost. Rust's ordinary
register remains the baseline; the effect is explicit at its boundary and recedes inside it.

The two governing rules are:

> **The producer is ordinary Rust; named fact reads choose its wake set.** No fact read, no hidden
> polling. A source binding replaces a broad producer wake only where an author asks for it.

> **Retain owners and expensive facts; reproduce cheap syntax; never duplicate an authoritative
> fact.**

There is no user-callable `notify()` in the design. There is no required action enum, reducer,
plan struct, render context, lens, field derive, edit draft, wildcard invalidation, universal delta,
second component trait, cadence generic, or permanent node per element. Focused traits exist for
genuinely specialized work—custom sources, render primitives, history, persistence, remote
virtualization, and native asset import—not as the price of a button.

The goal is therefore **not** an illusion of immediate mode. `View::view`/`FnMut` is the explicitly
repeatable ordinary-Rust register; framework fact names expose external cadence; a binding or region
is the explicitly retained/source register. The inspector shows the exact cause and next wake.

The documentation/API is tiered by who must know a noun:

| Tier | Vocabulary | Audience |
|---|---|---|
| Ordinary UI | `View`, `Ui`, `Component`, elements, methods, keys, optional `Id` | forms, apps, most libraries |
| Hot local state | `Signal`, binding, `region` | editors/dashboards and measured hot spots |
| Domain capabilities | `Task`/`Activity`, optional `History`/`Persist`, `Asset`/`MediaSession` | apps that actually need the lifecycle |
| Engine/library frontier | source, protocol facet, `Element`, `Primitive`, renderer/fact leases | specialized reusable crates and framework internals |

A guide never teaches a later tier to explain an earlier one. A value-only application links no
source graph; a non-history owner has no track; a screen without cross-span coordination has no
facet page. “One simple core, opt-in powers” is an allocation and documentation rule, not branding.

## 1. The value register is ordinary Rust

The complete counter is:

```rust,ignore
#[derive(Default)]
struct Counter {
    count: u64,
}

impl Counter {
    fn increment(&mut self) {
        self.count += 1;
    }
}

impl View for Counter {
    // `&mut self` marks this whole producer as ordinary, repeatable Rust.
    fn view(&mut self) -> Ui<'_> {
        row()
            .gap(8)
            .child(text(format_args!("Count: {}", self.count)))
            .child(button("Increment").on_click(Self::increment))
    }
}

fn main() {
    gpui::run(Counter::default());
}
```

There is no `cx`, `Window`, listener wrapper, double closure, notification, message enum, update
function, id, or history result. `View::view` has `&mut self` because this is the ordinary Rust
register: local variables, mutation, `if`/`match`, loops, borrowing, and helper calls retain their
normal meaning. An input handler mutates the same owner and queues one subsequent producer pass.
Multiple mutations may coalesce before that pass; an unrelated GPU present does not invoke it unless
the producer explicitly read `time::frame()`.

### A complete clock is just a producer

```rust,ignore
use std::time::{Duration, UNIX_EPOCH};
use gpui::{time, DurationExt, Ui};

fn clock() -> Ui<'static> {
    // Returns an ordinary SystemTime snapshot and records one exact next-second wake
    // for this producer. It is not an application Signal or timer object.
    let now = time::wall().each(1.seconds());
    let unix_seconds = now
        .duration_since(UNIX_EPOCH)
        .unwrap_or(Duration::ZERO)
        .as_secs();

    text(format_args!("Unix time: {unix_seconds}"))
}

fn main() {
    gpui::run(clock); // a function item returning Ui; no component or closure wrapper
}
```

`gpui::run` accepts a `Ui`/`impl Element` value for a self-contained static/protocol-owned root, a
function/closure producer, or a `T: View` owner. It installs the description scope and invokes
`clock` initially. The `time::wall().each(...)` read adds one coalesced deadline lease to that
producer; at the next exact boundary the same ordinary Rust function runs again. Hidden/minimized
policy may lower or pause presentation while preserving the newest logical time. Tests inject the
same clock and remain synchronous:

```rust,ignore
let mut app = TestApp::at(UNIX_EPOCH + 100.seconds(), clock);

app.text().exact("Unix time: 100").expect(Present)?;
app.advance(1.seconds())?;
app.text().exact("Unix time: 101").expect(Present)?;
app.expect_work().producer(clock).exactly(1)?;
```

The fact APIs are deliberately small and cadence-bearing: `time::wall().each(period)` wakes at
aligned monotonic deadlines while returning injected wall time; `time::frame()` wakes at active
presentation cadence; viewport/container/media facts wake on their actual revisions. Equal reads
within a producer collapse to one lease, and leases disappear with its span. This is owner-level
demand tracking, not a general signal node per expression.

There is one irreducible boundary: the runtime cannot intercept
`std::time::SystemTime::now()` or infer when arbitrary Rust computation will change. Such an
untracked read is a snapshot and changes only on another declared wake. Correct choices are the
named framework fact, explicit `time::frame()` for genuine continuous computation, or a source for
fine-grained reuse. Waking every visible application at 60 Hz merely to conceal this fact would be
simple but catastrophically wasteful.

### `Ui<'a>` is one concrete borrowed description value

There is no finalization method and no public opaque return type:

```rust,ignore
trait View {
    /// Ordinary repeatable Rust: initial, owner-event, and declared-fact wakes.
    fn view(&mut self) -> Ui<'_>;
}
```

Every normal constructor—`row`, `text`, `button`, a library's `date_picker`—returns the same
concrete `Ui<'a>`. Builder calls append compact instructions to a description draft installed by
the runtime around `View::view` and return a small generational range handle. `Ui` is
intentionally non-`Clone`: fluent calls consume and return it, child insertion consumes it, and a
temporary `&Ui` can name that exact range for a relationship before the move. The draft is not a
context: application code cannot access it, read window/application state from it, schedule work,
or mutate an owner. It is only the allocation/recording destination that a Rust allocator would
otherwise be.

The lifetime is real. `text(&self.title)` returns a `Ui` borrowing the title; parent builders carry
the shortest child lifetime; the runtime lowers/canonicalizes the completed value before releasing
the `&self` borrow. Rust therefore prevents any `Ui<'a>` carrying borrowed application data from
escaping, and ordinary borrowed text/data requires no clone or eager copy. A value containing only
`'static` operands can be stored accidentally, so its generational draft id must reject later use
safely; no raw draft pointer is exposed. Large editor documents, images, and cross-frame
custom data still prefer explicit revisioned/asset/source handles because those are the facts the
renderer can reuse. Handler captures must own anything retained for later dispatch.

Draft pages are bump-allocated, reused, and reclaimed in bulk after lowering. `Ui` is not a
permanent widget/node and has no layout, style, lifecycle, or reactive state. Its draft generation
is checked as defense in depth, but the borrow lifetime—not that runtime check—is the primary escape
guarantee.

The advanced path is the `Element` trait. A custom renderer element or a library that truly benefits
from a monomorphized plan may return `impl Element + 'a`; `.child(...)` records it into the current
draft immediately and still returns `Ui<'a>`. Public library constructors should normally return
`Ui<'a>`, keeping
their trait stacks out of callers. There is no framework `Blueprint` type or retained syntax cache.
If a library wants a plan struct, it is an ordinary Rust struct implementing `Element`, containing
the meaningful typed inputs—not frozen framework pages:

```rust,ignore
struct ToolbarPlan {
    can_go_back: bool,
    can_go_forward: bool,
}

impl<'p> Element for &'p ToolbarPlan {
    fn record<'a>(self, draft: &mut ElementDraft<'a>) -> Ui<'a>
    where
        'p: 'a,
    {
        draft.scope(|| {
            row()
                .child(button("Back").enabled(self.can_go_back).on_click(App::back))
                .child(button("Forward").enabled(self.can_go_forward).on_click(App::forward))
        })
    }
}

fn chrome<'a>(plan: &'a ToolbarPlan, body: Ui<'a>) -> Ui<'a> {
    column().child(plan).child(body)
}
```

`ElementDraft` is an advanced write-only recording capability, not the old general `cx`. Ordinary
applications and ordinary library functions never name it.

This split preserves the important properties: `Ui<'a>` and `impl Element + 'a` are both
borrow-checked; neither requires cloning; typed handlers, style impact, payload types, and custom
shader parameters are checked before recording. The concrete path gives up only some structural
type information/monomorphization in exchange for bounded compile time and one compact opcode
format. The typed path remains available when a profile proves that trade is wrong for a specific
library primitive.

### Structure and helpers stay language-shaped

```rust,ignore
fn post_rows(posts: &[Post], selected: Option<PostId>) -> Ui<'_> {
    column().children(posts.iter().map(|post| {
        post_row(post, selected == Some(post.id))
            .key(post.id)
    }))
}

impl View for Inbox {
    fn view(&mut self) -> Ui<'_> {
        let body = match &self.route {
            Route::Messages => column()
                .child(search_box(&self.filter))
                .child(post_rows(&self.posts, self.selected)),

            Route::Settings(section) => settings_page(section),

            Route::Onboarding => onboarding_wizard(&self.account),
        };

        column()
            .when(self.show_toolbar, |column| column.child(toolbar(&self.filter)))
            .child(body)
    }
}
```

That `match` replaces the complete body with three unrelated concrete tree shapes. `if`, `match`,
early return, borrowing, iterators, enums, and local variables retain their Rust meanings. No macro
owns control flow. `Option<Ui<'a>>` and `Iterator<Item = Ui<'a>>` implement `IntoChildren`, and
unrelated branches already have the same concrete type. Builders consume evaluated values;
`.width(self.sidebar_width)` is never secretly a tracked memo or thunk.

The common handler forms are deliberately small:

```rust,ignore
button("Save").on_click(Editor::save);                 // fn(&mut Editor)
button("Select").on_click(move |inbox: &mut Inbox| {   // one closure when capture is real
    inbox.select(post_id);
});
canvas().on_click_event(Editor::clicked);               // fn(&mut Editor, Click)
text_input(&self.query).on_change(Editor::set_query);   // fn(&mut Editor, String)
```

The event-free name is the common path. Event-bearing variants are explicit so ordinary methods do
not accept four ignored arguments. Handler adapters erase their concrete closure immediately; the
element's public type does not grow with every callback. A method handler records its owner
`TypeId` and source location. Lowering it outside the matching owner is a located error rather than
an unsafe cast.

The receiver is the cadence contract, not incidental flexibility. An owner-bound `&mut Self`
handler schedules `view`; an `&Self` handler has no ordinary mutable access and can update only
explicit interior sources if it wants visible change. Both can coexist in one owner. Static
protocol/effect functions remain possible when no owner access is needed. This is the direct answer
to “does this click rerun the component?” without assigning a permanent cadence to the component.

Handler results use one narrow conversion:

```rust,ignore
fn close(&mut self) -> WindowCommand { WindowCommand::Close }
fn save(&mut self) -> Task { /* completion method determines the owner/register */ }
fn choose(&mut self, id: SuggestionId) -> Emit<Picked> { Emit(Picked(id)) }
```

`()` means “no effect.” `WindowCommand`, `Task`, `Emit<E>`, focus/clipboard commands, and
small tuples implement `IntoEffects<Owner>`. This is not an action/reducer system: mutation already
happened in the method, and effects only describe work that must leave the owner transaction.
Effects are normalized and drained after the runtime releases `&mut Owner`. An emitted child event
therefore cannot re-enter a mutably borrowed parent/child; it becomes the next ordered owner
transaction. Immediate visual protocol commands may join the same frame without violating borrow
or causal order. The owner transaction queue drains to a bounded quiescent point before description,
so a child output can update its host before the frame is described. A disappearing route is
generation-checked:
an event already queued against a pinned site route is delivered in order; later output is cancelled
or reported unhandled after that site retires.

This is one explicit **turn protocol**, not several implicit schedulers:

```text
1 input/completion -> 2 ordered owner/source transactions -> 3 effects/outputs to quiescence
-> 4 dirty producers -> 5 layout/text/paint/damage -> 6 present
```

No phase re-enters an earlier active borrow. New input waits for the next turn; protocol-local
presentation changes may join the current output phase only when they cannot invoke application
code. Every queued item carries its cause and generation. Per-turn transaction/effect bounds detect
feedback cycles and print the complete route; cancellation, panic, site retirement, and task races
have fault-injection fixtures. Tests drive exactly this protocol synchronously. Calling it a turn
keeps the ordering cost visible and prevents each capability from inventing an epoch or microtask
queue.

### Invalidation is guaranteed by construction

All ordinary mutable state is owned by the runtime. It can be mutated only through:

- a routed input handler;
- `Component::call(method, args)` on the UI executor;
- a task/timer/capability completion routed to a method;
- an explicit history transaction; or
- a specialized platform protocol implemented by the runtime.

Every boundary increments the value owner's revision and requests a frame automatically. Read
access exposes no ordinary `&mut T`. There is consequently no valid use for `notify()` and no
stale-UI failure mode caused by forgetting it.

`View` is logically pure and has a specified cause set: initial embedding, a committed owner
revision, an explicitly read source version, explicit virtual-range invalidation owned by that span,
or correctness recovery after eviction/device loss. Transactions may coalesce, so code must not depend on an exact
count; the inspector reports every cause and duration. It is never a GPU-frame callback. Rust's
`&self` cannot prevent a private `Cell`, global, filesystem call, or other hidden side effect; the
framework rejects its own mutation/task/platform APIs during description and can sample
double-description for divergent output, but it cannot prove arbitrary Rust purity. Constructors,
handlers, effects, and explicit lifecycle protocols own side effects.

`Component::call` is the non-event escape hatch and still avoids closure threading:

```rust,ignore
search.call(Typeahead::set_query, query);
document.call(Document::apply_edits, edits);
```

Internally generated adapters support a few ordinary Rust method arities and pack arguments into a
tuple. `edit(|value| ...)` may exist for dynamic tooling or unusual borrow patterns, but it is
intentionally the advanced spelling and has exactly the same owner-wide invalidation.
`Component::call` starts immediately when no owner is borrowed; from inside another owner
transaction it queues behind that borrow with the same causal ordering as `Emit`.

Panic semantics are normal Rust semantics. The runtime preserves its own dispatcher invariants but
does not claim to roll back arbitrary partially completed mutation. Domains needing atomicity use a
transaction/checkpoint (§12). Hosts that execute plugins or untrusted extension components can add
a real site boundary without wrapping ordinary UI in closures:

```rust,ignore
self.plugin.element().recover(plugin_crashed)
```

The runtime already invokes a child component/region producer independently, so `recover` can catch
an unwind during its initial or later production/lowering, discard scratch output/source leases,
cancel that generation's input protocols, and publish the fallback span or retain the last-good span
according to policy. The `Fault` includes the causal producer/turn and is exposed through normal
activity/testing tools. It does not roll back domain mutation that occurred before the panic. A
panic inside an inline stateless helper is part of its host's `view`; isolating arbitrary statements
requires the deliberately exceptional `boundary(|| helper()).recover(...)` spelling. Panic-abort
builds need process/wasm isolation for hostile plugins and cannot promise an in-process boundary.

### Context becomes capability, not plumbing

Description takes no ambient context. Theme colors, scale-relative lengths, locale direction,
viewport units, and system appearance are typed late-bound values resolved by layout/paint:

```rust,ignore
text("Warning").color(theme::danger()).max_width(length::viewport(0.5))
```

Common responsiveness is output-owned style/layout data over one child structure:

```rust,ignore
navigation(&self.routes)
    .responsive_style(
        breakpoint::COMPACT,
        style().direction(Axis::Column).hide("labels"),
    )
    .responsive_style(breakpoint::WIDE, style().direction(Axis::Row))
```

Only the active style/layout variant runs. Precompiling two genuinely different element structures
is legal but pays to describe/store both and is not presented as free. Arbitrary Rust that must
choose structure from a window fact uses an explicit environment `Source` in a source region or
stores the fact through a routed platform event. Removing context intentionally removes untracked
ambient reads; it does not pretend they are ordinary values or retain a borrowed closure across
frames.

Application data is an ordinary field, service handle, or component. Input-specific data arrives
as a typed event. Side effects leave as typed effects. Custom low-level rendering receives a narrow
phase object because it genuinely needs device/encoder capability; that does not justify passing a
general `cx` through every description and callback.

## 2. Composition has two shapes, not a component protocol maze

There are only two normal library shapes:

1. a stateless function or owned builder returning `Ui<'a>`;
2. a `Component<T: View>`, whose description reruns after its `&mut T` transactions while any
   explicit source bindings/regions update independently.

There is one owner handle and one component lifecycle. A component may contain zero signals or a
thousand without changing its type, its parent field, its element language, or its ordinary state.
The receiver on each mutation and the binding at each consumer carry the cost contract locally.

`Component<T>` is a stable, cheap owning handle. Internally its sparse durable state is split
honestly:

```text
OwnerId = T + revision + effect/task mailbox + opted-in capability state
SiteId  = one active parent embedding + inherited environment + key/alias scope + output routes/protocols
SpanId  = the current published description/output range for that site
```

A stateless element gets none of these. A stateful component has one owner and at most one active
site/span. Separating the three flat records prevents state ownership, mount placement, and output
reuse from quietly becoming one object tree. A parent describing an unchanged child handle reuses
the site's span without calling the child's `view`. Dropping the final owner cancels owned
tasks and protocols. A headless service is an `OwnerId` without a site or UI trait implementation.

`Component::new(value)` requires no render context: it creates an inert UI-local owner and assigns
its runtime embedding lease when first inserted. A call before insertion changes its revision but
schedules no window. One component has at most one active embedding because focus, IME, capture,
scroll, tasks, output routes, and its last span are presentation-specific. A second embedding is a
located error; after the old span retires, the component may move. Applications that want two views
over shared data use two components over an explicit shared model/source. This removes owner fan-out
and keeps the normal record to one owner/site/span chain, not a dependency graph.

First embedding may run one explicit method hook before the first child description:

```rust,ignore
let search = Component::new(Typeahead::new(service)).on_mount(Typeahead::mounted);
```

The hook is for behavior owners that must acquire a subscription/asset lease and may return effects.
It is not invoked for static elements, runs as an owner transaction, and drains effects after the
borrow. Owned tasks/leases cancel automatically; `Drop` handles synchronous domain cleanup. There
is no general render-time hook API.

The hook runs on each transition from no site to one active site. Component state remains alive in
its owning Rust field while conditionally absent, but focus/IME/capture, output routes, site-bound
subscriptions, and active UI work are site-scoped and cancel or pause on unmount by default.
Cached asset values may remain under the byte budget. Work that must outlive all sites
uses an explicit service/background scope, making hidden network/CPU activity visible to tools.

There is no controlled-component reconciliation protocol. Controlled UI is a function over a
borrowed value and a handler:

```rust,ignore
fn title_editor(title: &str, changed: Handler<String>) -> Ui<'_> {
    text_input(title).on_change(changed)
}

title_editor(&column.title, move |board: &mut Board, title| {
    board.rename_column(column_id, title);
})
```

The host remains the only writer. There is no copied input record, `apply_input`, prop comparison,
pre-description mutation phase, or one-frame echo to prevent. The one closure exists because a column id is
actually captured; `title_editor(&title, Board::rename_title)` is available when the method already
has the right arguments. A reusable control that truly owns a query, focus session, request policy,
and selection is a `Component<Typeahead>`. A host-controlled typeahead is a stateless builder. The
framework does not hybridize those two ownership choices.

Visual slots belong to the parent embedding span rather than the child's state. A stateful library
may expose named slot points, and the host attaches current elements with
`.slot("empty", empty_results())`; `Ui<'a>` is already the uniform current-pass value, so dynamic
slots need no second erasure type. Slots, inputs, and output routes retire with the one embedding and
never become a second component lifecycle. Public libraries normally wrap raw named slots in typed
builder methods such as `.empty(element)`, keeping string slot coordination private.

A slot that must survive child-only updates is a component token or owned/revisioned slot input. A
current-pass `Ui<'a>` may borrow only until the parent's completed `view` is lowered. Its canonical
parent-owned slot span is compiled on demand. While inactive it has no child site or protocol state; its descriptor/output
may stay evictable under the normal byte budget. If evicted, activation invalidates the parent owner
to recreate it.

Dynamic stateful children are ordinary model ownership, never created by description. An optional child
is an `Option<Component<T>>`; a collection uses `ComponentMap<K, T>`, a thin keyed owner container
mutated from normal `&mut self` methods:

```rust,ignore
fn apply_rows(&mut self, rows: impl IntoIterator<Item = RowData>) {
    self.rows.reconcile(rows, RowData::id, Row::new, Row::set_data);
}

fn view(&mut self) -> Ui<'_> {
    column()
        .children(self.rows.iter().map(|(id, row)| row.element().key(id)))
}
```

Removal drops/cancels the child owner; reorder moves only sites/placements keyed by `K`. The
container offers entry/retain/drain APIs and no render-context hooks. This is the explicit answer to
stateful `if`/loops and lets libraries build reusable component collections with normal Rust data
structures. It is not a virtualization strategy: a 100k-row list keeps domain rows plus sparse
active protocols/range facts, not 100k `Component` owners, unless every row truly owns independent
behavior that must remain resident.

Large stateless collections do not need one component per row. `keyed` is a synchronous borrowed
construction adaptor with an exact per-item witness:

```rust,ignore
keyed(&self.columns)
    .by(Column::id)
    .revision(Column::revision)
    .row(Self::column)
```

While the slice is borrowed, `keyed` compares keys/revisions with the prior span and invokes the row
function only for a new key, a changed revision, a changed site environment, or a newly visible
virtual range. It appends description records and returns a `Ui<'a>` borrowing only through the
current lowering; neither the slice nor row closure enters the retained manifest. Re-entering
`Board::view` reconstructs only this cheap adaptor. This is
not dependency tracking: the domain supplies the identity and revision it already owns. With a
plain `Vec<T>` and no revision witness, the honest fallback reruns row functions or exact-compares
`T`; there is no hash-trusted fast path. Libraries are encouraged to expose revisioned collections
when their scale warrants the stronger boundary.

A supplied revision is a correctness contract, not merely a speed hint. Dev builds sample rows by
exactly re-emitting/comparing them; if content changes while the key/revision pair does not, the
diagnostic names the row, revision producer, first differing fact, and mutation turn. The runtime
falls back to conservative row work for that collection generation. Production can trust an audited
revision or choose exact comparison—never silently hash-trust stale UI.

### The kanban board without presentation mirrors

The board owns board data once. Columns are not components merely to manufacture memo boundaries,
and drag state is not copied into signals:

```rust,ignore
struct Board {
    columns: Vec<Column>,
    filter: String,
    history: Track<Board>,           // present only because Board opts in (§12)
}

#[derive(Id)]
#[owner(Board)]
enum BoardId { Columns }

impl Board {
    fn rename_column(&mut self, id: ColumnId, title: String) {
        self.commit("Rename column")
            .replace(move |board| &mut board.column_mut(id).title, title);
    }

    fn move_card(&mut self, drop: Drop<CardId, ColumnId>) {
        self.commit("Move card").apply(MoveCard::new(drop));
    }

    fn card(card: &Card) -> Ui<'_> {
        card_view(card)
            .key(card.id)
            .hovered(paint().background(theme::surface_hover()))
            .draggable(card.id)
    }

    fn column<'a>(&'a self, column: &'a Column) -> Ui<'a> {
        let id = column.id;

        column_shell()
            .key(id)
            .width(280)
            .drop_target(id)
            .on_drop(Self::move_card)
            .child(
                text_input(&column.title)
                    .on_change(move |board: &mut Board, title| {
                        board.rename_column(id, title)
                    }),
            )
            .child(
                virtual_list(&column.cards)
                    .key(Card::id)
                    .row(Self::card)
                    .estimate_height(88),
            )
    }
}

impl View for Board {
    fn view(&mut self) -> Ui<'_> {
        column()
            .child(board_toolbar(&self.filter).save_status(activity::<persist::Save<Self>>()))
            .child(
                row().id(BoardId::Columns).children(
                    keyed(&self.columns)
                        .by(Column::id)
                        .revision(Column::revision)
                        .row(Self::column),
                ),
            )
    }
}

fn main() {
    gpui::run(
        Board::new()
            .with_history::<MainHistory>()
            .with_persistence(),
    );
}
```

Resident scrolling is a transform/clip patch and invokes no Rust. When an entering band needs rows,
the runtime schedules the smallest value owner; `virtual_list` consumes the newly requested slice
range synchronously and emits only new/changed row records before returning. No borrow, collection
snapshot, or closure crosses a frame. If first-pass layout discovers that its initial range estimate
was insufficient, one bounded same-frame owner re-entry supplies the corrected range before
presentation. Variable-height measurement, anchor correction, overscan, and extent summaries are
runtime facts. Accessibility requests emit the same row element into semantics-only output; there
is no second semantic provider. An advanced `VirtualSource` trait exists only for paged/remote data
that cannot be borrowed as a slice.

The common drag protocol owns pointer capture, cancellation, preview placement, target hit testing,
autoscroll, keyboard semantics, and the transform-only presentation lane. `draggable(P)` and
`drop_target(T)` are typed by their payload/target values; `on_drop` receives `Drop<P, T>`. A
`DragPayload` trait is useful only for native/cross-process serialization or a custom preview, not
for a kanban card. Arbitrary editor gestures may opt into a source/custom protocol, but common drag
does not require a `DragSession`, three signals, or an overlay view.

For this board, the resident cost is deliberately asymmetric:

- each domain column/card exists once in `Board`; there is no `ColumnInput`, duplicated `Arc<[Card]>`,
  controlled snapshot, or presentation model;
- a visible column pays compact keyed/span/layout/paint facts, while an offscreen card pays only its
  domain bytes plus an extent/key summary if it has been observed;
- an idle draggable card has no drag object or signal; an active drag pins one protocol record,
  preview chunk placement, and payload;
- completed motions disappear, inactive persistence allocates at most its capability status, and a
  non-history/non-persistent application allocates neither track nor save machinery; and
- borrowed strings are promoted only into shaped/source facts that must survive the description,
  with no default `Arc` count per label.

This does not make the domain model or shaped/decoded/GPU facts free. It removes parallel ownership
representations so the memory budget can spend bytes on the facts the renderer actually reuses.

### Stateful libraries remain self-contained

A typeahead library that genuinely owns its query and request lifecycle can remain self-contained:

```rust,ignore
pub struct Typeahead {
    query: String,
    results: Latest<Vec<Suggestion>, SearchError>,
}

#[derive(Id)]
#[owner(Typeahead)]
pub enum TypeaheadId { Input, Popup }

pub struct Picked(pub SuggestionId);

impl Typeahead {
    fn query_changed(&mut self, query: String) -> Task {
        self.query = query.clone();
        self.results.run_debounced(query, Search::suggest, Self::suggestions_loaded)
    }

    fn pick(&mut self, id: SuggestionId) -> Emit<Picked> {
        Emit(Picked(id))
    }
}

impl View for Typeahead {
    fn view(&mut self) -> Ui<'_> {
        column()
            .child(
                text_input(&self.query)
                    .id(TypeaheadId::Input)
                    .on_change(Self::query_changed),
            )
            .children(self.results.ready().into_iter().flatten().map(|item| {
                let id = item.id;
                button(&item.label)
                    .key(id)
                    .on_click(move |this: &mut Self| this.pick(id))
            }))
    }
}

impl App {
    fn picked(&mut self, picked: Picked) {
        self.open(picked.0);
    }

    fn view_search(&self) -> Ui<'_> {
        self.search.element().on_output(Self::picked)
    }
}
```

`.on_output(Self::picked)` infers `Picked` from the method and attaches a typed output route at the
embedding boundary. It is not a
subscription closure, does not expose private library messages, and is torn down with that
embedding span. `Component::element()` creates only a cheap embedding token; it does not invoke the
child's `view`. The compiler invokes the child only when its revision/span requires it. Unhandled
output can be rejected in debug builds or deliberately detached. Routing is one hop to that site's
host owner—there is no global event bus or implicit type-based bubbling. A host deliberately forwards
an event by returning another `Emit<E>`.
Callbacks passed into stateless helpers are also ordinary typed handlers. Slots and ordinary
children use the same concrete `Ui<'a>`; `impl Element + 'a` is reserved for advanced typed recording.

Libraries do not get second-class renderer or tooling access. The same elements, typed ids/external aliases, semantics,
focus, IME, assets, portals, custom primitives, tests, inspector, damage, and memory budgets are
public. Extra typing is welcome at a library boundary when it creates a real guarantee; it is not
required of every application field or leaf.

This is also the external-library answer. React's useful composition ingredients are functions,
children/slots, local owned state, callbacks, context-like services, and package-defined
primitives—not its virtual DOM. Here they map to ordinary functions/builders, generic children or
`Ui<'a>` slots, `Component<T>`, method handlers/typed outputs, opt-in capabilities, and public
element/effect/asset/motion traits. A headless library can own behavior and expose builders; a
visual library can be purely functional; a dense editor can opt selected fields or whole regions
into sources without changing its component kind. The host does
not add a library-private action enum, reducer branch, subscription poller, or renderer adapter.

| React library seam | This proposal |
|---|---|
| Function component + props | Rust function/builder + borrowed arguments |
| `children` / render prop | `Ui<'a>`, iterator, method pointer, or advanced `impl Element + 'a` |
| Local state + lifecycle | Private `Component<T>` fields and one explicit mount lease when needed |
| Controlled component | Borrowed value + typed handler; no mirrored prop state |
| Context/provider | Typed late-bound value or explicitly exposed capability scope |
| Hook package | Ordinary state type/trait; explicit sources/regions only when tracked reads are the actual feature |
| DOM/custom renderer escape | Public `Element`/`Primitive`/`Asset`/`Motion` contracts with normal tooling |

Crates can wrap low-level strings and raw protocols in their own typed constructors without forcing
that verbosity on applications. The concrete `Ui<'a>` boundary also prevents every library's
private builder chain from becoming part of the caller's concrete type, compile time, or semver
surface. A library returns the same value as a built-in; it is not a second-class trait object.

Application text is ordinary `String` and borrowed `&str`. Text builders accept `&str`, `String`,
`fmt::Arguments<'a>`, `Cow<str>`, `Rc<str>`, and explicit `Arc<str>` through one `IntoText<'a>` carrier. Borrowed bytes
remain borrowed through synchronous lowering and are promoted only if a canonical retained text
fact needs ownership; large editor text uses a revisioned document handle so it is never recopied as
a string. `SharedString` does not exist in the greenfield public API. Domain state uses `String`,
deliberate UI-local sharing uses `Rc<str>`, and cross-thread sharing uses `Arc<str>`. The renderer's
retained representation is an internal generational `TextId`, not another application string type;
`!Send` UI code never pays atomic reference counting merely because text may eventually be drawn.

## 3. The second register is a field, not a component kind

The value register deliberately reruns one owner's cheap Rust description. When that work is
material, the application makes only the changing value live. There is no promotion from a
`Component` to a separate `Live` handle, no second trait, no mount-only control-flow language, and no conversion of
every field or handler. The progressive ladder is literal:

```text
plain field + fn(&mut Self)          rerun View::view
Signal<T> + fn(&Self)                publish exact source consumers
&Signal<T> on a bindable property    patch that property's downstream stages
region(Self::part)                   rerun only source-dependent structure
```

A component may stop anywhere on that ladder. An editor with mostly signals naturally executes
`view` once until an ordinary `&mut Self` operation occurs; it does not need a special mount trait
to obtain that behavior. Conversely, adding one live progress value to a form does not convert the
form's ownership model.

The source seam is advanced and narrow; ordinary descriptions never receive its observation
context:

```rust,ignore
pub trait LocalSource: Clone + 'static {
    type Snapshot<'a>
    where
        Self: 'a;

    fn observe<'a>(&'a self, cx: &mut LocalSourceCx)
        -> Observation<Self::Snapshot<'a>>;
}

pub trait SendSource: Clone + Send + Sync + 'static {
    type Snapshot: Send + 'static;

    fn observe(&self, cx: &mut SendSourceCx) -> Observation<Self::Snapshot>;
}

let progress: Signal<f32> = /* ... */;
progress_bar().value(&progress);
```

The rest of this document uses “source” for either contract. Most authors use `Signal<T>` or a
framework adapter and never implement one. Individual sources may have many consumer spans; their
edges are leased by those spans, not by a second owner tree.

`Signal<T>` is the standard owned source. Passing `&Signal<T>` to a deliberately bindable property
means “keep this destination attached”; passing `T`/`&T` means “use this description's value,” and
`signal.get()` means “take a snapshot and subscribe the current producer.” In `view`, that source
therefore reruns the whole owner; inside `region`, it reruns only that region; in a handler it is an
untracked momentary read.
The signal's type already states the different register, so there is no `watch()` conversion to
repeat on every property. Builders never implicitly dereference a signal into a fixed value.

When the property type differs, `signal.bind(projection)` records one typed, side-effect-free
projection rather than a derived reactive node:

```rust,ignore
.background(self.selection.bind(|selection| {
    if selection.active { ACTIVE_BG } else { NORMAL_BG }
}))
```

The projection runs initially and on exact source-version changes, then patches the property's
generated output-impact class. It cannot emit children, start work, or mutate a source. A method
pointer such as `.bind(Selection::background)` avoids a closure when the domain already has the
operation. A capturing projection must own a small `'static` environment, which is retained and
byte-accounted with the binding. Structure belongs to a region, keeping property computation and
tree computation visibly different.

The cost model is therefore readable from ordinary code and available verbatim in rustdoc/LSP:

| Spelling | What may execute again |
|---|---|
| `impl View::view` + `fn(&mut Self)` handler | The owner's whole `view`, after the transaction |
| `signal.get()` in `view` / `region` | That enclosing owner / region on a new source version |
| `.value(&signal)` | Canonical conversion/affected output stages on a new source version |
| `.background(signal.bind(f))` | `f` plus the generated output-impact path on a new source version |
| `region(Self::body)` | Only `body`, when one of the sources it read changes |
| `fn(&Self)` handler publishing sources | Only those sources' consumers; `view` does not rerun |
| `.hovered(...)`, scroll, caret, transform motion | Renderer/interaction protocol only |
| Unrelated GPU presentation | No application description |

Dev builds record the source location of every producer and can place an inline rust-analyzer/code
lens summary such as `view: 4 calls / 82 µs` or `binding: 1 consumer / paint-local`. The LSP data
comes from an optional bounded profile artifact, not a compiler plugin and not a semantic dependency.
CI can reject measured budgets by source location. The starter templates install a generous owner-
pass budget so a beginner's accidental 2,000-row root view is a visible test/CI failure with the
largest child sites listed, not a profiler archaeology exercise. This tooling makes cost observable,
while the method receiver and binding site keep correctness understandable without tooling.

`Observation` is the Future-like correctness boundary: one protocol yields a coherent snapshot,
exact version, and wake lease. `LocalSource` may lend a UI-executor snapshot. `SendSource` must yield
an owned/guarded snapshot and posts generation-tagged wakes; it never calls UI state while a UI
borrow is active. The context supplies the runtime wake and first/last-consumer lease hooks, but
does not expose consumer ids. Version identity includes source generation, so a recycled slot cannot
wake a new binding. The runtime, not a custom source, owns source-to-span fan-out.

Attaching `&Signal<T>` clones/erases its stable source handle into the binding record; it does not
retain the Rust reference. Borrowed local snapshots exist only during immediate region/binding
evaluation and are canonicalized into the destination fact before that borrow ends; a
`BindingRecord` never stores them. Custom `LocalSource`/`SendSource` handles use the same direct
`&source` conversion when a property explicitly accepts that source value type. This is the hard
lifetime boundary between an application's source representation and retained output.

Region publication is transactional: compile into scratch while recording observations and leaving
the old edge set live; attach all newly observed sources; recheck exact versions; atomically publish
the new span/edge set only if they still match; then detach old edges. A mismatch schedules one
bounded retry before presentation. Panic/error drops scratch/new leases and leaves the old published
span intact. Because description cannot mutate a source and the kernel contains no automatic
computed/effect nodes, the UI dependency graph is one-way source→consumer and cannot form a render
cycle. A future derived source must own and expose its own observation contract.

If a continuously changing external source exhausts the retry bound, the runtime keeps the last
coherent published span and schedules the newest generation for the next frame; it never publishes
a half-old dependency/value set or spins the UI executor.

The source register has the same four useful levels described for Rust's effectful registers:

- **core/source:** advanced libraries implement `LocalSource`/`SendSource` or use specialized
  sources such as a rope revision, media clock, editor selection, or collaborative snapshot;
- **consuming/binding:** `&source` directly updates one text/style/transform/custom-property
  slot without rerunning Rust structure;
- **combinator/region:** a component owns scoped description regions and records which sources each
  region read;
- **control-flow sugar:** a future optional `live!` compiler may turn ordinary `if`/loops over
  sources into regions. It is never required by the base framework or renderer.

Only the first three contracts are reserved now. The signal runtime and syntax are not prerequisites
for the value architecture.

A bound builder property lowers to a sparse `BindingRecord`—source lease, destination span/slot,
canonical conversion function, last exact version/value, and generated style/output impact. It does
not retain the element builder or an arbitrary render closure. On wake, the runtime snapshots the
source, equality-confirms the value when required, patches that typed slot, and starts at the first
affected output stage. Text content may re-shape; a color starts at paint; an isolated opacity starts
at composite. Structure is never a bindable property: it belongs in a region. Custom primitives
declare their bindable slots and damage impact through the same focused renderer contract.

Reactive polymorphism does not infect every library prop. A library property that deliberately
supports live input accepts one concrete, immediately erased `Bindable<T>` carrier (with conversions
from `T`, `&T`, and a compatible source reference); ordinary helpers continue to accept
`T`. `Bindable<T>` is a
fixed value or one source binding, not a closure, memo, or “maybe reactive” graph that propagates
through generic component types. Libraries expose it only on properties whose direct patch path is
worth supporting.

The standard conversion is deliberately concrete enough for Rust coherence:

```rust,ignore
impl<T> IntoBindable<T> for T { /* fixed, owned */ }
impl<'a, T> IntoBindable<T> for &'a T { /* fixed, borrowed until lowering */ }
impl<'a, T> IntoBindable<T> for &'a Signal<T> { /* clone the stable source handle */ }
```

Framework sources such as media clocks and rope revisions provide equally direct implementations.
There cannot be one fully blanket `&S where S: Source<Value = T>` implementation alongside `&T` on
stable Rust without coherence overlap for pathological self-valued sources. A custom source either
implements the non-overlapping conversion for its concrete source/value pair or returns one explicit
`Binding<T>` adapter from its library API. That rare authoring seam is preferable to making every
ordinary use spell a binding suffix or giving up borrowed fixed values.

### A signal-heavy owner is still an ordinary component

An editor progressively enhances the hot fields without changing its trait or parent handle:

```rust,ignore
struct Editor {
    document: DocumentSource,
    selection: Signal<Selection>,
    scroll_y: Signal<Pixels>,
    overlay: Signal<Option<Overlay>>,
}

impl View for Editor {
    fn view(&mut self) -> Ui<'_> {
        column()
            .child(editor_toolbar(self))
            .child(
                editor_surface()
                    .document(&self.document)
                    .selection(&self.selection)
                    .scroll_y(&self.scroll_y)
                    .background(self.selection.bind(Selection::background))
                    .children(region(Self::overlay)),
            )
            .on_key_down(Self::key_down)
    }
}

impl Editor {
    fn overlay(&self) -> Ui<'_> {
        match self.overlay.get() {
            Some(overlay) => overlay_view(overlay),
            None => empty(),
        }
    }

    fn key_down(&self, event: KeyDown) {
        // Mutating Signal fields publishes only their recorded consumers.
        self.apply_key(event);
    }
}
```

`region(method)` binds a normal `fn(&T) -> Ui<'_>` (or advanced `impl Element + '_`) to the current
owner, identified by owner + source call site. It needs no `cx` or repeated owner handle. Repeated/dynamic regions add
`.key(domain_id)`; no name string is required
for the common single site. Reads of
`Signal`/custom sources during that method are tracked locally. An `&T` method handler opens a
source-publication batch without giving out `&mut T`; therefore render-relevant mutation can occur
only through `Signal`/custom source APIs. The owner does not rerun `view`. Directly bound properties bypass the region entirely when
the output stage can patch them safely.

`Signal<T>` uses UI-local interior mutability and exposes no unobserved `DerefMut`. Its `set`,
`replace`, and `update` methods take `&self`; the surrounding shared handler batches their revisions
and wakes consumers after the method returns. A custom source must provide the equivalent revision/
wake contract. Multi-source edits are presentation-atomic at the batch boundary, though arbitrary
panic rollback still requires a domain transaction.

Shared handler methods may return the same tasks, typed outputs, and platform effects as mutable
methods. They enter the same post-borrow effect queue; task completion may route to another
`fn(&T, Result)` method and publish sources.

`View::view` and region description are read phases. Source mutation while either is active is always
rejected; development builds add the source and region locations. Description may read sources and
emit elements; it may not create a reactive feedback effect. Source wakes that race with compilation
follow the attach-and-recheck rule and schedule one subsequent bounded pass.

An `&mut T` handler remains legal in the same editor and visibly chooses owner-wide invalidation.
That is useful for rare configuration replacement and avoids a separate rematerialization API. If
it mutates only a signal, the owner still reruns: the receiver promised the broad register. A simple
lint/code action can change an eligible method to `&self`, but the runtime never guesses.

A region cannot retain changing data borrowed from its value parent. When a region needs such an
input, `region_with(owned_or_revisioned_input, method)` exact-compares and owns the canonical input
alongside that region; the method receives `(&T, &Input)`. A continuously changing input may instead
be a direct source binding. Plain `region` is only for state reachable from its owner.

### The source tier has a hard containment rule

Signals may add source records, consumer edges, and source-owned values only for an explicit direct
binding, owner subscription, or region. They may not create a second element tree, renderer scene, semantic tree,
scheduler epoch, identity namespace, or lifecycle model. Source-to-consumer edges are leased by the
published span and disappear when the span disappears. A source with no consumers costs only its
owned value/revision. A value-only application links or initializes no signal graph.

An ordinary handler receiving `&mut Owner` always dirties that owner, even if it only changes a
signal field. A shared handler receives `&Owner` and can produce visible mutation only through
publishing sources. This avoids the most dangerous “looks the same, costs 10× more” trap without
making authors select or migrate an owner mode.

## 4. One producer/span protocol joins both registers

The output compiler knows nothing about “components versus signals.” It sees producers and spans:

```text
Producer
  id + generation
  revision or exact source version
  invalidation class: owner | region | property | protocol

Span
  producer + local slot/source location
  description range + output-fact handles
  interaction/semantic/protocol records, if any
```

The manifest also retains the minimum downstream topology that layout/damage correctness requires:
parent index, dense child range, layout-containment/reflow boundary, paint isolation/context, and
reverse impact route. These are flat SoA indices/flags, not behavior owners or heap nodes, but they
are honestly retained topology. One generated patch classification routes every binding, style
variant, and custom slot:

```text
CompositeLocal
PaintLocal
LayoutLocal { proven containment boundary }
ReflowAncestor { walk parent indices to exact boundary; siblings may move }
RegionOnly { recompile description before downstream work }
```

Direct source patching is guaranteed only for local classes. Layout-affecting values walk the
recorded ancestor route and invalidate dependent sibling ranges; arbitrary structure is
`RegionOnly`. A custom primitive defaults to region/chunk re-emission unless it explicitly declares
a typed patch function, affected bounds/topology, asset lease, and fallback. This one routing
table prevents signals, hover, layout, and renderer extensions from each inventing a dependency
graph.

A `Component<T: View>` is one owner producer. An `&mut T` transaction changes its revision and
reproduces its span. Its regions and bindings are separately located producers whose source
dependencies choose whether they execute. A bound property may patch a typed downstream slot.
Hover, caret, scroll, and animation protocols patch output-owned slots with no application producer
at all.

The compiler never claims to skip arbitrary Rust inside a dirty value owner. Its locality comes
from sensible component ownership, unchanged child handles, lazy keyed/range descriptors, and
retained output facts. The source register earns finer locality by paying for explicit sources and
consumer edges.

For an unchanged child, `(OwnerId revision, SiteId environment fingerprint)` is the first cheap
exact rejection/reuse witness. Dirty value work is profiled in separate lanes: Rust description,
transient allocation, canonicalization, hash candidate lookup, exact comparison, and cache
admission. A large owner can lose on any of them even when downstream facts reuse. If measured
screens need help, one advanced owned/revisioned subtree input may be added; pervasive memo syntax
or a hidden read graph is not the default remedy.

There is no arbitrary read-witness system in the value register. A parent that reads child data as
an ordinary value owns that dependency and rebuilds when its own mutation boundary fires. A child
`Component` is its own revision boundary. Shared mutable domain state that must independently wake
many consumers is precisely a candidate for `Source`, an actor event, or an explicit application
fan-out—not an invisible runtime guess.

Debug recomputation can sample source regions and direct bindings against a from-scratch value to
detect bad custom-source revisions. Correctness never trusts a hash. Hashes index candidates;
exact input equality or revision contracts confirm them.

## 5. First draw and warm updates use one compiler

There is no retained-node mount algorithm. Empty and warm caches run the same path:

```text
dirty producer -> transient elements -> compact manifest -> layout/text/paint packet -> present
                                             ↘ retained expensive facts on confirmed reuse
```

On the first draw, misses compute output. The compiler appends into reusable pages, interns only
observed repetition, creates durable records only for components/sources/active protocols, and
starts in visibility order. Static leaves are tape words, not arena objects with wires and
lifecycle state. The first interactive frame includes the visible viewport and required
input/semantic records; offscreen virtual content, hover prewarming, speculative decode, spatial
indexes, and cache indexing are deferred.

This does not promise impossible streaming through arbitrary flex/grid/text. Intrinsic sizing,
wrapping, baselines, stacking, clips, and filters may require the complete visible subproblem before
paint. It promises that cold work is the work needed for the visible result, not the construction
of a permanent mirror tree.

Cold reports separate first pixel, first input-ready frame, and first complete semantic/
accessibility-ready frame. They include execution of every visible component/site hook, font
discovery, shader/pipeline/device/swapchain setup, required asset decode/upload, initial hit data,
and semantic materialization. A placeholder, linear fallback, or deferred accessibility range may
improve one milestone but cannot be reported as all three. The claim is narrowly “no object-heavy
permanent mirror-tree mount,” not “the platform has no startup work.”

There is no stored framework syntax format. Reusable plan structs are ordinary typed application/
library data implementing the advanced `Element` trait and record into the same draft. They retain
only the inputs their author chose; normal correctness and first draw never depend on a syntax cache.

## 6. Retain every expensive fact once

The runtime stores one compact current **manifest**, immutable shared fact/chunk pages, and a
transient next/diff journal. The superseded manifest dies immediately after damage and packet
publication. GPU fences pin only referenced packet/asset pages, never a second logical scene.

The invariant is:

> One authoritative representation per expensive fact; every other layer holds an index, range,
> revision, or recomputable summary.

“One” means one canonical logical CPU fact. A GPU texture, immutable command packet, native surface,
or OS accessibility object is necessarily another physical representation; it must have a bounded
generation lease and an attributed CPU/GPU/estimated-driver byte cost rather than being denied in
the accounting.

Examples:

- one shaped paragraph owns glyphs, clusters, source mapping, and ink bounds;
- width-specific wrap entries own only line boundaries and extents;
- paint and hit records refer to shaped/geometry ranges rather than copying them;
- semantic text refers to source ranges, not shaped glyph storage;
- renderer residency refers to a CPU asset key plus device generation;
- handlers and identity sit outside paint keys, so repeated visuals share safely; and
- old/new logical state coexists only for the bounded diff/publication interval.

Position-independent paint chunks store local geometry and asset/style references. Placement,
clip, opacity, and transform live in compact tables. Moving an unchanged panel is a placement edit.
Equality-confirmed content addressing lets repeated resident buttons, icons, rows, and decoration
share one chunk with many placements. Admission is measured: unique tiny chunks stay inline, and a
100k list is solved by virtualization rather than deduplicating 100k retained rows.

“Position-independent” is not “render-context-independent.” Reuse confirms an isolation/context
key covering scale/subpixel phase where relevant, color space, inherited opacity/blend, clip/effect/
backdrop class, asset generations, and interleaved paint-order constraints. Backdrop filters or
non-isolated blending usually prevent cross-placement sharing. A mismatch re-emits or widens the
isolation fact; it never trusts equal local commands alone.

Hot sections are structure-of-arrays with dense 8/16-byte records. Varints are limited to cold
diagnostic/serialization streams. The initial target is `<= 16` live description bytes per
stateless leaf, excluding shared payload and placement, measured with allocator live and reserved
bytes.

That tape target cannot stand in for total retained memory. Every benchmark also reports p50/p95
total resident bytes per visible stateless and interactive leaf, including owner/site/span,
placement, style/clip, hit, semantics, targets/alias interner, source edges, activities/assets, caches, `N`
fence-pinned packets, application-owned plan data, presentation targets, accounted GPU bytes, and the residual process/driver/OS
delta. Exclusions are listed, never hidden in “shared payload.”

The steady-state equation is explicit:

```text
application owners and source values (including any ordinary plan structs)
+ one current manifest + transient diff journal
+ unique immutable text/layout/paint/media/asset facts
+ sparse interaction/semantic/protocol records
+ evictable shared caches
+ exact in-flight packet/asset leases
+ optional presentation pixels
+ reusable reserved capacity
```

There is no permanent wire per property in the value register, node per element, fragment object
per leaf, three style copies, duplicated scene primitive stream, or full backing target required
before the first pixel.

### Memory is an economic lease

Every retained item is pinned by the current frame, an active protocol, or an in-flight backend
lease—or is evictable. All evictable CPU/GPU facts compete under application/window budgets using a
benefit-decayed `observed recompute time saved / reserved bytes` score. Reserved arena capacity
counts. A once-expensive entry cannot squat forever after reuse stops.

Pressure degrades continuously:

1. release superseded journals and trim cooled frame slabs;
2. evict low-benefit paint/layout/output reuse;
3. evict reconstructible GPU residency and spatial indexes;
4. shrink decoded media and text windows; and
5. retain only application state plus protocol/source state whose semantics require continuity.

Occluded/minimized windows enter **floor mode** after policy delay. They keep components/source
values, focus/IME/capture/scroll/activity generations, and explicitly pinned native surfaces; they
drop manifests, presentation targets, layout/paint caches, decoded windows, and reconstructible GPU
residency. Reveal is the ordinary cold compiler. A 20-window session should approach domain state
plus named protocol floors, not 20 complete document/render trees.

The inspector attributes live, unique, shared, evictable, protocol-pinned, fence-pinned, source-
graph, and reserved bytes. “Retained mode” is never accepted as an unowned memory category.

## 7. Continuity, relationships, and test names are different things

The old design overloaded one string id for three jobs. The replacement separates them:

1. **Static continuity** is automatic: site + embedding source token + enclosing keyed scopes.
2. **Dynamic continuity** is the domain key already required by `keyed`/`virtual_list`.
3. **Local relationships** borrow the actual lexical `Ui`.
4. **Named in-process relationships/tests** use an optional component-owned Rust id enum.
5. **External automation/persistence** may attach a human-readable alias; it is not protocol authority.

A relationship is ordinary Rust data derived from the element being referenced:

```rust,ignore
let search = text_input(&self.query);
let find = button("Find").focuses(&search);

dialog()
    .initial_focus(&search)
    .child(search)
    .child(find)
```

`Ui<'a>` itself is a non-`Clone` lexical handle to its described range. Passing `&search` to a
relationship records a compact local target token for that range; consuming `search` embeds it
exactly once. An element that nobody references allocates no target record. Rust catches missing
variables, wrong lifetimes, accidental moves, and passing a string/unrelated value at the call
site; rust-analyzer completion/rename follows the local variable. `initial_focus`, `focuses`,
`labels`, `described_by`, `controls`, `anchored_to`, group-hover, and portal placement all accept
`&impl TargetRef` rather than a string. The relationship method itself declares the role and emits
the corresponding semantic/protocol check. `TargetRef` is sealed for current-pass `Ui<'a>` and
explicit generational handles, so there is no user-implemented identity protocol and no typed
wrapper/finalization call.

There is deliberately no `.identity()` call: taking `&Ui` at a relationship method is enough for
lowering to mint the anonymous token lazily. Unreferenced elements remain record-free.

### Arbitrary distance uses one component-owned id family

A reusable component names only descendants it deliberately exposes. This uses a familiar Rust
enum and one derive; components that expose nothing declare nothing:

```rust,ignore
// Public identity surface declared by the library:
// #[derive(Id)] #[owner(Typeahead)]
// pub enum TypeaheadId { Input, Popup }

impl View for Typeahead {
    fn view(&mut self) -> Ui<'_> {
        column()
            .child(text_input(&self.query).id(TypeaheadId::Input))
            .child(results_popup(&self.results).id(TypeaheadId::Popup))
    }
}

#[derive(Id)]
#[owner(SearchPage)]
enum SearchPageId { Find }

impl View for SearchPage {
    fn view(&mut self) -> Ui<'_> {
        let input = self.search.at(TypeaheadId::Input);

        row()
            .child(label("Query").labels(input))
            .child(self.search.element())
            .child(button("Find").id(SearchPageId::Find).focuses(input))
    }
}
```

`#[derive(Id)] #[owner(T)]` implements the unsafe `IdFor<T>` encoding contract for that
enum. It does not add `type Id` to `View`, allocate a registry, hash a source location, or generate a
component trait. `Component<T>::at` accepts only `impl IdFor<T>`, so
`self.search.at(SearchPageId::Find)` is a compile error with expected owner `Typeahead`. A typo is an
ordinary missing enum variant with completion, go-to-definition, rename, and find-references across
crates. The returned target is copyable and branded with the component's runtime generation.

Because concrete `Ui` deliberately does not carry its enclosing owner through every helper type,
attaching `.id(U::Variant)` inside the wrong owner's `view` is a located lowering error, not a Rust
type error. The arbitrary-distance operation—the dangerous part that could address another
component—goes through `Component<T>::at` and is compile-checked. This is the same deliberate
generic-erasure trade as handler attachment, with both owner types and source sites in the error.

An enum is intentionally an identity family, not a duplicate declaration of the element's semantic
role. Whether the current target is focusable, labelable, or an anchor comes from the actual control
and is checked at lowering with both source sites. Encoding per-variant role typestate would require
turning each variant into a generated marker type and would make one id vocabulary fragment into
many capability vocabularies. The stronger useful compile-time guarantee here is ownership and
spelling; the dynamic semantic fact remains authoritative.

Private layers forward ids without exposing a path:

```rust,ignore
#[derive(Id)]
#[owner(SearchBox)]
pub enum SearchBoxId { Input }

impl View for SearchBox {
    fn view(&mut self) -> Ui<'_> {
        column().child(
            self.field
                .element()
                .export(SearchBoxId::Input, TextFieldId::Editor),
        )
    }
}
```

`export(outer, inner)` accepts only an outer id owned by the enclosing component and an inner id
owned by that child. Lowering records one id-to-token forwarding entry and rejects duplicates or
cycles. A library may move the real editor several components deeper without changing consumers of
`SearchBoxId::Input`. Each boundary explicitly chooses what it exposes, so arbitrary reach does not
become ambient tree lookup or pierce encapsulation.

The local token is stable for the materialization/view site because lowering resolves the
provisional `Ui` range through its `.child`/root embedding source token, enclosing domain keys, and
protocol-role fingerprint—not sibling position or a helper's internal constructor line. Two helper
calls embedded at different Rust sites therefore differ; repeated insertion through one iterator/
loop site requires a key. Active protocol state transfers only when token, generation rules, and
role fingerprint all agree; otherwise it cancels rather than retargeting. A forward relationship is legal:
the manifest resolves the token after the description completes. Borrowed lexical targets cannot
escape the description lifetime or accidentally address another component site; the all-`'static`
escape hatch is still rejected by the draft generation check from §1. Rare cross-site/programmatic
retention explicitly calls `search.handle()`, producing
a generational `TargetHandle` that fails safely after its target retires.

This scheme deliberately does not assign a permanent id object to every element. A static button's
source token is enough for focus/capture continuity, and a label/spacer with no protocol needs no
durable record. Pointer-down pins the exact span generation; removal/replacement cancels it and
pointer-up is never retargeted. Dynamic interactive rows use their domain key. Structural matching
is a reuse hint, never authority to move active protocol state to a different target.

The same typed id is the white-box test locator:

```rust,ignore
app.get(SearchPageId::Find).click()?;
app.get(TypeaheadId::Input).expect(Focused)?;
```

If several active component instances publish the same enum variant, an unscoped test lookup is
honestly ambiguous and lists the component paths; scope through the owning component/key. Strings
survive only as explicit `.alias("stable.external.name")` values for black-box automation,
cross-build recordings, or plugin protocols. They are optional in release and never protocol
authority. `.id(...)` is always Rust-typed; `.alias(...)` is always external, so an overload cannot
quietly demote a relationship to string lookup.

Duplicate aliases are an automation diagnostic, not a runtime correctness failure. Duplicate typed
ids in one component generation, dynamic keys, or target tokens are correctness errors and report
both source locations plus their smallest common site/key ancestor. Virtual interactive lists require `.key(...)`; visible and
offscreen semantics are derived from the same keyed row element, so a second semantic provider
cannot drift.

Handlers are erased into compact current-manifest pages, not retained behavior nodes. An active
dispatch/gesture pins the exact page, owner generation, and output-route generation until completion
or cancellation; long-lived focus/IME/drag state stores ids and protocol data, never a pointer into
an expired element. Handler captures are excluded from content-addressed paint keys, so visual
sharing cannot alias behavior.

Interaction, focus order, and accessibility are sparse manifest sections, not parallel permanent
trees. Most spans emit no record. Platform accessibility diffs stable semantic ids and may request
bounded semantics-only lowering of a virtual row range. Focused,
IME-composing, captured, or inspector-selected records are protocol-pinned and named in memory
accounting. Paint/hit/semantics share transform, clip, geometry, text-source, and id ranges rather
than copying their facts.

### Sparse coordination scopes cross owner/span boundaries

Selection across labels, a two-axis grid, an outline projection, docking, gesture arbitration, and
matched geometry all expose the same architectural need: several otherwise independent spans must
participate in one interaction. The kernel adds one mechanism, not six retained widget trees.

A **coordination scope** is a manifest range plus one typed, sparse facet page. Descendant spans may
publish a protocol key, coordinates/relations, and references to facts they already own. The page
never copies element structure, text, geometry, semantics, or handlers:

```text
CoordinationScope = protocol type + scope span + generation + facet range
Facet             = domain key + owning SpanId + protocol-small data + fact ranges
```

The protocol reconciles old/new facet pages by domain key and may retain only its compact active
state—selection endpoints, grid anchor, gesture claims, dock drag, or matched-transition pair. A
public advanced `Protocol` contract lets libraries define facet data, reconciliation, input routing,
semantics, and eviction/cancellation policy. Pages are SoA, byte-accounted, generation-checked, and
leased by the scope. The contract forbids a private element tree, renderer scene, scheduler, or
identity namespace; it refers back to canonical manifest facts. Ordinary users see focused
constructors, not the trait.

```rust,ignore
selectable_text(article(&self.blocks));
virtual_grid(&self.rows, &self.columns).cell(Self::cell);
outline(&self.nodes).expanded(&self.expanded).row(Self::outline_row);
dock(&self.layout).panel(Self::panel);
```

These borrow ordinary domain data for the current turn and accept ordinary `Ui` row/cell/panel
functions. Keys come from the domain values; none retains the slice, closure, or a widget object per
item. Specialized methods add frozen axes, extents, semantics, and policy only where needed.

This one mechanism supports the missing product primitives:

- `selectable_text(content)` collects descendant text-source ranges in manifested reading order.
  A selection endpoint is `(TextFactId, source-unit offset, affinity)`, so a drag may start in one
  label and end many elements later. Hit testing maps geometry through shaped cluster/source maps;
  copy traverses the ordered source ranges and emits their verbatim text with declared separators,
  never OCRs glyphs or concatenates accessibility labels. Bidi, hidden text, generated decoration,
  object replacements, and UTF-8/UTF-16 platform conversion have explicit policies. Only the two
  endpoint records and highlighted paint ranges are active state.
- `virtual_grid(rows, columns)` is a two-dimensional range coordinator, not nested virtual lists.
  Cells publish typed row/column keys, spans, and semantics; row/column extent maps answer visible
  bands, frozen rows/columns are additional placements of the same facts, and arrow/Page/Home/End
  navigation follows the sparse cell topology. Resize/reorder changes one axis map. Merged cells
  declare covered coordinates and must have one semantic owner. No offscreen cell component/layout/
  paint record exists.
- `outline(nodes)` owns a keyed visible projection `(node key, parent key, depth, expansion state)`,
  while the hierarchy remains application data. Expanding inserts projected keys; the extent map
  preserves the scroll anchor by key and offset, focus follows key rather than row number, and
  semantics expose level/expanded/set position from the same projection. Drag reorder uses the same
  typed keys and gesture protocol.
- `dock(layout)` treats `DockLayout<PanelId>` as serializable domain state and projects its split/tab/
  floating topology into the elastic spine and placement facts. Tab drag, split previews, merge,
  float/native-surface promotion, focus restoration, and persistence share panel ids; there is no
  second private docking tree. The library is substantial, but its only runtime privilege is the
  public coordination/placement/gesture contract.
- `gestures()` installs recognizers into one hit-scope arena. Recognizers observe the same pointer
  stream, move through Possible/Accepted/Rejected/Cancelled, and declare precedence, simultaneity,
  capture, and slop. Scroll, drag, swipe, long-press, pinch, and rotate use this arbitration; only
  winners may commit effects, losers receive cancellation, and momentum becomes an output-owned
  motion. A custom recognizer implements one trait instead of replacing input dispatch.
- `.matched(key)` publishes old/new geometry and paint-chunk facets inside a transition scope. The
  coordinator retains the outgoing chunk for a bounded lease, pairs it with the incoming span, and
  runs FLIP-style placement/clip/opacity motion without preserving either application tree. Missing,
  duplicate, incompatible-surface, or reduced-motion cases take an explicit fallback.

The manifest is therefore locally produced but not locally blind. Cross-element capabilities pay
only for sparse indexes they request, and all of them reuse span identity, facts, damage, semantics,
activities, virtual time, memory leases, and the from-scratch oracle. This is the composition seam
that lets third-party libraries build browser-class protocols without private runtime access.

Virtual text does not become secretly resident to make selection work. A virtual collection keeps
logical key/order/extent summaries; selection-driven autoscroll materializes encountered rows, and a
copy requests text-only lowering of the selected keyed range through the same borrowed row function
used for paint/semantics. The copy is assembled during that synchronous owner turn and owns only the
clipboard result. A remote `VirtualSource` can copy only loaded text or expose an explicit async
export activity—platform clipboard activation rules make “await arbitrary unloaded data after
Cmd-C” impossible to promise generically.

## 8. Interaction has explicit fast and expressive tiers

Hover demonstrates the principle. The common presentation-only path compiles a variant; the
application description never runs:

```rust,ignore
button("Open").hovered(paint().background(theme::hover()))
```

Style fields have generated internal impact bits: composite, paint, shape, layout, protocol.
`PaintStyle` accepts only composite/paint fields, so `.hovered(...)` is compile-time fast-path
framing. Pointer crossing swaps a variant style id, reuses geometry/shaping, re-encodes or selects
one position-independent chunk, and damages old/new ink.

Less common tiers are named honestly:

```rust,ignore
control.hovered_layout(style().padding(6))       // scoped layout; no view call
control.on_hover_change(Editor::hover_changed)   // arbitrary owner mutation; reruns view
```

The layout tier reuses already emitted children. Under proven containment it runs that local layout/
prepaint/paint span; otherwise `ReflowAncestor` walks the recorded parent route and may lay out
affected siblings, still without calling `view`. Shape-affecting fields reshape the affected text
span. The mutation tier may restructure arbitrary Rust and therefore pays owner
invalidation. Pressed, focus, caret, scroll transforms, and simple motion use the same finite
presentation protocol rather than a general hidden reactive tree.

Required paint-hover gate: zero `view`/region calls, zero layout nodes, zero shaping, and damage equal to
conservatively expanded old/new ink. Group hover links explicit spans and obeys the same rule—no
global string lookup. Report p50/p99 beside zgui's recorded 202 µs hover fixture rather than treating
that number as portable proof. Report first crossing (which may encode one chunk) separately from a
prewarmed/repeated crossing; idle prewarm competes under the normal memory budget.

### Focus and keyboard control are one production protocol

Focus is not component state. Standard focusable elements register their behavior automatically,
and the interaction runtime owns the focused semantic id, focus-visible state, traversal order, IME
session, restoration, and cancellation. There is no `Focus` field and no `.track_focus(...)` call.
The typeahead names `TypeaheadId::Input` because it deliberately exposes that target to hosts/tests;
tab traversal and click-to-focus themselves need no id or application bookkeeping. Focus paint uses a
compiled `.focused(PaintStyle)` variant and does not rerun application description.

The explicit tools describe intent rather than tracking machinery:

```rust,ignore
let search = text_input(&self.query);
let find = button("Find").focuses(&search);

dialog()
    .focus_scope()
    .initial_focus(&search)
    .child(search)
    .child(find)

list().focus_group(Axis::Vertical) // arrows, Home/End, typeahead, roving tab stop
```

The lexical target is site-relative by construction, so reusable libraries cannot collide.
Dynamic rows use their already-required domain key. A `TargetHandle` is minted only for a target that must cross a site or
survive restructuring; it is generational and fails safely after removal. Custom controls implement
one narrow `FocusBehavior`/semantic contract for traversal, activation, selection, and IME. Merely
rendering a custom primitive does not make it keyboard accessible.

Dynamic accessibility uses the same semantic diff. `status(message).live(Polite)` and
`alert(error).live(Assertive)` publish live-region records; a changed semantic text generation is
announced once after the successful turn, while reuse, retry, and hidden fallback do not duplicate
it. A nonvisual event may return `Announce::polite(text)` as an ordinary typed effect. Tests inspect
the platform-neutral announcement queue synchronously, and platform adapters map it to native live
region/notification APIs with deduplication and privacy redaction.

The common shortcut belongs to the control it invokes:

```rust,ignore
menu_item("Save")
    .on_select(Editor::save)
    .key(Key::S.primary())
    .searchable();

editor_surface()
    .on_key(Key::Escape, Editor::dismiss)
    .on_key(Key::K.primary().then(Key::S.primary()), Editor::save_all);
```

`.key(...)` adds an alternate gesture to the element's already typed primary handler; it does not
create a command object, second callback, action struct, context string, or registry entry. The
shortcut automatically shares the control's enabled state, focus scope, label, accessibility action,
menu presentation, inspector route, and test identity. `.searchable()` admits that same invoker to
the command palette. A toolbar and menu may both call `Editor::save`; ordinary Rust method typing is
the common reuse mechanism. An action without a visible control binds directly with `.on_key` on
the narrowest owning scope.

This takes the best common-path property of [SwiftUI's control-attached shortcut](https://developer.apple.com/documentation/swiftui/view/keyboardshortcut%28_%3A%29)
without inheriting a separate command declaration, while preserving the focus-first precedence that
large applications need. [Compose's defaults](https://developer.android.com/develop/ui/compose/touch-input/keyboard-input/commands)
reinforce that standard text, selection, scroll, and activation keys belong to controls rather than
application callbacks.

`Key`, `Modifiers`, `Chord`, and multi-stroke `Sequence` are typed values. `Key` means the logical
character/named key a user intends; `Code` is an explicitly physical keyboard position for games or
hardware-shaped bindings. `.primary()` resolves to the platform convention, preserves AltGr/dead
key and IME input, and distinguishes press, repeat, and release where a control asks for them. Tests
normally use
`app.key(Key::S.primary())` to exercise routing or invoke the semantic control by label; neither path
names a command type. Menus display the effective shortcut automatically.

Only software that promises user-remappable persistent bindings or a global automation surface pays
for stable action identity. Such a library/app explicitly exports an existing invoker at its setup
boundary, for example `actions.export("editor.save", "Save", Editor::save)`. The string is honest:
JSON settings, migration aliases, documentation, and plugins require a stable external name that
Rust's method pointers cannot supply. Export validates the method receiver/signature once, diagnoses
duplicate names, and feeds remapping, palette, menus, automation, and schema generation. It is not
required for a normal shortcut. This keeps [Zed's powerful remappable actions and contextual
precedence](https://zed.dev/docs/key-bindings) available without imposing its action declarations on
every application.

Routing is deterministic: platform/IME handling, focused control, focus group, focus scope,
component ancestors, then window/application bindings. Built-in controls ship typed Activate,
Move, Select, Expand, Dismiss, and Scroll behavior, so complete keyboard operation is a production
feature rather than a test shim. Tests exercise the same focus table and invoker route synchronously;
the inspector shows why a chord won, lost, or was intercepted. Static conflict/unreachable-binding
checks run where possible, while platform layout, IME, and user-remap conflicts remain runtime
diagnostics.

Eligible resident scroll changes only a transform/clip and exposed-band damage. Sticky descendants,
scroll-linked effects, selection/autoscroll, variable extents, fixed backgrounds, nested scroll,
and scrollbar changes declare additional patch/reflow/range work rather than entering that fast
class accidentally. The ordinary scalable boundary is the synchronous borrowed adaptor shown in §2:

```rust,ignore
virtual_list(&column.cards)
    .key(Card::id)
    .row(Board::card)
    .estimate_height(88)
```

During the call, the adaptor reads the currently requested range from the internal draft, compares
stable keys/revisions, invokes the row function for only required work, and appends borrowed
current-pass `Ui<'a>` records. Lowering canonicalizes any fact that must survive. The runtime retains
measured/estimated extents, anchors, and output spans—not
`&column.cards` or the row closure. Resident scroll is purely presentation-owned. An entering band
dirties the smallest value owner, whose cheap description recreates the slice access. A first-pass
range correction may cause one bounded same-frame re-entry. This admits a few microseconds of honest
Rust description in exchange for deleting a request/reply protocol, cross-frame snapshot contract,
revision retry loop, and duplicate semantics callback.

Semantics are obtained by lowering the same row element with paint disabled. An accessibility-only
range therefore cannot disagree with the visible row, and interactive virtual rows require only a
stable key. Variable-height measurement, extent summaries, anchor correction, overscan priority,
and stale-range cancellation are runtime facts tied to that key and owner revision. A change during
description simply schedules the next owner revision; no borrowed reply can publish late.

Only non-resident data needs an advanced contract. `VirtualSource` returns owned, keyed pages with
an exact source revision and may satisfy visual or semantic ranges from a database/worker. It is a
specialized source and uses the same task/activity/cancellation machinery as any other remote work,
not the API every `Vec<Card>` must implement. Eligible isolated scroll/video
regions may promote to platform compositor surfaces, with ordinary packet/damage fallback. Native
promotion is an optimization, not the semantics: z-order, transparency, filters, HDR, memory, and
platform capability can forbid it. Report translation-scroll p50/p99 beside zgui's recorded 44 µs
fixture and distinguish resident transform work from exposed-band row work.

Portals carry logical parent, anchor target, focus scope, dismiss policy, semantic parent, z-band, and
target surface. Menus that must escape window bounds may use an auxiliary native surface while
remaining one logical protocol. Arbitrary placement starts as a small relation list and promotes to
a graph only at measured scale; cycles are located errors.

## 9. Layout, text, damage, and renderer integration are the main event

### Layout and resize

The runtime implements Taffy's partial-tree adapter over current manifest spans or replaces Taffy
behind that boundary. It caches exact intrinsic subproblems, not blindly permanent Taffy nodes:

```text
layout/style opcode + child intrinsic fingerprints
+ exact available space + scale/font/locale/direction revisions
```

Final geometry reuses only when sibling flex/grid, baselines, percentages, alignment, and all other
container inputs match. A compact persistent layout pool is permitted if benchmarks beat the
manifest adapter; retaining that expensive fact does not imply retaining every element or property.

Resize has explicit specialization:

- fixed subtrees with unchanged constraints reuse description, geometry, shape, and paint exactly;
- dock/split/pane shells use a tiny one-dimensional elastic-spine solver with cached content boxes;
- shaped text survives width change; only line breaking and affected ancestors rerun;
- documents rebreak visible paragraphs first and retain offscreen extent summaries;
- live resize may anchor/stretch the last valid frame while the newest-size settle pass runs,
  dropping obsolete intermediate sizes; final geometry is never quantized.

The gate is proportional work: resizing a fixed-sidebar/elastic-content fixture leaves sidebar
description and paint byte-identical and recomputes only the elastic path.

Container queries use the same layout-impact route rather than a ResizeObserver-style callback.
`.container()` assigns the nearest anonymous query scope; `.when_width(range, style)` installs
preclassified style variants on descendants. Layout solves the container, selects variants, and
reruns only the affected contained subproblem. The solver requires a stable fixed point, detects an
oscillating variant cycle, reports the participating fields, and falls back conservatively. A query
cannot mutate application state or arbitrary structure; source-dependent structural replacement
uses a region. This seals layout feedback into one bounded protocol instead of creating
layout→callback→owner→layout turns.

Theme tokens remain late-bound but are indexed. Paint records store compact palette slots; a theme
swap updates the palette/uniform generation and damages only the ink ranges whose resolved token
changed, without description, layout, shaping, or chunk re-encode. Backends that can index a palette
in shaders update one buffer; others replay the same chunks with new resolved colors. Geometry-
affecting theme tokens are classified separately and take the recorded layout route. The theme gate
includes a 10k-consumer swap and counts fanout walk, upload, damage, and redraw rather than hiding a
full repaint behind “late bound.”

### Text

Text is a first-class retained fact with split keys:

```text
ShapingKey = text identity/revision + shaping style runs + bidi/script/language
             + font database revision + scale
WrapKey    = shaped paragraph id + exact width + break/hyphenation/max-line policy
```

One shaped paragraph owns glyphs, clusters, source maps, and ink. Wrap results own breaks/extents.
Local rope edits reshape the minimal script/bidi-safe range. Raster scratch is thread/frame-local
and allocation-free after growth. Editors may expose specialized snapshots, range units, IME maps,
selection revisions, and text history; that expertise does not become a universal application
delta system.

“Minimal safe” is a proof result, not an assumption. Uncertain script/bidi/font-fallback boundaries
escalate to the whole paragraph, and pathological document protocols may escalate further. Full
paragraph/document shaping remains the correctness oracle.

### Damage and pixels

Stable paint chunks carry conservative ink bounds. Diff rules are exact:

- identical content/placement/clip/composite/asset/color generation: no damage;
- translated identical chunk: old/new bounds or exposed scroll band;
- changed chunk: union of old/new ink;
- unknown blend/filter/backdrop dependency: isolation group or conservative promotion.

Partial replay emits every ordered contributor intersecting damage, not only changed chunks. Opaque
regions can prove front-to-back culling; unknown alpha, rounded antialiasing, filters, and backdrops
decline the proof. A from-scratch renderer and pixel oracle validate every optimization.

Presentation pixels are adaptive. A window receives a full target, sparse tiles, or no cache based
on damage/cadence/backend support and the shared byte budget. The cold frame draws directly to the
drawable. Swapchain preservation is never assumed.

### GPU and custom renderers

The manifest keeps typed primitive streams and a compact `PaintOrder { kind, index }`; it does not
clone every primitive into a second enum stream. Renderer frontends consume typed slices, shared
transform/clip/style tables, packet ranges, damage, and generational asset handles directly.
They may lower to Metal/Vulkan/D3D/WebGPU/native backends without rebuilding a generic scene.

Uploads and atlases are generation-tracked leases. Device loss invalidates residency, not CPU
facts. Packet pages remain immutable until their fence retires under hard byte/count limits.
Backpressure blocks or drops obsolete frames according to explicit policy; it never grows an
unbounded “previous scene” queue.

Custom primitives declare intrinsic/layout input, conservative paint bounds, hit/semantic output,
asset dependencies, damage behavior, and backend fallback through one focused contract:

```rust,ignore
trait Primitive: 'static {
    type Params: ShaderParams;

    fn bounds(&self, params: &Self::Params, layout: &LayoutFacts) -> Bounds;
    fn prepare(&self, params: &Self::Params, assets: &mut PrepareAssets);
    fn encode(&self, params: &Self::Params, pass: &mut PrimitivePass);
    fn fallback<'a>(&'a self, params: &'a Self::Params) -> Ui<'a>;
}
```

`ShaderParams` is a typed packed parameter block with generated field impact, not a closure called
per primitive per frame. A value, direct source binding, or motion may feed a declared field. Uniform-only changes
write one upload slice and damage the primitive bounds; pipeline keys, geometry, and unrelated
primitives survive. Layout-affecting parameters must say so and begin at layout. Pipeline creation,
reflection, and backend specialization are cached by primitive type + shader generation and charged
to the asset ledger. This lets a custom editor/canvas hit the renderer's fastest lanes without
inventing a second scheduler or scene.

### Motion is a presentation program, not repeated description code

The useful idea in Skeary's [tiny motion library](https://skeary.me/blog/motion) is not JavaScript
syntax; it is that one resumable motion protocol plus sequential/concurrent composition is enough.
Stable Rust can express the same kernel as a pollable value:

```rust,ignore
trait Motion: 'static {
    fn sample(&mut self, frame: MotionFrame, out: &mut MotionOutput) -> MotionStatus;
}

card.animate(sequence((
    delay(80.ms()),
    fade_to(1.0, 120.ms()),
    all((
        move_to(target, spring()),
        scale_to(1.0, 180.ms().ease_out()),
    )),
)))
```

`sequence`, `all`, `race`, `repeat`, `delay`, `tween`, and `spring` are ordinary values and
combinators over that one trait. A library can implement `Motion`; applications normally compose
built-ins. The runtime samples an active motion once per presentation frame and writes its outputs
directly to typed transform, opacity, color, clip, scroll, or shader-uniform slots. No view or source
region, layout, shaping, or command re-encode runs unless the target's generated impact requires it.
Interrupt/retarget/hold/reduced-motion policies are data on the motion, and completion is one typed
effect—not a per-frame callback.

The concise common cases stay on elements:

```rust,ignore
panel.transition(transform(), spring());
toast.enter(fade_in(120.ms()).with(slide_y(8, 160.ms())));
progress.value(&progress).transition(fill(), linear(80.ms()));
```

`animate_layout(...)` is the visibly expensive spelling for a changing layout field. Arbitrary
structural animation uses a source region or a custom `Motion`, making the tier change explicit.
Motion state is one compact active program per animation—not one signal per property—and completed
programs disappear. Tests and the inspector drive the same virtual clock and can sample any exact
time without sleeping.

A held structural transition is a small coordinator over two ordinary spans, not another component
lifecycle. `switch(key, content).hold_while(activity)` keeps the last committed span interactive
while the incoming activity is pending, then atomically publishes the new span and applies ordinary
enter/exit or `.matched(key)` motion. Superseding keys cancel stale work; failure/cancel policy says
keep, replace with fallback, or reveal the error. Old spans have a time/byte lease and cannot be held
indefinitely. This gives route/tab switches immediate feedback without teaching every screen a
loading-state mirror.

### Images and media use assets, not application resources

An `Asset<T>` is an immutable, content-addressable fact with acquisition, decoding, residency,
generation, and byte leases. File paths, encoded bytes, URLs, SVGs, platform images, and generated
pixels normalize to `Asset<Image>`; fonts and compiled shader modules use the same cache/lease
contract. This removes per-widget decoded copies without pretending a save operation is an image:

```rust,ignore
image(assets.image("avatars/miles.avif"))
    .fit(ContentFit::Cover)
    .decode_at(layout_size())
    .placeholder(avatar_skeleton())
```

Visibility starts decode/upload; the requested device scale and display size select a bounded
decode level; encoded bytes, decoded planes, atlas placement, upload staging, and GPU residency are
separately accounted and independently evictable. Identical content across windows shares CPU
facts, while each device generation owns only necessary residency. Progressive images replace
generations atomically. Cropping/placement is a transform/UV edit, color conversion is explicit,
and custom image effects are typed primitives so animation updates uniforms rather than rebuilding
the image tree.

Continuous playback is a `MediaSession<T>`, not an `Asset<T>`. A session is pull-driven by its audio
or presentation clock and owns bounded compressed, decoded, resampler, and device queues with
explicit low/high water marks. Seeking or changing tracks advances its generation and cancels stale
range requests and decodes. It never needs to retain a whole remote file, whole decoded track, or
unbounded frame history.

The source and playback policy are separate and reusable:

```rust,ignore
let player = audio(
    remote(track.url.clone())
        .headers(auth_headers())
        .cache(cache::sparse_content_addressed()),
)
.output(AudioOutput::device_rate_and_channels())
.compressed_window(2.mib())
.pcm_window(350.ms())
.prefetch(Prefetch::NextMetadataAndHead);

player_view()
    .title(&track.title)
    .position(&player.position)
    .buffered(&player.buffered)
    .artwork(
        image(track.artwork.clone())
            .decode_at(artwork_box())
            .quality(ImageQuality::Balanced),
    );
```

`MediaSource` supplies metadata and cancellable byte ranges with validators, priority, retry, and
backpressure. HTTP range support uses a sparse disk cache rather than a RAM mirror; servers without
ranges degrade to one bounded sequential stream and make random seek honestly expensive. Live
streams use the same bounded queue without pretending to have a content length. Authentication and
URL refresh live in the source service, not in every player widget. The UI observes only tiny
position/buffer/state sources, so a display-rate progress update patches scalar output slots.

The media byte ledger counts compressed network windows, demux packets, decoded PCM/video planes,
resampler state, device buffers, upload staging, artwork decode levels, and GPU/imported residency
separately. Current playback is protected; next-track prefetch, waveform work, background video, and
artwork compete by benefit per byte and are the first leases revoked. OS/driver buffers that cannot
be controlled are estimated and shown separately instead of being hidden. Gapless playback may pin
the tail of the current track plus the head of the next, but not two entire decoded tracks.

Audio decodes toward the negotiated device sample rate, channel layout, and sample format, then
resamples incrementally. Waveforms and spectra store bounded multiresolution peak/energy summaries,
never PCM. Image requests carry target pixels, scale, crop, color space, and quality; codecs use
reduced-resolution decode when available, and the fallback full-resolution transient is charged and
immediately releasable. Only admitted resolution levels survive. Animated images lower to
`MediaSession<ImageFrame>` and retain a bounded frame window. Video imports platform planes/textures
when possible and uses compositor surfaces only when z-order, color, clipping, and memory policy
allow it; CPU copies are explicit fallback facts.

The music-player gate is resident bytes, not cache hit rhetoric: a library of 10,000 remote tracks
must scale with domain metadata plus active/recent byte windows and the admitted thumbnail budget,
not total encoded audio, decoded PCM, or original artwork. Tests cover range/no-range servers,
unknown lengths, rapid seek/skip cancellation, gapless overlap, memory pressure, background-window
floor mode, device-rate changes, and decode/downsample thrash. No API name erases the difference
between immutable content, finite acquisition work, and a clocked continuing session.

## 10. Work is named by lifecycle, not called “resource”

`Resource<T>` is deleted. It collapsed unrelated protocols and forced tests, inspectors, and
libraries to special-case an abstraction that meant too many things. The vocabulary is:

- `Task<T, E>`: one finite computation and one typed completion;
- `after`/`every`: site-owned scheduled effects routing typed time events, with no application timer state;
- `Latest<T, E>`: an owner-local finite-work slot with generation/cancel/debounce/last-good policy;
- `Asset<T>`: immutable acquired/decoded/resident data (§9);
- `MediaSession<T>` or an actor: an ordered continuing session with backpressure; and
- `Persist`: an opt-in domain capability for saving.

Tasks capture owned `Send + 'static` inputs and route completion to an owner method:

```rust,ignore
fn refresh(&mut self) -> Task {
    let api = self.api.clone();
    task(async move { api.fetch().await }, Self::refreshed)
}

fn refreshed(&mut self, result: Result<Data, FetchError>) {
    self.data = result.into();
}
```

`task(..., Self::refreshed)` infers and type-checks the completion receiver, then binds it to the
current owner route when the effect is returned. Launch is post-transaction;
completion is another automatic mutation boundary. `Latest<T, E>` is merely the reusable policy for
search/typeahead-style finite work; it is not the base async model and does not pretend to represent
images, streams, or persistence.

Optimistic work reuses the same finite-work generation and the reversible `Change<T>` contract used
by optional history; it does not introduce optimistic shadow state:

```rust,ignore
fn move_card(&mut self, drop: Drop<CardId, ColumnId>) -> impl IntoEffects<Self> {
    optimistic(
        drop.card,                         // conflict/latest key
        MoveCard::new(drop),               // exact apply + inverse
        board_api().move_card(drop),       // confirmation future
    )
}
```

The returned effect applies the change as the next owner transaction in the same turn, launches the
request, and retains only its inverse, conflict key, and base/optimistic revisions. Success drops the
inverse or applies an explicit canonical server change. Failure/cancellation reverts only if its
conflict generation is still current; a newer overlapping attempt follows the declared queue,
supersede, or rebase policy rather than allowing an old response to undo new work. `History` is not
required; when present, policy chooses commit-on-attempt or commit-on-confirmation. Inspector/tests
see an ordinary typed `Activity`, and the debug change oracle verifies apply/inverse/redo. Arbitrary
collaborative reconciliation remains domain work, but ticketing, latest-wins, and safe rollback are
not reimplemented per app.

### Saving is an opt-in capability

The common save pattern should not require `save_state`, ticket ids, a completion method, and the
same debounce code in every application. A domain opts in by implementing one trait:

```rust,ignore
trait Persist: Sized {
    type Snapshot: Send + 'static;
    type Error: Send + 'static;

    const POLICY: PersistPolicy = PersistPolicy::manual();

    fn snapshot(&self) -> Versioned<Self::Snapshot>;
    fn save(snapshot: Self::Snapshot)
        -> impl Future<Output = Result<(), Self::Error>> + Send;
}

impl Persist for Board {
    type Snapshot = BoardSnapshot;
    type Error = SaveError;

    const POLICY: PersistPolicy = PersistPolicy::after_change().debounce(250.ms());

    fn snapshot(&self) -> Versioned<BoardSnapshot> {
        self.persistence_revision.snapshot(|| BoardSnapshot::from(self))
    }

    fn save(snapshot: BoardSnapshot)
        -> impl Future<Output = Result<(), SaveError>> + Send
    {
        async move { board_api().save(snapshot).await }
    }
}

```

Rust cannot discover after monomorphization that an arbitrary `T` happens to implement another
trait. `.with_persistence()` on an owning app/component handle is the one explicit registration
point, and it exists only when `T: Persist`; it installs the lazily allocated capability record
while routed handlers still
receive `&mut Board`. There is no derive, inventory, or ambient context. After a configured `Board`
transaction, the runtime first compares the snapshot revision. Selection, hover, or
other transient mutations that do not advance it do no save work. A new persistent revision takes
one owned snapshot after the borrow, applies the declared debounce/coalescing/latest-wins policy,
and owns cancellation, error, retry, and dirty-during-save state. `SaveNow` is the explicit effect
for a Save button or a manual policy. `activity::<persist::Save<Board>>()` is the same typed
late-bound activity projection used by tests/inspection, so the toolbar can show
Saving/Saved/Error without a context parameter, duplicated field, or persistence-only status API.
Tests and the inspector see the same capability state.

This abstraction is deliberately not universal object serialization. Snapshot construction,
revision ownership, conflict handling, credentials, and remote semantics remain domain code. The
trait removes the universally repeated orchestration while keeping the meaningful choices explicit.
Owners that do not implement `Persist` have no persistence state or scheduler hook.

### One observational vocabulary

Every finite/continuing protocol publishes a compact `Activity` projection:

```text
Activity = owner + kind + generation + Scheduled|Running|Ready|Failed|Cancelled
           + start/end cause + byte/lease/work counters
```

`Task`, scheduled effects, `Latest`, `Asset`, `MediaSession`, `Persist`, motion, native surfaces, and custom sources keep their
strongly typed operational APIs; `Activity` is only their shared read-only UI/inspection/testing projection.
This is what replaces one-off concepts such as `expect_resource`. It gives tools one causal
language without weakening application types or forcing unlike lifecycles into one mega-object.

UI owners may be `!Send` and `!Sync`. Worker boundaries transfer owned values or explicit immutable
snapshots; `String`/`Rc` remain normal on the UI side. Long-lived bidirectional systems still use an
actor/source with explicit ordering and backpressure. Development/hot reload may discard output
caches but cannot use a different ownership or lowering model from release.

## 11. Testing and inspection are projections of the real machine

Tests use the same typed ids/keys/targets, semantic records, hit testing, dispatch, output diff, and presentation path
as production:

```rust,ignore
let mut app = TestApp::new(Counter::default());

// Zero-id black-box test through semantics.
app.button().named("Increment").click()?;
app.text().exact("Count: 1").expect(Present)?;

// Named white-box tests use the component's ordinary Rust id family.
app.get(SearchPageId::Find).click()?;
app.get(TypeaheadId::Input).expect(Focused)?;

// Dynamic identity remains the domain key, scoped by a typed/static or semantic ancestor.
app.within(BoardId::Columns).key(card_id).button().named("Delete").click()?;

// Keyboard and focus use the production protocol and remain synchronous.
app.key(Key::Tab)?;
app.button().named("Increment").expect(Focused)?;

// Async is explicit only where the application is async.
app.button().named("Save").click()?;
let save = app.activity::<persist::Activity<Board>>().running()?;
app.complete(save, Ok(()))?;
app.status().named("Save status").expect_text("Saved")?;
```

Role/name queries are accessibility-first black-box tests, not identity strings. Named white-box
locators are compile-checked `IdFor<Owner>` enum values; misspellings and cross-owner `.at(...)`
mistakes fail in Rust. Runtime operations still validate presence, uniqueness, actionability, and
role, producing the requested operation, actual state, source location, candidate semantic matches,
and shortest correction. `.alias("...")` is reserved for an explicitly external automation contract.

Tests are synchronous by default. `click`, keyboard input, owner transactions, description, layout,
paint, damage, and presentation run one deterministic turn and return. They do not silently await a
network response or advance time. `app.advance(250.ms())`, `app.complete(activity, value)`, and
`app.run_until(predicate, virtual_deadline)` explicitly drive clocks or framework-owned work. A
normal unit test therefore has no async runtime, `.await`, polling ceremony, or race with unrelated
tasks. An optional async adapter exists only for real integration tests that intentionally await an
opaque OS/network future.

The harness can deterministically drive only framework-owned virtual clocks/executors and injected
services. An opaque network/thread future is not magically controllable; tests replace it with a
fake/recorded service or accept a real-time integration boundary that the trace labels explicitly.

Every failure carries a bounded causal trace:

```text
locator/semantic query -> hit/actionability -> handler method -> owner/source revision
-> first changed span -> reuse decision -> layout/text/paint -> damage -> presented frame
```

First-class assertions cover capture cancellation, focus/IME survival, virtual semantics,
cross-element selection/copy, grid/outline navigation/anchors, gesture winners/cancellation,
dock restoration, matched motion, live announcements, fault fallback, undo/redo, touched
producers/spans, zero-description hover/scroll, layout/shaping counts, exact damage,
retained/reserved/source/facet bytes, native promotion, fences, and floor mode. Protocol lifecycle
uses the generic `activity::<CapabilityOrKind>()` query, so tasks, assets, persistence, media, motion,
and custom libraries do not grow separate `expect_*` methods.

The inspector joins five views: selected control and semantics; input-to-present timeline; CPU/GPU/
memory lanes; retained-byte ownership/pin tree; and owner/source/activity/history/protocol state.
Pixel picking and semantic selection resolve to the same compact span. “Why did this change?” shows
the first old/new fact and its producer. “Why is this retained?” follows the actual lease to its
byte owner. A span shows its typed id/key and coordination memberships; a protocol scope overlays
text order, grid/outline topology, gesture claims, or transition pairs and explains its last decision.
Owner passes and source regions appear in one timeline; a signal graph is visible only where one
exists.

Model inspection is opt-in and redactable. Source paths, type names, full traces, and snapshots live
in feature-gated side tables. Inspector transport copies a bounded snapshot and immediately unpins
the frame. The release flight recorder is a byte-bounded ring, not an accidental memory leak.

## 12. Undo and transactions are domain capabilities

**Superseded as authoring by [08-history.md](08-history.md) and [07 §15](07-the-ladder.md).**
What follows is the 04 decision record: opt-in `History`, `commit().replace` terminals,
gesture coalescing, Scope types, the oracle. 08 keeps those and adds the DAG, selective
`undo_node`, Sudden-Termination stores, origins, and the "no `Track` field required"
default. Do not implement 04's `Box<dyn Change>` as the common path — sealed `Delta`s
first.

Ordinary mutation has no history tax and handler results never mention history. A domain opts in by
implementing one capability trait and storing one track. Common reversible collection/field edits
do not require an edit struct, enum variant, or hand-written inverse:

```rust,ignore
trait Change<M>: 'static {
    fn apply(self: Box<Self>, model: &mut M) -> Box<dyn Change<M>>;
}

trait History<Scope = MainHistory>: Sized {
    fn history(&mut self) -> &mut Track<Self, Scope>;
}

impl History for Board {
    fn history(&mut self) -> &mut Track<Board> {
        &mut self.history
    }
}

// The terminal operation applies now and records its exact inverse.
self.commit("Rename column")
    .replace(move |board| &mut board.column_mut(id).title, title);
```

`commit(label)` returns a small, must-use builder borrowing the owner. A terminal `replace`,
`insert`, `remove`, `splice`, or `move_item` applies immediately and owns only the information needed
to reverse itself; forgetting the terminal is a compile-time unused-value warning plus a
must-use diagnostic, never a commit-on-drop side effect. `replace` captures a typed mutable selector
and uses `mem::replace` in both directions. A domain method such as `column_mut` may advance its
normal revision, so commit, undo, and redo invalidate rendering and persistence through the same
path.

Routed interaction carries an optional `EditGesture` token. A text focus/edit session, IME
composition, slider scrub, or drag supplies one stable token and an exact barrier at commit/cancel;
history commits inside it group by track + gesture automatically, and repeated `replace` terminals
coalesce by gesture origin id + terminal source location/value type while preserving the oldest
inverse and newest redo value. A click or
programmatic call is one commit. This is production interaction metadata already needed for capture
and cancellation, not a hidden application transaction. `.merge(domain_key)`, `.group(key)`, or
`.barrier()` exist only for domain/programmatic coalescing that intentionally differs from the
originating gesture.

`HistoryExt::commit`, `undo`, and `redo` exist only for types implementing `History`. A terminal
operation temporarily takes the track, applies the change to `self`, then stores the returned inverse, avoiding
a self/field double borrow. The default `Track` uses a small-object history arena and erases one
change per committed transaction, never per element or mutation. A dense editor commits a compact
`TextBatch`/range patch as one custom `Change<Editor>`; complex domain operations such as a
cross-column card move may likewise use one custom change. That trait is the optimized/non-common
path, not boilerplate required for renaming a field. Domains without natural inverses may choose an
explicit undo/redo pair or immutable COW checkpoint. External effects are never falsely “undone.”

The default scope is `MainHistory`; the `Scope` parameter permits independent document, canvas, or
inspector tracks on the same owner. A composition site may expose one scope to descendants, and a
generic Undo/Redo control resolves the nearest exposed track; a closer provider deliberately
overrides the parent. This follows [EtoileUI's](https://github.com/etoile/EtoileUI) useful undo-track
routing idea while keeping the capability opt-in and statically named. Normal application methods
can call `self.undo()` directly; `.with_history::<MainHistory>()` on an owning app/component handle
adds one sparse site route and exists only when its `T: History<MainHistory>`. A nested component
registered for the same scope deliberately shadows the ancestor. Libraries may emit a typed domain
edit or use the exposed scope without knowing the host's track
storage. Inspector and test access is the same typed capability projection, not a global undo
manager.

Grouping and coalescing are operations on the capability, not framework-wide transaction modes:

```rust,ignore
self.history_group("Move cards", |board| {
    board.commit("Remove card").apply(remove);
    board.commit("Insert card").apply(insert);
});

button("Undo").on_click(history::undo::<MainHistory>);
button("Redo").on_click(history::redo::<MainHistory>);
```

The closure is confined to an explicitly atomic/history-shaped operation; ordinary handlers remain
plain methods. Undo/redo advance normal owner and persistence revisions, so rendering and autosave
need no special integration.

When `Checkpoint` is available (`Clone + PartialEq` is the convenience implementation), debug builds
sample an undo oracle: checkpoint before, apply, inverse and compare, redo and compare, then publish
the verified after-state. Property tests randomize groups and sequences. Panic-atomic transactions
similarly require a domain checkpoint; they are not smuggled into every click.

## 13. Diagnostics and compile time are architecture

The common path has one cheap spelling. Errors speak in that spelling:

- a handler with the wrong receiver points at `.on_click` and prints accepted method signatures;
- an `&mut T` method is profiled/linted as owner-wide; an eligible hot method gets a code action to
  use `&T` plus a source publication, never a silent semantic rewrite;
- a broad `signal.get()` subscription points at the read and suggests `&signal`, `signal.bind(...)`,
  or `region(...)` according to whether the value, projection, or structure changes;
- a handler lowered outside its owner prints both owner types and the embedding boundary;
- `Component<T>::at(id)` with an `IdFor<U>` fails in Rust with both owner types; duplicate ids,
  aliases, keys, and targets print both sources and the smallest common site/key ancestor;
- a duplicate/cyclic id forwarding chain or conditionally absent id prints every declaration/
  publication hop;
- a relationship to an unembedded/moved/foreign-generation target points at the referenced
  element's constructor and consumer, while a repeated target without a key suggests the
  domain-key site;
- a repeated protocol-bearing loop explains where `.key(domain_id)` belongs;
- an invalid paint-only hover names the layout field and suggests `hovered_layout`;
- a stale custom source names the source/consumer/revision and sampled mismatch;
- a virtual interactive list missing `.key(...)` points at the row and explains protocol identity;
- a stale activity shows kind, owner, request/current generations, cause, and cancellation;
- a `SaveNow` effect on a non-`Persist` owner suggests the missing capability implementation;
- a coordination facet with duplicate keys, invalid grid span, outline parent cycle, gesture
  conflict, or unmatched transition prints the owning scope and all participating spans;
- a placement cycle prints the relation chain; and
- a partial-render mismatch identifies the first pixel/fact and conservative fallback.

`#[diagnostic::on_unimplemented]` and `trybuild` snapshots cover the counter, method handlers,
component outputs, typed ids/aliases, virtual list/grid/outline, source binding, region,
task/asset/persistence, history, motion, custom primitive, protocol facets, and worker ownership
errors. Framework generics stop at the builder
boundary; callbacks are erased on attachment; `Ui<'a>` is concrete and `impl Element + 'a` is explicit; no output
optimization requires a proc macro.

CI measures clean/incremental `cargo check`, rust-analyzer completion, peak rustc memory,
monomorphized items, binary text, source size, and diagnostic span quality on real applications.
The §1 counter is the hello-world budget.

Named compile-time fixtures make the guarantees legible rather than merely claiming “type safe”:
UTF-8/UTF-16/grapheme positions cannot mix; local/window/screen coordinates cannot mix; drag payload
and drop target types must agree; a virtual interactive row cannot omit its domain key; a typed id
cannot address the wrong component; paint-only hover cannot contain layout fields; shader parameters
must match their generated layout/paint/uniform impact; and a worker cannot capture a UI-local
owner/source. Runtime oracles cover the genuinely dynamic halves: conditional target presence,
container-query fixed points, semantic completeness, gesture arbitration, and partial rendering.

## 14. Complexity firewall

The kernel may contain only:

- owner/site/span ids and revisions;
- optional source ids and locally leased consumer edges;
- lexical target tokens, compact typed-id/forwarding records, optional interned external aliases,
  and protocol generations;
- sparse coordination-scope/facet pages referring to canonical span/fact ranges;
- compact manifest span ids;
- generational expensive-fact/asset handles; and
- explicit pin/lease reasons.

A feature may own behavior, emit/read a typed manifest section, pin a fact for a named reason, and
request scoped work/damage/presentation. It may not add another model world, permanent element tree,
semantic tree, renderer scene copy, scheduler epoch, test tree, or private identity namespace.

Hover, tasks/assets, persistence, history, portals, virtual collections, drag/gestures, docking,
selection, media, motion, and sources meet only at owner/source revisions, ids, spans, coordination
facets, semantics, effects, activities, and fact leases. A transition may retain old presentation chunks; undo may retain changes; a fence may retain
asset/packet pages. None becomes a second mutable application epoch. This is the architectural kill
switch against dying at 60% built.

Features land only with a replacement boundary and a net deletion/avoidance statement. A source
runtime that requires changes to layout, renderer ownership, testing identity, or component
lifecycle beyond the producer/span interface has violated the design.

## 15. Exact competitive trade

| Axis | Two-register GPUI | Leptos | zgui |
|---|---|---|---|
| Default state/API | Plain struct, one `View`, direct methods; no context/notify/reducer | Signals/resources/effects and macro-oriented views | Signals/components over a retained document |
| Optional locality | A source field, direct binding, or region only where justified; no component-mode switch | Fine-grained ownership is the normal application register | Dirty retained document paths/stages |
| Update discovery | Owner revision, source consumers, or output-owned protocol; cost visible from receiver/binding | Reactive dependency closure, often direct dynamic-hole update | Dirty document path with strong end-to-end locality |
| Static memory | Tape words and shared expensive facts; no source/node per static leaf | Reactive owners/nodes plus browser document/rendering | Retained document/style/box/fragment/hit/pixel facts |
| First draw | Append-only visible compile; no permanent leaf mount | Installs owners/signals/DOM; browser pipeline is mature | Builds persistent document/style/layout/fragment state |
| Best leaf update | Source-bound slot can match fine-grained systems; an ordinary owner transaction is intentionally broader | Excellent exact signal consumer | Excellent exact dirty stage/path |
| Libraries | Function, `Component<T: View>`, public protocol/fact/renderer seams, typed method routes | Mature component/context/resource ecosystem | Retained component/service ecosystem |
| Renderer control | Direct typed streams, fact sharing, damage, adaptive pixels, native import/surfaces | Browser boundary trades control for maturity | Purpose-built retained renderer integration |
| Testing | Compile-checked ids plus roles/keys/semantics/protocol and causal spans; strings only for explicit external aliases | DOM roles/attributes/selectors and mature tools | Retained ids/semantics and custom tools |
| Characteristic risk | A `view` owner grows too large; optional sources/protocol facets and new renderer machinery must stay sparse | Signal ownership/lifetime and static-vs-live mistakes | Metadata/duplication, invalidation, mount, retained-memory creep |

Against [**Leptos**](https://github.com/leptos-rs/leptos), this design concedes that an all-fine-grained application can discover a tiny
dependency closure more directly. It can match that locality only after opting the relevant
property/region into the source register. In exchange, ordinary applications allocate no reactive
owner/wire per dynamic field and reason about mutation exactly like Rust. The source tier must earn
its existence with editor/dashboard fixtures and must approach Leptos' component/resource
composability without requiring it globally.

The cadence comparison is direct rather than rhetorical: `View::view` repeats after `&mut Self`;
each binding/region repeats after source publication. A source-heavy component obtains mount-once-
in-practice behavior without a second trait. The proposal no longer asks one `render` method to feel
immediate while leaving the rerun cause invisible.

Against [**zgui**](https://github.com/zortax/zgui/blob/41727c1b7de2239642378d0a47ed8b302e6ce9c0/docs/performance.md), this design concedes that a mature retained document may have better warm constant
factors and update discovery. Its wager is lower static metadata, lower background/floor memory,
faster cold construction, singular text/scene facts, and deeper renderer specialization. If hover,
scroll, resize, shaping, damage, and allocation do not meet the output-stage gates, cheap value
description does not rescue the pitch.

The syntax can resemble **Iced/Xilem** because all use Rust to describe structure, but the ownership
contract differs. There is no root message/update reducer, `View<State, Action>` mapping, or public
build/rebuild/message/teardown plan protocol. Methods mutate their owner; a child is an owned
component; outputs route to methods; source bindings are optional. This is GPUI's direct local feel
with less ambient machinery, not compatibility with old GPUI and not Iced with different styling.

Against [**Xilem**](https://github.com/linebender/xilem/blob/7fe469d6bd1ddc486d406a6eb4f9e776b5ffe34d/xilem/ARCHITECTURE.md) specifically, this design gives up some compile-time structural specialization at
the public boundary: concrete `Ui` instructions and keyed rows use runtime opcodes/keys/revisions. In
exchange, applications do not implement or compose view-state/rebuild/teardown/message machinery,
and libraries do not lift actions through a type stack. Xilem can be exceptionally cheap when its
view construction and structural rebuild specialize well; this proposal can be cheaper when a
method changes one owner and the retained span/output stages reject everything below it. The keyed
and source paths must prove that advantage rather than relying on API aesthetics.

Compiler-centric systems such as Ripple demonstrate how pleasant static templates and direct holes
can be. This design reserves optional control-flow sugar but refuses to make a compiler the source
of ownership truth. The runtime interfaces—`View`, handler receivers, source observation/direct bindings, regions, and
producer spans—must remain usable and diagnosable without it.

### Expected performance envelope, before measurements

These are falsifiable estimates, not benchmark results:

| Workload | Expected relative position if the design is used well | Principal reason it could lose |
|---|---|---|
| Cold first interactive frame | Likely lower framework work than zgui/Xilem and a browser-backed Leptos app; same font/shader/decode physics | Scratch erasure, interning, pipeline setup, or layout can dominate; mature competitors may have better constants |
| Static/mostly-static resident memory | Target materially below zgui/Xilem and reactive DOM stacks because static leaves have no owner/widget/signal object and expensive facts are singular | Manifest topology, ids, caches, targets, allocators, and drivers may erase the theoretical saving |
| Broad ordinary owner mutation | Roughly Xilem-class; likely behind a well-partitioned zgui/Leptos signal update | `View` and lazy descriptors rerun for that owner even when downstream exact reuse succeeds |
| Revisioned keyed row edit | Target near zgui locality and ahead of eager whole-sequence construction; Xilem memo/sequence specialization may tie | Bad/missing domain revisions fall back to row work or comparison |
| Source-bound scalar or editor slot | Signal-discovery cost should be comparable to zgui/Leptos; direct native output patch should beat a structural rebuild | Source graph and conversion overhead can exceed a tiny owner rerun |
| Paint-only hover, resident scroll, transform/uniform motion | Strongest expected category: zero application description and direct damage/presentation patch; target below zgui's published fixture times, with compositor promotion approaching zero app CPU | First variant encode, hit testing, damage replay, driver submission, or invalid impact classification |
| Text edit and resize | Potentially strongest through one shaped-text owner, split wrap facts, visible-first rebreak, and source-bound editor slots | Text correctness and layout invalidation are the hardest implementation work; a competent existing pipeline may simply be better |
| Images/media | Similar first decode cost, lower duplicate CPU/GPU residency when sharing/eviction works | Codec/platform copies and GPU surfaces dominate; aggressive eviction can cause decode thrash |

The prediction is therefore not “always faster.” The value path should win simplicity, cold work,
and bytes; the source path should match fine-grained discovery where it is worth paying for; the
renderer-owned protocols should win the interactions users feel. If zgui still wins hover/scroll,
Xilem wins cold structural work, or the total memory ledger does not materially fall, the design has
not earned a superiority claim.

The precise hypothesis is:

> Value owners make most Rust UI simple enough; source fields/regions recover the higher locality ceiling;
> one aggressively compact retained output machine supplies the memory, text, renderer, and
> interaction advantages neither description strategy supplies alone.

## 16. Direct answers to the original objections

1. **Novelty belonged at the cheapest layer.** Value invalidation is intentionally boring. Most
   engineering and gates target singular text/layout/paint/media facts, renderer packets, damage,
   pixels, memory eviction, compositor paths, testing, and diagnostics. Live sources exist for
   workloads where description really is material, not as the headline for every app.
2. **Mount became the new frame.** Static leaves have no durable mount objects. Cold and warm use one
   append-only visible compiler; lazy ranges defer offscreen work; caches are opportunistic. Static
   ordinary typed plan structs are optional library code, never salvation. Behavior components retain a
   semantic site mount for lifecycle/protocol correctness; its cost is sparse, named, and gated.
3. **The two-tier cost model was invisible.** The owner trait and receiver now state cadence:
   `View::view` follows `&mut Owner`; `&Owner` handlers can publish only explicit sources. Direct
   bindings, projected bindings, regions, and renderer protocols have distinct spellings and profile
   lanes. There is no component-mode cliff. Tooling explains actual work, but correctness and the
   cost class are readable without it.
4. **Specification mass could kill the project.** The kernel has one owner/site/span/source/fact-
   lease join, one turn, compact downstream topology, and one sparse coordination-facet extension.
   Signals are deferred, native surfaces optional, and each output mechanism lands behind an oracle
   and stop gate. Selection/grid/outline/docking/gestures/matched motion must share the facet seam;
   no feature may invent parallel identity, trees, epochs, or schedulers.
5. **Borrow ergonomics would collapse precision.** Normal state mutation is unrestricted `&mut
   Self`, including non-`Clone` data and multi-field edits. It knowingly invalidates one owner.
   Fine precision is chosen through owned sources, not field drafts or wildcard escape hatches.
6. **Bespoke vocabulary blocked composition.** The common vocabulary is Rust struct/method/function,
   `Ui`, fluent elements, and `Component<T: View>`. `Signal`, `Source`, `History`, and
   `Persist` are opt-in capabilities whose output remains ordinary elements. `Task`, `Asset`,
   `MediaSession`, and `Activity` distinguish lifecycles instead of proliferating subsystem exceptions.
7. **`!Send` stayed annoying.** It remains an honest constraint. Tasks/snapshots cover owned
   request/response; actors cover long-lived bidirectional work. No sender complexity appears in
   the view/source API when it is not needed.
8. **Retention always costs memory.** Retention is selective, singular, byte-accounted, globally
   budgeted, and evictable. Floor mode proves correctness without output caches. Source metadata is
   absent in value-only apps and charged separately where enabled.
9. **Locality blocked product-scale coordination.** One sparse coordination-scope/facet protocol
   lets selection, grids, outlines, docking, gestures, and matched transitions index existing spans/
   facts across owners without building parallel retained trees or private library runtimes.

## 17. Delivery: falsify the wager in independent rungs

### Rung 0 — freeze baselines and memory truth

Capture current GPUI, the last commit plus relevant working-tree experiments, zgui's reproducible
fixtures, and a persistent-node prototype on:

1. a 9,000-word editor/docs surface with IME, cross-element selection/copy, bidi, undo, and long
   soft-wrapped paragraphs;
2. a 100k-row virtual interactive list plus a two-axis grid and expandable outline, with images,
   frozen bands, focus, accessibility, and async rows;
3. a kitchen-sink first window with fixed sidebar, elastic panes, menus, hover, filters, native
   surfaces, docking, gesture conflicts, matched transitions, and many hidden windows; and
4. a music library with 10,000 remote-track metadata rows, a bounded artwork grid, active playback,
   seek/skip churn, gapless next-track overlap, and range/no-range fake servers.

Record cold first pixel/interactive frame, character edit, caret, paint/layout/mutating hover,
resident/entering scroll, live resize, tab reveal, scale/theme, device loss, and churn. Count wall
time, allocations, allocator live/reserved/RSS, source graph bytes, upload bytes, targets, surfaces,
fence leases, and every scene/text copy. Land the from-scratch renderer and pixel/damage oracle.

### Rung 1 — prove only the owner/site/span UX

On the existing full-frame renderer, prototype `View::view(&self) -> Ui<'_>`, both method receivers,
the ordered turn protocol, description draft, `OwnerId/SiteId/SpanId`, single embedding,
`ComponentMap`, keyed rows, typed outputs, lexical targets, optional `#[derive(Id)]` owner enums/id
forwarding, external aliases, component fault boundaries, exact interaction cancellation, and the
synchronous test turn.
Add only enough deterministic driver/trace to see those contracts.

Exit only when:

- the counter has no context, listener closure, notification, action, or reducer;
- unrelated `match` arms return `Ui` directly with no finalization or per-leaf heap allocation;
- a controlled title is only `&str + Handler<String>`, with no input mirror or echo frame;
- typeahead has no host subscription closure/private message mapping;
- stateful `if`/loops have explicit `Option<Component<_>>`/`ComponentMap` lifetime, while stateless
  loops use lazy keyed rows;
- all framework-owned mutation enters exactly one owner/source transaction in the specified turn;
- the single `.on_click` spelling infers `fn(&mut T)` as owner-write and `fn(&T)` as source-write;
  accepted compile/error fixtures cover method items, capturing closures, event arguments, return
  effects, and ambiguous/wrong-owner signatures, while runtime traces prove the former calls `view`
  and the latter does not;
- owner/site mismatch, duplicate id/alias/key/target, missing virtual key, and handler errors have accepted diagnostics;
- `.initial_focus(&target)`/`.labels(&target)`/`.anchored_to(&target)` reject strings and targets from
  the wrong description lifetime, while `.id(...)` accepts only an id family and `.alias("...")` is
  explicitly external;
- compile-fail fixtures reject a missing id variant, wrong `Component::at` owner, and inner-child
  forwarding mismatch; located lowering fixtures reject wrong attachment/enclosing-export owners;
  rust-analyzer completion/go-to/rename/find-reference covers declaration, attachment, forwarding,
  tests, and a downstream crate;
- a conditionally absent named target declines without retargeting and reports its id/forwarding chain;
- a child panic publishes its fallback/last-good policy without corrupting draft/turn state;
- insertion/removal between press/release cancels and never retargets;
- the ordinary timer fixture drives `every(..., fn(&mut T, Tick))` through virtual time with one
  owner pass per delivered tick, automatic site cancellation, monotonic deadlines, and bounded
  missed-tick coalescing;
- built-in tab/arrow/activation traversal needs no owner focus field, while a control-attached typed
  shortcut invokes the same enabled semantic action in UI and synchronous tests; and
- source size, compile time, binary size, and owner-wide description lanes meet their budgets.

Stop here if the public model is not clearly better. No new output representation is needed to
falsify it.

### Rung 2 — prove one compact manifest and one memory ledger

Lower the value model into the minimum SoA manifest topology and adapt it back to one existing
full-frame renderer. Add the transient next/diff journal, owner/site/span/fact ids, shared tables,
exact page/fence leases, global live/reserved/GPU ledger, and near-zero-cache correctness path. Do
not add partial damage, native surfaces, signals, media, or generalized chunk dedup yet.

Exit only when:

- unchanged children invoke zero `view` methods from owner/site/environment revision checks;
- the three cold milestones are no slower than current GPUI/persistent prototype on the fixtures;
- stateless description is `<=16` bytes/leaf **and** total p50/p95 bytes/visible leaf beat the
  persistent prototype materially;
- the superseded manifest dies after adapter publication and only exact packet pages survive fences;
- all live/reserved/interner/driver-estimate bytes have owners and pressure lowers reserved bytes;
- device loss and eviction to almost no cache reconstruct a pixel/semantic-equivalent full frame;
  and
- the adapter's temporary duplication is counted and has a deletion plan before Rung 3.

### Rung 3 — prove text, paint order, and damage on one renderer

On the editor fixture and one backend, add one shaped-paragraph owner plus wrap entries, compact
`PaintOrder`, direct typed-stream consumption, conservative ink bounds, old/new manifest damage, and
full/tiled/no-pixel policy. Position-independent chunks start without content-addressed dedup;
admission/dedup is a later measured optimization.

Exit only when:

- shaping/wrap/source maps have one canonical CPU owner and bidi uncertainty escalates correctly;
- one-character edit and resize preserve unaffected shaping/raster facts;
- partial output matches the from-scratch oracle through alpha, clips, filters, backdrops, atlas
  eviction, stalled fences, scale/color changes, and device loss;
- packet/asset leases obey hard byte/count limits; and
- direct frontend plus removed scene copies wins net CPU and memory after adapter code is deleted.

### Rung 4 — prove the presentation fast path with hover only

Add generated impact classes, compact reverse routing, paint-only variants, exact damage, and the
mutating-hover escape. Do not add virtual scrolling, compositor promotion, or broad motion.

Exit only when:

- first and warm paint hover call zero application description/layout/shape and damage old/new ink only;
- group hover stays within explicitly linked spans;
- layout-affecting style is rejected by `PaintStyle` with a local diagnostic;
- mutating hover visibly takes the owner/source path; and
- p50/p99, encode work, allocations, and retained variant bytes are reported beside the zgui
  fixture.

Only then add `.hovered_layout`; it must prove containment or walk the recorded reflow ancestor path
and remain pixel-equivalent.

### Rung 5 — prove synchronous borrowed virtualization without a provider framework

Implement `virtual_list(&slice).key(...).row(...).estimate_height(...)`, lazy keyed row spans,
variable/estimated extent maps, anchor correction, semantics-only lowering of the same rows,
resident transform scroll, owner re-entry, and entering-band output on the 100k-row fixture. Do not
implement `VirtualSource` until an actually remote fixture requires it.

Exit only when:

- resident eligible scroll calls no application description/row/layout/shape;
- entering-band scroll reruns at most the smallest value owner, invokes row functions only for
  newly required/changed keys, and reports description plus all measurement/layout/paint work;
- changing counts/extents between owner revisions produces no stale rows or anchor jumps;
- offscreen accessibility materializes bounded semantic ranges; and
- no collection borrow/row closure survives lowering and every extent/overscan cache is byte-budgeted.

### Rung 6 — prove resize reuse and background memory

Add exact constraint reuse, elastic spine, viewport-first rebreak, opaque culling, arena trimming,
container-query variants, indexed theme tokens, and window floor mode. Native compositor promotion
is not required.

Exit only when:

- fixed-sidebar resize leaves its description/geometry/paint byte-identical;
- resize cost scales with the elastic/visible document area;
- container queries converge within the bound or diagnose/fallback on cycles without owner turns;
- a 10k-consumer theme swap calls no application description/layout/shape, patches one palette
  buffer where supported, and reports exact changed-token fanout/damage elsewhere;
- hidden-window bytes approach model/owners plus named protocol/source pins;
- reveal restores focus, IME, activities/assets, semantics, and pixels correctly; and
- benefit/byte eviction beats simple LRU without allowing high-water capacity to hide.

### Rung 7 — prove the cross-span coordination seam

Implement one sparse coordination scope/facet page and use it—without private runtime hooks—for
cross-element selection/copy, a two-axis virtual grid, a virtual outline, gesture arbitration,
matched geometry, and docking projection. Land one protocol at a time; each must reuse canonical
span/text/geometry/semantic facts and delete any prototype-specific tree/index before the next.

Exit only when:

- selection copies verbatim source text across independently styled/owned descendants through bidi,
  object replacements, hidden/generated text, reflow, and virtualization boundaries;
- the grid virtualizes both axes, freezes/reorders/resizes axes, navigates cells, and represents
  merged-cell semantics without offscreen cell objects;
- outline expansion inserting hundreds of rows preserves keyed focus/selection/scroll anchor and
  exposes correct level/expanded semantics;
- gesture competitions deterministically commit one winner/cancel losers across scroll/drag/swipe/
  pinch/long-press fixtures, including nested scopes and pointer loss;
- matched transitions pair old/new keyed spans, obey byte/time leases and reduced motion, and fall
  back safely across missing/duplicate/native-surface cases;
- dock split/merge/float/restore is ordinary serializable domain mutation over the public elastic-
  layout, placement, gesture, focus, native-surface, history, and persistence facilities; and
- a no-coordination screen allocates no facet pages, while each fixture's page/fact-reference bytes
  are separately budgeted and reconstruct from the ordinary manifest.

### Rung 8 — prove libraries, capabilities, assets, motion, and one renderer escape

Ship third-party-shaped typeahead, within-window menu/portal, kanban drag, `Persist` autosave,
scoped document `History`, decoded/evicted `Asset<Image>`, the bounded remote-audio `MediaSession`, a
latest-wins optimistic change, held route transition, composable presentation motion, live-region
announcement, and a custom GPU canvas using only public facilities. Add
deterministic activity generations, the undo oracle, injected services, custom-primitive fallback,
virtual-time motion tests, and one exported remappable action. The host carries no library-private
messages, polls no tasks, and gets the same accessibility/damage/memory/activity tools.

Exit only when:

- a library can expose function components, generic/erased slots, an owned component, a headless
  capability, and a custom primitive without private runtime hooks;
- ordinary tests remain synchronous and task/save/media tests drive only explicit activities/time;
- persistence coalesces by domain revision and no non-`Persist` owner allocates save state;
- optimistic conflicts never let a stale failure revert a newer change, and apply/inverse/reconcile
  pass the sampled oracle without requiring `History`;
- non-history owners allocate no track; common replace/collection commits need no custom change,
  while inverse/redo oracle and scoped track override pass;
- duplicate images share encoded/decoded facts as policy permits and eviction reconstructs them;
- remote playback stays within declared compressed/PCM/artwork budgets through seek/skip, no-range
  fallback, gapless overlap, pressure, and device-format change; library size never drives PCM bytes;
- direct shortcuts need no exported action, while the one explicitly exported name survives remap,
  alias migration, palette/menu/test invocation, and conflict diagnostics;
- transform/color/uniform motion calls zero application description, layout, and shaping work;
- held transitions retain only bounded old-span bytes and atomically choose success/failure/cancel;
- live announcements deduplicate across retry/reuse and use the production semantic queue; and
- custom shader uniform changes patch one typed upload/damage range without rebuilding a scene.

### Rung 9 — validate, but do not prematurely generalize, the source seam

Only after the value/output rungs pass, build the smallest `Signal`/direct-binding/
`region` prototype inside ordinary `Component<T: View>`
for the editor and one dense dashboard. It must use the existing owner/site/span/topology/output
protocol and delete no value-path optimization.

Exit only when:

- a value-only binary/runtime allocates no source graph records;
- a source-update storm calls owner `view` zero times, while an `&mut T` handler in the same component
  visibly runs one owner pass;
- a source-bound scalar patches its typed output slot without calling owner `view`;
- an `&T` editor handler reruns only dependent regions/direct consumers and has full task/output support;
- value field → source-bound property → source-publishing `&T` handler → region is incremental local
  code change, not an owner/widget rewrite;
- branch dependency swaps, panic rollback, cross-thread wakes, site removal, and generation reuse
  pass the observation oracle;
- value/source versions render and test identically under the full oracle;
- consumer edges disappear with spans and floor/eviction bytes are exact; and
- view/region/binding causes and time are separately visible in inspector/profile artifacts, and
  graph/build/compare time beats an owner pass on target workloads.

If the last gate fails, sources remain a narrow custom-renderer/asset binding seam. Native surfaces,
cross-window portals, broad remote virtualization, content-addressed whole-chunk
dedup, and collaboration remain separate post-rung proposals; success here does not widen the
kernel automatically.

## 18. Repository grounding

This greenfield proposal was checked against repository head `ef2746c7ee` plus the current working
tree on 2026-08-14. The current code is evidence about useful seams and duplication, not an API
compatibility constraint:

- current [`Render`](../../crates/gpui/src/element.rs) already returns `impl IntoElement`, confirming
  fluent ephemeral description as a viable seam; its `Window`/`Context<T>` parameters and
  `cx.listener`/`notify` contract are deliberately removed here;
- current [`Action`](../../crates/gpui/src/action.rs) and [`KeyBinding`](../../crates/gpui/src/keymap/binding.rs)
  require a separately declared/registered action plus parsed key/context strings for the fully
  remappable path; the greenfield common path instead treats a typed key as another gesture on an
  existing control/method and retains named export only for persistence/plugins;
- current [`ViewElement`](../../crates/gpui/src/view.rs) records accessed entity ids and reuses some
  paint ranges, proving behavior-owner boundaries are useful, but this proposal rejects arbitrary
  access witnesses in the value register;
- current [`uniform_list`](../../crates/gpui/src/elements/uniform_list.rs) owns a `'static` range
  provider, proving the need for exposed-band work; the new API deliberately trades provider
  retention for smallest-owner re-entry and a synchronous borrowed-slice adaptor;
- current [`LineLayout`/`WrappedLineLayout`](../../crates/gpui/src/text_system/line_layout.rs) split
  shaping from width-specific wrapping, a separation the new fact store should preserve;
- current [`Scene`](../../crates/gpui/src/scene.rs) stores typed primitive vectors and clones
  primitives into paint-order operations, providing a concrete duplication target for
  `PaintOrder { kind, index }`; and
- Taffy's partial-tree API supports the proposed adapter experiment but does not prove it faster
  than a compact retained layout pool.

## 19. Irreducible constraints and honest tradeoffs

These remain after the redesign:

- **Rust cannot observe arbitrary field mutation.** The runtime can guarantee invalidation only by
  owning every mutable entry boundary. Giving a method `&mut Owner` therefore dirties the whole
  owner. Zero-view precision requires explicit source publication, instrumentation, or a compiler;
  the design chooses explicit sources. Mutating a `Signal` from an `&mut T` method still takes the
  broad owner path because the receiver is the promise.
- **One trait does not erase two mutation costs.** `View` removes the owner-mode migration cliff, but
  authors still choose `&mut Self` owner invalidation or `&Self` source publication per method and
  fixed/source/region semantics per consumer. The spellings and profile lanes make that knowledge
  local; they cannot make it unnecessary.
- **`&self` is not a purity proof.** Hidden interior/global side effects in `View::view` or a region cannot
  be detected universally. Framework side effects are rejected there, sampled double-description
  catches some violations, and the contract keeps all application-visible effects in handlers,
  tasks, constructors, or lifecycle protocols.
- **Rust does not ergonomically overload closure arity.** Separate `on_click` and
  `on_click_event` names, plus a few generated method adapters, are simpler than a universal handler
  trait that produces inscrutable errors.
- **The handler's owning site is still checked at lowering.** Rust checks the method receiver and
  signature, but stable Rust cannot contextually type every `row()`/helper from the enclosing `View`
  implementation. Parameterizing `Ui` by owner/cadence would infect stateless helpers, unrelated
  branches, and library signatures with generics—the opposite of the shared concrete language. The
  erased adapter records `TypeId` + source location and the one embedding boundary produces a local
  diagnostic. A future UI compiler may strengthen this without changing the element API.
- **Concrete `Ui<'a>` preserves borrows by requiring synchronous lowering.** It needs no `.ui()` and
  no mandatory clone, but the runtime must finish canonicalization before releasing the owner borrow.
  Anything needed across frames becomes an owned/revisioned canonical fact at that boundary. A
  library that truly benefits from fully typed recording may return `impl Element + 'a`; the common
  `Ui<'a>` path pays compact opcode/range writes and limited erasure to control compile time and API
  complexity. That constant must be benchmarked, not declared free.
- **`Ui` is deliberately single-use.** A described range cannot be cloned and embedded twice; call
  the helper twice over shared domain/fact handles when two presentations are intended. This enables
  lexical `&Ui` relationships and prevents visual reuse from accidentally aliasing behavior, but it
  rules out treating constructed element syntax as reusable data.
- **The hidden draft is still ambient machinery.** It exposes no application capability and removes
  `cx` threading, but constructors must run inside a runtime description scope. Generation checks,
  panic cleanup, nested-scope behavior, and debug diagnostics are correctness requirements. A
  `Ui<'a>` cannot be retained beyond that scope. A long-lived plan is ordinary data implementing the
  advanced `Element` trait and records fresh instructions when used; the framework stores no syntax
  cache.
- **A no-argument tracked read needs an ambient collector or compiler.** `region(...)` scopes a
  thread-local collector on the UI executor; passing a source reference to a bindable property is
  the portable explicit boundary. Future `live!` sugar cannot become required for correctness.
- **A context-free description cannot branch on an ambient window value.** Common responsive variants and
  theme/scale effects must be late-bound output data. Arbitrary structural dependence uses an
  explicit environment source/region or a routed event stored in the owner. This is the price
  of eliminating invisible contextual dependencies.
- **Description values cannot borrow across frames.** Anything retained must be owned, interned,
  revisioned, or copied into a canonical fact. An entering virtual band therefore reruns the
  smallest owner to synchronously revisit its borrowed slice. This is simpler and lower-memory than a
  permanent provider, but broad owners pay some repeat description work.
- **A component has one active presentation.** Embedding the same behavior owner twice would make
  focus, IME, capture, inherited environment, output routes, and span ownership ambiguous. Two
  presentations use two components over an explicit shared model/source; this is a deliberate
  simplicity/memory trade.
- **Controlled state has no independent lifecycle.** A controlled library function borrows host
  data and routes edits back to that host; an owned component owns its state. Code that wants both
  must choose an explicit shared source/model rather than relying on prop reconciliation magic.
- **Live observation needs an advanced context.** Custom local/cross-thread sources implement a
  linearizable snapshot/version/wake protocol and dynamic regions maintain leased edge sets. This
  complexity is contained outside ordinary `View`, but it does not disappear.
- **Rust coherence limits universal source conversion.** Fixed `T`/`&T` and standard `&Signal<T>`
  inputs are direct, but a blanket conversion for every `&Source<Value = T>` overlaps the borrowed
  fixed-value case. A custom source/value pair may need one library-provided `Binding<T>` adapter;
  ordinary application properties do not pay that suffix.
- **Retained output needs topology.** Correct reflow/damage requires parent, child-range,
  containment, isolation, and reverse-impact indices. Flat SoA records are much smaller than a
  behavior/widget tree, not zero bytes.
- **`!Send` UI ownership is real.** Workers receive owned snapshots/messages. Long-lived
  bidirectional systems still need actors and backpressure.
- **Persistence must copy or transfer an immutable snapshot.** `Persist` removes scheduling/ticket
  boilerplate, not the cost of producing `Send + 'static` data. Large domains need COW, ropes,
  immutable pages, or an actor-owned model to keep snapshot cost proportional to change.
- **Rust does not discover capability traits dynamically.** An implementation enables methods and
  compile-time checks, but a runtime route/hook still needs one typed registration such as
  `.with_persistence()` or `.with_history::<Scope>()`. Hiding that with inventories/macros would
  violate the plain-Rust goal.
- **History remains domain work.** The trait makes capability, routing, grouping, and tooling
  uniform, and built-in field/collection terminals synthesize common inverses, but arbitrary domain
  semantics and memory representation cannot be inferred from ordinary mutation. Stored selectors/
  custom changes must be `'static`; compact editors still need range changes or checkpoints. Owners
  without the trait get no automatic undo.
- **Rust has no linear “builder must be consumed” types.** `commit(...)` can be `#[must_use]` and CI
  can deny that diagnostic, but phantom typestate cannot make dropping an unterminated builder a
  language type error. Terminals apply explicitly and never commit in `Drop`; the API must not claim
  a guarantee Rust cannot express.
- **Automatic focus cannot infer custom-control intent.** Standard controls need no focus field or
  tracking call, but a novel editor/canvas must expose semantics, traversal/activation behavior, and
  an IME contract. Dynamic restoration still needs a stable target/key; otherwise removal cancels focus
  rather than guessing a replacement.
- **Persistent remapping requires an external name.** Direct `.key(...)` and `.on_key(...)` routes
  are typed and unnamed, but JSON settings, plugins, automation, and migration aliases cannot point
  at a Rust method pointer across builds. Only applications exporting that surface pay for one
  namespaced string and registry record.
- **Media has irreducible buffers and quality/latency tradeoffs.** Codec, device, driver, gapless
  overlap, network jitter, and non-range servers impose a floor the framework cannot evict. Smaller
  decode windows reduce bytes but raise underrun/seek risk; aggressive image/audio downsampling saves
  residency at quality and CPU cost. The ledger exposes those choices rather than promising zero-copy
  on platforms that cannot provide it.
- **External aliases are still strings.** Automation protocols, persisted action
  names, and plugin schemas need stable human-facing names that Rust cannot derive across builds.
  Lexical `&Ui<'_>` relationships and `IdFor<Owner>` enums remove strings from in-process
  coordination/white-box tests, but they cannot replace those external contracts; aliases retain
  ambiguity diagnostics and scoped lookup.
- **Compile-time target identity cannot prove runtime presence.** Lexical `&Ui` covers relationships
  inside one description. Component-owned `IdFor<Owner>` enums and typed forwarding cover arbitrary
  private descendant depth and cross-site consumers without string lookup. Rust proves spelling and
  component ownership, but arbitrary `if`/loop control flow means it cannot prove presence in this
  materialization; nor does one enum variant have a distinct Rust type that can prove its semantic
  role. Presence/role decline safely with located diagnostics. Cross-frame storage still requires an
  explicit generational `TargetHandle`, and hot reload may safely retire its generation.
- **Typed ids use an optional derive.** `#[derive(Id)] #[owner(T)]` is item-level glue for the
  externally addressable minority, not UI/control-flow syntax. `IdFor<T>` is an unsafe representation/
  owner contract, so safe code cannot forge another owner's ids; the derive is the normal
  implementation. Macro expansion/LSP quality and diagnostic snapshots are release gates. A
  component that names nothing invokes no macro.
- **A local concrete `Ui` erases the target's element kind.** Rust proves that `&Ui` references the
  actual lexical element with the right lifetime, while semantic suitability (for example, an
  initial-focus target with no focus behavior) is validated during lowering with both source spans.
  The typed id family strengthens owner/spelling, not element-role typestate; ordinary construction
  does not pay typed-tree generics for every element.
- **Ordered effects can cycle.** Outputs/cross-owner calls drain after borrows and before the frame,
  but a parent/child feedback loop may never quiesce. The queue has a hard per-turn transaction
  bound and reports the causal route instead of spinning or presenting arbitrary intermediate state.
- **Signals consume memory and materialization time.** Every live source/consumer edge must be justified by
  work saved, locally leased, separately budgeted, and absent from value-only code. Fine-grained is
  a higher ceiling, not a free upgrade; a small component with many bindings can lose first paint
  and memory to a cheap owner pass even while winning leaf-update latency.
- **Coordination scopes are retained indexes.** They avoid parallel element trees but still consume
  keys, facet pages, adjacency/extents, and active protocol state. Grid/outline/docking libraries can
  be algorithmically large and must obey the same byte ledger, generation rules, public-trait
  firewall, and from-scratch oracle. One generic seam reduces kernel concepts; it does not make the
  product protocols trivial.
- **Container queries can cycle.** Restricting them to sealed style variants makes detection and
  bounded retry possible, not free. Oscillation must diagnose/fallback, and arbitrary structural
  feedback remains a source region or owner pass.
- **Fault boundaries depend on unwinding and isolation granularity.** They can atomically preserve/
  replace a child component or region span, not roll back arbitrary domain mutation, recover unsafe
  memory corruption, or catch panic-abort. Hostile native extensions need process isolation.
- **Presentation motion is finite in what it can skip.** Transform/color/uniform motion avoids application description
  and layout; layout-targeting motion must reflow, and structural motion needs a source/value producer.
  The API names these tiers but cannot make layout dependencies disappear.
- **First draw has physical dependencies.** Correct layout, shaping, filters, and native assets
  can require whole visible subproblems. The design removes framework bookkeeping; it cannot make
  those facts unnecessary.
- **Caches and compositor surfaces can lose.** Hashing, equality, indirection, backing memory,
  platform fragmentation, and fences may exceed saved work. Every one has admission, eviction,
  fallback, and a from-scratch oracle.
- **Direct mutation is not automatically undoable or panic-atomic.** Changes/checkpoints are
  focused domain work because correct inverse, persistence, collaboration, and external effects
  cannot be inferred.
- **Custom sources carry a correctness contract.** Revision mistakes can cause stale output. Debug
  sampled recomputation, leases, and precise diagnostics reduce but cannot type-prove semantic
  equality.
- **Two registers add knowledge.** The architecture now uses one `View` trait, but `&mut` values
  invalidate owners while sources invalidate consumers. If users routinely need to understand
  producer spans, leases, coordination facets, or renderer facts to build normal UI, the API has failed.

The final wager is less magical than either universal signals or universal rerendering: ordinary
Rust should cover most screens; explicit source fields/regions should cover exceptional update topology;
and the retained machine should spend the real ingenuity on text, layout, memory, damage, pixels,
testing, and renderer ownership. Everything else should be allowed to die.
