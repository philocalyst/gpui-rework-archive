# Academic Papers & Cross-Domain Systems for a Compile-Time-Verified Fine-Grained Reactive GPUI

> Research synthesis, not the final recommendation. Durability, MVCC, height ordering, and compiler
> ideas are narrowed in [06-competitive-update.md](06-competitive-update.md) and selected/rejected in
> [../03-hybrid-plan.md](../03-hybrid-plan.md).

Research date: 2026-08-09. Scope: incremental computation theory, FRP lineage, compiler-assisted
reactivity, typestate/session types, layout theory, database/ECS reactivity, and odd corners
(Compose snapshots, attribute grammars, spreadsheets, HDLs, build-systems taxonomy, lenses).
Every claim below is sourced; where a source didn't yield the specific technical detail requested,
that gap is flagged rather than papered over.

---

## 0. Where GPUI is today (ground truth, read from source)

Before importing ideas, a baseline of GPUI's *current* invalidation model, read directly from
`crates/gpui/src/app.rs` and `crates/gpui/src/app/entity_map.rs` in this repo:

- State lives in `Entity<T>` handles inside a `SlotMap`-backed `EntityMap`
  (`crates/gpui/src/app/entity_map.rs:56-60`). Mutating an entity's state and calling
  `cx.notify()` (`crates/gpui/src/app/context.rs:229`, `crates/gpui/src/app.rs:2658`) pushes an
  `Effect::Notify` onto a `pending_effects` queue.
- Effects are drained by `App::flush_effects` in a loop; `apply_notify_global_observers_effect`
  and window notification effects mark `window.invalidator.set_dirty(true)`
  (`crates/gpui/src/app.rs:1784`).
- On the next frame, any window whose invalidator `is_dirty()` gets fully re-drawn:
  `self.update_window(window, |_, window, cx| window.draw(cx).clear(cx))`
  (`crates/gpui/src/app.rs:1699-1705`). "Draw" rebuilds the *entire* element tree for that window
  from scratch (immediate-mode-style `render()` calls), then diffs against the GPU scene.
- `observe`/`observe_global`/`observe_new` (`crates/gpui/src/app.rs:1083, 2052, 2098`) let entities
  subscribe to other entities' notifications, but this is coarse: a subscriber is re-run in full,
  not at the granularity of the specific field that changed.

**Classification**: this is a *dirty-bit, whole-window, push-notify* scheme — the crudest cell in
the Build Systems à la Carte taxonomy (§6 below): dependencies are implicit (whatever `render()`
touches), rebuild decisions are a single boolean per window, and there is no fine-grained
dependency graph, no memoization of sub-trees, and no compile-time tracking of what state a given
element actually reads. This is the baseline every idea below is measured against.

---

## 1. Incremental computation

### 1.1 Self-adjusting computation (Acar)

