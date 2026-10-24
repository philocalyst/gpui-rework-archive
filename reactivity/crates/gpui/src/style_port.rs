//! Borrowed, closed style operands. Signal references exist only in a View's
//! description; retained fanouts contain owner-qualified fields and sink IDs.
use crate::{
    property::{PropertyError, PropertyErrorKind, PropertyId, PropertyValue, ValueKind},
    source::{ErasedSignal, SourceCodec},
    style::{Affine, Align, Color, Flow, Justify, Length},
};
use gpui_reactivity_state::Signal;
use std::fmt;
pub(crate) mod boolean;
pub(crate) use boolean::GroupDraft as BooleanDraft;
pub use boolean::{BoolBinding, BoolColors, BoolState};
mod bindings;
pub(crate) use bindings::MapBindings;

#[derive(Clone, Copy, Debug)]
pub(crate) enum Scalar {
    Number(f64),
    Value(PropertyValue),
    // Checked literal-bank code, emitted only after ordinary recipe lowering.
    ColorSlot(u32),
}

impl Scalar {
    pub(crate) fn admit(self, id: PropertyId) -> Result<PropertyValue, PropertyError> {
        let value = self.narrow(id)?;
        id.validate_erased(value)?;
        Ok(value)
    }

    /// Keep the wide IntoLength value until admission: narrowing first would
    /// silently accept a negative subnormal as -0, or infinity from overflow.
    /// Literal authoring applies the same schema validator without its erased
    /// callback table; dynamic publication uses `admit` above.
    #[inline]
    pub(crate) fn narrow(self, id: PropertyId) -> Result<PropertyValue, PropertyError> {
        let value = match self {
            Self::Value(value) => value,
            Self::ColorSlot(_) => unreachable!("literal color resolved before admission"),
            Self::Number(number) => {
                let reason = if !number.is_finite() {
                    Some(PropertyErrorKind::NonFinite)
                } else if number.abs() > f32::MAX as f64 {
                    Some(PropertyErrorKind::OutOfRange)
                } else {
                    None
                };
                if let Some(reason) = reason {
                    return Err(PropertyError {
                        property: id,
                        reason,
                    });
                }
                let narrowed = number as f32;
                let numeric = |value| match id.value_kind() {
                    ValueKind::Dimension => PropertyValue::Dimension(Length::Points(value)),
                    _ => PropertyValue::Number(value),
                };
                if number < 0.0 && narrowed == 0.0 {
                    // Ask the canonical validator before underflow erases the
                    // sign's magnitude: font-size returns NonPositive, spacing
                    // returns Negative. Signed zero itself remains authored.
                    id.validate_erased(numeric(-f32::MIN_POSITIVE))?;
                }
                numeric(narrowed)
            }
        };
        Ok(value)
    }
}

pub(crate) type Recipe = gpui_inline_call::InlineCall<Option<Scalar>>;

/// A closed property output supported by source maps.
#[allow(private_bounds)]
pub trait MapValue: Value {}
impl<T: Value> MapValue for T {}

