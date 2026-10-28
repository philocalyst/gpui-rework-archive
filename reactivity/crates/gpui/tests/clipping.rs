use gpui::{
    Affine, Color, El, Point, Target, View, Win, div,
    property::{CORNER_RADIUS, Contribution},
};

struct Panel {
    rounded_first: bool,
    radius: f32,
    broken: bool,
}
impl View for Panel {
    fn view(&self) -> El<'_> {
        let parent = div().size(32).name("clip-parent").child(
            div()
                .size(48)
                .bg(Color::BLACK)
                .name("child")
                .on_click(|_: &mut Self| {}),
        );
        let parent = if self.rounded_first {
            parent.rounded(self.radius).clip()
        } else {
            parent.clip().rounded(self.radius)
        };
        parent.transform(if self.broken {
            Affine::scale(0.0, 1.0)
        } else {
            Affine::IDENTITY
        })
    }
}
fn acknowledge(win: &mut Win<Panel>) {
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
}
fn contains(win: &Win<Panel>, target: Target, point: Point) -> bool {
    let mut result = None;
    win.visit(|part| {
        if part.target() == target {
            result = Some(part.contains_point(point));
        }
    })
    .unwrap();
    result.unwrap()
}

#[test]
fn clipped_gradient_text_candidates_keep_their_resource_and_hit_authority_after_failure() {
    use gpui::{Extend, Gradient, GradientGeometry, GradientStop, Interpolation};
    struct Painted {
        paint: Gradient,
        broken: bool,
    }
    impl View for Painted {
        fn view(&self) -> El<'_> {
            div()
                .size(32)
                .rounded(16.0)
                .clip()
                .transform(if self.broken {
                    Affine::scale(0.0, 1.0)
                } else {
                    Affine::IDENTITY
                })
                .child(
                    div()
                        .size(48)
                        .bg(&self.paint)
                        .name("painted-child")
                        .child(gpui::text("office café אבג").name("painted-text")),
                )
        }
    }
    fn paint(color: Color) -> Gradient {
        Gradient::new(
            GradientGeometry::Linear {
                start: Point::default(),
                end: Point { x: 1.0, y: 0.0 },
            },
            &[
                GradientStop::new(0.0, Color::BLACK),
                GradientStop::new(1.0, color),
            ],
            Extend::Pad,
            Interpolation::LinearSrgb,
        )
        .unwrap()
    }
    let mut win = Win::recording(
        Painted {
            paint: paint(Color::WHITE),
            broken: false,
        },
        gpui::WindowOptions {
            size: [64, 64],
            ..Default::default()
        },
    )
    .unwrap();
    let first = win.with_scene(|_, token| token).unwrap();
    win.presented(first).unwrap();
    let child = win.query().name("painted-child").one().unwrap();
    let second = paint(Color::rgb(255, 0, 0));
    let key = second.key();
    win.update(|model| model.paint = second).unwrap();
    let eligible = win
        .with_scene(|scene, token| {
            assert_eq!(
                scene
                    .gradients()
                    .map(|gradient| gradient.key())
                    .collect::<Vec<_>>(),
                [key]
            );
            assert!(scene.clip_nodes().count() > 0);
            assert!(
                scene
                    .draws()
                    .filter(|draw| draw.source.mask().is_some())
                    .count()
                    > 1
            );
            token
        })
        .unwrap();
    let mut pixels = Vec::new();
    win.with_pixels(|bytes, _, _| pixels.extend_from_slice(bytes))
        .unwrap();
    assert!(
        win.update(|model| {
            model.paint = paint(Color::rgb(0, 0, 255));
            model.broken = true;
        })
        .is_err()
    );
    win.with_scene(|scene, token| {
        assert_eq!(token, eligible);
        assert_eq!(scene.gradients().next().unwrap().key(), key);
    })
    .unwrap();
    win.with_pixels(|bytes, _, _| assert_eq!(bytes, pixels))
        .unwrap();
    win.presented(eligible).unwrap();
    assert_eq!(
        win.query().name("painted-child").one(),
        Err(gpui::Error::PresentationStale)
    );
    let mut visited = false;
    win.visit(|part| {
        if part.target() == child {
            visited = true;
            assert!(!part.contains_point(Point { x: 0.5, y: 0.5 }));
            assert!(part.contains_point(Point { x: 16.0, y: 16.0 }));
        }
    })
    .unwrap();
    assert!(visited);
}
#[test]
fn declarative_clip_preserves_builder_order_paint_and_acknowledged_hit_geometry() {
    for rounded_first in [false, true] {
        let mut win = Win::recording(
            Panel {
                rounded_first,
                radius: 16.0,
                broken: false,
            },
            gpui::WindowOptions {
                size: [64, 64],
                ..Default::default()
            },
        )
        .unwrap();
        acknowledge(&mut win);
        let child = win.query().name("child").one().unwrap();
        let parent = win.query().name("clip-parent").one().unwrap();
        assert!(!contains(&win, child, Point { x: 0.5, y: 0.5 }));
        assert!(contains(&win, child, Point { x: 16.0, y: 16.0 }));
        assert!(!contains(&win, child, Point { x: 40.0, y: 16.0 }));
        win.with_pixels(|pixels, width, _| {
            assert_eq!(&pixels[..4], &[255, 255, 255, 255]);
            assert_eq!(
                &pixels[(16 * width as usize + 16) * 4..][..4],
                &[0, 0, 0, 255]
            );
        })
        .unwrap();
        win.set_property(parent, CORNER_RADIUS, Contribution::Set(0.0))
            .unwrap();
        // C is newer; the public/native semantic predicate still reads P.
        assert!(!contains(&win, child, Point { x: 0.5, y: 0.5 }));
        acknowledge(&mut win);
        assert!(contains(&win, child, Point { x: 0.5, y: 0.5 }));
        assert!(!contains(&win, child, Point { x: 40.0, y: 16.0 }));
    }
}

