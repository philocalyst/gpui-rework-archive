#[path = "../support.rs"]
mod support;

// docs:step state | Keep task ownership with the view
// An async operation is part of the view's state. The `Task` field matters: a
// task is cancelled when its handle is dropped, so the view can stop work by
// clearing this field. `running` is presentation state; it lets the render tree
// explain whether a click will start or stop the operation.
//
// The operation below is deliberately small. A real request can replace the
// timer and keep the same ownership shape. There is no blocking call on the
// foreground thread and no second copy of the view state in the future.
// docs:api gpui::Task gpui::Context
// docs:code
use std::time::Duration;
use gpui::{AppContext, Context, IntoElement, Render, Task, Window, div, prelude::*, rgb};

struct AsyncDemo {
    task: Option<Task<()>>,
    running: bool,
    message: String,
}
// docs:end

// docs:step completion | Await background work, then update safely
// `Context::spawn` gives the future a weak handle to this view and an
// `AsyncApp` that can be held across `.await`. The timer runs on the background
// executor, so the UI remains responsive while it waits. When the view is gone,
// `this.update` returns an error and the future ends without reviving it.
//
// `start` replaces an existing task first. Dropping that handle cancels the old
// operation before the new one begins. The completion update calls `notify`,
// because changing a field alone does not schedule a render.
// docs:api gpui::Context::spawn gpui::BackgroundExecutor::timer gpui::WeakEntity::update
// docs:code
impl AsyncDemo {
    fn start(&mut self, cx: &mut Context<Self>) {
        self.task = None;
        self.running = true;
        self.message = "Waiting...".into();
        cx.notify();
        self.task = Some(cx.spawn(async move |this, cx| {
            cx.background_executor()
                .timer(Duration::from_secs(2))
                .await;
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
// docs:end

// docs:step lifetime | Make start, stop, and restart visible
// The buttons expose the task's lifecycle instead of hiding it behind a magic
// callback. While waiting, Stop drops the handle and cancels the timer. Start
// is also a restart: it drops any previous task and starts a fresh delay. After
// completion, Start can be used again. This remains true if the timer later
// becomes a network request or a file operation.
//
// The click listeners use `cx.listener`, which supplies a safe mutable view
// access for the event. Rendering reads ordinary fields; it never waits for the
// task or performs work that could block the foreground executor.
// docs:api gpui::Context::listener gpui::InteractiveElement
// docs:code
impl Render for AsyncDemo {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let action = if self.running { "Stop" } else { "Start" };
        div()
            .size_full().flex().flex_col().items_center().justify_center().gap_4()
            .bg(rgb(0xf7f6f2)).text_color(rgb(0x202b29))
            .child(div().text_2xl().child(self.message.clone()))
            .child(
                div().id("task-action").px_4().py_2().rounded_md()
                    .bg(rgb(0x155b50)).text_color(rgb(0xffffff)).cursor_pointer()
                    .child(action)
                    .on_click(cx.listener(|this, _, _, cx| {
                        if this.running { this.stop(cx); } else { this.start(cx); }
                    })),
            )
    }
}
// docs:end

// docs:step launch | Give the task a real window
// The example's `main` is intentionally ordinary Rust. `support::run` selects
// the native or browser platform, opens a window, and roots the view entity in
// it. The same source therefore demonstrates the lifecycle in the downloadable
// example and in the live browser preview.
//
// There is no detached task here. Keeping the `Task` in `AsyncDemo` makes
// cancellation and restart explicit, and dropping the view also drops the
// task. That ownership rule is the useful part to carry into a larger app.
// docs:api gpui::Render gpui::AppContext::new
// docs:code
pub fn main() {
    support::run(|_window, cx| {
        cx.new(|_cx| AsyncDemo { task: None, running: false, message: "Ready".into() })
    });
}
// docs:end
