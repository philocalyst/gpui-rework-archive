//! Complete multi-source inbox delivery, canonical recording, and ACK.
use gpui::{LaneSet, Remote, WindowOptions, prelude::*};
use std::time::Instant;
struct Page<const OWNER: bool> {
    values: [Signal<String>; 4],
    rows: usize,
}
impl<const O: bool> Page<O> {
    const F: [Source<Self, String>; 4] = [
        Source::new(FieldId::new(1), "a", |m| &m.values[0], |m| &mut m.values[0]),
        Source::new(FieldId::new(2), "b", |m| &m.values[1], |m| &mut m.values[1]),
        Source::new(FieldId::new(3), "c", |m| &m.values[2], |m| &mut m.values[2]),
        Source::new(FieldId::new(4), "d", |m| &m.values[3], |m| &mut m.values[3]),
    ];
}
impl<const O: bool> View for Page<O> {
    fn sources() -> Sources<Self> {
        let s = if O {
            Sources::new().field(Self::F[0])
        } else {
            Sources::new().direct(Self::F[0])
        };
        s.direct(Self::F[1]).direct(Self::F[2]).direct(Self::F[3])
    }
    fn view(&self) -> El<'_> {
        column((
            row(self.values.iter().map(|v| text(v).w(200).h(20))),
            O.then(|| text(format!("owner:{}", self.values[0].as_str())).h(20)),
            column((0..self.rows).map(|r| {
                row((0..25).map(move |c| text((r * 25 + c).to_string()).w(36).h(18))).gap(2)
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
fn ack<const O: bool, L: LaneSet<Page<O>>>(win: &mut Win<Page<O>, L>) {
    let token = win.with_scene(|_, t| t).unwrap();
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
    let mut t = Timespec {
        seconds: 0,
        nanoseconds: 0,
    };
    // SAFETY: Linux process-CPU clock and writable ABI-compatible timespec.
    assert_eq!(unsafe { clock_gettime(2, &mut t) }, 0);
    t.seconds as u64 * 1_000_000_000 + t.nanoseconds as u64
}
fn base<const O: bool>(
    rows: usize,
    values: [String; 4],
    font: gpui_canvas::FontFace,
) -> Win<Page<O>> {
    Win::recording_with_font(
        Page {
            values: values.map(Signal::new),
            rows,
        },
        WindowOptions {
            size: [960, 720],
            ..Default::default()
        },
        font,
    )
    .unwrap()
}
fn measure<const O: bool, L: LaneSet<Page<O>>>(
    mut win: Win<Page<O>, L>,
    remotes: [Remote<String>; 4],
    rows: usize,
    fields: usize,
    mode: &str,
    font: gpui_canvas::FontFace,
) {
    ack(&mut win);
    let mut next = 0u64;
    let mut step = |win: &mut Win<Page<O>, L>| {
        next += 1;
        for (i, r) in remotes.iter().enumerate().take(fields) {
            r.try_send(format!("{i}: {next}")).unwrap();
        }
        let d = win.deliver_ready(8).unwrap();
        assert_eq!((d.received, d.applied), (fields, fields));
        ack(win);
    };
    for _ in 0..200 {
        step(&mut win);
    }
    win.reset_counters().unwrap();
    println!("rows,fields,mode,batch,ops,cpu_ns,wall_ns");
    for batch in 0..40 {
        let wall = Instant::now();
        let cpu = cpu_ns();
        for _ in 0..100 {
            step(&mut win);
        }
        let cpu = cpu_ns() - cpu;
        let wall = wall.elapsed().as_nanos();
        println!("{rows},{fields},{mode},{batch},100,{cpu},{wall}");
    }
    let expected = std::array::from_fn(|i| {
        if i < fields {
            format!("{i}: {next}")
        } else {
            format!("{i}: 0")
        }
    });
    for (i, value) in expected.iter().enumerate() {
        assert_eq!(win.root().unwrap().values[i].as_str(), value);
        assert!(win.contains_text(value).unwrap());
    }
    let mut fresh = base::<O>(rows, expected, font);
    ack(&mut fresh);
    let actual = win.with_pixels(|p, _, _| p.to_vec()).unwrap();
    let oracle = fresh.with_pixels(|p, _, _| p.to_vec()).unwrap();
    assert_eq!(actual, oracle);
    let hash = actual.iter().fold(0xcbf29ce484222325u64, |h, &b| {
        (h ^ u64::from(b)).wrapping_mul(0x100000001b3)
    });
    eprintln!(
        "FINAL,pixel_hash={hash},source_epoch={}",
        win.snapshot().unwrap().source_epoch
    );
    eprintln!("COUNTERS,{:?}", win.counters());
}
fn run<const O: bool>(rows: usize, fields: usize, mode: &str, font: gpui_canvas::FontFace) {
    let cold = Instant::now();
    let win = base::<O>(
        rows,
        std::array::from_fn(|i| format!("{i}: 0")),
        font.clone(),
    );
    let (a, ai) = Remote::bounded(4);
    let (b, bi) = Remote::bounded(4);
    let (c, ci) = Remote::bounded(4);
    let (d, di) = Remote::bounded(4);
    let win = win
        .with_inbox_for(ai, Page::F[0], |v, n| *v = n)
        .unwrap()
        .with_inbox_for(bi, Page::F[1], |v, n| *v = n)
        .unwrap()
        .with_inbox_for(ci, Page::F[2], |v, n| *v = n)
        .unwrap();
    if mode == "opaque" {
        let win = win.with_inbox(di, |m, n| *m.values[3] = n).unwrap();
        eprintln!("COLD,wall_ns={}", cold.elapsed().as_nanos());
        measure(win, [a, b, c, d], rows, fields, mode, font);
    } else {
        let win = win.with_inbox_for(di, Page::F[3], |v, n| *v = n).unwrap();
        eprintln!("COLD,wall_ns={}", cold.elapsed().as_nanos());
        measure(win, [a, b, c, d], rows, fields, mode, font);
    }
}
fn main() {
    let args: Vec<_> = std::env::args().skip(1).collect();
    let rows = args[0].parse().unwrap();
    let fields = args[1].parse().unwrap();
    let mode = &args[2];
    assert!([1, 2, 4].contains(&fields));
    assert!([0, 1, 40].contains(&rows));
    assert!(["exact", "owner", "opaque"].contains(&mode.as_str()));
    assert!(mode != "opaque" || fields == 4);
    let font = gpui_canvas::FontFace::new(std::fs::read(&args[3]).unwrap()).unwrap();
    if mode == "owner" {
        run::<true>(rows, fields, mode, font);
    } else {
        run::<false>(rows, fields, mode, font);
    }
}
