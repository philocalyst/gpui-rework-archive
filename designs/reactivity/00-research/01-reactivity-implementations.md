# Fine-Grained Reactivity in Rust: Source-Level Survey for GPUI

> Research snapshot. Descriptive findings remain useful, but recommendations are superseded by
> [06-competitive-update.md](06-competitive-update.md) and
> [../03-hybrid-plan.md](../03-hybrid-plan.md).

Research date: 2026-08-09. Code excerpts were read from shallow upstream clones at HEAD on that
date; paths below are repository-relative. Those temporary clones are not part of this repository,
so re-pin and re-check upstream before treating a line number as current. The follow-up audit pins
the projects it rechecked in [06-competitive-update.md](06-competitive-update.md).

---

## 0. Executive framing

Every framework surveyed decomposes into the same four subsystems, which is itself
the most important finding for a GPUI design:

1. **A handle type** — how you name a piece of state such that it is `Copy`,
   cheaply passed into closures, and doesn't fight the borrow checker.
2. **An ownership/arena system** — where the actual value lives, who frees it,
   and what happens when you read through a handle after it's gone.
3. **A dependency graph** — how "this computation read that signal" gets
   recorded, and how a write propagates to exactly the right recomputations
   without redundant work or missed updates (glitches).
4. **A scheduler** — when recorded-as-dirty work actually executes: synchronously
   inline, at a microtask, or at an explicit host-driven flush point (a frame).

GPUI is a *retained, native, single-threaded-per-window, frame-loop-driven* UI,
which makes **zgui** (an early, AI-assisted but architecturally serious framework
built by directly embedding Leptos's `reactive_graph` crate under a native
renderer) and **Floem** (a hand-rolled fine-grained engine driving Lapce, a real
shipped editor) the two most load-bearing precedents. Both are covered in the
most depth below.

---

## 1. zgui — native GPU-rendered UI built directly on `reactive_graph`

Repo: https://github.com/zortax/zgui (cloned depth 1; ~50+ crates, workspace of a
serious, if very-online "AI-sloppy" per its own README, framework).

### 1.1 What it is

From `docs/guide/reactivity.md` and `README.md`:

> "Zgui is a retained user interface framework for native Rust applications. It
> provides components, fine-grained reactive state, CSS styling, text layout,
> accessibility, and GPU rendering. It does not embed a browser and does not use
> HTML or JavaScript."

It is a from-scratch retained-mode pipeline (components → signals → view tree →
layout → paint → GPU, via `wgpu`/`vello`), styled with real CSS (cascade,
selectors, flexbox/grid), with a `view!` macro producing typed view trees, not a
VDOM. Component functions run **once**. The novelty isn't the reactive core — it
is explicitly *not* reinvented — the novelty is treating an off-the-shelf
web-reactivity engine as a native, frame-driven UI runtime, and building the
scaffolding (owner-per-node disposal, frame-synchronous flush, thread-safety
escapes, non-reactive zones) that doing so requires.

### 1.2 The reactivity model: `reactive_graph` wrapped, not reinvented

`crates/zgui-reactive/Cargo.toml`:

```toml
# L1 — contracts. Every dependency is inherited: `foo.workspace = true`.
#
# This is the only crate in the workspace permitted to name `reactive_graph`, `reactive_stores`,
# `any_spawner` or `send_wrapper`, so the reactive engine can be pinned, feature-checked and
# wrapped in exactly one place. `reactive_graph`'s `effects` feature is forced from the workspace
# manifest: without it every effect compiles, runs and silently never re-runs.
[dependencies]
any_spawner.workspace = true
futures.workspace = true
reactive_graph.workspace = true
reactive_stores.workspace = true
send_wrapper.workspace = true
```

`zgui-reactive` (4,350 LOC across `own/`, `executor/`, `context/`, `store/`,
`task/`, `zone/`, `reexport/`) is a **facade crate**: it re-exports (and
deliberately does *not* re-export some of) Leptos's `reactive_graph` primitives
— `RwSignal`, `ReadSignal`, `WriteSignal`, `Memo`, `RenderEffect`, `Store`,
`Selector`, `Trigger`, `ArenaItem`-backed values, `LocalStorage`/`SyncStorage` —
and layers a UI-appropriate lifecycle and scheduler on top. This is the single
most useful discovery of this research: **`reactive_graph` was designed
DOM-agnostically enough that a completely different, native, retained,
frame-loop UI could adopt it wholesale and only need to write the "glue"
described below.**

Design rule stated directly in `src/lib.rs`'s module doc: *"the underlying
reactive engine is named nowhere else in the workspace. That is deliberate: the
engine's version, its feature set and the handful of its APIs that are unsafe to
use in a UI are decided once, here."* — i.e., treat the reactive engine as a
vendored implementation detail behind your own crate's public surface, not as a
directly-exposed dependency. This is directly reusable advice for a GPUI
integration: don't let `reactive_graph` (or whatever engine is chosen) leak into
the public GPUI API; wrap it.

### 1.3 Owner-per-node disposal, synchronous and eager

`crates/zgui-reactive/src/own/mounted.rs`:

```rust
/// The reactive scope of one mounted node, disposed of synchronously when the node unmounts.
///
/// Everything a node creates while it is being built — signals, memos, contexts, stored values,
/// cleanups, child nodes — belongs to this owner. `unmount` disposes of all
/// of it at once, in one call, before it returns: child scopes first, then cleanups, then stored
/// values.
///
/// **Synchronously** is the load-bearing word. Letting the effects behind a node's bindings drop
/// their own scopes instead defers every cleanup by one executor poll, which means one frame in
/// which an unmounted node's cleanups have not run...
#[derive(Debug)]
#[must_use = "an unmounted scope frees nothing; store it and call `unmount` when the node goes away"]
pub struct Mounted {
    owner: Owner,
    membership: Option<Member>,
    disposed: bool,
}
```

`Mounted::new()` creates a child `Owner` (`reactive_graph::owner::Owner`) under
whatever owner is thread-local-current; `Mounted::with(build)` runs `build`
with this owner current (so every signal/effect/context created inside belongs
to this node); `unmount`/`Drop` calls `owner.cleanup()` which recursively
disposes children first, then runs cleanups in reverse-registration order, then
drops arena-stored values. One `Owner` per mounted UI node, matching component
lifetime 1:1 to reactive-scope lifetime — this is the standard fine-grained-UI
ownership pattern (same shape in Dioxus's per-`ScopeId` `Owner` and Sycamore's
per-node `Root` child scopes), but zgui's guide is unusually explicit about
*why* synchronous (not deferred-to-next-poll) disposal matters for a UI: a timer
firing into a disposed scope, or an observer reporting stale geometry, in the
one frame between "node removed from tree" and "owner actually cleaned up."

### 1.4 The frame-synchronous flush — the key scheduling precedent

`crates/zgui-reactive/src/executor/frame.rs` — signal writes **do not run
anything**; they mark observers dirty and wake tasks. All actual reactive work
happens inside one function, `flush()`, called once per frame by the host loop:

```rust
/// Runs every ready reactive task to a stall, and reports what the frame still owes.
///
/// This is the one place reactive work happens. Writing a signal marks its observers and wakes
/// their tasks; nothing runs until the frame loop calls this. Because the notification behind
/// each task holds one slot, a signal written a thousand times between two flushes costs one
/// re-run, not a thousand.
///
/// Bounded by the per-flush iteration budget, so two effects writing each other's sources cost
/// a logged error and a presented frame rather than a hang. Re-entrant calls — a flush from
/// inside an effect — do nothing and report nothing owed, rather than corrupting the pool.
pub fn flush() -> FlushOutcome {
    assert_ui_thread("flush");
    let started = FLUSH.with_borrow_mut(|state| { /* re-entrancy guard */ });
    if !started { return FlushOutcome::default(); }
    {
        let _running = Running; // clears the running flag even on panic
        crate::task::drain_ui_queue();
        context::enter(pool::poll);
    }
    // ... re-wake anything the budget deferred, report needs_another_frame
}
```

Effects are ordinary `Future`s in an `any_spawner`-driven task pool; `flush`
polls the pool to a stall. This gives natural coalescing (`RwSignal::set`
called 5 times between two frames triggers *one* rerun of a dependent effect,
not five) purely as a consequence of "signals wake a task; polling a woken task
runs it once, however many times it was marked ready" — no explicit batching
API required for the common case (Leptos's own default scheduling, described
in §2.6, needs an explicit `batch()` for the same effect; zgui gets it "for
free" because *nothing* runs until the frame calls `flush`, i.e., zgui is
*always* implicitly batched at frame granularity).

**A per-flush iteration budget guards against effect cycles that `reactive_graph`
itself does not detect** (`executor/budget.rs`):

```rust
/// How many times one task may be polled during a single flush.
pub(crate) const BUDGET: u32 = if cfg!(debug_assertions) { 32 } else { 8 };
```

A task exceeding the budget is set aside (its waker kept for next flush) and the
cycle is logged once via `tracing::error!`, rather than hanging the frame. This
is zgui's own addition on top of `reactive_graph` — Leptos's engine has no
built-in cycle breaker (see §2.7); a native UI that cannot afford to hang a
frame needs one, and a bounded per-generation poll counter is the mechanism
zgui chose.

