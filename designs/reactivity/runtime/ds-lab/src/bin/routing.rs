//! Experiment: handler routing (TypeId -> fn) + closure SSO (3-word inline storage).
//!
//! Contract (07 §3 "the signature is the wiring diagram", 05 §2 first-param-is-the-address):
//!  - Handlers route by the owner/target TYPE. The router maps TypeId -> dispatch thunk.
//!  - memory.md §3 regions/closures: "region closures stored in 3-word inline storage (size_of==0
//!    for fn items and capture-free producers); oversized captures spill to a pooled box, counted."
//!
//! Candidates for TypeId dispatch: std HashMap (SipHash), FxHash-style multiply hash, sorted array
//! + binary search, and identity hash (TypeId is already a good 64/128-bit hash).

use dslab::*;
use std::any::TypeId;
use std::collections::HashMap;
use std::hash::{BuildHasher, Hasher};

// ---- Identity/multiply hashers (FxHash-shaped) over the already-random TypeId bits ----
#[derive(Default)]
struct FxHasher {
    hash: u64,
}
impl Hasher for FxHasher {
    #[inline]
    fn write(&mut self, bytes: &[u8]) {
        const SEED: u64 = 0x51_7c_c1_b7_27_22_0a_95;
        let mut h = self.hash;
        for chunk in bytes.chunks(8) {
            let mut buf = [0u8; 8];
            buf[..chunk.len()].copy_from_slice(chunk);
            h = (h.rotate_left(5) ^ u64::from_le_bytes(buf)).wrapping_mul(SEED);
        }
        self.hash = h;
    }
    #[inline]
    fn write_u64(&mut self, i: u64) {
        self.hash = (self.hash.rotate_left(5) ^ i).wrapping_mul(0x51_7c_c1_b7_27_22_0a_95);
    }
    #[inline]
    fn finish(&self) -> u64 {
        self.hash
    }
}
#[derive(Default, Clone)]
struct FxBuild;
impl BuildHasher for FxBuild {
    type Hasher = FxHasher;
    fn build_hasher(&self) -> FxHasher {
        FxHasher::default()
    }
}

type Thunk = fn(u64) -> u64;
fn h_a(x: u64) -> u64 {
    x.wrapping_add(1)
}
fn h_b(x: u64) -> u64 {
    x.wrapping_mul(3)
}

// Make N distinct types to populate a routing table.
macro_rules! mk_types { ($($t:ident),*) => { $(struct $t;)* }; }
mk_types!(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15,
          T16, T17, T18, T19, T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31);

fn all_type_ids() -> Vec<TypeId> {
    vec![
        TypeId::of::<T0>(), TypeId::of::<T1>(), TypeId::of::<T2>(), TypeId::of::<T3>(),
        TypeId::of::<T4>(), TypeId::of::<T5>(), TypeId::of::<T6>(), TypeId::of::<T7>(),
        TypeId::of::<T8>(), TypeId::of::<T9>(), TypeId::of::<T10>(), TypeId::of::<T11>(),
        TypeId::of::<T12>(), TypeId::of::<T13>(), TypeId::of::<T14>(), TypeId::of::<T15>(),
        TypeId::of::<T16>(), TypeId::of::<T17>(), TypeId::of::<T18>(), TypeId::of::<T19>(),
        TypeId::of::<T20>(), TypeId::of::<T21>(), TypeId::of::<T22>(), TypeId::of::<T23>(),
        TypeId::of::<T24>(), TypeId::of::<T25>(), TypeId::of::<T26>(), TypeId::of::<T27>(),
        TypeId::of::<T28>(), TypeId::of::<T29>(), TypeId::of::<T30>(), TypeId::of::<T31>(),
    ]
}

