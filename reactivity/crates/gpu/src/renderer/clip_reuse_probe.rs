const CACHED_SHADER: &str = include_str!(concat!(env!("OUT_DIR"), "/clip/ui.wgsl"));
// Private spike: the baseline is frozen at 73fe8cf, identical to f287 shader.
use super::*;
use gpui_canvas::{
    Affine, Canvas, ClipShape, Color, ColorConfig, Extend, Gradient, GradientGeometry,
    GradientStop, Interpolation, Point, Rect, TextSystem,
};
#[allow(dead_code)]
#[path = "clip_reuse_baseline.rs"]
mod baseline;

fn texture(device: &wgpu::Device, w: u32, h: u32, format: wgpu::TextureFormat) -> wgpu::Texture {
    device.create_texture(&wgpu::TextureDescriptor {
        label: None,
        size: wgpu::Extent3d {
            width: w,
            height: h,
            depth_or_array_layers: 1,
        },
        mip_level_count: 1,
        sample_count: 1,
        dimension: wgpu::TextureDimension::D2,
        format,
        usage: wgpu::TextureUsages::RENDER_ATTACHMENT | wgpu::TextureUsages::COPY_SRC,
        view_formats: &[],
    })
}
fn read(context: &GpuContext, target: &wgpu::Texture) -> Vec<u8> {
    let bytes = target.format().block_copy_size(None).unwrap();
    let row = target.width() * bytes;
    let stride = row.next_multiple_of(256);
    let buffer = context.device.create_buffer(&wgpu::BufferDescriptor {
        label: None,
        size: u64::from(stride) * u64::from(target.height()),
        usage: wgpu::BufferUsages::COPY_DST | wgpu::BufferUsages::MAP_READ,
        mapped_at_creation: false,
    });
    let mut encoder = context.device.create_command_encoder(&Default::default());
    encoder.copy_texture_to_buffer(
        wgpu::TexelCopyTextureInfo {
            texture: target,
            mip_level: 0,
            origin: wgpu::Origin3d::ZERO,
            aspect: wgpu::TextureAspect::All,
        },
        wgpu::TexelCopyBufferInfo {
            buffer: &buffer,
            layout: wgpu::TexelCopyBufferLayout {
                offset: 0,
                bytes_per_row: Some(stride),
                rows_per_image: None,
            },
        },
        wgpu::Extent3d {
            width: target.width(),
            height: target.height(),
            depth_or_array_layers: 1,
        },
    );
    context.queue.submit([encoder.finish()]);
    let (send, receive) = std::sync::mpsc::channel();
    buffer.map_async(wgpu::MapMode::Read, .., move |result| {
        send.send(result).unwrap()
    });
    context
        .device
        .poll(wgpu::PollType::wait_indefinitely())
        .unwrap();
    receive.recv().unwrap().unwrap();
    let mapped = buffer.get_mapped_range(..).unwrap();
    let output = mapped
        .chunks_exact(stride as usize)
        .flat_map(|r| r[..row as usize].iter().copied())
        .collect();
    drop(mapped);
    buffer.unmap();
    output
}
fn make_pipeline(
    renderer: &Renderer,
    source: &str,
    format: wgpu::TextureFormat,
) -> wgpu::RenderPipeline {
    let c = &renderer.context;
    let module = c.device.create_shader_module(wgpu::ShaderModuleDescriptor {
        label: Some("clip-reuse probe"),
        source: wgpu::ShaderSource::Wgsl(Cow::Borrowed(source)),
    });
    let layout = c
        .device
        .create_pipeline_layout(&wgpu::PipelineLayoutDescriptor {
            label: None,
            bind_group_layouts: &[Some(&c.layout)],
            immediate_size: 0,
        });
    let pipeline = c
        .device
        .create_render_pipeline(&wgpu::RenderPipelineDescriptor {
            label: Some("clip-reuse probe"),
            layout: Some(&layout),
            vertex: wgpu::VertexState {
                module: &module,
                entry_point: Some("vertex"),
                compilation_options: Default::default(),
                buffers: &[],
            },
            primitive: Default::default(),
            depth_stencil: None,
            multisample: Default::default(),
            fragment: Some(wgpu::FragmentState {
                module: &module,
                entry_point: Some("fragment"),
                compilation_options: Default::default(),
                targets: &[Some(wgpu::ColorTargetState {
                    format,
                    blend: None,
                    write_mask: wgpu::ColorWrites::ALL,
                })],
            }),
            multiview_mask: None,
            cache: None,
        });
    pipeline
}
fn draw_pipeline(
    renderer: &Renderer,
    pipeline: &wgpu::RenderPipeline,
    format: wgpu::TextureFormat,
    w: u32,
    h: u32,
) -> Vec<u8> {
    let c = &renderer.context;
    let target = texture(&c.device, w, h, format);
    let view = target.create_view(&Default::default());
    let mut encoder = c.device.create_command_encoder(&Default::default());
    {
        let mut pass = encoder.begin_render_pass(&wgpu::RenderPassDescriptor {
            label: None,
            color_attachments: &[Some(wgpu::RenderPassColorAttachment {
                view: &view,
                resolve_target: None,
                depth_slice: None,
                ops: wgpu::Operations {
                    load: wgpu::LoadOp::Clear(wgpu::Color::TRANSPARENT),
                    store: wgpu::StoreOp::Store,
                },
            })],
            depth_stencil_attachment: None,
            timestamp_writes: None,
            occlusion_query_set: None,
            multiview_mask: None,
        });
        pass.set_pipeline(pipeline);
        pass.set_bind_group(0, &renderer.state.packet.as_ref().unwrap().bindings, &[]);
        pass.draw(0..3, 0..1);
    }
    c.queue.submit([encoder.finish()]);
    read(c, &target)
}
fn custom(
    renderer: &Renderer,
    source: &str,
    format: wgpu::TextureFormat,
    w: u32,
    h: u32,
) -> Vec<u8> {
    let pipeline = make_pipeline(renderer, source, format);
    draw_pipeline(renderer, &pipeline, format, w, h)
}

