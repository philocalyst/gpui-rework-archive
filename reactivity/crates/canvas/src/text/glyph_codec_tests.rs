use super::*;

#[test]
fn all_font_code_endpoints_and_float_bits_round_trip() {
    assert_eq!(size_of::<PackedGlyph>(), 12);
    let bits = [
        0,
        0x8000_0000,
        1,
        0x8000_0001,
        0x3f80_0000,
        0xff7f_ffff,
        0x7f80_0000,
        0x7fc1_2345,
    ];
    for (slot, count) in [(0, 65536), (1, 32768), (2, 32768)] {
        for id in 0..count {
            for cluster in [0, 1, 32767] {
                let expected = Glyph {
                    id: id as u16,
                    font: FontSlot(slot),
                    cluster,
                    x: f32::from_bits(bits[id as usize % bits.len()]),
                    baseline: f32::from_bits(bits[(id as usize + 3) % bits.len()]),
                };
                let actual = PackedGlyph::new(expected).unwrap().glyph();
                assert_eq!(
                    (actual.id, actual.font, actual.cluster),
                    (expected.id, expected.font, expected.cluster)
                );
                assert_eq!(actual.x.to_bits(), expected.x.to_bits());
                assert_eq!(actual.baseline.to_bits(), expected.baseline.to_bits());
            }
        }
    }
    let last = Glyph {
        id: 32767,
        font: FontSlot(2),
        cluster: 32767,
        x: -0.,
        baseline: 0.,
    };
    assert_eq!(PackedGlyph::new(last).unwrap().meta, u32::MAX);
    for invalid in [
        Glyph {
            cluster: 32768,
            ..last
        },
        Glyph {
            font: FontSlot(3),
            ..last
        },
        Glyph {
            id: 32768,
            font: FontSlot(1),
            ..last
        },
        Glyph { id: 65535, ..last },
    ] {
        assert!(matches!(PackedGlyph::new(invalid), Err(Error::InvalidFont)));
    }
}

#[test]
fn exact_embedded_fallback_fonts_fit_the_code_namespaces() {
    for (slot, expected) in [(1, 1661), (2, 149)] {
        let face = ttf_parser::Face::parse(FontFace::fallback_bytes(slot).unwrap(), 0).unwrap();
        assert_eq!(face.number_of_glyphs(), expected);
        assert!(u32::from(face.number_of_glyphs()) < FALLBACK_GLYPHS);
    }
}

#[test]
fn borrowed_iteration_never_materializes_an_expanded_buffer() {
    let face = FontFace::bundled().unwrap();
    let shape = face
        .shaper()
        .shape_interactive("office אבג العربية", 18., Some(80.))
        .unwrap();
    let expected = shape.glyphs().collect::<Vec<Glyph>>();
    let cost = allocation_counter::measure(|| {
        let mut glyphs = shape.glyphs();
        assert_eq!(glyphs.size_hint(), (expected.len(), Some(expected.len())));
        assert_eq!(glyphs.next(), expected.first().copied());
        assert_eq!(glyphs.next_back(), expected.last().copied());
        assert!(
            glyphs
                .clone()
                .eq(expected[1..expected.len() - 1].iter().copied())
        );
        assert!(shape.glyphs().rev().eq(expected.iter().rev().copied()));
        for run in shape.runs() {
            std::hint::black_box(run.glyphs().fold(0, |sum, glyph| sum + u64::from(glyph.id)));
        }
    });
    assert_eq!(cost.count_total, 0);
    assert_eq!(cost.bytes_total, 0);
}

#[test]
fn document_length_does_not_require_a_long_tail_geometry_owner() {
    let face = FontFace::bundled().unwrap();
    let source = format!("a{}", "\u{301}".repeat(1024));
    let mut shaper = face.shaper();
    let plain = shaper.shape(&source, 18., None).unwrap();
    let mut interactive = shaper.shape_interactive(&source, 18., None).unwrap();
    let geometry = interactive.retain_geometry().unwrap();
    assert!(plain.mapping.is_none());
    assert_eq!(plain.text_len(), source.len());
    assert!(plain.glyphs().eq(interactive.glyphs()));
    interactive.discard_interaction();
    assert!(interactive.mapping.is_none());
    assert_eq!(interactive.text_len(), source.len());
    assert!(
        geometry
            .caret_bounds(TextPosition {
                offset: TextOffset::new(source.len()).unwrap(),
                affinity: CaretAffinity::Downstream,
            })
            .is_some()
    );
}