fn main() {
    section("Handler routing (TypeId -> fn) + closure SSO");

    println!("  size_of<TypeId> = {}", std::mem::size_of::<TypeId>());
    let ids = all_type_ids();
    let thunks: Vec<Thunk> = (0..ids.len()).map(|i| if i % 2 == 0 { h_a as Thunk } else { h_b as Thunk }).collect();

    // (A) std HashMap<TypeId, Thunk> (SipHash)
    let std_map: HashMap<TypeId, Thunk> = ids.iter().copied().zip(thunks.iter().copied()).collect();
    // (B) FxHash map
    let fx_map: HashMap<TypeId, Thunk, FxBuild> =
        ids.iter().copied().zip(thunks.iter().copied()).collect();
    // (C) sorted array + binary search
    let mut sorted: Vec<(TypeId, Thunk)> = ids.iter().copied().zip(thunks.iter().copied()).collect();
    sorted.sort_by_key(|&(t, _)| t);

    // query pattern: look up each type in a shuffled order, dispatch
    let mut rng = Rng::new(5);
    let query: Vec<TypeId> = (0..1000).map(|_| ids[rng.below(ids.len() as u32) as usize]).collect();

    let (astd, _, _) = bench(1, 1000, 100, || {
        let mut acc = 0u64;
        for &t in &query {
            let f = std_map[&bb(t)];
            acc = f(acc);
        }
        bb(acc);
    });
    let (bfx, _, _) = bench(1, 1000, 100, || {
        let mut acc = 0u64;
        for &t in &query {
            let f = fx_map[&bb(t)];
            acc = f(acc);
        }
        bb(acc);
    });
    let (csorted, _, _) = bench(1, 1000, 100, || {
        let mut acc = 0u64;
        for &t in &query {
            let i = sorted.binary_search_by_key(&bb(t), |&(k, _)| k).unwrap();
            acc = (sorted[i].1)(acc);
        }
        bb(acc);
    });

    println!("\n  1000 dispatches over a {}-type table:", ids.len());
    println!("    (A) std HashMap (SipHash)      : {:>6.0}ns ({:.2}ns/dispatch)", astd, astd / 1000.0);
    println!("    (B) FxHash HashMap             : {:>6.0}ns ({:.2}ns/dispatch)", bfx, bfx / 1000.0);
    println!("    (C) sorted array + binary srch : {:>6.0}ns ({:.2}ns/dispatch)", csorted, csorted / 1000.0);
    note("TypeId is already a 128-bit avalanched hash; SipHash re-hashing it is pure waste. FxHash (or an");
    note("identity hasher taking the low 64 bits) removes that. Sorted+bsearch is branchy (log2(32)=5 cmps)");
    note("but cache-tiny; wins for small stable tables that fit a cache line or two.");

    // ---- Closure SSO ----
    section("Closure SSO — 3-word inline storage viability");
    // A handler that is a fn item captures nothing:
    let f: fn(&mut u64) = |o| *o += 1;
    println!("  size_of<fn(&mut u64)> (fn pointer)      = {}", std::mem::size_of_val(&f));
    let capfree = || 42u64;
    println!("  size_of<[|| 42]> (capture-free closure)  = {}", std::mem::size_of_val(&capfree));
    let x = 7u64;
    let cap1 = move || x;
    println!("  size_of<[move || x]> (one u64 capture)   = {}", std::mem::size_of_val(&cap1));
    let (a, b, c) = (1u64, 2u64, 3u64);
    let cap3 = move || a + b + c;
    println!("  size_of<[move || a+b+c]> (3 u64 capture)  = {}", std::mem::size_of_val(&cap3));

    // 3-word inline storage: fits fn ptr + up to ~2 words of captures inline; else spill to a box.
    #[repr(C)]
    union Inline3 {
        words: [usize; 3],
    }
    println!("  3-word inline storage capacity           = {} bytes", std::mem::size_of::<Inline3>());
    note("A capture-free closure / fn item is size_of==0 or one pointer -> stored inline, no box, no alloc.");
    note("Captures up to 3 machine words (24B) fit the inline region; anything larger spills to a pooled");
    note("box and increments a `closure_spill` counter (memory.md §4). The common region producer (reads a");
    note("field, returns an element) is capture-free -> inline, zero-alloc.");
    assert_eq!(std::mem::size_of_val(&capfree), 0, "capture-free closure is zero-sized");

    verdict("Route by TypeId with an FxHash/identity-hash map (NOT std SipHash — it re-hashes an already-");
    verdict("avalanched id). For a small fixed per-window handler set, a sorted array + binary search is");
    verdict("cache-tiny and competitive; a compile-time perfect hash is possible when the type set is closed.");
    verdict("Closure storage: 3-word inline union (fn ptr + <=2 words captures); capture-free producers are");
    verdict("size_of==0 and inline; oversized captures spill to a counted pooled box.");
}
