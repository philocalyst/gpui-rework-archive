use crate::prelude::*;
use crate::{
    AnyElement, AnyWindowHandle, App, Bounds, ContentMask, Context, CoordinateSpace, DispatchPhase,
    Edges, ElementTransform, Empty, Entity, InputEvent, InputHandler, MouseButton, MouseDownEvent,
    MouseUpEvent, Pixels, Point, Radians, Render, ScrollDelta, ScrollWheelEvent, StyleRefinement,
    TestAppContext, TransformationMatrix, UTF16Selection, VisualTestContext, Window, canvas, div,
    point, px, size,
};
use std::{
    cell::{Cell, RefCell},
    ops::Range,
    rc::Rc,
};

struct TestTree {
    build: Box<dyn FnMut(&mut Window, &mut Context<Self>) -> AnyElement>,
}

impl Render for TestTree {
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        (self.build)(window, cx)
    }
}

fn add_tree_window(
    cx: &mut TestAppContext,
    build: impl FnMut(&mut Window, &mut Context<TestTree>) -> AnyElement + 'static,
) -> (Entity<TestTree>, &mut VisualTestContext) {
    cx.add_window_view(move |_, _| TestTree {
        build: Box::new(build),
    })
}

#[test]
fn affine_operations_keep_their_order_and_inverse() {
    let transform = ElementTransform::default()
        .scale(2.)
        .translate(point(px(10.), px(20.)));
    let bounds = Bounds::new(point(px(0.), px(0.)), size(px(100.), px(100.)));
    let space = CoordinateSpace::new(transform.resolve(bounds));

    let mapped = space.to_window(point(px(3.), px(4.)));
    assert_eq!(mapped, point(px(16.), px(28.)));
    assert_eq!(space.from_window(mapped), Some(point(px(3.), px(4.))));
}

#[test]
fn same_space_fades_keep_their_original_ramps() {
    let mask = |left, width, fade| ContentMask {
        bounds: Bounds::new(point(px(left), px(0.)), size(px(width), px(100.))),
        fade_out: Edges {
            left: px(fade),
            ..Default::default()
        },
        ..Default::default()
    };
    for (outer, inner, x, expected) in [
        (mask(0., 100., 20.), mask(10., 80., 30.), 15., 0.125),
        (mask(0., 100., 20.), mask(0., 100., 20.), 10., 0.25),
        (mask(0., 100., 20.), mask(10., 80., 0.), 15., 0.75),
    ] {
        let space = CoordinateSpace::default().clipped(outer).clipped(inner);
        assert!(
            space.contains_window_point(point(px(x), px(50.))),
            "visual fading does not disable geometric input"
        );
        for scale in [1., 2.] {
            let mut scene = crate::Scene::default();
            scene.enter_coordinate_space(&space, scale);
            let clips: Vec<_> = scene
                .render_spaces()
                .iter()
                .filter(|record| record.kind == crate::SpaceKind::Clip)
                .collect();
            assert_eq!(clips.len(), 2, "neither partial ramp may be merged away");
            let alpha: f32 = clips
                .iter()
                .map(|record| {
                    if record.fade.left.0 > 0. {
                        ((x * scale - record.clip.origin.x.0) / record.fade.left.0).clamp(0., 1.)
                    } else {
                        1.
                    }
                })
                .product();
            assert!((alpha - expected).abs() < 0.00001);
        }
    }
}

#[test]
fn viewport_cropping_preserves_fade_anchors_and_hard_clip_fast_path() {
    let viewport = Bounds::new(point(px(0.), px(0.)), size(px(50.), px(100.)));
    let bounds = Bounds::new(point(px(-10.), px(0.)), size(px(100.), px(100.)));
    let faded = CoordinateSpace::default().clipped(ContentMask {
        bounds,
        fade_out: Edges {
            left: px(20.),
            ..Default::default()
        },
        ..Default::default()
    });
    assert!(!faded.is_identity_scope());
    assert_eq!(faded.content_mask(viewport).bounds, viewport);
    assert_eq!(faded.content_mask(viewport).fade_out, Edges::default());
    let mut scene = crate::Scene::default();
    scene.enter_coordinate_space(&faded, 1.);
    let clip = scene
        .render_spaces()
        .iter()
        .find(|record| record.kind == crate::SpaceKind::Clip)
        .unwrap();
    assert_eq!(clip.clip.origin.x.0, -10.);
    assert_eq!((5. - clip.clip.origin.x.0) / clip.fade.left.0, 0.75);

    let hard = CoordinateSpace::default().clipped(bounds).clipped(viewport);
    assert!(hard.is_identity_scope());
    assert_eq!(hard.content_mask(viewport), ContentMask::from(viewport));
    assert!(hard.clips.as_ref().unwrap().parent.is_none());
}

