# 03 — The Retained Reactive GPUI Plan

Status: **authoritative architecture proposal**. The four documents under `approaches/` are
explorations that contributed pieces to this plan; they are not four competing implementation
tracks. This document, [performance.md](performance.md), and [migration.md](migration.md) define
the intended system.

## Executive decision

Build retention first, then attach a UI-thread-local reactive graph to retained properties and
explicit structural regions. Keep GPUI's chainable Rust element API, Tailwind-like styling,
entities, and immediate drawing escape hatches. Replace whole-window reconstruction as the normal
path with a pipeline whose cost is proportional to changed state, changed structure, changed
geometry, and damaged pixels.

The resulting model is deliberately hybrid:

- **Retained nodes are the substrate.** Elements, layout nodes, dispatch entries, accessibility
  nodes, and paint fragments keep stable identity across frames.
- **Typed incremental lowering patches values.** `State<T>` is a copyable key; builders accept a
  sealed `Property<T>` bound without storing a universal value enum. Mount consumes and deforests
  the concrete blueprint into a constant, direct field sink, sealed circuit, fixed/dynamic derived
  node, structural region, or delta operator—the cheapest representation preserving semantics.
- **Structural regions reconcile.** `show`, `switch`, and keyed collections are the only places
  where changing state changes tree shape.
- **Legacy `Render` is an island.** Existing views may rebuild into a bounded retained host, but
  the new fast path never depends on rebuilding them.
- **Damage survives through presentation.** The renderer retains the composed target and redraws
  only damaged pixels when the backend can preserve them.

This is more aggressive than Approach A and more practical than the original B/C/D sketches. It
also sets a higher bar than merely adding signals: current zgui already retains document, layout,
paint records, hit-test state, and rendered pixels. The performance target is therefore stated as
falsifiable gates in [performance.md](performance.md), not as a predicted multiplier.

## 1. Public authoring model

### 1.1 State and values

The common authoring surface has four concepts: `State<T>`, `Scope`, `Update`, and a sealed
`Property<T>` input accepted by builders. `State<T>` is a copyable typed key, not an owning pointer
or subscription:

```rust
pub struct State<T: 'static> {
    runtime: RuntimeId,
    slot: SlotKey, // generational field/scalar slot
    _type: PhantomData<fn() -> T>,
    _local: PhantomData<Rc<()>>, // Copy, but !Send + !Sync
}

pub struct Scope<'a> { /* mount owner + creation/lowering authority */ }
pub struct Update<'a> { /* event-local read/write authority; publication is automatic */ }

pub trait Property<T>: private::Sealed { /* lowering only */ }
```

`State<T>` contains integers and marker types, no `Rc`, `Weak`, borrow, or raw runtime pointer. It
is manually `Copy` for every `T` and remains `!Send + !Sync`. It cannot dereference itself: a real
read uses `update.get(state)`/`update.with(state, ...)`, a write uses `update.set(state, value)` or
`update.edit(state, ...)`, and a deliberately frozen mount read uses `scope.initial(state)`. The
capability supplies the runtime reference and validates the key's runtime, owner, source, and field
generations. This removes refcount traffic, use-after-runtime risk, phase guards on context-free
reads, and clone choreography together. Passing a state/expression to a builder is inert; the
builder's existing mount scope lowers it later.

`#[derive(Reactive)]` does not expose a `Fields` enum. It generates an inferred, copyable handle
whose fields are ordinary `State<FieldType>` keys:

```rust
#[derive(Reactive)]
struct Settings {
    count: u64,
    accent: Color,
    sidebar_width: Pixels,
}

let settings = scope.model(Settings { /* ... */ });
text!("Count: {}", settings.count);
div().bg(settings.accent).w(settings.sidebar_width);
button("+").on_click(settings.count.add(1));
```

The generated handle type is normally inferred. `scope.model` allocates its fields as one contiguous
source group, but every generated field is an ordinary `State<FieldType>` pointing directly at its
field cell. There is no parent-source notification, projection node, field-mask dispatch, or sibling
invalidation on the exact path. Group metadata exists only for atomic initialization, disposal,
debugging, snapshots, and explicit whole-model operations. The derive emits stable private field
metadata, a group schema, draft/scatter code where supported, equality policy hooks, and debug names.
Repeating `settings.count` copies two machine words; it does not create a node, subscribe, borrow, or
increment a refcount. The generated bundle carries one private group key used only by
`update.replace(settings, value)`, `update.edit_all(settings, f)`, whole-model snapshots, and
disposal—not another reactive source in the field fast path. The `_all` suffix names the cost, not
the argument kind: an opaque aggregate edit publishes a conservative wildcard delta.

Nesting is explicit, not a proxy. `#[reactive(nested)]` on a field whose type also derives
`Reactive` allocates that sub-model inside the same contiguous group and exposes a nested handle
(`settings.editor.font_size` is an ordinary `State<Pixels>`); the private field metadata is shaped
as per-field marker types so the derive converges with the in-flight field-projections RFC (3735)
rather than competing with it. A reactive field *without* the attribute is one `State<B>` cell with
whole-value equality—correct, but coarse; the derive emits a deny-by-default mount diagnostic when a
`Reactive`-deriving type is stored as an opaque cell (`scope.state(Settings{..})` instead of
`scope.model`), because stable Rust cannot make that granularity cliff a compile error without
negative impls. Maps and vectors of models are `KeyedList` territory; there is deliberately no
deep-proxy “mutate anything nested and the UI notices” mode, because observed mutation through
arbitrary `&mut` cannot be made precise or panic-safe in Rust—the same reasoning as the aggregate
draft wildcard.

#### Zero-ceremony authoring surface

Three small, fully typed conveniences remove the remaining hello-world ceremony without weakening
the capability model. They are sugar over existing strata, never new semantics:

- **`text!` formatting.** `text!("Count: {}", settings.count)` is a stable proc macro over ordinary
  `format!` syntax. Each static segment lowers to a constant; each argument lowers to the sealed
  formatting circuit for its type (integers/floats use inline itoa/ryu-style formatting with no heap
  allocation for short output). Only a changed argument re-formats its segment; shaping still sees
  one string. `text(state)` also accepts a bare key for the primitive `Display`-stable types
  (integers, bool, `SharedString`) through the same sealed circuit, so the simplest label needs no
  macro at all. Locale-sensitive text uses `Localized` (§6) rather than `Display`.
- **Mutation descriptors.** `settings.count.add(1)`, `flag.toggle()`, `state.set_to(value)`, and the
  collection forms (`list.push(v)`, `list.remove_key(k)`) are inert, copyable, `#[must_use]`
  descriptors of a staged write. They are not reads, subscriptions, or graph nodes; handing one to an
  event method installs it as that event's handler. This eliminates the double-closure spelling
  (`move |_, update| update.edit(count, |n| *n += 1)` becomes `count.add(1)`) for the dominant
  handler bodies while lowering to the same draft/publish path — often better, because a named
  descriptor lowers as a typed delta instead of an opaque closure thunk.
- **Handler arities, in increasing authority.** Event methods accept a sealed handler bound with
  four forms: an inert mutation descriptor (`count.add(1)`); a **pure event function returning
  deltas** (`|click: &Click| count.add(click.count)`)—no capability at all, trivially unit-testable
  as a plain function; `FnMut(&mut Update)`; and `FnMut(&mut Update, &EventType)` when logic needs
  reads or commands. The capability comes first because every full handler uses it and only some
  inspect the event. Most handlers never see a context, which is the point: authority appears
  exactly where a read or command genuinely requires it.

Application signatures spell the mount capability as `&mut Scope` (elided lifetime); the explicit
`Scope<'_>` form appears only where a struct stores related generics.

Mutations are staged by construction. `Update::set` moves a replacement into the pending epoch.
`Update::edit` is available when the field's declared draft policy can make an isolated draft—`Copy`,
`Clone`, persistent/COW, or a generated delta builder—and publishes only after the closure returns.
A panic drops the draft and leaves committed state untouched. Large text and collections use typed
delta builders rather than cloning their roots. An opaque whole-model edit is possible only through
an explicit rollback-capable draft policy and publishes `Wildcard`; there is no default API that
hands arbitrary code the live committed `&mut Model` and then hopes to reconstruct what changed.

The authoring model has six internal lowering strata, selected at mount and invisible in ordinary
application signatures. The sealed `Property<T>` conversion carries the first four property-value
forms; structural and delta operators have their own typed inputs:

| Lowered form | Applies to | Work on change |
|---|---|---|
| constant | literal/static value | direct stored value; no graph or observer |
| direct sink | scalar/generated-field `State<T>` into one retained port | source revision -> monomorphic patch thunk |
| static circuit | sealed framework-owned operators over fixed inputs | fused/specialized because the framework owns their purity/fault semantics |
| dynamic computed | arbitrary derived closure with branching/opaque calls | tracked dependency maintenance and equality gate |
| structural region | `show`, `switch`, keyed structure | queued reconciliation command |
| delta operator | text, keyed collections, ranges, model deltas | applies a typed change, not a replacement recomputation |

Literals and `State<T>` implement the sealed property conversion. Framework-owned operators return
anonymous `impl Property<T>` descriptors, so users never name an expression-tree type. Raw function
pointers and closures are never silently treated as static circuits: Rust does not
prove them pure merely because their dependency set is fixed. The framework may fuse only sealed
operators whose purity, equality, and fallibility policy it owns. An arbitrary one-input `map(f)`
is a static-edge computed node, and an arbitrary branch-dependent `scope.memo(|read| ...)` is a
dynamically tracked computed node; neither is fused into a property sink. A shared derived result is
returned as an opaque copyable read-only property, not an owning closure handle. It implements the
sealed readable/property protocols but not the private writable-key protocol accepted by
`Update::set`/`Update::edit`; no public `Computed<T>` wrapper needs to be named. User side effects are an
after-publication API, never a property sink or a settle participant.
The precise paths and counters are illustrated in [examples.md](examples.md).

#### Deforested property lowering

`Property<T>` is a compile-time installation protocol, not a stored enum or `dyn` trait. Builder
types temporarily retain the concrete property expression on the stack. Consuming the final
`impl IntoElement` during mount recursively installs each property into its destination and then
drops the entire builder/expression type. Retained nodes never store that generic type.

```rust
impl<T: Eq + 'static> State<T> {
    pub fn eq<P>(self, rhs: P) -> impl Property<bool> + use<T, P>
    where
        P: Property<T>,
    {
        private::EqExpr::new(self, rhs)
    }
}
```

The stable precise-capture bound (`use<T, P>`, available since Rust 1.82) prevents the opaque return
type from accidentally capturing `Scope`, a borrow, or unrelated generics. This makes a returned
blueprint honestly owned/`'static` when its inputs are, shortens diagnostics, and avoids the old
`Captures`/outlives tricks. It does not itself optimize runtime work; the consuming installer does.

Installation deforests the temporary expression directly into one of a few storage records:

- constant: value in the retained port, no reactive record;
- field/scalar key: `(SlotKey, destination)` in the direct-fanout slab;
- sealed expression: input keys plus a generated operator/update function in a kind-segregated
  circuit slab, with no heap allocation after slab growth;
- arbitrary one-use `.map(f)`: one fixed-edge user-thunk record with its fault/equality policy;
- shared `scope.memo(f)`: one cached graph slot, represented to consumers by another copyable
  read-only key.

There is no universal `Value<T>`, boxed property, runtime expression tree, per-edge `Rc`, or graph
node for constants/direct fields. Common sealed operators can be grouped by operator/port kind and
run in tight batches; uncommon monomorphized thunks use one indirect call per dirty record. The
mount-time generic blueprint costs code size and compile time rather than steady-state dispatch, so
both are explicit gates. Dynamic child/trait-object boundaries erase a completed subtree after
installation rather than boxing every leaf property.

#### Minimal runtime kernel

The lowering strata are behaviors, not separate object hierarchies. The steady-state kernel has
four primary arenas:

| Arena | One record represents | Optional cold side data |
|---|---|---|
| cell | published value/revision, owner, fanout head | arbitrary-derived rule, dynamic input set, equality/fault metadata |
| wire | input cell(s) to destination port/cell, update function/operator, obligation | spilled inputs or arbitrary fixed-edge closure |
| node | retained UI identity, typed port range, child/order links, phase dirt | custom widget/platform/accessibility payload |
| epoch | sparse changed cells/wires/nodes plus publication state | dense double buffer, presentation shadows, pinned prior versions |

A generated model is a contiguous cell range. A source is a cell without a rule; a shared derived
value is a cell with a cold rule; a direct property is a one-input identity wire; a sealed circuit
is a wire whose installer fused known operators; a one-use map is a wire with a cold user thunk.
Dynamic reverse dependencies reuse cell fanout links. Owners/generations are compact headers shared
by these arenas rather than wrapper objects per feature.

This removes an entire “signal -> projection -> computed -> binding -> effect -> property” forwarding
chain. The exact hot path is:

```text
Update draft field cell -> publish revision -> cell fanout wire -> retained port -> obligation
```

No refcount, hash lookup, parent-model mask, general graph node, boxed callback, or user effect is
required on that path. Whether a function pointer, operator id, or kind-segregated batch is fastest
for each wire class remains a measured implementation choice behind the same record contract.

