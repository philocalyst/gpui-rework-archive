# Size, place, and style an element

A style describes inputs to layout and painting. The resulting bounds describe
what layout decided. Keep that distinction when an element becomes smaller than
its requested width, a long label pushes a pane outward, or drawing escapes a box.

Use [`Styled`](crate::Styled) while building an element. Its methods record a
[`StyleRefinement`](crate::StyleRefinement), a partial set of properties.
GPUI resolves those properties into a [`Style`](crate::Style) for the frame,
then computes bounds. The [rendering chapter](crate::_documentation::rendering)
explains when an element can measure, inspect those bounds, and paint.

## Choose a length for its reference

Most interface code uses logical [`Pixels`](crate::Pixels). A 16-pixel length
remains 16 logical pixels when the window moves to a denser display; the renderer
applies the display scale. [`Rems`](crate::Rems) instead follow the window's
configured root font size, which you can change with
[`Window::set_rem_size`](crate::Window::set_rem_size).
Windows start at sixteen logical pixels per rem. Changing a label's font size
does not change that reference. When changing the window's base rem size,
schedule a [`refresh`](crate::Window::refresh) unless the surrounding update
already invalidates the window; the setter does not request a frame.

| Authored value | Meaning | Example |
| --- | --- | --- |
| `px(16.)` | A logical length independent of font size | A border or fixed-width control |
| `rems(1.)` | One root-font-size unit | Spacing that follows the application's text scale |
| `relative(0.5)` | Half a reference dimension selected by the property | A pane requesting half its containing width |
| `auto()` | Let that property's layout rules choose | Intrinsic width, an auto margin, or an unspecified position offset |

The parameter type tells you which choices are accepted:
[`AbsoluteLength`](crate::AbsoluteLength) allows pixels and rems;
[`DefiniteLength`](crate::DefiniteLength) adds fractions;
[`Length`](crate::Length) adds `auto`. Border widths accept absolute lengths.
Padding accepts definite lengths. Widths and margins accept `Length`.

```rust
use gpui::{AbsoluteLength, px, relative, rems};

let root_size = px(20.);
assert_eq!(rems(0.5).to_pixels(root_size), px(10.));
assert_eq!(relative(0.5).to_pixels(AbsoluteLength::from(px(240.)), root_size), px(120.));
```

Numbered spacing helpers use quarter-rem steps: `p_4()` is one rem, not four
pixels. At a 16-pixel root size it gives 16-pixel padding. `_px` is one logical
pixel. Read a preset's reference when choosing border widths or text sizes;
their naming scales differ from spacing.

> [!NOTE]
> Percentages are fractions, not pixel measurements. The property's layout
> rules choose their reference. Explicit helpers such as
> [`Edges::to_pixels`](crate::Edges::to_pixels) take a reference from the caller;
> they do not reproduce every layout percentage rule.

## Keep one pane fixed and let another shrink

In a flex row, width requests compete with available space. Give a fixed sidebar
its width and disable shrinking. Give the content pane the remaining space and
allow its minimum width to reach zero:

```rust
use gpui::{div, prelude::*, px};

let panes = div()
    .flex()
    .w(px(360.))
    .h(px(180.))
    .child(div().w(px(96.)).flex_shrink_0().child("Navigation"))
    .child(div().flex_1().min_w_0().child("Content can wrap in the remaining width"));
```

[`flex_1`](crate::Styled::flex_1) sets grow and shrink to one and the basis to
zero percent. [`flex_auto`](crate::Styled::flex_auto) uses an automatic basis,
so each child's initial size participates. [`flex_none`](crate::Styled::flex_none)
disables both growth and shrinking. A growth factor shares positive free space;
it is not a requested width. A shrink factor weights the reduction when the row
has insufficient space.

The main axis follows [`FlexDirection`](crate::FlexDirection): horizontal for a
row, vertical for a column. `gap_x` and `gap_y` still name physical axes.
`items_*` aligns the parent's children on the cross axis, `justify_*` distributes
them along the main axis, and `self_*` overrides one child's cross-axis alignment.

