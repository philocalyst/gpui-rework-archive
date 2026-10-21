//! Reproducible allocation/startup evidence, including a TEST-ONLY forwarding
//! allocator. No custom allocation/unsafe code exists in the production library.
use gpui_reactivity_ownership_lab::*;
use std::{
    alloc::{GlobalAlloc, Layout, System},
    hint::black_box,
    num::NonZeroUsize,
    sync::atomic::{AtomicUsize, Ordering},
    time::Instant,
};
struct CountSystem;
static CALLS: AtomicUsize = AtomicUsize::new(0);
static BYTES: AtomicUsize = AtomicUsize::new(0);
// SAFETY: every operation forwards the exact pointer/layout to System; no memory
// is inspected or retained. Atomic counters are nonallocating. This instrumentation
// is isolated to the example and does not replace any production ownership proof.
unsafe impl GlobalAlloc for CountSystem {
    unsafe fn alloc(&self, l: Layout) -> *mut u8 {
        let p = unsafe { System.alloc(l) };
        if !p.is_null() {
            CALLS.fetch_add(1, Ordering::Relaxed);
            BYTES.fetch_add(l.size(), Ordering::Relaxed);
        }
        p
    }
    unsafe fn alloc_zeroed(&self, l: Layout) -> *mut u8 {
        let p = unsafe { System.alloc_zeroed(l) };
        if !p.is_null() {
            CALLS.fetch_add(1, Ordering::Relaxed);
            BYTES.fetch_add(l.size(), Ordering::Relaxed);
        }
        p
    }
    unsafe fn dealloc(&self, p: *mut u8, l: Layout) {
        unsafe { System.dealloc(p, l) }
    }
    unsafe fn realloc(&self, p: *mut u8, l: Layout, n: usize) -> *mut u8 {
        let q = unsafe { System.realloc(p, l, n) };
        if !q.is_null() {
            CALLS.fetch_add(1, Ordering::Relaxed);
            BYTES.fetch_add(n, Ordering::Relaxed);
        }
        q
    }
}
#[global_allocator]
static ALLOC: CountSystem = CountSystem;
fn counters() -> (usize, usize) {
    (CALLS.load(Ordering::Relaxed), BYTES.load(Ordering::Relaxed))
}
fn delta(a: (usize, usize)) -> (usize, usize) {
    let b = counters();
    (b.0 - a.0, b.1 - a.1)
}
fn nz(n: usize) -> NonZeroUsize {
    NonZeroUsize::new(n).unwrap()
}
fn main() {
    let rounds = std::env::args()
        .nth(1)
        .map(|v| v.parse::<usize>().unwrap())
        .unwrap_or(12);
    assert!(rounds > 0);
    println!(
        "kind,items,workers,rounds,mean_ns,alloc_calls,requested_alloc_bytes,payload_bytes,checksum"
    );
    for instances in [16, 256, 4096] {
        let a = counters();
        let template: Vec<_> = (0..64)
            .map(|i| LocalRect {
                x: (i % 8) * 8,
                y: (i / 8) * 8,
                width: 7,
                height: 7,
            })
            .collect();
        let placement: Vec<_> = (0..instances)
            .map(|i| Placement {
                x: (i % 8) * 64,
                y: (i % 7) * 64,
            })
            .collect();
        let mut output: Vec<_> = (0..instances)
            .map(|_| OutputPage::new(template.len()))
            .collect();
        let allocations = delta(a);
        let bytes = instances as usize * template.len() * std::mem::size_of::<PlacedRect>();
        println!(
            "phase_setup,{},0,1,0,{},{},{bytes},0",
            instances * 64,
            allocations.0,
            allocations.1
        );
        for workers in [1, 2, 4] {
            let execution = if workers == 1 {
                Execution::Serial
            } else {
                Execution::Scoped {
                    workers: nz(workers),
                }
            };
            let _ = BorrowedPhase::new(&template, &placement, &mut output)
                .unwrap()
                .run(execution);
            let a = counters();
            let start = Instant::now();
            let mut checksum = 0;
            for _ in 0..rounds {
                checksum ^= black_box(
                    BorrowedPhase::new(&template, &placement, &mut output)
                        .unwrap()
                        .run(execution),
                )
                .damage;
            }
            let ns = start.elapsed().as_nanos() / rounds as u128;
            let allocations = delta(a);
            println!(
                "phase,{},{workers},{rounds},{ns},{},{},{bytes},{checksum}",
                instances * 64,
                allocations.0,
                allocations.1
            );
        }
    }
    let a = counters();
    let (mut producer, mut consumer) = page_lane(nz(2));
    let page = OwnedPage::new(0, vec![0u64; 1024].into_boxed_slice());
    let address = page.data().as_ptr();
    let allocations = delta(a);
    println!(
        "ring_setup,1024,0,1,0,{},{},8192,0",
        allocations.0, allocations.1
    );
    let mut slots = [None];
    let mut returned = [None];
    let mut page = page;
    let loops = 100_000;
    let a = counters();
    let start = Instant::now();
    for i in 0..loops {
        page.set_sequence(i);
        page.data_mut()[0] = i;
        let _ = producer.publish(page).unwrap();
        let _ = consumer.drain(&mut slots).unwrap();
        let lease = slots[0].take().unwrap();
        assert_eq!(lease.data().as_ptr(), address);
        let _ = consumer.recycle(lease.complete()).unwrap();
        let _ = producer.reclaim(&mut returned).unwrap();
        page = returned[0].take().unwrap();
    }
    let ns = start.elapsed().as_nanos() / loops as u128;
    let allocations = delta(a);
    println!(
        "ring_roundtrip,1024,1,{loops},{ns},{},{},8192,{}",
        allocations.0,
        allocations.1,
        page.data()[0]
    );
    assert_eq!(
        allocations.0, 0,
        "warm ownership transfer must not allocate"
    );
    // Scope creation, Rust thread bookkeeping, and startup are INSIDE this window.
    let a = counters();
    let start = Instant::now();
    let page = std::thread::scope(|scope| {
        scope.spawn(move || {
            let mut slots = [None];
            for _ in 0..loops {
                loop {
                    let _ = consumer.drain(&mut slots).unwrap();
                    if let Some(lease) = slots[0].take() {
                        let _ = consumer.recycle(lease.complete()).unwrap();
                        break;
                    }
                    std::thread::yield_now();
                }
            }
        });
        let mut page = page;
        let mut returned = [None];
        for i in 0..loops {
            page.set_sequence(i);
            page.data_mut()[0] = i;
            let _ = producer.publish(page).unwrap();
            page = loop {
                let _ = producer.reclaim(&mut returned).unwrap();
                if let Some(page) = returned[0].take() {
                    break page;
                }
                std::thread::yield_now();
            };
        }
        page
    });
    let ns = start.elapsed().as_nanos() / loops as u128;
    let allocations = delta(a);
    println!(
        "ring_scoped_roundtrip,1024,2,{loops},{ns},{},{},8192,{}",
        allocations.0,
        allocations.1,
        page.data()[0]
    );
}
