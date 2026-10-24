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
            // Exercise the real optional install/packet selector, in addition
            // to independently compiled frozen/custom shader comparisons.
            let prepared = gpu
                .context
                .clip_acceleration_job()
                .unwrap()
                .prepare()
                .await
                .unwrap();
            assert!(gpu.install_clip_acceleration(prepared).unwrap());
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

#[test]
fn optional_pipeline_identity_fallback_and_packet_selection() {
    pollster::block_on(async {
        let mut gpu = renderer(wgpu::TextureFormat::Rgba16Float).await;
        assert!(gpu.context.clip_pipeline.is_none());
        assert!(gpu.clip_acceleration_job().is_none());
        assert_eq!(size_of::<Packet>(), 16);
        eprintln!(
            "optional_clip_layout context={} state={} renderer={} job={} prepared={}",
            size_of::<GpuContext>(),
            size_of::<RendererState>(),
            size_of::<Renderer>(),
            size_of::<ClipAccelerationJob>(),
            size_of::<PreparedClipAcceleration>()
        );
        let target = texture(gpu.device(), 512, 256, gpu.format());
        let view = target.create_view(&Default::default());
        let clipped = representative(1);
        gpu.render(clipped.prepared_scene(), &view).unwrap();
        assert!(gpu.state.benefits_from_clip_acceleration());
        let before = read(&gpu.context, &target); // Base immediately renders clips.
        let job = gpu.clip_acceleration_job().unwrap();
        let foreign = GpuContext::new(gpu.device().clone(), gpu.queue().clone(), gpu.format())
            .await
            .unwrap();
        let mut foreign = foreign;
        let rejected = gpu
            .context
            .clip_acceleration_job()
            .unwrap()
            .prepare()
            .await
            .unwrap();
        assert!(matches!(
            foreign.install_clip_acceleration(rejected),
            Err(Error::IncompatibleContext)
        ));
        let prepared = job.prepare().await.unwrap();
        assert!(gpu.install_clip_acceleration(prepared).unwrap());
        assert!(gpu.context.clip_acceleration_job().is_none());
        gpu.redraw(&view).unwrap().unwrap();
        assert_eq!(read(&gpu.context, &target), before);
        let mut shared = RendererState::new(&gpu.context);
        shared
            .render(&gpu.context, clipped.prepared_scene(), &view)
            .unwrap();
        assert_eq!(read(&gpu.context, &target), before);
        assert!(matches!(
            shared.redraw(&foreign, &view),
            Err(Error::IncompatibleContext)
        ));
        // A genuine selector mutant would accelerate all packets. The admitted
        // flat, banked and singleton-chain fixtures must select the base owner.
        let flat = representative(0);
        gpu.render(flat.prepared_scene(), &view).unwrap();
        assert!(!gpu.state.benefits_from_clip_acceleration());
        assert_eq!(gpu.state.packet.as_ref().unwrap().dimensions(), [512, 256]);
        assert!(std::ptr::eq(
            gpu.context.selected_pipeline(false),
            &gpu.context.pipeline
        ));
        assert!(std::ptr::eq(
            gpu.context.selected_pipeline(true),
            gpu.context.clip_pipeline.as_ref().unwrap()
        ));
        let cfg = ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.0).unwrap();
        let banked = boundary_scene(cfg, Affine::IDENTITY, 8.125, 2, true);
        let small = texture(gpu.device(), 32, 24, gpu.format());
        gpu.render(
            banked.prepared_scene(),
            &small.create_view(&Default::default()),
        )
        .unwrap();
        assert!(gpu.state.packet.as_ref().unwrap().banked());
        assert!(!gpu.state.benefits_from_clip_acceleration());
        // Poison only the optional pipeline, then mutate the actual packet
        // selector. Target-bit differences prove the selector is exercised.
        gpu.render(flat.prepared_scene(), &view).unwrap();
        let expected = read(&gpu.context, &target);
        let poison = "@vertex fn vertex(@builtin(vertex_index) i:u32)->@builtin(position) vec4f { var p=array<vec2f,3>(vec2f(-1.,-1.),vec2f(3.,-1.),vec2f(-1.,3.)); return vec4f(p[i],0.,1.); } @fragment fn fragment(@builtin(position) p:vec4f)->@location(0) vec4f { return vec4f(0.,1.,0.,1.); }";
        gpu.context.clip_pipeline = Some(make_pipeline(&gpu, poison, gpu.format()));
        gpu.redraw(&view).unwrap().unwrap();
        assert_eq!(read(&gpu.context, &target), expected);
        gpu.state.packet.as_mut().unwrap().size[0] |= CLIP_PACKET;
        gpu.redraw(&view).unwrap().unwrap();
        assert_ne!(
            read(&gpu.context, &target),
            expected,
            "actual selector mutant must change pixels"
        );
        // Actual post-binning negative fixtures, each retaining logical clip
        // nodes while offering no reusable sampled chain.
        for kind in 0..4 {
            let mut scene = Canvas::recording(32, 24, cfg).unwrap();
            let mut retained_chain = None;
            for n in 0..4 {
                let clip = if kind == 0 || retained_chain.is_none() {
                    let chain = scene
                        .create_clip(
                            None,
                            ClipShape::RoundedRect {
                                rect: Rect::new(0.125 + n as f32 * 0.125, 0.375, 30., 22.),
                                radius: 2.,
                            },
                            Affine::IDENTITY,
                        )
                        .unwrap();
                    retained_chain = Some(chain);
                    chain
                } else {
                    retained_chain.unwrap()
                };
                let rect = if kind == 1 {
                    Rect::new(100., 100., 8., 8.)
                } else {
                    Rect::new(1., 1., 28., 20.)
                };
                scene
                    .fill_rect(rect, Affine::IDENTITY, clip, Color::rgba(20, 40, 80, 127))
                    .unwrap();
            }
            if kind >= 2 {
                // One later opaque draw removes clipped references via cuts;
                // kind3 also allows the certified uniform tile path.
                scene
                    .fill_rect(
                        Rect::new(0., 0., 32., 24.),
                        Affine::IDENTITY,
                        Rect::new(0., 0., 32., 24.),
                        Color::BLACK,
                    )
                    .unwrap();
                if kind == 2 {
                    scene
                        .fill_rect(
                            Rect::new(1., 1., 4., 4.),
                            Affine::IDENTITY,
                            Rect::new(0., 0., 32., 24.),
                            Color::rgba(100, 20, 30, 127),
                        )
                        .unwrap();
                }
                gpu.set_tile_proofs(true);
            }
            gpu.render(
                scene.prepared_scene(),
                &small.create_view(&Default::default()),
            )
            .unwrap();
            assert!(
                !gpu.state.benefits_from_clip_acceleration(),
                "negative eligibility fixture {kind}"
            );
        }
        gpu.set_tile_proofs(true);
        // These exact CSR addresses include a flat draw between repeated keys.
        let mut words = vec![[0; 4]; 24];
        words[3] = [0x7fc0_0003, 100, 0, 0];
        words[15] = [0x7fc0_0003, 105, 0, 0];
        words[21] = [0x7fc0_0003, 100, 0, 0];
        let inline = INLINE_RECORD;
        assert!(acceleration::repeats_chain(
            &words,
            &[inline, inline | 6, inline | 18],
            [0, 3]
        ));
        assert!(!acceleration::repeats_chain(
            &words,
            &[inline, inline | 12, inline | 18],
            [0, 3]
        ));
        assert!(!acceleration::repeats_chain(&words, &[inline], [0, 1]));
    });
}

