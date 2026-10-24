use gpui_canvas::{
    Affine, Canvas, CaretAffinity, Color, FontFace, Point, Rect, TextDirection, TextOffset,
    TextPosition, TextSystem,
};
fn position(byte: usize, affinity: CaretAffinity) -> TextPosition {
    TextPosition {
        offset: TextOffset::new(byte).unwrap(),
        affinity,
    }
}

#[test]
fn mixed_scripts_rtl_numbers_and_isolates_have_actual_coverage() {
    let font = FontFace::bundled().unwrap();
    let mut shaper = font.shaper();
    for source in [
        "Latin Ω Ελληνικά Привет नमस्ते",
        "abc אבג 123",
        "abc العربية 123",
        "abc \u{2067}אבג 123\u{2069} xyz",
        "a\u{202e}b",
    ] {
        let layout = shaper.shape(source, 20., None).unwrap();
        assert!(!layout.glyphs().next().is_none());
        assert!(
            layout
                .glyphs()
                .all(|g| g.id != 0 && source.is_char_boundary(g.cluster as usize))
        );
        assert_eq!(layout.text_len(), source.len());
        for run in layout.runs() {
            let range = run.text_range();
            assert!(source.get(range.start.byte()..range.end.byte()).is_some());
        }
        if source.contains('א') || source.contains('ع') {
            assert!(
                layout
                    .runs()
                    .any(|r| r.direction() == TextDirection::RightToLeft)
            );
        }
    }
}

#[test]
fn bidi_visual_positions_match_explicit_mixed_direction_examples() {
    let font = FontFace::bundled().unwrap();
    let mut shaper = font.shaper();
    // Independent expected visible order for these UAX9 cases: Hebrew reversal,
    // European numbers within an RTL segment, an isolate, and an explicit RLO.
    // The characters here have one glyph each; no ligature/mark interpolation.
    for (source, expected) in [
        ("a אבג b", "a גבא b"),
        ("abc אבג 123 xyz", "abc 123 גבא xyz"),
        ("a \u{2067}אבג\u{2069} b", "a גבא b"),
        ("a\u{202e}BC\u{202c}D", "aCBD"),
    ] {
        let layout = shaper.shape(source, 20., None).unwrap();
        let mut placed = layout.glyphs().collect::<Vec<_>>();
        placed.sort_by(|a, b| a.x.total_cmp(&b.x));
        let visual = placed
            .into_iter()
            .filter_map(|glyph| {
                let character = source[glyph.cluster as usize..].chars().next().unwrap();
                (!matches!(character, '\u{2067}' | '\u{2069}' | '\u{202e}' | '\u{202c}'))
                    .then_some(character)
            })
            .collect::<String>();
        assert_eq!(visual, expected, "{source:?}");
    }
}
#[test]
fn original_crlf_bytes_empty_paragraphs_and_caret_affinity_are_exact() {
    let font = FontFace::bundled().unwrap();
    let mut shaper = font.shaper();
    let source = "a\r\nb\n";
    let layout = shaper.shape_interactive(source, 18., None).unwrap();
    assert_eq!(layout.lines().count(), 3);
    assert!(
        layout
            .caret_bounds(position(2, CaretAffinity::Downstream))
            .is_none()
    );
    let before = layout
        .caret_bounds(position(1, CaretAffinity::Upstream))
        .unwrap();
    let after = layout
        .caret_bounds(position(3, CaretAffinity::Downstream))
        .unwrap();
    assert!(after.y > before.y);
    assert!(
        layout
            .caret_bounds(position(source.len(), CaretAffinity::Upstream))
            .is_some()
    );
    let empty = shaper.shape_interactive("", 18., None).unwrap();
    assert_eq!(empty.lines().count(), 1);
    assert_eq!(empty.width, 0.);
    assert!(empty.glyphs().next().is_none());
    for source_layout in [&empty, &layout] {
        for line in source_layout.lines() {
            assert!(line.text_range().end.byte() <= source_layout.text_len());
        }
        for run in source_layout.runs() {
            assert!(run.text_range().end.byte() <= source_layout.text_len());
        }
    }
    for affinity in [CaretAffinity::Upstream, CaretAffinity::Downstream] {
        assert_eq!(empty.caret_bounds(position(0, affinity)).unwrap().x, 0.);
    }
    assert!(
        empty
            .caret_bounds(position(0, CaretAffinity::Downstream))
            .is_some()
    );
}
#[test]
fn grapheme_interiors_are_not_legal_byte_positions() {
    let font = FontFace::bundled().unwrap();
    let mut shaper = font.shaper();
    let source = "e\u{301} office";
    let layout = shaper.shape_interactive(source, 18., Some(60.)).unwrap();
    assert!(
        layout
            .caret_bounds(position(1, CaretAffinity::Downstream))
            .is_none()
    );
    assert!(
        layout
            .caret_bounds(position(2, CaretAffinity::Downstream))
            .is_none()
    );
    for byte in [0, 3, 4, 5, 6, 7, 8, 9, 10] {
        assert!(
            layout
                .caret_bounds(position(byte, CaretAffinity::Downstream))
                .is_some(),
            "byte {byte}"
        );
    }
}
fn paint(text: &mut TextSystem, layout: &gpui_canvas::TextLayout) -> Vec<u8> {
    let mut c = Canvas::new(300, 160).unwrap();
    c.clear(Color::WHITE);
    c.draw_text(
        text,
        layout,
        Point { x: 10., y: 10. },
        Affine::IDENTITY,
        Rect::new(0., 0., 300., 160.),
        Color::BLACK,
    )
    .unwrap();
    c.pixels().to_vec()
}
#[test]
fn fallback_layout_leases_survive_later_sets_and_cache_eviction() {
    let font = FontFace::bundled().unwrap();
    let mut shaper = font.shaper();
    let arabic = shaper.shape("العربية", 24., None).unwrap();
    let hebrew = shaper.shape("עברית", 24., None).unwrap();
    let latin = shaper.shape("Latin", 24., None).unwrap();
    drop(shaper);
    let mut first = TextSystem::from_font(font.clone());
    let a = paint(&mut first, &arabic);
    let h = paint(&mut first, &hebrew);
    let _ = paint(&mut first, &latin);
    first.clear_cache();
    assert_eq!(paint(&mut first, &arabic), a);
    let mut fresh = TextSystem::from_font(font);
    assert_eq!(paint(&mut fresh, &hebrew), h);
    assert_eq!(paint(&mut fresh, &arabic), a);
    assert_ne!(a, h);
}

