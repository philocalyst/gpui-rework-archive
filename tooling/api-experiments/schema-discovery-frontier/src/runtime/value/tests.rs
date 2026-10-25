use super::*;
use std::any::Any;

#[derive(Debug, PartialEq)]
struct Inner {
    title: String,
}
#[derive(Debug, PartialEq)]
struct Card {
    id: u32,
    inner: Inner,
    tags: Vec<String>,
    status: Status,
    note: Option<String>,
}
#[derive(Debug, PartialEq)]
enum Status {
    Open { owner: String },
    Closed { reason: String },
}

enum SameName {
    Count { value: u32 },
    Text { value: String },
}

struct Generic<T> {
    value: T,
}
impl<T: Any> Describe for Generic<T> {
    fn build_type() -> Schema<Self> {
        Schema::<Self>::new(
            vec![
                Field::new(
                    "value",
                    |value: &Self| &value.value,
                    |value| &mut value.value,
                )
                .into_schema(Type::opaque::<T>),
            ],
            None,
        )
    }
}
fn same_name_variant(value: &SameName) -> &'static str {
    match value {
        SameName::Count { .. } => "Count",
        SameName::Text { .. } => "Text",
    }
}
impl Describe for SameName {
    fn build_type() -> Schema<Self> {
        Schema::<Self>::new(
            vec![
                VariantField::new(
                    "Count",
                    "value",
                    |v: &Self| match v {
                        Self::Count { value } => Some(value),
                        _ => None,
                    },
                    |v| match v {
                        Self::Count { value } => Some(value),
                        _ => None,
                    },
                )
                .into_schema(u32_shape),
                VariantField::new(
                    "Text",
                    "value",
                    |v: &Self| match v {
                        Self::Text { value } => Some(value),
                        _ => None,
                    },
                    |v| match v {
                        Self::Text { value } => Some(value),
                        _ => None,
                    },
                )
                .into_schema(string_shape),
            ],
            Some(same_name_variant),
        )
    }
}

fn string_shape() -> Type {
    Type::opaque::<String>()
}
fn u32_shape() -> Type {
    Type::opaque::<u32>()
}
fn inner_shape() -> Type {
    Type::of::<Inner>()
}
fn tags_shape() -> Type {
    Type::vec::<String>(string_shape)
}
fn note_shape() -> Type {
    Type::option::<String>(string_shape)
}

impl Describe for Inner {
    fn build_type() -> Schema<Self> {
        Schema::<Self>::new(
            vec![
                Field::new("title", |i: &Self| &i.title, |i| &mut i.title)
                    .into_schema(string_shape),
            ],
            None,
        )
    }
}
fn status_variant(value: &Status) -> &'static str {
    match value {
        Status::Open { .. } => "Open",
        Status::Closed { .. } => "Closed",
    }
}
impl Describe for Card {
    fn build_type() -> Schema<Self> {
        Schema::<Self>::new(
            vec![
                Field::new("id", |c: &Self| &c.id, |c| &mut c.id).into_schema(u32_shape),
                Field::new("inner", |c: &Self| &c.inner, |c| &mut c.inner).into_schema(inner_shape),
                Field::new("tags", |c: &Self| &c.tags, |c| &mut c.tags).into_schema(tags_shape),
                Field::new("status", |c: &Self| &c.status, |c| &mut c.status)
                    .into_schema(Type::of::<Status>),
                Field::new("note", |c: &Self| &c.note, |c| &mut c.note).into_schema(note_shape),
            ],
            None,
        )
    }
}
impl Describe for Status {
    fn build_type() -> Schema<Self> {
        Schema::<Self>::new(
            vec![
                VariantField::new(
                    "Open",
                    "owner",
                    |s: &Self| match s {
                        Self::Open { owner } => Some(owner),
                        _ => None,
                    },
                    |s| match s {
                        Self::Open { owner } => Some(owner),
                        _ => None,
                    },
                )
                .into_schema(string_shape),
                VariantField::new(
                    "Closed",
                    "reason",
                    |s: &Self| match s {
                        Self::Closed { reason } => Some(reason),
                        _ => None,
                    },
                    |s| match s {
                        Self::Closed { reason } => Some(reason),
                        _ => None,
                    },
                )
                .into_schema(string_shape),
            ],
            Some(status_variant),
        )
    }
}

