use std::{hint::black_box, time::Instant};

use zero_macro_frontier::{Decorated, Decorator, Factory, Registered};

trait Accumulate {
    fn accumulate(&mut self, value: u64);
    fn value(&self) -> u64;
}

struct Cell(u64);
impl Accumulate for Cell {
    fn accumulate(&mut self, value: u64) {
        self.0 = self.0.wrapping_add(value).rotate_left(3);
    }
    fn value(&self) -> u64 {
        self.0
    }
}

fn as_accumulate(value: &mut Cell) -> &mut (dyn Accumulate + 'static) {
    value
}

fn make_decorated(count: usize) -> Vec<Decorated<Cell>> {
    (0..count)
        .map(|n| Decorator::new(Cell(n as u64)).expose(as_accumulate).erase())
        .collect()
}

fn make_registered(count: usize) -> Vec<Registered<Cell>> {
    let factory = Factory::<Cell>::new(|schema| schema.expose(as_accumulate));
    (0..count).map(|n| factory.wrap(Cell(n as u64))).collect()
}

fn time(name: &str, mut run: impl FnMut() -> u64, elements: usize, rounds: usize) -> u64 {
    black_box(run()); // warm-up
    let start = Instant::now();
    let mut checksum = 0;
    for _ in 0..rounds {
        checksum ^= black_box(run());
    }
    let elapsed = start.elapsed();
    let ns = elapsed.as_nanos() as f64 / (elements * rounds) as f64;
    println!("{name:28} {ns:8.2} ns/element  checksum={checksum}");
    checksum
}

fn main() {
    const N: usize = 60_000;
    const ROUNDS: usize = 10;
    let mut decorated = make_decorated(N);
    let mut registered = make_registered(N);
    let mut prebound = make_registered(N);
    let bound = prebound[0].bind::<dyn Accumulate>();
    let mut direct = (0..N).map(|n| Cell(n as u64)).collect::<Vec<_>>();

    let expected = time(
        "known concrete trait",
        || {
            for (i, cell) in direct.iter_mut().enumerate() {
                cell.accumulate(i as u64);
            }
            direct
                .iter()
                .fold(0u64, |sum, cell| sum.wrapping_add(cell.value()))
        },
        N,
        ROUNDS,
    );
    let per_value = time(
        "per-element .expose schema",
        || {
            for (i, cell) in decorated.iter_mut().enumerate() {
                cell.select::<dyn Accumulate>(move |value| {
                    value.accumulate(i as u64);
                });
            }
            decorated.iter_mut().fold(0u64, |sum, cell| {
                sum.wrapping_add(cell.downcast_mut::<Cell>().unwrap().value())
            })
        },
        N,
        ROUNDS,
    );
    let shared = time(
        "factory schema lookup",
        || {
            for (i, cell) in registered.iter_mut().enumerate() {
                cell.select::<dyn Accumulate>(move |value| {
                    value.accumulate(i as u64);
                });
            }
            registered.iter_mut().fold(0u64, |sum, cell| {
                sum.wrapping_add(cell.downcast_mut::<Cell>().unwrap().value())
            })
        },
        N,
        ROUNDS,
    );
    let bound_result = time(
        "factory schema prebound",
        || {
            for (i, cell) in prebound.iter_mut().enumerate() {
                bound.select(cell, move |value| {
                    value.accumulate(i as u64);
                });
            }
            prebound.iter_mut().fold(0u64, |sum, cell| {
                sum.wrapping_add(cell.downcast_mut::<Cell>().unwrap().value())
            })
        },
        N,
        ROUNDS,
    );

    assert_eq!(expected, per_value);
    assert_eq!(expected, shared);
    assert_eq!(expected, bound_result);
}
