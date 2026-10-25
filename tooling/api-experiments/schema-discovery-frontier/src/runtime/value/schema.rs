//! Immutable structural schemas and checked native role adapters.
use super::{FieldRegistration, FieldSchema, Value, ValueMut};
use std::{
    any::{Any, TypeId},
    collections::HashMap,
    marker::PhantomData,
    sync::{LazyLock, OnceLock, RwLock},
};

/// Describes the fields of one concrete type.
///
/// `build_type` must not recursively ask for the shape of a child type. Store child-shape function
/// pointers in fields instead; the runtime calls them only after this root schema has been cached.
/// This keeps self-recursive and mutually recursive types out of schema-initialization deadlocks.
pub trait Describe: Any + Sized {
    /// Builds the immutable schema for this concrete monomorphization.
    fn build_type() -> Schema<Self>;

    /// Returns this concrete type's process-owned schema.
    fn type_shape() -> Type {
        Type::of::<Self>()
    }
}

/// A cheap copyable handle to a process-owned runtime type description.
#[derive(Clone, Copy)]
pub struct Type(&'static TypeSlot);
impl PartialEq for Type {
    fn eq(&self, other: &Self) -> bool {
        std::ptr::eq(self.0, other.0)
    }
}
impl Eq for Type {}
impl std::fmt::Debug for Type {
    fn fmt(&self, formatter: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        formatter
            .debug_struct("Type")
            .field("name", &self.name())
            .field("type_id", &self.type_id())
            .finish()
    }
}

/// The broad structural category of a reflected type.
///
/// For schemas with both enum and sequence behavior, such as `Option<T>`, `kind()` returns
/// [`TypeKind::Enum`]. Use `Type::is_sequence` to query the additional sequence behavior.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum TypeKind {
    /// No structural schema is available.
    Opaque,
    /// A described struct-like type.
    Struct,
    /// An enum, including enums with payload fields.
    Enum,
    /// A sequence-like type such as `Vec<T>` or `Option<T>`.
    Sequence,
    /// An owned pointer with safe access to its pointee at index zero.
    BoxPointer,
    /// A fixed-size array with safe indexed access.
    ArraySequence,
}

/// A safe projection from a concrete receiver to one native trait-object view.
///
/// Use the generated role handle when available. This constructor is the manual escape hatch for
/// a trait implementation the schema generator cannot see.
pub struct Role<Root, Target: ?Sized + 'static> {
    project: for<'a> fn(&'a mut Root) -> &'a mut Target,
}
impl<Root, Target: ?Sized + 'static> Role<Root, Target> {
    /// Creates a role projection from a safe Rust coercion or field borrow.
    pub const fn new(project: for<'a> fn(&'a mut Root) -> &'a mut Target) -> Self {
        Self { project }
    }
}
impl<Root: Any, Target: ?Sized + 'static> Role<Root, Target> {
    /// Erases this typed role adapter for an immutable process-owned schema.
    #[doc(hidden)]
    pub fn into_schema(self) -> RoleRegistration<Root> {
        RoleRegistration {
            marker: PhantomData,
            target_type: TypeId::of::<Target>(),
            slot: Box::new(RoleSlot::<Target> {
                adapter: Box::new(BoundRole {
                    project: self.project,
                    marker: PhantomData,
                }),
                marker: PhantomData,
            }),
        }
    }
}

/// One generated native role adapter, consumed while building a type schema.
#[doc(hidden)]
pub struct RoleRegistration<Root> {
    marker: PhantomData<fn(Root) -> Root>,
    target_type: TypeId,
    slot: Box<dyn Any + Send + Sync>,
}

trait RoleAdapter<Target: ?Sized + 'static>: Send + Sync {
    fn project<'a>(&self, root: &'a mut dyn Any) -> Option<&'a mut Target>;
}
struct BoundRole<Root: 'static, Target: ?Sized + 'static> {
    project: for<'a> fn(&'a mut Root) -> &'a mut Target,
    marker: PhantomData<fn(&mut Root) -> &mut Target>,
}
impl<Root: 'static, Target: ?Sized + 'static> RoleAdapter<Target> for BoundRole<Root, Target> {
    fn project<'a>(&self, root: &'a mut dyn Any) -> Option<&'a mut Target> {
        Some((self.project)(root.downcast_mut::<Root>()?))
    }
}
struct RoleSlot<Target: ?Sized + 'static> {
    adapter: Box<dyn RoleAdapter<Target>>,
    marker: PhantomData<fn(&mut Target) -> &mut Target>,
}

