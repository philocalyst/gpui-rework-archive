# 13 — The Composition Pass: Sources in Front, Machinery in Back

Status: third structural pass, continuing [11-consolidations.md](11-consolidations.md) and
[12-example-review.md](12-example-review.md). This pass supersedes 12 §7d (`SurfacePhases`) and
revisits the workbench again — not to make it shorter (12's mistake: line count is not
understandability) but to make it **compose**. The target artifact is
[examples/workbench_composed.rs](examples/workbench_composed.rs).

One principle drives every change in this document, and it was already latent in 07:

> **Applications name sources. Everything derived from a source is owned by the framework at the
> place it is mounted, and is rebuilt from its sources whenever it needs to exist again.**

07 §7.3 already states the enabling half: *"No runtime can start work that has not been
declared."* Declared from what? From sources. This pass takes that law to its conclusion three
times: identity (§1), the display pipeline (§2), and custom surfaces (§3). §4 then brings back
`impl Element` — as a trait, with the concrete type demoted to a currency — because capability
composition is the same principle applied to the element surface itself.

---

## 1 · Identity goes into the background

### 1.1 The diagnosis

The workbench sketches carry a parallel identity universe the application must author:
`ItemInstanceId`, `StoredItem { kind, schema, instance, locator, state }`,
`ItemKind::new("dev.zed.editor", Version::new(3))`, `OpaqueRecord`, and an `ItemCatalog` whose
`ItemSpec` demands five factories (`open`, `save`, `restore`, `migrate`, `follow`). All of it
exists to answer one question — *how does state survive a process?* — and all of it is ceremony
the moment you notice that [presenter.rs](examples/presenter.rs) already answers that question
with none of it:

```rust,ignore
// presenter.rs, today: a Signal<Option<Slot<Slide>>> survives an app restart
let journal = app.history().checkpoint();
open_presenter(Application::demo().restore(journal), fixture());
assert_eq!(restored.progress(), "3 / 3");   // the typed slot came back — no restore UI code
```

The journal restores signals, lists, and even cross-references (`Slot<T>`) with zero app-authored
identity. The workbench never uses this mechanism. That is the hole.

### 1.2 The law: restore is re-derivation

Two moves close it.

**Move one: state is journaled structurally — through serde, not a `Save` trait.** An owner's
persistent state is the composition of its fields' persistent state, and the bound is the one the
ecosystem already has: `serde::Serialize + DeserializeOwned`. GPUI ships `Serialize`/`Deserialize`
impls for its containers — `Signal<T>` serializes as `T`; `Entity<T>` as a journal node
reference; `Slot<T>` as a stable node reference, re-minted as a fresh generational slot on
restore (the mapping lives entirely in the journal, threaded through serde's seeded
deserialization). `Target<K>` is presentation and never persists. **No application type contains
an id, and no application type derives anything GPUI invented** — `#[derive(Serialize,
Deserialize)]` is the whole contract. The journal is *just a serde format with an identity side
channel*, which buys composability everywhere serde reaches: the same state tree exports to JSON
for a bug report, snapshots into a test fixture, or crosses a sync protocol, with zero extra
impls. Migration uses serde's own vocabulary first (defaults, aliases, untagged fallbacks) and
explicit journal-level migrations for genuinely breaking changes — owned exactly where the data
is declared.

**Move two: everything derived rebuilds itself.** This is the insanely-simple consequence of
07's own architecture that the workbench missed. Producers are declared from inputs; the reader
graph, display projections, wraps, fetches, and caches are all *derived*. So restoring the
sources re-arms every producer, concurrently, through the same admission machinery as any other
turn — which means:

> **Cold start, restore, and reconnect are one code path: construct from sources.**

