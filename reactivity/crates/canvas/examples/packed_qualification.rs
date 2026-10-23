//! Public semantic/readback control. No timing; the same source builds both pins.
use gpui_canvas::{
    Affine, Canvas, CaretAffinity, Color, ColorConfig, FontFace, OutputProfile, Point, Rect,
    TextOffset, TextPosition, TextSelection, TextSystem,
};
use std::{io::Write, path::PathBuf};
fn main() {
    let output = PathBuf::from(std::env::args_os().nth(1).expect("capture directory"));
    std::fs::create_dir_all(&output).unwrap();
    let mut allocations = std::fs::File::create(output.join("allocations.txt")).unwrap();
    writeln!(
        allocations,
        "layout_header={}",
        std::mem::size_of::<gpui_canvas::TextLayout>()
    )
    .unwrap();
    let face = FontFace::bundled().unwrap();
    let mut text = TextSystem::from_font(face.clone());
    let mut shaper = face.shaper();
    let sources = [
        ("empty", String::new()),
        ("label", "a short label".into()),
        ("ligatures", "office affine AVATAR".into()),
        ("marks", "e\u{301} a\u{323}\u{301} العربية".into()),
        ("hebrew", "אבג דהו".into()),
        ("arabic", "العربية مرحبا".into()),
        ("bidi", "abc אבג 123 العربية xyz".into()),
        (
            "isolates",
            "a \u{2067}אבג 12\u{2069} b \u{202e}BC\u{202c}D".into(),
        ),
        (
            "paragraphs",
            "a\r\n\r\nb\r\n\u{2028}\u{2028}\u{2029}".into(),
        ),
        ("ignorables", "a\u{200d}b \u{2067}\u{2069} e\u{301}".into()),
        ("long_grapheme", format!("a{}", "\u{301}".repeat(1024))),
        ("max_ascii", "a".repeat(32768)),
        ("max_tail", format!("{}z", "a".repeat(32767))),
        ("max_bidi", "א".repeat(16384)),
    ];
    for (name, source) in sources {
        for (width_index, width) in [None, Some(1.), Some(55.), Some(400.)]
            .into_iter()
            .enumerate()
        {
            for interactive in [false, true] {
                let tag = format!("{name}-w{width_index}-i{}", u8::from(interactive));
                let mut shaped = None;
                let cost = allocation_counter::measure(|| {
                    shaped = Some(
                        if interactive {
                            shaper.shape_interactive(&source, 16., width)
                        } else {
                            shaper.shape(&source, 16., width)
                        }
                        .unwrap(),
                    )
                });
                let layout = shaped.unwrap();
                writeln!(allocations, "{tag} {cost:?}").unwrap();
                println!(
                    "CASE {tag} bytes={} glyphs={} metrics={:08x}/{:08x}/{:08x}",
                    layout.text_len(),
                    layout.glyphs().len(),
                    layout.width.to_bits(),
                    layout.height.to_bits(),
                    layout.baseline.to_bits()
                );
                assert_eq!(layout.text_len(), source.len());
                for g in layout.glyphs() {
                    println!(
                        "G {} {} {:08x} {:08x}",
                        g.id,
                        g.cluster,
                        g.x.to_bits(),
                        g.baseline.to_bits()
                    );
                }
                for run in layout.runs() {
                    println!(
                        "R {:?} {:?} {} {} {:?}",
                        run.text_range(),
                        run.direction(),
                        run.line(),
                        run.glyphs().len(),
                        run.font_face()
                    );
                }
                for line in layout.lines() {
                    let r = line.bounds();
                    println!(
                        "L {:?} {:08x}/{:08x}/{:08x}/{:08x}/{:08x}",
                        line.text_range(),
                        r.x.to_bits(),
                        r.y.to_bits(),
                        r.width.to_bits(),
                        r.height.to_bits(),
                        line.baseline().to_bits()
                    );
                }
                for byte in [
                    0,
                    1,
                    source.len() / 2,
                    source.len().saturating_sub(1),
                    source.len(),
                    source.len() + 1,
                ] {
                    for affinity in [CaretAffinity::Upstream, CaretAffinity::Downstream] {
                        let r = layout.caret_bounds(TextPosition {
                            offset: TextOffset::new(byte).unwrap(),
                            affinity,
                        });
                        println!(
                            "C {byte} {affinity:?} {:?}",
                            r.map(|r| [
                                r.x.to_bits(),
                                r.y.to_bits(),
                                r.width.to_bits(),
                                r.height.to_bits()
                            ])
                        );
                    }
                }
                for (start, end) in [(0, source.len()), (source.len(), 0), (1, source.len() + 1)] {
                    let selected = layout.selection_rects(
                        TextSelection::from_bytes(start, end).unwrap(),
                        |r, line| {
                            println!(
                                "S {start} {end} {line} {:08x}/{:08x}/{:08x}/{:08x}",
                                r.x.to_bits(),
                                r.y.to_bits(),
                                r.width.to_bits(),
                                r.height.to_bits()
                            )
                        },
                    );
                    println!("V {start} {end} {selected}");
                }
                for hdr in [false, true] {
                    let config = if hdr {
                        ColorConfig::linear_hdr(OutputProfile::Srgb, 203.).unwrap()
                    } else {
                        ColorConfig::default()
                    };
                    let mut canvas = Canvas::with_color_config(192, 96, config).unwrap();
                    canvas.clear(Color::linear_srgb(0.1, 0.2, 0.3, 1.).unwrap());
                    canvas
                        .draw_text_scaled(
                            &mut text,
                            &layout,
                            Point { x: 3., y: 2. },
                            Affine::IDENTITY,
                            Rect::new(0., 0., 192., 96.),
                            Color::WHITE,
                            1.,
                        )
                        .unwrap();
                    std::fs::write(
                        output.join(format!("{tag}-hdr{}.raw", u8::from(hdr))),
                        canvas.pixels(),
                    )
                    .unwrap();
                    println!("WORK {tag} {hdr} {:?}", canvas.stats());
                }
            }
        }
    }
}
