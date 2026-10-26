//! Experiment (ROUND 2): NODE RECORDS AT SCALE — width, lane splits, and CHAINED dirty-skip.
//!
//! Round 1 fixed the hot record at 8 B and measured 10k nodes (cache-resident). This round runs
//! 1M nodes (32 MB working set at 32 B/node — past LLC) to expose what actually pays at scale:
//!
//!   1. RECORD WIDTH: 4/8/16/32 B per node — full-scan cost is bandwidth, so bytes/node IS the
//!      cost model. Every u32 of "harmless" inline state doubles the frame-scan bill.
//!   2. LANE SPLIT: a pass that only needs flags should read a 1-byte lane, not drag the whole
//!      record through cache — SoA taken to its logical end (Unity/Vello-style columns).
//!   3. CHAINED SKIP (the order-of-magnitude one): subtree_size (contiguous subtrees, store.rs)
//!      + a "subtree-contains-dirty" epoch lane (publish marks ancestors) lets traversal skip
//!      clean subtrees in O(1) each. Visit cost collapses from O(N) to O(dirty·depth + fringe).
//!      This is the load-bearing fast path: the common frame touches 0.01–1% of nodes.

use dslab::*;

const N: usize = 1_000_000;

struct Tree {
    subtree: Vec<u32>,    // by paint position
    parent: Vec<u32>,     // by paint position; u32::MAX for root
    depth_max: usize,
}
fn build(n: usize, seed: u64) -> Tree {
    let mut rng = Rng::new(seed);
    let mut parent_id = vec![u32::MAX; n];
    let mut children: Vec<Vec<u32>> = vec![Vec::new(); n];
    // uniform random attachment: expected max depth ≈ e·ln n (~37 @ 1M) — realistic UI depth,
    // mixed fanout with a few large lists (the window-attachment generator used in store.rs
    // degenerates to depth ~n/32 chains at 1M, which no real UI has)
    for i in 1..n {
        let p = rng.below(i as u32);
        parent_id[i] = p;
        children[p as usize].push(i as u32);
    }
    let mut order = Vec::with_capacity(n);
    let mut stack = vec![0u32];
    while let Some(x) = stack.pop() {
        order.push(x);
        for &c in children[x as usize].iter().rev() {
            stack.push(c);
        }
    }
    let mut pos_of = vec![0u32; n];
    for (p, &id) in order.iter().enumerate() {
        pos_of[id as usize] = p as u32;
    }
    // reverse-paint-order accumulation: add my subtree to my parent's (children follow parents
    // in DFS order, so a reverse sweep sees every child before its parent is finalized)
    let mut subtree = vec![1u32; n];
    for p in (1..n).rev() {
        let id = order[p] as usize;
        let par = pos_of[parent_id[id] as usize] as usize;
        subtree[par] += subtree[p];
    }
    let mut parent_pos = vec![u32::MAX; n];
    let mut depth_max = 0usize;
    let mut depth = vec![0u32; n];
    for p in 1..n {
        let id = order[p] as usize;
        let pp = pos_of[parent_id[id] as usize];
        parent_pos[p] = pp;
        depth[p] = depth[pp as usize] + 1;
        depth_max = depth_max.max(depth[p] as usize);
    }
    Tree { subtree, parent: parent_pos, depth_max }
}