The `ItemSpec` pentad collapses. `open` and `restore` were two factories because current Zed
resolves resources imperatively; here the constructor stores journaled domain data (a path, an
anchor set, a mode) and the async producers declared from those fields do the resolving — on
first launch *and* on restore, identically. `save` is the journal. `migrate` is the versioned
`Save` impl. Parallel fetch-high restore (07 §9.2's proudest fixture) is not a workspace feature
anymore; it falls out of §7.3, because all the restored sources publish in one turn and every
producer declared from them arms together.

### 1.3 What honestly remains

- **Static heterogeneity is an enum.** A workspace whose item types are known at compile time
  holds `List<Tab>` where `Tab` is a plain enum (`Editor(Editor) | Terminal(Terminal)`), matched
  exhaustively in `view`. Rust already has the perfect tool for a closed set of alternatives;
  a catalog for your own five types was always a plugin mechanism misapplied.
- **The catalog survives only at the plugin boundary** — genuinely open sets, `AnyEntity`,
  versioned wire protocols (07 §9.2 unchanged there). An app that loads no plugins never sees it.
- **Collaboration still needs durable references** (07 §11.1) — but the peer-visible name of an
  item is domain data the app already stores (project + path + excerpt anchors), not a minted id.
  The session alias table maps those to live entities, in the framework, as before.
- The journal is explicit at exactly one place: `Application::new().journal("workbench")`.
  Nothing is ambient; what persists is what implements `Serialize`, and the inspector shows the
  journal tree.

---

## 2 · `DisplayPipeline` dissolves into the element

### 2.1 The diagnosis

The workbench holds `main: DisplayPipeline, minimap: DisplayPipeline`, mounts each with a
`ViewportSpec`, threads `.projection(self.main.snapshot())` into the surface, and reads
`is_pending(&self.main.snapshot())`. But 07 §15.4 already states the fact that makes all of this
ceremony: *"each mounted `EditorViewport` owns a `DisplayPipeline`."* The pipeline is
per-viewport, and a viewport **is a mount**. A noun the app constructs, whose identity duplicates
an identity the framework already has, is exactly the disease `Slot<T>` cured for lists — the
"hand-rolled `PaneId` plus `HashMap`" of the text world.

### 2.2 The shape: the pipeline lives where the mount is

`code(&document)` is an element. Its retained mount owns the display projection — the full
07 §15.4 transform stack (`multi → inlay → fold → tab → wrap → block`), the async wrap memo, the
`WrapDemand` bridge, provisional snapshots, coherent-epoch admission — all of it framework
machinery below the element, configured by combinators and extended by layers (§3):

```rust,ignore
struct Editor {
    document: Entity<Document>,        // sources — the only things the app names
    selection: Signal<Selections>,
    scroll: Signal<ScrollAnchor>,
    hints: Signal<Vec<InlayHint>>,
}

fn view(&self) -> impl Element<'_> {
    code(&self.document)
        .selection(&self.selection)    // wires, not observations
        .scroll(&self.scroll)
        .layer(inlay_hints(&self.hints))
        .overlay(Align::TopRight, minimap(&self.document).follows(&self.scroll))
}
```

Everything the `DisplayPipeline` noun was doing is still done — by the mount:

- **Viewport identity** is mount identity. The minimap is simply a second element over the same
  document; it gets its own wrap width, geometry, damage, and provisional snapshots because it is
  its own mount (07 §15.4's "N viewports" for free, including nesting). Document-invariant
  logical layers and the shaping/atlas caches are shared by revision — framework concern,
  invisible.
- **Wrap width comes from layout.** `ViewportSpec::editor(request.initial_bounds)` was the app
  transcribing a number the layout pass already knows. The mounted projection reads its width
  from its own laid-out box; the §2.3 demand/admission machinery is unchanged, just unnamed.
- **Readiness is asked where everything else is asked**: `is_pending(&self.document)` at
  entity grain, or on any wire derived from it — no `.snapshot()` accessor pair.
- **Escape hatch preserved**: code that truly needs the projection as a value (tests, a status
  bar showing wrap column) asks the element's target for a reader —
  `self.editor_target.display()` — the same way tests already query committed state through
  targets. The pipeline type still exists; it stopped being a constructor the app calls.

The principle restated: the app named a *derived* thing. Derived things live behind their
declaration. Only `document`, `selection`, `scroll` — sources — deserve fields.

---

## 3 · One child mechanism: marks are elements, geometry is a source, placement is a value

### 3.1 The diagnosis

`SurfacePhases { layout, geometry, paint, hit, input, accessibility }` (12 §7d) fixed the
*repetition* of six chained setters and kept the *monolith* — the kernel's internal shape leaking
into the authoring surface. This document's first draft replaced it with a `Layer<G>` trait, which
fixed the unit and kept three smaller diseases: `cx.quad(…)`/`cx.text(…)` is a **second drawing
vocabulary** beside elements; `fn paint(&self, cx, geo)` is imperative threading with a trait impl
as the price of admission; and `.layers((…))` sat next to `.overlay(…)` as two verbs for "content
stacked on content" — the exact overlap it should have dissolved. All three fall to facts the
design already owns:

1. **Marks are elements.** A peer-cursor quad and its name label need nothing that `rect(…)` and
   `label(…)` don't already do — same builders, same property ports, same routes for hit-testing,
   same accessibility story. A second paint vocabulary was a second world in miniature.
2. **Geometry is a source.** A surface's computed geometry (line boxes, caret rects, block
   metrics) is a *derived value* — in the 11 §1 algebra, `impl Source<Value = CodeGeometry>`. It
   is resolved the way theme tokens already are (§16.5): an **inherited source**, supplied by the
   nearest enclosing surface at mount, a located mount error outside one — the same law that gives
   a row handler its `Slot<T>`.
3. **Placement is a value, and the coordinate space lives in its type.** `identity.rs` already has
   the seed: `hover_card().place(below(handle))`. Generalize it: `code.caret(anchor)` returns a
   placed handle in *text space*; `TopRight` is *box space*; `below(h)` is anchor space. A child
   carrying a placement is out of flow — the web's `position: absolute`, semantics kept — stacks
   in document order, and reorders with `.z(n)` inside the surface's stacking context (the web's
   z-index, kept). Paint order thereby decouples from tree order without leaving the tree — the
   flexibility [PanGui](https://pangui.io) demonstrates with its single unified hierarchy where
   layout, styling, and draw order are one system rather than a widget tree plus a paint pass.

### 3.2 The shape

There is no `Layer` trait. A decoration is an ordinary `project` region over
`(its data, the enclosing geometry)`, returning ordinary elements with placements:

```rust,ignore
code(&self.document)
    .selection(&self.selection)                              // hot built-ins: configured wires
    .child(peer_cursors(&self.presence))                     // a decoration — same verb as any child
    .child(minimap(&self.document).align(TopRight))          // box-space placement — same verb

fn peer_cursors(presence: &Signal<PresenceSnapshot>) -> impl Element + '_ {
    (presence, Code::geometry()).project(|(peers, code)| {
        peers.iter().filter_map(|peer| {
            let caret = code.caret(peer.anchor)?;             // typed anchor → placed handle
            Some((
                rect(caret).fill(peer.color.alpha(0.8)),      // marks ARE elements
                label(&peer.name).above(caret).fg(peer.color),
            ))
        })
    })
}
```

Read what happened to the scheduling, because it is the elegant part: the decoration reruns
exactly when the presence signal or the geometry publishes — **the same law as every other region
in the system**. No trait, no phase, no paint callback; `filter_map` over an iterator of element
tuples is the entire authoring model, and `Option` handles an off-screen anchor the way Rust
handles absence everywhere else. Hit-testing needs no `fn hit` — a mark that wants interaction
attaches a route like any element; marks without routes cost nothing at dispatch.

What remains sealed is only what was always sealed: the **hot floor**. `draw(|cx: Paint<'_>| …)`
keeps 07 §15.2's zero-copy streaming path — glyph runs, selections-by-the-thousand — and the
built-in strata (`glyphs`, `selection`, `caret` blink on its §4.2 clock lane) are implemented on
that floor and exposed as configured wires (`.selection(&self.selection)`), not as things an
application re-implements. The ladder: a placed mark → a decoration region → a configured
built-in → `draw(closure)` → a full custom surface with its own `geometry(…)` pass
(`LayoutCx`/`GeometryCx` unchanged, §2.3). Each rung is reachable from the last without changing
vocabulary.

### 3.3 The verbs collapse

`layers(…)`, `stack(…)`, and `.overlay(align, x)` all delete. There is one child verb and a
placement algebra:

| Spelling | Meaning | Web equivalent |
|---|---|---|
| `.child(x)` | in flow, per the container's layout | normal flow |
| `.child(x.align(TopRight))` | out of flow, box space | `position:absolute` + inset |
| `.child(x.at(handle))` / `.above(h)` / `.below(h)` | out of flow, the handle's space (text, anchor, pointer) | no equivalent — this is the win |
| `.z(n)` | reorder within the surface's stacking context | `z-index` |

Document order remains the default paint order; a surface establishes a stacking context exactly
as CSS does, so web intuition transfers — and `follow(pointer.local())` from pointer_follow.rs
was this algebra all along: a placement whose handle happens to be live.

---

## 4 · `impl Element` returns — as the trait, with `El<'f>` as the currency

### 4.1 What concrete-only actually cost

07 §2 made every builder finish as one concrete `Element<'f>`, killing `.any()`, `Either`, and
branch poisoning. Keep all of that. But concreteness has a cost the examples show: **every method
exists on everything.** `text("hi").columns(3)` type-checks. A component returning `Element<'_>`
gives its caller the entire builder surface — there is no way to say "this chip is restyleable"
versus "this dialog's internals are sealed," and no way to write a mixin generic over "things
that can be styled" except the untyped `impl Styled` pipe helpers text.rs improvises.

### 4.2 The design

Split the name: **`Element` becomes the sealed trait; `El<'f>` is the concrete sealed currency.**

```rust,ignore
pub trait Element<'f>: sealed { … }        // implemented by El and every builder
pub struct El<'f> { … }                    // the §2 draft cursor, renamed; implements Element

pub trait View { fn view(&self) -> impl Element<'_>; }   // RPITIT; kernel seals at the call
```

- **Builders keep capability traits**: `Styled` (box styling), `TextStyled`, `Container`
  (children), `Interactive` (routes) — flat traits on the concrete builders, *not* recursive
  typestate; §3's recipe rule is untouched. `text(…)` implements `TextStyled` but not
  `Container`; `.columns(3)` on a text is now a *missing method*, found at the call site.
- **Components choose their contract in the return type**, and this is the point:

```rust,ignore
fn chip(label: &str) -> impl Element + Styled + '_ {    // open: caller may restyle
    row((dot(), text(label))).px(8).rounded_full()
}
fn confirm_dialog(…) -> El<'_> {                        // sealed: internals are not yours
    …
}

chip("Rust").bg(theme.accent.weak)     // ✓ the contract invites it
confirm_dialog(…).bg(red)              // ✗ no such method — encapsulation as a type
```

  Opacity becomes an API decision spelled in one word, instead of a comment. Mixins become
  honest generics: `fn card<E: Element + Styled>(e: E) -> E` — text.rs's pipe pattern with a real
  bound. And with a real bound, the method deserves a real name: **`pipe` is renamed `apply`**
  (`.apply(card)` — "apply this function to the chain here"), and because a mixin is just a
  function, plain application always works too: `card(column((…)))`. Two spellings, one meaning,
  zero new concepts — the shell-ism goes away.
- **Sealing is automatic everywhere coercion can be.** Why not *fully* automatic? A language
  fact, not a design choice: Rust has no user-defined implicit coercions, so two *different
  opaque* `impl Element` types can never unify as bare `match` arms — every Rust UI meets this
  wall (Iced's `Into<Element>`, etc.). The design's job is to make the wall almost never
  reachable, and it is: **every sink is generic** (`child`, `children`, boundary content, window
  roots, decoration tuples all accept `impl Element`), so passing a component *anywhere* seals it
  implicitly; and application views return `El<'_>` by default, so ordinary branches over
  ordinary helpers unify with no ceremony, exactly as 07 §2 promised. The residue is precisely
  one case — joining two *different opaque* component types in one expression — and its spelling
  is a **constructor, not an erasure method**: `el(x)`, the sibling of `text(x)`, taking anything
  element-able (including `&impl View`):

  ```rust,ignore
  match self {
      Tab::Editor(editor) => el(editor),
      Tab::Terminal(terminal) => el(terminal),
  }
  ```

  `el(…)` boxes nothing, erases nothing, allocates nothing — operands are already in the arena;
  it seals into the currency, monomorphically, cost zero. It is not the banned `.any()`, and the
  one-sentence rule stands: *return `El` to branch on it, return `impl Element + Caps` to compose
  on it; `el(…)` joins, free.* Gate 1 (no-macro branch freedom) is unaffected.
- **Monomorphization stays capped.** Opacity is one level deep: an `impl Element` return is
  sealed at the first sink or `.el()`, so helper-internals never propagate into caller signatures
  and the application still cannot encode its UI tree in a type. This was §2's real requirement;
  concreteness-everywhere was just the first way to get it.

### 4.3 Why this is the same principle

`El<'f>` is to elements what the journal node is to identity and the mount is to the display
pipeline: the framework-owned form behind the declaration. The app composes capabilities
(`impl Element + Styled`, placed marks, sources); the framework owns the sealed representation.
One law, fourth application.

---

## 5 · Readability rules the examples now follow

Adopted from this pass, applied in [workbench_composed.rs](examples/workbench_composed.rs):

1. **Fields are sources.** If a field is derived (a pipeline, a snapshot reader you only read in
   `view`, an id mirror), it is a smell; derive it at the mount or through the algebra.
2. **Name the strata, not the plumbing.** `code(…).child(inlay_hints(…))` over
   `.projection(pipeline.snapshot())`. A reader should meet domain words (glyphs, selections,
   hints), not kernel words (phases, pipelines, specs).
3. **Enums for closed sets; catalogs for open ones.** `match` is the most readable dynamic
   dispatch Rust has.
4. **Prefer a named local over a clever chain** when a chain crosses two concerns. Line count is
   not the metric; the metric is whether the next reader predicts each line from the last.
5. **The return type is the encapsulation contract** — `El<'_>` seals, `impl Element + Caps`
   invites (§4.2).
6. **One drawing vocabulary.** Decorations are elements with placements; `draw(closure)` appears
   only at the sealed streaming floor. If a sketch calls `cx.quad`, it had better be inside a
   framework built-in.

---

## 6 · Decision list

| # | Decision | Supersedes / touches |
|---|---|---|
| 1 | Structural journaling: `Save` on sources, journal-owned instance identity and slot remapping; no app-visible ids | workbench identity records; 07 §9.2/§11.1 narrowed to plugins + collaboration |
| 2 | Restore = re-derivation: one constructor path for cold start/restore/reconnect; `ItemSpec` pentad collapses | 07 §9.2 factories; async_workbench restore flow |
| 3 | Closed item sets are enums; `ItemCatalog` is plugin-boundary only | 12 lite's catalog usage |
| 4 | `DisplayPipeline` is mount-owned; `code(…)`/`minimap(…)` elements; width from layout; readiness via the source algebra | 07 §15.4 spelling (semantics intact); 12 §7 workbench fields |
| 5 | Decorations are `project` regions over `(data, inherited geometry source)` returning placed marks; `draw(closure)` only at the sealed streaming floor; input stays on element routes | **supersedes 12 §7d `SurfacePhases`** and this doc's first-draft `Layer<G>` trait |
| 6 | One child verb + placement algebra (`align`/`at`/`above`/`below`, `.z(n)`, web stacking semantics); `layers`/`stack`/`.overlay` deleted | 07 §15.2 spelling; pointer_follow/workbench sketches |
| 7 | Journal bound is `serde::Serialize + DeserializeOwned`; GPUI containers implement serde; the journal is a serde format with an identity side channel; no `Save` trait or GPUI derive | 13 §1 first draft's `Save` |
| 8 | `Element` trait + `El<'f>` currency; capability traits on builders; `el(x)` constructor at opaque joins (sinks seal implicitly); return type = encapsulation contract | 07 §2 naming (semantics intact) |
| 9 | `pipe` → `apply`; plain function application documented as the equal spelling | text.rs mixin pattern |
| 10 | Readability rules §5 adopted for all sketches | examples corpus |
