+++
title = "Models and contexts"
description = "Understand which context you have, what it can do, and how state crosses application boundaries."
weight = 10
aliases = ["/fundamentals/models-contexts.html"]
[extra]
category = "FUNDAMENTALS"
legacy_source = "gpui-ce-docs/build/html/fundamentals/models-contexts.html"
+++

**Model** is a role, not a type: plain data held by `Entity<T>`. **ModelContext** is also a role: `Context<T>` inside an `update` closure. Mutations run in closures, then `notify` wakes observers. Handle mechanics live in [entities](@/guide/fundamentals/entities.md) app setup lives in [application](@/guide/fundamentals/application.md).

## Mutate through closures

**Update closure** receives `&mut T` plus `&mut Context<T>` and runs now. `Entity::update` routes any `&mut C: AppContext` into that closure ([crates/gpui/src/app/entity_map.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/entity_map.rs)). `Context<T>` derefs to `App`, so app services stay one call away ([crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs)). Keep closures short: mutate, notify, return.

```rust
// update opens the state and its context together. No window needed.
// state.count touches the real model behind App's ownership.
// cx.notify() marks this entity dirty so observers and views re-run.
counter.update(cx, |state, cx| {
    state.count += 1;
    cx.notify();
});
```

Skipping `notify` leaves observers stale, while `write` never forgets it ([crates/gpui/src/app/entity_map.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/entity_map.rs)). Treat a silent observer as a missing `notify` first. `Context::notify` itself just forwards the entity id to `App` ([crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs)). The window mapping decides who wakes.

## Wire the loop

**Notify loop** moves one way: mutate, notify, observers re-run, views re-render. `Context::observe` runs a closure on its own entity whenever a peer notifies ([crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs)). `Context::subscribe` delivers typed events instead of bare wakeups ([crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs)). Emitters opt in through `EventEmitter`, and they send through `Context::emit` ([crates/gpui/src/gpui.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/gpui.rs), [crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs)).

```rust
// observe the peer, mutate self. first wakes, second follows.
// The closure gets (self, peer_handle, context). Read peer, write self.
// detach keeps the watch until the observed entity drops. Store it or leak it.
cx.observe(&first, |second, first, cx| {
    // first.read borrows the peer through the shared App. No lock drama.
    // Assign self directly. Views re-render on the next dirty pass.
    second.count = first.read(cx).count * 2;
}).detach();
```

`detach` keeps the callback until the observed entity drops ([crates/gpui/src/subscription.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/subscription.rs)). `Context::spawn` hands async code a `WeakEntity` plus `AsyncApp`, never a strong handle ([crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs)). Hold or detach the returned task, or it cancels.

```rust
// The loop in four lines: mutate, notify, observe, re-render.
// Render reads state. It never mutates. Keep that wall intact.
// Break the wall and you get flicker: draw-time mutation re-dirties mid-draw.
```

> **Pitfall.** Mutating state inside `render` re-dirties mid-draw, which defers instead of drawing. Symptom: stale views that lag one frame forever. Fix: mutate only in updates, notify each time, keep `render` pure.

## Meet the family

**Context family** spans sync code, async code, and tests. `Context<T>` adds entity powers: `observe`, `subscribe`, `emit`, `notify`, `entity` ([crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs), `:229`, `:765`, `:50`). `VisualContext` adds window-bound work: window entities and root views ([crates/gpui/src/gpui.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/gpui.rs)).

|  |  |  |
| --- | --- | --- |
| **Context** | **Use it for** | **Proof** |
| `App` | Live root; owns the globals registry. | [crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs) |
| `Context<T>` | Entity powers inside updates. | [crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs) |
| `VisualContext` | Window-bound entities, root views. | [crates/gpui/src/gpui.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/gpui.rs) |
| `AsyncApp` | Weak app handle across `await`. | [crates/gpui/src/app/async_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/async_context.rs) |
| `AsyncWindowContext` | Window work across `await`; fallible. | [crates/gpui/src/app/async_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/async_context.rs) |
| `TestAppContext` | Headless tests, no OS window. | [crates/gpui/src/app/test_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/test_context.rs) |
| `VisualTestContext` | Window tests with drawing. | [crates/gpui/src/app/test_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/test_context.rs) |

Table 11: Pick the smallest context that holds what you need.

Two edges bite here. `AsyncApp` holds the app weakly: it never keeps the app alive ([crates/gpui/src/app/async_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/async_context.rs)). Keeping the app alive stays the `ApplicationHandle`’s job. `AsyncWindowContext::update` returns `Result`, because the window may have closed while you awaited ([crates/gpui/src/app/async_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/async_context.rs)). Always handle that `Err` after an await. In tests, `TestAppContext` runs headless with no OS window, while `add_empty_window` hands you a `VisualTestContext` that can draw ([crates/gpui/src/app/test_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/test_context.rs)).

> **Tip.** After every `await`, assume the window closed and the entity died. Upgrade weakly, match on `Result`, and skip silently when the world moved on.

Global state uses the same observer machinery ([globals and subscriptions](@/guide/fundamentals/globals-subscriptions.md)). Startup and windows come first ([application](@/guide/fundamentals/application.md)).

## Sources

- `Context<T>`, deref to `App`: [crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs)
- `Context::{entity, weak_entity, observe, subscribe, notify, emit, spawn}`: [crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs), `:57`, `:63`, `:98`, `:229`, `:237`, `:765`
- `AppContext`, `VisualContext`, `EventEmitter`: [crates/gpui/src/gpui.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/gpui.rs), `:292`, `:328`
- `Entity::{update, read, write}`: [crates/gpui/src/app/entity_map.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/entity_map.rs), `:464`, `:491`
- `Subscription::detach`: [crates/gpui/src/subscription.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/subscription.rs)
- `AsyncApp`, `AsyncWindowContext::update`: [crates/gpui/src/app/async_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/async_context.rs), `:319`, `:337`
- `TestAppContext`, `VisualTestContext`, `add_empty_window`: [crates/gpui/src/app/test_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/test_context.rs), `:298`, `:769`

Next step: open `crates/gpui/src/_ownership_and_data_flow.rs`. Then run its `no_run` counter examples.
