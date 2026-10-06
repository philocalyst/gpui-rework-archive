//! The hero view: a lit prism behind ordinary GPUI content.

use gpui::{
    Context, FontWeight, IntoElement, ParentElement, Render, Styled, Window, black, div, px, rgb,
    shader::{self, Input, Paint, Scalar, color, noise, paint, shape, vec2, vec2f},
    white,
};

/// Inverse-square falloff: `1` at zero distance, `1/2` at `radius`.
fn falloff(distance: Scalar, radius: f32) -> Scalar {
    let x = distance / radius;
    1.0 / (1.0 + &x * &x)
}

/// A black prism with light spilling around its edges from behind.
///
/// The light hides on the side away from the pointer, so moving the pointer
/// sweeps the glow around the rim; hovering brightens it and pressing flares
/// it. Everything computed here from `input` is plain Rust on the CPU and
/// reaches the GPU as uniforms, so the paint compiles once.
pub fn prism(input: &Input) -> Paint {
    let size = input.size;
    let center = vec2f(size.x * 0.5, size.y * 0.47);
    let radius = (size.y * 0.17).clamp(60.0, 180.0);

    let away = center - input.pointer;
    let reach = (away.x * away.x + away.y * away.y).sqrt();
    let push = if reach > 1.0 {
        away * ((reach * 0.4).min(radius * 0.75) / reach)
    } else {
        vec2f(0.0, 0.0)
    };
    let drift = vec2f(
        (input.time * 0.7).sin() * 6.0,
        (input.time * 0.5).cos() * 4.0,
    );
    let light = center + vec2f(0.0, -radius * 0.3) + push + drift;
    let strength = 0.8 + 0.4 * input.hover + if input.pressed { 0.5 } else { 0.0 };

    paint(|px| {
        let p = px.position();
        let distance = shape::triangle(&p - center, radius);
        let lit = falloff((&p - light).length(), radius * 0.65);
        let rim = falloff(distance.abs(), 1.3) * &lit;
        let halo = falloff(distance.max(0.0), radius * 0.14) * &lit;
        let bloom = falloff((&p - center).length(), radius * 2.2) * 0.07;
        // Film grain, fixed to the device pixel grid.
        let grain = noise::hash((&p * px.scale()).floor()) * 0.6 + 0.7;
        let glow = (rim * 0.9 + halo * 0.8) * strength * grain + bloom;
        let outside = 1.0 - distance.coverage();
        color(white()).mask(glow * outside).over(color(black()))
    })
}

/// The mark in the navigation bar: a small solid triangle.
fn mark() -> impl IntoElement {
    div().size(px(22.0)).bg(paint(|px| {
        // A triangle's center sits a third of the way up; lower it to look centered.
        color(white()).clip(shape::triangle(px.centered() - vec2(0.0, 2.6), 10.5))
    }))
}

fn button(label: &'static str, primary: bool) -> impl IntoElement {
    let button = div()
        .px_3()
        .py_1p5()
        .rounded(px(8.0))
        .text_sm()
        .font_weight(FontWeight::MEDIUM)
        .child(label);
    if primary {
        button.bg(white()).text_color(black())
    } else {
        button
            .border_1()
            .border_color(rgb(0x2e2e2e))
            .bg(rgb(0x0a0a0a))
            .text_color(white())
    }
}

fn pill(label: &'static str, primary: bool) -> impl IntoElement {
    let pill = div()
        .px_5()
        .py_3()
        .rounded_full()
        .text_base()
        .font_weight(FontWeight::MEDIUM)
        .child(label);
    if primary {
        pill.bg(rgb(0xededed)).text_color(black())
    } else {
        pill.border_1()
            .border_color(rgb(0x333333))
            .text_color(white())
    }
}

fn navigation() -> impl IntoElement {
    let link = |label: &'static str| div().text_sm().text_color(rgb(0xa1a1a1)).child(label);
    div()
        .flex()
        .items_center()
        .justify_between()
        .h(px(64.0))
        .px_6()
        .child(
            div().flex().items_center().gap_8().child(mark()).child(
                div()
                    .flex()
                    .gap_6()
                    .child(link("Products"))
                    .child(link("Resources"))
                    .child(link("Enterprise"))
                    .child(link("Pricing")),
            ),
        )
        .child(
            div()
                .flex()
                .gap_2()
                .child(button("Get a Demo", false))
                .child(button("Log In", false))
                .child(button("Sign Up", true)),
        )
}

pub struct Hero;

impl Render for Hero {
    fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
        let headline = div()
            .flex()
            .flex_col()
            .gap_8()
            .w(px(420.0))
            .child(
                div()
                    .text_size(px(64.0))
                    .line_height(px(66.0))
                    .text_color(white())
                    .child("Agentic Infrastructure"),
            )
            .child(
                div()
                    .flex()
                    .gap_3()
                    .child(pill("Deploy now", true))
                    .child(pill("Talk to sales", false)),
            );
        let tagline = div()
            .flex()
            .flex_col()
            .gap_3()
            .w(px(240.0))
            .text_color(rgb(0xededed))
            .child("For coding agents")
            .child("To ship apps and agents")
            .child("Automated by agents");

        div()
            .size_full()
            .relative()
            .bg(black())
            .text_color(white())
            .child(
                // The prism follows the pointer anywhere in the window, even
                // over the content painted on top of it.
                shader::layer("prism", prism)
                    .animate()
                    .absolute()
                    .size_full(),
            )
            .child(
                div()
                    .absolute()
                    .size_full()
                    .flex()
                    .flex_col()
                    .child(navigation())
                    .child(
                        div()
                            .flex()
                            .justify_center()
                            .gap_6()
                            .py_2()
                            .text_sm()
                            .child(
                                div()
                                    .text_color(rgb(0xa1a1a1))
                                    .child("Ship 26 is coming to SF"),
                            )
                            .child("Get your ticket  ›"),
                    )
                    .child(
                        div()
                            .flex_1()
                            .flex()
                            .items_center()
                            .justify_between()
                            .px(px(48.0))
                            .pb(px(64.0))
                            .child(headline)
                            .child(tagline),
                    ),
            )
    }
}
