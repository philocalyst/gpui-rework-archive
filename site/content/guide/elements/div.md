+++
title = "div : the universal container"
description = "Meet the general-purpose container at the center of GPUI composition."
weight = 16
aliases = ["/elements/div.html"]
[extra]
category = "ELEMENTS"
legacy_source = "gpui-ce-docs/build/html/elements/div.html"
+++

If you learn one element, make it this one. `div()` creates a `Div`, the box nearly every GPUI tree is built from ([crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)). Think HTML `<div>` meets Tailwind, with DOM-like events riding along for free.

```rust
fn render(&mut self, _w: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
    // .flex() lays children out in a row; .gap_2() breathes between them.
    // .child() nests another element. That's the whole trick — boxes in boxes.
    div().flex().gap_2().child("left").child("right")
}
```

Under the hood a `Div` is two systems holding hands: `Interactivity` (it listens) plus `StyleRefinement` (it looks good). You can combine those two systems yourself to build brand-new elements — but on most days, just reach for `div`.

## Children and identity

A bare `div` is stateless: GPUI rebuilds it fresh every frame and remembers nothing. The moment you want clicks, hovers, drags, or focus, give it an id. That id is how GPUI recognizes **your** box across frames.

```rust
div()
    .id("ok-button") // claim an identity so state has somewhere to live
    .on_click(|_event, _window, _cx| {
        // this closure survives across frames because "ok-button" does
        println!("clicked");
    })
```

`on_click` lives on the stateful path (`div.rs:597`), so without `.id(...)` there is simply nothing for the listener to hang onto. If your button ever feels dead, check the id first — it fixes this bug nine times out of ten.

> **Tip.** Pick ids that read like names, not numbers: `"ok-button"` beats `"btn-3"`. Your future self, debugging at midnight, says thanks.

## What `div` bundles

|  |  |
| --- | --- |
| Capability | Where it lives |
| layout + Tailwind style | `Styled` / `StyleRefinement` |
| mouse, scroll, keyboard events | `Interactivity`, via `Div` |
| `on_click` | `div.rs:597` — needs `.id()` |
| `on_hover` | `div.rs:682` — needs `.id()` |
| nesting boxes | `ParentElement::child` |

Table 1: Everything a `div` gives you in one glance.

Style it with the same Tailwind-like builders you already know — `flex`, gaps, padding, borders, rounded corners. The styling page walks the full model. One rule of thumb carries you far: decide sizes from your **view data**, never from last frame’s boxes.

> **Pitfall.** Calling `.on_click(...)` with no `.id(...)`. Your handler quietly never fires, and nothing warns you. Add `.id("something-unique")` first, click happily ever after.

Where next? Give your boxes words (`text`), pictures (`media`), or very long families (`lists`).

## Sources

- `div()` constructor: [crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)
- `on_click`: `div.rs:597`; `on_hover`: `div.rs:682`
- Design note (Interactivity + StyleRefinement): `div.rs:1-21`
