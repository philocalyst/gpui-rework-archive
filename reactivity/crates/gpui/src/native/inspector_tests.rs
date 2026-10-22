//! Retained inspector controls drive the actual native owner's ordinary input.
use super::*;
use crate::{El, column, div, rgb};
use winit::{
    dpi::PhysicalPosition,
    event::DeviceId,
    event_loop::ControlFlow,
    platform::{run_on_demand::EventLoopExtRunOnDemand, x11::EventLoopBuilderExtX11},
};
struct App;
impl View for App {
    fn view(&self) -> El<'_> {
        column((div().w(80).h(60).bg(rgb(0x123456)).name("native card"),))
    }
}
struct Script {
    host: NativeHost<App>,
    stage: u8,
    deadline: Instant,
    minimum_frames: u64,
    complete: bool,
}
impl Script {
    fn click(&mut self, event_loop: &ActiveEventLoop, point: crate::Point) {
        let device_id = DeviceId::dummy();
        self.host
            .window_event(
                event_loop,
                &WindowEvent::CursorMoved {
                    device_id,
                    position: PhysicalPosition::new(f64::from(point.x), f64::from(point.y)),
                },
            )
            .unwrap();
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
        self.minimum_frames = self.host.presented_frames + 1;
        self.host.request_redraw();
    }
    fn control(&mut self, event_loop: &ActiveEventLoop, name: &str) {
        let owner = self.host.owner.as_ref().unwrap();
        let bounds = owner.bounds(owner.button(name)).unwrap();
        self.click(
            event_loop,
            crate::Point {
                x: bounds.x + 10.0,
                y: bounds.y + 10.0,
            },
        );
    }
    fn step(&mut self, event_loop: &ActiveEventLoop) {
        assert!(
            Instant::now() < self.deadline,
            "native inspector deadline stage {}",
            self.stage
        );
        let Some(owner) = self.host.owner.as_mut() else {
            return;
        };
        let sheet = owner.snapshot().unwrap();
        if !sheet.presentation_valid
            || sheet.prepared_epoch.is_some()
            || sheet.source_epoch != sheet.presentation_epoch
            || self.host.presented_frames < self.minimum_frames
        {
            return;
        }
        assert!(self.host.instance.is_none());
        match self.stage {
            0 => {
                owner.reset_counters().unwrap();
                for label in [
                    "Width +20",
                    "Auto",
                    "Inherit width",
                    "Set tint",
                    "Inherit tint",
                    "Select parent",
                ] {
                    self.control(event_loop, label);
                }
                let owner = self.host.owner.as_ref().unwrap();
                assert_eq!(owner.inspector_selected().unwrap(), None);
                assert_eq!(owner.counters().source_operations, 0);
                self.control(event_loop, "Pick element");
            }
            1 => self.click(event_loop, crate::Point { x: 20.0, y: 20.0 }),
            2 => {
                let card = owner.query().name("native card").one().unwrap();
                assert_eq!(owner.inspector_selected().unwrap(), Some(card));
                self.control(event_loop, "Width +20");
            }
            3 => {
                let card = owner.inspector_selected().unwrap().unwrap();
                assert_eq!(
                    owner.property(card, crate::property::WIDTH).unwrap(),
                    Some(100.0)
                );
                self.control(event_loop, "Set tint");
            }
            4 => self.control(event_loop, "Inherit width"),
            5 => {
                let card = owner.inspector_selected().unwrap().unwrap();
                assert_eq!(
                    owner.property(card, crate::property::WIDTH).unwrap(),
                    Some(80.0)
                );
                assert_eq!(
                    owner.property(card, crate::property::BACKGROUND).unwrap(),
                    rgb(0x0d9488)
                );
                assert_eq!(owner.counters().owner_reruns, 0);
                assert_eq!(owner.counters().descriptions, 0);
                let Some(Graphics::ReferenceCpu(surface, _)) = &mut self.host.graphics else {
                    unreachable!()
                };
                let pixels = surface.fetch().unwrap();
                assert_eq!(
                    pixels[20 * 800 + 20],
                    0x0d9488,
                    "native application pixels reflect inspector tint"
                );
                assert_eq!(
                    pixels[540 * 800 + 780],
                    0x0f172a,
                    "panel is independently retained and painted"
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
        let waiting = matches!(callback, Callback::AboutToWait);
        self.host.dispatch(event_loop, callback);
        assert!(self.host.error.is_none(), "{:?}", self.host.error);
        if waiting {
            self.step(event_loop);
            event_loop.set_control_flow(ControlFlow::WaitUntil(self.deadline));
        }
    }
}
#[test]
#[ignore = "requires X11 native presentation and server pixel fetch"]
fn native_inspector_picks_and_edits_actual_application_without_owner_rerun() {
    let mut event_loop = EventLoop::builder()
        .with_x11()
        .with_any_thread(true)
        .build()
        .unwrap();
    let script = Script {
        host: NativeHost::new(
            Window::document(App)
                .size(800, 560)
                .inspector()
                .renderer(RendererPolicy::ReferenceCpu),
        ),
        stage: 0,
        deadline: Instant::now() + Duration::from_secs(20),
        minimum_frames: 1,
        complete: false,
    };
    let (mut driver, wake) = Driver::new(&event_loop, script);
    driver.host_mut().host.wake = Some(wake);
    event_loop.run_app_on_demand(&mut driver).unwrap();
    assert!(driver.host().complete);
}
