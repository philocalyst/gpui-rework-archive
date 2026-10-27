//! Typed worker ingress uses ordinary source admission and owner turns.
use gpui::{
    BindError, Completion, Component, El, Error, FieldId, Questions, Remote, SendError, Signal,
    Source, Sources, StartError, View, Win, WindowOptions, column, text, text_input,
};
use std::{sync::mpsc, time::Duration};

struct Panel {
    left: Signal<String>,
    right: Signal<String>,
}
impl Panel {
    const LEFT: Source<Self, String> =
        Source::new(FieldId::new(1), "left", |m| &m.left, |m| &mut m.left);
    const RIGHT: Source<Self, String> =
        Source::new(FieldId::new(2), "right", |m| &m.right, |m| &mut m.right);
    fn new() -> Self {
        Self {
            left: Signal::new("seed".into()),
            right: Signal::new("peer".into()),
        }
    }
}
impl View for Panel {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::LEFT).direct(Self::RIGHT)
    }
    fn view(&self) -> El<'_> {
        column((text_input(&self.left).w(100), text(&self.right)))
    }
}

#[test]
fn same_field_batches_patch_once_and_keep_callback_inference_and_mutable_captures() {
    let (remote, inbox) = Remote::bounded(8);
    let mut sequence = 0;
    let left = &Panel::LEFT;
    let mut win = Win::demo(Panel::new())
        .with_inbox_for(inbox, left, move |value, message| {
            sequence += 1;
            *value = format!("{message}-{sequence}");
        })
        .unwrap();
    remote.try_send("first").unwrap();
    remote.try_send("last").unwrap();
    win.reset_counters().unwrap();
    let delivery = win.deliver_ready(8).unwrap();
    assert_eq!((delivery.received, delivery.applied), (2, 2));
    assert_eq!(delivery.commit.source_epoch, 1);
    assert_eq!(&**win.read(Panel::LEFT).unwrap(), "last-2");
    assert!(win.contains_text("last-2").unwrap());
    assert_eq!(win.counters().source_operations, 1);
    assert_eq!(win.counters().exact_updates, 1);
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(win.counters().paint_passes, 1);
    win.reset_counters().unwrap();
    assert_eq!(win.deliver_ready(0).unwrap().applied, 0);
    assert_eq!(win.deliver_ready(8).unwrap().applied, 0);
    assert_eq!(win.counters(), gpui::Counters::default());
}

#[test]
fn two_lanes_for_one_field_share_the_exact_grain() {
    let (a, ai) = Remote::bounded(2);
    let (b, bi) = Remote::bounded(2);
    let mut win = Win::demo(Panel::new())
        .with_inbox_for(ai, Panel::LEFT, |value, message: &str| {
            value.push_str(message)
        })
        .unwrap()
        .with_inbox_for(bi, Panel::LEFT, |value, message: &str| {
            value.push_str(message)
        })
        .unwrap();
    a.try_send("a").unwrap();
    b.try_send("b").unwrap();
    win.reset_counters().unwrap();
    assert_eq!(win.deliver_ready(8).unwrap().applied, 2);
    assert_eq!(&**win.read(Panel::LEFT).unwrap(), "seedba");
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(win.counters().exact_updates, 1);
}

