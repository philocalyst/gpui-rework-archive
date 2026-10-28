use std::sync::atomic::{AtomicU64,Ordering};
fn main() { assert_eq!(AtomicU64::new(1).try_update(Ordering::Relaxed, Ordering::Relaxed, |n|n.checked_add(1)),Ok(1)); }
