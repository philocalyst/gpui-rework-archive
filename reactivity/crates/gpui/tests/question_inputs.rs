//! Real owned windows exercise the same static question lanes as native delivery.
use gpui::{
    Completion, Error, QuestionFault, QuestionInput, QuestionStatus, Questions, Reader, StartError,
    WindowOptions, prelude::*,
};
use std::fmt;
use std::sync::mpsc;
#[derive(Debug)]
struct Fault;
impl fmt::Display for Fault {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_str("upstream fault")
    }
}
impl std::error::Error for Fault {}
struct Model {
    a: Signal<u32>,
    b: Signal<u32>,
    unrelated: Signal<u32>,
    broken: Signal<bool>,
    first: Reader<u32>,
    second: Reader<String>,
}
impl Model {
    const A: Source<Self, u32> = Source::new(FieldId::new(1), "a", |m| &m.a, |m| &mut m.a);
    const B: Source<Self, u32> = Source::new(FieldId::new(2), "b", |m| &m.b, |m| &mut m.b);
    const OTHER: Source<Self, u32> = Source::new(
        FieldId::new(3),
        "other",
        |m| &m.unrelated,
        |m| &mut m.unrelated,
    );
    const BROKEN: Source<Self, bool> =
        Source::new(FieldId::new(4), "broken", |m| &m.broken, |m| &mut m.broken);
}
impl View for Model {
    fn sources() -> Sources<Self> {
        Sources::new()
            .direct(Self::A)
            .direct(Self::B)
            .direct(Self::OTHER)
            .field(Self::BROKEN)
    }
    fn view(&self) -> El<'_> {
        column((
            text(if *self.broken { "漢" } else { "Inputs" }),
            self.first.project(|n| text(n.to_string())),
            self.second.project(|s| text(s.as_str())),
        ))
    }
}
type First = ((u32, u32), Completion<u32, Fault>);
type Second = ((u32, u32), Completion<String, Fault>);
#[allow(
    clippy::type_complexity,
    reason = "The fixture returns typed jobs and keys without erased test state."
)]
fn open() -> (
    Win<Model, impl gpui::LaneSet<Model>>,
    mpsc::Receiver<First>,
    mpsc::Receiver<Second>,
    Reader<u32>,
    Reader<String>,
) {
    let (a, first_jobs) = mpsc::channel();
    let (b, second_jobs) = mpsc::channel();
    let (plan, first) = Questions::new()
        .question(
            (Model::A, Model::B),
            |(a, b)| (*a, *b),
            move |input, cap| a.send((input, cap)).map_err(|_| StartError::Closed),
        )
        .unwrap();
    let (plan, second) = plan
        .question(
            (first, Model::B),
            |(first, b)| (*first, *b),
            move |input, cap| b.send((input, cap)).map_err(|_| StartError::Closed),
        )
        .unwrap();
    let win = Win::with_questions(
        Model {
            a: Signal::new(1),
            b: Signal::new(2),
            unrelated: Signal::new(0),
            broken: Signal::new(false),
            first,
            second,
        },
        plan,
        WindowOptions {
            size: [320, 180],
            ..Default::default()
        },
    )
    .unwrap();
    (win, first_jobs, second_jobs, first, second)
}
#[test]
fn both_sources_invalidate_but_unrelated_exact_edits_do_not_and_diagnostics_are_complete() {
    let (mut win, jobs, dependent, first, second) = open();
    let (input, cap) = jobs.recv().unwrap();
    assert_eq!(input, (1, 2));
    assert!(dependent.try_recv().is_err());
    assert!(win.question_info(first).unwrap().input.is_none());
    let mut inputs = Vec::new();
    assert_eq!(
        win.visit_question_inputs(first, |i| inputs.push(i))
            .unwrap(),
        2
    );
    assert!(
        matches!(inputs.as_slice(),[QuestionInput::Source(a),QuestionInput::Source(b)] if a.source()==Model::A.id() && b.source()==Model::B.id())
    );
    let info = win.question_info(first).unwrap();
    for n in 1..5 {
        win.set(Model::OTHER, n).unwrap();
    }
    assert_eq!(win.question_info(first).unwrap(), info);
    assert_eq!(win.question_info(second).unwrap().stats.frozen, 0);
    win.set(Model::B, 3).unwrap();
    assert!(cap.is_cancelled());
    assert!(jobs.try_recv().is_err());
    cap.complete(Ok(99)).unwrap();
    let d = win.deliver_ready(8).unwrap();
    assert_eq!(d.applied, 0);
    let (input, cap) = jobs.recv().unwrap();
    assert_eq!(input, (1, 3));
    cap.complete(Ok(4)).unwrap();
    let d = win.deliver_ready(8).unwrap();
    assert_eq!(d.applied, 1);
    let (input, cap) = dependent.recv().unwrap();
    assert_eq!(input, (4, 3));
    cap.complete(Ok("four plus three".into())).unwrap();
    win.deliver_ready(8).unwrap();
    assert_eq!(
        win.with_ready(second, Clone::clone).unwrap(),
        Some("four plus three".into())
    );
    win.set(Model::A, 8).unwrap();
    assert_eq!(win.question_status(second), Ok(QuestionStatus::Pending));
}
#[test]
fn same_batch_upstream_and_old_dependent_terminal_dispatch_latest_once() {
    let (mut win, first_jobs, second_jobs, first, second) = open();
    first_jobs.recv().unwrap().1.complete(Ok(3)).unwrap();
    win.deliver_ready(8).unwrap();
    let (_, old) = second_jobs.recv().unwrap();
    win.set(Model::A, 7).unwrap();
    assert!(old.is_cancelled());
    let (_, upstream) = first_jobs.recv().unwrap();
    old.complete(Ok("old dependent".into())).unwrap();
    upstream.complete(Ok(9)).unwrap();
    let d = win.deliver_ready(8).unwrap();
    assert_eq!((d.received, d.applied), (2, 1));
    assert_eq!(win.question_status(first), Ok(QuestionStatus::Ready));
    assert_eq!(win.question_status(second), Ok(QuestionStatus::Pending));
    assert!(!win.contains_text("old dependent").unwrap());
    let (input, cap) = second_jobs.recv().unwrap();
    assert_eq!(input, (9, 2));
    assert!(second_jobs.try_recv().is_err());
    assert_eq!(win.question_info(second).unwrap().stats.dispatched, 2);
    cap.complete(Ok("new dependent".into())).unwrap();
    win.deliver_ready(8).unwrap();
    assert!(win.contains_text("new dependent").unwrap());
}
#[test]
fn dependency_fault_and_pending_previous_values_never_freeze_fresh_work() {
    let (mut win, first_jobs, second_jobs, first, second) = open();
    first_jobs.recv().unwrap().1.complete(Ok(3)).unwrap();
    win.deliver_ready(8).unwrap();
    second_jobs
        .recv()
        .unwrap()
        .1
        .complete(Ok("previous".into()))
        .unwrap();
    win.deliver_ready(8).unwrap();
    win.retry(first).unwrap();
    assert_eq!(win.question_status(second), Ok(QuestionStatus::Pending));
    let frozen = win.question_info(second).unwrap().stats.frozen;
    for n in 1..4 {
        win.set(Model::OTHER, n).unwrap();
    }
    assert_eq!(win.question_info(second).unwrap().stats.frozen, frozen);
    first_jobs.recv().unwrap().1.complete(Err(Fault)).unwrap();
    win.deliver_ready(8).unwrap();
    assert_eq!(win.question_status(second), Ok(QuestionStatus::Fault));
    assert!(second_jobs.try_recv().is_err());
    assert!(win.contains_text("upstream fault").unwrap());
    win.retry(first).unwrap();
    first_jobs.recv().unwrap().1.complete(Ok(8)).unwrap();
    win.deliver_ready(8).unwrap();
    let (input, cap) = second_jobs.recv().unwrap();
    assert_eq!(input, (8, 2));
    cap.complete(Ok("recovered".into())).unwrap();
    win.deliver_ready(8).unwrap();
    assert_eq!(
        win.with_ready(second, Clone::clone).unwrap(),
        Some("recovered".into())
    );
}
#[test]
fn foreign_reader_is_rejected_before_mount() {
    let (_, foreign) = Questions::<Model>::new()
        .question(Model::A, |n| *n, |_, _: Completion<u32, Fault>| Ok(()))
        .unwrap();
    assert!(matches!(
        Questions::<Model>::new().question(foreign, |n| *n, |_, _: Completion<u32, Fault>| Ok(())),
        Err(QuestionFault::Revoked)
    ));
}
#[test]
fn synchronous_completion_waits_for_the_next_frozen_batch() {
    let (send, jobs) = mpsc::channel();
    let (plan, first) = Questions::new()
        .question(
            Model::A,
            |n| *n,
            move |n, cap| {
                send.send((n, cap)).unwrap();
                Ok(())
            },
        )
        .unwrap();
    let (plan, second) = plan
        .question(
            first,
            |n| *n,
            |n, cap: Completion<String, Fault>| {
                cap.complete(Ok(format!("sync {n}"))).unwrap();
                Ok(())
            },
        )
        .unwrap();
    let mut win = Win::with_questions(
        Model {
            a: Signal::new(1),
            b: Signal::new(2),
            unrelated: Signal::new(0),
            broken: Signal::new(false),
            first,
            second,
        },
        plan,
        WindowOptions::default(),
    )
    .unwrap();
    let (_, cap): (_, Completion<u32, Fault>) = jobs.recv().unwrap();
    cap.complete(Ok(7)).unwrap();
    let d = win.deliver_ready(8).unwrap();
    assert_eq!((d.received, d.applied), (1, 1));
    assert_eq!(win.question_status(second), Ok(QuestionStatus::Pending));
    let d = win.deliver_ready(8).unwrap();
    assert_eq!((d.received, d.applied), (1, 1));
    assert!(win.contains_text("sync 7").unwrap());
}
#[test]
fn accepted_upstream_survives_visual_failure_and_dependency_remains_coherent() {
    let (mut win, first_jobs, second_jobs, first, second) = open();
    assert!(win.set(Model::BROKEN, true).is_err());
    let (_, cap) = first_jobs.recv().unwrap();
    cap.complete(Ok(11)).unwrap();
    let error = win.deliver_ready(8).unwrap_err();
    assert_eq!(error.delivery.unwrap().applied, 1);
    assert_eq!(win.with_ready(first, |n| *n).unwrap(), Some(11));
    let (_, cap) = second_jobs.recv().unwrap();
    cap.complete(Ok("coherent".into())).unwrap();
    assert!(win.deliver_ready(8).is_err());
    win.set(Model::BROKEN, false).unwrap();
    // A known unrelated field repairs presentation without replacing input authority.
    assert_eq!(win.question_status(second), Ok(QuestionStatus::Ready));
    win.close();
    assert!(matches!(win.question_status(first), Err(Error::Closed)));
}
#[test]
fn nested_pairs_preserve_every_member_and_duplicate_sources_are_observed_consistently() {
    let (send, jobs) = mpsc::channel();
    let (plan, first) = Questions::new()
        .question(
            ((Model::A, Model::B), Model::A),
            |((a, b), again)| (*a, *b, *again),
            move |input, cap: Completion<u32, Fault>| {
                send.send((input, cap)).unwrap();
                Ok(())
            },
        )
        .unwrap();
    // Use an independent ready String slot for the view without a worker thread.
    let (plan, second) = plan
        .question(
            first,
            |n| *n,
            |n, cap: Completion<String, Fault>| {
                cap.complete(Ok(n.to_string())).unwrap();
                Ok(())
            },
        )
        .unwrap();
    let mut win = Win::with_questions(
        Model {
            a: Signal::new(1),
            b: Signal::new(2),
            unrelated: Signal::new(0),
            broken: Signal::new(false),
            first,
            second,
        },
        plan,
        WindowOptions::default(),
    )
    .unwrap();
    let mut ids = Vec::new();
    assert_eq!(
        win.visit_question_inputs(first, |input| if let QuestionInput::Source(v) = input {
            ids.push(v.source())
        })
        .unwrap(),
        3
    );
    assert_eq!(ids, [Model::A.id(), Model::B.id(), Model::A.id()]);
    let (values, cap) = jobs.recv().unwrap();
    assert_eq!(values, (1, 2, 1));
    win.set(Model::A, 3).unwrap();
    assert!(cap.is_cancelled());
    drop(cap);
    win.deliver_ready(8).unwrap();
    let (values, cap) = jobs.recv().unwrap();
    assert_eq!(values, (3, 2, 3));
    drop(cap);
    win.close();
}
#[test]
fn close_revokes_a_held_completion_and_returns_its_same_owned_payload() {
    let (mut win, jobs, _, first, _) = open();
    let (_, cap) = jobs.recv().unwrap();
    win.close();
    assert!(cap.is_cancelled());
    // A closed worker retains no owner pointer and cannot admit into a remount.
    assert!(cap.complete(Ok(42)).is_err());
    assert!(matches!(win.question_info(first), Err(Error::Closed)));
}