/// A prepared native trait projection. It retains metadata, never a receiver borrow.
///
/// Resolve once with `Type::role`, then use `get_mut` on successive concrete values.
/// Every call still checks the concrete receiver before lending its native trait view.
pub struct RoleProjection<Target: ?Sized + 'static>(&'static RoleSlot<Target>);
impl<Target: ?Sized + 'static> Copy for RoleProjection<Target> {}
impl<Target: ?Sized + 'static> Clone for RoleProjection<Target> {
    fn clone(&self) -> Self {
        *self
    }
}
impl<Target: ?Sized + 'static> RoleProjection<Target> {
    /// Borrows the registered view, or returns `None` for a different concrete receiver.
    pub fn get_mut<'a>(&self, root: &'a mut dyn Any) -> Option<&'a mut Target> {
        self.0.adapter.project(root)
    }
}

/// A root-typed schema assembled before its metadata is published.
///
/// Field and role registrations retain their root type until this boundary. A schema cannot
/// accidentally attach an accessor for a different receiver, even when assembled manually.
pub struct Schema<Root: Any> {
    shape: TypeShape,
    marker: PhantomData<fn(Root) -> Root>,
}
impl<Root: Any> Schema<Root> {
    /// Builds a schema from checked native field accessors.
    pub fn new(
        fields: Vec<FieldRegistration<Root>>,
        variant: Option<fn(&Root) -> &'static str>,
    ) -> Self {
        Self::with_roles(fields, variant, Vec::new())
    }

    /// Builds a schema with checked native trait projections.
    pub fn with_roles(
        fields: Vec<FieldRegistration<Root>>,
        variant: Option<fn(&Root) -> &'static str>,
        roles: Vec<RoleRegistration<Root>>,
    ) -> Self {
        let mut roles: Vec<_> = roles
            .into_iter()
            .map(|role| RoleEntry {
                target_type: role.target_type,
                slot: role.slot,
            })
            .collect();
        roles.sort_unstable_by_key(|entry| entry.target_type);
        assert!(
            roles
                .windows(2)
                .all(|pair| pair[0].target_type != pair[1].target_type),
            "duplicate native role target"
        );
        Self {
            shape: TypeShape {
                fields: fields.into_iter().map(FieldRegistration::erase).collect(),
                variant: variant.map(|project| {
                    Box::new(BoundVariant::<Root>(project)) as Box<dyn VariantSchema>
                }),
                sequence: None,
                roles: roles.into_boxed_slice(),
            },
            marker: PhantomData,
        }
    }

    /// Publishes this schema once. Every existing handle to the same Rust type sees it.
    ///
    /// Prefer `Type::of` for a `Describe` implementation: it also builds the schema only once
    /// when several threads ask for it concurrently.
    pub fn publish(self) -> Type {
        let ty = Type::opaque::<Root>();
        ty.0.shape.get_or_init(|| self.shape);
        ty
    }

    fn sequence(
        item_shape: fn() -> Type,
        len: fn(&dyn Any) -> Option<usize>,
        get: for<'a> fn(&'a dyn Any, usize) -> Option<&'a dyn Any>,
        get_mut: for<'a> fn(&'a mut dyn Any, usize) -> Option<&'a mut dyn Any>,
        kind: SequenceKind,
        variant: Option<fn(&Root) -> &'static str>,
    ) -> Self {
        Self {
            shape: TypeShape {
                fields: Box::new([]),
                variant: variant.map(|project| {
                    Box::new(BoundVariant::<Root>(project)) as Box<dyn VariantSchema>
                }),
                sequence: Some(SequenceSchema {
                    len,
                    get,
                    get_mut,
                    item_shape,
                    item_type: OnceLock::new(),
                    kind,
                }),
                roles: Box::new([]),
            },
            marker: PhantomData,
        }
    }
}

