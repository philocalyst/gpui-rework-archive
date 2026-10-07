//! One small lesson for pointer events, keyboard focus, conditional styles, and drag/drop.

#[path = "../shared/prelude.rs"]
mod example_prelude;

use gpui::{
    App, ClickEvent, ColorExt, Context, FocusHandle, Hsla, KeyDownEvent, Keystroke, MouseButton,
    MouseMoveEvent, Pixels, PlatformInput, Point, Render, Window, div, prelude::*, px, rgb, size,
};
use palette::IntoColor;
use std::time::Duration;

fn panel(title: &'static str, hint: &'static str, content: impl IntoElement) -> impl IntoElement {
    div()
        .flex()
        .flex_col()
        .gap_3()
        .p_4()
        .min_w(px(270.))
        .flex_1()
        .rounded_lg()
        .bg(rgb(0xf4f5f7))
        .child(
            div()
                .text_sm()
                .font_weight(gpui::FontWeight::SEMIBOLD)
                .child(title),
        )
        .child(div().text_xs().text_color(rgb(0x606876)).child(hint))
        .child(content)
}

fn button(id: &'static str, label: &'static str) -> gpui::Stateful<gpui::Div> {
    div()
        .id(id)
        .debug_selector(|| id.into())
        .px_3()
        .py_2()
        .rounded_md()
        .bg(rgb(0x3857a6))
        .text_color(rgb(0xffffff))
        .cursor_pointer()
        .hover(|style| style.opacity(0.85))
        .active(|style| style.opacity(0.7))
        .child(label)
}

#[derive(Clone, Copy)]
struct DragItem {
    index: usize,
    color: Hsla,
}

struct DragPreview {
    item: DragItem,
    position: Point<Pixels>,
}

impl Render for DragPreview {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .id("drag-preview")
            .debug_selector(|| "drag-preview".into())
            .pl(self.position.x - px(40.))
            .pt(self.position.y - px(20.))
            .child(
                div()
                    .w(px(80.))
                    .h(px(40.))
                    .flex()
                    .items_center()
                    .justify_center()
                    .rounded_md()
                    .bg(self.item.color)
                    .text_color(rgb(0xffffff))
                    .shadow_lg()
                    .child(format!("Item {}", self.item.index + 1)),
            )
    }
}

struct InteractionLesson {
    root: FocusHandle,
    tab_stops: [FocusHandle; 2],
    clicks: usize,
    last_click: String,
    hovered: bool,
    hover_count: usize,
    mouse_position: Option<Point<Pixels>>,
    mouse_pressed: bool,
    selected: bool,
    dropped: Option<DragItem>,
}

impl InteractionLesson {
    fn new(window: &mut Window, cx: &mut Context<Self>) -> Self {
        let root = cx.focus_handle();
        window.focus(&root, cx);
        Self {
            root,
            tab_stops: std::array::from_fn(|index| {
                cx.focus_handle()
                    .tab_index(index as isize + 1)
                    .tab_stop(true)
            }),
            clicks: 0,
            last_click: "None".into(),
            hovered: false,
            hover_count: 0,
            mouse_position: None,
            mouse_pressed: false,
            selected: false,
            dropped: None,
        }
    }

    fn focused_tab_stop(&self, window: &Window) -> Option<usize> {
        self.tab_stops
            .iter()
            .position(|handle| handle.is_focused(window))
    }

    fn root_focused(&self, window: &Window) -> bool {
        self.root.is_focused(window)
    }
}

impl Render for InteractionLesson {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .id("interaction")
            .track_focus(&self.root)
            .on_key_down(cx.listener(|_, event: &KeyDownEvent, window, cx| {
                if event.keystroke.key == "tab" {
                    // The lesson owns tab order; suppress the platform's competing default move.
                    window.prevent_default();
                    if event.keystroke.modifiers.shift {
                        window.focus_prev(cx);
                    } else {
                        window.focus_next(cx);
                    }
                }
            }))
            .size_full()
            .p_5()
            .bg(rgb(0xe9ebef))
            .text_color(rgb(0x20242b))
            .child(
                div()
                    .flex()
                    .flex_col()
                    .gap_4()
                    .max_w(px(760.))
                    .child(
                        div()
                            .text_xl()
                            .font_weight(gpui::FontWeight::BOLD)
                            .child("Interaction"),
                    )
                    .child(
                        div()
                            .flex()
                            .flex_wrap()
                            .gap_3()
                            .child(self.click_focus_panel(cx))
                            .child(self.hover_panel(cx))
                            .child(self.mouse_panel(cx))
                            .child(self.drag_panel(cx)),
                    ),
            )
    }
}

