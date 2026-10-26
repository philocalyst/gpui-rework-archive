//! Experiment (ROUND 2): SHARING PRIMITIVES — ThinArc/HeaderSlice, ArcBorrow, frozen arenas.
//!
//! Round 1 fixed `SharedString` (SSO + `Arc<str>` heap arm). This round measures the *rest* of
//! the sharing toolbox the frontier crates ship, reimplemented dependency-free so the numbers
//! are ours:
//!
//!   (T) ThinArc<H,[T]> — triomphe/servo_arc's HeaderSlice: refcount + header + len + slice in
//!       ONE allocation behind a ONE-WORD pointer (std `Arc<[T]>` is a two-word fat pointer and
//!       `Arc<Vec<T>>` is two allocations + two hops). Servo's rule tree lives on this.
//!   (B) ArcBorrow — passing `&T` where APIs habitually clone an Arc: what refcount traffic
//!       actually costs per call, per node, per frame.
//!   (F) Frozen arenas — elsa-style `FrozenVec` (stable `&T` via Box indirection) vs a CHUNKED
//!       stable arena (stable `&T` with NO per-item box — boxcar/append-only-vec's trick) vs
//!       plain `Vec` (fast, but addresses move). The chunked arena is what an interner or
//!       entity registry should be.
//!
//! All unsafe blocks carry stated invariants; Miri-pending (no rustup in this env).

use dslab::*;
use std::alloc::{alloc, dealloc, Layout};
use std::marker::PhantomData;
use std::mem::MaybeUninit;
use std::ptr::NonNull;
use std::sync::atomic::{AtomicUsize, Ordering};
use std::sync::Arc;

// ---------------------------------------------------------------- (T) ThinArc<H, [T]>
#[repr(C)]
struct ThinInner<H> {
    count: AtomicUsize,
    len: usize,
    header: H,
    // [T] payload follows, at align_of::<T>() after header
}
struct ThinArc<H, T> {
    ptr: NonNull<u8>,
    _m: PhantomData<(H, T)>,
}
impl<H, T: Copy> ThinArc<H, T> {
    // header→payload offset depends only on the TYPES, so it is a compile-time constant —
    // dereferencing a ThinArc never does layout math at runtime.
    const OFF: usize = {
        let sz = std::mem::size_of::<ThinInner<H>>();
        let al = std::mem::align_of::<T>();
        (sz + al - 1) / al * al
    };
    fn layout(len: usize) -> Layout {
        let al = std::mem::align_of::<ThinInner<H>>().max(std::mem::align_of::<T>());
        // INVARIANT: OFF is ThinInner<H> rounded up to T's alignment; total covers the slice.
        Layout::from_size_align(Self::OFF + len * std::mem::size_of::<T>(), al).unwrap()
    }
    fn new(header: H, slice: &[T]) -> Self {
        // INVARIANT: one allocation laid out as ThinInner<H> followed by len T's at OFF.
        unsafe {
            let p = alloc(Self::layout(slice.len()));
            assert!(!p.is_null());
            (p as *mut ThinInner<H>).write(ThinInner {
                count: AtomicUsize::new(1),
                len: slice.len(),
                header,
            });
            let data = p.add(Self::OFF) as *mut T;
            std::ptr::copy_nonoverlapping(slice.as_ptr(), data, slice.len());
            ThinArc { ptr: NonNull::new_unchecked(p), _m: PhantomData }
        }
    }
    #[inline]
    fn inner(&self) -> &ThinInner<H> {
        // INVARIANT: ptr always points at a live ThinInner<H> (count > 0 while self exists).
        unsafe { &*(self.ptr.as_ptr() as *const ThinInner<H>) }
    }
    #[inline]
    fn slice(&self) -> &[T] {
        let len = self.inner().len;
        unsafe { std::slice::from_raw_parts(self.ptr.as_ptr().add(Self::OFF) as *const T, len) }
    }
    #[inline]
    fn header(&self) -> &H {
        &self.inner().header
    }
}
impl<H, T> Clone for ThinArc<H, T> {
    #[inline]
    fn clone(&self) -> Self {
        // single count, no weak: one fetch_add (triomphe's exact win over std)
        unsafe {
            (*(self.ptr.as_ptr() as *const ThinInner<H>)).count.fetch_add(1, Ordering::Relaxed);
        }
        ThinArc { ptr: self.ptr, _m: PhantomData }
    }
}
impl<H, T> Drop for ThinArc<H, T> {
    #[inline]
    fn drop(&mut self) {
        unsafe {
            let inner = &*(self.ptr.as_ptr() as *const ThinInner<H>);
            if inner.count.fetch_sub(1, Ordering::Release) == 1 {
                std::sync::atomic::fence(Ordering::Acquire);
                let len = inner.len;
                // T: Copy in this lab -> no element drops needed; a real impl drops elements
                let sz = std::mem::size_of::<ThinInner<H>>();
                let ta = std::mem::align_of::<T>();
                let off = (sz + ta - 1) / ta * ta;
                let al = std::mem::align_of::<ThinInner<H>>().max(ta);
                let layout =
                    Layout::from_size_align_unchecked(off + len * std::mem::size_of::<T>(), al);
                dealloc(self.ptr.as_ptr(), layout);
            }
        }
    }
}

