//! Lines, curves, and arcs tessellated for the GPUI renderer.
//!
//! Coordinates and stroke widths are logical [`Pixels`](crate::Pixels). A
//! finished path is scaled to scene pixels when it is painted into a window.
//! Builder transforms apply to the completed path geometry at
//! [`PathBuilder::build`] time, so commands added before and after a transform
//! are transformed together. Building tessellates the path into triangles;
//! handle errors when geometry comes from user input. See the
//! [drawing chapter](crate::_documentation::drawing#prepare-a-path-once-when-its-geometry-is-stable)
//! for placement, clipping, and reuse.

use anyhow::Error;
use etagere::euclid::{Point2D, Vector2D};
use lyon::geom::Angle;
use lyon::math::{Vector, vector};
use lyon::path::traits::SvgPathBuilder;
use lyon::path::{ArcFlags, Polygon};
use lyon::tessellation::{
    BuffersBuilder, FillTessellator, FillVertex, StrokeTessellator, StrokeVertex, VertexBuffers,
};

pub use lyon::math::Transform;
pub use lyon::tessellation::{FillOptions, FillRule, StrokeOptions};

use crate::{Path, Pixels, Point, point, px};

/// Chooses whether a [`PathBuilder`] fills its contours or strokes their edges.
///
/// This controls geometry, not color. Supply the paint separately to
/// [`Window::paint_path`](crate::Window::paint_path). A builder uses one style
/// for all its contours; build two paths to fill and outline the same shape.
pub enum PathStyle {
    /// Tessellates edges with a width, end caps, and joins from [`StrokeOptions`].
    Stroke(StrokeOptions),
    /// Tessellates interiors according to [`FillOptions`], including its [`FillRule`].
    Fill(FillOptions),
}

/// Builds filled or stroked vector geometry for [`Window::paint_path`](crate::Window::paint_path).
///
/// A *contour* is one connected sequence of segments. Start it with
/// [`move_to`](Self::move_to), add lines or curves, and call [`close`](Self::close)
/// to join its end to its beginning. Another `move_to` starts a separate contour
/// in the same path. [`build`](Self::build) consumes the builder and
/// [tessellates](https://en.wikipedia.org/wiki/Tessellation_(computer_graphics))
/// the geometry into triangles. Keep that result when the geometry is stable;
/// changing its paint does not require tessellating it again.
///
/// Coordinates and stroke widths use logical [`Pixels`]. For a shape authored
/// relative to a canvas, [`translate`](Self::translate) by the canvas's
/// `bounds.origin` before building. Window painting expects window-local
/// coordinates and applies the display scale itself. See the
/// [drawing chapter](crate::_documentation::drawing#prepare-a-path-once-when-its-geometry-is-stable)
/// for clipping and caching choices.
///
/// ```rust
/// use gpui::{PathBuilder, point, px};
/// let mut outline = PathBuilder::stroke(px(2.));
/// outline.move_to(point(px(0.), px(0.)));
/// outline.line_to(point(px(40.), px(0.)));
/// outline.line_to(point(px(20.), px(24.)));
/// outline.close();
/// let path = outline.build()?;
/// assert!(!path.vertices.is_empty());
/// # Ok::<(), anyhow::Error>(())
/// ```
pub struct PathBuilder {
    raw: lyon::path::builder::WithSvg<lyon::path::BuilderImpl>,
    transform: Option<lyon::math::Transform>,
    /// Fill or stroke options for all contours when [`build`](Self::build) runs.
    /// Changing this does not discard the commands already added.
    pub style: PathStyle,
    dash_array: Option<Vec<Pixels>>,
}

impl From<lyon::path::Builder> for PathBuilder {
    fn from(builder: lyon::path::Builder) -> Self {
        Self {
            raw: builder.with_svg(),
            ..Default::default()
        }
    }
}

impl From<lyon::path::builder::WithSvg<lyon::path::BuilderImpl>> for PathBuilder {
    fn from(raw: lyon::path::builder::WithSvg<lyon::path::BuilderImpl>) -> Self {
        Self {
            raw,
            ..Default::default()
        }
    }
}

impl From<lyon::math::Point> for Point<Pixels> {
    fn from(p: lyon::math::Point) -> Self {
        point(px(p.x), px(p.y))
    }
}

