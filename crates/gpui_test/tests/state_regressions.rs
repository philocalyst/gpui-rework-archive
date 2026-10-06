use anyhow::Result;
use gpui::{App, AppContext as _, px, size};
use gpui_test::{
    Harness, RenderedCheckpoint, RenderedScenario, RenderedSuite, ReportChangeKind, ReportOptions,
    Scenario, ScenarioMetrics, Viewport, compare_reports, compare_reports_selected,
    gallery::AnimationScenario, write_report,
};
use std::time::Duration;

fn animation_scenario(id: &str, times_ms: &[u64]) -> Result<Scenario<AnimationScenario>> {
    let mut scenario = Scenario::new(
        id,
        "Repeated animation clock regression",
        size(px(320.0), px(220.0)),
        |_, cx: &mut App| cx.new(|_| AnimationScenario),
    )?;
    for (index, milliseconds) in times_ms.iter().copied().enumerate() {
        scenario = scenario.checkpoint(
            format!("frame-{index}"),
            format!("{milliseconds} ms"),
            Duration::from_millis(milliseconds),
        )?;
    }
    Ok(scenario)
}

fn pixel_bytes(checkpoint: &RenderedCheckpoint) -> Vec<u8> {
    checkpoint.image.as_raw().to_vec()
}

fn marker_min_x(checkpoint: &RenderedCheckpoint) -> u32 {
    checkpoint
        .image
        .enumerate_pixels()
        .filter(|(_, _, pixel)| pixel.0 == [0x61, 0xc6, 0xed, 0xff])
        .map(|(x, _, _)| x)
        .min()
        .expect("animation marker pixels are present")
}

#[test]
fn fixed_animation_times_are_idempotent_and_cross_repeat_boundaries() -> Result<()> {
    let scenario = animation_scenario("animation-fixed-times", &[0, 250, 250, 500, 1000, 1250])?;
    let rendered = Harness::new().timing_samples(1)?.run(&scenario)?;
    assert_eq!(rendered.checkpoints.len(), 6);

    let pixels = rendered
        .checkpoints
        .iter()
        .map(pixel_bytes)
        .collect::<Vec<_>>();
    assert_eq!(
        pixels[1], pixels[2],
        "repeated 250 ms capture must be identical"
    );
    let x0 = marker_min_x(&rendered.checkpoints[0]);
    let x250 = marker_min_x(&rendered.checkpoints[1]);
    let x500 = marker_min_x(&rendered.checkpoints[3]);
    let x1000 = marker_min_x(&rendered.checkpoints[4]);
    let x1250 = marker_min_x(&rendered.checkpoints[5]);
    assert!(
        (10..=25).contains(&(x250 as i32 - x0 as i32)),
        "ease-in-out at 250 ms should move about 16 px; got {} px",
        x250 as i32 - x0 as i32
    );
    assert!(
        (55..=70).contains(&(x500 as i32 - x0 as i32)),
        "eased 500 ms position is unexpected: {} px",
        x500 as i32 - x0 as i32
    );
    assert!(
        (160..=178).contains(&(x1000 as i32 - x0 as i32)),
        "eased 1000 ms position is unexpected: {} px",
        x1000 as i32 - x0 as i32
    );
    assert!(
        (0..=3).contains(&(x1250 as i32 - x0 as i32)),
        "repeat phase at 1250 ms should be near its start: {} px",
        x1250 as i32 - x0 as i32
    );
    for (before, after) in [(0, 1), (2, 3), (3, 4), (4, 5)] {
        assert_ne!(
            pixels[before],
            pixels[after],
            "animation should visibly advance between {} ms and {} ms",
            rendered.checkpoints[before].time_ns / 1_000_000,
            rendered.checkpoints[after].time_ns / 1_000_000,
        );
    }
    Ok(())
}

#[test]
fn animation_at_an_absolute_time_is_independent_of_clock_chunking() -> Result<()> {
    let direct = animation_scenario("animation-direct", &[0, 250])?;
    let chunked = animation_scenario("animation-chunked", &[0, 125, 250])?;
    let direct = Harness::new().timing_samples(1)?.run(&direct)?;
    let chunked = Harness::new().timing_samples(1)?.run(&chunked)?;

    assert_eq!(
        pixel_bytes(direct.checkpoints.last().unwrap()),
        pixel_bytes(chunked.checkpoints.last().unwrap()),
        "the same 250 ms animation state must render identically after different checkpoint intervals"
    );
    Ok(())
}

