//! Compact resolved style values used by description, layout and presentation.
//!
//! Values here are the first literal-property floor. Cascade contributions and
//! reactive property bindings must preserve presence separately when introduced.
pub use gpui_canvas::{Color, rgb};
pub use gpui_reactivity_core::Affine;

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
#[repr(u8)]
pub enum Flow {
    Row,
    #[default]
    Column,
}

/// Alignment of children on a flex container's cross axis.
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
#[repr(u8)]
pub enum Align {
    Start,
    End,
    Center,
    #[default]
    Stretch,
    Baseline,
}

/// Distribution of children along a flex container's main axis.
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
#[repr(u8)]
pub enum Justify {
    #[default]
    Start,
    End,
    Center,
    SpaceBetween,
    SpaceAround,
    SpaceEvenly,
}

#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Style {
    pub(crate) width: Option<f32>,
    pub(crate) height: Option<f32>,
    pub(crate) gap: f32,
    pub(crate) padding: f32,
    pub(crate) font_size: f32,
    pub(crate) fg: Color,
    pub(crate) bg: Color,
    pub(crate) flow: Flow,
    pub(crate) align: Align,
    pub(crate) justify: Justify,
    pub(crate) wrap: bool,
    pub(crate) transform: Affine,
}

impl Style {
    pub(crate) const DEFAULT: Self = Self {
        width: None,
        height: None,
        gap: 0.0,
        padding: 0.0,
        font_size: 16.0,
        fg: Color::rgb(0, 0, 0),
        bg: Color::rgba(0, 0, 0, 0),
        flow: Flow::Column,
        align: Align::Stretch,
        justify: Justify::Start,
        wrap: false,
        transform: Affine::IDENTITY,
    };
}
impl Default for Style {
    fn default() -> Self {
        Self::DEFAULT
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

/// A typed flow recipe; it finishes on the same concrete element currency.
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Flex<'a> {
    pub(crate) flow: Flow,
    pub(crate) gap: Option<crate::style_port::PropInput<'a, f64>>,
    pub(crate) align: Option<crate::style_port::PropInput<'a, Align>>,
    pub(crate) justify: Option<crate::style_port::PropInput<'a, Justify>>,
    pub(crate) wrap: Option<crate::style_port::PropInput<'a, bool>>,
}

impl<'a> Flex<'a> {
    pub const fn row() -> Self {
        Self {
            flow: Flow::Row,
            gap: None,
            align: None,
            justify: None,
            wrap: None,
        }
    }
    pub const fn column() -> Self {
        Self {
            flow: Flow::Column,
            gap: None,
            align: None,
            justify: None,
            wrap: None,
        }
    }
    pub fn gap(mut self, gap: impl crate::style_port::IntoProp<'a, f64>) -> Self {
        self.gap = Some(gap.into_prop());
        self
    }
    pub fn align(mut self, align: impl crate::style_port::IntoProp<'a, Align>) -> Self {
        self.align = Some(align.into_prop());
        self
    }
    pub fn justify(mut self, justify: impl crate::style_port::IntoProp<'a, Justify>) -> Self {
        self.justify = Some(justify.into_prop());
        self
    }
    pub fn wrap(mut self, wrap: impl crate::style_port::IntoProp<'a, bool>) -> Self {
        self.wrap = Some(wrap.into_prop());
        self
    }
}
