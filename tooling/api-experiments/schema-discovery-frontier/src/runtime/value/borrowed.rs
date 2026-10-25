//! Borrowed runtime values. Every child loan is tied to the current receiver borrow.
use super::{BorrowPath, Describe, Type};
use std::any::Any;

/// An immutable borrowed value and its runtime type description.
pub struct Value<'a> {
    value: &'a dyn Any,
    ty: Type,
}
impl<'a> Copy for Value<'a> {}
impl<'a> Clone for Value<'a> {
    fn clone(&self) -> Self {
        *self
    }
}
impl<'a> Value<'a> {
    /// Borrows a described value.
    pub fn new<T: Describe>(value: &'a T) -> Self {
        Self::from_parts(value, T::type_shape())
    }

    /// Constructs a borrowed value from an erased reference and its schema.
    pub fn from_parts(value: &'a dyn Any, ty: Type) -> Self {
        assert!(ty.accepts(value), "value type does not match its schema");
        Self { value, ty }
    }

    /// Constructs an opaque borrowed value for a native Rust value.
    pub fn opaque<T: Any>(value: &'a T) -> Self {
        Self::from_parts(value, Type::opaque::<T>())
    }

    /// The runtime schema for this borrowed value.
    pub fn ty(&self) -> Type {
        self.ty
    }

    /// The active enum variant, if this value is an enum.
    pub fn variant(&self) -> Option<&'static str> {
        self.ty.variant(self.value)
    }

    /// Resolves a named child field without allocating.
    pub fn field(&self, name: &str) -> Option<Value<'_>> {
        self.ty.field(self.value, name)
    }

    /// Resolves an indexed vector or option child without allocating.
    pub fn index(&self, index: usize) -> Option<Value<'_>> {
        self.ty.index(self.value, index)
    }

    /// The number of elements in a sequence-like value, or `None` for other values.
    pub fn len(&self) -> Option<usize> {
        self.ty.len(self.value)
    }

    /// Iterates this value's active named fields without allocating.
    pub fn fields(&self) -> impl Iterator<Item = (&'static str, Value<'a>)> + '_ {
        self.ty.field_descriptors().iter().filter_map(move |field| {
            field
                .is_active(self.value)
                .then(|| field.get(self.value).map(|value| (field.name(), value)))
                .flatten()
        })
    }

    /// Borrows a leaf through a compile-time typed path.
    pub fn at<'b, Path: BorrowPath<'b>>(&'b self, path: Path) -> Option<&'b Path::Leaf>
    where
        Path::Root: Any,
        Path::Leaf: Any,
    {
        path.get(self.value.downcast_ref::<Path::Root>()?)
    }

    /// Returns the value as its exact native Rust type.
    pub fn downcast_ref<T: Any>(&self) -> Option<&T> {
        self.value.downcast_ref()
    }
}

/// A mutable borrowed value and its runtime type description.
pub struct ValueMut<'a> {
    value: &'a mut dyn Any,
    ty: Type,
}
impl<'a> ValueMut<'a> {
    /// Borrows a described value mutably.
    pub fn new<T: Describe>(value: &'a mut T) -> Self {
        Self::from_parts(value, T::type_shape())
    }

    /// Constructs a mutable borrowed value from an erased reference and its schema.
    pub fn from_parts(value: &'a mut dyn Any, ty: Type) -> Self {
        assert!(ty.accepts(value), "value type does not match its schema");
        Self { value, ty }
    }

    /// Constructs an opaque mutable borrowed value for a native Rust value.
    pub fn opaque<T: Any>(value: &'a mut T) -> Self {
        Self::from_parts(value, Type::opaque::<T>())
    }

    /// The runtime schema for this borrowed value.
    pub fn ty(&self) -> Type {
        self.ty
    }

