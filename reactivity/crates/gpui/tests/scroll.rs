use gpui::{Error, Role, ScrollDelta, ScrollOffset, WindowOptions, prelude::*};

struct Blocks {
    count: usize,
    auto_height: bool,
}
impl View for Blocks {
    fn view(&self) -> El<'_> {
        let pane = column((0..self.count).map(|index| {
            div()
                .w(160)
                .h(40)
                .name(format!("row{index}"))
                .bg(if index % 2 == 0 {
                    Color::BLACK
                } else {
                    Color::rgb(200, 30, 50)
                })
        }))
        .scroll(Axis::BOTH)
        .w(80)
        .name("pane");
        if self.auto_height { pane } else { pane.h(40) }
    }
}
fn pane<M: View + 'static>(win: &Win<M>, name: &str) -> Target {
    win.role(Role::ScrollView).name(name).one().unwrap()
}
#[test]
fn ordinary_scroll_is_two_dimensional_retained_and_keeps_offscreen_semantics() {
    let mut win = Win::with_size(
        Blocks {
            count: 3,
            auto_height: false,
        },
        100,
        90,
    )
    .unwrap();
    let viewport = pane(&win, "pane");
    let row = win.role(Role::Generic).name("row0").one().unwrap();
    assert_eq!(
        win.viewport(viewport).unwrap().max,
        ScrollOffset { x: 80.0, y: 80.0 }
    );
    win.reset_counters().unwrap();
    win.scroll_by(viewport, ScrollDelta { x: 30.0, y: 50.0 })
        .unwrap();
    assert_eq!(
        win.viewport(viewport).unwrap().offset,
        ScrollOffset { x: 30.0, y: 50.0 }
    );
    assert!(win.bounds(row).unwrap().is_empty());
    assert_eq!(win.role(Role::Generic).name("row0").one().unwrap(), row);
    assert_eq!(win.snapshot().unwrap().source_epoch, 0);
    assert_eq!(win.counters().descriptions, 0);
    assert_eq!(win.counters().owner_reruns, 0);
    win.update(|model| model.count = 1).unwrap();
    assert_eq!(pane(&win, "pane"), viewport);
    assert_eq!(
        win.viewport(viewport).unwrap().offset,
        ScrollOffset { x: 30.0, y: 0.0 }
    );
}
#[test]
fn auto_viewport_resize_clamps_from_actual_layout() {
    let mut win = Win::with_size(
        Blocks {
            count: 3,
            auto_height: true,
        },
        100,
        40,
    )
    .unwrap();
    let viewport = pane(&win, "pane");
    assert_eq!(win.viewport(viewport).unwrap().size, [80.0, 40.0]);
    win.scroll_to(viewport, ScrollOffset { x: 0.0, y: 80.0 })
        .unwrap();
    win.resize([100, 100]).unwrap();
    assert_eq!(win.viewport(viewport).unwrap().size, [80.0, 100.0]);
    assert_eq!(win.viewport(viewport).unwrap().offset.y, 20.0);
}
struct Negative;
impl View for Negative {
    fn view(&self) -> El<'_> {
        column(
            div()
                .size(20)
                .bg(Color::BLACK)
                .transform(Affine::translation(-30.0, -50.0)),
        )
        .scroll(Axis::BOTH)
        .size(40)
        .name("pane")
    }
}
#[test]
fn transformed_negative_overflow_is_reachable_without_relayout() {
    let mut win = Win::with_size(Negative, 48, 48).unwrap();
    let viewport = pane(&win, "pane");
    let range = win.viewport(viewport).unwrap();
    assert!(range.min.x <= -30.0 && range.min.y <= -50.0);
    win.scroll_to(viewport, ScrollOffset { x: -30.0, y: -50.0 })
        .unwrap();
    win.with_pixels(|pixels, width, _| {
        assert_eq!(&pixels[..4], &[0, 0, 0, 255]);
        let index = (30 * width as usize + 30) * 4;
        assert_eq!(&pixels[index..index + 4], &[255, 255, 255, 255]);
    })
    .unwrap();
}
struct Nested {
    overlay: bool,
}
impl View for Nested {
    fn view(&self) -> El<'_> {
        let inner = column((0..3).map(|_| div().w(80).h(40).bg(Color::BLACK)))
            .scroll(Axis::Y)
            .w(80)
            .h(40)
            .name("inner");
        let outer = column((inner, div().w(80).h(100)))
            .scroll(Axis::Y)
            .w(80)
            .h(50)
            .name("outer");
        column((
            outer,
            self.overlay.then(|| {
                div()
                    .w(80)
                    .h(50)
                    .bg(Color::BLACK)
                    .transform(Affine::translation(0.0, -50.0))
            }),
        ))
    }
}
#[test]
fn nested_wheel_consumes_once_then_passes_only_residual() {
    let mut win = Win::with_size(Nested { overlay: false }, 100, 100).unwrap();
    let inner = pane(&win, "inner");
    let outer = pane(&win, "outer");
    assert_eq!(
        win.viewport(outer).unwrap().max.y,
        90.0,
        "inner hidden content does not inflate outer range"
    );
    win.reset_counters().unwrap();
    win.scroll_at_2d(Point { x: 10.0, y: 10.0 }, ScrollDelta { x: 0.0, y: 100.0 })
        .unwrap();
    assert_eq!(win.viewport(inner).unwrap().offset.y, 80.0);
    assert_eq!(win.viewport(outer).unwrap().offset.y, 20.0);
    assert_eq!(win.snapshot().unwrap().source_epoch, 0);
    assert_eq!(win.counters().paint_passes, 1);
    assert_eq!(win.counters().descriptions, 0);
}
#[test]
fn later_overlay_blocks_background_wheel() {
    let mut win = Win::with_size(Nested { overlay: true }, 100, 100).unwrap();
    let outer = pane(&win, "outer");
    assert_eq!(
        win.scroll_at_2d(Point { x: 10.0, y: 10.0 }, ScrollDelta { x: 0.0, y: 100.0 }),
        Err(Error::NotHittable)
    );
    assert_eq!(win.viewport(outer).unwrap().offset.y, 0.0);
}
#[test]
fn published_metadata_and_targets_do_not_advance_before_ack() {
    let mut win = Win::recording(
        Blocks {
            count: 3,
            auto_height: false,
        },
        WindowOptions {
            size: [100, 90],
            ..Default::default()
        },
    )
    .unwrap();
    let initial = win.with_scene(|_, token| token).unwrap();
    win.presented(initial).unwrap();
    let viewport = pane(&win, "pane");
    let row = win.role(Role::Generic).name("row2").one().unwrap();
    win.scroll_to(viewport, ScrollOffset { x: 10.0, y: 50.0 })
        .unwrap();
    assert_eq!(
        win.viewport(viewport).unwrap().offset,
        ScrollOffset::default()
    );
    assert_eq!(win.scroll(viewport, 1.0), Err(Error::PresentationStale));
    let mut offset = None;
    win.visit(|part| {
        if part.target() == viewport {
            offset = part.viewport().map(|viewport| viewport.offset);
        }
    })
    .unwrap();
    assert_eq!(offset, Some(ScrollOffset::default()));
    let candidate = win.with_scene(|_, token| token).unwrap();
    assert_ne!(candidate, initial);
    assert_eq!(win.presented(initial), Err(Error::StalePresentation));
    win.presented(candidate).unwrap();
    assert_eq!(win.viewport(viewport).unwrap().offset.y, 50.0);
    assert_eq!(win.role(Role::Generic).name("row2").one().unwrap(), row);
}
#[test]
fn scroll_into_view_uses_retained_offscreen_bounds() {
    let mut win = Win::with_size(
        Blocks {
            count: 3,
            auto_height: false,
        },
        100,
        90,
    )
    .unwrap();
    let viewport = pane(&win, "pane");
    let row = win.role(Role::Generic).name("row2").one().unwrap();
    win.scroll_into_view(row).unwrap();
    assert_eq!(win.viewport(viewport).unwrap().offset.y, 80.0);
    assert!(!win.bounds(row).unwrap().is_empty());
}

