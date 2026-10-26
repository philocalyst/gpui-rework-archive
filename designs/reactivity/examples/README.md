# Migrated examples

Syntax sketches of `crates/gpui/examples` rewritten against the final API: [07-the-ladder.md](../07-the-ladder.md)
for semantics, updated by the spelling passes in [11-consolidations.md](../11-consolidations.md),
[12-example-review.md](../12-example-review.md), [13-composition.md](../13-composition.md),
[14-el-and-wires.md](../14-el-and-wires.md), [15-io-and-deltas.md](../15-io-and-deltas.md),
[16-changed.md](../16-changed.md), 17 (superseded before the corpus ever adopted it — 17's
`Out`/catcher machinery never landed here, so there is nothing in this directory to migrate FROM
17, only past it), and [18-state-is-the-protocol.md](../18-state-is-the-protocol.md) (18 wins any
conflict — it deletes `Output<E>`, `.emit`, `.fired()`, and embed functions outright, in favor of
child state observed through the recursive delta and `Handoff<T>` for consume-once occurrences;
16's `View::changed(&mut self, Changed<'_, Self>)` as the one reaction method survives unchanged,
and so does 15's deletion of 14 §3.3/§4's `Wired`/`Wires` trait). They are **not** expected to
compile against current GPUI.

Current sketches launch with the terse `Application::run(root)` (which accepts a bare `V: View`
or a configured `Window::document(v)....`); anything past one window drops to `Application::new()`
+ `app.open(...)` + `app.run()` with no rewrite. Tests use `Win::demo(root)` for the one-window
case (or `Application::demo()` for multi-window); each driver action commits a turn automatically
and returns a typed `Win<V>` with semantic assertions. There is no `Ui` test runtime, public
`settle`, string window lookup, `gpui::run` free function, `desktop()`, or event-loop-on-drop.

`Element` is a sealed trait; `El<'f>` is its concrete currency, and builders/components finish as
that ONE nominal type again (14 §1.2 revises 13 §4: opaque-by-default was tried and the corpus
rewrite falsified it). The standard view signature is `fn view(&self) -> El<'_>` — views are
branched on by definition, so they always name the concrete type — a builder borrowed for one
description turn over a per-turn arena (07 §2.1). A helper that is never branched over instead
takes the lifetime-hiding LEAF spelling, `impl Element` (borrowing: `impl Element + '_`) — no
lifetime to write out, and `El<'static>` all but disappears from the corpus as a result; a helper
that IS branched over (an enum-variant match, an if/else joining two different opaque helper
return types) names `El<'_>` so the arms unify with zero ceremony. `Styled`/`Container` remain as
bounds — `fn card<E: Styled>(e: E) -> E` — and `-> impl Element + Styled` still appears where a
helper specifically advertises restylability across an opaque return, but it no longer means
"open" as opposed to a "sealed" `El`: every finished element now carries the full `Styled`/
`Container` surface (per-kind method gating is retired), so `El<'_>` permits the identical
`.something()` chain too. Real encapsulation is a struct `View` embedded as a field — module
privacy, not a return type, is what actually hides a style surface (14 §1.2 point 4).

**There is no `el(…)` constructor.** Every sink (`.child`, container constructors, boundary
content, window roots) is already generic and seals implicitly, and same-shaped branches (`if`/
`match`/`Option`/iterators) over `El<'_>`, `impl Element`, or a mix already unify or type-check on
their own. The one place a join still needs a decision is two DIFFERENT opaque types meeting in
one expression — two different helper functions each returning their own `impl Element` — and the
fix there is to change one (or both) helpers' return type to `El<'_>`, not to reach for a wrapper;
`.into()` (`From<impl Element> for El<'f>`, plain std, zero cost) is reserved for the rare
cross-library accident, never for a call between two functions in this corpus.

