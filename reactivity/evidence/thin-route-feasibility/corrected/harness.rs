#![allow(dead_code)]
use std::{
    alloc::{GlobalAlloc, Layout, System},
    marker::PhantomData,
    mem::{forget, offset_of, size_of},
    ptr::{drop_in_place, NonNull},
    sync::atomic::{AtomicPtr, AtomicUsize, Ordering},
};

static ALLOCS: AtomicUsize = AtomicUsize::new(0);
static DEALLOCS: AtomicUsize = AtomicUsize::new(0);
static LAST_SIZE: AtomicUsize = AtomicUsize::new(0);
static LAST_ALIGN: AtomicUsize = AtomicUsize::new(0);
static LAST_PTR: AtomicPtr<u8> = AtomicPtr::new(std::ptr::null_mut());
static WATCH_PTR: AtomicPtr<u8> = AtomicPtr::new(std::ptr::null_mut());
static WATCH_FREES: AtomicUsize = AtomicUsize::new(0);
static ZST_DROPS: AtomicUsize = AtomicUsize::new(0);
static ALIGNED_ZST_DROPS: AtomicUsize = AtomicUsize::new(0);
static PANIC_ZST_DROPS: AtomicUsize = AtomicUsize::new(0);
static PANIC_DROPS: AtomicUsize = AtomicUsize::new(0);

struct Counting;
unsafe impl GlobalAlloc for Counting {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
        ALLOCS.fetch_add(1, Ordering::SeqCst);
        LAST_SIZE.store(layout.size(), Ordering::SeqCst);
        LAST_ALIGN.store(layout.align(), Ordering::SeqCst);
        let ptr = unsafe { System.alloc(layout) };
        LAST_PTR.store(ptr, Ordering::SeqCst);
        ptr
    }
    unsafe fn dealloc(&self, ptr: *mut u8, layout: Layout) {
        DEALLOCS.fetch_add(1, Ordering::SeqCst);
        if ptr == WATCH_PTR.load(Ordering::SeqCst) {
            WATCH_FREES.fetch_add(1, Ordering::SeqCst);
        }
        unsafe { System.dealloc(ptr, layout) }
    }
    unsafe fn realloc(&self, ptr: *mut u8, layout: Layout, n: usize) -> *mut u8 {
        unsafe { System.realloc(ptr, layout, n) }
    }
}
#[global_allocator]
static ALLOC: Counting = Counting;

#[repr(C, align(2))]
struct Ops {
    call: unsafe fn(*const (), usize) -> usize,
    drop: unsafe fn(*mut ()),
}
#[repr(C)]
struct Header<T> {
    ops: &'static Ops,
    value: T,
}
#[repr(C)]
struct Prefix {
    ops: &'static Ops,
}

trait Route {
    fn call(&self, x: usize) -> usize;
}
// Keep the production trait object-safe; associated const lives on a separate
// blanket helper. Generic const promotion is the static table source under test.
trait RouteOpsFor: Route + 'static {
    const OPS: &'static Ops;
}
impl<T: Route + 'static> RouteOpsFor for T {
    const OPS: &'static Ops = &Ops {
        call: call_impl::<T>,
        drop: drop_impl::<T>,
    };
}
unsafe fn call_impl<T: Route + 'static>(base: *const (), x: usize) -> usize {
    let value = if size_of::<T>() == 0 {
        unsafe { &*NonNull::<T>::dangling().as_ptr() }
    } else {
        unsafe { &(*base.cast::<Header<T>>()).value }
    };
    value.call(x)
}
unsafe fn drop_impl<T: Route + 'static>(base: *mut ()) {
    if size_of::<T>() == 0 {
        unsafe { drop_in_place(NonNull::<T>::dangling().as_ptr()) };
    } else {
        // Box drop glue owns both T and its exact Header<T> allocation on unwind.
        unsafe { drop(Box::from_raw(base.cast::<Header<T>>())) };
    }
}

