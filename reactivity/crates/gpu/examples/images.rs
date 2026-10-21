//! Serialized llvmpipe/Vulkan wall time; no discrete-GPU timestamp claim.
#[path = "../../canvas/examples/support/images.rs"]
mod fixture;
use gpui_gpu::{Renderer, wgpu};
use std::time::Instant;
fn main() {
    pollster::block_on(run());
}
async fn run() {
    let case = std::env::args().nth(1).unwrap_or_else(|| "one".into());
    let canvas = fixture::scene(&case);
    let mut descriptor = wgpu::InstanceDescriptor::new_without_display_handle();
    descriptor.backends = wgpu::Backends::VULKAN;
    let instance = wgpu::Instance::new(descriptor);
    let adapter = instance
        .request_adapter(&wgpu::RequestAdapterOptions {
            force_fallback_adapter: true,
            ..Default::default()
        })
        .await
        .expect("Vulkan adapter required");
    eprintln!("{:?}", adapter.get_info());
    let mut renderer = Renderer::request(&adapter, wgpu::TextureFormat::Rgba8UnormSrgb)
        .await
        .unwrap();
    let texture = renderer.device().create_texture(&wgpu::TextureDescriptor {
        label: None,
        size: wgpu::Extent3d {
            width: 384,
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
    let mut cold_upload = 0;
    let mut cold_wall = 0.;
    for frame in 0..15 {
        let start = Instant::now();
        renderer.render(canvas.prepared_scene(), &view).unwrap();
        let submit = start.elapsed().as_secs_f64() * 1e6;
        renderer
            .device()
            .poll(wgpu::PollType::wait_indefinitely())
            .unwrap();
        let us = start.elapsed().as_secs_f64() * 1e6;
        if frame == 0 {
            cold_upload = renderer.image_stats().map_or(0, |s| s.uploaded_bytes);
            cold_wall = us;
        }
        if frame >= 3 {
            assert!(renderer.image_stats().is_none_or(|s| s.uploaded_bytes == 0));
            wall.push(us);
            host.push(submit);
        }
    }
    for (frame, (wall, host)) in wall.iter().zip(&host).enumerate() {
        eprintln!("GPU_IMAGE_FRAME,{case},{},{wall:.3},{host:.3}", frame + 3);
    }
    wall.sort_by(f64::total_cmp);
    host.sort_by(f64::total_cmp);
    let s = renderer.stats();
    let images = renderer.image_stats().unwrap_or_default();
    println!(
        "case,resources,payload_bytes,prefix_bytes,gpu_buffer_bytes,cold_image_upload,cold_wall_us,warm_image_upload,wall_p50_us,wall_p95_us,wall_p99_us,host_p50_us,all_buffer_bytes"
    );
    println!(
        "{case},{},{},{},{},{cold_upload},{cold_wall:.3},{},{:.3},{:.3},{:.3},{:.3},{}",
        images.resources,
        images.packed_bytes,
        images.prefix_bytes,
        images.gpu_buffer_bytes,
        images.uploaded_bytes,
        wall[6],
        wall[11],
        wall[11],
        host[6],
        s.gpu_buffer_bytes
    );
}