#[test]
fn distinct_visual_fields_patch_together_and_opaque_callbacks_keep_one_conservative_barrier() {
    let (a, ai) = Remote::bounded(2);
    let (b, bi) = Remote::bounded(2);
    let mut win = Win::demo(Panel::new())
        .with_inbox_for(ai, Panel::LEFT, |value, message| *value = message)
        .unwrap()
        .with_inbox_for(bi, Panel::RIGHT, |value, message| *value = message)
        .unwrap();
    a.try_send("left".into()).unwrap();
    b.try_send("right".into()).unwrap();
    win.reset_counters().unwrap();
    assert_eq!(win.deliver_ready(8).unwrap().applied, 2);
    assert!(win.contains_text("left").unwrap());
    assert!(win.contains_text("right").unwrap());
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(win.counters().source_operations, 1);

    let (remote, inbox) = Remote::bounded(2);
    let mut win = win
        .with_inbox(inbox, |model, message| {
            *model.right = message;
        })
        .unwrap();
    a.try_send("next".into()).unwrap();
    remote.try_send("opaque".into()).unwrap();
    win.reset_counters().unwrap();
    assert_eq!(win.deliver_ready(8).unwrap().applied, 2);
    assert!(win.contains_text("opaque").unwrap());
    assert_eq!(win.counters().owner_reruns, 1);
}

#[test]
fn owner_dependent_source_still_redescribes_ordinary_snapshot_reads() {
    struct Branch(Signal<bool>);
    const FLAG: Source<Branch, bool> = Source::new(FieldId::new(1), "flag", |m| &m.0, |m| &mut m.0);
    impl View for Branch {
        fn sources() -> Sources<Self> {
            Sources::new().field(FLAG)
        }
        fn view(&self) -> El<'_> {
            text(if *self.0 { "on" } else { "off" })
        }
    }
    let (remote, inbox) = Remote::bounded(1);
    let mut win = Win::demo(Branch(Signal::new(false)))
        .with_inbox_for(inbox, FLAG, |value, message| *value = message)
        .unwrap();
    remote.try_send(true).unwrap();
    win.reset_counters().unwrap();
    win.deliver_ready(1).unwrap();
    assert!(win.contains_text("on").unwrap());
    assert_eq!(win.counters().owner_reruns, 1);
}

#[test]
fn projected_peer_sources_keep_distinct_scoped_identities() {
    struct Pair {
        a: Panel,
        b: Panel,
    }
    const A: Component<Pair, Panel> = Component::new(FieldId::new(1), "a", |m| &m.a, |m| &mut m.a);
    const B: Component<Pair, Panel> = Component::new(FieldId::new(2), "b", |m| &m.b, |m| &mut m.b);
    impl View for Pair {
        fn sources() -> Sources<Self> {
            Sources::new().direct_component(A).direct_component(B)
        }
        fn view(&self) -> El<'_> {
            column((A.view(self), B.view(self)))
        }
    }
    let (a, ai) = Remote::bounded(2);
    let (b, bi) = Remote::bounded(2);
    let mut win = Win::demo(Pair {
        a: Panel::new(),
        b: Panel::new(),
    })
    .with_inbox_for(ai, A.source(&Panel::LEFT), |value, message| {
        *value = message
    })
    .unwrap()
    .with_inbox_for(bi, B.source(&Panel::LEFT), |value, message| {
        *value = message
    })
    .unwrap();
    a.try_send("a".into()).unwrap();
    win.reset_counters().unwrap();
    win.deliver_ready(1).unwrap();
    assert_eq!(win.counters().owner_reruns, 0);
    a.try_send("aa".into()).unwrap();
    b.try_send("bb".into()).unwrap();
    win.reset_counters().unwrap();
    win.deliver_ready(8).unwrap();
    assert_eq!(&**win.read(A.source(&Panel::LEFT)).unwrap(), "aa");
    assert_eq!(&**win.read(B.source(&Panel::LEFT)).unwrap(), "bb");
    assert_eq!(win.counters().owner_reruns, 1);
}

#[test]
fn unregistered_or_forged_projection_is_rejected_before_any_callback() {
    for source in [
        Source::new(
            FieldId::new(99),
            "absent",
            |m: &Panel| &m.left,
            |m| &mut m.left,
        ),
        Source::new(
            FieldId::new(1),
            "peer",
            |m: &Panel| &m.right,
            |m| &mut m.right,
        ),
    ] {
        let (remote, inbox) = Remote::bounded(1);
        remote.try_send(String::new()).unwrap();
        let result = Win::demo(Panel::new()).with_inbox_for(inbox, source, |_, _| {
            panic!("rejected projection reached callback")
        });
        assert!(matches!(result, Err(Error::Binding(_))));
        assert!(matches!(
            remote.try_send(String::new()),
            Err(SendError::Closed(_))
        ));
    }
}

