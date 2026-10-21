//! Opt-in native proof over the public 250K Library model and real X11 submit.
use super::*;
use crate::{ItemKey, PresentationToken, Role, Snapshot};
use std::time::{Duration, Instant};
use winit::{
    dpi::{PhysicalPosition, PhysicalSize},
    event::{DeviceId, TouchPhase},
    event_loop::ControlFlow,
    platform::x11::EventLoopBuilderExtX11,
};

use super::test_library::{LIBRARY, Library, catalogue::TrackId};

fn play(owner: &Win<Library>, key: u64) -> Target {
    let row = owner
        .list_item(owner.list(LIBRARY).unwrap(), ItemKey::new(key))
        .unwrap();
    owner
        .role(Role::Button)
        .within(row)
        .text("Play")
        .one()
        .unwrap()
}

struct Script {
    host: NativeHost<Library>,
    deadline: Instant,
    stage: u8,
    complete: bool,
    minimum_frames: u64,
    expected_token: Option<PresentationToken>,
    list: Option<Target>,
    overlap: Option<Target>,
    departed: Option<Target>,
}
impl Script {
    fn event(&mut self, event_loop: &ActiveEventLoop, event: WindowEvent) {
        let id = self.host.window.as_ref().unwrap().id();
        self.host
            .dispatch(event_loop, Callback::Window { id, event: &event });
        assert!(self.host.error.is_none(), "{:?}", self.host.error);
    }
    fn move_pointer(&mut self, event_loop: &ActiveEventLoop, bounds: crate::Rect) {
        self.event(
            event_loop,
            WindowEvent::CursorMoved {
                device_id: DeviceId::dummy(),
                position: PhysicalPosition::new(
                    f64::from(bounds.x + bounds.width * 0.5),
                    f64::from(bounds.y + bounds.height * 0.5),
                ),
            },
        );
    }
    fn queued(&mut self, previous: PresentationToken, source_epoch: u64) {
        let owner = self.host.owner.as_ref().unwrap();
        let sheet = owner.snapshot().unwrap();
        assert_eq!(sheet.source_epoch, source_epoch);
        assert!(
            sheet.prepared_epoch.is_some(),
            "input must await actual native acknowledgement"
        );
        assert_eq!(
            owner.list_state(self.list.unwrap()),
            Err(Error::PresentationStale)
        );
        let token = owner.with_scene(|_, token| token).unwrap();
        assert_ne!(token, previous);
        self.expected_token = Some(token);
        self.minimum_frames = self.host.presented_frames + 1;
    }
    fn ready(&self) -> Option<Snapshot> {
        let owner = self.host.owner.as_ref()?;
        let sheet = owner.snapshot().unwrap();
        if self.host.presented_frames < self.minimum_frames
            || !sheet.presentation_valid
            || sheet.prepared_epoch.is_some()
            || sheet.presentation_epoch != sheet.source_epoch
        {
            return None;
        }
        if let Some(expected) = self.expected_token {
            assert_eq!(owner.with_scene(|_, token| token).unwrap(), expected);
        }
        assert_eq!(self.host.renderer_policy, RendererPolicy::ReferenceCpu);
        assert!(matches!(
            self.host.graphics,
            Some(Graphics::ReferenceCpu(_))
        ));
        assert!(
            self.host.instance.is_none(),
            "ReferenceCpu must not initialize Wgpu"
        );
        assert!(
            self.host.upgrade.is_none(),
            "ReferenceCpu must not launch an initializer"
        );
        Some(sheet)
    }
    fn step(&mut self, event_loop: &ActiveEventLoop) {
        assert!(
            Instant::now() < self.deadline,
            "native Library timed out at stage {}",
            self.stage
        );
        let Some(sheet) = self.ready() else {
            return;
        };
        match self.stage {
            0 => {
                let owner = self.host.owner.as_ref().unwrap();
                assert_eq!(sheet.source_epoch, 0);
                assert_eq!(owner.root().unwrap().catalogue.len(), 250_000);
                let list = owner.list(LIBRARY).unwrap();
                assert_eq!(owner.list_state(list).unwrap().visible_range, 0..13);
                assert_eq!(owner.role(Role::Button).count().unwrap(), 15);
                self.list = Some(list);
                self.overlap = Some(play(owner, 2));
                self.departed = Some(play(owner, 0));
                let bounds = owner.bounds(self.overlap.unwrap()).unwrap();
                let previous = owner.with_scene(|_, token| token).unwrap();
                self.move_pointer(event_loop, bounds);
                self.event(
                    event_loop,
                    WindowEvent::MouseWheel {
                        device_id: DeviceId::dummy(),
                        delta: MouseScrollDelta::LineDelta(0.0, -1.0),
                        phase: TouchPhase::Moved,
                    },
                );
                self.queued(previous, 0);
            }
            1 => {
                let owner = self.host.owner.as_mut().unwrap();
                let state = owner.list_state(self.list.unwrap()).unwrap();
                assert_eq!((state.offset, state.visible_range), (32.0, 1..14));
                assert_eq!(sheet.source_epoch, 0);
                assert_eq!(play(owner, 2), self.overlap.unwrap());
                assert_eq!(
                    owner.bounds(self.departed.unwrap()),
                    Err(Error::StaleTarget)
                );
                assert_eq!(
                    owner.activate(self.departed.unwrap()),
                    Err(Error::StaleTarget)
                );
                let previous = owner.with_scene(|_, token| token).unwrap();
                let scale = self.host.window.as_ref().unwrap().scale_factor();
                self.event(
                    event_loop,
                    WindowEvent::MouseWheel {
                        device_id: DeviceId::dummy(),
                        delta: MouseScrollDelta::PixelDelta(PhysicalPosition::new(
                            0.0,
                            -16.5 * scale,
                        )),
                        phase: TouchPhase::Moved,
                    },
                );
                self.queued(previous, 0);
            }
            2 => {
                let owner = self.host.owner.as_ref().unwrap();
                let state = owner.list_state(self.list.unwrap()).unwrap();
                assert_eq!((state.offset, state.visible_range), (48.5, 1..15));
                assert_eq!(sheet.source_epoch, 0);
                assert_eq!(play(owner, 2), self.overlap.unwrap());
                let bounds = owner.bounds(self.overlap.unwrap()).unwrap();
                let previous = owner.with_scene(|_, token| token).unwrap();
                self.move_pointer(event_loop, bounds);
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
                self.queued(previous, 1);
            }
            3 => {
                let owner = self.host.owner.as_ref().unwrap();
                assert_eq!(sheet.source_epoch, 1);
                assert_eq!(
                    (
                        owner.root().unwrap().selected,
                        owner.root().unwrap().play_requests
                    ),
                    (Some(TrackId(2)), 1)
                );
                assert!(
                    owner
                        .contains_text("Selected recording 2; play requests 1")
                        .unwrap()
                );
                assert_eq!(play(owner, 2), self.overlap.unwrap());
                self.expected_token = None;
                self.minimum_frames = self.host.presented_frames + 1;
                let _ = self
                    .host
                    .window
                    .as_ref()
                    .unwrap()
                    .request_inner_size(PhysicalSize::new(700, 560));
            }
            4 => {
                if sheet.size != [700, 560] {
                    return;
                }
                let owner = self.host.owner.as_ref().unwrap();
                assert_eq!(sheet.source_epoch, 1);
                assert_eq!(owner.list_state(self.list.unwrap()).unwrap().offset, 48.5);
                assert_eq!(play(owner, 2), self.overlap.unwrap());
                self.minimum_frames = self.host.presented_frames + 1;
                self.host.dispatch(event_loop, Callback::Suspended);
                assert!(self.host.graphics.is_none());
                assert_eq!(
                    self.host
                        .owner
                        .as_ref()
                        .unwrap()
                        .hit_target(Point { x: 20.0, y: 150.0 }),
                    Err(Error::PresentationStale)
                );
                self.host.dispatch(event_loop, Callback::Resumed);
                assert!(self.host.error.is_none(), "{:?}", self.host.error);
            }
            5 => {
                let owner = self.host.owner.as_mut().unwrap();
                assert_eq!(sheet.size, [700, 560]);
                assert_eq!(sheet.source_epoch, 1);
                assert_eq!(play(owner, 2), self.overlap.unwrap());
                assert_eq!(
                    owner.bounds(self.departed.unwrap()),
                    Err(Error::StaleTarget)
                );
                assert_eq!(
                    (
                        owner.root().unwrap().selected,
                        owner.root().unwrap().play_requests
                    ),
                    (Some(TrackId(2)), 1)
                );
                assert!(
                    owner
                        .contains_text("Selected recording 2; play requests 1")
                        .unwrap()
                );
                let expected = owner
                    .with_pixels(|pixels, width, height| {
                        assert_eq!([width, height], [700, 560]);
                        pixels
                            .chunks_exact(4)
                            .map(|p| {
                                (u32::from(p[0]) << 16) | (u32::from(p[1]) << 8) | u32::from(p[2])
                            })
                            .collect::<Vec<_>>()
                    })
                    .unwrap();
                let Some(Graphics::ReferenceCpu(surface)) = &mut self.host.graphics else {
                    unreachable!();
                };
                let actual = surface.fetch().unwrap();
                assert_eq!(actual.len(), expected.len());
                if let Some((index, (actual, expected))) = actual
                    .iter()
                    .zip(&expected)
                    .enumerate()
                    .find(|(_, (actual, expected))| actual != expected)
                {
                    panic!("X11 pixel {index}: actual {actual:#08x}, expected {expected:#08x}");
                }
                assert_eq!(owner.counters().source_operations, 1);
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
            // One failure deadline, not a periodic poll/forced redraw engine.
            event_loop.set_control_flow(ControlFlow::WaitUntil(self.deadline));
        }
    }
}

#[test]
#[ignore = "requires a real X11 display; runs the actual CPU presenter, without a GPU"]
fn native_library_250k_wheel_pointer_resize_resume() {
    let event_loop = EventLoop::builder()
        .with_x11()
        .with_any_thread(true)
        .build()
        .unwrap();
    let script = Script {
        host: NativeHost::new(
            Window::document(Library::new(250_000))
                .size(760, 600)
                .renderer(RendererPolicy::ReferenceCpu),
        ),
        deadline: Instant::now() + Duration::from_secs(30),
        stage: 0,
        complete: false,
        minimum_frames: 1,
        expected_token: None,
        list: None,
        overlap: None,
        departed: None,
    };
    let (mut driver, wake) = Driver::new(&event_loop, script);
    driver.host_mut().host.wake = Some(wake);
    event_loop.run_app(&mut driver).unwrap();
    assert!(driver.host().complete);
    assert_eq!(driver.host().stage, 6);
    assert!(driver.host().host.presented_frames >= 6);
}