#[test]
fn long_graphemes_take_cold_metadata_without_rejecting_source_or_losing_tail() {
    let source = format!("a{}", "\u{301}".repeat(512));
    let font = FontFace::bundled().unwrap();
    let mut shaper = font.shaper();
    let plain = shaper.shape(&source, 18., None).unwrap();
    assert_eq!(plain.text_len(), source.len());
    assert_eq!(
        plain.runs().last().unwrap().text_range().end.byte(),
        source.len()
    );
    let detailed = shaper.shape_interactive(&source, 18., None).unwrap();
    assert!(
        detailed
            .caret_bounds(position(0, CaretAffinity::Downstream))
            .is_some()
    );
    assert!(
        detailed
            .caret_bounds(position(source.len(), CaretAffinity::Upstream))
            .is_some()
    );
    assert!(
        detailed
            .caret_bounds(position(1, CaretAffinity::Downstream))
            .is_none()
    );
    assert_eq!(std::mem::size_of::<gpui_canvas::Glyph>(), 16);
    assert_eq!(std::mem::size_of::<gpui_canvas::TextLayout>(), 48);
}
#[test]
fn every_bidi_grapheme_boundary_has_both_requested_destinations() {
    let font = FontFace::bundled().unwrap();
    let mut shaper = font.shaper();
    for source in [
        "abc אבג 123 def",
        "abc العربية 123 def",
        "abc \u{2067}אבג\u{2069} def",
        "office office office",
    ] {
        let layout = shaper.shape_interactive(source, 18., Some(65.)).unwrap();
        for byte in icu_segmenter::GraphemeClusterSegmenter::new().segment_str(source) {
            for affinity in [CaretAffinity::Upstream, CaretAffinity::Downstream] {
                assert!(
                    layout.caret_bounds(position(byte, affinity)).is_some(),
                    "{source:?} byte{byte} {affinity:?}"
                );
            }
        }
    }
}

