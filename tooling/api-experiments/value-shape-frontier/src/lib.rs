//! A std-only experiment in typed paths over runtime-described erased values.
use std::any::{Any, TypeId};

/// One opt-in surface for a type: a constant schema plus its typed field paths.
pub trait ValueShape: Any + Sized {
    fn schema() -> &'static dyn Shape;
}

/// Runtime metadata for one concrete value type.
pub trait Shape: Sync {
    fn name(&self) -> &'static str;
    fn type_id(&self) -> TypeId;
    fn accepts(&self, value: &dyn Any) -> bool;
    fn field<'a>(&self, value: &'a mut dyn Any, name: &str) -> Option<DynValue<'a>>;
    fn variant(&self, value: &dyn Any) -> Option<&'static str>;
    fn field_count(&self) -> usize {
        0
    }
    fn field_name(&self, _index: usize) -> Option<&'static str> {
        None
    }
    fn len(&self, _value: &dyn Any) -> Option<usize> {
        None
    }
    fn index<'a>(&self, _value: &'a mut dyn Any, _index: usize) -> Option<DynValue<'a>> {
        None
    }
}

/// A field accessor uses safe typed functions; it never computes a field offset.
pub struct Field<T: Any, U: Any> {
    pub name: &'static str,
    pub shape: &'static dyn Shape,
    get_mut: fn(&mut T) -> Option<&mut U>,
}
impl<T: Any, U: Any> Field<T, U> {
    pub const fn new(
        name: &'static str,
        shape: &'static dyn Shape,
        get_mut: fn(&mut T) -> Option<&mut U>,
    ) -> Self {
        Self {
            name,
            shape,
            get_mut,
        }
    }
}
pub trait FieldSchema: Sync {
    fn name(&self) -> &'static str;
    fn get<'a>(&self, root: &'a mut dyn Any) -> Option<DynValue<'a>>;
}
impl<T: Any, U: Any> FieldSchema for Field<T, U> {
    fn name(&self) -> &'static str {
        self.name
    }
    fn get<'a>(&self, root: &'a mut dyn Any) -> Option<DynValue<'a>> {
        let root = root.downcast_mut::<T>()?;
        Some(DynValue {
            value: (self.get_mut)(root)?,
            shape: self.shape,
        })
    }
}

/// Struct or enum schema. Enum field accessors may return `None` for inactive fields.
pub struct RecordSchema<T: Any> {
    name: &'static str,
    fields: &'static [&'static dyn FieldSchema],
    variant: Option<fn(&T) -> &'static str>,
}
impl<T: Any> RecordSchema<T> {
    pub const fn new(name: &'static str, fields: &'static [&'static dyn FieldSchema]) -> Self {
        Self {
            name,
            fields,
            variant: None,
        }
    }
    pub const fn enumeration(
        name: &'static str,
        fields: &'static [&'static dyn FieldSchema],
        variant: fn(&T) -> &'static str,
    ) -> Self {
        Self {
            name,
            fields,
            variant: Some(variant),
        }
    }
}
impl<T: Any + Sync> Shape for RecordSchema<T> {
    fn name(&self) -> &'static str {
        self.name
    }
    fn type_id(&self) -> TypeId {
        TypeId::of::<T>()
    }
    fn accepts(&self, value: &dyn Any) -> bool {
        value.is::<T>()
    }
    fn field_count(&self) -> usize {
        self.fields.len()
    }
    fn field_name(&self, index: usize) -> Option<&'static str> {
        self.fields.get(index).map(|field| field.name())
    }
    fn field<'a>(&self, value: &'a mut dyn Any, name: &str) -> Option<DynValue<'a>> {
        self.fields
            .iter()
            .find(|field| field.name() == name)?
            .get(value)
    }
    fn variant(&self, value: &dyn Any) -> Option<&'static str> {
        let variant = self.variant?;
        Some(variant(value.downcast_ref::<T>()?))
    }
}

