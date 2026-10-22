//! Real producer layouts exercise configurations not exposed by TextShaper yet.
//! Frozen line/caret records use the ordinary lowering functions. The oracle
//! uses Parley source-cluster paths and hard-break flags, never caret y.
use super::*;
use std::ops::Range;

struct Fixture {
    map: Details,
    units: Vec<(Range<usize>, usize, bool)>,
    cursors: Vec<(TextPosition, usize, [u32; 4])>,
}
fn lower(source: &str, line_height: f32) -> Fixture {
    let face = FontFace::bundled().unwrap();
    let mut planner = Planner::new(&face).unwrap();
    planner.coverage(source).unwrap();
    let families = FAMILIES.map(|name| FontFamilyName::Named(name.into()));
    let mut fixture = Fixture {
        map: Details {
            len: source.len() as u32,
            font_size: 16.,
            runs: Vec::new(),
            lines: Vec::new(),
            carets: Some(Vec::new()),
        },
        units: Vec::new(),
        cursors: Vec::new(),
    };
    let mut height = 0.;
    for paragraph in paragraph::ranges(source) {
        let content = &source[paragraph.content.clone()];
        let mut builder = planner
            .context
            .ranged_builder(&mut planner.fonts, content, 1., false);
        builder.push_default(&families[..]);
        builder.push_default(StyleProperty::FontSize(16.));
        builder.push_default(StyleProperty::LineHeight(parley::LineHeight::Absolute(
            line_height,
        )));
        builder.push_default(StyleProperty::OverflowWrap(OverflowWrap::Anywhere));
        builder.build_into(&mut planner.layout, content);
        planner.layout.break_all_lines(Some(30.));
        let planned = &planner.layout;
        let base = fixture.map.lines.len();
        for (line_index, line) in planned.lines().enumerate() {
            fixture
                .map
                .lines
                .push(freeze_line(line, content, paragraph.content.start, height).unwrap());
            for run in line.runs() {
                let range = if content.is_empty() {
                    0..0
                } else {
                    run.text_range()
                };
                fixture.map.runs.push(Run {
                    start: (paragraph.content.start + range.start) as u32,
                    end: (paragraph.content.start + range.end) as u32,
                    glyph_start: 0,
                    glyph_end: 0,
                    line: (base + line_index) as u32,
                    font: FontSlot(0),
                    direction: if run.is_rtl() {
                        TextDirection::RightToLeft
                    } else {
                        TextDirection::LeftToRight
                    },
                });
            }
        }
        append_carets(
            fixture.map.carets.as_mut().unwrap(),
            planned,
            content,
            paragraph.content.start,
            height,
        )
        .unwrap();
        let boundaries = GraphemeClusterSegmenter::new()
            .segment_str(content)
            .collect::<Vec<_>>();
        for pair in boundaries.windows(2) {
            let cluster = parley::layout::Cluster::from_byte_index(planned, pair[0]).unwrap();
            let line = cluster.path().line_index();
            assert!(
                planned
                    .get(line)
                    .unwrap()
                    .runs()
                    .any(|run| run.text_range().contains(&pair[0]))
            );
            fixture.units.push((
                paragraph.content.start + pair[0]..paragraph.content.start + pair[1],
                base + line,
                cluster.is_hard_line_break(),
            ));
        }
        for byte in boundaries {
            let upstream = Cursor::from_byte_index(planned, byte, Affinity::Upstream);
            let producer_bounds = |cursor: Cursor| {
                let r = cursor.geometry(planned, 1.);
                Rect::new(
                    r.x0 as f32,
                    (f64::from(height) + r.y0) as f32,
                    (r.x1 - r.x0) as f32,
                    (r.y1 - r.y0) as f32,
                )
            };
            let upstream_bounds = producer_bounds(upstream);
            for (requested, affinity) in [
                (CaretAffinity::Upstream, Affinity::Upstream),
                (CaretAffinity::Downstream, Affinity::Downstream),
            ] {
                let cursor = Cursor::from_byte_index(planned, byte, affinity);
                if cursor.index() != byte {
                    continue;
                }
                let mut bounds = producer_bounds(cursor);
                // The original producer merges Rect equality and retains the
                // upstream bits, including equal signed-zero coordinates.
                if upstream.index() == byte && bounds == upstream_bounds {
                    bounds = upstream_bounds;
                }
                let [upstream, downstream] = cursor.logical_clusters(planned);
                let cluster = if cursor.affinity() == Affinity::Upstream || downstream.is_none() {
                    upstream
                        .filter(|cluster| !cluster.is_hard_line_break())
                        .or(downstream)
                } else {
                    downstream
                };
                let line = cluster.map_or(planned.len() - 1, |cluster| cluster.path().line_index());
                fixture.cursors.push((
                    TextPosition {
                        offset: TextOffset::new(paragraph.content.start + byte).unwrap(),
                        affinity: requested,
                    },
                    base + line,
                    [bounds.x, bounds.y, bounds.width, bounds.height].map(f32::to_bits),
                ));
            }
        }
        if !paragraph.separator.is_empty() {
            fixture
                .units
                .push((paragraph.separator, base + planned.len() - 1, true));
        }
        height += planned.height();
    }
    fixture
}

