//! Address diagnostics only: the inherited mixed pixel gate remains FAILED.
use super::semantic_emission_tests::Variety;
use super::structural_trace_tests::{Tree, scene, submit, texture};
use super::*;
use serde_json::{Value, json};

fn capture<M: View + 'static>(
    owner: &mut Win<M>,
    renderer: &mut gpui_gpu::RetainedRenderer,
    packet: &mut Option<crate::PresentationToken>,
    target: &wgpu::Texture,
    case: &str,
    operation: &str,
) -> Value {
    let observation = owner.structural_observation();
    let mut scene = scene(owner);
    scene["local_rects"] = owner
        .with_scene(|s, _| {
            json!(
                s.draws()
                    .map(|d| [
                        d.local_rect.x,
                        d.local_rect.y,
                        d.local_rect.width,
                        d.local_rect.height
                    ])
                    .collect::<Vec<_>>()
            )
        })
        .unwrap();
    let clips = owner
        .with_scene(|s, _| s.clip_nodes().map(|n| json!({"rect":[n.local_rect.x,n.local_rect.y,n.local_rect.width,n.local_rect.height],"inverse":n.inverse,"radius":n.radius,"parent":n.parent,"raster":n.raster_rect.map(|r|[r.x,r.y,r.width,r.height])})).collect::<Vec<_>>())
        .unwrap();
    let (token, gpu) = submit(owner, renderer, packet, target);
    assert!(!renderer.stats().packet_reused);
    let mut trace = None;
    let allocation = allocation_counter::measure(|| trace = Some(renderer.trace_packet()));
    let trace = trace.unwrap();
    assert_eq!(trace.records.len() * 16, renderer.stats().draw_record_bytes);
    assert_eq!(
        trace.groups.iter().map(|g| g[1]).sum::<usize>(),
        renderer.stats().draws
    );
    owner.presented(token).unwrap();
    let stats = renderer.stats();
    let snapshot_bytes = trace.records.capacity() * 16
        + trace.groups.capacity() * 32
        + trace.ranges.capacity() * 8
        + trace.references.capacity() * 4
        + trace.corrections.capacity() * 32;
    json!({"case":case,"operation":operation,"observation":observation,"scene":scene,"clips":clips,"gpu":gpu,
        "packet":{"records":trace.records,"groups":trace.groups,"ranges":trace.ranges,"references":trace.references,"corrections":trace.corrections,"image_addresses":trace.image_addresses},
        "diagnostic":{"observer_capacity_bytes":trace.observer_capacity_bytes,"observer_header_bytes":trace.observer_header_bytes,"snapshot_array_capacity_bytes":snapshot_bytes,"snapshot_header_bytes":size_of::<gpui_gpu::PacketTrace>(),"snapshot_allocation_bytes":allocation.bytes_total,"snapshot_allocations":allocation.count_total,"snapshot_retained_bytes":allocation.bytes_current},
        "resources":{"mask_upload_bytes":stats.mask_upload_bytes,"atlas_bytes":stats.atlas_bytes,"atlas_keys":stats.atlas_keys,"atlas_key_capacity":stats.atlas_key_capacity,"correction_key_capacity":stats.correction_key_capacity},
        "image_stats":renderer.image_stats().map(|s|json!({"resources":s.resources,"packed_bytes":s.packed_bytes,"uploaded_bytes":s.uploaded_bytes,"prefix_bytes":s.prefix_bytes,"gpu_buffer_bytes":s.gpu_buffer_bytes,"index_capacity":s.index_capacity}))})
}
#[test]
#[ignore = "explicit packet address diagnostic, not a parity gate"]
fn live_packet_references() {
    let output = std::path::PathBuf::from(std::env::var("GPUI_PACKET_TRACE_OUTPUT").unwrap());
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
        let mut results = Vec::new();
        for (keyed, fillers) in [(true, 4), (true, 256), (false, 4)] {
            let case = format!("{}-{fillers}", if keyed { "keyed" } else { "unkeyed" });
            let mut renderer = gpui_gpu::RetainedRenderer::new(
                Renderer::new(
                    device.clone(),
                    queue.clone(),
                    wgpu::TextureFormat::Rgba8UnormSrgb,
                )
                .await
                .unwrap(),
            );
            let target = texture(&device);
            let mut packet = None;
            let mut owner = Win::recording(
                Tree::new(keyed, fillers, vec![1, 2, 3]),
                WindowOptions {
                    size: [64, 64],
                    ..Default::default()
                },
            )
            .unwrap();
            for (operation, keys) in [
                ("initial", vec![1, 2, 3]),
                ("insert", vec![1, 9, 2, 3]),
                ("remove", vec![1, 2, 3]),
                ("move", vec![3, 1, 2]),
            ] {
                if operation != "initial" {
                    owner.structural_reset();
                    owner.set(Tree::KEYS, keys).unwrap();
                }
                results.push(capture(
                    &mut owner,
                    &mut renderer,
                    &mut packet,
                    &target,
                    &case,
                    operation,
                ));
            }
        }
        let mut renderer = gpui_gpu::RetainedRenderer::new(
            Renderer::new(
                device.clone(),
                queue.clone(),
                wgpu::TextureFormat::Rgba8UnormSrgb,
            )
            .await
            .unwrap(),
        );
        let target = texture(&device);
        let mut packet = None;
        let mut owner = Win::recording(
            Variety::new(false),
            WindowOptions {
                size: [64, 64],
                ..Default::default()
            },
        )
        .unwrap();
        for (operation, more) in [("initial", false), ("insert", true), ("remove", false)] {
            if operation != "initial" {
                owner.structural_reset();
                owner.set(Variety::MORE, more).unwrap();
            }
            results.push(capture(
                &mut owner,
                &mut renderer,
                &mut packet,
                &target,
                "mixed",
                operation,
            ));
        }
        std::fs::write(
            output.join("trace.json"),
            serde_json::to_vec_pretty(&results).unwrap(),
        )
        .unwrap();
    });
}
