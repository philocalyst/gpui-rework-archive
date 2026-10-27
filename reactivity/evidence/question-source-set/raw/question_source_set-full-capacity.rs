//! Multi-source admission must preserve both dependency precision and completeness.
use gpui::{Completion, LaneSet, Questions, Reader, Remote, WindowOptions, prelude::*};
use std::{convert::Infallible, sync::mpsc};
struct Model<const OWNER: bool> {
    values: [Signal<String>; 5],
    query: Signal<u32>,
    answer: Reader<String>,
}
impl<const O: bool> Model<O> {
    const F: [Source<Self, String>; 5] = [
        Source::new(FieldId::new(1), "a", |m| &m.values[0], |m| &mut m.values[0]),
        Source::new(FieldId::new(2), "b", |m| &m.values[1], |m| &mut m.values[1]),
        Source::new(FieldId::new(3), "c", |m| &m.values[2], |m| &mut m.values[2]),
        Source::new(FieldId::new(4), "d", |m| &m.values[3], |m| &mut m.values[3]),
        Source::new(FieldId::new(5), "e", |m| &m.values[4], |m| &mut m.values[4]),
    ];
    const QUERY: Source<Self, u32> =
        Source::new(FieldId::new(6), "query", |m| &m.query, |m| &mut m.query);
}
impl<const O: bool> View for Model<O> {
    fn sources() -> Sources<Self> {
        let s = if O {
            Sources::new().field(Self::F[0])
        } else {
            Sources::new().direct(Self::F[0])
        };
        s.direct(Self::F[1])
            .direct(Self::F[2])
            .direct(Self::F[3])
            .direct(Self::F[4])
            .direct(Self::QUERY)
    }
    fn view(&self) -> El<'_> {
        column((
            column(self.values.iter().map(|v| text(v).h(20))),
            self.answer.project(|v| text(v.as_str())),
            O.then(|| text(format!("owner:{}", self.values[0].as_str()))),
        ))
    }
}
fn ack<const O: bool, L: LaneSet<Model<O>>>(win: &mut Win<Model<O>, L>) {
    let token = win.with_scene(|_, t| t).unwrap();
    win.presented(token).unwrap();
}
fn mount<const O: bool, Q: LaneSet<Model<O>>>(
    plan: Questions<Model<O>, Q>,
    answer: Reader<String>,
) -> (Win<Model<O>, impl LaneSet<Model<O>>>, [Remote<String>; 5]) {
    let model = Model {
        values: std::array::from_fn(|i| Signal::new(format!("old{i}"))),
        query: Signal::new(7),
        answer,
    };
    let win = Win::recording_questions(
        model,
        plan,
        WindowOptions {
            size: [320, 240],
            ..Default::default()
        },
    )
    .unwrap();
    let (a, ai) = Remote::bounded(4);
    let (b, bi) = Remote::bounded(4);
    let (c, ci) = Remote::bounded(4);
    let (d, di) = Remote::bounded(4);
    let (e, ei) = Remote::bounded(4);
    let mut win = win
        .with_inbox_for(ai, Model::F[0], |v, n| *v = n)
        .unwrap()
        .with_inbox_for(bi, Model::F[1], |v, n| *v = n)
        .unwrap()
        .with_inbox_for(ci, Model::F[2], |v, n| *v = n)
        .unwrap()
        .with_inbox_for(di, Model::F[3], |v, n| *v = n)
        .unwrap()
        .with_inbox_for(ei, Model::F[4], |v, n| *v = n)
        .unwrap();
    ack(&mut win);
    (win, [a, b, c, d, e])
}
fn unrelated<const O: bool>(overflow: bool) {
    let (send, jobs) = mpsc::channel();
    let (plan, answer) = Questions::new()
        .question(
            Model::<O>::QUERY,
            |v| *v,
            move |input, cap: Completion<String, Infallible>| {
                send.send((input, cap)).unwrap();
                Ok(())
            },
        )
        .unwrap();
    let (mut win, r) = mount(plan, answer);
    let (input, cap) = jobs.try_recv().unwrap();
    assert_eq!(input, 7);
    cap.complete(Ok("ready".into())).unwrap();
    win.deliver_ready(8).unwrap();
    ack(&mut win);
    let before = win.question_info(answer).unwrap();
    win.reset_counters().unwrap();
    for (i, r) in r.iter().enumerate().take(if overflow { 5 } else { 2 }) {
        r.try_send(format!("new{i}")).unwrap();
    }
    win.deliver_ready(8).unwrap();
    ack(&mut win);
    assert!(win.contains_text("new0").unwrap());
    assert!(win.contains_text("new1").unwrap());
    if O || overflow {
        assert!(jobs.try_recv().is_ok());
        assert_eq!(win.counters().owner_reruns, 1);
    } else {
        assert!(jobs.try_recv().is_err());
        assert_eq!(win.question_info(answer).unwrap(), before);
        assert_eq!(
            win.with_ready(answer, Clone::clone).unwrap(),
            Some("ready".into())
        );
        assert_eq!(win.counters().owner_reruns, 0);
    }
}
#[test]
fn unrelated_direct_batch_keeps_ready_question_and_patches_text() {
    unrelated::<false>(false);
}
#[test]
fn owner_dependent_batch_keeps_coarse_question_refresh() {
    unrelated::<true>(false);
}
#[test]
fn overflow_keeps_coarse_question_refresh() {
    unrelated::<false>(true);
}
#[test]
fn every_typed_member_can_invalidate_its_own_question() {
    let values = ["alpha", "beta", "gamma", "delta"];
    for affected in 0..4 {
        let (send, jobs) = mpsc::channel();
        let (plan, answer) = Questions::new()
            .question(
                Model::<false>::F[affected],
                Clone::clone,
                move |input, cap: Completion<String, Infallible>| {
                    send.send((input, cap)).unwrap();
                    Ok(())
                },
            )
            .unwrap();
        let (mut win, r) = mount(plan, answer);
        let (_, cap) = jobs.try_recv().unwrap();
        cap.complete(Ok("old-answer".into())).unwrap();
        win.deliver_ready(8).unwrap();
        ack(&mut win);
        for (remote, value) in r.iter().zip(values) {
            remote.try_send(value.into()).unwrap();
        }
        win.deliver_ready(8).unwrap();
        let (input, cap) = jobs
            .try_recv()
            .expect("changed member must dispatch its dependent");
        assert_eq!(input, values[affected]);
        assert_eq!(win.with_ready(answer, Clone::clone).unwrap(), None);
        cap.complete(Ok(input)).unwrap();
        win.deliver_ready(8).unwrap();
        ack(&mut win);
        assert_eq!(
            win.with_ready(answer, Clone::clone).unwrap(),
            Some(values[affected].into())
        );
    }
}
#[test]
fn tuple_freezes_final_pair_once_and_aba_never_accepts_old_completion() {
    let (send, jobs) = mpsc::channel();
    let (plan, answer) = Questions::new()
        .question(
            (Model::<false>::F[0], Model::<false>::F[1]),
            |(a, b)| (a.clone(), b.clone()),
            move |input, cap: Completion<String, Infallible>| {
                send.send((input, cap)).unwrap();
                Ok(())
            },
        )
        .unwrap();
    let (mut win, r) = mount(plan, answer);
    let (_, cap) = jobs.try_recv().unwrap();
    cap.complete(Ok("initial".into())).unwrap();
    win.deliver_ready(8).unwrap();
    ack(&mut win);
    let frozen = win.question_info(answer).unwrap().stats.frozen;
    r[0].try_send("alpha".into()).unwrap();
    r[1].try_send("beta".into()).unwrap();
    win.deliver_ready(8).unwrap();
    ack(&mut win);
    let (input, old) = jobs.try_recv().unwrap();
    assert_eq!(input, ("alpha".into(), "beta".into()));
    assert_eq!(win.question_info(answer).unwrap().stats.frozen, frozen + 1);
    assert!(jobs.try_recv().is_err());
    r[0].try_send("old0".into()).unwrap();
    r[1].try_send("old1".into()).unwrap();
    win.deliver_ready(8).unwrap();
    ack(&mut win);
    assert!(old.is_cancelled());
    assert!(jobs.try_recv().is_err());
    old.complete(Ok("stale".into())).unwrap();
    win.deliver_ready(8).unwrap();
    let (input, cap) = jobs.try_recv().unwrap();
    assert_eq!(input, ("old0".into(), "old1".into()));
    assert_eq!(win.with_ready(answer, Clone::clone).unwrap(), None);
    cap.complete(Ok("restored".into())).unwrap();
    win.deliver_ready(8).unwrap();
    ack(&mut win);
    assert!(win.contains_text("restored").unwrap());
    assert!(!win.contains_text("stale").unwrap());
}
#[test]
fn opaque_callback_still_supersedes_unrelated_question() {
    let (send, jobs) = mpsc::channel();
    let (plan, answer) = Questions::new()
        .question(
            Model::<false>::QUERY,
            |v| *v,
            move |input, cap: Completion<String, Infallible>| {
                send.send((input, cap)).unwrap();
                Ok(())
            },
        )
        .unwrap();
    let (win, r) = mount(plan, answer);
    let (remote, inbox) = Remote::bounded(2);
    let mut win = win.with_inbox(inbox, |m, n| *m.values[1] = n).unwrap();
    let (_, cap) = jobs.try_recv().unwrap();
    cap.complete(Ok("ready".into())).unwrap();
    win.deliver_ready(8).unwrap();
    ack(&mut win);
    r[0].try_send("typed".into()).unwrap();
    remote.try_send("opaque".into()).unwrap();
    win.deliver_ready(8).unwrap();
    assert!(jobs.try_recv().is_ok());
    assert_eq!(win.with_ready(answer, Clone::clone).unwrap(), None);
}
#[test]
fn batched_diamond_never_freezes_a_partial_join() {
    let (a_send, a_jobs) = mpsc::channel();
    let (b_send, b_jobs) = mpsc::channel();
    let (join_send, joins) = mpsc::channel();
    let (plan, a) = Questions::new()
        .question(
            Model::<false>::F[0],
            Clone::clone,
            move |input, cap: Completion<String, Infallible>| {
                a_send.send((input, cap)).unwrap();
                Ok(())
            },
        )
        .unwrap();
    let (plan, b) = plan
        .question(
            Model::<false>::F[1],
            Clone::clone,
            move |input, cap: Completion<String, Infallible>| {
                b_send.send((input, cap)).unwrap();
                Ok(())
            },
        )
        .unwrap();
    let (plan, joined) = plan
        .question(
            (a, b),
            |(a, b)| (a.clone(), b.clone()),
            move |input, cap: Completion<String, Infallible>| {
                join_send.send((input, cap)).unwrap();
                Ok(())
            },
        )
        .unwrap();
    let (mut win, remotes) = mount(plan, joined);
    let (_, a_cap) = a_jobs.try_recv().unwrap();
    let (_, b_cap) = b_jobs.try_recv().unwrap();
    a_cap.complete(Ok("old-a".into())).unwrap();
    b_cap.complete(Ok("old-b".into())).unwrap();
    win.deliver_ready(8).unwrap();
    let (pair, cap) = joins.try_recv().unwrap();
    assert_eq!(pair, ("old-a".into(), "old-b".into()));
    cap.complete(Ok("old-joined".into())).unwrap();
    win.deliver_ready(8).unwrap();
    ack(&mut win);
    let frozen = win.question_info(joined).unwrap().stats.frozen;
    remotes[0].try_send("new-a".into()).unwrap();
    remotes[1].try_send("new-b".into()).unwrap();
    win.deliver_ready(8).unwrap();
    ack(&mut win);
    let (a_input, a_cap) = a_jobs.try_recv().unwrap();
    let (b_input, b_cap) = b_jobs.try_recv().unwrap();
    assert_eq!((a_input, b_input), ("new-a".into(), "new-b".into()));
    assert!(a_jobs.try_recv().is_err());
    assert!(b_jobs.try_recv().is_err());
    assert!(joins.try_recv().is_err());
    assert!(win.contains_text("old-joined").unwrap());
    a_cap.complete(Ok("answer-a".into())).unwrap();
    win.deliver_ready(8).unwrap();
    ack(&mut win);
    assert!(
        joins.try_recv().is_err(),
        "one ready child cannot authorize the join"
    );
    assert_eq!(win.question_info(joined).unwrap().stats.frozen, frozen);
    assert!(win.contains_text("old-joined").unwrap());
    b_cap.complete(Ok("answer-b".into())).unwrap();
    win.deliver_ready(8).unwrap();
    ack(&mut win);
    let (pair, cap) = joins.try_recv().unwrap();
    assert_eq!(pair, ("answer-a".into(), "answer-b".into()));
    assert!(joins.try_recv().is_err());
    assert_eq!(win.question_info(joined).unwrap().stats.frozen, frozen + 1);
    cap.complete(Ok("new-joined".into())).unwrap();
    win.deliver_ready(8).unwrap();
    ack(&mut win);
    assert!(win.contains_text("new-joined").unwrap());
    assert!(!win.contains_text("old-joined").unwrap());
}
