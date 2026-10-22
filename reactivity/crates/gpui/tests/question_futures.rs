//! Public owners and an explicit deterministic executor exercise the real seam.
//! Boxing, control Arcs, and wake storage here belong to this test executor.
use gpui::{
    QuestionExecutor, QuestionFault, QuestionStatus, QuestionTask, Questions, Reader, StartError,
    WindowOptions, prelude::*,
};
use std::{
    collections::VecDeque,
    fmt,
    future::Future,
    panic::{AssertUnwindSafe, catch_unwind},
    pin::Pin,
    sync::{
        Arc, Mutex,
        atomic::{AtomicBool, AtomicUsize, Ordering},
        mpsc,
    },
    task::{Context, Poll, Wake, Waker},
};

#[derive(Debug)]
struct Domain;
impl fmt::Display for Domain {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_str("service unavailable")
    }
}
impl std::error::Error for Domain {}

struct Model {
    query: Signal<String>,
    unrelated: Signal<u32>,
    answer: Reader<String>,
}
impl Model {
    const QUERY: Source<Self, String> =
        Source::new(FieldId::new(1), "query", |m| &m.query, |m| &mut m.query);
    const OTHER: Source<Self, u32> = Source::new(
        FieldId::new(2),
        "unrelated",
        |m| &m.unrelated,
        |m| &mut m.unrelated,
    );
}
impl View for Model {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::QUERY).direct(Self::OTHER)
    }
    fn view(&self) -> El<'_> {
        self.answer
            .project(|s| text(s.as_str()))
            .loading(|| text("Searching"))
            .failed(|failure| text(format!("Failure: {failure}")))
    }
}

#[derive(Default)]
struct Control {
    cancelled: AtomicBool,
    wakes: AtomicUsize,
    retired: AtomicUsize,
}
impl Wake for Control {
    fn wake(self: Arc<Self>) {
        self.wake_by_ref();
    }
    fn wake_by_ref(self: &Arc<Self>) {
        self.wakes.fetch_add(1, Ordering::SeqCst);
    }
}
struct Handle(Arc<Control>);
impl QuestionTask for Handle {
    fn cancel(&mut self) {
        // The flag is authoritative even if no future waker was registered.
        self.0.cancelled.store(true, Ordering::SeqCst);
        self.0.wake_by_ref();
    }
}
impl Drop for Handle {
    fn drop(&mut self) {
        self.0.retired.fetch_add(1, Ordering::SeqCst);
    }
}
struct Job {
    future: Option<Pin<Box<dyn Future<Output = ()> + Send>>>,
    control: Arc<Control>,
}
impl Job {
    fn poll(&mut self) -> Poll<()> {
        if self.control.cancelled.load(Ordering::SeqCst) {
            self.future.take();
            return Poll::Ready(());
        }
        let waker = Waker::from(self.control.clone());
        let poll = self
            .future
            .as_mut()
            .unwrap()
            .as_mut()
            .poll(&mut Context::from_waker(&waker));
        // Model a conforming runtime's cancel-during-poll synchronization.
        if self.control.cancelled.load(Ordering::SeqCst) {
            self.future.take();
        }
        poll
    }
}
#[derive(Clone, Copy)]
enum Spawn {
    Accept,
    Reject,
    Panic,
    HalfAcceptError,
    HalfAcceptPanic,
    FinishOnWorker,
}
struct Executor {
    jobs: mpsc::Sender<Job>,
    modes: Arc<Mutex<VecDeque<Spawn>>>,
}
struct Driver {
    jobs: mpsc::Receiver<Job>,
    modes: Arc<Mutex<VecDeque<Spawn>>>,
}
impl Driver {
    fn new() -> (Executor, Self) {
        let (send, jobs) = mpsc::channel();
        let modes = Arc::new(Mutex::new(VecDeque::new()));
        (
            Executor {
                jobs: send,
                modes: modes.clone(),
            },
            Self { jobs, modes },
        )
    }
    fn mode(&self, mode: Spawn) {
        self.modes.lock().unwrap().push_back(mode);
    }
    fn next(&self) -> Job {
        self.jobs.try_recv().expect("one explicitly queued task")
    }
    fn empty(&self) {
        assert!(
            self.jobs.try_recv().is_err(),
            "no new task before credit retirement"
        );
    }
}
impl QuestionExecutor for Executor {
    type Task = Handle;
    fn spawn<F: Future<Output = ()> + Send + 'static>(
        &mut self,
        future: F,
    ) -> Result<Handle, StartError> {
        let mode = self
            .modes
            .lock()
            .unwrap()
            .pop_front()
            .unwrap_or(Spawn::Accept);
        if matches!(mode, Spawn::Reject) {
            drop(future);
            return Err(StartError::Busy);
        }
        if matches!(mode, Spawn::Panic) {
            panic!("spawn rejected before acceptance");
        }
        let control = Arc::new(Control::default());
        let mut job = Job {
            future: Some(Box::pin(future)),
            control: control.clone(),
        };
        if matches!(mode, Spawn::FinishOnWorker) {
            // A worker, never the owner, polls before spawn returns its handle.
            job = std::thread::spawn(move || {
                assert_eq!(job.poll(), Poll::Ready(()));
                job
            })
            .join()
            .unwrap();
        }
        self.jobs.send(job).unwrap();
        match mode {
            Spawn::HalfAcceptError => Err(StartError::Busy),
            Spawn::HalfAcceptPanic => panic!("broken executor lost accepted handle"),
            _ => Ok(Handle(control)),
        }
    }
}

