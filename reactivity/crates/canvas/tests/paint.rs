use gpui_canvas::{
    Affine, AlphaMode, Canvas, Color, ColorConfig, Image, ImageSampling, OutputProfile, PaintEdit,
    PaintErrorKind, PaintIndex, Point, Rect, TextLayout, TextSystem,
};

fn scene(
    canvas: &mut Canvas,
    text: &mut TextSystem,
    layout: &TextLayout,
    colors: [Color; 3],
) -> [PaintIndex; 3] {
    canvas.clear(Color::WHITE);
    let clip = Rect::new(0.375, 0.125, 61.25, 44.25);
    let at = canvas.paint_cursor();
    canvas
        .fill_rect(
            Rect::new(0.125, 0.375, 39.0, 29.0),
            Affine {
                a: -1.0,
                tx: 42.0,
                ..Affine::IDENTITY
            },
            clip,
            colors[0],
        )
        .unwrap();
    let lower = canvas.paint_index(at).unwrap();
    let at = canvas.paint_cursor();
    canvas
        .fill_rounded_rect(
            Rect::new(0.125, 0.375, 29.0, 25.0),
            7.0,
            Affine {
                c: 0.25,
                tx: 9.0,
                ty: 3.0,
                ..Affine::IDENTITY
            },
            clip,
            colors[1],
        )
        .unwrap();
    let upper = canvas.paint_index(at).unwrap();
    let at = canvas.paint_cursor();
    canvas
        .draw_text(
            text,
            layout,
            Point { x: 1.0, y: 12.0 },
            Affine::IDENTITY,
            clip,
            colors[2],
        )
        .unwrap();
    let letters = canvas.paint_index(at).unwrap();
    [lower, upper, letters]
}

#[test]
fn patches_match_full_replacement_for_profiles_hdr_masks_and_ordered_overlap() {
    let mut text = TextSystem::bundled().unwrap();
    let layout = text.shape("ABA café", 16.0, None).unwrap();
    for config in [
        ColorConfig::default(),
        ColorConfig {
            profile: OutputProfile::DisplayP3,
            ..ColorConfig::default()
        },
        ColorConfig::linear_hdr(OutputProfile::Srgb, 203.0).unwrap(),
        ColorConfig::linear_hdr(OutputProfile::DisplayP3, 203.0).unwrap(),
    ] {
        let mut colors = [
            Color::rgba(255, 0, 0, 128),
            Color::rgba(0, 0, 255, 128),
            Color::BLACK,
        ];
        let mut patched = Canvas::with_color_config(64, 48, config).unwrap();
        let indices = scene(&mut patched, &mut text, &layout, colors);
        let mut full = Canvas::with_color_config(64, 48, config).unwrap();
        let _ = patched.pixels();
        let storage = patched.prepared_scene().storage();
        for which in [0, 1, 2, 3] {
            let next = [
                Color::linear_display_p3(-0.25, 2.0, 0.3, 128.0 / 255.0).unwrap(),
                Color::rgba(0, 255, 0, 128),
                Color::linear_srgb(0.2, -0.125, 1.5, 1.0).unwrap(),
            ];
            let edits: Vec<_> = (0..3)
                .filter(|&i| which == i || which == 3)
                .map(|i| {
                    colors[i] = next[i];
                    PaintEdit::new(indices[i], colors[i])
                })
                .collect();
            let plan = patched.prepare_paint(&edits).unwrap();
            let damage = plan.damage();
            assert_eq!(plan.commit(), damage);
            scene(&mut full, &mut text, &layout, colors);
            assert_eq!(patched.pixels(), full.pixels(), "{config:?}, which {which}");
            assert_eq!(
                patched.prepared_scene().storage().lane_bytes(),
                storage.lane_bytes()
            );
        }
    }
}

