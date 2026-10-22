//! Real X11 target proof, rejection and pending-worker close lifecycle.
use super::*;
use crate::{El, button};
use std::sync::{
    Weak,
    atomic::{AtomicBool, Ordering},
    mpsc::SyncSender,
};
use wgpu::rwh::HasWindowHandle;
use winit::platform::{run_on_demand::EventLoopExtRunOnDemand, x11::EventLoopBuilderExtX11};
use x11rb::protocol::xproto::{ConnectionExt, MapState};

struct Document(Arc<AtomicBool>);
impl Drop for Document {
    fn drop(&mut self) {
        self.0.store(true, Ordering::Release);
    }
}
impl View for Document {
    fn view(&self) -> El<'_> {
        button("CPU frame remains live").on_click(|_: &mut Self| {})
    }
}
struct Script {
    host: NativeHost<Document>,
    expected: Option<&'static str>,
    close: bool,
    direct_drop: bool,
    model_dropped: Arc<AtomicBool>,
    initialization: Option<Arc<upgrade::Initialization>>,
    hold: Option<SyncSender<()>>,
    lease: Option<Weak<NativeWindow>>,
    xid: Option<u32>,
    checked: bool,
    deadline: Instant,
}
impl Host for Script {
    fn dispatch(&mut self, event_loop: &ActiveEventLoop, callback: Callback<'_>) {
        let idle = matches!(callback, Callback::AboutToWait);
        self.host.dispatch(event_loop, callback);
        assert!(self.host.error.is_none(), "{:?}", self.host.error);
        if self.initialization.is_none()
            && let Some(upgrade) = &self.host.upgrade
        {
            self.initialization = Some(upgrade.initialization());
            if self.close {
                self.hold = Some(upgrade.hold_renderer());
            }
        }
        if !idle || self.checked {
            return;
        }
        assert!(
            Instant::now() < self.deadline,
            "target proof/close deadline"
        );
        event_loop.set_control_flow(winit::event_loop::ControlFlow::WaitUntil(
            Instant::now() + Duration::from_millis(10),
        ));
        let owner = self.host.owner.as_mut().unwrap();
        if !owner.snapshot().unwrap().presentation_valid {
            return;
        }
        assert!(self.host.presented_frames > 0);
        assert!(matches!(
            self.host.graphics,
            Some(Graphics::ReferenceCpu(..))
        ));
        if self.close {
            let Some(initialization) = &self.initialization else {
                return;
            };
            if !initialization.proved() || !initialization.waiting_for_renderer() {
                return;
            }
            assert!(!initialization.renderer_started());
            let target = owner.find_button("CPU frame remains live").unwrap();
            owner.activate(target).unwrap();
            let window = self.host.window.as_ref().unwrap();
            self.lease = Some(Arc::downgrade(window));
            let wgpu::rwh::RawWindowHandle::Xlib(raw) = window.window_handle().unwrap().as_raw()
            else {
                panic!("X11 target")
            };
            self.xid = Some(raw.window.try_into().unwrap());
            // The external gate keeps the real proved Surface/Arc alive after
            // cancellation. This call must retire UI authority without joining.
            if self.direct_drop {
                // Replace only the test holder; the actual initialized host is
                // dropped directly, without dispatching Exiting/CloseRequested.
                let retired = std::mem::replace(
                    &mut self.host,
                    NativeHost::new(Window::document(Document(Arc::new(AtomicBool::new(false))))),
                );
                drop(retired);
                event_loop.exit();
            } else {
                self.host
                    .window_event(event_loop, &WindowEvent::CloseRequested)
                    .unwrap();
                assert!(self.host.window.is_none());
                assert!(self.host.upgrade.is_none());
                assert!(self.host.graphics.is_none());
                let owner = self.host.owner.as_mut().unwrap();
                assert!(owner.is_closed());
                assert!(matches!(owner.activate(target), Err(Error::Closed)));
            }
            assert!(self.model_dropped.load(Ordering::Acquire));
            assert!(!initialization.renderer_started());
            self.checked = true;
        } else if self.host.upgrade_rejection.as_deref() == self.expected {
            if let Some(initialization) = &self.initialization {
                assert!(
                    !initialization.renderer_started(),
                    "rejected target compiled a Renderer"
                );
            } else {
                assert_eq!(self.expected, Some("no automatic presentation candidate"));
                assert!(
                    self.host.upgrade.is_none(),
                    "cheap rejection started a worker"
                );
            }
            assert!(self.host.instance.is_none());
            self.checked = true;
            event_loop.exit();
        }
    }
}