impl InteractionLesson {
    fn click_focus_panel(&self, cx: &mut Context<Self>) -> impl IntoElement + use<> {
        panel(
            "Click and focus",
            "Click count comes from event data; Tab follows focus handles.",
            div()
                .flex()
                .flex_col()
                .gap_2()
                .child(button("click-button", "Click me").on_click(cx.listener(
                    |this, event: &ClickEvent, _, cx| {
                        this.clicks += 1;
                        this.last_click = match event.click_count() {
                            1 => "single".into(),
                            2 => "double".into(),
                            n => format!("{n}×"),
                        };
                        cx.notify();
                    },
                )))
                .child(
                    div()
                        .text_xs()
                        .child(format!("{} clicks · last {}", self.clicks, self.last_click)),
                )
                .child(
                    div()
                        .flex()
                        .gap_2()
                        .child(focus_button("focus-first", &self.tab_stops[0]))
                        .child(focus_button("focus-second", &self.tab_stops[1])),
                ),
        )
    }

    fn hover_panel(&self, cx: &mut Context<Self>) -> impl IntoElement + use<> {
        let muted = rgb(0x606876);
        let accent = rgb(0x3857a6);
        panel(
            "Hover and conditional styles",
            "State selects hover, selected, and disabled treatments; the parent owns group hover.",
            div()
                .flex()
                .flex_col()
                .gap_2()
                .child(
                    div()
                        .id("hover-target")
                        .debug_selector(|| "hover-target".into())
                        .px_3()
                        .py_2()
                        .rounded_md()
                        .bg(if self.hovered { accent } else { rgb(0xffffff) })
                        .text_color(if self.hovered {
                            rgb(0xffffff)
                        } else {
                            rgb(0x20242b)
                        })
                        .child(if self.hovered { "Inside" } else { "Hover here" })
                        .on_hover(cx.listener(|this, &hovered, _, cx| {
                            this.hovered = hovered;
                            if hovered {
                                this.hover_count += 1;
                            }
                            cx.notify();
                        })),
                )
                .child(
                    div()
                        .text_xs()
                        .text_color(muted)
                        .child(format!("Entered {} times", self.hover_count)),
                )
                .child(
                    div()
                        .flex()
                        .gap_2()
                        .child(
                            div()
                                .id("selected-row")
                                .debug_selector(|| "selected-row".into())
                                .px_3()
                                .py_2()
                                .rounded_md()
                                .bg(if self.selected { accent } else { rgb(0xffffff) })
                                .text_color(if self.selected {
                                    rgb(0xffffff)
                                } else {
                                    rgb(0x20242b)
                                })
                                .cursor_pointer()
                                .child(if self.selected { "Selected" } else { "Normal" })
                                .on_click(cx.listener(|this, _, _, cx| {
                                    this.selected = !this.selected;
                                    cx.notify();
                                })),
                        )
                        .child(
                            div()
                                .px_3()
                                .py_2()
                                .rounded_md()
                                .opacity(0.45)
                                .text_color(muted)
                                .child("Disabled"),
                        ),
                )
                .child(
                    div()
                        .group("card")
                        .flex()
                        .justify_between()
                        .p_2()
                        .rounded_md()
                        .bg(rgb(0xffffff))
                        .hover(|style| style.bg(rgb(0xe0e7f2)))
                        .child("Parent hover")
                        .child(
                            div()
                                .opacity(0.)
                                .group_hover("card", |style| style.opacity(1.))
                                .child("→"),
                        ),
                ),
        )
    }