### 1.5 The wake edge: routing off-thread readiness back into the event loop

`crates/zgui-reactive/src/executor/wake.rs` — the second scheduling precedent
worth stealing directly. A `Future`'s own waker just unparks the pool's thread,
which is useless when that thread is blocked in the platform's event loop, not
parked. So every effect-future is polled through a **composite waker**: waking
it (a) re-queues the task in the pool and (b) pings a `FrameWaker` trait object
that the platform backend implements to ask for a redraw:

```rust
pub trait FrameWaker: Send + Sync + 'static {
    /// Called from arbitrary threads. Must not block, must be idempotent.
    fn wake(&self);
}
```

Explicitly documented invariants: callable from any thread, non-blocking,
**idempotent** (a hundred wakes between frames costs one requested frame, not
a hundred). Wakes that occur *during* an in-progress flush are deliberately
**not** forwarded to `FrameWaker` — they're folded into
`FlushOutcome::needs_another_frame` so an effect writing a signal costs one
extra frame, not an immediate redraw request per write (`note_wake()` in
`frame.rs`: `if state.running { state.needs_another_frame = true; }`).
`TestWaker` is provided as a headless/`FrameWaker` implementation that just
counts wakes, used for both tests and (implicitly) any harness with no real
event loop.

This wake-edge design is the direct answer to "how does a signal write on a
background thread eventually cause GPUI to redraw a window" and is worth
importing near-verbatim.

### 1.6 The "reactive hole" view-integration pattern

`crates/zgui-view/src/view/reactive.rs` — this is the mechanism that turns "a
closure that reads a signal" into "a live, self-updating region of the view
tree," and it is implemented as a blanket trait impl over `FnMut() -> V`:

```rust
impl<F, V> View for F
where
    F: FnMut() -> V + 'static,
    V: IntoView,
{
    type State = ReactiveState<<V::Output as View>::State>;
    fn build(self, cx: &mut BuildCx<'_>) -> Self::State { ReactiveState::start(self, cx) }
    fn rebuild(self, state: &mut Self::State, cx: &mut BuildCx<'_>) { state.restart(self, cx); }
}
```

`ReactiveState::start` creates a child `Owner`, wraps a `RenderEffect::new`
(Leptos's synchronous-first-run effect — see §2.5) whose closure calls the
user's `source()` closure, builds/rebuilds the resulting view into a shared
`Hole<S>`, and stores both the effect handle and owner. Because it's a *render*
effect, the very first build happens synchronously inline (not deferred to the
first `flush`), so a parent's `.build()` call returns a genuinely-populated
child rather than an empty placeholder waiting for a poll. `Anchor::unmount`
drops the effect and calls `owner.cleanup()` synchronously — same rationale as
§1.3. The `view!` macro's whole "which parts are reactive" story reduces to:
*a plain value is written once; a closure is a `View` impl that self-updates.*
This is exactly the "closures are reactive, expressions are not" ergonomic
split every framework in this survey uses (`{move || count.get()}` vs
`{count.get()}`), and zgui's `docs/guide/reactivity.md` calls out that this is
their #1 documented footgun ("A missing `move ||`... Both compile. The first
never updates.") — worth flagging for a GPUI design since it's a silent bug,
not a compile error, in every framework surveyed except where a macro forces
the distinction syntactically (none do, fully).

### 1.7 The three `Send` escapes

`reactive_graph`'s default signal/context/cleanup bounds require `Send + Sync`
(so the *engine* is thread-safe), but the *view layer* (`Rc`-based node handles,
callbacks, backend handles, since they never leave the UI thread) is not. zgui
therefore exposes exactly three escape hatches, each generic over storage:

- `RwSignal::new_local` + `LocalStorage` — a signal whose value need not be `Send`;
  reading it off-thread panics with a message naming the thread (a *runtime*
  promise where the alternative engine offers a compile-time one via `SyncStorage`
  vs `LocalStorage` type parameter — see the storage-generic pattern in §2 and §3).
- `provide_local_context` / `use_local_context` for non-`Send` context values.
- `on_cleanup_local` for cleanup closures that capture `!Send` view handles.

And it explicitly un-re-exports four items whose failure mode is silent rather
than loud: unkeyed store indexing (re-runs every sibling + panics on stale
index on shrink), the engine's own `Effect` (whose thread-safe constructors run
off the UI thread — replaced by `RenderEffect`), the engine's own `on_cleanup`
(requires `Send + Sync`, replaced by `on_cleanup_local`), and the engine's
`nightly` feature (changes call syntax, would silently invalidate every doc
example on one build config). Plus a startup canary, `effects_are_enabled()`,
because a `reactive_graph` build compiled *without* its `effects` feature
compiles and runs fine and simply never re-runs anything — "a whole application
compiles, runs, and never updates."

### 1.8 Non-reactive zones and the "read outside tracking" diagnostic

`crates/zgui-reactive/src/zone.rs` wraps `reactive_graph::diagnostics::
SpecialNonReactiveZone` (§2.8): a thread-local flag suppressing the debug-mode
warning that fires when a signal is read with no current `Observer`. zgui's
frame loop enters this zone around every dispatched event-handler body, since
"read count.get() inside an onclick" is legitimate (should run once, at click
time, not become a dependency) and would otherwise be a false-positive flood.

### 1.9 Store: keyed fine-grained fields over structured state

