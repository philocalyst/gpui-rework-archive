//! Motion report contracts.
use super::*;

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
    let current_path = dirs.path("current");
    let manifest = write_report(
        &current,
        &current_path,
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
    for checkpoint in &checkpoints[1..] {
        let motion = checkpoint.motion.as_ref().unwrap();
        let mask = image::open(current_path.join(motion.diff_png.as_ref().unwrap()))?.into_rgba8();
        assert_eq!(mask[(0, 0)], image::Rgba([255, 32, 32, 255]));
        let heatmap =
            image::open(current_path.join(motion.heatmap_png.as_ref().unwrap()))?.into_rgba8();
        assert_ne!(mask, heatmap);
    }
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
