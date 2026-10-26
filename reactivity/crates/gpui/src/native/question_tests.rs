//! Actual native wake progression, not a headless callback substitute.
use super::*;
use crate::{
    Completion, El, FieldId, QuestionStatus, Questions, Reader, Signal, Source, Sources,
    StartError, column, text, text_input,
};
use std::{convert::Infallible, sync::mpsc};
use winit::platform::{run_on_demand::EventLoopExtRunOnDemand, x11::EventLoopBuilderExtX11};
struct Search {
    query: Signal<String>,
    theme: Signal<u32>,
    descending: Signal<bool>,
    answer: Reader<String>,
}
impl Search {
    const QUERY: Source<Self, String> =
        Source::new(FieldId::new(1), "query", |m| &m.query, |m| &mut m.query);
    const DESCENDING: Source<Self, bool> = Source::new(
        FieldId::new(3),
        "descending",
        |m| &m.descending,
        |m| &mut m.descending,
    );
    const THEME: Source<Self, u32> =
        Source::new(FieldId::new(2), "theme", |m| &m.theme, |m| &mut m.theme);
}
impl View for Search {
    fn sources() -> Sources<Self> {
        Sources::new()
            .direct(Self::QUERY)
            .direct(Self::THEME)
            .direct(Self::DESCENDING)
    }
    fn view(&self) -> El<'_> {
        column((
            text_input(&self.query).name("Search"),
            text(&self.theme),
            self.answer.project(|value| text(value.as_str())),
        ))
    }
}
struct Script<L: LaneSet<Search>> {
    host: NativeHost<Search, L>,
    first: Option<mpsc::Sender<()>>,
    second: Option<mpsc::Sender<()>>,
    deadline: Instant,
    ready_turns: u64,
    checked: bool,
}
impl<L: LaneSet<Search> + 'static> Host for Script<L> {
    fn dispatch(&mut self, event_loop: &ActiveEventLoop, callback: Callback<'_>) {
        let ready = matches!(callback, Callback::WorkReady);
        let idle = matches!(callback, Callback::AboutToWait);
        self.host.dispatch(event_loop, callback);
        assert!(self.host.error.is_none(), "{:?}", self.host.error);
        if ready {
            self.ready_turns += 1;
            if self.first.is_none()
                && let Some(second) = self.second.take()
            {
                let owner = self.host.owner.as_mut().unwrap();
                owner.set(Search::THEME, 2).unwrap(); // Exact unrelated S must not cancel B.
                second.send(()).unwrap();
            }
        }
        if !idle {
            return;
        }
        assert!(
            Instant::now() < self.deadline,
            "lost question completion/credit wake"
        );
        event_loop.set_control_flow(winit::event_loop::ControlFlow::WaitUntil(self.deadline));
        let Some(owner) = self.host.owner.as_mut() else {
            return;
        };
        let sheet = owner.snapshot().unwrap();
        if !sheet.presentation_valid || sheet.source_epoch != sheet.presentation_epoch {
            return;
        }
        if let Some(first) = self.first.take() {
            owner.set(Search::DESCENDING, true).unwrap();
            owner.set(Search::QUERY, "B".into()).unwrap();
            first.send(()).unwrap();
            return;
        }
        let answer = owner.root().unwrap().answer;
        if owner.question_status(answer).unwrap() != QuestionStatus::Ready {
            return;
        }
        assert!(owner.contains_text("Shown Answer B descending").unwrap());
        assert!(!owner.contains_text("obsolete A").unwrap());
        assert_eq!(*owner.root().unwrap().theme, 2);
        assert!(self.ready_turns >= 3);
        assert!(matches!(
            self.host.graphics,
            Some(Graphics::ReferenceCpu(..))
        ));
        assert!(self.host.instance.is_none());
        self.checked = true;
        event_loop.exit();
    }
}
#[test]
#[ignore = "requires real X11; deadline is only a watchdog, never a delivery poll"]
fn native_question_result_and_credit_wake_without_unrelated_input() {
    type Job = ((String, bool), Completion<String, Infallible>);
    let (send, jobs) = mpsc::sync_channel::<Job>(1);
    let (first, first_wait) = mpsc::channel();
    let (second, second_wait) = mpsc::channel();
    let worker = std::thread::spawn(move || {
        let (input, completion) = jobs.recv().unwrap();
        assert_eq!(input, ("A".to_string(), false));
        first_wait.recv().unwrap();
        // The owner superseded A before releasing this worker. The helper
        // abandons it without executing its compute closure, then WorkReady
        // must retire that physical credit and dispatch B without input polling.
        completion
            .run_cancellable(input, |_, _| panic!("obsolete work must not start"))
            .unwrap();
        let (input, completion) = jobs.recv().unwrap();
        assert_eq!(input, ("B".to_string(), true));
        second_wait.recv().unwrap();
        completion
            .run_cancellable(input, |input, cancellation| {
                assert!(!cancellation.is_cancelled());
                Some(Ok(format!(
                    "Answer {} {}",
                    input.0,
                    if input.1 { "descending" } else { "ascending" }
                )))
            })
            .unwrap();
    });
    let (questions, upstream) = Questions::new()
        .question(
            (Search::QUERY, Search::DESCENDING),
            |(query, descending)| (query.clone(), *descending),
            move |input, completion| {
                send.try_send((input, completion))
                    .map_err(|error| match error {
                        mpsc::TrySendError::Full(_) => StartError::Busy,
                        mpsc::TrySendError::Disconnected(_) => StartError::Closed,
                    })
            },
        )
        .unwrap();
    let (questions, answer) = questions
        .question(
            upstream,
            Clone::clone,
            |input, cap: Completion<String, Infallible>| {
                cap.complete(Ok(format!("Shown {input}"))).unwrap();
                Ok(())
            },
        )
        .unwrap();
    let opening = Window::document(Search {
        query: Signal::new("A".into()),
        theme: Signal::new(1),
        descending: Signal::new(false),
        answer,
    })
    .questions(questions)
    .size(320, 180)
    .renderer(RendererPolicy::ReferenceCpu);
    let mut event_loop = EventLoop::builder()
        .with_x11()
        .with_any_thread(true)
        .build()
        .unwrap();
    let script = Script {
        host: NativeHost::new(opening),
        first: Some(first),
        second: Some(second),
        deadline: Instant::now() + Duration::from_secs(15),
        ready_turns: 0,
        checked: false,
    };
    let (mut driver, wake) = Driver::new(&event_loop, script);
    driver.host_mut().host.wake = Some(wake);
    event_loop.run_app_on_demand(&mut driver).unwrap();
    assert!(driver.host_mut().checked);
    worker.join().unwrap();
}

