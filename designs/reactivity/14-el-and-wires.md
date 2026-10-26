# 14 — Retiring `el(…)`, One Children Rule, and Wiring as a Question

Status: fourth pass, continuing [13-composition.md](13-composition.md). Three items: the `el(…)`
wrapper and `El<'static>` noise the 13 §4 experiment produced (§1), the last children
inconsistency (§2), and an analysis of subscription-capturing struct fields with a recommendation
(§3). §1 **revises 13 §4**: the trait/currency split survives; opaque return types as the default
component contract do not.

---

## 1 · The `el(…)` post-mortem: opaque returns were the mistake, not the split

### 1.1 What went wrong

13 §4 made components return `impl Element + Caps`, betting that the `el(…)` join would be rare.
The corpus rewrite falsified the bet immediately: `el(…)` appeared at every enum-variant match,
around every mixin application (`el(card(column((…))))`), and inside helpers that merely wanted a
nameable return type. Worse, the opaque style dragged `El<'static>` annotations everywhere a
helper borrowed nothing. The diagnosis is exact: **Rust gives exactly one zero-annotation way to
unify branch arms — the same nominal type** — and 07 §2 had already built the design around that
fact. Opaque-by-default walked away from 07's core win and then paid `el(…)` to buy it back, one
call site at a time.

### 1.2 The revised rules — `el(…)` is deleted

1. **Builders and helpers finish as concrete `El<'f>`.** `text(…)`, `row((…))`, `code(…)` and
   every completed component are one nominal type again, so every `if`, `match`, `Option`, and
   iterator unifies with zero ceremony — 07 §2 restored in full. There is no `el(…)`; there is
   nothing for it to do.

2. **`impl Element` survives as the *lifetime-hiding leaf spelling*, and it solves the `'static`
   annoyance as a side effect.** A helper that is never branched over may return `impl Element`
   (borrowing: `impl Element + '_`) — and note what vanished: the lifetime annotation. A
   borrow-free leaf is `fn swatch(color: Color) -> impl Element`, not `-> El<'static>`. The
   contract is stated in the signature: *return `El<'_>` to be branched on; return `impl Element`
   to hide the plumbing; every sink takes both.* `El<'static>` remains legal as the honest
   spelling when a helper wants branchability *and* borrows nothing, but it stops being the
   idiom — the corpus should barely contain it.

3. **The rare forced join uses std, not a bespoke word.** Two different opaque types meeting in
   one expression (a cross-library accident, not a pattern) convert with `.into()` — standard
   Rust, `From<impl Element> for El<'f>`, zero cost as before. If your own code hits this, the
   fix is to change that helper's return to `El<'_>`, not to convert.

4. **Encapsulation moves to the mechanism Rust already ships: struct views.** 13 §4's real
   insight was "the return type is the encapsulation contract" — right idea, wrong tool. A
   function component returning `El<'_>` is *open* (the caller may keep styling it — every El
   method is available, which is what a helper wants). A component that has earned sealed
   internals has earned a struct: `struct ConfirmDialog { … } impl View` — and a struct view
   embedded as a child exposes **no** style surface at all, by module privacy, the strongest and
   oldest sealing Rust has. This completes the existing ladder rather than adding to it: *a
   component that earns state gets a struct (07 §11); a component that earns encapsulation gets
   one too.*

5. **Capability traits retreat to bounds, where they were always right.** `Styled`, `Container`,
   `Prop<T>` remain as *parameter and mixin bounds* — `fn card<E: Styled>(e: E) -> E` — and a
   library that wants to advertise restyleability across an opaque return may still write
   `-> impl Element + Styled`. What is retired is only per-kind method gating on finished
   elements (`text(…).columns(…)` type-checks again). The type-safety that mattered keeps its
   07 home: layout families live in `Flex`/`Grid` recipes (§3), obligations in proof builders
   (§2.2), and dataflow direction in `Prop`/routes. Element-level method gating was the one
   check whose price — the wrapper on everything — exceeded its value.

### 1.3 What the corpus looks like now