impl Card {
    fn fields() -> CardFields {
        CardFields {
            id: Field::new("id", |c: &Self| &c.id, |c| &mut c.id),
            inner: Field::new("inner", |c: &Self| &c.inner, |c| &mut c.inner),
        }
    }
}
struct CardFields {
    id: Field<Card, u32>,
    inner: Field<Card, Inner>,
}
impl Inner {
    fn fields() -> InnerFields {
        InnerFields {
            title: Field::new("title", |i: &Self| &i.title, |i| &mut i.title),
        }
    }
}
struct InnerFields {
    title: Field<Inner, String>,
}
fn card() -> Card {
    Card {
        id: 7,
        inner: Inner {
            title: "before".into(),
        },
        tags: vec!["one".into(), "two".into()],
        status: Status::Open {
            owner: "Ada".into(),
        },
        note: Some("draft".into()),
    }
}

#[test]
fn dynamic_borrows_cover_nested_fields_variants_and_containers() {
    let mut card = card();
    let mut value = ValueMut::new(&mut card);
    value
        .field("inner")
        .unwrap()
        .field("title")
        .unwrap()
        .downcast_mut::<String>()
        .unwrap()
        .push_str(" title");
    value
        .field("tags")
        .unwrap()
        .index(1)
        .unwrap()
        .downcast_mut::<String>()
        .unwrap()
        .push('!');
    let mut status = value.field("status").unwrap();
    assert_eq!(status.variant(), Some("Open"));
    status
        .field("owner")
        .unwrap()
        .downcast_mut::<String>()
        .unwrap()
        .push_str(" Lovelace");
    let mut note = value.field("note").unwrap();
    assert_eq!(note.variant(), Some("Some"));
    note.index(0)
        .unwrap()
        .downcast_mut::<String>()
        .unwrap()
        .push_str(" note");
    drop(value);
    assert_eq!(card.inner.title, "before title");
    assert_eq!(card.tags[1], "two!");
    assert_eq!(
        card.status,
        Status::Open {
            owner: "Ada Lovelace".into()
        }
    );
    assert_eq!(card.note.as_deref(), Some("draft note"));
}

#[test]
fn inspection_metadata_and_immediate_visitors_are_borrowed() {
    let schema = Type::of::<Card>();
    assert_eq!(schema.kind(), TypeKind::Struct);
    let tags = schema.fields().find(|field| field.name == "tags").unwrap();
    assert_eq!(tags.ty.kind(), TypeKind::Sequence);
    let note = schema.fields().find(|field| field.name == "note").unwrap();
    assert_eq!(note.ty.kind(), TypeKind::Enum);
    assert!(note.ty.is_sequence());
    let status_schema = Type::of::<Status>();
    assert!(status_schema.is_enum());
    let status_fields = status_schema.fields().collect::<Vec<_>>();
    assert_eq!(status_fields.len(), 2);
    assert!(status_fields.iter().all(|field| field.variant.is_some()));
    assert!(
        status_fields
            .iter()
            .all(|field| field.ty.kind() == TypeKind::Opaque)
    );

    let readonly_card = card();
    let tags_schema = Type::vec::<String>(string_shape);
    let tags = Value::from_parts(&readonly_card.tags, tags_schema);
    assert_eq!(tags.len(), Some(2));
    let status = Value::new(&readonly_card.status);
    assert_eq!(
        status.fields().map(|(name, _)| name).collect::<Vec<_>>(),
        ["owner"]
    );

    let mut card = card();
    let mut root = ValueMut::new(&mut card);
    let mut visited = Vec::new();
    root.visit_fields(|name, mut field| {
        visited.push(name);
        if let Some(id) = field.downcast_mut::<u32>() {
            *id += 1;
        }
    });
    assert!(visited.contains(&"id"));
    assert_eq!(root.downcast_ref::<Card>().unwrap().id, 8);
}

#[test]
fn schema_cache_is_distinct_per_generic_monomorphization() {
    let byte_type = Type::of::<Generic<u8>>();
    let string_type = Type::of::<Generic<String>>();
    assert_ne!(byte_type.type_id(), string_type.type_id());
    let mut byte = Generic { value: 7u8 };
    let mut text = Generic {
        value: String::from("typed"),
    };
    assert_eq!(
        ValueMut::new(&mut byte)
            .field("value")
            .unwrap()
            .downcast_ref::<u8>(),
        Some(&7)
    );
    assert_eq!(
        ValueMut::new(&mut text)
            .field("value")
            .unwrap()
            .downcast_ref::<String>()
            .map(String::as_str),
        Some("typed")
    );
}

#[test]
fn typed_handle_construction_does_not_require_static_field_types() {
    struct Borrowed<'a>(&'a str);
    let field = Field::new(
        "value",
        |value: &Borrowed<'_>| &value.0,
        |value| &mut value.0,
    );
    let first = String::from("borrowed");
    let second = String::from("other");
    let mut value = Borrowed(&first);
    assert_eq!(*field.get(&value), "borrowed");
    *field.get_mut(&mut value) = &second;
    assert_eq!(value.0, "other");
}

