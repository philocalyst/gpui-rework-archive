//! Cross-module structural schema discovery prototype.
//!
//! This isolated snapshot of GPUI's value runtime adds a linked schema-factory registry and an
//! actual-type probe; no production source is changed.

extern crate self as gpui;

pub mod reflection {
    #[path = "/Users/mileswirht/.codex/worktrees/5226/gpui-ce3/tooling/api-experiments/schema-discovery-frontier/src/runtime/value.rs"]
    mod value;
    pub use value::*;
}

#[doc(hidden)]
pub mod __private {
    pub use inventory;
}

use reflection::{Describe, Type};
use std::{
    any::{Any, TypeId},
    marker::PhantomData,
};

/// A statically linked schema factory for a concrete, monomorphic reflected type.
pub struct SchemaRegistration {
    pub type_id: fn() -> TypeId,
    pub schema: fn() -> Type,
}
inventory::collect!(SchemaRegistration);

/// Register a concrete `Describe` type for discovery from generic code with no `Describe` bound.
#[macro_export]
macro_rules! register_schema {
    ($ty:ty) => {
        const _: () = {
            fn type_id() -> ::std::any::TypeId {
                ::std::any::TypeId::of::<$ty>()
            }
            fn schema() -> $crate::reflection::Type {
                <$ty as $crate::reflection::Describe>::type_shape()
            }
            $crate::__private::inventory::submit! {
                $crate::SchemaRegistration { type_id, schema }
            }
        };
    };
}

fn linked_schema<T: Any>() -> Option<Type> {
    let wanted = TypeId::of::<T>();
    inventory::iter::<SchemaRegistration>()
        .find(|registration| (registration.type_id)() == wanted)
        .map(|registration| (registration.schema)())
}

/// Runtime fallback supports unbounded generic fields by consulting linked monomorphic schemas.
pub fn discover<T: Any>() -> Type {
    linked_schema::<T>().unwrap_or_else(Type::opaque::<T>)
}

impl Type {
    /// Resolves an exact type's linked monomorphic schema, or returns its canonical opaque slot.
    pub fn discover<T: Any>() -> Type {
        discover::<T>()
    }
}

#[doc(hidden)]
pub struct Probe<T>(PhantomData<fn() -> T>);
#[doc(hidden)]
pub trait ProbeShape {
    fn shape(self) -> Type;
}
// At concrete field sites, real `Describe` impls win. For generic `T` with no such bound,
// Rust selects the fallback, whose TypeId registry still finds linked monomorphic derives.
impl<T: Describe> ProbeShape for &Probe<T> {
    fn shape(self) -> Type {
        T::type_shape()
    }
}
impl<T: 'static> ProbeShape for &&Probe<T> {
    fn shape(self) -> Type {
        Type::discover::<T>()
    }
}

/// Put this expression at each concrete field-type site in generated code. Hiding it in
/// `fn child_shape<T>()` makes Rust resolve the autoref choice for abstract `T` once.
#[macro_export]
macro_rules! shape_at_site {
    ($ty:ty) => {{
        let probe = $crate::Probe::<$ty>(::std::marker::PhantomData);
        (&probe).shape()
    }};
}

