use crate::{Scenario, bundled_text_system};
use anyhow::{Context, Result, ensure};
use gpui::{
    AssetSource, DevicePixels, HeadlessAppContext, PlatformAtlas, PlatformHeadlessRenderer,
    PlatformTextSystem, Render, Size,
};
use gpui_ce_render::cpu::{CpuAtlas, CpuRenderer};
use std::{
    sync::{Arc, OnceLock},
    time::{Duration, Instant},
};

/// A rendered suite kept in memory until callers choose to persist a report.
#[derive(Clone, Debug)]
pub struct RenderedSuite {
    /// Captured scenarios, in caller-provided order.
    pub scenarios: Vec<RenderedScenario>,
    /// Native replay metadata, present only when an optional WGPU pass was requested.
    pub native_replay: Option<NativeReplayInfo>,
    /// Optional OS-backed lifecycle diagnostics.
    pub platform_checks: Option<gpui::WindowCheckReport>,
}

impl RenderedSuite {
    /// Creates a portable CPU-rendered suite without optional backend results.
    pub fn new(scenarios: Vec<RenderedScenario>) -> Self {
        Self {
            scenarios,
            native_replay: None,
            platform_checks: None,
        }
    }

    /// Adds a platform probe result to the report.
    pub fn with_platform_checks(mut self, checks: gpui::WindowCheckReport) -> Self {
        self.platform_checks = Some(checks);
        self
    }
}

/// Captures from one scenario and its viewport.
#[derive(Clone, Debug)]
pub struct RenderedScenario {
    /// Stable ID used in artifact paths.
    pub id: String,
    /// Human-readable title.
    pub title: String,
    /// Viewport associated with this scenario.
    pub viewport: Viewport,
    /// Font pack used to shape this scenario. Caller-supplied systems default to `custom`.
    pub font_pack: String,
    /// Per-checkpoint captures in timeline order.
    pub checkpoints: Vec<RenderedCheckpoint>,
}

/// Viewport metadata in physical-independent logical pixels.
#[derive(Clone, Debug, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct Viewport {
    /// Logical width.
    pub width: f32,
    /// Logical height.
    pub height: f32,
    /// Device scale factor used to build and capture the window.
    pub scale_factor: f32,
}

impl Viewport {
    /// Converts logical viewport dimensions to checked physical device pixels.
    pub fn device_size(&self) -> Result<Size<DevicePixels>> {
        ensure!(
            self.width.is_finite()
                && self.height.is_finite()
                && self.width > 0.0
                && self.height > 0.0
                && self.scale_factor.is_finite()
                && self.scale_factor > 0.0,
            "viewport dimensions and scale factor must be finite and positive"
        );
        let dimension = |logical: f32| -> Result<DevicePixels> {
            let physical = (logical * self.scale_factor).ceil();
            ensure!(
                physical.is_finite() && physical as f64 <= i32::MAX as f64,
                "physical viewport exceeds scene coordinate limits"
            );
            Ok(DevicePixels(physical as i32))
        };
        Ok(Size {
            width: dimension(self.width)?,
            height: dimension(self.height)?,
        })
    }
}

/// One portable display list, image, and timing sample set.
#[derive(Clone, Debug)]
pub struct RenderedCheckpoint {
    /// Stable ID used in artifact paths.
    pub id: String,
    /// Human-readable checkpoint label.
    pub name: String,
    /// Absolute simulated time from the start of the scenario.
    pub time_ns: u64,
    /// Versioned renderer-neutral display-list capture.
    pub capture: gpui::SceneCapture,
    /// Deterministic CPU-rendered pixels.
    pub image: image::RgbaImage,
    /// Measurements collected from repeated identical frame work.
    pub metrics: ScenarioMetrics,
    /// Optional native GPU replay output; CPU image and capture remain canonical.
    pub native: Option<NativeCheckpoint>,
}

/// Optional results from replaying one capture on a native WGPU device.
#[derive(Clone, Debug)]
pub struct NativeCheckpoint {
    /// Readback image produced by the native renderer.
    pub image: image::RgbaImage,
    /// Red-highlighted pixel difference against the canonical CPU output.
    pub diff: image::RgbaImage,
    /// Native execution and allocation measurements.
    pub metrics: NativeReplayMetrics,
    /// Difference statistics against the CPU output.
    pub difference: ImageDifference,
}

