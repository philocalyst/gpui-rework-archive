//! Owned two-phase hardware initialization. Only native-surface negotiation runs
//! on the event-loop thread. Dropping this receiver cancels admission; workers
//! never own a window, view, source, presentation token, or CPU surface.
use super::{DeviceErrors, GpuSurface, NativeWindow, Renderer, Wake, wgpu};
use std::{
    panic::{AssertUnwindSafe, catch_unwind},
    sync::{
        Arc,
        mpsc::{self, Receiver, SyncSender, TryRecvError},
    },
    thread::{self, JoinHandle},
};

const BACKENDS: wgpu::Backends = wgpu::Backends::VULKAN
    .union(wgpu::Backends::METAL)
    .union(wgpu::Backends::DX12);

#[derive(Clone, Copy, Default)]
pub(super) struct Policy {
    // Only the real native integration test may exercise handoff on llvmpipe.
    #[cfg(test)]
    pub(super) allow_cpu: bool,
    #[cfg(test)]
    pub(super) defer_renderer: bool,
    #[cfg(test)]
    pub(super) force_probe: bool,
}
impl Policy {
    /// Linux local-device hint only. Unknown/permission failures still probe;
    /// explicit GPU and the real software-GPU handoff test bypass this hint.
    pub(super) fn should_probe(self) -> bool {
        #[cfg(test)]
        if self.allow_cpu || self.force_probe {
            return true;
        }
        #[cfg(target_os = "linux")]
        {
            linux_device_hint()
        }
        #[cfg(not(target_os = "linux"))]
        {
            true
        }
    }
    fn accepts(self, kind: wgpu::DeviceType) -> bool {
        if kind != wgpu::DeviceType::Cpu {
            return true;
        }
        #[cfg(test)]
        {
            self.allow_cpu
        }
        #[cfg(not(test))]
        {
            false
        }
    }
}

// A render node (or Nvidia/WSL device) is the normal unprivileged hardware
// path on Linux. This deliberately does not claim to detect remote/custom ICDs;
// such deployments can select explicit Gpu. Reevaluate on each resume.
#[cfg(target_os = "linux")]
fn linux_device_hint() -> bool {
    use std::{io::ErrorKind, path::Path};
    for node in ["/dev/nvidiactl", "/dev/dxg"] {
        match Path::new(node).metadata() {
            Ok(_) => return true,
            Err(error) if error.kind() == ErrorKind::NotFound => {}
            Err(_) => return true,
        }
    }
    match std::fs::read_dir("/dev/dri") {
        Ok(entries) => entries.into_iter().any(|entry| match entry {
            Ok(entry) => entry
                .file_name()
                .to_str()
                .is_none_or(|name| name.starts_with("renderD")),
            Err(_) => true,
        }),
        Err(error) => error.kind() != ErrorKind::NotFound,
    }
}

