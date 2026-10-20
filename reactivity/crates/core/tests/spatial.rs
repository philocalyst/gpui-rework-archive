use gpui_reactivity_core::{
    Affine, CoordinateSpace, Damage, Geometry, NodeId, NodeKind, Point, Rect, SpatialTree,
    TreeError,
};

fn geometry(x: f32, y: f32) -> Geometry {
    Geometry {
        bounds: Rect::new(0.0, 0.0, 20.0, 10.0),
        transform: Affine::translation(x, y),
        clip: None,
    }
}
fn covered(damage: &Damage, p: Point) -> bool {
    damage.tiles().any(|tile| tile.contains(p))
}
fn assert_covered(damage: &Damage, bounds: Rect) {
    let bounds = bounds.intersection(Rect::new(0.0, 0.0, 512.0, 512.0));
    if bounds.is_empty() {
        return;
    }
    for y in bounds.y as u32..(bounds.y + bounds.height).ceil() as u32 {
        for x in bounds.x as u32..(bounds.x + bounds.width).ceil() as u32 {
            let p = Point {
                x: x as f32 + 0.5,
                y: y as f32 + 0.5,
            };
            if bounds.contains(p) {
                assert!(
                    covered(damage, p),
                    "missed damaged pixel {p:?} in {bounds:?}"
                );
            }
        }
    }
}

#[test]
fn nested_geometry_reparent_damage_clip_and_singular_transition() {
    let mut tree = SpatialTree::new(512, 512).unwrap();
    let a = tree.insert(None, NodeKind::Element).unwrap();
    let b = tree.insert(None, NodeKind::Native).unwrap();
    let leaf = tree.insert(Some(a), NodeKind::WebView).unwrap();
    tree.set_geometry(a, Some(geometry(10.0, 20.0))).unwrap();
    tree.set_geometry(b, Some(geometry(200.0, 200.0))).unwrap();
    tree.set_geometry(leaf, Some(geometry(5.0, 5.0))).unwrap();
    assert_eq!(tree.hit_test(Point { x: 16.0, y: 26.0 }), Some(leaf));
    let old = tree.window_bounds(leaf).unwrap().unwrap();
    tree.clear_damage();
    tree.reparent(leaf, Some(b)).unwrap();
    assert_eq!(tree.hit_test(Point { x: 16.0, y: 26.0 }), Some(a));
    assert_eq!(tree.hit_test(Point { x: 206.0, y: 206.0 }), Some(leaf));
    assert_covered(tree.damage(), old);
    assert_covered(tree.damage(), tree.window_bounds(leaf).unwrap().unwrap());
    tree.clear_damage();
    let mut clipped = geometry(200.0, 200.0);
    clipped.clip = Some(Rect::new(0.0, 0.0, 7.0, 7.0));
    tree.set_geometry(b, Some(clipped)).unwrap();
    assert_eq!(tree.hit_test(Point { x: 208.0, y: 206.0 }), None);
    assert_eq!(tree.hit_test(Point { x: 206.0, y: 206.0 }), Some(leaf));
    let old = tree.window_bounds(leaf).unwrap().unwrap();
    tree.clear_damage();
    tree.set_geometry(
        b,
        Some(Geometry {
            transform: Affine::scale(0.0, 1.0),
            ..clipped
        }),
    )
    .unwrap();
    assert_eq!(tree.hit_test(Point { x: 206.0, y: 206.0 }), None);
    assert_eq!(tree.window_bounds(leaf).unwrap(), None);
    assert_covered(tree.damage(), old);
}

