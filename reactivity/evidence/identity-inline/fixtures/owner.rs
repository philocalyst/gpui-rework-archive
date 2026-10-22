//! Identical public owner caller; timing requires a coordinated quiet window.
use gpui::{
    Error, Target, WindowOptions,
    prelude::*,
    property::{Contribution, WIDTH},
};
use std::{hint::black_box, time::Instant};
struct Page {
    count: usize,
    flipped: bool,
}
impl View for Page {
    fn view(&self) -> El<'_> {
        column((0..self.count).map(|i| {
            div().w(2 + i % 7).h(1).bg(if self.flipped {
                Color::BLACK
            } else {
                Color::WHITE
            })
        }))
        .w(64)
    }
}
fn open(count: usize) -> Win<Page> {
    let mut win = Win::recording(
        Page {
            count,
            flipped: false,
        },
        WindowOptions {
            size: [64, 64],
            ..Default::default()
        },
    )
    .unwrap();
    acknowledge(&mut win);
    win
}
fn acknowledge(win: &mut Win<Page>) {
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
}
fn targets(win: &Win<Page>) -> Vec<Target> {
    let mut out = Vec::new();
    win.visit(|part| out.push(part.target())).unwrap();
    out
}
fn oracle(win: &mut Win<Page>) -> u64 {
    let mut digest = 0xcbf29ce484222325u64;
    win.visit(|part| {
        for value in [
            part.local_bounds().x,
            part.local_bounds().y,
            part.local_bounds().width,
            part.local_bounds().height,
        ] {
            for byte in value.to_bits().to_le_bytes() {
                digest = (digest ^ u64::from(byte)).wrapping_mul(0x100000001b3);
            }
        }
    })
    .unwrap();
    win.with_pixels(|pixels, _, _| {
        for &byte in pixels {
            digest = (digest ^ u64::from(byte)).wrapping_mul(0x100000001b3);
        }
    })
    .unwrap();
    digest
}
#[inline(never)]
fn read_properties(win: &Win<Page>, targets: &[Target], permuted: bool, rounds: usize) -> u64 {
    let mut checksum = 0u64;
    for round in 0..rounds {
        for i in 0..targets.len() {
            let index = if permuted {
                (i * 193 + round) % targets.len()
            } else {
                i
            };
            checksum = checksum.wrapping_add(
                win.property(black_box(targets[index]), WIDTH)
                    .unwrap()
                    .unwrap()
                    .to_bits() as u64,
            );
        }
    }
    checksum
}
fn run(count: usize, capture: bool) {
    let mut retained = None;
    let start = Instant::now();
    let allocation = allocation_counter::measure(|| retained = Some(open(count)));
    let elapsed = start.elapsed().as_nanos();
    let mut win = retained.unwrap();
    let old = targets(&win);
    assert_eq!(old.len(), count + 1);
    println!(
        "cost,mount,{count},1,{elapsed},{},{},{},{}",
        allocation.count_total,
        allocation.bytes_total,
        allocation.bytes_current,
        allocation.bytes_max
    );
    println!("guard,fresh,{count},{:016x}", oracle(&mut win));
    for phase in ["contiguous", "stable", "gapped"] {
        if phase == "stable" {
            let start = Instant::now();
            let allocation = allocation_counter::measure(|| {
                win.update(|page| page.flipped = true).unwrap();
                acknowledge(&mut win);
            });
            let ns = start.elapsed().as_nanos();
            assert_eq!(targets(&win), old);
            println!(
                "cost,stable,{count},1,{ns},{},{},{},{}",
                allocation.count_total,
                allocation.bytes_total,
                allocation.bytes_current,
                allocation.bytes_max
            );
        } else if phase == "gapped" {
            let start = Instant::now();
            let allocation = allocation_counter::measure(|| {
                win.update(|page| page.count += 1).unwrap();
                acknowledge(&mut win);
            });
            let ns = start.elapsed().as_nanos();
            if count != 0 {
                assert_eq!(win.property(old[1], WIDTH), Err(Error::StaleTarget));
            }
            assert_eq!(win.property(old[0], WIDTH).unwrap(), Some(64.0));
            println!(
                "cost,grow,{count},1,{ns},{},{},{},{}",
                allocation.count_total,
                allocation.bytes_total,
                allocation.bytes_current,
                allocation.bytes_max
            );
        }
        let current = targets(&win);
        let iterations = if capture {
            65_536usize.div_ceil(current.len()).max(16)
        } else {
            1
        };
        for permuted in [false, true] {
            let start = Instant::now();
            let mut checksum = 0;
            let allocation = allocation_counter::measure(|| {
                checksum = black_box(read_properties(&win, &current, permuted, iterations))
            });
            let ns = start.elapsed().as_nanos();
            assert_eq!(allocation.count_total, 0);
            println!("guard,lookup,{phase},{permuted},{count},{checksum}");
            println!(
                "cost,{phase}-lookup-{permuted},{count},{},{ns},{},{},{},{}",
                iterations * current.len(),
                allocation.count_total,
                allocation.bytes_total,
                allocation.bytes_current,
                allocation.bytes_max
            );
        }
        println!("guard,{phase},{count},{:016x}", oracle(&mut win));
    }
    let last = *targets(&win).last().unwrap();
    win.set_property(last, WIDTH, Contribution::Set(Some(17.0)))
        .unwrap();
    acknowledge(&mut win);
    assert_eq!(win.property(last, WIDTH).unwrap(), Some(17.0));
}
fn main() {
    println!(
        "pin,{},{}",
        env!("IDENTITY_INDEX_VARIANT"),
        env!("IDENTITY_INDEX_SOURCE")
    );
    let mode = std::env::args().nth(1);
    let capture = mode.as_deref() == Some("capture");
    if capture {
        assert_eq!(
            std::env::var("IDENTITY_INDEX_QUIET").as_deref(),
            Ok("approved")
        );
    }
    for count in if capture || mode.as_deref() == Some("guard-large") {
        vec![1, 60, 4096, 65_536]
    } else {
        vec![1, 60]
    } {
        run(count, capture);
    }
}
