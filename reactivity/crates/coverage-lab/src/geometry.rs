use crate::math::Interval as I;

const LIMIT: f64 = 1_048_576.0;
const CONDITION: f64 = 4096.0;

#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Point {
    pub x: f64,
    pub y: f64,
}
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Rect {
    pub x: f64,
    pub y: f64,
    pub width: f64,
    pub height: f64,
}
impl Rect {
    pub fn valid(self) -> bool {
        [
            self.x,
            self.y,
            self.width,
            self.height,
            self.x + self.width,
            self.y + self.height,
        ]
        .into_iter()
        .all(|v| v.is_finite() && v.abs() <= LIMIT)
            && self.width > 0.0
            && self.height > 0.0
    }
}
/// [a c tx; b d ty; 0 0 1], local to window. This lab does not alter core math types.
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Affine {
    pub a: f64,
    pub b: f64,
    pub c: f64,
    pub d: f64,
    pub tx: f64,
    pub ty: f64,
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
    pub const fn translation(tx: f64, ty: f64) -> Self {
        Self {
            tx,
            ty,
            ..Self::IDENTITY
        }
    }
}
#[derive(Clone, Copy, Debug)]
pub struct Space {
    forward: Affine,
    inverse: Option<[I; 6]>,
    lipschitz: f64,
    inverse_det: f64,
}
impl Space {
    /// Nonfinite, too large, singular or uncertain/ill-conditioned input is kept
    /// unadmitted. Its tiles classify Boundary and point refinement errors.
    pub fn new(forward: Affine) -> Self {
        let mut result = Self {
            forward,
            inverse: None,
            lipschitz: f64::INFINITY,
            inverse_det: f64::NAN,
        };
        let t = forward;
        if ![t.a, t.b, t.c, t.d, t.tx, t.ty]
            .into_iter()
            .all(|v| v.is_finite() && v.abs() <= LIMIT)
        {
            return result;
        }
        let (a, b, c, d, x, y) = (
            I::point(t.a),
            I::point(t.b),
            I::point(t.c),
            I::point(t.d),
            I::point(t.tx),
            I::point(t.ty),
        );
        let det = a.mul(d).sub(b.mul(c));
        if det.lo <= 0.0 && det.hi >= 0.0 {
            return result;
        }
        let inverse = [
            d.div(det),
            b.neg().div(det),
            c.neg().div(det),
            a.div(det),
            c.mul(y).sub(d.mul(x)).div(det),
            b.mul(x).sub(a.mul(y)).div(det),
        ];
        if !inverse.into_iter().all(I::finite) {
            return result;
        }
        let Some(norm) = norm_upper([inverse[0], inverse[1], inverse[2], inverse[3]]) else {
            return result;
        };
        let Some(forward_norm) = norm_upper([a, b, c, d]) else {
            return result;
        };
        if norm > LIMIT || I::point(norm).mul(I::point(forward_norm)).hi > CONDITION {
            return result;
        }
        result.inverse = Some(inverse);
        result.lipschitz = norm;
        result.inverse_det = 1.0 / (t.a * t.d - t.b * t.c);
        result
    }
    pub fn is_admitted(self) -> bool {
        self.inverse.is_some()
    }
    pub fn inverse_norm_upper(self) -> Option<f64> {
        self.inverse.map(|_| self.lipschitz)
    }
    pub fn forward(self) -> Affine {
        self.forward
    }
    fn local_interval(self, p: [I; 2]) -> Option<[I; 2]> {
        let [a, b, c, d, x, y] = self.inverse?;
        Some([
            a.mul(p[0]).add(c.mul(p[1])).add(x),
            b.mul(p[0]).add(d.mul(p[1])).add(y),
        ])
    }
    pub(crate) fn local_point(self, p: Point) -> Option<Point> {
        if !self.is_admitted()
            || ![p.x, p.y]
                .into_iter()
                .all(|v| v.is_finite() && v.abs() <= LIMIT)
        {
            return None;
        }
        let t = self.forward;
        let (x, y) = (p.x - t.tx, p.y - t.ty);
        Some(Point {
            x: (t.d * x - t.c * y) * self.inverse_det,
            y: (t.a * y - t.b * x) * self.inverse_det,
        })
    }
}
// ||M||₂ <= sqrt(||M||₁ ||M||∞). All abs, sum, max and sqrt bounds
// are outward. This is exact for diagonal/identity maps and safe for shear.
fn norm_upper(m: [I; 4]) -> Option<f64> {
    let [a, b, c, d] = m.map(I::abs);
    let columns = a.add(b).max(c.add(d));
    let rows = a.add(c).max(b.add(d));
    Some(columns.mul(rows).sqrt()?.hi)
}

