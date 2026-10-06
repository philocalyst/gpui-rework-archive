//! A cancellable foreground task awaiting deterministic background work.

use gpui::{Context, Render, Task, Window, div, prelude::*, rgb};
use std::time::Duration;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum TaskState {
    Pending,
    Running,
    Cancelled,
    Completed(u32),
}

pub struct AsyncTaskScenario {
    state: TaskState,
    task: Option<Task<()>>,
}

impl Default for AsyncTaskScenario {
    fn default() -> Self {
        Self::new()
    }
}

impl AsyncTaskScenario {
    pub fn new() -> Self {
        Self {
            state: TaskState::Pending,
            task: None,
        }
    }

    pub fn state(&self) -> TaskState {
        self.state
    }

    fn start(&mut self, cx: &mut Context<Self>) {
        self.state = TaskState::Running;
        cx.notify();

        let executor = cx.background_executor().clone();
        self.task = Some(cx.spawn(async move |this, cx| {
            let result = cx
                .background_spawn(async move {
                    executor.timer(Duration::from_millis(250)).await;
                    42
                })
                .await;

            this.update(cx, |this, cx| {
                this.state = TaskState::Completed(result);
                cx.notify();
            })
            .ok();
        }));
    }

    fn cancel(&mut self, cx: &mut Context<Self>) {
        self.task = None;
        self.state = TaskState::Cancelled;
        cx.notify();
    }
}

impl Render for AsyncTaskScenario {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let (label, color) = match self.state {
            TaskState::Pending => ("Ready", rgb(0x64748b)),
            TaskState::Running => ("Waiting for background result…", rgb(0x2563eb)),
            TaskState::Cancelled => ("Cancelled", rgb(0xdc2626)),
            TaskState::Completed(_) => ("Completed", rgb(0x15803d)),
        };
        let running = self.state == TaskState::Running;
        div()
            .id("async-task-scenario")
            .size_full()
            .flex()
            .flex_col()
            .items_start()
            .gap_3()
            .p_5()
            .bg(rgb(0xf8fafc))
            .child(
                div()
                    .text_xl()
                    .font_weight(gpui::FontWeight::BOLD)
                    .child("Async task"),
            )
            .child(div().text_color(color).child(match self.state {
                TaskState::Completed(value) => format!("{label}: {value}"),
                _ => label.to_string(),
            }))
            .child(
                div()
                    .id("async-task-action")
                    .debug_selector(|| "async-task-action".into())
                    .px_3()
                    .py_2()
                    .rounded_md()
                    .bg(if running {
                        rgb(0xfee2e2)
                    } else {
                        rgb(0xdbeafe)
                    })
                    .cursor_pointer()
                    .child(if running { "Cancel task" } else { "Start task" })
                    .on_click(cx.listener(|this, _, _, cx| {
                        if this.state == TaskState::Running {
                            this.cancel(cx);
                        } else {
                            this.start(cx);
                        }
                    })),
            )
    }
}
