//! Render only the visible portion of a 10,000-row list, with stable row identities.

#[path = "../shared/prelude.rs"]
mod example_prelude;

use gpui::{App, Context, Render, Window, div, prelude::*, px, rgb, size, uniform_list};

struct UniformListExample;

impl Render for UniformListExample {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .size_full()
            .flex()
            .flex_col()
            .gap_2()
            .p_3()
            .bg(rgb(0xf8fafc))
            .child(
                div()
                    .text_lg()
                    .font_weight(gpui::FontWeight::BOLD)
                    .child("10,000 rows"),
            )
            // The callback receives only the visible range. IDs follow data identity so
            // recycled rows keep the right element state while scrolling.
            .child(
                uniform_list("virtual-rows", 10_000, |range, _, _| {
                    range
                        .map(|index| {
                            let color =
                                [0x93c5fd, 0x86efac, 0xfda4af, 0xfcd34d, 0xc4b5fd, 0x67e8f9]
                                    [index % 6];
                            div()
                                .id(index)
                                .h(px(36.))
                                .mb_1()
                                .px_2()
                                .flex()
                                .items_center()
                                .gap_3()
                                .bg(rgb(0xe2e8f0))
                                .child(div().size(px(18.)).rounded_full().bg(rgb(color)))
                                .child(format!("Row {index:05}"))
                        })
                        .collect()
                })
                .size_full(),
            )
    }
}

fn main() {
    example_prelude::run_example(
        "Uniform list",
        size(px(520.), px(580.)),
        |_, cx: &mut App| cx.new(|_| UniformListExample),
    );
}
