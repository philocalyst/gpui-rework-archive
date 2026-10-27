//! Native-shaped unbanked row backgrounds, identical across certificate variants.
#[path = "../tests/support/adapter.rs"]
mod test_adapter;
use gpui_canvas::{Affine, Canvas, Color, ColorConfig, OutputProfile, Point, Rect, TextSystem};
use gpui_gpu::{Renderer, wgpu};
use std::time::Instant;
const SIZE: [u32; 2] = [960, 720];
fn texture(renderer: &Renderer) -> wgpu::Texture {
    renderer.device().create_texture(&wgpu::TextureDescriptor {
        label: Some("retained benchmark output"),
        size: wgpu::Extent3d {
            width: SIZE[0],
            height: SIZE[1],
            depth_or_array_layers: 1,
        },
        mip_level_count: 1,
        sample_count: 1,
        dimension: wgpu::TextureDimension::D2,
        format: renderer.format(),
        usage: wgpu::TextureUsages::RENDER_ATTACHMENT | wgpu::TextureUsages::COPY_SRC,
        view_formats: &[],
    })
}
fn pixels(renderer: &Renderer, texture: &wgpu::Texture) -> Vec<u8> {
    let bytes = u64::from(
        SIZE[0]
            * SIZE[1]
            * if renderer.format() == wgpu::TextureFormat::Rgba16Float {
                8
            } else {
                4
            },
    );
    let device = renderer.device();
    let buffer = device.create_buffer(&wgpu::BufferDescriptor {
        label: None,
        size: bytes,
        usage: wgpu::BufferUsages::COPY_DST | wgpu::BufferUsages::MAP_READ,
        mapped_at_creation: false,
    });
    let mut encoder = device.create_command_encoder(&Default::default());
    encoder.copy_texture_to_buffer(
        wgpu::TexelCopyTextureInfo {
            texture,
            mip_level: 0,
            origin: wgpu::Origin3d::ZERO,
            aspect: wgpu::TextureAspect::All,
        },
        wgpu::TexelCopyBufferInfo {
            buffer: &buffer,
            layout: wgpu::TexelCopyBufferLayout {
                offset: 0,
                bytes_per_row: Some(
                    SIZE[0]
                        * if renderer.format() == wgpu::TextureFormat::Rgba16Float {
                            8
                        } else {
                            4
                        },
                ),
                rows_per_image: Some(SIZE[1]),
            },
        },
        texture.size(),
    );
    renderer.queue().submit([encoder.finish()]);
    let (send, receive) = std::sync::mpsc::channel();
    buffer.map_async(wgpu::MapMode::Read, .., move |r| send.send(r).unwrap());
    device.poll(wgpu::PollType::wait_indefinitely()).unwrap();
    receive.recv().unwrap().unwrap();
    buffer.get_mapped_range(..).unwrap().to_vec()
}

fn scene(case: &str) -> Canvas {
    let hdr = case == "hdr-stripes";
    let config = if hdr {
        ColorConfig::linear_hdr(OutputProfile::Srgb, 203.).unwrap()
    } else {
        ColorConfig::default()
    };
    let mut canvas = Canvas::recording(SIZE[0], SIZE[1], config).unwrap();
    canvas.clear(if hdr {
        Color::TRANSPARENT
    } else {
        Color::WHITE
    });
    let clip = Rect::new(0., 0., SIZE[0] as f32, SIZE[1] as f32);
    if case == "flat" {
        canvas
            .fill_rect(clip, Affine::IDENTITY, clip, Color::rgb(31, 79, 137))
            .unwrap();
        return canvas;
    }
    let mut text = TextSystem::new(include_bytes!(
        "../../gpui/examples/support/fonts/DejaVuSans.ttf"
    ))
    .unwrap();
    for row in 0..26 {
        let top = row as f32 * 28. + if case == "quarter-stripes" { 0.25 } else { 0. };
        let color = if hdr {
            Color::linear_srgb(2.0, if row % 2 == 0 { 0.5 } else { 1.0 }, 0.25, 0.5).unwrap()
        } else {
            gpui_canvas::rgb(if row % 2 == 0 { 0x192230 } else { 0x1d2838 })
        };
        canvas
            .fill_rect(Rect::new(0., top, 960., 28.), Affine::IDENTITY, clip, color)
            .unwrap();
        if case == "text-stripes" {
            let layout = text
                .shape(&format!("Row {row:06} — retained virtual item"), 14., None)
                .unwrap();
            canvas
                .draw_text(
                    &mut text,
                    &layout,
                    Point { x: 8., y: top + 4. },
                    Affine::IDENTITY,
                    clip,
                    gpui_canvas::rgb(0xe5edf7),
                )
                .unwrap();
        }
    }
    canvas
}

fn main() {
    let frames = std::env::args()
        .nth(1)
        .map_or(60, |n| n.parse::<usize>().unwrap());
    assert!(frames >= 10);
    let output =
        std::path::PathBuf::from(std::env::var("GPU_DRAW_OUTPUT").expect("pixel output directory"));
    std::fs::create_dir_all(&output).unwrap();
    pollster::block_on(async {
        let (_, adapter) = test_adapter::request().await;
        println!("case,frame,host_us,complete_us");
        for case in [
            "flat",
            "stripes",
            "text-stripes",
            "quarter-stripes",
            "hdr-stripes",
        ] {
            let format = if case == "hdr-stripes" {
                wgpu::TextureFormat::Rgba16Float
            } else {
                wgpu::TextureFormat::Rgba8UnormSrgb
            };
            let init = Instant::now();
            let mut renderer = Renderer::request(&adapter, format).await.unwrap();
            let init_us = init.elapsed().as_secs_f64() * 1e6;
            let recorded = Instant::now();
            let canvas = scene(case);
            let record_us = recorded.elapsed().as_secs_f64() * 1e6;
            let target = texture(&renderer);
            let view = target.create_view(&Default::default());
            let device = renderer.device().clone();
            let first = Instant::now();
            renderer.render(canvas.prepared_scene(), &view).unwrap();
            let first_host = first.elapsed().as_secs_f64() * 1e6;
            device.poll(wgpu::PollType::wait_indefinitely()).unwrap();
            let first_complete = first.elapsed().as_secs_f64() * 1e6;
            let initial = pixels(&renderer, &target);
            std::fs::write(output.join(format!("{case}-initial.rgba")), &initial).unwrap();
            eprintln!(
                "COLD,{case},{init_us:.3},{record_us:.3},{first_host:.3},{first_complete:.3},{:?}",
                renderer.stats()
            );
            for frame in 0..frames + 10 {
                let start = Instant::now();
                renderer.redraw(&view).unwrap().unwrap();
                let host = start.elapsed().as_secs_f64() * 1e6;
                device.poll(wgpu::PollType::wait_indefinitely()).unwrap();
                let complete = start.elapsed().as_secs_f64() * 1e6;
                if frame >= 10 {
                    println!("{case},{},{host:.3},{complete:.3}", frame - 10);
                }
            }
            let final_pixels = pixels(&renderer, &target);
            assert_eq!(
                initial, final_pixels,
                "unchanged scene exact readback {case}"
            );
            std::fs::write(output.join(format!("{case}-final.rgba")), &final_pixels).unwrap();
            assert_eq!(canvas.output_bytes(), 0);
        }
    });
}