#[repr(transparent)]
struct Handler {
    ptr: NonNull<()>,
    _owns: PhantomData<Box<dyn Route>>,
}
impl Handler {
    fn new<T: RouteOpsFor + 'static>(value: T) -> Self {
        let ops = T::OPS;
        if size_of::<T>() == 0 {
            // Transfer logical ZST ownership; otherwise `value` drops here.
            forget(value);
            let p = NonNull::from(ops).cast::<()>();
            let ptr = p.map_addr(|a| std::num::NonZeroUsize::new(a.get() | 1).unwrap());
            Self { ptr, _owns: PhantomData }
        } else {
            let p = Box::into_raw(Box::new(Header { ops, value })).cast::<()>();
            Self { ptr: NonNull::new(p).unwrap(), _owns: PhantomData }
        }
    }
    fn tagged(&self) -> bool { self.ptr.as_ptr().addr() & 1 != 0 }
    fn dispatch(&self) -> (&'static Ops, *const ()) {
        unsafe {
            if self.tagged() {
                let p = self.ptr.map_addr(|a| std::num::NonZeroUsize::new(a.get() & !1).unwrap());
                (&*p.as_ptr().cast::<Ops>(), p.as_ptr().cast_const())
            } else {
                let p = self.ptr.as_ptr();
                ((&*p.cast::<Prefix>()).ops, p.cast_const())
            }
        }
    }
    fn call(&self, x: usize) -> usize {
        let (ops, base) = self.dispatch();
        unsafe { (ops.call)(base, x) }
    }
}
impl Drop for Handler {
    fn drop(&mut self) {
        let (ops, base) = self.dispatch();
        unsafe { (ops.drop)(base.cast_mut()) }
    }
}

struct Method;
impl Route for Method { fn call(&self, x: usize) -> usize { x + 1 } }
struct Other;
impl Route for Other { fn call(&self, x: usize) -> usize { x + 2 } }
struct ZstDrop;
impl Route for ZstDrop { fn call(&self, x: usize) -> usize { x + 3 } }
impl Drop for ZstDrop { fn drop(&mut self) { ZST_DROPS.fetch_add(1, Ordering::SeqCst); } }
#[repr(align(128))]
struct AlignedZstDrop;
impl Route for AlignedZstDrop {
    fn call(&self, x: usize) -> usize {
        assert_eq!((self as *const Self as usize) % 128, 0);
        x + 4
    }
}
impl Drop for AlignedZstDrop {
    fn drop(&mut self) {
        assert_eq!((self as *mut Self as usize) % 128, 0);
        ALIGNED_ZST_DROPS.fetch_add(1, Ordering::SeqCst);
    }
}
struct PanicZst;
impl Route for PanicZst { fn call(&self, x: usize) -> usize { x + 5 } }
impl Drop for PanicZst {
    fn drop(&mut self) {
        PANIC_ZST_DROPS.fetch_add(1, Ordering::SeqCst);
        panic!("zst drop");
    }
}
struct Capture(usize);
impl Route for Capture { fn call(&self, x: usize) -> usize { x + self.0 } }
#[repr(align(64))]
struct Aligned(u8);
impl Route for Aligned { fn call(&self, x: usize) -> usize { x + self.0 as usize } }
struct PanicDrop(u8);
impl Route for PanicDrop { fn call(&self, x: usize) -> usize { x + self.0 as usize } }
impl Drop for PanicDrop { fn drop(&mut self) { PANIC_DROPS.fetch_add(1, Ordering::SeqCst); panic!("drop"); } }

struct Borrowed<'a>(&'a ());
impl Route for Borrowed<'_> { fn call(&self, x: usize) -> usize { x } }

#[cfg(negative_lifetime)]
fn borrowed_route_must_be_rejected<'a>(value: &'a ()) {
    let _ = Handler::new(Borrowed(value));
}

fn assert_unpin<T: Unpin>() {}

