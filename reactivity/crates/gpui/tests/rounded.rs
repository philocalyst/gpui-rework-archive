use gpui::property::{CORNER_RADIUS, Contribution, PropertyDestination};
use gpui::{
    Affine, Axis, Color, El, Error, Point, Role, ScrollDelta, Target, View, Win, WindowOptions,
    div, image,
};

#[test]
fn rounded_scroll_panes_preserve_shape_metadata_and_axes_in_both_builder_orders() {
    struct Pane {
        radius_first: bool,
    }
    impl View for Pane {
        fn view(&self) -> El<'_> {
            let pane = div()
                .child(div().w(64).h(128))
                .size(64)
                .bg(Color::BLACK)
                .on_click(|_: &mut Self| {});
            if self.radius_first {
                pane.name("pane").rounded(32.0).scroll(Axis::Y)
            } else {
                pane.scroll(Axis::Y).rounded(32.0).name("pane")
            }
        }
    }
    for radius_first in [false, true] {
        let mut win = Win::with_size(Pane { radius_first }, 64, 64).unwrap();
        let target = win.role(Role::ScrollView).name("pane").one().unwrap();
        assert_eq!(win.hit_target(Point { x: 0.5, y: 0.5 }).unwrap(), None);
        assert_eq!(
            win.hit_target(Point { x: 32.0, y: 32.0 }).unwrap(),
            Some(target)
        );
        win.scroll_by(target, ScrollDelta { x: 0.0, y: 16.0 })
            .unwrap();
        assert_eq!(win.viewport(target).unwrap().offset.y, 16.0);
        let document: serde_json::Value =
            serde_json::from_str(&win.semantics().unwrap().to_json().unwrap()).unwrap();
        assert_eq!(document["nodes"][0]["corner_radius"], 32.0);
        assert_eq!(document["nodes"][0]["viewport"]["offset"]["y"], 16.0);
        win.with_pixels(|pixels, width, _| {
            assert_eq!(&pixels[..4], &[255, 255, 255, 255]);
            assert_eq!(
                &pixels[(32 * width as usize + 32) * 4..][..4],
                &[0, 0, 0, 255]
            );
        })
        .unwrap();
        win.set_property(target, CORNER_RADIUS, Contribution::Set(0.0))
            .unwrap();
        assert_eq!(
            win.hit_target(Point { x: 0.5, y: 0.5 }).unwrap(),
            Some(target)
        );
        win.set_property(target, CORNER_RADIUS, Contribution::Inherit)
            .unwrap();
        assert_eq!(win.hit_target(Point { x: 0.5, y: 0.5 }).unwrap(), None);
    }
}

#[test]
fn alternating_scroll_and_radius_builders_reuse_one_cold_extension_allocation() {
    for named in [false, true] {
        let mut element = None;
        let measured = allocation_counter::measure(|| {
            let mut pane = div();
            if named {
                pane = pane.name("pane");
            }
            for _ in 0..1_000 {
                pane = pane.rounded(6.0).scroll(Axis::Y);
            }
            element = Some(pane);
        });
        assert_eq!(measured.count_total, if named { 2 } else { 1 });
        assert_eq!(measured.bytes_total, if named { 104 } else { 56 });
        drop(element);
    }
}

struct Card {
    radius: f32,
    broken: bool,
    clicks: u32,
}
impl Card {
    fn click(&mut self) {
        self.clicks += 1;
    }
}
impl View for Card {
    fn view(&self) -> El<'_> {
        div()
            .size(64)
            .bg(Color::BLACK)
            .rounded(self.radius)
            .transform(if self.broken {
                Affine::scale(0.0, 1.0)
            } else {
                Affine::IDENTITY
            })
            .on_click(Self::click)
    }
}
fn card() -> Card {
    Card {
        radius: 32.0,
        broken: false,
        clicks: 0,
    }
}
fn root(win: &Win<Card>) -> Target {
    win.snapshot().unwrap().nodes[0].target.unwrap()
}
fn radius(win: &Win<Card>) -> f32 {
    let mut value = None;
    win.visit(|part| value = Some(part.corner_radius()))
        .unwrap();
    value.unwrap()
}
fn ack(win: &mut Win<Card>) {
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
}

