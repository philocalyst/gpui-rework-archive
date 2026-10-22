//! Native callbacks own the surface; the view owner owns only a borrowed scene.
//! A surface submission acknowledges its exact prepared token after `present`.
use std::time::{Duration, Instant};
use std::{
    num::NonZeroU32,
    sync::{Arc, Mutex},
};

use gpui_gpu::{Renderer, wgpu};
use gpui_reactivity_host::native::{Callback, Driver, Host, Wake, winit};
use winit::{
    dpi::LogicalSize,
    event::{ElementState, MouseButton, MouseScrollDelta, WindowEvent},
    event_loop::{ActiveEventLoop, EventLoop},
    keyboard::{Key as NativeKey, ModifiersState, NamedKey},
    window::Window as NativeWindow,
};

#[cfg(all(
    test,
    target_os = "linux",
    any(feature = "x11", feature = "x11-minimal")
))]
use crate::Target;
use crate::{
    Commit, Error, Key, Point, PointerEvent, PointerSession, View, Win, WindowOptions,
    remote::{DeliveryError, Inbox, Lane, LaneSet},
    runtime::SurfaceDamage,
};

#[cfg(feature = "accessibility")]
mod accessibility;
mod destination;
mod upgrade;
#[cfg(all(
    test,
    target_os = "linux",
    any(feature = "x11", feature = "x11-minimal")
))]
mod upgrade_tests;

#[cfg(all(
    test,
    any(
        feature = "accessibility",
        all(target_os = "linux", any(feature = "x11", feature = "x11-minimal"))
    )
))]
#[path = "../examples/support/library.rs"]
pub(crate) mod test_library;

#[cfg(all(
    test,
    target_os = "linux",
    any(feature = "x11", feature = "x11-minimal")
))]
mod destination_tests;
#[cfg(all(
    test,
    any(feature = "x11", feature = "x11-minimal"),
    target_os = "linux"
))]
mod list_tests;
#[cfg(all(
    test,
    target_os = "linux",
    any(feature = "x11", feature = "x11-minimal")
))]
mod scroll_tests;

#[derive(Debug)]
pub enum NativeError {
    /// The native accessibility FIFO/payload budget or activation counter was exhausted.
    /// AccessKit cannot return Busy; this window fails closed instead.
    #[cfg(feature = "accessibility")]
    AccessibilityOverloaded,
    Runtime(Error),
    Graphics(gpui_gpu::Error),
    Platform(String),
    /// The adapter cannot realize an opaque, tagged sRGB surface.
    UnsupportedSurface,
    /// Recovery was attempted once without obtaining a usable surface.
    SurfaceUnavailable,
    DeviceFault(String),
}
impl std::fmt::Display for NativeError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "native application: {self:?}")
    }
}
impl std::error::Error for NativeError {}
impl From<Error> for NativeError {
    fn from(value: Error) -> Self {
        Self::Runtime(value)
    }
}
impl From<gpui_gpu::Error> for NativeError {
    fn from(value: gpui_gpu::Error) -> Self {
        Self::Graphics(value)
    }
}

type PresentationError = Box<dyn FnMut(&Error)>;
type PresentationFeedback = Box<dyn FnMut(PresentedFrame)>;
/// The renderer that submitted the frame, not a claim about physical hardware.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum RendererKind {
    ReferenceCpu,
    Gpu,
}
/// Emitted after native present and runtime acknowledgement. This is a host
/// submission boundary, not a monitor scanout/photon timestamp.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct PresentedFrame {
    pub renderer: RendererKind,
    pub source_epoch: u64,
    pub presentation_epoch: u64,
}
/// Select a renderer without changing views, input or presentation semantics.
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub enum RendererPolicy {
    /// Present software first, then prepare hardware on an owned worker and
    /// upgrade only after a complete GPU frame can be presented successfully.
    /// Windows currently retains software: its GDI surface cannot be restored
    /// after DXGI flip presentation. Select `Gpu` for native DX12 rendering.
    #[default]
    Auto,
    Gpu,
    /// Never initialize Wgpu or load a GPU driver.
    ReferenceCpu,
}
/// An owned root plus native opening policy. Components never receive Winit.
pub struct Window<V: View + 'static, L: LaneSet<V> = ()> {
    // Receivers close before the root is destroyed, including an unopened window.
    lanes: L,
    root: V,
    title: String,
    size: [u32; 2],
    presentation_error: Option<PresentationError>,
    presentation_feedback: Option<PresentationFeedback>,
    renderer: RendererPolicy,
    inspector: bool,
}
impl<V: View + 'static> Window<V> {
    pub fn document(root: V) -> Self {
        Self {
            root,
            lanes: (),
            title: "GPUI".into(),
            size: [800, 600],
            presentation_error: None,
            presentation_feedback: None,
            renderer: RendererPolicy::Auto,
            inspector: false,
        }
    }
}
impl<V: View + 'static, L: LaneSet<V>> Window<V, L> {
    pub fn questions<Q: LaneSet<V>>(
        self,
        questions: crate::Questions<V, Q>,
    ) -> Window<V, crate::reader::QuestionSet<Q, L>> {
        Window {
            lanes: questions.bind(self.lanes),
            root: self.root,
            title: self.title,
            size: self.size,
            presentation_error: self.presentation_error,
            presentation_feedback: self.presentation_feedback,
            renderer: self.renderer,
            inspector: self.inspector,
        }
    }
    /// Bind a typed FIFO completion lane when this window mounts.
    pub fn with_inbox<T: Send + 'static, F: FnMut(&mut V, T) + 'static>(
        self,
        inbox: Inbox<T>,
        receive: F,
    ) -> Window<V, Lane<T, F, L>> {
        Window {
            root: self.root,
            lanes: Lane::new(inbox, receive, self.lanes),
            title: self.title,
            size: self.size,
            presentation_error: self.presentation_error,
            presentation_feedback: self.presentation_feedback,
            renderer: self.renderer,
            inspector: self.inspector,
        }
    }
    /// Show a retained inspector beside this window's actual application.
    pub fn inspector(mut self) -> Self {
        self.inspector = true;
        self
    }
    pub fn title(mut self, title: impl Into<String>) -> Self {
        self.title = title.into();
        self
    }
    pub fn renderer(mut self, renderer: RendererPolicy) -> Self {
        self.renderer = renderer;
        self
    }
    /// Initial client area in logical window units.
    pub fn size(mut self, width: u32, height: u32) -> Self {
        self.size = [width, height];
        self
    }
    /// Observes successful native presentation and the exact acknowledged sheet.
    /// The first software feedback runs before Auto starts any GPU initialization.
    /// The host exclusively invokes this callback, so captured state can mutate
    /// directly without an interior-mutable wrapper.
    pub fn on_presented(mut self, handler: impl FnMut(PresentedFrame) + 'static) -> Self {
        self.presentation_feedback = Some(Box::new(handler));
        self
    }
    /// Observes a recoverable source-to-presentation failure. Source edits stay
    /// committed; position-free input can repair the value and publish again.
    /// Without a handler, failures are reported to stderr.
    /// Captured state uses the callback's ordinary mutable borrow.
    pub fn on_presentation_error(mut self, handler: impl FnMut(&Error) + 'static) -> Self {
        self.presentation_error = Some(Box::new(handler));
        self
    }
}

impl crate::Application {
    pub fn run<V: View + 'static>(root: V) -> Result<(), NativeError> {
        Self::run_window(Window::document(root))
    }
    pub fn run_window<V: View + 'static, L: LaneSet<V> + 'static>(
        window: Window<V, L>,
    ) -> Result<(), NativeError> {
        let event_loop = EventLoop::new().map_err(platform)?;
        let host = NativeHost::new(window);
        let (mut driver, wake) = Driver::new(&event_loop, host);
        driver.host_mut().wake = Some(wake);
        event_loop.run_app(&mut driver).map_err(platform)?;
        match driver.host_mut().error.take() {
            Some(error) => Err(error),
            None => Ok(()),
        }
    }
}
fn platform(error: impl std::fmt::Display) -> NativeError {
    NativeError::Platform(error.to_string())
}

fn surface_config(size: [u32; 2], format: wgpu::TextureFormat) -> wgpu::SurfaceConfiguration {
    wgpu::SurfaceConfiguration {
        usage: wgpu::TextureUsages::RENDER_ATTACHMENT,
        format,
        color_space: wgpu::SurfaceColorSpace::Srgb,
        width: size[0],
        height: size[1],
        present_mode: wgpu::PresentMode::Fifo,
        desired_maximum_frame_latency: 1,
        alpha_mode: wgpu::CompositeAlphaMode::Opaque,
        view_formats: vec![],
    }
}