/// An owned, small recipe borrowing its source only during description.
/// Maps must be total, deterministic, read-only computations of their input and
/// immutable parameters, with no I/O or external mutable reads. This semantic
/// law matches Source::new; Rust cannot prove purity. Outputs use the existing
/// closed property validators and impacts. Recipes are rebuilt on description.
pub struct Mapped<'a, T, U, F> {
    signal: &'a Signal<T>,
    map: F,
    output: std::marker::PhantomData<fn() -> U>,
}
impl<T, U, F: Copy> Copy for Mapped<'_, T, U, F> {}
impl<T, U, F: Copy> Clone for Mapped<'_, T, U, F> {
    fn clone(&self) -> Self {
        *self
    }
}
impl<'a, T: 'static, U: MapValue, F> Mapped<'a, T, U, F>
where
    F: Fn(&T) -> U + Copy + Send + Sync + 'static,
{
    fn operand(self) -> MapOperand<'a> {
        let map = self.map;
        MapOperand {
            signal: self.signal,
            recipe: Recipe::new(move |input: &dyn std::any::Any| {
                input
                    .downcast_ref::<Signal<T>>()
                    .map(|signal| map(&**signal).scalar())
            }),
        }
    }
}
// The small deferred alternative fits the inline function pointer niche.
// Color endpoints exist only during description; retained selectors carry two
// codes into the existing owner color bank, never a borrowed theme.
#[derive(Clone)]
pub(crate) enum PendingRecipe {
    Inline(Recipe),
    Deferred(DeferredRecipe),
}
// A small cold alternative fits the inline function pointer's existing niche.
// Exceptional large rejection diagnostics retain their complete usize payload.
#[derive(Clone)]
pub(crate) enum DeferredRecipe {
    Rejected { size: u32, alignment: u32 },
    RejectedLarge(Box<gpui_inline_call::TooLarge>),
    Select(Box<ColorSelection>),
}
#[derive(Clone)]
pub(crate) struct ColorSelection {
    build: gpui_inline_call::InlineCall<Result<Recipe, gpui_inline_call::TooLarge>>,
    colors: [Color; 2],
}
impl PendingRecipe {
    fn rejected(error: gpui_inline_call::TooLarge) -> Self {
        Self::Deferred(
            match (u32::try_from(error.size), u32::try_from(error.alignment)) {
                (Ok(size), Ok(alignment)) => DeferredRecipe::Rejected { size, alignment },
                _ => DeferredRecipe::RejectedLarge(Box::new(error)),
            },
        )
    }
    fn deferred_error(error: &DeferredRecipe) -> crate::Error {
        Self::error(match error {
            DeferredRecipe::Rejected { size, alignment } => gpui_inline_call::TooLarge {
                size: *size as usize,
                alignment: *alignment as usize,
            },
            DeferredRecipe::RejectedLarge(error) => **error,
            _ => unreachable!("deferred operand is not a rejection"),
        })
    }
    fn error(error: gpui_inline_call::TooLarge) -> crate::Error {
        crate::Error::MapStorage {
            size: error.size,
            alignment: error.alignment,
        }
    }
    pub(crate) fn scalar(&self, source: &dyn std::any::Any) -> Result<Scalar, crate::Error> {
        match self {
            Self::Inline(recipe) => recipe.call(source).ok_or(crate::Error::MapInput),
            Self::Deferred(
                error @ (DeferredRecipe::Rejected { .. } | DeferredRecipe::RejectedLarge(_)),
            ) => Err(Self::deferred_error(error)),
            Self::Deferred(DeferredRecipe::Select(selection)) => {
                let recipe = selection.build.call(&[0_u32, 1]).map_err(Self::error)?;
                let Some(Scalar::ColorSlot(code)) = recipe.call(source) else {
                    return Err(crate::Error::MapInput);
                };
                Ok(Scalar::Value(PropertyValue::Color(
                    selection.colors[code as usize],
                )))
            }
        }
    }
    pub(crate) fn lower(
        self,
        mut literal: impl FnMut(Color) -> u32,
    ) -> Result<Recipe, crate::Error> {
        match self {
            Self::Inline(recipe) => Ok(recipe),
            Self::Deferred(
                error @ (DeferredRecipe::Rejected { .. } | DeferredRecipe::RejectedLarge(_)),
            ) => Err(Self::deferred_error(&error)),
            Self::Deferred(DeferredRecipe::Select(selection)) => selection
                .build
                .call(&selection.colors.map(&mut literal))
                .map_err(Self::error),
        }
    }
}
#[derive(Clone, Copy)]
pub(crate) struct MapOperand<'a> {
    pub signal: &'a dyn ErasedSignal,
    pub recipe: Result<Recipe, gpui_inline_call::TooLarge>,
}
impl MapOperand<'_> {
    #[cfg(test)]
    pub fn scalar(self) -> Result<Scalar, crate::Error> {
        self.recipe
            .map_err(PendingRecipe::error)?
            .call(self.signal.as_any())
            .ok_or(crate::Error::MapInput)
    }
}
#[derive(Clone)]
pub(crate) struct OwnedMapOperand<'a> {
    pub signal: &'a dyn ErasedSignal,
    pub recipe: PendingRecipe,
}
impl OwnedMapOperand<'_> {
    pub fn scalar(&self) -> Result<Scalar, crate::Error> {
        self.recipe.scalar(self.signal.as_any())
    }
}
impl<'a> From<MapOperand<'a>> for OwnedMapOperand<'a> {
    fn from(value: MapOperand<'a>) -> Self {
        Self {
            signal: value.signal,
            recipe: match value.recipe {
                Ok(recipe) => PendingRecipe::Inline(recipe),
                Err(error) => PendingRecipe::rejected(error),
            },
        }
    }
}
/// A color operand, lowered by the shared foreground/background path. Ordinary
/// property operands remain Copy; explicitly erasing this new owned selection
/// family uses ColorInput, whose descriptor is consumed by the element.
pub struct ColorInput<'a>(ColorOperand<'a>);
pub(crate) enum ColorOperand<'a> {
    Property(PropInput<'a, Color>),
    Selection(OwnedMapOperand<'a>),
    Boolean(BoolColors<'a>),
}
impl<'a> ColorInput<'a> {
    pub(crate) fn operand(self) -> ColorOperand<'a> {
        self.0
    }
}
/// The closed solid-color input family, including typed boolean selections.
pub trait IntoColor<'a>: sealed::ColorInput {
    #[doc(hidden)]
    fn into_color(self) -> ColorInput<'a>;
    #[doc(hidden)]
    fn apply_color(self, element: crate::El<'a>, foreground: bool) -> crate::El<'a>
    where
        Self: Sized,
    {
        element.color_operand(self.into_color(), foreground)
    }
}
impl<'a, I: IntoProp<'a, Color>> sealed::ColorInput for I {}
impl<'a, I: IntoProp<'a, Color>> IntoColor<'a> for I {
    fn into_color(self) -> ColorInput<'a> {
        ColorInput(ColorOperand::Property(self.into_prop()))
    }
    #[inline]
    fn apply_color(self, mut element: crate::El<'a>, foreground: bool) -> crate::El<'a> {
        element.color_property(self, foreground);
        element
    }
}
impl sealed::ColorInput for ColorInput<'_> {}
impl<'a> IntoColor<'a> for ColorInput<'a> {
    fn into_color(self) -> Self {
        self
    }
}
/// A concrete, Copy selection recipe. Its palette is owned by value until the
/// element consumes it; it never retains a borrow of an application theme.
pub struct SelectedColors<'a, T, F> {
    signal: &'a Signal<T>,
    map: F,
    colors: [Color; 2],
}
impl<T, F: Copy> Copy for SelectedColors<'_, T, F> {}
impl<T, F: Copy> Clone for SelectedColors<'_, T, F> {
    fn clone(&self) -> Self {
        *self
    }
}
impl<T, F> sealed::ColorInput for SelectedColors<'_, T, F> {}
impl<'a, T: 'static, F> IntoColor<'a> for SelectedColors<'a, T, F>
where
    F: Fn(&T) -> bool + Copy + Send + Sync + 'static,
{
    fn into_color(self) -> ColorInput<'a> {
        let map = self.map;
        let build = gpui_inline_call::InlineCall::new(move |input: &dyn std::any::Any| {
            let codes = *input
                .downcast_ref::<[u32; 2]>()
                .expect("internal palette pair");
            Recipe::new(move |input: &dyn std::any::Any| {
                input
                    .downcast_ref::<Signal<T>>()
                    .map(|signal| Scalar::ColorSlot(codes[usize::from(map(&**signal))]))
            })
        });
        let recipe = match build {
            Ok(build) => {
                PendingRecipe::Deferred(DeferredRecipe::Select(Box::new(ColorSelection {
                    build,
                    colors: self.colors,
                })))
            }
            Err(error) => PendingRecipe::rejected(error),
        };
        ColorInput(ColorOperand::Selection(OwnedMapOperand {
            signal: self.signal,
            recipe,
        }))
    }
}
/// Allocation-free source mapping. The concrete mapper remains typed until an
/// element consumes the operand. Its final capture must fit sixteen bytes with
/// alignment at most eight; admission rejects larger recipes without fallback.
pub trait SignalMap<T> {
    fn map<U: MapValue, F>(&self, map: F) -> Mapped<'_, T, U, F>
    where
        F: Fn(&T) -> U + Copy + Send + Sync + 'static;
    fn map_with<P, U: MapValue, F>(
        &self,
        parameter: P,
        map: F,
    ) -> Mapped<'_, T, U, impl Fn(&T) -> U + Copy + Send + Sync + 'static>
    where
        P: Copy + Send + Sync + 'static,
        F: Fn(&T, P) -> U + Copy + Send + Sync + 'static;
}
impl<T: 'static> SignalMap<T> for Signal<T> {
    fn map<U: MapValue, F>(&self, map: F) -> Mapped<'_, T, U, F>
    where
        F: Fn(&T) -> U + Copy + Send + Sync + 'static,
    {
        Mapped {
            signal: self,
            map,
            output: std::marker::PhantomData,
        }
    }
    fn map_with<P, U: MapValue, F>(
        &self,
        parameter: P,
        map: F,
    ) -> Mapped<'_, T, U, impl Fn(&T) -> U + Copy + Send + Sync + 'static>
    where
        P: Copy + Send + Sync + 'static,
        F: Fn(&T, P) -> U + Copy + Send + Sync + 'static,
    {
        self.map(move |value| map(value, parameter))
    }
}
/// A boolean operand that can also select owned semantic palette tokens.
/// Literal selection is free. Dynamic endpoints are interned in the ordinary
/// owner color bank during lowering. Direct typed selections are independent
/// destinations and include their two palette codes in the capture budget.
/// BoolBinding explicitly shares a full boolean recipe across semantic and
/// palette members; its endpoint codes do not consume that recipe's budget.
pub trait BoolInput<'a>: IntoProp<'a, bool> + Copy {
    fn select(self, when_false: Color, when_true: Color) -> impl IntoColor<'a> + Copy;
}
impl<'a> BoolInput<'a> for bool {
    fn select(self, when_false: Color, when_true: Color) -> impl IntoColor<'a> + Copy {
        if self { when_true } else { when_false }
    }
}
impl<'a> BoolInput<'a> for &bool {
    fn select(self, when_false: Color, when_true: Color) -> impl IntoColor<'a> + Copy {
        (*self).select(when_false, when_true)
    }
}
impl<'a> BoolInput<'a> for &'a Signal<bool> {
    fn select(self, when_false: Color, when_true: Color) -> impl IntoColor<'a> + Copy {
        SelectedColors {
            signal: self,
            map: |value: &bool| *value,
            colors: [when_false, when_true],
        }
    }
}
impl<'a, T: 'static, F> BoolInput<'a> for Mapped<'a, T, bool, F>
where
    F: Fn(&T) -> bool + Copy + Send + Sync + 'static,
{
    fn select(self, when_false: Color, when_true: Color) -> impl IntoColor<'a> + Copy {
        SelectedColors {
            signal: self.signal,
            map: self.map,
            colors: [when_false, when_true],
        }
    }
}
/// Private destination tags share the existing two-byte binding slot. Control
/// state is intrinsic semantics, not an inspector style-property declaration.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub(crate) struct Sink(u16);
impl Sink {
    pub const CHECKED: Self = Self(0x8000);
    pub const DISABLED: Self = Self(0x8001);
    pub const INVALID: Self = Self(0x8002);
    pub fn property(self) -> Option<PropertyId> {
        PropertyId::from_code(self.0)
    }
    pub fn control_code(self) -> u16 {
        assert!(self.property().is_none());
        self.0 - 0x7fff
    }
    pub fn control(code: u16) -> Option<Self> {
        match code {
            1 => Some(Self::CHECKED),
            2 => Some(Self::DISABLED),
            3 => Some(Self::INVALID),
            _ => None,
        }
    }
    pub fn admit(self, scalar: Scalar) -> Result<PropertyValue, crate::Error> {
        if let Some(id) = self.property() {
            return Ok(scalar.admit(id)?);
        }
        match scalar {
            Scalar::Value(value @ PropertyValue::Flag(_)) => Ok(value),
            _ => Err(crate::Error::MapInput),
        }
    }
}
impl From<PropertyId> for Sink {
    fn from(id: PropertyId) -> Self {
        Self(id as u16)
    }
}
pub(crate) struct MapBinding<'a> {
    pub sink: Sink,
    pub operand: OwnedMapOperand<'a>,
}
pub(crate) struct MapDraft<'a> {
    pub node: u32,
    pub sink: Sink,
    pub value: PropertyValue,
    pub operand: OwnedMapOperand<'a>,
}

