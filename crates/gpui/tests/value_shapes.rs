use gpui::reflect;
use gpui::reflection::{Describe, Type, TypeKind, Value};

pub struct OpaqueLeaf(pub u8);

#[reflect]
mod foreign_types {
    pub struct Leaf(pub u32);
    pub struct GenericLeaf<T>(pub T);
}

mod external_aliases {
    pub type Hidden<T> = std::vec::Vec<std::option::Option<super::foreign_types::GenericLeaf<T>>>;
}

#[reflect]
mod probe {
    use super::foreign_types;
    use gpui::reflection::Describe;

    pub struct Holder {
        pub values: std::vec::Vec<std::option::Option<foreign_types::GenericLeaf<u32>>>,
        pub one: std::option::Option<foreign_types::Leaf>,
        pub local_alias: LocalNested,
        pub external_alias: crate::external_aliases::Hidden<u16>,
        pub generic_local_alias: LocalGeneric<u32>,
    }

    pub struct PartialHolder {
        pub nested: std::option::Option<std::vec::Vec<crate::OpaqueLeaf>>,
    }

    pub type LocalNested = std::vec::Vec<std::option::Option<foreign_types::GenericLeaf<u8>>>;
    pub type LocalGeneric<T> = std::vec::Vec<std::option::Option<UniqueGeneric<T>>>;

    pub struct Node {
        pub next: std::boxed::Box<std::option::Option<Node>>,
    }

    pub struct GenericHolder<T: Describe + 'static> {
        pub value: std::option::Option<T>,
    }

    pub struct GenericSlot<T> {
        pub value: T,
    }

    pub struct RaceType {
        pub value: u64,
    }

    pub struct MutualA {
        pub b: std::option::Option<std::boxed::Box<MutualB>>,
    }
    pub struct MutualB {
        pub a: std::vec::Vec<MutualA>,
    }

    pub struct Vec<T> {
        pub item: T,
    }
    pub struct Option<T> {
        pub item: T,
    }
    pub struct Box<T> {
        pub item: T,
    }

    pub struct CollisionHolder {
        pub custom_vec: Vec<foreign_types::Leaf>,
        pub custom_option: Option<foreign_types::Leaf>,
        pub custom_box: Box<foreign_types::Leaf>,
        pub actual_vec: std::vec::Vec<foreign_types::Leaf>,
        pub actual_option: std::option::Option<foreign_types::Leaf>,
        pub actual_box: std::boxed::Box<foreign_types::Leaf>,
    }

    pub struct UniqueGeneric<T>(pub T);

    pub trait HasAssoc {
        type Item;
    }
    pub struct AssocRoot;
    impl HasAssoc for AssocRoot {
        type Item = std::option::Option<UniqueGeneric<u16>>;
    }
    pub struct QSelfHolder {
        pub item: <AssocRoot as HasAssoc>::Item,
    }

    pub struct BinderFields {
        pub callback: for<'a> fn(&'a u8),
        pub reference: &'static (dyn std::fmt::Debug + Send + Sync),
        pub boxed_unsized: std::boxed::Box<dyn std::fmt::Debug>,
    }

    pub struct CfgFields {
        #[cfg(any())]
        pub disabled: std::vec::Vec<foreign_types::Leaf>,
        #[cfg(unix)]
        pub unix: std::option::Option<foreign_types::Leaf>,
        #[cfg(not(unix))]
        pub non_unix: std::boxed::Box<foreign_types::Leaf>,
    }
}

fn kind_of_field(root: Type, name: &str) -> TypeKind {
    root.fields()
        .find(|field| field.name == name)
        .unwrap()
        .ty
        .kind()
}

