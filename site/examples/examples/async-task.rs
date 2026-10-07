#[path = "../src/support.rs"]
mod support;

// ## Let the view own the operation {#state}
// Start waits two seconds, then displays Complete. Stop cancels that wait.
// The view stores the returned [`Task`] because the operation belongs to this
// view. Clearing the field drops the handle and cancels its remaining polling;
// releasing the view drops the field as well. Dropping a task is local
// cancellation, not rollback of work already accepted elsewhere.
//
// `running` chooses the button label, and `message` supplies the displayed
// status. Both are ordinary state updated through the view's [`Context`].

use gpui::{AppContext, Context, IntoElement, Render, Task, Window, div, prelude::*, rgb};
use std::time::Duration;

struct AsyncDemo {
    task: Option<Task<()>>,
    running: bool,
    message: String,
}

// ## Wait, then reacquire the view {#completion}
// [`Context::spawn`] runs a foreground future and gives it a weak handle to the
// view. The [`BackgroundExecutor::timer`] yields while the two seconds pass;
// it does not block the input callback or hold a mutable view borrow. After
// the wait, [`WeakEntity::update`] reacquires the live view to change its
// status. If the view was released meanwhile, the update fails and there is no
// UI state left to change.
//
// Starting notifies immediately so “Waiting...” appears before the timer
// completes. Completion obtains a fresh mutable borrow only inside `update`,
// then notifies again. Never carry a `Context` or entity borrow across `.await`.

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

// ## Expose Start and Stop {#lifetime}
// [`Context::listener`] gives the click handler access to the view. While
// waiting, the button calls `stop`, which drops the task and displays Stopped.
// Another Start begins a new two-second wait. Completion returns the button
// to Start. Observe that the status changes immediately on Stop and remains
// Stopped after the old deadline; this distinguishes task cancellation from
// merely hiding the pending result.
//
// > [!WARNING]
// > Dropping a task stops its remaining polling. It does not undo an operation
// > already accepted by another service. A network request may still complete
// > on the server even after the local task is cancelled.

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
            .child(div().text_2xl().child(self.message.clone()))
            .child(
                div()
                    .id("task-action")
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

// ## Try stopping before completion {#launch}
// Click Start, wait less than two seconds, then click Stop. The status stays
// Stopped after the original delay would have elapsed. Start again and let it
// finish. The view and its task are created under [`AppContext::new`]; no task
// is detached from that owner.

fn component(_window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<AsyncDemo> {
    cx.new(|_cx| AsyncDemo {
        task: None,
        running: false,
        message: "Ready".into(),
    })
}

pub fn main() {
    support::run(component);
}