    fn mouse_panel(&self, cx: &mut Context<Self>) -> impl IntoElement + use<> {
        let pointer = self.mouse_position.map_or_else(
            || "Move pointer here".to_string(),
            |point| {
                format!(
                    "Pointer: {:.0}, {:.0}",
                    f32::from(point.x),
                    f32::from(point.y)
                )
            },
        );
        let accent = rgb(0x3857a6);
        panel(
            "Mouse events",
            "Down/up control pressed state; move reports window coordinates.",
            div()
                .id("mouse-target")
                .debug_selector(|| "mouse-target".into())
                .h(px(100.))
                .flex()
                .items_center()
                .justify_center()
                .rounded_md()
                .bg(if self.mouse_pressed {
                    accent
                } else {
                    rgb(0xffffff)
                })
                .text_color(if self.mouse_pressed {
                    rgb(0xffffff)
                } else {
                    rgb(0x20242b)
                })
                .child(pointer)
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
                .on_mouse_move(cx.listener(|this, event: &MouseMoveEvent, _, cx| {
                    this.mouse_position = Some(event.position);
                    cx.notify();
                })),
        )
    }

    fn drag_panel(&self, cx: &mut Context<Self>) -> impl IntoElement + use<> {
        let colors = [rgb(0xd45555), rgb(0x348b62), rgb(0x9670c9)];
        panel(
            "Drag and drop",
            "A typed drag value also paints the cursor preview and is stored on drop.",
            div()
                .flex()
                .flex_col()
                .gap_3()
                .child(
                    div()
                        .flex()
                        .gap_2()
                        .children(colors.into_iter().enumerate().map(|(index, color)| {
                            let item = DragItem {
                                index,
                                color: color.into_color(),
                            };
                            div()
                                .id(("drag-item", index))
                                .debug_selector(move || format!("drag-item-{index}"))
                                .px_3()
                                .py_2()
                                .rounded_md()
                                .bg(color)
                                .text_color(rgb(0xffffff))
                                .cursor_grab()
                                .child(format!("Item {}", index + 1))
                                .on_drag(item, |item, position, _, cx| {
                                    cx.new(|_| DragPreview {
                                        item: *item,
                                        position,
                                    })
                                })
                        })),
                )
                .child(
                    div()
                        .id("drop-target")
                        .debug_selector(|| "drop-target".into())
                        .h(px(56.))
                        .flex()
                        .items_center()
                        .justify_center()
                        .rounded_md()
                        .border_1()
                        .border_dashed()
                        .border_color(
                            self.dropped
                                .map_or(rgb(0x9aa1ad), |item| item.color.into_color()),
                        )
                        .bg(self
                            .dropped
                            .map_or(gpui::hsla(0., 0., 1., 1.), |item| item.color.opacity(0.2)))
                        .child(self.dropped.map_or_else(
                            || "Drop an item".to_string(),
                            |item| format!("Dropped item {}", item.index + 1),
                        ))
                        .on_drop(cx.listener(|this, item: &DragItem, _, cx| {
                            this.dropped = Some(*item);
                            cx.notify();
                        })),
                ),
        )
    }
}

fn focus_button(id: &'static str, handle: &FocusHandle) -> gpui::Stateful<gpui::Div> {
    div()
        .id(id)
        .debug_selector(|| id.into())
        .track_focus(handle)
        .px_3()
        .py_2()
        .rounded_md()
        .bg(rgb(0xffffff))
        .border_1()
        .border_color(rgb(0x9aa1ad))
        .focus(|style| style.border_color(rgb(0x3857a6)))
        .focus_visible(|style| style.border_2().border_color(rgb(0x2563eb)).shadow_sm())
        .child("Tab stop")
}

fn main() {
    let scenario = lesson_scenario().expect("valid interaction lesson scenario");
    example_prelude::run_example(scenario).expect("run interaction lesson");
}

#[cfg(test)]
mod tests {
    use super::*;
    use gpui_test::Harness;

    #[test]
    fn tab_and_shift_tab_move_focus_between_controls() -> anyhow::Result<()> {
        Harness::new().run(&lesson_scenario()?)?;
        Ok(())
    }
}

#[path = "interaction/checkpoints.rs"]
mod checkpoints;
use checkpoints::lesson_scenario;
