//! Pointer events and typed drag/drop. For keyboard focus and selection, see `input_states`.

#[path = "interaction/drag.rs"]
mod drag;
#[path = "../shared/prelude.rs"]
mod example_prelude;

use drag::DragItem;
use gpui::{
    Context, MouseButton, MouseMoveEvent, Pixels, Point, Window, div, prelude::*, px, rgb, size,
};

#[derive(Default)]
struct InteractionLesson {
    clicks: usize,
    hovered: bool,
    mouse_position: Option<Point<Pixels>>,
    mouse_pressed: bool,
    dropped: Option<DragItem>,
}

impl InteractionLesson {
    fn new(_window: &mut Window, _cx: &mut Context<Self>) -> Self {
        Self::default()
    }
}

impl Render for InteractionLesson {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .size_full()
            .p_4()
            .flex()
            .flex_col()
            .gap_4()
            .bg(rgb(0xf4f5f7))
            .child(panel(
                "Click and hover",
                div()
                    .flex()
                    .gap_3()
                    .child(
                        div()
                            .id("click-button")
                            .debug_selector(|| "click-button".into())
                            .p_3()
                            .rounded_md()
                            .bg(rgb(0x3857a6))
                            .text_color(rgb(0xffffff))
                            .cursor_pointer()
                            .child(format!("Clicked {} times", self.clicks))
                            // cx.listener upgrades the owning entity only while handling this event.
                            .on_click(cx.listener(|this, _, _, cx| {
                                this.clicks += 1;
                                cx.notify();
                            })),
                    )
                    .child(
                        div()
                            .id("hover-target")
                            .debug_selector(|| "hover-target".into())
                            .p_3()
                            .rounded_md()
                            .bg(rgb(0xffffff))
                            .child(if self.hovered {
                                "Pointer inside"
                            } else {
                                "Hover here"
                            })
                            // Use hover() for appearance alone; on_hover is for actual application state.
                            .hover(|style| style.bg(rgb(0xcbd5e1)))
                            .on_hover(cx.listener(|this, &hovered, _, cx| {
                                this.hovered = hovered;
                                cx.notify();
                            })),
                    ),
            ))
            .child(panel(
                "Mouse down, move, and up",
                div()
                    .id("mouse-target")
                    .debug_selector(|| "mouse-target".into())
                    .h(px(100.))
                    .p_3()
                    .rounded_md()
                    .bg(if self.mouse_pressed {
                        rgb(0xcbd5e1)
                    } else {
                        rgb(0xffffff)
                    })
                    .child(self.mouse_position.map_or_else(
                        || "Move or press here".into(),
                        |p| format!("Window coordinates: {:.0}, {:.0}", p.x, p.y),
                    ))
                    .on_mouse_down(
                        MouseButton::Left,
                        cx.listener(|this, _, _, cx| {
                            this.mouse_pressed = true;
                            cx.notify();
                        }),
                    )
                    .on_mouse_up(
                        MouseButton::Left,
                        cx.listener(|this, _, _, cx| {
                            this.mouse_pressed = false;
                            cx.notify();
                        }),
                    )
                    // A release outside the panel must also clear the pressed state.
                    .on_mouse_up_out(
                        MouseButton::Left,
                        cx.listener(|this, _, _, cx| {
                            this.mouse_pressed = false;
                            cx.notify();
                        }),
                    )
                    .on_mouse_move(cx.listener(|this, event: &MouseMoveEvent, _, cx| {
                        this.mouse_position = Some(event.position);
                        cx.notify();
                    })),
            ))
            .child(panel(
                "Drag a typed value into the target",
                drag::controls(self.dropped, cx),
            ))
    }
}

fn panel(title: &'static str, content: impl IntoElement) -> impl IntoElement {
    div()
        .flex()
        .flex_col()
        .gap_2()
        .child(div().font_weight(gpui::FontWeight::SEMIBOLD).child(title))
        .child(content)
}

fn main() {
    example_prelude::run_example(
        "Pointer interactions",
        size(px(640.), px(420.)),
        |window, cx| cx.new(|cx| InteractionLesson::new(window, cx)),
    );
}

#[cfg(all(test, feature = "test-support"))]
#[path = "interaction/tests.rs"]
mod tests;
