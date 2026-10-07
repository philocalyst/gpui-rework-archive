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
            bounds: None,
            visible: Some(gpui_test::VisibleDifference {
                changed_pixels: 0,
                max_channel_error: 0.0,
                mean_channel_error: 0.0,
            }),
            size_changed: false,
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
fn gzip_scene_artifacts_are_deterministic_and_compare_equal_to_legacy_json() -> Result<()> {
    let dirs = TestDirs::new();
    let suite = sample_suite([40, 80, 120, 255]);
    let compressed_path = dirs.path("compressed");
    let duplicate_path = dirs.path("compressed-duplicate");
    let legacy_path = dirs.path("legacy");
    write(&suite, &compressed_path);
    write(&suite, &duplicate_path);
    write(&suite, &legacy_path);

    let compressed_bytes = fs::read(compressed_path.join("sample/frame.scene.json.gz"))?;
    assert_eq!(
        compressed_bytes,
        fs::read(duplicate_path.join("sample/frame.scene.json.gz"))?,
        "gzip output should be byte-for-byte stable"
    );
    rewrite_scene_as_legacy(&legacy_path)?;

    let compressed = read_report(&compressed_path)?;
    let legacy = read_report(&legacy_path)?;
    assert_eq!(
        compressed.scenarios[0].snapshots()?,
        legacy.scenarios[0].snapshots()?
    );
    assert!(compare_reports(&legacy_path, &compressed_path)?.is_empty());

    let compared_to_legacy = write_report(
        &suite,
        dirs.path("legacy-baseline-current"),
        ReportOptions {
            baseline_dir: Some(legacy_path),
            ..Default::default()
        },
    )?;
    let checkpoint = &compared_to_legacy.scenarios[0].checkpoints[0];
    assert_eq!(checkpoint.pixels_changed, Some(false));
    assert_eq!(checkpoint.scene_changed, Some(false));
    Ok(())
}

