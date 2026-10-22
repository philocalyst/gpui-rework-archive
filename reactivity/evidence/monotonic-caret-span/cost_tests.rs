//! Already-shaped producer allocation controls; shaping is outside the counter.
use crate::{FontFamilyName, LayoutContext, OverflowWrap, StyleProperty, editing::CursorGeometry};
use alloc::{format, string::String};
use core::{hint::black_box, ops::ControlFlow};

#[test]
fn indexed_and_streamed_scoped_allocation_rows() {
    let mut fonts = super::span_tests::fonts();
    let mut context = LayoutContext::new();
    for (name, source, width) in [
        ("empty", String::new(), None),
        ("tiny", "Count".into(), None),
        ("label", "Counter value: 123".into(), None),
        ("out_of_order", "abcdefghijklmno".into(), Some(30.)),
        ("ascii32k", "a".repeat(32 * 1024), Some(400.)),
        ("latin", "office abcdef 123 xyz ".repeat(1400), Some(400.)),
        ("rtl", "אבגדה 123 العربية ".repeat(900), Some(400.)),
        (
            "mixed",
            "abc אבג 123 xyz a\u{301}b\u{200d}c ".repeat(900),
            Some(400.),
        ),
        ("paragraphs", "a\u{2028}bc\r\ndef\n".repeat(900), Some(400.)),
        (
            "one_grapheme",
            format!("a{}", "\u{301}".repeat(12_000)),
            Some(400.),
        ),
    ] {
        assert!(source.len() <= 32 * 1024);
        let families = ["primary", "Arabic", "Hebrew"].map(|s| FontFamilyName::Named(s.into()));
        let mut builder = context.ranged_builder(&mut fonts, &source, 1., false);
        builder.push_default(&families[..]);
        builder.push_default(StyleProperty::FontSize(16.));
        builder.push_default(StyleProperty::OverflowWrap(OverflowWrap::Anywhere));
        let mut layout = builder.build(&source);
        layout.break_all_lines(width);
        if name == "out_of_order" {
            assert!(layout.data.lines.len() > 1);
            layout.data.lines.swap(0, 1);
        }
        let mut expected = 0_u64;
        let old = allocation_counter::measure(|| {
            let index = CursorGeometry::new(black_box(&layout)).unwrap();
            for byte in 0..=source.len() {
                if let Some(pair) = index.geometries_at(byte, 1.) {
                    expected = fold(expected, byte, pair);
                }
            }
            black_box(&index);
        });
        let mut actual = 0_u64;
        let stream = allocation_counter::measure(|| {
            assert_eq!(
                CursorGeometry::try_for_each_pair(
                    black_box(&layout),
                    0..=source.len(),
                    1.,
                    |byte, pair| {
                        if let Some(pair) = pair {
                            actual = fold(actual, byte, pair);
                        }
                        ControlFlow::<()>::Continue(())
                    },
                ),
                Some(ControlFlow::Continue(()))
            );
        });
        assert_eq!(actual, expected);
        for (variant, row) in [("index", old), ("stream", stream)] {
            assert_eq!(row.count_current, 0);
            assert_eq!(row.bytes_current, 0);
            println!(
                "SCOPED case={name} variant={variant} bytes={} lines={} allocations={} requested={} peak={} retained={} checksum={expected:016x}",
                source.len(),
                layout.len(),
                row.count_total,
                row.bytes_total,
                row.bytes_max,
                row.bytes_current
            );
        }
    }
}

fn fold(mut hash: u64, byte: usize, pair: [crate::BoundingBox; 2]) -> u64 {
    hash = hash.wrapping_mul(0x100_0000_01b3) ^ byte as u64;
    for rect in pair {
        for value in [rect.x0, rect.y0, rect.x1, rect.y1] {
            hash = hash.wrapping_mul(0x100_0000_01b3) ^ value.to_bits();
        }
    }
    hash
}