fn object_safe(_: &dyn Route) {}
fn main() {
    std::panic::set_hook(Box::new(|_| {}));
    assert_eq!(size_of::<Handler>(), size_of::<usize>());
    assert_eq!(size_of::<Option<Handler>>(), size_of::<usize>());
    assert_eq!(size_of::<Header<Capture>>(), 16);
    assert_eq!(size_of::<Header<Aligned>>(), 128);
    assert_eq!(offset_of!(Header<Aligned>, value), 64);
    assert_unpin::<Handler>();
    assert_eq!(Handler::new(Method).call(10), 11);
    assert_eq!(Handler::new(Other).call(10), 12);

    let before = ALLOCS.load(Ordering::SeqCst);
    let z = Handler::new(ZstDrop);
    assert_eq!(ALLOCS.load(Ordering::SeqCst) - before, 0);
    assert_eq!(ZST_DROPS.load(Ordering::SeqCst), 0);
    assert_eq!(z.call(10), 13);
    drop(z);
    assert_eq!(ZST_DROPS.load(Ordering::SeqCst), 1);

    let before_aligned_zst = ALLOCS.load(Ordering::SeqCst);
    let aligned_zst = Handler::new(AlignedZstDrop);
    assert_eq!(size_of::<AlignedZstDrop>(), 0);
    assert_eq!(std::mem::align_of::<AlignedZstDrop>(), 128);
    assert_eq!(ALLOCS.load(Ordering::SeqCst) - before_aligned_zst, 0);
    assert_eq!(aligned_zst.call(10), 14);
    drop(aligned_zst);
    assert_eq!(ALIGNED_ZST_DROPS.load(Ordering::SeqCst), 1);

    let before_panic_zst = ALLOCS.load(Ordering::SeqCst);
    let panic_zst = Handler::new(PanicZst);
    assert_eq!(ALLOCS.load(Ordering::SeqCst) - before_panic_zst, 0);
    assert!(std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| drop(panic_zst))).is_err());
    assert_eq!(PANIC_ZST_DROPS.load(Ordering::SeqCst), 1);

    let before_a = ALLOCS.load(Ordering::SeqCst);
    let before_d = DEALLOCS.load(Ordering::SeqCst);
    let c = Handler::new(Capture(7));
    assert_eq!(ALLOCS.load(Ordering::SeqCst) - before_a, 1);
    assert_eq!(LAST_SIZE.load(Ordering::SeqCst), size_of::<Header<Capture>>());
    assert_eq!(LAST_ALIGN.load(Ordering::SeqCst), 8);
    assert_eq!(c.call(5), 12);
    drop(c);
    assert_eq!(DEALLOCS.load(Ordering::SeqCst) - before_d, 1);

    let before = ALLOCS.load(Ordering::SeqCst);
    let a = Handler::new(Aligned(9));
    assert_eq!(ALLOCS.load(Ordering::SeqCst) - before, 1);
    assert_eq!(LAST_SIZE.load(Ordering::SeqCst), 128);
    assert_eq!(LAST_ALIGN.load(Ordering::SeqCst), 64);
    assert_eq!(a.call(1), 10);
    drop(a);

    let before = ALLOCS.load(Ordering::SeqCst);
    let p = Handler::new(PanicDrop(1));
    assert_eq!(ALLOCS.load(Ordering::SeqCst) - before, 1);
    WATCH_FREES.store(0, Ordering::SeqCst);
    WATCH_PTR.store(LAST_PTR.load(Ordering::SeqCst), Ordering::SeqCst);
    assert!(std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| drop(p))).is_err());
    assert_eq!(PANIC_DROPS.load(Ordering::SeqCst), 1);
    assert_eq!(WATCH_FREES.load(Ordering::SeqCst), 1);
    println!("PASS handler={} option={} header_capture=16 header_aligned=128 zst_alloc_delta=0 aligned_zst_drop=1 zst_panic_drop=1 capture_alloc_delta=1", size_of::<Handler>(), size_of::<Option<Handler>>());
}
