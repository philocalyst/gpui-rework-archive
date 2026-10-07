//! Clipping, filter groups, gradients, paths, and paint order in one small scene.

#[path = "../../shared/prelude.rs"]
mod example_prelude;

use gpui::{
    App, Context, PathBuilder, Render, Window, canvas, div, hsla, linear_color_stop,
    linear_gradient, point, prelude::*, px, rgb, size,
};

struct EffectsExample;

impl Render for EffectsExample {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .size_full()
            .flex()
            .flex_col()
            .gap_3()
            .p_4()
            .bg(rgb(0x171923))
            .child(
                div()
                    .text_xl()
                    .text_color(rgb(0xffffff))
                    .child("Rendering effects"),
            )
            .child(
                div()
                    .flex()
                    .flex_wrap()
                    .gap_3()
                    // The outer rounded box clips both the offset child and its filter output.
                    .child(
                        div()
                            .size(px(112.))
                            .overflow_hidden()
                            .rounded_lg()
                            .bg(rgb(0x6a56c7))
                            .child(
                                div()
                                    .relative()
                                    .left(px(42.))
                                    .top(px(28.))
                                    .size(px(100.))
                                    .rounded_full()
                                    .bg(rgb(0xf06b88))
                                    .blur(px(3.)),
                            ),
                    )
                    // Opacity and blur apply to this layer as a group, including its child.
                    .child(
                        div()
                            .size(px(112.))
                            .flex()
                            .items_center()
                            .justify_center()
                            .rounded_lg()
                            .bg(rgb(0x29374d))
                            .child(
                                div()
                                    .size(px(78.))
                                    .rounded_lg()
                                    .bg(rgb(0x73d9c2))
                                    .opacity(0.65)
                                    .blur(px(3.))
                                    .child(div().size(px(18.)).rounded_full().bg(rgb(0xffffff))),
                            ),
                    )
                    .child(div().size(px(112.)).rounded_lg().bg(linear_gradient(
                        45.,
                        linear_color_stop(hsla(0.58, 0.8, 0.62, 1.), 0.),
                        linear_color_stop(hsla(0.88, 0.7, 0.62, 1.), 1.),
                    )))
                    // Later siblings paint above earlier ones where the shapes overlap.
                    .child(
                        div()
                            .relative()
                            .size(px(112.))
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
                    )
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
                    ),
            )
    }
}

fn main() {
    example_prelude::run_example(
        "Rendering effects",
        size(px(500.), px(220.)),
        |_, cx: &mut App| cx.new(|_| EffectsExample),
    );
}
