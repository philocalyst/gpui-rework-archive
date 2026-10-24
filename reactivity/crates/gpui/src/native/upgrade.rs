//! Owned initialization follows vendor target-admission capabilities. X11
//! proves an unconfigured target before device/pipeline work; Metal attaches its
//! layer only during final event-thread redraw. A worker may retain an X11
//! window lease, never a view, source, presentation token, or CPU surface.
use super::{DeviceErrors, GpuSurface, NativeWindow, Renderer, Wake, wgpu};
use std::{
    panic::{AssertUnwindSafe, catch_unwind},
    sync::{
        Arc,
        atomic::{AtomicBool, Ordering},
        mpsc::{self, Receiver, SyncSender, TryRecvError},
    },
    thread,
};

use wgpu::presentation::{
    PresentationAdmission, PresentationPlan, PresentationRequirements, SurfacePreparation,
};

#[derive(Clone, Copy, Default)]
pub(super) struct Policy {
    // Only the real native integration test may exercise handoff on llvmpipe.
    #[cfg(test)]
    pub(super) allow_cpu: bool,
    #[cfg(all(
        test,
        target_os = "linux",
        any(feature = "x11", feature = "x11-minimal")
    ))]
    pub(super) defer_renderer: bool,
    #[cfg(test)]
    pub(super) force_probe: bool,
    #[cfg(test)]
    pub(super) requirements: Option<PresentationRequirements>,
}
impl Policy {
    fn plan(self, admission: PresentationAdmission) -> Option<PresentationPlan> {
        match admission {
            PresentationAdmission::Candidate(plan) => Some(plan),
            #[cfg(test)]
            PresentationAdmission::NoDeviceHint(plan) if self.allow_cpu || self.force_probe => {
                Some(plan)
            }
            _ => None,
        }
    }
    fn accepts(self, kind: wgpu::DeviceType) -> bool {
        #[cfg(test)]
        {
            kind != wgpu::DeviceType::Cpu || self.allow_cpu
        }
        #[cfg(not(test))]
        {
            kind != wgpu::DeviceType::Cpu
        }
    }
}

// One exact configuration is validated before requesting a device where the
// vendor permits early target creation. Explicit GPU retains its negotiated path.
pub(super) fn requirements() -> PresentationRequirements {
    PresentationRequirements {
        format: FORMAT,
        color_space: wgpu::SurfaceColorSpace::Srgb,
        alpha_mode: wgpu::CompositeAlphaMode::Opaque,
        present_mode: wgpu::PresentMode::Fifo,
    }
}
const FORMAT: wgpu::TextureFormat = wgpu::TextureFormat::Bgra8UnormSrgb;
enum Message {
    Renderer(Box<Candidate>),
    Unavailable(String),
}
struct Candidate {
    instance: wgpu::Instance,
    adapter: wgpu::Adapter,
    renderer: Renderer,
    surface: Option<wgpu::Surface<'static>>,
}
impl Candidate {
    fn boxed(self) -> Box<Self> {
        #[cfg(not(test))]
        {
            Box::new(self)
        }
        #[cfg(test)]
        {
            let mut candidate = None;
            let allocation = allocation_counter::measure(|| candidate = Some(Box::new(self)));
            eprintln!(
                "GPUI_AUTO_CANDIDATE,requests={},requested={},retained={},peak={}",
                allocation.count_total,
                allocation.bytes_total,
                allocation.bytes_current,
                allocation.bytes_max
            );
            candidate.unwrap()
        }
    }
}
pub(super) struct Initialization {
    cancelled: AtomicBool,
    #[cfg(test)]
    proved: AtomicBool,
    #[cfg(test)]
    renderer_started: AtomicBool,
    #[cfg(all(
        test,
        target_os = "linux",
        any(feature = "x11", feature = "x11-minimal")
    ))]
    deferred: AtomicBool,
}
impl Initialization {
    fn new() -> Self {
        Self {
            cancelled: AtomicBool::new(false),
            #[cfg(test)]
            proved: AtomicBool::new(false),
            #[cfg(test)]
            renderer_started: AtomicBool::new(false),
            #[cfg(all(
                test,
                target_os = "linux",
                any(feature = "x11", feature = "x11-minimal")
            ))]
            deferred: AtomicBool::new(false),
        }
    }
}
#[cfg(all(
    test,
    target_os = "linux",
    any(feature = "x11", feature = "x11-minimal")
))]
impl Initialization {
    pub(super) fn proved(&self) -> bool {
        self.proved.load(Ordering::Acquire)
    }
    pub(super) fn renderer_started(&self) -> bool {
        self.renderer_started.load(Ordering::Acquire)
    }
    pub(super) fn waiting_for_renderer(&self) -> bool {
        self.deferred.load(Ordering::Acquire)
    }
}
pub(super) struct Ready {
    pub(super) instance: wgpu::Instance,
    pub(super) gpu: Box<GpuSurface>,
}
pub(super) enum Progress {
    Pending,
    Ready(Ready),
    Unavailable(String),
}