impl From<Point<Pixels>> for lyon::math::Point {
    fn from(p: Point<Pixels>) -> Self {
        lyon::math::point(p.x.0, p.y.0)
    }
}

impl From<Point<Pixels>> for Vector {
    fn from(p: Point<Pixels>) -> Self {
        vector(p.x.0, p.y.0)
    }
}

impl From<Point<Pixels>> for Point2D<f32, Pixels> {
    fn from(p: Point<Pixels>) -> Self {
        Point2D::new(p.x.0, p.y.0)
    }
}

impl Default for PathBuilder {
    fn default() -> Self {
        Self {
            raw: lyon::path::Path::builder().with_svg(),
            style: PathStyle::Fill(FillOptions::default()),
            transform: None,
            dash_array: None,
        }
    }
}

impl PathBuilder {
    /// Creates a stroke builder with `width` in logical pixels.
    ///
    /// The defaults use butt end caps and miter joins. Use [`with_style`](Self::with_style)
    /// with [`StrokeOptions`] to change them. A builder transform changes the
    /// contour before stroking and leaves this width unchanged; the window's
    /// display scale later scales the complete tessellated result.
    pub fn stroke(width: Pixels) -> Self {
        Self {
            style: PathStyle::Stroke(StrokeOptions::default().with_line_width(width.0)),
            ..Self::default()
        }
    }

    /// Creates a fill builder with lyon's default [`FillOptions`].
    ///
    /// This is also the default builder. Its [`FillRule::EvenOdd`] rule leaves
    /// a hole where two nested contours overlap, regardless of their direction.
    /// Use [`with_style`](Self::with_style) to choose [`FillRule::NonZero`] instead.
    pub fn fill() -> Self {
        Self::default()
    }

    /// Replaces the fill or stroke options used by [`Self::build`].
    ///
    /// This applies to every contour, including those already added. It
    /// replaces the entire style: a new [`StrokeOptions`] value supplies its
    /// own line width rather than preserving a preceding `stroke(width)`.
    /// Here two nested contours run in the same direction. The nonzero rule
    /// fills the center; the default even-odd rule would leave a hole:
    ///
    /// ```
    /// use gpui::{FillOptions, PathBuilder, PathStyle, point, px};
    ///
    /// let mut shape = PathBuilder::fill()
    ///     .with_style(PathStyle::Fill(FillOptions::non_zero()));
    /// shape.add_polygon(&[
    ///     point(px(0.), px(0.)),
    ///     point(px(32.), px(0.)),
    ///     point(px(32.), px(32.)),
    ///     point(px(0.), px(32.)),
    /// ], true);
    /// shape.add_polygon(&[
    ///     point(px(8.), px(8.)),
    ///     point(px(24.), px(8.)),
    ///     point(px(24.), px(24.)),
    ///     point(px(8.), px(24.)),
    /// ], true);
    /// let path = shape.build()?;
    /// assert!(!path.vertices.is_empty());
    /// # Ok::<(), anyhow::Error>(())
    /// ```
    pub fn with_style(self, style: PathStyle) -> Self {
        Self { style, ..self }
    }

    /// Sets the repeating on/off lengths for a stroked path, in logical pixels.
    ///
    /// The slice must be non-empty and contain only positive lengths. If it has
    /// an odd number of values, the full sequence is repeated so each pattern
    /// has an even number of on/off entries. This setting is used only for
    /// strokes. [`Self::build`] returns an error for an empty pattern,
    /// non-finite or non-positive lengths, or lengths too small to advance
    /// along the measured path. The pattern runs across the measured path;
    /// this is not a complete implementation of SVG stroke semantics.
    ///
    /// See the [SVG stroke-dasharray reference](https://developer.mozilla.org/en-US/docs/Web/SVG/Reference/Attribute/stroke-dasharray).
    ///
    /// ```
    /// use gpui::{PathBuilder, point, px};
    ///
    /// // Four pixels of stroke, then two pixels of gap, repeated along the line.
    /// let mut line = PathBuilder::stroke(px(1.)).dash_array(&[px(4.), px(2.)]);
    /// line.move_to(point(px(0.), px(0.)));
    /// line.line_to(point(px(24.), px(0.)));
    /// assert!(!line.build()?.vertices.is_empty());
    ///
    /// // Use stroke(width), without dash_array, for a solid line.
    /// assert!(PathBuilder::stroke(px(1.)).dash_array(&[]).build().is_err());
    /// # Ok::<(), anyhow::Error>(())
    /// ```
    pub fn dash_array(mut self, dash_array: &[Pixels]) -> Self {
        // If an odd number of values is provided, then the list of values is repeated to yield an even number of values.
        // Thus, 5,3,2 is equivalent to 5,3,2,5,3,2.
        let array = if dash_array.len() % 2 == 1 {
            let mut new_dash_array = dash_array.to_vec();
            new_dash_array.extend_from_slice(dash_array);
            new_dash_array
        } else {
            dash_array.to_vec()
        };

        self.dash_array = Some(array);
        self
    }