#[test]
fn optional_compile_on_destroyed_device_declines() {
    pollster::block_on(async {
        let gpu = renderer(wgpu::TextureFormat::Rgba16Float).await;
        let job = gpu.context.clip_acceleration_job().unwrap();
        gpu.device().destroy();
        assert!(job.prepare().await.is_err());
    });
}

// Opt-in diagnostic: the real owned job compiles while the same device renders
// completed baseline work. This measures driver contention, not thread promises.
#[test]
fn optional_cold_compile_overlap() {
    if std::env::var("GPUI_OPTIONAL_CLIP_COLD").as_deref() != Ok("1") {
        return;
    }
    pollster::block_on(async {
        let mut gpu = renderer(wgpu::TextureFormat::Rgba16Float).await;
        let canvas = representative(2);
        let target = texture(gpu.device(), 512, 256, gpu.format());
        let view = target.create_view(&Default::default());
        gpu.render(canvas.prepared_scene(), &view).unwrap();
        let baseline = &gpu.context.pipeline;
        let mut ready = None;
        for _ in 0..6 {
            completed_frame(&gpu, baseline, &view);
        }
        for phase in 0..3 {
            if phase != 1 {
                for round in 0..16 {
                    eprintln!(
                        "optional_cold_frame,{phase},{round},{}",
                        completed_frame(&gpu, baseline, &view).as_nanos()
                    );
                }
            } else {
                eprintln!(
                    "optional_cold_rss_before,{}",
                    std::fs::read_to_string("/proc/self/status")
                        .unwrap()
                        .lines()
                        .filter(|l| l.starts_with("VmRSS:") || l.starts_with("VmHWM:"))
                        .collect::<Vec<_>>()
                        .join(";")
                );
                let job = gpu.clip_acceleration_job().unwrap();
                let (send, receive) = std::sync::mpsc::sync_channel(1);
                let started = std::time::Instant::now();
                let worker = std::thread::spawn(move || {
                    let t = std::time::Instant::now();
                    let prepared = pollster::block_on(job.prepare()).unwrap();
                    send.send((prepared, t.elapsed())).unwrap();
                });
                let mut round = 0;
                let (prepared, cold) = loop {
                    eprintln!(
                        "optional_cold_frame,{phase},{round},{}",
                        completed_frame(&gpu, baseline, &view).as_nanos()
                    );
                    round += 1;
                    if let Ok(result) = receive.try_recv() {
                        break result;
                    }
                    assert!(started.elapsed().as_secs() < 60);
                };
                worker.join().unwrap();
                // Keep the baseline selected for the after/control phase.
                ready = Some(prepared);
                eprintln!("optional_cold_compile_ns,{}", cold.as_nanos());
                eprintln!(
                    "optional_cold_rss,{}",
                    std::fs::read_to_string("/proc/self/status")
                        .unwrap()
                        .lines()
                        .filter(|l| l.starts_with("VmRSS:") || l.starts_with("VmHWM:"))
                        .collect::<Vec<_>>()
                        .join(";")
                );
            }
        }
        gpu.install_clip_acceleration(ready.unwrap()).unwrap();
        for round in 0..8 {
            eprintln!(
                "optional_first_use,{round},{}",
                completed_frame(&gpu, gpu.context.clip_pipeline.as_ref().unwrap(), &view)
                    .as_nanos()
            );
        }
        eprintln!(
            "optional_cold_rss_after_first_use,{}",
            std::fs::read_to_string("/proc/self/status")
                .unwrap()
                .lines()
                .filter(|l| l.starts_with("VmRSS:") || l.starts_with("VmHWM:"))
                .collect::<Vec<_>>()
                .join(";")
        );
    });
}