pub(crate) struct Binding<'a> {
    pub sink: Sink,
    pub signal: &'a dyn StyleSignal,
}
pub(crate) struct Draft<'a> {
    pub signal: &'a dyn StyleSignal,
    pub node: u32,
    pub sink: Sink,
}

pub(crate) trait Value: Copy + 'static {
    const CODEC: SourceCodec;
    fn scalar(self) -> Scalar;
}

pub(crate) trait StyleSignal: ErasedSignal {
    fn scalar(&self) -> Scalar;
    fn codec(&self) -> SourceCodec;
}
impl<T: Value> StyleSignal for Signal<T> {
    fn scalar(&self) -> Scalar {
        (**self).scalar()
    }
    fn codec(&self) -> SourceCodec {
        T::CODEC
    }
}

mod sealed {
    pub trait ColorInput {}
    // A literal's type makes source installation unreachable. Explicitly
    // erased inputs and signals still use the operand match.
    pub trait Input<T> {
        const IS_LITERAL: bool;
    }
}

/// A library-closed property input. Numeric builders accept every IntoLength
/// primitive; references to literals are copied, while signal inputs are borrowed
/// until synchronous description. Typed maps may compute these closed property
/// values; callers cannot replace setters, validators, or impacts.
pub trait IntoProp<'a, T>: sealed::Input<T> {
    #[doc(hidden)]
    fn into_prop(self) -> PropInput<'a, T>;
}

