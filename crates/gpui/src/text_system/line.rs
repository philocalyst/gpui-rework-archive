use crate::{
    App, Bounds, InlineLayout, LineLayout, PaintFragment, PaintQuad, Pixels, Point, Result,
    ShapedTextLayout, SharedString, TextAlign, TextSystem, VisualLine, Window, point, size,
};
use derive_more::{Deref, DerefMut};
use std::sync::{
    Arc,
    atomic::{AtomicUsize, Ordering},
};

static GLYPH_PAINT_ERRORS: AtomicUsize = AtomicUsize::new(0);
const MAX_LOGGED_GLYPH_PAINT_ERRORS: usize = 20;

/// A shaped line that is ready to measure and paint.
///
/// [`WindowTextSystem::shape_line`](crate::WindowTextSystem::shape_line) does
/// the expensive shaping work. Reuse the result to measure with
/// [`ShapedLine::width`] and paint on each frame. Paint backgrounds first with
/// [`ShapedLine::paint_background`] when a row needs to sit behind other content.
///
/// # Examples
///
/// ```
/// # use gpui::{EmptyView, TestApp, TextRun, font, hsla, px};
/// # let mut app = TestApp::new();
/// # let mut window = app.open_window(|_window, _cx| EmptyView);
/// window.update(|_view, window, _cx| {
///     let run = TextRun {
///         len: "Hi".len(),
///         font: font("Lilex"),
///         color: hsla(0., 0., 0., 1.),
///         ..Default::default()
///     };
///     let line = window.text_system().shape_line("Hi".into(), px(16.), &[run]);
///     assert_eq!(line.text.as_ref(), "Hi");
///     assert_eq!(line.len(), 2);
/// });
/// ```
#[derive(Clone, Debug, Deref, DerefMut)]
pub struct ShapedLine {
    #[deref]
    #[deref_mut]
    pub(crate) layout: Arc<LineLayout>,
    /// The text that was shaped for this line.
    pub text: SharedString,
}

impl ShapedLine {
    /// Returns the length of the line in UTF-8 bytes.
    #[allow(clippy::len_without_is_empty)]
    pub fn len(&self) -> usize {
        self.layout.len
    }

    /// Returns the width of the line in logical pixels.
    ///
    /// This is the glyph advance width from the text shaping system. Use it to
    /// advance a "pen" when you paint several lines or fragments on one row.
    pub fn width(&self) -> Pixels {
        self.layout.width
    }

    /// Paints the glyphs, underlines, and strikethroughs of the line.
    ///
    /// `origin` is the top-left corner of the line box, which is `line_height`
    /// tall. The baseline is placed inside that box, centered by the font's
    /// ascent and descent. When `align_width` is `Some`, the line is aligned
    /// within that width using `align`. Otherwise it is aligned in its own width.
    ///
    /// Call this during paint. Background colors are not painted here, so call
    /// [`ShapedLine::paint_background`] first.
    ///
    /// # Errors
    ///
    /// Returns an error only if the window's paint layer fails. A glyph that
    /// fails to paint is logged and skipped, and the call still succeeds.
    pub fn paint(
        &self,
        origin: Point<Pixels>,
        line_height: Pixels,
        align: TextAlign,
        align_width: Option<Pixels>,
        window: &mut Window,
        cx: &mut App,
    ) -> Result<()> {
        paint_visual_text(
            origin,
            &self.layout,
            line_height,
            align,
            align_width,
            &self.layout.visual_lines,
            TextPaintPass::Foreground,
            window,
            cx,
        )
    }

    /// Paints the background color of each run in the line.
    ///
    /// The arguments match [`ShapedLine::paint`]. Call this before `paint`, so
    /// that the glyphs are drawn over the backgrounds.
    pub fn paint_background(
        &self,
        origin: Point<Pixels>,
        line_height: Pixels,
        align: TextAlign,
        align_width: Option<Pixels>,
        window: &mut Window,
        cx: &mut App,
    ) -> Result<()> {
        paint_visual_text(
            origin,
            &self.layout,
            line_height,
            align,
            align_width,
            &self.layout.visual_lines,
            TextPaintPass::Background,
            window,
            cx,
        )
    }
}