struct Request {
    adapter: wgpu::Adapter,
    format: wgpu::TextureFormat,
}
enum Message {
    Adapter {
        instance: wgpu::Instance,
        adapter: wgpu::Adapter,
    },
    Renderer(Box<Renderer>),
    Unavailable(String),
}
struct Surface {
    instance: wgpu::Instance,
    handle: wgpu::Surface<'static>,
    format: wgpu::TextureFormat,
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
    request: Option<SyncSender<Request>>,
    surface: Option<Surface>,
    // Dropping a JoinHandle detaches; cancellation never joins on the UI thread.
    _worker: JoinHandle<()>,
    #[cfg(test)]
    defer_renderer: bool,
    #[cfg(test)]
    deferred: Option<Request>,
}
impl Upgrade {
    pub(super) fn start(policy: Policy, wake: Option<Wake>) -> std::io::Result<Self> {
        let (send, messages) = mpsc::sync_channel(1);
        let (request, receive) = mpsc::sync_channel::<Request>(1);
        let worker = thread::Builder::new()
            .name("gpui-hardware-init".into())
            .spawn(move || {
                let result = catch_unwind(AssertUnwindSafe(|| {
                    let instance = wgpu::Instance::new(wgpu::InstanceDescriptor {
                        backends: BACKENDS,
                        ..wgpu::InstanceDescriptor::new_without_display_handle()
                    });
                    let adapter = match pollster::block_on(instance.request_adapter(
                        &wgpu::RequestAdapterOptions {
                            power_preference: wgpu::PowerPreference::HighPerformance,
                            compatible_surface: None,
                            force_fallback_adapter: false,
                        },
                    )) {
                        Ok(adapter) => adapter,
                        Err(error) => {
                            deliver(&send, Message::Unavailable(error.to_string()), &wake);
                            return;
                        }
                    };
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
                    if !deliver(&send, Message::Adapter { instance, adapter }, &wake) {
                        return;
                    }
                    let Ok(Request { adapter, format }) = receive.recv() else {
                        return;
                    };
                    let message = match pollster::block_on(Renderer::request(&adapter, format)) {
                        Ok(renderer) => Message::Renderer(Box::new(renderer)),
                        Err(error) => Message::Unavailable(error.to_string()),
                    };
                    deliver(&send, message, &wake);
                }));
                if result.is_err() {
                    deliver(
                        &send,
                        Message::Unavailable("hardware initialization panicked".into()),
                        &wake,
                    );
                }
            })?;
        Ok(Self {
            messages,
            request: Some(request),
            surface: None,
            _worker: worker,
            #[cfg(test)]
            defer_renderer: policy.defer_renderer,
            #[cfg(test)]
            deferred: None,
        })
    }
    // Deterministically mutate a real native owner before allowing real device
    // and pipeline initialization. No renderer or presentation is mocked.
    #[cfg(test)]
    pub(super) fn release_renderer(&mut self) {
        self.defer_renderer = false;
        if let Some(value) = self.deferred.take()
            && let Some(request) = self.request.take()
        {
            let _ = request.try_send(value);
        }
    }
    /// Called only from Redraw on the event-loop thread. Surface creation and
    /// capability negotiation happen here; device/pipeline compilation does not.
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
            Message::Adapter { instance, adapter } => {
                let handle = match instance.create_surface(Arc::clone(window)) {
                    Ok(handle) => handle,
                    Err(error) => return Progress::Unavailable(error.to_string()),
                };
                let caps = handle.get_capabilities(&adapter);
                let Some(format) = [
                    wgpu::TextureFormat::Bgra8UnormSrgb,
                    wgpu::TextureFormat::Rgba8UnormSrgb,
                ]
                .into_iter()
                .find(|format| caps.formats.contains(format)) else {
                    return Progress::Unavailable("no supported sRGB surface".into());
                };
                if !caps.alpha_modes.contains(&wgpu::CompositeAlphaMode::Opaque) {
                    return Progress::Unavailable("no opaque surface mode".into());
                }
                self.surface = Some(Surface {
                    instance,
                    handle,
                    format,
                });
                let value = Request { adapter, format };
                #[cfg(test)]
                if self.defer_renderer {
                    self.deferred = Some(value);
                    return Progress::Pending;
                }
                let Some(request) = self.request.take() else {
                    return Progress::Unavailable("duplicate adapter result".into());
                };
                if request.try_send(value).is_err() {
                    return Progress::Unavailable("initializer cancelled".into());
                }
                Progress::Pending
            }
            Message::Renderer(renderer) => {
                let Some(surface) = self.surface.take() else {
                    return Progress::Unavailable("renderer without surface negotiation".into());
                };
                let errors = DeviceErrors::install(renderer.device(), wake);
                let size = window.inner_size();
                Progress::Ready(Ready {
                    instance: surface.instance,
                    gpu: Box::new(GpuSurface {
                        handle: surface.handle,
                        renderer: *renderer,
                        errors,
                        config: super::surface_config(
                            [size.width.max(1), size.height.max(1)],
                            surface.format,
                        ),
                    }),
                })
            }
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
    fn production_policy_rejects_cpu_before_renderer_phase_and_excludes_gl() {
        assert!(!Policy::default().accepts(wgpu::DeviceType::Cpu));
        assert!(Policy::default().accepts(wgpu::DeviceType::DiscreteGpu));
        assert!(Policy::default().accepts(wgpu::DeviceType::IntegratedGpu));
        assert!(!BACKENDS.contains(wgpu::Backends::GL));
        assert!(
            Policy {
                allow_cpu: true,
                ..Default::default()
            }
            .accepts(wgpu::DeviceType::Cpu)
        );
    }
}
