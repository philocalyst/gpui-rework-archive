use crate::{
    device::Device as CoreDevice, global::Global, indirect_validation::IndirectValidation,
};
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

pub(crate) fn fixture(
    backend: wgt::Backends,
    enabled: bool,
) -> (Global, Arc<CoreDevice>, Arc<Events>) {
    fixture_gate(backend, enabled, 0)
}
fn fixture_gate(
    backend: wgt::Backends,
    enabled: bool,
    gate: u8,
) -> (Global, Arc<CoreDevice>, Arc<Events>) {
    let mut desc = wgt::InstanceDescriptor::new_without_display_handle();
    desc.backends = backend;
    desc.flags = if enabled {
        wgt::InstanceFlags::VALIDATION_INDIRECT_CALL
    } else {
        wgt::InstanceFlags::empty()
    };
    desc.backend_options.noop.enable = true;
    let global = Global::new("lazy validation qualification", desc, None);
    let mut adapter = global
        .instance
        .enumerate_adapters(backend, false)
        .into_iter()
        .next()
        .unwrap();
    if gate == 1 {
        adapter
            .raw
            .capabilities
            .downlevel
            .flags
            .remove(wgt::DownlevelFlags::INDIRECT_EXECUTION);
    }
    if gate == 2 {
        adapter
            .raw
            .capabilities
            .downlevel
            .flags
            .remove(wgt::DownlevelFlags::COMPUTE_SHADERS);
    }
    if gate == 3 {
        adapter
            .raw
            .capabilities
            .limits
            .max_storage_buffers_per_shader_stage = 1;
    }
    let id = global.hub.adapters.prepare(None).assign(Arc::new(adapter));
    let adapter = global.hub.adapters.get(id);
    let mut descriptor = crate::device::DeviceDescriptor::default();
    if gate == 3 {
        descriptor
            .required_limits
            .max_storage_buffers_per_shader_stage = 1;
    }
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
        layout_flags: Mutex::new(Vec::with_capacity(32)),
        ..Default::default()
    });
    opened.device = Box::new(Probe {
        inner: opened.device,
        events: events.clone(),
    });
    let ((device, _), counts) = measured(|| {
        unsafe { global.create_device_from_hal(id, opened, &descriptor, None, None) }.unwrap()
    });
    if backend == wgt::Backends::VULKAN {
        println!("constructor Rust allocator [alloc/realloc calls, requested bytes, dealloc/realloc calls, freed bytes, retained new bytes, freed old bytes, overflow]={counts:?}");
    }
    *events.device_id.lock().unwrap() = Some(device);
    let device = global.hub.devices.get(device);
    (global, device, events)
}
fn buffer(
    device: &Arc<CoreDevice>,
    indirect: bool,
) -> Result<Arc<crate::resource::Buffer>, crate::resource::CreateBufferError> {
    device.create_buffer(&wgt::BufferDescriptor {
        label: None,
        size: 256,
        usage: if indirect {
            wgt::BufferUsages::INDIRECT
        } else {
            wgt::BufferUsages::COPY_DST
        },
        mapped_at_creation: false,
    })
}
pub(crate) fn arm(events: &Events, fail: usize, panic: usize) -> usize {
    events.step.store(0, Ordering::SeqCst);
    events.fail.store(fail, Ordering::SeqCst);
    events.panic.store(panic, Ordering::SeqCst);
    events.log.lock().unwrap().len()
}
fn balanced(log: &[&str]) {
    let mut counts = std::collections::BTreeMap::<&str, isize>::new();
    for operation in log {
        if *operation == "create_command_encoder" {
            continue;
        } // HAL encoder owns its Drop.
        if let Some(kind) = operation.strip_prefix("create_") {
            *counts.entry(kind).or_default() += 1;
        }
        if let Some(kind) = operation.strip_prefix("destroy_") {
            let count = counts.entry(kind).or_default();
            *count -= 1;
            assert!(*count >= 0, "duplicate destruction: {log:?}");
        }
    }
    assert!(
        counts.values().all(|n| *n == 0),
        "leaked resources: {counts:?}; {log:?}"
    );
}

