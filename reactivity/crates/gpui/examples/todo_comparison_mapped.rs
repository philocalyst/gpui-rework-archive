//! Mapped Todo fixture imported from the sealed 0062bf5898 experiment.
#[path = "support/todo_mapped.rs"]
mod todos;

use gpui::{Application, Remote, RendererPolicy, SendError, Window};
use std::{
    sync::mpsc,
    thread,
    time::{Duration, Instant},
};

struct FrameLog {
    started: Instant,
    samples: Vec<u64>,
    dropped: usize,
    initial_descriptions: Option<(u64, u64)>,
    suppress_first_receipt: bool,
}
impl FrameLog {
    fn presented(&mut self) {
        let elapsed = self.started.elapsed().as_nanos() as u64;
        if self.samples.is_empty() {
            self.initial_descriptions = Some(todos::descriptions());
            if !self.suppress_first_receipt {
                eprintln!("TODO_FIRST_PRESENT,{elapsed}");
            }
        }
        if self.samples.len() < self.samples.capacity() {
            self.samples.push(elapsed);
        } else {
            self.dropped += 1;
        }
    }
}
impl Drop for FrameLog {
    fn drop(&mut self) {
        let (owners, rows) = todos::descriptions();
        eprintln!(
            "TODO_REACTIVITY,{}",
            serde_json::json!({
                "core_pin": option_env!("GPUI_BENCH_SOURCE"), "status":"main-mapped-todo",
                "fixture_origin_core":"0062bf589829c4f28807ad0fde3e13285379294c",
                "mapped_sinks":33, "frame_bytes":std::mem::size_of::<todos::Frame>(),
                "signal_bytes":std::mem::size_of::<gpui::prelude::Signal<todos::Frame>>(),
                "initial_owner_descriptions":self.initial_descriptions.map(|v|v.0),
                "initial_row_descriptions":self.initial_descriptions.map(|v|v.1),
                "final_owner_descriptions":owners, "final_row_descriptions":rows,
                "owner_descriptions_after_first_present":self.initial_descriptions.map(|v|owners-v.0),
                "row_descriptions_after_first_present":self.initial_descriptions.map(|v|rows-v.1),
            })
        );
        eprintln!(
            "TODO_FRAMES,{}",
            serde_json::json!({
                "framework": "gpui", "boundary": "host-submit-ack",
                "elapsed_ns": self.samples, "observer_overflow": self.dropped,
            })
        );
    }
}
fn number<T: std::str::FromStr>(name: &str, fallback: T) -> T {
    std::env::var(name).map_or(fallback, |value| {
        value.parse().unwrap_or_else(|_| panic!("invalid {name}"))
    })
}
fn main() -> Result<(), Box<dyn std::error::Error>> {
    let started = Instant::now();
    let mode = std::env::var("TODO_BENCH_MODE").unwrap_or_else(|_| "idle".into());
    assert!(matches!(
        mode.as_str(),
        "idle" | "busy" | "heavy" | "animation"
    ));
    let animate = number("TODO_BENCH_ANIMATE", u8::from(mode == "animation")) != 0;
    let rows = number(
        "TODO_BENCH_ROWS",
        match mode.as_str() {
            "heavy" => 10_000,
            "animation" => 1_000,
            _ => 0,
        },
    );
    let hz: u32 = number("TODO_BENCH_TICK_HZ", 60);
    let seconds: u64 = number("TODO_BENCH_SECONDS", 30);
    assert!((1..=240).contains(&hz) && (1..=3600).contains(&seconds));
    let renderer = match std::env::var("TODO_BENCH_RENDERER").as_deref() {
        Ok("cpu") => RendererPolicy::ReferenceCpu,
        Ok("auto") => RendererPolicy::Auto,
        Ok("gpu") | Err(_) => RendererPolicy::Gpu,
        _ => panic!("expected TODO_BENCH_RENDERER=gpu|cpu|auto"),
    };
    let mut frames = FrameLog {
        started,
        samples: Vec::with_capacity(if std::env::var_os("TODO_TEST_OBSERVER_CAP").is_some() {
            1
        } else {
            (seconds as usize + 10) * hz as usize * 2
        }),
        dropped: 0,
        initial_descriptions: None,
        suppress_first_receipt: std::env::var_os("TODO_TEST_SUPPRESS_FIRST_RECEIPT").is_some(),
    };
    // Idle creates no worker or message lane. Animation edits one direct Frame
    // source; its 33 mapped property sinks patch without describing the owner.
    let (mut start, ready) = if animate {
        let (sender, receiver) = mpsc::sync_channel::<()>(1);
        (Some(sender), Some(receiver))
    } else {
        (None, None)
    };
    let window = Window::document(todos::Todos::seeded(rows, true))
        .title("GPUI Todo comparison")
        .size(540, 620)
        .renderer(renderer)
        .on_presented(move |frame| {
            if frames.samples.is_empty() {
                eprintln!("TODO_RENDERER,{:?}", frame.renderer);
            }
            frames.presented();
            if let Some(start) = start.take() {
                let _ = start.try_send(());
            }
        });
    if animate {
        let (remote, inbox) = Remote::<u64>::bounded(1);
        let worker = thread::Builder::new()
            .name("todo-animation".into())
            .spawn(move || {
                if ready.expect("animation start receiver").recv().is_err() {
                    return;
                }
                let epoch = Instant::now();
                let mut tick = 1u64;
                let mut delivered = 0;
                let mut skipped = 0;
                while tick <= seconds * u64::from(hz) {
                    let deadline = epoch + Duration::from_secs_f64(tick as f64 / f64::from(hz));
                    thread::sleep(deadline.saturating_duration_since(Instant::now()));
                    match remote.try_send(tick) {
                        Ok(()) => delivered += 1,
                        Err(SendError::Full(_)) => skipped += 1,
                        Err(SendError::Closed(_)) => break,
                    }
                    let next = (epoch.elapsed().as_secs_f64() * f64::from(hz)) as u64 + 1;
                    skipped += next.saturating_sub(tick + 1);
                    tick = next.max(tick + 1);
                }
                eprintln!(
                    "TODO_ANIMATION,{}",
                    serde_json::json!({
                        "scheduled": seconds * u64::from(hz), "enqueued": delivered,
                        "skipped": skipped, "hz": hz,
                    })
                );
            })?;
        let duplicate = std::env::var_os("TODO_TEST_DUPLICATE_TICKS").is_some();
        let result = Application::run_window(window.with_inbox_for(
            inbox,
            todos::Todos::FRAME,
            move |frame, tick| {
                frame.tick(tick, hz, duplicate);
            },
        ));
        worker.join().map_err(|_| "animation worker panicked")?;
        result?;
    } else {
        drop(ready);
        Application::run_window(window)?;
    }
    Ok(())
}