Before mount, a sealed expression is a small typed descriptor assembled from generated field keys
and framework operator tags. At mount it is erased into a compact slab record: source
index/revision, destination port id, equality/classifier id, and monomorphic patch thunk. A sealed
circuit adds only its fixed input indices and framework operator tag; it is installed by `Scope`,
never allocates or registers during layout/paint, and its warm update performs no user closure or
general effect allocation. The descriptor uses a bounded inline opcode/input representation and
spills only during mount if a deliberately long chain exceeds that bound; either representation is
erased before the first update. Dynamic computations instead own an explicit graph record and may
allocate/rewrite dependencies only during the tracked settle phase. This erased representation is
an internal optimization contract, tested by per-stratum allocation and phase counters—not a public
generic type leak.

Builder methods take `impl Property<T>`; downstream crates cannot implement that sealed trait.
Framework conversions cover literals, state keys, sealed expressions, and derived keys. Specific
ergonomic conversions such as `&'static str` to `SharedString` live beside the destination type.
The type checker still proves source/destination value compatibility without exposing `Value`,
`ReadState`, `WriteState`, `Field`, `Circuit`, or `Computed` as everyday public nouns.

The generated model shape is implementable with an associated handle type rather than language
magic: conceptually, `ReactiveModel::Handle: Copy`, and `Scope::model<M>` returns `M::Handle`.
Likewise, `scope.memo(f)` returns
`impl Property<T> + Readable<T> + Copy + use<T, F>`; builders and `Update::get` can consume it, while
the APIs that mutate state accept only a concrete `State<T>`. The opaque property has methods but no
user-visible dependency-graph type parameters.

```rust
fn counter(scope: &mut Scope) -> impl IntoElement {
    let count = scope.state(0u64);

    div()
        .gap_2()
        .child(text!("{} doubled is {}", count, count.mul(2)))
        .child(button("Increment").on_click(count.add(1)))
}
```

There is no process-global runtime, implicit TLS runtime selection, or reentrant user-code-on-write.
The key identifies which runtime it belongs to, while `Scope`, `Update`, dynamic-read, and advanced
phase capabilities supply the actual access. Keys remain cheap `Copy` data that can be stored in
ordinary Rust structs. The local default avoids refcounts, atomics, locks, and ambient lookup on the
hottest path. The common concurrency boundary is the typed work edge described in §5.3:

```rust
let index = scope.compute(document, index_document);
let symbols = scope.resource(workspace.symbol_query, load_symbols);
```

For a genuinely long-lived external producer or multi-message protocol, `Scope::sender` remains a
lower-level escape hatch and creates/registers an owner-bound bridge. A later `sender.clone()` is allocation-free;
state keys and sealed expressions never register anything themselves. Their retained-port
registration is the builder's mount action. Owned `Snapshot::new` copies owned data and registers
nothing. `Sender<T>` queues a message and invokes an idempotent, non-blocking frame waker. It cannot expose a
borrow or execute graph work on the sending thread. A send that linearizes after owner revocation
returns `SendError<T>` with its payload. A send accepted just before a concurrent close may still be
discarded at delivery when its epoch is rechecked; callers needing applied acknowledgement use a
separate request/ack operation. Capacity/coalescing policy is part of sender construction.

State ownership is explicit. State created in an application owner can feed retained property wires in
many windows; one write marks observers in each affected window and requests only those windows.
State created under a window/view owner is disposed with it. Application services and immutable
configuration are preferably plain structs passed to constructors. Owner-scoped typed context is
available for genuinely ambient descendants, with `try_context<T>` as the base operation and a
located `context<T>` convenience; it is never a process global with hidden initialization order.

### 1.2 Phase capabilities

Only framework entry points expose short-lived capabilities; ordinary properties and generated
field handles do not. `Scope` and `Update` are the only two most application code names. The remaining
types are advanced custom-widget callback capabilities or an inferred argument to
`scope.memo`—not state vocabulary:

```rust
pub struct Scope<'a>     { /* create owner-local state/nodes, wire structure */ }
pub struct Read<'a>      { /* inferred dynamic dependency recording; reads only */ }
pub struct Update<'a>    { /* event/command reads+writes; commits on normal return */ }
pub struct LayoutFeedback<'a> { /* declared, bounded post-layout writes only */ }
pub struct LayoutCx<'a>  { /* settled retained props, measure caches; no state writes */ }
pub struct GeometryCx<'a>{ /* committed geometry reads only */ }
pub struct PaintCx<'a>   { /* settled frame data and drawing only */ }
```

The capabilities are one idea, not seven types to memorize: **a phase is which methods exist.**
Three sealed permission traits make helpers phase-polymorphic without weakening any boundary:
`Reads` (implemented by `Update` and `Read`), `Writes` (implemented by `Update` alone), and
`Mounts` (implemented by `Scope`). A helper that only reads is written once as
`fn summary(cx: &impl Reads) -> SharedString` and is callable from event handlers and memos alike;
one that writes demands `&mut impl Writes` and is therefore uncallable from a memo *by signature*,
not by convention. The traits are sealed, so the permission lattice cannot be forged downstream,
and the concrete structs keep their extra phase-specific methods (commands on `Update`, dependency
recording on `Read`). The user-facing lesson collapses to: *keys are inert; a context argument says
what this phase may do; the same verb (`get`/`with`) reads everywhere.*

`Scope` appears once at a component/structural mount boundary; it creates owner-bound state,
resources, and structure. `Update` appears only at an event/command boundary; it may read source or
derived property keys, stage writes, and queue commands. `LayoutFeedback` appears only after
layout and may apply a predeclared bounded `LayoutCell` write set; it cannot demand-compute, reconcile
structure, run effects, create resources/senders, or select a worker. The dynamic `Read` argument is
inferred only in `scope.memo(|read| read.get(settings.count) ...)`; sealed comparisons, option
predicates, numeric operators, formatters, generated field ports, and fixed-input `.map(f)` require
neither it nor a named computed type. Layout/paint callbacks retain their phase contexts because they expose
ephemeral geometry/render capabilities.

An arbitrary derived closure is write-incapable, not proven “pure”: it may be
demanded or retried, so its body must be deterministic, idempotent, and free of external side
effects. External effects belong to the after-publication API. `update.get(derived)` may execute it to
stabilize the pending epoch; `read.get(other)` records dynamic dependencies inside its body. One
name covers “the committed value from before this update”: `update.prior(key)` never executes user
code—for a source it returns the pre-update value, for a derived key the last published output.
`update.try_get(derived)` is the fallible form for a computation that may currently be faulted
(§4). There is no context-free operation that unexpectedly reads storage or executes a dirty
computation.

This statically prevents the common category mistakes that fit naturally into an API boundary:
painting outside paint, direct state reads/writes during computed evaluation, and state creation
during paint. A captured `State<T>` key is harmless without an access capability. Custom measurement receives
`LayoutCx`, cannot read live state, mount structure, or enqueue effects, and is
deterministic for its constraints plus retained input revisions. Geometry observers receive
`GeometryCx` plus a `LayoutFeedback` bound to the mount-declared `LayoutCell` targets, up to
their configured cap. A geometry cell is not an ordinary `State`: it is `!Send`, its `GeometryInput`
half can feed only reviewed layout/anchor ports and cannot implement general `Property`, participate
in a derived node, drive structure/style/effects, or escape through a sender or work input. A
permitted write therefore triggers only the bounded relayout/geometry loop, not the general reactive
protocol. `LayoutFeedback` cannot demand a
computed, reconcile structure, run/create an effect, create a resource/sender, or choose a worker. A permitted write triggers the bounded
settle/re-layout loop with a trace of its declaration and loop chain. It does **not** claim to prove use-after-disposal, dynamic
dependency acyclicity, or every
multi-callback interaction protocol. Those are runtime properties with precise diagnostics.

```rust
let scroll_correction = scope.layout_cell(px(0.0), FeedbackBudget::writes_per_frame(2));

viewport
    .layout_correction(scroll_correction.input())
    .on_geometry(scroll_correction, |geometry, feedback| {
        if let Some(next) = geometry.anchor_correction() {
            feedback.set(next);
        }
    });
```

`Scope::layout_cell` creates one sealed cell in the local runtime with its identity, owner,
permitted layout ports, and budget. `LayoutCell<T>` is deliberately **not** `Copy`/`Clone` and is
consumed **by value** by exactly one `on_geometry` registration, so a second writer to the same
feedback cell is a compile error rather than a runtime-budget diagnostic; the handler's
`LayoutFeedback` is bound to that cell and exposes only `set`/`edit` on it. The copyable
`cell.input()` half can be installed only into the small whitelist of geometry-feedback-aware
layout ports. Capturing ordinary handles therefore cannot expand the feedback graph's authority. A product that wants to publish observed geometry into application
state emits an after-publication event for the next ordinary `Update`; it does not smuggle that write
into the current layout round. Runtime generation checks still handle disposal, and the callback
remains ordinary Rust whose external side effects are a documented semantic prohibition rather
than something stable Rust can prove.

This is a deliberate break from the current Taffy measure callback's mutable `Window`/`App` access.
Custom widgets lower every measure dependency into retained inputs before layout. Compile-fail API
tests and runtime reentrancy tests enforce that measurement cannot reach state/structure mutation.

Internal arena access uses a contained branded view after public id validation. Public handles
remain generational. A public `'ui` brand cannot be hidden across dynamic windows or stored
callbacks on stable Rust, so it is not the foundation of the user API.

#### Internal branding contract

Branding is retained as a hardening layer, not merely left as a possible experiment. The public
`NodeId`/`State<T>` is resolved at a framework boundary into a temporary branded capability:

```rust
window.with_node_arena(|mut arena: BrandedArena<'_>| {
    let node: NodeKey<'_, DivProps> = arena.resolve(id)?;
    // The branded key cannot escape or be used with another arena view.
    arena.with_mut(node, |props| patch(props));
})
```

`with_node_arena` is higher-ranked over a fresh invariant lifetime; callers cannot choose that
lifetime, and `NodeKey<'brand, T>` is only consumed by the `BrandedArena<'brand>` that minted it.
The precise implementation may be an HRTB-minted marker, a GhostCell-style token, or a private
branded facade over generational storage. Its required guarantees are:

- internal resolved references cannot escape the arena/phase callback;
- read and exclusive-write capabilities are distinct and borrow checked;
- a branded reference from one arena view cannot be consumed by another;
- unsafe indexing/unchecked access, if profiling justifies it, exists only behind successful public
  id/generation/window validation at the boundary;
- callbacks, async tasks, and user structs store public ids/senders, never branded references.

This deliberately does not claim that the private brand proves a long-lived public id still exists.
Generation and owner epoch provide that dynamic proof. The brand proves aliasing and containment
after resolution. If a GhostCell-shaped whole-runtime owner can be contained without making public
signatures viral, it is preferred; otherwise the temporary branded facade preserves the useful
boundary while keeping dynamic windows practical.

### 1.3 Build once; structure is explicit

A component is an ordinary Rust function called when its retained owner is mounted. Value changes
do not reinvoke it. Tree-shape changes occur only through explicit structural primitives:

```rust
show(logged_in, dashboard).fallback(login_form)

switch(route, |route, scope| match route {
    Route::Home => home(scope).into_any(),
    Route::Settings => settings(scope).into_any(),
})

list(rows.keyed_by(|row| row.id), |row, scope| table_row(row, scope))
```

Branches are lazy builders—fn items or closures invoked when the branch mounts—never eagerly
constructed values; `show` takes one branch and an optional `.fallback`, so the two-positional-
branches spelling (and its swapped-argument bug class) does not exist. The default replacement
policy is reset-on-replacement: an inactive branch is unmounted, its effects and tasks are
cancelled, and its local state is disposed. `keep_alive(key, view)` is an explicit cache with a
capacity/eviction policy. Hidden and retained are never synonyms.

**Held transitions.** A structural replacement commits immediately by default. Opting in with
`.transition(Hold::until_ready().timeout(ms(300)))` keeps the outgoing branch mounted, presented,
and interactive while the incoming branch mounts detached and its readiness set settles—by default
the first resolution of every `Work` handle created during that mount, or an explicit
`scope.ready_when(property)` declaration. The swap then publishes atomically: no spinner flash on
navigation, no half-swapped frame. Input routes to the held branch until commit; focus transfers at
commit under the focus-scope rules; accessibility announces once at commit; the timeout is
mandatory and force-commits with the incoming branch's pending UI. This is the Solid/React
transition UX expressed on the existing two-epoch scheduler—the detached branch settles logically
but withholds its presentation subtree—rather than dual storage on every signal. Held duration,
readiness membership, and timeout commits are counters.

The runtime separates a structural computation from the build it triggers. Dependency tracking is
active while the condition/key sequence is computed and disabled while mounting or reconciling the
chosen branch. Reads during construction therefore cannot accidentally widen the structural
subscription.

**Error boundaries are structural.** `boundary(child).catch(|fault, scope| fallback_view)` is the
named owner error boundary referenced by the work and scheduler contracts: descendant `WorkFault`s,
poisoned computations, and draft faults route to the nearest enclosing boundary, which may render a
fallback, reset the subtree (a fresh mount), or rethrow upward. Without one, faults surface at the
window boundary with the full owner chain. The boundary is an owner like any other—its reset is the
ordinary reset-on-replacement path, not a second lifecycle.