proptest::proptest! {
    #![proptest_config(proptest::test_runner::Config {
        cases: 48,
        .. proptest::test_runner::Config::default()
    })]

    #[test]
    fn nondecreasing_absolute_checkpoint_times_are_accepted(mut times in proptest::collection::vec(0u16..=5000, 0..12)) {
        times.sort_unstable();
        let mut scenario = Scenario::new(
            "timeline-order-property",
            "Checkpoint timeline ordering",
            size(px(1.0), px(1.0)),
            |_, cx: &mut App| cx.new(|_| AnimationScenario),
        ).unwrap();
        for (index, milliseconds) in times.into_iter().enumerate() {
            scenario = scenario.checkpoint(
                format!("tick-{index}"),
                "generated time",
                Duration::from_millis(u64::from(milliseconds)),
            ).unwrap();
        }
        proptest::prop_assert_eq!(scenario.id(), "timeline-order-property");
    }
}

#[test]
fn report_comparison_reports_removed_checkpoints() -> Result<()> {
    use gpui::Scene;

    fn fixture_checkpoint(id: &str, time_ns: u64) -> Result<RenderedCheckpoint> {
        let mut scene = Scene::default();
        // Fractional geometry catches f32 widening during saved-JSON comparisons.
        let bounds = gpui::Bounds::new(
            gpui::point(gpui::ScaledPixels(0.1), gpui::ScaledPixels(0.3)),
            size(gpui::ScaledPixels(0.8), gpui::ScaledPixels(0.6)),
        );
        scene.insert_primitive(gpui::Quad {
            bounds,
            content_mask: gpui::ContentMask {
                bounds,
                ..Default::default()
            },
            ..Default::default()
        });
        scene.finish();
        let capture = gpui::SceneCapture::capture(&scene, |_| {
            anyhow::bail!("empty scene has no atlas tiles")
        })?;
        Ok(RenderedCheckpoint {
            id: id.to_owned(),
            name: format!("{id} checkpoint"),
            time_ns,
            capture,
            image: image::RgbaImage::from_pixel(1, 1, image::Rgba([0, 0, 0, 0])),
            metrics: ScenarioMetrics {
                frame_count: 1,
                scene_build_p50_ns: 1,
                scene_build_p95_ns: 1,
                scene_build_p99_ns: 1,
                cpu_render_p50_ns: 1,
                cpu_render_p95_ns: 1,
                cpu_render_p99_ns: 1,
                primitive_count: 1,
                batch_count: 1,
                bitmap_storage_bytes: 0,
            },
            native: None,
        })
    }

    fn suite(checkpoints: Vec<RenderedCheckpoint>) -> RenderedSuite {
        RenderedSuite::new(vec![RenderedScenario {
            id: "animation".into(),
            title: "Animation".into(),
            viewport: Viewport {
                width: 1.0,
                height: 1.0,
                scale_factor: 1.0,
            },
            font_pack: "test-fixture".into(),
            checkpoints,
        }])
    }

    let mut old = suite(vec![
        fixture_checkpoint("t000", 0)?,
        fixture_checkpoint("t250", 250_000_000)?,
        fixture_checkpoint("t500", 500_000_000)?,
    ]);
    let mut current = suite(vec![
        fixture_checkpoint("t000", 0)?,
        fixture_checkpoint("t500", 500_000_000)?,
    ]);
    let root = std::env::temp_dir().join(format!("gpui-compare-checkpoint-{}", std::process::id()));
    let baseline_dir = root.join("baseline");
    let current_dir = root.join("current");
    let mut unrelated = old.scenarios[0].clone();
    unrelated.id = "unrelated".into();
    old.scenarios.push(unrelated);
    let mut added = current.scenarios[0].clone();
    added.id = "unrelated-new".into();
    current.scenarios.push(added);
    let _ = std::fs::remove_dir_all(&root);
    let baseline = write_report(&old, &baseline_dir, ReportOptions::default())?;
    assert_eq!(baseline.environment.font_pack, "test-fixture");
    let selected = write_report(
        &current,
        &current_dir,
        ReportOptions {
            baseline_dir: Some(baseline_dir.clone()),
            selected_ids: vec!["animation".into()],
        },
    )?;
    assert!(
        selected
            .changes
            .iter()
            .all(|change| change.scenario_id == "animation"),
        "unselected additions and removals must be excluded: {:?}",
        selected.changes
    );
    let selected_changes =
        compare_reports_selected(&baseline_dir, &current_dir, &["animation".into()])?;
    assert_eq!(
        selected.changes.len(),
        1,
        "unchanged fractional geometry must not produce spurious scene differences"
    );
    assert_eq!(selected_changes.len(), 1);
    assert!(
        selected_changes
            .iter()
            .all(|change| change.scenario_id == "animation"),
        "saved report comparisons must honor the same selection: {selected_changes:?}"
    );

    let changes = compare_reports(&baseline_dir, &current_dir)?;
    assert!(
        changes.iter().any(|change| {
            change.kind == ReportChangeKind::CheckpointRemoved
                && change.scenario_id == "animation"
                && change.checkpoint_id.as_deref() == Some("t250")
        }),
        "actual changes: {changes:?}"
    );
    std::fs::remove_dir_all(root)?;
    Ok(())
}

