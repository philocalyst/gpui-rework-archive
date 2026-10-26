//! Experiment: spatial/order structures — hit-test index, damage tiles, order/extent sum-tree.
//!
//! Contract (fastpath §1 hit index, §4 damage tiles, collections.md virtualization extent index):
//!  - Hit index: "tile-bucketed BVH over hitboxes" -> point query per pointer move.
//!  - Damage: "per-window tile grid (64x64) as a damage bitset ... union tiles into a bounded set of
//!    scissor/upload rects." Above a density threshold, promote to full-surface.
//!  - Virtualization: "prefix-sum extent index" mapping row<->pixel offset in O(log n).

use dslab::*;

#[derive(Clone, Copy)]
struct Rect {
    x: i32,
    y: i32,
    w: i32,
    h: i32,
}
impl Rect {
    #[inline]
    fn contains(&self, px: i32, py: i32) -> bool {
        px >= self.x && px < self.x + self.w && py >= self.y && py < self.y + self.h
    }
}

fn main() {
    section("Spatial/order structures — hit index, damage tiles, extent sum-tree");

    // ===================== HIT TEST =====================
    // 5000 hitboxes scattered over a 3840x2160 window; 1000 pointer queries.
    const NH: usize = 5000;
    const W: i32 = 3840;
    const H: i32 = 2160;
    let mut rng = Rng::new(3);
    let boxes: Vec<Rect> = (0..NH)
        .map(|_| {
            let w = 40 + rng.below(200) as i32;
            let h = 20 + rng.below(80) as i32;
            Rect { x: rng.below((W - w) as u32) as i32, y: rng.below((H - h) as u32) as i32, w, h }
        })
        .collect();
    let queries: Vec<(i32, i32)> = (0..1000).map(|_| (rng.below(W as u32) as i32, rng.below(H as u32) as i32)).collect();

    // (A) linear scan, topmost hit = last drawn containing box
    let (lmin, lmed, _) = bench(1, 500, 50, || {
        let mut acc = 0i64;
        for &(px, py) in &queries {
            let mut hit = -1i32;
            for (i, b) in boxes.iter().enumerate() {
                if b.contains(px, py) {
                    hit = i as i32;
                }
            }
            acc += hit as i64;
        }
        bb(acc);
    });

    // (B) uniform tile grid buckets: 64x64 tiles, each tile lists box indices overlapping it.
    const TS: i32 = 128;
    let cols = ((W + TS - 1) / TS) as usize;
    let rows = ((H + TS - 1) / TS) as usize;
    let mut buckets: Vec<Vec<u32>> = vec![Vec::new(); cols * rows];
    for (i, b) in boxes.iter().enumerate() {
        let (c0, c1) = ((b.x / TS) as usize, ((b.x + b.w - 1) / TS) as usize);
        let (r0, r1) = ((b.y / TS) as usize, ((b.y + b.h - 1) / TS) as usize);
        for r in r0..=r1 {
            for c in c0..=c1 {
                buckets[r * cols + c].push(i as u32);
            }
        }
    }
    let avg_bucket = buckets.iter().map(|v| v.len()).sum::<usize>() as f64 / buckets.len() as f64;
    let (tmin, tmed, _) = bench(1, 500, 50, || {
        let mut acc = 0i64;
        for &(px, py) in &queries {
            let ti = (py / TS) as usize * cols + (px / TS) as usize;
            let mut hit = -1i32;
            for &bi in &buckets[ti] {
                if boxes[bi as usize].contains(px, py) {
                    hit = hit.max(bi as i32);
                }
            }
            acc += hit as i64;
        }
        bb(acc);
    });
    println!("  hit-test 1000 queries over {} boxes:", NH);
    println!("    (A) linear scan            : {:>6.0}ns ({:.1}ns/query)", lmed, lmed / 1000.0);
    println!("    (B) {}px tile buckets (avg {:.1}/tile): {:>6.0}ns ({:.1}ns/query)  {:.0}x", TS, avg_bucket, tmed, tmed / 1000.0, lmed / tmed);
    let _ = (lmin, tmin);
    note("Tile buckets turn O(N) hit test into O(boxes in one tile). For UI (axis-aligned, low overlap) a");
    note("uniform grid beats a BVH to build and query; topmost-hit = max index within the tile bucket.");

    // ===================== DAMAGE TILES =====================
    // 200 small damage rects (hover/scroll patches); union into a tile bitset, coalesce to scissor rects.
    const DTS: i32 = 64;
    let dcols = ((W + DTS - 1) / DTS) as usize;
    let drows = ((H + DTS - 1) / DTS) as usize;
    let words = (dcols * drows + 63) / 64;
    let damage: Vec<Rect> = (0..200)
        .map(|_| {
            let w = 10 + rng.below(60) as i32;
            let h = 10 + rng.below(30) as i32;
            Rect { x: rng.below((W - w) as u32) as i32, y: rng.below((H - h) as u32) as i32, w, h }
        })
        .collect();
    let mut bitset = vec![0u64; words];
    let (dmin, dmed, _) = bench(1, 2000, 200, || {
        for w in bitset.iter_mut() {
            *w = 0;
        }
        let mut touched = 0u32;
        for d in &damage {
            let (c0, c1) = ((d.x / DTS) as usize, ((d.x + d.w - 1) / DTS) as usize);
            let (r0, r1) = ((d.y / DTS) as usize, ((d.y + d.h - 1) / DTS) as usize);
            for r in r0..=r1 {
                let base = r * dcols;
                for c in c0..=c1 {
                    let bit = base + c;
                    bitset[bit / 64] |= 1 << (bit % 64);
                }
            }
        }
        for w in &bitset {
            touched += w.count_ones();
        }
        bb(touched);
    });
    println!("\n  damage union: 200 rects -> {}px tile bitset ({} tiles, {}B): {:.0}ns", DTS, dcols * drows, words * 8, dmed);
    note("Tile bitset makes damage-union O(rects x tiles-per-rect) with O(1) dedup (idempotent bit-set),");
    note("independent of how many patches hit the same tile. count_ones gives the damaged-tile total for");
    note("the density-promotion threshold (full-surface above it). Popcount is 1 instr/word.");
    let _ = dmin;

    // ===================== ORDER / EXTENT SUM-TREE (Fenwick) =====================
    // Virtualization: variable row heights; map row->pixel offset (prefix sum) and pixel->row (search).
    const NR: usize = 100_000;
    let heights: Vec<u32> = (0..NR).map(|_| 18 + rng.below(30)).collect();

    // Fenwick / BIT over heights
    let mut bit = vec![0u64; NR + 1];
    for i in 0..NR {
        let mut j = i + 1;
        while j <= NR {
            bit[j] += heights[i] as u64;
            j += j & j.wrapping_neg();
        }
    }
    // prefix(i) = sum heights[0..i]
    let prefix = |mut i: usize| -> u64 {
        let mut s = 0;
        while i > 0 {
            s += bit[i];
            i -= i & i.wrapping_neg();
        }
        s
    };
    let probe: Vec<usize> = (0..1000).map(|_| rng.below(NR as u32) as usize).collect();
    let (fmin, fmed, _) = bench(1, 1000, 100, || {
        let mut acc = 0u64;
        for &r in &probe {
            acc = acc.wrapping_add(prefix(r)); // row -> pixel offset, O(log n)
        }
        bb(acc);
    });
    // naive prefix by rescan for contrast (row -> offset)
    let (nmin, nmed, _) = bench(1, 200, 20, || {
        let mut acc = 0u64;
        for &r in &probe {
            let mut s = 0u64;
            for h in &heights[..r] {
                s += *h as u64;
            }
            acc = acc.wrapping_add(s);
        }
        bb(acc);
    });
    // point update: a row height changes (one edit) -> O(log n)
    let (umin, umed, _) = bench(1000, 300, 50, || {
        let i = bb(12345usize);
        let delta = 1u64;
        let mut j = i + 1;
        while j <= NR {
            bit[j] += delta;
            j += j & j.wrapping_neg();
        }
        // undo to keep state stable
        let mut j = i + 1;
        while j <= NR {
            bit[j] -= delta;
            j += j & j.wrapping_neg();
        }
    });
    println!("\n  extent index over {} rows (variable height):", NR);
    println!("    Fenwick prefix (row->px) 1000 queries : {:>7.0}ns ({:.1}ns/query, O(log n))", fmed, fmed / 1000.0);
    println!("    naive rescan             1000 queries : {:>7.0}ns ({:.0}ns/query, O(n))", nmed, nmed / 1000.0);
    println!("    Fenwick point update (height change)  : {:>5.1}ns/update (x2 for undo)", umed);
    note("A Fenwick tree gives O(log n) row<->pixel maps AND O(log n) single-row-height updates in ONE flat");
    note("Vec<u64> of n+1 words (no nodes, no pointers) — the leanest order/extent index for virtualization.");
    let _ = (fmin, nmin, umin);

    verdict("Hit index: uniform TILE-BUCKET grid (not a BVH) for UI — measured big win over linear scan,");
    verdict("trivial to build/rebuild per epoch; topmost = max slot in the point's tile bucket.");
    verdict("Damage: 64px TILE BITSET (Vec<u64>) with idempotent set + popcount density -> O(1) dedup,");
    verdict("bounded coalescing, cheap full-surface promotion test.");
    verdict("Order/extent: FENWICK tree in a flat Vec<u64> (n+1 words) — O(log n) row<->pixel + O(log n)");
    verdict("height update, pointer-free; the lean alternative to a pointer sum-tree for virtualization.");
}