### 1.4 Equality is policy, not a universal bound

The graph needs equality cutoffs, but `PartialEq` cannot be imposed on all UI values. Each node has
one of these policies:

- `Eq`: compare values with a supplied equality function or `PartialEq` convenience constructor.
- `Revision`: compare an application-provided monotonically increasing revision.
- `Identity`: compare stable pointer/handle identity.
- `Always`: always propagate; explicit and visible for opaque values.

Framework primitives choose appropriate defaults. Styles compare compact resolved values; text
buffers compare revisions; `Arc` resources normally compare identity; animation clocks always
propagate while active. Devtools reports `Always` nodes that fan out broadly.

### 1.5 One-way values and two-way controls stay distinct

Builders accepting `Property<T>` are one-way. Interactive controls name the state they edit in the
method, so the common two-way case introduces no `Binding<T>` object at all:

```rust
checkbox().bind_checked(todo.done)
slider().bind_value(settings.volume).range(0.0..=1.0)
select(options).bind_selected(selection)
```

`bind_checked` accepts exactly `State<bool>` and derives both directions from that one key; mismatched
lineage cannot be constructed. Reversible adaptation is explicit but still descriptor-based:
`slider().bind_map(settings.volume, to_slider, from_slider)`. A fallible reverse function rejects an
edit before publication. The control reports edit origin and revision so a model echo is
acknowledged instead of replayed as a new user change.

Controls can also own local state created during mount and expose a read handle/events upward. The
API never ambiguously switches between controlled and uncontrolled behavior because an optional
prop changed at runtime. Text uses the richer `TextFieldState` contract rather than a generic string
binding alone.

### 1.6 Rust UX is a budget

Public types should remain shallow enough for rust-analyzer and error messages. Complex storage,
brands, queue nodes, circuits, read/write projections, and bitsets stay behind inferred descriptors;
ordinary application signatures normally name only `State<T>`, `Scope`, and `Update`. `Property<T>`
appears in framework builder bounds, not variable declarations. Advanced custom widgets name their
phase capability. Builder methods return concrete or `impl IntoElement` types without exposing a
type-level dependency graph.

Every fallible dynamic boundary has a `try_` form used by framework internals and an ergonomic
located convenience for application code. Duplicate keys, disposed owners, feedback loops, invalid
portal anchors, and stale snapshot application report the definition and operation chain. Devtools
can answer “why did this update?” without requiring macro expansion knowledge.

Error-message quality is a listed gate, not a hope. Every sealed public bound (`Property<T>`,
`WorkInput`, `IntoElement`, handler bounds, the virtualization requirements builder) carries
`#[diagnostic::on_unimplemented]` text that says what the builder actually accepts and states that
the trait is sealed—the default “consider implementing `Property<Pixels>`” suggestion is actively
wrong for a sealed trait. Noisy blanket conversions carry `#[diagnostic::do_not_recommend]` so a
port mismatch reports the mismatch, not a fourteen-impl candidate list. CI snapshots the rendered
errors (trybuild), because a malformed diagnostic attribute degrades silently.

Thread bounds are attached to operations, never sprayed across the model vocabulary:

| Surface | `Send`/`Sync`/`'static` requirement |
|---|---|
| `State`, generated fields, `Property`, `Scope`, `Update`, `list`, events, layout, paint | no `Send`/`Sync`; keys/runtime are deliberately local. Arena-stored value types are normally `'static` because the arena outlives the call, not because they are global. |
| immediate phase callbacks that execute before return | may borrow for that call under the phase lifetime; no `Send`/`Sync` |
| ordinary callbacks retained under an owner | own their captures (`'static` in Rust's stored-callback sense); no `Send`/`Sync` because they run on the UI executor |
| `scope.local_resource` | owned future/output for retained lifetime (`'static`), but no `Send`/`Sync` |
| `scope.compute/resource` | only frozen input, worker callable/future, and result crossing the worker boundary are `Send + 'static`; shared callables are `Sync` |
| typed `Sender<T>` | the sender and message are thread-safe because this is explicitly the cross-thread bridge |
| short, joined scoped parallel helper | may borrow only because it joins before the calling stage returns; it is not a retained resource |

`'static` on any arena-stored callback/value means “contains no borrowed stack/phase reference,” not
“cannot be cancelled” or “lives for the process.” Short-lived APIs still use ordinary borrows.
Custom implementers can remain entirely local, opt into
`scope.local_resource`, or define a frozen owned boundary with `scope.input`; they need not make
their application model thread-safe merely because one operation uses a worker.

### Guarantee boundary

| Layer | It can guarantee | It cannot guarantee |
|---|---|---|
| Rust type system | local keys are `Copy` but `!Send + !Sync`; an access capability is required to dereference them; generated model fields have exact value types; property/port/unit/protocol compatibility; phase contexts cannot be substituted | a generational owner is still live; keys are unique; arbitrary closures are pure; a dynamic graph is acyclic |
| Generated sealed schema | field exists as an exactly typed source slot; a port belongs to its node kind; reviewed obligation/equality/interpolation/draft metadata is present; `Update::edit(field, ...)` can touch only that field draft | metadata has real-world semantic correctness without tests; an explicit aggregate draft changed only one field |
| Runtime validation | runtime/owner generations when a key is resolved, duplicate keys, dynamic edges/cycles, transaction/fault state, backend capability, damage escalation, queue/fence budgets | compile-time proof of future platform behavior or arbitrary user code |

No layer claims more than it can prove. Full recompute/full damage and delta from-scratch oracles
remain correctness backstops for generated and runtime incremental machinery.

Additional guarantees the type system owns, each with a compile-fail test:

- geometry values carry their coordinate space (`Point<Local>`, `Point<Window>`,
  `Transform<Local, Window>`; composition typechecks only along matching spaces and scale domains),
  so un-inverted hit transforms and cross-space anchor math cannot compile;
- `GeometryRef`/anchor keys and `LayoutCell` are `!Send`, implement neither `Property` nor a work
  input, and the cell's single writer is enforced by by-value consumption;
- `update.edit` requires `T: EditDraft` and `update.edit_all` requires an aggregate draft policy;
  ineligible types fail at the call site, not as a runtime policy fault;
- no handler-registration API accepts an async closure receiving `Update`; the capability is
  lifetime-bound and cannot cross an await—async work is spelled `action`/`spawn`/`resource`;
- motion builders are typestated: `.over(...)` yields the timed surface (`ease`, `delay`, `repeat`),
  `.spring(...)` the spring surface (`preserve_velocity` only where `Interpolatable::Velocity`
  supports it); mixing them is not a documented rule but a missing method;
- `Queue::Reliable` actions require input implementing an idempotency-key trait; non-keyed inputs
  only construct `Latest`/coalescing policies;
- colors split sRGB-encoded `Color` from `LinearColor` at blending/shader-uniform boundaries with
  explicit conversions, so wrong-space blending is unrepresentable in typed ports
  (public style chains name only `Color`; see [runtime/color.md](runtime/color.md));
- the positional `positional(...)` row closure receives a reduced `ItemScope` without local-state,
  focus, or drag capabilities, so interactive rows do not typecheck outside keyed `list`;
- the joined parallel helper follows the `std::thread::scope` shape—user code never owns the scope
  value—so a leaked scope cannot outlive its stage boundary.

Compile time, monomorphization, binary size, and rust-analyzer latency are benchmark gates alongside
frame time. A zero-runtime-cost type trick that materially damages the developer loop is not free.

Pinned language-feature choices (stable baseline 1.97; recorded so nobody “improves” them onto
nightly):

- `local_resource`, `drop_zone(...).validate(...)`, and `spawn(...).then(...)` take `AsyncFn`
  bounds (stable 1.85) so async closures work at call sites; cross-thread `resource` keeps the
  two-parameter `Fn -> Fut` spelling because bounding the returned future's `Send`-ness needs
  return-type notation, and migrates when RTN lands. Located work-edge errors capture
  `Location::caller()` in the synchronous wrapper because `#[track_caller]` on `async fn` is
  unstable.
- Generated schemas emit `const {}` cross-consistency asserts (mask width covers field count, no
  duplicate field/slot ids, dense port ranges), moving a class of “tests enumerate every field”
  checks into `cargo check`; const-trait folding of static style layers is a forward-compat note,
  never a semantic dependency.
- Cold node payloads use one `trait RetainedPayload: Any` storage supertrait and stable trait
  upcasting (1.86) instead of per-capability `as_any` shims.
- Sealed descriptors use the `Copy` `core::range` types (1.96) internally and accept the legacy
  `std::ops` ranges at builder boundaries, keeping descriptor bundles unconditionally `Copy`.
- The capability-first call shape (`update.get(state)`, not `state.get(update)`) is the committed
  stable-Rust form; arbitrary self types remain blocked upstream and are not load-bearing here.
- `#[derive(Reactive)]` field metadata is shaped as per-field marker types aligned with the
  field-projections RFC (3735) so the derive shrinks to a shim if/when projections stabilize.

### 1.7 Typed retained ports and deltas

Every framework primitive property has a generated, sealed typed descriptor conceptually shaped
like `Port<NodeKind, T, ObligationClass>`. A `Port<DivProps, Pixels, LayoutThenPaint>` cannot be
used where a `Port<TextProps, SharedString, TextShapeThenMaybeLayout>` is required. Public builder calls
remain `.w(value)` and `.child(text(value))`; the port descriptor is resolved internally to a dense
slot id, equality policy, patch thunk, and reviewed obligation metadata. This puts destination
semantics—where they actually belong—into generated types and code, without infecting every source
as `State<T, LayoutDirty>` (one source can feed ports with different obligations).

Change is represented as a small typed algebra rather than universally as `T` replacement:

```text
Replace<T> | FieldDelta<M> | ListDelta<K> | TextEditDelta<Units, Revision>
| StyleMask | SceneRangeDelta | GpuRangeDelta
```

This algebra is the system's spine, not an internal encoding. The mutation descriptors of §1.1 are
its public constructors (`count.add(1)` *is* a `FieldDelta`), `Update` has one underlying write
primitive—`apply(delta)`—of which `set` (a `Replace`) and `edit` (a draft that derives its delta)
are sugar, and the same values flow through every mechanism that touches change: optimistic tags
apply and invert them, `KeyedList` operations and drag commits are `ListDelta`s, text edits are
`TextEditDelta`s, and a test can assert “this event produced exactly these deltas” without
rendering anything.

Undo follows the EtoileUI/CoreObject lesson rather than the NSUndoManager one. **The
normative encoding is [08-history.md](08-history.md)** (capture vs tag, DAG + tracks,
traits). The rest of this subsection is the decision record that 08 absorbed.

The model side is automatic—an opt-in per-owner journal records
each atomic logical epoch's deltas (the epoch is the natural transaction unit; nothing extra is
captured), and entries are serializable typed values, never closures, so undo state survives
process termination and enters the persistence seam unchanged. The UI side decides which epoch
boundaries are user-visible undo points (`update.undo_boundary(label)`, with coalescing policy for
typing bursts), because “what one Cmd-Z means” is presentation policy, not a property of the
change. An undo is an ordinary transaction applying inverses with `origin = Undo`, so controls
treat it as an external edit under the §1.5 echo rules and IME stays coherent; redo is the retained
forward transitions; and because concurrent-edit rebasing already exists for text and drag,
selective and branching undo—undoing an old change by rebasing later deltas across its inverse—is
delta transformation on the same algebra, not a second history system. Non-invertible entries
(wildcard aggregate edits) journal an explicit before-snapshot or mark the boundary
coarse-grained; the journal never silently claims reversibility it does not have. Because handlers can
be pure event-to-delta functions, event logic is unit-testable with no runtime, and recording the
delta stream gives the inspector time-travel for free—one algebra, learned once, powering
mutation, rollback, undo, collaboration seams, and assertions.

Each delta operator defines application, batch merge/coalescing, inverse/oracle strategy where
needed, revision rules, and a conservative reset fallback. It must have a debug from-scratch oracle
for randomized differential testing. `update.prior(state)` is deliberately not free: retaining an old
value may clone, retain an `Arc`, or ask a revisioned model for a snapshot. Direct field sinks need
not materialize an old model; classifiers requiring old/new values declare that cost and are
benchmarked. An implementation may choose `Always` or a conservative obligation over an expensive
old-value recovery, but must expose that choice in counters.

Observer removal is O(1) or amortized O(1): each subscriber stores reverse-edge/list links or
tombstones owned by its owner epoch, and compaction is budgeted. No node teardown scans all sources.
Generational ids include a reuse policy that treats wrap as a terminal/epoch-renewal condition in
debug and production rather than permitting an ancient handle to become valid after wrap.

## 2. Retained window substrate

### 2.1 Stable node identity

Each window owns a generational `NodeArena`. A node contains only handles/indices to larger records:

```text
RetainedNode
  parent / ordered children
  owner scope
  element kind + property slots
  computed style + dirty masks
  persistent Taffy NodeId
  geometry and scroll transform
  dispatch / focus / IME records
  accessibility record
  paint fragment handle + ink bounds
```

