# 05 — One Register: Values, References, Functions

Status: **amendment to [04-less-is-more.md](04-less-is-more.md)**. This document replaces 04's
authoring seam — the two-register receiver contract (`&mut self` handlers vs `&Self` handlers), the
`region`/`region_with` nouns, and the ladder framing of §3 — with a single register whose
granularity is expressed entirely by ordinary Rust. Everything below the authoring seam is
unchanged: the producer/span protocol, the turn protocol, the tape/manifest, the scheduler,
collections, media, style, identity, testing. This is a rewiring of how authors *spell* reactivity,
not a fourth architecture.

Research folded in (normative here, not a second plan):
[10-elegance-and-fast-paths.md](00-research/10-elegance-and-fast-paths.md)
(closures-as-scopes, `impl Element`, staged writes, effects, zero-cost 03 paths; verified on
rustc 1.97.1) and
[10-cross-cutting-higher-tier.md](00-research/10-cross-cutting-higher-tier.md)
(session indexes, editor ranges ≠ FlowIndex, gesture as three machines — seats in
[06-cross-cutting.md](06-cross-cutting.md)).

## 0. The diagnosis: the receiver split is an effect system wearing a borrow

04 encodes "what reruns" in the borrow mode of the handler's receiver: `fn(&mut Self)` reruns the
owner's `view`; `fn(&Self)` may publish only signals and skips it. That rule is small, but it is
structurally an effect annotation — a per-method cadence contract that:

- must be *chosen* on every handler, and choosing wrong is silent (`&mut self` on a signal-only
  handler costs 10× and compiles fine — 04 admits this and proposes a lint);
- creates a cliff, not a gradient: a handler that touches one signal *and* one plain field must be
  `&mut self`, so the signal bought nothing for exactly the handler you were optimizing;
- makes borrow mode mean something borrow mode doesn't mean anywhere else in Rust. `&self` vs
  `&mut self` is aliasing, not scheduling. Overloading it *is* the "second scaffolding" this
  project set out to avoid — an effect system smuggled into receivers.

The replacement rests on one observation and one measurement.

**The observation.** A component and a signal are the same thing at different sizes. `Component<T>`
is a state cell whose one consumer is its `view`. `Signal<T>` is a state cell whose consumers are
the exact slots and functions that read it. There are not two registers; there is one wake rule
applied to cells of different granularity:

> **Mutating a cell wakes exactly its readers. You choose cell size with ordinary data design —
> the same way Rust already teaches you to split structs for the borrow checker.**

**The measurement.** Re-emitting a description is not the expensive part of a UI frame and never
was. The Azul audit in [azul-xilem.md](../../azul-xilem.md) is blunt: producing the user model for
a 9,000-word document takes ~50µs; the real costs were shaping, cascade, damage, and allocation in
raster loops. 04's own pipeline already moves all of those behind the manifest. So the thing the
`&Self` receiver existed to avoid — an "unnecessary" `view` rerun — is the *cheapest stage in the
entire system*, and it can be made cheaper still (§4). The figure is document-sized, not a blanket
license — the 2,000-element single-owner cliff is real and stays gated (G1) — but the placement
argument holds: we do not need to statically prove a rerun unnecessary. We need reruns to cost
what they're worth.

## 1. The whole reactive vocabulary is three Rust moves

Everything an author does with state in the display tree is one of three moves that Rust
programmers already know:

```text
pass a VALUE          -> snapshot.  Refreshed when the enclosing producer reruns.
pass a &Signal        -> wire.      That one slot patches; no Rust reruns.
pass a FUNCTION       -> scope.     Reruns exactly when something it read changes.
```

Stated honestly: the move chooses the *mechanism family*; the receiving property chooses the
*exact contract* — snapshot vs controlled for a value, read-wire vs two-way vs event-sink for a
reference, scope vs wire-projection for a function (`signal.map(f)` is the function move applied
at wire granularity). Cost is derivable from the pair (move × property), which is how the §5
table reads. That is the ordinary consequence of typed builder methods; the move alone is not a
cost oracle, and this document does not pretend otherwise.

No `bind`, no `watch`, no receiver contract, no second trait, no cadence generic.
04 already used all three moves without naming them: `gpui::run(clock)` passes a function,
`keyed(...).row(Self::card)` passes a function, `.selection(&self.selection)` passes a reference,
`text(&self.title)` passes a value. This amendment makes that triad the *entire* rule and deletes
the receiver rule it was shadowing.

```rust,ignore
trait View {
    /// Describing is reading. Shared borrow, uniformly.
    /// Application code writes `impl Element + '_`. Never `use<..>` — that syntax is
    /// crate-internal (Rust 2024 capture opt-out on methods that take `&self` plus a
    /// borrow they actually return).
    fn view(&self) -> impl Element + '_;
}
```

`view` takes `&self` now, for the ordinary Rust reason, not a register reason: functions that
compute a description from data are readers; handlers are writers. Read = `&`, write = `&mut`,
everywhere, with no scheduling meaning attached to either. (04 gave `view` `&mut self` to *mark
the register*; with registers gone, the marker goes too. Scratch caches that wanted `&mut self`
during description move into handlers or a signal — description staying a pure read phase is what
lets scopes rerun independently and is the temporal read/write split the Azul notes call the only
way to stop fighting the borrow checker.)

Window roots are `fn run<V: View>(v: V)`. `View` is not `dyn`-safe (RPITIT); erasure to `Ui` /
the tape happens at the window boundary. There is no `dyn View`.

### Values: plain Rust, rebuilt and diffed

```rust,ignore
#[derive(Default)]
struct Counter { count: u64 }

impl Counter {
    fn increment(&mut self) { self.count += 1; }
}

impl View for Counter {
    fn view(&self) -> impl Element + '_ {
        row()
            .gap(8)
            .child(text(format_args!("Count: {}", self.count)))
            .child(button("Increment").on_click(Self::increment))
    }
}
```

Zero signals, zero graph, zero nouns beyond `View` and `Element`. Builders return `Ui`, which
implements `Element`; that is why the floor compiles with no extra types. A click runs an owner
transaction, `view` reruns, and the tape diff (§4) turns the rerun into one text-slot patch. This
is the "super plain, obvious Rust" floor, and it is *complete* — nothing above it is required.

### References: wires

Passing `&Signal<T>` to a property that accepts live input records a wire: source lease, slot,
canonical conversion, last version. A version bump patches the slot and enters the pipeline at the
first affected output stage (text re-shapes; a color starts at paint; a transform starts at
composite). No Rust reruns. `signal.map(f)` is a wire carrying a typed, side-effect-free
projection — note it is the *function* move applied at wire granularity, not a new concept:

```rust,ignore
editor_surface()
    .scroll_y(&self.scroll_y)                                  // wire
    .background(self.selection.map(Selection::background))    // wire + projection
```

This keeps 04's `BindingRecord` machinery verbatim; only the name `bind` (which implied a separate
binding subsystem) is retired in favor of the reference itself being the spelling.

### Functions: scopes

A function passed where an element is expected is retained as its own producer and rerun
independently:

```rust,ignore
impl View for Editor {
    fn view(&self) -> impl Element + '_ {
        column()
            .child(editor_toolbar(&self.prefs))   // value: part of this view's tape
            .child(Self::overlay_view)            // function: independent scope
    }
}

impl Editor {
    fn overlay_view(&self) -> Ui<'_> {
        match self.overlay.get() {                // read inside the scope: subscribes the scope
            Some(overlay) => overlay_view(overlay),
            None => empty(),
        }
    }
}
```

`.child(Self::overlay_view)` replaces `region(Self::overlay_view)` — the same producer record
underneath, and the laziness distinction is Rust-native: pass `f()` to inline the result now;
pass `f` to let the runtime call it again later.

Making that compile on stable Rust was adversarially checked and needs one specific mechanism,
recorded here because the naive version genuinely fails. A plain `Fn`-blanket
`impl<F: Fn(&O) -> Ui<'_>> IntoElement for F` coherence-conflicts (E0119) with the impl for
`Ui<'a>`. The fix is the **marker-type-parameter pattern** (Bevy `IntoSystem` / Axum handlers —
battle-tested at scale): the child bound is `IntoElement<'a, M>`, and the impls live at different
marker instantiations, which coherence treats as different traits:

```rust,ignore
pub trait IntoElement<'a, M>: /* sealed per marker */ { fn record(self, d: &mut Draft<'a>); }

impl<'a, E: Element + 'a> IntoElement<'a, AsElement> for E { /* Ui<'a> is just the erased Element */ }
impl<'a, O: 'static, F>   IntoElement<'a, AsScope<O>> for F
where F: for<'b> Fn(&'b O) -> Ui<'b> + 'static { /* retained scope producer */ }
impl<'a, I, F>            IntoElement<'a, AsScopeWith<I>> for Scoped<I, F> { /* scoped(input, f) */ }

fn child<M>(self, c: impl IntoElement<'a, M>) -> Self;
```

No overlap, and — the part the first pass missed — **no coercion problem either**: fn items
implement `Fn` natively, so `Self::overlay_view` satisfies the HRTB bound directly, with
`O = Editor` and `M` both inferred. This also re-centers children on `Element`. The known tax is
diagnostic quality — marker-trait inference failures are cryptic by default — so
`#[diagnostic::on_unimplemented]` plus `#[diagnostic::do_not_recommend]` on marker blankets,
and trybuild snapshots of the rendered errors, are a gate (G9), not a hope.

### Return types: `impl Element + '_` vs `Ui<'_>`

