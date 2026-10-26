//! Experiment: `Slot<T>` generational id — packing, niches, ABA safety.
//!
//! Contract (07 §1, collections.md, scheduler.md):
//!  - `Slot<T>` is typed, `Copy`, generational, item-not-position.
//!  - Transferable between containers of the same `T`.
//!  - scheduler describes State<T> as "two-word, generational, Copy" but the item Slot only needs
//!    to name a runtime item; the *window* is implicit in the container. We test the smallest sound
//!    representation and whether `Option<Slot<T>>` is niche-free.

use dslab::*;
use std::marker::PhantomData;
use std::num::NonZeroU32;

// NOTE (finding): `#[derive(Copy, Clone, PartialEq, Eq)]` on a generic Slot<T> adds a spurious
// `T: Copy`/`T: Clone` bound even though the only real field is a PhantomData<fn()->T> (always Copy).
// Slot<T> must be Copy *regardless of T* (07 §1) — so the impls are hand-written with no T bound.
macro_rules! copy_slot {
    ($ty:ident) => {
        impl<T> Clone for $ty<T> {
            #[inline]
            fn clone(&self) -> Self {
                *self
            }
        }
        impl<T> Copy for $ty<T> {}
        impl<T> PartialEq for $ty<T> {
            #[inline]
            fn eq(&self, o: &Self) -> bool {
                self.raw_eq(o)
            }
        }
        impl<T> Eq for $ty<T> {}
    };
}

// ---- Candidate A: 2×u32 (index:u32, generation:u32), no niche ----
struct SlotA<T> {
    index: u32,
    generation: u32,
    _t: PhantomData<fn() -> T>,
}
impl<T> SlotA<T> {
    fn raw_eq(&self, o: &Self) -> bool {
        self.index == o.index && self.generation == o.generation
    }
}
copy_slot!(SlotA);

// ---- Candidate B: single u64 packed (index:32 | generation:32), no niche ----
struct SlotB<T> {
    bits: u64,
    _t: PhantomData<fn() -> T>,
}
impl<T> SlotB<T> {
    fn raw_eq(&self, o: &Self) -> bool {
        self.bits == o.bits
    }
}
copy_slot!(SlotB);
impl<T> SlotB<T> {
    #[inline]
    fn new(index: u32, gen: u32) -> Self {
        SlotB { bits: ((index as u64) << 32) | gen as u64, _t: PhantomData }
    }
    #[inline]
    fn index(self) -> u32 {
        (self.bits >> 32) as u32
    }
    #[inline]
    fn generation(self) -> u32 {
        self.bits as u32
    }
}

// ---- Candidate C: NonZeroU32 generation packed with index in a u64, niche in the WHOLE ----
// Put a NonZero field so the compiler finds a niche for Option<Slot>. We reserve gen==0 as invalid.
struct SlotC<T> {
    index: u32,
    generation: NonZeroU32, // gen starts at 1; 0 is never a live generation -> Option niche
    _t: PhantomData<fn() -> T>,
}
impl<T> SlotC<T> {
    fn raw_eq(&self, o: &Self) -> bool {
        self.index == o.index && self.generation == o.generation
    }
}
copy_slot!(SlotC);

// ---- Candidate D: single NonZeroU64 packing both, full niche + one word ----
struct SlotD<T> {
    // layout: [index:32 | generation:32], generation>=1 guarantees the u64 is nonzero.
    bits: std::num::NonZeroU64,
    _t: PhantomData<fn() -> T>,
}
impl<T> SlotD<T> {
    fn raw_eq(&self, o: &Self) -> bool {
        self.bits == o.bits
    }
}
copy_slot!(SlotD);
impl<T> SlotD<T> {
    #[inline]
    fn new(index: u32, gen: NonZeroU32) -> Self {
        let bits = ((index as u64) << 32) | gen.get() as u64;
        // SAFETY: gen.get() >= 1, so the low 32 bits are nonzero, so the u64 is nonzero.
        SlotD { bits: unsafe { std::num::NonZeroU64::new_unchecked(bits) }, _t: PhantomData }
    }
    #[inline]
    fn index(self) -> u32 {
        (self.bits.get() >> 32) as u32
    }
    #[inline]
    fn generation(self) -> u32 {
        self.bits.get() as u32
    }
}

// A generational slab that mints & validates SlotD, to test ABA and access cost.
struct Slab<T> {
    items: Vec<Option<T>>,
    gens: Vec<NonZeroU32>,
    free: Vec<u32>,
}
impl<T> Slab<T> {
    fn new() -> Self {
        Slab { items: Vec::new(), gens: Vec::new(), free: Vec::new() }
    }
    fn insert(&mut self, v: T) -> SlotD<T> {
        if let Some(i) = self.free.pop() {
            self.items[i as usize] = Some(v);
            SlotD::new(i, self.gens[i as usize])
        } else {
            let i = self.items.len() as u32;
            let g = NonZeroU32::new(1).unwrap();
            self.items.push(Some(v));
            self.gens.push(g);
            SlotD::new(i, g)
        }
    }
    #[inline]
    fn get(&self, s: SlotD<T>) -> Option<&T> {
        let i = s.index() as usize;
        if i < self.items.len() && self.gens[i].get() == s.generation() {
            self.items[i].as_ref()
        } else {
            None
        }
    }
    fn remove(&mut self, s: SlotD<T>) -> Option<T> {
        let i = s.index() as usize;
        if i < self.items.len() && self.gens[i].get() == s.generation() {
            let v = self.items[i].take();
            // bump generation on free -> old slot handles no longer validate (ABA guard)
            let ng = self.gens[i].get().wrapping_add(1);
            self.gens[i] = NonZeroU32::new(if ng == 0 { 1 } else { ng }).unwrap();
            if v.is_some() {
                self.free.push(i as u32);
            }
            v
        } else {
            None
        }
    }
}