#[test]
fn typed_nested_variant_and_method_paths_keep_borrow_types() {
    let nested = Card::fields().inner.then(Inner::fields().title);
    let mut card = card();
    assert_eq!(Card::fields().id.get(&card), &7);
    assert_eq!(nested.get(&card).unwrap(), "before");
    *ValueMut::new(&mut card).at(nested).unwrap() = "typed".into();
    let owner = VariantField::new(
        "Open",
        "owner",
        |s: &Status| match s {
            Status::Open { owner } => Some(owner),
            _ => None,
        },
        |s| match s {
            Status::Open { owner } => Some(owner),
            _ => None,
        },
    );
    assert_eq!(owner.get(&card.status).unwrap(), "Ada");
    let method = Method::new("label", |card: &Card, prefix: String| {
        format!("{prefix}{}", card.id)
    });
    assert_eq!(
        method.call_on(Value::new(&card), "card-".into()).unwrap(),
        "card-7"
    );
    assert_eq!(Value::new(&card).at(nested).unwrap(), "typed");
}

#[test]
fn enum_field_and_sequence_absence_are_checked() {
    let mut card = card();
    card.status = Status::Closed {
        reason: "done".into(),
    };
    card.note = None;
    let mut value = ValueMut::new(&mut card);
    let mut status = value.field("status").unwrap();
    assert_eq!(status.variant(), Some("Closed"));
    assert!(status.field("owner").is_none());
    assert_eq!(
        status
            .field("reason")
            .unwrap()
            .downcast_ref::<String>()
            .map(String::as_str),
        Some("done")
    );
    let mut note = value.field("note").unwrap();
    assert_eq!(note.variant(), Some("None"));
    assert!(note.index(0).is_none());
    assert!(value.field("missing").is_none());
}

#[test]
fn repeated_enum_field_names_resolve_the_active_typed_field_once() {
    let mut value = SameName::Text {
        value: "text".into(),
    };
    let mut erased = ValueMut::new(&mut value);
    erased
        .field("value")
        .unwrap()
        .downcast_mut::<String>()
        .unwrap()
        .push('!');
    let mut visits = 0;
    erased.walk_mut(|node| {
        if node.downcast_mut::<String>().is_some() {
            visits += 1;
        }
    });
    assert_eq!(visits, 1);
    assert_eq!(
        erased
            .ty()
            .fields()
            .filter(|field| field.name == "value")
            .count(),
        2
    );
    assert_eq!(
        erased
            .ty()
            .fields()
            .filter(|field| field.variant.is_some())
            .count(),
        2
    );
    drop(erased);
    assert!(matches!(value, SameName::Text { value } if value == "text!"));

    let mut value = SameName::Count { value: 41 };
    let mut erased = ValueMut::new(&mut value);
    *erased
        .field("value")
        .unwrap()
        .downcast_mut::<u32>()
        .unwrap() += 1;
    assert_eq!(erased.variant(), Some("Count"));
    drop(erased);
    assert!(matches!(value, SameName::Count { value: 42 }));
}

struct RoleOnly(String);
trait LabelRole {
    fn label(&mut self) -> &mut String;
}
impl LabelRole for RoleOnly {
    fn label(&mut self) -> &mut String {
        &mut self.0
    }
}

#[test]
fn native_role_views_are_exact_and_borrowed() {
    let schema = Schema::<RoleOnly>::with_roles(
        vec![],
        None,
        vec![Role::<RoleOnly, dyn LabelRole>::new(|value| value).into_schema()],
    )
    .publish();
    let mut value = RoleOnly("role".into());
    let mut erased = ValueMut::from_parts(&mut value, schema);
    erased
        .cast_mut::<dyn LabelRole>()
        .unwrap()
        .label()
        .push_str(" view");
    assert!(erased.cast_mut::<dyn std::fmt::Debug>().is_none());
    drop(erased);
    assert_eq!(value.0, "role view");

    let mut value = RoleOnly("owned borrow".into());
    {
        let view: &mut dyn LabelRole = ValueMut::from_parts(&mut value, schema)
            .into_cast_mut::<dyn LabelRole>()
            .unwrap();
        view.label().push_str(" preserved");
    }
    assert_eq!(value.0, "owned borrow preserved");
}

