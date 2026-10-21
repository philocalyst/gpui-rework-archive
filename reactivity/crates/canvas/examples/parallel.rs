//! cargo run --release -p gpui_canvas --features parallel --example parallel
use gpui_canvas::{Affine, Canvas, Color, Point, Rect, RenderPool, TextLayout, TextSystem};
use std::{hint::black_box, time::Instant};

fn scene(canvas: &mut Canvas, text: &mut TextSystem, label: &TextLayout, kind: &str) {
    canvas.clear(Color::WHITE);
    let clip = Rect::new(0., 0., canvas.width() as f32, canvas.height() as f32);
    match kind {
        "flat" | "large_flat" => canvas
            .fill_rect(
                Rect::new(-2., -2., clip.width + 4., clip.height + 4.),
                Affine::IDENTITY,
                clip,
                Color::rgb(30, 80, 190),
            )
            .unwrap(),
        "labels" => {
            for i in 0..48 {
                canvas
                    .draw_text(
                        text,
                        label,
                        Point {
                            x: 12. + (i % 3) as f32 * 208.,
                            y: 8. + (i / 3) as f32 * 29.,
                        },
                        Affine::IDENTITY,
                        clip,
                        Color::rgb(25, 35, 55),
                    )
                    .unwrap();
            }
        }
        "shear" => {
            for i in 0..48 {
                canvas
                    .fill_rect(
                        Rect::new(0., 0., 30., 18.),
                        Affine {
                            a: if i % 2 == 0 { -1. } else { 1. },
                            b: 0.18,
                            c: 0.45,
                            d: 1.,
                            tx: 20. + (i % 8) as f32 * 39.,
                            ty: 5. + (i / 8) as f32 * 37.,
                        },
                        clip,
                        Color::rgba(40, 70, 190, 170),
                    )
                    .unwrap();
            }
        }
        "boundary" => {
            for i in 0..4 {
                canvas
                    .fill_rect(
                        Rect::new(0.1 + i as f32 * 0.7, 0.2, 0.35, 20.5),
                        Affine::rotation(0.13),
                        clip,
                        Color::rgba(120, 30, 20, 180),
                    )
                    .unwrap();
            }
        }
        _ => unreachable!(),
    }
}
fn digest(bytes: &[u8]) -> u64 {
    bytes
        .iter()
        .fold(0u64, |hash, &b| hash.wrapping_mul(16777619) ^ b as u64)
}
fn main() {
    let mut text = TextSystem::bundled().unwrap();
    let label = text.shape("office café 012345", 16., None).unwrap();
    let pools: Vec<_> = [1, 2, 4, 8]
        .into_iter()
        .map(|n| RenderPool::new(n).unwrap().with_min_work(0))
        .collect();
    println!(
        "scene,workers,median_frame_us,digest,parallel,commands,refs,samples,output_bytes,command_bytes,bin_bytes,mask_payload"
    );
    for (kind, width, height, batch) in [
        ("flat", 640, 360, 10),
        ("large_flat", 1920, 1080, 3),
        ("labels", 640, 480, 1),
        ("shear", 320, 240, 3),
        ("boundary", 4, 32, 50),
    ] {
        let mut expected = None;
        for (workers, pool) in
            std::iter::once((0, None)).chain(pools.iter().map(|p| (p.workers(), Some(p))))
        {
            let mut canvas = Canvas::new(width, height).unwrap();
            scene(&mut canvas, &mut text, &label, kind);
            let first = match pool {
                Some(pool) => canvas.pixels_with(pool),
                None => canvas.pixels(),
            };
            let hash = digest(first);
            if let Some(expected) = expected {
                assert_eq!(hash, expected)
            } else {
                expected = Some(hash)
            }
            let mut times = Vec::new();
            for _ in 0..7 {
                let start = Instant::now();
                for _ in 0..batch {
                    scene(&mut canvas, &mut text, &label, kind);
                    black_box(match pool {
                        Some(pool) => canvas.pixels_with(pool),
                        None => canvas.pixels(),
                    });
                }
                times.push(start.elapsed().as_secs_f64() * 1e6 / batch as f64);
            }
            times.sort_by(f64::total_cmp);
            let s = canvas.stats();
            println!(
                "{kind},{workers},{:.3},{hash},{},{},{},{},{},{},{},{}",
                times[3],
                s.parallel,
                s.commands,
                s.tile_references,
                s.sample_tests,
                canvas.output_bytes(),
                s.command_bytes,
                s.bin_bytes,
                s.retained_mask_bytes
            );
        }
    }
}