    /// Starts a contour at `to` without drawing a connecting segment.
    ///
    /// If another contour is open, it ends without being closed. Call
    /// [`close`](Self::close) first when its stroke should form a closed loop.
    #[inline]
    pub fn move_to(&mut self, to: Point<Pixels>) {
        self.raw.move_to(to.into());
    }

    /// Adds a straight segment to `to` and makes it the current point.
    ///
    /// Start a contour with [`move_to`](Self::move_to). If this is the first
    /// command, lyon moves to `to` without adding a segment.
    #[inline]
    pub fn line_to(&mut self, to: Point<Pixels>) {
        self.raw.line_to(to.into());
    }

    /// Adds a quadratic Bézier segment to `to` using `ctrl` as its control point.
    ///
    /// The start is the current point; the control point pulls the curve but
    /// need not lie on it. The endpoint comes **first** in this API, before the
    /// control point. Both are absolute coordinates in the builder's space:
    ///
    /// ```
    /// use gpui::{PathBuilder, point, px};
    ///
    /// let mut curve = PathBuilder::stroke(px(2.));
    /// curve.move_to(point(px(0.), px(12.)));
    /// curve.curve_to(point(px(48.), px(12.)), point(px(24.), px(-12.)));
    /// let path = curve.build()?;
    /// assert!(!path.vertices.is_empty());
    /// # Ok::<(), anyhow::Error>(())
    /// ```
    ///
    /// The curve rises from `(0, 12)` to `(24, 0)` and returns to `(48, 12)`.
    /// See [Bézier curves](https://en.wikipedia.org/wiki/B%C3%A9zier_curve)
    /// for the relationship between endpoints, control points, and tangents.
    #[inline]
    pub fn curve_to(&mut self, to: Point<Pixels>, ctrl: Point<Pixels>) {
        self.raw.quadratic_bezier_to(ctrl.into(), to.into());
    }

    /// Adds a cubic Bézier segment to `to` using `control_a` and `control_b`.
    ///
    /// `control_a` determines the tangent leaving the current point;
    /// `control_b` determines the tangent arriving at `to`. All three arguments
    /// are absolute coordinates, with the endpoint first. Unlike
    /// [`curve_to`](Self::curve_to), the two ends can have independent tangent
    /// directions. `to` becomes the current point for the next segment.
    #[inline]
    pub fn cubic_bezier_to(
        &mut self,
        to: Point<Pixels>,
        control_a: Point<Pixels>,
        control_b: Point<Pixels>,
    ) {
        self.raw
            .cubic_bezier_to(control_a.into(), control_b.into(), to.into());
    }

