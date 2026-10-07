use super::{ReportManifest, ReportStatus};
use anyhow::Result;
use plotters::prelude::*;
use std::{fs, path::Path};

pub(super) fn write_markdown(manifest: &ReportManifest, output_dir: &Path) -> Result<()> {
    let mut md = String::from("# GPUI scenario report\n\n");
    if !manifest.scenarios.is_empty() {
        md.push_str("Timings follow one warm-up frame. CPU replay reuses its target and excludes font setup, RGBA readback, capture serialization, and PNG encoding. Bitmap bytes measure captured atlas storage.\n\n| Scenario / checkpoint | Time (ms) | Samples | Build p50/p95/p99 (ms) | CPU p50/p95/p99 (ms) | Primitives | Batches | Bitmap bytes | Status |\n|---|---:|---:|---:|---:|---:|---:|---:|---|\n");
        for scenario in &manifest.scenarios {
            for checkpoint in &scenario.checkpoints {
                let m = &checkpoint.metrics;
                let title = format!("{} / {}", scenario.title, checkpoint.name)
                    .replace('|', "\\|")
                    .replace(['\n', '\r'], " ");
                md.push_str(&format!(
                    "| [{title}]({}) | {:.3} | {} | {} | {} | {} | {} | {} | {} |\n",
                    checkpoint.png,
                    checkpoint.time_ns as f64 / 1_000_000.0,
                    m.frame_count,
                    timing_triplet(
                        m.scene_build_p50_ns,
                        m.scene_build_p95_ns,
                        m.scene_build_p99_ns
                    ),
                    timing_triplet(
                        m.cpu_render_p50_ns,
                        m.cpu_render_p95_ns,
                        m.cpu_render_p99_ns
                    ),
                    m.primitive_count,
                    m.batch_count,
                    m.bitmap_storage_bytes,
                    status_name(checkpoint.status),
                ));
            }
        }
        md.push_str("\n![Frame timings](metrics.svg)\n\n## Baseline changes\n\n");
        if !manifest.changes.is_empty() {
            for change in &manifest.changes {
                md.push_str(&format!("- {change}\n"));
            }
        } else if manifest
            .scenarios
            .iter()
            .all(|scenario| scenario.status == ReportStatus::BaselineUnavailable)
        {
            md.push_str("No baseline was supplied.\n");
        } else {
            md.push_str("No scenario or checkpoint changes.\n");
        }
    }
    let visual_changes: Vec<_> = manifest
        .scenarios
        .iter()
        .flat_map(|scenario| {
            scenario
                .checkpoints
                .iter()
                .filter(|checkpoint| {
                    checkpoint.difference.is_some()
                        || checkpoint
                            .motion
                            .as_ref()
                            .is_some_and(|motion| motion.difference.changed_pixels > 0)
                })
                .map(move |checkpoint| (scenario, checkpoint))
        })
        .collect();
    if !visual_changes.is_empty() {
        md.push_str("\n## Image and transition differences\n\nExact RGBA errors include transparent extent changes. Visible errors use premultiplied color and alpha. Transition errors compare signed frame deltas, including extent, between adjacent matched checkpoints.\n\n| Checkpoint | Exact pixels | Visible pixels | Transition pixels | Baseline/current interval (ms) | Exact bounds |\n|---|---:|---:|---:|---:|---|\n");
        for (scenario, checkpoint) in visual_changes {
            let difference = checkpoint.difference.as_ref();
            let exact = difference
                .map(|d| pixel_change(d.changed_pixels, d.total_pixels))
                .unwrap_or_else(|| {
                    if checkpoint.pixels_changed == Some(false) {
                        "0".into()
                    } else {
                        "n/a".into()
                    }
                });
            let visible = difference
                .and_then(|d| {
                    d.visible
                        .as_ref()
                        .map(|v| pixel_change(v.changed_pixels, d.total_pixels))
                })
                .unwrap_or_else(|| "n/a".into());
            let motion = checkpoint.motion.as_ref();
            let transition = motion
                .map(|m| pixel_change(m.difference.changed_pixels, m.difference.total_pixels))
                .unwrap_or_else(|| "n/a".into());
            let interval = motion
                .map(|m| {
                    format!(
                        "{} / {}",
                        optional_ms(m.before_duration_ns),
                        optional_ms(m.current_duration_ns)
                    )
                })
                .unwrap_or_else(|| "n/a".into());
            let bounds = difference
                .and_then(|d| d.bounds)
                .map(|b| format!("{},{} {}×{}", b.x, b.y, b.width, b.height))
                .unwrap_or_else(|| "none".into());
            md.push_str(&format!("| [{} / {}](index.html#{}%2F{}) | {exact} | {visible} | {transition} | {interval} | {bounds} |\n", scenario.id, checkpoint.id, scenario.id, checkpoint.id));
        }
    }
    if let Some(adapter) = &manifest.native_replay {
        md.push_str(&format!(
            "\n## Native replay\n\nAdapter: {} ({}; {}; {}).\n\n",
            adapter.adapter, adapter.backend, adapter.device_type, adapter.driver
        ));
        md.push_str("Encode/submit/completion latency covers CPU frame preparation through queue completion. Target creation, timestamp mapping, and pixel readback are excluded. GPU latency is the device timestamp interval.\n\n");
        if let Some(reason) = &adapter.timestamp_reason {
            md.push_str(&format!("GPU timestamps unavailable: {reason}\n\n"));
        }
        if let Some(native) = manifest
            .scenarios
            .iter()
            .flat_map(|scenario| &scenario.checkpoints)
            .find_map(|checkpoint| checkpoint.native.as_ref())
        {
            let m = &native.metrics;
            md.push_str(&format!(
                "Tracked allocation scope: {}.\n\nDevice allocation: {}.\n\n",
                m.allocation_scope,
                m.device_allocation_scope
                    .as_deref()
                    .or(m.allocation_reason.as_deref())
                    .unwrap_or("unavailable")
            ));
        }
        md.push_str("| Scenario / checkpoint | Samples | Encode/submit/completion p50/p95/p99 (ms) | GPU p50/p95/p99 (ms) | Tracked bytes | Device allocated bytes | CPU vs native pixels | Max / mean channel error |\n|---|---:|---:|---:|---:|---:|---:|---:|\n");
        for scenario in &manifest.scenarios {
            for checkpoint in &scenario.checkpoints {
                let Some(native) = &checkpoint.native else {
                    continue;
                };
                let m = &native.metrics;
                let d = &native.difference;
                let gpu = m
                    .gpu
                    .as_ref()
                    .map(|p| timing_triplet(p.p50_ns, p.p95_ns, p.p99_ns))
                    .unwrap_or_else(|| "n/a".into());
                let device = m
                    .device_allocated_bytes
                    .map_or_else(|| "n/a".into(), |bytes| bytes.to_string());
                md.push_str(&format!(
                    "| [{} / {}]({}) | {} | {} | {} | {} | {} | [{}/{}]({}) | {} / {:.3} |\n",
                    scenario.id,
                    checkpoint.id,
                    native.png,
                    m.samples,
                    timing_triplet(
                        m.encode_submit_completion.p50_ns,
                        m.encode_submit_completion.p95_ns,
                        m.encode_submit_completion.p99_ns
                    ),
                    gpu,
                    m.tracked_owned_bytes,
                    device,
                    d.changed_pixels,
                    d.total_pixels,
                    native.diff_png,
                    d.max_channel_error,
                    d.mean_channel_error,
                ));
            }
        }
    }
    if let Some(checks) = &manifest.platform_checks {
        md.push_str(&format!("\n## Native platform checks\n\nPlatform: {} · Status: {}\n\n| Capability | Available |\n|---|---|\n", checks.platform, checks.status));
        for (name, available) in &checks.capabilities {
            md.push_str(&format!("| {name} | {available} |\n"));
        }
        md.push_str("\n| Lifecycle event | Polls | Elapsed (ms) |\n|---|---:|---:|\n");
        for event in &checks.events {
            md.push_str(&format!(
                "| {} | {} | {} |\n",
                event.name, event.polls, event.elapsed_ms
            ));
        }
        if manifest.scenarios.is_empty() {
            md.push_str("\n![Lifecycle latency](metrics.svg)\n");
        }
        if let Some(frame) = &checks.frame {
            md.push_str(&format!("\nCaptured frame: {}×{}, {} paints, {} quads, {} monochrome sprites, {} subpixel sprites, {} polychrome sprites, {} painted pixels.\n",
                frame.capture_width, frame.capture_height, frame.render_count, frame.quads, frame.monochrome_sprites, frame.subpixel_sprites, frame.polychrome_sprites, frame.painted_pixels));
        }
        if let Some(resize) = &checks.resize {
            md.push_str(&format!(
                "Resize callback: {} events at {}×{} logical pixels.\n",
                resize.callback_count, resize.width, resize.height
            ));
        }
        for error in &checks.errors {
            md.push_str(&format!("\n- Platform error: {error}\n"));
        }
    }
    fs::write(output_dir.join("report.md"), md)?;
    Ok(())
}

