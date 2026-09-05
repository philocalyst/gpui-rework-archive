+++
title = "Globals and subscriptions"
description = "Share application-wide state and keep observers connected for exactly as long as they are needed."
weight = 11
aliases = ["/fundamentals/globals-subscriptions.html"]
[extra]
category = "FUNDAMENTALS"
legacy_source = "gpui-ce-docs/build/html/fundamentals/globals-subscriptions.html"
+++

**Global** is app-wide state stored once per type. **Subscription** is a leash: drop it and the callback stops. `set_global` stores, `observe_global` watches. Window setup lives in [application](@/guide/fundamentals/application.md) shared state lives in [entities](@/guide/fundamentals/entities.md).

## Store one per type

**Global registry** keys values by type, with one slot each. Any type with the empty marker trait `Global` qualifies ([crates/gpui/src/global.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/global.rs)). `set_global` stores a value and wakes observers ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)). `global` borrows and panics when absent, while `try_global` returns `None` instead ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs), [crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)).

```rust
// One struct, one slot. The marker trait unlocks the registry.
// set_global inserts AND pushes a notify effect for observers.
// global borrows back. Missing key panics, so guard with try_global.
struct Settings { dark: bool }
impl Global for Settings {}
cx.set_global(Settings { dark: true });
let dark = cx.global::<Settings>().dark;
```

Every writer notifies: `global_mut`, `default_global`, `set_global`, and even `remove_global` push `NotifyGlobalObservers` ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs), `:2109`, `:2120`, `:2133`). `default_global` inserts a `Default` value on first touch, then notifies like any other write. Only `clear_globals` stays silent, and it exists for tests alone. `update_global` folds borrow plus notify into one closure ([crates/gpui/src/gpui.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/gpui.rs)).

```rust
// The three writers: borrow-and-touch, default-and-touch, replace-and-touch.
// Each one wakes observers. Pick by intent, not by habit.
// remove_global takes the value out AND notifies. Nothing leaves quietly.
let theme = cx.global_mut::<Settings>(); // panics when absent
theme.dark = false; // the borrow itself already queued the notify
cx.remove_global::<Settings>(); // registry slot emptied, watchers woken
```

> **Note.** `try_global` returns `None` for a missing key instead of panicking. Reach for it in shared code, where you cannot prove someone else stored the value first.

## Hold the leash

**Subscription lifetime** follows one rule: drop cancels, detach persists. `Subscription` runs its unsubscribe closure on drop ([crates/gpui/src/subscription.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/subscription.rs)). `observe_global` returns one such handle for global watchers ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)). `detach` releases the handle, so the callback survives until the emitter drops ([crates/gpui/src/subscription.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/subscription.rs)).

```rust
// observe_global returns a leash. Hold it in a struct field.
// drop(sub) cancels right there. The callback never fires again.
// detach() burns the leash instead: the watch outlives this scope.
struct Settings;
impl Global for Settings {}
cx.set_global(Settings);
let sub = cx.observe_global::<Settings>(|_| {});
drop(sub); // callback stops here
```

Two timing edges hide here. `observe_global` defers activation through an effect, so the watch starts after the current update ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)). A `set_global` in the same update will not synchronously re-enter your callback. `Subscription::join` fuses two leashes into one handle ([crates/gpui/src/subscription.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/subscription.rs)). Drop the fused handle to cancel both at once. Store handles in struct fields to keep callbacks alive.

> **Tip.** Store each `Subscription` in the struct that cares about it, next to the state it updates. When the struct drops, the watches cancel themselves. No cleanup code needed.

## Own state, trap leaks

**Ownership rule** says `App` owns every entity; handles only borrow through contexts (`crates/gpui/src/_ownership_and_data_flow.rs`). Strong cycles leak: an entity owning a closure that clones itself never releases. **Leak trap** number two is a detached watcher nobody cancels; it fires until the emitter drops.

|  |  |  |
| --- | --- | --- |
| **Myth** | **Reality** | **Proof** |
| Globals read anywhere. | Reads need a context reference. | [crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs) |
| Dropping entities drops watchers. | Only dropping the `Subscription` cancels. | [crates/gpui/src/subscription.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/subscription.rs) |
| `detach` means forever. | It ends when emitters drop. | [crates/gpui/src/subscription.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/subscription.rs) |

Table 10: Three myths that leak memory or sleep through updates.

`on_release` runs teardown when an entity dies; `observe_release` watches another entity’s death ([crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs), [crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs)). Pair each long-lived watcher with one of them.

```rust
// on_release fires when SELF dies. Clean up file handles, timers, tasks.
// observe_release fires when the PEER dies. Drop caches, clear back-links.
// Without one of these, detached watchers outlive their usefulness.
cx.on_release(|state, cx| {
    // Teardown lives here: cancel timers, close files, drop subscriptions.
}).detach();
```

> **Pitfall.** Detaching every watcher and cloning `Entity` into each closure pins memory two ways: cycles hold state, orphans fire callbacks ([crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs)). Fix: store each `Subscription` in a field, drop it on cleanup, and use `on_release` for teardown.

## Sources

- `Global`: [crates/gpui/src/global.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/global.rs)
- `App::{has_global, global, try_global, global_mut, default_global, set_global, remove_global, observe_global}`: [crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs), `:2082`, `:2090`, `:2098`, `:2109`, `:2120`, `:2133`, `:2145`
- `BorrowAppContext::{update_global, update_default_global}`: [crates/gpui/src/gpui.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/gpui.rs), `:340`
- `Subscription::{new, detach, join}`, drop cancels: [crates/gpui/src/subscription.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/subscription.rs), `:166`, `:172`
- `Context::{on_release, observe_release}`: [crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs), `:151`
- Ownership rules and `observe`/`subscribe`/`emit` flow: `crates/gpui/src/_ownership_and_data_flow.rs`

Next step: open [crates/gpui/src/subscription.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/subscription.rs) and read `Subscription`. Then audit one watcher.
