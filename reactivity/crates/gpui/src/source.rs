//! Typed owner-relative sources. Borrowed addresses are compared only while the
//! owner is borrowed; installed bindings retain a field key, never an address.

mod path;
mod value;
pub(crate) use path::Path;
pub use path::{ProjectedSource, SourcePath};
pub use value::SourceValue;

use crate::{View, component::Component};
use gpui_reactivity_state::{Revision, Signal};
use std::{any::Any, borrow::Cow, fmt, num::NonZeroU64};

/// Explicit local field identity. The runtime qualifies contained fields with
/// checked schema-relative scope ordinals; these are not durable capabilities.
/// `get()` returns the local declaration ID, not a globally unique identifier.
/// Declarations use `new`; resolved scoped IDs cannot be redeclared as sources.
/// Both this type and its Option occupy eight bytes, including local ID zero.
#[derive(Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct FieldId(NonZeroU64);

impl FieldId {
    pub const fn new(value: u32) -> Self {
        Self::scoped(value, 0)
    }
    pub const fn get(self) -> u32 {
        ((self.0.get() - 1) >> 32) as u32
    }
    const fn scope(self) -> u32 {
        (self.0.get() - 1) as u32
    }
    const fn scoped(local: u32, scope: u32) -> Self {
        // Sources allocates half-open scope ranges with checked addition.
        // Their exclusive end may be MAX, but an assigned scope never is.
        // Reserving it makes the entire public local-ID domain niche-friendly.
        assert!(scope < u32::MAX, "scope ordinal is reserved");
        let pair = ((local as u64) << 32) | scope as u64;
        Self(NonZeroU64::new(pair + 1).unwrap())
    }
}
impl fmt::Debug for FieldId {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("FieldId")
            .field("local", &self.get())
            .field("scope", &self.scope())
            .finish()
    }
}

/// A safe projection declaration. Declare these once per model type, then
/// return `Sources::new().field(FIELD)` from `View::sources`.
///
/// IDs and names must be unique. Projectors must select the same stable field
/// until that owner's bindings are remounted. The runtime checks agreement at
/// mount and before each edit; arbitrary custom projections have owner impact.
/// Projectors must only return the selected field: they must not mutate other
/// fields, perform I/O or depend on external mutable selection state. This is a
/// semantic projection contract, not a Rust type-system proof of purity. Declaring
/// a source opts into it; opaque owner methods retain conservative owner impact.
pub struct Source<M, T> {
    id: FieldId,
    name: &'static str,
    read: fn(&M) -> &Signal<T>,
    write: fn(&mut M) -> &mut Signal<T>,
}

impl<M, T> Copy for Source<M, T> {}
impl<M, T> Clone for Source<M, T> {
    fn clone(&self) -> Self {
        *self
    }
}

impl<M, T> Source<M, T> {
    pub const fn new(
        id: FieldId,
        name: &'static str,
        read: fn(&M) -> &Signal<T>,
        write: fn(&mut M) -> &mut Signal<T>,
    ) -> Self
    where
        T: SourceValue,
    {
        Self {
            id,
            name,
            read,
            write,
        }
    }
    pub const fn id(&self) -> FieldId {
        self.id
    }
    pub const fn name(&self) -> &'static str {
        self.name
    }
    /// A route whose only model access is this source's mutable value.
    pub fn update<F: Fn(&mut T)>(self, update: F) -> FieldAction<M, T, F> {
        FieldAction {
            source: self,
            update,
            owner: std::marker::PhantomData,
        }
    }
    /// Apply a typed source operation. Mismatched projectors fail before the
    /// source's mutable value is exposed. Panics from the operation follow the
    /// owner fault policy; arbitrary Rust callbacks cannot be rolled back.
    pub(crate) fn modify<R>(
        &self,
        model: &mut M,
        edit: impl FnOnce(&mut T) -> R,
    ) -> Result<R, BindError> {
        let read = (self.read)(model) as *const Signal<T>;
        let write = (self.write)(model);
        if !std::ptr::eq(read, write as *const Signal<T>) {
            return Err(BindError::ProjectionMismatch(self.id));
        }
        Ok(edit(&mut **write))
    }
}

impl<M, T: 'static> Source<M, T> {
    pub(crate) fn borrow_registered<'a>(
        &self,
        model: &'a M,
        sources: &Sources<M>,
    ) -> Result<&'a Signal<T>, BindError> {
        let signal = (self.read)(model);
        if sources.signal(model, self.id)?.same(signal) {
            Ok(signal)
        } else {
            Err(BindError::ProjectionMismatch(self.id))
        }
    }
}

/// An exact source route constructed by [`Source::update`].
pub struct FieldAction<M, T, F, S = Source<M, T>> {
    source: S,
    update: F,
    owner: std::marker::PhantomData<fn(&mut M, &mut T)>,
}
impl<M, T: 'static, F, S: SourcePath<M, T>> FieldAction<M, T, F, S> {
    pub(crate) fn new(source: S, update: F) -> Self {
        Self {
            source,
            update,
            owner: std::marker::PhantomData,
        }
    }
    pub(crate) fn validate_registered(
        &self,
        model: &M,
        sources: &Sources<M>,
    ) -> Result<FieldId, BindError> {
        self.source.resolve(model, sources).map(|(field, _)| field)
    }
    pub(crate) fn receive<U>(
        &mut self,
        model: &mut M,
        sources: &Sources<M>,
        value: U,
    ) -> Result<FieldId, BindError>
    where
        F: FnMut(&mut T, U),
    {
        let field = self.validate_registered(model, sources)?;
        self.source
            .modify(model, |target| (self.update)(target, value))?;
        Ok(field)
    }
}
impl<M, T: 'static, F: Fn(&mut T), S: SourcePath<M, T>> FieldAction<M, T, F, S> {
    /// Validate every exclusive projector before exposing `&mut T`.
    pub(crate) fn invoke(&self, model: &mut M) -> Result<(), BindError> {
        self.source.modify(model, &self.update)
    }
}

mod sealed {
    use std::borrow::Cow;
    pub(crate) trait TextValue: 'static {
        // Only library implementations can supply a property adapter. Custom
        // text adapters keep the default text-only capability.
        const STYLE: Option<fn(&Self) -> crate::style_port::Scalar> = None;
        fn text(&self) -> Cow<'_, str>;
        fn parse_text(text: &str) -> Result<Self, &'static str>
        where
            Self: Sized;
        fn from_text(input: String) -> Result<Self, (String, &'static str)>
        where
            Self: Sized,
        {
            match Self::parse_text(&input) {
                Ok(value) => Ok(value),
                Err(reason) => Err((input, reason)),
            }
        }
    }
}

