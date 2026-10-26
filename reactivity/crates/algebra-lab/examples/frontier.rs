//! cargo run --release -p gpui_reactivity_algebra_lab --example frontier -- [rounds]
//! CSV goes to stdout. Timings include local edits AND all requested reads.
use gpui_reactivity_algebra_lab::{Affine, Forest, Key};
use std::{hint::black_box, time::Instant};
const NONE: usize = u32::MAX as usize;

struct EagerNode {
    parent: u32,
    first: u32,
    next: u32,
    prev: u32,
    local: Affine,
    world: Affine,
}
struct Eager {
    nodes: Vec<EagerNode>,
    scratch: Vec<usize>,
    compositions: u64,
    visits: u64,
}
impl Eager {
    fn build(parents: &[usize], locals: &[Affine]) -> Self {
        let mut e = Self {
            nodes: Vec::with_capacity(parents.len()),
            scratch: Vec::new(),
            compositions: 0,
            visits: 0,
        };
        for (i, (&parent, &local)) in parents.iter().zip(locals).enumerate() {
            let world = if parent == NONE {
                local
            } else {
                e.nodes[parent].world.compose(local).unwrap()
            };
            let next = if parent == NONE {
                NONE
            } else {
                e.nodes[parent].first as usize
            };
            e.nodes.push(EagerNode {
                parent: parent as u32,
                first: NONE as u32,
                next: next as u32,
                prev: NONE as u32,
                local,
                world,
            });
            if next != NONE {
                e.nodes[next].prev = i as u32;
            }
            if parent != NONE {
                e.nodes[parent].first = i as u32;
            }
        }
        e
    }
    fn refresh(&mut self, root: usize) {
        self.scratch.clear();
        self.scratch.push(root);
        while let Some(i) = self.scratch.pop() {
            self.visits += 1;
            let p = self.nodes[i].parent as usize;
            self.nodes[i].world = if p == NONE {
                self.nodes[i].local
            } else {
                self.compositions += 1;
                self.nodes[p].world.compose(self.nodes[i].local).unwrap()
            };
            let mut child = self.nodes[i].first as usize;
            while child != NONE {
                self.scratch.push(child);
                child = self.nodes[child].next as usize;
            }
        }
    }
    fn edit(&mut self, i: usize, t: Affine) {
        self.nodes[i].local = t;
        self.refresh(i);
    }
    fn reparent(&mut self, i: usize, p: usize) {
        // The benchmark selects root siblings; explicit check still counted.
        let mut a = p;
        while a != NONE {
            assert_ne!(a, i);
            a = self.nodes[a].parent as usize;
        }
        let (old, prev, next) = (
            self.nodes[i].parent as usize,
            self.nodes[i].prev as usize,
            self.nodes[i].next as usize,
        );
        if prev != NONE {
            self.nodes[prev].next = next as u32;
        } else if old != NONE {
            self.nodes[old].first = next as u32;
        }
        if next != NONE {
            self.nodes[next].prev = prev as u32;
        }
        let next = if p == NONE {
            NONE
        } else {
            self.nodes[p].first as usize
        };
        self.nodes[i].parent = p as u32;
        self.nodes[i].prev = NONE as u32;
        self.nodes[i].next = next as u32;
        if next != NONE {
            self.nodes[next].prev = i as u32;
        }
        if p != NONE {
            self.nodes[p].first = i as u32;
        }
        self.refresh(i);
    }
    fn bytes(&self) -> usize {
        self.nodes.capacity() * std::mem::size_of::<EagerNode>()
            + self.scratch.capacity() * std::mem::size_of::<usize>()
    }
}
struct Walk {
    parent: Vec<u32>,
    local: Vec<Affine>,
    compositions: u64,
}
impl Walk {
    fn build(parents: &[usize], locals: &[Affine]) -> Self {
        Self {
            parent: parents.iter().map(|&p| p as u32).collect(),
            local: locals.to_vec(),
            compositions: 0,
        }
    }
    fn world(&mut self, mut i: usize) -> Affine {
        let mut result = self.local[i];
        while self.parent[i] != NONE as u32 {
            i = self.parent[i] as usize;
            self.compositions += 1;
            result = self.local[i].compose(result).unwrap();
        }
        result
    }
    fn reparent(&mut self, i: usize, p: usize) {
        let mut a = p;
        while a != NONE {
            assert_ne!(a, i);
            a = self.parent[a] as usize;
        }
        self.parent[i] = p as u32;
    }
    fn bytes(&self) -> usize {
        self.parent.capacity() * std::mem::size_of::<u32>()
            + self.local.capacity() * std::mem::size_of::<Affine>()
    }
}
fn tree(shape: &str, n: usize) -> (Vec<usize>, Vec<Affine>, Vec<usize>) {
    let mut parents = vec![NONE; n];
    for (i, parent) in parents.iter_mut().enumerate().skip(1) {
        *parent = match shape {
            "deep" => i - 1,
            "balanced" => (i - 1) / 2,
            _ => 0,
        };
    }
    let local = (0..n)
        .map(|i| Affine {
            a: 1.0,
            b: 0.0,
            c: (i % 3) as f64 * 1e-6,
            d: 1.0,
            tx: 0.001,
            ty: 0.001,
        })
        .collect();
    let mut has_child = vec![false; n];
    for &p in &parents {
        if p != NONE {
            has_child[p] = true;
        }
    }
    let leaves = (0..n).filter(|&i| !has_child[i]).collect();
    (parents, local, leaves)
}
fn lct(parents: &[usize], local: &[Affine]) -> (Forest, Vec<Key>) {
    let mut f = Forest::new();
    f.reserve_nodes(parents.len()).unwrap();
    let mut keys = Vec::with_capacity(parents.len());
    for (&p, &t) in parents.iter().zip(local) {
        keys.push(f.insert((p != NONE).then(|| keys[p]), t).unwrap());
    }
    (f, keys)
}
fn queries(leaves: &[usize], budget: usize) -> Vec<usize> {
    let count = budget.min(leaves.len());
    (0..count)
        .map(|i| leaves[i * leaves.len() / count])
        .collect()
}
fn verify(f: &mut Forest, keys: &[Key], e: &Eager, w: &mut Walk, queries: &[usize]) {
    for &i in queries {
        let expected = w.world(i);
        for actual in [f.world(keys[i]).unwrap(), e.nodes[i].world] {
            for (a, b) in actual
                .coefficients()
                .into_iter()
                .zip(expected.coefficients())
            {
                assert!(
                    (a - b).abs() <= 1e-8 * (1.0 + a.abs().max(b.abs())),
                    "benchmark baseline disagreement at {i}"
                );
            }
        }
    }
}
fn transform(round: usize) -> Affine {
    Affine {
        a: 1.0,
        b: 0.0,
        c: 1e-5,
        d: 1.0,
        tx: round as f64 * 0.001,
        ty: 0.002,
    }
}
fn main() {
    let rounds = std::env::args()
        .nth(1)
        .map(|v| v.parse::<usize>().expect("positive round count"))
        .unwrap_or(12);
    assert!(rounds > 0);
    println!(
        "phase,shape,n,edit,requested_queries,actual_queries,rounds,lct_ns,eager_ns,walk_ns,lct_bytes,eager_bytes,walk_bytes,lct_composes,eager_composes,walk_composes,lct_rotations,eager_visits"
    );
    for n in [1000, 10_000, 100_000] {
        for shape in ["deep", "balanced", "wide"] {
            let (parents, local, leaves) = tree(shape, n);
            let start = Instant::now();
            let (mut f, keys) = lct(&parents, &local);
            let lct_build = start.elapsed().as_nanos();
            let start = Instant::now();
            let mut eager = Eager::build(&parents, &local);
            let eager_build = start.elapsed().as_nanos();
            let start = Instant::now();
            let mut walk = Walk::build(&parents, &local);
            let walk_build = start.elapsed().as_nanos();
            println!(
                "build,{shape},{n},none,0,0,1,{lct_build},{eager_build},{walk_build},{},{},{},0,0,0,0,0",
                f.allocated_bytes() + keys.capacity() * std::mem::size_of::<Key>(),
                eager.bytes(),
                walk.bytes()
            );
            let leaf = *leaves.last().unwrap();
            let start = Instant::now();
            black_box(f.world(keys[leaf]).unwrap());
            let a = start.elapsed().as_nanos();
            let start = Instant::now();
            black_box(eager.nodes[leaf].world);
            let b = start.elapsed().as_nanos();
            let start = Instant::now();
            black_box(walk.world(leaf));
            let c = start.elapsed().as_nanos();
            println!(
                "first_query,{shape},{n},none,1,1,1,{a},{b},{c},{},{},{},{},0,{},{},0",
                f.allocated_bytes() + keys.capacity() * std::mem::size_of::<Key>(),
                eager.bytes(),
                walk.bytes(),
                f.work().compositions,
                walk.compositions,
                f.work().rotations
            );
            for (edit_name, edit) in [
                ("camera", 0),
                ("branch", if shape == "deep" { n / 2 } else { 1 }),
            ] {
                for (label, budget) in [("1", 1), ("16", 16), ("1024", 1024), ("all", leaves.len())]
                {
                    let q = queries(&leaves, budget);
                    // Warm preferred paths and eager scratch outside measured repeated trace.
                    for &i in &q {
                        black_box(f.world(keys[i]).unwrap());
                    }
                    eager.edit(edit, transform(0));
                    f.reset_work();
                    eager.compositions = 0;
                    eager.visits = 0;
                    walk.compositions = 0;
                    let start = Instant::now();
                    for r in 0..rounds {
                        f.set_local(keys[edit], transform(r)).unwrap();
                        for &i in &q {
                            black_box(f.world(keys[i]).unwrap());
                        }
                    }
                    let a = start.elapsed().as_nanos() / rounds as u128;
                    let start = Instant::now();
                    for r in 0..rounds {
                        eager.edit(edit, transform(r));
                        for &i in &q {
                            black_box(eager.nodes[i].world);
                        }
                    }
                    let b = start.elapsed().as_nanos() / rounds as u128;
                    let start = Instant::now();
                    for r in 0..rounds {
                        walk.local[edit] = transform(r);
                        for &i in &q {
                            black_box(walk.world(i));
                        }
                    }
                    let c = start.elapsed().as_nanos() / rounds as u128;
                    println!(
                        "edit_query,{shape},{n},{edit_name},{label},{},{rounds},{a},{b},{c},{},{},{},{},{},{},{},{}",
                        q.len(),
                        f.allocated_bytes() + keys.capacity() * std::mem::size_of::<Key>(),
                        eager.bytes(),
                        walk.bytes(),
                        f.work().compositions,
                        eager.compositions,
                        walk.compositions,
                        f.work().rotations,
                        eager.visits
                    );
                    verify(&mut f, &keys, &eager, &mut walk, &q);
                }
            }
            // Move a substantial subtree for deep/balanced, one leaf for wide. Toggle
            // between its original parent and detached root. Include a queried leaf.
            let moved = if shape == "deep" { n / 2 } else { 1 };
            let original = parents[moved];
            let leaf = *leaves
                .iter()
                .find(|&&leaf| {
                    let mut cursor = leaf;
                    while cursor != NONE {
                        if cursor == moved {
                            return true;
                        }
                        cursor = parents[cursor];
                    }
                    false
                })
                .unwrap();
            f.reset_work();
            eager.compositions = 0;
            eager.visits = 0;
            walk.compositions = 0;
            let start = Instant::now();
            for r in 0..rounds {
                let p = if r % 2 == 0 { NONE } else { original };
                f.reparent(keys[moved], (p != NONE).then(|| keys[p]))
                    .unwrap();
                black_box(f.world(keys[leaf]).unwrap());
            }
            let a = start.elapsed().as_nanos() / rounds as u128;
            let start = Instant::now();
            for r in 0..rounds {
                let p = if r % 2 == 0 { NONE } else { original };
                eager.reparent(moved, p);
                black_box(eager.nodes[leaf].world);
            }
            let b = start.elapsed().as_nanos() / rounds as u128;
            let start = Instant::now();
            for r in 0..rounds {
                let p = if r % 2 == 0 { NONE } else { original };
                walk.reparent(moved, p);
                black_box(walk.world(leaf));
            }
            let c = start.elapsed().as_nanos() / rounds as u128;
            println!(
                "reparent,{shape},{n},branch,1,1,{rounds},{a},{b},{c},{},{},{},{},{},{},{},{}",
                f.allocated_bytes() + keys.capacity() * std::mem::size_of::<Key>(),
                eager.bytes(),
                walk.bytes(),
                f.work().compositions,
                eager.compositions,
                walk.compositions,
                f.work().rotations,
                eager.visits
            );
            verify(&mut f, &keys, &eager, &mut walk, &[leaf]);
        }
    }
}