Containers take children in the CONSTRUCTOR, always — `column((a, b, c)).gap(8)` — and the
`.children(…)` method is deleted (14 §2). The children ladder has three rungs, explicitness opt-in
exactly where it carries meaning (14 §2 item 3): a plain collection maps as an ordinary iterator in
constructor position (`column(self.log.iter().map(|line| text(line).text_xs()))`); when a `List<T>`
or `Vec<T>`'s rows ARE views (`T: View`, plain zero-arg `view`), the implicit form comes back —
`&list`/`&vec` implement `Children` directly and the delta wiring for `List` rides along invisibly
(`row(&self.tiles)`, the 80% spelling — interactive.rs's `Palette::view`); a chosen projection (a
non-view row, or an alternate method) is explicit, the named verb on the list itself,
`list.each(row_fn)` or `list.each_with(row_fn, ctx)` (`column(self.rows.each(Row::view))`) — the
splice/edit/move-preserving form the old `.children(collection, row_fn)` pair used to spell.
Widgets that already take a `(list, fn)` pair as constructor arguments (`tabs(&self.items, f)`,
`virtual_list(&rows)`, `popup(&self.hits, f)`) keep their existing widget signatures; this rule is
about generic containers (`column`/`row`/`div`/`grid`), not those.

Two children rules, not one (14 §2.1). Flow containers — `column(…)`, `row(…)`, `grid(…)` — are
unary: born WITH their children, because they exist to arrange them, so a zero-arg `column()`/
`row()` never appears in this corpus (a site with no children to arrange, or exactly one child that
needs no arrangement, is not a flow container). `div()` is the opposite primitive on purpose: the
styled box — spacers, swatches, panels, positioning canvases — and stays nullary; content is added
with `.child(x)`, the one child verb, one call per piece. `div(())` therefore never needs writing
and never appears here; a styled wrapper with one child is `div().child(content)`, and a genuine
multi-child styled box (an absolute-positioning canvas whose pieces are each already self-placed,
like blur.rs's root or pointer_follow.rs's `loupe()`) chains `.child(…)` once per piece rather than
fighting for a constructor arity `div()` cannot have.

The `Wired`/`Wires` trait (14 §3.3/§4) is gone (15 §5): it fixed *where* relationships were
registered, but it was still a third declarative surface, separate from a component's own
boundary. 15 first moved observation INTO the view, as `when(source, route)` children; 16 deleted
that surface too, in favor of one provided method on the one view trait — **`View::changed(&mut
self, Changed<'_, Self>)`**; 18 keeps that method and finalizes the trait around it. `view`
describes what a component *looks like*; `changed` describes what it *does about change* —
presentation and effects are sibling methods of one trait, not a separate wiring surface and not
children, so there is zero mixing between them (18 §6 gate 1: no reaction construct in any `view`
body in the corpus, no element construction in any `changed` body, no embed functions anywhere).

