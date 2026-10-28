use gpui_canvas::{CaretAffinity, FontFace, Point, Rect, TextOffset, TextPosition, TextSelection};
fn rect(r: Rect) -> [u32; 4] { [r.x, r.y, r.width, r.height].map(f32::to_bits) }
fn main() {
    let mut case = 0;
    let sources = [
        String::new(), "a".into(), "office ffi fi  spaces   tail ".into(),
        "a\u{301}b\u{200d}c".into(),
        "abc אבג 123 xyz العربية نهاية".into(), "\r\n\u{2028}\u{2028}end\n".into(),
        format!("a{}", "\u{301}".repeat(150)), "\u{2067}אבג 12\u{2069} x".into(),
        "office café אבג and العربية ".repeat(12), "a".repeat(32768),
        "a".repeat(32769), "x\t".into(), "漢".into(), "\u{0000}漢".into(),
    ];
    for (font, face) in [("bundled", FontFace::bundled().unwrap()), ("custom", FontFace::new(include_bytes!("../assets/NotoSans.ttf")).unwrap())] {
        let mut shaper = face.shaper();
        for (source_index, source) in sources.iter().enumerate() {
            for width in [None, Some(f32::MIN_POSITIVE), Some(30.), Some(180.), Some(0.), Some(-1.), Some(f32::INFINITY), Some(f32::NAN)] {
                for size in [16., 24., 0., 513., f32::NAN] {
                    println!("CASE {case} font={font} source={source_index} width={:?} size={}", width.map(f32::to_bits), size.to_bits());
                    #[cfg(feature = "metrics")]
                    eprintln!("MEASURE {case} {:?}", shaper.measure(source, size, width).map(|m| [m.width, m.height, m.baseline].map(f32::to_bits)));
                    for interactive in [false, true] {
                        let shape = if interactive { shaper.shape_interactive(source, size, width) } else { shaper.shape(source, size, width) };
                        println!("METRIC {case} {interactive} {:?}", shape.as_ref().map(|s| [s.width, s.height, s.baseline].map(f32::to_bits)).map_err(Clone::clone));
                        // Long admission probes only need bounds and glyph identity;
                        // short Unicode cases exercise every original-byte offset.
                        if let Ok(shape) = shape {
                            println!("GLYPHS {:?}", shape.glyphs());
                            for run in shape.runs() { println!("RUN {:?} {:?} {} {:?}", run.text_range(), run.direction(), run.line(), run.glyphs()); }
                            for line in shape.lines() { println!("LINE {:?} {:?} {}", line.text_range(), rect(line.bounds()), line.baseline().to_bits()); }
                            if source.len() <= 1024 && interactive {
                                for byte in 0..=source.len() {
                                    for affinity in [CaretAffinity::Upstream, CaretAffinity::Downstream] {
                                        let position = TextPosition { offset: TextOffset::new(byte).unwrap(), affinity };
                                        println!("CARET {byte} {affinity:?} {:?} {:?} {:?}", shape.caret_bounds(position).map(rect), shape.previous_visual(position), shape.next_visual(position));
                                    }
                                }
                                for x in [-20., 0., 16., 60., 200.] { for y in [-1., 0., 22., 100.] { println!("HIT {x} {y} {:?}", shape.position_at(Point {x,y})); } }
                                let mut selection = Vec::new();
                                let valid = shape.selection_rects(TextSelection::from_bytes(0, source.len()).unwrap(), |r,d| selection.push((rect(r), d)));
                                println!("SELECTION {valid} {selection:?}");
                                println!("GRAPHEMES {:?}", shape.geometry().unwrap().graphemes().map(|g| (g.text_range(),rect(g.bounds()),g.line(),g.direction(),g.is_hard_break())).collect::<Vec<_>>());
                            }
                        }
                    }
                    case += 1;
                }
            }
        }
    }
    eprintln!("CASES {case}");
}
