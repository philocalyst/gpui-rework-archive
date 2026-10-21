//! Compare two borrowed views of the SAME canonical production scene.
use gpui_canvas::{Affine, Canvas, Color, ColorConfig, Point, Rect, TextSystem};
use std::{hint::black_box, time::Instant};
fn main() {
    let mut text = TextSystem::bundled().unwrap();
    let layout = text.shape(&"H".repeat(32), 16.0, None).unwrap();
    let mut canvas = Canvas::recording(640, 480, ColorConfig::default()).unwrap();
    let clip = Rect::new(0.0, 0.0, 640.0, 480.0);
    for i in 0..1000 {
        canvas
            .draw_text(
                &mut text,
                &layout,
                Point {
                    x: (i % 8) as f32,
                    y: (i % 16) as f32,
                },
                Affine::IDENTITY,
                clip,
                Color::BLACK,
            )
            .unwrap();
    }
    let scene = canvas.prepared_scene();
    let mut expected = 0_u64;
    let start = Instant::now();
    for _ in 0..100 {
        let mut digest = 0_u64;
        for draw in scene.draws() {
            digest = digest
                .wrapping_mul(31)
                .wrapping_add(draw.local_rect.x.to_bits() as u64);
            if let Some(mask) = draw.mask {
                digest ^= mask.coverage.len() as u64;
            }
        }
        expected = black_box(digest);
    }
    let flat_ns = start.elapsed().as_nanos() / 100;
    let start = Instant::now();
    for _ in 0..100 {
        let mut digest = 0_u64;
        for group in scene.groups() {
            for p in group.placements() {
                digest = digest
                    .wrapping_mul(31)
                    .wrapping_add(p.local_rect.x.to_bits() as u64);
                if let Some(mask) = p.mask {
                    digest ^= mask.coverage.len() as u64;
                }
            }
        }
        assert_eq!(black_box(digest), expected);
    }
    let group_ns = start.elapsed().as_nanos() / 100;
    println!(
        "flat_ns={flat_ns},group_ns={group_ns},draws={},groups={},masks={},storage={:?},digest={expected}",
        scene.draws().len(),
        scene.groups().len(),
        scene.masks().len(),
        scene.storage()
    );
}