#[derive(Default)]
struct MultilineUnderlineScenario;

impl gpui::Render for MultilineUnderlineScenario {
    fn render(
        &mut self,
        _window: &mut gpui::Window,
        _cx: &mut gpui::Context<Self>,
    ) -> impl gpui::IntoElement {
        use gpui::{HighlightStyle, StyledText, UnderlineStyle, div, hsla, prelude::*, px, rgb};
        let underline = |color| HighlightStyle {
            underline: Some(UnderlineStyle {
                thickness: px(2.0),
                color: Some(color),
                wavy: true,
            }),
            ..Default::default()
        };
        div()
            .size_full()
            .p_2()
            .bg(rgb(0xffffff))
            .text_color(rgb(0x111111))
            .child(div().w(px(90.0)).text_lg().child(
                StyledText::new("first second third").with_highlights([
                    (0..5, underline(hsla(0.0, 0.9, 0.45, 1.0))),
                    (6..12, underline(hsla(0.58, 0.9, 0.45, 1.0))),
                    (13..18, underline(hsla(0.88, 0.9, 0.45, 1.0))),
                ]),
            ))
    }
}

#[test]
fn wrapped_parley_text_keeps_colored_wavy_underlines_on_multiple_lines() -> Result<()> {
    let scenario = Scenario::new(
        "multiline-underlines",
        "Multiline colored underlines",
        size(px(120.0), px(160.0)),
        |_, cx: &mut App| cx.new(|_| MultilineUnderlineScenario),
    )?
    .checkpoint("default", "Wrapped text", Duration::ZERO)?;
    let rendered = Harness::new().timing_samples(1)?.run(&scenario)?;
    let checkpoint = &rendered.checkpoints[0];
    let scene = checkpoint.capture.clone().into_scene()?;

    let has_colored_underline_pixel = checkpoint.image.enumerate_pixels().any(|(x, y, pixel)| {
        let rgb = [pixel[0], pixel[1], pixel[2]];
        let colorful = rgb.iter().max().unwrap() - rgb.iter().min().unwrap() > 40;
        scene.underlines.iter().any(|underline| {
            let bounds = underline.bounds;
            x as f32 + 0.5 >= bounds.origin.x.0
                && x as f32 + 0.5 < bounds.origin.x.0 + bounds.size.width.0
                && y as f32 + 0.5 >= bounds.origin.y.0 - 1.0
                && y as f32 + 0.5 <= bounds.origin.y.0 + bounds.size.height.0 + 1.0
        }) && colorful
    });
    assert!(
        has_colored_underline_pixel,
        "the CPU raster must include colored underline pixels"
    );

    assert!(
        scene.underlines.len() >= 3,
        "captured underline segments: {}",
        scene.underlines.len()
    );
    assert!(
        scene
            .underlines
            .iter()
            .any(|underline| underline.wavy == gpui::ShaderBool::Enabled)
    );
    let mut y_positions = scene
        .underlines
        .iter()
        .map(|underline| underline.bounds.origin.y.0.to_bits())
        .collect::<Vec<_>>();
    y_positions.sort_unstable();
    y_positions.dedup();
    assert!(
        y_positions.len() >= 2,
        "underlines should occupy wrapped text lines; y positions: {y_positions:?}"
    );
    let mut colors = scene
        .underlines
        .iter()
        .map(|underline| serde_json::to_string(&underline.color).unwrap())
        .collect::<Vec<_>>();
    colors.sort();
    colors.dedup();
    assert!(
        colors.len() >= 2,
        "styled runs should retain separate underline colors"
    );
    Ok(())
}

#[derive(Default)]
struct DecorationBaselineScenario;