struct GpuSurface {
    handle: wgpu::Surface<'static>,
    config: wgpu::SurfaceConfiguration,
    renderer: Renderer,
    errors: Arc<DeviceErrors>,
    packet_token: Option<crate::PresentationToken>,
}
impl GpuSurface {
    fn render_paint(
        &mut self,
        scene: gpui_canvas::PreparedScene<'_>,
        token: crate::PresentationToken,
        paint: Option<&crate::runtime::paint::SlotTransition>,
        target: &wgpu::TextureView,
    ) -> Result<wgpu::SubmissionIndex, gpui_gpu::Error> {
        if self.packet_token == Some(token)
            && let Some(submitted) = self.renderer.redraw(target)?
        {
            return Ok(submitted);
        }
        if let Some(paint) = paint
            && self.packet_token == Some(paint.from)
            && let Ok(plan) = self.renderer.prepare_slots(&paint.edits, target)
        {
            self.packet_token = None; // revoke before the first queue write
            let submitted = plan.commit();
            self.packet_token = Some(token);
            return Ok(submitted);
        }
        self.packet_token = None;
        let submitted = self.renderer.render(scene, target)?;
        self.packet_token = Some(token);
        Ok(submitted)
    }
}
type CpuSurface = softbuffer::Surface<Arc<NativeWindow>, Arc<NativeWindow>>;
enum Graphics {
    Gpu(Box<GpuSurface>),
    ReferenceCpu(CpuSurface, SurfaceDamage),
}
impl Graphics {
    fn fault(&self) -> Option<DeviceFault> {
        match self {
            Self::Gpu(gpu) => gpu.errors.take(),
            Self::ReferenceCpu(..) => None,
        }
    }
}

enum DeviceFault {
    Lost,
    Error(String),
}
// Ported from GPUI-CE's device error boundary: callbacks belong to a device
// generation. Replacing this allocation prevents a late old-device callback
// from invalidating the recovered renderer. It is never touched per primitive.
#[derive(Default)]
struct DeviceErrors(Mutex<Option<DeviceFault>>);
impl DeviceErrors {
    fn install(device: &wgpu::Device, wake: Option<Wake>) -> Arc<Self> {
        let errors = Arc::new(Self::default());
        let lost = Arc::clone(&errors);
        let lost_wake = wake.clone();
        device.set_device_lost_callback(move |reason, _message| {
            if reason != wgpu::DeviceLostReason::Destroyed {
                lost.record(DeviceFault::Lost, &lost_wake);
            }
        });
        let uncaptured = Arc::clone(&errors);
        device.on_uncaptured_error(Arc::new(move |error: wgpu::Error| {
            uncaptured.record(DeviceFault::Error(error.to_string()), &wake);
        }));
        errors
    }
    fn record(&self, fault: DeviceFault, wake: &Option<Wake>) {
        let mut pending = self.0.lock().unwrap_or_else(|poison| poison.into_inner());
        // Device loss requires rebuilding everything even if a validation
        // notification follows it before the owner wakes.
        if !matches!(*pending, Some(DeviceFault::Lost)) {
            *pending = Some(fault);
        }
        drop(pending);
        if let Some(wake) = wake {
            wake.signal();
        }
    }
    fn take(&self) -> Option<DeviceFault> {
        self.0
            .lock()
            .unwrap_or_else(|poison| poison.into_inner())
            .take()
    }
}

