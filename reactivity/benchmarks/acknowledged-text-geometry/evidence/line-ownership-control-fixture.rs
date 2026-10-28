//! Real producer layouts exercise configurations not exposed by TextShaper yet.
//! Frozen line/caret records use the ordinary lowering functions. The oracle
//! uses Parley source-cluster paths and hard-break flags, never caret y.
use super::*;
use std::ops::Range;

struct Fixture {
    map: Details,
    units: Vec<(Range<usize>, usize, bool)>,
    cursors: Vec<(TextPosition, usize)>,
}
fn lower(source: &str, line_height: f32, boxes: bool) -> Fixture {
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
        if boxes && paragraph.content.start == 0 {
            // Defensive producer control for duplicate empty source-line starts.
            // Canvas currently rejects inline boxes; this is not an admission
            // expansion or a second production layout/configuration API.
            for id in 1..=2 {
                builder.push_inline_box(parley::InlineBox {
                    id,
                    index: 0,
                    kind: parley::InlineBoxKind::InFlow,
                    width: 60.,
                    height: 0.,
                    baseline: None,
                    vertical_align: Default::default(),
                });
            }
        }
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
            for (requested, affinity) in [
                (CaretAffinity::Upstream, Affinity::Upstream),
                (CaretAffinity::Downstream, Affinity::Downstream),
            ] {
                let cursor = Cursor::from_byte_index(planned, byte, affinity);
                if cursor.index() != byte {
                    continue;
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
    for source in [
        "abcdef ghijkl mnopqr",
        "אבג 12 abc def",
        "a\r\n\r\nb\r\n",
        "\r\n\r\n",
        "a\u{2028}\u{2028}ב\u{2028}",
        "\u{2028}\u{2028}",
    ] {
        for height in [0., 1., 4., 22.] {
            let fixture = lower(source, height, false);
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
            }
            // The independently recorded cursor ownership is checked through
            // the ordinary caret_line query in the source-ownership refinement.
            assert!(!fixture.cursors.is_empty());
        }
    }
}

#[test]
fn duplicate_empty_source_starts_do_not_capture_the_following_glyph_units() {
    let fixture = lower("abcd", 0., true);
    assert!(
        fixture
            .map
            .lines
            .windows(2)
            .any(|pair| pair[0].start == pair[1].start)
    );
    for (unit, (_, line, _)) in fixture.map.graphemes().zip(fixture.units) {
        assert_eq!(unit.line(), line);
    }
}
