use gpui::{Completion, Error, QuestionStatus, Questions, StartError, WindowOptions, prelude::*};
use std::{fmt, sync::mpsc};

#[derive(Debug, PartialEq, Eq)]
struct Domain(&'static str);
impl fmt::Display for Domain {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_str(self.0)
    }
}
impl std::error::Error for Domain {}
struct Model {
    caption: String,
    query: Signal<String>,
    theme: Signal<u32>,
    broken: Signal<bool>,
    answer: gpui::Reader<String>,
}
impl Model {
    const QUERY: Source<Self, String> =
        Source::new(FieldId::new(1), "query", |m| &m.query, |m| &mut m.query);
    const THEME: Source<Self, u32> =
        Source::new(FieldId::new(2), "theme", |m| &m.theme, |m| &mut m.theme);
    const BROKEN: Source<Self, bool> =
        Source::new(FieldId::new(3), "broken", |m| &m.broken, |m| &mut m.broken);
}
fn pane(reader: gpui::Reader<String>) -> El<'static> {
    reader
        .project(|value| text(value.as_str()))
        .loading(|| text("Searching"))
        .failed(|failure| text(format!("Search problem: {failure}")))
}
impl View for Model {
    fn sources() -> Sources<Self> {
        Sources::new()
            .direct(Self::QUERY)
            .direct(Self::THEME)
            .field(Self::BROKEN)
    }
    fn view(&self) -> El<'_> {
        column((
            text(if *self.broken { "漢" } else { &self.caption }),
            text_input(&self.query).name("Search"),
            text(&self.theme),
            pane(self.answer),
        ))
        .gap(4)
    }
}
type Job = (String, Completion<String, Domain>);
fn open() -> (
    Win<Model, impl gpui::LaneSet<Model>>,
    mpsc::Receiver<Job>,
    gpui::Reader<String>,
) {
    open_mode(true)
}
fn open_mode(
    automatic: bool,
) -> (
    Win<Model, impl gpui::LaneSet<Model>>,
    mpsc::Receiver<Job>,
    gpui::Reader<String>,
) {
    let (send, receive) = mpsc::channel();
    let (questions, answer) = Questions::new()
        .question(Model::QUERY, Clone::clone, move |input, completion| {
            send.send((input, completion))
                .map_err(|_| StartError::Closed)
        })
        .unwrap();
    let model = Model {
        caption: "Caption".into(),
        query: Signal::new("A".into()),
        theme: Signal::new(1),
        broken: Signal::new(false),
        answer,
    };
    let options = WindowOptions {
        size: [320, 180],
        ..Default::default()
    };
    let win = if automatic {
        Win::with_questions(model, questions, options)
    } else {
        Win::recording_questions(model, questions, options)
    }
    .unwrap();
    (win, receive, answer)
}
#[test]
fn queued_model_callback_supersedes_a_completion_in_the_same_batch() {
    let (win, jobs, answer) = open();
    let (remote, inbox) = gpui::Remote::bounded(1);
    let mut win = win
        .with_inbox(inbox, |model, (): ()| model.query = Signal::new("B".into()))
        .unwrap();
    let (_, old) = jobs.recv().unwrap();
    old.complete(Ok("obsolete A".into())).unwrap();
    remote.try_send(()).unwrap();
    let delivery = win.deliver_ready(8).unwrap();
    assert_eq!(delivery.applied, 1);
    assert_eq!(win.question_status(answer), Ok(QuestionStatus::Pending));
    assert!(!win.contains_text("obsolete A").unwrap());
    let (input, current) = jobs.recv().unwrap();
    assert_eq!(input, "B");
    current.complete(Ok("current B".into())).unwrap();
    drain(&mut win);
    assert!(win.contains_text("current B").unwrap());
}