#[test]
fn visitor_walks_borrowed_tree_one_child_at_a_time() {
    let mut card = card();
    let mut value = ValueMut::new(&mut card);
    let mut visits = 0;
    value.walk_mut(|node| {
        visits += 1;
        if let Some(text) = node.downcast_mut::<String>() {
            text.push('!');
        }
    });
    drop(value);
    assert!(visits >= 10);
    assert_eq!(card.inner.title, "before!");
    assert_eq!(card.tags, ["one!", "two!"]);
}

struct RecursiveChain {
    value: u32,
    next: Option<Box<RecursiveChain>>,
}
fn recursive_chain_shape() -> Type {
    Type::of::<RecursiveChain>()
}
fn boxed_recursive_chain_shape() -> Type {
    Type::boxed::<RecursiveChain>(recursive_chain_shape)
}
fn recursive_chain_option_shape() -> Type {
    Type::option::<Box<RecursiveChain>>(boxed_recursive_chain_shape)
}
impl Describe for RecursiveChain {
    fn build_type() -> Schema<Self> {
        Schema::<Self>::new(
            vec![
                Field::new("value", |node: &Self| &node.value, |node| &mut node.value)
                    .into_schema(u32_shape),
                Field::new("next", |node: &Self| &node.next, |node| &mut node.next)
                    .into_schema(recursive_chain_option_shape),
            ],
            None,
        )
    }
}

#[test]
fn boxed_recursive_children_resolve_lazily_and_walk_without_reentering_initialization() {
    let mut chain = RecursiveChain {
        value: 1,
        next: Some(Box::new(RecursiveChain {
            value: 2,
            next: Some(Box::new(RecursiveChain {
                value: 3,
                next: None,
            })),
        })),
    };

    // Publishing the root must not try to initialize its own child schema.
    let schema = Type::of::<RecursiveChain>();
    assert_eq!(schema.kind(), TypeKind::Struct);
    assert_eq!(boxed_recursive_chain_shape().kind(), TypeKind::BoxPointer);
    let mut value = ValueMut::from_parts(&mut chain, schema);
    assert_eq!(value.field("next").unwrap().variant(), Some("Some"));
    assert!(
        value
            .field("next")
            .unwrap()
            .index(0)
            .unwrap()
            .index(1)
            .is_none()
    );
    assert_eq!(
        value
            .field("next")
            .unwrap()
            .index(0)
            .unwrap()
            .index(0)
            .unwrap()
            .field("value")
            .unwrap()
            .downcast_ref::<u32>(),
        Some(&2)
    );
    *value
        .field("next")
        .unwrap()
        .index(0)
        .unwrap()
        .index(0)
        .unwrap()
        .field("value")
        .unwrap()
        .downcast_mut::<u32>()
        .unwrap() += 10;
    *value
        .field("next")
        .unwrap()
        .index(0)
        .unwrap()
        .index(0)
        .unwrap()
        .field("next")
        .unwrap()
        .index(0)
        .unwrap()
        .index(0)
        .unwrap()
        .field("value")
        .unwrap()
        .downcast_mut::<u32>()
        .unwrap() += 10;
    assert_eq!(
        value
            .field("next")
            .unwrap()
            .index(0)
            .unwrap()
            .index(0)
            .unwrap()
            .field("next")
            .unwrap()
            .variant(),
        Some("Some")
    );
    assert_eq!(chain.value, 1);
    assert_eq!(chain.next.as_ref().unwrap().value, 12);
    assert_eq!(
        chain.next.as_ref().unwrap().next.as_ref().unwrap().value,
        13
    );
}

#[test]
fn fixed_arrays_are_checked_mutable_sequences_with_lazy_element_shapes() {
    let schema = Type::array::<Inner, 2>(inner_shape);
    assert_eq!(schema.kind(), TypeKind::ArraySequence);
    assert!(schema.is_sequence());
    let mut values = [
        Inner {
            title: "first".into(),
        },
        Inner {
            title: "second".into(),
        },
    ];
    let mut array = ValueMut::from_parts(&mut values, schema);
    assert_eq!(array.len(), Some(2));
    assert!(array.index(2).is_none());
    array
        .index(1)
        .unwrap()
        .field("title")
        .unwrap()
        .downcast_mut::<String>()
        .unwrap()
        .push_str(" updated");
    // Child metadata is stable after warming and retains the described element shape.
    assert_eq!(schema.fields().count(), 0);
    assert_eq!(array.index(0).unwrap().ty().kind(), TypeKind::Struct);
    assert_eq!(values[1].title, "second updated");

    let empty_schema = Type::array::<u32, 0>(u32_shape);
    let mut empty: [u32; 0] = [];
    let mut empty = ValueMut::from_parts(&mut empty, empty_schema);
    assert_eq!(empty.len(), Some(0));
    assert!(empty.index(0).is_none());
}
