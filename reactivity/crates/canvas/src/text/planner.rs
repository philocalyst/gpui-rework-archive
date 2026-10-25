//! Scoped Unicode planning. Parley layouts and the mutable font database stay
//! within the planning pass; outputs own only Canvas glyphs and interaction data.
use super::layout::{Details, Line, Run, Stop, TextDirection};
use super::*;
use fontique::{Blob, Collection, CollectionOptions, FontInfoOverride, SourceCache};
use icu_properties::{CodePointSetData, props::DefaultIgnorableCodePoint};
use icu_segmenter::GraphemeClusterSegmenter;
use parley::{
    Affinity, Cursor, CursorGeometry, FontContext, FontFamilyName, LayoutContext, OverflowWrap,
    PositionedLayoutItem, StyleProperty,
};

const FAMILIES: [&str; 3] = ["GPUI primary", "GPUI fallback one", "GPUI fallback two"];
struct FontBytes(FontFace);
impl AsRef<[u8]> for FontBytes {
    fn as_ref(&self) -> &[u8] {
        &self.0.0.bytes
    }
}

/// Only the borrowed cmap survives parsing; the full Face's unrelated table
/// descriptors are not retained in the scoped planner.
struct Cmap<'font>(Option<ttf_parser::cmap::Table<'font>>);
impl<'font> Cmap<'font> {
    fn parse(bytes: &'font [u8]) -> Result<Self, Error> {
        let face = ttf_parser::Face::parse(bytes, 0).map_err(|_| Error::InvalidFont)?;
        Ok(Self(face.tables().cmap))
    }
    fn glyph_index(&self, code_point: char) -> Option<ttf_parser::GlyphId> {
        // Preserve Face::glyph_index's Unicode filter, subtable order and
        // first-match semantics, including a returned glyph zero.
        for subtable in self.0?.subtables {
            if subtable.is_unicode()
                && let Some(id) = subtable.glyph_index(u32::from(code_point))
            {
                return Some(id);
            }
        }
        None
    }
}

