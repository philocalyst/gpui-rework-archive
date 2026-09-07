//! Exhibit 02 — layout that answers to its container.
//!
//! The same two panels arrange themselves as a column, a tight row, or a
//! spacious row. The decision lives in `arrangement`, a plain function of the
//! available width, and the buttons only change that width.
use crate::bridge::{exhibit, report};
use gpui::{App, Context, IntoElement, Render, Window, div, prelude::*, px, rgb};

#[derive(Clone, Copy, PartialEq)]
enum Arrangement {
    Column,
    CompactRow,
    SpaciousRow,
}

fn arrangement(width: f32) -> Arrangement {
    match width {
        w if w < 340. => Arrangement::Column,
        w if w < 560. => Arrangement::CompactRow,
        _ => Arrangement::SpaciousRow,
    }
}

struct Workbench {
    width: f32,
}

impl Render for Workbench {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let abyss = rgb(0x0f1d33);
        let paper = rgb(0xf3ead7);
        let coral = rgb(0xf0603f);
        let lagoon = rgb(0x5fd3c4);
        let gold = rgb(0xf2c14e);

        let mode = arrangement(self.width);
        let gap = ((self.width - 220.).max(0.) / 18. + 8.).clamp(8., 28.);
        let label = match mode {
            Arrangement::Column => "column",
            Arrangement::CompactRow => "compact row",
            Arrangement::SpaciousRow => "spacious row",
        };

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
                    .child("EXHIBIT 02 · LAYOUT")
                    .child(format!("{}px · {label}", self.width as i32)),
            )
            .child(
                div()
                    .flex_1()
                    .flex()
                    .items_center()
                    .justify_center()
                    .p_4()
                    .child(
                        div()
                            .w(px(self.width))
                            .h(px(120.))
                            .flex()
                            .when(mode == Arrangement::Column, |stage| stage.flex_col())
                            .gap(px(gap))
                            .child(panel("Workbench", "Flexible space follows the width.", coral))
                            .child(panel("Inspector", "Narrow states stack both regions.", gold)),
                    ),
            )
            .child(
                div()
                    .h(px(40.))
                    .flex()
                    .items_center()
                    .justify_center()
                    .gap_2()
                    .border_t_1()
                    .border_color(lagoon)
                    .child(width_button("narrow", "Narrow", 280., self.width, lagoon, abyss, cx))
                    .child(width_button("compact", "Compact", 460., self.width, lagoon, abyss, cx))
                    .child(width_button("spacious", "Spacious", 620., self.width, lagoon, abyss, cx)),
            )
    }
}

fn panel(title: &'static str, note: &'static str, accent: gpui::Rgba) -> impl IntoElement {
    div()
        .flex_1()
        .min_w(px(0.))
        .p_3()
        .rounded_md()
        .border_1()
        .border_color(accent)
        .text_xs()
        .child(div().text_color(accent).text_sm().child(title))
        .child(div().child(note))
}

fn width_button(
    id: &'static str,
    label: &'static str,
    width: f32,
    current: f32,
    color: gpui::Rgba,
    ink: gpui::Rgba,
    cx: &mut Context<Workbench>,
) -> impl IntoElement {
    let selected = (current - width).abs() < 1.;
    div()
        .id(id)
        .px_3()
        .py_1()
        .rounded_full()
        .border_1()
        .border_color(color)
        .text_xs()
        .cursor_pointer()
        .when(selected, |button| button.bg(color).text_color(ink))
        .hover(move |style| style.bg(color).text_color(ink))
        .child(label)
        .on_click(cx.listener(move |this, _, _, cx| {
            this.width = width;
            report("width", width as i32);
            cx.notify();
        }))
}

pub fn main() {
    exhibit(|_, cx: &mut App| cx.new(|_| Workbench { width: 460. }));
}
