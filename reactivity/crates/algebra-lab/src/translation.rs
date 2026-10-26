use crate::{Algebra, Error, Key, TranslationForest};

/// The exact source-coordinate unit: one subpixel is 1/256 of a logical pixel.
pub const SUBPIXELS_PER_PIXEL: i64 = 256;

/// Local translation in fixed 1/256-pixel units. No floating-point constructor.
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct Translation {
    x: i64,
    y: i64,
}
impl Translation {
    pub const ZERO: Self = Self { x: 0, y: 0 };
    pub const fn from_subpixels(x: i64, y: i64) -> Self {
        Self { x, y }
    }
    pub const fn subpixels(self) -> (i64, i64) {
        (self.x, self.y)
    }
}

/// Exact accumulated translation. Nonzero values are only minted by a forest, so each
/// axis has magnitude <2^95: fewer than 2^32 nodes, each magnitude <=2^63.
/// Arbitrary i128 construction/addition is intentionally not exposed.
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct WideTranslation {
    x: i128,
    y: i128,
}
impl WideTranslation {
    pub const fn subpixels(self) -> (i128, i128) {
        (self.x, self.y)
    }
}

/// Offset tagged with its node and viewport origin. Narrow only after this exact
/// subtraction. Different components cannot produce this capability.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct RelativeTranslation {
    node: Key,
    origin: Key,
    x: i128,
    y: i128,
}
impl RelativeTranslation {
    pub const fn node(self) -> Key {
        self.node
    }
    pub const fn origin(self) -> Key {
        self.origin
    }
    pub const fn subpixels(self) -> (i128, i128) {
        (self.x, self.y)
    }
    /// Returns renderer f32 pixels only when both integer subpixel coordinates
    /// survive narrowing exactly. Division by 256 is exact power-of-two scaling.
    /// A rejected far offset should be culled/rebased, never silently rounded.
    pub fn to_pixels_f32(self) -> Result<(f32, f32), Error> {
        let (x, y) = (self.x as f32, self.y as f32);
        if x as i128 != self.x || y as i128 != self.y {
            return Err(Error::RendererRange);
        }
        Ok((
            x / SUBPIXELS_PER_PIXEL as f32,
            y / SUBPIXELS_PER_PIXEL as f32,
        ))
    }
}

pub(super) struct ExactTranslations;
impl Algebra for ExactTranslations {
    type Local = Translation;
    type Product = WideTranslation;
    fn validate(_: Translation) -> Result<(), Error> {
        Ok(())
    }
    fn lift(value: Translation) -> WideTranslation {
        WideTranslation {
            x: value.x as i128,
            y: value.y as i128,
        }
    }
    #[inline]
    fn combine(left: WideTranslation, right: WideTranslation) -> WideTranslation {
        // Every cached aggregate is a disjoint subpath. Therefore every partial
        // sum, for EVERY reassociation, lies in (-2^95,2^95), far inside i128.
        // No saturating/wrapping arithmetic; associativity is exact on this domain.
        WideTranslation {
            x: left.x + right.x,
            y: left.y + right.y,
        }
    }
    fn finish(value: WideTranslation) -> Result<WideTranslation, Error> {
        Ok(value)
    }
}

impl TranslationForest {
    /// Resolve a node relative to a viewport in this same represented component.
    /// The exact difference has magnitude <2^96 and cannot overflow i128.
    /// This call performs several amortized-logarithmic accesses, no parent scan.
    pub fn viewport_relative(
        &mut self,
        node: Key,
        origin: Key,
    ) -> Result<RelativeTranslation, Error> {
        let i = self.0.index(node)?;
        let o = self.0.index(origin)?;
        if self.0.root(i) != self.0.root(o) {
            return Err(Error::DifferentComponent);
        }
        let point = self.0.world(node)?;
        let viewport = self.0.world(origin)?;
        Ok(RelativeTranslation {
            node,
            origin,
            x: point.x - viewport.x,
            y: point.y - viewport.y,
        })
    }
}