#[test]
fn rotated_hit_uses_inverse_and_transformed_ancestor_clips() {
    let mut tree = SpatialTree::new(512, 512).unwrap();
    let root = tree.insert(None, NodeKind::Element).unwrap();
    let child = tree.insert(Some(root), NodeKind::Element).unwrap();
    let world =
        Affine::translation(100.0, 100.0).compose(Affine::rotation(std::f32::consts::FRAC_PI_4));
    tree.set_geometry(
        root,
        Some(Geometry {
            bounds: Rect::default(),
            transform: world,
            clip: Some(Rect::new(0.0, 0.0, 10.0, 10.0)),
        }),
    )
    .unwrap();
    tree.set_geometry(
        child,
        Some(Geometry {
            bounds: Rect::new(-10.0, -10.0, 40.0, 40.0),
            ..Geometry::default()
        }),
    )
    .unwrap();
    let inside = world.apply(Point { x: 5.0, y: 5.0 }).unwrap();
    let outside = world.apply(Point { x: 15.0, y: 5.0 }).unwrap();
    assert_eq!(tree.hit_test(inside), Some(child));
    assert_eq!(tree.hit_test(outside), None);
    // This point lies inside the rotated clip's AABB but outside its actual diamond.
    assert_eq!(tree.hit_test(Point { x: 93.1, y: 100.1 }), None);
}

#[test]
fn invalid_foreign_and_noop_mutations_do_zero_work() {
    let mut tree = SpatialTree::new(512, 512).unwrap();
    let a = tree.insert(None, NodeKind::Element).unwrap();
    let b = tree.insert(Some(a), NodeKind::Element).unwrap();
    tree.set_geometry(a, Some(geometry(1.0, 2.0))).unwrap();
    tree.clear_damage();
    let visits = tree.mutation_visits();
    let allocated = tree.allocated_bytes();
    assert!(!tree.set_geometry(a, Some(geometry(1.0, 2.0))).unwrap());
    assert!(!tree.reparent(b, Some(a)).unwrap());
    assert_eq!(tree.reparent(a, Some(b)), Err(TreeError::Cycle));
    assert_eq!(
        tree.set_geometry(a, Some(geometry(f32::NAN, 0.0))),
        Err(TreeError::InvalidGeometry)
    );
    let foreign = SpatialTree::new(1, 1)
        .unwrap()
        .insert(None, NodeKind::Element)
        .unwrap();
    assert_eq!(tree.remove(foreign), Err(TreeError::InvalidNode));
    assert_eq!(
        tree.set_geometry(foreign, None),
        Err(TreeError::InvalidNode)
    );
    for _ in 0..1000 {
        assert!(tree.damage().is_empty());
    }
    assert_eq!(tree.mutation_visits(), visits);
    assert_eq!(tree.allocated_bytes(), allocated);
}

#[test]
fn sparse_damage_is_bounded_and_covers_fractional_edges() {
    let mut damage = Damage::new(130, 65).unwrap();
    for _ in 0..100_000 {
        damage.add(Rect::new(63.9, 63.9, 0.2, 0.2));
    }
    assert_eq!(damage.tile_count(), 4);
    assert!(covered(&damage, Point { x: 64.05, y: 64.05 }));
    assert_eq!(damage.tiles().count(), 4);
    let allocated = damage.allocated_bytes();
    damage.clear();
    assert_eq!(damage.tiles().count(), 0);
    assert_eq!(damage.allocated_bytes(), allocated);
    damage.full();
    assert_eq!(damage.tile_count(), 6);
    assert_eq!(
        damage.tiles().map(|r| r.width * r.height).sum::<f32>(),
        130.0 * 65.0
    );
    assert!(Damage::new(u32::MAX, u32::MAX).is_err());
    let mut empty = Damage::new(0, 0).unwrap();
    empty.full();
    assert!(empty.is_empty());
}

#[test]
fn deep_spatial_refresh_and_removal_do_not_recurse() {
    let mut tree = SpatialTree::new(512, 512).unwrap();
    let root = tree.insert(None, NodeKind::Element).unwrap();
    let mut leaf = root;
    for _ in 1..30_000 {
        leaf = tree.insert(Some(leaf), NodeKind::Element).unwrap();
    }
    tree.set_geometry(leaf, Some(geometry(3.0, 4.0))).unwrap();
    tree.set_geometry(root, Some(geometry(10.0, 20.0))).unwrap();
    assert_eq!(
        tree.coordinate_space(leaf)
            .unwrap()
            .to_window(Point { x: 0.0, y: 0.0 }),
        Some(Point { x: 13.0, y: 24.0 })
    );
    assert_eq!(tree.geometry_count(), 2);
    assert_eq!(tree.remove(root).unwrap(), 30_000);
    assert_eq!(tree.geometry_count(), 0);
}