#[gpui::test]
fn deferred_overlay_can_escape_clipping_without_leaving_the_camera(cx: &mut TestAppContext) {
    let observed = Rc::new(RefCell::new(Vec::new()));
    let observations = observed.clone();
    let camera = ElementTransform::default()
        .scale(2.)
        .translate(point(px(10.), px(20.)))
        .resolve(Bounds::default());
    let probe = point(px(12.), px(0.));
    let (_, context) = add_tree_window(cx, move |_, _| {
        let observations = observations.clone();
        canvas(
            move |_, window, cx| {
                let original = window.coordinate_space().clone();
                window.with_element_transform(camera, |window| {
                    window.with_clip(
                        Bounds::new(point(px(0.), px(0.)), size(px(10.), px(10.))),
                        |window| {
                            for escape in [false, true] {
                                let observations = observations.clone();
                                let mut deferred = canvas(
                                    |_, _, _| (),
                                    move |_, _, window, _| {
                                        let space = window.coordinate_space();
                                        observations.borrow_mut().push((
                                            escape,
                                            space.to_window(probe),
                                            space.contains_window_point(camera.apply(probe)),
                                        ));
                                    },
                                )
                                .size(px(20.))
                                .into_any_element();
                                deferred.layout_as_root(
                                    crate::AvailableSpace::min_size(),
                                    window,
                                    cx,
                                );
                                let space = if escape {
                                    window.coordinate_space().without_clips()
                                } else {
                                    window.coordinate_space().clone()
                                };
                                window.with_coordinate_space(space, |window| {
                                    window.defer_draw(deferred, Point::default(), 0, None)
                                });
                            }
                        },
                    );
                });
                assert_eq!(
                    *window.coordinate_space(),
                    original,
                    "all nested scopes restore their parent"
                );
            },
            |_, _, _, _| {},
        )
        .size_full()
        .into_any_element()
    });
    // Inspect the explicit frame below, after the initial window draw.
    observed.borrow_mut().clear();
    context.update(|window, cx| window.draw(cx).clear(cx));
    assert_eq!(
        *observed.borrow(),
        [
            (false, camera.apply(probe), false),
            (true, camera.apply(probe), true)
        ]
    );
}

#[test]
fn origin_rotation_and_nested_composition_share_one_local_mapping() {
    let bounds = Bounds::new(point(px(0.), px(0.)), size(px(40.), px(20.)));
    let child = ElementTransform::default()
        .origin(point(0.5, 0.5))
        .rotate(Radians(std::f32::consts::FRAC_PI_2))
        .resolve(bounds);
    let parent = ElementTransform::default()
        .scale(2.)
        .translate(point(px(10.), px(20.)))
        .resolve(Bounds::new(point(px(0.), px(0.)), size(px(100.), px(100.))));

    let pivot = point(px(20.), px(10.));
    assert_eq!(child.apply(pivot), pivot);

    let nested = CoordinateSpace::new(parent.compose(child));
    assert_eq!(
        nested.to_window(point(px(20.), px(0.))),
        point(px(70.), px(40.))
    );
    let local = nested.from_window(point(px(70.), px(40.))).unwrap();
    assert!((local.x.0 - 20.).abs() < 0.001);
    assert!(local.y.0.abs() < 0.001);
}

#[test]
fn collapsed_and_rotated_spaces_have_sound_inverse_and_scale_queries() {
    let zero_scale = CoordinateSpace::new(
        ElementTransform::default()
            .scale(0.)
            .resolve(Bounds::new(point(px(0.), px(0.)), size(px(10.), px(10.)))),
    );
    assert_eq!(zero_scale.from_window(point(px(0.), px(0.))), None);

    let rotation_and_scale = ElementTransform::default()
        .scale_axes(size(3., 2.))
        .rotate(Radians(std::f32::consts::FRAC_PI_4))
        .resolve(Bounds::new(point(px(0.), px(0.)), size(px(10.), px(10.))));
    let space = CoordinateSpace::new(rotation_and_scale);
    assert!((space.transform.max_scale() - 3.).abs() < 0.001);
    let point = point(px(2.), px(7.));
    let round_trip = space.from_window(space.to_window(point)).unwrap();
    assert!((round_trip.x.0 - point.x.0).abs() < 0.001);
    assert!((round_trip.y.0 - point.y.0).abs() < 0.001);
}

