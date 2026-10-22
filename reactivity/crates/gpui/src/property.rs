//! Library-owned typed style declarations. A selector is one immutable schema
//! reference; callers cannot supply a setter, validator or impact claim.
//! Contributions retain presence separately from resolved destination equality.

use crate::style::{Affine, Align, Color, Flow, Justify, Style};
use std::{collections::BTreeMap, fmt};

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
#[non_exhaustive]
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
    Align = 10,
    Justify = 11,
    Wrap = 12,
    CornerRadius = 13,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
#[non_exhaustive]
pub enum ValueKind {
    Dimension,
    Number,
    Color,
    Flow,
    Transform,
    Align,
    Justify,
    Flag,
}

#[derive(Debug)]
pub struct PropertyInfo {
    pub destination: PropertyDestination,
    pub id: PropertyId,
    pub name: &'static str,
    pub kind: ValueKind,
    pub impact: Impact,
}

/// The destination is part of the static schema, not inferred from ValueKind.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum PropertyDestination {
    Style,
    Geometry,
}

/// Cold local geometry, independent from layout and inherited text styling.
#[derive(Clone, Copy, Debug, Default, PartialEq)]
pub struct GeometryStyle {
    pub(crate) corner_radius: f32,
}

mod sealed {
    use super::*;
    pub(crate) trait Domain: Copy {
        fn get_erased(id: PropertyId, value: &Self) -> Result<PropertyValue, PropertyError>;
        fn set_erased(
            id: PropertyId,
            value: &mut Self,
            edit: PropertyValue,
        ) -> Result<bool, PropertyError>;
    }
}
/// Library-owned property destinations. Dispatch is monomorphic; applications
/// cannot install a setter, choose an impact, or extend the destination schema.
#[allow(private_bounds)]
pub trait PropertyDomain: sealed::Domain + Copy + Default + 'static {
    #[doc(hidden)]
    fn dispatch<T, C, R>(
        property: Property<T, Self>,
        context: C,
        style: impl FnOnce(C, Property<T, Style>) -> R,
        geometry: impl FnOnce(C, Property<T, GeometryStyle>) -> R,
    ) -> R;
}
impl PropertyDomain for Style {
    fn dispatch<T, C, R>(
        property: Property<T, Self>,
        context: C,
        style: impl FnOnce(C, Property<T, Style>) -> R,
        _geometry: impl FnOnce(C, Property<T, GeometryStyle>) -> R,
    ) -> R {
        style(context, property)
    }
}
impl PropertyDomain for GeometryStyle {
    fn dispatch<T, C, R>(
        property: Property<T, Self>,
        context: C,
        _style: impl FnOnce(C, Property<T, Style>) -> R,
        geometry: impl FnOnce(C, Property<T, GeometryStyle>) -> R,
    ) -> R {
        geometry(context, property)
    }
}
impl sealed::Domain for Style {
    fn get_erased(id: PropertyId, value: &Self) -> Result<PropertyValue, PropertyError> {
        id.get_erased(value)
    }
    fn set_erased(
        id: PropertyId,
        value: &mut Self,
        edit: PropertyValue,
    ) -> Result<bool, PropertyError> {
        id.set_erased(value, edit)
    }
}
impl sealed::Domain for GeometryStyle {
    fn get_erased(id: PropertyId, value: &Self) -> Result<PropertyValue, PropertyError> {
        if id == PropertyId::CornerRadius {
            Ok(PropertyValue::Number(value.corner_radius))
        } else {
            Err(wrong_destination(id, PropertyDestination::Geometry))
        }
    }
    fn set_erased(
        id: PropertyId,
        value: &mut Self,
        edit: PropertyValue,
    ) -> Result<bool, PropertyError> {
        if id != PropertyId::CornerRadius {
            return Err(wrong_destination(id, PropertyDestination::Geometry));
        }
        if let PropertyValue::Number(number) = edit {
            CORNER_RADIUS.set(value, number)
        } else {
            Err(PropertyError {
                property: id,
                reason: PropertyErrorKind::WrongKind {
                    expected: ValueKind::Number,
                    actual: edit.kind(),
                },
            })
        }
    }
}
fn wrong_destination(id: PropertyId, actual: PropertyDestination) -> PropertyError {
    PropertyError {
        property: id,
        reason: PropertyErrorKind::WrongDestination {
            expected: id.info().destination,
            actual,
        },
    }
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
    OutOfRange,
    Negative,
    NonPositive,
    WrongDestination {
        expected: PropertyDestination,
        actual: PropertyDestination,
    },
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

// Shared by declarations, retained style interning and future property ports.
// Numerical PartialEq remains unchanged; this is exact authoring equality.
pub(crate) trait ExactValue {
    fn same(a: &Self, b: &Self) -> bool;
}
impl ExactValue for f32 {
    #[inline]
    fn same(a: &Self, b: &Self) -> bool {
        a.to_bits() == b.to_bits()
    }
}
impl ExactValue for Option<f32> {
    #[inline]
    fn same(a: &Self, b: &Self) -> bool {
        a.map(f32::to_bits) == b.map(f32::to_bits)
    }
}
impl ExactValue for Color {
    #[inline]
    fn same(a: &Self, b: &Self) -> bool {
        a.same_authoring(*b)
    }
}
impl ExactValue for Affine {
    #[inline]
    fn same(a: &Self, b: &Self) -> bool {
        [a.a, a.b, a.c, a.d, a.tx, a.ty].map(f32::to_bits)
            == [b.a, b.b, b.c, b.d, b.tx, b.ty].map(f32::to_bits)
    }
}
impl ExactValue for Flow {
    #[inline]
    fn same(a: &Self, b: &Self) -> bool {
        a == b
    }
}
impl ExactValue for Align {
    #[inline]
    fn same(a: &Self, b: &Self) -> bool {
        a == b
    }
}
impl ExactValue for Justify {
    #[inline]
    fn same(a: &Self, b: &Self) -> bool {
        a == b
    }
}
impl ExactValue for bool {
    #[inline]
    fn same(a: &Self, b: &Self) -> bool {
        a == b
    }
}

struct Declaration<T, D> {
    info: PropertyInfo,
    get: fn(&D) -> T,
    put: fn(&mut D, T),
    validate: fn(&T) -> Result<(), PropertyErrorKind>,
    same: fn(&T, &T) -> bool,
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
pub struct Property<T: 'static, D: PropertyDomain = Style>(&'static Declaration<T, D>);
impl<T, D: PropertyDomain> Copy for Property<T, D> {}
impl<T, D: PropertyDomain> Clone for Property<T, D> {
    fn clone(&self) -> Self {
        *self
    }
}
impl<T, D: PropertyDomain> fmt::Debug for Property<T, D> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        self.info().fmt(f)
    }
}
impl<T, D: PropertyDomain> Property<T, D> {
    pub(crate) fn erase(self, value: T) -> Result<PropertyValue, PropertyError>
    where
        T: PartialEq,
    {
        let mut destination = D::default();
        self.set(&mut destination, value)?;
        D::get_erased(self.id(), &destination)
    }
    pub const fn info(self) -> &'static PropertyInfo {
        &self.0.info
    }
    pub const fn id(self) -> PropertyId {
        self.0.info.id
    }
    pub fn get(self, style: &D) -> T {
        (self.0.get)(style)
    }
    /// Read the existing library default, without a second table of defaults.
    pub fn default_value(self) -> T {
        self.get(&D::default())
    }
    /// Compare exact declared bits/profile without changing numerical equality.
    pub fn same_authoring(self, a: &T, b: &T) -> bool {
        (self.0.same)(a, b)
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
    /// Validate before editing. False means the resolved authoring bits/profile
    /// are equal; it says nothing about contribution presence or provenance.
    pub fn set(self, style: &mut D, value: T) -> Result<bool, PropertyError>
    where
        T: PartialEq,
    {
        self.validate(&value)?;
        if self.same_authoring(&self.get(style), &value) {
            return Ok(false);
        }
        (self.0.put)(style, value);
        Ok(true)
    }
}

