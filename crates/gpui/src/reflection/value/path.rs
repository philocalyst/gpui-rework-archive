//! Safe field descriptors and composable native paths.
use super::{Type, Value, ValueMut};
use std::{any::Any, marker::PhantomData, sync::OnceLock};

/// A field adapter that retains its root proof until schema publication.
#[doc(hidden)]
pub struct FieldRegistration<Root> {
    field: Box<dyn FieldSchema>,
    marker: PhantomData<fn(Root) -> Root>,
}
impl<Root> FieldRegistration<Root> {
    pub(super) fn erase(self) -> Box<dyn FieldSchema> {
        self.field
    }
}

/// Supplies erased safe access to one field of a concrete receiver.
#[doc(hidden)]
pub trait FieldSchema: Send + Sync {
    /// The reflected field name.
    fn name(&self) -> &'static str;
    /// The enum variant owning this field, or None for struct fields.
    fn variant(&self) -> Option<&'static str> {
        None
    }
    /// The cached schema for this field's value.
    fn child_type(&self) -> Type;
    /// Whether this descriptor applies to the currently borrowed value.
    fn is_active(&self, root: &dyn Any) -> bool;
    /// Returns an immutable typed child when the field is active.
    fn get<'a>(&self, root: &'a dyn Any) -> Option<Value<'a>>;
    /// Returns a mutable typed child when the field is active.
    fn get_mut<'a>(&self, root: &'a mut dyn Any) -> Option<ValueMut<'a>>;
}

/// A compile-time typed field path and its safe runtime schema adapter.
pub struct Field<Root, Leaf> {
    name: &'static str,
    get: for<'a> fn(&'a Root) -> &'a Leaf,
    get_mut: for<'a> fn(&'a mut Root) -> &'a mut Leaf,
}
impl<Root, Leaf> Copy for Field<Root, Leaf> {}
impl<Root, Leaf> Clone for Field<Root, Leaf> {
    fn clone(&self) -> Self {
        *self
    }
}
impl<Root, Leaf> Field<Root, Leaf> {
    /// Creates a field path from native Rust borrows.
    #[doc(hidden)]
    pub const fn new(
        name: &'static str,
        get: for<'a> fn(&'a Root) -> &'a Leaf,
        get_mut: for<'a> fn(&'a mut Root) -> &'a mut Leaf,
    ) -> Self {
        Self { name, get, get_mut }
    }

    /// The reflected field name.
    pub fn name(&self) -> &'static str {
        self.name
    }

    /// Borrows the field from an exact typed root.
    pub fn get<'a>(&self, root: &'a Root) -> &'a Leaf {
        (self.get)(root)
    }

    /// Mutably borrows the field from an exact typed root.
    pub fn get_mut<'a>(&self, root: &'a mut Root) -> &'a mut Leaf {
        (self.get_mut)(root)
    }
}
impl<Root: Any, Leaf: Any> Field<Root, Leaf> {
    /// Erases this typed path for a process-owned type schema.
    #[doc(hidden)]
    pub fn into_schema(self, child_shape: fn() -> Type) -> FieldRegistration<Root> {
        FieldRegistration {
            field: Box::new(FieldSchemaField {
                field: self,
                child_shape,
                child: OnceLock::new(),
            }),
            marker: PhantomData,
        }
    }
}
struct FieldSchemaField<Root, Leaf> {
    field: Field<Root, Leaf>,
    child_shape: fn() -> Type,
    child: OnceLock<Type>,
}
impl<Root: Any, Leaf: Any> FieldSchemaField<Root, Leaf> {
    fn child_type(&self) -> Type {
        *self.child.get_or_init(|| (self.child_shape)())
    }
}
impl<Root: Any, Leaf: Any> FieldSchema for FieldSchemaField<Root, Leaf> {
    fn name(&self) -> &'static str {
        self.field.name
    }
    fn is_active(&self, root: &dyn Any) -> bool {
        root.is::<Root>()
    }
    fn child_type(&self) -> Type {
        self.child_type()
    }
    fn get<'a>(&self, root: &'a dyn Any) -> Option<Value<'a>> {
        let root = root.downcast_ref::<Root>()?;
        Some(Value::from_parts((self.field.get)(root), self.child_type()))
    }
    fn get_mut<'a>(&self, root: &'a mut dyn Any) -> Option<ValueMut<'a>> {
        let root = root.downcast_mut::<Root>()?;
        Some(ValueMut::from_parts(
            (self.field.get_mut)(root),
            self.child_type(),
        ))
    }
}

