# 16 — `changed`: the Component Reacts to Itself

Status: sixth pass, superseding 15 §2's `when(…)` children (and revising 15 §1.3's optional-output
binding) days after writing them — the passes exist to converge, and this is the convergence. The
triggering critique was exact on both counts: `when` children mix effects into presentation, and
`when` itself is a word the user shouldn't have to say. Both dissolve under one observation that
has been sitting in this design since pass 13:

> **A component's observable world is already its fields.** Fields are sources (13 §5.1) — that
> was the law. So a component never needed to *subscribe* to anything; the subscription set is
> the field set, and the only thing left to deliver is *what changed*. Which is exactly the typed
> delta pass 15 already built.

The reaction surface is therefore one provided method on the one trait:

```rust,ignore
trait View {
    fn view(&self) -> El<'_>;
    fn changed(&mut self, delta: Changed<'_, Self>) {}   // provided: inert by default
}
```

`view` describes what the component *looks like*; `changed` describes what it *does about
change*. Presentation and effects are contained in sibling methods of one trait — folded in, not
a second trait, not a wiring surface, not children. `when` is deleted. There is nothing to make
implicit, because there is no longer an explicit thing.

---

## 1 · How it reads

```rust,ignore
impl View for Inbox {
    fn view(&self) -> El<'_> { /* 100% presentation again — no when children */ }

    fn changed(&mut self, d: Changed<'_, Inbox>) {
        // The delta mirrors the struct. Independent concerns are independent ifs —
        // not one match forced over unrelated fields.
        if let Some(c) = d.store.unread() {
            if c.new > c.old && !*self.muted {          // "how" AND the conditional edge,
                self.chime();                            // both ordinary Rust — no Option child
            }
            if badge_level(c.new) != badge_level(c.old) { // the equality gate, inline:
                self.set_dock_badge(badge_level(c.new));  // old/new subsumes derived wires
            }
        }
        if let Some(c) = d.store.health() {
            if let SyncHealth::Failed { detail } = c.new {
                self.announce(Polite, detail.clone());
            }
        }
        for _ in d.composer.discarded.fired() {          // child emissions ride the same delta
            *self.composing = false;
            self.search_box.claim_focus();
        }
    }
}
```

Every mechanism the previous two passes maintained separately is now a line of ordinary Rust:

| Was (14/15) | Now |
|---|---|
| `w.on(&entity, route)` / `when(&entity, route)` | `if let Some(c) = d.entity.field()` |
| derived equality-gated wire (`when(src.map(f), route)`) | `if f(c.new) != f(c.old)` — old/new inline |
| conditional edge (`Option` child / `if` in `wires`) | an `if` in the handler body |
| optional output binding (`when(&child.out, route)`) | `for e in d.child.out.fired()` |
| `Emitter { type Event }` + `entity.on(route)` | **deleted** — events are `Output<E>` endpoints on the emitting struct, observed like any field |
| edge bundles, helpers, loops | functions, called from `changed` |

The `Emitter` trait dies because it was the last "type = Event" declaration living outside the
struct: an entity that raises events declares `Output<E>` endpoint fields like any component, and
observers read `.fired()` from the delta. Inputs and outputs are now *entirely* structural — the
component's reactive signature is literally its field list plus its parameters.

## 2 · The semantics, precisely

- **Invocation.** `changed` is a handler — the kernel invokes it post-publish with the turn's
  composed delta, at most once per turn, FIFO with other queued deliveries, never reentrantly.
  07's law stands verbatim: an effect only ever runs from a handler; this is the handler.
- **The delta is the turn's publication log, typed.** Assembled O(publications) as in 15 §3;
  recursion follows fields — `d.store.unread()` reaches through `Entity<MailStore>` into
  `MailStore`'s own delta. A field whose type has no `#[derive(Delta)]` degrades gracefully to a
  changed/unchanged marker with `Deref` to the new value; the derive adds `old`/`new` and
  per-field detail. Emissions (`Output<E>`) appear as `.fired()` — an iterator over this turn's
  events in order, because events are occurrences, not states.
- **Writes from `changed` are ordinary turn writes**: they publish, schedule the next round, and
  a `changed` that re-dirties what it reads is a loop the inspector attributes (same standing as
  a recursive `on_change` before it — no new hazard, one fewer place to have it).
