use schema_slot_audit::production::{
    Describe, Field, ProvideShape as _, Schema, Type, TypeProbe, TypeRegistration, Value,
};
use std::alloc::{GlobalAlloc, Layout, System};
use std::hint::black_box;
use std::sync::atomic::{AtomicUsize, Ordering};

struct Counting;
static ALLOCS: AtomicUsize = AtomicUsize::new(0);
unsafe impl GlobalAlloc for Counting {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
        ALLOCS.fetch_add(1, Ordering::Relaxed);
        unsafe { System.alloc(layout) }
    }
    unsafe fn dealloc(&self, ptr: *mut u8, layout: Layout) {
        unsafe { System.dealloc(ptr, layout) }
    }
    unsafe fn realloc(&self, ptr: *mut u8, layout: Layout, size: usize) -> *mut u8 {
        ALLOCS.fetch_add(1, Ordering::Relaxed);
        unsafe { System.realloc(ptr, layout, size) }
    }
}
#[global_allocator]
static ALLOC: Counting = Counting;

struct Discovered {
    value: u64,
}
impl Describe for Discovered {
    fn build_type() -> Schema<Self> {
        Schema::new(
            vec![
                Field::new("value", |v: &Self| &v.value, |v| &mut v.value)
                    .into_schema(|| Type::opaque::<u64>()),
            ],
            None,
        )
    }
}
inventory::submit! { TypeRegistration::of::<Discovered>() }

struct Parent {
    items: Vec<Discovered>,
}
impl Describe for Parent {
    fn build_type() -> Schema<Self> {
        Schema::new(
            vec![
                Field::new("items", |v: &Self| &v.items, |v| &mut v.items).into_schema(|| {
                    (&TypeProbe::<Vec<Discovered>>::new()).provide();
                    (&TypeProbe::<Discovered>::new()).provide();
                    Type::discover::<Vec<Discovered>>()
                }),
            ],
            None,
        )
    }
}

fn main() {
    let old = Type::opaque::<Discovered>();
    ALLOCS.store(0, Ordering::SeqCst);
    let discovered = black_box(Type::discover::<Discovered>());
    println!(
        "first inventory discovery allocations: {} (old handle upgraded: {})",
        ALLOCS.load(Ordering::SeqCst),
        old.kind() == schema_slot_audit::production::TypeKind::Struct,
    );
    assert_eq!(discovered, old);

    ALLOCS.store(0, Ordering::SeqCst);
    for _ in 0..100_000 {
        black_box(Type::discover::<Discovered>());
    }
    println!(
        "warm inventory discovery allocations: {} / 100000",
        ALLOCS.load(Ordering::SeqCst),
    );

    let parent = Parent {
        items: vec![Discovered { value: 17 }],
    };
    ALLOCS.store(0, Ordering::SeqCst);
    let parent_type = Type::of::<Parent>();
    let _ = parent_type.fields().next();
    let value = Value::new(&parent);
    let items = value.field("items").unwrap();
    let _ = items.index(0);
    println!(
        "first provided sequence and child resolution allocations: {}",
        ALLOCS.load(Ordering::SeqCst),
    );

    ALLOCS.store(0, Ordering::SeqCst);
    for _ in 0..100_000 {
        let value = Value::new(black_box(&parent));
        let items = value.field("items").unwrap();
        black_box(items.index(0));
    }
    println!(
        "warm reflected field+index allocations: {} / 100000",
        ALLOCS.load(Ordering::SeqCst),
    );
}
