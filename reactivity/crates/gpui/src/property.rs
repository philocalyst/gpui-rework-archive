//! Library-owned typed style declarations. A selector is one immutable schema
//! reference; callers cannot supply a setter, validator or impact claim.
//! Contributions retain presence separately from resolved destination equality.

use crate::style::{Affine, Color, Flow, Style};
use std::fmt;

/// Inclusive ceilings: Geometry includes hit/bounds/damage/paint; Layout also
/// includes geometry and paint. Destination equality may cut off concrete work.
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub enum Impact {
    Paint,
    Geometry,
    Layout,
}

/// Stable explicit IDs within GPUI's style schema; never Rust field positions.
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord, Hash)]
#[repr(u16)]
pub enum PropertyId {
    Width = 1,
    Height = 2,
    Gap = 3,
    Padding = 4,
    FontSize = 5,
    Foreground = 6,
    Background = 7,
    Flow = 8,
    Transform = 9,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum ValueKind {
    Dimension,
    Number,
    Color,
    Flow,
    Transform,
}

#[derive(Debug)]
pub struct PropertyInfo {
    pub id: PropertyId,
    pub name: &'static str,
    pub kind: ValueKind,
    pub impact: Impact,
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub enum Contribution<T> {
    #[default]
    Inherit,
    Set(T),
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct PropertyError {
    pub property: PropertyId,
    pub reason: PropertyErrorKind,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum PropertyErrorKind {
    NonFinite,
    Negative,
    NonPositive,
    WrongKind {
        expected: ValueKind,
        actual: ValueKind,
    },
}
impl fmt::Display for PropertyError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "style property {:?}: {:?}", self.property, self.reason)
    }
}
impl std::error::Error for PropertyError {}

struct Declaration<T> {
    info: PropertyInfo,
    get: fn(&Style) -> T,
    put: fn(&mut Style, T),
    validate: fn(&T) -> Result<(), PropertyErrorKind>,
}

/// A closed typed selector. Get/set share the declaration used by reflection.
/// Width/height use `Option<f32>`: `None` means explicit automatic sizing.
///
/// ```compile_fail,E0423
/// use gpui::property::Property;
/// let forged = Property::<f32>(());
/// ```
///
/// ```compile_fail,E0308
/// use gpui::property::{WIDTH, FOREGROUND};
/// let mut style = Default::default();
/// WIDTH.set(&mut style, FOREGROUND.default_value()).unwrap();
/// ```
pub struct Property<T: 'static>(&'static Declaration<T>);
impl<T> Copy for Property<T> {}
impl<T> Clone for Property<T> {
    fn clone(&self) -> Self {
        *self
    }
}
impl<T> fmt::Debug for Property<T> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        self.info().fmt(f)
    }
}
impl<T> Property<T> {
    pub const fn info(self) -> &'static PropertyInfo {
        &self.0.info
    }
    pub const fn id(self) -> PropertyId {
        self.0.info.id
    }
    pub fn get(self, style: &Style) -> T {
        (self.0.get)(style)
    }
    /// Read the existing library default, without a second table of defaults.
    pub fn default_value(self) -> T {
        self.get(&Style::default())
    }
    pub fn validate(self, value: &T) -> Result<(), PropertyError> {
        (self.0.validate)(value).map_err(|reason| PropertyError {
            property: self.id(),
            reason,
        })
    }
    /// Resolve presence without conflating Set(default) with Inherit. A runtime
    /// must retain the original contribution even if its destination is equal.
    pub fn resolve(self, contribution: Contribution<T>, inherited: T) -> Result<T, PropertyError> {
        let value = match contribution {
            Contribution::Inherit => inherited,
            Contribution::Set(value) => value,
        };
        self.validate(&value)?;
        Ok(value)
    }
    /// Validate before editing. False means the resolved destination is equal;
    /// it says nothing about contribution presence or provenance.
    pub fn set(self, style: &mut Style, value: T) -> Result<bool, PropertyError>
    where
        T: PartialEq,
    {
        self.validate(&value)?;
        if self.get(style) == value {
            return Ok(false);
        }
        (self.0.put)(style, value);
        Ok(true)
    }
}

fn nonnegative(value: &f32) -> Result<(), PropertyErrorKind> {
    if !value.is_finite() {
        Err(PropertyErrorKind::NonFinite)
    } else if *value < 0.0 {
        Err(PropertyErrorKind::Negative)
    } else {
        Ok(())
    }
}
fn dimension(value: &Option<f32>) -> Result<(), PropertyErrorKind> {
    value.as_ref().map_or(Ok(()), nonnegative)
}
fn font_size(value: &f32) -> Result<(), PropertyErrorKind> {
    if !value.is_finite() {
        Err(PropertyErrorKind::NonFinite)
    } else if *value <= 0.0 {
        Err(PropertyErrorKind::NonPositive)
    } else {
        Ok(())
    }
}

