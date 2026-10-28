//! Serialized native-backend wall time, not a GPU timestamp measurement.
#[path = "../tests/support/adapter.rs"]
mod test_adapter;
use gpui_canvas::{Affine, Canvas, Color, ColorConfig, Point, Rect, TextSystem};
use gpui_gpu::{Renderer, wgpu};
use std::time::Instant;

fn scene(case: &str) -> Canvas {
    let viewport = Rect::new(0.0, 0.0, 512.0, 256.0);
    let mut canvas = Canvas::recording(512, 256, ColorConfig::default()).unwrap();
    canvas.clear(Color::WHITE);
    match case {
        "flat" | "overlap32" | "text" => {
            let count = if case == "overlap32" { 32 } else { 1 };
            for n in 0..count {
                canvas
                    .fill_rect(
                        viewport,
                        Affine::IDENTITY,
                        viewport,
                        Color::rgb(80 + n * 3, 100, 140),
                    )
                    .unwrap();
            }
            if case == "text" {
                let mut fonts = TextSystem::bundled().unwrap();
                let run = fonts.shape("office café label", 16.0, None).unwrap();
                for row in 0..8 {
                    for column in 0..3 {
                        canvas
                            .draw_text(
                                &mut fonts,
                                &run,
                                Point {
                                    x: 8.0 + column as f32 * 168.0,
                                    y: 4.0 + row as f32 * 30.0,
                                },
                                Affine::IDENTITY,
                                viewport,
                                Color::BLACK,
                            )
                            .unwrap();
                    }
                }
            }
        }
        "boundary" => {
            for row in 0..32 {
                canvas
                    .fill_rect(
                        Rect::new(0.125, row as f32 * 8.0 + 0.125, 511.75, 0.25),
                        Affine::IDENTITY,
                        viewport,
                        Color::rgb(30, 90, 160),
                    )
                    .unwrap();
            }
        }
        _ => panic!("unknown case"),
    }
    canvas
}

async fn measure(case: &str, proofs: bool) {
    let canvas = scene(case);
    let (_, adapter) = test_adapter::request().await;
    eprintln!("{case}/{proofs}: {:?}", adapter.get_info());
    let mut renderer = Renderer::request(&adapter, wgpu::TextureFormat::Rgba8UnormSrgb)
        .await
        .unwrap();
    renderer.set_tile_proofs(proofs);
    let texture = renderer.device().create_texture(&wgpu::TextureDescriptor {
        label: None,
        size: wgpu::Extent3d {
            width: 512,
            height: 256,
            depth_or_array_layers: 1,
        },
        mip_level_count: 1,
        sample_count: 1,
        dimension: wgpu::TextureDimension::D2,
        format: renderer.format(),
        usage: wgpu::TextureUsages::RENDER_ATTACHMENT,
        view_formats: &[],
    });
    let view = texture.create_view(&Default::default());
    let mut times = Vec::new();
    let mut submit_times = Vec::new();
    for frame in 0..12 {
        let start = Instant::now();
        renderer.render(canvas.prepared_scene(), &view).unwrap();
        let submitted = start.elapsed().as_secs_f64() * 1e6;
        renderer
            .device()
            .poll(wgpu::PollType::wait_indefinitely())
            .unwrap();
        if frame >= 3 {
            times.push(start.elapsed().as_secs_f64() * 1e6);
            submit_times.push(submitted);
        }
    }
    times.sort_by(f64::total_cmp);
    submit_times.sort_by(f64::total_cmp);
    assert_eq!(canvas.output_bytes(), 0);
    let peak_rss = std::fs::read_to_string("/proc/self/status")
        .ok()
        .and_then(|status| {
            status.lines().find_map(|line| {
                line.strip_prefix("VmHWM:")
                    .and_then(|value| value.split_whitespace().next()?.parse::<usize>().ok())
            })
        })
        .unwrap_or(0);
    let s = renderer.stats();
    println!(
        "{case},{proofs},{:.3},{:.3},{},{},{},{},{},{},{},{},{},{},{},{},{}",
        times[times.len() / 2],
        submit_times[submit_times.len() / 2],
        s.draws,
        s.original_tile_references,
        s.tile_references,
        s.uniform_tiles,
        s.sample_evaluations,
        s.sample_draw_evaluations,
        s.instance_upload_bytes,
        s.gpu_buffer_bytes,
        s.atlas_bytes,
        s.cpu_index_capacity_bytes,
        s.correction_key_capacity,
        512 * 256 * 4,
        peak_rss
    );
}

fn main() {
    let args: Vec<_> = std::env::args().skip(1).collect();
    if args.len() == 2 {
        pollster::block_on(measure(&args[0], args[1].parse().unwrap()));
        return;
    }
    assert!(
        args.is_empty(),
        "expected either no arguments or case/proofs"
    );
    println!(
        "case,proofs,median_wall_us,median_host_submit_us,draws,original_refs,sampled_refs,uniform_tiles,lattice_samples,sample_draw_calls,upload_bytes,gpu_buffer_bytes,atlas_bytes,cpu_vector_capacity_bytes,correction_key_capacity,target_bytes,process_peak_rss_kib"
    );
}