/// An opaque operand for explicitly erasing the literal/signal input form.
#[derive(Clone, Copy)]
pub struct PropInput<'a, T>(Operand<'a, T>);
#[derive(Clone, Copy)]
enum Operand<'a, T> {
    Literal(T),
    // Numeric dimensions retain their wide author value until admission. This
    // is a real operand, never a NaN/signed-zero encoding in a Length value.
    Number(f64),
    Signal(&'a dyn StyleSignal),
    Mapped(MapOperand<'a>),
    Boolean { id: u64 },
}
impl<T: PartialEq> PartialEq for PropInput<'_, T> {
    fn eq(&self, other: &Self) -> bool {
        match (&self.0, &other.0) {
            (Operand::Literal(a), Operand::Literal(b)) => a == b,
            (Operand::Number(a), Operand::Number(b)) => a == b,
            (Operand::Signal(a), Operand::Signal(b)) => a.same(*b),
            _ => false,
        }
    }
}
impl<T> sealed::Input<T> for PropInput<'_, T> {
    const IS_LITERAL: bool = false;
}
impl<'a, T> IntoProp<'a, T> for PropInput<'a, T> {
    fn into_prop(self) -> Self {
        self
    }
}
impl<T: fmt::Debug> fmt::Debug for PropInput<'_, T> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match &self.0 {
            Operand::Literal(value) => f.debug_tuple("Literal").field(value).finish(),
            Operand::Number(value) => f.debug_tuple("Number").field(value).finish(),
            Operand::Signal(_) => f.write_str("Signal(..)"),
            Operand::Mapped(_) => f.write_str("Mapped(..)"),
            Operand::Boolean { .. } => f.write_str("Boolean(..)"),
        }
    }
}
impl<'a, T> PropInput<'a, T> {
    #[cfg(test)]
    pub(crate) fn scalar(self) -> Scalar
    where
        T: Value,
    {
        match self.0 {
            Operand::Literal(value) => value.scalar(),
            Operand::Number(value) => Scalar::Number(value),
            Operand::Signal(signal) => signal.scalar(),
            Operand::Mapped(map) => map.scalar().expect("valid mapped operand"),
            Operand::Boolean { .. } => unreachable!("boolean member resolved by description"),
        }
    }
    pub(crate) fn literal(&self) -> Option<T>
    where
        T: Copy,
    {
        match &self.0 {
            Operand::Literal(value) => Some(*value),
            Operand::Number(_)
            | Operand::Signal(_)
            | Operand::Mapped(_)
            | Operand::Boolean { .. } => None,
        }
    }
    pub(crate) fn literal_scalar(&self) -> Option<Scalar>
    where
        T: Value,
    {
        match &self.0 {
            Operand::Literal(value) => Some(value.scalar()),
            Operand::Number(value) => Some(Scalar::Number(*value)),
            Operand::Signal(_) | Operand::Mapped(_) | Operand::Boolean { .. } => None,
        }
    }
    pub(crate) fn mapped(self) -> Option<MapOperand<'a>> {
        match self.0 {
            Operand::Mapped(map) => Some(map),
            _ => None,
        }
    }
    pub(crate) fn signal(&self) -> Option<&'a dyn StyleSignal> {
        match &self.0 {
            Operand::Literal(_)
            | Operand::Number(_)
            | Operand::Mapped(_)
            | Operand::Boolean { .. } => None,
            Operand::Signal(signal) => Some(*signal),
        }
    }
}