/// Shaped text that may contain hard breaks and soft-wrapped lines.
///
/// [`WindowTextSystem::shape_text`](crate::WindowTextSystem::shape_text) returns
/// one visual line for each wrapped or hard-broken line. Paint it with
/// [`ShapedText::paint`], and paint backgrounds first with
/// [`ShapedText::paint_background`]. It derefs to [`ShapedTextLayout`], so the
/// same result supplies measurements such as [`ShapedTextLayout::size`] and
/// [`ShapedTextLayout::line_count`].
///
/// # Examples
///
/// ```
/// # use gpui::{EmptyView, TestApp, TextRun, font, hsla, px};
/// # let mut app = TestApp::new();
/// # let mut window = app.open_window(|_window, _cx| EmptyView);
/// window.update(|_view, window, _cx| {
///     let text = "Hello\nworld";
///     let run = TextRun {
///         len: text.len(),
///         font: font("Lilex"),
///         color: hsla(0., 0., 0., 1.),
///         ..Default::default()
///     };
///     let shaped = window
///         .text_system()
///         .shape_text(text, px(16.), &[run], None, None)
///         .unwrap();
///     assert_eq!(shaped.len(), text.len());
/// });
/// ```
#[derive(Debug, Deref, DerefMut)]
pub struct ShapedText {
    #[deref]
    #[deref_mut]
    pub(crate) layout: Arc<ShapedTextLayout>,
    /// The text that was shaped.
    pub text: SharedString,
}

impl ShapedText {
    /// Returns the length of the text in UTF-8 bytes.
    #[allow(clippy::len_without_is_empty)]
    pub fn len(&self) -> usize {
        self.layout.len()
    }

    /// Paints the glyphs and decorations of every visual line.
    ///
    /// `origin` is the top-left corner of the first line. Each following line
    /// starts `line_height` below the previous one. `bounds` supplies the width
    /// used for alignment; when it is `None`, the layout's wrap width is used.
    /// See [`ShapedLine::paint`] for how the arguments place the text.
    ///
    /// # Errors
    ///
    /// Returns an error only if the window's paint layer fails. A glyph that
    /// fails to paint is logged and skipped.
    pub fn paint(
        &self,
        origin: Point<Pixels>,
        line_height: Pixels,
        align: TextAlign,
        bounds: Option<Bounds<Pixels>>,
        window: &mut Window,
        cx: &mut App,
    ) -> Result<()> {
        let align_width = match bounds {
            Some(bounds) => Some(bounds.size.width),
            None => self.layout.wrap_width,
        };

        paint_visual_text(
            origin,
            &self.layout.layout,
            line_height,
            align,
            align_width,
            &self.layout.visual_lines,
            TextPaintPass::Foreground,
            window,
            cx,
        )
    }

    /// Paints the background colors of every visual line before the foreground.
    /// The arguments have the same meaning as [`ShapedText::paint`].
    pub fn paint_background(
        &self,
        origin: Point<Pixels>,
        line_height: Pixels,
        align: TextAlign,
        bounds: Option<Bounds<Pixels>>,
        window: &mut Window,
        cx: &mut App,
    ) -> Result<()> {
        let align_width = match bounds {
            Some(bounds) => Some(bounds.size.width),
            None => self.layout.wrap_width,
        };

        paint_visual_text(
            origin,
            &self.layout.layout,
            line_height,
            align,
            align_width,
            &self.layout.visual_lines,
            TextPaintPass::Background,
            window,
            cx,
        )
    }
}

impl InlineLayout {
    /// Paints the background color of each text run in the inline layout.
    ///
    /// `origin` is the top-left corner of the layout's box. Call this before
    /// [`InlineLayout::paint`].
    pub fn paint_background(
        &self,
        origin: Point<Pixels>,
        window: &mut Window,
        cx: &mut App,
    ) -> Result<()> {
        paint_inline_layout(self, origin, TextPaintPass::Background, window, cx)
    }