    /// Adds an elliptical arc from the current point to `to`.
    ///
    /// `radii` and `to` are in logical pixels. `x_rotation` is interpreted as
    /// degrees, despite using the [`Pixels`] wrapper. It rotates the ellipse,
    /// rather than setting the arc's starting angle. With two endpoints and
    /// two radii, several arcs are possible:
    ///
    /// - `large_arc = false` selects a sweep of at most half a turn; `true`
    ///   selects at least half a turn.
    /// - `sweep = true` follows increasing angles: clockwise in an untransformed
    ///   GPUI window, where y grows downward. `false` follows the other direction.
    ///
    /// Begin with [`move_to`](Self::move_to). For a circle, use equal radii;
    /// the rotation then has no effect. This draws the upper semicircle from
    /// its leftmost to its rightmost point:
    ///
    /// ```
    /// use gpui::{PathBuilder, point, px};
    ///
    /// let mut arc = PathBuilder::stroke(px(2.));
    /// arc.move_to(point(px(0.), px(20.)));
    /// arc.arc_to(point(px(20.), px(20.)), px(0.), false, true,
    ///            point(px(40.), px(20.)));
    /// let path = arc.build()?;
    /// assert!(!path.vertices.is_empty());
    /// assert!(path.bounds.origin.y < px(0.)); // The stroke reaches above its center.
    /// # Ok::<(), anyhow::Error>(())
    /// ```
    ///
    /// Lyon uses the absolute radii and enlarges them when needed to connect
    /// the endpoints. A zero radius produces a line. Equal endpoints do not
    /// produce a full circle; use two arcs. See the
    /// [SVG arc diagrams](https://www.w3.org/TR/SVG/paths.html#PathDataEllipticalArcCommands).
    pub fn arc_to(
        &mut self,
        radii: Point<Pixels>,
        x_rotation: Pixels,
        large_arc: bool,
        sweep: bool,
        to: Point<Pixels>,
    ) {
        self.raw.arc_to(
            radii.into(),
            Angle::degrees(x_rotation.into()),
            ArcFlags { large_arc, sweep },
            to.into(),
        );
    }

    /// Adds an elliptical arc using an endpoint relative to the current point.
    ///
    /// The radii and rotation use the same units and flags as [`Self::arc_to`].
    /// Only `to` changes meaning: it is an offset, not an absolute endpoint.
    /// From `(10, 20)`, `to = point(px(30.), px(0.))` ends at `(40, 20)`.
    pub fn relative_arc_to(
        &mut self,
        radii: Point<Pixels>,
        x_rotation: Pixels,
        large_arc: bool,
        sweep: bool,
        to: Point<Pixels>,
    ) {
        self.raw.relative_arc_to(
            radii.into(),
            Angle::degrees(x_rotation.into()),
            ArcFlags { large_arc, sweep },
            to.into(),
        );
    }

    /// Adds a polygon through `points`, optionally closing its contour.
    ///
    /// The first point starts a new contour; each later point adds a straight
    /// segment. `closed = true` adds the closing edge and joins the stroke's
    /// ends. An empty slice does nothing. Finish any preceding contour first,
    /// and start another with [`move_to`](Self::move_to) when needed.
    pub fn add_polygon(&mut self, points: &[Point<Pixels>], closed: bool) {
        let points = points.iter().copied().map(|p| p.into()).collect::<Vec<_>>();
        self.raw.add_polygon(Polygon {
            points: points.as_ref(),
            closed,
        });
    }

    /// Closes the current sub-path by connecting it back to its start point.
    ///
    /// For a stroke, this joins the last edge to the first. Merely calling
    /// [`line_to`](Self::line_to) with the start point leaves two separately
    /// capped ends. A later [`move_to`](Self::move_to) starts another contour.
    #[inline]
    pub fn close(&mut self) {
        self.raw.close();
    }

    /// Replaces the transform applied to the path geometry during [`Self::build`].
    ///
    /// This discards any preceding transform calls and applies to all
    /// commands, including those added afterward. The transform acts before
    /// tessellation, so stroke widths and dash lengths remain unchanged.
    /// Use [`translate`](Self::translate), [`scale`](Self::scale), and
    /// [`rotate`](Self::rotate) to append operations in call order instead.
    #[inline]
    pub fn transform(&mut self, transform: Transform) {
        self.transform = Some(transform);
    }

    /// Adds a translation to the transform applied during [`Self::build`].
    ///
    /// `to` is an offset in logical pixels. Translate by a canvas's
    /// `bounds.origin` to place locally authored geometry in the window.
    /// A later [`scale`](Self::scale) or [`rotate`](Self::rotate) also acts on
    /// this translation; apply translation last to keep the offset unchanged.
    #[inline]
    pub fn translate(&mut self, to: Point<Pixels>) {
        if let Some(transform) = self.transform {
            self.transform = Some(transform.then_translate(Vector2D::new(to.x.0, to.y.0)));
        } else {
            self.transform = Some(Transform::translation(to.x.0, to.y.0))
        }
    }

