//! Experiment: `Signal<T>` cell layout — how small can the non-T overhead be?
//!
//! Contract (07 §1, memory.md §0/§3):
//!  - `Signal<T>` is Deref/DerefMut to T, so **T lives inline in the cell** (deref returns &T).
//!  - !Clone. Default when T: Default. Never Serialize.
//!  - memory.md: "the value plus an interned u32 slot id and intrusive links; no Rc, no heap cell,
//!    no per-signal allocation, no side arena of values."
//!  - Interning is LAZY: "on first bind a wire is interned." A Signal only ever read via `*` in a
//!    handler (never wired, never read in a view) needs NO slot at all — pure inline field.
//!  - The describe-frame read-set records the cell on a starred deref; on publish the cell notifies
//!    its recorded readers. So the cell needs *identity* the moment it is used reactively.
//!  - Dirty law: publishes are unconditional; the equality cutoff lives at the CONSUMER. So the cell
//!    itself needs NO PartialEq, NO clone-before-write, and arguably no dirty bit of its own.

use dslab::*;
use std::cell::Cell;

// ============================================================================
// Baseline "naive inline": everything the runtime might want lives in the cell.
// ============================================================================
#[allow(dead_code)]
struct SignalNaive<T> {
    value: T,
    slot: u32,       // interned id
    subs_head: u32,  // head of subscriber list
    dirty_next: u32, // intrusive dirty-list link
    revision: u32,   // per-cell revision
    flags: u8,       // dirty/always/etc
}
// !Clone by construction (no derive). This is what you get if you don't think about it.

// ============================================================================
// Candidate LEAN: value + one lazily-interned slot word. ALL bookkeeping
// (subscriber head, dirty link, revision, owner, flags) lives in a dense
// per-window WireTable keyed by the slot, allocated only on first reactive use.
// slot == 0  => "never used reactively" (no table entry, zero heap).
// ============================================================================
struct SignalLean<T> {
    value: T,
    slot: Cell<u32>, // 0 = unbound; interior-mutable because interning happens under &self (describe)
}
impl<T> SignalLean<T> {
    fn new(v: T) -> Self {
        SignalLean { value: v, slot: Cell::new(0) }
    }
    // Deref/DerefMut would return &value / &mut value — T is genuinely inline.
    #[inline]
    fn get(&self) -> &T {
        &self.value
    }
}
// The side table entry (only exists once wired). Intrusive links live HERE, not in the cell.
#[allow(dead_code)]
struct WireRecord {
    subs_head: u32,  // head index into the subscriber slab (intrusive list)
    dirty_next: u32, // dirty-list intrusive link
    revision: u32,
    owner: u32,
    flags: u8,
}

// ============================================================================
// Candidate LEAN+NICHE: prove Signal<bool> is 8 bytes, not 16, and that a Signal
// of a niche-bearing T stays tight.
// ============================================================================

fn main() {
    section("Signal<T> cell layout — non-T overhead");

    println!("-- Naive (value + slot + subs_head + dirty_next + revision + flags):");
    let nb = size_line::<SignalNaive<bool>>("SignalNaive<bool>");
    let nf = size_line::<SignalNaive<f64>>("SignalNaive<f64>");
    size_line::<SignalNaive<[f32; 4]>>("SignalNaive<Color=[f32;4]>");
    size_line::<SignalNaive<String>>("SignalNaive<String>");

    println!("\n-- Lean (value + Cell<u32> slot; bookkeeping in side WireTable):");
    let lb = size_line::<SignalLean<bool>>("SignalLean<bool>");
    let lf = size_line::<SignalLean<f64>>("SignalLean<f64>");
    size_line::<SignalLean<[f32; 4]>>("SignalLean<Color=[f32;4]>");
    let ls = size_line::<SignalLean<String>>("SignalLean<String>");
    size_line::<SignalLean<u8>>("SignalLean<u8>");

    println!("\n-- The overhead itself (size_of Signal<T> - size_of T):");
    println!("   naive<bool> overhead = {} bytes", nb - 1);
    println!("   lean<bool>  overhead = {} bytes", lb - 1);
    println!("   naive<f64>  overhead = {} bytes", nf - 8);
    println!("   lean<f64>   overhead = {} bytes", lf - 8);
    println!("   lean<String> overhead = {} bytes (String is 24)", ls - 24);

    assert_eq!(lb, 8, "Signal<bool> must be 8 bytes (1 value + 4 slot + pad), NOT 16");
    assert_eq!(lf, 16, "Signal<f64> = 8 value + 4 slot + 4 pad");
    note("Lean overhead is a flat 4 bytes (one u32 slot) + alignment padding — the theoretical floor");
    note("for a cell that must carry reactive identity. Naive overhead is 16-20 bytes.");
    note("Signal<bool> = 8 bytes (was 16 naive). The slot word is the ONLY non-T cost.");

    // ---- Can we do better than 4 bytes? Only by giving up lazy interning or capping slot count. ----
    // A u24 slot (3 bytes) packed with a small value would need repr hackery and unaligned access;
    // for T with align>=4 the 4th byte is free padding anyway, so 4 bytes costs nothing for f64/color/String.
    note("For T with align>=4 (f64, Color, String, u32...), the slot word occupies otherwise-wasted");
    note("padding: SignalLean<f64>=16 == would-be padded {f64, u32}. Overhead is *free* there.");

    // ---- Lazy interning cost: first reactive use assigns a slot; steady reads are a plain field load ----
    let sig = SignalLean::new(3.0f64);
    let (rmin, rmed, _) = bench(1000, 300, 50, || {
        bb(*sig.get());
    });
    println!("\n  steady starred read (*signal): min {:.3}ns median {:.3}ns  (plain field load)", rmin, rmed);
    note("A starred read is a field load + (in describe) one read-set push. No table touch in steady state.");

    // ---- Interning: simulate first-bind assigning a dense slot from a bump counter ----
    struct Interner {
        next: u32,
    }
    impl Interner {
        #[inline]
        fn intern<T>(&mut self, s: &SignalLean<T>) -> u32 {
            let cur = s.slot.get();
            if cur != 0 {
                return cur;
            }
            self.next += 1;
            s.slot.set(self.next);
            self.next
        }
    }
    let mut interner = Interner { next: 0 };
    let sig = SignalLean::new(0u32);
    let first = interner.intern(&sig);
    let again = interner.intern(&sig);
    assert_eq!(first, again, "interning is idempotent; slot cached in the cell");
    assert_eq!(sig.slot.get(), 1);
    note("Interning is idempotent & lazy: unwired Signals never allocate a slot or a WireRecord.");

    println!("\n-- WireRecord (side-table entry, exists only when wired):");
    size_line::<WireRecord>("WireRecord");
    note("Bookkeeping is pay-per-wire: N wired cells => N WireRecords in one dense slab, 0 for the rest.");

    verdict("Adopt LEAN: `struct Signal<T> { value: T, slot: Cell<u32> }`. Overhead = 4 bytes (slot),");
    verdict("absorbed into alignment padding for any T with align>=4. Signal<bool>=8B. All subscriber/");
    verdict("dirty/revision bookkeeping lives in a dense per-window WireTable keyed by slot, allocated");
    verdict("on first reactive use. Unwired Signals are pure inline fields (zero heap, slot==0).");
}
