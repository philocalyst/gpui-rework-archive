//! One affine coordinate model for conservative bounds and exact local hit tests.

#[derive(Clone, Copy, Debug, Default, PartialEq)]
pub struct Point {
    pub x: f32,
    pub y: f32,
}

#[derive(Clone, Copy, Debug, Default, PartialEq)]
pub struct Rect {
    pub x: f32,
    pub y: f32,
    pub width: f32,
    pub height: f32,
}
impl Rect {
    pub const fn new(x: f32, y: f32, width: f32, height: f32) -> Self {
        Self {
            x,
            y,
            width,
            height,
        }
    }
    pub fn is_valid(self) -> bool {
        [
            self.x,
            self.y,
            self.width,
            self.height,
            self.x + self.width,
            self.y + self.height,
        ]
        .into_iter()
        .all(f32::is_finite)
            && self.width >= 0.0
            && self.height >= 0.0
    }
    pub fn is_empty(self) -> bool {
        self.width == 0.0 || self.height == 0.0
    }
    /// Half-open edges avoid double hits at adjacent rectangle boundaries.
    pub fn contains(self, p: Point) -> bool {
        self.is_valid()
            && !self.is_empty()
            && p.x as f64 >= self.x as f64
            && p.y as f64 >= self.y as f64
            && (p.x as f64) < self.x as f64 + self.width as f64
            && (p.y as f64) < self.y as f64 + self.height as f64
    }
    pub fn intersection(self, other: Self) -> Self {
        let x = self.x.max(other.x);
        let y = self.y.max(other.y);
        Self::new(
            x,
            y,
            ((self.x + self.width).min(other.x + other.width) - x).max(0.0),
            ((self.y + self.height).min(other.y + other.height) - y).max(0.0),
        )
    }
}

/// `[a c tx; b d ty; 0 0 1]`, mapping local coordinates to parent coordinates.
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Affine {
    pub a: f32,
    pub b: f32,
    pub c: f32,
    pub d: f32,
    pub tx: f32,
    pub ty: f32,
}
impl Default for Affine {
    fn default() -> Self {
        Self::IDENTITY
    }
}
impl Affine {
    pub const IDENTITY: Self = Self {
        a: 1.0,
        b: 0.0,
        c: 0.0,
        d: 1.0,
        tx: 0.0,
        ty: 0.0,
    };
    pub const fn translation(x: f32, y: f32) -> Self {
        Self {
            tx: x,
            ty: y,
            ..Self::IDENTITY
        }
    }
    pub const fn scale(x: f32, y: f32) -> Self {
        Self {
            a: x,
            d: y,
            ..Self::IDENTITY
        }
    }
    pub fn rotation(radians: f32) -> Self {
        let (s, c) = radians.sin_cos();
        Self {
            a: c,
            b: s,
            c: -s,
            d: c,
            tx: 0.0,
            ty: 0.0,
        }
    }
    pub fn is_finite(self) -> bool {
        [self.a, self.b, self.c, self.d, self.tx, self.ty]
            .into_iter()
            .all(f32::is_finite)
    }
    /// Invertibility does not require the inverse coefficients to fit in f32.
    pub fn is_invertible(self) -> bool {
        self.is_finite() && self.a as f64 * self.d as f64 - self.b as f64 * self.c as f64 != 0.0
    }
    /// `parent.compose(child)` applies child first, then parent.
    pub fn compose(self, child: Self) -> Self {
        let (a, b, c, d, x, y) = (
            self.a as f64,
            self.b as f64,
            self.c as f64,
            self.d as f64,
            self.tx as f64,
            self.ty as f64,
        );
        Self {
            a: (a * child.a as f64 + c * child.b as f64) as f32,
            b: (b * child.a as f64 + d * child.b as f64) as f32,
            c: (a * child.c as f64 + c * child.d as f64) as f32,
            d: (b * child.c as f64 + d * child.d as f64) as f32,
            tx: (a * child.tx as f64 + c * child.ty as f64 + x) as f32,
            ty: (b * child.tx as f64 + d * child.ty as f64 + y) as f32,
        }
    }
    pub fn apply(self, p: Point) -> Option<Point> {
        let result = Point {
            x: (self.a as f64 * p.x as f64 + self.c as f64 * p.y as f64 + self.tx as f64) as f32,
            y: (self.b as f64 * p.x as f64 + self.d as f64 * p.y as f64 + self.ty as f64) as f32,
        };
        (result.x.is_finite() && result.y.is_finite()).then_some(result)
    }
    pub fn inverse(self) -> Option<Self> {
        if !self.is_finite() {
            return None;
        }
        let (a, b, c, d, x, y) = (
            self.a as f64,
            self.b as f64,
            self.c as f64,
            self.d as f64,
            self.tx as f64,
            self.ty as f64,
        );
        let det = a * d - b * c;
        if det == 0.0 {
            return None;
        }
        let result = Self {
            a: (d / det) as f32,
            b: (-b / det) as f32,
            c: (-c / det) as f32,
            d: (a / det) as f32,
            tx: ((c * y - d * x) / det) as f32,
            ty: ((b * x - a * y) / det) as f32,
        };
        result.is_finite().then_some(result)
    }
}

#[derive(Clone, Copy, Debug, PartialEq)]
pub enum MappedBounds {
    Empty,
    Finite(Rect),
    /// The bound cannot be represented as a finite f32 rectangle. Damage must
    /// conservatively cover the viewport rather than interpret this as empty.
    Unbounded,
}

