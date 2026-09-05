+++
title = "Styling"
description = "Compose appearance with the fluent styling API: dimensions, color, spacing, borders, and type."
weight = 15
aliases = ["/rendering/styling.html"]
[extra]
category = "RENDERING"
legacy_source = "gpui-ce-docs/build/html/rendering/styling.html"
+++

**Styled** is the opt-in trait that turns any element into a Tailwind-like builder chain (`crates/gpui/src/styled.rs:23-36`). One `style()` accessor holds your base look, generated helpers cover margins through shadows, and hand-written shorthands add flex, filters, and friends. Chain with joy; state layers land on top.

```rust
// Each builder returns Self, so calls chain left to right into one style.
// `.flex()` + `.items_center()` arrange children; `.bg(...)` fills the box.
// `.rounded_md()` softens corners. `.child("styled")` fills it with words.
// Nothing paints until layout commits bounds — builders only describe.
fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
    div().flex().items_center().bg(rgb(0x1e1e2e)).rounded_md().child("styled")
}
```

Base values live in `Style`, per-state tweaks ride in `StyleRefinement` overlays fused by `Style::refine` ([crates/gpui/src/style.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/style.rs), `crates/gpui/src/view.rs:327-328`). Every state closure below takes a fresh default refinement and returns it changed. Deltas compose; they never replace the base.

## States and layering

Each pseudo-state stores one optional refinement on `Interactivity` (`crates/gpui/src/elements/div.rs:2161-2174`). GPUI layers them over the base in a fixed order inside `compute_style_internal` (`div.rs:3455-3595`).

```rust
// `.hover(...)` recolors while the pointer rests on YOUR hitbox.
// `.group_hover("card", ...)` recolors while the pointer rests on ANY
// member of the "card" group — pair it with `.group("card")` there.
// `.active(...)` fires while this element is pressed. `.focus(...)`
// fires while its own handle holds focus. Each closure edits a blank
// refinement, so write only the delta — base carries the rest.
div()
    .id("buy") // state needs identity: hover, focus, and press all key off it
    .hover(|s| s.bg(red())) // pointer over me (`div.rs:864`)
    .group_hover("card", |s| s.bg(blue())) // pointer over my group (`div.rs:874`)
    .active(|s| s.bg(green())) // pressed right now (`div.rs:1586`)
```

The full order runs base, then `in_focus`, `focus`, `focus_visible`, `group_hover`, `hover`, drag-over, `group_active`, `active`, and finally transitions (`div.rs:3463-3595`). Later wins on conflicts, so `active` beats `hover`. Hover and group-hover both sleep during an active drag and ignore touch input (`div.rs:3487-3526`). Same-property stacks across states are last-write-wins by design.

|  |  |  |
| --- | --- | --- |
| Builder | Fires when | Needs |
| `.hover` | pointer over this hitbox | `.id()` + mouse |
| `.group_hover` | pointer over group mate | shared group name |
| `.focus` | own handle focused | `track_focus` |
| `.in_focus` | inside focused subtree | `track_focus` nearby |
| `.focus_visible` | focused by keyboard | keyboard last input |
| `.active` | pressed now | `.id()` |

Table 34: Every state style, its trigger, and its price of admission.

## Focus flavors and listeners

Three focus builders sound alike and behave differently (`div.rs:1299-1325`). `focus` styles the element holding focus itself. `in_focus` styles anything inside the focused subtree, like a toolbar glowing while its input types. `focus_visible` matches CSS `:focus-visible`: focused plus last input came from the keyboard (`div.rs:3479-3484`).

```rust
// `.track_focus(&handle)` makes the div focusable — without it, the three
// builders below stay dark forever. `.focus(...)` answers "am I focused".
// `.in_focus(...)` answers "is my family focused". `.focus_visible(...)`
// answers "focused AND keyboard-driven", perfect for focus rings that
// stay out of mouse users' way.
div()
    .track_focus(&self.focus_handle) // opt into focus at all
    .focus(|s| s.border_color(blue())) // I hold focus
    .focus_visible(|s| s.ring(px(2.))) // keyboard focus: ring me
```

`.hover()` asserts single-set in debug builds: calling it twice panics (`div.rs:864-869`). `.on_hover` is the odd one out — a `(&bool, &mut Window, &mut App)` side-effect listener, not a style (`div.rs:682`). Reach for it when hovering must do work, like prefetching.

> **Pitfall.** Stacking `hover`, `group_hover`, and `active` refinements that all set one property is last-write-wins and baffling. Hold steady state in the base chain; reserve state closures for deltas.

## Transitions animate deltas

`.transitions(|t| …)` builds a `StyleTransitions` value that eases property changes instead of snapping (`div.rs:784-792`). It quietly claims a code-location id when your element lacks one, so repeated elements at one call site still need explicit `.id()` for independent motion. While anything animates, GPUI requests another frame and honors reduced-motion (`div.rs:3577-3593`).

```rust
// `StyleTransitions::new()` starts empty; each chained call names one
// property plus its timing. Keep the set tiny — opacity, color, offsets.
// Layout-sized properties re-run layout every tick and feel sluggish.
// With no `.id()`, every sibling shares one motion clock: name them.
div().id("toast").transitions(|t| t.bg(std::time::Duration::from_millis(200)))
```

> **Tip.** Animate paint, not layout: colors and opacity stay cheap, widths and gaps cost a layout pass per tick. Your fans stay quieter too.

Where next? Size what you just styled (`layout`), and wrap it in a view (`views-render`).

## Sources

- `Styled` + helpers: `crates/gpui/src/styled.rs:23-110`
- Base `Style`: [crates/gpui/src/style.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/style.rs)
- `refine` at view root: `crates/gpui/src/view.rs:327-328`
- State slots: `crates/gpui/src/elements/div.rs:2161-2174`
- Layer order: `div.rs:3455-3595`
- State builders: `div.rs:864-881,1299-1325,1586-1605`
- `transitions` id claim: `div.rs:784-792`
- `on_hover` listener: `div.rs:682-708`