// This closed declaration list also generates the catalog and erased dispatch.
// Applications provide neither callbacks nor macros.
macro_rules! properties {
    ($($name:ident, $decl:ident, $ty:ty, $id:ident, $text:literal, $kind:ident, $impact:ident, $field:ident, $validate:expr);+ $(;)?) => {
        $(static $decl: Declaration<$ty> = Declaration {
            info: PropertyInfo { id: PropertyId::$id, name: $text, kind: ValueKind::$kind, impact: Impact::$impact },
            get: |style| style.$field,
            put: |style, value| style.$field = value,
            validate: $validate,
        };
        pub const $name: Property<$ty> = Property(&$decl);)+
        /// References to the same declaration metadata as the typed selectors.
        pub static PROPERTIES: &[&PropertyInfo] = &[$($name.info()),+];
        impl PropertyId {
            pub const fn info(self) -> &'static PropertyInfo {
                match self { $(Self::$id => $name.info()),+ }
            }
            pub(crate) fn get_erased(self, style: &Style) -> PropertyValue {
                match self { $(Self::$id => PropertyValue::$kind($name.get(style))),+ }
            }
            pub(crate) fn set_erased(self, style: &mut Style, value: PropertyValue) -> Result<bool, PropertyError> {
                match (self, value) {
                    $((Self::$id, PropertyValue::$kind(value)) => $name.set(style, value),)+
                    _ => Err(PropertyError { property: self, reason: PropertyErrorKind::WrongKind { expected: self.info().kind, actual: value.kind() } }),
                }
            }
        }
    };
}
fn finite_transform(value: &Affine) -> Result<(), PropertyErrorKind> {
    if value.is_finite() {
        Ok(())
    } else {
        Err(PropertyErrorKind::NonFinite)
    }
}
// Color's private fields and checked constructors already guarantee finite,
// valid tagged color values, including extended RGB; do not clip them here.
properties! {
    WIDTH, WIDTH_DECL, Option<f32>, Width, "width", Dimension, Layout, width, dimension;
    HEIGHT, HEIGHT_DECL, Option<f32>, Height, "height", Dimension, Layout, height, dimension;
    GAP, GAP_DECL, f32, Gap, "gap", Number, Layout, gap, nonnegative;
    PADDING, PADDING_DECL, f32, Padding, "padding", Number, Layout, padding, nonnegative;
    FONT_SIZE, FONT_SIZE_DECL, f32, FontSize, "font_size", Number, Layout, font_size, font_size;
    FOREGROUND, FOREGROUND_DECL, Color, Foreground, "foreground", Color, Paint, fg, |_| Ok(());
    BACKGROUND, BACKGROUND_DECL, Color, Background, "background", Color, Paint, bg, |_| Ok(());
    FLOW, FLOW_DECL, Flow, Flow, "flow", Flow, Layout, flow, |_| Ok(());
    TRANSFORM, TRANSFORM_DECL, Affine, Transform, "transform", Transform, Geometry, transform, finite_transform;
}

/// Closed inspector seam. No boxed erased values, type IDs or external setters.
#[derive(Clone, Copy, Debug, PartialEq)]
pub(crate) enum PropertyValue {
    Dimension(Option<f32>),
    Number(f32),
    Color(Color),
    Flow(Flow),
    Transform(Affine),
}
impl PropertyValue {
    pub(crate) fn kind(self) -> ValueKind {
        match self {
            Self::Dimension(_) => ValueKind::Dimension,
            Self::Number(_) => ValueKind::Number,
            Self::Color(_) => ValueKind::Color,
            Self::Flow(_) => ValueKind::Flow,
            Self::Transform(_) => ValueKind::Transform,
        }
    }
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn contribution_presence_survives_destination_equality_and_auto_is_explicit() {
        let mut style = Style::default();
        let auto = Contribution::Set(None);
        assert_ne!(auto, Contribution::Inherit);
        assert_eq!(WIDTH.resolve(auto, Some(40.0)), Ok(None));
        assert_eq!(
            WIDTH.resolve(Contribution::Inherit, Some(40.0)),
            Ok(Some(40.0))
        );
        assert!(
            !WIDTH
                .set(&mut style, WIDTH.resolve(auto, Some(40.0)).unwrap())
                .unwrap()
        );
        assert_eq!(auto, Contribution::Set(None));
        let same = Contribution::Set(8.0);
        assert_eq!(PADDING.resolve(same, 8.0), Ok(8.0));
        assert_eq!(PADDING.resolve(same, 10.0), Ok(8.0));
        assert_eq!(PADDING.resolve(Contribution::Inherit, 10.0), Ok(10.0));
        assert!(
            WIDTH
                .resolve(Contribution::Inherit, Some(f32::NAN))
                .is_err()
        );
    }