#[test]
fn lazy_direct_reuse_concurrent_and_drop() {
    let (global, device, events) = fixture(wgt::Backends::NOOP, true);
    assert!(device.indirect_validation.as_ref().unwrap().get().is_none());
    let (layout, error) =
        device.create_pipeline_layout(&crate::binding_model::PipelineLayoutDescriptor {
            label: None,
            bind_group_layouts: alloc::borrow::Cow::Borrowed(&[]),
            immediate_size: 0,
        });
    assert!(error.is_none());
    drop(layout);
    assert!(events
        .layout_flags
        .lock()
        .unwrap()
        .last()
        .unwrap()
        .contains(hal::PipelineLayoutFlags::INDIRECT_BUILTIN_UPDATE));
    assert!(device.indirect_validation.as_ref().unwrap().get().is_none());
    drop(crate::indirect_validation::DrawResources::new(
        device.clone(),
    ));
    assert!(device.indirect_validation.as_ref().unwrap().get().is_none());
    let start = arm(&events, 0, 0);
    drop(buffer(&device, false).unwrap());
    assert!(device.indirect_validation.as_ref().unwrap().get().is_none());
    assert_eq!(
        &events.log.lock().unwrap()[start..],
        &["create_buffer", "destroy_buffer"]
    );
    let mut threads = Vec::new();
    for _ in 0..8 {
        let device = device.clone();
        threads.push(std::thread::spawn(move || buffer(&device, true).unwrap()));
    }
    let buffers: Vec<_> = threads.into_iter().map(|t| t.join().unwrap()).collect();
    assert!(device.ready_indirect_validation().is_some());
    let log = events.log.lock().unwrap();
    assert_eq!(
        log.iter()
            .filter(|op| **op == "create_shader_module")
            .count(),
        2
    );
    assert_eq!(
        log.iter()
            .filter(|op| **op == "create_compute_pipeline")
            .count(),
        2
    );
    drop(log);
    drop(buffers);
    drop(device);
    drop(global);
    balanced(&events.log.lock().unwrap());
    println!(
        "lazy direct and 8 concurrent indirect buffers: {:?}",
        events.log.lock().unwrap()
    );
}

#[test]
fn lazy_every_acquisition_failure_and_unwind() {
    // 1 user buffer, 7 dispatch objects, 6 draw objects, 2 source groups.
    for backend in [wgt::Backends::NOOP, wgt::Backends::VULKAN] {
        for unwind in [false, true] {
            for stage in 1..=16 {
                let (global, device, events) = fixture(backend, true);
                let start = arm(
                    &events,
                    if unwind { 0 } else { stage },
                    if unwind { stage } else { 0 },
                );
                let result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
                    buffer(&device, true)
                }));
                if unwind {
                    assert!(result.is_err(), "stage {stage}");
                } else {
                    assert!(result.unwrap().is_err(), "stage {stage}");
                    assert!(
                        !device.is_valid(),
                        "HAL Lost at stage {stage} must invalidate the device"
                    );
                    if (2..=14).contains(&stage) {
                        assert!(matches!(
                            device.indirect_validation.as_ref().unwrap().get(),
                            Some(Err(crate::device::DeviceError::Lost))
                        ));
                        events.fail.store(0, Ordering::SeqCst);
                        let attempts = events.step.load(Ordering::SeqCst);
                        assert!(matches!(
                            buffer(&device, true),
                            Err(crate::resource::CreateBufferError::Device(
                                crate::device::DeviceError::Lost
                            ))
                        ));
                        assert_eq!(
                            events.step.load(Ordering::SeqCst),
                            attempts,
                            "lost device retries HAL work"
                        );
                    }
                }
                // Failed group allocation leaves the successfully initialized owner alive.
                if stage <= 14 {
                    balanced(&events.log.lock().unwrap()[start..]);
                }
                events.panic.store(0, Ordering::SeqCst);
                if unwind && stage <= 14 {
                    assert!(device.indirect_validation.as_ref().unwrap().get().is_none());
                    drop(buffer(&device, true).unwrap());
                }
                drop(device);
                drop(global);
                balanced(&events.log.lock().unwrap());
            }
        }
    }
}

