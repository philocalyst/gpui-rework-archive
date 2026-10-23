//! Public exact-source contract adversary: separate Signals share mutable data.
use gpui::{
    Completion, El, FieldId, LaneSet, Questions, Reader, Remote, Signal, Source, Sources,
    StartError, View, Win, WindowOptions, text,
};
use std::{
    convert::Infallible,
    sync::{
        Arc,
        atomic::{AtomicU64, Ordering},
        mpsc,
    },
    time::Duration,
};

struct Model {
    left: Signal<Arc<AtomicU64>>,
    right: Signal<Arc<AtomicU64>>,
    answer: Reader<u64>,
}
impl Model {
    const LEFT: Source<Self, Arc<AtomicU64>> =
        Source::new(FieldId::new(1), "left", |m| &m.left, |m| &mut m.left);
    const RIGHT: Source<Self, Arc<AtomicU64>> =
        Source::new(FieldId::new(2), "right", |m| &m.right, |m| &mut m.right);
}
impl View for Model {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::LEFT).direct(Self::RIGHT)
    }
    fn view(&self) -> El<'_> {
        self.answer
            .project(|value| text(format!("captured {value}")))
    }
}
type Job = (u64, Completion<u64, Infallible>);
fn open() -> (
    Win<Model, impl LaneSet<Model>>,
    mpsc::Receiver<Job>,
    Reader<u64>,
) {
    let (send, receive) = mpsc::channel();
    let (questions, answer) = Questions::new()
        .question(
            Model::RIGHT,
            |value| value.load(Ordering::Relaxed),
            move |input, completion| {
                send.send((input, completion))
                    .map_err(|_| StartError::Closed)
            },
        )
        .unwrap();
    let value = Arc::new(AtomicU64::new(0));
    let model = Model {
        left: Signal::new(value.clone()),
        right: Signal::new(value),
        answer,
    };
    let mut win = Win::with_questions(model, questions, WindowOptions::default()).unwrap();
    let (input, completion) = receive.recv_timeout(Duration::from_secs(2)).unwrap();
    assert_eq!(input, 0);
    completion.complete(Ok(input)).unwrap();
    win.deliver_ready(8).unwrap();
    assert!(win.contains_text("captured 0").unwrap());
    (win, receive, answer)
}

#[test]
fn exact_edit_of_one_alias_must_not_leave_the_other_question_ready_with_stale_data() {
    let (win, jobs, reader) = open();
    let (remote, inbox) = Remote::bounded(1);
    let mut win = win
        .with_inbox_for(inbox, Model::LEFT, |value, message| {
            value.store(message, Ordering::Relaxed)
        })
        .unwrap();
    let before = win.question_info(reader).unwrap();
    remote.try_send(1).unwrap();
    win.deliver_ready(8).unwrap();
    assert_eq!(win.read(Model::RIGHT).unwrap().load(Ordering::Relaxed), 1);
    eprintln!(
        "right canonical=1, before={before:?}, after={:?}, stale_visible={}",
        win.question_info(reader),
        win.contains_text("captured 0").unwrap()
    );
    let (input, completion) = jobs
        .recv_timeout(Duration::from_secs(2))
        .expect("the affected canonical right value requires fresh capture");
    assert_eq!(input, 1);
    completion.complete(Ok(input)).unwrap();
    win.deliver_ready(8).unwrap();
    assert!(win.contains_text("captured 1").unwrap());
}

#[test]
fn coarse_edit_of_the_same_shared_value_refreshes_the_question() {
    let (win, jobs, _) = open();
    let (remote, inbox) = Remote::bounded(1);
    let mut win = win
        .with_inbox(inbox, |model, message| {
            model.left.store(message, Ordering::Relaxed)
        })
        .unwrap();
    remote.try_send(1).unwrap();
    win.deliver_ready(8).unwrap();
    assert_eq!(win.read(Model::RIGHT).unwrap().load(Ordering::Relaxed), 1);
    let (input, completion) = jobs
        .recv_timeout(Duration::from_secs(2))
        .expect("coarse ingress recaptures canonical data");
    assert_eq!(input, 1);
    completion.complete(Ok(input)).unwrap();
    win.deliver_ready(8).unwrap();
    assert!(win.contains_text("captured 1").unwrap());
}
