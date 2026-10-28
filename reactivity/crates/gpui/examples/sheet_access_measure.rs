//! Public acknowledged-sheet access costs, excluding mount/layout/rendering.
use gpui::{El, Point, Role, View, Win, WindowOptions, button, column};
use std::{hint::black_box, time::Instant};

struct Page(usize);
impl View for Page {
    fn view(&self) -> El<'_> {
        column((0..self.0).map(|_| button("x").w(16).h(1)))
    }
}

fn main() {
    let count: usize = std::env::args().nth(1).unwrap().parse().unwrap();
    assert!((1..=10_000).contains(&count));
    let mut win = Win::recording(
        Page(count),
        WindowOptions {
            size: [32, 16],
            ..Default::default()
        },
    )
    .unwrap();
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
    assert_eq!(win.role(Role::Button).count().unwrap(), count);
    let point = Point { x: 4.0, y: 0.5 };
    let target = win.hit_target(point).unwrap();
    let before = win.counters();
    let repetitions = (1_000_000 / count).max(100);
    println!("nodes,repetitions,operation,ns_per_call,allocations");
    for operation in ["visit", "count", "hit"] {
        let start = Instant::now();
        let allocations = allocation_counter::measure(|| {
            for _ in 0..repetitions {
                match operation {
                    "visit" => {
                        let mut digest = 0u64;
                        win.visit(|part| {
                            let map = part.transform().unwrap();
                            digest = digest
                                .wrapping_add(u64::from(map.tx.to_bits()))
                                .wrapping_add(u64::from(map.ty.to_bits()))
                                .wrapping_add(u64::from(part.bounds().height.to_bits()))
                                .wrapping_add(part.name().map_or(0, |text| text.len()) as u64);
                        })
                        .unwrap();
                        black_box(digest);
                    }
                    "count" => {
                        black_box(win.role(black_box(Role::Button)).count().unwrap());
                    }
                    "hit" => {
                        assert_eq!(win.hit_target(black_box(point)).unwrap(), target);
                    }
                    _ => unreachable!(),
                }
            }
        });
        let ns = start.elapsed().as_nanos() as f64 / repetitions as f64;
        assert_eq!(allocations.count_total, 0);
        println!(
            "{},{repetitions},{operation},{ns:.3},{}",
            count + 1,
            allocations.count_total
        );
    }
    assert_eq!(win.counters(), before);
}
