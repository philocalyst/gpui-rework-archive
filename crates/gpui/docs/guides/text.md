# Display and style text

Any string is an element, so `div().child("Saved")` works. Set text style on any
element, and its children inherit it. Use [`StyledText`] when one paragraph needs
several styles, and [`InteractiveText`] when parts of it must respond to clicks.

## Show a string

Pass a `&str`, a `String` or a [`SharedString`] to [`ParentElement::child`]:

```rust
# use gpui::*;
let label = div().child("Saved");
let count = div().child(format!("{} files", 3));
```

Strings are not accessible to screen readers. To make a piece of text
accessible, wrap it in [`text!`], which gives it a stable ID. See the
[accessibility guide](crate::_documentation::guides::accessibility) for the rules.

## Style text and let it inherit

Text style methods set a property on the element they are called on. The
property applies to the element's text and cascades to its children, so you
usually style a container once:

```rust
# use gpui::*;
let card = div()
    .text_sm()
    .text_color(rgb(0x374151))
    .font_weight(FontWeight::SEMIBOLD)
    .line_height(relative(1.5))
    .child("Quarterly report")
    .child(div().italic().child("Draft, not yet reviewed"));
```

The common methods, from [`Styled`]:

| Method | Sets |
| --- | --- |
| [`Styled::text_color`] | The color of the text |
| [`Styled::text_xs`] to [`Styled::text_3xl`] | A size from the scale (`text_sm` is `0.875rem`, `text_base` is `1rem`) |
| [`Styled::text_size`] | An exact size, such as `px(15.)` or a `rems` value |
| [`Styled::font_weight`] | A [`FontWeight`] such as `FontWeight::BOLD` |
| [`Styled::italic`] and [`Styled::not_italic`] | The font style |
| [`Styled::font_family`] | A font family by name |
| [`Styled::line_height`] | A [`DefiniteLength`], such as `relative(1.5)` or `px(22.)` |
| [`Styled::letter_spacing`] | Extra space between glyphs |
| [`Styled::text_transform`] | Uppercase or lowercase rendering |

The `text_xs`-style methods are rem-based, so they follow the window's rem size.
`text_size` takes a `px` or `rems` value.

## Decorate and align

[`Styled::underline`] and [`Styled::line_through`] draw a 1px line. Change the
color and style with [`Styled::text_decoration_color`],
[`Styled::text_decoration_wavy`] and [`Styled::text_decoration_solid`], and
remove an underline set by an ancestor with [`Styled::text_decoration_none`]:

```rust
# use gpui::*;
let row = div()
    .child(div().underline().text_decoration_color(rgb(0x2563eb)).child("Terms"))
    .child(div().line_through().child("Old price"));
```

Alignment works per block. [`Styled::text_left`], [`Styled::text_center`] and
[`Styled::text_right`] use physical edges. [`Styled::text_start`] and
[`Styled::text_end`] use the edges of the text's direction, so they flip in
right-to-left layouts.

```rust
# use gpui::*;
let heading = div().w_full().text_center().child("Settings");
```

## Wrap, truncate and clamp

Text wraps to the width of its element by default. Three methods change that:

- [`Styled::truncate`] turns off wrapping, hides overflow and puts an ellipsis
  at the end. Use it for a single line, such as a title in a toolbar.
- [`Styled::whitespace_nowrap`] turns off wrapping without any ellipsis.
  [`Styled::whitespace_normal`] turns wrapping back on.
- [`Styled::line_clamp`] shows at most `n` lines and drops the rest. It hides
  overflow but adds no ellipsis by itself. Add [`Styled::text_ellipsis`] to put
  an ellipsis at the end of the last visible line.

```rust
# use gpui::*;
let title = div().w(px(240.)).truncate().child("A long document title");

let summary = div()
    .w(px(240.))
    .line_clamp(2)
    .text_ellipsis()
    .child("A paragraph long enough to need more than two lines of space.");
```

For file names, [`Styled::text_ellipsis_start`] and
[`Styled::text_ellipsis_middle`] keep the end or both ends visible.
[`Styled::text_overflow`] takes any [`TextOverflow`].

## Mix styles in one paragraph

[`StyledText`] styles byte ranges of one string. Each highlight is a range and a
[`HighlightStyle`]. Only the fields you set change, and the rest come from the
inherited text style:

```rust
# use gpui::*;
# struct Demo;
# impl Render for Demo {
#     fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
let message = StyledText::new("Save the file before quitting.").with_highlights([
    (
        0..4,
        HighlightStyle {
            font_weight: Some(FontWeight::BOLD),
            ..Default::default()
        },
    ),
    (21..29, HighlightStyle::from(rgb(0xdc2626))),
]);

div().text_base().child(message)
#     }
# }
# let mut app = TestApp::new();
# app.open_window(|_, _| Demo);
```

Ranges are byte offsets, not character offsets. They must fall on character
boundaries. Ranges that do not cover the whole string are filled with the
inherited style. Use [`StyledText::with_default_highlights`] when you want to
pass one base [`TextStyle`] explicitly, or [`StyledText::with_runs`] when you
need full control over every [`TextRun`]. Use [`StyledText::with_font_family_overrides`]
to change the family of a range without building runs.

## Make ranges clickable

[`InteractiveText`] wraps a [`StyledText`] with hit testing. Give it an
[`ElementId`], the list of clickable ranges and a listener. The listener runs
only when the mouse goes down and up inside the same range, and it receives the
index of that range in your list:

```rust
# use gpui::*;
# struct Demo;
# impl Render for Demo {
#     fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
let text = "Read the docs or file an issue.";
let links = vec![5..13, 25..30];

let link_style = |_range: &std::ops::Range<usize>| HighlightStyle {
    underline: Some(UnderlineStyle {
        thickness: px(1.),
        ..Default::default()
    }),
    ..HighlightStyle::from(rgb(0x2563eb))
};

let styled = StyledText::new(text).with_highlights(
    links
        .iter()
        .map(|range| (range.clone(), link_style(range))),
);

InteractiveText::new("links", styled).on_click(links, |link_index, _window, _cx| {
    // `link_index` is 0 for "the docs" and 1 for "issue".
    let _ = link_index;
})
#     }
# }
# let mut app = TestApp::new();
# app.open_window(|_, _| Demo);
```

[`InteractiveText::on_hover`] reports the byte index of the character under the
pointer, or `None` when the pointer is over the element but not over a character.
It doesn't fire when the pointer leaves the element. [`InteractiveText::tooltip`] takes a
builder that is called with that index and may return an [`AnyView`]. The
[`ElementId`] must be unique among siblings, as for any stateful element.

## Load your own fonts

Register font files with [`TextSystem::add_fonts`], which you reach through
[`App::text_system`]. Each argument is the bytes of a font file. Call it before
you render text that uses the fonts:

```rust,no_run
# use gpui::*;
# use std::borrow::Cow;
fn load_fonts(cx: &mut App) -> anyhow::Result<()> {
    let regular = std::fs::read("assets/fonts/Inter-Regular.ttf")?;
    let bold = std::fs::read("assets/fonts/Inter-Bold.ttf")?;
    cx.text_system().add_fonts(vec![Cow::Owned(regular), Cow::Owned(bold)])
}
```

The family name comes from the font's own name table, not the file name. Once
loaded, use it with [`Styled::font_family`]:

```rust
# use gpui::*;
let note = div().font_family("Inter").child("Set in the font you loaded");
```

`add_fonts` returns an error if the platform cannot parse a font. It is safe to
call again with more fonts. To list the families the platform knows, call
[`TextSystem::all_font_names`].

## Measure text

Use [`Window::text_system`] to shape text without drawing it. Shaping needs
runs that cover the whole string. [`Window::text_style`] gives you the style in
effect at the current point in the tree, and [`TextStyle::to_run`] turns it into
a run of a given byte length:

```rust
# use gpui::*;
# struct Demo;
# impl Render for Demo {
#     fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
#         div()
#     }
# }
# let mut app = TestApp::new();
# let mut window = app.open_window(|_, _| Demo);
window.update(|_, window, _cx| {
    let text = "Measure me";
    let style = window.text_style();
    let runs = [style.to_run(text.len())];
    let line = window
        .text_system()
        .shape_line(text.into(), style.font_size.to_pixels(window.rem_size()), &runs);
    assert!(line.width() > px(0.));
});
```

[`WindowTextSystem::shape_line`] shapes one line and returns a [`ShapedLine`]
with [`ShapedLine::width`]. It panics in debug builds if the text contains a
newline. For text that may wrap or span several lines, use
[`WindowTextSystem::shape_text`]. Pass a wrap width, and read the height from
[`ShapedText::size`] with the line height you will paint with:

```rust
# use gpui::*;
# struct Demo;
# impl Render for Demo {
#     fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
#         div()
#     }
# }
# let mut app = TestApp::new();
# let mut window = app.open_window(|_, _| Demo);
window.update(|_, window, _cx| {
    let text = "A paragraph that will wrap onto several lines when it is narrow.";
    let style = window.text_style();
    let font_size = style.font_size.to_pixels(window.rem_size());
    let line_height = window.line_height();
    let runs = [style.to_run(text.len())];
    let shaped = window
        .text_system()
        .shape_text(text, font_size, &runs, Some(px(160.)), None)
        .expect("text shapes");
    // One line height for each line the text wrapped onto.
    let height = shaped.size(line_height).height;
    assert_eq!(height, line_height * shaped.line_count());
});
```

Measurement follows the same rules as painting, so the sizes match what you see.
For a [`StyledText`] that is already on screen, [`StyledText::layout`] returns
a [`TextLayout`] that maps between pixels and byte indices with
[`TextLayout::index_for_position`] and [`TextLayout::position_for_index`]. It
has data only after the element has been laid out and painted.

## Bidirectional text

Mixed left-to-right and right-to-left text is shaped with the Unicode
bidirectional algorithm, so a line of Arabic inside English prints in the right
order. [`Styled::rtl`] and [`Styled::ltr`] set the inline direction of an
element, which also decides the meaning of `text_start` and `text_end`. Leave
[`Styled::unicode_bidi`] alone unless you need to control the embedding
explicitly.

## See also

- [Text example](crate::_documentation::examples::text), which covers the scale,
  weights, decorations, wrapping and a styled paragraph. Run it with
  `cargo run --example text`.
- [Accessibility](crate::_documentation::guides::accessibility) for the `text!`
  macro and IDs.
- [Layout and style](crate::_documentation::concepts::layout_and_style) for how
  styles cascade and how an element's size is decided.
- [Images and assets](crate::_documentation::guides::images_and_assets) for
  icons that sit next to text.

[`text!`]: crate::text