#[test]
fn wrapped_zero_and_small_line_heights_keep_producer_source_ownership() {
    let _registry = super::super::BUNDLED_TEST_LOCK.lock().unwrap();
    for source in [
        "",
        "abcdef ghijkl mnopqr",
        "abc\u{2028}def\u{2028}",
        "\r\n",
        "a\u{85}\u{2029}",
        "אבג 12 abc def",
        "a\r\n\r\nb\r\n",
        "\r\n\r\n",
        "a\u{2028}\u{2028}ב\u{2028}",
        "\u{2028}\u{2028}",
    ] {
        for height in [0., 1., 4., 22.] {
            let fixture = lower(source, height);
            let units = fixture.map.graphemes().collect::<Vec<_>>();
            assert_eq!(units.len(), fixture.units.len());
            for (unit, (range, line, hard)) in units.iter().zip(&fixture.units) {
                assert_eq!(
                    unit.text_range().start.byte()..unit.text_range().end.byte(),
                    *range
                );
                assert_eq!(
                    unit.line(),
                    *line,
                    "{source:?} height={height} range={range:?}"
                );
                assert_eq!(
                    unit.is_hard_break(),
                    *hard,
                    "{source:?} height={height} range={range:?}"
                );
                let expected = fixture
                    .cursors
                    .iter()
                    .find(|(position, _, _)| {
                        position.offset.byte() == range.start
                            && position.affinity == CaretAffinity::Downstream
                    })
                    .unwrap()
                    .2;
                assert_eq!(
                    [unit.bounds().y.to_bits(), unit.bounds().height.to_bits()],
                    [expected[1], expected[3]],
                    "producer interval metrics {source:?} height={height} range={range:?}"
                );
            }
            for (position, line, bounds) in fixture.cursors {
                assert_eq!(
                    fixture.map.caret_line(position),
                    Some(line),
                    "{source:?} height={height} caret={position:?}"
                );
                let actual = fixture.map.caret_bounds(position).unwrap();
                assert_eq!(
                    [actual.x, actual.y, actual.width, actual.height].map(f32::to_bits),
                    bounds,
                    "producer rect bits {source:?} height={height} caret={position:?}"
                );
            }
        }
    }
}

#[test]
fn mandatory_break_lines_exclude_separators_but_runs_cover_document() {
    let _registry = super::super::BUNDLED_TEST_LOCK.lock().unwrap();
    for (source, expected) in [
        ("a\u{2028}\u{2028}ב\u{2028}", vec![0..1, 4..4, 7..9, 12..12]),
        ("\u{2028}\u{2028}", vec![0..0, 3..3, 6..6]),
        ("a\r\n\r\nb\r\n", vec![0..1, 3..3, 5..6, 8..8]),
    ] {
        let fixture = lower(source, 0.);
        let actual = fixture
            .map
            .lines()
            .map(|line| {
                let range = line.text_range();
                range.start.byte()..range.end.byte()
            })
            .collect::<Vec<_>>();
        assert_eq!(actual, expected, "{source:?}");
        let units = fixture
            .map
            .graphemes()
            .map(|unit| unit.text_range())
            .collect::<Vec<_>>();
        assert_eq!(units.first().unwrap().start.byte(), 0);
        assert_eq!(units.last().unwrap().end.byte(), source.len());
        for pair in units.windows(2) {
            assert_eq!(pair[0].end, pair[1].start);
        }
    }
}

#[test]
fn visual_line_transitions_do_not_rehit_collapsed_line_tops() {
    let _registry = super::super::BUNDLED_TEST_LOCK.lock().unwrap();
    for height in [0., 1., 4.] {
        let fixture = lower("abcdefghijklmnop", height);
        for (line, row) in fixture.map.lines.iter().enumerate().skip(1) {
            let start = TextPosition {
                offset: TextOffset::new(row.start as usize).unwrap(),
                affinity: CaretAffinity::Downstream,
            };
            let previous = fixture.map.previous_visual(start).unwrap();
            assert_eq!(fixture.map.caret_line(previous), Some(line - 1));
            let forward = fixture.map.next_visual(previous).unwrap();
            assert_eq!(fixture.map.caret_line(forward), Some(line));
        }
        assert_eq!(
            fixture.map.caret_line(TextPosition {
                offset: TextOffset::new(u32::MAX as usize).unwrap(),
                affinity: CaretAffinity::Downstream
            }),
            None
        );
    }
}

#[test]
fn source_line_geometry_reconstruction_preserves_producer_arithmetic_bits() {
    // Independent arithmetic oracle: Parley widens each f32 edge before
    // subtracting, while frozen lines perform their add/subtract in f32.
    // Include signed zero, subnormals, cancellation, large exponents and
    // adjacent representable values. No quantization or narrowed domain.
    let values = [
        0.,
        -0.,
        f32::from_bits(1),
        -f32::from_bits(1),
        f32::MIN_POSITIVE,
        -f32::MIN_POSITIVE,
        f32::from_bits(0x3f7f_ffff),
        1.,
        -1.,
        f32::from_bits(0x3f80_0001),
        16.,
        -16.,
        16_777_216.,
        -16_777_216.,
        1e20,
        -1e20,
        f32::MAX,
        -f32::MAX,
    ];
    for before in values {
        for a in values {
            let min = a.min(before);
            let max = a.max(before);
            assert_eq!(
                (max - min).to_bits(),
                ((f64::from(max) - f64::from(min)) as f32).to_bits(),
                "height min={min:?} max={max:?}"
            );
            for paragraph_height in values {
                assert_eq!(
                    (paragraph_height + min).to_bits(),
                    ((f64::from(paragraph_height) + f64::from(min)) as f32).to_bits(),
                    "top height={paragraph_height:?} min={min:?}"
                );
            }
        }
        // The producer adds the one-pixel width in f32 before widening. It
        // can round to zero and must never be reconstructed as a literal 1.
        let x1 = before + 1.;
        let expected = (f64::from(x1) - f64::from(before)) as f32;
        assert_eq!(expected.to_bits(), (x1 - before).to_bits());
        if before.abs() >= 33_554_432. {
            assert_eq!(expected, 0.);
        }
    }
}