This is data-oriented retained storage, not a general ECS rewrite. The hot node header slab stores
parent/child representation, owner, generation, kind, compact dirty summaries, geometry, and hot
flags. Property storage is kind-segregated (`DivProps`, `TextProps`, image, custom retained kind)
so a direct patch is one validated dense-slot write plus its generated thunk; uncommon handlers,
diagnostics, accessibility overflow, and unusual style values live cold/out of line. Registered
custom retained kinds provide typed properties and erased measure/paint/semantic thunks, paying
indirection only when that dirty kind runs.

Do not mandate one asymptotic structure everywhere. Child order, dirty children, scene order, and
damage each choose an adaptive representation with recorded crossovers: inline `SmallVec`/`Vec`
for tiny or contiguous sets, sorted ranges/bitsets for dense local dirt, and an order-maintenance
tree/sum-tree only when mutation/range-query scale justifies it. Promotion and demotion have
hysteresis to avoid workload thrash. A full-scene contiguous-vector fallback is required when
damage or order locality collapses; it is often faster and safer than forcing a tree through a
dense rebuild.

Generations catch stale handles. Node ids are never derived solely from author strings or call-site
locations. An explicit `ElementId` is a semantic lookup label, not allocation identity; duplicate
labels produce a located error instead of silently aliasing state.

Owners form a tree parallel to structural lifetime, not visual containment. Unmounting an owner:

1. marks its nodes logically dead so queued callbacks cannot observe half-torn state;
2. aborts tasks and resources;
3. removes reactive observers and event listeners;
4. retires dispatch, accessibility, layout, and paint records;
5. frees arena slots after the current dispatch/flush epoch.

Deferred physical reclamation makes teardown reentrancy deterministic without letting stale handles
become valid again.

An optional, later static-blueprint macro may compile static component shape into dense owner-local
node indices, constant property payloads, dynamic ports, semantic slots, and source locations.
Blueprint mounting is an allocation/locality optimization only: it lowers to exactly the same
explicit primitives, is never required for correctness, and cannot be required for peak
already-mounted leaf-update performance.

### 2.2 A UI is several related trees

Do not force ownership, layout, event routing, semantics, and paint order into one parent pointer.
Each retained node can participate in distinct, validated relationships:

- **owner tree:** lifetime of state, callbacks, tasks, and resources;
- **logical/event tree:** capture/bubble path and inherited application context;
- **layout tree:** Taffy parent/children and measurement dependencies;
- **paint/stacking tree:** clips, transforms, isolation groups, z order;
- **semantic tree:** accessibility parent/order and labelled-by/described-by relations.

They agree for ordinary elements and diverge deliberately for portals. A menu, tooltip, popover,
modal, drag preview, or editor completion list can paint in a window overlay while remaining owned
by its invoking component and routing events/semantics through an explicit logical relationship.
Portal mount specifies focus scope, dismiss policy, anchor geometry, clipping root, semantic parent,
and z-order band. Closing the anchor cancels the portal owner atomically; a stale anchor cannot leave
an orphan overlay. Where the platform requires a menu/tooltip to escape the window bounds, a portal
may target a native auxiliary surface (a borderless child window on the same UI executor): ownership,
focus scope, and dismissal stay with the invoking component; coordinates translate at the surface
boundary; and the auxiliary surface follows the same per-window damage/presentation rules. Desktop
context menus at screen edges are in scope, not an unhandled special case.

This separation also prevents common retained-tree bugs: a transform need not reparent semantics,
an accessibility grouping need not alter flex layout, and an exit animation may remain in the paint
tree after it leaves normal event/focus order while its transition owner is still alive.

### 2.3 Arbitrary placement without arbitrary feedback

Normal flow is not the only layout vocabulary. Every retained node can expose a copyable
`GeometryRef`—a generational reference to published geometry, not an application `State`. A node
can use ordinary absolute/fixed positioning or declare a relation to any live geometry reference:

```rust
let trigger = scope.anchor(); // Copy geometry identity; no allocation beyond its placement slot

stack()
    .child(button("Open").as_anchor(trigger)) // publisher role is named; `.place_*` consumes
    .child(popover(menu)
        .place_below(trigger)
        .align_start()
        .offset(px(8.0))
        .flip_or_slide_within(surface_safe_area()));

selection_ring()
    .place_over(editor.selection_bounds())
    .size_like(editor.selection_bounds());
```

The fluent surface lowers to one of four honest modes:

- normal flow, which participates in Taffy intrinsic sizing;
- anchored placement, resolved after normal layout and excluded from intrinsic size;
- presentation transform, which moves already-laid-out content without changing layout;
- an explicit local constraint group, used only when multiple geometries genuinely solve together.

Anchored relations live in a sparse `PlacementGraph` over geometry ids and coordinate-space edges.
After normal layout it topologically resolves percentages of the anchor/self, transforms, scroll,
scale, writing direction, safe-area/collision policy, clipping root, and z-order band. A change to
one anchor visits only its placement descendants. The placement result, inverse hit transform,
paint bounds, and accessibility bounds publish in the same presentation epoch. Geometry keys are
capabilities resolved by the presentation stage; they cannot be sent to workers or read like state.

Arbitrary anchored output cannot feed normal-flow measurement, so the common graph is acyclic by
construction. A cycle reports the complete relationship chain and preserves the prior presentation.
The advanced constraint-group form declares its members/equations together, has a bounded solver,
and fails locally rather than opening general layout feedback. An anchor disappearing mid-turn uses
the relation's explicit `close`, `hide`, `last_position`, or `fallback(anchor)` policy. Cross-window
placement is rejected unless expressed as a portal remount into the target surface; coordinate
spaces, scale, focus, hit testing, and accessibility remain window-local.

This covers PanGui-style “position/size anything relative to anything” while preserving a retained,
incremental scheduler. Reparenting visual content is a portal/paint-tree operation, never an
unchecked mutation of ownership, logical routing, semantics, and layout at once. Blending between
intrinsic modes such as fit and expand uses the explicit motion/layout-transition strategies in
§5.4 rather than pretending every Taffy constraint is numerically interpolable.

### 2.4 Persistent layout

GPUI's current `TaffyLayoutEngine::clear()` discards the tree for every draw. The retained path keeps
one Taffy node per retained layout node and uses [Taffy's stable tree
APIs](https://docs.rs/taffy/0.12.2/taffy/tree/struct.TaffyTree.html) (`set_style`, `set_children`,
insert/remove/move, `mark_dirty`, cached layout computation).

Layout invalidation carries a reason:

- own style/measure input changed;
- child sequence changed;
- descendant intrinsic size changed;
- available-size or scale boundary changed;
- global font metrics changed.

The runtime marks the affected node and the minimum necessary ancestor chain. A root layout is
allowed when constraints genuinely propagate to the root; it is counted separately so accidental
root fallbacks are visible. Geometry observers run after layout with a strict iteration cap and
diagnostics for the chain that kept changing geometry.

Persistent Taffy is necessary but not sufficient: the plan must benchmark actual nodes visited and
measured, not merely the presence of dirty flags.

### 2.5 Retained dispatch, hit testing, and accessibility

Event handlers are stable registrations owned by nodes. Changing one handler replaces one slot;
removing a node unregisters the subtree. GPUI's action/keymap system is retained dispatch data on
the same substrate: key bindings resolve against action registrations along the retained focus
path, a keymap change patches the resolution index rather than rebuilding dispatch, and actions
remain plain types delivered through the same capability-carrying handlers. Dispatch snapshots a generational logical path for one
event; structural commands apply after dispatch, and a revoked owner is skipped safely. This avoids
iterator invalidation while preserving the rule that the next queued event sees the committed tree.

Hit-test entries live in an updatable spatial index. Eligible scrolling/placement stores leaf bounds
in local coordinates under a transform node; a query applies the inverse accumulated transform, so
changing that transform does not visit or reinsert every leaf. Content that cannot use a transform
node updates/reinserts the affected entries explicitly. A “translated index” claim is accepted only
when queries and invalidation share this representation. Focus, pointer capture, drag capture,
hover, and IME ownership pin their node until the protocol releases it or teardown sends a defined
cancellation event.

A transform/composite update commits as one retained geometry revision across paint bounds,
hit-test inverse transform, and accessibility bounds. If any consumer cannot represent the update
incrementally (non-invertible transform, platform accessibility limitation, rasterized effect), the
classifier promotes it to the required geometry/paint/a11y path. The runtime never claims a GPU-only
transform while pointer targeting or semantic geometry still describes the old location.

After geometry, hit-testability, modal scope, or z order changes, a stationary pointer is re-hit-
tested before presentation and the resulting enter/leave transitions settle within the bounded
turn. Pointer/drag capture keeps routing to its live captured node regardless of hover; teardown
sends cancellation and releases the platform capture exactly once.

Accessibility nodes are retained and published as add/update/reparent/remove deltas. Focused nodes
and active text input must remain represented even when a virtualizer would otherwise recycle
their visual row. Accessibility ordering follows semantic order, which may differ from paint order.

### 2.6 Retained paint fragments and pixels

Every paintable node owns a `SceneFragment`: immutable primitive records, resource references,
local bounds, and a local-to-window transform. Repainting replaces that fragment only. Moving a
fragment may update a transform and damage old/new ink bounds without re-emitting primitives.

Global order is represented by an order-maintenance structure built on `gpui_sum_tree`, with
summaries for primitive count and bounds. Structural splices, moves, and range iteration are
logarithmic plus the changed range. Stable order labels leave gaps; relabeling is localized and
counted. Overlap, filters, opacity groups, and backdrop effects can widen damage or force an
offscreen group, but the widening reason is explicit.

Order is not a damage index. The scene also keeps an adaptive spatial index over conservative ink
bounds (small contiguous scenes may scan a vector; larger sparse scenes use tiles/R-tree-like
buckets). Damage replay queries spatial candidates, then restores paint order before composition.
False-positive candidate count/area is a first-class counter; index selection cannot silently turn
a small dirty rectangle into a whole-scene scan. A dense/large-damage crossover promotes to the
contiguous full-scene path with an explicit reason.

Damage is a statement about target pixels, not merely changed fragments. The initial target has an
empty valid region; successful full/partial composition grows validity, while resize, scale change,
format change, device loss, or discarded target clears it. For each damaged rectangle the scene
stage computes conservative old/new ink damage, widens through clips, shadows, filters, opacity/
blend groups, backdrops, and occlusion dependencies, then clears/restores the correct background and
replays **every ordered fragment whose output contributes to those pixels**, including unchanged
overlapping fragments. Repainting only the changed fragment is never considered sufficient.

Transform-only layer movement may copy/recompose previously valid pixels only when source/destination
overlap, sampling, clip, blend, and backdrop rules make that operation correct; otherwise it falls
back to fragment replay. Copy paths use an overlap-safe direction or scratch target and damage both
vacated and newly covered regions. Damage coalescing has a cost/area heuristic and may promote to
full target work without changing correctness.

The frame handed to a renderer is a view over retained fragments plus a `DamageSet`, not proof that
all visible GPU commands disappeared. Each operation can select one of these paths; these are not a
single global rank assigned to a backend:

- **Tier 0:** full scene/full surface, always correct fallback.
- **Tier 1:** replay cached fragments but redraw the surface.
- **Tier 2:** submit only damage-intersecting fragments into a retained target.
- **Tier 3:** translate/recompose eligible retained layers without primitive re-encoding.

Submission does not lend mutable arena storage to an asynchronous renderer. A `FramePacket` owns or
pins immutable fragment/chunk/resource versions and target-validity metadata until the backend fence
retires them. The next UI turn may swap a node to a new fragment without mutating the submitted
version. Atlas entries, textures, buffers, and removed nodes use fence-aware deferred reclamation;
device loss invalidates backend residency while preserving enough CPU description to rebuild or
request resource reupload.

A later Tier 4 may retain stable GPU primitive/glyph-instance slots. A port patch then updates only
declared CPU/GPU ranges; a text delta splices glyph ranges and a transform updates a matrix range.
This is optional backend specialization, never an assumption of the core renderer. CPU scene
descriptions remain authoritative for device loss, and slot reuse is fence- and generation-aware.
Pinned packet bytes, in-flight packet versions, and renderer wait time have hard budgets. On a
renderer stall the scheduler coalesces compatible deltas, applies backpressure, or promotes to a
bounded full-scene contiguous packet; it never mutates GPU-visible storage or allows unbounded
version retention merely to preserve locality.

Occlusion, swapchain loss, scale changes, renderer reset, or unsupported surface preservation can
promote a frame to a lower tier. Partial-presentation support is only a platform hint: the framework
may keep an intermediate persistent target and still blit/present the whole swapchain image. Pixels
outside damage are trusted only in the framework-owned target's valid region, never because a
swapchain happens to retain them. Damage retires only when the renderer reports successful
submission of the content that covers it.

### 2.7 Renderer frontends are a bulk lowering boundary

The retained core does not permanently standardize on `PlatformWindow::draw(&Scene)`. A window
negotiates a renderer frontend from independent capabilities, then submits immutable `FramePacket`s
containing changed fragment/range references, resource operations, media import leases, render-graph
passes, damage, target validity, surface/device generations, scale, and output color space. Backend
selection occurs once per packet/pass/range—not through a trait-object call per primitive. A built-in
backend enum or monomorphized frontend is permitted when it measures better than dynamic dispatch.