fn timing_triplet(p50: u64, p95: u64, p99: u64) -> String {
    format!(
        "{:.3} / {:.3} / {:.3}",
        p50 as f64 / 1_000_000.0,
        p95 as f64 / 1_000_000.0,
        p99 as f64 / 1_000_000.0
    )
}

fn pixel_change(changed: u64, total: u64) -> String {
    let percent = if total == 0 {
        0.0
    } else {
        changed as f64 * 100.0 / total as f64
    };
    format!("{changed} ({percent:.3}%)")
}

fn optional_ms(ns: Option<u64>) -> String {
    ns.map(|ns| format!("{:.3}", ns as f64 / 1_000_000.0))
        .unwrap_or_else(|| "n/a".into())
}

pub(super) fn write_svg(manifest: &ReportManifest, output_dir: &Path) -> Result<()> {
    let platform_only = manifest.scenarios.is_empty() && manifest.platform_checks.is_some();
    let mut values: Vec<_> = manifest
        .scenarios
        .iter()
        .flat_map(|scenario| {
            scenario.checkpoints.iter().map(move |checkpoint| {
                (
                    format!("{} / {}", scenario.id, checkpoint.id),
                    [
                        Some(checkpoint.metrics.scene_build_p50_ns),
                        Some(checkpoint.metrics.cpu_render_p50_ns),
                        checkpoint
                            .native
                            .as_ref()
                            .map(|native| native.metrics.encode_submit_completion.p50_ns),
                        checkpoint
                            .native
                            .as_ref()
                            .and_then(|native| native.metrics.gpu.as_ref())
                            .map(|gpu| gpu.p50_ns),
                    ],
                )
            })
        })
        .collect();
    let frame_bars = [
        ("Scene build", BLUE.mix(0.75)),
        ("CPU replay", RED.mix(0.7)),
        ("Native encode/submit/completion", GREEN.mix(0.75)),
        ("GPU execution", MAGENTA.mix(0.75)),
    ];
    let platform_bars = [("Lifecycle latency", BLUE.mix(0.75))];
    let bars = if platform_only {
        if let Some(checks) = &manifest.platform_checks {
            values = checks
                .events
                .iter()
                .map(|event| {
                    let ns = u64::try_from(event.elapsed_ms.saturating_mul(1_000_000))
                        .unwrap_or(u64::MAX);
                    (event.name.clone(), [Some(ns), None, None, None])
                })
                .collect();
        }
        &platform_bars[..]
    } else {
        let count = values
            .iter()
            .flat_map(|(_, timings)| timings.iter().enumerate())
            .filter_map(|(index, value)| value.map(|_| index + 1))
            .max()
            .unwrap_or(2);
        &frame_bars[..count]
    };
    let bars_per_row = bars.len();
    let path = output_dir.join("metrics.svg");
    let height = 140 + values.len().max(1) as u32 * 54;
    let root = SVGBackend::new(&path, (1100, height)).into_drawing_area();
    root.fill(&WHITE).map_err(plot_err)?;
    let max = values
        .iter()
        .flat_map(|(_, timings)| timings.iter().flatten().copied())
        .max()
        .unwrap_or(1)
        .max(1);
    let rows = values.len().max(1) * bars_per_row;
    let mut chart = ChartBuilder::on(&root)
        .caption(
            if platform_only {
                "Native lifecycle latency"
            } else {
                "Median frame work by checkpoint"
            },
            ("sans-serif", 24),
        )
        .margin(18)
        .x_label_area_size(48)
        .y_label_area_size(300)
        .build_cartesian_2d(
            0u64..max.saturating_add(max / 10 + 1),
            (0usize..rows).with_key_points(
                (0..values.len())
                    .map(|index| index * bars_per_row + bars_per_row / 2)
                    .collect(),
            ),
        )
        .map_err(plot_err)?;
    chart
        .configure_mesh()
        .y_labels(values.len())
        .y_label_formatter(&|index| {
            values
                .get(*index / bars_per_row)
                .map(|value| value.0.clone())
                .unwrap_or_default()
        })
        .x_desc("milliseconds")
        .x_label_formatter(&|ns| format!("{:.1}", *ns as f64 / 1_000_000.0))
        .disable_mesh()
        .draw()
        .map_err(plot_err)?;
    let mut legend_added = [false; 4];
    for (index, (_, timings)) in values.iter().enumerate() {
        for (bar_index, ((label, color), value)) in bars.iter().zip(timings).enumerate() {
            let Some(value) = value else {
                continue;
            };
            let row = index * bars_per_row + bar_index;
            let series = chart
                .draw_series(std::iter::once(Rectangle::new(
                    [(0, row), (*value, row + 1)],
                    color.filled(),
                )))
                .map_err(plot_err)?;
            if !legend_added[bar_index] {
                legend_added[bar_index] = true;
                let color = *color;
                series.label(*label).legend(move |(x, y)| {
                    Rectangle::new([(x, y - 4), (x + 16, y + 4)], color.filled())
                });
            }
        }
    }
    chart
        .configure_series_labels()
        .background_style(WHITE.mix(0.9))
        .border_style(BLACK)
        .draw()
        .map_err(plot_err)?;
    root.present().map_err(plot_err)?;
    Ok(())
}

pub(super) fn write_html(manifest: &ReportManifest, output_dir: &Path) -> Result<()> {
    let template = include_str!("../../assets/report/index.html");
    let style = include_str!("../../assets/report/viewer.css");
    let script = include_str!("../../assets/report/viewer.js");
    let data = serde_json::to_string(manifest)?.replace('<', "\\u003c");
    let html = template
        .replace("{{STYLE}}", style)
        .replace("{{SCRIPT}}", script)
        .replace("{{DATA}}", &data);
    fs::write(output_dir.join("index.html"), html)?;
    // Keep the inline page usable from disk, and expose the same module for website imports.
    fs::write(output_dir.join("viewer.js"), script)?;
    fs::write(output_dir.join("viewer.css"), style)?;
    Ok(())
}

fn status_name(status: ReportStatus) -> &'static str {
    match status {
        ReportStatus::BaselineUnavailable => "baseline unavailable",
        ReportStatus::New => "new",
        ReportStatus::Unchanged => "unchanged",
        ReportStatus::Changed => "changed",
    }
}

fn plot_err<E: std::fmt::Debug>(error: E) -> anyhow::Error {
    anyhow::anyhow!("plot error: {error:?}")
}