    /// Appends a uniform scale about the origin to the geometry's transform.
    ///
    /// Geometry is transformed before stroking. This does not multiply the
    /// configured stroke width or dash lengths; the window's display scale
    /// later scales the entire tessellated result.
    ///
    /// Operations act in call order. Here the ten-pixel triangle becomes
    /// twenty pixels wide, then moves forty pixels right:
    ///
    /// ```
    /// use gpui::{PathBuilder, point, px, size};
    ///
    /// let mut shape = PathBuilder::fill();
    /// shape.add_polygon(&[
    ///     point(px(0.), px(0.)),
    ///     point(px(10.), px(0.)),
    ///     point(px(0.), px(10.)),
    /// ], true);
    /// shape.scale(2.);
    /// shape.translate(point(px(40.), px(0.)));
    /// let path = shape.build()?;
    /// assert_eq!(path.bounds.origin, point(px(40.), px(0.)));
    /// assert_eq!(path.bounds.size, size(px(20.), px(20.)));
    /// # Ok::<(), anyhow::Error>(())
    /// ```
    ///
    /// Reverse those calls and the translation is scaled too: the left edge
    /// becomes eighty pixels from the origin.
    #[inline]
    pub fn scale(&mut self, scale: f32) {
        if let Some(transform) = self.transform {
            self.transform = Some(transform.then_scale(scale, scale));
        } else {
            self.transform = Some(Transform::scale(scale, scale));
        }
    }

    /// Adds a rotation to the transform applied during [`Self::build`].
    ///
    /// `angle` is in degrees. Values outside one full turn are accepted and
    /// have the same rotational effect modulo 360 degrees.
    /// Rotation is about the origin; positive angles turn clockwise in an
    /// untransformed GPUI window. To rotate about a point, translate it to the
    /// origin, rotate, then translate back. Each operation affects the whole
    /// path at build time, regardless of where it appears among drawing commands.
    #[inline]
    pub fn rotate(&mut self, angle: f32) {
        let radians = angle.to_radians();
        if let Some(transform) = self.transform {
            self.transform = Some(transform.then_rotate(Angle::radians(radians)));
        } else {
            self.transform = Some(Transform::rotation(Angle::radians(radians)));
        }
    }

    /// Tessellates the path into a triangle-based [`Path`].
    ///
    /// Applies the accumulated transform, then uses the current [`PathStyle`]
    /// for every contour. A fill ignores any dash pattern; a stroke validates
    /// and applies it. The returned path is still in logical pixels. Its
    /// bounds cover the tessellated geometry, including a stroke's thickness.
    /// Painting later supplies color, clipping, and display scale.
    ///
    /// # Errors
    ///
    /// Returns an error when lyon cannot tessellate the path or a stroke's
    /// dash pattern is invalid. Builder commands are not a general validator
    /// for arbitrary floating-point geometry; supply finite coordinates and
    /// sensible tessellation options.
    #[inline]
    pub fn build(self) -> Result<Path<Pixels>, Error> {
        let path = if let Some(transform) = self.transform {
            self.raw.build().transformed(&transform)
        } else {
            self.raw.build()
        };

        match self.style {
            PathStyle::Stroke(options) => Self::tessellate_stroke(self.dash_array, &path, &options),
            PathStyle::Fill(options) => Self::tessellate_fill(&path, &options),
        }
    }

    fn tessellate_fill(
        path: &lyon::path::Path,
        options: &FillOptions,
    ) -> Result<Path<Pixels>, Error> {
        // Will contain the result of the tessellation.
        let mut buf: VertexBuffers<lyon::math::Point, u16> = VertexBuffers::new();
        let mut tessellator = FillTessellator::new();

        // Compute the tessellation.
        tessellator.tessellate_path(
            path,
            options,
            &mut BuffersBuilder::new(&mut buf, |vertex: FillVertex| vertex.position()),
        )?;

        Ok(Self::build_path(buf))
    }

