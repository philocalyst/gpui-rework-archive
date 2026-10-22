//! Ordinary text queries for matched source-cut measurements. No testing API.
use gpui_canvas::{
    CaretAffinity, FontFace, Point, TextLayout, TextOffset, TextPosition, TextSelection,
};
use std::{hint::black_box, time::Instant};

fn endpoint(byte: usize) -> TextPosition {
    TextPosition {
        offset: TextOffset::new(byte).unwrap(),
        affinity: CaretAffinity::Downstream,
    }
}

#[inline(never)]
fn hit(layout: &TextLayout, point: Point) -> TextPosition {
    layout.position_at(point).unwrap()
}

#[inline(never)]
fn motion(layout: &TextLayout, position: TextPosition) -> TextPosition {
    layout.previous_visual(position).unwrap()
}

#[inline(never)]
fn selected(layout: &TextLayout, range: TextSelection) -> u64 {
    let mut signature = 0_u64;
    assert!(layout.selection_rects(range, |rect, line| {
        for bits in [
            rect.x.to_bits(),
            rect.y.to_bits(),
            rect.width.to_bits(),
            rect.height.to_bits(),
            line as u32,
        ] {
            signature = signature.rotate_left(7) ^ u64::from(bits);
        }
    }));
    signature
}

fn main() {
    let rounds = std::env::args()
        .nth(1)
        .map_or(2_000, |s| s.parse::<usize>().unwrap());
    let paragraphs = std::env::args()
        .nth(2)
        .map_or(1_800, |s| s.parse::<usize>().unwrap());
    assert!(rounds > 0 && (1..=1_800).contains(&paragraphs));
    let source = "abc אבג 123\n".repeat(paragraphs);
    let font = FontFace::bundled().unwrap();
    let layout = font
        .shaper()
        .shape_interactive(&source, 18., Some(55.))
        .unwrap();
    let first = layout.lines().next().unwrap();
    let last = layout.lines().nth(layout.lines().count() - 2).unwrap();
    let first_point = Point {
        x: 8.,
        y: first.bounds().y + 1.,
    };
    let last_point = Point {
        x: 8.,
        y: last.bounds().y + 1.,
    };
    let caret = endpoint(last.text_range().start.byte() + 1);
    let local = TextSelection {
        anchor: endpoint(last.text_range().start.byte()),
        focus: caret,
    };
    let whole = TextSelection {
        anchor: endpoint(0),
        focus: endpoint(source.len()),
    };
    println!("case,bytes,lines,rounds,nanoseconds,signature");
    for case in [
        "hit_first",
        "hit_last",
        "motion_last",
        "selection_local",
        "selection_whole",
    ] {
        let iterations = if case == "selection_whole" {
            rounds / 100 + 1
        } else {
            rounds
        };
        let query = || match case {
            "hit_first" => hit(black_box(&layout), black_box(first_point))
                .offset
                .byte() as u64,
            "hit_last" => hit(black_box(&layout), black_box(last_point)).offset.byte() as u64,
            "motion_last" => motion(black_box(&layout), black_box(caret)).offset.byte() as u64,
            "selection_local" => selected(black_box(&layout), black_box(local)),
            "selection_whole" => selected(black_box(&layout), black_box(whole)),
            _ => unreachable!(),
        };
        let signature = query();
        let start = Instant::now();
        for _ in 0..iterations {
            black_box(query());
        }
        println!(
            "{case},{},{},{iterations},{},{signature}",
            source.len(),
            layout.lines().count(),
            start.elapsed().as_nanos()
        );
    }
}
