//! Same source runs against the previous expanded list and the compact list.
//! Requested thread-local allocation deltas include all masks/lanes/hash tables.
use gpui_canvas::{Affine, Canvas, Color, ColorConfig, Point, Rect, TextSystem};
use std::{hint::black_box, time::Instant};
fn main() {
    let mode = std::env::args().nth(1).unwrap_or_else(|| "labels".into());
    let (content, runs) = match mode.as_str() {
        "labels" => ("office café AVATAR".into(), 48),
        "groups" => ("H".repeat(32), 1000),
        "singletons" => ("H".into(), 32000),
        "unique" => ("H".into(), 32000),
        _ => panic!("labels|groups|singletons|unique"),
    };
    let mut fonts = TextSystem::bundled().unwrap();
    let layout = fonts.shape(&content, 16.0, None).unwrap();
    let clip = Rect::new(0.0, 0.0, 640.0, 480.0);
    let mut warm = Canvas::recording(640, 480, ColorConfig::default()).unwrap();
    warm.draw_text(
        &mut fonts,
        &layout,
        Point::default(),
        Affine::IDENTITY,
        clip,
        Color::BLACK,
    )
    .unwrap();
    drop(warm);
    let mut canvas = Canvas::recording(640, 480, ColorConfig::default()).unwrap();
    let start = Instant::now();
    let prepared = allocation_counter::measure(|| {
        for i in 0..runs {
            let scale = if mode == "unique" {
                1.0 + i as f32 / 128000.0
            } else {
                1.0
            };
            let origin = if mode == "labels" {
                Point {
                    x: 4.0,
                    y: ((i / 3) * 26) as f32,
                }
            } else {
                Point {
                    x: (i % 8) as f32,
                    y: (i % 16) as f32,
                }
            };
            canvas
                .draw_text_scaled(
                    &mut fonts,
                    &layout,
                    origin,
                    Affine::IDENTITY,
                    clip,
                    Color::BLACK,
                    scale,
                )
                .unwrap();
        }
    });
    let prepare_ns = start.elapsed().as_nanos();
    let scene = canvas.prepared_scene();
    let draws = scene.draws().len();
    let start = Instant::now();
    let mut digest = 0_u64;
    for _ in 0..100 {
        for draw in scene.draws() {
            digest = digest
                .wrapping_mul(31)
                .wrapping_add(draw.local_rect.x.to_bits() as u64);
            if let Some(mask) = draw.mask {
                digest ^= mask.coverage.len() as u64;
            }
        }
    }
    let iteration_ns = start.elapsed().as_nanos() / 100;
    black_box(digest);
    let drop_scene = allocation_counter::measure(|| drop(canvas));
    println!(
        "mode,draws,prepare_ns,retained_new_bytes,peak_new_bytes,allocations,iteration_ns,drop_scene_bytes,digest,canvas_header_bytes"
    );
    println!(
        "{mode},{draws},{prepare_ns},{},{},{},{iteration_ns},{},{digest},{}",
        prepared.bytes_current,
        prepared.bytes_max,
        prepared.count_total,
        drop_scene.bytes_current,
        std::mem::size_of::<Canvas>()
    );
}
