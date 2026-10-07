use gpui::{
    PathBuilder, Render, Window, canvas, div, hsla, linear_color_stop, linear_gradient, point,
    prelude::*, px, rgb,
};

pub struct EffectsExample;

impl Render for EffectsExample {
    fn render(&mut self, _window: &mut Window, _cx: &mut gpui::Context<Self>) -> impl IntoElement {
        div()
            .flex()
            .flex_col()
            .gap_3()
            .size_full()
            .p_4()
            .bg(rgb(0x171923))
            .child(
                div()
                    .text_xl()
                    .text_color(rgb(0xffffff))
                    .child("Filters, clipping, and paint order"),
            )
            .child(
                div()
                    .flex()
                    .gap_2()
                    .child(
                        div()
                            .size(px(100.))
                            .overflow_hidden()
                            .rounded_lg()
                            .bg(rgb(0x6a56c7))
                            .child(
                                div()
                                    .relative()
                                    .left(px(42.))
                                    .top(px(30.))
                                    .size(px(110.))
                                    .rounded_full()
                                    .bg(rgb(0xf06b88))
                                    .blur(px(2.))
                                    .child(
                                        div()
                                            .size(px(24.))
                                            .rounded_full()
                                            .bg(rgb(0xffffff))
                                            .blur(px(3.)),
                                    ),
                            ),
                    )
                    .child(
                        div()
                            .size(px(100.))
                            .flex()
                            .items_center()
                            .justify_center()
                            .rounded_lg()
                            .bg(rgb(0x29374d))
                            .child(
                                div()
                                    .size(px(72.))
                                    .rounded_lg()
                                    .bg(rgb(0x73d9c2))
                                    .opacity(0.65)
                                    .blur(px(3.)),
                            ),
                    ),
            )
            .child(
                div()
                    .flex()
                    .gap_2()
                    .child(div().size(px(100.)).rounded_lg().bg(linear_gradient(
                        45.,
                        linear_color_stop(hsla(0.58, 0.8, 0.62, 1.), 0.),
                        linear_color_stop(hsla(0.88, 0.7, 0.62, 1.), 1.),
                    )))
                    .child(
                        div()
                            .relative()
                            .size(px(100.))
                            .rounded_lg()
                            .bg(rgb(0x29374d))
                            .child(
                                div()
                                    .absolute()
                                    .left(px(12.))
                                    .top(px(12.))
                                    .size(px(58.))
                                    .rounded_lg()
                                    .bg(rgb(0xf3bd58)),
                            )
                            .child(
                                div()
                                    .absolute()
                                    .left(px(36.))
                                    .top(px(36.))
                                    .size(px(48.))
                                    .rounded_full()
                                    .bg(rgb(0x61c6ed)),
                            ),
                    ),
            )
            .child(
                div()
                    .flex()
                    .items_center()
                    .gap_2()
                    .child(
                        canvas(
                            |_bounds, _window, _cx| {},
                            |bounds, _, window, _cx| {
                                let origin = bounds.origin;
                                let mut path = PathBuilder::fill();
                                path.move_to(point(origin.x + px(10.), origin.y + px(74.)));
                                path.line_to(point(origin.x + px(45.), origin.y + px(10.)));
                                path.line_to(point(origin.x + px(80.), origin.y + px(74.)));
                                path.close();
                                if let Ok(path) = path.build() {
                                    window.paint_path(path, rgb(0xf06b88));
                                }
                            },
                        )
                        .size(px(90.)),
                    )
                    .child(
                        div()
                            .w(px(200.))
                            .p_3()
                            .rounded_lg()
                            .bg(gpui::rgba(0xffffff44))
                            .backdrop_blur(px(8.))
                            .text_color(rgb(0xffffff))
                            .child("Backdrop blur samples the earlier rows."),
                    ),
            )
    }
}
