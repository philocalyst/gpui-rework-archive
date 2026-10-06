use anyhow::Result;
use gpui::{Scene, SceneCapture, WindowCheckReport, WindowCheckStatus};
use gpui_test::{
    ImageDifference, NativeCheckpoint, NativeReplayInfo, NativeReplayMetrics, RenderedCheckpoint,
    RenderedScenario, RenderedSuite, ReportChangeKind, ReportOptions, ReportStatus,
    ScenarioMetrics, TimingPercentiles, Viewport, collect_reports, read_report, write_report,
};
use std::{
    fs,
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
        image: image.clone(),
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

#[test]
fn read_report_round_trips_font_native_and_platform_metadata() -> Result<()> {
    let dirs = TestDirs::new();
    let mut suite = sample_suite([40, 80, 120, 255]);
    let checkpoint = &mut suite.scenarios[0].checkpoints[0];
    checkpoint.native = Some(NativeCheckpoint {
        image: checkpoint.image.clone(),
        diff: image::RgbaImage::from_pixel(4, 4, image::Rgba([0, 0, 0, 255])),
        metrics: NativeReplayMetrics {
            samples: 3,
            encode_submit_completion: TimingPercentiles {
                p50_ns: 10,
                p95_ns: 20,
                p99_ns: 30,
            },
            gpu: None,
            tracked_owned_bytes: 1024,
            device_allocated_bytes: None,
            allocation_scope: "test allocations".into(),
            device_allocation_scope: None,
            allocation_reason: Some("not queried in test".into()),
        },
        difference: ImageDifference {
            changed_pixels: 0,
            total_pixels: 16,
            max_channel_error: 0,
            mean_channel_error: 0.0,
        },
    });
    suite.native_replay = Some(NativeReplayInfo {
        adapter: "test adapter".into(),
        driver: "test driver".into(),
        backend: "Vulkan".into(),
        device_type: "Cpu".into(),
        timestamp_reason: Some("test adapter has no timestamps".into()),
    });
    suite.platform_checks = Some(WindowCheckReport {
        schema_version: 1,
        platform: "test".into(),
        status: WindowCheckStatus::Passed,
        ..Default::default()
    });
    let path = dirs.path("with-metadata");
    write(&suite, &path);

    let loaded = read_report(&path)?;
    assert_eq!(loaded.scenarios[0].font_pack, "fixture-pack");
    assert_eq!(
        loaded.scenarios[0].snapshots()?,
        suite.scenarios[0].snapshots()?
    );
    assert!(loaded.scenarios[0].checkpoints[0].native.is_some());
    assert_eq!(
        serde_json::to_value(loaded.native_replay)?,
        serde_json::to_value(suite.native_replay)?
    );
    assert_eq!(
        serde_json::to_value(loaded.platform_checks)?,
        serde_json::to_value(suite.platform_checks)?
    );
    Ok(())
}

#[test]
fn collect_reports_keeps_first_identical_duplicate_and_ignores_timing_differences() -> Result<()> {
    let dirs = TestDirs::new();
    let first_path = dirs.path("first");
    let second_path = dirs.path("second");
    let first = sample_suite([1, 2, 3, 255]);
    let mut second = sample_suite([1, 2, 3, 255]);
    second.scenarios[0].checkpoints[0].metrics.cpu_render_p50_ns = 999;
    write(&first, &first_path);
    write(&second, &second_path);

    let collected = collect_reports(&[first_path, second_path])?;
    assert_eq!(collected.scenarios.len(), 1);
    assert_eq!(
        collected.scenarios[0].checkpoints[0]
            .metrics
            .cpu_render_p50_ns,
        first.scenarios[0].checkpoints[0].metrics.cpu_render_p50_ns
    );
    Ok(())
}

#[test]
fn collect_reports_rejects_pixel_conflicts_for_duplicate_ids() {
    let dirs = TestDirs::new();
    let first_path = dirs.path("first");
    let second_path = dirs.path("second");
    write(&sample_suite([1, 2, 3, 255]), &first_path);
    write(&sample_suite([4, 5, 6, 255]), &second_path);

    let error = collect_reports(&[first_path, second_path]).unwrap_err();
    assert!(
        error
            .to_string()
            .contains("conflicting duplicate scenario ID")
    );
}

#[test]
fn collect_reports_rejects_incompatible_native_and_platform_results() {
    let dirs = TestDirs::new();
    let first_path = dirs.path("first");
    let second_path = dirs.path("second");
    let mut first = sample_suite([1, 2, 3, 255]);
    let mut second = sample_suite([1, 2, 3, 255]);
    first.native_replay = Some(NativeReplayInfo {
        adapter: "adapter one".into(),
        driver: "driver".into(),
        backend: "Vulkan".into(),
        device_type: "Cpu".into(),
        timestamp_reason: None,
    });
    second.native_replay = Some(NativeReplayInfo {
        adapter: "adapter two".into(),
        driver: "driver".into(),
        backend: "Vulkan".into(),
        device_type: "Cpu".into(),
        timestamp_reason: None,
    });
    write(&first, &first_path);
    write(&second, &second_path);
    let error = collect_reports(&[first_path.clone(), second_path.clone()]).unwrap_err();
    assert!(
        error
            .to_string()
            .contains("incompatible native WGPU adapter metadata")
    );

    first.native_replay = None;
    second.native_replay = None;
    first.platform_checks = Some(WindowCheckReport {
        schema_version: 1,
        platform: "linux".into(),
        status: WindowCheckStatus::Passed,
        ..Default::default()
    });
    second.platform_checks = Some(WindowCheckReport {
        schema_version: 1,
        platform: "macos".into(),
        status: WindowCheckStatus::Passed,
        ..Default::default()
    });
    write(&first, &first_path);
    write(&second, &second_path);
    let error = collect_reports(&[first_path, second_path]).unwrap_err();
    assert!(
        error
            .to_string()
            .contains("incompatible platform lifecycle report")
    );
}

#[test]
fn read_report_rejects_noncanonical_artifact_paths() {
    let dirs = TestDirs::new();
    let path = dirs.path("report");
    write(&sample_suite([1, 2, 3, 255]), &path);
    let manifest_path = path.join("manifest.json");
    let mut manifest: serde_json::Value =
        serde_json::from_slice(&fs::read(&manifest_path).unwrap()).unwrap();
    manifest["scenarios"][0]["checkpoints"][0]["png"] = "../outside.png".into();
    fs::write(
        &manifest_path,
        serde_json::to_vec_pretty(&manifest).unwrap(),
    )
    .unwrap();

    let error = read_report(&path).unwrap_err();
    assert!(error.to_string().contains("noncanonical artifact paths"));
}

#[test]
fn read_report_validates_capture_before_returning_it_for_replay() {
    let dirs = TestDirs::new();
    let path = dirs.path("report");
    write(&sample_suite([1, 2, 3, 255]), &path);
    let scene_path = path.join("sample/frame.scene.json");
    let mut capture: serde_json::Value =
        serde_json::from_slice(&fs::read(&scene_path).unwrap()).unwrap();
    capture["version"] = 999.into();
    fs::write(&scene_path, serde_json::to_vec(&capture).unwrap()).unwrap();

    let error = read_report(&path).unwrap_err();
    assert!(format!("{error:#}").contains("validating scene capture sample/frame"));
}

#[test]
fn collection_retains_each_font_pack_and_rejects_conflicting_duplicate_packs() -> Result<()> {
    let dirs = TestDirs::new();
    let first_path = dirs.path("first");
    let second_path = dirs.path("second");
    let first = sample_suite([1, 2, 3, 255]);
    let mut second = sample_suite([1, 2, 3, 255]);
    second.scenarios[0].font_pack = "another-pack".into();
    write(&first, &first_path);
    write(&second, &second_path);
    assert!(collect_reports(&[&first_path, &second_path]).is_err());

    second.scenarios[0].id = "another-scenario".into();
    write(&second, &second_path);
    let collected = collect_reports(&[first_path, second_path])?;
    let combined_path = dirs.path("combined");
    write(&collected, &combined_path);
    let loaded = read_report(&combined_path)?;
    assert_eq!(loaded.scenarios[0].font_pack, "fixture-pack");
    assert_eq!(loaded.scenarios[1].font_pack, "another-pack");
    Ok(())
}

#[test]
fn font_pack_changes_agree_in_scenario_checkpoint_and_comparison_results() -> Result<()> {
    let dirs = TestDirs::new();
    let baseline_path = dirs.path("baseline");
    let mut suite = sample_suite([1, 2, 3, 255]);
    write(&suite, &baseline_path);
    suite.scenarios[0].font_pack = "changed-pack".into();
    let manifest = write_report(
        &suite,
        dirs.path("current"),
        ReportOptions {
            baseline_dir: Some(baseline_path),
            ..Default::default()
        },
    )?;
    assert_eq!(manifest.scenarios[0].status, ReportStatus::Changed);
    let checkpoint = &manifest.scenarios[0].checkpoints[0];
    assert_eq!(checkpoint.status, ReportStatus::Changed);
    assert_eq!(checkpoint.metadata_changed, Some(true));
    assert_eq!(checkpoint.pixels_changed, Some(false));
    assert_eq!(checkpoint.scene_changed, Some(false));
    assert_eq!(manifest.changes.len(), 1);
    assert_eq!(
        manifest.changes[0].kind,
        ReportChangeKind::ScenarioMetadataChanged
    );
    Ok(())
}

#[cfg(unix)]
#[test]
fn canonical_artifact_names_cannot_follow_symlinks_outside_the_report() {
    let dirs = TestDirs::new();
    let path = dirs.path("report");
    write(&sample_suite([1, 2, 3, 255]), &path);
    let image_path = path.join("sample/frame.png");
    let outside_path = dirs.path("outside.png");
    fs::rename(&image_path, &outside_path).unwrap();
    std::os::unix::fs::symlink(&outside_path, &image_path).unwrap();

    let error = read_report(&path).unwrap_err();
    assert!(error.to_string().contains("escapes report directory"));
}
