//! Repeatable CPU workload for retained view rendering.
//!
//! The same file is copied into the c6b17e baseline checkout so its natural-notify timings use
//! the identical fixture and sample loop.

use crate::{
    AppContext, Context, Entity, IntoElement, Render, TestAppContext, Window, WindowHandle, div,
    prelude::*, px, size,
};
use std::{
    sync::{
        Arc,
        atomic::{AtomicUsize, Ordering},
    },
    time::{Duration, Instant},
};

struct WorkloadPanel {
    index: usize,
    value: usize,
    render_count: Arc<AtomicUsize>,
}

impl Render for WorkloadPanel {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        self.render_count.fetch_add(1, Ordering::Relaxed);
        div()
            .id(format!("workload-panel-{}", self.index))
            .size_full()
            .children((0..64).map(|label| {
                div().h(px(11.)).child(format!(
                    "panel {} value {} label {label}",
                    self.index, self.value
                ))
            }))
    }
}

struct WorkloadRoot {
    panels: Vec<Entity<WorkloadPanel>>,
}

impl Render for WorkloadRoot {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .id("workload-root")
            .size_full()
            .flex()
            .flex_col()
            .overflow_y_scroll()
            .children(self.panels.iter().map(|panel| {
                div()
                    .w_full()
                    .h(px(76.))
                    .overflow_hidden()
                    .child(panel.clone())
            }))
    }
}

fn workload_harness(
    cx: &mut TestAppContext,
) -> (WindowHandle<WorkloadRoot>, Vec<Arc<AtomicUsize>>) {
    let counts = (0..60)
        .map(|_| Arc::new(AtomicUsize::new(0)))
        .collect::<Vec<_>>();
    let window = cx.open_window(size(px(800.), px(900.)), {
        let counts = counts.clone();
        move |_, cx| WorkloadRoot {
            panels: (0..60)
                .map(|index| {
                    let render_count = counts[index].clone();
                    cx.new(|_| WorkloadPanel {
                        index,
                        value: 0,
                        render_count,
                    })
                })
                .collect(),
        }
    });
    cx.run_until_parked();
    (window, counts)
}

#[derive(Clone, Copy)]
enum WorkloadChange {
    Clean,
    OneDirty,
    AllDirty,
}

fn run_workload_sample(
    window: &WindowHandle<WorkloadRoot>,
    cx: &mut TestAppContext,
    change: WorkloadChange,
    force_refresh: bool,
) -> Duration {
    let start = Instant::now();
    match change {
        WorkloadChange::Clean => {
            window.update(cx, |_root, _, cx| cx.notify()).unwrap();
        }
        WorkloadChange::OneDirty => {
            window
                .update(cx, |root, _, cx| {
                    root.panels[17].update(cx, |panel, cx| {
                        panel.value += 1;
                        cx.notify();
                    });
                })
                .unwrap();
        }
        WorkloadChange::AllDirty => {
            window
                .update(cx, |root, _, cx| {
                    for panel in &root.panels {
                        panel.update(cx, |panel, cx| {
                            panel.value += 1;
                            cx.notify();
                        });
                    }
                })
                .unwrap();
        }
    }
    if force_refresh {
        window.update(cx, |_, window, _| window.refresh()).unwrap();
    }
    cx.run_until_parked();
    start.elapsed()
}

fn print_workload_samples(label: &str, samples: &[Duration]) {
    let mut milliseconds = samples
        .iter()
        .map(Duration::as_secs_f64)
        .map(|seconds| seconds * 1000.0)
        .collect::<Vec<_>>();
    milliseconds.sort_by(f64::total_cmp);
    let mean = milliseconds.iter().sum::<f64>() / milliseconds.len() as f64;
    let median = milliseconds[milliseconds.len() / 2];
    println!("retained-workload {label}: mean={mean:.3}ms median={median:.3}ms");
}

fn total_panel_renders(counts: &[Arc<AtomicUsize>]) -> usize {
    counts
        .iter()
        .map(|count| count.load(Ordering::Relaxed))
        .sum()
}

/// Run manually with `GPUI_BENCH_NATURAL_ONLY=1 CARGO_TARGET_DIR=/tmp/gpui-ce-retention-view-target cargo test -p gpui-ce --no-default-features --lib retention_workload::retained_rendering_cpu_workload -- --ignored --nocapture`.
/// Unset `GPUI_BENCH_NATURAL_ONLY` to also measure a forced-full-refresh comparison. Timings are
/// reported without thresholds; render counts remain the deterministic work oracle.
#[gpui::test]
#[ignore = "manual CPU workload benchmark"]
fn retained_rendering_cpu_workload(cx: &mut TestAppContext) {
    if std::env::var_os("FOOTPRINT_ONLY").is_some() {
        for (name, bytes) in crate::view::retained_type_footprint() {
            println!("retained-type-footprint {name}: {bytes} bytes");
        }
        return;
    }

    for change in [
        WorkloadChange::Clean,
        WorkloadChange::OneDirty,
        WorkloadChange::AllDirty,
    ] {
        for forced in [false, true] {
            if forced && std::env::var_os("GPUI_BENCH_NATURAL_ONLY").is_some() {
                continue;
            }
            let (window, render_counts) = workload_harness(cx);
            for _ in 0..20 {
                let _ = run_workload_sample(&window, cx, change, forced);
            }
            let samples = (0..40)
                .map(|_| run_workload_sample(&window, cx, change, forced))
                .collect::<Vec<_>>();
            let label = match (change, forced) {
                (WorkloadChange::Clean, false) => "clean-natural",
                (WorkloadChange::Clean, true) => "clean-plus-full-refresh",
                (WorkloadChange::OneDirty, false) => "one-dirty-natural",
                (WorkloadChange::OneDirty, true) => "one-dirty-plus-full-refresh",
                (WorkloadChange::AllDirty, false) => "all-dirty-natural",
                (WorkloadChange::AllDirty, true) => "all-dirty-plus-full-refresh",
            };
            print_workload_samples(label, &samples);
            println!(
                "retained-workload {label}: total panel renders={}",
                total_panel_renders(&render_counts)
            );
        }
    }
}