impl<T, U, F> sealed::Input<U> for Mapped<'_, T, U, F> {
    const IS_LITERAL: bool = false;
}
impl<'a, T: 'static, U: MapValue, F> IntoProp<'a, U> for Mapped<'a, T, U, F>
where
    F: Fn(&T) -> U + Copy + Send + Sync + 'static,
{
    fn into_prop(self) -> PropInput<'a, U> {
        PropInput(Operand::Mapped(self.operand()))
    }
}
macro_rules! numbers {
    ($($ty:ty => $codec:ident),+ $(,)?) => {$(
        impl Value for $ty {
            const CODEC: SourceCodec = SourceCodec::$codec::<Self>();
            fn scalar(self) -> Scalar { Scalar::Number(crate::IntoLength::into_length(self)) }
        }
        impl sealed::Input<f64> for $ty { const IS_LITERAL: bool = true; }
        impl<'a> IntoProp<'a, f64> for $ty {
            fn into_prop(self) -> PropInput<'a, f64> { PropInput(Operand::Literal(crate::IntoLength::into_length(self))) }
        }
        impl sealed::Input<f64> for &$ty { const IS_LITERAL: bool = true; }
        impl<'a> IntoProp<'a, f64> for &$ty {
            fn into_prop(self) -> PropInput<'a, f64> { (*self).into_prop() }
        }
        impl sealed::Input<f64> for &Signal<$ty> { const IS_LITERAL: bool = false; }
        impl<'a> IntoProp<'a, f64> for &'a Signal<$ty> {
            fn into_prop(self) -> PropInput<'a, f64> { PropInput(Operand::Signal(self)) }
        }
        impl sealed::Input<Length> for $ty { const IS_LITERAL: bool = true; }
        impl<'a> IntoProp<'a, Length> for $ty {
            fn into_prop(self) -> PropInput<'a, Length> { PropInput(Operand::Number(crate::IntoLength::into_length(self))) }
        }
        impl sealed::Input<Length> for &$ty { const IS_LITERAL: bool = true; }
        impl<'a> IntoProp<'a, Length> for &$ty {
            fn into_prop(self) -> PropInput<'a, Length> { (*self).into_prop() }
        }
        impl sealed::Input<Length> for &Signal<$ty> { const IS_LITERAL: bool = false; }
        impl<'a> IntoProp<'a, Length> for &'a Signal<$ty> {
            fn into_prop(self) -> PropInput<'a, Length> { PropInput(Operand::Signal(self)) }
        }
    )+};
}
// Existing text types use the SAME combined descriptor from either port. A
// style-first or text-first install therefore preserves both capabilities.
numbers!(f32 => for_style, f64 => for_value, u8 => for_style,
    u16 => for_style, u32 => for_value, u64 => for_value,
    usize => for_style, i8 => for_style, i16 => for_style,
    i32 => for_value, i64 => for_style, isize => for_style);