#[test]
fn failed_presentation_retains_old_sheet_and_later_buffered_repair() {
    let (remote, inbox) = Remote::bounded(2);
    let mut win = Win::demo(Panel::new())
        .with_inbox_for(inbox, Panel::LEFT, |value, message| *value = message)
        .unwrap();
    remote.try_send("漢".into()).unwrap();
    remote.try_send("repaired".into()).unwrap();
    let error = win.deliver_ready(1).unwrap_err();
    assert!(matches!(error.error, Error::Canvas(_)));
    let report = error.delivery.unwrap();
    assert_eq!(report.applied, 1);
    assert_eq!(
        (report.commit.source_epoch, report.commit.presentation_epoch),
        (1, 0)
    );
    assert!(win.contains_text("seed").unwrap());
    win.deliver_ready(1).unwrap();
    assert_eq!(&**win.read(Panel::LEFT).unwrap(), "repaired");
    assert!(win.contains_text("repaired").unwrap());
    assert_eq!(win.deliver_ready(8).unwrap().applied, 0);
}

#[test]
fn binding_fault_after_an_applied_prefix_commits_that_prefix_and_drops_only_rejected_value() {
    struct Changing {
        left: Signal<String>,
        right: Signal<String>,
        flipped: bool,
    }
    const REGISTERED: Source<Changing, String> = Source::new(
        FieldId::new(1),
        "selected",
        |m| if m.flipped { &m.right } else { &m.left },
        |m| if m.flipped { &mut m.right } else { &mut m.left },
    );
    const LEFT: Source<Changing, String> =
        Source::new(FieldId::new(1), "selected", |m| &m.left, |m| &mut m.left);
    impl View for Changing {
        fn sources() -> Sources<Self> {
            Sources::new().direct(REGISTERED)
        }
        fn view(&self) -> El<'_> {
            text_input(&self.left)
        }
    }
    let (remote, inbox) = Remote::bounded(2);
    let (flip, flips) = Remote::bounded(1);
    let mut win = Win::demo(Changing {
        left: Signal::new("seed".into()),
        right: Signal::new("peer".into()),
        flipped: false,
    })
    .with_inbox_for(inbox, LEFT, |value, message| *value = message)
    .unwrap()
    .with_inbox(flips, |model, _: ()| model.flipped = true)
    .unwrap();
    let input = win.input();
    win.focus(input).unwrap();
    win.select(input, gpui::TextSelection::from_bytes(1, 3).unwrap())
        .unwrap();
    let before = win.snapshot().unwrap();
    flip.try_send(()).unwrap();
    remote.try_send("rejected".into()).unwrap();
    remote.try_send("accepted".into()).unwrap();
    let error = win.deliver_ready(2).unwrap_err();
    assert!(matches!(
        error.error,
        Error::Binding(BindError::ProjectionMismatch(_))
    ));
    let report = error.delivery.unwrap();
    assert_eq!((report.received, report.applied), (2, 1));
    assert_eq!(report.commit.source_epoch, before.source_epoch + 1);
    assert_eq!(report.commit.presentation_epoch, before.presentation_epoch);
    assert_eq!(win.focused().unwrap(), None);
    assert_eq!(win.selection(input), Err(Error::StaleTarget));
    assert!(win.root().unwrap().flipped);
    assert_eq!(&*win.root().unwrap().left, "seed");
    win.update(|model| model.flipped = false).unwrap();
    assert_eq!(win.deliver_ready(2).unwrap().applied, 1);
    assert_eq!(&*win.root().unwrap().left, "accepted");
    assert_ne!(win.input(), input);
    assert_eq!(win.selection(input), Err(Error::StaleTarget));
}

