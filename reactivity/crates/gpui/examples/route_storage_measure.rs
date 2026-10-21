//! Whole-owner route density/churn costs through the public library interface.
use gpui::{WindowOptions, prelude::*};
use std::{hint::black_box, time::Instant};

struct Page {
    count: usize,
    every: usize,
    enabled: bool,
    exact: bool,
    value: Signal<usize>,
}
impl Page {
    const VALUE: Source<Self, usize> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
    fn method(&mut self) {}
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE)
    }
    fn view(&self) -> El<'_> {
        column((0..self.count).map(|index| {
            let site = div().w(32).h(1);
            if self.enabled && self.every != 0 && index % self.every == 0 {
                if self.exact {
                    site.on_click(Self::VALUE.update(move |value| *value += index + 1))
                } else {
                    site.on_click(Self::method)
                }
            } else {
                site
            }
        }))
        .w(32)
        .h(16)
        .bg(Color::WHITE)
    }
}
fn open(count: usize, every: usize, exact: bool) -> Win<Page> {
    let mut win = Win::recording(
        Page {
            count,
            every,
            enabled: true,
            exact,
            value: Signal::new(0),
        },
        WindowOptions {
            size: [32, 16],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    win
}
fn ack(win: &mut Win<Page>) {
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
}
fn verify(win: &mut Win<Page>, count: usize, routes: usize) -> Option<Target> {
    let sheet = win.inspect().unwrap();
    assert_eq!(sheet.nodes.len(), count + 1);
    let mut actions = 0;
    win.visit(|part| {
        actions += usize::from(part.actions().contains(gpui::ActionKind::Activate));
    })
    .unwrap();
    assert_eq!(actions, routes);
    sheet.nodes.get(1).and_then(|node| node.target)
}
fn main() {
    println!("count,every,exact,stage,ns,allocations,requested,delta,retained,peak");
    for (count, every) in [(0_usize, 0), (1, 1), (4096, 0), (4096, 16), (4096, 1)] {
        for exact in [false, true] {
            let routes = if every == 0 { 0 } else { count.div_ceil(every) };
            let mut preflight = open(count, every, exact);
            verify(&mut preflight, count, routes);
            preflight
                .with_pixels(|pixels, _, _| {
                    assert!(pixels.chunks_exact(4).all(|pixel| pixel == [255; 4]));
                })
                .unwrap();
            drop(preflight); // Warm code, allocator and masks before capture.
            let mut win = None;
            let mut retained = 0;
            let mut addressed = None;
            for stage in ["mount", "equal", "disable", "restore", "dispatch", "drop"] {
                let start = Instant::now();
                let work = allocation_counter::measure(|| match stage {
                    "mount" => win = Some(open(count, every, exact)),
                    "equal" => {
                        win.as_mut().unwrap().update(|_| {}).unwrap();
                    }
                    "disable" | "restore" => {
                        let current = win.as_mut().unwrap();
                        current.update(|m| m.enabled = stage == "restore").unwrap();
                        ack(current);
                    }
                    "dispatch" if routes != 0 => {
                        let current = win.as_mut().unwrap();
                        let target = addressed.unwrap();
                        for _ in 0..100 {
                            current.activate(target).unwrap();
                        }
                        assert_eq!(
                            current.with_model(|m| *m.value).unwrap(),
                            usize::from(exact) * 100
                        );
                    }
                    "drop" => drop(win.take()),
                    _ => {}
                });
                let ns = start.elapsed().as_nanos();
                retained += work.bytes_current;
                println!(
                    "{count},{every},{exact},{stage},{ns},{},{},{},{retained},{}",
                    work.count_total, work.bytes_total, work.bytes_current, work.bytes_max
                );
                if let Some(win) = &mut win {
                    addressed = verify(win, count, if stage == "disable" { 0 } else { routes });
                }
            }
            assert_eq!(retained, 0);
            black_box(win);
        }
    }
}
