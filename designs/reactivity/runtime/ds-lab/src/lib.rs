//! ds-lab: zero-dependency data-structure experiments for the GPUI-fork reactivity runtime.
//!
//! Machine: Apple M3 Pro, macOS (Darwin 24.6), rustc 1.97.1, release opt-level=3 LTO.
//! All timings are single-thread, single-core, warm-cache unless noted. Numbers are indicative
//! of *relative* cost on this microarchitecture; absolute ns will differ on x86/older ARM.

use std::hint::black_box;
use std::time::Instant;

/// Run `f` `iters` times per sample, `samples` samples, after `warmup` samples.
/// Returns (min_ns_per_iter, median_ns_per_iter, p99_ns_per_iter).
pub fn bench<F: FnMut()>(iters: u64, samples: usize, warmup: usize, mut f: F) -> (f64, f64, f64) {
    let mut times = Vec::with_capacity(samples);
    for s in 0..(samples + warmup) {
        let t0 = Instant::now();
        for _ in 0..iters {
            f();
        }
        let dt = t0.elapsed().as_nanos() as f64 / iters as f64;
        if s >= warmup {
            times.push(dt);
        }
    }
    times.sort_by(|a, b| a.partial_cmp(b).unwrap());
    let min = times[0];
    let median = times[times.len() / 2];
    let p99 = times[((times.len() as f64 * 0.99) as usize).min(times.len() - 1)];
    (min, median, p99)
}

pub fn bb<T>(x: T) -> T {
    black_box(x)
}

/// Print a size/align line and return the size for assertions.
pub fn size_line<T>(label: &str) -> usize {
    let s = std::mem::size_of::<T>();
    let a = std::mem::align_of::<T>();
    println!("  size_of<{label}> = {s:>3}  align = {a}");
    s
}

pub fn section(title: &str) {
    println!("\n========================================================================");
    println!("== {title}");
    println!("========================================================================");
}

pub fn note(s: &str) {
    println!("  · {s}");
}

pub fn verdict(s: &str) {
    println!("  >>> VERDICT: {s}");
}

/// A cheap deterministic xorshift RNG so experiments are reproducible with no deps.
pub struct Rng(pub u64);
impl Rng {
    pub fn new(seed: u64) -> Self {
        Rng(seed | 1)
    }
    #[inline]
    pub fn next_u64(&mut self) -> u64 {
        let mut x = self.0;
        x ^= x << 13;
        x ^= x >> 7;
        x ^= x << 17;
        self.0 = x;
        x
    }
    #[inline]
    pub fn below(&mut self, n: u32) -> u32 {
        (self.next_u64() % n as u64) as u32
    }
}