pub(super) struct Planner<'font> {
    fonts: FontContext,
    context: LayoutContext<()>,
    // Reuse the one paragraph being lowered, including Parley Engine's shaped
    // buffers. This scratch dies with TextShaper, never with a returned layout.
    layout: parley::Layout<()>,
    faces: FontSet,
    blob_ids: [Option<u64>; 3],
    sets: [Option<Arc<FontSet>>; 4],
    primary_cmap: Cmap<'font>,
}
struct Planned {
    metrics: TextMetrics,
    glyphs: EcoVec<PackedGlyph>,
    details: Option<Details>,
    mask: usize,
}
impl<'font> Planner<'font> {
    pub fn new(primary: &'font FontFace) -> Result<Self, Error> {
        let faces = FontSet {
            primary: primary.clone(),
            fallbacks: [None, None],
        };
        let base = Arc::new(faces.clone());
        let mut result = Self {
            fonts: FontContext {
                collection: Collection::new(CollectionOptions {
                    shared: false,
                    system_fonts: false,
                }),
                source_cache: SourceCache::default(),
            },
            context: LayoutContext::new(),
            layout: parley::Layout::default(),
            faces,
            blob_ids: [None; 3],
            sets: [Some(base), None, None, None],
            primary_cmap: if primary.0.bundled {
                Cmap(None)
            } else {
                Cmap::parse(&primary.0.bytes)?
            },
        };
        result.register(0)?;
        Ok(result)
    }
    fn register(&mut self, slot: usize) -> Result<(), Error> {
        self.blob_ids[slot] = Some(register_font(
            &mut self.fonts,
            self.faces.face(slot)?,
            FAMILIES[slot],
        )?);
        Ok(())
    }
    fn coverage(&mut self, text: &str) -> Result<u8, Error> {
        let ignorable = CodePointSetData::new::<DefaultIgnorableCodePoint>();
        let mut needed = 0_u8;
        for c in coverage::characters(text, self.faces.primary.0.bundled) {
            if matches!(c, '\r' | '\n' | '\u{85}' | '\u{2028}' | '\u{2029}')
                || ignorable.contains(c)
            {
                continue;
            }
            if c.is_control() {
                return Err(Error::UnsupportedControl(c));
            }
            let covered = if self.faces.primary.0.bundled {
                let mask = bundled_coverage::mask(c);
                if mask & 1 != 0 {
                    continue;
                }
                mask >> 1
            } else {
                if self.primary_cmap.glyph_index(c).is_some_and(|g| g.0 != 0) {
                    continue;
                }
                return Err(Error::MissingGlyph(c));
            };
            if covered == 0 {
                return Err(Error::MissingGlyph(c));
            }
            needed |= covered;
        }
        for slot in 1..=2 {
            if needed & (1 << (slot - 1)) != 0 && self.faces.fallbacks[slot - 1].is_none() {
                self.faces.fallbacks[slot - 1] = Some(FontFace::fallback(slot)?);
                self.register(slot)?;
            }
        }
        Ok(needed)
    }
    fn font_set(&mut self, mask: usize) -> Arc<FontSet> {
        Arc::clone(self.sets[mask].get_or_insert_with(|| {
            Arc::new(FontSet {
                primary: self.faces.primary.clone(),
                fallbacks: std::array::from_fn(|i| {
                    if mask & (1 << i) != 0 {
                        self.faces.fallbacks[i].clone()
                    } else {
                        None
                    }
                }),
            })
        }))
    }
    pub fn shape(
        &mut self,
        text: &str,
        size: f32,
        max_width: Option<f32>,
        interactive: bool,
    ) -> Result<TextLayout, Error> {
        let planned = self.plan::<true>(text, size, max_width, interactive)?;
        Ok(TextLayout {
            width: planned.metrics.width,
            height: planned.metrics.height,
            baseline: planned.metrics.baseline,
            font_size: size,
            glyphs: GlyphBuffer::new(planned.glyphs, text.len())
                .map_err(|_| Error::ResourceLimit)?,
            fonts: self.font_set(planned.mask),
            mapping: planned.details.map(Arc::new),
        })
    }
    pub fn measure(
        &mut self,
        text: &str,
        size: f32,
        max_width: Option<f32>,
    ) -> Result<TextMetrics, Error> {
        Ok(self.plan::<false>(text, size, max_width, false)?.metrics)
    }
    fn plan<const MATERIALIZE: bool>(
        &mut self,
        text: &str,
        size: f32,
        max_width: Option<f32>,
        interactive: bool,
    ) -> Result<Planned, Error> {
        let result = self.plan_inner::<MATERIALIZE>(text, size, max_width, interactive);
        if result.is_err() {
            // An invalid or expanding font can create a rejected large layout.
            // Do not keep its buffers for later calls in this planning pass.
            self.layout = parley::Layout::default();
        }
        result
    }
    fn plan_inner<const MATERIALIZE: bool>(
        &mut self,
        text: &str,
        size: f32,
        max_width: Option<f32>,
        interactive: bool,
    ) -> Result<Planned, Error> {
        let needed = self.coverage(text)?;
        let mut names = FAMILIES.map(|name| FontFamilyName::Named(name.into()));
        let mut family_count = 1;
        for (index, family) in FAMILIES.iter().enumerate().skip(1) {
            if needed & (1 << (index - 1)) != 0 {
                names[family_count] = FontFamilyName::Named((*family).into());
                family_count += 1;
            }
        }
        let mut glyphs = EcoVec::new();
        let mut details: Option<Details> = None;
        let mut detailed = false;
        let mut glyph_count = 0usize;
        let mut width = 0.0f32;
        let mut height = 0.0f32;
        let mut baseline = 0.0f32;
        let mut mask = 0;
        for paragraph in paragraph::ranges(text) {
            let content = &text[paragraph.content.clone()];
            let mut builder = self
                .context
                .ranged_builder(&mut self.fonts, content, 1., false);
            builder.push_default(&names[..family_count]);
            builder.push_default(StyleProperty::FontSize(size));
            builder.push_default(StyleProperty::OverflowWrap(OverflowWrap::Anywhere));
            builder.build_into(&mut self.layout, content);
            self.layout.break_all_lines(max_width);
            let planned = &self.layout;
            let simple = !interactive
                && paragraph.content.end == text.len()
                && paragraph.content.start == 0
                && planned.len() == 1
                && planned
                    .lines()
                    .flat_map(|line| line.runs())
                    .all(|run| !run.is_rtl() && Some(run.font().data.id()) == self.blob_ids[0])
                && planned.lines().flat_map(|line| line.runs()).count() <= 1;
            if !simple && !detailed {
                detailed = true;
                if MATERIALIZE {
                    details = Some(Details {
                        len: text.len() as u32,
                        font_size: size,
                        runs: Vec::new(),
                        lines: Vec::new(),
                        carets: interactive.then(Vec::new),
                    });
                }
            }
            let count = planned
                .lines()
                .flat_map(|line| line.runs())
                .map(|run| run.glyph_count())
                .sum::<usize>();
            if glyph_count
                .checked_add(count)
                .is_none_or(|n| n > MAX_GLYPHS)
            {
                return Err(Error::ResourceLimit);
            }
            if MATERIALIZE && !content.is_empty() {
                glyphs.reserve(count);
            }
            if paragraph.content.start == 0 {
                baseline = planned
                    .lines()
                    .next()
                    .map_or(0., |line| line.metrics().baseline);
            }
            width = width.max(if content.is_empty() {
                0.
            } else if max_width.is_some() {
                planned.width()
            } else {
                planned.full_width()
            });
            for (line_index, line) in planned.lines().enumerate() {
                let global_line = details.as_ref().map_or(line_index, |d| d.lines.len());
                if detailed {
                    let frozen = freeze_line(line, content, paragraph.content.start, height)?;
                    if let Some(d) = &mut details {
                        d.lines.push(frozen);
                    }
                }
                for item in line.items() {
                    let PositionedLayoutItem::GlyphRun(run) = item else {
                        return Err(Error::InvalidGeometry);
                    };
                    if run
                        .run()
                        .normalized_coords()
                        .iter()
                        .any(|coordinate| coordinate.to_bits() != 0)
                    {
                        return Err(Error::UnsupportedFontFormat);
                    }
                    let slot = self
                        .blob_ids
                        .iter()
                        .position(|&id| id == Some(run.run().font().data.id()))
                        .ok_or(Error::ForeignLayout)?;
                    if slot != 0 {
                        mask |= 1 << (slot - 1);
                    }
                    let first = glyph_count;
                    // This API shapes one style over each paragraph, so every
                    // positioned item covers its run's full visual glyph range.
                    let mut clusters = run.run().glyph_source_ranges();
                    for g in run.positioned_glyphs() {
                        let source = clusters.next().ok_or(Error::InvalidFont)?;
                        if content.is_empty() {
                            continue;
                        }
                        if content.get(source.clone()).is_none() {
                            return Err(Error::InvalidFont);
                        }
                        if g.id == 0 {
                            let ignored = content.get(source.clone()).is_some_and(|s| {
                                s.chars().all(|c| {
                                    CodePointSetData::new::<DefaultIgnorableCodePoint>().contains(c)
                                })
                            });
                            if ignored && g.advance == 0. {
                                continue;
                            }
                            return Err(content
                                .get(source)
                                .and_then(|s| s.chars().next())
                                .map_or(Error::InvalidFont, Error::MissingGlyph));
                        }
                        if !g.x.is_finite() || !g.y.is_finite() {
                            return Err(Error::InvalidGeometry);
                        }
                        let glyph = PackedGlyph::new(Glyph {
                            id: u16::try_from(g.id).map_err(|_| Error::InvalidFont)?,
                            font: FontSlot(slot as u8),
                            cluster: (paragraph.content.start + source.start) as u32,
                            x: g.x,
                            baseline: height + g.y,
                        })?;
                        glyph_count += 1;
                        if MATERIALIZE {
                            glyphs.push(glyph);
                        }
                    }
                    if clusters.next().is_some() {
                        return Err(Error::InvalidFont);
                    }
                    if detailed {
                        let source = if content.is_empty() {
                            0..0
                        } else {
                            run.run().text_range()
                        };
                        if content.get(source.clone()).is_none() {
                            return Err(Error::InvalidFont);
                        }
                        if let Some(d) = &mut details {
                            d.runs.push(Run {
                                start: (paragraph.content.start + source.start) as u32,
                                end: (paragraph.content.start + source.end) as u32,
                                glyph_start: first as u32,
                                glyph_end: glyph_count as u32,
                                line: global_line as u32,
                                font: FontSlot(slot as u8),
                                direction: if run.run().is_rtl() {
                                    TextDirection::RightToLeft
                                } else {
                                    TextDirection::LeftToRight
                                },
                            });
                        }
                    }
                }
            }
            if let Some(stops) = details.as_mut().and_then(|d| d.carets.as_mut()) {
                append_carets(stops, planned, content, paragraph.content.start, height)?;
            }
            height += planned.height();
        }
        // The immutable map cannot append stops after publication. Charge the
        // trim separately from stop-field compression and query changes.
        if let Some(stops) = details.as_mut().and_then(|d| d.carets.as_mut()) {
            stops.shrink_to_fit();
        }
        Ok(Planned {
            metrics: TextMetrics {
                width,
                height,
                baseline,
            },
            glyphs,
            mask,
            details,
        })
    }
}