/// A typed path to a field present only for one active enum variant.
pub struct VariantField<Root, Leaf> {
    variant: &'static str,
    name: &'static str,
    get: for<'a> fn(&'a Root) -> Option<&'a Leaf>,
    get_mut: for<'a> fn(&'a mut Root) -> Option<&'a mut Leaf>,
}
impl<Root, Leaf> Copy for VariantField<Root, Leaf> {}
impl<Root, Leaf> Clone for VariantField<Root, Leaf> {
    fn clone(&self) -> Self {
        *self
    }
}
impl<Root, Leaf> VariantField<Root, Leaf> {
    /// Creates a checked projection into an enum variant field.
    #[doc(hidden)]
    pub const fn new(
        variant: &'static str,
        name: &'static str,
        get: for<'a> fn(&'a Root) -> Option<&'a Leaf>,
        get_mut: for<'a> fn(&'a mut Root) -> Option<&'a mut Leaf>,
    ) -> Self {
        Self {
            variant,
            name,
            get,
            get_mut,
        }
    }

    /// The enum variant name.
    pub fn variant(&self) -> &'static str {
        self.variant
    }

    /// The reflected field name.
    pub fn name(&self) -> &'static str {
        self.name
    }

    /// Borrows the field when this enum value has the selected variant.
    pub fn get<'a>(&self, root: &'a Root) -> Option<&'a Leaf> {
        (self.get)(root)
    }

    /// Mutably borrows the field when this enum value has the selected variant.
    pub fn get_mut<'a>(&self, root: &'a mut Root) -> Option<&'a mut Leaf> {
        (self.get_mut)(root)
    }
}
impl<Root: Any, Leaf: Any> VariantField<Root, Leaf> {
    /// Erases this typed path for a process-owned type schema.
    #[doc(hidden)]
    pub fn into_schema(self, child_shape: fn() -> Type) -> FieldRegistration<Root> {
        FieldRegistration {
            field: Box::new(VariantFieldSchema {
                field: self,
                child_shape,
                child: OnceLock::new(),
            }),
            marker: PhantomData,
        }
    }
}
struct VariantFieldSchema<Root, Leaf> {
    field: VariantField<Root, Leaf>,
    child_shape: fn() -> Type,
    child: OnceLock<Type>,
}
impl<Root: Any, Leaf: Any> VariantFieldSchema<Root, Leaf> {
    fn child_type(&self) -> Type {
        *self.child.get_or_init(|| (self.child_shape)())
    }
}
impl<Root: Any, Leaf: Any> FieldSchema for VariantFieldSchema<Root, Leaf> {
    fn name(&self) -> &'static str {
        self.field.name
    }
    fn variant(&self) -> Option<&'static str> {
        Some(self.field.variant)
    }
    fn child_type(&self) -> Type {
        self.child_type()
    }
    fn is_active(&self, root: &dyn Any) -> bool {
        root.downcast_ref::<Root>()
            .is_some_and(|root| (self.field.get)(root).is_some())
    }
    fn get<'a>(&self, root: &'a dyn Any) -> Option<Value<'a>> {
        let root = root.downcast_ref::<Root>()?;
        Some(Value::from_parts(
            (self.field.get)(root)?,
            self.child_type(),
        ))
    }
    fn get_mut<'a>(&self, root: &'a mut dyn Any) -> Option<ValueMut<'a>> {
        let root = root.downcast_mut::<Root>()?;
        Some(ValueMut::from_parts(
            (self.field.get_mut)(root)?,
            self.child_type(),
        ))
    }
}

