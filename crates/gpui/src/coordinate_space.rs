//! Coordinate spaces shared by painting, clipping, input and platform geometry.

use crate::{Bounds, ContentMask, Pixels, Point, Radians, Size, TransformationMatrix, point};
use std::sync::Arc;

const RASTER_BUCKETS_PER_UNIT: f32 = 8.0;
const MAX_RASTER_SCALE: f32 = 8.0;

/// An affine transform applied after layout to an element and its descendants.
///
/// Operations apply in the order written. Translation uses logical pixels; the
/// origin is a fraction of the element's bounds (the top left by default).
/// Layout, including scroll extents, remains in the original coordinate space.
#[derive(Clone, Copy, Debug, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct ElementTransform {
    matrix: TransformationMatrix,
    origin: Point<f32>,
}

impl Default for ElementTransform {
    fn default() -> Self {
        Self {
            matrix: TransformationMatrix::unit(),
            origin: point(0.0, 0.0),
        }
    }
}

impl ElementTransform {
    /// Translates in logical pixels.
    pub fn translate(mut self, offset: Point<Pixels>) -> Self {
        self.matrix.translation[0] += offset.x.0;
        self.matrix.translation[1] += offset.y.0;
        self
    }

    /// Scales uniformly about the origin.
    pub fn scale(self, factor: f32) -> Self {
        self.scale_axes(Size::new(factor, factor))
    }

    /// Scales independently along the two axes. Negative scales reflect content.
    pub fn scale_axes(mut self, factors: Size<f32>) -> Self {
        self.matrix = TransformationMatrix {
            rotation_scale: [[factors.width, 0.0], [0.0, factors.height]],
            translation: [0.0; 2],
        }
        .compose(self.matrix);
        self
    }

    /// Rotates clockwise about the origin.
    pub fn rotate(mut self, angle: Radians) -> Self {
        self.matrix = TransformationMatrix::unit()
            .rotate(angle)
            .compose(self.matrix);
        self
    }

    /// Sets the pivot as a fraction of the element bounds, e.g. `(0.5, 0.5)` for its center.
    pub fn origin(mut self, origin: Point<f32>) -> Self {
        self.origin = origin;
        self
    }

    /// Uses an arbitrary affine matrix expressed in logical pixels.
    pub fn from_matrix(matrix: TransformationMatrix) -> Self {
        Self {
            matrix,
            ..Self::default()
        }
    }

    /// Resolves this transform against the element's untransformed layout bounds.
    pub fn resolve(self, bounds: Bounds<Pixels>) -> TransformationMatrix {
        let pivot = bounds.origin
            + point(
                bounds.size.width * self.origin.x,
                bounds.size.height * self.origin.y,
            );
        let mut matrix = self.matrix;
        matrix.translation[0] += pivot.x.0 - self.matrix.apply_vector(pivot).x.0;
        matrix.translation[1] += pivot.y.0 - self.matrix.apply_vector(pivot).y.0;
        matrix
    }
}

/// The mapping from an element's layout coordinates to the window.
///
/// A space owns its exact ancestor clips. Clones are cheap and can outlive the
/// traversal, so listeners, hitboxes and deferred draws retain the same geometry.
#[derive(Clone, Debug, PartialEq)]
pub struct CoordinateSpace {
    pub(crate) transform: TransformationMatrix,
    inverse: Option<TransformationMatrix>,
    raster_scale: f32,
    pub(crate) clips: Option<Arc<ClipRegion>>,
}

#[derive(Debug, PartialEq)]
pub(crate) struct ClipRegion {
    pub mask: ContentMask<Pixels>,
    pub transform: TransformationMatrix,
    inverse: Option<TransformationMatrix>,
    window_bounds: Bounds<Pixels>,
    pub parent: Option<Arc<ClipRegion>>,
}

impl ClipRegion {
    pub(crate) fn render_inverse(&self, scale: f32) -> Option<TransformationMatrix> {
        self.inverse.map(|inverse| inverse.scaled(scale))
    }

