//! Live Source -> the actual native packet decision -> retained GPU pixels.
//! This qualifies the existing seam, not a compressed renderer or native timing.
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
fn submit(
    owner: &Win<Paint>,
    renderer: &mut gpui_gpu::RetainedRenderer,
    packet: &mut Option<crate::PresentationToken>,
    image: &wgpu::Texture,
) -> (crate::PresentationToken, serde_json::Value) {
    let counters = owner.counters();
    let view = image.create_view(&Default::default());
    let (token, from, base, damage) = owner
        .with_paint_scene(|scene, token, edit, damage| {
            let from = edit.map(|e| e.from);
            render_packet(renderer, packet, scene, token, edit, &view, Some(damage)).unwrap();
            (token, from, damage.base, damage.region.bounds())
        })
        .unwrap();
    let s = renderer.stats();
    let r = renderer.retained_stats();
    (
        token,
        json!({"token":format!("{token:?}"),"from":format!("{from:?}"),"damage_base":format!("{base:?}"),"damage":damage,
        "source_counters":counters,"validated_draws":s.validated_draws,
        "binning_tile_visits":s.binning_tile_visits,"upload_bytes":s.instance_upload_bytes,
        "draw_record_bytes":s.draw_record_bytes,"tile_references":s.tile_references,"gpu_buffer_bytes":s.gpu_buffer_bytes,"cpu_index_capacity_bytes":s.cpu_index_capacity_bytes,
        "atlas_bytes":s.atlas_bytes,"retained_image_bytes":r.image_bytes,
        "composited_pixels":r.composited_pixels,"copied_pixels":r.copied_pixels}),
    )
}
fn compare(
    owner: &mut Win<Paint>,
    renderer: &gpui_gpu::RetainedRenderer,
    oracle: &mut Renderer,
    image: &wgpu::Texture,
    expected: &mut Win<Paint>,
) -> Vec<u8> {
    let actual = read(renderer, image);
    let cpu = owner.with_pixels(|p, _, _| p.to_vec()).unwrap();
    assert_eq!(actual, cpu, "live retained versus current full CPU");
    let fresh = expected.with_pixels(|p, _, _| p.to_vec()).unwrap();
    assert_eq!(actual, fresh, "fresh Window oracle");
    let full = texture(renderer.device());
    owner
        .with_scene(|scene, _| oracle.render(scene, &full.create_view(&Default::default())))
        .unwrap()
        .unwrap();
    let gpu = read(renderer, &full);
    assert_eq!(actual, gpu, "independent full GPU route");
    let dir = std::path::PathBuf::from(std::env::var("GPUI_LIVE_SEAM_OUTPUT").unwrap())
        .with_extension("pixels");
    std::fs::create_dir_all(&dir).unwrap();
    for (kind, bytes) in [
        ("actual", &actual),
        ("cpu", &cpu),
        ("fresh", &fresh),
        ("full", &gpu),
    ] {
        std::fs::write(
            dir.join(format!("{}-{kind}.rgba", renderer.stats().submissions)),
            bytes,
        )
        .unwrap();
    }
    actual
}
#[test]
#[ignore = "explicit offscreen Vulkan integration gate"]
fn live_slot_transition_to_retained_pixels() {
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
        let mut oracle = Renderer::new(device, queue, wgpu::TextureFormat::Rgba8UnormSrgb)
            .await
            .unwrap();
        let mut rows = Vec::new();
        let mut packet = None;
        for (n, shared) in [
            (1, false),
            (9, false),
            (32, false),
            (256, false),
            (1024, false),
            (64, true),
        ] {
            let mut owner = Win::recording(
                Paint::new(n, shared, Color::BLACK, 0.),
                WindowOptions {
                    size: [64, 64],
                    ..Default::default()
                },
            )
            .unwrap();
            let image = texture(renderer.device());
            let (initial, row) = submit(&owner, &mut renderer, &mut packet, &image);
            compare(
                &mut owner,
                &renderer,
                &mut oracle,
                &image,
                &mut Win::with_size(Paint::new(n, shared, Color::BLACK, 0.), 64, 64).unwrap(),
            );
            rows.push(json!({"case":"initial","n":n,"shared":shared,"work":row}));
            owner.presented(initial).unwrap();
            owner.reset_counters().unwrap();
            owner.set(Paint::COLOR, Color::WHITE).unwrap();
            let (white, row) = submit(&owner, &mut renderer, &mut packet, &image);
            assert_eq!(row["validated_draws"], 0);
            assert_eq!(row["binning_tile_visits"], 0);
            assert_eq!(row["upload_bytes"], 16);
            assert_eq!(row["source_counters"]["source_reads"], 1);
            for name in [
                "owner_reruns",
                "layout_runs",
                "paint_passes",
                "descriptions",
            ] {
                assert_eq!(row["source_counters"][name], 0);
            }
            compare(
                &mut owner,
                &renderer,
                &mut oracle,
                &image,
                &mut Win::with_size(Paint::new(n, shared, Color::WHITE, 0.), 64, 64).unwrap(),
            );
            rows.push(json!({"case":"one-slot","n":n,"shared":shared,"work":row}));
            owner.presented(white).unwrap();
            owner.set(Paint::COLOR, Color::BLACK).unwrap();
            let older = owner.with_scene(|_, t| t).unwrap();
            owner.set(Paint::COLOR, Color::rgb(255, 0, 0)).unwrap();
            assert!(matches!(
                owner.presented(older),
                Err(Error::StalePresentation)
            ));
            let (red, row) = submit(&owner, &mut renderer, &mut packet, &image);
            assert!(row["validated_draws"].as_u64().unwrap() > 0);
            compare(
                &mut owner,
                &renderer,
                &mut oracle,
                &image,
                &mut Win::with_size(Paint::new(n, shared, Color::rgb(255, 0, 0), 0.), 64, 64)
                    .unwrap(),
            );
            rows.push(json!({"case":"coalesced-full","n":n,"shared":shared,"work":row}));
            owner.presented(red).unwrap();
            owner
                .set(
                    Paint::SHIFT,
                    Affine::translation(16., -16. * n.saturating_sub(2) as f32),
                )
                .unwrap();
            let (moved, row) = submit(&owner, &mut renderer, &mut packet, &image);
            assert!(row["validated_draws"].as_u64().unwrap() > 0);
            compare(
                &mut owner,
                &renderer,
                &mut oracle,
                &image,
                &mut Win::with_size(Paint::new(n, shared, Color::rgb(255, 0, 0), 16.), 64, 64)
                    .unwrap(),
            );
            rows.push(json!({"case":"translation-full","n":n,"shared":shared,"work":row}));
            owner.presented(moved).unwrap();
            owner.set(Paint::COLOR, Color::TRANSPARENT).unwrap();
            let (alpha, row) = submit(&owner, &mut renderer, &mut packet, &image);
            compare(
                &mut owner,
                &renderer,
                &mut oracle,
                &image,
                &mut Win::with_size(Paint::new(n, shared, Color::TRANSPARENT, 16.), 64, 64)
                    .unwrap(),
            );
            rows.push(json!({"case":"alpha-full","n":n,"shared":shared,"work":row}));
            owner.presented(alpha).unwrap();
            assert!(matches!(
                owner.set(Paint::SHIFT, Affine::translation(f32::NAN, 0.)),
                Err(crate::SetError::Committed { .. })
            ));
            let (eligible, row) = submit(&owner, &mut renderer, &mut packet, &image);
            assert_eq!(eligible, alpha);
            assert_eq!(row["composited_pixels"], 0);
            compare(
                &mut owner,
                &renderer,
                &mut oracle,
                &image,
                &mut Win::with_size(Paint::new(n, shared, Color::TRANSPARENT, 16.), 64, 64)
                    .unwrap(),
            );
            rows.push(json!({"case":"failed-newer-replay","n":n,"shared":shared,"work":row}));
        }
        // Both GPU submissions precede the first fence/read. Each target must
        // retain its own color despite later writes to the shared paint buffer.
        let mut owner = Win::recording(
            Paint::new(9, false, Color::BLACK, 0.),
            WindowOptions {
                size: [64, 64],
                ..Default::default()
            },
        )
        .unwrap();
        let first = texture(renderer.device());
        let second = texture(renderer.device());
        let (old, _) = submit(&owner, &mut renderer, &mut packet, &first);
        owner.presented(old).unwrap();
        owner.set(Paint::COLOR, Color::rgb(255, 0, 0)).unwrap();
        let (new, row) = submit(&owner, &mut renderer, &mut packet, &second);
        assert_eq!(
            read(&renderer, &first),
            Win::with_size(Paint::new(9, false, Color::BLACK, 0.), 64, 64)
                .unwrap()
                .with_pixels(|p, _, _| p.to_vec())
                .unwrap()
        );
        compare(
            &mut owner,
            &renderer,
            &mut oracle,
            &second,
            &mut Win::with_size(Paint::new(9, false, Color::rgb(255, 0, 0), 0.), 64, 64).unwrap(),
        );
        assert!(matches!(
            owner.presented(old),
            Err(Error::StalePresentation)
        ));
        owner.presented(new).unwrap();
        rows.push(json!({"case":"two-submitted","work":row}));
        // Real different window reuses positional paint slot, but not token.
        let mut other = Win::recording(
            Paint::new(9, false, Color::BLACK, 32.),
            WindowOptions {
                size: [64, 64],
                ..Default::default()
            },
        )
        .unwrap();
        let token = other.with_scene(|_, t| t).unwrap();
        other.presented(token).unwrap();
        other.set(Paint::COLOR, Color::rgb(0, 0, 255)).unwrap();
        let (other_token, row) = submit(&other, &mut renderer, &mut packet, &second);
        assert!(row["validated_draws"].as_u64().unwrap() > 0);
        let exact = compare(
            &mut other,
            &renderer,
            &mut oracle,
            &second,
            &mut Win::with_size(Paint::new(9, false, Color::rgb(0, 0, 255), 32.), 64, 64).unwrap(),
        );
        rows.push(json!({"case":"foreign-full","work":row}));
        other.presented(other_token).unwrap();
        // Bounded mutant: deliberately authorize a foreign positional edit over
        // the old packet, omitting both namespace and predecessor certificate.
        packet = None;
        let _ = submit(&owner, &mut renderer, &mut packet, &first);
        other
            .with_paint_scene(|_, _, edit, _damage| {
                renderer
                    .patch_slots(
                        &edit.unwrap().edits,
                        &second.create_view(&Default::default()),
                        None,
                    )
                    .unwrap();
            })
            .unwrap();
        let wrong = read(&renderer, &second);
        let errors = wrong.iter().zip(&exact).filter(|(a, b)| a != b).count();
        assert!(errors > 0, "authority mutant must alter pixels");
        let report = json!({"adapter":format!("{:?}",adapter.get_info()),"rows":rows,"authority_mutant_wrong_bytes":errors,"scope":"actual native private decision and retained renderer, offscreen software Vulkan; no compression or timing claim"});
        let path = std::env::var("GPUI_LIVE_SEAM_OUTPUT").expect("capture path");
        std::fs::write(path, serde_json::to_vec_pretty(&report).unwrap()).unwrap();
    });
}
