# Migration and Delivery Plan

Two parts. **Part I** is the concept map for people with existing GPUI apps: every current
concept, its replacement on the [07](07-the-ladder.md) surface, and the order to migrate a
screen. **Part II** is the dependency-ordered delivery plan for building the runtime itself.
Where `cx` was *more expressive* than the map (not just more verbose), and which Zed-shaped
objects are the hard ports, is [10-from-cx.md](10-from-cx.md).

## Part I — Migrating a GPUI app: the concept map

The seam that makes this incremental is 07 §6's **age boundary**: a legacy `Render` view can
host a new `View` (`LegacyView` island the other way too), so one screen migrates at a time
while the rest of the app runs unchanged. Nothing below requires a flag day.

### State and updates

| Today | Becomes | Notes |
|---|---|---|
| `Entity<V>` + `impl Render` | a struct + `impl View` (`fn view(&self) -> Element<'_>`) | fields stay fields; the struct is now also the price list (07 §0). The return type is the concrete borrowed `Element<'_>` (07 §2), not `impl Element` — erasure happens once at element completion, not recursively in every caller's type |
| `cx.new(\|cx\| MyView { … })` | `MyView { … }` / `MyView::default()` | construction is plain Rust; `Entity<T>` is a *promotion* you store as a field when a subtree earns an independent surface |
| `cx.notify()` | **deleted** | the dirty law (07 §1): a handler running *is* the notification; the owner re-describes, the tape diffs |
| `Context<'_, V>` / `App` / `Window` params | gone from signatures | handlers are `fn(&mut Self, payload)`; effects are `self.spawn` / `self.emit` / `self.announce` calls (07 §3) |
| `cx.observe(&entity, …)` | for a *value*: a port/wire on the entity's field (`text_input(&self.doc.text)`) or a `.share()`d cell; for an *effect*: `entity.on_change(Self::f)` (any-change) or field-grain `derived.on_change(Self::f)` (07 §6.4) | observation by closure is replaced by wiring by type; the effect verb returns no handle |
| `cx.subscribe(&entity, …)` (typed events) | `impl Emitter for E` on the observed type + `entity.on(Self::f)`; the emitter raises `self.emit(Event)` | payload type is the subscription; no `Subscription` to store (07 §6.4) |
| `cx.emit(Event)` + `EventEmitter<Event>` + `cx.subscribe` | `self.emit(Event)` caught by `.child(&self.thing).on(Host::method)` | the payload type is the subscription; no subscription handles to store |
| `cx.spawn` / `background_executor` | `self.spawn(fut)` (owner-lifetime, fire-and-forget) or a self-filling field `self.x = Task::run(fut)` (`Task<T>: Deref<Option<T>>`; drop cancels) | a completion handler exists only for side effects: `.then(Self::done)` |
| hot scalar you notify about constantly | `Signal<T>` field | reads/writes become starred (`*self.count += 1`); view passes `&self.count` to wire a port |
| element-local state (`with_element_state`) | a field on the `View`, or a field on the row type in a `List` | there is no element-local state; state lives in structs |
| globals (`cx.global` / `observe_global`) | fields, shared `Entity`, `.share()`d cells; theme/media providers are the only ambients; react with `settings.on_change(Self::changed)` or a field-grain `settings.field.map(..).on_change(..)` | if several windows need it, it is a shared `Entity<Model>` (07 §17.6); no `TypeId` registry, no init-order panic |

### Views and elements