async fn renderer(format: wgpu::TextureFormat) -> Renderer {
    let mut desc = wgpu::InstanceDescriptor::new_without_display_handle();
    desc.backends = wgpu::Backends::VULKAN;
    let instance = wgpu::Instance::new(desc);
    let adapter = instance
        .request_adapter(&wgpu::RequestAdapterOptions {
            force_fallback_adapter: true,
            ..Default::default()
        })
        .await
        .unwrap();
    eprintln!("clip_reuse_adapter {:?}", adapter.get_info());
    Renderer::request(&adapter, format).await.unwrap()
}
fn representative(kind: u32) -> Canvas {
    let mut canvas = Canvas::recording(
        512,
        256,
        ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.0).unwrap(),
    )
    .unwrap();
    canvas.clear(Color::WHITE);
    let flat = Rect::new(0., 0., 512., 256.);
    // Preserve the existing tiles/text fixture's opaque background as well as
    // all 24 runs: this is 313 retained draws and 1,333 sampled CSR references.
    canvas
        .fill_rect(flat, Affine::IDENTITY, flat, Color::rgb(80, 100, 140))
        .unwrap();
    let outer = canvas
        .create_clip(
            None,
            ClipShape::RoundedRect {
                rect: Rect::new(4.125, 2.375, 503.5, 250.25),
                radius: 21.0,
            },
            Affine::IDENTITY,
        )
        .unwrap();
    let child = canvas
        .create_clip(
            Some(outer),
            ClipShape::RoundedRect {
                rect: Rect::new(7.375, 3.125, 497.25, 246.5),
                radius: 15.0,
            },
            Affine {
                b: 0.001,
                c: -0.002,
                ..Affine::IDENTITY
            },
        )
        .unwrap();
    let mut text = TextSystem::bundled().unwrap();
    let layout = text.shape("office café label", 16.0, None).unwrap();
    for i in 0..24 {
        let origin = Point {
            x: 8.0 + (i % 3) as f32 * 168.0,
            y: 4.0 + (i / 3) as f32 * 30.0,
        };
        if kind == 0 {
            canvas
                .draw_text(
                    &mut text,
                    &layout,
                    origin,
                    Affine::IDENTITY,
                    flat,
                    Color::BLACK,
                )
                .unwrap();
        } else {
            canvas
                .draw_text(
                    &mut text,
                    &layout,
                    origin,
                    Affine::IDENTITY,
                    child,
                    Color::BLACK,
                )
                .unwrap();
        }
        if kind == 2 {
            // Flat draws do not invalidate the most recent logical chain key.
            canvas
                .fill_rect(
                    Rect::new(origin.x, origin.y + 2., 90., 18.),
                    Affine::IDENTITY,
                    flat,
                    Color::rgba(31, 87, 211, 19),
                )
                .unwrap();
            let gradient = Gradient::new(
                GradientGeometry::Linear {
                    start: Point::default(),
                    end: Point { x: 1., y: 0. },
                },
                &[
                    GradientStop::new(0., Color::rgba(255, 7, 13, 31)),
                    GradientStop::new(1., Color::rgba(19, 211, 253, 97)),
                ],
                Extend::Pad,
                Interpolation::LinearSrgb,
            )
            .unwrap();
            canvas
                .fill_gradient(
                    &gradient,
                    Rect::new(origin.x, origin.y, 110., 24.),
                    3.0,
                    Affine::IDENTITY,
                    child,
                )
                .unwrap();
        }
    }
    canvas
}
fn diagnostic(source: &str) -> String {
    let start = source.find("fn clip_chain_contains(").unwrap();
    let end = source[start..].find("\nfn ").map(|v| start + v).unwrap();
    let chain = &source[start..end];
    let cost = chain
        .replace("clip_chain_contains(", "clip_chain_cost(")
        .replace("-> bool", "-> vec2u")
        .replace("return false;", "return vec2u(0u, u32(_depth) + 1u);")
        .replace("return true;", "return vec2u(1u, u32(_depth) + 1u);");
    // Final bounded-depth fallthrough has no in-scope loop counter.
    let at = cost.rfind("return vec2u(0u, u32(_depth) + 1u);").unwrap();
    let mut cost = cost;
    cost.replace_range(
        at..at + "return vec2u(0u, u32(_depth) + 1u);".len(),
        "return vec2u(0u, 64u);",
    );
    let fragment = source.find("@fragment").unwrap();
    format!(
        "{}\n{}\n{}",
        &source[..fragment],
        cost,
        r#"
@fragment fn fragment(@builtin(position) position: vec4f) -> @location(0) vec4f {
let globals=GLOBALS;
let tile=u32(position.x)/16u+u32(position.y)/16u*globals.viewport.z;
let range=TILES[tile];
if ((range.y & 0x80000000u)!=0u || range.x==range.y) {return vec4f(0.0);}
var counts=vec4u(0u);
for (var y=0u;y<4u;y++) {for (var x=0u;x<4u;x++) {
 let point=position.xy+vec2f((f32(x)+0.5)*0.25-0.5,(f32(y)+0.5)*0.25-0.5);
 var key=0xffffffffu;
 for (var cursor=range.x;cursor<range.y;cursor++) {
  let draw=load_draw(INDICES[cursor]);
  if ((draw.atlas.w & 0x40000000u)==0u && bitcast<u32>(draw.clip.x)==0x7fc00003u) {
   let address=bitcast<u32>(draw.clip.y);
   let cost=clip_chain_cost(address,point);
   counts.x+=1u;counts.z+=cost.y;
   if (key!=address) {key=address;counts.y+=1u;counts.w+=cost.y;}
  }
 }
}}
return vec4f(counts);
}
"#
    )
}
fn evidence(name: &str, bytes: &[u8]) {
    if let Ok(root) = std::env::var("GPUI_CLIP_REUSE_EVIDENCE") {
        std::fs::create_dir_all(&root).unwrap();
        std::fs::write(std::path::Path::new(&root).join(name), bytes).unwrap();
    }
}
#[test]
fn clip_reuse_eligibility_uploaded_csr() {
    pollster::block_on(async {
        let mut gpu = renderer(wgpu::TextureFormat::Rgba16Float).await;
        let source = baseline::ui::WGSL_SOURCE.wgsl_source().unwrap();
        evidence("baseline.wgsl", source.as_bytes());
        let diagnostic = diagnostic(&source);
        evidence("diagnostic.wgsl", diagnostic.as_bytes());
        for kind in 0..3 {
            let canvas = representative(kind);
            let target = texture(gpu.device(), 512, 256, gpu.format());
            gpu.render(
                canvas.prepared_scene(),
                &target.create_view(&Default::default()),
            )
            .unwrap();
            let actual = custom(
                &gpu,
                &diagnostic,
                wgpu::TextureFormat::Rgba32Float,
                512,
                256,
            );
            let mut sums = [0u64; 4];
            let mut histogram = std::collections::BTreeMap::<[u32; 4], u64>::new();
            for pixel in actual.chunks_exact(16) {
                let counts = std::array::from_fn(|c| {
                    f32::from_le_bytes(pixel[c * 4..c * 4 + 4].try_into().unwrap()) as u32
                });
                for c in 0..4 {
                    sums[c] += u64::from(counts[c]);
                }
                *histogram.entry(counts).or_default() += 1;
            }
            eprintln!(
                "clip_reuse_eligibility kind={kind} draws={} refs={} samples={} calls={} original_calls={} cached_calls={} original_nodes={} cached_nodes={} histogram={histogram:?}",
                gpu.stats().draws,
                gpu.stats().tile_references,
                gpu.stats().sample_evaluations,
                gpu.stats().sample_draw_evaluations,
                sums[0],
                sums[1],
                sums[2],
                sums[3]
            );
            if kind == 0 {
                assert_eq!(sums, [0; 4]);
            } else {
                assert!(sums[0] > sums[1] && sums[2] > sums[3]);
            }
            evidence(&format!("eligibility-{kind}.rgba32"), &actual);
            evidence(
                &format!("records-{kind}.bin"),
                bytemuck::cast_slice(&gpu.state.records),
            );
            evidence(
                &format!("ranges-{kind}.bin"),
                bytemuck::cast_slice(&gpu.state.ranges),
            );
            evidence(
                &format!("indices-{kind}.bin"),
                bytemuck::cast_slice(&gpu.state.references),
            );
        }
    });
}

