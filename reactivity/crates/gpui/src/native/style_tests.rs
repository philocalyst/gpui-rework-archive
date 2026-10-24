//! Real native pointer delivery and acknowledgement for direct style ports.
use super::*;
use crate::{Color, El, FieldId, Signal, Source, Sources, button, column, div, rgb, text};
use winit::{
    dpi::PhysicalPosition,
    event::DeviceId,
    event_loop::ControlFlow,
    platform::{run_on_demand::EventLoopExtRunOnDemand, x11::EventLoopBuilderExtX11},
};
struct Panel {
    width: Signal<u32>,
    color: Signal<Color>,
}
impl Panel {
    const WIDTH: Source<Self, u32> =
        Source::new(FieldId::new(1), "width", |m| &m.width, |m| &mut m.width);
    const COLOR: Source<Self, Color> =
        Source::new(FieldId::new(2), "color", |m| &m.color, |m| &mut m.color);
}
impl View for Panel {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::WIDTH).direct(Self::COLOR)
    }
    fn view(&self) -> El<'_> {
        column((
            div()
                .name("preview")
                .w(&self.width)
                .h(32)
                .bg(&self.color)
                .rounded(6.0)
                .child(text(&self.width)),
            button("Resize").on_click(Self::WIDTH.update(|width| *width = 100)),
            button("Recolor").on_click(Self::COLOR.update(|color| *color = rgb(0x80c0ff))),
        ))
        .p(4)
        .gap(4)
    }
}
struct Script {
    host: NativeHost<Panel>,
    stage: u8,
    deadline: Instant,
    minimum_frames: u64,
    complete: bool,
}
impl Script {
    fn click(&mut self, event_loop: &ActiveEventLoop, label: &str) {
        let owner = self.host.owner.as_ref().unwrap();
        let bounds = owner.bounds(owner.button(label)).unwrap();
        let device_id = DeviceId::dummy();
        self.host
            .window_event(
                event_loop,
                &WindowEvent::CursorMoved {
                    device_id,
                    position: PhysicalPosition::new(
                        f64::from(bounds.x + bounds.width * 0.5),
                        f64::from(bounds.y + bounds.height * 0.5),
                    ),
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
        let sheet = self.host.owner.as_ref().unwrap().snapshot().unwrap();
        assert_eq!(sheet.source_epoch, sheet.presentation_epoch + 1);
        self.minimum_frames = self.host.presented_frames + 1;
        self.host.request_redraw();
    }
    fn step(&mut self, event_loop: &ActiveEventLoop) {
        assert!(
            Instant::now() < self.deadline,
            "native style deadline stage{}",
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
        assert!(
            self.host.instance.is_none(),
            "ReferenceCpu does not initialize Wgpu"
        );
        match self.stage {
            0 => {
                owner.reset_counters().unwrap();
                self.click(event_loop, "Resize");
            }
            1 => {
                assert_eq!(*owner.root().unwrap().width, 100);
                assert_eq!(owner.counters().owner_reruns, 0);
                let panel = owner.query().name("preview").one().unwrap();
                assert_eq!(
                    owner.property(panel, crate::property::WIDTH).unwrap(),
                    crate::Length::Points(100.0)
                );
                self.click(event_loop, "Recolor");
            }
            2 => {
                assert_eq!(*owner.root().unwrap().color, rgb(0x80c0ff));
                assert_eq!(owner.counters().owner_reruns, 0);
                assert_eq!(owner.counters().descriptions, 0);
                assert_eq!(owner.counters().source_reads, 2);
                let expected = owner
                    .with_pixels(|bytes, _, _| {
                        bytes
                            .as_chunks::<4>()
                            .0
                            .iter()
                            .map(|p| {
                                (u32::from(p[0]) << 16) | (u32::from(p[1]) << 8) | u32::from(p[2])
                            })
                            .collect::<Vec<_>>()
                    })
                    .unwrap();
                let Some(Graphics::ReferenceCpu(surface, _)) = &mut self.host.graphics else {
                    unreachable!()
                };
                assert_eq!(
                    surface.fetch().unwrap(),
                    expected,
                    "complete native server image"
                );
                assert!(expected.contains(&0x80c0ff));
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
#[ignore = "requires real X11 pointer events, native acknowledgements and server pixel fetch"]
fn native_reactive_dimensions_and_color_match_full_server_image() {
    let mut event_loop = EventLoop::builder()
        .with_x11()
        .with_any_thread(true)
        .build()
        .unwrap();
    let script = Script {
        host: NativeHost::new(
            Window::document(Panel {
                width: Signal::new(80),
                color: Signal::new(Color::BLACK),
            })
            .size(180, 140)
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