| Today | Becomes | Notes |
|---|---|---|
| `div().child(a).child(b)` | same — or `column((a, b))` / `row(iter)`: constructors take children | both go through sealed `IntoChildren` (07 §2) |
| `"text".into_any_element()` / `.child("hi")` | `text("hi")` — a string is the content of a text leaf, never a child | located error otherwise (07 §2) |
| `px(300.)`, `rgba(0x1e293b66)` | `.w(300)` (ints are px), `rgb(0x1e293b).alpha(0.4)` | packed-alpha `rgba` is deleted; viewport units `vw/vh/vmin/vmax` added |
| `uniform_list` / `list(ListState)` | `.children(&self.items)` / `virtual_list(&self.items)` over `List<T>` | `ListState` and manual indices die; identity is `Slot<T>`; splices are the update |
| conditional children (`when`, `Option`) | real `if`/`match` at the floor; `*self.open` once promoted; `.then`/`.when`/`.switch` as live regions; `.open()` for hide | hide-vs-unmount is semantic, not stylistic (07 §2) |
| `canvas(prepaint, paint)` closures | one `Element<'f>` with typed `.measure`/`.paint` phase capabilities and an optional retained temporal graph | borrowed scene data, shader/history/hit/role stay on the same element (07 §15.2/§15.2.1) |
| `deferred` + `anchored` | the overlay family: `popup` / `dialog` / `sheet` / `hover_card` + `Placement` | dismiss/placement are values, not method chains (07 §2) |
| `AnyView` | `AnyEntity` | erasure is a protocol boundary, made for plugins (07 §5) |
| `with_animation(id, …)` | motion *values*: `animate(&target).spring(..)`, `repeat(1.turn().over(2.s()))`, structural `hero(slot)` | programs are property values sampled on explicit timelines (07 §4.2) |
| `img(source)` / `ImageSource` | `image(src).fit(..).tint(..)/.colorize(..).slice(..)` | staged acquisition behind the constructor; 9-slice/tile/atlas added (07 §17.8) |

### Input, focus, keys

| Today | Becomes | Notes |
|---|---|---|
| `actions!` + `KeyBinding` + `"cmd-s"` strings + key contexts | `.shortcut(Key::S.primary())` on the control that already has the handler; `.on_key(chord, f)` on the narrowest owning scope | no action registry, no context strings; `gpui::export` only if you ship user-remappable JSON bindings (07 §9) |
| `FocusHandle`, `track_focus`, `tab_index` | `button(..).focuses(&self.search)`, `.focus_default()` on the inner control, `dialog().focus_scope().initial_focus(..)` | focus targets are values (`&Target<K>`, `&element`, `&View`), never stored handles (07 §5) |
| `ElementId` for state continuity | nothing — continuity is the embedding site or the `List` slot | there is no id enum at all: wiring identity is a `Copy` `Target<K>` field; tests hold the state (`ui.click(ui.find)`); external names are semantic role+name locators (07 §2, §16.5) |
| `on_action` dispatch | typed payload handlers routed by receiver (`fn(&mut Self, KeyEvent)`) | the routing law, 07 §3 |
| custom `InputHandler` text fields | `text_input(&self.title)` (String/Signal) or `text_input(&self.doc)` (`Editor`) | IME/UTF-16 plumbing is the widget's, not yours (07 §5, §19) |

### App shell and the rest

| Today | Becomes | Notes |
|---|---|---|
| `Application::new().run(…)` + `cx.open_window(WindowOptions, …)` | `gpui::run(root_view).title(..).size(..)`; more windows: `self.open(WindowKind::Utility, Inspector)` | kind is the constructor argument; chrome is the builder (07 §8) |
| bespoke undo stacks | `impl History for Board { type Scope = MainHistory; }` + `gpui_history` | two lines; list/signal ops were already deltas (07 §15) |
| `cx.prompt` / platform dialogs | window kinds + overlay family | |
| `TestAppContext` | `Ui<Root>` — tests hold the state (`DerefMut`), act via Copy targets (`ui.click(ui.find)`), inject real input on the virtual clock | the inspector and tests share one snapshot; semantic role+name locators for external drivers (07 §16.5) |

### The order that works (per screen)

1. Swap the struct: delete `Render` for `View`, delete every `cx` parameter, let handlers take
   payloads. Everything still re-describes per turn — that is the legal floor.
2. Delete `cx.notify` / observers / subscriptions; wire events with `.on`, shared state with
   `.share()`.
3. Move keys and focus onto controls (`.shortcut`, `focuses`); delete the action registry
   entries for that screen.
4. Only then look at the profiler, and promote fields: `Vec`→`List` where rows need identity,
   `T`→`Signal` where a scalar is hot (rustc lists the read sites; add stars), field→`Entity`
   where a subtree should stop re-describing with you.
5. If the screen wants Cmd-Z, add the two `gpui_history` lines last — the deltas were already
   being captured.

Steps 1–3 are semantic and mechanical; step 4 is optional and profiler-driven; nothing in
steps 1–3 has to be revisited when step 4 happens. That is the ladder working as a migration
strategy, not just an optimization strategy.

## Part II — Delivery plan for the runtime

The PR-granular sequencing of everything below — which pull request lands which mechanism,
against which crate, gated by which CI job — is [pr-plan.md](pr-plan.md).

