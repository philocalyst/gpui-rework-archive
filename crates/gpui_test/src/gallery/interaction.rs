//! Input-driven controls shared by interactive examples and deterministic scenarios.

use gpui::{
    Context, FocusHandle, KeyDownEvent, Render, ScrollHandle, ScrollWheelEvent, Window, div,
    prelude::*, px, rgb,
};

pub struct InteractionScenario {
    root: FocusHandle,
    did_focus: bool,
    focus_items: Vec<FocusHandle>,
    selected_index: usize,
    tree_expanded: bool,
    scroll_events: usize,
    scroll: ScrollHandle,
}

impl InteractionScenario {
    pub fn new(cx: &mut Context<Self>) -> Self {
        let root = cx.focus_handle();
        let focus_items = (1..=3)
            .map(|index| cx.focus_handle().tab_index(index).tab_stop(true))
            .collect();
        Self {
            root,
            did_focus: false,
            focus_items,
            selected_index: 0,
            tree_expanded: true,
            scroll_events: 0,
            scroll: ScrollHandle::new(),
        }
    }

    pub fn selected_index(&self) -> usize {
        self.selected_index
    }
    pub fn tree_expanded(&self) -> bool {
        self.tree_expanded
    }
    pub fn scroll_events(&self) -> usize {
        self.scroll_events
    }
    pub fn scroll_offset_y(&self) -> f32 {
        self.scroll.offset().y.as_f32()
    }

    pub fn root_focused(&self, window: &Window) -> bool {
        self.root.is_focused(window)
    }

    /// Reads actual GPUI focus state; no test-only focus mirror is maintained.
    pub fn focused_index(&self, window: &Window) -> Option<usize> {
        self.focus_items
            .iter()
            .position(|handle| handle.is_focused(window))
    }
}

impl Render for InteractionScenario {
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        if !self.did_focus {
            // Scenario construction has no Window; establish initial focus on the first real frame.
            window.focus(&self.root, cx);
            self.did_focus = true;
        }
        let items = self.focus_items.iter().enumerate().map(|(index, handle)| {
            div()
                .id(index)
                .debug_selector(move || format!("interaction-item-{index}"))
                .track_focus(handle)
                .tab_stop(true)
                .focus_visible(|style| style.border_2().border_color(rgb(0x2563eb)))
                .p_3()
                .rounded_md()
                .bg(if self.selected_index == index {
                    rgb(0xdbeafe)
                } else {
                    rgb(0xf1f5f9)
                })
                .child(format!("Focus and select item {}", index + 1))
                .on_click(cx.listener(move |this, _, _, cx| {
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
            .id("interaction-scenario")
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
