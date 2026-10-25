//! Optional native WGPU replay of portable CPU captures.

use crate::{
    DiffMode, NativeCheckpoint, NativeReplayInfo, NativeReplayMetrics, RenderedSuite,
    TimingPercentiles, compare_images,
};
use anyhow::{Context, Result, ensure};
use gpui::PlatformHeadlessRenderer;
use gpui_ce_wgpu::WgpuHeadlessRenderer;

/// Replays every checkpoint on one retained WGPU renderer.
///
/// Atlas upload and scene reconstruction happen before timing samples. Native images are
/// diagnostic; the CPU image and capture remain the portable correctness contract.
pub fn replay_native(suite: &mut RenderedSuite, samples: usize) -> Result<()> {
    ensure!(samples > 0, "native replay sample count must be positive");
    ensure!(
        !suite.scenarios.is_empty(),
        "native replay requires a nonempty suite"
    );

    let mut renderer = WgpuHeadlessRenderer::new_with_measurements()
        .context("initializing the optional headless WGPU renderer")?;
    for scenario in &mut suite.scenarios {
        let size = scenario.viewport.device_size()?;
        for checkpoint in &mut scenario.checkpoints {
            let scene = renderer
                .load_capture(&checkpoint.capture)
                .with_context(|| format!("uploading capture {}/{}", scenario.id, checkpoint.id))?;
            renderer.render_scene_and_wait(&scene, size)?;

            let mut encode_submit_samples = Vec::with_capacity(samples);
            let mut gpu_samples = Vec::with_capacity(samples);
            for _ in 0..samples {
                let measured = renderer
                    .render_scene_measured(&scene, size)
                    .with_context(|| {
                        format!("replaying capture {}/{}", scenario.id, checkpoint.id)
                    })?;
                encode_submit_samples.push(
                    measured
                        .encode_submit_completion
                        .as_nanos()
                        .min(u64::MAX as u128) as u64,
                );
                if let Some(gpu) = measured.gpu_execution {
                    let currently_available = renderer
                        .replay_info()
                        .is_some_and(|info| info.gpu_timestamps_available);
                    ensure!(
                        currently_available,
                        "native renderer returned GPU timing while adapter timestamps are unavailable"
                    );
                    gpu_samples.push(gpu.as_nanos().min(u64::MAX as u128) as u64);
                }
            }

            // Readback is deliberately outside the timing samples.
            let image = renderer
                .render_scene_to_image(&scene, size)
                .with_context(|| {
                    format!("reading native frame {}/{}", scenario.id, checkpoint.id)
                })?;
            let comparison = compare_images(&checkpoint.image, &image, DiffMode::Exact);
            let memory = renderer.owned_memory_usage();
            checkpoint.native = Some(NativeCheckpoint {
                image,
                diff: comparison.image,
                difference: comparison.difference,
                metrics: NativeReplayMetrics {
                    samples,
                    encode_submit_completion: TimingPercentiles::from_samples(
                        encode_submit_samples,
                    ),
                    // A None value means timestamps are unsupported, or this frame had no
                    // GPU work to measure (for example, a clear-only scene).
                    gpu: (!gpu_samples.is_empty())
                        .then(|| TimingPercentiles::from_samples(gpu_samples)),
                    tracked_owned_bytes: memory.measured_owned_bytes,
                    device_allocated_bytes: memory.process_device_memory_bytes,
                    allocation_scope: memory.measured_owned_scope.to_owned(),
                    device_allocation_scope: memory.process_device_memory_source.map(str::to_owned),
                    allocation_reason: memory.process_device_memory_unavailable_reason,
                },
            });
        }
    }

    let final_adapter = renderer
        .replay_info()
        .context("WGPU renderer did not provide final adapter metadata")?;
    if !final_adapter.gpu_timestamps_available {
        // A malformed timestamp read disables the capability on the renderer. Discard
        // earlier timings too, so the report never mixes valid and degraded samples.
        for checkpoint in suite
            .scenarios
            .iter_mut()
            .flat_map(|scenario| &mut scenario.checkpoints)
        {
            if let Some(native) = &mut checkpoint.native {
                native.metrics.gpu = None;
            }
        }
    }
    suite.native_replay = Some(NativeReplayInfo {
        adapter: final_adapter.adapter_name.clone(),
        driver: final_adapter.driver.clone(),
        backend: final_adapter.backend.clone(),
        device_type: final_adapter.device_type.clone(),
        timestamp_reason: final_adapter.gpu_timestamps_unavailable_reason.clone(),
    });
    Ok(())
}
