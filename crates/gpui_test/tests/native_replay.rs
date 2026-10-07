#![cfg(feature = "gpu")]

use anyhow::Result;
use gpui::{App, AppContext as _, Context, Render, Window, div, px, size};
use gpui_test::{Harness, RenderedSuite, Scenario, built_in_scenarios, native::replay_native};
use std::time::Duration;

struct EmptyView;

impl Render for EmptyView {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl gpui::IntoElement {
        div()
    }
}

fn empty_scenario() -> Result<Scenario<EmptyView>> {
    Scenario::new(
        "native-empty-scene",
        "Clear-only scene",
        size(px(64.), px(48.)),
        |_, cx: &mut App| cx.new(|_| EmptyView),
    )?
    .checkpoint("clear", "Clear", Duration::ZERO)
}

/// Hardware CI opts in to replay every registered capture through the real WGPU renderer.
/// Ordinary CPU-only test runs remain independent of native GPU availability.
#[test]
fn all_gallery_captures_replay_on_native_wgpu_when_required() -> Result<()> {
    if std::env::var("GPUI_REQUIRE_GPU").as_deref() != Ok("1") {
        return Ok(());
    }
    let harness = Harness::new();
    let mut suite = harness.run_all(&built_in_scenarios()?)?;
    replay_native(&mut suite, 1)?;
    let adapter = suite
        .native_replay
        .as_ref()
        .expect("adapter metadata was not captured");
    for scenario in &suite.scenarios {
        for checkpoint in &scenario.checkpoints {
            let native = checkpoint.native.as_ref().expect("native replay result");
            assert_eq!(native.image.dimensions(), checkpoint.image.dimensions());
            assert_eq!(native.diff.dimensions(), checkpoint.image.dimensions());
            assert_eq!(
                native.difference.total_pixels,
                u64::from(native.image.width()) * u64::from(native.image.height())
            );
            assert_eq!(native.metrics.samples, 1);
            assert!(native.metrics.encode_submit_completion.p50_ns > 0);
            if adapter.timestamp_reason.is_some() {
                assert!(native.metrics.gpu.is_none());
            }
            if scenario.id == "text-mixed-script" && checkpoint.id == "default" {
                assert!(
                    native.image.pixels().any(|pixel| pixel[3] > 0),
                    "native replay must still produce text pixels if timing telemetry degrades"
                );
            }
            assert!(native.metrics.tracked_owned_bytes > 0);
            assert!(
                native.metrics.device_allocated_bytes.is_some()
                    || native.metrics.allocation_reason.is_some()
            );
        }
    }

    Ok(())
}

#[test]
fn clear_only_capture_has_no_gpu_duration_when_required() -> Result<()> {
    if std::env::var("GPUI_REQUIRE_GPU").as_deref() != Ok("1") {
        return Ok(());
    }
    // This is a real GPUI capture; it should not invent GPU timing for a clear-only frame.
    let mut empty_suite = RenderedSuite::new(vec![Harness::new().run(&empty_scenario()?)?]);
    replay_native(&mut empty_suite, 2)?;
    assert!(
        empty_suite.scenarios[0].checkpoints[0]
            .native
            .as_ref()
            .expect("native replay result")
            .metrics
            .gpu
            .is_none()
    );
    Ok(())
}