    fn tessellate_stroke(
        dash_array: Option<Vec<Pixels>>,
        path: &lyon::path::Path,
        options: &StrokeOptions,
    ) -> Result<Path<Pixels>, Error> {
        let path = if let Some(dash_array) = dash_array {
            anyhow::ensure!(
                !dash_array.is_empty()
                    && dash_array
                        .iter()
                        .all(|length| length.0.is_finite() && length.0 > 0.),
                "dash lengths must be finite, positive, and non-empty"
            );
            let measurements = lyon::algorithms::measure::PathMeasurements::from_path(path, 0.01);
            let mut sampler = measurements
                .create_sampler(path, lyon::algorithms::measure::SampleType::Normalized);
            let mut builder = lyon::path::Path::builder();

            let total_length = sampler.length();
            let dash_array_len = dash_array.len();
            let mut pos = 0.;
            let mut dash_index = 0;
            while pos < total_length {
                let dash_length = dash_array[dash_index % dash_array_len].0;
                let next_pos = (pos + dash_length).min(total_length);
                anyhow::ensure!(
                    next_pos > pos,
                    "dash length is too small to advance along the path"
                );
                if dash_index % 2 == 0 {
                    let start = pos / total_length;
                    let end = next_pos / total_length;
                    sampler.split_range(start..end, &mut builder);
                }
                pos = next_pos;
                dash_index += 1;
            }

            &builder.build()
        } else {
            path
        };

        // Will contain the result of the tessellation.
        let mut buf: VertexBuffers<lyon::math::Point, u16> = VertexBuffers::new();
        let mut tessellator = StrokeTessellator::new();

        // Compute the tessellation.
        tessellator.tessellate_path(
            path,
            options,
            &mut BuffersBuilder::new(&mut buf, |vertex: StrokeVertex| vertex.position()),
        )?;

        Ok(Self::build_path(buf))
    }

    /// Builds a [`Path`] from lyon's tessellated triangle buffers.
    ///
    /// Use this to adapt tessellated, filled triangles from another geometry
    /// routine. Positions must already be in logical pixels; this method
    /// applies no builder transform, stroke options, or dash pattern. Each
    /// index triple becomes one filled triangle. Any trailing one or two
    /// indices are ignored, and an empty vertex list yields an empty path at
    /// the origin. Supply color and clipping when painting the result.
    ///
    /// # Panics
    ///
    /// Panics if a complete triangle references a missing vertex in a nonempty
    /// buffer. Validate external indices before calling. Use [`build`](Self::build)
    /// for ordinary line and curve commands instead.
    pub fn build_path(buf: VertexBuffers<lyon::math::Point, u16>) -> Path<Pixels> {
        if buf.vertices.is_empty() {
            return Path::new(Point::default());
        }

        let first_point = buf.vertices[0];

        let mut path = Path::new(first_point.into());
        for i in 0..buf.indices.len() / 3 {
            let i0 = buf.indices[i * 3] as usize;
            let i1 = buf.indices[i * 3 + 1] as usize;
            let i2 = buf.indices[i * 3 + 2] as usize;

            let v0 = buf.vertices[i0];
            let v1 = buf.vertices[i1];
            let v2 = buf.vertices[i2];

            path.push_triangle(
                (v0.into(), v1.into(), v2.into()),
                (point(0., 1.), point(0., 1.), point(0., 1.)),
            );
        }

        path
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn invalid_dash_patterns_return_errors() {
        for pattern in [
            vec![],
            vec![px(0.)],
            vec![px(-1.)],
            vec![px(f32::NAN)],
            vec![px(f32::INFINITY)],
        ] {
            let mut builder = PathBuilder::stroke(px(1.)).dash_array(&pattern);
            builder.move_to(point(px(0.), px(0.)));
            builder.line_to(point(px(10.), px(0.)));
            assert!(builder.build().is_err(), "accepted {pattern:?}");
        }
    }

    #[test]
    fn dash_pattern_must_advance_in_floating_point() {
        let mut builder = PathBuilder::stroke(px(1.)).dash_array(&[px(1.), px(f32::MIN_POSITIVE)]);
        builder.move_to(point(px(0.), px(0.)));
        builder.line_to(point(px(10.), px(0.)));
        assert!(builder.build().is_err());
    }
}