/// Typed schema constructors for standard containers. These return unpublished shapes so a
/// container's `Describe::build_type` does not re-enter its canonical `Type` slot.
impl<T: Any> Schema<Vec<T>> {
    pub fn vec(item_shape: fn() -> Type) -> Self {
        Self::sequence(
            item_shape,
            vec_len::<T>,
            vec_get::<T>,
            vec_get_mut::<T>,
            SequenceKind::Sequence,
            None,
        )
    }
}
impl<T: Any> Schema<Option<T>> {
    pub fn option(item_shape: fn() -> Type) -> Self {
        Self::sequence(
            item_shape,
            option_len::<T>,
            option_get::<T>,
            option_get_mut::<T>,
            SequenceKind::EnumSequence,
            Some(|value| if value.is_some() { "Some" } else { "None" }),
        )
    }
}
impl<T: Any> Schema<Box<T>> {
    pub fn boxed(item_shape: fn() -> Type) -> Self {
        Self::sequence(
            item_shape,
            box_len::<T>,
            box_get::<T>,
            box_get_mut::<T>,
            SequenceKind::BoxPointer,
            None,
        )
    }
}
impl<T: Any, const N: usize> Schema<[T; N]> {
    pub fn array(item_shape: fn() -> Type) -> Self {
        Self::sequence(
            item_shape,
            array_len::<T, N>,
            array_get::<T, N>,
            array_get_mut::<T, N>,
            SequenceKind::ArraySequence,
            None,
        )
    }
}

struct TypeSlot {
    name: &'static str,
    type_id: TypeId,
    accepts: fn(&dyn Any) -> bool,
    shape: OnceLock<TypeShape>,
}
struct TypeShape {
    fields: Box<[Box<dyn FieldSchema>]>,
    variant: Option<Box<dyn VariantSchema>>,
    sequence: Option<SequenceSchema>,
    roles: Box<[RoleEntry]>,
}
trait VariantSchema: Send + Sync {
    fn variant(&self, value: &dyn Any) -> Option<&'static str>;
}
struct BoundVariant<Root>(fn(&Root) -> &'static str);
impl<Root: Any> VariantSchema for BoundVariant<Root> {
    fn variant(&self, value: &dyn Any) -> Option<&'static str> {
        Some(self.0(value.downcast_ref::<Root>()?))
    }
}

/// A point-in-time schema identity for caches that also store failed lookups.
///
/// `Type` identity is permanent, but an opaque slot may gain metadata once. A snapshot records
/// that transition so a previously cached missing role is checked again after publication.
#[doc(hidden)]
#[derive(Clone, Copy)]
pub struct TypeSnapshot {
    slot: &'static TypeSlot,
    shape: Option<&'static TypeShape>,
}
impl TypeSnapshot {
    pub(crate) fn same_schema(self, other: Self) -> bool {
        std::ptr::eq(self.slot, other.slot)
            && match (self.shape, other.shape) {
                (Some(a), Some(b)) => std::ptr::eq(a, b),
                (None, None) => true,
                _ => false,
            }
    }
}

impl Type {
    /// Returns the canonical schema for this concrete type, initializing it at most once.
    pub fn of<T: Describe>() -> Type {
        let ty = Self::opaque::<T>();
        // The builder stores child factories without invoking them. This is essential for
        // recursive types: no child can re-enter this slot while its shape is being built.
        ty.0.shape.get_or_init(|| T::build_type().shape);
        ty
    }

    /// Returns the canonical identity for a type whose structure may not yet be described.
    ///
    /// Exact downcasts work immediately. If metadata is published later, all copies of this
    /// handle observe it; child descriptors never retain a permanently opaque schema copy.
    pub fn opaque<T: Any>() -> Type {
        let type_id = TypeId::of::<T>();
        if let Some(ty) = read_schemas().get(&type_id).copied() {
            return ty;
        }
        let mut schemas = schemas()
            .write()
            .unwrap_or_else(std::sync::PoisonError::into_inner);
        *schemas.entry(type_id).or_insert_with(|| {
            Type(Box::leak(Box::new(TypeSlot {
                name: std::any::type_name::<T>(),
                type_id,
                accepts: accepts::<T>,
                shape: OnceLock::new(),
            })))
        })
    }

