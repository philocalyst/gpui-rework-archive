//! Real native wake proof, with the same static lane and owner barrier as demo.
use super::*;
use crate::{El, FieldId, Remote, SendError, Signal, Source, Sources, column, text, text_input};
use std::sync::mpsc;
use winit::platform::{run_on_demand::EventLoopExtRunOnDemand, x11::EventLoopBuilderExtX11};

#[derive(Default)]
struct Catalogue {
    title: Signal<String>,
    rows: Vec<u32>,
    finished: bool,
    bad_schema: bool,
    unregistered: Signal<String>,
}
enum ResultMessage {
    Row(u32),
    Finished,
    Schema(bool),
}
impl Catalogue {
    const TITLE: Source<Self, String> =
        Source::new(FieldId::new(1), "title", |m| &m.title, |m| &mut m.title);
    fn receive(&mut self, message: ResultMessage) {
        match message {
            ResultMessage::Row(row) => self.rows.push(row),
            ResultMessage::Finished => self.finished = true,
            ResultMessage::Schema(bad) => self.bad_schema = bad,
        }
    }
}
impl View for Catalogue {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::TITLE)
    }
    fn view(&self) -> El<'_> {
        column((
            text_input(if self.bad_schema {
                &self.unregistered
            } else {
                &self.title
            })
            .w(150)
            .h(30),
            text(format!("{} results", self.rows.len())),
        ))
    }
}
type Results = Lane<ResultMessage, fn(&mut Catalogue, ResultMessage), ()>;
struct Script {
    host: NativeHost<Catalogue, Results>,
    start: Option<mpsc::Sender<()>>,
    deadline: Instant,
    ready_turns: usize,
    nonempty_turns: usize,
    checked: bool,
}
impl Host for Script {
    fn dispatch(&mut self, event_loop: &ActiveEventLoop, callback: Callback<'_>) {
        let ready = matches!(callback, Callback::WorkReady);
        let idle = matches!(callback, Callback::AboutToWait);
        let before = self
            .host
            .owner
            .as_ref()
            .map_or(0, |owner| owner.root().unwrap().rows.len());
        let focus_before = self
            .host
            .owner
            .as_ref()
            .and_then(|owner| owner.focused().unwrap());
        self.host.dispatch(event_loop, callback);
        assert!(self.host.error.is_none(), "{:?}", self.host.error);
        if ready {
            self.ready_turns += 1;
            let owner = self.host.owner.as_ref().unwrap();
            let after = owner.root().unwrap().rows.len();
            assert_eq!(
                owner.focused().unwrap(),
                focus_before,
                "completion dispatch preserves focus"
            );
            assert!(
                after - before <= 8,
                "one turn is bounded by staging/receive capacity"
            );
            if after != before {
                self.nonempty_turns += 1;
            }
        }
        if !idle {
            return;
        }
        assert!(
            Instant::now() < self.deadline,
            "lost native completion wake"
        );
        // The single deadline is a failure watchdog. It never polls the inbox;
        // ordinary progress must come from actual WorkReady notifications.
        event_loop.set_control_flow(winit::event_loop::ControlFlow::WaitUntil(self.deadline));
        let Some(owner) = self.host.owner.as_mut() else {
            return;
        };
        let sheet = owner.snapshot().unwrap();
        if !sheet.presentation_valid || sheet.presentation_epoch != sheet.source_epoch {
            return;
        }
        if let Some(start) = self.start.take() {
            let input = owner.input();
            owner.focus(input).unwrap();
            start.send(()).unwrap();
        }
        if !owner.root().unwrap().finished {
            return;
        }
        assert_eq!(owner.root().unwrap().rows, (0..130).collect::<Vec<_>>());
        assert!(owner.contains_text("130 results").unwrap());
        assert!(self.ready_turns >= 17);
        assert!(self.nonempty_turns >= 17);
        assert_eq!(
            owner.counters().source_operations,
            owner.snapshot().unwrap().source_epoch
        );
        assert!(matches!(
            self.host.graphics,
            Some(Graphics::ReferenceCpu(..))
        ));
        assert!(self.host.instance.is_none());
        // A completion did not steal focus; ordinary normalized native input
        // still edits the same live control and source/publication barrier.
        let input = owner.input();
        // OS blur may independently clear focus between callbacks. Explicit
        // focus uses the same owner authority before this normalized key.
        owner.focus(input).unwrap();
        self.host
            .key_input(&NativeKey::Character("native".into()), Some("native"))
            .unwrap();
        assert_eq!(
            self.host
                .owner
                .as_ref()
                .unwrap()
                .root()
                .unwrap()
                .title
                .as_str(),
            "native"
        );
        self.checked = true;
        event_loop.exit();
    }
}

#[test]
#[ignore = "requires real X11; deadline is a failure watchdog, not a delivery poll"]
fn native_remote_results_wake_bounded_owner_turns_without_polling() {
    let mut event_loop = EventLoop::builder()
        .with_x11()
        .with_any_thread(true)
        .build()
        .unwrap();
    for repair_description in [false, true] {
        let (remote, inbox) = Remote::bounded(8);
        let first = if repair_description { 7 } else { 1 };
        for row in 0..first {
            remote.try_send(ResultMessage::Row(row)).unwrap();
        }
        if repair_description {
            remote.try_send(ResultMessage::Schema(true)).unwrap();
        }
        let retained = remote.clone();
        let (start, begin) = mpsc::channel();
        let observer_start = start.clone();
        let (faults, observed_faults) = mpsc::channel();
        let worker = std::thread::spawn(move || {
            begin.recv().unwrap();
            let repair = repair_description.then_some(ResultMessage::Schema(false));
            for message in repair
                .into_iter()
                .chain((first..130).map(ResultMessage::Row))
                .chain([ResultMessage::Finished])
            {
                let mut value = message;
                loop {
                    match remote.try_send(value) {
                        Ok(()) => break,
                        Err(SendError::Full(returned)) => {
                            value = returned;
                            std::thread::yield_now();
                        }
                        Err(SendError::Closed(_)) => panic!("owner closed before worker finished"),
                    }
                }
            }
        });
        let window = Window::document(Catalogue::default())
            .renderer(RendererPolicy::ReferenceCpu)
            .on_presentation_error(move |error| {
                faults.send(error.clone()).unwrap();
                if repair_description {
                    let _ = observer_start.send(());
                }
            })
            .with_inbox(
                inbox,
                Catalogue::receive as fn(&mut Catalogue, ResultMessage),
            );
        let script = Script {
            host: NativeHost::new(window),
            start: (!repair_description).then_some(start),
            deadline: Instant::now() + Duration::from_secs(15),
            ready_turns: 0,
            nonempty_turns: 0,
            checked: false,
        };
        let (mut driver, wake) = Driver::new(&event_loop, script);
        driver.host_mut().host.wake = Some(wake);
        event_loop.run_app_on_demand(&mut driver).unwrap();
        assert!(driver.host().checked);
        worker.join().unwrap();
        drop(driver);
        let errors = observed_faults.try_iter().collect::<Vec<_>>();
        if repair_description {
            assert!(matches!(
                errors.as_slice(),
                [Error::UnregisteredInput { .. }]
            ));
        } else {
            assert!(errors.is_empty());
        }
        assert!(matches!(
            retained.try_send(ResultMessage::Row(999)),
            Err(SendError::Closed(_))
        ));
    }
}