```rust,ignore
impl View for Tab {
    fn view(&self) -> El<'_> {
        match self {                       // no el(…): arms are the same nominal type
            Tab::Editor(editor) => editor.view_with(…),
            Tab::Terminal(terminal) => terminal.view(),
        }
    }
}

fn swatch(color: Color) -> impl Element {  // no lifetime, no El<'static>, no wrapper
    div().size_8().bg(color).rounded_md()
}

fn tab_skeleton() -> impl Element {        // mixins by plain application — no el(card(…))
    card(column((skeleton_line(0.7), skeleton_line(0.9))).gap(8))
}
```

`View::view` returns `El<'_>` (concrete — views are branched on by definition). The 13 §4
sentence "the framework owns the sealed representation" is truer than before: there is exactly
one sealed representation and the author never converts into it.

### 1.4 The variance decision this quietly requires

Pass 14's bare branching depends on `match { Some(s) => s.view(), None => end_card() }`
unifying `El<'f>` with `El<'static>` — which requires **`El` to be covariant in `'f`**. 07 §2.1
declares `'f` *invariant* (the generativity brand), and also claims `Element<'static>` "coerces
into any frame." Those two sentences were already in tension; this pass forces the decision, so
make it explicitly:

> **`El<'f>` is covariant in `'f`.** Covariance only permits *shortening* a lifetime. The
> no-escape property needs the opposite direction forbidden — holding an `El<'f>` past its frame
> means using it at a longer lifetime, which covariance still rejects. Cross-frame smuggling
> (`El<'f1>` used as `El<'f2>`) requires proving `'f1: 'f2`, which the borrow checker cannot do
> for two disjoint frame scopes. What invariance additionally bought — brand *identity* for
> interior-mutability keyed by the brand, GhostCell-style — must be checked against the one
> subtle case: a candidate/speculative description (07 §13) nested inside a turn, where an outer
> frame demonstrably outlives an inner one. If the kernel ever holds two live frames with an
> outlives relationship, covariance would let an outer element flow into the inner draft; the
> commit diff must either tolerate that (it copies operands anyway) or the candidate arena must
> get its own brand.

07 §2.1's wording must be updated to match, and gate 13 gains a fixture: a Miri/`trybuild` case
proving (a) `El<'static>` flows into a frame arm, (b) `El<'f>` still cannot be stored, sent,
returned past `describe`, or used in a later frame, and (c) the candidate-description nesting
case above is either unrepresentable or harmless. If the fixture fails, the fallback is
invariance plus a sink-side-only coercion — which would resurrect a conversion at exactly the
`end_card` match shape, so the covariance proof is worth real effort.

---

## 2 · One children rule, no exceptions

The corpus still contains `column().children(&self.log, |line| …)` next to `row((a, b))`. The
inconsistency exists because `.children(collection, fn)` was carrying two unrelated jobs, and
splitting them deletes the method:

1. **Plain collections were never special.** An iterator of elements is already `impl Children`,
   so a `Vec` maps like anything else in Rust — in constructor position, like every other child:

   ```rust,ignore
   column(self.log.iter().map(|line| text(line).text_xs()))
   ```

2. **`List<T>` was the only real customer** — the `(collection, row_fn)` pair exists so the
   kernel can wire delta-preserving slots (07 §4.1). That contract gets its own named verb on the
   *list*, producing an `impl Children` like everything else:

   ```rust,ignore
   column(self.rows.each(Row::view))              // delta-wired: splice/edit/move per slot
   column(self.rows.each_with(Row::view_with, &ctx))
   ```

3. **The implicit form comes back for the common case.** When rows are themselves views, no row
   function is information — so `&List<T>` and `&Vec<T>` (for `T: View`) implement `Children`
   directly, and the delta wiring rides along invisibly for the `List`:

   ```rust,ignore
   row(&self.tiles)                     // T: View — delta-wired implicitly; the 80% spelling
   row(self.tiles.each(Tile::compact))  // explicit row fn (a non-view or an alternate view method)
   column(self.log.iter().map(|l| text(l).text_xs()))   // plain data: ordinary iterator
   ```

   The ladder is: implicit when the row *is* a view; `each(f)` when you choose the projection;
   an iterator when it's plain data. Explicitness is opt-in, exactly where it carries meaning.

