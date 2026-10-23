use crate::{
    device::Device as CoreDevice, global::Global, indirect_validation::IndirectValidation,
};
use alloc::{string::String, vec};
use hal::Device as _;
use std::println;
use std::sync::{
    atomic::{AtomicBool, AtomicUsize, Ordering},
    Arc, Mutex,
};

pub(crate) struct Events {
    log: Mutex<Vec<&'static str>>,
    step: AtomicUsize,
    fail: AtomicUsize,
    panic: AtomicUsize,
    device_id: Mutex<Option<crate::id::DeviceId>>,
    oom: AtomicBool,
    fail_shader: AtomicBool,
    shader_attempts: AtomicUsize,
    unique_handles: bool,
    live_handles: Mutex<[Option<(&'static str, usize)>; 128]>,
    layout_flags: Mutex<Vec<hal::PipelineLayoutFlags>>,
    fault: AtomicUsize,
    buffers: Mutex<Vec<(usize, String, u64, wgt::BufferUses)>>,
    maps: Mutex<Vec<(usize, usize, usize)>>,
    uploads: Mutex<Vec<(usize, [u8; 512])>>,
    copies: Mutex<Vec<(usize, usize, u64)>>,
}
impl Default for Events {
    fn default() -> Self {
        Self {
            log: Mutex::new(Vec::new()),
            step: AtomicUsize::new(0),
            fail: AtomicUsize::new(0),
            panic: AtomicUsize::new(0),
            device_id: Mutex::new(None),
            oom: AtomicBool::new(false),
            fail_shader: AtomicBool::new(false),
            shader_attempts: AtomicUsize::new(0),
            unique_handles: false,
            live_handles: Mutex::new([None; 128]),
            layout_flags: Mutex::new(Vec::new()),
            fault: AtomicUsize::new(0),
            buffers: Mutex::new(Vec::new()),
            maps: Mutex::new(Vec::new()),
            uploads: Mutex::new(Vec::new()),
            copies: Mutex::new(Vec::new()),
        }
    }
}
fn handle<T: ?Sized>(value: &T) -> usize {
    core::ptr::from_ref(value).cast::<()>() as usize
}
struct Probe {
    inner: Box<dyn hal::DynDevice>,
    events: Arc<Events>,
}
impl hal::DynResource for Probe {
    fn as_any(&self) -> &dyn core::any::Any {
        self.inner.as_any()
    }
    fn as_any_mut(&mut self) -> &mut dyn core::any::Any {
        self.inner.as_any_mut()
    }
}
impl Probe {
    fn record(&self, operation: &'static str) {
        self.events
            .log
            .lock()
            .unwrap_or_else(|e| e.into_inner())
            .push(operation);
    }
    fn record_handle(&self, operation: &'static str, handle: usize) {
        self.record(operation);
        if operation == "create_command_encoder" {
            return;
        }
        let mut live = self.events.live_handles.lock().unwrap();
        if let Some(kind) = operation.strip_prefix("create_") {
            if self.events.unique_handles {
                assert!(
                    !live.contains(&Some((kind, handle))),
                    "duplicate live handle {kind} {handle}"
                );
            }
            *live.iter_mut().find(|slot| slot.is_none()).unwrap() = Some((kind, handle));
        } else if let Some(kind) = operation.strip_prefix("destroy_") {
            let slot = live
                .iter_mut()
                .find(|slot| **slot == Some((kind, handle)))
                .expect("destroyed handle was not acquired or was already destroyed");
            *slot = None;
        }
    }
    fn error(&self) -> hal::DeviceError {
        if self.events.oom.load(Ordering::SeqCst) {
            hal::DeviceError::OutOfMemory
        } else {
            hal::DeviceError::Lost
        }
    }
    fn before<E>(&self, operation: &'static str, error: impl FnOnce() -> E) -> Result<(), E> {
        if operation == "create_shader_module" {
            self.events.shader_attempts.fetch_add(1, Ordering::SeqCst);
            if self.events.fail_shader.swap(false, Ordering::SeqCst) {
                return Err(error());
            }
        }
        let step = self.events.step.fetch_add(1, Ordering::SeqCst) + 1;
        assert_ne!(
            step,
            self.events.panic.load(Ordering::SeqCst),
            "injected HAL unwind"
        );
        if step == self.events.fail.load(Ordering::SeqCst) {
            Err(error())
        } else {
            Ok(())
        }
    }
}
include!("proxy.rs");
include!("allocator.rs");
include!("encoder-proxy.rs");

fn params(device: &CoreDevice) -> Option<&dyn hal::DynBuffer> {
    device.default_external_texture_params_buffer.as_deref()
}

fn fixture(
    backend: wgt::Backends,
    external: bool,
    fault: usize,
    oom: bool,
) -> (
    Global,
    Result<(Arc<CoreDevice>, crate::id::QueueId), crate::instance::RequestDeviceError>,
    Arc<Events>,
) {
    let mut desc = wgt::InstanceDescriptor::new_without_display_handle();
    desc.backends = backend;
    desc.flags = wgt::InstanceFlags::empty();
    desc.backend_options.noop.enable = true;
    let global = Global::new("external params qualification", desc, None);
    let adapter = global
        .instance
        .enumerate_adapters(backend, false)
        .into_iter()
        .next()
        .unwrap();
    let adapter_id = global.hub.adapters.prepare(None).assign(Arc::new(adapter));
    let adapter = global.hub.adapters.get(adapter_id);
    let descriptor = crate::device::DeviceDescriptor {
        required_features: if external {
            wgt::Features::EXTERNAL_TEXTURE
        } else {
            wgt::Features::empty()
        },
        #[cfg(feature = "trace")]
        trace: wgt::Trace::Memory,
        ..Default::default()
    };
    let mut opened = unsafe {
        adapter.raw.adapter.open(
            descriptor.required_features,
            &descriptor.required_limits,
            &descriptor.memory_hints,
        )
    }
    .unwrap();
    let events = Arc::new(Events {
        log: Mutex::new(Vec::with_capacity(128)),
        unique_handles: backend == wgt::Backends::VULKAN,
        buffers: Mutex::new(Vec::with_capacity(16)),
        maps: Mutex::new(Vec::with_capacity(16)),
        uploads: Mutex::new(Vec::with_capacity(16)),
        copies: Mutex::new(Vec::with_capacity(16)),
        fault: AtomicUsize::new(fault),
        oom: AtomicBool::new(oom),
        ..Default::default()
    });
    opened.device = Box::new(Probe {
        inner: opened.device,
        events: events.clone(),
    });
    let (result, counts) = measured(|| unsafe {
        global.create_device_from_hal(adapter_id, opened, &descriptor, None, None)
    });
    println!("constructor backend={backend:?} external={external} fault={fault} oom={oom} allocations={counts:?}");
    let result = result.map(|(id, queue)| (global.hub.devices.get(id), queue));
    (global, result, events)
}
fn balanced(events: &Events) {
    let live = events.live_handles.lock().unwrap();
    assert!(live.iter().all(Option::is_none), "live handles: {live:?}");
}
fn external_entries() -> [wgt::BindGroupLayoutEntry; 1] {
    [wgt::BindGroupLayoutEntry {
        binding: 0,
        visibility: wgt::ShaderStages::FRAGMENT,
        ty: wgt::BindingType::ExternalTexture,
        count: None,
    }]
}
fn layout(
    device: &Arc<CoreDevice>,
) -> (
    Arc<crate::binding_model::BindGroupLayout>,
    Option<crate::binding_model::CreateBindGroupLayoutError>,
) {
    device.create_bind_group_layout(&crate::binding_model::BindGroupLayoutDescriptor {
        label: None,
        entries: alloc::borrow::Cow::Owned(external_entries().to_vec()),
    })
}
fn view(device: &Arc<CoreDevice>) -> Arc<crate::resource::TextureView> {
    let (texture, error) = device.create_texture(&wgt::TextureDescriptor {
        label: None,
        size: wgt::Extent3d {
            width: 2,
            height: 2,
            depth_or_array_layers: 1,
        },
        mip_level_count: 1,
        sample_count: 1,
        dimension: wgt::TextureDimension::D2,
        format: wgt::TextureFormat::Rgba8Unorm,
        usage: wgt::TextureUsages::TEXTURE_BINDING,
        view_formats: Vec::new(),
    });
    assert!(error.is_none(), "{error:?}");
    device
        .create_texture_view(
            &texture,
            &crate::resource::TextureViewDescriptor {
                label: None,
                format: None,
                dimension: None,
                usage: None,
                range: Default::default(),
            },
        )
        .unwrap()
}
fn bind(
    device: &Arc<CoreDevice>,
    layout: Arc<crate::binding_model::BindGroupLayout>,
) -> Result<Arc<crate::binding_model::BindGroup>, crate::binding_model::CreateBindGroupError> {
    let view = view(device);
    device.create_bind_group(crate::binding_model::ResolvedBindGroupDescriptor {
        label: None,
        layout,
        entries: alloc::borrow::Cow::Owned(vec![crate::binding_model::ResolvedBindGroupEntry {
            binding: 0,
            resource: crate::binding_model::BindingResource::TextureView(view),
        }]),
    })
}

#[test]
fn external_constructor_counts_headers_and_drop() {
    for backend in [wgt::Backends::NOOP, wgt::Backends::VULKAN] {
        for _ in 0..3 {
            let (global, result, events) = fixture(backend, false, 0, false);
            let (device, _) = result.unwrap();
            assert!(params(&device).is_none());
            assert!(events.maps.lock().unwrap().is_empty());
            assert!(events.copies.lock().unwrap().is_empty());
            assert_eq!(events.buffers.lock().unwrap().len(), 1);
            let buffer = device
                .create_buffer(&wgt::BufferDescriptor {
                    label: None,
                    size: 64,
                    usage: wgt::BufferUsages::COPY_DST,
                    mapped_at_creation: false,
                })
                .unwrap();
            drop(buffer);
            drop(device);
            drop(global);
            balanced(&events);
            println!("HAL {backend:?} {:?}", events.log.lock().unwrap());
        }
    }
    println!(
        "headers Device={} params_option={} params_old={} params_data={}",
        size_of::<CoreDevice>(),
        size_of::<Option<Box<dyn hal::DynBuffer>>>(),
        size_of::<core::mem::ManuallyDrop<Box<dyn hal::DynBuffer>>>(),
        size_of::<super::ExternalTextureParams>()
    );
}

#[test]
fn external_enabled_upload_binding_get_layout_and_queue_drop() {
    let (global, result, events) = fixture(wgt::Backends::NOOP, true, 0, false);
    let (device, queue) = result.unwrap();
    let destination = handle(params(&device).unwrap());
    assert_eq!(events.buffers.lock().unwrap().len(), 3);
    assert_eq!(events.copies.lock().unwrap().len(), 1);
    let uploads = events.uploads.lock().unwrap();
    assert_eq!(uploads.len(), 1);
    let data: super::ExternalTextureParams =
        bytemuck::pod_read_unaligned(&uploads[0].1[..uploads[0].0]);
    assert_eq!(
        data.yuv_conversion_matrix,
        [1., 0., 0., 0., 0., 1., 0., 0., 0., 0., 1., 0., 0., 0., 0., 1.]
    );
    assert_eq!(
        data.gamut_conversion_matrix,
        [1., 0., 0., 0., 0., 1., 0., 0., 0., 0., 1., 0.]
    );
    assert_eq!(data.sample_transform, [1., 0., 0., 1., 0., 0.]);
    assert_eq!(data.load_transform, data.sample_transform);
    assert_eq!(
        bytemuck::bytes_of(&data.src_transfer_function),
        bytemuck::bytes_of(&wgt::ExternalTextureTransferFunction::default())
    );
    assert_eq!(
        bytemuck::bytes_of(&data.dst_transfer_function),
        bytemuck::bytes_of(&wgt::ExternalTextureTransferFunction::default())
    );
    assert_eq!(data._padding, [0; 4]);
    assert_eq!(data.num_planes, 1);
    assert_eq!(data.size, [0, 0]);
    assert_eq!(events.copies.lock().unwrap()[0].1, destination);
    assert_eq!(events.copies.lock().unwrap()[0].2, uploads[0].0 as u64);
    drop(uploads);
    let (bgl, error) = layout(&device);
    assert!(error.is_none());
    let (pipeline, error) =
        device.create_pipeline_layout(&crate::binding_model::PipelineLayoutDescriptor {
            label: None,
            bind_group_layouts: alloc::borrow::Cow::Owned(vec![Some(bgl.clone())]),
            immediate_size: 0,
        });
    assert!(error.is_none());
    let returned = pipeline
        .get_bind_group_layout(0, crate::binding_model::ExclusivePipeline::None)
        .unwrap();
    assert!(Arc::ptr_eq(&returned, &bgl));
    global.queue_submit(queue, &[]).unwrap();
    global.queue_drop(queue);
    assert!(device.get_queue().is_none());
    let group = bind(&device, returned).unwrap();
    assert_eq!(
        events.buffers.lock().unwrap().len(),
        3,
        "binding must not initialize again"
    );
    drop(group);
    drop(pipeline);
    drop(bgl);
    drop(device);
    drop(global);
    balanced(&events);
}

#[test]
fn external_disabled_rejects_explicit_derived_invalid_foreign_and_trace_replay() {
    let (global, result, events) = fixture(wgt::Backends::NOOP, false, 0, false);
    let (device, _) = result.unwrap();
    let (invalid, error) = layout(&device);
    assert!(error.is_some());
    assert!(bind(&device, invalid).is_err());
    let entry_map = super::bgl::EntryMap::from_entries(&external_entries()).unwrap();
    let mut maps = Box::new(arrayvec::ArrayVec::new());
    maps.push(entry_map);
    assert!(device.create_derived_pipeline_layout(maps, 0).is_err());
    let (other, result, other_events) = fixture(wgt::Backends::NOOP, true, 0, false);
    let (foreign, _) = result.unwrap();
    let (foreign_layout, error) = layout(&foreign);
    assert!(error.is_none());
    assert!(bind(&device, foreign_layout).is_err());
    #[cfg(feature = "trace")]
    {
        use crate::device::trace::{Action, MemoryTrace};
        let trace = device.take_trace().unwrap();
        let any: &dyn core::any::Any = trace.as_ref();
        let actions = any.downcast_ref::<MemoryTrace>().unwrap().actions();
        assert!(
            matches!(&actions[0], Action::Init { desc, .. } if !desc.required_features.contains(wgt::Features::EXTERNAL_TEXTURE))
        );
        let (replay, replay_result, replay_events) = fixture(wgt::Backends::NOOP, false, 0, false);
        let (replay_device, _) = replay_result.unwrap();
        for action in actions {
            if let Action::CreateBindGroupLayout(_, descriptor) = action {
                let (_, error) = replay_device.create_bind_group_layout(descriptor);
                assert!(error.is_some());
            }
        }
        assert!(params(&replay_device).is_none());
        assert!(replay_events.copies.lock().unwrap().is_empty());
        drop(replay_device);
        drop(replay);
        balanced(&replay_events);
    }
    assert_eq!(events.buffers.lock().unwrap().len(), 1);
    assert!(events.copies.lock().unwrap().is_empty());
    drop(foreign);
    drop(other);
    balanced(&other_events);
    drop(device);
    drop(global);
    balanced(&events);
}

#[test]
fn external_feature_disabled_skips_all_default_params_faults() {
    for backend in [wgt::Backends::NOOP, wgt::Backends::VULKAN] {
        for fault in 1..=6 {
            let (global, result, events) = fixture(backend, false, fault, true);
            let (device, _) = result.unwrap();
            assert!(params(&device).is_none());
            drop(device);
            drop(global);
            balanced(&events);
        }
    }
}

#[test]
fn external_enabled_faults_preserve_existing_errors_and_cleanup_limits() {
    for oom in [false, true] {
        for fault in 1..=3 {
            let (global, result, events) = fixture(wgt::Backends::NOOP, true, fault, oom);
            let error = result.unwrap_err();
            let expected_oom = oom;
            assert!(
                matches!(
                    error,
                    crate::instance::RequestDeviceError::Device(
                        crate::device::DeviceError::OutOfMemory
                    )
                ) == expected_oom,
                "{error:?}"
            );
            if !expected_oom {
                assert!(
                    matches!(
                        error,
                        crate::instance::RequestDeviceError::Device(
                            crate::device::DeviceError::Lost
                        )
                    ),
                    "{error:?}"
                );
            }
            drop(global);
            let live = events.live_handles.lock().unwrap();
            let count = live.iter().flatten().count();
            // These are inherited eager-path cleanup limits, pinned against
            // the unmodified control, not successful cleanup claims.
            assert_eq!(count, [3, 0, 1][fault - 1], "{live:?}");
            println!("enabled fault={fault} oom={oom} error={error:?} residual_handles={live:?}");
        }
    }
}

#[test]
fn external_safe_request_and_empty_get_layout() {
    for external in [false, true] {
        let mut desc = wgt::InstanceDescriptor::new_without_display_handle();
        desc.backends = wgt::Backends::NOOP;
        desc.flags = wgt::InstanceFlags::empty();
        desc.backend_options.noop.enable = true;
        let global = Global::new("safe requested feature", desc, None);
        let adapter = global
            .instance
            .enumerate_adapters(wgt::Backends::NOOP, false)
            .into_iter()
            .next()
            .unwrap();
        let id = global.hub.adapters.prepare(None).assign(Arc::new(adapter));
        let descriptor = crate::device::DeviceDescriptor {
            required_features: if external {
                wgt::Features::EXTERNAL_TEXTURE
            } else {
                wgt::Features::empty()
            },
            ..Default::default()
        };
        let (id, _) = global
            .adapter_request_device(id, &descriptor, None, None)
            .unwrap();
        let device = global.hub.devices.get(id);
        assert_eq!(params(&device).is_some(), external);
        let (external_layout, error) = layout(&device);
        assert_eq!(error.is_none(), external);
        drop(external_layout);
        let (pipeline, error) =
            device.create_pipeline_layout(&crate::binding_model::PipelineLayoutDescriptor {
                label: None,
                bind_group_layouts: alloc::borrow::Cow::Borrowed(&[]),
                immediate_size: 0,
            });
        assert!(error.is_none());
        let empty = pipeline
            .get_bind_group_layout(0, crate::binding_model::ExclusivePipeline::None)
            .unwrap();
        assert!(empty.entries.is_empty());
        let group = device
            .create_bind_group(crate::binding_model::ResolvedBindGroupDescriptor {
                label: None,
                layout: empty,
                entries: alloc::borrow::Cow::Borrowed(&[]),
            })
            .unwrap();
        drop(group);
        drop(pipeline);
        drop(device);
        drop(global);
    }
}
