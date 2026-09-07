//! Exhibit 01 — the counter.
//!
//! Two buttons, one number. The struct is the state, `render` is the view, and
//! every click runs through an entity update followed by `cx.notify()`.
use crate::bridge::{exhibit, report};
use gpui::{App, Context, FontWeight, IntoElement, Render, Window, div, prelude::*, px, rgb};

struct Counter {
    count: i32,
}

impl Counter {
    fn step(&mut self, delta: i32, cx: &mut Context<Self>) {
        self.count = (self.count + delta).clamp(-99, 99);
        report("count", self.count);
        cx.notify();
    }
}

impl Render for Counter {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let abyss = rgb(0x0f1d33);
        let paper = rgb(0xf3ead7);
        let coral = rgb(0xf0603f);
        let lagoon = rgb(0x5fd3c4);

        div()
            .size_full()
            .flex()
            .flex_col()
            .bg(abyss)
            .text_color(paper)
            .font_family("Monaspace Neon")
            .child(
                div()
                    .h(px(34.))
                    .flex()
                    .items_center()
                    .justify_between()
                    .px_4()
                    .border_b_1()
                    .border_color(lagoon)
                    .text_xs()
                    .text_color(lagoon)
                    .child("EXHIBIT 01 · COUNTER")
                    .child("GPUI · WASM · GPU"),
            )
            .child(
                div()
                    .flex_1()
                    .flex()
                    .items_center()
                    .justify_center()
                    .gap_6()
                    .child(round_button("decrement", "−", coral, abyss, cx.listener(|this, _, _, cx| this.step(-1, cx))))
                    .child(
                        div()
                            .min_w(px(150.))
                            .text_center()
                            .font_family("Pilowlava")
                            .text_size(px(96.))
                            .text_color(paper)
                            .child(self.count.to_string()),
                    )
                    .child(round_button("increment", "+", lagoon, abyss, cx.listener(|this, _, _, cx| this.step(1, cx)))),
            )
    }
}

fn round_button(
    id: &'static str,
    label: &'static str,
    color: gpui::Rgba,
    ink: gpui::Rgba,
    on_click: impl Fn(&gpui::ClickEvent, &mut Window, &mut App) + 'static,
) -> impl IntoElement {
    div()
        .id(id)
        .size(px(56.))
        .flex()
        .items_center()
        .justify_center()
        .rounded_full()
        .border_2()
        .border_color(color)
        .text_color(color)
        .text_size(px(28.))
        .font_weight(FontWeight::BOLD)
        .cursor_pointer()
        .child(label)
        .hover(move |style| style.bg(color).text_color(ink))
        .active(|style| style.opacity(0.7))
        .on_click(on_click)
}

pub fn main() {
    exhibit(|_, cx| cx.new(|_| Counter { count: 0 }));
}
