//! A compact visual matrix for drop, inset, multi-layer, and gradient-backed shadows.

#[path = "../shared/prelude.rs"]
mod example_prelude;

use gpui::{
    App, Background, BoxShadow, Context, Render, Window, div, linear_color_stop, linear_gradient,
    prelude::*, px, rgb, size,
};

#[derive(Clone, Copy)]
enum Shape {
    Circle,
    Rounded,
    Square,
}

fn layer(
    x: f32,
    y: f32,
    blur: f32,
    spread: f32,
    color: impl Into<Background>,
    inset: bool,
) -> BoxShadow {
    let shadow = BoxShadow::new(px(x), px(y), color)
        .blur_radius(px(blur))
        .spread_radius(px(spread));
    if inset { shadow.inset() } else { shadow }
}

fn sample(
    label: &'static str,
    shape: Shape,
    layers: Vec<BoxShadow>,
    border: Background,
) -> gpui::Div {
    let mut surface = div()
        .size(px(92.))
        .flex()
        .items_center()
        .justify_center()
        .border_4()
        .border_color(border)
        .bg(rgb(0xf8fafc))
        .shadow(layers);
    surface = match shape {
        Shape::Circle => surface.rounded_full(),
        Shape::Rounded => surface.rounded_lg(),
        Shape::Square => surface,
    };
    div()
        .flex()
        .flex_col()
        .items_center()
        .gap_2()
        .p_4()
        .child(surface.child("GPUI"))
        .child(div().text_xs().text_color(rgb(0x475569)).child(label))
}

fn gradient(angle: f32, first: u32, second: u32, alpha: f32) -> Background {
    linear_gradient(
        angle,
        linear_color_stop(gpui::rgba((first << 8) | (alpha * 255.) as u32), 0.),
        linear_color_stop(gpui::rgba((second << 8) | (alpha * 255.) as u32), 1.),
    )
}

struct ShadowGallery;

impl Render for ShadowGallery {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        let dark = rgb(0x111827);
        let neutral: Background = rgb(0x94a3b8).into();
        let ocean = gradient(135., 0x16a6c2, 0x7356d8, 0.75);
        let sunset = gradient(45., 0xef476f, 0xffb703, 0.8);
        let samples = [
            sample(
                "soft drop",
                Shape::Rounded,
                vec![layer(0., 10., 16., 0., dark, false)],
                neutral,
            ),
            sample(
                "tight + spread",
                Shape::Rounded,
                vec![layer(0., 8., 3., 6., dark, false)],
                neutral,
            ),
            sample(
                "left offset",
                Shape::Circle,
                vec![layer(-10., 0., 8., 0., ocean.clone(), false)],
                ocean.clone(),
            ),
            sample(
                "inset",
                Shape::Rounded,
                vec![layer(0., 2., 12., 2., dark, true)],
                neutral,
            ),
            sample(
                "stacked colors",
                Shape::Square,
                vec![
                    layer(-8., 8., 12., 1., ocean.clone(), false),
                    layer(8., 8., 12., 1., sunset.clone(), false),
                ],
                sunset.clone(),
            ),
            sample(
                "gradient border",
                Shape::Rounded,
                vec![layer(0., 12., 18., 2., ocean.clone(), false)],
                ocean,
            ),
            sample(
                "gradient inset",
                Shape::Rounded,
                vec![layer(0., 0., 14., 7., sunset.clone(), true)],
                sunset,
            ),
            sample(
                "drop + inset",
                Shape::Rounded,
                vec![
                    layer(0., 12., 20., 2., dark, false),
                    layer(0., 0., 12., 4., ocean, true),
                ],
                neutral,
            ),
        ];
        div()
            .size_full()
            .p_5()
            .bg(rgb(0xf1f3f6))
            .child(
                div()
                    .flex()
                    .flex_col()
                    .gap_2()
                    .child(
                        div()
                            .text_xl()
                            .font_weight(gpui::FontWeight::BOLD)
                            .child("Shadows"),
                    )
                    .child(
                        "Compare offset, blur, spread, inset, and gradient paint in the same card.",
                    ),
            )
            .child(div().flex().flex_wrap().children(samples))
    }
}

fn main() {
    example_prelude::run_example("Shadows", size(px(680.), px(460.)), |_, cx: &mut App| {
        cx.new(|_| ShadowGallery)
    });
}
