use anyhow::Result;
use flate2::{Compression, GzBuilder, read::MultiGzDecoder};
use gpui::{Scene, SceneCapture, WindowCheckReport, WindowCheckStatus};
use gpui_test::{
    ImageDifference, NativeCheckpoint, NativeReplayInfo, NativeReplayMetrics, RenderedCheckpoint,
    RenderedScenario, RenderedSuite, ReportChangeKind, ReportOptions, ReportStatus, ReportWriter,
    ScenarioMetrics, TimingPercentiles, Viewport, collect_reports, compare_reports, read_report,
    write_report,
};
use std::{
    fs,
    io::{Read, Write},
    path::PathBuf,
    sync::atomic::{AtomicUsize, Ordering},
};

static NEXT_DIR: AtomicUsize = AtomicUsize::new(0);

struct TestDirs(PathBuf);

impl TestDirs {
    fn new() -> Self {
        let suffix = NEXT_DIR.fetch_add(1, Ordering::Relaxed);
        let root = std::env::temp_dir().join(format!(
            "gpui-report-collection-{}-{suffix}",
            std::process::id()
        ));
        let _ = fs::remove_dir_all(&root);
        fs::create_dir_all(&root).unwrap();
        Self(root)
    }

    fn path(&self, name: &str) -> PathBuf {
        self.0.join(name)
    }
}

impl Drop for TestDirs {
    fn drop(&mut self) {
        let _ = fs::remove_dir_all(&self.0);
    }
}

fn sample_suite(color: [u8; 4]) -> RenderedSuite {
    let mut scene = Scene::default();
    scene.finish();
    let capture = SceneCapture::capture(&scene, |_tile| {
        anyhow::bail!("empty scene does not have atlas tiles")
    })
    .unwrap();
    let image = image::RgbaImage::from_pixel(4, 4, image::Rgba(color));
    let checkpoint = RenderedCheckpoint {
        id: "frame".into(),
        name: "Frame".into(),
        time_ns: 0,
        capture,
        image,
        metrics: ScenarioMetrics {
            frame_count: 1,
            scene_build_p50_ns: 10,
            scene_build_p95_ns: 10,
            scene_build_p99_ns: 10,
            cpu_render_p50_ns: 20,
            cpu_render_p95_ns: 20,
            cpu_render_p99_ns: 20,
            primitive_count: 0,
            batch_count: 0,
            bitmap_storage_bytes: 0,
        },
        native: None,
    };
    RenderedSuite::new(vec![RenderedScenario {
        id: "sample".into(),
        title: "Sample scenario".into(),
        viewport: Viewport {
            width: 4.0,
            height: 4.0,
            scale_factor: 1.0,
        },
        font_pack: "fixture-pack".into(),
        checkpoints: vec![checkpoint],
    }])
}

fn write(suite: &RenderedSuite, path: &PathBuf) {
    write_report(suite, path, ReportOptions::default()).unwrap();
}

fn gzip(bytes: &[u8]) -> Vec<u8> {
    let mut encoder = GzBuilder::new()
        .mtime(0)
        .write(Vec::new(), Compression::fast());
    encoder.write_all(bytes).unwrap();
    encoder.finish().unwrap()
}

fn rewrite_scene_as_legacy(report: &PathBuf) -> Result<()> {
    let manifest_path = report.join("manifest.json");
    let mut manifest: serde_json::Value = serde_json::from_slice(&fs::read(&manifest_path)?)?;
    let checkpoint = &mut manifest["scenarios"][0]["checkpoints"][0];
    let compressed_path = checkpoint["scene_json"].as_str().unwrap().to_owned();
    let compressed_scene = fs::read(report.join(&compressed_path))?;
    let mut scene_json = Vec::new();
    MultiGzDecoder::new(compressed_scene.as_slice()).read_to_end(&mut scene_json)?;
    let legacy_path = compressed_path.trim_end_matches(".gz").to_owned();
    fs::write(report.join(&legacy_path), scene_json)?;
    fs::remove_file(report.join(&compressed_path))?;
    checkpoint["scene_json"] = legacy_path.into();
    fs::write(&manifest_path, serde_json::to_vec_pretty(&manifest)?)?;
    Ok(())
}

#[path = "report_collection/collection.rs"]
mod collection;
#[path = "report_collection/motion.rs"]
mod motion;
#[path = "report_collection/publication.rs"]
mod publication;
#[path = "report_collection/roundtrip.rs"]
mod roundtrip;
#[path = "report_collection/validation.rs"]
mod validation;
