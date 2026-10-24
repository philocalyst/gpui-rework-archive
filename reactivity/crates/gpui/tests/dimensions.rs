//! Authored dimensions share the ordinary source, property and layout boundaries.
use gpui::{
    Error, SetError, Style, WindowOptions,
    prelude::*,
    property::{Contribution, HEIGHT, PropertyErrorKind, PropertyId, PropertyValue, WIDTH},
};

struct Panel {
    size: Signal<Length>,
}
impl Panel {
    const SIZE: Source<Self, Length> =
        Source::new(FieldId::new(1), "size", |m| &m.size, |m| &mut m.size);
}
impl View for Panel {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::SIZE)
    }
    fn view(&self) -> El<'_> {
        div()
            .name("root")
            .size(Length::Percent(100.0))
            .p(10)
            .bg(Color::BLACK)
            .child(
                div().name("panel").size(&self.size).bg(Color::WHITE).child(
                    div()
                        .name("nested")
                        .w(Length::Percent(50.0))
                        .h(Length::Percent(100.0)),
                ),
            )
    }
}
fn panel() -> Panel {
    Panel {
        size: Signal::new(Length::Percent(50.0)),
    }
}
fn ack<M: View + 'static>(win: &mut Win<M>) {
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
}
// Canonical geometry is exact. Win::bounds is deliberately outward-rounded
// for conservative clipping and is not the dimension's authored-size oracle.
fn bounds<M: View + 'static>(win: &Win<M>, name: &str) -> Rect {
    let mut result = None;
    win.visit(|part| {
        if part.name() == Some(name) {
            let local = part.local_bounds();
            let map = part.transform().unwrap();
            result = Some(Rect {
                x: map.tx,
                y: map.ty,
                ..local
            });
        }
    })
    .unwrap();
    result.unwrap()
}