// Rustybuzz is a separate HarfBuzz implementation from Parley's HarfRust. This
// checks glyph choice, source clusters and relative positions, not just that a
// layout can paint itself again.
#[test]
fn single_script_glyphs_match_independent_harfbuzz_implementation() {
    let fonts: &[(&[u8], &[&str])] = &[
        (
            include_bytes!("../assets/NotoSans.ttf"),
            &["office AV", "e\u{301} Ελληνικά", "Привет", "नमस्ते"],
        ),
        (
            include_bytes!("../assets/arabic/NotoSansArabic-Regular.ttf"),
            &["العربية", "لَا"],
        ),
        (
            include_bytes!("../assets/hebrew/NotoSansHebrew-Regular.ttf"),
            &["עברית", "שָׁלוֹם"],
        ),
    ];
    for &(bytes, sources) in fonts {
        let font = FontFace::new(bytes).unwrap();
        let mut shaper = font.shaper();
        let face = rustybuzz::Face::from_slice(bytes, 0).unwrap();
        for &source in sources {
            compare_harfbuzz(&mut shaper, &face, source);
        }
    }
    let source = format!("a{}", "\u{301}".repeat(512));
    let font = FontFace::bundled().unwrap();
    let mut shaper = font.shaper();
    let face = rustybuzz::Face::from_slice(include_bytes!("../assets/NotoSans.ttf"), 0).unwrap();
    compare_harfbuzz(&mut shaper, &face, &source);
}
fn compare_harfbuzz(
    shaper: &mut gpui_canvas::TextShaper<'_>,
    face: &rustybuzz::Face<'_>,
    source: &str,
) {
    let layout = shaper.shape(source, 20., None).unwrap();
    let mut buffer = rustybuzz::UnicodeBuffer::new();
    buffer.push_str(source);
    buffer.guess_segment_properties();
    let independent = rustybuzz::shape(face, &[], buffer);
    assert_eq!(layout.glyphs().len(), independent.len(), "{source:?}");
    let scale = 20. / face.units_per_em() as f32;
    let mut advance = 0.;
    for ((actual, info), position) in layout
        .glyphs()
        .zip(independent.glyph_infos())
        .zip(independent.glyph_positions())
    {
        assert_eq!(u32::from(actual.id), info.glyph_id, "{source:?}");
        assert_eq!(actual.cluster, info.cluster, "{source:?}");
        let x = advance + position.x_offset as f32 * scale;
        let y = -(position.y_offset as f32) * scale;
        assert!(
            (actual.x - x).abs() < 0.0001,
            "{source:?}: {} != {x}",
            actual.x
        );
        assert!(
            (actual.baseline - layout.baseline - y).abs() < 0.0001,
            "{source:?}"
        );
        advance += position.x_advance as f32 * scale;
    }
}

#[test]
fn missing_coverage_is_an_error_and_inherited_arabic_marks_use_fallback() {
    let font = FontFace::bundled().unwrap();
    let mut shaper = font.shaper();
    assert!(matches!(
        shaper.shape("漢", 20., None),
        Err(gpui_canvas::Error::MissingGlyph('漢'))
    ));
    for text in ["\u{651}ع", "ع\u{651}"] {
        let layout = shaper.shape_interactive(text, 20., None).unwrap();
        assert!(layout.glyphs().all(|glyph| glyph.id != 0));
        assert!(
            layout
                .caret_bounds(position(text.len(), CaretAffinity::Upstream))
                .is_some()
        );
    }
}