#[test]
fn coordinate_model_handles_reflection_shear_nonfinite_and_overflow() {
    let affine = Affine {
        a: -2.0,
        b: 0.5,
        c: 0.3,
        d: 1.5,
        tx: 21.0,
        ty: 37.0,
    };
    let space = CoordinateSpace::new(affine);
    let rect = Rect::new(-2.0, 3.0, 5.0, 8.0);
    for p in [Point { x: 0.0, y: 5.0 }, Point { x: 2.0, y: 10.0 }] {
        let window = space.to_window(p).unwrap();
        let back = space.to_local(window).unwrap();
        assert!((back.x - p.x).abs() < 1e-4 && (back.y - p.y).abs() < 1e-4);
        assert!(space.hit(rect, window));
        assert!(space.bounds(rect).unwrap().contains(window));
    }
    for matrix in [
        Affine::scale(0.0, 1.0),
        Affine::translation(f32::NAN, 0.0),
        Affine::scale(f32::INFINITY, 1.0),
    ] {
        let space = CoordinateSpace::new(matrix);
        assert!(space.bounds(rect).is_none());
        assert!(!space.hit(rect, Point::default()));
        assert!(space.to_local(Point::default()).is_none());
    }
    let huge = CoordinateSpace::new(Affine::scale(f32::MAX, 1.0));
    assert!(huge.bounds(rect).is_none());
    assert!(!huge.hit(rect, Point::default()));
}

#[test]
fn sparse_record_swap_remove_and_slot_reuse_preserve_survivors() {
    let mut tree = SpatialTree::new(512, 512).unwrap();
    let a = tree.insert(None, NodeKind::Element).unwrap();
    let b = tree.insert(None, NodeKind::Element).unwrap();
    let c = tree.insert(None, NodeKind::Element).unwrap();
    for (id, x) in [(a, 10.0), (b, 50.0), (c, 90.0)] {
        tree.set_geometry(id, Some(geometry(x, 0.0))).unwrap();
    }
    tree.remove(b).unwrap();
    assert_eq!(tree.geometry(c).unwrap(), Some(geometry(90.0, 0.0)));
    let fresh = tree.insert(None, NodeKind::NestedGpui).unwrap();
    assert_eq!(tree.geometry(fresh).unwrap(), None);
    tree.set_geometry(fresh, Some(geometry(130.0, 0.0)))
        .unwrap();
    tree.set_geometry(a, None).unwrap();
    assert_eq!(tree.geometry_count(), 2);
    assert_eq!(tree.hit_test(Point { x: 91.0, y: 1.0 }), Some(c));
    assert_eq!(tree.hit_test(Point { x: 131.0, y: 1.0 }), Some(fresh));
}

#[test]
fn deep_hit_queries_are_linear_and_rejected_clips_prune_descendants() {
    let mut tree = SpatialTree::new(128, 128).unwrap();
    let root = tree.insert(None, NodeKind::Element).unwrap();
    tree.set_geometry(root, Some(geometry(0.0, 0.0))).unwrap();
    let mut last = root;
    for _ in 1..20_000 {
        last = tree.insert(Some(last), NodeKind::Element).unwrap();
        tree.set_geometry(last, Some(geometry(0.0, 0.0))).unwrap();
    }
    let point = Point { x: 1.0, y: 1.0 };
    let query = tree.query_hit(point);
    assert_eq!(query.node, Some(last));
    assert_eq!(query.visited, 20_000);

    let mut clipped = geometry(0.0, 0.0);
    clipped.clip = Some(Rect::new(40.0, 40.0, 4.0, 4.0));
    tree.set_geometry(root, Some(clipped)).unwrap();
    let sibling = tree.insert(None, NodeKind::Element).unwrap();
    tree.set_geometry(sibling, Some(geometry(0.0, 0.0)))
        .unwrap();
    let query = tree.query_hit(point);
    assert_eq!(query.node, Some(sibling));
    assert_eq!(
        query.visited, 2,
        "skip descendants but keep following forest roots"
    );
}