#[test]
fn typed_delivery_refreshes_only_questions_that_depend_on_its_source() {
    let (jobs, results) = mpsc::channel();
    let left = &Panel::LEFT;
    let (questions, reader) = Questions::new()
        .question(
            left,
            String::clone,
            move |input, completion: Completion<usize, std::io::Error>| {
                jobs.send((input, completion))
                    .map_err(|_| StartError::Closed)
            },
        )
        .unwrap();
    let (remote, inbox) = Remote::bounded(2);
    let (other, others) = Remote::bounded(2);
    let mut win = Win::with_questions(Panel::new(), questions, WindowOptions::default())
        .unwrap()
        .with_inbox_for(inbox, Panel::LEFT, |value, message| *value = message)
        .unwrap()
        .with_inbox_for(others, Panel::RIGHT, |value, message| *value = message)
        .unwrap();
    let (initial, completion) = results.recv_timeout(Duration::from_secs(3)).unwrap();
    assert_eq!(initial, "seed");
    let before = win.question_info(reader).unwrap();
    other.try_send("unrelated".into()).unwrap();
    win.deliver_ready(1).unwrap();
    assert!(!completion.is_cancelled());
    assert_eq!(win.question_info(reader).unwrap(), before);
    remote.try_send("new".into()).unwrap();
    win.deliver_ready(1).unwrap();
    assert!(completion.is_cancelled());
    completion.complete(Ok(4)).unwrap();
    win.deliver_ready(8).unwrap();
    let (input, completion) = results.recv_timeout(Duration::from_secs(3)).unwrap();
    assert_eq!(input, "new");
    completion.complete(Ok(3)).unwrap();
    win.deliver_ready(8).unwrap();
    assert_eq!(win.with_ready(reader, |value| *value).unwrap(), Some(3));
}

#[test]
fn a_committed_prefix_revokes_a_ready_answer_before_returning_a_later_binding_error() {
    let (send, jobs) = mpsc::channel();
    let (questions, reader) = Questions::new()
        .question(
            Panel::LEFT,
            String::clone,
            move |input, completion: Completion<usize, std::io::Error>| {
                send.send((input, completion))
                    .map_err(|_| StartError::Closed)
            },
        )
        .unwrap();
    let (bad, bad_inbox) = Remote::bounded(1);
    let (remote, inbox) = Remote::bounded(1);
    let bad_right = Source::new(
        FieldId::new(2),
        "right",
        |m: &Panel| &m.right,
        |m| &mut m.left,
    );
    let mut win = Win::with_questions(Panel::new(), questions, WindowOptions::default())
        .unwrap()
        .with_inbox_for(bad_inbox, bad_right, |_, _: ()| panic!("rejected callback"))
        .unwrap()
        .with_inbox_for(inbox, Panel::LEFT, |value, message| *value = message)
        .unwrap();
    let (input, completion) = jobs.recv_timeout(Duration::from_secs(3)).unwrap();
    assert_eq!(input, "seed");
    completion.complete(Ok(4)).unwrap();
    win.deliver_ready(8).unwrap();
    assert_eq!(win.with_ready(reader, |value| *value).unwrap(), Some(4));
    remote.try_send("changed".into()).unwrap();
    bad.try_send(()).unwrap();
    let failure = win.deliver_ready(8).unwrap_err();
    assert!(matches!(failure.error, Error::Binding(_)));
    assert_eq!(failure.delivery.unwrap().applied, 1);
    assert_eq!(&**win.read(Panel::LEFT).unwrap(), "changed");
    assert_eq!(win.with_ready(reader, |value| *value).unwrap(), None);
    assert_eq!(
        win.question_status(reader).unwrap(),
        gpui::QuestionStatus::Pending
    );
    let (input, completion) = jobs.recv_timeout(Duration::from_secs(3)).unwrap();
    assert_eq!(input, "changed");
    completion.complete(Ok(7)).unwrap();
    win.deliver_ready(8).unwrap();
    assert_eq!(win.with_ready(reader, |value| *value).unwrap(), Some(7));
    assert!(win.contains_text("changed").unwrap());

    // Repeat while an older completion is frozen in this failing batch.
    // Retiring that physical credit must not require a fresh transport send.
    win.set(Panel::LEFT, "inflight".into()).unwrap();
    let (input, completion) = jobs.recv_timeout(Duration::from_secs(3)).unwrap();
    assert_eq!(input, "inflight");
    completion.complete(Ok(8)).unwrap();
    remote.try_send("latest".into()).unwrap();
    bad.try_send(()).unwrap();
    let failure = win.deliver_ready(8).unwrap_err();
    assert!(matches!(failure.error, Error::Binding(_)));
    assert_eq!(failure.delivery.unwrap().applied, 1);
    let resumed = win.deliver_ready(1).unwrap();
    assert_eq!((resumed.received, resumed.applied), (0, 0));
    assert_eq!(win.with_ready(reader, |value| *value).unwrap(), None);
    let (input, completion) = jobs.recv_timeout(Duration::from_secs(3)).unwrap();
    assert_eq!(input, "latest");
    completion.complete(Ok(6)).unwrap();
    win.deliver_ready(8).unwrap();
    assert_eq!(win.with_ready(reader, |value| *value).unwrap(), Some(6));
}