#[test]
fn two_reader_inputs_settle_before_their_dependent_freezes_once() {
    let (a, a_jobs) = mpsc::channel();
    let (b, b_jobs) = mpsc::channel();
    let (c, c_jobs) = mpsc::channel();
    let (plan, first) = Questions::new()
        .question(
            Model::A,
            |n| *n,
            move |_, cap: Completion<u32, Fault>| {
                a.send(cap).unwrap();
                Ok(())
            },
        )
        .unwrap();
    let (plan, other) = plan
        .question(
            Model::B,
            |n| *n,
            move |_, cap: Completion<u32, Fault>| {
                b.send(cap).unwrap();
                Ok(())
            },
        )
        .unwrap();
    let (plan, second) = plan
        .question(
            (first, other),
            |(a, b)| (*a, *b),
            move |input, cap: Completion<String, Fault>| {
                c.send((input, cap)).unwrap();
                Ok(())
            },
        )
        .unwrap();
    let mut win = Win::with_questions(
        Model {
            a: Signal::new(1),
            b: Signal::new(2),
            unrelated: Signal::new(0),
            broken: Signal::new(false),
            first,
            second,
        },
        plan,
        WindowOptions::default(),
    )
    .unwrap();
    let a = a_jobs.recv().unwrap();
    let b = b_jobs.recv().unwrap();
    a.complete(Ok(11)).unwrap();
    win.deliver_ready(8).unwrap();
    assert!(
        c_jobs.try_recv().is_err(),
        "one Ready input cannot authorize a partial snapshot"
    );
    assert_eq!(win.question_info(second).unwrap().stats.frozen, 0);
    b.complete(Ok(22)).unwrap();
    win.deliver_ready(8).unwrap();
    let (input, old) = c_jobs.recv().unwrap();
    assert_eq!(input, (11, 22));
    win.set(Model::A, 3).unwrap();
    win.set(Model::B, 4).unwrap();
    assert!(old.is_cancelled());
    old.complete(Ok("old pair".into())).unwrap();
    a_jobs.recv().unwrap().complete(Ok(33)).unwrap();
    b_jobs.recv().unwrap().complete(Ok(44)).unwrap();
    let delivery = win.deliver_ready(8).unwrap();
    assert_eq!((delivery.received, delivery.applied), (3, 2));
    let (input, cap) = c_jobs.recv().unwrap();
    assert_eq!(input, (33, 44));
    assert!(c_jobs.try_recv().is_err());
    assert_eq!(win.question_info(second).unwrap().stats.frozen, 2);
    cap.complete(Ok("new pair".into())).unwrap();
    win.deliver_ready(8).unwrap();
    assert!(win.contains_text("new pair").unwrap());
}

