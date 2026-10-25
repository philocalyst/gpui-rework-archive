//! Concrete Rust type discovery; syntax never decides a type's structural category.
use super::*;

/// A built-in or generated partial shape that remains useful when a child is opaque.
#[doc(hidden)]
pub trait PartialDescribe: Any + Sized + sealed::PartialSequence {
    /// Builds the structural part of a schema without requiring described children.
    fn partial_type_shape() -> Type;
}

mod sealed {
    pub trait PartialSequence {}
    impl<T: super::Any> PartialSequence for Vec<T> {}
    impl<T: super::Any> PartialSequence for Option<T> {}
    impl<T: super::Any> PartialSequence for Box<T> {}
    impl<T: super::Any, const N: usize> PartialSequence for [T; N] {}
}

/// A linked factory for one monomorphic reflected type.
#[doc(hidden)]
pub struct TypeRegistration {
    type_id: fn() -> TypeId,
    resolve: fn() -> Type,
}
impl TypeRegistration {
    /// Registers the exact type's native schema implementation.
    pub const fn of<T: Describe>() -> Self {
        Self {
            type_id: TypeId::of::<T>,
            resolve: T::type_shape,
        }
    }
}
inventory::collect!(TypeRegistration);

fn linked_factories() -> &'static HashMap<TypeId, fn() -> Type> {
    static FACTORIES: LazyLock<HashMap<TypeId, fn() -> Type>> = LazyLock::new(|| {
        let mut factories = HashMap::new();
        for registration in inventory::iter::<TypeRegistration> {
            // `of<T>` is the only constructor: duplicates resolve the same coherent
            // `Describe` implementation, including registrations made through aliases.
            factories
                .entry((registration.type_id)())
                .or_insert(registration.resolve);
        }
        factories
    });
    &FACTORIES
}

impl Type {
    /// Discovers linked metadata for an exact type, or returns its canonical opaque slot.
    ///
    /// Generated schemas also provide factories for their visible type arguments. This lets
    /// generic container implementations find nested shapes without guessing Rust type names.
    pub fn discover<T: Any>() -> Self {
        let ty = Self::opaque::<T>();
        if ty.0.shape.get().is_none() {
            let factory =
                ty.0.resolver
                    .get()
                    .copied()
                    .or_else(|| linked_factories().get(&ty.type_id()).copied());
            if let Some(factory) = factory {
                let resolved = factory();
                assert_eq!(
                    resolved.type_id(),
                    ty.type_id(),
                    "schema factory returned another Rust type"
                );
            }
        }
        ty
    }

    fn provide<T: Describe>() {
        // Publish only the factory here. Calling it while assembling a recursive parent's
        // metadata could re-enter that parent's OnceLock.
        let _ = Self::opaque::<T>().0.resolver.set(T::type_shape);
    }

    fn provide_partial<T: PartialDescribe>() {
        let _ = Self::opaque::<T>().0.resolver.set(T::partial_type_shape);
    }
}

/// A type-directed probe emitted at the actual field site.
#[doc(hidden)]
pub struct TypeProbe<T: ?Sized>(PhantomData<fn(*const T) -> *const T>);
impl<T: ?Sized> TypeProbe<T> {
    /// Creates a zero-sized probe without constructing a value.
    pub const fn new() -> Self {
        Self(PhantomData)
    }
}

/// Selects native metadata when Rust can prove `Describe`, otherwise uses linked discovery.
#[doc(hidden)]
pub trait ProbeShape {
    /// Returns a fully described schema when Rust proves the bound at this site.
    fn full_shape(self) -> Option<Type>;
}
impl<T: Describe> ProbeShape for &TypeProbe<T> {
    fn full_shape(self) -> Option<Type> {
        Some(T::type_shape())
    }
}
impl<T: Any> ProbeShape for &&TypeProbe<T> {
    fn full_shape(self) -> Option<Type> {
        None
    }
}

/// Falls back to a partial container shape when no complete `Describe` proof is available.
#[doc(hidden)]
pub trait ProbePartialShape {
    /// Resolves a partial schema or returns an opaque canonical slot.
    fn partial_shape(self) -> Type;
}
impl<T: PartialDescribe> ProbePartialShape for &TypeProbe<T> {
    fn partial_shape(self) -> Type {
        T::partial_type_shape()
    }
}
impl<T: Any> ProbePartialShape for &&TypeProbe<T> {
    fn partial_shape(self) -> Type {
        Type::discover::<T>()
    }
}

/// Provides lazily callable native factories without requiring every argument to be described.
#[doc(hidden)]
pub trait ProvideShape {
    /// Records a proven factory, or does nothing for an opaque or unsized argument.
    fn provide(self);
}
impl<T: Describe> ProvideShape for &TypeProbe<T> {
    fn provide(self) {
        Type::provide::<T>();
    }
}
impl<T: ?Sized> ProvideShape for &&TypeProbe<T> {
    fn provide(self) {}
}

/// Provides a partial factory when no complete schema factory was available.
#[doc(hidden)]
pub trait ProvidePartialShape {
    /// Stores a partial schema factory, or does nothing for an unrecognized type.
    fn provide_partial(self);
}
impl<T: PartialDescribe> ProvidePartialShape for &TypeProbe<T> {
    fn provide_partial(self) {
        Type::provide_partial::<T>();
    }
}
impl<T: ?Sized> ProvidePartialShape for &&TypeProbe<T> {
    fn provide_partial(self) {}
}