struct HugeNested;
impl View for HugeNested {
    fn view(&self) -> El<'_> {
        column(
            column(
                div()
                    .size(100_000)
                    .transform(Affine::translation(-50_000.0, -60_000.0)),
            )
            .scroll(Axis::BOTH)
            .size(10)
            .name("inner"),
        )
        .scroll(Axis::BOTH)
        .size(20)
        .name("outer")
    }
}
#[test]
fn nested_aperture_contains_both_cephal_and_transformed_overflow() {
    let win = Win::with_size(HugeNested, 40, 40).unwrap();
    let outer = win.viewport(pane(&win, "outer")).unwrap();
    assert_eq!(outer.min, ScrollOffset::default());
    assert_eq!(outer.max, ScrollOffset::default());
    let inner = win.viewport(pane(&win, "inner")).unwrap();
    assert_eq!(
        inner.min,
        ScrollOffset {
            x: -50_000.0,
            y: -60_000.0
        }
    );
    assert!(inner.max.x >= 99_990.0 && inner.max.y >= 99_990.0);
}
#[test]
fn ordinary_resize_and_paint_geometry_overrides_never_redescribe_the_owner() {
    use gpui::property::{BACKGROUND, Contribution, TRANSFORM};
    let mut win = Win::with_size(
        Blocks {
            count: 3,
            auto_height: true,
        },
        100,
        40,
    )
    .unwrap();
    let viewport = pane(&win, "pane");
    win.reset_counters().unwrap();
    win.set_property(viewport, BACKGROUND, Contribution::Set(Color::WHITE))
        .unwrap();
    win.set_property(
        viewport,
        TRANSFORM,
        Contribution::Set(Affine::translation(2.0, 3.0)),
    )
    .unwrap();
    win.resize([100, 70]).unwrap();
    assert_eq!(win.counters().descriptions, 0);
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(win.viewport(viewport).unwrap().size, [80.0, 70.0]);
}
struct Axes {
    axes: Axis,
    map: Affine,
    show: bool,
}
impl View for Axes {
    fn view(&self) -> El<'_> {
        if self.show {
            column(div().size(100).bg(Color::BLACK))
                .scroll(self.axes)
                .size(40)
                .name("pane")
                .transform(self.map)
        } else {
            div()
        }
    }
}
#[test]
fn changing_axes_clamps_disabled_offsets_and_removed_targets_stay_stale() {
    let mut win = Win::with_size(
        Axes {
            axes: Axis::BOTH,
            map: Affine::IDENTITY,
            show: true,
        },
        60,
        60,
    )
    .unwrap();
    let target = pane(&win, "pane");
    win.scroll_to(target, ScrollOffset { x: 30.0, y: 40.0 })
        .unwrap();
    win.update(|m| m.axes = Axis::Y).unwrap();
    assert_eq!(pane(&win, "pane"), target);
    assert_eq!(
        win.viewport(target).unwrap().offset,
        ScrollOffset { x: 0.0, y: 40.0 }
    );
    win.update(|m| m.show = false).unwrap();
    assert_eq!(win.viewport(target), Err(Error::StaleTarget));
    win.update(|m| m.show = true).unwrap();
    assert_ne!(pane(&win, "pane"), target);
    assert_eq!(win.viewport(target), Err(Error::StaleTarget));
}
#[test]
fn unsupported_viewport_transform_keeps_old_p_geometry_and_metadata() {
    let mut win = Win::with_size(
        Axes {
            axes: Axis::BOTH,
            map: Affine::IDENTITY,
            show: true,
        },
        60,
        60,
    )
    .unwrap();
    let target = pane(&win, "pane");
    let before = win.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
    assert_eq!(
        win.update(|m| m.map = Affine::rotation(0.2)),
        Err(Error::Scroll(gpui::ScrollError::UnsupportedTransform))
    );
    assert_eq!(
        win.viewport(target).unwrap().offset,
        ScrollOffset::default()
    );
    assert_eq!(
        win.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap(),
        before
    );
    assert_eq!(win.scroll(target, 1.0), Err(Error::PresentationStale));
    win.update(|m| m.map = Affine::IDENTITY).unwrap();
    win.scroll(target, 20.0).unwrap();
    assert_eq!(win.viewport(target).unwrap().offset.y, 20.0);
}
#[test]
fn invalid_offsets_and_foreign_targets_leave_epochs_and_scene_token_unchanged() {
    let mut win = Win::with_size(
        Blocks {
            count: 3,
            auto_height: false,
        },
        100,
        90,
    )
    .unwrap();
    let other = Win::with_size(
        Blocks {
            count: 3,
            auto_height: false,
        },
        100,
        90,
    )
    .unwrap();
    let target = pane(&win, "pane");
    let token = win.with_scene(|_, token| token).unwrap();
    assert_eq!(
        win.scroll_by(
            target,
            ScrollDelta {
                x: f64::NAN,
                y: 1.0
            }
        ),
        Err(Error::Scroll(gpui::ScrollError::InvalidDelta))
    );
    assert_eq!(
        win.scroll_to(
            target,
            ScrollOffset {
                x: 0.0,
                y: f64::INFINITY
            }
        ),
        Err(Error::Scroll(gpui::ScrollError::InvalidOffset))
    );
    assert_eq!(win.viewport(pane(&other, "pane")), Err(Error::StaleTarget));
    assert_eq!(win.with_scene(|_, current| current).unwrap(), token);
    assert_eq!(win.snapshot().unwrap().source_epoch, 0);
}
struct ScaledNested;
impl View for ScaledNested {
    fn view(&self) -> El<'_> {
        column((
            column((0..3).map(|_| div().w(40).h(40).bg(Color::BLACK)))
                .scroll(Axis::Y)
                .size(40)
                .name("inner")
                .transform(Affine::scale(2.0, 2.0)),
            div().w(40).h(100),
        ))
        .scroll(Axis::Y)
        .w(90)
        .h(60)
        .name("outer")
    }
}
#[test]
fn nested_scaled_wheel_converts_displacement_and_residual_exactly_once() {
    let mut win = Win::with_size(ScaledNested, 100, 100).unwrap();
    let inner = pane(&win, "inner");
    let outer = pane(&win, "outer");
    win.scroll_at_2d(Point { x: 10.0, y: 10.0 }, ScrollDelta { x: 0.0, y: 190.0 })
        .unwrap();
    assert_eq!(win.viewport(inner).unwrap().offset.y, 80.0);
    assert_eq!(win.viewport(outer).unwrap().offset.y, 30.0);
}
#[test]
fn semantic_scroll_actions_use_the_public_mutation_path_and_frozen_support() {
    use gpui::{Action, ActionKind, ScrollDirection, ScrollUnit};
    let mut win = Win::with_size(
        Blocks {
            count: 3,
            auto_height: false,
        },
        100,
        90,
    )
    .unwrap();
    let viewport = pane(&win, "pane");
    let row = win.role(Role::Generic).name("row2").one().unwrap();
    let mut support = false;
    win.visit(|part| {
        if part.target() == row {
            support = part.actions().contains(ActionKind::ScrollIntoView);
        }
    })
    .unwrap();
    assert!(support);
    win.perform(
        viewport,
        Action::Scroll {
            direction: ScrollDirection::Down,
            unit: ScrollUnit::Page,
        },
    )
    .unwrap();
    assert_eq!(win.viewport(viewport).unwrap().offset.y, 40.0);
    win.perform(row, Action::ScrollIntoView).unwrap();
    assert_eq!(win.viewport(viewport).unwrap().offset.y, 80.0);
    win.perform(viewport, Action::ScrollTo(ScrollOffset::default()))
        .unwrap();
    assert_eq!(
        win.viewport(viewport).unwrap().offset,
        ScrollOffset::default()
    );
    assert_eq!(win.snapshot().unwrap().source_epoch, 0);
}

