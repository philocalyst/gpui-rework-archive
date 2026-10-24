//! Private spike: the baseline is frozen at 73fe8cf, independent of candidate.
use super::*;
use gpui_canvas::{
    Affine, Canvas, ClipShape, Color, ColorConfig, Extend, Gradient, GradientGeometry,
    GradientStop, Interpolation, Point, Rect, TextSystem,
};
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
fn custom(
    renderer: &Renderer,
    source: &str,
    format: wgpu::TextureFormat,
    w: u32,
    h: u32,
) -> Vec<u8> {
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
        pass.set_pipeline(&pipeline);
        pass.set_bind_group(0, &renderer.state.packet.as_ref().unwrap().bindings, &[]);
        pass.draw(0..3, 0..1);
    }
    c.queue.submit([encoder.finish()]);
    read(c, &target)
}
async fn renderer() -> Renderer {
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
    Renderer::request(&adapter, wgpu::TextureFormat::Rgba16Float)
        .await
        .unwrap()
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
        let mut gpu = renderer().await;
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