fn open<Fut: Future<Output = Result<String, Domain>> + Send + 'static>(
    executor: Executor,
    make: impl FnMut(String) -> Fut,
) -> (Win<Model, impl gpui::LaneSet<Model>>, Reader<String>) {
    let (questions, answer) = Questions::new()
        .question_future(Model::QUERY, Clone::clone, executor, make)
        .unwrap();
    let win = Win::with_questions(
        Model {
            query: Signal::new("A".into()),
            unrelated: Signal::new(0),
            answer,
        },
        questions,
        WindowOptions {
            size: [160, 60],
            ..Default::default()
        },
    )
    .unwrap();
    (win, answer)
}
fn deliver<L: gpui::LaneSet<Model>>(win: &mut Win<Model, L>) {
    for _ in 0..8 {
        if !win.deliver_ready(8).unwrap().more {
            return;
        }
    }
    panic!("finite staged terminals did not become idle");
}

#[test]
fn never_waking_pending_cancels_exact_task_and_only_latest_input_starts_after_teardown() {
    let (executor, driver) = Driver::new();
    let (made, inputs) = mpsc::channel();
    let (mut win, answer) = open(executor, move |input| {
        made.send(input).unwrap();
        std::future::pending()
    });
    let mut first = driver.next();
    assert_eq!(inputs.try_recv().unwrap(), "A");
    assert_eq!(first.poll(), Poll::Pending);
    win.set(Model::OTHER, 1).unwrap();
    assert!(!first.control.cancelled.load(Ordering::SeqCst));
    win.set(Model::QUERY, "B".into()).unwrap();
    assert!(first.control.cancelled.load(Ordering::SeqCst));
    assert!(first.control.wakes.load(Ordering::SeqCst) > 0);
    assert!(win.question_info(answer).unwrap().completion_leased);
    deliver(&mut win);
    driver.empty();
    win.set(Model::QUERY, "C".into()).unwrap();
    assert_eq!(first.poll(), Poll::Ready(()));
    assert_eq!(first.control.retired.load(Ordering::SeqCst), 0);
    deliver(&mut win);
    assert_eq!(first.control.retired.load(Ordering::SeqCst), 1);
    assert_eq!(inputs.try_recv().unwrap(), "C");
    assert_eq!(win.question_status(answer), Ok(QuestionStatus::Pending));
    assert_eq!(win.question_info(answer).unwrap().stats.dispatched, 2);
    drop(driver.next());
}