/// The library-owned text adapters; generic source registration does not need
/// this trait. Formatting and parsing implementation details remain private.
#[allow(private_bounds)]
pub trait TextValue: sealed::TextValue {}
impl<T: sealed::TextValue> TextValue for T {}

impl sealed::TextValue for String {
    fn text(&self) -> Cow<'_, str> {
        Cow::Borrowed(self)
    }
    fn parse_text(text: &str) -> Result<Self, &'static str> {
        Ok(text.to_owned())
    }
    fn from_text(input: String) -> Result<Self, (String, &'static str)> {
        Ok(input)
    }
}

macro_rules! scalar {
    ($($ty:ty),* $(,)?) => {$ (
        impl sealed::TextValue for $ty {
            const STYLE: Option<fn(&Self) -> crate::style_port::Scalar> = Some(|value| crate::style_port::Scalar::Number(*value as f64));
            fn text(&self) -> Cow<'_, str> { Cow::Owned(self.to_string()) }
            fn parse_text(text: &str) -> Result<Self, &'static str> {
                text.parse().map_err(|_| concat!("invalid ", stringify!($ty)))
            }
        }
    )* };
}
scalar!(u32, u64, i32);
impl sealed::TextValue for bool {
    const STYLE: Option<fn(&Self) -> crate::style_port::Scalar> = Some(|value| {
        crate::style_port::Scalar::Value(crate::property::PropertyValue::Flag(*value))
    });
    fn text(&self) -> Cow<'_, str> {
        Cow::Owned(self.to_string())
    }
    fn parse_text(text: &str) -> Result<Self, &'static str> {
        text.parse().map_err(|_| "invalid bool")
    }
}
impl sealed::TextValue for f64 {
    const STYLE: Option<fn(&Self) -> crate::style_port::Scalar> =
        Some(|value| crate::style_port::Scalar::Number(*value));
    fn text(&self) -> Cow<'_, str> {
        Cow::Owned(self.to_string())
    }
    fn parse_text(text: &str) -> Result<Self, &'static str> {
        let value: f64 = text.parse().map_err(|_| "invalid f64")?;
        if value.is_finite() {
            Ok(value)
        } else {
            Err("non-finite f64")
        }
    }
}

pub(crate) trait ErasedSignal {
    fn as_any(&self) -> &dyn Any;
    fn same(&self, other: &dyn ErasedSignal) -> bool;
}
impl<T: 'static> ErasedSignal for Signal<T> {
    fn as_any(&self) -> &dyn Any {
        self
    }
    fn same(&self, other: &dyn ErasedSignal) -> bool {
        other
            .as_any()
            .downcast_ref::<Signal<T>>()
            .is_some_and(|other| std::ptr::eq(self, other))
    }
}

/// One immutable descriptor per concrete source scalar, shared by every fanout.
/// A numeric descriptor freezes both text and style when both are requested;
/// installation order cannot discard a capability.
#[derive(Clone, Copy)]
pub(crate) struct SourceCodec(&'static CodecDeclaration);
pub(crate) type TextCodec = SourceCodec;
type WriteText = fn(&mut dyn Any, FieldId, String) -> Result<Revision, TextEditError>;
struct CodecDeclaration {
    freeze: for<'a> fn(&'a dyn Any, FieldId, Needs) -> Result<Frozen<'a>, BindError>,
    write: Option<WriteText>,
}
#[derive(Clone, Copy)]
pub(crate) struct Needs {
    pub text: bool,
    pub style: bool,
}
pub(crate) struct Frozen<'a> {
    pub text: Option<Cow<'a, str>>,
    pub style: Option<crate::style_port::Scalar>,
}
struct TextAdapter<T>(std::marker::PhantomData<T>);
impl<T: TextValue> TextAdapter<T> {
    const DECLARATION: CodecDeclaration = CodecDeclaration {
        freeze: |signal, id, needs| {
            let signal = signal
                .downcast_ref::<Signal<T>>()
                .ok_or(BindError::TypeMismatch(id))?;
            let value = &**signal;
            let text = needs.text.then(|| value.text());
            let style = if needs.style {
                Some(T::STYLE.ok_or(BindError::TypeMismatch(id))?(value))
            } else {
                None
            };
            Ok(Frozen { text, style })
        },
        write: Some(|value, id, input| {
            let signal = match value.downcast_mut::<Signal<T>>() {
                Some(signal) => signal,
                None => {
                    return Err(TextEditError {
                        field: id,
                        input,
                        reason: TextEditErrorKind::Binding(BindError::TypeMismatch(id)),
                    });
                }
            };
            let value = match T::from_text(input) {
                Ok(value) => value,
                Err((input, reason)) => {
                    return Err(TextEditError {
                        field: id,
                        input,
                        reason: TextEditErrorKind::InvalidValue(reason),
                    });
                }
            };
            **signal = value;
            Ok(signal.revision())
        }),
    };
}
struct StyleAdapter<T>(std::marker::PhantomData<T>);
impl<T: crate::style_port::Value> StyleAdapter<T> {
    const DECLARATION: CodecDeclaration = CodecDeclaration {
        freeze: |signal, id, needs| {
            if needs.text {
                return Err(BindError::TypeMismatch(id));
            }
            let signal = signal
                .downcast_ref::<Signal<T>>()
                .ok_or(BindError::TypeMismatch(id))?;
            Ok(Frozen {
                text: None,
                style: needs
                    .style
                    .then(|| crate::style_port::Value::scalar(**signal)),
            })
        },
        write: None,
    };
}
impl SourceCodec {
    pub(crate) const fn for_style<T: crate::style_port::Value>() -> Self {
        Self(&StyleAdapter::<T>::DECLARATION)
    }
    pub(crate) const fn for_value<T: TextValue>() -> Self {
        Self(&TextAdapter::<T>::DECLARATION)
    }
    pub(crate) fn freeze<'a>(
        self,
        signal: &'a dyn Any,
        id: FieldId,
        needs: Needs,
    ) -> Result<Frozen<'a>, BindError> {
        (self.0.freeze)(signal, id, needs)
    }
    fn read<'a>(self, signal: &'a dyn Any, id: FieldId) -> Result<Cow<'a, str>, BindError> {
        self.freeze(
            signal,
            id,
            Needs {
                text: true,
                style: false,
            },
        )?
        .text
        .ok_or(BindError::TypeMismatch(id))
    }
    fn write(
        self,
        signal: &mut dyn Any,
        id: FieldId,
        input: String,
    ) -> Result<Revision, TextEditError> {
        match self.0.write {
            Some(write) => write(signal, id, input),
            None => Err(TextEditError {
                field: id,
                input,
                reason: TextEditErrorKind::Binding(BindError::TypeMismatch(id)),
            }),
        }
    }
}

