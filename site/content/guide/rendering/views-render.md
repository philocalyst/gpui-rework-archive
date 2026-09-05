+++
title = "Views and render"
description = "Turn persistent entity state into an element tree through the Render trait."
weight = 13
aliases = ["/rendering/views-render.html"]
[extra]
category = "RENDERING"
legacy_source = "gpui-ce-docs/build/html/rendering/views-render.html"
+++

**Render** is the trait that lets a view draw itself as an element tree (`crates/gpui/src/element.rs:163-166`). Your view holds the state, `render` describes the pixels, and GPUI rebuilds the description each frame. Split state into small views and each update stays small too.

```rust
// `&mut self` means you read live view state here — no props threading.
// `self.label.clone()` snapshots one field into the tree. The tree owns
// the copy now, so later view edits cannot disturb this frame.
fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
    div().child(self.label.clone())
}
```

Its sibling **`RenderOnce`** renders by value for plain-data components with no entity (`element.rs:179-184`). One frame owns the value, draws it, and lets it drop. Pick it for recipes, keep `Render` for living state.

## Stateful and stateless paths

`ViewElement` wraps any `View` and plugs it into layout, prepaint, and paint (`crates/gpui/src/view.rs:237-246`). Build one with `ViewElement::new(view)`. Inside `request_layout` it forks on identity (`view.rs:321-359`).

```rust
// Stateful path: the view HAS an entity id, so GPUI opens a reactive
// boundary with `with_rendered_view`. Notifies to this entity re-render
// just this subtree. Stateless path: no id, so GPUI scopes the subtree
// by type name instead — `ElementId::Name(type_name::<V>())`.
if let Some(entity_id) = self.entity_id {
    window.with_rendered_view(entity_id, |window| { /* render or reuse */ })
} else {
    window.with_id(ElementId::Name(type_name::<V>()), |window| { /* render */ })
}
```

Two views keyed on the same entity must never sit as siblings under one parent: their `use_state` and scroll offsets silently collide (`view.rs:186-190`). Nest them instead, since the id path scopes by parents. `cx.notify()` on an entity re-renders only that subtree, so small views beat one giant root.

> **Pitfall.** Rendering the same entity twice as siblings merges their element state with no warning. Wrap one copy in a parent `div` with its own `.id()` to split the paths.

## Prepaint cache keys

Stateful prepaint reuses work when nothing moved. GPUI keeps a `ViewElementState` per identity and replays it only when bounds, content mask, text style, dirtiness, and the refresh flag all agree (`view.rs:386-401`).

```rust
// All five must match, or GPUI re-renders the subtree fresh.
// On a hit it replays the saved prepaint range and re-registers the
// entities this subtree read, so later notifies still wake it up.
// `dirty_views` holds notified entities; `refreshing` means full redraw.
if cache.bounds == bounds
    && cache.content_mask == content_mask
    && cache.text_style == text_style
    && !window.dirty_views.contains(&entity_id)
    && !window.refreshing
{
    window.reuse_prepaint(saved_range);
}
```

|  |  |  |
| --- | --- | --- |
| Key piece | Where it lives | Change means |
| bounds | `view.rs:387` | resized or moved: redraw |
| content mask | `view.rs:388` | clip or scroll shifted: redraw |
| text style | `view.rs:389` | font context changed: redraw |
| dirty set | `view.rs:390` | entity notified: redraw |
| refresh flag | `view.rs:391` | full refresh: redraw all |

Table 35: The five-part cache key behind every stateful view.

## The view trait

**View** unifies both kinds behind `entity_id()` plus a by-value `render(self, …)` (`view.rs:182-195`). Note the by-value bite: `Render::render` borrows `&mut self`, but `View::render` consumes. Hand-implement `View` only when a component needs parent-supplied props and a backing entity together (`view.rs:179-181`).

```rust
// `Entity<T: Render>` keys itself on its own id — the stateful View.
// Any `T: RenderOnce` keys on nothing — the stateless View.
// `ViewElement::new(view)` snapshots that choice once, at wrap time.
impl<T: Render> View for Entity<T> { /* entity_id() = Some(...) */ }
impl<T: RenderOnce> View for T { /* entity_id() = None */ }
```

`Entity::cached(style)` pins a definite-size subtree for reuse across frames (`view.rs:223-235`). Caching skips measuring children, so you must supply the size up front. The inner `cached()` constructor stays crate-private on purpose: only entity-backed views carry the notify contract that busts the cache (`view.rs:271-274`).

## Derive macros

Both macros emit trait impls and nothing more. `derive(Render)` stamps an `impl Render` whose body returns `Empty`, a placeholder for views you wire up later (`crates/gpui_macros/src/derive_render.rs:5-17`). `derive(IntoElement)` stamps an `impl IntoElement` that wraps `ViewElement::new(self)` with caller tracking (`crates/gpui_macros/src/derive_into_element.rs:5-20`).

```rust
// derive(Render): your view compiles today, draws nothing until you
// write a real `render`. derive(IntoElement): your plain-data struct
// becomes a component — the `element.rs:28-32` recipe path. The latter
// records your call site, so inspector traces point at your code.
#[derive(Render)] // -> fn render(...) { gpui::Empty }
#[derive(IntoElement)] // -> ViewElement::new(self)
```

> **Tip.** Default to components: plain struct plus `RenderOnce` plus `derive(IntoElement)`. Promote to an entity only when outside code must notify it.

Where next? Learn how `div` sizes these trees (`layout`), then how state restyles them (`styling`).

## Sources

- `Render`, `RenderOnce`: `crates/gpui/src/element.rs:163-184`
- `View` docs + blanket impls: `crates/gpui/src/view.rs:171-221`
- Stateful vs stateless layout: `view.rs:321-359`
- Stateless prepaint + paint: `view.rs:436-445`
- Cache key + reuse: `view.rs:380-401`
- `cached`, definite-size rule: `view.rs:223-235,271-274`
- Same-entity sibling collision: `view.rs:186-190`
- Derives: `crates/gpui_macros/src/derive_render.rs:5-17`, `crates/gpui_macros/src/derive_into_element.rs:5-20`
