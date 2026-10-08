use gpui::{
    AppContext, Context, FocusHandle, IntoElement, Render, Role, Window, div, prelude::*, rgb, text,
};

struct Counter {
    count: u32,
    focus: FocusHandle,
}

impl Render for Counter {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .track_focus(&self.focus)
            .on_key_down(|event, window, cx| {
                let mut modifiers = event.keystroke.modifiers;
                let reverse = modifiers.shift;
                modifiers.shift = false;
                if event.keystroke.key == "tab" && !modifiers.modified() {
                    if reverse {
                        window.focus_prev(cx);
                    } else {
                        window.focus_next(cx);
                    }
                    cx.stop_propagation();
                }
            })
            .size_full()
            .flex()
            .flex_col()
            .items_center()
            .justify_center()
            .gap_4()
            .bg(rgb(0xf7f6f2))
            .text_color(rgb(0x202b29))
            .child(
                div()
                    .text_2xl()
                    .child(text!(format!("Count: {}", self.count))),
            )
            .child(
                div()
                    .id("increment")
                    .role(Role::Button)
                    .aria_label("Increment")
                    .tab_index(0)
                    .focus_visible(|style| style.ring_2().ring_color(rgb(0x3478c8)))
                    .px_4()
                    .py_2()
                    .rounded_md()
                    .bg(rgb(0x155b50))
                    .text_color(rgb(0xffffff))
                    .cursor_pointer()
                    .child("Increment")
                    .on_click(cx.listener(|this, _event, _window, cx| this.increment(cx))),
            )
    }
}

impl Counter {
    fn increment(&mut self, cx: &mut Context<Self>) {
        self.count = self.count.saturating_add(1);
        cx.notify();
    }
}

fn component(window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<Counter> {
    cx.new(|cx| {
        let focus = cx.focus_handle();
        window.focus(&focus, cx);
        Counter { count: 0, focus }
    })
}
