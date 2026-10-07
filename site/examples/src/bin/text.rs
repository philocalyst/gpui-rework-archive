#[path = "../support.rs"]
mod support;

// docs:step shaping | Shape text from Unicode source
// GPUI accepts ordinary Rust UTF-8 strings. The text element shapes the whole
// string, chooses fallback faces for missing glyphs, and keeps the source text
// available for accessibility. This example uses a combining sequence and an
// emoji so the visible glyph count is deliberately different from the number
// of Rust `char`s. The IBM Plex Sans preview font is Latin-focused, so the
// emoji may use a platform fallback or show as a missing glyph; that is a
// property of the installed fonts, not a different layout API.
//
// Text positions in GPUI are UTF-8 byte offsets. A byte offset is not a Unicode
// scalar index and neither is a user-visible grapheme boundary. Shaping may
// also combine several scalars into one cluster. For the Unicode terminology,
// see the [Unicode text segmentation specification](https://www.unicode.org/reports/tr29/);
// for the shaping stage, see [Wikipedia's text shaping overview](https://en.wikipedia.org/wiki/Font_shaping).
// docs:api gpui::Render gpui::Text gpui::text gpui::div
// docs:code
use gpui::{AppContext, Context, IntoElement, Render, Window, div, prelude::*, px, rgb, text};

struct TextView;
// docs:end

// docs:step wrap | Style and wrap a paragraph
// The text is laid out under the width constraint on its parent. `text_size`
// sets the font size, while `line_height` sets the distance between baselines.
// Give the paragraph a narrow width and GPUI breaks it into visual lines; the
// shaping backend still receives the complete string, including its hard and
// soft boundaries. Resize the native window or browser preview and watch the
// same source reflow without an editable-text widget.
//
// The styling here is inherited by the `Text` child. For mixed styles, build
// `TextRun` values whose `len` fields cover the complete UTF-8 string and pass
// them to a `Text` layout; every run boundary must be a UTF-8 boundary.
// docs:api gpui::Styled::text_size gpui::Styled::line_height gpui::Styled::w gpui::Pixels
// docs:code
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
                    .child(text!("Café — नमस्ते — GPUI wraps shaped text here.")),
            )
    }
}
// docs:end

// docs:step run | Run the same view everywhere
// `support::run` supplies the native or web platform, opens a window, and
// mounts the entity returned by `cx.new`. The view therefore uses the same
// GPUI render path in a browser preview and in a native application. There is
// no custom text widget to synchronize: the platform text system handles font
// resolution, shaping, fallback, line breaking, and painting for this tree.
//
// Try replacing the paragraph with a longer sentence, then resize the window.
// The width constraint changes wrapping; the UTF-8 source and shaping rules do
// not change. If you later add selection or editing, preserve byte boundaries
// when converting between document offsets and grapheme-aware UI movement.
// docs:api gpui::AppContext gpui::Render
// docs:code
pub fn main() {
    support::run(|_window, cx| cx.new(|_cx| TextView));
}
// docs:end