#[test]
fn a_rejected_message_does_not_strand_its_frozen_fifo_or_evade_a_smaller_budget() {
    struct Moving {
        value: Signal<String>,
        peer: Signal<String>,
        reject: bool,
    }
    const REGISTERED: Source<Moving, String> = Source::new(
        FieldId::new(1),
        "value",
        |m| if m.reject { &m.peer } else { &m.value },
        |m| if m.reject { &mut m.peer } else { &mut m.value },
    );
    const VALUE: Source<Moving, String> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
    impl View for Moving {
        fn sources() -> Sources<Self> {
            Sources::new().direct(REGISTERED)
        }
        fn view(&self) -> El<'_> {
            text(&self.value)
        }
    }
    for capacity in [4, 8] {
        let (remote, inbox) = Remote::bounded(capacity);
        let (flip, flips) = Remote::bounded(1);
        let mut win = Win::demo(Moving {
            value: Signal::new("seed".into()),
            peer: Signal::new("peer".into()),
            reject: false,
        })
        .with_inbox_for(inbox, VALUE, |value, message| *value = message)
        .unwrap()
        .with_inbox(flips, |model, _: ()| model.reject = true)
        .unwrap();
        flip.try_send(()).unwrap();
        for value in ["rejected", "first", "second", "third"] {
            remote.try_send(value.into()).unwrap();
        }
        let failure = win.deliver_ready(16).unwrap_err();
        assert!(matches!(failure.error, Error::Binding(_)));
        let delivery = failure.delivery.unwrap();
        assert_eq!((delivery.received, delivery.applied), (5, 1));
        assert!(
            delivery.more,
            "retained frozen messages require another turn"
        );
        // Three frozen values still occupy capacity after the rejected value
        // was consumed. Filling only the freed slots cannot borrow a second C.
        for extra in 0..capacity - 3 {
            remote.try_send(format!("later-{extra}")).unwrap();
        }
        let owned = String::from("full");
        let pointer = owned.as_ptr();
        let Err(SendError::Full(owned)) = remote.try_send(owned) else {
            panic!("frozen backlog must count toward capacity");
        };
        assert_eq!(owned.as_ptr(), pointer);
        win.update(|model| model.reject = false).unwrap();
        assert_eq!(win.deliver_ready(0).unwrap().applied, 0);
        for value in ["first", "second", "third"] {
            let delivery = win.deliver_ready(1).unwrap();
            assert_eq!(delivery.received, 0, "this message was already frozen");
            assert_eq!(delivery.applied, 1);
            assert_eq!(&**win.read(VALUE).unwrap(), value);
        }
        for extra in 0..capacity - 3 {
            let delivery = win.deliver_ready(1).unwrap();
            assert_eq!((delivery.received, delivery.applied), (1, 1));
            assert_eq!(&**win.read(VALUE).unwrap(), format!("later-{extra}"));
        }
        assert_eq!(win.deliver_ready(16).unwrap().applied, 0);
    }
}