These are not two APIs. `Ui<'a>` is the **nameable** erased plan (Iced's `Element<'a>`).
`impl Element + '_` is the **typed** plan, recorded when a parent `.child`s it. Application
code never writes `use<..>`.

| Returns | Who writes it | Why |
|---|---|---|
| `impl Element + '_` | `View::view`, helpers, library widgets, row bodies | Copy reuse; `fn pane(a: impl Element, b: impl Element) -> impl Element`; deforestation (03's Property lowering). A view may return a `Copy` badge with no tape. |
| `Ui<'_>` | Retained **scope producers** (`Self::list`, `Self::scope(\|this\| …)`) | The HRTB bound `F: for<'a> Fn(&'a O) -> Ui<'a>` is writeable, so the runtime can call `f` later. You cannot write `Fn(&O) -> impl Element` as a higher-ranked bound ([rust#70263](https://github.com/rust-lang/rust/issues/70263)). |
| `UiBuf` | Opt-in clone of already-recorded tape | Embed the same chrome twice after recording. Slow path, named so. |

`.child(self.list())` inlines the list into the parent producer — cheaper to type, **wrong** if
the list should skip when the parent reruns. `.child(Self::list)` retains it; `list` therefore
returns `Ui`. Mixing those two *is* the style.

Do **not** make constructors return a `Row<(A, B, …)>` type tower. That is Xilem's `View<State>`
explosion, which Vizia 0.4 deleted. Builders still lower to one tape. `impl Element` is the
unrecorded leaf/helper plan, not a second tree of nested generics. No TAIT: do not name
`impl Element` in a struct field.

`use<..>` (precise capturing, stable 1.82; in traits 1.87) is **crate-internal**. Rust 2024
RPIT captures every in-scope lifetime by default; a framework method that takes `&self` plus a
borrow it actually returns uses `use<'t>` so the element does not pretend to borrow `self`.
Application signatures stay `impl Element + '_`. A lint/code-action "this helper can return
`impl Element + '_`" is the DX.

### Closures as scopes: `Self::scope`, stable today

The marker was the bug, not the solver. A **direct** HRTB bound
`F: for<'a> Fn(&'a O) -> Ui<'a>` accepts capture-free closures on rustc 1.97.1. The same
closure fails through `IntoElement<'a, M>` ([rust#70263](https://github.com/rust-lang/rust/issues/70263):
the HRTB-closure special case is `Fn*` only). Annotating `|x: &Owner|` does not fix the marker
path.

```rust,ignore
impl View {
    fn scope<F>(f: F) -> ScopeFn<Self, F>
    where
        Self: Sized + 'static,
        F: for<'a> Fn(&'a Self) -> Ui<'a> + 'static,
    {
        ScopeFn { f, _o: PhantomData }
    }
}

.child(Self::overlay_view)                       // taught: named, reusable, no wrapper
.child(Self::scope(|this| this.overlay()))       // inline; associated fn pins O = Self
.child(scoped(doc_id, Self::overlay_for))        // owned input, skip on equal
```

Bare `.child(|this| …)` still fails through the marker. G9's text is "pass a method path, or
`Self::scope(|this| …)`". Captured borrows fail with E0373 — that is the semantic ban, already
the borrow checker. Copy/`move` of `'static` data is legal (same permission `scoped` grants).
`scoped`/`frozen` steal Xilem's `const { assert!(size_of::<F>() == 0) }` for the capture-free
case.

The next-generation trait solver is a **compatibility gift**, never load-bearing (P12). Coherence
has used it since 1.84. `-Znext-solver=globally` is not even default on nightly as of 2026-08-11
([rust#160895](https://github.com/rust-lang/rust/issues/160895)). It does not make `|x| view(x)`
infer through `IntoElement`. `closure_lifetime_binder` (RFC 3216) is worse DX than `Self::scope`
and must not be a public requirement.

A scope reruns when a signal it read changes, and on owner reruns (where its own tape diff bounds
the work — see §3 for why owner reruns cannot be statically excluded). When both happen in one
turn, dirty producers run parent-before-child and a parent rerun *subsumes* the scope's
independent dirty flag; a queued signal-wake carrying a stale scope generation is dropped. Scope
identity is **owner + embedding site in the parent** (the `.child` call's `#[track_caller]`
location) **+ enclosing keys** — 04 §7's embedding-token rule, kept because a helper that wraps
the call must be `#[track_caller]` or two call sites would silently collide; `.key(...)` covers
repeated/dynamic scopes. Closures capturing borrows are rejected at the type level, which is the
borrow checker enforcing "no borrow crosses a frame" — not a framework rule.

And `signal.get()` inside `view` itself? It subscribes the enclosing producer — the view. That is
the coarse-but-correct default; narrowing is exactly the two moves above: hand the property the
reference instead of the value, or move the branch into a function. **A read subscribes whatever
producer encloses it; you choose producer size by what you hand the runtime.** One rule, three
sizes: view ⊃ scope ⊃ wire.

## 2. Writes: the target is the granularity, and it's a type, not a borrow mode

There is exactly one kind of owner handler:

```rust,ignore
button("Save").on_click(Editor::save);        // fn(&mut Editor)
```

`fn(&mut Self)` targets the owner cell; its readers — this component's `view` and scopes — rerun,
then diff. No alternative receiver exists on `Self`, so there is no per-method cadence choice to
get wrong.

Fine-grained writes are handlers on *the data inside a signal* — ordinary methods on an ordinary
struct, whose granularity is stated by their first argument's type:

```rust,ignore
struct Editor {
    document: DocumentSource,
    selection: Signal<Selection>,
    scroll_y: Signal<Pixels>,
    overlay: Signal<Option<Overlay>>,
    prefs: Preferences,                        // plain field — and that's fine
}

impl Selection {
    // Plain Rust on plain data. Nothing framework-shaped about it.
    fn apply_key(&mut self, event: KeyDown) { /* ... */ }
}

editor_surface()
    .on_key(self.selection.update(Selection::apply_key))   // fn(&mut Selection, KeyDown)
    .on_scroll(&self.scroll_y)                              // event payload piped into the signal
```

- `signal.update(f)` installs `f: fn(&mut T, Event)` as the handler. The write opens the signal's
  cell, not the owner. Wakes: selection's readers — a few wires and maybe one scope. `view` does
  not run. There is nothing to annotate because there is nothing to infer: **a function that takes
  `&mut Selection` physically cannot touch the rest of the editor.** The borrow checker is the
  effect system, used the way it was designed to be used — on data, not on scheduling.
- `on_scroll(&self.scroll_y)` is the degenerate, most important case: an input protocol piped
  straight into a signal that feeds a transform-stage wire. The whole 120 Hz path — input → signal
  → composite patch — runs zero user Rust per event and zero description work. This lane, plus
  tasks, motion, and media clocks, is where machine-rate updates actually come from; owner handlers
  are human-rate almost by definition. The receiver split optimized the wrong axis: it made
  *keystroke-rate* handlers cheap while machine-rate traffic never needed a handler at all.
- When the transition needs to *read other data*, do **not** alias the cell you are drafting
  behind an owner reference. Extra arguments, or a sibling `rest` struct — actual split borrows:

```rust,ignore
    .on_key(self.selection.update(Selection::apply_key).reading(&self.keymap))
    // fn(&mut Selection, &Keymap, KeyDown) — the draft is the only name for selection
```

  `.reading(x)` snapshots/`Rc`s its argument at each install (handlers reinstall per emission, so
  the snapshot refreshes with the producer); it can never hand out the drafted cell, so
  "two names, two isolation levels, one cell" is unspellable. Need-the-whole-owner ⇒ you wanted
  an owner handler, and you pay the view rerun this document already prices.

**`update_in` is deleted, not renamed.** The earlier draft kept it with `Draft<T>`/`Host<O>`
wrappers so the owner-alias couldn't lie about isolation — scaffolding that existed only to
*name* an irregular fact. Removing the API removes the fact: with no `&Owner` parameter there is
no second name for the drafted cell, no committed-vs-draft read to teach, no missing-method
`Host`, and G4 shrinks to one lint on the leftover dynamic `edit` escape. One family remains:
`update(f)`, arity-extended by `.reading(...)`. This is the pattern for every irregularity in
this document: **prefer deleting the API that creates the fact over naming the fact.**

### The first parameter is the routing

There is one more inference the runtime can make for free, and it completes the gradient: a
handler's first parameter type is not just its blast radius — it is its *address*. When a bare
method is installed whose receiver is **not** the owner, the runtime routes it to the wired cell
of that type on the same element:

```rust,ignore
editor_surface()
    .selection(&self.selection)            // the wire declares the cell
    .on_key(Selection::apply_key)          // fn(&mut Selection, KeyDown) → routed to that wire
```

Resolution at lowering, deterministic and located: receiver type == owner → owner transaction;
receiver type matches **exactly one** wired cell on this element → that cell's transaction; zero
or multiple matches → a located error naming both fixes ("wire the cell" / "disambiguate with
`self.selection.update(...)`"). No new trait machinery — the existing handler blanket already
accepts `FnMut(&mut T, Ev)` for any `T`; only the lowering rule changes.

To be explicit about what this does **not** add: `signal.update(...)` is not a peer spelling —
this document just deleted `update_in`, `spawn`, and returned `ListDelta` precisely for being
second spellings. `update` survives as the **disambiguator only**, for the one real case where
routing cannot: two cells of the same type on one surface (primary + secondary
`Signal<Selection>` in an editor). Taught material uses the bare method everywhere else, and
the ambiguity error is where authors learn the explicit form exists.

`.reading(x)`'s freshness is part of the contract, not an implementation detail: a plain
reference (`.reading(&self.keymap)`) is a **snapshot taken when the enclosing producer emits** —
stale until that producer reruns, which is the honest cheap default for configuration-shaped
data; a cell reference (`.reading(&self.keymap_signal)`) is a **wire** — read live at event
time, never stale, never cloned per event. The type of the argument picks the semantics, which
is the triad again: value = snapshot, reference-to-cell = live.

This is what makes promotion *complete*: promoting `selection: Selection` to
`Signal<Selection>` plus moving `apply_key` onto `Selection` (where it now belongs — it operates
on selection data) leaves every call site the same shape: `on_key(Type::method)`. There is no
rebinding step left to forget, and no code-action heuristic — the receiver type is the proof,
checked where it lowers.

Inside a **wired collection row** (below), the routing goes one step further: a handler on the
item type binds to *this row's slot* — `row().on_click(Thread::toggle_read)` mutates that row's
`Thread` in place, bumps its slot revision, and reruns that row only. Most `.with(id)` plumbing
disappears, because the row already knows which item it is.

The full write rule fits in one line, and every case is derivable from what the code *names*:

> **What you mutate is what wakes, and the first parameter's type is the address.**
> `&mut Editor` → the editor's readers (its view, diffed). `&mut Selection` → the wired
> selection cell's readers. `&mut Thread` in a wired row → that row.

Two ergonomic forms remove nearly every closure — and with them the owner-type annotation
(`move |b: &mut Board| ...`) that would otherwise appear on every capturing handler, since `Ui` is
deliberately not generic over the owner:

```rust,ignore
// Bound-argument methods: O and A infer from the fn item; no closure, no annotation.
button("Add card").on_click(Board::add_card.with(id));          // fn(&mut Board, ColumnId)
text_input(&col.title).on_change(Board::rename_column.with(id)); // event arg stays free

// Mutation descriptors on signals: inert, typed, #[must_use] — 03's `count.add(1)` reborn
// as signal-write sugar. Wakes count's readers only; the owner never dirties.
button("+").on_click(self.count.add(1));
button("Mute").on_click(self.muted.toggle());
```

`.with(args)` is a sealed extension on `Fn(&mut O, A, ..)` items returning an erased
`FnMut(&mut O, ..)`; it is the taught form, and a hand-rolled closure is the escape hatch for
genuine multi-capture. Descriptors exist only on `Signal<T>` (a plain field is not addressable as
a value — which is a feature: "promote the field to `Signal` and gain `.set/.add/.toggle` sugar"
is another visible rung of the gradient). Because descriptors are drawn from a sealed set with
known inverses, descriptor writes are journal-eligible for undo where arbitrary closures never can
be (§6).

The gradient the user model wants is now literal and involves no trait, receiver, or handler-kind
change — it is data design, the most ordinary Rust activity there is:

```text
plain field                     mutations rerun this view (diffed)
Signal<T> field, same T         hot handlers move from Self::method to signal.update(T::method);
                                hot properties take &signal instead of the value;
                                hot branches become functions
```

Promoting `selection: Selection` to `selection: Signal<Selection>` changes *one field's type*.
`Selection`'s methods don't change. The component's trait doesn't change. Handlers that still take
`&mut Editor` still work (and still honestly rerun the view — they read/write the whole editor).
You rebind exactly the hot handlers, and the signature of each rebound handler tells the reviewer
what it costs.

### Effects: one noun, and its position is its lifetime

An earlier draft had three legal spellings for the same intent — return an effect, call a
turn-scoped `spawn`, or store a `TaskHandle` field — and which to pick was taste plus "does this
outlive the turn?" That question was the tell: it is Rust's *ownership* question, so the answer
should be Rust's, not a style guide's. The collapse:

> **An effect is a value. Where you put the value is who owns the work.**
> Return it → the turn routes it, scoped to the owner (cancelled when the owner drops).
> Store it → you own it (drop or overwrite cancels).
> Neither → `#[must_use]`; `.detach()` is the explicit process-scoped escape.

`Task` and `TaskHandle` are the **same type** now — `Task`, the running work as a value.
`Emit<E>`, `Announce`, `WindowCommand`, and tuples are effect values under the one sealed
`IntoEffects`. And the choice space is two scopes, not three spellings: **owner-scoped** work is
written to the turn log — by returning the value *or* by `spawn`, which are the *same log
entry* (returning is sugar over the log; `spawn` is the mid-stack spelling so starting work
never forces a signature change up a helper chain) — while **field-owned** work is a stored
`Task`. The decision is never taste: *does a specific piece of state own this work's lifetime?*
Store it there. Otherwise it's owner-scoped, spelled whichever way the call stack makes
natural:

```rust,ignore
fn increment(&mut self) { self.count += 1; }                   // () — no effect

fn save(&mut self) -> Task {                                   // returned: owner-scoped
    let snap = self.doc.snapshot();                            // owned, 'static
    Task::run(async move { api.save(snap).await }, Self::saved)
}

fn start(&mut self, id: DownloadId) {                          // stored: field-owned
    let task = self.client.fetch(self.item(id).url.clone())
        .progress_into(&self.item(id).progress)
        .on_done(Downloads::finished.with(id));                // -> Task
    self.item_mut(id).state = DownloadState::Active { task, .. };
}

fn pick(&mut self, id: SuggestionId) -> Emit<Picked> {
    Emit(Picked(id))
}
```

**Reject `async fn save(&mut self) { … .await }`.** The future would capture `&mut self` across
`await` — the no-borrow-across-a-frame rule, now at the type level. `Task::run` takes an owned
future plus a completion method; `From<Fut>` covers the completion-free case.

`spawn` earns its return from an earlier deletion by being a **log, not a runtime**, with the
contract pinned rather than implied:

- **Turn-scoped or nothing.** `spawn(fut, Editor::saved)` pushes onto a buffer the dispatcher
  installs for this transaction and restores on unwind (`thread::scope` shape — user code never
  owns the buffer). Outside a turn it is a located error; inside `view`/scopes (read phases) it
  is a located error; `#[track_caller]` names the offender.
- **Routing is checked like any handler.** The completion method's receiver must match the
  current transaction's owner (same `TypeId` + location check as handler lowering); a mismatch
  is a located error at the call, not a misdelivery.
- **Owner-scoped by default**: logged work cancels with the owner, identically to a returned
  `Task`. Tests cannot tell the two spellings apart — `Turn::run` drains one log;
  `expect_work().spawned(n)` counts both.
- **It cannot do anything else.** No cell creation, no key resolution, no TLS graph selection
  (the `Signal::new` ban stands untouched) — the buffer accepts effect values, period. The
  inspector lists each turn's effects with caller locations and eventual cancellation cause, so
  the "hidden effect system" objection is answered with visibility instead of prohibition.

Returns remain the *testable contract* (a handler whose signature says `-> Task` documents
itself) and the taught form for handlers; `spawn` is for the helper five frames down. Reject
inherent `self.spawn` on domain structs; reject `cx: &mut Context` on handlers; both remain
rejected.

One more ergonomic note, because it applies to every handler position: closures work everywhere
fn items do (the blankets are `FnMut`-shaped), the annotation being the only tax —
`.on_click(|c: &mut Counter| c.count += 1)`. The annotation-free inline form is the same
associated-fn pinning trick as `Self::scope`, verified on stable:
`.on_click(Self::act(|this| this.count += 1))` pins `O = Self`; `.with(args)` composes with all
of these because its output is just another `FnMut`. No macro anywhere.

### `Signal<T>` is an owning handle, and the ownership rules are load-bearing

Signals live inside domain data — `filter: Signal<String>` in a struct, `progress: Signal<f32>`
inside an enum variant inside a `Vec` item. That placement is the whole gradient, and it pins the
representation (each rule below was adversarially checked):

- **The cell is heap/arena-indirected, never inline.** A `Vec` push reallocates and moves its
  items; an inline cell would dangle under any live wire. `Signal<T>` is a stable handle; moving
  or swapping the *handle* is always safe. The per-signal allocation is the stated cost of
  "no `Scope` capability to construct" — `Signal::new(v)` self-owns its cell and mints its source
  identity lazily, registering with the consuming runtime on first wire, so no ambient/TLS runtime
  is introduced (the 03/04 ban stands).
- **`Signal<T>` is `!Copy` and `!Clone`.** `Copy` and `Drop` are mutually exclusive: a Copy key
  cannot own a cell in a `Vec`/enum. `#[derive(Clone)]` on signal-bearing domain data would
  otherwise silently alias the reactive cell across "copies". Making it `!Clone` turns that
  reflex into a compile error and a located decision: `signal.share()` when you *mean* shared
  writers, a fresh `Signal::new(snapshot)` when you meant a copy. You can pick two of:
  (1) `Signal::new` with no `Scope` and no TLS, (2) Copy, (3) cell lifetime tied to the domain
  location. This design picks **1+3**. Intern-on-wire does not make Copy safe.
- **Cell storage is a pool** the owning handle's `Drop` returns to. Same public type. First
  `Signal::new` creates it (lazy). This is the only arena that satisfies 1+3.
- **`SignalRef<T>` is the `Copy` companion.** `signal.reader()` yields a copyable, read/wire-only
  handle for task closures, `text!` holes, and cross-component wires — 03's cheap capture without
  aliasing writers.
- **`scope.slot(v) -> SignalKey<T>`** is 03's Copy key, and it **requires a Scope**. Do not
  advertise it as a capability-free fast path.
- **Signals are runtime state, not data.** `Signal` opts out of `Serialize`; persist the snapshot
  into a plain field and rehydrate into a fresh signal on load.
- **The cell may outlive its holder by at most one turn.** Dropping the `Active { progress, .. }`
  variant drops the owning handle, but a still-leased wire keeps the cell alive until its span
  retires at the end of the turn. Documented, tested, and bounded — not "dies instantly with the
  variant."

### Controls: two-way is the reference move; `on_change` is interception

A control's primary value is its **constructor argument** — `slider(x)`, `checkbox(x)`,
`text_input(x)`, `progress_bar(x)`, `select(x, options)`. There is no `.value()` property for the
thing the control *is*. The triad then picks the mode with no extra API:

- **`&Signal<T>` → live two-way.** The control renders from the signal and writes user edits back
  into it through the ordinary staged signal transaction. No handler. Echo-safe: edits carry
  origin + version, so the control's own wire acknowledges its echo instead of replaying it
  (03 §1.5's rule, kept verbatim).
- **Value / `&plain_field` → controlled snapshot.** The host is the only writer; attach it with
  `.on_change(Self::set)` or, for collection items, the bound-argument form
  `.on_change(Board::rename_card.with(id))` — naming the write target is irreducible without
  lenses or a field derive, but it costs a method path plus `.with`, not an annotated closure.
  An editable control with a snapshot and no writer is a dev-build "inert control" warning; if
  that proves too weak, the typestate upgrade is mechanical (constructor returns
  `Control<NeedsWriter>`, `.on_change` discharges to `Control<Ready>`, only `Ready` is a child —
  a compile error instead of a warning) and is reserved as a decision, not promised as a
  guarantee.

`on_change` on a signal-bound control is observation/interception (fires after the committed
edit — validation, kicking off a save task), never the data path. Text keeps 04's richer
document/`TextFieldState` contract for heavy editing; `&Signal<String>` covers the search-box
class. Reversible adaptation stays descriptor-shaped (`slider(&self.volume).map_range(db, db_inv)`).

This closes the loop on why signals are not merely a performance tool: **a field that widgets or
tasks write directly is, by definition, a field with non-owner writers — which is exactly what a
signal is.** Ergonomics and granularity are the same decision made once, at the field.

One collection consequence, found the hard way: if `keyed(...).revision(...)` rows also read a
shared input (a filter, a selection), a change to that input bumps no item revision and the rows
would skip, stale. Shared row inputs are therefore declared: `keyed(...).revision(...).with(&filter)`
re-runs rows when the declared input changes. At small scale the right spelling is plain iteration
plus the tape diff; `.with()` exists for the 10k-row case only.

### Collections are cells too: the reference move is the scale answer

The earlier collections story had three rungs (`Vec` + diff, `List` methods, returned
`ListDelta` hints) and a standing confusion: a returned delta *looked* like it skipped `view()`
and didn't. The fix is not better documentation of three rungs — it is noticing that the triad
was never applied to collections. Apply it:

- **Value move** — `self.columns.iter().map(...)`: the collection is *contained* in this
  producer's description. Rerun + keyed tape diff. `Vec<T>` stays plain and stays the default;
  `Vec::push` cannot notify and never pretends to.
- **Reference move** — `.children(&col.cards, Card::view)`: a reference and a function, the
  same pair as every other move. There is no `list(...)`/`.row(...)` wrapper ceremony for the
  common case; the `list(...)` / `virtual_list(...)` builders exist only when the *list itself*
  has chrome (`.selected`, `.pan`, `.scroll_y`, windowing); arrangements live on the collection
  reference itself (`col.cards.filtered(input, f)`, `.sorted(..)`, `.with(input)`), so the pair
  form stays uniform. **`List<T>`** is the
  collection cell, and its identity is **derived, not declared**: every insertion mints a typed,
  `Copy`, generational **`Slot<T>`** — no id newtypes, no `next_id` counters, no key parameter
  to forget. `Slot<T>` is *item* identity, not position: slots transfer between containers of
  the same `T`, which is what lets a caret survive a cross-column drag. Domain-keyed data (DB
  rows, persistence) upgrades with one optional parameter — `List<Thread, ThreadId>` via
  `.keyed_by(Thread::id)` — the upgrade, never the default. Ops (`push -> Slot<T>`,
  `insert_at`, `take`, `move_to`, `edit(slot, f)`) publish typed splices; the parent producer
  records **one list-wire record** — a parent rerun re-checks one version and does **not**
  iterate items or run row functions. Push runs the row for the new item only; a move is a move
  by construction; `edit` reruns one row. Drag payloads, drop targets, and selection carry
  slots: `Drop<Slot<Card>, Slot<Column>>` — typed addressing the container derived for you.

Wired rows are honest producers with a machine-checked read set: `fn(&Thread) -> impl Element
+ '_` has no `&self`, so it *cannot* read undeclared owner state — the borrow checker closes the
loophole that made list skipping unsound everywhere else in this design. Shared inputs are
declared cells (`.with(&self.selected)` → `fn(&Thread, &ThreadId)`), versioned like any wire;
per-row live values stay wires (`progress_bar(&item.progress)`); a signal read inside a wired
row subscribes *that row's* producer. Handlers on the item type route to the row's own slot
(§ above). And because `List` ops are a sealed delta set with known inverses, wired-
collection mutations are **journal-eligible for undo**, same bright line as descriptors.

This dissolves the old G1 workload instead of optimizing it. The 2,000-element owner view was
never 2,000 elements of chrome — it was a collection plus chrome. Wire the collection and a
human-rate click on that view costs **O(chrome) + O(changed rows)**: the view still reruns, but
the list contributes one version check. There is nothing left to misread, because there is no
returned-delta API at all anymore: *what the description contains is what reruns, and the move
you used says what it contains.*

Two residual rules:

- **Prefer plain collections of signal-bearing items over `Signal<Vec<_>>`.** A signal-of-vec
  subscribes consumers to every structural change at once and its snapshots alias inner cells;
  `List<Item>` (wired) or `Vec<Item>` (contained) with signal fields for hot properties
  is strictly better on both axes.
- **`ComponentMap<K, T>` is the wired collection of components** — the same slot machinery with
  owner lifecycles per item; one story, not two.

### Identity: always the container's or the site's — never the element's

The endgame, stated first: **there is no `.key()` method on elements.** Identity is a property
of a *container* (`List` slots, `keyed(...).by(...)` at the parent, the grid's
`(row_key, col_key)`, the tree's node id) or of the *embedding site* (`#[track_caller]` +
enclosing keys). An element never re-annotates a slot its container already owns, and a random
`div` never carries an identity annotation at all. The full table:

| Situation | Identity lives | Annotation on the element |
|---|---|---|
| `list(&keyed)` / `virtual_list` / `grid` / `tree` | container slot / `(row, col)` / node id | **forbidden** — the container owns it |
| `Vec` + contained rows with stateful widgets | the parent-level adaptor: `keyed(&vec).by(Card::id)` | none — keys are declared *once, at the collection* |
| Stateless chips (`text`, `button`) in a plain `.children(iter)` | embedding site + content-hash alignment | none — and lowering **rejects** a `text_input` here |
| Static children | `#[track_caller]` embedding site | never |
| `hero(id)` | continuity across *structural swaps* | a different noun on purpose — never spelled `.key` |
| Two sibling instances of the same scope | the scope's owned input | `scoped(discriminator, Self::panel)` — the input *is* the instance identity |

Two rules make the table safe rather than merely tidy:

1. **Enforced-absent is checked at lowering.** Elements that require durable identity
   (`text_input`, focusables, component children, `hero`, capture-taking gestures) inside an
   *unkeyed* dynamic run are a **located mount error** naming both fixes — "declare keys at the
   collection (`keyed(...).by(...)`), or wire it (`List`)." This generalizes 04's
   virtual-list rule to every dynamic collection and converts React's "you forgot a key and
   lost focus" into a deterministic authoring-time error. Stateless rows stay unkeyed and free.
2. **`Vec` is not deprecated by this.** Forcing every collection into `List` would delete
   the plain-Rust default; keys for contained collections move to the *constructor-level
   adaptor*, not onto row widgets — the declaration happens once where the collection enters
   the description, which is also the only place the diff needs it.

Optimistic edits ride the same staging machinery as two-way binding:
`signal.optimistic(new_value, future)` stages the value now (visible immediately), retains the
inverse plus a conflict generation, and on completion drops the inverse (success), reverts only if
the generation is still current (failure), or applies the canonical server value. This is 04 §10's
optimistic contract narrowed to one cell — the networked-app gap called out in the feedback pass,
closed at the signal seam.

## 3. Why there is no "skip" — and why that's the right answer

The tempting feature is: keep every handler `fn(&mut Self)` and have the runtime *detect* that a
particular transaction only touched signals, skipping the rerun. Every mechanism for that detection
was examined and fails the project's own principles:

1. **Per-field versioning via derive** — a `#[derive(Reactive)]`-shaped scaffold (03's model).
   Rejected: the whole point of the value register is that plain structs stay plain.
2. **Snapshot + compare `Self`** — imposes `Clone + PartialEq` on arbitrary application state and
   costs more than the rerun it saves. Rejected.
3. **Receiver annotation** — 04's answer. Rejected by this amendment as an effect system.
4. **Write-watching via MMU page protection** — genuinely possible, genuinely insane: platform-
   specific, false-sharing-prone, and it turns "plain Rust" into "plain Rust plus a segfault
   handler." Noted for completeness, rejected with affection.

The conclusion is not a compromise; it is the actual insight. **Input-change detection on untracked
plain state is impossible without annotations — so detect output change instead, at the cheapest
stage.** The rerun *is* the change detector: it re-derives the description (the ~50µs artifact) and
the tape diff cuts propagation before anything expensive happens. Output equality is strictly
stronger than input equality — a plain-field change that doesn't affect this view's output produces
zero downstream work, something no input-tracking system can promise. Signals then have a crisp,
honest role: they are *declared inputs*, for when you want to skip even the re-derivation and gain
sub-description entry points (patch at paint, patch at composite) that no diff can reach.

So the two halves are not "fast register / slow register." They are two placements of the same
equality cut:

```text
plain Rust   -> output diffing:  rerun description, cut at the tape, pay O(description)
signals      -> input tracking:  skip description, cut at the source, pay O(readers)
```

Both are fine-grained *below* the description stage. They differ only in whether the description
stage runs — the stage the Azul measurements show is nearly free when the memory story is right
(bump-allocated draft pages, no per-label Arc, borrowed text straight through lowering — all
already in 04 §1).

## 4. The plain register's waste mechanisms

"Rebuilt on every frame" is the mental model; the implementation is better than the mental model,
and every mechanism is either invisible or ordinary Rust:

1. **Rebuild on transaction, not on frame.** Unchanged from 04: no fact read, no hidden polling.
   An idle app runs nothing. A component whose owner wasn't dirtied isn't re-described when its
   parent is (component boundaries stay revision walls). `time::frame()` remains the explicit
   opt-in to genuine per-frame re-description — immediate mode where you actually mean it.
2. **The tape diff.** Description emits compact opcodes into bump pages; spans carry rolling
   content hashes keyed by `#[track_caller]` call site + `.key(...)`. Unchanged span → skip
   canonicalization, layout, text, paint for that range; byte-identical emission degenerates to a
   memcmp. Moves are detected as moves (keyed spans realign), not as delete+create. The diff runs
   at the tape — *before* lowering — so its cost is proportional to description bytes, not to
   retained-tree size. Positional identity via `#[track_caller]` is Compose's positional
   memoization landed as a stable-Rust attribute instead of a compiler plugin. One honest limit:
   the diff subsumes *downstream* cost (shaping, layout, paint), never formatting cost —
   `format_args!` still runs on every rerun of its producer. The opt-ins: `text!("{} matches", unread)`
   interned template + `Signal`/`SignalRef` holes (patch the hole, no reformat); `text(format_args!(...))`
   as a *call-site macro* rewrite; `text(Self::match_label)` format-as-function. Stored
   `fmt::Arguments` is impossible. Nanoseconds for a counter; wrong for large or machine-rate
   formatted text, which should be a hole or a `&Signal<String>` wire.
3. **Wire the collection.** The dominant O(n) content of any big view is a collection; the
   reference move (§2) takes it out of the description: `list(&self.threads)` /
   `virtual_list(&self.threads)` over a `List` contributes one version check to a parent
   rerun, and its ops splice rows without any diff. `Vec` + iteration stays the contained
   default with keyed tape diff; `keyed(...).by(..).revision(..)` and the revision auditor carry
   over for contained collections at scale. There is **no returned-delta API**: you cannot
   observe `Vec::push`, so nothing pretends to; `List::push` notifies because the type is a
   cell. Do not invent a parallel diff-native vec; do not treat a diff stream as keyed identity.
4. **Explicit memo where you want it.** `.child(scoped(inputs, Self::part))` skips the function
   entirely when its owned inputs compare equal and no signal it read changed. This is the only
   opt-in memo in the system, it is spelled as "a function plus its arguments," and nobody is
   required to know it exists. Do **not** skip `fn(&Self)` scopes on owner dirty: they can read
   untracked plain fields. Tracked children (wires, `scoped`, signal-only records) may reuse tape
   pages across a parent rerun as an impl detail.
5. **Machine-rate events are not `fn(&mut O)`.** `PointerMove` / `Scroll` / `DragDelta` do not
   impl `OnEvent` for `fn(&mut O)` — compile error, `_owner` escape. Click stays `fn(&mut Self)`.
   `.scroll_y` / transform / caret accept `&Signal` / `SignalRef` / `Projection` only
   (`IntoLiveWire`; `#[diagnostic::on_unimplemented("scroll_y must be a live wire")]`).
   `.pan(Pan::VERTICAL)` is the compositor claim that keeps list scroll on the motion lane —
   not a recognizer losing a race after 8px of slop. Snapshot scroll uses a named escape.
6. **Static-chain folding stays an optimization, not a semantic.** Literal-only builder chains can
   const-fold to static tape segments (P8); the runtime may dedup identical emission bytes across
   reruns. No claim is made that user control flow is skipped — user Rust always runs; only its
   *output's consequences* are deduplicated. Do **not** build persistent opcode ropes to fix G1.
   G1's cost is running `view`, not sibling memcmp. Draft pages are reclaimed after lowering.
7. **The cost lens and CI budget** carry over: a beginner's 2,000-element single-owner view is a
   visible budget failure naming the biggest child spans, not profiler archaeology.

## 5. The cost table is the syntax

Every row derivable by looking at the code, none requiring a receiver convention:

| You write | What runs on change |
|---|---|
| `text(self.count)` — a value | nothing by itself; refreshed when the enclosing producer reruns |
| `on_click(Self::increment)` — `fn(&mut Self)` | this component's `view`, then tape diff (usually a few slot patches) |
| `.scroll_y(&self.scroll_y)` — a reference | that slot, entering at its output stage; no Rust |
| `.background(self.sel.map(f))` — reference + function | `f`, then that slot |
| `.child(Self::overlay)` — a function | that function, when a signal it read changes; diffed on owner reruns |
| `signal.get()` in `view`/scope | the enclosing producer |
| `on_click(Board::add_card.with(id))` — bound-arg method | owner transaction, same as any `fn(&mut Self)`; no closure |
| `on_click(self.count.add(1))` — mutation descriptor | count's readers only; typed and journal-eligible |
| `on_key(self.sel.update(Selection::apply))` — `fn(&mut Selection, _)` | selection's readers only; `view` never runs |
| `on_key(Selection::apply_key)` — type-routed method | the wired `Selection` cell's readers; unwired/ambiguous = located error |
| `on_scroll(&self.scroll_y)` — input piped to a signal | wires only; zero user Rust per event |
| `.child(Self::scope(\|this\| …))` — inline closure scope | same as a named fn item; wrapper is a newtype |
| `text!("{} matches", unread)` — interned template | hole patch; no reformat of the template |
| `list(&self.threads).row(Self::row)` — wired collection | ops splice rows; a parent rerun checks one version, iterates nothing |
| `self.threads.push(t)` / `.edit(k, f)` — `List` op | the new/edited row only; journal-eligible splice |
| `row().on_click(Thread::toggle)` in a wired row | that row's slot; the row reruns |
| `.pan(Pan::VERTICAL)` | compositor claim; list scroll stays on the motion lane |

Keystroke trace for the editor above: key event → selection signal transaction
(`Selection::apply_key`, plain Rust on plain data) → two wires patch (caret transform at
composite, selection background at paint) → overlay scope version-checked, unchanged → present.
`Editor::view` did not run, and nothing in the code had to *say* so — it was unsayable any other
way.

Preferences-dialog trace: `fn(&mut Editor)` handler mutates three plain fields → owner transaction
→ `view` reruns (~µs) → tape diff: toolbar span changed, surface span hash-equal → toolbar
re-lowers; wires re-checked by version, no-op → layout/paint for the toolbar range only.

## 6. What this deletes from 04, and what it keeps verbatim

Deleted or renamed at the authoring seam:

- **`&Self` shared handlers** — replaced by `signal.update(f)` and type-routed methods. No
  handler on `Self` has two borrow modes anymore.
- **`update_in` / `Draft<T>` / `Host<O>`** — deleted (§2). The owner-alias-of-a-drafted-cell
  fact is unspellable once the API that created it is gone; `.reading(args)` covers extra data.
- **The separate `TaskHandle` type and free `emit`** — collapsed into `Task` as a value whose
  position is its lifetime (§2). `spawn` survives, redefined: it is the mid-stack spelling of
  the *same* owner-scoped log entry a returned `Task` writes — one mechanism, two scopes
  (owner-scoped vs field-owned), zero taste.
- **Returned `ListDelta` hints** — deleted. Collections are contained (value move) or wired
  (reference move, `List`); there is no third rung to misread. The delta algebra survives
  internally (ops, oracles, undo journal), never as a handler return.
- **`region` / `region_with`** — genuinely subsumed: `.child(Self::part)` via the
  marker-parameterized `IntoElement` (§1), `.child(Self::scope(|this| …))` for inline closures,
  and `.child(scoped(input, f))` for the owned-input form. The producer record underneath is
  unchanged; only the noun died.
- **`signal.bind(f)`** — replaced by `signal.map(f)` (a wire-granularity function; same record).
  The conversion trait is renamed to match the noun: `IntoWire<T>` / `Wire<T>`, not
  `IntoBindable` / `Bindable`.
- **`view(&mut self)`** — becomes `view(&self) -> impl Element + '_`. Describe = read,
  mutate = write, uniformly. `Ui<'_>` remains the nameable return of retained scope producers.
- **The "two registers" framing and the boats citation** — retired. The registers this design
  needs are ones Rust already ships: values, references, functions. Nothing is "entered"; there is
  no boundary to mark, so nothing marks it.
- **The receiver-based cost table and the `&mut`-dirties-even-signal-writes trap** — the trap no
  longer exists, because there is no receiver whose borrow mode selects cost. An owner handler
  that only writes a signal still reruns the view *and that's correct pricing*: it claimed
  `&mut Editor`, meaning it reserved the right to change anything; the diff makes the claim cheap.
  The lint 04 wanted ("this `&mut self` handler only touches signals") survives as a code action
  that rewrites it to `signal.update`, but it's a refactor hint, not a semantic patch.

Kept verbatim underneath: the producer/span protocol (view, scope, and wire are all just producers
with invalidation classes owner/region/property — the §4 protocol of 04 doesn't change by one
field), the turn protocol and its bounds, `Component<T>`/owner/site/span records, `Ui<'a>`
lifetime discipline, `IntoWire`-style coherence for value-vs-reference properties (including
the honest note that a fully blanket source impl can't coexist with `&T` on stable), `Emit`/
`Task`/effects, `ComponentMap`, `keyed`, `virtual_list`, identity (`#[derive(Id)]`, `.key`,
lexical `&Ui`), capabilities, testing, the inspector, and every pipeline/renderer contract.

Named survivors worth re-marketing rather than folding into "the protocol" (the feedback pass
flagged each as load-bearing):

- **Error boundaries**: `boundary(Self::plugin_view).recover(Self::plugin_crashed)` attaches to
  the function move — a scope is already an independently-invoked producer, so the unwind
  containment of 04 §1 seats there unchanged. One bad extension must not take the host down.
- **Held transitions**: `.scope(held(Self::route_view).until_ready().timeout(300.ms()))` — keep
  the outgoing branch live and interactive while the incoming one settles, commit atomically.
  A combinator on scopes, not a lifecycle.
- **Undo has a bright line, stated plainly.** Arbitrary `&mut Self` and `signal.update(f)` writes
  are not capturable inverses — 03's free time-travel does *not* carry. What carries: 04 §12's
  opt-in `commit("label")` / `Track<T>` / `Change<M>` for owners, unchanged; plus, for free,
  mutation descriptors (`.add(1)`, `.toggle()`) are drawn from a sealed set with known inverses,
  so descriptor writes to signals are journal-eligible. "Typed edits are undoable; arbitrary
  `&mut` is not" is the honest pitch.
- **The compile-time leapfrog list** survives untouched and should stay named: coordinate-space
  typing, text units, typed drag payloads (`Drop<P, T>`), single-writer `LayoutCell` by-value
  consumption, `Color`/`LinearColor` split, motion typestate, reliable-queue idempotency keys,
  interactive-virtual-rows-require-`.key`. None depended on the register mechanism.

## 7. The sealed typing story

All conversion and handler bounds are sealed, carry `#[diagnostic::on_unimplemented]` text that
names what the position actually accepts (and says the trait is sealed — the default "consider
implementing" hint is actively wrong here), and erase at recording, so nothing generic propagates
into `Ui<'a>` or any caller's type. Verified against coherence and coercion rules:

```rust,ignore
// Read properties — was IntoBindable; renamed to match the noun.
pub trait IntoWire<T>: sealed::Sealed { fn into_wire(self) -> Wire<T>; }
impl<T: 'static>     IntoWire<T> for T                 {}  // owned snapshot
impl<'a, T: 'static> IntoWire<T> for &'a T             {}  // borrowed snapshot until lowering
impl<'a, T: 'static> IntoWire<T> for &'a Signal<T>     {}  // live wire (clones the SourceId)
impl<T: 'static>     IntoWire<T> for SignalRef<T>      {}  // Copy read handle (task-friendly)
impl<A: 'static, T>  IntoWire<T> for Projection<A, T>  {}  // signal.map(f) result
// Deliberately NO blanket over a Source trait — coherence overlap with &T (04 §3's wall).
// Custom sources implement the concrete pair or return an explicit Wire<T>.

// Editable controls — two-way and controlled coexist on one constructor argument.
pub trait IntoEditable<T>: sealed::Sealed { type Writeback; /* TwoWay | Controlled */ }
impl<T: 'static>     IntoEditable<T> for T             { type Writeback = Controlled; }
impl<'a, T: 'static> IntoEditable<T> for &'a T         { type Writeback = Controlled; }
impl<'a, T: 'static> IntoEditable<T> for &'a Signal<T> { type Writeback = TwoWay;     }

// Handlers — fn items implement Fn natively, so items, closures, and adapters all flow
// through ONE blanket per arity. Event-bearing variants are separate method names because
// Rust cannot overload Fn arity in coherence (04's conclusion, kept).
impl<O: 'static, F: FnMut(&mut O) + 'static>          OnClick<O>        for F {}
impl<O: 'static, Ev, F: FnMut(&mut O, Ev) + 'static>  OnClickEvent<O,Ev> for F {}

// Event positions with multiple faces: distinct impl types, no overlap.
impl<O: 'static, Ev, F: FnMut(&mut O, Ev) + 'static> OnEvent<Ev> for F {}                  // owner
impl<T: 'static, Ev> OnEvent<Ev> for SignalUpdate<T, Ev> {}                                 // signal.update(..)
// The owner blanket is generic over its receiver type, so `on_key(Selection::apply_key)`
// already typechecks with O = Selection. Routing is a LOWERING rule, not trait machinery:
// receiver == owner → owner cell; receiver == exactly one wired cell → that cell; receiver
// == the item type inside a wired row → that row's slot; else a located error naming the fix.
impl<'a, T: EventSink<Ev>, Ev> OnEvent<Ev> for &'a Signal<T> {}                             // event sink
// EventSink is per-pair: on_scroll(&pixels_signal) compiles; on_key(&pixels_signal) does not.

// The closure-annotation killer: bind leading args off a method's fn item.
pub trait BindArgs<O, A>: sealed::Sealed {
    fn with(self, args: A) -> impl FnMut(&mut O) + 'static;
}
impl<O: 'static, A: Clone + 'static, F: Fn(&mut O, A) + 'static> BindArgs<O, A> for F { /* … */ }

// Children: marker-parameterized so values, Elements, and fn scopes coexist coherently.
// (A naive Fn-blanket E0119s against the Ui impl; distinct markers are the stable-Rust fix.)
#[diagnostic::do_not_recommend]
impl<'a, E: Element + 'a> IntoElement<'a, AsElement>  for E {}   // Ui<'a> is the erased Element
#[diagnostic::do_not_recommend]
impl<'a, O: 'static, F: for<'b> Fn(&'b O) -> Ui<'b> + 'static>
                          IntoElement<'a, AsScope<O>> for F {}   // .child(Self::overlay_view)
impl<'a, O, F>            IntoElement<'a, AsScope<O>> for ScopeFn<O, F> {} // Self::scope(|this| …)
impl<'a, I: PartialEq + 'static, F>
                          IntoElement<'a, AsScopeWith<I>> for Scoped<I, F> {} // scoped(input, f)

// Machine-rate ports: cadence is a property of the event / port type.
pub trait IntoLiveWire<T>: sealed::Sealed {}
impl<'a, T: 'static> IntoLiveWire<T> for &'a Signal<T> {}
impl<T: 'static>     IntoLiveWire<T> for SignalRef<T> {}
impl<A, T>           IntoLiveWire<T> for Projection<A, T> {}
// Scroll / PointerMove / DragDelta do not impl OnEvent for fn(&mut O).
```

Two things the type story deliberately does not attempt: making `Ui`/builders generic over the
owner to infer closure receivers (it would infect every stateless helper and library signature
with an owner parameter — the single-concrete-`Ui` property is worth more than the annotation it
would save, and `.with` saves it anyway), and using fn-pointer *addresses* as identity (see §8).
Owner mismatch on a lowered handler stays a located runtime error via recorded `TypeId` + source
location, exactly as in 04.

## 8. Frontier mechanics this leans on

- **`#[track_caller]` positional identity** (stable) — span and scope identity without macros,
  ids, or a compiler plugin; the loop case falls back to explicit keys exactly where Compose and
  SwiftUI also require them.
- **Interior-mutability split borrows** (stable, ancient, underused) — `(&mut Selection, &Editor)`
  in one signature is the entire replacement for the `&Self` handler register, and it's checked by
  rustc today.
- **fn-item types and method paths as values** (stable) — `.child(Self::overlay)`,
  `signal.update(Selection::apply_key)`: no closure boxing on the common path and no coercion
  friction anywhere, because fn items implement `Fn` natively and every bound that accepts them
  (handlers, marker-based children) is `Fn`-shaped. One correction from the adversarial pass: the
  fn value carries *behavior only* — fn-pointer addresses are not identity (linker ICF merges
  identical functions and duplicates them across codegen units), so producer identity always
  comes from the `#[track_caller]` embedding site + keys, never from the pointer.
- **Precise capture `use<..>`** (stable 1.82; RPITIT 1.87) — **crate-internal only.** Application
  signatures are `impl Element + '_`. Internals that take `&self` plus a borrow they actually
  return use `use<'t>` so Rust 2024's default-captures-everything rule does not pin the element
  to `self`. Never a public requirement; never in examples.
- **Next-gen trait solver** — coherence default since 1.84. Global solving is watched, never
  load-bearing (P12). It does not make bare closures infer through `IntoElement` (#70263).
  `Self::scope` ships now.
- **`#[diagnostic::do_not_recommend]`** (stable 1.85) — hide marker blankets from suggestions.
- **Rolling content hashes over bump-page opcode streams** — the tape diff's cost model; 128-bit
  hashes with byte-verify on match, SIMD memcmp fast path for unchanged pages.
- **Field projections (RFC 3735), watched** — if per-field projections land, `Signal<T>` could
  someday project `signal.field_x` as a narrower source without a derive. Explicitly *not* load-
  bearing: the design is complete without it; it would only sweeten the `update_in` read side.

## 9. Honest risks and gates

- **G1 — owner-handler rate × view size, dissolved on two axes.** Machine-rate: `PointerMove` /
  `Scroll` / `DragDelta` refuse `fn(&mut O)` (compile error); `.pan()` keeps scroll on the
  compositor. Human-rate × big view: the big content is a collection, and a **wired** collection
  contributes one version check to a rerun — a click on a 2,000-row view costs O(chrome) +
  O(changed rows), not O(description). What remains of G1 is the *contained* spelling chosen
  deliberately (`Vec` + iterate), which pays its documented price, and the pathological
  2,000-element hand-written chrome, which is the budget's business. Do not skip `fn(&Self)`
  scopes; do not build opcode ropes. Gate: kanban click with wired columns/cards emits O(chrome)
  bytes (counter-asserted); drag-selection on the heaviest real view holds frame budget with the
  idiomatic spelling.
- **G2 — diff soundness.** Hash-equal spans must be byte-verified or 128-bit; keyed realignment
  must be fuzzed against the from-scratch oracle (P10 applies to the tape diff too).
- **G3 — scope/span identity.** Identity is the embedding site in the parent + enclosing keys
  (04 §7's token rule), never a constructor's internal line or a fn-pointer address; helpers that
  forward identity must be `#[track_caller]`, with a dev-build collision auditor. A scope moving
  between parents is a remount — correct, just not free; `.key` covers the dynamic case. Needs
  the same keyed-span tests as collections.
- **G4 — draft isolation and `.reading` freshness.** With the owner alias deleted, one surface
  remains, and its semantics are pinned: `.reading(&plain)` snapshots **at producer emission**
  (stale until the enclosing producer reruns — documented, tested, and cheap; never cloned per
  event); `.reading(&signal)` is a wire, live at event time. The drafted cell's own reference is
  rejected by the adapter (typed); the leftover dynamic `edit` / inspector escape lints `.get()`
  on a cell being drafted; re-entrant `update` on the drafted cell is a located error, never UB
  and never a bare `RefCell` panic. Fuzz per P10, including the staleness window (mutate keymap,
  don't rerun the view, fire the key event — the snapshot must be *observably* the old one, not
  torn).
- **G10 — wired collections.** The wired list's op-driven splices are fuzzed against the
  contained-oracle (render the same data via the value move; outputs must match — P10). Row
  read-set enforcement is compile-tested (a row fn cannot name `&self`); shared inputs are
  version-checked; the click-cost counter from G1's gate is asserted here. Slot identity
  continuity (focus/hero across moves) gets the keyed-span test suite.
- **G7 — dirty-producer ordering.** When one turn dirties both an owner and a signal read by that
  owner's scope, producers run parent-before-child; a parent rerun subsumes the scope's
  independent dirty flag, and stale-generation signal wakes are dropped. The both-woken-in-one-
  turn case gets an explicit double-run/zero-run test.
- **G8 — cell lifetime beyond its holder.** A signal dropped with its enum variant survives at
  most one turn while a retiring span still leases it. Bounded, documented, fault-injected
  (cancel-mid-stream is the fixture).
- **G9 — marker-trait diagnostics.** The `IntoElement<'a, M>` marker pattern (§1) produces
  cryptic inference errors by default (Bevy's known tax). Every marker bound carries
  `#[diagnostic::on_unimplemented]` text naming what `.child` actually accepts (`Self::scope`,
  `impl Element + '_`, live-wire ports); marker blankets take `#[diagnostic::do_not_recommend]`.
  CI snapshots the rendered errors with trybuild — a malformed diagnostic degrades silently, so
  the error text is itself a tested artifact. Trybuild also covers: capture-free `Self::scope`
  compiles; borrow capture is E0373; `Copy` `Element` binds twice; `Ui` reuse is E0382 with G9
  text; machine-rate `fn(&mut O)` is a type error.
- **G5 — `view(&self)` removes scratch mutation.** Memo caches move to handlers, signals, or
  `scoped` inputs. Audit the real Zed views for patterns that genuinely needed `&mut` during
  description; if any survive contact, the fallback is interior scratch on the component, not a
  receiver change.
- **G6 — coherence of value-vs-reference properties.** Unchanged risk from 04 §3 (no blanket
  source impl alongside `&T`); the triad makes the reference spelling more central, so the
  conversion set needs trybuild coverage early.

## 10. The pitch, in the project's own terms

04's principle was "the producer is ordinary Rust; named fact reads choose its wake set." This
amendment finishes the thought: **the mutation is ordinary Rust too, and the type it mutates
chooses its wake set.** No second trait. No receiver contract. No effect system — the borrow
checker, applied to data, is the only checker involved. Signals are not a register you enter;
they are smaller cells you carve when a cell's readers are worth naming, and the display tree
picks up the benefit through the three moves Rust already has: pass the value, pass the reference,
pass the function.

## 11. Complete worked examples

Three examples, deliberately whole. Counter (in §1) is the floor. Kanban is the gradient.
Downloads is signal-inside-enum. Inbox is every high-perf opt-in at once. The seams — where a
closure is required, where `Ui` vs `impl Element + '_` is required, what each interaction
costs — are exactly the non-obvious parts.

### Kanban — the wired board

This is the example that lives every rule at once: wired collections, slot-routed handlers, zero
element keys, zero `.with(id)` plumbing, and the O(chrome) claim the G1 gate counter-asserts.

```rust,ignore
#[derive(Default)]
struct Board {
    columns: List<Column>,      // identity is derived: every insert mints a Copy Slot<Column>
    filter: Signal<String>,
}
#[derive(Default)] struct Column { title: String, cards: List<Card> }
#[derive(Default)] struct Card   { title: String }

impl Column {
    fn set_title(&mut self, title: String) { self.title = title; }
    fn add_card(&mut self) { self.cards.push(Card::default()); }   // -> Slot<Card>, ignorable
}
impl Card {
    fn set_title(&mut self, title: String) { self.title = title; }
}

impl Board {
    fn add_column(&mut self) { self.columns.push(Column::default()); }

    fn move_card(&mut self, drop: Drop<Slot<Card>, Slot<Column>>) {
        // Crossing two cells is owner territory. `drop.source` exists because the payload's
        // slot knows its container, and the slot is ITEM identity — it transfers.
        let card = self.columns.edit(drop.source, |col| col.cards.take(drop.payload));
        self.columns.edit(drop.target, |col| col.cards.insert_at(drop.index, drop.payload, card));
    }
}

impl View for Board {
    fn view(&self) -> impl Element + '_ {
        column()
            .child(row().gap(8)
                .child(text_input(&self.filter).placeholder("Filter cards…"))  // two-way
                .child(button("Add column").on_click(Board::add_column)))
            .child(row().gap(12).children(
                self.columns.with(self.filter.reader()),   // wired + one declared live input
                Board::column_view))                       // fn(&Column, SignalRef<String>)
    }
}

impl Board {
    fn column_view(col: &Column, filter: SignalRef<String>) -> impl Element + '_ {
        column_shell().width(280)                      // no key — the slot owns identity
            .drop_target()                             // target = this slot's ColumnId
            .on_drop(Board::move_card)                 // spans two cells ⇒ owner handler
            .child(text_input(&col.title)
                .on_change(Column::set_title))         // routed to THIS slot; no id plumbing
            .child(column().gap(6).children(
                col.cards.filtered(filter, |card, q| card.title.contains(q)),
                Board::card_view))                     // reference + function, nothing else
            .child(button("Add card").on_click(Column::add_card))   // fn(&mut Column) — this slot
    }

    fn card_view(card: &Card) -> impl Element + '_ {
        card_shell()
            .draggable()                               // payload = this slot's CardId
            .hovered(paint().background(theme::surface_hover()))
            .child(text_input(&card.title).on_change(Card::set_title))
    }
}

fn main() { gpui::run(Board::default()); }
```

`Board` has exactly two methods that see `&mut self`, and both genuinely span cells. Everything
else routes to the slot that owns the data. The traces:

- **Card-title keystroke**: `Card::set_title` routes to that card's slot → one card row reruns →
  one text slot patch. `Board::view` does not run.
- **Add card**: `Column::add_card` routes to the column's slot → that column row reruns (~15
  elements) + one card splice. `Board::view` does not run.
- **Filter keystroke**: the filter's readers are each inner list's declared arrangement input →
  filters recompute; appearing/disappearing card rows splice; unchanged card rows never
  re-describe; the toolbar is untouched.
- **Add column**: an owner handler → `view` reruns at **O(chrome)** — toolbar plus the row
  shell, ~10 elements — because the wired outer list contributes one version check; then one
  column splice. This is the trace the G1 gate counter-asserts.
- **Drag a card across columns**: hover/preview/autoscroll are protocol lanes; the drop is one
  owner transaction; two column slots republish; and the moved card's span *moves* — a caret
  mid-edit in the card's `text_input` survives the drop, because identity is the slot, not an
  annotation someone remembered.

The contained spelling remains legal and is still the right floor for small boards: `Vec` +
`keyed(&self.columns).by(Column::id)` at the parent, owner handlers with `.with(id)`, rerun +
diff. Same UI; the collection type and the move are the whole difference.

### Downloads

```rust,ignore
struct Downloads {
    client: HttpClient,
    items: Vec<DownloadItem>,
}
struct DownloadItem { id: DownloadId, name: String, url: Url, state: DownloadState }

enum DownloadState {
    Idle,
    Active { progress: Signal<f32>, task: Task },       // the signal lives inside its state
    Done(PathBuf),
    Failed(FetchError),
}

impl Downloads {
    fn start(&mut self, id: DownloadId) {
        let url = self.item(id).url.clone();
        let progress = Signal::new(0.0);
        let task = self.client.fetch(url)
            .progress_into(&progress)    // machine-rate lane: coalesced to newest per UI turn
            .on_done(Downloads::finished.with(id));     // -> Task, stored ⇒ this state owns it
        self.item_mut(id).state = DownloadState::Active { progress, task };
    }
    fn cancel(&mut self, id: DownloadId) {
        self.item_mut(id).state = DownloadState::Idle;  // dropping the Task cancels
    }
    fn finished(&mut self, id: DownloadId, result: Result<PathBuf, FetchError>) {
        self.item_mut(id).state = match result {
            Ok(path) => DownloadState::Done(path),
            Err(e) => DownloadState::Failed(e),
        };
    }
}

impl View for Downloads {
    fn view(&self) -> impl Element + '_ {
        column().gap(4).children(self.items.iter().map(|item| {
            let id = item.id;
            row().key(id).gap(8)
                .child(text(&item.name))
                .child(match &item.state {
                    DownloadState::Idle =>
                        button("Start").on_click(Downloads::start.with(id)),
                    DownloadState::Active { progress, .. } => row().gap(8)
                        .child(progress_bar(progress))  // &Signal in the constructor = wire
                        .child(button("Cancel").on_click(Downloads::cancel.with(id))),
                    DownloadState::Done(path) =>
                        text(format_args!("Saved to {}", path.display())),
                    DownloadState::Failed(e) =>
                        text(format_args!("Failed: {e}")).color(theme::danger()),
                })
        }))
    }
}
```

The shape this teaches: **state-machine transitions are owner transactions** (Start/Done/Failed
each rerun and diff — structure changed, that's correct pricing), while **the continuous interior
of a state is a signal whose lifetime is that state** — owned by the `Active` variant, its wire
dies with the span, and dropping the stored `Task` cancels the fetch (position = ownership, §2). `progress_into` owns the honest
cross-thread caveat: `Signal` is UI-local, so the task machinery marshals chunk updates, coalescing
to the newest value per UI turn and applying one signal transaction — the `SendSource` seam of 04
doing its job invisibly. Progress at any chunk rate never runs `view` and never emits description;
each update is a paint-stage patch of the bar fill.

### Inbox — the high-perf gradient

Same triad. Every hot cell is a type you already have. Unused kit is not in the cost model.
Helpers and `view` return `impl Element + '_`. Independent producers return `Ui` so they satisfy
`for<'a> Fn(&'a O) -> Ui<'a>`.

```rust,ignore
struct Inbox {
    query: Signal<String>,
    selection: Signal<ThreadId>,
    scroll_y: Signal<f32>,
    unread: Signal<u32>,
    overlay: Signal<Option<ComposeId>>,
    threads: List<Thread, ThreadId>,   // domain-keyed upgrade: .keyed_by(Thread::id)
}

struct Thread {
    id: ThreadId,
    title: String,
    unread: bool,
    progress: Option<Signal<f32>>,
}

impl Thread {
    fn toggle_read(&mut self) { self.unread = !self.unread; }   // slot-routed from its row
}

#[derive(Copy, Clone)]
struct Brand;
impl Element for Brand {}

fn chrome(query: &Signal<String>, unread: SignalRef<u32>) -> impl Element + '_ {
    row()
        .child(Brand)
        .child(text!("{} unread", unread))     // interned template + SignalRef hole
        .child(text_input(query))               // live two-way; no handler
}

fn pane(list: impl Element, detail: impl Element) -> impl Element {
    row().child(list).flex(1).child(detail).flex(2)
}

impl View for Inbox {
    fn view(&self) -> impl Element + '_ {
        column()
            .child(chrome(&self.query, self.unread.reader()))
            .child(pane(
                Self::thread_list,                                  // fn item → Ui (retained)
                scoped(self.selection.get(), Self::reading_pane),
            ))
            .child(Self::scope(|this| {
                compose_sheet(&this.overlay)
                    .width(this.overlay.map(ComposeId::open_width).animate(spring()))
            }))
    }
}

impl Inbox {
    fn thread_list(&self) -> Ui<'_> {
        virtual_list(&self.threads)      // reference move: wired; ops splice, reruns don't iterate
            .filter_with(&self.query, |t, q| t.title.contains(q))  // declared, versioned input
            .pan(Pan::VERTICAL)
            .scroll_y(&self.scroll_y)
            .selected(&self.selection)   // two-way: click selects; the wire styles the row
            .on_select(Inbox::selected)  // owner interception, human-rate, optional
            .row(Self::thread_row)
    }

    fn thread_row(thread: &Thread) -> impl Element + '_ {
        row()                            // no .key — the slot owns identity (§2)
            .hero(thread.id)             // continuity noun, deliberately not .key
            .on_click_middle(Thread::toggle_read)   // routed to THIS row's slot
            .child(unread_dot(thread.unread))
            .child(text(&thread.title))
            .child(thread.progress.as_ref().map(progress_bar))
    }

    fn reading_pane(&self, id: ThreadId) -> Ui<'_> {
        editor_surface()
            .selection(&self.selection)             // the wire that makes routing unambiguous
            .background(self.selection.map(ThreadId::tint))
            .scroll_y(&self.scroll_y)
            .on_key(ThreadId::apply_key)            // bare method: routed via the wire above
            .child(text(Self::match_label))
    }

    fn selected(&mut self, _id: ThreadId) {
        // Selection itself was already set by the two-way `.selected` wire; this interception
        // only does the owner-shaped side work.
        self.unread.update(|n| *n = n.saturating_sub(1));
    }

    fn send(&mut self) -> Task {
        let snap = self.draft_snapshot();
        Task::run(async move { api.send(snap).await }, Self::sent)   // returned ⇒ owner-scoped
    }

    fn match_label(&self) -> impl IntoText + '_ {
        format_args!("{} threads", self.threads.len())
    }
}
```

| Input | App Rust | Stage |
|---|---|---|
| Type in find | the declared filter (`filter_with`) re-arranges | two-way input wire; unchanged rows never re-describe; chrome does not rerun |
| Wheel / pan | none | `scroll_y` live port + `pan()` compositor claim |
| Unread count | none | `text!` hole via `SignalRef` |
| Click a row | `selected` (interception) | `.selected` two-way wire sets selection; `scoped(selection)` reruns reading pane only |
| Middle-click a row | `Thread::toggle_read` | that row's slot; one row reruns |
| Attachment progress | none | that row's `progress_bar` wire |
| Compose width | none | motion lane (`animate` on a mapped wire) |
| Send | `send` then `sent` | owner + turn log |

`.child(self.thread_list())` would inline the list into the parent producer — a toolbar dirty
would rerun 10k rows. Passing `Self::thread_list` is the skip.

## 12. Rounding out to a real plan

05 amends one seam. Everything else a shipping framework needs is either **inherited by
reference** (normative as written, with only spellings re-based on the triad) or **named as a
gap** with its intended seat. This section is the manifest, so nothing rides on "kept verbatim"
hand-waving.

### Inherited contracts (normative, unchanged in substance)

| Surface | Where it lives | Triad re-spelling, if any |
|---|---|---|
| Testing: `TestApp`, virtual clock, `expect_work`, deterministic turn driving | 04 §1/§16, [02-principles P11](02-principles.md) | producers are the work unit: `expect_work().producer(Board::columns_view)` |
| Identity: `#[derive(Id)]`, `.id(Variant)`, lexical `&element` relationships (no `.identity()`), `child.at(...)` branded, `export(outer, inner)`, `.handle()` → `TargetHandle`, `.alias` strings only for black-box automation | 07 §5 + [identity.rs](examples/identity.rs); 04 §7 machinery | unchanged; `.key` narrowed per §2 |
| Images/video/native frames: typed acquisition/decode/variant/residency stages, fence-owned imports | [runtime/media.md](runtime/media.md) | a playing clock is a framework source: wires, not reruns |
| Canvas/shaders: retained passes, typed inputs, hazards, damage | 04 §8 / P9 | custom uniforms are declared bindable slots → `&Signal` wires reach shaders directly |
| Style: Tailwind-like chains, output-owned responsive variants, palette tokens | [style/README.md](style/README.md) | `paint()`/`style()` values; theme tokens stay late-bound |
| Scheduler/turn protocol, collections, virtualization | [runtime/scheduler.md](runtime/scheduler.md), [runtime/collections.md](runtime/collections.md) | plus G7 ordering and `.with()` shared inputs |
| Text editing: document revisions, selection/IME/edit-origin contract | 04 §6 / P9 | the document is the archetypal custom source |
| Focus, portals, drag protocol, accessibility tree, inspector | 04 §2/§7/§13 | unchanged |

### Animation, seated in the triad (this matters, so it is explicit)

Motion never invents a fourth move; it decorates the three:

- **Animated wires.** `.width(self.w.animate(spring()))` — a wire combinator: on version change
  the motion lane interpolates at the cheapest stage (composite for transforms/opacity, paint for
  color), zero Rust per frame. `signal.animate_to(target, curve)` is the write-side twin.
- **Enter/exit on children.** `.child(Self::panel).transition(fade_in(), slide_out())` — retained
  spans make exit animation real (the leaving span stays in the paint tree while its motion
  finishes; 04 §2.2 already permits paint-tree residency past event order).
- **Matched geometry / hero transitions** — the known gap feedback.md ranked with SwiftUI's
  `matchedGeometryEffect`: `element.hero(id)` marks continuity candidates; when a structural swap
  retires one span and mounts another with the same hero id, the runtime FLIP-captures
  first/last geometry via the placement graph and runs the morph on the composite lane. Needs
  identity continuity across unmount/remount — precisely what keys/ids already provide — and is
  planned as a primitive because it cannot be composed from per-element motion.
- **Gesture-driven motion** (scrub, rubber-band, momentum) reads an input-lane signal; the motion
  lane and the input lane are the same wire machinery at different sources.

### Undo/redo, stated as commitments

1. Owner-level undo is 04 §12 unchanged: opt-in `Track<T>`, `commit("label")`, typed `Change<M>`,
   gesture coalescing, serializable entries.
2. Mutation descriptors **and `List` ops** are journal-eligible for free (both are sealed
   delta sets with known inverses); descriptor writes to signals and structural edits to wired
   collections participate in undo without any author work.
3. The bright line is documented, not hidden: arbitrary `&mut Self` / `signal.update(f)` bodies
   are not capturable inverses. Apps that want deep undo route edits through `commit()` or
   descriptors — and get 03's delta benefits (serializable history, collaborative rebase seams)
   exactly where they opted in.

### The gap map — surfaces peers have that need a seat here

Ranked from feedback.md plus a fresh comparison against SwiftUI/Compose/Flutter/web:

1. **Cross-element text selection + copy** — a range over the flattened text order of many
   elements. The manifest must expose flattened text order; selection becomes a window-level
   protocol over it. Product-critical; nothing in the triad blocks it, but no primitive exists
   yet.
2. **2D grids** (dual-axis virtualization, frozen rows/columns, cell spanning, grid keyboard nav)
   — `virtual_list` is 1D; a `grid` primitive over the same span machinery is required.
3. **Virtualized trees/outlines** — flattened-projection virtualization with stable row identity
   across expand/collapse; the `.key` + anchor-correction machinery is the substrate.
4. **Docking/panel management** — the protocol (drag-out to split, float, persist layout), not
   just the layout solver.
5. **Gesture recognition + conflict arbitration** — the who-wins state machine over pointer
   streams (scroll vs drag vs swipe); recognizers are easy, arbitration is the design.
6. **Container/self-size queries** — `responsive_style` is window-level; container-level needs a
   bounded layout→style→layout contract (the web only recently earned this).
7. **Live-region accessibility announcements** — dynamic, non-structural a11y ("3 new messages");
   an effect-shaped `announce()` riding the semantic tree.
8. **Theme-swap fanout** — verify late-bound tokens don't regress 03's indexed-fanout answer for
   the 10k-consumer theme flip; if they do, tokens become framework sources (wires) internally.

Each is buildable on the one-register substrate; none reopens the register question — and each
now has a concrete design in [06-cross-cutting.md](06-cross-cutting.md), built on one thesis:
incrementally maintained **projections** of the manifest (FlowIndex, Lattice, FlattenIndex,
TokenIndex) plus window-level **protocols** over them, never a second retained tree.

The higher-tier corrections from
[10-cross-cutting-higher-tier.md](00-research/10-cross-cutting-higher-tier.md) are **folded into
06**: session indexes that die with their protocol; editor ranges kept off FlowIndex (N
viewports, one document); gesture arbitration as compositor claims → failure DAG → nested-scroll
pipeline; named-ancestor container queries; exist-before-change live regions; docking as two
algebras (workbench chrome + editor grid); Lattice of the arrangement; pull-based tree children.

The honest sequencing is the vertical slice first (counter → kanban → inbox → editor with
the gates of [performance.md](performance.md)), then grid/tree/selection, because those three
stress the manifest's cross-element structure — the real test of whether "retain facts, not
objects" holds.

## 13. Pockets: the reference move applied to components

The proposal this section absorbs observed something true: GPUI already has the social unit
(Zed is a graph of `Entity<T>`), `.cached()` already means "replay this subtree's last scene,"
and both are hooked to the wrong dirt. The natural version inside this design needs no new noun,
because the triad already names it:

> `.child(&self.inbox)` is the **reference move applied to a component**. A reference always
> means "keep this live; don't re-derive it here." For a scalar that's a wire; for a collection
> it's a wired list; for a component it is a **surface**: the parent's rerun re-records one
> placement, and the child presents from its own cells.

Half of this is already the law — a `Component<T>` is a dirty-child root and a revision wall;
a parent rerun reuses its span without running its view. The pocket *finishes the boundary
downward through the pipeline*:

- **A layer is earned, not declared.** When a component's update cadence diverges from its
  parent's (a hot child under a static parent, or a static child under a churning parent), the
  runtime promotes it to a compositor layer: its own retained target, one composited quad, a
  hit-test proxy, its own a11y subtree, its own damage domain. Parent changes become transform
  patches on the quad. Promotion/demotion uses hysteresis and a **layer memory budget** with
  counters — layer explosion is the browser's documented disease, so "earned like a damage
  tier" is the rule and `.layer()` is only the explicit override. `.cached()` is, verbatim, the
  MVP of this: the same replay, finally hooked to the child's cells instead of the window.
- **Isolation lives at the protocol boundary, not in a type wall.** Reaching into another
  owner's cells is already unspellable (private fields; no ambient runtime to query). What
  branding actually protects is the *boundary artifacts*: a pocket's packets, fences, input
  routes, and IME/focus sessions are generation-tagged to its epoch, so a retired pocket cannot
  receive a stale write or deliver a stale frame. Deliberate cross-owner sharing — the
  workspace playhead handed to three components — stays exactly as legal as it is today,
  because a handed-down `&Signal`/`SignalRef` *is* the explicit grant. Sealing that off would
  have deleted a feature to prevent a mistake that was already impossible.
- **The age line runs through the same boundary, in both directions.** New-inside-old and
  old-inside-new are the same artifact: a scene packet with a fence. `.child(&legacy_entity)`
  hosts today's `Render`-era entity as a pocket — its rebuild cadence is contained behind its
  quad, its input arrives through the proxy, and nothing about the parent's fast path depends
  on the island's insides. A legacy view hosting a one-register component is the mirror image.
  This **re-anchors migration from window-first to entity-granular**: one entity can be
  retained first, adopters convert hot leaves without touching the shell (or the shell without
  touching leaves), and immediate-mode islands ("zgui in a hole") stop being a lie and become a
  layer. [migration.md](migration.md)'s ordering should be rewritten around this boundary.
- **No second scheduler.** A pocket's producers are ordinary producers in the same turn
  protocol; the isolation is presentational. Media surfaces (already fence-imported), plugin
  surfaces (the `recover` boundary's natural seat, and the hook for process isolation later),
  popups on auxiliary windows, editors, and canvases are the expected residents.

Gate **G11**: promotion/demotion hysteresis under cadence flip-flop; the layer budget with
eviction telemetry; a parent rerun over a promoted child records placement-only work (counter:
zero child description, zero child paint); stale-fence and retired-epoch injection on input,
IME, and packet delivery.

## 14. Honest walls

Surfaces where this architecture bends but does not naturally excel — named so nobody discovers
them in production. Each has an escape, and the escape's cost is stated:

1. **Per-glyph motion / kinetic typography.** Per-glyph reactive nodes are a stated non-goal;
   text granularity is run/line/paragraph. Escape: a custom text `Primitive` with shader-side
   animation — full tooling, but you leave the text system's caches.
2. **Element-grade services at datum scale.** A 100k-object direct-manipulation canvas (Figma,
   node graphs) wants focus, hit-testing, and a11y *per datum*. Elements stop at ~10³–10⁴;
   beyond that the answer is a canvas primitive plus its own spatial index and a semantic
   provider — the machinery exists (custom hit-test, virtualized a11y), but you are assembling
   it, not inheriting it. Connector edges between real elements are fine (placement graph);
   whole-scene-as-data is yours.
3. **Inline interactive widgets inside line-breaking text** (Notion-style embeds mid-paragraph).
   This is no longer a reactivity wall: the contract is [09-text.md](09-text.md) (U+FFFC
   placeholders in the IFC, decorating-box skip, atom recycling). It remains an
   *implementation* milestone (gate T1). Do not improvise it with overlays / `place_in`.
   Per-glyph kinetic typography (wall 1) is a different, still-standing wall.
4. **Global constraint layout.** Local constraint groups are bounded by design; a whole-window
   Cassowary solve (AutoLayout-general) is deliberately unsupported. Escape: the elastic spine +
   placement graph cover the sane cases; a truly solver-shaped screen embeds a custom layout
   `Primitive` for that subtree.
5. **Structure changes at machine rate.** Wires patch properties at any rate, but *structural*
   change (audio-reactive layouts, generative UI where the tree itself follows a signal at
   120 Hz) is turn-priced. Escape: keep machine-rate structure inside a canvas/pocket whose
   *contents* are data, not elements.
6. **Cross-window continuity.** Hero transitions and drag previews across native windows are
   platform-hostage (separate swapchains, compositors); a pocket can move between surfaces, but
   a *morph* across them is not promised. In-window and window→auxiliary-portal are covered.

## 15. What still keeps me honest

The cliffs this document has *not* engineered away, restated once so the pitch never outruns
the product: call-vs-pass (`f()` inlines, `f` retains) and `Ui` vs `impl Element + '_` are
conceptual load the diagnostics can soften but not delete; `.reading(&plain)` is stale until
its producer reruns, on purpose; contained `Vec` iteration at scale costs what it costs until
you switch the type; and every "routed" convenience (first-parameter addressing, two-way
controls, slot handlers) resolves at lowering with a located error as its failure mode — good
errors are a gate (G9), because they are the difference between "magic" and "inference you can
predict."
