# Luna 01: state and ownership documentation review

This note records the implementation evidence behind the state, app-context,
entity, global, and subscription documentation edited in this pass. It is an
editorial review, not a claim that the documentation has been built or that
every platform-specific API behavior has been verified.

## Assigned files read

- `crates/gpui/src/gpui.rs`
- `crates/gpui/src/app.rs`
- `crates/gpui/src/app/context.rs`
- `crates/gpui/src/app/entity_map.rs`
- `crates/gpui/src/global.rs`
- `crates/gpui/src/subscription.rs`
- `crates/gpui/src/_ownership_and_data_flow.rs`
- `crates/gpui/README.md`

I also read `target/zed-documentation-reference/AGENTS.md` as reference-repo
data, not as instructions for this checkout. I made no intentional edits to
generated `docs/examples` include blocks or files outside the assigned edit
scope.

## Claims checked or corrected against this checkout

- **An entity handle owns identity and lifetime, while a context grants access.**
  `Entity<T>` cloning increments the strong count; `read` and `update` require
  an app context, and `EntityMap::lease` removes the value from the map until
  `end_lease` restores it. Re-entering the same entity therefore panics.
  Evidence: `crates/gpui/src/app/entity_map.rs:134-173`,
  `crates/gpui/src/app/entity_map.rs:417-621`, and
  `crates/gpui/src/app.rs:2940-2982`.
- **Last-handle drop and value destruction are separate moments.** Dropping a
  final strong handle queues its ID; `flush_effects` drains released values
  before processing each effect and invokes release callbacks before dropping
  each value. A weak upgrade fails as soon as the strong count reaches zero.
  Evidence: `crates/gpui/src/app/entity_map.rs:184-214`,
  `crates/gpui/src/app/entity_map.rs:713-747`, and
  `crates/gpui/src/app.rs:1846-1903`.
- **Notifications and typed events have different jobs.** `notify` queues a
  coalesced observer effect (or invalidates a currently rendered window); an
  event stores a payload and queues delivery to listeners of the matching
  `TypeId`. Neither callback is invoked inline by the call itself. Evidence:
  `crates/gpui/src/app.rs:1827-1868`, `crates/gpui/src/app.rs:1958-1978`,
  and `crates/gpui/src/app.rs:3023-3060`.
- **Subscription registration can be deferred, and queue order matters.**
  `App::subscribe` enqueues an activation effect; `emit` enqueues delivery.
  If registration comes first, both can be requested in one update and the
  listener runs when the effect queue is flushed after the update closure.
  The former prose incorrectly required a later update to emit. Evidence:
  `crates/gpui/src/app.rs:1316-1365`,
  `crates/gpui/src/app.rs:1340-1358`, and
  `crates/gpui/src/app.rs:3048-3060`.
- **Callback captures differ by API.** `Context::observe`, `subscribe`,
  `listener`, and `spawn` capture the observing entity weakly. `observe_self`,
  `subscribe_self`, `processor`, and `on_next_frame` hold a strong entity
  handle; retaining those callbacks or subscriptions on the same entity can
  form an ownership cycle. Evidence: `crates/gpui/src/app/context.rs:74-107`,
  `crates/gpui/src/app/context.rs:109-191`,
  `crates/gpui/src/app/context.rs:267-365`, and
  `crates/gpui/src/app/context.rs:387-399`.
- **The app-facing context names describe different lifetimes.** `Application`
  configures and starts the platform; `App` is synchronous callback access;
  `Context<T>` adds the current entity; `AsyncApp` and
  `AsyncWindowContext` reacquire access for each callback after an await and
  hold the application weakly. Evidence: `crates/gpui/src/app.rs:148-340`,
  `crates/gpui/src/app.rs:776-790`, and
  `crates/gpui/src/app/async_context.rs:17-28`,
  `crates/gpui/src/app/async_context.rs:344-355`.
- **Shutdown waiting differs by target.** Native shutdown waits up to
  `SHUTDOWN_TIMEOUT` for quit handlers; Wasm schedules cleanup as best effort
  because its event-loop thread cannot block. The entity-scoped quit hook docs
  now state this platform difference. Evidence: `crates/gpui/src/app.rs:1095-1120`
  and `crates/gpui/src/app/context.rs:299-305`.
