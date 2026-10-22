//! Actual native typing, pointer activation, error recovery and acknowledged pixels.
use super::*;
use crate::{
    TextSelection,
    property::{PropertyId, PropertyValue},
};
#[path = "../../examples/support/property_workbench.rs"]
mod property_workbench;
use property_workbench::Companion;
use winit::{
    dpi::PhysicalPosition,
    event::DeviceId,
    event_loop::ControlFlow,
    platform::{run_on_demand::EventLoopExtRunOnDemand, x11::EventLoopBuilderExtX11},
};
struct Script {
    host: NativeHost<Companion>,
    stage: u8,
    deadline: Instant,
    minimum_frames: u64,
    complete: bool,
    release: bool,
}
impl Script {
    fn enter(&mut self, value: &str) {
        let owner = self.host.owner.as_mut().unwrap();
        let input = owner.find_input().unwrap();
        let end = owner.root().unwrap().editor.draft.len();
        owner.focus(input).unwrap();
        owner
            .select(input, TextSelection::from_bytes(0, end).unwrap())
            .unwrap();
        self.host
            .key_input(&NativeKey::Character(value.into()), Some(value))
            .unwrap();
    }
    fn apply(&mut self, event_loop: &ActiveEventLoop) {
        let owner = self.host.owner.as_ref().unwrap();
        let bounds = owner.bounds(owner.button("Apply")).unwrap();
        self.host
            .window_event(
                event_loop,
                &WindowEvent::CursorMoved {
                    device_id: DeviceId::dummy(),
                    position: PhysicalPosition::new(
                        f64::from(bounds.x + bounds.width / 2.),
                        f64::from(bounds.y + bounds.height / 2.),
                    ),
                },
            )
            .unwrap();
        self.host
            .window_event(
                event_loop,
                &WindowEvent::MouseInput {
                    device_id: DeviceId::dummy(),
                    state: ElementState::Pressed,
                    button: MouseButton::Left,
                },
            )
            .unwrap();
        // Press can prepare caret blur. Release uses its acknowledged P; an
        // immediate release during pending C is intentionally rejected today.
        self.release = true;
    }
    fn step(&mut self, event_loop: &ActiveEventLoop) {
        assert!(
            Instant::now() < self.deadline,
            "property action stage {}",
            self.stage
        );
        let Some(owner) = self.host.owner.as_mut() else {
            return;
        };
        let sheet = owner.inspect().unwrap();
        if !sheet.presentation_valid
            || sheet.prepared_epoch.is_some()
            || sheet.source_epoch != sheet.presentation_epoch
            || self.host.presented_frames < self.minimum_frames
        {
            return;
        }
        if self.release {
            self.host
                .window_event(
                    event_loop,
                    &WindowEvent::MouseInput {
                        device_id: DeviceId::dummy(),
                        state: ElementState::Released,
                        button: MouseButton::Left,
                    },
                )
                .unwrap();
            self.release = false;
            self.minimum_frames = self.host.presented_frames + 1;
            self.host.request_redraw();
            return;
        }
        match self.stage {
            0 => {
                let target = owner.button("Library button");
                let value = owner.property_value(target, PropertyId::Width).unwrap();
                owner
                    .update(|m| m.editor.select(target, PropertyId::Width, value))
                    .unwrap();
            }
            1 => self.enter("NaN"),
            2 => self.apply(event_loop),
            3 => {
                assert!(
                    owner.root().unwrap().editor.status.contains("NonFinite"),
                    "draft={:?} status={:?}",
                    *owner.root().unwrap().editor.draft,
                    owner.root().unwrap().editor.status
                );
                let target = owner.button("Library button");
                assert_eq!(
                    owner.property_value(target, PropertyId::Width).unwrap(),
                    PropertyValue::Dimension(Some(120.))
                );
                self.enter("193.25");
            }
            4 => self.apply(event_loop),
            5 => {
                let target = owner.button("Library button");
                assert_eq!(
                    owner.property_value(target, PropertyId::Width).unwrap(),
                    PropertyValue::Dimension(Some(193.25))
                );
                assert_eq!(
                    owner.root().unwrap().editor.status,
                    "Logical contribution accepted"
                );
                let Some(Graphics::ReferenceCpu(surface, _)) = &mut self.host.graphics else {
                    unreachable!()
                };
                assert_eq!(surface.fetch().unwrap()[20 * 800 + 180], 0x123456);
                self.enter("bad syntax");
            }
            6 => self.apply(event_loop),
            7 => {
                assert_eq!(&**owner.root().unwrap().editor.draft, "bad syntax");
                assert!(owner.contains_text("Expected a number").unwrap());
                self.enter("211.75");
            }
            8 => self.apply(event_loop),
            9 => {
                let target = owner.button("Library button");
                assert_eq!(
                    owner.property_value(target, PropertyId::Width).unwrap(),
                    PropertyValue::Dimension(Some(211.75))
                );
                owner.update(|m| m.show_application = false).unwrap();
            }
            10 => self.apply(event_loop),
            11 => {
                assert!(owner.root().unwrap().editor.status.contains("StaleTarget"));
                eprintln!(
                    "NATIVE_PROPERTY_ENTRY: typed draft, canonical rejection, syntax error, recovery, Apply pointer, server pixel, stale-target feedback, exact ACK"
                );
                self.complete = true;
                event_loop.exit();
                return;
            }
            _ => unreachable!(),
        }
        self.minimum_frames = self.host.presented_frames + 1;
        self.host.request_redraw();
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
fn native_contained_property_entry_recovers_and_reports_stale_targets() {
    let mut event_loop = EventLoop::builder()
        .with_x11()
        .with_any_thread(true)
        .build()
        .unwrap();
    let script = Script {
        host: NativeHost::new(
            Window::document(Companion::default())
                .size(800, 400)
                .renderer(RendererPolicy::ReferenceCpu),
        ),
        stage: 0,
        deadline: Instant::now() + Duration::from_secs(20),
        minimum_frames: 1,
        complete: false,
        release: false,
    };
    let (mut driver, wake) = Driver::new(&event_loop, script);
    driver.host_mut().host.wake = Some(wake);
    event_loop.run_app_on_demand(&mut driver).unwrap();
    assert!(driver.host().complete);
}
