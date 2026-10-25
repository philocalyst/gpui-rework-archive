//! Isolated tests and benchmarks for the production `gpui::reflection::value` runtime.
//!
//! This experiment imports the source directly so it stays dependency-free and exercises the
//! exact implementation in the checkout.
#[path = "../../../../crates/gpui/src/reflection/value.rs"]
mod value;

pub use value::*;

#[cfg(test)]
mod tests {
    use super::*;
    struct SameName {
        value: SamePayload,
    }
    enum SamePayload {
        Number { value: u32 },
        Text { value: String },
    }

    fn same_variant(value: &SameName) -> &'static str {
        match value.value {
            SamePayload::Number { .. } => "Number",
            SamePayload::Text { .. } => "Text",
        }
    }
    impl Describe for SameName {
        fn build_type() -> Schema<Self> {
            Schema::new(
                vec![
                    VariantField::new(
                        "Number",
                        "value",
                        |root: &Self| match &root.value {
                            SamePayload::Number { value } => Some(value),
                            _ => None,
                        },
                        |root| match &mut root.value {
                            SamePayload::Number { value } => Some(value),
                            _ => None,
                        },
                    )
                    .into_schema(Type::opaque::<u32>),
                    VariantField::new(
                        "Text",
                        "value",
                        |root: &Self| match &root.value {
                            SamePayload::Text { value } => Some(value),
                            _ => None,
                        },
                        |root| match &mut root.value {
                            SamePayload::Text { value } => Some(value),
                            _ => None,
                        },
                    )
                    .into_schema(Type::opaque::<String>),
                ],
                Some(same_variant),
            )
        }
    }

    struct Node {
        label: String,
        children: Vec<Node>,
        selected: Option<Vec<Node>>,
    }
    fn node_shape() -> Type {
        Node::type_shape()
    }
    fn children_shape() -> Type {
        Type::vec::<Node>(node_shape)
    }
    fn selected_shape() -> Type {
        Type::option::<Vec<Node>>(children_shape)
    }
    impl Describe for Node {
        fn build_type() -> Schema<Self> {
            Schema::new(
                vec![
                    Field::new("label", |v: &Self| &v.label, |v| &mut v.label)
                        .into_schema(Type::opaque::<String>),
                    Field::new("children", |v: &Self| &v.children, |v| &mut v.children)
                        .into_schema(children_shape),
                    Field::new("selected", |v: &Self| &v.selected, |v| &mut v.selected)
                        .into_schema(selected_shape),
                ],
                None,
            )
        }
    }

    trait RoleView {
        type Item;
        fn bump(&mut self);
    }
    struct RoleRoot {
        count: u64,
    }
    impl RoleView for RoleRoot {
        type Item = u64;
        fn bump(&mut self) {
            self.count += 1;
        }
    }
    impl Describe for RoleRoot {
        fn build_type() -> Schema<Self> {
            Schema::with_roles(
                vec![],
                None,
                vec![Role::<Self, dyn RoleView<Item = u64>>::new(|root| root).into_schema()],
            )
        }
    }

    struct Upgrade {
        value: u32,
    }
    impl Describe for Upgrade {
        fn build_type() -> Schema<Self> {
            Schema::new(
                vec![
                    Field::new("value", |v: &Self| &v.value, |v| &mut v.value)
                        .into_schema(Type::opaque::<u32>),
                ],
                None,
            )
        }
    }

    #[test]
    fn same_named_enum_fields_are_selected_by_active_variant() {
        let mut number = SameName {
            value: SamePayload::Number { value: 3 },
        };
        let mut dynamic = ValueMut::new(&mut number);
        *dynamic
            .field("value")
            .unwrap()
            .downcast_mut::<u32>()
            .unwrap() += 4;
        assert_eq!(dynamic.variant(), Some("Number"));
        assert_eq!(
            *dynamic
                .field("value")
                .unwrap()
                .downcast_ref::<u32>()
                .unwrap(),
            7
        );

        let mut text = SameName {
            value: SamePayload::Text { value: "a".into() },
        };
        let mut dynamic = ValueMut::new(&mut text);
        dynamic
            .field("value")
            .unwrap()
            .downcast_mut::<String>()
            .unwrap()
            .push('b');
        assert_eq!(dynamic.variant(), Some("Text"));
        assert_eq!(
            dynamic
                .field("value")
                .unwrap()
                .downcast_ref::<String>()
                .unwrap(),
            "ab"
        );
    }

    #[test]
    fn recursive_vec_and_option_shapes_walk_finite_values() {
        let leaf = Node {
            label: "leaf".into(),
            children: vec![],
            selected: None,
        };
        let mut root = Node {
            label: "root".into(),
            children: vec![leaf],
            selected: Some(vec![Node {
                label: "chosen".into(),
                children: vec![],
                selected: None,
            }]),
        };
        let mut value = ValueMut::new(&mut root);
        let mut seen = Vec::new();
        value.walk_mut(|node| {
            if let Some(label) = node.downcast_mut::<String>() {
                seen.push(label.clone());
            }
        });
        assert_eq!(seen, ["root", "leaf", "chosen"]);
        assert_eq!(
            value.ty().field_names().collect::<Vec<_>>(),
            ["label", "children", "selected"]
        );
    }

    #[test]
    fn role_with_associated_type_bound_uses_registered_native_projection() {
        let mut root = RoleRoot { count: 10 };
        let mut value = ValueMut::new(&mut root);
        assert!(value.ty().has_role::<dyn RoleView<Item = u64>>());
        value.cast_mut::<dyn RoleView<Item = u64>>().unwrap().bump();
        assert_eq!(value.downcast_ref::<RoleRoot>().unwrap().count, 11);
        assert!(value.cast_mut::<dyn RoleView<Item = String>>().is_none());
    }

    #[test]
    fn described_schema_replaces_earlier_opaque_schema() {
        let opaque = Type::opaque::<Upgrade>();
        assert_eq!(opaque.field_names().count(), 0);
        let described = Type::of::<Upgrade>();
        assert_eq!(described.field_names().collect::<Vec<_>>(), ["value"]);
        assert_eq!(
            Type::opaque::<Upgrade>().field_names().collect::<Vec<_>>(),
            ["value"]
        );
    }
}