trait TextSignal: ErasedSignal {
    fn text(&self) -> Cow<'_, str>;
    fn codec(&self) -> TextCodec;
}
impl<T: TextValue> TextSignal for Signal<T> {
    fn text(&self) -> Cow<'_, str> {
        (**self).text()
    }
    fn codec(&self) -> TextCodec {
        TextCodec::for_value::<T>()
    }
}

/// An opaque borrowed signal operand, consumed while the owner is borrowed.
#[derive(Clone, Copy)]
pub struct SignalText<'a>(&'a dyn TextSignal);
impl fmt::Debug for SignalText<'_> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_tuple("SignalText").field(&self.0.text()).finish()
    }
}

/// A description operand. Ordinary borrowed strings stay borrowed; signal
/// operands are resolved to owner-relative field keys before lowering returns.
#[derive(Clone, Debug)]
pub enum Text<'a> {
    Borrowed(&'a str),
    Owned(String),
    Signal(SignalText<'a>),
}
impl<'a> Text<'a> {
    pub const fn literal(value: &'a str) -> Self {
        Self::Borrowed(value)
    }
    pub fn borrowed_value(&self) -> Cow<'_, str> {
        match self {
            Self::Borrowed(value) => Cow::Borrowed(value),
            Self::Owned(value) => Cow::Borrowed(value),
            Self::Signal(value) => value.0.text(),
        }
    }
    pub(crate) fn signal(&self) -> Option<&dyn ErasedSignal> {
        match self {
            Self::Signal(value) => Some(value.0),
            _ => None,
        }
    }
    pub(crate) fn codec(&self) -> Option<TextCodec> {
        match self {
            Self::Signal(value) => Some(value.0.codec()),
            _ => None,
        }
    }
}

pub trait IntoText<'a> {
    fn into_text(self) -> Text<'a>;
}
impl<'a> IntoText<'a> for Text<'a> {
    fn into_text(self) -> Text<'a> {
        self
    }
}
impl<'a> IntoText<'a> for &'a str {
    fn into_text(self) -> Text<'a> {
        Text::Borrowed(self)
    }
}
impl<'a> IntoText<'a> for &'a String {
    fn into_text(self) -> Text<'a> {
        Text::Borrowed(self)
    }
}
impl<'a> IntoText<'a> for String {
    fn into_text(self) -> Text<'a> {
        Text::Owned(self)
    }
}
impl<'a, T: TextValue> IntoText<'a> for &'a Signal<T> {
    fn into_text(self) -> Text<'a> {
        Text::Signal(SignalText(self))
    }
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub enum BindError {
    /// A resolved component field cannot be reused as a local declaration ID.
    NonLocalDeclaration(FieldId),
    ReceiverMismatch,
    DuplicateComponent(FieldId),
    UnknownComponent(FieldId),
    ComponentProjectionMismatch(FieldId),
    ScopeExhausted,
    ComponentDepthLimit,
    DuplicateId(FieldId),
    DuplicateName(&'static str),
    AliasedFields {
        first: FieldId,
        second: FieldId,
    },
    ProjectionMismatch(FieldId),
    UnknownField(FieldId),
    TypeMismatch(FieldId),
}
impl fmt::Display for BindError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "source binding: {self:?}")
    }
}
impl std::error::Error for BindError {}

/// A rejected edit owns the submitted payload, so callers can report or retry
/// without reconstructing it. Validation never mutates a source revision.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct TextEditError {
    pub field: FieldId,
    pub input: String,
    pub reason: TextEditErrorKind,
}
#[derive(Clone, Debug, PartialEq, Eq)]
pub enum TextEditErrorKind {
    Binding(BindError),
    InvalidValue(&'static str),
}
impl fmt::Display for TextEditError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "text edit for {:?}: {:?}", self.field, self.reason)
    }
}
impl std::error::Error for TextEditError {}

trait Field<M> {
    fn id(&self) -> FieldId;
    fn name(&self) -> &'static str;
    fn signal<'a>(&self, model: &'a M) -> &'a dyn ErasedSignal;
    fn revision(&self, model: &M) -> Revision;
    fn validate(&self, model: &mut M) -> Result<(), BindError>;
    fn write_text(
        &self,
        model: &mut M,
        input: String,
        codec: TextCodec,
    ) -> Result<Revision, TextEditError>;
}
impl<M, T: 'static> Field<M> for Source<M, T> {
    fn id(&self) -> FieldId {
        self.id
    }
    fn name(&self) -> &'static str {
        self.name
    }
    fn signal<'a>(&self, model: &'a M) -> &'a dyn ErasedSignal {
        (self.read)(model)
    }
    fn revision(&self, model: &M) -> Revision {
        (self.read)(model).revision()
    }
    fn validate(&self, model: &mut M) -> Result<(), BindError> {
        // Only compare opaque addresses. Neither pointer is dereferenced and
        // no shared reference remains live during the exclusive projection.
        let read = (self.read)(model) as *const Signal<T>;
        let write = (self.write)(model) as *const Signal<T>;
        if std::ptr::eq(read, write) {
            Ok(())
        } else {
            Err(BindError::ProjectionMismatch(self.id))
        }
    }
    fn write_text(
        &self,
        model: &mut M,
        input: String,
        codec: TextCodec,
    ) -> Result<Revision, TextEditError> {
        let read = (self.read)(model) as *const Signal<T>;
        let signal = (self.write)(model);
        if !std::ptr::eq(read, signal as *const Signal<T>) {
            return Err(TextEditError {
                field: self.id,
                input,
                reason: TextEditErrorKind::Binding(BindError::ProjectionMismatch(self.id)),
            });
        }
        codec.write(signal, self.id, input)
    }
}

