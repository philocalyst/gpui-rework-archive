use gpui_canvas::{
    Affine, Canvas, Color, ColorConfig, PaintColor, PaintEdit, Point, Rect, SlotEdit,
    SlotErrorKind, TextSystem,
};

fn draw(canvas: &mut Canvas, shared: bool, color: Color) -> Option<gpui_canvas::PaintSlot> {
    let slot = shared.then(|| canvas.paint_slot(PaintColor::new(color)).unwrap());
    let clip = Rect::new(0.125, 0.375, 62.5, 47.0);
    for i in 0..13 {
        let rect = Rect::new(0.125, 0.375, 15.5, 11.25);
        let map = Affine {
            a: if i & 1 == 0 { 1.0 } else { -1.0 },
            b: 0.125,
            c: -0.25,
            d: 1.0,
            tx: 5.0 + (i % 4) as f32 * 13.0,
            ty: (i / 4) as f32 * 11.0,
        };
        if let Some(slot) = slot {
            canvas
                .fill_rounded_rect_slot(rect, 3.25, map, clip, slot)
                .unwrap();
        } else {
            canvas
                .fill_rounded_rect(rect, 3.25, map, clip, color)
                .unwrap();
        }
    }
    let mut text = TextSystem::bundled().unwrap();
    let layout = text.shape("café אב", 12.0, None).unwrap();
    if let Some(slot) = slot {
        canvas
            .draw_text_scaled_slot(
                &mut text,
                &layout,
                Point { x: 2.0, y: 3.0 },
                Affine::IDENTITY,
                clip,
                slot,
                1.25,
            )
            .unwrap();
    } else {
        canvas
            .draw_text_scaled(
                &mut text,
                &layout,
                Point { x: 2.0, y: 3.0 },
                Affine::IDENTITY,
                clip,
                color,
                1.25,
            )
            .unwrap();
    }
    slot
}

#[test]
fn shared_slot_matches_full_literal_oracle_after_each_transaction() {
    for config in [
        ColorConfig::default(),
        ColorConfig::linear_hdr(gpui_canvas::OutputProfile::DisplayP3, 203.0).unwrap(),
    ] {
        let mut shared = Canvas::with_color_config(64, 48, config).unwrap();
        shared.clear(Color::WHITE);
        let slot = draw(&mut shared, true, Color::rgba(255, 0, 0, 128)).unwrap();
        for color in [
            Color::rgba(0, 255, 0, 128),
            Color::linear_srgb(-0.125, 2.0, 0.25, 128.0 / 255.0).unwrap(),
            Color::rgba(255, 0, 0, 128),
        ] {
            let edits = [SlotEdit::new(slot, PaintColor::new(color))];
            let plan = shared.prepare_slots(&edits).unwrap();
            assert_eq!(plan.changed_slots(), 1);
            assert!(!plan.damage().is_empty());
            plan.commit();
            let mut literal = Canvas::with_color_config(64, 48, config).unwrap();
            literal.clear(Color::WHITE);
            draw(&mut literal, false, color);
            assert_eq!(shared.try_pixels().unwrap(), literal.try_pixels().unwrap());
        }
    }
}

#[test]
fn transaction_rejection_and_drop_leave_complete_bank_untouched() {
    let mut canvas = Canvas::new(32, 16).unwrap();
    canvas.clear(Color::WHITE);
    let a = canvas.paint_slot(PaintColor::new(Color::BLACK)).unwrap();
    let b = canvas.paint_slot(PaintColor::new(Color::BLACK)).unwrap();
    assert_ne!(a, b);
    let clip = Rect::new(0.0, 0.0, 32.0, 16.0);
    canvas
        .fill_rect_slot(Rect::new(0.0, 0.0, 16.0, 16.0), Affine::IDENTITY, clip, a)
        .unwrap();
    canvas
        .fill_rect_slot(Rect::new(16.0, 0.0, 16.0, 16.0), Affine::IDENTITY, clip, b)
        .unwrap();
    let before = canvas.try_pixels().unwrap().to_vec();
    let edits = [
        SlotEdit::new(a, PaintColor::new(Color::WHITE)),
        SlotEdit::new(b, PaintColor::new(Color::TRANSPARENT)),
    ];
    assert_eq!(
        canvas.prepare_slots(&edits).err().unwrap().reason,
        SlotErrorKind::AlphaChanged
    );
    assert_eq!(canvas.try_pixels().unwrap(), before);
    let edits = [SlotEdit::new(a, PaintColor::new(Color::WHITE))];
    {
        let _uncommitted = canvas.prepare_slots(&edits).unwrap();
    }
    assert_eq!(canvas.try_pixels().unwrap(), before);
    canvas.prepare_slots(&edits).unwrap().commit();
    let pixels = canvas.try_pixels().unwrap();
    assert_eq!(&pixels[..4], &[255, 255, 255, 255]);
    assert_eq!(&pixels[16 * 4..16 * 4 + 4], &[0, 0, 0, 255]);
}