#[test]
fn explicit_variable_face_uses_its_default_instance_for_shape_and_raster() {
    // Change only the declared default weight/OS2 metadata in this test copy.
    // Both engines must use normalized axis zero, rather than Fontique selecting
    // CSS's implicit weight400 while the rasterizer uses the face default700.
    let mut bytes = include_bytes!("../assets/NotoSans.ttf").to_vec();
    let raw = rustybuzz::ttf_parser::RawFace::parse(&bytes, 0).unwrap();
    let table = |tag: &[u8; 4]| {
        raw.table_records
            .into_iter()
            .find(|record| record.tag.to_bytes() == *tag)
            .unwrap()
            .offset as usize
    };
    let fvar = table(b"fvar");
    let os2 = table(b"OS/2");
    let axes = fvar
        + usize::from(u16::from_be_bytes(
            bytes[fvar + 4..fvar + 6].try_into().unwrap(),
        ));
    let count = usize::from(u16::from_be_bytes(
        bytes[fvar + 8..fvar + 10].try_into().unwrap(),
    ));
    let stride = usize::from(u16::from_be_bytes(
        bytes[fvar + 10..fvar + 12].try_into().unwrap(),
    ));
    let weight = (0..count)
        .map(|index| axes + index * stride)
        .find(|&axis| &bytes[axis..axis + 4] == b"wght")
        .unwrap();
    bytes[weight + 8..weight + 12].copy_from_slice(&(700_i32 << 16).to_be_bytes());
    bytes[os2 + 4..os2 + 6].copy_from_slice(&700_u16.to_be_bytes());
    let font = FontFace::new(&bytes).unwrap();
    let mut shaper = font.shaper();
    let face = rustybuzz::Face::from_slice(&bytes, 0).unwrap();
    compare_harfbuzz(&mut shaper, &face, "office AVATAR");
    let layout = shaper.shape("office AVATAR", 20., None).unwrap();
    let mut service = TextSystem::from_font(font.clone());
    let pixels = paint(&mut service, &layout);
    assert!(pixels.iter().any(|&byte| byte != 255));
    let mut fresh = TextSystem::from_font(font);
    assert_eq!(paint(&mut fresh, &layout), pixels);
}

#[cfg(feature = "parallel")]
#[test]
fn unicode_runs_are_byte_identical_in_scoped_parallel_rendering() {
    let font = FontFace::bundled().unwrap();
    let mut shaper = font.shaper();
    let layout = shaper
        .shape(
            "Hello Ελληνικά नमस्ते\r\nabc العربية אבג 123",
            18.,
            Some(210.),
        )
        .unwrap();
    let mut text = TextSystem::from_font(font);
    let expected = paint(&mut text, &layout);
    for workers in [1, 2, 4] {
        let mut canvas = Canvas::new(300, 160).unwrap();
        canvas.clear(Color::WHITE);
        canvas
            .draw_text(
                &mut text,
                &layout,
                Point { x: 10., y: 10. },
                Affine::IDENTITY,
                Rect::new(0., 0., 300., 160.),
                Color::BLACK,
            )
            .unwrap();
        let pool = gpui_canvas::RenderPool::new(workers)
            .unwrap()
            .with_min_work(0);
        assert_eq!(canvas.try_pixels_with(&pool).unwrap(), expected);
    }
}

#[test]
fn line_separator_keeps_paragraph_bidi_base_but_paragraph_separator_resets_it() {
    let font = FontFace::bundled().unwrap();
    let mut shaper = font.shaper();
    for (separator, rtl_base) in [('\u{2028}', true), ('\u{2029}', false)] {
        let source = format!("אבג{separator}123 abc");
        let layout = shaper.shape_interactive(&source, 20., None).unwrap();
        assert_eq!(layout.lines().count(), 2);
        let one = layout
            .glyphs()
            .find(|glyph| glyph.cluster as usize == source.find('1').unwrap())
            .unwrap();
        let a = layout
            .glyphs()
            .find(|glyph| glyph.cluster as usize == source.find('a').unwrap())
            .unwrap();
        assert_eq!(a.x < one.x, rtl_base);
        assert!(
            layout
                .caret_bounds(position(
                    source.find('1').unwrap(),
                    CaretAffinity::Downstream
                ))
                .is_some()
        );
    }
}

#[test]
fn fallback_choice_is_independent_of_prior_passes_and_ignorables_keep_source_bytes() {
    let font = FontFace::bundled().unwrap();
    for source in [
        "עברית",
        "العربية",
        "abc אבג العربية 123",
        "\u{651}ع",
        "ع\u{200c}ع",
        "a\u{fe0f}",
        "\u{200d}",
        "a\u{200d}",
    ] {
        let mut fresh = font.shaper();
        let expected = fresh.shape_interactive(source, 18., None).unwrap();
        let mut prior = font.shaper();
        prior.shape("العربية עברית", 18., None).unwrap();
        let actual = prior.shape_interactive(source, 18., None).unwrap();
        assert_eq!(
            actual.glyphs().collect::<Vec<_>>(),
            expected.glyphs().collect::<Vec<_>>(),
            "{source:?}"
        );
        assert_eq!(actual.text_len(), source.len());
        let mut service = TextSystem::from_font(font.clone());
        assert_eq!(paint(&mut service, &actual), paint(&mut service, &expected));
        for byte in icu_segmenter::GraphemeClusterSegmenter::new().segment_str(source) {
            assert!(
                actual
                    .caret_bounds(position(byte, CaretAffinity::Downstream))
                    .is_some(),
                "{source:?} byte{byte}"
            );
        }
    }
}

