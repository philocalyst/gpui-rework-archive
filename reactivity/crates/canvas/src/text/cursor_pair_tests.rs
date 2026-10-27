//! Compare the bulk pair with two independent, unindexed producer queries.
use super::*;
use parley::{Alignment, AlignmentOptions};

fn bits(bounds: parley::BoundingBox) -> [u64; 4] {
    [bounds.x0, bounds.y0, bounds.x1, bounds.y1].map(f64::to_bits)
}

#[test]
fn indexed_affinity_pairs_preserve_every_direct_geometry_bit() {
    let _registry = super::super::BUNDLED_TEST_LOCK.lock().unwrap();
    let face = FontFace::bundled().unwrap();
    let mut planner = Planner::new(&face).unwrap();
    let families = FAMILIES.map(|name| FontFamilyName::Named(name.into()));
    let mut accepted = 0;
    let mut snapped = 0;
    let mut distinct = 0;
    for source in [
        "",
        "a",
        "abcdef",
        "abcdefg",
        "abcdefgh",
        "office ffi fi  spaces   tail ",
        "a\u{301}b\u{200d}c defghijklmnop",
        "abc אבג 123 xyz العربية نهاية",
        "אבגדהוזחטיךכלםמןנסעףפץצקרשת",
        "a\u{2067}אבג 12\u{2069} z\u{2028}next\r\nlast",
        "\r\n\u{2028}\u{2028}end\n",
    ] {
        planner.coverage(source).unwrap();
        for wrap in [None, Some(30.), Some(80.)] {
            for height in [0., 22.] {
                for spacing in [-20., -0., 1.25] {
                    for styled in [false, true] {
                        let mut builder = planner.state.context.ranged_builder(
                            &mut planner.state.fonts,
                            source,
                            1.,
                            false,
                        );
                        builder.push_default(&families[..]);
                        builder.push_default(StyleProperty::FontSize(16.));
                        builder.push_default(StyleProperty::LineHeight(
                            parley::LineHeight::Absolute(height),
                        ));
                        builder.push_default(StyleProperty::LetterSpacing(spacing));
                        builder.push_default(StyleProperty::OverflowWrap(OverflowWrap::Anywhere));
                        if styled {
                            let split = source.char_indices().nth(3).map_or(source.len(), |x| x.0);
                            builder.push(StyleProperty::FontSize(23.), split..source.len());
                        }
                        builder.build_into(&mut planner.state.layout, source);
                        planner.state.layout.break_all_lines(wrap);
                        for alignment in [
                            Alignment::Start,
                            Alignment::Center,
                            Alignment::End,
                            Alignment::Justify,
                        ] {
                            planner
                                .state
                                .layout
                                .align(alignment, AlignmentOptions::default());
                            let geometry = CursorGeometry::new(&planner.state.layout).unwrap();
                            assert_lowered_stops(&planner.state.layout, source);
                            for byte in (0..=source.len()).chain([usize::MAX]) {
                                for width in [-0., 1., -1., 1e20] {
                                    let direct = [Affinity::Upstream, Affinity::Downstream].map(
                                        |affinity| {
                                            let cursor = Cursor::from_byte_index(
                                                &planner.state.layout,
                                                byte,
                                                affinity,
                                            );
                                            (cursor.index() == byte).then(|| {
                                                bits(cursor.geometry(&planner.state.layout, width))
                                            })
                                        },
                                    );
                                    let actual = geometry.geometries_at(byte, width);
                                    let expected = direct[0].zip(direct[1]).map(|(a, b)| [a, b]);
                                    assert_eq!(
                                        actual.map(|pair| pair.map(bits)),
                                        expected,
                                        "source={source:?}, byte={byte}, wrap={wrap:?}, height={height}, spacing={spacing}, styled={styled}, alignment={alignment:?}, width={width}"
                                    );
                                    if let Some(pair) = expected {
                                        accepted += 1;
                                        distinct += usize::from(pair[0] != pair[1]);
                                    } else {
                                        snapped += 1;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    assert!(accepted > 10_000);
    assert!(snapped > 1_000);
    assert!(
        distinct > 100,
        "wrap/bidi/run affinity exceptions must occur"
    );
    eprintln!("cursor_pairs,accepted={accepted},snapped={snapped},distinct={distinct}");
}

fn assert_lowered_stops(layout: &parley::Layout<()>, source: &str) {
    // The reference deliberately uses direct unindexed producer queries and
    // the original numeric-rectangle coalescing rule. Compare actual packed
    // Stop bits, not only the pair API's widened bounding boxes.
    let mut expected = Vec::new();
    for byte in GraphemeClusterSegmenter::new().segment_str(source) {
        let pair = [Affinity::Upstream, Affinity::Downstream].map(|affinity| {
            let cursor = Cursor::from_byte_index(layout, byte, affinity);
            (cursor.index() == byte).then(|| {
                let r = cursor.geometry(layout, 1.);
                Rect::new(
                    r.x0 as f32,
                    (13.25 + r.y0) as f32,
                    (r.x1 - r.x0) as f32,
                    (r.y1 - r.y0) as f32,
                )
            })
        });
        if let [Some(a), Some(b)] = pair
            && a == b
        {
            expected.push(((17 + byte) as u32, a.x.to_bits(), 3));
        } else {
            for (i, bounds) in pair.into_iter().enumerate() {
                if let Some(bounds) = bounds {
                    expected.push(((17 + byte) as u32, bounds.x.to_bits(), 1 << i));
                }
            }
        }
    }
    let mut actual = Vec::new();
    append_carets(&mut actual, layout, source, 17, 13.25).unwrap();
    let actual = actual
        .iter()
        .map(|stop| (stop.byte, stop.x.to_bits(), stop.affinities))
        .collect::<Vec<_>>();
    assert_eq!(
        actual, expected,
        "packed source/affinity/x bits for {source:?}"
    );
    assert_eq!(
        append_carets(&mut Vec::new(), layout, source, 17, f32::INFINITY),
        Err(Error::InvalidGeometry),
    );
}
