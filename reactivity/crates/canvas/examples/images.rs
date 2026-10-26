//! Exact resource/allocator ledger and warm serial full-raster wall time.
#[path = "support/images.rs"]
mod fixture;
use gpui_canvas::Canvas;
use std::{hint::black_box, time::Instant};
fn main() {
    let case = std::env::args().nth(1).unwrap_or_else(|| "one".into());
    let mut canvas = None;
    let start = Instant::now();
    let construction = allocation_counter::measure(|| canvas = Some(fixture::scene(&case)));
    let build_us = start.elapsed().as_secs_f64() * 1e6;
    let mut canvas = canvas.unwrap();
    let mut output = vec![0; 384 * 256];
    let mut expected = Vec::new();
    let mut times = Vec::new();
    let mut allocation_count = 0;
    let mut allocation_bytes = 0;
    for frame in 0..15 {
        let start = Instant::now();
        let allocation = allocation_counter::measure(|| canvas.render_bgrx(&mut output).unwrap());
        let us = start.elapsed().as_secs_f64() * 1e6;
        if frame == 0 {
            expected.clone_from(&output);
        }
        assert_eq!(output, expected);
        if frame >= 3 {
            allocation_count += allocation.count_total;
            allocation_bytes += allocation.bytes_total;
            times.push(us);
        }
        black_box(&output);
    }
    for (frame, us) in times.iter().enumerate() {
        eprintln!("CPU_IMAGE_FRAME,{case},{},{us:.3}", frame + 3);
    }
    times.sort_by(f64::total_cmp);
    let scene = canvas.prepared_scene();
    let storage = scene.storage();
    let payload: usize = scene.images().map(|image| image.pixel_bytes()).sum();
    let digest = output
        .iter()
        .fold(0u64, |v, &p| v.wrapping_mul(31).wrapping_add(u64::from(p)));
    println!(
        "case,canvas_header,resource_header,resources,payload_bytes,lane_bytes,index_capacity,build_us,build_allocs,build_retained,build_peak,raster_p50_us,raster_p95_us,raster_p99_us,warm_allocs,warm_alloc_bytes,digest"
    );
    println!(
        "{case},{},{},{},{payload},{},{},{build_us:.3},{},{},{},{:.3},{:.3},{:.3},{allocation_count},{allocation_bytes},{digest}",
        size_of::<Canvas>(),
        storage.resource_header_bytes,
        scene.images().count(),
        storage.lane_bytes(),
        storage.resource_index_capacity,
        construction.count_total,
        construction.bytes_current,
        construction.bytes_max,
        times[6],
        times[11],
        times[11]
    );
}
