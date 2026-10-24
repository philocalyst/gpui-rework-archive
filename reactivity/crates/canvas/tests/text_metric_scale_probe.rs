use gpui_canvas::{Affine, Canvas, Color, ColorConfig, Point, Rect, TextLayout, TextSystem};
use std::{hint::black_box, time::Instant};

const CLIP: Rect = Rect::new(0., 0., 320., 192.);
fn submit(
    canvas: &mut Canvas,
    text: &mut TextSystem,
    layouts: &[TextLayout],
    labels: usize,
    solids: usize,
    clipped: bool,
    raster_scale: f32,
) {
    for row in 0..solids {
        canvas
            .fill_rect(
                Rect::new((row % 16) as f32 * 19., (row / 16) as f32 * 19., 9., 9.),
                Affine::IDENTITY,
                CLIP,
                Color::BLACK,
            )
            .unwrap();
    }
    for row in 0..labels {
        let layout = &layouts[row % layouts.len()];
        canvas
            .draw_text_scaled(
                text,
                layout,
                Point {
                    x: if clipped { 1000. } else { 2.25 },
                    y: (row % 12) as f32 * 14.,
                },
                Affine::IDENTITY,
                CLIP,
                Color::WHITE,
                raster_scale,
            )
            .unwrap();
    }
}
fn expansion(canvas: &Canvas) -> u64 {
    let mut value = 0u64;
    // Material classification, packet writing, forward/backward CSR passes.
    for pass in 0..5 {
        for group in canvas.prepared_scene().groups() {
            if pass == 4 {
                for p in group.placements().rev() {
                    value = value.wrapping_add(
                        u64::from(black_box(p.local_rect.x).to_bits())
                            + u64::from(p.bounds.width.to_bits()),
                    );
                }
            } else {
                for p in group.placements() {
                    value = value.wrapping_add(
                        u64::from(black_box(p.local_rect.y).to_bits())
                            + u64::from(p.bounds.height.to_bits()),
                    );
                }
            }
        }
    }
    black_box(value)
}
#[test]
fn retained_text_metric_scale_cost_and_work_probe() {
    let mut text = TextSystem::bundled().unwrap();
    let face = text.font_face().clone();
    let mut shaper = face.shaper();
    drop(shaper.shape("warm", 12., None).unwrap());
    for raster_scale in [1.0, 2.0, 1.25] {
        for (name, source, labels, solids, clipped, unique) in [
            ("blank", "", 0, 0, false, false),
            ("solids32", "", 0, 32, false, false),
            ("empty32", "", 32, 0, false, false),
            ("single32", "H", 32, 0, false, false),
            ("pair32", "Hi", 32, 0, false, false),
            ("empty_independent32", "", 32, 0, false, false),
            ("single_independent32", "H", 32, 0, false, false),
            ("pair_independent32", "Hi", 32, 0, false, false),
            ("triple_independent32", "Hip", 32, 0, false, false),
            ("triple32", "Hip", 32, 0, false, false),
            (
                "labels32",
                "office café repeated labels",
                32,
                0,
                false,
                false,
            ),
            (
                "labels_borrowed32",
                "office café repeated labels",
                32,
                0,
                false,
                false,
            ),
            (
                "unique32",
                "office café repeated labels",
                32,
                0,
                false,
                true,
            ),
            ("bidi32", "office e\u{301} אבג مرحبا", 32, 0, false, true),
            (
                "clipped32",
                "office café repeated labels",
                32,
                0,
                true,
                true,
            ),
            (
                "mixed32",
                "office café repeated labels",
                32,
                32,
                false,
                false,
            ),
        ] {
            let owners = if name.contains("borrowed") { 1 } else { labels };
            let mut layouts = Vec::with_capacity(owners);
            let sources: Vec<_> = (0..labels)
                .map(|row| {
                    if unique {
                        format!("{source}{row}")
                    } else {
                        source.to_string()
                    }
                })
                .collect();
            let shape = allocation_counter::measure(|| {
                for (row, source) in sources.iter().take(owners).enumerate() {
                    if row == 0 || unique || name.contains("independent") {
                        layouts.push(shaper.shape(source, 12., None).unwrap());
                    } else {
                        layouts.push(layouts[0].clone());
                    }
                }
            });
            // Cache warm-up is outside scene admission measurements.
            let mut warm = Canvas::recording(320, 192, ColorConfig::default()).unwrap();
            submit(
                &mut warm,
                &mut text,
                &layouts,
                labels,
                solids,
                clipped,
                raster_scale,
            );
            drop(warm);
            let mut canvas = Canvas::recording(320, 192, ColorConfig::default()).unwrap();
            canvas.clear(Color::BLACK);
            let cold = allocation_counter::measure(|| {
                submit(
                    &mut canvas,
                    &mut text,
                    &layouts,
                    labels,
                    solids,
                    clipped,
                    raster_scale,
                )
            });
            let storage = canvas.prepared_scene().storage();
            let count = canvas.prepared_scene().draws().len();
            canvas.clear(Color::BLACK);
            let warm = allocation_counter::measure(|| {
                submit(
                    &mut canvas,
                    &mut text,
                    &layouts,
                    labels,
                    solids,
                    clipped,
                    raster_scale,
                )
            });
            assert_eq!((warm.count_total, warm.bytes_total), (0, 0));
            let mut pixels = vec![0u32; 320 * 192];
            canvas.render_bgrx(&mut pixels).unwrap();
            let stats = canvas.stats();
            let mut prepare_times = Vec::new();
            let mut render_times = Vec::new();
            let mut expand_times = Vec::new();
            for _ in 0..7 {
                let t = Instant::now();
                for _ in 0..80 {
                    canvas.clear(Color::BLACK);
                    submit(
                        &mut canvas,
                        &mut text,
                        &layouts,
                        labels,
                        solids,
                        clipped,
                        raster_scale,
                    );
                }
                prepare_times.push(t.elapsed().as_nanos() / 80);
                let t = Instant::now();
                for _ in 0..12 {
                    canvas.render_bgrx(black_box(&mut pixels)).unwrap();
                }
                render_times.push(t.elapsed().as_nanos() / 12);
                let t = Instant::now();
                for _ in 0..80 {
                    black_box(expansion(&canvas));
                }
                expand_times.push(t.elapsed().as_nanos() / 80);
            }
            prepare_times.sort();
            render_times.sort();
            expand_times.sort();
            println!(
                "METRIC_RUN case={name} scale={raster_scale} draws={count} layout_header={} shape_allocs={} shape_requested={} shape_live={} scene_allocs={} scene_requested={} scene_live={} scene_peak={} header={} lanes={} order={} inline={} common={} placements={} handles={} index={} bin_bytes={} tile_refs={} sample_tests={} prepare_ns={} render_ns={} expansion_ns={} expansion_hash={}",
                size_of::<TextLayout>(),
                shape.count_total,
                shape.bytes_total,
                shape.bytes_current,
                cold.count_total,
                cold.bytes_total,
                cold.bytes_current,
                cold.bytes_max,
                storage.header_bytes,
                storage.lane_bytes(),
                storage.order_bytes,
                storage.inline_bytes,
                storage.common_bytes,
                storage.placement_bytes,
                storage.resource_handles_bytes,
                storage.resource_index_capacity,
                stats.bin_bytes,
                stats.tile_references,
                stats.sample_tests,
                prepare_times[3],
                render_times[3],
                expand_times[3],
                expansion(&canvas)
            );
        }
    }
}