#[test]
fn visible_nested_type_arguments_are_seeded_lazily() {
    let instance = probe::Holder {
        values: vec![Some(foreign_types::GenericLeaf(7u32))],
        one: Some(foreign_types::Leaf(1)),
        local_alias: vec![Some(foreign_types::GenericLeaf(2u8))],
        external_alias: vec![Some(foreign_types::GenericLeaf(3u16))],
        generic_local_alias: vec![Some(probe::UniqueGeneric(5u32))],
    };
    let root = probe::Holder::type_shape();
    let value = Value::from_parts(&instance, root);

    let values = value.field("values").unwrap();
    assert_eq!(values.ty().kind(), TypeKind::Sequence);
    let optional = values.index(0).unwrap();
    assert_eq!(optional.ty().kind(), TypeKind::Enum);
    let leaf = optional.index(0).unwrap();
    assert_eq!(leaf.ty().kind(), TypeKind::Struct);

    let local_alias = value.field("local_alias").unwrap();
    let local_option = local_alias.index(0).unwrap();
    assert_eq!(local_option.ty().kind(), TypeKind::Enum);
    assert_eq!(local_option.index(0).unwrap().ty().kind(), TypeKind::Struct);

    // The external generic alias's inner type arguments are hidden from this module's syntax walk.
    let external_alias = value.field("external_alias").unwrap();
    let external_option = external_alias.index(0).unwrap();
    let external_option_type = external_option.ty();
    assert_eq!(external_option_type.kind(), TypeKind::Enum);
    let hidden_leaf = external_option.index(0).unwrap();
    assert_eq!(hidden_leaf.ty().kind(), TypeKind::Struct);

    // The alias exists in this module but has parameters. Full wrapper Describe and child
    // preparation resolve its nested generic child without expanding the alias in the macro.
    let generic_alias = value.field("generic_local_alias").unwrap();
    let generic_alias_option = generic_alias.index(0).unwrap();
    assert_eq!(generic_alias_option.ty().kind(), TypeKind::Enum);
    assert_eq!(
        generic_alias_option.index(0).unwrap().ty().kind(),
        TypeKind::Struct
    );

    assert_eq!(kind_of_field(root, "one"), TypeKind::Enum);
}

#[test]
fn blanket_container_describe_uses_actual_type_not_its_spelling() {
    let root = probe::CollisionHolder::type_shape();
    assert_eq!(kind_of_field(root, "custom_vec"), TypeKind::Struct);
    assert_eq!(kind_of_field(root, "custom_option"), TypeKind::Struct);
    assert_eq!(kind_of_field(root, "custom_box"), TypeKind::Struct);
    assert_eq!(kind_of_field(root, "actual_vec"), TypeKind::Sequence);
    assert_eq!(kind_of_field(root, "actual_option"), TypeKind::Enum);
    assert_eq!(kind_of_field(root, "actual_box"), TypeKind::BoxPointer);
}

