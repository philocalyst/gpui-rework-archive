//! Borrowed typed views over the one canonical owned glyph layout.
use super::{FontFace, FontSlot, Glyph, TextLayout};
use crate::Rect;
use std::ops::Range;
mod interaction;

/// UTF-8 document byte offset, distinct from glyph indices and UTF-16 units.
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub struct TextOffset(u32);
impl TextOffset {
    pub fn new(byte: usize) -> Option<Self> {
        u32::try_from(byte).ok().map(Self)
    }
    pub fn byte(self) -> usize {
        self.0 as usize
    }
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum CaretAffinity {
    Upstream,
    Downstream,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct TextPosition {
    pub offset: TextOffset,
    pub affinity: CaretAffinity,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct TextSelection {
    pub anchor: TextPosition,
    pub focus: TextPosition,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum TextDirection {
    LeftToRight,
    RightToLeft,
}

#[derive(Clone, Debug)]
pub(super) struct Details {
    pub len: u32,
    pub runs: Vec<Run>,
    pub lines: Vec<Line>,
    pub carets: Option<Vec<Stop>>,
}
#[derive(Clone, Copy, Debug)]
pub(super) struct Run {
    pub start: u32,
    pub end: u32,
    pub glyph_start: u32,
    pub glyph_end: u32,
    pub line: u32,
    pub font: FontSlot,
    pub direction: TextDirection,
}
#[derive(Clone, Copy, Debug)]
pub(super) struct Line {
    pub start: u32,
    pub end: u32,
    pub top: f32,
    pub height: f32,
    pub baseline: f32,
    pub width: f32,
}
#[derive(Clone, Copy, Debug)]
pub(super) struct Stop {
    pub byte: u32,
    pub bounds: Rect,
    // 1 upstream, 2 downstream, 3 either. Equal geometry is retained once.
    pub affinities: u8,
}
#[derive(Clone, Copy)]
pub struct GlyphRun<'a> {
    layout: &'a TextLayout,
    run: Run,
}
impl<'a> GlyphRun<'a> {
    pub fn text_range(self) -> Range<TextOffset> {
        TextOffset(self.run.start)..TextOffset(self.run.end)
    }
    pub fn glyphs(self) -> &'a [Glyph] {
        &self.layout.glyphs[self.run.glyph_start as usize..self.run.glyph_end as usize]
    }
    pub fn direction(self) -> TextDirection {
        self.run.direction
    }
    pub fn line(self) -> usize {
        self.run.line as usize
    }
    pub fn font_face(self) -> &'a FontFace {
        self.layout
            .fonts
            .face(usize::from(self.run.font.0))
            .expect("validated run font slot")
    }
}
#[derive(Clone, Copy, Debug)]
pub struct TextLine(Line);
impl TextLine {
    pub fn text_range(self) -> Range<TextOffset> {
        TextOffset(self.0.start)..TextOffset(self.0.end)
    }
    pub fn bounds(self) -> Rect {
        Rect::new(0., self.0.top, self.0.width, self.0.height)
    }
    pub fn baseline(self) -> f32 {
        self.0.baseline
    }
}

impl TextLayout {
    pub fn text_len(&self) -> usize {
        self.mapping.as_ref().map_or_else(
            || {
                self.glyphs
                    .last()
                    .map_or(0, |g| (g.cluster + u32::from(g.simple_tail_bytes)) as usize)
            },
            |m| m.len as usize,
        )
    }
    pub fn runs(&self) -> impl Iterator<Item = GlyphRun<'_>> + Clone {
        let (single, many): (Option<Run>, &[Run]) = match &self.mapping {
            None => (
                Some(Run {
                    start: 0,
                    end: self.text_len() as u32,
                    glyph_start: 0,
                    glyph_end: self.glyphs.len() as u32,
                    line: 0,
                    font: FontSlot(0),
                    direction: TextDirection::LeftToRight,
                }),
                &[],
            ),
            Some(m) => (None, &m.runs),
        };
        single
            .into_iter()
            .chain(many.iter().copied())
            .map(|run| GlyphRun { layout: self, run })
    }
    pub fn lines(&self) -> impl Iterator<Item = TextLine> + Clone {
        let (single, many): (Option<Line>, &[Line]) = match &self.mapping {
            None => (
                Some(Line {
                    start: 0,
                    end: self.text_len() as u32,
                    top: 0.,
                    height: self.height,
                    baseline: self.baseline,
                    width: self.width,
                }),
                &[],
            ),
            Some(m) => (None, &m.lines),
        };
        single.into_iter().chain(many.iter().copied()).map(TextLine)
    }
    /// Geometry exists only when interactive shaping was requested. Invalid
    /// bytes (including CRLF/combining interiors) produce None, never a snap.
    pub fn caret_bounds(&self, position: TextPosition) -> Option<Rect> {
        let map = self.mapping.as_ref()?;
        let stops = map.carets.as_ref()?;
        let mask = match position.affinity {
            CaretAffinity::Upstream => 1,
            CaretAffinity::Downstream => 2,
        };
        let first = stops.partition_point(|stop| stop.byte < position.offset.0);
        stops[first..]
            .iter()
            .take_while(|stop| stop.byte == position.offset.0)
            .find(|stop| stop.affinities & mask != 0)
            .map(|stop| stop.bounds)
    }
    /// Validates both endpoints in this layout's current interaction map.
    /// It is not a document-revision token or an editor mutation.
    pub fn validates_selection(&self, selection: TextSelection) -> bool {
        self.caret_bounds(selection.anchor).is_some()
            && self.caret_bounds(selection.focus).is_some()
    }

    /// Release opt-in caret geometry while preserving the canonical glyphs,
    /// fonts and placement. Single primary-font LTR metadata is folded back
    /// into the ordinary compact layout when its tail fits the existing slot.
    pub fn discard_interaction(&mut self) {
        let Some(map) = &mut self.mapping else {
            return;
        };
        map.carets = None;
        let simple = map.lines.len() == 1
            && map.runs.len() <= 1
            && map.runs.iter().all(|run| {
                run.font == FontSlot(0)
                    && run.direction == TextDirection::LeftToRight
                    && run.start == 0
                    && run.end == map.len
            });
        if simple {
            let encoded = match self.glyphs.last_mut() {
                Some(last) => map
                    .len
                    .checked_sub(last.cluster)
                    .and_then(|tail| u8::try_from(tail).ok())
                    .map(|tail| last.simple_tail_bytes = tail)
                    .is_some(),
                None => map.len == 0,
            };
            if encoded {
                self.mapping = None;
            }
        }
    }
}
