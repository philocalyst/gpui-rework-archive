use gpui::{Affine, Color, El, Error, Point, View, Win, WindowOptions, div, text};

struct BoxView;
impl View for BoxView {
    fn view(&self) -> El<'_> {
        div()
            .size(20)
            .bg(Color::BLACK)
            .transform(Affine::translation(4.0, 6.0))
            .on_click(|_: &mut Self| {})
    }
}
fn near_bounds(actual: [f32; 4], expected: [f32; 4]) {
    for (actual, expected) in actual.into_iter().zip(expected) {
        assert!((actual - expected).abs() < 0.0001, "{actual} vs {expected}");
    }
}
fn options(size: [u32; 2]) -> WindowOptions {
    WindowOptions {
        size,
        ..Default::default()
    }
}

#[test]
fn layout_units_transform_once_into_matching_physical_pixels_and_hits() {
    let win = Win::with_options_scaled(BoxView, options([128, 80]), 2.0).unwrap();
    let snapshot = win.snapshot().unwrap();
    assert_eq!(snapshot.scale_factor, 2.0);
    assert_eq!(snapshot.requested_scale_factor, 2.0);
    near_bounds(snapshot.nodes[0].bounds, [8.0, 12.0, 40.0, 40.0]);
    assert_eq!(
        snapshot.nodes[0].transform,
        Some([2.0, 0.0, 0.0, 2.0, 8.0, 12.0])
    );
    let target = snapshot.nodes[0].target.unwrap();
    assert_eq!(
        win.hit_target(Point { x: 9.0, y: 13.0 }).unwrap(),
        Some(target)
    );
    assert_eq!(win.hit_target(Point { x: 49.0, y: 13.0 }).unwrap(), None);
    win.with_pixels(|pixels, width, _| {
        let index = (13 * width as usize + 9) * 4;
        assert_eq!(&pixels[index..index + 4], &[0, 0, 0, 255]);
        assert_eq!(&pixels[..4], &[255; 4]);
    })
    .unwrap();
}

#[test]
fn changing_density_at_equal_size_requires_ack_without_rerunning_view_or_changing_targets() {
    let win = Win::recording_scaled(BoxView, options([128, 80]), 1.0).unwrap();
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    let target = win.snapshot().unwrap().nodes[0].target.unwrap();
    win.reset_counters().unwrap();
    let commit = win.resize_scaled([128, 80], 2.0).unwrap();
    assert_eq!((commit.source_epoch, commit.presentation_epoch), (0, 0));
    assert_eq!(commit.prepared_epoch, Some(0));
    let before = win.snapshot().unwrap();
    assert_eq!(
        (before.scale_factor, before.requested_scale_factor),
        (1.0, 2.0)
    );
    assert_eq!(
        win.hit_target(Point { x: 9.0, y: 13.0 }),
        Err(Error::PresentationStale)
    );
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(win.counters().layout_runs, 1);
    let token = win
        .with_scene(|scene, token| {
            assert_eq!((scene.width, scene.height), (128, 80));
            token
        })
        .unwrap();
    win.presented(token).unwrap();
    let snapshot = win.snapshot().unwrap();
    assert_eq!(snapshot.scale_factor, 2.0);
    assert_eq!(snapshot.nodes[0].target, Some(target));
    near_bounds(snapshot.nodes[0].bounds, [8.0, 12.0, 40.0, 40.0]);
    let counters = win.counters();
    win.resize_scaled([128, 80], 2.0).unwrap();
    assert_eq!(win.counters(), counters);
    // The ordinary physical-resize convenience preserves current device density.
    win.resize([160, 100]).unwrap();
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    assert_eq!(win.snapshot().unwrap().scale_factor, 2.0);
}

#[test]
fn invalid_density_is_rejected_before_requested_geometry_or_authority_changes() {
    let win = Win::with_options(BoxView, options([128, 80])).unwrap();
    let before = win.snapshot().unwrap();
    for scale in [0.0, -1.0, f32::NAN, f32::INFINITY, f32::from_bits(1)] {
        assert_eq!(
            win.resize_scaled([128, 80], scale),
            Err(Error::InvalidScale)
        );
        assert_eq!(win.snapshot().unwrap(), before);
    }
    assert!(matches!(
        Win::recording_scaled(BoxView, options([128, 80]), f32::NAN),
        Err(Error::InvalidScale)
    ));
}

