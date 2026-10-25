//! Explicit multi-edit publication, not hidden workload coalescing.
use gpui::property::{Contribution, HEIGHT, WIDTH};
use gpui::{Error, PresentationToken, SetError, WindowOptions, prelude::*};
use std::panic::{AssertUnwindSafe, catch_unwind};

struct Panel {
    width: Signal<f64>,
    map: Signal<Affine>,
    color: Signal<Color>,
    description: Signal<String>,
}
impl Panel {
    const WIDTH: Source<Self, f64> =
        Source::new(FieldId::new(1), "width", |m| &m.width, |m| &mut m.width);
    const MAP: Source<Self, Affine> =
        Source::new(FieldId::new(2), "map", |m| &m.map, |m| &mut m.map);
    const COLOR: Source<Self, Color> =
        Source::new(FieldId::new(3), "color", |m| &m.color, |m| &mut m.color);
    const DESCRIPTION: Source<Self, String> = Source::new(
        FieldId::new(4),
        "description",
        |m| &m.description,
        |m| &mut m.description,
    );
    fn new() -> Self {
        Self {
            width: Signal::new(40.),
            map: Signal::new(Affine::IDENTITY),
            color: Signal::new(Color::BLACK),
            description: Signal::new("old".into()),
        }
    }
}
impl View for Panel {
    fn sources() -> Sources<Self> {
        Sources::new()
            .direct(Self::WIDTH)
            .direct(Self::MAP)
            .direct(Self::COLOR)
            .direct(Self::DESCRIPTION)
    }
    fn view(&self) -> El<'_> {
        column((
            div()
                .name("left")
                .description(&self.description)
                .w(&self.width)
                .h(10)
                .transform(&self.map)
                .bg(&self.color),
            div().name("right").size(10).bg(Color::WHITE),
            column((0..128).map(|_| div().size(1))),
        ))
    }
}
fn token(win: &Win<Panel>) -> PresentationToken {
    win.with_scene(|_, token| token).unwrap()
}
fn ack(win: &mut Win<Panel>) {
    win.presented(token(win)).unwrap();
}
fn recording() -> Win<Panel> {
    let mut win = Win::recording(
        Panel::new(),
        WindowOptions {
            size: [64, 64],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    win.reset_counters().unwrap();
    win
}
fn equivalent(a: &mut Win<Panel>, b: &mut Win<Panel>) {
    let nodes = |w: &Win<Panel>| {
        let mut nodes = w.snapshot().unwrap().nodes;
        for n in &mut nodes {
            n.target = None;
        }
        nodes
    };
    assert_eq!(nodes(a), nodes(b));
    let semantics = |w: &Win<Panel>| {
        let mut out = Vec::new();
        w.visit(|p| {
            out.push((
                p.name().map(str::to_owned),
                p.description().map(str::to_owned),
                p.text().map(str::to_owned),
                p.role(),
            ))
        })
        .unwrap();
        out
    };
    assert_eq!(semantics(a), semantics(b));
    let pixels = a.with_pixels(|p, _, _| p.to_vec()).unwrap();
    b.with_pixels(|p, _, _| assert_eq!(pixels, p)).unwrap();
    for y in [0., 5., 10., 20., 63.] {
        for x in [0., 5., 15., 30., 63.] {
            let point = Point { x, y };
            let ah = a.hit_target(point).unwrap();
            let bh = b.hit_target(point).unwrap();
            let idx = |w: &Win<Panel>, t: Option<Target>| {
                w.snapshot()
                    .unwrap()
                    .nodes
                    .iter()
                    .position(|n| n.target == t && t.is_some())
            };
            assert_eq!(idx(a, ah), idx(b, bh));
        }
    }
}
#[test]
fn hover_leave_enter_admits_both_properties_but_prepares_once() {
    let mut a = recording();
    let mut b = recording();
    let al = a.query().name("left").one().unwrap();
    let ar = a.query().name("right").one().unwrap();
    let bl = b.query().name("left").one().unwrap();
    let br = b.query().name("right").one().unwrap();
    a.set_property(al, HEIGHT, Contribution::Set(Some(12.)))
        .unwrap();
    b.set_property(bl, HEIGHT, Contribution::Set(Some(12.)))
        .unwrap();
    ack(&mut a);
    ack(&mut b);
    a.reset_counters().unwrap();
    b.reset_counters().unwrap();
    a.set_property(al, HEIGHT, Contribution::Inherit).unwrap();
    a.set_property(ar, HEIGHT, Contribution::Set(Some(12.)))
        .unwrap();
    let mut turn = b.edit_turn().unwrap();
    let first = turn
        .set_property(bl, HEIGHT, Contribution::Inherit)
        .unwrap();
    let second = turn
        .set_property(br, HEIGHT, Contribution::Set(Some(12.)))
        .unwrap();
    assert!(first.prepared_epoch.is_none() && second.prepared_epoch.is_none());
    turn.finish().unwrap();
    assert_eq!(a.counters().source_operations, 2);
    assert_eq!(b.counters().source_operations, 2);
    assert_eq!(a.counters().paint_passes, 2);
    assert_eq!(b.counters().paint_passes, 1);
    ack(&mut a);
    ack(&mut b);
    equivalent(&mut a, &mut b);
}
#[test]
fn mixed_exact_changes_preserve_admission_and_publish_final_semantics_once() {
    let mut a = recording();
    let mut b = recording();
    a.set(Panel::WIDTH, 24.).unwrap();
    a.set(Panel::MAP, Affine::translation(3., 0.)).unwrap();
    a.set(Panel::COLOR, Color::rgb(50, 90, 130)).unwrap();
    a.set(Panel::DESCRIPTION, "new".into()).unwrap();
    let mut turn = b.edit_turn().unwrap();
    for receipt in [
        turn.set(Panel::WIDTH, 24.).unwrap(),
        turn.set(Panel::MAP, Affine::translation(3., 0.)).unwrap(),
        turn.set(Panel::COLOR, Color::rgb(50, 90, 130)).unwrap(),
        turn.set(Panel::DESCRIPTION, "new".into()).unwrap(),
    ] {
        assert!(receipt.prepared_epoch.is_none());
        assert!(receipt.presentation_epoch < receipt.source_epoch);
    }
    assert_eq!(*turn.read(Panel::WIDTH).unwrap(), 24.);
    turn.finish().unwrap();
    assert_eq!(b.counters().source_operations, 4);
    assert_eq!(b.counters().source_reads, 4);
    assert_eq!(b.counters().paint_passes, 1);
    ack(&mut a);
    ack(&mut b);
    equivalent(&mut a, &mut b);
}
#[test]
fn cancelling_changes_are_still_admitted_and_empty_turn_is_idle() {
    let mut a = recording();
    let mut b = recording();
    let before = token(&b);
    let epoch = b.snapshot().unwrap().source_epoch;
    b.edit_turn().unwrap().finish().unwrap();
    assert_eq!(b.snapshot().unwrap().source_epoch, epoch);
    assert_eq!(b.counters().paint_passes, 0);
    assert_eq!(token(&b), before);
    a.set(Panel::WIDTH, 20.).unwrap();
    a.set(Panel::WIDTH, 40.).unwrap();
    let mut turn = b.edit_turn().unwrap();
    turn.set(Panel::WIDTH, 20.).unwrap();
    turn.set(Panel::WIDTH, 40.).unwrap();
    turn.finish().unwrap();
    assert_eq!(b.counters().source_operations, 2);
    assert_eq!(b.counters().paint_passes, 1);
    ack(&mut a);
    ack(&mut b);
    equivalent(&mut a, &mut b);
}
#[test]
fn drop_without_finish_keeps_old_sheets_and_settle_realizes_the_prefix() {
    let mut a = recording();
    let mut b = recording();
    let before = token(&b);
    let left = b.query().name("left").one().unwrap();
    let bounds = b.bounds(left).unwrap();
    {
        let mut turn = b.edit_turn().unwrap();
        turn.set(Panel::WIDTH, 20.).unwrap();
    }
    assert_eq!(token(&b), before);
    assert_eq!(b.bounds(left).unwrap(), bounds);
    assert_eq!(b.counters().paint_passes, 0);
    assert_eq!(*b.read(Panel::WIDTH).unwrap(), 20.);
    assert!(matches!(
        b.hit_target(Point { x: 1., y: 1. }),
        Err(Error::PresentationStale)
    ));
    let old = b.presented(before).unwrap();
    assert!(old.presentation_epoch < old.source_epoch);
    b.settle().unwrap();
    a.set(Panel::WIDTH, 20.).unwrap();
    ack(&mut a);
    ack(&mut b);
    equivalent(&mut a, &mut b);
}
#[test]
fn rejected_second_edit_can_be_caught_then_finish_the_accepted_prefix() {
    let mut a = recording();
    let mut b = recording();
    let left = b.query().name("left").one().unwrap();
    let mut turn = b.edit_turn().unwrap();
    turn.set(Panel::WIDTH, 20.).unwrap();
    assert!(
        turn.set_property(left, WIDTH, Contribution::Set(Some(-1.)))
            .is_err()
    );
    turn.finish().unwrap();
    assert_eq!(b.counters().source_operations, 1);
    assert_eq!(b.counters().paint_passes, 1);
    a.set(Panel::WIDTH, 20.).unwrap();
    ack(&mut a);
    ack(&mut b);
    equivalent(&mut a, &mut b);
}
#[test]
fn committed_edit_error_must_be_repaired_before_finish_can_publish() {
    let mut a = recording();
    let mut b = recording();
    let before = token(&b);
    let mut turn = b.edit_turn().unwrap();
    assert!(matches!(
        turn.set(Panel::WIDTH, f64::NAN),
        Err(SetError::Committed { .. })
    ));
    assert!(turn.finish().is_err());
    assert_eq!(token(&b), before);
    assert_eq!(b.counters().paint_passes, 0);
    let mut turn = b.edit_turn().unwrap();
    turn.set(Panel::WIDTH, 20.).unwrap();
    turn.finish().unwrap();
    // The reference must follow the same rejected-description history: a
    // committed invalid source revokes logical identities before repair.
    assert!(matches!(
        a.set(Panel::WIDTH, f64::NAN),
        Err(SetError::Committed { .. })
    ));
    assert!(a.settle().is_err());
    a.set(Panel::WIDTH, 20.).unwrap();
    ack(&mut a);
    ack(&mut b);
    equivalent(&mut a, &mut b);
}
#[test]
fn failed_finish_preserves_older_eligible_candidate_and_requires_real_repair() {
    let mut a = recording();
    let mut b = recording();
    b.set(Panel::WIDTH, 30.).unwrap();
    let eligible = token(&b);
    let old = b.snapshot().unwrap().nodes;
    let mut turn = b.edit_turn().unwrap();
    turn.set(Panel::WIDTH, 20.).unwrap();
    turn.set(Panel::MAP, Affine::scale(0., 1.)).unwrap();
    assert!(turn.finish().is_err());
    assert_eq!(token(&b), eligible);
    assert_eq!(b.snapshot().unwrap().nodes, old);
    let acked = b.presented(eligible).unwrap();
    assert!(acked.presentation_epoch < acked.source_epoch);
    assert!(b.settle().is_err());
    b.set(Panel::MAP, Affine::IDENTITY).unwrap();
    a.set(Panel::WIDTH, 20.).unwrap();
    ack(&mut a);
    ack(&mut b);
    equivalent(&mut a, &mut b);
}
#[test]
fn caller_unwind_drops_without_publishing_or_losing_the_logical_prefix() {
    let mut a = recording();
    let mut b = recording();
    let before = token(&b);
    assert!(
        catch_unwind(AssertUnwindSafe(|| {
            let mut turn = b.edit_turn().unwrap();
            turn.set(Panel::WIDTH, 20.).unwrap();
            panic!("caller failure");
        }))
        .is_err()
    );
    assert_eq!(token(&b), before);
    assert_eq!(b.counters().paint_passes, 0);
    b.settle().unwrap();
    a.set(Panel::WIDTH, 20.).unwrap();
    ack(&mut a);
    ack(&mut b);
    equivalent(&mut a, &mut b);
}
#[test]
fn dropped_prefix_is_realized_by_a_later_edit_without_cheap_old_cohort_ack() {
    let mut a = recording();
    let mut b = recording();
    let before = token(&b);
    {
        let mut turn = b.edit_turn().unwrap();
        turn.set(Panel::WIDTH, 20.).unwrap();
    }
    b.set(Panel::COLOR, Color::BLACK).unwrap();
    assert_ne!(token(&b), before);
    assert_eq!(b.counters().paint_passes, 1);
    a.set(Panel::WIDTH, 20.).unwrap();
    ack(&mut a);
    ack(&mut b);
    equivalent(&mut a, &mut b);
}

#[test]
fn owner_callback_panic_keeps_existing_poison_policy_without_publication() {
    let mut win = recording();
    let mut turn = win.edit_turn().unwrap();
    assert!(matches!(
        turn.update(|_| panic!("owner failure")),
        Err(Error::OwnerPanicked)
    ));
    assert!(turn.finish().is_err());
    assert_eq!(win.counters().paint_passes, 0);
    assert!(win.settle().is_err());
}
#[test]
fn forgetting_a_borrow_guard_cannot_leave_deferred_policy_in_the_window() {
    let mut a = recording();
    let mut b = recording();
    let mut turn = b.edit_turn().unwrap();
    turn.set(Panel::WIDTH, 20.).unwrap();
    std::mem::forget(turn);
    b.set(Panel::COLOR, Color::BLACK).unwrap();
    assert_eq!(b.counters().paint_passes, 1);
    a.set(Panel::WIDTH, 20.).unwrap();
    ack(&mut a);
    ack(&mut b);
    equivalent(&mut a, &mut b);
}

#[test]
fn first_color_equal_or_metadata_edit_cannot_publish_through_a_deferred_turn() {
    for mode in 0..3 {
        let mut a = recording();
        let mut b = recording();
        let mut turn = b.edit_turn().unwrap();
        let receipt = match mode {
            0 => turn.set(Panel::COLOR, Color::rgb(50, 90, 130)).unwrap(),
            1 => turn.set(Panel::WIDTH, 40.).unwrap(),
            _ => turn.set(Panel::DESCRIPTION, "new".into()).unwrap(),
        };
        assert!(receipt.prepared_epoch.is_none());
        assert!(receipt.presentation_epoch < receipt.source_epoch);
        turn.set(Panel::WIDTH, 24.).unwrap();
        turn.finish().unwrap();
        match mode {
            0 => {
                a.set(Panel::COLOR, Color::rgb(50, 90, 130)).unwrap();
            }
            1 => {
                a.set(Panel::WIDTH, 40.).unwrap();
            }
            _ => {
                a.set(Panel::DESCRIPTION, "new".into()).unwrap();
            }
        }
        a.set(Panel::WIDTH, 24.).unwrap();
        assert_eq!(b.counters().source_operations, 2);
        assert_eq!(b.counters().paint_passes, 1);
        ack(&mut a);
        ack(&mut b);
        equivalent(&mut a, &mut b);
    }
}

#[test]
fn inspector_observes_final_admitted_properties_and_publishes_once() {
    let options = WindowOptions {
        size: [640, 480],
        ..Default::default()
    };
    let mut a = Win::with_inspector(Panel::new(), options).unwrap();
    let mut b = Win::with_inspector(Panel::new(), options).unwrap();
    let al = a.query().name("left").one().unwrap();
    let bl = b.query().name("left").one().unwrap();
    a.inspector_select(al).unwrap();
    b.inspector_select(bl).unwrap();
    a.reset_counters().unwrap();
    b.reset_counters().unwrap();
    a.set_property(al, WIDTH, Contribution::Set(Some(24.)))
        .unwrap();
    a.set_property(al, HEIGHT, Contribution::Set(Some(14.)))
        .unwrap();
    let mut turn = b.edit_turn().unwrap();
    turn.set_property(bl, WIDTH, Contribution::Set(Some(24.)))
        .unwrap();
    turn.set_property(bl, HEIGHT, Contribution::Set(Some(14.)))
        .unwrap();
    turn.finish().unwrap();
    assert_eq!(b.counters().paint_passes, 1);
    assert_eq!(a.counters().paint_passes, 2);
    assert_eq!(b.inspector_selected().unwrap(), Some(bl));
    equivalent(&mut a, &mut b);
}

struct Input {
    value: Signal<String>,
}
impl Input {
    const VALUE: Source<Self, String> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
}
impl View for Input {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE)
    }
    fn view(&self) -> El<'_> {
        text_input(&self.value).name("input").w(70).h(24)
    }
}
#[test]
fn active_selection_and_ime_reconcile_each_admission_before_final_publication() {
    use gpui::{ImeEvent, ImeSession, TextSelection};
    let input_window = || {
        let mut win = Win::recording(
            Input {
                value: Signal::new("abcdef".into()),
            },
            WindowOptions {
                size: [80, 40],
                ..Default::default()
            },
        )
        .unwrap();
        let ack = |w: &mut Win<Input>| {
            let token = w.with_scene(|_, t| t).unwrap();
            w.presented(token).unwrap();
        };
        ack(&mut win);
        let target = win.input();
        win.focus(target).unwrap();
        win.select(target, TextSelection::from_bytes(2, 4).unwrap())
            .unwrap();
        ack(&mut win);
        let mut session = ImeSession::default();
        win.ime_event(&mut session, ImeEvent::Enabled).unwrap();
        win.ime_event(
            &mut session,
            ImeEvent::Preedit {
                text: "XYZ",
                cursor: Some((1, 1)),
            },
        )
        .unwrap();
        ack(&mut win);
        win.reset_counters().unwrap();
        (win, target, session)
    };
    let (mut a, at, mut asession) = input_window();
    let (mut b, bt, mut bsession) = input_window();
    let old = b.snapshot().unwrap().nodes;
    a.set(Input::VALUE, "ab".into()).unwrap();
    a.set(Input::VALUE, "abQ".into()).unwrap();
    let mut turn = b.edit_turn().unwrap();
    turn.set(Input::VALUE, "ab".into()).unwrap();
    turn.set(Input::VALUE, "abQ".into()).unwrap();
    turn.finish().unwrap();
    assert_eq!(
        b.snapshot().unwrap().nodes,
        old,
        "pending candidate cannot expose new caret/IME state as acknowledged"
    );
    assert_eq!(b.counters().source_operations, 2);
    assert_eq!(b.counters().paint_passes, 1);
    assert_eq!(a.counters().paint_passes, 2);
    assert_eq!(a.selection(at).unwrap(), b.selection(bt).unwrap());
    for win in [&mut a, &mut b] {
        let token = win.with_scene(|_, t| t).unwrap();
        win.presented(token).unwrap();
    }
    let nodes = |w: &Win<Input>| {
        let mut n = w.snapshot().unwrap().nodes;
        for n in &mut n {
            n.target = None;
        }
        n
    };
    assert_eq!(nodes(&a), nodes(&b));
    let frozen = |w: &Win<Input>| {
        let mut out = Vec::new();
        w.visit(|p| out.push((p.value().map(str::to_owned), p.selection(), p.marked_text())))
            .unwrap();
        out
    };
    assert_eq!(frozen(&a), frozen(&b));
    let pixels = a.with_pixels(|p, _, _| p.to_vec()).unwrap();
    b.with_pixels(|p, _, _| assert_eq!(pixels, p)).unwrap();
    // A source value change cancels preedit, not necessarily the still-enabled
    // platform session. Compare its actual ordinary admission, not an invented
    // rejection requirement.
    let ordinary = a.ime_event(&mut asession, ImeEvent::Commit("late"));
    let deferred = b.ime_event(&mut bsession, ImeEvent::Commit("late"));
    assert_eq!(ordinary.is_ok(), deferred.is_ok());
    if let (Err(a), Err(b)) = (&ordinary, &deferred) {
        assert_eq!(a.to_string(), b.to_string());
    }
    assert_eq!(a.read(Input::VALUE).unwrap(), b.read(Input::VALUE).unwrap());
    assert_eq!(a.selection(at).unwrap(), b.selection(bt).unwrap());
    if ordinary.is_ok() {
        for win in [&mut a, &mut b] {
            let token = win.with_scene(|_, t| t).unwrap();
            win.presented(token).unwrap();
        }
        assert_eq!(nodes(&a), nodes(&b));
        assert_eq!(frozen(&a), frozen(&b));
        let pixels = a.with_pixels(|p, _, _| p.to_vec()).unwrap();
        b.with_pixels(|p, _, _| assert_eq!(pixels, p)).unwrap();
    }
}
