use gpui_reactivity_algebra_lab::{Affine, Error, Forest, Key};

// Independent coefficient formulas; no call into the implementation's compose.
fn multiply(l: Affine, r: Affine) -> Affine {
    Affine {
        a: l.a * r.a + l.c * r.b,
        b: l.b * r.a + l.d * r.b,
        c: l.a * r.c + l.c * r.d,
        d: l.b * r.c + l.d * r.d,
        tx: l.a * r.tx + l.c * r.ty + l.tx,
        ty: l.b * r.tx + l.d * r.ty + l.ty,
    }
}
fn close(a: Affine, b: Affine) {
    for (x, y) in a.coefficients().into_iter().zip(b.coefficients()) {
        assert!(
            (x - y).abs() <= 2e-9 * (1.0 + x.abs().max(y.abs())),
            "{a:?} != {b:?}"
        );
    }
}
struct Model {
    parent: Vec<Option<usize>>,
    local: Vec<Affine>,
    keys: Vec<Key>,
}
impl Model {
    fn world(&self, mut i: usize) -> Affine {
        let mut path = Vec::new();
        loop {
            path.push(i);
            match self.parent[i] {
                Some(p) => i = p,
                None => break,
            }
        }
        path.into_iter()
            .rev()
            .fold(Affine::IDENTITY, |w, i| multiply(w, self.local[i]))
    }
    fn cycle(&self, node: usize, mut parent: Option<usize>) -> bool {
        while let Some(p) = parent {
            if p == node {
                return true;
            }
            parent = self.parent[p];
        }
        false
    }
}
struct Rng(u64);
impl Rng {
    fn next(&mut self, n: usize) -> usize {
        self.0 ^= self.0 << 13;
        self.0 ^= self.0 >> 7;
        self.0 ^= self.0 << 17;
        self.0 as usize % n
    }
    fn affine(&mut self) -> Affine {
        let mut t = Affine {
            a: 1.0,
            b: self.next(3) as f64 * 0.01,
            c: 0.0,
            d: 1.0,
            tx: self.next(17) as f64 - 8.0,
            ty: self.next(17) as f64 - 8.0,
        };
        if self.next(10) == 0 {
            t.a = 0.0;
            t.b = 0.0;
        }
        t
    }
}

#[test]
fn randomized_local_edit_cut_link_reparent_and_query_match_independent_parentwalk() {
    for seed in [1, 0x12345678, 0xfeedbabe] {
        let mut rng = Rng(seed);
        let mut f = Forest::new();
        let mut m = Model {
            parent: Vec::new(),
            local: Vec::new(),
            keys: Vec::new(),
        };
        for i in 0..128 {
            let parent = if i == 0 || rng.next(5) == 0 {
                None
            } else {
                Some(rng.next(i))
            };
            let local = rng.affine();
            m.keys
                .push(f.insert(parent.map(|p| m.keys[p]), local).unwrap());
            m.parent.push(parent);
            m.local.push(local);
        }
        for step in 0..5000 {
            let i = rng.next(m.keys.len());
            match rng.next(5) {
                0 => {
                    let t = rng.affine();
                    f.set_local(m.keys[i], t).unwrap();
                    m.local[i] = t;
                }
                1 => {
                    let parent = if rng.next(5) == 0 {
                        None
                    } else {
                        Some(rng.next(m.keys.len()))
                    };
                    let result = f.reparent(m.keys[i], parent.map(|p| m.keys[p]));
                    if m.cycle(i, parent) {
                        assert_eq!(result, Err(Error::Cycle));
                    } else {
                        result.unwrap();
                        m.parent[i] = parent;
                    }
                }
                2 => {
                    assert_eq!(f.cut(m.keys[i]).unwrap(), m.parent[i].map(|p| m.keys[p]));
                    m.parent[i] = None;
                }
                3 => {
                    let p = rng.next(m.keys.len());
                    let result = f.link(m.keys[i], m.keys[p]);
                    if m.parent[i].is_some() {
                        assert_eq!(result, Err(Error::NotRoot));
                    } else if m.cycle(i, Some(p)) {
                        assert_eq!(result, Err(Error::Cycle));
                    } else {
                        result.unwrap();
                        m.parent[i] = Some(p);
                    }
                }
                _ => close(f.world(m.keys[i]).unwrap(), m.world(i)),
            }
            for _ in 0..4 {
                let q = rng.next(m.keys.len());
                assert_eq!(
                    f.parent(m.keys[q]).unwrap(),
                    m.parent[q].map(|p| m.keys[p]),
                    "step {step}"
                );
                close(f.world(m.keys[q]).unwrap(), m.world(q));
            }
        }
        for i in 0..m.keys.len() {
            close(f.world(m.keys[i]).unwrap(), m.world(i));
        }
    }
}

