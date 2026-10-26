# View-Tree / Declarative UI Architectures: A Comparative Study for GPUI's Fine-Grained-Reactivity Redesign

> Research snapshot. Descriptive findings remain useful, but recommendations are superseded by
> [06-competitive-update.md](06-competitive-update.md) and
> [../03-hybrid-plan.md](../03-hybrid-plan.md).

Sources were read from shallow upstream clones of Xilem, Druid, Vizia, Slint, Iced, and
OpenSwiftUI, plus the linked primary web sources. File paths below are repository-relative. The
temporary clones were not preserved here, so re-pin upstream before relying on current line numbers;
the follow-up audit records its pins in [06-competitive-update.md](06-competitive-update.md).

---

## 1. Xilem (`xilem_core` + `xilem` + `xilem_masonry`)

### 1.1 Repo layout (from `xilem/ARCHITECTURE.md`)

```
xilem_core    -- the View/ViewSequence traits, no widget toolkit knowledge
xilem_masonry -- natively-compiled framework, built on Masonry
xilem         -- batteries-included wrapper (winit) around xilem_masonry
xilem_web     -- web framework, built on the DOM, also on xilem_core

masonry_core  -- base GUI engine (widget tree, passes, WidgetMut)
masonry       -- baseline widgets/properties/theme on top of masonry_core
masonry_winit -- winit backend
masonry_testing -- test harness
```

Xilem's own history doc (`xilem/docs/history.md`) says these crates "evolved from various experiments in the Linebender community (Druid, masonry, idiopath, lasagna, crochet, etc)" and lists the canonical essays:

- [Xilem: an architecture for UI in Rust (2022)](https://raphlinus.github.io/rust/gui/2022/05/07/ui-architecture.html)
- [Advice for the next dozen Rust GUIs (2022)](https://raphlinus.github.io/rust/gui/2022/07/15/next-dozen-guis.html)
- [Announcing Masonry 0.1, and my vision for Rust UI (2023)](https://poignardazur.github.io/2023/02/02/masonry-01-and-my-vision-for-rust-ui/)
- [Towards a unified theory of reactive UI (2019)](https://raphlinus.github.io/ui/druid/2019/11/22/reactive-ui.html)
- [Towards principled reactive UI (2020)](https://raphlinus.github.io/rust/druid/2020/09/25/principled-reactive-ui.html)

(See §7 for the extracted arguments from these posts.)

### 1.2 The `View` trait — `xilem_core/src/view.rs`

```rust
pub trait View<State: 'static, Action, Context: ViewPathTracker>: ViewMarker + 'static {
    type Element: ViewElement;
    type ViewState;

    fn build(&self, ctx: &mut Context, app_state: &mut State) -> (Self::Element, Self::ViewState);

    fn rebuild(
        &self,
        prev: &Self,
        view_state: &mut Self::ViewState,
        ctx: &mut Context,
        element: Mut<'_, Self::Element>,
        app_state: &mut State,
    );

    fn teardown(&self, view_state: &mut Self::ViewState, ctx: &mut Context, element: Mut<'_, Self::Element>);

    fn message(
        &self,
        view_state: &mut Self::ViewState,
        message: &mut MessageCtx,
        element: Mut<'_, Self::Element>,
        app_state: &mut State,
    ) -> MessageResult<Action>;
}
```

Key design points, straight from the doc comments:

- **The View tree is transitory.** "The view tree is transitory and is retained only long enough to dispatch messages and then serve as a reference for diffing for the next view tree." Every re-render of the app-state closure produces a **fresh tree of small, short-lived, typed values** (buttons, labels, flex containers…) that is *not* the retained UI — it's a diff key for the retained Masonry widget tree, discarded immediately after `rebuild`.
- **`rebuild(&self, prev: &Self, ...)`** — `prev` is literally the *old value of the same static type*, not a dynamically-typed old-vs-new comparison. Because `View` is generic over its own concrete Rust type, the compiler statically knows that `self` and `prev` are structurally identical types (e.g. both `Button<F>`), so there is no need for a runtime "is this the same kind of node" check — that question is resolved by the type system at zero cost, unlike React/Vue vdom diffing which must runtime-check element "type" tags. **This is the central compile-time-verification trick of Xilem's tree**: the shape of the two trees being diffed is provable identical (mod generic type params) by rustc.
- **`ViewState`** is explicitly *not* public API and can change on a patch release — it's the "opaque hidden retained state per view node" (analogous to a React fiber's hook list, but statically typed, not heap-boxed, not positionally-indexed at runtime — its shape is baked into the type).
- **`ViewElement`** (`xilem_core/src/element.rs`) is the associated "which retained-tree node type does this view correspond to" type, with `type Mut<'a>` as the mutable reference form used for `rebuild`/`teardown` (this becomes `WidgetMut<'_, ButtonWidget>` in `xilem_masonry`). `SuperElement<Child, Context>` provides `upcast`/`with_downcast` so a concrete element (e.g. `Button`'s widget) can be treated as a member of a more general element bucket (e.g. `Pod<dyn Widget>` for `ViewSequence`s and `AnyView`).
- `NoElement` — a `ViewElement` whose `Mut<'a> = ()`, for views that don't produce any widget at all (contribute nothing to the tree; used e.g. by `fork`'s "alongside" view or async-only views).

### 1.3 `ViewSequence` — tuples-as-heterogeneous-lists (`xilem_core/src/view_sequence.rs`)

```rust
pub trait ViewSequence<State, Action, Context, Element>: 'static
where Context: ViewPathTracker, Element: ViewElement {
    type SeqState;
    const ELEMENTS_COUNT: Count;   // Zero | One | Many | Unknown  (statically known shape class!)
    fn seq_build(&self, ctx: &mut Context, elements: &mut AppendVec<Element>, app_state: &mut State) -> Self::SeqState;
    fn seq_rebuild(&self, prev: &Self, seq_state: &mut Self::SeqState, ctx: &mut Context, elements: &mut impl ElementSplice<Element>, app_state: &mut State);
    fn seq_teardown(&self, seq_state: &mut Self::SeqState, ctx: &mut Context, elements: &mut impl ElementSplice<Element>);
    fn seq_message(&self, seq_state: &mut Self::SeqState, message: &mut MessageCtx, elements: &mut impl ElementSplice<Element>, app_state: &mut State) -> MessageResult<Action>;
}
```

`ViewSequence` is implemented for:

1. **Any single `View`** (blanket impl in `view_sequence.rs`) — the base case that actually pushes/mutates an `Element`.
2. **`Option<Seq>`** — inserted/removed as the value flips between `Some`/`None` (`view_sequences/impl_option.rs`).
3. **`Vec<Seq>`** (`view_sequences/impl_vec.rs`) — heap-allocated, dynamically-sized; uses a **generational index scheme**: `ViewId`s are packed `(generation:u32 << 32) | index:u32`. Every position in the vec is addressed **positionally by index**, but a per-slot `generation` counter is bumped whenever an index is reused with unrelated content, so that stale in-flight messages (e.g. an async callback captured from a since-removed list item at index 3) are detected as `MessageResult::Stale` instead of silently corrupting the wrong widget. This is a purely **positional, non-keyed** diff (unlike React's `key=`), i.e. Xilem does **not** have a first-class `for_each` with explicit stable keys — reordering an unkeyed `Vec<View>` causes elements to rebuild-in-place using the *positionally aligned* old/new pair, which for reorders means widgets end up representing the "wrong" logical item and just get patched into looking like the new one (still O(1) alloc-wise, but semantically like React sans keys).
4. **`[Seq; N]` fixed arrays** (`view_sequences/impl_array.rs`) — statically-known-length, so no generation/allocation bookkeeping needed at all; purely index-based recursion unrolled by the compiler.
5. **Tuples up to 15 elements** (`view_sequences/impl_tuples.rs`), nestable for more — **this is the mechanism that avoids `Vec<Box<dyn View>>` (and its allocation + dynamic dispatch) for the common case of "a fixed, statically-known list of heterogeneous children."** A `flex((label(...), button(...), if cond { Some(...) } else { None }))` call produces a value whose *Rust type* fully encodes the exact shape of the child list; `seq_build`/`seq_rebuild` are then monomorphized per call site with zero indirection. Every widget with multiple typed children (e.g. Xilem's `Flex`) is generic over `Seq: ViewSequence<...>` and stores the concrete tuple/array/View type directly, not a boxed list.

`Count` (`Zero | One | Many | Unknown`) is a **compile-time-computed enum constant** (`const ELEMENTS_COUNT: Count`) letting container widgets pick specialized code paths depending on whether their child sequence is provably 0, 1, or N elements — e.g. a widget that requires exactly one child can bound its `Seq` generic with `Seq: ViewSequence<..., ELEMENTS_COUNT = { Count::One }>`-style constraints, catching "you gave `Flex` a `ViewSequence` producing zero children where one was required" as close to compile time as const generics currently allow.

`ElementSplice<Element>` (`xilem_core/src/element_splice.rs`) is the "list diff cursor" interface: `insert`, `mutate`, `skip(n)`, `delete`, `index()`. Every `ViewSequence` impl is written as a **linear single pass** over both old and new sequences simultaneously (like a merge in mergesort), calling `insert`/`mutate`/`skip`/`delete` — there is no separate "diff algorithm" producing an edit script; the diff *is* the recursive structural walk, driven entirely by the static tree shape. `AppendVec<T>` is the append-only builder used only during the very first `build()`.

### 1.4 Id-path message routing (`xilem_core/src/view_ctx.rs`, `message.rs`)

- `ViewId(u64)` — an opaque per-hop identifier a `View`/`ViewSequence` pushes onto a path while building/rebuilding descendants (`ViewPathTracker::push_id`/`pop_id`/`with_id`). Meaningful only to the pusher (e.g. `Vec`'s generational index, a `Flex`'s child position, `AnyView`'s generation counter).
- When a widget deep in the Masonry tree fires a callback (e.g. button click), Masonry/xilem_masonry looks up that widget's **full id path** (recorded at `build` time) and replays it: at each `View`/`ViewSequence` level, `message()` is called with the *current* view value, `pop`s the first `ViewId` off the path, and recurses — so **the view that ultimately handles the message is always reconstructed from the current (not stale) view tree**, walking down by id, not by holding a stashed closure from a previous frame. This is structurally identical to how React Fiber or SwiftUI route events by "identity path," but here the path segments' *meaning* is fully owned and interpreted by strongly-typed Rust code at each level (`AnyView` uses the id to store/check a `generation:u64` so if the underlying dynamic type changed between when the message was queued and when it's routed, the view returns `MessageResult::Stale` rather than crashing — see `views/any_view.rs` `dyn_message`).
- `DynMessage(pub Box<dyn AnyDebug>)` (`message.rs`) is the type-erased message payload carried alongside the id path; `.downcast::<T>()` recovers the concrete type. `MessageResult<Action>` is `Action(Action) | RequestRebuild | Nop | Stale` — `RequestRebuild` exists specifically for the case where async work mutated retained-but-invisible state (e.g. a virtualized list fetched new rows) and the tree must be rebuilt even though the *View values* the app produces haven't structurally changed.

### 1.5 Composition adapters: `lens`, `map_state`, `Adapt`-equivalents

Xilem doesn't have a class called `Adapt` (that's a Crochet/early-Xilem-prototype name); the shipped primitives are `map_state`, `lens`, `map_message`/`map_action`, and `fork`.

**`map_state`** (`xilem_core/src/views/map_state.rs`) — the general form: given a `View<ChildState, ...>` and `F: Fn(&mut ParentState) -> &mut ChildState`, produces a `View<ParentState, ...>`. `build`/`rebuild`/`message` all simply re-derive `&mut ChildState` from `&mut ParentState` via `f` and forward:

```rust
fn build(&self, ctx: &mut Context, app_state: &mut ParentState) -> (Self::Element, Self::ViewState) {
    self.child.build(ctx, (self.map_state)(app_state))
}
```
No new element/state is created — this is a pure *type-level* narrowing of the state reference, zero runtime cost beyond the closure call, and works because Rust reference reborrowing lets `f` return `&mut ChildState` borrowed from `&mut ParentState` for the duration of the call.

**`lens`** (`xilem_core/src/views/lens.rs`) — the more common/ergonomic sibling: takes a `component: Fn(&mut ChildState) -> InnerView` (i.e. a whole sub-app function, not a pre-built view) plus the same state-accessor `F`. Its `ViewState` is `(InnerView, InnerView::ViewState)` — Xilem's `lens`, unlike Druid's `Lens` trait, is **not** a standalone composable path type with `.then()`; it is a single combinator that re-invokes the child component function every `rebuild` (functional-reactive style: "component" is re-called each frame like the outer `app_logic`, not memoized structurally). Doc comment: "It's a more specialized/simpler alternative to `map_state`."

**`fork`** (`xilem_core/src/views/fork.rs`) lets a view produce an "alongside" second view (of possibly `NoElement` type) that shares the same element slot notionally but is driven independently — used for attaching non-widget-producing logic (subscriptions, effects) to a view without affecting the element tree shape.

**Environment** (`xilem_core/src/environment.rs`) — a `ViewPathTracker::environment()` hook exists for context-like values threaded implicitly down the tree (analogous to SwiftUI's `EnvironmentValues` / React context), independent of the `State`/`Action` type parameters.

### 1.6 Memoization: `memoize` / `frozen` (`xilem_core/src/views/memoize.rs`)

```rust
pub fn memoize<State, Action, Context, Data, V, InitView>(data: Data, init_view: InitView) -> Memoize<...>
where Data: PartialEq + 'static, InitView: Fn(&Data) -> V + 'static, ...
{
    const { assert!(size_of::<InitView>() == 0, "{NON_CAPTURING_CLOSURE}"); }
    Memoize { data, init_view, phantom: PhantomData }
}
```

- `rebuild` only re-invokes `init_view` and diffs the inner view **if `prev.data != self.data`** (structural `PartialEq`) **or** the view previously returned `MessageResult::RequestRebuild` (tracked via a `dirty: bool` flag in `MemoizeState`). Otherwise the previous element subtree is left completely untouched — this is Xilem's one first-class **"skip a subtree if inputs are `==`" primitive**, directly analogous to React's `useMemo`/`memo()`, Compose's parameter-equality skip, or SwiftUI's `EquatableView`.
- The **`const { assert!(size_of::<InitView>() == 0) }`** is a remarkable compile-time-enforced constraint: it statically rejects any closure that captures *anything* (including by reference) — only zero-sized (i.e. fully "pure function pointer shaped," capturing nothing) closures are accepted, specifically to prevent the classic bug where a memoized closure secretly captures stale outer state that isn't part of `Data`, silently breaking the memoization contract. This is enforced by the Rust compiler at the `memoize()` call site, not by a lint or doc comment — a genuinely load-bearing compile-time check.
- **`frozen`** is the degenerate case: `init_view: Fn() -> V` with no data dependency at all — evaluated exactly once at `build`, and only re-evaluated if `dirty` was set via `RequestRebuild`. Doc comment: "This view can be used when the view returned by `init_view` doesn't access the `State`, other than in event callbacks" — i.e. a purely "static" subtree whose only interaction with state is through captured mutation callbacks, not through what's displayed.

There's also `views/impl_rc.rs` implementing `View` for `Rc<V>`/`Arc<V>` — `rebuild` short-circuits with **pointer equality** (`Rc::ptr_eq`) before falling back to a full structural rebuild, i.e. "`Arc` views" as mentioned in the research brief: wrapping a subtree in `Rc`/`Arc` and reusing the same allocation across frames is itself a (cheaper, coarser) memoization signal, no `PartialEq` required.

### 1.7 The `AnyView` escape hatch (`xilem_core/src/views/any_view.rs`)

```rust
pub trait AnyView<State: 'static, Action, Context, Element: ViewElement> {
    fn as_any(&self) -> &dyn Any;
    fn dyn_build(&self, ctx: &mut Context, app_state: &mut State) -> (Element, AnyViewState);
    fn dyn_rebuild(&self, dyn_state: &mut AnyViewState, ctx: &mut Context, prev: &dyn AnyView<...>, element: Element::Mut<'_>, app_state: &mut State);
    fn dyn_teardown<'el>(&self, ...) -> Element::Mut<'el>;
    fn dyn_message(&self, ...) -> MessageResult<Action>;
}
```

Blanket-implemented for every `V: View<...> + 'static`. `Box<dyn AnyView<...>>` then implements `View` itself, giving a fully type-erased escape hatch for genuinely heterogeneous/dynamic view sets (e.g. plugin systems, a `Vec` of totally unrelated view types). Mechanics worth noting:

- `AnyViewState { inner_state: Box<dyn Any>, generation: u64 }` — `generation` increments only when `dyn_rebuild` discovers `prev.as_any().downcast_ref()` **fails** (i.e. the concrete type actually changed between frames), at which point the old element is torn down via `dyn_teardown` and a brand new one built, and any message routed to the *old* generation number is rejected as `MessageResult::Stale` — this is the dynamic-dispatch analog of the static generation bump seen in `Vec<Seq>`.
- This is explicitly framed as **the boxing/dyn-dispatch tax you pay only where you ask for it** — everywhere else in Xilem the tree is monomorphized value types with no v-table and no heap allocation per node (module the actual widget objects in Masonry, which are heap-allocated exactly once and then mutated in place via `WidgetMut`, never reallocated by rebuild).

### 1.8 Where the type system does the verifying vs. where Xilem falls back to runtime

| Guarantee | Mechanism | Enforcement |
|---|---|---|
| Old/new tree shapes match structurally for diffing | `rebuild(&self, prev: &Self, ...)` — same concrete Rust type | **Compile time** (rustc type system) |
| Child count matches a container's requirement (e.g. exactly 1 child) | `ViewSequence::ELEMENTS_COUNT: Count` const + trait bounds | **Compile time** (const evaluation + trait bounds), though not universally enforced everywhere yet |
| Memoized closure captures nothing extraneous | `const { assert!(size_of::<F>() == 0) }` in `memoize`/`frozen` | **Compile time** (const panic, i.e. build fails) |
| State type flows correctly through `lens`/`map_state` composition | Generic `View<State, Action, Context>` parameterization | **Compile time** |
| Stale/misrouted async messages after a list reorder/dynamic type change | `ViewId` generation counters (`Vec`, `AnyView`) checked at dispatch | **Runtime** (`MessageResult::Stale`, non-panicking, but a real runtime check — proof that Xilem *doesn't* get this one for free at compile time) |
| A container widget actually got the element type it expects | `SuperElement<Child, Context>::with_downcast` | **Runtime downcast**, but only at fixed integration seams (e.g. `AnyView`, `ViewSequence`'s generic `Element` bucket), not in the hot path of statically-typed same-shape rebuilds |

The overall design principle: **make the common (same shape every frame) path 100% statically typed and allocation-free after first build; push all dynamism (`AnyView`, `Vec` reorders, generation mismatches) into narrow, explicit, opt-in seams that use runtime checks.**

---

## 2. Masonry — the retained widget layer

Source: `masonry_core/src/doc/pass_system.md`, `masonry_core/src/doc/masonry_concepts.md`, `masonry_core/src/core/widget_mut.rs`, `masonry_core/src/passes/mutate.rs`.

### 2.1 Pass system (verbatim structure from `pass_system.md`)

Masonry is organized as three categories of **passes**, run every frame in a fixed order:

1. **Event passes** (`on_pointer_event`, `on_text_event`, `on_access_event`) — bubble from the target widget up to the root, browser-style. Plus **`update_anim`**, a special non-bubbling, externally-triggered pass for animated widgets.
2. **Rewrite passes**, run in this exact order after every event pass, until all invalidation flags settle:
   `mutate → update_widget_tree → update_disabled → update_stashed → update_focusable → update_focus → layout → update_scrolls → compose → update_pointer → update_props [→ update_fonts]`
   Each pass is a no-op unless a pass-specific invalidation flag is set; passes can request work for *later* passes cheaply, or for *earlier* passes (triggering the whole rewrite sequence to rerun, capped by a static rerun limit to avoid infinite loops, with reruns past the limit deferred to next frame).
3. **Render passes** (`paint`, `accessibility`) — pure, "may be skipped or called multiple times for arbitrary reasons," produce a Vello scene graph / AccessKit tree respectively.

### 2.2 `WidgetMut<'a, W>` — the only way to mutate

```rust
pub struct WidgetMut<'a, W: Widget + ?Sized> {
    pub widget: &'a mut W,
    pub ctx: MutateCtx<'a>,
}
impl<W: Widget + ?Sized> Drop for WidgetMut<'_, W> {
    fn drop(&mut self) {
        if let Some(parent_widget_state) = self.ctx.parent_widget_state.take() {
            parent_widget_state.merge_up(self.ctx.widget_state);
        }
    }
}
```

"In Masonry, widgets can't be mutated directly. All mutations go through a `WidgetMut` wrapper... this helps Masonry make sure that internal metadata is propagated after every widget change." Every mutating setter on a concrete widget (`Label::set_text(WidgetMut<Label>, ...)`) is written to take `WidgetMut<Self>` as receiver, so **it is structurally impossible to mutate widget content without also going through the bookkeeping in `Drop`** that merges dirty/invalidation flags up toward the root — this is the mechanism that makes the "rewrite passes" section above actually correct: any mutation, wherever it originates (Xilem's rebuild, or the "mutate pass" escape hatch), is guaranteed to propagate invalidation.

`WidgetMut` is obtained from: `RenderRoot::edit_root_widget()` (top-level external entry point — "how Xilem applies any changes to the widget tree produced by its reactive step," per the pass-system doc), from inside `EventCtx`/`UpdateCtx` for a widget mutating itself/children during passes, or from a parent `WidgetMut` via `MutateCtx` for a container mutating a specific child.

### 2.3 The "mutate pass" as an *explicit* escape hatch to fine-grained-style updates

`pass_system.md`, "The mutate pass": *"The mutate pass runs a list of callbacks with mutable access to the widget tree. These callbacks can be queued with the `mutate_later()` method... Note: The mutate pass is meant to be an escape hatch. It covers widgets which don't quite fit into the pass system... It's more powerful and gives complete access to the tree, but is also slightly more expensive and less idiomatic than doing things in other passes."*

This is significant for a fine-grained-reactivity redesign: **Masonry already has a documented, sanctioned mechanism for "reach directly into a specific widget by identity and mutate it, bypassing the tree-shaped diff entirely."** `RenderRoot::edit_root_widget()` is literally described as "in effect a 'mutate' pass which only processes one callback" — i.e. Xilem's entire reactive step is, from Masonry's point of view, indistinguishable from a single big `mutate_later` callback. Nothing in Masonry's actual widget-tree/pass architecture is inherently coupled to diff-and-patch; **a fine-grained/signal-driven UI could drive Masonry directly by having each signal's write-callback call `mutate_later` (or hold a persistent `WidgetId`/`WidgetTag` and call the equivalent of `edit_root_widget` scoped to that id) instead of routing through a `View` tree at all.** This is exactly the "Masonry as a shared foundation" idea referenced in the research brief (see §7.3 for direct citations on this from linebender discussions).

### 2.4 Properties: intentionally *not* compile-time verified

`masonry_concepts.md`, "Properties are low-verification": *"While it would be tempting to implement some kind of trait-based compile-time verification system to check that the `EverlastingGobstopper` property is only set on widgets that can properly gobstop them, we refrain from implementing such systems in Masonry. The property system is meant to be flexible... For external crates that do want static verification, we provide the non-binding `UsesProperty` trait."*

Property resolution is **three-layer cascading** (local props → a "property stack" of layers gated by `Selector` (CSS-like) → widget-type defaults), explicitly modeled on CSS pseudo-classes/cascading, and resolved fully at runtime via a `property_cache`. This is Masonry's deliberate choice to trade some of Xilem's type-level rigor for CSS-like flexibility at the styling layer specifically — worth flagging as a **counter-example** to "maximal compile-time verification": even the most statically-typed Rust GUI framework in this survey chose runtime cascading for style properties, on ergonomic grounds.

### 2.5 Widget statuses & lifecycle terms

`masonry_concepts.md` defines hover/active/pointer-capture/focus(active vs inactive)/disabled/stashed as first-class "statuses," each of which triggers `Widget::update()` with a specific `Update` event variant when it changes (`FocusChanged`, `ChildFocusChanged`, `ChildHoveredChanged`, etc.) — i.e. **individual boolean-ish pieces of widget state that already get point-updates, not full rebuilds**, driven by dedicated rewrite passes (`update_focus`, `update_pointer`, `update_disabled`, `update_stashed`). This is Masonry's own (currently ad hoc, not generalized) precedent for "fine-grained property update without going through the View diff" — worth reusing/generalizing as a design pattern.

---

## 3. Druid — lenses, `Data`, `Env`, and why it was archived

Source: `druid/druid/src/lens/lens.rs` (full contents excerpted above), `druid/docs/src/05_lens.md`.

### 3.1 The `Lens<T, U>` trait

```rust
pub trait Lens<T: ?Sized, U: ?Sized> {
    fn with<V, F: FnOnce(&U) -> V>(&self, data: &T, f: F) -> V;
    fn with_mut<V, F: FnOnce(&mut U) -> V>(&self, data: &mut T, f: F) -> V;
}
```

CPS-style (continuation-passing) accessors rather than returning `&U`/`&mut U` directly — this sidesteps borrow-checker pain when the lens needs to *synthesize* the value (e.g. `Map`, `Index`, `InArc`) rather than literally holding a subfield reference. `#[derive(Lens)]` (in `druid-derive`) auto-generates one zero-sized `Field`-lens type per struct field.

### 3.2 Compile-time path composition — `LensExt::then`

```rust
fn then<Other, C>(self, other: Other) -> Then<Self, Other, B>
where Other: Lens<B, C> + Sized, Self: Sized { Then::new(self, other) }
```

`Then<T, U, B>` composes two lenses into one, and this composes arbitrarily: `lens!(Foo, x).then(lens!((u32, bool), 1))`. Because every lens is its own concrete (usually zero-sized) type, **a composed lens path's entire "address" through nested data structures is a single monomorphized Rust type**, resolved and inlined by the optimizer with (in principle) zero runtime cost — this is the single most directly reusable idea from Druid for a GPUI redesign: **type-level composable property paths, verified by the type checker, with the composition operator (`.then()`) itself ordinary trait code, no macro/DSL required** (only the *leaf* accessors typically come from a derive macro, for field-name ergonomics).

Other combinators in `lens.rs`, useful as a checklist for what a Rust "typed path" library needs: `Map` (get/put pair, for lenses whose target doesn't literally exist in the source — e.g. adapting a `0..2` range to a `0..1` slider), `Deref`/`Ref` (piggyback on `Deref`/`AsRef`), `Index<I>` (container indexing), `InArc` (**copy-on-write**: clones out of an `Arc`, and only writes back — triggering a real `Arc::make_mut` deep clone — if the lens's own `Data::same()` check says the value actually changed: `if self.inner.with(data, |x| !x.same(&temp)) { ... }`), `Not` (bool negation), `Constant<T>`, `Unit` (discards everything, target is `()`), and a blanket impl of `Lens<A, (B0,...,Bn)>` for **tuples of lenses**, letting a widget depend on several fields as one synthesized tuple.

### 3.3 `Data` trait and `Env`

Druid's `Data: Clone + 'static` trait (with `fn same(&self, other: &Self) -> bool`) is the mechanism the whole framework uses to decide "did this subtree's input actually change" — every widget's `update()` method receives old and new `Data` and is expected to call `.same()` to decide whether to do work. This is structurally the same idea as Xilem's `Memoize`'s `Data: PartialEq` bound, generalized to be the *universal* comparison the framework runs on every node every frame (rather than an opt-in view). `Env` is Druid's typed, thread-local-ish environment for theme/config values threaded implicitly through the tree (predecessor of Xilem's `Environment`).

### 3.4 Why Druid was effectively abandoned in favor of Xilem/Masonry

(Cross-referenced against `xilem/docs/history.md`, which frames Xilem/Masonry explicitly as descendants of Druid, and Raph Levien's 2019/2020 posts "Towards a unified theory of reactive UI" / "Towards principled reactive UI," which predate and set up Xilem.) The commonly cited structural problems (confirmed by the shape of the Druid codebase and corroborated by linebender community writing):

- **`Data: Clone` requirement is expensive/awkward** for large app state — every widget potentially clones its data slice on every pass; encourages `Arc`-wrapping everywhere (see `InArc`) as a workaround, which itself leaks COW-clone-detection complexity (`same()` after already cloning) into user code.
- **Runtime `same()` checks scattered through every widget's `update()`** are a *weaker, more error-prone* granularity control than Xilem's single `Memoize` view or a real fine-grained dependency graph: it's opt-out by omission (a widget that forgets to check `same()` just does unnecessary work silently; there's no compiler help) rather than opt-in-with-verification.
- **The single global, dynamically-typed `Env`** for theme values doesn't compose as cleanly as Xilem's environment mechanism designed after the fact with the View-tree id-path system in mind.
- Lenses are excellent for *addressing* nested data compile-time-safely, but Druid coupled them to the *whole-tree diff* model (a lens narrows what a `Widget<U>` sees, but the widget itself still gets `update()` called and must re-diff every frame) rather than to a genuinely incremental/fine-grained update mechanism — i.e. **Druid got the compile-time addressing (lenses) right, but not the incrementality** (still fundamentally whole-(sub)tree diff-and-patch per frame, with `Data::same()` as the only opt-out).
- Raph Levien and the linebender community's own explicit post-mortem framing (per `history.md`'s link list, and repeated in interviews/talks) is that Druid's architecture didn't scale to complex real apps and motivated a ground-up rethink — Xilem's View-tree/typed-diff design *is* that rethink, deliberately keeping Druid's "typed compile-time addressing" spirit (lenses live on in `xilem_core::lens`/`map_state`) while replacing "widget owns and diffs `Data` every frame" with "the view tree itself, produced fresh from a closure, IS the diff input, and Masonry is a separate crate that only ever sees patches via `WidgetMut`."

---

## 4. vizia — from compile-time Lenses to a SolidJS-style fine-grained Signal runtime

This is the single most load-bearing finding for a GPUI redesign: **vizia is a real, shipping Rust retained-mode GUI framework that migrated away from a Druid-style `Lens` system toward an explicit fine-grained reactive signal graph**, and its own migration guide is checked into the repo at `vizia/MIGRATION_LENS_TO_SIGNALS.md`.

### 4.1 What changed (verbatim from the migration guide)

> "Reactive updates are signal-driven. Model fields that were plain values are typically `Signal<T>`. Views/modifiers take signal sources in common paths. Writes move from assignment to `.set(...)` / `.update(...)`. Lens derives are no longer the primary app-state pattern."

Before/after:
```rust
// Before (Druid-style, compile-time lens path into app state)
#[derive(Lens)]
struct AppData { count: i32 }
AppData { count: 0 }.build(cx);
Label::new(cx, AppData::count);          // AppData::count is a generated Lens type

// After (fine-grained signal)
struct AppData { count: Signal<i32> }
let count = Signal::new(0);
AppData { count }.build(cx);
Label::new(cx, count);                    // count is a live handle, not a path
```
Writes: `self.count += 1` → `self.count.update(|count| *count += 1)`. Derived values: `count.map(|v| format!("Count: {v}"))` for cheap 1-signal projections, `Memo::new(move |_| a.get() && b.get())` for multi-signal computed state. As of the current `vizia_core` source tree read here, **`grep`ing for `pub trait Lens` in `vizia/crates/**` returns nothing** — the Lens trait has been fully removed from the current codebase, not just deprecated.

### 4.2 `Signal<T>` — `vizia_reactive/src/signal.rs`

```rust
pub struct Signal<T> { pub(crate) id: Id, pub(crate) ty: PhantomData<T> }   // Copy, zero-cost handle
impl<T: 'static> Signal<T> {
    pub fn new(value: T) -> Self { /* registers in thread-local Runtime, tags with current Scope */ }
}
impl<T> SignalRead<T> for Signal<T> {
    fn try_read(&self) -> Option<ReadRef<'_, T>> {
        self.id().signal().map(|signal| { signal.subscribe(); /* register current-effect as observer */
            ReadRef::Local(LocalReadRef::new(signal.as_local::<T>())) })
    }
}
impl<T> SignalUpdate<T> for Signal<T> {
    fn set(&self, new_value: T) { signal.update_value_local(|v| *v = new_value); /* triggers dependents */ }
    fn update(&self, f: impl FnOnce(&mut T)) { signal.update_value_local(f); }
}
```

`Signal<T>` is a `Copy`, `'static`, allocation-free **handle** (just an `Id`, an index into a thread-local `Runtime`'s slab of signal storage) — not a smart pointer, not a lens/path. `ReadSignal<T>`/`WriteSignal<T>` are read-only/write-only projections of the same underlying id (`signal.read_only()`/`signal.write_only()`), i.e. **capability-narrowing by wrapper type**, the signals-world analog of Rust's own `&`/`&mut` split, itself a form of compile-time-checked read/write access control.

`TrackedRefCell<T>` wraps the actual storage with a `RefCell` **plus a debug-only borrow-conflict tracker that records the call-site `Location` of the current borrow**, so a double-mutable-borrow panic prints *where the first borrow was taken* (`"signal value already borrowed at {file}:{line} (attempted at {file}:{line})"`) — a nice piece of DX engineering directly reusable for any Rust fine-grained-state system built on interior mutability.

### 4.3 `Effect`/`UpdaterEffect` — the dependency-tracking runtime (`vizia_reactive/src/effect.rs`)

This is architecturally a small, from-scratch **SolidJS/Leptos-style "push-then-pull" reactive runtime** implemented in plain Rust with no macros:

- A thread-local `RUNTIME.current_effect: RefCell<Option<Rc<dyn EffectTrait>>>` holds "the effect currently running." Any `Signal::try_read()` call, wherever it textually occurs, checks this thread-local and — if set — calls `signal.subscribe()`, registering the *currently running effect* as an observer of that signal. **Dependency tracking is thus fully dynamic and automatic: there is no explicit dependency list anywhere in user code** — it falls out of "which signals got `.get()`/`.read()`-called during this effect's last run," exactly like SolidJS/Leptos/MobX/Vue 3's `reactive()`.
- `run_effect()`: on rerun, first calls `observer_clean_up(effect)`, which clears the effect's previous observer set and, for each signal it *had* subscribed to, removes this effect from that signal's `subscribers`. This means **the dependency graph is rebuilt from scratch on every single effect run** (not incrementally patched) — a deliberate simplicity/soundness tradeoff (avoids "stale unsubscribed dependency" bugs from conditional signal reads, at the cost of doing `HashSet` churn every run) that's standard practice in this family of runtimes (Leptos does the same).
- `UpdaterEffect<T, I, C, U>` — a two-phase effect: `compute: Fn(Option<T>) -> (I, T)` (the tracked part, returns an "intermediate" `I` plus new internal state `T`) then `on_change: Fn(I, T) -> T` (an *untracked* side-effecting phase). This is exactly the shape `Binding::new` uses (below): `compute` reads the signal (subscribing) and returns its value; `on_change` doesn't touch signals at all, it just queues a UI rebuild — cleanly separating "what triggers rerun" from "what happens on rerun" so the side-effecting phase can't accidentally create new dependencies.
- `Effect::batch(f)` — a reentrant thread-local `batching: Cell<bool>` flag; nested `Signal::set` calls inside a `batch()` don't run effects until the outermost `batch()` call returns, then `run_pending_effects()` fires once — standard "microtask batching" to coalesce N writes into 1 UI update.
- `Effect::untrack(f)` — temporarily clears `current_effect` so signal reads inside `f` don't register any dependency — the escape hatch every fine-grained system needs (SolidJS `untrack`, MobX `untracked`, Leptos `untrack`).

### 4.4 `Binding` — how a retained widget subtree hooks into a signal (`vizia_core/src/binding/binding.rs`)

```rust
pub struct Binding<T: 'static + Clone> {
    entity: Entity,
    content: Option<Box<dyn Fn(&mut Context)>>,
    scope: Scope,   // owns the UpdaterEffect; disposing it unsubscribes
}
impl<T: 'static + Clone> Binding<T> {
    pub fn new<S: SignalGet<T> + 'static, F: 'static + Fn(&mut Context)>(cx: &mut Context, signal: S, builder: F) {
        let entity = cx.entity_manager.create();
        // ...
        let scope = Scope::new();
        scope.enter(|| {
            UpdaterEffect::new(
                move || signal.get(),                 // tracked: subscribes to `signal`
                move |_new_value| { SIGNAL_REBUILDS.with_borrow_mut(|set| { set.insert(SignalRebuild { context_id, entity }); }); }, // untracked: just queues a rebuild of this one Entity
            )
        });
        // build initial content once, immediately
        cx.with_current(entity, |cx| (builder)(cx));
        cx.bindings.insert(entity, Box::new(binding));
    }
}
impl<T: 'static + Clone> BindingHandler for Binding<T> {
    fn update(&mut self, cx: &mut Context) {
        cx.remove_children(cx.current());
        if let Some(b) = &self.content { cx.with_current(self.entity, |cx| (b)(cx)); }
    }
    fn remove(&self, _cx: &mut Context) { self.scope.dispose(); }  // unsubscribe cleanly
}
```

This is **exactly the granularity dial GPUI needs to consider**: `Binding` is a retained-tree node (an `Entity` in vizia's ECS-like tree, structurally similar to a GPUI `Entity`) that owns one `UpdaterEffect`. When the signal it watches changes, only *that* `Binding`'s subtree is torn down (`remove_children`) and rebuilt (`(builder)(cx)`) — everything outside the `Binding` is completely untouched, no diff, no walk of the rest of the tree. **The unit of incrementality is exactly "whatever is inside the nearest enclosing `Binding`,"** which the app author places explicitly (not inferred by a compiler) — closer to React's `memo()` boundaries or Svelte's per-component reactivity than to SwiftUI/Compose's automatic per-property fine-graining, but crucially **driven by real signals with automatic dependency tracking, not by manual dirty-flagging**. `Label::new(cx, count)` elsewhere (not shown in full here, but implied by `Res<T>` in `binding/res.rs`) presumably creates its own even-finer-grained internal binding so that a `Label` bound directly to a `Signal<T>` updates just its text run without an explicit surrounding `Binding{}` block — i.e. **leaf widgets can each be signal-observers in their own right**, and `Binding` is only needed when *structure* (which widgets exist at all) must change in response to a value, not when only a leaf's content changes.

### 4.5 The pre-migration `Lens`/`Store` system (vizia ≤0.3.0) — field-path-granular invalidation without a VDOM

Before the Signal migration (§4.1), vizia's binding system (tag `0.3.0`, source no longer in the shallow-cloned `main` tree but recovered via raw GitHub fetch) worked as a **compile-time lens path + runtime per-field `Store`**, structurally distinct from both Druid's lens (§3) and the current `Signal` system (§4.2–4.4) — worth preserving as its own design point since vizia is the only framework in this survey to have shipped *both* a Druid-style lens system and a SolidJS-style signal system in production, sequentially:

```rust
// vizia_core/src/binding/lens.rs @0.3.0
pub trait Lens: 'static + Copy + Debug {
    type Source;
    type Target;
    fn view<'a>(&self, source: &'a Self::Source) -> Option<LensValue<'a, Self::Target>>;
    fn id(&self) -> StoreId { StoreId::Source(TypeId::of::<Self>()) }
}
```

`#[derive(Lens)]` (explicitly adapted from Druid's lens macro) generates one zero-sized unit type per struct field (e.g. `AppData::count: Lens<Source = AppData, Target = i32>`); `LensExt` supplies `.then(other)` (path chaining producing a new zero-cost `Then<A, B>` type), `.idx(i)`, `.map(f)`, `.and`/`.or` — i.e. the same **compile-time-composed typed path** idea as Druid, but the composed path is then plugged into a runtime subscription registry rather than into a whole-tree `update()` walk:

```rust
// vizia_core/src/binding/store.rs @0.3.0
pub(crate) trait Store {
    fn update(&mut self, model: ModelOrView) -> bool;   // true iff the specific lensed field changed
    fn observers(&self) -> &HashSet<Entity>;
    fn add_observer(&mut self, observer: Entity);
}
pub(crate) struct BasicStore<L: Lens, T> { pub lens: L, pub old: Option<T>, pub observers: HashSet<Entity> }
```

`BasicStore::update` re-applies `lens.view(data)`, diffs the result against the cached `old` value via a `Data::same`-style equality check, and returns `true` **only if the specific field the lens addresses actually changed** — sibling-field mutations don't trigger it. `Binding::new(cx, lens, builder)` walks up the entity tree for an existing `Store` keyed by `lens.id()` (derived from the lens's `TypeId`/composed-path identity); if found, it just adds itself as an observer `Entity`; otherwise it creates a new `BasicStore`. On a model mutation, vizia iterates the stores attached to that model, calls `Store::update` on each, and rebuilds only the `Binding` views whose store reported a real change — **field-path-granular invalidation over a fully retained tree, achieved entirely through typed lens composition plus a runtime observer-set registry, with no VDOM anywhere and no automatic dependency *discovery* (unlike the later `Signal`/`Effect` system, §4.3, the dependency edge is the lens path itself, declared once at `Binding::new` time, not re-tracked on every read).** [vizia lens.rs @0.3.0](https://raw.githubusercontent.com/vizia/vizia/0.3.0/crates/vizia_core/src/binding/lens.rs), [vizia store.rs @0.3.0](https://raw.githubusercontent.com/vizia/vizia/0.3.0/crates/vizia_core/src/binding/store.rs), [vizia binding_view.rs @0.3.0](https://raw.githubusercontent.com/vizia/vizia/0.3.0/crates/vizia_core/src/binding/binding_view.rs)

The move from this to `Signal`/`Effect` (§4.2–4.4) trades **static path identity + explicit `Binding` placement** for **dynamic automatic dependency discovery + the same explicit `Binding` placement** — i.e. the granularity-boundary mechanism (`Binding` as the unit of rebuild) didn't change across the migration, only *how the dependency between a `Binding` and the data it reads is established* (declared lens path vs. auto-tracked signal reads).

### 4.6 `Res<T>` — the "value or lens or signal" unifying input type

The migration guide notes: *"Res is the unifying input type behind many modifiers/constructors. It can represent values, lenses, and signals... use `.get_value(cx)`."* This tells us vizia's *widget constructor* APIs are generic over "anything that can produce a `T`, tracked or not" via a `Res<T>` trait object/enum, letting the same `Label::new(cx, X)` call accept a plain literal, a signal, or (historically) a lens — a useful pattern for **API ergonomics that don't force every call site to pick a reactivity strategy up front**.

---

## 5. SwiftUI internals — the AttributeGraph hybrid

### 5.1 What AttributeGraph is

AttributeGraph (`AGGraph`) is a private Apple C++/Swift engine that SwiftUI is a "thin veneer on top of" — per reverse-engineer Saagar Jha, it "tracks almost every single aspect of your app from behind the scenes to make decisions on when things need to be updated." [Making Friends with AttributeGraph](https://saagarjha.com/blog/2024/02/27/making-friends-with-attributegraph/)

It is a **pull-based, demand-driven DAG**. Nodes ("attributes") hold a cached value plus a rule (closure) computing that value from its inputs; edges are *discovered*, not declared: "when a rule runs and reads another attribute, an edge is recorded between them." [SwiftUI Is One Graph](https://aleahim.com/blog/swiftui-is-one-graph/) Nodes carry tri-state status (up-to-date / potentially-dirty / pending). On a state change, the graph "recursively marks all dependent nodes as 'potentially invalid'" without recomputing anything yet; recomputation happens lazily on pull, and propagation **stops once a recomputed value equals its previous cached value** — value-equality short-circuiting baked into the graph engine itself, not into the view layer. [Attribute Graph — Chris Eidhof](https://chris.eidhof.nl/note/attribute-graph/), [SwiftUI Is One Graph](https://aleahim.com/blog/swiftui-is-one-graph/) It's widely believed to descend from one-way-constraint-solver research (in the lineage of Adapton / self-adjusting computation — "record dependencies between values in a computation graph and use graph algorithms to recompute a minimal subset of the graph when inputs change"). objc.io's Swift Talk ran a 10+ part series reimplementing it from scratch: edges, dirty-marking, recomputation, display-list construction, layout — [Swift Talk: SwiftUI collection](https://talk.objc.io/collections/swiftui), [Attribute Graph Part 1](https://talk.objc.io/episodes/S01E429-attribute-graph-part-1).

The community reimplementation **OpenAttributeGraph** (formerly OpenGraph, [github.com/OpenSwiftUIProject/OpenGraph](https://github.com/OpenSwiftUIProject/OpenGraph)) mirrors Apple's real split: `OpenAttributeGraph` (public Swift API) over `OpenAttributeGraphCxx` (core C++ engine) over `OpenAttributeGraphShims`/`Platform` abstraction — i.e. **a thin Swift-facing API wrapping a portable C++ graph kernel**, cross-platform-portable by design (Linux/WASI/Windows targets), which is itself a useful precedent: the fine-grained engine is language-agnostic infrastructure, the declarative-view layer is a client of it, not fused to it. `OpenSwiftUI` proper layers `OpenSwiftUI`/`OpenSwiftUIExtension`/`OpenSwiftUIBridge` on top.

### 5.2 The division of labor: diffing layer vs. graph layer (the crux)

Two layers compose in sequence, not as alternatives:

**Layer A — View-tree diffing (structural identity).** `View` structs are cheap, disposable value types rebuilt every "frame." SwiftUI compares old vs. new struct instances at each tree position to decide whether a subtree's *identity* changed (same type/position ⇒ same identity ⇒ state survives; different ⇒ destroy/recreate), and — crucially — uses this same comparison to **decide whether `body` even needs to re-run**: "When a view gets marked as potentially dirty in the Attribute Graph, SwiftUI will compare the current and new value. If it can 'prove' the view is the same as before, it doesn't need to reevaluate the view's `body`." This works even without explicit `Equatable`: "SwiftUI assumes any `Equatable.==` is a true equality check, so for POD views it compares each field directly instead (via reflection)... For non-POD views it prefers the view's `==` but falls back to its own field compare," recursively. [SwiftUI View Equality — Chris Eidhof](https://chris.eidhof.nl/note/swiftui-view-equality/)

**Layer B — Attribute-graph node updates (no diffing at all).** Every read of `@State`/`@Binding`/environment value is itself a graph node. When only a leaf attribute changes, the graph propagates a dirty flag ("just a flag, so it only takes a very short time to execute") up dependency edges and recomputes *only the nodes that actually read that value* — no struct diffing involved: "The system skips recomputation if the state variable is never accessed in the body." [SwiftUI's Redraw System](https://medium.com/@matgnt/swiftui-redraw-system-in-depth-attributes-recomputation-diffing-and-observation-66b469fdcada)

The sharpest statement of how the two compose: body recomputation is triggered by Layer B *only* for views whose body actually reads the changed attribute; but when a body **does** re-run for purely structural reasons (a parent was invalidated) without that view reading the changed value, SwiftUI falls back to Layer A: "SwiftUI applies diffing — comparing the old and new view hierarchies. If content hasn't actually changed, the old view persists without screen redraws." Measured impact: identical scenes cost 6.84ms/412 Core Animation commits vs. 14.12ms/505 commits depending on whether the changed state was read directly by the affected view's body (fast graph path) or diffing had to bail it out (slow structural path). [SwiftUI's Redraw System](https://medium.com/@matgnt/swiftui-redraw-system-in-depth-attributes-recomputation-diffing-and-observation-66b469fdcada)

**Conclusion: fine-grained attribute updates are the default fast path (recompute only nodes on the dependency edge from the changed input, stop when values stabilize); struct diffing is the fallback/safety-net layer**, invoked whenever a body must run for structural reasons and needs a mechanism to avoid over-propagating below that point. Observation granularity compounds this: legacy `@ObservableObject`/Combine gives no per-property tracking ("any property change triggers full object invalidation"), while the newer `@Observable` macro adds "KeyPath-based tracking, enabling property-level granularity" — i.e. Apple's own trajectory has been to push *more* work into Layer B over time, reducing reliance on Layer A. [SwiftUI's Redraw System](https://medium.com/@matgnt/swiftui-redraw-system-in-depth-attributes-recomputation-diffing-and-observation-66b469fdcada)

### 5.3 `@State` storage and the identity problem

Since `View` structs are recreated every evaluation, `@State` cannot literally live in the struct. "The struct holds only a thin token — a reference to a node in an external, long-lived graph maintained by the SwiftUI runtime." [SwiftUI: @State under the hood](https://www.nsvasilev.com/posts/swiftui-state) Concretely, `State<T>` contains a `_value` plus `Optional<AnyLocation<T>>` `_location` pointing into the graph's `StoredLocation<T>`; before every `body` call SwiftUI reflects over `DynamicProperty` conformances and rewires the fresh struct's `_location` fields to the persistent graph nodes. [Making Friends with AttributeGraph](https://saagarjha.com/blog/2024/02/27/making-friends-with-attributegraph/) The graph node is keyed by **view identity** — structural (type + tree position, stable while unchanged) or explicit via `.id(_:)`. This is the classic hazard: "inserting or removing views conditionally without explicit identity can cause state to bleed between seemingly unrelated views — if two views occupy the same structural position at different times, SwiftUI maps them to the same graph node." [SwiftUI: @State under the hood](https://www.nsvasilev.com/posts/swiftui-state) Reading `State.wrappedValue` has the observed side effect of registering into the current read-set, building the dependency edge that later drives Layer B's targeted invalidation.

### 5.4 `@ViewBuilder` — result builders as compile-time tree composition

`@ViewBuilder` is a `@resultBuilder`: sequential statements/`if`-`else`/loops in a builder closure are rewritten at compile time into nested `buildBlock`/`buildEither` calls producing statically-typed composite types — historically `TupleView<(A, B, C, ...)>` via up to 10 overloads of `buildBlock`, now generalized with variadic generics. Because tuples are heterogeneous and fixed-size at compile time, this avoids both array homogeneity constraints and (mostly) `AnyView` dynamic-dispatch cost — **structurally the same idea as Xilem's tuple `ViewSequence` (§1.3)**, arrived at independently in Swift's macro system instead of Rust's trait system. [Understanding SwiftUI DSL: TupleView](https://forums.swift.org/t/swiftui-viewbuilder-result-is-a-tupleview-how-is-apple-using-it-and-able-to-avoid-turning-things-into-anyview/28181) Containers like `List`/`ForEach` further process these through `_VariadicView.Tree`, exposing children as an `Identifiable` `RandomAccessCollection` so a container can inspect/restyle a compile-time-composed child list while preserving per-child structural identity. [SwiftUI under the Hood: Variadic Views](https://movingparts.io/variadic-views-in-swiftui)

**Load-bearing takeaway for GPUI:** the two-tier split is independently confirmed across every source above — cheap value-type view structs diffed structurally act only as the *coarse* invalidation/safety-net layer, while a separate persistent, pull-based, dependency-edge graph (keyed to stable identity, not to the struct) does the actual fine-grained incremental recomputation. Neither layer alone is "the" SwiftUI reactivity model; it is their composition, with the graph as the fast/common path and diffing as backstop.

---

## 6. Jetpack Compose runtime — slot table, snapshot state, recomposition scopes

### 6.1 Positional memoization and the slot table

Compose stores all composition state in a **slot table**: two flattened arrays (group metadata + slot values) implemented as a gap buffer — the official runtime design doc states "the arrays of the slot table are a gap buffer." Each group entry holds six fields: `Key` (int), `Flags` (group kind), `Nodes` (nodes generated), `Size` (transitive children + self), `Slots` (offset into slot array), `Parent` (parent group index). Addressing is gap-relative; "slots cannot be inserted, deleted or moved, only groups can." [How Composition Works](https://android.googlesource.com/platform/frameworks/support/+/refs/heads/androidx-main/compose/runtime/design/how-compose-works.md) Get/insert/delete are O(1) at the gap; moving the gap is O(n) — "bets that, on average, UIs don't change structure very much." [Under the Hood of Jetpack Compose — Part 2, Leland Richardson](https://medium.com/androiddevelopers/under-the-hood-of-jetpack-compose-part-2-of-2-37b2c20c6cdd)

Identity is **positional by default**: "Call location is the identity of composable content"; "the instance of a composable in Composition is identified by its call site," with execution order disambiguating repeated calls. [Lifecycle of composables](https://developer.android.com/develop/ui/compose/lifecycle) This inverts React: Fiber is a pointer-linked node tree (`child`/`sibling`/`return`) where explicit `key` props are the required default for lists; in Compose, `key(movie.id) { ... }` is the opt-in exception, unique "only amongst the invocations of composables at the call site."

### 6.2 `remember {}` vs. React's `useState`

`remember` compiles to `Composer.cache(...)`; values are identified "not by name, but by their position in the execution trace" — each pass advances a cursor through the flat slot array, which is why generated code uses bitwise `or` rather than short-circuiting `||` for multi-key `changed()` checks (a skipped call would desync the cursor). [How Compose Remembers](https://doveletter.dev/articles/compose-positional-memoization) For control flow, "the compiler inserts separate keys for each branch of the if statement"; a key mismatch on recomposition is treated as structural change and the gap buffer repositions. React instead stores hooks as a singly linked list on `Fiber.memoizedState` (each: `memoizedState`, `queue`, `next`), walked in call order on update — hence the Rules of Hooks ("React relies on the order in which Hooks are called"), with conditional hooks categorically banned. Compose's identity model is two-layer (implicit position + explicit `key()`); React's is single-layer positional with conditional hooks forbidden entirely.

### 6.3 The snapshot state system — genuine MVCC

`mutableStateOf` returns a `SnapshotMutableStateImpl` backed by a **linked list of versioned `StateRecord`s, each tagged with a snapshot ID** — this is literal MVCC. A `GlobalSnapshot` sits at the top; per-thread snapshots live in ThreadLocals. `takeSnapshot()` is read-only; `takeMutableSnapshot()` allows writes invisible until `apply()`; "when finished with the snapshot, it must always be disposed." [Introduction to the Compose Snapshot System, Zach Klippenstein](https://blog.zachklipp.com/introduction-to-the-compose-snapshot-system/) Writes create a new record: "any subsequent writes to any state objects will then be forced to use a new record with the new ID"; concurrent-write conflicts resolve via `SnapshotMutationPolicy` merge. [derivedStateOf deep dive](https://blog.zachklipp.com/how-derivedstateof-works-a-deep-d-er-ive/)

Read tracking: snapshots take "a 'read observer' and a 'write observer' — both simple `(Any) -> Unit` functions," and "state reads are observed no matter how deep in the call stack they occur." In composition, the read observer maps each read to the enclosing `RecomposeScope`. Writes trigger the write observer, marking exactly those scopes invalid; external writes go through `sendApplyNotifications → advanceGlobalSnapshot() →` registered apply observers with the modified set. Invalidation is an O(dependents) reverse-index lookup (state → scopes), **not a tree scan** — the direct Rust-relevant analog of "signal write → notify subscriber set" seen in vizia's `Signal`/`Effect` (§4.3), except Compose's version is transactional/versioned (MVCC) rather than plain interior-mutability. `derivedStateOf` further prunes: a scope isn't invalidated "unless the value actually changed" — Compose's version of Xilem's `Memoize`/SwiftUI's graph-level equality short-circuit.

### 6.4 Recomposition scopes, donut-hole skipping, strong skipping

Each composable compiles into a restart group: `$composer.startRestartGroup(); ...; $composer.endRestartGroup()?.updateScope { next -> A(x, next, $changed or 0b1) }` — that `updateScope` lambda is what the runtime re-invokes on invalidation. [Recomposition Scopes](https://composeinternals.com/compose-recomposition-scopes) A parent can skip while an inner scope recomposes independently — the "donut hole." [Donut-hole skipping](https://www.jetpackcompose.app/articles/donut-hole-skipping-in-jetpack-compose) The `$changed` bitmask carries 3 bits per parameter (stability bit + state: `00` Uncertain / `01` Same / `10` Different / `11` Static); when uncertain, `composer.changed(x)` does a slot-table `equals()` compare; if all params are Same/Static, `$composer.skipToGroupEnd()` skips the body while still advancing the cursor. [How Compose Works, lhwdev](https://lhwdev.github.io/note/compose/how-it-works/)

**Strong skipping mode** (default since Kotlin 2.0.20) changed two things: "all restartable composable functions become skippable... whether or not they have unstable parameters" (unstable params now compared via `changedInstance()`/`===`); and the compiler auto-wraps every lambda in `remember(captures) {...}` since lambdas were reallocated each recomposition. [Strong skipping mode](https://developer.android.com/develop/ui/compose/performance/stability/strongskipping), [Strong Skipping Mode Explained](https://medium.com/androiddevelopers/jetpack-compose-strong-skipping-mode-explained-cbdb2aa4b900) It "does not change the stability of any type," only the comparison strategy; fresh instances per frame (`listOf()`, `.copy()`) still defeat it. Escape hatches: `@NonSkippableComposable`, `@DontMemoize`.

### 6.5 Compile-time mechanics — and whether Rust could do this without a compiler plugin

The Compose compiler is a **Kotlin IR compiler plugin**: "most of the plugin's work occurs at the IR stage... the semantics of the IR tree deviate significantly from the original source." [Decomposing Jetpack Compose](https://proandroiddev.com/decomposing-jetpack-compose-7b7abcd6c81b) It rewrites every `@Composable` signature and body: synthetic `$composer: Composer` and `$changed: Int` params (10 param slots per Int at 3 bits each), plus a `$default: Int` bitmask for default arguments. Documented before/after: `Hello(name)` becomes `startRestartGroup(274849561)` → `$dirty = $changed | ($composer.changed(name) ? 4 : 2)` → `if (($dirty & 11 ^ 2) == 0 && $composer.getSkipping()) $composer.skipToGroupEnd(); else Text(name,...)` → `endRestartGroup()?.updateScope(...)`. [Jetpack Compose Playground](https://foso.github.io/Jetpack-Compose-Playground/general/compiler_plugin/) The group key is a compile-time constant derived from source location.

**Can `#[track_caller]` substitute for this in Rust? No — three concrete gaps.** (1) *Granularity*: `#[track_caller]` (per [RFC 2091](https://rust-lang.github.io/rfcs/2091-inline-semantic.html)) appends one implicit `&'static Location` argument per static call site — identical across all loop iterations of that call site, whereas Compose needs a distinct key per branch/iteration. (2) *No callee-side insertion*: the skip machinery (start/end groups, `changed` bitmask, `skipToGroupEnd`) lives *inside* the rewritten callee body; `#[track_caller]` adds zero logic to the callee, and Rust has no stable MIR/IR compiler-plugin API to add any. (3) *Defaults*: the `$default` bitmask requires rewriting both the call site and the signature together. **The realistic Rust equivalent is a proc-macro attribute** (e.g. `#[composable]`) operating on the token stream pre-typecheck: it can append a composer-context parameter and a `changed` bitmask, wrap the body in start/end-group calls, and inject skip branches — but `changed()` must go through ordinary trait bounds (`PartialEq`) rather than compiler-known equality, and positional keys must be macro-synthesized (`line!()`/`column!()` plus explicit `key()` scopes for loops), since a proc-macro operates on syntax, not on a typed/IR representation the way the Kotlin plugin does. **`#[track_caller]` answers "who called me," never "which of N calls at this site is this" — it cannot alone provide Compose-grade positional identity.**

---

## 7. Raph Levien's own writing: why Xilem chose diffing over fine-grained reactivity

### 7.1 "Xilem: an architecture for UI in Rust" (May 2022)

[Xilem: an architecture for UI in Rust](https://raphlinus.github.io/rust/gui/2022/05/07/ui-architecture.html)

Motivation: "Architectures that work well in other languages generally don't adapt well to Rust, mostly because they rely on shared mutable state and that is not idiomatic Rust, to put it mildly." Goal: "expression of modern reactive, declarative UI, in components which easily compose, and a high performance implementation," SwiftUI/Flutter/React-familiar but "idiomatic Rust." On why the `View` trait leans on the type system so heavily: "the design relies *heavily* on the type inference mechanisms of the Rust compiler... In almost every other comparable system (SwiftUI being the notable exception), these are determined at runtime with a fair amount of allocation, downcasting, and dynamic dispatch." I.e. diffing over a **statically-typed** tree (§1) is explicitly positioned as *the* Rust-idiomatic alternative to both React's untyped vdom and to a runtime observable graph.

### 7.2 The steelmanned rejection of observer-pattern/signal reactivity

Levien directly rejects the React/Dioxus-style observer approach for Rust: "This standard approach works poorly in Rust, though it can be done... The problem is that it requires *shared mutable* access to that state, which is clunky at best in Rust (it requires interior mutability). In addition, because Rust doesn't have built-in syntax for getters and setters, invoking the notification mechanism also requires some kind of explicit call." Yet he explicitly acknowledges the fine-grained framing has real substance, quoting Yaron Minsky: "hidden inside of every UI framework is some kind of incrementalization framework. Xilem unapologetically contains at its core a lightweight change propagation engine, similar in scope to the attribute graph of SwiftUI, but highly specialized to the needs of UI." His resolution is not "diffing instead of incrementality" but "incrementality via typed-tree-diff-plus-opt-in-memoization instead of via a general dependency graph": "Comparing a number is extremely cheap (especially because all this happens with static typing, so no boxing or downcasting is needed)." He also dismisses the Elm architecture as too verbose and poor at composable components: "actively trying to make components is a recipe for disaster in Elm."

### 7.3 "Advice for the next dozen Rust GUIs" (July 2022) — dead-end experiments that inform this debate

[Advice for the next dozen Rust GUIs](https://raphlinus.github.io/rust/gui/2022/07/15/next-dozen-guis.html)

Covers three prior Druid-lineage architecture attempts: an ECS-pattern attempt, "the current architecture relying heavily on lenses" (i.e. Druid as shipped, §3), and "the Xilem proposal." Two dead ends bear directly on fine-grained reactivity: **Crochet** (immediate-mode-on-retained-tree) failed via **"state tearing"**: "Because updates to app state... are interleaved with rendering, the rendering of any given frame may contain a mix of old and new state," and the architecture "effectively enforces the app logic running on a single thread" — i.e. *fine-grained direct mutation interleaved with rendering, without a coherent snapshot/batching discipline, produces torn frames* (contrast with Compose's MVCC snapshot system, §6.3, which exists specifically to prevent this). **lasagna** was "an attempt to decouple the reactive architecture from the underlying widget tree implementation" — a direct precursor to today's Masonry/Xilem crate split (§2, §7.4). On accessibility as an architectural forcing function: "In general, they expect a retained mode widget tree; this is a significant impedance mismatch with immediate mode GUI, and generally requires stable widget ID and a diffing approach" — i.e. **a11y trees are cited as an independent reason a retained tree (of some kind) is close to mandatory**, regardless of which reactivity strategy drives it.

### 7.4 Linebender/Xilem 2023–2025 status; "Masonry as shared foundation"

[Xilem 2024 plans](https://linebender.org/blog/xilem-2024/) | [Linebender in June 2025](https://linebender.org/blog/tmil-18/) | [xilem/ARCHITECTURE.md](https://github.com/linebender/xilem/blob/main/xilem/ARCHITECTURE.md) | [masonry/ARCHITECTURE.md](https://github.com/linebender/xilem/blob/main/masonry/ARCHITECTURE.md) | [RFC 0001: Masonry backend](https://github.com/linebender/rfcs/blob/main/rfcs/0001-masonry-backend.md)

The 2024 plan describes "factoring out the reactive layer into a generic `xilem_core` module," decoupling diffing from any one backend (already reused by `xilem_web`). Masonry's own ARCHITECTURE.md is the clearest statement of the shared-foundation philosophy, matching the source read directly in §2: "Developers trying to write immediate-mode GUIs, Elm-architecture GUIs, functional reactive GUIs, etc, can import Masonry and get a platform to create windows... each with a tree of widgets," and design goal "**Be dumb.** As a general rule, Masonry doesn't do 'algorithms.' It has no reconciliation logic, no behind-the-scenes dataflow, no clever optimizations, etc... High-level logic should be implemented in downstream crates." RFC 0001's historical framing: "Masonry was written as an exploration into the concept of a GUI backend, with a Widget tree that could serve as the retained component of a reactive architecture. Xilem was written as an exploration into reactive GUI," and "Masonry was built as a potential foundation for *multiple* native GUI crates... it shouldn't be too tied to Xilem." **No alternative signals-based front-end has yet been publicly built on Masonry** as of this research (mid-2026), but the architectural door is explicitly, deliberately open — confirming the reading in §2.3 that Masonry's `mutate`/`WidgetMut` mechanism could be driven by a fine-grained system instead of Xilem's `View` diff without any change to Masonry itself.

### 7.5 "Towards a unified theory of reactive UI" (2019) / "Towards principled reactive UI" (2020) — the direct both-sides argument

[Towards a unified theory of reactive UI (2019)](https://raphlinus.github.io/ui/druid/2019/11/22/reactive-ui.html) | [Towards principled reactive UI (2020)](https://raphlinus.github.io/rust/druid/2020/09/25/principled-reactive-ui.html)

These pre-Xilem posts contain Levien's most explicit both-sides treatment. 2019 frames all reactive UI as "a pipeline of tree transformations," distinguishing **diffing** ("you do a traversal... and at each node you keep track of the *focus*... compare that input subtree to its previous state, and if it's the same you skip") from **explicit deltas/listeners** (fine-grained push, citing Compose's `Recompose`/`changed()` by name). Diffing is characterized as "quite the common pattern in JS reactive frameworks," placing "the least burden on the programmer... often a good starting point," with finer strategies "available as an opt-in, for when it matters to performance" — i.e. **diffing-by-default with opt-in fine-graining was the design philosophy years before Xilem's `Memoize` shipped it.**

The 2020 post's "Observable objects" section is the closest thing to a direct verdict on the fine-grained-vs-diffing question: *"The problems with observable boil down to the fact that the callback requires a lot of context to know what change should happen in response to the event. In this way, I think it is fundamentally in tension with the goals of reactive UI, though some systems have managed to reconcile the two, often with compiler help... SwiftUI and Svelte come to mind."* And, crucially, he rejects porting SwiftUI's attribute-graph approach **on engineering-cost grounds, not correctness grounds**: *"What I know of SwiftUI suggests that it has a similar engine under the hood (which shows up as 'ViewGraph' or 'AttributeGraph' in stack traces)... As a result, though I sometimes hear people suggest adapting SwiftUI to Rust... I fundamentally do not think it would work, at least without expending enormous resources."* He also flags a Rust-specific structural friction: *"While Swift notably does have getter/setter, Rust, for better or worse, does not,"* making transparent-mutation-triggers-notification (the basis of Vue/MobX/SwiftUI's `@Observable`) awkward to build in Rust without either macros or explicit `.set()`/`.get()` calls (exactly what vizia's `Signal::set`/`.get()` ended up doing, §4). His proposed middle path — borrowed from Rust's async `Waker` design — is **minimal-context notification** ("something in this area changed, you're going to need to recompute") rather than SolidJS/MobX-precise dependency tracking; this became Xilem's `Memoize`/id-path system rather than a full signals graph.

**Steelman summary, both sides, in one paragraph each:**

- **For diffing (Xilem's choice):** Works with Rust's ownership model without interior mutability by default; the common case (tree shape unchanged) is fully statically typed and allocation-free after first build (§1.8); low conceptual burden — "diff the two trees" is one mental model covering the whole framework, with opt-in escapes (`Memoize`, `Rc`/`Arc` views) for the cases that need better-than-O(tree) update cost; sidesteps the "torn frame" hazard Crochet hit; matches Rust's lack of getter/setter syntax, so there's no ambient hook for "notify on mutation" without an explicit macro/wrapper system; building a SwiftUI/Compose-grade fine-grained engine is asserted to cost "enormous resources" relative to the team's capacity.
- **For fine-grained reactivity (the road not taken, later partially retraced by vizia, §4):** Avoids re-running/diffing any code at all for the vast majority of updates that touch only one leaf value (SwiftUI's Layer B, Compose's snapshot system) — asymptotically better than "diff a subtree every time," especially for large/deep trees where only a handful of leaves change per frame; composes naturally with async/incremental data sources (a signal write from a background task doesn't need to re-run any view-tree closures at all, only its direct dependents); Rust *can* express it without getters/setters using explicit `.get()`/`.set()`/`Effect` types (vizia proves this, and Leptos/Dioxus-signals prove it in a broader Rust-web context) — the "Rust has no properties" objection turns out to be a solvable ergonomics problem, not a hard blocker, provided the API embraces explicit read/write calls rather than trying to hide them.

---

## 8. iced, slint, egui, makepad, freya

### 8.1 iced — Elm architecture, full-rebuild-then-diff

iced follows The Elm Architecture: `Message`, `update(&mut self, Message) -> Task<Message>`, `view(&self) -> Element<Message>`. On every `update`, the **entire `view()` function is re-invoked from scratch**, reconstructing a brand-new `Element` tree top to bottom — there is no user-facing incremental view-construction API; the "reactivity" is "just call the pure function again." [The Elm Architecture — iced book](https://book.iced.rs/architecture.html) This exists specifically because Rust's borrow checker won't let a widget tree hold `&mut` references into application state while that state is mutated again later — the old tree must be dropped and a new one built. An iced PR that optimized rebuild timing frames it directly: "When the application changes state, the widget tree needs to be reconstructed in order to stay up-to-date" — iced only avoids *redundant* rebuilds (calling `view` again when literally nothing changed), never rebuild-on-real-change. [Rebuild widget tree only after an application update #597](https://github.com/iced-rs/iced/pull/597)

What *is* preserved across rebuilds is internal per-widget runtime state (scroll offset, text-input cursor, animation phase, focus) via a separate `widget::tree::Tree`/`tree::State` structure keyed by tree position plus a `tag: TypeId`. Each new `Element` tree is diffed against the previous `Tree`: `Tree::diff` checks whether a widget's `tag` matches the corresponding positional node's tag; if so, `Widget::diff` reconciles and preserves that node's opaque `Box<dyn Any>` `State` (recursing into `diff_children`); if the tag differs, that subtree of state is discarded and recreated. [`Tree` — iced::advanced::widget](https://docs.iced.rs/iced/advanced/widget/struct.Tree.html) So precisely: **rebuilt every message** = the declarative `Element` description tree; **preserved via positional (non-keyed) diff** = opaque internal state blobs — a lighter-weight, dynamically-downcast cousin of Xilem's typed `ViewState`.

This is iced's acknowledged scaling bottleneck. A long-standing performance-tracking issue states plainly "the most expensive operation is clearly `UserInterface::build`" (i.e. `view()`), with `update`/`draw` also degrading "the more widgets and events a user interface has to handle." [Perform benchmarks #7](https://github.com/iced-rs/iced/issues/7) Because there's no fine-grained subscription model, a single state change forces `view()` to walk and (heap-)allocate a description for *every* widget in the tree — O(total widget count) per update, regardless of how localized the actual change was; the diff pass only saves re-creating internal state, not the cost of re-describing the tree. Community discussion around iced 0.14 corroborates this is treated as fundamental, not a bug: complaints center on baseline memory/allocation cost rather than questioning the full-rebuild model itself. [Iced 0.14 has been released – Hacker News](https://news.ycombinator.com/item?id=46185323)

### 8.2 vizia — see §4 in full (classic Lens/Store §4.5, current Signal/Effect §4.2–4.4)

### 8.3 slint — the compiled property graph

Slint's `.slint` DSL is compiled ahead-of-time into target-language (Rust/C++/JS) code where each declared `property` becomes a generated struct field plus generated dependency-tracking code — not a runtime-interpreted graph. The `binding_analysis` compiler pass statically computes the property dependency graph and detects binding loops **at compile time**; "a dependency is registered for any property accessed while evaluating a binding," and at runtime, when a property changes, its dependents are marked dirty and lazily re-evaluated on next read. [Property System & Reactive Bindings | DeepWiki](https://deepwiki.com/slint-ui/slint/2.2-property-system-and-data-binding) At runtime, generated code uses a `PropertyTracker`, thread-local `CHANGED_NODES` lists, and **intrusive linked lists** (`DependencyListHead`/`DependencyNode`) for O(1) dirty propagation with deterministic memory layout — deliberately avoiding heap-heavy generic graph structures (contrast vizia's `HashSet<Id>` subscriber sets, §4.3). [Core Runtime Architecture | DeepWiki](https://deepwiki.com/slint-ui/slint/2-core-runtime-architecture) Two-way bindings (`<=>`) alias two properties so they always hold the same value, initial value taken from the right-hand side. [Reactivity | Slint Docs](https://docs.slint.dev/latest/docs/slint/guide/language/concepts/reactivity/)

Critically, this analysis happens ahead-of-time on the *whole program*, enabling optimizations impossible for a runtime-interpreted graph (SolidJS-style signals "dynamically discover dependencies as code executes" and cannot pre-optimize the graph shape): Slint's compiler has a dedicated `remove_unused_properties.rs` pass doing dead-code elimination on properties with no observers, and constant-propagates bindings that reduce to compile-time-known values. [Compilation Passes & Transformations | DeepWiki](https://deepwiki.com/slint-ui/slint/3.2-compilation-passes-and-transformations) The generated `BindingCallable`/`BindingVTable` machinery encodes each binding's evaluation as concrete generated code rather than a boxed interpreted closure graph — the "reactive graph" that exists at runtime is a lean, pre-shaped, per-property dirty/notify structure, not a general dynamic graph the runtime must build and interpret. This is the **polar opposite of SolidJS/vizia's runtime-discovered dependency edges** (§4.3): Slint pays the incrementality cost once, at compile time, at the cost that the graph's *shape* must be expressible in the DSL and known statically — it cannot express dependencies only knowable at runtime (e.g. "observe whichever item in this list is currently selected, where selection is arbitrary host-language logic") without falling back to imperative callback plumbing.

### 8.4 egui — immediate mode, the opposite pole

egui has no retained widget tree, no diffing, and no persistent app-state mirror: each frame, application code directly calls `if ui.button("Save").clicked() { save(); }`; "the only output of this call is some colored shapes, and a `Response`." [docs.rs egui](https://docs.rs/egui/latest/egui/) This buys real simplicity — it eliminates the "cache invalidation problem" entirely: "you just can't make that mistake. You rebuild everything based on the most up-to-date data." [Graphics: why immediate mode? — users.rust-lang.org](https://users.rust-lang.org/t/graphics-why-immediate-mode/93356) The cost is total and symmetric: a full layout+paint pass every frame regardless of what changed — inherently O(n) per frame in UI element count, with zero fine-grained update capability, since there is no persistent identity to update selectively. egui mitigates raw CPU cost only by skipping whole-*frame* repaints when idle, never by skipping per-element work *within* a frame that does run. A structural consequence of immediate mode: since widgets must report their size before being laid out, but layout is needed to know where to draw them, egui historically falls back to using the *previous frame's* measured size — "produces occasional flickering the first frame something shows up" — addressed in newer egui only via an optional multi-pass mode (a sizing pass then a layout pass, i.e. paying render cost twice to recover correctness). [docs.rs egui](https://docs.rs/egui/latest/egui/) egui is not *purely* stateless in practice: an internal `Memory` store (`HashMap` keyed by a hashed `Id`, itself typically derived positionally/by label — the same "position or explicit key" identity problem recurring throughout this survey) persists exactly the state that must survive across frames (collapsing-header open/closed, scroll offset, animation progress, focus) as a narrow, explicit, keyed side-channel for what a retained tree would otherwise hold implicitly. Animation, accessibility-tree construction, and text layout are the parts of egui's design most strained by the model, precisely because those subsystems most want a stable, addressable, persistent tree (matching Raph Levien's a11y argument, §7.3) rather than a from-scratch stream of draw calls every frame.

### 8.5 makepad — live DSL, proc macros, and a runtime live-dependency registry for hot reload

Makepad pairs a normal Rust build with its own `Live` system for real-time reload of UI/shader code, motivated explicitly by the fact that "Rust is a statically compiled language and doesn't support runtime coding like dynamic languages." [Makepad Framework Architecture — Makepad Book](https://makepad.rs/guide/start/makepad-framework-architecture) Three proc-macro pieces cooperate: `#[derive(Live)]` implements a `Live` trait on a struct; `#[live]` marks individual fields as live-reloadable; a `live_design! { ... }` block declares default/styled values in a CSS-like DSL:

```rust
live_design! { Button = {{Button}} { color: #f00 } }
#[derive(Live)] pub struct Button { #[live] color: DVec4 }
```

A `LiveRegistry`/`LiveRegister` mechanism tracks where each `live_design!` block lives so the framework can locate and reapply it; when a design tool or file-watcher edits the DSL text, the changed block is sent to the running app and reapplied into already-instantiated widget/shader fields **without a Rust recompile or restart**. [Makepad Framework Architecture — Makepad Book](https://makepad.rs/guide/start/makepad-framework-architecture) This spans the GPU layer too: Makepad's own shader language (MPSL) is embedded in the same Live DSL and cross-compiles to GLSL/HLSL/MetalSL, so shader parameters are live-editable the same way widget properties are; [Makepad Component — Makepad Book](https://makepad.rs/skills-and-components/components/makepad-component) the renderer itself is built around retained `DrawList` draw-call trees for GPU efficiency. [makepad/makepad GitHub](https://github.com/makepad/makepad) This is a **third distinct kind of fine-grained graph** in this survey (alongside SwiftUI's AttributeGraph and vizia's Signal graph) but purpose-built for live/hot editing of design-time constants rather than app-state-driven reactivity, and it is DSL/macro-heavy by design — trading Xilem's "little to no reliance on macros" philosophy for live-coding ergonomics. (Public documentation of the internal live-dependency propagation algorithm itself is thin; deeper specifics would require reading `platform/src/live_*.rs` directly.)

### 8.6 freya — started on Dioxus's keyed VDOM, now its own reactive core

Freya (0.1–0.3) was built directly on Dioxus's core: components as plain functions with hooks, diffed via React-style **keyed reconciliation of a dynamically-typed Virtual DOM**, targeting a custom Skia renderer plus a custom layout library instead of the browser DOM. [Freya Announcement — Rust GUI library](https://freyaui.dev/posts/announcement), [GitHub — marc2332/freya](https://github.com/marc2332/freya) As of **0.4, Freya diverged from Dioxus entirely**: it "no longer uses Dioxus, instead it uses its own reactive core, partially inspired by Dioxus but yet with lots of differences." [freya-dom — Rust GUI library // Lib.rs](https://lib.rs/crates/freya-dom) Architecturally, pre-0.4 Freya sits in the "full-rebuild + (dynamically-typed, keyed) diff" bucket — much closer to iced/React than to Xilem, vizia, or SwiftUI — while fully avoiding egui's per-frame full-repaint cost, since diffing only touches changed VDOM subtrees before Skia paints. Post-0.4 Freya's independent reactive core is a further data point (alongside vizia's Lens→Signal migration) of a Rust GUI project moving *away from* borrowed/inherited VDOM-diffing architecture toward a custom-built reactivity layer, though its internals weren't inspected at source level for this report.

### 8.7 Where each sits on the spectrum (informal ordering, immediate → fine-grained)

`egui` (immediate mode, no retained tree) → `iced`/`freya` (full-rebuild view fn + dynamically-typed/positional diff of a retained tree) → `Xilem` (full-rebuild view fn, but *statically-typed* diff of a retained tree, with opt-in `Memoize`/`Rc` memoization) → `slint` (compile-time-specialized property graph, no runtime diff at all for the properties the compiler can resolve statically) → `vizia` (current, post-migration) / `SwiftUI` / `Compose` (runtime fine-grained dependency graph as the primary/default update mechanism, structural diff only as occasional fallback or absent).

---

## 9. Comparative table

| System | Spectrum position | Component-local state: addressed how | Events/messages flow back how | Incremental unit | List/keyed-collection handling | Compile-time guarantees | Styling reactivity |
|---|---|---|---|---|---|---|---|
| **egui** | Immediate mode (pole 0) | Explicit keyed side-channel (`Memory: HashMap<Id, _>`, `Id` usually derived positionally/by label) | Direct: widget call returns `Response`, checked inline (`if ui.button(...).clicked()`) | Whole frame (every visible widget does layout+paint every frame) | No persistence structure at all; "list" is just a loop each frame | Almost none — everything is a runtime `Id`-keyed lookup, `Any`-boxed where needed | Immediate — style params passed as plain args each call, no persistence/diff |
| **iced** | Full-rebuild + positional/tag diff | Tree-owned: `widget::tree::State` (`Box<dyn Any>`) in a `Tree` positioned isomorphically to the `Element` tree, matched by `TypeId` tag | Message enum + `update(&mut self, Message)`; no callback closures capturing state | Whole `view()` tree (rebuilt every message); only internal state blobs are diff-preserved, positionally | Positional/tag-matched only — no explicit keys; reorders lose identity | Message type is a real enum (exhaustive match), but tree shape/diff correctness is entirely runtime (`Any` downcast) | Not reactive — styles are plain fields recomputed in `view()` every rebuild |
| **freya (≤0.3)** | Full-rebuild + dynamically-typed keyed diff | Dioxus hook-list, positional like React | React-style props/callbacks + Dioxus event system | VDOM node (React-style reconciliation) | Explicit `key` props, standard React-style keyed reconciliation | None beyond Rust's own type system on `rsx!` output; VDOM is dynamically typed | Not reactive — CSS-like props diffed with the VDOM node |
| **Xilem** | Full-rebuild view fn + **statically-typed** diff, opt-in memoization | `View::ViewState` — opaque, per-node, statically typed (not `Any`-boxed in the common path); `AnyView`/`Vec` use runtime generation counters only at explicit dynamic seams | `ViewId` path + `DynMessage` (`Box<dyn AnyDebug>`) routed by walking the *current* view tree by id, not via stashed closures | Whichever `View`/`ViewSequence` node's `rebuild` decides needs work; `Memoize`/`Rc`/`Arc` views can skip whole subtrees by `PartialEq`/pointer-equality | Tuples (fixed, typed, compile-time shape) for static children; `Vec<Seq>` positional + `u32` generation counters (not stable keys) for dynamic children | **Same-type `rebuild(prev: &Self, ...)`** statically proves tree-shape match; `Count` const tracks child-count class; `memoize`'s zero-sized-closure `const` assert | Runtime, CSS-like cascading (`Selector`-gated property stack) — deliberately *not* type-verified (Masonry design choice) |
| **slint** | Compile-time-specialized property graph | Generated struct field per property; graph shape fixed by the compiler | Callbacks (`callback clicked();`) invoked from generated code; host language attaches handlers | Single property node (intrusive-linked-list dirty propagation, O(1)) | `for`/`if` in the DSL compiled to generated iteration/conditional code; no runtime keyed-diff abstraction exposed to the app author | Whole-program dependency graph resolved and even partly *eliminated* (dead property removal, constant folding) at compile time | **Fully reactive per-property** by construction — that's the entire model |
| **vizia (pre-0.4, Lens/Store)** | Memoized diff → fine-grained (explicit lens paths, declared once) | `Store` (keyed by `StoreId` = lens `TypeId`/path) holding cached `old` value + `HashSet<Entity>` observers | Explicit `Binding::new(cx, lens, builder)` subscribes; model mutation → `Store::update` → rebuild only observing `Binding`s | The `Binding` subtree (explicitly placed by the app author) | No first-class list primitive shown in the lens era beyond composing lenses with `.idx(i)` | Lens composition (`.then`) is type-checked path composition, compile time; but "did I remember to wrap this in a `Binding`" is not checked | Not shown as reactive per se — styling is orthogonal to the binding system |
| **vizia (current, Signal/Effect)** | Fine-grained, automatic dependency tracking (SolidJS/Leptos-style) | `Signal<T>` — `Copy`, `'static`, allocation-free handle (`Id` into thread-local `Runtime` slab); no positional/lens addressing needed | `.set()`/`.update()` writes trigger `Effect`/`UpdaterEffect` reruns via automatically-tracked subscriber sets; `Binding` still the explicit tree-rebuild boundary | As fine as a `Label`-level signal read (leaf text) or as coarse as a `Binding` block (structural rebuild) — app author's choice | `Signal<Vec<Signal<T>>>` idiom for `List`; `Signal<Vec<T>>` for `VirtualList` — no built-in keyed diff, list identity is per-item `Signal` handle | None beyond ordinary Rust type-checking of `Signal<T>`/`SignalGet<T>` bounds; dependency *correctness* (did you subscribe to the right signal) is entirely runtime | Not signal-driven in the core (styling is a separate CSS-like layer in vizia) |
| **Druid** | Whole-(sub)tree diff, `Data::same()` opt-out | Widget-owned, addressed into via `Lens<T,U>` (compile-time-composed `Then<A,B>` path types) | `Widget::event(&mut self, ctx, event, data: &mut T, env)`, direct mutation of lensed `&mut T` | Whatever `update()` decides via `Data::same()` — opt-out by omission, no compiler help | No first-class keyed list; `List` widget diffs by index | **Lens path composition is compile-time type-checked** (the one thing Druid got fully right); `same()` correctness is not | `Env` — dynamically typed, threaded implicitly; not reactive per property |
| **SwiftUI** | Hybrid: fine-grained AttributeGraph (default/fast path) + struct diff (fallback/safety-net) | `@State` — struct holds a thin token (`_location: Optional<AnyLocation<T>>`) into a persistent graph node, keyed by structural or explicit (`.id()`) view identity | Bindings (`@Binding`) + closures capturing `_location`-backed state; reads register into the current dependency edge automatically | A single AttributeGraph node (a `@State`/computed property) when read-tracked; a `body` re-evaluation (struct diff) only when a parent invalidated structurally | `ForEach` requires `Identifiable`/explicit `id:`; `@ViewBuilder` compiles fixed children into `TupleView<(...)>` at compile time (à la Xilem tuples) | `@ViewBuilder` result-builder composition is compile-time typed; but graph-node identity correctness (accidental state-sharing across structurally-identical positions) is a documented runtime footgun | `@Observable`'s KeyPath-based tracking is per-property-reactive by construction; legacy `@ObservableObject`/Combine is not (whole-object invalidation) |
| **Jetpack Compose** | Hybrid: MVCC snapshot state (fine-grained) + positional slot-table recomposition (structural) | Slot table — positional by call-site by default, `key()` for explicit override; `remember{}` persists per-slot | Lambdas capturing `MutableState` directly (no message enum by default); snapshot writes propagate via O(dependents) reverse index | A single `RecomposeScope` (donut-hole skipping — parent skips while inner scope reruns) | `LazyColumn`/`items(list, key = {...})` — explicit key-based diffing, closest analog to React's keyed reconciliation | **Compiler-plugin-verified**: `$changed` bitmask, `startRestartGroup`/`skipToGroupEnd` inserted by the Kotlin IR plugin — no Rust equivalent without a proc-macro/compiler-plugin (verified: `#[track_caller]` alone is insufficient, §6.5) | `Modifier` chains are recomposed like any other composable input — reactive to the extent the underlying state is `State<T>`-backed |
| **GPUI (today)** | Full-rebuild view fn per notified entity (closest to iced/Elm), coarse-grained manual dirty flagging | `Entity<T>` — reference-counted handle into `App`-owned storage (explicit handle, not positional, not lens-addressed) | `cx.notify()` (manual, whole-entity-granularity dirty flag) + `cx.observe`/`cx.subscribe` (manually-wired, **not** auto-tracked) + direct closures capturing `Entity<T>` handles for callbacks | Whole `Render::render()` output of one notified `Entity` (its full element subtree is reconstructed); persistent per-element state (scroll/animation/focus) keyed by explicit, app-author-assigned `ElementId`/`GlobalElementId` path | No first-class keyed-list `ViewSequence`; children built imperatively via `.child()`/`.children()` each render call | Element tree is dynamically typed (`AnyElement`, `IntoElement` erasure); no static tree-shape proof like Xilem's `rebuild(prev: &Self)` | Style structs are recomputed as plain data each `render()` call — not reactive per property |

---

## 10. GPUI today, and stealable ideas

### 10.1 Where GPUI sits, precisely

From `crates/gpui/src/_ownership_and_data_flow.rs` and `crates/gpui/src/element.rs` (this repo):

```rust
pub trait Render: 'static + Sized {
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement;
}
```

- **State ownership**: every `Entity<T>` is a reference-counted handle into `App`-owned storage — "much like an `Rc`... but unlike an `Rc` it only provides access to the model's state when a reference to an `App` is available." This is *explicit-handle-addressed* state (closer to vizia's `Entity`/Signal handles or Compose's `MutableState` object than to Druid/Xilem's lens-path addressing or Compose's positional slot table).
- **Invalidation**: `cx.notify()` is a **manual, whole-entity-granularity dirty flag** — there is no automatic dependency tracking (no equivalent of SwiftUI reading `@State` registering a graph edge, or vizia's `Signal::get()` auto-subscribing the current effect). `cx.observe`/`cx.subscribe` are **explicitly, manually wired** edges between entities, set up once (typically in a constructor) and then implicit for the relationship's lifetime — structurally similar to Druid's approach of "you must remember to do the right thing," not to Compose/vizia/SwiftUI's "the read *is* the subscription."
- **Rebuild granularity**: when a notified entity's `Render::render()` runs, its **entire element subtree is reconstructed from scratch** on that call — architecturally this is the *iced/Elm* full-rebuild-view-function model, not Xilem's typed-diff model and not any fine-grained model. `IntoElement`/`AnyElement` are dynamically typed (erased), so there is no static proof of tree-shape stability across rebuilds the way Xilem's `rebuild(prev: &Self, ...)` provides.
- **Persistent state across rebuilds**: handled via explicit, app-author-assigned `ElementId`s composed into a `GlobalElementId` path (`Arc<[ElementId]>`) — this is GPUI's analog of iced's positional `Tree`/`tag` matching or SwiftUI's `.id()`, but *always* explicit (no automatic structural-position fallback the way iced/SwiftUI provide one).
- **Net position on the spectrum (§9)**: GPUI today sits at **"full-rebuild view fn, dynamically-typed element tree, coarse manual dirty-flagging, explicit persistent-state keys"** — one notch more explicit/manual than iced (real reference-counted entity ownership instead of borrow-checker-enforced full-tree-drop, and explicit id-based persistence rather than positional-by-default), but with **none** of Xilem's compile-time tree-shape verification, **none** of vizia/SwiftUI/Compose's fine-grained automatic dependency tracking, and **none** of Compose's transactional (MVCC) state consistency guarantees.

### 10.2 Five most stealable ideas, ranked

1. **SwiftUI's hybrid diff+attribute-graph split (§5.2) — the single most important structural idea.** Don't choose "diffing OR fine-grained" — run *both*, layered: keep a coarse, cheap "did this subtree's inputs change at all" check (Xilem-style `Memoize`/structural comparison, or GPUI's existing `cx.notify()`) as the *safety-net* layer that guarantees correctness even where fine-graining wasn't wired up, but make the **default, fast path** a persistent dependency graph where reading a piece of state inside a render/computation automatically registers an edge, and writing that state walks *only* the dependent edges — never the whole tree. Concretely for GPUI: today `cx.notify()` is exactly SwiftUI's "structural fallback" layer, minus the fine-grained layer underneath it. Adding the fine-grained layer (a real dependency graph triggered by reads) *underneath* the existing `notify`/`observe` mechanism, rather than replacing it, is lower-risk than a rip-and-replace, and Raph Levien's own writing (§7.5) suggests this is exactly the kind of incremental move he considered too costly for Xilem's team size at the time — GPUI, being a funded, in-production framework with an existing full-rebuild fallback already battle-tested, is in a *better* position to attempt it than Xilem was in 2019–2022.

2. **Compose's snapshot (MVCC) state system (§6.3) — solves the "torn frame" problem that killed Crochet (§7.3).** Raph Levien's own post-mortem of Crochet (immediate-mode-on-retained-tree) identifies "state tearing" — rendering seeing a mix of old/new state because updates interleave with rendering — as a concrete failure mode of naive fine-grained mutation. Compose's answer (a linked list of versioned `StateRecord`s per state cell, snapshot IDs, batched `apply()`) is the proven fix. **For GPUI**: any move toward direct/fine-grained mutation of state read during rendering needs an equivalent discipline — at minimum, batch all signal writes during a render/paint pass and apply them atomically between frames (GPUI's existing frame/pass structure, similar to Masonry's rewrite-pass system, §2.1, is a natural place to hang this), rather than allowing a callback to mutate state that's mid-read by an in-flight render.

3. **vizia's `Signal`/`Effect`/`Binding` triad (§4.2–4.4) — the most directly portable Rust implementation pattern, because it's real, shipping, macro-free Rust, not a foreign-language reimplementation.** `Signal<T>` as a `Copy` handle into thread-local slab storage, `Effect`/`UpdaterEffect` for automatic dependency tracking via a thread-local "current effect" pointer that `Signal::get()` checks, `Binding` as an explicit tree-rebuild boundary that owns one `UpdaterEffect` and tears down/rebuilds only its own subtree — this is a **complete, working blueprint** for exactly the "fine-grained reactivity for a retained Rust GUI tree" problem GPUI is trying to solve, already proven against real-world app complexity (vizia ships production apps). The `TrackedRefCell` debug-mode double-borrow diagnostic (records call-site `Location` of the conflicting borrow) is a small but valuable piece of reusable DX engineering. Vizia's own migration *away from* Druid-style lenses *toward* this system is itself evidence for prioritizing this idea over idea #4 below if forced to choose one reactive core.

4. **Xilem's typed `ViewSequence`/tuple composition + same-type `rebuild(prev: &Self)` (§1.3, §1.8) — for whatever part of the tree GPUI keeps diff-based.** Even in a fine-grained-reactivity future, GPUI will likely still have *some* structural view composition (conditionally-present children, heterogeneous child lists) that isn't naturally expressed as "one signal, one leaf." For that residual diffing surface, Xilem's approach — tuples/arrays/`Option` as `ViewSequence` for statically-known shapes (zero allocation, zero dynamic dispatch, tree-shape-verified by the type system because `rebuild` takes `prev: &Self` of the identical concrete type) with `Vec`+generation-counter and `AnyView`+generation-counter as narrow, explicit, opt-in escapes for genuine dynamism — is a better-typed alternative to GPUI's current `AnyElement`/`IntoElement` fully-erased approach, and directly reusable as "the part of the tree that's still diffed" in a hybrid design (idea #1).

5. **Druid's/vizia's compile-time composable lens (`Lens<T,U>` + `.then()`) as the *addressing* mechanism for wiring signals to nested app state (§3.2, §4.5).** Regardless of whether the underlying reactive core ends up being vizia-style signals or something else, the *problem* of "let a reusable component declare it needs `&mut SomeSubState` and have the call site supply where that substate lives inside the larger app state, checked by the compiler" is exactly what `Lens`/`.then()` solves, with zero runtime cost (each composed lens is its own monomorphized, typically zero-sized type). Xilem itself kept a simplified version of this (`lens`/`map_state`, §1.5) precisely because the addressing problem doesn't go away just because the diffing problem was solved differently — it's an orthogonal axis. For GPUI, adding a real `Lens<ParentState, ChildState>` trait with compile-time `.then()` composition (as Druid/vizia-classic did) gives component authors a statically-verified way to declare "I only touch this field" *regardless of* whether the underlying storage is an `Entity<T>`, a future `Signal<T>`, or plain owned data — decoupling the "how do I address a piece of state" question from the "how does the state notify its dependents" question, which is a design mistake worth avoiding (Druid conflated them; Xilem and vizia both eventually separated them).

### 10.3 One explicit non-recommendation, worth flagging

Masonry's own documented principle — "Properties are low-verification... we refrain from implementing [trait-based compile-time verification]... The property system is meant to be flexible" (§2.4) — and Slint's opposite, fully-compiled, fully-verified-but-inflexible property graph (§8.3) — are presented here as **the two ends of a real tradeoff, not a solved problem**. "Maximal compile-time verification" (this research effort's stated goal) should be scoped deliberately: Xilem's own most successful production codebase (Masonry) explicitly chose *not* to statically verify its styling/property layer, for concrete ergonomic reasons (container widgets setting properties on children whose authors didn't anticipate them; CSS-like cascading is fundamentally a runtime-resolved concept). A GPUI redesign should expect — and explicitly budget for — at least one layer (most likely styling/theming) where the Slint-style "prove everything at compile time" approach is the wrong tradeoff, and Masonry's "low-verification, flexible, runtime-cascaded" approach is more appropriate, even while pursuing maximal static verification everywhere else (tree shape, state addressing, dependency wiring).