#[test]
#[ignore = "requires private X11 and Mesa CPU Vulkan, with no local render-node hint"]
fn automatic_target_rejects_before_renderer_and_close_unmaps_a_worker_retained_window() {
    let mut event_loop = EventLoop::builder()
        .with_x11()
        .with_any_thread(true)
        .build()
        .unwrap();
    let normal = upgrade::requirements();
    let mut cases = vec![
        (
            "no-hint",
            upgrade::Policy::default(),
            Some("no automatic presentation candidate"),
            false,
        ),
        (
            "CPU adapter",
            upgrade::Policy {
                force_probe: true,
                ..Default::default()
            },
            Some("CPU-only adapter"),
            false,
        ),
    ];
    for (name, required, reason) in [
        (
            "format",
            wgpu::presentation::PresentationRequirements {
                format: wgpu::TextureFormat::Depth32Float,
                ..normal
            },
            "prepared surface format unsupported",
        ),
        (
            "color-space",
            wgpu::presentation::PresentationRequirements {
                color_space: wgpu::SurfaceColorSpace::DisplayP3,
                ..normal
            },
            "prepared surface color space unsupported",
        ),
        (
            "alpha",
            wgpu::presentation::PresentationRequirements {
                alpha_mode: wgpu::CompositeAlphaMode::Auto,
                ..normal
            },
            "prepared surface alpha mode unsupported",
        ),
        (
            "FIFO proof",
            wgpu::presentation::PresentationRequirements {
                present_mode: wgpu::PresentMode::AutoVsync,
                ..normal
            },
            "prepared surface present mode unsupported",
        ),
    ] {
        cases.push((
            name,
            upgrade::Policy {
                allow_cpu: true,
                force_probe: true,
                requirements: Some(required),
                ..Default::default()
            },
            Some(reason),
            false,
        ));
    }
    cases.push((
        "pending close",
        upgrade::Policy {
            allow_cpu: true,
            force_probe: true,
            defer_renderer: true,
            ..Default::default()
        },
        None,
        true,
    ));
    cases.push((
        "direct host drop",
        upgrade::Policy {
            allow_cpu: true,
            force_probe: true,
            defer_renderer: true,
            ..Default::default()
        },
        None,
        true,
    ));
    for (name, policy, expected, close) in cases {
        let model_dropped = Arc::new(AtomicBool::new(false));
        let mut host = NativeHost::new(
            Window::document(Document(Arc::clone(&model_dropped)))
                .size(320, 180)
                .renderer(RendererPolicy::Auto),
        );
        host.upgrade_policy = policy;
        let script = Script {
            host,
            expected,
            close,
            direct_drop: name == "direct host drop",
            model_dropped,
            initialization: None,
            hold: None,
            lease: None,
            xid: None,
            checked: false,
            deadline: Instant::now() + Duration::from_secs(20),
        };
        let (mut driver, wake) = Driver::new(&event_loop, script);
        driver.host_mut().host.wake = Some(wake);
        event_loop.run_app_on_demand(&mut driver).unwrap();
        assert!(driver.host().checked, "{name}");
        if close {
            let script = driver.host_mut();
            let lease = script.lease.as_ref().unwrap();
            assert!(
                lease.upgrade().is_some(),
                "actual target lease is still worker-owned"
            );
            let (connection, _) = x11rb::connect(None).unwrap();
            let deadline = Instant::now() + Duration::from_secs(5);
            loop {
                let state = connection
                    .get_window_attributes(script.xid.unwrap())
                    .unwrap()
                    .reply()
                    .unwrap()
                    .map_state;
                if state == MapState::UNMAPPED {
                    break;
                }
                assert!(
                    Instant::now() < deadline,
                    "closed worker-retained target stayed mapped"
                );
                std::thread::sleep(Duration::from_millis(1));
            }
            assert!(!script.initialization.as_ref().unwrap().renderer_started());
            script.hold.take().unwrap().send(()).unwrap();
            while lease.upgrade().is_some() {
                assert!(
                    Instant::now() < deadline,
                    "cancelled target lease was not released"
                );
                std::thread::sleep(Duration::from_millis(1));
            }
        }
        eprintln!("GPUI_AUTO_TARGET_GATE,{name},pass");
    }
}
