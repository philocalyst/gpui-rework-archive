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
    answer: Reader<String>,
}
impl Search {
    const QUERY: Source<Self, String> =
        Source::new(FieldId::new(1), "query", |m| &m.query, |m| &mut m.query);
    const THEME: Source<Self, u32> =
        Source::new(FieldId::new(2), "theme", |m| &m.theme, |m| &mut m.theme);
}
impl View for Search {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::QUERY).direct(Self::THEME)
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
            owner.set(Search::QUERY, "B".into()).unwrap();
            first.send(()).unwrap();
            return;
        }
        let answer = owner.root().unwrap().answer;
        if owner.question_status(answer).unwrap() != QuestionStatus::Ready {
            return;
        }
        assert!(owner.contains_text("Answer B").unwrap());
        assert!(!owner.contains_text("obsolete A").unwrap());
        assert_eq!(*owner.root().unwrap().theme, 2);
        assert!(self.ready_turns >= 2);
        assert!(matches!(
            self.host.graphics,
            Some(Graphics::ReferenceCpu(_))
        ));
        assert!(self.host.instance.is_none());
        self.checked = true;
        event_loop.exit();
    }
}
#[test]
#[ignore = "requires real X11; deadline is only a watchdog, never a delivery poll"]
fn native_question_result_and_credit_wake_without_unrelated_input() {
    type Job = (String, Completion<String, Infallible>);
    let (send, jobs) = mpsc::sync_channel::<Job>(1);
    let (first, first_wait) = mpsc::channel();
    let (second, second_wait) = mpsc::channel();
    let worker = std::thread::spawn(move || {
        let (input, completion) = jobs.recv().unwrap();
        assert_eq!(input, "A");
        first_wait.recv().unwrap();
        // The owner superseded A before releasing this worker. The helper
        // abandons it without executing its compute closure, then WorkReady
        // must retire that physical credit and dispatch B without input polling.
        completion
            .run_cancellable(input, |_, _| panic!("obsolete work must not start"))
            .unwrap();
        let (input, completion) = jobs.recv().unwrap();
        assert_eq!(input, "B");
        second_wait.recv().unwrap();
        completion
            .run_cancellable(input, |input, cancellation| {
                assert!(!cancellation.is_cancelled());
                Some(Ok(format!("Answer {input}")))
            })
            .unwrap();
    });
    let (questions, answer) = Questions::new()
        .question(Search::QUERY, Clone::clone, move |input, completion| {
            send.try_send((input, completion))
                .map_err(|error| match error {
                    mpsc::TrySendError::Full(_) => StartError::Busy,
                    mpsc::TrySendError::Disconnected(_) => StartError::Closed,
                })
        })
        .unwrap();
    let opening = Window::document(Search {
        query: Signal::new("A".into()),
        theme: Signal::new(1),
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
