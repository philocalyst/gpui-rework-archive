use gpui_canvas::{Affine, Canvas, Color, DamageRegion, DamageRegions, PaintColor, Rect, SlotEdit};
fn supports() -> Vec<DamageRegion> {
    let mut canvas = Canvas::recording(512, 64, Default::default()).unwrap();
    (0..80)
        .map(|i| {
            let slot = canvas.paint_slot(PaintColor::new(Color::BLACK)).unwrap();
            canvas
                .fill_rect_slot(
                    Rect::new(i as f32 * 6., 2., 2., 2.),
                    Affine::IDENTITY,
                    Rect::new(0., 0., 512., 64.),
                    slot,
                )
                .unwrap();
            canvas
                .prepare_slots(&[SlotEdit::new(slot, PaintColor::new(Color::WHITE))])
                .unwrap()
                .commit()
        })
        .collect()
}
#[test]
fn reset_reuses_bounded_capacity_and_restores_empty_one_many_and_overflow() {
    let support = supports();
    let mut regions = DamageRegions::default();
    regions.clear();
    assert_eq!(regions.regions(), DamageRegions::default().regions());
    regions.include(support[0]);
    regions.clear();
    assert!(regions.bounds().is_empty());
    for &s in &support[..3] {
        regions.include(s);
    }
    let address = regions.regions().as_ptr();
    assert_eq!(regions.regions().len(), 3);
    let cost = allocation_counter::measure(|| {
        for _ in 0..64 {
            regions.clear();
            assert_eq!(regions.regions(), DamageRegions::default().regions());
            for &s in &support[..3] {
                regions.include(s);
            }
            assert_eq!(regions.regions().as_ptr(), address);
            assert_eq!(regions.regions().len(), 3);
            assert_eq!(regions.pixels(), 12);
        }
    });
    assert_eq!(cost.count_total, 0);
    assert_eq!(cost.bytes_total, 0);
    for &s in &support {
        regions.include(s);
    }
    assert_eq!(regions.regions().len(), 1);
    regions.clear();
    assert!(regions.bounds().is_empty());
    regions.include(support[0]);
    regions.include(support[1]);
    assert_eq!(
        regions.regions().len(),
        2,
        "overflow must not poison a new operation"
    );
    assert_eq!(regions.pixels(), 8);
}