struct KeyboardPane;
impl View for KeyboardPane {
    fn view(&self) -> El<'_> {
        column((0..5).map(|index| button(format!("row{index}")).w(80).h(32)))
            .scroll(Axis::Y)
            .w(80)
            .h(64)
    }
}
#[test]
fn tab_reveals_offscreen_controls_but_explicit_focus_remains_logical() {
    let mut win = Win::with_size(KeyboardPane, 100, 100).unwrap();
    let pane = win.role(Role::ScrollView).one().unwrap();
    let last = win.button("row4");
    win.focus(last).unwrap();
    assert_eq!(win.viewport(pane).unwrap().offset.y, 0.0);
    win.clear_focus().unwrap();
    win.reset_counters().unwrap();
    for index in 0..5 {
        win.key(Key::Tab).unwrap();
        let target = win.button(&format!("row{index}"));
        assert_eq!(win.focused().unwrap(), Some(target));
        assert!(!win.bounds(target).unwrap().is_empty());
    }
    assert_eq!(win.viewport(pane).unwrap().offset.y, 96.0);
    assert_eq!(win.counters().descriptions, 0);
    assert_eq!(win.snapshot().unwrap().source_epoch, 0);
}

struct Reflected;
impl View for Reflected {
    fn view(&self) -> El<'_> {
        column(div().w(100).h(100).bg(Color::BLACK))
            .scroll(Axis::BOTH)
            .size(40)
            .transform(Affine {
                a: -2.0,
                d: -2.0,
                tx: 80.0,
                ty: 80.0,
                ..Affine::IDENTITY
            })
    }
}
#[test]
fn reflected_dpi_wheel_routes_displacements_instead_of_points() {
    let mut win = Win::with_options_scaled(
        Reflected,
        WindowOptions {
            size: [180, 180],
            ..Default::default()
        },
        2.0,
    )
    .unwrap();
    let target = win.role(Role::ScrollView).one().unwrap();
    win.scroll_to(target, ScrollOffset { x: 30.0, y: 30.0 })
        .unwrap();
    win.scroll_at_2d(
        Point { x: 80.0, y: 80.0 },
        ScrollDelta { x: 20.0, y: -10.0 },
    )
    .unwrap();
    assert_eq!(
        win.viewport(target).unwrap().offset,
        ScrollOffset { x: 20.0, y: 35.0 }
    );
    assert_eq!(win.snapshot().unwrap().source_epoch, 0);
}

