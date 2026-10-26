//! Experiment: describe-frame read-sets — the per-owner set diffed each describe.
//!
//! Contract (07 §1, fastpath §5/§7):
//!  - On a starred deref or region read, the cell is recorded into the describe frame's read-set.
//!  - After describe, the new read-set is diffed against the previous one to update subscriptions
//!    (subscribe to newly-read cells, unsubscribe from no-longer-read cells) — reverse edges.
//!  - Read-sets are typically SMALL (a view reads a handful of cells) but re-diffed every re-describe,
//!    and must be allocation-free in steady state (memory.md M0).
//!
//! Candidates: (A) sorted SmallVec<u32> + merge-diff, (B) bitset over interned slots + XOR,
//! (C) epoch-stamped global array (mark this epoch; membership = last_seen==epoch), O(reads).

use dslab::*;

const INLINE: usize = 8;

// A tiny inline-or-spill vector (SmallVec-shaped) to model steady-state zero-alloc small read-sets.
enum Small {
    Inline([u32; INLINE], u8),
    Spill(Vec<u32>),
}
impl Small {
    fn new() -> Self {
        Small::Inline([0; INLINE], 0)
    }
    #[inline]
    fn push(&mut self, v: u32) {
        match self {
            Small::Inline(a, n) => {
                if (*n as usize) < INLINE {
                    a[*n as usize] = v;
                    *n += 1;
                } else {
                    let mut vec = a.to_vec();
                    vec.push(v);
                    *self = Small::Spill(vec);
                }
            }
            Small::Spill(v2) => v2.push(v),
        }
    }
    #[inline]
    fn as_slice(&self) -> &[u32] {
        match self {
            Small::Inline(a, n) => &a[..*n as usize],
            Small::Spill(v) => v,
        }
    }
    fn clear(&mut self) {
        match self {
            Small::Inline(_, n) => *n = 0,
            Small::Spill(v) => v.clear(),
        }
    }
}

// (A) sorted merge diff: returns (added, removed) by walking two sorted slices.
fn diff_sorted(old: &[u32], new: &[u32], added: &mut Vec<u32>, removed: &mut Vec<u32>) {
    added.clear();
    removed.clear();
    let (mut i, mut j) = (0, 0);
    while i < old.len() && j < new.len() {
        match old[i].cmp(&new[j]) {
            std::cmp::Ordering::Equal => {
                i += 1;
                j += 1;
            }
            std::cmp::Ordering::Less => {
                removed.push(old[i]);
                i += 1;
            }
            std::cmp::Ordering::Greater => {
                added.push(new[j]);
                j += 1;
            }
        }
    }
    removed.extend_from_slice(&old[i..]);
    added.extend_from_slice(&new[j..]);
}

// (C) epoch-stamped: mark reads with the current epoch in a shared array; the diff is implicit —
// a subscribe happens when we mark a slot whose last_seen != epoch-transition; unsubscribe is lazy
// (a producer publishing to a stale reader notices staleness). Here we measure the MARK+detect-new cost.
fn main() {
    section("Describe-frame read-sets — sorted-smallvec vs bitset vs epoch-stamped");

    size_line::<Small>("Small read-set (inline 8 x u32)");
    note("Inline capacity 8 covers the common view (reads a handful of cells) with ZERO alloc.");

    // Realistic: a view reads ~8 cells; on re-describe usually the SAME 8, occasionally +/-1.
    let old: Vec<u32> = vec![3, 17, 42, 88, 101, 256, 900, 1500];
    let mut newv = old.clone();
    // typical churn: one cell drops out, one new appears
    newv[3] = 89; // 88 -> 89 (one removed, one added), keep sorted
    newv.sort_unstable();

    let mut added = Vec::with_capacity(8);
    let mut removed = Vec::with_capacity(8);

    // (A) sorted merge diff
    let (amin, amed, _) = bench(1000, 400, 50, || {
        diff_sorted(bb(&old), bb(&newv), &mut added, &mut removed);
        bb((added.len(), removed.len()));
    });
    println!("\n  (A) sorted merge-diff (8-cell set, 1 in/1 out): {:.1}ns  (added {}, removed {})", amed, added.len(), removed.len());
    let _ = amin;

    // (B) bitset over interned slots. Slot space here: say 2048 slots -> 256-byte bitmap. Diff = XOR words.
    const SLOTS: usize = 2048;
    const WORDS: usize = SLOTS / 64;
    let mut oldbits = [0u64; WORDS];
    let mut newbits = [0u64; WORDS];
    for &s in &old {
        oldbits[s as usize / 64] |= 1 << (s % 64);
    }
    for &s in &newv {
        newbits[s as usize / 64] |= 1 << (s % 64);
    }
    let (bmin, bmed, _) = bench(1000, 400, 50, || {
        let mut changed = 0u32;
        for w in 0..WORDS {
            let x = bb(oldbits[w]) ^ bb(newbits[w]);
            changed += x.count_ones();
        }
        bb(changed);
    });
    println!("  (B) bitset XOR diff ({} slots / {}B bitmap):        {:.1}ns  (scans whole bitmap)", SLOTS, SLOTS / 8, bmed);
    let _ = bmin;

    // (C) epoch-stamped mark: mark each read this epoch; "new" = last_seen jumped a generation.
    let mut last_seen = vec![0u32; SLOTS];
    let mut epoch = 1u32;
    let (cmin, cmed, _) = bench(1000, 400, 50, || {
        epoch = epoch.wrapping_add(1);
        let mut newly = 0u32;
        for &s in bb(&newv) {
            let ls = &mut last_seen[s as usize];
            // "new this describe" detection is O(reads); actual sub/unsub still needs the prev set,
            // but the per-read MARK is a single array write + compare.
            if *ls != epoch.wrapping_sub(1) {
                newly += 1;
            }
            *ls = epoch;
        }
        bb(newly);
    });
    println!("  (C) epoch-stamped mark (O(reads)=8 writes):         {:.1}ns", cmed);
    let _ = cmin;

    note("(A) sorted diff is O(|old|+|new|) with tiny constants; on an 8-cell set it is a handful of ns");
    note("    and allocation-free (added/removed reuse scratch). It gives EXACT added/removed sets.");
    note("(B) bitset XOR scans the WHOLE slot space every diff regardless of read-set size -> loses when");
    note("    slots >> reads (the usual case: thousands of slots, ~8 reads). Wins only for dense huge sets.");
    note("(C) epoch-stamp marks in O(reads) but does NOT by itself yield the 'removed' set (needs the");
    note("    prior list too) — it is the READ-RECORDING primitive (dedup a cell read twice this frame),");
    note("    not the diff. Best combined with (A): epoch-stamp to dedup during describe, sorted-diff after.");

    verdict("Read-set = inline-8 SmallVec<u32> of interned slots kept SORTED (insert keeps order, or sort");
    verdict("the tiny set once at frame end). Diff via sorted merge -> exact added/removed, ~ns, zero-alloc.");
    verdict("Use an epoch-stamp array as the intra-frame DEDUP (a cell read twice records once). Reject the");
    verdict("bitset except for pathologically dense read-sets: it pays O(total slots), not O(reads).");
}