fn boundary_scene(
    config: ColorConfig,
    map: Affine,
    edge: f32,
    depth: usize,
    banked: bool,
) -> Canvas {
    use gpui_canvas::{AlphaMode, Image, ImageProfile, ImageSampling, PaintColor};
    let mut canvas = Canvas::recording(32, 24, config).unwrap();
    canvas.clear(Color::linear_srgb(-0.0, -0.0, -0.0, 1.0).unwrap());
    let flat = Rect::new(0.125, 0.375, 31.5, 23.25);
    let mut parent = None;
    for level in 0..depth {
        parent = Some(
            canvas
                .create_clip(
                    parent,
                    ClipShape::RoundedRect {
                        rect: Rect::new(
                            0.125 + (level % 3) as f32 * 0.25,
                            0.375,
                            edge + 20.0,
                            22.5,
                        ),
                        radius: if level % 2 == 0 { 7.0 } else { 0.0 },
                    },
                    if level % 3 == 0 {
                        map
                    } else {
                        Affine::IDENTITY
                    },
                )
                .unwrap(),
        );
    }
    let a = parent.unwrap();
    let b = canvas
        .create_clip(
            None,
            ClipShape::RoundedRect {
                rect: Rect::new(edge + 4.0, 0.125, 17.5, 22.5),
                radius: 5.0,
            },
            Affine::IDENTITY,
        )
        .unwrap();
    let mut fonts = TextSystem::bundled().unwrap();
    let layout = fonts.shape("office", 12.0, None).unwrap();
    let paint = Color::linear_srgb(-0.0, -f32::from_bits(1), 2.0, 0.75).unwrap();
    let slot = banked.then(|| canvas.paint_slot(PaintColor::new(paint)).unwrap());
    for (turn, clip) in [a, a, b, b, a].into_iter().enumerate() {
        if let Some(slot) = slot {
            canvas
                .draw_text_scaled_slot(
                    &mut fonts,
                    &layout,
                    Point {
                        x: edge - 7.0,
                        y: 0.125 + turn as f32 * 0.25,
                    },
                    map,
                    clip,
                    slot,
                    1.0,
                )
                .unwrap();
        } else {
            canvas
                .draw_text(
                    &mut fonts,
                    &layout,
                    Point {
                        x: edge - 7.0,
                        y: 0.125 + turn as f32 * 0.25,
                    },
                    map,
                    clip,
                    paint,
                )
                .unwrap();
        }
        // Lowered flat-solid and generic flat draws preserve a cached chain key.
        canvas
            .fill_rect(
                Rect::new(2.125, 1.375, edge + 12.0, 17.25),
                Affine::IDENTITY,
                flat,
                Color::linear_srgb(f32::from_bits(2), -0.0, -0.25, 0.125).unwrap(),
            )
            .unwrap();
        canvas
            .fill_rect(
                Rect::new(edge, 2.125, 11.5, 18.25),
                Affine {
                    c: 0.125,
                    ..Affine::IDENTITY
                },
                flat,
                Color::rgba(17, 29, 61, 1),
            )
            .unwrap();
    }
    let gradient = Gradient::new(
        GradientGeometry::Linear {
            start: Point::default(),
            end: Point { x: 1.0, y: 0.0 },
        },
        &[
            GradientStop::new(0., Color::linear_srgb(-0.125, 0.25, 3.0, 0.5).unwrap()),
            GradientStop::new(1., paint),
        ],
        Extend::Reflect,
        Interpolation::LinearSrgb,
    )
    .unwrap();
    canvas
        .fill_gradient(&gradient, Rect::new(0.125, 0.375, 31.5, 22.25), 3.0, map, a)
        .unwrap();
    let image = Image::rgba8(
        7,
        11,
        ImageProfile::Srgb,
        AlphaMode::Straight,
        (0..77)
            .flat_map(|i| [i as u8, (i * 3) as u8, 255, [0, 1, 254, 255][i % 4]])
            .collect::<Vec<_>>()
            .into_boxed_slice(),
    )
    .unwrap();
    canvas
        .draw_image(
            &image,
            Rect::new(edge - 7.0, 0.125, 21.0, 22.0),
            map,
            b,
            ImageSampling::Nearest,
        )
        .unwrap();
    canvas
}
#[test]
fn clip_reuse_exact_frozen_shader_and_key_mutant() {
    pollster::block_on(async {
        let baseline = baseline::ui::WGSL_SOURCE.wgsl_source().unwrap();
        let candidate = CACHED_SHADER.to_owned();
        assert_ne!(baseline, candidate);
        evidence("candidate.wgsl", candidate.as_bytes());
        let needle = "cached_clip_address != address";
        assert_eq!(candidate.matches(needle).count(), 1);
        let mutant = candidate.replace(needle, "cached_clip_address == 4294967295u");
        evidence("changed-key-mutant.wgsl", mutant.as_bytes());
        let mut mutant_differences = 0usize;
        let mut comparisons = 0usize;
        for mode in 0..3 {
            let config = if mode == 0 {
                ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.0).unwrap()
            } else {
                ColorConfig {
                    mapping: if mode == 2 {
                        gpui_canvas::SdrMapping::ReinhardPerChannel { exposure: 1.75 }
                    } else {
                        gpui_canvas::SdrMapping::Clip
                    },
                    ..Default::default()
                }
            };
            let native = if mode == 0 {
                wgpu::TextureFormat::Rgba16Float
            } else {
                wgpu::TextureFormat::Rgba8UnormSrgb
            };
            let mut gpu = renderer(native).await;
            let formats = [
                wgpu::TextureFormat::Rgba8UnormSrgb,
                wgpu::TextureFormat::Rgba16Float,
                wgpu::TextureFormat::Rgba32Float,
            ];
            let pipelines = formats.map(|format| {
                (
                    make_pipeline(&gpu, &baseline, format),
                    make_pipeline(&gpu, &candidate, format),
                    make_pipeline(&gpu, &mutant, format),
                )
            });
            for grouped in [false, true] {
                gpu.set_grouped_records(grouped);
                for (variant, map) in [
                    Affine::IDENTITY,
                    Affine {
                        a: -1.0,
                        b: -0.0,
                        c: 0.0,
                        d: 1.0,
                        tx: 31.125,
                        ty: -0.0,
                    },
                    Affine {
                        a: 0.9,
                        b: 0.125,
                        c: -0.25,
                        d: 1.0,
                        tx: 4.0,
                        ty: 0.375,
                    },
                    Affine {
                        tx: 0.125_f32.next_up(),
                        ty: 0.375_f32.next_down(),
                        b: -0.0,
                        ..Affine::IDENTITY
                    },
                ]
                .into_iter()
                .enumerate()
                {
                    for edge in [8.125_f32.next_down(), 8.125, 8.125_f32.next_up()] {
                        for banked in [false, true] {
                            let canvas = boundary_scene(
                                config,
                                map,
                                edge,
                                if variant == 3 { 64 } else { 2 },
                                banked,
                            );
                            let target = texture(gpu.device(), 32, 24, native);
                            gpu.render(
                                canvas.prepared_scene(),
                                &target.create_view(&Default::default()),
                            )
                            .unwrap();
                            assert_chain_tag_excludes_lowered(&gpu);
                            for (index, format) in formats.into_iter().enumerate() {
                                let (ref before, ref after, ref bad) = pipelines[index];
                                let expected = draw_pipeline(&gpu, before, format, 32, 24);
                                let actual = draw_pipeline(&gpu, after, format, 32, 24);
                                assert_eq!(
                                    actual, expected,
                                    "mode{mode} grouped{grouped} variant{variant} edge{edge:?} banked{banked} {format:?}"
                                );
                                if format == native {
                                    assert_eq!(
                                        read(&gpu.context, &target),
                                        expected,
                                        "normal offline-artifact/native pipeline differs from frozen WGSL"
                                    );
                                }
                                comparisons += 1;
                                // The unchanged banked route is a required negative eligibility control.
                                if !banked && variant == 0 && edge == 8.125 && index == 2 {
                                    let bad = draw_pipeline(&gpu, bad, format, 32, 24);
                                    let differences =
                                        bad.iter().zip(&expected).filter(|(a, b)| a != b).count();
                                    assert!(
                                        differences > 0,
                                        "changed chain key mutant must alter actual target bits"
                                    );
                                    mutant_differences += differences;
                                    evidence(
                                        &format!(
                                            "mutant-output-mode{mode}-grouped{grouped}.rgba32"
                                        ),
                                        &bad,
                                    );
                                    evidence(
                                        &format!(
                                            "oracle-output-mode{mode}-grouped{grouped}.rgba32"
                                        ),
                                        &expected,
                                    );
                                }
                            }
                        }
                    }
                }
            }
        }
        assert!(mutant_differences > 0);
        eprintln!(
            "clip_reuse_exact comparisons={comparisons} mutant_differing_bytes={mutant_differences}"
        );
    });
}