    /// Captures the current metadata generation for a prepared lookup cache.
    #[doc(hidden)]
    pub fn snapshot(self) -> TypeSnapshot {
        TypeSnapshot {
            slot: self.0,
            shape: self.0.shape.get(),
        }
    }

    /// Returns a `Vec<T>` schema with lazy, checked index access.
    pub fn vec<T: Any>(item_shape: fn() -> Type) -> Type {
        Self::sequence::<Vec<T>>(
            item_shape,
            vec_len::<T>,
            vec_get::<T>,
            vec_get_mut::<T>,
            SequenceKind::Sequence,
            None,
        )
    }

    /// Returns an `Option<T>` schema with `Some`/`None` variants and index-zero access.
    pub fn option<T: Any>(item_shape: fn() -> Type) -> Type {
        Self::sequence::<Option<T>>(
            item_shape,
            option_len::<T>,
            option_get::<T>,
            option_get_mut::<T>,
            SequenceKind::EnumSequence,
            Some(|value| if value.is_some() { "Some" } else { "None" }),
        )
    }

    /// Returns a `Box<T>` schema with safe access to its pointee at index zero.
    pub fn boxed<T: Any>(item_shape: fn() -> Type) -> Type {
        Self::sequence::<Box<T>>(
            item_shape,
            box_len::<T>,
            box_get::<T>,
            box_get_mut::<T>,
            SequenceKind::BoxPointer,
            None,
        )
    }

    /// Returns a `[T; N]` schema with checked bounds and lazy element metadata.
    pub fn array<T: Any, const N: usize>(item_shape: fn() -> Type) -> Type {
        Self::sequence::<[T; N]>(
            item_shape,
            array_len::<T, N>,
            array_get::<T, N>,
            array_get_mut::<T, N>,
            SequenceKind::ArraySequence,
            None,
        )
    }