#[test]
fn typed_clipping_overrides_observe_p_and_eligible_c_after_new_logical_failure() {
    use gpui::property::{CLIP, PROPERTIES, PropertyDestination, ValueKind};
    let mut win = Win::recording(
        Panel {
            rounded_first: true,
            radius: 16.0,
            broken: false,
        },
        gpui::WindowOptions {
            size: [64, 64],
            ..Default::default()
        },
    )
    .unwrap();
    acknowledge(&mut win);
    let parent = win.query().name("clip-parent").one().unwrap();
    let child = win.query().name("child").one().unwrap();
    assert_eq!(CLIP.info().destination, PropertyDestination::Geometry);
    assert_eq!(CLIP.info().kind, ValueKind::Flag);
    assert!(
        PROPERTIES
            .iter()
            .any(|info| std::ptr::eq(*info, CLIP.info()))
    );
    assert!(win.property(parent, CLIP).unwrap());
    win.set_property(parent, CLIP, Contribution::Set(false))
        .unwrap();
    let eligible = win.with_scene(|_, token| token).unwrap();
    assert!(!contains(&win, child, Point { x: 0.5, y: 0.5 }));
    assert!(
        win.update(|panel| {
            panel.radius = 9.0;
            panel.broken = true;
        })
        .is_err()
    );
    assert!(!contains(&win, child, Point { x: 0.5, y: 0.5 }));
    win.presented(eligible).unwrap();
    assert!(contains(&win, child, Point { x: 0.5, y: 0.5 }));
    assert!(contains(&win, child, Point { x: 40.0, y: 16.0 }));
    win.update(|panel| panel.broken = false).unwrap();
    win.set_property(parent, CLIP, Contribution::Inherit)
        .unwrap();
    assert!(contains(&win, child, Point { x: 0.5, y: 0.5 }));
    acknowledge(&mut win);
    assert!(!contains(&win, child, Point { x: 0.5, y: 0.5 }));
}