// A component owns one child schema. Field and method routing recurse through
// typed projection tables, never through retained child addresses or refcounts.
trait ComponentSchema<M> {
    fn as_any(&self) -> &dyn Any;
    fn id(&self) -> FieldId;
    fn name(&self) -> &'static str;
    fn contains(&self, id: FieldId) -> bool;
    fn len(&self) -> usize;
    fn validate(&self, model: &mut M) -> Result<(), BindError>;
    fn collect_signals<'a>(&self, model: &'a M, output: &mut Vec<(FieldId, &'a dyn ErasedSignal)>);
    fn resolve(&self, model: &M, signal: &dyn ErasedSignal) -> Result<Option<FieldId>, BindError>;
    fn signal<'a>(&self, model: &'a M, id: FieldId) -> Result<&'a dyn ErasedSignal, BindError>;
    fn invalidates_owner(&self, id: FieldId) -> Result<bool, BindError>;
    fn revision(&self, model: &M, id: FieldId) -> Result<Revision, BindError>;
    fn write_text(
        &self,
        model: &mut M,
        id: FieldId,
        input: String,
        codec: TextCodec,
    ) -> Result<Revision, TextEditError>;
    fn scan(&self, model: &M, output: &mut Vec<(FieldId, Revision)>);
}
pub(crate) struct ComponentEntry<M, C> {
    pub(crate) component: Component<M, C>,
    pub(crate) sources: Sources<C>,
    start: u32,
    end: u32,
    parent_dependency: bool,
}
impl<M, C> ComponentEntry<M, C> {
    pub(crate) fn qualify_scope(&self, scope: u32) -> u32 {
        self.start + scope
    }
    pub(crate) fn qualify(&self, field: FieldId) -> FieldId {
        FieldId::scoped(field.get(), self.start + field.scope())
    }
    fn local(&self, field: FieldId) -> FieldId {
        FieldId::scoped(field.get(), field.scope() - self.start)
    }
}
impl<M: 'static, C: 'static> ComponentSchema<M> for ComponentEntry<M, C> {
    fn as_any(&self) -> &dyn Any {
        self
    }
    fn id(&self) -> FieldId {
        self.component.id
    }
    fn name(&self) -> &'static str {
        self.component.name
    }
    fn contains(&self, id: FieldId) -> bool {
        id.scope() >= self.start && id.scope() < self.end
    }
    fn len(&self) -> usize {
        self.sources.len()
    }
    fn validate(&self, model: &mut M) -> Result<(), BindError> {
        self.sources.validate(self.component.project_mut(model)?)
    }
    fn collect_signals<'a>(&self, model: &'a M, output: &mut Vec<(FieldId, &'a dyn ErasedSignal)>) {
        let begin = output.len();
        self.sources
            .collect_signals((self.component.read)(model), output);
        for (id, _) in &mut output[begin..] {
            *id = self.qualify(*id);
        }
    }
    fn resolve(&self, model: &M, signal: &dyn ErasedSignal) -> Result<Option<FieldId>, BindError> {
        self.sources
            .resolve((self.component.read)(model), signal)
            .map(|id| id.map(|id| self.qualify(id)))
    }
    fn signal<'a>(&self, model: &'a M, id: FieldId) -> Result<&'a dyn ErasedSignal, BindError> {
        self.sources
            .signal((self.component.read)(model), self.local(id))
    }
    fn invalidates_owner(&self, id: FieldId) -> Result<bool, BindError> {
        let child = self.sources.invalidates_owner(self.local(id))?;
        Ok(self.parent_dependency || child)
    }
    fn revision(&self, model: &M, id: FieldId) -> Result<Revision, BindError> {
        self.sources
            .revision((self.component.read)(model), self.local(id))
    }
    fn write_text(
        &self,
        model: &mut M,
        id: FieldId,
        input: String,
        codec: TextCodec,
    ) -> Result<Revision, TextEditError> {
        let child = match self.component.project_mut(model) {
            Ok(child) => child,
            Err(error) => {
                return Err(TextEditError {
                    field: id,
                    input,
                    reason: TextEditErrorKind::Binding(error),
                });
            }
        };
        self.sources
            .write_text(child, self.local(id), input, codec)
            .map_err(|mut error| {
                error.field = id;
                error
            })
    }
    fn scan(&self, model: &M, output: &mut Vec<(FieldId, Revision)>) {
        let begin = output.len();
        self.sources.scan_into((self.component.read)(model), output);
        for (id, _) in &mut output[begin..] {
            *id = self.qualify(*id);
        }
    }
}