#[test]
fn validation_and_dropping_a_prepared_commit_are_transactional() {
    let mut canvas = Canvas::new(32, 16).unwrap();
    let clip = Rect::new(0.0, 0.0, 32.0, 16.0);
    let at = canvas.paint_cursor();
    canvas
        .fill_rect(clip, Affine::IDENTITY, clip, Color::BLACK)
        .unwrap();
    let first = canvas.paint_index(at).unwrap();
    let at = canvas.paint_cursor();
    canvas
        .fill_rect(
            Rect::new(3.0, 3.0, 4.0, 4.0),
            Affine::IDENTITY,
            clip,
            Color::WHITE,
        )
        .unwrap();
    let second = canvas.paint_index(at).unwrap();
    let before = canvas.pixels().to_vec();
    let edits = [
        PaintEdit::new(first, Color::WHITE),
        PaintEdit::new(second, Color::TRANSPARENT),
    ];
    let err = canvas.prepare_paint(&edits).err().unwrap();
    assert_eq!(err.edit, 1);
    assert_eq!(err.reason, PaintErrorKind::AlphaChanged);
    assert_eq!(canvas.pixels(), before);
    let edits = [
        PaintEdit::new(second, Color::BLACK),
        PaintEdit::new(first, Color::WHITE),
    ];
    assert_eq!(
        canvas.prepare_paint(&edits).err().unwrap().reason,
        PaintErrorKind::Unordered
    );
    let edits = [PaintEdit::new(first, Color::WHITE)];
    drop(canvas.prepare_paint(&edits).unwrap());
    assert_eq!(canvas.pixels(), before);
    let edits = [PaintEdit::new(first, Color::BLACK)];
    let plan = canvas.prepare_paint(&edits).unwrap();
    assert_eq!(plan.changed_groups(), 0);
    assert!(plan.commit().is_empty());
    canvas.clear(Color::WHITE);
    assert_eq!(
        canvas.prepare_paint(&edits).err().unwrap().reason,
        PaintErrorKind::MissingGroup
    );
}

#[test]
fn group_boundaries_empty_calls_and_image_material_are_checked() {
    let mut text = TextSystem::bundled().unwrap();
    let layout = text.shape("AAAA", 16.0, None).unwrap();
    let clip = Rect::new(0.0, 0.0, 64.0, 32.0);
    let mut canvas = Canvas::recording(64, 32, ColorConfig::default()).unwrap();
    let at = canvas.paint_cursor();
    canvas
        .fill_rect(Rect::default(), Affine::IDENTITY, clip, Color::WHITE)
        .unwrap();
    assert!(canvas.paint_index(at).is_none());
    canvas
        .draw_text(
            &mut text,
            &layout,
            Point::default(),
            Affine::IDENTITY,
            clip,
            Color::BLACK,
        )
        .unwrap();
    assert!(canvas.paint_index(at).is_some());
    assert!(canvas.paint_index(at + 1).is_none());
    let image = Image::linear_srgb(1, 1, AlphaMode::Straight, Box::new([[1.0; 4]])).unwrap();
    let at = canvas.paint_cursor();
    canvas
        .draw_image(&image, clip, Affine::IDENTITY, clip, ImageSampling::Nearest)
        .unwrap();
    assert!(canvas.paint_index(at).is_none());
    assert_eq!(std::mem::size_of::<PaintIndex>(), 4);
    assert_eq!(std::mem::size_of::<PaintEdit>(), 20);
}

#[test]
fn returned_damage_repairs_a_preserved_image_and_leaves_outside_pixels_unchanged() {
    let mut canvas = Canvas::new(64, 48).unwrap();
    canvas.clear(Color::WHITE);
    let clip = Rect::new(0.0, 0.0, 64.0, 48.0);
    let at = canvas.paint_cursor();
    canvas
        .fill_rounded_rect(
            Rect::new(7.125, 4.375, 13.0, 19.0),
            4.0,
            Affine::IDENTITY,
            clip,
            Color::BLACK,
        )
        .unwrap();
    let index = canvas.paint_index(at).unwrap();
    let mut preserved = vec![0; 64 * 48];
    canvas.render_bgrx(&mut preserved).unwrap();
    let previous = preserved.clone();
    let edits = [PaintEdit::new(index, Color::rgb(255, 0, 0))];
    let damage = canvas.prepare_paint(&edits).unwrap().commit();
    canvas.render_bgrx_region(&mut preserved, damage).unwrap();
    let mut full = vec![0; 64 * 48];
    canvas.render_bgrx(&mut full).unwrap();
    assert_eq!(preserved, full);
    let [l, t, r, b] = damage.bounds().unwrap();
    for y in 0..48 {
        for x in 0..64 {
            if x < l || x >= r || y < t || y >= b {
                assert_eq!(
                    preserved[(y * 64 + x) as usize],
                    previous[(y * 64 + x) as usize]
                );
            }
        }
    }
}
