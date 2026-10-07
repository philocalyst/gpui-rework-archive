//! Text system example.

#[path = "../shared/prelude.rs"]
mod example_prelude;

use gpui::{
    Context, Div, FontFallbacks, FontFeatures, FontStyle, FontWeight, FontWidth, HighlightStyle,
    Render, StrikethroughStyle, StyledText, TextTransform, UnderlineStyle, Window, div, font, hsla,
    prelude::*, px, relative, rgb, size,
};

const BACKGROUND: u32 = 0x0d1117;
const SURFACE: u32 = 0x161b22;
const SAMPLE_SURFACE: u32 = 0x21262d;
const BORDER: u32 = 0x30363d;
const TEXT: u32 = 0xe6edf3;
const MUTED: u32 = 0x8b949e;
const ACCENT: u32 = 0x58a6ff;

struct TextSystemExample;

fn section(
    title: &'static str,
    description: &'static str,
    content: impl IntoElement,
) -> impl IntoElement {
    div()
        .w_full()
        .min_w_0()
        .flex()
        .flex_col()
        .gap_3()
        .p_5()
        .rounded_lg()
        .border_1()
        .border_color(rgb(BORDER))
        .bg(rgb(SURFACE))
        .child(
            div()
                .flex()
                .flex_col()
                .gap_1()
                .child(
                    div()
                        .text_lg()
                        .font_weight(FontWeight::SEMIBOLD)
                        .child(title),
                )
                .child(div().text_sm().text_color(rgb(MUTED)).child(description)),
        )
        .child(content)
}

fn sample(label: &'static str, content: impl IntoElement) -> impl IntoElement {
    div()
        .min_w(px(240.))
        .max_w_full()
        .flex_1()
        .flex()
        .flex_col()
        .gap_2()
        .p_4()
        .rounded_md()
        .bg(rgb(SAMPLE_SURFACE))
        .child(
            div()
                .text_xs()
                .font_weight(FontWeight::SEMIBOLD)
                .text_color(rgb(MUTED))
                .child(label),
        )
        .child(content)
}

fn sample_row() -> Div {
    div().flex().flex_wrap().gap_3()
}

fn paragraph_container() -> Div {
    div().block().w_full().min_w_0()
}

#[path = "text_system/fonts.rs"]
mod fonts;
#[path = "text_system/paragraphs.rs"]
mod paragraphs;
#[path = "text_system/spans.rs"]
mod spans;
use fonts::{font_faces, open_type_and_spacing, variable_font_widths};
use paragraphs::{multilingual_text, paragraph_layout};
use spans::{inline_layout, styled_runs};

fn text_sections() -> impl IntoElement {
    div()
        .w_full()
        .min_w_0()
        .max_w(px(960.))
        .flex()
        .flex_col()
        .gap_5()
        .p_8()
        .child(
            div()
                .flex()
                .flex_col()
                .gap_2()
                .child(
                    div()
                        .text_3xl()
                        .font_weight(FontWeight::BOLD)
                        .child("GPUI text system"),
                )
                .child(div().text_color(rgb(MUTED)).child(
                    "Font selection, rich text, multilingual text, wrapping, truncation, and inline layout.",
                ))
                .child(
                    div()
                        .text_sm()
                        .font_weight(FontWeight::SEMIBOLD)
                        .text_color(rgb(ACCENT))
                        .child("Sample fonts are embedded with this example."),
                ),
        )
        .child(section(
            "Font families and faces",
            "Compare family, weight, and style.",
            font_faces(),
        ))
        .child(section(
            "Variable font width",
            "Change Noto Sans width while keeping text and size fixed.",
            variable_font_widths(),
        ))
        .child(section(
            "Styled runs",
            "Independent paint and font styles within one text value.",
            styled_runs(),
        ))
        .child(section(
            "OpenType features and spacing",
            "Compare ligatures, case, and letter spacing.",
            open_type_and_spacing(),
        ))
        .child(section(
            "Scripts and fallback fonts",
            "Combining marks, RTL scripts, and emoji in one view.",
            multilingual_text(),
        ))
        .child(section(
            "Paragraph layout",
            "Wrap, space, clamp, and truncate within a container.",
            paragraph_layout(),
        ))
        .child(section(
            "Inline layout",
            "Styled spans and boxes share paragraph flow.",
            inline_layout(),
        ))
}

impl Render for TextSystemExample {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .id("text-system-content")
            .size_full()
            .flex()
            .justify_center()
            .overflow_y_scroll()
            .bg(rgb(BACKGROUND))
            .text_color(rgb(TEXT))
            .child(text_sections())
    }
}

fn main() {
    example_prelude::run_example("Text system", size(px(1000.), px(900.)), |_, cx| {
        cx.new(|_| TextSystemExample)
    });
}