#[test]
fn clip_reuse_backend_assembly() {
    let Ok(which) = std::env::var("GPUI_CLIP_REUSE_BACKEND") else {
        return;
    };
    pollster::block_on(async {
        let mut gpu = renderer(wgpu::TextureFormat::Rgba16Float).await;
        let source = if which == "baseline" {
            baseline::ui::WGSL_SOURCE.wgsl_source().unwrap()
        } else {
            assert_eq!(which, "candidate");
            CACHED_SHADER.to_owned()
        };
        let canvas = boundary_scene(
            ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.0).unwrap(),
            Affine::IDENTITY,
            8.125,
            2,
            false,
        );
        let target = texture(gpu.device(), 32, 24, gpu.format());
        gpu.render(
            canvas.prepared_scene(),
            &target.create_view(&Default::default()),
        )
        .unwrap();
        gpu.device()
            .poll(wgpu::PollType::wait_indefinitely())
            .unwrap();
        eprintln!("CLIP_REUSE_ASSEMBLY_BEGIN {which}");
        let result = custom(&gpu, &source, wgpu::TextureFormat::Rgba32Float, 32, 24);
        assert_eq!(result.len(), 32 * 24 * 16);
        eprintln!("CLIP_REUSE_ASSEMBLY_END {which}");
    });
}
#[test]
fn clip_reuse_signed_zero_is_observed() {
    pollster::block_on(async {
        let mut gpu = renderer(wgpu::TextureFormat::Rgba16Float).await;
        let mut canvas = Canvas::recording(
            64,
            16,
            ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.0).unwrap(),
        )
        .unwrap();
        canvas.clear(Color::linear_srgb(-0.0, -0.0, -0.0, 1.0).unwrap());
        let clip = canvas
            .create_clip(
                None,
                ClipShape::RoundedRect {
                    rect: Rect::new(0.125, 0.375, 10., 14.),
                    radius: 3.0,
                },
                Affine::IDENTITY,
            )
            .unwrap();
        let mut fonts = TextSystem::bundled().unwrap();
        let layout = fonts.shape("HH", 12., None).unwrap();
        canvas
            .draw_text(
                &mut fonts,
                &layout,
                Point::default(),
                Affine::IDENTITY,
                clip,
                Color::linear_srgb(-0.0, -f32::from_bits(1), 2.0, 0.5).unwrap(),
            )
            .unwrap();
        let target = texture(gpu.device(), 64, 16, gpu.format());
        gpu.render(
            canvas.prepared_scene(),
            &target.create_view(&Default::default()),
        )
        .unwrap();
        let baseline = baseline::ui::WGSL_SOURCE.wgsl_source().unwrap();
        let candidate = CACHED_SHADER.to_owned();
        let mut negative_zeros = 0;
        for format in [
            wgpu::TextureFormat::Rgba16Float,
            wgpu::TextureFormat::Rgba32Float,
        ] {
            let before = custom(&gpu, &baseline, format, 64, 16);
            let after = custom(&gpu, &candidate, format, 64, 16);
            assert_eq!(before, after);
            if format == wgpu::TextureFormat::Rgba16Float {
                assert_eq!(read(&gpu.context, &target), before);
            } else {
                negative_zeros = before
                    .chunks_exact(4)
                    .filter(|b| u32::from_le_bytes((*b).try_into().unwrap()) == 0x80000000)
                    .count();
                evidence("signed-zero-oracle.rgba32", &before);
            }
        }
        assert!(
            negative_zeros > 0,
            "corpus must actually retain negative-zero target bits"
        );
        eprintln!("clip_reuse_signed_zero negative_zero_channels={negative_zeros}");
    });
}