#[test]
fn cancellable_none_faults_current_work_but_frees_superseded_credit_without_faulting_newer_work() {
    let (mut win, jobs, answer) = open();
    let (_, current) = jobs.recv().unwrap();
    current
        .run_cancellable((), |_, cancellation| {
            assert!(!cancellation.is_cancelled());
            None
        })
        .unwrap();
    drain(&mut win);
    assert_eq!(win.question_status(answer), Ok(QuestionStatus::Fault));
    assert!(win.contains_text("Abandoned").unwrap());

    win.retry(answer).unwrap();
    let (_, old) = jobs.recv().unwrap();
    let (started, entered) = mpsc::channel();
    let (resume, wait) = mpsc::channel();
    let worker = std::thread::spawn(move || {
        old.run_cancellable((), |_, cancellation| {
            started.send(()).unwrap();
            wait.recv().unwrap();
            assert!(cancellation.is_cancelled());
            None
        })
        .unwrap();
    });
    entered.recv().unwrap();
    win.set(Model::QUERY, "B".into()).unwrap();
    let before = win.question_info(answer).unwrap();
    assert!(before.completion_leased);
    assert!(
        jobs.try_recv().is_err(),
        "physical credit is still occupied"
    );
    resume.send(()).unwrap();
    worker.join().unwrap();
    win.deliver_ready(8).unwrap();
    assert_eq!(win.question_status(answer), Ok(QuestionStatus::Pending));
    let (input, current) = jobs
        .try_recv()
        .expect("newest input starts after retirement");
    assert_eq!(input, "B");
    current
        .run_cancellable(input, |input, cancellation| {
            assert!(!cancellation.is_cancelled());
            Some(Ok(format!("Answer {input}")))
        })
        .unwrap();
    drain(&mut win);
    assert_eq!(win.question_status(answer), Ok(QuestionStatus::Ready));
    assert!(win.contains_text("Answer B").unwrap());
}