struct Deep;
impl View for Deep {
    fn view(&self) -> El<'_> {
        let mut inner = div().w(40).h(80);
        for level in 0..32 {
            inner = column((inner, div().w(40).h(1)))
                .scroll(Axis::Y)
                .size(40)
                .name(format!("depth{level}"));
        }
        inner
    }
}
#[test]
fn deep_residual_routing_has_no_fixed_ancestry_limit_or_repeated_application() {
    let mut win = Win::with_size(Deep, 60, 60).unwrap();
    win.scroll_at_2d(Point { x: 10.0, y: 10.0 }, ScrollDelta { x: 0.0, y: 60.0 })
        .unwrap();
    assert_eq!(win.viewport(pane(&win, "depth0")).unwrap().offset.y, 41.0);
    for level in 1..=19 {
        assert_eq!(
            win.viewport(pane(&win, &format!("depth{level}")))
                .unwrap()
                .offset
                .y,
            1.0
        );
    }
    assert_eq!(win.viewport(pane(&win, "depth20")).unwrap().offset.y, 0.0);
    assert_eq!(win.snapshot().unwrap().source_epoch, 0);
}

struct Mixed;
impl ItemSource for Mixed {
    fn len(&self) -> usize {
        100
    }
    fn key(&self, index: usize) -> ItemKey {
        ItemKey::new(index as u64)
    }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        (key.get() < 100).then_some(key.get() as usize)
    }
    fn row(&self, index: usize) -> El<'_> {
        button(format!("item{index}")).w(80).h(20)
    }
}
impl View for Mixed {
    fn view(&self) -> El<'_> {
        column((
            uniform_list(ListId::new(9), self, 20).w(80).h(40),
            div().w(80).h(100),
        ))
        .scroll(Axis::Y)
        .size(60)
    }
}
#[test]
fn virtual_list_and_ordinary_ancestor_share_one_scroll_cohort() {
    let mut win = Win::with_size(Mixed, 100, 100).unwrap();
    let list = win.list(ListId::new(9)).unwrap();
    let outer = win.role(Role::ScrollView).one().unwrap();
    win.reset_counters().unwrap();
    win.scroll_at_2d(
        Point { x: 10.0, y: 10.0 },
        ScrollDelta { x: 0.0, y: 2000.0 },
    )
    .unwrap();
    assert_eq!(win.list_state(list).unwrap().offset, 1960.0);
    assert_eq!(win.viewport(outer).unwrap().offset.y, 40.0);
    assert_eq!(win.counters().paint_passes, 1);
    assert_eq!(win.snapshot().unwrap().source_epoch, 0);
}

