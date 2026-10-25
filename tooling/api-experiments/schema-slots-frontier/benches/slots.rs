use schema_slots_frontier::{Describe, SchemaBuilder, Type};
use std::hint::black_box;
use std::time::Instant;
#[derive(Clone)]
struct Row {
    value: u64,
}
impl Describe for Row {
    fn describe() -> SchemaBuilder<Row> {
        SchemaBuilder::record(|_: &Row| ()).field_name("value")
    }
}
fn main() {
    let ty = Type::of::<Row>();
    let row = Row { value: 7 };
    let n = 20_000_000u64;
    let start = Instant::now();
    let mut sum = 0u64;
    for _ in 0..n {
        let snap = black_box(ty).snapshot();
        sum += snap.fields().len() as u64;
        sum += black_box(row.value) & 1;
    }
    let elapsed = start.elapsed();
    println!(
        "warm slot snapshot+metadata: {:.2} ns/op (checksum {sum})",
        elapsed.as_nanos() as f64 / n as f64
    );
}
