//! Selection, disclosure, scrolling, and visible keyboard focus in one small list.

use gpui::{
    Context, FocusHandle, KeyDownEvent, Render, ScrollHandle, ScrollWheelEvent, Window, div,
    prelude::*, px, rgb,
};

struct InputStatesExample {
    root: FocusHandle,
    focus_items: Vec<FocusHandle>,
    selected_index: usize,
    tree_expanded: bool,
    scroll_events: usize,
    scroll: ScrollHandle,
}

impl InputStatesExample {
    fn new(window: &mut Window, cx: &mut Context<Self>) -> Self {
        let root = cx.focus_handle();
        window.focus(&root, cx);
        let focus_items = (1..=3)
            .map(|index| cx.focus_handle().tab_index(index).tab_stop(true))
            .collect();
        Self {
            root,
            focus_items,
            selected_index: 0,
            tree_expanded: true,
            scroll_events: 0,
            scroll: ScrollHandle::new(),
        }
    }

    fn scroll_offset_y(&self) -> f32 {
        self.scroll.offset().y.as_f32()
    }
}

impl Render for InputStatesExample {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let items = self.focus_items.iter().enumerate().map(|(index, handle)| {
            div()
                .id(index)
                .debug_selector(move || format!("interaction-item-{index}"))
                .track_focus(handle)
                .tab_stop(true)
                // Pointer focus selects the item; keyboard focus also draws a visible ring.
                .focus_visible(|style| style.border_2().border_color(rgb(0x2563eb)))
                .p_3()
                .rounded_md()
                .bg(if self.selected_index == index {
                    rgb(0xdbeafe)
                } else {
                    rgb(0xf1f5f9)
                })
                .child(format!("Focus and select item {}", index + 1))
                .on_click(cx.listener(move |this, _, window, cx| {
                    window.focus(&this.focus_items[index], cx);
                    this.selected_index = index;
                    cx.notify();
                }))
        });
        let tree_label = if self.tree_expanded {
            "Collapse branch"
        } else {
            "Expand branch"
        };
        div()
            .id("input-states")
            .track_focus(&self.root)
            .on_key_down(cx.listener(|_, event: &KeyDownEvent, window, cx| {
                if event.keystroke.key == "tab" {
                    if event.keystroke.modifiers.shift {
                        window.focus_prev(cx);
                    } else {
                        window.focus_next(cx);
                    }
                }
            }))
            .flex()
            .flex_col()
            .gap_2()
            .size_full()
            .p_4()
            .bg(rgb(0xf8fafc))
            .child(
                div()
                    .text_lg()
                    .font_weight(gpui::FontWeight::BOLD)
                    .child("Input and state"),
            )
            .children(items)
            .child(
                div()
                    .id("tree-toggle")
                    .debug_selector(|| "interaction-tree-toggle".into())
                    .p_2()
                    .bg(rgb(0xe2e8f0))
                    .cursor_pointer()
                    .child(tree_label)
                    .on_click(cx.listener(|this, _, _, cx| {
                        this.tree_expanded = !this.tree_expanded;
                        cx.notify();
                    })),
            )
            .when(self.tree_expanded, |el| {
                el.child(div().ml_4().p_2().bg(rgb(0xcbd5e1)).child("Nested child"))
            })
            .child(
                div()
                    .id("scroll-viewport")
                    .debug_selector(|| "interaction-scroll-viewport".into())
                    .h(px(70.))
                    .overflow_scroll()
                    .track_scroll(&self.scroll)
                    .p_2()
                    .bg(rgb(0xe0f2fe))
                    .on_scroll_wheel(cx.listener(|this, _: &ScrollWheelEvent, _, cx| {
                        this.scroll_events += 1;
                        cx.notify();
                    }))
                    .child(
                        div()
                            .flex()
                            .flex_col()
                            .gap_1()
                            .child("Wheel input moves these labeled rows:")
                            .children((0..12).map(|row| {
                                div()
                                    .h(px(24.))
                                    .px_2()
                                    .bg(if row % 2 == 0 {
                                        rgb(0xffffff)
                                    } else {
                                        rgb(0xdbeafe)
                                    })
                                    .child(format!("Row {row:02}"))
                            })),
                    ),
            )
            .child(format!(
                "Selected: {} · scroll events: {} · offset: {:.0}px",
                self.selected_index + 1,
                self.scroll_events,
                self.scroll_offset_y()
            ))
    }
}

#[path = "../../shared/prelude.rs"]
mod example_prelude;

fn main() {
    example_prelude::run_example(
        "Input states",
        gpui::size(px(420.), px(480.)),
        |window, cx: &mut gpui::App| cx.new(|cx| InputStatesExample::new(window, cx)),
    );
}
