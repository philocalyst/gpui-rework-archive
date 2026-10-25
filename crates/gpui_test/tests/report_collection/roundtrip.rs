//! Roundtrip report contracts.
use super::*;

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
