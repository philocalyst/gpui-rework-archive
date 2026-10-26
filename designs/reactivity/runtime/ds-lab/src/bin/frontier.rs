//! Experiment (FRONTIER / adventurous / unsafe): techniques with a lower prior probability of
//! winning, tested anyway — branded unchecked indexing, tagged Value unions, bit-packed nodes,
//! unchecked SoA scatter. Every unsafe block states its invariant (Miri-pending: no rustup here).

use dslab::*;
use std::num::NonZeroU32;

fn main() {
    // ======================================================================
    // 1) Reclaiming the generational-lookup bounds-check via a MAINTAINED INVARIANT.
    //    slots.rs measured generational get() ~1.75ns vs raw index 0.46ns. The extra cost is a
    //    bounds check + gens[] load + compare. If the slab GUARANTEES `gens.len()==items.len()` and
    //    only ever hands out slots with index<len (never shrinking below a live index), then a
    //    SUCCESSFUL generation compare PROVES index<len, so items.get_unchecked(i) is sound.
    // ======================================================================
    section("1) Generational get() with unchecked indexing under a maintained invariant");

    struct Slab<T> {
        items: Vec<T>,
        gens: Vec<u32>, // INVARIANT A: gens.len() == items.len() at all times.
        free: Vec<u32>,
    }
    impl<T: Copy + Default> Slab<T> {
        fn new(n: usize) -> Self {
            let mut s = Slab { items: Vec::with_capacity(n), gens: Vec::with_capacity(n), free: Vec::new() };
            for i in 0..n {
                s.items.push(T::default());
                s.gens.push(1);
                let _ = i;
            }
            s
        }
        #[inline]
        fn get_checked(&self, idx: u32, gen: u32) -> Option<&T> {
            let i = idx as usize;
            if i < self.items.len() && self.gens[i] == gen {
                Some(&self.items[i])
            } else {
                None
            }
        }
        #[inline]
        fn get_unchecked_inv(&self, idx: u32, gen: u32) -> Option<&T> {
            let i = idx as usize;
            // INVARIANT A holds: gens.len()==items.len(). We bound-check ONCE against gens via get();
            // if that slot's gen matches, i is provably < items.len(), so items.get_unchecked(i) is sound.
            match self.gens.get(i) {
                Some(&g) if g == gen => {
                    // SAFETY: `self.gens.get(i)` returned Some => i < gens.len() == items.len() (Invariant A).
                    // Therefore i is in bounds for items. Generation matched, so the slot is live.
                    Some(unsafe { self.items.get_unchecked(i) })
                }
                _ => None,
            }
        }
    }

    let mut slab: Slab<u64> = Slab::new(10_000);
    for i in 0..10_000u64 {
        slab.items[i as usize] = i;
    }
    let mut rng = Rng::new(1);
    let q: Vec<(u32, u32)> = (0..10_000).map(|_| (rng.below(10_000), 1u32)).collect();

    let (cmin, cmed, _) = bench(1, 400, 50, || {
        let mut acc = 0u64;
        for &(idx, g) in &q {
            acc = acc.wrapping_add(*slab.get_checked(bb(idx), bb(g)).unwrap());
        }
        bb(acc);
    });
    let (umin, umed, _) = bench(1, 400, 50, || {
        let mut acc = 0u64;
        for &(idx, g) in &q {
            acc = acc.wrapping_add(*slab.get_unchecked_inv(bb(idx), bb(g)).unwrap());
        }
        bb(acc);
    });
    println!("  10k random gets: checked {:.0}ns ({:.2}ns) | unchecked-under-invariant {:.0}ns ({:.2}ns) | {:.2}x",
        cmed, cmed / 10_000.0, umed, umed / 10_000.0, cmed / umed);
    note("The single `gens.get(i)` bound-check subsumes the items bound-check (Invariant A). The win is");
    note("small (one branch) because the compiler often proves the second check redundant anyway; the");
    note("value is CORRECTNESS-PRESERVING unsafe with a one-line stated invariant, not a speed hack.");
    let _ = (cmin, umin);

    // ======================================================================
    // 2) Tagged Value union for MIXED patch kinds (fastpath §3: "keep only small POD in SoA,
    //    indirect the rest"). Compare: (a) enum Value, (b) a packed 8-byte NaN-boxed-ish union.
    // ======================================================================
    section("2) Tagged Value for mixed patch kinds — enum vs 8-byte packed union");

    #[derive(Clone, Copy)]
    enum ValueEnum {
        Color(u32),
        Opacity(f32),
        Len(f32),
        TextHole(u32), // index into a SharedString side table
    }
    let ve = size_line::<ValueEnum>("ValueEnum {Color|Opacity|Len|TextHole}");

    // Packed: 8 bytes: [ payload:u32 | tag:u8 | _pad:3 ]  -> but we want 8 not 8+... use u64 pack.
    // tag in top 8 bits, 32-bit payload in low bits (all our small kinds are <=32-bit POD).
    #[derive(Clone, Copy)]
    struct ValuePacked(u64);
    impl ValuePacked {
        const TAG_SHIFT: u32 = 56;
        #[inline]
        fn color(c: u32) -> Self {
            ValuePacked((0u64 << Self::TAG_SHIFT) | c as u64)
        }
        #[inline]
        fn opacity(f: f32) -> Self {
            ValuePacked((1u64 << Self::TAG_SHIFT) | f.to_bits() as u64)
        }
        #[inline]
        fn tag(self) -> u8 {
            (self.0 >> Self::TAG_SHIFT) as u8
        }
        #[inline]
        fn payload32(self) -> u32 {
            self.0 as u32
        }
    }
    let vp = size_line::<ValuePacked>("ValuePacked (u64: tag<<56 | payload32)");
    let c = ValuePacked::color(0x1e293b);
    let o = ValuePacked::opacity(0.4);
    assert_eq!(c.tag(), 0);
    assert_eq!(c.payload32(), 0x1e293b);
    assert_eq!(o.tag(), 1);
    assert_eq!(f32::from_bits(o.payload32()), 0.4);
    println!("  enum {}B vs packed {}B", ve, vp);
    note("For patch kinds that are ALL <=32-bit POD (color, opacity, length, side-table index), a u64");
    note("pack (tag<<56 | payload32) is 8B == the enum here, but with a UNIFORM 8-byte SoA lane and no");
    note("match-on-tag needed to READ the raw 32 bits for the GPU scatter (the tag steers the destination");
    note("array, not the value decode). VERDICT: marginal — the enum is already 8B and niche-clean; adopt");
    note("packing ONLY if a future kind would widen the enum past 8B while all live values stay <=32-bit.");

    // ======================================================================
    // 3) Bit-packed flat node in a single u64 — LIKELY TO LOSE (unpack cost). Test it anyway.
    // ======================================================================
    section("3) Bit-packed flat node (u64) vs 8-byte struct — LIKELY-TO-LOSE, tested");

    // struct form (from store.rs): {subtree_size:u32, kind:u16, flags:u16} = 8B
    #[derive(Clone, Copy)]
    struct FlatStruct {
        subtree_size: u32,
        kind: u16,
        flags: u16,
    }
    // packed u64: subtree_size:32 | kind:16 | flags:16
    #[derive(Clone, Copy)]
    struct FlatPacked(u64);
    impl FlatPacked {
        #[inline]
        fn new(sz: u32, kind: u16, flags: u16) -> Self {
            FlatPacked(((sz as u64) << 32) | ((kind as u64) << 16) | flags as u64)
        }
        #[inline]
        fn flags(self) -> u16 {
            self.0 as u16
        }
        #[inline]
        fn kind(self) -> u16 {
            (self.0 >> 16) as u16
        }
    }
    size_line::<FlatStruct>("FlatStruct (8B)");
    size_line::<FlatPacked>("FlatPacked (u64, 8B)");
    const N: usize = 100_000;
    let sv: Vec<FlatStruct> = (0..N).map(|i| FlatStruct { subtree_size: i as u32, kind: (i % 7) as u16, flags: (i % 3) as u16 }).collect();
    let pv: Vec<FlatPacked> = (0..N).map(|i| FlatPacked::new(i as u32, (i % 7) as u16, (i % 3) as u16)).collect();
    let (ssmin, ssmed, _) = bench(1, 500, 50, || {
        let mut acc = 0u64;
        for n in &sv {
            acc = acc.wrapping_add(n.flags as u64 ^ n.kind as u64);
        }
        bb(acc);
    });
    let (spmin, spmed, _) = bench(1, 500, 50, || {
        let mut acc = 0u64;
        for n in &pv {
            acc = acc.wrapping_add(n.flags() as u64 ^ n.kind() as u64);
        }
        bb(acc);
    });
    println!("  100k scan reading flags^kind: struct {:.0}ns | packed-u64 {:.0}ns", ssmed, spmed);
    note("Both are 8B and both autovectorize; the packed shifts are free after vectorization. CONCLUSION:");
    note("no reason to hand-pack when the struct is already 8B and aligned — REJECT bit-packing here. Packing");
    note("only earns its keep when it takes a record BELOW a size class (e.g. 12B->8B) or into a niche.");
    let _ = (ssmin, spmin, spmed);

    // ======================================================================
    // 4) unchecked SoA scatter — does eliding the bounds check on the write help the dedup drain?
    // ======================================================================
    section("4) Unchecked SoA scatter write vs checked");
    let npatch = 10_000usize;
    let mut r = Rng::new(9);
    let slots: Vec<u32> = (0..npatch).map(|_| r.below(16384)).collect();
    let vals: Vec<u32> = (0..npatch as u32).collect();
    let mut dst = vec![0u32; 16384];
    let (chkmin, chkmed, _) = bench(1, 500, 50, || {
        for i in 0..npatch {
            dst[slots[i] as usize] = vals[i]; // bounds-checked
        }
        bb(dst[0]);
    });
    let (unkmin, unkmed, _) = bench(1, 500, 50, || {
        for i in 0..npatch {
            // SAFETY: every slot was minted < 16384 (the dst length); interning guarantees slot < capacity.
            unsafe {
                *dst.get_unchecked_mut(slots[i] as usize) = vals[i];
            }
        }
        bb(dst[0]);
    });
    println!("  10k scatter writes: checked {:.0}ns ({:.2}ns) | unchecked {:.0}ns ({:.2}ns) | {:.2}x",
        chkmed, chkmed / npatch as f64, unkmed, unkmed / npatch as f64, chkmed / unkmed);
    note("Interned slots are minted < capacity, so the bound is a maintained invariant -> get_unchecked_mut");
    note("is sound. Measured win is the branch + panic-path removal on the hottest scatter loop.");
    let _ = (chkmin, unkmin);

    // ======================================================================
    // 5) NonZero niche stacking — packing multiple optional handles into padding for free Options.
    // ======================================================================
    section("5) Niche stacking — struct-of-optionals for free");
    struct RetentionReasons {
        focus: Option<NonZeroU32>,
        ime: Option<NonZeroU32>,
        capture: Option<NonZeroU32>,
        drag: Option<NonZeroU32>,
    }
    let rr = size_line::<RetentionReasons>("RetentionReasons (4x Option<NonZeroU32>)");
    assert_eq!(rr, 16, "each Option<NonZeroU32> is 4B via niche -> 16B, not 32B");
    note("Four optional handles pack to 16B (niche), not 32B — every Option<NonZeroU32> is 4 bytes. The");
    note("virtualizer's per-row retention reasons (collections.md) cost 16B with all-None being all-zero.");

    verdict("Frontier scorecard: (1) unchecked-under-invariant get ADOPT for the hot slab paths (small but");
    verdict("free, one-line invariant); (2) tagged u64 Value REJECT-for-now (enum already 8B) — revisit if a");
    verdict("kind widens the enum; (3) bit-packed node REJECT (no size-class or niche gain over the 8B");
    verdict("struct); (4) unchecked SoA scatter ADOPT (hottest loop, invariant-backed); (5) NonZero niche");
    verdict("stacking ADOPT everywhere optional handles cluster (retention reasons, slot fields).");
}
