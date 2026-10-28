//! Public API lifetime/error fixture. The optional native layer only observes or
//! injects calls; this executable is never used for allocation measurements.
use gpui_gpu::wgpu;
use std::{borrow::Cow, ffi::CString};
include!(concat!(
    env!("CARGO_MANIFEST_DIR"),
    "/../../evidence/static-shader/modules/words.rs"
));

type Phase = unsafe extern "C" fn(*const std::ffi::c_char, u64, i32);
struct Probe {
    _library: libloading::Library,
    phase: Phase,
}
impl Probe {
    fn load() -> Self {
        let path = std::env::var_os("GPUI_STATIC_PROBE_LAYER").expect("test layer path");
        // SAFETY: load our exact pinned test-only library and its declared C ABI.
        let library = unsafe { libloading::Library::new(path) }.unwrap();
        let phase = unsafe { *library.get::<Phase>(b"gpui_shader_probe_phase\0").unwrap() };
        Self {
            _library: library,
            phase,
        }
    }
    fn phase(&self, name: &str, module: u64, pipeline: bool) {
        let name = CString::new(name).unwrap();
        // SAFETY: the library remains loaded; C borrows this string synchronously.
        // All worker threads have joined before the fixture changes a phase.
        unsafe { (self.phase)(name.as_ptr(), module, i32::from(pipeline)) };
    }
}
fn shader(
    device: &wgpu::Device,
    words: &'static [u32],
    name: &'static str,
    raw: bool,
) -> wgpu::ShaderModule {
    let entries = [wgpu::PassthroughShaderEntryPoint {
        name: Cow::Borrowed(name),
        workgroup_size: if name == "compute" {
            (1, 1, 1)
        } else {
            (0, 0, 0)
        },
    }];
    // SAFETY: pinned generator validates this source with Naga and spirv-val.
    // Each module has exactly one named stage, no resource interface, overrides,
    // workgroup memory or unchecked dynamic accesses. The enabled Device feature
    // and Vulkan backend are established in normal cases. Missing-feature and
    // unsupported-backend probes deliberately reject before reaching HAL. These fixtures
    // test ownership, not arbitrary shader ingestion or the GPUI artifact family.
    unsafe {
        if raw {
            device.create_shader_module_passthrough(wgpu::ShaderModuleDescriptorPassthrough {
                label: Some(name),
                entry_points: Cow::Borrowed(&entries),
                spirv: Some(Cow::Borrowed(words)),
                ..Default::default()
            })
        } else {
            device
                .create_shader_module_static_spirv(Some(name), &entries, words)
                .unwrap()
        }
    }
}
fn render(
    device: &wgpu::Device,
    layout: &wgpu::PipelineLayout,
    vertex: &wgpu::ShaderModule,
    fragment: &wgpu::ShaderModule,
) -> wgpu::RenderPipeline {
    device.create_render_pipeline(&wgpu::RenderPipelineDescriptor {
        label: Some("static recipe ownership probe"),
        layout: Some(layout),
        vertex: wgpu::VertexState {
            module: vertex,
            entry_point: Some("vertex"),
            compilation_options: Default::default(),
            buffers: &[],
        },
        primitive: Default::default(),
        depth_stencil: None,
        multisample: Default::default(),
        fragment: Some(wgpu::FragmentState {
            module: fragment,
            entry_point: Some("fragment"),
            compilation_options: Default::default(),
            targets: &[Some(wgpu::ColorTargetState {
                format: wgpu::TextureFormat::Rgba8Unorm,
                blend: None,
                write_mask: wgpu::ColorWrites::ALL,
            })],
        }),
        multiview_mask: None,
        cache: None,
    })
}
fn compute(
    device: &wgpu::Device,
    layout: &wgpu::PipelineLayout,
    module: &wgpu::ShaderModule,
) -> wgpu::ComputePipeline {
    device.create_compute_pipeline(&wgpu::ComputePipelineDescriptor {
        label: Some("static compute ownership probe"),
        layout: Some(layout),
        module,
        entry_point: Some("compute"),
        compilation_options: Default::default(),
        cache: None,
    })
}
fn failure(device: &wgpu::Device, build: impl FnOnce()) {
    let oom = device.push_error_scope(wgpu::ErrorFilter::OutOfMemory);
    let validation = device.push_error_scope(wgpu::ErrorFilter::Validation);
    let internal = device.push_error_scope(wgpu::ErrorFilter::Internal);
    build();
    let errors = [
        pollster::block_on(internal.pop()),
        pollster::block_on(validation.pop()),
        pollster::block_on(oom.pop()),
    ];
    assert!(
        errors.iter().any(Option::is_some),
        "injected failure must propagate"
    );
    eprintln!("PROBE_ERRORS {errors:?}");
}
fn main() {
    let probe = Probe::load();
    let mode = std::env::args().nth(1).unwrap_or_else(|| "success".into());
    let missing = mode == "missing-feature";
    #[cfg(feature = "noop")]
    if mode == "unsupported-backend" {
        let (device, _queue) = wgpu::Device::noop(&wgpu::DeviceDescriptor {
            required_features: wgpu::Features::PASSTHROUGH_SHADERS,
            ..Default::default()
        });
        assert!(device.shader_artifact_profile().is_none());
        probe.phase("unsupported-backend", 0, false);
        failure(&device, || {
            drop(shader(&device, &VERTEX, "vertex", false));
        });
        probe.phase("end", 0, false);
        return;
    }

    let (_instance, adapter) = gpui_gpu_owner_fixture::adapter();
    let mut descriptor = wgpu::DeviceDescriptor {
        required_features: if missing {
            wgpu::Features::empty()
        } else {
            wgpu::Features::PASSTHROUGH_SHADERS
        },
        ..Default::default()
    };
    #[cfg(feature = "trace")]
    if let Some(path) = std::env::var_os("GPUI_STATIC_TRACE") {
        descriptor.trace = wgpu::Trace::Directory(path.into());
    }
    #[cfg(not(feature = "trace"))]
    let _ = &mut descriptor;
    let (device, _queue) = pollster::block_on(adapter.request_device(&descriptor)).unwrap();
    if missing {
        probe.phase("missing-feature", 0, false);
        failure(&device, || {
            drop(shader(&device, &VERTEX, "vertex", false));
        });
        probe.phase("end", 0, false);
        return;
    }
    assert!(device.shader_artifact_profile().is_some());
    let layout = device.create_pipeline_layout(&wgpu::PipelineLayoutDescriptor {
        label: None,
        bind_group_layouts: &[],
        immediate_size: 0,
    });
    if mode != "success" {
        let raw = mode == "raw-pipeline-failure";
        probe.phase(if raw { "raw-create" } else { "static-create" }, 0, false);
        let vertex = shader(&device, &VERTEX, "vertex", raw);
        let fragment = shader(&device, &FRAGMENT, "fragment", raw);
        let kernel = shader(&device, &COMPUTE, "compute", false);
        let (failed_module, failed_pipeline) = match mode.as_str() {
            "static-module-first-failure" | "static-compute-module-failure" => (1, false),
            "static-module-second-failure" => (2, false),
            "static-pipeline-failure"
            | "static-compute-pipeline-failure"
            | "raw-pipeline-failure" => (0, true),
            _ => panic!("unknown failure mode"),
        };
        probe.phase(&mode, failed_module, failed_pipeline);
        failure(&device, || {
            if mode.starts_with("static-compute") {
                drop(compute(&device, &layout, &kernel));
            } else {
                drop(render(&device, &layout, &vertex, &fragment));
            }
        });
        // Core loses the Device on HAL OOM. Every injection therefore runs in
        // its own process/Device; later creates cannot validate driver cleanup.
        probe.phase("failed-public-shaders-drop", 0, false);
        drop((vertex, fragment, kernel));
        probe.phase("end", 0, false);
        return;
    }
    probe.phase("static-create", 0, false);
    let vertex = shader(&device, &VERTEX, "vertex", false);
    let fragment = shader(&device, &FRAGMENT, "fragment", false);
    let kernel = shader(&device, &COMPUTE, "compute", false);
    probe.phase("static-render-first", 0, false);
    let first = render(&device, &layout, &vertex, &fragment);
    probe.phase("static-render-repeat", 0, false);
    let second = render(&device, &layout, &vertex, &fragment);
    probe.phase("static-concurrent", 0, false);
    let pipelines = std::thread::scope(|scope| {
        let workers: Vec<_> = (0..4)
            .map(|_| scope.spawn(|| render(&device, &layout, &vertex, &fragment)))
            .collect();
        workers
            .into_iter()
            .map(|worker| worker.join().unwrap())
            .collect::<Vec<_>>()
    });
    probe.phase("static-compute-repeat", 0, false);
    let kernels: Vec<_> = (0..3).map(|_| compute(&device, &layout, &kernel)).collect();
    probe.phase("static-public-shaders-drop", 0, false);
    drop((vertex, fragment, kernel));
    probe.phase("static-pipelines-drop", 0, false);
    drop((first, second, pipelines, kernels));
    probe.phase("raw-create", 0, false);
    let vertex = shader(&device, &VERTEX, "vertex", true);
    let fragment = shader(&device, &FRAGMENT, "fragment", true);
    let kernel = shader(&device, &COMPUTE, "compute", true);
    probe.phase("raw-render-repeat", 0, false);
    let first = render(&device, &layout, &vertex, &fragment);
    let second = render(&device, &layout, &vertex, &fragment);
    probe.phase("raw-concurrent", 0, false);
    let pipelines = std::thread::scope(|scope| {
        let workers: Vec<_> = (0..4)
            .map(|_| scope.spawn(|| render(&device, &layout, &vertex, &fragment)))
            .collect();
        workers
            .into_iter()
            .map(|worker| worker.join().unwrap())
            .collect::<Vec<_>>()
    });
    probe.phase("raw-compute-repeat", 0, false);
    let kernels: Vec<_> = (0..3).map(|_| compute(&device, &layout, &kernel)).collect();
    probe.phase("raw-public-shaders-drop", 0, false);
    drop((vertex, fragment, kernel));
    probe.phase("raw-pipelines-drop", 0, false);
    drop((first, second, pipelines, kernels));
    device.poll(wgpu::PollType::wait_indefinitely()).unwrap();
    probe.phase("end", 0, false);
}
