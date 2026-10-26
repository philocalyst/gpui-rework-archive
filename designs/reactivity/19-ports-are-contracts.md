# 19 — Ports Are Contracts: the Sealed Algebra and the Platform Bar

Status: ninth pass, incorporating the 2026 Rust GUI survey audit (the P0/P1/P2 decision table)
into the design as it stands after [18-state-is-the-protocol.md](18-state-is-the-protocol.md).
The survey's own "concrete API shape" — `Signal<String>`, `Reader<Vec<ResultRow>>`,
`Handoff<ResultId>`, `Target<TextInput>`, `#[derive(Delta)]`, `changed(&mut self, Changed<'_,
Self>)` — is pass 18's surface verbatim. That is external validation of the arc, and it changes
what this pass is for: not another revision of the model, but the pass that makes the model
**contractual**. Three things were still promises: the algebra was designed (11 §1) but never
ratified; invalidation precision was an implementation intention with no schema; and the survey's
strongest finding — that custom-rendered toolkits routinely ship text editing and accessibility
as examples rather than controls — described this design's own biggest open liability.

The organizing idea, stated once:

> **A port is a contract, not a parameter.** Every place a value, a sequence, a medium, or a
> piece of work enters the retained world is a sealed socket with (a) a closed family of
> accepted plugs, (b) one cost per plug form, (c) a declared semantic impact, and (d) a declared
> direction. Nothing enters any other way, and nothing that enters is unknowable.

---

## 0 · What the survey validated, and what it still demands

Validated by convergent evolution (no change required, recorded so it stays decided):

- **Mount-owned identity, never hook-slot identity.** `Slot`, `Target`, retained mounts,
  generational staleness (07 §11, 11 §6). Dioxus/Freya/Windows-Reactor call-order hooks stay
  rejected.
- **State is the protocol.** Child→parent is delta observation; occurrences are `Handoff<T>`;
  no output machinery (18). The survey's API sketch kept a `picked: Handoff<ResultId>` field and
  a `changed` that drains it — exactly pass 18's idiom.
- **No public `Task`, no global message enum, no subscriptions bus, no `cx`** (07 §7, §18).
- **Typed IPC only at true ABI boundaries** (07 §9.2 catalog, plugin protocols): Crux/CXX-Qt/
  Rinf/tauri-specta validate schema-generated contracts *for foreign shells* — and validate
  keeping them out of local component updates. Law, restated: **a metaobject or wire schema may
  exist only where a linker or process boundary already exists.**
- **Static subtree compilation stays internal** (11 §14 const templates): the optional
  macro/tooling lowers to the same `El`/port schema as handwritten Rust. Slint/Makepad/Pax prove
  the tooling value; GPUI does not ship a second UI language to get it.

Demanded, and delivered by this pass:

| Survey priority | This pass |
|---|---|
| P0 · name and seal one Source/Property algebra, with a collection counterpart | §1, §2 |
| P0 · child composition as a sealed sequence contract | §2 |
| P0 · explicit per-port semantic invalidation schema | §3 |
| P0 · text editing + AccessKit as hard release gates | §4 |
| P1 · finite work vs mount-owned streams, made exact | §5 |
| P1 · typed media adapters for ordinary Rust values | §6 |
| P1 · "derived state is a circuit; effects synchronize externally" as a lintable law | §7 |

---

## 1 · The value algebra, ratified and directional

11 §1 designed the sealed `Source` trait and observed that twelve verbs were each redefining
"a place a value comes from." This pass ratifies it as normative and adds the one axis the
survey's Slint evidence shows was missing: **direction lives in the algebra, not in the widget.**

```rust,ignore
// kernel-owned, all sealed; application code implements none of these
pub trait Source: sealed {          // "can be read reactively"
    type Value;
    type Ready<'a>: Copy;           // &'a T for scalars; slot views for sequences
    // internal: raw key(s), verdict (Ready/Pending/Fault), stamp, equality hook, impact
}
pub trait Sink: sealed {            // "can be written through the turn machinery"
    type Value;
}
pub trait Cell: Source + Sink {}    // both — Signal<T> is the canonical instance
```