#[inline]
fn nonnegative(value: &f32) -> Result<(), PropertyErrorKind> {
    if !value.is_finite() {
        Err(PropertyErrorKind::NonFinite)
    } else if *value < 0.0 {
        Err(PropertyErrorKind::Negative)
    } else {
        Ok(())
    }
}
#[inline]
fn dimension(value: &Option<f32>) -> Result<(), PropertyErrorKind> {
    value.as_ref().map_or(Ok(()), nonnegative)
}
#[inline]
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
        $(static $decl: Declaration<$ty,Style> = Declaration {
            info: PropertyInfo { destination: PropertyDestination::Style, id: PropertyId::$id, name: $text, kind: ValueKind::$kind, impact: Impact::$impact },
            get: |style| style.$field,
            put: |style, value| style.$field = value,
            validate: $validate,
            same: <$ty as ExactValue>::same,
        };
        pub const $name: Property<$ty> = Property(&$decl);)+
        /// References to the same declaration metadata as the typed selectors.
        pub static PROPERTIES: &[&PropertyInfo] = &[$($name.info()),+, CORNER_RADIUS.info()];
        const _: () = { $(assert!(PropertyId::$id as u16 <= 8191);)+ assert!(PropertyId::CornerRadius as u16 <= 8191); };
        impl PropertyId {
            pub(crate) const fn from_code(code: u16) -> Option<Self> {
                match code {
                    $(value if value == Self::$id as u16 => Some(Self::$id),)+
                    value if value == Self::CornerRadius as u16 => Some(Self::CornerRadius),
                    _ => None,
                }
            }
            pub(crate) fn validate_erased(self, value: PropertyValue) -> Result<(), PropertyError> {
                match (self, value) {
                    $((Self::$id, PropertyValue::$kind(value)) => $name.validate(&value),)+
                    (Self::CornerRadius, PropertyValue::Number(value)) => CORNER_RADIUS.validate(&value),
                    _ => Err(PropertyError { property: self, reason: PropertyErrorKind::WrongKind { expected: self.info().kind, actual: value.kind() } }),
                }
            }
            pub const fn info(self) -> &'static PropertyInfo {
                match self { $(Self::$id => $name.info()),+, Self::CornerRadius => CORNER_RADIUS.info() }
            }
            pub(crate) const fn value_kind(self) -> ValueKind {
                match self { $(Self::$id => ValueKind::$kind),+, Self::CornerRadius => ValueKind::Number }
            }
            pub(crate) fn get_erased(self, style: &Style) -> Result<PropertyValue,PropertyError> {
                match self { $(Self::$id => Ok(PropertyValue::$kind($name.get(style)))),+, Self::CornerRadius=>Err(wrong_destination(self,PropertyDestination::Style)) }
            }
            pub(crate) fn set_erased(self, style: &mut Style, value: PropertyValue) -> Result<bool, PropertyError> {
                if self.info().destination != PropertyDestination::Style { return Err(wrong_destination(self,PropertyDestination::Style)); }
                match (self, value) {
                    $((Self::$id, PropertyValue::$kind(value)) => $name.set(style, value),)+
                    _ => Err(PropertyError { property: self, reason: PropertyErrorKind::WrongKind { expected: self.info().kind, actual: value.kind() } }),
                }
            }
            // Literal authoring has a compile-time field and performs no source
            // subscription or previous-value comparison. Use
            // this SAME schema's field/validator directly, so external callers
            // need not load the inspector's callback descriptor to set a value.
            pub(crate) fn set_literal<const CODE: u16>(style: &mut Style, value: PropertyValue) -> Result<(), PropertyError> {
                let id = const { Self::from_code(CODE).expect("closed property code") };
                match (id, value) {
                    $((Self::$id, PropertyValue::$kind(value)) => {
                        let verdict: Result<(),PropertyErrorKind> = ($validate)(&value);
                        verdict.map_err(|reason| PropertyError { property: id, reason })?;
                        style.$field = value;
                        Ok(())
                    },)+
                    _ => Err(PropertyError { property: id, reason: PropertyErrorKind::WrongKind { expected: id.info().kind, actual: value.kind() } }),
                }
            }
        }
    };
}
#[inline]
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
    ALIGN, ALIGN_DECL, Align, Align, "align", Align, Layout, align, |_| Ok(());
    JUSTIFY, JUSTIFY_DECL, Justify, Justify, "justify", Justify, Layout, justify, |_| Ok(());
    WRAP, WRAP_DECL, bool, Wrap, "wrap", Flag, Layout, wrap, |_| Ok(());
}

