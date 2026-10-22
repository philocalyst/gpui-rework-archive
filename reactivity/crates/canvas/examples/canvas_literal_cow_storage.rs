//! Untimed complete Canvas controls, including the cost after all aliases detach.
use gpui_canvas::{Affine, Canvas, Color, ColorConfig, PaintEdit, Rect};

fn color(mode: usize, index: usize) -> Color {
    match mode {
        0 => Color::BLACK,
        1 => Color::linear_srgb(0.25, 0.5, 0.75, 1.0).unwrap(),
        2 | 3 => {
            let value = if mode == 3 { index / 2 } else { index };
            Color::linear_srgb(0.25 + value as f32 / 8192.0, 0.5, 0.75, 1.0).unwrap()
        }
        4 => {
            let value = if index < 34 { index } else { 32 + index % 2 };
            Color::linear_srgb(0.25 + value as f32 / 8192.0, 0.5, 0.75, 1.0).unwrap()
        }
        _ => unreachable!(),
    }
}
fn main() {
    println!("count,mode,edits,allocations,requested,retained,peak,command_lanes,draws");
    for count in [0, 1, 4096] {
        for mode in 0..5 {
            for phase in 0..3 {
                let mut retained = None;
                let measured = allocation_counter::measure(|| {
                    let mut canvas = Canvas::recording(32, 32, ColorConfig::default()).unwrap();
                    canvas.clear(Color::WHITE);
                    let mut sites = Vec::with_capacity(count);
                    let rect = Rect::new(0.0, 0.0, 1.0, 1.0);
                    let clip = Rect::new(0.0, 0.0, 32.0, 32.0);
                    for index in 0..count {
                        let cursor = canvas.paint_cursor();
                        canvas
                            .fill_rect(rect, Affine::IDENTITY, clip, color(mode, index))
                            .unwrap();
                        sites.push(canvas.paint_index(cursor).unwrap());
                    }
                    if phase != 0 {
                        let edits = sites
                            .into_iter()
                            .enumerate()
                            .map(|(index, site)| {
                                PaintEdit::new(
                                    site,
                                    if phase == 1 {
                                        color(mode, index)
                                    } else {
                                        Color::linear_srgb(0.125, 0.5, 0.75, 1.0).unwrap()
                                    },
                                )
                            })
                            .collect::<Vec<_>>();
                        let plan = canvas.prepare_paint(&edits).unwrap();
                        plan.commit();
                    }
                    retained = Some(canvas);
                });
                let canvas = retained.unwrap();
                let scene = canvas.prepared_scene();
                println!(
                    "{count},{mode},{phase},{},{},{},{},{},{}",
                    measured.count_total,
                    measured.bytes_total,
                    measured.bytes_current,
                    measured.bytes_max,
                    scene.storage().lane_bytes(),
                    scene.draws().len()
                );
                std::hint::black_box(canvas);
            }
        }
    }
}