#[test]
fn bitmap_density_uses_the_composed_intrinsic_mapping() {
    let anisotropic_parent = TransformationMatrix::unit().scale(size(4., 0.25));
    let anisotropic_child = TransformationMatrix::unit().scale(size(0.25, 4.));
    let parent = CoordinateSpace::new(anisotropic_parent);

    // The two anisotropic scales cancel. Multiplying their independent maximum
    // stretches would incorrectly select the maximum density bucket.
    assert_eq!(parent.raster_scale_for(anisotropic_child), 1.);
    assert_eq!(
        parent.raster_scale_for(TransformationMatrix {
            translation: [3., -2.],
            ..TransformationMatrix::unit()
        }),
        parent.raster_scale()
    );

    let rotated_parent = TransformationMatrix::unit()
        .scale(size(1.5, 0.75))
        .rotate(Radians(0.37));
    let sheared_child = TransformationMatrix {
        rotation_scale: [[1., 0.6], [0.2, 1.]],
        translation: [80., -40.],
    };
    let composed = rotated_parent.compose(sheared_child);
    let expected = (composed.max_scale().max(1.) * 8.).ceil().clamp(8., 64.) / 8.;
    assert_eq!(
        CoordinateSpace::new(rotated_parent).raster_scale_for(sheared_child),
        expected
    );
}

struct CachedTarget {
    renders: Rc<Cell<usize>>,
    clicks: Rc<Cell<usize>>,
}

impl Render for CachedTarget {
    fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
        self.renders.set(self.renders.get() + 1);
        let clicks = self.clicks.clone();
        div()
            .id("cached-target")
            .size(px(40.))
            .on_click(move |_, _, _| clicks.set(clicks.get() + 1))
    }
}

struct CachedCamera {
    target: Entity<CachedTarget>,
    pan_x: Pixels,
}

impl Render for CachedCamera {
    fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
        div().size_full().child(
            div()
                .id("cached-camera")
                .size(px(100.))
                .transform(ElementTransform::default().translate(point(self.pan_x, px(0.))))
                .child(
                    self.target
                        .clone()
                        .cached(StyleRefinement::default().size_full()),
                ),
        )
    }
}

struct FixedInputGeometry {
    bounds: Bounds<Pixels>,
    range_bounds: Option<Vec<Bounds<Pixels>>>,
}

impl InputHandler for FixedInputGeometry {
    fn selected_text_range(
        &mut self,
        _: bool,
        _: &mut Window,
        _: &mut App,
    ) -> Option<UTF16Selection> {
        Some(UTF16Selection {
            range: 2..4,
            reversed: false,
        })
    }

    fn marked_text_range(&mut self, _: &mut Window, _: &mut App) -> Option<Range<usize>> {
        Some(0..5)
    }

    fn text_for_range(
        &mut self,
        _: Range<usize>,
        _: &mut Option<Range<usize>>,
        _: &mut Window,
        _: &mut App,
    ) -> Option<String> {
        None
    }

    fn replace_text_in_range(
        &mut self,
        _: Option<Range<usize>>,
        _: &str,
        _: &mut Window,
        _: &mut App,
    ) {
    }

    fn replace_and_mark_text_in_range(
        &mut self,
        _: Option<Range<usize>>,
        _: &str,
        _: Option<Range<usize>>,
        _: &mut Window,
        _: &mut App,
    ) {
    }

    fn unmark_text(&mut self, _: &mut Window, _: &mut App) {}

    fn bounds_for_range(
        &mut self,
        range_utf16: Range<usize>,
        _: &mut Window,
        _: &mut App,
    ) -> Option<Bounds<Pixels>> {
        self.range_bounds
            .as_ref()
            .and_then(|bounds| bounds.get(range_utf16.start).copied())
            .or(Some(self.bounds))
    }

    fn character_index_for_point(
        &mut self,
        point: Point<Pixels>,
        _: &mut Window,
        _: &mut App,
    ) -> Option<usize> {
        Some(point.x.0.round() as usize)
    }
}

#[gpui::test]
fn transformed_tree_routes_clicks_and_wheels_in_local_coordinates(cx: &mut TestAppContext) {
    let clicks = Rc::new(RefCell::new(Vec::new()));
    let wheel = Rc::new(RefCell::new(Vec::new()));
    let click_log = clicks.clone();
    let wheel_log = wheel.clone();
    let (_, context) = add_tree_window(cx, move |_, _| {
        let click_log = click_log.clone();
        let wheel_log = wheel_log.clone();
        div()
            .size_full()
            .child(
                div()
                    .id("camera")
                    .size(px(100.))
                    .transform(
                        ElementTransform::default()
                            .scale(2.)
                            .translate(point(px(30.), px(20.))),
                    )
                    .child(
                        div()
                            .id("target")
                            .size(px(30.))
                            .on_click(move |event, _, _| {
                                click_log.borrow_mut().push(event.position())
                            })
                            .on_scroll_wheel(move |event, _, _| {
                                if let ScrollDelta::Pixels(delta) = event.delta {
                                    wheel_log.borrow_mut().push((event.position, delta));
                                }
                            }),
                    ),
            )
            .into_any_element()
    });

    // Window point (70, 40) maps to (20, 10) in the scaled subtree.
    context.simulate_mouse_move(
        point(px(70.), px(40.)),
        Option::<MouseButton>::None,
        Default::default(),
    );
    context.simulate_click(point(px(70.), px(40.)), Default::default());
    let click = clicks.borrow()[0];
    assert_eq!(click.x, px(20.));
    assert!((click.y.0 - 10.).abs() < 0.001);

    context.simulate_event(ScrollWheelEvent {
        position: point(px(70.), px(40.)),
        delta: ScrollDelta::Pixels(point(px(20.), px(10.))),
        ..Default::default()
    });
    // Translation never changes a vector; a 2x camera halves the local delta.
    assert_eq!(
        *wheel.borrow(),
        [(point(px(20.), px(10.)), point(px(10.), px(5.)))]
    );
}

