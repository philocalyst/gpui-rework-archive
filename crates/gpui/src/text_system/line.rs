use crate::{
    App, Bounds, InlineLayout, LineLayout, PaintFragment, Pixels, Point, Result, ShapedTextLayout,
    SharedString, TextAlign, TextSystem, VisualLine, Window, fill, point, size,
};
use derive_more::{Deref, DerefMut};
use std::sync::{
    Arc,
    atomic::{AtomicUsize, Ordering},
};

static GLYPH_PAINT_ERRORS: AtomicUsize = AtomicUsize::new(0);
const MAX_LOGGED_GLYPH_PAINT_ERRORS: usize = 20;

/// One unwrapped line, with resolved glyphs, styles, and interaction geometry.
///
/// Obtain it from [`crate::WindowTextSystem::shape_line`] when custom drawing
/// needs a label's width or direct control over painting. Use [`ShapedText`]
/// for hard breaks or wrapping, and [`crate::Text`] for an ordinary element
/// that should measure and paint itself.
///
/// Shaping selects glyphs and their advances; it does not rasterize them.
/// [`Self::width`] is the advance width, including spacing, rather than the
/// rectangle enclosing the visible ink. The dereferenced layout's
/// [`LineLayout::platform_layout`] supplies byte-index and position queries
/// for this same source string.
/// Retain that layout when pointer handling must agree with the painted text.
/// See the [text chapter](crate::_documentation::text) for source positions,
/// visual order, and caret affinity.
#[derive(Clone, Debug, Deref, DerefMut)]
pub struct ShapedLine {
    #[deref]
    #[deref_mut]
    pub(crate) layout: Arc<LineLayout>,
    /// The source text paired with this layout.
    ///
    /// Changing this field does not reshape the glyphs or update byte indices. To change the
    /// line, obtain a new [`ShapedLine`] from [`crate::WindowTextSystem::shape_line`].
    pub text: SharedString,
}

impl ShapedLine {
    /// Return the source length recorded by shaping, in UTF-8 bytes.
    ///
    /// This counts neither characters nor glyphs. It reads the layout, so
    /// assigning a different string to [`Self::text`] does not change it.
    #[allow(clippy::len_without_is_empty)]
    pub fn len(&self) -> usize {
        self.layout.len
    }

    /// Return the line's advance width in logical pixels.
    ///
    /// This is the glyph advance width computed by the text shaping system and is useful for
    /// allocating space for the label. It is not the width of its visible ink.
    /// Shape a whole string together when kerning or ligatures can span what
    /// would otherwise be separate fragments.
    pub fn width(&self) -> Pixels {
        self.layout.width
    }

    /// Paint glyphs, underlines, and strikethroughs into the current scene.
    ///
    /// `line_height` sets the row's vertical extent and baseline placement. `align_width` gives
    /// the width used for alignment; if it is `None`, the shaped advance width is used. Call
    /// [`Self::paint_background`] first when the run backgrounds should appear behind the text.
    /// `origin` is the row box's top-left in window-local logical pixels,
    /// rather than its baseline. Alignment moves the glyphs within
    /// `align_width`; it neither wraps the line nor clips it. Use
    /// [`Window::with_content_mask`] when drawing must stop at an edge.
    ///
    /// Call during an element's paint phase. Individual glyph-rasterization
    /// or atlas errors are logged and that glyph is skipped; an `Ok` result
    /// therefore does not establish that every glyph was drawn. Painting
    /// registers no input handlers or accessibility nodes.
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

    /// Paint run background rectangles for this line.
    ///
    /// Each run's background spans its horizontal fragment and the supplied
    /// `line_height`. Runs without a background color draw nothing in this
    /// pass. Call it before [`Self::paint`], using the same origin, height,
    /// alignment, and alignment width, so the rectangles sit behind the glyphs.
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

/// A shaped document whose visual rows can be painted and queried together.
///
/// Obtain it from [`crate::WindowTextSystem::shape_text`] or
/// [`crate::WindowTextSystem::shape_text_with_options`]. Hard line breaks,
/// optional soft wrapping, font fallback, and bidirectional ordering are
/// resolved in one layout. Its dereferenced [`ShapedTextLayout`] supplies
/// measurement, caret movement, hit testing, and selection rectangles.
/// Those queries address UTF-8 byte offsets in the string that was shaped.
///
/// Use the same layout for drawing and interaction. A caret calculated with
/// another wrap width or line height will disagree with the displayed rows.
/// Rebuild the layout when its text, fonts, or layout options change; calling
/// [`Self::paint`] with different bounds does not reshape it. See the
/// [text chapter](crate::_documentation::text) for choosing between text
/// elements and custom text drawing.
#[derive(Debug, Deref, DerefMut)]
pub struct ShapedText {
    #[deref]
    #[deref_mut]
    pub(crate) layout: Arc<ShapedTextLayout>,
    /// The source text paired with this layout.
    ///
    /// Changing this field does not reshape the glyphs or update byte indices. To change the
    /// document, obtain a new [`ShapedText`] from [`crate::WindowTextSystem::shape_text`].
    pub text: SharedString,
}

impl ShapedText {
    /// Return the UTF-8 source length recorded by this layout.
    ///
    /// Hard-break bytes remain part of that length. Visual row counts and
    /// glyph counts are separate quantities.
    #[allow(clippy::len_without_is_empty)]
    pub fn len(&self) -> usize {
        self.layout.len()
    }

