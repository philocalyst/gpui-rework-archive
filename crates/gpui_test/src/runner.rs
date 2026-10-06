use crate::Scenario;
use anyhow::{Context, Result, ensure};
use gpui::{
    AssetSource, DevicePixels, HeadlessAppContext, PlatformAtlas, PlatformHeadlessRenderer,
    PlatformTextSystem, Render, Size,
};
use gpui_ce_parley::{ParleyTextSystem, SystemFonts};
use gpui_ce_render::cpu::{CpuAtlas, CpuRenderer};
use std::{
    borrow::Cow,
    sync::Arc,
    time::{Duration, Instant},
};

/// A rendered suite kept in memory until callers choose to persist a report.
#[derive(Clone, Debug)]
pub struct RenderedSuite {
    /// Captured scenarios, in caller-provided order.
    pub scenarios: Vec<RenderedScenario>,
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
#[derive(Clone, Debug, serde::Serialize, serde::Deserialize)]
pub struct Viewport {
    /// Logical width.
    pub width: f32,
    /// Logical height.
    pub height: f32,
    /// Device scale factor used to build and capture the window.
    pub scale_factor: f32,
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
}

/// Explicit CPU-side performance and storage measurements.
#[derive(Clone, Debug, serde::Serialize, serde::Deserialize)]
pub struct ScenarioMetrics {
    /// Number of repeated frames used for timing.
    pub frame_count: usize,
    /// Scene build percentiles, in nanoseconds.
    pub scene_build_p50_ns: u64,
    /// Scene build percentiles, in nanoseconds.
    pub scene_build_p95_ns: u64,
    /// Scene build percentiles, in nanoseconds.
    pub scene_build_p99_ns: u64,
    /// CPU replay percentiles, in nanoseconds.
    pub cpu_render_p50_ns: u64,
    /// CPU replay percentiles, in nanoseconds.
    pub cpu_render_p95_ns: u64,
    /// CPU replay percentiles, in nanoseconds.
    pub cpu_render_p99_ns: u64,
    /// Number of scene primitives across all primitive arrays.
    pub primitive_count: usize,
    /// Number of batch commands in the captured display list.
    pub batch_count: usize,
    /// Bytes in all captured atlas bitmaps.
    pub bitmap_storage_bytes: usize,
}

/// Configures a deterministic headless GPUI run.
pub struct Harness {
    timing_samples: usize,
    text_system: Option<Arc<dyn PlatformTextSystem>>,
    font_pack: String,
    asset_source: Arc<dyn AssetSource>,
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
        let dimension = |logical: f32| -> Result<DevicePixels> {
            let physical = (logical * viewport.scale_factor).ceil();
            ensure!(
                physical.is_finite() && physical as f64 <= i32::MAX as f64,
                "scenario {} physical viewport exceeds scene coordinate limits",
                scenario.id
            );
            Ok(DevicePixels(physical as i32))
        };
        let device_size = Size {
            width: dimension(viewport.width)?,
            height: dimension(viewport.height)?,
        };
        let system: Arc<dyn PlatformTextSystem> = match &self.text_system {
            Some(system) => system.clone(),
            None => Arc::new(bundled_text_system()?),
        };
        let atlas = Arc::new(CpuAtlas::new());
        let factory_atlas = atlas.clone();
        let mut cx =
            HeadlessAppContext::with_platform(system, self.asset_source.clone(), move || {
                Some(Box::new(CaptureOnlyRenderer {
                    atlas: factory_atlas.clone(),
                }) as Box<dyn PlatformHeadlessRenderer>)
            });