#[test]
fn ready_result_is_stale_across_a_b_a_and_handle_retires_before_next_factory() {
    let (executor, driver) = Driver::new();
    let prior = Arc::new(Mutex::new(None::<Arc<Control>>));
    let check = prior.clone();
    let (mut win, answer) = open(executor, move |input| {
        if let Some(control) = check.lock().unwrap().as_ref() {
            assert_eq!(
                control.retired.load(Ordering::SeqCst),
                1,
                "handle retired before newest work starts"
            );
        }
        async move { Ok(format!("answer {input}")) }
    });
    let mut first = driver.next();
    *prior.lock().unwrap() = Some(first.control.clone());
    assert_eq!(first.poll(), Poll::Ready(()));
    win.set(Model::QUERY, "B".into()).unwrap();
    win.set(Model::QUERY, "A".into()).unwrap();
    deliver(&mut win);
    assert_eq!(win.with_ready(answer, String::clone).unwrap(), None);
    assert_eq!(win.question_info(answer).unwrap().stats.stale_results, 1);
    let mut current = driver.next();
    assert_eq!(current.poll(), Poll::Ready(()));
    deliver(&mut win);
    assert_eq!(
        win.with_ready(answer, String::clone).unwrap(),
        Some("answer A".into())
    );
    assert_eq!(win.question_info(answer).unwrap().stats.accepted, 1);
}

#[test]
fn worker_completion_before_spawn_returns_still_waits_for_the_owner_barrier() {
    let (executor, driver) = Driver::new();
    driver.mode(Spawn::FinishOnWorker);
    let (mut win, answer) = open(executor, |query| async move { Ok(query) });
    assert_eq!(win.question_status(answer), Ok(QuestionStatus::Pending));
    let mut completed = driver.next();
    deliver(&mut win);
    assert_eq!(
        win.with_ready(answer, String::clone).unwrap(),
        Some("A".into())
    );
    // Retaining and even repolling the trivial completed wrapper is harmless.
    assert_eq!(completed.poll(), Poll::Ready(()));
    deliver(&mut win);
    assert_eq!(win.question_info(answer).unwrap().stats.accepted, 1);
}

#[test]
fn rejection_start_panic_and_broken_half_accept_never_fabricate_credit() {
    for mode in [
        Spawn::Reject,
        Spawn::Panic,
        Spawn::HalfAcceptError,
        Spawn::HalfAcceptPanic,
    ] {
        let (executor, driver) = Driver::new();
        driver.mode(mode);
        let (mut win, answer) = open(executor, |query| async move { Ok(query) });
        assert_eq!(win.question_status(answer), Ok(QuestionStatus::Fault));
        let half = matches!(mode, Spawn::HalfAcceptError | Spawn::HalfAcceptPanic);
        let retained = if half { Some(driver.next()) } else { None };
        win.retry(answer).unwrap();
        if half {
            deliver(&mut win);
            assert!(win.question_info(answer).unwrap().completion_leased);
            driver.empty();
            // This unsupported executor lost its handle: only actual physical
            // teardown, supplied externally here, can restore its credit.
            drop(retained);
        }
        deliver(&mut win);
        let mut next = driver.next();
        assert_eq!(next.poll(), Poll::Ready(()));
        deliver(&mut win);
        assert_eq!(
            win.with_ready(answer, String::clone).unwrap(),
            Some("A".into())
        );
    }
}

#[test]
fn factory_panic_is_a_start_fault_and_retry_is_not_poisoned() {
    let (executor, driver) = Driver::new();
    let mut first = true;
    let (mut win, answer) = open(executor, move |query| {
        if std::mem::take(&mut first) {
            panic!("factory panic");
        }
        async move { Ok(query) }
    });
    assert!(win.contains_text("ExecutorPanicked").unwrap());
    assert!(!win.snapshot().unwrap().poisoned);
    win.retry(answer).unwrap();
    deliver(&mut win);
    let mut next = driver.next();
    assert_eq!(next.poll(), Poll::Ready(()));
    deliver(&mut win);
    assert_eq!(win.question_status(answer), Ok(QuestionStatus::Ready));
}

struct Probe {
    query: String,
    ready: bool,
    poll_panic: bool,
    drop_panic: bool,
    dropped: mpsc::Sender<String>,
    drop_pause: Option<(mpsc::Sender<()>, mpsc::Receiver<()>)>,
    _pin: std::marker::PhantomPinned,
}
impl Future for Probe {
    type Output = Result<String, Domain>;
    fn poll(self: Pin<&mut Self>, _: &mut Context<'_>) -> Poll<Self::Output> {
        if self.poll_panic {
            panic!("poll panic");
        }
        if self.ready {
            Poll::Ready(Ok(format!("answer {}", self.query)))
        } else {
            Poll::Pending
        }
    }
}
impl Drop for Probe {
    fn drop(&mut self) {
        if let Some((entered, resume)) = self.drop_pause.take() {
            entered.send(()).unwrap();
            resume.recv().unwrap();
        }
        self.dropped.send(self.query.clone()).unwrap();
        if self.drop_panic {
            panic!("future destructor panic");
        }
    }
}
fn probe(query: String, dropped: mpsc::Sender<String>) -> Probe {
    Probe {
        query,
        ready: false,
        poll_panic: false,
        drop_panic: false,
        dropped,
        drop_pause: None,
        _pin: std::marker::PhantomPinned,
    }
}