    /// Paint the laid-out rows, glyphs, underlines, and strikethroughs.
    ///
    /// `line_height` determines each visual row's height. `bounds`, when supplied, contributes
    /// its width for horizontal alignment; otherwise the wrap width is used when the text was
    /// shaped with one. The bounds origin is not applied: `origin` remains the placement point.
    /// `origin` is the first row box's top-left in window-local logical
    /// pixels. The rows retain the breaks established during shaping;
    /// changing `bounds` changes alignment space, not wrapping or clipping.
    /// `TextAlign::Start` and `End` follow each row's resolved direction.
    ///
    /// Call [`Self::paint_background`] first for run backgrounds, with the
    /// same placement parameters. Individual glyph-rasterization or atlas
    /// errors are logged and that glyph is skipped, so `Ok` does not prove
    /// that every glyph was drawn. Call during paint; this creates no input
    /// handlers or accessibility nodes.
    ///
    /// ```rust
    /// use gpui::{App, Bounds, Pixels, ShapedText, TextAlign, Window, px};
    ///
    /// // `label` was shaped during preparation with this region's width.
    /// fn paint_label(
    ///     label: &ShapedText,
    ///     region: Bounds<Pixels>,
    ///     window: &mut Window,
    ///     cx: &mut App,
    /// ) -> anyhow::Result<()> {
    ///     let line_height = px(24.);
    ///     label.paint_background(
    ///         region.origin, line_height, TextAlign::Start, Some(region), window, cx,
    ///     )?;
    ///     label.paint(
    ///         region.origin, line_height, TextAlign::Start, Some(region), window, cx,
    ///     )
    /// }
    /// ```
    ///
    /// Use [`Window::with_content_mask`] around both passes if the region
    /// must clip text. Supply the same `line_height` to interaction queries
    /// such as [`ShapedTextLayout::closest_caret_for_pixel_point`].
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

    /// Paint the run background rectangles for all visual rows.
    ///
    /// Width selection and row placement match [`Self::paint`]. Call this
    /// first with the same parameters. Each colored run fragment gets a
    /// rectangle with the supplied row height; rows without a run background
    /// draw nothing. The optional `bounds` supplies alignment width, not a clip.
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
    /// Paint the text-run background rectangles in this inline layout.
    ///
    /// The boxes themselves are not painted by this method; use their positioned bounds from
    /// [`InlineLayout::boxes`] to paint the corresponding elements. Call this before [`Self::paint`]
    /// when backgrounds should sit behind text and inline elements.
    pub fn paint_background(
        &self,
        origin: Point<Pixels>,
        window: &mut Window,
        cx: &mut App,
    ) -> Result<()> {
        paint_inline_layout(self, origin, TextPaintPass::Background, window, cx)
    }

    /// Paint glyphs and foreground decorations, using the line and baseline geometry in this
    /// layout. Inline element boxes are positioned here but remain the caller's responsibility to
    /// paint.
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
    // Most platforms leave this lazy iterator untouched. Interpreter bridges
    // use it to prepare visible glyphs in one backend call, then the exact same
    // paint methods below consume the prepared styles and atlas pixels.
    let mut requests = fragment
        .glyphs
        .iter()
        .filter(|glyph| {
            let cull_origin = point(
                context.line_origin.x + glyph.position.x,
                context.line_origin.y,
            );
            Bounds::new(cull_origin, max_glyph_size).intersects(&window.content_mask().bounds)
        })
        .map(|glyph| {
            let origin = point(
                context.line_origin.x + glyph.position.x,
                context.baseline_y + glyph.position.y,
            );
            window
                .glyph_raster_request(
                    origin,
                    fragment.font_id,
                    glyph.id,
                    fragment.font_size,
                    fragment.style.color,
                    glyph.is_emoji,
                )
                .1
        });
    context.text_system.prewarm_glyphs(&mut requests);
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
        window.paint_quad(fill(
            Bounds::new(
                point(range.start, line_origin.y),
                size(range.end - range.start, line_height),
            ),
            color,
        ));
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
}
