//! Complete state-write through canonical paint and acknowledgement.
//! See evidence/state-segments/PROTOCOL.md; this is not native frame latency.
use gpui::{WindowOptions, prelude::*};
use std::time::Instant;

struct Page {
    label: Signal<String>,
    rows: usize,
}
impl Page {
    const LABEL: Source<Self, String> =
        Source::new(FieldId::new(1), "label", |m| &m.label, |m| &mut m.label);
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::LABEL)
    }
    fn view(&self) -> El<'_> {
        column((
            text(&self.label).h(20).font_size(12).fg(rgb(0xe5edf7)),
            column((0..self.rows).map(|r| {
                row((0..25).map(move |c| {
                    text((r * 25 + c).to_string())
                        .w(36)
                        .h(18)
                        .font_size(12)
                        .fg(rgb(0xe5edf7))
                }))
                .gap(2)
            }))
            .gap(2),
        ))
        .w(960)
        .h(720)
        .p(8)
        .gap(6)
        .font_size(12)
        .fg(rgb(0xe5edf7))
        .bg(rgb(0x0e1218))
    }
}

// Measurement-only FFI: Linux CLOCK_PROCESS_CPUTIME_ID and a valid writable
// timespec. No production library code or timing-dependent behavior uses it.
#[cfg(target_os = "linux")]
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
    // SAFETY: the Linux ABI and writable object are as specified above.
    assert_eq!(unsafe { clock_gettime(2, &mut time) }, 0);
    time.seconds as u64 * 1_000_000_000 + time.nanoseconds as u64
}

fn ack(win: &mut Win<Page>) {
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
}
fn mount(rows: usize, label: String, font: gpui_canvas::FontFace) -> Win<Page> {
    let mut win = Win::recording_with_font(
        Page {
            rows,
            label: Signal::new(label),
        },
        WindowOptions {
            size: [960, 720],
            ..Default::default()
        },
        font,
    )
    .unwrap();
    ack(&mut win);
    win
}
fn main() {
    let args: Vec<_> = std::env::args().skip(1).collect();
    let rows: usize = args[0].parse().unwrap();
    assert!(rows <= 400);
    let font = gpui_canvas::FontFace::new(std::fs::read(&args[1]).unwrap()).unwrap();
    let start = Instant::now();
    let cold_cpu = cpu_ns();
    let mut win = mount(rows, "Count: 0".into(), font.clone());
    eprintln!(
        "cold,cpu_ns={},wall_ns={}",
        cpu_ns() - cold_cpu,
        start.elapsed().as_nanos()
    );
    assert_eq!(win.role(gpui::Role::Text).count().unwrap(), rows * 25 + 1);
    let mut next = 0;
    let step = |win: &mut Win<Page>, next: &mut usize| {
        *next += 1;
        win.set(Page::LABEL, format!("Count: {next}")).unwrap();
        ack(win);
    };
    for _ in 0..200 {
        step(&mut win, &mut next);
    }
    win.reset_counters().unwrap();
    println!("rows,batch,ops,cpu_ns,wall_ns");
    for batch in 0..200 {
        let wall = Instant::now();
        let cpu = cpu_ns();
        for _ in 0..10 {
            step(&mut win, &mut next);
        }
        let cpu = cpu_ns() - cpu;
        let wall = wall.elapsed().as_nanos();
        println!("{rows},{batch},10,{cpu},{wall}");
    }
    eprintln!("counters,{:?}", win.counters());
    let label = format!("Count: {next}");
    assert!(win.contains_text(&label).unwrap());
    let fresh = mount(rows, label, font);
    let actual = win.with_pixels(|p, _, _| p.to_vec()).unwrap();
    let expected = fresh.with_pixels(|p, _, _| p.to_vec()).unwrap();
    assert_eq!(actual, expected, "complete fresh-render pixel oracle");
    let start = Instant::now();
    drop(win);
    eprintln!("drop,wall_ns={}", start.elapsed().as_nanos());
}
