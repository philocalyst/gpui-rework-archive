//! Virtualized rows with dense overlap and stable repeated content.

use gpui::{Render, Window, div, prelude::*, px, rgb, uniform_list};

#[derive(Default)]
pub struct StressScenario;

impl Render for StressScenario {
    fn render(&mut self, _window: &mut Window, _cx: &mut gpui::Context<Self>) -> impl IntoElement {
        div()
            .id("stress-scenario")
            .size_full()
            .flex()
            .flex_col()
            .p_3()
            .gap_2()
            .bg(rgb(0xf8fafc))
            .child(
                div()
                    .text_lg()
                    .font_weight(gpui::FontWeight::BOLD)
                    .child("Virtual rows and overlap"),
            )
            .child(
                uniform_list("stress-rows", 2_000, |range, _, _| {
                    range
                        .map(|index| {
                            let hue = (index % 6) as u32;
                            let color =
                                [0x93c5fd, 0x86efac, 0xfda4af, 0xfcd34d, 0xc4b5fd, 0x67e8f9]
                                    [hue as usize];
                            div()
                                .id(index)
                                .relative()
                                .h(px(48.))
                                .mb_1()
                                .px_2()
                                .flex()
                                .items_center()
                                .bg(rgb(0xe2e8f0))
                                .child(div().size(px(28.)).rounded_md().bg(rgb(color)))
                                .child(
                                    div()
                                        .absolute()
                                        .left(px(20.))
                                        .top(px(12.))
                                        .size(px(22.))
                                        .rounded_full()
                                        .bg(rgb(0xf97316)),
                                )
                                .child(
                                    div()
                                        .ml_4()
                                        .child(format!("Cell {index:04} · stable content")),
                                )
                        })
                        .collect()
                })
                .size_full(),
            )
    }
}
