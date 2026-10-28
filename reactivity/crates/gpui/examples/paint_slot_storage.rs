//! Allocation counts, not timings. This fixture uses only the pre-slot public
//! API so its exact source can also run against the retained-color baseline.
use gpui::{El, Signal, Source, Sources, View, Win, WindowOptions, prelude::*};

struct StorageOwner {
    count: usize,
    mode: u8,
    color: Signal<Color>,
}
impl StorageOwner {
    const COLOR: Source<Self, Color> =
        Source::new(FieldId::new(1), "color", |m| &m.color, |m| &mut m.color);
}
impl View for StorageOwner {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::COLOR)
    }
    fn view(&self) -> El<'_> {
        column((0..self.count).map(|index| {
            // All nodes overlap: command storage scales with the whole owner,
            // rather than disappearing after the first viewport's children.
            let el = div()
                .size(1)
                .transform(Affine::translation(0., -(index as f32)));
            match self.mode {
                0 => el,
                1 => el.bg(Color::BLACK),
                2 => el.bg(&self.color),
                3 => el.bg(Color::rgb(index as u8, (index >> 8) as u8, 127)),
                _ => unreachable!(),
            }
        }))
    }
}

fn main() {
    println!("count,mode,pending,allocations,requested,retained,peak,command_lanes,draws");
    for count in [0, 1, 4096] {
        for mode in 0..4 {
            for pending in [false, true] {
                let mut owner = None;
                let allocation = allocation_counter::measure(|| {
                    let mut win = Win::recording(
                        StorageOwner {
                            count,
                            mode,
                            color: Signal::new(Color::BLACK),
                        },
                        WindowOptions {
                            size: [32, 32],
                            ..Default::default()
                        },
                    )
                    .unwrap();
                    let token = win.with_scene(|_, token| token).unwrap();
                    win.presented(token).unwrap();
                    if pending {
                        win.update(|model| model.count += 1).unwrap();
                        win.resize([33, 32]).unwrap();
                    }
                    owner = Some(win);
                });
                let owner = owner.unwrap();
                let (storage, draws) = owner
                    .with_scene(|scene, _| (scene.storage(), scene.draws().len()))
                    .unwrap();
                println!(
                    "{count},{mode},{pending},{},{},{},{},{},{draws}",
                    allocation.count_total,
                    allocation.bytes_total,
                    allocation.bytes_current,
                    allocation.bytes_max,
                    storage.lane_bytes()
                );
                std::hint::black_box(owner);
            }
        }
    }
}
