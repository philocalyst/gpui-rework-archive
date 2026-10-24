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
        column((
            div().w(80).h(60).bg(rgb(0x123456)).name("native card"),
            div()
                .w(80)
                .h(60)
                .bg(rgb(0x405060))
                .name("second native card"),
        ))
    }
}
struct Script {
    host: NativeHost<App>,
    stage: u8,
    deadline: Instant,
    minimum_frames: u64,
    complete: bool,
    rejected_epoch: u64,
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
    fn control(&mut self, event_loop: &ActiveEventLoop, name: &str) -> bool {
        let owner = self.host.owner.as_mut().unwrap();
        let panel = owner
            .role(crate::Role::ScrollView)
            .name("GPUI Inspector")
            .one()
            .unwrap();
        let target = owner.query().name(name).within(panel).one().unwrap();
        owner.scroll_into_view(target).unwrap();
        if owner.inspect().unwrap().prepared_epoch.is_some() {
            self.minimum_frames = self.host.presented_frames + 1;
            self.host.request_redraw();
            return false;
        }
        let bounds = owner.bounds(target).unwrap();
        assert!(!bounds.is_empty());
        self.click(
            event_loop,
            crate::Point {
                x: bounds.x + bounds.width / 2.,
                y: bounds.y + bounds.height / 2.,
            },
        );
        true
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
                assert_eq!(owner.inspector_selected().unwrap(), None);
                assert_eq!(owner.counters().source_operations, 0);
                if !self.control(event_loop, "Pick element") {
                    return;
                }
            }
            1 => self.click(event_loop, crate::Point { x: 20.0, y: 20.0 }),
            2 => {
                let card = owner.query().name("native card").one().unwrap();
                assert_eq!(owner.inspector_selected().unwrap(), Some(card));
                if !self.control(event_loop, "Increase") {
                    return;
                }
            }
            3 => {
                let card = owner.inspector_selected().unwrap().unwrap();
                assert_eq!(
                    owner.property(card, crate::property::WIDTH).unwrap(),
                    Some(81.0)
                );
                if !self.control(event_loop, "background") {
                    return;
                }
            }
            4 => {
                if !self.control(event_loop, "Increase") {
                    return;
                }
            }
            5 => {
                if !self.control(event_loop, "width") {
                    return;
                }
            }
            6 => {
                if !self.control(event_loop, "Inherit") {
                    return;
                }
            }
            7 => {
                let card = owner.inspector_selected().unwrap().unwrap();
                assert_eq!(
                    owner.property(card, crate::property::WIDTH).unwrap(),
                    Some(80.0)
                );
                assert_eq!(
                    owner
                        .property(card, crate::property::BACKGROUND)
                        .unwrap()
                        .solid()
                        .unwrap(),
                    crate::Color::srgb(18. / 255. + 0.05, 52. / 255., 86. / 255., 1.).unwrap()
                );
                assert_eq!(owner.counters().owner_reruns, 0);
                assert_eq!(owner.counters().descriptions, 0);
                let Some(Graphics::ReferenceCpu(surface, _)) = &mut self.host.graphics else {
                    unreachable!()
                };
                let pixels = surface.fetch().unwrap();
                assert_eq!(
                    pixels[20 * 800 + 20],
                    0x1f3456,
                    "native application pixels reflect the actual sRGB channel step"
                );
                assert_eq!(
                    pixels[540 * 800 + 780],
                    0x0f172a,
                    "panel is independently retained and painted"
                );
                if !self.control(event_loop, "corner_radius") {
                    return;
                }
            }
            8 => {
                if !self.control(event_loop, "Increase") {
                    return;
                }
            }
            9 => {
                let card = owner.inspector_selected().unwrap().unwrap();
                assert_eq!(
                    owner
                        .property(card, crate::property::CORNER_RADIUS)
                        .unwrap(),
                    1.
                );
                let Some(Graphics::ReferenceCpu(surface, _)) = &mut self.host.graphics else {
                    unreachable!()
                };
                let pixels = surface.fetch().unwrap();
                assert_ne!(
                    pixels[0], 0x1f3456,
                    "rounded native corner has partial coverage"
                );
                assert_eq!(pixels[801], 0x1f3456);
                if !self.control(event_loop, "transform") {
                    return;
                }
            }
            10..=13 => {
                if !self.control(event_loop, "Component") {
                    return;
                }
            }
            14 => {
                if !self.control(event_loop, "Increase") {
                    return;
                }
            }
            15 => {
                let card = owner.inspector_selected().unwrap().unwrap();
                assert_eq!(
                    owner.property(card, crate::property::TRANSFORM).unwrap().tx,
                    1.
                );
                let Some(Graphics::ReferenceCpu(surface, _)) = &mut self.host.graphics else {
                    unreachable!()
                };
                let pixels = surface.fetch().unwrap();
                assert_ne!(pixels[20 * 800], 0x1f3456);
                assert_eq!(pixels[20 * 800 + 1], 0x1f3456);
                if !self.control(event_loop, "gap") {
                    return;
                }
            }
            16 => {
                self.rejected_epoch = owner.inspect().unwrap().source_epoch;
                if !self.control(event_loop, "Decrease") {
                    return;
                }
            }
            17 => {
                assert_eq!(owner.inspect().unwrap().source_epoch, self.rejected_epoch);
                assert!(
                    owner
                        .contains_text("Last edit rejected: Property(Negative)")
                        .unwrap()
                );
                if !self.control(event_loop, "Increase") {
                    return;
                }
            }
            18 => {
                if !self.control(event_loop, "Pick element") {
                    return;
                }
            }
            19 => {
                let card = owner.query().name("native card").one().unwrap();
                owner
                    .set_property(
                        card,
                        crate::property::WIDTH,
                        crate::property::Contribution::Set(crate::Length::Points(90.)),
                    )
                    .unwrap();
                // An actual physical click during pending C cannot re-pick P.
                self.click(event_loop, crate::Point { x: 20., y: 80. });
                assert_eq!(
                    self.host
                        .owner
                        .as_ref()
                        .unwrap()
                        .inspector_selected()
                        .unwrap(),
                    Some(card)
                );
            }
            20 => self.click(event_loop, crate::Point { x: 20., y: 80. }),
            21 => {
                let second = owner.query().name("second native card").one().unwrap();
                assert_eq!(owner.inspector_selected().unwrap(), Some(second));
                assert_eq!(owner.counters().owner_reruns, 0);
                assert_eq!(owner.counters().descriptions, 0);
                eprintln!(
                    "NATIVE_CATALOG: pick, scroll/ACK, width Set/Inherit, sRGB channel pixel, radius corner pixel, tx pixel, rejected negative step + recovery, stale-P ignored/re-pick"
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
        rejected_epoch: 0,
    };
    let (mut driver, wake) = Driver::new(&event_loop, script);
    driver.host_mut().host.wake = Some(wake);
    event_loop.run_app_on_demand(&mut driver).unwrap();
    assert!(driver.host().complete);
}
