+++
title = "Entities and weak handles"
description = "Give application state a stable identity, with strong and weak handles and explicit updates."
weight = 9
aliases = ["/fundamentals/entities.html"]
[extra]
category = "FUNDAMENTALS"
legacy_source = "gpui-ce-docs/build/html/fundamentals/entities.html"
+++

**Entity** is GPUI’s shared handle to state owned by `App`. Picture it as an `Rc` with a notify bell: cheap to clone, yet readable only through a context. **WeakEntity** is the non-owning twin, and it expires when the last `Entity` drops. This page covers handle mechanics only; state flow lives in [mental model](@/guide/getting-started/mental-model.md).

## Make and mutate

**Create path** means `cx.new`, `update`, and `read` on a typed handle. `AppContext::new` builds the state inside a closure and hands back `Entity<T>` ([crates/gpui/src/gpui.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/gpui.rs)). `Entity::read` borrows through `&App`, while `Entity::update` mutates through any `&mut C: AppContext` ([crates/gpui/src/app/entity_map.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/entity_map.rs), [crates/gpui/src/app/entity_map.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/entity_map.rs)).

```rust
// cx.new builds Counter inside a closure and hands App ownership.
// The returned Entity is just an id plus a type tag. Cheap to clone.
// read borrows through &App. No mutation, no notify needed.
// update opens &mut state plus a Context. Mutate, notify, return.
let counter = cx.new(|_| Counter { count: 0 });
let n = counter.read(cx).count;
counter.update(cx, |state, cx| {
    state.count += 1; // touch the real state here
    cx.notify(); // ring the bell, or observers stay silent
});
```

Call `Context::notify` after each mutation, or observers stay silent ([crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs)). `Entity::write` replaces the value and notifies in one step ([crates/gpui/src/app/entity_map.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/entity_map.rs)). `Entity::as_mut` opens the state behind a borrow guard instead of a closure ([crates/gpui/src/app/entity_map.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/entity_map.rs)).

> **Tip.** Prefer `write` for full replacement and `update` for field surgery. Both notify. Bare mutation without either leaves every observer stale.

## Break cycles weakly

**Weak path** means `downgrade`, then `upgrade`, then act on `Some`. `Entity::downgrade` returns a handle that never keeps state alive ([crates/gpui/src/app/entity_map.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/entity_map.rs)). `WeakEntity::upgrade` returns `Option<Entity<T>>`: `Some` while a strong handle lives, `None` after release ([crates/gpui/src/app/entity_map.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/entity_map.rs)). Store weak handles for back-links, parent pointers, and cached peers.

```rust
// downgrade keeps no strong count. The child can point up safely.
// upgrade returns Some while a strong handle lives, None after.
// Act only inside `if let Some`. The peer may already be gone.
let weak = entity.downgrade();
if let Some(strong) = weak.upgrade() {
    strong.update(cx, |s, cx| {
        s.count += 1; // same mutate-then-notify rhythm
        cx.notify();
    });
}
```

`WeakEntity::update` and `read_with` fold upgrade plus access into one `Result` ([crates/gpui/src/app/entity_map.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/entity_map.rs), [crates/gpui/src/app/entity_map.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/entity_map.rs)). They fail with “entity released” when nothing strong remains. `WeakEntity::update_in` is stricter still: it routes through the entity’s current window, and fails when the entity belongs to no window ([crates/gpui/src/app/entity_map.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/entity_map.rs)). `WeakEntity::new_invalid` never upgrades at all ([crates/gpui/src/app/entity_map.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/entity_map.rs)). It exists as a placeholder, not a handle.

```rust
// The one-line weak dance: upgrade, mutate, notify, all fallible.
// `?` here means "peer gone or windowless". Handle it, do not unwrap.
// Reach for this when cached peers may have died without telling you.
weak.update(cx, |s, cx| {
    s.count += 1; // runs only when upgrade succeeded
    cx.notify();
})?;
```

> **Pitfall.** Calling `update_in` on a windowless entity fails with “entity has no current window”. Models shared across windows should use `update`, which needs no window at all.

## Compare the three roles

**Role table** keeps `Entity`, `Model`, and `View` apart. `Entity<T>` is the strong handle type ([crates/gpui/src/app/entity_map.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/entity_map.rs)). `Model` is a role, not a type: plain data stored in `Entity<T>` (verify in checkout: no `struct Model` exists). `View` renders state into elements through `Render::render` ([crates/gpui/src/element.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/element.rs)).

|  |  |  |
| --- | --- | --- |
| **Role** | **What it is** | **Proof** |
| `Entity` | Shared handle; `App` owns the state. | [crates/gpui/src/app/entity_map.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/entity_map.rs) |
| Model | Plain data inside `Entity<T>`; no separate type. | Verify in checkout. |
| View | `Entity<T: Render>` turns state into elements. | [crates/gpui/src/element.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/element.rs) |

Table 9: Three names, three jobs: handle, data, rendering.

A view’s identity becomes its element id ([crates/gpui/src/view.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/view.rs)). Two views keyed on the same entity must never sit as siblings: their element state, like scroll offsets, silently collides. Nest them instead. `Entity::cached(style)` reuses the rendered subtree until notified, but it needs a definite size from `style` ([crates/gpui/src/view.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/view.rs)). It never measures from contents.

> **Note.** Cloning `Entity` into a closure the entity itself owns pins the strong count above zero, so state leaks. Store `WeakEntity`, call `upgrade`, and act only on `Some` ([crates/gpui/src/app/entity_map.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/entity_map.rs)).

Models use these handles for shared data ([models and contexts](@/guide/fundamentals/models-contexts.md)). Events between handles use typed callbacks ([globals and subscriptions](@/guide/fundamentals/globals-subscriptions.md)).

## Sources

- `AppContext::new`, `update_entity`, `read_entity`: [crates/gpui/src/gpui.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/gpui.rs)
- `Entity::{entity_id, downgrade, into_any, read, read_with, update, as_mut, write, update_in}`: [crates/gpui/src/app/entity_map.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/entity_map.rs), `:449`, `:458`, `:464`, `:470`, `:476`, `:486`, `:491`, `:502`
- `WeakEntity::{upgrade, update, update_in, read_with, new_invalid}`: [crates/gpui/src/app/entity_map.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/entity_map.rs), `:777`, `:792`, `:810`, `:820`
- `Context::notify`: [crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs)
- `View::{entity_id, render}`, `Entity::cached`: [crates/gpui/src/view.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/view.rs), `:232`
- `Render::render`: [crates/gpui/src/element.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/element.rs)

Next step: open [crates/gpui/src/app/entity_map.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/entity_map.rs) and read `Entity`. Then run its doc examples.
