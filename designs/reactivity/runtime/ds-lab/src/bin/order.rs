//! Experiment (ROUND 2): ORDER-MAINTENANCE LABELS — identity order without physical order.
//!
//! The design needs "is A before B in paint/focus/z order?" for durable identities (Slots,
//! targets) *without* materializing a physical index — physical positions shift on every edit,
//! and scattering position-fixups is exactly the splice identity-tax measured in list.rs.
//!
//! The literature answer is order maintenance (Dietz–Sleator 1987; Bender et al. 2002 two-level
//! tags): give each element an integer LABEL such that order(A,B) = label(A) < label(B), keep
//! O(1) amortized insert-after by relabeling a small window when a gap runs out. The deployment
//! shape is exactly a slab: items in a doubly-linked list (u32 links) carrying a u64 label —
//! insert-after is O(1) splice + one label midpoint; a relabel walks a small link window.
//!
//! Candidates:
//!   (F) f64 midpoint keys  — the naive fractional index (what CRDT/list toys do): dies fast.
//!   (L) u64 labels + windowed relabel over a linked slab — practical list-labeling.
//!   (V) physical Vec::insert — the baseline that pays memmove per insert.

use dslab::*;

// ---------------------------------------------------------------- (L) linked slab + u64 labels
struct Om {
    label: Vec<u64>,
    prev: Vec<u32>,
    next: Vec<u32>,
    relabels: u64,
    relabeled_items: u64,
}
// ids 0 and 1 are head/tail sentinels
impl Om {
    fn new() -> Self {
        Om {
            label: vec![0, u64::MAX],
            prev: vec![u32::MAX, 0],
            next: vec![1, u32::MAX],
            relabels: 0,
            relabeled_items: 0,
        }
    }
    /// O(1) amortized: insert a new item right after `a`; returns its id.
    fn insert_after(&mut self, a: u32) -> u32 {
        let b = self.next[a as usize];
        let la = self.label[a as usize];
        let lb = self.label[b as usize];
        if lb - la >= 2 {
            let id = self.label.len() as u32;
            self.label.push(la + (lb - la) / 2);
            self.prev.push(a);
            self.next.push(b);
            self.next[a as usize] = id;
            self.prev[b as usize] = id;
            return id;
        }
        self.relabel_around(a);
        self.insert_after(a) // gap now guaranteed
    }
    fn relabel_around(&mut self, a: u32) {
        self.relabels += 1;
        // grow a window [lo, hi] of list-neighbors around `a` until its label span has
        // quadratic headroom over its count, then spread the labels evenly.
        let mut lo = a;
        let mut hi = self.next[a as usize];
        let mut count = 2usize;
        loop {
            // (sentinels have labels 0 / u64::MAX and are never moved)
            let span = self.label[hi as usize] - self.label[lo as usize];
            let interior = count - 2; // items strictly between lo and hi... we move [lo..hi] EXCLUSIVE
            let need = ((interior + 1) as u128) * ((interior + 1) as u128);
            if span as u128 >= need.max(16) {
                // redistribute the `interior` items strictly between lo and hi
                let base = self.label[lo as usize];
                let step = (span / (interior as u64 + 1)).max(1);
                let mut cur = self.next[lo as usize];
                let mut k = 1u64;
                while cur != hi {
                    self.label[cur as usize] = base + step * k;
                    k += 1;
                    cur = self.next[cur as usize];
                }
                self.relabeled_items += interior as u64;
                return;
            }
            // widen: alternate extending left and right where possible
            let can_left = self.prev[lo as usize] != u32::MAX;
            let can_right = self.next[hi as usize] != u32::MAX;
            if can_left && (count % 2 == 0 || !can_right) {
                lo = self.prev[lo as usize];
            } else if can_right {
                hi = self.next[hi as usize];
            } else {
                // whole list in window and still no room — impossible with u64 space at UI scale
                unreachable!("u64 label space exhausted");
            }
            count += 1;
        }
    }
    fn len(&self) -> usize {
        self.label.len() - 2
    }
}

