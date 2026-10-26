# 07 — One Rust Surface

Status: **normative greenfield surface.** This replaces every earlier public-syntax proposal in
the reactivity plan. The runtime, rendering, text, history, and protocol documents remain the
mechanical specifications; when their spelling disagrees with this file, this file wins.

The final test is brutally simple:

> A small GPUI program is ordinary Rust with no macro. A hot program is the same Rust plus direct
> typed wires. A signal-dense program may opt into one macro. None of those choices changes the
> runtime, the meaning of control flow, or the element API.

There is no public `tracked`, `Either`, `.any()`, `Task`, hook order, effect language, chord
predicate language, or UI template grammar. There is also no typestate encoded in the shape of an
entire element tree. GPUI is strongly typed at the places where a proof prevents a real error and
deliberately monomorphic where a type only makes ordinary Rust harder to write.

---

## 0 · Keep the reason GPUI exists

The [GPUI ownership account](https://zed.dev/blog/gpui-ownership) is still the starting point.
Rust encourages a single ownership tree, while an editor needs shared models, dynamically chosen
subtrees, dialogs reporting to workspaces, asynchronous updates, and listeners that cannot borrow
their receiver forever. The application owner solved those problems without forcing all product
state into locks or an exotic graph. Its queued effects also solved a subtler problem: listeners
run after the current update, so notification is FIFO and non-reentrant.

Those are load-bearing wins. The new system keeps:

- one application owner for entities, windows, routes, platform resources, and committed epochs;
- typed shared handles for state that genuinely has independent ownership;
- immutable one-turn reads during each description and coherent committed presentation;
- queued mutation and run-to-completion delivery;
- retained identity through layout, input, accessibility, paint, and composition;
- explicit erasure at plugin, process, and kernel-storage boundaries.

It removes the ceremony that leaked those internals into application code: `cx` threading, lease
closures, manual `notify`, detached subscriptions, weak-self dances, framework tasks, and action
registries. A handler gets `&mut T`. A view gets `&T`. A worker owns its inputs. A later turn owns
its result.

---

## 1 · The final shape

There are two performance tiers but only one semantic model.

| Need | Authoring surface | Runtime price |
|---|---|---|
| small or ordinary view | normal `fn view` | owner describes; retained tape diffs |
| hot leaf/property | pass `&Signal<T>` | direct typed port; no Rust rerun |
| hot explicit structure | `sources.project(|values| ordinary Rust)` | one exact retained region |
| many interdependent signal branches | add `#[reactive]` to the same function | compiler-cut ports/regions |
| sync/async derived read | `source.map(...)` / `source.map_async(...)` | one mounted producer; same `Reader<T>` |
| first readiness / revalidation UX | low `boundary().loading(...)`; `is_pending` / `latest` | retained fallback/coherent cohort |
| durable changing rows | `List<T>` | splice/edit/move only affected slots |
| independent shared owner | `Entity<T>` | independent schedule and lifetime |

The first three rows require no macro and can reach the same runtime fast paths as the fourth. The
macro is bulk syntax removal, not the owner of a faster runtime.

The storage ladder remains small:

- `T`: ordinary owner-grained state;
- `Signal<T>`: independently publishable scalar state;
- `Vec<T>`: ordinary owner-grained sequence;
- `List<T>`: sequence with durable typed slots and deltas;
- contained `T: View`: state owned by its parent;
- `Entity<T>`: independently owned/shared state.

Promotion changes storage, not view architecture. A constant and a signal are accepted by the
same property sink; a `Vec` and a `List` are accepted by the same child sink.
`Reader<T>` is intentionally absent from the storage ladder: it owns no application value. It is
the uniform read capability produced by any storage/derivation whose value must cross an ownership
or latency boundary (§4, §7).

---

## 2 · The pivotal move: one borrowed `Element<'f>`

Every finished widget and every application helper returns the same small concrete `Element`,
borrowed for the duration of one description:

```rust,ignore
pub trait View {
    fn view(&self) -> Element<'_>;
}

fn toolbar(document: &Document) -> Element<'_> { /* borrows the document for this frame */ }
fn empty_state() -> Element<'static> { /* borrows nothing */ }
```

A function returning `Element<'_>` (or `Element<'static>`) is itself a root/child view. `View` is only needed when a named
stateful type earns its existence:

```rust,ignore
fn blur() -> Element<'static> {
    div().child("No adapter struct")
}

fn main() {
    let mut app = Application::new();
    app.open(Window::document(blur).title("Blur"));
    app.run();
}
```

`Window::document` accepts a `RootView` — a function item, an owned `Fn(Frame) -> Element`, an
`Entity<T: View>`, or a plain `T: View`. It invokes functions inside description, once per turn,
against that turn's frame; it does not snapshot `blur()` at application construction. `blur`
borrows nothing from a receiver, so its element is `Element<'static>`; a captured closure is fine
for a stateless projection over owned handles. Mutable local state still belongs in a normal
struct—only the empty `struct Foo; impl View for Foo` adapter disappears.

`Element<'f>` is not `Box<dyn Element>`. It is a compact **draft cursor** into the current
description frame: a node key plus a short packet range in a per-turn bump arena. Constructors and
setters append sealed opcodes whose operands may **borrow** — a `&str` slice, a `&[T]`, a
source key — directly from `self` and from that arena; nothing is cloned, interned, or refcounted
merely to name it. Mount **diffs** the draft against the retained slabs and promotes only the
changed operands to owned storage. Dispatch is by opcode/table at the kernel boundary, which the
renderer already needs. There is no per-node vtable call, and the steady-state description does no
heap allocation at all — appends are pointer bumps into the arena, the same operation Dear ImGui
performs when it "outputs vertex buffers and a small list of draw call batches"
([ocornut/imgui](https://github.com/ocornut/imgui)). The lifetime `'f` is what keeps that borrow
honest, and §2.1 is the proof that it cannot leak.

### 2.1 Why `Element<'f>` borrows — the frame arena

An earlier draft of this file erased the lifetime: a concrete `Element` that *owns* its tape, so
every borrowed operand had to be copied or interned into that tape at the moment of description.
That was a mistake, and it was the mistake the rest of this plan kept tripping over. Eager
materialization means a `text(&self.name)` clones a `SharedString` on **every** description, for a
string that is byte-identical to last frame and will be diffed away microseconds later. It is a
per-frame allocation tax on exactly the hot path, it forced a second `Primitive` API for anything
that wanted zero-copy paint (§15.2), and it made "match zgui by construction" (§14.1) impossible,
because the description pass was doing work an immediate-mode toolkit never does.

So the lifetime comes back, but with a precise meaning. `Element<'f>` borrows from **one frame**:
the single description turn that produced it. `'f` is not `self`'s lifetime and not `'static`; it
is the lifetime of a per-turn **bump arena** the kernel opens before description and drops after
commit. Building an element is appending borrowed operands to that arena:

- `&Signal<T>`, `&List<T>`, `&Entity<T>`, and `&Target<K>` append a two-word `Copy` source key
  (already owned; nothing to clone);
- `&str`, `&[T]`, `Color`, and small styles append the **borrow itself** — a fat pointer into
  `self` or a `memcpy` of scalars into the arena, never a `SharedString`/`Arc` allocation;
- a temporary like `format!(…)` is moved into the arena and referenced as `&'f str`;
- already-owned large resources (`Arc`, rope snapshots, images, media, scene models) append their
  cheap owned handle, exactly as before.

Retention is a **separate owned representation, produced by the diff, not by description.** At
commit the draft is compared slot-by-slot against the retained slabs. An unchanged operand costs
nothing — last turn's owned copy stays. Only a *changed* operand is promoted (`&'f str` →
`SharedString`, `&'f [T]` → `Arc<[T]>`), and a signal-backed property is never promoted at all: it
installs a direct port that reads the signal's own inline storage. This is precisely the trade
GPUI already makes for glyphs — cache the stable thing, cheaply rebuild the description — stated as
a data-structure law: *the borrowed frame pays for the frame; the diff pays only for the delta.*
It is strictly less copying than the owned-`Element` draft, and zero on an unchanged subtree.

The borrow is sound **by construction**, not by review. `'f` is a *generative* brand, the
`GhostCell`/[`generativity`](https://docs.rs/generativity) trick: description runs inside an
invariantly-quantified scope, and `Element<'f>` (and every builder) is tagged with that brand.

```rust,ignore
// kernel-internal; application code never spells the brand
pub struct Frame<'f>(PhantomData<fn(&'f ()) -> &'f ()>); // invariant, unforgeable

fn describe<R: RootView>(root: &R, f: Frame<'_>) -> Committed {
    let draft = root.view(f);   // Element<'f>: may borrow root + f's arena
    commit(draft)               // diff + promote; arena dropped here
}
```

Because `'f` is invariant and universally quantified, an `Element<'f>` provably cannot be stored in
a `'static` field, sent to another thread, smuggled into the next frame, or returned past
`describe` — the borrow checker rejects it the same way it rejects a `GhostCell` token escaping its
branding closure. `Element<'f>` is additionally move-only, `!Send`, `!Sync`, and `#[must_use]`.
Reusing a consumed element is a type error; an unconsumed draft simply dies with the arena and is
inspector-attributed. There is no runtime check and no `unsafe` in application code; the no-escape
guarantee is the type system's, paid for at compile time.

The common `fn view(&self) -> Element<'_>` never spells `Frame` or the brand: elision unifies the
returned `'_` with the turn's immutable owner borrow, which the kernel already holds for the whole
description (§13), and that borrow *is* the frame. The one place friction surfaces is a **stateless free
function that builds arena temporaries but borrows no receiver** — it must name the frame
(`fn empty_state(f: Frame) -> Element<'_>`) or borrow nothing and be `Element<'static>` like
`blur`. That is the honest cost of the trade, and it is rare: borrowing from `self` is the
overwhelmingly common shape, and it reads with a single elided `'_`.

This is a real trade, not lifetime magic. GPUI still cannot *retain* an arbitrary `&str` or
`&[T]`; large owned state that must cross into async or the next epoch must become `SharedString`,
`Arc<[T]>`, a rope snapshot, `Reader<T>`, or a media/scene handle at that boundary. The gate (§14,
§17) compares per-frame allocations and refcount operations against today's `AnyElement` path and
against zgui's retained loop. If the borrowed frame merely moves hidden allocation somewhere else,
the design fails.

With the lifetime honest, ordinary Rust arms unify naturally:

```rust,ignore
fn view(&self) -> Element<'_> {
    let body = if self.document.is_empty() {
        empty_state()               // borrows nothing → Element<'static>, coerces into 'f
    } else {
        editor(&self.document)      // borrows self → Element<'_>
    };

    if self.full_screen {
        canvas(body)
    } else {
        window_frame(body)
    }
}
```

No `Either::Left`, `Either::Right`, `.any()`, box, result builder, or macro is involved. `Option`
and iterators also work directly because `Option<Element<'f>>` and `Iterator<Item = Element<'f>>`
are normal child inputs — every arm shares the one frame brand, so a `match` that returns unlike
widgets type-checks with no erasure.

The type erasure happens once, at element completion, rather than recursively in application
types. This deliberately caps monomorphization: a helper changing its internal tree does not
change the return type of every caller, and a large application does not encode its entire UI in
one enormous generic type. The brand `'f` is a single lifetime parameter shared by the whole
description, not a new type per subtree.

### 2.2 Strong typing moves to the inputs

The concrete output does not mean a stringly builder. GPUI applies types where they prove local
facts:

- `Flex`, `Grid`, `Stack`, and `TextFlow` are distinct layout recipe types;
- `Px`, `Rem`, `Angle`, `Duration`, `Color`, `Brush`, and `Opacity` are real newtypes;
- `Target<Button>`, `Slot<Row>`, `Entity<Document>`, and `Output<Picked>` cannot be mixed;
- `Property<T>` only accepts constants or sources producing exactly `T`;
- `Input<T>` and `Output<T>` make dataflow direction explicit;
- required callbacks/bindings are constructor arguments;
- incomplete shader, drag, and controlled-input obligations use short local proof builders and
  produce `Element` only when complete.

The invariant is checked where the mistake is made. The proof type does not infect unrelated
styles, child types, branch arms, helpers, or the application link graph.

### 2.3 Describe-time compute is a kernel phase, not application mutation

Purity at the application seam must not erase the work a serious text engine necessarily performs
while geometry is known. Zed's `EditorElement` currently enters `editor.update(cx, ...)` more than
forty times from layout and prepaint. Much of that is not accidental model mutation: wrapping,
line shaping, block measurement, visible-range construction, hit geometry, and display-map
maintenance are demand-driven computations whose inputs do not exist until the frame is described.

The replacement is a named, sealed **kernel** phase:

```rust,ignore
editor_surface(&self.document)
    .layout(|cx: LayoutCx<'_>| EditorLayout::compute(cx, &self.viewport))
    .geometry(|cx: GeometryCx<'_>, layout| EditorGeometry::compute(cx, layout))
    .paint(|cx: Paint<'_>, geometry| EditorPaint::emit(cx, geometry));
```

`LayoutCx` is not the old omnipotent `&mut Context<Editor>` with a better name. It can read one
revision-stamped immutable input cut, request text/font measurement, demand phase memos, update
only the surface's retained layout/projection cache, and emit typed `Measure`, `Shape`, `Wrap`, or
`Layout` obligations. `GeometryCx` can derive hit/selection/accessibility geometry from the sealed
layout result. `Paint` can only append renderer-neutral packets. None can mutate application
entities or signals, dispatch commands, focus a target, start effects, or recursively flush.

These computations live below `View::view(&self)`, are dependency-tracked and revision-keyed, and
may run many times while a frame converges without making those invocations application turns.
Their unpublished drafts are disposable. If a layout input changes, the kernel invalidates the
smallest phase memo. `LayoutCx` still cannot spawn: when geometry reveals new soft-wrap work it may
only emit an owned, revision-keyed `WrapDemand` into the private display-pipeline draft. At the
phase/epoch barrier the kernel deduplicates that demand and arms an already-mounted wrap producer;
the result cannot re-enter the same frame. Its runtime wake follows §7.0 and dirties that phase memo
for the next flush. Inline blocks that require measure/reflow use a separately budgeted
`LayoutFeedback` lane with monotonic convergence or an explicit iteration cap—not an unrestricted
geometry-to-effect edge. This is the one sealed text-kernel bridge; application layout cannot turn
measurements into arbitrary work.

A phase fault discards the candidate geometry, not the document. Thus “view is pure” remains true
at the architectural seam while the text engine gets an honest, optimized home for describe-time
compute instead of being rewritten as fake app reactivity.

---

## 3 · Builder typing without branch poisoning

The request in [zed#12390](https://github.com/zed-industries/zed/issues/12390) is correct: a
flex-only operation should not autocomplete on an ordinary box. Encoding `display: flex` in
`Div<Flex<Wrapped<Gap<...>>>>`, however, makes a useful local check become a global type problem.

The solution is a typed recipe passed into a monomorphic element:

```rust,ignore
div()
    .layout(Flex::row()
        .align(Align::Center)
        .gap(8)
        .wrap(&self.wrap))
    .bg(theme.surface)
    .child(content)
```

`Flex` owns `row`, `column`, `wrap`, `justify`, `align`, and `gap`. `Grid` owns `columns`, `rows`,
`areas`, and grid placement. Those methods do not exist on the wrong recipe, so completion is
useful and misuse fails at the exact call. `div().layout(...)` accepts a sealed `Layout` recipe
and still returns `Element`.

Conditional configuration is plain Rust and needs no builder closure:

```rust,ignore
let layout = Flex::row().align(Align::Center).gap(8);
let layout = if *self.wrap { layout.wrap(true) } else { layout };

div().layout(layout).child(content)
```

The common live spelling is shorter:

```rust,ignore
div().layout(Flex::row().gap(&self.gap).wrap(&self.wrap));
```

Changing layout families also uses normal control flow because both calls finish as `Element`:

```rust,ignore
let panel = if *self.compact {
    div().layout(Flex::row().gap(8))
} else {
    div().layout(Grid::columns(2).gap(12))
};

panel.bg(theme.surface).child(content)
```

There is no `.flex(|f| ...)`, capability-intersection type, or macro-generated join. The trade is
intentional: layout-specific configuration lives together in one typed value instead of being
interleaved through every common element method. Stored design tokens also become natural:

```rust,ignore
const TOOLBAR: Flex = Flex::row().align(Align::Center).gap(8);
div().layout(TOOLBAR).child(actions)
```

`row()` and `column()` remain convenience constructors returning `Element` with the corresponding
static `Flex` recipe. The explicit recipe form is used when layout itself is configured or live.

---

## 4 · Signals: references are wires, dereferences are reads

`Signal<T>` owns one current value inline in its owner. It implements `Deref<Target = T>` and
publishing `DerefMut`; mutation still requires `&mut self` and cannot occur during view code. A
post-handler description therefore reads current model intent. §7 may retain an older **sink
operand/presentation tape** while async work settles, but never implies that arbitrary `T` was
cloned into a second hidden model version.

```rust,ignore
fn increment(&mut self) {
    *self.count += 1;
}

fn view(&self) -> Element<'_> {
    column().children((
        text(&self.count),                 // direct text property port; borrows the signal key
        text(format!("{}", *self.count)), // temporary formatted into the frame arena; owner reruns
    ))
}
```

A property reference is the zero-ceremony fast path. Sealed `IntoProperty<T>` implementations
turn `T`, `&T`, `&Signal<T>`, `Reader<T>`, and typed projections into the same installed port.
After installation, a signal publication patches the property slab without calling application
Rust and without allocating. If that destination belongs to an async-held presentation cohort,
the patch is staged in its candidate slab while the already-owned presented property operand stays
unchanged; GPUI retains the sink value, not a second arbitrary copy of the signal's model `T`.

`Reader<T>` is the common read capability at an ownership or latency boundary. It contains only a
typed source key and never a `T`; unlike the always-ready `Signal<T>`, it does not implement
`Deref`. A reader may name a signal, synchronous derivation, async derivation, application
resource, or externally driven cache without exposing which one to its consumer. Passing a reader
copies the key. Consuming it means installing it directly in a property sink or opening the
ready-only `project` region described below. §7 defines pending, faults, and coherent async
publication; none of those states add an `Option<T>` to the reader's type.

For structural work without the macro, sources expose one combinator:

```rust,ignore
fn view(&self) -> Element<'_> {
    (&self.open, &self.mode).project(|(open, mode)| {
        if *open {
            match mode {
                Mode::Insert => insert_dialog(),
                Mode::Normal => normal_dialog(),
            }
        } else {
            placeholder()
        }
    })
}
```

`project` is the replacement for `tracked`, not a renamed tracker:

- its dependencies are the typed source or tuple on the left, never ambient reads;
- the closure receives committed references and contains unrestricted Rust control flow;
- it returns any accepted sink value (`Element`, property value, `Option<Element>`, iterator,
  scene packet), not a special reactive type;
- the kernel has an exact static edge list before the first run;
- tuples are implemented to a deliberately modest arity; a named struct of readers handles more;
- nested projections fuse when their schedules and retention policy match.

For a `Reader<T>`, the closure is invoked only with a ready `&T`. A pending/fault verdict bypasses
the closure and travels through the retained graph to the nearest boundary, while an already
committed output stays available according to §7's revalidation policy. This is the no-macro Rust
equivalent of a compiled lazy JSX expression: the absence of a value is represented by whether the
region may run, not by changing the closure argument's type.

The closure is acceptable here because it is an explicit boundary around signal-driven work and
immediately returns to regular Rust. Closures are not used merely to mutate a builder.

For a single direct value, normal property wiring remains preferable to `project`. For many
cross-cutting branches, the one macro removes the tuple and closure.

### 4.1 `List<T>`

`List<T>` is contiguous storage plus a generational slot directory and delta log. `Slot<T>` is
identity, never an index. Reads dereference to `[T]`; mutation is through delta-preserving verbs
such as `push`, `take`, `edit`, `replace`, `move_before`, and `insert_at`. It intentionally has no
`DerefMut<[T]>`.

```rust,ignore
.children(&self.temporary_rows, Row::view) // Vec: rows realign
.children(&self.rows, Row::view)           // List: durable slots and deltas
```

Delivery revalidates every slot. Stale state is `Option`, not a panic. A row that needs durable
local state while backed by a `Vec` produces a located diagnostic naming `List<T>` as the fix.

### 4.2 Motion is a property value, sampled on a timeline

Current GPUI's `with_animation("id", …, |element, t| …)` mixes identity, time, interpolation, and a
per-frame Rust closure. The replacement is a borrowed mount descriptor accepted by the same typed
property sink as a constant or signal:

```rust,ignore
fn view(&self) -> Element<'_> {
    let reveal = animate(&self.reveal)
        .spring(Spring::snappy().preserve_velocity());

    popover()
        .opacity(reveal)
        .translate_y(reveal.reverse().scale(8))
        .child(icon(SPINNER).rotate(repeat(1.turn().over(2.s()))))
}
```

`animate(&Signal<T>)` means “observe this target and present a sampled `T`.” `over`, cubic Bezier,
spring, delay, keyframes, sequence, parallel, race, repeat, reverse, and gesture handoff are normal
values/combinators. `Motion<'f, T>` is a small `Copy` draft key; its temporary program type is erased
at mount into a compact `MotionProgram` and does not propagate through `Element<'f>` or application
signatures. Reusing one key installs one sampled track with several typed output ports, not duplicate
samplers.

A program separates four things that animation APIs often blur together:

- **timeline:** monotonic presentation time, scroll, gesture, media, or explicit demo time;
- **effect:** tween/keyframes/spring/decay/FLIP plus its interpolation and velocity rules;
- **playback:** delay, fill, pause, seek, direction, rate, iteration, finish, and cancel;
- **composition:** `Replace` by default; `Add`/`Accumulate` only for types with reviewed algebra.

Built-in numbers, lengths, angles, transforms, colors/brushes, paths with compatible topology, and
shader parameter fields have generated interpolation metadata. A custom `Interpolatable` must define
distance and, for a spring, velocity semantics; “four floats happen to lerp” is not sufficient.

Retargeting first samples the value and velocity actually presented at the interruption instant.
`jump(target)` is the explicit discontinuity that resets velocity. A timestamp produces the same
timed/keyframe result at 60 Hz, 120 Hz, or irregular cadence. The built-in damped spring evaluates
analytic position and velocity from its initial conditions rather than using variable-delta Euler
integration. Any custom numerical motion declares a fixed-substep/checkpoint policy and is checked
against the same reference sampler. Reduced motion substitutes/snaps while reaching the identical
final state. Completion is one typed queued output, never a per-frame application callback.

Active programs live in kind-segregated dense lanes for paint, transform/opacity, placement,
layout, shader uniforms/ranges, and structural hosts. One injected frame clock samples each active
lane and batch-patches retained destinations directly. There is no signal write, owner turn,
dependency discovery, heap allocation, or one task/effect per animation frame after warm-up.
Dormant tracks request no frame. Code that never supplies a motion value allocates no lane, clock
subscriber, composite layer, or shader variant.

Layout motion names its cost. Numeric layout fields can request incremental layout; fit/content and
other intrinsic modes use an explicit measured proxy, FLIP, or crossfade/reflow fallback. Structural
enter/exit/hero motion commits the new logical tree first, then holds byte/time-bounded old/new
presentation snapshots. Those snapshots are visual only: they cannot retain focus, hit targets, or
accessibility nodes after logical removal.

---

## 5 · Exactly one optional macro

There is no macro in the basic path. Signal-dense view functions may add one attribute:

```rust,ignore
#[reactive]
fn view(&self) -> Element<'_> {
    column().children((
        toolbar(&self.document),
        if *self.open {
            dialog(match *self.mode {
                Mode::Insert => insert_form(&self.name),
                Mode::Normal => normal_help(),
            })
        } else {
            placeholder()
        },
        text(format!("{} / {}", *self.current, self.slides.len())),
    ))
}
```

It is the same Rust that would compile without the attribute. `Element` has already solved branch
typing; the macro exists only to cut many visible signal reads into direct property ports and
retained `project` regions. It may also give lexical action sites stable identity. Removing the
attribute changes scheduling counters, not pixels, event order, state, focus, accessibility,
evaluation order, drop order, or error behavior.

The macro does not pretend to see through an opaque helper. A helper returning a sealed property
projection keeps that projection's exact edges; any other helper call becomes one owner- or
entity-grained retained region. Extracting a function may widen scheduling, never change meaning
or silently install ambient dependencies.

The same limit is decisive for async. A stable proc macro sees syntax, not rustc's inferred types,
so it cannot discover that arbitrary field access is a possibly-pending `Reader<T>` read. It may
fuse explicit reader/projection bindings and give their producer sites lexical identity; it may not
turn `reader.field` into hidden suspension. The normative spelling at the first async consumer is
`reader.project(|value| ...)` (§7.1), with a real `&T` inside. Async correctness, boundaries, and
parallel work discovery do not depend on the attribute.

There is no `#[view]` and `#[view(fine)]` pair. `#[reactive]` is the only UI semantics macro.
Simple views do not decorate themselves to satisfy the framework.

### 5.1 Why this cannot honestly be `macro_rules!`

A declarative macro can forward a `$block:block` or `$expr:expr`, but the
[Rust Reference's forwarding rule](https://doc.rust-lang.org/reference/macros-by-example.html#forwarding-a-matched-fragment)
deliberately makes that fragment opaque to downstream matchers. It cannot walk arbitrary Rust
`if`, `match`, `?`, method calls, and borrow scopes and rewrite selected expressions. Capturing
every token as `tt` would require GPUI to reimplement a Rust parser and still could not perform the
needed semantic classification. Requiring special branch tokens would create the third language
this design is trying to avoid.

Therefore the macro is an **optional attribute proc macro**, and it does not stabilize until its
editor experience passes gates below. The no-macro `project`/property APIs are the normative
runtime surface and remain equally fast. If proc-macro completion, rename, diagnostics, and span
mapping are not excellent in rust-analyzer, GPUI ships without `#[reactive]`; it does not ship a
declarative DSL as a consolation prize.

The expansion target is public, readable Rust:

- direct `Property<T>` ports;
- typed `Sources::project` regions;
- mounted sync/async producer descriptors and ready-only reader projections;
- mounted `ActionSite<T, E>` records;
- ordinary element builder calls.

`cargo expand` must be understandable. Diagnostics point to original expressions. Go-to-definition,
rename, completion, inlay hints, rustfmt, and extract-function are acceptance tests, not polish.
The macro may not rewrite a function signature, synthesize fields, extend a borrow, or infer
fallibility away.

---

## 6 · Handlers are methods with return values

The route shape is:

```text
fn(&mut Receiver, [site context], [event], [bound inputs]) -> R
```

The receiver selects the owner. Site context supplies values such as `Slot<T>`, `Win`, or a drag
payload that delivery has already validated. `.with(...)` binds trailing owned inputs. `R` is
interpreted by the registration that asked for it.

### 6.1 Guard the function, never the chord

This is invalid:

```rust,ignore
.on_key(Key::Escape.guard(Workspace::in_insert), Workspace::to_normal)
```

The handler owns state-dependent dispatch using ordinary control flow:

```rust,ignore
editor_surface().on_key(Key::Escape, Workspace::escape);

fn escape(&mut self, event: KeyEvent) -> KeyEvent {
    if !self.in_insert_mode() {
        return event.propagate();
    }

    self.to_normal();
    event.consume()
}
```

A `()` key handler consumes after it runs. Returning the event explicitly chooses consumption or
propagation. Pointer and gesture events follow the same law. There is no `IntoGuard`, predicate
registry, string context, or action table for an ordinary shortcut.

### 6.2 Component outputs are named obligations

General `.child(component).on(...)` subscriptions hide lifecycle in presentation and are deleted.
A reusable component stores named typed routes, requiring important ones in its constructor:

```rust,ignore
pub struct Typeahead {
    picked: Output<Picked>,
    cancelled: Output<Cancelled>,
}

impl Typeahead {
    pub fn new(picked: impl Route<Picked>) -> Self {
        Self {
            picked: Output::required(picked),
            cancelled: Output::ignore(),
        }
    }

    pub fn on_cancel(mut self, route: impl Route<Cancelled>) -> Self {
        self.cancelled = Output::optional(route);
        self
    }
}
```

The host binds the back-edge where it constructs state:

```rust,ignore
search: Typeahead::new(Workspace::open_suggestion)
    .on_cancel(Workspace::restore_focus),
```

`Output<E>` erases the host only after its method has type-checked. It parks before mount, arms
against the concrete mount route, and dies on unmount. A required unresolved output is a located
mount error. `Option<E>` means no output; `Result<E, Err>` remains visible according to the
declared route policy.

### 6.3 Remappable product commands still need names

Zed does not only have local key handlers. Its command palette, menus, extensions, remote
protocols, and user keymaps must refer to an operation without holding a Rust function item. That
is a legitimate registry boundary and survives as typed `Command<A>`:

```rust,ignore
const SPLIT: Command<Axis> = Command::new("pane.split");

pane()
    .command(SPLIT, Pane::split)
    .on_key(Key::Backspace, Pane::backspace);
```

Keymaps and menus store the stable command protocol id plus serialized `A`; registration proves
that `Pane::split` accepts `Axis`. A command handler still performs its own state guard and returns
normal `EventFlow`/`Result`. Bare keys and clicks do not need a command name. This replaces the
current untyped action/listener adapter without pretending that a large editor can delete its
command catalog.

### 6.4 Observing another entity is a method on a trait, not a stored bus

`Output<E>` (§6.2) is a *child* reporting up to the host that built it. A different need is one
entity reacting to *another* entity it holds: a workspace re-indexing when its buffer changes, or
handling a project rename. GPUI's `cx.observe`/`cx.subscribe` did this with weak handles and
self-capturing closures. A stored `on_change: Output<()>` field is no better — it is untyped (`()`
carries nothing), and it is ceremony: a field, a manual `.emit()`, and a hand-rolled event enum.

The honest shape is a trait on the *observed* type and a verb on its handle. Any-change needs no
event at all; a typed event declares its contract once:

```rust,ignore
// Any-change: fires once after any committed &mut turn dirties the entity. No payload, no field.
// Replaces cx.observe.
buffer.on_change(Workspace::persist);

// Typed events: the emitter declares its contract; observers name a method.
impl Emitter for Project {
    type Event = ProjectEvent;
}
project.on(Workspace::on_project);   // route must accept ProjectEvent — checked at the call
```

Neither `on_change` nor `on` returns a handle to store. The link **parks at construction and arms
at mount** against the observing entity — the one that owns this handle as a field — exactly like
`Output` (§6.2), and is torn down when either entity unmounts. The subscription lives in the
non-generic entity kernel (§9), so there is no weak-upgrade dance, no `Subscription` to drop by
hand, and no `()` bus. Because the payload is `Emitter::Event`, a handler of the wrong type is a
compile error, not a silent no-op. The emitter raises its own event from inside a normal method
with `self.emit(ProjectEvent::Renamed(name))`, available because `Project: Emitter` — distinct from
`self.output.emit(..)`, which fires a component back-edge.

This stays explicit — you still write one typed line, because §15.1's rule holds: a many-to-many
effect bus cannot be safely inferred. What changes is that the explicitness is that line, not a
field plus a manual emit plus an untyped enum. `Signal`/`List` remain the answer when the observer
wants a *value* rather than an *effect*: reading `buffer.text` in a view records a dependency and
patches without any subscription at all.

`on_change` is entity-grain — any commit. When you need an effect at **field grain**, `on_change`
also accepts a *derived wire*, not only an `Entity`: `buffer.text.map(detect_language).on_change(Self::f)`.
The equality gate lives in the wire (`signal.map(f)`; the `Projection` result is never named, the
wire is built inline at the subscription site), so the handler fires only when the derived value
actually changes — not on every keystroke that dirties the entity — and it is delivered the new
value (`fn(&mut Self, Language)`), where the entity form carries no payload. This is the existing
verb over an existing source, not a new noun; it is the honest replacement for `cx.observe` + a
hand-rolled `if new != old` diff. Worked example, with the construction→mount binding and
turn-ordering spelled out: [examples/derived_observe.rs](examples/derived_observe.rs).

---

## 7 · Rust owns work; the graph owns latency

The earlier rule that GPUI “does not own an async model” went too far. GPUI must not invent a
second application-visible executor, future wrapper, `Task<T>` field, `detach`, or async context.
It should use real Rust runtimes for polling, timers, I/O, blocking pools, and cancellation. It
**must** own only what a latency-bearing value means after it enters the reactive graph: declared
inputs, mounted identity, readiness, request generations, stale-result rejection, coherent
presentation, cancellation of delivery, and fault propagation.

That distinction is the Rust form of Solid 2's useful split between creating, consuming,
blocking, and reading an async value
([article](https://www.solidjs.com/blog/async-solid-fetch-high-block-low),
[async RFC](https://raw.githubusercontent.com/solidjs/solid/next/documentation/solid-2.0/05-async-data.md)).
Creating work is a scheduling/ownership decision. Blocking is a presentation decision. A component
between those points carries a value capability and neither awaits nor invents loading state.

There is one graph read facade:

```rust,ignore
pub struct Reader<T> {
    raw: RawSource, // small typed generational key; no T and no executor handle
    marker: PhantomData<fn() -> T>,
}
```

`Signal<T>::reader()`, a synchronous projection, an async projection, an application resource, and
an external cache adapter all produce the same `Reader<T>`. A `Reader<T>` is `Copy`, inert, and
cheap to pass through component constructors. It deliberately does **not** implement `Deref`:
before first readiness there is no `T` to borrow, and a Rust dereference must not secretly block,
return a hole, or unwind. `Signal<T>` retains §4's convenient `Deref` as the always-ready local
refinement; latency-agnostic component inputs use `Reader<T>`.

Rust has to spell the one place where a future is created. That is an honest language boundary,
not a parallel resource API:

```rust,ignore
fn local_story(id: StoryId) -> Story { /* ... */ }
async fn fetch_story(id: StoryId) -> Result<Story, LoadError> { /* ... */ }

let story = selected_id.map(local_story);                 // Reader<Story>
let story = selected_id.try_map_async(fetch_story);       // Reader<Story>
let byline = story.map(|story| format_byline(story));     // Reader<String>; latency composes
```

`map_async` admits an ordinary `Future<Output = T>`; `try_map_async` admits
`Future<Output = Result<T, E>>` and lifts `E` into the graph's typed failure channel. Both return
`Reader<T>`. If a caller wants an error to remain an ordinary value and branch with Rust, it uses
`map_async` with `T = Result<U, E>`. CPU work has the corresponding `compute`/`try_compute` producer
verb so choosing an I/O executor versus a CPU pool is visible exactly once, at creation. Everything
downstream is the same reader graph.

An async edge is a **mounted producer site**, never an unowned future recreated by view execution.
The common form is a durable `Reader<T>` field created during owner construction. Conditional/tree-
local work uses an explicit retained producer descriptor whose surrounding mount identity (and
collection key when repeated) owns its private cell. Source location is a diagnostic, not identity:
owner + line number alone is ambiguous across repeated helpers, branches, and rows. There is no
anonymous `resource(...)` local whose retention depends on call order, and no hook index. A
descriptor parks during description, arms only after its candidate record commits, and dies when
its owner/mount generation is revoked.

### 7.0 The whole runtime bridge is one wake law

The implementation is deliberately smaller than the semantics it enables, with one Rust-precise
qualification:

> **At the graph boundary, an async completion is only a stamped memo update scheduled for the
> next reactive flush. A `Future` wake itself only schedules another poll.**

That is the kernel, not an analogy. An async producer is an ordinary memo node with a private
`Empty | Ready(previous) | Pending(request) | Fault` evaluation record. Its future is polled by
Tokio, smol, GPUI's existing foreground executor, a host runtime, or another declared driver. The
runtime remains responsible for reactors, timers, work stealing, blocking pools, and physical
cancellation. GPUI does not proxy each poll and does not build a shadow resource scheduler.

`Waker::wake` may be duplicate or spurious and carries no value. It stays inside the driver as a
coalesced `PollWake`; it cannot dirty a graph node, run a memo, or start a flush. When polling
actually returns `Ready(value_or_fault)`, the driver puts the owned outcome in a private completion
slot and enqueues one small record through the same generational ingress core as `Remote<T>`:

```rust,ignore
StampedCompletion {
    node: RawSource,
    owner_generation: Generation,
    request_ticket: Ticket,
    slot_generation: Generation, // owned ReadyOrFault is already in the private slot
}
```

Enqueueing a `StampedCompletion` is `Send`, host-wake-capable, and inert: it never runs application
Rust, edits a tree, or publishes presentation reentrantly. The next normal turn validates the
stamps in §7.5, stages the accepted outcome, marks that ordinary memo dirty, and lets the next
reactive flush settle it through the same height, equality, fault, and commit machinery as a
synchronous memo. A completion arriving during a flush waits for the following turn. Stale or dead
completions are cheap drops.

Tokio, smol, GPUI's local executor, and host/custom runtimes all retain their normal polling loops.
A local driver may queue `PollWake`s on the UI thread, but it polls in the driver phase with no
application borrow live, never from description or reactive settle. In every adapter only the
driver polls futures and only the reactive flush publishes nodes. Repeated wakes collapse to one
scheduled poll; exactly one `Ready` outcome crosses ingress.

The default application installs GPUI's existing runtime handles, but hosts may inject Tokio, smol,
or their own adapter once. `map_async` selects the default I/O lane; `map_async_on(runtime, f)` and
`compute_on(pool, f)` make exceptional affinity visible at the producer and nowhere downstream.
The adapter is a scheduling capability, not ambient context threaded through view code.

```text
signal write -> reactive flush -> dirty async memo -> runtime.spawn(frozen input)
runtime poll / I/O / timer -> PollWake -> runtime polls again
runtime observes Ready -> StampedCompletion(node, ticket) -> next normal turn
                              -> dirty memo -> reactive flush -> ordinary readers settle
```

The complete worked pressure test is
[`examples/async_workbench.rs`](examples/async_workbench.rs): parallel item restoration, low
boundaries, revalidation, failures, an async editor display pipeline, nested minimap, durable
identity, post-commit focus, weak cycles, and ordered/coalesced presence all use this one ingress.

The richer ideas below—first readiness, retained stale content, `is_pending`, coherent reveal,
typed failure, and stale-result rejection—are metadata and commit policy on this same memo node.
They are not another scheduler. A single derived value therefore needs no manual `Remote::send`;
the producer adapter receives a private completion sink built on the same ingress machinery.
`Remote<T>` remains the public escape hatch for actor commands and streams whose messages are the
application protocol rather than the completion of one memo evaluation. Coalescing a wake never
drops reliable protocol data; the service's bounded inbox owns that policy.

### 7.1 Passing is not reading; `project` is the honest Rust await point

Intermediate functions accept and forward `Reader<T>`, never `Future<T>`, `Option<T>`, or
`Result<T, E>`:

```rust,ignore
fn story_page(story: Reader<Story>) -> Element<'_> {
    div().layout(Grid::columns(2)).children((
        sidebar(),
        main().child(story_detail(story)),
    ))
}

fn story_detail(story: Reader<Story>) -> Element<'_> {
    story.project(|story: &Story| {
        article().children((
            h1(&story.title),
            text(&story.text),
        ))
    })
}
```

Copying the reader into `story_page` does not consume it. `project` installs a retained consumer
region and invokes its closure only when the reader has a value, so inside the closure `story` is
plain `&Story`, not `Option<&Story>`. A direct property sink is even smaller:

```rust,ignore
h1(story.map_ref(|story| story.title.as_str()))
```

The private evaluator has a three-way verdict—`Ready(&T)`, `Pending(wait_set)`, or
`Fault(failure_key)`—but that enum is not application state and is never returned by a reader.
Property ports and projections understand the verdict. `Loading` and fault boundaries consume it.
This is the same graph path for sync and async values; only a producer happens to have latency.

A retained reader projection is conceptually
`for<'f> Fn(&'f T) -> Element<'f> + 'static`: every invocation receives a fresh value/frame borrow
and returns a fresh draft. It cannot capture `&self` or retain `Element<'f>` across turns. The
owner-method form stores a function item plus an owner key and reborrows that owner for each future
description; it never lengthens the original borrow. Retained behavior owns keys/data, then borrows
phase-local state only while it runs.

Imperative code and tests use `reader.resolve().await` to obtain an owned snapshot or `Failure` for
the reader's current generation. `resolve` is illegal during description—it is a one-shot wait, not
a hidden dependency—and never blocks the UI executor. That is the bridge for startup sequencing or
protocol code; view code stays on projections and boundaries.

Stable Rust cannot simultaneously provide arbitrary `story.title` syntax for a possibly absent
`T`, avoid `Option`/`Future`, avoid blocking, and avoid unwinding. The plan chooses the retained
consumer boundary. `#[reactive]` may fuse recognized reader bindings and explicit projections, but
a proc macro receives syntax rather than type-checker facts
([Rust Reference](https://doc.rust-lang.org/reference/procedural-macros.html)); it may not pretend
to discover arbitrary async field reads through opaque helpers. The no-macro `project` form is the
normative meaning and remains the diagnostic shown by a fix-it.

### 7.2 Fetch high, block low

A boundary is a retained element. Its child is a reader/property/projection descriptor, so the
boundary is installed before the child is evaluated:

```rust,ignore
fn app(&self) -> Element<'_> {
    row().children((
        story_list(&self.selected_id),
        boundary()
            .loading(detail_skeleton())
            .failed(load_failed)
            .child(story_page(self.story)),
    ))
}
```

The fetch belongs to the model/root producer and begins as soon as its declared input publishes.
The skeleton belongs to the detail pane. `story_page` and every layout between those locations only
pass a `Reader<Story>`. Moving the producer changes when work starts; moving `loading` changes what
the user sees. Neither move forces promise types through the intervening architecture.

`Loading` means **first readiness**, not “some request exists.” Before this branch has committed
real content, a pending reader selects the fallback. After the first successful content commit,
revalidation keeps that coherent content mounted and interactive by default. A semantic replacement
that should deliberately show its skeleton again says so at the boundary:

```rust,ignore
boundary()
    .loading(detail_skeleton())
    .reload_on(&self.selected_id)
    .child(story_page(self.story))
```

This follows the useful distinction in Solid's `Loading on=...` design without confusing network
activity with presentation policy. Nested boundaries are ordinary retained nesting: use one around
the pane if the pane should reveal together, or smaller ones when comments and the article should
reveal separately.

### 7.3 UI nesting does not schedule independent work

Producer declaration precedes ready-region evaluation. Therefore two nodes driven by the same
already-ready input arm together even when their consumers are nested in the visual tree:

```rust,ignore
let story = selected_id.try_map_async(fetch_story);
let comments = selected_id.try_map_async(fetch_comments);

article().children((
    story.project(story_header),
    comments.project(comment_list),
))
```

Both requests start from `selected_id`; source code position does not serialize them. A true
dependency remains visible and sequential:

```rust,ignore
let author = story.try_map_async(|story| fetch_author(story.author_id));
```

No runtime can start work that has not been declared. A producer created *inside* a blocked
`story.project(...)` is intentionally downstream and cannot arm before that region becomes ready.
The inspector calls this a **declaration waterfall**, names the blocking edge, and suggests hoisting
when its input was already available. This is more honest than claiming tree position can never
matter. The contract is that ordinary sibling/child placement does not impose ordering once the
producer graph has been declared.

### 7.4 Pending is a question; transition is a graph fact

A write begins a candidate **presentation** cohort. The model mutation itself completes normally;
GPUI does not clone or journal every arbitrary `Signal<T>` behind `DerefMut`. Existing retained
ports/regions keep their last settled owned operands while candidate description reads current
model intent and freezes the declared owned worker inputs. The candidate publishes only when every
value required by that cohort's committed read set can land consistently. Unrelated sources and
regions continue to commit; GPUI never waits for “every async descendant.”
React's Suspense RFC arrived at the same important boundary—loading presentation is declarative,
but a transition must not be held by arbitrary deep work
([RFC 213](https://github.com/reactjs/rfcs/blob/main/text/0213-suspense-in-react-18.md)).

There is no `start_transition` API. The graph already knows which write caused which in-flight
reader. It exposes two read-only questions:

```rust,ignore
results_list()
    .opacity(if_(is_pending(&self.results), 0.65, 1.0));

story_list()
    .selected(latest(&self.selected_id)); // opt into the user's intent now
```

`is_pending(x)` means “does the next visible answer for this source/read expression still have an
unresolved causal dependency?” It is not a writable flag and not an application-global spinner.
It can be asked at an async reader, a derived reader, or at the source write that began the cohort.
`latest(input)` means “bind this existing presentation sink directly to current model intent rather
than its cohort's retained operand.” It is for input sources; it does not pretend to know the future
result of an unresolved fetch.

The default therefore cannot show a new selected id next to the old story. If product design wants
the highlight to follow the click immediately, only that sink uses `latest`. Controlled text/IME,
pointer capture, and other latency-critical writeback paths declare the same immediate/latest
policy so an async search below them never freezes typing. The inspector displays the cohort,
entangled readers, boundary, held presentation values, and every `latest` escape; invisible global
transition state is not acceptable.

This is multi-version **presentation**, not a long transaction holding `&mut` borrows and not
universal model rollback. A handler reads/writes ordinary current model state; presentation retains
the last settled property/tape operands; speculative description sees current intent; async workers
receive one owned frozen input snapshot. Multiple independent presentation cohorts may be in
flight. A newer write touching the same input supersedes its older cohort by policy, never by
completion timing. Product state that itself needs commit/revert across latency uses an explicit
persistent/COW/optimistic journal type; GPUI cannot manufacture a second arbitrary non-`Clone` `T`.

Compose's snapshot system is useful precedent for version-selected reads and atomically applying an
isolated mutable snapshot, but its own implementation explicitly does not claim serializability
([snapshot source](https://raw.githubusercontent.com/androidx/androidx/androidx-main/compose/runtime/runtime/src/commonMain/kotlin/androidx/compose/runtime/snapshots/Snapshot.kt),
[API](https://developer.android.com/reference/kotlin/androidx/compose/runtime/snapshots/MutableSnapshot)).
GPUI therefore does not market a candidate cohort as a database transaction: it validates exact
input stamps at admission and atomically publishes the particular retained cut it actually proved.

### 7.5 Request admission and cancellation are exact

Every async/CPU request carries at least:

```text
RequestStamp {
    producer: (owner, site, mount_generation),
    ticket: monotonic_per_producer,
    frozen_inputs: [(source, version)],
    policy_generation,
    candidate_epoch,
}
```

The complete input tuple freezes once from one immutable candidate description. GPUI stages the
request and pending verdict, atomically admits that private graph record (without publishing its
presentation), and only then enqueues owned work; a draft that fails admission never launches an
orphan request. Completion enters through a later ordinary
turn and is admitted only when producer generation, ticket, every input version, and policy
generation still match. This rejects out-of-order completion and the `A -> B -> A` alias that a
value-only or global-epoch check misses. Accepted value/fault plus all affected ports and regions
then publish atomically.

The portable cancellation guarantee is deliberately one sentence:

> Once work is superseded, unmounted, or revoked, its completion cannot affect presentation.

Logical cancellation (ticket revocation) is universal. Cancelling a queued driver is
executor-specific. Dropping a polled future is only as cancellation-safe as that future. A running
thread, blocking FFI call, service request, or external side effect may continue. Cooperative CPU
work opts into a token-taking `compute_cancellable`; the ordinary function receives no fake token.
The runtime may stop polling and always rejects stale delivery, but it never claims the server
rolled a write back. Saves and other effects use actions with explicit reliable/idempotent policy,
not latest-wins read producers.

GPUI can drive these sites with its private foreground/background executors, Tokio, smol, a custom
driver, a thread, or an external cache adapter. The selected driver changes bounds and physical
cancellation, not reader/boundary semantics. Only an actual cross-thread edge requires frozen
input, future/output, and domain error to be `Send + 'static`; a local resource removes `Send` but
still owns everything across `await`. Here `'static` means owned, not immortal.

### 7.6 Failures travel with the read

There is one failure path, not a resource `.error` flag competing with boundaries. A fallible
producer's `E` is checked at creation and retained exactly. It is erased only when several failure
types meet at a heterogeneous subtree boundary—the same justified dynamic boundary as a plugin or
protocol—and remains downcastable/inspectable there. The internal record separates:

| Outcome | Meaning | Presentation rule |
|---|---|---|
| not yet ready | first request has no accepted value | nearest `loading` fallback |
| refreshing | newer request, previous accepted value exists | keep the coherent previous subtree; `is_pending` is true |
| domain `E` | expected operation failure | nearest matching `failed` policy; retryable |
| superseded/revoked | a newer ticket or dead owner won | no error UI; delivery is discarded |
| worker/executor fault | panic, driver shutdown, admission failure | framework `Fault`; never forged into `E` |
| invariant/plugin panic | programmer or isolation failure | discard draft, poison the narrowest unsafe pocket, then recover/escalate |

An initial domain failure replaces the loading fallback with the boundary's failure content. A
revalidation failure never publishes half of the candidate cohort and never silently overwrites
the last accepted value. By default it also does not publish the candidate input's ordinary
presentation ports: the old selection/content remain visually coherent while the boundary presents
the failed intent and retry. The model already owns that intent—there is no implicit rollback;
`latest(input)` or an explicit commit-on-fault policy may deliberately present it.
Boundary policy chooses either replace-with-error or keep-stale plus an explicit error adornment;
the default application supervisor reports any unhandled failure, so
“keep stale” cannot become “swallow error.” A dependency change or successful retry heals a domain
boundary automatically. A programmer-panic pocket is rebuilt only through its declared reset,
because blindly rerunning the same panic is a hot loop.

The boundary's public domain handler remains statically typed—`failed(load_failed)` infers a
`fn(&LoadError, Retry) -> Element<'_>`. Internally a heterogeneous boundary erases that handler only
after recording `TypeId`; mismatched errors continue upward, and application code never sees
`Any`. The normalized inspector/supervisor record includes concrete type/source, producer and input
stamps, cohort, attempt/retry history, and cancellation disposition. Framework faults use a
separate discriminator/handler and never downcast to `E`; raw panic payloads are never retained.

This deliberately improves on coroutine-backed model streams where an uncaught child failure can
terminate the producing job while a `StateFlow` merely keeps its last value. Molecule is a useful
example of that lifecycle/fault split
([runtime](https://raw.githubusercontent.com/cashapp/molecule/trunk/molecule-runtime/src/commonMain/kotlin/app/cash/molecule/molecule.kt),
[StateFlow contract](https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.flow/-state-flow/)).
One failed GPUI reader settles its own cohort and boundary; it cannot cancel unrelated siblings.

### 7.7 Pending is not a Rust panic

Solid can throw an internal `NotReadyError` because JavaScript exceptions are its available
non-local control mechanism. GPUI does not copy that implementation. Rust's `catch_unwind` is not a
general `try/catch`: it catches only unwinding panics, carries `UnwindSafe` constraints, cannot
recover `panic=abort`, has unspecified foreign-unwind cases, and even dropping a captured payload
may panic ([standard library](https://doc.rust-lang.org/std/panic/fn.catch_unwind.html)). Salsa's
cancellation panic is instructive precisely because it is a narrow private protocol that catches
its own marker and resumes every other panic; it is not a UI availability mechanism
([Salsa source](https://docs.rs/salsa/latest/src/salsa/cancelled.rs.html)).

Readiness therefore uses the typed evaluator verdict in §7.1 and works identically under
`panic=unwind` and `panic=abort`. `catch_unwind` is reserved for audited true-fault containment
around disposable immutable drafts and fully owned worker polls. An unknown panic discards the
draft; an ordinary `&mut Model` handler cannot be magically rolled back, so its owner is poisoned
or process-isolated according to policy. FFI and aborting plugins require a process boundary if
survival is a requirement.

An `async fn view(...) -> Element<'_>` is also rejected. It would hold or recreate frame borrows
across `await`, color every caller with a future, make tree position schedule work, and conflict
with §2's one-frame `Element<'f>`. Views remain synchronous descriptions of retained reader edges.
Async functions remain ordinary owned producers.

### 7.8 Writes are actions, not reads

Dependency-driven async readers are repeatable questions and normally use latest-input-wins.
User-triggered mutations are effects and keep their ordinary `Result` plus explicit queue,
idempotency, optimistic, and retry policy. A save is still a method:

```rust,ignore
impl Editor {
    fn save(&mut self) {
        self.document.send(Document::save);
    }
}

button("Save").on_click(Editor::save)
```

The model stores durable product state when another control/window needs it. A tiny operation owned
by one mounted control may use the local adapter:

```rust,ignore
button("Save")
    .action(Editor::persist.with(&self.document.snapshot))
    .queue(Queue::Reliable)
    .pending("Saving…")
    .then(Editor::saved)
    .catch(Editor::save_failed)
```

The invocation cell lives at the button's mount identity. Unmount always revokes delivery; it does
not promise the external save was undone. `.then`/`.catch` are typed completion routes, not promise
transforms, and queue policy is explicit because cancelling a query and cancelling a mutation are
not equivalent. Optimistic writes are tagged candidate deltas; success reconciles them with the
canonical reader, and failure applies a typed inverse or an explicit reset/rebase policy.

`Remote<T>` remains the escape hatch for progress streams, services, processes, foreign runtimes,
and work whose result is genuinely an effect rather than a derived value. It carries owned
arguments to a later FIFO turn and never permits reentrant mutation. The dividing line is semantic:
a repeatable question belongs in the reader graph; a command belongs in an action/method; a
multi-message protocol remains a protocol.

---

## 8 · Fallibility is a value, and absence is normal

Author-triggerable absence never panics. A deleted row, closed popup, stale target, cancelled
operation, lost device, rejected drop, or missing optional route is ordinary UI state.

```rust,ignore
fn open(&mut self, slot: Slot<Item>) -> Option<Opened> {
    let item = self.items.get(slot)?;
    Some(Opened(item.id))
}

fn rename(&mut self, slot: Slot<Item>, name: String) -> Result<(), RenameError> {
    let item = self.items.get_mut(slot).ok_or(RenameError::Gone)?;
    validate_name(&name)?;
    item.name = name;
    Ok(())
}
```

Delivery revalidates site context before invoking the method. `Option` from an input handler means
“no output” and propagates when propagation exists. A handler/action `Result` routes intact or is
split explicitly with `.then/.catch`; a fallible derived reader follows §7.6's single boundary
path unless its creator deliberately keeps `Result<T, E>` as the reader's ordinary value.
Best-effort target operations record a typed miss in the inspector; checked variants return a
standard future:

```rust,ignore
self.editor.focus();

async fn focus_editor(editor: Remote<Editor>, target: Target<TextInput>) {
    if let Err(miss) = target.focus_checked().await {
        editor.send(Editor::focus_failed.with(miss));
    }
}
```

Framework code contains no `unwrap`, indexing, or `expect` over author-controlled identity.
Internal invariant failure poisons the narrowest entity/surface in release builds and additionally
asserts in debug builds. Discarding a description/worker draft is rollback because the draft was
never published; catching a panic around an arbitrary `&mut T` handler is not rollback and is
therefore forbidden unless that handler uses an explicit transactional/journaled state type.

---

## 9 · Entity is a typed facade, not a generic runtime

`Entity<T>` remains useful for genuinely shared, independently scheduled ownership. It must not
become the default wrapper for every view, nor should it force a Bevy-style giant dynamically
linked engine crate.

The representation is split deliberately:

```rust,ignore
#[repr(transparent)]
pub struct Entity<T: 'static> {
    raw: RawEntity, // non-generic key + refcount
    marker: PhantomData<fn() -> T>,
}
```

`Entity<T>`, `Remote<T>`, and typed routes are tiny inline proof adapters. Allocation, generation
checks, scheduling, queues, dependency storage, drop, and fault isolation live in non-generic
`EntityCore` code. The concrete type is registered once with a compact method/drop/describe table.
The hot kernel does not monomorphize per application type.

This follows the productive pattern from typed dataflow systems: a `Slot<T>` or port proves value
type and access direction, while the graph store erases only after that proof. Plugin and dynamic
library boundaries use `AnyEntity` plus a versioned scene/input/accessibility protocol; Rust
generic layout is never treated as a stable ABI.

Mutation is a queued ordinary method call:

```rust,ignore
self.project.send(Project::rename.with(new_name));
```

`send` never invokes user code synchronously. A read after `send` sees the current committed epoch.
`with` has one meaning across GPUI: bind trailing owned inputs to a function item. A value is
constant; a signal/reader is sampled into an owned value at dispatch.

### 9.1 Weak ownership and cyclic construction are real public contracts

The audit's repeated `weak_self` fields are evidence for a missing primitive, not eight components
that should each invent a completion ceremony. GPUI exposes a small generational `WeakEntity<T>`:

```rust,ignore
let editor = Entity::new_cyclic(|me: WeakEntity<Editor>| Editor::new(me, document));
let weak = editor.downgrade();

weak.inspect(|editor| editor.mode());
weak.send(Editor::refresh); // Delivery::Closed after drop
```

The weak key exists before `T`, but no strong entity is visible until the constructor returns and
the slot publishes. A panic or failed construction leaves every copy permanently dead; no callback
can observe a partial `T`. `inspect`/`send` generation-check and return `Option`/
`Delivery::Closed`; there is no public strong `upgrade`, mutable access, `Deref`, or convention of
capturing the weak handle through `await`. Named `Output<E>` remains preferable for child-to-parent
flow, a `Reader` for parent facts, and a mounted producer for async completion. `WeakEntity<T>` is
the audited last resort for genuine cycles and optional forward queries—cases where lifetime,
rather than event meaning, is the point.

### 9.2 One injected item catalog replaces all workspace registries

The current [`ProjectItemRegistry`, `SerializableItemRegistry`, and
`FollowableViewRegistry`](https://github.com/zed-industries/zed/blob/main/crates/workspace/src/workspace.rs#L787-L1061) split
one protocol across global `TypeId` maps, string maps, `Window`/`App` contexts, pane borrows, and
factories returning GPUI tasks. They are the largest remaining workspace blocker and are replaced
together, not wrapped.

`ItemCatalog` is an explicit application/host-owned resource passed to `Workspace`; tests and
embedded hosts construct their own. Registration is typed, then erased exactly once:

```rust,ignore
catalog.register::<EditorItem>(ItemSpec {
    kind: ItemKind::new("zed.editor", Version::new(3)),
    open: EditorItem::open,       // fn(OwnedOpen) -> impl Future<Output = Result<EditorItem, E>>
    save: EditorItem::save,       // fn(&EditorItem) -> Result<OwnedState, E>
    restore: EditorItem::restore, // fn(OwnedRestore) -> impl Future<Output = Result<EditorItem, E>>
    migrate: EditorItem::migrate,
    follow: Some(EditorItem::follow_protocol),
});
```

The generic registration checks the concrete item, locator, saved-state, error, and item-protocol
implementations before storing a compact factory/vtable. `TypeId` may accelerate an in-process
reverse lookup but is never a persisted or wire identity. Dynamic plugins cross the same boundary
with a versioned manifest and `AnyEntity` that proves the `Item` protocol; erasure is confined to
the catalog, not spread through panes. The private object-safe adapter may box a future here because
heterogeneous item kinds genuinely meet here; public factories remain statically typed. Separately
loaded plugins use a versioned C/IPC protocol and host proxy rather than exporting Rust trait
objects or futures across an unstable ABI. The private adapter is also the stable-Rust answer to
[`dyn` compatibility](https://doc.rust-lang.org/reference/items/traits.html#dyn-compatibility):
generic registration proves the item type first; only the catalog stores an object-safe erased
factory.

Open and restore requests own every argument needed across `await`: project/service handles,
workspace session id, item locator/state bytes, target pane slot, and cancellation policy. They
never retain `&Pane`, `&Workspace`, `&mut Window`, or `&mut App`. Their ordinary future runs on a
real runtime and its completion becomes the §7.0 memo/action wake. Removing a registration rejects
new opens; already-open items hold a catalog lease until they close. A catalog revision is a
reader only for UI that truly lists capabilities, so installing a plugin invalidates menus or open
dialogs precisely instead of broadcasting construction globally.

Restore first allocates a generational `Slot<ItemPlacement>` containing the persisted instance and
a `Reader<AnyItem>`, then starts every known placement concurrently. The slot, catalog generation,
record revision, and mount generation enter the request stamp, so closing/moving/reusing a tab
cannot accept its old factory completion. Each tab puts loading/fault UI at its own content
boundary. This is §7's fetch-high/block-low law applied to the workspace, not a sequential startup
loop hidden in pane construction.

Unknown/disabled kinds, unsupported schemas, corrupt records, and temporarily unavailable targets
are typed item-load errors, not framework faults. A recovery item retains the original bytes and
offers retry, enable/migrate, export, or remove; failed restore never silently deletes a tab.
Worker/plugin panic, executor loss, and ABI violation remain §7.6 framework `Fault`s. Catalog kind
collisions are deterministic errors, and a plugin cannot unload while a descriptor, item, or
restore future holds its lease.

### 9.3 Linking decision

Bevy's [`bevy_dylib`](https://github.com/bevyengine/bevy/tree/main/crates/bevy_dylib)
intentionally forces the engine into one `dylib` to speed relinking. GPUI does not make that
architecture a requirement. The concrete `Element`, non-generic entity kernel, and protocol
boundaries are chosen so ordinary incremental compilation and normal crate-level linking remain
effective.

An optional development-only dynamic kernel may be measured later, but the public API cannot rely
on it and release binaries never require it. CI tracks generic instantiation count, incremental
rebuild time after an application-only edit, clean link time, artifact size, and exported symbol
count. A change that makes `Entity<Foo>` pull a new copy of scheduler/renderer code fails the gate.

---

## 10 · How far to push the type system

Three reference points give a useful rule:

1. [`cozy-chess`](https://docs.rs/cozy-chess/latest/cozy_chess/) uses focused newtypes to prevent
   square/piece/category mistakes while retaining competitive bitboard performance. Adopt this.
2. [`pipeline-graph`](https://docs.rs/pipeline-graph/latest/pipeline_graph/) uses typed `Slot<T>`
   handles and declared input/output capabilities, validates graph invariants once, then erases
   the node store. Adopt this shape for signals, routes, lists, and entities.
3. [`type-system-chess`](https://github.com/Dragon-Hatcher/type-system-chess) demonstrates the
   opposite extreme: legal chess in traits and ZSTs, but roughly 5,000 Rust lines, enormous trait
   resolution, poor diagnostics, and very slow compilation. Treat this as a ceiling warning, not
   a UI API aspiration.

The resulting policy is:

> Use types as small proofs at boundaries; erase representation after the proof; never encode the
> changing UI tree or arbitrary business control flow in Rust's trait solver.

Use newtypes, sealed traits, function-item receiver inference, GATs for borrowed port views, and
`#[diagnostic::on_unimplemented]` where they make an invalid state unrepresentable locally. Do not
use recursive tuple types, const-generic style bitsets, type-level lists of children, negative
trait tricks, or hundreds of arity/specialization impls to make a screenshot type-check.

---

## 11 · Components, identity, and collections

A component is a Rust struct implementing `View`, stored as a plain field by default. Inputs are
constructor values/shared signals; required outputs are constructor routes; optional outputs are
named configuration. Controlled and uncontrolled widgets use named constructors:

```rust,ignore
Typeahead::new(Workspace::picked)
Typeahead::bound(self.query.share(), Workspace::picked)
```

Identity has three non-overlapping types:

- `Slot<T>`: durable identity inside a `List<T>`;
- `Target<K>`: a typed addressable mounted part such as a text input;
- retained node identity: internal identity of an embedding site.

There is no per-element string id, derived id enum, or universal key. In particular there is no
hand-rolled `PaneId`/`GroupId` newtype paired with a `HashMap<PaneId, Pane>`: that parallel
id-plus-map is precisely what `Slot<T>` deletes. A workspace of panes, groups, and panels is nested
`List<T>`s, and every cross-reference — last-active pane, the group a tab lives in — is a `Copy`
`Slot<T>` into the relevant list, generation-checked and never an index. `Target<K>` resolves on
every use and cannot dangle. Rows get `Slot<T>` from validated event context. `Take<T>` removes on
delivery and restores on drop unless inserted, so drag/move code cannot lose the item.

Arrangements (`filtered`, `sorted`, grouped, tree projections) live on list references. Indexed
sealed operators receive deltas; arbitrary closures rerun over the visible arrangement and have
their cost attributed. Virtualization preserves slots, edit sessions, focus/accessibility
reasons, anchor extents, and measurement generations.

### 11.1 Runtime identity, session identity, and durable identity do not alias

`EntityId`, `Slot<T>`, retained-node keys, and `Target<K>` are generational process-local
capabilities. Serializing one would turn an allocator accident into a protocol. A persisted item
instead has three explicit layers:

```text
SavedItem {
    kind: ItemKind + protocol version,
    instance: ItemInstanceId,         // durable identity of this tab/view instance
    locator: versioned item-owned bytes,
    state: versioned item-owned bytes,
}
```

The `ItemSpec<T>` in §9.2 owns typed `Locator` and `SavedState` representations plus migration.
A locator explains how to reacquire the domain object; state explains how to restore this view of
it. There is intentionally no universal “domain key”: an editor locator may contain project,
worktree/path or remote document identity, excerpt-set identity, and mode; a terminal may contain a
workspace/session or relaunch descriptor; an ephemeral item can declare that it is not restorable.
`ItemInstanceId` preserves tab/history relationships while restoring but is mapped to a fresh
`EntityId` on success.

The same durable `ItemKind + locator` vocabulary crosses collaboration. Peer-local entity ids and
pane slots never do. A session alias table resolves a remote item reference to the current local
entity after authorization and restore; missing, migrated, and unauthorized locators are typed
protocol outcomes. This one separation closes persistence, workspace restore, leader/follower
presence, and stale-handle bugs without pretending they share one lifetime.

### 11.2 Focus is a committed claim, never a render-time reclaim flag

The common `reclaim_focus`/`focus_pending` pattern—even small non-Zed applications contain it—is
not harmless view scratch. Mutating the flag and calling focus during description makes tree shape,
input routing, and rerun count affect behavior. The owner instead holds a typed target and queues a
one-shot focus intent from the event that created the need:

```rust,ignore
fn closed_palette(&mut self, effects: &mut Effects<Self>) {
    effects.after_commit(Focus::claim(self.editor_target));
}

fn view(&self) -> Element<'_> {
    editor().target(self.editor_target).focus_default()
}
```

Description only binds a `Target<K>` and may declare a default for a newly committed scope. An
explicit claim is applied after the target's generation commits; if temporarily unbound it parks
for its declared generation/deadline, then returns a typed miss or follows an explicit fallback.
Claims are ordered and coalesced by scope, so duplicate description cannot focus twice and an old
claim cannot steal focus after navigation. `LayoutCx`, paint, and arbitrary `view(&self)` code have
no focus capability. This turns the three observed Hummingbird mutations and Zed's stored
`FocusHandle` restoration into one deterministic protocol rather than an exception to pure views.

---

## 12 · One application surface

There is no `gpui::run` free function, `View::run`, `Ui::run`, `desktop()`, event-loop-on-drop, or
hidden App spec. But "one owner" must not mean "four lines of ceremony for a one-window program."
The common case is one terse associated function on that owner:

```rust,ignore
fn main() {
    Application::run(HelloWorld { text: "World".into() });
}
```

`Application::run(root)` is exactly `Application::new()` + `open(Window::document(root))` +
`run()`: one document window with default chrome, then the platform loop. It is not the banned
`gpui::run` — it is a method on the typed owner, it opens one *explicit, defaulted* window (not a
hidden one), it holds no ambient App spec, and nothing happens on `Drop`. It accepts
`impl Into<Window<V>>`, so a bare `V: View` uses defaults and a configured window stays one line:

```rust,ignore
fn main() {
    Application::run(Window::document(TextGallery).title("Text").size(650, 900).centered());
}
```

The instant a program needs a second window, the typed handle, or app-level policy, it drops to
the builder — same owner, no rewrite:

```rust,ignore
fn main() {
    let mut app = Application::new();
    let studio: Win<Studio> = app.open(
        Window::document(Studio::default())
            .title("Studio")
            .size(960, 640)
            .centered(),
    );
    let inspector: Win<Inspector> = app.open(
        Window::utility(Inspector::default())
            .title("Inspector")
            .start_hidden(),
    );
    app.run();
}
```

`Application::open(&mut self, Window<V>) -> Win<V>` returns the typed window it created. Ignoring
the handle is fine in a small binary; keeping it makes activation, close, queries, and tests
compile-time typed. `AnyWin` exists only for genuinely heterogeneous storage and plugin protocols.
Titles are presentation, never identity. An API that asks for `"Audience"` to find a window is a
bug.

`Win<V>` is a generational owned route, not a borrow of `Application`. It exposes committed
properties (`active`, `bounds`, `scale`, `display`, `appearance`) as readers, and verbs such as
`activate`, `close`, `move_to`, and `request_attention`. A stale handle returns `Closed`, never
dangles. Window event handlers may receive the current `Win<V>` as validated site context.

The application carries providers, renderer/executor policy, menus, platform attachment, and fail
policy. A window carries only window configuration. Optional desktop integrations are typed
capabilities over `Application`; they do not invent a `desktop()` root.

Tests use the same owner, and the one-window case is a single call. `Win::demo(root) -> Win<V>`
constructs a demo `Application`, opens one document window, and returns the typed handle that owns
it — no `let mut app`, no separate `open`:

```rust,ignore
#[test]
fn picks_a_suggestion() {
    let search = Win::demo(SearchPage::default());

    search.type_text(search.root().input, "ban");
    search.click(search.root().find);
    assert_eq!(search.root().hits.len(), 3);
}
```

Multi-window tests still take the owner explicitly with `Application::demo()` and `open` each
window (the presenter test does this for two windows sharing one `Entity`). Both spellings drive
the same turn engine; `Win::demo` is only the single-window shorthand.

`demo` supplies a deterministic clock/work source, software renderer option, typed roots/windows,
and explicit driving. `open` returns only after the first committed presentation. Every demo input
method is a **turn barrier**: it validates and dispatches the input, drains ready work, settles
ports, commits layout/paint/accessibility, and then returns. Assertions therefore observe the
result without public `settle`, `run_until_idle`, `snapshot().window(0).scene()`, or arbitrary
sleeps. This follows the useful behavior already proven by current GPUI's `TestApp`, which
automatically flushes effects after updates.

The typed `Win<V>` exposes semantic test queries directly: `contains_text`, `role`, `focused`,
`bounds(Target<K>)`, `filter_count`, `damage`, and root reads. `scene()` remains an expert renderer
diagnostic, not the price of asserting ordinary UI. A virtual-clock `advance(duration)` is also a
turn barrier. Truly external/nondeterministic work is awaited by a typed event or
`app.until(deadline, predicate)`, which reports pending work on timeout; a vague `settle()` cannot
make an OS thread deterministic.

Calling `.run()` on a demo opens the same plan interactively for an example gallery. Embedding
uses `app.attach(host_loop)?` or the lower-level `app.poll(deadline)` contract; both drive the same
turn engine and neither creates a second application or scheduler.

---

## 13 · Turns and soundness

Every dispatched input, batch of stamped completions, remote message, or test action begins one
turn. Async adds a
private **candidate description/graph head** between ordinary model mutation and retained
presentation; it does not add reentrancy or a second copy of every model value:

```text
validate event context
  -> run one handler to completion
  -> drain returned outputs and queued entity sends FIFO
  -> drain StampedCompletion records; validate generation + request stamps
  -> mark their ordinary memo nodes dirty; apply admitted values/faults
  -> speculatively describe affected regions against one immutable candidate
  -> seal producer sites + pending/fault verdicts; only now enqueue owned work
  -> settle each ready cohort / retain prior regions / select first-load fallbacks
  -> publish every eligible structure/property cohort atomically
  -> layout / hit / accessibility / paint / composite one epoch
```

User code cannot settle recursively. A route may enqueue another route but cannot execute it
inside the mutation that produced it. After the handler finishes, one description/projection
invocation sees one immutable borrow of current model intent plus one internally consistent set of
reader versions; it never observes a worker half-publication. Dispatch/hit testing sees one
committed presentation epoch. Existing reader/property ports retain their settled owned operands
while a cohort waits; `latest` is the explicit current-intent port on already-presented UI. This is
not a general rollback transaction over arbitrary `&mut T`.

Speculative description is necessary, not optional cleverness. A write may select a new branch
whose producer did not exist in the old tree; GPUI must describe that candidate branch to discover
and arm its work without first showing an inconsistent half-tree. The borrowed frame still does
not survive: its draft is diffed/promoted into a private **owned candidate tape** before the arena
drops. A later completion re-evaluates the affected candidate region. Only an eligible coherent cut
becomes presentation. First-load `Loading` fallbacks and unrelated ready regions may publish while
the blocked candidate remains private; an already-revealed region retains its prior owned tape.
Thus GPUI never holds `Element<'f>` or an application borrow across `await`.

A panic during immutable description/projection discards that unpublished draft and records a
fault at the narrowest boundary. A panic during an arbitrary mutable handler has no general
rollback: queued effects are suppressed and its owner is poisoned/dropped unless the state uses an
explicit transactional representation. A worker panic owns only frozen input and becomes a
framework fault for its request stamp. None of these cases can publish half a turn.

`Entity<T>: Deref` is permitted only if the implementation proves: UI-thread-only handle, stable
allocation, immutable committed epoch during the borrow, no public settle/mutation while it is
live, and no borrow in `Remote`. Miri and permutation tests are stabilization gates. If the proof
fails, the spelling becomes `entity.inspect(...)` before release; the design does not paper over a
soundness hole for convenience.

---

## 14 · Performance and inspection contract

The no-macro path is not a slow teaching API:

- a borrowed signal property installs the exact same zero-allocation port as `#[reactive]`;
- an explicit source tuple `project` installs the exact same retained region as macro lowering;
- a `List` delta invokes affected slots, not the whole collection;
- `Element<'f>` construction is a **borrowed** append into the per-turn arena — a pointer bump, no
  clone, no intern, no refcount, no virtual-tree allocation;
- the commit diff promotes only changed operands to owned storage; unchanged operands and
  signal-backed ports allocate nothing;
- static layout recipes are constants and disappear after lowering;
- routes are capture-free function items plus compact bound-input records;
- presentation-rate properties never route through owner handlers.

Ordinary committed reads may rerun an owner; that is the only intentional floor price. Authors
can remove it one sink at a time with a reference, one structural region at a time with `project`,
or in bulk with `#[reactive]`. All three converge on the same kernel representation.

### 14.1 The secondary tier matches and exceeds zgui by construction

The "secondary tier" is the no-macro hot path: borrowed-frame description, direct signal ports,
`project` regions, and `List` deltas. Its competitive claim is not a benchmark hope; it falls out
of the data structures, so it is stated as a theorem with a construction proof. The baselines are
the two honest extremes: **Dear ImGui** (immediate mode — rebuild a borrowed draw list every
frame, no retained widget state) and **[zgui](https://github.com/zortax/zgui)** (retained mode —
persistent document, computed styles, Taffy box tree, shaped paragraphs, paint chunks, hit-test
index, damage tracking).

GPUI is already the hybrid between them: Zed "is rendered like a videogame"
([zed.dev/blog/videogame](https://zed.dev/blog/videogame)) and rebuilds its element tree from
current state each frame (immediate-mode *authoring*), while entity state, persistent Taffy nodes,
and the glyph atlas are retained caches — "text normally doesn't change much across frames," so the
rasterized glyphs "are cached into an atlas, a long-lived texture stored on the GPU" (ibid.). The
borrowed frame is the exact articulation of that hybrid, and it lets the secondary tier dominate
*both* baselines on their own terms:

> **Claim.** Per description turn, the secondary tier's authoring cost is in ImGui's cost class
> (arena appends, no per-frame heap allocation) with strictly-less-or-equal copying, and its
> *steady-state* cost is in zgui's cost class (O(changed), damage-tracked, zero clean-tree
> traversal) — and it beats each baseline exactly where that baseline is weakest.

**Proof by construction.**

1. *Authoring ≈ ImGui, by the arena.* An `Element<'f>` append is a pointer bump into the per-turn
   arena carrying a borrowed operand — the same operation as an `ImDrawList` append. ImGui
   re-copies every string and vertex each frame; the borrowed frame copies **nothing** during
   description (it borrows `self` and scalars) and promotes only the commit-diff delta. So
   per-frame allocation is `≤` ImGui's and is exactly `0` on an unchanged subtree. *We match ImGui
   on a fully-dirty frame and beat it on every partial one.*

2. *Steady state ≈ zgui, by the diff and the ports.* Where ImGui always re-emits the whole command
   list, the retained tape diffs the draft and touches only changed slots — zgui's damage model.
   But the hot sinks never enter description at all: a signal publication patches its property slab
   through a direct port with **zero turns and zero Rust** (the presentation-resident input loop of
   [`performance.md` §2](performance.md)), and a `List` edit patches only its affected slots. So on
   a typical frame the secondary tier does `O(changed sinks)` work, not `O(tree)`. *We match zgui's
   retained locality and beat it because a changed leaf need not even re-describe its parent.*

3. *The floor is a construction fact, not a tuning result.* The bound is `max(ImGui_authoring,
   zgui_steady_state)` with the constant factors of a `!Send + !Sync` local graph (no atomics; see
   `performance.md` §2), two-word `Copy` keys, and a sealed `Property<T>` installer that avoids a
   universal value enum or box. None of these depend on workload shape; they are properties of the
   arena, the diff, and the port slab.

The one price the secondary tier does *not* escape is an ordinary committed read forcing an owner
rerun (a full arena rebuild for that owner) — but that rebuild is still ImGui-cheap, and the diff
still promotes only the delta. An author removes even that with a reference (`&self.count`), a
`project`, or `#[reactive]`. What GPUI keeps that ImGui discards, and keeps *more cheaply* than
zgui, is the retained identity underneath: hit-testing, accessibility, focus, animation tracks, and
undo all read the same committed epoch the diff produced. The gate that holds this honest is a
ported apples-to-apples workload (`performance.md` §4) measuring per-frame allocations, nodes
visited, and turns against both baselines; a secondary-tier frame that allocates on an unchanged
subtree, or traverses a clean tree, is a construction bug, not a regression to tune away.

Every epoch exposes an inspectable `UiSnapshot`: retained logical tree, layout, property slabs,
typed routes, action generations, projection dependencies, list deltas, accessibility projection,
scene packets, damage, queues, producer/request stamps, presentation cohorts, pending/fault
provenance, and work attribution. The inspector answers which source dirtied which sink, which
handler consumed/propagated, why a target missed, why a result was stale, which boundary retains a
cohort, whether a waterfall is declared or structural, and how much time/allocation each owner,
region, layout, producer, and surface consumed.

Tests use `Application::demo`, the real dispatcher, a virtual clock, and the same targets/routes as
production. Semantic role/text/property/layout assertions are the primary tier; retained-scene
packet goldens are the renderer/protocol tier; the fixed reference CPU renderer is the pixel tier.
Ordinary component tests never traverse the scene. Full recomputation and full damage remain
correctness oracles.

---

## 15 · Current Zed/GPUI migration audit

This surface was checked against current Zed source at
[`fd82517`](https://github.com/zed-industries/zed/commit/fd82517a115d97a07835b52f0512b22b38e38ccf)
(2026-08-21), not only toy counters. A mechanical scan of `gpui`, `ui`, `editor`, `workspace`,
`picker`, `menu`, `project_panel`, `assistant`, `terminal`, and `file_finder` found the following
pressure points:

| Current spelling | Approximate sites | What 07 must replace |
|---|---:|---|
| `into_any_element` | 775 | unlike branches and heterogeneous children |
| `.when` / `.when_some` | 333 / 225 | conditional style, child, handler, and layout mutation |
| `cx.listener` | 333 | receiver recovery for event closures |
| `.on_action` | 253 | local handlers plus genuine named commands |
| `cx.spawn` / `window.spawn` | 375 / 21 | owned async work and return routing |
| `cx.subscribe` / `cx.observe` | 113 / 25 | model dataflow and lifecycle outputs |
| `cx.notify` | 572 | manual dirty publication |
| `cx.open_window` | 100 | window construction plus handle recovery |
| `AnyWindowHandle` / `WindowHandle<T>` | 121 / 81 | heterogeneous and typed window identity |

Counts are directional rather than a compatibility promise, but they prevent the design from
optimizing only its preferred examples.

The audit also read the places where a count cannot explain the constraint:

| Current source shape | Constraint carried into 07 |
|---|---|
| [`editor/src/element.rs`](https://github.com/zed-industries/zed/blob/fd82517a115d97a07835b52f0512b22b38e38ccf/crates/editor/src/element.rs), a roughly 12,000-line custom `Element` | keep a first-class, phase-separated retained primitive; styled boxes are not an editor renderer |
| `EditorElement`'s 40+ layout/prepaint updates, `Entity<DisplayMap>` plus async `Entity<WrapMap>`, excerpted `MultiBuffer`, and nested minimap editor | name sealed describe-time compute and an N-viewport async `DisplayPipeline`; do not flatten the editor into a pure single-buffer projection |
| [`workspace/src/item.rs`](https://github.com/zed-industries/zed/blob/fd82517a115d97a07835b52f0512b22b38e38ccf/crates/workspace/src/item.rs), whose `Item` protocol includes rendering, navigation, serialization, focus, telemetry, and lifecycle | preserve explicit versioned protocols for heterogeneous product objects instead of pretending one generic tree type proves them |
| three global project/serialization/follow registries plus pane/workspace weak cycles | replace them with one injected versioned catalog, durable item-owned identity, mounted outputs, and one narrow weak-entity primitive |
| workspace follower/leader state and ordered async update channel | treat presence as a supervised distributed protocol with reliable and coalesced lanes, not a view observation |
| [`workspace/src/notifications.rs`](https://github.com/zed-industries/zed/blob/fd82517a115d97a07835b52f0512b22b38e38ccf/crates/workspace/src/notifications.rs), which stores `AnyView` and owned render factories | admit owned dynamic factories at an actual dynamic-lifetime boundary; remove erasure from ordinary branches, not from plugins/product registries |
| [`workspace/src/pane.rs`](https://github.com/zed-industries/zed/blob/fd82517a115d97a07835b52f0512b22b38e38ccf/crates/workspace/src/pane.rs), combining commands, focus, drag, history, items, and asynchronous close/save flows | typed commands, targets, protocols, and standard futures must compose; no single signal abstraction replaces this coordination |
| [`gpui/src/app/test_app.rs`](https://github.com/zed-industries/zed/blob/fd82517a115d97a07835b52f0512b22b38e38ccf/crates/gpui/src/app/test_app.rs), whose new `TestApp` already flushes effects after each update | make the barrier universal and hide it behind every demo driver operation rather than exposing `settle` |
| [`gpui/src/view.rs`](https://github.com/zed-industries/zed/blob/fd82517a115d97a07835b52f0512b22b38e38ccf/crates/gpui/src/view.rs) and the typed/untyped window handles in current GPUI | retain type erasure only for heterogeneous storage and preserve typed identity all the way through window and root APIs |

### 15.1 Common Zed shapes

| Real shape | New representation | Remaining roughness |
|---|---|---|
| `Empty`/modal/editor branches returning `AnyElement` | all finish as one `Element<'f>` sharing the frame brand; `Option<Element<'f>>` is a child | none beyond diff-time promotion of the changed delta |
| conditional `.when` styles | direct live property, or `let x = if condition { x.foo() } else { x }` | a long chain may need one rebinding; no builder closure is added to hide that |
| `.when_some(value, |x, v| ...)` | ordinary `if let Some(v) = value { ... }`; optional property setters accept `Option<T>` where “unset” has real meaning | setters cannot treat `None` ambiguously as both clear and inherit; those are distinct enums |
| `cx.listener(Self::method)` | bare `Self::method`, optionally `.with(inputs)` | captures that are not inputs become a named method or an owned route value |
| keymaps, menus, command palette, extensions | typed `Command<A>` plus a method receiver | a stable serialized command id remains intentionally registry-like |
| `cx.notify()` | a successful `&mut self` handler turn dirties its owner; `Signal`/`List` publish exact deltas | mutating interior state outside the owner must publish through its actual source |
| model observe/subscribe | `Signal`/`List` for values; `entity.on_change(M)` for any-change; typed `Emitter` + `entity.on(M)` for events (§6.4) | one typed wiring line, kernel-managed lifetime, no stored `Subscription`/weak handle/`()` bus; a true effect bus cannot be inferred |
| stored GPUI `Task` fields | dependency-driven results become mounted `Reader<T>` producers; commands use methods/actions; streams keep a channel/service | physical cancellation still differs, but request-stamp admission makes stale delivery impossible |
| `AnyView` workspace items/panels/modals | `AnyEntity` implementing a versioned `Item`/`Panel`/`Modal` protocol | true runtime heterogeneity necessarily erases the concrete type and reports protocol mismatch at mount |
| boxed render callbacks for tabs, blocks, notifications | function items or owned `Fn(...) -> Element`; dynamic extension callbacks cross the protocol boundary | capturing callbacks still allocate when their capture truly has dynamic lifetime |
| globals/settings/theme | constructor-injected readers, application resources, and inherited semantic tokens | an arbitrary service locator in view code is deliberately unavailable |
| focus/scroll/test ids | typed `Target<K>` | dynamic collections still need `Slot<T>` plus a target relative to that slot |
| window/app operations threaded through `cx` | validated handler parameters such as `Win<V>`, `Clipboard`, `FileDialogs`, `Menus`, and `Remote<T>` | platform capability absence is a typed runtime result, not a compile-time fact |
| deferred focus/layout/paint work | `Target` claims and `AfterCommit<M>` routes | reading layout and mutating structure in the same epoch is rejected to avoid feedback/reentrancy |

### 15.2 The editor is not an escape hatch — it is the frame at full strength

Zed's editor, uniform list, custom text blocks, drag geometry, and GPU surfaces cannot be reduced
to styled `div`s without losing their performance model. An earlier draft admitted this as a
*separate* `Primitive<M>` trait — a second API alongside `Element`. That separateness was itself
the leak the concrete-`Element` decision created: once description could not carry a borrow, the
only way to submit a borrowed glyph run without cloning it was to leave the `Element` world
entirely. The borrowed frame removes the reason for a second world. A custom editor is the **same
`Element<'f>`**, differing only in that it supplies its own phase closures instead of the default
box ones:

```rust,ignore
editor_surface(&self.display_map)
    .layout(|cx: LayoutCx<'_>| Editor::layout(cx, &self.viewport))
    .geometry(|cx: GeometryCx<'_>, layout| Editor::geometry(cx, layout))
    .paint(|cx: Paint<'f>, geometry| Editor::paint(cx, geometry))
    .hit(Editor::hit)
    .input(Editor::input)
    .accessibility(Editor::accessibility)      // still returns Element<'f>
```

The phases are **sealed capability tokens**, not a trait to implement. `LayoutCx`, `GeometryCx`,
`Paint<'f>`, `Hit`, and `A11y` are the `Slot<T>`-style local proofs of §10 applied to a paint
pipeline: `Paint<'f>` can *only* emit renderer-neutral scene packets into the frame's scene arena
and holds no `&mut` to the model, so paint cannot mutate state; `LayoutCx` may update only the
revisioned phase caches and obligations defined in §2.3, so measurement cannot secretly mount an
element or focus a control. The typestate
lives on the closure *argument*, exactly where the mistake would be made — it does not infect the
element's type, so `editor_surface(…)` is an ordinary `Element<'f>` that branches, nests, and
composes with every other builder.

The decisive win is that `.paint(|cx| cx.glyphs(&self.shaped))` **borrows** `self.shaped` for the
frame and streams it straight into the scene arena — the same zero-copy append that `text(&s)`
performs for a label, now at the glyph-run granularity an editor needs. There is no
`EditorPrimitive::new(&self.lines)` wrapper allocation, no registration ceremony, and no
owned-buffer requirement; the editor gets ImGui-class submission cost while the commit diff still
promotes only the scene ranges that actually changed (the atlas already caches the glyphs
themselves). Phase boundaries remain explicit because eliding them would make custom paint unsound,
but they are now expressed in the one vocabulary — borrowed frame, capability token, `Element<'f>`
— rather than as a parallel API. The custom editor stops being an exception and becomes the general
mechanism used at full strength; a `div` is the same mechanism used shallowly. Scene packets stay
renderer-neutral, so the same surface works with GPU, software, tests, remote composition, and
device recovery.

### 15.2.1 Temporal shading: current, previous, velocity, compute, composite

[Shading Motion](https://blog.maximeheckel.com/posts/shading-motion/) exposes a gap in most UI
animation plans. Moving a property is only one kind of motion; professional graphics software also
needs to *observe and shade motion* across frames: frame differences, decay trails, feedback paint,
blob masks, approximate optical flow, motion vectors, directional blur, onion skinning, wet brushes,
stabilization, and temporal filters. These are not more `Ease` variants. They are retained temporal
render graphs.

GPUI therefore exposes a scoped, typed graph capability on the same custom surface:

```rust,ignore
editor_surface(&self.document)
    .paint(Editor::paint)
    .post_process(|g: TemporalGraph<'_>| {
        let history = g.history_texture(
            Texture::working().scale(0.5),
            HistoryReset::Clear,
        );
        let motion = g.compute(MotionMask::new(
            g.scene_color(),
            history.previous(),
            history.current(),
            &self.threshold,
            &self.decay,
        ));
        g.output(MotionHeatmap::new(g.scene_color(), motion))
    })
```

`TemporalGraph<'_>` is a local proof builder, not a shader language and not a per-frame callback.
`#[gpu_shader]` types still provide checked WGSL interfaces. Mount validates the static pass/resource
DAG once and retains it. A frame only resolves typed ports, dispatches active passes, swaps history
generations after successful submission, and composites the output. Passes declare read/write
hazards, bounds, workgroup/scale policy, formats, color/data meaning, first-frame initialization,
resize/profile/device-loss reset, and fallback. Portable history uses separate previous/current
resources; read-write aliasing is an explicitly supported backend capability, never an assumption.

The graph distinguishes **inferred** from **known** motion. Frame differencing/optical flow infer
motion from current and previous color and are honestly sensitive to illumination, occlusion,
cadence, and wagon-wheel aliasing. Known velocity comes from retained scene identity and
previous/current presentation transforms. If a graph requests `g.velocity()`, ordinary scene nodes
emit the extra attachment from those transforms; a custom canvas supplies a typed velocity stream.
GPUI does not require the application to clone its scene into a second “velocity portal.” Depth,
object id, velocity, history, and extra color attachments are materialized only when a retained pass
requests them.

Known framework motion may also be sampled over a declared shutter interval/subsample count, under
the pass budget, to smear a predictable trajectory without cloning application nodes. Captured
video and other discrete external frames cannot recover unsampled motion; they use declared
optical-flow/frame-difference approximations and expose confidence rather than promising a correct
vector field.

GPU-to-CPU readback is a named asynchronous edge with byte/rate/backpressure limits. Reading a
192-byte blob table can be reasonable; reading the framebuffer each tick is never hidden behind a
property read. The optional `gpui_motion_fx` crate can ship motion masks, temporal decay, optical
flow approximations, SDF overlays, velocity blur, and similar recipes. The kernel ships only the
general history/pass/attachment/readback contract.

This remains zero-tax when absent: an application with no temporal graph has no history resources,
velocity attachment, compute dispatch, readback queue, extra pipeline variant, or frame request.
Within an active graph, half/quarter-resolution analysis, direct motion/property uniforms, retained
pipelines, range uploads, and damage/visibility gating make cost proportional to the declared
effect. Occlusion suspends sampling according to policy without advancing unpublished history.

### 15.3 Cases that remain honestly rough

The audit found no Zed shape that is unrepresentable, but several costs remain irreducible:

- heterogeneous workspace items and third-party panels cross the checked §9.2 protocol as
  `AnyEntity`; static Rust types cannot span a runtime plugin boundary;
- custom editor/layout/render nodes use the sealed phase capabilities on `Element<'f>`; application
  code cannot receive those capabilities as a back door to `&mut View`;
- OS windows, clipboard, drag export, IME, trays, and dialogs can be unsupported or revoked;
- physical async cancellation differs across Tokio, smol, threads, processes, and services; §7
  standardizes revocation/admission and stale delivery, not an impossible universal abort;
- application layout-dependent structure uses container queries or a next-epoch measurement
  signal. Only a sealed text surface may run §2.3's declared, bounded geometry fixed point over an
  unpublished draft; it never re-enters application description or effects;
- cross-window anchors cannot share one layout tree and either use screen-space platform placement
  or return `CrossWindowAnchor`;
- arbitrary borrowed large data must become an owned snapshot/handle before entering `Element`;
- named commands remain a catalog because keymaps/extensions need durable protocol identity;
- stateful components still deserve structs—only empty adapter structs disappear.

These costs are surfaced in types, inspector traces, and capability results rather than hidden in
`cx`, `.on`, a macro, or a panic.

### 15.4 The editor kernel — where GPUI was weakest, typed honestly

The single hardest thing GPUI expresses today is its own editor. `editor/src/element.rs` is roughly
12,000 lines. It calls back through `editor.update(cx, ...)` more than forty times during layout and
prepaint because the display pipeline is describe-time compute, not merely a model observed by a
view ([layout/prepaint source](https://github.com/zed-industries/zed/blob/main/crates/editor/src/element.rs#L7421-L7534)).
§2.3 gives that work its real home in `LayoutCx`/`GeometryCx`; converting each call to a
signal or declaring every mutation a bug would preserve neither performance nor meaning. Much of
the remaining bulk is manual coordinate juggling and a bespoke block-layout system. The buffer
offset, buffer point, multibuffer anchor, inlay point, fold
point, tab point, wrap point, block row, display point, and scroll pixel are all `usize`/`Point`
under the hood, so mixing them is a silent mis-render rather than a compile error, and every
conversion is a hand-written function. §15.2 already made custom paint cheap (borrowed glyph runs
through phase closures); this section resolves the *structure* those phases operate on, and it is
where the design is meant to be not incrementally but categorically better than what came before.

**1 · Coordinate spaces are branded newtypes; you cannot cross a space without the map.** Every
position is a `Pos<Space>` where `Space` is a distinct marker — `Buffer`, `Inlay`, `Fold`, `Wrap`,
`Block`, `Display` — and `Px` is its own type. A raw `usize` never flows as a position. The only
way from one space to another is the display map:

```rust,ignore
let caret: Pos<Buffer>  = self.selection.head();
let row:   Pos<Display> = self.map.to_display(caret);   // the ONLY path across spaces
let y:     Px           = self.map.line_top(row.line());
```

`self.map.line_top(caret)`—passing a `Pos<Buffer>` where `Pos<Display>` is required—does not
type-check. This is the `cozy-chess`/`pipeline-graph` newtype discipline (§10) applied to the exact
place editors leak. Revision safety uses a scoped lifetime proof, because stable Rust cannot create
a new nominal type for each runtime revision:

```rust,ignore
pipeline.with_snapshot(|map: DisplayMapRef<'m>| {
    let row: DisplayPos<'m> = map.to_display(anchor);
    map.line_top(row); // row cannot escape or be consumed by another snapshot
});
```

Across frames the application may retain only durable `(ExcerptId, Anchor<Buffer>)`. Kernel code
that must queue a numeric display offset pairs it with a runtime-checked `MapRevision`; event
lowering converts it back to an anchor against the same committed presentation snapshot before the
turn begins. The borrow checker prevents cross-snapshot positions inside a phase, while generation
validation handles stored packets between phases—an honest split between compile-time and runtime
identity.

**2 · The display map is an async-maintained derived projection, not a value we wish away.** Today
it is a third observed `Entity<DisplayMap>`, and its soft-wrap layer is itself an `Entity<WrapMap>`
because font-metric-dependent wrapping completes asynchronously. That independent lifecycle is
real ([display layers](https://github.com/zed-industries/zed/blob/main/crates/editor/src/display_map.rs#L197-L224),
[async wrap admission](https://github.com/zed-industries/zed/blob/main/crates/editor/src/display_map/wrap_map.rs#L2514-L2619)).
The replacement removes application `observe` wiring, not the entity-shaped kernel cell:
each mounted `EditorViewport` owns a `DisplayPipeline` and reads its
`Reader<DisplayMapSnapshot>`. Document-invariant logical layers and summaries may be shared, but
wrap width, font metrics, scale, blocks, and visible geometry are viewport inputs. The pipeline's
background wrap memo obeys the §7.0 wake law. While revision *N+1* wraps, that viewport keeps a
coherent exact or provisional snapshot descended from *N*; admission rejects a result whose
document, font, width, viewport, or projection generation is stale.

The private projection is the sealed `DisplayPipeline` exception specified in §2.3. Layout emits
`WrapDemand { projection, document_revision, font_revision, width, dirty_ranges }`; the epoch
barrier—not `LayoutCx`—coalesces it and arms the durable wrap node. The cell may retain pending
edits and an interpolation from the last accepted wrap snapshot, so “keep map *N*” does not mean
discarding edit correspondence while *N+1* computes. Only an admitted next-flush result advances
the public projection revision.

Within the projection, Zed's pipeline is
`multi → inlay → fold → tab → wrap → block → crease → display`. Each layer is a `Transform` with
typed adjacent spaces, so the stack only composes if the spaces line up. Sum-tree summaries make a
local edit reshape in `O(log n + changed)`:

```rust,ignore
trait Transform {
    type Above;
    type Below;
    fn down(&self, p: Pos<Self::Above>) -> Pos<Self::Below>;      // exact
    fn up(&self, p: Pos<Self::Below>) -> Range<Pos<Self::Above>>; // a fold maps to a range
}

// Fold<Above = Inlay, Below = Fold> ∘ Wrap<Above = Tab, Below = Wrap> ∘ …
type DisplayMap = Stack<Excerpts, Inlays, Folds, Tabs, Wraps, Blocks, Creases>;
```

The public snapshot is immutable and scoped-lifetime branded; the private phase cell may maintain
incremental trees and publish another snapshot. The hand-written `to_display_point`/
`to_buffer_point` swamp collapses into one composed function whose type proves the adjacent spaces,
without falsely claiming that a latency-bearing projection is a plain field or belongs to a
single global document view.

**3 · Inlays and block decorations are ordinary `Element<'f>` at typed positions — not a second
render path.** Diagnostics, git blame, inline assist, folded-region headers, and type hints are
today an entire subsystem. Here a block is just an `Element<'f>` slotted at a `Pos<Display>` (or
between two display rows), and an inlay is an `Element<'f>` at an intra-line `Anchor`; both go
through the *same* child sink and are measured by the *same* measure phase as any `div`. The editor
row stream is therefore "a shaped line **or** a child element," and interleaving custom widgets with
text stops being bespoke layout code:

```rust,ignore
canvas(&self.map)
    .rows(|row: Pos<Display>| match self.map.content(row) {
        Content::Text(line)  => shaped_line(line),          // borrowed glyph run (§15.2)
        Content::Block(slot) => self.blocks.get(slot),      // ordinary Element<'f>
    })
    .inlays(&self.inlays, Inlay::view)                      // Element<'f> at an Anchor
    .paint(|cx: Paint<'f>| cx.glyphs(&self.shaped))
    .hit(Editor::hit)
```

Only the frame-local child is an `Element<'f>`. The retained projection stores `BlockId`, anchor,
an owned renderer descriptor, and committed `BlockMetrics`; neither `DisplayMapSnapshot`, a cache,
nor a wrap future can contain `Element<'f>`. `LayoutCx` materializes and measures the current
child immediately, and a wrap worker receives only frozen owned inline metrics. This keeps ordinary
element composition without smuggling frame borrows into the async display pipeline.

**4 · Selections are data ports; blink is a timeline, not an observation.** Selection ranges live
in a retained overlay layer in display space and publish exact changed ranges. Caret blink is not
an `on_change`, task, or untyped observe: it is a clock-driven animation lane sampled directly into
opacity, reset by declared input/focus epochs. Neither path mutates `Editor` or re-describes it. A
120 Hz selection drag and a blinking caret therefore stay in the presentation-resident loop of
§4.2/§14.1 instead of manufacturing owner turns.

**5 · `MultiBuffer` is an excerpt composition over many buffers, with one semantic API.** An
`Anchor<Buffer>` is a rope sum-tree identity (bias + edit timestamp) that rebases across edits—
durable identity rather than an offset. `MultiBuffer` is a `List<Excerpt, ExcerptId>` projection;
each excerpt owns a stable identity, a source `Entity<Buffer>`, an anchored source range, and its
summary. `Pos<Multi>` resolves to `(ExcerptId, Anchor<that buffer>)`, and edits invalidate only
affected excerpt summaries. The common one-buffer editor uses a specialized singleton
representation, but not a different type or code path: it obeys the identical excerpt/position
contract ([current singleton representation](https://github.com/zed-industries/zed/blob/main/crates/multi_buffer/src/multi_buffer.rs#L76-L87)).
Search results, diffs, and ordinary files can therefore share selection, display-map,
serialization, and collaboration logic without pretending there is one global `Buffer`.

**6 · Main editor and minimap are N viewports, including viewport-inside-viewport.** The minimap is
currently a second `Editor` entity rendered from the first editor's prepaint. The replacement does
not special-case that recursion
([per-editor/minimap construction](https://github.com/zed-industries/zed/blob/main/crates/editor/src/editor.rs#L1816-L1875)).
A `Viewport<Document>` owns local scroll, scale, visible range,
selection presentation, focus/targets, and layout obligations while sharing the document,
`MultiBuffer`, document-invariant logical snapshots, shaping cache, and atlas by revision. A main
editor, split, peek, and minimap are peers even when one viewport's element is nested inside
another. They do not accidentally share width-specific wraps, selections, scroll, focus, or hit
geometry; reuse requires a compatible `ViewportSpec`. Each gets a separate scoped layout brand and
damage range; no entity-to-one-window reverse map and no reentrant `editor.update` are required.

**7 · Incremental reshape is a construction property, not a special case.** Rope + sum-tree gives
`O(log n + changed range)` reshaping; the borrowed frame re-describes only the changed line range
(the commit diff); the glyph atlas caches the rest because "text normally doesn't change much across
frames" ([zed.dev/blog/videogame](https://zed.dev/blog/videogame)). The editor gets "only reshape
and re-promote what changed" for free from §2.1 and §11, where element.rs tracks dirty ranges by
hand.

The net is not the unearned promise that twelve thousand lines become a few hundred. It is a clean
ownership cut: application `Editor` supplies document/view state and commands; the text kernel owns
phase computation, async projection maintenance, caches, and geometry; ordinary elements own
decorations; viewports own presentation. The coordinate, revision, cancellation, and phase rules
are enforced once below the seam instead of rediscovered by forty `update(cx, ...)` calls. The
escape hatch stops being a second UI model (§15.2), while the editor remains appropriately
specialized engineering rather than being rhetorically “resolved.”

### 15.5 Workspace presence is a supervised protocol, not view observation

Zed's follower state, leader-update channel, and long-lived apply task form a distributed system
inside [`Workspace`](https://github.com/zed-industries/zed/blob/fd82517a115d97a07835b52f0512b22b38e38ccf/crates/workspace/src/workspace.rs#L6184-L6250).
Collapsing that into `on_change`, a signal assignment, or a detached task would
lose ordering, reconnection, identity, and failure semantics. The replacement is an explicit
application/workspace-owned `PresenceSession` service. Transport tasks run on the selected async
runtime; the UI sees a `Reader<PresenceSnapshot>` plus typed session commands.

Every envelope carries `{ session, leader, incarnation, peer, lane, sequence, origin, item_ref,
payload }`, where `incarnation` advances on leader/reconnect/resync, `origin` suppresses echoes, and
`item_ref` is the versioned `ItemKind + locator/session alias` of §11.1—never an `EntityId`. The
receiver accepts only the active leader/incarnation, dedups replays, admits contiguous deltas, and
requests a snapshot when a bounded gap cannot close. A new incarnation begins with an authoritative
snapshot that atomically replaces obsolete peer/item replica state and establishes sequence bases.
Unknown local item mappings park or trigger authorized acquisition; they never alias another local
entity. Applying one admitted batch is one ordinary reactive transaction, so selection, scroll,
followed item, and peer status never expose a half-applied remote update.

One queue policy cannot serve all presence traffic:

- structural verbs—begin/end following, open/close/switch item, session membership—are reliable,
  ordered, bounded, and acknowledge protocol versions; overflow backpressures or resyncs rather
  than dropping `Open; Close`;
- cursor, scroll, viewport, and ephemeral status are latest-per-`(peer, item, field)`, coalescible,
  and may be replaced under backpressure;
- buffer edits remain the document collaboration protocol, not presence messages.

Transport ingress is `Remote<PresenceEnvelope>` with an explicit lane policy, not an async-reader
special case. `PresenceSession` validates/reorders a batch, then queues one typed
`Workspace::apply_presence_batch`; those writes dirty mounted consumers and publish once at the
normal flush. Session cancellation revokes future delivery; reconnect advances the incarnation so
an old stream cannot resurrect stale commands. Transport loss publishes typed `PresenceHealth`
plus retry/backoff/offline state—it is not forged into a reader/domain failure—and does not cancel
sibling views.
The view merely projects the snapshot and sends domain commands. This preserves full use of async
runtimes while removing a runtime task and distributed identity table from the rendering object.

---

## 16 · Feedback4 closure: shell, platform, text, and environment

The consolidated `feedback4.md` register is promoted from “future gaps” into the following public
contracts. A backend may report lack of support; the framework may not omit the concept.

### 16.1 Window chrome and compositor policy

`Window<V>` separates identity/kind, geometry, frame, compositor, controls, and activation:

```rust,ignore
Window::utility(inspector)
    .frame(Frame::Custom(titlebar))
    .background(WindowBackground::Transparent)
    .material(Prefer::new(Material::Mica).fallback(Material::Blurred))
    .shadow(WindowShadow::System)
    .corners(WindowCorners::Square)
    .controls(WindowControls::default().minimize(false).maximize(false))
    .level(WindowLevel::AlwaysOnTop)
    .hit_test(WindowHitTest::Content)
```

The vocabulary covers transparent/vibrant/Mica/blurred backgrounds, system/custom/no shadow,
corner policy, min/max/close buttons and placement, custom/native/server-side frames, movable and
resizable policy, always-on-top, mouse passthrough, native tab grouping, and parent/modal/popup
relationships. `Prefer<T>` records fallback; `Require<T>` makes unsupported realization a checked
open failure. Silent platform divergence is forbidden.

`Win<V>::active`, `bounds`, `scale`, `display`, and `appearance` are live readers. `activate`,
`minimize`, `maximize`, `restore`, `close`, `start_move`, `start_resize`, and
`request_attention` are checked/best-effort verbs. This closes focus gain/loss, programmatic focus,
per-monitor DPI, and monitor-move lifecycle. The current GPUI window handle is evidence that typed
window identity works; 07 removes the remaining need to recover it through context or strings.

### 16.2 Renderer choice, device loss, and screenshot tests

Layout emits a renderer-neutral retained scene protocol. `Application::renderer` chooses
`Auto`, a named GPU backend, `ReferenceCpu`, or an ordered fallback policy. Device preference
(`LowPower`, `HighPerformance`, explicit adapter) and recovery policy belong to the application,
not individual elements. Device loss keeps the committed CPU scene, realizes another backend,
reuploads leased resources, and publishes either `Recovered` or a typed surface fault.

The renderer's working light is **premultiplied linear extended sRGB**. This is deliberately not a
choice between an sRGB renderer and a Display-P3 renderer: negative and greater-than-one components
let an application CMS transform arbitrary ICC/document spaces into one stable framebuffer contract,
while the tagged platform surface/compositor maps it to the current display. Adding a future monitor
gamut does not add a GPUI working-space variant. `Color` retains its authoring/interpolation tag;
shader and canvas color ports receive the internal `WorkingColor`; masks, velocity, ids, and generic
data textures are explicitly not color.

```rust,ignore
Window::document(studio)
    .surface_color(Prefer::new(SurfaceColor::ExtendedSrgb16)
        .fallback(SurfaceColor::SdrSrgb8))
    .dynamic_range(DynamicRange::Extended)
```

`SdrSrgb8` remains the default four-byte surface. `ExtendedSrgb16` negotiates a float16/scRGB-like
surface tagged extended **linear** sRGB (`RGBA16Float` on Metal, `R16G16B16A16_FLOAT`/scRGB on
Windows, an advertised extended-linear format/tag or explicit final transform on wgpu/Vulkan).
`Prefer` records fallback; `Require` turns lack of support into a checked open/reconfigure error.
The realized surface publishes format, color tag, reference white, HDR headroom, alpha mode, and
profile revision. Moving between displays patches that presentation contract; it does not rebuild
the logical/layout tree or relabel sRGB values as P3.

This adopts the open-surface direction of
[zed discussion #62795](https://github.com/zed-industries/zed/discussions/62795), with linear
compositing, while deliberately not adopting
[PR #48835](https://github.com/zed-industries/zed/pull/48835)'s global
sRGB/Display-P3/untagged selector. Changing only a `BGRA8Unorm` layer tag cannot preserve
out-of-range pixels, ingest profiles, or make relabeled triples color-correct.

Professional document state owns source/assigned/proof ICC profiles, rendering intent, and
black-point policy. An optional `ColorManagement` capability realizes CPU transforms or cached GPU
LUTs into `WorkingColor`; GPUI does not mandate a particular CMS. Images/video keep source metadata,
PQ/HLG is normalized against the declared reference white, SDR fallback uses an explicit tone/gamut
mapper, and export/screenshot names its output profile and transfer. HDR highlights—including
system-like specular feedback—use an explicit luminance-bearing paint; a random `Color` above 1 is
not silently reinterpreted as HDR.

Glass/specular feedback is consequently a retained material, not a theme-color trick: pointer,
press, geometry, clock, and motion-lane inputs bind directly to typed shader uniforms; the material
declares backdrop/history/damage and may emit luminance-bearing working light on an extended
surface. No handler or owner reruns at pointer cadence, and an application that never installs the
material has no pass, layer, HDR request, or uniform lane.

The framebuffer does not become the document's storage format. Creative canvases may keep native
integer/f16/f32/profiled planes, spot channels, or other application data and convert only the
composited result into `WorkingColor`. Float16 is the preferred extended presentation precision,
not a forced precision for destructive editing or export.

The zero-tax boundary is exact. A window that never requests extended color keeps the existing
surface byte count, attachment/pass count, lazily compiled shader set, and clean-frame work. It has
no profile lookup, LUT, HDR metadata update, extended intermediate, or full-screen conversion pass.
An extended window pays the unavoidable extra storage/bandwidth; the claim is **zero when unused**,
not that float16 is free. All intermediate/save/temporal layers in an extended graph preserve the
working range, or the renderer reports the precise narrowing fallback. The full normative contract
and profile corpus are in [runtime/color.md](runtime/color.md).

Screenshot tests do not capture a native window. They rasterize a committed scene directly into
an offscreen `ReferenceCpu` target with fixed fonts, scale, working/surface color contract, output
profile, reference white, tone mapper, and sampling. Semantic tree/scene assertions remain cheaper;
reference pixels cover raster fidelity; each GPU/Vello-like
backend runs conformance images against the reference with declared tolerances. An alternative
renderer can therefore improve production without changing test meaning or making CI depend on a
GPU/display server.

Software rendering is a production fallback, not test-only code. Framebuffer/MCU targets may
install a font source, output surface, clock, input source, and `ReferenceCpu` renderer without a
desktop backend. Foreign-language integrations consume the versioned scene/input protocol rather
than Rust `Element` or `Entity<T>` ABI.

### 16.3 Text raster policy and measurement

Parley supplies shaping, bidi, line breaking, fallback, selection, and layout; it does not by
itself solve every raster mode. Although its Skrifa stack can produce hinted outlines, current
Zed's metrics-hinting/bi-level request remains blocked on the needed Skrifa behavior. GPUI exposes
the policy now and reports backend support honestly:

```rust,ignore
TextRaster::default()
    .metrics_hinting(Hinting::Full)
    .antialias(Antialias::BiLevel)
    .atlas_filter(Sampling::Nearest)
    .snap(PixelSnap::BaselineAndStems)
```

The policy is application/window default with subtree override. Unsupported combinations use
`Prefer` fallback or `Require` failure. Layout snapping is a logical-axis policy shared by text,
borders, and transforms; it is not an ad hoc rounding call in paint.

`TextMeasure` is a read-only service accepting text, style, constraints, locale/direction, and
scale and returning ink bounds, logical bounds, baselines, line metrics, clusters, carets, and
overflow. Retained `TextLayout` handles expose the same metrics after commit. Measurement never
secretly mounts an element or mutates the font cache from a paint callback.

### 16.4 Clipboard, drag, menus, tray, dialogs, and IME

Desktop integration is a set of independently installable typed capabilities:

- `Clipboard` supports MIME-tagged values, images, external paths, X11/Wayland primary selection,
  find pasteboard, async/lazy providers, and ownership-loss notification;
- `DragDrop` uses the same `DataOffer` protocol for internal values, OS MIME data, promised files,
  and virtual files whose bytes are produced on demand;
- `Menus` consumes typed `Command<A>` entries for menu bar, context, dock/taskbar, and application
  menus;
- `Tray` owns icon/menu/status/attention and activation routes;
- `FileDialogs` returns standard futures for open/save/folder choices with filters, starting
  location, bookmarks/security scope, and cancellation;
- `OpenExternal`, notifications, haptics, and accessibility platform bridges follow the same
  capability/result pattern.

Handlers request only what they use:

```rust,ignore
fn copy(&mut self, clipboard: Clipboard) -> Result<(), ClipboardError> { /* ... */ }
fn open(&mut self, dialogs: FileDialogs, editor: Remote<Self>) { /* spawn ordinary future */ }
```

IME is a public bidirectional protocol, not a backend-private callback. An input target publishes
`Enable/Update/Disable(InputMethodState)` containing surrounding text snapshot/revision, UTF-8 and
UTF-16 selection, composition/preedit and styling, replacement range, cursor rectangle in window
coordinates, input purpose, capitalization, and writing direction. The platform sends
`Preedit`, `Commit`, `DeleteSurrounding`, `SetSelection`, and `Candidates` events tagged with that
revision. Stale events rebase or reject; history groups composition as one transaction. An
in-process virtual keyboard implements this same protocol and therefore needs no privileged widget
API.

### 16.5 Theme, inherited environment, RTL, and global resources

Theme colors are semantic, color-space-aware tokens rather than precomposited leaf colors:

```rust,ignore
text("Next").text_color(Fg::Muted);
panel.provide(Theme::dark()).provide(Enabled(false));
```

The retained environment supports a sealed set of typed inherited properties: theme/palette,
enabled, visibility, locale, writing direction, reduced motion, contrast, text defaults, and
accessibility state. Each is a source key in the cascade, so changing `Enabled(false)` patches the
affected subtree without recreating it. Alpha colors resolve against semantic layers at composite
time, avoiding theme coupling under translucent surfaces.

`FlowDirection` drives logical `Start/End`, flex order, grid placement, padding/margins, icons that
opt into mirroring, and placement fallback. Text bidi and layout mirroring share locale/direction
but remain separate algorithms; setting Arabic text does not blindly mirror a code editor.

Application-global domain data is not an ambient singleton lookup. `Application::provide` installs
typed resources; constructors receive `Reader<T>`/`Entity<T>` explicitly, handlers may request a
sealed service capability, and visual cascade data uses `provide` on the tree. Tests replace a
resource on `Application::demo`. This handles settings, theme, HTTP/client services, clocks, and
feature flags without making arbitrary globals invisible dependencies of `view`.

### 16.6 Event-loop interop, displays, and cross-thread work

`Application::run` owns a normal platform loop. `attach(host)` integrates with an external owner.
`poll(deadline)` exposes prepare/wait-dispatch/commit deadlines for hosts such as game engines,
audio tools, and embedded shells. All three terminate the same application plan and use the same
turn queue; platform callbacks may wake the host but never recursively settle GPUI.

`Application::displays()` returns `Reader<Arc<[Display]>>`; there is no platform-only
`Availability<T>` parallel to §7's graph. A low boundary distinguishes first readiness from a real
empty set or typed platform failure, while `displays.resolve().await` is the imperative startup
synchronization point.
Each `Display` has durable identity and live geometry/scale plus an opaque color-profile handle or
bytes when available, profile revision, SDR reference white, HDR headroom/range, and compositor
capabilities; each `Win<V>` publishes its realized surface contract and which display currently
presents it. Layer-shell/output selection and a document CMS can therefore wait for facts instead
of guessing from an empty vector or hard-coding Display P3.

Derived workers use standard futures, threads, pools, processes, or channels and complete through
the §7.0 driver adapter: one owned `StampedCompletion` dirties their memo at the next normal turn;
`PollWake` remains inside the runtime. `Remote<T>` is reserved for owned actor/service commands
whose message is itself the domain protocol; it is `Send`, wake-capable, generational, and reports
owner closure. Spawning from a
foreign thread needs no GPUI executor in either case. Backpressure is explicit (`Latest`,
`Coalesce`, `Reliable`, bounded channel), and machine-rate streams publish specialized ports rather
than owner messages.

---

## 17 · Stabilization gates

This design lands only if executable fixtures prove it:

The cross-cutting reference scenario is
[`examples/async_workbench.rs`](examples/async_workbench.rs); the focused gates below split that
scenario into deterministic runtime, compile-fail, fault-injection, and protocol fixtures rather
than trusting one happy-path demo.

1. **No-macro Rust:** nested `if`, `match`, `if let`, `?`, early returns, borrowed locals,
   `Option<Element>`, iterators, Flex/Grid branches, and conditional setters compile with no
   erasure call or macro.
2. **One macro:** the workspace has one UI-semantics macro, `#[reactive]`. There is no coarse view
   macro, fine variant, builder macro, action macro, or signal expression DSL.
3. **Semantic equivalence:** adding/removing `#[reactive]` changes only work counters and the
   dependency manifest, never scene, state, events, focus, a11y, history, or drop order.
4. **LSP:** completion, rename, go-to-definition, inlay hints, extract-function, rustfmt,
   diagnostics, and source-mapped expansion work inside realistic macro bodies. Failure deletes
   the macro from the release, not the no-macro fast path.
5. **Builder typing:** `Flex`/`Grid` wrong-family methods fail locally with a useful diagnostic;
   their completed elements branch freely; no rustdoc or compiler error prints a recursive style
   type.
6. **Direct parity:** handwritten property ports and `project` regions have byte-identical runtime
   descriptors to macro-lowered equivalents and allocate zero after installation.
6b. **zgui by construction (§14.1):** a ported apples-to-apples workload proves the secondary tier
   allocates zero on an unchanged subtree, never traverses a clean tree, and stays in ImGui's
   authoring cost class and zgui's steady-state cost class on the *same* renderer; a clean-frame
   allocation or clean-tree walk is a build failure, not a tuning task.
7. **Handler flow:** Escape and blackout examples prove guards are ordinary early returns and
   propagation; recursive outputs remain FIFO and non-reentrant.
8. **Work freedom:** Tokio, smol, a custom executor, `std::thread`, and a channel drive equivalent
   readers/actions without importing a GPUI task type. Physical cancellation may differ; admitted
   pixels, event order, and stale-delivery rejection do not. One hundred duplicate/spurious
   `PollWake`s cause zero signal writes or memo evaluations; only `Poll::Ready` emits one
   `StampedCompletion`, which runs no application code before its next ordinary turn and uses the
   same dirty-node/height/equality path as a synchronous memo. Completion during a flush is deferred.
8b. **Async reads (§7):** high-declared Story and Comments producers start in the same turn while a
   low detail boundary alone shows fallback; a truly author-id-dependent producer starts later and
   the inspector names that edge. Initial readiness, no-fallback revalidation, `reload_on`,
   `is_pending`, `latest`, urgent text input, unrelated-cohort progress, `A -> B -> A`, out-of-order
   success/fault, unmount/remount, retry, and owner revocation match the reference state machine.
   `trybuild` rejects `*Reader<T>`, a retained projection capturing `&self`, a reader/element across
   `await`, and a worker input without an owned freeze. Removing `#[reactive]` preserves the explicit
   `project` fixture's semantics.
9. **Fallibility:** fuzz stale slots/targets, cancellation, first-load and stale revalidation
   failures, window/media/device loss, drop rebase, worker panic, mutable-handler panic, plugin
   unwind, and `panic=abort`; domain `E`, cancellation, and framework `Fault` never alias, no
   sibling reader is cancelled by another's failure, no half-cohort publishes, and no result is
   silently swallowed.
10. **Entity/link cost:** application-only incremental rebuild and link benchmarks prove new
    `Entity<T>` types add only proof shims/table entries, not scheduler/renderer copies; no dylib is
    required to keep development viable.
11. **Application unity:** binaries, examples, tests, multi-window plans, and embedded loops begin
    with `Application`; no `gpui::run`, `desktop()`, `Ui` test runtime, or hidden scheduler remains.
12. **Promotion:** `T <-> Signal`, `Vec <-> List`, and contained `<-> Entity` fixtures preserve
    ordinary view source except honest dereference/reader changes.
13. **Borrowed element:** function roots need no adapter struct; the generative `'f` brand makes an
    `Element<'f>` that escapes its `describe` scope (stored `'static`, sent, or held to the next
    frame) a compile error under a `trybuild`/Miri fixture; description performs zero clones/interns
    and the commit diff promotes only the changed operand, both counter-verified.
14. **Demo barriers:** open, key, pointer, text, clock, and ready-work drivers return after one
    committed presentation; normal assertions contain no `settle`, sleep, window index, or scene
    traversal.
15. **Typed windows:** multi-window tests retain `Win<V>` values and contain no title/string
    lookup; closed/stale handles return a typed miss; scale/display/activation transitions publish.
16. **Platform matrix:** window material/chrome, CPU fallback, device recovery, text raster policy,
    clipboard/drag, menus/tray/dialogs, IME, RTL/inheritance, display readiness, and external-loop
    fixtures either work or return their declared `Unsupported`/fallback result.
17. **Zed migration corpus:** representative editor, pane, modal, notification, context-menu,
    workspace-item, command, subscription, async, custom paint surface, and multi-window files
    compile without `cx`, `AnyElement` branch erasure, GPUI `Task`, or manual notify, and the
    editor's glyph run reaches the scene arena as a borrow, not a per-frame clone.
18. **Editor/display pipeline (§2.3/§15.4):** a fixture proves `Pos<Buffer>` cannot be used where
    `DisplayPos<'m>` is required; a display position cannot escape or cross snapshot scopes; queued
    numeric packets fail a mismatched `MapRevision`; and transform layers compose only when spaces
    align. One `MultiBuffer` drives two differently sized editors plus a nested minimap with distinct
    coherent wrap/geometry snapshots. A→B→A width/font/document changes, reordered completions,
    typing through provisional wrap, display worker faults, and bounded block reflow never mix map,
    hit, paint, a11y, or selection epochs. `trybuild` rejects `Element<'f>` in a retained block or
    worker. Selection and blink patch ports with zero owner reruns.
19. **Entity observation (§6.4):** `entity.on_change(M)` and typed `Emitter` + `entity.on(M)` wire
    with no stored `Subscription`/weak handle/`()` bus; a wrong-typed observer is a compile error;
    links park at construction, arm at mount, and die on unmount under a leak fixture.
20. **Terse launch (§12):** `Application::run(root)` and `Win::demo(root)` drive the same turn
    engine as the builder with no hidden App spec and nothing on `Drop`; a one-window binary and a
    one-window test each fit one line.
21. **Motion semantics (§4.2):** timed/keyframe samples agree at identical timestamps across 60,
    120, and irregular Hz; interruption begins at the presented value/declared velocity; pause,
    seek, reverse/rate, fill, cancel, replace/add, gesture handoff, reduced motion, and structural
    snapshot teardown reach their declared final state. Ten thousand warm tracks allocate zero,
    write no source, run no owner/effect, and patch only their destination obligation lanes.
22. **Temporal shading (§15.2.1):** first-frame/resize/profile/device-loss resets, portable
    ping-pong, failed/dropped-frame publication, hazards, downsampled coordinates, history eviction,
    velocity disocclusion, cadence aliasing, and bounded readback pass. A retained motion-mask →
    decay → flow/blob → composite fixture dispatches without rebuilding its element/canvas or
    cloning its scene, while a UI without a temporal graph has zero history/velocity/pass work.
23. **Open color/HDR (§16.2):** `runtime/color.md` C0–C10 pass on Metal, DirectX, wgpu and
    `ReferenceCpu`: ICC corpus, negative/>1 working values, linear premultiplied blend, tagged
    extended output, SDR gamut/tone fallback, display moves, HDR reference white, and no double
    transform. The SDR fixture retains the pre-feature surface bytes, attachments, passes, pipeline
    creation, and clean-frame counters exactly.
24. **Workspace item protocol (§9.2/§11.1):** two independent catalogs coexist in one process;
    duplicate kinds fail deterministically; all known tabs restore in parallel; close/move/remount
    rejects stale completion; duplicate tabs share a locator but preserve distinct instance state;
    and unknown/disabled plugin records survive byte-for-byte behind a recovery surface. No factory
    can borrow a pane/workspace/window/app across `await`, use a global, serialize `EntityId`, or
    call a weak upgrade. Plugin leases make unsafe unload impossible.
25. **Cycles, focus, and presence:** cyclic-construction panic leaves every weak key dead; ordinary
    pane/workspace flow uses mounted outputs/readers rather than weak self. Focus reclaim runs once
    after a successful target commit and loses to unmount, a newer claim, or user/OS focus. Presence
    fuzzing covers replay, gap/resync, leader/reconnect incarnation, protocol mismatch, missing item
    alias, echo suppression, reliable `Open; Close` ordering, coalesced cursor/scroll pressure, and
    atomic snapshot/batch application; no peer sends an `EntityId`, and one transport fault cannot
    cancel a sibling view.

---

## 18 · Deleted and retained surface

Deleted outright:

- `gpui::run`, `View::run`, `Ui::run`, `desktop()`, and event-loop-on-drop;
- public tasks, task/action fields, detach, and framework executor contexts;
- process-global project/serialization/follow registries, persisted `EntityId`, and factories that
  hold pane/workspace/window/application borrows across `await`;
- `async fn view`, fallible/pending `Deref`, panic-as-suspension, resource `loading/error` flags,
  app-global pending state, and explicit `start_transition` wrappers;
- `tracked`, public region scopes, signal `then/when/switch`, and ambient dependency capture;
- application-side `Either`/`.any()`/boxing merely to unify view branches;
- `.flex(|builder| ...)` and recursive element/style typestate;
- general presentation-time `.on(...)`, detached subscriptions, and ambient emit;
- chord `.guard`, chord predicates, untyped local-action/listener adapters, and string key contexts;
- hook order, generated component state, and foreign UI template syntax;
- weak-self completion ceremonies, reentrant entity update closures, manual notify, and `cx`
  threading through ordinary application methods;
- render-time focus-reclaim flags and timer/animation ticks modeled as entity observation.

Retained, narrowed, or introduced:

- one borrowed `Element<'f>` draft over a per-turn arena, with owned retention produced by the diff;
- typed layout/policy recipes and short obligation builders;
- constants and signals accepted by the same typed property sinks;
- `Sources::project` as the explicit, exact, no-macro structural fast path;
- one optional `#[reactive]` macro that lowers normal Rust to those same primitives;
- one non-`Deref` `Reader<T>` across sync/async/external producers, with ready-only `project` at
  the first consumer and no `Future`/`Option`/error type through intermediate components;
- mounted async/CPU producer sites, exact request stamps, private candidate graph descriptions,
  retained presentation cohorts, low first-readiness/fault boundaries, `is_pending`, and `latest`;
- the single graph bridge `Poll::Ready -> StampedCompletion -> dirty memo -> next reactive flush`,
  while `PollWake` and all polling stay in real Rust runtimes rather than a second GPUI async model;
- regular model methods/actions for asynchronous writes, plus mounted
  `.action(...).queue(...).pending(...).then(...).catch(...)` as a small local adapter;
- `Remote<T>` for owned cross-thread method delivery;
- `Output<E>` for named component back-edges;
- `entity.on_change(M)` and typed `Emitter` + `entity.on(M)` for kernel-managed entity observation;
- narrow `WeakEntity<T>::inspect/send` plus atomic `Entity::new_cyclic` for audited true cycles;
- sealed `LayoutCx`/`GeometryCx`, bounded layout feedback, and the post-barrier `WrapDemand` bridge
  for text-engine describe-time compute below the application seam;
- typed `Pos<Space>` coordinates, a composed display-map transform stack, and decorations as
  frame-local `Element<'f>`; per-viewport async `DisplayPipeline`s over excerpt-based
  `MultiBuffer`, including singleton fast path and nested minimap viewports;
- one injected versioned `ItemCatalog`, item-owned locator/state schemas, preserved recovery items,
  and a supervised ordered/coalesced presence protocol;
- motion values lowered to dense timeline/effect/playback/composition lanes with presented-value
  interruption and bounded structural snapshots;
- retained temporal shader graphs with typed history, optional scene attachments, compute/render
  hazards, bounded readback, and no resources or work when absent;
- a linear extended-sRGB working contract, opt-in float16/HDR surfaces, application-owned ICC
  policy, and an exactly unchanged default SDR cost class;
- typed `Command<A>` for the real keymap/menu/extension protocol boundary;
- `Signal<T>`, `List<T>`, and `Entity<T>` only when their distinct semantics pay for themselves;
- direct function roots, typed `Win<V>`, semantic demo queries, and automatic turn barriers;
- explicit renderer/platform/text/IME/environment capabilities with typed fallback;
- one `Application` for run, demo, tests, windows, and embedding, with terse `Application::run(root)`
  and `Win::demo(root)` sugar for the one-window binary and test.

---

## 19 · Three-paragraph summary

The original GPUI owner was right: a serious Rust GUI needs a safe home for shared dynamic state,
asynchronous subtrees, platform resources, and non-reentrant notification. The refactor keeps that
owner but moves cleverness behind typed routes and a borrowed-frame draft over a retained tape. A
one-off root is simply a function returning `Element<'_>`; a stateful component is an ordinary
struct; a title is never a window identity; and `Application` is the only way to run, demonstrate,
test, or embed the system.

Ordinary `if`, `match`, `Option`, iterators, and unlike widgets work because finished tree shape is
one `Element<'f>` sharing a single frame brand, while useful proofs live at inputs: `Flex`, `Grid`,
`Slot<T>`, `Target<K>`, `Win<V>`, properties, routes, and protocol capabilities. Description
**borrows** `self` and scalars into a per-turn arena — ImGui-cheap appends, no clone or intern —
and the commit diff promotes only the changed operand to owned storage; that generative `'f` brand
is exactly why `Element<'f>` can borrow yet provably cannot leak. A signal reference is a direct
wire; an explicit typed `project` is the no-macro structural fast path; the sole optional
`#[reactive]` macro only removes repetitive projections and lowers to the same runtime
representation. The same non-`Deref` `Reader<T>` crosses synchronous, asynchronous, and external
producers; its first `project` consumer receives a real `&T`, while low loading/fault boundaries
own absence and latency. The same borrowed frame carries a custom editor's glyph run; sealed
`LayoutCx`/`GeometryCx` phases give its necessary describe-time computation a home without giving
application views mutation. The secondary tier matches ImGui's per-frame cost and zgui's retained
locality by construction, not by tuning.

Handlers are methods and guard themselves with Rust control flow; named product commands survive
only where keymaps and extensions need durable identity. Tokio, smol, host runtimes, threads, and
services create and poll work; their only graph bridge is “`Poll::Ready` becomes one stamped memo
update for the next flush.” Mounted identity, exact stamps, retained presentation, and typed fault boundaries
then make latency a first-class graph fact without `async fn View`, task fields, null holes, unwind
control flow, or a second executor. Saving is a method/action because mutations are not reads;
ordinary fallibility remains `Option`/`Result`. One injected item catalog, item-owned durable
locators, checked weak cycles, post-commit focus claims, and a supervised presence service close the
workspace gaps without globals or serialized runtime ids. `Application::demo` commits after every driver action and typed windows expose
semantic assertions directly. Motion values sample dense retained lanes rather than rerunning Rust;
the same phase-capability surface can retain temporal compute/history graphs when an editor asks to
shade motion and allocates none of them when it does not. Linear extended sRGB gives an application
CMS one open working/framebuffer contract, with float16/HDR opt-in and the ordinary SDR path exactly
unchanged. Together with explicit platform capabilities, these mechanisms cover the editor, custom
rendering, color-accurate creative work, IME, desktop integration, software fallback, and event-loop
interop without inventing a third language.
