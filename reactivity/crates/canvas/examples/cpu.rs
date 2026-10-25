//! cargo run --release -p gpui_canvas --example cpu -- [optional-output.ppm]
use gpui_canvas::{Affine, Canvas, Color, Point, Rect, TextLayout, TextSystem};
use std::{hint::black_box, io::Write, time::Instant};

fn scene(canvas: &mut Canvas, text: &mut TextSystem, label: &TextLayout, name: &str) {
    canvas.clear(Color::rgb(248, 249, 252));
    let clip = Rect::new(0.0, 0.0, canvas.width() as f32, canvas.height() as f32);
    match name {
        "flat" => canvas
            .fill_rect(
                Rect::new(-1.0, -1.0, 642.0, 362.0),
                Affine::IDENTITY,
                clip,
                Color::rgb(40, 90, 180),
            )
            .unwrap(),
        "opaque_overlap" | "alpha_overlap" => {
            for i in 0..32 {
                let alpha = if name == "opaque_overlap" { 255 } else { 90 };
                canvas
                    .fill_rect(
                        Rect::new(-2.0, -2.0, 132.0, 100.0),
                        Affine::IDENTITY,
                        clip,
                        Color::rgba(i * 7, 180, 220 - i * 3, alpha),
                    )
                    .unwrap();
            }
        }
        "sheared" => {
            for i in 0..48 {
                canvas
                    .fill_rect(
                        Rect::new(0.0, 0.0, 30.0, 18.0),
                        Affine {
                            a: if i % 2 == 0 { -1.0 } else { 1.0 },
                            b: 0.18,
                            c: 0.45,
                            d: 1.0,
                            tx: 20.0 + (i % 8) as f32 * 39.0,
                            ty: 5.0 + (i / 8) as f32 * 37.0,
                        },
                        clip,
                        Color::rgba(40, 70, 190, 170),
                    )
                    .unwrap();
            }
        }
        "labels" => {
            for i in 0..48 {
                let origin = Point {
                    x: 12.0 + (i % 3) as f32 * 208.0,
                    y: 8.0 + (i / 3) as f32 * 29.0,
                };
                canvas
                    .draw_text(
                        text,
                        label,
                        origin,
                        Affine::IDENTITY,
                        clip,
                        Color::rgb(25, 35, 55),
                    )
                    .unwrap();
            }
        }
        "boundary_dense" => {
            for i in 0..4 {
                canvas
                    .fill_rect(
                        Rect::new(0.1 + i as f32 * 0.7, 0.2, 0.35, 3.5),
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
fn main() {
    let before = rss_kib();
    let start = Instant::now();
    let mut text = TextSystem::bundled().unwrap();
    println!("font_init_us={}", start.elapsed().as_micros());
    println!(
        "font_instances=1,rss_before_font_kib={before:?},rss_after_font_kib={:?},color_header_bytes={},glyph_record_bytes={},layout_header_bytes={}",
        rss_kib(),
        std::mem::size_of::<Color>(),
        std::mem::size_of::<gpui_canvas::Glyph>(),
        std::mem::size_of::<TextLayout>()
    );
    let start = Instant::now();
    let label = text.shape("office café 012345", 16.0, None).unwrap();
    println!(
        "shape_us={},glyphs={},width={},height={},baseline={}",
        start.elapsed().as_micros(),
        label.glyphs().len(),
        label.width,
        label.height,
        label.baseline
    );
    println!(
        "scene,proofs,median_frame_us,commands,tile_refs,full_rect_tiles,skipped_command_tiles,boundary_pixels,sample_tests,command_capacity_bytes,bin_capacity_bytes,retained_mask_payload,cache_mask_payload,rgba_bytes"
    );
    for (name, width, height, batch) in [
        ("flat", 640, 360, 1),
        ("opaque_overlap", 128, 96, 1),
        ("alpha_overlap", 128, 96, 1),
        ("sheared", 320, 240, 1),
        ("labels", 640, 480, 1),
        ("boundary_dense", 4, 4, 200),
    ] {
        for proofs in [false, true] {
            let mut canvas = Canvas::new(width, height).unwrap();
            canvas.set_tile_proofs(proofs);
            scene(&mut canvas, &mut text, &label, name);
            black_box(canvas.pixels());
            let mut times = Vec::new();
            for _ in 0..3 {
                let start = Instant::now();
                for _ in 0..batch {
                    scene(&mut canvas, &mut text, &label, name);
                    black_box(canvas.pixels());
                }
                times.push(start.elapsed().as_secs_f64() * 1e6 / batch as f64);
            }
            times.sort_by(f64::total_cmp);
            let s = canvas.stats();
            println!(
                "{name},{proofs},{:.3},{},{},{},{},{},{},{},{},{},{},{}",
                times[1],
                s.commands,
                s.tile_references,
                s.full_rect_tiles,
                s.skipped_command_tiles,
                s.boundary_pixels,
                s.sample_tests,
                s.command_bytes,
                s.bin_bytes,
                s.retained_mask_bytes,
                text.cache_bytes(),
                width * height * 4
            );
            if name == "labels"
                && proofs
                && let Some(path) = std::env::args().nth(1)
            {
                let mut file = std::fs::File::create(path).unwrap();
                write!(file, "P6\n{width} {height}\n255\n").unwrap();
                for rgba in canvas.pixels().as_chunks::<4>().0.iter() {
                    file.write_all(&rgba[..3]).unwrap();
                }
            }
        }
    }
}
fn rss_kib() -> Option<usize> {
    let status = std::fs::read_to_string("/proc/self/status").ok()?;
    status
        .lines()
        .find(|line| line.starts_with("VmRSS:"))?
        .split_whitespace()
        .nth(1)?
        .parse()
        .ok()
}