So: **containers take `impl Children` in the constructor, always** — a tuple, an `Option`, an
iterator, `&list`/`&vec` of views, `list.each(f)`, or one element — and the `.children(…)`
method is deleted. (A bare `(collection, fn)` tuple overload was considered and rejected: it
collides with a two-element tuple of children. `each` also reads better — it says *per slot*.)
`virtual_list(&self.rows)` remains a widget because virtualization is a scrolling behavior, not
a children spelling; it accepts the same forms internally.

### 2.1 The empty box: `div()` stays nullary

Rust cannot overload by arity, so `div()` and `div(children)` cannot coexist — and the answer is
not `div(())`. The rule that resolves it is worth stating because it is a real semantic
distinction, not a workaround:

> **Flow containers are born with their children; the box primitive is born empty.**
> `column(…)`, `row(…)`, and `grid(…)` exist to arrange children, so they take them in the
> constructor. `div()` is the styled-box primitive — spacers, swatches, panels — and stays
> nullary; content is added with `.child(x)`, which remains the one child verb (13 §3.3) and
> composes with placement exactly as before. `rect(…)` remains the mark primitive (13 §3) —
> childless by type, so the question never arises there.

`div(())` therefore never needs to be written, `div()` keeps working, and a styled wrapper with
one child is `div().child(content)` — or just `column((content,))` when flow is what you meant.

---

## 3 · Subscriptions as struct fields: the analysis

The question: instead of constructor-line wiring
(`buffer.on_change(Workspace::persist)` — 07 §6.4), should subscriptions be captured as struct
fields, with a bundled derive to make them look declarative?

### 3.1 What fields would buy

- **Legibility**: the struct becomes the component's wiring diagram — every reactive edge
  visible in one place, next to the state it serves.
- **Explicit lifetime**: a subscription field is droppable, rebindable, enumerable; nothing is
  "registered by side effect."
- And that side effect is a real smell today: `doc.text.map(detect_language).on_change(Editor::reconfigure_lsp);`
  is an expression statement returning `()` whose entire meaning is invisible from the outside —
  order-dependent, easy to delete without a compile error, undiscoverable from the struct.

### 3.2 Why fields (and the derive) are still the wrong shape

- **A subscription is a relationship, not data.** Fields imply storage, and 13's laws both trip
  over that: *"fields are sources"* (13 §5.1) breaks, and structural serde journaling (13 §1)
  would try to persist them — every subscription field needs a `#[serde(skip)]`, which is the
  design contradicting itself in attributes.
- **The derive is the third language.** `#[on_change(doc.text => reconfigure_lsp)]` must name
  *runtime values* (fields, derived wires, map closures) in *attribute position* — that is a
  mini-expression-DSL inside a macro, exactly the thing 07 §5.1 and the `if_` deletion (11 §2)
  exist to prevent. And it would be the second UI-semantics macro, breaking gate 2 outright.
- **Composability, which you flagged, is the decisive loss.** Constructor wiring is plain Rust:
  it loops (`for doc in docs { doc.on_change(…) }`), branches, lives in helper functions, and
  handles the dynamic case (re-subscribe when `self.doc` is swapped). Fields are static per
  struct definition; the derive could never express a conditional or repeated edge without
  growing syntax for it.

### 3.3 The synthesis: wiring is a *question*, like a view

There is a way to get the declarative legibility without fields or a derive, and it is the same
move this design has now made four times: make it a **declarative description the kernel diffs**.
A component that wants its wiring in one visible place implements one optional method:

```rust,ignore
impl Wired for Workspace {
    fn wires(&self, w: &mut Wires<Self>) {
        w.change(self.buffer.text.map(detect_language), Self::reconfigure_lsp);
        w.on(&self.project, Self::on_project);
        if self.follow_mode {                             // plain Rust: conditional edges
            w.on(&self.leader, Self::apply_leader_update);
        }
    }
}
```

`wires` is to effects what `view` is to presentation: called at mount and re-evaluated when its
reads change; the kernel **diffs the declared edge set** — an edge that disappears is torn down,
one that appears is armed, unchanged edges are kept (same park/arm/teardown machinery as
07 §6.4, same retained-diff law as elements). This subsumes the dynamic-resubscribe case that
neither fields nor constructor lines handle well (swap `self.doc`, the next `wires` pass rewires
it), gives the inspector a complete authoritative wiring diagram, and adds **zero macros and
zero field ceremony** — it is four lines of ordinary Rust in a named place.