/// A model's explicit macro-free source schema. Descriptors allocate once per
/// mounted owner. Signals themselves carry no registry, allocation or address.
pub struct Sources<M> {
    fields: Vec<Box<dyn Field<M>>>,
    schema_error: Option<BindError>,
    owner_fields: Vec<FieldId>,
    components: Vec<Box<dyn ComponentSchema<M>>>,
    next_scope: u32,
    component_depth: u32,
}
impl<M> Default for Sources<M> {
    fn default() -> Self {
        Self::new()
    }
}
impl<M> Sources<M> {
    pub const fn new() -> Self {
        Self {
            fields: Vec::new(),
            schema_error: None,
            owner_fields: Vec::new(),
            components: Vec::new(),
            next_scope: 1,
            component_depth: 0,
        }
    }
    /// Register an owner dependency. Typed edits also re-describe the owner, so
    /// ordinary branches, formatting and other snapshot reads remain current.
    pub fn field<T: 'static>(self, source: Source<M, T>) -> Self
    where
        M: 'static,
    {
        let mut schema = self.direct(source);
        schema.owner_fields.push(source.id());
        schema
    }
    /// Register a direct-port-only source. Edits update already mounted direct
    /// operands without invoking View. This does not observe ordinary Deref
    /// reads: use `field` for branches, formatting or structural dependencies.
    /// Selecting this form explicitly declares that those dependencies are absent.
    pub fn direct<T: 'static>(mut self, source: Source<M, T>) -> Self
    where
        M: 'static,
    {
        if self.schema_error.is_none() && source.id.scope() != 0 {
            self.schema_error = Some(BindError::NonLocalDeclaration(source.id));
        }
        if self.schema_error.is_none() {
            for other in &self.fields {
                if other.id() == source.id {
                    self.schema_error = Some(BindError::DuplicateId(source.id));
                    break;
                }
                if other.name() == source.name {
                    self.schema_error = Some(BindError::DuplicateName(source.name));
                    break;
                }
            }
        }
        if self.schema_error.is_none()
            && self
                .components
                .iter()
                .any(|component| component.name() == source.name)
        {
            self.schema_error = Some(BindError::DuplicateName(source.name));
        }
        self.fields.push(Box::new(source));
        self
    }
    /// Register contained state with conservative parent dependencies. Child
    /// methods and every child edit may affect ordinary parent snapshot reads.
    pub fn component<C: View + 'static>(self, component: Component<M, C>) -> Self
    where
        M: 'static,
    {
        self.register_component(component, true)
    }
    /// Declare that the parent does not snapshot child state outside the child
    /// description/direct operands. Child `field` declarations still invalidate
    /// the owner; child `direct` declarations can patch without running any View.
    /// This explicit contract does not observe ordinary Rust Deref reads.
    pub fn direct_component<C: View + 'static>(self, component: Component<M, C>) -> Self
    where
        M: 'static,
    {
        self.register_component(component, false)
    }
    fn register_component<C: View + 'static>(
        mut self,
        component: Component<M, C>,
        parent_dependency: bool,
    ) -> Self
    where
        M: 'static,
    {
        if self.schema_error.is_none() && component.id.scope() != 0 {
            self.schema_error = Some(BindError::NonLocalDeclaration(component.id));
            return self;
        }
        if self
            .components
            .iter()
            .any(|other| other.id() == component.id)
        {
            self.schema_error = Some(BindError::DuplicateComponent(component.id));
        }
        if self.schema_error.is_none()
            && (self
                .components
                .iter()
                .any(|other| other.name() == component.name)
                || self
                    .fields
                    .iter()
                    .any(|field| field.name() == component.name))
        {
            self.schema_error = Some(BindError::DuplicateName(component.name));
        }
        let sources = C::sources();
        // Static schemas must be finite and acyclic; bound the admitted route
        // and schema call/drop stacks independently from visual layout depth.
        if sources.component_depth >= 128 {
            self.schema_error = Some(BindError::ComponentDepthLimit);
            return self;
        }
        self.component_depth = self.component_depth.max(sources.component_depth + 1);
        let Some(end) = self.next_scope.checked_add(sources.next_scope) else {
            self.schema_error = Some(BindError::ScopeExhausted);
            return self;
        };
        let start = self.next_scope;
        self.next_scope = end;
        self.components.push(Box::new(ComponentEntry {
            component,
            sources,
            start,
            end,
            parent_dependency,
        }));
        self
    }
    pub(crate) fn component_entry<C: 'static>(
        &self,
        id: FieldId,
    ) -> Result<&ComponentEntry<M, C>, BindError>
    where
        M: 'static,
    {
        self.check_schema()?;
        self.components
            .iter()
            .find(|entry| entry.id() == id)
            .ok_or(BindError::UnknownComponent(id))?
            .as_any()
            .downcast_ref()
            .ok_or(BindError::ReceiverMismatch)
    }
    pub fn len(&self) -> usize {
        self.fields.len()
            + self
                .components
                .iter()
                .map(|entry| entry.len())
                .sum::<usize>()
    }
    pub fn is_empty(&self) -> bool {
        self.len() == 0
    }
    fn component_for(&self, id: FieldId) -> Result<&dyn ComponentSchema<M>, BindError> {
        self.components
            .iter()
            .find(|entry| entry.contains(id))
            .map(|entry| entry.as_ref())
            .ok_or(BindError::UnknownField(id))
    }
    pub(crate) fn invalidates_owner(&self, id: FieldId) -> Result<bool, BindError> {
        self.check_schema()?;
        if id.scope() != 0 {
            return self.component_for(id)?.invalidates_owner(id);
        }
        self.get(id)?;
        Ok(self.owner_fields.contains(&id))
    }
    fn check_schema(&self) -> Result<(), BindError> {
        self.schema_error.clone().map_or(Ok(()), Err)
    }
    fn check_aliases(&self, model: &M) -> Result<(), BindError> {
        let mut projected = Vec::with_capacity(self.len());
        self.collect_signals(model, &mut projected);
        for (index, (id, signal)) in projected.iter().enumerate() {
            for (other_id, other_signal) in &projected[..index] {
                if signal.same(*other_signal) {
                    return Err(BindError::AliasedFields {
                        first: *other_id,
                        second: *id,
                    });
                }
            }
        }
        Ok(())
    }
    /// Mount-time validation requires an exclusive owner borrow to check that
    /// separately supplied read and write projectors select the same field.
    pub fn validate(&self, model: &mut M) -> Result<(), BindError> {
        self.check_schema()?;
        for field in &self.fields {
            field.validate(model)?;
        }
        for component in &self.components {
            component.validate(model)?;
        }
        self.check_aliases(model)
    }
    fn collect_signals<'a>(&self, model: &'a M, output: &mut Vec<(FieldId, &'a dyn ErasedSignal)>) {
        output.extend(
            self.fields
                .iter()
                .map(|field| (field.id(), field.signal(model))),
        );
        for component in &self.components {
            component.collect_signals(model, output);
        }
    }
    fn signal<'a>(&self, model: &'a M, id: FieldId) -> Result<&'a dyn ErasedSignal, BindError> {
        if id.scope() == 0 {
            Ok(self.get(id)?.signal(model))
        } else {
            self.component_for(id)?.signal(model, id)
        }
    }
    pub(crate) fn resolve(
        &self,
        model: &M,
        signal: &dyn ErasedSignal,
    ) -> Result<Option<FieldId>, BindError> {
        self.check_schema()?;
        let mut found = None;
        for field in &self.fields {
            if field.signal(model).same(signal) {
                if let Some(first) = found {
                    return Err(BindError::AliasedFields {
                        first,
                        second: field.id(),
                    });
                }
                found = Some(field.id());
            }
        }
        for component in &self.components {
            if let Some(id) = component.resolve(model, signal)? {
                if let Some(first) = found {
                    return Err(BindError::AliasedFields { first, second: id });
                }
                found = Some(id);
            }
        }
        Ok(found)
    }
    fn get(&self, id: FieldId) -> Result<&dyn Field<M>, BindError> {
        self.fields
            .iter()
            .find(|field| field.id() == id)
            .map(|field| field.as_ref())
            .ok_or(BindError::UnknownField(id))
    }
    pub fn revision(&self, model: &M, id: FieldId) -> Result<Revision, BindError> {
        if id.scope() == 0 {
            Ok(self.get(id)?.revision(model))
        } else {
            self.component_for(id)?.revision(model, id)
        }
    }
    pub(crate) fn freeze<'a>(
        &self,
        model: &'a M,
        id: FieldId,
        codec: SourceCodec,
        needs: Needs,
    ) -> Result<Frozen<'a>, BindError> {
        codec.freeze(self.signal(model, id)?.as_any(), id, needs)
    }
    pub(crate) fn read_text<'a>(
        &self,
        model: &'a M,
        id: FieldId,
        codec: TextCodec,
    ) -> Result<Cow<'a, str>, BindError> {
        codec.read(self.signal(model, id)?.as_any(), id)
    }
    pub(crate) fn write_text(
        &self,
        model: &mut M,
        id: FieldId,
        input: String,
        codec: TextCodec,
    ) -> Result<Revision, TextEditError> {
        if let Err(error) = self.check_schema() {
            return Err(TextEditError {
                field: id,
                input,
                reason: TextEditErrorKind::Binding(error),
            });
        }
        if id.scope() != 0 {
            return match self.component_for(id) {
                Ok(component) => component.write_text(model, id, input, codec),
                Err(error) => Err(TextEditError {
                    field: id,
                    input,
                    reason: TextEditErrorKind::Binding(error),
                }),
            };
        }
        match self.get(id) {
            Ok(field) => field.write_text(model, input, codec),
            Err(error) => Err(TextEditError {
                field: id,
                input,
                reason: TextEditErrorKind::Binding(error),
            }),
        }
    }
    fn scan_into(&self, model: &M, output: &mut Vec<(FieldId, Revision)>) {
        output.extend(
            self.fields
                .iter()
                .map(|field| (field.id(), field.revision(model))),
        );
        for component in &self.components {
            component.scan(model, output);
        }
    }
    /// Scan registered fields after arbitrary owner mutation. Revision equality
    /// alone cannot detect replacement by `Signal::new`; callers must compare
    /// destination values at that conservative owner boundary as well.
    pub fn scan<'a>(
        &'a self,
        model: &'a M,
    ) -> impl ExactSizeIterator<Item = (FieldId, Revision)> + 'a {
        let mut output = Vec::with_capacity(self.len());
        self.scan_into(model, &mut output);
        output.into_iter()
    }
}