static RADIUS_DECL: Declaration<f32, GeometryStyle> = Declaration {
    info: PropertyInfo {
        destination: PropertyDestination::Geometry,
        id: PropertyId::CornerRadius,
        name: "corner_radius",
        kind: ValueKind::Number,
        impact: Impact::Geometry,
    },
    get: |geometry| geometry.corner_radius,
    put: |geometry, value| geometry.corner_radius = value,
    validate: nonnegative,
    same: <f32 as ExactValue>::same,
};
/// Uniform circular local radius, independent from the layout Style domain.
///
/// ```compile_fail,E0308
/// use gpui::{Style,property::CORNER_RADIUS};
/// CORNER_RADIUS.set(&mut Style::default(), 8.0).unwrap();
/// ```
pub const CORNER_RADIUS: Property<f32, GeometryStyle> = Property(&RADIUS_DECL);

/// Closed inspector seam. No boxed erased values, type IDs or external setters.
/// New schema families may be added; external tools should retain an unsupported
/// read-only row for unfamiliar kinds. IDs are not a versioned preset format.
#[derive(Clone, Copy, Debug, PartialEq)]
#[non_exhaustive]
pub enum PropertyValue {
    Dimension(Option<f32>),
    Number(f32),
    Color(Color),
    Flow(Flow),
    Transform(Affine),
    Align(Align),
    Justify(Justify),
    Flag(bool),
}
impl PropertyValue {
    pub fn kind(self) -> ValueKind {
        match self {
            Self::Dimension(_) => ValueKind::Dimension,
            Self::Number(_) => ValueKind::Number,
            Self::Color(_) => ValueKind::Color,
            Self::Flow(_) => ValueKind::Flow,
            Self::Transform(_) => ValueKind::Transform,
            Self::Align(_) => ValueKind::Align,
            Self::Justify(_) => ValueKind::Justify,
            Self::Flag(_) => ValueKind::Flag,
        }
    }
}
impl PropertyId {
    pub(crate) fn value<D: PropertyDomain>(
        self,
        destination: &D,
    ) -> Result<PropertyValue, PropertyError> {
        D::get_erased(self, destination)
    }
}
/// Cold per-window state, keyed by a runtime-validated logical node identity.
/// Ordinary nodes have no entry or duplicate base style. Presence belongs here,
/// independently of whether the resolved destination changed.
#[derive(Default)]
pub(crate) struct Overrides<D: PropertyDomain = Style> {
    entries: BTreeMap<u64, Overlay<D>>,
}
struct Overlay<D> {
    base: D,
    values: BTreeMap<PropertyId, PropertyValue>,
}
impl<D: PropertyDomain> Overrides<D> {
    pub(crate) fn contribution(
        &self,
        identity: u64,
        id: PropertyId,
    ) -> Contribution<PropertyValue> {
        self.entries
            .get(&identity)
            .and_then(|overlay| overlay.values.get(&id))
            .copied()
            .map_or(Contribution::Inherit, Contribution::Set)
    }
    pub(crate) fn get<T>(&self, identity: u64, property: Property<T, D>) -> Contribution<T> {
        let Some(overlay) = self.entries.get(&identity) else {
            return Contribution::Inherit;
        };
        let Some(value) = overlay.values.get(&property.id()) else {
            return Contribution::Inherit;
        };
        let mut style = overlay.base;
        D::set_erased(property.id(), &mut style, *value).expect("validated stored contribution");
        Contribution::Set(property.get(&style))
    }