struct NativeHost<V: View + 'static, L: LaneSet<V> = ()> {
    #[cfg(feature = "accessibility")]
    accessibility: Option<accessibility::Bridge>,
    opening: Option<Window<V, L>>,
    instance: Option<wgpu::Instance>,
    renderer_policy: RendererPolicy,
    window: Option<Arc<NativeWindow>>,
    owner: Option<Win<V, L>>,
    graphics: Option<Graphics>,
    pointer: PointerSession,
    occluded: bool,
    destination: destination::Destination,
    error: Option<NativeError>,
    wake: Option<Wake>,
    recoveries: u8,
    presentation_error: Option<PresentationError>,
    retry_at: Option<Instant>,
    timeouts: u8,
    modifiers: ModifiersState,
    presentation_feedback: Option<PresentationFeedback>,
    upgrade: Option<upgrade::Upgrade>,
    upgrade_attempted: bool,
    upgrade_policy: upgrade::Policy,
    #[cfg(test)]
    presented_frames: u64,
    #[cfg(test)]
    fail_next_cpu_present: bool,
    #[cfg(test)]
    upgrade_rejection: Option<String>,
}
impl<V: View + 'static, L: LaneSet<V>> Drop for NativeHost<V, L> {
    fn drop(&mut self) {
        // Exiting is not guaranteed on early failure or unwind. A worker's safe
        // target lease must not leave this retired owner visibly on screen.
        self.hide_and_cancel_upgrade();
    }
}
impl<V: View + 'static, L: LaneSet<V>> NativeHost<V, L> {
    fn new(opening: Window<V, L>) -> Self {
        let renderer_policy = opening.renderer;
        Self {
            #[cfg(feature = "accessibility")]
            accessibility: None,
            opening: Some(opening),
            instance: None,
            renderer_policy,
            window: None,
            owner: None,
            graphics: None,
            pointer: PointerSession::default(),
            occluded: false,
            destination: destination::Destination::default(),
            error: None,
            wake: None,
            recoveries: 0,
            presentation_error: None,
            retry_at: None,
            timeouts: 0,
            modifiers: ModifiersState::empty(),
            presentation_feedback: None,
            upgrade: None,
            upgrade_attempted: false,
            upgrade_policy: upgrade::Policy::default(),
            #[cfg(test)]
            presented_frames: 0,
            #[cfg(test)]
            fail_next_cpu_present: false,
            #[cfg(test)]
            upgrade_rejection: None,
        }
    }
    fn resumed(&mut self, event_loop: &ActiveEventLoop) -> Result<(), NativeError> {
        if let Some(opening) = self.opening.take() {
            #[cfg(feature = "accessibility")]
            let accessibility_title = opening.title.clone();
            self.presentation_error = opening.presentation_error;
            self.presentation_feedback = opening.presentation_feedback;
            let window = Arc::new(
                event_loop
                    .create_window(
                        NativeWindow::default_attributes()
                            .with_title(opening.title)
                            .with_inner_size(LogicalSize::new(opening.size[0], opening.size[1]))
                            .with_visible(false),
                    )
                    .map_err(platform)?,
            );
            let size = window.inner_size();
            let mut owner = Win::recording_lanes(
                opening.root,
                opening.lanes,
                WindowOptions {
                    size: [size.width.max(1), size.height.max(1)],
                    ..WindowOptions::default()
                },
                window.scale_factor() as f32,
                opening.inspector,
            )?;
            if let Some(wake) = &self.wake {
                owner.attach_wake(wake);
            }
            #[cfg(feature = "accessibility")]
            {
                self.accessibility = Some(accessibility::Bridge::new(
                    event_loop,
                    &window,
                    self.wake.clone().ok_or_else(|| {
                        platform("native accessibility requires an attached driver wake")
                    })?,
                    accessibility_title,
                ));
            }
            self.owner = Some(owner);
            self.window = Some(window);
        }
        if self.graphics.is_none() {
            self.create_surface()?;
        }
        if let Some(window) = &self.window {
            window.set_visible(true);
            window.request_redraw();
        }
        Ok(())
    }
    fn create_surface(&mut self) -> Result<(), NativeError> {
        let Some(window) = &self.window else {
            return Ok(());
        };
        if self.renderer_policy != RendererPolicy::Gpu {
            return self.create_cpu_surface();
        }
        let instance = self.instance.get_or_insert_with(|| {
            wgpu::Instance::new(wgpu::InstanceDescriptor::new_with_display_handle_from_env(
                Box::new(Arc::clone(window)),
            ))
        });
        let handle = instance
            .create_surface(Arc::clone(window))
            .map_err(platform)?;
        // Request a surface-compatible adapter rather than assuming the first
        // headless device can present to this display connection.
        let adapter = pollster::block_on(instance.request_adapter(&wgpu::RequestAdapterOptions {
            compatible_surface: Some(&handle),
            ..Default::default()
        }))
        .map_err(platform)?;
        let caps = handle.get_capabilities(&adapter);
        let format = [
            wgpu::TextureFormat::Bgra8UnormSrgb,
            wgpu::TextureFormat::Rgba8UnormSrgb,
        ]
        .into_iter()
        .find(|format| caps.formats.contains(format))
        .ok_or(NativeError::UnsupportedSurface)?;
        if !caps.alpha_modes.contains(&wgpu::CompositeAlphaMode::Opaque) {
            return Err(NativeError::UnsupportedSurface);
        }
        // Recreate the renderer on resume/recovery: a different adapter/device
        // generation must never reuse old atlas keys or buffer handles.
        let renderer = pollster::block_on(Renderer::request(&adapter, format))?;
        let errors = DeviceErrors::install(renderer.device(), self.wake.clone());
        let size = window.inner_size();
        self.graphics = Some(Graphics::Gpu(Box::new(GpuSurface {
            handle,
            renderer,
            errors,
            packet_token: None,
            config: surface_config([size.width.max(1), size.height.max(1)], format),
        })));
        self.resize([size.width, size.height])
    }
    fn create_cpu_surface(&mut self) -> Result<(), NativeError> {
        self.retry_at = None;
        self.timeouts = 0;
        let Some(window) = &self.window else {
            return Ok(());
        };
        let size = window.inner_size();
        let context = softbuffer::Context::new(Arc::clone(window)).map_err(platform)?;
        let surface = CpuSurface::new(&context, Arc::clone(window)).map_err(platform)?;
        self.graphics = Some(Graphics::ReferenceCpu(surface, SurfaceDamage::default()));
        self.resize([size.width, size.height])
    }
    fn hide_and_cancel_upgrade(&mut self) {
        // A cancelled worker may retain an unconfigured native target while a
        // driver call finishes. Hide promptly before dropping this UI lease;
        // never let that retained target keep a closed owner visibly alive.
        if let Some(window) = &self.window {
            window.set_visible(false);
        }
        self.upgrade = None;
    }
    fn retire_window(&mut self) {
        self.hide_and_cancel_upgrade();
        #[cfg(feature = "accessibility")]
        {
            self.accessibility = None;
        }
        if let Some(owner) = &mut self.owner {
            owner.close();
        }
        self.graphics = None;
        self.instance = None;
        self.window = None;
    }
    fn resize(&mut self, size: [u32; 2]) -> Result<(), NativeError> {
        self.destination.invalidate();
        self.pointer = PointerSession::default();
        if size.contains(&0) {
            return Ok(());
        }
        if let Some(Graphics::Gpu(graphics)) = &self.graphics {
            let maximum = graphics.renderer.device().limits().max_texture_dimension_2d;
            if size.iter().any(|&side| side > maximum)
                || u64::from(size[0]) * u64::from(size[1]) > 16 * 1024 * 1024
            {
                return Err(NativeError::Runtime(Error::ResourceLimit));
            }
        }
        if let Some(owner) = &mut self.owner {
            owner.resize_scaled(size, self.window.as_ref().unwrap().scale_factor() as f32)?;
        }
        if let Some(graphics) = &mut self.graphics {
            if let Some(owner) = &mut self.owner {
                owner.presentation_lost()?;
            }
            match graphics {
                Graphics::Gpu(gpu) => {
                    gpu.config.width = size[0];
                    gpu.config.height = size[1];
                    gpu.handle.configure(gpu.renderer.device(), &gpu.config);
                }
                Graphics::ReferenceCpu(surface, damage) => {
                    surface
                        .resize(
                            NonZeroU32::new(size[0]).unwrap(),
                            NonZeroU32::new(size[1]).unwrap(),
                        )
                        .map_err(platform)?;
                    *damage = SurfaceDamage::default();
                }
            }
        }
        self.request_redraw();
        Ok(())
    }
    fn request_redraw(&self) {
        if !self.occluded
            && let Some(window) = &self.window
        {
            window.request_redraw();
        }
    }
    fn redraw(&mut self) -> Result<(), NativeError> {
        if let Some(window) = &self.window {
            self.destination.observe(window.take_redraw_invalidation());
        }
        if self
            .retry_at
            .is_some_and(|deadline| deadline > Instant::now())
        {
            return Ok(());
        }
        self.retry_at = None;
        let Some(size) = self.window.as_ref().map(|window| window.inner_size()) else {
            return Ok(());
        };
        if size.width == 0
            || size.height == 0
            || self.occluded
            || self
                .window
                .as_ref()
                .is_some_and(|window| window.is_visible() == Some(false))
        {
            self.destination.invalidate();
            return Ok(());
        }
        if matches!(self.graphics, Some(Graphics::ReferenceCpu(..))) && self.try_upgrade()? {
            return Ok(());
        }
        if matches!(self.graphics, Some(Graphics::ReferenceCpu(..))) {
            let full = self.destination.requires_full();
            return match self.present_cpu(full) {
                Ok((commit, needs_gpu)) => {
                    self.destination.accepted(full);
                    self.did_present(RendererKind::ReferenceCpu, commit);
                    if needs_gpu {
                        self.start_upgrade();
                    }
                    Ok(())
                }
                Err(error) => {
                    self.destination.invalidate();
                    Err(error)
                }
            };
        }
        // One bounded reconfiguration/recreation. Repeated failure exits with a
        // typed fault instead of spinning an idle event loop or publishing P.
        for attempt in 0..2 {
            let Some(Graphics::Gpu(graphics)) = &mut self.graphics else {
                return Ok(());
            };
            match graphics.handle.get_current_texture() {
                wgpu::CurrentSurfaceTexture::Success(frame) => {
                    let owner = self.owner.as_mut().expect("surface has an owner");
                    let view = frame.texture.create_view(&Default::default());
                    let rendered = owner.with_paint_scene(|scene, token, paint| {
                        graphics
                            .render_paint(scene, token, paint, &view)
                            .map(|_| token)
                    })?;
                    let token = match rendered {
                        Ok(token) => token,
                        Err(error)
                            if self.renderer_policy == RendererPolicy::Auto
                                && matches!(
                                    error,
                                    gpui_gpu::Error::Precision { .. }
                                        | gpui_gpu::Error::ResourceLimit
                                        | gpui_gpu::Error::AtlasFull
                                ) =>
                        {
                            // Release this acquired Vulkan image before dropping
                            // the GPU cohort and presenting through software.
                            drop(view);
                            drop(frame);
                            owner.presentation_lost()?;
                            self.graphics = None;
                            self.instance = None;
                            self.upgrade = None;
                            // Do not oscillate on the same unsupported scene.
                            self.upgrade_attempted = true;
                            self.create_cpu_surface()?;
                            return self.redraw();
                        }
                        Err(error) => return Err(error.into()),
                    };
                    self.window.as_ref().unwrap().pre_present_notify();
                    graphics.renderer.queue().present(frame);
                    let commit = owner.presented(token)?;
                    self.did_present(RendererKind::Gpu, commit);
                    self.recoveries = 0;
                    self.timeouts = 0;
                    return Ok(());
                }
                wgpu::CurrentSurfaceTexture::Occluded => return Ok(()),
                wgpu::CurrentSurfaceTexture::Timeout => {
                    let Some(delay) = [16, 64, 256].get(self.timeouts as usize) else {
                        return Err(NativeError::SurfaceUnavailable);
                    };
                    self.timeouts += 1;
                    self.retry_at = Some(Instant::now() + Duration::from_millis(*delay));
                    return Ok(());
                }
                wgpu::CurrentSurfaceTexture::Suboptimal(frame) if attempt == 0 => {
                    // Release the acquired swapchain image before configure.
                    drop(frame);
                    self.resize([size.width, size.height])?;
                }
                wgpu::CurrentSurfaceTexture::Outdated if attempt == 0 => {
                    self.resize([size.width, size.height])?;
                }
                wgpu::CurrentSurfaceTexture::Lost if attempt == 0 => {
                    if let Some(owner) = &mut self.owner {
                        owner.presentation_lost()?;
                    }
                    self.upgrade = None;
                    self.upgrade_attempted = false;
                    self.instance = None;
                    self.graphics = None;
                    self.create_surface()?;
                }
                _ => return Err(NativeError::SurfaceUnavailable),
            }
        }
        Err(NativeError::SurfaceUnavailable)
    }
    fn did_present(&mut self, renderer: RendererKind, commit: Commit) {
        #[cfg(test)]
        {
            if self.presented_frames == 0 && self.renderer_policy == RendererPolicy::Auto {
                assert_eq!(renderer, RendererKind::ReferenceCpu);
                assert!(
                    self.instance.is_none(),
                    "Auto initialized Wgpu before its first software present"
                );
                assert!(
                    self.upgrade.is_none(),
                    "Auto worker started before first presentation feedback"
                );
            }
            self.presented_frames += 1;
        }
        if let Some(handler) = &mut self.presentation_feedback {
            handler(PresentedFrame {
                renderer,
                source_epoch: commit.source_epoch,
                presentation_epoch: commit.presentation_epoch,
            });
        }
    }
    fn start_upgrade(&mut self) {
        if self.renderer_policy != RendererPolicy::Auto || self.upgrade_attempted {
            return;
        }
        self.upgrade_attempted = true;
        let Some(window) = self.window.as_ref() else {
            return;
        };
        match upgrade::Upgrade::start(self.upgrade_policy, window, self.wake.clone()) {
            Ok(Some(upgrade)) => self.upgrade = Some(upgrade),
            Ok(None) => {
                #[cfg(test)]
                {
                    self.upgrade_rejection = Some("no automatic presentation candidate".into());
                }
            }
            Err(error) => eprintln!(
                "GPUI keeps software rendering: cannot start hardware initializer: {error}"
            ),
        }
    }
    /// Keep the CPU cohort alive until this Redraw has actually submitted and
    /// presented the latest complete canonical sheet through the new GPU.
    fn try_upgrade(&mut self) -> Result<bool, NativeError> {
        let Some(upgrade) = &mut self.upgrade else {
            return Ok(false);
        };
        let window = Arc::clone(self.window.as_ref().expect("upgrade has a window"));
        let ready = match upgrade.poll(&window, self.wake.clone()) {
            upgrade::Progress::Pending => return Ok(false),
            upgrade::Progress::Unavailable(reason) => {
                #[cfg(test)]
                {
                    self.upgrade_rejection = Some(reason.clone());
                }
                self.upgrade = None;
                // Hardware is opportunistic; retain software and its authority.
                let _ = reason;
                return Ok(false);
            }
            upgrade::Progress::Ready(ready) => ready,
        };
        self.upgrade = None;
        let upgrade::Ready { instance, mut gpu } = ready;
        // Configuration/acquisition can disturb the native destination even
        // when this handoff fails and software presents again in this turn.
        self.destination.invalidate();
        let size = window.inner_size();
        gpu.config.width = size.width.max(1);
        gpu.config.height = size.height.max(1);
        let owner = self.owner.as_mut().expect("upgrade has an owner");
        let result = (|| {
            if gpu.errors.take().is_some() {
                return Err(NativeError::SurfaceUnavailable);
            }
            let limit = gpu.renderer.device().limits().max_texture_dimension_2d;
            if size.width > limit || size.height > limit {
                return Err(NativeError::UnsupportedSurface);
            }
            gpu.handle.configure(gpu.renderer.device(), &gpu.config);
            let frame = match gpu.handle.get_current_texture() {
                wgpu::CurrentSurfaceTexture::Success(frame) => frame,
                _ => return Err(NativeError::SurfaceUnavailable),
            };
            let view = frame.texture.create_view(&Default::default());
            let token = owner.with_paint_scene(|scene, token, paint| {
                gpu.render_paint(scene, token, paint, &view).map(|_| token)
            })??;
            window.pre_present_notify();
            gpu.renderer.queue().present(frame);
            owner.presented(token).map_err(NativeError::from)
        })();
        match result {
            Ok(commit) => {
                self.instance = Some(instance);
                self.graphics = Some(Graphics::Gpu(gpu));
                self.recoveries = 0;
                self.timeouts = 0;
                self.did_present(RendererKind::Gpu, commit);
                Ok(true)
            }
            Err(error) => {
                // Drop the unadmitted GPU surface/device, then restore current
                // CPU pixels in this same Redraw. No GPU token was acknowledged.
                drop(gpu);
                drop(instance);
                eprintln!("GPUI keeps software rendering: hardware handoff failed: {error}");
                Ok(false)
            }
        }
    }
    fn present_cpu(&mut self, full: bool) -> Result<(Commit, bool), NativeError> {
        let Some(Graphics::ReferenceCpu(surface, history)) = &mut self.graphics else {
            unreachable!("CPU presentation requires an admitted CPU surface");
        };
        let window = self.window.as_ref().expect("surface has a window");
        let owner = self.owner.as_mut().expect("surface has an owner");
        let solid = owner
            .with_scene(|scene, token| {
                scene
                    .solid_bgrx()
                    .map(|color| color.map(|color| (color, token)))
            })?
            .map_err(Error::from)?;
        let notified = solid.is_some();
        if let Some((color, token)) = solid {
            window.pre_present_notify();
            if surface.present_solid(color).map_err(platform)? {
                let commit = owner.presented(token)?;
                // The solid backend may discard its pixel backing entirely.
                *history = SurfaceDamage::default();
                return Ok((commit, false));
            }
        }
        let mut buffer = surface.buffer_mut().map_err(platform)?;
        let age = buffer.age();
        let (token, damage) = owner.render_preserved_bgrx(&mut buffer, history.since(age))?;
        if !notified {
            window.pre_present_notify();
        }
        #[cfg(test)]
        if std::mem::take(&mut self.fail_next_cpu_present) {
            // Exercise a real backend rejection before acknowledgment. The
            // explicit X11 proof requires SHM; Wire ignores damage rectangles.
            buffer
                .present_with_damage(&[softbuffer::Rect {
                    x: u32::MAX,
                    y: 0,
                    width: NonZeroU32::new(1).unwrap(),
                    height: NonZeroU32::new(1).unwrap(),
                }])
                .map_err(platform)?;
            panic!("native failure proof requires XShm damage validation");
        }
        if full {
            buffer.present().map_err(platform)?;
        } else if let Some([left, top, right, bottom]) = damage.bounds() {
            buffer
                .present_with_damage(&[softbuffer::Rect {
                    x: left,
                    y: top,
                    width: NonZeroU32::new(right - left).expect("nonempty damage"),
                    height: NonZeroU32::new(bottom - top).expect("nonempty damage"),
                }])
                .map_err(platform)?;
        } else {
            // XShm sends no image rectangle but retains its completion
            // barrier and coherent client-buffer age. Wire may copy full.
            buffer.present_with_damage(&[]).map_err(platform)?;
        }
        let commit = owner.presented(token)?;
        history.presented(damage);
        // A certified fill needs no device, pipeline, worker or driver probe.
        // The first complex frame is still submitted here before Auto starts
        // its asynchronous handoff. Keep this decision independent of whether
        // the platform offers a native fill or needs an ordinary CPU buffer.
        Ok((commit, !notified))
    }
    fn input_result(&mut self, result: Result<Commit, Error>) -> Result<(), NativeError> {
        match result {
            Ok(commit) => {
                if commit.prepared_epoch.is_some() {
                    self.request_redraw();
                }
            }
            Err(Error::NotInput | Error::NotInteractive) => {}
            Err(Error::StaleTarget | Error::PresentationStale) => {}
            Err(error @ (Error::Canvas(_) | Error::Layout(_) | Error::PresentationPanicked)) => {
                if let Some(handler) = &mut self.presentation_error {
                    handler(&error);
                } else {
                    eprintln!("GPUI presentation failed; source edits retained: {error}");
                }
            }
            Err(error) => return Err(error.into()),
        }
        Ok(())
    }
    fn key_input(&mut self, key: &NativeKey, text: Option<&str>) -> Result<(), NativeError> {
        if self.modifiers.control_key() || self.modifiers.super_key() {
            return Ok(());
        }
        let Some(owner) = &mut self.owner else {
            return Ok(());
        };
        let key = match key {
            NativeKey::Named(NamedKey::Backspace) => Key::Backspace,
            NativeKey::Named(NamedKey::ArrowLeft) => Key::Left {
                extend: self.modifiers.shift_key(),
            },
            NativeKey::Named(NamedKey::ArrowRight) => Key::Right {
                extend: self.modifiers.shift_key(),
            },
            NativeKey::Named(NamedKey::Enter) => Key::Enter,
            NativeKey::Named(NamedKey::Space) => Key::Space,
            NativeKey::Named(NamedKey::Tab) if self.modifiers.shift_key() => Key::ReverseTab,
            NativeKey::Named(NamedKey::Tab) => Key::Tab,
            _ => match text {
                Some(text) => Key::Text(text),
                None => return Ok(()),
            },
        };
        let result = owner.key(key);
        self.input_result(result)
    }
    fn pointer_input(&mut self, event: PointerEvent) -> Result<(), NativeError> {
        let Some(owner) = &mut self.owner else {
            return Ok(());
        };
        let result = owner.pointer_event(&mut self.pointer, event);
        match result {
            Ok(commit)
                if matches!(
                    event,
                    PointerEvent::Move(_) | PointerEvent::Leave | PointerEvent::Cancel
                ) && commit.changed_nodes == 0 =>
            {
                Ok(())
            }
            Err(Error::NotHittable) => Ok(()),
            result => self.input_result(result),
        }
    }
    fn window_event(
        &mut self,
        event_loop: &ActiveEventLoop,
        event: &WindowEvent,
    ) -> Result<(), NativeError> {
        #[cfg(feature = "accessibility")]
        if let (Some(bridge), Some(window)) = (&mut self.accessibility, &self.window) {
            bridge.process_event(window, event);
        }
        match event {
            WindowEvent::CloseRequested => {
                self.retire_window();
                event_loop.exit();
            }
            WindowEvent::Resized(size) => self.resize([size.width, size.height])?,
            // A prior physical point is relative to the previous window
            // origin. Wait for a new cursor sample before another press.
            WindowEvent::Moved(_) => self.pointer = PointerSession::default(),
            WindowEvent::ScaleFactorChanged { .. } => {
                if let Some(window) = &self.window {
                    let size = window.inner_size();
                    self.resize([size.width, size.height])?;
                }
            }
            WindowEvent::RedrawRequested => self.redraw()?,
            WindowEvent::Occluded(value) => {
                self.destination.invalidate();
                self.occluded = *value;
                if !value {
                    self.request_redraw();
                }
            }
            WindowEvent::CursorMoved { position, .. } => {
                self.pointer_input(PointerEvent::Move(Point {
                    x: position.x as f32,
                    y: position.y as f32,
                }))?;
            }
            WindowEvent::CursorLeft { .. } => {
                self.pointer_input(PointerEvent::Leave)?;
            }
            WindowEvent::Focused(false) => {
                self.pointer = PointerSession::default();
                if let Some(owner) = &mut self.owner {
                    let result = owner.clear_focus();
                    self.input_result(result)?;
                }
                self.modifiers = ModifiersState::empty();
            }
            WindowEvent::ModifiersChanged(modifiers) => self.modifiers = modifiers.state(),
            WindowEvent::MouseWheel { delta, .. } => {
                let scale = self
                    .window
                    .as_ref()
                    .map_or(1.0, |window| window.scale_factor());
                let (dx, dy) = match delta {
                    MouseScrollDelta::LineDelta(x, y) => {
                        (-f64::from(*x) * 32.0, -f64::from(*y) * 32.0)
                    }
                    MouseScrollDelta::PixelDelta(position) => {
                        (-position.x / scale, -position.y / scale)
                    }
                };
                if !dx.is_finite() || !dy.is_finite() {
                    return Ok(());
                }
                self.pointer_input(PointerEvent::Wheel(crate::ScrollDelta { x: dx, y: dy }))?;
            }
            WindowEvent::MouseInput {
                state,
                button: MouseButton::Left,
                ..
            } => {
                self.pointer_input(if *state == ElementState::Pressed {
                    PointerEvent::Press
                } else {
                    PointerEvent::Release
                })?;
            }
            WindowEvent::KeyboardInput {
                event,
                is_synthetic: false,
                ..
            } if event.state == ElementState::Pressed => {
                self.key_input(&event.logical_key, event.text.as_deref())?;
            }
            _ => {}
        }
        Ok(())
    }
}
impl<V: View + 'static, L: LaneSet<V>> Host for NativeHost<V, L> {
    fn dispatch(&mut self, event_loop: &ActiveEventLoop, callback: Callback<'_>) {
        if !matches!(&callback, Callback::Suspended | Callback::Exiting)
            && let Some(fault) = self.graphics.as_ref().and_then(Graphics::fault)
        {
            let result = match fault {
                DeviceFault::Lost if self.recoveries == 0 => {
                    if let Some(owner) = &mut self.owner
                        && let Err(error) = owner.presentation_lost()
                    {
                        self.error = Some(error.into());
                        event_loop.exit();
                        return;
                    }
                    self.recoveries += 1;
                    self.upgrade = None;
                    self.upgrade_attempted = false;
                    self.instance = None;
                    self.graphics = None;
                    self.create_surface()
                }
                DeviceFault::Lost => Err(NativeError::SurfaceUnavailable),
                DeviceFault::Error(message) => Err(NativeError::DeviceFault(message)),
            };
            if let Err(error) = result {
                self.error = Some(error);
                event_loop.exit();
                return;
            }
        }
        let result = match callback {
            Callback::NewEvents(_)
                if self
                    .retry_at
                    .is_some_and(|deadline| deadline <= Instant::now()) =>
            {
                self.retry_at = None;
                self.request_redraw();
                Ok(())
            }
            Callback::WorkReady => {
                #[cfg(feature = "accessibility")]
                if let (Some(bridge), Some(owner)) = (&mut self.accessibility, &mut self.owner) {
                    match bridge.drain(owner) {
                        Ok(results) => {
                            for result in results.into_iter().flatten() {
                                if let Err(error) = self.input_result(result) {
                                    self.error = Some(error);
                                    event_loop.exit();
                                    return;
                                }
                            }
                        }
                        Err(error) => {
                            self.accessibility = None;
                            self.error = Some(error);
                            event_loop.exit();
                            return;
                        }
                    }
                }
                if let Some(owner) = &mut self.owner {
                    let before = owner.runtime_epoch();
                    let result = match owner.deliver_ready(64) {
                        Ok(delivery) => Ok(delivery.commit),
                        Err(DeliveryError {
                            error,
                            delivery: Some(delivery),
                        }) if delivery.commit.source_epoch > before
                            && !matches!(error, Error::OwnerPanicked | Error::Poisoned) =>
                        {
                            if let Some(handler) = &mut self.presentation_error {
                                handler(&error);
                            } else {
                                eprintln!(
                                    "GPUI completion presentation failed; applied={} S={} P={}: {}",
                                    delivery.applied,
                                    delivery.commit.source_epoch,
                                    delivery.commit.presentation_epoch,
                                    error
                                );
                            }
                            Ok(delivery.commit)
                        }
                        Err(failure) => Err(failure.error),
                    };
                    if let Err(error) = self.input_result(result) {
                        self.error = Some(error);
                        event_loop.exit();
                        return;
                    }
                }
                if self.upgrade.is_some() {
                    self.request_redraw();
                }
                Ok(())
            }
            Callback::AboutToWait => {
                event_loop.set_control_flow(match self.retry_at.filter(|_| !self.occluded) {
                    Some(deadline) => winit::event_loop::ControlFlow::WaitUntil(deadline),
                    None => winit::event_loop::ControlFlow::Wait,
                });
                Ok(())
            }
            Callback::Resumed => self.resumed(event_loop),
            Callback::Suspended => {
                self.destination.invalidate();
                self.pointer = PointerSession::default();
                // Dropping both bounded channel endpoints cancels this admission
                // generation; a late worker can only drop its owned resources.
                self.hide_and_cancel_upgrade();
                self.upgrade_attempted = false;
                self.instance = None;
                self.graphics = None;
                self.owner
                    .as_mut()
                    .map(Win::presentation_lost)
                    .transpose()
                    .map(|_| ())
                    .map_err(NativeError::from)
            }
            Callback::Exiting => {
                self.retire_window();
                Ok(())
            }
            Callback::Window { id, event }
                if self.window.as_ref().is_some_and(|window| window.id() == id) =>
            {
                self.window_event(event_loop, event)
            }
            _ => Ok(()),
        };
        if let Err(error) = result {
            self.error = Some(error);
            event_loop.exit();
        }
        #[cfg(feature = "accessibility")]
        if self.error.is_none()
            && let (Some(bridge), Some(owner)) = (&mut self.accessibility, &mut self.owner)
            && let Err(error) = bridge.sync(owner)
        {
            self.accessibility = None;
            self.error = Some(error);
            event_loop.exit();
        }
    }
}