The reactive model is now enumerable on one hand (18 §5's "final surface"): a **struct** of state
— data, sources, `Handoff<T>` cells, `Target<K>`, nothing else, the field law closed; **`view`**,
presentation as a projection; **`changed`**, effects over the typed diff of the struct; **methods**,
commands routed from input events by fn item; plus two derives that add vocabulary, never
meaning — `#[derive(Delta)]` and the optional `#[reactive]`. Every file in this directory is built
from exactly those four items and two derives; nothing else is load-bearing.

First, **the subscription set is the field set** (18 §1). A component never needed to *subscribe*
to anything — 13 §5.1 already established that fields are sources — so there is nothing left to
declare: the kernel hands `changed` the turn's composed delta, typed to mirror the struct, read
with FIELD syntax throughout (18 §3, kept from 17): `&d.store.unread` — not `d.store.unread()` —
reaches through `Entity<MailStore>` into `MailStore`'s own `#[derive(Delta)]` delta (15 §3);
`d.composer.sent.take()` consumes a child's `Handoff<T>` occurrence, once, in order. Conditionals,
guards, and equality gates that used to need an `Option` child or a derived
`when(source.map(f), route)` wire are ordinary Rust over `c.old`/`c.new` in the handler body
instead — inbox.rs's `Inbox::changed` folds a mute-guarded chime, an inline equality-gated badge,
a health-transition announcement, and a taken child handoff into independent `if`s in one method,
none of them a declared edge.

Second, **state is the protocol** (18 §1–2) — outputs are deleted for the third and final time,
not moved, not renamed: no `Output<E>`, no `.emit`, no `.fired()`, no embed function, no catcher,
no `Msg` enum anywhere in the framework. What a component "reports," it always was a state
transition; say so in the type. A RESTING occurrence — one that should persist until something
else changes it — is a lifecycle enum in a `Signal` (18 §1's worked example: `Stage { Editing,
Sent(OutgoingMail), Discarded }`); a CONSUME-ONCE occurrence — the composer's send, typeahead's
pick, an admitted presence batch — is `Handoff<T>` (18 §2): a linear give/take SOURCE, journaled
like any other field, never an endpoint. The child gives (`self.sent.give(mail)` in
`Composer::send`); the parent takes, once, in its own `changed` (`d.composer.sent.take()` in
`Inbox::changed`) — taking IS the acknowledgement, so no ack ever travels the other way. Embeds
die entirely (18 §5): a struct component mounts as a plain field child again — `dialog(&self
.composer)`, never `dialog(composer(&self.composer, Inbox::mail_sent))` — and services drop their
constructor route too (`PresenceSession::connect(transport)` in workbench.rs takes no argument
beyond the transport; `Workbench::changed` takes `d.presence.applied` like any other child
handoff). A grandparent that cares reads `d.workspace.inbox.composer.stage`/`.sent` directly — the
recursive delta composes through nesting with zero code in the middle component, which is
precisely what message-wrapping architectures never offered.

`Handoff<T>` buys guarantees no event bus or message type offers structurally (18 §2, §6 gate 2–3):

| Guarantee | What it means | Where it's exercised |
|---|---|---|
| Durable in flight | give → journal checkpoint → crash → restore → take still succeeds | inbox.rs's `a_handoff_survives_a_journal_round_trip_before_being_taken` |
| Untaken is diagnosed | a handoff still full at turn-end is a located inspector report naming giver and non-taker, never a silent `_ => {}` | 18 §2 point 2, flagged in inbox.rs's tests since the diagnostic itself lives below this corpus's level |
| Linear | a second `take()` in the same turn returns `None`, not a second delivery | inbox.rs's `a_handoff_takes_at_most_once` |
| Ordering/coalescing | FIFO drains in order (`take()` in a loop, or `drain()`); `Handoff<T, Latest>` keeps only the newest — declared policy, not accident | 18 §2 point 3 |
| Recursive depth | a grandparent consumes a grandchild transition through the recursive delta with no intermediate code in the middle component | 18 §6 gate 4 |
| No Msg, no wrapping, no catchers, no embeds | no message type, no per-level unwrap/rewrap, no catcher parameter, no embed function anywhere in the corpus | 18 §6 gate 1's zero-vocabulary grep |

Third, **the change is a typed value, read in the handler, never routed to one**, with FIELD
syntax as the one access spelling (15 §3, 18 §3, kept from 17). `#[derive(Delta, Serialize,
Deserialize)]` is a DATA derive, structdiff-shaped, assembled from the publication log rather than
computed by walking: it generates a `T::Delta` (`MailStoreDelta` for inbox.rs's `MailStore`) with
one `Option<Change<field>>` — or a richer splice/edit/move delta for a `List<T>` field, or
`Option<Given<T>>` for a `Handoff<T>` field — per field, and it is now the ENTIRE observation
vocabulary: a field whose type has no derive degrades gracefully to a changed/unchanged marker
with `Deref` to the new value (reach.rs's `Buffer` stays undecorated — `d.buffer.any()` is exactly
that degrade tier). "How" something changed is ordinary Rust — guard-the-function (07 §6.1)
applied to change — `if let Some(c) = &d.store.unread { if c.new > c.old { self.chime() } }`
(inbox.rs's `Inbox::changed`) — rather than a pile of parallel derived wires. The layering that
used to be two mechanisms is now one: an equality-gated projection that needed its own derived
`when` wire (derived_observe.rs's whole point) sits in the SAME handler body as the richer "how"
case — `if new_lang != old_lang` is a sibling `if` to `if c.new > c.old`, both just Rust over the
delta, both field syntax.

Fourth, **scheduling is gate-3, extended from views to reactions** (18 §6 gate 5, unchanged from
16 §2). With no `#[reactive]`, `changed` is invoked whenever ANY field-source of the component
publishes — coarse, cheap (a no-op pass over `None`s), and semantically exact. With `#[reactive]`,
the statically visible delta accesses in the handler body are cut into exact invocation edges, so
`changed` runs only when a read path actually published. Removing the attribute changes invocation
COUNTERS only, never BEHAVIOR — the same theorem the view already lived under, now covering
effects too (derived_observe.rs's "guarantee" section works this out in full; inbox.rs's
mute-guard test exercises it directly).