#[test]
fn cancellable_worker_panic_and_owner_close_keep_their_distinct_lifecycle() {
    let (mut win, jobs, answer) = open();
    jobs.recv()
        .unwrap()
        .1
        .run_cancellable((), |_, _| panic!("cancellable worker panic"))
        .unwrap();
    drain(&mut win);
    assert_eq!(win.question_status(answer), Ok(QuestionStatus::Fault));
    assert!(win.contains_text("WorkerPanicked").unwrap());
    win.retry(answer).unwrap();
    let (_, current) = jobs.recv().unwrap();
    let (started, entered) = mpsc::channel();
    let (resume, wait) = mpsc::channel();
    let worker = std::thread::spawn(move || {
        let value = String::from("same owned closed result");
        let pointer = value.as_ptr() as usize;
        let result = current.run_cancellable(value, |value, cancellation| {
            started.send(()).unwrap();
            wait.recv().unwrap();
            assert!(
                !cancellation.is_cancelled(),
                "unrelated exact edit is not cancellation"
            );
            started.send(()).unwrap();
            wait.recv().unwrap();
            assert!(cancellation.is_cancelled());
            // An advisory hint cannot force cooperative code to stop. Closed
            // must still return the exact owned result when it ignores the hint.
            Some(Ok(value))
        });
        let value = result.unwrap_err().into_value().unwrap();
        assert_eq!(value.as_ptr() as usize, pointer);
    });
    entered.recv().unwrap();
    win.set(Model::THEME, 2).unwrap();
    resume.send(()).unwrap();
    entered.recv().unwrap();
    win.close();
    resume.send(()).unwrap();
    worker.join().unwrap();
}
#[test]
fn forwarded_reader_projection_routes_new_controls_to_the_contained_child() {
    struct Child {
        answer: gpui::Reader<String>,
        count: u32,
    }
    impl Child {
        fn bump(&mut self) {
            self.count += 1;
        }
    }
    impl View for Child {
        fn view(&self) -> El<'_> {
            column((
                text(self.count.to_string()),
                self.answer.project(|value| {
                    column((
                        text(value.as_str()),
                        button("Bump child").on_click(Child::bump),
                    ))
                }),
            ))
        }
    }
    struct Parent {
        input: Signal<String>,
        child: Child,
    }
    impl Parent {
        const INPUT: Source<Self, String> =
            Source::new(FieldId::new(1), "input", |m| &m.input, |m| &mut m.input);
        const CHILD: gpui::Component<Self, Child> =
            gpui::Component::new(FieldId::new(2), "child", |m| &m.child, |m| &mut m.child);
    }
    impl View for Parent {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Self::INPUT).component(Self::CHILD)
        }
        fn view(&self) -> El<'_> {
            Self::CHILD.view(self)
        }
    }
    let (send, jobs) = mpsc::channel::<Job>();
    let (questions, answer) = Questions::new()
        .question(Parent::INPUT, Clone::clone, move |input, cap| {
            send.send((input, cap)).unwrap();
            Ok(())
        })
        .unwrap();
    let mut win = Win::with_questions(
        Parent {
            input: Signal::new("A".into()),
            child: Child { answer, count: 0 },
        },
        questions,
        WindowOptions::default(),
    )
    .unwrap();
    jobs.recv()
        .unwrap()
        .1
        .complete(Ok("Child answer".into()))
        .unwrap();
    drain(&mut win);
    let control = win.button("Bump child");
    win.activate(control).unwrap();
    assert_eq!(win.root().unwrap().child.count, 1);
    assert_eq!(win.button("Bump child"), control);
}
#[test]
fn prepared_question_sheet_and_old_presentation_remain_frozen_until_acknowledged() {
    let (mut win, jobs, answer) = open_mode(false);
    let initial = win.with_scene(|_, token| token).unwrap();
    win.presented(initial).unwrap();
    let (_, first) = jobs.recv().unwrap();
    first.complete(Ok("answer A".into())).unwrap();
    win.deliver_ready(8).unwrap();
    let coherent = win.with_scene(|_, token| token).unwrap();
    assert!(win.contains_text("Searching").unwrap());
    assert!(!win.contains_text("answer A").unwrap());
    // New source state fails visual preparation. The earlier complete answer
    // candidate must retain its own sheet and may still be acknowledged.
    assert!(win.set(Model::BROKEN, true).is_err());
    assert_eq!(win.with_scene(|_, token| token).unwrap(), coherent);
    win.presented(coherent).unwrap();
    assert!(win.contains_text("answer A").unwrap());
    assert_eq!(win.question_status(answer), Ok(QuestionStatus::Ready));
    assert!(win.snapshot().unwrap().source_epoch > win.snapshot().unwrap().presentation_epoch);
}
fn drain<M: View + 'static, L: gpui::LaneSet<M>>(win: &mut Win<M, L>) {
    for _ in 0..8 {
        if !win.deliver_ready(8).unwrap().more {
            return;
        }
    }
    panic!("finite ingress did not become idle");
}
#[test]
fn failed_mount_never_dispatches_a_prepared_question() {
    let (send, jobs) = mpsc::channel::<Job>();
    let (questions, answer) = Questions::new()
        .question(Model::QUERY, Clone::clone, move |input, completion| {
            send.send((input, completion))
                .map_err(|_| StartError::Closed)
        })
        .unwrap();
    let result = Win::with_questions(
        Model {
            caption: "Caption".into(),
            query: Signal::new("A".into()),
            theme: Signal::new(0),
            broken: Signal::new(true),
            answer,
        },
        questions,
        WindowOptions::default(),
    );
    assert!(matches!(result, Err(Error::Canvas(_))));
    assert!(matches!(
        jobs.try_recv(),
        Err(mpsc::TryRecvError::Disconnected)
    ));
}
#[test]
fn ordinary_owner_drop_cancels_an_outstanding_cap_and_closes_its_payload_lane() {
    let (win, jobs, _) = open();
    let (_, completion) = jobs.recv().unwrap();
    drop(win);
    assert!(completion.is_cancelled());
    assert!(matches!(
        completion.complete(Ok("late".into())),
        Err(gpui::CompleteError::Closed(_))
    ));
}
#[test]
fn ready_is_borrowed_only_after_the_production_barrier_and_unrelated_exact_edits_do_not_cancel() {
    let (mut win, jobs, answer) = open();
    assert_eq!(win.question_status(answer), Ok(QuestionStatus::Pending));
    assert!(win.contains_text("Searching").unwrap());
    let (input, completion) = jobs
        .recv_timeout(std::time::Duration::from_secs(1))
        .unwrap();
    assert_eq!(input, "A");
    win.set(Model::THEME, 2).unwrap();
    assert!(!completion.is_cancelled());
    completion.complete(Ok("Answer A".into())).unwrap();
    assert_eq!(win.with_ready(answer, String::len).unwrap(), None);
    let delivery = win.deliver_ready(8).unwrap();
    assert_eq!(delivery.applied, 1);
    assert_eq!(win.with_ready(answer, String::len).unwrap(), Some(8));
    assert!(win.contains_text("Answer A").unwrap());
    let epoch = delivery.commit.source_epoch;
    assert_eq!(win.deliver_ready(8).unwrap().commit.source_epoch, epoch);
    assert!(jobs.try_recv().is_err());
}
#[test]
fn a_b_a_coalesces_one_latest_snapshot_but_never_admits_the_first_a() {
    let (mut win, jobs, answer) = open();
    let (_, first) = jobs
        .recv_timeout(std::time::Duration::from_secs(1))
        .unwrap();
    win.set(Model::QUERY, "B".into()).unwrap();
    win.set(Model::QUERY, "A".into()).unwrap();
    assert!(first.is_cancelled());
    assert!(jobs.try_recv().is_err());
    first.complete(Ok("obsolete A".into())).unwrap();
    let epoch = win.snapshot().unwrap().source_epoch;
    let delivery = win.deliver_ready(8).unwrap();
    assert_eq!(delivery.applied, 0);
    assert_eq!(delivery.commit.source_epoch, epoch);
    assert_eq!(win.question_status(answer), Ok(QuestionStatus::Pending));
    drain(&mut win);
    let (input, current) = jobs
        .recv_timeout(std::time::Duration::from_secs(1))
        .unwrap();
    assert_eq!(input, "A");
    current.complete(Ok("current A".into())).unwrap();
    drain(&mut win);
    assert!(win.contains_text("current A").unwrap());
    assert!(!win.contains_text("obsolete A").unwrap());
}
#[test]
fn coarse_owner_signal_replacement_supersedes_equal_revision_and_value() {
    let (mut win, jobs, answer) = open();
    let (_, old) = jobs
        .recv_timeout(std::time::Duration::from_secs(1))
        .unwrap();
    win.update(|m| m.query = Signal::new("A".into())).unwrap();
    old.complete(Ok("old".into())).unwrap();
    drain(&mut win);
    assert_eq!(win.question_status(answer), Ok(QuestionStatus::Pending));
    let (_, new) = jobs
        .recv_timeout(std::time::Duration::from_secs(1))
        .unwrap();
    new.complete(Ok("replacement".into())).unwrap();
    drain(&mut win);
    assert!(win.contains_text("replacement").unwrap());
}
#[test]
fn accepted_answer_survives_presentation_failure_and_repairs_without_reacceptance() {
    let (mut win, jobs, answer) = open();
    let (_, completion) = jobs
        .recv_timeout(std::time::Duration::from_secs(1))
        .unwrap();
    assert!(win.set(Model::BROKEN, true).is_err());
    assert!(!completion.is_cancelled());
    completion.complete(Ok("retained answer".into())).unwrap();
    let failure = win.deliver_ready(8).unwrap_err();
    assert!(matches!(failure.error, Error::Canvas(_)));
    assert_eq!(failure.delivery.unwrap().applied, 1);
    assert_eq!(win.question_status(answer), Ok(QuestionStatus::Ready));
    assert_eq!(
        win.with_ready(answer, |value| value.clone()).unwrap(),
        Some("retained answer".into())
    );
    assert!(!win.contains_text("retained answer").unwrap());
    win.set(Model::BROKEN, false).unwrap();
    assert!(win.contains_text("retained answer").unwrap());
    assert!(jobs.try_recv().is_err());
}
#[test]
fn abandonment_and_domain_faults_are_distinct_and_retries_heal() {
    let (mut win, jobs, answer) = open();
    let (_, completion) = jobs
        .recv_timeout(std::time::Duration::from_secs(1))
        .unwrap();
    drop(completion);
    drain(&mut win);
    assert_eq!(win.question_status(answer), Ok(QuestionStatus::Fault));
    assert!(win.contains_text("Abandoned").unwrap());
    win.retry(answer).unwrap();
    let (_, completion) = jobs
        .recv_timeout(std::time::Duration::from_secs(1))
        .unwrap();
    completion
        .complete(Err(Domain("catalogue offline")))
        .unwrap();
    drain(&mut win);
    assert!(win.contains_text("catalogue offline").unwrap());
    assert!(!win.snapshot().unwrap().poisoned);
    win.retry(answer).unwrap();
    let (_, completion) = jobs
        .recv_timeout(std::time::Duration::from_secs(1))
        .unwrap();
    completion.run((), |_| Ok("healed".into())).unwrap();
    drain(&mut win);
    assert!(win.contains_text("healed").unwrap());
}
#[test]
fn old_delayed_drop_cannot_fault_the_latest_ticket_or_release_credit_early() {
    let (mut win, jobs, answer) = open();
    let (_, old) = jobs
        .recv_timeout(std::time::Duration::from_secs(1))
        .unwrap();
    win.set(Model::QUERY, "B".into()).unwrap();
    assert!(jobs.try_recv().is_err());
    drop(old);
    drain(&mut win);
    assert_eq!(win.question_status(answer), Ok(QuestionStatus::Pending));
    let (query, new) = jobs
        .recv_timeout(std::time::Duration::from_secs(1))
        .unwrap();
    assert_eq!(query, "B");
    new.complete(Ok("B answer".into())).unwrap();
    drain(&mut win);
    assert_eq!(win.question_status(answer), Ok(QuestionStatus::Ready));
}
#[test]
fn completion_and_terminal_queued_before_ack_start_pending_b_in_that_same_turn() {
    let (mut win, jobs, _) = open();
    let (_, first) = jobs
        .recv_timeout(std::time::Duration::from_secs(1))
        .unwrap();
    win.set(Model::QUERY, "B".into()).unwrap();
    // Both Remote's payload wake and the terminal wake precede owner delivery.
    first.complete(Ok("obsolete A".into())).unwrap();
    let delivery = win.deliver_ready(8).unwrap();
    assert_eq!(delivery.received, 1);
    assert_eq!(delivery.applied, 0);
    assert!(!delivery.more);
    let (input, second) = jobs
        .try_recv()
        .expect("returned credit starts B without another event");
    assert_eq!(input, "B");
    second.complete(Ok("B".into())).unwrap();
    drain(&mut win);
    assert!(win.contains_text("B").unwrap());
}
#[test]
fn start_error_which_retains_a_cap_cancels_it_without_fabricating_free_credit() {
    let (send, jobs) = mpsc::channel::<Job>();
    let (questions, answer) = Questions::new()
        .question(Model::QUERY, Clone::clone, move |input, completion| {
            send.send((input, completion)).unwrap();
            Err(StartError::Busy)
        })
        .unwrap();
    let mut win = Win::with_questions(
        Model {
            caption: "Caption".into(),
            query: Signal::new("A".into()),
            theme: Signal::new(1),
            broken: Signal::new(false),
            answer,
        },
        questions,
        WindowOptions::default(),
    )
    .unwrap();
    let (_, old) = jobs.try_recv().unwrap();
    assert!(old.is_cancelled());
    assert_eq!(win.question_status(answer), Ok(QuestionStatus::Fault));
    win.retry(answer).unwrap();
    assert!(jobs.try_recv().is_err());
    drop(old);
    drain(&mut win);
    let (_, new) = jobs
        .try_recv()
        .expect("credit returned by the actual old cap");
    assert!(new.is_cancelled());
    drop(new);
    drain(&mut win);
    assert_eq!(win.question_status(answer), Ok(QuestionStatus::Fault));
}
#[test]
fn close_returns_same_owned_outcome_and_reminted_foreign_readers_are_revoked() {
    let (mut win, jobs, reader) = open();
    let (_, completion) = jobs
        .recv_timeout(std::time::Duration::from_secs(1))
        .unwrap();
    win.close();
    let payload = String::from("owned allocation");
    let ptr = payload.as_ptr();
    let rejected = completion
        .complete(Ok(payload))
        .unwrap_err()
        .into_value()
        .unwrap();
    assert_eq!(rejected.as_ptr(), ptr);
    let (mut other, jobs, _) = open();
    assert_eq!(
        other.question_status(reader),
        Err(Error::Question(gpui::QuestionFault::Revoked))
    );
    let old = other.root().unwrap().answer;
    other.update(|m| m.answer = reader).unwrap();
    assert!(other.contains_text("Question revoked").unwrap());
    assert_eq!(other.question_status(old), Ok(QuestionStatus::Pending));
    drop(jobs);
}
#[test]
fn worker_panic_is_a_question_fault_and_does_not_quarantine_the_owner() {
    let (mut win, jobs, answer) = open();
    let (_, completion) = jobs
        .recv_timeout(std::time::Duration::from_secs(1))
        .unwrap();
    completion.run((), |_| panic!("worker panic")).unwrap();
    drain(&mut win);
    assert_eq!(win.question_status(answer), Ok(QuestionStatus::Fault));
    assert!(!win.snapshot().unwrap().poisoned);
    win.retry(answer).unwrap();
    let (_, completion) = jobs
        .recv_timeout(std::time::Duration::from_secs(1))
        .unwrap();
    completion.complete(Ok("recovered".into())).unwrap();
    drain(&mut win);
    assert!(win.contains_text("recovered").unwrap());
}
