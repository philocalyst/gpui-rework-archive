//! Complete exact-translation vs approximate-affine LCT/eager/parentwalk traces.
//! cargo run --release -p gpui_reactivity_algebra_lab --example exact_frontier -- 12
use gpui_reactivity_algebra_lab::{Affine, Forest, Key, Translation, TranslationForest};
use std::{hint::black_box, time::Instant};
const NIL: u32 = u32::MAX;
fn local(x: i64, y: i64) -> Translation {
    Translation::from_subpixels(x, y)
}
fn affine(t: Translation) -> Affine {
    let (x, y) = t.subpixels();
    Affine::translation(x as f64 / 256.0, y as f64 / 256.0)
}
fn add(a: (i128, i128), b: (i128, i128)) -> (i128, i128) {
    (a.0 + b.0, a.1 + b.1)
}
fn lift(t: Translation) -> (i128, i128) {
    let (x, y) = t.subpixels();
    (x as i128, y as i128)
}
fn subtract(a: (i128, i128), b: (i128, i128)) -> (i128, i128) {
    (a.0 - b.0, a.1 - b.1)
}
fn narrow(p: (i128, i128)) -> (f32, f32) {
    let (x, y) = (p.0 as f32, p.1 as f32);
    assert_eq!((x as i128, y as i128), p);
    (x / 256.0, y / 256.0)
}
struct Node {
    parent: u32,
    first: u32,
    next: u32,
    prev: u32,
    local: Translation,
    world: (i128, i128),
}
struct Eager {
    nodes: Vec<Node>,
    scratch: Vec<u32>,
    visits: u64,
}
impl Eager {
    fn build(parent: &[u32], source: &[Translation]) -> Self {
        let mut s = Self {
            nodes: Vec::with_capacity(parent.len()),
            scratch: Vec::new(),
            visits: 0,
        };
        for (i, (&p, &t)) in parent.iter().zip(source).enumerate() {
            let (world, next) = if p == NIL {
                (lift(t), NIL)
            } else {
                (
                    add(s.nodes[p as usize].world, lift(t)),
                    s.nodes[p as usize].first,
                )
            };
            s.nodes.push(Node {
                parent: p,
                first: NIL,
                next,
                prev: NIL,
                local: t,
                world,
            });
            if next != NIL {
                s.nodes[next as usize].prev = i as u32;
            }
            if p != NIL {
                s.nodes[p as usize].first = i as u32;
            }
        }
        s
    }
    fn refresh(&mut self, i: usize) {
        self.scratch.clear();
        self.scratch.push(i as u32);
        while let Some(i) = self.scratch.pop() {
            let i = i as usize;
            self.visits += 1;
            let p = self.nodes[i].parent;
            self.nodes[i].world = if p == NIL {
                lift(self.nodes[i].local)
            } else {
                add(self.nodes[p as usize].world, lift(self.nodes[i].local))
            };
            let mut c = self.nodes[i].first;
            while c != NIL {
                self.scratch.push(c);
                c = self.nodes[c as usize].next;
            }
        }
    }
    fn edit(&mut self, i: usize, t: Translation) {
        self.nodes[i].local = t;
        self.refresh(i);
    }
    fn reparent(&mut self, i: usize, p: u32) {
        let mut a = p;
        while a != NIL {
            assert_ne!(a as usize, i);
            a = self.nodes[a as usize].parent;
        }
        let (old, prev, next) = (self.nodes[i].parent, self.nodes[i].prev, self.nodes[i].next);
        if prev != NIL {
            self.nodes[prev as usize].next = next;
        } else if old != NIL {
            self.nodes[old as usize].first = next;
        }
        if next != NIL {
            self.nodes[next as usize].prev = prev;
        }
        let next = if p == NIL {
            NIL
        } else {
            self.nodes[p as usize].first
        };
        self.nodes[i].parent = p;
        self.nodes[i].prev = NIL;
        self.nodes[i].next = next;
        if p != NIL {
            self.nodes[p as usize].first = i as u32;
        }
        if next != NIL {
            self.nodes[next as usize].prev = i as u32;
        }
        self.refresh(i);
    }
    fn bytes(&self) -> usize {
        self.nodes.capacity() * std::mem::size_of::<Node>() + self.scratch.capacity() * 4
    }
}
struct Walk {
    parent: Vec<u32>,
    source: Vec<Translation>,
    adds: u64,
}
impl Walk {
    fn world(&mut self, mut i: usize) -> (i128, i128) {
        let mut result = lift(self.source[i]);
        while self.parent[i] != NIL {
            i = self.parent[i] as usize;
            self.adds += 1;
            result = add(result, lift(self.source[i]));
        }
        result
    }
    fn reparent(&mut self, i: usize, p: u32) {
        let mut a = p;
        while a != NIL {
            assert_ne!(a as usize, i);
            a = self.parent[a as usize];
        }
        self.parent[i] = p;
    }
    fn bytes(&self) -> usize {
        self.parent.capacity() * 4 + self.source.capacity() * std::mem::size_of::<Translation>()
    }
}
fn query_exact(f: &mut TranslationForest, keys: &[Key], i: usize, relative: bool) {
    if relative {
        black_box(
            f.viewport_relative(keys[i], keys[0])
                .unwrap()
                .to_pixels_f32()
                .unwrap(),
        );
    } else {
        black_box(f.world(keys[i]).unwrap());
    }
}
fn query_affine(f: &mut Forest, keys: &[Key], i: usize, relative: bool) {
    let p = f.world(keys[i]).unwrap();
    if relative {
        let v = f.world(keys[0]).unwrap();
        black_box(((p.tx - v.tx) as f32, (p.ty - v.ty) as f32));
    } else {
        black_box(p);
    }
}
fn query_eager(f: &Eager, i: usize, relative: bool) {
    let p = f.nodes[i].world;
    if relative {
        black_box(narrow(subtract(p, f.nodes[0].world)));
    } else {
        black_box(p);
    }
}
fn query_walk(f: &mut Walk, i: usize, relative: bool) {
    let p = f.world(i);
    if relative {
        let v = f.world(0);
        black_box(narrow(subtract(p, v)));
    } else {
        black_box(p);
    }
}
fn validate(
    exact: &mut TranslationForest,
    ek: &[Key],
    float: &mut Forest,
    fk: &[Key],
    eager: &Eager,
    walk: &mut Walk,
    query: &[usize],
) {
    for &q in query {
        let expected = walk.world(q);
        assert_eq!(exact.world(ek[q]).unwrap().subpixels(), expected);
        assert_eq!(eager.nodes[q].world, expected);
        let f = float.world(fk[q]).unwrap();
        assert_eq!(
            (f.tx, f.ty),
            (expected.0 as f64 / 256.0, expected.1 as f64 / 256.0)
        );
    }
}
fn main() {
    let rounds = std::env::args()
        .nth(1)
        .map(|s| s.parse::<usize>().unwrap())
        .unwrap_or(12);
    assert!(rounds > 0);
    println!(
        "phase,shape,n,edit,queries,actual_queries,mode,rounds,exact_ns,affine_ns,eager_ns,walk_ns,exact_bytes,affine_bytes,eager_bytes,walk_bytes,exact_combines,affine_composes,eager_visits,walk_adds"
    );
    for n in [1000, 10_000, 100_000] {
        for shape in ["deep", "balanced", "wide"] {
            let mut parent = vec![NIL; n];
            for (i, p) in parent.iter_mut().enumerate().skip(1) {
                *p = match shape {
                    "deep" => i as u32 - 1,
                    "balanced" => (i as u32 - 1) / 2,
                    _ => 0,
                };
            }
            let source: Vec<_> = (0..n).map(|i| local((i % 3) as i64 - 1, 1)).collect();
            let mut child = vec![false; n];
            for &p in &parent {
                if p != NIL {
                    child[p as usize] = true;
                }
            }
            let leaves: Vec<_> = (0..n).filter(|&i| !child[i]).collect();
            let start = Instant::now();
            let mut exact = TranslationForest::new();
            exact.reserve_nodes(n).unwrap();
            let mut ek = Vec::with_capacity(n);
            for (&p, &t) in parent.iter().zip(&source) {
                ek.push(exact.insert((p != NIL).then(|| ek[p as usize]), t).unwrap());
            }
            let build_exact = start.elapsed().as_nanos();
            let start = Instant::now();
            let mut float = Forest::new();
            float.reserve_nodes(n).unwrap();
            let mut fk = Vec::with_capacity(n);
            for (&p, &t) in parent.iter().zip(&source) {
                fk.push(
                    float
                        .insert((p != NIL).then(|| fk[p as usize]), affine(t))
                        .unwrap(),
                );
            }
            let build_affine = start.elapsed().as_nanos();
            let start = Instant::now();
            let mut eager = Eager::build(&parent, &source);
            let build_eager = start.elapsed().as_nanos();
            let start = Instant::now();
            let mut walk = Walk {
                parent: parent.clone(),
                source: source.clone(),
                adds: 0,
            };
            let build_walk = start.elapsed().as_nanos();
            let keybytes = n * std::mem::size_of::<Key>();
            println!(
                "build,{shape},{n},none,0,0,world,1,{build_exact},{build_affine},{build_eager},{build_walk},{},{},{},{},0,0,0,0",
                exact.allocated_bytes() + keybytes,
                float.allocated_bytes() + keybytes,
                eager.bytes(),
                walk.bytes()
            );
            let leaf = *leaves.last().unwrap();
            let start = Instant::now();
            query_exact(&mut exact, &ek, leaf, false);
            let a = start.elapsed().as_nanos();
            let start = Instant::now();
            query_affine(&mut float, &fk, leaf, false);
            let b = start.elapsed().as_nanos();
            let start = Instant::now();
            query_eager(&eager, leaf, false);
            let c = start.elapsed().as_nanos();
            let start = Instant::now();
            query_walk(&mut walk, leaf, false);
            let d = start.elapsed().as_nanos();
            println!(
                "first_query,{shape},{n},none,1,1,world,1,{a},{b},{c},{d},{},{},{},{},{},{},0,{}",
                exact.allocated_bytes() + keybytes,
                float.allocated_bytes() + keybytes,
                eager.bytes(),
                walk.bytes(),
                exact.work().compositions,
                float.work().compositions,
                walk.adds
            );
            for (name, edit) in [
                ("camera", 0),
                ("branch", if shape == "deep" { n / 2 } else { 1 }),
            ] {
                for (label, budget) in [("1", 1), ("16", 16), ("1024", 1024), ("all", leaves.len())]
                {
                    let count = budget.min(leaves.len());
                    let q: Vec<_> = (0..count)
                        .map(|i| leaves[i * leaves.len() / count])
                        .collect();
                    for relative in [false, true] {
                        let mode = if relative { "viewport" } else { "world" };
                        for &i in &q {
                            query_exact(&mut exact, &ek, i, relative);
                            query_affine(&mut float, &fk, i, relative);
                        }
                        eager.edit(edit, local(0, 0));
                        exact.reset_work();
                        float.reset_work();
                        eager.visits = 0;
                        walk.adds = 0;
                        let start = Instant::now();
                        for r in 0..rounds {
                            exact
                                .set_local(ek[edit], local(r as i64 * 16, r as i64))
                                .unwrap();
                            for &i in &q {
                                query_exact(&mut exact, &ek, i, relative);
                            }
                        }
                        let a = start.elapsed().as_nanos() / rounds as u128;
                        let start = Instant::now();
                        for r in 0..rounds {
                            float
                                .set_local(fk[edit], affine(local(r as i64 * 16, r as i64)))
                                .unwrap();
                            for &i in &q {
                                query_affine(&mut float, &fk, i, relative);
                            }
                        }
                        let b = start.elapsed().as_nanos() / rounds as u128;
                        let start = Instant::now();
                        for r in 0..rounds {
                            eager.edit(edit, local(r as i64 * 16, r as i64));
                            for &i in &q {
                                query_eager(&eager, i, relative);
                            }
                        }
                        let c = start.elapsed().as_nanos() / rounds as u128;
                        let start = Instant::now();
                        for r in 0..rounds {
                            walk.source[edit] = local(r as i64 * 16, r as i64);
                            for &i in &q {
                                query_walk(&mut walk, i, relative);
                            }
                        }
                        let d = start.elapsed().as_nanos() / rounds as u128;
                        println!(
                            "edit_query,{shape},{n},{name},{label},{count},{mode},{rounds},{a},{b},{c},{d},{},{},{},{},{},{},{},{}",
                            exact.allocated_bytes() + keybytes,
                            float.allocated_bytes() + keybytes,
                            eager.bytes(),
                            walk.bytes(),
                            exact.work().compositions,
                            float.work().compositions,
                            eager.visits,
                            walk.adds
                        );
                        validate(&mut exact, &ek, &mut float, &fk, &eager, &mut walk, &q);
                    }
                }
            }
            let moved = if shape == "deep" { n / 2 } else { 1 };
            let old = parent[moved];
            let leaf = *leaves
                .iter()
                .find(|&&i| {
                    let mut a = i as u32;
                    while a != NIL {
                        if a as usize == moved {
                            return true;
                        }
                        a = parent[a as usize];
                    }
                    false
                })
                .unwrap();
            exact.reset_work();
            float.reset_work();
            eager.visits = 0;
            walk.adds = 0;
            let start = Instant::now();
            for r in 0..rounds {
                let p = if r % 2 == 0 { NIL } else { old };
                exact
                    .reparent(ek[moved], (p != NIL).then(|| ek[p as usize]))
                    .unwrap();
                query_exact(&mut exact, &ek, leaf, false);
            }
            let a = start.elapsed().as_nanos() / rounds as u128;
            let start = Instant::now();
            for r in 0..rounds {
                let p = if r % 2 == 0 { NIL } else { old };
                float
                    .reparent(fk[moved], (p != NIL).then(|| fk[p as usize]))
                    .unwrap();
                query_affine(&mut float, &fk, leaf, false);
            }
            let b = start.elapsed().as_nanos() / rounds as u128;
            let start = Instant::now();
            for r in 0..rounds {
                let p = if r % 2 == 0 { NIL } else { old };
                eager.reparent(moved, p);
                query_eager(&eager, leaf, false);
            }
            let c = start.elapsed().as_nanos() / rounds as u128;
            let start = Instant::now();
            for r in 0..rounds {
                let p = if r % 2 == 0 { NIL } else { old };
                walk.reparent(moved, p);
                query_walk(&mut walk, leaf, false);
            }
            let d = start.elapsed().as_nanos() / rounds as u128;
            println!(
                "reparent,{shape},{n},branch,1,1,world,{rounds},{a},{b},{c},{d},{},{},{},{},{},{},{},{}",
                exact.allocated_bytes() + keybytes,
                float.allocated_bytes() + keybytes,
                eager.bytes(),
                walk.bytes(),
                exact.work().compositions,
                float.work().compositions,
                eager.visits,
                walk.adds
            );
            validate(&mut exact, &ek, &mut float, &fk, &eager, &mut walk, &[leaf]);
        }
    }
}
