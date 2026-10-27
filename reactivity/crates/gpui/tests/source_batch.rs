//! Public authority tests for several typed edits in one publication.
use gpui::{LaneSet, Remote, WindowOptions, prelude::*};
struct Panel<const OWNER: bool, const NAMES: bool> {
    values: [Signal<String>; 5],
}
impl<const O: bool, const N: bool> Panel<O, N> {
    const FIELDS: [Source<Self, String>; 5] = [
        Source::new(FieldId::new(1), "a", |m| &m.values[0], |m| &mut m.values[0]),
        Source::new(FieldId::new(2), "b", |m| &m.values[1], |m| &mut m.values[1]),
        Source::new(FieldId::new(3), "c", |m| &m.values[2], |m| &mut m.values[2]),
        Source::new(FieldId::new(4), "d", |m| &m.values[3], |m| &mut m.values[3]),
        Source::new(FieldId::new(5), "e", |m| &m.values[4], |m| &mut m.values[4]),
    ];
    fn new(values: [String; 5]) -> Self {
        Self {
            values: values.map(Signal::new),
        }
    }
}
impl<const O: bool, const N: bool> View for Panel<O, N> {
    fn sources() -> Sources<Self> {
        let s = if O {
            Sources::new().field(Self::FIELDS[0])
        } else {
            Sources::new().direct(Self::FIELDS[0])
        };
        s.direct(Self::FIELDS[1])
            .direct(Self::FIELDS[2])
            .direct(Self::FIELDS[3])
            .direct(Self::FIELDS[4])
    }
    fn view(&self) -> El<'_> {
        column((
            row(self.values.iter().enumerate().map(|(i, v)| {
                let e = text(v).w(48).h(20);
                if N && i == 0 {
                    e.name(&self.values[1])
                } else {
                    e
                }
            })),
            O.then(|| text(format!("owner:{}", self.values[0].as_str()))),
        ))
    }
}
fn options() -> WindowOptions {
    WindowOptions {
        size: [256, 64],
        ..Default::default()
    }
}
fn ack<M: View + 'static, L: LaneSet<M>>(win: &mut Win<M, L>) {
    let token = win.with_scene(|_, t| t).unwrap();
    win.presented(token).unwrap();
}
fn open<const O: bool, const N: bool>() -> (
    Win<Panel<O, N>, impl LaneSet<Panel<O, N>>>,
    [Remote<String>; 5],
) {
    let win = Win::recording(
        Panel::<O, N>::new(std::array::from_fn(|i| format!("old{i}"))),
        options(),
    )
    .unwrap();
    let (a, ai) = Remote::bounded(4);
    let (b, bi) = Remote::bounded(4);
    let (c, ci) = Remote::bounded(4);
    let (d, di) = Remote::bounded(4);
    let (e, ei) = Remote::bounded(4);
    let mut win = win
        .with_inbox_for(ai, Panel::FIELDS[0], |v, n| *v = n)
        .unwrap()
        .with_inbox_for(bi, Panel::FIELDS[1], |v, n| *v = n)
        .unwrap()
        .with_inbox_for(ci, Panel::FIELDS[2], |v, n| *v = n)
        .unwrap()
        .with_inbox_for(di, Panel::FIELDS[3], |v, n| *v = n)
        .unwrap()
        .with_inbox_for(ei, Panel::FIELDS[4], |v, n| *v = n)
        .unwrap();
    ack(&mut win);
    win.reset_counters().unwrap();
    (win, [a, b, c, d, e])
}
fn oracle<const O: bool, const N: bool, L: LaneSet<Panel<O, N>>>(win: &mut Win<Panel<O, N>, L>) {
    let values = win.root().unwrap().values.each_ref().map(|v| v.to_string());
    let mut fresh = Win::recording(Panel::<O, N>::new(values), options()).unwrap();
    ack(&mut fresh);
    let actual = win.with_pixels(|p, _, _| p.to_vec()).unwrap();
    let expected = fresh.with_pixels(|p, _, _| p.to_vec()).unwrap();
    assert_eq!(actual, expected);
}
fn send(remotes: &[Remote<String>; 5], count: usize) {
    for (i, r) in remotes.iter().enumerate().take(count) {
        r.try_send(format!("new{i}")).unwrap();
    }
}
#[test]
fn four_disjoint_visual_sources_publish_one_exact_cohort() {
    let (mut win, r) = open::<false, false>();
    send(&r, 4);
    let d = win.deliver_ready(8).unwrap();
    assert_eq!((d.received, d.applied), (4, 4));
    assert_eq!(d.commit.source_epoch, 1);
    assert_eq!(d.commit.changed_nodes, 4);
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(win.counters().exact_updates, 1);
    assert_eq!(win.counters().source_operations, 1);
    for i in 0..4 {
        assert!(win.contains_text(&format!("new{i}")).unwrap());
    }
    ack(&mut win);
    oracle(&mut win);
}
#[test]
fn fifth_distinct_source_keeps_the_existing_coarse_boundary() {
    let (mut win, r) = open::<false, false>();
    send(&r, 5);
    assert_eq!(win.deliver_ready(8).unwrap().applied, 5);
    assert_eq!(win.counters().owner_reruns, 1);
    ack(&mut win);
    oracle(&mut win);
}
#[test]
fn owner_dependent_source_cannot_reuse_only_its_bound_text_destinations() {
    let (mut win, r) = open::<true, false>();
    send(&r, 2);
    win.deliver_ready(8).unwrap();
    assert!(win.contains_text("owner:new0").unwrap());
    assert_eq!(win.counters().owner_reruns, 1);
    ack(&mut win);
    oracle(&mut win);
}
#[test]
fn metadata_destinations_keep_the_existing_coarse_boundary() {
    let (mut win, r) = open::<false, true>();
    send(&r, 2);
    win.deliver_ready(8).unwrap();
    assert_eq!(win.counters().owner_reruns, 1);
    ack(&mut win);
    oracle(&mut win);
}
#[test]
fn failed_newer_batch_does_not_revoke_an_older_complete_candidate() {
    let (mut win, r) = open::<false, false>();
    send(&r, 2);
    win.deliver_ready(8).unwrap();
    let old = win.with_scene(|_, token| token).unwrap();
    r[0].try_send("漢".into()).unwrap();
    r[1].try_send("bad-peer".into()).unwrap();
    let error = win.deliver_ready(8).unwrap_err();
    assert_eq!(error.delivery.unwrap().applied, 2);
    win.presented(old).unwrap();
    r[0].try_send("fixed".into()).unwrap();
    r[1].try_send("peer".into()).unwrap();
    win.deliver_ready(8).unwrap();
    ack(&mut win);
    oracle(&mut win);
}
