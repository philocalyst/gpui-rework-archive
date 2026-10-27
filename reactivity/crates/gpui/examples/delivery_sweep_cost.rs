//! Complete public inbox delivery, paint publication, and acknowledgement.
use gpui::{LaneSet, Remote, WindowOptions, prelude::*};
use std::time::Instant;
struct Model {
    value: Signal<u64>,
}
impl Model {
    const VALUE: Source<Self, u64> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
}
impl View for Model {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE)
    }
    fn view(&self) -> El<'_> {
        div().size(32).bg(self
            .value
            .map(|v| rgb((*v as u32).wrapping_mul(2654435761) & 0xffffff)))
    }
}
fn receive(value: &mut u64, message: u64) {
    *value = value.wrapping_mul(33).wrapping_add(message);
}
fn attach<L: LaneSet<Model>>(
    win: Win<Model, L>,
    senders: &mut Vec<Remote<u64>>,
) -> Win<Model, impl LaneSet<Model>> {
    let (sender, inbox) = Remote::bounded(128);
    senders.push(sender);
    win.with_inbox_for(inbox, Model::VALUE, receive).unwrap()
}
fn ack<L: LaneSet<Model>>(win: &mut Win<Model, L>) {
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
}
fn cpu_ns() -> u64 {
    #[repr(C)]
    struct Timespec {
        seconds: i64,
        nanoseconds: i64,
    }
    unsafe extern "C" {
        fn clock_gettime(clock: i32, time: *mut Timespec) -> i32;
    }
    let mut time = Timespec {
        seconds: 0,
        nanoseconds: 0,
    };
    // SAFETY: Linux CLOCK_PROCESS_CPUTIME_ID and a valid ABI-compatible output.
    assert_eq!(unsafe { clock_gettime(2, &mut time) }, 0);
    time.seconds as u64 * 1_000_000_000 + time.nanoseconds as u64
}
fn measure<L: LaneSet<Model>>(
    mut win: Win<Model, L>,
    senders: Vec<Remote<u64>>,
    mode: &str,
    cold: u128,
) {
    let n = senders.len();
    ack(&mut win);
    eprintln!("COLD,lanes={n},wall_ns={cold}");
    let mut sequence = 0u64;
    let mut expected = 0u64;
    // Newest inbox is index zero; callbacks apply in that same structural order.
    let mut cursor = 0;
    let mut step = |win: &mut Win<Model, L>| {
        sequence += 1;
        match mode {
            "idle" => {
                let d = win.deliver_ready(64).unwrap();
                assert_eq!((d.received, d.applied, d.more), (0, 0, false));
            }
            "one" => {
                senders[0].try_send(sequence).unwrap();
                let d = win.deliver_ready(64).unwrap();
                assert_eq!((d.received, d.applied), (1, 1));
                expected = expected.wrapping_mul(33).wrapping_add(sequence);
                ack(win);
            }
            "all" => {
                for (i, sender) in senders.iter().enumerate() {
                    sender.try_send(sequence + i as u64).unwrap();
                }
                let d = win.deliver_ready(n).unwrap();
                assert_eq!((d.received, d.applied), (n, n));
                for i in (0..n).rev() {
                    expected = expected.wrapping_mul(33).wrapping_add(sequence + i as u64);
                }
                ack(win);
            }
            "rotate" => {
                // One complete operation drains one item from each lane, budget one.
                for (i, sender) in senders.iter().enumerate() {
                    sender.try_send(sequence + i as u64).unwrap();
                }
                for _ in 0..n {
                    let d = win.deliver_ready(1).unwrap();
                    assert_eq!((d.received, d.applied), (1, 1));
                    expected = expected
                        .wrapping_mul(33)
                        .wrapping_add(sequence + (n - 1 - cursor) as u64);
                    cursor = (cursor + 1) % n;
                    ack(win);
                }
            }
            _ => panic!("unknown mode"),
        }
    };
    for _ in 0..200 {
        step(&mut win);
    }
    win.reset_counters().unwrap();
    println!("lanes,mode,batch,ops,cpu_ns,wall_ns");
    for batch in 0..40 {
        let wall = Instant::now();
        let cpu = cpu_ns();
        for _ in 0..100 {
            step(&mut win);
        }
        let cpu = cpu_ns() - cpu;
        let wall = wall.elapsed().as_nanos();
        println!("{n},{mode},{batch},100,{cpu},{wall}");
    }
    assert_eq!(*win.root().unwrap().value, expected);
    let mut fresh = Win::recording(
        Model {
            value: Signal::new(expected),
        },
        WindowOptions {
            size: [32, 32],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut fresh);
    let actual = win.with_pixels(|p, _, _| p.to_vec()).unwrap();
    let oracle = fresh.with_pixels(|p, _, _| p.to_vec()).unwrap();
    assert_eq!(actual, oracle);
    let hash = actual.iter().fold(0xcbf29ce484222325u64, |h, &b| {
        (h ^ u64::from(b)).wrapping_mul(0x100000001b3)
    });
    eprintln!(
        "FINAL,value={expected},pixel_hash={hash},counters={:?}",
        win.counters()
    );
}
fn main() {
    let args: Vec<_> = std::env::args().skip(1).collect();
    let lanes: usize = args[0].parse().unwrap();
    let mode = &args[1];
    let start = Instant::now();
    let win = Win::recording(
        Model {
            value: Signal::new(0),
        },
        WindowOptions {
            size: [32, 32],
            ..Default::default()
        },
    )
    .unwrap();
    let mut senders = Vec::new();
    let win = attach(win, &mut senders);
    if lanes == 1 {
        measure(win, senders, mode, start.elapsed().as_nanos());
        return;
    }
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    if lanes == 8 {
        measure(win, senders, mode, start.elapsed().as_nanos());
        return;
    }
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    if lanes == 32 {
        measure(win, senders, mode, start.elapsed().as_nanos());
        return;
    }
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    let win = attach(win, &mut senders);
    if lanes == 64 {
        measure(win, senders, mode, start.elapsed().as_nanos());
        return;
    }
    panic!("lanes must be 1, 8, 32, or 64");
}
