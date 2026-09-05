+++
title = "Elements core"
description = "The element lifecycle: request layout, prepare the frame, and paint the result."
weight = 12
aliases = ["/rendering/elements-core.html"]
[extra]
category = "RENDERING"
legacy_source = "gpui-ce-docs/build/html/rendering/elements-core.html"
+++

**Element** is the trait that lays out and paints one node of your window. You build trees of elements every frame, and GPUI turns them into pixels (`crates/gpui/src/element.rs:47-51`). Reach for this page when custom drawing calls. Start with `div`, then come back here.

```rust
// Your render method returns *something convertible*, not an Element itself.
// `div()` builds a Div. `.child("hello")` nests text inside it.
// `impl IntoElement` means "any type the tree knows how to draw".
fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
    div().child("hello")
}
```

Each frame GPUI calls `Render::render` on the root view, lays the tree out with Taffy, paints it, then drops the whole tree (`element.rs:10-14`). Your state lives in views, never in the tree. That split keeps frames fresh and bugs rare.

## Three phases, one order

Every element walks three steps in strict order: `request_layout`, then `prepaint`, then `paint` (`element.rs:73-104`). Layout asks Taffy for a `LayoutId` and stashes setup work. Prepaint commits bounds for hit-testing. Paint draws inside those bounds.

```rust
// `id` carries cross-frame identity (None = anonymous, rebuilt fresh).
// `window` + `cx` give you layout, hitboxes, and app state at each step.
// Each state flows into the next phase — layout state feeds prepaint,
// and both feed paint. Nothing flows backward.
fn request_layout(&mut self, id: Option<&GlobalElementId>, window: &mut Window, cx: &mut App)
    -> (LayoutId, Self::RequestLayoutState);
fn prepaint(&mut self, id: Option<&GlobalElementId>, bounds: Bounds<Pixels>, request_layout: &mut Self::RequestLayoutState, window: &mut Window, cx: &mut App)
    -> Self::PrepaintState;
fn paint(&mut self, id: Option<&GlobalElementId>, bounds: Bounds<Pixels>, request_layout: &mut Self::RequestLayoutState, prepaint: &mut Self::PrepaintState, window: &mut Window, cx: &mut App);
```

Underneath sits a small state machine, `ElementDrawPhase`, with five stops from `Start` to `Painted` (`element.rs:287-313`). Call the phases out of order and GPUI panics with a plain message (`element.rs:367`, `element.rs:480`, `element.rs:523`). That strictness is a gift: layout bugs surface loudly instead of flickering.

> **Pitfall.** Reading last frame’s boxes during `request_layout` to pick sizes loops forever. Decide sizes from view data, never from laid-out output.

## Identity spans frames

A bare element is stateless: GPUI rebuilds it fresh and remembers nothing. Return an id from `id()`, and GPUI hands you a `GlobalElementId` path in every phase (`element.rs:60-65`). That path is a stack of ids, pushed before your phase runs and popped after (`element.rs:327-330`).

```rust
// First render pushes "ok-button" onto the id stack for this subtree.
// Second render pushes it again — same path, so GPUI finds old state.
// Siblings must differ: ids stay unique among children of the nearest
// named ancestor (`element.rs:60-64`). Reuse one id twice and state collides.
div()
    .id("ok-button") // claim a name so hover, focus, and clicks persist
    .on_click(|_event, _window, _cx| println!("clicked"))
```

Two details love to bite. `PrepaintState` exists for tiny voluminous flags, like hover-started, that would waste space in every view (`element.rs:16-17`). Accessibility also needs identity: elements stay out of the a11y tree unless both `id()` and `a11y_role()` return something (`element.rs:109`).

> **Tip.** Name ids like names, not numbers: `"ok-button"` beats `"btn-3"`. Midnight debugging thanks you.

## Conversions and wrappers

**`IntoElement`** is the one-step recipe that turns strings, `Div`s, and components into real elements (`element.rs:145-157`). Its `into_any_element()` type-erases into `AnyElement`, the shared currency `child()` accepts. Only hand-roll `Element` for custom layout or painting, like editors or canvases (`element.rs:28-32`).

```rust
// `.child()` takes anything implementing IntoElement — &str, Div, components.
// Each child converts twice: first `into_element()`, then `into_any()`.
// That second step boxes it into AnyElement (`element.rs:220-225`).
// The arena behind AnyElement frees every node when the frame ends.
div().flex().child("left").child("right")
```

|  |  |  |
| --- | --- | --- |
| Type | Owns | Rebuilt per frame |
| `Element` | layout + paint impl | yes |
| `View` / `Entity` | state + identity | no |
| `IntoElement` | one-shot conversion | yes |
| `AnyElement` | boxed, arena-owned node | yes |
| `Empty` | a `Display::None` leaf | yes |

Table 32: The five types you meet in the tree, and who owns what.

`AnyElement` boxes through the per-frame element arena, so the tree never allocates long-lived (`element.rs:618-626`). `Empty` is the polite nothing: a leaf styled `Display::None` that draws nowhere (`element.rs:785-794`). Prefer it over `Option` gymnastics in branches.

Where next? Meet the view layer that feeds this tree (`views-render`), then the flex rules that size it (`layout`).

## Sources

- Trait + phases: `crates/gpui/src/element.rs:47-104`
- Draw phases + order panics: `element.rs:287-313,367,480,523`
- Identity + id-stack push/pop: `element.rs:60-65,327-330,355-357`
- A11y needs `id`: `element.rs:109-113`
- `PrepaintState` rationale: `element.rs:16-17`
- `IntoElement`, `ParentElement::child`, arena: `element.rs:145-157,215-236,614-626`
- `Empty` leaf: `element.rs:785-794`
