//! Experiment: `List<T>` slab + THE Deref<[T]> DESIGN QUESTION.
//!
//! Contract (07 §1 `List<T>`, collections.md):
//!  - `List<T>` is `Deref<Target = [T]>` (read-only), NEVER DerefMut. Handlers get `.iter()/.len()/
//!    slice patterns` for free -> the live items must be a CONTIGUOUS `&[T]` in list order.
//!  - `Slot<T>` is stable generational identity, item-not-position, survives moves, transfers
//!    between containers. So get(slot) must be O(1) and independent of position.
//!  - collections.md identity table: insert=insert pos; remove=close the gap; move=change pos,
//!    PRESERVE identity; edit=preserve. Performance tiers: vector tier below N_vec (O(N) moves
//!    DOCUMENTED), sum-tree order/extent maintenance above it.
//!
//! THE TENSION (flagged prominently in the report):
//!   Deref<[T]> demands contiguous items in list order.  Stable slots demand a position<->slot
//!   bijection that survives moves.  Can both hold, and what does maintaining the bijection over a
//!   contiguous store actually cost per splice?  And what happens in the promoted (sum-tree) tier,
//!   where items are NOT contiguous?

use dslab::*;
use std::num::NonZeroU32;

// A realistic row payload: 32 bytes.
#[derive(Clone, Copy)]
struct Row {
    id: u64,
    a: u64,
    b: u64,
    c: u32,
    d: u32,
}
impl Row {
    fn new(i: u64) -> Self {
        Row { id: i, a: i * 2, b: i * 3, c: i as u32, d: (i as u32).wrapping_mul(7) }
    }
}

const NIL: u32 = u32::MAX;

// ============================================================================
// (V) Plain Vec<Row> — no identity. The Deref<[T]> target, but no stable slots.
//     insert/remove is a pure memmove. This is the *floor* cost.
// ============================================================================
// (uses Vec<Row> directly)

// ============================================================================
// (S) Contiguous store + slot directory. THE PROPOSED List repr for the vector tier:
//     - `items: Vec<Row>`            -> contiguous, list order  => Deref<[T]> is `&items` (honest!)
//     - `pos_to_slot: Vec<u32>`      -> parallel to items: which slot owns each position
//     - `slots: Vec<SlotEntry>`      -> generational directory (tombstoned/reused); pos=NIL if detached
//     get(slot) = validate gen, read slots[i].pos, items[pos]  -> O(1)
//     splice    = memmove items + memmove pos_to_slot + fixup slots[..].pos for shifted range (O(k))
// ============================================================================
#[derive(Clone, Copy)]
struct SlotEntry {
    gen: u32,
    pos: u32, // index into items, or NIL if taken/detached
}
struct ListS {
    items: Vec<Row>,
    pos_to_slot: Vec<u32>,
    slots: Vec<SlotEntry>,
    free: Vec<u32>,
}
#[derive(Clone, Copy, PartialEq)]
struct Slot {
    idx: u32,
    gen: NonZeroU32,
}
impl ListS {
    fn with_capacity(n: usize) -> Self {
        ListS {
            items: Vec::with_capacity(n),
            pos_to_slot: Vec::with_capacity(n),
            slots: Vec::with_capacity(n),
            free: Vec::new(),
        }
    }
    #[inline]
    fn as_slice(&self) -> &[Row] {
        &self.items
    } // this IS Deref::deref
    fn mint_slot(&mut self, pos: u32) -> Slot {
        if let Some(i) = self.free.pop() {
            let e = &mut self.slots[i as usize];
            e.pos = pos;
            Slot { idx: i, gen: NonZeroU32::new(e.gen).unwrap() }
        } else {
            let i = self.slots.len() as u32;
            self.slots.push(SlotEntry { gen: 1, pos });
            Slot { idx: i, gen: NonZeroU32::new(1).unwrap() }
        }
    }
    fn push(&mut self, v: Row) -> Slot {
        let pos = self.items.len() as u32;
        let slot = self.mint_slot(pos);
        self.items.push(v);
        self.pos_to_slot.push(slot.idx);
        slot
    }
    #[inline]
    fn get(&self, s: Slot) -> Option<&Row> {
        let e = self.slots.get(s.idx as usize)?;
        if e.gen == s.gen.get() && e.pos != NIL {
            Some(&self.items[e.pos as usize])
        } else {
            None
        }
    }
    // insert at position `at`, minting a new slot. O(N) shift + O(N) fixup.
    fn insert_at(&mut self, at: usize, v: Row) -> Slot {
        let slot = self.mint_slot(at as u32);
        self.items.insert(at, v);
        self.pos_to_slot.insert(at, slot.idx);
        // fixup: every position from `at` onward changed (the inserted one is `at`, tail shifted +1)
        for p in at..self.items.len() {
            self.slots[self.pos_to_slot[p] as usize].pos = p as u32;
        }
        slot
    }
    // remove by position, closing the gap. Returns the freed slot to the free list.
    fn remove_at(&mut self, at: usize) -> Row {
        let v = self.items.remove(at);
        let sidx = self.pos_to_slot.remove(at);
        let e = &mut self.slots[sidx as usize];
        e.pos = NIL;
        e.gen = e.gen.wrapping_add(1).max(1);
        self.free.push(sidx);
        for p in at..self.items.len() {
            self.slots[self.pos_to_slot[p] as usize].pos = p as u32;
        }
        v
    }
    fn move_before(&mut self, from: usize, to: usize) {
        // preserve identity: pull the (item, slot) pair out and reinsert
        let v = self.items.remove(from);
        let sidx = self.pos_to_slot.remove(from);
        let to = if to > from { to - 1 } else { to };
        self.items.insert(to, v);
        self.pos_to_slot.insert(to, sidx);
        let lo = from.min(to);
        for p in lo..self.items.len() {
            self.slots[self.pos_to_slot[p] as usize].pos = p as u32;
        }
    }
}

