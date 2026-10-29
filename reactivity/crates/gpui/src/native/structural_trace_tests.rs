//! Actual Source structural edits through full reconciliation and raw GPU publication.
use super::*;
use crate::prelude::*;
use serde_json::json;
struct Tree {
    keys: Signal<Vec<u64>>,
    keyed: bool,
    fillers: usize,
}
impl Tree {
    const KEYS: Source<Self, Vec<u64>> =
        Source::new(FieldId::new(1), "keys", |m| &m.keys, |m| &mut m.keys);
    fn new(keyed: bool, fillers: usize, keys: Vec<u64>) -> Self {
        Self {
            keys: Signal::new(keys),
            keyed,
            fillers,
        }
    }
    fn item(key: u64) -> El<'static> {
        let color = match key % 4 {
            0 => Color::BLACK,
            1 => Color::rgb(255, 0, 0),
            2 => Color::rgb(0, 255, 0),
            _ => Color::BLACK,
        };
        let el = div().w(24).h(8).bg(color);
        if key == u64::MAX {
            el.transform(Affine::translation(f32::NAN, 0.))
        } else {
            el
        }
    }
}
impl crate::ItemSource for Tree {
    fn len(&self) -> usize {
        self.keys.len()
    }
    fn key(&self, index: usize) -> crate::ItemKey {
        crate::ItemKey::new(self.keys[index])
    }
    fn index_of(&self, key: crate::ItemKey) -> Option<usize> {
        self.keys.iter().position(|&k| k == key.get())
    }
    fn row(&self, index: usize) -> El<'_> {
        Self::item(self.keys[index])
    }
}
impl View for Tree {
    fn sources() -> Sources<Self> {
        Sources::new().field(Self::KEYS)
    }
    fn view(&self) -> El<'_> {
        let group = if self.keyed {
            crate::uniform_list(crate::ListId::new(7), self, 8)
                .w(24)
                .h((self.keys.len() * 8) as f32)
        } else {
            column(self.keys.iter().copied().map(Self::item)).w(24)
        };
        row((
            column((
                group,
                div()
                    .w(24)
                    .h(8)
                    .bg(Color::rgb(0, 0, 255))
                    .transform(Affine::translation(8., -4.)),
            ))
            .w(32),
            column((0..self.fillers).map(|_| div().w(16).h(1).bg(Color::BLACK)))
                .w(16)
                .h(64),
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
    owner: &Win<Tree>,
    renderer: &mut gpui_gpu::RetainedRenderer,
    packet: &mut Option<crate::PresentationToken>,
    target: &wgpu::Texture,
) -> (crate::PresentationToken, serde_json::Value) {
    let before = *packet;
    let (token, base, damage) = owner
        .with_paint_scene(|scene, token, paint, damage| {
            render_packet(
                renderer,
                packet,
                scene,
                token,
                paint,
                &target.create_view(&Default::default()),
                Some(damage),
            )
            .unwrap();
            (token, damage.base, damage.region.bounds())
        })
        .unwrap();
    renderer
        .device()
        .poll(wgpu::PollType::wait_indefinitely())
        .unwrap();
    let s = renderer.stats();
    let t = renderer.retained_stats();
    (
        token,
        json!({"previous":format!("{before:?}"),"token":format!("{token:?}"),"base":format!("{base:?}"),"damage":damage,"upload_bytes":s.instance_upload_bytes,"validations":s.validated_draws,"bin_visits":s.binning_tile_visits,"gpu_buffer_bytes":s.gpu_buffer_bytes,"cpu_index_bytes":s.cpu_index_capacity_bytes,"raw_records":s.draw_record_bytes,"composited_pixels":t.composited_pixels,"copied_pixels":t.copied_pixels}),
    )
}
fn scene(owner: &Win<Tree>) -> serde_json::Value {
    owner.with_scene(|s,_| {
        let st=s.storage();
        let draws:Vec<_>=s.draws().enumerate().map(|(i,d)|json!({"index":i,"bounds":[d.bounds.x,d.bounds.y,d.bounds.width,d.bounds.height],"clip":[d.clip.x,d.clip.y,d.clip.width,d.clip.height],"color":d.color,"source":format!("{:?}",d.source)})).collect();
        json!({"draws":draws,"scene_lane_bytes":st.lane_bytes(),"scene_header_bytes":st.header_bytes,"resource_header_bytes":st.resource_header_bytes,"resource_handles_bytes":st.resource_handles_bytes,"resource_index_capacity":st.resource_index_capacity,"resource_entries":st.resource_entries,"masks":s.masks().len(),"images":s.images().count(),"gradients":s.gradients().count()})
    }).unwrap()
}
fn verify(
    owner: &mut Win<Tree>,
    renderer: &gpui_gpu::RetainedRenderer,
    oracle: &mut Renderer,
    target: &wgpu::Texture,
    expected: &mut Win<Tree>,
    path: &std::path::Path,
) {
    let actual = read(renderer, target);
    let cpu = owner.with_pixels(|p, _, _| p.to_vec()).unwrap();
    let fresh = expected.with_pixels(|p, _, _| p.to_vec()).unwrap();
    let full = texture(renderer.device());
    owner
        .with_scene(|s, _| oracle.render(s, &full.create_view(&Default::default())))
        .unwrap()
        .unwrap();
    let gpu = read(renderer, &full);
    assert_eq!(actual, cpu);
    assert_eq!(actual, fresh);
    assert_eq!(actual, gpu);
    for (kind, bytes) in [
        ("actual", actual),
        ("cpu", cpu),
        ("fresh", fresh),
        ("full", gpu),
    ] {
        std::fs::write(path.with_extension(format!("{kind}.rgba")), bytes).unwrap();
    }
}
#[test]
#[ignore = "explicit structural trace gate"]
fn live_structural_boundary() {
    let output = std::path::PathBuf::from(std::env::var("GPUI_STRUCTURAL_TRACE_OUTPUT").unwrap());
    std::fs::create_dir(&output).unwrap();
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
        let mut oracle = Renderer::new(
            device.clone(),
            queue.clone(),
            wgpu::TextureFormat::Rgba8UnormSrgb,
        )
        .await
        .unwrap();
        let mut results = Vec::new();
        for keyed in [false, true] {
            for fillers in [4, 32, 256] {
                let mut renderer = gpui_gpu::RetainedRenderer::new(
                    Renderer::new(
                        device.clone(),
                        queue.clone(),
                        wgpu::TextureFormat::Rgba8UnormSrgb,
                    )
                    .await
                    .unwrap(),
                );
                let mut mutant = gpui_gpu::RetainedRenderer::new(
                    Renderer::new(
                        device.clone(),
                        queue.clone(),
                        wgpu::TextureFormat::Rgba8UnormSrgb,
                    )
                    .await
                    .unwrap(),
                );
                let target = texture(&device);
                let mutant_target = texture(&device);
                let mut packet = None;
                let mut owner = Win::recording(
                    Tree::new(keyed, fillers, vec![1, 2, 3]),
                    WindowOptions {
                        size: [64, 64],
                        ..Default::default()
                    },
                )
                .unwrap();
                let (initial, initial_gpu) = submit(&owner, &mut renderer, &mut packet, &target);
                owner.presented(initial).unwrap();
                owner
                    .with_scene(|s, _| {
                        mutant.render(s, &mutant_target.create_view(&Default::default()), None)
                    })
                    .unwrap()
                    .unwrap();
                let mut expected =
                    Win::with_size(Tree::new(keyed, fillers, vec![1, 2, 3]), 64, 64).unwrap();
                let prefix = format!("{}-{fillers}", if keyed { "keyed" } else { "unkeyed" });
                verify(
                    &mut owner,
                    &renderer,
                    &mut oracle,
                    &target,
                    &mut expected,
                    &output.join(format!("{prefix}-initial")),
                );
                let mut previous = owner.snapshot().unwrap();
                results.push(json!({"case":prefix,"operation":"initial","observation":owner.structural_observation(),"snapshot":previous,"scene":scene(&owner),"gpu":initial_gpu}));
                for (operation, keys) in [
                    ("insert", vec![1, 9, 2, 3]),
                    ("remove", vec![1, 2, 3]),
                    ("move", vec![3, 1, 2]),
                ] {
                    owner.structural_reset();
                    let allocation = allocation_counter::measure(|| {
                        owner.set(Tree::KEYS, keys.clone()).unwrap();
                    });
                    let observation = owner.structural_observation();
                    let stale = packet.unwrap();
                    let (token, gpu) = submit(&owner, &mut renderer, &mut packet, &target);
                    assert!(owner.presented(stale).is_err());
                    owner.presented(token).unwrap();
                    let next = owner.snapshot().unwrap();
                    let mut expected =
                        Win::with_size(Tree::new(keyed, fillers, keys), 64, 64).unwrap();
                    verify(
                        &mut owner,
                        &renderer,
                        &mut oracle,
                        &target,
                        &mut expected,
                        &output.join(format!("{prefix}-{operation}")),
                    );
                    let mut mutant_wrong = None;
                    if operation == "insert" {
                        // Deliberately omit the following sibling's old/new support.
                        let mut witness =
                            gpui_canvas::Canvas::recording(64, 64, Default::default()).unwrap();
                        let mut stage = witness.stage();
                        stage
                            .fill_rect(
                                crate::Rect::new(0., 0., 24., 32.),
                                Affine::IDENTITY,
                                crate::Rect::new(0., 0., 64., 64.),
                                Color::BLACK,
                            )
                            .unwrap();
                        let damage = stage.commit_with_damage();
                        owner
                            .with_scene(|s, _| {
                                mutant.render(
                                    s,
                                    &mutant_target.create_view(&Default::default()),
                                    Some(damage),
                                )
                            })
                            .unwrap()
                            .unwrap();
                        let bad = read(&mutant, &mutant_target);
                        let good = read(&renderer, &target);
                        let wrong = bad.iter().zip(&good).filter(|(a, b)| a != b).count();
                        assert!(wrong > 0);
                        std::fs::write(output.join(format!("{prefix}-mutant-actual.rgba")), bad)
                            .unwrap();
                        std::fs::write(output.join(format!("{prefix}-mutant-expected.rgba")), good)
                            .unwrap();
                        mutant_wrong =
                            Some(json!({"wrong_bytes":wrong,"restricted_damage":damage.bounds()}));
                    }
                    results.push(json!({"case":prefix,"operation":operation,"before":previous,"snapshot":next,"observation":observation,"scene":scene(&owner),"gpu":gpu,"allocation":{"count":allocation.count_total,"bytes":allocation.bytes_total,"retained_delta":allocation.bytes_current,"peak_delta":allocation.bytes_max,"includes":"source Vec clone + complete public set; excludes diagnostic snapshot/scene mirrors and GPU/oracle work"},"subtree_damage_mutant":mutant_wrong}));
                    previous = next;
                }
                let good = packet.unwrap();
                owner.structural_reset();
                assert!(owner.set(Tree::KEYS, vec![u64::MAX]).is_err());
                assert_eq!(owner.with_scene(|_, t| t).unwrap(), good);
                owner.presented(good).unwrap();
                let mut expected =
                    Win::with_size(Tree::new(keyed, fillers, vec![3, 1, 2]), 64, 64).unwrap();
                verify(
                    &mut owner,
                    &renderer,
                    &mut oracle,
                    &target,
                    &mut expected,
                    &output.join(format!("{prefix}-failed-newer")),
                );
                results.push(json!({"case":prefix,"operation":"failed-newer","observation":owner.structural_observation(),"eligible":format!("{good:?}"),"scene":scene(&owner)}));
            }
        }
        std::fs::write(
            output.join("trace.json"),
            serde_json::to_vec_pretty(
                &json!({"adapter":format!("{:?}",adapter.get_info()),"results":results}),
            )
            .unwrap(),
        )
        .unwrap();
    });
}
