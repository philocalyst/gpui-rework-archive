//! Actual provider wire reads over CJK preedit, old ACK and commit.
use super::*;
use crate::{Affine, El, FieldId, FontFace, Signal, Source, Sources, column, div, text_input};
use winit::event::{Ime, WindowEvent};
const IME_TITLE: &str = "GPUI acknowledged IME wire proof";
struct Form {
    value: Signal<String>,
    broken: bool,
}
impl Form {
    const VALUE: Source<Self, String> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
}
impl View for Form {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE)
    }
    fn view(&self) -> El<'_> {
        column((
            text_input(&self.value).name("Compose").w(240),
            div()
                .size(2)
                .bg(crate::Color::BLACK)
                .transform(if self.broken {
                    Affine::scale(0., 1.)
                } else {
                    Affine::IDENTITY
                }),
        ))
    }
}
#[derive(Debug)]
struct Read {
    step: u8,
    extents: Option<(i32, i32, i32, i32)>,
}
async fn observe(
    runtime: &SharedRuntime,
    deadline: Instant,
    bus: &Connection,
    window: &Address,
    value: &str,
    caret: i32,
) -> Address {
    wait_for(runtime, deadline, async || {
        let input = named(bus, vec![window.clone()], "Compose").await?;
        let text = proxy(bus, &input, "org.a11y.atspi.Text").await.ok()?;
        let actual: String = text.call("GetText", &(0i32, -1i32)).await.ok()?;
        let offset: i32 = text.get_property("CaretOffset").await.ok()?;
        (actual == value && offset == caret).then_some(input)
    })
    .await
}
fn client(
    deadline: Instant,
    sender: mpmc::Sender<Result<Read, String>>,
    gate: mpmc::Receiver<()>,
    wake: Wake,
) {
    let result = zbus::block_on(async {
        let runtime = SharedRuntime::current()?;
        runtime
            .timeout_at(deadline, async {
                let session = Builder::session()
                    .method_timeout(Duration::from_secs(3))
                    .build()
                    .await?;
                let status =
                    Proxy::new(&session, "org.a11y.Bus", "/org/a11y/bus", "org.a11y.Status")
                        .await?;
                status.set_property("IsEnabled", true).await?;
                let address: String =
                    Proxy::new(&session, "org.a11y.Bus", "/org/a11y/bus", "org.a11y.Bus")
                        .await?
                        .call("GetAddress", &())
                        .await?;
                let bus = Builder::address(address.as_str())
                    .method_timeout(Duration::from_secs(3))
                    .build()
                    .await?;
                let desktop = (
                    "org.a11y.atspi.Registry".to_owned(),
                    "/org/a11y/atspi/accessible/root".try_into()?,
                );
                let window = wait_for(&runtime, deadline, async || {
                    let roots: Vec<Address> = proxy(&bus, &desktop, "org.a11y.atspi.Accessible")
                        .await
                        .ok()?
                        .call("GetChildren", &())
                        .await
                        .ok()?;
                    named(&bus, roots, IME_TITLE).await
                })
                .await;
                for (step, value, caret) in [
                    (0, "base", 4),
                    (1, "base", 4),
                    (2, "base日本", 6),
                    (3, "base日本", 6),
                    (4, "baseに", 5),
                    (5, "base語", 5),
                ] {
                    if step != 0 {
                        gate.recv().await?;
                    }
                    let input = observe(&runtime, deadline, &bus, &window, value, caret).await;
                    let extents = if (2..=4).contains(&step) {
                        // AccessKit keeps EditableText alongside text ranges. Its
                        // live action guards must reject edits of preview bytes.
                        let editable = proxy(&bus, &input, "org.a11y.atspi.EditableText").await?;
                        let admitted: bool =
                            editable.call("SetTextContents", &("forbidden",)).await?;
                        assert!(!admitted, "preview cannot acquire source edit authority");
                        let text = proxy(&bus, &input, "org.a11y.atspi.Text").await?;
                        let rect: (i32, i32, i32, i32) =
                            text.call("GetCharacterExtents", &(4i32, 1u32)).await?;
                        assert!(rect.2 > 0 && rect.3 > 0);
                        let hit: i32 = text
                            .call(
                                "GetOffsetAtPoint",
                                &(rect.0 + rect.2 / 2, rect.1 + rect.3 / 2, 1u32),
                            )
                            .await?;
                        assert_eq!(hit, 4);
                        Some(rect)
                    } else {
                        None
                    };
                    sender.try_send(Ok(Read { step, extents }))?;
                    wake.signal();
                }
                bus.close().await?;
                session.close().await?;
                Ok::<_, Box<dyn std::error::Error>>(())
            })
            .await?
    });
    if let Err(error) = result {
        let _ = sender.try_send(Err(error.to_string()));
        wake.signal();
    }
}
struct Script {
    host: NativeHost<Form>,
    deadline: Instant,
    receiver: mpmc::Receiver<Result<Read, String>>,
    sender: Option<mpmc::Sender<Result<Read, String>>>,
    gate: mpmc::Sender<()>,
    gate_receiver: Option<mpmc::Receiver<()>>,
    client: Option<thread::JoinHandle<()>>,
    waiting: Option<u64>,
    complete: bool,
}
impl Script {
    fn ime(&mut self, event_loop: &ActiveEventLoop, event: Ime) {
        self.host
            .window_event(event_loop, &WindowEvent::Ime(event))
            .unwrap();
    }
    fn frame(&mut self) {
        self.waiting = Some(self.host.presented_frames + 1);
        self.host.request_redraw();
    }
    fn geometry(&self, rect: (i32, i32, i32, i32)) {
        let owner = self.host.owner.as_ref().unwrap();
        let before = owner.counters();
        let mut checked = false;
        owner
            .visit(|part| {
                if part.name() == Some("Compose") {
                    let geometry = part.text_geometry().unwrap();
                    let unit = geometry
                        .layout()
                        .grapheme(crate::TextOffset::new(4).unwrap())
                        .unwrap();
                    let expected = geometry.visible_bounds(unit.bounds()).unwrap();
                    // AT-SPI serializes integer rectangles; the canonical P source
                    // retains the exact floating point physical rectangle.
                    for (actual, expected) in [
                        (rect.0, expected.x),
                        (rect.1, expected.y),
                        (rect.2, expected.width),
                        (rect.3, expected.height),
                    ] {
                        assert!(
                            (actual - expected as i32).abs() <= 1,
                            "AT-SPI/P rectangle {actual} {expected}"
                        );
                    }
                    checked = true;
                }
            })
            .unwrap();
        assert!(checked);
        assert_eq!(owner.counters(), before);
    }
    fn step(&mut self, event_loop: &ActiveEventLoop) {
        assert!(Instant::now() < self.deadline, "IME wire deadline");
        let Some(owner) = self.host.owner.as_ref() else {
            return;
        };
        if !owner.snapshot().unwrap().presentation_valid {
            return;
        }
        if let Some(frames) = self.waiting {
            if self.host.presented_frames >= frames {
                self.waiting = None;
                self.gate.try_send(()).unwrap();
            }
        }
        if self.client.is_none() {
            let sender = self.sender.take().unwrap();
            let gate = self.gate_receiver.take().unwrap();
            let wake = self.host.wake.clone().unwrap();
            let deadline = self.deadline;
            self.client = Some(thread::spawn(move || client(deadline, sender, gate, wake)));
        }
        while let Ok(read) = self.receiver.try_recv() {
            let read = read.expect("actual IME AT-SPI client failed");
            if let Some(rect) = read.extents {
                self.geometry(rect);
            }
            match read.step {
                0 => {
                    self.host.occluded = true;
                    self.host
                        .window_event(event_loop, &WindowEvent::Focused(true))
                        .unwrap();
                    let owner = self.host.owner.as_mut().unwrap();
                    let target = owner.input();
                    let result = owner.focus(target);
                    self.host.input_result(result).unwrap();
                    self.ime(event_loop, Ime::Enabled);
                    let epoch = self
                        .host
                        .owner
                        .as_ref()
                        .unwrap()
                        .snapshot()
                        .unwrap()
                        .source_epoch;
                    self.ime(event_loop, Ime::Preedit("日本".into(), Some((6, 6))));
                    assert_eq!(
                        self.host
                            .owner
                            .as_ref()
                            .unwrap()
                            .snapshot()
                            .unwrap()
                            .source_epoch,
                        epoch
                    );
                    assert_eq!(
                        self.host
                            .owner
                            .as_ref()
                            .unwrap()
                            .read(&Form::VALUE)
                            .unwrap(),
                        "base"
                    );
                    self.gate.try_send(()).unwrap();
                }
                1 => {
                    self.host.occluded = false;
                    self.frame();
                }
                2 => {
                    self.host.occluded = true;
                    self.ime(event_loop, Ime::Preedit("に".into(), Some((3, 3))));
                    let owner = self.host.owner.as_mut().unwrap();
                    assert!(owner.update(|m| m.broken = true).is_err());
                    self.host.sync_ime().unwrap();
                    self.gate.try_send(()).unwrap();
                }
                3 => {
                    self.host.occluded = false;
                    self.frame();
                }
                4 => {
                    let owner = self.host.owner.as_mut().unwrap();
                    assert_eq!(owner.read(&Form::VALUE).unwrap(), "base");
                    let result = owner.update(|m| m.broken = false);
                    self.host.input_result(result).unwrap();
                    self.ime(event_loop, Ime::Disabled);
                    self.ime(event_loop, Ime::Enabled);
                    let epoch = self
                        .host
                        .owner
                        .as_ref()
                        .unwrap()
                        .snapshot()
                        .unwrap()
                        .source_epoch;
                    self.ime(event_loop, Ime::Commit("語".into()));
                    assert_eq!(
                        self.host
                            .owner
                            .as_ref()
                            .unwrap()
                            .read(&Form::VALUE)
                            .unwrap(),
                        "base語"
                    );
                    assert_eq!(
                        self.host
                            .owner
                            .as_ref()
                            .unwrap()
                            .snapshot()
                            .unwrap()
                            .source_epoch,
                        epoch + 1
                    );
                    self.frame();
                }
                5 => {
                    self.complete = true;
                    event_loop.exit();
                }
                _ => unreachable!(),
            }
        }
    }
}
impl Host for Script {
    fn dispatch(&mut self, event_loop: &ActiveEventLoop, callback: Callback<'_>) {
        let about = matches!(callback, Callback::AboutToWait);
        self.host.dispatch(event_loop, callback);
        assert!(self.host.error.is_none(), "{:?}", self.host.error);
        if about {
            self.step(event_loop);
            event_loop.set_control_flow(ControlFlow::WaitUntil(self.deadline));
        }
    }
}
#[test]
#[ignore = "requires X11 and isolated session bus with actual AT-SPI registry"]
fn native_atspi_ime_cjk_preview_old_candidate_ack_and_commit() {
    let event_loop = EventLoop::builder()
        .with_x11()
        .with_any_thread(true)
        .build()
        .unwrap();
    let (sender, receiver) = mpmc::bounded(4.try_into().unwrap());
    let (gate, gate_receiver) = mpmc::bounded(1.try_into().unwrap());
    let script = Script {
        host: NativeHost::new(
            Window::document(Form {
                value: Signal::new("base".into()),
                broken: false,
            })
            .title(IME_TITLE)
            .size(280, 100)
            .renderer(RendererPolicy::ReferenceCpu)
            .text_font(
                FontFace::new(include_bytes!("../../../../tests/fonts/ime/cjk.otf")).unwrap(),
            ),
        ),
        deadline: Instant::now() + Duration::from_secs(40),
        receiver,
        sender: Some(sender),
        gate,
        gate_receiver: Some(gate_receiver),
        client: None,
        waiting: None,
        complete: false,
    };
    let (mut driver, wake) = Driver::new(&event_loop, script);
    driver.host_mut().host.wake = Some(wake);
    event_loop.run_app(&mut driver).unwrap();
    driver.host_mut().client.take().unwrap().join().unwrap();
    assert!(driver.host().complete);
}