/// Vec schema adds safe index access and carries the element's own schema.
pub struct VecSchema<T: Any> {
    name: &'static str,
    item: &'static dyn Shape,
    _item: fn(&T),
}
impl<T: Any> VecSchema<T> {
    pub const fn new(name: &'static str, item: &'static dyn Shape) -> Self {
        Self {
            name,
            item,
            _item: |_| {},
        }
    }
}
impl<T: Any + Sync> Shape for VecSchema<T> {
    fn name(&self) -> &'static str {
        self.name
    }
    fn type_id(&self) -> TypeId {
        TypeId::of::<Vec<T>>()
    }
    fn accepts(&self, value: &dyn Any) -> bool {
        value.is::<Vec<T>>()
    }
    fn field<'a>(&self, _value: &'a mut dyn Any, _name: &str) -> Option<DynValue<'a>> {
        None
    }
    fn variant(&self, _value: &dyn Any) -> Option<&'static str> {
        None
    }
    fn len(&self, value: &dyn Any) -> Option<usize> {
        Some(value.downcast_ref::<Vec<T>>()?.len())
    }
    fn index<'a>(&self, value: &'a mut dyn Any, index: usize) -> Option<DynValue<'a>> {
        let vec = value.downcast_mut::<Vec<T>>()?;
        Some(DynValue {
            value: vec.get_mut(index)?,
            shape: self.item,
        })
    }
}

/// A checked typed projection for fields that exist only in one enum variant.
#[derive(Clone, Copy)]
pub struct VariantPath<Root, Leaf> {
    pub variant: &'static str,
    pub field: &'static str,
    get: fn(&Root) -> Option<&Leaf>,
    get_mut: fn(&mut Root) -> Option<&mut Leaf>,
}
impl<Root, Leaf> VariantPath<Root, Leaf> {
    pub const fn new(
        variant: &'static str,
        field: &'static str,
        get: fn(&Root) -> Option<&Leaf>,
        get_mut: fn(&mut Root) -> Option<&mut Leaf>,
    ) -> Self {
        Self {
            variant,
            field,
            get,
            get_mut,
        }
    }
    pub fn get<'a>(&self, root: &'a Root) -> Option<&'a Leaf> {
        (self.get)(root)
    }
    pub fn get_mut<'a>(&self, root: &'a mut Root) -> Option<&'a mut Leaf> {
        (self.get_mut)(root)
    }
}

/// Typed method path. The argument and result types travel in the callable signature.
#[derive(Clone, Copy)]
pub struct MethodPath<Root, Args, Output> {
    pub name: &'static str,
    call: fn(&Root, Args) -> Output,
}
impl<Root, Args, Output> MethodPath<Root, Args, Output> {
    pub const fn new(name: &'static str, call: fn(&Root, Args) -> Output) -> Self {
        Self { name, call }
    }
    pub fn call(&self, root: &Root, args: Args) -> Output {
        (self.call)(root, args)
    }
}

/// Option schema exposes `Some`/`None` and index zero for its borrowed payload.
pub struct OptionSchema<T: Any> {
    name: &'static str,
    item: &'static dyn Shape,
    _item: fn(&T),
}
impl<T: Any> OptionSchema<T> {
    pub const fn new(name: &'static str, item: &'static dyn Shape) -> Self {
        Self {
            name,
            item,
            _item: |_| {},
        }
    }
}
impl<T: Any + Sync> Shape for OptionSchema<T> {
    fn name(&self) -> &'static str {
        self.name
    }
    fn type_id(&self) -> TypeId {
        TypeId::of::<Option<T>>()
    }
    fn accepts(&self, value: &dyn Any) -> bool {
        value.is::<Option<T>>()
    }
    fn field<'a>(&self, _: &'a mut dyn Any, _: &str) -> Option<DynValue<'a>> {
        None
    }
    fn variant(&self, value: &dyn Any) -> Option<&'static str> {
        let option = value.downcast_ref::<Option<T>>()?;
        Some(if option.is_some() { "Some" } else { "None" })
    }
    fn len(&self, value: &dyn Any) -> Option<usize> {
        Some(usize::from(value.downcast_ref::<Option<T>>()?.is_some()))
    }
    fn index<'a>(&self, value: &'a mut dyn Any, index: usize) -> Option<DynValue<'a>> {
        if index != 0 {
            return None;
        }
        let option = value.downcast_mut::<Option<T>>()?;
        Some(DynValue {
            value: option.as_mut()?,
            shape: self.item,
        })
    }
}