    /// Paints the glyphs and underlines or strikethroughs of the inline layout.
    ///
    /// `origin` is the top-left corner of the layout's box. This method paints
    /// only text. The atomic boxes in [`InlineLayout::boxes`] are not painted here.
    pub fn paint(&self, origin: Point<Pixels>, window: &mut Window, cx: &mut App) -> Result<()> {
        paint_inline_layout(self, origin, TextPaintPass::Foreground, window, cx)
    }
}

#[derive(Clone, Copy, PartialEq)]
enum TextPaintPass {
    Background,
    Foreground,
}

struct FragmentPaintContext<'a> {
    line_origin: Point<Pixels>,
    line_height: Pixels,
    baseline_y: Pixels,
    layout: &'a LineLayout,
    pass: TextPaintPass,
    text_system: &'a TextSystem,
}

fn paint_inline_layout(
    inline: &InlineLayout,
    origin: Point<Pixels>,
    pass: TextPaintPass,
    window: &mut Window,
    cx: &mut App,
) -> Result<()> {
    if inline.lines.is_empty() {
        return Ok(());
    }

    let text_system = cx.text_system().clone();
    let placement = place_inline_layout(origin, inline.alignment_offset, window);
    window.paint_layer(Bounds::new(placement.origin, inline.size), |window| {
        for (line, visual_line) in inline.lines.iter().zip(&inline.layout.visual_lines) {
            let line_origin = origin + line.origin + placement.delta;
            paint_visual_line(
                &inline.layout,
                visual_line,
                line_origin,
                line.size.height,
                line_origin.y + line.baseline,
                pass,
                &text_system,
                window,
            );
        }

        Ok(())
    })
}

#[derive(Clone, Copy, Debug, PartialEq)]
pub(crate) struct InlineLayoutPlacement {
    pub(crate) origin: Point<Pixels>,
    pub(crate) delta: Point<Pixels>,
}

pub(crate) fn place_inline_layout(
    content_origin: Point<Pixels>,
    alignment_offset: Pixels,
    window: &Window,
) -> InlineLayoutPlacement {
    let anchor = content_origin + point(alignment_offset, Pixels::ZERO);
    let placed_anchor = window.pixel_snap_point(anchor);
    let delta = placed_anchor - anchor;

    InlineLayoutPlacement {
        origin: content_origin + delta,
        delta,
    }
}

fn paint_visual_line(
    layout: &LineLayout,
    visual_line: &VisualLine,
    line_origin: Point<Pixels>,
    line_height: Pixels,
    baseline_y: Pixels,
    pass: TextPaintPass,
    text_system: &TextSystem,
    window: &mut Window,
) {
    let context = FragmentPaintContext {
        line_origin,
        line_height,
        baseline_y,
        layout,
        pass,
        text_system,
    };
    for fragment in &layout.paint_fragments[visual_line.paint_fragment_range.clone()] {
        paint_text_fragment(fragment, &context, window);
    }
}

fn paint_text_fragment(
    fragment: &PaintFragment,
    context: &FragmentPaintContext<'_>,
    window: &mut Window,
) {
    paint_fragment_decorations_at(
        fragment,
        context.line_origin,
        context.line_height,
        context.baseline_y,
        context.layout,
        window,
        context.pass == TextPaintPass::Foreground,
    );
    if context.pass == TextPaintPass::Background {
        return;
    }

    let max_glyph_size = context
        .text_system
        .bounding_box(fragment.font_id, fragment.font_size)
        .size;
    for glyph in &*fragment.glyphs {
        let cull_origin = point(
            context.line_origin.x + glyph.position.x,
            context.line_origin.y,
        );
        if !Bounds::new(cull_origin, max_glyph_size).intersects(&window.content_mask().bounds) {
            continue;
        }

        let glyph_origin = point(
            context.line_origin.x + glyph.position.x,
            context.baseline_y + glyph.position.y,
        );
        let result = if glyph.is_emoji {
            window.paint_emoji_with_color(
                glyph_origin,
                fragment.font_id,
                glyph.id,
                fragment.font_size,
                fragment.style.color,
            )
        } else {
            window.paint_glyph(
                glyph_origin,
                fragment.font_id,
                glyph.id,
                fragment.font_size,
                fragment.style.color,
            )
        };

        if let Err(error) = result {
            let error_idx = GLYPH_PAINT_ERRORS.fetch_add(1, Ordering::Relaxed);

            if error_idx < MAX_LOGGED_GLYPH_PAINT_ERRORS {
                log::error!(
                    "failed to paint glyph {:?} from font {:?}: {error:#}",
                    glyph.id,
                    fragment.font_id
                );
            } else if error_idx == MAX_LOGGED_GLYPH_PAINT_ERRORS {
                log::error!("suppressing further glyph paint errors");
            }
        }
    }
}