macro_rules! mapped_numbers {
    ($($ty:ty),+ $(,)?) => {$(
        impl<T, F> sealed::Input<f64> for Mapped<'_, T, $ty, F> { const IS_LITERAL: bool = false; }
        impl<'a, T: 'static, F> IntoProp<'a, f64> for Mapped<'a, T, $ty, F> where F: Fn(&T) -> $ty + Copy + Send + Sync + 'static {
            fn into_prop(self) -> PropInput<'a, f64> { PropInput(Operand::Mapped(self.operand())) }
        }
    )+};
}
mapped_numbers!(f32, u8, u16, u32, u64, usize, i8, i16, i32, i64, isize);

macro_rules! mapped_dimensions {
    ($($ty:ty),+ $(,)?) => {$(
        impl<T, F> sealed::Input<Length> for Mapped<'_, T, $ty, F> { const IS_LITERAL: bool = false; }
        impl<'a, T: 'static, F> IntoProp<'a, Length> for Mapped<'a, T, $ty, F> where F: Fn(&T) -> $ty + Copy + Send + Sync + 'static {
            fn into_prop(self) -> PropInput<'a, Length> { PropInput(Operand::Mapped(self.operand())) }
        }
    )+};
}
mapped_dimensions!(f32, f64, u8, u16, u32, u64, usize, i8, i16, i32, i64, isize);

