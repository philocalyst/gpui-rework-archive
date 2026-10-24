use gpui_canvas::{Affine, Canvas, ClipShape, Color, Point, Rect};

#[test]
fn identical_nested_rounded_clips_intersect_samples_instead_of_multiplying_alpha() {
    let viewport = Rect::new(0.0, 0.0, 8.0, 8.0);
    let rounded = Rect::new(0.125, 0.375, 6.5, 6.0);
    let mut reference = Canvas::new(8, 8).unwrap();
    reference.clear(Color::BLACK);
    reference
        .fill_rounded_rect(rounded, 2.0, Affine::IDENTITY, viewport, Color::WHITE)
        .unwrap();
    let mut canvas = Canvas::new(8, 8).unwrap();
    canvas.clear(Color::BLACK);
    let parent = canvas
        .create_clip(
            None,
            ClipShape::RoundedRect {
                rect: rounded,
                radius: 2.0,
            },
            Affine::IDENTITY,
        )
        .unwrap();
    let child = canvas
        .create_clip(
            Some(parent),
            ClipShape::RoundedRect {
                rect: rounded,
                radius: 2.0,
            },
            Affine::IDENTITY,
        )
        .unwrap();
    canvas
        .fill_rect(viewport, Affine::IDENTITY, child, Color::WHITE)
        .unwrap();
    assert_eq!(canvas.pixels(), reference.pixels());
    let geometry = canvas.clip_geometry().unwrap();
    let chain = geometry.chain(child).unwrap();
    let mask = chain.sample_mask(0, 1);
    assert_ne!(mask, 0);
    assert_ne!(mask, u16::MAX);
    assert!(!chain.contains(Point { x: 0.125, y: 0.375 }));
    assert!(chain.contains(Point { x: 3.0, y: 3.0 }));
}

#[test]
fn handles_reject_foreign_cleared_dropped_and_replaced_scenes() {
    use gpui_canvas::Error;
    let rect = Rect::new(0.0, 0.0, 8.0, 8.0);
    let shape = ClipShape::RoundedRect { rect, radius: 2.0 };
    let mut a = Canvas::new(8, 8).unwrap();
    let mut b = Canvas::new(8, 8).unwrap();
    let old = a.create_clip(None, shape, Affine::IDENTITY).unwrap();
    assert_eq!(
        b.fill_rect(rect, Affine::IDENTITY, old, Color::WHITE),
        Err(Error::InvalidClip)
    );
    assert_eq!(
        b.create_clip(Some(old), shape, Affine::IDENTITY),
        Err(Error::InvalidClip)
    );
    let dropped;
    {
        let mut candidate = a.stage();
        dropped = candidate
            .create_clip(None, shape, Affine::IDENTITY)
            .unwrap();
    }
    assert_eq!(
        a.fill_rect(rect, Affine::IDENTITY, dropped, Color::WHITE),
        Err(Error::InvalidClip)
    );
    a.clear(Color::BLACK);
    let reused = a.create_clip(None, shape, Affine::IDENTITY).unwrap();
    assert_ne!(old, reused);
    assert_eq!(
        a.fill_rect(rect, Affine::IDENTITY, old, Color::WHITE),
        Err(Error::InvalidClip)
    );
    let committed;
    {
        let mut candidate = a.stage();
        committed = candidate
            .create_clip(None, shape, Affine::IDENTITY)
            .unwrap();
        candidate.commit();
    }
    assert_eq!(
        a.fill_rect(rect, Affine::IDENTITY, reused, Color::WHITE),
        Err(Error::InvalidClip)
    );
    a.fill_rect(rect, Affine::IDENTITY, committed, Color::WHITE)
        .unwrap();
}

#[test]
fn depth_and_invalid_geometry_reject_before_mutating_the_prefix() {
    use gpui_canvas::{Error, MAX_CLIP_DEPTH};
    let mut canvas = Canvas::new(8, 8).unwrap();
    let shape = ClipShape::RoundedRect {
        rect: Rect::new(0.0, 0.0, 8.0, 8.0),
        radius: 2.0,
    };
    let mut parent = None;
    for _ in 0..MAX_CLIP_DEPTH {
        parent = Some(canvas.create_clip(parent, shape, Affine::IDENTITY).unwrap());
    }
    assert_eq!(
        canvas.create_clip(parent, shape, Affine::IDENTITY),
        Err(Error::ResourceLimit)
    );
    for radius in [-1.0, f32::NAN, f32::INFINITY] {
        assert_eq!(
            canvas.create_clip(
                None,
                ClipShape::RoundedRect {
                    rect: Rect::new(0.0, 0.0, 8.0, 8.0),
                    radius
                },
                Affine::IDENTITY
            ),
            Err(Error::InvalidGeometry)
        );
    }
    assert_eq!(canvas.prepared_scene().clip_nodes().count(), MAX_CLIP_DEPTH);
    let counted = allocation_counter::measure(|| {
        assert_eq!(
            canvas.create_clip(parent, shape, Affine::IDENTITY),
            Err(Error::ResourceLimit)
        );
    });
    assert_eq!(counted.count_total, 0);
}