/// Native adapter details stored once per report suite.
#[derive(Clone, Debug, serde::Serialize, serde::Deserialize)]
pub struct NativeReplayInfo {
    /// Name advertised by the selected hardware or software adapter.
    pub adapter: String,
    /// Driver name and version advertised by WGPU.
    pub driver: String,
    /// Graphics API used for replay, such as Metal or Vulkan.
    pub backend: String,
    /// Adapter class, including integrated, discrete, and software devices.
    pub device_type: String,
    /// Why hardware GPU timestamps are unavailable, if the adapter does not support them.
    pub timestamp_reason: Option<String>,
}

/// Native replay measurements and their explicit memory scope.
#[derive(Clone, Debug, serde::Serialize, serde::Deserialize)]
pub struct NativeReplayMetrics {
    /// Repeated frames measured after one warm-up frame.
    pub samples: usize,
    /// CPU elapsed time from frame preparation through encoding, queue submission, and completion
    /// wait. Excludes target creation, timestamp mapping, and pixel readback.
    pub encode_submit_completion: TimingPercentiles,
    /// GPU command execution timestamps, absent when unsupported by the adapter.
    pub gpu: Option<TimingPercentiles>,
    /// Renderer-owned GPU resource bytes, not total driver/device VRAM.
    pub tracked_owned_bytes: u64,
    /// Backend-reported allocation; interpret this with `device_allocation_scope`.
    pub device_allocated_bytes: Option<u64>,
    /// Exact resource subset included in `tracked_owned_bytes`.
    pub allocation_scope: String,
    /// Source and scope of backend-reported device allocation telemetry, when available.
    pub device_allocation_scope: Option<String>,
    /// Why allocation telemetry is unavailable; absent when a measurement exists.
    pub allocation_reason: Option<String>,
}

/// Pixel difference statistics between native replay and canonical CPU output.
#[derive(Clone, Debug, serde::Serialize, serde::Deserialize)]
pub struct ImageDifference {
    /// Pixels where at least one RGBA channel differs.
    pub changed_pixels: u64,
    /// Pixels in the union of both image bounds.
    pub total_pixels: u64,
    /// Largest absolute difference in an 8-bit channel.
    pub max_channel_error: u8,
    /// Mean absolute difference across all RGBA channels, in the range 0–255.
    pub mean_channel_error: f64,
}

/// Explicit CPU-side performance and storage measurements.
#[derive(Clone, Debug, serde::Serialize, serde::Deserialize)]
pub struct ScenarioMetrics {
    /// Number of repeated frames measured after one warm-up frame.
    pub frame_count: usize,
    /// Scene build percentiles, in nanoseconds.
    pub scene_build_p50_ns: u64,
    /// Scene build percentiles, in nanoseconds.
    pub scene_build_p95_ns: u64,
    /// Scene build percentiles, in nanoseconds.
    pub scene_build_p99_ns: u64,
    /// CPU replay p50, in nanoseconds; reuses the target and excludes RGBA readback.
    pub cpu_render_p50_ns: u64,
    /// CPU replay p95, in nanoseconds; reuses the target and excludes RGBA readback.
    pub cpu_render_p95_ns: u64,
    /// CPU replay p99, in nanoseconds; reuses the target and excludes RGBA readback.
    pub cpu_render_p99_ns: u64,
    /// Number of scene primitives across all primitive arrays.
    pub primitive_count: usize,
    /// Number of batch commands in the captured display list.
    pub batch_count: usize,
    /// Bytes in all captured atlas bitmaps.
    pub bitmap_storage_bytes: usize,
}

/// Nearest-rank timing percentiles in nanoseconds.
#[derive(Clone, Debug, serde::Serialize, serde::Deserialize)]
pub struct TimingPercentiles {
    pub p50_ns: u64,
    pub p95_ns: u64,
    pub p99_ns: u64,
}

/// Configures a deterministic headless GPUI run.
pub struct Harness {
    timing_samples: usize,
    text_system: Option<Arc<dyn PlatformTextSystem>>,
    font_pack: String,
    asset_source: Arc<dyn AssetSource>,
    bundled_text_system: OnceLock<std::result::Result<Arc<dyn PlatformTextSystem>, String>>,
}

impl Default for Harness {
    fn default() -> Self {
        Self::new()
    }
}

