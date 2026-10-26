# GPUI-CE Architectural Map: Data Flow, State Ownership, Reactivity

> Source audit pinned to the commit named below. The original seam recommendations are corrected by
> [06-competitive-update.md](06-competitive-update.md) and
> [../03-hybrid-plan.md](../03-hybrid-plan.md), especially the distinction between retained
> auxiliary element state and retained element/layout/scene nodes.

Repo: `/Users/mileswirht/Downloads/gpui-ce` (community fork of Zed's GPUI, "gpui-ce"). Purpose: exhaustive map of the current coarse observer/notify model to inform a redesign toward fine-grained, compile-time-verified reactivity. All findings below are sourced directly from the current checkout (no web access), with `file:line` citations and verbatim code quotes throughout.

---

# PART 1 — App, Context, Entity Model, Global State

Scope: `crates/gpui/src/_ownership_and_data_flow.rs`, `app.rs` (3080 lines), `app/context.rs` (876 lines), `app/entity_map.rs` (1278 lines), `app/async_context.rs` (536 lines), `global.rs` (75 lines), `gpui.rs`.

## 1.1 `_ownership_and_data_flow.rs` — GPUI's own description of its model

This module is pure doc-comment prose (plus doctests) — GPUI's own articulation of its ownership model. Key passages, quoted verbatim:

- **Lines 1–3**: *"every model or view in the application is actually owned by a single top-level object called the `App`. When a new entity or view is created (referred to collectively as _entities_), the application is given ownership of their state to enable their participation in a variety of app services and interaction with other entities."*

- **Lines 16–18**: *"this `Entity<Counter>` handle doesn't provide access to the entity's state. It's merely an inert identifier plus a compile-time type tag, and it maintains a reference counted pointer to the underlying `Counter` object that is owned by the app."* And: *"Much like an `Rc` from the Rust standard library, this reference count is incremented when the handle is cloned and decremented when it is dropped... but unlike an `Rc` it only provides access to the model's state when a reference to an `App` is available. The handle doesn't truly _own_ the state, but it can be used to access the state from its true owner, the `App`."*

- **Line 34**: *"To update the counter, we call `update` on the handle, passing the context reference and a callback. The callback is yielded a mutable reference to the counter, which can be used to manipulate state."*

- **Line 36**: *"This reference is similar to the `App` reference provided to the `run` callback. A `Context` is actually a wrapper around the `App`, including some additional data to indicate which particular entity it is tied to; in this case the counter."*

- **Line 38**: *"a `Context` provides access to entity-level services. For example, it can be used it to inform observers of this entity that its state has changed."* — this is the introduction of `cx.notify()`.

- **Line 54**: on `observe`: *"Whenever the first counter changes, twice its count is assigned to the second counter... The call to `observe` returns a `Subscription`, which is `detach`ed to preserve this behavior for as long as both counters exist... We could also store this subscription and drop it at a time of our choosing to cancel this behavior."*

- **Line 90**: *"In addition to `observe` and `notify`, which indicate that an entity's state has changed, GPUI also offers `subscribe` and `emit`, which enables entities to emit typed events. To opt into this system, the emitting object must implement the `EventEmitter` trait."*

This doc module is the framework's own confession of exactly the coarse observer model the redesign targets: state lives in an app-owned map keyed by opaque `EntityId`; access always requires a live `&App`/`&mut App`/`Context<T>`; change propagation is untyped ("notify" = "something changed, re-derive/re-render") layered by a separately-typed event channel ("emit"/"subscribe") — there is no dependency graph, no fine-grained field-level tracking, and no compile-time link between what changed and who must re-run.

## 1.2 Entity storage and the lease mechanic (`app/entity_map.rs`)

### Core storage
```rust
// entity_map.rs:56-60
pub(crate) struct EntityMap {
    entities: SecondaryMap<EntityId, Box<dyn Any>>,
    pub accessed_entities: RefCell<FxHashSet<EntityId>>,
    ref_counts: Arc<RwLock<EntityRefCounts>>,
}
```
Entities are type-erased (`Box<dyn Any>`), keyed by `slotmap`-generated `EntityId`, with a separate `Arc<RwLock<EntityRefCounts>>` (atomic `SlotMap<EntityId, AtomicUsize>`) for refcounting independent of storage.

### `reserve` / `insert` (entity_map.rs:113–130)
```rust
pub fn reserve<T: 'static>(&self) -> Slot<T> {
    let id = self.ref_counts.write().counts.insert(1.into());
    Slot(Entity::new(id, Arc::downgrade(&self.ref_counts)))
}

pub fn insert<T>(&mut self, slot: Slot<T>, entity: T) -> Entity<T>
where T: 'static,
{
    let mut accessed_entities = self.accessed_entities.get_mut();
    accessed_entities.insert(slot.entity_id);
    let handle = slot.0;
    self.entities.insert(handle.entity_id, Box::new(entity));
    handle
}
```
The id is allocated (refcounted at 1) *before* the value exists — this is what lets a build closure `observe`/`subscribe` its own not-yet-inserted entity.

### `lease` / `end_lease` — the "move to stack" mechanic (entity_map.rs:132–154)
```rust
#[track_caller]
pub fn lease<T>(&mut self, pointer: &Entity<T>) -> Lease<T> {
    self.assert_valid_context(pointer);
    let mut accessed_entities = self.accessed_entities.get_mut();
    accessed_entities.insert(pointer.entity_id);

    let entity = Some(
        self.entities
            .remove(pointer.entity_id)
            .unwrap_or_else(|| double_lease_panic::<T>("update")),
    );
    Lease { entity, id: pointer.entity_id, entity_type: PhantomData }
}

pub fn end_lease<T>(&mut self, mut lease: Lease<T>) {
    self.entities.insert(lease.id, lease.entity.take().unwrap());
}
```
A "lease" is: `Box<dyn Any>` is `remove`d out of the `SecondaryMap` for the duration of `update`, leaving the slot empty; any second attempt to `lease`/`read` the same entity while it is out finds nothing and panics. `end_lease` puts it back.

### `read` (entity_map.rs:156–165)
```rust
pub fn read<T: 'static>(&self, entity: &Entity<T>) -> &T {
    self.assert_valid_context(entity);
    let mut accessed_entities = self.accessed_entities.borrow_mut();
    accessed_entities.insert(entity.entity_id);
    self.entities
        .get(entity.entity_id)
        .and_then(|entity| entity.downcast_ref())
        .unwrap_or_else(|| double_lease_panic::<T>("read"))
}
```
Reading while the same entity is leased (mid-`update`) hits the empty slot and panics via the same helper.

### Panic sites — exact text, file:line

1. **Double-lease / use-while-being-updated** — `entity_map.rs:206–212`:
```rust
#[track_caller]
fn double_lease_panic<T>(operation: &str) -> ! {
    panic!(
        "cannot {operation} {} while it is already being updated",
        std::any::type_name::<T>()
    )
}
```
Triggered from `lease` (line 142, `operation = "update"`) and `read` (line 164, `operation = "read"`). E.g.: `"cannot read my_crate::MyEntity while it is already being updated"`. A **runtime**, not compile-time, invariant — precisely the bug class a fine-grained, compile-time-verified reactivity model should eliminate structurally.

2. **Use-after-release (leaked `Lease` guard)** — `entity_map.rs:234–240`:
```rust
impl<T> Drop for Lease<T> {
    fn drop(&mut self) {
        if self.entity.is_some() && !panicking() {
            panic!("Leases must be ended with EntityMap::end_lease")
        }
    }
}
```

3. **Wrong-App usage** — `entity_map.rs:167–172`:
```rust
fn assert_valid_context(&self, entity: &AnyEntity) {
    debug_assert!(
        Weak::ptr_eq(&entity.entity_map, &Arc::downgrade(&self.ref_counts)),
        "used a entity with the wrong context"
    );
}
```
Only active in debug builds.

4. **Over-release on `Clone`** — `entity_map.rs:311–321`:
```rust
impl Clone for AnyEntity {
    fn clone(&self) -> Self {
        if let Some(entity_map) = self.entity_map.upgrade() {
            let entity_map = entity_map.read();
            let count = entity_map.counts.get(self.entity_id)
                .expect("detected over-release of a entity");
            let prev_count = count.fetch_add(1, SeqCst);
            assert_ne!(prev_count, 0, "Detected over-release of a entity.");
        }
        ...
```

5. **Over-release on `Drop`** — `entity_map.rs:339–354`:
```rust
impl Drop for AnyEntity {
    fn drop(&mut self) {
        if let Some(entity_map) = self.entity_map.upgrade() {
            let entity_map = entity_map.upgradable_read();
            let count = entity_map.counts.get(self.entity_id)
                .expect("detected over-release of a handle.");
            let prev_count = count.fetch_sub(1, SeqCst);
            assert_ne!(prev_count, 0, "Detected over-release of a entity.");
            if prev_count == 1 {
                let mut entity_map = RwLockUpgradableReadGuard::upgrade(entity_map);
                entity_map.dropped_entity_ids.push(self.entity_id);
            }
        }
        ...
```
`prev_count == 1` → last strong ref → pushed into `dropped_entity_ids`, drained by `EntityMap::take_dropped` (184–203), which has its own `debug_assert_eq!(count.load(SeqCst), 0, "dropped an entity that was referenced")` (192–196).

6. **Leak detector** (test/`leak-detection` feature) — `entity_map.rs:661–663` (`"entity was recently dropped but resources are retained until the end of the effect cycle."`), `1023` (`"Handles for {type_name} leaked:\n{out}"`), `1080` (`"New entity leaks detected since snapshot:\n{out}"`), `1116` (`"Exited with leaked handles:\n{out}"`).

### `Lease<T>` / `Slot<T>` / `AnyEntity` / `Entity<T>` / `WeakEntity<T>`
- `Lease<T>` (214–240): `Option<Box<dyn Any>>`; `Deref`/`DerefMut` unwrap-and-downcast unconditionally (220–232).
- `Slot<T>` (242–243): thin newtype over `Entity<T>` from `reserve`.
- `AnyEntity` (246–252): `entity_id: EntityId`, `entity_type: TypeId`, `entity_map: Weak<RwLock<EntityRefCounts>>` — the real ref-counted pointer. `Entity<T>` (413–419) = `AnyEntity` + `PhantomData<fn(T)->T>`.
- Access API on `Entity<T>` (462–508): `read` (464, → `cx.entities.read`), `read_with` (470), `update` (476, → `cx.update_entity`), `as_mut` (486, → `cx.as_mut` → `GpuiBorrow`), `write` (491, `update` + `notify()`), `update_in` (502, `VisualContext`-gated, window-scoped).
- `WeakEntity<T>::upgrade` (767) increments the atomic count only if nonzero (`atomic_incr_if_not_zero`, 598) — lock-free liveness check.

### `GpuiBorrow<'a, T>` — RAII alternative to closure-based `update` (app.rs:2991–3040)
```rust
pub struct GpuiBorrow<'a, T> {
    inner: Option<Lease<T>>,
    app: &'a mut App,
}
impl<'a, T: 'static> GpuiBorrow<'a, T> {
    fn new(inner: Entity<T>, app: &'a mut App) -> Self {
        app.start_update();
        let lease = app.entities.lease(&inner);
        Self { inner: Some(lease), app }
    }
}
impl<'a, T> Drop for GpuiBorrow<'a, T> {
    fn drop(&mut self) {
        let lease = self.inner.take().unwrap();
        self.app.notify(lease.id);
        self.app.entities.end_lease(lease);
        self.app.finish_update();
    }
}
```
Confirms leasing is fundamentally "remove-from-map for a scope," whether via closure (`update`) or RAII guard (`as_mut`) — every mutation path shares the same double-lease-panic-guarded slot swap.

## 1.3 Effect queue (`pending_effects: VecDeque<Effect>`)

### `Effect` enum — 6 variants (app.rs:2868–2890)
```rust
pub(crate) enum Effect {
    Notify { emitter: EntityId },
    Emit { emitter: EntityId, event_type: TypeId, event: ArenaBox<dyn Any> },
    RefreshWindows,
    NotifyGlobalObservers { global_type: TypeId },
    Defer { callback: Box<dyn FnOnce(&mut App) + 'static> },
    EntityCreated { entity: AnyEntity, tid: TypeId, window: Option<WindowId> },
}
```

### `push_effect` — dedup logic (app.rs:1636–1652)
```rust
pub(crate) fn push_effect(&mut self, effect: Effect) {
    match &effect {
        Effect::Notify { emitter } => {
            if !self.pending_notifications.insert(*emitter) { return; }
        }
        Effect::NotifyGlobalObservers { global_type } => {
            if !self.pending_global_notifications.insert(*global_type) { return; }
        }
        _ => {}
    };
    self.pending_effects.push_back(effect);
}
```
`Notify`/`NotifyGlobalObservers` are coalesced via side-set membership (`pending_notifications: FxHashSet<EntityId>`, `pending_global_notifications: TypeIdHashSet`) — repeated `cx.notify()` on the same entity within one update batch collapses to one queued effect. This is GPUI's *only* batching of change propagation, and it's coarse: it knows *that* an entity changed, never *what*.

Call sites: `refresh_windows` (`RefreshWindows`, 1041, 2209, 2215), `emit` (`Emit`, 1075), `global_mut`/`default_global`/`set_global`/`remove_global`/`end_global_lease` (`NotifyGlobalObservers`, 2007/2018/2029/2042/2082), `defer` (`Defer`, 1967), entity construction (`EntityCreated`, 2755), `App::notify` (`Notify`, 2680–2683, fallback branch only — see below).

### `App::notify` — dual-path notification (app.rs:2657–2692)
```rust
pub fn notify(&mut self, entity_id: EntityId) {
    let window_invalidators = mem::take(
        self.window_invalidators_by_entity.entry(entity_id).or_default(),
    );
    let live_invalidators: SmallVec<[WindowInvalidator; 2]> = window_invalidators
        .iter()
        .filter(|(window_id, _)| {
            self.tracked_entities.get(window_id).is_some_and(|set| set.contains(&entity_id))
        })
        .map(|(_, invalidator)| invalidator.clone())
        .collect();

    if live_invalidators.is_empty() {
        if self.pending_notifications.insert(entity_id) {
            self.pending_effects.push_back(Effect::Notify { emitter: entity_id });
        }
    } else {
        for invalidator in &live_invalidators {
            invalidator.invalidate_view(entity_id, self);
        }
    }
    self.window_invalidators_by_entity.insert(entity_id, window_invalidators);
}
```
Architecturally significant: when an entity is *currently rendered by a window* — tracked via `tracked_entities`/`window_invalidators_by_entity`, populated by `record_entities_accessed` (1097–1140), which snapshots `accessed_entities` from `EntityMap` before/after a render pass (**dependency tracking = diff-the-global-read-set-before-and-after-render, not a static/typed graph**) — `notify` bypasses the effect queue and calls `WindowInvalidator::invalidate_view` directly. Only entities with no current window (headless observers/models) go through the `Effect::Notify` queue.

### `flush_effects` — drain loop (app.rs:1657–1713)
```rust
fn flush_effects(&mut self) {
    loop {
        self.release_dropped_entities();
        self.release_dropped_focus_handles();
        if let Some(effect) = self.pending_effects.pop_front() {
            match effect {
                Effect::Notify { emitter } => self.apply_notify_effect(emitter),
                Effect::Emit { emitter, event_type, event } => self.apply_emit_effect(emitter, event_type, &*event),
                Effect::RefreshWindows => self.apply_refresh_effect(),
                Effect::NotifyGlobalObservers { global_type } => self.apply_notify_global_observers_effect(global_type),
                Effect::Defer { callback } => self.apply_defer_effect(callback),
                Effect::EntityCreated { entity, tid, window } => self.apply_entity_created_effect(entity, tid, window),
            }
        } else {
            #[cfg(any(test, feature = "test-support", feature = "bench"))]
            for window in self.windows.values().filter_map(|w| { /* dirty windows */ }).collect::<Vec<_>>() {
                self.update_window(window, |_, window, cx| window.draw(cx).clear(cx)).unwrap();
            }
            if self.pending_effects.is_empty() {
                self.event_arena.clear();
                break;
            }
        }
    }
}
```
Doc comment (1654–1656): *"Called at the end of [`App::update`] to complete any side effects such as notifying observers, emitting events, etc. Effects can themselves cause effects, so we continue looping until all effects are processed."* Entity teardown (`release_dropped_entities`, invokes `on_release` listeners) and effect application are interleaved every loop iteration; both can generate new effects.

### Where `flush_effects` connects to the frame loop
`flush_effects` (private) is reachable only via `App::update`:
```rust
// app.rs:1044-1062
pub(crate) fn update<R>(&mut self, update: impl FnOnce(&mut Self) -> R) -> R {
    self.start_update();
    let result = update(self);
    self.finish_update();
    result
}
pub(crate) fn start_update(&mut self) { self.pending_updates += 1; }
pub(crate) fn finish_update(&mut self) {
    if !self.flushing_effects && self.pending_updates == 1 {
        self.flushing_effects = true;
        self.flush_effects();
        self.flushing_effects = false;
    }
    self.pending_updates -= 1;
}
```
Reentrancy counter (`pending_updates`) + reentrancy guard (`flushing_effects`): effects flush only when the outermost `App::update` returns. Every mutation path funnels through `App::update`: `AppContext::new` (2749–2763), `update_entity` (2783–2797), `update_window_id` (1848–1903), `open_window` (1269), `GpuiBorrow::new`/`Drop` (2997–3040). Connection to the platform paint loop: `window.rs:1551` (`platform_window.on_request_frame(...)`) → `handle.update(&mut cx, ...)` → `update_window` → `update_window_id` → `self.update(|cx| {...})` → `finish_update` → `flush_effects`. **GPUI has no separate "commit phase"; each `cx.update(...)` call is its own micro-transaction ending in a full effect-queue drain** — the effect queue is drained on every top-level mutation, not on a fixed frame cadence.

## 1.4 Global state (`global.rs` + `app.rs`)

### `Global` trait (global.rs:22–27)
```rust
pub trait Global: 'static {
    // This trait is intentionally left empty, by virtue of being a marker trait.
}
```
Doc (3–8): *"This trait exists to provide type-safe access to globals by ensuring only types that implement [`Global`] can be used with the accessor methods... trying to access a global with a type that does not implement [`Global`] will result in a compile-time error."* This guarantees only the *type* is global-capable at compile time — **not** that an instance has been inserted; that check is still runtime.

### `ReadGlobal` / `UpdateGlobal` blanket impls (global.rs:29–75)
```rust
pub trait ReadGlobal {
    fn global(cx: &App) -> &Self; // Panics if a global for that type has not been assigned.
}
impl<T: Global> ReadGlobal for T {
    fn global(cx: &App) -> &Self { cx.global::<T>() }
}
pub trait UpdateGlobal {
    fn update_global<C, F, R>(cx: &mut C, update: F) -> R
    where C: BorrowAppContext, F: FnOnce(&mut Self, &mut C) -> R;
    fn set_global<C>(cx: &mut C, global: Self) where C: BorrowAppContext;
}
```

Storage: `App.globals_by_type: TypeIdHashMap<Box<dyn Any>>` (app.rs:736), with a comment above it (732–735): *"Drop globals last. We need to ensure all tasks owned by entities and callbacks are marked cancelled at this point as this will also shutdown the tokio runtime..."* — globals are declared last in the struct specifically to control Rust's field-drop order.

### Accessor panics — exact text
- `global<G>()` (1987–1994): `#[track_caller] pub fn global<G: Global>(&self) -> &G { ... .unwrap_or_else(|| panic!("no state of type {} exists", type_name::<G>())) }` — **`"no state of type {type_name} exists"`**.
- `global_mut<G>()` (2004–2012): same panic text, and **pushes `Effect::NotifyGlobalObservers` before checking the value exists** (line 2007) — an observer-notify effect is queued even on a call about to panic.
- `remove_global<G>()` (2040–2049): **`"no global added for {type_name}"`**.
- **`lease_global<G>()`** (2067–2076), global analogue of `EntityMap::lease`:
```rust
#[track_caller]
pub(crate) fn lease_global<G: Global>(&mut self) -> GlobalLease<G> {
    GlobalLease::new(
        self.globals_by_type
            .remove(&TypeId::of::<G>())
            .with_context(|| format!("no global registered of type {}", type_name::<G>()))
            .unwrap(),
    )
}
```
**`"no global registered of type {type_name}"`**. Because this *removes* the entry for the duration of the lease (same "move to stack" pattern as entities, 2907–2934), calling `update_global::<G, _>` reentrantly for the same `G` while already inside another `update_global::<G, _>` hits this same panic — **globals have an undocumented double-lease hazard structurally identical to entities**, reusing the "missing" message instead of a dedicated "already being updated" one.

### `update_global` — generic entry point via `BorrowAppContext` (gpui.rs:299–338)
```rust
pub trait BorrowAppContext {
    fn set_global<T: Global>(&mut self, global: T);
    fn update_global<G, R>(&mut self, f: impl FnOnce(&mut G, &mut Self) -> R) -> R where G: Global;
    fn update_default_global<G, R>(&mut self, f: impl FnOnce(&mut G, &mut Self) -> R) -> R where G: Global + Default;
}
impl<C> BorrowAppContext for C where C: std::borrow::BorrowMut<App> {
    #[track_caller]
    fn update_global<G, R>(&mut self, f: impl FnOnce(&mut G, &mut Self) -> R) -> R
    where G: Global,
    {
        let mut global = self.borrow_mut().lease_global::<G>();
        let result = f(&mut global, self);
        self.borrow_mut().end_global_lease(global);
        result
    }
    ...
}
```
Implemented generically for anything `BorrowMut<App>` (`App` itself and `Context<'_, T>`) — globals are reachable from *any* context type uniformly, with no scoping mechanism beyond the `TypeId` key. `AsyncApp`/`AsyncWindowContext` expose their own `update_global`/`read_global`/`try_read_global`/`read_default_global`/`has_global` wrappers (async_context.rs:214–262, 320–340).

## 1.5 Cx-threading quantification

Raw grep counts across the five core files:

| file | `&mut Context<T>` | `&mut App` | `&mut Window` | `pub fn` count |
|---|---|---|---|---|
| `app.rs` | 4 | 54 | 20 | 174 |
| `app/context.rs` | 31 | 11 | 43 | 41 |
| `app/entity_map.rs` | 4 | 0 | 2 | 42 |
| `app/async_context.rs` | 10 | 12 | 12 | 21 |
| `global.rs` | 0 | 0 | 0 | 0 |
| **total** | **49** | **77** | **77** | **278** |

Combined "must-thread-a-cx-shaped-mutable-reference" count: **203** across five files, excluding an additional 21 `&App` and 9 `&Window` (read-only) occurrences, and excluding generic `C: AppContext`/`C: VisualContext`/`C: BorrowAppContext` bound-parameter threading (a *third* form, used pervasively). Essentially no function in GPUI's core app/entity API is cx-free. **This is the concrete footprint of the "cx-threading burden"**: state access is not a first-class value (a `Signal`/`Cell`-style handle usable anywhere) — it's a capability that must be re-derived/re-passed through every call frame, enforced by borrow-checker-driven signatures rather than a dependency-tracked reactive graph.

## 1.6 Async re-entry (`app/async_context.rs`)

`AsyncApp` (22–26) holds only a `Weak<AppCell>` plus executor clones — no live borrow, so it can cross `.await`:
```rust
pub struct AsyncApp {
    pub(crate) app: Weak<AppCell>,
    pub(crate) background_executor: BackgroundExecutor,
    pub(crate) foreground_executor: ForegroundExecutor,
}
```
Doc (15–20): *"An async-friendly version of [App] with a static lifetime so it can be held across `await` points in async code... Methods will panic if the app has been dropped, but this should not happen in practice when using foreground tasks spawned via `cx.spawn()`, as the executor checks if the app is alive before running each task."*

Re-entry point, `AsyncApp::app()` (28–34):
```rust
fn app(&self) -> std::rc::Rc<AppCell> {
    self.app.upgrade().expect("app was released before async operation completed")
}
```
**`"app was released before async operation completed"`**. Every `AppContext` impl method re-borrows the shared `RefCell<App>` (via `AppCell::borrow_mut`, app.rs:98–104, whose comment reads *"Temporary(?) wrapper around `RefCell<App>` to help us debug any double borrows. Strongly consider removing after stabilization."*) synchronously and drops the borrow immediately, e.g.:
```rust
fn update_entity<T: 'static, R>(&mut self, handle: &Entity<T>, update: impl FnOnce(&mut T, &mut Context<T>) -> R) -> R {
    let app = self.app();
    let mut app = app.borrow_mut();
    app.update_entity(handle, update)
}
```
`AsyncApp::update` (162–167) delegates straight into `App::update` — every async `update`/`update_entity`/`update_global`/etc. call is its own independent transaction, flushing effects once per resumption; **no batching of effects across `.await` points**, only within a single synchronous call.

`WeakEntity::update`/`update_in`/`read_with` (entity_map.rs:777–805, 810–816) are the fallible analogues:
```rust
pub fn update<C, R>(&self, cx: &mut C, update: impl FnOnce(&mut T, &mut Context<T>) -> R) -> Result<R>
where C: AppContext,
{
    let entity = self.upgrade().context("entity released")?;
    Ok(cx.update_entity(&entity, update))
}
```
Async/weak path always upgrades-or-errors (`"entity released"`), never panics on stale handles.

`AsyncWindowContext::update_window` on `AsyncApp` (85–95) uses the **fallible** `try_borrow_mut()` rather than `borrow_mut()`, so window-scoped async re-entry degrades to `Err` on a double-borrow rather than panicking:
```rust
fn update_window<T, F>(&mut self, window: AnyWindowHandle, f: F) -> Result<T> {
    let app = self.app.upgrade().context("app was released")?;
    let mut lock = app.try_borrow_mut()?;
    if lock.quitting { bail!("app is quitting"); }
    lock.update_window(window, f)
}
```

### Synthesis
Every subsystem here shares one structural trait: **all reactivity/liveness/change-detection facts are runtime-checked against a single shared mutable arena (`App`/`RefCell<App>`), keyed by opaque `TypeId`/`EntityId`, using remove-from-map-then-reinsert ("lease") as the exclusivity mechanism, and diff-the-read-set-before-and-after as the sole dependency-discovery mechanism.** There is no static graph of "what depends on what." Every panic site enumerated above exists because none of the invariants (exclusive-mutable-access, global-registered, app-alive, entity-alive) are encoded in the type system — all are discharged by `unwrap`/`expect`/`panic!` at the moment of violation, exactly the surface a compile-time-verified reactivity model needs to close.

---

# PART 2 — Reactivity Primitives: notify/observe/subscribe/emit End-to-End

Scope: `crates/gpui/src/subscription.rs` (351 lines), plus `app.rs`, `app/context.rs`, `window.rs`, `view.rs`.

## 2.1 `subscription.rs` mechanics

### Core data structures (subscription.rs:9–28)
```rust
pub(crate) struct SubscriberSet<EmitterKey, Callback>(
    Rc<RefCell<SubscriberSetState<EmitterKey, Callback>>>,
);
struct SubscriberSetState<EmitterKey, Callback> {
    subscribers: BTreeMap<EmitterKey, Option<BTreeMap<usize, Subscriber<Callback>>>>,
    next_subscriber_id: usize,
}
struct Subscriber<Callback> {
    active: Rc<Cell<bool>>,
    dropped: Rc<Cell<bool>>,
    callback: Callback,
}
```
`SubscriberSet` is GPUI's single generic building block for *every* observer/listener registry (entity-change observers, event listeners, global observers, release listeners, keystroke observers, etc.), keyed by `EmitterKey` (usually `EntityId` or `TypeId`).

### Insert — two-phase "inert until activated" registration (46–87)
```rust
pub fn insert(
    &self,
    emitter_key: EmitterKey,
    callback: Callback,
) -> (Subscription, impl FnOnce() + use<EmitterKey, Callback>) {
    let active = Rc::new(Cell::new(false));
    let dropped = Rc::new(Cell::new(false));
    let mut lock = self.0.borrow_mut();
    let subscriber_id = post_inc(&mut lock.next_subscriber_id);
    lock.subscribers
        .entry(emitter_key.clone())
        .or_default()
        .get_or_insert_with(Default::default)
        .insert(subscriber_id, Subscriber { active: active.clone(), dropped: dropped.clone(), callback });
    let this = self.0.clone();
    let subscription = Subscription {
        unsubscribe: Some(Box::new(move || {
            dropped.set(true);
            let mut lock = this.borrow_mut();
            let Some(subscribers) = lock.subscribers.get_mut(&emitter_key) else { return; };
            if let Some(subscribers) = subscribers {
                subscribers.remove(&subscriber_id);
                if subscribers.is_empty() { lock.subscribers.remove(&emitter_key); }
            }
        })),
    };
    (subscription, move || active.set(true))
}
```
`insert` returns `(Subscription, impl FnOnce())`. The subscriber is stored *inert* immediately; the activation closure must be called separately, and every call site does so via `self.app.defer(move |_| activate())` — activation is deferred to the next effect-flush cycle, not immediate. A freshly-created subscription will not fire for a notify that happens synchronously before its own `insert` call returns.

### Retain — the "fire all subscribers" dispatch primitive (110–144)
```rust
pub fn retain<F>(&self, emitter: &EmitterKey, mut f: F)
where F: FnMut(&mut Callback) -> bool,
{
    let Some(mut subscribers) = self.0.borrow_mut().subscribers.get_mut(emitter).and_then(|s| s.take())
    else { return; };
    subscribers.retain(|_, subscriber| {
        if !subscriber.active.get() { return true; }
        if subscriber.dropped.get() { return false; }
        let keep = f(&mut subscriber.callback);
        keep && !subscriber.dropped.get()
    });
    let mut lock = self.0.borrow_mut();
    if let Some(Some(new_subscribers)) = lock.subscribers.remove(emitter) {
        subscribers.extend(new_subscribers);
    }
    if !subscribers.is_empty() { lock.subscribers.insert(emitter.clone(), Some(subscribers)); }
}
```
Invokes `f` for every *active*, non-dropped subscriber; the callback's own return (`bool`) controls auto-unsubscribe. `subscribers.take()` at the top temporarily empties the entry so re-entrant `insert`s made *during* a callback (subscribing again from within an observer) land in a fresh bucket merged back afterward.

### `Subscription` handle — RAII unsubscribe (150–194)
```rust
#[must_use]
pub struct Subscription { unsubscribe: Option<Box<dyn FnOnce() + 'static>> }
impl Subscription {
    pub fn new(unsubscribe: impl 'static + FnOnce()) -> Self { ... }
    pub fn detach(mut self) { self.unsubscribe.take(); }
    pub fn join(mut subscription_a: Self, mut subscription_b: Self) -> Self { ... }
}
impl Drop for Subscription {
    fn drop(&mut self) {
        if let Some(unsubscribe) = self.unsubscribe.take() { unsubscribe(); }
    }
}
```
`#[must_use]`; dropping unsubscribes immediately; `.detach()` intentionally leaks it so the callback lives until the *emitter* entity is dropped — the idiom used pervasively as `cx.observe(...).detach()`.

## 2.2 `notify()` full call chain — cx.notify() to actual redraw

**Hop 1 — `Context<T>::notify`** (context.rs:229–231):
```rust
pub fn notify(&mut self) {
    self.app.notify(self.entity_state.entity_id);
}
```

**Hop 2 — `App::notify(entity_id)`** (app.rs:2657–2692, quoted in full in §1.3). Decides fast-path (entity currently rendered by a window → `WindowInvalidator::invalidate_view` directly) vs. slow-path (entity not on-screen → generic `Effect::Notify` on the queue).

**Hop 3a — `WindowInvalidator::invalidate_view`** (window.rs:153–165):
```rust
pub fn invalidate_view(&self, entity: EntityId, cx: &mut App) -> bool {
    let mut inner = self.inner.borrow_mut();
    inner.update_count += 1;
    inner.dirty_views.insert(entity);
    if inner.draw_phase == DrawPhase::None {
        Self::record_frame_dirty(&mut inner);
        inner.dirty = true;
        cx.push_effect(Effect::Notify { emitter: entity });
        true
    } else { false }
}
```
Also pushes `Effect::Notify` (so `observe()` callbacks still fire on the fast path), sets `inner.dirty = true` (window-level "needs redraw"), and inserts into `inner.dirty_views: FxHashSet<EntityId>` (window-level "which entities changed" set — distinct from the app-level `pending_notifications`). If a draw is already in progress (`draw_phase != DrawPhase::None`), skips (re-entrant-notify-during-draw guard).

```rust
// window.rs:117-123
struct WindowInvalidatorInner {
    pub dirty: bool,
    pub draw_phase: DrawPhase,
    pub dirty_views: FxHashSet<EntityId>,
    pub update_count: usize,
    pub frame_dirty: FrameDirtyAccumulator,
}
```

**Hop 4 — `App::push_effect`** (1636–1652, quoted in §1.3) — dedup + enqueue into `pending_effects: VecDeque<Effect>`.

**Hop 5 — `App::flush_effects`** (1657–1713, quoted in §1.3), called from `App::finish_update`. `apply_notify_effect`:
```rust
// app.rs:1760-1766
fn apply_notify_effect(&mut self, emitter: EntityId) {
    self.pending_notifications.remove(&emitter);
    self.observers.clone().retain(&emitter, |handler| handler(self));
}
```
Calls `SubscriberSet::retain` on `self.observers: SubscriberSet<EntityId, Handler>` (`Handler = Box<dyn FnMut(&mut App) -> bool>`), invoking every registered `observe()` callback for that entity. Note: the "auto-draw-dirty-windows-when-queue-empties" branch in `flush_effects` is **only compiled under `test`/`test-support`/`bench` features** — in production, `flush_effects` just leaves `invalidator.dirty = true`; the platform's own frame-request callback later asks the window to redraw.

**Hop 6 — Platform frame callback checks `is_dirty()`** (window.rs:1643–1657, inside `platform_window.on_request_frame(...)`):
```rust
if invalidator.is_dirty() || force_render {
    measure("frame duration", || {
        handle.update(&mut cx, |_, window, cx| {
            if force_render { window.refresh(); }
            let arena_clear_needed = window.draw(cx);
            window.present();
            arena_clear_needed.clear(cx);
        }).log_err();
    })
} else if needs_present { ... }
```

**Hop 7 — `Window::draw`** (window.rs:2807–2933, excerpt):
```rust
pub fn draw(&mut self, cx: &mut App) -> ArenaClearNeeded {
    let frame_dirty = self.invalidator.take_frame_dirty();
    ...
    self.invalidate_entities();                 // walks dirty_views, propagates dirtiness up ancestor chain
    cx.entities.clear_accessed();
    debug_assert!(self.rendered_entity_stack.is_empty());
    self.invalidator.set_dirty(false);           // clears the "needs redraw" flag up front
    ...
    if !cx.mode.skip_drawing() { self.draw_roots(cx); }   // the actual layout/prepaint/paint pass
    self.dirty_views.clear();
    ...
}
fn invalidate_entities(&mut self) {
    let mut views = self.invalidator.take_views();
    for entity in views.drain() { self.mark_view_dirty(entity); }
    self.invalidator.replace_views(views);
}
fn mark_view_dirty(&mut self, view_id: EntityId) {
    // Mark ancestor views as dirty. If already in the `dirty_views` set, all its ancestors
    // should already be dirty.
    for view_id in self.rendered_frame.dispatch_tree.view_path_reversed(view_id) {
        if !self.dirty_views.insert(view_id) { break; }
    }
}
```
`draw_roots` runs `root_element.request_layout(...)` → `.prepaint_as_root(...)` → `.paint(...)` on the **entire root `AnyElement` tree** — the whole element tree from the window's root, not just the notified entity.

## 2.3 The critical fork: default (uncached) vs `.cached()` — the smallest invalidatable unit

`ViewElement<V>` (view.rs:240–498) wraps every `Entity<T: Render>`/`AnyView` in the tree. Default `request_layout` (314–360):
```rust
fn request_layout(...) -> (LayoutId, Self::RequestLayoutState) {
    if let Some(entity_id) = self.entity_id {
        window.with_rendered_view(entity_id, |window| {
            let caching_disabled = window.is_inspector_picking(cx);
            match self.cached_style.as_ref() {
                Some(style) if !caching_disabled => { /* cached path */ }
                _ => {
                    let mut element = self.view.take().unwrap().render(window, cx).into_any_element();
                    let layout_id = element.request_layout(window, cx);
                    (layout_id, Some(element))
                }
            }
        })
    } else { ... }
}
```
**By default (no `.cached()`), `.render(window, cx)` runs unconditionally on every window draw**, regardless of whether that specific entity was the one notified. Since `draw_roots` walks the whole tree from the root every time the window is dirty, and every non-cached `ViewElement` re-invokes `View::render` unconditionally: **any single `cx.notify()` anywhere marks the whole window dirty, and the entire visible view tree's `Render::render()` re-runs on the next frame** — whole-window granularity, not per-entity.

Opt-in finer mechanism: `Entity<T>::cached(style)` / `AnyView::cached(style)` (view.rs:39–41, 223–234). `prepaint` (362–435):
```rust
window.with_element_state::<ViewElementState, _>(global_id.unwrap(), |element_state, window| {
    let content_mask = window.content_mask();
    let text_style = window.text_style();
    if let Some(mut element_state) = element_state
        && element_state.cache_key.bounds == bounds
        && element_state.cache_key.content_mask == content_mask
        && element_state.cache_key.text_style == text_style
        && !window.dirty_views.contains(&entity_id)     // the finer-grained check
        && !window.refreshing
    {
        let prepaint_start = window.prepaint_index();
        window.reuse_prepaint(element_state.prepaint_range.clone());  // replay cached output, skip render()
        cx.entities.extend_accessed(&element_state.accessed_entities);
        let prepaint_end = window.prepaint_index();
        element_state.prepaint_range = prepaint_start..prepaint_end;
        return (None, element_state);
    }
    // else: actually re-render and re-prepaint
})
```
Doc comment (34–38): *"The rendered subtree is recycled from the previous frame unless [Context::notify] was called on the backing entity since it was rendered (or [Window::refresh] is called, which ignores caching)."*

**Answer to "smallest invalidatable unit"**: the default/implicit behavior is whole-window — `cx.notify()` marks the window dirty and the entire visible `Render` tree re-executes. The only finer mechanism is the manually opt-in `.cached(style)` wrapper, which is per-`Entity` (whole subtree, one `EntityId` key — no per-field/per-expression/per-child dependency tracking), doc-noted as *"crate-private on purpose: caching is only sound for entity-backed views, where `Context::notify` is the contract that busts the cache"* (view.rs:266–270). Nothing finer than "one entity's entire render output" exists anywhere.

## 2.4 `observe`/`subscribe`/`observe_global`/`observe_release` — semantics compared

### `observe` — fires on `notify()`, unstructured, no payload
```rust
// app.rs:1082-1095
pub fn observe<W>(&mut self, entity: &Entity<W>, mut on_notify: impl FnMut(Entity<W>, &mut App) + 'static) -> Subscription
where W: 'static,
{ self.observe_internal(entity, move |e, cx| { on_notify(e, cx); true }) }

// app.rs:1142-1146
pub(crate) fn new_observer(&mut self, key: EntityId, value: Handler) -> Subscription {
    let (subscription, activate) = self.observers.insert(key, value);
    self.defer(move |_| activate());
    subscription
}
```
`Context<T>::observe` (context.rs:61–81) is the entity-scoped variant that re-`update`s your own entity when fired. Fires whenever the observed entity's `notify()` is processed via `Effect::Notify` → `apply_notify_effect` — no payload beyond an entity handle; the callback must re-read whatever state it needs.

### `subscribe` — fires on `emit(event)`, structured payload
```rust
// app.rs:1170-1185
pub fn subscribe<T, Event>(&mut self, entity: &Entity<T>, mut on_event: impl FnMut(Entity<T>, &Event, &mut App) + 'static) -> Subscription
where T: 'static + EventEmitter<Event>, Event: 'static,
{ self.subscribe_internal(entity, move |entity, event, cx| { on_event(entity, event, cx); true }) }

// app.rs:1196-1221
pub(crate) fn subscribe_internal<T, Evt>(&mut self, entity: &Entity<T>, mut on_event: impl FnMut(Entity<T>, &Evt, &mut App) -> bool + 'static) -> Subscription
where T: 'static + EventEmitter<Evt>, Evt: 'static,
{
    let entity_id = entity.entity_id();
    let handle = entity.downgrade();
    self.new_subscription(entity_id, (
        TypeId::of::<Evt>(),
        Box::new(move |event, cx| {
            let event: &Evt = event.downcast_ref().expect("invalid event type");
            if let Some(entity) = handle.upgrade() { on_event(entity, event, cx) } else { false }
        }),
    ))
}
```
Stored in `self.event_listeners: SubscriberSet<EntityId, (TypeId, Listener)>` — keyed by `EntityId` like observers, but carrying the event's `TypeId` so multiple event types from the same entity can be filtered per-callback. Requires `T: EventEmitter<Evt>`, compile-time-gated. The callback receives the actual event *value*, not just "something changed" — a structured pub/sub channel, vs. `observe`'s unstructured signal.

### `observe_global` — same unstructured mechanism, `TypeId`-keyed
```rust
// app.rs:2051-2065
pub fn observe_global<G: Global>(&mut self, mut f: impl FnMut(&mut Self) + 'static) -> Subscription {
    let (subscription, activate) = self.global_observers.insert(
        TypeId::of::<G>(),
        Box::new(move |cx| { f(cx); true }),
    );
    self.defer(move |_| activate());
    subscription
}
```
Dispatched via `apply_notify_global_observers_effect` (1789–1794), identical mechanics to `apply_notify_effect` but keyed by `TypeId` rather than `EntityId`. Global changes never auto-mark any window dirty — the observer callback must call `cx.notify()`/`refresh_windows()` itself for a redraw.

### `observe_release` — one-shot, immediate activation (not deferred)
```rust
// app.rs:2117-2136
pub fn observe_release<T>(&self, handle: &Entity<T>, on_release: impl FnOnce(&mut T, &mut App) + 'static) -> Subscription
where T: 'static,
{
    let (subscription, activate) = self.release_listeners.insert(
        handle.entity_id(),
        Box::new(move |entity, cx| {
            let entity = entity.downcast_mut().expect("invalid entity type");
            on_release(entity, cx)
        }),
    );
    activate();   // NOT deferred, unlike observe/subscribe/observe_global
    subscription
}
```
Fired from `App::release_dropped_entities` (1715–1735), called every `flush_effects` loop iteration, using `SubscriberSet::remove` (bulk-drain, strictly one-shot) rather than `retain`.

## 2.5 Confirmation: no finer-grained reactivity primitive exists

Grep of `crates/gpui/src` for `Model`, `signal`, `reactive`, `memo`, `derived`:
- **`Model`**: zero hits — this fork fully renamed the historical `Model<T>` to `Entity<T>`.
- **`signal`**: zero reactivity-related hits.
- **`memo`**: zero hits anywhere.
- **`derived`**: zero hits related to reactive derivation (only unrelated English-word doc-comment uses).
- **`reactive`**: exactly 3 hits, all doc-comment prose in `view.rs` describing the notify→redraw mechanism, not a distinct primitive (e.g. `view.rs:171`: *"A renderable that participates in GPUI's reactive graph — the unifying model behind `Render` and `RenderOnce`."*).

**Conclusion**: GPUI's entire reactivity surface is: (1) `SubscriberSet`/`Subscription` generic pub/sub plumbing, (2) `notify()`/`observe()` unstructured "something changed, re-read" signal, (3) `emit()`/`subscribe()` typed event channel gated by `EventEmitter<E>`, (4) `observe_global()`/`set_global()` same unstructured signal keyed by `TypeId`, (5) `observe_release()`/`on_release()` one-shot teardown notification. The only finer-than-whole-window memoization is the opt-in `.cached(style)` wrapper — whole-subtree, single-`EntityId`-keyed. **There is no per-field, per-signal, per-expression, or fine-grained dependency-tracked reactivity anywhere in this codebase.**

---

# PART 3 — Rendering Pipeline

Scope: `element.rs` (792 lines), `view.rs` (507 lines), `window.rs` (7451 lines, frame lifecycle), `arena.rs` (396 lines), `taffy.rs` (781 lines), `key_dispatch.rs`, `elements/div.rs` (interactive elements — note: `interactive.rs` itself is just event-type definitions; the actual `Interactivity`/dispatch logic lives in `elements/div.rs`).

This fork has diverged from upstream in a way that matters here: it already has a **partial caching layer** (`ViewElement::cached`, `reuse_prepaint`/`reuse_paint`, `dirty_views`) that upstream Zed gpui lacks. A fine-grained-reactivity redesign inherits this scaffolding rather than starting from nothing.

## 3.1 Element trait, IntoElement, AnyElement, RenderOnce

`Element` trait (element.rs:51–142), quoted:
```rust
pub trait Element: 'static + IntoElement {
    type RequestLayoutState: 'static;
    type PrepaintState: 'static;

    fn id(&self) -> Option<ElementId>;
    fn source_location(&self) -> Option<&'static panic::Location<'static>>;

    fn request_layout(
        &mut self,
        id: Option<&GlobalElementId>,
        inspector_id: Option<&InspectorElementId>,
        window: &mut Window,
        cx: &mut App,
    ) -> (LayoutId, Self::RequestLayoutState);

    fn prepaint(
        &mut self,
        id: Option<&GlobalElementId>,
        inspector_id: Option<&InspectorElementId>,
        bounds: Bounds<Pixels>,
        request_layout: &mut Self::RequestLayoutState,
        window: &mut Window,
        cx: &mut App,
    ) -> Self::PrepaintState;

    fn paint(
        &mut self,
        id: Option<&GlobalElementId>,
        inspector_id: Option<&InspectorElementId>,
        bounds: Bounds<Pixels>,
        request_layout: &mut Self::RequestLayoutState,
        prepaint: &mut Self::PrepaintState,
        window: &mut Window,
        cx: &mut App,
    );
    // + a11y_role, write_a11y_info, a11y_synthetic_children, into_any (default impls)
}
```
Three-phase, strictly sequential per element instance, enforced at runtime by `Drawable`'s phase state machine (element.rs:254–286, 297–497): `Start → RequestLayout → Prepaint → Painted`. Out-of-order phase calls panic: `"must call request_layout only once"` (340), `"must call request_layout before prepaint"` (453), `"must call prepaint before paint"` (495).

`IntoElement` (145–157):
```rust
pub trait IntoElement: Sized {
    type Element: Element;
    fn into_element(self) -> Self::Element;
    fn into_any_element(self) -> AnyElement { self.into_element().into_any() }
}
```

`RenderOnce` (179–184) — consumes `self` (unlike `Render`'s `&mut self`):
```rust
pub trait RenderOnce: 'static {
    fn render(self, window: &mut Window, cx: &mut App) -> impl IntoElement;
}
```

`AnyElement` (588–664) — type-erased: `pub struct AnyElement(ArenaBox<dyn ElementObject>)`, constructed by allocating `Drawable<E>` into the per-draw arena (590–599):
```rust
pub(crate) fn new<E>(element: E) -> Self
where E: 'static + Element, E::RequestLayoutState: Any,
{
    let element = with_element_arena(|arena| arena.alloc(|| Drawable::new(element)))
        .map(|element| element as &mut dyn ElementObject);
    AnyElement(element)
}
```
Every element in the tree is arena-allocated fresh, every frame (see §3.4).

## 3.2 `Render` trait and the "does every render() rebuild everything" question

```rust
// element.rs:163-166
pub trait Render: 'static + Sized {
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement;
}
```
Module doc (10–14): *"Elements are constructed by calling `Render::render()` on the root view of the window, which recursively constructs the element tree from the current state of the application... Before the start of the next frame, the entire element tree and any callbacks they have registered with GPUI are dropped and the process repeats."*

`View` (view.rs:182–195) unifies `Render`-backed `Entity<T>` and stateless `RenderOnce` under one abstraction. Blanket impl for the `Render` case:
```rust
impl<T: Render> View for Entity<T> {
    fn entity_id(&self) -> Option<EntityId> { Some(Entity::entity_id(self)) }
    fn render(self, window: &mut Window, cx: &mut App) -> impl IntoElement {
        self.update(cx, |this, cx| { Render::render(this, window, cx).into_any_element() })
    }
}
```

**Answer**: without `.cached()` — i.e. ordinary `.child(entity)` composition — `request_layout` (view.rs:314–360) always takes the branch that unconditionally reconstructs the subtree every frame, regardless of `dirty_views`. With `.cached()`, invalidation is gated on `window.dirty_views.contains(&entity_id)` (§2.3) — a single flag per entity, not per-field.

The window-level draw loop (`Window::draw`, window.rs:2808–2933 → `draw_roots`, 2984–3099) is unconditional whenever it runs at all:
```rust
let mut root_element = self.root.as_ref().unwrap().clone().into_any_element();   // window.rs:3015
let root_layout_id = root_element.request_layout(self, cx);                       // window.rs:3016
...
root_element.prepaint_as_root(Point::default(), root_size.into(), self, cx);      // window.rs:3021
...
root_element.paint(self, cx);                                                     // window.rs:3055
```
Caching, where present, only prunes *inside* this walk at `ViewElement` boundaries — it never skips the walk itself.

## 3.3 Element state persistence: `GlobalElementId` / `with_element_state`

**`GlobalElementId`** (element.rs:211–213):
```rust
#[derive(Deref, DerefMut, Clone, Default, Debug, Eq, PartialEq, Hash)]
pub struct GlobalElementId(pub(crate) Arc<[ElementId]>);
```
A **path of `ElementId`s from the root**, not a stable per-position auto-index. `ElementId` (window.rs:6660–6681) is a key/string/type-based enum: `View(EntityId)`, `Integer(u64)`, `Name(SharedString)`, `Uuid(Uuid)`, `FocusHandle(FocusId)`, `NamedInteger(SharedString, u64)`, `Path(Arc<Path>)`, `CodeLocation(Location<'static>)`, `NamedChild(...)`, `OpaqueId([u8;20])` — supplied explicitly (`.id("foo")`) or synthesized (view identity = `ElementId::View(entity_id)`; stateless component identity = `ElementId::Name(type_name::<V>())`, view.rs:346–348; `use_state`'s default key = `ElementId::CodeLocation(caller location)`, window.rs:3690).

The stack is pushed/popped as ided elements are visited (element.rs:300–303, in `Drawable::request_layout`):
```rust
let global_id = self.element.id().map(|element_id| {
    window.element_id_stack.push(element_id);
    GlobalElementId(Arc::from(&*window.element_id_stack))
});
```
Elements without `.id()` (most primitives) contribute no path segment and are not individually addressable across frames — only their ancestor-with-id's subtree state persists.

**`Window::with_element_state`**, quoted in full (window.rs:3702–3775):
```rust
pub fn with_element_state<S, R>(
    &mut self,
    global_id: &GlobalElementId,
    f: impl FnOnce(Option<S>, &mut Self) -> (R, S),
) -> R
where S: 'static,
{
    self.invalidator.debug_assert_paint_or_prepaint();
    let key = (global_id.clone(), TypeId::of::<S>());
    self.next_frame.accessed_element_states.push(key.clone());

    if let Some(any) = self
        .next_frame.element_states.remove(&key)
        .or_else(|| self.rendered_frame.element_states.remove(&key))
    {
        // ... downcast, panics on type mismatch for same id
        let state = state_box.take().expect(
            "reentrant call to with_element_state for the same state type and element id",
        );
        let (result, state) = f(Some(state), self);
        state_box.replace(state);
        self.next_frame.element_states.insert(key, ElementStateBox { inner: state_box, .. });
        result
    } else {
        let (result, state) = f(None, self);
        self.next_frame.element_states.insert(key, ElementStateBox { inner: Box::new(Some(state)), .. });
        result
    }
}
```
Backing storage: `pub(crate) element_states: FxHashMap<(GlobalElementId, TypeId), ElementStateBox>` (window.rs:910) — a plain hash map, one per `Frame` (`rendered_frame`/`next_frame`, swapped each draw: `window.rs:2869 mem::swap(&mut self.rendered_frame, &mut self.next_frame)`). This underlies `Window::use_state`/`use_keyed_state` (window.rs:3684–3694, 3660–3676) and `Interactivity`'s `InteractiveElementState` (hover/click/scroll state, `div.rs:2093–2108, 2138–2159`).

### Where this breaks (stale state / reordering)
1. **Reordering without stable keys**: reordering a positionally-keyed list swaps which physical state each logical item gets (classic "index as key" bug) — GPUI mitigates this only where callers supply explicit `ElementId::Integer`/`Name`/`NamedInteger` keys; `with_element_state` itself does nothing to detect collisions on reorder.
2. **Reentrancy / duplicate ids**: `"reentrant call to with_element_state for the same state type and element id"` panic (window.rs:3749–3751) fires if two elements in the same frame compute an identical `GlobalElementId` and both call `with_element_state::<S,_>` — the framework's only defense, and it's a panic.
3. **View-id collisions — documented, silent footgun**: `View::entity_id` doc (view.rs:182–195): *"two views keyed on the same entity must not be rendered at the same position in the element tree (e.g. as siblings under the same parent): their internal element state (use_state, scroll offsets, etc.) would silently collide."*
4. **Cache staleness for `.cached()` views**: cache key is bounds/mask/text-style-based; invalidated by `dirty_views` membership or `window.refreshing`. Reading a `Global` or an untracked entity during a cached render could go stale without going through `cx.notify()` on the tracked entity — mitigated specifically for entity reads via `accessed_entities` tracking (view.rs:395–396, 405, 423), not for globals.

## 3.4 Arena: allocation and lifetime model (`arena.rs`)

Bump allocator, chunked storage (`Chunk::allocate`, 55–74), per-element drop glue (`ArenaElement { value: *mut u8, drop: unsafe fn(*mut u8) }`, 10–20).

- **What's allocated per frame**: every `AnyElement` (every div, text, custom element, `ViewElement` wrapper) is arena-allocated via `Arena::alloc` (161–210), called from `AnyElement::new`. Happens on every draw for every non-cached element.
- **Clearing, unless scoped**: `Arena::clear()` (139–148):
```rust
pub fn clear(&mut self) {
    if self.scope_depth == 0 { self.force_clear(); }
    else { log::debug!("deferring arena clear; {} enclosing scope(s) still active", self.scope_depth); }
}
```
  `force_clear` (150–158) drops everything via stored destructors, resets chunk offsets. `begin_scope`/`end_scope` (112–131) support re-entrant draws (nested window procedures, opening a window mid-draw) — wired via `ElementArenaScope` in `window.rs:297–393`, entered at `window.rs:2816` and exited at `window.rs:2932`, returning an `ArenaClearNeeded` token the caller must invoke.
- **Use-after-clear safety**: `ArenaBox<T>` (213–252) validates a shared `Rc<Cell<bool>>` flag on every deref (227–233), panicking `"attempted to dereference an ArenaRef after its Arena was cleared"` post-clear (confirmed by `test_arena_use_after_clear`, 328–336).
- **Net effect**: elements are cheap, short-lived, arena-allocated, and intentionally *not* meant to persist. Persistent state lives separately in `Window::element_states` (a `HashMap`) and in `Entity<T>` (the observable store, via `cx.notify`). The arena's "clear everything every frame" model is fundamentally at odds with fine-grained incremental re-rendering unless persistence goes entirely through the `with_element_state`/entity layer, with the element tree treated as purely ephemeral paint output — which is exactly the model `.cached()` partially routes around by skipping tree construction, not by skipping arena use (reused ranges still read from `rendered_frame`, they don't re-enter the arena for that subtree).

## 3.5 Taffy integration: full rebuild every frame

`TaffyLayoutEngine` (taffy.rs) wraps `taffy::TaffyTree<NodeContext>` (line 35).

- **Full clear every frame**: `TaffyLayoutEngine::clear()` (58–63):
```rust
pub fn clear(&mut self) {
    self.taffy.clear();
    self.absolute_layout_bounds.clear();
    self.absolute_outer_origins.clear();
    self.computed_layouts.clear();
}
```
  Called unconditionally in the draw loop: `window.rs:2862 self.layout_engine.as_mut().unwrap().clear();` — right after `draw_roots`, before frame-swap. Wipes the **entire** Taffy tree every draw.
- **Node creation**: `TaffyLayoutEngine::request_layout` (65–86) always calls `self.taffy.new_leaf(...)`/`new_with_children(...)` — brand-new `NodeId`s every call, every frame; no lookup-by-previous-node/memoization inside the layout engine itself.
- **No cross-frame node reuse mechanism exists in taffy.rs.** The only "skip creating nodes" lever anywhere is the `ViewElement::cached` path, which for a cached view creates exactly **one** Taffy leaf node from `style` (view.rs:326–330) instead of walking into `render()` and creating nodes for the whole subtree — caching prevents Taffy tree growth for that subtree, it doesn't reuse prior nodes.
- Consequence: **every draw rebuilds the entire Taffy tree from scratch and recomputes layout for the whole (non-cached) subtree.** `compute_layout` (191–273) runs per root during `layout_as_root`/`prepaint_as_root` (element.rs:499–549); `computed_layouts` (a `FxHashSet<LayoutId>`, cleared every frame) only dedupes redundant calls to the *same* `LayoutId` within one frame, never across frames.

## 3.6 Listener registration & dispatch (on_click / on_mouse_down etc.)

**Storage** — `Interactivity` fields (`elements/div.rs:2007–2080`):
```rust
pub struct Interactivity {
    pub element_id: Option<ElementId>,
    ...
    pub(crate) mouse_down_listeners: Vec<MouseDownListener>,
    pub(crate) mouse_up_listeners: Vec<MouseUpListener>,
    pub(crate) mouse_pressure_listeners: Vec<MousePressureListener>,
    pub(crate) mouse_move_listeners: Vec<MouseMoveListener>,
    pub(crate) mouse_exit_listeners: Vec<MouseExitListener>,
    pub(crate) scroll_wheel_listeners: Vec<ScrollWheelListener>,
    pub(crate) pinch_listeners: Vec<PinchListener>,
    pub(crate) key_down_listeners: Vec<KeyDownListener>,
    pub(crate) key_up_listeners: Vec<KeyUpListener>,
    pub(crate) action_listeners: Vec<(TypeId, ActionListener)>,
    pub(crate) click_listeners: Vec<ClickListener>,
    pub(crate) aux_click_listeners: Vec<ClickListener>,
    pub(crate) drag_listener: Option<DragListener>,
    pub(crate) hover_listener: Option<Box<dyn Fn(&bool, &mut Window, &mut App)>>,
    ...
}
```
Registered fresh every frame by builder methods, e.g. `on_click` (566–573):
```rust
pub fn on_click(&mut self, listener: impl Fn(&ClickEvent, &mut Window, &mut App) + 'static)
where Self: Sized,
{
    self.click_listeners.push(Rc::new(move |event, window, cx| { listener(event, window, cx) }));
}
```
`on_mouse_down` (122–136), with the button/phase/hover check baked in:
```rust
pub fn on_mouse_down(&mut self, button: MouseButton, listener: impl Fn(&MouseDownEvent,&mut Window,&mut App)+'static) {
    self.mouse_down_listeners.push(Box::new(move |event, phase, hitbox, window, cx| {
        if phase == DispatchPhase::Bubble && event.button == button && hitbox.is_hovered(window) {
            (listener)(event, window, cx)
        }
    }));
}
```
Closures are **rebuilt from scratch every render call** since `div()` returns a fresh struct each frame — no cross-frame reuse of the `Vec<...>`.

**Transfer to the window's per-frame listener list** — `Interactivity::paint_mouse_listeners` drains each `Vec` and re-wraps into `Window::on_mouse_event` calls (2681–2686):
```rust
for listener in self.mouse_down_listeners.drain(..) {
    let hitbox = hitbox.clone();
    window.on_mouse_event(move |event: &MouseDownEvent, phase, window, cx| {
        listener(event, phase, &hitbox, window, cx);
    })
}
```
`Window::on_mouse_event` (window.rs:4890–4903) pushes into a **flat, unordered-by-tree-position Vec** for the frame:
```rust
pub fn on_mouse_event<Event: MouseEvent>(&mut self, mut listener: impl FnMut(&Event, DispatchPhase, &mut Window, &mut App) + 'static) {
    self.next_frame.mouse_listeners.push(Some(Box::new(
        move |event: &dyn Any, phase: DispatchPhase, window: &mut Window, cx: &mut App| {
            if let Some(event) = event.downcast_ref() { listener(event, phase, window, cx) }
        },
    )));
}
```
Backing field: `pub(crate) mouse_listeners: Vec<Option<AnyMouseListener>>` (window.rs:912). Order equals paint order (depth-first, parent-before-child) — there is no actual tree structure for mouse dispatch, unlike keyboard/action dispatch.

**Hit-testing** is separate from listener registration: `Window::insert_hitbox` (window.rs:4773–4787) pushes `Hitbox { id, bounds, content_mask, behavior }` during prepaint. `Frame::hit_test` (1022–1044) walks `hitboxes.iter().rev()` (topmost/last-painted first), honoring `HitboxBehavior::BlockMouse`/`BlockMouseExceptScroll` occlusion.

**Dispatch** — `Window::dispatch_mouse_event`, quoted (window.rs:5226–5282):
```rust
fn dispatch_mouse_event(&mut self, event: &dyn Any, cx: &mut App) {
    let hit_test = self.rendered_frame.hit_test(self.mouse_position());
    if hit_test != self.mouse_hit_test { self.mouse_hit_test = hit_test; self.reset_cursor_style(cx); }
    ...
    let mut mouse_listeners = mem::take(&mut self.rendered_frame.mouse_listeners);
    // Capture phase, events bubble from back to front.
    for listener in &mut mouse_listeners {
        let listener = listener.as_mut().unwrap();
        listener(event, DispatchPhase::Capture, self, cx);
        if !cx.propagate_event { break; }
    }
    // Bubble phase, where most normal handlers do their work.
    if cx.propagate_event {
        for listener in mouse_listeners.iter_mut().rev() {
            let listener = listener.as_mut().unwrap();
            listener(event, DispatchPhase::Bubble, self, cx);
            if !cx.propagate_event { break; }
        }
    }
    self.rendered_frame.mouse_listeners = mouse_listeners;
    ...
}
```
Not tree-walk dispatch — a flat list in paint order, iterated forward for capture and reversed for bubble; each listener re-checks `hitbox.is_hovered(window)` against the precomputed hit-test snapshot; `cx.propagate_event`/`stop_propagation()` short-circuits.

Keyboard/action dispatch, by contrast, **is tree-based**: `DispatchTree` (key_dispatch.rs:71–91) with real parent/child `DispatchNode`s, rebuilt every frame via `push_node`/`pop_node` during `Drawable::prepaint` (element.rs:403, 412), except where a cached view's prepaint range is reused, in which case `DispatchTree::reuse_subtree` (key_dispatch.rs:264–306) splices matching nodes from `rendered_frame` — note the doc comment on `DispatchNodeId` (66–69): *"these are not stable between frames."*

## 3.7 Cost for a single piece of state changing — evidence-based trace

1. `App::notify` looks up window invalidators tracking the entity, calls `invalidator.invalidate_view(entity_id, self)` → marks window dirty, adds entity to `dirty_views`.
2. Next `draw()`: `invalidate_entities()` (window.rs:2949–2955) walks `dirty_views`, calls `mark_view_dirty`, which propagates dirtiness **up the ancestor view chain** until an already-dirty ancestor is hit — one entity's `notify()` marks itself *and every ancestor view* dirty.
3. `draw_roots` unconditionally reconstructs the **entire window's element tree from the root** — no partial/subtree-only draw entry point exists at the window level.
4. At each `ViewElement` boundary walking down: if **not** `.cached(...)` (the common/default case), `Render::render` runs unconditionally regardless of whether that entity is in `dirty_views` — full re-render, full arena reallocation, full Taffy node recreation, full re-prepaint/paint, even for entities whose state did NOT change, as long as they're descendants of the redrawn root. If **`.cached(...)`**, only views whose `entity_id ∈ dirty_views` (or `window.refreshing`, or changed bounds/mask/text-style) re-render; others replay recorded hitboxes/scene-primitives/dispatch-tree-slice/mouse-listeners from `rendered_frame` — no re-render, no Taffy work, no arena construction for that subtree.
5. Taffy's `layout_engine.clear()` wipes the **whole** tree every draw regardless of what changed — even a cached subtree's ancestors and the root get fresh Taffy nodes and a fresh `compute_layout` walk; only the cached subtree's *internal* nodes are skipped (one leaf node stands in for it).
6. Paint: the changed subtree's primitives are recomputed and re-pushed into `next_frame.scene`; uncached ancestors above it also repaint.

**Bottom line**: without `.cached()` anywhere in the ancestor chain (the common/default composition style), a single state change causes the entire window's `draw()` to re-walk from the root, re-running `request_layout`/`prepaint`/`paint` on every element (freshly arena-allocated) even where the underlying `Render::render()` output would be identical, and rebuilding the entire Taffy layout tree from scratch. With `.cached()` used deliberately, cost shrinks to re-render+relayout+reprepaint+repaint for exactly the `dirty_views` entities transitively up through ancestors — caching only helps for parts of the tree that are *not* ancestors of the changed entity. **There is no mechanism anywhere in this pipeline for skipping work below the granularity of "one `Entity`'s subtree"** — no dependency tracking of individual reads/writes inside a `render()` call, no memoization of individual elements by prop equality, no signal/derived-value graph.

---

# PART 4 — Styling System

Scope: `style.rs` (1641 lines), `styled.rs` (963 lines), `gpui_refineable/src/refineable.rs` (132 lines), `gpui_derive_refineable/src/derive_refineable.rs` (548 lines), `transition.rs` (756 lines), `elements/div.rs` (hover/active/focus/group application).

## 4.1 `StyleRefinement` + `Refineable`: the "cascade" model

`Refineable` trait (`gpui_refineable/src/refineable.rs:29–64`):
```rust
pub trait Refineable: Clone {
    type Refinement: Refineable<Refinement = Self::Refinement> + IsEmpty + Default;
    /// Applies the given refinement to this instance, modifying it in place.
    /// Only non-empty values in the refinement are applied.
    fn refine(&mut self, refinement: &Self::Refinement);
    /// Returns a new instance with the refinement applied
    fn refined(self, refinement: Self::Refinement) -> Self;
    fn from_cascade(cascade: &Cascade<Self>) -> Self
    where Self: Default + Sized,
    { Self::default().refined(cascade.merged()) }
    fn is_superset_of(&self, refinement: &Self::Refinement) -> bool;
    fn subtract(&self, refinement: &Self::Refinement) -> Self::Refinement;
}
```
`Style` is declared `#[derive(Clone, Refineable, Debug)] #[refineable(Debug, PartialEq, Serialize, Deserialize, JsonSchema)] pub struct Style { ... }` (style.rs:178–180). The derive generates a sibling `StyleRefinement` where every non-`#[refineable]` field is `Option<T>`, and every `#[refineable]`-tagged field (e.g. `padding: Edges<DefiniteLength>`, style.rs:248) gets its own generated `...Refinement` type.

**The cascade in practice is linear and hardcoded**: a base `Style::default()` gets `.refine(&refinement)` called on it repeatedly in a fixed call order (§4.4) — CSS-like "later rule wins, `None` falls through" semantics resolved by *sequential explicit mutation calls*, not a generic prioritized pass. There **is** a generic `Cascade<S: Refineable>` container (`gpui_refineable/src/refineable.rs:80–132`, doc: *"styles from different sources... are combined with specific precedence rules"*) supporting priority-ordered slots (`reserve()`, `set()`, `merged()`), but **grepping the whole `gpui` crate confirms `Cascade<...>` is never instantiated for `Style`/`StyleRefinement`** — hover/active/focus/group merging in `div.rs` bypasses it entirely, calling `style.refine(...)` directly in sequence. The priority-slot abstraction exists in the dependency but isn't wired into the interactive-style pipeline.

Test showing merge semantics (style.rs:1625–1640):
```rust
let mut style = Style::default();
style.refine(&StyleRefinement::default().text_size(px(20.0)));
style.refine(&StyleRefinement::default().font_weight(FontWeight::SEMIBOLD));
assert_eq!(Some(AbsoluteLength::from(px(20.0))), style.text_style().unwrap().font_size);
assert_eq!(Some(FontWeight::SEMIBOLD), style.text_style().unwrap().font_weight);
```

## 4.2 What `#[derive(Refineable)]` generates

Wrapper strategy per field (`get_wrapper_type`, 524–548): `#[refineable]` field → nested `FooRefinement`; already `Option<T>` → stays `Option<T>`; plain `T` → becomes `Option<T>`.

Generated body per field (`refineable_refine_assignments`, 104–129):
```rust
if is_refineable {
    quote! { self.#name.refine(&refinement.#name); }
} else if is_optional {
    quote! { if let Some(value) = &refinement.#name { self.#name = Some(value.clone()); } }
} else {
    quote! { if let Some(value) = &refinement.#name { self.#name = value.clone(); } }
}
```
For `Style`, this mechanically unrolls over **every one of ~40 fields**. This code is emitted at compile time by the final `quote!` block (391–503: `struct #refinement_ident`, `impl Refineable for #ident`, `impl Refineable for #refinement_ident`, `impl IsEmpty for #refinement_ident`, `impl From<#refinement_ident> for #ident`, `impl Default for #refinement_ident`).

**Implication for a fine-grained-reactivity redesign**: `refine()` unconditionally walks *every field* regardless of whether that field actually differs (only checks `is_some()`, never "did the value change from what's currently in `self`") — **there is no per-field dirty/changed detection anywhere in this generated code**. Adding it would require either hand-modifying the derive macro's assignment closures to emit `if refinement.#name != Some(self.#name) { dirty.insert(FieldId::#name); }`, or wrapping each field in a tracked cell — mechanical (the macro already enumerates every field name/type) but touches a widely-used derive (also used for `TextStyle`, `GridTemplate`, `UnderlineStyle`, `StrikethroughStyle`, and generically by consumers outside `gpui` itself, e.g. settings/theme crates). `IsEmpty` is generated as an AND-chain over all fields (256–274) — O(fields), no bitset of "which fields are set" exists anywhere; presence is only discoverable by re-scanning all fields.

## 4.3 `Styled` trait method soup

```rust
pub trait Styled: Sized {
    fn style(&mut self) -> &mut StyleRefinement;
    gpui_macros::style_helpers!();
    gpui_macros::visibility_style_methods!();
    gpui_macros::margin_style_methods!();
    gpui_macros::padding_style_methods!();
    ...
}
```
Every builder method: `self -> mut self.style().<field> = Some(value); self` — consumes-by-value, self-returning, pure overwrite, no diffing/dirty flag. Hand-written examples:
```rust
fn flex(mut self) -> Self {                       // styled.rs:92
    self.style().display = Some(Display::Flex);
    self
}
fn bg<F>(mut self, fill: F) -> Self                // styled.rs:549
where F: Into<Fill>, Self: Sized {
    self.style().background = Some(fill.into());
    self
}
fn text_color(mut self, color: impl Into<Hsla>) -> Self {   // styled.rs:573
    self.text_style().color = Some(color.into());
    self
}
```
`.p_4()` etc. are macro-generated by `crates/gpui_macros/src/styles.rs`, table-driven: prefix table (751–762, e.g. `BoxStylePrefix { prefix: "p", fields: vec![padding.top, padding.bottom, padding.left, padding.right], ... }`) × suffix table (968–972, e.g. `BoxStyleSuffix { suffix: "4", length_tokens: quote!{ rems(1.) }, ... }`), expanded by `generate_predefined_setter` (623–663) into:
```rust
fn p_4(mut self) -> Self {
    let style = self.style();
    style.padding.top = Some((gpui::rems(1.)).into());
    style.padding.bottom = Some((gpui::rems(1.)).into());
    style.padding.left = Some((gpui::rems(1.)).into());
    style.padding.right = Some((gpui::rems(1.)).into());
    self
}
```
Same "mutate refinement field, return self" pattern as hand-written methods, just stamped across a cartesian product of ~15 box-model prefixes × ~30 length suffixes (padding, margin, position, corner radii, border widths all reuse this generator).

## 4.4 Hover / Active / Focus / Group-hover: WHEN and HOW OFTEN

State fields on `Interactivity` (div.rs:2031–2042):
```rust
pub(crate) focus_style: Option<Box<StyleRefinement>>,
pub(crate) in_focus_style: Option<Box<StyleRefinement>>,
pub(crate) hover_style: Option<Box<StyleRefinement>>,
pub(crate) group_hover_style: Option<GroupStyle>,
pub(crate) active_style: Option<Box<StyleRefinement>>,
pub(crate) group_active_style: Option<GroupStyle>,
...
pub(crate) group_drag_over_styles: Vec<(TypeId, GroupStyle)>,
```
`GroupStyle` (53–60): `{ group: SharedString, style: Box<StyleRefinement> }`.

**`Interactivity::compute_style_internal`** — the merge function, quoted in full (div.rs:3273–3393):
```rust
fn compute_style_internal(
    &self,
    hitbox: Option<&Hitbox>,
    element_state: Option<&mut InteractiveElementState>,
    window: &mut Window,
    cx: &mut App,
) -> Style {
    let mut style = Style::default();
    style.refine(&self.base_style);

    if let Some(focus_handle) = self.tracked_focus_handle.as_ref() {
        if let Some(in_focus_style) = self.in_focus_style.as_ref()
            && focus_handle.within_focused(window, cx)
        { style.refine(in_focus_style); }
        if let Some(focus_style) = self.focus_style.as_ref()
            && focus_handle.is_focused(window)
        { style.refine(focus_style); }
        if let Some(focus_visible_style) = self.focus_visible_style.as_ref()
            && focus_handle.is_focused(window)
            && window.last_input_was_keyboard()
        { style.refine(focus_visible_style); }
    }

    if !cx.has_active_drag() {
        if let Some(group_hover) = self.group_hover_style.as_ref() {
            let is_group_hovered = if let Some(group_hitbox_id) = GroupHitboxes::get(&group_hover.group, cx) {
                group_hitbox_id.is_hovered(window)
            } else { false };
            if is_group_hovered { style.refine(&group_hover.style); }
        }
        if let Some(hover_style) = self.hover_style.as_ref() {
            let is_hovered = if let Some(hitbox) = hitbox {
                hitbox.is_hovered(window)
            } else { false };
            if is_hovered { style.refine(hover_style); }
        }
    }

    if let Some(hitbox) = hitbox { /* drag-over group/element styles refined here too */ }

    if let Some(element_state) = element_state {
        let clicked_state = element_state.clicked_state.get_or_insert_with(Default::default).borrow();
        if clicked_state.group && let Some(group) = self.group_active_style.as_ref() { style.refine(&group.style) }
        if let Some(active_style) = self.active_style.as_ref() && clicked_state.element { style.refine(active_style) }
    }
    style
}
```

**This function is invoked from all three per-element frame phases, unconditionally, every time:**
- `Interactivity::request_layout` — div.rs:2198
- `Interactivity::prepaint` — div.rs:2263
- `Interactivity::paint` — div.rs:2415

**For every `div`, `compute_style_internal` — allocating a fresh `Style::default()` and re-running the entire refinement chain — runs three separate times per frame**, once per phase. No caching of the merged `Style` between phases (each call restarts from `Style::default()`) and none across frames.

**Hover detection**: `HitboxId::is_hovered` (window.rs:706–722):
```rust
pub fn is_hovered(self, window: &Window) -> bool {
    if window.captured_hitbox == Some(self) { return true; }
    if window.last_input_was_keyboard() { return false; }
    self.hit_test(window)
}
fn hit_test(self, window: &Window) -> bool {
    let hit_test = &window.mouse_hit_test;
    for id in hit_test.ids.iter().take(hit_test.hover_hitbox_count) {
        if self == *id { return true; }
    }
    false
}
```
`window.mouse_hit_test` recomputed once per redrawn frame (window.rs:3051) and eagerly on every raw mouse-move platform event (5226–5231). `is_hovered()` is cheap but gives no signal about whether a *particular* element's hover-derived style actually changed — that's determined separately.

**What actually triggers re-render on hover change** — a dedicated `on_mouse_event` closure comparing this frame's hover state to last (div.rs:2730–2778):
```rust
window.on_mouse_event(move |_: &MouseMoveEvent, phase, window, cx| {
    let hovered = hitbox.is_hovered(window);
    let was_hovered = hover_state.as_ref().is_some_and(|state| state.borrow().element);
    if phase == DispatchPhase::Capture && hovered != was_hovered {
        if let Some(hover_state) = &hover_state {
            hover_state.borrow_mut().element = hovered;
            cx.notify(current_view);   // the only invalidation signal
        }
    }
});
```
GPUI's invalidation granularity here is **the enclosing `View`/entity**, not the individual styled `div`. Once notified, the whole view subtree re-renders/re-lays-out/re-paints and `compute_style_internal` re-runs (3×) for every div in it, hovered or not.

## 4.5 Group hover mechanics — a paint-order-dependent global

`GroupHitboxes` (div.rs:3839–3863), keyed by group-name string:
```rust
pub(crate) struct GroupHitboxes(HashMap<SharedString, SmallVec<[HitboxId; 1]>>);
impl Global for GroupHitboxes {}
impl GroupHitboxes {
    pub fn get(name: &SharedString, cx: &mut App) -> Option<HitboxId> {
        cx.default_global::<Self>().0.get(name).and_then(|s| s.last()).cloned()
    }
    pub fn push(name: SharedString, hitbox_id: HitboxId, cx: &mut App) { ... }
    pub fn pop(name: &SharedString, cx: &mut App) { ... }
}
```
An ancestor with `.group("card")` pushes its own hitbox id onto this **global** stack during paint (div.rs:2470–2472); descendants with `.group_hover("card", ...)` look it up in `compute_style_internal`. Because paint is depth-first parent-before-children, this is a **paint-order-dependent, name-keyed global**, not a parent→child data-flow relationship — coupling across unrelated subtrees is possible only via matching group-name strings, fully re-derived every frame with no cross-frame persistence.

## 4.6 Transition/animation: per-frame wall-clock interpolation (`transition.rs`)

`Transition<T>` holds a `RefCell<Option<T>> cached_value` (single-frame cache only) plus an `Entity<TransitionState<T>>` (`start_goal`/`end_goal`/`goal_last_updated_at`/`last_delta`).

`raw_evaluate` (99–120):
```rust
fn raw_evaluate(&self, cx: &mut App) -> (bool, T) {
    let mut state_entity = self.state.as_mut(cx);
    let state: &mut TransitionState<T> = state_entity.borrow_mut();
    let elapsed_secs = state.goal_last_updated_at
        .unwrap_or_else(|| self.default_goal_updated_at())
        .elapsed().as_secs_f32();
    let delta = (self.easing)((elapsed_secs / self.duration_secs).min(1.));
    state.last_delta = delta;
    let evaluated_value = state.start_goal.lerp(&state.end_goal, delta);
    (delta != 1., evaluated_value)
}
```
`evaluate()` (131–143), the self-perpetuating tick mechanism:
```rust
pub fn evaluate(&self, window: &mut Window, cx: &mut App) -> Ref<'_, T> {
    if self.cached_value.borrow().is_none() {
        let (in_progress, evaluated_value) = self.raw_evaluate(cx);
        if in_progress { window.request_animation_frame(); }
        *self.cached_value.borrow_mut() = Some(evaluated_value);
    }
    Ref::map(self.cached_value.borrow(), |opt| opt.as_ref().unwrap())
}
```
```rust
// window.rs:2351-2354
pub fn request_animation_frame(&self) {
    let entity = self.current_view();
    self.on_next_frame(move |_, cx| cx.notify(entity));
}
```
Interpolation is wall-clock-based (elapsed real time since `goal_last_updated_at`), recomputed fresh on every `evaluate()` call (cached only for the current render pass — "cached for the duration of the current frame to avoid redundant calculations when called multiple times," line 129–130), and self-perpetuating: while `delta != 1.0`, each evaluation schedules `cx.notify(entity)` for the next frame, forcing `Render::render` (and `evaluate()`) to run again — **a continuous re-render loop for the animation's duration, driven by the same coarse view-level `cx.notify` used for hover.** No independent animation scheduler patches only the animated field into a persistent scene graph.

`update()` (183–209) explicitly documents the manual-notify contract: *"Note: This method does not automatically notify GPUI of changes. You should call `cx.notify()` within the closure if you want to trigger a re-render."*

## 4.7 Conclusion: no style memoization anywhere

1. `compute_style_internal` always starts from `Style::default()` — no early-return, no "has anything changed" check, no memo table.
2. Called independently from `request_layout`, `prepaint`, `paint` — **three full re-derivations per div per frame**, even when nothing about that div's interactive state changed.
3. `Refineable::refine`/`refined`/`is_superset_of`/`subtract` are O(total fields) unconditional walks — no bitmask/dirty-set representation exists for downstream code to exploit.
4. `Cascade<S>` — the one abstraction purpose-built for efficient priority-ordered incremental merging — is unused in `gpui`'s own hover/focus/active pipeline; `div.rs` reimplements "later wins" ad hoc.
5. `Transition::cached_value` is explicitly single-frame, reset whenever a fresh evaluation cycle starts (`jump_to`/`reset`/`scale_by` all clear it).
6. The only invalidation signal anywhere in this chain is `cx.notify(entity)` on a whole `Entity`/view — used identically by hover-change detection and by `Transition::evaluate`'s `request_animation_frame()`.

**Net**: exactly one invalidation granularity (per-`Entity`/view via `cx.notify`), zero style-level memoization or dirty-field tracking below that. Every styled element pays the full "walk every field of `Style`, refine base + up to 5 (focus/in-focus/focus-visible/group-hover/hover) + up to 2 (drag) + up to 2 (active/group-active)" cost, ×3 for layout/prepaint/paint, per frame. The derive macro is a clean, mechanical field-enumerating generator — a natural insertion point for per-field change tracking (e.g. a parallel bitset/generation-counter alongside `refine`) — but no such tracking exists today.

---

# PART 5 — Text/Input, Async & Scheduling, gpui_elements

## 5.1 Text shaping architecture (`text_system.rs` + `text_system/`)

`crates/gpui/src/text_system/`: `font_fallbacks.rs`, `font_features.rs`, `line.rs` (37KB, `ShapedLine`/`WrappedLine`), `line_layout.rs` (36KB, `LineLayout`/`WrappedLineLayout` + the shaping cache), `line_wrapper.rs` (57KB, word-wrap). `TextSystem` (text_system.rs:49) holds font metadata and a glyph raster-bounds cache, delegating shaping to `platform_text_system: Arc<dyn PlatformTextSystem>`.

**A per-frame, content-addressable shaping cache exists**: `FrameCache` (text_system/line_layout.rs:399), keyed by `(text, font_size, runs, wrap_width, force_width)`:
```rust
// line_layout.rs:577
pub fn layout_line<Text>(
    &self,
    text: Text,
    font_size: Pixels,
    runs: &[FontRun],
    force_width: Option<Pixels>,
) -> Arc<LineLayout>
```
checks `current_frame.lines` then `previous_frame.lines` (double-buffered, so unchanged text carries over frame-to-frame without reshaping), calling `platform_text_system.layout_line(...)` only on a genuine miss. There's also a **hash-keyed, non-allocating probe path** (line_layout.rs:632, `try_layout_line_by_hash`/`layout_line_by_hash`) explicitly designed so callers (like editable-text) can check for a cache hit without materializing a contiguous `SharedString` for the whole document — large/rope-backed text doesn't need to be copied just to probe the cache.

**Style → TextRun**: `TextStyle::to_run(&self, len: usize) -> TextRun` (style.rs:646) converts the ambient `TextStyle` into `TextRun{ len, font, color, background_color, underline, strikethrough, letter_spacing }`. The `Text` element builds `Vec<TextRun>` via `compute_runs` (elements/text.rs:454), splicing per-range `HighlightStyle` overrides onto `default_style` before shaping.

**Reshaping trigger model**: shaping is keyed purely on text+style content, with no "dirty" flag from the framework — a cache hit is free if identical; any character change produces a different cache key and forces full re-shape of that line on the next paint. No incremental/partial-line diffing exists at this layer.

## 5.2 `crates/gpui/src/input.rs` (233 lines) — IME bridge

```rust
// input.rs:10
pub trait EntityInputHandler: 'static + Sized {
    fn text_for_range(&mut self, range: Range<usize>, adjusted_range: &mut Option<Range<usize>>, window: &mut Window, cx: &mut Context<Self>) -> Option<String>;
    fn selected_text_range(&mut self, ignore_disabled_input: bool, window: &mut Window, cx: &mut Context<Self>) -> Option<UTF16Selection>;
    fn marked_text_range(&self, window: &mut Window, cx: &mut Context<Self>) -> Option<Range<usize>>;
    fn unmark_text(&mut self, window: &mut Window, cx: &mut Context<Self>);
    fn replace_text_in_range(&mut self, range: Option<Range<usize>>, text: &str, window: &mut Window, cx: &mut Context<Self>);
    fn replace_and_mark_text_in_range(&mut self, range: Option<Range<usize>>, new_text: &str, new_selected_range: Option<Range<usize>>, window: &mut Window, cx: &mut Context<Self>);
    fn bounds_for_range(&mut self, range_utf16: Range<usize>, element_bounds: Bounds<Pixels>, window: &mut Window, cx: &mut Context<Self>) -> Option<Bounds<Pixels>>;
    fn character_index_for_point(&mut self, point: crate::Point<Pixels>, window: &mut Window, cx: &mut Context<Self>) -> Option<usize>;
    fn set_selected_text_range(&mut self, _range_utf16: Range<usize>, _window: &mut Window, _cx: &mut Context<Self>) {}
    fn text_length_utf16(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> Option<usize> { None }
    fn accepts_text_input(&self, _window: &mut Window, _cx: &mut Context<Self>) -> bool { true }
}
```
`ElementInputHandler<V: EntityInputHandler>` (input.rs:100) adapts this for the platform layer — every method is `self.view.update(cx, |view, cx| view.some_method(...))`, i.e. **every IME callback is an `Entity<V>::update`**, going through the normal mutation/notify path. The handler is registered fresh on every paint pass.

## 5.3 `crates/gpui_elements/src/editable_text/` — data flow

**Architecture**: a single, large `Entity<EditableTextState>` per input, keyed by `ElementId`, lazily created and cached across frames via `window.use_keyed_state` — not per-render local state, not `RenderOnce`.

```rust
// state.rs:62
pub struct EditableTextState {
    storage: Box<dyn UnicodeTextStorage>,      // pluggable text backend
    selected_range: CaretSelection,
    marked_range: Option<Range<usize>>,        // IME composition range
    is_selecting: bool,
    last_click_position: Option<Point<Pixels>>,
    click_count: usize,
    focus_handle: FocusHandle,                 // element owns its own FocusHandle
    history: Option<EditableTextHistory>,
    pub(super) layout_data: EditableTextLayoutResult,
}
```
Attachment (state.rs:117, 137):
```rust
pub fn use_keyed(key: impl Into<ElementId>, window: &mut Window, cx: &mut App) -> Entity<Self> {
    Self::use_keyed_init(key, window, cx, |_, _| StringStorage::default())
}
pub fn use_keyed_init<F, StorageType>(key: impl Into<ElementId>, window: &mut Window, cx: &mut App, init: F) -> Entity<Self>
where F: 'static + FnOnce(&mut Window, &mut Context<'_, EditableTextState>) -> StorageType, StorageType: 'static + UnicodeTextStorage,
{ window.use_keyed_state(key, cx, |window, cx| Self::new(init(window, cx), cx)) }
```
`Window::use_keyed_state` (window.rs:3655) is the framework-level re-render-propagation seam:
```rust
pub fn use_keyed_state<S: 'static>(&mut self, key: impl Into<ElementId>, cx: &mut App, init: impl FnOnce(&mut Self, &mut Context<S>) -> S) -> Entity<S> {
    let current_view = self.current_view();
    self.with_global_id(key.into(), |global_id, window| {
        window.with_element_state(global_id, |state: Option<Entity<S>>, window| {
            if let Some(state) = state { (state.clone(), state) }
            else {
                let new_state = cx.new(|cx| init(window, cx));
                cx.observe(&new_state, move |_, cx| { cx.notify(current_view); }).detach();
                (new_state.clone(), new_state)
            }
        })
    })
}
```
On first render this creates `Entity<S>` and installs an observer: **any `cx.notify()` on the child entity re-notifies the enclosing view.** So every keystroke → `EditableTextState` mutation → `cx.notify()` → observer fires → `cx.notify(current_view)` → the *entire owning view* is dirtied and fully re-renders/re-lays-out next frame. Confirmed 17 unconditional `cx.notify()` call sites across mutating methods in state.rs (196, 445, 457, 496, 529, 573, 588, 634, 735, 752, 830, 1068, 1091 — `emplace`, `move_to`, `select_to`, `delete_linear`, `nav_linear`, `select_document`, `select_linear`, IME replace/mark, action handlers).

**Re-shape avoidance is manual, via a version counter — not framework-provided**: `UnicodeTextStorage::version(&self) -> u16` (storage.rs:22) increments on every `replace_range` (storage.rs:237–240: `self.version = self.version.wrapping_add(1)`). `EditableTextLayoutState.last_seen_storage_version` (layout.rs:12) is compared during layout (element.rs:559, `perform_text_layout`, ~603):
```rust
&& self.storage_version == self.prev_layout_state.last_seen_storage_version
{
    return size;   // skip re-layout entirely, reuse cached lines
}
```
`cx.notify()` always triggers a re-render/re-paint of the view, but the element internally checks the version stamp to decide whether to actually re-run wrap/shape (`perform_text_layout`) or reuse the cached `Vec<TextLineSegment>` in `layout_data.lines` — the **one piece of fine-grained invalidation in the whole editable-text stack**, but it's document-wide (whole-field granularity): a single-character edit invalidates the *entire* document's cached line list, not just the affected line.

`EditableTextElement` (element.rs:250–458, the `Element` impl) is a **stateless, per-render builder struct** — not an `Entity` itself, holding only an `Rc<RefCell<WeakEntity<...>>>` cache of the entity it looks up each frame via `find_or_create_state`/`find_or_create_caret` (460, 474).

**`history.rs`** (157 lines) — patch-based undo/redo, not full-snapshot:
```rust
pub const MAX_HISTORY_LEN: usize = 1000;
pub const DEFAULT_GROUP_INTERVAL: Duration = Duration::from_millis(300);
pub struct EditableTextHistory {
    grouping_interval: Duration,
    undo_stack: Vec<HistoryEntry>,   // was SmallVec<[HistoryEntry; MAX_HISTORY_LEN]>
    redo_stack: Vec<HistoryEntry>,   // was SmallVec<[HistoryEntry; MAX_HISTORY_LEN]>
}
```
Confirmed by `git log`: commit `b172d695cd` ("replace EditableTextHistory stacks from SmallVec to Vec since they can easily cause the stack to overflow (#112)", 2026-08-09) changed both stacks from `SmallVec<[HistoryEntry; 1000]>` (a 1000-entry inline array on the stack before spilling) to plain heap-backed `Vec<HistoryEntry>` — the inline array was large enough to overflow the stack. `HistoryEntry` stores only a diff (byte range + old text + new length + selection + timestamp), grouping consecutive edits within 300ms into one entry via in-place range extension (`HistoryEntry::extend`, history.rs:128) — the coalescing mechanism for undo granularity.

**`storage.rs`** (241 lines) — `UnicodeTextStorage` trait, the pluggable text-backend abstraction (default `StringStorage`, a `String` wrapper). Contract: `version()` for change detection, `content_utf8`, `len_utf16`, `replace_range`, utf8↔utf16 offset conversion, grapheme/word/line boundary navigation, all implemented generically against `content_utf8()`. This is the seam a fine-grained-reactivity/rope-backed text redesign would need to preserve.

**`caret.rs`** (162 lines) — `Caret` is its own small `Entity`, decoupled from `EditableTextState` via pub/sub rather than embedded as a field:
```rust
pub struct Caret {
    interval: Duration, generation: usize, visible: bool, has_focus: bool,
    paused: bool, subscriptions: SmallVec<[Subscription; 2]>, was_focused: bool,
}
```
`subscribe_to<E: EventEmitter<CaretNotify>>` (caret.rs:70) listens for `CaretNotify::PauseBlinking` emitted by `EditableTextState`. Blinking is a self-respawning async task with a generation counter to cancel stale ticks:
```rust
// caret.rs:128
fn restart_blink_ticker(&mut self, cx: &mut Context<Self>) {
    let generation = self.generation.wrapping_add(1);
    self.generation = generation;
    let interval = self.interval;
    cx.spawn(async move |this, cx| {
        cx.background_executor().timer(interval).await;
        let Some(this) = this.upgrade() else { return };
        this.update(cx, |this, cx| {
            if this.generation == generation {
                this.paused = false;
                if !this.has_focus { return; }
                this.visible = !this.visible;
                cx.notify();
                this.restart_blink_ticker(cx);
            }
        });
    }).detach();
}
```
A complete, small example of the standard async pattern (`cx.spawn` → weak upgrade → `update` → `cx.notify()`).

**`actions.rs`** — ~30 actions via `gpui::actions!` macro (Escape, Enter, Tab, DeleteLeft/Right/WordLeft/WordRight/ToLineStart/ToLineEnd, Nav*, Select*, etc.), dispatched through `EditableTextActionHandler` (state.rs:827) into the mutation methods above (each calling `cx.notify()`).

**`layout.rs`** (104 lines) — `EditableTextLayoutState{ wrap_width, size, last_seen_storage_version }` and `EditableTextLayoutResult{ ..., lines: Vec<TextLineSegment>, ... }`. `TextLineSegment{ text_range, wrapped_line: Option<Arc<WrappedLine>>, pos_y }` retains shaped output explicitly "so IME `bounds_for_range`/`character_index_for_point` can evaluate without re-shaping" (comment, layout.rs:26).

### Summary — editable text data flow
Keystroke → `EditableTextState` mutation → unconditional `cx.notify()` → `use_keyed_state`'s observer → `cx.notify(current_view)` → full parent-view re-render next frame → `EditableTextElement::request_layout` re-runs, internally short-circuiting actual reshaping via a document-wide `u16` version-stamp comparison. No line-level or run-level diffing exists beneath that.

## 5.4 Async & Scheduling

### `crates/gpui/src/executor.rs` (532 lines) — thin wrapper over `gpui_scheduler`
```rust
pub use scheduler::{FallibleTask, LocalExecutor as SchedulerLocalExecutor, Priority, Task};
#[derive(Clone)]
pub struct BackgroundExecutor { inner: scheduler::BackgroundExecutor, dispatcher: Arc<dyn PlatformDispatcher> }
#[derive(Clone)]
pub struct ForegroundExecutor { inner: scheduler::LocalExecutor, dispatcher: Arc<dyn PlatformDispatcher>, not_send: PhantomData<Rc<()>> }
```
`Task<R>` is re-exported directly from `scheduler` (defined in `gpui_scheduler`, not `gpui`).

```rust
// BackgroundExecutor
pub fn spawn<R>(&self, future: impl Future<Output = R> + Send + 'static) -> Task<R> where R: Send + 'static
pub fn spawn_with_priority<R>(&self, priority: Priority, future: ...) -> Task<R>
pub async fn scoped<'scope, F>(&self, scheduler: F) where F: FnOnce(&mut Scope<'scope>)
pub fn timer(&self, duration: Duration) -> Task<()>

// ForegroundExecutor (main-thread only, !Send)
pub fn spawn<R>(&self, future: impl Future<Output = R> + 'static) -> Task<R>
pub fn spawn_with_priority<R>(&self, _priority: Priority, future: ...) -> Task<R>  // priority ignored on main thread
pub fn spawn_when_idle<R>(&self, timeout: Option<Duration>, future: ...) -> Task<R>
pub fn block_on<R>(&self, future: impl Future<Output = R>) -> R
```
`Priority` (from `scheduler::Priority`): `RealtimeAudio, High, Medium (default), Low` — `RealtimeAudio` gets a dedicated OS thread (`spawn_realtime`); others feed a weighted probabilistic scheduler.

### `crates/gpui_scheduler` — vendored from upstream Zed
Cargo.toml: `name = "gpui_scheduler"`, `[lib] name = "scheduler"`, description *"Async task scheduler/executor for gpui-ce (vendored from Zed)."* This **is** the scheduler `gpui::executor` wraps, not fork-original. Files: `clock.rs`, `executor.rs`, `scheduler.rs` (crate root), `test_scheduler.rs`, `tests.rs`.
```rust
// scheduler.rs:81
pub trait Scheduler: Send + Sync {
    fn block(&self, session_id: Option<SessionId>, future: Pin<&mut dyn Future<Output = ()>>, timeout: Option<Duration>) -> bool;
    fn schedule_local(&self, session_id: SessionId, runnable: Runnable<RunnableMeta>);
    fn schedule_background_with_priority(&self, runnable: Runnable<RunnableMeta>, priority: Priority);
    fn spawn_realtime(&self, f: Box<dyn FnOnce() + Send>);
    fn schedule_background(&self, runnable: Runnable<RunnableMeta>) { ... }
    ...
}
```
`Priority::weight()`: High=60, Medium=30, Low=10, RealtimeAudio=0 (bypasses probability scheduling, own thread). `RunnableMeta` carries `#[track_caller]` spawn location + `SpawnTime` for debugging — why nearly every `spawn` fn in gpui is `#[track_caller]`. `TestScheduler` (deterministic, seedable, fake clock) implements `Scheduler` for tests — powers `run_until_parked`/`advance_clock`/`tick`/`rng()` transparently.

### `cx.spawn` — entity-scoped, weak by construction
```rust
// context.rs:237
#[track_caller]
pub fn spawn<AsyncFn, R>(&self, f: AsyncFn) -> Task<R>
where T: 'static, AsyncFn: AsyncFnOnce(WeakEntity<T>, &mut AsyncApp) -> R + 'static, R: 'static,
{
    let this = self.weak_entity();
    self.app.spawn(async move |cx| f(this, cx).await)
}
```
The closure receives a `WeakEntity<T>`, **never a strong `Entity<T>`** — the framework enforces that async continuations must re-acquire the entity rather than artificially keeping it alive across await points.
```rust
// app.rs:1931
#[track_caller]
pub fn spawn<AsyncFn, R>(&self, f: AsyncFn) -> Task<R>
where AsyncFn: AsyncFnOnce(&mut AsyncApp) -> R + 'static, R: 'static,
{
    if self.quitting { debug_panic!("Can't spawn on main thread after on_app_quit") };
    let mut cx = self.to_async();
    self.foreground_executor.spawn(async move { f(&mut cx).await }.boxed_local())
}
```

**The canonical dropped-entity idiom**, exercised throughout the codebase (e.g. `caret.rs:133–158` above):
```rust
let Some(this) = this.upgrade() else { return };   // silent no-op if entity was dropped
this.update(cx, |this, cx| { ... });                 // Result-returning; often .ok()'d
```
`AnyWeakEntity::upgrade` does an atomic ref-count check-and-increment against the entity map's ref counts, returning `None` if already zero. `WeakEntity::update` returns `Result<R>`; call sites frequently `.ok()` to no-op on failure (e.g. `on_app_restart`/`on_app_quit`, context.rs:200–226: `handle.update(cx, |...| ...).ok();`). **This is the load-bearing pattern any reactive redesign must replicate**: async tasks never hold a strong reference across suspension; liveness is always re-derived via `upgrade`, and dropped entities make the continuation a silent no-op rather than a panic or dangling access.

## 5.5 `gpui_elements` crate — component inventory

```
crates/gpui_elements/src/
  lib.rs                 (3 lines: `pub mod editable_text;`)
  editable_text.rs
  editable_text/{actions.rs, caret.rs, element.rs, history.rs, layout.rs, state.rs, storage.rs}
```
**Currently contains exactly one component family: editable text** (`text_input`/`text_area` constructors, both producing `EditableTextElement`). No buttons, lists, checkboxes, etc. exist yet. The doc comment describes it as "Element library written alongside gpui to be as unopinionated as possible while still providing fundamental components" — more are implied but not present in this snapshot.

Within that one family, three distinct state-ownership patterns are already visible:
1. **`EditableTextState`** — full owned `Entity<T>` per instance, keyed by `ElementId`, framework-observer-propagated invalidation ("heavyweight owned entity" pattern).
2. **`Caret`** — a *second*, smaller `Entity<T>`, decoupled from `EditableTextState` via `cx.subscribe`/`EventEmitter<CaretNotify>` rather than embedded as a field ("satellite entity via pub/sub" pattern — used for independent lifecycle concerns like blink timing that shouldn't force invalidation of/from the main state).
3. **`EditableTextElement`** — stateless, `#[track_caller]`-constructed builder struct, rebuilt fresh every render, holding no persistent app state itself beyond a `WeakEntity` cache ("stateless per-render element, backed by looked-up persistent entities" pattern).

No pure `RenderOnce` stateless component with zero persistent state exists in this crate yet — everything present needs cross-frame persistence (text content, caret blink), so all of it routes through `use_keyed_state`.

## 5.6 Cross-cutting implications (Part 5)

1. Invalidation is two-tier and coarse: entity-level (any mutation → unconditional `cx.notify()`, no per-field tracking) and view-level (`use_keyed_state`'s `cx.observe` blindly forwards any child-entity notify into a full parent-view notify).
2. The one place manual fine-graining exists (the editable-text version-stamp check) is document-wide, not per-line/per-run — a general "memoize by dependency" primitive could subsume and refine it.
3. Async re-entry is uniformly weak-handle-based and safe to build on — a reactive-signal system can follow the identical idiom without new invalidation-safety design.
4. Async scheduling (`gpui_scheduler`, priority-aware, deterministic-test-capable) is orthogonal to the entity/view notify system — new reactive-effect scheduling would plug in alongside it, not replace it.
5. Text shaping already has a robust per-frame cache with a hash-based non-materializing probe API purpose-built for large documents — a rope/fine-grained-signal-backed text implementation should target `layout_line_by_hash`/`try_layout_line_by_hash` to avoid contiguous-string copies of large documents.

---

# PART 6 — Fork vs. Upstream Zed GPUI

## 6.1 Fork identity/purpose (README.md, quoted)

> "# gpui - Community Edition
> A community fork of [GPUI](https://gpui.rs), Zed's GPU-accelerated UI framework."

On differentiation from other forks (notably WGPUI):
> "Other efforts (namely WGPUI) are actively maintained, but have diverged quite a bit from mainline usage. They typically serve the interests of the projects that they're used within, leading to a diverse yet fragmented ecosystem. GPUI-CE strives to focus on the general use-case first, and over time, grow in the facilities to support the same outside adaptations through a single consistent API."

On long-term intent:
> "We'd like to be a premiere Rust GUI library! For the time being, we're working incrementally, in an effort to better understand the codebase and where is the right direction to take it, so we're okay being limited by mainline Zed. We will not stay this way forever! The spirit of the project is independence, so 'limited' is loose, and we have and will continue to add features that mainline will never have."

On drop-in compatibility:
> "100% Because we're a drop-in for GPUI, any component library or surrounding project should work 1:1 through the use of a patch block... We track the latest upstream -- if there's breaking changes and the library you're pulling in hasn't updated yet, gpui-ce cannot help you. Otherwise, we treat any mismatches as bugs."

`docs/` is a near-empty Typst site skeleton (stub `index.typ`, template/sidebar/nav files) — no architecture document beyond the README and `scripts/sync-upstream/README.md`.

## 6.2 Fork-specific additions (non-sync commits)

Total commit history: **33,657** commits (full upstream Zed history back to 2021-02-20, replayed/merged in — not a shallow fork). Only 1 of the last 100 commits is titled "Sync/zed..." — most recent activity is fork-original work.

- **Letter spacing + text transforms** — `6043651563` "Add letter spacing and text transforms to GPUI (#111)", Aug 8 2026. Touches `style.rs` (new `TextTransform` enum: `Uppercase`/`Lowercase`/`Capitalize`, `TextStyle::letter_spacing: Option<Pixels>`, `TextStyle::text_transform: Option<TextTransform>`), `elements/text.rs`, `text_system.rs`, `text_system/line_layout.rs`, `line_wrapper.rs`, plus per-backend plumbing in `gpui_macos/src/text_system.rs`, `gpui_wgpu/src/cosmic_text_system.rs`, `gpui_windows/src/direct_write.rs`. Doc comments explicitly note transforms are "byte-length preserving" (Unicode full case folding kept byte-stable) — deliberate so ranges/spans/selections computed against source text don't need remapping after transform. **Relevant to a reactive text-diffing scheme**: transforms apply at layout/paint time without perturbing byte offsets used elsewhere (selection, IME, history).

- **Haptic feedback (macOS)** — `568271c01c` "feat(macos): support haptic feedback (#71)", Aug 4 2026. Adds `gpui_macos/src/haptic_feedback.rs` (`MacHaptics`, wraps `NSHapticFeedbackManager`, fire-and-forget, silently no-ops without hardware support), a `HapticFeedbackStyle` type surfaced via `platform.rs`/`app.rs`. Platform-only, macOS-specific.

- **`EditableTextHistory` SmallVec→Vec** — `b172d695cd`, Aug 9 2026 (most recent commit in the checkout). `undo_stack`/`redo_stack` changed from `SmallVec<[HistoryEntry; 1000]>` to `Vec<HistoryEntry>` because the inline-array storage of a growing undo history was overflowing the stack. **A concrete cautionary data point**: `gpui_elements` (fork-only, never synced from upstream) already hit a stack-overflow bug from an inline-buffer collection for growable per-widget state — any new fine-grained reactive state container should default to heap-backed growth for state that can grow unboundedly (undo history, dependency lists, subscriber lists).

- **Automatic upstream sync tooling** — `33ed975bf2` "Add tooling for automatic upstream sync (#83)" (full detail in §6.3).

Other fork-specific (non-sync) commits of note: `2542e1154a` "add App::emit such that events can be emitted without acquiring a Context (#94)"; `1fe82dbcd7` "implement start_window_move on win32 platform (#102)"; `6c799b8e99` "removed all of the git sources (#91)" (vendored collections/sum_tree/scheduler in-tree — see §6.5/6.6); `ce08af96db` "add wgpu renderer for windows (#44)"; `6d043b22e4` "gpui: Add wgpu Surface element and GPU device requirements API for Linux (#39)"; `c17b4367d5` "gpui: Add gpu_device_lost() to query device-loss state on Linux (#78)"; `0610782953` "Wayland input_region and exclusive_zone + WGPU panic fix (#82)"; `676d5897ae` "feat: kinetic scrolling on wayland (#54)"; `69d467e4d1` "Filter API + Blur (#40)"; `cfec5ff014` "Add Transition::jump_to for transitions (#58)"; `1b410c1783` "Add a collection of contextless action keystrokes that can be built with a shared key context (#43)"; the entire `gpui_elements` crate (editable text: text_input/text_area, caret blinking, IME, undo/redo, selection — never synced from upstream).

## 6.3 Upstream-sync tooling — the compounding-merge-cost constraint

`scripts/sync-upstream/`: `sync_upstream.py` (stdlib-only orchestrator), `resolve-conflicts.prompt.md`, `fix-build.prompt.md`, `README.md`, `state.json` (committed — last-synced upstream SHA + vendor tip).

**Mechanism**: upstream (`zed-industries/zed`) keeps GPUI in-tree at the **same relative paths** this fork uses for 1:1 crates. A local branch `vendor/zed-gpui` holds a filtered replay of upstream's gpui-touching commits (original author/date/message + a `zed-upstream: <sha>` trailer). Each sync `git merge`s that branch's new tip, producing up to three commits: (1) raw merge with conflict markers; (2) an LLM-driven (`claude -p` + `resolve-conflicts.prompt.md`) resolution commit, retried up to `--retries`; (3) if build/tests break, an LLM-driven fix commit (`fix-build.prompt.md`). Gate: `just check` (warnings-as-failures) then `just test`. Nothing is ever pushed automatically — a human reviews and lands the `sync/` branch.

**Explicit rule (`resolve-conflicts.prompt.md`, rule 2)**:
> "**gpui-ce keeps its own patches.** gpui-ce carries features/fixes not yet upstream (e.g. blur filters, kinetic scrolling on Wayland, the wgpu device-loss API). When a conflict pits an upstream change against a gpui-ce patch, **keep both behaviours** — integrate the upstream change around gpui-ce's additions rather than dropping either."

**Why this matters for the redesign**: the sync process diffs/merges upstream's *actual file contents* at the same paths on every sync — not a fixed patch set. Any redesign that substantially rewrites core files upstream also actively changes (`elements/text.rs`, `style.rs`, `text_system.rs`, `element.rs`, the `App`/`Context`/`Window` core, the render/paint pipeline) creates **recurring, compounding merge burden**: every future upstream sync will re-conflict against the redesigned code, and the LLM conflict-resolution pass explicitly instructs itself to "keep both behaviours" — harder to do correctly the more structurally different the fork's reactivity model is from upstream's. A redesign confined to `gpui_elements` (fork-only, never synced) or a new standalone crate incurs **zero** sync burden; a redesign touching `crates/gpui` core incurs **permanent, ongoing** conflict-resolution cost on every sync cycle.

## 6.4 Backend crate map

Per `scripts/sync-upstream/README.md`'s explicit tracking table:
> "Synced 1:1 (same path): `gpui`, `gpui_linux`, `gpui_macos`, `gpui_macros`, `gpui_platform`, `gpui_shared_string`, `gpui_tokio`, `gpui_web`, `gpui_wgpu`, `gpui_windows`."

**Both `gpui_wgpu` and `gpui_web` already exist in upstream Zed's monorepo at the same relative path — they are NOT fork inventions.** Zed's real gpui already ships a wgpu-based rendering backend and a WASM/browser platform backend upstream; the assumption that Zed's gpui only talks to Metal/Vulkan/DirectX directly is not accurate for this codebase.

- **`gpui_wgpu`**: modules `cosmic_text_system`, `wgpu_atlas`, `wgpu_context`, `wgpu_renderer` (`GpuContext`, `WgpuRenderer`, `WgpuSurfaceConfig`). Depends on `wgpu`, `cosmic-text`, `swash`, `etagere`. **Fork additions on top**: Windows wgpu renderer support, Linux GPU-device-lost query API, a Wayland WGPU panic fix.
- **`gpui_web`** (`#![cfg(target_family = "wasm")]`): modules `dispatcher`, `display`, `events`, `http_client`, `keyboard`, `logging`, `platform`, `window` (`WebDispatcher`, `WebDisplay`, `FetchHttpClient`, `WebKeyboardLayout`, `WebPlatform`, `WebWindow`). Depends on `gpui_wgpu` (renders via wgpu → WebGPU/WebGL), `wasm-bindgen`, `web-sys`, an optional `multithreaded` feature via a Zed-maintained fork of `wasm_thread`. A genuine WASM/browser backend, present upstream, same path in this fork.
- **`gpui_platform`**: thin cross-platform shim; doc comment: *"Convenience crate that re-exports GPUI's platform traits and the `current_platform` constructor so consumers don't need `#[cfg]` gating."* `application()` branches on `target_family = "wasm"` to construct `WebPlatform` vs native `current_platform()` — confirming the web backend is first-class and wired-in.
- **`gpui_macos`**: native Metal backend; fork addition: haptics.
- **`gpui_linux`**: native backend, `wayland`/`x11` features, both pull in `gpui_wgpu` (Linux rendering goes through wgpu, not bespoke Vulkan). Fork additions: kinetic scrolling on Wayland, input_region/exclusive_zone, device-loss query.
- **`gpui_windows`**: native DirectWrite backend with an **optional** `wgpu` feature (`wgpu = ["dep:gpui_wgpu"]`) — fork-touched wiring/compile fix.

**Architectural implication**: because a wgpu/WASM backend is real, actively used, and actively kept at parity with upstream, any reactivity redesign must remain compatible with (a) a browser/WASM execution target where arbitrary build-time codegen, native threads (absent the `multithreaded` wasm_thread feature), and OS-level primitives are unavailable; (b) a rendering path funneling through the existing `Element`/`Window` prepaint/paint pipeline and shared `wgpu_atlas`/`cosmic_text_system` machinery common across Linux, Windows(optional), and Web. A reactive system assuming native-only capabilities (thread-per-signal, unrestricted `std::thread`, non-wasm-safe timing) would break the web target this fork is committed to syncing.

## 6.5 `gpui_collections` / `gpui_sum_tree`

Both vendored (fork-renamed in-tree copies of upstream Zed's separate `collections`/`sum_tree` crates), per `6c799b8e99` "removed all of the git sources (#91)":
- **`gpui_collections`** (`[lib] name = "collections"`): `HashMap`/`HashSet` aliases over `rustc_hash::Fx*`, `IndexMap`/`IndexSet`, `TypeIdHashMap`/`TypeIdHashSet`, `vecmap`.
- **`gpui_sum_tree`** (`[lib] name = "sum_tree"`, description: *"Copy-on-write B+ tree with monoidal summaries for gpui-ce (vendored from Zed)."*): `Cursor`/`FilterCursor`/`Iter`, `TreeMap`/`TreeSet`, `TREE_BASE = 6` (2 under test). This is Zed's `sum_tree` — the structure underlying Zed's `Rope`/buffer text representation for O(log n) edits with cached summaries.

**Relevance to fine-grained reactive text**: `sum_tree` is copy-on-write with monoidal (summary) aggregation, purpose-built to let large text buffers be edited/re-summarized incrementally without re-scanning, and to let multiple cursors/observers hold cheap immutable snapshots (Arc-based COW nodes). Not itself reactive/observable — a plain data structure — but exactly the substrate a fine-grained reactive text/editor layer would want to build subscriptions on top of (invalidate only the summary path touched by an edit) rather than diffing whole strings. Any reactivity design for text editing should be compatible with (or built on) this model rather than assuming flat-string diffing.

## 6.6 `gpui_scheduler`

`gpui_scheduler` (`[lib] name = "scheduler"`, description: *"Async task scheduler/executor for gpui-ce (vendored from Zed)."*) — vendored from upstream Zed's separate `scheduler` crate via the same `#91` move, not fork-original. Structure: `clock`, `executor`, `test_scheduler` modules; `TaskPriority` doc: *"Higher priority tasks are more likely to be scheduled before lower priority tasks, but this is not a strict guarantee — the scheduler may interleave tasks of different priorities to prevent starvation."* Built on `async-task`, `flume`, `futures`, `parking_lot`. Task prioritization is an actively-evolving upstream concern this fork inherits via sync — relevant if a reactive system wants to schedule effect/update propagation at specific priorities relative to layout/paint.

## 6.7 Takeaway

This fork is disciplined about scope: nearly all fork-original work (haptics, letter-spacing/text-transform, `gpui_elements`, blur/filters, kinetic scrolling, wgpu device-loss APIs) lives either in genuinely new files/crates or in narrow, additive changes to existing files. The automated sync tooling is explicitly built around preserving the fork's own patches without them being deeply structural, so they can be re-integrated against upstream's real diffs indefinitely. **`gpui_elements` and any new crate are the low-friction places to build fine-grained reactivity; `crates/gpui` core and the shared rendering crates (`gpui_wgpu`, synced across macOS/Linux/Windows/Web) are high-friction**, both because they're actively synced from upstream and because a WASM backend is a real, maintained target constraining execution-model assumptions (threading, codegen, timing) available to a reactive system.

---

# PART 7 — Pain Points Catalog (with evidence)

1. **Runtime, not compile-time, exclusivity enforcement for entity mutation.** Every entity access goes through `EntityMap::lease`/`read`, which panics with `"cannot {read|update} {type} while it is already being updated"` (`entity_map.rs:206–212`, triggered at lines 142/164) on any reentrant read/mutate of the same entity — a purely dynamic check with no static aliasing analysis. Same pattern reused for `Lease<T>` drop-without-`end_lease` (`"Leases must be ended with EntityMap::end_lease"`, entity_map.rs:234–240) and for globals (`lease_global`, app.rs:2067–2076, sharing the *generic* "no global registered" panic text with the missing-global case rather than a dedicated reentrancy message).

2. **Coarse, single-bit invalidation is the only granularity that exists.** `cx.notify()` marks either a window dirty (fast path, entity currently rendered — `App::notify`, app.rs:2657–2692) or queues a generic `Effect::Notify` (slow path). Either way, the *default* (uncached) render path reconstructs the entire visible view tree — `Render::render()` reruns unconditionally for every non-cached `ViewElement` in a dirtied window (view.rs:314–360), Taffy's whole tree is wiped and rebuilt every draw (`taffy.rs:58-63`, called unconditionally at `window.rs:2862`), and every arena-allocated element is reconstructed from scratch (`arena.rs`, `element.rs:590-599`). There is no dependency tracking below "one `Entity`'s entire render output"; the only finer mechanism, `.cached(style)`, is opt-in, per-`EntityId`, whole-subtree (view.rs:39-41, 223-234, 362-435).

3. **Style computation is recomputed from scratch up to 3× per element per frame, with zero memoization.** `Interactivity::compute_style_internal` (div.rs:3273-3393) starts from `Style::default()` and re-runs the entire refine chain (base + up to 5 pseudo-state refinements) independently in `request_layout`, `prepaint`, and `paint` (div.rs:2198, 2263, 2415) — no caching between phases or across frames. The `Refineable` derive macro (`gpui_derive_refineable/src/derive_refineable.rs:104-129`) generates unconditional per-field `if let Some(value) = ...` walks with no dirty-bit/changed-detection representation at all.

4. **Dependency discovery is "diff the global read-set before and after render," not a static graph.** `App::record_entities_accessed` (app.rs:1097-1140) snapshots `EntityMap::accessed_entities` before/after a window's draw to populate `tracked_entities`/`window_invalidators_by_entity` — this is how GPUI knows which window(s) to mark dirty when an entity notifies. It's dynamic, whole-render-granular, and re-derived every frame; nothing about it is checked or guaranteed at compile time.

5. **Cx-threading is pervasive and non-optional.** Across the five core app/entity files alone, 278 `pub fn` signatures include 203 occurrences of `&mut Context<T>`/`&mut App`/`&mut Window` (app.rs: 174 pub fns, 78 of those params; context.rs: 41 pub fns, 85 params; entity_map.rs: 42 pub fns, 6 params; async_context.rs: 21 pub fns, 34 params) — plus generic `C: AppContext`/`VisualContext`/`BorrowAppContext` bounds not captured by the literal grep. State access is a capability re-derived through every call frame, not a first-class value usable anywhere (see App/Context section §1.5 for full breakdown).

6. **String/enum-keyed, path-based element state with silent-collision failure modes.** `GlobalElementId` (element.rs:211-213) is a path of developer-supplied or synthesized `ElementId`s; `Window::with_element_state` (window.rs:3702-3775) keys a `FxHashMap<(GlobalElementId, TypeId), ElementStateBox>` off this path. Positional/unkeyed lists are vulnerable to classic "index as key" reordering bugs (nothing in the mechanism detects this); duplicate ids in the same frame panic (`"reentrant call to with_element_state for the same state type and element id"`, window.rs:3749-3751); and `View`'s own doc explicitly documents a **silent** corruption case: *"two views keyed on the same entity must not be rendered at the same position in the element tree... their internal element state (use_state, scroll offsets, etc.) would silently collide"* (view.rs:182-195).

7. **Init-order / ambient-global hazards with no compile-time enforcement of "has been initialized."** `Global` (global.rs:22-27) statically gates *type* eligibility only; `App::global<G>()` panics `"no state of type {type_name} exists"` (app.rs:1987-1994) if no instance was ever inserted, and `remove_global`/`lease_global` have their own similarly-worded panics (`"no global added for {type_name}"`, `"no global registered of type {type_name}"`). Nothing in the type system tracks "has `set_global::<G>()` been called on this path" — it's whatever order app-init code happens to run in.

8. **Async re-entry relies on manual weak-upgrade-or-noop discipline, not enforced by the compiler.** `cx.spawn` closures always receive `WeakEntity<T>`, never a strong handle (context.rs:237, entity_map.rs:777-805) — but nothing stops a future implementation from ignoring `.upgrade()`'s `None` case or forgetting the `Result`/`.ok()` pattern; it's convention (consistently followed in-tree) rather than a static guarantee. Separately, `AsyncApp::app()` panics `"app was released before async operation completed"` (async_context.rs:28-34) if the whole app is gone, and the underlying `RefCell<App>` (`AppCell`, app.rs:78-83, doc: *"Temporary(?) wrapper... Strongly consider removing after stabilization"*) can raise a raw `BorrowMutError` on synchronous re-entrant double-borrow with no GPUI-specific diagnostic.

9. **Undo/redo history already hit a stack-overflow bug from a stack-allocated collection choice** — `EditableTextHistory` undo/redo stacks were `SmallVec<[HistoryEntry; 1000]>` (a 1000-entry inline array) until `b172d695cd` (2026-08-09, the most recent commit in this checkout) converted them to heap-backed `Vec<HistoryEntry>` "since they can easily cause the stack to overflow." A cautionary precedent: growable reactive-system internals (dependency lists, subscriber sets, undo/history buffers) must default to heap growth, not inline/stack buffers.

10. **Editable-text reshape avoidance is hand-rolled and document-wide, not framework-provided or fine-grained.** `EditableTextState`/`EditableTextElement` implement their own `u16` version-stamp comparison (`storage.rs:237-240`, `layout.rs:12`, checked in `element.rs:~603`) purely to avoid unconditionally reshaping the whole document on every `cx.notify()`-triggered re-render — this is bespoke, single-widget-local logic reinventing exactly the kind of dependency tracking a general reactive system should provide, and even so it's whole-document granularity (a one-character edit invalidates the entire cached `Vec<TextLineSegment>`), not per-line/per-run.

---

# PART 8 — Integration Seams Catalog (least-violence insertion points)

1. **The `#[derive(Refineable)]` macro (`gpui_derive_refineable/src/derive_refineable.rs`) is a clean, mechanical, per-field code generator.** It already enumerates every field name/type to build `refine`/`refined`/`is_superset_of`/`subtract`/`IsEmpty` (104-129, 256-274). Emitting a parallel bitset or generation-counter alongside `refine` (flagging which fields actually changed value, not just which are `Some`) would give `compute_style_internal` (div.rs:3273-3393) a cheap way to skip re-deriving unchanged pseudo-state refinements — a low-violence, purely-additive change to one code-generation site that fans out to `Style`, `TextStyle`, and every other `Refineable` consumer.

2. **The already-existing `Cascade<S: Refineable>` container (`gpui_refineable/src/refineable.rs:80-132`) is unused for `Style`/`StyleRefinement`.** It supports priority-ordered slots (`reserve()`, `set()`, `merged()`) — exactly the shape needed to replace `div.rs`'s hardcoded sequential `style.refine(...)` calls (base → focus → group-hover → hover → drag → active) with a slot-based system that could track per-slot dirtiness and only re-merge when a specific slot's contribution changes. Wiring this in is scoped to `Interactivity::compute_style_internal` and doesn't touch core entity/window machinery.

3. **`ViewElement::cached(style)` (view.rs:39-41, 223-234, 271-274) is GPUI's one existing per-entity memoization boundary** — it already checks `window.dirty_views.contains(&entity_id)` plus a bounds/mask/text-style cache key, and already has `reuse_prepaint`/`reuse_paint` replay machinery (window.rs:3302-3401) and `DispatchTree::reuse_subtree` (key_dispatch.rs:264-306) for splicing cached dispatch-tree nodes. A fine-grained reactivity layer could hook into `window.dirty_views`/`ViewElementCacheKey` as its "should this subtree re-render" oracle rather than reinventing subtree-skip machinery from zero — this is the most mature existing seam in the whole rendering pipeline for coarse-to-medium-grained skip logic.

4. **`Window::with_element_state`/`GlobalElementId` (window.rs:3702-3775, element.rs:211-213) is the existing slot-based persistence layer used for cross-frame auxiliary element-local state** (`use_state`, `use_keyed_state`, `InteractiveElementState`). A signal handle or adapter state could live there, but its destination element is still frame-arena allocated and its Taffy node is cleared. This seam cannot provide direct property patching by itself. It is useful for compatibility and prototypes; the fine-grained path requires retained element/layout/dispatch/scene identities in core.

5. **`App::record_entities_accessed`/`accessed_entities` (app.rs:1097-1140, entity_map.rs `accessed_entities: RefCell<FxHashSet<EntityId>>`) is already a dependency-tracking mechanism, just coarse (whole-entity, diffed pre/post render).** This is the natural place to generalize from "which entities were read" to "which specific fields/signals were read" — the read-tracking *scaffold* (detect-accessed-during-a-scope) already exists and is exercised on every render; a finer read-log could be threaded through the same `detect_accessed_entities` call sites (app.rs:1097-1111) without redesigning how dependency discovery is triggered.

6. **The `Effect` queue (`app.rs:2868-2890`, `flush_effects` app.rs:1657-1713) is an extensible, already-batched, already-deduplicated (`pending_notifications`/`pending_global_notifications` side-sets) effect-application point.** A new `Effect::FineGrainedInvalidate { signal_id, ... }` variant (or similar) could be added alongside the existing six variants and drained by the same loop, inheriting the existing "effects can cause effects, keep looping" reentrancy handling (1654-1656) and the existing per-`App::update`-transaction flush timing (`finish_update`, 1044-1062) — this avoids needing a wholly separate scheduling pass parallel to the one GPUI already runs at the end of every mutation.

7. **`gpui_elements` (fork-only, never synced from upstream — confirmed via `scripts/sync-upstream/README.md`'s 1:1-crate list) and any brand-new crate are zero-sync-cost locations to prototype a fine-grained reactive layer.** Per the sync tooling's own operating rule (`resolve-conflicts.prompt.md` rule 2: "gpui-ce keeps its own patches... keep both behaviours"), anything touching `crates/gpui` core incurs recurring conflict-resolution cost on every upstream sync; anything confined to `gpui_elements` or a new crate does not. The editable-text stack's existing hand-rolled dependency-tracking (the `u16` version-stamp comparison, `storage.rs:237-240`/`layout.rs:12`) is a concrete, self-contained candidate to replace with a general primitive first, as a low-risk proving ground before touching core `gpui`.

8. **The text-shaping `FrameCache` and its hash-based, non-materializing probe API (`text_system/line_layout.rs:399`, `577`, `632` `layout_line_by_hash`/`try_layout_line_by_hash`) is a ready-made integration point for rope/fine-grained-signal-backed text.** It's already content-addressable and already designed so large-document callers don't need to materialize a contiguous string just to check a cache hit — a reactive text layer built on `gpui_sum_tree` (vendored copy-on-write B+ tree with monoidal summaries, `crates/gpui_sum_tree`) could drive per-line invalidation straight into this existing cache rather than building a parallel shaping-cache mechanism.

---

# APPENDIX — Verification Notes

All file:line references above were sourced from live reads of the checkout at `/Users/mileswirht/Downloads/gpui-ce` on 2026-08-09 (current HEAD: `b172d695cd`, "replace EditableTextHistory stacks from SmallVec to Vec since they can easily cause the stack to overflow (#112)"). Six parallel research passes were run against non-overlapping file sets (App/Context/Entity/Global; Subscription/Reactivity; Element/View/Window/Arena/Taffy/Interactivity; Style/Refineable/Transition; Text/Input/Async/gpui_elements; Fork-vs-upstream/backends) and cross-checked for consistency (e.g. the `Effect` enum, `flush_effects`, and `App::notify` are quoted identically across the App/Context pass and the Reactivity pass, confirming agreement).
