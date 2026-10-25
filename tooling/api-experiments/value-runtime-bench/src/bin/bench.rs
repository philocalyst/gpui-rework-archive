use std::{
    alloc::{GlobalAlloc, Layout, System},
    hint::black_box,
    sync::atomic::{AtomicUsize, Ordering},
    time::Instant,
};
use value_runtime_bench::{Describe, Field, Role, Schema, Type, TypedPath, ValueMut};

struct Counting;
static ALLOCATIONS: AtomicUsize = AtomicUsize::new(0);
unsafe impl GlobalAlloc for Counting {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
        ALLOCATIONS.fetch_add(1, Ordering::Relaxed);
        unsafe { System.alloc(layout) }
    }
    unsafe fn dealloc(&self, ptr: *mut u8, layout: Layout) {
        unsafe { System.dealloc(ptr, layout) }
    }
    unsafe fn realloc(&self, ptr: *mut u8, layout: Layout, size: usize) -> *mut u8 {
        ALLOCATIONS.fetch_add(1, Ordering::Relaxed);
        unsafe { System.realloc(ptr, layout, size) }
    }
}
#[global_allocator]
static ALLOCATOR: Counting = Counting;

struct Inner {
    value: u64,
}
struct Root {
    value: u64,
    inner: Inner,
    role_value: u64,
}
trait CounterRole {
    fn bump(&mut self);
}
impl CounterRole for Root {
    fn bump(&mut self) {
        self.role_value = self.role_value.wrapping_add(1);
    }
}
fn inner_shape() -> Type {
    Inner::type_shape()
}
impl Describe for Inner {
    fn build_type() -> Schema<Self> {
        Schema::new(
            vec![
                Field::new("value", |r: &Self| &r.value, |r| &mut r.value)
                    .into_schema(Type::opaque::<u64>),
            ],
            None,
        )
    }
}
impl Describe for Root {
    fn build_type() -> Schema<Self> {
        Schema::with_roles(
            vec![
                Field::new("value", |r: &Self| &r.value, |r| &mut r.value)
                    .into_schema(Type::opaque::<u64>),
                Field::new("inner", |r: &Self| &r.inner, |r| &mut r.inner).into_schema(inner_shape),
                Field::new(
                    "role_value",
                    |r: &Self| &r.role_value,
                    |r| &mut r.role_value,
                )
                .into_schema(Type::opaque::<u64>),
            ],
            None,
            vec![Role::<Self, dyn CounterRole>::new(|root| root).into_schema()],
        )
    }
}

fn root_value() -> Root {
    Root {
        value: 0,
        inner: Inner { value: 0 },
        role_value: 0,
    }
}
const ITERATIONS: usize = 5_000_000;
const SAMPLES: usize = 11;

fn native_field(root: &mut Root, n: usize) -> u64 {
    let root = black_box(root);
    let mut sum = 0u64;
    for _ in 0..n {
        let value = black_box(&mut root.value);
        *value = value.wrapping_add(1);
        sum = sum.wrapping_add(*value);
    }
    black_box(sum)
}
fn typed_handle(root: &mut Root, n: usize) -> u64 {
    let field = Field::<Root, u64>::new("value", |r| &r.value, |r| &mut r.value);
    let root = black_box(root);
    let mut sum = 0u64;
    for _ in 0..n {
        let value = black_box(field.get_mut(root));
        *value = value.wrapping_add(1);
        sum = sum.wrapping_add(*value);
    }
    black_box(sum)
}
fn typed_path(root: &mut Root, n: usize) -> u64 {
    let field = Field::<Root, u64>::new("value", |r| &r.value, |r| &mut r.value);
    let mut erased = ValueMut::new(black_box(root));
    let mut sum = 0u64;
    for _ in 0..n {
        let value = black_box(erased.at(field).unwrap());
        *value = value.wrapping_add(1);
        sum = sum.wrapping_add(*value);
    }
    black_box(sum)
}
fn typed_composed_path(root: &mut Root, n: usize) -> u64 {
    let outer = Field::<Root, Inner>::new("inner", |r| &r.inner, |r| &mut r.inner);
    let inner = Field::<Inner, u64>::new("value", |r| &r.value, |r| &mut r.value);
    let path = outer.then(inner);
    let mut erased = ValueMut::new(black_box(root));
    let mut sum = 0u64;
    for _ in 0..n {
        let value = black_box(erased.at(path).unwrap());
        *value = value.wrapping_add(1);
        sum = sum.wrapping_add(*value);
    }
    black_box(sum)
}
fn dynamic_chain(root: &mut Root, n: usize) -> u64 {
    let mut erased = ValueMut::new(black_box(root));
    let mut sum = 0u64;
    for _ in 0..n {
        let mut child = erased.field("inner").unwrap();
        let mut leaf = child.field("value").unwrap();
        let value = black_box(leaf.downcast_mut::<u64>().unwrap());
        *value = value.wrapping_add(1);
        sum = sum.wrapping_add(*value);
    }
    black_box(sum)
}
fn native_role(root: &mut Root, n: usize) -> u64 {
    let role: &mut dyn CounterRole = black_box(root);
    for _ in 0..n {
        black_box(&mut *role).bump();
    }
    black_box(root.role_value)
}
fn value_role(root: &mut Root, n: usize) -> u64 {
    let mut erased = ValueMut::new(black_box(root));
    for _ in 0..n {
        erased.cast_mut::<dyn CounterRole>().unwrap().bump();
    }
    black_box(erased.downcast_ref::<Root>().unwrap().role_value)
}
fn prepared_value_role(root: &mut Root, n: usize) -> u64 {
    let projection = Root::type_shape().role::<dyn CounterRole>().unwrap();
    for _ in 0..n {
        projection.get_mut(black_box(root)).unwrap().bump();
    }
    black_box(root.role_value)
}
fn cached_value_role(root: &mut Root, n: usize) -> u64 {
    let mut erased = ValueMut::new(black_box(root));
    {
        let role = erased.cast_mut::<dyn CounterRole>().unwrap();
        for _ in 0..n {
            black_box(&mut *role).bump();
        }
    }
    black_box(erased.downcast_ref::<Root>().unwrap().role_value)
}

