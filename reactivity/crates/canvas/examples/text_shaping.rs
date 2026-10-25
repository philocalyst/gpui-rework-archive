//! Same source is compiled against baseline and candidate. Both borrow exactly
//! one parser per pass. Allocation counts are requested thread-local bytes.
use gpui_canvas::{
    Affine, Canvas, Color, ColorConfig, FontFace, Glyph, Point, Rect, TextLayout, TextSystem,
};
use std::{hint::black_box, time::Instant};

fn labels(mode: &str) -> &'static [&'static str] {
    match mode {
        "labels" => &[
            "Settings",
            "office café AVATAR",
            "Play 001",
            "Search library",
        ],
        "unicode" => &[
            "Hello Ελληνικά Привет नमस्ते",
            "abc العربية אבג 123",
            "a\r\nb\r\n",
        ],
        _ => panic!("labels|unicode"),
    }
}
fn report(
    mode: &str,
    count: usize,
    stage: &str,
    nanos: u128,
    allocation: allocation_counter::AllocationInfo,
    glyphs: usize,
) {
    println!(
        "{mode},{count},{stage},{nanos},{},{},{},{},{glyphs},{},{}",
        allocation.bytes_current,
        allocation.bytes_total,
        allocation.bytes_max,
        allocation.count_total,
        size_of::<TextLayout>(),
        size_of::<Glyph>()
    );
}
fn main() {
    let mode = std::env::args().nth(1).unwrap_or_else(|| "labels".into());
    let count = std::env::args()
        .nth(2)
        .unwrap_or_else(|| "1".into())
        .parse::<usize>()
        .unwrap();
    assert!([0, 1, 1000].contains(&count));
    println!(
        "mode,count,stage,nanoseconds,retained_delta,total_requested,peak_new_bytes,allocations,glyphs,layout_header,glyph_bytes"
    );
    let samples = labels(&mode);
    if count == 0 {
        let allocation = allocation_counter::measure(|| {
            black_box(Canvas::recording(640, 480, ColorConfig::default()).unwrap());
        });
        report(&mode, count, "textless", 0, allocation, 0);
        return;
    }
    let face = FontFace::bundled().unwrap();
    let mut layouts = Vec::with_capacity(count);
    let start = Instant::now();
    let cold = allocation_counter::measure(|| {
        let mut parser = face.shaper();
        for index in 0..count {
            layouts.push(
                parser
                    .shape(samples[index % samples.len()], 16., Some(600.))
                    .unwrap(),
            );
        }
    });
    let elapsed = start.elapsed().as_nanos();
    let glyphs = layouts.iter().map(|layout| layout.glyphs().len()).sum();
    report(&mode, count, "cold_pass", elapsed, cold, glyphs);
    layouts.clear();
    let mut parser = face.shaper();
    black_box(parser.shape(samples[0], 16., Some(600.)).unwrap());
    let start = Instant::now();
    let warm = allocation_counter::measure(|| {
        for index in 0..count {
            layouts.push(
                parser
                    .shape(samples[index % samples.len()], 16., Some(600.))
                    .unwrap(),
            );
        }
    });
    let elapsed = start.elapsed().as_nanos();
    report(&mode, count, "warm_pass", elapsed, warm, glyphs);
    drop(parser);
    let mut text = TextSystem::from_font(face);
    let mut canvas = Canvas::recording(640, 480, ColorConfig::default()).unwrap();
    canvas.clear(Color::WHITE);
    let start = Instant::now();
    let prepare = allocation_counter::measure(|| {
        for (index, layout) in layouts.iter().enumerate() {
            canvas
                .draw_text(
                    &mut text,
                    layout,
                    Point {
                        x: 8.,
                        y: (index % 16) as f32 * 28.,
                    },
                    Affine::IDENTITY,
                    Rect::new(0., 0., 640., 480.),
                    Color::BLACK,
                )
                .unwrap();
        }
    });
    report(
        &mode,
        count,
        "prepare",
        start.elapsed().as_nanos(),
        prepare,
        glyphs,
    );
    let mut output = vec![0_u32; 640 * 480];
    let start = Instant::now();
    let render = allocation_counter::measure(|| canvas.render_bgrx(&mut output).unwrap());
    report(
        &mode,
        count,
        "render",
        start.elapsed().as_nanos(),
        render,
        glyphs,
    );
    assert!(output.iter().any(|&pixel| pixel != 0x00ffffff));
    save_pixels("render", &output);
    black_box(output);
}

// Optional preflight artifact. Explicit per-word bytes, no pixel reinterpretation.
fn save_pixels(stage: &str, pixels: &[u32]) {
    if let Ok(prefix) = std::env::var("GPUI_TEXT_PIXELS") {
        use std::io::Write;
        let mut file = std::io::BufWriter::new(std::fs::File::create(format!("{prefix}.{stage}.bgrx")).unwrap());
        for pixel in pixels { file.write_all(&pixel.to_le_bytes()).unwrap(); }
        file.flush().unwrap();
    }
}