pub(super) struct Upgrade {
    messages: Receiver<Message>,
    initialization: Arc<Initialization>,
    #[cfg(all(
        test,
        target_os = "linux",
        any(feature = "x11", feature = "x11-minimal")
    ))]
    release: Option<SyncSender<()>>,
}
impl Upgrade {
    pub(super) fn start(
        policy: Policy,
        window: &Arc<NativeWindow>,
        wake: Option<Wake>,
    ) -> std::io::Result<Option<Self>> {
        let admission = wgpu::presentation::automatic_surface_admission(window.as_ref())
            .map_err(std::io::Error::other)?;
        let Some(plan) = policy.plan(admission) else {
            return Ok(None);
        };
        // Only the vendor-classified early path owns a native lease off-thread.
        // No AppKit/UIKit target is sent to this worker.
        let target = (plan.surface_preparation == SurfacePreparation::BeforeDevice)
            .then(|| Arc::clone(window));
        #[cfg(test)]
        let required = policy.requirements.unwrap_or_else(requirements);
        #[cfg(not(test))]
        let required = requirements();
        let initialization = Arc::new(Initialization::new());
        let cancellation = Arc::clone(&initialization);
        let (send, messages) = mpsc::sync_channel(1);
        #[cfg(all(
            test,
            target_os = "linux",
            any(feature = "x11", feature = "x11-minimal")
        ))]
        let (release, receive) = mpsc::sync_channel::<()>(1);
        let worker = thread::Builder::new()
            .name("gpui-hardware-init".into())
            .spawn(move || {
                let result = catch_unwind(AssertUnwindSafe(|| {
                    if cancellation.cancelled.load(Ordering::Acquire) {
                        return;
                    }
                    let instance = wgpu::Instance::new(wgpu::InstanceDescriptor {
                        backends: plan.backends,
                        ..wgpu::InstanceDescriptor::new_without_display_handle()
                    });
                    let options = wgpu::RequestAdapterOptions {
                        power_preference: wgpu::PowerPreference::HighPerformance,
                        compatible_surface: None,
                        force_fallback_adapter: false,
                        apply_limit_buckets: false,
                    };
                    let prepared = if let Some(target) = target {
                        // Safe WGPU creation retains the Arc until after backend
                        // surface destruction. This surface is never configured
                        // on the worker and cannot cover a software frame.
                        instance
                            .create_surface(target)
                            .map_err(|error| error.to_string())
                            .and_then(|surface| {
                                pollster::block_on(
                                    instance
                                        .request_presentation_adapter(surface, &options, required),
                                )
                                .map_err(|error| error.to_string())
                            })
                            .map(|prepared| {
                                let (surface, adapter) = prepared.into_parts();
                                (adapter, Some(surface))
                            })
                    } else {
                        // Metal still prepares headlessly; creating its layer
                        // now would cover CPU pixels while compilation is pending.
                        pollster::block_on(instance.request_adapter(&options))
                            .map(|adapter| (adapter, None))
                            .map_err(|error| error.to_string())
                    };
                    let (adapter, surface) = match prepared {
                        Ok(prepared) => prepared,
                        Err(error) => {
                            deliver(&send, Message::Unavailable(error), &wake);
                            return;
                        }
                    };
                    #[cfg(test)]
                    cancellation.proved.store(true, Ordering::Release);
                    if cancellation.cancelled.load(Ordering::Acquire) {
                        return;
                    }
                    // CPU-only adapters never request a device, compile a pipeline,
                    // or JIT the reference shader in production Auto policy.
                    if !policy.accepts(adapter.get_info().device_type) {
                        deliver(
                            &send,
                            Message::Unavailable("CPU-only adapter".into()),
                            &wake,
                        );
                        return;
                    }
                    #[cfg(all(
                        test,
                        target_os = "linux",
                        any(feature = "x11", feature = "x11-minimal")
                    ))]
                    if policy.defer_renderer {
                        cancellation.deferred.store(true, Ordering::Release);
                        if receive.recv().is_err() {
                            return;
                        }
                    }
                    if cancellation.cancelled.load(Ordering::Acquire) {
                        return;
                    }
                    #[cfg(test)]
                    cancellation.renderer_started.store(true, Ordering::Release);
                    let message = match pollster::block_on(Renderer::request(&adapter, FORMAT)) {
                        Ok(renderer) => Message::Renderer(
                            Candidate {
                                instance,
                                adapter,
                                renderer,
                                surface,
                            }
                            .boxed(),
                        ),
                        Err(error) => Message::Unavailable(error.to_string()),
                    };
                    if !cancellation.cancelled.load(Ordering::Acquire) {
                        deliver(&send, message, &wake);
                    }
                }));
                if result.is_err() {
                    deliver(
                        &send,
                        Message::Unavailable("hardware initialization panicked".into()),
                        &wake,
                    );
                }
            })?;
        // Admission never joins or queries the worker. Detach immediately rather
        // than retaining a JoinHandle/result packet in every native host cohort.
        drop(worker);
        Ok(Some(Self {
            messages,
            initialization,
            #[cfg(all(
                test,
                target_os = "linux",
                any(feature = "x11", feature = "x11-minimal")
            ))]
            release: Some(release),
        }))
    }
    // Deterministically mutate a real native owner before allowing real device
    // and pipeline initialization. No renderer or presentation is mocked.
    #[cfg(all(
        test,
        target_os = "linux",
        any(feature = "x11", feature = "x11-minimal")
    ))]
    pub(super) fn release_renderer(&mut self) {
        if let Some(release) = self.release.take() {
            let _ = release.try_send(());
        }
    }
    #[cfg(all(
        test,
        target_os = "linux",
        any(feature = "x11", feature = "x11-minimal")
    ))]
    pub(super) fn initialization(&self) -> Arc<Initialization> {
        Arc::clone(&self.initialization)
    }
    #[cfg(all(
        test,
        target_os = "linux",
        any(feature = "x11", feature = "x11-minimal")
    ))]
    pub(super) fn hold_renderer(&self) -> SyncSender<()> {
        self.release
            .as_ref()
            .expect("unreleased renderer gate")
            .clone()
    }
    /// Called only from Redraw on the event-loop thread. The delayed target
    /// path creates and proves its surface here, after renderer preparation.
    /// No CAMetalLayer is attached while initialization remains pending.
    pub(super) fn poll(&mut self, window: &Arc<NativeWindow>, wake: Option<Wake>) -> Progress {
        let message = match self.messages.try_recv() {
            Ok(message) => message,
            Err(TryRecvError::Empty) => return Progress::Pending,
            Err(TryRecvError::Disconnected) => {
                return Progress::Unavailable("initializer ended".into());
            }
        };
        match message {
            Message::Unavailable(reason) => Progress::Unavailable(reason),
            Message::Renderer(candidate) => {
                let Candidate {
                    instance,
                    adapter,
                    renderer,
                    surface,
                } = *candidate;
                let handle = match surface {
                    Some(surface) => surface,
                    None => {
                        let handle = match instance.create_surface(Arc::clone(window)) {
                            Ok(handle) => handle,
                            Err(error) => return Progress::Unavailable(error.to_string()),
                        };
                        if let Err(error) =
                            requirements().validate(&handle.get_capabilities(&adapter))
                        {
                            return Progress::Unavailable(error.to_string());
                        }
                        handle
                    }
                };
                let errors = DeviceErrors::install(renderer.device(), wake);
                Progress::Ready(Ready {
                    instance,
                    gpu: Box::new(GpuSurface {
                        handle,
                        renderer,
                        errors,
                        packet_token: None,
                        acceleration: Default::default(),
                    }),
                })
            }
        }
    }
}
impl Drop for Upgrade {
    fn drop(&mut self) {
        // A blocked driver call is not interruptible. Its result can only drop;
        // cancellation never waits or admits a late target into another owner.
        self.initialization.cancelled.store(true, Ordering::Release);
    }
}