fn paint_visual_text(
    origin: Point<Pixels>,
    layout: &LineLayout,
    line_height: Pixels,
    align: TextAlign,
    align_width: Option<Pixels>,
    visual_lines: &[VisualLine],
    pass: TextPaintPass,
    window: &mut Window,
    cx: &mut App,
    paint_underline: &mut dyn FnMut(
        Range<usize>,
        Point<Pixels>,
        Pixels,
        &UnderlineStyle,
        &mut Window,
    ),
) -> Result<()> {
    if visual_lines.is_empty() {
        return Ok(());
    }

    let line_bounds = visual_text_bounds(origin, line_height, align, align_width, visual_lines);
    window.paint_layer(line_bounds, |window| {
        let padding_top = (line_height - layout.ascent - layout.descent) / 2.;
        let text_system = cx.text_system().clone();

        for (line_index, line) in visual_lines.iter().enumerate() {
            let line_origin = point(
                visual_line_origin_x(origin.x, align, align_width, line),
                origin.y + line_index as f32 * line_height,
            );
            paint_visual_line(
                layout,
                line,
                line_origin,
                line_height,
                line_origin.y + padding_top + layout.ascent,
                pass,
                &text_system,
                window,
            );
        }

        Ok(())
    })
}

fn visual_text_bounds(
    origin: Point<Pixels>,
    line_height: Pixels,
    align: TextAlign,
    align_width: Option<Pixels>,
    visual_lines: &[VisualLine],
) -> Bounds<Pixels> {
    let mut left = Pixels::MAX;
    let mut right = Pixels::MIN;

    for line in visual_lines {
        let line_left = visual_line_origin_x(origin.x, align, align_width, line);
        left = left.min(line_left);
        right = right.max(line_left + line.advance_width);
    }
    Bounds::new(
        point(left, origin.y),
        size(right - left, line_height * visual_lines.len() as f32),
    )
}

fn visual_line_origin_x(
    origin_x: Pixels,
    align: TextAlign,
    align_width: Option<Pixels>,
    line: &VisualLine,
) -> Pixels {
    line.offset
        + aligned_visual_origin_x(
            origin_x,
            align_width.unwrap_or(line.advance_width),
            line.advance_width,
            align,
            line.direction,
        )
}

fn paint_fragment_decorations_at(
    fragment: &PaintFragment,
    line_origin: Point<Pixels>,
    line_height: Pixels,
    baseline_y: Pixels,
    layout: &LineLayout,
    window: &mut Window,
    foreground: bool,
) {
    let range = line_origin.x + fragment.x_range.start..line_origin.x + fragment.x_range.end;
    if foreground {
        if let Some(mut underline) = fragment.style.underline {
            underline.color = Some(underline.color.unwrap_or(fragment.style.color));
            window.paint_underline(
                point(
                    range.start,
                    baseline_y + fragment.underline_offset.unwrap_or(layout.descent * 0.618),
                ),
                range.end - range.start,
                &underline,
            );
        }
        if let Some(mut strike) = fragment.style.strikethrough {
            strike.color = Some(strike.color.unwrap_or(fragment.style.color));
            let strike_y = baseline_y
                + fragment
                    .strikethrough_offset
                    .unwrap_or(-layout.ascent * 0.5);
            window.paint_strikethrough(
                point(range.start, strike_y),
                range.end - range.start,
                &strike,
            );
        }
    } else if let Some(color) = fragment.style.background_color {
        window.paint_quad(
            PaintQuad::new(Bounds::new(
                point(range.start, line_origin.y),
                size(range.end - range.start, line_height),
            ))
            .background(color),
        );
    }
}