#[test]
fn poll_panic_tears_down_before_one_worker_fault_and_retry_heals() {
    let (executor, driver) = Driver::new();
    let (drops, dropped) = mpsc::channel();
    let mut first = true;
    let (mut win, answer) = open(executor, move |query| {
        let mut future = probe(query, drops.clone());
        future.poll_panic = std::mem::take(&mut first);
        future.ready = true;
        future
    });
    let mut first = driver.next();
    assert_eq!(first.poll(), Poll::Ready(()));
    assert_eq!(dropped.try_recv().unwrap(), "A");
    deliver(&mut win);
    assert!(win.contains_text("WorkerPanicked").unwrap());
    assert_eq!(win.question_info(answer).unwrap().stats.framework_faults, 1);
    win.retry(answer).unwrap();
    let mut next = driver.next();
    assert_eq!(next.poll(), Poll::Ready(()));
    assert_eq!(dropped.try_recv().unwrap(), "A");
    deliver(&mut win);
    assert_eq!(win.question_status(answer), Ok(QuestionStatus::Ready));
    assert!(!win.snapshot().unwrap().poisoned);
}

#[test]
fn pending_or_ready_destructor_panic_publishes_exactly_one_worker_terminal() {
    for ready in [false, true] {
        let (executor, driver) = Driver::new();
        let (drops, dropped) = mpsc::channel();
        let (mut win, answer) = open(executor, move |query| {
            let mut future = probe(query, drops.clone());
            future.ready = ready;
            future.drop_panic = true;
            future
        });
        let mut job = driver.next();
        if ready {
            assert!(catch_unwind(AssertUnwindSafe(|| job.poll())).is_err());
        } else {
            assert_eq!(job.poll(), Poll::Pending);
        }
        // On Ready Drop panic the executor unwinds, then drops the wrapper;
        // on Pending it simply destroys the cancelled/abandoned task.
        let dropped_job = catch_unwind(AssertUnwindSafe(|| drop(job)));
        assert_eq!(dropped_job.is_err(), !ready);
        assert_eq!(dropped.try_recv().unwrap(), "A");
        assert!(dropped.try_recv().is_err());
        deliver(&mut win);
        assert!(win.contains_text("WorkerPanicked").unwrap());
        assert_eq!(win.question_info(answer).unwrap().stats.framework_faults, 1);
        assert!(!win.question_info(answer).unwrap().completion_leased);
        deliver(&mut win);
        assert_eq!(win.question_info(answer).unwrap().stats.framework_faults, 1);
    }
}

#[test]
fn blocked_future_destructor_holds_credit_even_after_ready_or_cancel() {
    for ready in [false, true] {
        let (executor, driver) = Driver::new();
        let (drops, dropped) = mpsc::channel();
        let (entered, wait_entered) = mpsc::channel();
        let (resume, wait_resume) = mpsc::channel();
        let mut pause = Some((entered, wait_resume));
        let (mut win, answer) = open(executor, move |query| {
            let mut future = probe(query, drops.clone());
            future.ready = ready;
            future.drop_pause = pause.take();
            future
        });
        let mut first = driver.next();
        if !ready {
            assert_eq!(first.poll(), Poll::Pending);
            win.set(Model::QUERY, "B".into()).unwrap();
        }
        let worker = std::thread::spawn(move || {
            if ready {
                assert_eq!(first.poll(), Poll::Ready(()));
            }
            drop(first);
        });
        wait_entered.recv().unwrap();
        if ready {
            win.set(Model::QUERY, "B".into()).unwrap();
        }
        deliver(&mut win);
        assert!(win.question_info(answer).unwrap().completion_leased);
        driver.empty();
        assert!(dropped.try_recv().is_err());
        resume.send(()).unwrap();
        worker.join().unwrap();
        assert_eq!(dropped.try_recv().unwrap(), "A");
        deliver(&mut win);
        assert_eq!(win.question_status(answer), Ok(QuestionStatus::Pending));
        drop(driver.next());
    }
}