fn main() {
    section("ORDER MAINTENANCE — u64 windowed labels vs f64 midpoints vs physical memmove");

    const INSERTS: usize = 100_000;

    // ---------------- (F) f64 midpoints die at a hotspot ----------------
    {
        let mut lo = 0.0f64;
        let hi = 1.0f64;
        let mut steps = 0;
        loop {
            let mid = lo + (hi - lo) / 2.0;
            if mid == lo || mid == hi {
                break;
            }
            lo = mid; // always insert after the previous insert: hotspot
            steps += 1;
        }
        println!("  (F) f64 midpoint keys at a hotspot: EXHAUSTED after {steps} inserts.");
        note("Fractional f64 indices are not an order-maintenance structure; they fail after ~53");
        note("sequential inserts at one point. Rejected for anything durable.");
    }

    // ---------------- (L) three insertion patterns ----------------
    let patterns: [(&str, fn(&mut Om, &mut Rng, u32) -> u32); 3] = [
        ("RANDOM insert-after (uniform)", |om, rng, _last| {
            if om.len() == 0 { 0 } else { 2 + rng.below(om.len() as u32) } // ids dense from 2
        }),
        ("HOTSPOT chain (after previous insert)", |_om, _rng, last| last),
        ("FRONT (always after head sentinel)", |_om, _rng, _last| 0),
    ];
    for (name, pick) in patterns {
        let mut om = Om::new();
        let mut rng = Rng::new(3);
        let mut last = 0u32;
        let t0 = std::time::Instant::now();
        for _ in 0..INSERTS {
            let a = pick(&mut om, &mut rng, last);
            last = om.insert_after(a);
        }
        let dt = t0.elapsed().as_nanos() as f64 / INSERTS as f64;
        println!(
            "\n  (L) u64 labels, {name}: {:.0} ns/insert amortized\n      ({} relabels, {:.2} relabeled items/insert)",
            dt,
            om.relabels,
            om.relabeled_items as f64 / INSERTS as f64
        );
    }

    // ---------------- (V) physical order via memmove ----------------
    {
        let mut v: Vec<u64> = Vec::with_capacity(INSERTS + 1);
        v.push(0);
        let t0 = std::time::Instant::now();
        for k in 0..INSERTS {
            v.insert(1, k as u64); // front insert: worst-case memmove
        }
        let dt = t0.elapsed().as_nanos() as f64 / INSERTS as f64;
        println!("\n  (V) physical Vec front-insert (memmove): {dt:.0} ns/insert at {INSERTS}");
    }

    // ---------------- order queries ----------------
    {
        let mut om = Om::new();
        let mut rng = Rng::new(9);
        let mut last = 0u32;
        for _ in 0..INSERTS {
            let a = if om.len() == 0 { 0 } else { 2 + rng.below(om.len() as u32) };
            last = om.insert_after(a);
        }
        let _ = last;
        let a: Vec<u64> = (0..1000).map(|_| om.label[2 + rng.below(INSERTS as u32) as usize]).collect();
        let b: Vec<u64> = (0..1000).map(|_| om.label[2 + rng.below(INSERTS as u32) as usize]).collect();
        let (_, qmed, _) = bench(1, 2000, 200, || {
            let mut acc = 0u64;
            for k in 0..1000 {
                acc += (a[k] < b[k]) as u64;
            }
            bb(acc);
        });
        println!("  order query label<label: {:.3} ns/query (one u64 compare)", qmed / 1000.0);
    }

    // memory: 16 B/item (u64 label + 2×u32 links) — and the links are usually already there
    println!("\n  memory: 16 B/item (label u64 + prev/next u32) — links usually exist anyway");

    println!();
    verdict("ADOPT u64 order-maintenance labels for durable order (z/focus/list order over Slots):");
    verdict("  · one-compare order queries; ns-scale amortized insert-after in every pattern;");
    verdict("  · pairs with the chunked store: chunk edits stay O(page), labels give global order");
    verdict("    without scatter-fixups. f64 fractional keys are rejected (exhaust in ~53 inserts).");
}