// This explicit test executor pays for its own thread, pin box, cancellation
// Arc and waker Arc. None are stored in ordinary GPUI question controllers.
struct FutureExecutor;
struct FutureTask {
    cancelled: std::sync::Arc<std::sync::atomic::AtomicBool>,
    thread: std::thread::Thread,
}
impl crate::QuestionTask for FutureTask {
    fn cancel(&mut self) {
        self.cancelled
            .store(true, std::sync::atomic::Ordering::Release);
        self.thread.unpark();
    }
}
impl crate::QuestionExecutor for FutureExecutor {
    type Task = FutureTask;
    fn spawn<F>(&mut self, future: F) -> Result<FutureTask, StartError>
    where
        F: std::future::Future<Output = ()> + Send + 'static,
    {
        use std::sync::{
            Arc,
            atomic::{AtomicBool, Ordering},
        };
        struct ThreadWake(std::thread::Thread);
        impl std::task::Wake for ThreadWake {
            fn wake(self: Arc<Self>) {
                self.0.unpark();
            }
            fn wake_by_ref(self: &Arc<Self>) {
                self.0.unpark();
            }
        }
        let cancelled = Arc::new(AtomicBool::new(false));
        let abort = cancelled.clone();
        let task = std::thread::Builder::new()
            .name("question-future-test".into())
            .spawn(move || {
                let waker = std::task::Waker::from(Arc::new(ThreadWake(std::thread::current())));
                let mut future = std::pin::pin!(future);
                loop {
                    if abort.load(Ordering::Acquire) {
                        break;
                    }
                    if future
                        .as_mut()
                        .poll(&mut std::task::Context::from_waker(&waker))
                        .is_ready()
                    {
                        break;
                    }
                    // park/unpark's retained token closes cancel-before-park.
                    std::thread::park();
                }
            })
            .map_err(|_| StartError::Closed)?;
        Ok(FutureTask {
            cancelled,
            thread: task.thread().clone(),
        })
    }
}
struct FutureScript<L: LaneSet<Search>> {
    host: NativeHost<Search, L>,
    superseded: bool,
    checked: bool,
    deadline: Instant,
}
impl<L: LaneSet<Search> + 'static> Host for FutureScript<L> {
    fn dispatch(&mut self, event_loop: &ActiveEventLoop, callback: Callback<'_>) {
        let idle = matches!(callback, Callback::AboutToWait);
        self.host.dispatch(event_loop, callback);
        assert!(self.host.error.is_none(), "{:?}", self.host.error);
        if !idle {
            return;
        }
        assert!(
            Instant::now() < self.deadline,
            "lost future cancellation/result wake"
        );
        event_loop.set_control_flow(winit::event_loop::ControlFlow::WaitUntil(self.deadline));
        let Some(owner) = self.host.owner.as_mut() else {
            return;
        };
        let sheet = owner.snapshot().unwrap();
        if !sheet.presentation_valid || sheet.source_epoch != sheet.presentation_epoch {
            return;
        }
        if !self.superseded {
            self.superseded = true;
            owner.set(Search::DESCENDING, true).unwrap();
            owner.set(Search::QUERY, "B".into()).unwrap();
            return;
        }
        let answer = owner.root().unwrap().answer;
        if owner.question_status(answer).unwrap() != QuestionStatus::Ready {
            return;
        }
        assert!(owner.contains_text("Future Answer B descending").unwrap());
        assert_eq!(owner.question_info(answer).unwrap().stats.dispatched, 2);
        assert!(matches!(
            self.host.graphics,
            Some(Graphics::ReferenceCpu(..))
        ));
        assert!(self.host.instance.is_none());
        self.checked = true;
        event_loop.exit();
    }
}
#[test]
#[ignore = "requires real X11; deadline is a watchdog, never a completion delivery poll"]
fn native_future_cancellation_and_result_wake_without_unrelated_input() {
    let (questions, answer) = Questions::new()
        .question_future(
            (Search::QUERY, Search::DESCENDING),
            |(query, descending)| (query.clone(), *descending),
            FutureExecutor,
            |(query, descending)| async move {
                if query == "A" {
                    std::future::pending::<()>().await;
                }
                Ok::<_, Infallible>(format!(
                    "Future Answer {query} {}",
                    if descending {
                        "descending"
                    } else {
                        "ascending"
                    }
                ))
            },
        )
        .unwrap();
    let opening = Window::document(Search {
        query: Signal::new("A".into()),
        theme: Signal::new(1),
        descending: Signal::new(false),
        answer,
    })
    .questions(questions)
    .size(320, 180)
    .renderer(RendererPolicy::ReferenceCpu);
    let mut event_loop = EventLoop::builder()
        .with_x11()
        .with_any_thread(true)
        .build()
        .unwrap();
    let script = FutureScript {
        host: NativeHost::new(opening),
        superseded: false,
        checked: false,
        deadline: Instant::now() + Duration::from_secs(15),
    };
    let (mut driver, wake) = Driver::new(&event_loop, script);
    driver.host_mut().host.wake = Some(wake);
    event_loop.run_app_on_demand(&mut driver).unwrap();
    assert!(driver.host_mut().checked);
}
