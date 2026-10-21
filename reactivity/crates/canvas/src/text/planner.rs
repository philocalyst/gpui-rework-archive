//! Scoped Unicode planning. No Parley layout or mutable font database survives
//! lowering into Canvas's owned glyphs and optional interaction map.
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

pub(super) struct Planner {
    fonts: FontContext,
    context: LayoutContext<()>,
    faces: FontSet,
    blob_ids: [Option<u64>; 3],
    sets: [Option<Arc<FontSet>>; 4],
}
impl Planner {
    pub fn new(primary: &FontFace) -> Result<Self, Error> {
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
            faces,
            blob_ids: [None; 3],
            sets: [Some(base), None, None, None],
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
        let face = ttf_parser::Face::parse(&self.faces.primary.0.bytes, 0)
            .map_err(|_| Error::InvalidFont)?;
        let ignorable = CodePointSetData::new::<DefaultIgnorableCodePoint>();
        let mut fallback_faces = None;
        let mut needed = 0_u8;
        for c in text.chars() {
            if matches!(c, '\r' | '\n' | '\u{85}' | '\u{2028}' | '\u{2029}')
                || ignorable.contains(c)
            {
                continue;
            }
            if c.is_control() {
                return Err(Error::UnsupportedControl(c));
            }
            if face.glyph_index(c).is_some_and(|g| g.0 != 0) {
                continue;
            }
            if !self.faces.primary.0.bundled {
                return Err(Error::MissingGlyph(c));
            }
            // Inspect borrowed cmap tables once, without creating a font lease
            // or registering a family until actual missing coverage needs it.
            if fallback_faces.is_none() {
                fallback_faces = Some([
                    ttf_parser::Face::parse(FontFace::fallback_bytes(1)?, 0)
                        .map_err(|_| Error::InvalidFont)?,
                    ttf_parser::Face::parse(FontFace::fallback_bytes(2)?, 0)
                        .map_err(|_| Error::InvalidFont)?,
                ]);
            }
            let mut covered = 0_u8;
            for (index, fallback) in fallback_faces.as_ref().unwrap().iter().enumerate() {
                if fallback.glyph_index(c).is_some_and(|glyph| glyph.0 != 0) {
                    covered |= 1 << index;
                }
            }
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
        let needed = self.coverage(text)?;
        let mut names = FAMILIES.map(|name| FontFamilyName::Named(name.into()));
        let mut family_count = 1;
        for (index, family) in FAMILIES.iter().enumerate().skip(1) {
            if needed & (1 << (index - 1)) != 0 {
                names[family_count] = FontFamilyName::Named((*family).into());
                family_count += 1;
            }
        }
        let mut glyphs = Vec::new();
        let mut details: Option<Details> = None;
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
            let mut planned = builder.build(content);
            planned.break_all_lines(max_width);
            let simple = !interactive
                && paragraph.content.end == text.len()
                && paragraph.content.start == 0
                && planned.len() == 1
                && planned
                    .lines()
                    .flat_map(|line| line.runs())
                    .all(|run| !run.is_rtl() && Some(run.font().data.id()) == self.blob_ids[0])
                && planned.lines().flat_map(|line| line.runs()).count() <= 1;
            if !simple && details.is_none() {
                details = Some(Details {
                    len: text.len() as u32,
                    runs: Vec::new(),
                    lines: Vec::new(),
                    carets: interactive.then(Vec::new),
                });
            }
            let count = planned
                .lines()
                .flat_map(|line| line.items())
                .map(|item| match item {
                    PositionedLayoutItem::GlyphRun(run) => run.positioned_glyphs().count(),
                    _ => 0,
                })
                .sum::<usize>();
            if glyphs
                .len()
                .checked_add(count)
                .is_none_or(|n| n > MAX_GLYPHS)
            {
                return Err(Error::ResourceLimit);
            }
            if !content.is_empty() {
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
                if let Some(d) = &mut details {
                    let m = line.metrics();
                    let range = if content.is_empty() {
                        0..0
                    } else {
                        line.text_range()
                    };
                    if content.get(range.clone()).is_none() {
                        return Err(Error::InvalidFont);
                    }
                    d.lines.push(Line {
                        start: (paragraph.content.start + range.start) as u32,
                        end: (paragraph.content.start + range.end) as u32,
                        top: height + m.block_min_coord,
                        height: m.line_height,
                        baseline: height + m.baseline,
                        width: if content.is_empty() { 0. } else { m.advance },
                    });
                }
                for item in line.items() {
                    let PositionedLayoutItem::GlyphRun(run) = item else {
                        return Err(Error::InvalidGeometry);
                    };
                    if run
                        .run()
                        .normalized_coords()
                        .iter()
                        .any(|&coordinate| coordinate != 0)
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
                    let first = glyphs.len();
                    // This API shapes one style over each paragraph, so every
                    // positioned item covers its run's full visual glyph range.
                    let mut visual = run.run().visual_clusters();
                    let mut clusters = std::iter::from_fn(|| {
                        let cluster = visual.next()?;
                        let mut source = cluster.text_range();
                        // Parley splits ligatures into logical caret components.
                        // In RTL the glyph-bearing component is at the highest
                        // byte offset; canonical glyph clusters still start at
                        // the first source byte, as HarfBuzz clusters do.
                        if cluster.is_ligature_start() {
                            for component in
                                visual.clone().take_while(|c| c.is_ligature_continuation())
                            {
                                let part = component.text_range();
                                source.start = source.start.min(part.start);
                                source.end = source.end.max(part.end);
                            }
                        }
                        Some((cluster, source))
                    })
                    .flat_map(|(cluster, source)| cluster.glyphs().map(move |_| source.clone()));
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
                        glyphs.push(Glyph {
                            id: u16::try_from(g.id).map_err(|_| Error::InvalidFont)?,
                            font: FontSlot(slot as u8),
                            simple_tail_bytes: 0,
                            cluster: (paragraph.content.start + source.start) as u32,
                            x: g.x,
                            baseline: height + g.y,
                        });
                    }
                    if clusters.next().is_some() {
                        return Err(Error::InvalidFont);
                    }
                    if let Some(d) = &mut details {
                        let source = if content.is_empty() {
                            0..0
                        } else {
                            run.run().text_range()
                        };
                        if content.get(source.clone()).is_none() {
                            return Err(Error::InvalidFont);
                        }
                        d.runs.push(Run {
                            start: (paragraph.content.start + source.start) as u32,
                            end: (paragraph.content.start + source.end) as u32,
                            glyph_start: first as u32,
                            glyph_end: glyphs.len() as u32,
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
            if let Some(stops) = details.as_mut().and_then(|d| d.carets.as_mut()) {
                let segmenter = GraphemeClusterSegmenter::new();
                // A fixed small number of direct queries is linear in source
                // length and avoids an index for e.g. one huge grapheme. Bulk
                // maps use constant-time source/prefix lookup per destination.
                let geometry = if segmenter.segment_str(content).count() > 8 {
                    Some(CursorGeometry::new(&planned).ok_or(Error::InvalidFont)?)
                } else {
                    None
                };
                for byte in segmenter.segment_str(content) {
                    let mut pair = [None, None];
                    for (index, affinity) in [Affinity::Upstream, Affinity::Downstream]
                        .into_iter()
                        .enumerate()
                    {
                        let cursor = geometry.as_ref().map_or_else(
                            || Cursor::from_byte_index(&planned, byte, affinity),
                            |index| index.cursor(byte, affinity),
                        );
                        if cursor.index() != byte {
                            continue;
                        }
                        let r = geometry.as_ref().map_or_else(
                            || cursor.geometry(&planned, 1.),
                            |index| index.geometry(cursor, 1.),
                        );
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
                    let global = (paragraph.content.start + byte) as u32;
                    if pair[0].is_some() && pair[0] == pair[1] {
                        stops.push(Stop {
                            byte: global,
                            bounds: pair[0].unwrap(),
                            affinities: 3,
                        });
                    } else {
                        for (i, bounds) in pair.into_iter().enumerate() {
                            if let Some(bounds) = bounds {
                                stops.push(Stop {
                                    byte: global,
                                    bounds,
                                    affinities: 1 << i,
                                });
                            }
                        }
                    }
                }
            }
            height += planned.height();
        }
        if details.is_none() {
            let encoded = match glyphs.last_mut() {
                Some(last) => {
                    let tail = (text.len() as u32)
                        .checked_sub(last.cluster)
                        .ok_or(Error::InvalidFont)?;
                    if let Ok(tail) = u8::try_from(tail) {
                        last.simple_tail_bytes = tail;
                        true
                    } else {
                        false
                    }
                }
                None => text.is_empty(),
            };
            if !encoded {
                details = Some(Details {
                    len: text.len() as u32,
                    runs: vec![Run {
                        start: 0,
                        end: text.len() as u32,
                        glyph_start: 0,
                        glyph_end: glyphs.len() as u32,
                        line: 0,
                        font: FontSlot(0),
                        direction: TextDirection::LeftToRight,
                    }],
                    lines: vec![Line {
                        start: 0,
                        end: text.len() as u32,
                        top: 0.,
                        height,
                        baseline,
                        width,
                    }],
                    carets: None,
                });
            }
        }
        Ok(TextLayout {
            width,
            height,
            baseline,
            font_size: size,
            glyphs,
            fonts: self.font_set(mask),
            mapping: details.map(Box::new),
        })
    }
}

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
            axes: None,
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
    use parley::Cursor;

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