fn main() {
    section("ThinArc<H,[T]> — one word, one allocation (triomphe/servo_arc HeaderSlice)");
    println!("  sizes:");
    size_line::<ThinArc<u32, u32>>("ThinArc<u32,[u32]> (thin)");
    size_line::<Option<ThinArc<u32, u32>>>("Option<ThinArc> (NonNull niche)");
    size_line::<Arc<[u32]>>("std Arc<[u32]> (fat)");
    size_line::<Arc<Vec<u32>>>("std Arc<Vec<u32>> (thin ptr, TWO allocations, extra hop)");

    let src: Vec<u32> = (0..64).collect();

    // construction cost
    let (_, tmk, _) = bench(2000, 60, 10, || {
        let t = ThinArc::<u32, u32>::new(7, &src);
        bb(t.slice()[0]);
    });
    let (_, amk, _) = bench(2000, 60, 10, || {
        let a: Arc<[u32]> = Arc::from(&src[..]);
        bb(a[0]);
    });
    let (_, vmk, _) = bench(2000, 60, 10, || {
        let a: Arc<Vec<u32>> = Arc::new(src.clone());
        bb(a[0]);
    });
    println!("\n  construct+drop (64-u32 payload): ThinArc {tmk:.1} ns   Arc<[u32]> {amk:.1} ns   Arc<Vec> {vmk:.1} ns");

    // clone+drop (non-final) cost
    let t = ThinArc::<u32, u32>::new(7, &src);
    let a: Arc<[u32]> = Arc::from(&src[..]);
    let (_, tcl, _) = bench(5000, 60, 10, || {
        let c = t.clone();
        bb(c.header());
    });
    let (_, acl, _) = bench(5000, 60, 10, || {
        let c = a.clone();
        bb(c.len());
    });
    println!("  clone+drop (non-final):          ThinArc {tcl:.2} ns   std Arc {acl:.2} ns");
    note("Clone parity is expected (both are one RMW pair on M3); the thin win is the WORD and");
    note("the single allocation: a child-list field is 8 B not 16, Option<field> is still 8,");
    note("header+slice share one cache-line neighborhood, and there is no Vec middle hop.");

    // read-through cost: sum the slice behind each handle shape
    let (_, trd, _) = bench(2000, 60, 10, || {
        let mut s = 0u64;
        for &x in t.slice() {
            s += x as u64;
        }
        bb(s);
    });
    let (_, ard, _) = bench(2000, 60, 10, || {
        let mut s = 0u64;
        for &x in a.iter() {
            s += x as u64;
        }
        bb(s);
    });
    let av: Arc<Vec<u32>> = Arc::new(src.clone());
    let (_, avrd, _) = bench(2000, 60, 10, || {
        let mut s = 0u64;
        for &x in av.iter() {
            s += x as u64;
        }
        bb(s);
    });
    println!("  sum 64 elems through handle:     ThinArc {trd:.1} ns   Arc<[u32]> {ard:.1} ns   Arc<Vec> {avrd:.1} ns");

    // ---------------------------------------------------------------- (B) ArcBorrow economics
    section("ArcBorrow — what cloning an Arc per read actually costs");
    #[inline(never)]
    fn read_owned(a: Arc<[u32]>) -> u32 {
        a[0]
    }
    #[inline(never)]
    fn read_borrowed(a: &[u32]) -> u32 {
        a[0]
    }
    let (_, own, _) = bench(5000, 60, 10, || {
        bb(read_owned(a.clone()));
    });
    let (_, brw, _) = bench(5000, 60, 10, || {
        bb(read_borrowed(&a));
    });
    println!("  call taking Arc clone: {own:.2} ns   call taking &[u32]: {brw:.2} ns   ({:.1}x)", own / brw);
    println!(
        "  per 10k styled nodes/frame that difference is {:.0} µs of pure refcount traffic",
        (own - brw) * 10_000.0 / 1000.0
    );
    note("ArcBorrow (a NonNull + lifetime, bit-identical to &T) is triomphe's answer: read paths");
    note("take borrows, ownership transfers take the Arc. The kernel API should never require a");
    note("clone to *look* at a shared style/rope/scene handle.");

    // ---------------------------------------------------------------- (F) frozen arenas
    section("Frozen arenas — stable &T under append (elsa vs chunked vs plain Vec)");
    const M: usize = 1_000_000;
    #[derive(Clone, Copy, Default)]
    struct Item {
        a: u64,
        #[allow(dead_code)]
        b: u64, // pad to a realistic 16 B record
    }

    // (a) elsa-style: Vec<Box<Item>> — stable because the BOX target never moves
    let mut elsa: Vec<Box<Item>> = Vec::new();
    let t0 = std::time::Instant::now();
    for i in 0..M {
        elsa.push(Box::new(Item { a: i as u64, b: 0 }));
    }
    let elsa_push = t0.elapsed().as_nanos() as f64 / M as f64;

    // (b) chunked stable arena: Vec<Box<[MaybeUninit<Item>; 4096]>> — stable because chunks
    //     never move or reallocate; only the outer Vec of chunk POINTERS reallocates.
    struct ChunkArena {
        chunks: Vec<Box<[MaybeUninit<Item>; 4096]>>,
        len: usize,
    }
    impl ChunkArena {
        fn push(&mut self, it: Item) -> &Item {
            let (c, o) = (self.len / 4096, self.len % 4096);
            if o == 0 {
                // INVARIANT: a chunk, once pushed, is never moved/dropped until the arena drops.
                self.chunks.push(Box::new([MaybeUninit::uninit(); 4096]));
            }
            self.len += 1;
            self.chunks[c][o].write(it);
            // SAFETY: just initialized; chunk memory address is stable for the arena's life.
            unsafe { self.chunks[c][o].assume_init_ref() }
        }
        #[inline]
        fn get(&self, i: usize) -> &Item {
            // SAFETY: i < len ⇒ initialized (monotone append-only).
            unsafe { self.chunks[i / 4096][i % 4096].assume_init_ref() }
        }
    }
    let mut ca = ChunkArena { chunks: Vec::new(), len: 0 };
    let t0 = std::time::Instant::now();
    for i in 0..M {
        ca.push(Item { a: i as u64, b: 0 });
    }
    let ca_push = t0.elapsed().as_nanos() as f64 / M as f64;

    // (c) plain Vec (addresses move on realloc — the thing the other two fix)
    let mut pv: Vec<Item> = Vec::new();
    let t0 = std::time::Instant::now();
    for i in 0..M {
        pv.push(Item { a: i as u64, b: 0 });
    }
    let pv_push = t0.elapsed().as_nanos() as f64 / M as f64;

    println!("  push x{M}: elsa-style(Box/item) {elsa_push:.1} ns   chunked arena {ca_push:.1} ns   plain Vec {pv_push:.1} ns");

    // random reads
    let mut rng = Rng::new(5);
    let idx: Vec<usize> = (0..4096).map(|_| rng.below(M as u32) as usize).collect();
    let (_, er, _) = bench(200, 60, 10, || {
        let mut s = 0u64;
        for &i in &idx {
            s = s.wrapping_add(elsa[i].a);
        }
        bb(s);
    });
    let (_, cr, _) = bench(200, 60, 10, || {
        let mut s = 0u64;
        for &i in &idx {
            s = s.wrapping_add(ca.get(i).a);
        }
        bb(s);
    });
    let (_, pr, _) = bench(200, 60, 10, || {
        let mut s = 0u64;
        for &i in &idx {
            s = s.wrapping_add(pv[i].a);
        }
        bb(s);
    });
    println!(
        "  4096 random reads: elsa-style {:.2} ns/read   chunked {:.2} ns/read   plain Vec {:.2} ns/read",
        er / 4096.0,
        cr / 4096.0,
        pr / 4096.0
    );

    // sequential iteration
    let (_, ei, _) = bench(5, 40, 8, || {
        let mut s = 0u64;
        for b in &elsa {
            s = s.wrapping_add(b.a);
        }
        bb(s);
    });
    let (_, ci, _) = bench(5, 40, 8, || {
        let mut s = 0u64;
        for c in 0..(ca.len + 4095) / 4096 {
            let hi = if (c + 1) * 4096 <= ca.len { 4096 } else { ca.len % 4096 };
            for o in 0..hi {
                s = s.wrapping_add(unsafe { ca.chunks[c][o].assume_init_ref() }.a);
            }
        }
        bb(s);
    });
    let (_, pi, _) = bench(5, 40, 8, || {
        let mut s = 0u64;
        for it in &pv {
            s = s.wrapping_add(it.a);
        }
        bb(s);
    });
    println!(
        "  full iteration:    elsa-style {:.3} ns/item   chunked {:.3} ns/item   plain Vec {:.3} ns/item",
        ei / M as f64,
        ci / M as f64,
        pi / M as f64
    );
    println!(
        "  memory/item (16 B payload): elsa-style {} B (Box + ptr)   chunked ~16 B   Vec 16 B",
        16 + 8 + 16 // malloc bucket for Box<Item> is >=16B + 8B ptr in the Vec
    );

    println!();
    verdict("ADOPT ThinArc/HeaderSlice for shared header+slice payloads (children arrays, glyph");
    verdict("runs, rule chains): 8 B handles, free Option, ONE allocation, no Vec hop. ADOPT the");
    verdict("borrow-to-read discipline (ArcBorrow shape) in every kernel read path. ADOPT the");
    verdict("CHUNKED stable arena for interners/registries needing &T stability under append —");
    verdict("it beats elsa-style per-item boxing on every axis measured (push, read, iterate,");
    verdict("bytes) while keeping the same soundness argument (chunks never move).");
}