/// Borrowed dynamic node. Children borrow from this call and cannot outlive the root borrow.
pub struct DynValue<'a> {
    value: &'a mut dyn Any,
    shape: &'static dyn Shape,
}
impl<'a> DynValue<'a> {
    pub fn new<T: ValueShape>(value: &'a mut T) -> Self {
        Self {
            value,
            shape: T::schema(),
        }
    }
    pub fn erased(value: &'a mut dyn Any, shape: &'static dyn Shape) -> Option<Self> {
        shape.accepts(&*value).then_some(Self { value, shape })
    }
    pub fn shape(&self) -> &'static dyn Shape {
        self.shape
    }
    pub fn variant(&self) -> Option<&'static str> {
        self.shape.variant(self.value)
    }
    pub fn field(&mut self, name: &str) -> Option<DynValue<'_>> {
        self.shape.field(self.value, name)
    }
    pub fn index(&mut self, index: usize) -> Option<DynValue<'_>> {
        self.shape.index(self.value, index)
    }
    pub fn walk_mut(&mut self, mut visitor: impl FnMut(&mut DynValue<'_>)) {
        self.walk_inner(&mut visitor);
    }
    fn walk_inner(&mut self, visitor: &mut impl FnMut(&mut DynValue<'_>)) {
        visitor(self);
        let field_count = self.shape.field_count();
        for index in 0..field_count {
            let Some(name) = self.shape.field_name(index) else {
                continue;
            };
            if let Some(mut child) = self.field(name) {
                child.walk_inner(visitor);
            }
        }
        let len = self.shape.len(&*self.value).unwrap_or(0);
        for index in 0..len {
            if let Some(mut child) = self.index(index) {
                child.walk_inner(visitor);
            }
        }
    }
    pub fn downcast_ref<T: Any>(&self) -> Option<&T> {
        self.value.downcast_ref()
    }
    pub fn downcast_mut<T: Any>(&mut self) -> Option<&mut T> {
        self.value.downcast_mut()
    }
}

/// A typed direct field path. Function pointers encode the types; no PhantomData is needed.
#[derive(Clone, Copy)]
pub struct Path<Root, Leaf> {
    pub name: &'static str,
    get: fn(&Root) -> &Leaf,
    get_mut: fn(&mut Root) -> &mut Leaf,
}
impl<Root, Leaf> Path<Root, Leaf> {
    pub const fn new(
        name: &'static str,
        get: fn(&Root) -> &Leaf,
        get_mut: fn(&mut Root) -> &mut Leaf,
    ) -> Self {
        Self { name, get, get_mut }
    }
    pub fn get<'a>(&self, root: &'a Root) -> &'a Leaf {
        (self.get)(root)
    }
    pub fn get_mut<'a>(&self, root: &'a mut Root) -> &'a mut Leaf {
        (self.get_mut)(root)
    }
    pub fn then<Next>(self, next: Path<Leaf, Next>) -> Then<Root, Leaf, Next> {
        Then {
            outer: self,
            inner: next,
        }
    }
}

#[derive(Clone, Copy)]
pub struct Then<Root, Mid, Leaf> {
    outer: Path<Root, Mid>,
    inner: Path<Mid, Leaf>,
}
impl<Root: 'static, Mid: 'static, Leaf: 'static> Then<Root, Mid, Leaf> {
    pub fn get<'a>(&self, root: &'a Root) -> &'a Leaf {
        self.inner.get(self.outer.get(root))
    }
    pub fn get_mut<'a>(&self, root: &'a mut Root) -> &'a mut Leaf {
        self.inner.get_mut(self.outer.get_mut(root))
    }
}

