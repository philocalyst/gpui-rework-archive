//! Collection report contracts.
use super::*;

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