    #[test]
    fn invalid_typed_and_erased_edits_leave_all_fields_unchanged() {
        let mut style = Style::default();
        for invalid in [f32::NAN, f32::INFINITY, -1.0] {
            let before = style;
            assert!(WIDTH.set(&mut style, Some(invalid)).is_err());
            assert!(GAP.set(&mut style, invalid).is_err());
            assert!(PADDING.set(&mut style, invalid).is_err());
            assert!(
                PropertyId::Height
                    .set_erased(&mut style, PropertyValue::Dimension(Some(invalid)))
                    .is_err()
            );
            assert_eq!(style, before);
        }
        for invalid in [0.0, -0.0, -1.0, f32::NAN, f32::INFINITY] {
            assert!(FONT_SIZE.set(&mut style, invalid).is_err());
        }
        // Author-domain validation is distinct from a particular text backend cap.
        assert!(FONT_SIZE.set(&mut style, 513.0).unwrap());
        let before = style;
        assert!(
            TRANSFORM
                .set(
                    &mut style,
                    Affine {
                        tx: f32::NAN,
                        ..Affine::IDENTITY
                    }
                )
                .is_err()
        );
        assert_eq!(style, before);
        let error = PropertyId::Width
            .set_erased(&mut style, PropertyValue::Color(Color::BLACK))
            .unwrap_err();
        assert_eq!(
            error.reason,
            PropertyErrorKind::WrongKind {
                expected: ValueKind::Dimension,
                actual: ValueKind::Color
            }
        );
        assert_eq!(style, before);
    }

    #[test]
    fn catalog_metadata_is_the_typed_declaration_and_ceilings_are_library_owned() {
        assert_eq!(std::mem::size_of_val(&WIDTH), std::mem::size_of::<usize>());
        assert_eq!(PROPERTIES.len(), 9);
        for (index, info) in PROPERTIES.iter().enumerate() {
            assert!(!info.name.is_empty());
            assert!(std::ptr::eq(*info, info.id.info()));
            assert!(
                !PROPERTIES[..index]
                    .iter()
                    .any(|previous| previous.id == info.id || previous.name == info.name)
            );
            let expected = match info.id {
                PropertyId::Foreground | PropertyId::Background => Impact::Paint,
                PropertyId::Transform => Impact::Geometry,
                _ => Impact::Layout,
            };
            assert_eq!(info.impact, expected);
        }
        assert!(std::ptr::eq(WIDTH.info(), PropertyId::Width.info()));
        assert!(Impact::Layout > Impact::Geometry && Impact::Geometry > Impact::Paint);
    }

    #[test]
    fn all_typed_selectors_and_the_erased_seam_edit_the_same_style() {
        let mut style = Style::default();
        let values = [
            (PropertyId::Width, PropertyValue::Dimension(Some(90.0))),
            (PropertyId::Height, PropertyValue::Dimension(Some(30.0))),
            (PropertyId::Gap, PropertyValue::Number(3.0)),
            (PropertyId::Padding, PropertyValue::Number(4.0)),
            (PropertyId::FontSize, PropertyValue::Number(18.0)),
            (PropertyId::Foreground, PropertyValue::Color(Color::WHITE)),
            (
                PropertyId::Background,
                PropertyValue::Color(Color::rgb(9, 8, 7)),
            ),
            (PropertyId::Flow, PropertyValue::Flow(Flow::Row)),
            (
                PropertyId::Transform,
                PropertyValue::Transform(Affine::translation(4.0, 8.0)),
            ),
        ];
        for (id, value) in values {
            assert!(id.set_erased(&mut style, value).unwrap());
            assert_eq!(id.get_erased(&style), value);
            assert!(!id.set_erased(&mut style, value).unwrap());
        }
        assert_eq!(WIDTH.get(&style), Some(90.0));
        assert_eq!(PADDING.get(&style), 4.0);
        assert_eq!(FOREGROUND.get(&style), Color::WHITE);
        assert_eq!(FLOW.get(&style), Flow::Row);
        assert_eq!(TRANSFORM.get(&style), Affine::translation(4.0, 8.0));
        assert_eq!(WIDTH.default_value(), None);
        assert_eq!(FONT_SIZE.default_value(), 16.0);
    }
}
