# 17 — The Function-Shaped Component: Outputs Are Return Types

Status: seventh pass, revising 16 (which stands except where named) and completing the arc. The
triggering critiques were four, and they share one root:

1. *"There's an `Output<>` marker but not an `Input<>` — that's implicit. This basically creates
   a DAG."* — Correct, and the asymmetry is real.
2. *"There's an `unread()` method but it's not declared anywhere."* — Correct; generated
   accessor methods are magic.
3. *"How do you mutate the tree based on changes?"* — The doc never stated the law.
4. *"I imagined you could encode outputs into return types."* — This is the answer to all four.

The root: the design was still inventing declaration syntax for dataflow when **Rust already has
one — the function signature.** Parameters are inputs. Return types are outputs. A component is
a function-shaped node in the DAG, and the DAG is spelled entirely in signatures:

```text
view:     &self                    -> El<'_>          // presentation out
handler:  &mut self + event/site   -> Out             // domain value out
changed:  &mut self + Changed<Self> -> Out            // reaction out
```

There is no `Input<T>` marker because parameters and source-fields already *are* the input
declaration. And there is no longer an `Output<E>` field because return types already *are* the
output declaration. The asymmetry is resolved by deletion, not by adding the missing twin.

---

## 1 · `Out` is folded into the trait — the stable-Rust trick

The "type = thing" fold, on the one trait, using a **generic parameter with a default** (stable
today, unlike associated-type defaults):

```rust,ignore
trait View<Out = ()> {
    fn view(&self) -> El<'_>;
    fn changed(&mut self, delta: Changed<'_, Self>) -> impl Emit<Out> { }
}
```

- A simple view writes `impl View for Settings` — `Out = ()`, `changed` defaulted, exactly as
  before. Zero ceremony at the floor.
- A component that reports upward names its output type once: `impl View<ComposerOut> for
  Composer`. **Multiple outputs are an enum** — Rust's native sum type, not N endpoint fields:

  ```rust,ignore
  enum ComposerOut { Sent(OutgoingMail), Discarded }
  ```

- `impl Emit<Out>` admits `()`, `Out`, `Option<Out>`, and iterators — a handler emits by
  *returning*, and enum constructors being fn items keeps every spelling first-class.

`Output<E>`, `Output::new()`, `.emit(…)`, endpoint serialization, and the embed-body "binding
verb" NOTE all delete. The composer's handlers become their own documentation:

```rust,ignore
impl Composer {
    fn send(&mut self) -> Option<ComposerOut> {
        if self.to.is_empty() {
            self.first_field.claim_focus();
            return None;                       // not valid yet — nothing leaves
        }
        Some(ComposerOut::Sent(self.outgoing()))
    }
    fn discard(&mut self) -> ComposerOut {
        self.body.clear();
        ComposerOut::Discarded
    }
}
```

## 2 · Catching: one route parameter, one level, no bubbling

Where does a returned `Out` go? To the **catcher the mount declared** — and mounting a
`V: View<Out>` with `Out ≠ ()` *requires* one, generically:

```rust,ignore
// the embed shrinks to nothing but the signature — there is no body trick left to need:
pub fn composer<'a>(state: &'a Composer, out: impl Route<ComposerOut>) -> El<'a> {
    state.view_with(out)                       // kernel routes Out returns to `out`
}

// host side: ONE required parameter per component, however many outputs it has:
dialog(composer(&self.composer, Inbox::on_composer))

fn on_composer(&mut self, out: ComposerOut) -> Option<InboxOut> {
    match out {
        ComposerOut::Sent(mail) => { self.send(mail); None }
        ComposerOut::Discarded  => { *self.composing = false; self.search_box.claim_focus(); None }
    }
}
```

Three deliberate properties:

- **Requiredness is total and compile-checked.** Not per-output: per-*component*. The old
  required/optional split dissolves into enum variants the host's `match` may ignore — Rust's
  exhaustiveness becomes the "did you handle everything" check, opt-out per arm, visible in code.
- **No bubbling.** An output routes exactly one level, to its declared catcher. A catcher
  forwards upward the same way anything emits: by returning (`-> Option<InboxOut>`). "Props down
  one level, events up one level" — every hop explicit, every hop typed, which is what makes the
  pattern composable instead of spooky. (This is also why 15's typed-catcher-search idea does
  not appear: nearest-match-by-type through a tree is ambient behavior, and this design deletes
  ambient behavior on sight.)
- **Uncaught is unrepresentable**, not inspector-attributed: with `Out` in the trait and the
  catcher in the mount bound, there is no way to mount an emitting component silently.

## 3 · Entities: state is the only broadcast

Return-routing is single-consumer — a child reports to the parent that mounted it. Entities are
the *multi*-consumer case, and the law completes 16's deletion of `Emitter`:

> **Components report via returns; entities communicate via state.** There is no third thing.
> An entity "event" that several observers care about is a state transition, observed through
> the delta (`d.project.root` — old *and* new are right there). Something that is genuinely a
> multi-cast stream of occurrences is a protocol, and `Remote<T>`/services already own that
> lane (07 §7.8) — it was never a UI observation.

