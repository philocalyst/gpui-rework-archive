use gpui::{
    AppContext, Context, FocusHandle, IntoElement, KeyBinding, Render, Window, actions, div,
    prelude::*, rgb,
};

actions!(counter_keys, [Increment]);

struct KeyboardCounter {
    count: u32,
    focus: FocusHandle,
}

fn component(window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<KeyboardCounter> {
    cx.bind_keys([KeyBinding::new("space", Increment, Some("Counter"))]);
    cx.new(|cx| {
        let focus = cx.focus_handle();
        window.focus(&focus, cx);
        KeyboardCounter { count: 0, focus }
    })
}


impl Render for KeyboardCounter {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .id("keyboard-counter")
            .key_context("Counter")
            .track_focus(&self.focus)
            .on_action(cx.listener(|this, _action: &Increment, _window, cx| {
                this.count = this.count.saturating_add(1);
                cx.notify();
            }))
            .size_full()
            .flex()
            .flex_col()
            .items_center()
            .justify_center()
            .gap_4()
            .bg(rgb(0xf7f6f2))
            .text_color(rgb(0x202b29))
            .child(format!("Count: {}", self.count))
            .child("Press Space to increment")
    }
}