    fn sequence<Root: Any>(
        item_shape: fn() -> Type,
        len: fn(&dyn Any) -> Option<usize>,
        get: for<'a> fn(&'a dyn Any, usize) -> Option<&'a dyn Any>,
        get_mut: for<'a> fn(&'a mut dyn Any, usize) -> Option<&'a mut dyn Any>,
        kind: SequenceKind,
        variant: Option<fn(&Root) -> &'static str>,
    ) -> Type {
        let ty = Self::opaque::<Root>();
        ty.0.shape.get_or_init(|| TypeShape {
            fields: Box::new([]),
            variant: variant
                .map(|project| Box::new(BoundVariant::<Root>(project)) as Box<dyn VariantSchema>),
            sequence: Some(SequenceSchema {
                len,
                get,
                get_mut,
                item_shape,
                item_type: OnceLock::new(),
                kind,
            }),
            roles: Box::new([]),
        });
        ty
    }

    /// Whether this schema has a native view for an exact trait-object target.
    pub fn has_role<Target: ?Sized + 'static>(self) -> bool {
        self.role_entry(TypeId::of::<Target>()).is_some()
    }

    /// Prepares a checked native projection for repeated access to this schema's role.
    pub fn role<Target: ?Sized + 'static>(self) -> Option<RoleProjection<Target>> {
        let slot = self
            .role_entry(TypeId::of::<Target>())?
            .slot
            .downcast_ref()?;
        Some(RoleProjection(slot))
    }

    fn role_entry(self, target: TypeId) -> Option<&'static RoleEntry> {
        let roles = &self.0.shape.get()?.roles;
        // Most values expose only a few views. Keep those lookups linear and
        // contiguous, while bounding comparisons for schemas with many roles.
        if roles.len() <= 8 {
            roles.iter().find(|entry| entry.target_type == target)
        } else {
            roles
                .binary_search_by_key(&target, |entry| entry.target_type)
                .ok()
                .map(|index| &roles[index])
        }
    }

    /// The broad structural category of this schema.
    pub fn kind(self) -> TypeKind {
        let Some(shape) = self.0.shape.get() else {
            return TypeKind::Opaque;
        };
        if shape.variant.is_some() {
            TypeKind::Enum
        } else if let Some(sequence) = &shape.sequence {
            match sequence.kind {
                SequenceKind::Sequence | SequenceKind::EnumSequence => TypeKind::Sequence,
                SequenceKind::BoxPointer => TypeKind::BoxPointer,
                SequenceKind::ArraySequence => TypeKind::ArraySequence,
            }
        } else {
            TypeKind::Struct
        }
    }

    /// Whether this schema describes a sequence-like value.
    pub fn is_sequence(self) -> bool {
        self.0
            .shape
            .get()
            .is_some_and(|shape| shape.sequence.is_some())
    }

    /// Whether this schema describes an enum.
    pub fn is_enum(self) -> bool {
        self.0
            .shape
            .get()
            .is_some_and(|shape| shape.variant.is_some())
    }

    /// The Rust type name.
    pub fn name(self) -> &'static str {
        self.0.name
    }
    /// The identity used to validate a borrowed erased receiver.
    pub fn type_id(self) -> TypeId {
        self.0.type_id
    }
    /// Returns whether an erased value has this exact Rust type.
    pub fn accepts(self, value: &dyn Any) -> bool {
        (self.0.accepts)(value)
    }
    /// Returns the active enum variant, if this type is an enum.
    pub fn variant(self, value: &dyn Any) -> Option<&'static str> {
        self.0.shape.get()?.variant.as_ref()?.variant(value)
    }
    /// Iterates static field names without allocating. Enum names may repeat across variants.
    pub fn field_names(self) -> impl Iterator<Item = &'static str> {
        self.field_descriptors().iter().map(|field| field.name())
    }
    /// Iterates field names and their optional enum variant qualifiers.
    pub fn fields(self) -> impl Iterator<Item = FieldDescription> + 'static {
        let fields = self.field_descriptors();
        fields.iter().map(|field| FieldDescription {
            name: field.name(),
            variant: field.variant(),
            ty: field.child_type(),
        })
    }

    pub(super) fn field_descriptors(self) -> &'static [Box<dyn FieldSchema>] {
        self.0.shape.get().map_or(&[], |shape| &shape.fields)
    }

    pub(super) fn field<'a>(self, value: &'a dyn Any, name: &str) -> Option<Value<'a>> {
        self.field_descriptors()
            .iter()
            .find(|field| field.name() == name && field.is_active(value))?
            .get(value)
    }
    pub(super) fn field_mut<'a>(self, value: &'a mut dyn Any, name: &str) -> Option<ValueMut<'a>> {
        let field = self
            .field_descriptors()
            .iter()
            .find(|field| field.name() == name && field.is_active(&*value))?;
        field.get_mut(value)
    }
    pub(super) fn index<'a>(self, value: &'a dyn Any, index: usize) -> Option<Value<'a>> {
        let sequence = self.0.shape.get()?.sequence.as_ref()?;
        if index >= (sequence.len)(value)? {
            return None;
        }
        Some(Value::from_parts(
            (sequence.get)(value, index)?,
            sequence.item_type(),
        ))
    }
    pub(super) fn index_mut<'a>(
        self,
        value: &'a mut dyn Any,
        index: usize,
    ) -> Option<ValueMut<'a>> {
        let sequence = self.0.shape.get()?.sequence.as_ref()?;
        if index >= (sequence.len)(value)? {
            return None;
        }
        Some(ValueMut::from_parts(
            (sequence.get_mut)(value, index)?,
            sequence.item_type(),
        ))
    }

    pub(super) fn len(self, value: &dyn Any) -> Option<usize> {
        (self.0.shape.get()?.sequence.as_ref()?.len)(value)
    }
}

