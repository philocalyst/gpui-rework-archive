# Display, measure, and navigate text

For a label, start with [`text!`](crate::text!). It inherits the parent's font,
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
| A label with one style | [`Text`](crate::Text), usually constructed with `text!` |
| Ranges with different weights, colors, or decorations | [`StyledText`](crate::StyledText) |
| Pointer callbacks on ranges in styled text | [`InteractiveText`](crate::InteractiveText) |
| A form field, search box, or short message | The companion crate's [editable fields](#choose-an-editable-field) |
| Text in a custom-painted element | [`WindowTextSystem::shape_line`](crate::WindowTextSystem::shape_line) or [`shape_text`](crate::WindowTextSystem::shape_text) |
| Text wrapping around embedded element boxes | [`WindowTextSystem::layout_inline`](crate::WindowTextSystem::layout_inline) |

`Text` has an element ID and contributes a label to the accessibility tree.
The macro derives that ID from its call site. Repeated labels created at the
same call site need distinct IDs from [`Text::with_id`](crate::Text::with_id).
See the [ownership chapter](crate::_ownership_and_data_flow) for how a parent
scopes element identity.

> [!WARNING]
> `StyledText` does not create an accessibility node. `InteractiveText` exposes a
> label, but its clickable ranges are pointer handlers, not keyboard-operable
> links. For several links, create separate focusable controls and give each its
> own accessibility role and action. See the [accessibility chapter](crate::_accessibility).

## Separate presentation text from editable state

[`SharedString`](crate::SharedString) is immutable presentation text. A clone
retains the same contents without copying a long string. Use
[`new_static`](crate::SharedString::new_static) for a literal and
[`new`](crate::SharedString::new) to copy text from a temporary borrow. The
result can outlive that borrow; it does not observe later edits to the source.

An editor should keep its mutable buffer on the model, construct presentation
text from the current contents, and notify after a change. Replacing the model's
`SharedString` also requires notification; existing clones keep their old
contents. This is the same ownership rule as other entity fields, described in
the [ownership chapter](crate::_ownership_and_data_flow#notify-after-a-change).

## Style a range without counting characters

[`StyledText::with_highlights`](crate::StyledText::with_highlights) accepts
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
[`TextRangeExt::contains_range`](crate::TextRangeExt::contains_range) to check a
range received from elsewhere before slicing. That check proves the slice is
valid UTF-8; it does not prove that the range contains whole grapheme clusters.

Use [`StyledText::with_runs`](crate::StyledText::with_runs) when you already have
complete [`TextRun`](crate::TextRun) values. Their lengths are consecutive byte
lengths and must cover the string. Choose runs or highlights for a particular
element; the two inputs cannot be combined. Unspecified highlight properties
come from the inherited text style.

## Wrap text and element boxes in one paragraph

A block [`Div`](crate::Div) combines adjacent text and inline children into a
paragraph. Put a styled phrase in an [`inline`](crate::Styled::inline) div
when its text should continue wrapping with the surrounding sentence. Put a
badge or icon in an [`inline_flex`](crate::Styled::inline_flex) div when it
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

[`VerticalAlign`](crate::VerticalAlign) positions an inline box against its
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

[`StyledText::layout`](crate::StyledText::layout) exposes the geometry of an
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

## Measure the text you will paint

Shaping selects fonts and glyphs, applies substitutions and positioning, and
produces advances. Layout then assigns visual rows. Rasterization produces the
glyph pixels used during painting. These stages have different outputs: a
glyph bitmap does not tell you where a word should wrap.

A window exposes its [`WindowTextSystem`](crate::WindowTextSystem), which
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
fallback fonts. A [`TextRun`](crate::TextRun) can produce several paint fragments
with different resolved font IDs. Measure the shaped result even if the
requested font appears to cover the whole string.

Use `shape_text` for hard line breaks or soft wrapping. Keep its
[`ShapedText`](crate::ShapedText) result for both painting and interaction
geometry. The line height passed to paint and hit testing must agree. Its
[`size`](crate::ShapedTextLayout::size) uses that height for each visual row;
it does not measure the ink around the glyphs. Paint run backgrounds before
foreground glyphs and decorations.

[`FontMetrics`](crate::FontMetrics) helps place baselines and decorations.
Its raw values are in font design units; the helper methods scale them to
logical [`Pixels`](crate::Pixels). Font-wide bounds are backend estimates,
not a substitute for a shaped string's width or a glyph's painted bounds.
[`FontId`](crate::FontId) identifies a face within one text backend. It is not
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
[`TextMovement`](crate::TextMovement) with
[`ShapedTextLayout::caret_movement`](crate::ShapedTextLayout::caret_movement),
and carry its returned horizontal coordinate into successive up/down moves.

[`CaretPosition`](crate::CaretPosition) pairs a byte offset with
[`CaretAffinity`](crate::CaretAffinity). At a soft wrap, one offset can belong
to the preceding row's end or the following row's start. Affinity chooses the
logical neighbor; it does not mean left or right. Constructing a caret does
not validate it. Normalize an external position with
[`ShapedTextLayout::normalized_caret`](crate::ShapedTextLayout::normalized_caret).

[`CaretSelection`](crate::CaretSelection) records a fixed anchor and an active
caret. Use [`selection_movement`](crate::ShapedTextLayout::selection_movement)
to move or extend it. Converting `start..end` places the active caret at
`start`; construct both endpoints explicitly when you want the other direction.

> [!NOTE]
> Layout positions address the exact string that was shaped. Case conversion
> and truncation can change that string. Keep the original editing buffer
> separate from display text, and map positions explicitly if you need to move
> between them. [`TextLayout::text`](crate::TextLayout::text) returns the measured
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
subscription on each render. The [ownership chapter](crate::_ownership_and_data_flow)
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
[`EntityInputHandler`](crate::EntityInputHandler), run
`cargo run --example view_example`. Its implementation is in
`crates/gpui/examples/view_example/example_editor.rs`, with drawing in
`example_editor/paint.rs`. This lower-level route gives you the editing model
and painting policy to maintain as well as the platform input contract. Read
the [input chapter](crate::_documentation::input) before implementing that
contract, then use the [testing chapter](https://gpui-ce.github.io/book/testing.html)
to exercise edits and selection without relying on a human to type them.

For a complete program that displays text, the
[text walkthrough](https://gpui-ce.github.io/examples/text/) shows inherited
styles and wrapping. The [hit-testing walkthrough](https://gpui-ce.github.io/examples/text-hit-testing/)
adds the connection between byte offsets, pointer positions, and a painted marker.
