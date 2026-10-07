//! Flexible rows, wrapping, and a content region that fills the remaining space.

#[path = "../shared/prelude.rs"]
mod example_prelude;

use gpui::{App, Context, Render, Window, div, prelude::*, px, rgb, size};

struct LayoutExample;

impl Render for LayoutExample {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .size_full()
            .flex()
            .gap_3()
            .p_4()
            // Keep the sidebar fixed while the content column takes leftover width.
            .child(
                div()
                    .w(px(112.))
                    .flex_shrink_0()
                    .p_3()
                    .bg(rgb(0x344966))
                    .text_color(rgb(0xffffff))
                    .child("Fixed sidebar"),
            )
            // min_w(0) lets this flex child shrink below its text's intrinsic width.
            .child(
                div()
                    .flex_1()
                    .min_w(px(0.))
                    .flex()
                    .flex_col()
                    .gap_3()
                    .child(
                        div()
                            .flex()
                            .flex_wrap()
                            .gap_2()
                            .child(tile("Header", rgb(0x94bde4)))
                            .child(tile("Toolbar can wrap", rgb(0xb9a9dc)))
                            .child(tile("Another item", rgb(0xc5d7c6))),
                    )
                    .child(
                        div()
                            .flex_1()
                            .min_h(px(80.))
                            .p_3()
                            .bg(rgb(0xe0e7ef))
                            .child("flex_1 fills the remaining height"),
                    ),
            )
    }
}

fn tile(label: &'static str, color: gpui::Rgba) -> impl IntoElement {
    div()
        .flex_1()
        .min_w(px(110.))
        .p_3()
        .bg(color)
        .text_color(rgb(0x172033))
        .child(label)
}

fn main() {
    example_prelude::run_example("Layout", size(px(620.), px(360.)), |_, cx: &mut App| {
        cx.new(|_| LayoutExample)
    });
}