/// Static field metadata for type inspectors. Variant is present for enum payload fields.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct FieldDescription {
    /// The field name (numeric text for tuple fields).
    pub name: &'static str,
    /// The variant that owns the field, or `None` for a struct field.
    pub variant: Option<&'static str>,
    /// The schema for this field's value.
    pub ty: Type,
}

struct SequenceSchema {
    len: fn(&dyn Any) -> Option<usize>,
    get: for<'a> fn(&'a dyn Any, usize) -> Option<&'a dyn Any>,
    get_mut: for<'a> fn(&'a mut dyn Any, usize) -> Option<&'a mut dyn Any>,
    item_shape: fn() -> Type,
    item_type: OnceLock<Type>,
    kind: SequenceKind,
}
#[derive(Clone, Copy)]
enum SequenceKind {
    Sequence,
    EnumSequence,
    BoxPointer,
    ArraySequence,
}
impl SequenceSchema {
    fn item_type(&self) -> Type {
        *self.item_type.get_or_init(|| (self.item_shape)())
    }
}

struct RoleEntry {
    target_type: TypeId,
    slot: Box<dyn Any + Send + Sync>,
}

fn vec_len<T: Any>(value: &dyn Any) -> Option<usize> {
    Some(value.downcast_ref::<Vec<T>>()?.len())
}
fn vec_get<T: Any>(value: &dyn Any, index: usize) -> Option<&dyn Any> {
    Some(value.downcast_ref::<Vec<T>>()?.get(index)?)
}
fn vec_get_mut<T: Any>(value: &mut dyn Any, index: usize) -> Option<&mut dyn Any> {
    Some(value.downcast_mut::<Vec<T>>()?.get_mut(index)?)
}
fn box_len<T: Any>(value: &dyn Any) -> Option<usize> {
    value.downcast_ref::<Box<T>>()?;
    Some(1)
}
fn box_get<T: Any>(value: &dyn Any, index: usize) -> Option<&dyn Any> {
    if index != 0 {
        return None;
    }
    Some(value.downcast_ref::<Box<T>>()?.as_ref())
}
fn box_get_mut<T: Any>(value: &mut dyn Any, index: usize) -> Option<&mut dyn Any> {
    if index != 0 {
        return None;
    }
    Some(value.downcast_mut::<Box<T>>()?.as_mut())
}
fn array_len<T: Any, const N: usize>(value: &dyn Any) -> Option<usize> {
    value.downcast_ref::<[T; N]>()?;
    Some(N)
}
fn array_get<T: Any, const N: usize>(value: &dyn Any, index: usize) -> Option<&dyn Any> {
    Some(value.downcast_ref::<[T; N]>()?.get(index)?)
}
fn array_get_mut<T: Any, const N: usize>(
    value: &mut dyn Any,
    index: usize,
) -> Option<&mut dyn Any> {
    Some(value.downcast_mut::<[T; N]>()?.get_mut(index)?)
}
fn option_len<T: Any>(value: &dyn Any) -> Option<usize> {
    Some(usize::from(value.downcast_ref::<Option<T>>()?.is_some()))
}
fn option_get<T: Any>(value: &dyn Any, index: usize) -> Option<&dyn Any> {
    if index != 0 {
        return None;
    }
    Some(value.downcast_ref::<Option<T>>()?.as_ref()?)
}
fn option_get_mut<T: Any>(value: &mut dyn Any, index: usize) -> Option<&mut dyn Any> {
    if index != 0 {
        return None;
    }
    Some(value.downcast_mut::<Option<T>>()?.as_mut()?)
}

fn read_schemas() -> std::sync::RwLockReadGuard<'static, HashMap<TypeId, Type>> {
    schemas()
        .read()
        .unwrap_or_else(std::sync::PoisonError::into_inner)
}
fn schemas() -> &'static RwLock<HashMap<TypeId, Type>> {
    static SCHEMAS: LazyLock<RwLock<HashMap<TypeId, Type>>> =
        LazyLock::new(|| RwLock::new(HashMap::new()));
    &SCHEMAS
}
fn accepts<T: Any>(value: &dyn Any) -> bool {
    value.is::<T>()
}