#[test]
fn cancel_before_first_poll_and_close_or_natural_drop_never_join_the_task() {
    for close in [false, true] {
        let (executor, driver) = Driver::new();
        let (drops, dropped) = mpsc::channel();
        let (mut win, answer) = open(executor, move |query| probe(query, drops.clone()));
        let mut first = driver.next();
        win.set(Model::QUERY, "B".into()).unwrap();
        assert!(first.control.cancelled.load(Ordering::SeqCst));
        assert_eq!(first.poll(), Poll::Ready(()));
        assert_eq!(dropped.try_recv().unwrap(), "A");
        deliver(&mut win);
        let mut second = driver.next();
        assert_eq!(second.poll(), Poll::Pending);
        if close {
            win.close();
        } else {
            drop(win);
        }
        assert!(second.control.cancelled.load(Ordering::SeqCst));
        assert!(
            dropped.try_recv().is_err(),
            "owner close did not block waiting for teardown"
        );
        assert_eq!(second.poll(), Poll::Ready(()));
        assert_eq!(dropped.try_recv().unwrap(), "B");
        let _ = answer;
    }
}

#[test]
fn domain_fault_and_refresh_preserve_previous_projection_and_reuse_existing_error_view() {
    let (executor, driver) = Driver::new();
    let (mut win, answer) = open(executor, |query| async move {
        if query == "fault" {
            Err(Domain)
        } else {
            Ok(format!("answer {query}"))
        }
    });
    assert_eq!(driver.next().poll(), Poll::Ready(()));
    deliver(&mut win);
    assert!(win.contains_text("answer A").unwrap());
    win.set(Model::QUERY, "fault".into()).unwrap();
    assert!(win.contains_text("answer A").unwrap());
    assert_eq!(driver.next().poll(), Poll::Ready(()));
    deliver(&mut win);
    assert_eq!(win.question_status(answer), Ok(QuestionStatus::Fault));
    assert!(win.contains_text("answer A").unwrap());
    assert!(win.contains_text("service unavailable").unwrap());
}

#[test]
fn foreign_reader_is_rejected_before_executor_start() {
    let (executor, driver) = Driver::new();
    let (_win, foreign) = open(executor, |query| async move { Ok(query) });
    drop(driver.next());
    let (executor, driver) = Driver::new();
    let result = Questions::<Model>::new().question_future(
        foreign,
        Clone::clone,
        executor,
        |query| async move { Ok::<_, Domain>(query) },
    );
    assert!(matches!(result, Err(QuestionFault::Revoked)));
    driver.empty();
}

