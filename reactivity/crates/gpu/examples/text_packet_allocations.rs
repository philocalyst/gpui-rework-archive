//! Separate caller-thread Rust allocation probe. Durations are not performance evidence.
//! Shaping is outside timing; this is not native presentation or input latency.
#[path = "support/text_packet_memory.rs"]
mod memory;
#[path = "support/text_packet_strategy.rs"]
mod strategy;
#[path = "../tests/support/adapter.rs"]
mod test_adapter;
#[allow(dead_code)]
#[path = "../../gpui/examples/support/zgx_workload/src/lib.rs"]
mod workload;
use gpui_canvas::{
    Affine, Canvas, Color, ColorConfig, FontFace, Point, Rect, TextLayout, TextRunReplacement,
    TextRunSlot, TextSystem,
};
use gpui_gpu::{Renderer, RetainedRenderer, wgpu};
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

const CLIP: Rect = Rect::new(0., 0., 960., 720.);
fn origin(i: usize) -> Point {
    Point {
        x: 8. + i as f32 * 80.,
        y: 8.,
    }
}
fn scene(
    text: &mut TextSystem,
    dynamic: &[TextLayout],
    label: &TextLayout,
    seed: &TextLayout,
    count: usize,
) -> (Canvas, Vec<TextRunSlot>) {
    let mut canvas = Canvas::recording(SIZE[0], SIZE[1], ColorConfig::default()).unwrap();
    let mut stage = canvas.stage();
    stage.clear(Color::WHITE);
    let mut slots = Vec::new();
    for (i, layout) in dynamic.iter().enumerate() {
        slots.push(
            stage
                .draw_text_scaled_tracked(
                    text,
                    layout,
                    origin(i),
                    Affine::IDENTITY,
                    CLIP,
                    Color::BLACK,
                    1.,
                )
                .unwrap()
                .unwrap(),
        );
    }
    stage
        .draw_text(
            text,
            seed,
            Point { x: 8., y: 128. },
            Affine::IDENTITY,
            CLIP,
            Color::BLACK,
        )
        .unwrap();
    for i in 0..count {
        stage
            .draw_text(
                text,
                label,
                Point {
                    x: 4. + (i % 25) as f32 * 38.,
                    y: 152. + (i / 25) as f32 * 14.,
                },
                Affine::IDENTITY,
                CLIP,
                Color::BLACK,
            )
            .unwrap();
    }
    stage.commit();
    (canvas, slots)
}
fn main() {
    let args: Vec<_> = std::env::args().collect();
    let count: usize = args[1].parse().unwrap();
    let fields: usize = args[2].parse().unwrap();
    let mode = &args[3];
    assert!([0, 25, 1000].contains(&count) && [1, 2, 4].contains(&fields));
    assert!(["exact", "full", "stream"].contains(&mode.as_str()));
    assert!(mode != "stream" || fields == 1);
    let font = std::fs::read(&args[4]).unwrap();
    eprintln!("FONT,fnv64={:016x}", workload::fnv64(&font));
    let face = FontFace::new(font).unwrap();
    let mut text = TextSystem::from_font(face);
    let label = text.shape("label", 10., None).unwrap();
    // Keep the complete ASCII mask set leased, independently of changing runs.
    let seed = text
        .shape(
            "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz. ",
            12.,
            None,
        )
        .unwrap();
    let mut work = workload::Workload {
        text: String::with_capacity(8256),
        scroll_offset: 0.,
        frames: 0,
        mode: workload::Mode::Stream,
        seconds: 0.,
    };
    for _ in 0..100 {
        work.tick();
    }
    let values: Vec<Vec<TextLayout>> = (0..71)
        .map(|frame| {
            if mode == "stream" {
                work.tick();
                vec![text.shape(&work.visible_text(), 12., Some(944.)).unwrap()]
            } else {
                (0..fields)
                    .map(|i| {
                        text.shape(
                            if (frame + i) % 2 == 0 { "0011" } else { "1100" },
                            12.,
                            None,
                        )
                        .unwrap()
                    })
                    .collect()
            }
        })
        .collect();
    let cold = Instant::now();
    pollster::block_on(async {
        let (_, adapter) = test_adapter::request().await;
        let mut renderer = RetainedRenderer::new(
            Renderer::request(&adapter, wgpu::TextureFormat::Rgba8UnormSrgb)
                .await
                .unwrap(),
        );
        let target = texture(&renderer);
        let view = target.create_view(&Default::default());
        let (mut canvas, mut slots) = scene(&mut text, &values[0], &label, &seed, count);
        renderer
            .render(canvas.prepared_scene(), &view, None)
            .unwrap();
        renderer
            .device()
            .poll(wgpu::PollType::wait_indefinitely())
            .unwrap();
        eprintln!("COLD,wall_ns={}", cold.elapsed().as_nanos());
        let initial = pixels(&renderer, &target);
        std::fs::write(format!("{}.initial.rgba", args[5]), &initial).unwrap();
        println!(
            "frame,labels,fields,mode,host_ns,complete_ns,canonical_sparse,packet_reused,validated_draws,binning_tile_visits,upload_bytes,bind_groups,mask_upload_bytes,cpu_index_bytes,gpu_buffer_bytes,atlas_bytes"
        );
        eprintln!(
            "LAYOUT,renderer={},retained_renderer={},stats={},canvas={},text_map_bytes={}",
            size_of::<Renderer>(),
            size_of::<RetainedRenderer>(),
            size_of::<gpui_gpu::Stats>(),
            size_of::<Canvas>(),
            memory::map_bytes(&renderer)
        );
        for frame in 0..70 {
            let mut sample = None;
            let allocations = allocation_counter::measure(|| {
                let start = Instant::now();
                let edits: Vec<_> = slots
                    .iter()
                    .zip(&values[frame + 1])
                    .enumerate()
                    .map(|(i, (&slot, layout))| TextRunReplacement {
                        slot,
                        layout,
                        origin: origin(i),
                        transform: Affine::IDENTITY,
                        clip: CLIP,
                        color: Color::BLACK,
                        raster_scale: 1.,
                    })
                    .collect();
                let damage = if mode == "full" {
                    None
                } else {
                    canvas.try_patch_texts(&mut text, &edits).unwrap()
                };
                let sparse = damage.is_some();
                if !sparse {
                    (canvas, slots) = scene(&mut text, &values[frame + 1], &label, &seed, count);
                }
                strategy::render(
                    &mut renderer,
                    canvas.prepared_scene(),
                    &slots,
                    &view,
                    damage,
                    sparse,
                );
                let host = start.elapsed().as_nanos();
                renderer
                    .device()
                    .poll(wgpu::PollType::wait_indefinitely())
                    .unwrap();
                let complete = start.elapsed().as_nanos();
                sample = Some((host, complete, sparse));
            });
            let (host, complete, sparse) = sample.unwrap();
            if frame >= 10 {
                eprintln!(
                    "ALLOC,frame={},requests={},requested={},retained_delta={},peak_new={},text_map_bytes={}",
                    frame - 10,
                    allocations.count_total,
                    allocations.bytes_total,
                    allocations.bytes_current,
                    allocations.bytes_max,
                    memory::map_bytes(&renderer)
                );
                let s = renderer.stats();
                println!(
                    "{},{count},{fields},{mode},{host},{complete},{sparse},{},{},{},{},{},{},{},{},{}",
                    frame - 10,
                    s.packet_reused,
                    s.validated_draws,
                    s.binning_tile_visits,
                    s.instance_upload_bytes,
                    s.bind_group_creations,
                    s.mask_upload_bytes,
                    s.cpu_index_capacity_bytes,
                    s.gpu_buffer_bytes,
                    s.atlas_bytes
                );
            }
        }
        let final_pixels = pixels(&renderer, &target);
        std::fs::write(format!("{}.final.rgba", args[5]), &final_pixels).unwrap();
        // Independent complete reconstruction, never a replay of the patched packet.
        let mut oracle = Renderer::request(&adapter, renderer.format())
            .await
            .unwrap();
        let oracle_texture = texture(&oracle);
        let oracle_view = oracle_texture.create_view(&Default::default());
        let (fresh, _) = scene(&mut text, &values[70], &label, &seed, count);
        oracle.render(fresh.prepared_scene(), &oracle_view).unwrap();
        assert_eq!(
            final_pixels,
            pixels(&oracle, &oracle_texture),
            "fresh final image"
        );
        let (fresh, _) = scene(&mut text, &values[0], &label, &seed, count);
        oracle.render(fresh.prepared_scene(), &oracle_view).unwrap();
        assert_eq!(
            initial,
            pixels(&oracle, &oracle_texture),
            "fresh initial image"
        );
        assert_eq!(canvas.output_bytes(), 0);
        eprintln!(
            "FINAL,initial_hash={:016x},final_hash={:016x},frames=60,warmups=10,labels={count},fields={fields},mode={mode}",
            workload::fnv64(&initial),
            workload::fnv64(&final_pixels)
        );
    });
}
