# 10 — Elegance and Fast Paths: Closing the 05 Gap Map

Status: **research companion to [05-one-register.md](../05-one-register.md)**. The spellings
below are **absorbed into 05** (2026-08-15). Application code writes `impl Element + '_`, never
`use<..>` — precise capturing is crate-internal. Not an architecture replacement.

Research date: 2026-08-15. Compiler: **stable rustc 1.97.1**. Samples marked **VERIFIED** were
compiled in a temporary edition-2024 crate against that compiler (not committed; any adopted
mechanism needs an in-repo trybuild, same rule as [04-rust-frontier.md](04-rust-frontier.md)).

The brief was: keep 05 feeling like regular Rust, recover the DX and perf papercuts without a
second scaffolding, and — worst case — provide a zero-cost abstraction that opts into the 03 fast
path. The next-generation trait solver
([Inside Rust, 2024-12-04](https://blog.rust-lang.org/inside-rust/2024/12/04/trait-system-refactor-initiative/))
is real and worth watching, but it is **not** the closure fix. The closure fix is already on
stable, and it is one associated function.

---

## 0. The finding in one page

05's four "stops feeling like Rust" papercuts and four perf regressions vs 03 are all the same
shape: **the default is the honest, capability-free, plain-Rust path; the fast or clever path is a
type you already know (a function, a `Copy` value, a return value, a pool).** None of them want a
new register, a derive, or an ambient runtime.

| Gap | 05 today | The higher-tier move | Cost if unused |
|---|---|---|---|
| Closures can't be scopes | fn items only; HRTB blamed on the solver | `Self::scope(\|this\| …)` — **VERIFIED** on 1.97.1. The marker trait was the killer, not rustc. Next-solver / `closure_lifetime_binder` only delete the wrapper later. | Zero. Wrapper is a newtype. |
| `Ui<'a>` single-use, `!Clone` | lending draft | Teach `Ui` as an iterator of the description. Helpers return `impl Element`; `Copy` elements **VERIFIED** usable twice. Owned `UiBuf` is the opt-in clone. | `UiBuf` is the slow path; lending stays free. |
| Staged writes in `update_in` | `&Owner` sees committed | Taught path: don't pass `&Editor` (extra args / sibling `rest`). If `update_in` stays: `Draft<T>` / `Host<O>` so the two views cannot pretend to agree. Compose has *one name* and read-your-writes; G4 is two names. Not STM. | Zero. |
| Effects as return values | `-> Task` / `Emit<E>` | Keep returns (`IntoEffects`, `From<Fut>`). **Not** `async fn(&mut self)` that awaits — that captures `&mut self`. Turn-scoped `spawn`/`emit` is a transaction log, not a runtime. | Sync `fn(&mut Self)` unchanged. |
| Owner handler = O(description) | deliberate; G1 | Machine-rate events (`Scroll`/`PointerMove`/`DragDelta`) do not impl `OnEvent` for `fn(&mut O)` — compile error, `_owner` escape. Click stays `fn(&mut Self)`. Do not skip `fn(&Self)` scopes. | Zero. |
| Lost `ListDelta` | keyed splice after rerun | Authoring is collection *methods* (`KeyedList::push` notifies, Slint `VecModel` shape). Returning `ListDelta` is a splice *hint* and does **not** skip `view()`. `Vec` stays default. | Zero for `Vec`. |
| Signal = heap cell | price of `Signal::new` | `Copy` and `Drop` are mutually exclusive: a Copy key cannot own a cell in a `Vec`/enum. Keep `!Clone` + `Drop`. Pool cells behind `Signal::new`. `scope.slot` is 03 keys *and* a Scope. Intern-on-wire does not make Copy safe. | Pool is lazy. |
| `format_args!` every rerun | honest | `text!` intern + holes; `text(format_args!(...))` as a *macro* rewrite at the call site. Format as a function/wire (`text(Self::count_label)`). Stored `Arguments` is impossible. | Macro is opt-in. |

The next-solver is a **compatibility gift**, not a design dependency. Coherence has used it since
**1.84**. `-Znext-solver=globally` is still **not default on nightly** as of 2026-08-11
([rust#160895](https://github.com/rust-lang/rust/issues/160895)); MCP 1014 is accepted, crater
still finds HRTB-associated-type breaks. It does **not** make `|x| view(x)` infer through
`IntoElement` ([rust#70263](https://github.com/rust-lang/rust/issues/70263): the HRTB-closure
special case is `Fn*` bounds only). Ship `Self::scope` / `.scope(f)` *now*. That is P12.

### Worked example: the same Finder, before and after

One screen: find chrome, an editor surface, a match count, Save. The product does not
change. Every papercut is a line you can point at.

**05 as written** — named-fn scopes only, `Ui` is one-shot, `update_in` aliases the owner,
`save` returns `Task`, `format!` and `on_scroll(Self::…)` are legal:

```rust,ignore
struct Finder {
    doc: Document,
    query: Signal<String>,
    selection: Signal<Selection>,
    keymap: Keymap,
    hits: Vec<Hit>,
    scroll_y: Signal<f32>,
}

impl View for Finder {
    fn view(&self) -> Ui<'_> {
        let chrome = self.chrome();
        column()
            .child(chrome)
            // E0382 if you write `.child(chrome)` again — Ui is a one-shot recording.
            .child(Self::find_panel) // must extract a named fn; `.child(|this| …)` fails
            .child(
                editor_surface()
                    .on_key(self.selection.update_in(Finder::apply_key))
                    .on_scroll(Self::on_scroll), // compiles; reruns view() at pointer rate
            )
            .child(text(format!("{} matches", self.hits.len())))
            .child(button("Save").on_click(Self::save))
    }
}

impl Finder {
    fn chrome(&self) -> Ui<'_> {
        row().child(text("Finder")).child(text_input(&self.query))
    }

    fn find_panel(&self) -> Ui<'_> {
        row()
            .child(text("Find"))
            .child(text_input(&self.query))
            .child(button("Next").on_click(Self::next_hit))
    }

    fn apply_key(sel: &mut Selection, finder: &Finder, ev: KeyDown) {
        sel.apply(&finder.keymap, ev);
        // Surprise: finder.selection.get() is the *committed* range, not `sel`.
        if finder.selection.get().is_empty() {
            sel.extend_word();
        }
    }

    fn on_scroll(&mut self, dy: f32) {
        self.scroll_y.update(|y| *y += dy);
    }

    fn save(&mut self) -> Task {
        let snap = self.doc.snapshot();
        Task::spawn(async move { api.save(snap).await })
    }

    fn next_hit(&mut self) {
        self.hits.push(Hit::next(&self.query));
        // Hoped: a ListDelta skips view(). Actual: view() reruns, then a keyed splice.
    }
}
```

**After the papercut fixes** — still one register, still no `cx`, still no ambient runtime.
A named fn remains the taught scope. The new lines are ordinary Rust: an associated
function, calling a helper twice, extra args instead of an alias, a turn log, a collection
type, a live-wire port.

```rust,ignore
struct Finder {
    doc: Document,
    query: Signal<String>,
    selection: Signal<Selection>,
    keymap: Keymap,
    hits: KeyedList<HitId, Hit>,
    scroll_y: Signal<f32>,
}

fn chrome(query: &Signal<String>) -> impl Element + '_ {
    row().child(text("Finder")).child(text_input(query))
}

impl View for Finder {
    fn view(&self) -> impl Element + '_ {
        column()
            .child(chrome(&self.query))
            .child(chrome(&self.query)) // like Iterator: call the producer twice
            .child(Self::scope(|this| {
                row()
                    .child(text("Find"))
                    .child(text_input(&this.query))
                    .child(button("Next").on_click(Self::next_hit))
            }))
            .child(
                editor_surface()
                    .on_key(
                        self.selection
                            .update(Selection::apply_key)
                            .reading(&self.keymap),
                    )
                    .scroll_y(&self.scroll_y), // live wire; fn(&mut Self) is a type error
            )
            .child(text!("{} matches", self.hits.len()))
            .child(button("Save").on_click(Self::save))
    }
}

impl Selection {
    fn apply_key(&mut self, keymap: &Keymap, ev: KeyDown) {
        self.apply(keymap.bind(ev));
        if self.is_empty() {
            self.extend_word(); // the draft is the only name; no alias
        }
    }
}

impl Finder {
    fn save(&mut self) {
        let snap = self.doc.snapshot(); // owned, 'static — not async fn(&mut self)
        spawn(async move { api.save(snap).await }, Self::saved);
    }

    fn saved(&mut self, result: Result<(), SaveError>) { /* toast / dirty bit */ }

    fn next_hit(&mut self) {
        self.hits.push(Hit::next(&self.query)); // KeyedList notifies; view() still runs
    }
}
```

| Line that changed | Papercut | Why it now feels like Rust |
|---|---|---|
| `Self::scope(\|this\| …)` | Closures cannot be scopes | Associated fn pins `O = Self`. Named `Self::find_panel` is still better. Bare `.child(\|this\| …)` still fails (`#70263`). |
| `chrome(&self.query)` twice | `Ui<'a>` is `!Clone` | Helper returns `impl Element + '_`. You do not clone an iterator. |
| `update(Selection::apply_key).reading(&self.keymap)` | `update_in` alias | Extra arg, not `&Finder`. If `update_in` is kept: `Draft<Selection>` / `Host<Finder>`. |
| `spawn(fut, Self::saved)` | `-> Task` virality | Returns stay legal (`IntoEffects`). The log is turn-scoped, not a runtime. |
| `.scroll_y(&self.scroll_y)` | G1 owner × pointer-rate | `Scroll` does not impl `OnEvent` for `fn(&mut O)`. Click is unchanged. |
| `text!("{} matches", …)` | `format!` every rerun | Call-site macro intern + holes. Or `text(Self::match_label)`. |
| `hits: KeyedList<…>` | Lost `ListDelta` | Fast path is the collection's type. A returned delta is a hint and does not skip `view()`. |

If you still want `update_in` because the handler really must see the rest of the owner,
the irregular fact gets a name — it is not STM and not Compose:

```rust,ignore
fn apply_key(sel: &mut Draft<Selection>, host: &Host<Finder>, ev: KeyDown) {
    sel.apply(&host.keymap, ev);
    // host.selection.get() does not exist. Re-entrant update is a missing method.
}
```

### `impl Element` — yes, and here is the actual door

`Ui<'a>` is Iced's `Element<'a>`: the **nameable** erased plan. `impl Element + '_` is the
**typed** plan, recorded when a parent `.child`s it. Precise capturing (`use<..>`) is
crate-internal — Rust 2024 default-captures-everything on methods that take `&self` plus a
borrow they actually return. Application code never writes it.

| Returns | Who | Door it opens | Door it does not open |
|---|---|---|---|
| `impl Element + '_` | Helpers, library widgets, **`View::view`** | Copy reuse; `fn pane(a: impl Element, b: impl Element) -> impl Element`; deforestation (03's Property lowering sits here); a view may return a `Copy` badge with no tape | Naming the type (no TAIT); `dyn View` (RPITIT is not object-safe) |
| `Ui<'a>` | Retained **scope producers** (`Self::list`, `Self::scope(\|this\| …)`) | The HRTB bound `F: for<'a> Fn(&'a O) -> Ui<'a>` is writeable, so the runtime can call `f` later | Binding twice (`!Clone`) |
| `UiBuf` | Opt-in clone of already-recorded tape | Embed the same chrome twice after recording | Fast path |

A function `fn overlay(&self) -> impl Element + '_` is a unique opaque type per lifetime.
You **cannot** write `F: for<'a> Fn(&'a O) -> impl Element + 'a` — that is invalid, and it is
why `#70263` killed bare closures through the marker. `Self::scope` therefore still returns
`Ui` from the *closure* (`column()` is `Ui`, which implements `Element`). Inside it, every
helper can be `impl Element`. Passing `Self::list` as an independent producer wants `list` to
return `Ui` (or you write `.child(self.list())` and inline it into the parent producer — that
is cheaper to type and *wrong* if the list should skip when the parent reruns).

Do **not** make constructors return a `Row<(A, B, …)>` type tower. That is Xilem's
`View<State>` explosion, which Vizia 0.4 just deleted. Builders still lower to one tape.
`impl Element` is the unrecorded *leaf/helper* plan, not a second tree of nested generics.

`trait View { fn view(&self) -> impl Element + '_; }` is the 05 amendment: window roots
are `fn run<V: View>(v: V)`, never `dyn View`. `Ui` remains because scopes have to name a
lending return. Deleting `Ui` does not compile on stable.

### Worked example: Inbox on the high-perf gradient

Same rules as Finder. Every hot cell is a type you already have. Unused kit (no `KeyedList`,
no `virtual_list`, no `animate`) is not in the cost model.

```rust,ignore
struct Inbox {
    query: Signal<String>,
    selection: Signal<ThreadId>,
    scroll_y: Signal<f32>,
    unread: Signal<u32>,
    overlay: Signal<Option<ComposeId>>,
    threads: KeyedList<ThreadId, Thread>,
}

struct Thread {
    id: ThreadId,
    title: String,
    unread: bool,
    progress: Option<Signal<f32>>,
}

#[derive(Copy, Clone)]
struct Brand;
impl Element for Brand {}

fn chrome(query: &Signal<String>, unread: SignalRef<u32>) -> impl Element + '_ {
    row()
        .child(Brand)                                // Copy plan; bind twice if you want
        .child(text!("{} unread", unread))          // interned template + SignalRef hole
        .child(text_input(query))                    // live two-way wire; no handler
}

fn pane(list: impl Element, detail: impl Element) -> impl Element {
    row().child(list).flex(1).child(detail).flex(2)  // composition door: no Ui in the signature
}

impl View for Inbox {
    fn view(&self) -> impl Element + '_ {
        column()
            .child(chrome(&self.query, self.unread.reader()))
            .child(pane(
                Self::thread_list,                   // fn item: independent producer, returns Ui
                scoped(self.selection.get(), Self::reading_pane),
            ))
            .child(Self::scope(|this| {              // inline overlay; closure returns Ui
                compose_sheet(&this.overlay)
                    .width(this.overlay.map(ComposeId::open_width).animate(spring()))
            }))
    }
}

impl Inbox {
    fn thread_list(&self) -> Ui<'_> {
        virtual_list(&self.threads)
            .filter(|t| t.title.contains(&self.query.get()))
            .pan(Pan::VERTICAL)                      // compositor claim; not a recognizer race
            .scroll_y(&self.scroll_y)                // live port; fn(&mut Self) would not compile
            .row(Self::thread_row)
    }

    fn thread_row(thread: &Thread) -> impl Element + '_ {
        let id = thread.id;
        row()
            .key(id)
            .hero(id)
            .on_click(Inbox::select.with(id))
            .child(text(&thread.title))
            .child(thread.progress.as_ref().map(progress_bar)) // &Signal → paint-stage wire
    }

    fn reading_pane(&self, id: ThreadId) -> Ui<'_> {
        editor_surface()
            .background(self.selection.map(ThreadId::tint))
            .scroll_y(&self.scroll_y)
            .on_key(self.selection.update(ThreadId::apply_key))
            .child(text(Self::match_label))          // format-as-function; no format! on rerun
    }

    fn select(&mut self, id: ThreadId) {
        self.selection.set(id);
        self.unread.update(|n| *n = n.saturating_sub(1));
    }

    fn send(&mut self) {
        let snap = self.draft_snapshot();
        spawn(async move { api.send(snap).await }, Self::sent);
    }

    fn match_label(&self) -> impl IntoText + '_ {
        format_args!("{} threads", self.threads.len())
    }
}
```

What actually runs, per input:

| Input | Rust that runs | Stage |
|---|---|---|
| Type in the find box | none (`&query` two-way) | text reshape of the input; `thread_list` reruns (it `.get()`s query) |
| Wheel / pan | none | composite (`scroll_y` wire + `pan()` claim) |
| Unread count | none | `text!` hole patch |
| Click a row | `select` | owner transaction; `scoped(selection, …)` reruns reading pane only |
| Attachment progress | none | paint of that row's bar |
| Compose width | none | motion lane (`animate`) |
| Send | `send` then `sent` | owner + turn log |

`thread_list` returns `Ui` *on purpose*: it is passed as a function, so it must satisfy
`for<'a> Fn(&'a Inbox) -> Ui<'a>`. `thread_row` and `chrome` return `impl Element` *on
purpose*: they are values, recorded into someone else's producer. Mixing those two is the
whole high-perf style.

---

## 1. Closures as scopes: the marker was the bug, not the solver

### 1.1 What 05 got right, and what 1.97.1 changed

05 §1: a naive `impl<F: Fn(&O) -> Ui<'_>> IntoElement for F` E0119s against `Ui`, so children use
the Bevy/Axum marker `IntoElement<'a, M>`. Fn items satisfy `for<'b> Fn(&'b O) -> Ui<'b>` natively.
Closures are "out" because HRTB closure inference is unreliable.

That last sentence is true **of the marker-parameterized bound**, and false of a *direct* HRTB
bound. **VERIFIED** on rustc 1.97.1:

```text
OK   child_scope::<Owner, _>(|o| overlay_view(o));          // direct HRTB generic
OK   take(|o| overlay_view(o));                             // impl for<'b> Fn(...)
FAIL Row.child(|this: &Owner| this.overlay());              // marker IntoEl<'a, M>
OK   Owner::scope(|this| this.overlay());                   // associated fn pins O = Self
OK   Owner::scope(move |this| { let _ = n; this.overlay() }); // Copy capture, 'static
FAIL hrtb(|o| { let _ = &s; overlay_view(o) });             // borrow capture: E0373
```

The semantic ban (no captured borrows across frames) is already the borrow checker. The technical
ban (HRTB inference) is an artifact of asking rustc to infer `M` *and* a higher-ranked closure
together. Split those two inferences and closures compile today, on stable, with no feature gate.
Annotating the closure (`|x: &Owner|`) does **not** work through the marker — verified.

This is [rust#70263](https://github.com/rust-lang/rust/issues/70263) (still open): rustc's
HRTB-closure special case applies to **direct `Fn*` bounds**, not to `Fn` via another trait.
Next-solver does not claim to fix that. The `hrc_hint` identity function on
[rust#97362](https://github.com/rust-lang/rust/issues/97362) is the same door. `Self::scope` is
that hint, with `O` pinned to `Self` so `|this| this.overlay()` needs **no type annotation**.
Xilem's `memoize` adds `const { assert!(size_of::<F>() == 0) }` for the capture-free case — steal
that for `scoped`/`frozen`, as a const error rather than HRTB soup.

A second spelling, also verified: split methods so `.child` takes `impl Element` and `.scope(f)`
has the direct HRTB `Fn` bound. Then `.scope(|x| overlay_view(x))` needs no wrapper type. Keep
one `.child` plus `Self::scope` if you want a single children method; use split methods if you
want the bound itself to be the hint. Marker blankets take
`#[diagnostic::do_not_recommend]` (stable 1.85) so rustc does not suggest implementing
`IntoElement<'_, AsScope<_>>`.

### 1.2 The adapter (zero new nouns)

```rust,ignore
pub struct ScopeFn<O, F> {
    f: F,
    _o: PhantomData<fn(&O)>,
}

impl View {
    // Default method on the trait every component already implements.
    fn scope<F>(f: F) -> ScopeFn<Self, F>
    where
        Self: Sized + 'static,
        F: for<'a> Fn(&'a Self) -> Ui<'a> + 'static,
    {
        ScopeFn { f, _o: PhantomData }
    }
}

impl<'a, O, F> IntoElement<'a, AsScope<O>> for ScopeFn<O, F>
where
    F: for<'b> Fn(&'b O) -> Ui<'b> + 'static,
{ /* retained scope producer, same record as the fn-item impl */ }
```

Taught forms, in order of taste:

```rust,ignore
.child(Self::overlay_view)                       // still the best: named, reusable, no wrapper
.child(Self::scope(|this| this.overlay()))       // inline; regular associated function
.child(scoped(doc_id, Self::overlay_for))        // owned input, already in 05
```

Bare `.child(|this| …)` still fails through the marker. That is fine: G9's
`#[diagnostic::on_unimplemented]` text becomes "pass a method path, or `Self::scope(|this| …)`".
When next-solver or `closure_lifetime_binder` (RFC 3216, implemented, **not stabilized**, last
activity Apr 2026, blocked on higher-kinded inference / types-team#131) make the bare closure
match `IntoElement<'a, AsScope<O>>`, the wrapper becomes optional and the diagnostic can mention
it as the explicit form. **No API break either way.**

`for<'a> |this: &'a Self| -> Ui<'a> { … }` (the nightly binder) is strictly worse DX than
`Self::scope(|this| …)` and must not be a public requirement. It is a power-user spelling for
people already on nightly, not a framework feature.

Capturing *owned* `'static` data (Copy, or `move` of an owned `String`) is legal because the
retained record is `'static`. That is the same permission `scoped(input, f)` already grants.
Capturing a borrow of a local is a compile error. Do not paper over it with `'static` erasure or
yoke — that is how you get use-after-frame.

### 1.3 What the next-solver actually buys

- Coherence is already on it (1.84). That is why the marker pattern is *more* trustworthy, not
  less: overlap checking is the new solver's job.
- Global solving is the 2026 project goal, crater-clean enough that an MCP to enable by default
  has been in FCP. Remaining work is perf, diagnostics, and a handful of ICEs — not "make
  closures higher-ranked."
- TAIT/ATPIT remain blocked on it ([04-rust-frontier.md](04-rust-frontier.md) §3 still holds).
  Do not design public APIs that need to *name* `impl Element`.
- Field projections (RFC 3735) are a **2026–2028** lang experiment
  (`#![feature(field_projections)]`, FRTs landed, borrowck integration not done). Still the
  watched sweetener for `signal.selection` as a projected source. Not a 05 dependency; 03's
  derive-shaped field keys remain the fallback if anyone wants 03-style `settings.count`.

**P12 restated:** the public vocabulary is `Self::scope` / fn items / `scoped`. Solver and
binder changes may widen what `.child` accepts. They must never be the reason the API compiles.

---

## 2. `Ui<'a>` is an iterator, not a value

The papercut is real: you cannot `let x = row().child(a);` and then `.child(x).child(x)`, and
holding a `Ui` across a mutation of its source is a borrow error. Peers "solve" this two ways,
both of which 05 should refuse to copy:

- **Xilem** makes the *view tree* a cheap value you rebuild every logic tick (`View` +
  `ViewSequence` + `Memoize`). Reuse is "the view value is `Clone`/`Copy`-ish because it is
  data." The tax is the lens/`Adapt` explosion Azul called out ([azul-xilem.md](../../../azul-xilem.md)):
  every component is generic over `State`, so composition is a type-level problem.
- **Dioxus 0.5+** deleted the `'bump` lifetime and made `Element` `'static` by making *state*
  `Copy` generational boxes against a store. Reuse is easy because nothing borrows. The tax is
  an ambient `Owner`/`Store` — exactly the capability 05 banned for `Signal::new`.

The regular-Rust analogue of `Ui<'a>` is `impl Iterator`. You do not clone an iterator to walk
it twice; you call the function that produces it twice. That is the teaching. The API then
offers two rungs for people who actually needed a value:

**Rung 1 — `impl Element`, and `Copy` when the plan is `Copy`. VERIFIED:**

```rust,ignore
#[derive(Copy, Clone)]
struct Button { label: &'static str }
impl Element for Button {}

fn header() -> Button { button("Title") }

let h = header();
row().child(h).child(h);   // compiles; two recordings of the same plan
```

05 already said libraries may return `impl Element + '_` for a deforested plan. Market it as the
helper signature. `-> Ui<'_>` is what *`view`* returns (the erased root), not what every helper
returns. A lint/code-action "this helper can return `impl Element`" is the DX, not a new type.

**Rung 2 — owned tape, the opt-in clone:**

```rust,ignore
fn shared_chrome(title: &str) -> UiBuf { /* records into an owned opcode buffer */ }
let chrome = shared_chrome("Inbox");
column().child(&chrome).child(&chrome);  // memcpy of compact tape, then two embeddings
```

`UiBuf` is `Vec`-shaped: allocation, `Clone`, no borrow of the owner. It is the slow path and
must be named so. Static/literal trees can intern to a `Copy` `SpanId` on first record (P8
static-chain folding already wants this). Dynamic borrowed helpers stay lending.

**Diagnostics.** The E0505/E0382 you get from reusing `Ui` should carry G9 text: "`Ui` is a
one-shot recording. Call the helper again, return `impl Element` (Copy plans can be bound), or
build a `UiBuf`." That is the whole papercut, converted into a teacher.

`super let` / flexible temporary lifetime extension is a 2026 lang redesign
([project goal](https://rust-lang.github.io/rust-project-goals/2026/redesigning-super-let.html)),
not stable, and would at best let a *temporary* `Ui` live to the end of a statement. It does not
make `Ui` reusable. Ignore it for the public API.

---

## 3. Staged writes: this is split-borrow, not STM

`update_in` is `fn(&mut Selection, &Editor, KeyDown)`. Through `&Editor`, `self.selection.get()`
returns the committed value; the `&mut Selection` sees the draft. Correct under P5. Surprising
once.

Jetpack Compose's `MutableSnapshot` does the **opposite**: in-snapshot reads see in-snapshot
writes, and other snapshots see nothing until `apply`
([Snapshot API](https://developer.android.com/reference/kotlin/androidx/compose/runtime/snapshots/Snapshot)).
That is MVCC for a multi-threaded composition runtime. 05 is single-writer, UI-thread-local
(P4). Importing Compose's "reads see writes" would make nested computations during a handler
observe unpublished state — the thing P5 exists to forbid.

The regular-Rust analogue is holding `&mut vec[i]` and also writing `vec[j]`. You do not index
`vec[i]` through the vec; you use the reference you already have. Programmers already know this.
The surprise is only that `Editor.selection` is reachable two ways.

G4 is not STM and not Compose. STM's in-transaction-value is "I see my writes; other turns
don't." Compose has **one name** (`state.value`) and read-your-writes inside `enter`. G4 is
**two names, two isolation levels, one cell** — an alias ordinary Rust would refuse, invented so
`update_in` can look like a split borrow. Solid 2.0 moved *toward* committed-until-flush for
every name and then had to add `flush()` because it surprised people. Teaching G4 as "like STM"
makes people expect the opposite of what `&Editor` does.

**Taught path: don't pass `&Editor`.** Extra arguments, or a sibling `rest` struct — actual split
borrows. `signal.update(T::method).reading(&self.keymap)` copies/`&` other data, never the
drafted cell. Need-the-whole-owner ⇒ you wanted an owner handler (and you pay the view rerun 05
already prices).

**If `update_in` stays:** `fn(&mut Draft<Selection>, &Host<Editor>, KeyDown)`. `Draft<T>` is
`#[repr(transparent)]` + `DerefMut<Target = T>` so `Selection` methods stay ordinary; the adapter
*requires* the `Draft` parameter so autoderef cannot erase it. `Host<Editor>` has the drafted
field's live-read and `update` methods gone — re-entrant update is a missing method, not a
panic. That is scaffolding that names an irregular fact, not a second register.

Do not make `&Editor` reads see the draft while `&mut T` is live (UB or a hidden clone). Do not
put GhostCell `'id` on user signatures. Do not switch to a Compose cell API (`sel.write(|s|
…)`) — that fights "Selection's methods don't change."

A lint remains on the leftover escape (dynamic `edit(|…|)`, inspector, fuzz): `.get()` on the
drafted field through the owner is a located warning.

---

## 4. Effects: returns stay the contract; `spawn` is a turn log, not a runtime

04/05's `fn save(&mut self) -> Task` is the Elm/Iced answer and is how you *test* handlers.
The papercut is **virality**, the same complaint as `Result` before `?`. Three layers:

```rust,ignore
fn increment(&mut self) { self.count += 1; }              // () — no effect

fn save(&mut self) -> impl Future<Output = SaveResult> + use<> {
    let snap = self.doc.snapshot();                       // owned, 'static
    async move { api.save(snap).await }                   // does not borrow self
}

fn pick(&mut self, id: SuggestionId) -> Emit<Picked> {
    Emit(Picked(id))
}

fn save_and_toast(&mut self) -> impl IntoEffects<Self> {
    (self.start_save(), Emit(Saved))
}
```

**Reject `async fn save(&mut self) { … .await }`.** The future would capture `&mut self` across
`await` — the "no borrow across a frame" rule, now at the type level. `impl From<Fut> for Task`
(future owns its data) is the 1.85-shaped path. Dioxus's `onclick: async move { … }` works
because signals are Copy handles *and* a TLS runtime; steal the owned-snapshot half via
`SignalRef`, not the process-global runtime.

`#[track_caller]` on `async fn` is still unstable (rust#110011). Record locations on the
synchronous spawn/`task()` wrapper.

**Turn-scoped `spawn`/`emit` is a transaction log, not a runtime.** 05 banned TLS for
`Signal::new` because that *selects which graph owns the cell*. A handler already runs on a
known runtime. Prelude `spawn(fut, Self::saved)` pushes onto a buffer the dispatcher installs
for this call and restores on unwind — `thread::scope` shape, user never owns the buffer. It
cannot resolve keys, cannot run from `view`, and is a located error outside a turn. That is
compatible with the ban; Leptos/Dioxus `CURRENT_RUNTIME` is not. It *is* a hidden effect system
(P6 tension): inspector lists "effects recorded this turn"; tests use `Turn::run`.

Reject inherent `self.spawn` on the domain struct (SwiftUI `_location` energy). Reject putting
`cx: &mut Context` back on every handler. `Turn::run` is the honest capability argument for
tests and non-event entry.

The Downloads pattern (`TaskHandle` field, `.spawn(Self::finished.with(id))`) remains more like
regular Rust than making every handler return `Task`. Keep both: returns as the type-level
contract, field-owned tasks as the long-lived default.

---

## 5. Perf gaps: opt into 03, don't default to it

### 5.1 O(description) owner handlers

This is not a bug. Description is the cheap stage (Azul ~50µs for a 9k-word doc). The expensive
stages already sit behind the tape. G1 stands: a 120 Hz *owner* handler on a huge single-owner
view is the workload that should have been a signal.

Zero-cost moves that do not reopen the receiver split:

- **Machine-rate events are not `fn(&mut O)`.** `PointerMove` / `Scroll` / `DragDelta` only
  accept `EventSink` (`&Signal`) or `signal.update(T::method)`. The ugly escape is
  `on_pointer_move_owner(Self::f)`. Cadence is a property of the **event type**, which is how
  Rust already works (`OnKey` vs `OnScroll`). This is the actual G1 spelling: the beginner
  mistake is wiring 120 Hz to `&mut Self`, and it becomes a compile error. Click stays
  `fn(&mut Self)`.
- **`IntoLiveWire` on machine-rate *ports*:** `.scroll_y` / transform / caret accept `&Signal` /
  `SignalRef` / `Projection` only. `#[diagnostic::on_unimplemented("scroll_y must be a live
  wire")]`. Snapshot scroll uses a named escape. Zero-cost unused (sealed trait, no codegen).
- **Code action** on Click (04's lint, kept): body only touches signals → rewrite to
  `signal.update`. Heuristic, not a proof.
- **Do not skip `fn(&Self)` scopes on owner dirty.** They can read untracked plain fields.
  `scoped(input, f)` already skips on equal inputs. `SkipDescription` as an `IntoEffects` return
  is an advanced escape with a tape oracle (P10) — keep it ugly so it does not become 04's
  `&self` handler in a hat. `offset_of` bitsets and Compose `#[view]` are rejected (forgotten
  bits are stale UI; skip would require a compiler).

Do **not** build persistent opcode ropes to fix G1. G1's cost is running `view`, not sibling
memcmp. Draft pages are reclaimed after lowering. Tracked children (wires, `scoped`) may reuse
tape pages across a parent rerun as an impl detail; `fn(&Self)` scopes may not.

### 5.2 ListDelta as an effect, not a store

03's `ListDelta<K>` is the scalable algebra. 05 gave it up as the *default* so `Vec<T>` stays
`Vec<T>`. You cannot see `Vec::push` — a typed delta is either a different collection type or
an explicit value the handler produces. **Authoring is the collection's methods** (Slint
`VecModel::push` → `row_added`), not a `ListDelta` enum in product code. That is 05's own
gradient: granularity is the type.

```rust,ignore
fn add_card(&mut self, column: ColumnId) {
    self.column_mut(column).cards.push(Card { .. }); // KeyedList: O(1) insert op
}
```

Three rungs:

1. **`Vec` + keyed tape splice** after the owner/scope reruns. Default. A returned `ListDelta`
   is a splice *hint* (`IntoEffects`); the oracle wins if it lies (P10). It does **not** skip
   `view()` or the author's `iter()`.
2. **`KeyedList` / `ComponentMap`.** Mutations *are* the ops. No diff. 10k-row opt-in, already
   in [runtime/collections.md](../runtime/collections.md).
3. **`keyed(...).apply_delta(d)`** when the producer should not scan.

Dock's `DockDelta` is the existence proof of (1) for a domain that is already a tree of ops.
Do not invent a parallel "diff-native vec." Do not pretend `items.splice` on `std::Vec`
notifies the UI.

Floem's `dyn_stack` and Jonmo's `Move`/`UpdateAt`/`Replace` are the cautionary tale
([06-competitive-update.md](06-competitive-update.md)): a diff stream is not keyed identity.
The 03/collections contract (move preserves, resident update preserves, replace remounts) stays
normative. A delta that says `UpdateAt` and means "remount" is a bug, not an API.

### 5.3 Signal cells: intern, don't Copy

Dioxus `generational-box` and Leptos `ArenaItem` make signals `Copy` by putting the cell in a
runtime-owned arena and handing out generational indices. That is 03's `State<T>`. It requires an
`Owner`/`Scope` at construction and makes aliasing writers the default. 05's `!Clone` is a
*semantic* choice (a `Vec` of items must not silently share cells on `#[derive(Clone)]`), not an
allocator choice.

You can pick two of: (1) `Signal::new` with no `Scope` and no TLS, (2) `Copy` (hence no `Drop`),
(3) cell lifetime tied to the domain-data location (variant / `Vec` item). 05 already picked
**1+3**. Leptos/Dioxus pick 2+3 and pay TLS/`Owner`. Dioxus documents the failure: dropping a
Copy `GenerationalBox` does not drop the value; `Signal::new()` in a `Vec` leaks until unmount.
Leptos's most common panic is the dual: Copy handle outlives `Owner`. There is no triangle-
solving crate. `UniqueRc` would be the honest unique-owning cell; it is still nightly
([#112566](https://github.com/rust-lang/rust/issues/112566)).

So:

- **Handle uniqueness** stays `!Clone` + `share()` / `SignalRef`. `SignalRef` is the Copy
  capture for the read/wire side — 03's cheap capture without aliasing writers.
- **Cell storage** is a pool the owning handle's `Drop` returns to. Same public type. First
  `Signal::new` creates it (lazy). This is the only arena that satisfies 1+3. Intern-on-first-
  wire is a `SourceId` mint, not a Copy trick: two Copies of an uninterned handle would be
  aliased pointers with no `Drop`.
- **`scope.slot(v) -> SignalKey<T>`** is 03's Copy key, and it **requires a Scope**. Do not
  advertise it as a capability-free fast path. It is the opt-in for people who want 03 and
  will accept the capability.

Do not introduce a process-global store to make `Signal::new` Copy.

### 5.4 Formatting: intern the template, wire the holes

`format_args!` cannot be stored (the `Arguments` lifetime is the statement). The tape diff
correctly does not claim to kill formatting cost.

The fast path is a template with typed holes, which *is* the function move at wire granularity:

```rust,ignore
text!("Count: {}", &self.count)     // count: Signal<u64> → interned "Count: {}" + one wire
text!("Count: {}", self.count)      // count: u64 → format on producer rerun, as today
text(format_args!("Count: {}", x))  // always legal; never interned
```

`text` as a *function* taking `fmt::Arguments` is a dead end (`Arguments` has private fields and
a statement lifetime; `as_str()` is only the no-placeholder case). `text` as a *macro* that
tt-matches `format_args!(...)` at the call site rewrites to `text!`. Stored `Arguments` and
helpers that already received `Arguments` stay the slow path, on purpose.

The other spelling is the function move, which Floem/Leptos already teach: `text(Self::count_label)`
or a `&Signal<String>` wire. `format_args!` inside `view` becomes a lint, not a new API.
`compact_str` / `smol_str` shrink allocs and still reformat every producer rerun — not a skip.

---

## 6. What to steal, what to refuse

| Source | Steal | Refuse |
|---|---|---|
| **Xilem `ViewSequence` / `Memoize`** | Typed structural composition; `size_of::<F>() == 0` for `scoped`/`frozen`; `ElementSplice` as the tape-splice *impl*. | `View<State>` genericity, `lens`/`Adapt`. Vizia 0.4 deleted 672 lines of lenses — independent 2026 vote. |
| **Dioxus `generational-box` / Leptos `ArenaItem`** | Slab density, generational stale-handle checks, Copy *reader* handles (`SignalRef`). | Copy writer handles, ambient Owner at `Signal::new`, `'static` everything by leaking into a store. |
| **Floem `dyn_stack` / `virtual_stack`** | Prefix-sum extents, persistent Taffy nodes. | Distinct static vs reactive builder methods. |
| **Slint 1.17** | Purity in bindings; indexed property fanout (TokenIndex). | A compiler-owned DSL as the authoring language. |
| **Ribir** | "Non-intrusive": UI reads data APIs, data stays data. 05's gradient is the same thesis. | Mandatory macros as the view language. |
| **Freya 0.4** | Native renderer + custom reactive core after leaving Dioxus — evidence the RSX/hooks layer is not load-bearing for native perf. | Hooks as the state model. |
| **Iced / Elm** | `view(&self) -> Element<'_>` as the existence proof that lending UIs live with "call twice"; `Task` as post-mutation work. | Whole-view rebuild as the only incrementality; Message as the only event path. |
| **Slint `VecModel`** | Collection methods that notify (`push` → `row_added`). Two-way on rows (`<=>`) = `&Signal`. | The DSL. |
| **Freya 0.4 / Vizia 0.4** | Typed builders not `rsx!`; lenses deleted. | Hooks; Copy owning signals. |
| **Compose Snapshot** | One name, read-your-writes *inside* the draft cell; `SelectionGeometry` as a session index. | Two-name alias; universal MVCC (P4). |
| **Flutter `SelectionArea` / `SelectionContainer`** | Selection as a *tree of participants* with a registrar, not a second document. Maps onto FlowIndex + protocol: spans register as selectables, the protocol is the registrar. `SelectionContainer.disabled` is `.selectable(false)` on a subtree. | Widget-tree registrar (we have a manifest). |
| **Flutter 2D viewport** | Dual-axis cache extent, diagonal drag policy. Lattice already matches. | Per-cell widget instances. |
| **UIKit `require(toFail:)`** | Failure *requirements*, not just "who claimed first." 06's claim table has `defer_to` / `claims_over` / simultaneous; it is missing **delayed recognition until the other fails** (single-tap vs double-tap). That is the gold standard. | Delegate objects. Spell it `.require_failure::<DoubleTap>()` on the recognizer. |
| **SwiftUI `matchedGeometryEffect`** | Already seated in 05 §12 as `hero(id)`. | Magic identity across unmatched trees without keys. |
| **GPUI itself** | Sum-tree, drop-cancel tasks, entity handles as the *internal* intern target. | `cx: &mut Context` on every handler. |

Autoref specialization (dtolnay) stays a poor fit for a fluent generic `.child` (04-rust-frontier
§10). Marker traits + `#[diagnostic::on_unimplemented]` remain the Bevy-proven path.

---

## 7. Higher-tier gap map (on top of 06)

06's thesis holds. The full protocol-level write-up is
[10-cross-cutting-higher-tier.md](10-cross-cutting-higher-tier.md). Three structural upgrades,
not new projections:

1. **Session indexes die with the protocol.** SelectionGeometry, find MatchSet, DropGap, IME
   marks — leased like a drag preview, not always-on.
2. **Do not unify editor ranges with FlowIndex.** Monaco/Zed/xterm keep document selection (N
   cursors, column mode, IME as a third range) off the widget-tree walk. They share overlay
   *painting*, not a model. 06 §9's "collaborative cursors are N selection-protocol states" is
   the failure mode.
3. **Gesture arbitration is three machines.** UIKit failure DAG, Compose nested-scroll
   pipeline, CSS `touch-action` compositor pan claims. Predicate racing loses tap-vs-long-press
   and nested scroll. `.pan(Pan::VERTICAL)` is what keeps list scroll on the motion lane.

Also: container queries attach to an **ancestor** (`.container("rail", Axis::Horizontal)`), not
the querying node (06's `.container()` is self-size and reopens the cycle). Live regions exist
*before* the text change; announce `value`, not child text. Docking is two algebras (workbench
chrome + editor grid), not one `DockLayout`.

### Must-have upgrades to 06 (summary; details in the companion)

1. **Selection participants, not only a flow range.** Flutter's `SelectionContainer` lesson:
   nested `.selectable(Select::Contain | Exclude)`, and non-text leaves as flow atoms with
   app-provided copy text. Widget-tree selection is `(anchor, focus)` plus a **session**
   `SelectionGeometry` over resident rects. Editor N-cursors / column mode / IME-as-third-range
   stay a document algebra (Monaco/Zed/xterm); they share overlay *painting*, not FlowIndex.
   IME marked range is a session index that preempts widget selection on the focused atom.

2. **Gesture arbitration is three machines.** `require_failure::<Other>()` (UIKit DAG) is
   distinct from nested-scroll leftover deltas (Compose pre/child/post) and from `.pan()`
   compositor claims (`touch-action`). Predicate racing cannot wait 300ms; scroll-as-claimant
   fights nested lists. Buffered motion replay (already in 06) makes the DAG delay cheap.

3. **Scroll anchoring by key is not enough for sticky headers / pinned rows.** Lattice of the
   *arrangement*, never `0..scroll_index`. Sticky is a compositor pin plus scroll-state `Stuck`.
   Not a new projection.

4. **Shared model, many viewports.** Split editors / cloned tabs are one `Document` owner, N
   sites, N *document* selection states. FlowIndex covers widget-tree copy/a11y of each
   viewport, not the buffer's cursor algebra. 06 currently talks as if the manifest *is* the
   document.

5. **Find-in-page** is a `MatchSet` session index over FlowIndex, leased for the search
   protocol. A search generation rebases highlights the way selection endpoints clamp.

### Nice-to-have (library-shaped, but give them a protocol hook)

- Drag autoscroll: a recognizer that pipes into the scroll signal of the nearest scrollport
  while a drag claim is active. Zero new projection.
- Typeahead in trees: FlattenIndex iteration + a small protocol over focused row. App supplies
  the matcher.
- Command palette: not a gap, an app. `Latest<Vec<Hit>, SearchError>` in 04 already.
- Semantic zoom / minimap: extent summaries of Lattice/FlattenIndex (06 §9).
- Drop indicators in trees: overlay lane + `(parent, index)` from FlattenIndex, already in 06 §3.

### Rejected overkill

- A second selection document / attributed string tree (browser `contenteditable` inner model).
  FlowIndex + source maps are the native equivalent; a parallel tree drifts.
- Quadtree for grids. Lattice (two 1D sum-trees) is the Excel answer.
- Compile-time container-query solving, and 06's `.container()` on the *querying* node (self-size,
  cycle). Named ancestor `.container("rail", Axis::Horizontal)` + descendant `.when_container`;
  self-query unrepresentable.
- Unifying editor selection with FlowIndex; quadtrees; Deep Zoom; Theia/Phosphor dock;
  `contenteditable`; `aria-relevant`; animated theme tokens.
- Universal MVCC so `update_in` reads see writes. See §3.

---

## 8. Absorbed into 05

These patches are now normative in [05-one-register.md](../05-one-register.md). Kept here as
the research trail.

1. **§1 Closures.** Fn items taught; `Self::scope(|this| …)` or split `.scope(f)` **stable
   today**; bare closures through `IntoElement<'a, M>` unsupported (`#70263`); captured borrows
   a type error; `size_of::<F>() == 0` on `scoped`/`frozen`. `#[diagnostic::do_not_recommend]`
   on marker blankets. Next-solver / binder are watched, never load-bearing.
2. **§1 Return types.** Helpers, library widgets, and `View::view` return
   `impl Element + '_` (RPITIT). `Ui<'a>` is the nameable erased Element, **required** by
   retained scope producers (`F: for<'a> Fn(&'a O) -> Ui<'a>`). `UiBuf` is the owned opt-in.
   Composition is `fn pane(a: impl Element, b: impl Element) -> impl Element`. No TAIT, no
   `dyn View`, no `Row<(A,B,…)>` type tower. A function is the reusable fragment.
3. **§2 `update_in`.** Taught: extra args / sibling `rest`, no `&Owner` alias. If kept:
   `Draft<T>` / `Host<O>`. Lint on the leftover escape. Never STM.
4. **§2 / §7 Handlers.** `()` / `Emit<E>` / `Task` / `From<Fut>` / tuples stay `IntoEffects`.
   No `async fn(&mut Self)` that awaits. Turn-scoped `spawn`/`emit`; `Turn::run` for tests.
   Downloads-style `TaskHandle` fields remain the long-lived default.
5. **§4 / G1.** Machine-rate events and ports refuse `fn(&mut O)` / snapshots (`IntoLiveWire`,
   `_owner` escape). Click unchanged. No opcode ropes. No silent skip of `fn(&Self)` scopes.
6. **§4 / collections.** Fast path is the collection's type (`KeyedList::push`). `ListDelta`
   return is a hint, does not skip `view()`.
7. **§2 Signals.** `!Clone` + `Drop`; cell pool behind `Signal::new`. `scope.slot` requires a
   Scope. Copy writers remain banned.
8. **§4 Formatting.** `text!` + `text(format_args!(…))` as a call-site macro; format-as-function.
9. **G9.** Snapshot `Self::scope`, `Ui` reuse, and live-wire-port errors. Axum-shaped
   `#[debug_child]` proc-macro optional.

None of these add a noun an author must learn to write a counter. The new spellings that *can*
appear in ordinary code are `Self::scope`, `impl Element` helpers, `text!`, `spawn` during a
turn, and `KeyedList` methods — all ordinary Rust.

---

## 9. Verified compile corpus (1.97.1)

Temporary crate, edition 2024, not in-tree. Recreate as trybuild before treating as a gate.

| Case | Result |
|---|---|
| Fn-item as `F: for<'b> Fn(&'b O) -> Ui<'b>` | OK |
| Bare capture-free closure to that direct bound | OK |
| Same closure to marker `impl IntoEl<'a, M>` | FAIL (lifetime / mismatched `Ui`) |
| `Owner::scope(\|this\| this.overlay())` then `.child(...)` via marker | OK, no annotations |
| `Owner::scope(move \|this\| { let _ = n; … })` with `n: u32` | OK |
| Closure capturing `&String` through `hrtb` | FAIL E0373 |
| `Copy` `impl Element` bound and passed to `.child` twice | OK |
| `scope(\|this\| this.overlay())` *without* pinning `O = Self` | FAIL E0282 (needs annotation) |

The last row is why the adapter is an associated function on `View`, not a free `scope(f)`:
pinning `O` is the whole trick.

---

## 10. Sources

- Trait solver: [Inside Rust 2024-12-04](https://blog.rust-lang.org/inside-rust/2024/12/04/trait-system-refactor-initiative/),
  [project goal #113](https://github.com/rust-lang/rust-project-goals/issues/113),
  [LWN](https://lwn.net/Articles/1063124/), rust#107374.
- Closures: RFC 3216, [rust#97362](https://github.com/rust-lang/rust/issues/97362),
  [rust#70263](https://github.com/rust-lang/rust/issues/70263), `lending-iterator` `hrc_hint`.
  Next-solver global: [rust#160895](https://github.com/rust-lang/rust/issues/160895) (not default
  on nightly as of 2026-08-11). `do_not_recommend`: rust#132056, stable 1.85.
- Field projections: RFC 3735, rust#145383, [2026 goal #390](https://rust-lang.github.io/rust-project-goals/2026/field-projections.html).
- `super let`: rust#139076, [2026 goal](https://rust-lang.github.io/rust-project-goals/2026/redesigning-super-let.html).
- Async: RFC 3668, Rust 1.85; `async_fn_track_caller` rust#110011.
- Dioxus: [generational-box](https://docs.rs/generational-box), [0.5 discussion](https://github.com/DioxusLabs/dioxus/discussions/2160).
- Leptos: [ARCHITECTURE.md](https://github.com/leptos-rs/leptos/blob/main/ARCHITECTURE.md), `ArenaItem`.
- Xilem: [ARCHITECTURE.md](https://github.com/linebender/xilem/blob/main/xilem/ARCHITECTURE.md),
  `ViewSequence`, `memoize`; Raph Levien, [Xilem architecture](https://raphlinus.github.io/rust/gui/2022/05/07/ui-architecture.html).
- Compose: [Snapshot](https://developer.android.com/reference/kotlin/androidx/compose/runtime/snapshots/Snapshot),
  [MutableSnapshot](https://developer.android.com/reference/kotlin/androidx/compose/runtime/snapshots/MutableSnapshot).
- Flutter: `SelectableRegion` / `SelectionContainer` / `TwoDimensionalScrollView`.
- UIKit: `require(toFail:)`, `gestureRecognizer(_:shouldRequireFailureOf:)`.
- Ribir: [ribir.org](https://ribir.org/docs/introduction). Freya 0.4: [marc2332/freya](https://github.com/marc2332/freya).
- This packet: 04-rust-frontier.md, 05-one-register.md, 06-cross-cutting.md, 06-competitive-update.md,
  07-async-and-interaction-ux.md, azul-xilem.md, runtime/collections.md.
