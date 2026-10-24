//! Public-API matched qualification. Measurements are serialized wall clocks.
use gpui_canvas::{
    Affine, AlphaMode, Canvas, Color, ColorConfig, Image, ImageProfile, ImageSampling,
    OutputProfile, Point, Rect, TextSystem,
};
use gpui_gpu::{Renderer, wgpu};
use std::{fs, io::Write, path::Path, time::Instant};

const WIDTH: u32 = 512;
const HEIGHT: u32 = 256;
const CASES: &[(&str, bool)] = &[
    ("flat", false),
    ("text", false),
    ("text-bg", false),
    ("layers8", false),
    ("layers8-text", false),
    ("image-text", false),
    ("rounded", false),
    ("runs32k", false),
    ("singletons32k", false),
    ("layers8", true),
    ("layers8-text", true),
    ("image-text", true),
    ("rounded", true),
];

fn scene(case: &str, hdr: bool, offset: f32, text: &mut TextSystem, image: &Image) -> Canvas {
    let config = if hdr {
        ColorConfig::linear_hdr(OutputProfile::DisplayP3, 203.0).unwrap()
    } else {
        ColorConfig::default()
    };
    let mut canvas = Canvas::recording(WIDTH, HEIGHT, config).unwrap();
    canvas.clear(if hdr {
        Color::linear_display_p3(-0.0, 0.2, -0.125, 1.0).unwrap()
    } else {
        Color::WHITE
    });
    let clip = Rect::new(0.0, 0.0, WIDTH as f32, HEIGHT as f32);
    let full = Rect::new(-1.0, -1.0, WIDTH as f32 + 2.0, HEIGHT as f32 + 2.0);
    let map = Affine::translation(offset, 0.0);
    if matches!(case, "flat" | "text-bg") {
        canvas
            .fill_rect(full, map, clip, Color::rgb(30, 80, 150))
            .unwrap();
    }
    if matches!(case, "layers8" | "layers8-text") {
        for layer in 0..8 {
            let color = if hdr {
                Color::linear_display_p3(1.5 + layer as f32 * 0.2, -0.1, 0.3, 0.17).unwrap()
            } else {
                Color::rgba(25 + layer * 24, 81, 143, 43)
            };
            canvas.fill_rect(full, map, clip, color).unwrap();
        }
    }
    if case == "image-text" {
        for y in 0..2 {
            for x in 0..4 {
                canvas
                    .draw_image(
                        image,
                        Rect::new(x as f32 * 128.0, y as f32 * 128.0, 128.0, 128.0),
                        map,
                        clip,
                        ImageSampling::Linear,
                    )
                    .unwrap();
            }
        }
    }
    if case == "rounded" {
        for i in 0..24 {
            canvas
                .fill_rounded_rect(
                    Rect::new(
                        3.125 + (i % 6) as f32 * 82.0,
                        4.375 + (i / 6) as f32 * 62.0,
                        78.5,
                        56.25,
                    ),
                    9.25,
                    map,
                    clip,
                    if hdr {
                        Color::linear_display_p3(2.0, -0.125, 0.4, 0.6).unwrap()
                    } else {
                        Color::rgba(70, 100, 180, 153)
                    },
                )
                .unwrap();
        }
    }
    if matches!(
        case,
        "text" | "text-bg" | "layers8-text" | "image-text" | "runs32k" | "singletons32k"
    ) {
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
            _ => 24,
        };
        for i in 0..count {
            let origin = if count == 24 {
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
                .draw_text(text, &layout, origin, map, clip, Color::BLACK)
                .unwrap();
        }
        if count != 24 {
            // Validate and upload all records; bound the shader overlap workload.
            canvas
                .fill_rect(full, map, clip, Color::rgb(30, 80, 150))
                .unwrap();
        }
    }
    canvas
}

fn read_texture(renderer: &Renderer, texture: &wgpu::Texture) -> Vec<u8> {
    let bytes = renderer.format().block_copy_size(None).unwrap();
    let stride = (WIDTH * bytes).next_multiple_of(256);
    let buffer = renderer.device().create_buffer(&wgpu::BufferDescriptor {
        label: Some("qualification readback"),
        size: u64::from(stride) * u64::from(HEIGHT),
        usage: wgpu::BufferUsages::MAP_READ | wgpu::BufferUsages::COPY_DST,
        mapped_at_creation: false,
    });
    let mut encoder = renderer
        .device()
        .create_command_encoder(&Default::default());
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
                bytes_per_row: Some(stride),
                rows_per_image: Some(HEIGHT),
            },
        },
        wgpu::Extent3d {
            width: WIDTH,
            height: HEIGHT,
            depth_or_array_layers: 1,
        },
    );
    renderer.queue().submit([encoder.finish()]);
    let (send, receive) = std::sync::mpsc::channel();
    buffer.map_async(wgpu::MapMode::Read, .., move |result| {
        send.send(result).unwrap();
    });
    renderer
        .device()
        .poll(wgpu::PollType::wait_indefinitely())
        .unwrap();
    receive.recv().unwrap().unwrap();
    let mapped = buffer.get_mapped_range(..).unwrap();
    let mut output = Vec::with_capacity((WIDTH * HEIGHT * bytes) as usize);
    for row in mapped.chunks_exact(stride as usize) {
        output.extend_from_slice(&row[..(WIDTH * bytes) as usize]);
    }
    drop(mapped);
    buffer.unmap();
    output
}

