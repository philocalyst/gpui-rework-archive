# 11 — Consolidations: Where 07 Leaks, and the Algebra That Closes It

Status: structural review of [07-the-ladder.md](07-the-ladder.md) as normative surface.
Each finding names a leak or an unstated law in 07, proposes the consolidation, and lists what
the consolidation buys elsewhere. Findings are ordered by leverage, not severity: the first one
closes several of the later ones for free.

The test applied throughout is 07's own: one semantic model, proofs at boundaries, no third
language, nothing ambient. Every finding below is a place where 07 currently passes that test
*locally* but fails it *globally* — the same idea respelled per feature, or a law the gates
depend on that no section states.

---

## 1 · The missing centerpiece: name the Source algebra

07 has one idea it never names. Count the verbs that accept "a place a value comes from":

| Verb | Accepts today | Defined in |
|---|---|---|
| property sink | `T`, `&T`, `&Signal<T>`, `Reader<T>`, "typed projections" | §4 (`IntoProperty<T>`) |
| `project` | tuple of sources; single `Reader<T>` ready-only | §4, §7.1 |
| `map` / `map_async` / `try_map_async` | signal, reader | §7 |
| `on_change` | `Entity<T>`, *or* "a derived wire" `signal.map(f)` | §6.4 |
| `animate` | `&Signal<T>` | §4.2 |
| `is_pending` | "a source/read expression" | §7.4 |
| `latest` | "input sources" | §7.4 |
| `reload_on` | a source | §7.2 |
| `.with(...)` | value = constant; "a signal/reader is sampled at dispatch" | §9 |
| boundary child | reader/property/projection descriptors | §7.2 |
| `Win<V>::active`, `displays()` | readers | §12, §16.6 |
| theme tokens | `Fg::Muted` — a cascade-resolved feed | §16.5 |

Twelve surfaces, each defining its accepted inputs ad hoc, each with its own prose about
readiness, equality, and staleness. This is the leak: the concept "typed value feed with
identity, readiness, and a change protocol" is load-bearing everywhere and specified nowhere.
The symptoms are already visible in 07:

- §6.4 needs a special paragraph to let `on_change` take a derived wire, because "wire" has no
  name — it's re-derived from `Signal` + `map` in place.
- §4 says tuples project "to a deliberately modest arity; a named struct of readers handles
  more" — but there is no mechanism by which a named struct becomes projectable. A derive would
  be a second macro (forbidden by gate 2). This is dangling.
- What does `(&self.open, story).project(...)` mean when `open` is a `Signal<bool>` and `story`
  is a possibly-pending `Reader<Story>`? 07 defines signal-tuple projection and single-reader
  projection but never the mixed case, which is the common one.

**Consolidation.** One sealed trait, kernel-owned, with a GAT for the borrowed ready view:

```rust,ignore
pub trait Source: sealed::Sealed {
    type Value;
    type Ready<'a>: Copy;                    // &'a T for scalars; slot views for lists
    // kernel-internal: raw key(s), verdict (Ready/Pending/Fault), stamp, equality hook
}
```

- `Signal<T>`, `Reader<T>`, `Entity<T>` (any-change, `Value = ()`), committed window properties,
  and cascade tokens are instances.
- Tuples implement `Source` by product; readiness is the meet (all ready), the stamp is the
  tuple of stamps. The mixed signal/reader tuple is now *defined*, not special-cased.
- A named struct of sources implements one sealed `SourceSet` trait by hand — five explicit
  lines listing its fields, honest, no derive macro, no arity cliff.
- Every verb in the table above is defined **once**, over `impl Source`. §6.4's derived-wire
  paragraph deletes: `on_change` is a verb on any `Source`, and `signal.map(f)` is already one.
- `List<T>` gets the sibling row: a sealed `SeqSource` whose `Ready<'a>` is a slot view and
  whose change protocol is deltas. `children(...)` is then one verb over `SeqSource`, with
  `&Vec<T>` as the degenerate realign instance — exactly the promotion story §1 already tells,
  now as a trait fact rather than two overloads.

