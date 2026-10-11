# Layout and style

If you have written CSS, GPUI's layout will feel familiar: elements are boxes,
boxes have padding, borders and margins, and you arrange them with flexbox or
grid. The difference is that you style elements with Rust methods instead of
stylesheets, and nothing cascades except text properties.

## Styles are method calls

Every element that implements [`Styled`] has a method for each property, named
after the [Tailwind CSS](https://tailwindcss.com) class that does the same
thing:

```
# use gpui::{IntoElement, div, prelude::*, rgb};
# fn card() -> impl IntoElement {
div()
    .flex()
    .flex_col()
    .gap_2()
    .p_4()
    .rounded_lg()
    .bg(rgb(0xffffff))
    .shadow_md()
# }
```

Each call records one property in the element's [`StyleRefinement`]: a style in
which every property is optional. When GPUI draws the element, it fills in the
properties you didn't set from [`Style`]'s defaults. Interaction states work
the same way. [`hover`](InteractiveElement::hover) takes a closure that
receives an empty refinement and returns the properties that should change
while the pointer is over the element:

```
# use gpui::{IntoElement, div, prelude::*, rgb};
# fn button() -> impl IntoElement {
div()
    .id("save")
    .bg(rgb(0x2563eb))
    .hover(|style| style.bg(rgb(0x1d4ed8)))
    .active(|style| style.opacity(0.8))
    .child("Save")
# }
```

Text properties such as color, size, font and weight are the exception: they are
inherited. Setting [`text_color`](Styled::text_color) on a container colors the
text in all of its children, unless a child sets its own.

## Lengths

Lengths come in a few kinds, and the type of a method's parameter tells you
which it accepts:

| Function | Meaning |
| --- | --- |
| [`px`] | Logical pixels. GPUI multiplies by the display's scale factor for you. |
| [`rems`] | Multiples of the window's root font size, 16 pixels unless you change it with [`Window::set_rem_size`]. |
| [`relative`] | A fraction of the parent's size: `relative(0.5)` is half. |
| `auto()` | Let layout decide. |

The numbered helpers follow Tailwind's scale, where each step is a quarter of a
rem. `p_4()` is one rem of padding, or 16 pixels by default, and `gap_2()` is
half a rem:

```
use gpui::{px, rems};

let root_font_size = px(16.);
assert_eq!(rems(1.).to_pixels(root_font_size), px(16.));
assert_eq!(rems(0.25).to_pixels(root_font_size), px(4.));
```

Using rems for spacing and text means the whole interface scales when the user
or your app changes the root font size.

## Flexbox and grid

A `div` lays out its children in normal block flow until you choose a layout:

* [`flex`](Styled::flex) arranges children in a row, or in a column with
  [`flex_col`](Styled::flex_col). Align them across the axis with
  [`items_center`](Styled::items_center) and friends, distribute them along it
  with [`justify_between`](Styled::justify_between) and friends, and separate
  them with [`gap_*`](Styled::gap_2).
* [`grid`](Styled::grid) places children in rows and columns. Choose the number
  of columns with [`grid_cols`](Styled::grid_cols), and span cells with
  [`col_span`](Styled::col_span).

Children size themselves from their content unless you say otherwise.
[`flex_1`](Styled::flex_1) lets a child grow to fill the remaining space, and
[`flex_shrink_0`](Styled::flex_shrink_0) stops it from shrinking below its
natural size. A common layout puts both together:

```
# use gpui::{IntoElement, div, prelude::*, px};
# fn shell() -> impl IntoElement {
div()
    .size_full()
    .flex()
    .child(div().w(px(220.)).flex_shrink_0().child("Sidebar"))
    .child(div().flex_1().min_w_0().child("Content"))
# }
```

The `min_w_0` matters. A flex child refuses to shrink below the width of its
content by default, so a long line in the content area would push the window
wider instead of wrapping. Setting its minimum width to zero lets it shrink.

GPUI computes layout with [Taffy](https://github.com/DioxusLabs/taffy), which
implements the CSS flexbox and grid algorithms. When a layout surprises you, the
CSS documentation for the same property is usually the right reference.

## Overflow, scrolling and stacking

Content that doesn't fit spills out of its box by default.
[`overflow_hidden`](Styled::overflow_hidden) clips it.
[`overflow_y_scroll`](StatefulInteractiveElement::overflow_y_scroll) makes the
box scroll, which needs an [`id`](InteractiveElement::id), because the scroll
position is state that GPUI keeps between frames. A scrolling box also needs a
bounded height: a `flex_1` child of a column, or an explicit height.

[`absolute`](Styled::absolute) takes an element out of the flow and positions
it relative to its nearest positioned ancestor, with `top`, `left` and friends.
Elements paint in tree order, so later siblings draw on top. For menus and
popovers that must draw above everything and stay inside the window, use
[`anchored`] and [`deferred`] instead.

## Responsive layout

GPUI has no media queries. A view can read [`Window::viewport_size`] in `render`
and choose a layout, and it is re-rendered when the window is resized. When a
component should adapt to the space *it* is given rather than the window's size,
wrap it in a [`container_query`], which renders its contents with the size it
was laid out at.

## Writing direction

Layout follows the writing direction. Call [`rtl`](Styled::rtl) on a container
to lay out its contents right to left, for languages such as Arabic and Hebrew.
