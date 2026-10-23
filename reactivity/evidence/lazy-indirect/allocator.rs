use core::cell::UnsafeCell;
use std::alloc::{GlobalAlloc, Layout, System};

struct AllocationTrace {
    enabled: bool,
    // Calls, requested bytes, frees, freed bytes, retained new bytes,
    // bytes freed from allocations predating this interval, tracking overflow.
    counts: [u64; 7],
    live: [(usize, usize); 4096],
}
std::thread_local! {
    static ALLOCATIONS: UnsafeCell<AllocationTrace> = const { UnsafeCell::new(AllocationTrace {
        enabled: false, counts: [0; 7], live: [(0, 0); 4096],
    }) };
}
struct Counted;
fn allocation(ptr: *mut u8, size: usize, old: Option<(*mut u8, usize)>) {
    let _ = ALLOCATIONS.try_with(|trace| {
        // SAFETY: This is thread-local state; this callback only scans fixed
        // arrays and cannot allocate or reenter the allocator.
        let trace = unsafe { &mut *trace.get() };
        if !trace.enabled {
            return;
        }
        if let Some((old_ptr, old_size)) = old {
            trace.counts[2] += 1;
            trace.counts[3] += old_size as u64;
            if let Some(slot) = trace
                .live
                .iter_mut()
                .find(|slot| slot.0 == old_ptr as usize)
            {
                trace.counts[4] -= slot.1 as u64;
                *slot = (0, 0);
            } else {
                trace.counts[5] += old_size as u64;
            }
        }
        if !ptr.is_null() {
            trace.counts[0] += 1;
            trace.counts[1] += size as u64;
            trace.counts[4] += size as u64;
            if let Some(slot) = trace.live.iter_mut().find(|slot| slot.0 == 0) {
                *slot = (ptr as usize, size);
            } else {
                trace.counts[6] += 1;
            }
        }
    });
}
unsafe impl GlobalAlloc for Counted {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
        let ptr = unsafe { System.alloc(layout) };
        if !ptr.is_null() {
            allocation(ptr, layout.size(), None);
        }
        ptr
    }
    unsafe fn alloc_zeroed(&self, layout: Layout) -> *mut u8 {
        let ptr = unsafe { System.alloc_zeroed(layout) };
        if !ptr.is_null() {
            allocation(ptr, layout.size(), None);
        }
        ptr
    }
    unsafe fn dealloc(&self, ptr: *mut u8, layout: Layout) {
        allocation(core::ptr::null_mut(), 0, Some((ptr, layout.size())));
        unsafe { System.dealloc(ptr, layout) };
    }
    unsafe fn realloc(&self, ptr: *mut u8, old: Layout, new: usize) -> *mut u8 {
        let result = unsafe { System.realloc(ptr, old, new) };
        if !result.is_null() {
            allocation(result, new, Some((ptr, old.size())));
        }
        result
    }
}
#[global_allocator]
static ALLOCATOR: Counted = Counted;
struct StopTrace;
impl Drop for StopTrace {
    fn drop(&mut self) {
        ALLOCATIONS.with(|trace| {
            // SAFETY: Access is thread-local and never allocates.
            unsafe {
                (*trace.get()).enabled = false;
            }
        });
    }
}
fn measured<T>(f: impl FnOnce() -> T) -> (T, [u64; 7]) {
    let already_enabled = ALLOCATIONS.with(|trace| {
        // SAFETY: Access is thread-local and never allocates.
        unsafe { (*trace.get()).enabled }
    });
    assert!(!already_enabled);
    ALLOCATIONS.with(|trace| {
        // SAFETY: Access is thread-local and never allocates.
        let trace = unsafe { &mut *trace.get() };
        trace.counts = [0; 7];
        trace.live.fill((0, 0));
        trace.enabled = true;
    });
    let stop = StopTrace;
    let result = f();
    drop(stop);
    let counts = ALLOCATIONS.with(|trace| {
        // SAFETY: Access is thread-local and never allocates.
        unsafe { (*trace.get()).counts }
    });
    assert_eq!(counts[6], 0, "allocation tracking overflow");
    (result, counts)
}
