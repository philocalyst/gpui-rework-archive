//! Syntax sketch of `crates/gpui/examples/learn/transition.rs`.
//!
//! Hover is a style variant; the transition is element policy.
//! Launch is the terse `Application::run(Window::document(view)…)` (07 §12).
//! `pill` borrows the `&str` label and is never branched over, so it returns the lifetime-hiding
//! leaf spelling `impl Element + Styled + '_` (14 §1.2) — `Styled` stays only to advertise that
//! the caller may keep restyling it, not because `El<'_>` would refuse the same chain.

use gpui::prelude::*;

fn pill(label: &str) -> impl Element + Styled + '_ {
    button(label)
        .rounded(100)
        .px(14)
        .py(10)
        .bg(0x663399)
        .text_color(0x110F15)
        .hover(|s| s.bg(Color::Black.mix(0x663399, 0.7)))
        .transition(Prop::Background, ease_in_out(300.ms()))
}

struct TransitionExample;

impl View for TransitionExample {
    fn view(&self) -> El<'_> {
        // No children at all here, so this is honestly the styled-box primitive, not a flow
        // container — `row()` never takes zero args (14 §2.1).
        div().center().bg(0x110F15).gap(20).p(100)
        // .child(pill("Click me!"))
    }
}

fn main() {
    Application::run(Window::document(TransitionExample).title("Transition").size(500, 650).centered());
}
