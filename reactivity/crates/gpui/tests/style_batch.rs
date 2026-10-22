//! Source fanouts mutate shared patterns without changing public property laws.
use gpui::{
    WindowOptions,
    prelude::*,
    property::{BACKGROUND, Contribution, FOREGROUND},
};

struct Cohort {
    color: Signal<Color>,
    converging: bool,
}
impl Cohort {
    const COLOR: Source<Self, Color> =
        Source::new(FieldId::new(1), "color", |m| &m.color, |m| &mut m.color);
    fn literal() -> Color {
        Color::rgb(1, 2, 3)
    }
}
impl View for Cohort {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::COLOR)
    }
    fn view(&self) -> El<'_> {
        div().size(128).child((0..128).map(|i| {
            let el = div().w(if self.converging { 16 } else { i % 8 + 1 }).h(1);
            let el = if !self.converging {
                el.bg(&self.color).fg(&self.color)
            } else if i % 2 == 0 {
                el.bg(&self.color).fg(Self::literal())
            } else {
                el.bg(Self::literal()).fg(&self.color)
            };
            el.name(format!("item{i}"))
        }))
    }
}
fn owner(converging: bool) -> Win<Cohort> {
    let mut win = Win::recording(
        Cohort {
            color: Signal::new(Color::rgb(4, 5, 6)),
            converging,
        },
        WindowOptions {
            size: [128, 128],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    win
}
fn ack(win: &mut Win<Cohort>) {
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
}
fn targets(win: &Win<Cohort>) -> Vec<Target> {
    (0..128)
        .map(|i| win.query().name(&format!("item{i}")).one().unwrap())
        .collect()
}

#[test]
fn repeated_bg_fg_ports_preserve_counts_noops_and_acknowledged_geometry() {
    let mut win = owner(false);
    let targets = targets(&win);
    let before = win.bounds(targets[64]).unwrap();
    win.reset_counters().unwrap();
    let color = Color::linear_display_p3(-0.0, 0.5, 2.0, 1.0).unwrap();
    let commit = win.set(Cohort::COLOR, color).unwrap();
    assert_eq!(commit.changed_nodes, 128);
    assert_eq!(win.counters().destination_compares, 256);
    assert_eq!(win.counters().source_reads, 1);
    assert_eq!(win.counters().descriptions, 0);
    assert_eq!(win.counters().layout_runs, 0);
    for &target in &targets {
        assert!(
            win.property(target, BACKGROUND)
                .unwrap()
                .same_authoring(color)
        );
        assert!(
            win.property(target, FOREGROUND)
                .unwrap()
                .same_authoring(color)
        );
    }
    assert_eq!(win.bounds(targets[64]).unwrap(), before);
    ack(&mut win);
    win.reset_counters().unwrap();
    let commit = win.set(Cohort::COLOR, color).unwrap();
    assert_eq!(commit.changed_nodes, 0);
    assert_eq!(win.counters().presentations, 0);
    assert_eq!(win.counters().descriptions, 0);
}

#[test]
fn convergence_never_retargets_literal_or_masked_peers_and_inherit_reveals_latest_base() {
    let mut win = owner(true);
    let targets = targets(&win);
    win.set_property(targets[0], BACKGROUND, Contribution::Set(Cohort::literal()))
        .unwrap();
    ack(&mut win);
    for turn in 0..64 {
        let color = if turn % 2 == 0 {
            Cohort::literal()
        } else {
            Color::rgb(10, 20, 30)
        };
        win.reset_counters().unwrap();
        win.set(Cohort::COLOR, color).unwrap();
        assert_eq!(win.counters().descriptions, 0);
        assert_eq!(win.counters().owner_reruns, 0);
        for (index, &target) in targets.iter().enumerate() {
            let bg = if index != 0 && index % 2 == 0 {
                color
            } else {
                Cohort::literal()
            };
            let fg = if index % 2 == 0 {
                Cohort::literal()
            } else {
                color
            };
            assert!(win.property(target, BACKGROUND).unwrap().same_authoring(bg));
            assert!(win.property(target, FOREGROUND).unwrap().same_authoring(fg));
        }
        ack(&mut win);
    }
    let latest = Color::rgb(10, 20, 30);
    win.set_property(targets[0], BACKGROUND, Contribution::Inherit)
        .unwrap();
    assert!(
        win.property(targets[0], BACKGROUND)
            .unwrap()
            .same_authoring(latest)
    );
    assert!(
        win.property(targets[1], BACKGROUND)
            .unwrap()
            .same_authoring(Cohort::literal())
    );
}