struct Label {
    size: f32,
    padding: f32,
}
impl View for Label {
    fn view(&self) -> El<'_> {
        text("Hi").font_size(self.size).p(self.padding)
    }
}
#[test]
fn runtime_uses_physical_font_masks_while_layout_and_shaping_stay_logical() {
    let scaled = Win::with_options_scaled(
        Label {
            size: 16.0,
            padding: 2.0,
        },
        options([128, 80]),
        2.0,
    )
    .unwrap();
    let physical = Win::with_options(
        Label {
            size: 32.0,
            padding: 4.0,
        },
        options([128, 80]),
    )
    .unwrap();
    let expected = physical.with_pixels(|bytes, _, _| bytes.to_vec()).unwrap();
    scaled
        .with_pixels(|bytes, _, _| assert_eq!(bytes, expected))
        .unwrap();
    let logical = Win::with_options(
        Label {
            size: 16.0,
            padding: 2.0,
        },
        options([64, 40]),
    )
    .unwrap();
    let a = logical.snapshot().unwrap();
    let b = scaled.snapshot().unwrap();
    for (x, y) in a.nodes[0].bounds.into_iter().zip(b.nodes[0].bounds) {
        assert_eq!(2.0 * x, y);
    }
}

#[test]
fn failed_physical_font_admission_keeps_the_old_sheet_and_recovers_at_old_density() {
    let win = Win::recording_scaled(
        Label {
            size: 256.0,
            padding: 0.0,
        },
        options([512, 512]),
        1.0,
    )
    .unwrap();
    let old = win.with_scene(|_, token| token).unwrap();
    win.presented(old).unwrap();
    let before = win.snapshot().unwrap();
    assert_eq!(
        win.resize_scaled([512, 512], 20.0),
        Err(Error::Canvas(gpui_canvas::Error::InvalidFontSize))
    );
    let failed = win.snapshot().unwrap();
    assert_eq!(failed.source_epoch, 0);
    assert_eq!(failed.scale_factor, 1.0);
    assert_eq!(failed.requested_scale_factor, 20.0);
    assert_eq!(failed.nodes, before.nodes);
    assert_eq!(win.with_scene(|_, token| token).unwrap(), old);
    assert_eq!(
        win.hit_target(Point { x: 1.0, y: 1.0 }),
        Err(Error::PresentationStale)
    );
    win.presented(old).unwrap();
    assert_eq!(
        win.hit_target(Point { x: 1.0, y: 1.0 }),
        Err(Error::PresentationStale)
    );
    win.resize_scaled([512, 512], 1.0).unwrap();
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    assert!(win.hit_target(Point { x: 1.0, y: 1.0 }).is_ok());
    assert_eq!(win.snapshot().unwrap().nodes, before.nodes);
}

#[test]
fn physical_viewport_constraints_are_divided_by_density_before_text_wrapping() {
    struct Paragraph;
    impl View for Paragraph {
        fn view(&self) -> El<'_> {
            text("one two three four five six seven eight nine ten eleven twelve thirteen fourteen")
                .font_size(16)
        }
    }
    let logical = Win::with_options(Paragraph, options([120, 200])).unwrap();
    let scaled = Win::with_options_scaled(Paragraph, options([240, 400]), 2.0).unwrap();
    let physical = Win::with_options(Paragraph, options([240, 400])).unwrap();
    let a = logical.snapshot().unwrap().nodes[0].bounds;
    let b = scaled.snapshot().unwrap().nodes[0].bounds;
    let c = physical.snapshot().unwrap().nodes[0].bounds;
    near_bounds(b, a.map(|v| v * 2.0));
    assert!(
        b[3] > c[3] * 2.0,
        "scaled narrower logical viewport must wrap more lines: {b:?} vs{c:?}"
    );
}