fn freeze_line(
    line: parley::layout::Line<'_, ()>,
    content: &str,
    source: usize,
    height: f32,
) -> Result<Line, Error> {
    let m = line.metrics();
    let mut range = if content.is_empty() {
        0..0
    } else {
        line.text_range()
    };
    // In-paragraph mandatory breaks (e.g. U+2028) have the same content-only
    // contract as paragraph separators. Use actual producer cluster authority.
    if line.break_reason() == parley::layout::BreakReason::Explicit
        && let Some(start) = line
            .runs()
            .flat_map(|run| run.visual_clusters())
            .filter(|cluster| cluster.is_hard_line_break())
            .map(|cluster| cluster.text_range().start)
            .min()
    {
        range.end = range.end.min(start);
    }
    if content.get(range.clone()).is_none() {
        return Err(Error::InvalidFont);
    }
    Ok(Line {
        start: (source + range.start) as u32,
        end: (source + range.end) as u32,
        top: height + m.block_min_coord.min(m.content_block_min_coord),
        height: m.block_max_coord.max(m.content_block_max_coord)
            - m.block_min_coord.min(m.content_block_min_coord),
        baseline: height + m.baseline,
        width: if content.is_empty() { 0. } else { m.advance },
    })
}
fn append_carets(
    stops: &mut Vec<Stop>,
    planned: &parley::Layout<()>,
    content: &str,
    source: usize,
    height: f32,
) -> Result<(), Error> {
    let segmenter = GraphemeClusterSegmenter::new();
    // A fixed small number of direct queries is linear in source
    // length and avoids an index for e.g. one huge grapheme. Bulk
    // maps use constant-time source/prefix lookup per destination.
    let geometry = if segmenter.segment_str(content).nth(8).is_some() {
        Some(CursorGeometry::new(planned).ok_or(Error::InvalidFont)?)
    } else {
        None
    };
    for byte in segmenter.segment_str(content) {
        let indexed_pair = if let Some(index) = &geometry {
            let Some(pair) = index.geometries_at(byte, 1.) else {
                continue;
            };
            Some(pair)
        } else {
            None
        };
        let mut pair = [None, None];
        for (index, affinity) in [Affinity::Upstream, Affinity::Downstream]
            .into_iter()
            .enumerate()
        {
            let r = if let Some(bounds) = &indexed_pair {
                bounds[index]
            } else {
                let cursor = Cursor::from_byte_index(planned, byte, affinity);
                if cursor.index() != byte {
                    continue;
                }
                cursor.geometry(planned, 1.)
            };
            let bounds = Rect::new(
                r.x0 as f32,
                (f64::from(height) + r.y0) as f32,
                (r.x1 - r.x0) as f32,
                (r.y1 - r.y0) as f32,
            );
            if ![bounds.x, bounds.y, bounds.width, bounds.height]
                .into_iter()
                .all(f32::is_finite)
            {
                return Err(Error::InvalidGeometry);
            }
            pair[index] = Some(bounds);
        }
        let global = (source + byte) as u32;
        if pair[0].is_some() && pair[0] == pair[1] {
            stops.push(Stop {
                byte: global,
                x: pair[0].unwrap().x,
                affinities: 3,
            });
        } else {
            for (i, bounds) in pair.into_iter().enumerate() {
                if let Some(bounds) = bounds {
                    stops.push(Stop {
                        byte: global,
                        x: bounds.x,
                        affinities: 1 << i,
                    });
                }
            }
        }
    }
    Ok(())
}
#[cfg(test)]
#[path = "cursor_pair_tests.rs"]
mod cursor_pair_tests;
#[cfg(test)]
#[path = "line_ownership_tests.rs"]
mod line_ownership_tests;