pub struct Query<Root>(fn(&mut Root) -> &mut Root);
pub fn query<Root>() -> Query<Root> {
    Query(|root| root)
}
impl<Root: Any> Query<Root> {
    pub fn where_field<Leaf: PartialEq + Any>(
        self,
        path: Path<Root, Leaf>,
        expected: Leaf,
    ) -> FieldQuery<Root, Leaf> {
        let _ = self.0;
        FieldQuery { path, expected }
    }
}
pub struct FieldQuery<Root, Leaf> {
    path: Path<Root, Leaf>,
    expected: Leaf,
}
impl<Root: Any, Leaf: PartialEq + Any> FieldQuery<Root, Leaf> {
    pub fn edit(self, value: &mut dyn Any, edit: impl FnOnce(&mut Leaf)) -> bool {
        let Some(root) = value.downcast_mut::<Root>() else {
            return false;
        };
        if self.path.get(root) != &self.expected {
            return false;
        }
        edit(self.path.get_mut(root));
        true
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[derive(Debug, PartialEq)]
    struct Payload {
        text: String,
    }
    #[derive(Debug, PartialEq)]
    struct Card {
        id: u32,
        payload: Payload,
        tags: Vec<String>,
        status: Status,
        note: Option<String>,
    }
    #[derive(Debug, PartialEq)]
    enum Status {
        Open { owner: String },
        Closed { reason: String },
    }

    struct StringShape;
    impl Shape for StringShape {
        fn name(&self) -> &'static str {
            "String"
        }
        fn type_id(&self) -> TypeId {
            TypeId::of::<String>()
        }
        fn accepts(&self, v: &dyn Any) -> bool {
            v.is::<String>()
        }
        fn field<'a>(&self, _: &'a mut dyn Any, _: &str) -> Option<DynValue<'a>> {
            None
        }
        fn variant(&self, _: &dyn Any) -> Option<&'static str> {
            None
        }
    }
    struct U32Shape;
    impl Shape for U32Shape {
        fn name(&self) -> &'static str {
            "u32"
        }
        fn type_id(&self) -> TypeId {
            TypeId::of::<u32>()
        }
        fn accepts(&self, v: &dyn Any) -> bool {
            v.is::<u32>()
        }
        fn field<'a>(&self, _: &'a mut dyn Any, _: &str) -> Option<DynValue<'a>> {
            None
        }
        fn variant(&self, _: &dyn Any) -> Option<&'static str> {
            None
        }
    }
    static STRING: StringShape = StringShape;
    static U32: U32Shape = U32Shape;
    static PAYLOAD_TEXT: Field<Payload, String> =
        Field::new("text", &STRING, |p| Some(&mut p.text));
    static PAYLOAD_FIELDS: &[&dyn FieldSchema] = &[&PAYLOAD_TEXT];
    static PAYLOAD_SCHEMA: RecordSchema<Payload> = RecordSchema::new("Payload", PAYLOAD_FIELDS);
    static CARD_ID: Field<Card, u32> = Field::new("id", &U32, |c| Some(&mut c.id));
    static CARD_PAYLOAD: Field<Card, Payload> =
        Field::new("payload", &PAYLOAD_SCHEMA, |c| Some(&mut c.payload));
    static CARD_TAGS: Field<Card, Vec<String>> =
        Field::new("tags", &TAGS_SCHEMA, |c| Some(&mut c.tags));
    static STATUS_OWNER: Field<Status, String> = Field::new("owner", &STRING, |s| match s {
        Status::Open { owner } => Some(owner),
        Status::Closed { .. } => None,
    });
    static STATUS_FIELDS: &[&dyn FieldSchema] = &[&STATUS_OWNER];
    static STATUS_SCHEMA: RecordSchema<Status> =
        RecordSchema::enumeration("Status", STATUS_FIELDS, |s| match s {
            Status::Open { .. } => "Open",
            Status::Closed { .. } => "Closed",
        });
    static CARD_STATUS: Field<Card, Status> =
        Field::new("status", &STATUS_SCHEMA, |c| Some(&mut c.status));
    static OPTIONAL_STRING: OptionSchema<String> = OptionSchema::new("Option<String>", &STRING);
    static CARD_NOTE: Field<Card, Option<String>> =
        Field::new("note", &OPTIONAL_STRING, |c| Some(&mut c.note));
    static CARD_FIELDS: &[&dyn FieldSchema] = &[
        &CARD_ID,
        &CARD_PAYLOAD,
        &CARD_TAGS,
        &CARD_STATUS,
        &CARD_NOTE,
    ];
    static CARD_SCHEMA: RecordSchema<Card> = RecordSchema::new("Card", CARD_FIELDS);
    static TAGS_SCHEMA: VecSchema<String> = VecSchema::new("Vec<String>", &STRING);
    impl ValueShape for Card {
        fn schema() -> &'static dyn Shape {
            &CARD_SCHEMA
        }
    }

    impl Card {
        fn fields() -> CardFields {
            CardFields {
                id: Path::new("id", |c| &c.id, |c| &mut c.id),
                payload: Path::new("payload", |c| &c.payload, |c| &mut c.payload),
                _status: Path::new("status", |c| &c.status, |c| &mut c.status),
            }
        }
    }
    struct CardFields {
        id: Path<Card, u32>,
        payload: Path<Card, Payload>,
        _status: Path<Card, Status>,
    }
    impl Payload {
        fn fields() -> PayloadFields {
            PayloadFields {
                text: Path::new("text", |p| &p.text, |p| &mut p.text),
            }
        }
    }
    struct PayloadFields {
        text: Path<Payload, String>,
    }

    fn status_owner() -> VariantPath<Status, String> {
        VariantPath::new(
            "Open",
            "owner",
            |status| match status {
                Status::Open { owner } => Some(owner),
                _ => None,
            },
            |status| match status {
                Status::Open { owner } => Some(owner),
                _ => None,
            },
        )
    }
    fn card_label(card: &Card, prefix: String) -> String {
        format!("{prefix}{}", card.id)
    }
    fn card() -> Card {
        Card {
            id: 7,
            payload: Payload {
                text: "before".into(),
            },
            tags: vec!["one".into(), "two".into()],
            status: Status::Open {
                owner: "Ada".into(),
            },
            note: Some("draft".into()),
        }
    }

    #[test]
    fn typed_nested_paths_and_selector_edit() {
        let path = Card::fields().payload.then(Payload::fields().text);
        let mut c = card();
        assert_eq!(path.get(&c), "before");
        *path.get_mut(&mut c) = "after".into();
        let mut erased: Box<dyn Any> = Box::new(c);
        assert!(
            query::<Card>()
                .where_field(Card::fields().id, 7)
                .edit(erased.as_mut(), |id| *id += 1)
        );
        assert!(
            !query::<Card>()
                .where_field(Card::fields().id, 7)
                .edit(erased.as_mut(), |id| *id += 1)
        );
        let c = erased.downcast_ref::<Card>().unwrap();
        assert_eq!(c.id, 8);
        assert_eq!(path.get(c), "after");
    }

    #[test]
    fn dynamic_named_recursive_enum_and_container_access() {
        let mut c = card();
        let mut root = DynValue::new(&mut c);
        assert_eq!(root.shape().name(), "Card");
        {
            let mut p = root.field("payload").unwrap();
            let mut text = p.field("text").unwrap();
            *text.downcast_mut::<String>().unwrap() = "dynamic".into();
        }
        {
            let mut tags = root.field("tags").unwrap();
            let mut tag = tags.index(1).unwrap();
            tag.downcast_mut::<String>().unwrap().push('!');
        }
        {
            let mut note = root.field("note").unwrap();
            assert_eq!(note.variant(), Some("Some"));
            let mut payload = note.index(0).unwrap();
            payload.downcast_mut::<String>().unwrap().push_str(" note");
        }
        {
            let mut status = root.field("status").unwrap();
            assert_eq!(status.variant(), Some("Open"));
            status
                .field("owner")
                .unwrap()
                .downcast_mut::<String>()
                .unwrap()
                .push_str(" Lovelace");
        }
        drop(root);
        assert_eq!(c.payload.text, "dynamic");
        assert_eq!(c.tags[1], "two!");
        assert_eq!(c.note.as_deref(), Some("draft note"));
        assert_eq!(
            c.status,
            Status::Open {
                owner: "Ada Lovelace".into()
            }
        );
    }

    #[test]
    fn structural_visitor_walks_borrowed_nodes_without_aliasing() {
        let mut c = card();
        let mut root = DynValue::new(&mut c);
        let mut visits = 0;
        root.walk_mut(|node| {
            visits += 1;
            if let Some(text) = node.downcast_mut::<String>() {
                text.push('!');
            }
        });
        drop(root);
        assert!(visits >= 10);
        assert_eq!(c.payload.text, "before!");
        assert_eq!(c.tags, ["one!", "two!"]);
    }

    #[test]
    fn variant_path_is_typed_and_checked() {
        let path = status_owner();
        let mut open = Status::Open {
            owner: "Ada".into(),
        };
        let closed = Status::Closed {
            reason: "done".into(),
        };
        assert_eq!(path.get(&open).map(String::as_str), Some("Ada"));
        path.get_mut(&mut open).unwrap().push_str(" Lovelace");
        assert_eq!(path.get(&closed), None);
        assert_eq!(
            open,
            Status::Open {
                owner: "Ada Lovelace".into()
            }
        );
    }

    #[test]
    fn typed_method_path_is_callable_without_erasure() {
        let method = MethodPath::<Card, String, String>::new("label", card_label);
        assert_eq!(method.call(&card(), "card-".into()), "card-7");
    }

    #[test]
    fn dynamic_inactive_enum_field_is_absent() {
        let mut c = card();
        c.status = Status::Closed {
            reason: "done".into(),
        };
        let mut root = DynValue::new(&mut c);
        let mut status = root.field("status").unwrap();
        assert_eq!(status.variant(), Some("Closed"));
        assert!(status.field("owner").is_none());
        let mut note = root.field("note").unwrap();
        assert_eq!(note.variant(), Some("Some"));
        assert!(note.index(1).is_none());
    }
}