#[test]
fn axis_rect_prefixes_lower_without_losing_continuous_geometry() {
    let mut canvas = Canvas::new(8, 8).unwrap();
    let local = Rect::new(0.125, 0.375, 6.5, 6.0);
    let transform = Affine {
        a: -1.0,
        b: -0.0,
        c: 0.0,
        d: 1.0,
        tx: 7.0,
        ty: 0.125,
    };
    let clip = canvas
        .create_clip(None, ClipShape::Rect(local), transform)
        .unwrap();
    canvas
        .fill_rect(
            Rect::new(0.0, 0.0, 8.0, 8.0),
            Affine::IDENTITY,
            clip,
            Color::WHITE,
        )
        .unwrap();
    assert!(
        canvas
            .prepared_scene()
            .groups()
            .next()
            .unwrap()
            .clip_chain()
            .is_none()
    );
    let geometry = canvas.clip_geometry().unwrap();
    let chain = geometry.chain(clip).unwrap();
    assert!(chain.contains(Point { x: 1.0, y: 1.0 }));
    for y in 0..8 {
        for x in 0..8 {
            let draw = canvas.prepared_scene().draws().next().unwrap();
            let mut expected = 0;
            for row in 0..4 {
                for column in 0..4 {
                    let p = Point {
                        x: x as f32 + (column as f32 + 0.5) * 0.25,
                        y: y as f32 + (row as f32 + 0.5) * 0.25,
                    };
                    if draw.clip.contains(p) {
                        expected |= 1 << (row * 4 + column);
                    }
                }
            }
            assert_eq!(chain.sample_mask(x, y), expected);
        }
    }
}

fn oracle_inside(rect: Rect, radius: f32, map: Affine, x: f64, y: f64) -> bool {
    let (a, b, c, d, tx, ty) = (
        f64::from(map.a),
        f64::from(map.b),
        f64::from(map.c),
        f64::from(map.d),
        f64::from(map.tx),
        f64::from(map.ty),
    );
    let det = a * d - b * c;
    let lx = (d / det) * x + (-c / det) * y + (c * ty - d * tx) / det;
    let ly = (-b / det) * x + (a / det) * y + (b * tx - a * ty) / det;
    let (left, top, width, height) = (
        f64::from(rect.x),
        f64::from(rect.y),
        f64::from(rect.width),
        f64::from(rect.height),
    );
    if lx < left || ly < top || lx >= left + width || ly >= top + height {
        return false;
    }
    let radius = f64::from(radius).min(width / 2.0).min(height / 2.0);
    let dx = (radius - (lx - left))
        .max((lx - left) - (width - radius))
        .max(0.0);
    let dy = (radius - (ly - top))
        .max((ly - top) - (height - radius))
        .max(0.0);
    dx * dx + dy * dy <= radius * radius
}
#[test]
fn every_lattice_site_matches_an_independent_oracle_at_ties_and_transformed_corners() {
    let viewport = Rect::new(0.0, 0.0, 8.0, 8.0);
    for map in [
        Affine::IDENTITY,
        Affine {
            a: -1.0,
            b: -0.0,
            c: 0.0,
            d: 1.0,
            tx: 8.0,
            ty: -0.0,
        },
        Affine {
            a: 1.0,
            b: 0.25,
            c: -0.125,
            d: 0.75,
            tx: 1.125,
            ty: 0.375,
        },
        Affine {
            a: 0.000_001,
            b: -0.0,
            c: 0.0,
            d: 1.0,
            tx: 0.125,
            ty: 0.375,
        },
    ] {
        for edge in [0.125_f32.next_down(), 0.125, 0.125_f32.next_up()] {
            for radius in [0.0, f32::from_bits(1), 0.125, 2.0, f32::MAX] {
                let outer = Rect::new(edge, 0.375, 6.5, 6.25);
                let inner = Rect::new(0.375, 0.125, 6.25, 6.5);
                let mut canvas = Canvas::new(8, 8).unwrap();
                canvas.clear(Color::BLACK);
                let parent = canvas
                    .create_clip(
                        None,
                        ClipShape::RoundedRect {
                            rect: outer,
                            radius,
                        },
                        map,
                    )
                    .unwrap();
                let child = canvas
                    .create_clip(
                        Some(parent),
                        ClipShape::RoundedRect {
                            rect: inner,
                            radius: 1.0,
                        },
                        Affine::IDENTITY,
                    )
                    .unwrap();
                canvas
                    .fill_rect(viewport, Affine::IDENTITY, child, Color::WHITE)
                    .unwrap();
                let mut expected = Canvas::new(8, 8).unwrap();
                expected.clear(Color::BLACK);
                for y in 0..8 {
                    for x in 0..8 {
                        let mut mask = 0;
                        for row in 0..4 {
                            for column in 0..4 {
                                let wx = f64::from(x) + (f64::from(column) + 0.5) * 0.25;
                                let wy = f64::from(y) + (f64::from(row) + 0.5) * 0.25;
                                if oracle_inside(outer, radius, map, wx, wy)
                                    && oracle_inside(inner, 1.0, Affine::IDENTITY, wx, wy)
                                {
                                    mask |= 1 << (row * 4 + column);
                                    expected
                                        .fill_rect(
                                            Rect::new(
                                                x as f32 + column as f32 * 0.25,
                                                y as f32 + row as f32 * 0.25,
                                                0.25,
                                                0.25,
                                            ),
                                            Affine::IDENTITY,
                                            viewport,
                                            Color::WHITE,
                                        )
                                        .unwrap();
                                }
                            }
                        }
                        assert_eq!(
                            canvas
                                .clip_geometry()
                                .unwrap()
                                .chain(child)
                                .unwrap()
                                .sample_mask(x, y),
                            mask
                        );
                    }
                }
                assert_eq!(
                    canvas.pixels(),
                    expected.pixels(),
                    "map={map:?} edge={edge:?} radius={radius}"
                );
            }
        }
    }
}