The repository can tolerate major refactoring, so this is a dependency-ordered delivery plan, not a
promise to preserve every internal API. It still keeps a working comparison path long enough to
measure correctness and performance instead of rewriting blind. (Vocabulary note: `State<T>`,
`Scope`, `Update`, `Read` below are **kernel-internal** names for the machinery under 07's
surface — they never appear in application code; 07 §14 lists what the public surface deleted.)

Each phase has an exit gate. Do not begin the next performance-dependent phase because the types
look plausible; begin it because the preceding substrate is measured and correct.

## Phase 0 — Freeze the contracts

Deliver:

- conformance fixtures for current layout, painting, input, focus, text, accessibility, and cached
  subtree behavior;
- deterministic headless clock/event traces and screenshot baselines;
- a first `UiSnapshot` schema and `UiTest` host over the current tree, reusing the existing
  accessibility debug capture as an adapter rather than creating a second semantic model;
- a counter registry and frame trace format, with no-op release implementation;
- benchmark runners for idle, counter locality, hover, scroll, keyed table, editor, kitchen sink,
  and churn;
- pinned competitor ports/commit or release metadata described in [performance.md](performance.md),
  including zgui's local-storage path and Slint's compiler-specialized property path;
- microbench runners for every property-lowering stratum, fanout, palette/animation specialization,
  sparse/dense crossover, spatial false positives, and renderer backpressure.

Exit gate: tests can prove a counter is non-vacuous, raw benchmark results are reproducible, and
the current GPUI baseline is stored. This is where “surpass” becomes measurable.

## Phase 1 — Retained identity and ownership

Deliver:

- per-window generational `NodeArena` and owner tree;
- hot node-header slabs, kind-segregated property slabs, cold side records, and adaptive
  small/dense/large child and dirty-set representations;
- internal branded arena views that turn validated public ids into non-escaping read/write
  capabilities, with compile-fail coverage for cross-view escape and alias misuse;
- explicit mount/unmount transactions and deferred reclamation epoch;
- stable handler, focus, IME, accessibility, and semantic ids;
- retained property slots with typed field ids;
- generated model bundles backed by contiguous direct field cells and typed property descriptors;
- `LegacyView` island capable of hosting existing `Render` output;
- devtools node/owner inspector and live-object gauges;
- source/test ids and snapshot hooks needed by the versioned inspector/test protocol, compiled to
  no-op metadata when the feature is disabled.

Initially the retained tree may still invoke the old layout/paint pipeline. The goal is identity and
lifetime correctness, not an early speed claim.

Exit gate: reorder/mount/unmount tests preserve the right local state, cleanup runs exactly once,
late callbacks fail harmlessly, duplicate semantic ids diagnose precisely, and churn gauges return
to baseline.

## Phase 2 — Persistent layout, dispatch, and accessibility

Deliver:

- persistent Taffy node lifecycle and style/children patch operations;
- write-free `LayoutCx` measurement and `GeometryCx` plus declared, bounded `LayoutFeedback`/
  `GeometryWrite` observation capability;
- reasoned layout dirt and dirty-child summaries;
- retained event routing and focus order;
- incrementally updated hit-test spatial index;
- accessibility delta publication;
- sparse geometry anchors and `PlacementGraph` for normal-flow-independent relative placement,
  coordinate transforms, collision/safe-area policy, and located cycle/fallback diagnostics;
- bounded geometry-observation loop.

Keep a debug mode that recomputes layout/hit/a11y from scratch and compares results. Randomized tree
mutation/property tests should run both implementations.

Exit gate: leaf layout work scales with the true dependency closure; scroll translation does not
rebuild hit state; no incremental/full oracle mismatch remains in the mutation corpus; root-layout
fallbacks are explained by counters; custom measure cannot compile against write/structure APIs;
feedback cannot demand-compute/create structure/effects/resources/senders or exceed its declared
cap; runtime reentrancy fixtures cannot mutate a measured subtree. Anchored popovers must track
scroll/transform/scale and publish matching paint/hit/a11y geometry;
removed anchors and mutual cycles take their declared fallback without exposing a partial epoch.

## Phase 3 — Retained fragments and damage-aware presentation

Deliver:

