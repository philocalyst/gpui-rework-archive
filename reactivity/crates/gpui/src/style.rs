//! Compact resolved style values used by description, layout and presentation.
//!
//! Values here are the first literal-property floor. Cascade contributions and
//! reactive property bindings must preserve presence separately when introduced.
pub use gpui_canvas::{Color, rgb};
pub use gpui_reactivity_core::Affine;

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub enum Flow {
    Row,
    #[default]
    Column,
}

/// A dimension after the builder/property boundary has admitted its value.
/// Finite lengths retain their exact bits; NaN denotes automatic sizing.
/// Public selectors continue to accept and return `Option<f32>`.
#[derive(Clone, Copy)]
pub(crate) struct OptionalLength(f32);
impl OptionalLength {
    pub const AUTO: Self = Self(f32::NAN);

    #[inline]
    pub fn from_validated(value: Option<f32>) -> Self {
        debug_assert!(value.is_none_or(|value| value.is_finite() && value >= 0.0));
        Self(value.unwrap_or(f32::NAN))
    }

    #[inline]
    pub fn get(self) -> Option<f32> {
        (!self.0.is_nan()).then_some(self.0)
    }
}
impl PartialEq for OptionalLength {
    #[inline]
    fn eq(&self, other: &Self) -> bool {
        // Admitted lengths are nonnegative and Auto has one canonical NaN.
        // Removing the sign bit equates the two zeros while preserving every
        // other admitted value, including Auto, without float/option branches.
        self.0.to_bits() & 0x7fff_ffff == other.0.to_bits() & 0x7fff_ffff
    }
}
impl std::fmt::Debug for OptionalLength {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        self.get().fmt(f)
    }
}

#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Style {
    pub(crate) width: OptionalLength,
    pub(crate) height: OptionalLength,
    pub(crate) gap: f32,
    pub(crate) padding: f32,
    pub(crate) font_size: f32,
    pub(crate) fg: Color,
    pub(crate) bg: Color,
    pub(crate) flow: Flow,
    pub(crate) transform: Affine,
}

impl Default for Style {
    fn default() -> Self {
        Self {
            width: OptionalLength::AUTO,
            height: OptionalLength::AUTO,
            gap: 0.0,
            padding: 0.0,
            font_size: 16.0,
            fg: Color::rgb(0, 0, 0),
            bg: Color::rgba(0, 0, 0, 0),
            flow: Flow::Column,
            transform: Affine::IDENTITY,
        }
    }
}

mod sealed {
    pub trait Length {}
}

/// Literal lengths accept ordinary integer and floating-point Rust values.
/// Dimensions and spacing must be finite and nonnegative; font size is positive.
pub trait IntoLength: sealed::Length {
    #[doc(hidden)]
    fn into_length(self) -> f64;
}

macro_rules! lengths {
    ($($ty:ty),+ $(,)?) => {$(
        impl sealed::Length for $ty {}
        impl IntoLength for $ty {
            fn into_length(self) -> f64 { self as f64 }
        }
    )+};
}
lengths!(f32, f64, u8, u16, u32, u64, usize, i8, i16, i32, i64, isize);

pub(crate) fn nonnegative(value: impl IntoLength, field: &str) -> f32 {
    let value = value.into_length();
    assert!(
        value.is_finite() && value >= 0.0 && value <= f32::MAX as f64,
        "{field} must be finite, nonnegative and representable as f32"
    );
    value as f32
}

/// A typed flow recipe; it finishes on the same concrete element currency.
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Flex {
    pub(crate) flow: Flow,
    pub(crate) gap: Option<f32>,
}

impl Flex {
    pub const fn row() -> Self {
        Self {
            flow: Flow::Row,
            gap: None,
        }
    }
    pub const fn column() -> Self {
        Self {
            flow: Flow::Column,
            gap: None,
        }
    }
    pub fn gap(mut self, gap: impl IntoLength) -> Self {
        self.gap = Some(nonnegative(gap, "gap"));
        self
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn literals_validate_after_conversion() {
        assert_eq!(nonnegative(8, "gap"), 8.0);
        assert_eq!(nonnegative(2.5_f64, "padding"), 2.5);
        for invalid in [f64::NAN, f64::INFINITY, f64::MAX, -1.0, -f64::MIN_POSITIVE] {
            assert!(std::panic::catch_unwind(|| nonnegative(invalid, "width")).is_err());
        }
    }

    #[test]
    fn optional_lengths_preserve_the_admitted_float_domain() {
        assert_eq!(size_of::<OptionalLength>(), size_of::<f32>());
        assert_eq!(OptionalLength::AUTO.get(), None);
        assert_eq!(OptionalLength::AUTO, OptionalLength::AUTO);
        assert_eq!(format!("{:?}", OptionalLength::AUTO), "None");
        for value in [0.0, -0.0, f32::from_bits(1), f32::MIN_POSITIVE, f32::MAX] {
            let length = OptionalLength::from_validated(Some(value));
            assert_eq!(length.get().unwrap().to_bits(), value.to_bits());
            assert_eq!(format!("{length:?}"), format!("{:?}", Some(value)));
        }
        assert_eq!(
            OptionalLength::from_validated(Some(0.0)),
            OptionalLength::from_validated(Some(-0.0))
        );
        assert_ne!(
            OptionalLength::AUTO,
            OptionalLength::from_validated(Some(0.0))
        );
    }
}
