//! Coordinate spaces shared by painting, clipping, input and platform geometry.

use crate::{Bounds, ContentMask, Pixels, Point, Radians, Size, TransformationMatrix, point};
use std::sync::Arc;

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
    pub(crate) clips: Option<Arc<ClipRegion>>,
}

#[derive(Debug, PartialEq)]
pub(crate) struct ClipRegion {
    pub mask: ContentMask<Pixels>,
    pub transform: TransformationMatrix,
    inverse: Option<TransformationMatrix>,
    pub parent: Option<Arc<ClipRegion>>,
}

impl Default for CoordinateSpace {
    fn default() -> Self {
        Self {
            transform: TransformationMatrix::unit(),
            inverse: Some(TransformationMatrix::unit()),
            clips: None,
        }
    }
}

impl CoordinateSpace {
    /// Maps a point in layout coordinates into the window.
    pub fn to_window(&self, position: Point<Pixels>) -> Point<Pixels> {
        self.transform.apply(position)
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
        self.transform.apply_bounds(bounds)
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

    pub(crate) fn transformed(&self, transform: TransformationMatrix) -> Self {
        let transform = self.transform.compose(transform);
        Self {
            transform,
            inverse: transform.inverse(),
            clips: self.clips.clone(),
        }
    }

    pub(crate) fn clipped(&self, mut mask: ContentMask<Pixels>) -> Self {
        let mut parent = self.clips.clone();
        if let Some(clip) = &self.clips
            && clip.transform == self.transform
        {
            mask = mask.intersect(&clip.mask);
            parent = clip.parent.clone();
        }
        Self {
            transform: self.transform,
            inverse: self.inverse,
            clips: Some(Arc::new(ClipRegion {
                mask,
                transform: self.transform,
                inverse: self.inverse,
                parent,
            })),
        }
    }

    pub(crate) fn window_clip_bounds(&self, viewport: Bounds<Pixels>) -> Bounds<Pixels> {
        let mut bounds = viewport;
        let mut clip = self.clips.as_deref();
        while let Some(region) = clip {
            bounds = bounds.intersect(&region.transform.apply_bounds(region.mask.bounds));
            clip = region.parent.as_deref();
        }
        bounds
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
#[derive(Clone, Copy, Debug, PartialEq)]
#[repr(C)]
pub struct RenderSpace {
    pub transform: TransformationMatrix,
    pub inverse: TransformationMatrix,
    pub clip: Bounds<crate::ScaledPixels>,
    pub fade: crate::Edges<crate::ScaledPixels>,
    pub parent: u32,
    /// 0: mapping only, 1: clip, 2: collapsed/non-finite mapping.
    pub has_clip: u32,
}

impl Default for RenderSpace {
    fn default() -> Self {
        Self {
            transform: TransformationMatrix::unit(),
            inverse: TransformationMatrix::unit(),
            clip: Bounds::default(),
            fade: crate::Edges::default(),
            parent: 0,
            has_clip: 0,
        }
    }
}

impl RenderSpace {
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
        key[21] = self.has_clip;
        key
    }
}
