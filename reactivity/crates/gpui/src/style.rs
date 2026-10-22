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
    pub trait Recipe {}
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

/// A Copy flow recipe storing original operands, not erased bindings. Numeric
/// gap types are inferred; use `Flex<i32>` when naming an integer-gap recipe.
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Flex<G = f32, A = Align, J = Justify, W = bool> {
    flow: Flow,
    gap: Option<G>,
    align: Option<A>,
    justify: Option<J>,
    wrap: Option<W>,
}
impl Flex {
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
}
impl<G: Copy, A: Copy, J: Copy, W: Copy> Flex<G, A, J, W> {
    pub const fn gap<'a, Next: Copy + crate::IntoProp<'a, f64>>(
        self,
        gap: Next,
    ) -> Flex<Next, A, J, W> {
        Flex {
            flow: self.flow,
            gap: Some(gap),
            align: self.align,
            justify: self.justify,
            wrap: self.wrap,
        }
    }
    pub const fn align<'a, Next: Copy + crate::IntoProp<'a, Align>>(
        self,
        align: Next,
    ) -> Flex<G, Next, J, W> {
        Flex {
            flow: self.flow,
            gap: self.gap,
            align: Some(align),
            justify: self.justify,
            wrap: self.wrap,
        }
    }
    pub const fn justify<'a, Next: Copy + crate::IntoProp<'a, Justify>>(
        self,
        justify: Next,
    ) -> Flex<G, A, Next, W> {
        Flex {
            flow: self.flow,
            gap: self.gap,
            align: self.align,
            justify: Some(justify),
            wrap: self.wrap,
        }
    }
    pub const fn wrap<'a, Next: Copy + crate::IntoProp<'a, bool>>(
        self,
        wrap: Next,
    ) -> Flex<G, A, J, Next> {
        Flex {
            flow: self.flow,
            gap: self.gap,
            align: self.align,
            justify: self.justify,
            wrap: Some(wrap),
        }
    }
}
impl<G, A, J, W> sealed::Recipe for Flex<G, A, J, W> {}
impl<G, A, J, W> sealed::Recipe for &Flex<G, A, J, W> {}

/// Closed lowering for typed flow recipes. Applications cannot install recipe
/// callbacks; borrowed forms copy the same original operands into ordinary ports.
#[doc(hidden)]
pub trait FlexRecipe<'a>: sealed::Recipe {
    fn apply_to(self, element: crate::El<'a>) -> crate::El<'a>;
}
impl<'a, G, A, J, W> FlexRecipe<'a> for Flex<G, A, J, W>
where
    G: Copy + crate::IntoProp<'a, f64>,
    A: Copy + crate::IntoProp<'a, Align>,
    J: Copy + crate::IntoProp<'a, Justify>,
    W: Copy + crate::IntoProp<'a, bool>,
{
    fn apply_to(self, mut element: crate::El<'a>) -> crate::El<'a> {
        element = element.flow(self.flow);
        if let Some(gap) = self.gap {
            element = element.gap(gap);
        }
        if let Some(align) = self.align {
            element = element.align(align);
        }
        if let Some(justify) = self.justify {
            element = element.justify(justify);
        }
        if let Some(wrap) = self.wrap {
            element = element.wrap(wrap);
        }
        element
    }
}
impl<'a, G, A, J, W> FlexRecipe<'a> for &Flex<G, A, J, W>
where
    Flex<G, A, J, W>: Copy + FlexRecipe<'a>,
{
    fn apply_to(self, element: crate::El<'a>) -> crate::El<'a> {
        (*self).apply_to(element)
    }
}

#[cfg(test)]
mod recipe_tests {
    use super::*;
    use crate::{Signal, div};
    const TOOLBAR: Flex = Flex::row()
        .gap(8.0)
        .align(Align::Center)
        .justify(Justify::End)
        .wrap(true);
    const INTEGER_GAP: Flex<i32> = Flex::column().gap(8).align(Align::Start).wrap(false);
    #[test]
    fn stable_const_recipes_store_raw_values_with_the_original_literal_floor() {
        assert_eq!(size_of::<Flex>(), 12);
        assert_eq!(size_of::<Flex<i32>>(), 12);
        let draft = div().layout(TOOLBAR).flatten();
        assert_eq!(draft[0].style.gap, 8.0);
        assert_eq!(draft[0].style.align, Align::Center);
        assert!(draft[0].style.wrap);
        let draft = div().layout(INTEGER_GAP).flatten();
        assert_eq!(draft[0].style.flow, Flow::Column);
        assert_eq!(draft[0].style.gap, 8.0);
        assert!(!draft[0].style.wrap);
    }
    #[test]
    #[allow(clippy::needless_borrows_for_generic_args)] // borrowed recipe conformance
    fn dynamic_recipe_stores_only_thin_references_and_lowers_without_recipe_allocation() {
        let gap = Signal::new(8_u64);
        let align = Signal::new(Align::Center);
        let justify = Signal::new(Justify::End);
        let wrap = Signal::new(true);
        let mut recipe = None;
        let count = allocation_counter::measure(|| {
            recipe = Some(
                Flex::row()
                    .gap(&gap)
                    .align(&align)
                    .justify(&justify)
                    .wrap(&wrap),
            )
        });
        assert_eq!(count.count_total, 0);
        let recipe = recipe.unwrap();
        assert_eq!(size_of_val(&recipe), 40);
        fn copy<T: Copy>(_: T) {}
        copy(recipe);
        let draft = div().layout(&recipe).flatten();
        assert_eq!(draft[0].style.gap, 8.0);
        assert_eq!(draft[0].style.align, Align::Center);
        assert_eq!(draft[0].style.justify, Justify::End);
        assert!(draft[0].style.wrap);
    }
}