#[test]
fn metadata_only_publication_preserves_cohort_indexed_viewport_dimensions() {
    let mut win = Win::with_size(Mixed, 100, 100).unwrap();
    let list = win.list(ListId::new(9)).unwrap();
    let outer = win.role(Role::ScrollView).one().unwrap();
    let before = [win.viewport(list).unwrap(), win.viewport(outer).unwrap()];
    let token = win.with_scene(|_, token| token).unwrap();
    win.set_semantic(
        list,
        gpui::SemanticText::Name,
        gpui::property::Contribution::Set(Some("Renamed".into())),
    )
    .unwrap();
    assert_eq!(win.with_scene(|_, token| token).unwrap(), token);
    assert_eq!(
        [win.viewport(list).unwrap(), win.viewport(outer).unwrap()],
        before
    );
    win.scroll(outer, 20.0).unwrap();
    assert_eq!(win.viewport(list).unwrap().size, [80.0, 40.0]);
}

#[test]
fn scroll_builder_rejects_role_replacement_and_preserves_container_annotations() {
    assert!(matches!(
        button("control").try_scroll(Axis::Y),
        Err(gpui::ScrollError::UnsupportedElement)
    ));
    struct Named;
    impl View for Named {
        fn view(&self) -> El<'_> {
            column(())
                .name("Named pane")
                .description("Contents")
                .scroll(Axis::Y)
                .child(div().size(100))
                .size(40)
        }
    }
    let win = Win::with_size(Named, 80, 80).unwrap();
    assert_eq!(
        win.role(Role::ScrollView)
            .name("Named pane")
            .description("Contents")
            .count()
            .unwrap(),
        1
    );
}

