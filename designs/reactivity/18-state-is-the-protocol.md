# 18 — State Is the Protocol

Status: eighth pass. 17's function-shaped model was correct about *inputs* (parameters and
fields — kept verbatim) and correct about deltas (field syntax, lazy log-view, derive-don't-
react, the perf floor — all kept). But its output half reinvented Elm: `Out` is a `Msg` enum, a
catcher is an `update` arm, and forwarding-by-returning is TEA's message-wrapping — the exact
boilerplate Elm users complain about, arriving here wearing Rust syntax. The critique "more
GPUI-native, with better guarantees" has a precise answer, because GPUI's native substrate has
something Elm never had:

> **GPUI journals, logs, stamps, and diffs *state*. So make state the only protocol.**
> An occurrence is a state transition. A payload is the transition's value. A child "reporting"
> to a parent is a parent observing a field it already owns. The machinery Elm builds out of
> messages — delivery, ordering, wrapping, replay — GPUI already provides for state, with
> guarantees messages cannot have.

This deletes outputs for the third and final time — not moved, not renamed: **gone**. There is
no `Output<E>`, no `Out` type parameter, no catcher, no embed, no `.emit`, no `.fired()`. The
trait returns to its floor form and stays there:

```rust,ignore
trait View {
    fn view(&self) -> El<'_>;
    fn changed(&mut self, delta: Changed<'_, Self>) {}
}
```

---

## 1 · A component's API is its state machine

What Composer was "emitting" was always a lifecycle. Say so, in the type:

```rust,ignore
#[derive(Clone, PartialEq, Serialize, Deserialize)]
enum Stage {
    Editing,
    Sent(OutgoingMail),     // the payload rides the transition
    Discarded,
}

#[derive(Delta, Serialize, Deserialize)]
pub struct Composer {
    to: Signal<String>,
    subject: Signal<String>,
    body: Signal<String>,
    stage: Signal<Stage>,
    pub first_field: Target<TextInput>,
}

impl Composer {
    fn send(&mut self) {
        if self.to.is_empty() { self.first_field.claim_focus(); return; }
        *self.stage = Stage::Sent(self.outgoing());
    }
    fn discard(&mut self) { *self.stage = Stage::Discarded; }
}
```

The parent holds the child as a plain field — **the embed function dies; `&self.composer` is a
child again** — and reacts in `changed`, where the recursive delta already reaches:

```rust,ignore
fn changed(&mut self, d: Changed<'_, Inbox>) {
    if let Some(c) = &d.composer.stage {
        match &c.new {                                  // exhaustive: the compiler owns coverage
            Stage::Sent(mail) => self.deliver(mail.clone()),
            Stage::Discarded  => { *self.composing = false; self.search_box.claim_focus(); }
            Stage::Editing    => {}
        }
    }
}
```

No `Msg`. No wrapping. No forwarding chain: a *grandparent* that cares reads
`d.workspace.inbox.composer.stage` — **recursive deltas compose through nesting automatically**,
which is precisely what TEA's message plumbing never did. Sibling communication is the parent
taking and republishing into its own state — one explicit hop, visible in `changed`.

## 2 · `Handoff<T>`: occurrences with better guarantees than any event

One honest objection survives §1: some occurrences are consume-once values, not resting states —
who resets `Stage::Sent` after the parent delivers it? GPUI already owns the answer in
`Take<T>`'s linear-move semantics (07 §11). Promote it to a first-class source:

```rust,ignore
pub struct Composer {
    …
    sent: Handoff<OutgoingMail>,      // a linear cell: give once, take once
}

fn send(&mut self) { … self.sent.give(self.outgoing()); }

// parent, in changed:
if let Some(mail) = d.composer.sent.take() {
    self.deliver(mail);               // taking IS the acknowledgement
}
```

`Handoff<T>` is *state* — a source like any other — which is what buys the guarantees Elm-style
messages structurally cannot offer:

1. **Durable in flight.** A handoff is journaled (13 §1) like every source. Give, crash,
   restore: the value is still there to take. No event bus on any platform gives you
   crash-surviving delivery of UI intents; here it falls out of serde.
2. **Untaken is diagnosed, never silent.** A handoff still full at turn-end is a located
   inspector report naming giver and non-taker — versus Elm's `_ => {}`, which is you silencing
   yourself. (A component that wants *compile-time* guaranteed consumption may still demand an
   `impl Route<T>` constructor parameter — the mechanism remains legal; it is no longer the
   idiom.)
3. **Ordering and coalescing come from the publication log.** Two gives in one turn: `take()`
   drains FIFO (`take` in a loop, or `drain()`); a coalescing handoff (`Handoff<T, Latest>`)
   keeps only the newest — declared policy, not accident, the same vocabulary as `Remote`'s
   lanes (07 §16.6).
