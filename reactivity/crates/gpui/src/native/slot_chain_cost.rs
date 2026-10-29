//! Frozen live offscreen Source -> native packet -> GPU completion -> acknowledgement cost.
use super::*;
use crate::prelude::*;
use serde_json::json;

struct Paint {
    n: usize,
    shared: bool,
    color: Signal<Color>,
    shift: Signal<Affine>,
}
impl Paint {
    const COLOR: Source<Self, Color> =
        Source::new(FieldId::new(1), "color", |m| &m.color, |m| &mut m.color);
    const SHIFT: Source<Self, Affine> =
        Source::new(FieldId::new(2), "shift", |m| &m.shift, |m| &mut m.shift);
    fn new(n: usize, shared: bool, color: Color, x: f32) -> Self {
        Self {
            n,
            shared,
            color: Signal::new(color),
            shift: Signal::new(Affine::translation(x, -16. * n.saturating_sub(2) as f32)),
        }
    }
}
impl View for Paint {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::COLOR).direct(Self::SHIFT)
    }
    fn view(&self) -> El<'_> {
        if self.n == 1 {
            return div().w(32).h(16).bg(&self.color).transform(&self.shift);
        }
        column((
            (0..self.n - 2).map(|j| {
                let node = div().w(32).h(16).transform(Affine::translation(
                    if self.shared { 8. } else { 40. },
                    if self.shared { 8. } else { 40. } - 16. * j as f32,
                ));
                if self.shared {
                    node.bg(&self.color)
                } else {
                    node.bg(Color::BLACK)
                }
            }),
            div().w(32).h(16).bg(&self.color).transform(&self.shift),
        ))
        .size(64)
        .bg(Color::WHITE)
        .clip()
    }
}
fn texture(device: &wgpu::Device) -> wgpu::Texture {
    device.create_texture(&wgpu::TextureDescriptor {
        label: Some("live seam target"),
        size: wgpu::Extent3d {
            width: 64,
            height: 64,
            depth_or_array_layers: 1,
        },
        mip_level_count: 1,
        sample_count: 1,
        dimension: wgpu::TextureDimension::D2,
        format: wgpu::TextureFormat::Rgba8UnormSrgb,
        usage: wgpu::TextureUsages::RENDER_ATTACHMENT | wgpu::TextureUsages::COPY_SRC,
        view_formats: &[],
    })
}
fn read(renderer: &gpui_gpu::RetainedRenderer, image: &wgpu::Texture) -> Vec<u8> {
    let device = renderer.device();
    let buffer = device.create_buffer(&wgpu::BufferDescriptor {
        label: Some("live seam readback"),
        size: 16384,
        usage: wgpu::BufferUsages::COPY_DST | wgpu::BufferUsages::MAP_READ,
        mapped_at_creation: false,
    });
    let mut encoder = device.create_command_encoder(&Default::default());
    encoder.copy_texture_to_buffer(
        wgpu::TexelCopyTextureInfo {
            texture: image,
            mip_level: 0,
            origin: wgpu::Origin3d::ZERO,
            aspect: wgpu::TextureAspect::All,
        },
        wgpu::TexelCopyBufferInfo {
            buffer: &buffer,
            layout: wgpu::TexelCopyBufferLayout {
                offset: 0,
                bytes_per_row: Some(256),
                rows_per_image: Some(64),
            },
        },
        wgpu::Extent3d {
            width: 64,
            height: 64,
            depth_or_array_layers: 1,
        },
    );
    renderer.queue().submit([encoder.finish()]);
    let (tx, rx) = std::sync::mpsc::channel();
    buffer.map_async(wgpu::MapMode::Read, .., move |r| tx.send(r).unwrap());
    device.poll(wgpu::PollType::wait_indefinitely()).unwrap();
    rx.recv().unwrap().unwrap();
    let bytes = buffer.get_mapped_range(..).unwrap().to_vec();
    buffer.unmap();
    bytes
}

