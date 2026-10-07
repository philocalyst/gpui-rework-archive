#![cfg_attr(target_family = "wasm", no_main)]

#[path = "../shared/prelude.rs"]
mod example_prelude;

use gpui::{
    App, AppContext, Context, Window, div, linear_color_stop, linear_gradient, pattern_slash,
    prelude::*, px, rgb,
};
use palette::WithAlpha;
use std::time::Duration;

struct PatternExample;

fn pattern_bar(
    color: gpui::Hsla,
    width: f32,
    height: f32,
    slash_width: f32,
    slash_height: f32,
) -> impl IntoElement {
    div()
        .w(px(width))
        .h(px(height))
        .bg(pattern_slash(color, slash_width, slash_height))
}

impl Render for PatternExample {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .flex()
            .flex_col()
            .gap_3()
            .bg(rgb(0xffffff))
            .size(px(600.0))
            .justify_center()
            .items_center()
            .shadow_lg()
            .text_xl()
            .text_color(rgb(0x000000))
            .child("Pattern Example")
            .child(
                div()
                    .flex()
                    .flex_col()
                    .border_1()
                    .border_color(gpui::blue())
                    .children(
                        (0..3).map(|_| pattern_bar(gpui::red(), 54., 18., 18. / 4., 18. / 4.)),
                    )
                    .child(pattern_bar(gpui::red(), 54., 18., 18. / 4., 18. / 2.)),
            )
            .child(
                div()
                    .flex()
                    .flex_col()
                    .border_1()
                    .border_color(gpui::blue())
                    .bg(gpui::green().with_alpha(0.16))
                    .child("Elements the same height should align")
                    .children(
                        [gpui::red(), gpui::green(), gpui::blue()]
                            .into_iter()
                            .map(|color| pattern_bar(color, 256., 56., 56. / 6., 56. / 6.)),
                    )
                    .child(pattern_bar(gpui::yellow(), 256., 26., 56. / 6., 56. / 6.)),
            )
            .child(
                div()
                    .border_1()
                    .border_color(gpui::blue())
                    .w(px(240.0))
                    .h(px(40.0))
                    .bg(gpui::red()),
            )
            .child(
                div()
                    .border_1()
                    .border_color(gpui::blue())
                    .w(px(240.0))
                    .h(px(40.0))
                    .bg(linear_gradient(
                        45.,
                        linear_color_stop(gpui::red(), 0.),
                        linear_color_stop(gpui::blue(), 1.),
                    )),
            )
    }
}

fn pattern_scenario() -> anyhow::Result<gpui_test::Scenario<PatternExample>> {
    Ok(gpui_test::Scenario::new(
        "pattern-fills",
        "Pattern fills",
        gpui::size(gpui::px(600.), gpui::px(600.)),
        |_, cx: &mut App| cx.new(|_| PatternExample),
    )?
    .checkpoint("default", "Pattern and gradient fills", Duration::ZERO)?)
}

#[cfg(not(target_family = "wasm"))]
fn main() {
    example_prelude::run_example(pattern_scenario().expect("valid pattern scenario"))
        .expect("run pattern example");
}

#[cfg(target_family = "wasm")]
#[wasm_bindgen::prelude::wasm_bindgen(start)]
pub fn start() {
    gpui_platform::web_init();
    example_prelude::run_example(pattern_scenario().expect("valid pattern scenario"))
        .expect("run pattern example");
}
