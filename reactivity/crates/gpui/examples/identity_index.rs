//! Public-operation controls for contiguous, gapped and permuted retained IDs.
use gpui::{WindowOptions, prelude::*, property::BACKGROUND};
use std::{hint::black_box, time::Instant};

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
enum Pattern {
    Contiguous,
    Gapped,
    Permuted,
}
struct Page {
    count: usize,
    pattern: Pattern,
    prepared: bool,
    value: Signal<usize>,
}
impl Page {
    const VALUE: Source<Self, usize> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
    fn cell(&self) -> El<'_> {
        div()
            .w(32)
            .h(1)
            .on_click(Self::VALUE.update(|value| *value += 1))
    }
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE)
    }
    fn view(&self) -> El<'_> {
        let rows = if self.pattern == Pattern::Permuted {
            uniform_list(ListId::new(1), self, 1)
                .w(32)
                .h(self.count as f32)
        } else {
            column((0..self.count).map(|_| self.cell()))
                .w(32)
                .h(self.count as f32)
        };
        column((
            div().child((!self.prepared || self.pattern != Pattern::Gapped).then(|| div().h(1))),
            rows,
        ))
        .w(32)
        .h((self.count + 2) as f32)
        .bg(Color::WHITE)
    }
}
impl ItemSource for Page {
    fn len(&self) -> usize {
        self.count
    }
    fn key(&self, index: usize) -> ItemKey {
        ItemKey::new(if self.prepared {
            self.count - 1 - index
        } else {
            index
        } as u64)
    }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        let key = usize::try_from(key.get())
            .ok()
            .filter(|&key| key < self.count)?;
        Some(if self.prepared {
            self.count - 1 - key
        } else {
            key
        })
    }
    fn row(&self, _: usize) -> El<'_> {
        self.cell()
    }
}
fn ack(win: &mut Win<Page>) {
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
}
fn open(count: usize, pattern: Pattern) -> Win<Page> {
    let mut win = Win::recording(
        Page {
            count,
            pattern,
            prepared: false,
            value: Signal::new(0),
        },
        WindowOptions {
            size: [32, count as u32 + 2],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    win
}
fn prepare(win: &mut Win<Page>) {
    win.update(|model| model.prepared = true).unwrap();
    ack(win);
}
fn targets(win: &Win<Page>, count: usize) -> [Target; 2] {
    let mut first = None;
    let mut last = None;
    let mut actions = 0;
    win.visit(|part| {
        if part.actions().contains(ActionKind::Activate) {
            first.get_or_insert(part.target());
            last = Some(part.target());
            actions += 1;
        }
    })
    .unwrap();
    assert_eq!(actions, count);
    [first.unwrap(), last.unwrap()]
}
fn main() {
    println!("pattern,count,stage,operations,ns,allocations,requested,delta,retained,peak");
    for count in [1, 128, 4096] {
        for pattern in [Pattern::Contiguous, Pattern::Gapped, Pattern::Permuted] {
            let mut preflight = open(count, pattern);
            let initial = targets(&preflight, count);
            prepare(&mut preflight);
            let prepared = targets(&preflight, count);
            assert_eq!(
                prepared,
                if pattern == Pattern::Permuted {
                    [initial[1], initial[0]]
                } else {
                    initial
                }
            );
            preflight
                .with_pixels(|pixels, _, _| {
                    assert!(pixels.chunks_exact(4).all(|pixel| pixel == [255; 4]))
                })
                .unwrap();
            drop(preflight);
            let mut win = None;
            let mut addressed: Option<[Target; 2]> = None;
            let mut retained = 0;
            for stage in [
                "mount",
                "prepare",
                "equal",
                "focus_first",
                "focus_last",
                "property_first",
                "property_last",
                "activate",
                "inspect",
                "drop",
            ] {
                let operations = if stage.starts_with("focus_") || stage.starts_with("property_") {
                    10_000
                } else if stage == "activate" {
                    64
                } else {
                    1
                };
                let start = Instant::now();
                let work = allocation_counter::measure(|| match stage {
                    "mount" => win = Some(open(count, pattern)),
                    "prepare" => prepare(win.as_mut().unwrap()),
                    "equal" => {
                        win.as_mut().unwrap().update(|_| {}).unwrap();
                        ack(win.as_mut().unwrap());
                    }
                    "focus_first" | "focus_last" => {
                        let target = addressed.unwrap()[usize::from(stage.ends_with("last"))];
                        for _ in 0..operations {
                            black_box(win.as_mut().unwrap().focus(target).unwrap());
                        }
                    }
                    "property_first" | "property_last" => {
                        let target = addressed.unwrap()[usize::from(stage.ends_with("last"))];
                        for _ in 0..operations {
                            assert_eq!(
                                black_box(
                                    win.as_ref().unwrap().property(target, BACKGROUND).unwrap()
                                ),
                                Color::TRANSPARENT
                            );
                        }
                    }
                    "activate" => {
                        for _ in 0..operations {
                            win.as_mut()
                                .unwrap()
                                .activate(addressed.unwrap()[0])
                                .unwrap();
                        }
                        assert_eq!(
                            win.as_ref().unwrap().with_model(|m| *m.value).unwrap(),
                            operations
                        );
                    }
                    "inspect" => {
                        black_box(win.as_ref().unwrap().inspect().unwrap());
                    }
                    "drop" => drop(win.take()),
                    _ => unreachable!(),
                });
                let ns = start.elapsed().as_nanos();
                retained += work.bytes_current;
                println!(
                    "{pattern:?},{count},{stage},{operations},{ns},{},{},{},{retained},{}",
                    work.count_total, work.bytes_total, work.bytes_current, work.bytes_max
                );
                if let Some(win) = &win {
                    addressed = Some(targets(win, count));
                }
            }
            assert_eq!(retained, 0);
        }
    }
}
