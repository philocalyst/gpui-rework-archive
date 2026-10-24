//! Structured glyph/source/caret oracle output. Historical Parley 0.11 profiles
//! compared this output with and without the old word-analysis feature.
use gpui_canvas::{CaretAffinity, FontFace, TextOffset, TextPosition};

fn main() {
    let face = FontFace::bundled().unwrap();
    let mut shaper = face.shaper();
    let mut sources = vec![
        String::new(),
        "office café AVATAR".into(),
        "Latin Ω Ελληνικά Привет नमस्ते".into(),
        "abc אבג العربية 123 xyz".into(),
        "a\r\nb\n".into(),
        "אבג\u{2028}123 abc\u{2029}123 abc".into(),
        "a\u{200d}ع\u{651}\u{2069}e\u{301} \u{2069}\u{2067}ع\u{651}П\n א".into(),
        format!("a{}", "\u{301}".repeat(512)),
    ];
    let tokens = [
        "a",
        " ",
        "Ω",
        "П",
        "א",
        "ب",
        "न",
        "स्ते",
        "e\u{301}",
        "ع\u{651}",
        "a\u{200d}",
        "\u{2067}",
        "\u{2069}",
        "\r\n",
        "\n",
        "\u{2028}",
    ];
    let mut seed = 0x1935ab23_u32;
    for _ in 0..100 {
        let mut source = String::new();
        for _ in 0..12 {
            seed ^= seed << 13;
            seed ^= seed >> 17;
            seed ^= seed << 5;
            source.push_str(tokens[seed as usize % tokens.len()]);
        }
        sources.push(source);
    }
    for source in sources {
        for width in [None, Some(20.), Some(80.)] {
            let layout = shaper.shape_interactive(&source, 18., width).unwrap();
            println!(
                "{source:?} {width:?} {:?}",
                [
                    layout.width.to_bits(),
                    layout.height.to_bits(),
                    layout.baseline.to_bits()
                ]
            );
            println!("{:?}", layout.glyphs().collect::<Vec<_>>());
            for run in layout.runs() {
                println!(
                    "run {:?} {:?} {} {}",
                    run.text_range(),
                    run.direction(),
                    run.line(),
                    run.glyphs().len()
                );
            }
            for line in layout.lines() {
                let b = line.bounds();
                println!(
                    "line {:?} {:?}",
                    line.text_range(),
                    [
                        b.x.to_bits(),
                        b.y.to_bits(),
                        b.width.to_bits(),
                        b.height.to_bits(),
                        line.baseline().to_bits()
                    ]
                );
            }
            for byte in 0..=source.len() {
                for affinity in [CaretAffinity::Upstream, CaretAffinity::Downstream] {
                    let geometry = layout.caret_bounds(TextPosition {
                        offset: TextOffset::new(byte).unwrap(),
                        affinity,
                    });
                    println!(
                        "caret {byte} {affinity:?} {:?}",
                        geometry.map(|b| [
                            b.x.to_bits(),
                            b.y.to_bits(),
                            b.width.to_bits(),
                            b.height.to_bits()
                        ])
                    );
                }
            }
        }
    }
}
