//! Separately compiled public consumer; not a unit-test instantiation.
use gpui_reactivity_core::{Affine, CoordinateSpace, MappedBounds, Rect};

#[inline(never)]
fn inspect(space: CoordinateSpace, rect: Rect) -> MappedBounds {
    space.mapped_bounds(rect)
}

fn main() {
    let mode = std::env::args().nth(1).unwrap_or_else(|| "finite".into());
    let repeats: usize = std::env::args()
        .nth(2)
        .map(|arg| arg.parse().unwrap())
        .unwrap_or(0);
    let mut wide = CoordinateSpace::new(Affine::IDENTITY);
    for _ in 0..8 {
        wide = wide.compose(Affine::scale(1.0e38, 1.0e-38));
    }
    let mut cases = Vec::with_capacity(4096);
    let mut hash = 0xcbf2_9ce4_8422_2325u64;
    for index in 0..4096 {
        let angle = index as f32 * 0.013;
        let transform = Affine {
            a: angle.cos(),
            b: angle.sin(),
            c: -angle.sin(),
            d: angle.cos(),
            tx: index as f32 * 0.125,
            ty: index as f32 * -0.0625,
        };
        let (space, rect) = match mode.as_str() {
            "finite" => (
                CoordinateSpace::new(transform),
                Rect::new(-13.125, 27.75, 32.5, 7.875),
            ),
            "fallback" => (wide, Rect::new(0.0, 0.0, 1.0e38, 1.0)),
            "empty" => (
                CoordinateSpace::new(transform),
                Rect::new(0.0, 0.0, 0.0, 1.0),
            ),
            _ => panic!("unknown mode"),
        };
        cases.push((space, rect));
        let result = inspect(std::hint::black_box(space), std::hint::black_box(rect));
        let words = match result {
            MappedBounds::Empty => [0; 5],
            MappedBounds::Unbounded => [2, 0, 0, 0, 0],
            MappedBounds::Finite(r) => [
                1,
                r.x.to_bits(),
                r.y.to_bits(),
                r.width.to_bits(),
                r.height.to_bits(),
            ],
        };
        for word in words {
            hash = (hash ^ word as u64).wrapping_mul(0x100_0000_01b3);
        }
    }
    println!("bounds,{hash:016x}");
    if repeats > 0 {
        let start = std::time::Instant::now();
        for _ in 0..repeats {
            for &(space, rect) in &cases[..256] {
                std::hint::black_box(inspect(
                    std::hint::black_box(space),
                    std::hint::black_box(rect),
                ));
            }
        }
        println!(
            "cost,{mode},{},{},{}",
            repeats * 256,
            start.elapsed().as_nanos(),
            hash
        );
    }
}