`Emitter`/`type Event` was deleted outright by 16 §1 table, §6 decision #3, and 16's replacement —
an `Output<E>` endpoint an entity emits into — is now ALSO gone (18 §1/§5): an entity that used to
"raise an event" simply changes a field, and observers read it the same way they read any other
state transition. reach.rs's `Project` no longer has a `renamed` endpoint at all; `Workspace
::changed` reads `&d.project.root` — the rename's old AND new value both ride the ordinary
`Change<PathBuf>` a field mutation already produces. Inputs and outputs are now entirely
structural — a component's reactive signature is literally its field list plus its parameters,
with no registration and no declared endpoint, in any spelling, anywhere in the system (18 §5).

Elm is a library choice, not a foundation feature — the ratatui posture (16 §4, kept by 18 §5).
The mechanisms — fields, delta, `Handoff<T>`, `view`/`changed`, routes-as-fn-items — compose into
TEA in userland with nothing added: a `Stage`-style lifecycle enum plus one funnel method per
component is nearly TEA already (18 §5), and `changed` forwarding a taken delta into
`self.update(msg)` is three lines over the same primitives every other component in this corpus
uses directly. The default per-concern style (a method per concern, as inbox.rs and reach.rs both
use) is just as many lines the other way; the foundation refuses to pick. With `Wired`/`when`/
`Emitter`/`Output<E>` all gone, there is no framework-owned reaction vocabulary left for an
architecture to conflict with — no message type exists anywhere in the framework for TEA to
compete with (18 §5).

There is one child verb, `.child(x)`, plus a placement algebra (`.align(…)`, `.at(handle)`,
`.above`/`.below`, `.z(n)`); `layers(…)`/`stack(…)`/`.overlay(…)` don't exist. The document root
fills the window by default, so roots don't restate `.size_full()`. No example wraps a SINGLE
child in a meaningless pass-through `div()` just to have a node to hang a style on — the style goes
directly on that child. Where `div()` genuinely holds several already-placed pieces with nothing
for a flow container to arrange (blur.rs's root, pointer_follow.rs's `loupe()`), that IS the honest
use of the styled-box primitive, not glue (14 §2.1). Application code is base Rust — `String` in
structs, `&str` at boundaries, no `SharedString` in any signature. Nothing is cloned during
description; the commit diff promotes only the changed operand. This is the whole point of the
redesign, so read [blur.rs](blur.rs)
first for the floor.

| Sketch | Source | What it is testing |
|---|---|---|
| [hello_world.rs](hello_world.rs) | `legacy/hello_world.rs` | Floor: `String`, `Application::run`, `fn view(&self) -> El<'_>` vs the leaf `impl Element + Styled` |
| [app.rs](app.rs) | (new — 07 §12) | Application ownership and explicit window kind; older syntax retained as migration input |
| [creating_components.rs](creating_components.rs) | `learn/creating_components.rs` | `&self.local` is a child; the borrowed frame makes helper `'a` honest; `Prop<i32>` unifies `42`/`&n`/`&signal`; `El<'a>` for whole-view helpers |
| [identity.rs](identity.rs) | (new — 07 §5) | `Target<K>` identity as a field; `.focus_default()`; `AnyTarget` + `impl Into<AnyTarget>`; `Win::demo` + `win.root()` test |
| [interactive.rs](interactive.rs) | `learn/interactive_elements.rs` | Clicks, hover-as-style, drag payloads (`Dropped<T>`, never `Drop<…>`), machine-rate ports; `row(&self.tiles)` — the implicit rung of the children ladder (14 §2 item 3) for a `List<T>` whose rows are plain views |
| [haptic.rs](haptic.rs) | `learn/haptic_feedback.rs` | `self.haptic` ambient; `.on_hover_enter(Route.with(style))` — `.with` binds on the route, not the element; `slider(&Signal).step().on_step` |
| [animation.rs](animation.rs) | `learn/animation.rs` | `.spin` / `.rotate` / `.scale(pulse)` programs; `asset!` embed; `.apply(card)` mixin (`pipe` renamed) |
| [image.rs](image.rs) | `legacy/image.rs` + `image_loading.rs` | thousands of photos; source is the constructor / a field; virtualizer = decode window; `.scroll(Axis::Y)`; `.decode_at(Decode::Layout)` |
| [image_slice.rs](image_slice.rs) | Bevy `ui_texture_slice` / atlas | 9-slice, tile, atlas, `.tint` vs `.colorize`; `vw`/`vmin` |
| [pointer_follow.rs](pointer_follow.rs) | Slint TouchArea / Bevy RelativeCursorPosition | pointer is a `GeometryRef`, not a `Signal<Point>`; `follow(…)` is a placement value, no `layers()`/`.relative()`; the nullary `div()` + three chained `.child(…)` calls IS the answer for a bare positioning canvas (14 §2.1 — resolves the file's former open-question NOTE) |
| [docking.rs](docking.rs) | Iced `pane_grid` on 06 | `List<T>` + `Slot<T>` identity (no id-newtype/`ComponentMap`); sash leeway; two algebras |
| [example_input.rs](example_input.rs) | `view_example/` | `text_input(&String)` vs `text_input(&Editor)`; `editor.cursor.project(…)` (inherent method, no parenthesized borrow); `Key::Q.primary()` on the view |
| [uniform_list.rs](uniform_list.rs) | `legacy/uniform_list.rs` | `List` + row fn, not a range processor; `.scroll(Axis::Y)` |
| [typeahead.rs](typeahead.rs) | `view_example/example_input.rs` + 07 §5, journal-cleaned by 14 §4, state-is-the-protocol by 18 §1–2 | `.open()` vs `.then()`; `picked: Handoff<SuggestionId>` as a linear give/take source — `Typeahead::new()` takes no route, there is no embed function at all, `Search` mounts `&self.typeahead` as a plain field child and takes `d.typeahead.picked` in its own `Search::changed`; `List::follow(reader, key)` replaces the hand-rolled epoch dance for latest-wins search |
| [async_search.rs](async_search.rs) | `learn/async_tasks.rs` | the async ladder's rung 2 (`self.action(…).queue(…).then(…)`) for a one-shot user-triggered task, and rung 3 (raw `tokio::spawn` + `Remote<Self>`) for a genuine progress stream |
| [reach.rs](reach.rs) | (new — 07 §6.4, 12, 18 §1) | mini-`Workspace`: entity `Deref` as a peek, `self.spawn_latest`; `Emitter`/`ProjectEvent` deleted (16 §1 table, §6 decision #3), and 18 deletes what replaced it too — `Project` has no `renamed` endpoint at all, `rename()` just sets `*self.root`; both observations move into `Workspace::changed(&mut self, d: Changed<'_, Workspace>)`: `d.buffer.any()` (entity-grain, `Buffer` derives no `Delta`, degrades to a changed marker) replaces the old `when(&self.buffer, Self::persist)` edge, `&d.project.root` reads the rename as a plain field `Change<PathBuf>` (field syntax, 18 §3) — no edges declared in `view` at all; this file is 18 §1's law made concrete, state IS the protocol |
| [derived_observe.rs](derived_observe.rs) | (new — 07 §6.4, 12 §2a, 18 §1/§3) | field-grain, equality-gated effect respelled as handler-body Rust: `Buffer` now derives `Delta` so `Editor::changed` reads `&d.doc.text` (field syntax, not a method call) for `c.old`/`c.new`, projects both through `detect_language`, and gates with a plain `if new_lang != old_lang` — no `when(derived_source, route)` wire, no view child at all; the file's "guarantee" section is rewritten around gate-3 symmetry extended to reactions (18 §6 gate 5, unchanged from 16 §2: `#[reactive]` narrows `changed`'s invocation to the read pattern, never changes behavior); the fire-and-forget rebuild still uses `self.spawn_latest` |
| [workbench.rs](workbench.rs) | (new — 07 §§2.3, 7, 9, 11, 13, 14, 15, 18; merges the former `async_workbench.rs`, `async_workbench_lite.rs`, `workbench_composed.rs`) | the composition pass in full: zero app-visible ids (serde journaling, restore = re-derivation), the closed field law (14 §4, 18 §5 — `Workbench.editor_focus: Target<TextInput>` serializes like `PhantomData` under `#[derive(Serialize, Deserialize)]`, no `#[serde(skip)]`; `PresenceSession.applied: Handoff<PresenceBatch>` is journaled STATE instead, a different and stronger guarantee than `Target`'s unit serialization — `connect(transport)` now takes NO route at all (18 §5 decision #4: services take no constructor routes, same rule as a mounted component's dead embed), `Workbench::changed` takes `d.presence.applied` and applies the batch atomically), enum tabs whose variant views unify as `El<'_>` with no `el(…)` join, `code(…)` owning its display projection at the mount, decorations as placed marks over an inherited geometry source, encapsulation as struct views rather than a return-type contract, the presence protocol, and the richest test matrix (§7.0 wake law, A→B→A stale-completion rejection, presence resync/incarnation, weak-cycle teardown, durable-vs-live identity recast for the journal model) |
| [text.rs](text.rs) | `learn/text.rs` | `column((…))` / `.apply(card)` / `text(…)`; `section<'a>` and the gallery helpers as leaf `impl Element` (never branched over); `grid(iter)` children in constructor position; `.scroll(Axis::Y)`; `Application::run` |
| [transition.rs](transition.rs) | `learn/transition.rs` | Hover variant + `.transition`; `Application::run` |
| [blur.rs](blur.rs) | `learn/blur.rs` | No-macro floor: `El<'f>`, leaf `impl Element` helpers with no `el(…)` wrapper, ordinary conditional builders (same concrete builder type in both arms), constructor-position children for flow containers and nullary `div()` + chained `.child(…)` for the absolute-positioning canvas root (14 §2.1's two children rules, both demonstrated in one file), demo turn barriers, one child verb + placement values instead of `.overlay(…)` |
| [presenter.rs](presenter.rs) | (new) | One optional `#[reactive]`, typed `Win<V>` handles, shared `Entity`, method-local key guard, `Selected<Slide>`, plain-serde journal persistence (restore = re-derivation, no `History` trait), semantic demo tests; `grid((now_column, next_column)).layout(Grid::columns(…))` — the honest flow container for a genuinely two-column layout, not `div((…))` (14 §2.1) |
| [reactive_compare.rs](reactive_compare.rs) | (new — 07 §5, gate 3) | one component written twice: `#[reactive]` and its hand-lowering side by side; direct ports, `project` regions (inherent-method and tuple forms), mixed reads, opaque helpers that must be respelled `El<'_>` at the one genuine cross-helper join (no `el(…)`, 14 §1.2), and the gate 3 counters test |
| [inbox.rs](inbox.rs) | (new — 07 §6, 13, 14, 15, 18) | the full reaction surface in one app, the flagship for 18: `Inbox::changed(&mut self, d: Changed<'_, Inbox>)` as the ONE reaction method — a mute-guarded chime and an unconditional badge as independent `if`s over `&d.store.unread`'s `c.old`/`c.new` (field syntax; `#[derive(Delta)]`'s `MailStoreDelta`, 15 §3; folds in what used to be a separate derived `on_unread_level` edge), a health-transition announcement over `&d.store.health`, and a composer close over `d.composer.discarded.take()` — no `when` children, no `Option`-child edge, no wiring API named anywhere in `view`; the mute-guard test exercises gate-3 symmetry directly (18 §6 gate 5: the guard is an ordinary `if`, not a torn-down/re-armed edge); `Composer.sent: Handoff<OutgoingMail>` and `.discarded: Handoff<Discarded>` as linear give/take sources (18 §2) — `Composer::send`/`discard` give, `Inbox::changed` takes `d.composer.sent`/`.discarded`, taking IS the acknowledgement, and `Composer` mounts as a plain field child (`dialog(&self.composer)`), no embed function anywhere; `Target<K>` for focus/claims/parts/typed-space placement (`.below(target)`); all three children rungs in one view; `List::follow` search + a rung-2 reliable send action; a dedicated crash-safe fixture (give → journal checkpoint → restore → take, 18 §6 gate 3) alongside the linearity test (double-take is `None`, 18 §6 gate 2) and the whole-tree journal round-trip restoring a mid-flight composer draft, with no wire count to re-arm on restore (`changed` is a provided method, not a stored edge) |
