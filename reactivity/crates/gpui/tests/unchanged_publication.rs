//! Exact unchanged output reuses the complete sheet, including its authority.
use gpui::{Error, WindowOptions, prelude::*};

struct Panel {
    width: Signal<f64>,
    transform: Signal<Affine>,
    unused: Signal<u64>,
}
impl Panel {
    const WIDTH: Source<Self, f64> =
        Source::new(FieldId::new(1), "width", |m| &m.width, |m| &mut m.width);
    const TRANSFORM: Source<Self, Affine> = Source::new(
        FieldId::new(2),
        "transform",
        |m| &m.transform,
        |m| &mut m.transform,
    );
    const UNUSED: Source<Self, u64> =
        Source::new(FieldId::new(3), "unused", |m| &m.unused, |m| &mut m.unused);
    fn new() -> Self {
        Self {
            width: Signal::new(40.),
            transform: Signal::new(Affine::IDENTITY),
            unused: Signal::new(0),
        }
    }
}
impl View for Panel {
    fn sources() -> Sources<Self> {
        Sources::new()
            .direct(Self::WIDTH)
            .direct(Self::TRANSFORM)
            .direct(Self::UNUSED)
    }
    fn view(&self) -> El<'_> {
        column((
            div()
                .name("surface")
                .w(&self.width)
                .h(10)
                .bg(Color::BLACK)
                .transform(&self.transform),
            column((0..128).map(|_| div().name("stable").size(1))),
        ))
    }
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
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
    win
}
#[test]
fn exact_noops_admit_sources_without_freezing_semantic_rows() {
    for kind in 0..3 {
        let mut win = recording();
        let before = win.root().unwrap().width.revision();
        let token = win.with_scene(|_, token| token).unwrap();
        win.reset_counters().unwrap();
        let cost = allocation_counter::measure(|| {
            for i in 0..32 {
                match kind {
                    0 => {
                        win.set(Panel::WIDTH, 40.).unwrap();
                    }
                    1 => {
                        win.set(Panel::TRANSFORM, Affine::IDENTITY).unwrap();
                    }
                    _ => {
                        win.set(Panel::UNUSED, i).unwrap();
                    }
                }
            }
        });
        assert_eq!(
            cost.count_total, 0,
            "no new immutable sheet for exact equal output"
        );
        assert_eq!(win.with_scene(|_, next| next).unwrap(), token);
        assert_eq!(win.counters().source_operations, 32);
        assert_eq!(win.counters().paint_passes, 0);
        assert_eq!(win.counters().descriptions, 0);
        assert_eq!(win.counters().layout_runs, 0);
        if kind == 0 {
            assert_ne!(win.root().unwrap().width.revision(), before);
        }
        assert!(win.hit_target(Point { x: 1., y: 1. }).is_ok());
    }
}
#[test]
fn unchanged_publication_preserves_pending_failed_and_lost_cohorts() {
    let mut win = recording();
    let target = win.query().name("surface").one().unwrap();
    let old = win.bounds(target).unwrap();
    win.set(Panel::WIDTH, 24.).unwrap();
    let pending = win.with_scene(|_, token| token).unwrap();
    let equal = win.set(Panel::WIDTH, 24.).unwrap();
    assert_eq!(win.with_scene(|_, token| token).unwrap(), pending);
    assert_eq!(win.bounds(target).unwrap(), old);
    assert!(matches!(
        win.hit_target(Point { x: 1., y: 1. }),
        Err(Error::PresentationStale)
    ));
    let presented = win.presented(pending).unwrap();
    assert_eq!(presented.presentation_epoch, equal.source_epoch);
    assert_eq!(win.bounds(target).unwrap().width, 24.);

    assert!(win.set(Panel::TRANSFORM, Affine::scale(0., 1.)).is_err());
    assert!(
        win.set(Panel::WIDTH, 24.).is_err(),
        "equal source cannot relabel a failed newer visual"
    );
    assert_eq!(win.with_scene(|_, token| token).unwrap(), pending);
    let ack = win.presented(pending).unwrap();
    assert!(ack.presentation_epoch < ack.source_epoch);
    assert!(matches!(
        win.hit_target(Point { x: 1., y: 1. }),
        Err(Error::PresentationStale)
    ));

    win.set(Panel::TRANSFORM, Affine::IDENTITY).unwrap();
    let complete = win.with_scene(|_, token| token).unwrap();
    win.presented(complete).unwrap();
    win.presentation_lost().unwrap();
    let equal = win.set(Panel::UNUSED, 99).unwrap();
    assert!(!equal.presentation_valid);
    assert!(matches!(
        win.hit_target(Point { x: 1., y: 1. }),
        Err(Error::PresentationStale)
    ));
    let ack = win.presented(complete).unwrap();
    assert_eq!(ack.presentation_epoch, equal.source_epoch);
    assert!(ack.presentation_valid);
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
        text_input(&self.value).name("input").w(60).h(24)
    }
}
#[test]
fn equal_text_output_still_publishes_the_changed_caret() {
    use gpui::TextSelection;
    let range = |a, b| TextSelection::from_bytes(a, b).unwrap();
    let mut win = Win::recording(
        Input {
            value: Signal::new("abc".into()),
        },
        WindowOptions {
            size: [64, 64],
            ..Default::default()
        },
    )
    .unwrap();
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    let input = win.input();
    win.focus(input).unwrap();
    win.select(input, range(0, 2)).unwrap();
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    let previous = win.with_scene(|_, token| token).unwrap();
    let frozen_selection = |win: &Win<Input>| {
        let mut value = None;
        win.visit(|part| {
            if part.target() == input {
                value = part.selection();
            }
        })
        .unwrap();
        value.unwrap()
    };
    assert_eq!(frozen_selection(&win), range(0, 2));
    win.reset_counters().unwrap();
    win.type_text(input, "ab").unwrap();
    assert_eq!(win.root().unwrap().value.as_str(), "abc");
    assert_eq!(win.selection(input).unwrap(), range(2, 2));
    assert_eq!(frozen_selection(&win), range(0, 2));
    let next = win.with_scene(|_, token| token).unwrap();
    assert_ne!(
        previous, next,
        "equal bytes do not prove unchanged caret pixels"
    );
    win.presented(next).unwrap();
    assert_eq!(frozen_selection(&win), range(2, 2));
    assert_eq!(win.counters().text_promotions, 0);
    assert_eq!(win.counters().paint_passes, 1);
    let mut oracle = Win::with_size(
        Input {
            value: Signal::new("abc".into()),
        },
        64,
        64,
    )
    .unwrap();
    oracle.focus(oracle.input()).unwrap();
    oracle.select(oracle.input(), range(2, 2)).unwrap();
    let pixels = win.with_pixels(|p, _, _| p.to_vec()).unwrap();
    oracle.with_pixels(|p, _, _| assert_eq!(pixels, p)).unwrap();
}
#[test]
fn inspector_enabled_noops_preserve_full_publication_parity() {
    let options = WindowOptions {
        size: [640, 480],
        ..Default::default()
    };
    let mut exact = Win::with_inspector(Panel::new(), options).unwrap();
    let mut coarse = Win::with_inspector(Panel::new(), options).unwrap();
    let a = exact.query().name("surface").one().unwrap();
    let b = coarse.query().name("surface").one().unwrap();
    exact.inspector_select(a).unwrap();
    coarse.inspector_select(b).unwrap();
    for i in 0..3 {
        exact.set(Panel::WIDTH, 40.).unwrap();
        coarse.update(|m| *m.width = 40.).unwrap();
        exact.set(Panel::UNUSED, i).unwrap();
        coarse.update(|m| *m.unused = i).unwrap();
        let mut x = exact.snapshot().unwrap().nodes;
        let mut y = coarse.snapshot().unwrap().nodes;
        for row in &mut x {
            row.target = None;
        }
        for row in &mut y {
            row.target = None;
        }
        assert_eq!(x, y);
        assert_eq!(exact.inspector_selected().unwrap(), Some(a));
        assert_eq!(coarse.inspector_selected().unwrap(), Some(b));
        let pixels = exact.with_pixels(|p, _, _| p.to_vec()).unwrap();
        coarse.with_pixels(|p, _, _| assert_eq!(pixels, p)).unwrap();
    }
}