#[test]
fn mutable_projector_disagreement_rejects_before_editing_or_advancing_source() {
    let bad = Source::new(
        FieldId::new(1),
        "left",
        |m: &Panel| &m.left,
        |m| &mut m.right,
    );
    let (remote, inbox) = Remote::bounded(1);
    let mut win = Win::demo(Panel::new())
        .with_inbox_for(inbox, bad, |_, _: ()| panic!("wrong write projector"))
        .unwrap();
    let input = win.input();
    let selection = gpui::TextSelection::from_bytes(1, 3).unwrap();
    win.focus(input).unwrap();
    win.select(input, selection).unwrap();
    let before = win.snapshot().unwrap();
    win.reset_counters().unwrap();
    remote.try_send(()).unwrap();
    let error = win.deliver_ready(1).unwrap_err();
    assert!(matches!(
        error.error,
        Error::Binding(BindError::ProjectionMismatch(_))
    ));
    let report = error.delivery.unwrap();
    assert_eq!(report.applied, 0);
    assert_eq!(report.commit.source_epoch, before.source_epoch);
    assert_eq!(&*win.root().unwrap().left, "seed");
    assert_eq!(&*win.root().unwrap().right, "peer");
    assert_eq!(win.focused().unwrap(), Some(input));
    assert_eq!(win.selection(input).unwrap(), selection);
    assert_eq!(win.snapshot().unwrap(), before);
    assert_eq!(win.counters(), gpui::Counters::default());
    // The rejected message cannot revoke a coherent input target. Editing
    // through that same target must still reach its original logical range.
    win.type_text(input, "x").unwrap();
    assert_eq!(&**win.read(Panel::LEFT).unwrap(), "sxd");
}

#[test]
fn typed_callback_panic_quarantines_and_revokes_pending_messages() {
    let (remote, inbox) = Remote::bounded(4);
    let mut win = Win::demo(Panel::new())
        .with_inbox_for(inbox, Panel::LEFT, |value, message: &str| {
            value.push_str(message);
            if message == "panic" {
                panic!("typed callback fault");
            }
        })
        .unwrap();
    for message in ["first", "panic", "never"] {
        remote.try_send(message).unwrap();
    }
    let error = win.deliver_ready(4).unwrap_err();
    assert_eq!(error.error, Error::OwnerPanicked);
    assert_eq!(error.delivery.unwrap().applied, 1);
    assert!(matches!(
        remote.try_send("closed"),
        Err(SendError::Closed(_))
    ));
}

#[test]
fn messages_sent_during_a_typed_callback_wait_for_the_next_frozen_batch() {
    let (remote, inbox) = Remote::bounded(4);
    let next = remote.clone();
    let mut win = Win::demo(Panel::new())
        .with_inbox_for(inbox, Panel::LEFT, move |value, message| {
            *value = message;
            if value == "first" {
                next.try_send("second".into()).unwrap();
            }
        })
        .unwrap();
    remote.try_send("first".into()).unwrap();
    assert_eq!(win.deliver_ready(4).unwrap().applied, 1);
    assert_eq!(&**win.read(Panel::LEFT).unwrap(), "first");
    assert_eq!(win.deliver_ready(4).unwrap().applied, 1);
    assert_eq!(&**win.read(Panel::LEFT).unwrap(), "second");
}