If a pane still refuses to shrink, inspect its minimum size and the constraints
on its ancestors. If a scrolling pane grows to fit every row, give its viewport
a finite height. The [layout walkthrough](https://gpui-ce.github.io/examples/layout/#constraints)
puts these choices in a complete window.

## Choose grid tracks deliberately

Grid helpers create repeated tracks with one sizing preset. Here a *track* is a
column or row; the lines are its boundaries.

| Column helper | Track definition | Consequence |
| --- | --- | --- |
| [`grid_cols(n)`](crate::Styled::grid_cols) | `minmax(0, 1fr)` | Equal fractions can shrink below the content's intrinsic width |
| [`grid_cols_min_content(n)`](crate::Styled::grid_cols_min_content) | `minmax(min-content, 1fr)` | Content constrains each track's minimum |
| [`grid_cols_max_content(n)`](crate::Styled::grid_cols_max_content) | `minmax(0, max-content)` | Content-sized maxima; spare space is not divided into equal fractions |

The row helpers use the corresponding definitions. In the third preset,
`max-content` is the maximum, despite the field name
[`GridTemplate::min_size`](crate::GridTemplate::min_size).

Place a child with a start/end pair of [`GridPlacement`](crate::GridPlacement).
Lines start at one; negative indices count from the explicit grid's far edge.
A span counts tracks. The [`GridLocation`](crate::GridLocation) stores these
specifications in a Rust range, but that range is not an iterator over row or
column indices. `col_span_full()` selects lines `1..-1` to cover the explicit grid.

## Separate placement, clipping, and visibility

[`absolute`](crate::Styled::absolute) positions a child independently within its
layout parent. Siblings reserve no space for it, but its dimensions still come
from layout. [`relative`](crate::Styled::relative) keeps the normal layout space
and applies offsets. These position methods do not create a new window layer.
Use [`anchored`](crate::anchored) for an overlay that must fit the window, and
[`deferred`](crate::deferred) when it needs a later paint pass.

Overflow, truncation, and hiding solve different problems:

| Operation | Effect |
| --- | --- |
| [`overflow_hidden`](crate::Styled::overflow_hidden) | Clip content escaping the box |
| `overflow_y_scroll()` on an identified `Div` | Clip the vertical viewport and install scrolling behavior |
| [`truncate`](crate::Styled::truncate) | Disable soft wrapping, replace overflowing text's end with an ellipsis, and clip |
| [`invisible`](crate::Styled::invisible) | Hide drawing while retaining layout space |
| [`hidden`](crate::Styled::hidden) | Remove the subtree from layout and drawing |

A custom element's layout box does not clip its drawing automatically. Narrow
the active mask with [`Window::with_content_mask`](crate::Window::with_content_mask)
when its paint must stay inside a region. Similarly,
[`ObjectFit::Cover`](crate::ObjectFit::Cover) computes image placement that can
extend outside its box; fitting alone does not guarantee clipping.

## Keep geometry in one coordinate space

An element's `prepaint` and `paint` bounds are already in logical,
window-local pixels. A child at `(20, 30)` inside a parent at `(100, 50)` has
window-local origin `(120, 80)`. Use that origin for painting and hitboxes;
adding the parent's origin again would move it twice.

[`Window::layout_bounds`](crate::Window::layout_bounds) includes ancestor
layout positions and the active element offset. It also snaps edges to the
device-pixel grid, then returns logical pixels. Keep those logical bounds
through prepaint and paint. The paint methods apply the display scale when
recording the scene; multiplying by it yourself would scale the drawing twice.

| Operation | What changes | What stays in place |
| --- | --- | --- |
| [`with_element_offset`](crate::Window::with_element_offset) | Adds a translation to layout bounds queried within the prepaint scope | Layout calculations and the content mask |
| [`with_absolute_element_offset`](crate::Window::with_absolute_element_offset) | Replaces that translation | The child's own position within the layout tree |
| [`with_content_mask`](crate::Window::with_content_mask) | Intersects the active clip with window-local bounds | Layout and drawing geometry |

For a custom scrolling container, keep the viewport's mask fixed and prepaint
the content under a negative scroll offset. The children then retain shifted
bounds for painting and hit testing. Apply the viewport mask during painting
too. An offset scope does not translate arbitrary points passed to
[`paint_quad`](crate::Window::paint_quad) or other paint methods.

Clipping has two parts. A hitbox captures the mask active when
[`insert_hitbox`](crate::Window::insert_hitbox) runs in prepaint. A drawing
command captures the mask active during paint. Clipping only paint can leave
an invisible part of a control clickable. The
[clipping test](https://gpui-ce.github.io/guides/testing/#check-clipping-and-input-together)
checks both the recorded mask and presses on either side of its edge.

For custom text placement,
[`parent_relative_layout_bounds`](crate::Window::parent_relative_layout_bounds)
still returns window-local bounds. Its name describes how it snaps the local
origin and size before adding the parent's origin. Use ordinary `layout_bounds`
for boxes whose adjoining edges must meet; use the parent-relative method when
text must keep a stable position within a moving container.

### Round at the boundary that needs it

[`Pixels`](crate::Pixels) stores a floating-point logical length.
[`ScaledPixels`](crate::ScaledPixels) stores the floating-point result of
applying display scaling. [`DevicePixels`](crate::DevicePixels) stores an
integer in physical pixels. The last two belong at scene, renderer, and
pixel-buffer boundaries; ordinary window paint methods take logical pixels.

Choose the rounding operation for the quantity you need:

| Operation | Result | Halfway rule |
| --- | --- | --- |
| [`round`](crate::Pixels::round) | Whole logical pixel | Away from zero |
| [`pixel_snap`](crate::Window::pixel_snap) | Device-grid position in logical units | Toward zero |
| [Convert to `DevicePixels`](crate::DevicePixels) | Whole physical pixel | Upward |

At a display scale of two, `px(10.75)` is 21.5 physical pixels.
`Pixels::round` gives `px(11.)`; `Window::pixel_snap` gives `px(10.5)`.
Both results still use logical units. The latter lies on the actual display
grid and can be passed straight to a paint method.

For a positive texture extent, rounding upward can preserve room for its
fractional last pixel. A `u32` conversion instead truncates that fraction:

```rust
use gpui::{DevicePixels, px};

let extent = px(10.25).scale(2.);
assert_eq!(DevicePixels::from(extent), DevicePixels(21));
assert_eq!(u32::from(extent), 20);
```

These conversions do not validate a buffer size or align its rows. Check
dimensions and byte-count arithmetic at the allocation boundary. Likewise,
rounding a width alone does not clip drawing or register a hitbox; those remain
separate prepaint and paint decisions.

## Know which changes reach children

Text properties such as font, color, and line height are inherited. Box properties
such as padding, border, and background belong to the element itself. Use
`text_bg` for text-fragment backgrounds and `bg` for the element's box.
The [text chapter](crate::_documentation::text) explains styled ranges and
measurement in that inherited context.

For named application colors, the optional
[`colors` module](crate::colors) supplies a small semantic palette. Installing
that palette and observing its changes are explicit operations; a dark window
appearance does not replace the palette automatically. Keep the theme policy
on an owner that can notify the affected views, as the
[ownership chapter](crate::_ownership_and_data_flow) explains.

A later setter replaces the same field, while
[`refine_style`](crate::Styled::refine_style) merges only supplied fields.
Setting `w` twice therefore keeps the second request. Filter convenience methods
are an exception: `blur` appends to a list, while `filter` replaces the list.
The supplied renderers use that list's largest blur radius for one operation,
rather than applying entries successively. See the
[drawing chapter](crate::_documentation::drawing#choose-which-pixels-to-blur)
for content versus backdrop filtering and the nesting limit, and
[`Style::paint`](crate::Style::paint) for the grouping and paint order.

## Override a field, or leave it alone

An empty [`StyleRefinement`](crate::StyleRefinement) supplies no properties.
That differs from supplying a property's default value. A flex growth factor
of zero, for example, still overrides a previous factor of one:

```rust
use gpui::{Refineable, Style, StyleRefinement};

let mut style = Style { flex_grow: 1.0, ..Default::default() };
style.refine(&StyleRefinement::default());
assert_eq!(style.flex_grow, 1.0);

style.refine(&StyleRefinement { flex_grow: Some(0.0), ..Default::default() });
assert_eq!(style.flex_grow, 0.0);
```

[`Refineable`](crate::Refineable) applies these partial updates. Nested fields
marked as refinable, including the text refinement, merge their supplied
properties rather than replacing the whole nested style. [`Cascade`](crate::Cascade)
keeps several layers in reservation order: later active layers win. It does
not implement CSS selector specificity. Deactivating a layer reveals earlier
values without changing their order.

An omitted refinement means “use the resolved value.” It need not mean “remove
the effect”: `text_decoration_none()` clears the local underline refinement and
can reveal an inherited underline. `text_decoration_0()` supplies an explicit
zero-thickness underline instead. Check the setter's contract before using a
`none` helper to reset inherited properties.

For changes over time, [`StyleTransitions`](crate::StyleTransitions) associates
motion with selected authored properties on a stable element ID. It does not
replace the need to choose sensible layout endpoints. For motion driven by an
explicit progress value, use [`AnimationExt::with_animation`](crate::AnimationExt::with_animation).
The [animation chapter](crate::_documentation::animation) compares style
transitions, sampled values, and springs, including their interruption and
reduced-motion behavior.
The [animation walkthrough](https://gpui-ce.github.io/examples/animation/)
shows that approach, including replay and reduced-motion behavior.
