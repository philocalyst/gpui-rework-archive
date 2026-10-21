//! Absolute opt-in interaction-map cost; no baseline editor capability implied.
use gpui_canvas::{CaretAffinity, FontFace, TextOffset, TextPosition};
use std::{hint::black_box, time::Instant};

fn main() {
    let count: usize = std::env::args()
        .nth(1)
        .unwrap_or_else(|| "1000".into())
        .parse()
        .unwrap();
    assert!((1..=32768).contains(&count));
    let sample = std::env::args().nth(2).unwrap_or_else(|| "ascii".into());
    let source = match sample.as_str() {
        "ascii" => "a".repeat(count),
        "rtl" => "עברית ".repeat(count / "עברית ".len()),
        "ligature" => "لَا ".repeat(count / "لَا ".len()),
        "combining" => format!("a{}", "\u{301}".repeat((count - 1) / 2)),
        _ => panic!("ascii|rtl|ligature|combining"),
    };
    let face = FontFace::bundled().unwrap();
    println!(
        "bytes,sample,stage,nanoseconds,retained_delta,total_requested,peak_new_bytes,allocations"
    );
    for interactive in [false, true] {
        let mut layout = None;
        let start = Instant::now();
        let allocation = allocation_counter::measure(|| {
            let mut shaper = face.shaper();
            layout = Some(if interactive {
                shaper.shape_interactive(&source, 16., None).unwrap()
            } else {
                shaper.shape(&source, 16., None).unwrap()
            });
        });
        let elapsed = start.elapsed().as_nanos();
        let layout = layout.unwrap();
        assert_eq!(layout.text_len(), source.len());
        if interactive {
            for byte in icu_segmenter::GraphemeClusterSegmenter::new().segment_str(&source) {
                for affinity in [CaretAffinity::Upstream, CaretAffinity::Downstream] {
                    assert!(
                        layout
                            .caret_bounds(TextPosition {
                                offset: TextOffset::new(byte).unwrap(),
                                affinity,
                            })
                            .is_some()
                    );
                }
            }
        }
        println!(
            "{},{sample},{},{elapsed},{},{},{},{}",
            source.len(),
            if interactive { "carets" } else { "plain" },
            allocation.bytes_current,
            allocation.bytes_total,
            allocation.bytes_max,
            allocation.count_total
        );
        black_box(layout);
    }
}