#[test]
fn node_budget_failed_draw_and_aborted_candidate_preserve_complete_scene() {
    use gpui_canvas::{Error, MAX_CLIP_NODES};
    let rect = Rect::new(0., 0., 8., 8.);
    let mut canvas = Canvas::new(8, 8).unwrap();
    canvas.clear(Color::BLACK);
    let first = canvas
        .create_clip(
            None,
            ClipShape::RoundedRect { rect, radius: 2. },
            Affine::IDENTITY,
        )
        .unwrap();
    canvas
        .fill_rect(rect, Affine::IDENTITY, first, Color::WHITE)
        .unwrap();
    let before = canvas.pixels().to_vec();
    let groups = canvas.prepared_scene().groups().count();
    for _ in 1..MAX_CLIP_NODES {
        canvas
            .create_clip(None, ClipShape::Rect(rect), Affine::IDENTITY)
            .unwrap();
    }
    let count = allocation_counter::measure(|| {
        assert_eq!(
            canvas.create_clip(None, ClipShape::Rect(rect), Affine::IDENTITY),
            Err(Error::ResourceLimit)
        );
    });
    assert_eq!(count.count_total, 0);
    assert_eq!(canvas.prepared_scene().clip_nodes().count(), MAX_CLIP_NODES);
    assert_eq!(
        canvas.fill_rect(rect, Affine::scale(0., 1.), first, Color::BLACK),
        Err(Error::InvalidGeometry)
    );
    assert_eq!(canvas.prepared_scene().groups().count(), groups);
    assert_eq!(canvas.pixels(), before);
    let abandoned;
    {
        let mut candidate = canvas.stage();
        abandoned = candidate
            .create_clip(
                None,
                ClipShape::RoundedRect { rect, radius: 3. },
                Affine::IDENTITY,
            )
            .unwrap();
        candidate
            .fill_rect(rect, Affine::IDENTITY, abandoned, Color::BLACK)
            .unwrap();
        assert_eq!(
            candidate.fill_rect(rect, Affine::scale(0., 1.), abandoned, Color::WHITE),
            Err(Error::InvalidGeometry)
        );
    }
    assert_eq!(canvas.prepared_scene().groups().count(), groups);
    assert_eq!(canvas.pixels(), before);
    assert_eq!(
        canvas.fill_rect(rect, Affine::IDENTITY, abandoned, Color::BLACK),
        Err(Error::InvalidClip)
    );
    assert!(canvas.clip_geometry().unwrap().chain(first).is_ok());
}