#[test]
fn sub_ulp_extents_at_tile_boundaries_remain_damaged_and_hittable() {
    let mut damage = Damage::new(128, 128).unwrap();
    let point = Point { x: 64.0, y: 0.0 };
    let narrow = Rect::new(64.0, 0.0, 1e-6, 1.0);
    assert!(narrow.contains(point));
    assert!(CoordinateSpace::new(Affine::IDENTITY).hit(narrow, point));
    damage.add(narrow);
    assert_eq!(damage.tile_count(), 1);
    assert!(covered(&damage, point));

    damage.clear();
    damage.add(Rect::new(63.999_996, 0.0, 4e-6, 1.0));
    assert_eq!(damage.tile_count(), 2);
}

#[test]
fn wide_ancestor_composition_does_not_erase_recoverable_geometry() {
    let mut tree = SpatialTree::new(128, 64).unwrap();
    let root = tree.insert(None, NodeKind::Element).unwrap();
    let middle = tree.insert(Some(root), NodeKind::Element).unwrap();
    let leaf = tree.insert(Some(middle), NodeKind::Element).unwrap();
    for node in [root, middle] {
        tree.set_geometry(
            node,
            Some(Geometry {
                transform: Affine::scale(1e-30, 1.0),
                ..Geometry::default()
            }),
        )
        .unwrap();
    }
    tree.clear_damage();
    tree.set_geometry(
        leaf,
        Some(Geometry {
            bounds: Rect::new(0.0, 0.0, 1e30, 1.0),
            transform: Affine::scale(1e30, 1.0),
            clip: None,
        }),
    )
    .unwrap();
    assert!(!tree.damage().is_empty());
    assert_eq!(tree.hit_test(Point { x: 0.5, y: 0.5 }), Some(leaf));
}

struct Rng(u64);
impl Rng {
    fn next(&mut self, n: usize) -> usize {
        self.0 ^= self.0 << 13;
        self.0 ^= self.0 >> 7;
        self.0 ^= self.0 << 17;
        self.0 as usize % n
    }
}

// Independent f64 matrix oracle, rebuilt from local declarations on every query.
fn oracle_world(tree: &SpatialTree, node: NodeId) -> [f64; 6] {
    let mut chain = Vec::new();
    let mut cursor = Some(node);
    while let Some(id) = cursor {
        if let Some(g) = tree.geometry(id).unwrap() {
            chain.push(g.transform);
        }
        cursor = tree.tree().parent(id).unwrap();
    }
    let mut w = [1.0, 0.0, 0.0, 1.0, 0.0, 0.0];
    for t in chain.into_iter().rev() {
        let [a, b, c, d, x, y] = w;
        w = [
            a * t.a as f64 + c * t.b as f64,
            b * t.a as f64 + d * t.b as f64,
            a * t.c as f64 + c * t.d as f64,
            b * t.c as f64 + d * t.d as f64,
            a * t.tx as f64 + c * t.ty as f64 + x,
            b * t.tx as f64 + d * t.ty as f64 + y,
        ];
    }
    w
}

fn oracle_hit(tree: &SpatialTree, point: Point) -> Option<NodeId> {
    tree.tree()
        .preorder()
        .filter(|&id| {
            let Some(g) = tree.geometry(id).unwrap() else {
                return false;
            };
            let [a, b, c, d, x, y] = oracle_world(tree, id);
            let det = a * d - b * c;
            if det == 0.0 {
                return false;
            }
            let px = point.x as f64 - x;
            let py = point.y as f64 - y;
            let local_x = (d * px - c * py) / det;
            let local_y = (a * py - b * px) / det;
            local_x >= g.bounds.x as f64
                && local_y >= g.bounds.y as f64
                && local_x < (g.bounds.x + g.bounds.width) as f64
                && local_y < (g.bounds.y + g.bounds.height) as f64
        })
        .last()
}