use std::io::Write;
fn render_once(
    owner: &Win<Paint>,
    renderer: &mut gpui_gpu::RetainedRenderer,
    packet: &mut Option<crate::PresentationToken>,
    target: &wgpu::Texture,
) -> crate::PresentationToken {
    owner
        .with_paint_scene(|scene, token, edit, damage| {
            render_packet(
                renderer,
                packet,
                scene,
                token,
                edit,
                &target.create_view(&Default::default()),
                Some(damage),
            )
            .unwrap();
            token
        })
        .unwrap()
}
fn verify_cost(
    owner: &mut Win<Paint>,
    renderer: &gpui_gpu::RetainedRenderer,
    oracle: &mut Renderer,
    target: &wgpu::Texture,
    expected: (usize, Color, f32),
    output: &std::path::Path,
    label: &str,
) {
    let actual = read(renderer, target);
    let cpu = owner.with_pixels(|p, _, _| p.to_vec()).unwrap();
    let mut fresh = Win::with_size(
        Paint::new(expected.0, false, expected.1, expected.2),
        64,
        64,
    )
    .unwrap();
    let independent = fresh.with_pixels(|p, _, _| p.to_vec()).unwrap();
    let full = texture(renderer.device());
    owner
        .with_scene(|s, _| oracle.render(s, &full.create_view(&Default::default())))
        .unwrap()
        .unwrap();
    let gpu = read(renderer, &full);
    assert_eq!(actual, cpu);
    assert_eq!(actual, independent);
    assert_eq!(actual, gpu);
    for (name, bytes) in [
        ("actual", actual),
        ("cpu", cpu),
        ("fresh", independent),
        ("full", gpu),
    ] {
        std::fs::write(output.join(format!("{label}-{name}.rgba")), bytes).unwrap();
    }
}
#[test]
#[ignore = "explicit frozen live cost gate"]
fn live_chain_cost() {
    let config_path = std::env::var("GPUI_CHAIN_COST_CONFIG").expect("config path");
    let config: serde_json::Value =
        serde_json::from_slice(&std::fs::read(&config_path).unwrap()).unwrap();
    let output =
        std::path::PathBuf::from(std::env::var("GPUI_CHAIN_COST_OUTPUT").expect("output path"));
    std::fs::create_dir(&output).unwrap();
    let n = config["n"].as_u64().unwrap() as usize;
    let mode = config["mode"].as_str().unwrap();
    let preflight = std::env::var("GPUI_CHAIN_COST_PREFLIGHT").is_ok();
    assert!([1, 9, 32, 256, 1024].contains(&n));
    assert!(["single", "coalesced", "return-original", "geometry"].contains(&mode));
    let cold = Instant::now();
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
        let (device, queue) = adapter.request_device(&Default::default()).await.unwrap();
        let inner = Renderer::new(
            device.clone(),
            queue.clone(),
            wgpu::TextureFormat::Rgba8UnormSrgb,
        )
        .await
        .unwrap();
        let mut renderer = gpui_gpu::RetainedRenderer::new(inner);
        let mut owner = Win::recording(
            Paint::new(n, false, Color::BLACK, 0.),
            WindowOptions {
                size: [64, 64],
                ..Default::default()
            },
        )
        .unwrap();
        let target = texture(renderer.device());
        let mut packet = None;
        let token = render_once(&owner, &mut renderer, &mut packet, &target);
        renderer
            .device()
            .poll(wgpu::PollType::wait_indefinitely())
            .unwrap();
        owner.presented(token).unwrap();
        let cold_ns = cold.elapsed().as_nanos();
        let initial = renderer.stats();
        // Independent oracle context and all readbacks are outside cold/steady intervals.
        let mut oracle = Renderer::new(device, queue, wgpu::TextureFormat::Rgba8UnormSrgb)
            .await
            .unwrap();
        verify_cost(
            &mut owner,
            &renderer,
            &mut oracle,
            &target,
            (n, Color::BLACK, 0.),
            &output,
            "initial",
        );
        let colors = [
            Color::WHITE,
            Color::rgb(255, 0, 0),
            Color::rgb(0, 0, 255),
            Color::BLACK,
        ];
        let mut log =
            std::io::LineWriter::new(std::fs::File::create(output.join("events.jsonl")).unwrap());
        let mut warmups = Vec::new();
        let mut samples = Vec::new();
        let mut checked = Vec::new();
        for (phase, count) in if preflight {
            vec![("preflight", 12)]
        } else {
            vec![("warmup", 64), ("timing", 512)]
        } {
            for i in 0..count {
                owner.reset_counters().unwrap();
                let final_color = if mode == "geometry" || mode == "return-original" {
                    Color::BLACK
                } else {
                    colors[i % 4]
                };
                let x = if mode == "geometry" && i % 2 == 0 {
                    16.
                } else {
                    0.
                };
                let start = Instant::now();
                match mode {
                    "single" => {
                        owner.set(Paint::COLOR, final_color).unwrap();
                    }
                    "coalesced" => {
                        owner.set(Paint::COLOR, colors[(i + 1) % 4]).unwrap();
                        owner.set(Paint::COLOR, final_color).unwrap();
                    }
                    "return-original" => {
                        owner.set(Paint::COLOR, Color::WHITE).unwrap();
                        owner.set(Paint::COLOR, Color::BLACK).unwrap();
                    }
                    "geometry" => {
                        owner
                            .set(
                                Paint::SHIFT,
                                Affine::translation(x, -16. * n.saturating_sub(2) as f32),
                            )
                            .unwrap();
                    }
                    _ => unreachable!(),
                }
                let sourced = Instant::now();
                let token = render_once(&owner, &mut renderer, &mut packet, &target);
                let submitted = Instant::now();
                renderer
                    .device()
                    .poll(wgpu::PollType::wait_indefinitely())
                    .unwrap();
                let completed = Instant::now();
                owner.presented(token).unwrap();
                let done = Instant::now();
                let s = renderer.stats();
                let retained = renderer.retained_stats();
                let row = json!({"phase":phase,"i":i,"endpoint_ns":done.duration_since(start).as_nanos(),"source_ns":sourced.duration_since(start).as_nanos(),"render_submit_ns":submitted.duration_since(sourced).as_nanos(),"completion_wait_ns":completed.duration_since(submitted).as_nanos(),"ack_ns":done.duration_since(completed).as_nanos(),"source_counters":owner.counters(),"upload_bytes":s.instance_upload_bytes,"validated_draws":s.validated_draws,"binning_tile_visits":s.binning_tile_visits,"composited_pixels":retained.composited_pixels,"copied_pixels":retained.copied_pixels});
                serde_json::to_writer(&mut log, &row).unwrap();
                log.write_all(b"\n").unwrap();
                if preflight {
                    verify_cost(
                        &mut owner,
                        &renderer,
                        &mut oracle,
                        &target,
                        (n, final_color, x),
                        &output,
                        &format!("check-{i}"),
                    );
                    checked.push(row);
                } else if phase == "warmup" {
                    warmups.push(row);
                } else {
                    samples.push(row);
                }
            }
            if !preflight {
                verify_cost(
                    &mut owner,
                    &renderer,
                    &mut oracle,
                    &target,
                    (n, Color::BLACK, 0.),
                    &output,
                    if phase == "warmup" {
                        "after-warmup"
                    } else {
                        "final"
                    },
                );
            }
        }
        log.flush().unwrap();
        let s = renderer.stats();
        let retained = renderer.retained_stats();
        let status = std::fs::read_to_string("/proc/self/status").unwrap();
        let rss = status
            .lines()
            .find(|l| l.starts_with("VmHWM:"))
            .and_then(|l| l.split_whitespace().nth(1))
            .unwrap()
            .parse::<u64>()
            .unwrap();
        let result = json!({"config":config,"preflight":preflight,"adapter":format!("{:?}",adapter.get_info()),"cold_ns":cold_ns,"initial_upload_bytes":initial.instance_upload_bytes,"warmups":warmups,"samples":samples,"checked":checked,"storage":{"raw_record_bytes":s.draw_record_bytes,"cpu_packet_index_capacity_bytes":s.cpu_index_capacity_bytes,"gpu_buffer_bytes":s.gpu_buffer_bytes,"retained_image_bytes":retained.image_bytes,"atlas_bytes":s.atlas_bytes,"target_bytes":16384},"process_maxrss_kib":rss,"scope":"live public Source to native packet submission, GPU completion and acknowledgement; offscreen software Vulkan; excludes WSI/scanout/oracles/logging; RSS includes test/oracle/driver resources"});
        serde_json::to_writer_pretty(
            std::fs::File::create(output.join("result.json")).unwrap(),
            &result,
        )
        .unwrap();
    });
}