Recommendation: keep constructor-line wiring for the one-edge case (it is one line, and it
stays); add `Wired::wires` as the declarative home for components with several edges or dynamic
edges; do **not** add subscription fields or a wiring derive. If a struct wants its edges
visible, the method sits directly under the struct — same file, same legibility, real Rust.

---

## 4 · Journal-clean structs: `Target`, `Output`, and the field law completed

13 §1 said `Target<K>` "is presentation and never persists" — and then put one in a
`#[derive(Serialize, Deserialize)]` struct. Serde's derive requires *every* field to implement
the traits; the alternative is `#[serde(skip)]` on runtime-only fields, which is exactly the
attribute ceremony §3.2 condemned for subscription fields. Covering this base properly turns out
to finish the field law.

**`Target<K>` serializes like `PhantomData`.** Serde already ships the precedent: `PhantomData`
implements `Serialize`/`Deserialize` by writing a unit and rebuilding a fresh value. A target is
per-process generational identity whose *persistent content is nothing*, so `Target<K>`
serializes as unit and deserializes by minting fresh — semantically exact (a restored process
must re-mint anyway), zero attributes, and the derive just works.

**`Output<E>` was the real problem, and fixing it improves the design.** An output field today
stores a *route* (07 §6.2's constructor binding) — and a route is a function item, not data.
No `Deserialize` impl can recover it, and `#[serde(skip)]` would deserialize a broken component.
The fix is the same move as §3.3, applied to the last relationship still living in construction:

- `Output<E>` the **field** becomes a pure typed endpoint — a declaration, data-free, serialized
  like `Target` (unit → fresh). It no longer stores a route.
- The **binding** moves to `Wired::wires`, beside every other edge:

  ```rust,ignore
  impl Wired for Search {
      fn wires(&self, w: &mut Wires<Self>) {
          w.output(&self.typeahead.picked, Self::picked);   // the back-edge, bound at mount
      }
  }
  ```

- **Requiredness moves from the constructor to the mount** — where 07 §6.2 already checked it
  ("a required unresolved output is a located mount error"); the constructor argument was only
  ever a way to make the mount check unmissable, and an unbound required output is still exactly
  that error. Constructors get simpler as a side effect: `Typeahead::new()` takes no routes.

The field law now closes with no exceptions and no attributes:

> **A struct field is data, a source, or a data-free endpoint (`Target`, `Output`). Every
> relationship — subscription, observation, output binding — is declared in `wires`/the view and
> diffed at mount.** Consequently every view struct derives `Serialize`/`Deserialize` cleanly,
> and 13 §1.2's "restore = re-derivation" becomes literally mechanical: deserialization rebuilds
> data and sources; the first mount re-establishes every wire, producer, and target — the same
> code path as cold start, now with nothing left over that could have gone stale.

---

## 5 · Decision list

| # | Decision | Revises |
|---|---|---|
| 1 | `el(…)` deleted; builders/components finish as concrete `El<'f>`; branch freedom is 07 §2 restored | 13 §4.2 |
| 2 | `impl Element` = lifetime-hiding leaf contract (“never branched over”); kills routine `El<'static>` | 13 §4.2 |
| 3 | Forced cross-library joins use std `.into()`; never a bespoke word | 13 §4.2 |
| 4 | Encapsulation = struct views (module privacy), completing the 07 §11 ladder; capability traits are bounds only; per-kind method gating on elements retired | 13 §4.2 |
| 5 | Containers take `impl Children` in the constructor, always; `.children(…)` deleted; `&list`/`&vec` of views implicit (delta-wired for `List`); `each(f)` explicit; iterators for plain data | 12 §4a residue |
| 6 | Flow containers unary; `div()` stays nullary (box primitive, `.child` for content); `div(())` never written | §2.1 |
| 7 | No subscription fields, no wiring derive; optional `Wired::wires(&self, &mut Wires<Self>)` — a diffed, declarative edge set in plain Rust | 07 §6.4 extension |
| 8 | `Target<K>` serializes like `PhantomData` (unit → fresh mint); `Output<E>` becomes a data-free endpoint serialized the same way, with its route bound in `wires` and requiredness checked at mount; field law: data, sources, and data-free endpoints only | 07 §6.2 binding; 13 §1 journaling |