Umut Acar's 2005 CMU thesis, *Self-Adjusting Computation*
([PDF](https://www.cs.cmu.edu/~rwh/students/acar.pdf)), is the ur-text: an ordinary program is
transformed (by hand or via a "modifiable references" library) into one that records a **dynamic
dependence graph (DDG)** of reads during execution, and a **change-propagation algorithm** replays
only the parts of the DDG downstream of a changed input, re-executing exactly the code that
observed the changed value and nothing else, with amortized-optimal overhead — self-adjusting
programs are shown to be composable and to add only O(1)-time overhead per operation in the
common case (thesis abstract). The follow-up *An Experimental Analysis of Self-Adjusting
Computation* ([PDF](https://www.cs.cmu.edu/~guyb/papers/ABBT06.pdf), Acar/Blelloch/Blume/Tangwongsan
2006) validates this against custom incremental algorithms for problems like incremental
computational geometry, showing near-matching asymptotic complexity from a naive from-scratch
program plus the DDG machinery — i.e., you get an online algorithm "for free" from a batch one.

**Mechanism**: every read of a mutable cell is logged as an edge in the DDG; every write triggers a
change-propagation pass that walks only the edges reachable from that cell, in the *order they were
originally executed* (a time-stamped order, not a topological-height order — see §1.3 for the
contrast with Incremental). This is the direct ancestor of both Adapton and Salsa.

### 1.2 Adapton / miniAdapton — demand-driven, names, laziness

Adapton (Hammer et al., PLDI 2014, [paper](http://matthewhammer.org/adapton/adapton-pldi2014.pdf),
[project page](http://matthewhammer.org/adapton/)) is an OCaml library implementing λ_iccdd, a
demand-driven incremental calculus. Its central complaint about prior self-adjusting-computation
systems (including Acar's) is that they are **push-only**: any change to an input propagates through
*every* reachable dependent, even parts of the computation that the current observer no longer
needs. Adapton fixes this with:

- **Laziness as first-class**: computations are represented as suspended `thunk`s; a thunk is only
  forced when an *observer* demands its value, and change-propagation is likewise demand-driven —
  a stale thunk isn't recomputed until something asks for it.
- **Names**: nodes in the demanded computation graph ("DCG") are addressed by explicit, programmer-
  supplied names (not just their position/identity), which lets Adapton match up "the same logical
  computation" across changed input structures (e.g., an element inserted into the middle of a
  list) rather than tearing down and rebuilding all subsequent memoized nodes. This is the
  mechanism that gives Adapton good behavior for incremental operations over *structurally changing*
  collections (map/filter/fold over a list where an item is inserted mid-list), a problem push-based
  systems like Jane Street's Incremental handle poorly without manual re-keying.
  ([Incremental Computation with Names, extended version](https://www.researchgate.net/publication/274095005_Incremental_Computation_with_Names))

**Where this fits a frame GUI**: names map almost exactly onto the "stable list-item identity"
problem every UI framework re-solves per-list (`key=` in React, `for` item identity in Solid/Svelte,
diffing in Xilem). Adapton's answer — make identity a first-class *name* the incremental engine
uses to reuse memoized subcomputations — is more principled than ad hoc `key` props and is directly
stealable as "GPUI elements are addressed by a name/path, and re-rendering an element with the same
name reuses its cached layout/paint subtree if none of its *demanded* dependencies changed."

### 1.3 Jane Street's Incremental & Incr_dom — height-ordered stabilization

Incremental ([intro post](https://blog.janestreet.com/introducing-incremental/),
[GitHub](https://github.com/janestreet/incremental)) is a push-based, eagerly-scheduled dataflow
graph, explicitly contrasted by Jane Street with FRP (their post calls out the "incremental GUI
construction" use case as an alternative to FRP). Its scheduling algorithm, confirmed from
GitHub/DeepWiki search results:

- Every node has a **height**: an over-approximation of the longest path from a "variable" (root
  input) to that node, maintained as an invariant that if there is an edge n1 → n2 then
  `height(n1) < height(n2)`.
- A single **recompute heap**, ordered by height (not insertion order, not topological-sort-per-
  frame), holds all nodes marked dirty since the last stabilization.
- `stabilize()` repeats: pop the node with **smallest height** from the recompute heap, recompute
  it, and if its value *changed*, push its parents onto the heap. This guarantees each node fires at
  most once per stabilization and always after all of its (currently lower-height) inputs have
  settled — glitch-free by construction, without needing a full topological sort each frame (the
  heap ordering amortizes that).
- A separate **adjust-heights heap** handles the case where the graph's *structure* changes (e.g., a
  `bind` produces a new subgraph whose height invalidates the height invariant elsewhere) — heights
  are lazily repaired rather than globally recomputed.
- **Cutoffs**: "if you recompute the value of a node and find that the new value is equal to the old
  value, you don't actually need to recompute [propagate to] its children" — an explicit, per-node,
  user-overridable equality check that prunes propagation. This is the same idea as React/Compose
  "bail out if value is `===`" but generalized to arbitrary user equality functions per node, and
  applied *during* a single graph-wide stabilization rather than per-component render.
- Reported micro-cost: "firing a single node takes on the order of 30ns" — i.e., Incremental is
  advertised as suitable when per-node work is nontrivial or the graph is large, not as a
  zero-overhead abstraction; there is real per-node bookkeeping cost.

**Incr_dom** (self-adjusting DOM, [blog](https://blog.janestreet.com/self-adjusting-dom/)) is the
production consumer: model changes flow through `Incr.map`/`Incr.bind` chains that build a virtual
DOM incrementally, with **field-projection** (splitting a record into per-field incrementals via
physical-equality cutoffs so that, e.g., changing `temperature` doesn't dirty a `selected: bool`
projection) as the main technique for keeping recomputation scoped. The post is explicit that this
approach was worked out for flat records and that nested/variant-heavy data structures were an open
problem at time of writing — a useful admission that height-ordered incremental graphs don't trivially
scale to deeply nested UI state without careful manual projection, which a Rust proc-macro
(`#[derive(Incremental)]` generating per-field cutoff nodes) could automate.

### 1.4 Salsa / rust-analyzer — red-green + durability

Salsa ([overview](https://salsa-rs.github.io/salsa/overview.html),
[algorithm reference](https://salsa-rs.github.io/salsa/reference/algorithm.html),
[rustc-dev-guide](https://rustc-dev-guide.rust-lang.org/queries/salsa.html)) is explicitly a
Rust reimplementation of rustc's query system's incremental algorithm, hence its name (rustc's
red-green coloring, "Salsa" as a pun). Mechanism:

- Every input bump increments a global **revision counter**.
- A tracked query, when invoked in a new revision, doesn't necessarily re-execute: Salsa walks its
  recorded dependencies and checks, for each, whether *that* dependency's value could have changed
  since the query's `verified_at` revision. If none did, the cached result is **backdated** — reused
  and marked verified at the current revision without recomputation. This is a **verifying-trace**
  style scheme (see §6): correctness is checked lazily/on-demand by walking dependency edges, not by
  eagerly pushing dirty marks.
- **Backdating**: even when an input *did* change, if the recomputed output is *equal* to the old
  output, the result is backdated so that things depending on it don't need to re-execute either —
  functionally identical to Incremental's cutoffs but implemented via a pull/verify walk rather than
  a push/height-heap.
- **Durability** ([Durable Incrementality post](https://rust-analyzer.github.io/blog/2023/07/24/durable-incrementality.html)):
  the killer optimization for large graphs. Naively, incrementing a single global revision number
  and then having every downstream query re-verify its dependency chain costs real time even when
  nothing relevant changed — rust-analyzer measured **~300ms** of pure graph-traversal overhead when
  editing `src/lib.rs`, even though the standard library (durable, unaffected) dominates the query
  graph size. The fix: replace the single revision *number* with a revision **vector**, one component
  per durability tier (their post describes three tiers: volatile/local source, normal/third-party
  deps, durable/stdlib). Bumping a low-durability input only increments that tier's counter; queries
  that provably only depend on higher-durability tiers never need to be walked at all, because their
  recorded durability floor already proves they can't be affected — this **skips whole subgraphs
  without visiting a single edge in them**, converting an O(edges) traversal into an O(distinct
  durability tiers touched) check for the common "I only edited my own file" case.

**Direct relevance to GPUI**: a UI has an almost perfect durability hierarchy already —
theme/design-tokens (rarely change) → app-level settings (change occasionally) → per-window layout
constraints (change on resize) → per-frame animation/interaction state (changes every frame). A
durability-tiered dependency system would let GPUI skip re-verifying theme-derived style computations
on every keystroke, the same way rust-analyzer skips re-verifying stdlib-derived types on every
local edit.

### 1.5 Differential dataflow — arrangements & consolidation as a model for incremental lists

Differential dataflow ([CIDR 2013 paper](https://www.cidrdb.org/cidr2013/Papers/CIDR13_Paper111.pdf),
[foundations](https://www.researchgate.net/publication/301971998_Foundations_of_Differential_Dataflow),
[Materialize arrangements docs](https://materialize.com/docs/get-started/arrangements/), [shared
arrangements VLDB paper](http://www.vldb.org/pvldb/vol13/p1793-mcsherry.pdf)) generalizes
incremental view maintenance by tracking `(value, time, diff)` triples over a *partially ordered*
set of logical timestamps, rather than Incremental/Salsa's single linear revision counter. The key
structure, an **arrangement**, is a compacted, indexed, sorted representation of a collection's
current *and historical* update stream that multiple downstream operators (joins in particular) can
share without each maintaining its own copy — this is explicitly the mechanism Materialize uses for
multi-query sharing of the same incrementally-maintained state
([shared arrangements paper](https://dl.acm.org/doi/10.14778/3401960.3401974)).
**Consolidation** collapses `(+1, -1)` diff pairs for the same key/time into nothing, keeping the
working set proportional to *actual* churn rather than accumulated history.

**Where this fits a GUI**: differential dataflow's model — treat a *list of UI items* as a
collection of `(item, diff)` updates rather than as "the whole list, re-diffed" — is precisely what
virtual-DOM keyed-list reconciliation is trying to approximate with heuristics. A DD-style arranged
list (sorted, indexed, incrementally maintained multiset) as GPUI's list/table primitive would let
insert/remove/reorder of list items cost O(log n) or O(1) amortized rather than O(n) diffing, and
the "arrangement shared across queries" idea maps onto "the same filtered/sorted view of a
collection, shown in two different panes, sharing one incremental index" — a case current React/Vue/
GPUI list virtualization does not handle without manual memoization.

### 1.6 Anchors — a Rust attempt at exactly this design space

The `anchors` crate ([crates.io](https://crates.io/crates/anchors/0.3.0),
[GitHub](https://github.com/lord/anchors)) is worth flagging because it's a prior Rust attempt to
hybridize Adapton-style pull and Incremental-style push in one graph: "a hybrid graph that allows
both Adapton-style and Incremental-style push updates... cloning values in the graph is almost
always optional." Its `Singlethread` engine supports both `mark_observed`/`mark_unobserved` pull
semantics and push semantics in the same graph. It is explicitly alpha/abandoned-feeling ("expect
major API changes over the next several years") but its API design (map closures over `&T` returning
owned `T`, or `refmap` closures over `&T` returning `&T` to avoid clones) is a concrete existence
proof for how an incremental-computation core could be built in Rust without pervasive cloning —
relevant to a compile-time-verified reactive GPUI that must respect borrow-checker constraints.

---

## 2. FRP lineage

### 2.1 Fran and push-pull FRP (Conal Elliott)

Elliott & Hudak's *Functional Reactive Animation* (ICFP 1997) introduced **behaviors** (continuous
time-varying values) and **events** (discrete occurrences) as the two core FRP abstractions —
this behavior/event split is the taxonomic backbone the Bainomugisha survey (§2.3) later uses to
classify the entire field. Elliott's later *Push-Pull Functional Reactive Programming*
(Haskell Symposium 2009, [PDF](http://conal.net/papers/push-pull-frp/push-pull-frp.pdf)) is the
direct ancestor of the "hybrid" evaluation model: the paper's stated problem is that demand-driven
(pull) FRP "wastes computation and can result in high reaction latency" when sampled naively, while
naive push wastes work on events nobody observes; the `reactive` library's fix is a hybrid where
events *push* (to get low latency for discrete occurrences) and behaviors are *pulled*/sampled on
demand (avoiding continuous polling of things nobody's observing) — the same push/pull-hybrid split
that underlies both Incremental (push+cutoff) and Salsa (pull/verify) decades later, and the one
Solid.js/Vue's reactivity systems (§3) independently re-derive at the JS-runtime level.

### 2.2 Higher-order FRP and the spacetime leak problem (Krishnaswami)

Krishnaswami's *Higher-Order Functional Reactive Programming without Spacetime Leaks*
(ICFP 2013, [PDF](https://www.cl.cam.ac.uk/~nk480/simple-frp.pdf)) is the single most directly
relevant paper in this literature to a Rust type-system-verified reactive system. Its problem
statement: naive higher-order FRP (streams of streams, first-class behaviors/events as ordinary
values) makes it easy to accidentally retain references to old values in a way that leaks both space
(old graph nodes never freed) and time (recomputation cost grows unboundedly) — a "spacetime leak."
The fix is a **type system**, not a runtime discipline: a modal/temporal type theory that
*statically* bounds the size of the dataflow graph a program can construct, while still allowing
higher-order functions and higher-type streams (streams-of-streams). Concretely (from the abstract
and companion work), this is done with:

- A **"later" modality** (◯ or `Stream`-of-next-tick) marking values that are only available at the
  *next* logical timestep — you cannot use a later-value now, which prevents constructing unbounded
  chains of dependencies that all resolve "eventually."
- **Linear/affine typing** of streams/behaviors so that a stream cannot be duplicated and retained
  in two places without the type system knowing about both retentions — the mechanism that prevents
  the classic leak where an old event handler closure keeps a stale subgraph alive.

This is explicitly the same design space as Rust's ownership/lifetime system, just derived from a
different direction (linear logic / guarded recursion in type theory, rather than a borrow checker
for memory safety). The companion strand — *Higher-order functional reactive programming in bounded
space* (Krishnaswami/Benton/Hoffmann, POPL 2012,
[ACM link](https://dl.acm.org/doi/10.1145/2103621.2103665)) — is the earlier, first-order-restricted
version of the same idea, and *Functional Reactive GUI Programming with Modal Types*
([Springer chapter, 2024](https://link.springer.com/content/pdf/10.1007/978-3-031-99751-8_5.pdf))
is a direct application of this line of work to GUI programming specifically, which should be read
in full if this direction is pursued further (not fully mined in this pass — flagged for follow-up).

**Rust mapping**: a `Rc`/`Arc`-free reactive graph where "you can only read a signal's value inside
a scope tied to its lifetime, and a derived computation's lifetime is bounded by its inputs'
lifetimes" is a weaker, ownership-based analog of Krishnaswami's modal types. Rust cannot express
"available only at the next logical tick" as a first-class modality without a proc-macro or a
GhostCell/branded-lifetime trick, but the *leak-freedom-via-linearity* idea is directly portable:
require that a `Signal<T>` handle can only be *read* while holding a token whose lifetime is the
current frame, so stale cross-frame references to signals are a borrow-check error, not a runtime
leak. This is close to what `GhostCell`/`qcell`-style branded arenas already do in Rust for other
aliasing problems.

### 2.3 Bainomugisha et al., *A Survey on Reactive Programming*

ACM Computing Surveys 2013 ([paper](https://dl.acm.org/doi/10.1145/2501654.2501666), summarized well
by [the morning paper](https://blog.acolyer.org/2015/12/08/a-survey-on-reactive-programming/)).
Taxonomizes reactive languages along six axes: representation of time-varying values (behaviors vs.
events vs. signal functions), **evaluation model** (push / pull / hybrid), lifting operations,
**multidirectionality**, **glitch avoidance**, and distribution support.

- **Push**: source-initiated propagation; low latency, risk of wasted recomputation and of glitches
  (a dependent observed mid-update, before all its inputs have settled).
- **Pull**: dependent-initiated (demand-driven) sampling; avoids wasted work but risks "space and
  time leaks" where the lazily-retained computation graph grows unboundedly if nobody forces it —
  this is the same failure mode Krishnaswami's paper fixes with types, described here at the
  systems-taxonomy level instead.
- **Hybrid**: e.g. push-pull FRP (§2.1) — combine both to get push's latency and pull's efficiency.
- **Glitch avoidance**: the standard fix is **topological ordering** of the dependency graph so a
  node only evaluates after every one of its dependencies has evaluated for the current update
  cycle — exactly Incremental's height invariant and Salsa's revision-consistency check, independently
  arrived at across three different fields. The survey notes this becomes "considerably harder in a
  distributed reactive program" because network delay breaks the ability to establish a consistent
  order — not relevant to a single-process GUI but useful context for why some reactive frameworks
  (Rx-style push streams) *don't* bother with topological glitch-freedom at all and accept transient
  inconsistency.
- **Multidirectionality**: most reactive languages are one-directional (source → derived); a
  minority (constraint-based systems, see Cassowary §5.1) allow *derived* values to be set, with the
  change propagating backward to solve for the sources — relevant to two-way-bound UI controls
  (sliders, text inputs bound to validated model state).

### 2.4 Elm's abandonment of FRP (historical, cautionary)

Elm shipped with an FRP `Signal` model and removed it in 0.17 (May 2016) in favor of The Elm
Architecture + `Sub`scriptions
([official post, "A Farewell to FRP"](https://elm-lang.org/news/farewell-to-frp)). The stated
reasons, condensed: signals were "one of the few stumbling blocks left in learning Elm"; once the
Elm Architecture (model/update/view + a runtime-managed effect loop) existed, *most* application code
never needed to think about signals directly, and removing them let three of Elm's hardest concepts
(signals, addresses, ports) collapse into simpler ones. This is direct evidence that a general
first-class reactive-value abstraction, exposed raw to application authors, is a *usability* tax even
when its underlying propagation algorithm is sound — an argument for GPUI hiding any new incremental
core behind an ergonomic, TEA-like or React-like surface API rather than exposing raw `Signal`/
`Behavior` combinators as the primary programming model.

---

## 3. Compiler-assisted reactivity

### 3.1 Svelte 5 runes

`$state`/`$derived`/`$effect` ([overview](https://svelte.dev), search-summarized details above) are
compiler-recognized markers: the Svelte 5 compiler transforms `$derived(count * 2)` into a runtime
call `$.derived(() => count * 2)` — a lazily-evaluated, memoized thunk, evaluated only when
`$.get(doubled)` is read. The interesting, non-obvious compiler behavior surfaced in research: **the
compiler performs dead-reactivity elimination** — if it can statically prove a `$state` variable is
never written after initialization, it strips the reactive wrapper entirely and treats it as a plain
constant. This is a compile-time optimization *of the reactive graph itself*, not just of generated
code — the compiler is proving a liveness/mutability fact about a value and using it to skip building
graph nodes that will provably never fire. This generalizes to: a Rust proc-macro over a `#[reactive]`
struct/fn could statically determine which fields are ever mutated within the observable scope, and
skip generating tracking machinery for the immutable ones — cutting both memory and runtime overhead
for the (common) case of tree-structured "mostly static" UI state.

### 3.2 Vue Vapor mode

Vue 3.6's opt-in "Vapor" compiler target (search-summarized above; no official paper) skips the
virtual DOM entirely: the compiler emits direct DOM-mutation code wired straight to reactive signals,
so a state change touches exactly the bound DOM node with zero diff/patch step. Reported gains:
20-50% bundle size reduction and Solid/Svelte-comparable runtime performance for Vapor-only
components. The architecturally important point for GPUI: Vapor is *opt-in per component* and
interoperates with the legacy virtual-DOM renderer in the same app — i.e., the framework authors
explicitly decided that a hard, all-or-nothing migration to fine-grained reactivity was too risky,
and instead built a boundary where "coarse" and "fine" reactive subtrees can be mixed. This is a
strong argument for any GPUI redesign to support incremental, per-element opt-in to a new fine-grained
model rather than requiring an all-at-once rewrite of every `Render` impl.

### 3.3 Qwik resumability

Qwik's resumability model (Misko Hevery; summarized above,
[docs](https://qwik.dev/docs/concepts/resumable/),
[Builder.io comparison](https://www.builder.io/blog/resumability-vs-hydration)) is not incremental
*computation* in the Adapton/Salsa sense but is a directly relevant idea about **serializing
reactive-graph state across a discontinuity**: instead of hydration (re-executing the whole
component tree on the client to reconstruct listeners/state/tree), Qwik serializes the already-built
reactive graph (including *where* event listeners are and what closures they need) into the HTML
itself, so the client can "resume" — attach a listener lazily, only on first interaction, without
ever re-running component setup code. For GPUI this doesn't apply to hydration (no SSR concept) but
the underlying idea — a reactive graph's *topology* is serializable/resumable state, not something
that must be rebuilt by re-executing all constructor code — is relevant to GPUI's window
restore/multi-window duplication features (rebuilding a window's element/signal graph from a saved
description rather than replaying every `render()` call).

### 3.4 React Compiler (né React Forget)

([DebugBear overview](https://www.debugbear.com/blog/react-compiler),
[SitePoint](https://www.sitepoint.com/react-20-compiler-usememo-changes/)) performs **static value-
dependency-graph construction at the Babel/AST level**: for each expression in a component body, it
builds a dependency graph of which props/state values that expression reads, groups expressions into
"reactive scopes," and inserts a per-scope memoization cache slot with a conditional equality check
— mechanically similar to what a human writing `useMemo`/`useCallback` everywhere would do, but
exhaustive and correctly scoped rather than ad hoc. It works under a closed-world assumption ("Rules
of React": no mutating props, no non-deterministic calls during render) and **bails out of
optimizing a scope, rather than miscompiling, when it detects a rule violation** — a safety-first
static-analysis posture directly analogous to how a Rust proc-macro reactive-derive should behave:
detect unsupported patterns (interior mutability escaping tracked scope, etc.) at compile time and
either hard-error or fall back to an unoptimized path, never silently produce wrong incremental
behavior.

**What's inferred vs. tracked, synthesized across 3.1-3.4**: Svelte/React-Compiler infer the
*dependency graph shape* statically from source, then generate code that tracks *runtime identity/
equality* of the actual values (compile-time graph construction + runtime value tracking). Solid/Vue-
non-Vapor infer nothing at compile time and track both graph *and* values at runtime via `Proxy`/
getter interception. Vue Vapor and Svelte both additionally use the compiler to eliminate dead
reactivity nodes entirely when provably safe. A Rust proc-macro is best positioned to do what
Svelte/React-Compiler do — infer the dependency graph shape from field-access patterns in a derive
macro or attribute-annotated function body — because Rust already has the necessary static
information (types, mutability, ownership) available at macro-expansion time without needing a full
data-flow analysis pass; what Rust *cannot* cheaply replicate is JS's dynamic-proxy runtime value
tracking, which argues for doing more of the work in the macro than these JS systems do at runtime.

---

## 4. State machines & session types for UI

### 4.1 Statecharts (Harel) and XState

Statecharts (Harel, 1987) extend finite state machines with hierarchy (nested/compound states),
orthogonality (parallel regions), and history states, specifically to make *reactive, event-driven
systems* tractable to specify without state-explosion
([statecharts.dev](https://statecharts.dev/use-case-statecharts-in-user-interfaces.html)). XState
([GitHub](https://github.com/statelyai/xstate)) is the canonical modern implementation, used widely
for exactly the class of UI-flow problems named in the brief (multi-step forms, drag interactions,
modal stacks). Statecharts are a *runtime-checked* discipline in XState — illegal transitions are
rejected when the machine processes an event, not rejected by the type system before compilation.

### 4.2 Typestate in Rust

The typestate pattern encodes a value's protocol-state in its *type*, using distinct generic
instantiations (`Order<Created>`, `Order<Paid>`, `Order<Shipped>`) so that calling a method only
valid in a later state is a compile error, not a runtime assertion (search-summarized;
this is a well-established, if informally documented, Rust idiom, not from a specific paper). This
is the compile-time analog of a statechart: instead of a table of (state, event) → state checked at
runtime, the *type system* enforces that you cannot even construct a call sequence that violates the
protocol, at the cost of needing a distinct type (and therefore, typically, code duplication or
generics) per state.

### 4.3 Session types in Rust: `session_types` and Ferrite

`session_types` ([crates.io](https://crates.io/crates/session_types)) implements binary session
types for Rust channels using **move semantics as the enforcement mechanism**: "taking a step" in
the protocol (send/receive) consumes the channel value and returns a new one typed as the next
protocol state, so the old, already-used state cannot be reused — Rust's ownership system alone
is sufficient to give static protocol-adherence guarantees, no special compiler support needed.

Ferrite ([PLDI/ICFP-style paper, arXiv 2205.06921](https://arxiv.org/abs/2205.06921),
[book](https://ferrite-rs.github.io/ferrite-book/)) goes further: it's a *judgmental embedding* of a
full session-type calculus (including **shared**, not just linear, sessions) into Rust, formally
verified equivalent to the source calculus. Its type system distinguishes linear session endpoints
(no contraction, no weakening — must be used exactly once) from shared ones, and "protocol adherence
is guaranteed statically by the Rust compiler."

**UI application, concretely**: a drag interaction has an implicit protocol —
`PointerDown → { PointerMove* → (PointerUp | PointerCancel) }` — and today in GPUI (and virtually
every GUI framework) this is enforced by *runtime discipline* (an `Option<DragState>` that's checked
and matched by hand at each event). A session-typed drag handle — `DragStart` returns a
`DraggingHandle` type whose only methods are `.move_to()` and `.finish()`/`.cancel()`, both of which
*consume* it (returning either a new `DraggingHandle` or ending the session) — would make "calling
`.finish()` twice" or "handling a `PointerMove` before `PointerDown`" a compile error rather than a
possible bug, using exactly the same move-semantics trick as `session_types`. This is a small,
scoped, high-confidence port from an existing Rust crate design, not speculative research.

---

## 5. Layout & styling theory

### 5.1 Cassowary constraints — and why it was dropped

Cassowary (Badros/Borning/Stuckey, *ACM TOCHI* 2001,
[paper](https://dl.acm.org/doi/10.1145/504704.504705),
[docs](https://cassowary.readthedocs.io/en/latest/topics/theory.html)) is an incremental linear-
constraint solver (a simplex variant) that underlies AppKit/UIKit Auto Layout and was briefly
prototyped, then removed, in Flutter (a 2017 commit message: "We didn't end up using this mechanism,"
[Flutter issue #50309](https://github.com/flutter/flutter/issues/50309)). Its strengths, confirmed
from the Cassowary paper/docs: constraints are **local to a view** and compose automatically when
views combine (a natural fit for component-based UIs), and `suggestValue`-style incremental re-
solves are fast enough for 60fps interactive dragging even on 2001-era hardware — the algorithm is
*designed* to be incremental (add/remove one constraint at a time cheaply), which is exactly the
"invalidate one thing, don't resolve from scratch" property a reactive GUI wants from its layout
system. Its limitation, also confirmed: **linearity only** — no quadratic terms, no products of
variables, no conditional/branching constraints — which makes it a poor fit for the kind of
content-dependent, branchy sizing logic (text wrapping, intrinsic-size-dependent flex) that
dominates real UI layout, and is the most likely reason it lost out to imperative flexbox-style
layout algorithms industry-wide: those handle conditional/content-dependent sizing natively at the
cost of losing multi-directional (solve-for-either-side) constraint solving.

**Relevance**: Cassowary's incrementality is attractive, but its expressiveness gap is real and
explains the industry's convergence on flexbox/flow layout instead. A hybrid — flexbox-style layout
as the default, with an *optional* Cassowary-solved region for the minority of cases needing true
multi-directional constraints (e.g., a resizable multi-pane splitter, or an inspector panel with
interdependent field widths) — is a more defensible design than a wholesale switch.

### 5.2 Parallel/attribute-grammar layout (Meyerovich & Bodik)

*Fast and Parallel Webpage Layout* (Meyerovich & Bodik, WWW 2010,
[PDF](https://lmeyerov.github.io/projects/pbrowser/pubfiles/paper.pdf)) reformulates CSS layout
solving as an **attribute grammar** evaluation problem: a page's DOM tree is the grammar's parse
tree, and layout properties are *inherited attributes* (flow down: available width, containing
block) and *synthesized attributes* (flow up: intrinsic/used size) — exactly the "constraints flow
down, sizes flow up" model GPUI's own blog post independently describes (§5.4). The paper's
contribution is showing that, formulated this way, layout solving is **provably parallelizable to
O(log n) depth without extra reflow passes**, and their prototype (a from-scratch layout engine,
"Superconductor," described in a follow-up as ["A Language for Big Data
Visualization"](https://datavis.cs.columbia.edu/files/papers/superconductor.pdf)) measured speedups
up to **80x** on real webpages by exploiting this parallel structure plus new parallel algorithms for
CSS selector matching and font rendering.

**Why this matters for a *reactive*, not just parallel, layout engine**: an attribute grammar is
inherently an incremental-computation-friendly formalism — inherited/synthesized attributes are just
named dependency edges, and re-evaluating only the attributes downstream of a changed node is the
same change-propagation problem as §1. This gives a principled vocabulary (inherited vs. synthesized
attribute, not "layout pass 1 / layout pass 2") for specifying which parts of GPUI's constraint-down/
size-up layout algorithm are safe to memoize/cutoff-check per attribute rather than per whole
element, and the Meyerovich result is direct evidence that this formulation also unlocks parallelism
essentially for free, which is independently attractive for a 120fps target.

### 5.3 Typed/compile-time-checked CSS-in-Rust

Search turned up concrete, if minor, prior art: `tailwindcss-to-rust`
([crate](https://crates.io/crates/tailwindcss-to-rust/0.3.0),
[blog](https://blog.urth.org/2022/02/21/checking-tailwind-class-names-at-compile-time-with-rust/))
generates Rust code so that a Tailwind class name typo is a compile error rather than a silently-
ignored missing style; `encre-css` ([lib.rs](https://lib.rs/crates/encre-css)) is a from-scratch,
Tailwind-compatible utility CSS generator in Rust claiming best-in-class benchmark speed;
`stylers`/`stylist`-family crates let CSS be written inline in Rust source and extracted/scoped at
compile time. None of these attempt compile-time-checked *layout* (only class-name/existence
checking), so the brief's suggestion of "typed Tailwind" is only partially realized in the Rust
ecosystem today — there is room for GPUI to go further than any existing Rust crate here, e.g.
compile-time-checked *combinations* of utility classes (detecting `flex` used without a `flex-
direction` at macro-expansion time), which none of the found crates do.

### 5.4 GPUI's own stated design constraints (Zed blog)

["Leveraging Rust and the GPU to render user interfaces at 120 FPS"](https://zed.dev/blog/videogame)
states GPUI's layout pipeline explicitly as "constraints flow down and sizes flow up" (a Flutter-style
box-constraint model, itself a special-case, non-solver instantiation of the attribute-grammar
formulation in §5.2), and describes elements as producing a platform-neutral `Scene` of primitives
(rects, shadows, glyphs) that is rendered via primitive-specific GPU shaders rather than a general-
purpose rasterizer — i.e., GPUI already treats "what to draw" as data pushed to the GPU rather than
immediate imperative draw calls, which is a retained-mode characteristic layered under an immediate-
mode-*feeling* API. Notably, per the fetch of that post, **it explicitly defers discussion of state
management, reactivity, and dependency tracking to a future post** — the current public blog
material does not document GPUI's invalidation model at the design-rationale level; §0 above (read
from source) is a better source of truth than the blog for that question.

---

## 6. Databases/ECS angle

### 6.1 Reactive queries / incremental view maintenance (Materialize)

Covered mechanically in §1.5 (differential dataflow is Materialize's engine). The UI-relevant framing:
Materialize treats a live dashboard as a SQL view whose result set is *incrementally maintained*,
never recomputed from scratch — "recent increments in incremental view maintenance" is an active
research area ([arXiv 2404.17679](https://arxiv.org/pdf/2404.17679)) with the core insight that IVM
requires only propagating *deltas* through the query plan, exactly the same primitive a reactive
UI needs to propagate deltas through a render tree. The generalizable idea: **any derived UI state
computed from a collection (filtered list, sorted table, grouped/aggregated summary) is structurally
a materialized view**, and should be built on an IVM-style engine rather than hand-rolled diffing —
this is the theoretical justification for §1.5's suggestion to use an arrangement-like structure for
GPUI's list/table widgets.

### 6.2 ECS-based reactive UI: bevy_reactor and Quill (viridia)

These are the single most directly on-point prior-art projects in this entire research pass, per the
brief's own flag, and deserve to be read in full by whoever implements the next step (this pass
covers them at a level derived from repo descriptions/DeepWiki, not full source review):

- **bevy_reactor** ([GitHub](https://github.com/viridia/bevy_reactor),
  [DeepWiki](https://deepwiki.com/viridia/bevy_reactor)): "a fine-grained reactive framework for
  Bevy" implementing signals, mutables, and derived/memoized computations *as ECS resources and
  components* — i.e., the reactive graph's nodes are literally ECS entities/components, so Bevy's
  existing change-detection (`Changed<T>` queries, which Bevy already implements via a tick-counter
  scheme not unlike a coarse revision counter) and system-scheduling machinery double as the
  reactive engine's propagation substrate, rather than building a separate graph data structure
  alongside the ECS.
- **Quill** ([GitHub](https://github.com/viridia/quill), predecessor
  [quill_v1](https://github.com/viridia/quill_v1)): a React/Solid/Dioxus/Xilem-influenced UI
  framework built on top of bevy_reactor, i.e., the "component framework" layer over the "reactive
  primitives" layer bevy_reactor provides — a two-layer split (low-level signal graph in ECS +
  higher-level component/view API) worth mirroring in any GPUI redesign so the incremental core and
  the ergonomic surface API can evolve independently.
- Related Bevy-core discussions ([ECS and Reactivity #10212](https://github.com/bevyengine/bevy/discussions/10212),
  [Reactivity design choices #10978](https://github.com/bevyengine/bevy/discussions/10978)) show the
  core Bevy maintainers debating whether reactivity belongs in the engine itself (as an
  observer/event system, eventually shipped as Bevy's "Observers" API) vs. staying a third-party
  layer — the same "core vs. ecosystem" tension GPUI faces around whether fine-grained reactivity
  should be a first-class part of the framework or an opt-in layer.

**Why this is unusually relevant to GPUI specifically**: GPUI's `Entity<T>`/`SlotMap` model (§0) is
already structurally an ECS (typed, ID-addressed, arena-allocated component storage), just without
the query/archetype machinery. bevy_reactor demonstrates that this exact starting point — entities +
components + a tick/generation counter for change detection — is sufficient to build fine-grained
signals on top of, without inventing a wholly separate reactive-graph data structure. This is a much
smaller delta from GPUI's current architecture than adopting, say, Adapton's demanded-computation-
graph model wholesale.

### 6.3 Flecs relationships for UI trees

Not separately confirmed by search in this pass (flagged as unexplored — the brief's mention of
"flecs relationships for UI trees" did not surface distinct search results beyond general flecs docs
already implicit in ECS literature); worth a follow-up pass specifically on flecs' relationship
(`(Relation, Target)` pair) feature as a way to model parent-child and "observes" edges in a UI tree
as first-class queryable ECS relationships rather than out-of-band pointers, but this claim is not
independently verified here and should not be cited as settled.

---

## 7. Odd corners

### 7.1 Jetpack Compose's snapshot system (MVCC)

Compose's state system ([Compose Internals: Concurrency Control](https://composeinternals.com/concurrency-control-in-jetpack-compose),
[snapshot deep dive](https://mukuljangra.com/guide/compose-snapshot-system/)) implements
**multiversion concurrency control**, the same technique used by transactional databases, for a
completely different reason than a database: not durability/crash-recovery, but *isolation for
concurrent recomposition*. Mechanism: each `mutableStateOf` object holds multiple **versioned
records**, tagged by snapshot ID; writes inside a "mutable snapshot" don't mutate shared state
in-place, they record a new version scoped to that snapshot; the snapshot is later **applied**
atomically, making all its writes visible at once. This gives Compose lock-free atomicity,
consistency, and isolation for state reads/writes happening on different threads during
recomposition (which Compose deliberately allows to run in parallel across the composition tree) —
explicitly *not* durable/recoverable/distributed, because a UI framework doesn't need those DB
properties, just the concurrency-isolation ones.

**Relevance to a Rust GUI**: GPUI is currently single-threaded for its entity/window state (the
`App`/`Context` types are not `Send` in the general case per typical GPUI usage patterns), so MVCC's
concurrency motivation doesn't directly apply today — but if a future GPUI wants to parallelize
layout or paint computation across elements (as Meyerovich's attribute-grammar result in §5.2 shows
is theoretically available), a Compose-style snapshot/MVCC layer is the proven mechanism for letting
multiple layout subtrees read consistent, isolated views of shared reactive state concurrently
without locks, while writes (from event handlers) stay serialized. This is a "when you need thread-
parallel recomputation" tool, not a baseline requirement.

### 7.2 Attribute grammars generally (UUAGC)

The Utrecht University Attribute Grammar system ([Hackage package](https://hackage.haskell.org/package/uuagc))
compiles `.ag` grammar specifications (inherited + synthesized attribute declarations over a tree
grammar) to plain Haskell implementing the tree walks. This is the general form of the Meyerovich
layout formulation (§5.2): "derive attributes over a tree" is a formalism broad enough to cover not
just layout but *styling cascade resolution* (CSS's inherited properties are literally inherited
attributes; computed/used values are synthesized attributes) and even a UI's derived-state
computations in general (a "selected item's computed display string" is a synthesized attribute of
the selection state). UUAG's specific contribution beyond "just write the tree walk by hand" is
automatically **fusing multiple attribute computations into a single tree traversal** at compile
time (confirmed via the "Zipping Strategies and Attribute Grammars" and "traversal fusion" related
papers surfaced in search, e.g. [arXiv 2110.07902](https://arxiv.org/pdf/2110.07902),
[traversal fusion](https://arxiv.org/pdf/1904.07061)) — i.e., if styling, layout, and accessibility-
tree computation are all naturally expressed as attributes over the same element tree, an attribute-
grammar-style compiler can fuse them into one pass instead of three separate tree walks, which is a
concrete, checkable optimization a Rust proc-macro operating over a `#[derive(Element)]`-annotated
tree could plausibly replicate.

### 7.3 Spreadsheets as the original fine-grained reactive system

Confirmed historically: the first electronic spreadsheet, LANPAR (1969, Pardo & Landau), was built
specifically to avoid a 6-month-to-2-year manual respreadsheeting cycle at Bell Canada/AT&T for a
2000-cell budget model — i.e., incremental recomputation-on-change was the *entire point* of the
spreadsheet's invention, predating every academic incremental-computation paper cited elsewhere in
this report by decades. The formal model (confirmed generically, no single canonical paper
identified in this pass — flagged as an area where a more targeted literature search, e.g. for
Sestoft's or Burnett's spreadsheet-semantics papers, would sharpen the citation) is: every cell is a
node in a dependency DAG; a formula's dependencies are exactly the cells it reads; a changed cell
triggers recomputation of exactly its transitive dependents, in dependency order. This is
push+topological-order — the same glitch-avoidance mechanism as §2.3, arrived at by spreadsheet
implementers with no FRP theory at all, which is a strong argument that topological/height-ordered
push propagation (§1.3, §2.3) is the "obviously correct, independently-rediscovered" baseline
algorithm — everything else in this report is an optimization or expressiveness extension on top of
that baseline, not a different baseline.

### 7.4 Hardware description languages: Clash & Chisel

Clash ([clash-lang.org](https://clash-lang.org/)) is a Haskell-syntax HDL restricted to **synchronous
circuits only**, with a `Signal dom a` type parameterized by clock domain — every value is explicitly
"the value of this wire at clock cycle N," and the type system prevents mixing signals from different
clock domains without an explicit synchronizer. Chisel ([GitHub](https://github.com/chipsalliance/chisel))
embeds hardware description in Scala with its own distinct wire/register/signal types rather than
reusing host-language types. The relevant idea for reactive UI: both languages make "which logical
timestep does this value belong to" a **type-level** distinction (Clash's `dom` type parameter), not
a runtime concept — this is a hardware-world independent arrival at the same idea as Krishnaswami's
modal "later" type (§2.2): temporal staging as a type, not a runtime tag. For a frame-based GUI, a
`Frame<'a>`-branded signal handle (a signal value is only valid/readable within the frame it was
computed, checked via a lifetime brand) would be the Rust-idiomatic version of Clash's clock-domain
typing — turning "read a stale signal from last frame" into a compile error via lifetime variance
rather than a logic bug caught by testing.

### 7.5 Build Systems à la Carte — the taxonomy, and where everyone falls in it

Mokhov, Mitchell, Peyton Jones, ICFP 2018
([paper PDF](https://www.microsoft.com/en-us/research/uploads/prod/2018/03/build-systems.pdf),
[Peyton Jones talk notes](https://simon.peytonjones.org/build-systems-a-la-carte/)). The paper's
framework: every build system factors into two **orthogonal** choices —

1. **Task order / scheduling**: topological (Make: static dependency graph known up front),
   restarting (Excel: re-run and see what it asks for, restart if a not-yet-computed dependency is
   hit), suspending (Shake/Bazel-style: use continuations to suspend a task mid-execution when it
   hits an unbuilt dependency, resume it once that's ready).
2. **Rebuild strategy** — the specific vocabulary the brief asked for (dirty-bit / verifying trace /
   constructive trace), confirmed present in the paper's abstract-level structure even though the
   search results didn't quote the exact terminology verbatim:
   - **Dirty bit**: a boolean per task, set whenever *anything* it might depend on changes; rebuild
     if dirty. Cheapest to implement, coarsest — this is GPUI-today (§0): one dirty bit per *window*.
   - **Verifying trace**: record what each task's inputs' values (or hashes) were last time it ran;
     to decide whether to rebuild, *re-check* (verify) whether those recorded values still match
     current ones — Salsa's red-green/backdating scheme (§1.4) and Nix/content-addressed builds are
     verifying-trace systems: they don't proactively mark things dirty, they lazily verify on demand.
   - **Constructive trace**: go further than verifying — record the actual *output* produced for a
     given set of input values, and if the current inputs exactly match a previously-seen
     combination, **reuse the recorded output without rerunning the task at all**, even across
     different "versions" of the target (this is memoization/caching by input-hash, the strategy
     Bazel/Nix use for remote/shared caching, and the strategy Incremental's per-node "cutoff"
     equality check is a restricted, single-node instance of).

**Mapping GPUI-today, Leptos, SwiftUI, Compose, Salsa onto this taxonomy** (synthesized, not sourced
per-cell — this classification is this report's own analysis applying the paper's framework, cross-
referenced against each system's mechanism as documented above):

| System | Task order | Rebuild strategy | Granularity |
|---|---|---|---|
| GPUI (today, §0) | restarting (re-run `render()` top to bottom each dirty frame) | dirty bit | whole window |
| Salsa / rust-analyzer | suspending (queries call queries, demand-driven) | verifying trace + durability-tiered skip | per query, tiered |
| Jane Street Incremental / Incr_dom | topological (height-ordered) | dirty bit *with* cutoff (a verifying-trace-like value check post-hoc) | per node, with field-level cutoffs |
| Adapton | suspending (demand-driven thunks) | verifying trace (via names) | per named thunk |
| React (pre-Compiler) | restarting (full component re-run) | dirty bit (state/props changed → re-run) + manual constructive-trace opt-in (`useMemo`) | per component |
| React Compiler | restarting, but scopes narrowed | compiler-inserted constructive trace (cache slot + equality check per reactive scope) | per expression-scope, not per component |
| SolidJS / Svelte 5 runes | suspending-ish (signal reads happen when the derived thunk actually runs) | dirty bit + cutoff, evaluated per-signal | per signal/derived value |
| SwiftUI | restarting (`body` re-evaluated) with a diffing pass over the resulting view tree | dirty bit (on the "identity" of dependency-graph inputs via `@State`/`@Observable`) + tree diff as a coarse cutoff | per view struct, then diffed |
| Compose | restarting (`@Composable` re-invoked) but with per-`remember`/skip-if-unchanged checks compiler-inserted like React Compiler | compiler+snapshot-inserted constructive trace (skip recomposition if params unchanged, MVCC for isolation) | per composable call site |

**What cell should a new GPUI target?** Given the 120fps/frame-based constraint (§8 below expands
this), the strongest candidate is **topological/height-ordered scheduling + per-node dirty-bit with
mandatory cutoff checks** (Incremental's cell), *augmented* with Salsa's **durability tiers** to let
whole rarely-changing subgraphs (theme, static layout) skip verification entirely, and with
Adapton-style **names** for list/collection identity so structural edits to collections don't force
full subtree rebuilds. This is a composite of three existing systems' cells, not a novel point in the
taxonomy — which is itself informative: nothing in this literature suggests a *new* algorithmic idea
is needed, only a careful composition of three well-understood ones, tuned for the frame-boundary
constraint no batch build system has (see §8).

### 7.6 Functional lenses/optics in Rust

`lens-rs` ([GitHub](https://github.com/TOETOE55/lens-rs),
[docs](https://docs.rs/optics)) and `pl-lens` ([docs](https://docs.rs/pl-lens)) provide
`#[derive]`-generated lenses (`get`/`set` pairs focusing on a substructure) for Rust structs; Druid's
built-in `Lens` trait ([docs](https://docs.rs/druid/latest/druid/index.html)) is the GUI-specific
precedent — Druid uses lenses as **typed paths into application state**, letting a widget be generic
over "some substructure of the app's data model" rather than the whole model, with the lens
composing (`.then()`) to drill into nested fields. This is directly relevant to a compile-time-
verified GPUI as the mechanism for **typed dependency paths**: if a reactive-tracking system needs
to know "this element depends on `app_state.editor.selection.range`," a composed, statically-typed
lens *is* that dependency path, expressed as a value the tracking system can hash/compare/index by
— arguably a cleaner primitive than the implicit "whatever this closure happened to read" tracking
every other system in this report uses, because a lens's path is inspectable without executing the
computation.

---

## 8. Synthesis

### 8.1 Propagation algorithm verdict for a 120fps frame-based GUI

| Approach | Where it excels | Where it fails for 120fps GUI |
|---|---|---|
| **Eager mark + frame-boundary flush** (Solid/Svelte-ish: mark dirty immediately on write, defer actual recompute to a flush point) | Simple to implement; low latency for the "did anything change" check; matches GPUI's existing `Effect` queue + frame-dirty-flag design (§0) almost exactly, so it's the smallest delta | Without height-ordering, a naive "just walk from dirty roots" flush can still do wasted or out-of-order work on complex fan-in graphs (a node with two dirty parents recomputed twice before both have settled) — need to combine with height ordering, not use in isolation |
| **Height-ordered stabilization** (Jane Street Incremental) | Glitch-free by construction, O(1) amortized scheduling overhead via the recompute heap, proven at production scale (Incr_dom) for a UI workload specifically | ~30ns/node fixed overhead (per Jane Street's own numbers) is a real cost at GUI-sized graphs (thousands of nodes) if applied to *every* piece of state rather than selectively; needs the adjust-heights machinery for dynamic graph shape (conditional rendering), adding implementation complexity |
| **Demand-driven pull** (Adapton/salsa) | Avoids recomputing things nobody's currently observing — valuable for GPUI where large parts of a window (offscreen scroll content, collapsed panels) genuinely aren't observed every frame; salsa's durability tiers give outsized wins when most edits are localized (typing in one text field shouldn't re-verify the whole app's derived style graph) | Pure pull risks the "space/time leak" failure mode (§2.2, §2.3) if not paired with a bound on retained thunks; less naturally "glitch-free within one frame" than push, because nothing forces a consistent snapshot unless you also add a revision/snapshot concept (which Salsa does, via its revision counter) |

**Verdict**: no single one of these is the answer in pure form; the frame boundary itself is the
deciding architectural fact none of these systems (except Incr_dom, which shares it) were designed
around. The recommended composite, matching the "what cell should GPUI target" analysis in §7.5:

1. **Push+mark on write, all frame** (writes during event handling mark nodes dirty and enqueue them
   — cheap, matches GPUI's existing effect queue).
2. **Height-ordered stabilization at the frame boundary** (drain the dirty set in height order once
   per frame, exactly like Incremental's `stabilize()` — guarantees glitch-freedom and bounds the
   work to exactly the dirty transitive closure, no more).
3. **Durability tiers layered on top** (Salsa-style) so that height-ordered stabilization doesn't
   even have to *visit* subgraphs rooted in durable inputs (theme, static layout constants) when only
   volatile inputs (this frame's mouse position, a keystroke) changed — this is what makes step 2
   cheap enough for 120fps on a UI with thousands of elements, rather than merely "correct."
4. **Demand-driven (pull) evaluation for genuinely offscreen/unobserved subtrees** — nodes with no
   active observer this frame (collapsed panel, virtualized-out list row) simply never enter the
   dirty-height-heap at all; observation status becomes another input to the durability/skip check,
   not a separate mechanism.

This is architecturally closest to Incr_dom, with Salsa's durability layered in and Adapton's naming
borrowed specifically for list-identity (§1.2) — not a novel algorithm, a specific, justified
composition.

### 8.2 Compile-time guarantees this literature suggests Rust could actually encode

1. **Linearity for leak-freedom** (Krishnaswami §2.2): use move-semantics / branded lifetimes so a
   signal handle from a previous frame cannot be read in the current frame — a `Frame<'a>` brand
   (à la GhostCell) turns "stale read" into `error[E0716]`, not a logic bug. Concretely realizable in
   Rust today with generative lifetime brands; no new type-theory needed.
2. **Move-consumed protocol states for interaction flows** (session types, §4.3): drag/focus/modal
   state machines where each step consumes and returns a new typed handle, exactly like
   `session_types`' channel protocol enforcement — directly portable, existing Rust crate design to
   copy.
3. **Typed dependency paths via lenses** (§7.6): a composed lens as the *unit* the tracking system
   indexes dependencies by, giving inspectable (not just executed) dependency paths — feasible with
   existing Rust lens-derive macros as a starting point.
4. **Durability/phase as a type-level tag** (§1.4, §7.4's Clash clock-domain typing): mark a
   `Signal<T, Durable>` vs `Signal<T, Volatile>` so that a computation only reading `Durable` inputs
   is *provably* skippable when a `Volatile`-only change occurs — the type system enforces what
   Salsa currently only enforces by convention/runtime bookkeeping. This is more speculative (would
   need trait-level durability arithmetic, e.g. `Combine<Durable, Volatile> = Volatile`) but is a
   genuinely novel-to-Rust idea, not present in any surveyed system as a *type-level* (vs. runtime)
   mechanism.
5. **Height as a const generic** (brief's own suggestion): plausible only for statically-shaped
   subtrees (a fixed-layout panel) — dynamically-shaped UI (conditional rendering, lists) makes
   height a runtime property by nature (this is exactly why Incremental needs an adjust-heights
   heap), so const-generic height is a narrow, not general-purpose, optimization: usable for
   hand-authored fixed chrome, not for arbitrary user content.

### 8.3 Five non-obvious stealable ideas, ranked by leverage-to-effort

1. **Salsa-style durability tiers, ported to a UI dependency graph.** Highest leverage: directly
   explains and fixes the exact failure mode GPUI has today (§0 — one dirty bit per window means a
   single keystroke re-renders everything in that window). Low conceptual novelty to implement
   (it's a revision *vector* instead of a revision *counter*, per §1.4) but requires threading
   durability tags through every state-producing API — moderate implementation effort, very high
   payoff, and it composes with whatever propagation core is chosen.
2. **bevy_reactor's "reactive graph = ECS components/resources" pattern.** GPUI's `Entity`/`SlotMap`
   model (§0) is already ECS-shaped; building fine-grained signals as components *within* that
   existing arena, rather than a bolt-on graph, is the smallest-delta path to fine-grained reactivity
   and has a working, if young, reference implementation to study line-by-line (§6.2). High leverage,
   low-to-moderate effort because the substrate already exists.
3. **Session-typed interaction protocols for drag/focus/modal flows (§4.3).** Narrow in scope (not a
   framework-wide rewrite) but a genuinely free compile-time win: copy `session_types`' move-
   semantics trick for GPUI's existing drag/focus state machines. Low effort (can be prototyped on
   one interaction type first), moderate-but-concentrated leverage (eliminates an entire class of
   "impossible state" bugs in exactly the code paths that are hardest to test, e.g. interrupted
   drags).
4. **Adapton-style names for list/collection identity, feeding an arrangement-like (differential-
   dataflow) list/table primitive (§1.2, §1.5).** Higher effort — this is close to a new data
   structure, not a policy change — but directly targets a known-hard problem (incremental,
   identity-stable collection diffing) that every framework surveyed here solves with heuristics
   (React `key`, Solid's `For`) rather than a principled mechanism; getting this right in GPUI's list/
   table widgets would be a genuine differentiator, not just parity.
5. **A `#[reactive]`/`#[derive(Element)]` proc-macro doing Svelte/React-Compiler-style static
   dependency-graph inference over field access (§3.1, §3.4), emitting durability-tagged (idea #1),
   height-ordered (Incremental-style) tracking code.** Highest effort of the five (a real static-
   analysis pass inside a proc-macro, with React Compiler's bail-out-on-uncertain-code discipline as
   the safety model) but the highest ceiling: it's the only idea on this list that changes the
   *authoring experience* (plain-looking struct/impl code compiles to a fine-grained reactive graph)
   rather than just the runtime's internals, which is the difference between "GPUI got faster" and
   "GPUI got a fundamentally more ergonomic and more verified programming model," matching the
   brief's stated goal directly.

---

## Source index (all links referenced above)

- Acar, *Self-Adjusting Computation* (thesis): https://www.cs.cmu.edu/~rwh/students/acar.pdf
- Acar et al., *An Experimental Analysis of Self-Adjusting Computation*: https://www.cs.cmu.edu/~guyb/papers/ABBT06.pdf
- Hammer et al., *Adapton: Composable, Demand-Driven Incremental Computation* (PLDI 2014): http://matthewhammer.org/adapton/adapton-pldi2014.pdf ; project page: http://matthewhammer.org/adapton/
- *Incremental Computation with Names*: https://www.researchgate.net/publication/274095005_Incremental_Computation_with_Names
- Jane Street, *Introducing Incremental*: https://blog.janestreet.com/introducing-incremental/
- Jane Street, *Self Adjusting DOM* (Incr_dom): https://blog.janestreet.com/self-adjusting-dom/
- janestreet/incremental (GitHub): https://github.com/janestreet/incremental
- lord/anchors (GitHub): https://github.com/lord/anchors ; crates.io: https://crates.io/crates/anchors/0.3.0
- Salsa, *The "red-green" algorithm*: https://salsa-rs.github.io/salsa/reference/algorithm.html
- Salsa overview: https://salsa-rs.github.io/salsa/overview.html
- rustc-dev-guide, *Salsa*: https://rustc-dev-guide.rust-lang.org/queries/salsa.html
- rust-analyzer blog, *Durable Incrementality*: https://rust-analyzer.github.io/blog/2023/07/24/durable-incrementality.html
- Differential dataflow (CIDR 2013): https://www.cidrdb.org/cidr2013/Papers/CIDR13_Paper111.pdf
- *Foundations of Differential Dataflow*: https://www.researchgate.net/publication/301971998_Foundations_of_Differential_Dataflow
- *Shared Arrangements* (VLDB 2020): http://www.vldb.org/pvldb/vol13/p1793-mcsherry.pdf ; https://dl.acm.org/doi/10.14778/3401960.3401974
- Materialize, *Arrangements*: https://materialize.com/docs/get-started/arrangements/
- *Recent Increments in Incremental View Maintenance*: https://arxiv.org/pdf/2404.17679
- Elliott & Hudak, Fran lineage: http://conal.net/papers/frp.html ; http://conal.net/papers/
- Elliott, *Push-Pull Functional Reactive Programming*: http://conal.net/papers/push-pull-frp/push-pull-frp.pdf
- Krishnaswami, *Higher-Order Functional Reactive Programming without Spacetime Leaks* (ICFP 2013): https://www.cl.cam.ac.uk/~nk480/simple-frp.pdf ; ACM: https://dl.acm.org/doi/10.1145/2500365.2500588
- Krishnaswami, Benton, Hoffmann, *Higher-order FRP in bounded space* (POPL 2012): https://dl.acm.org/doi/10.1145/2103621.2103665
- *Functional Reactive GUI Programming with Modal Types*: https://link.springer.com/content/pdf/10.1007/978-3-031-99751-8_5.pdf
- Bainomugisha et al., *A Survey on Reactive Programming*: https://dl.acm.org/doi/10.1145/2501654.2501666 ; summary: https://blog.acolyer.org/2015/12/08/a-survey-on-reactive-programming/
- Elm, *A Farewell to FRP*: https://elm-lang.org/news/farewell-to-frp
- Svelte 5 runes background: https://www.htmlallthethings.com/blog-posts/understanding-svelte-5-runes-derived-vs-effect ; https://codehints.io/svelte/runes/
- Vue Vapor mode: https://forkbyte.nl/en/blog/vue-36-vapor-mode-rc ; https://www.blueshoe.io/blog/vue-vapor-performance-without-virtual-dom/
- Qwik resumability: https://qwik.dev/docs/concepts/resumable/ ; https://www.builder.io/blog/resumability-vs-hydration
- React Compiler: https://www.debugbear.com/blog/react-compiler ; https://www.sitepoint.com/react-20-compiler-usememo-changes/
- SolidJS fine-grained reactivity: https://docs.solidjs.com/advanced-concepts/fine-grained-reactivity ; https://jser.dev/react/2023/02/26/reactivity-in-solidjs/
- statecharts.dev, *Statecharts in User Interfaces*: https://statecharts.dev/use-case-statecharts-in-user-interfaces.html
- XState (GitHub): https://github.com/statelyai/xstate
- `session_types` (crates.io): https://crates.io/crates/session_types
- Ferrite (arXiv 2205.06921): https://arxiv.org/abs/2205.06921 ; book: https://ferrite-rs.github.io/ferrite-book/
- Badros, Borning, Stuckey, *Cassowary* (ACM TOCHI 2001): https://dl.acm.org/doi/10.1145/504704.504705 ; docs: https://cassowary.readthedocs.io/en/latest/topics/theory.html
- Flutter Cassowary removal: https://github.com/flutter/flutter/issues/50309
- Meyerovich & Bodik, *Fast and Parallel Webpage Layout* (WWW 2010): https://lmeyerov.github.io/projects/pbrowser/pubfiles/paper.pdf
- Superconductor: https://datavis.cs.columbia.edu/files/papers/superconductor.pdf
- `tailwindcss-to-rust`: https://crates.io/crates/tailwindcss-to-rust/0.3.0 ; https://blog.urth.org/2022/02/21/checking-tailwind-class-names-at-compile-time-with-rust/
- `encre-css`: https://lib.rs/crates/encre-css
- Zed blog, *Leveraging Rust and the GPU...*: https://zed.dev/blog/videogame
- bevy_reactor (GitHub): https://github.com/viridia/bevy_reactor ; DeepWiki: https://deepwiki.com/viridia/bevy_reactor
- Quill (GitHub): https://github.com/viridia/quill ; quill_v1: https://github.com/viridia/quill_v1
- Bevy discussions: https://github.com/bevyengine/bevy/discussions/10212 ; https://github.com/bevyengine/bevy/discussions/10978
- Compose snapshot/MVCC: https://composeinternals.com/concurrency-control-in-jetpack-compose ; https://mukuljangra.com/guide/compose-snapshot-system/
- UUAGC: https://hackage.haskell.org/package/uuagc ; traversal fusion: https://arxiv.org/pdf/1904.07061 ; zipping strategies: https://arxiv.org/pdf/2110.07902
- Clash: https://clash-lang.org/
- Chisel: https://github.com/chipsalliance/chisel
- Mokhov, Mitchell, Peyton Jones, *Build Systems à la Carte* (ICFP 2018): https://www.microsoft.com/en-us/research/uploads/prod/2018/03/build-systems.pdf ; https://simon.peytonjones.org/build-systems-a-la-carte/
- `lens-rs` (GitHub): https://github.com/TOETOE55/lens-rs ; `optics`: https://docs.rs/optics ; `pl-lens`: https://docs.rs/pl-lens
- Druid `Lens`: https://docs.rs/druid/latest/druid/index.html
- Xilem: https://raphlinus.github.io/rust/gui/2022/05/07/ui-architecture.html ; https://github.com/linebender/xilem
- Leptos reactivity: https://book.leptos.dev/appendix_reactive_graph.html ; https://github.com/leptos-rs/leptos

GPUI source references (this repo): `crates/gpui/src/app/entity_map.rs:56-80`,
`crates/gpui/src/app.rs:1040-1160, 1699-1800, 2052-2120`, `crates/gpui/src/app/context.rs:229`.