#[test]
fn relative_dimensions_resolve_against_parent_content_and_resize_after_ack() {
    let mut win = Win::recording(
        panel(),
        WindowOptions {
            size: [400, 200],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    assert_eq!(
        bounds(&win, "root"),
        Rect {
            x: 0.0,
            y: 0.0,
            width: 400.0,
            height: 200.0
        }
    );
    assert_eq!(
        bounds(&win, "panel"),
        Rect {
            x: 10.0,
            y: 10.0,
            width: 190.0,
            height: 90.0
        }
    );
    assert_eq!(bounds(&win, "nested").width, 95.0);
    assert_eq!(bounds(&win, "nested").height, 90.0);
    win.resize([600, 300]).unwrap();
    assert_eq!(
        bounds(&win, "panel").width,
        190.0,
        "queries retain acknowledged geometry"
    );
    ack(&mut win);
    assert_eq!(bounds(&win, "root").width, 600.0);
    assert_eq!(bounds(&win, "panel").width, 290.0);
    assert_eq!(bounds(&win, "panel").height, 140.0);
    assert_eq!(bounds(&win, "nested").width, 145.0);
    win.with_pixels(|pixels, width, height| {
        assert_eq!((width, height), (600, 300));
        assert_eq!(
            &pixels[pixels.len() - 4..],
            &[0, 0, 0, 255],
            "root fills the last pixel"
        );
    })
    .unwrap();
    // Same logical containing block, different device density. Percentages
    // resolve before the ordinary acknowledged local-to-physical transform.
    win.resize_scaled([900, 450], 1.5).unwrap();
    ack(&mut win);
    assert_eq!(bounds(&win, "root").width, 600.0);
    assert_eq!(bounds(&win, "panel").width, 290.0);
    assert_eq!(bounds(&win, "panel").x, 15.0);
    win.visit(|part| {
        if part.name() == Some("panel") {
            assert_eq!(part.transform().unwrap().a, 1.5);
        }
    })
    .unwrap();
    win.with_pixels(|pixels, width, height| {
        assert_eq!((width, height), (900, 450));
        assert_eq!(&pixels[pixels.len() - 4..], &[0, 0, 0, 255]);
    })
    .unwrap();
}

#[test]
fn dimension_source_fanout_retains_units_and_latest_lower_value_under_explicit_auto() {
    let mut win = Win::with_size(panel(), 400, 200).unwrap();
    let target = win.query().name("panel").one().unwrap();
    win.set_property(target, WIDTH, Contribution::Set(WIDTH.default_value()))
        .unwrap();
    assert_eq!(
        win.contribution(target, WIDTH).unwrap(),
        Contribution::Set(Length::Auto)
    );
    win.reset_counters().unwrap();
    win.set(Panel::SIZE, Length::Percent(75.0)).unwrap();
    assert_eq!(win.property(target, WIDTH).unwrap(), Length::Auto);
    assert_eq!(win.property(target, HEIGHT).unwrap(), Length::Percent(75.0));
    assert_eq!(win.counters().source_reads, 1);
    assert_eq!(win.counters().owner_reruns, 0);
    win.set_property(target, WIDTH, Contribution::Inherit)
        .unwrap();
    assert_eq!(win.property(target, WIDTH).unwrap(), Length::Percent(75.0));
    assert_eq!(bounds(&win, "panel").width, 285.0);
    win.set(Panel::SIZE, Length::Points(40.0)).unwrap();
    assert_eq!(bounds(&win, "panel").width, 40.0);
    assert_eq!(bounds(&win, "panel").height, 40.0);
    for value in [Length::Percent(-0.0), Length::Percent(0.0)] {
        win.set(Panel::SIZE, value).unwrap();
        assert!(WIDTH.same_authoring(&win.property(target, WIDTH).unwrap(), &value));
    }
}

#[test]
fn invalid_relative_publication_keeps_prepared_and_acknowledged_cohorts_distinct() {
    let mut win = Win::recording(
        panel(),
        WindowOptions {
            size: [400, 200],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    let initial = win.snapshot().unwrap();
    win.set(Panel::SIZE, Length::Percent(75.0)).unwrap();
    let pending = win.with_scene(|_, token| token).unwrap();
    let digest = win.scene_digest().unwrap();
    assert!(matches!(win.set(Panel::SIZE, Length::Percent(f32::NAN)),
        Err(SetError::Committed { error: Error::Property(error), .. })
            if error.reason == PropertyErrorKind::NonFinite));
    assert_eq!(win.with_scene(|_, token| token).unwrap(), pending);
    assert_eq!(win.scene_digest().unwrap(), digest);
    assert_eq!(win.snapshot().unwrap().nodes, initial.nodes);
    win.presented(pending).unwrap();
    assert_eq!(bounds(&win, "panel").width, 285.0);
    assert!(
        win.query().name("panel").one().is_err(),
        "invalid logical publication cannot mint an interaction target"
    );
    win.set(Panel::SIZE, Length::Percent(25.0)).unwrap();
    ack(&mut win);
    assert_eq!(bounds(&win, "panel").width, 95.0);
}

#[test]
fn typed_and_cold_edits_reject_invalid_dimensions_before_mutating_contributions() {
    let mut win = Win::with_size(panel(), 400, 200).unwrap();
    let target = win.query().name("panel").one().unwrap();
    for invalid in [
        Length::Percent(-1.0),
        Length::Percent(f32::INFINITY),
        Length::Percent(f32::NAN),
        Length::Points(-1.0),
    ] {
        assert!(
            win.set_property(target, WIDTH, Contribution::Set(invalid))
                .is_err()
        );
        assert!(
            win.set_property_value(
                target,
                PropertyId::Width,
                Contribution::Set(PropertyValue::Dimension(invalid))
            )
            .is_err()
        );
        assert_eq!(win.property(target, WIDTH).unwrap(), Length::Percent(50.0));
        assert_eq!(
            win.contribution(target, WIDTH).unwrap(),
            Contribution::Inherit
        );
    }
    win.set_property(target, WIDTH, Contribution::Set(Length::Percent(125.0)))
        .unwrap();
    assert_eq!(win.property(target, WIDTH).unwrap(), Length::Percent(125.0));
    assert_eq!(bounds(&win, "panel").width, 475.0);
    assert!(win.bounds(target).unwrap().width < 475.0);
}

#[test]
fn mapped_dimensions_preserve_static_units_without_describing_the_owner() {
    struct Model(Signal<bool>);
    impl Model {
        const FLAG: Source<Self, bool> =
            Source::new(FieldId::new(1), "flag", |m| &m.0, |m| &mut m.0);
    }
    impl View for Model {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Self::FLAG)
        }
        fn view(&self) -> El<'_> {
            div().size(Length::Percent(100.0)).child(
                div()
                    .name("mapped")
                    .w(self.0.map(|flag| {
                        if *flag {
                            Length::Percent(25.0)
                        } else {
                            Length::Points(80.0)
                        }
                    }))
                    .h(20),
            )
        }
    }
    let mut win = Win::with_size(Model(Signal::new(false)), 400, 200).unwrap();
    assert_eq!(bounds(&win, "mapped").width, 80.0);
    win.reset_counters().unwrap();
    win.set(Model::FLAG, true).unwrap();
    assert_eq!(bounds(&win, "mapped").width, 100.0);
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(win.counters().source_reads, 1);
}

#[test]
fn dimensions_keep_authored_tags_bits_and_existing_headers_without_literal_allocation() {
    assert_eq!(size_of::<Length>(), 8);
    assert_eq!(size_of::<Option<Length>>(), 8);
    assert_eq!(size_of::<Style>(), 88);
    assert_eq!(size_of::<El<'static>>(), 176);
    let count = allocation_counter::measure(|| {
        let _element = std::hint::black_box(div().size(Length::Percent(100.0)));
    });
    assert_eq!(count.count_total, 0);
    for value in [
        Length::Auto,
        Length::Points(-0.0),
        Length::Points(f32::MIN_POSITIVE),
        Length::Percent(-0.0),
        Length::Percent(100.0),
        Length::Percent(150.0),
    ] {
        let parsed: Length = value.to_string().parse().unwrap();
        assert!(WIDTH.same_authoring(&value, &parsed));
    }
    assert!(!WIDTH.same_authoring(&Length::Auto, &Length::Points(0.0)));
    assert!(!WIDTH.same_authoring(&Length::Points(0.0), &Length::Percent(0.0)));
    assert!(!WIDTH.same_authoring(&Length::Percent(0.0), &Length::Percent(-0.0)));
    assert_eq!(
        Length::Percent(0.0),
        Length::Percent(-0.0),
        "ordinary numerical equality remains separate"
    );
}

#[test]
fn ordinary_inspector_increment_preserves_percentage_units_and_auto_presence() {
    let mut win = Win::with_inspector(
        panel(),
        WindowOptions {
            size: [800, 600],
            ..Default::default()
        },
    )
    .unwrap();
    let target = win.query().name("panel").one().unwrap();
    win.inspector_select(target).unwrap();
    for name in ["Increase", "Auto", "Inherit"] {
        let inspector = win
            .role(gpui::Role::ScrollView)
            .name("GPUI Inspector")
            .one()
            .unwrap();
        let control = win.query().name(name).within(inspector).one().unwrap();
        win.scroll_into_view(control).unwrap();
        ack(&mut win);
        win.click(control).unwrap();
        match name {
            "Increase" => assert_eq!(win.property(target, WIDTH).unwrap(), Length::Percent(51.0)),
            "Auto" => assert_eq!(
                win.contribution(target, WIDTH).unwrap(),
                Contribution::Set(Length::Auto)
            ),
            _ => assert_eq!(win.property(target, WIDTH).unwrap(), Length::Percent(50.0)),
        }
    }
}