#[cfg(test)]
mod tests {
    use super::sealed::TextValue as _;
    use super::*;

    #[test]
    fn field_ids_preserve_the_full_local_domain_and_pair_order() {
        assert_eq!(size_of::<FieldId>(), 8);
        assert_eq!(size_of::<Option<FieldId>>(), 8);
        let mut pairs = Vec::new();
        for local in [0, 1, 0x7fff_ffff, u32::MAX] {
            assert_eq!(FieldId::new(local).get(), local);
            assert_eq!(FieldId::new(local).scope(), 0);
            for scope in [0, 1, 0x7fff_ffff, u32::MAX - 1] {
                let id = FieldId::scoped(local, scope);
                assert_eq!((id.get(), id.scope()), (local, scope));
                pairs.push(((local, scope), id));
            }
        }
        pairs.reverse();
        pairs.sort_unstable_by_key(|(_, id)| *id);
        assert!(pairs.windows(2).all(|pair| pair[0].0 < pair[1].0));
        assert_eq!(FieldId::scoped(u32::MAX, u32::MAX - 1).0.get(), u64::MAX);
        assert_eq!(
            format!("{:?}", FieldId::new(u32::MAX)),
            "FieldId { local: 4294967295, scope: 0 }"
        );
    }

    struct Model {
        first: Signal<String>,
        second: Signal<String>,
        count: Signal<u32>,
    }
    const FIRST: Source<Model, String> =
        Source::new(FieldId::new(1), "first", |m| &m.first, |m| &mut m.first);
    const SECOND: Source<Model, String> =
        Source::new(FieldId::new(2), "second", |m| &m.second, |m| &mut m.second);
    const COUNT: Source<Model, u32> =
        Source::new(FieldId::new(3), "count", |m| &m.count, |m| &mut m.count);
    fn model() -> Model {
        Model {
            first: Signal::new("same".into()),
            second: Signal::new("same".into()),
            count: Signal::new(4),
        }
    }
    fn sources() -> Sources<Model> {
        Sources::new().field(FIRST).field(SECOND).field(COUNT)
    }

    #[test]
    fn same_typed_fields_bind_by_projection_not_equal_value() {
        let mut model = model();
        let sources = sources();
        sources.validate(&mut model).unwrap();
        let first = (&model.first).into_text();
        let second = (&model.second).into_text();
        assert_eq!(
            sources.resolve(&model, first.signal().unwrap()),
            Ok(Some(FIRST.id()))
        );
        assert_eq!(
            sources.resolve(&model, second.signal().unwrap()),
            Ok(Some(SECOND.id()))
        );
        let unrelated = Signal::new("same".to_owned());
        assert_eq!(sources.resolve(&model, &unrelated), Ok(None));
    }

    #[test]
    fn bound_key_survives_moving_the_entire_model() {
        let mut original = model();
        let sources = sources();
        sources.validate(&mut original).unwrap();
        let key = sources
            .resolve(&original, &original.second)
            .unwrap()
            .unwrap();
        let mut moved = Box::new(original);
        sources
            .write_text(
                &mut moved,
                key,
                "after move".into(),
                TextCodec::for_value::<String>(),
            )
            .unwrap();
        assert_eq!(&*moved.first, "same");
        assert_eq!(&*moved.second, "after move");
    }

    #[test]
    fn mismatched_read_write_paths_fail_before_a_value_mutates() {
        let bad = Source::new(
            FieldId::new(5),
            "bad",
            |m: &Model| &m.first,
            |m| &mut m.second,
        );
        let sources = Sources::new().field(bad);
        let mut model = model();
        assert_eq!(
            sources.validate(&mut model),
            Err(BindError::ProjectionMismatch(bad.id()))
        );
        let before = model.second.revision();
        let error = sources
            .write_text(
                &mut model,
                bad.id(),
                "edit".into(),
                TextCodec::for_value::<String>(),
            )
            .unwrap_err();
        assert_eq!(error.input, "edit");
        assert_eq!(
            error.reason,
            TextEditErrorKind::Binding(BindError::ProjectionMismatch(bad.id()))
        );
        assert_eq!(&*model.second, "same");
        assert_eq!(model.second.revision(), before);
    }

    #[test]
    fn aliased_fields_are_ambiguous_even_when_keys_differ() {
        let alias = Source::new(
            FieldId::new(5),
            "alias",
            |m: &Model| &m.first,
            |m| &mut m.first,
        );
        let sources = Sources::new().field(FIRST).field(alias);
        let mut model = model();
        let expected = Err(BindError::AliasedFields {
            first: FIRST.id(),
            second: alias.id(),
        });
        assert_eq!(sources.validate(&mut model), expected);
        assert_eq!(
            sources.resolve(&model, &model.first),
            expected.map(|()| None)
        );
    }

    #[test]
    fn duplicate_names_and_ids_are_rejected() {
        let mut model = model();
        assert_eq!(
            Sources::new()
                .field(FIRST)
                .field(FIRST)
                .validate(&mut model),
            Err(BindError::DuplicateId(FIRST.id()))
        );
        let duplicate = Source::new(
            SECOND.id(),
            FIRST.name(),
            |m: &Model| &m.second,
            |m| &mut m.second,
        );
        assert_eq!(
            Sources::new()
                .field(FIRST)
                .field(duplicate)
                .validate(&mut model),
            Err(BindError::DuplicateName(FIRST.name()))
        );
    }

    #[test]
    fn parse_failure_returns_payload_and_preserves_value_and_revision() {
        let mut model = model();
        let sources = sources();
        let revision = model.count.revision();
        let input = "not a number".to_owned();
        let pointer = input.as_ptr();
        let error = sources
            .write_text(&mut model, COUNT.id(), input, TextCodec::for_value::<u32>())
            .unwrap_err();
        assert_eq!(error.input.as_ptr(), pointer);
        assert_eq!(error.reason, TextEditErrorKind::InvalidValue("invalid u32"));
        assert_eq!(*model.count, 4);
        assert_eq!(model.count.revision(), revision);
        let revision = sources
            .write_text(
                &mut model,
                COUNT.id(),
                "42".into(),
                TextCodec::for_value::<u32>(),
            )
            .unwrap();
        assert_eq!(*model.count, 42);
        assert_eq!(revision.get(), 1);
    }

