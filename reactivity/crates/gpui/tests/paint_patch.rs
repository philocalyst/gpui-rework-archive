use gpui::property::{BACKGROUND, Contribution};
use gpui::{Error, SetError, WindowOptions, prelude::*};

struct Panel {
    color: Signal<Color>,
    transform: Signal<Affine>,
}
impl Panel {
    const COLOR: Source<Self, Color> =
        Source::new(FieldId::new(1), "color", |m| &m.color, |m| &mut m.color);
    const TRANSFORM: Source<Self, Affine> = Source::new(
        FieldId::new(2),
        "transform",
        |m| &m.transform,
        |m| &mut m.transform,
    );
    fn new(color: Color) -> Self {
        Self {
            color: Signal::new(color),
            transform: Signal::new(Affine::IDENTITY),
        }
    }
}
impl View for Panel {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::COLOR).direct(Self::TRANSFORM)
    }
    fn view(&self) -> El<'_> {
        column((
            button("change")
                .name("control")
                .bg(&self.color)
                .fg(&self.color)
                .on_click(|_: &mut Self| {}),
            div()
                .name("surface")
                .size(40)
                .rounded(9.0)
                .bg(&self.color)
                .transform(&self.transform),
        ))
        .gap(4)
    }
}
fn ack(win: &mut Win<Panel>) {
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
}
fn pixels(win: &mut Win<Panel>) -> Vec<u8> {
    win.with_pixels(|p, _, _| p.to_vec()).unwrap()
}
fn oracle(color: Color, transform: Affine) -> Vec<u8> {
    let mut model = Panel::new(color);
    model.transform = Signal::new(transform);
    pixels(&mut Win::with_size(model, 100, 100).unwrap())
}
fn recording() -> Win<Panel> {
    let mut win = Win::recording(
        Panel::new(rgb(0x804020)),
        WindowOptions {
            size: [100, 100],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    win
}
#[test]
fn colors_commit_without_description_layout_or_paint_walk_and_match_full_oracle() {
    let mut win = Win::with_size(Panel::new(rgb(0x804020)), 100, 100).unwrap();
    win.reset_counters().unwrap();
    for color in [rgb(0x2080b0), rgb(0xc02040), rgb(0x101010)] {
        win.set(Panel::COLOR, color).unwrap();
        assert_eq!(pixels(&mut win), oracle(color, Affine::IDENTITY));
    }
    let counters = win.counters();
    assert_eq!(counters.owner_reruns, 0);
    assert_eq!(counters.layout_runs, 0);
    assert_eq!(counters.paint_passes, 0);
}
#[test]
fn pending_colors_preserve_targets_and_geometry_until_acknowledgement() {
    let mut win = recording();
    let target = win.query().name("surface").one().unwrap();
    let bounds = win.bounds(target).unwrap();
    let a = win.set(Panel::COLOR, rgb(0x2080b0)).unwrap();
    let token_a = win.with_scene(|_, token| token).unwrap();
    assert_eq!(a.presentation_epoch, 0);
    win.set(Panel::COLOR, rgb(0xc02040)).unwrap();
    let token_b = win.with_scene(|_, token| token).unwrap();
    assert_ne!(token_a, token_b);
    assert!(matches!(
        win.presented(token_a),
        Err(Error::StalePresentation)
    ));
    assert_eq!(win.bounds(target).unwrap(), bounds);
    assert_eq!(pixels(&mut win), oracle(rgb(0xc02040), Affine::IDENTITY));
    win.presented(token_b).unwrap();
    assert_eq!(win.query().name("surface").one().unwrap(), target);
}
#[test]
fn paint_preserves_prior_full_candidate_and_failed_newer_visual_is_not_relabelled() {
    let mut win = recording();
    let target = win.query().name("surface").one().unwrap();
    let old = win.bounds(target).unwrap();
    win.set(Panel::TRANSFORM, Affine::translation(7.0, 0.0))
        .unwrap();
    win.reset_counters().unwrap();
    win.set(Panel::COLOR, rgb(0xabcdef)).unwrap();
    assert_eq!(win.counters().paint_passes, 0);
    let complete = win.with_scene(|_, token| token).unwrap();
    assert_eq!(win.bounds(target).unwrap(), old);
    win.presented(complete).unwrap();
    let mut expected = Panel::new(rgb(0xabcdef));
    expected.transform = Signal::new(Affine::translation(7.0, 0.0));
    let expected = Win::with_size(expected, 100, 100).unwrap();
    assert_eq!(
        win.bounds(target).unwrap(),
        expected
            .bounds(expected.query().name("surface").one().unwrap())
            .unwrap()
    );
    win.set(Panel::TRANSFORM, Affine::translation(9.0, 0.0))
        .unwrap();
    let prior = win.with_scene(|_, token| token).unwrap();
    assert!(matches!(
        win.set(Panel::TRANSFORM, Affine::scale(0.0, 1.0)),
        Err(SetError::Committed {
            error: Error::Canvas(_),
            ..
        })
    ));
    assert!(win.set(Panel::COLOR, rgb(0x102030)).is_err());
    assert_eq!(win.with_scene(|_, token| token).unwrap(), prior);
    win.presented(prior).unwrap();
    let mut expected = Panel::new(rgb(0xabcdef));
    expected.transform = Signal::new(Affine::translation(9.0, 0.0));
    let expected = Win::with_size(expected, 100, 100).unwrap();
    assert_eq!(
        win.bounds(target).unwrap(),
        expected
            .bounds(expected.query().name("surface").one().unwrap())
            .unwrap()
    );
}
#[test]
fn masked_bases_and_alpha_topology_fallback_remain_exact() {
    let mut win = Win::with_size(Panel::new(rgb(0x804020)), 100, 100).unwrap();
    let target = win.query().name("surface").one().unwrap();
    win.set_property(
        target,
        BACKGROUND,
        Contribution::Set(gpui::Brush::Solid(Color::WHITE)),
    )
    .unwrap();
    win.reset_counters().unwrap();
    win.set(Panel::COLOR, rgb(0x305070)).unwrap();
    assert_eq!(
        win.property(target, BACKGROUND).unwrap().solid().unwrap(),
        Color::WHITE
    );
    win.set_property(target, BACKGROUND, Contribution::Inherit)
        .unwrap();
    assert_eq!(
        win.property(target, BACKGROUND).unwrap().solid().unwrap(),
        rgb(0x305070)
    );
    win.reset_counters().unwrap();
    win.set(Panel::COLOR, Color::rgba(10, 20, 30, 100)).unwrap();
    assert!(win.counters().paint_passes > 0);
    assert_eq!(
        pixels(&mut win),
        oracle(Color::rgba(10, 20, 30, 100), Affine::IDENTITY)
    );
}

#[test]
fn keep_rows_flag_preserves_virtual_membership_and_semantic_columns() {
    struct Rows(Signal<Color>);
    impl Rows {
        const COLOR: Source<Self, Color> =
            Source::new(FieldId::new(1), "color", |m| &m.0, |m| &mut m.0);
    }
    impl ItemSource for Rows {
        fn len(&self) -> usize {
            100
        }
        fn key(&self, index: usize) -> ItemKey {
            ItemKey::new(index as u64 + 1)
        }
        fn index_of(&self, key: ItemKey) -> Option<usize> {
            key.get()
                .checked_sub(1)
                .filter(|&i| i < 100)
                .map(|i| i as usize)
        }
        fn row(&self, index: usize) -> El<'_> {
            text(format!("row {index}")).h(20)
        }
    }
    impl View for Rows {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Self::COLOR)
        }
        fn view(&self) -> El<'_> {
            uniform_list(ListId::new(1), self, 20).size(80).bg(&self.0)
        }
    }
    let mut win = Win::recording(
        Rows(Signal::new(Color::BLACK)),
        WindowOptions {
            size: [80, 80],
            ..Default::default()
        },
    )
    .unwrap();
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
    let row = win.query().text("row 0").one().unwrap();
    let before = win.bounds(row).unwrap();
    win.reset_counters().unwrap();
    win.set(Rows::COLOR, Color::WHITE).unwrap();
    assert_eq!(win.counters().paint_passes, 0);
    // This logical inspector lookup resolves current virtual membership through
    // the complete candidate, which must reuse P rather than an empty Vec.
    win.property(row, gpui::property::WIDTH).unwrap();
    assert_eq!(win.bounds(row).unwrap(), before);
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
    assert_eq!(win.query().text("row 0").one().unwrap(), row);
}