#[test]
fn mixed_paragraph_reordering_preserves_every_grapheme_destination_and_run_range() {
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
    let font = FontFace::bundled().unwrap();
    let mut shaper = font.shaper();
    let mut seed = 0x1935ab23_u32;
    for case in 0..100 {
        let mut source = String::new();
        for _ in 0..12 {
            seed ^= seed << 13;
            seed ^= seed >> 17;
            seed ^= seed << 5;
            source.push_str(tokens[seed as usize % tokens.len()]);
        }
        let width = match case % 3 {
            0 => None,
            1 => Some(20.),
            _ => Some(80.),
        };
        let plain = shaper
            .shape(&source, 18., width)
            .unwrap_or_else(|error| panic!("case{case} {source:?} plain {error:?}"));
        let detail = shaper
            .shape_interactive(&source, 18., width)
            .unwrap_or_else(|error| panic!("case{case} {source:?} detail {error:?}"));
        assert_eq!(plain.text_len(), source.len());
        assert_eq!(detail.text_len(), source.len());
        let glyphs = |layout: &gpui_canvas::TextLayout| {
            layout
                .glyphs()
                .map(|g| (g.id, g.cluster, g.x.to_bits(), g.baseline.to_bits()))
                .collect::<Vec<_>>()
        };
        assert_eq!(glyphs(&plain), glyphs(&detail));
        assert_eq!(
            detail.runs().map(|run| run.glyphs().len()).sum::<usize>(),
            detail.glyphs().len()
        );
        for run in detail.runs() {
            let range = run.text_range();
            assert!(source.get(range.start.byte()..range.end.byte()).is_some());
        }
        for line in detail.lines() {
            let range = line.text_range();
            assert!(source.get(range.start.byte()..range.end.byte()).is_some());
        }
        for byte in icu_segmenter::GraphemeClusterSegmenter::new().segment_str(&source) {
            for affinity in [CaretAffinity::Upstream, CaretAffinity::Downstream] {
                assert!(
                    detail.caret_bounds(position(byte, affinity)).is_some(),
                    "case{case} {source:?} {byte} {affinity:?}"
                );
            }
        }
    }
}

#[test]
fn wrapped_ligatures_never_cross_font_or_bidi_run_boundaries() {
    // The released Parley getter read the next run's clusters, and its
    // ligature loop passed a layout-global index to that run-relative getter.
    // The last fixture produced a line range 0..2, inside the first ZWJ.
    let sources = [
        "a\u{200d}ع\u{651}",
        "א a\u{200d}ع\u{651}",
        "a\u{200d}ع\u{651}\u{2069}e\u{301} \u{2069}\u{2067}ع\u{651}П\n א",
    ];
    let font = FontFace::bundled().unwrap();
    let mut shaper = font.shaper();
    for source in sources {
        let unwrapped = shaper.shape_interactive(source, 18., None).unwrap();
        let mut expected = unwrapped
            .glyphs()
            .map(|g| (g.cluster, g.id))
            .collect::<Vec<_>>();
        expected.sort_unstable();
        for width in [1., 10., 20., 80.] {
            let layout = shaper.shape_interactive(source, 18., Some(width)).unwrap();
            let mut actual = layout
                .glyphs()
                .map(|g| (g.cluster, g.id))
                .collect::<Vec<_>>();
            actual.sort_unstable();
            assert_eq!(actual, expected, "{source:?}, width {width}");
            for line in layout.lines() {
                let range = line.text_range();
                assert!(source.get(range.start.byte()..range.end.byte()).is_some());
            }
            for run in layout.runs() {
                let range = run.text_range();
                assert!(source.get(range.start.byte()..range.end.byte()).is_some());
            }
            for byte in icu_segmenter::GraphemeClusterSegmenter::new().segment_str(source) {
                for affinity in [CaretAffinity::Upstream, CaretAffinity::Downstream] {
                    assert!(layout.caret_bounds(position(byte, affinity)).is_some());
                }
            }
        }
    }
}
