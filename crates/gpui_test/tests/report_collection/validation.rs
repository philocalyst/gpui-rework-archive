//! Validation report contracts.
use super::*;

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