        let view = (scenario.build)(&mut cx.app.borrow_mut());
        let window = cx.open_window(scenario.size, |_, _| view.clone())?;
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
            let mut cpu_samples = Vec::with_capacity(self.timing_samples);
            let mut image = None;
            for _ in 0..self.timing_samples {
                let start = Instant::now();
                let frame = cpu
                    .render_scene_to_image(&scene, device_size)
                    .context("CPU rendering scenario frame")?;
                cpu_samples.push(elapsed_ns(start));
                if image.is_none() {
                    image = Some(frame);
                }
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
            let build = Percentiles::new(scene_samples);
            let replay = Percentiles::new(cpu_samples);
            output.push(RenderedCheckpoint {
                id: checkpoint.id.clone(),
                name: checkpoint.name.clone(),
                time_ns: checkpoint.at.as_nanos().min(u64::MAX as u128) as u64,
                capture,
                image: image.context("CPU renderer produced no frame")?,
                metrics: ScenarioMetrics {
                    frame_count: self.timing_samples,
                    scene_build_p50_ns: build.p50,
                    scene_build_p95_ns: build.p95,
                    scene_build_p99_ns: build.p99,
                    cpu_render_p50_ns: replay.p50,
                    cpu_render_p95_ns: replay.p95,
                    cpu_render_p99_ns: replay.p99,
                    primitive_count,
                    batch_count,
                    bitmap_storage_bytes,
                },
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

/// Builds the fixed-fallback Parley text system with the fonts bundled in this crate.
pub fn bundled_text_system() -> Result<ParleyTextSystem> {
    let system = ParleyTextSystem::new_with_system_font(SystemFonts::Skip, "IBM Plex Sans")
        .with_fallback_families([
            "Noto Sans Arabic",
            "Noto Sans Hebrew",
            "Noto Color Emoji",
            "Noto Sans",
            "IBM Plex Sans",
            "Lilex",
        ]);
    system
        .add_fonts(vec![
            Cow::Borrowed(
                include_bytes!("../assets/fonts/ibm-plex-sans/IBMPlexSans-Regular.ttf").as_slice(),
            ),
            Cow::Borrowed(
                include_bytes!("../assets/fonts/ibm-plex-sans/IBMPlexSans-Italic.ttf").as_slice(),
            ),
            Cow::Borrowed(
                include_bytes!("../assets/fonts/ibm-plex-sans/IBMPlexSans-SemiBold.ttf").as_slice(),
            ),
            Cow::Borrowed(
                include_bytes!("../assets/fonts/ibm-plex-sans/IBMPlexSans-SemiBoldItalic.ttf")
                    .as_slice(),
            ),
            Cow::Borrowed(include_bytes!("../assets/fonts/lilex/Lilex-Regular.ttf").as_slice()),
            Cow::Borrowed(include_bytes!("../assets/fonts/lilex/Lilex-Bold.ttf").as_slice()),
            Cow::Borrowed(include_bytes!("../assets/fonts/lilex/Lilex-Italic.ttf").as_slice()),
            Cow::Borrowed(include_bytes!("../assets/fonts/lilex/Lilex-BoldItalic.ttf").as_slice()),
            Cow::Borrowed(
                include_bytes!("../assets/fonts/source-serif-4/SourceSerif4[opsz,wght].ttf")
                    .as_slice(),
            ),
            Cow::Borrowed(
                include_bytes!("../assets/fonts/noto-sans/NotoSans[wdth,wght].subset.ttf")
                    .as_slice(),
            ),
            Cow::Borrowed(
                include_bytes!("../assets/fonts/noto-sans-arabic/NotoSansArabic-Regular.ttf")
                    .as_slice(),
            ),
            Cow::Borrowed(
                include_bytes!("../assets/fonts/noto-sans-hebrew/NotoSansHebrew-Regular.ttf")
                    .as_slice(),
            ),
            Cow::Borrowed(
                include_bytes!("../assets/fonts/noto-color-emoji/NotoColorEmoji.subset.ttf")
                    .as_slice(),
            ),
        ])
        .context("registering bundled scenario fonts")?;
    for (family, character) in [
        ("Noto Sans Arabic", 'ع'),
        ("Noto Sans Hebrew", 'א'),
        ("Noto Color Emoji", '👩'),
    ] {
        let font_id = system.font_id(&gpui::font(family))?;
        ensure!(
            system.glyph_for_char(font_id, character).is_some(),
            "bundled font {family} does not resolve U+{:04X} ({character})",
            character as u32,
        );
    }
    Ok(system)
}

fn elapsed_ns(start: Instant) -> u64 {
    start.elapsed().as_nanos().min(u64::MAX as u128) as u64
}

struct Percentiles {
    p50: u64,
    p95: u64,
    p99: u64,
}

impl Percentiles {
    fn new(mut samples: Vec<u64>) -> Self {
        assert!(
            !samples.is_empty(),
            "timing measurements require at least one sample"
        );
        samples.sort_unstable();
        // Nearest-rank quantiles: with twenty samples, p95 is the nineteenth.
        let rank =
            |percent: u128| samples[((samples.len() as u128 * percent).div_ceil(100) - 1) as usize];
        Self {
            p50: rank(50),
            p95: rank(95),
            p99: rank(99),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::Percentiles;

    #[test]
    fn tail_percentiles_use_nearest_rank_without_discarding_the_slowest_frame() {
        let distribution = Percentiles::new((1..=20).rev().collect());
        assert_eq!(
            (distribution.p50, distribution.p95, distribution.p99),
            (10, 19, 20)
        );
        let single = Percentiles::new(vec![42]);
        assert_eq!((single.p50, single.p95, single.p99), (42, 42, 42));
    }
}