- **Instances.** `Signal<T>` is a `Cell`. `Reader<T>`, derived projections, `is_pending(_)`,
  `latest(_)`, committed window properties (`win.active`), theme tokens, and `Entity<T>`
  (any-change, `Value = ()`) are `Source`-only. `Handoff<T>` is a `Source` whose ready view is
  linear (§18). Constants are the degenerate always-ready source. Tuples implement `Source` by
  product — readiness is the meet, the stamp is the tuple of stamps — so the mixed
  signal/reader tuple is *defined*, not special-cased. A named struct of sources implements one
  sealed `SourceSet` by hand: five explicit lines, no derive, no arity cliff.
- **Every verb is defined once, over the algebra.** `project`, `map`/`map_async`, prop sinks,
  `animate`, `reload_on`, `.with` sampling, boundary children, delta observation — one
  definition each, over `impl Source`. The per-verb "what does this accept" prose in 07 deletes;
  the conformance matrix (gate A1) replaces it.
- **Direction is checked where the widget is typed.** A two-way control demands `impl Cell`:

  ```rust,ignore
  fn text_input<'a>(text: &'a Signal<String>) -> El<'a>;   // wants a Cell — read AND write
  fn label<'a>(text: impl IntoProp<'a, SharedString>) -> El<'a>;  // wants any Source

  text_input(&self.query)          // ✓ Signal is a Cell
  text_input(&self.derived_name)   // ✗ Reader<String> is not a Sink — located error:
                                   //   "a two-way port needs a place to write; bind a
                                   //    Signal<String>, or use label(...) to display"
  ```

  This is Slint's explicit one-way/two-way binding distinction carried into the type system
  instead of a property attribute: you cannot accidentally hand a read-only derivation to an
  editing control, and you never annotate direction — the port's bound states it.

### 1.1 The sealed conversion protocol: `IntoProp<T>` closes the plug family

The survey's phrasing is exact: *"a generic property sink accepts static and live values
through a sealed conversion protocol; there is no public `Fn() -> T` fallback whose allocation,
dependency tracking, and phase are unknowable."* The closed family, normative:

```text
IntoProp<T> ⊇  T | &T                    constant; promoted only when the diff finds it changed
             | &Signal<T>                direct two-way-capable port; publication patches slab
             | Reader<T>                 latency-aware port; verdicts route to boundaries
             | impl Source<Value = T>    any algebra composition (map, is_pending, tuples…)
             | Motion<T>                 sampled on a timeline lane (07 §4.2)
             | semantic token            cascade-resolved feed (07 §16.5)
             | Option<any of the above>  only where the port declares one meaning for absence
```

Three laws ride the family:

1. **Closures never enter a port.** The only closure-accepting positions in the whole surface
   are `map`/`map_async`/`project`/phase closures, where the dependency set is the explicit
   left-hand source and the phase is named. A bare `.opacity(|| …)` does not exist and never
   will; `source.map(f)` is its spelling, with knowable deps, equality gate, and cost.
2. **`Option` is admitted only where absence has exactly one meaning.** A port where `None`
   could mean either *clear* or *inherit* takes a two-variant enum instead (07 §15.1's rule,
   now enforced at the family definition, not per-setter review).
3. **One cost per plug form, every port.** A constant costs a diff compare; a signal costs a
   direct slab patch; a reader costs a verdict check plus a slab patch; a token costs a cascade
   edge. The same form never costs differently at different ports — that is what makes the
   family teachable — and gate A1 measures it as descriptor identity, not intention.

### 1.2 The collection counterpart: `SeqSource`

`SeqSource` is the sequence half of the same algebra, with deltas instead of values as its
change protocol:

- `List<T>` is the canonical instance: slot-keyed, splice/edit/move deltas, arrangements
  (`filtered`/`sorted`/grouped) as slot-preserving read projections (11 §11).
- `&Vec<T>` is the degenerate realign instance — same verb, coarser delta ("everything moved").
- `list.each(f)` / `list.each_with(f, ctx)` produce the wired row projection (14 §2).

Promotion (`Vec → List`) changes the delta grain and nothing else — the trait fact behind the
storage-ladder promise 07 §1 made in prose.

---

## 2 · Children are a sealed sequence contract

07 §2 demonstrated that tuples, `Option`, iterators, and unlike branches compose without
erasure; 14 §2 unified the spelling. The survey asks for the remaining step — make it a *sealed
contract* with a coherence law, so the property is architectural rather than an emergent
kindness. Xilem's `ViewSequence` is the precedent: sequence shapes are types, and each shape
knows its own diff.

