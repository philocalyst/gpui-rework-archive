#[path = "../src/support.rs"]
mod support;

// ## Count bytes, scalars, and graphemes separately {#shaping}
// The [`Text`] below contains `Café`: the final visible letter is an `e` plus
// a combining accent. Rust counts those as two `char`s, Unicode grapheme
// segmentation groups them as one user-perceived character, and shaping may
// place one or more glyphs for that text. The [`text`] macro creates an element
// from the UTF-8 string.
//
// GPUI text positions use UTF-8 byte offsets. A byte offset is a storage
// location, not a count of scalars, graphemes, or glyphs. [Unicode text
// segmentation](https://www.unicode.org/reports/tr29/) defines grapheme
// boundaries; [text shaping](https://en.wikipedia.org/wiki/Complex_text_layout)
// maps text and font features to positioned glyphs.

use gpui::{AppContext, Context, IntoElement, Render, Window, div, prelude::*, px, rgb, text};

struct TextView;

// ## Give wrapping a width {#wrap}
// The parent [`div`] limits the paragraph to 280 logical [`Pixels`].
// [`Styled::text_size`] sets font size and [`Styled::line_height`] sets the
// line box height. The text inherits those styles, shapes the string, then
// wraps within the width requested by [`Styled::w`]. Changing width changes
// the line breaks without changing the source bytes.
//
// For mixed styles, use [StyledText::with_runs](https://docs.rs/gpui-ce/0.2.2/gpui/struct.StyledText.html#method.with_runs).
// Each run length counts bytes, and the runs must cover the UTF-8 string at
// valid boundaries.
//
// > [!NOTE]
// > The preview includes IBM Plex Sans. Text beyond its coverage needs another
// > registered font. Native platforms may also use installed fallback faces;
// > the browser bundle does not promise that same font coverage.

impl Render for TextView {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .size_full()
            .flex()
            .items_center()
            .justify_center()
            .bg(rgb(0xf7f6f2))
            .child(
                div()
                    .w(px(280.))
                    .flex_shrink_0()
                    .text_size(px(18.))
                    .line_height(px(28.))
                    .text_color(rgb(0x202b29))
                    .child(text!("Café — Straße — GPUI wraps shaped text here.")),
            )
    }
}

// ## Make the paragraph narrower {#run}
// Change `.w(px(280.))` to `.w(px(160.))` and run again. The paragraph gains
// lines because its constraint changed. Resizing the window alone keeps the
// explicit width. The [`Render`] view uses the same tree in both platforms;
// continue to the [text guide](@/guides/text.md) for selection and caret indices.

fn component(_window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<TextView> {
    cx.new(|_cx| TextView)
}

pub fn main() {
    support::run(component);
}
