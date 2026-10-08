//! Ergonomic path construction and lyon tessellation for GPUI scenes.
//!
//! Coordinates and stroke widths are logical [`Pixels`](crate::Pixels). A
//! finished path is scaled to scene pixels when it is painted into a window.
//! Builder transforms apply to the completed path geometry at
//! [`PathBuilder::build`] time, so commands added before and after a transform
//! are transformed together. Building tessellates the path into triangles;
//! handle errors when geometry comes from user input. For examples, see the
//! [drawing walkthrough](https://gpui-ce.github.io/examples/drawing/#paint).

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

/// Tessellation style used by a [`PathBuilder`].
///
/// Fill and stroke options are passed to lyon when [`PathBuilder::build`] runs.
pub enum PathStyle {
    /// Stroke the path with these options.
    Stroke(StrokeOptions),
    /// Fill the path with these options.
    Fill(FillOptions),
}

/// Build filled or stroked contours, then tessellate them into a [`Path`].
///
/// Begin each contour with [`move_to`](Self::move_to), add line or curve
/// segments, and consume the builder with [`build`](Self::build). Coordinates
/// are logical pixels. Paint the result with [`Window::paint_path`](crate::Window::paint_path).
/// See the [drawing chapter](crate::_documentation::drawing) for coordinate,
/// clipping, and caching choices.
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
    /// The tessellation style used when [`PathBuilder::build`] is called.
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
    /// The width is used during tessellation. A later window scale also scales
    /// the resulting path geometry when it is painted.
    pub fn stroke(width: Pixels) -> Self {
        Self {
            style: PathStyle::Stroke(StrokeOptions::default().with_line_width(width.0)),
            ..Self::default()
        }
    }

    /// Creates a fill builder with lyon's default [`FillOptions`].
    pub fn fill() -> Self {
        Self::default()
    }

    /// Replaces the fill or stroke options used by [`Self::build`].
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

    /// Move the current point to the given point.
    #[inline]
    pub fn move_to(&mut self, to: Point<Pixels>) {
        self.raw.move_to(to.into());
    }

    /// Draw a straight line from the current point to the given point.
    #[inline]
    pub fn line_to(&mut self, to: Point<Pixels>) {
        self.raw.line_to(to.into());
    }

    /// Adds a quadratic Bézier segment to `to` using `ctrl` as its control point.
    #[inline]
    pub fn curve_to(&mut self, to: Point<Pixels>, ctrl: Point<Pixels>) {
        self.raw.quadratic_bezier_to(ctrl.into(), to.into());
    }

    /// Adds a cubic Bézier segment to `to` using `control_a` and `control_b`.
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
    /// degrees, despite using the [`Pixels`] wrapper for compatibility with
    /// lyon's SVG path builder. `large_arc` selects the larger candidate arc;
    /// `sweep` selects its direction.
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
    pub fn add_polygon(&mut self, points: &[Point<Pixels>], closed: bool) {
        let points = points.iter().copied().map(|p| p.into()).collect::<Vec<_>>();
        self.raw.add_polygon(Polygon {
            points: points.as_ref(),
            closed,
        });
    }

    /// Closes the current sub-path by connecting it back to its start point.
    #[inline]
    pub fn close(&mut self) {
        self.raw.close();
    }

    /// Replaces the transform applied to the path geometry during [`Self::build`].
    ///
    /// This sets the transform; it does not transform only the commands that
    /// have already been added.
    #[inline]
    pub fn transform(&mut self, transform: Transform) {
        self.transform = Some(transform);
    }

    /// Adds a translation to the transform applied during [`Self::build`].
    #[inline]
    pub fn translate(&mut self, to: Point<Pixels>) {
        if let Some(transform) = self.transform {
            self.transform = Some(transform.then_translate(Vector2D::new(to.x.0, to.y.0)));
        } else {
            self.transform = Some(Transform::translation(to.x.0, to.y.0))
        }
    }

    /// Append a uniform scale to the path geometry's transform.
    ///
    /// Geometry is transformed before stroking. This does not multiply the
    /// configured stroke width or dash lengths; the window's display scale
    /// later scales the entire tessellated result.
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
    /// Fill paths use [`FillOptions`]; stroke paths use [`StrokeOptions`] and
    /// any dash array set on the builder. Dash lengths should be positive.
    /// The returned path is still in logical pixels; a window painting method
    /// converts it to scene space.
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
    /// Each index triple becomes one triangle. The vertex buffer's index list
    /// must therefore contain complete triangles; any trailing one or two
    /// indices are ignored.
    ///
    /// Panics if a complete triangle references a missing vertex. Prefer
    /// [`Self::build`] when the buffers did not come from a trusted tessellator.
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