impl gpui::Render for DecorationBaselineScenario {
    fn render(
        &mut self,
        _window: &mut gpui::Window,
        _cx: &mut gpui::Context<Self>,
    ) -> impl gpui::IntoElement {
        use gpui::{
            StrikethroughStyle, TextAlign, UnderlineStyle, canvas, div, fill, point, prelude::*,
        };

        let pieces = [
            (
                "IBM Plex Sans has a baseline marker and enough words to wrap across visual lines. ",
                "IBM Plex Sans",
            ),
            (
                "Source Serif 4 also wraps its own words across multiple visual lines. ",
                "Source Serif 4",
            ),
            (
                "Lilex wraps too, so all three bundled families are painted.",
                "Lilex",
            ),
        ];
        let text = pieces
            .iter()
            .map(|(piece, _)| *piece)
            .collect::<Vec<_>>()
            .concat();
        let runs = pieces
            .iter()
            .map(|(piece, family)| gpui::TextRun {
                len: piece.len(),
                font: gpui::font(*family),
                color: gpui::hsla(0.0, 0.0, 0.07, 1.0),
                underline: Some(UnderlineStyle {
                    thickness: px(2.0),
                    color: Some(gpui::hsla(0.0, 0.8, 0.5, 1.0)),
                    wavy: false,
                }),
                strikethrough: Some(StrikethroughStyle {
                    thickness: px(2.0),
                    color: Some(gpui::hsla(0.66, 0.8, 0.5, 1.0)),
                }),
                ..Default::default()
            })
            .collect::<Vec<_>>();
        let line_height = px(30.0);

        div().size_full().bg(gpui::rgb(0xffffff)).child(canvas(
            move |_bounds, window, _cx| {
                window
                    .text_system()
                    .shape_text(text, px(16.0), &runs, Some(px(180.0)), None)
                    .expect("fixed bundled decoration text should shape")
            },
            move |bounds, shaped, window, cx| {
                let origin = point(bounds.origin.x + px(8.0), bounds.origin.y + px(8.0));
                let baseline_offset =
                    (line_height - shaped.ascent() - shaped.descent()) / 2.0 + shaped.ascent();
                for line_index in 0..shaped.line_count() {
                    let baseline = origin.y + line_height * line_index as f32 + baseline_offset;
                    // This guide is outside the text column and is computed from font metrics,
                    // independently of the decoration offsets being tested.
                    window.paint_quad(fill(
                        gpui::Bounds::new(
                            point(bounds.origin.x + px(220.0), baseline - px(0.5)),
                            gpui::size(px(8.0), px(1.0)),
                        ),
                        gpui::hsla(0.33, 1.0, 0.4, 1.0),
                    ));
                }
                shaped
                    .paint(origin, line_height, TextAlign::Left, None, window, cx)
                    .expect("shaped decorated text should paint");
            },
        ))
    }
}

#[test]
fn rendered_decoration_pixels_straddle_independent_font_baseline_guides() -> Result<()> {
    let scenario = Scenario::new(
        "decoration-baseline-signs",
        "Decoration sides of font baseline",
        size(px(240.0), px(280.0)),
        |_, cx: &mut App| cx.new(|_| DecorationBaselineScenario),
    )?
    .checkpoint("default", "Wrapped decorated text", Duration::ZERO)?;
    let rendered = Harness::new().timing_samples(1)?.run(&scenario)?;
    let checkpoint = &rendered.checkpoints[0];

    let baseline_rows = checkpoint
        .image
        .enumerate_pixels()
        .filter(|(x, _, pixel)| {
            (220..238).contains(x) && pixel[1] > 100 && pixel[0] < 80 && pixel[2] < 80
        })
        .map(|(_, y, _)| y)
        .collect::<std::collections::BTreeSet<_>>();
    assert!(
        baseline_rows.len() >= 3,
        "baseline guides found at {baseline_rows:?}"
    );
    let baselines = baseline_rows.into_iter().collect::<Vec<_>>();

    let mut underline_pixels = 0;
    let mut strike_pixels = 0;
    for (x, y, pixel) in checkpoint.image.enumerate_pixels() {
        if x >= 210 {
            continue;
        }
        let nearest_baseline = *baselines
            .iter()
            .min_by_key(|baseline| y.abs_diff(**baseline))
            .expect("baseline guides are present");
        let baseline = nearest_baseline as i32;
        if pixel[0] > 120 && pixel[0] > pixel[1].saturating_mul(2) && pixel[2] < 120 {
            underline_pixels += 1;
            assert!(
                y as i32 > baseline,
                "underline pixel ({x}, {y}) must be below its baseline guide at {nearest_baseline}"
            );
        }
        if pixel[2] > 120 && pixel[2] > pixel[0].saturating_mul(2) && pixel[1] < 120 {
            strike_pixels += 1;
            assert!(
                (y as i32) < baseline,
                "strikethrough pixel ({x}, {y}) must be above its baseline guide at {nearest_baseline}"
            );
        }
    }
    assert!(
        underline_pixels > 10,
        "rendered underline pixels: {underline_pixels}"
    );
    assert!(
        strike_pixels > 10,
        "rendered strikethrough pixels: {strike_pixels}"
    );
    Ok(())
}