// Original f287 constructor; only the new empty owner field is initialized.
async fn legacy_context(
    device: wgpu::Device,
    queue: wgpu::Queue,
    format: wgpu::TextureFormat,
) -> Result<GpuContext, Error> {
    validate_format(format)?;
    #[cfg(feature = "offline-shader")]
    let internal = device.push_error_scope(wgpu::ErrorFilter::Internal);
    #[cfg(feature = "offline-shader")]
    let memory = device.push_error_scope(wgpu::ErrorFilter::OutOfMemory);
    let errors = device.push_error_scope(wgpu::ErrorFilter::Validation);
    #[cfg(feature = "offline-shader")]
    let artifact = legacy_artifact::create(&device);
    #[cfg(not(feature = "offline-shader"))]
    let artifact = None::<(
        wgpu::ShaderModule,
        wgpu::ShaderModule,
        wgpu::BindGroupLayout,
        wgpu::PipelineLayout,
    )>;
    let (module, explicit) = match artifact {
        Some((module, fragment, layout, pipeline_layout)) => {
            (module, Some((fragment, layout, pipeline_layout)))
        }
        None => (
            device.create_shader_module(wgpu::ShaderModuleDescriptor {
                label: Some("GPUI tile compositor"),
                source: wgpu::ShaderSource::Wgsl(Cow::Borrowed(SHADER_SOURCE)),
            }),
            None,
        ),
    };
    let pipeline = device.create_render_pipeline(&wgpu::RenderPipelineDescriptor {
        label: Some("GPUI tile compositor"),
        layout: explicit
            .as_ref()
            .map(|(_, _, pipeline_layout)| pipeline_layout),
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
            module: explicit
                .as_ref()
                .map(|(fragment, _, _)| fragment)
                .unwrap_or(&module),
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
    // A destroyed device can yield an invalid pipeline. Keep inferred
    // layout validation in the same scope instead of panicking afterward.
    // Each context must mint a fresh layout handle, including if this ever
    // uses explicit layouts. Sharing a BGL across contexts/formats would
    // invalidate the state/context identity certificate.
    // Keep this checked pipeline lookup on the explicit route too: after
    // device loss creation errors can be ignored by WGPU's scopes, while
    // this rejects the invalid pipeline instead of returning a dead owner.
    drop(explicit);
    let layout = pipeline.get_bind_group_layout(0);
    let error = errors.pop().await;
    #[cfg(feature = "offline-shader")]
    let error = {
        let memory = memory.pop().await;
        let internal = internal.pop().await;
        error.or(memory).or(internal)
    };
    if let Some(error) = error {
        return Err(Error::Shader(error.to_string()));
    }
    Ok(GpuContext {
        device,
        queue,
        format,
        pipeline,
        clip_pipeline: None,
        layout,
    })
}

#[cfg(feature = "offline-shader")]
#[allow(unsafe_code)]
#[path = "clip_legacy_artifact.rs"]
mod legacy_artifact;

#[test]
fn optional_context_startup_cost() {
    if std::env::var("GPUI_OPTIONAL_CLIP_STARTUP").as_deref() != Ok("1") {
        return;
    }
    pollster::block_on(async {
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
        let (device, queue) = adapter
            .request_device(&wgpu::DeviceDescriptor {
                #[cfg(feature = "offline-shader")]
                required_features: adapter.shader_artifact_features(),
                ..Default::default()
            })
            .await
            .unwrap();
        for round in 0..8 {
            for (position, which) in [round % 2, 1 - round % 2].into_iter().enumerate() {
                let start = std::time::Instant::now();
                let context = if which == 0 {
                    legacy_context(
                        device.clone(),
                        queue.clone(),
                        wgpu::TextureFormat::Rgba16Float,
                    )
                    .await
                    .unwrap()
                } else {
                    GpuContext::new(
                        device.clone(),
                        queue.clone(),
                        wgpu::TextureFormat::Rgba16Float,
                    )
                    .await
                    .unwrap()
                };
                eprintln!(
                    "optional_context_startup,{round},{position},{which},{}",
                    start.elapsed().as_nanos()
                );
                drop(context);
                device.poll(wgpu::PollType::wait_indefinitely()).unwrap();
            }
        }
    });
}

#[test]
fn optional_late_preparation_cannot_enter_replacement_context() {
    pollster::block_on(async {
        let gpu = renderer(wgpu::TextureFormat::Rgba16Float).await;
        let job = gpu.context.clip_acceleration_job().unwrap();
        let device = gpu.device().clone();
        let queue = gpu.queue().clone();
        let (start, wait) = std::sync::mpsc::sync_channel(0);
        let worker = std::thread::spawn(move || {
            wait.recv().unwrap();
            pollster::block_on(job.prepare()).unwrap()
        });
        drop(gpu);
        let mut replacement = GpuContext::new(device, queue, wgpu::TextureFormat::Rgba16Float)
            .await
            .unwrap();
        start.send(()).unwrap();
        let prepared = worker.join().unwrap();
        assert!(matches!(
            replacement.install_clip_acceleration(prepared),
            Err(Error::IncompatibleContext)
        ));
        assert!(replacement.clip_pipeline.is_none());
    });
}

#[test]
fn optional_display_p3_exact_target_bits() {
    pollster::block_on(async {
        let frozen = baseline::ui::WGSL_SOURCE.wgsl_source().unwrap();
        let mut count = 0;
        for hdr in [false, true] {
            let cfg = if hdr {
                ColorConfig::linear_hdr(gpui_canvas::OutputProfile::DisplayP3, 203.).unwrap()
            } else {
                ColorConfig {
                    profile: gpui_canvas::OutputProfile::DisplayP3,
                    mapping: gpui_canvas::SdrMapping::ReinhardPerChannel { exposure: 1.75 },
                    ..Default::default()
                }
            };
            let format = if hdr {
                wgpu::TextureFormat::Rgba16Float
            } else {
                wgpu::TextureFormat::Rgba8UnormSrgb
            };
            let mut gpu = renderer(format).await;
            let prepared = gpu
                .context
                .clip_acceleration_job()
                .unwrap()
                .prepare()
                .await
                .unwrap();
            gpu.install_clip_acceleration(prepared).unwrap();
            let formats = [
                wgpu::TextureFormat::Rgba8UnormSrgb,
                wgpu::TextureFormat::Rgba16Float,
                wgpu::TextureFormat::Rgba32Float,
            ];
            let pipelines = formats.map(|f| {
                (
                    make_pipeline(&gpu, &frozen, f),
                    make_pipeline(&gpu, CACHED_SHADER, f),
                )
            });
            let target = texture(gpu.device(), 32, 24, format);
            for grouped in [false, true] {
                gpu.set_grouped_records(grouped);
                for map in [
                    Affine::IDENTITY,
                    Affine {
                        a: 0.9,
                        b: 0.125,
                        c: -0.25,
                        d: 1.,
                        tx: 4.,
                        ty: 0.375,
                    },
                ] {
                    for banked in [false, true] {
                        let scene = boundary_scene(cfg, map, 8.125, 64, banked);
                        gpu.render(
                            scene.prepared_scene(),
                            &target.create_view(&Default::default()),
                        )
                        .unwrap();
                        for (i, &f) in formats.iter().enumerate() {
                            let a = draw_pipeline(&gpu, &pipelines[i].0, f, 32, 24);
                            let b = draw_pipeline(&gpu, &pipelines[i].1, f, 32, 24);
                            assert_eq!(
                                a, b,
                                "DisplayP3 HDR={hdr} grouped={grouped} banked={banked} format={f:?}"
                            );
                            if f == format {
                                assert_eq!(read(&gpu.context, &target), a);
                            }
                            count += 1;
                        }
                    }
                }
            }
        }
        eprintln!("optional_display_p3_exact comparisons={count}");
        assert_eq!(count, 48);
    });
}