    #[cfg(test)]
    pub(crate) fn set<T: PartialEq>(
        &mut self,
        identity: u64,
        current: D,
        property: Property<T, D>,
        contribution: Contribution<T>,
    ) -> Result<D, PropertyError> {
        let id = property.id();
        let value = match contribution {
            Contribution::Inherit => Contribution::Inherit,
            Contribution::Set(value) => Contribution::Set(property.erase(value)?),
        };
        self.set_value(identity, current, id, value)
    }
    pub(crate) fn set_value(
        &mut self,
        identity: u64,
        current: D,
        id: PropertyId,
        contribution: Contribution<PropertyValue>,
    ) -> Result<D, PropertyError> {
        match contribution {
            Contribution::Inherit => {
                let Some(overlay) = self.entries.get(&identity) else {
                    return Ok(current);
                };
                let resolved = apply_except(overlay.base, &overlay.values, Some(id));
                let overlay = self.entries.get_mut(&identity).unwrap();
                overlay.values.remove(&id);
                if overlay.values.is_empty() {
                    self.entries.remove(&identity);
                }
                self.release_empty();
                Ok(resolved)
            }
            Contribution::Set(value) => {
                // Complete validated resolution before touching either map,
                // including the stored base. Typed and catalog fronts share it.
                let mut resolved = self.entries.get(&identity).map_or(current, |overlay| {
                    apply_except(overlay.base, &overlay.values, Some(id))
                });
                D::set_erased(id, &mut resolved, value)?;
                let overlay = self.entries.entry(identity).or_insert_with(|| Overlay {
                    base: current,
                    values: BTreeMap::new(),
                });
                overlay.values.insert(id, value);
                Ok(resolved)
            }
        }
    }

