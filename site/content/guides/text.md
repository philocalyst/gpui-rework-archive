+++
aliases = ["elements/text-input.html", "elements/text.html", "graphics/text-system.html", "guide/elements/text-input/", "guide/elements/text/", "guide/graphics/text-system/"]
title = "Display, measure, and navigate text"
description = "Choose a text element, shape and measure it, and keep editing positions tied to the right string."
weight = 80
+++

<!-- Mirrored from crates/gpui/docs/text.md; edit that source. -->

For a label, start with [`text!`](https://docs.rs/gpui-ce/0.2.2/gpui/macro.text.html). It inherits the parent's font,
color, line height, and wrapping policy. GPUI measures it during layout and
paints it at the assigned position. You do not need to resolve fonts or draw
glyphs yourself.

```rust
use gpui::{IntoElement, prelude::*, text};

fn greeting(name: &str) -> impl IntoElement {
    gpui::div().text_lg().child(text!(format!("Hello, {name}")))
}
```

Choose an entry point for the content and interaction you need:

| Content | Entry point |
| --- | --- |
| A label with one style | [`Text`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Text.html), usually constructed with `text!` |
| Ranges with different weights, colors, or decorations | [`StyledText`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.StyledText.html) |
| Pointer callbacks on ranges in styled text | [`InteractiveText`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.InteractiveText.html) |
| A form field, search box, or short message | The companion crate's [editable fields](#choose-an-editable-field) |
| Text in a custom-painted element | [`WindowTextSystem::shape_line`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.WindowTextSystem.html#method.shape_line) or [`shape_text`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.WindowTextSystem.html#method.shape_text) |
| Text wrapping around embedded element boxes | [`WindowTextSystem::layout_inline`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.WindowTextSystem.html#method.layout_inline) |

`Text` has an element ID and contributes a label to the accessibility tree.
The macro derives that ID from its call site. Repeated labels created at the
same call site need distinct IDs from [`Text::with_id`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Text.html#method.with_id).
See the [ownership chapter](https://gpui-ce.github.io/book/ownership.html) for how a parent
scopes element identity.

> [!WARNING]
> `StyledText` does not create an accessibility node. `InteractiveText` exposes a
> label, but its clickable ranges are pointer handlers, not keyboard-operable
> links. For several links, create separate focusable controls and give each its
> own accessibility role and action. See the [accessibility chapter](https://gpui-ce.github.io/book/accessibility.html).

## Separate presentation text from editable state

[`SharedString`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.SharedString.html) is immutable presentation text. A clone
retains the same contents without copying a long string. Use
[`new_static`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.SharedString.html#method.new_static) for a literal and
[`new`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.SharedString.html#method.new) to copy text from a temporary borrow. The
result can outlive that borrow; it does not observe later edits to the source.

An editor should keep its mutable buffer on the model, construct presentation
text from the current contents, and notify after a change. Replacing the model's
`SharedString` also requires notification; existing clones keep their old
contents. This is the same ownership rule as other entity fields, described in
the [ownership chapter](https://gpui-ce.github.io/book/ownership.html#notify-after-a-change).

## Style a range without counting characters

[`StyledText::with_highlights`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.StyledText.html#method.with_highlights) accepts
nonoverlapping ranges in ascending order. Each range addresses **UTF-8 bytes**
in the supplied string. Find the text you want to style, then use its byte
length to construct the range:

```rust
use gpui::{FontWeight, HighlightStyle, SharedString, StyledText};

let source = SharedString::from("Meet at the café.");
let start = source.find("café").unwrap();
let emphasis = HighlightStyle {
    font_weight: Some(FontWeight::BOLD),
    ..Default::default()
};
let label = StyledText::new(source.clone())
    .with_highlights([(start..start + "café".len(), emphasis)]);
```

The range's end includes both bytes of `é`. Counting four characters and using
that count as a byte length would cut the character in half. Use
[`TextRangeExt::contains_range`](https://docs.rs/gpui-ce/0.2.2/gpui/trait.TextRangeExt.html#tymethod.contains_range) to check a
range received from elsewhere before slicing. That check proves the slice is
valid UTF-8; it does not prove that the range contains whole grapheme clusters.

Use [`StyledText::with_runs`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.StyledText.html#method.with_runs) when you already have
complete [`TextRun`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.TextRun.html) values. Their lengths are consecutive byte
lengths and must cover the string. Choose runs or highlights for a particular
element; the two inputs cannot be combined. Unspecified highlight properties
come from the inherited text style.

## Wrap text and element boxes in one paragraph

A block [`Div`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Div.html) combines adjacent text and inline children into a
paragraph. Put a styled phrase in an [`inline`](https://docs.rs/gpui-ce/0.2.2/gpui/trait.Styled.html#method.inline) div
when its text should continue wrapping with the surrounding sentence. Put a
badge or icon in an [`inline_flex`](https://docs.rs/gpui-ce/0.2.2/gpui/trait.Styled.html#method.inline_flex) div when it
should stay together as one box:

```rust
use gpui::{FontWeight, div, prelude::*, px, rgb, text};

let status = div()
    .block()
    .w(px(280.))
    .child(text!("Build "))
    .child(div().inline().font_weight(FontWeight::BOLD).child(text!("42")))
    .child(text!(" "))
    .child(
        div().inline_flex().px_1().align_middle().bg(rgb(0xe4e9ed))
            .child(text!("beta"))
    )
    .child(text!(" is ready."));
```

The spaces belong to the strings. GPUI does not insert a separator between
children. A block child ends the current paragraph; an absolutely positioned
child contributes no inline box. A flex parent instead gives each child an
independent flex-item box, so `flex_wrap` cannot replace paragraph wrapping.

[`VerticalAlign`](https://docs.rs/gpui-ce/0.2.2/gpui/enum.VerticalAlign.html) positions an inline box against its
line's text metrics. `align_middle` aligns its midpoint with the parent
baseline plus half the font's x-height; it does not center the badge in the
whole paragraph. A wrapped or bidirectional span may have several disjoint
regions. Its enclosing bounds include the gaps, so use GPUI's registered
hitboxes rather than treating that bounding rectangle as a clickable region.

> [!NOTE]
> Text-rewriting truncation is currently skipped for a paragraph containing
> element boxes. Keep such a paragraph in a bounded, clipped container when
> overflow must be hidden. An ellipsis on ordinary text does not imply that
> embedded widgets will be removed or replaced.

### Query a text element's own geometry

[`StyledText::layout`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.StyledText.html#method.layout) exposes the geometry of an
independently measured text element. Clone the handle before moving the text
into the tree, then query it after layout and prepaint. Put that text directly
in a flex container so it receives its own measurement. The text can still
wrap to the container's width.

A block or inline div can gather the same text into a shared paragraph.
The paragraph then owns the layout and does not populate the individual text
handle. Waiting until paint does not make that handle describe the paragraph. The
[hit-testing walkthrough](https://gpui-ce.github.io/examples/text-hit-testing/#layout)
uses a flex column and queries its text handle from an input callback and a
later sibling's prepaint callback. It maps a click to a byte offset and paints
that offset back at the corresponding window-space position.

## Choose a font request, then measure its result

[`font`](https://docs.rs/gpui-ce/0.2.2/gpui/fn.font.html) creates a family request with normal weight, width, and
face style. It does not load a font or resolve every character to one face.
Register bundled bytes through [`TextSystem::add_fonts`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.TextSystem.html#method.add_fonts)
before opening views that use them. Native backends can also find installed
families; the browser backend needs registered bytes. A font's embedded family
name identifies it, not its asset filename.

Use [`font_family`](https://docs.rs/gpui-ce/0.2.2/gpui/trait.Styled.html#method.font_family) to change just the family while
preserving inherited weight and other typography. Use [`font`](https://docs.rs/gpui-ce/0.2.2/gpui/trait.Styled.html#method.font)
to set the family, features, weight, width, and face style together. Neither
method changes font size, line height, or color. A font request's `None` fallback
list leaves the parent's preferences inherited; supply an empty
[`FontFallbacks`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.FontFallbacks.html) list when you want no additional named
preferences. Backend fallback remains available.

An [OpenType feature](https://learn.microsoft.com/en-us/typography/opentype/spec/featurelist)
asks the font for a particular substitution or positioning rule. For example,
tabular figures give digits equal advances, so replacing one digit need not
shift the rest of a total:

```rust
use std::sync::Arc;
use gpui::{FontFeatures, SharedString, div, prelude::*};

fn total_label(value: &str) -> impl IntoElement {
    div()
        .font_features(FontFeatures(Arc::new(vec![("tnum".into(), 1)])))
        .child(SharedString::new(value))
}
```

The inherited font must support `tnum` for that request to change its figures.
[`FontFeatures::disable_ligatures`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.FontFeatures.html#method.disable_ligatures)
disables only contextual alternates (`calt`), often used for programming-font
ligatures. It does not disable every ligature feature. Read a tag's definition
and check the chosen font rather than treating all feature settings as booleans.

> [!WARNING]
> Deserializing font features does not validate a shaping request. Parley layout
> panics on malformed tags or values above `u16::MAX`, including through
> `shape_text`, whose `Result` does not capture backend invariant failures.
> Validate externally supplied settings against [`FontFeatures`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.FontFeatures.html)'s
> contract before applying them to a view.

## Measure the text you will paint

Shaping selects fonts and glyphs, applies substitutions and positioning, and
produces advances. Layout then assigns visual rows. Rasterization produces the
glyph pixels used during painting. These stages have different outputs: a
glyph bitmap does not tell you where a word should wrap.

A window exposes its [`WindowTextSystem`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.WindowTextSystem.html), which
shares the app's font database and keeps a layout cache for that window. For
one unwrapped line, shape the whole string before reading its advance width:

```rust
use gpui::{Pixels, SharedString, Window, px};

fn label_width(source: SharedString, window: &Window) -> Pixels {
    let run = window.text_style().to_run(source.len());
    window.text_system().shape_line(source, px(16.), &[run]).width()
}
```

Adding the widths of individual characters misses kerning, ligatures, and
fallback fonts. A [`TextRun`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.TextRun.html) can produce several paint fragments
with different resolved font IDs. Measure the shaped result even if the
requested font appears to cover the whole string.

Use `shape_text` for hard line breaks or soft wrapping. Keep its
[`ShapedText`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.ShapedText.html) result for both painting and interaction
geometry. The line height passed to paint and hit testing must agree. Its
[`size`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.ShapedTextLayout.html#method.size) uses that height for each visual row;
it does not measure the ink around the glyphs. Paint run backgrounds before
foreground glyphs and decorations.

For unwrapped text centered or right-aligned inside a wider box, use
[`shape_text_with_options`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.WindowTextSystem.html#method.shape_text_with_options)
with [`TextLayoutOptions::alignment_width`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.TextLayoutOptions.html#structfield.alignment_width).
That width positions the rows; it does not size an element. In the Parley backend,
wrapped rows align within the wrapping width instead.

> [!NOTE]
> A line-breaking budget does not necessarily hide text. Parley stops inserting
> soft breaks after the budget, so the remaining text can overflow horizontally;
> source newlines still create rows. Use element overflow clipping to hide excess
> content and `text_ellipsis` when removed text needs a visible marker. See
> [`TextStyle::line_clamp`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.TextStyle.html#structfield.line_clamp) for the style-level request.

[`FontMetrics`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.FontMetrics.html) helps place baselines and decorations.
Its raw values are in font design units; the helper methods scale them to
logical [`Pixels`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Pixels.html). Font-wide bounds are backend estimates,
not a substitute for a shaped string's width or a glyph's painted bounds.
[`FontId`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.FontId.html) identifies a face within one text backend. It is not
a portable font identifier to save and reuse in another app.

## Keep source positions separate from visual positions

GPUI layout ranges and caret indices use UTF-8 byte offsets. A
[grapheme cluster](https://www.unicode.org/reports/tr29/#Grapheme_Cluster_Boundaries)
approximates a character as a reader perceives it: `e` followed by a combining
accent is one cluster, and an emoji sequence can contain several scalars.
A glyph is a drawing shape selected by the font. Neither cluster counts nor
glyph counts are byte offsets.

Logical order follows the source string. Visual order follows the laid-out
rows, which can contain both left-to-right and right-to-left text. Incrementing
a byte offset is therefore unsuitable for moving a caret to the right. Use
[`TextMovement`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.TextMovement.html) with
[`ShapedTextLayout::caret_movement`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.ShapedTextLayout.html#method.caret_movement),
and carry its returned horizontal coordinate into successive up/down moves.

[`CaretPosition`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.CaretPosition.html) pairs a byte offset with
[`CaretAffinity`](https://docs.rs/gpui-ce/0.2.2/gpui/enum.CaretAffinity.html). At a soft wrap, one offset can belong
to the preceding row's end or the following row's start. Affinity chooses the
logical neighbor; it does not mean left or right. Constructing a caret does
not validate it. Normalize an external position with
[`ShapedTextLayout::normalized_caret`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.ShapedTextLayout.html#method.normalized_caret).

[`CaretSelection`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.CaretSelection.html) records a fixed anchor and an active
caret. Use [`selection_movement`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.ShapedTextLayout.html#method.selection_movement)
to move or extend it. Converting `start..end` places the active caret at
`start`; construct both endpoints explicitly when you want the other direction.

> [!NOTE]
> Layout positions address the exact string that was shaped. Case conversion
> and truncation can change that string. Keep the original editing buffer
> separate from display text, and map positions explicitly if you need to move
> between them. [`TextLayout::text`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.TextLayout.html#method.text) returns the measured
> display string. Platform input protocols can also use UTF-16 indices; convert
> those at the input boundary rather than passing them into layout unchanged.

## Choose an editable field

The companion crate `gpui_ce_elements` provides `text_input` and `text_area` for
forms, search boxes, and short messages. Their `EditableTextState` owns the
text, selection, composition, focus, and field-local undo history. Give each
field a stable ID, and install the module's default keyboard bindings once
when starting the app. The element installs action handlers, but those handlers
need a keymap to receive keyboard commands.

Keep the state on an owning entity when its contents must survive removing
the field from the tree. Use `EditableTextState::use_keyed_init` during
rendering when the contents should instead follow the field's presence.
Create subscriptions once with that state, rather than adding a new detached
subscription on each render. The [ownership chapter](https://gpui-ce.github.io/book/ownership.html)
explains both lifetimes.

Read the companion module and run its complete native example from this
checkout:

```sh
cargo doc -p gpui_ce_elements --no-deps --open
cargo run -p gpui_ce_elements --example editable_text
```

`text_input` removes CR and LF from user-entered paste and composition text;
programmatic replacement can still supply them. A byte limit constrains the
encoded size, not the number of visible characters. Neither behavior validates
an email address, search expression, or other application value. Check those
rules before accepting or submitting the value.

For a custom editor built directly on
[`EntityInputHandler`](https://docs.rs/gpui-ce/0.2.2/gpui/trait.EntityInputHandler.html), run
`cargo run --example view_example`. Its implementation is in
`crates/gpui/examples/view_example/example_editor.rs`, with drawing in
`example_editor/paint.rs`. This lower-level route gives you the editing model
and painting policy to maintain as well as the platform input contract. Read
the [input chapter](https://gpui-ce.github.io/book/input.html) before implementing that
contract, then use the [testing chapter](https://gpui-ce.github.io/book/testing.html)
to exercise edits and selection without relying on a human to type them.

For a complete program that displays text, the
[text walkthrough](https://gpui-ce.github.io/examples/text/) shows inherited
styles and wrapping. The [hit-testing walkthrough](https://gpui-ce.github.io/examples/text-hit-testing/)
adds the connection between byte offsets, pointer positions, and a painted marker.