#[gpui::test]
fn nested_transforms_keep_descendant_click_coordinates_in_layout_space(cx: &mut TestAppContext) {
    let clicks = Rc::new(RefCell::new(Vec::new()));
    let click_log = clicks.clone();
    let (_, context) = add_tree_window(cx, move |_, _| {
        let click_log = click_log.clone();
        div()
            .size_full()
            .child(
                div()
                    .id("camera")
                    .size(px(100.))
                    .transform(
                        ElementTransform::default()
                            .scale(2.)
                            .translate(point(px(30.), px(20.))),
                    )
                    .child(
                        div()
                            .id("rotated-group")
                            .absolute()
                            .left_0()
                            .top_0()
                            .w(px(40.))
                            .h(px(20.))
                            .transform(
                                ElementTransform::default()
                                    .origin(point(0.5, 0.5))
                                    .rotate(Radians(std::f32::consts::FRAC_PI_2)),
                            )
                            .child(div().id("nested-target").size_full().on_click(
                                move |event, _, _| click_log.borrow_mut().push(event.position()),
                            )),
                    ),
            )
            .into_any_element()
    });

    // The group center (20, 10) is fixed by its 90 degree rotation and is then
    // mapped by the camera to window point (70, 40).
    context.simulate_mouse_move(
        point(px(70.), px(40.)),
        Option::<MouseButton>::None,
        Default::default(),
    );
    context.simulate_click(point(px(70.), px(40.)), Default::default());
    let click = clicks.borrow()[0];
    assert_eq!(click.x, px(20.));
    assert!((click.y.0 - 10.).abs() < 0.001);
}

#[gpui::test]
fn rotated_hitbox_rejects_aabb_corner_and_accepts_shape_interior(cx: &mut TestAppContext) {
    let clicks = Rc::new(Cell::new(0));
    let click_count = clicks.clone();
    let (_, context) = add_tree_window(cx, move |_, _| {
        let click_count = click_count.clone();
        div()
            .size_full()
            .child(
                div()
                    .id("rotated-target")
                    .absolute()
                    .left(px(50.))
                    .top(px(20.))
                    .w(px(40.))
                    .h(px(50.))
                    .transform(
                        ElementTransform::default().rotate(Radians(std::f32::consts::FRAC_PI_4)),
                    )
                    .on_click(move |_, _, _| click_count.set(click_count.get() + 1)),
            )
            .into_any_element()
    });

    // This point is inside the rotated shape's axis-aligned bounds, but its
    // inverse-transformed point lies outside the actual rectangle.
    context.simulate_mouse_move(
        point(px(75.), px(22.)),
        Option::<MouseButton>::None,
        Default::default(),
    );
    context.simulate_click(point(px(75.), px(22.)), Default::default());
    assert_eq!(clicks.get(), 0);

    // The transformed center is inside the true hit region.
    context.simulate_click(point(px(46.46), px(51.82)), Default::default());
    assert_eq!(clicks.get(), 1);
}

#[gpui::test]
fn rotated_overflow_clip_rejects_a_child_point_past_its_exact_edge(cx: &mut TestAppContext) {
    let clicks = Rc::new(Cell::new(0));
    let click_count = clicks.clone();
    let (_, context) = add_tree_window(cx, move |_, _| {
        let click_count = click_count.clone();
        div()
            .size_full()
            .child(
                div()
                    .id("rotated-clip")
                    .absolute()
                    .left(px(50.))
                    .top(px(20.))
                    .w(px(40.))
                    .h(px(20.))
                    .overflow_hidden()
                    .transform(
                        ElementTransform::default().rotate(Radians(std::f32::consts::FRAC_PI_4)),
                    )
                    .child(
                        div()
                            .id("overflowing-child")
                            .absolute()
                            .left(px(-10.))
                            .top(px(-10.))
                            .w(px(80.))
                            .h(px(50.))
                            .on_click(move |_, _, _| click_count.set(click_count.get() + 1)),
                    ),
            )
            .into_any_element()
    });

    // The child contains layout point (95, 25), which maps through the
    // rotated parent to this window point. It is outside the parent's local
    // 40x20 clip despite lying inside both transformed AABBs.
    context.simulate_mouse_move(
        point(px(78.28), px(55.36)),
        Option::<MouseButton>::None,
        Default::default(),
    );
    context.simulate_click(point(px(78.28), px(55.36)), Default::default());
    assert_eq!(clicks.get(), 0);

    context.simulate_click(point(px(57.07), px(41.21)), Default::default());
    assert_eq!(clicks.get(), 1);
}