#[test]
fn ordinary_builder_paint_hit_and_typed_presence_share_one_geometry() {
    let mut win = Win::demo(card());
    let target = root(&win);
    assert_eq!(
        CORNER_RADIUS.info().destination,
        PropertyDestination::Geometry
    );
    assert_eq!(CORNER_RADIUS.info().id as u16, 13);
    assert_eq!(win.property(target, CORNER_RADIUS).unwrap(), 32.0);
    assert_eq!(win.hit_target(Point { x: 0.5, y: 0.5 }).unwrap(), None);
    assert_eq!(
        win.hit_target(Point { x: 32.0, y: 0.5 }).unwrap(),
        Some(target)
    );
    win.with_pixels(|pixels, width, _| {
        assert_eq!(&pixels[..4], &[255, 255, 255, 255]);
        assert_eq!(
            &pixels[(32 * width as usize + 32) * 4..][..4],
            &[0, 0, 0, 255]
        );
    })
    .unwrap();
    let before = win.counters();
    win.set_property(target, CORNER_RADIUS, Contribution::Set(0.0))
        .unwrap();
    assert_eq!(win.counters().layout_runs, before.layout_runs);
    assert_eq!(
        win.hit_target(Point { x: 0.5, y: 0.5 }).unwrap(),
        Some(target)
    );
    win.update(|card| card.radius = 16.0).unwrap();
    assert_eq!(win.property(target, CORNER_RADIUS).unwrap(), 0.0);
    assert_eq!(
        win.contribution(target, CORNER_RADIUS).unwrap(),
        Contribution::Set(0.0)
    );
    win.set_property(target, CORNER_RADIUS, Contribution::Inherit)
        .unwrap();
    assert_eq!(win.property(target, CORNER_RADIUS).unwrap(), 16.0);
    let epoch = win.snapshot().unwrap().source_epoch;
    assert!(matches!(
        win.set_property(target, CORNER_RADIUS, Contribution::Set(f32::NAN)),
        Err(Error::Property(_))
    ));
    assert_eq!(win.snapshot().unwrap().source_epoch, epoch);
    win.activate(target).unwrap();
    assert_eq!(win.root().unwrap().clicks, 1);
}

#[test]
fn old_sheet_and_older_complete_candidate_keep_their_own_radius_after_failure() {
    let mut win = Win::recording(
        card(),
        WindowOptions {
            size: [64, 64],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    let target = root(&win);
    win.set_property(target, CORNER_RADIUS, Contribution::Set(16.0))
        .unwrap();
    let older = win.with_scene(|_, token| token).unwrap();
    assert_eq!(radius(&win), 32.0);
    assert_eq!(
        win.hit_target(Point { x: 32.0, y: 32.0 }),
        Err(Error::PresentationStale)
    );
    assert!(matches!(
        win.update(|card| card.broken = true),
        Err(Error::Canvas(_))
    ));
    assert!(matches!(
        win.set_property(target, CORNER_RADIUS, Contribution::Set(8.0)),
        Err(Error::Canvas(_))
    ));
    assert_eq!(radius(&win), 32.0);
    assert_eq!(win.property(target, CORNER_RADIUS).unwrap(), 8.0);
    win.set_semantic(
        target,
        gpui::semantic::NAME,
        Contribution::Set(Some("new name".into())),
    )
    .unwrap();
    assert_eq!(radius(&win), 32.0);
    win.presented(older).unwrap();
    assert_eq!(radius(&win), 16.0);
    assert_eq!(
        win.hit_target(Point { x: 32.0, y: 32.0 }),
        Err(Error::PresentationStale)
    );
    win.update(|card| card.broken = false).unwrap();
    ack(&mut win);
    assert_eq!(radius(&win), 8.0);
    win.resize([80, 72]).unwrap();
    ack(&mut win);
    assert_eq!(radius(&win), 8.0);
}

#[test]
fn rounded_album_cover_uses_shared_image_pixels_and_matching_own_hit_shape() {
    struct Cover {
        pixels: gpui::Image,
    }
    impl View for Cover {
        fn view(&self) -> El<'_> {
            image(&self.pixels)
                .size(64)
                .rounded(32.0)
                .on_click(|_: &mut Cover| {})
        }
    }
    let pixels = gpui::Image::rgba8(
        1,
        1,
        gpui::ImageProfile::Srgb,
        gpui::AlphaMode::Straight,
        vec![255, 0, 0, 255].into_boxed_slice(),
    )
    .unwrap();
    let mut win = Win::demo(Cover { pixels });
    assert_eq!(win.hit_target(Point { x: 0.5, y: 0.5 }).unwrap(), None);
    assert!(
        win.hit_target(Point { x: 32.0, y: 32.0 })
            .unwrap()
            .is_some()
    );
    win.with_scene(|scene, _| {
        assert_eq!(scene.images().count(), 1);
        assert_eq!(
            scene
                .draws()
                .filter(|draw| draw.source.image().is_some())
                .count(),
            1
        );
    })
    .unwrap();
    win.with_pixels(|pixels, width, _| {
        assert_eq!(&pixels[..4], &[255, 255, 255, 255]);
        assert_eq!(
            &pixels[(32 * width as usize + 32) * 4..][..4],
            &[255, 0, 0, 255]
        );
    })
    .unwrap();
}

#[test]
fn malformed_builder_reports_the_node_before_any_new_sheet_is_published() {
    let mut win = Win::demo(card());
    let before = radius(&win);
    assert!(matches!(
        win.update(|card| card.radius = -1.0),
        Err(Error::GeometryProperty { node: 0, .. })
    ));
    assert_eq!(radius(&win), before);
    win.update(|card| card.radius = 6.0).unwrap();
    assert_eq!(radius(&win), 6.0);
}

#[test]
fn radius_composes_with_component_routes_without_clipping_descendants() {
    use gpui::{Component, FieldId, Sources, row};
    struct Child {
        name: &'static str,
        clicks: u32,
    }
    impl Child {
        fn click(&mut self) {
            self.clicks += 1;
        }
    }
    impl View for Child {
        fn view(&self) -> El<'_> {
            div()
                .size(32)
                .bg(Color::BLACK)
                .name(self.name)
                .rounded_md()
                .on_click(Self::click)
                .child(div().size(4).bg(Color::WHITE))
        }
    }
    struct Pair {
        left: Child,
        right: Child,
    }
    impl Pair {
        const LEFT: Component<Self, Child> =
            Component::new(FieldId::new(1), "left", |m| &m.left, |m| &mut m.left);
        const RIGHT: Component<Self, Child> =
            Component::new(FieldId::new(2), "right", |m| &m.right, |m| &mut m.right);
    }
    impl View for Pair {
        fn sources() -> Sources<Self> {
            Sources::new().component(Self::LEFT).component(Self::RIGHT)
        }
        fn view(&self) -> El<'_> {
            row((Self::LEFT.view(self), Self::RIGHT.view(self))).gap(4)
        }
    }
    let mut win = Win::demo(Pair {
        left: Child {
            name: "left",
            clicks: 0,
        },
        right: Child {
            name: "right",
            clicks: 0,
        },
    });
    let left = win.query().name("left").one().unwrap();
    let right = win.query().name("right").one().unwrap();
    win.set_property(left, CORNER_RADIUS, Contribution::Set(16.0))
        .unwrap();
    assert_eq!(win.property(right, CORNER_RADIUS).unwrap(), 6.0);
    win.activate(right).unwrap();
    assert_eq!(
        (
            win.root().unwrap().left.clicks,
            win.root().unwrap().right.clicks
        ),
        (0, 1)
    );
    assert_eq!(win.property(left, CORNER_RADIUS).unwrap(), 16.0);
    // The visible child at the parent's cut-out corner remains a hit; ordinary
    // ancestor bubbling is retained because .rounded is not a child clip.
    assert_eq!(
        win.hit_target(Point { x: 1.0, y: 1.0 }).unwrap(),
        Some(left)
    );
}

