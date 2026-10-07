//! Publication report contracts.
use super::*;

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