fn register_font(
    fonts: &mut FontContext,
    face: &FontFace,
    family: &'static str,
) -> Result<u64, Error> {
    let blob = Blob::new(Arc::new(FontBytes(face.clone())));
    let id = blob.id();
    let registered = fonts.collection.register_fonts(
        blob,
        Some(FontInfoOverride {
            family_name: Some(family),
            // A FontFace is an explicit default instance, not a CSS family
            // request. Prevent implicit weight/width/slant synthesis from
            // choosing axes that our default-instance rasterizer does not use.
            width: Some(Default::default()),
            style: Some(Default::default()),
            weight: Some(Default::default()),
            // Fontique 0.12 compares a variable weight axis's default directly
            // to the CSS request, independently of the overridden face weight.
            // This registry describes an explicit default instance: prevent a
            // synthesized wght=400 coordinate without changing the font bytes.
            axes: Some(&[(skrifa::Tag::new(b"wght"), 400.)]),
        }),
    );
    if registered.is_empty() {
        return Err(Error::InvalidFont);
    }
    Ok(id)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn raw_run_counts_match_positioned_output_across_wraps_and_scripts() {
        let face = FontFace::bundled().unwrap();
        let mut planner = Planner::new(&face).unwrap();
        let stacked = format!("a{}", "\u{301}".repeat(512));
        for source in [
            "",
            "office ffi",
            "a אבג 123 العربية नमस्ते",
            "\u{200d}\u{2067}\u{2069}",
            "a\u{202e}BC\u{202c}D",
            "  spaces  ",
            &stacked,
        ] {
            for width in [None, Some(0.), Some(17.), Some(80.)] {
                planner.shape(source, 18., width, true).unwrap();
                for line in planner.layout.lines() {
                    let raw = line.runs().map(|run| run.glyph_count()).sum::<usize>();
                    let positioned = line
                        .items()
                        .map(|item| match item {
                            PositionedLayoutItem::GlyphRun(run) => run.positioned_glyphs().count(),
                            _ => 0,
                        })
                        .sum::<usize>();
                    assert_eq!(raw, positioned, "{source:?}, {width:?}");
                }
            }
        }
    }

    #[test]
    fn rejected_expanding_output_does_not_contaminate_the_next_paragraph() {
        let face = FontFace::new(&PRIMARY_BYTES[..]).unwrap();
        let mut planner = Planner::new(&face).unwrap();
        planner
            .shape("first paragraph", 18., Some(40.), true)
            .unwrap();
        // Exercise the output guard directly: public TextShaper also limits
        // source bytes, whereas a font may expand short admitted source.
        assert!(matches!(
            planner.shape(&"W".repeat(MAX_GLYPHS + 1), 18., None, false),
            Err(Error::ResourceLimit)
        ));
        assert!(matches!(
            planner.measure(&"W".repeat(MAX_GLYPHS + 1), 18., None),
            Err(Error::ResourceLimit)
        ));
        let source = "office\n\nnext";
        let actual = planner.shape(source, 18., Some(60.), true).unwrap();
        let expected = face
            .shaper()
            .shape_interactive(source, 18., Some(60.))
            .unwrap();
        assert_eq!(
            actual.glyphs().collect::<Vec<_>>(),
            expected.glyphs().collect::<Vec<_>>()
        );
        assert_eq!(
            [actual.width, actual.height, actual.baseline],
            [expected.width, expected.height, expected.baseline]
        );
        for byte in source
            .char_indices()
            .map(|(byte, _)| byte)
            .chain([source.len()])
        {
            for affinity in [CaretAffinity::Upstream, CaretAffinity::Downstream] {
                let position = TextPosition {
                    offset: TextOffset::new(byte).unwrap(),
                    affinity,
                };
                assert_eq!(
                    actual.caret_bounds(position),
                    expected.caret_bounds(position)
                );
            }
        }
    }
    #[test]
    fn measurement_keeps_exact_metrics_and_no_owned_geometry() {
        let _registry = super::super::BUNDLED_TEST_LOCK.lock().unwrap();
        let face = FontFace::bundled().unwrap();
        let mut planner = Planner::new(&face).unwrap();
        for source in [
            "",
            "office ffi fi  spaces   tail ",
            "a\u{301}b\u{200d}c",
            "abc אבג 123 xyz العربية نهاية",
            "\r\n\u{2028}\u{2028}end\n",
        ] {
            for width in [None, Some(f32::MIN_POSITIVE), Some(30.), Some(180.)] {
                let measured = planner.measure(source, 16., width).unwrap();
                let shape = planner.shape(source, 16., width, true).unwrap();
                assert_eq!(
                    [measured.width, measured.height, measured.baseline].map(f32::to_bits),
                    [shape.width, shape.height, shape.baseline].map(f32::to_bits),
                    "source={source:?} width={width:?}",
                );
                // Inspect the same specialization used by the public measure
                // entry point, including scripts that need detailed layouts.
                let planned = planner.plan::<false>(source, 16., width, false).unwrap();
                assert_eq!(planned.glyphs.capacity(), 0);
                assert!(planned.details.is_none());
            }
        }
        println!(
            "TEXT_HEADERS metrics={} planned={} layout={} planner={}",
            size_of::<TextMetrics>(),
            size_of::<Planned>(),
            size_of::<TextLayout>(),
            size_of::<Planner<'_>>()
        );
    }
    use parley::Cursor;

    fn cmap_record(bytes: &[u8]) -> usize {
        let count = u16::from_be_bytes(bytes[4..6].try_into().unwrap());
        (0..usize::from(count))
            .map(|index| 12 + index * 16)
            .find(|&record| &bytes[record..record + 4] == b"cmap")
            .unwrap()
    }

    fn compare_cmap(bytes: &[u8]) {
        let face = ttf_parser::Face::parse(bytes, 0).unwrap();
        let cached = Cmap::parse(bytes).unwrap();
        for code in 0..=0x10ffff {
            if let Some(character) = char::from_u32(code) {
                assert_eq!(
                    cached.glyph_index(character),
                    face.glyph_index(character),
                    "U+{code:04X}"
                );
            }
        }
    }

    #[test]
    fn cached_cmaps_match_face_for_every_scalar_and_absent_or_custom_tables() {
        for bytes in [&PRIMARY_BYTES[..], &ARABIC_BYTES[..], &HEBREW_BYTES[..]] {
            compare_cmap(bytes);
        }
        let mut missing = PRIMARY_BYTES.to_vec();
        let record = cmap_record(&missing);
        missing[record..record + 4].copy_from_slice(b"zmap");
        assert!(Cmap::parse(&missing).unwrap().0.is_none());
        compare_cmap(&missing);

        // Three format-0 subtables: ignore the non-Unicode first table, prefer
        // the first Unicode mapping for A, and continue past its missing B.
        let mut custom = PRIMARY_BYTES.to_vec();
        let record = cmap_record(&custom);
        let offset = custom.len() as u32;
        let mut cmap = vec![0, 0, 0, 3];
        for (index, (platform, encoding)) in
            [(1_u16, 0_u16), (3, 1), (0, 3)].into_iter().enumerate()
        {
            cmap.extend(platform.to_be_bytes());
            cmap.extend(encoding.to_be_bytes());
            cmap.extend((28 + index as u32 * 262).to_be_bytes());
        }
        for index in 0..3 {
            cmap.extend([0, 0, 1, 6, 0, 0]); // format, length, language
            let mut glyphs = [0; 256];
            glyphs[b'A' as usize] = [10, 7, 8][index];
            glyphs[b'B' as usize] = if index == 2 { 9 } else { 0 };
            cmap.extend(glyphs);
        }
        custom[record + 8..record + 12].copy_from_slice(&offset.to_be_bytes());
        custom[record + 12..record + 16].copy_from_slice(&(cmap.len() as u32).to_be_bytes());
        custom.extend(cmap);
        let cached = Cmap::parse(&custom).unwrap();
        assert_eq!(cached.glyph_index('A'), Some(ttf_parser::GlyphId(7)));
        assert_eq!(cached.glyph_index('B'), Some(ttf_parser::GlyphId(9)));
        assert_eq!(cached.glyph_index('C'), None);
        compare_cmap(&custom);

        // Format 13 can return Some(GlyphId(0)), despite the subtable API's
        // general documentation. Face stops there; do not skip to the later A.
        let offset = offset as usize;
        let length = custom.len() - offset;
        custom[offset + 16..offset + 20].copy_from_slice(&(length as u32).to_be_bytes());
        let mut zero = vec![0, 13, 0, 0];
        for value in [28_u32, 0, 1, u32::from('A'), u32::from('A'), 0] {
            zero.extend(value.to_be_bytes());
        }
        custom.extend(zero);
        custom[record + 12..record + 16].copy_from_slice(&((length + 28) as u32).to_be_bytes());
        assert_eq!(
            Cmap::parse(&custom).unwrap().glyph_index('A'),
            Some(ttf_parser::GlyphId(0))
        );
        compare_cmap(&custom);
    }

    #[test]
    fn indexed_cursor_geometry_matches_original_at_every_byte_and_affinity() {
        // Keep the bundled-registry concurrency/release unit test isolated:
        // this independent Parley oracle mints no GPUI font IDs or leases.
        let mut fonts = FontContext {
            collection: Collection::new(CollectionOptions {
                shared: false,
                system_fonts: false,
            }),
            source_cache: SourceCache::default(),
        };
        for (family, bytes) in
            FAMILIES
                .into_iter()
                .zip([&PRIMARY_BYTES[..], &ARABIC_BYTES[..], &HEBREW_BYTES[..]])
        {
            fonts.collection.register_fonts(
                Blob::new(Arc::new(bytes)),
                Some(FontInfoOverride {
                    family_name: Some(family),
                    width: Some(Default::default()),
                    style: Some(Default::default()),
                    weight: Some(Default::default()),
                    axes: None,
                }),
            );
        }
        let mut context = LayoutContext::<()>::new();
        let names = FAMILIES.map(|name| FontFamilyName::Named(name.into()));
        for source in [
            String::new(),
            "a\r\nb\n".into(),
            "a\u{200d}ع\u{651}\u{2069}e\u{301} \u{2067}ع\u{651}П".into(),
            "abc אבג 123 def".repeat(8),
            "لَا العربية ".repeat(8),
            format!("a{}", "\u{301}".repeat(512)),
            "a".repeat(1000),
        ] {
            for (width, boxes) in [
                (None, false),
                (Some(20.), false),
                (Some(80.), false),
                (Some(80.), true),
            ] {
                let mut builder = context.ranged_builder(&mut fonts, &source, 1., false);
                if boxes {
                    for (id, byte) in [(1, 0), (2, source.len())] {
                        builder.push_inline_box(parley::InlineBox {
                            id,
                            index: byte,
                            kind: parley::InlineBoxKind::InFlow,
                            width: 3.125,
                            height: 13.75,
                            baseline: None,
                            vertical_align: Default::default(),
                        });
                    }
                }
                builder.push_default(&names[..]);
                builder.push_default(StyleProperty::FontSize(18.));
                builder.push_default(StyleProperty::OverflowWrap(OverflowWrap::Anywhere));
                let mut layout = builder.build(&source);
                layout.break_all_lines(width);
                let index = CursorGeometry::new(&layout).unwrap();
                for byte in 0..=source.len() + 1 {
                    for affinity in [Affinity::Upstream, Affinity::Downstream] {
                        let reference = Cursor::from_byte_index(&layout, byte, affinity);
                        let actual = index.cursor(byte, affinity);
                        assert_eq!(
                            actual, reference,
                            "byte{byte} {affinity:?} width{width:?} {source:?}"
                        );
                        let expected = reference.geometry(&layout, 1.25);
                        let bounds = index.geometry(actual, 1.25);
                        assert_eq!(
                            [
                                bounds.x0.to_bits(),
                                bounds.y0.to_bits(),
                                bounds.x1.to_bits(),
                                bounds.y1.to_bits()
                            ],
                            [
                                expected.x0.to_bits(),
                                expected.y0.to_bits(),
                                expected.x1.to_bits(),
                                expected.y1.to_bits()
                            ],
                            "byte{byte} {affinity:?} width{width:?} {source:?}"
                        );
                    }
                }
            }
        }
    }
}

#[cfg(test)]
#[path = "line_break_tests.rs"]
mod line_break_tests;