The boundary has three owners:

- the retained core owns backend-neutral fragments, resource identities, damage and the full replay
  oracle;
- the renderer frontend owns device resources, pipelines, atlases, staging rings, native imports,
  residency, command encoding, fences and deferred destruction;
- the platform window owns the native surface, frame pacing and presentation events.

Core scene records therefore contain no `Any`, `CVPixelBuffer`, wgpu texture, D3D resource or Metal
object. A native producer obtains a typed, generational importer advertised by its renderer and
returns an opaque `ImportLease`; only that matching frontend can open it. The lease and its source
planes remain alive until the exact GPU fence retires. Device loss increments the device generation,
rejects old imports and residency, and replays from the cheapest authoritative CPU/encoded/provider
representation instead of corrupting a new device with an old handle.

Capabilities are orthogonal bits and limits—retained target, damage replay, partial present,
transform/layer recomposition, stable slots, range uploads, external plane formats, HDR/protected
output, timestamps, custom pass formats and readback, and **system-compositor surface promotion**
(an eligible scroll region, video plane, or overlay may become an OS compositor surface—CALayer,
DirectComposition visual, Wayland subsurface—so scrolling and video presentation become compositor
work with no per-frame submission, falling back to in-target recomposition where unsupported or
where lowest-common-denominator compositor effects would degrade output)—not one global quality
tier. Lowering chooses
the cheapest valid path for each resource/pass. An unsupported native video import falls back to
plane or RGBA upload without demoting unrelated retained primitives. Metal, DirectX and wgpu may
therefore specialize allocation, binding, upload and video import all the way down while consuming
the same correctness packet. A deterministic software frontend consumes it as the oracle.

