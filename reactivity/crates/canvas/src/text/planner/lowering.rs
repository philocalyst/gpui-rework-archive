//! One ordered admission/lowering traversal for ordinary and borrowed widths.
//! No paragraph cache/resource, font registration or GPUI adoption is introduced.
use super::*;

#[derive(Clone, Copy)]
pub(super) enum PlannedParagraph<'a, 'owner: 'a> {
    Layout(&'a parley::Layout<()>),
    // Only test callers construct this until a certified Canvas resource exists.
    #[allow(dead_code)]
    View(&'a parley::WidthView<'owner, ()>),
}
impl<'a, 'owner: 'a> PlannedParagraph<'a, 'owner> {
    fn len(self) -> usize { match self { Self::Layout(p) => p.len(), Self::View(p) => p.lines().len() } }
    fn get(self, index: usize) -> Option<parley::layout::Line<'a, ()>> {
        match self { Self::Layout(p) => p.get(index), Self::View(p) => p.get(index) }
    }
    fn lines(self) -> impl ExactSizeIterator<Item = parley::layout::Line<'a, ()>> + DoubleEndedIterator + Clone + 'a {
        // Both private sources expose exactly their width-data line array length.
        // No new filtering, order, source topology or allocation is introduced.
        (0..self.len()).map(move |index| self.get(index).expect("private width-data line index"))
    }
    fn width(self) -> f32 { match self { Self::Layout(p) => p.width(), Self::View(p) => p.width() } }
    fn full_width(self) -> f32 { match self { Self::Layout(p) => p.full_width(), Self::View(p) => p.full_width() } }
    fn height(self) -> f32 { match self { Self::Layout(p) => p.height(), Self::View(p) => p.height() } }
    pub(super) fn index(self) -> Option<CursorGeometry<'a, ()>> {
        match self { Self::Layout(p) => CursorGeometry::new(p), Self::View(p) => CursorGeometry::from_width_view(p) }
    }
    pub(super) fn cursor(self, byte: usize, affinity: Affinity) -> Cursor {
        match self { Self::Layout(p) => Cursor::from_byte_index(p, byte, affinity), Self::View(p) => p.cursor_from_byte_index(byte, affinity) }
    }
    pub(super) fn geometry(self, cursor: Cursor, width: f32) -> parley::BoundingBox {
        match self { Self::Layout(p) => cursor.geometry(p, width), Self::View(p) => p.cursor_geometry(cursor, width) }
    }
}

pub(super) struct Lowering {
    glyphs: EcoVec<PackedGlyph>,
    details: Option<Details>,
    detailed: bool,
    glyph_count: usize,
    width: f32,
    height: f32,
    baseline: f32,
    mask: usize,
}
impl Lowering {
    pub(super) fn new() -> Self {
        Self { glyphs: EcoVec::new(), details: None, detailed: false, glyph_count: 0,
            width: 0.0f32, height: 0.0f32, baseline: 0.0f32, mask: 0 }
    }
    // State is MOVED, never cloned: vector capacities stay owned by one lowering
    // pass. On any admission error these output buffers drop, as previously.
    pub(super) fn paragraph<'a, 'owner: 'a, const MATERIALIZE: bool>(
        self, planned: PlannedParagraph<'a, 'owner>, content: &str,
        paragraph: &paragraph::Paragraph, text: &str, size: f32,
        max_width: Option<f32>, interactive: bool, blob_ids: &[Option<u64>; 3],
    ) -> Result<Self, Error> {
        let Self { mut glyphs, mut details, mut detailed, mut glyph_count,
            mut width, mut height, mut baseline, mut mask } = self;
        let simple = !interactive
            && paragraph.content.end == text.len()
            && paragraph.content.start == 0
            && planned.len() == 1
            && planned
                .lines()
                .flat_map(|line| line.runs())
                .all(|run| !run.is_rtl() && Some(run.font().data.id()) == blob_ids[0])
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
                let slot = blob_ids
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
            append_carets_read(stops, planned, content, paragraph.content.start, height)?;
        }
        height += planned.height();
        Ok(Self { glyphs, details, detailed, glyph_count, width, height, baseline, mask })
    }
    pub(super) fn finish(self) -> Planned {
        let Self { glyphs, mut details, width, height, baseline, mask, .. } = self;
        // The immutable map cannot append stops after publication. Charge the
        // trim separately from stop-field compression and query changes.
        if let Some(stops) = details.as_mut().and_then(|d| d.carets.as_mut()) {
            stops.shrink_to_fit();
        }
        Planned {
            metrics: TextMetrics {
                width,
                height,
                baseline,
            },
            glyphs,
            mask,
            details,
        }
    }
}

#[cfg(test)]
#[path = "lowering_tests.rs"]
mod tests;
