use gpui::{
    Completion, El, FieldId, Questions, Remote, Signal, Source, Sources, StartError, View, Win,
    WindowOptions, text,
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
    left: Signal<Arc<Vec<u64>>>,
    right: Signal<Arc<Vec<u64>>>,
    shared_text: Signal<triomphe::Arc<str>>,
    answer: gpui::Reader<u64>,
}
impl Model {
    const LEFT: Source<Self, Arc<Vec<u64>>> =
        Source::new(FieldId::new(1), "left", |m| &m.left, |m| &mut m.left);
    const RIGHT: Source<Self, Arc<Vec<u64>>> =
        Source::new(FieldId::new(2), "right", |m| &m.right, |m| &mut m.right);
    const TEXT: Source<Self, triomphe::Arc<str>> = Source::new(
        FieldId::new(3),
        "text",
        |m| &m.shared_text,
        |m| &mut m.shared_text,
    );
}
impl View for Model {
    fn sources() -> Sources<Self> {
        Sources::new()
            .field(Self::LEFT)
            .field(Self::RIGHT)
            .field(Self::TEXT)
    }
    fn view(&self) -> El<'_> {
        self.answer
            .project(|value| text(format!("captured {value}")))
    }
}

#[test]
fn immutable_arc_copy_on_write_keeps_peer_data_and_ready_capture_coherent() {
    let (send, receive) = mpsc::channel();
    let (questions, answer) = Questions::new()
        .question(
            Model::RIGHT,
            |value| value[0],
            move |input, completion: Completion<u64, Infallible>| {
                send.send((input, completion))
                    .map_err(|_| StartError::Closed)
            },
        )
        .unwrap();
    let data = Arc::new(vec![0]);
    let model = Model {
        left: Signal::new(data.clone()),
        right: Signal::new(data),
        shared_text: Signal::new(triomphe::Arc::<str>::from("shared")),
        answer,
    };
    let mut win = Win::with_questions(model, questions, WindowOptions::default()).unwrap();
    let (_, completion) = receive.recv_timeout(Duration::from_secs(2)).unwrap();
    completion.complete(Ok(0)).unwrap();
    win.deliver_ready(8).unwrap();
    let before = win.question_info(answer).unwrap();
    let (remote, inbox) = Remote::bounded(1);
    let mut win = win
        .with_inbox_for(inbox, Model::LEFT, |value, message| {
            Arc::make_mut(value)[0] = message
        })
        .unwrap();
    remote.try_send(1).unwrap();
    win.deliver_ready(8).unwrap();
    assert_eq!(win.read(Model::LEFT).unwrap()[0], 1);
    assert_eq!(win.read(Model::RIGHT).unwrap()[0], 0);
    assert_eq!(win.question_info(answer).unwrap(), before);
    assert!(receive.try_recv().is_err());
    assert!(win.contains_text("captured 0").unwrap());
    assert_eq!(&**win.read(Model::TEXT).unwrap(), "shared");
}

#[test]
fn coarse_models_still_allow_shared_mutable_resources() {
    struct Coarse(Signal<Arc<AtomicU64>>);
    impl View for Coarse {
        fn view(&self) -> El<'_> {
            text(format!("value {}", self.0.load(Ordering::Relaxed)))
        }
    }
    let (remote, inbox) = Remote::bounded(1);
    let mut win = Win::demo(Coarse(Signal::new(Arc::new(AtomicU64::new(0)))))
        .with_inbox(inbox, |model, message| {
            model.0.store(message, Ordering::Relaxed)
        })
        .unwrap();
    remote.try_send(1).unwrap();
    win.deliver_ready(1).unwrap();
    assert!(win.contains_text("value 1").unwrap());
}

#[test]
fn immutable_arcstr_leases_allow_exact_replacement_without_changing_a_peer() {
    struct Captions {
        left: Signal<arcstr::ArcStr>,
        right: Signal<arcstr::ArcStr>,
    }
    impl Captions {
        const LEFT: Source<Self, arcstr::ArcStr> =
            Source::new(FieldId::new(1), "left", |m| &m.left, |m| &mut m.left);
        const RIGHT: Source<Self, arcstr::ArcStr> =
            Source::new(FieldId::new(2), "right", |m| &m.right, |m| &mut m.right);
    }
    impl View for Captions {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Self::LEFT).direct(Self::RIGHT)
        }
        fn view(&self) -> El<'_> {
            gpui::div()
        }
    }
    let shared = arcstr::ArcStr::from("shared immutable bytes");
    let (remote, inbox) = Remote::bounded(1);
    let mut win = Win::demo(Captions {
        left: Signal::new(shared.clone()),
        right: Signal::new(shared.clone()),
    })
    .with_inbox_for(inbox, Captions::LEFT, |value, replacement| {
        *value = replacement;
    })
    .unwrap();
    remote
        .try_send(arcstr::ArcStr::from("replacement"))
        .unwrap();
    win.reset_counters().unwrap();
    assert_eq!(win.deliver_ready(1).unwrap().applied, 1);
    assert_eq!(win.read(Captions::LEFT).unwrap().as_str(), "replacement");
    assert_eq!(win.read(Captions::RIGHT).unwrap(), &shared);
    assert_eq!(shared.as_str(), "shared immutable bytes");
    assert_eq!(win.counters().owner_reruns, 0);
}