impl Harness {
    /// Uses one frame for deterministic correctness captures.
    pub fn new() -> Self {
        Self {
            timing_samples: 1,
            text_system: None,
            font_pack: "bundled-v1".into(),
            asset_source: Arc::new(()),
            bundled_text_system: OnceLock::new(),
        }
    }

    /// Creates a harness with twenty repeated frames for CPU-side benchmarking.
    pub fn benchmark() -> Self {
        Self {
            timing_samples: 20,
            ..Self::new()
        }
    }

    /// Sets the number of repeated, identical frames used for timing. One sample is useful for
    /// correctness-only callers; larger samples provide more useful tail percentiles.
    pub fn timing_samples(mut self, count: usize) -> Result<Self> {
        ensure!(count > 0, "timing sample count must be positive");
        self.timing_samples = count;
        Ok(self)
    }

    /// Repeated frames measured at each checkpoint, excluding its warm-up frame.
    pub fn timing_sample_count(&self) -> usize {
        self.timing_samples
    }

    /// Supplies a caller-owned text system instead of the bundled-font default.
    pub fn with_text_system(mut self, system: Arc<dyn PlatformTextSystem>) -> Self {
        self.text_system = Some(system);
        self.font_pack = "custom".into();
        self
    }

    /// Identifies a caller-owned font pack in exported reports.
    pub fn with_named_text_system(
        mut self,
        name: impl Into<String>,
        system: Arc<dyn PlatformTextSystem>,
    ) -> Self {
        self.text_system = Some(system);
        self.font_pack = name.into();
        self
    }

    /// Supplies assets used by the scenario views.
    pub fn with_asset_source(mut self, assets: Arc<dyn AssetSource>) -> Self {
        self.asset_source = assets;
        self
    }

    /// Runs the scenario headlessly with a deterministic CPU renderer. Bundled font fixtures are
    /// used unless a text system was supplied with [`Self::with_text_system`].
    pub fn run<V: Render + 'static>(&self, scenario: &Scenario<V>) -> Result<RenderedScenario> {
        ensure!(
            !scenario.checkpoints.is_empty(),
            "scenario {} has no checkpoints",
            scenario.id
        );
        let viewport = Viewport {
            width: scenario.size.width.as_f32(),
            height: scenario.size.height.as_f32(),
            scale_factor: scenario.scale_factor,
        };
        let device_size = viewport
            .device_size()
            .with_context(|| format!("invalid physical viewport for scenario {}", scenario.id))?;
        let system: Arc<dyn PlatformTextSystem> = if let Some(system) = &self.text_system {
            system.clone()
        } else {
            self.bundled_text_system
                .get_or_init(|| {
                    bundled_text_system()
                        .map(|system| Arc::new(system) as Arc<dyn PlatformTextSystem>)
                        .map_err(|error| format!("{error:#}"))
                })
                .as_ref()
                .map(Arc::clone)
                .map_err(|error| anyhow::anyhow!(error.clone()))?
        };
        let atlas = Arc::new(CpuAtlas::new());
        let factory_atlas = atlas.clone();
        let mut cx =
            HeadlessAppContext::with_platform(system, self.asset_source.clone(), move || {
                Some(Box::new(CaptureOnlyRenderer {
                    atlas: factory_atlas.clone(),
                }) as Box<dyn PlatformHeadlessRenderer>)
            });

        let window = cx.open_window(scenario.size, |window, app| (scenario.build)(window, app))?;
        let view = window.root(&mut cx)?;
        cx.set_scale_factor(window.into(), scenario.scale_factor)?;
        cx.run_until_parked();
        let any_window = window.into();
        let mut previous_at = Duration::ZERO;
        let mut output = Vec::with_capacity(scenario.checkpoints.len());

