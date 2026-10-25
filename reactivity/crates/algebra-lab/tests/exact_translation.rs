use gpui_reactivity_algebra_lab::{Error, Forest, Translation, TranslationForest};

fn t(x: i64, y: i64) -> Translation {
    Translation::from_subpixels(x, y)
}

#[test]
fn catastrophic_float_cancellation_is_exact_and_query_history_independent_here() {
    let mut f = TranslationForest::new();
    let mut keys = Vec::new();
    for x in [i64::MAX, -i64::MAX, 1, 0] {
        keys.push(f.insert(keys.last().copied(), t(x, -x)).unwrap());
    }
    for order in [[0, 1, 2, 3], [3, 2, 1, 0], [1, 3, 0, 2], [2, 0, 3, 1]] {
        for i in order {
            f.world(keys[i]).unwrap();
        }
        assert_eq!(f.world(keys[3]).unwrap().subpixels(), (1, -1));
    }
    assert_eq!(f.reparent(keys[0], Some(keys[3])), Err(Error::Cycle));
    assert_eq!(f.world(keys[3]).unwrap().subpixels(), (1, -1));
    assert_eq!(f.parent(keys[0]).unwrap(), None);
}

#[test]
fn viewport_rebasing_preserves_one_subpixel_at_giant_virtual_offsets() {
    let mut f = TranslationForest::new();
    let root = f.insert(None, t(i64::MAX, i64::MIN)).unwrap();
    let viewport = f.insert(Some(root), t(i64::MAX, i64::MIN)).unwrap();
    let point = f.insert(Some(viewport), t(1, -1)).unwrap();
    let p = f.world(point).unwrap().subpixels();
    let v = f.world(viewport).unwrap().subpixels();
    assert_eq!(
        p.0 as f64 - v.0 as f64,
        0.0,
        "float conversion first loses the subpixel"
    );
    let relative = f.viewport_relative(point, viewport).unwrap();
    assert_eq!(relative.node(), point);
    assert_eq!(relative.origin(), viewport);
    assert_eq!(relative.subpixels(), (1, -1));
    assert_eq!(relative.to_pixels_f32(), Ok((1.0 / 256.0, -1.0 / 256.0)));
    f.set_local(point, t(4, -4)).unwrap();
    assert_eq!(
        f.viewport_relative(point, viewport)
            .unwrap()
            .to_pixels_f32(),
        Ok((1.0 / 64.0, -1.0 / 64.0))
    );
    // A relative snapshot remains the old value; it is not a live frame handle.
    assert_eq!(relative.subpixels(), (1, -1));
}

#[test]
fn narrowing_rejects_lost_subpixels_and_origins_cannot_cross_components_or_forests() {
    let mut f = TranslationForest::new();
    let root = f.insert(None, t(0, 0)).unwrap();
    let point = f.insert(Some(root), t((1 << 24) + 1, 0)).unwrap();
    assert_eq!(
        f.viewport_relative(point, root).unwrap().to_pixels_f32(),
        Err(Error::RendererRange)
    );
    f.set_local(point, t(1 << 24, 0)).unwrap();
    assert_eq!(
        f.viewport_relative(point, root).unwrap().to_pixels_f32(),
        Ok((65536.0, 0.0))
    );
    let separate = f.insert(None, t(0, 0)).unwrap();
    assert_eq!(
        f.viewport_relative(point, separate),
        Err(Error::DifferentComponent)
    );
    let foreign = TranslationForest::new().insert(None, t(0, 0)).unwrap();
    assert_eq!(f.viewport_relative(point, foreign), Err(Error::ForeignKey));
    let affine = Forest::new().insert(None, Default::default()).unwrap();
    assert_eq!(f.world(affine), Err(Error::ForeignKey));
}

#[test]
fn extreme_signed_sources_accumulate_beyond_i64_without_saturation_or_path_allocations() {
    let mut f = TranslationForest::new();
    f.reserve_nodes(100_000).unwrap();
    let root = f.insert(None, t(i64::MIN, i64::MAX)).unwrap();
    let mut leaf = root;
    for _ in 1..100_000 {
        leaf = f.insert(Some(leaf), t(i64::MIN, i64::MAX)).unwrap();
    }
    let expected = (i64::MIN as i128 * 100_000, i64::MAX as i128 * 100_000);
    assert_eq!(f.world(leaf).unwrap().subpixels(), expected);
    assert_eq!(TranslationForest::node_bytes(), 64);
    assert_eq!(f.allocated_bytes(), 6_400_000);
    for _ in 0..32 {
        f.world(root).unwrap();
        assert_eq!(f.world(leaf).unwrap().subpixels(), expected);
    }
}

struct Rng(u64);
impl Rng {
    fn bits(&mut self) -> u64 {
        self.0 ^= self.0 << 13;
        self.0 ^= self.0 >> 7;
        self.0 ^= self.0 << 17;
        self.0
    }
    fn next(&mut self, n: usize) -> usize {
        self.bits() as usize % n
    }
    fn translation(&mut self) -> Translation {
        t(self.bits() as i64, self.bits() as i64)
    }
}
fn oracle(parent: &[Option<usize>], local: &[Translation], mut i: usize) -> (i128, i128) {
    let (mut x, mut y) = (0, 0);
    loop {
        let (a, b) = local[i].subpixels();
        x += a as i128;
        y += b as i128;
        match parent[i] {
            Some(p) => i = p,
            None => return (x, y),
        }
    }
}
#[test]
fn randomized_structural_edits_and_query_permutations_match_exact_parent_sums() {
    for seed in [1, 0xdeadbeef, 0x12345678] {
        let mut rng = Rng(seed);
        let mut f = TranslationForest::new();
        let (mut keys, mut parent, mut local) = (Vec::new(), Vec::new(), Vec::new());
        for i in 0..128 {
            let p = if i == 0 { None } else { Some(rng.next(i)) };
            let v = rng.translation();
            keys.push(f.insert(p.map(|p| keys[p]), v).unwrap());
            parent.push(p);
            local.push(v);
        }
        for step in 0..3000 {
            let i = rng.next(keys.len());
            if step % 2 == 0 {
                let v = rng.translation();
                f.set_local(keys[i], v).unwrap();
                local[i] = v;
            } else {
                let p = if rng.next(8) == 0 {
                    None
                } else {
                    Some(rng.next(keys.len()))
                };
                let mut a = p;
                let mut cycle = false;
                while let Some(j) = a {
                    if i == j {
                        cycle = true;
                        break;
                    }
                    a = parent[j];
                }
                let result = f.reparent(keys[i], p.map(|j| keys[j]));
                if cycle {
                    assert_eq!(result, Err(Error::Cycle));
                } else {
                    result.unwrap();
                    parent[i] = p;
                }
            }
            let expected: Vec<_> = (0..keys.len())
                .map(|i| oracle(&parent, &local, i))
                .collect();
            for _ in 0..16 {
                let q = rng.next(keys.len());
                assert_eq!(f.world(keys[q]).unwrap().subpixels(), expected[q]);
            }
            let q = rng.next(keys.len());
            assert_eq!(f.parent(keys[q]).unwrap(), parent[q].map(|i| keys[i]));
        }
    }
}