trait IndexedRole<const ID: usize> {
    fn bump(&mut self);
}
struct ManyRole<const COUNT: usize> {
    value: u64,
}
impl<const COUNT: usize, const ID: usize> IndexedRole<ID> for ManyRole<COUNT> {
    fn bump(&mut self) {
        self.value = self.value.wrapping_add(1);
    }
}
macro_rules! role_registrations {
    ($($id:literal),* $(,)?) => {
        vec![$(Role::<Self, dyn IndexedRole<$id>>::new(|root| root).into_schema()),*]
    };
}
macro_rules! role_candidates {
    ($($id:literal),* $(,)?) => {
        vec![$((
            std::any::TypeId::of::<dyn IndexedRole<$id>>(),
            $id,
            native_indexed_role::<COUNT, $id> as fn(&mut ManyRole<COUNT>, usize) -> u64,
            reflected_indexed_role::<COUNT, $id> as fn(&mut ManyRole<COUNT>, usize) -> u64,
            cached_indexed_role::<COUNT, $id> as fn(&mut ManyRole<COUNT>, usize) -> u64,
            prepared_indexed_role::<COUNT, $id> as fn(&mut ManyRole<COUNT>, usize) -> u64,
        )),*]
    };
}
impl<const COUNT: usize> Describe for ManyRole<COUNT> {
    fn build_type() -> Schema<Self> {
        let roles = match COUNT {
            3 => role_registrations!(0, 1, 2),
            8 => role_registrations!(0, 1, 2, 3, 4, 5, 6, 7),
            9 => role_registrations!(0, 1, 2, 3, 4, 5, 6, 7, 8),
            32 => role_registrations!(
                0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22,
                23, 24, 25, 26, 27, 28, 29, 30, 31
            ),
            64 => role_registrations!(
                0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22,
                23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43,
                44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63
            ),
            _ => panic!("unsupported role count"),
        };
        Schema::with_roles(vec![], None, roles)
    }
}

fn native_indexed_role<const COUNT: usize, const ID: usize>(
    root: &mut ManyRole<COUNT>,
    n: usize,
) -> u64 {
    let role: &mut dyn IndexedRole<ID> = black_box(root);
    for _ in 0..n {
        black_box(&mut *role).bump();
    }
    black_box(root.value)
}
fn reflected_indexed_role<const COUNT: usize, const ID: usize>(
    root: &mut ManyRole<COUNT>,
    n: usize,
) -> u64 {
    let mut erased = ValueMut::new(black_box(root));
    for _ in 0..n {
        erased.cast_mut::<dyn IndexedRole<ID>>().unwrap().bump();
    }
    black_box(erased.downcast_ref::<ManyRole<COUNT>>().unwrap().value)
}
fn cached_indexed_role<const COUNT: usize, const ID: usize>(
    root: &mut ManyRole<COUNT>,
    n: usize,
) -> u64 {
    let mut erased = ValueMut::new(black_box(root));
    {
        let role = erased.cast_mut::<dyn IndexedRole<ID>>().unwrap();
        for _ in 0..n {
            black_box(&mut *role).bump();
        }
    }
    black_box(erased.downcast_ref::<ManyRole<COUNT>>().unwrap().value)
}
fn prepared_indexed_role<const COUNT: usize, const ID: usize>(
    root: &mut ManyRole<COUNT>,
    n: usize,
) -> u64 {
    let projection = ManyRole::<COUNT>::type_shape()
        .role::<dyn IndexedRole<ID>>()
        .unwrap();
    for _ in 0..n {
        projection.get_mut(black_box(root)).unwrap().bump();
    }
    black_box(root.value)
}

