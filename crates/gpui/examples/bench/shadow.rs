#![cfg_attr(target_family = "wasm", no_main)]

#[path = "../shared/prelude.rs"]
mod example_prelude;
#[path = "../example_support/fonts.rs"]
mod example_support;

use gpui::{
    App, AppContext as _, BoxShadow, Context, Div, SharedString, Window, div, hsla,
    linear_color_stop, linear_gradient, prelude::*, px, relative, rgb,
};
use gpui_platform::application;

struct Shadow {}

impl Shadow {
    fn surface() -> Div {
        div()
            .size_16()
            .bg(rgb(0xffffff))
            .border_1()
            .border_color(hsla(0.0, 0.0, 0.0, 0.1))
    }

    fn square() -> Div {
        Self::surface()
    }

    fn circle() -> Div {
        Self::surface().rounded_full()
    }

    fn rounded(radius: f32) -> Div {
        Self::surface().rounded(px(radius))
    }
}

fn example(label: impl Into<SharedString>, example: impl IntoElement) -> impl IntoElement {
    let label = label.into();

    div()
        .flex()
        .flex_col()
        .justify_center()
        .items_center()
        .w(relative(1. / 6.))
        .border_r_1()
        .border_color(hsla(0.0, 0.0, 0.0, 1.0))
        .child(
            div()
                .flex()
                .items_center()
                .justify_center()
                .flex_1()
                .py_12()
                .child(example),
        )
        .child(
            div()
                .w_full()
                .border_t_1()
                .border_color(hsla(0.0, 0.0, 0.0, 1.0))
                .p_1()
                .flex()
                .items_center()
                .child(label),
        )
}

