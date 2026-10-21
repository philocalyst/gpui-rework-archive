//! Identical image-free public owner source, compiled against baseline/candidate.
use gpui::prelude::*;
use std::{hint::black_box, time::Instant};
#[cfg(image_candidate)]
const IMAGE_HANDLE_BYTES: usize = std::mem::size_of::<gpui::Image>();
#[cfg(not(image_candidate))]
const IMAGE_HANDLE_BYTES: usize = 0;
struct Page { labels: bool, active: bool }
impl View for Page {
    fn view(&self) -> El<'_> {
        let mut root = column(()).w(384).h(256).bg(if self.active { Color::rgb(240, 245, 250) } else { Color::WHITE });
        if self.labels {
            for _ in 0..12 { root = root.child(text("An ordinary image-free label").font_size(14).h(18)); }
        }
        root
    }
}
fn main() {
    let labels = std::env::args().nth(1).as_deref() == Some("labels");
    let mut mounted = None;
    let start = Instant::now();
    let allocation = allocation_counter::measure(|| {
        let mut win = Win::with_size(Page { labels, active: false }, 384, 256).unwrap();
        win.with_pixels(|p, _, _| { black_box(p); }).unwrap();
        mounted = Some(win);
    });
    let mount_us = start.elapsed().as_secs_f64()*1e6;
    let mut win = mounted.unwrap();
    let mut times = Vec::new();
    let mut digest = 0u64;
    for frame in 0..32 {
        let start = Instant::now();
        win.update(|page| page.active = !page.active).unwrap();
        win.with_pixels(|pixels, _, _| {
            digest = pixels.iter().fold(0u64, |n, &b| n.wrapping_mul(31).wrapping_add(u64::from(b)));
        }).unwrap();
        if frame >= 2 { times.push(start.elapsed().as_secs_f64()*1e6); }
    }
    for (frame, us) in times.iter().enumerate() { eprintln!("OWNER_FRAME,{labels},{},{us:.3}", frame+2); }
    times.sort_by(f64::total_cmp);
    println!("labels,image_handle_bytes,mount_us,mount_allocs,retained_bytes,peak_bytes,turn_p50_us,turn_p95_us,turn_p99_us,digest");
    println!("{labels},{IMAGE_HANDLE_BYTES},{mount_us:.3},{},{},{},{:.3},{:.3},{:.3},{digest}", allocation.count_total, allocation.bytes_current, allocation.bytes_max, times[15], times[28], times[29]);
}