struct PixelClip {
    viewport: bool,
    map: Affine,
    extent: f32,
    height: f32,
}
impl View for PixelClip {
    fn view(&self) -> El<'_> {
        let node = if self.viewport {
            column(div().w(self.extent).h(self.height).bg(Color::BLACK)).scroll(Axis::BOTH)
        } else {
            div().bg(Color::BLACK)
        };
        node.w(self.extent).h(self.height).transform(self.map)
    }
}
#[test]
fn reflected_fractional_and_collapsed_viewport_clips_match_ordinary_raster_membership() {
    for extent in [0.01, 1.25, 3.0] {
        for scale in [0.1, 1.0, 1.25] {
            for a in [-scale, scale] {
                for d in [-scale, scale] {
                    for translation in [0.125, 0.375, 2.0] {
                        let map = Affine {
                            a,
                            d,
                            tx: translation,
                            ty: translation,
                            ..Affine::IDENTITY
                        };
                        let mut expected = Win::with_size(
                            PixelClip {
                                viewport: false,
                                map,
                                extent,
                                height: extent,
                            },
                            8,
                            8,
                        )
                        .unwrap();
                        let mut actual = Win::with_size(
                            PixelClip {
                                viewport: true,
                                map,
                                extent,
                                height: extent,
                            },
                            8,
                            8,
                        )
                        .unwrap();
                        assert_eq!(
                            actual.with_pixels(|p, _, _| p.to_vec()).unwrap(),
                            expected.with_pixels(|p, _, _| p.to_vec()).unwrap(),
                            "extent{extent} map{map:?}"
                        );
                    }
                }
            }
        }
    }
    let map = Affine {
        a: 1e-10,
        d: 1.0,
        tx: 0.125,
        ..Affine::IDENTITY
    };
    let mut expected = Win::with_size(
        PixelClip {
            viewport: false,
            map,
            extent: 1e-20,
            height: 1.0,
        },
        1,
        1,
    )
    .unwrap();
    let mut actual = Win::with_size(
        PixelClip {
            viewport: true,
            map,
            extent: 1e-20,
            height: 1.0,
        },
        1,
        1,
    )
    .unwrap();
    assert_eq!(
        actual.with_pixels(|p, _, _| p.to_vec()).unwrap(),
        expected.with_pixels(|p, _, _| p.to_vec()).unwrap()
    );
}

struct ParentFlow {
    horizontal: bool,
}
impl View for ParentFlow {
    fn view(&self) -> El<'_> {
        let children = (
            div().w(40).h(10),
            column(div().size(120))
                .scroll(Axis::BOTH)
                .h(64)
                .name("pane"),
        );
        (if self.horizontal {
            row(children)
        } else {
            column(children)
        })
        .w(200)
        .h(100)
        .name("parent")
    }
}
#[test]
fn parent_flow_changes_match_cold_scroll_layout_for_source_and_property() {
    use gpui::property::{Contribution, FLOW};
    let mut retained = Win::with_size(ParentFlow { horizontal: true }, 200, 100).unwrap();
    let cold = Win::with_size(ParentFlow { horizontal: false }, 200, 100).unwrap();
    let expected = cold.viewport(pane(&cold, "pane")).unwrap();
    let target = pane(&retained, "pane");
    retained.update(|m| m.horizontal = false).unwrap();
    assert_eq!(retained.viewport(target).unwrap(), expected);
    let mut retained = Win::with_size(ParentFlow { horizontal: true }, 200, 100).unwrap();
    let parent = retained.role(Role::Generic).name("parent").one().unwrap();
    let target = pane(&retained, "pane");
    retained
        .set_property(parent, FLOW, Contribution::Set(gpui::Flow::Column))
        .unwrap();
    assert_eq!(retained.viewport(target).unwrap(), expected);
}

