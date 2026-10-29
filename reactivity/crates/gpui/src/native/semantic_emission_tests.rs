//! Bounded actual-emission variety, with existing full render oracles.
use super::structural_trace_tests::{scene, submit, texture, verify};
use super::*;
use crate::prelude::*;
use serde_json::json;
struct Variety {
    more: Signal<bool>,
    picture: crate::Image,
}
impl Variety {
    const MORE: Source<Self, bool> =
        Source::new(FieldId::new(1), "more", |m| &m.more, |m| &mut m.more);
    fn new(more: bool) -> Self {
        Self {
            more: Signal::new(more),
            picture: crate::Image::rgba8(
                2,
                2,
                crate::ImageProfile::Srgb,
                crate::AlphaMode::Straight,
                vec![
                    255, 0, 0, 255, 0, 255, 0, 255, 0, 0, 255, 255, 255, 255, 0, 255,
                ]
                .into_boxed_slice(),
            )
            .unwrap(),
        }
    }
}
impl View for Variety {
    fn sources() -> Sources<Self> {
        Sources::new().field(Self::MORE)
    }
    fn view(&self) -> El<'_> {
        column((
            div().w(0).h(0),
            (*self.more).then(|| div().w(16).h(4).bg(Color::BLACK)),
            text("mm")
                .w(48)
                .h(16)
                .font_size(12)
                .bg(Color::rgb(210, 210, 210)),
            text("mm").w(48).h(16).font_size(12),
            row((
                crate::image(&self.picture).w(8).h(8).bg(Color::WHITE),
                crate::image(&self.picture).w(8).h(8),
            )),
        ))
        .size(64)
        .bg(Color::WHITE)
        .rounded(4.0)
        .clip()
        .transform(Affine::translation(1., 0.))
    }
}
#[test]
#[ignore = "explicit semantic emission mapping gate"]
fn zero_multiple_and_shared_resources() {
    let output = std::path::PathBuf::from(std::env::var("GPUI_SEMANTIC_EMISSION_OUTPUT").unwrap());
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
        let mut renderer = gpui_gpu::RetainedRenderer::new(
            Renderer::new(
                device.clone(),
                queue.clone(),
                wgpu::TextureFormat::Rgba8UnormSrgb,
            )
            .await
            .unwrap(),
        );
        let mut oracle = Renderer::new(
            device.clone(),
            queue.clone(),
            wgpu::TextureFormat::Rgba8UnormSrgb,
        )
        .await
        .unwrap();
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
        let mut results = Vec::new();
        for (operation, more) in [("initial", false), ("insert", true), ("remove", false)] {
            let allocation = if operation == "initial" {
                None
            } else {
                owner.structural_reset();
                Some(allocation_counter::measure(|| {
                    owner.set(Variety::MORE, more).unwrap();
                }))
            };
            let observation = owner.structural_observation();
            let s = scene(&owner);
            let rows = observation["semantic_emission"]["current"]["rows"]
                .as_array()
                .unwrap();
            assert!(rows.iter().any(|r| r["end"] == r["start"]));
            assert!(
                rows.iter()
                    .any(|r| r["end"].as_u64().unwrap() > r["start"].as_u64().unwrap() + 1)
            );
            let draws = s["draws"].as_array().unwrap();
            let mut next = 0;
            for row in rows {
                assert_eq!(row["start"].as_u64().unwrap(), next);
                next = row["end"].as_u64().unwrap();
            }
            assert_eq!(next as usize, draws.len());
            // Deliberate one-node/one-command assumption is contradicted by
            // the actual admitted stream, without changing the renderer.
            let wrong = rows
                .iter()
                .enumerate()
                .filter(|(i, r)| {
                    r["start"].as_u64() != Some(*i as u64)
                        || r["end"].as_u64() != Some(*i as u64 + 1)
                })
                .count();
            assert!(wrong > 0);
            assert_eq!(s["images"], 1);
            assert_eq!(
                draws.iter().filter(|d| !d["image_key"].is_null()).count(),
                2
            );
            let glyph_uses = draws.iter().filter(|d| !d["mask_key"].is_null()).count();
            assert!(glyph_uses > s["masks"].as_u64().unwrap() as usize);
            assert!(draws.iter().any(|d| !d["clip_chain"].is_null()));
            let (token, gpu) = submit(&owner, &mut renderer, &mut packet, &target);
            owner.presented(token).unwrap();
            let mut fresh = Win::with_size(Variety::new(more), 64, 64).unwrap();
            verify(
                &mut owner,
                &renderer,
                &mut oracle,
                &target,
                &mut fresh,
                &output.join(operation),
            );
            results.push(json!({"operation":operation,"observation":observation,"scene":s,"gpu":gpu,"one_node_one_command_wrong_rows":wrong,"allocation":allocation.map(|a|json!({"bytes":a.bytes_total,"count":a.count_total,"retained_delta":a.bytes_current,"peak_delta":a.bytes_max}))}));
        }
        std::fs::write(
            output.join("trace.json"),
            serde_json::to_vec_pretty(&results).unwrap(),
        )
        .unwrap();
    });
}