`crates/zgui-reactive/src/store/keyed.rs` and the re-exported `Store`,
`StoreField`, `Subfield`, `KeyedSubfield`, `Patch`, `AtKeyed` types come
straight from `reactive_stores` (Leptos's companion crate — see §2.9). The
guide is emphatic that **unkeyed** collection indexing is a footgun deliberately
kept unpublished ("re-runs every sibling's observers, and panics on a stale
index when the collection shrinks") in favor of keyed access, which turns "which
of 1000 rows changed" into "one subscription per row, exactly the two that
changed." `Selector` (`reexport/selector.rs`) is called out for the same
purpose at the "is this the selected id" granularity, evicting stale
subscriptions automatically.

---

## 2. Leptos `reactive_graph` (0.7+) — the reference engine

Repo: https://github.com/leptos-rs/leptos, `reactive_graph/` (18,684 LOC).
This is the engine zgui wraps wholesale, so this section documents the actual
mechanism zgui (and by inheritance any GPUI design that reuses it) would run.

### 2.1 The core graph abstraction: push-dirty, pull-check-and-recompute

`reactive_graph/src/graph/node.rs` — every graph node (signal, memo, effect) is:

```rust
pub trait ReactiveNode {
    fn mark_dirty(&self);
    fn mark_check(&self);
    fn mark_subscribers_check(&self);
    fn update_if_necessary(&self) -> bool;
}

pub enum ReactiveNodeState {
    Clean, // none of its sources changed, or they did but its own value didn't
    Check, // may have changed, not yet known
    Dirty, // definitely changed
}
```

This is the classic **push-pull ("adaptive") algorithm**: a signal write calls
`mark_dirty()` on itself, which (i) sets its own state to `Dirty` and (ii) calls
`mark_check()` on every direct subscriber, which sets *their* state to `Check`
(unless already `Dirty`) and recursively propagates `mark_check` further up the
subscriber chain — this is the eager "push" phase, O(edges reachable), done
synchronously at write time, and it does no recomputation. Recomputation is
lazy and pull-driven: when something later asks a node "do you actually need to
update" (`update_if_necessary`), a `Check` node walks *its own* sources calling
`update_if_necessary` on each (recursively resolving the whole upstream `Check`
subgraph first) and only recomputes itself if a source actually turned out
`Dirty`. This is glitch-free because a diamond dependency (`A` feeds both `B`
and `C`, both feed `D`) marks `D` `Check` exactly once and `D`'s eventual pull
resolves both parents before deciding whether to recompute — no possibility of
`D` seeing `B`'s new value against `C`'s stale one, and no possibility of `D`
running twice for one write to `A`.

`reactive_graph/src/computed/inner.rs` (`MemoInner::update_if_necessary`) is the
concrete implementation of the pull side, and it doubles as the **equality-gated
memo**:

```rust
fn needs_update(reactivity: &RwLock<MemoInnerReactivity>) -> bool {
    let (state, sources) = { /* snapshot */ };
    match state {
        ReactiveNodeState::Clean => false,
        ReactiveNodeState::Dirty => true,
        ReactiveNodeState::Check => (&sources).into_iter().any(|source| {
            source.update_if_necessary()
                || reactivity.read().or_poisoned().state == ReactiveNodeState::Dirty
        }),
    }
}

if needs_update(&self.reactivity) {
    // ... clear old sources (they'll be re-collected during the recompute) ...
    let (new_value, changed) = self.owner.with_cleanup(|| {
        any_subscriber.with_observer(|| (self.fun)(value.map(StorageAccess::into_taken)))
    });
    // ... store new_value, set state = Clean ...
    if changed {
        for sub in subscribers {
            if !Observer::is(&sub) { sub.mark_dirty(); } // glitch-avoidance guard
        }
    }
}
```

`(self.fun)(Option<T>) -> (T, bool)` is user code plus an equality check baked
in by the `Memo` constructor (`PartialEq`), so a memo only propagates
`mark_dirty` to *its* subscribers if the recomputed value actually differs —
this is what lets a memo act as a firebreak that stops an update wave even
though its own sources changed. Note the `if !Observer::is(&sub)` guard: if the
subscriber currently recomputing *is* the one that triggered this recompute
(re-entrant case), it's skipped, since it doesn't need to be told twice that it
should rerun.

Sources/subscribers are stored as `IndexSet`s over type-erased handles
(`reactive_graph/src/graph/sets.rs`):

```rust
type FxIndexSet<T> = IndexSet<T, BuildHasherDefault<FxHasher>>;
pub struct SourceSet(FxIndexSet<AnySource>);
pub struct SubscriberSet(FxIndexSet<AnySubscriber>);
```

Comment justifies the choice: "the M:N relationship between sources and
subscribers usually consists of fairly small numbers, such that the cost of a
linear search is not significantly more expensive than a hash and lookup," and
explicitly uses `shift_remove` (not `swap_remove`) on unsubscribe to preserve
insertion order — load-bearing for correctness with nested effects where an
outer effect assumes it already ran before an inner one (order-dependent
UI-tree semantics, exactly GPUI's parent-before-child concern).

**Dynamic dependencies** fall out naturally: `graph/subscriber.rs`'s
`observer_clean_up`-equivalent (each effect/memo clears its own `SourceSet` and
removes itself from every one of those sources' `SubscriberSet`s at the start
of *every* re-run, before re-executing the closure) — so an `if`/`match` inside
a tracked closure that reads different signals on different runs correctly
re-subscribes to exactly this run's set, dropping subscriptions to branches not
taken this time. (Leptos does *not* do a topological-DFS style edge
recomputation like Sycamore; it's "clear all my sources, then re-read.")

### 2.2 The observer stack: how tracking gets recorded

`reactive_graph/src/graph/subscriber.rs`:

```rust
thread_local! {
    static OBSERVER: RefCell<Option<ObserverState>> = const { RefCell::new(None) };
}
struct ObserverState { subscriber: AnySubscriber, untracked: bool }

pub struct Observer;
impl Observer {
    pub fn get() -> Option<AnySubscriber> { /* current, unless untracked flag set */ }
    fn replace(observer: Option<AnySubscriber>) -> SetObserverOnDrop { /* RAII swap */ }
}

#[track_caller]
pub fn untrack<T>(fun: impl FnOnce() -> T) -> T {
    let _prev = Observer::take();
    fun()
}
```

Not a *stack* data structure per se — a single thread-local `Option`, swapped
via an RAII guard (`SetObserverOnDrop`) that restores the previous value on
drop, which nests correctly because Rust's call stack *is* the stack: entering
a nested effect swaps the thread-local, running its closure, and returning
restores the parent's observer automatically via `Drop`. Every signal `read()`
calls `Observer::get()`; if `Some`, it calls `add_subscriber`/`add_source` on
both ends of that edge. `untrack(...)` is literally "swap in `None`, run,
restore." This thread-local-swap-plus-RAII-guard is the single most portable
idea in the whole survey — it requires no allocation, composes with panics
(guard still runs), and works identically whether the "current observer" is an
effect, a memo being recomputed, or (per zgui) a `RenderEffect` driving a UI
node.

### 2.3 Handle representation: `Arc<RwLock<...>>` (`Arc*` types) vs arena `Copy` handles

Two parallel handle families, both wrapping the same `ReactiveNode` machinery:

- **`ArcRwSignal<T>` / `ArcReadSignal<T>` / `ArcMemo<T>`** (`signal/arc_rw.rs`
  etc.): plain `Arc<RwLock<T>>`-style reference-counted handles — `Clone`, not
  `Copy`, live exactly as long as a reference is held, freed by normal Rust
  drop/refcounting, no arena, no owner tree involved.
- **`RwSignal<T, S>` / `Memo<T, S>` / `RenderEffect` internals** (`signal/rw.rs`):
  a thin wrapper around `ArenaItem<ArcRwSignal<T>, S>` — i.e., the arena stores
  the `Arc`-based handle, and the `Copy` handle is really "an index into a
  slotmap that dereferences to an `Arc`." `RwSignal` itself:

```rust
pub struct RwSignal<T, S = SyncStorage> {
    #[cfg(any(debug_assertions, leptos_debuginfo))]
    defined_at: &'static Location<'static>,
    inner: ArenaItem<ArcRwSignal<T>, S>,
}
```

`ArenaItem<T, S>` (`owner/arena_item.rs`) is the generic "arena-allocated `Copy`
handle" primitive underlying all of `RwSignal`/`Memo`/`Signal`/`StoredValue`:

```rust
pub struct ArenaItem<T, S = SyncStorage> { node: NodeId, ty: PhantomData<fn() -> (SendWrapper<T>, S)> }
impl<T, S> Copy for ArenaItem<T, S> {}
impl<T, S> Clone for ArenaItem<T, S> { fn clone(&self) -> Self { *self } }
```

`Copy` is achieved the standard way: the handle is `(NodeId, PhantomData)` —
just a `slotmap::new_key_type!`'d index plus zero-sized type info, nothing
borrowed, nothing reference-counted in the handle itself; all the real
reference-counting lives inside the arena slot.

### 2.4 The arena: global-by-default, sandboxable

`reactive_graph/src/owner/arena.rs`:

```rust
new_key_type! { pub struct NodeId; }
pub type ArenaMap = SlotMap<NodeId, Box<dyn Any + Send + Sync>>;
#[cfg(not(feature = "sandboxed-arenas"))]
static MAP: OnceLock<RwLock<ArenaMap>> = OnceLock::new();
```

Default build: **one process-global `SlotMap` behind one `RwLock`**, accessed
via `Arena::with`/`with_mut` (read/write lock the whole map for the duration of
the closure). `ArenaItem::new_with_storage` inserts, then walks the
thread-local current `Owner` and calls `owner.register(node)` so the owner's
cleanup can later `Arena::with_mut(|arena| arena.remove(node))` it. Optional
`sandboxed-arenas` feature swaps the global `OnceLock` for a thread-local
`Weak<RwLock<ArenaMap>>` so, e.g., a server handling concurrent requests can
give each request its own arena with stable `NodeId`s that don't collide —
irrelevant to GPUI's single-process desktop case but notable as "the arena
itself is swappable," i.e., not baked into the handle type.

**Note the concurrency-control implication for GPUI**: every `RwSignal` read or
write in this design takes the *global* arena `RwLock` (briefly, to resolve the
`NodeId` → `Arc<RwLock<T>>`) plus the *per-signal* `RwLock` (to actually read
the value) — two lock acquisitions per read/write, one of which is contended
across the entire process. This is a real cost center for a UI-thread-only
design and a place where a GPUI-specific implementation could strictly improve
on Leptos by using a `RefCell`-based single-threaded arena (no atomics/locks at
all when there is only ever one UI thread), the way Sycamore does (§4) and the
way zgui's own `Owner`/arena calls still pay for despite being single-threaded
in practice (because they took the `Send+Sync`-by-default engine as-is).

### 2.5 Effects: `Effect` (async-scheduled) vs `RenderEffect` (sync-first, handle-owned)

`reactive_graph/src/effect/render_effect.rs`:

```rust
/// 1. Its first run takes place immediately and synchronously... (Hence "render effect.")
/// 2. It is canceled when the `RenderEffect` itself is dropped, rather than being stored in the
///    reactive system and canceled when the `Owner` cleans up.
#[must_use = "A RenderEffect will be canceled when it is dropped..."]
pub struct RenderEffect<T> { value: Arc<RwLock<Option<T>>>, inner: Arc<RwLock<EffectInner>> }
impl<T> RenderEffect<T> {
    pub fn new(fun: impl FnMut(Option<T>) -> T + 'static) -> Self { /* runs fun once, now */ }
}
```

The ordinary `Effect` (not `RenderEffect`) is scheduled onto whatever
`any_spawner::Executor` is installed (wasm: `queueMicrotask`; native: whatever
async runtime is configured) and its *first* run is deferred to that executor
too — hence zgui deliberately un-re-exports plain `Effect` ("its thread-safe
constructors run effects off the UI thread") in favor of `RenderEffect`, whose
lifetime is tied to the handle (drop the handle, the effect stops — not "stops
when some owner elsewhere is disposed"), and whose first run is synchronous so
a UI `build()` call can return fully-populated content rather than a promise of
future content. This Effect/RenderEffect split — "cheap, owner-scoped,
async-first" vs "handle-scoped, sync-first, UI-appropriate" — is a distinction
a GPUI design will want to make explicitly rather than offer one generic
`Effect` type.

### 2.6 Batching and scheduling

Leptos 0.7's default: a signal write immediately updates the stored value and
immediately calls `mark_dirty()` (the graph-marking push phase is *not*
deferred), but the actual re-running of `Effect`s is deferred to the installed
async executor's next microtask/tick — so within one synchronous function that
sets five signals, effects run once, after that function returns control to the
executor, *unless* the effects are `RenderEffect`s reading a memo whose
`update_if_necessary` gets pulled synchronously by something else in the
meantime. An explicit `batch(|| { ... })` exists to force multiple writes to
resolve as one unit even across executor boundaries. Per web search, this was
enough of a footgun in practice that "finding `batch()` as the solution... was
not obvious, resulting in more than a handful of bug reports" (community
discussion). **zgui sidesteps this entirely** by using `RenderEffect`
exclusively and deferring literally everything (including first non-initial
runs) to its own explicit `flush()`, so the "microtask timing is
surprising" footgun does not apply to it — a strong argument that a
GPUI-facing wrapper should hide the underlying engine's own scheduler
entirely and substitute a single frame-flush point, exactly as zgui did.

### 2.7 Known footguns (from GitHub issues/discussions)

- **"tried to access a reactive value... but it has already been disposed"** —
  the single most common Leptos reactivity panic. Root cause across the
  reported issues (#2842, #3243, #3627, #3681) is consistently *reading an
  arena-`Copy` handle after its owning `Owner` has been torn down* — e.g. a
  `Resource`/`Suspense` component whose owner scope was disposed while an async
  task that captured one of its signals was still in flight, or a signal
  created inside a nested `Store`/`RwSignal` combination read from a
  background executor thread after the page/route that created it navigated
  away. This is the direct, real-world cost of the "arena handle, `Copy`,
  disposed-out-from-under-you" design (§2.3-2.4): the type system does not
  prevent using a stale handle; only a runtime check (a `try_with`-style
  `Option`/`Result`, or a hard panic on the infallible `.get()`) catches it,
  and by default Leptos's convenience methods (`.get()`) panic rather than
  return `Option`.
- **No built-in cycle detection.** `update_if_necessary`'s recursive pull has no
  visited-set / depth guard; two effects that each write the other's source in
  their body will recurse or ping-pong indefinitely unless something external
  bounds it. (zgui's `BUDGET`-based per-flush poll cap, §1.4, is exactly the
  missing piece added back in for a native UI's sake; Sycamore instead detects
  this at the graph level with an eager DFS mark, §4, and panics synchronously
  with "cyclic reactive dependency"— a strictly better failure mode for a UI
  framework: fail loud immediately rather than silently degrade to a bounded
  number of extra reruns.)
- **Batching timing surprises** (§2.6) — effects not running "now" the way a
  first-time user expects from a synchronous mental model.
- **`nightly` feature changes call syntax** (`count()` vs `count.get()`) well
  enough that, per zgui's own guide, "every example in this documentation
  [would be] wrong on one build and right on another" if it accidentally leaked
  into a downstream crate's feature unification — a real hazard of Cargo
  feature unification across a workspace that any GPUI vendoring plan needs to
  guard against explicitly (zgui's answer: don't re-export it, don't let any
  crate in the workspace enable it).

### 2.8 `#[track_caller]` / `DefinedAt` diagnostics

Every constructor (`RwSignal::new`, `Memo::new`, etc.) is `#[track_caller]` and
stashes `Location::caller()` behind `#[cfg(any(debug_assertions,
leptos_debuginfo))]` — zero-cost in release, and used both for panic messages
("you tried to access a reactive value... defined at src/foo.rs:12") and for
`AnySource`'s own `Debug` impl (`graph/source.rs`, same conditional-compiled
`Location` field). `diagnostics.rs`'s `SpecialNonReactiveZone` (§1.8) is the
opt-out mechanism for the complementary debug-only warning: reading a signal
with no `Observer` present. Both diagnostics compile to nothing in release
builds — this pattern (all diagnostics behind a debug/feature cfg, sharing one
`#[track_caller]`-captured `Location`) is directly reusable and cheap.

### 2.9 Guards: `ReadGuard`, `WriteGuard`, and the borrow-panic surface

`reactive_graph/src/signal/guards.rs` — a full family of `Deref`/`DerefMut`
wrapper guards (`Plain` wraps `ArcRwLockReadGuardian`, `Mapped`/`MappedArc` for
`.with()`-style field projection without cloning, `WriteGuard<S, G>` which wraps
an inner mutable guard **and calls `S::notify()` on `Drop`** — i.e., the
"notify subscribers" side effect of a write is deferred to guard-drop time, not
to the write call itself, which is what makes `.update(|v| ...)` and
`signal.write().push(x)` equivalent). `UntrackableGuard::untrack()` lets a
write guard opt out of notifying (`self.triggerable.take()`) mid-flight.
Because the underlying storage is `Arc<RwLock<T>>`, taking a guard can block
(same-thread double-borrow after a panicking previous guard was leaked, or
genuine cross-thread contention) rather than being a *guaranteed* panic the way
a `RefCell`'s `borrow_mut` on top of an already-outstanding borrow *would* be
on a single thread — the code comment in `MemoInner::update_if_necessary` flags
this explicitly: `"Safety: Can block endlessly if the user has a ReadGuard on
the value"`. **This is a materially different borrow-safety story than a
single-threaded `RefCell`-arena design (Dioxus/Sycamore): `RwLock` converts a
same-thread double-borrow into a deadlock, not a panic**, which is strictly
worse for debuggability in a UI context where nothing should ever legitimately
block. A GPUI-native design on a `RefCell` (single-threaded, "double borrow
panics loudly, immediately, with a backtrace to both borrow sites if tracked")
is preferable purely on these grounds, independent of any threading concerns.

### 2.10 Trait decomposition (from `traits.rs`)

The full read/write trait surface, all bounded by `DefinedAt` (for the
diagnostics above):

```
Track, ReadUntracked, Read, UntrackableGuard, Write, WithUntracked, With,
GetUntracked, Get, Notify, UpdateUntracked, Update, Set, ToStream, FromStream,
IsDisposed, IntoInner, DefinedAt, ReadValue, WithValue, GetValue, WriteValue,
UpdateValue, SetValue
```

i.e., "clone the value" (`Get`/`GetUntracked`), "borrow it via a guard/closure"
(`Read`/`With` + their `Untracked` twins), "replace it" (`Set`), "mutate it via
closure" (`Update`), "mutate it via guard" (`Write`), each independently
trackable or not, each independently generic over the concrete signal type via
blanket impls — this is exactly the trait-object-free "generic over anything
readable as a T" story zgui's guide cites ("Reading and writing are **trait**
methods, not inherent ones, so a component can accept 'anything readable as a
`T`' without caring whether it was handed a signal, a memo, a store field or a
constant.") A GPUI equivalent should adopt the same *decomposition granularity*
— separate traits for tracked-clone vs tracked-borrow vs untracked-anything —
rather than one monolithic `Signal` trait, precisely so "anything Read-able"
can be a function parameter bound without forcing callers into one concrete
signal type.

---

## 3. Dioxus `generational-box` + `dioxus-signals`

Repo: https://github.com/DioxusLabs/dioxus, `packages/generational-box/` and
`packages/signals/`.

### 3.1 `generational-box`: leaked-static-slot generational arena, not a central `SlotMap`

This is architecturally distinct from Leptos's single central `SlotMap` (§2.4).
`packages/generational-box/src/unsync.rs`:

```rust
thread_local! {
    static UNSYNC_RUNTIME: RefCell<Vec<&'static UnsyncStorage>> = const { RefCell::new(Vec::new()) };
}
pub struct UnsyncStorage {
    borrow_info: MemoryLocationBorrowInfo,
    data: RefCell<StorageEntry<RefCellStorageEntryData>>,
}
fn create_new(value: ..., caller: ...) -> GenerationalPointer<Self> {
    UNSYNC_RUNTIME.with(|runtime| match runtime.borrow_mut().pop() {
        Some(storage) => { /* reuse a freed slot: bump its generation, overwrite its value */ }
        None => {
            let storage: &'static Self = &*Box::leak(Box::new(Self { .. }));
            GenerationalPointer { storage, location: GenerationalLocation { generation: NonZeroU64::MIN, .. } }
        }
    })
}
```

Each storage cell is individually `Box::leak`'d to `&'static` (never actually
freed for the life of the process) and put on a **free list**
(`UNSYNC_RUNTIME`) when its generational-box is dropped; a later allocation
pops a free cell off the list, bumps `generation` by one, and overwrites its
data — so a **stale handle referencing the old generation of a recycled cell
fails a generation check on next access rather than reading garbage or another
live value's data** (`GenerationalBox<T,S>` is `(&'static Storage, {generation,
location})`; validity = `storage.generation == pointer.generation`). This is
the generational-arena pattern (same idea as `slotmap`, `generational-arena`
crates) applied per-cell instead of via one shared `Vec`/`SlotMap` — the
practical upshot vs. Leptos's design: **no single global lock/borrow to
contend on across unrelated signals** — each `GenerationalBox` only ever
touches its own cell's `RefCell` (`UnsyncStorage`, single-threaded) or its own
`RwLock` (`SyncStorage`). This is a meaningfully better concurrency/contention
story than Leptos's "one global arena `RwLock` + one per-signal `RwLock`" for a
UI with many independent signals, at the cost of leaking storage cells for the
life of the process (bounded by the high-water mark of concurrently-live
signals, since cells are reused, not actually freed).

`GenerationalBox<T, S>::try_read`/`try_write` return `Result<Guard,
BorrowError/BorrowMutError>` — **fallible by construction**, not
infallible-then-documented-to-panic; `.read()`/`.write()` are thin
`.unwrap()` wrappers for ergonomics. `BorrowError` explicitly distinguishes
"already borrowed" (would-be `RefCell` panic, turned into a `Result`) from
"dropped" (stale generation) — a strictly more granular error surface than
Leptos's single panic message.

### 3.2 `Signal<T, S>`: `ReactiveContext`-subscribed, not per-effect-edge

`packages/signals/src/signal.rs`:

```rust
pub struct Signal<T, S: 'static = UnsyncStorage> { pub(crate) inner: CopyValue<SignalData<T>, S> }
pub struct SignalData<T> {
    pub(crate) subscribers: Arc<Mutex<HashSet<ReactiveContext>>>,
    pub(crate) value: T,
}
```

`packages/core/src/reactive_context.rs` — the important architectural
divergence from Leptos/Sycamore/Floem: **the thing a signal subscribes is a
`ReactiveContext`, which by default *is* a component's `ScopeId`'s own
re-render trigger**, not a fine-grained per-effect node:

```rust
pub(crate) fn new_for_scope(scope: &Scope, runtime: &Runtime) -> Self {
    let id = scope.id;
    let sender = runtime.sender.clone();
    let update_scope = move || { let _ = sender.unbounded_send(SchedulerMsg::Immediate(id)); };
    let inner = Inner { update: Box::new(update_scope), .. };
    Self { scope: id, inner: owner.insert(inner) }
}
```

Reading a signal inside a component body subscribes that component's whole
`ScopeId` to it, so by default Dioxus signals give you **component-level
granularity** (re-run the whole component function), i.e. much closer to
React's re-render model than to Leptos's per-expression fine granularity —
finer granularity requires explicitly reaching for `use_memo`/`ReactiveContext::
new()` to create a sub-component-scoped tracking boundary. This is a real
comparative data point: "Copy, generational-arena-backed handles" and
"fine-grained (sub-component) dependency tracking" are *orthogonal* design
axes — Dioxus has the former without defaulting to the latter, whereas
Leptos/Sycamore/Floem have both. A GPUI design should be explicit about which
of these two axes it's committing to; conflating "uses arena handles" with
"is fine-grained" is a category error this comparison makes visible.

### 3.3 Ownership/scope tie-in

`CopyValue<T, S>` (`packages/signals/src/copy_value.rs`) stores an
`origin_scope: ScopeId`; `Signal::new` stores into the *current* component
scope's owner by default (`Signal::new_in_scope` to override), and the value is
dropped when that scope (component instance) is torn down — same "owner ==
component lifetime" shape as zgui's `Mounted`/Leptos's `Owner`, just backed by
`generational-box` recycling instead of `SlotMap` removal.

---

## 4. Sycamore 0.9 — unified-node slotmap arena, eager topological-DFS propagation

Repo: https://github.com/sycamore-rs/sycamore, `packages/sycamore-reactive/`.

### 4.1 One node type for everything, one arena per `Root`

`packages/sycamore-reactive/src/node.rs`:

```rust
new_key_type! { pub(crate) struct NodeId; }
pub(crate) struct ReactiveNode {
    pub value: Option<Box<dyn Any>>,
    pub callback: Option<Box<dyn FnMut(&mut Box<dyn Any>) -> bool>>, // returns "changed?"
    pub children: Vec<NodeId>,   // owned children (disposal tree)
    pub parent: NodeId,
    pub dependents: Vec<NodeId>,   // subscribers
    pub dependencies: SmallVec<[NodeId; 1]>, // sources
    pub cleanups: Vec<Box<dyn FnOnce()>>,
    pub context: Vec<Box<dyn Any>>,
    pub state: NodeState,          // Clean | Dirty  (two states, not three)
    pub mark: Mark,                // Temp | Permanent | None — DFS coloring
}
#[derive(Clone, Copy)] pub struct NodeHandle(pub(crate) NodeId, pub(crate) &'static Root);
```

Signals, memos, and effects are all the *same* `ReactiveNode` struct
differentiated only by whether `callback` is `Some` — a much simpler type
lattice than Leptos's separate `SignalInner`/`MemoInner`/`EffectInner` structs
with parallel trait impls. `NodeHandle` is `(NodeId, &'static Root)` — a
`Copy` handle exactly like `ArenaItem`, but explicitly pointing at *which*
`Root` (arena) it belongs to rather than a single process-global one, so
nested/independent reactive scopes (`create_root`) are first-class rather than
a feature flag (`sandboxed-arenas`) away.

### 4.2 Eager topological-sort propagation with synchronous cycle panic

`packages/sycamore-reactive/src/root.rs` — this is a materially different
algorithm from Leptos's lazy push-dirty/pull-check (§2.1):

```rust
/// If there are no cyclic dependencies, then the reactive graph is a DAG. We can therefore use
/// DFS to get a topological sorting of all the reactive nodes. We then go through every node in
/// this topological sorting and update only those nodes which have dependencies that were updated.
fn propagate_node_updates(&'static self, start_nodes: &[NodeId]) {
    let mut rev_sorted = /* reused buffer */;
    for &node in start_nodes {
        Self::dfs(node, &mut self.nodes.borrow_mut(), rev_sorted);
        self.mark_dependents_dirty(node);
    }
    for &node in rev_sorted.iter().rev() {
        // reset DFS mark; if state == Dirty, run_node_update(node)
    }
}
fn dfs(current_id: NodeId, nodes: &mut SlotMap<NodeId, ReactiveNode>, buf: &mut Vec<NodeId>) {
    match nodes[current_id].mark {
        Mark::Temp => panic!("cyclic reactive dependency"),
        Mark::Permanent => return,
        Mark::None => {}
    }
    nodes[current_id].mark = Mark::Temp;
    for child in std::mem::take(&mut nodes[current_id].dependents) { Self::dfs(child, nodes, buf); }
    nodes[current_id].mark = Mark::Permanent;
    buf.push(current_id);
}
```

On every write, Sycamore does a **full DFS from the written node over its
transitive dependents right now**, producing a topological order, then walks
that order in reverse (sources before dependents) running `run_node_update`
only on nodes actually marked `Dirty`. This is eager, synchronous,
whole-subgraph-at-write-time work (vs. Leptos's O(1)-ish push + later lazy
pull), and it gets **glitch-freedom via topological ordering** rather than via
a three-state Clean/Check/Dirty pull negotiation. The `Mark` enum is exactly
the textbook DFS three-color cycle detector (white/gray/black ≈
None/Temp/Permanent): hitting a node already marked `Temp` (currently on the
DFS stack, i.e., an ancestor of itself) means a real cycle, and Sycamore
**panics synchronously and immediately at the write that closes the cycle**,
by name ("cyclic reactive dependency") — a strictly more debuggable failure
mode than Leptos's silent infinite-recursion-until-something-else-bounds-it
(§2.7), and a decision GPUI's own graph should replicate: **detect cycles
eagerly and panic with a clear message, don't rely on an external iteration
budget as the only backstop.**

Batching (`start_batch`/`propagate_updates`) just defers the same
`propagate_node_updates` call: writes during a batch push onto
`node_update_queue`; the outermost batch's end runs one
`propagate_node_updates` over the whole accumulated set instead of one per
write — so batching in Sycamore is "coalesce the *set of dirty roots*, then
run one DFS," not "coalesce guard-drop notifications" (Leptos) or "poll the
task pool to a stall" (zgui/Floem).

---

## 5. Floem `floem-reactive` — hand-rolled engine driving a real editor (Lapce)

Repo: https://github.com/lapce/floem, crate `reactive/` (`floem_reactive` in
`Cargo.toml`, *not* a Leptos dependency — floem wrote its own, inspired by
early Leptos/Sycamore but independently implemented). This is the **existing
precedent closest to "fine-grained signals driving a native retained widget
tree,"** and per its own docs, powers the Lapce code editor in production.

### 5.1 No lazy pull, no topological sort — push-only, always-rerun effects

`reactive/src/effect.rs` — an `Effect<T, F>` just wraps `F: Fn(Option<T>) -> T`
plus a `RefCell<Option<T>>` for the previous value and a `RefCell<HashSet<Id>>`
of the signals it currently observes:

```rust
pub trait EffectTrait: Any {
    fn id(&self) -> Id;
    fn run(&self) -> bool;
    fn add_observer(&self, id: Id);
    fn clear_observers(&self) -> HashSet<Id>;
}
pub(crate) fn observer_clean_up(effect: &Rc<dyn EffectTrait>) {
    let observers = effect.clear_observers();
    for observer in observers {
        if let Some(signal) = observer.signal() { signal.subscribers.lock().remove(&effect_id); }
    }
}
pub(crate) fn run_effect(effect: Rc<dyn EffectTrait>) {
    effect_id.dispose_children();
    observer_clean_up(&effect);  // drop last run's subscriptions before re-tracking
    /* set as current_effect, run inside its own child Scope, unset */
}
```

There is **no `Clean`/`Check`/`Dirty` state machine and no equality gating at
the effect level** (a plain `Effect` always re-runs its full body when notified
— unlike Leptos's `Memo`, there's no built-in "did the value actually change"
short-circuit unless the user writes one). This is simpler to implement and
reason about than Leptos's push-pull machinery, at the cost of doing
strictly more recomputation on average (every effect that read a dirty signal
reruns fully, with no lazy short-circuiting of intermediate memos — though
Floem does have its own `Memo` type, `reactive/src/memo.rs`, layered on top for
the cases that need it).

### 5.2 Scheduling: a `Runtime`-owned pending queue, drained once per host tick

`reactive/src/runtime.rs`:

```rust
pub(crate) fn add_pending_effect(&self, effect_id: Id) {
    let mut set = self.pending_effects_set.borrow_mut();
    if set.insert(effect_id) { self.pending_effects.borrow_mut().push(effect_id); } // de-dup
}
pub(crate) fn run_pending_effects(&self) {
    loop {
        let mut pending_effects = self.pending_effects.take();
        if pending_effects.is_empty() { break; }
        pending_effects.sort_by_key(|id| { /* EffectPriority::High before Normal */ });
        for effect_id in pending_effects { /* run_effect(effect) */ }
    }
}
pub fn drain_pending_work() {
    let pending_effects = SYNC_RUNTIME.take_pending_effects();  // cross-thread writes
    let pending_disposals = SYNC_RUNTIME.take_pending_disposals();
    RUNTIME.with(|runtime| {
        for id in pending_effects { runtime.add_pending_effect(id); }
        for id in pending_disposals { id.dispose(); }
        runtime.run_pending_effects();
    });
}
```

`Effect::batch(f)` sets a `batching` flag so writes during `f` only *enqueue*
(via `add_pending_effect`) rather than immediately draining; the outermost
batch's end calls `run_pending_effects()`. Outside a batch, a write can
trigger `run_pending_effects` essentially inline/eagerly — **Floem's default
timing is closer to "synchronous propagation" than Leptos's
microtask-deferred default**, and pending effects have an explicit two-level
**priority** (`EffectPriority::High`/`Normal`, sorted before running) — a
scheduling knob none of Leptos/Sycamore/Dioxus expose, presumably added
because in a real editor UI some updates (layout-affecting) need to happen
before others (cosmetic) within the same batch.

`src/app/handle.rs:235` calls `Runtime::drain_pending_work()` — this is
Floem's equivalent of zgui's `flush()`/reactive_graph's executor poll, called
from the windowing event-loop handler once per relevant event, and
`SYNC_RUNTIME` (`reactive/src/sync_runtime.rs`) plus `Runtime::
set_sync_effect_waker` is Floem's equivalent of zgui's `FrameWaker` — a
cross-thread signal write (`SyncSignal`, backed by `Storage: Sync`) queues into
a global sync-safe queue and pings an installed waker closure so the UI thread
wakes up and calls `drain_pending_work`.

### 5.3 View integration: hand-written per-widget effects, not a generic `View for FnMut`

Unlike zgui's generic `impl<F: FnMut() -> V> View for F` (§1.6), Floem's
widgets each manually wire an `Effect::new`/`UpdaterEffect::new` where needed:
`src/views/dyn_view.rs` and `src/views/container.rs` use `UpdaterEffect::new`
to swap out an entire child view when a signal-computed `View`-producing
closure's result changes (the `dyn_view()`/reactive-child pattern — closest
Floem analogue to zgui's reactive hole, but written once per such
widget rather than derived generically from a blanket trait impl); individual
style properties are bound with per-property `Effect::new` calls in
`src/views/decorator.rs` (e.g. `.style(...)`, `.disabled(...)` each get their
own effect); text content in `src/views/label.rs` is driven by a
`prop_extractor!`-generated `LabelProps` struct (`color`, `text_overflow`,
`line_height`, ...) which is Floem's mechanism for turning a whole *style*
(cascaded, potentially large) into a small, `PartialEq`-diffable struct that's
recomputed and compared once per style-effect run rather than subscribing
individually to every property — i.e., Floem's answer to "avoid N micro-effects
per widget" is a hand-written aggregate-and-diff struct, not one-signal-per-CSS-
property. **Granularity in Floem is per-widget-property (a handful of effects
per visible widget), not per-DOM-text-node the way SolidJS/Leptos-in-the-DOM
would be** — a directly relevant data point for how fine "fine-grained" should
actually go in a native, batched-paint UI: too fine (subscribe every glyph)
is wasted bookkeeping when the actual paint step is already batched per frame.

### 5.4 `RwSignal` and thread safety

Floem's `RwSignal<T>` (there is both an unsync default and a `SyncSignal<T>`
alias with `Storage: Sync`) plus `Runtime::assert_ui_thread()` /
`Runtime::init_on_ui_thread()` (checked via a `OnceLock<ThreadId>` +
`AtomicBool` enable-flag, `#[track_caller]`-annotated panic messages naming
both the expected and actual thread and where the UI thread was first set) —
functionally identical in spirit to zgui's `assert_ui_thread`, independently
reinvented, which is a strong signal this exact guard is close to mandatory
for any native-UI reactive engine and should be included from day one in a
GPUI design, not bolted on later.

---

## 6. Silkenweb — fine-grained DOM without a VDOM, built on `futures-signals`

Repo: https://github.com/silkenweb/silkenweb (`packages/silkenweb/`). Confirmed
via `Cargo.toml` (`futures-signals = { workspace = true }`) and its own
`lib.rs` doc comment: *"Fine grained reactivity using `futures_signals`."*
Silkenweb contributes no independent reactive engine of its own — it's a DOM
adapter over Pauan's `futures-signals` (§7), demonstrating that the Stream-based
model (below) is sufficient to drive fine-grained real-DOM node updates,
same category of proof-of-precedent as Floem is for a native retained tree,
just for the DOM case and with a different (Stream-combinator, not
observer-graph) underlying reactivity model. `packages/signals-ext/` is
silkenweb's own small set of extra combinators layered on `futures-signals`
Signals (confirmed via `Cargo.toml`: `description = "Extras for
futures-signals"`), not a competing engine.

---

## 7. `futures-signals` (Pauan) — pull-based, `Stream`-composed, lossy signals

Repo: https://github.com/Pauan/rust-signals, `src/signal/`. Fundamentally
different tradeoff from every framework above: there is **no shared mutable
dependency graph and no `Observer` thread-local at all**. A `Signal<Item = T>`
is a trait almost identical to `Future`/`Stream` — `poll_change(&mut self, cx:
&mut Context) -> Poll<Option<T>>` — and derived signals (`map`, `filter`,
`switch`, `flatten`, ...) are combinator structs that hold their upstream
`Signal` and implement `poll_change` by polling it, exactly like `Iterator`/
`Stream` adaptors. There is no tracking-by-side-effect (no thread-local
recording "what did this closure read") — dependencies are **structural**,
declared by combinator nesting, not discovered by execution.

`src/signal/mutable.rs` — the root of the tree, `Mutable<T>`, is the one place
actual notification happens, via a wake-list rather than a graph:

```rust
struct MutableLockState<A> { value: A, signals: Vec<Weak<ChangedWaker>> }
impl<A> MutableLockState<A> {
    fn notify(&mut self, has_changed: bool) {
        self.signals.retain(|signal| {
            if let Some(signal) = signal.upgrade() { signal.wake(has_changed); true } else { false }
        });
    }
}
struct ChangedWaker { changed: AtomicBool, waker: Mutex<Option<Waker>> }
```

Each live `Signal` view onto a `Mutable` holds a `ChangedWaker`; writing the
`Mutable` walks every still-alive weak reference and wakes it (standard
`Future`-style waking — the actual executor is responsible for re-polling).
Crucially this is **lossy by design**: `poll_change` yields only the *current*
value when polled, not a queue of every intermediate value written between
polls — three writes between two polls of a downstream signal are observed as
one change to the latest value, never as three, which is precisely the
opposite failure mode from a naive "channel of every write" design and matches
what most UIs actually want (why redraw three times for three writes that
happened before the next frame looked at the signal?), but it also means
**`futures-signals` cannot express "I need to see every intermediate value,"**
unlike an actual `mpsc` channel. Diamond-dependency sharing needs an explicit
`.broadcast()` combinator (fans one signal out to multiple pollers, since by
default each downstream combinator owns/consumes its upstream and only one
consumer can poll a given `Signal` value). No arena, no `Copy` handles, no
owner/disposal tree at all — lifetime management is exactly Rust's normal
ownership/`Drop` (a `Signal` chain is dropped like any other value; a `Mutable`
is dropped like any other `Arc`), and correctness bugs of the
"read-after-dispose" (§2.7) class documented for Leptos are structurally
impossible in `futures-signals`, because *there is no arena to have a stale
handle into* — the tradeoff is that this model composes awkwardly with a
retained widget tree that wants to hold onto derived-view identity across
frames (which is why silkenweb and Floem both diverge from pure
`futures-signals`/`Stream`-composition toward explicit signal-graph engines
for their view layers, and why `futures-signals` itself is mostly seen wrapping
async data (HTTP responses, timers) rather than driving fine-grained view
diffing directly).

---

## 8. `ripplets` — not found

Searched crates.io and GitHub for "ripplets" as a Rust reactive/signals crate;
no matching project exists under that name as of 2026-08-09. Nothing to report
here — flagging explicitly rather than guessing, per instructions. (If this was
a mis-remembered name for something else in the Leptos-family ecosystem, likely
candidates already covered by this survey are `reactive-signals`
(crates.io, "a dx-first scope-based fine-grained reactive system... based on
ideas from leptos_reactive" — found via search but not independently verified
by source read, since it wasn't in-scope of the seven named targets) or
`reactive_stores` (Leptos's own companion crate, covered via zgui's re-export
in §1.9).

---

## 9. SolidJS — the semantic reference algorithm

(From documentation/search, not source-cloned — JS, out of scope for direct
reading, but the algorithmic reference every Rust framework above is explicitly
or implicitly reproducing.) Key properties, cross-checked against what's
implemented above:

- **Synchronous, single-clock-cycle stabilization**: a write walks the whole
  affected subgraph and settles it *within one synchronous "clock" tick* before
  any effect (as opposed to computation) is allowed to observe the result —
  computations (memos) run first and are side-effect-free by convention;
  effects run only after the graph has fully stabilized. This is the same
  shape as Leptos's Clean/Check/Dirty resolution (computations = memos,
  pulled/resolved first) followed by effects, and the same shape as Sycamore's
  "topo-sort then run only Dirty nodes in dependency order" — all three commit
  to "no observer ever sees a torn/partially-updated graph."
- **Bidirectional edges**: a node holds both its sources and its observers
  (exactly `SourceSet`/`SubscriberSet` in Leptos, `dependencies`/`dependents`
  in Sycamore, `subscribers` + effect-local observed-set in Floem) so that
  disposal/re-tracking can walk in either direction — this is universal across
  every framework surveyed, not a SolidJS-only trait.
- **Execution-count/clock**: Solid tags each run with a monotonically
  increasing counter used to detect "have I already been recomputed this
  cycle" without a separate visited-set — architecturally closest to zgui's
  per-flush `generation: u64` counter (`executor/frame.rs`) used to reset each
  task's poll-budget every flush, and to Sycamore's per-`propagate_updates`
  call implicitly resetting `Mark` state at the end of each DFS.
- **Transitions**: marking an update as non-urgent so the current (stale) tree
  keeps rendering until the new one is ready — this has no real analogue in
  any of the six Rust frameworks surveyed (none of them target concurrent/
  suspense-style rendering of a *retained native* tree; Leptos's own
  `AsyncTransition`, `reactive_graph/src/transition.rs`, exists but is a
  web/SSR-streaming concept zgui explicitly does not re-export). **Not
  relevant to a first-cut GPUI design** — flagged only because it was an asked
  reference point; no GPUI-relevant precedent exists for it among the surveyed
  Rust code.

---

## 10. Comparison table

| Axis | Leptos `reactive_graph` (+ zgui) | Dioxus `generational-box`/signals | Sycamore 0.9 | Floem `floem-reactive` | `futures-signals` (+ silkenweb) |
|---|---|---|---|---|---|
| **Handle repr.** | `ArenaItem<T,S>` = `(SlotMap NodeId, PhantomData)`, `Copy`; dereferences into one **global** `SlotMap<NodeId, Box<dyn Any+Send+Sync>>` behind one `RwLock` (thread-local-swappable arena w/ `sandboxed-arenas`) | `GenerationalBox<T,S>` = `(&'static leaked storage cell, {generation, location})`, `Copy`; **no central arena** — each cell is its own `RefCell`/`RwLock`, recycled via a thread-local free list | `NodeHandle`/`Signal` = `(NodeId, &'static Root)`, `Copy`; one `SlotMap` **per `Root`** (nested roots supported natively) | `Id`-keyed `HashMap<Id, SignalState>` inside a `thread_local! Runtime`; signals not `Copy` by default in the same arena sense — accessed via `Rc`-cloned handle types | No handle/arena at all — `Signal` is a `poll_change`-able trait object/struct chain; identity is ordinary Rust ownership |
| **`Copy`-ness mechanism** | index + zero-sized marker | pointer + generation, both `Copy` scalars | index + `&'static` root pointer | N/A (mostly `Rc`-based, `Clone` not universally `Copy`) | N/A |
| **Disposal** | `Owner` tree; `owner.cleanup()` walks children→cleanups→arena-removes, invoked synchronously by `Mounted::unmount`/`Drop` (zgui) or component teardown (Leptos itself) | scope (`ScopeId`) owns `CopyValue`s; dropped scope → cell recycled (generation bump), not actually freed | `Root` child-scope tree, same shape as Leptos's `Owner`; `NodeHandle::dispose()` disposes children first | per-effect `Scope`/`Id` tree (`dispose_children`), same shape | Rust's own `Drop`; no separate disposal system |
| **Use-after-dispose behavior** | **panics** by default (`.get()` etc.); `try_*` variants exist and return `None`/error. Root cause of the most common Leptos GitHub issues. | **`Result<_, BorrowError>` by construction** on `try_read`/`try_write`; `.read()`/`.write()` are `.unwrap()` wrappers — same eventual panic, but the fallible path is the primary API, not an escape hatch | Reading a disposed `NodeId` returns `None` internally; public API typically panics via `.expect` at the signal-wrapper level (same practical outcome as Leptos) | Similar: disposed `Id` lookups return `None` internally, wrapper panics | **Impossible by construction** — no handle can outlive the data it derives from; ordinary Rust lifetime/ownership rules apply instead |
| **Dependency tracking** | thread-local `Option<AnySubscriber>` "current observer," RAII-swapped; read = add edge both ways; full clear-and-re-collect per subscriber run | same shape, but default granularity is **component `ScopeId`**, not per-effect; fine-grain requires explicit `ReactiveContext`/`use_memo` | same thread-local-observer shape as Leptos (implementation not fully read, but `dependencies`/`dependents` fields match) | per-effect explicit `HashSet<Id>` "observers," cleared+rebuilt every run (`observer_clean_up`) — no thread-local *stack*, a single `current_effect: RefCell<Option<Rc<dyn EffectTrait>>>>` | **no tracking** — dependencies are structural (combinator nesting), discovered by construction, not execution |
| **Update propagation / glitch avoidance** | lazy pull: `mark_dirty`/`mark_check` push (O(reachable) at write time, no recompute) + `update_if_necessary` pull (recompute only when asked, equality-gated at `Memo`) — **3-state** Clean/Check/Dirty | thin layer over the same reactive_graph-family idea within `dioxus-core`'s scheduler (component-level, not signal-graph-level) | **eager**: full DFS-topological-sort from every written root at write time, then run only `Dirty` nodes in dependency order — **2-state** Clean/Dirty | **push-only**, no equality gating on plain `Effect`, no topo-sort — notified effects fully rerun, dedup'd via a pending-effect `HashSet` | pull-only via `poll_change`, lossy (only latest value observed), no graph at all |
| **Cycle handling** | **none built-in** — infinite pull recursion unless bounded externally (zgui adds a per-flush poll-count budget, `BUDGET = 8/32`, logs+defers rather than hangs) | inherits Dioxus's scheduler-level guards, not signal-graph-level | **eager, synchronous panic** at the DFS site: `Mark::Temp` revisited ⇒ `panic!("cyclic reactive dependency")` | none observed in the read source | N/A (no graph) |
| **Borrow-checking exposure** | `Arc<RwLock<T>>` — same-thread double-`write()` **deadlocks**, does not panic (explicit code comment acknowledges this) | `RefCell`(unsync)/`RwLock`(sync) **per-cell**; unsync path gives immediate, precise panic on same-thread double-borrow with `BorrowError` distinguishing "borrowed" vs "dropped" | `RefCell`-based (via `SlotMap` + `Ref`/`RefMut` style access, per source excerpts read) — panics, not deadlocks | `RefCell`/`Mutex`-based (`HashMap<Id, SignalState>`, per-signal locks not directly inspected in depth) — panics expected | none — no interior mutability layer to speak of at the signal-composition level; `Mutable<T>`'s own lock is a plain `RwLock` |
| **Threading (Send/Sync)** | `SyncStorage` (default, `Send+Sync` bound) vs `LocalStorage` (opt-in, `!Send` allowed, runtime thread-check panic) — **type-parameter-selected storage strategy** | `UnsyncStorage` (default, `RefCell`) vs `SyncStorage` (`RwLock`) — same type-parameter pattern, independently arrived at | Not fully inspected; `Root`/`NodeId` appear thread-confined (`&'static Root`, `RefCell`-backed) — no evidence of a `Sync` variant | `SyncSignal<T>` alias (`Storage: Sync`) alongside default unsync `RwSignal`; explicit `assert_ui_thread`/`init_on_ui_thread` guard with named-thread panic messages, `SYNC_RUNTIME` for genuinely cross-thread writes | `Mutable<T>` is plain `Arc<RwLock<...>>`-based, `Send+Sync` by construction; no unsync fast path offered |
| **Batching/scheduling** | signal write = immediate mark; `Effect` run deferred to installed async executor (microtask on wasm); explicit `batch()` needed to coalesce across executor boundaries — documented footgun. zgui instead **defers everything to one explicit `flush()` per frame**, sidestepping the footgun entirely. | component-scope re-render, scheduled via Dioxus's own `SchedulerMsg` queue — coarser-grained batching by default (whole component, not per-signal) | write ⇒ `propagate_updates` immediately unless `batch_depth > 0`, in which case queued and flushed as one DFS at batch end | writes enqueue into `pending_effects` (deduped via a set); drained either inline (no batch) or at outer-`batch()` end; **explicit two-level priority** (`High`/`Normal`) on top of dedup — unique among those surveyed; host-driven `drain_pending_work()` call once per event-loop tick, cross-thread writes routed through a `SYNC_RUNTIME` + installable waker | pull-based — nothing "runs" until something polls; whatever drives the executor (an async runtime) decides cadence; inherently lossy/coalescing by construction, no explicit batch API needed or possible |
| **Frame/event-loop integration** | not built-in to `reactive_graph` itself; **zgui adds it**: `flush()` + `FrameWaker` trait (idempotent, any-thread, non-blocking) pinging the platform for a redraw, `TestWaker` for headless/tests | Dioxus's own async-runtime-integrated scheduler (`tokio`/wasm), not frame-loop shaped (Dioxus targets are VDOM-diffed renders, not a native paint loop) | not applicable in the same sense — Sycamore targets DOM/SSR, no native frame loop in the reactive crate itself | **built-in and load-bearing**: `Runtime::drain_pending_work()` called from the real windowing event loop (`src/app/handle.rs`), `SYNC_RUNTIME` waker is Floem's `FrameWaker` equivalent | none — `futures-signals` has no concept of a frame; consuming crate (silkenweb) drives it via the DOM's own microtask/rAF machinery |
| **Ergonomic surface for "derived state"** | `Memo::new(move |_| ...)`, equality-gated; or a bare `move || ...` closure treated specially by call sites that know to track it (zgui's `View for FnMut`) | `use_memo(move || ...)`; component-scope re-render is the "default" derived state (no memo needed for basic cases, at the cost of granularity) | `create_memo(move || ...)` | `Memo::new`, `UpdaterEffect::new` (compute+on_change split) for view-tree derivation specifically | `.map(\|x\| ...)`/`.map_ref`/combinator chaining — "derived state" *is* just Stream-style composition, no separate memo concept needed or possible |

---

## 11. Five most stealable design ideas for a GPUI integration

1. **Wrap, don't expose, the reactive engine — and pick the wrapping seam
   zgui already validated.** Whether GPUI vendors `reactive_graph`,
   reimplements its push-pull algorithm directly against a `RefCell`-based
   single-threaded arena (recommended — see #2), or writes something
   Floem-shaped, the *public* GPUI signal API should own its own vocabulary
   (`Signal`, `Memo`, `RenderEffect`, `Owner`/`Mounted`) with the underlying
   engine named in exactly one internal crate, exactly as `zgui-reactive`'s
   `lib.rs` states the rule. This buys freedom to swap or hand-roll the engine
   later without an API break, and lets GPUI curate away known footguns (don't
   re-export the async `Effect`, don't re-export unkeyed store indexing, don't
   let a `nightly`-style feature leak) the way zgui's guide documents.

2. **Use a `RefCell`-based, single-threaded arena (or Dioxus's leaked-cell
   generational-box), not `Arc<RwLock<...>>`.** GPUI already confines
   reactive work to one thread per window/app; Leptos's `Arc<RwLock<T>>` /
   global-`RwLock`-arena design pays for cross-thread safety GPUI doesn't need,
   and — worse — **turns a same-thread double-borrow into a silent deadlock
   instead of an immediate, debuggable panic** (explicitly flagged in Leptos's
   own `MemoInner::update_if_necessary` comment). A `RefCell`-per-slot design
   (Dioxus's `generational-box::UnsyncStorage`, or Sycamore's `SlotMap` +
   `Ref`/`RefMut`) gets you the strongest available runtime borrow-check
   (instant panic with file:line via `#[track_caller]`, both borrow sites
   nameable) and removes an entire footgun class from GPUI's design for free,
   at zero-cost since GPUI is not multithreaded per-window anyway.

3. **Commit to one explicit host-driven `flush()`/frame point, and make
   scheduling *invisible* to signal writers.** Both real-world precedents
   (zgui wrapping Leptos, Floem's own engine) converge on the same shape:
   writing a signal only marks state and wakes tasks; nothing recomputes until
   the host (GPUI's own frame loop / update cycle) calls one function. This
   sidesteps Leptos's own most-cited footgun (`batch()` not being obvious,
   microtask-timing surprises) entirely, gives free coalescing of N writes
   between two frames into one recompute, and composes naturally with GPUI's
   existing `cx.notify()`/redraw-request model. Steal zgui's exact
   `FrameWaker` shape for the cross-thread case: a `Send + Sync`, idempotent,
   non-blocking `wake()` trait object that a background-thread signal write
   pings, which the platform backend turns into "schedule a redraw," decoupled
   from in-flush wakes (which should *not* re-request a redraw, only set a
   "needs another pass" flag) — this exact distinction is what stops "effect
   writes a signal" from becoming "redraw request per write."

4. **Detect cycles eagerly and panic with a name, the way Sycamore does —
   don't rely solely on an iteration-budget backstop.** Leptos's lazy
   push-pull algorithm has *no* native cycle detection; zgui had to bolt one
   on externally (a per-flush poll-count cap that silently defers a runaway
   task to next frame and logs once). Sycamore's eager topological-DFS
   approach gets synchronous, precise, immediate cycle detection
   (`panic!("cyclic reactive dependency")`) as a natural byproduct of the same
   traversal it needs anyway for glitch-free ordering. For a framework meant
   to have "maximal compile-time verification" as a design goal, failing loud
   and immediately at the exact write that creates a cycle (ideally with the
   two node locations, given `#[track_caller]` diagnostics are already
   table-stakes per §2.8) is a strictly better UX than a bounded number of
   silently-wasted extra frames.

5. **Decompose the read/write trait surface finely (à la
   `reactive_graph::traits`), and expose the "closure vs plain value" split as
   the API's core ergonomic contract — but consider forcing it, not just
   documenting it.** Every framework surveyed shares the single most common
   documented footgun: `{move || signal.get()}` (reactive) vs `{signal.get()}`
   (frozen forever) both compile, and only one updates; zgui's own guide lists
   this first among "common mistakes." A fine-grained-verification-maximizing
   GPUI design should treat this as the one place worth spending extra type-
   system or macro effort to make the mistake a compile error rather than a
   silent bug — e.g., a `view!`-style builder macro (as zgui/Leptos/Sycamore
   all use) that requires an explicit reactive-hole marker, or leaning on
   GPUI's existing typed element-builder API so that "pass a value" and "pass
   a closure" are visibly, syntactically distinct call sites rather than two
   expressions of the same shape. Separately, replicate the *granularity* of
   the trait decomposition itself (`Get`/`With`/`Read`/`Set`/`Update`/`Write`,
   each independently `_untracked`-able, each blanket-implemented over
   `Signal`/`Memo`/`Store`-field/constant) so GPUI component APIs can accept
   "anything readable as a `T`" without forcing every call site onto one
   concrete signal type — this is the mechanism that makes signals compose
   with "plain Rust" the way the research brief asks for.

---

## Appendix: sources consulted

- zgui: https://github.com/zortax/zgui (clone; `crates/zgui-reactive/**`,
  `crates/zgui-view/src/view/reactive.rs`, `docs/guide/reactivity.md`, `README.md`)
- Leptos `reactive_graph`: https://github.com/leptos-rs/leptos, `reactive_graph/src/{graph,owner,signal,computed,effect,traits.rs,diagnostics.rs}/**`
- Dioxus: https://github.com/DioxusLabs/dioxus, `packages/{generational-box,signals,core/src/reactive_context.rs}/**`
- Sycamore: https://github.com/sycamore-rs/sycamore, `packages/sycamore-reactive/src/{node,signals,root}.rs`
- Floem: https://github.com/lapce/floem, `reactive/src/{effect,runtime}.rs`, `src/views/{label,decorator,dyn_view,container}.rs`, `src/app/handle.rs`
- Silkenweb: https://github.com/silkenweb/silkenweb, `packages/{silkenweb,signals-ext}/Cargo.toml`, `packages/silkenweb/src/lib.rs`
- futures-signals: https://github.com/Pauan/rust-signals, `src/signal/mutable.rs`
- GitHub issues: leptos-rs/leptos #2842, #3243, #3627, #3681; leptos-rs/leptos #2822 discussion on immediate effects; general web search on batching pain points
- SolidJS reactivity: docs.solidjs.com "Fine-grained reactivity", DeepWiki solidjs/solid transitions page, jser.dev walkthrough (web search / WebFetch summaries, not source-cloned — JS out of scope)
- crates.io / GitHub search for "ripplets": no matching project found