#[test]
fn removing_radius_keeps_old_recording_shape_until_acknowledgement() {
    let mut win = Win::recording(
        card(),
        WindowOptions {
            size: [64, 64],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    let target = root(&win);
    win.set_property(target, CORNER_RADIUS, Contribution::Set(0.0))
        .unwrap();
    assert_eq!(radius(&win), 32.0);
    assert_eq!(win.property(target, CORNER_RADIUS).unwrap(), 0.0);
    ack(&mut win);
    assert_eq!(radius(&win), 0.0);
    assert_eq!(
        win.hit_target(Point { x: 0.5, y: 0.5 }).unwrap(),
        Some(target)
    );
}

#[test]
fn typed_inspector_retains_signed_zero_bits_in_each_authoring_domain() {
    use gpui::property::{BACKGROUND, TRANSFORM, WIDTH};
    let mut win = Win::demo(card());
    let target = root(&win);
    win.set_property(target, CORNER_RADIUS, Contribution::Set(-0.0))
        .unwrap();
    assert_eq!(
        win.property(target, CORNER_RADIUS).unwrap().to_bits(),
        (-0.0_f32).to_bits()
    );
    assert_eq!(radius(&win).to_bits(), (-0.0_f32).to_bits());
    win.set_property(
        target,
        BACKGROUND,
        Contribution::Set(gpui::Brush::Solid(
            Color::linear_srgb(0.0, 0.0, 0.0, 1.0).unwrap(),
        )),
    )
    .unwrap();
    win.set_property(
        target,
        BACKGROUND,
        Contribution::Set(gpui::Brush::Solid(
            Color::linear_srgb(-0.0, 0.0, 0.0, 1.0).unwrap(),
        )),
    )
    .unwrap();
    assert_eq!(
        win.property(target, BACKGROUND)
            .unwrap()
            .solid()
            .unwrap()
            .channels()[0]
            .to_bits(),
        (-0.0_f32).to_bits()
    );
    win.set_property(
        target,
        TRANSFORM,
        Contribution::Set(Affine {
            tx: -0.0,
            ..Affine::IDENTITY
        }),
    )
    .unwrap();
    assert_eq!(
        win.property(target, TRANSFORM).unwrap().tx.to_bits(),
        (-0.0_f32).to_bits()
    );
    win.set_property(target, WIDTH, Contribution::Set(gpui::Length::Points(-0.0)))
        .unwrap();
    assert_eq!(
        win.property(target, WIDTH).unwrap().unwrap().to_bits(),
        (-0.0_f32).to_bits()
    );
    win.set_property(target, CORNER_RADIUS, Contribution::Set(0.0))
        .unwrap();
    assert_eq!(
        win.contribution(target, CORNER_RADIUS).unwrap(),
        Contribution::Set(0.0)
    );
    win.set_property(target, CORNER_RADIUS, Contribution::Inherit)
        .unwrap();
    assert_eq!(win.property(target, CORNER_RADIUS).unwrap(), 32.0);
}