#[test]
fn recursive_and_generic_described_children_resolve_without_reentry() {
    let node = probe::Node {
        next: std::boxed::Box::new(Some(probe::Node {
            next: std::boxed::Box::new(None),
        })),
    };
    let root = probe::Node::type_shape();
    let node_value = Value::from_parts(&node, root);
    let first = node_value.field("next").unwrap();
    assert_eq!(first.ty().kind(), TypeKind::BoxPointer);
    let second = first.index(0).unwrap();
    assert_eq!(second.ty().kind(), TypeKind::Enum);
    let box_node = second.index(0).unwrap();
    assert_eq!(box_node.ty().kind(), TypeKind::Struct);
    assert_eq!(
        box_node.field("next").unwrap().ty().kind(),
        TypeKind::BoxPointer
    );

    let generic = probe::GenericHolder::<foreign_types::GenericLeaf<u64>> {
        value: Some(foreign_types::GenericLeaf(9u64)),
    };
    let generic_type = probe::GenericHolder::<foreign_types::GenericLeaf<u64>>::type_shape();
    let value = Value::from_parts(&generic, generic_type);
    let option = value.field("value").unwrap();
    assert_eq!(option.ty().kind(), TypeKind::Enum);
    assert_eq!(option.index(0).unwrap().ty().kind(), TypeKind::Struct);

    // The macro emitted a linked factory for the monomorphic foreign type. An unbounded generic
    // field gets that factory through Type::discover even though its impl cannot require Describe.
    let generic_slot = probe::GenericSlot {
        value: foreign_types::Leaf(12),
    };
    let generic_slot_type = Type::of::<probe::GenericSlot<foreign_types::Leaf>>();
    let generic_slot_value = Value::from_parts(&generic_slot, generic_slot_type);
    assert_eq!(
        generic_slot_value.field("value").unwrap().ty().kind(),
        TypeKind::Struct
    );

    // Mutual recursion is initialized via stored child factories, never while either root is built.
    let mutual = probe::MutualA {
        b: Some(std::boxed::Box::new(probe::MutualB { a: Vec::new() })),
    };
    let mutual_value = Value::from_parts(&mutual, probe::MutualA::type_shape());
    let mutual_option = mutual_value.field("b").unwrap();
    let b = mutual_option.index(0).unwrap();
    assert_eq!(b.ty().kind(), TypeKind::BoxPointer);
    let b_value = b.index(0).unwrap();
    assert_eq!(b_value.ty().kind(), TypeKind::Struct);
    assert_eq!(b_value.field("a").unwrap().ty().kind(), TypeKind::Sequence);

    // Bare Value::new uses the full Describe bound and prepares the nested chain without any
    // field-site helper or macro-provided factories.
    let nested_values = vec![Some(foreign_types::Leaf(4))];
    let bare = Value::new(&nested_values);
    assert_eq!(bare.ty().kind(), TypeKind::Sequence);
    let bare_option = bare.index(0).unwrap();
    assert_eq!(bare_option.ty().kind(), TypeKind::Enum);
    assert_eq!(bare_option.index(0).unwrap().ty().kind(), TypeKind::Struct);
}

#[test]
fn binders_unsized_referents_and_cfg_fields_compile() {
    let binder = probe::BinderFields {
        callback: |_| {},
        reference: &"debug",
        boxed_unsized: std::boxed::Box::new(7u8),
    };
    assert_eq!(probe::BinderFields::type_shape().kind(), TypeKind::Struct);
    assert_eq!(probe::CfgFields::type_shape().kind(), TypeKind::Struct);
    let cfg_fields: Vec<_> = probe::CfgFields::type_shape().field_names().collect();
    assert!(!cfg_fields.contains(&"disabled"));
    #[cfg(unix)]
    assert!(cfg_fields.contains(&"unix"));
    #[cfg(not(unix))]
    assert!(cfg_fields.contains(&"non_unix"));
    let _ = Value::from_parts(&binder, probe::BinderFields::type_shape())
        .field("callback")
        .unwrap();
    let _ = Type::discover::<for<'a> fn(&'a u8)>();
    assert_eq!(
        kind_of_field(probe::BinderFields::type_shape(), "boxed_unsized"),
        TypeKind::Opaque
    );
}

#[test]
fn linked_inventory_discovery_is_thread_safe_and_canonical() {
    use std::sync::{Arc, Barrier};
    let count = 16;
    let barrier = Arc::new(Barrier::new(count));
    let workers: Vec<_> = (0..count)
        .map(|_| {
            let barrier = Arc::clone(&barrier);
            std::thread::spawn(move || {
                barrier.wait();
                Type::discover::<probe::RaceType>()
            })
        })
        .collect();
    let discovered: Vec<_> = workers
        .into_iter()
        .map(|worker| worker.join().unwrap())
        .collect();
    for ty in &discovered {
        assert_eq!(*ty, discovered[0]);
        assert_eq!(ty.kind(), TypeKind::Struct);
    }
}

#[test]
fn qself_associated_child_resolves_from_full_container_prepare() {
    let value = probe::QSelfHolder {
        item: Some(probe::UniqueGeneric(2u16)),
    };
    let root = probe::QSelfHolder::type_shape();
    let root_value = Value::from_parts(&value, root);
    let item = root_value.field("item").unwrap();
    assert_eq!(item.ty().kind(), TypeKind::Enum);
    assert_eq!(item.index(0).unwrap().ty().kind(), TypeKind::Struct);
}