4. **Stamps apply.** A handoff filled by superseded/revoked async work is rejected by the same
   §7.5 admission every publication passes through. Elm has no notion of a stale message.

## 3 · The output type is the Delta — declared never, derived always

17 asked "can outputs be encoded in types?" and answered with a hand-written enum. The native
answer is stronger: **a component's output type is its `Delta`, generated from its struct.**
`ComposerDelta` — with `stage: Option<Change<Stage>>` and `sent: Option<Given<OutgoingMail>>` —
*is* the complete, typed, documented description of everything this component can tell the
world, and nobody wrote it. The component's turn "returns" its delta; the parent's `changed`
pattern-matches that return. Inputs are parameters and fields; outputs are the diff of the
fields. The DAG is fully spelled by struct definitions and one derive.

## 4 · Scorecard against the traditional patterns

| | Observer/subscription | Elm/TEA | **18: state is the protocol** |
|---|---|---|---|
| declare an observable | trait + registration | Msg variant + update arm + wiring | a field |
| deliver a payload | callback invocation | message dispatch | state transition (journaled, stamped) |
| deep consumer | re-subscribe at each level | wrap/unwrap messages per level | recursive delta path, free |
| unhandled occurrence | silent | `_ => {}` you wrote | located diagnostic (untaken handoff) |
| crash mid-delivery | lost | lost | restored from the journal |
| replay/inspect | ad hoc logging | ad hoc | the publication log *is* the record |
| coverage checking | none | exhaustive match on Msg | exhaustive match on the transition enum |
| granularity control | per-subscription | per-message | macro-narrowed delta reads (gate-3) |

## 5 · What this pass deletes and finalizes

**Deleted:** `Output<E>` and `.emit` (14 §4's endpoints, 16 §3's `.fired()`), 17's
`View<Out = ()>` parameter, `impl Emit<Out>`, catcher parameters, embed functions
(`composer(…)`, `typeahead(…)`), and the constructor-route on services — `PresenceSession::
connect(transport)` takes no route; the workspace holds the entity and takes
`d.presence.applied` like any other handoff. **Zero exceptions remain**: nothing in the system
registers, subscribes, catches, or emits.

**Final surface** — the whole reactive model, enumerable on one hand:
- a **struct** of state: data, sources, `Handoff<T>` cells, `Target<K>` (the field law, closed);
- **`view`** — presentation as a projection;
- **`changed`** — effects over the typed diff of the struct;
- **methods** — commands, routed from input events by fn item;
- **`#[derive(Delta)]`** + optional **`#[reactive]`** — vocabulary and precision, never meaning.

TEA remains buildable in userland (a `Stage`-style enum plus one funnel method is nearly TEA
already), but the foundation no longer resembles it: there is no message type anywhere in the
framework, and the thing that replaced it — journaled, stamped, log-backed state — is the part
of GPUI that Elm's runtime never had.

## 6 · Gates

1. **Zero-vocabulary grep:** `Output<`, `.emit(`, `.fired(`, `impl View<`, `when(`, `Wired`
   appear nowhere in the corpus; no embed functions remain; struct-view children are plain
   fields.
2. **Handoff linearity:** give-then-take round-trips; double-take is `None`; an untaken handoff
   at turn-end produces the located diagnostic; `Latest` policy coalesces; FIFO policy drains in
   order.
3. **Durability:** give → journal checkpoint → restore → take succeeds with the value (the
   crash-safe delivery fixture — the one no event system can pass).
4. **Depth:** a grandparent consumes a grandchild transition through the recursive delta with no
   intermediate code in the middle component.
5. **Gate-3 for reactions**, unchanged from 16: macro presence alters invocation counters only.

## 7 · Decision list

| # | Decision | Supersedes |
|---|---|---|
| 1 | Child→parent is state observation over the recursive delta; lifecycle enums carry payloads | 17 §1–2 (`Out`, catchers), 16 §3, 15 §1, 14 §4, 07 §6.2 |
| 2 | `Handoff<T>` — linear give/take source with declared FIFO/Latest policy; durable, stamped, diagnosed when untaken | `Output<E>` in every prior form |
| 3 | The output type is the generated `Delta`; never hand-declared | 17's hand-written `Out` enums |
| 4 | Embeds deleted; struct components are plain field children again; services take no constructor routes | 15 §1.2, 17 §2 |
| 5 | Trait finalized: `View { view, changed }` — no generics, no associated I/O types | 17 §1 |
| 6 | Kept from 17: delta field syntax, lazy log-view, derive-don't-react, the perf floor, entities-are-state (now universal) | — |
