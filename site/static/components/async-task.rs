use gpui::{
    AppContext, Context, IntoElement, Render, Role, Task, Window, div, prelude::*, rgb, text,
};
use std::time::Duration;

struct AsyncDemo {
    task: Option<Task<()>>,
    running: bool,
    message: String,
}

impl AsyncDemo {
    fn start(&mut self, cx: &mut Context<Self>) {
        self.task = None;
        self.running = true;
        self.message = "Waiting...".into();
        cx.notify();
        self.task = Some(cx.spawn(async move |this, cx| {
            cx.background_executor().timer(Duration::from_secs(2)).await;
            let _ = this.update(cx, |this, cx| {
                this.running = false;
                this.task = None;
                this.message = "Complete".into();
                cx.notify();
            });
        }));
    }

    fn stop(&mut self, cx: &mut Context<Self>) {
        self.task = None;
        self.running = false;
        self.message = "Stopped".into();
        cx.notify();
    }
}

impl Render for AsyncDemo {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let action = if self.running { "Stop" } else { "Start" };
        div()
            .size_full()
            .flex()
            .flex_col()
            .items_center()
            .justify_center()
            .gap_4()
            .bg(rgb(0xf7f6f2))
            .text_color(rgb(0x202b29))
            .child(div().text_2xl().child(text!(self.message.clone())))
            .child(
                div()
                    .id("task-action")
                    .role(Role::Button)
                    .aria_label(action)
                    .tab_index(0)
                    .focus_visible(|style| style.ring_2().ring_color(rgb(0x3478c8)))
                    .px_4()
                    .py_2()
                    .rounded_md()
                    .bg(rgb(0x155b50))
                    .text_color(rgb(0xffffff))
                    .cursor_pointer()
                    .child(action)
                    .on_click(cx.listener(|this, _, _, cx| {
                        if this.running {
                            this.stop(cx);
                        } else {
                            this.start(cx);
                        }
                    })),
            )
    }
}

fn component(_window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<AsyncDemo> {
    cx.new(|_cx| AsyncDemo {
        task: None,
        running: false,
        message: "Ready".into(),
    })
}
