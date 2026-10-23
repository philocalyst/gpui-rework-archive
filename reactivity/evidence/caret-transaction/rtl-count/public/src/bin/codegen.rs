//! Force separate optimized symbols for the public atomic API and RTL flag count.
use core::{hint::black_box, ops::ControlFlow};
use parley::{Layout, editing::CursorGeometry, layout::Run};

#[inline(never)]
fn flag_count(run: Run<'_, ()>) -> usize {
    run.len()
}

#[inline(never)]
fn atomic(layout: &Layout<()>, len: usize) -> u64 {
    let mut checksum = 0;
    let result = CursorGeometry::try_for_each_pair(layout, 0..=len, 1., |byte, pair| {
        checksum ^= byte as u64;
        if let Some(pair) = pair {
            for r in pair {
                checksum ^= r.x0.to_bits() ^ r.y0.to_bits() ^ r.x1.to_bits() ^ r.y1.to_bits();
            }
        }
        ControlFlow::<()>::Continue(())
    });
    black_box(result);
    checksum
}

fn main() {
    black_box(flag_count as fn(Run<'_, ()>) -> usize);
    black_box(atomic as fn(&Layout<()>, usize) -> u64);
}