// An eligibility-triggered continuation of cold GPU preparation. The baseline
// initializer exits normally; no worker waits permanently for a future scene.
// The context owns the installed pipeline. This owner only cancels/receives one
// transient job, and never lends a window, surface or mutable renderer to it.
#[derive(Default)]
pub(super) enum ClipUpgrade {
    #[default]
    Idle,
    Preparing(Box<ClipPreparation>),
    Finished,
}
pub(super) struct ClipPreparation {
    messages: Receiver<Result<gpui_gpu::PreparedClipAcceleration, gpui_gpu::Error>>,
    cancelled: Arc<AtomicBool>,
}
impl Drop for ClipPreparation {
    fn drop(&mut self) {
        self.cancelled.store(true, Ordering::Release);
    }
}
impl ClipUpgrade {
    pub(super) fn progress(&mut self, renderer: &mut Renderer, wake: &Option<Wake>) {
        if let Self::Preparing(preparation) = self {
            match preparation.messages.try_recv() {
                Err(TryRecvError::Empty) => return,
                result => {
                    *self = Self::Finished;
                    if let Ok(Ok(prepared)) = result {
                        // Exact context/layout identity is checked under this
                        // exclusive renderer borrow. A rejected/failed optional
                        // result leaves the fully correct base pipeline active.
                        let _ = renderer.install_clip_acceleration(prepared);
                    }
                    return;
                }
            }
        }
        if !matches!(self, Self::Idle) {
            return;
        }
        let Some(job) = renderer.clip_acceleration_job() else {
            return;
        };
        *self = Self::Finished;
        let cancelled = Arc::new(AtomicBool::new(false));
        let cancellation = Arc::clone(&cancelled);
        let (send, messages) = mpsc::sync_channel(1);
        let wake = wake.clone();
        let worker = thread::Builder::new()
            .name("gpui-clip-prepare".into())
            .spawn(move || {
                if cancellation.load(Ordering::Acquire) {
                    return;
                }
                // Driver compilation itself cannot be cancelled and can take
                // driver locks also used by rendering. Threading promises no
                // latency isolation; this is an optional owned cold boundary.
                let result = catch_unwind(AssertUnwindSafe(|| pollster::block_on(job.prepare())))
                    .unwrap_or_else(|_| {
                        Err(gpui_gpu::Error::Shader("clip preparation panicked".into()))
                    });
                if !cancellation.load(Ordering::Acquire) && send.send(result).is_ok() {
                    if let Some(wake) = wake {
                        wake.signal();
                    }
                }
            });
        if let Ok(worker) = worker {
            drop(worker);
            *self = Self::Preparing(Box::new(ClipPreparation {
                messages,
                cancelled,
            }));
        }
    }
}
fn deliver(send: &SyncSender<Message>, message: Message, wake: &Option<Wake>) -> bool {
    if send.send(message).is_err() {
        return false;
    }
    if let Some(wake) = wake {
        wake.signal();
    }
    true
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn closing_optional_owner_revokes_delivery_without_waiting_for_driver() {
        let cancelled = Arc::new(AtomicBool::new(false));
        let (send, messages) = mpsc::sync_channel(1);
        let preparation = ClipPreparation {
            messages,
            cancelled: Arc::clone(&cancelled),
        };
        drop(preparation);
        assert!(cancelled.load(Ordering::Acquire));
        assert!(
            send.send(Err(gpui_gpu::Error::Shader("late result".into())))
                .is_err()
        );
        eprintln!(
            "optional_native_header surface={} controller={} pending={}",
            size_of::<GpuSurface>(),
            size_of::<ClipUpgrade>(),
            size_of::<ClipPreparation>()
        );
    }
    #[test]
    fn initialization_cohort_ledger() {
        // A layout comparison with the prior actual message payload; this does
        // not estimate process/driver memory from Rust headers.
        #[allow(dead_code)]
        enum PreviousMessage {
            Renderer {
                instance: wgpu::Instance,
                adapter: wgpu::Adapter,
                renderer: Box<Renderer>,
            },
            Unavailable(String),
        }
        #[allow(dead_code)]
        struct PreviousUpgrade {
            messages: Receiver<PreviousMessage>,
            worker: thread::JoinHandle<()>,
            #[cfg(all(target_os = "linux", any(feature = "x11", feature = "x11-minimal")))]
            release: Option<SyncSender<()>>,
        }
        let mut retained = None;
        let allocation = allocation_counter::measure(|| {
            retained = Some(Arc::new(Initialization::new()));
        });
        let mut old_channel = None;
        let old_queue = allocation_counter::measure(|| {
            old_channel = Some(mpsc::sync_channel::<PreviousMessage>(1));
        });
        let mut channel = None;
        let queue = allocation_counter::measure(|| {
            channel = Some(mpsc::sync_channel::<Message>(1));
        });
        eprintln!(
            "GPUI_AUTO_COHORT,old_message={},message={},renderer={},candidate={},surface={},optional_surface={},old_upgrade={},upgrade={},production_flag={},flag_requests={},flag_requested={},flag_retained={},flag_peak={}",
            size_of::<PreviousMessage>(),
            size_of::<Message>(),
            size_of::<Renderer>(),
            size_of::<Candidate>(),
            size_of::<wgpu::Surface<'static>>(),
            size_of::<Option<wgpu::Surface<'static>>>(),
            size_of::<PreviousUpgrade>(),
            size_of::<Upgrade>(),
            size_of::<AtomicBool>(),
            allocation.count_total,
            allocation.bytes_total,
            allocation.bytes_current,
            allocation.bytes_max
        );
        eprintln!(
            "GPUI_AUTO_QUEUE,old_requests={},old_requested={},old_retained={},old_peak={},requests={},requested={},retained={},peak={}",
            old_queue.count_total,
            old_queue.bytes_total,
            old_queue.bytes_current,
            old_queue.bytes_max,
            queue.count_total,
            queue.bytes_total,
            queue.bytes_current,
            queue.bytes_max
        );
        drop((old_channel, channel));
        drop(retained);
    }
    #[test]
    fn production_policy_rejects_cpu_before_renderer_phase_and_cheap_missing_hint() {
        assert!(!Policy::default().accepts(wgpu::DeviceType::Cpu));
        assert!(Policy::default().accepts(wgpu::DeviceType::DiscreteGpu));
        assert!(Policy::default().accepts(wgpu::DeviceType::IntegratedGpu));
        let plan = PresentationPlan {
            backends: wgpu::Backends::VULKAN,
            surface_preparation: SurfacePreparation::BeforeDevice,
        };
        assert!(
            Policy::default()
                .plan(PresentationAdmission::NoDeviceHint(plan))
                .is_none()
        );
        assert!(
            Policy::default()
                .plan(PresentationAdmission::SoftwareRecoveryUnavailable)
                .is_none()
        );
        assert!(
            Policy::default()
                .plan(PresentationAdmission::Unknown)
                .is_none()
        );
        assert!(
            Policy {
                allow_cpu: true,
                ..Default::default()
            }
            .accepts(wgpu::DeviceType::Cpu)
        );
    }
}