```rust,ignore
pub trait ChildSeq<'f>: sealed {
    // internal: arity class, shape-delta protocol, tape-splice lowering
}
```

The closed family and its coherence classes:

| Form | Arity class | Shape delta | Tape lowering |
|---|---|---|---|
| `El<'f>` / `impl Element` | exactly 1 | none | in-place diff |
| `(A, B, …)` tuple of ChildSeqs | fixed | none | per-position diff |
| `Option<impl ChildSeq>` | 0 or 1 | insert/remove | splice at position |
| `impl Iterator<Item: ChildSeq>` | dynamic | ordinal realign | windowed splice |
| `&Vec<T: View>` | dynamic | ordinal realign | windowed splice |
| `&List<T: View>` / `list.each(f)` | dynamic | slot deltas | per-slot splice/edit/move |

The coherence law, boxed because the gates depend on it:

> **A sequence form owns its shape delta.** The kernel never re-derives structure by comparing
> rendered children; it applies the delta class the form declares. Ordinal forms mount-cycle on
> reorder (11 §6 — the price of not keying); slot forms preserve identity across any
> permutation; fixed forms cannot change shape at all, so their positions never cycle. Nesting
> composes deltas positionally: a tuple of Options of iterators is exactly as precise as its
> parts.

Erasure exists in exactly one place: the open-world boundary. A plugin or catalog item crosses
as `AnyEntity` behind a versioned protocol (07 §9.2). Application code has no `AnyElement`, no
box-to-branch, no macro-to-compose — and now that is a *sealed-trait fact* a `trybuild` gate can
pin, not a style rule a reviewer enforces.

---

## 3 · Every port declares its impact — the Masonry kernel with zero user surface

Masonry's contribution is an exact invalidation taxonomy: passes are named, and a mutation
declares which passes it dirties. The survey is right that this is the correct kernel precedent
— and right that users must never see it. The resolution is to attach the taxonomy to the one
place this design already funnels every mutation: **the port descriptor.**

```rust,ignore
bitflags! {                        // kernel-internal; never public API
    struct Impact: u8 {
        const LOGICAL;             // retained logical tree / semantics-bearing structure
        const LAYOUT;              // box sizes and positions must be recomputed
        const PLACEMENT;           // transform/offset only — layout untouched
        const PAINT;               // display-list bytes for this node
        const HIT;                 // hit-test geometry
        const A11Y;                // accessibility projection
    }
}
```

- **Every sealed port carries a `const IMPACT`.** `.bg(...)` is `PAINT`. `.gap(...)` is
  `LAYOUT | PAINT`. `.translate_y(...)` is `PLACEMENT | HIT`. `.opacity(...)` is composite-lane
  only. Text content is `LAYOUT | PAINT | A11Y`. A structural splice is `LOGICAL | LAYOUT |
  PAINT | HIT | A11Y`. The constant is fixed when the port seals, so the flags cost nothing at
  runtime: a publication's impact is a bitwise-or over the log, and the epoch runs exactly the
  union's passes (the scheduler's phase list in [runtime/scheduler.md](runtime/scheduler.md)
  gains this as its admission input).
- **Custom surfaces declare impact in their phase obligations.** An `editor_surface` phase
  closure's outputs are typed obligations (07 §2.3); each obligation kind carries its impact.
  A custom port with no declared impact does not seal — the mistake is unrepresentable, not
  reviewed.
- **Motion lanes pre-classify.** 07 §4.2's kind-segregated lanes (paint, transform/opacity,
  placement, layout, shader, structural) *are* impact classes; this section is the naming of
  the scheme they already obeyed.
- **User code never invalidates, in either direction.** No `request_paint()`, and also no
  ability to *suppress* — an author cannot claim a text edit is paint-only. Precision is the
  framework's obligation; gate A3 holds it to counters (a `bg` publication on a laid-out tree
  must run zero layout, zero a11y, zero hit work).

The quiet payoff is diagnostic: the inspector can now answer *"why did layout run this frame?"*
with a port name and a source, because the impact union is an attributed log, not an emergent
consequence of dirty bits scattered through the tree.

---

## 4 · The platform bar: text and access are release gates, not examples

