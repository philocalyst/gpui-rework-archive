//! Text wrapping, styled ranges, transformations, and mixed-script fallback.

#[path = "../shared/prelude.rs"]
mod example_prelude;

use gpui::{
    App, Context, FontWeight, HighlightStyle, Render, StyledText, TextTransform, UnderlineStyle,
    Window, div, hsla, prelude::*, px, rgb, size,
};

struct TextExample;

impl Render for TextExample {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div().size_full().bg(rgb(0xf1f3f6)).p_5().child(
            div()
                .flex()
                .flex_col()
                .gap_4()
                .max_w(px(520.))
                .child(
                    div()
                        .text_2xl()
                        .font_weight(FontWeight::BOLD)
                        .child("Text layout"),
                )
                .child(
                    "This paragraph wraps at the available width while keeping its words together.",
                )
                // Highlight ranges index UTF-8 bytes, so keep these ranges on ASCII text.
                .child(
                    div()
                        .text_lg()
                        .child(StyledText::new("color underline").with_highlights([
                            (
                                0..5,
                                HighlightStyle {
                                    color: Some(hsla(0.58, 0.8, 0.58, 1.)),
                                    ..Default::default()
                                },
                            ),
                            (
                                6..15,
                                HighlightStyle {
                                    underline: Some(UnderlineStyle {
                                        thickness: px(2.),
                                        color: Some(hsla(0.88, 0.75, 0.64, 1.)),
                                        wavy: true,
                                    }),
                                    ..Default::default()
                                },
                            ),
                        ])),
                )
                .child("English · Español · العربية · עברית · 👩🏽‍💻")
                .child(
                    div()
                        .flex()
                        .flex_wrap()
                        .gap_4()
                        .child(
                            div()
                                .flex_1()
                                .min_w(px(220.))
                                .text_transform(TextTransform::Uppercase)
                                .letter_spacing(px(2.))
                                .child("uppercase with tracking"),
                        )
                        .child(
                            div()
                                .flex_1()
                                .min_w(px(220.))
                                .text_transform(TextTransform::Capitalize)
                                .child("capitalize each word"),
                        ),
                ),
        )
    }
}

fn main() {
    example_prelude::run_example("Text", size(px(580.), px(500.)), |_, cx: &mut App| {
        cx.new(|_| TextExample)
    });
}
