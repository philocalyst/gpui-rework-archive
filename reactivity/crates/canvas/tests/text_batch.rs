use gpui_canvas::{
    Affine, Canvas, Color, Point, Rect, TextLayout, TextRunReplacement, TextRunSlot, TextSystem,
};
const CLIP: Rect = Rect::new(0., 0., 128., 96.);
fn origin(row: usize) -> Point {
    Point {
        x: 2.,
        y: 2. + row as f32 * 24.,
    }
}
fn scene(
    text: &mut TextSystem,
    labels: &[&str],
    transform: Affine,
    clip: Rect,
) -> (Canvas, Vec<TextRunSlot>) {
    let mut canvas = Canvas::new(128, 96).unwrap();
    let mut slots = Vec::new();
    let mut stage = canvas.stage();
    for (i, label) in labels.iter().enumerate() {
        let layout = text.shape(label, 12., None).unwrap();
        slots.push(
            stage
                .draw_text_scaled_tracked(
                    text,
                    &layout,
                    origin(i),
                    transform,
                    clip,
                    Color::WHITE,
                    1.,
                )
                .unwrap()
                .unwrap(),
        );
    }
    stage.commit();
    (canvas, slots)
}
fn replacement(
    slot: TextRunSlot,
    layout: &TextLayout,
    row: usize,
    transform: Affine,
    clip: Rect,
) -> TextRunReplacement<'_> {
    TextRunReplacement {
        slot,
        layout,
        origin: origin(row),
        transform,
        clip,
        color: Color::WHITE,
        raster_scale: 1.,
    }
}
#[test]
fn disjoint_runs_match_full_replacement_with_exact_clips_and_transforms() {
    for (map, clip) in [
        (Affine::IDENTITY, CLIP),
        (
            Affine::translation(0.25, 0.5),
            Rect::new(0.125, 0.375, 120.5, 90.25),
        ),
    ] {
        let mut text = TextSystem::bundled().unwrap();
        let (mut canvas, slots) = scene(&mut text, &["11", "22", "1122"], map, clip);
        let a = text.shape("22", 12., None).unwrap();
        let b = text.shape("11", 12., None).unwrap();
        let edits = [
            replacement(slots[0], &a, 0, map, clip),
            replacement(slots[1], &b, 1, map, clip),
        ];
        assert!(canvas.try_patch_texts(&mut text, &edits).unwrap().is_some());
        let (mut full, _) = scene(&mut text, &["22", "11", "1122"], map, clip);
        assert_eq!(canvas.pixels(), full.pixels());
        assert_eq!(
            canvas.prepared_scene().storage().resource_entries,
            full.prepared_scene().storage().resource_entries
        );
    }
}
#[test]
fn aggregate_last_resource_use_rejects_the_entire_cohort() {
    let mut text = TextSystem::bundled().unwrap();
    let (mut canvas, slots) = scene(&mut text, &["11", "11", "22"], Affine::IDENTITY, CLIP);
    let before = canvas.pixels().to_vec();
    let masks: Vec<_> = canvas.prepared_scene().masks().map(|m| m.key).collect();
    let b = text.shape("22", 12., None).unwrap();
    let edits = [
        replacement(slots[0], &b, 0, Affine::IDENTITY, CLIP),
        replacement(slots[1], &b, 1, Affine::IDENTITY, CLIP),
    ];
    let result = canvas.try_patch_texts(&mut text, &edits).unwrap();
    assert_eq!(
        canvas.pixels(),
        before,
        "collective last-use rejection cannot publish a partial batch"
    );
    assert!(result.is_none());
    assert_eq!(
        canvas
            .prepared_scene()
            .masks()
            .map(|m| m.key)
            .collect::<Vec<_>>(),
        masks
    );
}
#[test]
fn a_rejected_second_run_preserves_the_first_run_and_its_pixels() {
    let mut text = TextSystem::bundled().unwrap();
    let (mut canvas, slots) = scene(&mut text, &["11", "11", "1122"], Affine::IDENTITY, CLIP);
    let before = canvas.pixels().to_vec();
    let first = text.shape("22", 12., None).unwrap();
    let longer = text.shape("222", 12., None).unwrap();
    let edits = [
        replacement(slots[0], &first, 0, Affine::IDENTITY, CLIP),
        replacement(slots[1], &longer, 1, Affine::IDENTITY, CLIP),
    ];
    let result = canvas.try_patch_texts(&mut text, &edits).unwrap();
    assert_eq!(
        canvas.pixels(),
        before,
        "later admission failure must roll back the entire batch"
    );
    assert!(result.is_none());
}
#[test]
fn duplicate_slot_and_late_foreign_layout_leave_the_preceding_scene_intact() {
    let mut text = TextSystem::bundled().unwrap();
    let (mut canvas, slots) = scene(&mut text, &["11", "11", "1122"], Affine::IDENTITY, CLIP);
    let before = canvas.pixels().to_vec();
    let next = text.shape("22", 12., None).unwrap();
    let edits = [
        replacement(slots[0], &next, 0, Affine::IDENTITY, CLIP),
        replacement(slots[0], &next, 0, Affine::IDENTITY, CLIP),
    ];
    assert!(canvas.try_patch_texts(&mut text, &edits).unwrap().is_none());
    assert_eq!(canvas.pixels(), before);
    let mut foreign = TextSystem::new(include_bytes!("../assets/NotoSans.ttf")).unwrap();
    let foreign_layout = foreign.shape("22", 12., None).unwrap();
    let edits = [
        replacement(slots[0], &next, 0, Affine::IDENTITY, CLIP),
        replacement(slots[1], &foreign_layout, 1, Affine::IDENTITY, CLIP),
    ];
    assert!(canvas.try_patch_texts(&mut text, &edits).is_err());
    assert_eq!(canvas.pixels(), before);
}
