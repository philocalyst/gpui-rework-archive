#![cfg(feature = "gpu")]

use anyhow::Result;
use gpui_test::{Harness, RenderedSuite, built_in_scenarios, native::replay_native};

/// Hardware CI opts in to replay every registered capture through the real WGPU renderer.
/// Ordinary CPU-only test runs remain independent of native GPU availability.
#[test]
fn all_gallery_captures_replay_on_native_wgpu_when_required() -> Result<()> {
    if std::env::var("GPUI_REQUIRE_GPU").as_deref() != Ok("1") {
        return Ok(());
    }
    let harness = Harness::new();
    let scenarios = built_in_scenarios()?
        .iter()
        .map(|scenario| scenario.run(&harness))
        .collect::<Result<Vec<_>>>()?;
    let mut suite = RenderedSuite::new(scenarios);
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
            assert_eq!(
                native.metrics.gpu.is_some(),
                adapter.timestamp_reason.is_none(),
                "GPU timing availability must match adapter metadata"
            );
            assert!(native.metrics.tracked_owned_bytes > 0);
            assert!(
                native.metrics.device_allocated_bytes.is_some()
                    || native.metrics.allocation_reason.is_some()
            );
        }
    }
    Ok(())
}
