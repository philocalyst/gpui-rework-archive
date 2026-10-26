use gpui_canvas::{Affine, Canvas, Color, ColorConfig, Point, Rect, TextSystem};

#[test]
fn repeated_labels_keep_batched_capacity_and_allocate_nothing_when_warm() {
    let mut text = TextSystem::bundled().unwrap();
    let layout = text
        .shape("office café repeated labels", 12.0, None)
        .unwrap();
    let clip = Rect::new(0.0, 0.0, 320.0, 192.0);
    for (labels, batched_bytes) in [(32, 22_528), (48, 45_056), (64, 45_056), (96, 90_112)] {
        let mut canvas = Canvas::recording(320, 192, ColorConfig::default()).unwrap();
        let mut submit = |canvas: &mut Canvas| {
            for row in 0..labels {
                canvas
                    .draw_text(
                        &mut text,
                        &layout,
                        Point {
                            x: 2.25,
                            y: (row % 12) as f32 * 14.0,
                        },
                        Affine::IDENTITY,
                        clip,
                        Color::WHITE,
                    )
                    .unwrap();
            }
        };
        submit(&mut canvas);
        let storage = canvas.prepared_scene().storage();
        println!(
            "labels={labels} placement_bytes={} batched_bytes={batched_bytes}",
            storage.placement_bytes
        );
        assert!(storage.placement_bytes <= batched_bytes);
        canvas.clear(Color::TRANSPARENT);
        let allocation = allocation_counter::measure(|| submit(&mut canvas));
        assert_eq!(allocation.count_total, 0);
        assert_eq!(allocation.bytes_total, 0);
    }
}
