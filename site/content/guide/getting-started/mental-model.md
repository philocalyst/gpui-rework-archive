+++
title = "Mental model: the three registers"
description = "State lives in entities. Views produce elements. Layout and paint turn those elements into pixels."
weight = 3
aliases = ["/getting-started/mental-model.html"]
[extra]
category = "GETTING STARTED"
legacy_source = "gpui-ce-docs/build/html/getting-started/mental-model.html"
+++

**GPUI** offers three registers, one per need. An **Entity** is a strong handle to state owned by GPUI. A **View** is an `Entity` that renders declaratively. An **Element** draws imperatively with total control. Pick the highest register that solves your problem, and drop down only when it stops working.

## Register 1: `Entity` state

An `Entity<T>` is a strong handle to state owned by GPUI (`README.md:29`). You never hold `T` directly. You create entities with `cx.new`, read them with `Entity::read`, and mutate them with `Entity::update`:

```rust
// cx.new moves Counter into GPUI ownership and returns the owning handle.
let counter = cx.new(|_| Counter { count: 0 });
// read borrows through the handle; no clone, no copy, just a look.
let n = counter.read(cx).count;
// update mutates through the handle; notify() tells GPUI to re-render.
counter.update(cx, |state, cx| {
    state.count += 1; // touch the state inside the closure, nowhere else
    cx.notify(); // mark dirty: observers re-run, views re-render
});
```

Call `cx.notify()` after every mutation ([crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs)). It marks the entity dirty so observers re-run and views re-render. Skip it and your field updates while the screen stays frozen.

Two friends ride along. Use `Context::observe` to re-run a closure whenever another entity calls `notify`, and `Context::subscribe` to listen for typed events ([crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs), [crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs)). The split is strict: `observe` watches `notify` calls, `subscribe` watches `emit` calls ([crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs)), and `subscribe` only compiles when the emitter implements `EventEmitter`. Both return a `Subscription` that unsubscribes the moment you drop it, so hold it in your struct.

> **Tip.** Reach for `Entity::write` when you replace the whole value. It assigns and calls `notify` for you ([crates/gpui/src/app/entity_map.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/entity_map.rs)), which deletes the most common forgotten-notify bug.

## Register 2: View (declarative)

A View is an `Entity` that implements `Render` (`README.md:31`). GPUI calls `render` at the start of each frame on every window root ([crates/gpui/src/element.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/element.rs)). Your job is one pure step: turn current state into an element tree:

```rust
// Render says: this entity can turn itself into boxes every frame.
impl Render for Counter {
    // Read self, build elements, return. Change nothing here.
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div().child(format!("Count: {}", self.count)) // fresh boxes, built from state
    }
}
```

Never mutate state inside `render`. Never run network or disk I/O there. Read `self`, build elements, return. The `div` element is the all-purpose box: style it with `flex`, `gap_3`, `bg`, `text_xl`, and nest children with `child` (see the `div` element page for the full tour).

> **Pitfall.** Mutating inside `render` loops forever in spirit: GPUI calls `render` every frame, so a `count += 1` hiding there spins out of control. Mutate only in event handlers and task completions, where each change traces back to one cause.

## Register 3: Element (imperative)

Elements are the building blocks that Views return (`README.md:33`). Most days you use `div` and friends declaratively. Drop to the imperative `Element` API only when you need total control: custom layout, huge virtualized lists, or a code editor surface.

> **Note.** Reach for custom Elements when `div` cannot express the layout, or when the frame budget proves `div` too slow. Measure first: `div` covers far more than newcomers expect.

## Contexts: your main interface

Every GPUI service hangs off a context (`README.md:35`). **App** is the root context: entities, globals, windows, spawning. **Context** derefs to `App` and adds entity powers: `notify`, `observe`, `subscribe`, `emit`, `listener`. **Window** carries per-window powers: focus, hit-testing, spawning window-bound tasks.

Two traits make those powers portable. `AppContext` is the shared trait behind `App` and friends: `new`, `update_entity`, `read_entity`, `notify`, `update_window` (`crates/gpui/src/gpui.rs:183-228`). `VisualContext` extends it for window-bound work: `update_window_entity`, `new_window_entity`, `replace_root_view`, `focus` (`crates/gpui/src/gpui.rs:292-324`).

Import both traits through the prelude:

```rust
// Without this, cx.new and friends vanish from method resolution.
use gpui::prelude::*; // pulls AppContext + VisualContext into scope
```

> **Note.** The `cx.new` closure receives a fresh `&mut Context<T>`. That means you can `observe` or `subscribe` to other entities during construction, before anyone can see the half-built value.

## Frame lifecycle

One frame runs the same pipeline every time:

```rust
// The whole runtime in five lines. State flows one way, top to bottom.
// 1. Events arrive: clicks, keys, timers, async tasks wake.
// 2. Handlers run: `on_click` closures and `listener`s mutate Entities.
// 3. Mutations call `cx.notify()`, marking entities dirty.
// 4. GPUI calls `render` on each dirty window root, top-down.
// 5. Elements lay out (taffy), paint into a scene, and the GPU presents.
```

State flows one way: events mutate entities, `render` reads entities, elements draw. When a frame misbehaves, walk the pipeline in order. Most bugs sit in step 3, a mutation that forgot its `notify`.

> **Tip.** One quiet lifecycle detail: `open_window` draws a frame synchronously before returning, so a brand-new window paints at least once even if your first `notify` never comes.

## Decision tree

|  |  |  |
| --- | --- | --- |
| **Situation** | **Register** | **Rule** |
| State shared between parts of the app | `Entity` | Create with `cx.new`, mutate with `update` + `notify`. |
| One screenful of UI from state | View (`Render`) | Read `self` in `render`, return elements, no side effects. |
| Clicks, hovers, focus, keyboard | View + interactivity | Add `.id(...)` then `.on_click(...)` with `cx.listener`. |
| Events between entities | `Entity` + subscribe | `emit` on one side, `subscribe` or `observe` on the other. |
| `div` cannot lay it out, or frames are slow | Custom `Element` | Take full control of layout and paint. |
| Window-level action (open, focus, replace root) | Context | Use `App::open_window`, `VisualContext::replace_root_view`, `focus`. |

Table 16: Which register to reach for, and the one rule each register keeps.

When you outgrow one row, the counter-tutorial walks the middle three rows end to end: shared state, a `Render` view, and clicks wired with `listener`.

## Sources

- Three registers: `README.md:27-35`
- Contexts as main interface: `README.md:35`
- `AppContext::new`, `update_entity`, `read_entity`, `notify`: `crates/gpui/src/gpui.rs:189-228`
- `VisualContext` (`update_window_entity`, `replace_root_view`, `focus`): `crates/gpui/src/gpui.rs:292-324`
- `Context::notify`, `Context::listener`, `Context::observe`, `Context::subscribe`: [crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs), [crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs), [crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs), [crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs)
- `Context::emit`: [crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs)
- `Entity::read`, `Entity::update`, `Entity::write`: [crates/gpui/src/app/entity_map.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/entity_map.rs), [crates/gpui/src/app/entity_map.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/entity_map.rs), [crates/gpui/src/app/entity_map.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/entity_map.rs)
- `Render::render`: [crates/gpui/src/element.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/element.rs); `Element`: [crates/gpui/src/element.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/element.rs)
- `App::open_window`: [crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs); `Application::run`: [crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)
- `div()`: [crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs); `.id()`: [crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs); `on_click`: [crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)