#[gpui::test]
fn collapsed_transform_cannot_receive_pointer_input(cx: &mut TestAppContext) {
    let clicks = Rc::new(Cell::new(0));
    let click_count = clicks.clone();
    let (_, context) = add_tree_window(cx, move |_, _| {
        let click_count = click_count.clone();
        div()
            .size_full()
            .child(
                div()
                    .id("collapsed")
                    .absolute()
                    .left(px(10.))
                    .top(px(10.))
                    .size(px(40.))
                    .transform(ElementTransform::default().scale(0.))
                    .on_click(move |_, _, _| click_count.set(click_count.get() + 1)),
            )
            .into_any_element()
    });

    context.simulate_mouse_move(
        point(px(10.), px(10.)),
        Option::<MouseButton>::None,
        Default::default(),
    );
    context.simulate_click(point(px(10.), px(10.)), Default::default());
    assert_eq!(clicks.get(), 0);
}

#[gpui::test]
fn drag_threshold_is_measured_in_window_pixels_but_grab_offset_stays_local(
    cx: &mut TestAppContext,
) {
    for scale in [0.5, 4.] {
        let starts = Rc::new(Cell::new(0));
        let offsets = Rc::new(RefCell::new(Vec::new()));
        let starts_for_view = starts.clone();
        let offsets_for_view = offsets.clone();
        let (_, context) = add_tree_window(cx, move |_, _| {
            let starts = starts_for_view.clone();
            let offsets = offsets_for_view.clone();
            div()
                .size_full()
                .child(
                    div()
                        .id("scaled-draggable")
                        .size(px(100.))
                        .transform(
                            ElementTransform::default()
                                .scale(scale)
                                .translate(point(px(20.), px(20.))),
                        )
                        .on_drag("payload", move |_, cursor_offset, _, cx| {
                            starts.set(starts.get() + 1);
                            offsets.borrow_mut().push(cursor_offset);
                            cx.new(|_| Empty)
                        }),
                )
                .into_any_element()
        });

        // A local center point maps to this window location at any zoom.
        let start = point(px(20. + 50. * scale), px(20. + 50. * scale));
        context.simulate_mouse_move(start, None, Default::default());
        context.simulate_mouse_down(start, MouseButton::Left, Default::default());
        context.simulate_mouse_move(
            point(start.x + px(1.), start.y),
            Some(MouseButton::Left),
            Default::default(),
        );
        assert_eq!(
            starts.get(),
            0,
            "a 1px window movement at {scale}x is below threshold"
        );

        context.simulate_mouse_move(
            point(start.x + px(3.), start.y),
            Some(MouseButton::Left),
            Default::default(),
        );
        assert_eq!(
            starts.get(),
            1,
            "a 3px window movement at {scale}x starts a drag"
        );
        assert_eq!(
            *offsets.borrow(),
            [point(px(50. + 3. / scale), px(50.))],
            "the drag constructor receives the threshold-crossing point in element-local units"
        );
        context.simulate_mouse_up(
            point(start.x + px(3.), start.y),
            MouseButton::Left,
            Default::default(),
        );
    }
}

#[gpui::test]
fn captured_drag_preserves_local_coordinates_beyond_the_transformed_clip(cx: &mut TestAppContext) {
    let moves = Rc::new(RefCell::new(Vec::new()));
    let recorded_moves = moves.clone();
    let (_, context) = add_tree_window(cx, move |_, _| {
        let recorded_moves = recorded_moves.clone();
        div()
            .size_full()
            .overflow_hidden()
            .child(
                div()
                    .id("camera")
                    .size(px(100.))
                    .transform(
                        ElementTransform::default()
                            .scale(2.)
                            .translate(point(px(20.), px(10.))),
                    )
                    .child(
                        div()
                            .id("drag-target")
                            .size(px(100.))
                            .on_mouse_down_all(|event, phase, hitbox, window, _| {
                                if phase == DispatchPhase::Bubble
                                    && event.button == MouseButton::Left
                                    && hitbox.is_hovered(window)
                                {
                                    window.capture_pointer(hitbox.id);
                                }
                            })
                            .on_mouse_move_all(move |event, _, _, _, _| {
                                if event.dragging() {
                                    recorded_moves.borrow_mut().push(event.position);
                                }
                            }),
                    ),
            )
            .into_any_element()
    });

    context.simulate_mouse_down(
        point(px(40.), px(30.)),
        MouseButton::Left,
        Default::default(),
    );
    // The window-space pointer leaves both the viewport and its clipping mask.
    // Capture still routes it to the original target; (180, 100) maps to (80, 45).
    context.simulate_mouse_move(
        point(px(180.), px(100.)),
        Some(MouseButton::Left),
        Default::default(),
    );
    let moves = moves.borrow();
    assert!(
        !moves.is_empty(),
        "captured pointer should keep receiving drag moves"
    );
    assert!(
        moves
            .iter()
            .all(|position| *position == point(px(80.), px(45.)))
    );
    context.simulate_mouse_up(
        point(px(180.), px(100.)),
        MouseButton::Left,
        Default::default(),
    );
}

