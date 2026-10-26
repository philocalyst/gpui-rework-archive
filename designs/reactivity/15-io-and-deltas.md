# 15 — Inputs, Outputs, and Typed Deltas: the Wiring Surface Disappears

Status: fifth pass, superseding 14 §3.3/§4's `Wired` trait after one pass of life — which is what
the passes are for. The trigger is a correct observation: `Wired` fixed *where* relationships were
registered (not the constructor, not fields), but it still put a component's dataflow in a third
place, separate from the component's own boundary. This pass deletes the third place. A
component's inputs and outputs are its **parameters**; reactions are **children**; and the change
itself becomes a **typed value** — a derived delta in the mold of
[structdiff](https://github.com/knickish/structdiff) — so a handler can decide on *when* and
*how* something changed with ordinary Rust.

The result is one declarative surface (the view), one diff law, one macro (optional, doing more),
and a no-macro floor that is the same algebra everything else already uses.

---

## 1 · Outputs are parameters

### 1.1 Function components: an output is just a route argument

A function component never needed `Output<E>` at all. Its "output" is a route it forwards inward —
so it is a **parameter**, and requiredness is checked by the compiler, not the mount:

```rust,ignore
fn search_bar<'a>(query: &'a Signal<String>, submitted: impl Route<Submitted>) -> El<'a> {
    row((
        text_input(query),
        button("Go").on_click(submitted),      // plain forwarding — zero machinery
    ))
    .gap(8)
}

// call site — inputs and outputs, literally the parameter list:
search_bar(&self.query, Inbox::search_submitted)
```

Forgetting the output is a missing-argument compile error. An *optional* output is an `Option`
parameter (or simply a second function). No endpoint, no binding step, no registration anywhere.

### 1.2 Struct components: the endpoint stays, the binding moves to the embed

A stateful component's handlers decide *when* to emit, so it keeps the data-free `Output<E>`
endpoint field (serde-clean per 14 §4) and calls `self.sent.emit(…)`. What moves is the binding:
it is a parameter of the **embed**, in the view, where the component appears:

```rust,ignore
// the embed fn is the component's public signature — inputs and outputs, one line:
pub fn composer<'a>(state: &'a Composer, sent: impl Route<OutgoingMail>) -> El<'a> {
    state.view().child(when(&state.sent, sent))     // §1.3: binding IS a when-edge
}

composer(&self.composer, Inbox::mail_sent)          // required output: a positional parameter
```

Requiredness upgrades from a located mount error to a **missing-argument compile error**. The
kernel diffs embed-declared bindings under the same park/arm/teardown law as everything else —
07 §6.2's original objection to view-site `.on(…)` (lifecycle hidden in presentation) was
answered the moment wiring became a diffed declaration; there is no longer a reason to exile the
binding from the place the component is used. Constructors take no routes; `Wires::output` is
gone; the component's dataflow reads off its signature.

Service entities that are never mounted (a `PresenceSession`) keep the constructor-parameter
form (`PresenceSession::connect(transport, route)`) — which is now not an exception but the
same rule: *outputs are parameters of whatever brings the thing into being* — the embed for
mounted components, the constructor for services.

### 1.3 Outputs are sources — `when` is the only binding mechanism

The embed body above gives the game away, and it should be stated as the law rather than left as
an implementation: **`Output<E>` implements `Source<Value = E>`.** Emitting publishes; binding an
output *is* declaring a `when` edge over it. Three consequences close everything that was still
open:

- The required-parameter embed is not new machinery — it is compile-time-mandatory *packaging*
  of one `when` child. There is exactly one binding mechanism in the system.
- **Optional outputs need no builder method on a finished `El`** (a mechanic 15's first draft
  left unspecified and an implementation flagged). The endpoint is `pub`; the host binds it as a
  plain reaction child, exactly like any other edge:

  ```rust,ignore
  when(&self.composer.discarded, Inbox::composer_discarded),   // optional output = a when child
  ```

  Required = parameter of the embed (compiler-enforced); optional = `when` wherever the host
  likes (silently unbound if absent). One rule, no chaining mystery, no named-slot machinery.
- Multiple listeners, conditional listeners, and listeners in other components fall out: an
  output is a source, and sources already compose.

### 1.4 The `when` edge kind is selected by the route's payload type

`when(source, route)` admits several source kinds; the route's declared parameter disambiguates,
checked at the call:

| Route signature | Edge |
|---|---|
| `fn(&mut R)` | any-change, no payload |
| `fn(&mut R, Changed<'_, T>)` | entity-grain with delta access (§3) |
| `fn(&mut R, U)` over `source.map(f) -> U` | derived, equality-gated, value delivered |
| `fn(&mut R, E)` over `&Output<E>` | output binding, event delivered |

A mismatch is a compile error at the `when` call — the same function-item inference every route
verb already uses (07 §6).

---

## 2 · Reactions are children

### 2.1 `when(source, route)` — an edge is a zero-paint element

`Wired::wires` was a second declarative surface with its own diff story. But the system already
has a declarative, diffed, conditional, composable, mount-identified surface: **the view**. An
observation edge becomes a child that paints nothing:

```rust,ignore
fn view(&self) -> El<'_> {
    column((
        // ── reactions: edges as children, diffed with the tree ──────────────────────────
        when(&self.store, Inbox::on_store),                            // entity-grain, delta payload
        when(self.store.unread.map(badge_level), Inbox::on_unread),    // derived, equality-gated
        (!*self.muted).then(|| when(&self.alerts, Inbox::on_alert)),   // conditional edge = Option child
        // ── presentation ────────────────────────────────────────────────────────────────
        …
    ))
}
```

Everything the `Wired` trait needed bespoke rules for is inherited free:

- **Conditional edges are `Option` children** — `bool::then`, the identical machinery as a
  conditional dialog. No "wires are re-evaluated when their reads change" special case: the view
  already is.
- **Edge bundles are helpers** — `fn store_reactions(&self) -> El<'_>` returns a group of
  `when(…)` children; loops produce edges per row; a `project` region can swap edge sets with
  structure. Composition is element composition.
- **Mount identity, teardown, receiver resolution** (11 §5/§6) apply verbatim, because an edge
  *is* a mount.
- **Legibility** is a convention, not a mechanism: reactions first, or extracted into a named
  helper — the wiring diagram is still one visible block, now in the one place a reader already
  looks.

`when` is a verb over `impl Source` (11 §1), so the whole algebra applies: entities, signals,
derived wires, tuples. The constructor-line verbs (`on_change`, `on`) and the `Wired`/`Wires`
machinery are deleted; `when` is the one spelling.

### 2.2 Purity is preserved

A `when` child *declares* an edge; the handler still runs in an ordinary turn. This is exactly
the status of `on_key` today — the view has always declared routes; it has never run them.

---

## 3 · Deltas: the structdiff influence

### 3.1 The change is a typed value

[structdiff](https://github.com/knickish/structdiff) derives, per struct, a typed description of
*what changed between two instances* — field-level entries, recursion into nested types,
collection diffs — via a `Difference` derive. That is precisely the vocabulary "fire on when
**and how** things change" needs, and GPUI is in a better position than structdiff itself to
supply the values: **structdiff must compare two instances in O(fields); the reactive substrate
already knows.** Signals publish, `List<T>` emits splice/edit/move, and the commit diff compares
retained operands anyway (11 §9's invariant — "the compare at the destination is the truth").
The delta is *assembled from the publication log*, not computed by walking.

```rust,ignore
#[derive(Delta, Serialize, Deserialize)]     // a DATA derive, serde-precedent — not a UI macro
struct MailStore {
    unread: Signal<u32>,
    account: Signal<String>,
    labels: List<Label>,
}
// generates (structdiff-shaped):
// struct MailStoreDelta {
//     unread:  Option<Change<u32>>,        // Change { old, new } — old kept for Clone fields
//     account: Option<Change<String>>,
//     labels:  Option<ListDelta<Label>>,   // splice/edit/move — richer than an array diff
// }
```

An entity-grain `when` delivers `Changed<'_, MailStore>`: `Deref` to the new committed state,
plus `.delta() -> &MailStoreDelta`. And now "how it changed" is not a predicate DSL — it is
**guard-the-function (07 §6.1) applied to change**, ordinary Rust over an ordinary value:

```rust,ignore
fn on_store(&mut self, store: Changed<'_, MailStore>) {
    match store.delta() {
        MailStoreDelta { unread: Some(c), .. } if c.new > c.old => self.chime(),
        MailStoreDelta { labels: Some(d), .. } if d.removed_any() => self.rebuild_filters(),
        _ => {}
    }
}
```

Field granularity comes from the instrumented containers; plain fields fall back to the commit
compare (changed/unchanged, with `Change` values where the field is `Clone + PartialEq`). The
gate-2 argument is the serde one: `#[derive(Delta)]` derives a data shape and knows nothing of
UI semantics — and because a delta *is* plain data, it composes outward for free: a delta can be
serialized (sync protocols, presence lanes), journaled (incremental checkpoints), or converted
to/from structdiff's own representation where the ecosystems meet.

### 3.2 The layering, precisely

| Question | Answer | Mechanism |
|---|---|---|
| *when* (that something changed) | the edge fires | `when(source, route)` — publication log |
| *when* (that a value changed) | equality gate in the wire | `when(src.map(f), route)` — 07 §6.4, unchanged |
| *how* (which fields, old→new, list ops) | handler matches the delta | `Changed<T>` / `T::Delta` — this pass |

Nothing overlaps: the wire decides *whether to call*; the delta lets the handler decide *what to
do*. The equality-gated derived wire remains the right tool when only one projection matters;
the delta form replaces the pile of parallel derived wires a rich observer would otherwise need.

---

## 4 · The macro does more; the floor stays elegant

`#[reactive]`'s charter (07 §5) — cut visible reads into exact edges, lower to public surface —
extends naturally, and the no-macro floor remains fully capable:

- **With the macro:** a `when` whose closure reads several sources gets an exact fused edge list;
  reaction groups interleaved with structure lower to the same retained regions as visual
  branches; delta matches inside `#[reactive] fn view` bodies get lexical site identity like
  action sites. Same law as ever: removing the attribute changes scheduling counters, never
  meaning (gate 3 unamended).
- **Without the macro:** `when` + the source algebra + delta pattern-matching is the whole
  model. Tuples fuse inputs; `map` derives; `Option` children gate; `match` on `T::Delta`
  expresses arbitrarily rich "how" logic. There is no capability behind the attribute — only
  compression.

---

## 5 · What this deletes and what it demands

**Deleted:** the `Wired` trait, `Wires<T>`, `w.on`/`w.change`/`w.output` (14 §3.3–§4, one pass
old); constructor-line `on_change`/`on` verbs; route arguments in component *constructors*
(moved to embeds); the notion of a separate "wiring surface" at all.

**Kept from 14:** the field law (data, sources, data-free endpoints), `Output<E>`/`Target<K>`
serializing like `PhantomData`, mount-diffed lifecycle, requiredness-as-error — upgraded to
compile-time where the output is a parameter.

**New gates:**
1. `when` edges diff with the tree: the mute fixture (edge fires → `Option` child removes it →
   re-arms and delivers current value once) asserted through the *view*, no wiring API in sight.
2. A required output missing at an embed is a compile error (`trybuild`); an optional one
   defaults silently.
3. Delta assembly is O(publications), never O(fields): a 10k-field... realistically, a large
   struct with one signal publish produces one delta entry and zero compares beyond the
   destination's own (11 §9).
4. `#[derive(Delta)]` output is public, readable, and round-trips serde; gate 2's macro census
   still counts exactly one UI-semantics macro.

---

## 6 · Decision list

| # | Decision | Supersedes |
|---|---|---|
| 1 | Function-component outputs are route **parameters**; requiredness is a compile error | 14 §4 binding |
| 2 | Struct-component outputs: data-free endpoint field; `Output<E>: Source<Value = E>` and binding = a `when` edge — packaged as a required **embed parameter**, or a plain host-side `when` child for optional outputs (§1.3) | `Wires::output` |
| 2b | `when`'s edge kind is selected by the route's payload type, compile-checked (§1.4) | — |
| 3 | Services bind routes in constructors — same rule: outputs are parameters of whatever creates the thing | 14's "deliberate exception" (now just the rule) |
| 4 | `when(source, route)` — edges are zero-paint children, diffed with the tree; conditional = `Option` child; bundles = helpers | `Wired`/`Wires`, constructor `on_change`/`on` |
| 5 | `#[derive(Delta)]` (data derive, structdiff-shaped, runtime-assembled); `Changed<T>` payload; "how" = guard-the-function over `T::Delta` | ad-hoc parallel derived wires for rich observers |
| 6 | Macro compresses reactions like it compresses views; floor is `when` + algebra + `match` | — |
