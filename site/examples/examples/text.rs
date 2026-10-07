#[path = "../src/support.rs"]
mod support;

// ## Count bytes, scalars, and graphemes separately {#shaping}
// The [`Text`] below contains `Café`: its final visible letter consists of
// an `e` and a separate combining accent. Two Rust `char`s form one grapheme.
// The [`text`] macro creates the text element from this UTF-8 string.
//
// GPUI text positions use byte offsets. Those offsets do not count scalars,
// visible letters, or glyphs. [Unicode text segmentation](https://www.unicode.org/reports/tr29/)
// defines graphemes; [text shaping](https://en.wikipedia.org/wiki/Complex_text_layout)
// selects and positions the glyphs that display them.

use gpui::{AppContext, Context, IntoElement, Render, Window, div, prelude::*, px, rgb, text};

struct TextView;

// ## Give wrapping a width {#wrap}
// The parent [`div`] limits the paragraph to 280 logical [`Pixels`].
// [`Styled::text_size`] sets its font size and [`Styled::line_height`] sets
// the distance between baselines. The child inherits those styles; GPUI finds
// line breaks within the width requested by [`Styled::w`].
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
