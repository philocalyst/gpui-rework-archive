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
            && p.x >= self.x
            && p.y >= self.y
            && p.x < self.x + self.width
            && p.y < self.y + self.height
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
    transform: Affine,
}
impl CoordinateSpace {
    pub const fn new(transform: Affine) -> Self {
        Self { transform }
    }
    pub const fn transform(self) -> Affine {
        self.transform
    }
    pub fn to_window(self, point: Point) -> Option<Point> {
        self.transform.apply(point)
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
        let t = self.transform;
        if !t.is_finite() || !point.x.is_finite() || !point.y.is_finite() {
            return None;
        }
        let (a, b, c, d) = (t.a as f64, t.b as f64, t.c as f64, t.d as f64);
        let det = a * d - b * c;
        if det == 0.0 {
            return None;
        }
        let (x, y) = (point.x as f64 - t.tx as f64, point.y as f64 - t.ty as f64);
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
        let t = self.transform;
        if !rect.is_valid() || !t.is_finite() {
            return MappedBounds::Unbounded;
        }
        let det = t.a as f64 * t.d as f64 - t.b as f64 * t.c as f64;
        if rect.is_empty() || det == 0.0 {
            return MappedBounds::Empty;
        }
        let (x, y) = (rect.x as f64, rect.y as f64);
        let (right, bottom) = (x + rect.width as f64, y + rect.height as f64);
        let points = [[x, y], [right, y], [x, bottom], [right, bottom]];
        let mut min = [f64::INFINITY; 2];
        let mut max = [f64::NEG_INFINITY; 2];
        for p in points {
            let x = t.a as f64 * p[0] + t.c as f64 * p[1] + t.tx as f64;
            let y = t.b as f64 * p[0] + t.d as f64 * p[1] + t.ty as f64;
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
