//! Exhibit 03 — one element, four moods.
//!
//! Hover, press, release, and keyboard activation each move a small state
//! machine. The visuals are derived from that state every frame; nothing is
//! toggled by hand.
use crate::bridge::{exhibit, report};
use gpui::{Context, IntoElement, KeyDownEvent, MouseButton, Render, Window, div, prelude::*, px, rgb};

#[derive(Clone, Copy, PartialEq)]
enum Mood {
    Idle,
    Hovered,
    Pressed,
    Activated,
}

impl Mood {
    fn label(self) -> &'static str {
        match self {
            Mood::Idle => "Idle",
            Mood::Hovered => "Hovered",
            Mood::Pressed => "Pressed",
            Mood::Activated => "Activated",
        }
    }
}

struct Specimen {
    mood: Mood,
    activations: u32,
}

impl Specimen {
    fn set(&mut self, mood: Mood, cx: &mut Context<Self>) {
        if mood == Mood::Activated {
            self.activations += 1;
        }
        self.mood = mood;
        report("mood", mood.label());
        cx.notify();
    }
}

impl Render for Specimen {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let abyss = rgb(0x0f1d33);
        let paper = rgb(0xf3ead7);
        let coral = rgb(0xf0603f);
        let lagoon = rgb(0x5fd3c4);
        let gold = rgb(0xf2c14e);

        let (fill, ink, lift) = match self.mood {
            Mood::Idle => (abyss, paper, 0.),
            Mood::Hovered => (rgb(0x1a3350), paper, -4.),
            Mood::Pressed => (coral, abyss, 2.),
            Mood::Activated => (lagoon, abyss, -4.),
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
                    .child("EXHIBIT 03 · INTERACTION")
                    .child(format!("{} · {} activations", self.mood.label(), self.activations)),
            )
            .child(
                div().flex_1().flex().items_center().justify_center().child(
                    div()
                        .id("specimen")
                        .w(px(300.))
                        .h(px(96.))
                        .mt(px(lift))
                        .flex()
                        .items_center()
                        .justify_center()
                        .rounded_lg()
                        .border_2()
                        .border_color(gold)
                        .bg(fill)
                        .text_color(ink)
                        .font_family("Pilowlava")
                        .text_size(px(26.))
                        .cursor_pointer()
                        .focusable()
                        .child(match self.mood {
                            Mood::Idle => "Point, press, or focus.",
                            other => other.label(),
                        })
                        .on_hover(cx.listener(|this, hovered: &bool, _, cx| {
                            this.set(if *hovered { Mood::Hovered } else { Mood::Idle }, cx)
                        }))
                        .on_mouse_down(MouseButton::Left, cx.listener(|this, _, _, cx| this.set(Mood::Pressed, cx)))
                        .on_click(cx.listener(|this, _, _, cx| this.set(Mood::Activated, cx)))
                        .on_key_down(cx.listener(|this, event: &KeyDownEvent, _, cx| {
                            if matches!(event.keystroke.key.as_str(), "space" | "enter") {
                                this.set(Mood::Activated, cx);
                            }
                        })),
                ),
            )
    }
}

pub fn main() {
    exhibit(|_, cx| cx.new(|_| Specimen { mood: Mood::Idle, activations: 0 }));
}