#[test]
fn gzip_scene_reader_handles_member_boundaries_and_rejects_truncation_or_trailing_data()
-> Result<()> {
    let dirs = TestDirs::new();
    let valid = dirs.path("valid");
    write(&sample_suite([1, 2, 3, 255]), &valid);
    let scene_path = valid.join("sample/frame.scene.json.gz");
    let compressed = fs::read(&scene_path)?;
    let mut decoder = MultiGzDecoder::new(compressed.as_slice());
    let mut json = Vec::new();
    decoder.read_to_end(&mut json)?;

    let split = json.len() / 2;
    let mut two_members = gzip(&json[..split]);
    two_members.extend(gzip(&json[split..]));
    fs::write(&scene_path, two_members)?;
    assert_eq!(read_report(&valid)?.scenarios.len(), 1);

    let mut trailing_member = fs::read(&scene_path)?;
    trailing_member.extend(gzip(b"{}"));
    fs::write(&scene_path, trailing_member)?;
    let error = read_report(&valid).unwrap_err();
    assert!(format!("{error:#}").contains("parsing scene capture"));

    fs::write(&scene_path, &compressed[..compressed.len() - 8])?;
    let error = read_report(&valid).unwrap_err();
    assert!(format!("{error:#}").contains("decompressing scene capture"));

    fs::write(&scene_path, b"not a gzip stream")?;
    let error = read_report(&valid).unwrap_err();
    assert!(format!("{error:#}").contains("decompressing scene capture"));

    let oversized = vec![0; 12 * 1024 * 1024 + 1];
    fs::write(&scene_path, gzip(&oversized))?;
    let error = read_report(&valid).unwrap_err();
    assert!(format!("{error:#}").contains("decompressed scene capture exceeds 12 MiB"));
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
fn report_writer_streams_and_deduplicates_report_inputs() -> Result<()> {
    let dirs = TestDirs::new();
    let first_path = dirs.path("first");
    let second_path = dirs.path("second");
    let output_path = dirs.path("output");
    write(&sample_suite([1, 2, 3, 255]), &first_path);
    let mut second = sample_suite([1, 2, 3, 255]);
    second.scenarios[0].checkpoints[0].metrics.cpu_render_p50_ns += 10;
    write(&second, &second_path);

    let mut writer = ReportWriter::new(&output_path, ReportOptions::default())?;
    writer.add_report(&first_path)?;
    writer.add_report(&second_path)?;
    let manifest = writer.finish()?;
    assert_eq!(manifest.scenarios.len(), 1);
    assert_eq!(manifest.scenarios[0].id, "sample");
    let loaded = read_report(output_path)?;
    assert_eq!(loaded.scenarios.len(), 1);
    assert_eq!(
        loaded.scenarios[0].checkpoints[0].metrics.cpu_render_p50_ns,
        20
    );
    Ok(())
}

#[test]
fn report_writer_rejects_input_output_containment() -> Result<()> {
    let dirs = TestDirs::new();
    let input_path = dirs.path("input");
    write(&sample_suite([1, 2, 3, 255]), &input_path);

    let mut same_dir = ReportWriter::new(&input_path, ReportOptions::default())?;
    assert!(same_dir.add_report(&input_path).is_err());

    let mut nested = ReportWriter::new(input_path.join("output"), ReportOptions::default())?;
    assert!(nested.add_report(&input_path).is_err());
    drop(nested);
    assert!(!input_path.join("output").exists());

    let nested_output = input_path.join("baseline-child");
    let result = ReportWriter::new(
        &nested_output,
        ReportOptions {
            baseline_dir: Some(input_path.clone()),
            selected_ids: Vec::new(),
        },
    );
    let error = match result {
        Ok(_) => anyhow::bail!("nested output path should be rejected"),
        Err(error) => error,
    };
    assert!(error.to_string().contains("must not contain one another"));
    assert!(!nested_output.exists());
    Ok(())
}

#[test]
fn failed_report_write_preserves_existing_report_and_refuses_unrelated_directories() -> Result<()> {
    let dirs = TestDirs::new();
    let output = dirs.path("output");
    write(&sample_suite([1, 2, 3, 255]), &output);
    let old_manifest = fs::read(output.join("manifest.json"))?;
    let old_image = fs::read(output.join("sample/frame.png"))?;

    let mut broken = sample_suite([4, 5, 6, 255]);
    let duplicate = broken.scenarios[0].checkpoints[0].clone();
    broken.scenarios[0].checkpoints.push(duplicate);
    let mut writer = ReportWriter::new(&output, ReportOptions::default())?;
    assert!(writer.add_scenario(&broken.scenarios[0]).is_err());
    assert!(writer.finish().is_err());
    assert_eq!(fs::read(output.join("manifest.json"))?, old_manifest);
    assert_eq!(fs::read(output.join("sample/frame.png"))?, old_image);

    let unrelated = dirs.path("unrelated");
    fs::create_dir(&unrelated)?;
    fs::write(unrelated.join("keep.txt"), b"keep")?;
    assert!(ReportWriter::new(&unrelated, ReportOptions::default()).is_err());
    assert_eq!(fs::read(unrelated.join("keep.txt"))?, b"keep");
    Ok(())
}

#[test]
fn read_report_rejects_oversized_legacy_scene_json() -> Result<()> {
    let dirs = TestDirs::new();
    let report = dirs.path("report");
    write(&sample_suite([1, 2, 3, 255]), &report);
    let manifest_path = report.join("manifest.json");
    let mut manifest: serde_json::Value = serde_json::from_slice(&fs::read(&manifest_path)?)?;
    let compressed_path = manifest["scenarios"][0]["checkpoints"][0]["scene_json"]
        .as_str()
        .unwrap()
        .to_owned();
    let raw_path = compressed_path.trim_end_matches(".gz").to_owned();
    fs::write(report.join(&raw_path), vec![b' '; 12 * 1024 * 1024 + 1])?;
    fs::remove_file(report.join(&compressed_path))?;
    manifest["scenarios"][0]["checkpoints"][0]["scene_json"] = raw_path.into();
    fs::write(manifest_path, serde_json::to_vec_pretty(&manifest)?)?;
    let error = read_report(&report).unwrap_err();
    assert!(format!("{error:#}").contains("scene capture exceeds 12 MiB"));
    Ok(())
}

#[test]
fn read_report_rejects_oversized_manifest() -> Result<()> {
    let dirs = TestDirs::new();
    let report = dirs.path("report");
    write(&sample_suite([1, 2, 3, 255]), &report);
    fs::write(
        report.join("manifest.json"),
        vec![b' '; 12 * 1024 * 1024 + 1],
    )?;
    let error = read_report(&report).unwrap_err();
    assert!(format!("{error:#}").contains("file exceeds 12 MiB"));
    Ok(())
}

#[cfg(unix)]
#[test]
fn report_writer_resolves_parent_symlinks_before_parent_components() -> Result<()> {
    let dirs = TestDirs::new();
    let real_parent = dirs.path("real");
    fs::create_dir_all(real_parent.join("nested"))?;
    let alias = dirs.path("alias");
    std::os::unix::fs::symlink(real_parent.join("nested"), &alias)?;
    let requested_output = alias.join("..").join("output");

    let mut writer = ReportWriter::new(&requested_output, ReportOptions::default())?;
    writer.add_suite(&sample_suite([1, 2, 3, 255]))?;
    writer.finish()?;
    assert!(real_parent.join("output/manifest.json").is_file());
    assert!(!dirs.path("output").exists());
    Ok(())
}

#[test]
fn report_writer_rejects_conflicting_source_revisions() -> Result<()> {
    let dirs = TestDirs::new();
    let first = dirs.path("first");
    let second = dirs.path("second");
    write(&sample_suite([1, 2, 3, 255]), &first);
    write(&sample_suite([1, 2, 3, 255]), &second);
    for (report, sha) in [(&first, "revision-one"), (&second, "revision-two")] {
        let path = report.join("manifest.json");
        let mut manifest: serde_json::Value = serde_json::from_slice(&fs::read(&path)?)?;
        manifest["environment"]["git_sha"] = sha.into();
        fs::write(path, serde_json::to_vec_pretty(&manifest)?)?;
    }

    let mut writer = ReportWriter::new(dirs.path("output"), ReportOptions::default())?;
    writer.add_report(&first)?;
    let error = writer.add_report(&second).unwrap_err();
    assert!(error.to_string().contains("incompatible source revisions"));

    let mut preserving = ReportWriter::new(dirs.path("preserved"), ReportOptions::default())?;
    preserving.add_report(&first)?;
    let output = preserving.finish()?;
    assert_eq!(output.environment.git_sha.as_deref(), Some("revision-one"));
    Ok(())
}

#[test]
fn collect_reports_rejects_pixel_conflicts_for_duplicate_ids() {
    let dirs = TestDirs::new();
    let first_path = dirs.path("first");
    let second_path = dirs.path("second");
    write(&sample_suite([1, 2, 3, 255]), &first_path);
    write(&sample_suite([4, 5, 6, 255]), &second_path);

    let error = collect_reports(&[first_path.clone(), second_path.clone()]).unwrap_err();
    assert!(
        error
            .to_string()
            .contains("conflicting duplicate scenario ID")
    );
    let output = dirs.path("streaming");
    let mut writer = ReportWriter::new(&output, ReportOptions::default()).unwrap();
    writer.add_report(&first_path).unwrap();
    assert!(writer.add_report(&second_path).is_err());
    assert!(writer.finish().is_err());
    assert!(!output.exists());
}

#[test]
fn motion_comparison_detects_a_frozen_frame_without_bridging_missing_checkpoints() -> Result<()> {
    let dirs = TestDirs::new();
    let baseline_path = dirs.path("baseline");
    let mut baseline = sample_suite([0, 0, 0, 255]);
    let template = baseline.scenarios[0].checkpoints[0].clone();
    baseline.scenarios[0].checkpoints = [0, 64, 128]
        .into_iter()
        .enumerate()
        .map(|(index, red)| RenderedCheckpoint {
            id: format!("frame-{index}"),
            time_ns: index as u64 * 100_000_000,
            image: image::RgbaImage::from_pixel(4, 4, image::Rgba([red, 0, 0, 255])),
            ..template.clone()
        })
        .collect();
    write(&baseline, &baseline_path);
    let mut current = baseline.clone();
    current.scenarios[0].checkpoints[1].image = template.image;
    current.scenarios[0].checkpoints[1].time_ns = 150_000_000;
    let manifest = write_report(
        &current,
        dirs.path("current"),
        ReportOptions {
            baseline_dir: Some(baseline_path.clone()),
            ..Default::default()
        },
    )?;
    let checkpoints = &manifest.scenarios[0].checkpoints;
    assert!(checkpoints[0].motion.is_none());
    let frozen = checkpoints[1].motion.as_ref().unwrap();
    assert_eq!(frozen.previous_checkpoint_id, "frame-0");
    assert_eq!(frozen.before_duration_ns, Some(100_000_000));
    assert_eq!(frozen.current_duration_ns, Some(150_000_000));
    assert_eq!(frozen.difference.changed_pixels, 16);
    assert_eq!(frozen.difference.max_channel_error, 64.0);
    // The final image catches up, but its transition is still different from the baseline.
    assert_eq!(checkpoints[2].pixels_changed, Some(false));
    assert_eq!(
        checkpoints[2]
            .motion
            .as_ref()
            .unwrap()
            .difference
            .changed_pixels,
        16
    );

    current.scenarios[0].checkpoints.remove(1);
    let sparse = write_report(
        &current,
        dirs.path("sparse"),
        ReportOptions {
            baseline_dir: Some(baseline_path),
            ..Default::default()
        },
    )?;
    assert!(sparse.scenarios[0].checkpoints[1].motion.is_none());
    Ok(())
}

#[test]
fn streaming_collection_preserves_validated_source_encoding() -> Result<()> {
    let dirs = TestDirs::new();
    let input = dirs.path("input");
    write(&sample_suite([1, 2, 3, 255]), &input);
    let scene_path = input.join("sample/frame.scene.json.gz");
    let mut json = Vec::new();
    MultiGzDecoder::new(fs::File::open(&scene_path)?).read_to_end(&mut json)?;
    let mut encoder = GzBuilder::new()
        .mtime(123)
        .write(Vec::new(), Compression::best());
    encoder.write_all(&json)?;
    let source_bytes = encoder.finish()?;
    fs::write(&scene_path, &source_bytes)?;
    let output = dirs.path("output");
    let mut writer = ReportWriter::new(&output, ReportOptions::default())?;
    writer.add_report(&input)?;
    // A duplicate with different gzip bytes must take the semantic comparison fallback.
    fs::write(&scene_path, gzip(&json))?;
    writer.add_report(&input)?;
    writer.finish()?;
    assert_eq!(
        fs::read(output.join("sample/frame.scene.json.gz"))?,
        source_bytes
    );
    assert_eq!(
        fs::read(output.join("sample/frame.png"))?,
        fs::read(input.join("sample/frame.png"))?
    );
    Ok(())
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
    let scene_path = path.join("sample/frame.scene.json.gz");
    let compressed = fs::read(&scene_path).unwrap();
    let mut decoder = MultiGzDecoder::new(compressed.as_slice());
    let mut scene_json = Vec::new();
    decoder.read_to_end(&mut scene_json).unwrap();
    let mut capture: serde_json::Value = serde_json::from_slice(&scene_json).unwrap();
    capture["version"] = 999.into();
    fs::write(&scene_path, gzip(&serde_json::to_vec(&capture).unwrap())).unwrap();

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
    assert_eq!(checkpoint.before_time_ns, Some(0));
    assert_eq!(checkpoint.difference, None);
    assert_eq!(checkpoint.heatmap_png, None);
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
