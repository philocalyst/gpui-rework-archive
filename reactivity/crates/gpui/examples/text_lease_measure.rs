//! Microbenchmarks of the actual two dependency representations; not frame time.
use arcstr::ArcStr;
use std::{hint::black_box, time::Instant};
use triomphe::Arc;

#[inline(never)]
fn baseline_publish(value: &Arc<str>) -> Arc<str> {
    value.clone()
}
#[inline(never)]
fn thin_publish(value: &ArcStr) -> ArcStr {
    value.clone()
}
#[inline(never)]
fn baseline_release(value: Arc<str>) {
    drop(value)
}
#[inline(never)]
fn thin_release(value: ArcStr) {
    drop(value)
}
#[inline(never)]
fn clones<T: Clone + AsRef<str>>(values: &[T], iterations: usize) -> f64 {
    let start = Instant::now();
    for index in 0..iterations {
        let value = black_box(&values[index & (values.len() - 1)]);
        let copy = black_box(value.clone());
        black_box(copy.as_ref());
        drop(copy);
    }
    start.elapsed().as_secs_f64() * 1e9 / iterations as f64
}
fn main() {
    let iterations = std::env::args()
        .nth(1)
        .map_or(2_000_000, |value| value.parse().unwrap());
    println!("representation,length,leases,allocations,requested_bytes,clone_drop_ns");
    for length in [0, 3, 8, 23, 24, 25, 64, 4096] {
        let payload = "a".repeat(length);
        let mut baseline = None;
        let old =
            allocation_counter::measure(|| baseline = Some(Arc::<str>::from(payload.as_str())));
        let mut thin = None;
        let new = allocation_counter::measure(|| thin = Some(ArcStr::from(payload.as_str())));
        let baseline = baseline.unwrap();
        let thin = thin.unwrap();
        // Keep concrete clone/drop functions emitted for inspection. Timings
        // below use inline loops and include no function-pointer dispatch.
        black_box(baseline_release)(black_box(baseline_publish)(&baseline));
        black_box(thin_release)(black_box(thin_publish)(&thin));
        for count in [1, 256] {
            let old_values = if count == 1 {
                vec![baseline.clone()]
            } else {
                (0..count)
                    .map(|_| Arc::<str>::from(payload.as_str()))
                    .collect()
            };
            let new_values = if count == 1 {
                vec![thin.clone()]
            } else {
                (0..count).map(|_| ArcStr::from(payload.as_str())).collect()
            };
            // Alternating ordering is controlled by the driver process too.
            let old_ns = clones(&old_values, iterations);
            let new_ns = clones(&new_values, iterations);
            println!(
                "triomphe,{length},{count},{},{},{old_ns:.4}",
                old.count_total, old.bytes_total
            );
            println!(
                "arcstr,{length},{count},{},{},{new_ns:.4}",
                new.count_total, new.bytes_total
            );
        }
    }
}