- immutable per-node scene fragments and resource references;
- sum-tree order structure with localized splice/move;
- adaptive spatial damage index queried before retained-order replay, with false-positive counters;
- transform-only and fragment-replay paths;
- conservative ink bounds and damage propagation through filters/groups;
- renderer capability tiers and retained composed targets;
- bulk renderer frontend boundary with per-operation capabilities, immutable resource operations,
  typed native-import leases, no platform resources/`Any` in core scene records, and backend
  selection once per packet/pass/range;
- bounded in-flight `FramePacket`/fragment versions, backpressure and contiguous dense fallback;
- damage retirement handshake and device/surface loss recovery;
- experimental stable GPU primitive/glyph slots and dirty-range uploads behind a capability tier;
- retained canvas nodes and a render-graph pass contract with typed inputs, declared bounds/damage,
  clip/blend/resource hazards, pipeline caching, fence-owned versions, device-loss recreation, and
  validated WGSL parameter layouts;
- `UiSnapshot` scene/damage/pass/resource capture and reference-renderer integration.

Run incremental painting beside a full-render oracle in test/profile builds. Periodically force full
damage in production builds during development to reveal stale-pixel defects.

Exit gate: visual equivalence under randomized changes; idle submits nothing; paint-only leaf and
translation scroll meet their zero-work phase gates; cache budgets remain bounded; renderer reset
cannot lose pending damage; spatial false-positive ratios remain within stored workload bands;
stalled fences cannot exceed packet/version/pinned-byte budgets; dense fallback and device recovery
match the full oracle. The reference, Metal, DirectX and wgpu frontends consume the same recorded
packet protocol where supported; profiles show no per-primitive backend virtual dispatch. Device
loss rejects old native imports and reconstructs residency without stale handles.

## Phase 4 — Typed incremental lowering

Deliver:

- unconditional-`Copy`, two-word, `!Send + !Sync` `State<T>` keys; `Scope`; rollback-safe `Update`;
  inferred dynamic `Read`; sealed generic `Property<T>` installation; and `Sender`;
- no ambient key dereference: `Scope::initial`, `Update::read/with/before/published`, and dynamic
  `Read::get/with` resolve and validate keys; editable control destinations consume one state/
  document key rather than a paired binding object;
- stable `use<…>` precise captures on opaque property combinators and compile/code-size gates for the
  temporary generic blueprint;
- constants and direct field property sinks first, with compact slab records, intrusive
  owner/source removal links, typed patch thunks, and no general effect/graph node;
- sealed framework circuits second, deforested from the mount blueprint, with debug reference
  evaluation and no fusion of arbitrary user closures;
- fixed-edge user maps and tracked arbitrary derivation third, with reverse-edge maintenance, height repair, equality
  policies, priority lanes, work budgets, cycle diagnostics, and graph devtools;
- destination-owned editable controls and effectless direct property wires for text, styles,
  visibility, semantics, and handlers;
- isolated `Copy`/`Clone`/persistent/generated-delta edit drafts, direct field revisions, aggregate
  wildcard scatter, and typed text/list/document deltas; no arbitrary mutation of published storage;
- sparse `LogicalDraft` and `PresentationDraft`, atomic epoch publication, owner pinning, dense
  double-buffer promotion, and coordinate-input behavior while presentation recovery is pending;
- canonical host protocol: computations -> structural/property/sink logical draft -> atomic logical
  publish -> after-publication effects/new update waves -> presentation draft -> style/layout ->
  sealed geometry feedback/relayout -> hit/a11y/prepaint/paint/composite -> atomic presentation publish;
- entity/signal adapters at explicit boundaries.

`Sender` includes bounded reliable/latest/coalescing policies and close-race counters; selected
background snapshots own `Send + 'static` values and contain no graph/node/platform borrow.

Use the retained property store directly; do not implement property wires by rebuilding temporary
elements in `with_element_state`. Keep graph storage behind GPUI-owned types.

Land and benchmark the constant/direct-field lane before adding arbitrary derivations. If the
direct lane cannot beat a per-property general effect on bytes, allocation, and update work, stop
and redesign its representation; do not hide that failure under the flexibility of Phase 4's
dynamic fallback.

Exit gate: writes run no reactive computation recursively; event read-your-draft and between-event
publication pass; graph fuzzing finds no glitches; the clone-free/enum-free examples compile with
only meaningful capabilities; key size/`Copy`/`!Send` assertions, stale/runtime mismatch,
same-slot reentrant draft borrow, cross-thread key, draft unwind, and cross-field nesting tests pass;
captured keys cannot resolve in build/compute/layout/geometry/paint without the proper capability;
fault injection at every logical and presentation stage proves the two atomic publication barriers;
paint-only state updates perform zero structural, style-tree, and layout work; local benchmarks show
the expected refcount/lock/atomic-free path; direct-field wires meet their allocation/byte gates
before the arbitrary dynamic graph is accepted as the default fallback.

