//! Frozen matched-selector live cost endpoint; no WSI or cross-backend parity claim.
use super::layout_handle_tests::{Constrained, Resources};
use super::layout_preservation_tests::Measured;
use super::structural_trace_tests::{Tree, read, texture};
use super::*;
use crate::prelude::*;
use crate::runtime::layout_preservation::{CostSnapshot, Mode};
use serde::Serialize;
use serde_json::{Value, json};
use std::time::Instant;
const WARM: usize = 32;
const MEASURED: usize = 384;
#[derive(Serialize)]
struct Sample {
    step: usize,
    direction: usize,
    measured: bool,
    total_ns: u64,
    source_ns: u64,
    prepare_submit_ns: u64,
    completion_ack_ns: u64,
    layout: CostSnapshot,
    renderer_gpu_bytes: u64,
    renderer_index_bytes: usize,
    instance_staged_bytes: usize,
    mask_staged_bytes: usize,
    image_staged_bytes: usize,
    submissions: u64,
    validations: usize,
    bin_visits: usize,
    composited_pixels: u64,
    copied_pixels: u64,
}
struct Engine {
    renderer: gpui_gpu::RetainedRenderer,
    view: wgpu::TextureView,
    packet: Option<crate::PresentationToken>,
}
impl Engine {
    fn publish<M: View + 'static>(&mut self, owner: &mut Win<M>) -> crate::PresentationToken {
        owner
            .with_paint_scene(|scene, token, paint, damage| {
                render_packet(
                    &mut self.renderer,
                    &mut self.packet,
                    scene,
                    token,
                    paint,
                    &self.view,
                    Some(damage),
                )
                .unwrap();
                token
            })
            .unwrap()
    }
    fn finish<M: View + 'static>(&mut self, owner: &mut Win<M>, token: crate::PresentationToken) {
        self.renderer
            .device()
            .poll(wgpu::PollType::wait_indefinitely())
            .unwrap();
        owner.presented(token).unwrap();
    }
    fn frame<M: View + 'static>(
        &mut self,
        owner: &mut Win<M>,
        step: usize,
        update: impl FnOnce(&mut Win<M>),
    ) -> Sample {
        owner.structural_reset();
        let before = self.renderer.stats().submissions;
        let start = Instant::now();
        update(owner);
        let source_ns = start.elapsed().as_nanos() as u64;
        let token = self.publish(owner);
        let submitted = start.elapsed().as_nanos() as u64;
        self.finish(owner, token);
        let total_ns = start.elapsed().as_nanos() as u64;
        let stats = self.renderer.stats();
        let retained = self.renderer.retained_stats();
        Sample {
            step,
            direction: usize::from(step.is_multiple_of(2)),
            measured: step > WARM,
            total_ns,
            source_ns,
            prepare_submit_ns: submitted - source_ns,
            completion_ack_ns: total_ns - submitted,
            layout: owner.layout_cost_snapshot(),
            renderer_gpu_bytes: stats.gpu_buffer_bytes + stats.atlas_bytes + retained.image_bytes,
            renderer_index_bytes: stats.cpu_index_capacity_bytes,
            instance_staged_bytes: stats.instance_upload_bytes,
            mask_staged_bytes: stats.mask_upload_bytes,
            image_staged_bytes: self.renderer.image_stats().map_or(0, |s| s.uploaded_bytes),
            submissions: stats.submissions - before,
            validations: stats.validated_draws,
            bin_visits: stats.binning_tile_visits,
            composited_pixels: retained.composited_pixels,
            copied_pixels: retained.copied_pixels,
        }
    }
}
fn memory() -> String {
    std::fs::read_to_string("/proc/self/status")
        .unwrap()
        .lines()
        .filter(|s| s.starts_with("VmRSS:") || s.starts_with("VmHWM:"))
        .collect::<Vec<_>>()
        .join("\n")
}
fn run<M: View + 'static>(
    renderer: Renderer,
    mode: Mode,
    build: impl Fn(bool) -> M,
    update: impl Fn(&mut Win<M>, bool),
    output: &std::path::Path,
) -> Value {
    let setup = Instant::now();
    let mut owner = Win::recording(
        build(false),
        WindowOptions {
            size: [64, 64],
            ..Default::default()
        },
    )
    .unwrap();
    owner.layout_preservation_mode(mode);
    let owner_setup_ns = setup.elapsed().as_nanos() as u64;
    let target = texture(renderer.device());
    let mut engine = Engine {
        renderer: gpui_gpu::RetainedRenderer::new(renderer),
        view: target.create_view(&Default::default()),
        packet: None,
    };
    let mut samples = Vec::with_capacity(WARM + MEASURED);
    let initial = engine.frame(&mut owner, 0, |_| {});
    let memory_initial = memory();
    let mut memory_warm = String::new();
    for step in 1..=WARM + MEASURED {
        let s = engine.frame(&mut owner, step, |w| update(w, step % 2 == 1));
        let structural = s.layout.work.plan_attempts > 0;
        if structural {
            assert_eq!(s.layout.work.authority_declines, 0);
            assert_eq!(s.layout.producer.layout_full_rebuilds, 0);
        }
        samples.push(s);
        if step == WARM {
            memory_warm = memory();
        }
    }
    let memory_end = memory();
    let mut allocations = Vec::new();
    for next in [true, false] {
        owner.structural_reset();
        let a = allocation_counter::measure(|| update(&mut owner, next));
        let snapshot = owner.layout_cost_snapshot();
        let token = engine.publish(&mut owner);
        engine.finish(&mut owner, token);
        allocations.push(json!({"direction":usize::from(!next),"bytes":a.bytes_total,"count":a.count_total,"peak_delta":a.bytes_max,"retained_delta":a.bytes_current,"layout":snapshot}));
    }
    let actual = read(&engine.renderer, &target);
    let mut fresh = Win::with_size(build(false), 64, 64).unwrap();
    fresh.layout_preservation_mode(Mode::Automatic);
    owner
        .layout_capture()
        .assert_equivalent(&fresh.layout_capture());
    let cpu = owner.with_pixels(|p, _, _| p.to_vec()).unwrap();
    let fresh_cpu = fresh.with_pixels(|p, _, _| p.to_vec()).unwrap();
    assert_eq!(cpu, fresh_cpu, "fresh full CPU layout/pixel oracle");
    let mut full = pollster::block_on(Renderer::new(
        engine.renderer.device().clone(),
        engine.renderer.queue().clone(),
        wgpu::TextureFormat::Rgba8UnormSrgb,
    ))
    .unwrap();
    let oracle_target = texture(engine.renderer.device());
    fresh
        .with_scene(|scene, _| full.render(scene, &oracle_target.create_view(&Default::default())))
        .unwrap()
        .unwrap();
    let expected = read(&engine.renderer, &oracle_target);
    let wrong = actual.iter().zip(&expected).filter(|(a, b)| a != b).count();
    std::fs::write(output.join("final.rgba"), actual).unwrap();
    std::fs::write(output.join("oracle.rgba"), expected).unwrap();
    std::fs::write(output.join("final.cpu.rgba"), cpu).unwrap();
    std::fs::write(output.join("fresh.cpu.rgba"), fresh_cpu).unwrap();
    json!({"warm":WARM,"measured":MEASURED,"owner_setup_ns":owner_setup_ns,"initial":initial,"samples":samples,"allocations":allocations,"memory":{"initial":memory_initial,"warm":memory_warm,"end_before_allocations_oracle":memory_end,"after_oracle":memory()},"final_wrong_bytes":wrong,"sample_capacity_bytes":samples.capacity()*size_of::<Sample>(),"target_bytes":16384,"scope":"matched feature selectors; native packet decision and serial raw retained renderer; CPU and GPU separate exact oracles, inherited cross-backend gate unchanged"})
}
#[test]
#[ignore = "frozen layout cost driver only"]
fn complete_endpoint() {
    let output = std::path::PathBuf::from(std::env::var("GPUI_LAYOUT_COST_OUTPUT").unwrap());
    std::fs::create_dir(&output).unwrap();
    let name = std::env::var("GPUI_LAYOUT_COST_MODE").unwrap();
    let family = std::env::var("GPUI_LAYOUT_COST_FAMILY").unwrap();
    let mode = match name.as_str() {
        "automatic" => Mode::Automatic,
        "ordered" => Mode::Ordered,
        "append" => Mode::Append,
        _ => panic!("mode"),
    };
    let setup = Instant::now();
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
        let info = format!("{:?}", adapter.get_info());
        let (device, queue) = adapter.request_device(&Default::default()).await.unwrap();
        let renderer = Renderer::new(device, queue, wgpu::TextureFormat::Rgba8UnormSrgb)
            .await
            .unwrap();
        let setup_ns = setup.elapsed().as_nanos() as u64;
        let mut result = match family.as_str() {
            "keyed4" | "unkeyed4" | "keyed256" | "reorder256" | "unkeyedmove" => {
                let keyed = !family.starts_with("unkeyed");
                let fillers = if family.ends_with("256") { 256 } else { 4 };
                let reorder = family == "reorder256" || family == "unkeyedmove";
                let keys = |next| {
                    if next {
                        if reorder {
                            vec![3, 1, 2]
                        } else {
                            vec![1, 9, 2, 3]
                        }
                    } else {
                        vec![1, 2, 3]
                    }
                };
                run(
                    renderer,
                    mode,
                    |next| Tree::new(keyed, fillers, keys(next)),
                    |w, next| {
                        w.set(Tree::KEYS, keys(next)).unwrap();
                    },
                    &output,
                )
            }
            "resources" => run(
                renderer,
                mode,
                Resources::new,
                |w, next| {
                    w.set(Resources::NEXT, next).unwrap();
                },
                &output,
            ),
            "constraints" => run(
                renderer,
                mode,
                |next| Constrained {
                    narrow: Signal::new(next),
                },
                |w, next| {
                    w.set(Constrained::NARROW, next).unwrap();
                },
                &output,
            ),
            "measured" => run(
                renderer,
                mode,
                |next| Measured::new(usize::from(next)),
                |w, next| {
                    w.set(Measured::VALUES, Measured::values(usize::from(next)))
                        .unwrap();
                },
                &output,
            ),
            _ => panic!("family"),
        };
        result["mode"] = json!(name);
        result["family"] = json!(family);
        result["device_pipeline_setup_ns"] = json!(setup_ns);
        result["adapter"] = json!(info);
        std::fs::write(
            output.join("result.json"),
            serde_json::to_vec(&result).unwrap(),
        )
        .unwrap();
        assert_eq!(result["final_wrong_bytes"], 0);
    });
}