#[test]
fn ordered_products_collapse_and_recover_without_matrix_inversion() {
    let mut f = Forest::new();
    let root = f.insert(None, Affine::translation(10.0, 3.0)).unwrap();
    let middle = f.insert(Some(root), Affine::scale(2.0, 4.0)).unwrap();
    let leaf = f
        .insert(Some(middle), Affine::translation(5.0, 7.0))
        .unwrap();
    close(
        f.world(leaf).unwrap(),
        Affine {
            a: 2.0,
            b: 0.0,
            c: 0.0,
            d: 4.0,
            tx: 20.0,
            ty: 31.0,
        },
    );
    f.set_local(middle, Affine::scale(0.0, 0.0)).unwrap();
    close(
        f.world(leaf).unwrap(),
        Affine {
            a: 0.0,
            b: 0.0,
            c: 0.0,
            d: 0.0,
            tx: 10.0,
            ty: 3.0,
        },
    );
    f.set_local(middle, Affine::scale(2.0, 4.0)).unwrap();
    close(
        f.world(leaf).unwrap(),
        Affine {
            a: 2.0,
            b: 0.0,
            c: 0.0,
            d: 4.0,
            tx: 20.0,
            ty: 31.0,
        },
    );
    assert_eq!(f.reparent(root, Some(leaf)), Err(Error::Cycle));
    assert_eq!(f.parent(root).unwrap(), None);
    assert_eq!(f.parent(middle).unwrap(), Some(root));
    close(
        f.world(leaf).unwrap(),
        Affine {
            a: 2.0,
            b: 0.0,
            c: 0.0,
            d: 4.0,
            tx: 20.0,
            ty: 31.0,
        },
    );
}

#[test]
fn numeric_range_is_diagnosed_instead_of_aliasing_singular_or_identity() {
    let mut f = Forest::new();
    let a = f.insert(None, Affine::scale(1e-200, 1.0)).unwrap();
    let b = f.insert(Some(a), Affine::scale(1e-200, 1.0)).unwrap();
    assert_eq!(f.world(b), Err(Error::NumericRange));
    f.set_local(b, Affine::scale(1e200, 1.0)).unwrap();
    close(f.world(b).unwrap(), Affine::IDENTITY);
    f.set_local(a, Affine::scale(1e200, 1.0)).unwrap();
    assert_eq!(f.world(b), Err(Error::NumericRange));
    let before = f.local(a).unwrap();
    assert_eq!(
        f.set_local(a, Affine::scale(f64::NAN, 1.0)),
        Err(Error::InvalidTransform)
    );
    assert_eq!(f.local(a).unwrap(), before);
    assert_eq!(
        f.insert(None, Affine::scale(f64::from_bits(1), 1.0)),
        Err(Error::InvalidTransform)
    );
}

#[test]
fn foreign_arenas_fail_before_any_represented_edge_or_value_changes() {
    let mut a = Forest::new();
    let mut b = Forest::new();
    let x = a.insert(None, Affine::translation(1.0, 2.0)).unwrap();
    let y = b.insert(None, Affine::IDENTITY).unwrap();
    assert_ne!(x, y);
    assert_eq!(a.reparent(x, Some(y)), Err(Error::ForeignKey));
    assert_eq!(a.link(x, y), Err(Error::ForeignKey));
    assert_eq!(a.cut(y), Err(Error::ForeignKey));
    assert_eq!(a.world(y), Err(Error::ForeignKey));
    assert_eq!(a.set_local(y, Affine::IDENTITY), Err(Error::ForeignKey));
    close(a.world(x).unwrap(), Affine::translation(1.0, 2.0));
    assert_eq!(a.parent(x).unwrap(), None);
}

#[test]
fn hundred_thousand_deep_first_access_and_drop_use_no_recursive_stack() {
    let mut f = Forest::new();
    let root = f.insert(None, Affine::translation(1.0, 0.0)).unwrap();
    let mut leaf = root;
    for _ in 1..100_000 {
        leaf = f.insert(Some(leaf), Affine::translation(1.0, 0.0)).unwrap();
    }
    assert_eq!(f.world(leaf).unwrap().tx, 100_000.0);
    let first = f.work();
    f.reset_work();
    for i in 0..64 {
        f.set_local(root, Affine::translation(i as f64, 0.0))
            .unwrap();
        assert_eq!(f.world(leaf).unwrap().tx, 99_999.0 + i as f64);
    }
    assert!(
        first.rotations > 10_000,
        "first cold access can be linear, and must be disclosed"
    );
    assert!(
        f.work().rotations < 1000,
        "repeated camera edits must reuse preferred path"
    );
    assert_eq!(f.reparent(root, Some(leaf)), Err(Error::Cycle));
    assert_eq!(f.parent(root).unwrap(), None);
}

/// A passing characterization of a known adoption blocker, NOT equivalence proof.
/// Query-only splay regrouping changes cancellation on unrestricted f64 inputs.
#[test]
fn cancellation_can_change_a_query_without_a_model_mutation() {
    let mut f = Forest::new();
    let mut keys = Vec::new();
    for x in [1e16, -1e16, 1.0, 0.0] {
        keys.push(
            f.insert(keys.last().copied(), Affine::translation(x, 0.0))
                .unwrap(),
        );
    }
    let before = f.world(keys[3]).unwrap().tx;
    f.world(keys[0]).unwrap();
    f.world(keys[3]).unwrap();
    f.world(keys[1]).unwrap();
    let after = f.world(keys[3]).unwrap().tx;
    assert_eq!(
        (before, after),
        (0.0, 1.0),
        "if fixed, replace this characterization with stable-output proof"
    );
}

#[test]
fn cache_range_tag_uses_no_additional_per_node_word() {
    assert_eq!(Forest::node_bytes(), 112);
    let mut f = Forest::new();
    f.reserve_nodes(1000).unwrap();
    assert_eq!(f.allocated_bytes(), 112_000);
}