#[derive(Clone, Copy, Debug, PartialEq)]
pub struct CoordinateSpace {
    matrix: [f64; 6],
    uncertain: bool,
}
impl CoordinateSpace {
    pub const fn new(transform: Affine) -> Self {
        Self {
            matrix: [
                transform.a as f64,
                transform.b as f64,
                transform.c as f64,
                transform.d as f64,
                transform.tx as f64,
                transform.ty as f64,
            ],
            uncertain: false,
        }
    }
    /// The composed CPU mapping retains wide intermediates between ancestors.
    pub const fn coefficients(self) -> [f64; 6] {
        self.matrix
    }
    /// Compose without narrowing between ancestors. A lost invertible product
    /// remains uncertain, causing full damage rather than an empty rectangle.
    pub fn compose(self, child: Affine) -> Self {
        let [a, b, c, d, x, y] = self.matrix;
        let child = Self::new(child);
        let [e, f, g, h, u, v] = child.matrix;
        let matrix = [
            a * e + c * f,
            b * e + d * f,
            a * g + c * h,
            b * g + d * h,
            a * u + c * v + x,
            b * u + d * v + y,
        ];
        let det = matrix[0] * matrix[3] - matrix[1] * matrix[2];
        let lost_rank = self.is_invertible() && child.is_invertible() && det == 0.0;
        Self {
            matrix,
            uncertain: self.uncertain || lost_rank || !det.is_finite(),
        }
    }
    pub fn is_invertible(self) -> bool {
        let [a, b, c, d, _, _] = self.matrix;
        !self.uncertain && self.matrix.into_iter().all(f64::is_finite) && a * d - b * c != 0.0
    }
    pub fn to_window(self, point: Point) -> Option<Point> {
        let [a, b, c, d, x, y] = self.matrix;
        if self.uncertain {
            return None;
        }
        let result = Point {
            x: (a * point.x as f64 + c * point.y as f64 + x) as f32,
            y: (b * point.x as f64 + d * point.y as f64 + y) as f32,
        };
        (result.x.is_finite() && result.y.is_finite()).then_some(result)
    }
    pub fn to_local(self, point: Point) -> Option<Point> {
        let (x, y) = self.local_f64(point)?;
        let result = Point {
            x: x as f32,
            y: y as f32,
        };
        (result.x.is_finite() && result.y.is_finite()).then_some(result)
    }
    fn local_f64(self, point: Point) -> Option<(f64, f64)> {
        if !self.is_invertible() || !point.x.is_finite() || !point.y.is_finite() {
            return None;
        }
        let [a, b, c, d, tx, ty] = self.matrix;
        let det = a * d - b * c;
        if det == 0.0 {
            return None;
        }
        let (x, y) = (point.x as f64 - tx, point.y as f64 - ty);
        Some(((d * x - c * y) / det, (a * y - b * x) / det))
    }
    /// Finite AABB convenience accessor. Use `mapped_bounds` for damage: `None`
    /// here includes both empty geometry and unrepresentably large geometry.
    pub fn bounds(self, rect: Rect) -> Option<Rect> {
        match self.mapped_bounds(rect) {
            MappedBounds::Finite(rect) => Some(rect),
            _ => None,
        }
    }
    /// Conservative forward bound independent of inverse representability.
    pub fn mapped_bounds(self, rect: Rect) -> MappedBounds {
        if !rect.is_valid() || self.uncertain || !self.matrix.into_iter().all(f64::is_finite) {
            return MappedBounds::Unbounded;
        }
        let [a, b, c, d, tx, ty] = self.matrix;
        let det = a * d - b * c;
        if rect.is_empty() || det == 0.0 {
            return MappedBounds::Empty;
        }
        let (x, y) = (rect.x as f64, rect.y as f64);
        let (right, bottom) = (x + rect.width as f64, y + rect.height as f64);
        let points = [[x, y], [right, y], [x, bottom], [right, bottom]];
        let mut min = [f64::INFINITY; 2];
        let mut max = [f64::NEG_INFINITY; 2];
        for p in points {
            let x = a * p[0] + c * p[1] + tx;
            let y = b * p[0] + d * p[1] + ty;
            min[0] = min[0].min(x);
            min[1] = min[1].min(y);
            max[0] = max[0].max(x);
            max[1] = max[1].max(y);
        }
        // Outward rounding covers exact affine corner positions after f32 conversion.
        let min = min.map(|v| (v as f32).next_down());
        let max = max.map(|v| (v as f32).next_up());
        let result = Rect::new(
            min[0],
            min[1],
            (max[0] - min[0]).next_up(),
            (max[1] - min[1]).next_up(),
        );
        if result.is_valid() {
            MappedBounds::Finite(result)
        } else {
            MappedBounds::Unbounded
        }
    }
    pub fn hit(self, rect: Rect, window_point: Point) -> bool {
        if !rect.is_valid() || rect.is_empty() {
            return false;
        }
        self.local_f64(window_point).is_some_and(|(x, y)| {
            x >= rect.x as f64
                && y >= rect.y as f64
                && x < (rect.x as f64 + rect.width as f64)
                && y < (rect.y as f64 + rect.height as f64)
        })
    }
}

/// Explicit spatial data. A topology-only node has identity mapping and no surface/clip.
#[derive(Clone, Copy, Debug, Default, PartialEq)]
pub struct Geometry {
    pub bounds: Rect,
    pub transform: Affine,
    pub clip: Option<Rect>,
}
impl Geometry {
    pub fn is_valid(self) -> bool {
        self.bounds.is_valid() && self.transform.is_finite() && self.clip.is_none_or(Rect::is_valid)
    }
}
