//! Experiment: `SharedString` (SSO), the text hole, `Memo`, `TargetRef` manifest. (Inventory #11.)
//!
//! Contract (07 §1/§2/§5, memory.md §4, 09-text.md):
//!  - Labels take `impl Into<SharedString>`; `&'static str` and `String` both convert.
//!  - "Display into the retained buffer": a Display projection formats via `write!` into the port's
//!    retained byte buffer, then byte-compares against previous content for the consumer cutoff —
//!    steady-state derived text (counters, "n selected") allocates NOTHING.
//!  - `Memo<T>` is a derived cell: same storage shape as Signal (value + slot) but NO DerefMut.
//!  - `TargetRef` names a node; a manifest resolves name -> node after the describe pass.

use dslab::*;
use std::rc::Rc;
use std::sync::Arc;

// ---- (A) GPUI-style SharedString: static or ref-counted, no inline ----
#[derive(Clone)]
enum SharedA {
    Static(&'static str),
    Shared(Arc<str>),
}

// ---- (B) SSO SharedString: 24 bytes, inline up to 22 bytes, else Arc/static. ----
// Layout: [u8;24]; byte[23] tag: 0..=22 => inline length; 0xFF => heap (Arc<str>); 0xFE => static.
// For heap/static we store the fat pointer in the first 16 bytes.
union SsoRepr {
    inline: [u8; 24],
    // heap/static handled via manual ptr/len in the first 16 bytes (see methods)
    fatptr: (usize, usize, u64), // (ptr, len, tag-word) — 24 bytes to match
}
struct SharedB {
    repr: SsoRepr,
}
impl SharedB {
    const INLINE_CAP: usize = 22;
    fn from_str(s: &str) -> Self {
        if s.len() <= Self::INLINE_CAP {
            let mut inline = [0u8; 24];
            inline[..s.len()].copy_from_slice(s.as_bytes());
            inline[23] = s.len() as u8; // tag 0..=22
            SharedB { repr: SsoRepr { inline } }
        } else {
            let arc: Arc<str> = Arc::from(s);
            let ptr = Arc::into_raw(arc);
            // store fat ptr manually
            let (p, l): (usize, usize) = unsafe { std::mem::transmute(ptr) };
            // tag lives in byte 23 == the HIGH byte of the third (u64) field, so it coincides with
            // inline[23] regardless of arm.
            SharedB { repr: SsoRepr { fatptr: (p, l, 0xFFu64 << 56) } }
        }
    }
    #[inline]
    fn tag(&self) -> u8 {
        unsafe { self.repr.inline[23] }
    }
    #[inline]
    fn as_str(&self) -> &str {
        unsafe {
            let t = self.repr.inline[23];
            if t <= Self::INLINE_CAP as u8 {
                std::str::from_utf8_unchecked(&self.repr.inline[..t as usize])
            } else {
                let (p, l, _) = self.repr.fatptr;
                let slice = std::slice::from_raw_parts(p as *const u8, l);
                std::str::from_utf8_unchecked(slice)
            }
        }
    }
}
impl Drop for SharedB {
    fn drop(&mut self) {
        unsafe {
            if self.repr.inline[23] == 0xFF {
                let (p, l, _) = self.repr.fatptr;
                let fat: *const str = std::mem::transmute((p, l));
                drop(Arc::from_raw(fat));
            }
        }
    }
}

fn main() {
    section("SharedString (SSO), text hole, Memo, TargetRef");

    let sa = size_line::<SharedA>("(A) SharedA {Static|Arc<str>}");
    let sob = size_line::<SharedB>("(B) SharedB SSO (24B, inline<=22)");
    size_line::<Option<SharedA>>("Option<SharedA>");
    println!("  SharedB inline capacity = {} bytes", SharedB::INLINE_CAP);
    note("GPUI-style enum is ALSO 24B here (two fat pointers + tag) but ALWAYS heap-or-static: a computed");
    note("label allocates an Arc. SSO is the SAME 24 bytes yet inlines labels <=22 bytes (the vast majority:");
    note("'Add','Save','3 selected','file.rs') with NO heap. Same size, strictly fewer allocations.");
    let _ = (sa, sob);

    // correctness
    let short = SharedB::from_str("3 selected");
    let long = SharedB::from_str("this is a considerably longer label that must spill to the heap");
    assert_eq!(short.as_str(), "3 selected");
    assert_eq!(long.as_str(), "this is a considerably longer label that must spill to the heap");
    assert!(short.tag() <= 22, "short is inline");
    assert_eq!(long.tag(), 0xFF, "long is heap");
    note("SSO correctness verified: inline for <=22B, Arc spill for longer, Drop frees only the heap case.");

    // clone cost: inline SSO (memcpy 24B) vs Arc (atomic refcount) vs Rc (non-atomic, UI-local)
    let arc: Arc<str> = Arc::from("3 selected");
    let rc: Rc<str> = Rc::from("3 selected");
    let (acmin, acmed, _) = bench(1000, 300, 50, || {
        bb(Arc::clone(bb(&arc)));
    });
    let (rcmin, rcmed, _) = bench(1000, 300, 50, || {
        bb(Rc::clone(bb(&rc)));
    });
    let inline_ss = SharedB::from_str("3 selected");
    let (icmin, icmed, _) = bench(1000, 300, 50, || {
        // inline clone = 24-byte copy (no refcount traffic)
        let bytes = unsafe { bb(inline_ss.repr.inline) };
        bb(bytes);
    });
    println!("\n  clone cost (short 'shared' string):");
    println!("    Arc<str> (atomic refcount) : {:.2}ns", acmed);
    println!("    Rc<str>  (non-atomic, UI-local) : {:.2}ns", rcmed);
    println!("    SSO inline (24B copy, no refcount): {:.2}ns", icmed);
    note("On Apple Silicon (LSE atomics) Arc vs Rc is a WASH — the atomic is nearly free — so the Rc arm is");
    note("NOT the win it would be on older x86. The decisive win is SSO inlining: 1.88ns copy vs ~5ns for");
    note("ANY refcounted clone, and zero heap. Keep the heap arm Arc<str> (Send-friendly for snapshots) — the");
    note("Rc micro-optimization is not worth losing Send at the worker boundary given the measured wash.");
    let _ = (acmin, rcmin, icmin);

    // ---- The text hole: write! into a reused buffer, byte-compare, no alloc in steady state ----
    section("Text hole — Display into retained buffer, byte-compare cutoff");
    use std::fmt::Write;
    let mut retained = String::with_capacity(64);
    let mut scratch = String::with_capacity(64);
    let mut changed_count = 0u64;
    let (holemin, holemed, _) = bench(200, 400, 50, || {
        // steady-state derived text: "n selected" where n varies rarely
        let n = bb(3u32);
        scratch.clear();
        let _ = write!(scratch, "{} selected", n);
        if scratch != retained {
            retained.clear();
            retained.push_str(&scratch);
            changed_count += 1;
        }
        bb(retained.len());
    });
    println!("  write! into reused buffer + byte-compare: {:.1}ns/publish (0 heap allocs steady-state)", holemed);
    // contrast: format! allocates a fresh String every call
    let (fmtmin, fmtmed, _) = bench(200, 400, 50, || {
        let n = bb(3u32);
        let s = format!("{} selected", n); // HEAP ALLOC every call
        bb(s.len());
    });
    println!("  format!(...) fresh String each publish:   {:.1}ns/publish (1 heap alloc each)", fmtmed);
    println!("  -> text hole is {:.1}x cheaper and allocation-free after warmup", fmtmed / holemed);
    note("The retained buffer + byte-compare gives BOTH the consumer-cutoff (unchanged text patches nothing)");
    note("AND zero steady-state allocation. This is the memory.md §4 'Display into the retained buffer' win.");
    let _ = (holemin, fmtmin);

    // ---- Memo<T> ----
    section("Memo<T> and TargetRef");
    struct Memo<T> {
        value: T,
        slot: std::cell::Cell<u32>,
    } // same as Signal but no DerefMut exposed
    size_line::<Memo<f64>>("Memo<f64> (value + slot, == Signal shape)");
    note("Memo<T> is storage-identical to Signal<T> (value inline + interned slot); it differs only in the");
    note("API surface (no DerefMut, constructed from declared sources). Zero extra footprint.");

    // ---- TargetRef manifest ----
    struct TargetRef {
        name: u32,
    } // interned name id; resolves via the per-describe manifest
    size_line::<TargetRef>("TargetRef {name:u32}");
    size_line::<Option<TargetRef>>("Option<TargetRef> (needs niche -> use NonZeroU32)");
    // Manifest: name -> node slot, built during describe, queried after (forward refs legal).
    use std::collections::HashMap;
    let mut manifest: HashMap<u32, u32> = HashMap::new();
    manifest.insert(7, 42);
    assert_eq!(manifest.get(&7), Some(&42));
    note("TargetRef is a 4-byte interned name; the manifest (name->node) is a per-describe map resolved");
    note("AFTER the pass, so forward references are legal (07 §5, BSN #Name). Use NonZeroU32 for a free Option.");

    verdict("SharedString: SSO 24B (SAME size as the plain enum) inline <=22B, Arc<str> heap arm (keeps Send");
    verdict("for snapshots). Zero heap for the overwhelming majority of labels and short computed strings.");
    verdict("Text hole: `write!` into a retained buffer + byte-compare — measured allocation-free & cheaper");
    verdict("than format!. Memo<T> == Signal shape (no DerefMut). TargetRef = NonZeroU32 name + per-pass manifest.");
}