## Phase 5 — Structural primitives and scalable collections

Deliver:

- `show`, `switch`, reset policy, `keep_alive` cache policy;
- O(n) convenience `list(rows.keyed_by(key), row)` with explicit resident-row update semantics;
- diff-native `KeyedList`, per-key rows, incremental filter/sort arrangements;
- generated field-aware filter/sort forms plus conservative wildcard dependency for arbitrary
  predicates;
- `.virtualize(fixed/variable/estimated_extent)` on keyed `list`, with anchoring and automatic
  focus/IME/pointer/drag/accessibility retention reasons;
- focus, IME, pointer capture, drag, and accessibility integration;
- retained typed drag world with keyed-row `.drag`/`.drop_zone`, key-relative landing positions,
  preview portals, keyboard/a11y operation, cross-window handoff, and optional work-edge validation;
- lightweight virtual semantic providers/materialization and accessibility-driven pinning;
- list/order devtools and duplicate-key diagnostics.

Exit gate: the 100k-row mutation matrix meets complexity gates, moves preserve identity, resident
updates do not remount, variable heights do not jump scroll position, and pinned rows cannot be
recycled prematurely; drag/drop never exposes an index and survives capture loss, stale order,
async validation, teardown, and legal cross-window handoff. The fixed `N_vec` crossover is stored per target, vector-tier O(N) behavior
is never reported as O(log N), and arbitrary filter/sort closures visibly take the wildcard/reset
path while sealed field-aware arrangements pass their one-row update gate.

## Phase 6 — Text, resources, and animation

Deliver:

- `TextFieldState` and revision-aware model binding;
- parity with every current GPUI `InputHandler` query/edit/routing method, including UTF-16 range
  maps and committed geometry queries;
- rope/range invalidation and per-line shape accounting;
- typed `scope.compute/resource/action` work edges over sealed freeze inputs, inferred concrete
  `Work<T, E>` handles with one coherent load-state record and opaque read-only value/pending/error
  projections, pending-view tuple freeze, owner/work/request/policy stamps, queue/result cancellation,
  explicit token-cancellable CPU work, and distinct local
  versus `Send + 'static` execution;
- generic `image(source)` and `video(source)` inputs for embedded assets, paths, explicit URLs/HTTP
  requests, byte buffers, work results and application/native providers; no public mega-enum,
  paired binding method, widget-owned cache/task polling, or user-owned `Arc<RenderImage>`;
- staged acquisition, sniff/demux, decode/parse, scale/orientation/color, variant and renderer-
  residency caches with full identity, HTTP validator/`Vary`/authorization/no-store semantics,
  byte/time budgets, visibility priority, cancellation and owner/source/seek/device stamps;
- scale-aware still/vector/tiled decode and disposal-aware bounded animated-image windows rather
  than eager all-frame retention;
- bounded video demux/decode queues, one injected A/V/media clock, seek generations, captions and
  timestamp-aware frame selection; native Metal/DirectX/wgpu external-plane imports where
  negotiated, with counted plane/RGBA fallbacks, fence-owned sample lifetime and protected-media
  restrictions;
- deterministic media provider/decoder/clock fixtures and inspector views for cache lineage,
  encoded/decoded/resident bytes, frames, copies, color plans, leases and redacted requests;
- compatibility adapters from current `Resource`/`ImageSource`/`RenderImage` and `SurfaceSource`;
  migrate built-in image users first, then animated images and platform video surfaces, and remove
  element-local `ImageCacheItem` polling plus platform/type-erased scene variants after parity;
- animation tier classifier, transform/order bands, explicit FLIP/structural transition host;
- compact timed/spring/keyframe/gesture/FLIP motion programs with interruption-from-presented-value,
  explicit spring velocity policy, and honest intrinsic-layout fallback;
- dense kind-segregated motion lanes sampled from one injected clock rather than one graph
  write/effect per animated property, including direct canvas/shader uniform-range destinations;
- reduced-motion and hidden-window policies.