#[test]
fn cancellation_during_waker_registration_is_not_lost() {
    struct Register {
        before: mpsc::Sender<()>,
        resume: mpsc::Receiver<()>,
        dropped: mpsc::Sender<()>,
        waker: Option<Waker>,
    }
    impl Future for Register {
        type Output = Result<String, Domain>;
        fn poll(mut self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Self::Output> {
            self.before.send(()).unwrap();
            self.resume.recv().unwrap();
            // Deliberately register after cancellation. This future never wakes.
            self.waker = Some(cx.waker().clone());
            Poll::Pending
        }
    }
    impl Drop for Register {
        fn drop(&mut self) {
            self.dropped.send(()).unwrap();
        }
    }
    let (executor, driver) = Driver::new();
    let (before, reached) = mpsc::channel();
    let (resume, paused) = mpsc::channel();
    let (dropped, drops) = mpsc::channel();
    let mut registration = Some((before, paused, dropped));
    let (mut win, answer) = open(executor, move |_| {
        let (before, resume, dropped) = registration.take().unwrap();
        Register {
            before,
            resume,
            dropped,
            waker: None,
        }
    });
    let mut task = driver.next();
    let control = task.control.clone();
    let worker = std::thread::spawn(move || {
        assert_eq!(task.poll(), Poll::Pending);
        task
    });
    reached.recv().unwrap();
    win.set(Model::QUERY, "B".into()).unwrap();
    assert!(control.cancelled.load(Ordering::SeqCst));
    assert!(control.wakes.load(Ordering::SeqCst) > 0);
    driver.empty();
    assert!(win.question_info(answer).unwrap().completion_leased);
    // Close instead of starting B: this one-shot adversarial factory is consumed.
    win.close();
    resume.send(()).unwrap();
    let task = worker.join().unwrap();
    drops.try_recv().unwrap();
    assert!(
        task.future.is_none(),
        "executor serialized abort after active poll"
    );
}

#[test]
fn a_panicking_poll_payload_is_classified_only_after_future_teardown() {
    struct Payload;
    impl Drop for Payload {
        fn drop(&mut self) {
            panic!("panic payload destructor");
        }
    }
    struct PanicPayload(mpsc::Sender<()>);
    impl Future for PanicPayload {
        type Output = Result<String, Domain>;
        fn poll(self: Pin<&mut Self>, _: &mut Context<'_>) -> Poll<Self::Output> {
            std::panic::panic_any(Payload);
        }
    }
    impl Drop for PanicPayload {
        fn drop(&mut self) {
            self.0.send(()).unwrap();
        }
    }
    let (executor, driver) = Driver::new();
    let (dropped, drops) = mpsc::channel();
    let (mut win, answer) = open(executor, move |_| PanicPayload(dropped.clone()));
    let mut task = driver.next();
    assert!(catch_unwind(AssertUnwindSafe(|| task.poll())).is_err());
    deliver(&mut win);
    assert!(win.question_info(answer).unwrap().completion_leased);
    assert!(drops.try_recv().is_err());
    drop(task);
    drops.try_recv().unwrap();
    deliver(&mut win);
    assert!(win.contains_text("WorkerPanicked").unwrap());
    assert_eq!(win.question_info(answer).unwrap().stats.framework_faults, 1);
}

#[test]
fn dependent_input_becoming_pending_or_fault_cancels_its_future() {
    struct Chained {
        input: Signal<u32>,
        first: Reader<String>,
        second: Reader<String>,
    }
    impl Chained {
        const INPUT: Source<Self, u32> =
            Source::new(FieldId::new(1), "input", |m| &m.input, |m| &mut m.input);
    }
    impl View for Chained {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Self::INPUT)
        }
        fn view(&self) -> El<'_> {
            column((
                self.first.project(|s| text(s.as_str())),
                self.second.project(|s| text(s.as_str())),
            ))
        }
    }
    for fault in [false, true] {
        let (send, caps) = mpsc::channel::<gpui::Completion<String, Domain>>();
        let (plan, first) = Questions::new()
            .question(
                Chained::INPUT,
                |i| *i,
                move |_, cap| send.send(cap).map_err(|_| StartError::Closed),
            )
            .unwrap();
        let (executor, driver) = Driver::new();
        let (plan, second) = plan
            .question_future(first, Clone::clone, executor, |_| {
                std::future::pending::<Result<String, Domain>>()
            })
            .unwrap();
        let mut win = Win::with_questions(
            Chained {
                input: Signal::new(1),
                first,
                second,
            },
            plan,
            WindowOptions {
                size: [160, 60],
                ..Default::default()
            },
        )
        .unwrap();
        caps.try_recv()
            .unwrap()
            .complete(Ok("upstream".into()))
            .unwrap();
        win.deliver_ready(8).unwrap();
        let mut task = driver.next();
        assert_eq!(task.poll(), Poll::Pending);
        if fault {
            win.retry(first).unwrap();
            caps.try_recv().unwrap().complete(Err(Domain)).unwrap();
            win.deliver_ready(8).unwrap();
            assert_eq!(win.question_status(second), Ok(QuestionStatus::Fault));
        } else {
            win.set(Chained::INPUT, 2).unwrap();
            assert_eq!(win.question_status(second), Ok(QuestionStatus::Pending));
        }
        assert!(task.control.cancelled.load(Ordering::SeqCst));
        assert!(win.question_info(second).unwrap().completion_leased);
        assert_eq!(task.poll(), Poll::Ready(()));
        win.deliver_ready(8).unwrap();
        driver.empty();
        assert!(!win.question_info(second).unwrap().completion_leased);
    }
}
