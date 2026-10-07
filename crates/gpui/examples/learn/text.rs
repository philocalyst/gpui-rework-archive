//! Wrapping, rich text, mixed scripts, and simple text transformations.

#[path = "../shared/prelude.rs"]
mod example_prelude;

use gpui::{
    App, Context, Entity, FontWeight, Render, TextTransform, Window, div, prelude::*, px, rgb, size,
};
use gpui_test::gallery::TextScenario;
use std::time::Duration;

struct TextLesson {
    shared_text: Entity<TextScenario>,
}

impl TextLesson {
    fn new(cx: &mut Context<Self>) -> Self {
        Self {
            shared_text: cx.new(|_| TextScenario),
        }
    }
}

impl Render for TextLesson {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div().size_full().bg(rgb(0xf1f3f6)).child(
            div()
                .flex()
                .flex_col()
                .gap_3()
                .max_w(px(540.))
                .p_4()
                .child(self.shared_text.clone())
                .child(
                    div()
                        .flex()
                        .flex_wrap()
                        .gap_3()
                        .child(
                            div()
                                .flex_1()
                                .min_w(px(220.))
                                .flex()
                                .flex_col()
                                .gap_2()
                                .p_4()
                                .rounded_lg()
                                .bg(rgb(0xffffff))
                                .child("Uppercase + tracking")
                                .child(
                                    div()
                                        .text_lg()
                                        .font_weight(FontWeight::SEMIBOLD)
                                        .text_transform(TextTransform::Uppercase)
                                        .letter_spacing(px(2.))
                                        .child("letter spacing works"),
                                ),
                        )
                        .child(
                            div()
                                .flex_1()
                                .min_w(px(220.))
                                .flex()
                                .flex_col()
                                .gap_2()
                                .p_4()
                                .rounded_lg()
                                .bg(rgb(0xffffff))
                                .child("Capitalize")
                                .child(
                                    div()
                                        .text_lg()
                                        .text_transform(TextTransform::Capitalize)
                                        .child("each word keeps its byte offsets"),
                                ),
                        ),
                ),
        )
    }
}

fn main() {
    let scenario = gpui_test::Scenario::new(
        "text",
        "Text",
        size(px(580.), px(500.)),
        |_, cx: &mut App| cx.new(TextLesson::new),
    )
    .expect("valid text scenario")
    .checkpoint("default", "Text transformations", Duration::ZERO)
    .expect("valid text checkpoint");
    example_prelude::run_example(scenario).expect("run text example");
}