    /// The active enum variant, if this value is an enum.
    pub fn variant(&self) -> Option<&'static str> {
        self.ty.variant(self.value)
    }

    /// Resolves a named mutable child field without allocating.
    pub fn field(&mut self, name: &str) -> Option<ValueMut<'_>> {
        self.ty.field_mut(self.value, name)
    }

    /// Resolves an indexed mutable vector or option child without allocating.
    pub fn index(&mut self, index: usize) -> Option<ValueMut<'_>> {
        self.ty.index_mut(self.value, index)
    }

    /// The number of elements in a sequence-like value, or `None` for other values.
    pub fn len(&self) -> Option<usize> {
        self.ty.len(self.value)
    }

    /// Visits each active immediate field with an exclusive borrow lasting only for the callback.
    pub fn visit_fields(&mut self, mut visitor: impl for<'b> FnMut(&'static str, ValueMut<'b>)) {
        for index in 0..self.ty.field_descriptors().len() {
            let field = &self.ty.field_descriptors()[index];
            if field.is_active(&*self.value) {
                let name = field.name();
                if let Some(child) = field.get_mut(self.value) {
                    visitor(name, child);
                }
            }
        }
    }

    /// Mutably borrows a leaf through a compile-time typed path.
    pub fn at<'b, Path: BorrowPath<'b>>(&'b mut self, path: Path) -> Option<&'b mut Path::Leaf>
    where
        Path::Root: Any,
        Path::Leaf: Any,
    {
        path.get_mut(self.value.downcast_mut::<Path::Root>()?)
    }

    /// Borrows a registered native trait view from this concrete value.
    ///
    /// The result is tied to this mutable borrow, so another mutable field or role access cannot
    /// overlap it. The role adapter downcasts the concrete receiver and performs the native Rust
    /// coercion supplied by the type's schema.
    ///
    /// ```compile_fail
    /// use gpui::reflection::{Role, Schema, ValueMut};
    /// trait Edit { fn edit(&mut self); }
    /// struct Card;
    /// impl Edit for Card { fn edit(&mut self) {} }
    /// let ty = Schema::<Card>::with_roles(vec![], None,
    ///     vec![Role::<Card, dyn Edit>::new(|card| card).into_schema()]).publish();
    /// let mut card = Card;
    /// let mut value = ValueMut::from_parts(&mut card, ty);
    /// let first = value.cast_mut::<dyn Edit>().unwrap();
    /// let second = value.cast_mut::<dyn Edit>().unwrap();
    /// first.edit(); second.edit();
    /// ```
    pub fn cast_mut<Target: ?Sized + 'static>(&mut self) -> Option<&mut Target> {
        self.ty.role::<Target>()?.get_mut(self.value)
    }

    /// Consumes this erased borrow and returns its registered native trait view.
    ///
    /// This is useful when an erased value is a temporary produced by a selector: consuming the
    /// wrapper preserves the original value's borrow lifetime in the returned reference.
    pub fn into_cast_mut<Target: ?Sized + 'static>(self) -> Option<&'a mut Target> {
        self.ty.role::<Target>()?.get_mut(self.value)
    }

    /// Calls a visitor once for each reachable value, borrowing one child at a time.
    pub fn walk_mut(&mut self, mut visitor: impl FnMut(&mut ValueMut<'_>)) {
        self.walk_inner(&mut visitor);
    }

    fn walk_inner(&mut self, visitor: &mut impl FnMut(&mut ValueMut<'_>)) {
        visitor(self);
        let field_count = self.ty.field_descriptors().len();
        for index in 0..field_count {
            let field = &self.ty.field_descriptors()[index];
            if field.is_active(&*self.value) {
                if let Some(mut child) = field.get_mut(self.value) {
                    child.walk_inner(visitor);
                }
            }
        }
        let len = self.len().unwrap_or(0);
        for index in 0..len {
            if let Some(mut child) = self.index(index) {
                child.walk_inner(visitor);
            }
        }
    }

    /// Returns the value as its exact native Rust type.
    pub fn downcast_ref<T: Any>(&self) -> Option<&T> {
        self.value.downcast_ref()
    }

    /// Mutably returns the value as its exact native Rust type.
    pub fn downcast_mut<T: Any>(&mut self) -> Option<&mut T> {
        self.value.downcast_mut()
    }
}
