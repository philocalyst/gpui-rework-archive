//! Experiment: wire/port subscriber lists — intrusive slab vs Vec-per-cell vs CSR adjacency.
//!
//! Contract (memory.md §3, scheduler.md "Graph ordering"):
//!  - "subscriber lists are intrusive links on the retained records — no per-cell Vec, so
//!     subscribe/unsubscribe is pointer surgery, zero alloc."
//!  - "Reverse observer links carry removal metadata, so unmount is O(1) ... never scans every source."
//!  - Publish walks the subscriber set of ONE cell and marks each observer.
//!
//! The tension we test: intrusive doubly-linked lists give O(1) unsubscribe & zero alloc, but the
//! PUBLISH walk is a pointer chase with poor locality. CSR (contiguous per-cell runs, rebuilt per
//! epoch) has perfect iteration locality but O(1) incremental unsubscribe is awkward. Which wins on
//! the 1000-subscriber publish, and does churn wreck intrusive locality?

use dslab::*;

const NSUBS: usize = 1000;

// A "subscriber target": in reality a dense slab index + a dirty flag. We simulate the publish
// effect as writing a dirty epoch into a target array (the scatter that a real publish does).
fn scatter_target(dirty: &mut [u32], idx: u32, epoch: u32) {
    dirty[idx as usize] = epoch;
}

// ============================================================================
// A) Vec-per-cell. subscribe=push; unsubscribe=swap_remove w/ back-index map; publish=iter Vec.
// ============================================================================
struct VecCell {
    subs: Vec<u32>, // target indices
}
impl VecCell {
    fn new() -> Self {
        VecCell { subs: Vec::new() }
    }
    fn subscribe(&mut self, target: u32) -> usize {
        self.subs.push(target);
        self.subs.len() - 1
    }
    fn unsubscribe_swap(&mut self, pos: usize) {
        self.subs.swap_remove(pos);
    }
    #[inline]
    fn publish(&self, dirty: &mut [u32], epoch: u32) {
        for &t in &self.subs {
            scatter_target(dirty, t, epoch);
        }
    }
}

// ============================================================================
// B) Intrusive doubly-linked in a dense slab. Cell holds head. Node = {prev,next,target}.
//    subscribe = alloc node (or reuse free) + link at head, O(1). unsubscribe = unlink, O(1).
//    publish = walk next-chain (pointer chase).
// ============================================================================
const NIL: u32 = u32::MAX;
#[derive(Clone, Copy)]
struct SubNode {
    prev: u32,
    next: u32,
    target: u32,
}
struct IntrusiveArena {
    nodes: Vec<SubNode>,
    free: Vec<u32>,
}
impl IntrusiveArena {
    fn new() -> Self {
        IntrusiveArena { nodes: Vec::new(), free: Vec::new() }
    }
    fn alloc(&mut self, n: SubNode) -> u32 {
        if let Some(i) = self.free.pop() {
            self.nodes[i as usize] = n;
            i
        } else {
            self.nodes.push(n);
            (self.nodes.len() - 1) as u32
        }
    }
}
struct IntrusiveCell {
    head: u32,
}
impl IntrusiveCell {
    fn new() -> Self {
        IntrusiveCell { head: NIL }
    }
    fn subscribe(&mut self, arena: &mut IntrusiveArena, target: u32) -> u32 {
        let node = arena.alloc(SubNode { prev: NIL, next: self.head, target });
        if self.head != NIL {
            arena.nodes[self.head as usize].prev = node;
        }
        self.head = node;
        node
    }
    fn unsubscribe(&mut self, arena: &mut IntrusiveArena, node: u32) {
        let n = arena.nodes[node as usize];
        if n.prev != NIL {
            arena.nodes[n.prev as usize].next = n.next;
        } else {
            self.head = n.next;
        }
        if n.next != NIL {
            arena.nodes[n.next as usize].prev = n.prev;
        }
        arena.free.push(node);
    }
    #[inline]
    fn publish(&self, arena: &IntrusiveArena, dirty: &mut [u32], epoch: u32) {
        let mut cur = self.head;
        while cur != NIL {
            let n = arena.nodes[cur as usize];
            scatter_target(dirty, n.target, epoch);
            cur = n.next;
        }
    }
}

// ============================================================================
// C) CSR adjacency, rebuilt per publish-epoch: one contiguous targets array per cell.
//    Perfect iteration locality; "unsubscribe" is a compaction done at epoch rebuild, not incremental.
// ============================================================================
struct CsrCell {
    targets: Vec<u32>, // contiguous, rebuilt when membership changes at epoch boundary
}
impl CsrCell {
    #[inline]
    fn publish(&self, dirty: &mut [u32], epoch: u32) {
        for &t in &self.targets {
            scatter_target(dirty, t, epoch);
        }
    }
}