impl sealed::Input<Length> for PropInput<'_, f64> {
    const IS_LITERAL: bool = false;
}
impl<'a> IntoProp<'a, Length> for PropInput<'a, f64> {
    fn into_prop(self) -> PropInput<'a, Length> {
        PropInput(match self.0 {
            Operand::Literal(value) | Operand::Number(value) => Operand::Number(value),
            Operand::Signal(signal) => Operand::Signal(signal),
            Operand::Mapped(map) => Operand::Mapped(map),
            Operand::Boolean { .. } => unreachable!("numeric operand cannot be boolean"),
        })
    }
}

// Corner radius preserves its established f32 authoring domain. Unlike the
// pre-existing length builders, literal radius errors are deferred to mount.
impl sealed::Input<f32> for f32 {
    const IS_LITERAL: bool = true;
}
impl<'a> IntoProp<'a, f32> for f32 {
    fn into_prop(self) -> PropInput<'a, f32> {
        PropInput(Operand::Literal(self))
    }
}
impl sealed::Input<f32> for &f32 {
    const IS_LITERAL: bool = true;
}
impl<'a> IntoProp<'a, f32> for &f32 {
    fn into_prop(self) -> PropInput<'a, f32> {
        PropInput(Operand::Literal(*self))
    }
}
impl sealed::Input<f32> for &Signal<f32> {
    const IS_LITERAL: bool = false;
}
impl<'a> IntoProp<'a, f32> for &'a Signal<f32> {
    fn into_prop(self) -> PropInput<'a, f32> {
        PropInput(Operand::Signal(self))
    }
}

macro_rules! values {
    ($($ty:ty => $variant:ident, $codec:ident);+ $(;)?) => {$(
        impl Value for $ty {
            const CODEC: SourceCodec = SourceCodec::$codec::<Self>();
            fn scalar(self) -> Scalar { Scalar::Value(PropertyValue::$variant(self)) }
        }
        impl sealed::Input<$ty> for $ty { const IS_LITERAL: bool = true; }
        impl<'a> IntoProp<'a, $ty> for $ty {
            fn into_prop(self) -> PropInput<'a, $ty> { PropInput(Operand::Literal(self)) }
        }
        impl sealed::Input<$ty> for &$ty { const IS_LITERAL: bool = true; }
        impl<'a> IntoProp<'a, $ty> for &$ty {
            fn into_prop(self) -> PropInput<'a, $ty> { PropInput(Operand::Literal(*self)) }
        }
        impl sealed::Input<$ty> for &Signal<$ty> { const IS_LITERAL: bool = false; }
        impl<'a> IntoProp<'a, $ty> for &'a Signal<$ty> {
            fn into_prop(self) -> PropInput<'a, $ty> { PropInput(Operand::Signal(self)) }
        }
    )+};
}
values!(Color => Color, for_style; Affine => Transform, for_style;
    Flow => Flow, for_style; Align => Align, for_style;
    Justify => Justify, for_style; bool => Flag, for_value;
    Length => Dimension, for_style);

#[cfg(test)]
mod tests {
    use super::*;
    use crate::source::{FieldId, IntoText, Needs};
    use std::mem::size_of;

    fn number(input: impl IntoProp<'static, f64>) -> f64 {
        match input.into_prop().scalar() {
            Scalar::Number(value) => value,
            _ => panic!("numeric operand"),
        }
    }
    #[test]
    fn all_length_primitives_and_borrowed_literals_keep_into_length_conversion() {
        macro_rules! check { ($($ty:ty),+) => {$(
            let value = 3 as $ty;
            assert_eq!(number(value).to_bits(), crate::IntoLength::into_length(value).to_bits());
            assert_eq!(number(&value).to_bits(), number(value).to_bits());
            let signal = Signal::new(value);
            let input: PropInput<'_,f64> = (&signal).into_prop();
            match input.scalar() {
                Scalar::Number(got) => assert_eq!(got.to_bits(), number(value).to_bits()),
                _ => panic!("numeric signal"),
            }
            let operand = input.signal().unwrap();
            let frozen = operand.codec().freeze(operand.as_any(),FieldId::new(1),Needs{text:false,style:true}).unwrap();
            assert!(matches!(frozen.style,Some(Scalar::Number(got)) if got.to_bits()==number(value).to_bits()));
        )+}; }
        check!(f32, f64, u8, u16, u32, u64, usize, i8, i16, i32, i64, isize);
        assert_eq!(number(-0_f64).to_bits(), (-0_f64).to_bits());
        assert_eq!(number(f64::MAX).to_bits(), f64::MAX.to_bits());
        assert!(number(f64::NAN).is_nan());
    }