    // A rectangle is convex: its four corners certify full coverage of its
    // entire support. Fades matter even when their hard edge is redundant.
    fn fully_covers(&self, bounds: Bounds<Pixels>, transform: TransformationMatrix) -> bool {
        let Some(inverse) = self.inverse else {
            return false;
        };
        let norm = |matrix: TransformationMatrix| {
            matrix
                .rotation_scale
                .iter()
                .map(|row| row[0].abs() + row[1].abs())
                .fold(0.0f32, f32::max)
        };
        if bounds.is_empty() || norm(self.transform) * norm(inverse) > 4096.0 {
            return false;
        }
        let near = [self.mask.bounds.left().0, self.mask.bounds.top().0];
        let far = [self.mask.bounds.right().0, self.mask.bounds.bottom().0];
        let near_fade = [self.mask.fade_out.left.0, self.mask.fade_out.top.0];
        let far_fade = [self.mask.fade_out.right.0, self.mask.fade_out.bottom.0];
        [
            bounds.origin,
            bounds.top_right(),
            bounds.bottom_left(),
            bounds.bottom_right(),
        ]
        .into_iter()
        .all(|corner| {
            let position = inverse.apply(transform.apply(corner));
            let source = [corner.x.0 as f64, corner.y.0 as f64];
            // Bound cancellation error in both affine evaluations. Uncertain
            // edges retain the ancestor; the coverage inset only shrinks.
            let magnitude = transform
                .rotation_scale
                .map(|row| (row[0] as f64 * source[0]).abs() + (row[1] as f64 * source[1]).abs());
            let magnitude = [
                magnitude[0] + (transform.translation[0] as f64).abs(),
                magnitude[1] + (transform.translation[1] as f64).abs(),
            ];
            [position.x.0, position.y.0]
                .into_iter()
                .enumerate()
                .all(|(axis, value)| {
                    let row = inverse.rotation_scale[axis];
                    let magnitude = (row[0] as f64).abs() * magnitude[0]
                        + (row[1] as f64).abs() * magnitude[1]
                        + (inverse.translation[axis] as f64).abs();
                    let margin = 32.0
                        * f32::EPSILON as f64
                        * magnitude
                            .max((near[axis] as f64).abs())
                            .max((far[axis] as f64).abs())
                            .max(1.0);
                    let lower = near[axis] as f64 + near_fade[axis].max(0.0) as f64 + margin;
                    let upper = far[axis] as f64 - far_fade[axis].max(0.0) as f64 - margin;
                    value.is_finite() && value as f64 >= lower && value as f64 <= upper
                })
        })
    }
}

impl Default for CoordinateSpace {
    fn default() -> Self {
        Self {
            transform: TransformationMatrix::unit(),
            inverse: Some(TransformationMatrix::unit()),
            raster_scale: 1.0,
            clips: None,
        }
    }
}

impl CoordinateSpace {
    /// Creates a coordinate space from an affine mapping in logical pixels.
    pub fn new(transform: TransformationMatrix) -> Self {
        Self {
            transform,
            inverse: transform.inverse(),
            // Raster density is a property of the space, not of each glyph.
            // Upward eighth-step buckets limit churn; the cap bounds allocations.
            raster_scale: (transform.max_scale().max(1.0) * RASTER_BUCKETS_PER_UNIT)
                .ceil()
                .clamp(
                    RASTER_BUCKETS_PER_UNIT,
                    MAX_RASTER_SCALE * RASTER_BUCKETS_PER_UNIT,
                )
                / RASTER_BUCKETS_PER_UNIT,
            clips: None,
        }
    }

    /// Recommended bitmap density relative to the window's device scale.
    ///
    /// The greatest affine stretch rounds upward to eighth steps, between one
    /// and eight. Use this for custom bitmap content while retaining layout size.
    pub fn raster_scale(&self) -> f32 {
        self.raster_scale
    }

    /// Maps a point in layout coordinates into the window.
    pub fn to_window(&self, position: Point<Pixels>) -> Point<Pixels> {
        self.transform.apply(position)
    }

    /// Maps a displacement, excluding translation, into window coordinates.
    pub fn vector_to_window(&self, vector: Point<Pixels>) -> Point<Pixels> {
        self.transform.apply_vector(vector)
    }

    /// Maps a window point into layout coordinates. A collapsed space has no inverse.
    pub fn from_window(&self, position: Point<Pixels>) -> Option<Point<Pixels>> {
        self.inverse.map(|inverse| inverse.apply(position))
    }

    /// Maps a displacement, excluding translation, into layout coordinates.
    pub fn vector_from_window(&self, vector: Point<Pixels>) -> Option<Point<Pixels>> {
        self.inverse.map(|inverse| inverse.apply_vector(vector))
    }

    /// Returns the axis-aligned window bounds enclosing a local rectangle.
    /// This is conservative geometry for culling and platform APIs, not a hit test.
    pub fn bounds_to_window(&self, bounds: Bounds<Pixels>) -> Bounds<Pixels> {
        if self.inverse.is_none() {
            return Bounds::default();
        }
        self.transform.apply_bounds(bounds)
    }

    /// Conservatively maps a window rectangle into layout coordinates.
    pub fn bounds_from_window(&self, bounds: Bounds<Pixels>) -> Option<Bounds<Pixels>> {
        self.inverse.map(|inverse| inverse.apply_bounds(bounds))
    }