- **Scheduling is the gate-3 symmetry, extended from views to reactions.** With no macro,
  `changed` is invoked whenever *any* field-source publishes — coarse, cheap (a no-op pass over
  `None`s), and semantically exact. With `#[reactive]`, the statically visible delta accesses
  (`d.store.unread()`, `d.composer.discarded`) are cut into exact invocation edges, so `changed`
  runs only when a read path published. **Removing the attribute changes scheduling counters,
  never behavior** — the same theorem the view already lives under, now covering effects. This is
  what "make `when` implicit" turns out to mean: the edge list is the *read pattern of the
  handler*, discovered the same way the view's is.

## 3 · What remains from 15, sharpened

- **Required outputs stay parameters** (15 §1) — compile-checked at the embed/constructor,
  routed directly, never via a delta (a required back-edge is a contract, not an observation).
  *Optional* outputs lose their `when` child and become delta reads — strictly less machinery.
- **`#[derive(Delta)]`** is unchanged (data derive, structdiff-shaped, publication-assembled) and
  more load-bearing: it is now the entire observation vocabulary. The graceful-degradation tier
  (no derive → any-change marker) keeps it opt-in.
- **The field law completes.** 13: fields are sources. 14: relationships never live in fields.
  16: relationships never live *anywhere* — inputs are fields and parameters, outputs are
  endpoint fields and parameters, behavior is two methods. There is no registration in the
  system, in any spelling, at all.

## 4 · Elm is a library choice — the ratatui posture

The foundation is deliberately unopinionated the way ratatui is: it ships mechanism (fields,
delta, two methods, routes-as-fn-items) and no architecture. But the mechanisms compose into TEA
in userland with nothing added:

```rust,ignore
enum Msg { Compose, Send, Discard, StoreChanged(MailStoreDelta) }

impl View for Inbox {
    fn view(&self) -> El<'_> {
        // routes are fn items; enum constructors ARE fn items — precompose them:
        column((button("New").on_click(Inbox::update.via(|| Msg::Compose)), …))
    }
    fn changed(&mut self, d: Changed<'_, Self>) {
        if let Some(delta) = d.store.take() { self.update(Msg::StoreChanged(delta)); }
    }
}

impl Inbox {
    fn update(&mut self, msg: Msg) { match msg { … } }   // the one Elm reducer, by choice
}
```

One funnel method, every event a `Msg`, exhaustive match — Elm, built from routes and `changed`
without a framework blessing. Equally, the default style (a method per concern) is just Rust.
The foundation refuses to pick; both are three lines from the primitives. That is the ratatui
test, and this pass is what makes it passable: with `Wired`/`when`/`Emitter` gone, there is no
framework-owned reaction vocabulary left for an architecture to conflict with.

## 5 · Gates

1. **Containment:** no reaction construct appears in any `view` body in the corpus; `changed`
   bodies contain no element construction. (Grep-able, and the point of the pass.)
2. **Gate-3 for reactions:** removing `#[reactive]` from a component with `changed` alters
   invocation counters only — pixel, state, focus, event-order, and emission-order equivalence
   asserted on the inbox fixture.
3. **Delta completeness:** every publication kind (signal write, list splice/edit/move, entity
   recursion, output emission, plain-field commit compare) is representable and observed in one
   `changed` body in the corpus.
4. **Loop attribution:** a `changed` that re-dirties its own read set is surfaced by the
   inspector with the cycle path within two turns.
5. **TEA fixture:** the §4 pattern implemented in an example with zero framework additions.

## 6 · Decision list

| # | Decision | Supersedes |
|---|---|---|
| 1 | `View::changed(&mut self, Changed<'_, Self>)` — provided, inert default; the one reaction surface | 15 §2 `when` children; 14 §3.3 `Wired`; constructor verbs |
| 2 | Subscription set = field set; edge precision = the handler's read pattern (macro-narrowed, gate-3 symmetric) | explicit edge declaration in any form |
| 3 | `Emitter`/`type Event` deleted; events are `Output<E>` endpoints on the emitter, observed via `.fired()` | 07 §6.4's emitter trait |
| 4 | Required outputs remain compile-checked parameters; optional outputs are delta reads | 15 §1.3's host-side `when` |
| 5 | Conditionals, guards, equality gates, and derivations are handler-body Rust over `old`/`new` | `Option`-child edges, derived wires for effects |
| 6 | TEA and other architectures are userland patterns over routes + `changed` (ratatui posture) | — |