    /// A source publication changes the lower declaration even while an
    /// inspector masks this property. Admission occurs before either base edits.
    pub(crate) fn update_base(
        &mut self,
        identity: u64,
        mut current: D,
        id: PropertyId,
        value: PropertyValue,
    ) -> Result<D, PropertyError> {
        let Some(overlay) = self.entries.get_mut(&identity) else {
            D::set_erased(id, &mut current, value)?;
            return Ok(current);
        };
        let mut base = overlay.base;
        D::set_erased(id, &mut base, value)?;
        if !overlay.values.contains_key(&id) {
            D::set_erased(id, &mut current, value)?;
        }
        overlay.base = base;
        Ok(current)
    }

    pub(crate) fn resolve(&mut self, identity: u64, declared: D) -> D {
        let Some(overlay) = self.entries.get_mut(&identity) else {
            return declared;
        };
        let resolved = apply_except(declared, &overlay.values, None);
        overlay.base = declared;
        resolved
    }

    pub(crate) fn retain(&mut self, mut live: impl FnMut(u64) -> bool) {
        self.entries.retain(|identity, _| live(*identity));
        self.release_empty();
    }

    pub(crate) fn is_empty(&self) -> bool {
        self.entries.is_empty()
    }

    fn release_empty(&mut self) {
        // BTreeMap may retain an empty root allocation after removal. Release
        // it when the window no longer has any overridden nodes.
        if self.entries.is_empty() {
            self.entries = BTreeMap::new();
        }
    }
}

impl Overrides<Style> {
    /// Source colors are retained relationships. Refresh the two lower values
    /// only when an inspector actually addresses this node, not on publication.
    pub(crate) fn refresh_color_base(&mut self, identity: u64, colors: (Color, Color)) {
        if let Some(overlay) = self.entries.get_mut(&identity) {
            overlay.base.fg = colors.0;
            overlay.base.bg = colors.1;
        }
    }
}