#[test]
fn legacy_positional_edit_detaches_only_that_common_from_shared_slot() {
    let mut canvas = Canvas::new(32, 16).unwrap();
    let clip = Rect::new(0.0, 0.0, 32.0, 16.0);
    let slot = canvas.paint_slot(PaintColor::new(Color::BLACK)).unwrap();
    let cursor = canvas.paint_cursor();
    canvas
        .fill_rect_slot(
            Rect::new(0.0, 0.0, 16.0, 16.0),
            Affine::IDENTITY,
            clip,
            slot,
        )
        .unwrap();
    let index = canvas.paint_index(cursor).unwrap();
    canvas
        .fill_rect_slot(
            Rect::new(16.0, 0.0, 16.0, 16.0),
            Affine::IDENTITY,
            clip,
            slot,
        )
        .unwrap();
    canvas
        .prepare_paint(&[PaintEdit::new(index, Color::rgb(255, 0, 0))])
        .unwrap()
        .commit();
    canvas
        .prepare_slots(&[SlotEdit::new(slot, PaintColor::new(Color::rgb(0, 255, 0)))])
        .unwrap()
        .commit();
    let pixels = canvas.try_pixels().unwrap();
    assert_eq!(&pixels[..4], &[255, 0, 0, 255]);
    assert_eq!(&pixels[16 * 4..16 * 4 + 4], &[0, 255, 0, 255]);
}

#[test]
fn equal_legacy_edit_of_nondefault_shared_paint_is_infallible_without_allocation() {
    let mut canvas = Canvas::new(16, 16).unwrap();
    let color = Color::rgb(23, 45, 67);
    let slot = canvas.paint_slot(PaintColor::new(color)).unwrap();
    let clip = Rect::new(0.0, 0.0, 16.0, 16.0);
    let cursor = canvas.paint_cursor();
    canvas
        .fill_rect_slot(clip, Affine::IDENTITY, clip, slot)
        .unwrap();
    let index = canvas.paint_index(cursor).unwrap();
    let edits = [PaintEdit::new(index, color)];
    let plan = canvas.prepare_paint(&edits).unwrap();
    assert_eq!(plan.changed_groups(), 0);
    let allocation = allocation_counter::measure(|| {
        plan.commit();
    });
    assert_eq!(allocation.count_total, 0);
}

#[test]
fn equal_positional_set_detaches_from_future_shared_color_edits() {
    let mut canvas = Canvas::new(32, 16).unwrap();
    let color = Color::rgb(23, 45, 67);
    let slot = canvas.paint_slot(PaintColor::new(color)).unwrap();
    let clip = Rect::new(0.0, 0.0, 32.0, 16.0);
    let cursor = canvas.paint_cursor();
    canvas
        .fill_rect_slot(
            Rect::new(0.0, 0.0, 16.0, 16.0),
            Affine::IDENTITY,
            clip,
            slot,
        )
        .unwrap();
    let index = canvas.paint_index(cursor).unwrap();
    canvas
        .fill_rect_slot(
            Rect::new(16.0, 0.0, 16.0, 16.0),
            Affine::IDENTITY,
            clip,
            slot,
        )
        .unwrap();
    let edits = [PaintEdit::new(index, color)];
    let plan = canvas.prepare_paint(&edits).unwrap();
    assert_eq!(plan.changed_groups(), 0);
    let allocation = allocation_counter::measure(|| {
        plan.commit();
    });
    assert_eq!(allocation.count_total, 0);
    canvas
        .prepare_slots(&[SlotEdit::new(slot, PaintColor::new(Color::WHITE))])
        .unwrap()
        .commit();
    let pixels = canvas.try_pixels().unwrap();
    assert_eq!(&pixels[..4], &[23, 45, 67, 255]);
    assert_eq!(&pixels[16 * 4..16 * 4 + 4], &[255; 4]);
}

#[test]
fn deferred_shared_paints_allocate_no_bank_for_empty_geometry_or_clipped_glyphs() {
    let mut canvas = Canvas::recording(32, 32, ColorConfig::default()).unwrap();
    let initial = PaintColor::new(Color::BLACK);
    let clip = Rect::new(0.0, 0.0, 32.0, 32.0);
    let mut empty = None;
    let allocation = allocation_counter::measure(|| {
        for _ in 0..140_000 {
            canvas
                .fill_rounded_rect_shared(
                    Rect::new(0., 0., 0., 0.),
                    0.,
                    Affine::IDENTITY,
                    clip,
                    initial,
                    &mut empty,
                )
                .unwrap();
        }
    });
    assert_eq!((allocation.count_total, allocation.bytes_total), (0, 0));
    assert_eq!(empty, None);
    let mut text = TextSystem::bundled().unwrap();
    let layout = text.shape("ABC", 16.0, None).unwrap();
    let mut glyphs = None;
    canvas
        .draw_text_scaled_shared(
            &mut text,
            &layout,
            Point { x: 0., y: 0. },
            Affine::translation(1000., 1000.),
            clip,
            initial,
            &mut glyphs,
            1.,
        )
        .unwrap();
    assert_eq!(glyphs, None);
    assert_eq!(canvas.prepared_scene().paint_bank().len(), 0);
    assert_eq!(canvas.prepared_scene().draws().len(), 0);
    assert_eq!(canvas.prepared_scene().storage().common_bytes, 0);
}
