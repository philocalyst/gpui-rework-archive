//! Borrowed, closed style operands. Signal references exist only in a View's
//! description; retained fanouts contain owner-qualified fields and sink IDs.
use crate::{
    property::{PropertyError, PropertyErrorKind, PropertyId, PropertyValue, ValueKind},
    source::{ErasedSignal, SourceCodec},
    style::{Affine, Align, Color, Flow, Justify},
};
use gpui_reactivity_state::Signal;
use std::fmt;

#[derive(Clone, Copy, Debug)]
pub(crate) enum Scalar {
    Number(f64),
    Value(PropertyValue),
}

impl Scalar {
    /// Keep the wide IntoLength value until admission: narrowing first would
    /// silently accept a negative subnormal as -0, or infinity from overflow.
    pub(crate) fn admit(self, id: PropertyId) -> Result<PropertyValue, PropertyError> {
        let value = match self {
            Self::Value(value) => value,
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
                let numeric = |value| match id.info().kind {
                    ValueKind::Dimension => PropertyValue::Dimension(Some(value)),
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
        id.validate_erased(value)?;
        Ok(value)
    }
}

pub(crate) struct Binding<'a> {
    pub property: PropertyId,
    pub signal: &'a dyn StyleSignal,
}
pub(crate) struct Draft<'a> {
    pub signal: &'a dyn StyleSignal,
    pub node: u32,
    pub property: PropertyId,
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
    pub trait Input<T> {}
}

/// A library-closed property input. Numeric builders accept every IntoLength
/// primitive; references to literals are copied, while signal inputs are borrowed
/// until synchronous description. Callers cannot install conversion callbacks.
pub trait IntoProp<'a, T>: sealed::Input<T> {
    #[doc(hidden)]
    fn into_prop(self) -> PropInput<'a, T>;
}

/// An opaque borrowed operand, also used by Copy flow recipes.
pub struct PropInput<'a, T>(Operand<'a, T>);
#[derive(Clone, Copy)]
enum Operand<'a, T> {
    Literal(T),
    Signal(&'a dyn StyleSignal),
}
impl<T: Copy> Copy for PropInput<'_, T> {}
impl<T: Copy> Clone for PropInput<'_, T> {
    fn clone(&self) -> Self {
        *self
    }
}
impl<T: PartialEq> PartialEq for PropInput<'_, T> {
    fn eq(&self, other: &Self) -> bool {
        match (&self.0, &other.0) {
            (Operand::Literal(a), Operand::Literal(b)) => a == b,
            (Operand::Signal(a), Operand::Signal(b)) => a.same(*b),
            _ => false,
        }
    }
}
impl<T> sealed::Input<T> for PropInput<'_, T> {}
impl<'a, T> IntoProp<'a, T> for PropInput<'a, T> {
    fn into_prop(self) -> Self {
        self
    }
}
impl<T: fmt::Debug> fmt::Debug for PropInput<'_, T> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match &self.0 {
            Operand::Literal(value) => f.debug_tuple("Literal").field(value).finish(),
            Operand::Signal(_) => f.write_str("Signal(..)"),
        }
    }
}
impl<'a, T> PropInput<'a, T> {
    pub(crate) fn scalar(self) -> Scalar
    where
        T: Value,
    {
        match self.0 {
            Operand::Literal(value) => value.scalar(),
            Operand::Signal(signal) => signal.scalar(),
        }
    }
    pub(crate) fn literal(self) -> Option<T> {
        match self.0 {
            Operand::Literal(value) => Some(value),
            Operand::Signal(_) => None,
        }
    }
    pub(crate) fn signal(self) -> Option<&'a dyn StyleSignal> {
        match self.0 {
            Operand::Literal(_) => None,
            Operand::Signal(signal) => Some(signal),
        }
    }
}

macro_rules! numbers {
    ($($ty:ty => $codec:ident),+ $(,)?) => {$(
        impl Value for $ty {
            const CODEC: SourceCodec = SourceCodec::$codec::<Self>();
            fn scalar(self) -> Scalar { Scalar::Number(crate::IntoLength::into_length(self)) }
        }
        impl sealed::Input<f64> for $ty {}
        impl<'a> IntoProp<'a, f64> for $ty {
            fn into_prop(self) -> PropInput<'a, f64> { PropInput(Operand::Literal(crate::IntoLength::into_length(self))) }
        }
        impl sealed::Input<f64> for &$ty {}
        impl<'a> IntoProp<'a, f64> for &$ty {
            fn into_prop(self) -> PropInput<'a, f64> { (*self).into_prop() }
        }
        impl sealed::Input<f64> for &Signal<$ty> {}
        impl<'a> IntoProp<'a, f64> for &'a Signal<$ty> {
            fn into_prop(self) -> PropInput<'a, f64> { PropInput(Operand::Signal(self)) }
        }
    )+};
}
// Existing text types use the SAME combined descriptor from either port. A
// style-first or text-first install therefore preserves both capabilities.
numbers!(f32 => for_style, f64 => for_value, u8 => for_style,
    u16 => for_style, u32 => for_value, u64 => for_value,
    usize => for_style, i8 => for_style, i16 => for_style,
    i32 => for_value, i64 => for_style, isize => for_style);

// Corner radius preserves its established f32 authoring domain. Unlike the
// pre-existing length builders, literal radius errors are deferred to mount.
impl sealed::Input<f32> for f32 {}
impl<'a> IntoProp<'a, f32> for f32 {
    fn into_prop(self) -> PropInput<'a, f32> {
        PropInput(Operand::Literal(self))
    }
}
impl sealed::Input<f32> for &f32 {}
impl<'a> IntoProp<'a, f32> for &f32 {
    fn into_prop(self) -> PropInput<'a, f32> {
        PropInput(Operand::Literal(*self))
    }
}
impl sealed::Input<f32> for &Signal<f32> {}
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
        impl sealed::Input<$ty> for $ty {}
        impl<'a> IntoProp<'a, $ty> for $ty {
            fn into_prop(self) -> PropInput<'a, $ty> { PropInput(Operand::Literal(self)) }
        }
        impl sealed::Input<$ty> for &$ty {}
        impl<'a> IntoProp<'a, $ty> for &$ty {
            fn into_prop(self) -> PropInput<'a, $ty> { PropInput(Operand::Literal(*self)) }
        }
        impl sealed::Input<$ty> for &Signal<$ty> {}
        impl<'a> IntoProp<'a, $ty> for &'a Signal<$ty> {
            fn into_prop(self) -> PropInput<'a, $ty> { PropInput(Operand::Signal(self)) }
        }
    )+};
}
values!(Color => Color, for_style; Affine => Transform, for_style;
    Flow => Flow, for_style; Align => Align, for_style;
    Justify => Justify, for_style; bool => Flag, for_value);

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
            let style = (&signal).into_prop().signal().unwrap();
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
        let PropertyValue::Dimension(Some(value)) =
            Scalar::Number(-0.0).admit(PropertyId::Width).unwrap()
        else {
            panic!("dimension")
        };
        assert_eq!(value.to_bits(), (-0_f32).to_bits());
    }
}