    #[test]
    fn unchanged_borrowed_strings_are_zero_copy() {
        let string = "borrowed".to_owned();
        let signal = Signal::new(string.clone());
        for text in [string.as_str().into_text(), (&string).into_text()] {
            let value = text.borrowed_value();
            assert!(matches!(value, Cow::Borrowed(_)));
            assert_eq!(value.as_ptr(), string.as_ptr());
        }
        let text = (&signal).into_text();
        let value = text.borrowed_value();
        assert!(matches!(value, Cow::Borrowed(_)));
        assert_eq!(value.as_ptr(), signal.as_ptr());
    }

    #[test]
    fn string_edits_transfer_the_owned_input_allocation() {
        let sources = sources();
        let mut model = model();
        let input = "input moved into the signal".to_owned();
        let pointer = input.as_ptr();
        sources
            .write_text(
                &mut model,
                FIRST.id(),
                input,
                TextCodec::for_value::<String>(),
            )
            .unwrap();
        assert_eq!(model.first.as_ptr(), pointer);
    }

    #[test]
    fn scan_reports_all_registered_field_revisions() {
        let mut model = model();
        let sources = sources();
        *model.second = "changed".into();
        *model.count += 1;
        let scanned: Vec<_> = sources
            .scan(&model)
            .map(|(id, revision)| (id, revision.get()))
            .collect();
        assert_eq!(
            scanned,
            vec![(FIRST.id(), 0), (SECOND.id(), 1), (COUNT.id(), 1)]
        );
    }

    #[test]
    fn replacement_revision_equality_requires_owner_boundary_value_comparison() {
        let mut model = model();
        let sources = sources();
        let before = sources.revision(&model, FIRST.id()).unwrap();
        model.first = Signal::new("replacement".into());
        assert_eq!(sources.revision(&model, FIRST.id()).unwrap(), before);
        assert_eq!(
            sources
                .read_text(&model, FIRST.id(), TextCodec::for_value::<String>())
                .unwrap(),
            "replacement"
        );
        assert_eq!(sources.resolve(&model, &model.first), Ok(Some(FIRST.id())));
    }

    #[test]
    fn every_supported_scalar_formats_and_floats_validate() {
        assert_eq!((&Signal::new(1u32)).into_text().borrowed_value(), "1");
        assert_eq!((&Signal::new(2u64)).into_text().borrowed_value(), "2");
        assert_eq!((&Signal::new(-3i32)).into_text().borrowed_value(), "-3");
        assert_eq!((&Signal::new(true)).into_text().borrowed_value(), "true");
        assert_eq!((&Signal::new(1.5f64)).into_text().borrowed_value(), "1.5");
        assert!(f64::parse_text("NaN").is_err());
        assert!(f64::parse_text("inf").is_err());
    }

    #[test]
    fn exact_action_edits_only_its_value_and_requires_registered_projection() {
        let sources = sources();
        let mut model = model();
        let action = COUNT.update(|value| *value += 1);
        assert_eq!(action.validate_registered(&model, &sources), Ok(COUNT.id()));
        action.invoke(&mut model).unwrap();
        assert_eq!(*model.count, 5);
        assert_eq!(model.first.revision().get(), 0);
        let imposter = Source::new(
            FIRST.id(),
            "other",
            |m: &Model| &m.second,
            |m| &mut m.second,
        );
        assert_eq!(
            imposter.borrow_registered(&model, &sources).map(|_| ()),
            Err(BindError::ProjectionMismatch(FIRST.id()))
        );
    }

    #[test]
    fn unknown_key_returns_unchanged_payload() {
        let sources = sources();
        let mut model = model();
        let unknown = FieldId::new(500);
        let error = sources
            .write_text(
                &mut model,
                unknown,
                "retained".into(),
                TextCodec::for_value::<String>(),
            )
            .unwrap_err();
        assert_eq!(error.input, "retained");
        assert_eq!(
            error.reason,
            TextEditErrorKind::Binding(BindError::UnknownField(unknown))
        );
    }

    #[test]
    fn binding_and_scanning_read_each_field_once_exact_edits_read_only_the_target() {
        use std::cell::Cell;
        struct Counted {
            first: Signal<u32>,
            second: Signal<u32>,
            reads: [Cell<usize>; 2],
        }
        // Instrumentation counts projector discovery without changing values.
        let first = Source::new(
            FieldId::new(1),
            "first",
            |m: &Counted| {
                m.reads[0].set(m.reads[0].get() + 1);
                &m.first
            },
            |m| &mut m.first,
        );
        let second = Source::new(
            FieldId::new(2),
            "second",
            |m: &Counted| {
                m.reads[1].set(m.reads[1].get() + 1);
                &m.second
            },
            |m| &mut m.second,
        );
        let sources = Sources::new().field(first).field(second);
        let mut model = Counted {
            first: Signal::new(1),
            second: Signal::new(2),
            reads: [Cell::new(0), Cell::new(0)],
        };
        assert_eq!(sources.resolve(&model, &model.first), Ok(Some(first.id())));
        assert_eq!([model.reads[0].get(), model.reads[1].get()], [1, 1]);
        assert_eq!(sources.scan(&model).count(), 2);
        assert_eq!([model.reads[0].get(), model.reads[1].get()], [2, 2]);
        sources
            .write_text(
                &mut model,
                first.id(),
                "5".into(),
                TextCodec::for_value::<u32>(),
            )
            .unwrap();
        assert_eq!([model.reads[0].get(), model.reads[1].get()], [3, 2]);
        assert_eq!(*model.first, 5);
        assert_eq!(*model.second, 2);
    }

    #[test]
    fn domain_sources_register_resolve_and_edit_without_text_support() {
        #[derive(Debug, PartialEq, Eq)]
        struct Domain {
            enabled: bool,
            entries: Vec<u8>,
        }
        struct Owner {
            domain: Signal<Domain>,
        }
        const DOMAIN: Source<Owner, Domain> =
            Source::new(FieldId::new(7), "domain", |m| &m.domain, |m| &mut m.domain);
        let sources = Sources::new().field(DOMAIN);
        let mut owner = Owner {
            domain: Signal::new(Domain {
                enabled: false,
                entries: vec![1, 2],
            }),
        };
        sources.validate(&mut owner).unwrap();
        assert_eq!(
            sources.resolve(&owner, &owner.domain),
            Ok(Some(DOMAIN.id()))
        );
        let action = DOMAIN.update(|value| {
            value.enabled = true;
            value.entries.push(3);
        });
        action.validate_registered(&owner, &sources).unwrap();
        action.invoke(&mut owner).unwrap();
        assert_eq!(
            *owner.domain,
            Domain {
                enabled: true,
                entries: vec![1, 2, 3]
            }
        );
        assert_eq!(sources.revision(&owner, DOMAIN.id()).unwrap().get(), 1);
    }

