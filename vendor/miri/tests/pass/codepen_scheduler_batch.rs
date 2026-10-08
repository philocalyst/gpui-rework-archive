// Run with GPUI_CODEPEN_IPC=1 to exercise the Codepen statement-block fast path.
// Call, return, unwind, yield and block boundaries must retain normal scheduling.
use std::sync::{Arc, atomic::{AtomicUsize, Ordering}};

#[inline(never)]
fn arithmetic(mut value: usize) -> usize {
    value = value.wrapping_mul(3);
    value = value.wrapping_add(7);
    value = value.rotate_left(2);
    value ^ 0x1234
}

struct OnDrop(Arc<AtomicUsize>);
impl Drop for OnDrop {
    fn drop(&mut self) { self.0.fetch_add(1, Ordering::SeqCst); }
}

fn main() {
    let progress = Arc::new(AtomicUsize::new(0));
    let child_progress = progress.clone();
    let child = std::thread::spawn(move || {
        let mut result = 0;
        for value in 0..16 {
            result ^= arithmetic(value);
            child_progress.fetch_add(1, Ordering::SeqCst);
            std::thread::yield_now();
        }
        result
    });
    while progress.load(Ordering::SeqCst) != 16 { std::thread::yield_now(); }
    let expected = (0..16).map(arithmetic).fold(0, |a, b| a ^ b);
    assert_eq!(child.join().unwrap(), expected);

    let drops = Arc::new(AtomicUsize::new(0));
    for iteration in 0..4 {
        let count = drops.clone();
        assert!(std::panic::catch_unwind(move || {
            let _guard = OnDrop(count);
            std::hint::black_box(arithmetic(iteration));
            panic!("batch unwind");
        }).is_err());
        assert_eq!(drops.load(Ordering::SeqCst), iteration + 1);
        assert_eq!(arithmetic(iteration), ((iteration * 3 + 7).rotate_left(2)) ^ 0x1234);
    }
}
