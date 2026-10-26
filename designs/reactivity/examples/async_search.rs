//! Syntax sketch of `crates/gpui/examples/learn/async_tasks.rs`.
//!
//! Two rungs of the three-rung async ladder (12 §6, 13's cheat sheet):
//!
//!   - `ForegroundTaskDemo` is a user-triggered, one-shot mutation with no stream of events —
//!     rung 2: `self.action(future).queue(Queue::Reliable).then(…)`. No `remote()`, no
//!     `tokio::spawn`, no epoch, no `Task` field: the queued action owns the completion route.
//!   - `BackgroundTaskDemo` genuinely streams events over time (progress, then a result) —
//!     rung 3, the honest protocol floor: raw `tokio::spawn` + `Remote<Self>`, a `Send` route
//!     into a later turn. See `async_workbench.rs`/`workbench.rs` for the first-class
//!     `Reader<T>`/producer-verb path (rung 1's derived reads), which neither demo needs.
//!
//! The owner stores product state — a message, a status enum, a progress `Signal` — never a
//! `Task` field. Progress is a `Signal` so the bar patches without re-describing the demo: the
//! write IS the publish (`*self.progress = p`, no `.set`). Branches are ordinary `if`/`Option`:
//! both arms are the same builder type, so no `.any()`/`.when` is needed.

use gpui::prelude::*;

#[derive(Default)]
struct ForegroundTaskDemo {
    message: String,
    is_loading: bool,
}

impl ForegroundTaskDemo {
    fn start(&mut self) {
        self.is_loading = true;
        self.message = "Loading...".into();
        // A reliable, queued, user-triggered action — not a derived read, not a protocol stream.
        self.action(sleep_ms(1000))
            .queue(Queue::Reliable)
            .then(ForegroundTaskDemo::done);
    }

    fn done(&mut self) {
        self.message = "Task completed!".into();
        self.is_loading = false;
    }
}

impl View for ForegroundTaskDemo {
    fn view(&self) -> El<'_> {
        column((
            text(&self.message), // a string is not a child — text lives in `text(…)` (§2)
            // Ordinary Rust: both arms are the same builder type, so a bare `if` unifies them.
            // If `is_loading` became a `Signal<bool>`, the fix-it would name `.project`.
            if self.is_loading {
                spinner()
            } else {
                button("Start").on_click(ForegroundTaskDemo::start)
            },
        ))
        .gap_2()
        .p_4()
    }
}

#[derive(Default)]
struct BackgroundTaskDemo {
    progress: Signal<u32>, // live port; `.ephemeral()` if the owner is History
    result: Option<u64>,
}

impl BackgroundTaskDemo {
    fn start(&mut self) {
        *self.progress = 0;
        self.result = None;
        let remote = self.remote();
        tokio::spawn(async move {
            // The worker owns its inputs; each event crosses back as one owned message. This is
            // a genuine event stream (many progress ticks, then a result) — the protocol floor,
            // not a candidate for `self.action`'s single completion route.
            let mut events = compute_on_worker();
            while let Some(ev) = events.next().await {
                remote.send(BackgroundTaskDemo::tick.with(ev));
            }
        });
    }

    fn tick(&mut self, ev: WorkerEv) {
        match ev {
            WorkerEv::Progress(p) => *self.progress = p,
            WorkerEv::Done(n) => self.result = Some(n),
        }
    }
}

impl View for BackgroundTaskDemo {
    fn view(&self) -> El<'_> {
        column((
            progress_bar(&self.progress),
            self.result.map(|n| text(format!("result: {n}"))),
            button("Compute").on_click(BackgroundTaskDemo::start),
        ))
        .gap_2()
        .p_4()
    }
}

enum WorkerEv {
    Progress(u32),
    Done(u64),
}

#[derive(Default)]
struct AsyncExamples {
    foreground: ForegroundTaskDemo,
    background: BackgroundTaskDemo,
}

impl View for AsyncExamples {
    fn view(&self) -> El<'_> {
        column((&self.foreground, &self.background))
    }
}

fn main() {
    Application::run(Window::document(AsyncExamples::default()).title("Async"));
}