The survey's QR scenario failed more custom-rendered toolkits on IME and accessibility than on
anything reactive. This design's honest position until now: an IME *protocol* (07 §16.4), a
text *contract* (09), and no standard control obligated to use them. That is precisely the
"700-line example" failure mode with better documents. This section closes it.

### 4.1 `text_input(&Signal<String>)` is a standard control, and two-way means two-way

```rust,ignore
text_input(&self.query)                       // controlled: the signal is the document of record
    .placeholder("Search…")
    .target(self.input)                       // Target<TextInput>: focus, selection, tests
    .on_edit(Search::filter_input)            // optional interceptor — see the law below
```

The binding law:

> **The signal is the document of record, and an edit is one transaction in the same turn
> machinery as every other write.** A keystroke, paste, drop, or IME commit stages an edit
> against the signal's current value, runs the interceptor *inside* that turn, publishes once,
> and every consumer — the input's own presentation, a filtered list, the a11y projection —
> observes the same committed value in the same epoch. There is no event-then-writeback round
> trip, no frame where the box shows text the signal doesn't hold, and no second "trigger
> reactivity" step for `on_edit` to forget.

`on_edit` is an interceptor, not a change listener: `fn(&mut Self, Edit<'_>) -> EditVerdict`
where the verdict is `Accept`, `Amend(replacement)`, or `Reject`. It sees the typed edit
(range, inserted text, source: keyboard/IME/paste/a11y), may consult `&mut self`, and decides —
validation, masking, auto-formatting — all before publication. Reject leaves signal, box, and
history untouched, coherently. What it cannot do is *observe the new value and then write the
signal*, because it runs before there is a published new value; the failure mode the survey
found in the wild (controlled inputs that lag or fight their model) is unspellable.

