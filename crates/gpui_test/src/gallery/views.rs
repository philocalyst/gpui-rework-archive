//! Small deterministic views shared by the runnable examples and regression tests.
//!
//! Keep these focused on stable layout and paint inputs. Input-driven state is public so a
//! harness can set a checkpoint directly instead of depending on wall-clock animation timing.

use std::time::Duration;

use gpui::{
    Animation, AnimationExt as _, Context, HighlightStyle, PathBuilder, Render, StyledText,
    UnderlineStyle, Window, canvas, div, ease_in_out, hsla, linear_color_stop, linear_gradient,
    point, prelude::*, px, rgb,
};

#[derive(Default)]
pub struct LayoutScenario;

impl Render for LayoutScenario {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .id("layout-scenario")
            .flex()
            .gap_3()
            .size_full()
            .min_w(px(0.))
            .p_4()
            .bg(rgb(0xf3f5f8))
            .child(
                div()
                    .w(px(96.))
                    .flex_shrink_0()
                    .p_3()
                    .bg(rgb(0x344966))
                    .text_color(rgb(0xffffff))
                    .child("Sidebar"),
            )
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
                            .child(layout_tile("Header", rgb(0x94bde4)))
                            .child(layout_tile("Toolbar", rgb(0xb9a9dc))),
                    )
                    .child(
                        div()
                            .flex_1()
                            .min_h(px(80.))
                            .p_3()
                            .bg(rgb(0xe0e7ef))
                            .child("Content grows to fill the remaining space"),
                    ),
            )
    }
}

fn layout_tile(label: &'static str, color: gpui::Rgba) -> impl IntoElement {
    div()
        .flex_1()
        .min_w(px(80.))
        .p_3()
        .bg(color)
        .text_color(rgb(0x172033))
        .child(label)
}

#[derive(Default)]
pub struct TextScenario;

impl Render for TextScenario {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .id("text-scenario")
            .flex()
            .flex_col()
            .gap_4()
            .max_w(px(460.))
            .p_6()
            .bg(rgb(0xf5f2ed))
            .text_color(rgb(0x24211e))
            .child(
                div()
                    .text_2xl()
                    .font_weight(gpui::FontWeight::BOLD)
                    .child("Typography"),
            )
            .child(
                div().text_base().child(
                    "A sentence wraps at the available width while keeping its words together.",
                ),
            )
            .child(div().text_lg().child(
                StyledText::new("color underline mixed scripts").with_highlights([
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
                ]),
            ))
            .child(
                div()
                    .text_lg()
                    .child("English · Español · العربية · עברית · 👩🏽‍💻"),
            )
    }
}

#[derive(Default)]
pub struct EffectsScenario;

impl Render for EffectsScenario {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .id("effects-scenario")
            .flex()
            .flex_col()
            .gap_3()
            .p_4()
            .bg(rgb(0x171923))
            .child(
                div()
                    .text_xl()
                    .text_color(rgb(0xffffff))
                    .child("Filters and clipping"),
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
                                    // Nested filters use a separate group for each filtered subtree.
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
                            // Children paint in declaration order: the later circle overlaps the square.
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
                            move |_bounds, _window, _cx| {},
                            move |bounds, _, window, _cx| {
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
                            .child("Backdrop blur; the earlier rows show what it samples."),
                    ),
            )
    }
}

#[derive(Default)]
pub struct AnimationScenario;

impl Render for AnimationScenario {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .id("animation-scenario")
            .flex()
            .flex_col()
            .gap_3()
            .p_6()
            .bg(rgb(0x111318))
            .child(
                div()
                    .text_lg()
                    .text_color(rgb(0xffffff))
                    .child("Motion checkpoint"),
            )
            .child(
                div()
                    .relative()
                    .h(px(64.))
                    .w(px(220.))
                    .rounded_lg()
                    .bg(rgb(0x282d37))
                    .child(
                        div()
                            .absolute()
                            .top(px(12.))
                            .size(px(40.))
                            .rounded_full()
                            .bg(rgb(0x61c6ed))
                            .with_animation(
                                "moving-checkpoint",
                                Animation::new(Duration::from_millis(1200))
                                    .repeat()
                                    .with_easing(ease_in_out),
                                |marker, progress| marker.left(px(12. + 180. * progress)),
                            ),
                    ),
            )
            .child(
                div()
                    .text_sm()
                    .text_color(rgb(0xb4bac5))
                    .child("Repeats over 1.2 seconds with ease-in-out"),
            )
    }
}