#[test]
fn partial_container_shapes_survive_without_described_children() {
    let value = probe::PartialHolder {
        nested: Some(vec![OpaqueLeaf(4)]),
    };
    let root = probe::PartialHolder::type_shape();
    let root_value = Value::from_parts(&value, root);
    let optional = root_value.field("nested").unwrap();
    assert_eq!(optional.ty().kind(), TypeKind::Enum);
    let vector = optional.index(0).unwrap();
    assert_eq!(vector.ty().kind(), TypeKind::Sequence);
    assert_eq!(vector.index(0).unwrap().ty().kind(), TypeKind::Opaque);
}

#[test]
fn partial_sequence_child_handles_upgrade_after_full_type_of() {
    struct Item(u32);
    impl Describe for Item {
        fn build_type() -> gpui::reflection::Schema<Self> {
            gpui::reflection::Schema::new(
                vec![
                    gpui::reflection::Field::new("0", |v: &Self| &v.0, |v| &mut v.0)
                        .into_schema(Type::of::<u32>),
                ],
                None,
            )
        }
    }
    let values = vec![Item(4)];
    let partial = Type::vec::<Item>(Type::discover::<Item>);
    let partial_value = Value::from_parts(&values, partial);
    let old_child = partial_value.index(0).unwrap();
    assert_eq!(old_child.ty().kind(), TypeKind::Opaque);

    let full = Type::of::<Vec<Item>>();
    assert_eq!(full.kind(), TypeKind::Sequence);
    assert_eq!(old_child.ty().kind(), TypeKind::Struct);
}

#[test]
fn atomic_standard_types_terminate_bare_container_chains() {
    let strings = vec![Some(String::from("value"))];
    let root = Value::new(&strings);
    assert_eq!(root.ty().kind(), TypeKind::Sequence);
    let optional = root.index(0).unwrap();
    assert_eq!(optional.variant(), Some("Some"));
    let string = optional.index(0).unwrap();
    assert_eq!(string.ty().kind(), TypeKind::Opaque);
    assert_eq!(string.downcast_ref::<String>().unwrap(), "value");
}
mod foreign_rendering {
    pub struct Component;

    pub trait View {
        fn value(&self) -> u32;
    }

    pub trait LocalRole {
        fn generic<T>(&self, value: T) -> T;
    }
}

#[gpui::reflect]
mod unrelated_traits {
    pub trait RenderOnce {}
    pub trait View {}
    pub trait Element {}

    pub struct Component {
        pub value: u32,
    }

    impl RenderOnce for Component {}
    impl View for Component {}
    impl Element for Component {}
}

#[gpui::reflect]
mod unrelated_alias {
    use super::foreign_rendering::LocalRole as ForeignRole;
    use super::foreign_rendering::View as Element;

    pub trait LocalRole {}

    pub struct Component(pub u32);

    impl Element for Component {
        fn value(&self) -> u32 {
            self.0
        }
    }

    impl ForeignRole for Component {
        fn generic<T>(&self, value: T) -> T {
            value
        }
    }

    impl super::foreign_rendering::Component {
        pub fn foreign_method(&self) -> u32 {
            17
        }
    }
}

#[test]
fn unrelated_traits_keep_their_native_names_and_signatures() {
    let component = unrelated_traits::Component { value: 23 };
    let value = gpui::reflection::Value::new(&component);
    assert_eq!(
        *value.field("value").unwrap().downcast_ref::<u32>().unwrap(),
        23
    );
    assert!(value.ty().has_role::<dyn unrelated_traits::View>());
    assert!(value.ty().has_role::<dyn unrelated_traits::Element>());
    assert!(value.ty().has_role::<dyn unrelated_traits::RenderOnce>());

    use foreign_rendering::View as _;
    assert_eq!(unrelated_alias::Component(42).value(), 42);
    assert_eq!(foreign_rendering::Component.foreign_method(), 17);
    use foreign_rendering::LocalRole as _;
    assert_eq!(unrelated_alias::Component(42).generic("native"), "native");
    assert!(
        !gpui::reflection::Type::of::<unrelated_alias::Component>()
            .has_role::<dyn unrelated_alias::LocalRole>()
    );
}