**IME is a sub-transaction.** Composition/preedit lives in the input's private presentation
state; the signal sees only commits. The full 07 §16.4 protocol — surrounding-text revision,
UTF-8/UTF-16 ranges, replacement range, candidate rectangle, preedit styling — is driven by the
standard control, not left as capability documentation. Ordering closes the Vizia failure by
construction: **focus loss first settles the composition (commit or cancel per platform
convention) as its own transaction, then delivers focus-out** — so blur can never drop composed
text, and the a11y node for the input derives from the same committed epoch as paint, so a
stale semantic value cannot outlive a frame. History groups a composition as one undoable
transaction (08's grouping law).

Selection, caret affinity, grapheme motion, word/paragraph motion, bidi caret placement,
kill-ring/emacs bindings on macOS, and platform text shortcuts ship in the control. The
existing ~780-line `example_input.rs` becomes a *conformance narrative* for people building
custom text surfaces, not the way applications get an input.

### 4.2 Accessibility is a committed-epoch artifact, not a paint byproduct

Because the retained tree, its properties, and its impact-tagged publication log are the
committed epoch, the AccessKit projection is a *pure function of that epoch* — which yields the
survey's hardest gate almost for free:

> **Activation completeness.** When assistive technology connects, the full initial AccessKit
> tree is produced from the current committed epoch with no describe turn, no repaint, and no
> application code. A window that has been idle for an hour answers immediately and completely.

- **Every standard element has default semantics.** `text` is a label; `button` is a button
  with its action; `text_input` implements the AccessKit text-editing contract (value, selection,
  ranges, edits round-tripped through the same transaction law as §4.1 — an a11y-initiated edit
  is just another edit source). List/tree/grid protocols project from the 06 projections.
- **A11Y-impact publications patch the projection incrementally** — the same delta discipline as
  paint, so screen-reader updates are exact, not tree rebuilds.
- **Custom surfaces implement the a11y phase or say why not.** The phase-capability surface
  (07 §15.2) includes `A11y`; a retained node that opts out is an inspector-visible hole, not
  silence. Canvas/a11y callbacks remain the escape hatch the survey allows — an escape hatch
  with a diagnostic, not a default.

### 4.3 Reaching a mounted capability stays typed — including for tests

`Target<K>` remains the only ordinary way application code reaches a mounted part. The survey's
nod to Iced's `Operation` is adopted where it belongs: the **inspector/test tier** gets a typed
capability visitor (walk committed nodes, query semantic role/text/bounds, drive the a11y
action surface) — which is exactly what `Win<V>`'s semantic test queries (07 §12) already are,
now specified as the same visitor the a11y bridge uses. No string query API exists at the
application tier, and none is needed at the test tier either: tests address parts by `Target`,
role, and semantic text, the same vocabulary assistive technology uses.

### 4.4 The bar, as gates

Numbered as release gates T1–T6 (§9); the framework does not stabilize while any fails:

1. **T1 — activation:** AccessKit connection on an idle, never-repainted window yields a
   complete, correct initial tree; incremental updates thereafter are delta-exact.
2. **T2 — IME completeness:** preedit, commit, surrounding-text deletion, UTF-8/UTF-16 range
   agreement, selection sync, candidate rect tracking, focus-loss settlement, cancellation,
   and single-transaction undo grouping pass on every supported backend, exercised through
   `text_input`, in CI, with a scripted IME.
3. **T3 — controlled coherence:** no reachable interleaving of edits, async work, focus
   changes, and a11y edits leaves the box, the signal, history, or the a11y node disagreeing;
   blur never loses text (the Vizia fixture, fuzzed).
4. **T4 — media directness:** every §6 plug form reaches pixels with no user-written encode,
   data URL, or canvas detour.
5. **T5 — default semantics:** a semantic audit over the standard element set finds no
   retained interactive node without a role, name, and action surface.
6. **T6 — i18n raster:** a CJK + RTL + fallback-font fixture (mixed-script paragraph, Arabic
   selection and caret, CJK IME entry) runs on every supported backend and the reference CPU
   renderer.

---

## 5 · Latency has exactly three shapes: question, action, stream

07 §7 built the machinery; the survey asks for the *semantics* to be sealed so the public
surface can never grow an Iced-style `Task`/`Subscription` API by accretion. The trichotomy,
boxed:

> **Question.** A repeatable derived read. Spelled `source.map_async(f)` / `try_map_async` /
> `compute`; produces a `Reader<T>`; revision-stamped; latest-input-wins; superseded or
> unmounted work cannot affect presentation (07 §7.5); readiness and faults are boundary
> policy, never value types. Finite by definition — one accepted answer per stamped request.
>
> **Action.** A finite effect with a declared policy. Spelled as a method or a mounted
> `.action(...)` with explicit `queue`/`pending`/`then`/`catch` (07 §7.8); reliable or
> idempotent by declaration, because cancelling a mutation is not like cancelling a read.
> Completion is one stamped delivery to its owner; unmount revokes delivery, never un-does the
> world.
>
> **Stream.** An owned protocol whose *messages are the domain*, not the completion of a
> derivation. Spelled `Remote<T>`/services with explicit lanes (`Reliable`, `Latest`,
> `Coalesce`, bounded); owner-bound — it lives exactly as long as the entity or mount that
> owns it, and its teardown is that owner's teardown. Never latest-wins, never silently
> coalesced unless the lane says so.

The classifying question is one sentence: *is a stale answer worthless (question), is a lost
request a bug (action), or is the sequence itself the meaning (stream)?* Nothing else exists;
a fourth shape is a design error, not an extension point. The trichotomy's tests are the gate:
cancellation fuzzing, stale-delivery rejection, and A→B→A aliasing already in gate 8/8b, plus a
new fixture per shape proving the *wrong* spelling is either a compile error (a stream result
cannot install as a property port) or a located diagnostic (a question producer performing an
observable side effect is inspector-attributed).

07 §7's no-public-`Task` rule survives unchanged — the trichotomy is what a `Task` type would
have flattened into one word, kept as three meanings with three contracts.

---

## 6 · Media are ordinary Rust values in the same sockets

The survey's finding is blunt: toolkits make users base64-encode PNGs or paint bitmaps onto
canvases to display an image they already hold in memory. The media pipeline
([runtime/media.md](runtime/media.md)) already stages acquisition/decode/upload; what was
missing is the sealed plug family at the authoring seam — the `IntoProp` move applied to media:

```rust,ignore
image(&self.photo)                       // Signal<RgbaImage>: a live image port
image(rgba_image)                        // image::RgbaImage — owned pixels, zero ceremony
image(dynamic_image)                     // image::DynamicImage — converted in the pipeline
image(Png(bytes))                        // encoded bytes, format-tagged; decode is staged
image(asset!("logo.svg"))                // build-time asset; vector-aware
image(Uri::get(url))                     // request descriptor: fetch/decode staged, cached
image(self.thumbnails.reader())          // Reader<Frame> — video/live/provider frames
```

```text
IntoMedia ⊇ RgbaImage | DynamicImage | tagged encoded bytes | asset | path | request
          | frame provider | any Source of the above
```

Laws: every form lowers into the *same* typed pipeline (staging, cache identity, color-space
tagging, atlas/texture ownership per runtime/media.md) — a provider does not have a private
fast path and bytes do not have a slow one; pipeline identity means the same `RgbaImage` handle
shown twice uploads once; **data URLs are not an in-memory image API** and never become one
(the string form is at most a parser for foreign content, not the way a Rust value reaches the
GPU); and the whole family is a `Source` composition, so a `Signal<RgbaImage>` patches its
texture through the port like any other publication — camera preview and generated thumbnails
are the ordinary case, not the advanced one. Gate T4 measures the matrix.

---

## 7 · "Derived state is a circuit" becomes lintable

17 §6 stated the discipline ("derive, don't react"); the survey asks for it as a *lintable
law*. Vocabulary first, then the two lint tiers.

> **A value that is a function of current state is a circuit** — a prop plug, a `map`, a
> `project` region, a derived reader. It lives in `view` or in the source algebra, updates by
> port patch, and never occupies a turn.
> **`changed` is the synchronization surface with the world outside the circuit** — I/O,
> focus claims, sounds, entity commands, handoff consumption, protocol sends. A `changed` that
> only computes state from state is a circuit written as an effect: one extra turn of latency,
> one glitch window, and one lint.

- **Static tier.** `#[reactive]` (and a shipped lint for the no-macro path) flags a `changed`
  whose body, along some path, does nothing but assign fields from pure functions of the
  delta — no method calls that leave the component, no handoff `take`, no capability use. The
  diagnostic names the port to use: *"`self.badge` is derivable — bind
  `self.store.unread.map(badge_level)` at the sink instead."* It is warn-by-default and
  suppressible, because the analysis is syntactic and false positives must cost one attribute,
  not an argument.
- **Dynamic tier.** The kernel already attributes turns; the inspector detects the signature —
  a `changed`-initiated write that triggers re-description and no external effect, converging
  in the following turn — and reports the same "derivable state" finding with the actual
  runtime cycle, including across components (parent `changed` writes what child `view`
  derives). This subsumes 16 §2's loop attribution: an infinite version is a loop report; a
  converging version is a derivable-state report.

The law also settles what `changed` scheduling *means* under the macro (16 §2's gate-3
symmetry, restated with the survey's framing): narrowing invocation edges is legal precisely
because `changed` is an effect surface — a circuit may be arbitrarily reordered or fused, an
effect may only be *skipped when its inputs did not change*. The lint keeps authors on the
right side of that line, so the optimizer's license stays sound.

---

## 8 · Boundary laws, restated once

Two P2 decisions were already made across 07/11/13; they are restated here as one-line laws so
the final synthesis can cite a single home:

- **Schema-derived typed IPC exists only at actual ABI boundaries.** The plugin catalog
  (07 §9.2), foreign shells, and separately compiled extensions get versioned, generated,
  checked contracts. In-process component communication is state, deltas, and methods — never
  serialized commands, never a metaobject registry (the current `actions!` macro's
  string-keyed action registry does not return).
- **Compilation is a tier, not a language.** Const-evaluable subtrees may lower to static tape
  templates with patch tables (11 §14); `#[reactive]` may cut ports and regions (07 §5); any
  future tooling lowers to the same `El`/port/impact schema plain Rust produces. A second
  runtime, a second tree, or a second semantics is out — permanently, at any measured benefit.

---

## 9 · Gates added by this pass

Continuing 07 §17's numbering scheme with a letter prefix per family:

- **A1 — algebra matrix.** Every verb × every `Source`/`SeqSource` instance × every `IntoProp`
  plug form: accepted combinations produce descriptor-identical installations to their
  macro-lowered equivalents and allocate zero after install; rejected combinations fail with
  the §1 diagnostics (`trybuild`, message-text asserted, per 11 §15).
- **A2 — sequence coherence.** Each `ChildSeq` form's shape delta lowers to its declared splice
  class; permutation fixtures prove slot forms preserve identity and ordinal forms mount-cycle
  exactly as 11 §6 states; a plugin boundary is the only place erasure appears in the corpus.
- **A3 — impact precision.** Counter-verified: a `PAINT`-only publication runs zero
  layout/hit/a11y work on a warm tree; a `PLACEMENT` publication moves a subtree without
  re-layout; text edits run layout on the damaged range only; the union over a mixed turn is
  the exact union, and every pass the epoch runs is attributable to a logged port.
- **T1–T6** — the platform bar (§4.4), each a required CI job on every supported backend.
- **L1 — latency trichotomy.** The three-shape fixtures of §5: per-shape contract tests plus
  the mis-spelling rejections; the existing gate-8/8b fuzzing is folded in unchanged.
- **C1 — circuit lint.** The static lint fires on the canonical derivable-state fixture and
  stays silent on the canonical legitimate-effect fixture (focus claim, sound, entity send,
  handoff take); the dynamic tier attributes a cross-component derivable-state cycle within
  two turns.

---

## 10 · Explicit rejections, consolidated

The survey's rejection list merged with 07 §18's — recorded as the standing no-list the final
proposal inherits verbatim. None of these returns in response to any future survey, benchmark,
or convenience argument:

hooks and positional state (`use_state`, `use_ref`, `remember`) · global message enums,
framework-wide `Task`, `Command`, subscriptions, or an event bus · `cx`, manual `notify`,
stored subscriptions, lifecycle-owning callbacks, ambient reactive tracking · user-facing
widget invalidation · `Any` event payloads, string properties/signals, implicit list keys,
location-only identity · a mandatory DSL/RSX/QML-like language · data URLs as an in-memory
image API · a second runtime tree for selection, accessibility, grids, or docking · public
`Fn() -> T` property fallbacks · call-order or hook-slot identity in any costume · IPC or
metaobjects for in-process updates · string capability queries in application code.

---

## 11 · Decision list

| # | Decision | Grounds / supersedes |
|---|---|---|
| 1 | Ratify sealed `Source`/`SeqSource` as the normative algebra; add `Sink`/`Cell` so binding direction is type-checked at the port | survey P0; 11 §1 promoted from proposal to law |
| 2 | `IntoProp<T>` closed plug family with the three laws (no closure plugs, one-meaning `Option`, one cost per form) | survey P0; 07 §4 `IntoProperty` sealed and enumerated |
| 3 | `ChildSeq` sealed sequence contract with per-form shape deltas and the coherence law; erasure only at open-world boundaries | survey P0; 14 §2 formalized; Xilem precedent |
| 4 | Kernel `Impact` taxonomy carried as a const on every sealed port and phase obligation; scheduler runs the logged union; no user invalidation in either direction | survey P0; Masonry precedent; names the lanes 07 §4.2 already had |
| 5 | `text_input(&Signal<String>)` standard control; document-of-record transaction law; `on_edit` interceptor verdicts; IME sub-transaction; blur-settles-composition ordering | survey P0; 07 §16.4 + 09 promoted from protocol to shipped control |
| 6 | A11y projection is a pure function of the committed epoch; activation needs no repaint; default semantics on every standard element; typed capability visitor for tests/inspector, no string queries anywhere | survey P0; Iced `Operation` precedent, application tier excluded |
| 7 | Platform bar T1–T6 are stabilization gates | survey P0 |
| 8 | Question / action / stream trichotomy sealed with per-shape contracts; no fourth shape, no public task type ever | survey P1; 07 §7 semantics made exact; Iced Task/Subscription as evidence not API |
| 9 | `IntoMedia` sealed plug family; every form lowers to the one typed pipeline; data URLs permanently rejected as an API | survey P1; runtime/media.md gains its authoring seam |
| 10 | Circuit/effect law lintable: static tier in `#[reactive]` + shipped lint, dynamic tier in the inspector; grounds the macro's scheduling license | survey P1; 17 §6 made enforceable |
| 11 | Boundary laws restated: generated IPC only at ABI edges; compilation lowers to the one schema | survey P2; 07 §9.2, 11 §14 |
| 12 | Rejection list consolidated as the standing no-list | survey + 07 §18 |