#[test]
fn randomized_spatial_mutations_match_from_scratch_coordinates_and_damage() {
    let mut rng = Rng(0x9876_1234);
    let mut tree = SpatialTree::new(512, 512).unwrap();
    let mut ids = Vec::new();
    for _ in 0..80 {
        let parent = if ids.is_empty() || rng.next(4) == 0 {
            None
        } else {
            Some(ids[rng.next(ids.len())])
        };
        ids.push(tree.insert(parent, NodeKind::Element).unwrap());
    }
    for _ in 0..700 {
        let node = ids[rng.next(ids.len())];
        let affected: Vec<_> = tree.tree().subtree(node).unwrap().collect();
        let old: Vec<_> = affected
            .iter()
            .filter_map(|&id| tree.window_bounds(id).unwrap())
            .collect();
        tree.clear_damage();
        let changed = if rng.next(3) == 0 {
            let parent = if rng.next(5) == 0 {
                None
            } else {
                Some(ids[rng.next(ids.len())])
            };
            match tree.reparent(node, parent) {
                Ok(changed) => changed,
                Err(TreeError::Cycle) => false,
                Err(e) => panic!("{e:?}"),
            }
        } else {
            let g = if rng.next(5) == 0 {
                None
            } else {
                Some(Geometry {
                    bounds: Rect::new(0.0, 0.0, 8.0, 8.0),
                    transform: Affine::translation(rng.next(20) as f32, rng.next(20) as f32)
                        .compose(Affine::rotation(rng.next(16) as f32 * 0.1)),
                    clip: None,
                })
            };
            tree.set_geometry(node, g).unwrap()
        };
        if changed {
            for bounds in old {
                assert_covered(tree.damage(), bounds);
            }
            for id in affected {
                if let Some(bounds) = tree.window_bounds(id).unwrap() {
                    assert_covered(tree.damage(), bounds);
                }
            }
        } else {
            assert!(tree.damage().is_empty());
        }
        for &id in &ids {
            let w = oracle_world(&tree, id);
            let p = tree
                .coordinate_space(id)
                .unwrap()
                .to_window(Point { x: 2.0, y: 3.0 })
                .unwrap();
            assert!((p.x as f64 - (w[0] * 2.0 + w[2] * 3.0 + w[4])).abs() < 0.001);
            assert!((p.y as f64 - (w[1] * 2.0 + w[3] * 3.0 + w[5])).abs() < 0.001);
        }
        for _ in 0..8 {
            let point = Point {
                x: rng.next(256) as f32 + 0.371,
                y: rng.next(256) as f32 + 0.619,
            };
            assert_eq!(tree.hit_test(point), oracle_hit(&tree, point));
        }
    }
}

#[test]
fn unrepresentable_forward_bounds_damage_viewport_and_tiny_inverse_stays_hittable() {
    use gpui_reactivity_core::MappedBounds;
    let mut tree = SpatialTree::new(128, 128).unwrap();
    let node = tree.insert(None, NodeKind::Element).unwrap();
    let huge = Geometry {
        bounds: Rect::new(-1e38, 0.0, 2e38, 10.0),
        transform: Affine::scale(10.0, 1.0),
        clip: None,
    };
    assert_eq!(
        CoordinateSpace::new(huge.transform).mapped_bounds(huge.bounds),
        MappedBounds::Unbounded
    );
    tree.set_geometry(node, Some(huge)).unwrap();
    assert_eq!(tree.damage().tile_count(), 4);
    assert_eq!(tree.hit_test(Point { x: 64.0, y: 5.0 }), Some(node));
    tree.clear_damage();
    tree.set_geometry(node, None).unwrap();
    assert_eq!(tree.damage().tile_count(), 4);
    let tiny = Geometry {
        bounds: Rect::new(0.0, 0.0, 1e38, 10.0),
        transform: Affine::scale(1e-39, 1.0),
        clip: None,
    };
    assert!(
        tiny.transform.inverse().is_none(),
        "f32 inverse cannot represent coefficient"
    );
    let space = CoordinateSpace::new(tiny.transform);
    assert!(space.bounds(tiny.bounds).unwrap().width > 0.09);
    assert!(space.to_local(Point { x: 0.05, y: 5.0 }).is_some());
    tree.clear_damage();
    tree.set_geometry(node, Some(tiny)).unwrap();
    assert_eq!(tree.hit_test(Point { x: 0.05, y: 5.0 }), Some(node));
    assert!(covered(tree.damage(), Point { x: 0.05, y: 5.0 }));
}
