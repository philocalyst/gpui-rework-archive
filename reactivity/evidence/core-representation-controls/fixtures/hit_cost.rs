use gpui::{Color, El, Point, View, Win, WindowOptions, column, div, row};
use std::{hint::black_box, time::Instant};
struct Page {
    count: usize,
    visible: bool,
}
impl View for Page {
    fn view(&self) -> El<'_> {
        let body = if self.visible {
            column((0..self.count.div_ceil(64)).map(|band| {
                row((band * 64..self.count.min((band + 1) * 64))
                    .map(|_| div().size(4).bg(Color::BLACK)))
                .h(4)
            }))
            .w(256)
            .h((self.count.div_ceil(64) * 4) as u32)
        } else {
            column((0..self.count).map(|_| div().w(64).h(24).bg(Color::BLACK)))
                .w(64)
                .h(48)
        };
        column((
            div().size(16).bg(Color::BLACK).on_click(|_: &mut Self| {}),
            body,
        ))
    }
}
fn open(count: usize, visible: bool) -> Win<Page> {
    let mut win = Win::recording(
        Page { count, visible },
        WindowOptions {
            size: if visible {
                [256, (16 + count.div_ceil(64) as u32 * 4).max(64)]
            } else {
                [64, 64]
            },
            ..Default::default()
        },
    )
    .unwrap();
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
    win
}
#[test]
#[ignore = "paired hit/mount cost probe; explicit quiet window only"]
fn public_hit_probe() {
    let preflight = std::env::var_os("GPUI_HIT_PREFLIGHT").is_some();
    for (visible, count) in [false, true].into_iter().flat_map(|visible| {
        [0, 127, 128, 1000, 10000, 40000]
            .into_iter()
            .filter(move |n| !visible || *n == 1000 || *n == 40000)
            .map(move |n| (visible, n))
    }) {
        let scene = if visible { "visible" } else { "clipped" };
        let win = open(count, visible);
        assert_eq!(
            win.snapshot().unwrap().nodes.len(),
            count + 3 + if visible { count.div_ceil(64) } else { 0 }
        );
        for (kind, point, expected) in [
            ("hit", Point { x: 8.0, y: 8.0 }, true),
            ("miss", Point { x: 48.0, y: 8.0 }, false),
        ] {
            assert_eq!(win.hit_target(point).unwrap().is_some(), expected);
            if preflight {
                println!("preflight,scene={scene},count={count},kind={kind},expected={expected}");
                continue;
            }
            let started = Instant::now();
            let costs = allocation_counter::measure(|| {
                for _ in 0..10000 {
                    assert_eq!(
                        black_box(&win)
                            .hit_target(black_box(point))
                            .unwrap()
                            .is_some(),
                        expected
                    );
                }
            });
            println!(
                "query,scene={scene},count={count},kind={kind},iterations=10000,total_ns={},allocations={},requested={},retained={}",
                started.elapsed().as_nanos(),
                costs.count_total,
                costs.bytes_total,
                costs.bytes_current
            );
        }
        if preflight {
            continue;
        }
        let iterations = if count < 1000 { 64 } else { 8 };
        let started = Instant::now();
        let costs = allocation_counter::measure(|| {
            for _ in 0..iterations {
                black_box(open(count, visible));
            }
        });
        println!(
            "mount,scene={scene},count={count},iterations={iterations},total_ns={},allocations={},requested={},retained={},peak={}",
            started.elapsed().as_nanos(),
            costs.count_total,
            costs.bytes_total,
            costs.bytes_current,
            costs.bytes_max
        );
    }
}
