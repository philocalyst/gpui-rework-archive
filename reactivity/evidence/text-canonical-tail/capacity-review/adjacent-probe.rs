use gpui_canvas::{Affine, Canvas, Color, ColorConfig, Point, Rect, TextLayout, TextSystem};
const CLIP: Rect = Rect::new(0.0, 0.0, 320.0, 192.0);

fn submit(canvas: &mut Canvas, text: &mut TextSystem, layout: &TextLayout, labels: usize, changed: bool) {
    canvas.clear(Color::TRANSPARENT);
    let delta = if changed { 0.375 } else { 0.0 };
    let transform = Affine::translation(delta, delta * -0.5);
    for row in 0..2 {
        canvas.fill_rect(Rect::new(1.0 + delta, row as f32 * 14.0, 60.0, 12.0), transform, CLIP,
            Color::rgba(31, 81, 191, 100)).unwrap();
    }
    for row in 0..labels {
        canvas.draw_text(text, layout, Point { x: 2.25, y: (row % 12) as f32 * 14.0 }, transform, CLIP,
            if changed { Color::rgba(193, 43, 91, 220) } else { Color::rgba(41, 93, 181, 220) }).unwrap();
    }
    canvas.fill_rect(Rect::new(42.0 + delta, 0.0, 1.0, 12.0), transform, CLIP, Color::WHITE).unwrap();
}

fn main() {
    let mut text = TextSystem::bundled().unwrap();
    let layout = text.shape("office café repeated labels", 12.0, None).unwrap();
    let mut cache_warm = Canvas::recording(320, 192, ColorConfig::default()).unwrap();
    submit(&mut cache_warm, &mut text, &layout, 1, false);
    for labels in [32, 48, 64, 96] {
        let mut canvas = Canvas::recording(320, 192, ColorConfig::default()).unwrap();
        let cold = allocation_counter::measure(|| submit(&mut canvas, &mut text, &layout, labels, false));
        let before = canvas.prepared_scene().storage();
        let update = allocation_counter::measure(|| submit(&mut canvas, &mut text, &layout, labels, true));
        let after = canvas.prepared_scene().storage();
        assert_eq!(before.placement_bytes, after.placement_bytes);
        println!("labels={labels} cold_count={} cold_bytes={} update_count={} update_bytes={} draws={} before={before:?} after={after:?}",
            cold.count_total, cold.bytes_total, update.count_total, update.bytes_total, canvas.prepared_scene().draws().len());
    }
}