impl Render for Shadow {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .id("shadow-example")
            .overflow_y_scroll()
            .bg(rgb(0xffffff))
            .size_full()
            .text_xs()
            .child(div().flex().flex_col().w_full().children(vec![
                    div()
                        .border_b_1()
                        .border_color(hsla(0.0, 0.0, 0.0, 1.0))
                        .flex()
                        .flex_row()
                        .children(vec![
                            example(
                                "Square",
                                Shadow::square().shadow(vec![
                                    BoxShadow::new(px(0.), px(8.), hsla(0.0, 0.5, 0.5, 0.3))
                                        .blur_radius(px(8.)),
                                ]),
                            ),
                            example(
                                "Rounded 4",
                                Shadow::rounded(4.).shadow(vec![
                                    BoxShadow::new(px(0.), px(8.), hsla(0.0, 0.5, 0.5, 0.3))
                                        .blur_radius(px(8.)),
                                ]),
                            ),
                            example(
                                "Rounded 8",
                                Shadow::rounded(8.).shadow(vec![
                                    BoxShadow::new(px(0.), px(8.), hsla(0.0, 0.5, 0.5, 0.3))
                                        .blur_radius(px(8.)),
                                ]),
                            ),
                            example(
                                "Rounded 16",
                                Shadow::rounded(12.).shadow(vec![
                                    BoxShadow::new(px(0.), px(8.), hsla(0.0, 0.5, 0.5, 0.3))
                                        .blur_radius(px(8.)),
                                ]),
                            ),
                            example(
                                "Circle",
                                Shadow::circle().shadow(vec![
                                    BoxShadow::new(px(0.), px(8.), hsla(0.0, 0.5, 0.5, 0.3))
                                        .blur_radius(px(8.)),
                                ]),
                            ),
                        ]),
                    div()
                        .border_b_1()
                        .border_color(hsla(0.0, 0.0, 0.0, 1.0))
                        .flex()
                        .w_full()
                        .children(vec![
                            example("None", Shadow::circle()),
                            example("2X Small", Shadow::circle().shadow_2xs()),
                            example("Extra Small", Shadow::circle().shadow_xs()),
                            example("Small", Shadow::circle().shadow_sm()),
                            example("Medium", Shadow::circle().shadow_md()),
                            example("Large", Shadow::circle().shadow_lg()),
                            example("Extra Large", Shadow::circle().shadow_xl()),
                            example("2X Large", Shadow::circle().shadow_2xl()),
                        ]),
                    // Horizontal list of increasing blur radii
                    div()
                        .border_b_1()
                        .border_color(hsla(0.0, 0.0, 0.0, 1.0))
                        .flex()
                        .children(vec![
                            example(
                                "Blur 0",
                                Shadow::circle().shadow(vec![BoxShadow::new(
                                    px(0.),
                                    px(8.),
                                    hsla(0.0, 0.0, 0.0, 0.3),
                                )]),
                            ),
                            example(
                                "Blur 2",
                                Shadow::circle().shadow(vec![
                                    BoxShadow::new(px(0.), px(8.), hsla(0.0, 0.0, 0.0, 0.3))
                                        .blur_radius(px(2.)),
                                ]),
                            ),
                            example(
                                "Blur 4",
                                Shadow::circle().shadow(vec![
                                    BoxShadow::new(px(0.), px(8.), hsla(0.0, 0.0, 0.0, 0.3))
                                        .blur_radius(px(4.)),
                                ]),
                            ),
                            example(
                                "Blur 8",
                                Shadow::circle().shadow(vec![
                                    BoxShadow::new(px(0.), px(8.), hsla(0.0, 0.0, 0.0, 0.3))
                                        .blur_radius(px(8.)),
                                ]),
                            ),
                            example(
                                "Blur 16",
                                Shadow::circle().shadow(vec![
                                    BoxShadow::new(px(0.), px(8.), hsla(0.0, 0.0, 0.0, 0.3))
                                        .blur_radius(px(16.)),
                                ]),
                            ),
                        ]),
                    // Horizontal list of increasing spread radii
                    div()
                        .border_b_1()
                        .border_color(hsla(0.0, 0.0, 0.0, 1.0))
                        .flex()
                        .children(vec![
                            example(
                                "Spread 0",
                                Shadow::circle().shadow(vec![
                                    BoxShadow::new(px(0.), px(8.), hsla(0.0, 0.0, 0.0, 0.3))
                                        .blur_radius(px(8.)),
                                ]),
                            ),
                            example(
                                "Spread 2",
                                Shadow::circle().shadow(vec![
                                    BoxShadow::new(px(0.), px(8.), hsla(0.0, 0.0, 0.0, 0.3))
                                        .blur_radius(px(8.))
                                        .spread_radius(px(2.)),
                                ]),
                            ),
                            example(
                                "Spread 4",
                                Shadow::circle().shadow(vec![
                                    BoxShadow::new(px(0.), px(8.), hsla(0.0, 0.0, 0.0, 0.3))
                                        .blur_radius(px(8.))
                                        .spread_radius(px(4.)),
                                ]),
                            ),
                            example(
                                "Spread 8",
                                Shadow::circle().shadow(vec![
                                    BoxShadow::new(px(0.), px(8.), hsla(0.0, 0.0, 0.0, 0.3))
                                        .blur_radius(px(8.))
                                        .spread_radius(px(8.)),
                                ]),
                            ),
                            example(
                                "Spread 16",
                                Shadow::circle().shadow(vec![
                                    BoxShadow::new(px(0.), px(8.), hsla(0.0, 0.0, 0.0, 0.3))
                                        .blur_radius(px(8.))
                                        .spread_radius(px(16.)),
                                ]),
                            ),
                        ]),
                    // Square spread examples
                    div()
                        .border_b_1()
                        .border_color(hsla(0.0, 0.0, 0.0, 1.0))
                        .flex()
                        .children(vec![
                            example(
                                "Square Spread 0",
                                Shadow::square().shadow(vec![
                                    BoxShadow::new(px(0.), px(8.), hsla(0.0, 0.0, 0.0, 0.3))
                                        .blur_radius(px(8.)),
                                ]),
                            ),
                            example(
                                "Square Spread 8",
                                Shadow::square().shadow(vec![
                                    BoxShadow::new(px(0.), px(8.), hsla(0.0, 0.0, 0.0, 0.3))
                                        .blur_radius(px(8.))
                                        .spread_radius(px(8.)),
                                ]),
                            ),
                            example(
                                "Square Spread 16",
                                Shadow::square().shadow(vec![
                                    BoxShadow::new(px(0.), px(8.), hsla(0.0, 0.0, 0.0, 0.3))
                                        .blur_radius(px(8.))
                                        .spread_radius(px(16.)),
                                ]),
                            ),
                        ]),
                    // Rounded large spread examples
                    div()
                        .border_b_1()
                        .border_color(hsla(0.0, 0.0, 0.0, 1.0))
                        .flex()
                        .children(vec![
                            example(
                                "Rounded Large Spread 0",
                                Shadow::rounded(12.).shadow(vec![
                                    BoxShadow::new(px(0.), px(8.), hsla(0.0, 0.0, 0.0, 0.3))
                                        .blur_radius(px(8.)),
                                ]),
                            ),
                            example(
                                "Rounded Large Spread 8",
                                Shadow::rounded(12.).shadow(vec![
                                    BoxShadow::new(px(0.), px(8.), hsla(0.0, 0.0, 0.0, 0.3))
                                        .blur_radius(px(8.))
                                        .spread_radius(px(8.)),
                                ]),
                            ),
                            example(
                                "Rounded Large Spread 16",
                                Shadow::rounded(12.).shadow(vec![
                                    BoxShadow::new(px(0.), px(8.), hsla(0.0, 0.0, 0.0, 0.3))
                                        .blur_radius(px(8.))
                                        .spread_radius(px(16.)),
                                ]),
                            ),
                        ]),
                    // Directional shadows
                    div()
                        .border_b_1()
                        .border_color(hsla(0.0, 0.0, 0.0, 1.0))
                        .flex()
                        .children(vec![
                            example(
                                "Left",
                                Shadow::circle().shadow(vec![
                                    BoxShadow::new(px(-8.), px(0.), hsla(0.0, 0.5, 0.5, 0.3))
                                        .blur_radius(px(8.)),
                                ]),
                            ),
                            example(
                                "Right",
                                Shadow::circle().shadow(vec![
                                    BoxShadow::new(px(8.), px(0.), hsla(0.0, 0.5, 0.5, 0.3))
                                        .blur_radius(px(8.)),
                                ]),
                            ),
                            example(
                                "Top",
                                Shadow::circle().shadow(vec![
                                    BoxShadow::new(px(0.), px(-8.), hsla(0.0, 0.5, 0.5, 0.3))
                                        .blur_radius(px(8.)),
                                ]),
                            ),
                            example(
                                "Bottom",
                                Shadow::circle().shadow(vec![
                                    BoxShadow::new(px(0.), px(8.), hsla(0.0, 0.5, 0.5, 0.3))
                                        .blur_radius(px(8.)),
                                ]),
                            ),
                        ]),
                    // Square directional shadows
                    div()
                        .border_b_1()
                        .border_color(hsla(0.0, 0.0, 0.0, 1.0))
                        .flex()
                        .children(vec![
                            example(
                                "Square Left",
                                Shadow::square().shadow(vec![
                                    BoxShadow::new(px(-8.), px(0.), hsla(0.0, 0.5, 0.5, 0.3))
                                        .blur_radius(px(8.)),
                                ]),
                            ),
                            example(
                                "Square Right",
                                Shadow::square().shadow(vec![
                                    BoxShadow::new(px(8.), px(0.), hsla(0.0, 0.5, 0.5, 0.3))
                                        .blur_radius(px(8.)),
                                ]),
                            ),
                            example(
                                "Square Top",
                                Shadow::square().shadow(vec![
                                    BoxShadow::new(px(0.), px(-8.), hsla(0.0, 0.5, 0.5, 0.3))
                                        .blur_radius(px(8.)),
                                ]),
                            ),
                            example(
                                "Square Bottom",
                                Shadow::square().shadow(vec![
                                    BoxShadow::new(px(0.), px(8.), hsla(0.0, 0.5, 0.5, 0.3))
                                        .blur_radius(px(8.)),
                                ]),
                            ),
                        ]),
                    // Rounded large directional shadows
                    div()
                        .border_b_1()
                        .border_color(hsla(0.0, 0.0, 0.0, 1.0))
                        .flex()
                        .children(vec![
                            example(
                                "Rounded Large Left",
                                Shadow::rounded(12.).shadow(vec![
                                    BoxShadow::new(px(-8.), px(0.), hsla(0.0, 0.5, 0.5, 0.3))
                                        .blur_radius(px(8.)),
                                ]),
                            ),
                            example(
                                "Rounded Large Right",
                                Shadow::rounded(12.).shadow(vec![
                                    BoxShadow::new(px(8.), px(0.), hsla(0.0, 0.5, 0.5, 0.3))
                                        .blur_radius(px(8.)),
                                ]),
                            ),
                            example(
                                "Rounded Large Top",
                                Shadow::rounded(12.).shadow(vec![
                                    BoxShadow::new(px(0.), px(-8.), hsla(0.0, 0.5, 0.5, 0.3))
                                        .blur_radius(px(8.)),
                                ]),
                            ),
                            example(
                                "Rounded Large Bottom",
                                Shadow::rounded(12.).shadow(vec![
                                    BoxShadow::new(px(0.), px(8.), hsla(0.0, 0.5, 0.5, 0.3))
                                        .blur_radius(px(8.)),
                                ]),
                            ),
                        ]),
                    // Multiple shadows for different shapes
                    div()
                        .border_b_1()
                        .border_color(hsla(0.0, 0.0, 0.0, 1.0))
                        .flex()
                        .children(vec![
                            example(
                                "Circle Multiple",
                                Shadow::circle().shadow(vec![
                                    BoxShadow::new(
                                        px(0.),
                                        px(-12.),
                                        hsla(0.0 / 360., 1.0, 0.5, 0.3),
                                    )
                                    .blur_radius(px(8.))
                                    .spread_radius(px(2.)),
                                    BoxShadow::new(
                                        px(12.),
                                        px(0.),
                                        hsla(60.0 / 360., 1.0, 0.5, 0.3),
                                    )
                                    .blur_radius(px(8.))
                                    .spread_radius(px(2.)),
                                    BoxShadow::new(
                                        px(0.),
                                        px(12.),
                                        hsla(120.0 / 360., 1.0, 0.5, 0.3),
                                    )
                                    .blur_radius(px(8.))
                                    .spread_radius(px(2.)),
                                    BoxShadow::new(
                                        px(-12.),
                                        px(0.),
                                        hsla(240.0 / 360., 1.0, 0.5, 0.3),
                                    )
                                    .blur_radius(px(8.))
                                    .spread_radius(px(2.)),
                                ]),
                            ),
                            example(
                                "Square Multiple",
                                Shadow::square().shadow(vec![
                                    BoxShadow::new(
                                        px(0.),
                                        px(-12.),
                                        hsla(0.0 / 360., 1.0, 0.5, 0.3),
                                    )
                                    .blur_radius(px(8.))
                                    .spread_radius(px(2.)),
                                    BoxShadow::new(
                                        px(12.),
                                        px(0.),
                                        hsla(60.0 / 360., 1.0, 0.5, 0.3),
                                    )
                                    .blur_radius(px(8.))
                                    .spread_radius(px(2.)),
                                    BoxShadow::new(
                                        px(0.),
                                        px(12.),
                                        hsla(120.0 / 360., 1.0, 0.5, 0.3),
                                    )
                                    .blur_radius(px(8.))
                                    .spread_radius(px(2.)),
                                    BoxShadow::new(
                                        px(-12.),
                                        px(0.),
                                        hsla(240.0 / 360., 1.0, 0.5, 0.3),
                                    )
                                    .blur_radius(px(8.))
                                    .spread_radius(px(2.)),
                                ]),
                            ),
                            example(
                                "Rounded Large Multiple",
                                Shadow::rounded(12.).shadow(vec![
                                    BoxShadow::new(
                                        px(0.),
                                        px(-12.),
                                        hsla(0.0 / 360., 1.0, 0.5, 0.3),
                                    )
                                    .blur_radius(px(8.))
                                    .spread_radius(px(2.)),
                                    BoxShadow::new(
                                        px(12.),
                                        px(0.),
                                        hsla(60.0 / 360., 1.0, 0.5, 0.3),
                                    )
                                    .blur_radius(px(8.))
                                    .spread_radius(px(2.)),
                                    BoxShadow::new(
                                        px(0.),
                                        px(12.),
                                        hsla(120.0 / 360., 1.0, 0.5, 0.3),
                                    )
                                    .blur_radius(px(8.))
                                    .spread_radius(px(2.)),
                                    BoxShadow::new(
                                        px(-12.),
                                        px(0.),
                                        hsla(240.0 / 360., 1.0, 0.5, 0.3),
                                    )
                                    .blur_radius(px(8.))
                                    .spread_radius(px(2.)),
                                ]),
                            ),
                        ]),
                    // Inset shadows (CSS `box-shadow: inset ...`).
                    div()
                        .border_b_1()
                        .border_color(hsla(0.0, 0.0, 0.0, 1.0))
                        .flex()
                        .w_full()
                        .children(vec![
                            example(
                                "Inset basic",
                                Shadow::circle().shadow(vec![
                                    BoxShadow::new(px(0.), px(0.), hsla(0.0, 0.0, 0.0, 0.5))
                                        .blur_radius(px(12.))
                                        .inset(),
                                ]),
                            ),
                            example(
                                "Inset offset",
                                Shadow::circle().shadow(vec![
                                    BoxShadow::new(px(6.), px(6.), hsla(0.0, 0.0, 0.0, 0.5))
                                        .blur_radius(px(8.))
                                        .inset(),
                                ]),
                            ),
                            example(
                                "Inset spread",
                                Shadow::circle().shadow(vec![
                                    BoxShadow::new(px(0.), px(0.), hsla(0.0, 0.0, 0.0, 0.5))
                                        .blur_radius(px(4.))
                                        .spread_radius(px(8.))
                                        .inset(),
                                ]),
                            ),
                            example(
                                "Inset rounded",
                                Shadow::rounded(12.).shadow(vec![
                                    BoxShadow::new(px(0.), px(4.), hsla(0.0, 0.0, 0.0, 0.5))
                                        .blur_radius(px(10.))
                                        .spread_radius(px(2.))
                                        .inset(),
                                ]),
                            ),
                            example(
                                "Inset sharp",
                                Shadow::square().shadow(vec![
                                    BoxShadow::new(px(0.), px(0.), hsla(0.0, 0.0, 0.0, 0.6))
                                        .spread_radius(px(6.))
                                        .inset(),
                                ]),
                            ),
                        ]),
                    // Gradient drop and inset shadows on the same element.
                    div()
                        .border_b_1()
                        .border_color(hsla(0.0, 0.0, 0.0, 1.0))
                        .flex()
                        .w_full()
                        .children(vec![example(
                            "Gradient Drop + Inset",
                            Shadow::rounded(8.).shadow(vec![
                                BoxShadow::new(
                                    px(0.),
                                    px(8.),
                                    linear_gradient(
                                        90.,
                                        linear_color_stop(hsla(0., 0.85, 0.55, 0.4), 0.),
                                        linear_color_stop(
                                            hsla(2. / 3., 0.85, 0.55, 0.4),
                                            1.,
                                        ),
                                    ),
                                )
                                .blur_radius(px(12.)),
                                BoxShadow::new(
                                    px(0.),
                                    px(2.),
                                    linear_gradient(
                                        90.,
                                        linear_color_stop(hsla(1. / 3., 0.8, 0.4, 0.6), 0.),
                                        linear_color_stop(hsla(1. / 6., 0.9, 0.5, 0.6), 1.),
                                    ),
                                )
                                .blur_radius(px(4.))
                                .inset(),
                            ]),
                        )]),
                ]))
    }
}

fn run_example() {
    application().run(|cx: &mut App| {
        if !example_support::load_fonts(cx) {
            return;
        }
        let options = example_prelude::centered_window(1000., 800., cx);
        cx.open_window(options, |_, cx| cx.new(|_| Shadow {}))
            .expect("open shadow gallery");
        example_prelude::init_example(cx, "Shadow Gallery");
    });
}

#[cfg(not(target_family = "wasm"))]
fn main() {
    env_logger::init();
    run_example();
}

#[cfg(target_family = "wasm")]
#[wasm_bindgen::prelude::wasm_bindgen(start)]
pub fn start() {
    gpui_platform::web_init();
    run_example();
}
