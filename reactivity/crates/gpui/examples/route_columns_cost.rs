//! Public Win activation and full-window controls. Timings require a coordinated
//! quiet CPU; `check` runs only one operation and validates source/output rules.
use gpui::{WindowOptions, prelude::*};
use std::{hint::black_box, time::Instant};

struct Page {
    nodes: usize,
    routes: usize,
    count: Signal<u64>,
}
impl Page {
    const COUNT: Source<Self, u64> =
        Source::new(FieldId::new(1), "count", |m| &m.count, |m| &mut m.count);
    fn site<'a>(&self, index: usize, site: El<'a>) -> El<'a> {
        if index < self.routes {
            site.on_click(Self::COUNT.update(|count| *count += 1))
        } else {
            site
        }
    }
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::COUNT)
    }
    fn view(&self) -> El<'_> {
        self.site(
            0,
            column((1..self.nodes).map(|index| self.site(index, div().w(8).h(1)))),
        )
    }
}
fn acknowledge(win: &mut Win<Page>) {
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
}
fn main() {
    let args = std::env::args().skip(1).collect::<Vec<_>>();
    assert_eq!(
        args.len(),
        5,
        "check|measure operation nodes routes repetitions"
    );
    let measured = match args[0].as_str() {
        "check" => false,
        "measure" => true,
        _ => panic!("mode"),
    };
    let operation = args[1].as_str();
    let nodes: usize = args[2].parse().unwrap();
    let routes: usize = args[3].parse().unwrap();
    let repetitions: usize = if measured {
        args[4].parse().unwrap()
    } else {
        1
    };
    assert!((1..=50_000).contains(&nodes) && routes <= nodes && repetitions > 0);
    let mut win = Win::recording(
        Page {
            nodes,
            routes,
            count: Signal::new(0),
        },
        WindowOptions {
            size: [32, 32],
            ..Default::default()
        },
    )
    .unwrap();
    acknowledge(&mut win);
    let snapshot = win.snapshot().unwrap();
    assert_eq!(snapshot.nodes.len(), nodes);
    let targets = snapshot
        .nodes
        .iter()
        .filter_map(|node| node.target)
        .collect::<Vec<_>>();
    assert_eq!(targets.len(), routes);
    let before = win.counters();
    let mut run = || {
        let mut digest = 0;
        for iteration in 0..repetitions {
            match operation {
                "activate" => {
                    assert!(!targets.is_empty());
                    black_box(
                        win.activate(targets[(iteration * 7919) % targets.len()])
                            .unwrap(),
                    );
                }
                "equal" => {
                    black_box(win.update(|_| {}).unwrap());
                    acknowledge(&mut win);
                }
                "resize" => {
                    black_box(win.resize([33 + (iteration & 1) as u32, 32]).unwrap());
                    acknowledge(&mut win);
                }
                "snapshot" => {
                    let snapshot = win.snapshot().unwrap();
                    digest += snapshot
                        .nodes
                        .iter()
                        .filter(|node| node.target.is_some())
                        .count();
                    black_box(snapshot);
                }
                _ => panic!("operation"),
            }
        }
        black_box(digest)
    };
    let (digest, elapsed) = if measured {
        let start = Instant::now();
        let digest = run();
        (digest, Some(start.elapsed().as_nanos()))
    } else {
        (run(), None)
    };
    let after = win.counters();
    match operation {
        "activate" => {
            assert_eq!(*win.root().unwrap().count, repetitions as u64);
            assert_eq!(after.owner_reruns, before.owner_reruns);
            assert_eq!(
                after.exact_updates - before.exact_updates,
                repetitions as u64
            );
        }
        "equal" => assert_eq!(after.owner_reruns - before.owner_reruns, repetitions as u64),
        "resize" => assert_eq!(after.owner_reruns, before.owner_reruns),
        "snapshot" => {
            assert_eq!(after, before);
            assert_eq!(digest, routes * repetitions);
        }
        _ => unreachable!(),
    }
    println!(
        "route_cost,operation={operation},nodes={nodes},routes={routes},repetitions={repetitions},elapsed_ns={},owner_reruns={},exact_updates={},digest={digest}",
        elapsed.map_or_else(|| "unchecked_timing".to_owned(), |value| value.to_string()),
        after.owner_reruns - before.owner_reruns,
        after.exact_updates - before.exact_updates
    );
}