// These impls classify the resolved Rust types themselves. A user type or a module-local alias
// named Vec/Option/Box is never classified by its last identifier.
impl<T: Any> Describe for Vec<T> {
    fn build_type() -> reflection::Schema<Self> {
        reflection::Schema::<Self>::vec(Type::discover::<T>)
    }
}
impl<T: Any> Describe for Option<T> {
    fn build_type() -> reflection::Schema<Self> {
        reflection::Schema::<Self>::option(Type::discover::<T>)
    }
}
impl<T: Any> Describe for Box<T> {
    fn build_type() -> reflection::Schema<Self> {
        reflection::Schema::<Self>::boxed(Type::discover::<T>)
    }
}
impl<T: Any, const N: usize> Describe for [T; N] {
    fn build_type() -> reflection::Schema<Self> {
        reflection::Schema::<Self>::array(Type::discover::<T>)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use reflection::TypeKind;
    use std::sync::{Arc, Barrier};

    pub mod external {
        use super::*;
        pub struct Leaf {
            pub n: u8,
        }
        impl Describe for Leaf {
            fn build_type() -> reflection::Schema<Self> {
                reflection::Schema::<Self>::new(Vec::new(), None)
            }
        }
        register_schema!(Leaf);

        pub struct Card;
        impl Describe for Card {
            fn build_type() -> reflection::Schema<Self> {
                reflection::Schema::<Self>::new(Vec::new(), None)
            }
        }
        register_schema!(Card);

        pub struct GenericOnly;
        impl Describe for GenericOnly {
            fn build_type() -> reflection::Schema<Self> {
                reflection::Schema::<Self>::new(Vec::new(), None)
            }
        }
        register_schema!(GenericOnly);

        pub struct UnshapedLeaf;
        impl Describe for UnshapedLeaf {
            fn build_type() -> reflection::Schema<Self> {
                reflection::Schema::<Self>::new(Vec::new(), None)
            }
        }
        register_schema!(UnshapedLeaf);

        pub struct Recursive {
            pub next: std::boxed::Box<Option<Recursive>>,
        }
        impl Describe for Recursive {
            fn build_type() -> reflection::Schema<Self> {
                reflection::Schema::<Self>::new(
                    vec![
                        reflection::Field::new(
                            "next",
                            |value: &Self| &value.next,
                            |value| &mut value.next,
                        )
                        .into_schema(recursive_child_shape),
                    ],
                    None,
                )
            }
        }
        register_schema!(Recursive);

        fn recursive_child_shape() -> Type {
            Type::boxed::<Option<Recursive>>(recursive_option_shape)
        }
        fn recursive_option_shape() -> Type {
            Type::option::<Recursive>(Type::of::<Recursive>)
        }
    }

    mod shadow {
        use super::*;
        pub struct Vec(pub u32);
        impl Describe for Vec {
            fn build_type() -> reflection::Schema<Self> {
                reflection::Schema::<Self>::new(::std::vec::Vec::new(), None)
            }
        }
        pub struct Option(pub u32);
        impl Describe for Option {
            fn build_type() -> reflection::Schema<Self> {
                reflection::Schema::<Self>::new(::std::vec::Vec::new(), None)
            }
        }
        pub struct Box(pub u32);
        impl Describe for Box {
            fn build_type() -> reflection::Schema<Self> {
                reflection::Schema::<Self>::new(::std::vec::Vec::new(), None)
            }
        }
    }

    type ExternalList = std::vec::Vec<external::Leaf>;
    type MaybeCard = std::option::Option<external::Card>;

    fn generic_unbounded<T: 'static>() -> Type {
        discover::<T>()
    }
    fn generic_vec<T: 'static>() -> Type {
        shape_at_site!(std::vec::Vec<T>)
    }

    #[test]
    fn external_aliases_and_wrappers_resolve_by_actual_type() {
        assert_eq!(
            shape_at_site!(external::Leaf).type_id(),
            std::any::TypeId::of::<external::Leaf>()
        );
        assert_eq!(shape_at_site!(ExternalList).kind(), TypeKind::Sequence);
        assert_eq!(shape_at_site!(MaybeCard).kind(), TypeKind::Enum);
        assert_eq!(
            shape_at_site!(std::boxed::Box<external::Card>).kind(),
            TypeKind::BoxPointer
        );
        assert_eq!(
            shape_at_site!(std::option::Option<std::vec::Vec<external::UnshapedLeaf>>).kind(),
            TypeKind::Enum
        );
        assert_eq!(
            generic_unbounded::<external::Card>().type_id(),
            std::any::TypeId::of::<external::Card>()
        );
        // The blanket wrapper Describe implementation works with arbitrary T. Its lazy child
        // resolver recovers this monomorphic T from the linked registry.
        let values = vec![external::GenericOnly];
        let vec_type = Type::of::<std::vec::Vec<external::GenericOnly>>();
        let sequence = reflection::Value::from_parts(&values, vec_type);
        let child = sequence.index(0).unwrap();
        assert_eq!(
            child.ty().type_id(),
            std::any::TypeId::of::<external::GenericOnly>()
        );
        // `Vec<T>` has a known blanket Describe impl even when T is generic.
        let generic_container = generic_vec::<external::GenericOnly>();
        assert_eq!(generic_container.kind(), TypeKind::Sequence);
        let generic_sequence = reflection::Value::from_parts(&values, generic_container);
        assert_eq!(
            generic_sequence.index(0).unwrap().ty().type_id(),
            std::any::TypeId::of::<external::GenericOnly>()
        );

        // An unconstrained generic T that later happens to be a Vec uses the TypeId fallback.
        // It sees a canonical opaque slot until Type::of publishes that wrapper's schema.
        let deferred = generic_unbounded::<std::vec::Vec<external::UnshapedLeaf>>();
        assert_eq!(deferred.kind(), TypeKind::Opaque);
        let nested_value = Some(vec![external::UnshapedLeaf]);
        let nested_ty = shape_at_site!(std::option::Option<std::vec::Vec<external::UnshapedLeaf>>);
        let nested_value = reflection::Value::from_parts(&nested_value, nested_ty);
        let inner_vec = nested_value.index(0).unwrap();
        assert_eq!(inner_vec.ty(), deferred);
        assert_eq!(inner_vec.ty().kind(), TypeKind::Opaque);
        assert_eq!(
            Type::of::<std::vec::Vec<external::UnshapedLeaf>>().kind(),
            TypeKind::Sequence
        );
        assert_eq!(inner_vec.ty().kind(), TypeKind::Sequence);
    }

    #[test]
    fn shadowed_names_are_structs() {
        assert_eq!(shape_at_site!(shadow::Vec).kind(), TypeKind::Struct);
        assert_eq!(shape_at_site!(shadow::Option).kind(), TypeKind::Struct);
        assert_eq!(shape_at_site!(shadow::Box).kind(), TypeKind::Struct);
    }

    #[test]
    fn nested_wrapper_children_are_lazy_and_recursive_types_initialize() {
        let root = Type::of::<external::Recursive>();
        assert_eq!(root.kind(), TypeKind::Struct);
        let recursive = external::Recursive {
            next: std::boxed::Box::new(Some(external::Recursive {
                next: std::boxed::Box::new(None),
            })),
        };
        let root_value = reflection::Value::from_parts(&recursive, root);
        let first = root_value.field("next").unwrap();
        assert_eq!(first.ty().kind(), TypeKind::BoxPointer);
        let second = first.index(0).unwrap();
        assert_eq!(second.ty().kind(), TypeKind::Enum);
        let third = second.index(0).unwrap();
        assert_eq!(third.ty().kind(), TypeKind::Struct);
        assert_eq!(
            third.field("next").unwrap().ty().kind(),
            TypeKind::BoxPointer
        );
        let array = shape_at_site!([external::Leaf; 3]);
        assert_eq!(array.kind(), TypeKind::ArraySequence);
    }

    #[test]
    fn concurrent_discovery_returns_canonical_handles() {
        let n = 24;
        let barrier = Arc::new(Barrier::new(n));
        let threads: Vec<_> = (0..n)
            .map(|_| {
                let barrier = barrier.clone();
                std::thread::spawn(move || {
                    barrier.wait();
                    shape_at_site!(external::Leaf)
                })
            })
            .collect();
        let first = threads
            .into_iter()
            .map(|t| t.join().unwrap())
            .next()
            .unwrap();
        for _ in 0..100 {
            assert_eq!(shape_at_site!(external::Leaf), first);
        }
    }
}
