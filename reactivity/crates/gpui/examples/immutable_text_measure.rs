//! Paired fresh-process allocation/phase evidence. See evidence/thin-text.md.
use gpui::{Role, WindowOptions, prelude::*};
use std::{hint::black_box, time::Instant};

struct Page {
    count: usize,
    every: usize,
    ports: u8, // bit0 visual, bit1 name, bit2 description
    unique: bool,
    value: Signal<String>,
    labels: Vec<String>,
    broken: bool,
}
impl Page {
    const VALUE: Source<Self, String> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
    fn payload(&self, index: usize) -> &str {
        if self.unique {
            &self.labels[index]
        } else {
            &self.value
        }
    }
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE)
    }
    fn view(&self) -> El<'_> {
        column((0..self.count).map(|index| {
            if self.every == 0 || !index.is_multiple_of(self.every) {
                return div().w(64).h(1);
            }
            let site = if self.ports & 1 != 0 {
                if self.unique {
                    text(self.payload(index))
                } else {
                    text(&self.value)
                }
            } else {
                div()
            }
            .w(64)
            .h(1);
            let site = if self.ports & 2 != 0 {
                if self.unique {
                    site.name(self.payload(index))
                } else {
                    site.name(&self.value)
                }
            } else {
                site
            };
            if self.ports & 4 != 0 {
                if self.unique {
                    site.description(self.payload(index))
                } else {
                    site.description(&self.value)
                }
            } else {
                site
            }
        }))
        .w(64)
        .h(24)
        .bg(Color::WHITE)
        .transform(if self.broken {
            Affine::scale(f32::MAX, f32::MAX)
        } else {
            Affine::IDENTITY
        })
    }
}
fn payload(length: &str) -> String {
    if length == "utf8" {
        "Café naïve".into()
    } else {
        "a".repeat(length.parse().unwrap())
    }
}
fn model(count: usize, every: usize, ports: u8, unique: bool, value: &str) -> Page {
    let labels = if unique {
        (0..count)
            .map(|index| {
                // Fixed-length distinct ASCII labels whenever length can represent all
                // indices; at length0 all values are necessarily identical.
                let mut bytes = value.as_bytes().to_vec();
                if value.is_ascii() {
                    let mut number = index;
                    for byte in bytes.iter_mut().rev().take(6) {
                        *byte = b'a' + (number % 26) as u8;
                        number /= 26;
                    }
                }
                String::from_utf8(bytes).unwrap()
            })
            .collect()
    } else {
        vec![]
    };
    Page {
        count,
        every,
        ports,
        unique,
        value: Signal::new(value.into()),
        labels,
        broken: false,
    }
}
fn ack(win: &mut Win<Page>) {
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
}
fn options() -> WindowOptions {
    WindowOptions {
        size: [64, 24],
        ..Default::default()
    }
}
fn checks(win: &Win<Page>, active: usize, ports: u8) -> u64 {
    let mut seen = 0;
    let mut named = 0;
    let mut described = 0;
    let mut hash = 0xcbf29ce484222325u64;
    win.visit(|part| {
        seen += usize::from(part.role() == Role::Text);
        named += usize::from(part.name().is_some());
        described += usize::from(part.description().is_some());
        for text in [part.text(), part.name(), part.description()]
            .into_iter()
            .flatten()
        {
            for byte in text.bytes() {
                hash = (hash ^ u64::from(byte)).wrapping_mul(0x100000001b3);
            }
        }
    })
    .unwrap();
    assert_eq!(seen, if ports & 1 != 0 { active } else { 0 });
    assert_eq!(named, if ports & 3 != 0 { active } else { 0 });
    assert_eq!(described, if ports & 4 != 0 { active } else { 0 });
    hash
}
fn main() {
    let args = std::env::args().skip(1).collect::<Vec<_>>();
    let count: usize = args[0].parse().unwrap();
    let every: usize = args[1].parse().unwrap();
    let ports: u8 = args[2].parse().unwrap();
    let value = payload(&args[3]);
    let unique = args[4] == "unique";
    let cpu = args[5] == "cpu";
    assert!(count < 100_000 && ports <= 7);
    let active = if every == 0 { 0 } else { count.div_ceil(every) };
    // Warm dependency scratch/font caches in exactly the same way for both
    // binaries. No measured owner or model payload exists during this warmup.
    let mut reference =
        Win::recording(model(count, every, ports, unique, &value), options()).unwrap();
    ack(&mut reference);
    let expected = checks(&reference, active, ports);
    let pixel_digest = if cpu {
        Some(reference.scene_digest().unwrap())
    } else {
        None
    };
    drop(reference);
    let page = model(count, every, ports, unique, &value);
    let source_bytes = page.value.capacity()
        + page.labels.capacity() * size_of::<String>()
        + page.labels.iter().map(String::capacity).sum::<usize>();
    let mut page = Some(page);
    let mut owner = None;
    let mut retained = 0i64;
    println!(
        "nodes,active,ports,length,sharing,mode,stage,microseconds,retained_delta,total_retained,peak_new_bytes,allocations,promotions,compares,paint_passes,semantic_hash,pixel_digest"
    );
    for stage in [
        "mount",
        "equal_description",
        "prepare_pending",
        "ack_pending",
        "edit",
        "drop",
    ] {
        if let Some(win) = &mut owner {
            Win::<Page>::reset_counters(win).unwrap();
        }
        let old_token = owner
            .as_ref()
            .map(|win| win.with_scene(|_, token| token).unwrap());
        let start = Instant::now();
        let allocation = allocation_counter::measure(|| {
            match stage {
                "mount" => {
                    let page = page.take().unwrap();
                    let mut win = if cpu {
                        Win::with_options(page, options())
                    } else {
                        Win::recording(page, options())
                    }
                    .unwrap();
                    if !cpu {
                        ack(&mut win)
                    };
                    owner = Some(win);
                }
                "equal_description" => {
                    owner.as_mut().unwrap().update(|_| {}).unwrap();
                }
                "prepare_pending" => {
                    let win = owner.as_mut().unwrap();
                    win.resize([80, 32]).unwrap();
                }
                "ack_pending" => {
                    if !cpu {
                        ack(owner.as_mut().unwrap());
                    }
                }
                "edit" => {
                    let win = owner.as_mut().unwrap();
                    if unique {
                        win.update(|page| {
                            for value in &mut page.labels {
                                value.push('z')
                            }
                        })
                        .unwrap();
                    } else {
                        win.set(Page::VALUE, format!("{}z", value)).unwrap();
                    }
                    if !cpu {
                        ack(win);
                    }
                }
                "drop" => drop(owner.take()),
                _ => unreachable!(),
            }
            if cpu && let Some(win) = &mut owner {
                win.with_pixels(|pixels, _, _| black_box(pixels.len()))
                    .unwrap();
            }
        });
        // Capture elapsed immediately: semantic/pixel proof is outside timing.
        let us = start.elapsed().as_secs_f64() * 1e6;
        retained += allocation.bytes_current;
        let counters = owner.as_ref().map(Win::counters).unwrap_or_default();
        let hash = owner
            .as_ref()
            .map(|win| checks(win, active, ports))
            .unwrap_or(0);
        if stage == "prepare_pending" && !cpu {
            assert_ne!(
                owner
                    .as_ref()
                    .unwrap()
                    .with_scene(|_, token| token)
                    .unwrap(),
                old_token.unwrap()
            );
            assert_eq!(hash, expected);
        }
        if stage == "mount" {
            assert_eq!(hash, expected);
            if let Some(expected) = pixel_digest {
                assert_eq!(owner.as_mut().unwrap().scene_digest().unwrap(), expected);
            }
        }
        // CPU mount/resize already owns its image; ask pixels only outside the
        // measured operation. CPU mode still includes normal runtime drawing.
        if cpu && let Some(win) = &mut owner {
            black_box(win.scene_digest().unwrap());
        }
        println!(
            "{},{active},{ports},{},{},{},{stage},{us:.3},{},{retained},{},{},{},{},{},{hash},{pixel_digest:?}",
            count + 1,
            value.len(),
            if unique { "unique" } else { "source" },
            if cpu { "cpu" } else { "recording" },
            allocation.bytes_current,
            allocation.bytes_max,
            allocation.count_total,
            counters.text_promotions,
            counters.destination_compares,
            counters.paint_passes
        );
    }
    assert_eq!(
        retained,
        -(source_bytes as i64),
        "all newly owned allocations released (source existed before counter)"
    );
}