struct OversizedNested {
    map: Affine,
    leading: f32,
}
impl View for OversizedNested {
    fn view(&self) -> El<'_> {
        column((
            div().w(80).h(200),
            column((
                div().w(80).h(self.leading),
                button("Oversized").w(80).h(1000),
            ))
            .scroll(Axis::Y)
            .w(80)
            .h(40)
            .name("inner"),
        ))
        .scroll(Axis::Y)
        .w(80)
        .h(80)
        .name("outer")
        .transform(self.map)
    }
}
#[test]
fn reveal_propagates_the_visible_fragment_through_nested_apertures() {
    for leading in [0.0, 20.0] {
        for a in [-1.0, 1.0] {
            for d in [-1.0, 1.0] {
                let map = Affine {
                    a,
                    d,
                    tx: if a < 0.0 { 80.0 } else { 0.0 },
                    ty: if d < 0.0 { 80.0 } else { 0.0 },
                    ..Affine::IDENTITY
                };
                let mut win = Win::with_size(OversizedNested { map, leading }, 100, 100).unwrap();
                let inner = pane(&win, "inner");
                let outer = pane(&win, "outer");
                let target = win.button("Oversized");
                assert!(win.bounds(target).unwrap().is_empty());
                win.scroll_into_view(target).unwrap();
                assert_eq!(
                    win.viewport(inner).unwrap().offset.y,
                    f64::from(leading),
                    "nearest oversized edge"
                );
                assert_eq!(
                    win.viewport(outer).unwrap().offset.y,
                    160.0,
                    "reveal inner's visible fragment"
                );
                assert!(!win.bounds(target).unwrap().is_empty());
                win.scroll_to(inner, ScrollOffset { x: 0.0, y: 500.0 })
                    .unwrap();
                win.scroll_to(outer, ScrollOffset::default()).unwrap();
                win.scroll_into_view(target).unwrap();
                assert_eq!(
                    win.viewport(inner).unwrap().offset.y,
                    500.0,
                    "already covers aperture"
                );
                assert_eq!(win.viewport(outer).unwrap().offset.y, 160.0);
                assert!(!win.bounds(target).unwrap().is_empty());
            }
        }
    }
}

#[test]
fn virtual_rows_hidden_by_an_ordinary_ancestor_never_revive_old_targets() {
    let mut win = Win::with_size(Mixed, 100, 100).unwrap();
    let outer = win.role(Role::ScrollView).one().unwrap();
    let list = win.list(ListId::new(9)).unwrap();
    let departed = win.button("item0");
    win.focus(departed).unwrap();
    win.scroll(outer, 80.0).unwrap();
    assert_eq!(win.focused().unwrap(), None);
    assert_eq!(win.bounds(departed), Err(Error::StaleTarget));
    win.scroll_to(outer, ScrollOffset::default()).unwrap();
    assert_eq!(win.list(ListId::new(9)).unwrap(), list);
    assert_ne!(win.button("item0"), departed);
    assert_eq!(win.focused().unwrap(), None);
    assert_eq!(win.bounds(departed), Err(Error::StaleTarget));
    assert_eq!(win.snapshot().unwrap().source_epoch, 0);
}

#[test]
fn semantic_cardinal_action_rechecks_the_frozen_enabled_axis() {
    let mut win = Win::with_size(KeyboardPane, 100, 100).unwrap();
    let target = win.role(Role::ScrollView).one().unwrap();
    let token = win.with_scene(|_, token| token).unwrap();
    assert_eq!(
        win.perform(
            target,
            gpui::Action::Scroll {
                direction: gpui::ScrollDirection::Left,
                unit: gpui::ScrollUnit::Page
            }
        ),
        Err(Error::NotInteractive)
    );
    assert_eq!(win.with_scene(|_, token| token).unwrap(), token);
    assert_eq!(
        win.viewport(target).unwrap().offset,
        ScrollOffset::default()
    );
}