- **Global state is per-app and keyed by type.** Direct mutable access and
  `set_global` queue observers; `update_global` removes the value for the
  callback and schedules observers when the lease is restored. Missing typed
  globals panic except through `try_global`/optional async accessors. Evidence:
  `crates/gpui/src/app.rs:2193-2257` and
  `crates/gpui/src/gpui.rs:466-505`.
- **New-entity hooks cover models too.** `App::observe_new<T>` is keyed only
  by `TypeId` and runs for every entity of that type, with a window only when
  creation occurred in one. Its old description said “view,” which wrongly
  excluded models. Evidence: `crates/gpui/src/app.rs:2303-2337` and
  `crates/gpui/src/app.rs:1873-1890`.
- **Window lookup follows an entity's current association.** A rendered entity
  is associated with the most recently rendered window that referenced it;
  before first render, creation can supply the association. Lookup may fail
  while the window is closed or on the update stack. Evidence:
  `crates/gpui/src/app.rs:1257-1279`,
  `crates/gpui/src/app.rs:2032-2050`, and
  `crates/gpui/src/app/context.rs:334-378`.

## Platform service implementations inspected

For the expanded `Application` and `App` service docs, I read the common
`Platform` trait in `crates/gpui/src/platform.rs` and the concrete service
implementations in `crates/gpui_macos/src/platform.rs`,
`crates/gpui_linux/src/linux/platform.rs`,
`crates/gpui_windows/src/platform.rs`, and
`crates/gpui_web/src/platform.rs`. The docs now distinguish best-effort
fire-and-forget requests from APIs that return a task or picker receiver;
mention the browser user-activation requirement for clipboard access; describe
backend-specific results for clipboard, pickers, app/helper paths, URL scheme
registration, and thermal state; and direct callers to capability checks where
the API provides one. I also documented that macOS alone currently reports
thermal changes, while unsupported backends return a nominal state or do not
deliver a callback. These statements were checked against this checkout's
implementations, not a build or runtime test.

## Consumer references inspected

These are pinned snapshots and usage examples only; their implementations are
not authoritative for this checkout.

- **Zed:** `target/zed-documentation-reference` at
  `da0a7a78cf296a6d8a75894f46b71a8e7f19cb2f` (2026-10-07). In
  `crates/acp_thread/src/acp_thread.rs`, `AcpThread::new` at lines 3637-3686
  starts a task with `Context::spawn`, observes a global, subscribes to its own
  events, and subscribes to a `GitStore` entity. The own-event subscription is
  retained in the entity and the external subscription is bound to a local
  variable, illustrating lifetime ownership. The same file's
  `resolve_locations` around lines 1736-1748 awaits in a foreground task and
  operates through the weak project handle afterward.
- **Hummingbird:** `target/hummingbird-documentation-reference` at
  `2e1ee5f1c8d415ef7f835801fe368ab4106035b5` (2026-10-07). In
  `src/library/scan/control.rs`, `start_broadcast` around lines 145-166 uses a
  detached foreground task, updates a model then calls `notify`, and emits
  playlist events. In `src/services/controllers.rs`,
  `register_pbc_event_handlers` around lines 208-295 observes entities and
  subscribes to an image event, detaching application-level callbacks. In
  `src/playback/interface.rs` around lines 227-303, updates call `notify` for
  state snapshots while separate model updates emit payload-bearing events.

The checked-out trees were sparse and their consumer source files were not
present on disk; these paths and line ranges were inspected from the pinned Git
objects with `git show`. Hummingbird depends on a separate `gpui-unofficial`
shim, so its call sites inform the consumer examples but do not establish this
checkout's behavior.

## Editorial reference and remaining review

I read the primary Jiff crate documentation on docs.rs as an editorial
reference: its crate root distinguishes the central type, recommends a default
choice, gives a complete quick example, and routes readers to focused longer
guides. GPUI prose added here follows that information architecture without
borrowing Jiff's semantics: <https://docs.rs/jiff/latest/jiff/>.

The primary review should still run rustdoc to verify link resolution and the
included examples, especially the `BorrowAppContext`/global callback wording
and whether callers should be encouraged to register-and-emit in one update.
The parent review caught one newly introduced unqualified link to
`BorrowAppContext::update_default_global`; it is now qualified as
`crate::BorrowAppContext::update_default_global`. I manually inspected the
other newly introduced intra-doc targets, but did not run rustdoc. The platform
claims likewise need runtime verification on supported backends. No build,
test, or rustdoc generation was run in this pass.