#[gpui::test]
fn changed_camera_space_invalidates_cached_child_and_rebuilds_hitboxes(cx: &mut TestAppContext) {
    let renders = Rc::new(Cell::new(0));
    let clicks = Rc::new(Cell::new(0));
    let target = cx.update(|cx| {
        cx.new(|_| CachedTarget {
            renders: renders.clone(),
            clicks: clicks.clone(),
        })
    });
    let camera = cx.add_window({
        let target = target.clone();
        move |_, _| CachedCamera {
            target,
            pan_x: px(20.),
        }
    });
    let window = AnyWindowHandle::from(camera.clone());

    cx.update_window(window, |_, window, cx| window.draw(cx).clear(cx))
        .unwrap();
    let initial_renders = renders.get();
    assert!(initial_renders > 0);

    // A second draw with identical bounds and camera reuses the rendered view.
    cx.update_window(window, |_, window, cx| window.draw(cx).clear(cx))
        .unwrap();
    assert_eq!(renders.get(), initial_renders);

    let click_at = |cx: &mut TestAppContext, position| {
        cx.update_window(window, |_, window, cx| {
            window.simulate_mouse_move(position, cx);
            window.dispatch_event(
                MouseDownEvent {
                    position,
                    button: MouseButton::Left,
                    modifiers: Default::default(),
                    click_count: 1,
                    first_mouse: false,
                }
                .to_platform_input(),
                cx,
            );
            window.dispatch_event(
                MouseUpEvent {
                    position,
                    button: MouseButton::Left,
                    modifiers: Default::default(),
                    click_count: 1,
                }
                .to_platform_input(),
                cx,
            );
        })
        .unwrap();
    };

    click_at(cx, point(px(30.), px(20.)));
    assert_eq!(clicks.get(), 1);
    let renders_before_pan = renders.get();

    camera
        .update(cx, |camera, _, cx| {
            camera.pan_x = px(70.);
            cx.notify();
        })
        .unwrap();
    cx.update_window(window, |_, window, cx| window.draw(cx).clear(cx))
        .unwrap();
    assert_eq!(renders.get(), renders_before_pan + 1);

    click_at(cx, point(px(30.), px(20.)));
    assert_eq!(
        clicks.get(),
        1,
        "the cached child must leave its former hitbox behind"
    );
    click_at(cx, point(px(80.), px(20.)));
    assert_eq!(
        clicks.get(),
        2,
        "the cached child must register at the new camera offset"
    );
}

#[gpui::test]
fn input_handler_range_bounds_follow_the_element_coordinate_space(cx: &mut TestAppContext) {
    let focus = cx.update(|cx| cx.focus_handle());
    let input_bounds = Bounds::new(point(px(2.), px(3.)), size(px(8.), px(5.)));
    let focus_for_paint = focus.clone();
    let (_, context) = add_tree_window(cx, move |_, _| {
        let focus_for_paint = focus_for_paint.clone();
        div()
            .size_full()
            .child(
                div()
                    .id("ime-camera")
                    .size(px(100.))
                    .transform(
                        ElementTransform::default()
                            .scale(2.)
                            .translate(point(px(30.), px(20.))),
                    )
                    .child(
                        div()
                            .id("ime-editor")
                            .size(px(30.))
                            .track_focus(&focus_for_paint)
                            .child(canvas(|_, _, _| (), {
                                let focus = focus_for_paint.clone();
                                move |_, _, window, cx| {
                                    window.handle_input(
                                        &focus,
                                        FixedInputGeometry {
                                            bounds: input_bounds,
                                            range_bounds: None,
                                        },
                                        cx,
                                    );
                                }
                            })),
                    ),
            )
            .into_any_element()
    });
    context.update(|window, cx| {
        window.focus(&focus, cx);
        window.draw(cx).clear(cx);
    });

    let mut input_handler = context
        .update(|window, _| window.platform_window.take_input_handler())
        .expect("focused editor should register its input handler");
    let ime_bounds = input_handler
        .bounds_for_range(0..0)
        .expect("the mock input handler reports range geometry");
    assert_eq!(
        ime_bounds,
        Bounds::new(point(px(34.), px(26.)), size(px(16.), px(10.)))
    );
}