#[test]
fn lazy_imported_failure_and_disabled_policy() {
    for stage in 1..=15 {
        let (global, device, events) = fixture(wgt::Backends::NOOP, true);
        let desc = wgt::BufferDescriptor {
            label: None,
            size: 256,
            usage: wgt::BufferUsages::INDIRECT,
            mapped_at_creation: false,
        };
        // Construct the transferred handle through the underlying HAL, so the
        // import itself is responsible for accounting it exactly once.
        let raw = unsafe {
            device
                .raw()
                .as_any()
                .downcast_ref::<hal::noop::Context>()
                .unwrap()
                .create_buffer(&BufferDescriptor {
                    label: None,
                    size: 256,
                    usage: wgt::BufferUses::INDIRECT | wgt::BufferUses::STORAGE_READ_ONLY,
                    memory_flags: hal::MemoryFlags::empty(),
                })
        }
        .unwrap();
        arm(&events, stage, 0);
        let (result, error) = unsafe { device.create_buffer_from_hal(Box::new(raw), &desc) };
        assert!(error.is_some());
        assert!(matches!(result, crate::resource::Fallible::Invalid(_)));
        drop(device);
        drop(global);
        balanced(&events.log.lock().unwrap());
    }
    for gate in 0..4 {
        let (global, device, events) = fixture_gate(wgt::Backends::NOOP, gate != 0, gate);
        assert!(device.indirect_validation.is_none());
        let (layout, error) =
            device.create_pipeline_layout(&crate::binding_model::PipelineLayoutDescriptor {
                label: None,
                bind_group_layouts: alloc::borrow::Cow::Borrowed(&[]),
                immediate_size: 0,
            });
        assert!(error.is_none());
        drop(layout);
        assert!(!events
            .layout_flags
            .lock()
            .unwrap()
            .last()
            .unwrap()
            .contains(hal::PipelineLayoutFlags::INDIRECT_BUILTIN_UPDATE));
        let result = buffer(&device, true);
        if gate == 1 {
            assert!(result.is_err());
        } else {
            drop(result.unwrap());
        }
        drop(device);
        drop(global);
        assert!(!events.log.lock().unwrap().contains(&"create_shader_module"));
        balanced(&events.log.lock().unwrap());
    }
}

#[test]
fn lazy_native_constructor_counts_and_sizes() {
    for indirect in [false, true] {
        let (global, device, events) = fixture(wgt::Backends::VULKAN, true);
        assert!(device.indirect_validation.as_ref().unwrap().get().is_none());
        for use_number in 0..if indirect { 2 } else { 1 } {
            let (buffer, counts) = measured(|| buffer(&device, indirect).unwrap());
            println!("buffer indirect={indirect} use={use_number} Rust allocator={counts:?}");
            drop(buffer);
        }
        drop(device);
        drop(global);
        balanced(&events.log.lock().unwrap());
        println!(
            "native Vulkan indirect={indirect}: {:?}",
            events.log.lock().unwrap()
        );
    }
    println!(
        "Device={} owner={} policy_cell={} old_inline={}",
        size_of::<CoreDevice>(),
        size_of::<IndirectValidation>(),
        size_of::<
            Option<
                crate::OnceCellOrLock<Result<Box<IndirectValidation>, crate::device::DeviceError>>,
            >,
        >(),
        size_of::<Option<IndirectValidation>>()
    );
}

#[cfg(feature = "trace")]
#[test]
fn lazy_buffer_trace_replay_and_failed_trace() {
    use crate::device::trace::{Action, MemoryTrace};
    for indirect in [false, true] {
        let (global, device, events) = fixture(wgt::Backends::NOOP, true);
        *device.trace.lock() = Some(Box::new(MemoryTrace::new()));
        let descriptor = wgt::BufferDescriptor {
            label: None,
            size: 256,
            usage: if indirect {
                wgt::BufferUsages::INDIRECT
            } else {
                wgt::BufferUsages::COPY_DST
            },
            mapped_at_creation: false,
        };
        let device_id = events.device_id.lock().unwrap().unwrap();
        let (_, error) = global.device_create_buffer(device_id, &descriptor, None);
        assert!(error.is_none());
        let trace = device.take_trace().unwrap();
        let trace: &dyn core::any::Any = trace.as_ref();
        let trace = trace.downcast_ref::<MemoryTrace>().unwrap();
        assert_eq!(
            trace.actions().len(),
            1,
            "internal validator actions must not leak into public trace"
        );
        let (replay, replay_device, replay_events) = fixture(wgt::Backends::NOOP, true);
        for action in trace.actions() {
            if let Action::CreateBuffer(_, descriptor) = action {
                let replay_id = replay_events.device_id.lock().unwrap().unwrap();
                let (_, error) = replay.device_create_buffer(replay_id, descriptor, None);
                assert!(error.is_none());
            } else {
                panic!("unexpected trace action");
            }
        }
        assert_eq!(
            replay_device.ready_indirect_validation().is_some(),
            indirect
        );
        drop(replay_device);
        drop(replay);
        drop(device);
        drop(global);
    }
    let (global, device, events) = fixture(wgt::Backends::NOOP, true);
    *device.trace.lock() = Some(Box::new(MemoryTrace::new()));
    arm(&events, 2, 0);
    let descriptor = wgt::BufferDescriptor {
        label: None,
        size: 256,
        usage: wgt::BufferUsages::INDIRECT,
        mapped_at_creation: false,
    };
    let device_id = events.device_id.lock().unwrap().unwrap();
    let (_, error) = global.device_create_buffer(device_id, &descriptor, None);
    assert!(matches!(
        error,
        Some(crate::resource::CreateBufferError::Device(
            crate::device::DeviceError::Lost
        ))
    ));
    let trace = device.take_trace().unwrap();
    let trace: &dyn core::any::Any = trace.as_ref();
    assert!(trace
        .downcast_ref::<MemoryTrace>()
        .unwrap()
        .actions()
        .is_empty());
    drop(device);
    drop(global);
    balanced(&events.log.lock().unwrap());
}

