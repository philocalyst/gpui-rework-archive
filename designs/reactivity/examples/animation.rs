//! Syntax sketch of `crates/gpui/examples/learn/animation.rs`.
//!
//! Current GPUI: `with_animation("id", Animation::new(dur).repeat().with_easing(…), |el, t| el.with_transformation(…))`
//! — a string id and a per-frame Rust closure. The ladder: programs are property values.
//! `.spin(2.s())` is the 80%. Timing hangs off the value (`.over(…).repeat()`), not a wrapper.
//! The arrow is `asset!` — a compile-time embed, not `Application.with_assets`.
//!
//! `card` is a mixin with an honest bound (`fn card<E: Element + Styled>(e: E) -> E`, 13 §4.2)
//! applied mid-chain with `.apply(card)` — `pipe` no longer exists. `section` is never branched
//! over, so it returns the lifetime-hiding leaf spelling `impl Element + 'a`, not `El<'a>`; there
//! is no `el(…)` constructor to wrap it in (14 §1.2).

use gpui::prelude::*;

const ARROW: Asset = asset!("examples/legacy/image/arrow_circle.svg");

fn card<E: Element + Styled>(e: E) -> E {
    e.gap(8).p(16).bg(theme.container.opacity(0.5)).rounded_lg()
}

fn section<'a>(title: &'a str, caption: &'a str, demo: impl Element + 'a) -> impl Element + 'a {
    column((
        text(title).text_sm().semibold(),
        text(caption).text_xs().text_muted(),
        // One child, centered — a styled box, not a row arranging multiple items, so it stays
        // `div()` rather than a zero-arg `row()` (14 §2.1: flow containers are unary).
        div().center().h(96).child(demo),
    ))
    .apply(card)
}

struct AnimationExample;

impl View for AnimationExample {
    fn view(&self) -> El<'_> {
        // Outer: full-bleed (root fills the window by default, 12 §4b), scrollable, padded.
        // Inner: the readable-width content column — the two concerns stay two containers.
        // The outer box holds exactly one child (the inner column), so it is the styled-box
        // primitive `div()`, not a zero-arg `column()` (14 §2.1).
        div().p(24).bg(theme.background).scroll(Axis::Y).child(
            column((
                column((
                    text("Animation Patterns").text_xl().bold(),
                    text("Programs are ports. No with_animation id, no per-frame closure.")
                        .text_sm()
                        .text_muted(),
                ))
                .gap(4),
                section(
                    "Rotation",
                    "Continuous rotation — .spin(2.s()) is 1 turn, ease-in-out, repeat",
                    icon(ARROW).size_16().text_color(theme.selected).spin(2.s()),
                ),
                section(
                    "Bounce",
                    "Same program, bounce easing",
                    icon(ARROW)
                        .size_16()
                        .text_color(0x388e3c)
                        .rotate(1.turn().over(2.s()).bounce().repeat()),
                ),
                section(
                    "Scale",
                    "Pulse between 0.8 and 1.2",
                    icon(ARROW)
                        .size_16()
                        .text_color(0xf9a825)
                        .scale(pulse(0.8, 1.2).over(1.5.s()).bounce().repeat()),
                ),
                section(
                    "Combined",
                    "Two lanes on one element — not one closure composing Transformation",
                    icon(ARROW)
                        .size_16()
                        .text_color(0xd32f2f)
                        .rotate(1.turn().over(3.s()).ease_in_out().repeat())
                        .scale(pulse(0.7, 1.3).over(3.s()).ease_in_out().repeat()),
                ),
            ))
            .gap(24)
            .max_w(600),
        )
    }
}

fn main() {
    Application::run(
        Window::document(AnimationExample)
            .title("Animation")
            .size(500, 650)
            .centered(),
    );
}