    /// Tests all ancestor clips in the coordinates where they were established.
    pub fn contains_window_point(&self, position: Point<Pixels>) -> bool {
        let mut clip = self.clips.as_deref();
        while let Some(region) = clip {
            let Some(inverse) = region.inverse else {
                return false;
            };
            if !region.mask.bounds.contains(&inverse.apply(position)) {
                return false;
            }
            clip = region.parent.as_deref();
        }
        self.inverse.is_some()
    }

    pub(crate) fn same_scope(&self, other: &Self) -> bool {
        self.transform == other.transform
            && match (&self.clips, &other.clips) {
                (None, None) => true,
                (Some(a), Some(b)) => Arc::ptr_eq(a, b),
                _ => false,
            }
    }

    // Ordinary drawing retains the original single-mask shader path. Consecutive
    // clips in one space are already intersected by `clipped`.
    pub(crate) fn is_identity_scope(&self) -> bool {
        self.transform == TransformationMatrix::unit()
            && self.clips.as_ref().is_none_or(|clip| {
                clip.transform == TransformationMatrix::unit() && clip.parent.is_none()
            })
    }

    pub(crate) fn content_mask(&self, viewport: Bounds<Pixels>) -> ContentMask<Pixels> {
        if self.is_identity_scope() {
            let viewport = ContentMask {
                bounds: viewport,
                ..Default::default()
            };
            return self
                .clips
                .as_ref()
                .map_or(viewport, |clip| clip.mask.intersect(&viewport));
        }
        ContentMask {
            bounds: self
                .bounds_from_window(self.window_clip_bounds(viewport))
                .unwrap_or_default(),
            ..Default::default()
        }
    }

    pub(crate) fn transformed(&self, transform: TransformationMatrix) -> Self {
        let transform = self.transform.compose(transform);
        Self {
            clips: self.clips.clone(),
            ..Self::new(transform)
        }
    }

    pub(crate) fn clipped(&self, mut mask: ContentMask<Pixels>) -> Self {
        let mut parent = self.clips.clone();
        if let Some(clip) = &self.clips
            && clip.transform == self.transform
        {
            mask = mask.intersect(&clip.mask);
            if mask == clip.mask {
                return self.clone();
            }
            parent = clip.parent.clone();
        }
        // Clip multiplication has an identity: an ancestor covering the whole
        // child contributes alpha one. Pop only a proven redundant prefix; this
        // avoids rebuilding an arbitrary chain or compiling a polygon.
        while let Some(clip) = &parent
            && clip.fully_covers(mask.bounds, self.transform)
        {
            parent = clip.parent.clone();
        }
        let local_window_bounds = self.transform.apply_bounds(mask.bounds);
        let window_bounds = self.clips.as_ref().map_or(local_window_bounds, |clip| {
            clip.window_bounds.intersect(&local_window_bounds)
        });
        Self {
            transform: self.transform,
            inverse: self.inverse,
            raster_scale: self.raster_scale,
            clips: Some(Arc::new(ClipRegion {
                mask,
                transform: self.transform,
                inverse: self.inverse,
                window_bounds,
                parent,
            })),
        }
    }

    pub(crate) fn window_clip_bounds(&self, viewport: Bounds<Pixels>) -> Bounds<Pixels> {
        self.clips
            .as_ref()
            .map_or(viewport, |clip| viewport.intersect(&clip.window_bounds))
    }

    pub(crate) fn render_transform(
        &self,
        scale: f32,
    ) -> (TransformationMatrix, Option<TransformationMatrix>) {
        (
            self.transform.scaled(scale),
            self.inverse.map(|inverse| inverse.scaled(scale)),
        )
    }
}

impl TransformationMatrix {
    /// Inverts a finite affine transform. Collapsed or non-finite transforms return `None`.
    pub fn inverse(self) -> Option<Self> {
        let [[a, b], [c, d]] = self.rotation_scale;
        let determinant = a * d - b * c;
        if determinant == 0.0 || !determinant.is_finite() {
            return None;
        }
        let rotation_scale = [
            [d / determinant, -b / determinant],
            [-c / determinant, a / determinant],
        ];
        let [x, y] = self.translation;
        let inverse = Self {
            rotation_scale,
            translation: [
                -(rotation_scale[0][0] * x + rotation_scale[0][1] * y),
                -(rotation_scale[1][0] * x + rotation_scale[1][1] * y),
            ],
        };
        inverse
            .rotation_scale
            .iter()
            .flatten()
            .chain(inverse.translation.iter())
            .all(|value| value.is_finite())
            .then_some(inverse)
    }

    /// Maps a vector without translating it.
    pub fn apply_vector(self, vector: Point<Pixels>) -> Point<Pixels> {
        let mut matrix = self;
        matrix.translation = [0.0; 2];
        matrix.apply(vector)
    }

