use gpui::{Color, El, Remote, SendError, View, Win, div};
use std::{hint::black_box, time::Instant};
#[derive(Default)]
struct Page {
    total: u64,
    paint: bool,
}
impl View for Page {
    fn view(&self) -> El<'_> {
        div()
            .w(32)
            .h(32)
            .bg(if self.paint && !self.total.is_multiple_of(2) {
                Color::BLACK
            } else {
                Color::WHITE
            })
    }
}
fn main() {
    for round in 0..7 {
        let (full, inbox) = Remote::<u64>::bounded(0);
        let _win = Win::demo(Page::default())
            .with_inbox(inbox, |_: &mut Page, _: u64| {})
            .unwrap();
        let start = Instant::now();
        for n in 0..500_000 {
            assert!(matches!(
                full.try_send(black_box(n)),
                Err(SendError::Full(_))
            ));
        }
        let full_ns = start.elapsed().as_nanos() as f64 / 500_000.0;
        let (remote, inbox) = Remote::<u64>::bounded(8);
        let mut win = Win::with_size(Page::default(), 32, 32)
            .unwrap()
            .with_inbox(inbox, |m: &mut Page, n: u64| m.total += n)
            .unwrap();
        let mut enqueue = 0;
        for _ in 0..10_000 {
            let start = Instant::now();
            for _ in 0..8 {
                remote.try_send(black_box(1)).unwrap();
            }
            enqueue += start.elapsed().as_nanos();
            win.deliver_ready(8).unwrap();
        }
        let enqueue_ns = enqueue as f64 / 80_000.0;
        win.update(|m| m.paint = true).unwrap();
        let start = Instant::now();
        for _ in 0..2000 {
            remote.try_send(black_box(1)).unwrap();
            win.deliver_ready(1).unwrap();
            win.with_pixels(|pixels, _, _| black_box(pixels[0]))
                .unwrap();
        }
        let render_ns = start.elapsed().as_nanos() as f64 / 2000.0;
        assert_eq!(win.root().unwrap().total, 82000);
        println!("{round},{full_ns:.3},{enqueue_ns:.3},{render_ns:.3}");
    }
}