#[cfg(all(
    test,
    any(feature = "x11", feature = "x11-minimal"),
    target_os = "linux"
))]
#[path = "../examples/support/todos.rs"]
pub(crate) mod test_todos;

#[cfg(all(
    test,
    any(feature = "x11", feature = "x11-minimal"),
    target_os = "linux"
))]
mod paint_tests;
#[cfg(all(
    test,
    any(feature = "x11", feature = "x11-minimal"),
    target_os = "linux"
))]
mod solid_tests;

#[cfg(all(
    test,
    any(feature = "x11", feature = "x11-minimal"),
    target_os = "linux"
))]
mod tests {
    use super::*;
    use crate::{
        Affine, Target,
        property::{Contribution, TRANSFORM},
    };
    use std::sync::mpsc::{self, Receiver};
    use std::time::{Duration, Instant};
    use winit::{dpi::PhysicalPosition, event::DeviceId, platform::x11::EventLoopBuilderExtX11};

    enum Observed {
        Fault,
        Presented(PresentedFrame),
    }
    struct Script {
        host: NativeHost<test_todos::Todos>,
        stage: u8,
        started: Instant,
        complete: bool,
        feedback: Receiver<Observed>,
        faults: usize,
        retained_target: Option<Target>,
        frames: Vec<PresentedFrame>,
        edited_during_upgrade: bool,
        cancelled_generation: bool,
        exposure_submissions: Option<u64>,
        selection_stage: u8,
    }
    fn exercise_window_packet_namespaces(gpu: &mut GpuSurface) {
        struct Fill(crate::Color);
        impl View for Fill {
            fn view(&self) -> crate::El<'_> {
                crate::div().w(32).h(24).bg(self.0)
            }
        }
        let options = WindowOptions {
            size: [32, 24],
            ..Default::default()
        };
        // Both fresh windows begin at S0/first sequence; only their namespace differs.
        let a = Win::recording(Fill(crate::Color::rgb(200, 20, 30)), options).unwrap();
        let b = Win::recording(Fill(crate::Color::rgb(20, 30, 200)), options).unwrap();
        let token_a = a.with_scene(|_, token| token).unwrap();
        let token_b = b.with_scene(|_, token| token).unwrap();
        assert_ne!(token_a, token_b);
        let texture = gpu
            .renderer
            .device()
            .create_texture(&wgpu::TextureDescriptor {
                label: Some("native namespace oracle"),
                size: wgpu::Extent3d {
                    width: 32,
                    height: 24,
                    depth_or_array_layers: 1,
                },
                mip_level_count: 1,
                sample_count: 1,
                dimension: wgpu::TextureDimension::D2,
                format: gpu.renderer.format(),
                usage: wgpu::TextureUsages::RENDER_ATTACHMENT,
                view_formats: &[],
            });
        let target = texture.create_view(&Default::default());
        for (window, reused) in [(&a, false), (&a, true), (&b, false), (&a, false)] {
            window
                .with_scene(|scene, token| gpu.render_paint(scene, token, None, &target))
                .unwrap()
                .unwrap();
            assert_eq!(gpu.renderer.stats().packet_reused, reused);
        }
        // A renderer mode change invalidates its packet even though the native
        // token is still current. The adapter must fall back to full admission.
        gpu.renderer.set_tile_proofs(false);
        a.with_scene(|scene, token| gpu.render_paint(scene, token, None, &target))
            .unwrap()
            .unwrap();
        assert!(!gpu.renderer.stats().packet_reused);
        gpu.renderer.set_tile_proofs(true);
        a.with_scene(|scene, token| gpu.render_paint(scene, token, None, &target))
            .unwrap()
            .unwrap();
        // Failed replacement revokes the old native binding as well. The public
        // GPU regression exercises a failure after actual image/atlas mutation.
        assert!(
            b.with_scene(|mut scene, token| {
                scene.width += 1;
                gpu.render_paint(scene, token, None, &target)
            })
            .unwrap()
            .is_err()
        );
        assert!(gpu.packet_token.is_none());
        a.with_scene(|scene, token| gpu.render_paint(scene, token, None, &target))
            .unwrap()
            .unwrap();
        assert!(!gpu.renderer.stats().packet_reused);
        super::paint_tests::run(gpu);
    }
    #[test]
    fn packet_gpu_header_ledger() {
        eprintln!(
            "packet_gpu_layout,Renderer={},Stats={},GpuSurface={},NativeHost={},Canvas={},PreparedScene={}",
            size_of::<Renderer>(),
            size_of::<gpui_gpu::Stats>(),
            size_of::<GpuSurface>(),
            size_of::<NativeHost<test_todos::Todos>>(),
            size_of::<gpui_canvas::Canvas>(),
            size_of::<gpui_canvas::PreparedScene<'_>>()
        );
    }
    impl Script {
        fn collect_feedback(&mut self) {
            for feedback in self.feedback.try_iter() {
                match feedback {
                    Observed::Fault => self.faults += 1,
                    Observed::Presented(frame) => self.frames.push(frame),
                }
            }
        }
        fn step(&mut self, event_loop: &ActiveEventLoop) {
            self.collect_feedback();
            assert!(
                self.started.elapsed() < Duration::from_secs(30),
                "native script timed out at stage {}",
                self.stage
            );
            let Some(owner) = &mut self.host.owner else {
                return;
            };
            let sheet = owner.snapshot().unwrap();
            if !sheet.presentation_valid || sheet.presentation_epoch != sheet.source_epoch {
                return;
            }
            match self.stage {
                0 => {
                    if self.host.renderer_policy == RendererPolicy::Auto {
                        assert_eq!(self.frames[0].renderer, RendererKind::ReferenceCpu);
                        if self.host.upgrade_policy.allow_cpu
                            && self.host.upgrade.is_some()
                            && !self.cancelled_generation
                        {
                            // Cancel an owned initialization generation without
                            // waiting for its worker; a late result cannot attach.
                            self.host.dispatch(event_loop, Callback::Suspended);
                            assert!(self.host.upgrade.is_none());
                            self.host.dispatch(event_loop, Callback::Resumed);
                            self.cancelled_generation = true;
                            // Tab cannot use the detached sheet. Resume must
                            // actually present again before navigation proceeds.
                            self.host
                                .key_input(&NativeKey::Named(NamedKey::Tab), None)
                                .unwrap();
                            assert_eq!(self.host.owner.as_ref().unwrap().focused().unwrap(), None);
                            return;
                        }
                    }
                    let owner = self.host.owner.as_mut().unwrap();
                    let input = owner.input();
                    assert_eq!(owner.focused().unwrap(), None);
                    self.host
                        .key_input(&NativeKey::Named(NamedKey::Tab), None)
                        .unwrap();
                    assert_eq!(
                        self.host.owner.as_ref().unwrap().focused().unwrap(),
                        Some(input)
                    );
                    self.host
                        .key_input(&NativeKey::Named(NamedKey::Tab), None)
                        .unwrap();
                    assert_eq!(
                        self.host.owner.as_ref().unwrap().focused().unwrap(),
                        Some(self.host.owner.as_ref().unwrap().button("Add"))
                    );
                    self.host.modifiers = ModifiersState::SHIFT;
                    self.host
                        .key_input(&NativeKey::Named(NamedKey::Tab), None)
                        .unwrap();
                    self.host.modifiers = ModifiersState::empty();
                    assert_eq!(
                        self.host.owner.as_ref().unwrap().focused().unwrap(),
                        Some(input)
                    );
                    self.host
                        .window_event(event_loop, &WindowEvent::Focused(false))
                        .unwrap();
                    assert_eq!(self.host.owner.as_ref().unwrap().focused().unwrap(), None);
                    self.host
                        .key_input(&NativeKey::Named(NamedKey::Tab), None)
                        .unwrap();
                    self.host
                        .key_input(&NativeKey::Character("Ship".into()), Some("Ship"))
                        .unwrap();
                    self.host
                        .key_input(&NativeKey::Named(NamedKey::Space), Some(" "))
                        .unwrap();
                    self.host
                        .key_input(&NativeKey::Character("new GPUI".into()), Some("new GPUI"))
                        .unwrap();
                    // Unsupported shaping retains the accepted source edit and
                    // old sheet; ordinary backspace repairs it without exit.
                    self.host
                        .key_input(&NativeKey::Character("漢".into()), Some("漢"))
                        .unwrap();
                    let failed = self.host.owner.as_ref().unwrap().snapshot().unwrap();
                    assert!(failed.source_epoch > failed.presentation_epoch);
                    self.host
                        .key_input(&NativeKey::Named(NamedKey::Tab), None)
                        .unwrap();
                    assert_eq!(
                        self.host.owner.as_ref().unwrap().focused().unwrap(),
                        Some(input)
                    );
                    self.collect_feedback();
                    assert_eq!(self.faults, 1);
                    self.host
                        .key_input(&NativeKey::Named(NamedKey::Backspace), None)
                        .unwrap();
                }
                1 => {
                    // Each step waits for the actual native presentation above.
                    // Exercise the production modifier adapter, range painting
                    // and replacement through the same input path as the host.
                    if self.selection_stage == 0 {
                        self.host.modifiers = ModifiersState::SHIFT;
                        self.host
                            .key_input(&NativeKey::Named(NamedKey::ArrowLeft), None)
                            .unwrap();
                        self.host.modifiers = ModifiersState::empty();
                        let owner = self.host.owner.as_ref().unwrap();
                        let selection = owner.selection(owner.input()).unwrap();
                        assert_eq!(selection.anchor.offset.byte(), 13);
                        assert_eq!(selection.focus.offset.byte(), 12);
                        self.selection_stage = 1;
                        return;
                    }
                    if self.selection_stage == 1 {
                        if let Some(Graphics::ReferenceCpu(surface, _)) = &mut self.host.graphics {
                            let expected = self
                                .host
                                .owner
                                .as_mut()
                                .unwrap()
                                .with_pixels(|pixels, _, _| {
                                    pixels
                                        .chunks_exact(4)
                                        .map(|p| {
                                            (u32::from(p[0]) << 16)
                                                | (u32::from(p[1]) << 8)
                                                | u32::from(p[2])
                                        })
                                        .collect::<Vec<_>>()
                                })
                                .unwrap();
                            assert_eq!(surface.fetch().unwrap(), expected);
                        }
                        self.host
                            .key_input(&NativeKey::Character("I".into()), Some("I"))
                            .unwrap();
                        let owner = self.host.owner.as_ref().unwrap();
                        let selection = owner.selection(owner.input()).unwrap();
                        assert_eq!(selection.anchor.offset.byte(), 13);
                        assert_eq!(selection.focus.offset.byte(), 13);
                        assert!(owner.contains_text("Ship new GPUI").unwrap());
                        self.selection_stage = 2;
                        return;
                    }
                    if self.selection_stage == 2 || self.selection_stage == 3 {
                        let input = owner.input();
                        let bounds = sheet
                            .nodes
                            .iter()
                            .find(|node| node.target == Some(input))
                            .unwrap()
                            .rect();
                        let x = if self.selection_stage == 2 {
                            bounds.x + 1.
                        } else {
                            bounds.x + bounds.width - 1.
                        };
                        self.host
                            .pointer_input(PointerEvent::Move(Point {
                                x,
                                y: bounds.y + bounds.height * 0.5,
                            }))
                            .unwrap();
                        if self.selection_stage == 2 {
                            self.host.pointer_input(PointerEvent::Press).unwrap();
                            let owner = self.host.owner.as_ref().unwrap();
                            assert_eq!(owner.focused().unwrap(), Some(input));
                            assert_eq!(owner.selection(input).unwrap().anchor.offset.byte(), 0);
                        }
                        self.selection_stage += 1;
                        return;
                    }
                    if self.selection_stage == 4 {
                        let selection = owner.selection(owner.input()).unwrap();
                        assert_eq!(selection.anchor.offset.byte(), 0);
                        assert_eq!(selection.focus.offset.byte(), 13);
                        self.host.pointer_input(PointerEvent::Release).unwrap();
                        self.host
                            .key_input(
                                &NativeKey::Character("Ship new GPUI".into()),
                                Some("Ship new GPUI"),
                            )
                            .unwrap();
                        self.selection_stage = 5;
                        return;
                    }
                    let target = owner.button("Add");
                    let bounds = sheet
                        .nodes
                        .iter()
                        .find(|node| node.target == Some(target))
                        .unwrap()
                        .rect();
                    let position = PhysicalPosition::new(
                        f64::from(bounds.x + bounds.width * 0.5),
                        f64::from(bounds.y + bounds.height * 0.5),
                    );
                    let device_id = DeviceId::dummy();
                    for invalidation in [
                        WindowEvent::Moved(winit::dpi::PhysicalPosition::new(0, 0)),
                        WindowEvent::Resized(winit::dpi::PhysicalSize::new(
                            sheet.size[0],
                            sheet.size[1],
                        )),
                        WindowEvent::Focused(false),
                    ] {
                        self.host
                            .pointer_input(PointerEvent::Move(Point {
                                x: position.x as f32,
                                y: position.y as f32,
                            }))
                            .unwrap();
                        self.host.pointer_input(PointerEvent::Press).unwrap();
                        // Press can publish removal of the input's focused
                        // caret. The invalidated samples below must be idle.
                        let source_epoch = self
                            .host
                            .owner
                            .as_ref()
                            .unwrap()
                            .snapshot()
                            .unwrap()
                            .source_epoch;
                        self.host.window_event(event_loop, &invalidation).unwrap();
                        assert_eq!(self.host.pointer.position(), None);
                        // Resize detaches coordinate authority. Exercise a
                        // real native present before trying a fresh press.
                        self.host.redraw().unwrap();
                        // No new physical sample: neither the old release nor
                        // a fresh press/release may reuse the previous point.
                        for event in [
                            PointerEvent::Release,
                            PointerEvent::Press,
                            PointerEvent::Release,
                        ] {
                            self.host.pointer_input(event).unwrap();
                        }
                        assert_eq!(
                            self.host
                                .owner
                                .as_ref()
                                .unwrap()
                                .snapshot()
                                .unwrap()
                                .source_epoch,
                            source_epoch
                        );
                    }
                    self.host
                        .window_event(
                            event_loop,
                            &WindowEvent::CursorMoved {
                                device_id,
                                position,
                            },
                        )
                        .unwrap();
                    assert_eq!(
                        self.host
                            .owner
                            .as_ref()
                            .unwrap()
                            .hit_target(self.host.pointer.position().unwrap())
                            .unwrap(),
                        Some(target),
                    );
                    for state in [ElementState::Pressed, ElementState::Released] {
                        self.host
                            .window_event(
                                event_loop,
                                &WindowEvent::MouseInput {
                                    device_id,
                                    state,
                                    button: MouseButton::Left,
                                },
                            )
                            .unwrap();
                    }
                }
                2 => {
                    assert!(owner.find_text("Ship new GPUI").is_ok());
                    assert!(owner.find_text("1 left").is_ok());
                    let _ = self
                        .host
                        .window
                        .as_ref()
                        .unwrap()
                        .request_inner_size(winit::dpi::PhysicalSize::new(640, 480));
                    self.host.request_redraw();
                }
                3 => {
                    if sheet.size != [640, 480] {
                        return;
                    }
                    let target = owner.find_text("Ship new GPUI").unwrap();
                    owner
                        .set_property(
                            target,
                            TRANSFORM,
                            Contribution::Set(Affine::translation(7., 3.)),
                        )
                        .unwrap();
                    self.host.request_redraw();
                }
                4 => {
                    if self.host.upgrade_policy.force_probe && !self.host.upgrade_policy.allow_cpu {
                        if self.host.upgrade.is_some() {
                            return;
                        }
                        if self.host.upgrade_rejection.as_deref() == Some("CPU-only adapter") {
                            assert!(matches!(
                                self.host.graphics,
                                Some(Graphics::ReferenceCpu(..))
                            ));
                            assert!(self.host.instance.is_none());
                            eprintln!(
                                "Auto rejected actual CPU adapter before requesting a device/pipeline"
                            );
                        }
                    }
                    if self.host.renderer_policy == RendererPolicy::Auto
                        && self.host.upgrade_policy.allow_cpu
                        && !matches!(self.host.graphics, Some(Graphics::Gpu(_)))
                    {
                        if !self.edited_during_upgrade {
                            let input = owner.input();
                            owner.focus(input).unwrap();
                            self.host
                                .key_input(
                                    &NativeKey::Character("while preparing".into()),
                                    Some("while preparing"),
                                )
                                .unwrap();
                            self.edited_during_upgrade = true;
                        }
                        if let Some(upgrade) = &mut self.host.upgrade {
                            upgrade.release_renderer();
                        }
                        return;
                    }
                    if self.host.renderer_policy == RendererPolicy::Auto {
                        assert_eq!(self.frames[0].renderer, RendererKind::ReferenceCpu);
                        if self.host.upgrade_policy.allow_cpu {
                            let last = *self.frames.last().unwrap();
                            assert_eq!(last.renderer, RendererKind::Gpu);
                            assert_eq!(
                                (last.source_epoch, last.presentation_epoch),
                                (sheet.source_epoch, sheet.source_epoch)
                            );
                            assert!(
                                self.edited_during_upgrade,
                                "model changed while real pipeline initialized"
                            );
                        }
                    }
                    let owner = self.host.owner.as_mut().unwrap();
                    let target = owner.find_text("Ship new GPUI").unwrap();
                    assert_eq!(
                        owner.property(target, TRANSFORM).unwrap(),
                        Affine::translation(7., 3.)
                    );
                    match self.host.graphics.as_mut().unwrap() {
                        Graphics::Gpu(gpu) => {
                            let stats = gpu.renderer.stats();
                            if self.host.renderer_policy == RendererPolicy::Gpu {
                                assert!(stats.submissions >= 5);
                                if self.exposure_submissions.is_none() {
                                    assert_eq!(
                                        stats.mask_upload_bytes, 0,
                                        "transform-only update reuses glyph atlas"
                                    );
                                }
                            } else {
                                assert!(
                                    stats.submissions >= 1,
                                    "real Auto handoff submitted through Wgpu"
                                );
                            }
                            if let Some(previous) = self.exposure_submissions {
                                if stats.submissions == previous {
                                    return;
                                }
                                assert!(
                                    stats.packet_reused,
                                    "same-token OS exposure replays the packet"
                                );
                                assert_eq!(
                                    (
                                        stats.validated_draws,
                                        stats.binning_tile_visits,
                                        stats.instance_upload_bytes,
                                        stats.bind_group_creations
                                    ),
                                    (0, 0, 0, 0)
                                );
                            } else {
                                exercise_window_packet_namespaces(gpu);
                                // Restore this owner's packet after the foreign-window oracle.
                                owner
                                    .with_scene(|scene, token| {
                                        let texture = gpu.renderer.device().create_texture(
                                            &wgpu::TextureDescriptor {
                                                label: Some("restore native owner packet"),
                                                size: wgpu::Extent3d {
                                                    width: scene.width,
                                                    height: scene.height,
                                                    depth_or_array_layers: 1,
                                                },
                                                mip_level_count: 1,
                                                sample_count: 1,
                                                dimension: wgpu::TextureDimension::D2,
                                                format: gpu.renderer.format(),
                                                usage: wgpu::TextureUsages::RENDER_ATTACHMENT,
                                                view_formats: &[],
                                            },
                                        );
                                        gpu.render_paint(
                                            scene,
                                            token,
                                            None,
                                            &texture.create_view(&Default::default()),
                                        )
                                        .unwrap();
                                    })
                                    .unwrap();
                                self.exposure_submissions = Some(gpu.renderer.stats().submissions);
                                self.host.request_redraw();
                                return;
                            }
                            eprintln!("native GPU port: {stats:?}");
                        }
                        Graphics::ReferenceCpu(surface, _) => {
                            // Actual X11 window contents, through the library's
                            // ordinary CPU diagnostic oracle. Only this explicit
                            // diagnostic allocates a GPUI output image.
                            let expected = owner
                                .with_pixels(|pixels, _, _| {
                                    pixels
                                        .chunks_exact(4)
                                        .map(|p| {
                                            (u32::from(p[0]) << 16)
                                                | (u32::from(p[1]) << 8)
                                                | u32::from(p[2])
                                        })
                                        .collect::<Vec<_>>()
                                })
                                .unwrap();
                            assert_eq!(surface.fetch().unwrap(), expected);
                        }
                    }
                    if self.host.renderer_policy == RendererPolicy::Auto
                        && self.host.upgrade_policy.allow_cpu
                    {
                        // The CPU admits a subnormal radius. GPU FTZ/distance
                        // admission must fall back by actually presenting this
                        // same canonical candidate through softbuffer.
                        let owner = self.host.owner.as_mut().unwrap();
                        owner
                            .set_property(
                                target,
                                crate::property::BACKGROUND,
                                Contribution::Set(crate::Color::BLACK),
                            )
                            .unwrap();
                        owner
                            .set_property(
                                target,
                                crate::property::CORNER_RADIUS,
                                Contribution::Set(f32::from_bits(1)),
                            )
                            .unwrap();
                        self.host.redraw().unwrap();
                        let Some(Graphics::ReferenceCpu(surface, _)) = &mut self.host.graphics
                        else {
                            panic!("rounded Precision must execute CPU fallback");
                        };
                        let owner = self.host.owner.as_mut().unwrap();
                        let sheet = owner.snapshot().unwrap();
                        assert!(sheet.presentation_valid);
                        assert_eq!(sheet.source_epoch, sheet.presentation_epoch);
                        let expected = owner
                            .with_pixels(|pixels, _, _| {
                                pixels
                                    .chunks_exact(4)
                                    .map(|p| {
                                        (u32::from(p[0]) << 16)
                                            | (u32::from(p[1]) << 8)
                                            | u32::from(p[2])
                                    })
                                    .collect::<Vec<_>>()
                            })
                            .unwrap();
                        assert_eq!(surface.fetch().unwrap(), expected);
                    }
                    self.retained_target = Some(target);
                    self.host.dispatch(event_loop, Callback::Suspended);
                    assert_eq!(
                        self.host
                            .owner
                            .as_ref()
                            .unwrap()
                            .hit_target(Point { x: 1., y: 1. }),
                        Err(Error::PresentationStale)
                    );
                    self.host.dispatch(event_loop, Callback::Resumed);
                }
                5 => {
                    assert_eq!(
                        owner.find_text("Ship new GPUI").unwrap(),
                        self.retained_target.unwrap()
                    );
                    assert_eq!(self.faults, 1);
                    if let Some(Graphics::Gpu(gpu)) = &self.host.graphics {
                        assert!(gpu.renderer.stats().submissions > 0);
                    }
                    self.complete = true;
                    event_loop.exit();
                }
                _ => unreachable!(),
            }
            self.stage += 1;
        }
    }
    impl Host for Script {
        fn dispatch(&mut self, event_loop: &ActiveEventLoop, callback: Callback<'_>) {
            let about_to_wait = matches!(callback, Callback::AboutToWait);
            self.host.dispatch(event_loop, callback);
            assert!(self.host.error.is_none(), "{:?}", self.host.error);
            if about_to_wait {
                self.step(event_loop);
                // Only the test has a deadline wake; ordinary applications wait
                // indefinitely while idle without polling or frame requests.
                event_loop.set_control_flow(winit::event_loop::ControlFlow::WaitUntil(
                    Instant::now() + Duration::from_millis(20),
                ));
            }
        }
    }

    #[test]
    #[ignore = "requires a real X11 display and Vulkan driver; see README"]
    fn native_todo_port_presents_edits_pointer_actions_resize_and_inspection() {
        use winit::platform::run_on_demand::EventLoopExtRunOnDemand;
        let mut event_loop = EventLoop::builder()
            .with_x11()
            .with_any_thread(true)
            .build()
            .unwrap();
        solid_tests::run(&mut event_loop);
        for (policy, allow_cpu, force_probe) in [
            (RendererPolicy::Auto, false, false),
            (RendererPolicy::Gpu, false, false),
            (RendererPolicy::ReferenceCpu, false, false),
            (RendererPolicy::Auto, false, true),
            (RendererPolicy::Auto, true, true),
        ] {
            let (observer, feedback) = mpsc::channel();
            let frame_observer = observer.clone();
            let mut host = NativeHost::new(
                Window::document(test_todos::Todos::default())
                    .size(540, 620)
                    .on_presentation_error(move |_| observer.send(Observed::Fault).unwrap())
                    .on_presented(move |frame| {
                        frame_observer.send(Observed::Presented(frame)).unwrap()
                    })
                    .renderer(policy),
            );
            host.upgrade_policy.allow_cpu = allow_cpu;
            host.upgrade_policy.defer_renderer = allow_cpu;
            host.upgrade_policy.force_probe = force_probe;
            let script = Script {
                host,
                stage: 0,
                started: Instant::now(),
                complete: false,
                feedback,
                faults: 0,
                retained_target: None,
                frames: Vec::new(),
                edited_during_upgrade: false,
                cancelled_generation: false,
                exposure_submissions: None,
                selection_stage: 0,
            };
            let (mut driver, wake) = Driver::new(&event_loop, script);
            driver.host_mut().host.wake = Some(wake);
            event_loop.run_app_on_demand(&mut driver).unwrap();
            assert!(driver.host().complete);
        }
    }
}

#[cfg(all(test, feature = "x11", target_os = "linux"))]
mod question_tests;
#[cfg(all(
    test,
    any(feature = "x11", feature = "x11-minimal"),
    target_os = "linux"
))]
#[path = "native/remote_tests.rs"]
mod remote_tests;

#[cfg(all(
    test,
    target_os = "linux",
    any(feature = "x11", feature = "x11-minimal")
))]
mod unicode_tests;

#[cfg(all(
    test,
    target_os = "linux",
    any(feature = "x11", feature = "x11-minimal")
))]
mod image_tests;

#[cfg(all(
    test,
    target_os = "linux",
    any(feature = "x11", feature = "x11-minimal")
))]
mod style_tests;

#[cfg(all(
    test,
    target_os = "linux",
    any(feature = "x11", feature = "x11-minimal")
))]
mod inspector_tests;

#[cfg(all(
    test,
    target_os = "linux",
    any(feature = "x11", feature = "x11-minimal")
))]
mod property_action_tests;
