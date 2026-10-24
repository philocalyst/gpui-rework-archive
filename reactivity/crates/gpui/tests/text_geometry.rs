//! Ordinary public geometry: the same P authority used by native projection.
use gpui::{
    property::{Contribution, WIDTH},
    *,
};

struct Page {
    value: String,
    width: f32,
    broken: bool,
}
impl View for Page {
    fn view(&self) -> El<'_> {
        row((
            text(&self.value).w(self.width).p(3).name("paragraph"),
            div().size(4).bg(Color::BLACK).transform(if self.broken {
                Affine::scale(0., 1.)
            } else {
                Affine::IDENTITY
            }),
        ))
    }
}
type Unit = (usize, usize, Rect, usize);
type Paragraph = (String, Rect, Vec<Unit>);
fn capture(win: &Win<Page>) -> Vec<Paragraph> {
    let mut values = Vec::new();
    win.visit(|part| {
        if let Some(text) = part.text() {
            let geometry = part.text_geometry().expect("all P text owns geometry");
            let units = geometry
                .layout()
                .graphemes()
                .map(|unit| {
                    let range = unit.text_range();
                    (
                        range.start.byte(),
                        range.end.byte(),
                        geometry.bounds(unit.bounds()).unwrap(),
                        unit.line(),
                    )
                })
                .collect();
            values.push((
                text.to_owned(),
                geometry
                    .caret_bounds(TextPosition {
                        offset: TextOffset::new(0).unwrap(),
                        affinity: CaretAffinity::Downstream,
                    })
                    .unwrap(),
                units,
            ));
        } else {
            assert!(part.text_geometry().is_none());
        }
    })
    .unwrap();
    values
}
#[test]
fn old_p_and_eligible_c_keep_exact_geometry_after_new_l_reshapes_then_fails() {
    let mut win = Win::recording(
        Page {
            value: "office café אבג\r\nlast".into(),
            width: 90.,
            broken: false,
        },
        WindowOptions::default(),
    )
    .unwrap();
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    let p0 = capture(&win);
    let target = win.query().name("paragraph").one().unwrap();
    win.set_property(target, WIDTH, Contribution::Set(gpui::Length::Points(55.)))
        .unwrap();
    let c1 = win.with_scene(|_, token| token).unwrap();
    assert_eq!(capture(&win), p0);
    assert!(
        win.update(|page| {
            page.value = "different العربية content spanning more lines".into();
            page.width = 20.;
            page.broken = true;
        })
        .is_err()
    );
    assert_eq!(capture(&win), p0);
    win.presented(c1).unwrap();
    let p1 = capture(&win);
    assert_eq!(p1[0].0, p0[0].0);
    assert_ne!(p1[0].2, p0[0].2);
    win.update(|page| page.broken = false).unwrap();
    assert_eq!(capture(&win), p1);
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    assert!(capture(&win)[0].0.starts_with("different"));
}
#[test]
fn wrapped_directional_runs_cover_source_and_containing_hit_is_not_nearest_caret() {
    for value in [
        "",
        "a\r\n\r\n",
        "office café אבג العربية",
        "a\u{301} a\u{200d}b",
        "a\u{2028}b",
    ] {
        let win = Win::demo(Page {
            value: value.into(),
            width: 70.,
            broken: false,
        });
        win.visit(|part| {
            if part.name() == Some("paragraph") {
                let geometry = part.text_geometry().unwrap();
                let runs = geometry.layout().runs().collect::<Vec<_>>();
                assert!(!runs.is_empty());
                assert_eq!(runs.first().unwrap().text_range().start.byte(), 0);
                assert_eq!(runs.last().unwrap().text_range().end.byte(), value.len());
                for pair in runs.windows(2) {
                    assert_eq!(pair[0].text_range().end, pair[1].text_range().start);
                }
                for unit in geometry
                    .layout()
                    .graphemes()
                    .filter(|unit| !unit.is_hard_break() && unit.bounds().width > 0.)
                {
                    let rect = unit.bounds();
                    let local = Point {
                        x: rect.x + rect.width * 0.75,
                        y: rect.y + rect.height * 0.5,
                    };
                    let point = geometry.transform().unwrap().to_window(local).unwrap();
                    let containing = geometry.grapheme_at(point).unwrap();
                    assert_eq!(containing.text_range(), unit.text_range());
                    assert!(geometry.position_at(point).is_some());
                }
            }
        })
        .unwrap();
    }
    let win = Win::demo(Page {
        value: "ab".into(),
        width: 80.,
        broken: false,
    });
    win.visit(|part| {
        if part.name() == Some("paragraph") {
            let geometry = part.text_geometry().unwrap();
            let unit = geometry.layout().graphemes().next().unwrap();
            let bounds = unit.bounds();
            let point = geometry
                .transform()
                .unwrap()
                .to_window(Point {
                    x: bounds.x + bounds.width * 0.75,
                    y: bounds.y + bounds.height * 0.5,
                })
                .unwrap();
            assert_eq!(
                geometry
                    .grapheme_at(point)
                    .unwrap()
                    .text_range()
                    .start
                    .byte(),
                0
            );
            assert_eq!(geometry.position_at(point).unwrap().offset.byte(), 1);
            assert_eq!(geometry.position_at(Point { x: f32::NAN, y: 0. }), None);
        }
    })
    .unwrap();
}