fn aligned_visual_origin_x(
    origin_x: Pixels,
    align_width: Pixels,
    line_width: Pixels,
    align: TextAlign,
    direction: crate::ResolvedDirection,
) -> Pixels {
    match align {
        TextAlign::Start if direction.is_rtl() => origin_x + align_width - line_width,
        TextAlign::Start | TextAlign::Left => origin_x,
        TextAlign::Center => (origin_x * 2.0 + align_width - line_width) / 2.0,
        TextAlign::End if direction.is_rtl() => origin_x,
        TextAlign::End | TextAlign::Right => origin_x + align_width - line_width,
    }

    struct UnderlineHandlerTestView(Rc<dyn Fn(&mut Window, &mut App)>);

    impl Render for UnderlineHandlerTestView {
        fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
            let paint = self.0.clone();
            canvas(
                |_, _, _| {},
                move |_, _, window, cx| {
                    window.with_element_opacity(Some(0.5), |window| paint(window, cx));
                },
            )
            .size_full()
        }
    }

    fn test_underline_handler_at_scales(
        cx: &mut TestAppContext,
        paint: impl Fn(&mut Window, &mut App) + 'static,
    ) {
        let window = cx.add_window(move |_, _| UnderlineHandlerTestView(Rc::new(paint)));
        for scale in [1., 1.25, 1.5, 2., 3.] {
            cx.simulate_window_scale_factor_change(window.into(), scale);
            cx.update_window(window.into(), |_, window, cx| window.draw(cx).clear(cx))
                .unwrap();
        }
    }

    fn underline_test_line(
        text: &str,
        decorations: &[DecorationRun],
        zero_advance: bool,
        window: &Window,
    ) -> ShapedLine {
        let mut line = window.text_system().shape_line(
            SharedString::new(text),
            px(16.),
            &[TextRun {
                len: text.len(),
                font: font(".ZedMono"),
                color: black(),
                ..TextRun::default()
            }],
            None,
        );
        line.decoration_runs = SmallVec::from(decorations.to_vec());
        let layout = &line.layout;
        let mut runs = layout.runs.clone();
        let advance = if zero_advance { px(0.) } else { px(8.) };
        let mut width = px(0.);
        for glyph in runs.iter_mut().flat_map(|run| &mut run.glyphs) {
            glyph.position.x = width;
            width += advance;
        }
        line.layout = Arc::new(LineLayout {
            font_size: layout.font_size,
            width,
            ascent: layout.ascent,
            descent: layout.descent,
            runs,
            len: layout.len,
        });
        line
    }

    fn assert_underline_primitives_eq(actual: &[Underline], expected: &[Underline]) {
        assert_eq!(actual.len(), expected.len());
        for (actual, expected) in actual.iter().zip(expected) {
            assert_eq!(actual.bounds, expected.bounds);
            assert_eq!(actual.content_mask, expected.content_mask);
            assert_eq!(actual.color, expected.color);
            assert_eq!(actual.thickness, expected.thickness);
            assert_eq!(actual.wavy, expected.wavy);
            assert_eq!(actual.order, expected.order);
            assert_eq!(actual.pad, expected.pad);
        }
    }

    #[test]
    fn test_cursor_preserves_shaping_metadata_across_runs() {
        let line = ShapedLine {
            layout: Arc::new(LineLayout {
                font_size: px(16.0),
                width: px(50.0),
                ascent: px(12.0),
                descent: px(4.0),
                runs: vec![
                    ShapedRun {
                        font_id: FontId(3),
                        glyphs: vec![
                            ShapedGlyph {
                                id: GlyphId(11),
                                position: point(px(0.0), px(1.0)),
                                index: 0,
                                is_emoji: true,
                            },
                            ShapedGlyph {
                                id: GlyphId(12),
                                position: point(px(17.0), px(1.0)),
                                index: 1,
                                is_emoji: false,
                            },
                            ShapedGlyph {
                                id: GlyphId(13),
                                position: point(px(19.0), px(-1.0)),
                                index: 1,
                                is_emoji: false,
                            },
                        ],
                    },
                    ShapedRun {
                        font_id: FontId(8),
                        glyphs: vec![
                            ShapedGlyph {
                                id: GlyphId(21),
                                position: point(px(25.0), px(1.0)),
                                index: 5,
                                is_emoji: true,
                            },
                            ShapedGlyph {
                                id: GlyphId(22),
                                position: point(px(41.0), px(1.0)),
                                index: 7,
                                is_emoji: false,
                            },
                        ],
                    },
                ],
                len: 10,
            }),
            text: "a😀bcdef".into(),
            decoration_runs: SmallVec::new(),
        };
        let mut cursor = line.cursor();
        let first = cursor.take_until(5);
        assert_eq!(first.text.as_ref(), "a😀");
        assert_eq!(first.runs[0].font_id, FontId(3));
        assert_eq!(first.runs[0].glyphs[0].id, GlyphId(11));
        assert!(first.runs[0].glyphs[0].is_emoji);
        assert_eq!(first.runs[0].glyphs[1].index, 1);
        assert_eq!(first.runs[0].glyphs[1].position, point(px(17.0), px(1.0)));
        assert_eq!(first.runs[0].glyphs.len(), 3);
        assert_eq!(first.runs[0].glyphs[2].index, 1);
        assert_eq!(first.runs[0].glyphs[2].position, point(px(19.0), px(-1.0)));
        assert_eq!(cursor.x_offset(), px(25.0));

        let second = cursor.take_until(7);
        assert_eq!(second.text.as_ref(), "bc");
        assert_eq!(second.runs[0].font_id, FontId(8));
        assert_eq!(second.runs[0].glyphs[0].id, GlyphId(21));
        assert_eq!(second.runs[0].glyphs[0].index, 0);
        assert_eq!(second.runs[0].glyphs[0].position, point(px(0.0), px(1.0)));
        assert_eq!(cursor.x_offset(), px(41.0));

        let final_part = cursor.take_until(10);
        assert_eq!(final_part.text.as_ref(), "def");
        assert_eq!(final_part.runs[0].font_id, FontId(8));
        assert_eq!(final_part.runs[0].glyphs[0].id, GlyphId(22));
        assert_eq!(final_part.runs[0].glyphs[0].index, 0);
        assert_eq!(
            final_part.runs[0].glyphs[0].position,
            point(px(0.0), px(1.0))
        );
    }

    #[test]
    fn test_cursor_preserves_existing_visual_order_splitting() {
        let line = make_shaped_line("abc", &[(0, 0.0), (2, 10.0), (1, 20.0)], 30.0, &[]);
        let mut cursor = line.cursor();
        let mut remainder = line.clone();
        let mut previous_boundary = 0;
        for boundary in [0, 1, 2, 3] {
            let (expected, rest) = remainder.split_at(boundary - previous_boundary);
            let actual = cursor.take_until(boundary);
            assert_eq!(actual.text, expected.text);
            assert_eq!(actual.width(), expected.width());
            assert_eq!(actual.runs.len(), expected.runs.len());
            for (actual, expected) in actual.runs.iter().zip(&expected.runs) {
                assert_eq!(actual.font_id, expected.font_id);
                assert_eq!(actual.glyphs.len(), expected.glyphs.len());
                for (actual, expected) in actual.glyphs.iter().zip(&expected.glyphs) {
                    assert_eq!(actual.id, expected.id);
                    assert_eq!(actual.index, expected.index);
                    assert_eq!(actual.position, expected.position);
                }
            }
            assert_eq!(cursor.x_offset(), line.x_for_index(boundary));
            remainder = rest;
            previous_boundary = boundary;
        }
    }

    #[test]
    fn test_cursor_partitions_one_decoration_across_three_chunks() {
        let line = make_shaped_line(
            "abcdef",
            &[
                (0, 0.0),
                (1, 10.0),
                (2, 20.0),
                (3, 30.0),
                (4, 40.0),
                (5, 50.0),
            ],
            60.0,
            &[DecorationRun {
                len: 6,
                color: Hsla {
                    h: 0.2,
                    s: 0.4,
                    l: 0.6,
                    a: 1.0,
                },
                background_color: None,
                underline: None,
                strikethrough: None,
            }],
        );
        let mut cursor = line.cursor();
        assert_eq!(cursor.take_until(2).decoration_runs[0].len, 2);
        assert_eq!(cursor.take_until(4).decoration_runs[0].len, 2);
        assert_eq!(cursor.take_until(6).decoration_runs[0].len, 2);
    }

    #[test]
    fn test_cursor_matches_successive_splits_at_ordered_boundaries() {
        let decorations: Vec<_> = [2, 0, 3, 1]
            .into_iter()
            .map(|len| DecorationRun {
                len,
                color: Hsla {
                    h: len as f32 / 10.0,
                    s: 0.5,
                    l: 0.5,
                    a: 1.0,
                },
                background_color: Some(black()),
                underline: None,
                strikethrough: None,
            })
            .collect();
        let line = make_shaped_line(
            "abcdef",
            &[(0, 5.0), (0, 5.0), (2, 15.0), (4, 25.0), (5, 35.0)],
            45.0,
            &decorations,
        );
        for first in 0..=line.len() {
            for second in first..=line.len() {
                let mut cursor = line.cursor();
                let mut remainder = line.clone();
                let mut previous_boundary = 0;
                let mut total_width = px(0.0);
                let mut text = String::new();
                for boundary in [first, second, line.len(), line.len()] {
                    let (expected, rest) = remainder.split_at(boundary - previous_boundary);
                    let actual = cursor.take_until(boundary);
                    assert_eq!(actual.text, expected.text);
                    assert_eq!(actual.len(), expected.len());
                    assert_eq!(actual.width(), expected.width());
                    assert_eq!(actual.runs.len(), expected.runs.len());
                    for (actual, expected) in actual.runs.iter().zip(&expected.runs) {
                        assert_eq!(actual.font_id, expected.font_id);
                        assert_eq!(actual.glyphs.len(), expected.glyphs.len());
                        for (actual, expected) in actual.glyphs.iter().zip(&expected.glyphs) {
                            assert_eq!(actual.id, expected.id);
                            assert_eq!(actual.index, expected.index);
                            assert_eq!(actual.position, expected.position);
                        }
                    }
                    assert_eq!(actual.decoration_runs.len(), expected.decoration_runs.len());
                    for (actual, expected) in
                        actual.decoration_runs.iter().zip(&expected.decoration_runs)
                    {
                        assert_eq!(actual.len, expected.len);
                        assert_eq!(actual.color, expected.color);
                        assert_eq!(actual.background_color, expected.background_color);
                    }
                    total_width += actual.width();
                    text.push_str(&actual.text);
                    remainder = rest;
                    previous_boundary = boundary;
                }
                assert_eq!(total_width, line.width());
                assert_eq!(text, line.text.as_ref());
            }
        }
    }

    #[test]
    fn test_cursor_empty_chunks_and_repeated_boundaries() {
        let line = make_shaped_line("ab", &[(0, 5.0), (1, 15.0)], 20.0, &[]);
        let mut cursor = line.cursor();
        assert_eq!(cursor.take_until(0).text.as_ref(), "");
        assert_eq!(cursor.take_until(0).text.as_ref(), "");
        assert_eq!(cursor.take_until(1).text.as_ref(), "a");
        assert_eq!(cursor.take_until(2).text.as_ref(), "b");
        assert_eq!(cursor.take_until(2).text.as_ref(), "");
        let empty = make_shaped_line("", &[], 0.0, &[]);
        let piece = empty.cursor().take_until(0);
        assert!(piece.text.is_empty());
        assert!(piece.runs.is_empty());
        assert_eq!(piece.width(), px(0.0));
    }

    #[test]
    fn test_cursor_rejects_invalid_boundaries() {
        let line = make_shaped_line("é", &[(0, 0.0)], 10.0, &[]);
        let mut cursor = line.cursor();
        assert!(
            std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
                cursor.take_until(1);
            }))
            .is_err()
        );
        let mut cursor = line.cursor();
        cursor.take_until(2);
        assert!(
            std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
                cursor.take_until(0);
            }))
            .is_err()
        );
        let mut cursor = line.cursor();
        assert!(
            std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
                cursor.take_until(3);
            }))
            .is_err()
        );
    }
}