    #[test]
    fn numeric_text_and_style_install_orders_share_both_capabilities() {
        macro_rules! check { ($($ty:ty),+) => {$(
            let signal = Signal::new(12 as $ty);
            let text = (&signal).into_text();
            let input: PropInput<'_, f64> = (&signal).into_prop();
            let style = input.signal().unwrap();
            for codec in [text.codec().unwrap(), style.codec()] {
                let frozen = codec.freeze(style.as_any(), FieldId::new(7), Needs { text: true, style: true }).unwrap();
                assert_eq!(frozen.text.as_deref(), Some("12"));
                assert!(matches!(frozen.style, Some(Scalar::Number(12.0))));
            }
        )+}; }
        check!(u32, u64, i32, f64);
        assert_eq!(size_of::<SourceCodec>(), size_of::<usize>());
    }

    #[test]
    fn style_only_descriptor_checks_type_and_never_fabricates_text() {
        let color = Signal::new(Color::WHITE);
        let style = (&color).into_prop().signal().unwrap();
        let codec = style.codec();
        let id = FieldId::new(3);
        let frozen = codec
            .freeze(
                style.as_any(),
                id,
                Needs {
                    text: false,
                    style: true,
                },
            )
            .unwrap();
        assert!(frozen.text.is_none());
        assert!(
            matches!(frozen.style, Some(Scalar::Value(PropertyValue::Color(value))) if value == Color::WHITE)
        );
        assert!(
            codec
                .freeze(
                    style.as_any(),
                    id,
                    Needs {
                        text: true,
                        style: true
                    }
                )
                .is_err()
        );
        let wrong = Signal::new(1_f64);
        assert!(
            codec
                .freeze(
                    &wrong,
                    id,
                    Needs {
                        text: false,
                        style: true
                    }
                )
                .is_err()
        );
    }
}

#[cfg(test)]
mod admission_tests {
    use super::*;
    #[test]
    fn wide_numeric_admission_preserves_range_sign_and_canonical_property_errors() {
        use PropertyErrorKind::*;
        for (value, id, reason) in [
            (f64::NAN, PropertyId::Width, NonFinite),
            (f64::INFINITY, PropertyId::Width, NonFinite),
            (f64::MAX, PropertyId::Width, OutOfRange),
            (-1.0, PropertyId::Width, Negative),
            (-f64::MIN_POSITIVE, PropertyId::Width, Negative),
            (-f64::MIN_POSITIVE, PropertyId::FontSize, NonPositive),
            (f64::MIN_POSITIVE, PropertyId::FontSize, NonPositive),
            (0.0, PropertyId::FontSize, NonPositive),
        ] {
            assert_eq!(Scalar::Number(value).admit(id).unwrap_err().reason, reason);
        }
        let PropertyValue::Dimension(crate::Length::Points(value)) =
            Scalar::Number(-0.0).admit(PropertyId::Width).unwrap()
        else {
            panic!("dimension")
        };
        assert_eq!(value.to_bits(), (-0_f32).to_bits());
    }
}

#[cfg(test)]
mod binding_storage_tests {
    use super::*;
    #[test]
    fn deferred_selections_preserve_existing_operands_and_full_rejection_payloads() {
        assert_eq!(size_of::<Recipe>(), 24);
        assert_eq!(size_of::<PendingRecipe>(), 24);
        assert_eq!(size_of::<MapOperand<'_>>(), 40);
        assert_eq!(size_of::<OwnedMapOperand<'_>>(), 40);
        assert_eq!(size_of::<MapBinding<'_>>(), 48);
        assert_eq!(size_of::<MapDraft<'_>>(), 80);
        assert_eq!(size_of::<PropertyValue>(), 28);
        assert_eq!(size_of::<ColorSelection>(), 56);
        for (size, alignment) in [(20, 4), (usize::MAX, 1), (1, usize::MAX)] {
            let expected = crate::Error::MapStorage { size, alignment };
            let pending = PendingRecipe::rejected(gpui_inline_call::TooLarge { size, alignment });
            assert_eq!(pending.scalar(&()).unwrap_err(), expected);
            assert_eq!(pending.lower(|_| unreachable!()).err(), Some(expected));
        }
    }
}
