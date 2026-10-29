//! Independent original-GPU encoding oracle. The mixed CPU/GPU gate stays FAILED.
use super::semantic_emission_tests::Variety;
use super::structural_trace_tests::{Tree, texture};
use super::*;
use crate::prelude::{El, FieldId, Signal, Source, Sources};
use gpui_gpu::{
    GpuContext, RendererState,
    address_lab::{Fault, Handles, Mode, Version},
};
use serde_json::{Value, json};

fn read(context: &GpuContext, target: &wgpu::Texture) -> Vec<u8> {
    let device = context.device();
    let buffer = device.create_buffer(&wgpu::BufferDescriptor {
        label: Some("address publication pixels"),
        size: 16384,
        usage: wgpu::BufferUsages::MAP_READ | wgpu::BufferUsages::COPY_DST,
        mapped_at_creation: false,
    });
    let mut encoder = device.create_command_encoder(&Default::default());
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
    context.queue().submit([encoder.finish()]);
    let (tx, rx) = std::sync::mpsc::channel();
    buffer.map_async(wgpu::MapMode::Read, .., move |r| tx.send(r).unwrap());
    device.poll(wgpu::PollType::wait_indefinitely()).unwrap();
    rx.recv().unwrap().unwrap();
    let data = buffer.get_mapped_range(..).unwrap().to_vec();
    buffer.unmap();
    data
}
fn record(version: &Version) -> Value {
    let w = version.work();
    let s = version.stats();
    json!({"keys_compared":w.key_comparisons,"key_insertions":w.key_insertions,"key_moved_bytes":w.key_moved_bytes,"directory_entries":w.directory_entries,"group_events":w.group_events,"tile_comparisons":w.tile_comparisons,"tile_reused":w.tile_reused,"tile_appended_entries":w.tile_appended_entries,"arena_compactions":w.arena_compactions,"scan_bytes":w.scanned_bytes,"instance_staged_bytes":w.staged_bytes,"write_calls":w.write_calls,"gpu_copy_bytes":w.gpu_copy_bytes,"gpu_copy_calls":w.gpu_copy_calls,"cpu_copy_bytes":w.cpu_copy_bytes,"fallback":w.fallback,"resource_keys_examined":w.resource_keys_examined,"resource_index_cloned_capacity":w.resource_index_cloned_capacity,"orphan_copy_bytes":version.orphan_copy_bytes(),"validations":s.validated_draws,"bin_visits":s.binning_tile_visits,"mask_upload_bytes":s.mask_upload_bytes,"gpu_buffer_bytes":s.gpu_buffer_bytes,"atlas_bytes":s.atlas_bytes,"cpu_array_capacity_bytes":s.cpu_index_capacity_bytes,"adapter_retained_bytes":version.adapter_retained_bytes(),"images":version.images().map(|s|json!({"uploaded":s.uploaded_bytes,"index_capacity":s.index_capacity,"packed":s.packed_bytes,"prefix":s.prefix_bytes}))})
}
#[allow(clippy::too_many_arguments)]
fn run_case<M: View + 'static>(
    mut owner: Win<M>,
    raw: &GpuContext,
    lab: &GpuContext,
    mode: Mode,
    case: &str,
    operations: &[&str],
    mut update: impl FnMut(&mut Win<M>, usize),
    output: &std::path::Path,
) -> Value {
    let mut original = RendererState::new(raw);
    let mut versions = Vec::new();
    let mut targets = Vec::new();
    let mut expected = Vec::new();
    let mut tokens = Vec::new();
    let mut reports = Vec::new();
    let mut negatives = Vec::new();
    let (_, stamp, _) = owner.packet_keys();
    let mut handles = Handles::new(stamp[0]);
    for (i, &operation) in operations.iter().enumerate() {
        owner.structural_reset();
        let source = allocation_counter::measure(|| {
            if i != 0 {
                update(&mut owner, i);
            }
        });
        let observation = owner.structural_observation();
        let (token, stamp, keys) = owner.packet_keys();
        let target = texture(lab.device());
        let oracle_target = texture(raw.device());
        let mut candidate = None;
        let mut prepare_allocation = None;
        owner
            .with_scene(|scene, scene_token| {
                assert_eq!(token, scene_token);
                original
                    .render(raw, scene, &oracle_target.create_view(&Default::default()))
                    .unwrap();
                prepare_allocation = Some(allocation_counter::measure(|| {
                    candidate = Some(
                        Version::prepare(
                            lab,
                            scene,
                            &target.create_view(&Default::default()),
                            stamp,
                            keys,
                            &mut handles,
                            mode,
                            versions.last(),
                            Fault::None,
                        )
                        .unwrap(),
                    );
                }));
            })
            .unwrap();
        let candidate = candidate.unwrap();
        let allocation = prepare_allocation.unwrap();
        let oracle = read(raw, &oracle_target);
        std::fs::write(
            output.join(format!("{case}-{mode:?}-{operation}.raw.rgba")),
            &oracle,
        )
        .unwrap();
        if case == "mixed" && operation == "insert" && mode != Mode::RawRelocation {
            let fault = if mode == Mode::RelativeDomains {
                Fault::OldClipDescriptor
            } else {
                Fault::OldDirectoryDescriptor
            };
            let mutant_target = texture(lab.device());
            let mut mutant = owner
                .with_scene(|scene, _| {
                    Version::prepare(
                        lab,
                        scene,
                        &mutant_target.create_view(&Default::default()),
                        stamp,
                        keys,
                        &mut handles,
                        mode,
                        versions.last(),
                        fault,
                    )
                })
                .unwrap()
                .unwrap();
            mutant
                .submit(lab, &mutant_target.create_view(&Default::default()))
                .unwrap();
            let pixels = read(lab, &mutant_target);
            let wrong = pixels.iter().zip(&oracle).filter(|(a, b)| a != b).count();
            std::fs::write(
                output.join(format!("{case}-{mode:?}-{operation}.mutant.rgba")),
                pixels,
            )
            .unwrap();
            negatives.push(
                json!({"fault":format!("{fault:?}"),"wrong_bytes":wrong,"work":record(&mutant)}),
            );
            assert!(
                wrong > 0,
                "wrong descriptor must be detected in actual GPU pixels"
            );
            // read() waited for the mutant's completion before releasing it.
        }
        let s = original.stats();
        reports.push(json!({"operation":operation,"stamp":stamp,"source_allocation":{"bytes":source.bytes_total,"count":source.count_total,"retained_delta":source.bytes_current,"peak_delta":source.bytes_max},"prepare_allocation":{"bytes":allocation.bytes_total,"count":allocation.count_total,"retained_delta":allocation.bytes_current,"peak_delta":allocation.bytes_max},"producer":observation,"raw":{"instance_staged_bytes":s.instance_upload_bytes,"mask_upload_bytes":s.mask_upload_bytes,"gpu_buffer_bytes":s.gpu_buffer_bytes,"atlas_bytes":s.atlas_bytes,"cpu_array_capacity_bytes":s.cpu_index_capacity_bytes,"images":original.image_stats().map(|s|json!({"uploaded":s.uploaded_bytes,"packed":s.packed_bytes,"prefix":s.prefix_bytes}))},"candidate":record(&candidate),"handles_retained_bytes":handles.retained_bytes()}));
        versions.push(candidate);
        targets.push(target);
        expected.push(oracle);
        tokens.push(token);
    }
    assert!(versions.len() <= 4);
    // Oldest is deliberately consumed last. No wait between these submissions;
    // each target and every mutable packet buffer belongs to its own version.
    let mut order: Vec<_> = (1..versions.len()).rev().collect();
    order.push(0);
    for &i in &order {
        versions[i]
            .submit(lab, &targets[i].create_view(&Default::default()))
            .unwrap();
    }
    lab.device()
        .poll(wgpu::PollType::wait_indefinitely())
        .unwrap();
    let retained_gpu = Version::unique_gpu_storage_bytes(&versions);
    let retained_adapter: usize = versions.iter().map(Version::adapter_retained_bytes).sum();
    let mut comparisons = Vec::new();
    for &i in &order {
        let pixels = read(lab, &targets[i]);
        let wrong = pixels
            .iter()
            .zip(&expected[i])
            .filter(|(a, b)| a != b)
            .count();
        std::fs::write(
            output.join(format!("{case}-{mode:?}-{}.candidate.rgba", operations[i])),
            pixels,
        )
        .unwrap();
        let accepted = owner.presented(tokens[i]).is_ok();
        comparisons.push(json!({"index":i,"wrong_bytes":wrong,"ack_accepted":accepted}));
        assert_eq!(accepted, i + 1 == versions.len());
        assert_eq!(wrong, 0, "independent original GPU renderer");
    }
    // All submitted readers are complete before the private versions are dropped.
    json!({"case":case,"mode":format!("{mode:?}"),"frames":reports,"consumption_order":order,"comparisons":comparisons,"negative_controls":negatives,"retained_versions":versions.len(),"unique_gpu_payload_bytes":retained_gpu,"retained_adapter_bytes":retained_adapter,"inherited_mixed_cross_backend_gate":"FAILED; not rerun or replaced by this encoding comparison"})
}
struct Replacement {
    next: Signal<bool>,
    images: [crate::Image; 2],
}
impl Replacement {
    const NEXT: Source<Self, bool> =
        Source::new(FieldId::new(1), "next", |s| &s.next, |s| &mut s.next);
    fn new() -> Self {
        let image = |color: [u8; 4]| {
            crate::Image::rgba8(
                2,
                2,
                crate::ImageProfile::Srgb,
                crate::AlphaMode::Straight,
                color.repeat(4).into_boxed_slice(),
            )
            .unwrap()
        };
        Self {
            next: Signal::new(false),
            images: [image([255, 0, 0, 255]), image([0, 0, 255, 255])],
        }
    }
}
impl View for Replacement {
    fn sources() -> Sources<Self> {
        Sources::new().field(Self::NEXT)
    }
    fn view(&self) -> El<'_> {
        use crate::prelude::*;
        column((
            text(if *self.next { "nn" } else { "mm" })
                .font_size(12)
                .w(48)
                .h(16),
            crate::image(&self.images[usize::from(*self.next)])
                .w(16)
                .h(16),
        ))
        .size(64)
        .bg(Color::WHITE)
        .rounded(4.0)
        .clip()
        .transform(Affine::translation(1., 0.))
    }
}
#[test]
#[ignore = "explicit bounded address publication GPU experiment"]
fn private_versions_and_addresses() {
    let output = std::path::PathBuf::from(std::env::var("GPUI_ADDRESS_OUTPUT").unwrap());
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
        let raw = GpuContext::new(
            device.clone(),
            queue.clone(),
            wgpu::TextureFormat::Rgba8UnormSrgb,
        )
        .await
        .unwrap();
        std::fs::write(
            output.join("alternative.wgsl"),
            gpui_gpu::address_lab::shader_source(),
        )
        .unwrap();
        let lab = GpuContext::new_address_lab(device, queue, wgpu::TextureFormat::Rgba8UnormSrgb)
            .await
            .unwrap();
        let mut cases = Vec::new();
        for mode in [
            Mode::RawRelocation,
            Mode::RelativeDomains,
            Mode::StableDraws,
        ] {
            for (keyed, fillers) in [(true, 4), (true, 256), (false, 4)] {
                let owner = Win::recording(
                    Tree::new(keyed, fillers, vec![1, 2, 3]),
                    WindowOptions {
                        size: [64, 64],
                        ..Default::default()
                    },
                )
                .unwrap();
                cases.push(run_case(
                    owner,
                    &raw,
                    &lab,
                    mode,
                    &format!("{}-{fillers}", if keyed { "keyed" } else { "unkeyed" }),
                    &["initial", "insert", "remove", "move"],
                    |o, i| {
                        o.set(
                            Tree::KEYS,
                            match i {
                                1 => vec![1, 9, 2, 3],
                                2 => vec![1, 2, 3],
                                _ => vec![3, 1, 2],
                            },
                        )
                        .unwrap();
                    },
                    &output,
                ));
                std::fs::write(
                    output.join("trace.json"),
                    serde_json::to_vec_pretty(&cases).unwrap(),
                )
                .unwrap();
            }
            let owner = Win::recording(
                Variety::new(false),
                WindowOptions {
                    size: [64, 64],
                    ..Default::default()
                },
            )
            .unwrap();
            cases.push(run_case(
                owner,
                &raw,
                &lab,
                mode,
                "mixed",
                &["initial", "insert", "remove"],
                |o, i| {
                    o.set(Variety::MORE, i == 1).unwrap();
                },
                &output,
            ));
            std::fs::write(
                output.join("trace.json"),
                serde_json::to_vec_pretty(&cases).unwrap(),
            )
            .unwrap();
            let owner = Win::recording(
                Replacement::new(),
                WindowOptions {
                    size: [64, 64],
                    ..Default::default()
                },
            )
            .unwrap();
            cases.push(run_case(
                owner,
                &raw,
                &lab,
                mode,
                "resources",
                &["initial", "replace", "return", "replace_again"],
                |o, i| {
                    o.set(Replacement::NEXT, i % 2 == 1).unwrap();
                },
                &output,
            ));
            std::fs::write(
                output.join("trace.json"),
                serde_json::to_vec_pretty(&cases).unwrap(),
            )
            .unwrap();
        }
    });
}