#[derive(Clone, Copy, Debug, PartialEq)]
pub enum Shape {
    Circle { radius: f64 },
    Box { half_width: f64, half_height: f64 },
}
impl Shape {
    fn valid(self) -> bool {
        let values = match self {
            Self::Circle { radius } => [radius, radius],
            Self::Box {
                half_width,
                half_height,
            } => [half_width, half_height],
        };
        values
            .into_iter()
            .all(|v| v.is_finite() && (0.0..=LIMIT).contains(&v))
    }
    fn distance_interval(self, p: [I; 2]) -> Option<I> {
        let zero = I::point(0.0);
        match self {
            Self::Circle { radius } => Some(
                p[0].square()
                    .add(p[1].square())
                    .sqrt()?
                    .sub(I::point(radius)),
            ),
            Self::Box {
                half_width,
                half_height,
            } => {
                let x = p[0].abs().sub(I::point(half_width));
                let y = p[1].abs().sub(I::point(half_height));
                let outside = x.max(zero).square().add(y.max(zero).square()).sqrt()?;
                Some(outside.add(x.max(y).min(zero)))
            }
        }
    }
}
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum Class {
    Outside,
    Inside,
    Boundary,
}
#[derive(Clone, Copy, Debug)]
pub struct Primitive {
    shape: Shape,
    space: Space,
}
impl Primitive {
    pub fn new(shape: Shape, space: Space) -> Option<Self> {
        shape.valid().then_some(Self { shape, space })
    }
    pub fn shape(self) -> Shape {
        self.shape
    }
    pub fn space(self) -> Space {
        self.space
    }
    pub fn classify(self, tile: Rect) -> Class {
        if !tile.valid() || !self.space.is_admitted() {
            return Class::Boundary;
        }
        // Center and half extents are intervals too: a rounded center must not
        // silently shrink the exact mathematical rectangle footprint.
        let hx = I::point(tile.width).mul(I::point(0.5));
        let hy = I::point(tile.height).mul(I::point(0.5));
        let center = [I::point(tile.x).add(hx), I::point(tile.y).add(hy)];
        let Some(local) = self.space.local_interval(center) else {
            return Class::Boundary;
        };
        let Some(distance) = self.shape.distance_interval(local) else {
            return Class::Boundary;
        };
        let Some(radius) = hx.square().add(hy.square()).sqrt() else {
            return Class::Boundary;
        };
        let extent = I::point(self.space.lipschitz).mul(radius);
        let bounds = distance.add(I {
            lo: -extent.hi,
            hi: extent.hi,
        });
        if !bounds.finite() {
            Class::Boundary
        } else if bounds.lo > 0.0 {
            Class::Outside
        } else if bounds.hi < 0.0 {
            Class::Inside
        } else {
            Class::Boundary
        }
    }
    /// Scalar point coverage (closed shape). This is not exact area coverage AA.
    pub fn contains(self, point: Point) -> Option<bool> {
        let p = self.space.local_point(point)?;
        Some(match self.shape {
            Shape::Circle { radius } => p.x * p.x + p.y * p.y <= radius * radius,
            Shape::Box {
                half_width,
                half_height,
            } => p.x.abs() <= half_width && p.y.abs() <= half_height,
        })
    }
}