    #[test]
    fn a_text_operand_supplies_the_codec_and_wrong_codecs_cannot_edit() {
        let mut model = model();
        let sources = sources();
        let codec = (&model.first).into_text().codec().unwrap();
        assert_eq!(
            sources.read_text(&model, FIRST.id(), codec).unwrap(),
            "same"
        );
        let before = model.count.revision();
        assert_eq!(
            sources.read_text(&model, COUNT.id(), codec),
            Err(BindError::TypeMismatch(COUNT.id()))
        );
        let input = "100".to_owned();
        let pointer = input.as_ptr();
        let error = sources
            .write_text(&mut model, COUNT.id(), input, codec)
            .unwrap_err();
        assert_eq!(error.input.as_ptr(), pointer);
        assert_eq!(
            error.reason,
            TextEditErrorKind::Binding(BindError::TypeMismatch(COUNT.id()))
        );
        assert_eq!(*model.count, 4);
        assert_eq!(model.count.revision(), before);
        assert!(Text::literal("literal").codec().is_none());
    }

    #[test]
    fn owner_dependency_is_the_default_and_direct_ports_are_explicit() {
        let ordinary = Sources::new().field(FIRST);
        let direct = Sources::new().direct(FIRST);
        assert_eq!(ordinary.invalidates_owner(FIRST.id()), Ok(true));
        assert_eq!(direct.invalidates_owner(FIRST.id()), Ok(false));
        assert_eq!(
            direct.invalidates_owner(COUNT.id()),
            Err(BindError::UnknownField(COUNT.id()))
        );
    }
}

#[cfg(test)]
mod component_tests {
    use super::*;
    use crate::{El, text};
    struct Child {
        value: Signal<u32>,
    }
    impl Child {
        const VALUE: Source<Self, u32> =
            Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
    }
    impl View for Child {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Self::VALUE)
        }
        fn view(&self) -> El<'_> {
            text(&self.value)
        }
    }
    struct Parent {
        left: Child,
        right: Child,
    }
    const LEFT: Component<Parent, Child> =
        Component::new(FieldId::new(1), "left", |m| &m.left, |m| &mut m.left);
    const RIGHT: Component<Parent, Child> =
        Component::new(FieldId::new(2), "right", |m| &m.right, |m| &mut m.right);
    fn model() -> Parent {
        Parent {
            left: Child {
                value: Signal::new(1),
            },
            right: Child {
                value: Signal::new(2),
            },
        }
    }
    #[test]
    fn component_schemas_reject_duplicate_names_ids_and_cross_scope_source_aliases() {
        let mut model = model();
        assert_eq!(
            Sources::new()
                .component(LEFT)
                .component(LEFT)
                .validate(&mut model),
            Err(BindError::DuplicateComponent(LEFT.id()))
        );
        let duplicate_id =
            Component::new(LEFT.id(), "other", |m: &Parent| &m.right, |m| &mut m.right);
        assert_eq!(
            Sources::new()
                .component(LEFT)
                .component(duplicate_id)
                .validate(&mut model),
            Err(BindError::DuplicateComponent(LEFT.id()))
        );
        let alias = Component::new(RIGHT.id(), "right", |m: &Parent| &m.left, |m| &mut m.left);
        assert!(matches!(
            Sources::new()
                .component(LEFT)
                .component(alias)
                .validate(&mut model),
            Err(BindError::AliasedFields { .. })
        ));
        let field = Source::new(
            FieldId::new(1),
            "left",
            |m: &Parent| &m.right.value,
            |m| &mut m.right.value,
        );
        assert_eq!(
            Sources::new()
                .field(field)
                .component(LEFT)
                .validate(&mut model),
            Err(BindError::DuplicateName("left"))
        );
        assert_eq!(
            Sources::new()
                .component(LEFT)
                .field(field)
                .validate(&mut model),
            Err(BindError::DuplicateName("left"))
        );
    }
    #[test]
    fn scoped_scan_and_revision_preserve_local_ids_without_namespace_collision() {
        let mut model = model();
        let sources = Sources::new()
            .direct_component(LEFT)
            .direct_component(RIGHT);
        sources.validate(&mut model).unwrap();
        *model.right.value += 1;
        let values: Vec<_> = sources.scan(&model).collect();
        assert_eq!(values.len(), 2);
        assert_eq!(values[0].0.get(), 1);
        assert_eq!(values[1].0.get(), 1);
        assert_ne!(values[0].0, values[1].0);
        assert_eq!(values[1].1.get(), 1);
        assert_eq!(sources.revision(&model, values[1].0).unwrap().get(), 1);
        assert!(!sources.invalidates_owner(values[0].0).unwrap());
    }
    #[test]
    fn namespace_exhaustion_is_checked_before_a_component_is_registered() {
        let mut sources = Sources::<Parent>::new();
        sources.next_scope = u32::MAX;
        let sources = sources.component(LEFT);
        assert_eq!(
            sources.validate(&mut model()),
            Err(BindError::ScopeExhausted)
        );
    }

    #[test]
    fn the_last_component_namespace_routes_edits_before_exhaustion() {
        let mut sources = Sources::<Parent>::new();
        sources.next_scope = u32::MAX - 1;
        let sources = sources.component(LEFT);
        let mut model = model();
        sources.validate(&mut model).unwrap();
        assert_eq!(sources.next_scope, u32::MAX);
        let id = sources.resolve(&model, &model.left.value).unwrap().unwrap();
        assert_eq!((id.get(), id.scope()), (1, u32::MAX - 1));
        let codec = (&model.left.value).into_text().codec().unwrap();
        sources
            .write_text(&mut model, id, "42".to_owned(), codec)
            .unwrap();
        assert_eq!(*model.left.value, 42);
        assert_eq!(sources.revision(&model, id).unwrap().get(), 1);
        let sources = sources.component(RIGHT);
        assert_eq!(sources.components.len(), 1);
        assert_eq!(sources.validate(&mut model), Err(BindError::ScopeExhausted));
    }

    #[test]
    fn resolved_component_ids_are_rejected_as_local_source_declarations() {
        let mut model = model();
        let sources = Sources::new().component(LEFT);
        sources.validate(&mut model).unwrap();
        let id = sources.resolve(&model, &model.left.value).unwrap().unwrap();
        let misplaced = Source::new(
            id,
            "misplaced",
            |m: &Parent| &m.right.value,
            |m| &mut m.right.value,
        );
        assert_eq!(
            Sources::new().direct(misplaced).validate(&mut model),
            Err(BindError::NonLocalDeclaration(id))
        );
        let misplaced = Component::new(id, "misplaced", |m: &Parent| &m.right, |m| &mut m.right);
        assert_eq!(
            Sources::new().component(misplaced).validate(&mut model),
            Err(BindError::NonLocalDeclaration(id))
        );
    }
}