        for checkpoint in &scenario.checkpoints {
            cx.advance_clock(checkpoint.at - previous_at);
            previous_at = checkpoint.at;
            if let Some(update) = &checkpoint.update {
                update(&mut cx, &view, window)?;
            }
            cx.run_until_parked();

            // Resolve first-paint work before measuring repeated draws at this fixed time.
            cx.draw_window(any_window)?;
            let mut scene_samples = Vec::with_capacity(self.timing_samples);
            for _ in 0..self.timing_samples {
                let start = Instant::now();
                cx.draw_window(any_window)?;
                scene_samples.push(elapsed_ns(start));
            }

            let capture = cx.capture_scene(any_window, |tile| atlas.resolve(tile))?;
            let primitive_count = cx.read_scene(any_window, |scene| {
                scene.shadows.len()
                    + scene.quads.len()
                    + scene.paths.len()
                    + scene.underlines.len()
                    + scene.monochrome_sprites.len()
                    + scene.subpixel_sprites.len()
                    + scene.polychrome_sprites.len()
            })?;
            let scene = capture.to_scene()?;
            let mut cpu = CpuRenderer::from_captured_bitmaps(capture.bitmaps())?;
            // Allocate and warm the retained target before collecting steady-state samples.
            cpu.render_scene(&scene, device_size)?;
            let mut cpu_samples = Vec::with_capacity(self.timing_samples);
            for _ in 0..self.timing_samples {
                let start = Instant::now();
                cpu.render_scene(&scene, device_size)
                    .context("CPU rendering scenario frame")?;
                cpu_samples.push(elapsed_ns(start));
            }
            let commands = capture.commands();
            let batch_count = commands
                .iter()
                .filter(|command| matches!(command, gpui::RenderCommand::Batch(_)))
                .count();
            let bitmap_storage_bytes = capture
                .bitmaps()
                .iter()
                .map(|bitmap| bitmap.bytes.len())
                .sum();
            let build = TimingPercentiles::from_samples(scene_samples);
            let replay = TimingPercentiles::from_samples(cpu_samples);
            output.push(RenderedCheckpoint {
                id: checkpoint.id.clone(),
                name: checkpoint.name.clone(),
                time_ns: checkpoint.at.as_nanos().min(u64::MAX as u128) as u64,
                capture,
                image: cpu.readback()?,
                metrics: ScenarioMetrics {
                    frame_count: self.timing_samples,
                    scene_build_p50_ns: build.p50_ns,
                    scene_build_p95_ns: build.p95_ns,
                    scene_build_p99_ns: build.p99_ns,
                    cpu_render_p50_ns: replay.p50_ns,
                    cpu_render_p95_ns: replay.p95_ns,
                    cpu_render_p99_ns: replay.p99_ns,
                    primitive_count,
                    batch_count,
                    bitmap_storage_bytes,
                },
                native: None,
            });
        }
        Ok(RenderedScenario {
            id: scenario.id.clone(),
            title: scenario.title.clone(),
            viewport,
            font_pack: self.font_pack.clone(),
            checkpoints: output,
        })
    }
}

struct CaptureOnlyRenderer {
    atlas: Arc<CpuAtlas>,
}

impl PlatformHeadlessRenderer for CaptureOnlyRenderer {
    fn render_scene_to_image(
        &mut self,
        _scene: &gpui::Scene,
        _size: Size<DevicePixels>,
    ) -> Result<image::RgbaImage> {
        anyhow::bail!("capture-only renderer cannot produce images")
    }
    fn render_scene(&mut self, _scene: &gpui::Scene, _size: Size<DevicePixels>) -> Result<()> {
        Ok(())
    }
    fn sprite_atlas(&self) -> Arc<dyn PlatformAtlas> {
        self.atlas.clone()
    }
}

fn elapsed_ns(start: Instant) -> u64 {
    start.elapsed().as_nanos().min(u64::MAX as u128) as u64
}

impl TimingPercentiles {
    pub(crate) fn from_samples(samples: impl IntoIterator<Item = u64>) -> Self {
        let mut samples: Vec<_> = samples.into_iter().collect();
        assert!(
            !samples.is_empty(),
            "timing measurements require at least one sample"
        );
        samples.sort_unstable();
        // Nearest-rank quantiles: with twenty samples, p95 is the nineteenth.
        let rank =
            |percent: u128| samples[((samples.len() as u128 * percent).div_ceil(100) - 1) as usize];
        Self {
            p50_ns: rank(50),
            p95_ns: rank(95),
            p99_ns: rank(99),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::TimingPercentiles;

    #[test]
    fn tail_percentiles_use_nearest_rank_without_discarding_the_slowest_frame() {
        let distribution = TimingPercentiles::from_samples((1..=20).rev());
        assert_eq!(
            (
                distribution.p50_ns,
                distribution.p95_ns,
                distribution.p99_ns
            ),
            (10, 19, 20)
        );
        let single = TimingPercentiles::from_samples([42]);
        assert_eq!((single.p50_ns, single.p95_ns, single.p99_ns), (42, 42, 42));
    }
}