#[test]
fn physical_geometry_keeps_padding_fractional_dpi_reflection_shear_and_exact_target_hits() {
    struct Surface;
    impl View for Surface {
        fn view(&self) -> El<'_> {
            column((text("office café אבג العربية\r\nnext line")
                .w(90)
                .p(4)
                .rounded(10.)
                .transform(Affine {
                    a: -1.,
                    b: 0.1,
                    c: 0.15,
                    d: 1.,
                    tx: 108.,
                    ty: 3.,
                })
                .name("shaped"),))
            .w(100)
            .h(36)
            .scroll(Axis::Y)
        }
    }
    let mut win = Win::recording_scaled(
        Surface,
        WindowOptions {
            size: [240, 160],
            ..Default::default()
        },
        1.25,
    )
    .unwrap();
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    let mut admitted = 0;
    let mut clipped = 0;
    win.visit(|part| {
        if part.name() == Some("shaped") {
            let geometry = part.text_geometry().unwrap();
            let origin = geometry.origin();
            assert_eq!(origin, Point { x: 4., y: 4. });
            let affine = part.transform().unwrap();
            let coefficients = geometry.transform().unwrap().coefficients();
            assert_eq!(
                coefficients,
                [
                    f64::from(affine.a),
                    f64::from(affine.b),
                    f64::from(affine.c),
                    f64::from(affine.d),
                    f64::from(affine.tx) + f64::from(affine.a) * 4. + f64::from(affine.c) * 4.,
                    f64::from(affine.ty) + f64::from(affine.b) * 4. + f64::from(affine.d) * 4.
                ]
            );
            for unit in geometry
                .layout()
                .graphemes()
                .filter(|unit| !unit.is_hard_break() && unit.bounds().width > 0.)
            {
                let bounds = unit.bounds();
                let point = geometry
                    .transform()
                    .unwrap()
                    .to_window(Point {
                        x: bounds.x + bounds.width * 0.5,
                        y: bounds.y + bounds.height * 0.5,
                    })
                    .unwrap();
                if part.contains_point(point) {
                    admitted += 1;
                    assert!(geometry.hit_position(point).is_some());
                    assert_eq!(
                        geometry.grapheme_at(point).unwrap().text_range(),
                        unit.text_range()
                    );
                } else {
                    clipped += 1;
                    assert_eq!(geometry.hit_position(point), None);
                    assert!(geometry.grapheme_at(point).is_none());
                    assert!(
                        geometry.position_at(point).is_some(),
                        "unclipped nearest caret is the drag policy"
                    );
                }
            }
            assert_eq!(geometry.hit_position(Point { x: 200., y: 100. }), None);
        }
    })
    .unwrap();
    assert!(admitted > 0 && clipped > 0);
}

#[test]
fn zero_advance_unit_retains_visible_semantic_extent_without_a_damage_rectangle() {
    let win = Win::demo(Page {
        value: "\u{200d}".into(),
        width: 70.,
        broken: false,
    });
    win.visit(|part| {
        if part.name() == Some("paragraph") {
            let geometry = part.text_geometry().unwrap();
            let unit = geometry.layout().graphemes().next().unwrap();
            assert_eq!(unit.bounds().width, 0.);
            let full = geometry.bounds(unit.bounds()).unwrap();
            let visible = geometry.visible_bounds(unit.bounds()).unwrap();
            assert_eq!(full.width, 0.);
            assert_eq!(visible.width, 0.);
            assert!(visible.height > 0.);
            assert!(
                geometry
                    .visible_bounds(Rect::new(-100., -100., 0., 10.))
                    .is_none()
            );
        }
    })
    .unwrap();
}