#[test]
fn lazy_lost_callback_published_before_reentrant_user_code() {
    let (global, device, events) = fixture(wgt::Backends::NOOP, true);
    let weak_device = Arc::downgrade(&device);
    let callbacks = Arc::new(AtomicUsize::new(0));
    let called = callbacks.clone();
    let (send, recv) = std::sync::mpsc::channel();
    let id = events.device_id.lock().unwrap().unwrap();
    global.device_set_device_lost_closure(
        id,
        Box::new(move |reason, _message| {
            assert_eq!(reason, wgt::DeviceLostReason::Unknown);
            called.fetch_add(1, Ordering::SeqCst);
            let device = weak_device.upgrade().unwrap();
            assert!(!device.is_valid());
            assert!(matches!(
                device.indirect_validation.as_ref().unwrap().get(),
                Some(Err(crate::device::DeviceError::Lost))
            ));
            assert!(matches!(
                buffer(&device, true),
                Err(crate::resource::CreateBufferError::Device(
                    crate::device::DeviceError::Lost
                ))
            ));
            // This lock must have been released before invoking the callback.
            assert!(device.device_lost_closure.lock().is_none());
            send.send(()).unwrap();
        }),
    );
    arm(&events, 2, 0);
    let work = device.clone();
    let thread = std::thread::spawn(move || buffer(&work, true));
    recv.recv_timeout(std::time::Duration::from_secs(10))
        .expect("lost callback deadlocked");
    assert!(thread.join().unwrap().is_err());
    assert!(!device.is_valid());
    assert!(buffer(&device, true).is_err());
    assert!(buffer(&device, false).is_err());
    assert_eq!(callbacks.load(Ordering::SeqCst), 1);
    drop(device);
    drop(global);
    balanced(&events.log.lock().unwrap());
}

#[test]
fn lazy_native_imported_handle_failure_owns_drop_callback_once() {
    for stage in 1..=15 {
        let (global, device, events) = fixture(wgt::Backends::VULKAN, true);
        let owned = unsafe {
            device.raw().create_buffer(&BufferDescriptor {
                label: None,
                size: 256,
                usage: wgt::BufferUses::MAP_WRITE
                    | wgt::BufferUses::INDIRECT
                    | wgt::BufferUses::STORAGE_READ_ONLY,
                memory_flags: hal::MemoryFlags::empty(),
            })
        }
        .unwrap();
        // Initialize the caller-owned backing buffer before importing its handle.
        let mapping = unsafe { device.raw().map_buffer(owned.as_ref(), 0..256) }.unwrap();
        unsafe {
            core::ptr::write_bytes(mapping.ptr.as_ptr(), 0, 256);
        }
        if !mapping.is_coherent {
            unsafe {
                device.raw().flush_mapped_ranges(owned.as_ref(), &[0..256]);
            }
        }
        unsafe {
            device.raw().unmap_buffer(owned.as_ref());
        }
        let handle = unsafe {
            owned
                .as_any()
                .downcast_ref::<hal::vulkan::Buffer>()
                .unwrap()
                .raw_handle()
        };
        let callbacks = Arc::new(AtomicUsize::new(0));
        let callback = callbacks.clone();
        // The original HAL owner keeps the VkBuffer and memory alive. The
        // transferred external wrapper owns this callback, not the VkBuffer.
        let imported = unsafe {
            hal::vulkan::Buffer::from_raw_externally_owned(
                handle,
                Box::new(move || {
                    callback.fetch_add(1, Ordering::SeqCst);
                }),
            )
        };
        arm(&events, stage, 0);
        let desc = wgt::BufferDescriptor {
            label: None,
            size: 256,
            usage: wgt::BufferUsages::INDIRECT,
            mapped_at_creation: false,
        };
        let (_, error) = unsafe { device.create_buffer_from_hal(Box::new(imported), &desc) };
        assert!(error.is_some());
        assert_eq!(
            callbacks.load(Ordering::SeqCst),
            1,
            "imported callback at failure stage {stage}"
        );
        unsafe {
            device.raw().destroy_buffer(owned);
        }
        drop(device);
        drop(global);
        balanced(&events.log.lock().unwrap());
        assert!(events
            .live_handles
            .lock()
            .unwrap()
            .iter()
            .all(Option::is_none));
    }
}

