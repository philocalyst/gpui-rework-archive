//! Paired full-frame/retained-output ablation, including submission and poll.
//! This is GPU-completion wall time, not display latency or hardware GPU time.
#[path = "../tests/support/adapter.rs"]
mod test_adapter;
use gpui_canvas::{
    Affine, Canvas, Color, ColorConfig, PaintColor, Point, Rect, SlotEdit, TextSystem,
};
use gpui_gpu::{Renderer, RetainedRenderer, wgpu};
use std::time::Instant;

const SIZE: [u32; 2] = [512, 256];
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
    let bytes = u64::from(SIZE[0] * SIZE[1] * 4);
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
                bytes_per_row: Some(SIZE[0] * 4),
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
    buffer.get_mapped_range(..).to_vec()
}
fn timed(renderer: &Renderer, operation: impl FnOnce()) -> (f64, f64) {
    let start = Instant::now();
    operation();
    let host = start.elapsed().as_secs_f64() * 1e6;
    renderer
        .device()
        .poll(wgpu::PollType::wait_indefinitely())
        .unwrap();
    (host, start.elapsed().as_secs_f64() * 1e6)
}
fn main() {
    let frames = std::env::args()
        .nth(1)
        .map_or(60, |n| n.parse::<usize>().unwrap());
    assert!(frames >= 10);
    pollster::block_on(async {
        let (_, adapter) = test_adapter::request().await;
        let control = Renderer::request(&adapter, wgpu::TextureFormat::Rgba8UnormSrgb)
            .await
            .unwrap();
        let device = control.device().clone();
        let queue = control.queue().clone();
        // Borrow an independent handle only for polling, avoiding timed setup.
        let poll = control;
        println!(
            "case,pair,order,full_host_us,retained_host_us,full_complete_us,retained_complete_us,composited_pixels,copied_pixels,image_bytes"
        );
        for case in [
            "flat-sparse",
            "text-sparse",
            "overlap-sparse",
            "text-full",
            "text-exposure",
        ] {
            let mut full = Renderer::new(device.clone(), queue.clone(), poll.format())
                .await
                .unwrap();
            let mut retained = RetainedRenderer::new(
                Renderer::new(device.clone(), queue.clone(), poll.format())
                    .await
                    .unwrap(),
            );
            let mut canvas = Canvas::recording(SIZE[0], SIZE[1], ColorConfig::default()).unwrap();
            let clip = Rect::new(0., 0., SIZE[0] as f32, SIZE[1] as f32);
            canvas.clear(Color::WHITE);
            let slot = canvas
                .paint_slot(PaintColor::new(Color::rgb(41, 79, 137)))
                .unwrap();
            let rect = if case == "text-full" {
                clip
            } else {
                Rect::new(4., 5., 8., 12.)
            };
            canvas
                .fill_rect_slot(rect, Affine::IDENTITY, clip, slot)
                .unwrap();
            if case.starts_with("text") {
                let mut text = TextSystem::bundled().unwrap();
                let layout = text.shape("office café label", 16., None).unwrap();
                for row in 0..8 {
                    for column in 0..3 {
                        canvas
                            .draw_text(
                                &mut text,
                                &layout,
                                Point {
                                    x: 8. + column as f32 * 168.,
                                    y: 4. + row as f32 * 30.,
                                },
                                Affine::IDENTITY,
                                clip,
                                Color::BLACK,
                            )
                            .unwrap();
                    }
                }
            } else if case == "overlap-sparse" {
                for inset in 0..8 {
                    canvas
                        .fill_rounded_rect(
                            Rect::new(inset as f32 + 0.125, 0.25, 500., 250.),
                            8.,
                            Affine::IDENTITY,
                            clip,
                            Color::rgba(71, 109, 179, 31),
                        )
                        .unwrap();
                }
            }
            let a = texture(&full);
            let b = texture(&retained);
            let av = a.create_view(&Default::default());
            let bv = b.create_view(&Default::default());
            full.render(canvas.prepared_scene(), &av).unwrap();
            retained.render(canvas.prepared_scene(), &bv, None).unwrap();
            assert_eq!(pixels(&full, &a), pixels(&retained, &b));
            for pair in 0..frames + 10 {
                let color = if pair % 2 == 0 {
                    Color::rgb(179, 67, 29)
                } else {
                    Color::rgb(41, 79, 137)
                };
                let edits = [SlotEdit::new(slot, PaintColor::new(color))];
                let damage = canvas.prepare_slots(&edits).unwrap().commit();
                let mut full_time = (0., 0.);
                let mut retained_time = (0., 0.);
                for is_retained in if pair % 2 == 0 {
                    [false, true]
                } else {
                    [true, false]
                } {
                    if is_retained {
                        retained_time = timed(&poll, || {
                            if case == "text-exposure" {
                                retained.redraw(&bv).unwrap().unwrap();
                            } else {
                                retained.patch_slots(&edits, &bv, Some(damage)).unwrap();
                            }
                        });
                    } else {
                        full_time = timed(&poll, || {
                            if case == "text-exposure" {
                                full.redraw(&av).unwrap().unwrap();
                            } else {
                                full.prepare_slots(&edits, &av).unwrap().commit();
                            }
                        });
                    }
                }
                if pair >= 10 {
                    let s = retained.retained_stats();
                    println!(
                        "{case},{},{},{:.3},{:.3},{:.3},{:.3},{},{},{}",
                        pair - 10,
                        pair % 2,
                        full_time.0,
                        retained_time.0,
                        full_time.1,
                        retained_time.1,
                        s.composited_pixels,
                        s.copied_pixels,
                        s.image_bytes
                    );
                }
            }
            assert_eq!(
                pixels(&full, &a),
                pixels(&retained, &b),
                "{case} final parity"
            );
            assert_eq!(canvas.output_bytes(), 0);
        }
    });
}