async fn run(output: &Path, calibration: bool) {
    fs::create_dir_all(output).unwrap();
    let mut descriptor = wgpu::InstanceDescriptor::new_without_display_handle();
    descriptor.backends = wgpu::Backends::VULKAN;
    let instance = wgpu::Instance::new(descriptor);
    let adapter = instance
        .request_adapter(&wgpu::RequestAdapterOptions {
            force_fallback_adapter: true,
            ..Default::default()
        })
        .await
        .unwrap();
    fs::write(
        output.join("adapter.txt"),
        format!("{:#?}\n", adapter.get_info()),
    )
    .unwrap();
    let mut rows = fs::File::create(output.join("frames.csv")).unwrap();
    writeln!(
        rows,
        "case,hdr,motion,frame,sampled,host_submit_ns,device_poll_ns,total_ns,stats,image_stats"
    )
    .unwrap();
    let mut text = TextSystem::bundled().unwrap();
    let pixels = (0..64 * 64)
        .flat_map(|i| {
            [
                (i * 17) as u8,
                (i * 31) as u8,
                (i * 7) as u8,
                [0, 127, 255][i % 3],
            ]
        })
        .collect::<Vec<_>>();
    let image = Image::rgba8(
        64,
        64,
        ImageProfile::DisplayP3,
        AlphaMode::Straight,
        pixels.into_boxed_slice(),
    )
    .unwrap();
    for &(case, hdr) in CASES {
        let scenes = [
            scene(case, hdr, 0.0, &mut text, &image),
            scene(case, hdr, 0.25, &mut text, &image),
        ];
        for motion in [false, true] {
            let format = if hdr {
                wgpu::TextureFormat::Rgba16Float
            } else {
                wgpu::TextureFormat::Rgba8UnormSrgb
            };
            let mut renderer = Renderer::request(&adapter, format).await.unwrap();
            let texture = renderer.device().create_texture(&wgpu::TextureDescriptor {
                label: Some("qualification target"),
                size: wgpu::Extent3d {
                    width: WIDTH,
                    height: HEIGHT,
                    depth_or_array_layers: 1,
                },
                mip_level_count: 1,
                sample_count: 1,
                dimension: wgpu::TextureDimension::D2,
                format,
                usage: wgpu::TextureUsages::RENDER_ATTACHMENT | wgpu::TextureUsages::COPY_SRC,
                view_formats: &[],
            });
            let view = texture.create_view(&Default::default());
            let frames = if calibration { 2 } else { 12 };
            for frame in 0..frames {
                let index = if motion { frame % 2 } else { 0 };
                let start = Instant::now();
                renderer
                    .render(scenes[index].prepared_scene(), &view)
                    .unwrap();
                let host = start.elapsed().as_nanos();
                let poll = Instant::now();
                renderer
                    .device()
                    .poll(wgpu::PollType::wait_indefinitely())
                    .unwrap();
                let device = poll.elapsed().as_nanos();
                let total = start.elapsed().as_nanos();
                writeln!(
                    rows,
                    "{case},{hdr},{motion},{frame},{},{host},{device},{total},\"{:?}\",\"{:?}\"",
                    !calibration && frame >= 3,
                    renderer.stats(),
                    renderer.image_stats()
                )
                .unwrap();
                // Readback copies and disk writes are outside every timed interval.
                // Capture both translated parities and the cold/warm static output.
                if frame < 2 || frame + 2 >= frames {
                    fs::write(
                        output.join(format!("{case}-{hdr}-{motion}-{frame}.bin")),
                        read_texture(&renderer, &texture),
                    )
                    .unwrap();
                }
            }
            rows.flush().unwrap();
        }
    }
}

fn main() {
    let args = std::env::args().skip(1).collect::<Vec<_>>();
    assert_eq!(args.len(), 2, "output-directory calibration|measure");
    assert!(matches!(args[1].as_str(), "calibration" | "measure"));
    pollster::block_on(run(Path::new(&args[0]), args[1] == "calibration"));
}
