#[path = "../shared/prelude.rs"]
mod example_prelude;

use gpui::{
    App, AppContext as _, Context, FontWeight, Render, TextTransform, Window, div, prelude::*, px,
    rgb,
};

struct TextTransformPreview;

impl Render for TextTransformPreview {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .flex()
            .flex_col()
            .gap_4()
            .bg(rgb(0x10141c))
            .size(px(720.))
            .p_8()
            .text_color(rgb(0xe5e7eb))
            .child(
                div()
                    .text_xl()
                    .font_weight(FontWeight::BOLD)
                    .child("Text spacing and transforms"),
            )
            .child(
                div()
                    .flex()
                    .flex_col()
                    .gap_2()
                    .p_4()
                    .bg(rgb(0x1f2937))
                    .rounded_md()
                    .child(div().text_sm().text_color(rgb(0x9ca3af)).child("Uppercase"))
                    .child(
                        div()
                            .text_2xl()
                            .font_weight(FontWeight::SEMIBOLD)
                            .letter_spacing(px(3.))
                            .text_transform(TextTransform::Uppercase)
                            .text_color(rgb(0x93c5fd))
                            .child("letter spacing works"),
                    ),
            )
            .child(
                div()
                    .flex()
                    .flex_col()
                    .gap_2()
                    .p_4()
                    .bg(rgb(0x1f2937))
                    .rounded_md()
                    .child(
                        div()
                            .text_sm()
                            .text_color(rgb(0x9ca3af))
                            .child("Capitalize"),
                    )
                    .child(
                        div()
                            .text_2xl()
                            .letter_spacing(px(1.5))
                            .text_transform(TextTransform::Capitalize)
                            .text_color(rgb(0xfcd34d))
                            .child("each word keeps its byte offsets"),
                    ),
            )
    }
}

fn main() {
    gpui_platform::application().run(|cx: &mut App| {
        let options = example_prelude::centered_window(720., 480., cx);
        if let Err(error) = cx.open_window(options, |_, cx| cx.new(|_| TextTransformPreview)) {
            eprintln!("failed to open preview window: {error}");
            return;
        }
        example_prelude::init_example(cx, "Text Transform Preview");
    });
}
