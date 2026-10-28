//! Paired preparation + raster work. This excludes native upload/scanout and
//! models a small moving caret over a stable display list, not whole apps.
use gpui_canvas::{Affine, Canvas, CanvasScene, Color, ColorConfig, Rect};
use std::{hint::black_box, time::Instant};

const WIDTH: usize = 1280;
const HEIGHT: usize = 720;

fn describe(scene: &mut CanvasScene<'_>, count: usize, frame: usize) {
    let viewport = Rect::new(0.0, 0.0, WIDTH as f32, HEIGHT as f32);
    scene.clear(Color::WHITE);
    for i in 0..count {
        scene
            .fill_rect(
                Rect::new((i % 40 * 24) as f32, (i / 40 * 24) as f32, 13.0, 13.0),
                Affine::IDENTITY,
                viewport,
                Color::rgb(30, 90, 140),
            )
            .unwrap();
    }
    scene
        .fill_rect(
            Rect::new(1100.0 + (frame % 2) as f32, 650.0, 2.0, 17.0),
            Affine::IDENTITY,
            viewport,
            Color::BLACK,
        )
        .unwrap();
}

fn main() {
    println!(
        "draws,run,full_prepare_ns,repair_prepare_ns,full_raster_ns,repair_raster_ns,full_bins_bytes,repair_bins_bytes,repair_references,repair_bands,repair_allocations,repair_peak_new_bytes"
    );
    for count in [0, 64, 1000] {
        let canvas =
            || Canvas::recording(WIDTH as u32, HEIGHT as u32, ColorConfig::default()).unwrap();
        let (mut full, mut repair) = (canvas(), canvas());
        let (mut full_pixels, mut repair_pixels) =
            (vec![0; WIDTH * HEIGHT], vec![0; WIDTH * HEIGHT]);
        for frame in 0..12 {
            let mut preparation = [0; 2];
            let mut raster = [0; 2];
            let mut peak = 0;
            let mut allocations = 0;
            // Alternate order, separate retained canvases and output buffers.
            for index in [frame % 2, 1 - frame % 2] {
                let (canvas, pixels) = if index == 0 {
                    (&mut full, &mut full_pixels)
                } else {
                    (&mut repair, &mut repair_pixels)
                };
                let start = Instant::now();
                let mut candidate = canvas.stage();
                describe(&mut candidate, count, frame);
                let damage = if index == 0 {
                    candidate.commit();
                    None
                } else {
                    Some(candidate.commit_with_damage())
                };
                preparation[index] = start.elapsed().as_nanos();
                let start = Instant::now();
                let memory = allocation_counter::measure(|| {
                    if frame > 0
                        && let Some(damage) = damage
                    {
                        canvas.render_bgrx_region(pixels, damage).unwrap();
                    } else {
                        canvas.render_bgrx(pixels).unwrap();
                    }
                });
                raster[index] = start.elapsed().as_nanos();
                if index == 1 {
                    peak = memory.bytes_max;
                    allocations = memory.count_total;
                }
                black_box(&pixels);
            }
            assert_eq!(full_pixels, repair_pixels, "count {count}, frame {frame}");
            if frame > 0 {
                let stats = repair.stats();
                println!(
                    "{},{frame},{},{},{},{},{},{},{},{},{allocations},{peak}",
                    count + 1,
                    preparation[0],
                    preparation[1],
                    raster[0],
                    raster[1],
                    full.stats().bin_bytes,
                    stats.bin_bytes,
                    stats.tile_references,
                    stats.output_bands,
                );
            }
        }
    }
}