fn apply_except<D: PropertyDomain>(
    mut style: D,
    values: &BTreeMap<PropertyId, PropertyValue>,
    skip: Option<PropertyId>,
) -> D {
    for (id, value) in values {
        if Some(*id) != skip {
            D::set_erased(*id, &mut style, *value).expect("validated stored contribution");
        }
    }
    style
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
        eprintln!(
            "property_declaration_bytes={}",
            std::mem::size_of::<Declaration<f32, Style>>()
        );
        eprintln!(
            "catalog_baseline,info={},value={},contribution={},declaration={},catalog_reference_bytes={}",
            size_of::<PropertyInfo>(),
            size_of::<PropertyValue>(),
            size_of::<Contribution<PropertyValue>>(),
            size_of::<Declaration<f32, Style>>(),
            size_of_val(PROPERTIES)
        );
        assert_eq!(std::mem::size_of_val(&WIDTH), std::mem::size_of::<usize>());
        assert_eq!(PROPERTIES.len(), 13);
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
                PropertyId::Transform | PropertyId::CornerRadius => Impact::Geometry,
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
            (PropertyId::Align, PropertyValue::Align(Align::Center)),
            (
                PropertyId::Justify,
                PropertyValue::Justify(Justify::SpaceBetween),
            ),
            (PropertyId::Wrap, PropertyValue::Flag(true)),
            (
                PropertyId::Transform,
                PropertyValue::Transform(Affine::translation(4.0, 8.0)),
            ),
        ];
        for (id, value) in values {
            assert!(id.set_erased(&mut style, value).unwrap());
            assert_eq!(id.get_erased(&style), Ok(value));
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

    #[test]
    fn sparse_overrides_preserve_explicit_auto_and_reveal_updated_base_on_reset() {
        let mut overrides = Overrides::default();
        let base = Style::default();
        assert_eq!(overrides.get(1, WIDTH), Contribution::Inherit);
        assert!(overrides.entries.is_empty());
        let equal = overrides
            .set(1, base, WIDTH, Contribution::Set(None))
            .unwrap();
        assert_eq!(equal, base);
        assert_eq!(overrides.get(1, WIDTH), Contribution::Set(None));
        let mut declared = base;
        WIDTH.set(&mut declared, Some(40.0)).unwrap();
        PADDING.set(&mut declared, 8.0).unwrap();
        let resolved = overrides.resolve(1, declared);
        assert_eq!(WIDTH.get(&resolved), None);
        assert_eq!(PADDING.get(&resolved), 8.0);
        assert_eq!(overrides.get(1, WIDTH), Contribution::Set(None));
        let restored = overrides
            .set(1, resolved, WIDTH, Contribution::Inherit)
            .unwrap();
        assert_eq!(restored, declared);
        assert_eq!(overrides.get(1, WIDTH), Contribution::Inherit);
        assert!(overrides.entries.is_empty());
    }

    #[test]
    fn independent_overrides_survive_base_changes_and_lifecycle_purge() {
        let mut overrides = Overrides::default();
        let base = Style::default();
        let width = overrides
            .set(1, base, WIDTH, Contribution::Set(Some(20.0)))
            .unwrap();
        let both = overrides
            .set(1, width, HEIGHT, Contribution::Set(Some(30.0)))
            .unwrap();
        assert_eq!(
            (WIDTH.get(&both), HEIGHT.get(&both)),
            (Some(20.0), Some(30.0))
        );
        overrides.set(2, base, GAP, Contribution::Set(7.0)).unwrap();
        let mut declared = base;
        WIDTH.set(&mut declared, Some(100.0)).unwrap();
        HEIGHT.set(&mut declared, Some(200.0)).unwrap();
        let both = overrides.resolve(1, declared);
        assert_eq!(
            (WIDTH.get(&both), HEIGHT.get(&both)),
            (Some(20.0), Some(30.0))
        );
        let height = overrides
            .set(1, both, WIDTH, Contribution::Inherit)
            .unwrap();
        assert_eq!(
            (WIDTH.get(&height), HEIGHT.get(&height)),
            (Some(100.0), Some(30.0))
        );
        assert_eq!(overrides.get(1, HEIGHT), Contribution::Set(Some(30.0)));
        assert_eq!(overrides.get(2, GAP), Contribution::Set(7.0));
        overrides.retain(|identity| identity == 2);
        assert_eq!(overrides.get(1, HEIGHT), Contribution::Inherit);
        assert_eq!(overrides.get(2, GAP), Contribution::Set(7.0));
        overrides.retain(|_| false);
        assert!(overrides.entries.is_empty());
        // A recycled caller identity has no retained values or lower base.
        assert_eq!(overrides.resolve(1, declared), declared);
    }

    #[test]
    fn rejected_override_changes_neither_existing_bases_nor_any_contribution() {
        let mut overrides = Overrides::default();
        let base = Style::default();
        let current = overrides.set(1, base, GAP, Contribution::Set(3.0)).unwrap();
        overrides
            .set(2, base, WIDTH, Contribution::Set(Some(8.0)))
            .unwrap();
        let old_values = overrides.entries[&1].values.clone();
        let old_base = overrides.entries[&1].base;
        let other_values = overrides.entries[&2].values.clone();
        let mut different_base = current;
        PADDING.set(&mut different_base, 91.0).unwrap();
        for id in [1, 3] {
            assert!(
                overrides
                    .set(id, different_base, GAP, Contribution::Set(f32::NAN))
                    .is_err()
            );
        }
        assert_eq!(overrides.entries.len(), 2);
        assert_eq!(overrides.entries[&1].base, old_base);
        assert_eq!(overrides.entries[&1].values, old_values);
        assert_eq!(overrides.entries[&2].base, base);
        assert_eq!(overrides.entries[&2].values, other_values);
        assert_eq!(GAP.get(&current), 3.0);
        assert_eq!(PADDING.get(&current), 0.0);
    }
}