fn main() {
    section("List<T> slab + THE Deref<[T]> design question");

    size_line::<Row>("Row payload");
    size_line::<SlotEntry>("SlotEntry {gen,pos} (directory, 8B)");
    size_line::<Slot>("Slot {idx, NonZeroU32 gen}");
    size_line::<Option<Slot>>("Option<Slot> (niche-free?)");
    note("Per-item overhead of stable identity over a contiguous store: 4B (pos_to_slot) + 8B (SlotEntry)");
    note("= 12B/item of directory, SEPARATE from the contiguous Vec<T> that Deref<[T]> returns.");

    for &n in &[1_000usize, 10_000, 100_000] {
        println!("\n---- N = {} rows ({} KB of Row payload) ----", n, n * 32 / 1024);

        // Build both
        let base: Vec<Row> = (0..n as u64).map(Row::new).collect();
        let mut ls = ListS::with_capacity(n);
        let slots: Vec<Slot> = (0..n as u64).map(|i| ls.push(Row::new(i))).collect();

        // ---- Deref<[T]>: iterate the whole list (the handler `.iter()` / sum) ----
        let (dvmin, dvmed, _) = bench(1, 500, 50, || {
            let mut acc = 0u64;
            for r in base.iter() {
                acc = acc.wrapping_add(r.a);
            }
            bb(acc);
        });
        let (dsmin, dsmed, _) = bench(1, 500, 50, || {
            let mut acc = 0u64;
            for r in ls.as_slice().iter() {
                acc = acc.wrapping_add(r.a);
            }
            bb(acc);
        });
        println!("  Deref<[T]> full iter:  plain Vec {:.0}ns   List(as_slice) {:.0}ns  (IDENTICAL path)", dvmed, dsmed);
        let _ = (dvmin, dsmin);

        // ---- get(slot): O(1) stable lookup, random order ----
        let mut rng = Rng::new(7);
        let order: Vec<usize> = (0..n).map(|_| rng.below(n as u32) as usize).collect();
        let (gmin, gmed, _) = bench(1, 200, 30, || {
            let mut acc = 0u64;
            for &k in &order {
                acc = acc.wrapping_add(ls.get(bb(slots[k])).unwrap().a);
            }
            bb(acc);
        });
        println!("  get(slot) x{}: {:.0}ns total ({:.2}ns/lookup, O(1) validated)", n, gmed, gmed / n as f64);
        let _ = gmin;

        // ---- splice at a RANDOM middle position: memmove + slot fixup (the O(N) move) ----
        // We insert then remove at the same spot so the list size is stable across samples.
        let midlow = n / 4;
        let midhigh = 3 * n / 4;
        let mut r2 = Rng::new(99);

        // (a) plain Vec: pure memmove, no identity
        let mut vv = base.clone();
        let (svmin, svmed, _) = bench(1, 300, 30, || {
            let at = (midlow + (r2.below((midhigh - midlow) as u32) as usize)) as usize;
            vv.insert(at, Row::new(0));
            vv.remove(at);
            bb(vv.len());
        });

        // (b) ListS: memmove items + memmove pos_to_slot + O(N) slot fixup
        let mut r3 = Rng::new(99);
        let (ssmin, ssmed, _) = bench(1, 300, 30, || {
            let at = midlow + (r3.below((midhigh - midlow) as u32) as usize);
            let s = ls.insert_at(at, Row::new(0));
            // remove the just-inserted item to keep size stable
            let pos = ls.slots[s.idx as usize].pos as usize;
            ls.remove_at(pos);
            bb(ls.items.len());
        });
        println!(
            "  splice @random-mid: plain Vec {:.0}ns  |  List(+identity) {:.0}ns  |  identity tax {:.0}ns ({:.1}x)",
            svmed,
            ssmed,
            ssmed - svmed,
            ssmed / svmed.max(1.0)
        );
        let _ = (svmin, ssmin);
    }

    println!();
    verdict("Deref<[T]> IS honestly implementable in the vector tier: items live in a contiguous `Vec<T>`");
    verdict("in list order; `deref` returns `&items`. Stable identity is a SIDE directory (pos_to_slot +");
    verdict("generational slots slab), 12B/item, tombstoned & reused. get(slot) is O(1). Splice is O(N):");
    verdict("a memmove of items PLUS an O(N) scatter-fixup of shifted slots' positions.");
    println!();
    verdict("DESIGN FLAG (upstream decision needed): in the PROMOTED tier collections.md names a sum-tree");
    verdict("above N_vec. A sum-tree stores items in scattered leaf chunks -> `Deref<Target=[T]>` cannot");
    verdict("return one `&[T]` without materializing an O(N) copy. Since Deref is a trait on the single");
    verdict("type `List<T>`, it must hold at ALL sizes. RESOLUTION: keep item storage CONTIGUOUS (gap");
    verdict("buffer) at every size; let the sum-tree index EXTENTS/ORDER-STATISTICS (pixel<->row for");
    verdict("virtualization) as a LAYER OVER the contiguous store, not as the item storage itself. Then");
    verdict("Deref<[T]> stays honest and O(1); large moves are O(N) memmoves (measured cheap below), which");
    verdict("collections.md ALREADY documents as the vector-tier cost and 05 §14 walls at 100k-datum scale.");
}