This retires 16's `.fired()` iterators along with the endpoint fields that fed them. The delta
becomes purely *how state changed*; values-in-flight are purely *routed returns*. Two directions,
two mechanisms, no overlap: **deltas flow down into `changed`; returns flow up through
catchers.** That is the DAG, stated as a sentence.

## 4 · The delta is honest data, and lazy

Fixing the "undeclared `unread()`" magic and pinning the performance model:

- **Generated fields, not methods.** `#[derive(Delta)]` on `MailStore` generates a plain,
  documented, greppable struct — access is field syntax, and nothing is callable that isn't
  visible in the (rustdoc'd, `cargo expand`-stable) generated type:

  ```rust,ignore
  pub struct MailStoreDelta {
      pub unread:  Option<Change<u32>>,       // d.store.unread — a field, not a method
      pub account: Option<Change<String>>,
      pub health:  Option<Change<SyncHealth>>,
  }
  ```

- **`Changed<'_, Self>` is a lazy view over the turn's publication log**, not a materialized
  struct: field access consults the log; an untouched path costs nothing; nothing allocates.
  Assembly is O(publications this turn), never O(fields) — the structdiff *shape* without the
  structdiff *walk*.

## 5 · Fine-grained control and the performance floor

The high-perf story, stated as guarantees rather than vibes:

1. **Presentation-rate data never routes through `changed`.** Property ports, motion lanes,
   `List` slot deltas, and text pipelines patch their destinations directly (07 §14's law,
   untouched by every pass since). `changed` is an *application-effect* surface; nothing on the
   frame path waits for it.
2. **Invocation is edge-narrowed by the macro, coarse-but-cheap without it** (gate-3 symmetry,
   16 §2): no macro → invoked when any field-source of *this component* publishes, and the lazy
   delta makes the no-op pass a few branch tests; `#[reactive]` → the handler's visible delta
   reads become exact invocation edges. Counters differ; behavior cannot.
3. **Grain is component grain, and you control it by decomposition** — the same knob views have
   always had. A component with one frantic field and one calm reaction splits into two
   components (or promotes the frantic field's consumers to direct ports), exactly as a hot
   view splits. No second granularity system exists to tune.
4. **Emission routing is a queued method call** — the same FIFO delivery as `send`, no
   subscription table, no dynamic dispatch beyond the one monomorphized route the mount stored.

## 6 · "Mutating the tree" — the law that was missing

`changed` never mutates the tree, because nothing does: **the tree is a projection of state**
(07 §2, still the constitution). The missing guidance is the discipline, stated once:

> **Derive, don't react.** If a change should alter what is *shown*, that is a derivation — it
> belongs in `view` (a branch over state, a property port, a `project` region) and the tree
> updates because `view` is a function of state. `changed` is for effects that *leave* the
> component: I/O, focus claims, sounds, commands to entities, emissions upward. Writing state in
> `changed` that `view` could have derived is the smell the inspector attributes (the classic
> "you might not need an effect"), and the loop-detection law (16 §2) already polices its
> pathological form.

So "how do you mutate the tree based on changes" has a two-word answer — *you don't* — and a
practical one: put the change in the state the tree derives from, from a handler; the diff does
the rest.

## 7 · TEA becomes definitionally close

With `Out` in the trait and emission-by-return, the Elm reading is no longer an analogy:
`View<Out>` *is* a `Model` with `Msg = Out`; a catcher *is* a parent's `update` arm; and a
userland TEA layer is one funnel method away (16 §4's posture, now with the types doing the
work). The foundation still refuses the architecture — `Out = ()` components and per-concern
methods are equally first-class — but the ratatui test now passes with room to spare: the
framework owns *no* reaction vocabulary beyond one trait, one delta, and the Rust function
signature.

## 8 · Decision list

| # | Decision | Supersedes |
|---|---|---|
| 1 | Inputs are parameters/fields; outputs are return types; no `Input<T>` marker, `Output<E>` fields deleted with `.emit` | 14 §4 endpoints; 16 §3's optional-output delta reads |
| 2 | `trait View<Out = ()>` (generic-param default — stable Rust); multi-output = enum `Out`; `impl Emit<Out>` admits `()`/`Out`/`Option`/iterators | separate emit machinery; 16's `type = thing` gap |
| 3 | One catcher parameter per emitting component, compile-required; forwarding = returning; no bubbling, no ambient search | 15 §1.3 packaging; the embed "binding verb" NOTE |
| 4 | Components report via returns; entities communicate via state (delta) or protocols (`Remote`); `.fired()` retired | 16 §1's emission-in-delta |
| 5 | `#[derive(Delta)]` generates public *fields* (`Option<Change<T>>`), documented and greppable; `Changed` is a lazy view over the publication log | 16's accessor methods |
| 6 | Perf floor pinned: frame path bypasses `changed`; macro narrows invocation; grain = component decomposition; emission = one queued monomorphic call | — |
| 7 | "Derive, don't react" stated as law; tree mutation is state mutation + projection | — |
