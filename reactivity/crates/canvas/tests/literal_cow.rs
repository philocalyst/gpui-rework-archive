use gpui_canvas::{
    Affine, Canvas, Color, ColorConfig, PaintColor, PaintEdit, PaintErrorKind, PaintIndex, Rect,
    SlotEdit,
};

fn append(canvas: &mut Canvas, column: usize, color: Color) -> PaintIndex {
    let cursor = canvas.paint_cursor();
    canvas
        .fill_rect(
            Rect::new(column as f32 * 8.0, 0.0, 8.0, 8.0),
            Affine::IDENTITY,
            Rect::new(0.0, 0.0, 32.0, 8.0),
            color,
        )
        .unwrap();
    canvas.paint_index(cursor).unwrap()
}

fn oracle(config: ColorConfig, colors: [Color; 4]) -> Vec<u8> {
    let mut canvas = Canvas::with_color_config(32, 8, config).unwrap();
    for (column, color) in colors.into_iter().enumerate() {
        append(&mut canvas, column, color);
    }
    canvas.try_pixels().unwrap().to_vec()
}

#[test]
fn equal_and_changed_positional_writes_detach_locally_without_mutating_literal_peers() {
    for config in [
        ColorConfig::default(),
        ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.0).unwrap(),
    ] {
        let original = Color::linear_srgb(0.25, 0.5, 0.75, 1.0).unwrap();
        let changed = Color::linear_srgb(0.75, 0.25, 0.5, 1.0).unwrap();
        let mut canvas = Canvas::with_color_config(32, 8, config).unwrap();
        let first = append(&mut canvas, 0, original);
        let second = append(&mut canvas, 1, original);
        let third = append(&mut canvas, 2, original);
        let equal = [PaintEdit::new(first, original)];
        let plan = canvas.prepare_paint(&equal).unwrap();
        assert_eq!(plan.changed_groups(), 0);
        assert!(plan.damage().is_empty());
        let allocation = allocation_counter::measure(|| {
            plan.commit();
        });
        assert_eq!(allocation.count_total, 0);

        let edits = [PaintEdit::new(second, changed)];
        let plan = canvas.prepare_paint(&edits).unwrap();
        // The palette's aggregate support covers three panels. A positional
        // write uses only the addressed panel's existing outward-rounded
        // bounds, never that aggregate.
        assert_eq!(plan.damage().bounds(), Some([7, 0, 17, 8]));
        plan.commit();
        append(&mut canvas, 3, original);
        assert_eq!(
            canvas.try_pixels().unwrap(),
            oracle(config, [original, changed, original, original])
        );

        // A previously detached row must not get re-interned by later draws.
        canvas
            .prepare_paint(&[PaintEdit::new(first, changed)])
            .unwrap()
            .commit();
        canvas
            .prepare_paint(&[PaintEdit::new(third, Color::WHITE)])
            .unwrap()
            .commit();
        assert_eq!(
            canvas.try_pixels().unwrap(),
            oracle(config, [changed, changed, Color::WHITE, original])
        );
    }
}

#[test]
fn dropped_and_rejected_transactions_preserve_all_aliases_and_future_source_updates() {
    let original = Color::rgb(23, 45, 67);
    let mut canvas = Canvas::new(32, 8).unwrap();
    let a = append(&mut canvas, 0, original);
    let b = append(&mut canvas, 1, original);
    let slot = canvas.paint_slot(PaintColor::new(original)).unwrap();
    canvas
        .fill_rect_slot(
            Rect::new(16.0, 0.0, 8.0, 8.0),
            Affine::IDENTITY,
            Rect::new(0.0, 0.0, 32.0, 8.0),
            slot,
        )
        .unwrap();
    append(&mut canvas, 3, original);
    let before = canvas.try_pixels().unwrap().to_vec();
    let edits = [PaintEdit::new(a, Color::WHITE)];
    drop(canvas.prepare_paint(&edits).unwrap());
    assert_eq!(canvas.try_pixels().unwrap(), before);
    let rejected = [
        PaintEdit::new(a, Color::WHITE),
        PaintEdit::new(b, Color::TRANSPARENT),
    ];
    assert_eq!(
        canvas.prepare_paint(&rejected).err().unwrap().reason,
        PaintErrorKind::AlphaChanged
    );
    assert_eq!(canvas.try_pixels().unwrap(), before);
    canvas
        .prepare_slots(&[SlotEdit::new(slot, PaintColor::new(Color::WHITE))])
        .unwrap()
        .commit();
    assert_eq!(
        canvas.try_pixels().unwrap(),
        oracle(
            ColorConfig::default(),
            [original, original, Color::WHITE, original]
        )
    );
    canvas
        .prepare_paint(&[PaintEdit::new(a, Color::WHITE)])
        .unwrap()
        .commit();
    assert_eq!(
        canvas.try_pixels().unwrap(),
        oracle(
            ColorConfig::default(),
            [Color::WHITE, original, Color::WHITE, original]
        )
    );
}
