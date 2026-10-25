extern crate self as gpui;

pub mod reflection {
    #[path = "/Users/mileswirht/.codex/worktrees/5226/gpui-ce3/crates/gpui/src/reflection/value.rs"]
    mod value;
    pub use value::*;
}

use reflection::{Describe, Type};
use std::marker::PhantomData;

// The two implementations intentionally differ only by one receiver reference. At a concrete
// field site Rust prefers `&Probe<T>` when T: Describe, and falls back to `&&Probe<T>` otherwise.
struct Probe<T>(PhantomData<fn() -> T>);
trait ShapeProbe {
    fn shape(self) -> Type;
}
impl<T: Describe> ShapeProbe for &Probe<T> {
    fn shape(self) -> Type { Type::of::<T>() }
}
impl<T: 'static> ShapeProbe for &&Probe<T> {
    fn shape(self) -> Type { Type::opaque::<T>() }
}

#[doc(hidden)]
pub fn shape_of<T: 'static>() -> Type {
    let probe = Probe::<T>(PhantomData);
    (&probe).shape()
}

#[doc(hidden)]
pub fn shape_of_described<T: Describe>() -> Type {
    let probe = Probe::<T>(PhantomData);
    (&probe).shape()
}

#[cfg(test)]
mod tests {
    use super::*;
    use reflection::TypeKind;

    mod types {
        use super::reflection::{Describe, Type};
        pub struct ExternalLeaf { pub value: u32 }
        impl Describe for ExternalLeaf {
            fn build_type() -> Type { Type::new::<Self>("ExternalLeaf", Vec::new(), None) }
        }

        pub struct Card;
        impl Describe for Card {
            fn build_type() -> Type { Type::new::<Self>("local::Card", Vec::new(), None) }
        }
    }

    // Models an imported same-named type alongside a local type. No name heuristic is involved.
    mod imported {
        pub struct Card;
        impl super::Describe for Card {
            fn build_type() -> super::Type {
                super::Type::new::<Self>("imported::Card", Vec::new(), None)
            }
        }
    }

    fn external_site() -> Type {
        let probe = Probe::<types::ExternalLeaf>(PhantomData);
        (&probe).shape()
    }
    fn local_card_site() -> Type {
        let probe = Probe::<types::Card>(PhantomData);
        (&probe).shape()
    }
    fn imported_card_site() -> Type {
        let probe = Probe::<imported::Card>(PhantomData);
        (&probe).shape()
    }
    fn generic_described_site<T: Describe>() -> Type {
        let probe = Probe::<T>(PhantomData);
        (&probe).shape()
    }

    #[test]
    fn described_external_and_opaque_generic_sites_select_correctly() {
        assert_eq!(external_site().kind(), TypeKind::Struct);
        assert_eq!(shape_of::<u32>().kind(), TypeKind::Opaque);
        assert_eq!(generic_described_site::<types::ExternalLeaf>().kind(), TypeKind::Struct);
    }

    #[test]
    fn same_named_imported_type_uses_its_own_trait_impl() {
        assert_eq!(local_card_site().name(), "local::Card");
        assert_eq!(imported_card_site().name(), "imported::Card");
    }

    #[test]
    fn wrapper_factories_keep_the_child_shape_lazy() {
        let vec = Type::vec::<types::ExternalLeaf>(external_site);
        let option = Type::option::<types::ExternalLeaf>(external_site);
        assert!(vec.is_sequence());
        assert!(option.is_sequence());
        let leaf = types::ExternalLeaf { value: 4 };
        let list = vec![leaf];
        let sequence = reflection::Value::from_parts(&list, vec);
        assert_eq!(sequence.index(0).unwrap().ty().kind(), TypeKind::Struct);
        let optional = Some(types::ExternalLeaf { value: 5 });
        let sequence = reflection::Value::from_parts(&optional, option);
        assert_eq!(sequence.index(0).unwrap().ty().kind(), TypeKind::Struct);
    }
}