#[test]
fn a_coarse_replacement_of_either_source_supersedes_an_equal_revision_pack() {
    let (mut win, jobs, _, first, _) = open();
    let (_, old) = jobs.recv().unwrap();
    win.update(|model| model.b = Signal::new(2)).unwrap();
    assert!(old.is_cancelled());
    old.complete(Ok(999)).unwrap();
    assert_eq!(win.deliver_ready(8).unwrap().applied, 0);
    let (values, cap) = jobs.recv().unwrap();
    assert_eq!(values, (1, 2));
    cap.complete(Ok(3)).unwrap();
    win.deliver_ready(8).unwrap();
    assert_eq!(win.with_ready(first, |value| *value).unwrap(), Some(3));
    let mut epochs = Vec::new();
    win.visit_question_inputs(first, |input| {
        if let QuestionInput::Source(v) = input {
            epochs.push(v.coarse_epoch())
        }
    })
    .unwrap();
    assert_eq!(epochs, [1, 1]);
}
#[test]
fn a_dependent_freeze_panic_quarantines_the_same_owner_after_counted_upstream_admission() {
    let (send, jobs) = mpsc::channel();
    let (plan, first) = Questions::new()
        .question(
            Model::A,
            |n| *n,
            move |_, cap: Completion<u32, Fault>| {
                send.send(cap).unwrap();
                Ok(())
            },
        )
        .unwrap();
    let (plan, second) = plan
        .question(
            first,
            |n| {
                assert_ne!(*n, 9, "dependent pure freeze fault");
                *n
            },
            |_, _: Completion<String, Fault>| panic!("must not dispatch failed input"),
        )
        .unwrap();
    let mut win = Win::with_questions(
        Model {
            a: Signal::new(1),
            b: Signal::new(2),
            unrelated: Signal::new(0),
            broken: Signal::new(false),
            first,
            second,
        },
        plan,
        WindowOptions::default(),
    )
    .unwrap();
    jobs.recv().unwrap().complete(Ok(9)).unwrap();
    let failure = win.deliver_ready(8).unwrap_err();
    assert_eq!(failure.error, Error::OwnerPanicked);
    assert_eq!(failure.delivery.unwrap().applied, 1);
    assert_eq!(win.question_status(first), Err(Error::Poisoned));
    assert_eq!(win.deliver_ready(8).unwrap_err().error, Error::Poisoned);
}