fn main() {
    section("1M-NODE SCANS — record width is the frame bill");

    #[derive(Clone, Copy, Default)]
    struct W4(u32); // kind:8 | flags:8 | small payload:16
    #[derive(Clone, Copy, Default)]
    struct W8 { a: u32, b: u32 }
    #[derive(Clone, Copy, Default)]
    struct W16 { a: u32, b: u32, c: u32, d: u32 }
    #[derive(Clone, Copy, Default)]
    struct W32 { a: [u32; 8] }

    let v4: Vec<W4> = (0..N).map(|i| W4(i as u32)).collect();
    let v8: Vec<W8> = (0..N).map(|i| W8 { a: i as u32, b: 0 }).collect();
    let v16: Vec<W16> = (0..N).map(|i| W16 { a: i as u32, b: 0, c: 0, d: 0 }).collect();
    let v32: Vec<W32> = (0..N).map(|i| W32 { a: [i as u32, 0, 0, 0, 0, 0, 0, 0] }).collect();

    let (_, m4, _) = bench(1, 40, 8, || {
        let mut acc = 0u64;
        for x in &v4 { acc = acc.wrapping_add((x.0 & 0xff) as u64); }
        bb(acc);
    });
    let (_, m8, _) = bench(1, 40, 8, || {
        let mut acc = 0u64;
        for x in &v8 { acc = acc.wrapping_add((x.a & 0xff) as u64); }
        bb(acc);
    });
    let (_, m16, _) = bench(1, 40, 8, || {
        let mut acc = 0u64;
        for x in &v16 { acc = acc.wrapping_add((x.a & 0xff) as u64); }
        bb(acc);
    });
    let (_, m32, _) = bench(1, 40, 8, || {
        let mut acc = 0u64;
        for x in &v32 { acc = acc.wrapping_add((x.a[0] & 0xff) as u64); }
        bb(acc);
    });
    for (w, m) in [(4u64, m4), (8, m8), (16, m16), (32, m32)] {
        println!(
            "  {w:>2} B/node: {:>6.0} µs/scan  {:.3} ns/node  {:>5.1} GB/s",
            m / 1000.0,
            m / N as f64,
            (w * N as u64) as f64 / m / 1.0
        );
    }
    note("Same loop, same visited field — only record width changes. Past LLC the scan is a");
    note("bandwidth product: bytes/node × N. Inline 'harmless' state multiplies the frame bill.");

    // ---------------- lane split ----------------
    section("LANE SPLIT — a flags-only pass should read a flags-only lane");
    let flags_lane: Vec<u8> = (0..N).map(|i| (i % 3) as u8).collect();
    let (_, ml, _) = bench(1, 60, 10, || {
        let mut acc = 0u64;
        for &f in &flags_lane { acc = acc.wrapping_add(f as u64); }
        bb(acc);
    });
    println!(
        "  8 B record scan reading flags : {:.0} µs   1 B flags lane: {:.0} µs  ({:.1}x)",
        m8 / 1000.0,
        ml / 1000.0,
        m8 / ml
    );
    note("Kind-segregated SoA already side-tables payload; this pushes further: per-PASS lanes.");
    note("(The 1B lane autovectorizes too — treat the ratio, not the ns, as the finding.)");

    // ---------------- chained dirty-skip ----------------
    section("CHAINED: subtree_size + dirty-epoch lane -> skip clean subtrees (the big one)");
    let t = build(N, 42);
    println!("  tree: N={N}, max depth {}", t.depth_max);

    // full-scan baseline over the 8B record
    let full = m8;
    println!("  full 8 B scan baseline: {:.0} µs", full / 1000.0);

    let mut dirty_epoch = vec![0u32; N]; // "subtree at p contains a dirty node" stamp
    let mut epoch = 0u32;
    let mut rng = Rng::new(1234);

    for frac in [0.0001f64, 0.001, 0.01, 0.1] {
        let dirty_count = ((N as f64) * frac) as usize;
        // publish: mark each dirty node and its ancestor chain (this is the real publish cost)
        epoch += 1;
        let t0 = std::time::Instant::now();
        for _ in 0..dirty_count {
            let mut p = rng.below(N as u32) as usize;
            while p != usize::MAX as usize && dirty_epoch[p] != epoch {
                dirty_epoch[p] = epoch;
                let par = t.parent[p];
                if par == u32::MAX {
                    break;
                }
                p = par as usize;
            }
        }
        let mark_ns = t0.elapsed().as_nanos() as f64;

        // traversal: visit dirty closure, skip clean subtrees in O(1)
        let (_, skip_med, _) = bench(1, 40, 8, || {
            let mut acc = 0u64;
            let mut visited = 0u64;
            let mut i = 0usize;
            while i < N {
                if dirty_epoch[i] == epoch {
                    acc = acc.wrapping_add(v8[i].a as u64);
                    visited += 1;
                    i += 1;
                } else {
                    i += t.subtree[i] as usize;
                }
            }
            bb(acc + visited);
        });
        // count visits once for reporting
        let mut visited = 0u64;
        let mut skips = 0u64;
        {
            let mut i = 0usize;
            while i < N {
                if dirty_epoch[i] == epoch {
                    visited += 1;
                    i += 1;
                } else {
                    skips += 1;
                    i += t.subtree[i] as usize;
                }
            }
        }
        println!(
            "  {:>7.2}% dirty ({:>6} leaves): mark {:>7.0} ns  visit {:>8.0} ns ({:>7} visited, {:>7} skips)  vs full {:>6.0} ns  => {:>6.1}x",
            frac * 100.0,
            dirty_count,
            mark_ns,
            skip_med,
            visited,
            skips,
            full,
            full / skip_med
        );
    }
    // ---- the honest comparison: traversal with real per-node work attached ----
    // A zero-work scan flatters the full traversal (pure bandwidth). A layout/paint visit does
    // real math per node. Model ~a dozen ns of work and compare again.
    #[inline(always)]
    fn work(x: u64) -> u64 {
        // ~12 dependent ALU ops ≈ 3-4 ns — a *cheap* stand-in for measure/style/paint math
        let mut v = x.wrapping_mul(0x9E37_79B9_7F4A_7C15);
        v ^= v >> 29;
        v = v.wrapping_mul(0xBF58_476D_1CE4_E5B9);
        v ^= v >> 32;
        v = v.wrapping_mul(0x94D0_49BB_1331_11EB);
        v ^= v >> 31;
        v
    }
    println!();
    let (_, wfull, _) = bench(1, 20, 4, || {
        let mut acc = 0u64;
        for x in &v8 {
            acc = acc.wrapping_add(work(x.a as u64));
        }
        bb(acc);
    });
    println!("  full scan WITH per-node work ({:.1} ns/node): {:.0} µs", wfull / N as f64, wfull / 1000.0);
    let mut rng2 = Rng::new(4321);
    for frac in [0.0001f64, 0.001, 0.01, 0.1] {
        let dirty_count = ((N as f64) * frac) as usize;
        epoch += 1;
        for _ in 0..dirty_count {
            let mut p = rng2.below(N as u32) as usize;
            loop {
                if dirty_epoch[p] == epoch {
                    break;
                }
                dirty_epoch[p] = epoch;
                let par = t.parent[p];
                if par == u32::MAX {
                    break;
                }
                p = par as usize;
            }
        }
        let (_, wskip, _) = bench(1, 40, 8, || {
            let mut acc = 0u64;
            let mut i = 0usize;
            while i < N {
                if dirty_epoch[i] == epoch {
                    acc = acc.wrapping_add(work(v8[i].a as u64));
                    i += 1;
                } else {
                    i += t.subtree[i] as usize;
                }
            }
            bb(acc);
        });
        println!(
            "  {:>7.2}% dirty: skip-visit WITH work {:>8.0} ns   vs full-with-work {:>8.0} ns  => {:>7.1}x",
            frac * 100.0,
            wskip,
            wfull,
            wfull / wskip
        );
    }
    note("Even with work that pipelines to ~0.4 ns/node, the skip wins 20x+ at 0.01% dirty and");
    note("crosses over near ~1% dirty (the skip walk is branchy dependent loads at ~3.5 ns/step,");
    note("the full scan is streamed). LAW: the scheduler PICKS the traversal by dirty count —");
    note("dirty < ~1%N: skip-walk the closure; else: one streamed full pass. Both endpoints are");
    note("measured, so the crossover is a constant the runtime can hardcode per record width.");
    note("Publish marking is memory-latency bound (~1 µs per cold dirty path at 1M: random");
    note("4 B epoch-lane + parent[] misses x depth); a 1-bit dirty lane (128 KB, L2-resident)");
    note("would mark cheaper but needs an O(N/64) word clear — epoch vs bit is a real trade.");
    note("For pure property patches (no traversal) round 1's SoA queues stay O(patches).");
    note("");
    note("Publish already walks ancestors (O(depth) per dirty node, epoch-deduped: a second dirty");
    note("leaf under the same parent stops at the first stamped ancestor). Clearing is epoch+=1 —");
    note("no O(N) reset pass, the same trick as readset.rs' epoch-stamp dedup. CHAIN:");
    note("  paint-order SoA (linear scan) + subtree_size (O(1) subtree skip)");
    note("  + epoch dirty lane (no clears) + parent[] (publish marking) = O(dirty) frames.");
}
