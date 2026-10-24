//! Serialized native-backend wall time, not GPU timestamps. Separate process per schema.
#[path = "../tests/support/adapter.rs"]
mod test_adapter;
use gpui_canvas::{Affine, Canvas, Color, ColorConfig, Point, Rect, TextSystem};
use gpui_gpu::{Renderer, wgpu};
use std::time::Instant;
fn scene(case: &str) -> Canvas {
    let mut canvas = Canvas::recording(512, 256, ColorConfig::default()).unwrap();
    canvas.clear(Color::WHITE);
    let clip = Rect::new(0.0, 0.0, 512.0, 256.0);
    if case == "flat" {
        canvas
            .fill_rect(
                Rect::new(-1.0, -1.0, 514.0, 258.0),
                Affine::IDENTITY,
                clip,
                Color::rgb(30, 80, 150),
            )
            .unwrap();
        return canvas;
    }
    let mut text = TextSystem::bundled().unwrap();
    let content = if case == "runs32k" {
        "H".repeat(32)
    } else if case == "singletons32k" {
        "H".into()
    } else {
        "office café label".into()
    };
    let layout = text.shape(&content, 16.0, None).unwrap();
    let count = match case {
        "runs32k" => 1000,
        "singletons32k" => 32000,
        "text" => 24,
        _ => panic!("flat|text|runs32k|singletons32k"),
    };
    for i in 0..count {
        let origin = if case == "text" {
            Point {
                x: 8.0 + (i % 3) as f32 * 168.0,
                y: 4.0 + (i / 3) as f32 * 30.0,
            }
        } else {
            Point {
                x: (i % 8) as f32,
                y: (i % 16) as f32,
            }
        };
        canvas
            .draw_text(
                &mut text,
                &layout,
                origin,
                Affine::IDENTITY,
                clip,
                Color::BLACK,
            )
            .unwrap();
    }
    if case != "text" {
        // Canonical records/upload still count. Opaque coverage prevents an
        // artificial 32K-overlap sample loop from dominating the packet measure.
        canvas
            .fill_rect(
                Rect::new(-1.0, -1.0, 514.0, 258.0),
                Affine::IDENTITY,
                clip,
                Color::rgb(30, 80, 150),
            )
            .unwrap();
    }
    canvas
}
async fn run(case: &str, grouped: bool) {
    let canvas = scene(case);
    let (_, adapter) = test_adapter::request().await;
    let mut renderer = Renderer::request(&adapter, wgpu::TextureFormat::Rgba8UnormSrgb)
        .await
        .unwrap();
    renderer.set_grouped_records(grouped);
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
    let mut wall = Vec::new();
    let mut host = Vec::new();
    for frame in 0..12 {
        let start = Instant::now();
        renderer.render(canvas.prepared_scene(), &view).unwrap();
        let submit = start.elapsed().as_secs_f64() * 1e6;
        renderer
            .device()
            .poll(wgpu::PollType::wait_indefinitely())
            .unwrap();
        if frame >= 3 {
            wall.push(start.elapsed().as_secs_f64() * 1e6);
            host.push(submit);
        }
    }
    wall.sort_by(f64::total_cmp);
    host.sort_by(f64::total_cmp);
    let s = renderer.stats();
    println!(
        "case,grouped,wall_us,host_us,draws,shared_groups,compact_draws,inline_draws,draw_record_bytes,total_upload_bytes,gpu_buffer_bytes,cpu_vector_bytes,atlas_bytes,sample_draw_calls"
    );
    println!(
        "{case},{grouped},{:.3},{:.3},{},{},{},{},{},{},{},{},{},{}",
        wall[4],
        host[4],
        s.draws,
        s.shared_groups,
        s.compact_draws,
        s.inline_draws,
        s.draw_record_bytes,
        s.instance_upload_bytes,
        s.gpu_buffer_bytes,
        s.cpu_index_capacity_bytes,
        s.atlas_bytes,
        s.sample_draw_evaluations
    );
}
fn main() {
    let args = std::env::args().skip(1).collect::<Vec<_>>();
    assert_eq!(args.len(), 2, "case grouped:true|false");
    pollster::block_on(run(&args[0], args[1].parse().unwrap()));
}
