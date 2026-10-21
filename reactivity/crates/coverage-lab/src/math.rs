//! Outward intervals over finite IEEE binary64 operations. No fast-math assumptions.
#[derive(Clone, Copy, Debug)]
pub(crate) struct Interval {
    pub lo: f64,
    pub hi: f64,
}
impl Interval {
    pub fn point(value: f64) -> Self {
        Self {
            lo: value,
            hi: value,
        }
    }
    pub fn whole() -> Self {
        Self {
            lo: f64::NEG_INFINITY,
            hi: f64::INFINITY,
        }
    }
    pub fn finite(self) -> bool {
        self.lo.is_finite() && self.hi.is_finite() && self.lo <= self.hi
    }
    pub fn add(self, other: Self) -> Self {
        if self.lo == 0.0 && self.hi == 0.0 {
            return other;
        }
        if other.lo == 0.0 && other.hi == 0.0 {
            return self;
        }
        Self {
            lo: (self.lo + other.lo).next_down(),
            hi: (self.hi + other.hi).next_up(),
        }
    }
    pub fn neg(self) -> Self {
        Self {
            lo: -self.hi,
            hi: -self.lo,
        }
    }
    pub fn sub(self, other: Self) -> Self {
        self.add(other.neg())
    }
    pub fn mul(self, other: Self) -> Self {
        if (self.lo == 0.0 && self.hi == 0.0) || (other.lo == 0.0 && other.hi == 0.0) {
            return Self::point(0.0);
        }
        let products = [
            self.lo * other.lo,
            self.lo * other.hi,
            self.hi * other.lo,
            self.hi * other.hi,
        ];
        if products.iter().any(|v| v.is_nan()) {
            return Self::whole();
        }
        Self {
            lo: products
                .into_iter()
                .fold(f64::INFINITY, f64::min)
                .next_down(),
            hi: products
                .into_iter()
                .fold(f64::NEG_INFINITY, f64::max)
                .next_up(),
        }
    }
    pub fn div(self, other: Self) -> Self {
        if other.lo <= 0.0 && other.hi >= 0.0 {
            return Self::whole();
        }
        let reciprocal = Self {
            lo: (1.0 / other.hi).next_down(),
            hi: (1.0 / other.lo).next_up(),
        };
        self.mul(reciprocal)
    }
    pub fn abs(self) -> Self {
        if self.lo >= 0.0 {
            self
        } else if self.hi <= 0.0 {
            self.neg()
        } else {
            Self {
                lo: 0.0,
                hi: self.hi.max(-self.lo),
            }
        }
    }
    pub fn max(self, other: Self) -> Self {
        Self {
            lo: self.lo.max(other.lo),
            hi: self.hi.max(other.hi),
        }
    }
    pub fn min(self, other: Self) -> Self {
        Self {
            lo: self.lo.min(other.lo),
            hi: self.hi.min(other.hi),
        }
    }
    pub fn square(self) -> Self {
        let abs = self.abs();
        if abs.hi == 0.0 {
            return Self::point(0.0);
        }
        Self {
            lo: (abs.lo * abs.lo).next_down().max(0.0),
            hi: (abs.hi * abs.hi).next_up(),
        }
    }
    pub fn sqrt(self) -> Option<Self> {
        if !self.finite() || self.hi < 0.0 {
            return None;
        }
        let lo = bracket(self.lo.max(0.0))?.0;
        let hi = bracket(self.hi)?.1;
        Some(Self { lo, hi })
    }
}

// sqrt is only a seed, not an unproved accuracy assumption: endpoint-square
// intervals certify the returned bracket. If eight adjacent floats cannot prove
// a bracket, classification declines rather than assuming a library error bound.
fn bracket(value: f64) -> Option<(f64, f64)> {
    if value == 0.0 {
        return Some((0.0, 0.0));
    }
    let seed = value.sqrt();
    if !seed.is_finite() || seed < 0.0 {
        return None;
    }
    let mut lo = seed.next_down().max(0.0);
    let mut hi = seed.next_up();
    for _ in 0..8 {
        let lower = Interval::point(lo).square().hi <= value;
        let upper = Interval::point(hi).square().lo >= value;
        if lower && upper {
            return Some((lo, hi));
        }
        if !lower {
            lo = lo.next_down().max(0.0);
        }
        if !upper {
            hi = hi.next_up();
        }
    }
    None
}