// Opt-in completed-work software diagnostic. One immutable uploaded packet and
// two precompiled pipelines share the same preallocated target in balanced order.
fn completed_frame(
    renderer: &Renderer,
    pipeline: &wgpu::RenderPipeline,
    view: &wgpu::TextureView,
) -> std::time::Duration {
    let start = std::time::Instant::now();
    let c = &renderer.context;
    let mut encoder = c.device.create_command_encoder(&Default::default());
    {
        let mut pass = encoder.begin_render_pass(&wgpu::RenderPassDescriptor {
            label: Some("clip reuse measured frame"),
            color_attachments: &[Some(wgpu::RenderPassColorAttachment {
                view,
                resolve_target: None,
                depth_slice: None,
                ops: wgpu::Operations {
                    load: wgpu::LoadOp::Clear(wgpu::Color::TRANSPARENT),
                    store: wgpu::StoreOp::Store,
                },
            })],
            depth_stencil_attachment: None,
            timestamp_writes: None,
            occlusion_query_set: None,
            multiview_mask: None,
        });
        pass.set_pipeline(pipeline);
        pass.set_bind_group(0, &renderer.state.packet.as_ref().unwrap().bindings, &[]);
        pass.draw(0..3, 0..1);
    }
    c.queue.submit([encoder.finish()]);
    c.device.poll(wgpu::PollType::wait_indefinitely()).unwrap();
    start.elapsed()
}
#[test]
fn clip_reuse_completed_work_benchmark() {
    if std::env::var("GPUI_CLIP_REUSE_BENCH").as_deref() != Ok("1") {
        return;
    }
    pollster::block_on(async {
        let mut gpu = renderer(wgpu::TextureFormat::Rgba16Float).await;
        const BASELINE: &str = include_str!("../../tests/clip_reuse_baseline.wgsl");
        assert_eq!(BASELINE, baseline::ui::WGSL_SOURCE.wgsl_source().unwrap());
        assert_eq!(CACHED_SHADER, CACHED_SHADER.to_owned());
        let baseline = BASELINE;
        let candidate = CACHED_SHADER;
        let pipelines = [
            make_pipeline(&gpu, &baseline, gpu.format()),
            make_pipeline(&gpu, &candidate, gpu.format()),
        ];
        let target = texture(gpu.device(), 512, 256, gpu.format());
        let view = target.create_view(&Default::default());
        for kind in 0..3 {
            let canvas = representative(kind);
            gpu.render(canvas.prepared_scene(), &view).unwrap();
            assert_chain_tag_excludes_lowered(&gpu);
            completed_frame(&gpu, &pipelines[0], &view);
            let expected = read(&gpu.context, &target);
            completed_frame(&gpu, &pipelines[1], &view);
            let actual = read(&gpu.context, &target);
            assert_eq!(actual, expected);
            evidence(&format!("bench-output-{kind}.rgba16"), &expected);
            evidence(
                &format!("bench-records-{kind}.bin"),
                bytemuck::cast_slice(&gpu.state.records),
            );
            evidence(
                &format!("bench-ranges-{kind}.bin"),
                bytemuck::cast_slice(&gpu.state.ranges),
            );
            evidence(
                &format!("bench-indices-{kind}.bin"),
                bytemuck::cast_slice(&gpu.state.references),
            );
            eprintln!(
                "clip_reuse_bench_fixture kind={kind} stats={:?}",
                gpu.stats()
            );
            for warmup in 0..6 {
                for shader in [warmup % 2, 1 - warmup % 2] {
                    completed_frame(&gpu, &pipelines[shader], &view);
                }
            }
            for round in 0..24 {
                for (position, shader) in [round % 2, 1 - round % 2].into_iter().enumerate() {
                    let elapsed = completed_frame(&gpu, &pipelines[shader], &view);
                    eprintln!(
                        "clip_reuse_bench,{kind},{round},{position},{shader},{}",
                        elapsed.as_nanos()
                    );
                }
            }
        }
    });
}

