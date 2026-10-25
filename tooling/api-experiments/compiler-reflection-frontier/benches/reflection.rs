use compiler_reflection_frontier::{field_name, field_offset};
use std::hint::black_box;
use std::time::Instant;

#[repr(C)]
struct Record {
    a: u64,
    b: u64,
    c: u64,
}

fn run(value: (&'static str, usize)) -> (std::time::Duration, usize) {
    let start = Instant::now();
    let mut checksum = 0usize;
    for _ in 0..10_000_000 {
        let (name, offset) = black_box(value);
        checksum = checksum.wrapping_add(name.len() + offset);
    }
    (start.elapsed(), checksum)
}

fn main() {
    const REFLECTED: (&str, usize) = (field_name::<Record, 2>(), field_offset::<Record, 2>());
    let (reflection_elapsed, reflection_checksum) = run(REFLECTED);
    let (manual_elapsed, manual_checksum) = run(("c", 16));
    assert_eq!(reflection_checksum, manual_checksum);
    println!("10M const-reflection results: {reflection_elapsed:?}");
    println!("10M equivalent literal results: {manual_elapsed:?}");
}
