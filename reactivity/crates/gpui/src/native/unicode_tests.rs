//! Actual owner-turn keyboard delivery and X11 surface output, not an alternate
//! shaper/render harness. IME/preedit is deliberately not inferred from this test.
use super::*;
use crate::{El, FieldId, Signal, Source, Sources, column, text, text_input};
use winit::{
    event_loop::ControlFlow,
    platform::{run_on_demand::EventLoopExtRunOnDemand, x11::EventLoopBuilderExtX11},
};

const VALUE: &str = "Hello Ελληνικά Привет नमस्ते abc العربية אבג 123";
#[derive(Default)]
struct Document {
    value: Signal<String>,
}
impl Document {
    const VALUE: Source<Self, String> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
}
impl View for Document {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE)
    }
    fn view(&self) -> El<'_> {
        column((
            text("Paragraph one\r\nParagraph two"),
            text_input(&self.value).w(350).h(100),
            text(&self.value).w(350),
        ))
        .p(8)
        .gap(8)
    }
}
struct Script {
    host: NativeHost<Document>,
    stage: u8,
    deadline: Instant,
    complete: bool,
    input: Option<Target>,
}
impl Script {
    fn step(&mut self, event_loop: &ActiveEventLoop) {
        assert!(
            Instant::now() < self.deadline,
            "Unicode native deadline at stage{}",
            self.stage
        );
        let Some(owner) = self.host.owner.as_ref() else {
            return;
        };
        let sheet = owner.snapshot().unwrap();
        if !sheet.presentation_valid || sheet.source_epoch != sheet.presentation_epoch {
            return;
        }
        match self.stage {
            0 => {
                self.input = Some(owner.input());
                self.host
                    .key_input(&NativeKey::Named(NamedKey::Tab), None)
                    .unwrap();
                self.host
                    .key_input(&NativeKey::Character(VALUE.into()), Some(VALUE))
                    .unwrap();
                let owner = self.host.owner.as_ref().unwrap();
                assert_eq!(owner.root().unwrap().value.as_str(), VALUE);
                assert_eq!(owner.snapshot().unwrap().source_epoch, 1);
                assert_eq!(owner.snapshot().unwrap().presentation_epoch, 0);
            }
            1 => {
                let owner = self.host.owner.as_mut().unwrap();
                assert_eq!(owner.input(), self.input.unwrap());
                assert!(owner.contains_text(VALUE).unwrap());
                assert_eq!((sheet.source_epoch, sheet.presentation_epoch), (1, 1));
                let actual = match self.host.graphics.as_mut().unwrap() {
                    Graphics::ReferenceCpu(surface, _) => surface.fetch().unwrap(),
                    _ => unreachable!(),
                };
                let expected = owner
                    .with_pixels(|bytes, _, _| {
                        bytes
                            .as_chunks::<4>()
                            .0
                            .iter()
                            .map(|pixel| {
                                (u32::from(pixel[0]) << 16)
                                    | (u32::from(pixel[1]) << 8)
                                    | u32::from(pixel[2])
                            })
                            .collect::<Vec<_>>()
                    })
                    .unwrap();
                assert_eq!(actual, expected, "complete native X11 framebuffer");
                assert!(expected.iter().any(|&pixel| pixel != 0xffffff));
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
#[ignore = "requires a real X11 display; actual software presenter, no GPU initialization"]
fn native_unicode_keyboard_and_surface_match_complete_cpu_pixels() {
    let mut event_loop = EventLoop::builder()
        .with_x11()
        .with_any_thread(true)
        .build()
        .unwrap();
    let host = NativeHost::new(
        Window::document(Document::default())
            .size(400, 280)
            .renderer(RendererPolicy::ReferenceCpu),
    );
    let script = Script {
        host,
        stage: 0,
        deadline: Instant::now() + Duration::from_secs(20),
        complete: false,
        input: None,
    };
    let (mut driver, wake) = Driver::new(&event_loop, script);
    driver.host_mut().host.wake = Some(wake);
    event_loop.run_app_on_demand(&mut driver).unwrap();
    assert!(driver.host().complete);
}