    /// Conservatively encloses all four transformed corners of a rectangle.
    pub fn apply_bounds(self, bounds: Bounds<Pixels>) -> Bounds<Pixels> {
        if self == Self::unit() {
            return bounds;
        }
        let corners = [
            bounds.origin,
            bounds.top_right(),
            bounds.bottom_left(),
            bounds.bottom_right(),
        ]
        .map(|corner| self.apply(corner));
        let mut min = corners[0];
        let mut max = corners[0];
        for corner in &corners[1..] {
            min.x = min.x.min(corner.x);
            min.y = min.y.min(corner.y);
            max.x = max.x.max(corner.x);
            max.y = max.y.max(corner.y);
        }
        Bounds::from_corners(min, max)
    }

    /// Converts the translation between logical and device pixel units.
    pub fn scaled(self, factor: f32) -> Self {
        Self {
            translation: self.translation.map(|value| value * factor),
            ..self
        }
    }

    /// Largest singular value of the linear mapping, used to choose text raster density.
    pub fn max_scale(self) -> f32 {
        let [[a, b], [c, d]] = self.rotation_scale;
        let sum = a * a + b * b + c * c + d * d;
        let determinant = a * d - b * c;
        ((sum
            + (sum * sum - 4.0 * determinant * determinant)
                .max(0.0)
                .sqrt())
            * 0.5)
            .sqrt()
    }
}

/// A frame-local coordinate space shared by scene primitives on the GPU.
/// The parent links clipping scopes; bounds and fades stay in their own local units.
#[doc(hidden)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
#[repr(u32)]
pub enum SpaceKind {
    /// An affine mapping with no additional clip.
    #[default]
    Mapping = 0,
    /// A clipping scope, evaluated in its own coordinates.
    Clip = 1,
    /// A collapsed or non-finite mapping with no visible region.
    Collapsed = 2,
}

/// An interned coordinate-space record in the scene's GPU table.
#[doc(hidden)]
#[derive(Clone, Copy, Debug, PartialEq)]
#[repr(C)]
pub struct RenderSpace {
    pub transform: TransformationMatrix,
    pub inverse: TransformationMatrix,
    pub clip: Bounds<crate::ScaledPixels>,
    pub fade: crate::Edges<crate::ScaledPixels>,
    pub parent: u32,
    pub kind: SpaceKind,
}

impl Default for RenderSpace {
    fn default() -> Self {
        Self {
            transform: TransformationMatrix::unit(),
            inverse: TransformationMatrix::unit(),
            clip: Bounds::default(),
            fade: crate::Edges::default(),
            parent: 0,
            kind: SpaceKind::Mapping,
        }
    }
}

impl RenderSpace {
    pub(crate) fn mapping(
        transform: TransformationMatrix,
        inverse: Option<TransformationMatrix>,
        parent: u32,
    ) -> Self {
        let Some(inverse) = inverse else {
            return Self::collapsed(parent);
        };
        Self {
            transform,
            inverse,
            parent,
            ..Default::default()
        }
    }

    pub(crate) fn clipping(
        transform: TransformationMatrix,
        inverse: Option<TransformationMatrix>,
        clip: Bounds<crate::ScaledPixels>,
        fade: crate::Edges<crate::ScaledPixels>,
        parent: u32,
    ) -> Self {
        let Some(inverse) = inverse else {
            return Self::collapsed(parent);
        };
        Self {
            transform,
            inverse,
            clip,
            fade,
            parent,
            kind: SpaceKind::Clip,
        }
    }

    pub(crate) fn collapsed(parent: u32) -> Self {
        Self {
            transform: TransformationMatrix {
                rotation_scale: [[0.0; 2]; 2],
                translation: [0.0; 2],
            },
            inverse: TransformationMatrix::unit(),
            parent,
            kind: SpaceKind::Collapsed,
            ..Default::default()
        }
    }

    pub(crate) fn is_collapsed(&self) -> bool {
        self.kind == SpaceKind::Collapsed
    }

    pub(crate) fn key(&self) -> [u32; 22] {
        let mut key = [0; 22];
        for (i, value) in self
            .transform
            .rotation_scale
            .iter()
            .flatten()
            .chain(self.transform.translation.iter())
            .chain(self.inverse.rotation_scale.iter().flatten())
            .chain(self.inverse.translation.iter())
            .copied()
            .chain([
                self.clip.origin.x.0,
                self.clip.origin.y.0,
                self.clip.size.width.0,
                self.clip.size.height.0,
                self.fade.top.0,
                self.fade.right.0,
                self.fade.bottom.0,
                self.fade.left.0,
            ])
            .enumerate()
        {
            key[i] = value.to_bits();
        }
        key[20] = self.parent;
        key[21] = self.kind as u32;
        key
    }
}

#[cfg(test)]
mod tests;