#[test]
fn mapped_flag_coalesces_without_describing_and_p_changes_only_on_ack() {
    use gpui::{FieldId, Remote, Signal, SignalMap, Source, Sources, property::CLIP};
    struct Mapped {
        flag: Signal<bool>,
    }
    impl Mapped {
        const FLAG: Source<Self, bool> =
            Source::new(FieldId::new(1), "flag", |m| &m.flag, |m| &mut m.flag);
    }
    impl View for Mapped {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Self::FLAG)
        }
        fn view(&self) -> El<'_> {
            div()
                .size(32)
                .rounded(16.0)
                .clipped(self.flag.map(|flag| *flag))
                .name("parent")
                .child(
                    div()
                        .size(48)
                        .bg(Color::BLACK)
                        .name("child")
                        .on_click(|_: &mut Self| {}),
                )
        }
    }
    let (remote, inbox) = Remote::bounded(4);
    let mut win = Win::recording(
        Mapped {
            flag: Signal::new(true),
        },
        gpui::WindowOptions {
            size: [64, 64],
            ..Default::default()
        },
    )
    .unwrap()
    .with_inbox_for(inbox, Mapped::FLAG, |value, next| *value = next)
    .unwrap();
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    let parent = win.query().name("parent").one().unwrap();
    let child = win.query().name("child").one().unwrap();
    win.reset_counters().unwrap();
    remote.try_send(false).unwrap();
    remote.try_send(true).unwrap();
    remote.try_send(false).unwrap();
    win.deliver_ready(3).unwrap();
    assert!(!win.property(parent, CLIP).unwrap());
    assert_eq!(win.counters().descriptions, 0);
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(win.counters().layout_runs, 0);
    let mut hit = None;
    win.visit(|part| {
        if part.target() == child {
            hit = Some(part.contains_point(Point { x: 0.5, y: 0.5 }));
        }
    })
    .unwrap();
    assert_eq!(hit, Some(false));
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    win.visit(|part| {
        if part.target() == child {
            hit = Some(part.contains_point(Point { x: 0.5, y: 0.5 }));
        }
    })
    .unwrap();
    assert_eq!(hit, Some(true));
}

#[test]
fn nested_clip_depth_failure_keeps_prior_acknowledged_and_eligible_scenes() {
    struct Deep(usize);
    impl View for Deep {
        fn view(&self) -> El<'_> {
            let mut child = div().size(16).bg(Color::BLACK).name("leaf");
            for _ in 0..self.0 {
                child = div().size(16).rounded(4.0).clip().child(child);
            }
            child
        }
    }
    let mut win = Win::recording(
        Deep(1),
        gpui::WindowOptions {
            size: [32, 32],
            ..Default::default()
        },
    )
    .unwrap();
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    let before = win.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
    win.update(|page| page.0 = 2).unwrap();
    let eligible = win.with_scene(|_, token| token).unwrap();
    assert!(win.update(|page| page.0 = 65).is_err());
    assert_eq!(
        win.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap(),
        before
    );
    win.presented(eligible).unwrap();
    let mut leaf = false;
    win.visit(|part| {
        if part.name() == Some("leaf") {
            assert!(!part.contains_point(Point { x: 0.5, y: 0.5 }));
            assert!(part.contains_point(Point { x: 8., y: 8. }));
            leaf = true;
        }
    })
    .unwrap();
    assert!(leaf);
}

#[test]
fn scrolling_beneath_rounded_clip_admits_new_glyphs_and_updates_hits_on_ack() {
    struct Scrolled;
    impl View for Scrolled {
        fn view(&self) -> El<'_> {
            div().size(32).rounded(16.).clip().child(
                gpui::column(["i", "ii", "WWWWW", "WWWWWW"].into_iter().enumerate().map(
                    |(index, label)| gpui::text(label).w(32).h(16).name(format!("row{index}")),
                ))
                .size(32)
                .scroll(gpui::Axis::Y)
                .name("viewport"),
            )
        }
    }
    let mut win = Win::recording(
        Scrolled,
        gpui::WindowOptions {
            size: [48, 48],
            ..Default::default()
        },
    )
    .unwrap();
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    let viewport = win.query().name("viewport").one().unwrap();
    let row = win.query().name("row2").one().unwrap();
    let count = |win: &mut Win<Scrolled>| {
        win.with_scene(|scene, _| {
            scene
                .draws()
                .filter(|draw| draw.source.mask().is_some())
                .count()
        })
        .unwrap()
    };
    let before = count(&mut win);
    win.reset_counters().unwrap();
    win.scroll_to(viewport, gpui::ScrollOffset { x: 0., y: 32. })
        .unwrap();
    assert!(
        count(&mut win) > before,
        "newly visible rows must admit their glyph masks"
    );
    let mut old_hit = false;
    win.visit(|part| {
        if part.target() == row {
            old_hit = part.contains_point(Point { x: 16., y: 8. });
        }
    })
    .unwrap();
    assert!(!old_hit);
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    let mut hit = false;
    win.visit(|part| {
        if part.target() == row {
            hit = part.contains_point(Point { x: 16., y: 8. });
        }
    })
    .unwrap();
    assert!(hit);
    win.with_pixels(|pixels, _, _| assert_eq!(&pixels[..4], &[255; 4]))
        .unwrap();
    assert_eq!(win.counters().descriptions, 0);
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(win.counters().layout_runs, 0);
}