fn measure_generic<R>(
    label: &str,
    root: fn() -> R,
    operation: fn(&mut R, usize) -> u64,
) -> (f64, usize, u64) {
    let mut value = root();
    black_box(operation(&mut value, 1));
    ALLOCATIONS.store(0, Ordering::SeqCst);
    black_box(operation(&mut value, 100));
    let allocations = ALLOCATIONS.load(Ordering::SeqCst);
    assert_eq!(allocations, 0, "warm operation {label} allocated");
    let mut timings = Vec::with_capacity(SAMPLES);
    let mut checksum = 0u64;
    for _ in 0..SAMPLES {
        let start = Instant::now();
        checksum = checksum.wrapping_add(operation(&mut value, ITERATIONS));
        timings.push(start.elapsed().as_nanos() as f64 / ITERATIONS as f64);
    }
    timings.sort_by(f64::total_cmp);
    (timings[SAMPLES / 2], allocations, checksum)
}

fn run_role_count<const COUNT: usize>(label: &str) {
    let root = || ManyRole::<COUNT> { value: 0 };
    let mut candidates = match COUNT {
        3 => role_candidates!(0, 1, 2),
        8 => role_candidates!(0, 1, 2, 3, 4, 5, 6, 7),
        9 => role_candidates!(0, 1, 2, 3, 4, 5, 6, 7, 8),
        32 => role_candidates!(
            0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23,
            24, 25, 26, 27, 28, 29, 30, 31
        ),
        64 => role_candidates!(
            0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23,
            24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45,
            46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63
        ),
        _ => panic!("unsupported role count"),
    };
    candidates.sort_unstable_by_key(|entry| entry.0);
    let (_, target_tag, native, reflected, cached, prepared) = *candidates.last().unwrap();
    println!("{label}: target_tag={target_tag} (greatest TypeId in sorted role table)");
    for (kind, operation) in [
        ("native", native),
        ("cast_mut_each_call", reflected),
        ("cast_mut_once_cached_borrow", cached),
        ("prepared_projection_get_mut_each_call", prepared),
    ] {
        let full_label = format!("{label}_{kind}");
        let (ns, allocations, checksum) = measure_generic(&full_label, root, operation);
        println!(
            "{full_label}: median_ns_op={ns:.2} warm_allocations_per_100_ops={allocations} checksum={checksum}"
        );
    }
}

fn measure(label: &str, operation: fn(&mut Root, usize) -> u64) -> (f64, usize, u64) {
    let mut root = root_value();
    black_box(operation(&mut root, 1)); // Warm caches and branch paths before measurements.
    ALLOCATIONS.store(0, Ordering::SeqCst);
    black_box(operation(&mut root, 100));
    let allocations = ALLOCATIONS.load(Ordering::SeqCst);
    assert_eq!(allocations, 0, "warm operation {label} allocated");

    let mut timings = Vec::with_capacity(SAMPLES);
    let mut checksum = 0u64;
    for _ in 0..SAMPLES {
        let start = Instant::now();
        checksum = checksum.wrapping_add(operation(&mut root, ITERATIONS));
        timings.push(start.elapsed().as_nanos() as f64 / ITERATIONS as f64);
    }
    timings.sort_by(f64::total_cmp);
    (timings[SAMPLES / 2], allocations, checksum)
}

struct ColdNode {
    _children: Vec<ColdNode>,
    _selected: Option<Box<ColdNode>>,
}
impl Describe for ColdNode {
    fn build_type() -> Schema<Self> {
        Schema::new(
            vec![
                Field::new("children", |r: &Self| &r._children, |r| &mut r._children)
                    .into_schema(|| Type::vec::<ColdNode>(ColdNode::type_shape)),
                Field::new("selected", |r: &Self| &r._selected, |r| &mut r._selected).into_schema(
                    || Type::option::<Box<ColdNode>>(|| Type::opaque::<Box<ColdNode>>()),
                ),
            ],
            None,
        )
    }
}

fn main() {
    let schema_start = Instant::now();
    ALLOCATIONS.store(0, Ordering::SeqCst);
    let cold = Type::of::<ColdNode>();
    let cold_allocations = ALLOCATIONS.load(Ordering::SeqCst);
    let cold_time = schema_start.elapsed();
    black_box(cold);
    println!(
        "cold_schema=ColdNode time_ns={} allocations={cold_allocations}",
        cold_time.as_nanos()
    );

    for (label, operation) in [
        ("native_field", native_field as fn(&mut Root, usize) -> u64),
        ("typed_handle", typed_handle),
        ("ValueMut_at", typed_path),
        ("typed_then_path", typed_composed_path),
        ("dynamic_field_chain", dynamic_chain),
        ("native_trait_role", native_role),
        ("ValueMut_cast_mut_role", value_role),
        ("ValueMut_cached_role_borrow", cached_value_role),
        ("prepared_role_projection_get_mut", prepared_value_role),
    ] {
        let (ns, allocations, checksum) = measure(label, operation);
        println!(
            "{label}: median_ns_op={ns:.2} warm_allocations_per_100_ops={allocations} checksum={checksum}"
        );
    }

    run_role_count::<3>("roles_3_worst_target");
    run_role_count::<8>("roles_8_worst_target");
    run_role_count::<9>("roles_9_worst_target");
    run_role_count::<32>("roles_32_worst_target");
    run_role_count::<64>("roles_64_worst_target");
}