fn assert_chain_tag_excludes_lowered(gpu: &Renderer) -> usize {
    let mut count = 0;
    for &address in &gpu.state.references {
        let base = (address & !INLINE_RECORD) as usize;
        let (clip, metadata) = if address & INLINE_RECORD != 0 {
            (gpu.state.records[base + 3], gpu.state.records[base + 5][3])
        } else {
            let common = gpu.state.records[base + 1][3] as usize;
            (
                gpu.state.records[common + 2],
                gpu.state.records[common + 4][0],
            )
        };
        if clip[0] == 0x7fc00003 {
            assert_eq!(
                metadata & LOWERED_SOLID,
                0,
                "CHAIN tag must exclude LOWERED_SOLID at uploaded address {address}"
            );
            count += 1;
        }
    }
    count
}
#[test]
fn clip_reuse_chain_tag_excludes_lowered_in_actual_packets() {
    pollster::block_on(async {
        use gpui_canvas::PaintColor;
        let mut gpu = renderer(wgpu::TextureFormat::Rgba16Float).await;
        let mut checked = 0;
        for grouped in [false, true] {
            gpu.set_grouped_records(grouped);
            for banked in [false, true] {
                let mut canvas = Canvas::recording(
                    32,
                    24,
                    ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.).unwrap(),
                )
                .unwrap();
                canvas.clear(Color::WHITE);
                let full = Rect::new(0., 0., 32., 24.);
                canvas
                    .fill_rect(full, Affine::IDENTITY, full, Color::BLACK)
                    .unwrap();
                let clip = canvas
                    .create_clip(
                        None,
                        ClipShape::RoundedRect {
                            rect: Rect::new(0.125, 0.375, 31.5, 22.25),
                            radius: 7.,
                        },
                        Affine::IDENTITY,
                    )
                    .unwrap();
                let slot = banked.then(|| {
                    canvas
                        .paint_slot(PaintColor::new(Color::rgba(91, 37, 211, 127)))
                        .unwrap()
                });
                for x in [0.125, 1.375] {
                    let rect = Rect::new(x, 0.375, 29.5, 22.25);
                    if let Some(slot) = slot {
                        canvas
                            .fill_rect_slot(rect, Affine::IDENTITY, clip, slot)
                            .unwrap();
                    } else {
                        canvas
                            .fill_rect(rect, Affine::IDENTITY, clip, Color::rgba(91, 37, 211, 127))
                            .unwrap();
                    }
                }
                let mut fonts = TextSystem::bundled().unwrap();
                let layout = fonts.shape("office", 12., None).unwrap();
                canvas
                    .draw_text(
                        &mut fonts,
                        &layout,
                        Point::default(),
                        Affine::IDENTITY,
                        clip,
                        Color::WHITE,
                    )
                    .unwrap();
                let target = texture(gpu.device(), 32, 24, gpu.format());
                gpu.render(
                    canvas.prepared_scene(),
                    &target.create_view(&Default::default()),
                )
                .unwrap();
                let count = assert_chain_tag_excludes_lowered(&gpu);
                assert!(count > 0);
                checked += count;
                let frozen = baseline::ui::WGSL_SOURCE.wgsl_source().unwrap();
                let actual = CACHED_SHADER.to_owned();
                assert_eq!(
                    custom(&gpu, &frozen, wgpu::TextureFormat::Rgba32Float, 32, 24),
                    custom(&gpu, &actual, wgpu::TextureFormat::Rgba32Float, 32, 24)
                );
            }
        }
        eprintln!("clip_reuse_chain_certificate checked_uploaded_references={checked}");
    });
}