/// A typed projection, including a composition of nested field or variant paths.
///
/// Path identity is independent of a borrow's duration. Projection is checked for the
/// lifetime of each call, so paths can compose through types containing borrowed data.
pub trait TypedPath {
    /// The exact concrete root type accepted by this path.
    type Root;
    /// The exact leaf type borrowed by this path.
    type Leaf;

    /// Returns the leaf when this path is active.
    fn get<'a>(&self, root: &'a Self::Root) -> Option<&'a Self::Leaf>
    where
        Self: BorrowPath<'a>,
    {
        self.borrow(root)
    }

    /// Returns the leaf mutably when this path is active.
    fn get_mut<'a>(&self, root: &'a mut Self::Root) -> Option<&'a mut Self::Leaf>
    where
        Self: BorrowPath<'a>,
    {
        self.borrow_mut(root)
    }

    /// Composes this path with a path from its leaf type.
    fn then<Next>(self, next: Next) -> Then<Self, Next>
    where
        Self: Sized,
        Next: TypedPath<Root = Self::Leaf>,
    {
        Then {
            outer: self,
            inner: next,
        }
    }
}

/// The projection proof for one borrow duration. Generated paths implement this automatically.
///
/// Keeping this proof separate from `TypedPath` lets composition require an intermediate
/// type to outlive the current borrow, rather than requiring it to be `'static`.
#[doc(hidden)]
pub trait BorrowPath<'a>: TypedPath
where
    Self::Root: 'a,
    Self::Leaf: 'a,
{
    /// Borrows the leaf from its exact root.
    fn borrow(&self, root: &'a Self::Root) -> Option<&'a Self::Leaf>;
    /// Exclusively borrows the leaf from its exact root.
    fn borrow_mut(&self, root: &'a mut Self::Root) -> Option<&'a mut Self::Leaf>;
}

impl<Root, Leaf> TypedPath for Field<Root, Leaf> {
    type Root = Root;
    type Leaf = Leaf;
}
impl<'a, Root: 'a, Leaf: 'a> BorrowPath<'a> for Field<Root, Leaf> {
    fn borrow(&self, root: &'a Root) -> Option<&'a Leaf> {
        Some((self.get)(root))
    }
    fn borrow_mut(&self, root: &'a mut Root) -> Option<&'a mut Leaf> {
        Some((self.get_mut)(root))
    }
}
impl<Root, Leaf> TypedPath for VariantField<Root, Leaf> {
    type Root = Root;
    type Leaf = Leaf;
}
impl<'a, Root: 'a, Leaf: 'a> BorrowPath<'a> for VariantField<Root, Leaf> {
    fn borrow(&self, root: &'a Root) -> Option<&'a Leaf> {
        (self.get)(root)
    }
    fn borrow_mut(&self, root: &'a mut Root) -> Option<&'a mut Leaf> {
        (self.get_mut)(root)
    }
}

/// A composition of two typed paths.
pub struct Then<Outer, Inner> {
    outer: Outer,
    inner: Inner,
}
impl<Outer: Copy, Inner: Copy> Copy for Then<Outer, Inner> {}
impl<Outer: Copy, Inner: Copy> Clone for Then<Outer, Inner> {
    fn clone(&self) -> Self {
        *self
    }
}
impl<Outer, Inner> TypedPath for Then<Outer, Inner>
where
    Outer: TypedPath,
    Inner: TypedPath<Root = Outer::Leaf>,
{
    type Root = Outer::Root;
    type Leaf = Inner::Leaf;
}
impl<'a, Outer, Inner> BorrowPath<'a> for Then<Outer, Inner>
where
    Outer: BorrowPath<'a>,
    Outer::Root: 'a,
    Outer::Leaf: 'a,
    Inner: BorrowPath<'a, Root = Outer::Leaf>,
    Inner::Leaf: 'a,
{
    fn borrow(&self, root: &'a Self::Root) -> Option<&'a Self::Leaf> {
        self.inner.borrow(self.outer.borrow(root)?)
    }
    fn borrow_mut(&self, root: &'a mut Self::Root) -> Option<&'a mut Self::Leaf> {
        self.inner.borrow_mut(self.outer.borrow_mut(root)?)
    }
}
