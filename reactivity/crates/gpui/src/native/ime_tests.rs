//! Real native window/CPU submission; IME callbacks are normalized Winit events.
//! This does not synthesize an operating-system candidate engine.
use super::*;
use crate::{El, FieldId, FontFace, Signal, Source, Sources, column, text_input};
use winit::{event::Ime, event_loop::ControlFlow, platform::x11::EventLoopBuilderExtX11};
struct Form {
    a: Signal<String>,
    b: Signal<String>,
}
impl Form {
    const A: Source<Self, String> = Source::new(FieldId::new(1), "a", |m| &m.a, |m| &mut m.a);
    const B: Source<Self, String> = Source::new(FieldId::new(2), "b", |m| &m.b, |m| &mut m.b);
}
impl View for Form {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::A).direct(Self::B)
    }
    fn view(&self) -> El<'_> {
        column((
            text_input(&self.a).w(220).name("first"),
            text_input(&self.b).w(220).name("second"),
        ))
    }
}
struct Script {
    host: NativeHost<Form>,
    deadline: Instant,
    stage: u8,
    frames: u64,
    complete: bool,
}
impl Script {
    fn event(&mut self, event_loop: &ActiveEventLoop, event: Ime) {
        let id = self.host.window.as_ref().unwrap().id();
        self.host.dispatch(
            event_loop,
            Callback::Window {
                id,
                event: &WindowEvent::Ime(event),
            },
        );
        assert!(self.host.error.is_none(), "{:?}", self.host.error);
    }
    fn queue(&mut self) {
        self.frames = self.host.presented_frames + 1;
        self.host.request_redraw();
    }
    fn value(&self, name: &str) -> String {
        let owner = self.host.owner.as_ref().unwrap();
        let target = owner.query().name(name).one().unwrap();
        let mut value = None;
        owner
            .visit(|part| {
                if part.target() == target {
                    value = part.value().map(str::to_owned);
                }
            })
            .unwrap();
        value.unwrap()
    }
    fn oracle(&mut self) {
        let owner = self.host.owner.as_mut().unwrap();
        let size = owner.snapshot().unwrap().size;
        let mut expected = vec![0; size[0] as usize * size[1] as usize];
        owner.render_bgrx(&mut expected).unwrap();
        let Some(Graphics::ReferenceCpu(surface, _)) = &mut self.host.graphics else {
            panic!("CPU presenter")
        };
        assert_eq!(
            surface.fetch().unwrap(),
            expected,
            "native pixels stage {}",
            self.stage
        );
    }
    fn step(&mut self, event_loop: &ActiveEventLoop) {
        assert!(
            Instant::now() < self.deadline,
            "IME deadline stage {}",
            self.stage
        );
        let Some(owner) = &self.host.owner else {
            return;
        };
        let snapshot = owner.snapshot().unwrap();
        if self.host.presented_frames < self.frames
            || !snapshot.presentation_valid
            || snapshot.prepared_epoch.is_some()
        {
            return;
        }
        self.oracle();
        match self.stage {
            0 => {
                assert_eq!(self.value("first"), "日本");
                let owner = self.host.owner.as_mut().unwrap();
                let target = owner.query().name("first").one().unwrap();
                let result = owner.focus(target);
                self.host.input_result(result).unwrap();
                self.queue();
            }
            1 => {
                self.event(event_loop, Ime::Enabled);
                self.event(event_loop, Ime::Preedit("に".into(), Some((3, 3))));
                assert_eq!(self.value("first"), "日本");
                assert_eq!(
                    self.host.owner.as_ref().unwrap().read(&Form::A).unwrap(),
                    "日本"
                );
                assert_eq!(
                    self.host
                        .owner
                        .as_ref()
                        .unwrap()
                        .snapshot()
                        .unwrap()
                        .source_epoch,
                    snapshot.source_epoch
                );
                self.queue();
            }
            2 => {
                assert_eq!(self.value("first"), "日本に");
                let bridge = self.host.ime.as_ref().unwrap();
                assert!(bridge.has_acknowledged_cursor(self.host.owner.as_ref().unwrap()));
                self.event(event_loop, Ime::Preedit("日本".into(), Some((6, 6))));
                self.event(event_loop, Ime::Preedit(String::new(), None));
                self.event(event_loop, Ime::Commit("語".into()));
                assert_eq!(
                    self.host.owner.as_ref().unwrap().read(&Form::A).unwrap(),
                    "日本語"
                );
                assert_eq!(
                    self.host
                        .owner
                        .as_ref()
                        .unwrap()
                        .snapshot()
                        .unwrap()
                        .source_epoch,
                    snapshot.source_epoch + 1
                );
                self.queue();
            }
            3 => {
                assert_eq!(self.value("first"), "日本語");
                // An observed stream cannot acquire the next focused source.
                self.event(event_loop, Ime::Preedit("に".into(), Some((3, 3))));
                let owner = self.host.owner.as_mut().unwrap();
                let target = owner.query().name("second").one().unwrap();
                let result = owner.focus(target);
                self.host.input_result(result).unwrap();
                self.event(event_loop, Ime::Commit("late".into()));
                self.event(event_loop, Ime::Enabled); // Also rejected until Disabled.
                self.event(event_loop, Ime::Commit("late".into()));
                assert_eq!(
                    self.host.owner.as_ref().unwrap().read(&Form::B).unwrap(),
                    ""
                );
                self.event(event_loop, Ime::Disabled);
                self.event(event_loop, Ime::Enabled);
                self.event(event_loop, Ime::Commit("!".into()));
                self.queue();
            }
            4 => {
                assert_eq!(self.value("first"), "日本語");
                assert_eq!(self.value("second"), "!");
                self.event(event_loop, Ime::Disabled);
                self.host
                    .key_input(&NativeKey::Character("A".into()), Some("A"))
                    .unwrap();
                self.queue();
            }
            5 => {
                assert_eq!(self.value("second"), "!A");
                assert!(self.host.instance.is_none());
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
#[ignore = "requires real X11; actual initial CJK font, IME callback bridge, caret and complete server pixels"]
fn native_ime_preedit_commit_focus_lifecycle_and_acknowledged_pixels() {
    let event_loop = EventLoop::builder()
        .with_x11()
        .with_any_thread(true)
        .build()
        .unwrap();
    let script = Script {
        host: NativeHost::new(
            Window::document(Form {
                a: Signal::new("日本".into()),
                b: Signal::new(String::new()),
            })
            .text_font(FontFace::new(include_bytes!("../../tests/fonts/ime/cjk.otf")).unwrap())
            .size(260, 100)
            .renderer(RendererPolicy::ReferenceCpu),
        ),
        deadline: Instant::now() + Duration::from_secs(30),
        stage: 0,
        frames: 1,
        complete: false,
    };
    let (mut driver, wake) = Driver::new(&event_loop, script);
    driver.host_mut().host.wake = Some(wake);
    event_loop.run_app(&mut driver).unwrap();
    assert!(driver.host().complete);
    assert_eq!(driver.host().stage, 6);
}
