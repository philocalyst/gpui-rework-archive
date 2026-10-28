//! Real X11 presenter proof over an ordinary public scroll-pane component.
use super::*;
use crate::{Action, PresentationToken, Role, ScrollOffset};
use std::time::{Duration, Instant};
use winit::{
    dpi::{PhysicalPosition, PhysicalSize},
    event::{DeviceId, TouchPhase},
    event_loop::ControlFlow,
    platform::x11::EventLoopBuilderExtX11,
};
#[path = "../../examples/support/panes.rs"]
mod panes;
use panes::Panes;

struct Script {
    host: NativeHost<Panes>,
    deadline: Instant,
    stage: u8,
    frames: u64,
    token: Option<PresentationToken>,
    viewport: Option<Target>,
    last: Option<Target>,
    complete: bool,
}
impl Script {
    fn event(&mut self, event_loop: &ActiveEventLoop, event: WindowEvent) {
        let id = self.host.window.as_ref().unwrap().id();
        self.host
            .dispatch(event_loop, Callback::Window { id, event: &event });
        assert!(self.host.error.is_none(), "{:?}", self.host.error);
    }
    fn queue(&mut self) {
        let owner = self.host.owner.as_ref().unwrap();
        assert!(owner.snapshot().unwrap().prepared_epoch.is_some());
        self.token = Some(owner.with_scene(|_, token| token).unwrap());
        self.frames = self.host.presented_frames + 1;
        self.host.request_redraw();
    }
    fn oracle(&mut self) {
        let owner = self.host.owner.as_mut().unwrap();
        let size = owner.snapshot().unwrap().size;
        let mut expected = vec![0; size[0] as usize * size[1] as usize];
        owner.render_bgrx(&mut expected).unwrap();
        let Some(Graphics::ReferenceCpu(surface, _)) = &mut self.host.graphics else {
            panic!("explicit CPU presenter")
        };
        assert_eq!(
            surface.fetch().unwrap(),
            expected,
            "complete native pixels stage{}",
            self.stage
        );
    }
    fn step(&mut self, event_loop: &ActiveEventLoop) {
        assert!(
            Instant::now() < self.deadline,
            "scroll proof deadline stage{}",
            self.stage
        );
        let Some(owner) = self.host.owner.as_ref() else {
            return;
        };
        let snapshot = owner.snapshot().unwrap();
        if self.host.presented_frames < self.frames
            || !snapshot.presentation_valid
            || snapshot.prepared_epoch.is_some()
        {
            return;
        }
        if let Some(token) = self.token {
            assert_eq!(owner.with_scene(|_, token| token).unwrap(), token);
        }
        assert!(self.host.instance.is_none());
        assert!(self.host.upgrade.is_none());
        self.oracle();
        match self.stage {
            0 => {
                let owner = self.host.owner.as_ref().unwrap();
                let viewport = owner.role(Role::ScrollView).one().unwrap();
                let last = owner.button("Record 31");
                self.viewport = Some(viewport);
                self.last = Some(last);
                assert!(owner.bounds(last).unwrap().is_empty());
                let bounds = owner.bounds(viewport).unwrap();
                self.event(
                    event_loop,
                    WindowEvent::CursorMoved {
                        device_id: DeviceId::dummy(),
                        position: PhysicalPosition::new(
                            f64::from(bounds.x + 10.0),
                            f64::from(bounds.y + 10.0),
                        ),
                    },
                );
                self.event(
                    event_loop,
                    WindowEvent::MouseWheel {
                        device_id: DeviceId::dummy(),
                        delta: MouseScrollDelta::LineDelta(-1.0, -1.0),
                        phase: TouchPhase::Moved,
                    },
                );
                assert_eq!(
                    self.host
                        .owner
                        .as_ref()
                        .unwrap()
                        .viewport(viewport)
                        .unwrap()
                        .offset,
                    ScrollOffset::default(),
                    "P stays frozen before OS submit"
                );
                self.queue();
            }
            1 => {
                let owner = self.host.owner.as_ref().unwrap();
                assert_eq!(
                    owner.viewport(self.viewport.unwrap()).unwrap().offset,
                    ScrollOffset { x: 32.0, y: 32.0 }
                );
                let scale = self.host.window.as_ref().unwrap().scale_factor();
                self.event(
                    event_loop,
                    WindowEvent::MouseWheel {
                        device_id: DeviceId::dummy(),
                        delta: MouseScrollDelta::PixelDelta(PhysicalPosition::new(
                            -8.0 * scale,
                            -16.0 * scale,
                        )),
                        phase: TouchPhase::Moved,
                    },
                );
                self.queue();
            }
            2 => {
                let owner = self.host.owner.as_mut().unwrap();
                assert_eq!(
                    owner.viewport(self.viewport.unwrap()).unwrap().offset,
                    ScrollOffset { x: 40.0, y: 48.0 }
                );
                assert_eq!(snapshot.source_epoch, 0);
                owner
                    .perform(self.last.unwrap(), Action::ScrollIntoView)
                    .unwrap();
                self.queue();
            }
            3 => {
                let owner = self.host.owner.as_ref().unwrap();
                assert_eq!(
                    owner.viewport(self.viewport.unwrap()).unwrap().offset.y,
                    928.0
                );
                let bounds = owner.bounds(self.last.unwrap()).unwrap();
                assert!(!bounds.is_empty());
                self.event(
                    event_loop,
                    WindowEvent::CursorMoved {
                        device_id: DeviceId::dummy(),
                        position: PhysicalPosition::new(
                            f64::from(bounds.x + bounds.width / 2.0),
                            f64::from(bounds.y + bounds.height / 2.0),
                        ),
                    },
                );
                for state in [ElementState::Pressed, ElementState::Released] {
                    self.event(
                        event_loop,
                        WindowEvent::MouseInput {
                            device_id: DeviceId::dummy(),
                            state,
                            button: MouseButton::Left,
                        },
                    );
                }
                self.queue();
            }
            4 => {
                assert_eq!(snapshot.source_epoch, 1);
                assert_eq!(
                    self.host.owner.as_ref().unwrap().root().unwrap().selected,
                    Some(31)
                );
                self.host
                    .window
                    .as_ref()
                    .unwrap()
                    .request_inner_size(PhysicalSize::new(240, 180))
                    .unwrap_or_default();
                self.event(
                    event_loop,
                    WindowEvent::Resized(PhysicalSize::new(240, 180)),
                );
                self.queue();
            }
            5 => {
                self.host.dispatch(event_loop, Callback::Suspended);
                assert_eq!(
                    self.host
                        .owner
                        .as_ref()
                        .unwrap()
                        .viewport(self.viewport.unwrap()),
                    Err(Error::PresentationStale)
                );
                self.host.dispatch(event_loop, Callback::Resumed);
                assert!(self.host.error.is_none(), "{:?}", self.host.error);
                self.frames = self.host.presented_frames + 1;
            }
            6 => {
                assert_eq!(snapshot.source_epoch, 1);
                assert_eq!(
                    self.host.owner.as_ref().unwrap().button("Record 31"),
                    self.last.unwrap()
                );
                assert!(
                    self.host
                        .owner
                        .as_ref()
                        .unwrap()
                        .contains_text("Selected Some(31)")
                        .unwrap()
                );
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
        let step = matches!(callback, Callback::AboutToWait);
        self.host.dispatch(event_loop, callback);
        assert!(self.host.error.is_none(), "{:?}", self.host.error);
        if step {
            self.step(event_loop);
            event_loop.set_control_flow(ControlFlow::WaitUntil(self.deadline));
        }
    }
}
#[test]
#[ignore = "requires real X11; actual wheel, activation, resize/resume and complete server pixel oracle"]
fn native_ordinary_scroll_wheel_reveal_pointer_resize_resume() {
    let event_loop = EventLoop::builder()
        .with_x11()
        .with_any_thread(true)
        .build()
        .unwrap();
    let script = Script {
        host: NativeHost::new(
            Window::document(Panes { selected: None })
                .size(320, 240)
                .renderer(RendererPolicy::ReferenceCpu),
        ),
        deadline: Instant::now() + Duration::from_secs(30),
        stage: 0,
        frames: 1,
        token: None,
        viewport: None,
        last: None,
        complete: false,
    };
    let (mut driver, wake) = Driver::new(&event_loop, script);
    driver.host_mut().host.wake = Some(wake);
    event_loop.run_app(&mut driver).unwrap();
    assert!(driver.host().complete);
    assert_eq!(driver.host().stage, 7);
}