#[test]
fn virtual_focus_retires_with_candidate_authority_and_never_returns() {
    let mut win = Win::recording(
        Mixed,
        WindowOptions {
            size: [100, 100],
            ..Default::default()
        },
    )
    .unwrap();
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    let outer = win.role(Role::ScrollView).one().unwrap();
    let departed = win.button("item0");
    win.focus(departed).unwrap();
    win.scroll(outer, 80.0).unwrap();
    assert_eq!(
        win.focused().unwrap(),
        None,
        "completed C already revokes the virtual interaction target"
    );
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    assert_eq!(win.focused().unwrap(), None);
    win.scroll_to(outer, ScrollOffset::default()).unwrap();
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    assert_eq!(win.focused().unwrap(), None);
    assert_ne!(win.button("item0"), departed);
    assert_eq!(win.bounds(departed), Err(Error::StaleTarget));
}

struct WideTransforms {
    map: Affine,
}
impl View for WideTransforms {
    fn view(&self) -> El<'_> {
        column(
            column(
                column(
                    div()
                        .size(16)
                        .name("leaf")
                        .bg(Color::BLACK)
                        .transform(Affine::translation(500_000.0, -400_000.0)),
                )
                .size(16)
                .transform(Affine::scale(-0.7, -1.2)),
            )
            .size(16)
            .transform(Affine::scale(1.3, 1.1)),
        )
        .scroll(Axis::BOTH)
        .size(40)
        .transform(self.map)
    }
}
#[test]
fn wide_overflow_endpoints_match_continuous_reference_after_p_narrowing() {
    let x = f64::from(1.3_f32) * f64::from(-0.7_f32);
    let y = f64::from(1.1_f32) * f64::from(-1.2_f32);
    for a in [-1.1, 1.1] {
        for d in [-0.9, 0.9] {
            let map = Affine {
                a,
                d,
                tx: 80.0,
                ty: 80.0,
                ..Affine::IDENTITY
            };
            let mut win = Win::with_size(WideTransforms { map }, 160, 160).unwrap();
            let pane = win.role(Role::ScrollView).one().unwrap();
            let leaf = win.role(Role::Generic).name("leaf").one().unwrap();
            let viewport = win.viewport(pane).unwrap();
            assert!((viewport.min.x - x * 500_016.0).abs() < 1e-7);
            assert!((viewport.max.y - (y * -400_000.0 - 40.0)).abs() < 1e-7);
            for (offset, visible) in [
                (
                    ScrollOffset {
                        x: viewport.min.x,
                        y: viewport.max.y,
                    },
                    true,
                ),
                (
                    ScrollOffset {
                        x: viewport.max.x,
                        y: viewport.min.y,
                    },
                    false,
                ),
            ] {
                win.scroll_to(pane, offset).unwrap();
                let mut reference = [
                    f64::INFINITY,
                    f64::INFINITY,
                    f64::NEG_INFINITY,
                    f64::NEG_INFINITY,
                ];
                for u in [0.0, 16.0] {
                    for v in [0.0, 16.0] {
                        let px = f64::from(a) * (x * (500_000.0 + u) - offset.x) + 80.0;
                        let py = f64::from(d) * (y * (-400_000.0 + v) - offset.y) + 80.0;
                        reference[0] = reference[0].min(px);
                        reference[1] = reference[1].min(py);
                        reference[2] = reference[2].max(px);
                        reference[3] = reference[3].max(py);
                    }
                }
                let mut actual = None;
                win.visit(|part| {
                    if part.target() == leaf {
                        actual = part.unclipped_bounds();
                    }
                })
                .unwrap();
                let actual = actual.unwrap();
                let actual = [
                    f64::from(actual.x),
                    f64::from(actual.y),
                    f64::from(actual.x) + f64::from(actual.width),
                    f64::from(actual.y) + f64::from(actual.height),
                ];
                // P intentionally stores a narrowed f32 map and conservative
                // outward bounds. At this admitted ~500K span, allow0.125px
                // error, rather than claiming the P AABB equals wide range math.
                for (actual, expected) in actual.into_iter().zip(reference) {
                    assert!(
                        (actual - expected).abs() <= 0.125,
                        "{actual} vs{expected} map{map:?} offset{offset:?}"
                    );
                }
                assert_eq!(!win.bounds(leaf).unwrap().is_empty(), visible);
                if visible {
                    assert!(
                        win.with_pixels(|pixels, _, _| pixels.chunks_exact(4).any(|p| p[0] == 0))
                            .unwrap()
                    );
                }
            }
        }
    }
}
