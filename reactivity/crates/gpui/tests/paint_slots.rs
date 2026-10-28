//! Shared authored colors are owner relationships, including masked lower bases.
use gpui::{
    prelude::*,
    property::{BACKGROUND, Contribution},
};

struct Colors {
    left: Signal<Color>,
    right: Signal<Color>,
}
impl Colors {
    const LEFT: Source<Self, Color> =
        Source::new(FieldId::new(1), "left", |m| &m.left, |m| &mut m.left);
    const RIGHT: Source<Self, Color> =
        Source::new(FieldId::new(2), "right", |m| &m.right, |m| &mut m.right);
    fn new() -> Self {
        Self {
            left: Signal::new(Color::BLACK),
            right: Signal::new(Color::BLACK),
        }
    }
}
impl View for Colors {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::LEFT).direct(Self::RIGHT)
    }
    fn view(&self) -> El<'_> {
        row((
            div().name("left").size(20).bg(&self.left),
            div().name("right").size(20).bg(&self.right),
        ))
    }
}

#[test]
fn equal_source_values_do_not_merge_relationships_or_masked_lower_bases() {
    let mut win = Win::with_size(Colors::new(), 48, 24).unwrap();
    let left = win.query().name("left").one().unwrap();
    let right = win.query().name("right").one().unwrap();
    win.set_property(
        left,
        BACKGROUND,
        Contribution::Set(gpui::Brush::Solid(Color::BLACK)),
    )
    .unwrap();
    win.reset_counters().unwrap();
    win.set(Colors::LEFT, Color::WHITE).unwrap();
    assert!(
        win.property(left, BACKGROUND)
            .unwrap()
            .solid()
            .unwrap()
            .same_authoring(Color::BLACK)
    );
    assert!(
        win.property(right, BACKGROUND)
            .unwrap()
            .solid()
            .unwrap()
            .same_authoring(Color::BLACK)
    );
    assert_eq!(win.counters().source_reads, 1);
    assert_eq!(win.counters().destination_compares, 0);
    assert_eq!(win.counters().owner_reruns, 0);
    win.set_property(left, BACKGROUND, Contribution::Inherit)
        .unwrap();
    assert!(
        win.property(left, BACKGROUND)
            .unwrap()
            .solid()
            .unwrap()
            .same_authoring(Color::WHITE)
    );
    assert!(
        win.property(right, BACKGROUND)
            .unwrap()
            .solid()
            .unwrap()
            .same_authoring(Color::BLACK)
    );
    win.set(Colors::RIGHT, Color::rgb(10, 20, 30)).unwrap();
    assert!(
        win.property(left, BACKGROUND)
            .unwrap()
            .solid()
            .unwrap()
            .same_authoring(Color::WHITE)
    );
    assert!(
        win.property(right, BACKGROUND)
            .unwrap()
            .solid()
            .unwrap()
            .same_authoring(Color::rgb(10, 20, 30))
    );
}

struct Many {
    color: Signal<Color>,
}
impl Many {
    const COLOR: Source<Self, Color> =
        Source::new(FieldId::new(1), "color", |m| &m.color, |m| &mut m.color);
}
impl View for Many {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::COLOR)
    }
    fn view(&self) -> El<'_> {
        column((0..1024).map(|_| div().name("row").size(2).fg(&self.color).bg(&self.color)))
    }
}
#[test]
fn shared_fg_bg_source_updates_once_without_writing_each_style() {
    let mut win = Win::with_size(
        Many {
            color: Signal::new(Color::BLACK),
        },
        32,
        32,
    )
    .unwrap();
    win.reset_counters().unwrap();
    win.set(Many::COLOR, Color::WHITE).unwrap();
    assert_eq!(win.counters().source_reads, 1);
    assert_eq!(win.counters().destination_compares, 0);
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(win.counters().paint_passes, 0);
    assert_eq!(win.counters().layout_runs, 0);
    let mut seen = 0;
    win.visit(|part| {
        if part.name() == Some("row") {
            seen += 1;
        }
    })
    .unwrap();
    assert_eq!(seen, 1024);
}

#[test]
fn equal_inspector_set_rebinds_only_masked_member_of_shared_color_source() {
    struct Peers(Signal<Color>);
    impl Peers {
        const COLOR: Source<Self, Color> =
            Source::new(FieldId::new(1), "color", |m| &m.0, |m| &mut m.0);
    }
    impl View for Peers {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Self::COLOR)
        }
        fn view(&self) -> El<'_> {
            row((
                div().name("masked").size(16).bg(&self.0),
                div().name("peer").size(16).bg(&self.0),
            ))
        }
    }
    let mut win = Win::with_size(Peers(Signal::new(Color::BLACK)), 32, 16).unwrap();
    let masked = win.query().name("masked").one().unwrap();
    win.set_property(
        masked,
        BACKGROUND,
        Contribution::Set(gpui::Brush::Solid(Color::BLACK)),
    )
    .unwrap();
    win.reset_counters().unwrap();
    win.set(Peers::COLOR, Color::WHITE).unwrap();
    assert_eq!(win.counters().paint_passes, 0);
    win.with_pixels(|pixels, _, _| {
        assert_eq!(&pixels[..4], &[0, 0, 0, 255]);
        assert_eq!(&pixels[16 * 4..16 * 4 + 4], &[255; 4]);
    })
    .unwrap();
    win.set_property(masked, BACKGROUND, Contribution::Inherit)
        .unwrap();
    win.set(Peers::COLOR, Color::rgb(255, 0, 0)).unwrap();
    win.with_pixels(|pixels, _, _| {
        assert_eq!(&pixels[..4], &[255, 0, 0, 255]);
        assert_eq!(&pixels[16 * 4..16 * 4 + 4], &[255, 0, 0, 255]);
    })
    .unwrap();
}