fn main() {
    section("Subscriber lists — intrusive slab vs Vec-per-cell vs CSR (1000-subscriber publish)");

    size_line::<SubNode>("SubNode {prev,next,target} (intrusive, 12B)");
    note("Intrusive node is 12 bytes/subscriber; a Vec<u32> is 4 bytes/subscriber + 24B cell header.");
    note("Per-cell memory: Vec cell = 24B + 4B/sub; intrusive cell = 4B (head) + 12B/sub in shared slab.");

    let dirty = vec![0u32; NSUBS + 16];

    // ---- Build fresh (in-order) versions ----
    // A: Vec
    let mut vcell = VecCell::new();
    let mut vpos = Vec::new();
    for t in 0..NSUBS as u32 {
        vpos.push(vcell.subscribe(t));
    }
    // B: intrusive (fresh)
    let mut arena = IntrusiveArena::new();
    let mut icell = IntrusiveCell::new();
    let mut inodes = Vec::new();
    for t in 0..NSUBS as u32 {
        inodes.push(icell.subscribe(&mut arena, t));
    }
    // C: CSR
    let ccell = CsrCell { targets: (0..NSUBS as u32).collect() };

    // ---- PUBLISH throughput (fresh) ----
    let mut d = dirty.clone();
    let (vmin, vmed, _) = bench(1, 2000, 200, || {
        vcell.publish(&mut d, bb(7));
    });
    let (imin, imed, _) = bench(1, 2000, 200, || {
        icell.publish(&arena, &mut d, bb(7));
    });
    let (cmin, cmed, _) = bench(1, 2000, 200, || {
        ccell.publish(&mut d, bb(7));
    });
    println!("\n  publish 1000 subs (FRESH, in-order allocation):");
    println!("    Vec-per-cell : min {:>6.0}ns  median {:>6.0}ns  ({:.2}ns/sub)", vmin, vmed, vmed / 1000.0);
    println!("    intrusive    : min {:>6.0}ns  median {:>6.0}ns  ({:.2}ns/sub)", imin, imed, imed / 1000.0);
    println!("    CSR contig   : min {:>6.0}ns  median {:>6.0}ns  ({:.2}ns/sub)", cmin, cmed, cmed / 1000.0);

    // ---- Now CHURN the intrusive list: unsubscribe half at random, re-subscribe, so the
    // free-list scatters node allocation and the next-chain no longer walks memory in order. ----
    let mut rng = Rng::new(42);
    // remove ~700 at random then re-add 700 -> node indices scattered via free list
    let mut alive: Vec<(u32, u32)> = inodes.iter().copied().zip(0..NSUBS as u32).collect(); // (node, target)
    for _ in 0..3 {
        // 3 rounds of churn
        let mut removed_targets = Vec::new();
        for _ in 0..700 {
            if alive.is_empty() {
                break;
            }
            let k = rng.below(alive.len() as u32) as usize;
            let (node, target) = alive.swap_remove(k);
            icell.unsubscribe(&mut arena, node);
            removed_targets.push(target);
        }
        for target in removed_targets {
            let node = icell.subscribe(&mut arena, target);
            alive.push((node, target));
        }
    }
    let (imin2, imed2, _) = bench(1, 2000, 200, || {
        icell.publish(&arena, &mut d, bb(9));
    });
    println!("\n  publish ~1000 subs (intrusive AFTER churn — scattered node allocation):");
    println!("    intrusive    : min {:>6.0}ns  median {:>6.0}ns  ({:.2}ns/sub)", imin2, imed2, imed2 / 1000.0);
    note("Churn scatters the next-chain across the slab -> cache misses on the walk. This is the real");
    note("intrusive cost: publish locality degrades with subscription churn.");

    // ---- CSR rebuilt from the churned set to show it recovers full locality at epoch cost ----
    let csr_rebuilt = CsrCell { targets: alive.iter().map(|&(_, t)| t).collect() };
    let (crmin, crmed, _) = bench(1, 2000, 200, || {
        csr_rebuilt.publish(&mut d, bb(9));
    });
    println!("    CSR rebuilt  : min {:>6.0}ns  median {:>6.0}ns  ({:.2}ns/sub)", crmin, crmed, crmed / 1000.0);

    // ---- UNSUBSCRIBE cost: intrusive O(1) pointer surgery vs Vec swap_remove ----
    // Rebuild fresh for a clean measurement.
    let (uimin, uimed, _) = {
        let mut arena = IntrusiveArena::new();
        let mut icell = IntrusiveCell::new();
        let nodes: Vec<u32> = (0..NSUBS as u32).map(|t| icell.subscribe(&mut arena, t)).collect();
        let mut order: Vec<u32> = nodes.clone();
        // shuffle removal order
        for i in (1..order.len()).rev() {
            let j = rng.below((i + 1) as u32) as usize;
            order.swap(i, j);
        }
        let mut live: Vec<u32> = order.clone();
        let mut oi = 0usize;
        // Each timed sample does 1000 unlink+relink pairs so we clear timer resolution.
        let (mn, md, p9) = bench(1000, 300, 50, || {
            let slot = oi % live.len();
            let node = live[slot];
            let tgt = arena.nodes[node as usize].target;
            icell.unsubscribe(&mut arena, node);
            let newn = icell.subscribe(&mut arena, tgt);
            live[slot] = newn;
            oi = oi.wrapping_add(1);
        });
        (mn, md, p9)
    };
    println!("\n  unsubscribe+resubscribe pair (intrusive O(1) pointer surgery):");
    println!("    intrusive    : min {:.1}ns  median {:.1}ns per pair", uimin, uimed);
    note("Intrusive unsubscribe is a handful of array writes, no scan, no realloc — the design's claim holds.");
    note("Vec-per-cell unsubscribe needs a back-index (swap_remove moves the tail sub, invalidating ITS pos).");

    verdict("KEEP intrusive doubly-linked in a dense slab as the DEFAULT (memory.md is right): O(1) zero-alloc");
    verdict("subscribe/unsubscribe is the property that matters for mount/unmount churn, and 12B/sub is fine.");
    verdict("REFINEMENT: for high-fanout *stable* cells (theme, a palette read by 10k rows), publish walks");
    verdict("dominate and intrusive locality degrades under churn. Rebuild those into a CSR run at epoch");
    verdict("boundary (contiguous targets) — the publish becomes a linear scan. Pick per-cell by fanout×churn.");
}