#[test]
fn rotated_child_inside_fade_safe_region_prunes_redundant_parent_clip() {
    let ancestor_mask = ContentMask {
        bounds: Bounds::new(point(px(0.), px(0.)), size(px(100.), px(100.))),
        fade_out: Edges {
            top: px(10.),
            right: px(10.),
            bottom: px(10.),
            left: px(10.),
        },
        ..Default::default()
    };
    let ancestor = CoordinateSpace::default().clipped(ancestor_mask);
    let child_transform = TransformationMatrix {
        rotation_scale: [[0.8, -0.6], [0.6, 0.8]],
        translation: [35., 30.],
    };
    let child_mask = ContentMask {
        bounds: Bounds::new(point(px(0.), px(0.)), size(px(10.), px(10.))),
        ..Default::default()
    };
    let child = ancestor.transformed(child_transform).clipped(child_mask);

    let child_clip = child.clips.as_deref().unwrap();
    assert!(
        child_clip.parent.is_none(),
        "the child support lies inside the ancestor's fully opaque interior"
    );

    let inverse = child_transform.inverse().unwrap();
    for x in (-5..=105).step_by(5) {
        for y in (-5..=105).step_by(5) {
            let point = point(px(x as f32), px(y as f32));
            let reference = ancestor.contains_window_point(point)
                && child_mask.bounds.contains(&inverse.apply(point));
            assert_eq!(
                child.contains_window_point(point),
                reference,
                "input membership changed at {point:?}"
            );
        }
    }
}

#[test]
fn active_ancestor_fade_and_uncertain_clip_edges_are_retained() {
    let child_mask = ContentMask {
        bounds: Bounds::new(point(px(0.), px(0.)), size(px(10.), px(10.))),
        ..Default::default()
    };
    let faded_ancestor = CoordinateSpace::default().clipped(ContentMask {
        bounds: Bounds::new(point(px(0.), px(0.)), size(px(100.), px(100.))),
        fade_out: Edges {
            left: px(20.),
            ..Default::default()
        },
        ..Default::default()
    });
    let shifted = TransformationMatrix {
        translation: [1., 0.],
        ..TransformationMatrix::unit()
    };
    let inside_fade = faded_ancestor.transformed(shifted).clipped(child_mask);
    assert!(
        inside_fade.clips.as_deref().unwrap().parent.is_some(),
        "a parent fade still attenuates content inside its hard bounds"
    );

    let plain_ancestor = CoordinateSpace::default().clipped(ContentMask {
        bounds: Bounds::new(point(px(0.), px(0.)), size(px(100.), px(100.))),
        ..Default::default()
    });
    let near_edge = TransformationMatrix {
        translation: [0.0001, 0.],
        ..TransformationMatrix::unit()
    };
    let boundary_adjacent = plain_ancestor.transformed(near_edge).clipped(child_mask);
    assert!(
        boundary_adjacent.clips.as_deref().unwrap().parent.is_some(),
        "coverage uncertainty near the ancestor edge must keep the original clip"
    );
    for x in [-1., 0., 0.0001, 5., 10., 99.999, 100.] {
        let point = point(px(x), px(5.));
        assert_eq!(
            boundary_adjacent.contains_window_point(point),
            plain_ancestor.contains_window_point(point)
                && child_mask
                    .bounds
                    .contains(&near_edge.inverse().unwrap().apply(point)),
            "boundary-adjacent input membership changed at {point:?}"
        );
    }
}

#[test]
fn deeply_nested_redundant_clips_collapse_without_changing_input_membership() {
    let root_mask = ContentMask {
        bounds: Bounds::new(point(px(0.), px(0.)), size(px(1000.), px(1000.))),
        ..Default::default()
    };
    let mut space = CoordinateSpace::default().clipped(root_mask);
    let mut reference_clips = vec![(TransformationMatrix::unit(), root_mask.bounds)];

    for depth in 1..=20 {
        let translation = TransformationMatrix {
            translation: [1., 1.],
            ..TransformationMatrix::unit()
        };
        space = space.transformed(translation);
        let extent = px(100. - depth as f32 * 2.);
        let mask = ContentMask {
            bounds: Bounds::new(point(px(0.), px(0.)), size(extent, extent)),
            ..Default::default()
        };
        reference_clips.push((space.transform.inverse().unwrap(), mask.bounds));
        space = space.clipped(mask);
    }

    let mut depth = 0;
    let mut clip = space.clips.as_deref();
    while let Some(region) = clip {
        depth += 1;
        clip = region.parent.as_deref();
    }
    assert_eq!(depth, 1, "only the most restrictive nested clip remains");

    for x in (-5..=105).step_by(5) {
        for y in (-5..=105).step_by(5) {
            let point = point(px(x as f32), px(y as f32));
            let reference = reference_clips
                .iter()
                .all(|(inverse, bounds)| bounds.contains(&inverse.apply(point)));
            assert_eq!(
                space.contains_window_point(point),
                reference,
                "deep clip input membership changed at {point:?}"
            );
        }
    }
}

