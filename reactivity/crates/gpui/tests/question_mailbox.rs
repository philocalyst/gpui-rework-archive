use gpui::{Completion, Questions, Reader, WindowOptions, prelude::*};
use std::{
    convert::Infallible,
    sync::{
        Arc,
        atomic::{AtomicUsize, Ordering},
        mpsc,
    },
};
struct Resource(Arc<AtomicUsize>);
impl Drop for Resource {
    fn drop(&mut self) {
        self.0.fetch_add(1, Ordering::SeqCst);
    }
}
struct Model {
    input: Signal<u64>,
    answer: Reader<Resource>,
}
impl Model {
    const INPUT: Source<Self, u64> =
        Source::new(FieldId::new(1), "input", |m| &m.input, |m| &mut m.input);
}
impl View for Model {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::INPUT)
    }
    fn view(&self) -> El<'_> {
        self.answer.project(|_| text("ready resource"))
    }
}
fn open() -> (
    Win<Model, impl gpui::LaneSet<Model>>,
    mpsc::Receiver<Completion<Resource, Infallible>>,
) {
    let (send, jobs) = mpsc::channel();
    let (questions, answer) = Questions::new()
        .question(
            Model::INPUT,
            |value| *value,
            move |_, cap| {
                send.send(cap).unwrap();
                Ok(())
            },
        )
        .unwrap();
    let win = Win::with_questions(
        Model {
            input: Signal::new(1),
            answer,
        },
        questions,
        WindowOptions::default(),
    )
    .unwrap();
    (win, jobs)
}
#[test]
fn a_frozen_question_response_drops_once_when_an_earlier_model_callback_panics() {
    let (win, jobs) = open();
    let (remote, inbox) = Remote::bounded(1);
    let mut win = win
        .with_inbox(inbox, |_: &mut Model, (): ()| {
            panic!("owner fault before question apply")
        })
        .unwrap();
    let drops = Arc::new(AtomicUsize::new(0));
    jobs.recv()
        .unwrap()
        .complete(Ok(Resource(drops.clone())))
        .unwrap();
    remote.try_send(()).unwrap();
    assert_eq!(
        win.deliver_ready(8).unwrap_err().error,
        gpui::Error::OwnerPanicked
    );
    assert_eq!(drops.load(Ordering::SeqCst), 1);
    drop(win);
    assert_eq!(drops.load(Ordering::SeqCst), 1);
}
#[test]
fn close_releases_ready_state_and_a_late_physical_cap_returns_its_owned_resource() {
    let (mut win, jobs) = open();
    let drops = Arc::new(AtomicUsize::new(0));
    jobs.recv()
        .unwrap()
        .complete(Ok(Resource(drops.clone())))
        .unwrap();
    win.deliver_ready(8).unwrap();
    win.set(Model::INPUT, 2).unwrap();
    let late = jobs.recv().unwrap();
    win.close();
    assert!(late.is_cancelled());
    assert_eq!(drops.load(Ordering::SeqCst), 1);
    let returned = late
        .complete(Ok(Resource(drops.clone())))
        .unwrap_err()
        .into_value()
        .unwrap();
    assert_eq!(drops.load(Ordering::SeqCst), 1);
    drop(returned);
    drop(win);
    assert_eq!(drops.load(Ordering::SeqCst), 2);
}

#[test]
fn a_staged_response_stays_owned_until_callbacks_supersede_it_and_apply_retires_it() {
    let (win, jobs) = open();
    let drops = Arc::new(AtomicUsize::new(0));
    let during_callback = drops.clone();
    let (remote, inbox) = Remote::bounded(1);
    let mut win = win
        .with_inbox(inbox, move |model: &mut Model, (): ()| {
            // Staging has frozen readiness, and the old result is still owned.
            assert_eq!(during_callback.load(Ordering::SeqCst), 0);
            model.input = Signal::new(2);
        })
        .unwrap();
    jobs.recv()
        .unwrap()
        .complete(Ok(Resource(drops.clone())))
        .unwrap();
    remote.try_send(()).unwrap();
    let delivery = win.deliver_ready(8).unwrap();
    assert_eq!(
        delivery.applied, 1,
        "only the normal model edit was admitted"
    );
    assert_eq!(
        drops.load(Ordering::SeqCst),
        1,
        "obsolete response retired once"
    );
    assert!(!win.contains_text("ready resource").unwrap());
    let current = jobs
        .try_recv()
        .expect("newest input starts in this same turn");
    assert!(!current.is_cancelled());
    current.complete(Ok(Resource(drops.clone()))).unwrap();
    assert_eq!(win.deliver_ready(8).unwrap().applied, 1);
    assert!(win.contains_text("ready resource").unwrap());
    assert_eq!(drops.load(Ordering::SeqCst), 1);
    win.close();
    assert_eq!(drops.load(Ordering::SeqCst), 2);
}
