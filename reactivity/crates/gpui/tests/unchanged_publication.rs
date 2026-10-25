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