Exit gate: platform IME fixtures, cursor/model echo, undo grouping, late work completion, and
animation phase-matrix tests pass; editor and animation reference workloads meet their work gates;
the two-line compute/resource examples have no user-visible transport object and pass stale/
teardown/cancellation races; 10k-track sampling uses the vector lane, reaches only declared phases,
and matches the scalar reference interpolator at identical timestamps. Interruptions at 60/120 Hz
and irregular cadence agree; reduced motion reaches the same final state; shader/canvas motion
patches only declared uniform/scene ranges. Embedded/path/HTTP/bytes/provider image fixtures
converge after acquisition; animated/video memory is bounded under stalled consumers; stale source/
seek/device completions cannot publish; native video fast paths prove zero CPU pixel copies and zero
extra full-frame GPU copies while every fallback reports and counts its cause. Crop/orientation/
color/HDR output matches the reference policy, and device loss never forces a needless refetch of
still-valid encoded content.

## Phase 7 — Style schema and authoring polish

Deliver:

- generated multiword field masks and explicit damage metadata;
- slotted cascade with static, variant, inline reactive, and animation layers;
- palette-token indirection with reverse users, opacity/blend-class promotion, and conservative
  fallback when a token's semantic class changes;
- unified literal/reactive builder inputs;
- stable `tw!` literal proc macro emitting the same schema operations;
- compile-fail tests and actionable diagnostics.

Static chains execute once because elements are retained. Const evaluation may optimize generated
payloads but is not an API requirement.

Exit gate: the style mutation matrix proves exact phase entry, every field has reviewed metadata,
unknown/invalid `tw!` classes fail at the right span, conflict ordering matches fluent calls (and
strict mode reports both spans), and chain/macro outputs are identical; the 10k-user palette gate
and opacity/blend-class promotion oracle pass without per-consumer computed closures.

## Phase 8 — Product migration and default flip

Migrate representative screens in increasing difficulty:

1. counter/settings form;
2. menus/overlays/focus traversal;
3. large keyed table and virtual list;
4. editor surface with IME;
5. multi-pane workspace with drag/drop, tasks, and custom paint.
6. arbitrary anchored overlays plus shader-backed canvas, inspector-driven debugging, and a
   deterministic end-to-end integration suite.

For each screen, record legacy-island percentage, frame work, latency, allocations, memory, and
behavioral gaps. APIs may break while the retained model is still greenfield; once two difficult
products converge, freeze the public vocabulary and publish a compatibility window.

Exit gate: no new first-party UI uses `LegacyView`; compatibility islands are bounded and
instrumented; competitive gates reproduce on two hardware classes; default examples/docs use the
retained API.

## Phase 9 — Optional compiler assistance

Only after the explicit Rust API is stable, evaluate:

- `#[component]` for diagnostics and boilerplate reduction;
- static dependency hints verified against runtime tracking in debug builds;
- slot synthesis for local state where explicit state construction is demonstrably painful;
- static blueprints for mount-time dense node/property allocation, lowering to the same public
  primitives and providing no exclusive steady-state leaf-update fast path.

The macro must expand to readable public primitives, preserve source spans, and bail out to runtime
tracking rather than guess across opaque calls. It is rejected if it becomes necessary for peak
performance or creates a second semantic model.

## Cross-cutting release rules

- Stable Rust only. A nightly experiment may inform a design but cannot gate the public crate.
- Every retained cache has byte/entry budgets, eviction telemetry, and a correctness-safe miss path.
- Every unsafe block states its invariant and is covered by Miri where applicable; generational
  arenas and callback reclamation receive loom/model tests when concurrency is involved.
- WASM/headless/full GPU backends share conformance fixtures; capability tiers may differ.
- Performance PRs include work-counter deltas, not only wall-clock anecdotes.
- Old and new paths are removed only after the new path passes parity and stored performance gates.

## Kill switches and recovery

During rollout, retain per-window flags for full layout, full hit-index rebuild, full a11y publish,
full scene emission, and full-surface damage. These are correctness fallbacks and diagnostic
bisectors. They are not permanent alternate architectures: once a phase is proven, production
fallbacks narrow to real platform/device recovery cases.

If a mechanism fails its exit gate, preserve the plan's invariant and replace the mechanism. For
example, a height heap may become a collected dirty-subgraph topological pass; a sum tree may use a
different order-maintenance encoding; a reactive style slot may become a specialized field store.
The user-facing state/value/structure contracts should survive those substitutions.
