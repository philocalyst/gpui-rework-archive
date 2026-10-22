//! Matched scoped-shaper control; inputs and font initialization precede timing.
use gpui_canvas::{CaretAffinity, FontFace, TextLayout, TextOffset, TextPosition};
use std::{hint::black_box, time::Instant};

fn source(case: &str) -> String {
    match case {
        "tiny" => "Count".into(),
        "label" => "Counter value: 123".into(),
        "latin" => "office abcdef 123 xyz ".repeat(1_400),
        "rtl" => "אבגדה 123 العربية ".repeat(900),
        "mixed" => "abc אבג 123 xyz a\u{301}b\u{200d}c ".repeat(900),
        "paragraphs" => "a\u{2028}bc\r\ndef\n".repeat(900),
        "one-grapheme" => format!("a{}", "\u{301}".repeat(12_000)),
        _ => panic!("unknown case {case}"),
    }
}

#[inline(never)]
fn cold(face: &FontFace, source: &str) -> TextLayout {
    face.shaper()
        .shape_interactive(source, 16., Some(400.))
        .unwrap()
}

fn checksum(layout: &TextLayout, source: &str) -> u64 {
    let mut result = 0xcbf2_9ce4_8422_2325u64;
    let mut add = |word: u32| {
        result = (result ^ u64::from(word)).wrapping_mul(0x100_0000_01b3);
    };
    for value in [layout.width, layout.height, layout.baseline] {
        add(value.to_bits());
    }
    add(layout.glyphs().len() as u32);
    for offset in [0, source.len() / 2, source.len()] {
        for affinity in [CaretAffinity::Upstream, CaretAffinity::Downstream] {
            if let Some(bounds) = layout.caret_bounds(TextPosition {
                offset: TextOffset::new(offset).unwrap(),
                affinity,
            }) {
                for value in [bounds.x, bounds.y, bounds.width, bounds.height] {
                    add(value.to_bits());
                }
            }
        }
    }
    result
}

fn main() {
    let arguments = std::env::args().skip(1).collect::<Vec<_>>();
    assert_eq!(arguments.len(), 4, "case cold|warm alloc|time iterations");
    let [case, scope, mode, rounds] = arguments.as_slice() else {
        unreachable!()
    };
    assert!(matches!(scope.as_str(), "cold" | "warm"));
    assert!(matches!(mode.as_str(), "alloc" | "time"));
    let rounds: usize = rounds.parse().unwrap();
    assert!(rounds > 0);
    let source = source(case);
    assert!(
        source.len() <= 32 * 1024,
        "fixture exceeds the text admission limit"
    );
    let face = FontFace::bundled().unwrap();
    // Prime global font discovery/leases equally. Cold means a fresh scoped
    // Planner, not a cold process, cold file cache or first native window.
    drop(cold(&face, &source));
    let mut shaper = face.shaper();
    if scope == "warm" {
        drop(shaper.shape_interactive(&source, 16., Some(400.)).unwrap());
    }
    let mut last = None;
    let mut operation = || {
        last = Some(black_box(if scope == "cold" {
            cold(&face, black_box(&source))
        } else {
            shaper
                .shape_interactive(black_box(&source), 16., Some(400.))
                .unwrap()
        }));
    };
    if mode == "alloc" {
        assert_eq!(rounds, 1);
        let info = allocation_counter::measure(&mut operation);
        let hash = checksum(last.as_ref().unwrap(), &source);
        println!(
            "alloc,{case},{scope},bytes={},count={},requested={},retained={},peak={},checksum={hash:016x}",
            source.len(),
            info.count_total,
            info.bytes_total,
            info.bytes_current,
            info.bytes_max
        );
    } else {
        let start = Instant::now();
        for _ in 0..rounds {
            operation();
        }
        let elapsed = start.elapsed().as_nanos();
        let hash = checksum(last.as_ref().unwrap(), &source);
        println!(
            "time,{case},{scope},bytes={},rounds={rounds},ns={elapsed},checksum={hash:016x}",
            source.len()
        );
    }
}
