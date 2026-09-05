+++
title = "Layout"
description = "Describe the relationship between a container, its children, and the space available to them."
weight = 14
aliases = ["/rendering/layout.html"]
[extra]
playground = true
category = "RENDERING"
legacy_source = "gpui-ce-docs/build/html/rendering/layout.html"
+++

**Layout** is how GPUI turns your style builders into boxes, using web flex rules through Taffy (`crates/gpui/src/element.rs:1-3`). You declare intent with `div` builders, Taffy resolves sizes, and prepaint commits bounds. Learn the defaults here and centering stops feeling like luck.

```rust
// `div()` makes the flex container everything builds from (`div.rs:1802`).
// `.flex()` switches display to flex — children now flow in a row.
// `.flex_row()` names the direction out loud. `.gap_2()` breathes
// between children. `.child("a")` nests one box inside another.
fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
    div().flex().flex_row().gap_2().child("a").child("b")
}
```

Behind the builders sits `Style`, the plain box-model struct: sizes, margins, padding, borders, flex, alignment, gaps (`crates/gpui/src/style.rs:215-311`). Builders write into a `StyleRefinement` overlay that refines the base (`crates/gpui/src/styled.rs:23-36`).


{{ <playground example="layout" title="Try the constraint" label="Interactive companion" /> }}


## Flex defaults that bite

Taffy starts every node as a row that refuses to wrap, never grows, may shrink, and sizes from content (`style.rs:942-946`). That one line explains most “why is my column horizontal” mysteries.

|  |  |  |
| --- | --- | --- |
| Property | Default | What it means for you |
| `flex_direction` | `Row` | children flow sideways until `flex_col` |
| `flex_wrap` | `NoWrap` | one line only; overflow spills |
| `flex_grow` | `0.0` | never takes spare space unless asked |
| `flex_shrink` | `1.0` | may squeeze to fit its container |
| `flex_basis` | `Auto` | starts from content size |
| `size` / `min_size` | `auto` | hugs content until you pin it |

Table 33: Taffy starting values, and the surprise each one hides.

`.flex()` sets only `Display::Flex` (`styled.rs:94`). Direction stays `Row` until you say `flex_col()`, `flex_row_reverse()`, or siblings. Growing takes two moves: `.flex()` on the parent, `.flex_1()` on the child that should drink the spare room.

```rust
// Parent declares a flex context; children opt into growth one by one.
// `.flex_1()` sets grow on THIS child — siblings without it keep content size.
// `.flex_col()` flips the main axis vertical; gaps follow the axis.
div().flex().flex_col().gap_2().child(div().flex_1().child("grows"))
```

> **Pitfall.** Deep `flex` nesting multiplies Taffy passes, and a `Div` sized from a child sized from itself never converges. Flatten where you can, and pin one side with a definite size.

## Space, measures, units

Unbounded axes arrive as **`AvailableSpace`**, a three-way enum: `Definite` pixels, `MinContent`, or `MaxContent` (`crates/gpui/src/taffy.rs:768-776`). `MinContent` is the default, so content-shaped nodes start small. Two constructors feed Taffy: `request_layout` for fixed-style nodes, `request_measured_layout` with a measure closure for text-like content (`taffy.rs:62-107`).

```rust
// `Length::Auto` means "ask the context" — parent, content, or viewport.
// `DefiniteLength::Fraction(1.)` means "all of my parent", via relative(1.).
// `rems(2.)` means "twice the window rem size" — it resolves with
// `to_pixels(rem_size)` at draw time (`geometry.rs:3242`).
div().w_full() // full parent width: relative(1.) under the hood
div().p_4() // padding in rems: scales with user font settings
div().rounded_md() // corners in px: exact, never scales
```

Window roots stretch `auto` axes to fill the viewport, like the web root filling its block (`taffy.rs:115-137`). Explicit sizes survive untouched. Prefer `rems` for type and spacing so UI follows settings; spend `px` on hairlines (`geometry.rs:3721-3736`).

> **Tip.** Margin accepts `auto` for centering tricks, but padding and gap take definite lengths only. When centering fails, check which family your property belongs to.

## Container queries

**Container query** is an element that branches on the size its parent gave it (`crates/gpui/src/elements/container_query.rs:33-48`). It fills its parent by default, then builds children after layout from the measured size.

```rust
// The closure runs AFTER layout, receiving the assigned size in pixels.
// Narrow parents get one child, wide parents get another. Children can
// never resize the query itself — they arrive too late (`container_query.rs:17-19`).
// `Styled` still applies: chain `.w(...)` to stop filling the parent.
container_query(|size, _window, _cx| {
    if size.width < px(240.) { div().child("narrow") } else { div().child("wide") }
})
```

Two constraints carry the design. The query defaults to `relative(1.)` on both axes, so it fills unless you restyle it (`container_query.rs:39-41`). Children lay out as roots inside definite bounds (`container_query.rs:93`), which seals the one-way street: size flows parent to query to children, never back.

Where next? Restyle these boxes by state (`styling`), and feed them from views (`views-render`).

## Sources

- Engine + entry: `crates/gpui/src/element.rs:1-3`, `crates/gpui/src/taffy.rs:31-107`
- Root auto-fill: `taffy.rs:115-137`
- Space enum: `taffy.rs:768-776`
- `Style` box model + defaults: `crates/gpui/src/style.rs:215-311,942-946`
- Builders (`flex`, direction): `crates/gpui/src/styled.rs:23-36,94,213-242`
- Units (`px`, `rems`, `relative`, `Length`): `crates/gpui/src/geometry.rs:3609-3704,3721-3736`
- Query fill + late children: `crates/gpui/src/elements/container_query.rs:17-19,33-48,69-95`
