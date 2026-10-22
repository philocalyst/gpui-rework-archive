use gpui_canvas::{Affine, Canvas, Color, ColorConfig, PaintEdit, PaintIndex, Rect};
use std::{hint::black_box, time::Instant};

const WIDTH: u32 = 1024;
const SIDE: usize = 64;
const CLIP: Rect = Rect::new(0.0, 0.0, WIDTH as f32, WIDTH as f32);
fn recording() -> Canvas {
    Canvas::recording(WIDTH, WIDTH, ColorConfig::default()).unwrap()
}
fn scene(canvas: &mut Canvas, shift: f32) -> [PaintIndex; 2] {
    let mut pending = canvas.stage();
    pending.clear(Color::WHITE);
    let mut first = None;
    let mut last = None;
    for i in 0..SIDE * SIDE {
        let at = pending.paint_cursor();
        pending.fill_rect(Rect::new((i % SIDE * 16) as f32 + shift,
            (i / SIDE * 16) as f32, 16.0, 16.0), Affine::IDENTITY, CLIP,
            if i % 2 == 0 { Color::BLACK } else { Color::rgb(80, 100, 120) }).unwrap();
        let index = pending.paint_index(at).unwrap();
        first.get_or_insert(index);
        last = Some(index);
    }
    pending.commit();
    [first.unwrap(), last.unwrap()]
}
fn hash(words: &[u32]) -> u64 {
    words.iter().fold(0xcbf29ce484222325, |h, &w| (h ^ u64::from(w)).wrapping_mul(0x100000001b3))
}
fn phase(name: &str, iterations: usize, mut run: impl FnMut(usize)) {
    let started = Instant::now();
    let measured = allocation_counter::measure(|| {
        for i in 0..iterations { run(i); }
    });
    let ns = started.elapsed().as_nanos();
    println!("phase,{name},iterations={iterations},total_ns={ns},ns_each={},requests={},requested_bytes={},live_bytes={}",
        ns / iterations as u128, measured.count_total, measured.bytes_total, measured.bytes_current);
}
#[test]
#[ignore = "paired performance probe; explicit quiet-window capture only"]
fn bin_phase_probe() {
    println!("layout,Canvas={}", size_of::<Canvas>());
    phase("recording_only", 20000, |_| {
        black_box(recording());
    });
    let mut tiny = [0; 64 * 48];
    phase("first_blank_cpu", 2000, |_| {
        let mut c = Canvas::recording(64, 48, ColorConfig::default()).unwrap();
        c.clear(Color::WHITE);
        c.render_bgrx(&mut tiny).unwrap();
        black_box(&tiny);
    });
    println!("digest,first_blank_cpu,{}", hash(&tiny));
    let mut words = vec![0; (WIDTH * WIDTH) as usize];
    phase("first_panel_scene", 8, |_| {
        let mut c = recording();
        scene(&mut c, 0.0);
        c.render_bgrx(&mut words).unwrap();
        black_box(&words);
    });
    println!("digest,first_panel_scene,{}", hash(&words));
    let mut c = recording();
    let indices = scene(&mut c, 0.0);
    c.render_bgrx(&mut words).unwrap();
    let edits = [PaintEdit::new(indices[0], Color::WHITE)];
    let damage = c.prepare_paint(&edits).unwrap().commit();
    c.render_bgrx_region(&mut words, damage).unwrap();
    phase("same_tile_color_repair", 1000, |i| {
        let edits = [PaintEdit::new(indices[0], if i % 2 == 0 { Color::BLACK } else { Color::WHITE })];
        let damage = c.prepare_paint(&edits).unwrap().commit();
        c.render_bgrx_region(&mut words, damage).unwrap();
        black_box(&words);
    });
    println!("digest,same_tile_color_repair,{}", hash(&words));
    phase("alternating_tile_color_repair", 128, |i| {
        let edits = [PaintEdit::new(indices[i % 2], if i % 4 < 2 { Color::BLACK } else { Color::WHITE })];
        let damage = c.prepare_paint(&edits).unwrap().commit();
        c.render_bgrx_region(&mut words, damage).unwrap();
        black_box(&words);
    });
    println!("digest,alternating_tile_color_repair,{}", hash(&words));
    phase("full_color_raster", 24, |i| {
        let edits = [PaintEdit::new(indices[0], if i % 2 == 0 { Color::BLACK } else { Color::WHITE })];
        c.prepare_paint(&edits).unwrap().commit();
        c.render_bgrx(&mut words).unwrap();
        black_box(&words);
    });
    println!("digest,full_color_raster,{}", hash(&words));
    phase("full_geometry_replacement", 12, |i| {
        scene(&mut c, if i % 2 == 0 { 0.0 } else { 0.25 });
        c.render_bgrx(&mut words).unwrap();
        black_box(&words);
    });
    println!("digest,full_geometry_replacement,{}", hash(&words));
    println!("final,csr_capacity_bytes={},output_capacity_bytes={}", c.stats().bin_bytes, c.output_bytes());
}
