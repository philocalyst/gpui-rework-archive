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

struct SourceScript<L: LaneSet<Catalogue>> {
    host: NativeHost<Catalogue, L>,
    start: Option<Remote<String>>,
    deadline: Instant,
    ready_turns: usize,
    checked: bool,
}
impl<L: LaneSet<Catalogue> + 'static> Host for SourceScript<L> {
    fn dispatch(&mut self, event_loop: &ActiveEventLoop, callback: Callback<'_>) {
        let idle = matches!(callback, Callback::AboutToWait);
        if matches!(callback, Callback::WorkReady) {
            self.ready_turns += 1;
        }
        self.host.dispatch(event_loop, callback);
        assert!(self.host.error.is_none(), "{:?}", self.host.error);
        if !idle {
            return;
        }
        assert!(Instant::now() < self.deadline, "lost source inbox wake");
        event_loop.set_control_flow(winit::event_loop::ControlFlow::WaitUntil(self.deadline));
        let Some(owner) = self.host.owner.as_ref() else {
            return;
        };
        let sheet = owner.snapshot().unwrap();
        if !sheet.presentation_valid || sheet.presentation_epoch != sheet.source_epoch {
            return;
        }
        if let Some(remote) = self.start.take() {
            remote.try_send("漢".into()).unwrap();
        }
        if owner.root().unwrap().title.as_str() != "repair-129" {
            return;
        }
        assert!(owner.contains_text("repair-129").unwrap());
        assert_eq!(owner.counters().owner_reruns, 0);
        assert!(owner.counters().exact_updates >= 4);
        assert!(self.ready_turns >= 4);
        self.checked = true;
        event_loop.exit();
    }
}

#[test]
#[ignore = "requires real X11; actual wakes and failed presentation repair"]
fn native_source_inbox_patches_and_rearms_without_describing_the_owner() {
    let mut event_loop = EventLoop::builder()
        .with_x11()
        .with_any_thread(true)
        .build()
        .unwrap();
    let (remote, inbox) = Remote::bounded(130);
    let repair = remote.clone();
    let (faults, observed) = mpsc::channel();
    let window = Window::document(Catalogue::default())
        .renderer(RendererPolicy::ReferenceCpu)
        .on_presentation_error(move |error| {
            faults.send(error.clone()).unwrap();
            for i in 0..130 {
                repair.try_send(format!("repair-{i}")).unwrap();
            }
        })
        .with_inbox_for(
            inbox,
            Catalogue::TITLE,
            (|value, message| *value = message) as fn(&mut String, String),
        );
    let script = SourceScript {
        host: NativeHost::new(window),
        start: Some(remote),
        deadline: Instant::now() + Duration::from_secs(15),
        ready_turns: 0,
        checked: false,
    };
    let (mut driver, wake) = Driver::new(&event_loop, script);
    driver.host_mut().host.wake = Some(wake);
    event_loop.run_app_on_demand(&mut driver).unwrap();
    assert!(driver.host().checked);
    drop(driver);
    let errors = observed.try_iter().collect::<Vec<_>>();
    assert!(matches!(errors.as_slice(), [Error::Canvas(_)]));
}

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

type StatusResults =
    crate::StatusLane<ResultMessage, fn(&mut Catalogue, Option<ResultMessage>), ()>;
struct ClosingScript {
    host: NativeHost<Catalogue, StatusResults>,
    start: Option<mpsc::Sender<()>>,
    produced: mpsc::Receiver<()>,
    release: Option<mpsc::Sender<()>>,
    retained: Option<Remote<ResultMessage>>,
    deadline: Instant,
    expected_rows: usize,
    ready_turns: usize,
    terminal_turn: Option<usize>,
    checked: bool,
}
impl Host for ClosingScript {
    fn dispatch(&mut self, event_loop: &ActiveEventLoop, callback: Callback<'_>) {
        let ready = matches!(callback, Callback::WorkReady);
        let idle = matches!(callback, Callback::AboutToWait);
        if ready {
            self.ready_turns += 1;
        }
        self.host.dispatch(event_loop, callback);
        assert!(self.host.error.is_none(), "{:?}", self.host.error);
        if let Some(owner) = &self.host.owner
            && owner.root().unwrap().finished
            && self.terminal_turn.is_none()
        {
            assert!(ready, "terminal must enter through an actual WorkReady");
            self.terminal_turn = Some(self.ready_turns);
        }
        if !idle {
            return;
        }
        assert!(
            Instant::now() < self.deadline,
            "lost native producer-close wake"
        );
        // This deadline only detects failure. No timer callback polls delivery.
        event_loop.set_control_flow(winit::event_loop::ControlFlow::WaitUntil(self.deadline));
        let Some(owner) = &self.host.owner else {
            return;
        };
        let snapshot = owner.snapshot().unwrap();
        if !snapshot.presentation_valid || snapshot.source_epoch != snapshot.presentation_epoch {
            return;
        }
        if let Some(start) = self.start.take() {
            start.send(()).unwrap();
            // Ensure the entire >64 batch was queued after wake attachment and
            // before the loop can deliver it. This is test synchronization only.
            self.produced.recv_timeout(Duration::from_secs(5)).unwrap();
        }
        let model = owner.root().unwrap();
        if model.rows.len() == self.expected_rows
            && let Some(release) = self.release.take()
        {
            assert!(!model.finished, "an extant clone keeps the lane open");
            self.retained.take();
            release.send(()).unwrap();
            return;
        }
        if !model.finished {
            return;
        }
        assert_eq!(
            model.rows,
            (0..self.expected_rows as u32).collect::<Vec<_>>()
        );
        if self.expected_rows > 64 {
            assert!(
                self.ready_turns >= 3,
                "saturated batches require owner rearm"
            );
        } else {
            assert!(
                self.terminal_turn.unwrap() >= 2,
                "quiescent close needs its own wake"
            );
        }
        self.checked = true;
        self.host.retire_window();
        assert!(self.host.owner.is_none());
        // Reuse the pinned prerequisite's exact late-callback lifecycle: a
        // wake already queued when retirement begins has no owner to enter.
        self.host.dispatch(event_loop, Callback::WorkReady);
        assert!(self.host.error.is_none(), "{:?}", self.host.error);
        event_loop.exit();
    }
}