fn main() {
    section("Slot<T> generational id — size, niche, ABA");

    // Sizes
    let a = size_line::<SlotA<u8>>("SlotA<u8>  2xu32 plain");
    let b = size_line::<SlotB<u8>>("SlotB<u8>  u64 packed");
    let c = size_line::<SlotC<u8>>("SlotC<u8>  u32 + NonZeroU32");
    let d = size_line::<SlotD<u8>>("SlotD<u8>  NonZeroU64 packed");
    println!();
    size_line::<Option<SlotA<u8>>>("Option<SlotA>");
    size_line::<Option<SlotB<u8>>>("Option<SlotB>");
    let oc = size_line::<Option<SlotC<u8>>>("Option<SlotC>");
    let od = size_line::<Option<SlotD<u8>>>("Option<SlotD>");
    println!();
    size_line::<[Option<SlotD<u8>>; 8]>("[Option<SlotD>;8] (packed-niche array)");
    size_line::<[Option<SlotB<u8>>; 8]>("[Option<SlotB>;8] (no-niche array)");

    assert_eq!(a, 8);
    assert_eq!(b, 8);
    assert_eq!(c, 8);
    assert_eq!(d, 8);
    assert_eq!(oc, 8, "Option<SlotC> must be niche-free (8, not 12)");
    assert_eq!(od, 8, "Option<SlotD> must be niche-free (8, not 16)");
    note("All four Slot reprs are 8 bytes. Only C and D give a *free* Option (niche).");
    note("SlotD (NonZeroU64) is the only one where Option costs 8 AND it is one register/one word.");

    // Typed branding is zero-cost: verify PhantomData<fn()->T> adds nothing and stays Send-agnostic.
    assert_eq!(size_line::<SlotD<String>>("SlotD<String> (branding cost)"), 8);

    // ABA safety demonstration
    let mut slab: Slab<u64> = Slab::new();
    let s1 = slab.insert(100);
    assert_eq!(slab.get(s1).copied(), Some(100));
    let _ = slab.remove(s1);
    let s2 = slab.insert(200); // reuses index 0, generation bumped
    assert_eq!(s1.index(), s2.index(), "index reused");
    assert_ne!(s1.generation(), s2.generation(), "generation bumped");
    assert_eq!(slab.get(s1), None, "stale slot (ABA) rejected");
    assert_eq!(slab.get(s2).copied(), Some(200));
    note("ABA: after remove+reinsert at same index, the old Slot fails validation (gen mismatch).");

    // Generation width math: u32 gen means 2^32 recycles of one index before wrap.
    // scheduler.md: "wrap causes a new epoch/terminal diagnostic before an old handle could alias."
    // A 24-bit gen (16.7M recycles) + 40-bit index would also fit a NonZeroU64 and free 8 more index bits;
    // but 40-bit index is overkill for a per-window slab (<2^32 items). 32/32 is the honest split.
    note("Gen width: 32-bit gen = 4.29e9 recycles/index before wrap; scheduler mandates a wrap diagnostic,");
    note("so ABA is impossible in practice. 32/32 split is the recommendation.");

    // Access-cost micro: validate-and-get through the generational slab vs a raw Vec index.
    let mut slab: Slab<u64> = Slab::new();
    let slots: Vec<_> = (0..10_000u64).map(|v| slab.insert(v)).collect();
    let raw: Vec<u64> = (0..10_000u64).collect();

    let mut rng = Rng::new(1);
    let idxs: Vec<usize> = (0..10_000).map(|_| rng.below(10_000) as usize).collect();

    let (gmin, gmed, _) = bench(1, 400, 50, || {
        let mut acc = 0u64;
        for &i in &idxs {
            acc = acc.wrapping_add(*slab.get(bb(slots[i])).unwrap());
        }
        bb(acc);
    });
    let (rmin, rmed, _) = bench(1, 400, 50, || {
        let mut acc = 0u64;
        for &i in &idxs {
            acc = acc.wrapping_add(raw[bb(i)]);
        }
        bb(acc);
    });
    println!(
        "  10k random generational get():  min {:.0}ns  median {:.0}ns  ({:.2}ns/lookup)",
        gmin, gmed, gmed / 10_000.0
    );
    println!(
        "  10k random raw Vec index:       min {:.0}ns  median {:.0}ns  ({:.2}ns/lookup)",
        rmin, rmed, rmed / 10_000.0
    );
    note("Generational validation adds a bounds check + a gens[] load + compare over a raw index —");
    note("sub-nanosecond per lookup here; the gens[] array is a second cache stream (SoA), acceptable.");

    verdict("Adopt SlotD = NonZeroU64 packed [index:32 | gen:32]. 8 bytes, Copy, free Option, typed via");
    verdict("PhantomData<fn()->T> (zero size, keeps Slot !Send-neutral & variance-correct). gen>=1 invariant.");
}