The complete packet, importer, device-loss, multi-window and ownership contract is in
[runtime/media.md](runtime/media.md#5-renderer-frontend-composition). It is part of the Phase 3 exit
gate, not a post-hoc backend optimization.

### 2.8 Inspector and deterministic test protocol

Inspection and integration testing consume the retained truth; they do not maintain a shadow UI or
invoke callbacks directly. After a successful presentation publication, an opt-in immutable
`UiSnapshot` can materialize:

- generational node/owner identity and logical, layout, paint, and semantic relationships;
- bounds, constraints/results, coordinate transforms, clips, z order, hit result, focus/capture,
  and accessibility role/name/value/actions;
- resolved property values with static/variant/inline/animation provenance, source locations,
  dependencies, revisions, equality decisions, obligations, and “why changed” chains;
- event routes/listener labels, scene fragments, damage, animation/work state, shader/pass/resource
  diagnostics, and redacted model metadata.

The snapshot carries its logical and presentation epochs. A locator is a query plan re-resolved
against the latest snapshot, not a retained node pointer; a disposed generation yields a stale-node
diagnostic. Full snapshots/history, source stacks, graph edges, and tracing are dev/test opt-ins.
With inspection disabled, normal builds retain only runtime data already required for rendering,
input, and accessibility; the inspector adds zero per-node hot-path allocation. Accessibility
materialization remains independently capability/budget controlled.

One versioned protocol serves the in-process inspector, test harness, and an optional remote
frontend:

```text
target/list, snapshot/get, snapshot/diff, query, highlight,
input/inject, clock/advance, settle, trace/start-stop,
screenshot/capture, profile/get, shader/diagnostics
```

The remote side sees serialized snapshots/deltas, never `App`, `Window`, local keys, callbacks, or
unredacted values by default. It is a development feature, binds to loopback, requires a random
token, and separates read/inspect from input/mutation capability. The visual inspector provides a
node picker/highlight overlay; logical/layout/paint/semantic tree views; box model and constraint
provenance; live style/property editing in a temporary inspector layer; accessibility, listener,
animation, work, memory, damage, and frame timelines; shader errors and render-pass/resource views;
and graph queries such as `why_changed(node, property)`.

The Rust integration-test UX follows semantic, auto-retrying locators:

```rust,ignore
#[ui_test]
fn keyboard_drag_moves_card(test: &mut UiTest) {
    test.clock().freeze();
    test.mount(board_fixture());

    let card = test.get_by_role(Role::ListItem, "Write plan");
    card.focus().press("Space").press("ArrowRight").press("Enter");
    test.settle();

    test.get_by_role(Role::List, "Doing").expect().contains_text("Write plan");
    test.expect_a11y_tree("board-after-move");
    test.expect_trace("keyboard-drag");
    test.expect_image("board-after-move");
}
```

`UiTest` owns a deterministic platform, virtual monotonic clock, seeded executor/work completion
controller, fixed viewport/scale/color profile/font fixtures, and reference renderer. Input travels
through real hit testing, capture, focus, IME, routing, updates, settlement, and presentation.
Locators prioritize role/name, label, text, and explicit `.test_id`; actions require one visible,
enabled, stable target that actually receives events. Assertions retry over finite scheduled work,
but `settle()` does not advance clocks or wait forever on animations, streams, or external I/O.
Tests explicitly advance time and complete/mock work.

Exact semantic, scene-command, event, and work-count snapshots are portable. Exact pixels require
the pinned software/reference renderer and pinned fonts; real GPU/platform screenshots use per-
platform baselines or a documented perceptual tolerance. A custom shader participates in exact
reference pixels only when it supplies a deterministic CPU/reference implementation; otherwise its
pass/resources/uniforms are asserted exactly and its GPU output uses the platform/tolerance policy.
Failure artifacts bundle before/input/after
snapshots, event/epoch/work trace, screenshot, source locations, and the smallest relevant graph
slice. The same trace viewer provides time-travel debugging in the inspector.

### 2.9 Hot reload is designed in, not retrofitted

Two mechanisms in this plan are hostile to state-preserving code reload if left as-is: deforested
property wires store monomorphic fn-pointer thunks into old code, and state slots deliberately have
no call-site-derived identity across re-mounts. Both get dev-mode variants now, because they touch
`Scope::state/model` allocation and wire representation:

- **A patch point in the host turn.** Code patches (Subsecond-style binary patching or a relaunch
  handshake) apply between epochs, as another wake reason; the runtime then re-runs affected mounts.
- **Dev-mode stable slot keying.** In dev builds, `scope.state/model/keyed_list` slots carry a
  location+type+ordinal fingerprint used to re-associate surviving state after a patch; a mismatch
  disposes that slot (the Subsecond dispose-or-migrate contract). Production builds compile the
  fingerprint out; it is never allocation identity in release.
- **Rebindable wires in dev.** Dev builds bias lowering toward the operator-tag/kind-table
  representation (already preferred for batching) instead of raw monomorphized thunks, so patched
  operator tables rebind; subtrees containing arbitrary `.map(f)`/`memo` thunks remount on patch.
  Release keeps the fused representation; the dev/release lowering delta is a stated benchmark
  fixture, not a silent fork.
- **Cross-compile-stable schema ids.** Style fields, ports, and `#[derive(Reactive)]` metadata hash
  from names/types, never compilation order, so a patch does not invalidate every wire.
- **A runtime style overlay.** The inspector's temporary style-edit layer doubles as a dev
  stylesheet: a watched class-string file re-lowers through the same schema (a dev-mode `tw!`
  grammar parser) with zero release cost—Vizia-class style hot reload for the spacing/color/variant
  iteration loop that dominates UI development.

Because state lives in runtime arenas rather than code, a working patch preserves scroll positions,
focus, IME composition, and running animations—something no surveyed Rust framework currently does
(iced's reload discards all view state by design). Reload latency joins the developer-loop
benchmarks.

## 3. Invalidation model

Invalidation is an obligation lattice, not one dirty bit:

```text
Structure
  -> Style
     -> Layout
        -> Geometry / HitTest / A11yBounds
           -> Paint
              -> Composite / PresentDamage

Independent obligations: Semantics, EventRouting, TextShape, Resource, FocusOrder
```

An obligation records the smallest node/subtree/range known to owe work. Promotion is monotonic
within a frame; servicing a phase retires only the obligation it handled. Examples:

- background color: `Paint(node)`;
- opacity on an isolated fragment: `Composite(node)`;
- width: `Layout(node)` then geometry-dependent downstream work;
- string edit: `TextShape(paragraph, changed_range)` and usually layout;
- child reorder: `Structure(parent, splice)` plus order/focus/a11y deltas;
- scroll offset: transform, hit-index translation, exposed-band damage;
- enabled flag: event routing, semantics, and often paint, but not necessarily layout.

Dirty-child summaries prevent a phase from walking clean siblings to find the dirty ones. For small
fanout, store exact child indices inline; for larger fanout, store sorted ranges or a compact bitset.
Both marking cost and traversal cost are instrumented because optimizing one can hide work in the
other.

## 4. Reactive scheduler

An edit body mutates an isolated draft so an event handler can read its own pending write. Normal
return contributes the draft to a sparse logical epoch; unwinding drops it without touching
published storage. The transaction coalesces changed field slots, marks dependents, and settles
without recursive reactive execution. Retained ports/geometry remain published snapshots during
the handler. The
API does **not** promise source snapshots and retained geometry agree mid-transaction, and no
layout/paint may run then. A successful canonical settle atomically publishes source/derived/
structure/port state as one logical epoch; a settle fault drops its sparse draft. Presentation has
the separate sparse epoch described below.

A host turn is:

```text
one platform event
  -> handler writes / commands
  -> write-incapable tracked computations
  -> structural draft
  -> properties introduced by structure
  -> compact direct/field/sealed-circuit sinks
  -> atomically publish logical epoch
  -> after-publication effects; writes become a new transaction
  -> repeat for next queued event

frame requested
  -> sparse presentation draft from newest logical epoch
  -> style -> layout -> restricted sealed geometry feedback
  -> relayout only if declared feedback wrote, bounded by the geometry cap
  -> hit/a11y -> prepaint -> paint -> composite packet
  -> atomically publish interaction/presentation epoch -> submit
  -> publish a11y and counters
  -> park until event, wake, timer, animation deadline, or renderer retry
```

Settling between separately dispatched input events ensures the second event sees the first event's
structural changes. Multiple writes inside one handler remain implicitly batched.

Dynamic dependencies are discovered during computation. On every recomputation, old and new input
sets are diffed; reverse edges are updated, and node height is raised or lazily repaired when an edge
would violate topological order. Dirty nodes are processed in height order with equality cutoffs.
Small heights use buckets; sparse/high graphs use a heap. Complexity claims are benchmarked; the
design does not promise O(1) scheduling for dynamic rewiring.

Cycles are detected while a computation is active or when new edges are drafted—not at an
unrelated state write. Diagnostics print the complete dependency path and definition locations. A
separate per-turn work budget catches cycles routed through effects or observations; exhaustion
does not silently present partially settled state. In debug/test it is an error. In production it
records a fault, preserves the last committed frame, and schedules a bounded retry according to
policy.

Write-incapable tracked/dynamic computations run before structural and property consumers. The fixed
logical protocol is `tracked computations -> structural draft -> properties introduced by structure
-> compact direct/field/sealed-circuit sinks -> validate -> publish`. After-publication effects may
start a later transaction but cannot alter the epoch that triggered them. Layout observations use
restricted `LayoutFeedback` over sealed layout-only cells; accepted feedback writes relayout the sparse
presentation draft before hit/a11y/prepaint. A
property sink only writes a retained port and emits obligations—it is not a user effect and cannot
arbitrarily enqueue user code. This prevents an effect from exposing half-applied structure to
paint and lets direct sinks remain allocation-free after slab growth.

Static circuits carry framework-specified purity/equality/classifier contracts and may fuse into a
direct port patch. Arbitrary `.map(f)` is a fixed-edge user thunk; `scope.memo(f)` tracks branches
at runtime. Neither fuses merely because its closure looks small. A shared derived slot computes
once per settle then serves all sinks. Faults are isolated by phase: a computation/equality/
classifier fault during settle drops the logical draft rather than partially invoking its
consumers, while a fault during a handler's demand read (`update.get(derived)`) poisons that node
for the transaction—`update.try_get` reports it, the located panic names it—without discarding
unrelated writes the handler already staged. A poisoned node keeps its last published output, its
sinks do not run, and the fault routes to the owner error boundary; one panicky third-party memo
cannot silently destroy a valid user edit staged in the same transaction.

The publication mechanism is sparse, not universal MVCC. Changed logical records live in an
overlay until one epoch swap; changed layout/hit/a11y/scene records live in a presentation overlay
until its swap. Unchanged arena records are shared, old interaction/presentation epochs pin owners
they reference, and dense work promotes to a contiguous double buffer. If presentation fails after
logical publication, application state remains published but the prior coherent interaction/frame
stays active; coordinate input waits for recovery instead of targeting mismatched geometry. Overlay
bytes, shadow copies, pins, queued-input latency, and dense promotion are mandatory counters.

There is no universal durability type parameter. Reverse dependencies already identify what a
write can affect; runtime priority lanes express urgency without making every generic type carry a
lattice:

- `Input`: pointer, key, IME, focus;
- `Animation`: deadlines that feed the current frame;
- `Normal`: application state;
- `Idle`: prefetch, cache warming, non-visible derivations.

Priority changes service order, never dependency correctness. Starvation counters and deadlines
force eventual progress.

Transient platform input is not automatically persistent reactive state. Click/key/text edit are
ordered/lossless event commands; pointer motion and resize are latest-value/coalesced samples;
scroll is accumulated delta sampled at frame cadence; animation is a clock-fed lane; background
progress chooses reliable/latest/coalescing explicitly. This prevents a 240 Hz pointer stream from
allocating graph work that has no durable UI consequence.

### Selective parallel stages without thread-safe local state

Single-writer state does not require every pure downstream stage to be serial. After settle, a large
dirty batch may lower the exact required inputs into an immutable `StageSnapshot` and partition
independent work such as selector/style lowering, paragraph shaping, image decoding, fragment
recording, or GPU upload preparation. Workers never receive `State<T>`, retained node references, or
window/platform objects—only owned `Send` values and stable ids plus input/owner revisions.

The UI thread validates those revisions before committing results in deterministic order. A stale
result is discarded or requeued; it cannot patch a reused arena slot. Work required for the current
frame joins before its stage boundary, so paint never observes partial results. Speculative/offscreen
work uses idle priority and may finish later.

Parallelism is thresholded from stored cost history. A one-label update stays entirely local and
pays no worker synchronization; a cold start, font/theme-scale change, or many independent
paragraphs/fragments may fan out. Taffy's dependency-ordered tree computation remains serial unless
its own supported algorithm changes, while independent measurement/shaping inputs may prepare in
parallel. Counters report snapshot bytes, tasks, join wait, stale discards, and speedup so work is not
merely moved off the measured UI thread.

## 5. Collections, text, async, and animation

### 5.1 Two collection APIs

`list(rows.keyed_by(key), row)` is the convenience API. It performs an O(n) key-sequence
reconcile when the vector changes. It preserves mounted row identity across moves, but replacing
the value for a resident key does not magically update a row that captured an old plain `T`.
Callers either make row fields reactive or use the scalable API:

```rust
KeyedList<K, V>
  insert / remove / move / update
  filter / sort arrangements
  per-key revision and ReadRow<K, V>
```

`KeyedList` emits structural diffs separately from resident-key value updates. A move preserves
node, owner, focus, and local state. An update patches the row source without remounting. Duplicate
keys are located errors. Diff-stream `UpdateAt` semantics from another library are not accepted as
evidence of keyed identity; identity is specified directly.

The convenience/vector tier is only chosen below a measured fixed `N_vec`; its move/range work is
documented O(N). The promoted order-statistics tree earns the O(log N) structural claims. Likewise,
only sealed field-aware filter/sort operators get per-row incremental invalidation; arbitrary
predicate/sort closures use wildcard dependencies and conservatively rescan/rebuild. Crossover,
wildcard, and arrangement-reset counters make these distinctions visible.

`list(...)` always means keyed identity; a `KeyedList` view already supplies keys, while a plain
`State<Vec<T>>` uses `.keyed_by(key)`. The deliberately lesser API is named for its downgrade:
`positional(values, row)` identifies rows by position, may remount the shifted suffix on
insertion/removal, and hands its row closure a reduced `ItemScope` without local-state, focus, or
drag capabilities, so stateful interactive rows do not typecheck there. Virtualization is a policy
on a keyed list—`.virtualize(extent)`—with fixed, estimated-variable, and measured extent models;
the argument is `impl Into<Extent>`, so the common fixed case is spelled `.virtualize(px(24.0))`. It overscans by policy, anchors scroll position
through extent corrections, and automatically retains focused/IME/composing, pointer-captured,
dragging, transition-active, or accessibility-active rows. The application does not enumerate those
reasons. Recycling is never allowed to transfer local state from one key to another.

For drag/drop over a keyed collection, identity and mutation are already known, so the 90% list
mutation/drop commit is destination-owned and callback-free (preview construction and optional
business validation remain ordinary callbacks):

```rust
let lane = cards.in_group(column);

list(lane, move |card, _| {
    card_row(card.title)
        .drag(card)
        .drag_preview(move || card_ghost(card.title))
})
.virtualize(extent)
.semantics(card_semantics)
.drop_zone(lane)
```

The retained drag world owns pointer capture, key-relative landing positions, preview portal,
virtualization pins, keyboard/accessibility operation, cancellation, order-revision validation, and
same-/cross-group atomic list deltas. App-owned collections can hand off across windows on one UI
executor without moving retained nodes between arenas. Optional `.validate(async_fn)` uses an owned
typed move request and the work-edge machinery; it never carries `Update` or local keys across await.
A generic typed-payload escape hatch exists for interactions not backed by a collection, but raw
platform events/`Any` payloads are not the default. See the complete example and guarantee boundary
in [examples.md](examples.md).

### 5.2 Text editing is a state machine

Text input is not `State<String>`. `TextFieldState` owns text revision, selection, affinity,
composition range, marked-text metadata, scroll/viewport state, undo grouping, and edit origin.
`TextBinding` is the model adapter: it distinguishes draft from committed/canonical value, exposes
parse/validation errors, and carries source revisions so an external model echo acknowledges the
edit rather than resetting selection or cancelling IME. Equality-only echo suppression is not
enough when a formatter canonicalizes text or composition is active. Conflicting external edits
choose an explicit policy: replace, transform through local edits, reject while composing, or
application merge.

It is also the retained implementation point for GPUI's current platform `InputHandler` contract:
selected/marked/replacement ranges and text length in UTF-16; adjusted text-range queries;
replace-and-mark/unmark; system-driven selection changes; element/range bounds for candidate and
selection UI; point-to-UTF-16-index hit testing; whether input is accepted; press-and-hold behavior;
and whether printable keys prefer IME routing. UTF-8/rope, grapheme, scalar, and UTF-16 coordinates
are converted through revisioned indexes. Geometry queries read the last committed layout snapshot,
never trigger layout or observe a half-applied edit; an edit queues the next layout/IME-position
publication.

The display pipeline uses rope/sum-tree edit ranges and hash-keyed shaping. An edit starts at a safe
text/shaping boundary. Unchanged runs and lines are reused when their content, style, bidi context,
and wrap constraints still match; soft wrap, bidi reordering, hyphenation, or shaping context may
legitimately rebreak or reshape the remainder of a paragraph. Unaffected following paragraphs
reposition through summaries. Font/scale changes deliberately widen invalidation. Password fields
prevent text from entering debug snapshots and accessibility values unless platform policy
requires it.

### 5.3 Resources and tasks

The common API declares a typed work edge, not its transport:

```rust
fn index_document(input: DocumentSnapshot) -> Result<Index, IndexError> { /* ordinary Rust */ }
async fn load_symbols(query: SymbolQuery) -> Result<Vec<Symbol>, LoadError> { /* ordinary Rust */ }

let index = scope.compute(document, index_document);                 // CPU pool, latest input wins
let symbols = scope.resource(workspace.symbol_query, load_symbols);  // async I/O, latest input wins
let save = scope.action(save_document).queue(Queue::Reliable);       // event-triggered, every input
```

The stable-Rust surface is conceptually:

```rust,ignore
pub struct Work<T: 'static, E: 'static> { /* copyable local generational key */ }

impl<T: 'static, E: 'static> Work<T, E> {
    pub fn pending(self) -> impl Property<bool> + Readable<bool> + Copy + use<T, E>;
    pub fn value(self) -> impl Property<Option<T>> + Readable<Option<T>> + Copy + use<T, E>;
    pub fn error(self) -> impl Property<Option<E>> + Readable<Option<E>> + Copy + use<T, E>;
}

pub fn compute<S, F, T, E>(&mut self, source: S, function: F) -> Work<T, E>
where
    S: WorkInput,
    S::Owned: Send,
    T: Send + 'static,
    E: Send + 'static,
    F: Fn(S::Owned) -> Result<T, E> + Copy + Send + 'static;

pub fn resource<S, F, Fut, T, E>(&mut self, source: S, function: F) -> Work<T, E>
where
    S: WorkInput,
    S::Owned: Send,
    T: Send + 'static,
    E: Send + 'static,
    F: Fn(S::Owned) -> Fut + Copy + Send + 'static,
    Fut: Future<Output = Result<T, E>> + Send + 'static;
```

The private `WorkInput` trait is shown only to specify framework behavior; product crates use built-
in inputs or `scope.input(source, freeze_fn)`. `compute_with`/`resource_with` are explicit shared-
callable variants. `local_resource` has the analogous owned API without `Send`/`Sync` bounds.

The inferred generic instantiation `Work<T, E>` is one copyable, read-only generational handle. Its
single runtime state is logically `Pending { previous, request }`, `Ready { value, request }`, or
`Failed { error, previous, request }`; transitions publish atomically, so `pending`, `value`, and
`error` cannot describe different requests. Opaque `index.pending()`, `index.value()`, and
`index.error()` accessors are read-only projections (`Property<bool>`, `Property<Option<T>>`, and
`Property<Option<E>>`) that borrow the stored value while patching and add no `T: Clone` bound. A
load-state destination can consume `Work<T, E>` directly. Product code never receives writable
status keys. Initially it is pending with no previous value; a new latest request preserves the last
value and clears the previous domain error; current success replaces the value, and current domain
failure preserves the last value while exposing `E`.

A private sealed `WorkInput` protocol has an associated owned type with only an ownership bound,
`type Owned: 'static`. Built-in documents, persistent values, generated snapshots, and tuples
implement it. Downstream code does not implement a private trait: `scope.input(source, freeze_fn)`
returns a framework-owned opaque input descriptor, making custom freezing explicit without opening
the scheduler contract. All tuple members freeze from one pending logical view. A `TextDocument`
yields `DocumentSnapshot`; persistent/`Arc` state can yield a cheap owned snapshot. Every reactive
configuration value belongs in the source tuple; a closure capture is mount-time configuration and
is intentionally invisible to dependency tracking.

Only the cross-thread methods add thread bounds. `compute` requires `WorkInput::Owned`, `T`, and `E`
to be `Send + 'static`; `resource` additionally requires its future to be `Send`. The ordinary
function/closure is `Copy + Send + 'static`, so a free function or small `Copy` closure can be
copied into overlapping jobs without hidden `Arc<F>` traffic. `compute_with`/`resource_with` accept a
non-`Copy` captured callable and explicitly pay shared callable storage (including `Sync` when jobs
may overlap). `local_resource` removes
all `Send`/`Sync` bounds and runs an owned `'static` future on the UI executor. Here `'static` means
the stored work owns its captures and contains no borrowed stack/phase capability; owner revocation
still ends delivery. Ordinary state, properties, builders, list rows, events, canvas callbacks, and
animations require none of these thread bounds.

Reactive configuration is ordinary tuple input rather than a captured hidden dependency:

```rust
let index = scope.compute(
    (document, workspace.index_options),
    |(document, options)| index_document(document, options),
);
```

That closure captures nothing and is `Copy`; both frozen values come from the same logical view.

Work launch is part of the atomic protocol rather than an afterthought:

1. During logical settle, freeze the complete input once against the immutable pending view and
   allocate a monotonically checked request ticket.
2. Stage `Pending { request }` in that same `LogicalDraft`. A freeze panic/fault aborts the draft;
   no task was launched for an epoch that never existed.
3. After the logical epoch swaps successfully, enqueue the already-owned input. Enqueue failure
   publishes a framework fault for that ticket; it is not forged into the domain's `E`.
4. Completion carries runtime id, work slot generation, owner epoch, request ticket, exact input
   stamp vector, and policy generation. It changes state only if every value still matches.

A newer latest request cancels a queued/not-started job and suppresses delivery from already-running
CPU work. Plain `compute(input, fn)` does not pretend to preempt or cooperatively cancel a running
function because the function receives no token. `compute_cancellable(input, |input, cancel| ...)`
is the explicit polling form. Dropping a resource future stops polling it when cancellation-safe,
but cannot promise that an underlying OS operation or server-side effect stopped. Latest-wins work
must therefore be repeatable and externally side-effect-free; saves/mutations use `action` with a
reliable policy and domain idempotency. Every source owner must dominate the work owner; installation
otherwise fails with a located lifetime error. Ticket/generation wrap revokes the slot rather than
allowing an ancient completion to alias a new request.

`E` is exclusively the ordinary function's domain error. Freeze failure/panic, worker panic,
executor shutdown, source/owner disposal, cancellation, and policy exhaustion are framework
`WorkFault`s routed to the owner error boundary and inspector; they are never forged into `E`.
A fault for the current request clears pending, preserves the last accepted value, and follows the
declared stop/retry/escalate policy. Retry/backoff is request- and policy-generation scoped: a newer
input cancels the old timer. Reliable actions that retry require an application idempotency key.
Tests and profile builds can project the framework fault for assertions, but it is not another
everyday application state cell.

#### Forks and optimistic writes

Two named primitives close the interaction-UX gap that TS frameworks solved with `useOptimistic`/
`createProjection`, using machinery this plan already requires:

- **`scope.fork(source)`** returns a writable projection key: reads pass through to the source
  until the fork is written, after which consumers of the fork see the local value while the source
  stays canonical. `update.clear(fork)` reverts to pass-through. It is the sanctioned local edit
  buffer (draft settings pane, staged filter, in-flight rename) without cloning the model or
  inventing parallel state, and it is the substrate the optimistic policy uses.
- **`action(...).optimistic(target, delta_fn)`** applies a typed, invertible delta to the target's
  presented value at dispatch, tagged with the action's request ticket. Success retires the tag when
  the canonical update lands (origin/revision echo, as in §1.5); failure or supersession applies the
  delta's inverse—the same inverse the delta algebra already defines for its from-scratch oracles—or
  the declared rebase/reject policy when later confirmed edits interleaved. Concurrent optimistic
  edits to one target apply and revert in ticket order, mirroring the drag protocol's stale-order
  rules; a reverted optimistic row animates out through the ordinary structural transition path.

Neither primitive introduces new scheduler phases: a fork is one cell with a pass-through rule, and
an optimistic tag is a pinned delta in the target's journal. TS frameworks implement rollback by
ad-hoc snapshot-and-restore in user code; here rollback is a typed inverse with a located diagnostic
when inversion is impossible, which is exactly when the policy must say `Reset`.

The abstraction removes redundant transport ceremony; it does not make asynchronous work
allocation-free. A mounted edge normally owns a task allocation/record, frozen or retained input,
observed output/status cells, a queue/wake path, and revision/cancellation bookkeeping. A freeze is
zero-copy only when the source representation permits it (for example, an `Arc` or persistent rope
snapshot); mutable contiguous data may require a copy. The gate is no more allocations, retained
bytes, wakes, or completion latency than the equivalent manual snapshot/sender/task/apply
implementation, with fewer mismatch states. “No abstraction overhead after lowering” is a measured
target, not a consequence of the type signature; background execution never costs zero.
Dependency-driven CPU and I/O work use
`compute/resource`; event-triggered work uses `action`; true progress streams/services, dedicated
realtime work, blocking foreign calls, and internal frame-parallel stages keep specialized surfaces.
The one coherent work-state record is necessary even when the handle is consumed whole. Accessor
projections add fanout wires only when mounted; they do not create separately mutable status cells.

An imperative one-shot keeps plain future composition without exposing a mailbox:

```rust
scope
    .spawn(upload(bytes))
    .then(move |update, receipt| update.set(upload_receipt, receipt));
```

The completion runs on the UI thread with `Update` only if its owner epoch is live. Long-lived
multi-message protocols may opt into a typed task stream/mailbox; it is not the default for a single
result. Local non-`Send` I/O uses the explicitly named `scope.local_resource` and the same owner/
revision semantics.

All callbacks, listeners, timers, and tasks have an owner. Teardown revokes their epoch before
running cleanup. A queued completion can therefore be harmlessly rejected even if the executor
cannot cancel the underlying operation.

### 5.4 Images, video, and native media

Images and video use one typed acquisition-to-presentation pipeline instead of element-owned tasks,
eager frame vectors, public source enums, or platform texture variants in the scene. Authoring stays
plain Rust:

```rust,ignore
image(asset!("icons/logo.svg"))
image(path)
image(http.get(avatar_url).header(ACCEPT, "image/avif,image/webp,*/*"))
image(bytes)

video(path)
video(http.get(movie_url).bearer_auth(token))
video(camera.frames())
```

`image` and `video` accept sealed generic `MediaInput<Still/Timed>` installation descriptors. The
framework supplies implementations for embedded assets, paths, URLs/request builders, byte buffers,
`Work` output and native/provider descriptors; the common path does not allocate a public trait
object or retain the generic builder. Applications with databases, authenticated stores, generated
frames, or cameras implement `MediaProvider`, whose bounded sink receives metadata/chunks/frames but
never `Window`, `App`, destination state, or a renderer borrow. `scope.media_local` keeps local
producers local; `Send + 'static` appears only when a selected acquisition, decoder or device lane
actually crosses threads.

Mount lowers the source to a compact recipe and destination port. Constant sources create no graph
node. A reactive source replacement increments one acquisition generation; cancellation and owner/
source/seek/device stamps reject every stale byte, decode result and imported surface. There is no
paired `.source(...).bind_source(...)` API and no user-managed `Arc<RenderImage>`, cache, decoder
queue, snapshot, sender or fence.

Acquisition, sniff/demux, parse/decode, size/orientation/color transformation, CPU/vector/native-
plane representation, renderer residency/import, sampling and presentation are distinct typed
stages. Files, embedded data, HTTP responses and application streams converge after acquisition;
already decoded/native producers skip earlier stages. Acquisition, parsed/decode, scale/color
variant and device-residency caches have independent full keys and byte/time budgets. HTTP identity
honors redirects, `Vary`, validators, freshness, authorization partitioning and no-store; secrets
never enter snapshots. Cache sharing is explicit and collision-checked, never an arbitrary closure
or `u64` hash pretending to be content identity.

Still images decode for observed scale when possible, retain enough authority to request a sharper
variant, and may use tiles/mips for large content. SVG can retain a parsed vector description.
Animated images are a bounded timed decoder window with disposal-aware composition and sparse
checkpoints—not an eagerly retained `Vec` of all RGBA frames. Video has bounded demux/decode queues,
seek generations, A/V clock policy, tracks/captions, visibility priority, backpressure and timestamp-
aware frame dropping. Media deadlines patch the retained resource/fragment directly; they do not
write source state or run a general reactive effect on every frame.

Decoded video carries crop/orientation/aspect plus matrix/range/primaries/transfer/HDR metadata.
Compatible backends sample native YUV planes and perform the required conversion/tone mapping;
fallbacks upload planes or RGBA. “Zero-copy” is deliberately not promised: the measurable fast path
is no CPU pixel copy and no extra full-frame GPU copy when decoder, renderer device, format and
composition agree. Native frames are fence-owned so decoder pools cannot recycle them while sampled.
Protected media can prohibit readback, remote inspection, intermediate targets and arbitrary shader
composition rather than silently weakening protection.

The detailed public/provider API, stage/cache keys, renderer imports, test doubles, inspector data,
privacy rules and performance gates are normative in [runtime/media.md](runtime/media.md).

### 5.5 Animation tiers

Animation targets are ordinary properties; they do not become thread-safe state and do not perform
one graph write per frame. The common one-destination form reads like the value it modifies:

```rust
panel()
    .opacity(animate(open.select(1.0, 0.0)).over(ms(180)).ease(Ease::OutCubic))
    .scale(animate(open.select(1.0, 0.96)).spring(Spring::snappy()));
```

When several destinations need the identical presented value, one inferred shared motion key avoids
duplicate sampling:

```rust
let reveal = scope.motion(open.select(1.0, 0.0)).spring(Spring::snappy());
popover().opacity(reveal).blur(reveal.reverse().mul(px(8.0)));
```

The temporary descriptor lowers at mount to a compact `MotionProgram`; application signatures do
not carry a timeline type graph. Programs cover timed easing/cubic Bezier, delay/repeat/auto-reverse,
physical springs, keyframe sequences, gesture/external progress, FLIP, and structural enter/exit.
Custom value interpolation uses a reviewed `Interpolatable` implementation with explicit distance/
velocity semantics where springs require them. An ordinary local animation requires no `Send`,
`Sync`, or `'static` worker bound.

All active programs sample from one injected monotonic frame clock. A timed transition is a function
of target/start sample/start time, so the same timestamp produces the same value at 60 Hz, 120 Hz,
or irregular frames. Interruption first samples the currently presented value at the interruption
time and uses it as the new start. Springs additionally choose `PreserveVelocity` or `ResetVelocity`;
retargeting never jumps back to the last logical target. Gesture-driven motion takes explicit
progress/velocity and defines release handoff into a timed or spring program. Reduced-motion,
background, missed-deadline, and zero-duration policies always reach the same final target.

Programs are stored in dense, kind-segregated lanes and batch-patch typed retained ports. Inactive
programs occupy a compact record but request no frame. A target change activates exactly one track;
the frame sampler writes the presentation draft directly and emits the destination's reviewed
obligation. There is no state revision, dynamic dependency discovery, general effect, allocation,
or task per sampled frame after capacity warm-up on the target fast path; this is a measured gate,
not assumed from the representation. Shader uniform ranges and canvas parameters can
consume the same lanes without a reactive detour.

Classify each destination by the cheapest correct work:

- paint value: repaint one fragment;
- transform/opacity on an isolated layer: composite and damage old/new bounds;
- placement transform within declared travel bounds: update transform/order band;
- layout property: incremental layout, then downstream geometry/paint;
- structural transition: keep entering/exiting owners in a transition host until completion.

FLIP is an explicit structural/layout transition that captures first/last geometry; it is not an
automatic consequence of interpolating a layout property. Intrinsic modes such as fit-content and
expand are not assumed numerically interpolable. The destination chooses FLIP, an explicit measured
proxy-size transition where valid, or a crossfade/reflow fallback, and counters expose that choice.
Exit motion retains only the transition owner/paint/semantic policy it declares, with a deadline and
teardown path; it cannot strand event targets or accessibility focus after logical removal.

### 5.6 Localization and ambient environment

Localized text is a property source, not a widget concern. `Localized::new("cards-count").arg(n)`
implements `IntoProperty<SharedString>`: its dependencies are the owner-scoped locale cell plus its
arguments, so a locale switch is an ordinary sparse update whose text/layout consequences flow
through the normal obligations (direction changes deliberately widen layout, as fonts do). Fluent-
style plural/gender rules resolve inside the sealed formatting circuit; `text!` interpolations and
`Localized` compose. A small built-in `Environment` model (locale, text direction, system/effective
theme, reduced motion, scale class) ships as owner-scoped context from day one so applications and
libraries share one definition of ambient state instead of inventing per-crate globals.

## 6. Styling

The existing chainable surface stays. Static builder calls execute once at mount, which removes
their per-frame cost without claiming that arbitrary chains are const-evaluated. Reactive methods
install one direct field wire:

```rust
div()
    .flex()
    .gap_2()
    .px_4()
    .bg(theme.surface)
    .w(sidebar_width)
    .hover(|s| s.bg(theme.surface_hover))
```

The style schema generates field ids, storage accessors, diff masks, serialization, and merge code.
Pass classification is explicit metadata reviewed with the field (`layout`, `geometry`, `paint`,
`composite`, `semantics`); a derive cannot infer semantic damage from a Rust type or field name.
Use generated multiword bitsets, not a fixed `u128` assumption.

`tw!` may be added early as a stable proc macro that parses a literal and emits the same builder
operations/schema ids. Unknown/invalid classes are errors. Conflicts use the same ordered last-write
semantics as fluent calls; a strict spelling can reject them with spans. Const evaluation is an
implementation optimization for static data, not part of its semantic claim. A general
`#[component]` body-rewriting macro waits until the explicit Rust API and retained semantics are
stable; it is never required for peak runtime performance.

## 7. Compatibility and escape hatches

`LegacyView<T: Render>` mounts in a retained island. A notification rebuilds that island, translates
its temporary element tree into retained children, and reconciles at the island boundary. This is a
migration tool, not the implementation of new reactive leaves. Counters attribute its build,
allocation, and full-subtree work separately.

Canvas and custom shaders are normal retained nodes, not an untyped escape outside layout, input,
accessibility, damage, and tooling:

```rust,ignore
canvas("spectrum", Spectrum {
    samples: audio.samples,
    cursor: selection.cursor,
    accent: theme.accent,
})
.position(absolute().inside(panel).at(panel.x, panel.y))
.size(panel.size)
.pointer_events(PointerEvents::Auto)
.role(Role::Image)
.accessible_name("Audio spectrum")
.shader(SpectrumShader::default())
```

`Spectrum` is an ordinary owned local Rust struct. Optional `#[derive(Canvas)]` generates private
typed property ports; it does not expose a field enum or require `Send`. The retained node owns
identity, settled inputs, local/ink bounds, clip, transform, hit shape, semantics, damage and cache
policy, immutable scene operations, and inspector metadata. Changing `accent` can patch one uniform;
pan/zoom may update one transform; changing a sample range can replace one retained vertex/buffer
range. The node declares when a change instead invalidates its full fragment or surface.

The low-level custom widget contract receives already-settled inputs and narrow phase capabilities:

```rust,ignore
impl Canvas for Spectrum {
    fn prepare(&mut self, input: CanvasInput<'_>, cache: &mut CanvasCache) -> CanvasChange;
    fn paint(&self, paint: &mut PaintCx<'_>, cache: &CanvasCache);
}
```

It can emit safe paths, quads, images, text, meshes, and retained resource ranges or declare an
isolated render pass. It cannot read live state, mutate application data, mount structure, select a
worker, or retain renderer borrows across submission. A deliberately advanced native-command escape
hatch declares bounds, clip, target reads/writes, blend/depth/stencil, ordering and readback; missing
precision conservatively isolates the pass and damages its entire node/surface.

`#[gpu_shader(path = "...")]` validates WGSL and generates a typed parameter/bind layout. Uniform,
storage, texture, sampler, push-constant, vertex, target, sample-count and capability mismatches are
build errors for static shaders. Development hot reload parses/validates before replacement; an
invalid version leaves the prior pipeline active and exposes diagnostics. Runtime text is validated
and resource-limited but is not advertised as a security sandbox.

Custom GPU work lowers into the retained render graph. Each pass declares resource read/write sets,
target, clip/mask/backdrop dependencies, blend/depth/stencil and order. Hazards/topology are validated;
pipelines cache by shader/interface/device/target key; uploads and compilation are budgeted. Shader
parsing/asset preparation may run on workers using owned data, while device resource creation stays
on the renderer owner. `FramePacket`/fence ownership prevents a later UI edit from mutating submitted
uniforms, buffers, textures or pipelines. Device loss reconstructs from retained CPU descriptors.
The inspector exposes shader diagnostics, pass/resource graph, lifetimes, cache hits, uploads,
timings, damage and a scene capture.

Backends and platforms may initially run in lower retention tiers. Correctness cannot depend on
partial presentation, GPU persistence, threads, or native IME availability. WASM uses the same
single-writer graph and sender queue with platform-appropriate wake plumbing.

### Multi-window and surface rules

The app graph is owned by exactly one UI executor/thread and may feed multiple windows scheduled on
that executor; retained nodes, focus/IME, damage, and presentation are per window. A future platform
that drives windows on different UI threads shares an external thread-safe model and `Sender`s, not
the same local `State<T>` graph. A node cannot be moved directly between windows because layout
scale, renderer surface, platform handlers, and arena brand differ; moving content means unmount/
remount while application state survives above both owners. Pop-out/docking APIs make that lifecycle
explicit and provide a state handoff hook.

Windows may share device-level pipelines, glyph/image atlases, and immutable resource caches with
budgeted synchronization. Swapchain targets, damage, frame pacing, and surface recovery remain
per-window. An occluded window detaches paint demand and reduces animation sampling, but continues
to process state required for correctness; on reveal it validates revisions and conservatively
damages stale regions. Closing a window revokes its owner before late renderer/task callbacks run.

## 8. Representative product fit

The same primitives cover common native UI without creating per-widget reactive mini-runtimes:

| Product/use case | Primary model | Important fast/correct path |
|---|---|---|
| Forms and settings | generated field keys, destination-owned editable controls, derived validation | field-only semantics/paint; async validation rejects stale generations |
| Menus, popovers, modals, tooltips | portals across logical/layout/paint trees | retained anchor geometry, focus scope, dismissal, overlay damage |
| Tables, lists, grids, trees | `list`, `KeyedList`, arrangements, `.virtualize` | resident-key update, identity-preserving move, measured extents and automatic active-row retention |
| Editors and terminals | rope revisions, `TextFieldState`, custom paint fragments | range shaping, IME/cursor integrity, viewport damage, blink/composite deadlines |
| Images, video, cameras | generic `image`/`video` inputs plus typed provider boundary | shared staged caches, bounded decode, native-plane import, fence-owned lifetime, exact fallback reason |
| Canvas, charts, maps, timelines | retained typed canvas/render-pass node plus app data index | declared bounds/revision/ranges/hazards, tile/layer cache, shader uniform patches, transform-only pan/zoom |
| Navigation and async data | `switch`, owner scopes, `Work<T, E>` / `scope.resource` | latest-wins request tickets, branch reset/keep-alive, cancellable prefetch |
| Drag/drop and docking | retained runtime protocol + portal preview | pointer capture, validated key/order revision, cross-window remount/handoff |
| Animation-heavy UI | property animation tiers + transition hosts | composite/placement fast paths; explicit layout/structural fallbacks |
| Multi-window tools | app-owned state, window-owned nodes/surfaces | observer-targeted wakes, shared device resources, isolated damage/focus |
| Accessible UI | retained semantic tree and delta publisher | stable semantic ids, virtualized pinning, independent semantic order |
| Themes/localization | ordinary state/context and style/text observers | only consuming fields update; direction/font changes widen layout deliberately |

Custom widgets implement the same retained-node contract: declare properties, measure, semantic
projection, hit behavior, paint fragment, and invalidation classification. They do not have to use a
macro or expose internal storage. An escape hatch that cannot state narrow damage remains correct by
declaring full-node/full-surface damage and is visible in counters.

## 9. What is deliberately not in the core

- Universal MVCC/version chains for every state value. Single UI-thread writes plus phase barriers
  provide coherent frames without the memory and reclamation tax.
- Transparent cross-thread signal mutation. Threads send commands or explicit snapshots.
- Public branded lifetimes on every UI type. They do not compose with dynamically stored windows
  and callbacks without a viral API.
- Type-level durability. Reverse edges and runtime lanes solve the real scheduling problem.
- Session types for protocols spanning independently dispatched callbacks. Focus/drag/IME are
  retained runtime state machines with typed one-callback transition helpers where useful.
- Unkeyed dynamic collection identity.
- A compiler macro as the only way to obtain correctness or performance.

## 9.5 Second-order frontiers the substrate unlocks

These are staged extensions, not core commitments: each reuses machinery the plan already requires,
each is gated like everything else, and none may complicate the four-concept authoring surface.
They are recorded because the substrate makes them unusually cheap here and structurally impossible
elsewhere.

- **Incremental queries: the UI as a maintained view.** `KeyedList` arrangements already maintain
  filter/sort incrementally from delta streams. The generalization is a small relational layer—
  `scope.query()` with joins, group-by, and aggregates over keyed collections, maintained in
  O(changed keys) DBSP-style rather than recomputed. A master-detail view over a join of two
  collections, a symbol table grouped by file, a dashboard aggregate—declared once, updated by
  delta, with the same wildcard-fallback honesty as arrangements. No UI framework has incremental
  joins; this plan already has the delta streams and revision discipline they need.
- **The delta log is a persistence, sync, and collaboration seam.** Because every change is a
  typed, invertible, revisioned delta, `scope.model(...).persist(key)` is snapshot-plus-log replay;
  process-to-process sync ships deltas; and collaborative editing is delta transformation—the text
  pipeline already rebases concurrent edits. Offline-first native apps fall out of machinery that
  undo and optimistic updates already paid for.
- **A production flight recorder.** The deterministic-test substrate (event trace + delta log +
  injected clock) runs cheaply enough to keep a bounded ring buffer in release builds: a bug report
  becomes a replayable trace, and every crash is a failing test. Redaction rules follow the
  inspector's existing privacy contract.
- **Sandboxed extension UI.** Capabilities are unforgeable arguments and deltas/regions are
  serializable values, so a plugin can host UI from a WASM component that receives snapshots and
  emits deltas and commands—never holding a key, capability, or node reference. The same contract
  that makes phases safe in-process is a security boundary out-of-process; the remote-inspector
  protocol already proves the serialization seam.
- **Shared-element transitions.** Keyed identity plus published geometry make SwiftUI-class
  matched-geometry moves a policy, not an engine: `.shared_element(id)` on nodes in two structural
  branches lets a held transition morph the surviving element between its old and new geometry
  through the existing FLIP/placement lanes.
- **Temporal properties.** With one injected clock, a value like `posted_at.relative()` is a sealed
  circuit that schedules its own next re-evaluation at exactly the boundary where its output next
  changes (“4 minutes ago” → one wake in 60 s), replacing app-wide polling timers with
  deadline-exact wakes that the idle gate can verify.
- **GPU-resident motion.** Dense motion lanes already batch typed port patches; on Tier-4 backends
  a warm spring/timeline can sample straight into retained uniform/instance ranges so a running
  animation costs zero CPU scene work per frame—the classifier and fences already exist.
- **Compile-time theme contracts.** Generated palette schemas can carry const-evaluable policy:
  token pairs declared as text/background must pass contrast thresholds at `cargo check`, making a
  class of accessibility regressions unrepresentable per theme rather than audited after the fact.
- **A coverage-guided UI fuzzer.** Deterministic input routing plus cheap invariants (no panic,
  focus is live, a11y tree consistent, oracles agree) make a monkey-tester a harness feature: replay
  any failure exactly. The same properties that made tests deterministic make fuzzing findings
  actionable.

## 10. Extension surface and long-lived seams

### 10.1 Third-party contracts: no private superpowers

The sealing decisions above protect hot-path invariants, not framework privilege. The rule is that
**every contract a first-party widget, control, or animation uses is public**, so an ecosystem of
libraries can touch the whole GUI stack—widget kits, animation/gesture crates, form and query
libraries, design systems, charting—without forking the framework. The committed public contracts:

- **`IntoProperty<T>`** (open entry, sealed internals): a third-party type converts *into* a
  framework property descriptor without implementing the sealed trait. A localization handle, a
  design-token type, or a units wrapper becomes directly bindable (`div().bg(BrandToken::Surface)`)
  while lowering into the same constant/sink/circuit records. This restores the source
  extensibility of an open `Res<T>`/TC39-`Signal` world without giving up fusion soundness.
- **Public, non-sealed `Readable<T>`** so library signatures can accept "any reactive value" from
  any conforming source; `Property` and `Readable` stay method-disjoint by policy until supertrait
  item shadowing stabilizes.
- **`#[derive(RetainedProps)]` + public `ObligationClass` vocabulary.** Custom retained kinds
  declare typed ports with self-declared obligation metadata; anything un-annotated defaults to
  conservative full-node damage. Correct by default, fast by declaration—the same rule §8 applies to
  first-party escape hatches. Widget fields may additionally register **namespaced style-schema
  fragments** (crate id + field id) so third-party knobs participate in variants, tokens, cascade
  layers, and the transition policy in §6 instead of feeling bolted on.
- **Open `Interpolatable` (with an associated `Velocity` type; `preserve_velocity` bounds on it) and
  a `MotionSampler` trait** installed into a user motion lane: an animation/physics/IK library
  supplies math sampled by the framework clock, with interruption, reduced-motion, and obligation
  policy staying framework-owned. Without this, a third-party animation library structurally cannot
  exist, because per-frame source writes and per-frame effects are exactly the anti-patterns the
  lanes eliminate.
- **`scope.external_work::<T, E>() -> (WorkDriver<T, E>, Work<T, E>)`** so query/cache/dedup
  libraries mint coherent `Work` handles. The driver enforces the atomic tri-state, request tickets,
  and owner epochs internally; a data library gets the coherence guarantees without writable status
  cells and without recreating the tri-state out of three raw `State`s.
- **Opt-in `#[reactive(public_schema)]`** field reflection (name, type id, erased get/set through
  `Update` with type checks) for form/validation/settings-UI libraries, shaped to converge with the
  compiler reflection/`facet` direction rather than compete with it.
- **A public structural-region contract.** `show`, `switch`, and `list` are implemented on a public
  keyed `Region` API (mount/unmount/move/splice under an owner, with reset/keep-alive/transition
  policy), so routers, docking systems, masonry grids, and tree views are library-buildable with the
  same identity guarantees.
- **A public two-way control contract**: the edit-origin/revision echo-suppression helper from §1.5
  and a composable `TextBinding`, so third-party controls get model-echo behavior right by
  construction instead of re-deriving it.
- **`HitShape`** for custom hit geometry (with the conservative-fallback rule) and the CPU-side
  retained GPU **range declaration API promoted from the optional Tier 4 to a core contract**—a
  charting library must be able to declare persistent instance-buffer ranges even where a backend
  falls back to re-upload.
- **`scope.on_cleanup(f)`**: user-registerable owner teardown. Every resource-wrapping library in
  every surveyed ecosystem is built on this one method.
- **Public introspection** (`sources(key)`/`sinks(key)`, stable and separate from the full
  inspector protocol) so third-party devtools and lints can walk the causal graph—the one design in
  the stalled TC39 signals proposal worth adopting wholesale. The owner/disposal model is this
  plan's answer to the lifetime problem TC39 explicitly punts on, and is stated as such.
- **Crate layering**: the reactive core (keys, capabilities, memo/work/graph contracts) and the
  extension traits above live in renderer-independent `-core` crates (the axum-core precedent), so
  a headless library or test double depends on the small crate. Cross-toolkit interop position:
  that core crate *is* the interop seam; foreign reactive graphs (Leptos, Floem, Dioxus) bridge at
  senders/work edges, never by aliasing another runtime's cells. A stable C ABI is an explicit
  non-goal—the binary-boundary story is the sandboxed delta/region plugin seam of §9.5, which
  serializes values instead of freezing vtables.
- **Public palette-token registration**, so a third-party design system's tokens get the indexed
  reverse-use fanout of §6 rather than a slow path. `tw!` itself stays scoped to the core class
  grammar—a proc macro cannot see foreign registrations—and a design system ships its own macro
  generated from a shared grammar crate.

### 10.2 Replaceable internal seams

The system is split into replaceable contracts:

- graph storage/scheduler behind GPUI state vocabulary;
- retained node arena and reconciliation independent of renderer;
- style schema and invalidation classification independent of authoring syntax;
- layout adapter with persistent-node operations;
- scene fragments/damage and bulk `FramePacket` frontend contract independent of
  WGPU/Metal/DirectX/Vulkan implementation;
- typed media acquisition/decode/variant pipeline independent of renderer residency/import;
- platform frame waker, clock, clipboard, IME, and accessibility adapters;
- deterministic headless clock/renderer for conformance and performance tests.

Stage-boundary values are inspectable and replayable. A graph transaction log can reproduce why a
frame changed without serializing user closures. Arena generations, owner epochs, and resource
versions are wide enough that wraparound cannot resurrect a stale handle during a process lifetime.

The plan is complete only when the gates in [performance.md](performance.md) pass, the migration
sequence in [migration.md](migration.md) has an exit criterion at every stage, and the retained path
supports the representative products—not when the type names compile.