#[test]
#[ignore = "requires real X11; deadline detects failure and never polls delivery"]
fn native_final_producer_drop_drains_saturated_and_quiescent_status_lanes() {
    let mut event_loop = EventLoop::builder()
        .with_x11()
        .with_any_thread(true)
        .build()
        .unwrap();
    // Buffered terminal before binding; terminal after binding; then a final
    // producer dropping while the owner is idle after a below-budget batch.
    for (prebinding, repair, quiescent) in [
        (true, false, false),
        (true, true, false),
        (false, false, false),
        (false, true, false),
        (false, false, true),
    ] {
        let (remote, inbox) = Remote::bounded(256);
        let retained = quiescent.then(|| remote.clone());
        let (start, begin) = mpsc::channel();
        let (produced, production) = mpsc::channel();
        let (release, released) = mpsc::channel();
        let expected_rows = if quiescent { 3 } else { 130 };
        let worker = std::thread::spawn(move || {
            begin.recv().unwrap();
            for row in 0..expected_rows as u32 {
                if repair && row == 63 {
                    remote.try_send(ResultMessage::Schema(true)).unwrap();
                }
                if repair && row == 64 {
                    remote.try_send(ResultMessage::Schema(false)).unwrap();
                }
                remote.try_send(ResultMessage::Row(row)).unwrap();
            }
            if quiescent {
                produced.send(()).unwrap();
                released.recv().unwrap();
                drop(remote);
            } else {
                drop(remote);
                produced.send(()).unwrap();
            }
        });
        let start = if prebinding {
            start.send(()).unwrap();
            production.recv_timeout(Duration::from_secs(5)).unwrap();
            // Join guarantees the sole Producer is gone before Window binding.
            worker.join().unwrap();
            None
        } else {
            Some((start, worker))
        };
        let (faults, observed) = mpsc::channel();
        let window = Window::document(Catalogue::default())
            .renderer(RendererPolicy::ReferenceCpu)
            .on_presentation_error(move |error| {
                faults.send(error.clone()).unwrap();
            })
            .with_inbox_status(
                inbox,
                (|model: &mut Catalogue, value| match value {
                    Some(value) => model.receive(value),
                    None => model.finished = true,
                }) as fn(&mut Catalogue, Option<ResultMessage>),
            )
            .unwrap();
        let (start, worker) = match start {
            Some((start, worker)) => (Some(start), Some(worker)),
            None => (None, None),
        };
        let script = ClosingScript {
            host: NativeHost::new(window),
            start,
            produced: production,
            release: quiescent.then_some(release),
            retained,
            deadline: Instant::now() + Duration::from_secs(15),
            expected_rows,
            ready_turns: 0,
            terminal_turn: None,
            checked: false,
        };
        let (mut driver, wake) = Driver::new(&event_loop, script);
        driver.host_mut().host.wake = Some(wake);
        event_loop.run_app_on_demand(&mut driver).unwrap();
        assert!(driver.host().checked);
        if let Some(worker) = worker {
            worker.join().unwrap();
        }
        drop(driver);
        let errors = observed.try_iter().collect::<Vec<_>>();
        if repair {
            assert!(matches!(
                errors.as_slice(),
                [Error::UnregisteredInput { .. }]
            ));
        } else {
            assert!(errors.is_empty());
        }
    }
}