#[gpui::test]
fn rotated_ime_candidate_uses_visual_line_in_editor_coordinates(cx: &mut TestAppContext) {
    let focus = cx.update(|cx| cx.focus_handle());

    // Positions 3 and 4 are on the same visual line (same local y), even
    // though rotation makes their window-space y coordinates differ.
    let range_bounds: Vec<Bounds<Pixels>> = (0..5)
        .map(|index| {
            Bounds::new(
                point(px(index as f32 * 10.), px(if index < 3 { 0. } else { 20. })),
                size(px(3.), px(10.)),
            )
        })
        .collect();
    let focus_for_paint = focus.clone();
    let camera_transform = ElementTransform::default()
        .rotate(Radians(std::f32::consts::FRAC_PI_2))
        .scale(2.)
        .translate(point(px(30.), px(20.)));
    let (_, context) = add_tree_window(cx, move |_, _| {
        let focus_for_paint = focus_for_paint.clone();
        let input_range_bounds = range_bounds.clone();
        div()
            .size_full()
            .child(
                div()
                    .id("rotated-ime-camera")
                    .size(px(100.))
                    .transform(camera_transform)
                    .child(
                        div()
                            .id("rotated-ime-editor")
                            .size(px(80.))
                            .track_focus(&focus_for_paint)
                            .child(canvas(|_, _, _| (), {
                                let focus = focus_for_paint.clone();
                                move |_, _, window, cx| {
                                    window.handle_input(
                                        &focus,
                                        FixedInputGeometry {
                                            bounds: Bounds::default(),
                                            range_bounds: Some(input_range_bounds),
                                        },
                                        cx,
                                    );
                                }
                            })),
                    ),
            )
            .into_any_element()
    });
    context.update(|window, cx| {
        window.focus(&focus, cx);
        window.draw(cx).clear(cx);
    });

    let mut input_handler = context
        .update(|window, _| window.platform_window.take_input_handler())
        .expect("focused editor should register its input handler");
    let actual = input_handler
        .ime_candidate_bounds()
        .expect("active composition should return candidate geometry");

    let camera_bounds = Bounds::new(point(px(0.), px(0.)), size(px(100.), px(100.)));
    let expected = CoordinateSpace::new(camera_transform.resolve(camera_bounds))
        .bounds_to_window(Bounds::new(point(px(30.), px(20.)), size(px(3.), px(10.))));
    assert_eq!(actual, expected);

    let coordinate_space = CoordinateSpace::new(camera_transform.resolve(camera_bounds));
    let window_point = coordinate_space.to_window(point(px(12.), px(34.)));
    assert_eq!(
        input_handler.character_index_for_point(window_point),
        Some(12)
    );
}

#[gpui::test]
fn accessibility_bounds_follow_a_styled_transform_on_the_role_owner(cx: &mut TestAppContext) {
    let (_, context) = add_tree_window(cx, |_, _| {
        div()
            .size_full()
            .child(
                div()
                    .id("accessible-camera-control")
                    .role(accesskit::Role::Button)
                    .aria_label("Transformed camera control")
                    .size(px(20.))
                    .transform(
                        ElementTransform::default()
                            .scale(2.)
                            .translate(point(px(30.), px(20.))),
                    ),
            )
            .into_any_element()
    });
    context.update(|window, cx| {
        window.set_a11y_forced(true);
        window.draw(cx).clear(cx);
    });

    let bounds = context.update(|window, _| {
        let (_, node) = window
            .a11y_tree()
            .expect("forced accessibility should build a tree")
            .nodes
            .iter()
            .find(|(_, node)| node.label() == Some("Transformed camera control"))
            .expect("role owner should remain in the accessibility tree");
        assert_eq!(node.role(), accesskit::Role::Button);
        let node_id = window
            .a11y_tree()
            .unwrap()
            .nodes
            .iter()
            .find(|(_, node)| node.label() == Some("Transformed camera control"))
            .unwrap()
            .0;
        window.a11y_node_bounds(node_id).unwrap()
    });
    assert_eq!(
        bounds,
        Bounds::new(point(px(30.), px(20.)), size(px(40.), px(40.)))
    );
}