#[test]
fn lazy_oom_keeps_existing_error_policy() {
    for stage in 1..=16 {
        let (global, device, events) = fixture(wgt::Backends::NOOP, true);
        arm(&events, stage, 0);
        events.oom.store(true, Ordering::SeqCst);
        let result = buffer(&device, true);
        if (2..=14).contains(&stage) {
            assert!(matches!(
                result,
                Err(crate::resource::CreateBufferError::Device(
                    crate::device::DeviceError::Lost
                ))
            ));
            assert!(!device.is_valid());
        } else {
            if stage == 1 {
                assert!(matches!(
                    result,
                    Err(crate::resource::CreateBufferError::Device(
                        crate::device::DeviceError::OutOfMemory
                    ))
                ));
            } else {
                assert!(matches!(
                    result,
                    Err(
                        crate::resource::CreateBufferError::IndirectValidationBindGroup(
                            crate::device::DeviceError::OutOfMemory
                        )
                    )
                ));
            }
            assert!(device.is_valid());
            events.fail.store(0, Ordering::SeqCst);
            drop(buffer(&device, true).unwrap());
        }
        drop(device);
        drop(global);
        balanced(&events.log.lock().unwrap());
    }
}

#[test]
fn lazy_user_lost_callback_unwind_releases_unpublished_buffer() {
    for stage in [2, 15, 16] {
        let (global, device, events) = fixture(wgt::Backends::NOOP, true);
        let id = events.device_id.lock().unwrap().unwrap();
        global.device_set_device_lost_closure(
            id,
            Box::new(|_, _| panic!("user lost callback unwind")),
        );
        arm(&events, stage, 0);
        assert!(
            std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| buffer(&device, true)))
                .is_err()
        );
        assert!(!device.is_valid());
        assert!(device.indirect_validation.as_ref().unwrap().get().is_some());
        assert!(buffer(&device, true).is_err());
        drop(device);
        drop(global);
        balanced(&events.log.lock().unwrap());
    }
}

#[test]
fn lazy_concurrent_failed_first_use_caches_once_and_balances() {
    for backend in [wgt::Backends::NOOP, wgt::Backends::VULKAN] {
        let (global, device, events) = fixture(backend, true);
        let callbacks = Arc::new(AtomicUsize::new(0));
        let called = callbacks.clone();
        let id = events.device_id.lock().unwrap().unwrap();
        global.device_set_device_lost_closure(
            id,
            Box::new(move |_, _| {
                called.fetch_add(1, Ordering::SeqCst);
            }),
        );
        events.fail_shader.store(true, Ordering::SeqCst);
        let barrier = Arc::new(std::sync::Barrier::new(8));
        let threads: Vec<_> = (0..8)
            .map(|_| {
                let device = device.clone();
                let barrier = barrier.clone();
                std::thread::spawn(move || {
                    barrier.wait();
                    buffer(&device, true)
                })
            })
            .collect();
        for thread in threads {
            assert!(matches!(
                thread.join().unwrap(),
                Err(crate::resource::CreateBufferError::Device(
                    crate::device::DeviceError::Lost
                ))
            ));
        }
        assert_eq!(events.shader_attempts.load(Ordering::SeqCst), 1);
        assert!(matches!(
            device.indirect_validation.as_ref().unwrap().get(),
            Some(Err(crate::device::DeviceError::Lost))
        ));
        assert_eq!(
            callbacks.load(Ordering::SeqCst),
            1,
            "the consumed registered FnOnce must run once"
        );
        let attempts = events.step.load(Ordering::SeqCst);
        assert!(buffer(&device, true).is_err());
        assert_eq!(events.step.load(Ordering::SeqCst), attempts);
        drop(device);
        drop(global);
        balanced(&events.log.lock().unwrap());
        assert!(events
            .live_handles
            .lock()
            .unwrap()
            .iter()
            .all(Option::is_none));
    }
}

pub(crate) fn assert_balanced(events: &Events) {
    balanced(&events.log.lock().unwrap());
    assert!(events
        .live_handles
        .lock()
        .unwrap()
        .iter()
        .all(Option::is_none));
}