**What this buys.** Three open questions in 07 dissolve:

1. *`Entity<T>: Deref`* (§13) is a conditional soundness proof 07 defers to stabilization. Under
   the algebra it stops mattering: an entity is a `Source`, so committed reads happen inside
   kernel-evaluated positions (`project`, property feeds, `map_ref`) where the epoch borrow is
   the kernel's to prove, and imperative code keeps `inspect`. Recommend dropping the public
   `Deref` ambition now rather than carrying a maybe-unsound convenience to the gate.
2. *`is_pending` / `latest` scope* (§7.4). Both become total functions on `impl Source` — an
   adapter returning another `Source` (`is_pending: Source → Source<Value = bool>`; `latest`
   returns the same source with a different cohort policy). Their prose definitions become
   one-line type signatures.
3. *Composition questions answer themselves.* Can you animate a theme token? `animate(Fg::Muted)`
   type-checks iff tokens are sources — and the cascade-resolution-then-sample order falls out of
   the feed pipeline (finding 2's table). Can a boundary `reload_on` a derived reader? Yes, it's
   a source. Nobody has to design these one at a time.

The gates change accordingly: gate 6 ("direct parity") generalizes to *every verb × every source
instance produces the same installed descriptor as its macro lowering*, one matrix instead of
per-feature fixtures.

## 1.1 · The property side of the same algebra

`IntoProperty<T>` (§4) is the dual: "what a sink accepts." Enumerate it once:

```text
Feed<T> = Const(T)
        | Wire(impl Source<Value = T>)          // installed port
        | Track(Motion over a Source)            // §4.2, sampled on a timeline
        | Token(semantic cascade key)            // §16.5
  modifiers: latest(_), is_pending(_)-derived wires, map/map_ref projections
```

07 has every constructor but presents them in four unrelated sections, so their interactions
are unspecified (Track over Token? latest of a Track?). One table in §4 defining `Feed<T>` and
which modifier compositions are admitted closes the class of questions permanently. Same for
child sinks: `Element`, `Option<Element>`, iterator, `SeqSource + fn`, projection region — one
list, one place.

---

## 2 · Delete `if_` before it becomes a language

§7.4 spells:

```rust,ignore
results_list().opacity(if_(is_pending(&self.results), 0.65, 1.0));
```

`if_` is a conditional *expression combinator* — the first word of exactly the third language 07
forbids (§0, §5.1: "no effect language, chord predicate language, or UI template grammar").
Today it has one form; the moment a second condition or a `match_` is needed, GPUI owns an
expression DSL with its own evaluation and equality semantics.

Under finding 1 it is unnecessary: `is_pending(&self.results)` is a `Source<Value = bool>`, and
`map` is already closed over sources:

```rust,ignore
results_list().opacity(is_pending(&self.results).map(|p| if p { 0.65 } else { 1.0 }));
```

Ordinary Rust in the closure, one fewer public name, no expression grammar to grow. The same
argument pre-deletes any future `select_`/`match_`/`bool::then_`-style feed helpers: the answer
is always `map` over a source.

---

## 3 · `Element<'static>` should own its temporaries — kill the `Frame` parameter

§2.1 admits the one ergonomic wart of the borrowed frame: a stateless free function that builds
arena temporaries must spell `fn empty_state(f: Frame) -> Element<'_>`. This is worse than
"rare friction" — it is a **signature-instability leak**. Whether a helper contains a `format!`
is an implementation detail, but under 07 it changes the function's public type: adding one
formatted label to a previously borrow-free helper breaks every caller. Refactors will ripple
`Frame` parameters through utility crates exactly the way `cx` rippled through Zed.

**Consolidation.** Make the arena an *optimization*, not a *capability*. An `Element<'static>`
draft carries a small owned spillover buffer (inline-then-heap, like `SmallVec`) for operands
that would otherwise need the arena; the coercion `Element<'static> → Element<'f>` at the
`.child()`/return splice moves the spillover into the arena. Consequences:

- `fn empty_state() -> Element<'static>` works with `format!` inside; `Frame` disappears from
  application signatures entirely and becomes kernel-internal. The §2.1 "honest cost" paragraph
  deletes.
- The cost lands only on the rare shape that had the wart (borrow-free helpers with
  temporaries), is proportional to those temporaries, and is measured by the same gate-13
  allocation counters. The overwhelmingly common `fn view(&self) -> Element<'_>` path is
  untouched — still pure arena appends.
- Boundary fallbacks stop being eagerly described: `boundary().loading(detail_skeleton)` can
  take the *fn item* (a `fn() -> Element<'static>` is now unconditionally possible), so a ready
  branch never pays for describing a skeleton it will not show. Today's `loading(detail_skeleton())`
  re-describes the fallback on every rerun of the parent — a small standing contradiction of
  "zero on unchanged subtree" that this closes.

Gate 13 gains a clause: no public API takes `Frame`; `trybuild` keeps proving the brand cannot
escape, unchanged.

---

## 4 · One generativity primitive, one phase-capability shape

07 uses the invariant-lifetime brand trick three separate times, each with its own spelling:

- `'f` — the frame arena brand (§2.1, `Frame<'f>`);
- `'m` — the display-map snapshot brand (§15.4, `with_snapshot(|map: DisplayMapRef<'m>|`,
  `DisplayPos<'m>`);
- the sealed phase tokens — `LayoutCx<'_>`, `GeometryCx<'_>`, `Paint<'f>`, `Hit`, `A11y`
  (§2.3, §15.2), which are scoped capabilities with the same no-escape requirement.

Three hand-rolled instances means three soundness arguments, three `trybuild` corpora, and three
chances for one of them to be subtly weaker (nothing currently states whether a `DisplayPos<'m>`
may outlive its *frame* rather than its snapshot, or how `Paint<'f>` relates to `'f`).

**Consolidation.** One kernel primitive:

```rust,ignore
pub struct Scope<'id, K: ScopeKind>(PhantomData<(fn(&'id ()) -> &'id (), K)>);
```

with sealed kinds `FrameK`, `SnapshotK`, and one `PhaseK` per phase. `Frame<'f>` =
`Scope<'f, FrameK>`; `DisplayMapRef<'m>` carries `Scope<'m, SnapshotK>`; the phase contexts
become `Cx<'s, Layout>`, `Cx<'s, Geometry>`, `Cx<'s, Paint>` — one generic type whose
per-phase methods live in `impl Cx<'s, Layout> { ... }` blocks. This is *fewer* public types
(one `Cx` instead of five structs), one invariance proof, one escape-fixture corpus
(parameterized by kind), and one documented nesting law: a snapshot scope opens inside a phase
scope opens inside a frame scope, and a branded value is dead when its own scope closes —
stated once, true everywhere. §10's warning against typestate sprawl is answered rather than
risked: this is the same number of proofs with strictly less machinery.

---

## 5 · Receiver resolution for bare fn-item routes is unspecified

§6 says "the receiver selects the owner," and every route in the document is a bare fn item:
`Workspace::escape`, `Pane::split`, `Workspace::open_suggestion`. A fn item carries no instance.
So *which* `Workspace` runs when `on_key(Key::Escape, Workspace::escape)` fires? 07 never says.
The question is not pedantic:

- Two nested owners of the same type (an editor embedding an editor — §15.4's minimap is
  exactly this) make "the enclosing Workspace" ambiguous.
- `Output<E>` (§6.2) is constructed in plain Rust (`Typeahead::new(Workspace::open_suggestion)`)
  — at construction time there is no tree, no describing owner, no ambient anything (§16.5
  deliberately removed ambient context). "Parks before mount, arms against the concrete mount
  route" names the *when* but not the *against-what*.

**Consolidation.** State the resolution law once, in §6, for every route-accepting verb:

> A bare fn-item route resolves its receiver at **mount**, against the mounting description's
> owner chain: the nearest enclosing owner whose type matches the route's receiver. No match is
> a located mount error. Nested same-type owners resolve to the nearest; delivering to anything
> that is not an ancestor of the mount site requires an explicit handle
> (`entity.route(Workspace::method)` / `remote.send(...)`), never search.

This is deterministic, checkable at mount (the same moment `Output::required` already errors),
inspector-attributable, and makes the minimap case well-defined by construction. It also gives
`#[reactive]`'s "lexical action sites" (§5) a precise meaning: identity = mount site + resolved
receiver generation.

---

## 6 · Structural identity needs a stated reconciliation law

07 defines identity for lists (`Slot<T>`), addressable parts (`Target<K>`), and names a third
kind — "retained node identity: internal identity of an embedding site" (§11) — without ever
saying how that internal identity is *assigned or matched across turns*. But an entire stratum
of the design keys off it: conditional producer descriptors own "private cells" at "surrounding
mount identity" (§7); action cells live "at the button's mount identity" (§7.8); animation
tracks, focus defaults, phase memos, and boundary cohorts are all retained per node. So the
unanswered question is the oldest one in retained UI: when `if cond { a() } else { b() }` flips,
or a sibling appears ahead of a subtree, which retained cells survive?

07's own architecture makes the *right* answer unusually cheap, and it should say so as a law:

> **Application state never lives in the tree.** Owner fields, signals, lists, and entities are
> identity-free with respect to description (this is why there are no hooks). Tape identity is
> **parent identity × child ordinal × node kind**. A turn that changes the kind at an ordinal —
> or shifts ordinals by inserting an unkeyed sibling — *mount-cycles* everything at and below
> that position: producer cells are revoked (their in-flight completions die by §7.5 stamps),
> tracks and memos drop, focus falls back by §11.2. Keyed survival across reordering is what
> `List<T>` is for; there is no other keying mechanism, by design.

Stating this closes real holes: it defines what a branch flip does to a §7.8 pending action
(revoked — the save's completion routes are dead, which is exactly why `.queue(Reliable)`
exists); it defines whether swapping `match` arms replays enter animations (yes — motion state
is presentation, and §4.2's structural snapshots cover the exit); and it makes the cost model
honest — the inspector should attribute mount-cycling churn, because an author who interleaves
an unkeyed conditional sibling above a hot subtree deserves to see the price. Without the law,
every one of those behaviors is an implementation accident the gates cannot pin.

---

## 7 · The cohort machine is normative but unwritten

Gate 8b requires async behavior to "match **the reference state machine**." No such artifact
exists. The cohort/boundary semantics — 07's genuinely novel contribution — are currently
distributed as prose across §7.2 (first readiness), §7.4 (candidate cohorts, `is_pending`,
`latest`), §7.5 (admission stamps), §7.6 (the six-row outcome table), and §13 (the turn
pipeline). Prose in five sections cannot be fuzzed against.

Two entanglement questions the prose does not decide:

1. A `project` region reads a cohort-held reader **and** an unrelated live source. The live
   source publishes. Does the region rerun with (old retained story, new feed value) and
   republish, or hold entirely? §7.4 says "unrelated sources and regions continue to commit" and
   §13 says regions "retain their settled owned operands" — both, ambiguously, cover this case.
2. Two overlapping cohorts (write A then unrelated write B) whose read sets share one region:
   supersession is defined per-input ("a newer write touching the *same* input supersedes"), but
   nothing defines join/serialization for cohorts entangled only through a shared consumer.

**Consolidation.** Write `runtime/cohort.md`: the per-node record
(`Empty | Ready(prev) | Pending(request) | Fault`) × the cohort record × an explicit transition
table, including the entanglement rule (proposed: a region rewrites whenever any input
publishes, always reading each input's *presentation-selected* operand — retained for
cohort-held inputs, current for live ones; cohort join is defined as read-set union with the
newer policy generation winning). Point gate 8b and the inspector's cohort view at that file.
Until it exists, the most sophisticated part of 07 is unfalsifiable.

---

## 8 · State the Reader ownership law

`Reader<T>` is `Copy` (§7) and owns nothing; producers are owned by "the owner construction"
or "surrounding mount identity." Both true statements, but their composition is never stated,
and it is the kind of law users hit in week one:

- A `Reader<T>` copied into a component that outlives the producer's owner now names a dead
  node. What does a sink bound to it present? (Proposed: a distinct `Fault(Revoked)` — never
  pending-forever, never last-value-forever — with inspector attribution to the dead owner.)
- `let story = selected_id.try_map_async(fetch_story);` — in a constructor this registers a
  producer against the constructing owner; the *same line* inside `view` must instead become a
  mount-site descriptor (§7 says so obliquely). The scope-determines-ownership rule should be
  one boxed law: **a producer belongs to the scope that created it — owner construction → owner
  lifetime; description → mount identity (finding 6); nothing else can create one.** The Copy
  reader is a capability onto it, valid exactly while that scope's generation lives.

Also worth deciding here: whether an *owned* producer handle (`Derived<T>`, `!Copy`, drop =
revoke) is worth a noun for imperative/service code, or whether owner-scoped lifetime covers
every real case. Recommend the latter until a fixture demands otherwise — but record the
decision; today the doc is silent.

---

## 9 · Publication truth is the slab compare — say it once

Three places imply three different equality regimes: §4.2/§6.4 put an equality gate "in the
wire" for derived observation; §2.1 has the commit diff compare operands slot-by-slot; §4's
`DerefMut` publish has no stated gate at all. The un-stated composite invites real questions:
does `*self.count += 0` dirty ports? Does `if let Some(x) = &mut *self.flag { ... }` (a
read-only reborrow through `DerefMut`) publish?

**Consolidation.** One invariant, stated in §4 and referenced everywhere:

> **Publication is a hint; the compare at the destination is the truth.** A `DerefMut` guard
> publishes on drop, unconditionally and cheaply. Every retained destination — property slab,
> region operand, `on_change` wire — compares the incoming operand against its retained one and
> no-ops on equality. Spurious publication therefore costs one key enqueue plus one compare,
> never a rerun, a repaint, or an observer fire.

This makes §6.4's "equality gate lives in the wire" a corollary rather than a special mechanism,
defines the `DerefMut`-reborrow case (publishes; the slab compare absorbs it), and turns "when
does my handler fire" from folklore into one sentence. It also gives the fix-it for
non-`PartialEq` payloads a home: destinations that cannot compare declare always-propagate, and
the inspector shows which edges are compare-gated.

---

## 10 · One handler-outcome table (and one flow type)

§6.1 has `fn escape(&mut self, event: KeyEvent) -> KeyEvent` with `event.consume()` /
`event.propagate()`; §6.3 says command handlers return "normal `EventFlow`/`Result`". Two
spellings of the same concept — returning the event *as* the flow value versus a dedicated flow
type — and the interpretation of `()`, `Option<T>`, `Result<T, E>`, and `R` is scattered across
§6.1, §6.2, §7.8, and §8 ("R is interpreted by the registration that asked for it" is exactly
the kind of ambient meaning 07 deletes elsewhere).

**Consolidation.** Pick the event-valued spelling (it is self-documenting and prevents
consuming a *different* event than was delivered — a small linearity proof `EventFlow` cannot
give), delete `EventFlow` from §6.3, and add the one normative table to §6:

| Declared return | Meaning at delivery |
|---|---|
| `()` | handled; input events consume |
| the event type | explicit `consume()`/`propagate()` decision |
| `Option<E>` | `Some` fires the site's output route; `None` is silence |
| `Result<T, E>` | routed intact unless the site split it with `.then`/`.catch` |
| any other `R` | only legal where the registration's `Route<_, R>` names it |

Every route-accepting verb links here. Nothing else may assign meaning to a return type.

---

## 11 · `List<T>`'s key story is inconsistent

§4.1/§11 define `List<T>` with kernel-generational `Slot<T>` as the *only* identity ("`Slot<T>`
is identity, never an index"; "there is no per-element string id, derived id enum, or universal
key"). §15.4 then writes `List<Excerpt, ExcerptId>` — a second type parameter smuggling in
exactly the domain-key mechanism §11 forbids. One of these is wrong, and the answer matters
beyond editors: any collaborative or persisted collection needs a durable key (§11.1's whole
point is that runtime and durable identity must not alias).

**Consolidation.** Keep `List<T>` single-parameter and slot-keyed — and make the durable-key
need go through §11.1's existing three-layer story instead of a type parameter: an `ExcerptId`
is a *domain value stored in `T`* (or in a slot-indexed side table), and the alias table that
maps durable ids to live slots is the same mechanism §11.1 already requires for collaboration.
Fix §15.4's spelling to `List<Excerpt>` + anchored excerpt identity inside `Excerpt`. If a
fixture later proves a first-class keyed list earns its existence, that is a deliberate
storage-ladder extension — not a notation slip in an editor section.

Two adjacent under-specifications to close in the same pass:

- **Row view signature.** `children(&self.rows, Row::view)` — does a row view receive its
  `Slot<T>`? It must (a row that renders a slot-relative `Target` or binds a slot-carrying
  route needs it), so the accepted shapes should be stated: `fn(&T) -> Element<'_>` and
  `fn(&T, Slot<T>) -> Element<'_>`.
- **Arrangement identity.** §11's `filtered`/`sorted`/grouped views "live on list references" —
  state that arrangements are read projections that *preserve slots* (same `Slot<T>` vocabulary,
  no separate arrangement identity), so selection and edit sessions survive re-sorting by
  construction.

---

## 12 · `Effects<Self>` is a one-off — make focus claims a queued verb

§11.2 introduces `fn closed_palette(&mut self, effects: &mut Effects<Self>)` — the only
appearance of `Effects` in the entire surface, a new handler parameter type invented for one
feature. But 07 already has a universal law for this exact shape: *verbs on typed handles are
queued and never run synchronously* (`entity.send`, `win.activate`, `target.focus()` in §8).
Focus claiming should be the same vocabulary:

```rust,ignore
fn closed_palette(&mut self) {
    self.editor_target.claim_focus();   // queued; applied after the target's generation commits
}
```

Same after-commit ordering, same coalescing-by-scope, same park/deadline/typed-miss semantics —
§11.2 keeps every behavioral sentence and loses its bespoke parameter type. If a general
after-commit hook is ever needed beyond focus, that is the moment to design `Effects`; today it
is speculative surface with one caller.

---

## 13 · State the component-boundary law, and admit methods-as-views

§2 establishes that a function returning `Element<'_>` is a view. §11 establishes stateful
components as structs whose inputs are constructor wires. The gap between them is the most
common question a newcomer will ask: *how does a stateful child receive per-frame data from its
parent?* `View::view(&self)` takes nothing; constructor inputs are fixed at construction. 07
never answers, and the answer has two halves worth stating as one law:

1. **Methods are views.** `fn view_with(&self, results: &[Hit]) -> Element<'_>` on a stateful
   component composes exactly like any view function — `View::view` is merely the canonical
   zero-argument case that roots and containers call. This costs nothing and should be an
   explicit, documented pattern (it is currently only derivable).
2. **The wire boundary is the scheduling boundary.** A child invoked with borrowed arguments
   schedules at its parent's grain — the kernel cannot rerun it independently, because the
   arguments cannot be re-borrowed without the parent. Independent child scheduling requires
   every input to be storage-ladder-shaped (`Signal`, `Reader`, `List`, `Entity`). This is the
   real meaning of promotion (§1's ladder) at component boundaries, and it is the honest answer
   to "why must this prop become a signal": not for change *detection* but for change
   *delivery without the parent*.

Stated this way, the ladder's promotion story and the component story become one story, and the
inspector's "why did this parent rerun" answer has a documented vocabulary.

---

## 14 · Const subtree templates: approach D falls out for free

§3 already makes layout recipes `const` (`const TOOLBAR: Flex = ...`). Push one step further and
the compiled-UI approach (approaches/D) collapses into the ladder at zero API cost: a subtree
whose operands are all constants is, in principle, a **const-evaluable opcode template** — the
sealed tape bytes computable at compile time. Description of such a subtree becomes one `memcpy`
of a `static` template plus patches at the recorded live-operand offsets; the commit diff sees
byte-identical ranges and skips them wholesale.

This needs no macro, no new user-facing type, and no semantic change — only that builder
methods on recipes and static element constructors be `const fn` where operands permit, plus a
kernel template format with a patch table. It is purely an optimization tier, so the honest
framing is a note in §14 and a benchmark, not a promise: if the measured win on real chrome
(toolbars, menus, gutters — exactly the subtrees that never change) is large, GPUI gets
approach D's headline benefit inside approach-ladder semantics; if not, nothing was spent on
API. Either way the design should claim the *possibility* now, because it constrains the tape
format (stable operand offsets) cheaply today and expensively later.

---

## 15 · Diagnostics are surface — gate the no-macro path's error messages

Gate 4 holds the *macro* to an editor-experience bar and deletes it on failure. The no-macro
path — the normative surface! — has no equivalent bar, yet it leans on exactly the Rust
features that produce the worst default diagnostics: sealed traits (`IntoProperty`, `Source`,
routes), invariant lifetimes (the `'f` brand), and GAT-bearing bounds. The predictable failure
mode: a user passes `Signal<T>` by value where `&Signal<T>` was meant and receives a
three-screen trait-resolution error mentioning `sealed::Sealed`, or leaks an `Element<'f>` and
gets a raw "lifetime may not live long enough" with no mention of frames.

**Consolidation.** Treat diagnostics as part of the sealed surface:

- every sealed trait ships `#[diagnostic::on_unimplemented]` copy written in 07's vocabulary
  ("a property takes a *feed*: pass `&self.count`, not `self.count`") and
  `#[diagnostic::do_not_recommend]` on blanket impls that would otherwise dominate suggestions;
- brand-escape errors get the same care via a doc-aliased `Frame`/`Scope` naming so the
  compiler's message names the concept the book teaches;
- a `trybuild` corpus asserts the *message text* of the top-twenty predictable mistakes (wrong
  layout-family method, escaped element, by-value signal, `*reader`, captured `&self` in a
  retained projection, mismatched route receiver…), promoted to a numbered stabilization gate
  alongside gate 4. Gate 5 already does this for one case (`Flex`/`Grid`); generalize it.

The design's bet is that ordinary Rust plus good types can beat a DSL — that bet is won or lost
in error messages, and 07 currently gates only the macro's.

---

## 16 · The document architecture is itself leaky

07 opens with a supremacy clause — "when their spelling disagrees with this file, this file
wins" — and then absorbs window chrome, HDR color, IME, clipboard, text raster policy, and
temporal shading (§15.2.1–§16) into 2,500 lines. The clause was right when 07 was the one
corrective surface; at this size it has three concrete costs:

- **Unfalsifiable references.** Gate 8b binds to "the reference state machine" (does not
  exist — finding 7); the cohort semantics normativity lives in prose.
- **Stale satellites.** `gap-register.md` still cites "07 §8" for windows and lists as open
  several gaps §16 now answers (vibrancy/Mica → §16.1, software renderer → §16.2, IME → §16.4,
  displays readiness → §16.6, inherited `Enabled` → §16.5, RTL layout → §16.5). Nothing forces
  the register to track the file that wins. (Also: `00-research/` contains two files numbered
  10.)
- **Merge hazard.** Every future edit to color or presence semantics must edit the constitution.

**Consolidation.** Split 07 into a constitution and statutes: 07 keeps §0–§14 — the vocabulary,
the laws (including the new ones from findings 5, 6, 8, 9, 13), the gates — at perhaps 1,200
lines; §15.4 (editor kernel), §15.5 (presence), §15.2.1 (temporal shading), and §16 (platform)
move to owned normative satellites (`runtime/editor-kernel.md`, `runtime/presence.md`, already-
existing `runtime/color.md`, …). Replace the supremacy clause with a **conformance index**: a
table in 07 naming each satellite, its owned vocabulary, and the 07 sections it must agree
with — so disagreement is a listed break, not a silent precedence rule. Refresh or delete the
gap register against that index.

---

## 17 · Smaller nits, recorded so they don't recur

- **§4 precision:** `text(&self.count)` for `Signal<i32>` claims patching "without calling
  application Rust" — the port necessarily runs a monomorphized `Display` formatter. The true
  claim is "no application *rerun*, no allocation beyond the formatted operand"; say that, or
  the first profiler screenshot contradicts the doc.
- **§9 naming collision:** the flagship example `self.project.send(Project::rename)` uses a
  field named `project` in a design whose central combinator is `project`. Rename the example
  entity (`self.workspace_project`) or the collision will haunt every tutorial.
- **§6.3:** `Command<A>` has a string id but, unlike `ItemKind` (§9.2), no version. Keymaps and
  extensions serialize `A`; the day `Axis` gains a field, the protocol has no migration story.
  Give `Command::new` the same `Version` the item catalog already requires.
- **§7.1:** the closure-capture contracts are scattered — `project` regions are
  `for<'f> Fn(&T) -> Element<'f> + 'static` (stated), but `map`/`map_ref`/phase closures'
  capture rules (fn-item only? `'static` captures? owner reborrow?) are implied per example.
  One table in §7.1 covering every closure-accepting position.
- **§15.3:** "container queries" appears once, undefined, as the answer to layout-dependent
  structure. Either specify the mechanism (it interacts with finding 6's identity law and the
  §2.3 feedback lane) or strike the phrase and leave the next-epoch measurement signal as the
  single stated answer.

---

## Decision list

| # | Decision | Effect on 07 |
|---|---|---|
| 1 | Name sealed `Source`/`SeqSource` algebra; define all twelve verbs over it | rewrites §4/§6.4/§7.4 definitions as instances; adds §4 algebra table |
| 2 | Delete `if_` | §7.4 example respelled with `.map` |
| 3 | Owned spillover on `Element<'static>`; `Frame` goes kernel-internal | §2.1 wart paragraph deleted; boundary fallbacks take fn items |
| 4 | One `Scope<'id, K>` brand primitive; phases become `Cx<'s, P>` | §2.1/§2.3/§15.2/§15.4 unify; one escape corpus |
| 5 | Route receiver resolution law (nearest typed ancestor at mount; explicit handle otherwise) | new boxed law in §6 |
| 6 | Reconciliation law: parent × ordinal × kind; List is the only keying | new boxed law in §11; inspector churn attribution |
| 7 | Write `runtime/cohort.md` state machine incl. entanglement rule | gate 8b gains a real referent |
| 8 | Reader/producer ownership law; `Fault(Revoked)` presentation | new boxed law in §7 |
| 9 | "Publication is a hint; destination compare is truth" | one invariant in §4; §6.4 gate becomes corollary |
| 10 | Event-valued flow only; handler-outcome table | §6.3 `EventFlow` deleted; table added to §6 |
| 11 | `List<T>` single-param; durable keys via §11.1 aliasing; row-view signatures | §15.4 spelling fixed; §11 additions |
| 12 | `target.claim_focus()` queued verb; delete `Effects<Self>` | §11.2 respelled |
| 13 | Methods-as-views + wire-boundary scheduling law | new §11 subsection |
| 14 | Const opcode templates as optimization tier | note in §14 + tape-format constraint |
| 15 | Diagnostics gate for the no-macro surface | new numbered gate beside gate 4 |
| 16 | Constitution/statutes split; conformance index replaces supremacy clause | 07 restructure; gap register refresh |
