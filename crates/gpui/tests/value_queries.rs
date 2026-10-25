use gpui::{
    App, InteractiveElement, IntoElement, ParentElement, Pixels, RenderOnce, Select,
    SelectableElement, Styled, TestAppContext, Window, div, px,
    reflection::{TypedPath, Value, ValueMut},
    size,
};

// The ordinary component API needs no conversion or reflection attributes.
struct PlainCard(Pixels, &'static str);

trait WidthView {
    fn width(&mut self) -> &mut Pixels;
}
impl WidthView for PlainCard {
    fn width(&mut self) -> &mut Pixels {
        &mut self.0
    }
}

impl RenderOnce for PlainCard {
    fn render(self, _: &mut Window, _: &mut App) -> impl IntoElement {
        let name = self.1;
        div()
            .w(self.0)
            .h(px(8.))
            .debug_selector(move || name.into())
    }
}

struct PlainView(Pixels);
impl gpui::View for PlainView {
    fn entity_id(&self) -> Option<gpui::EntityId> {
        None
    }
    fn render(self, _: &mut Window, _: &mut App) -> impl IntoElement {
        PlainCard(self.0, "custom-view")
    }
}

#[gpui::reflect]
mod model {
    use gpui::RenderOnce as AuthoredComponent;
    use gpui::{
        App, Div, InteractiveElement, IntoElement, Pixels, RenderOnce, Styled, Window, div, px,
    };

    pub struct Details {
        pub title: String,
        pub width: Pixels,
    }

    pub struct BorrowedDetails<'a> {
        pub text: &'a str,
    }
    pub struct BorrowedOwner<'a> {
        pub details: BorrowedDetails<'a>,
    }

    pub struct Card {
        pub details: Details,
        pub items: Vec<Details>,
        pub optional: Option<Details>,
        pub state: State,
        secret: u32,
        #[cfg(any())]
        pub absent: String,
    }

    impl Card {
        fn private_method(&self) -> u32 {
            self.secret
        }

        /// # Safety
        /// `value` must point to a readable initialized `u32`.
        pub unsafe fn read(&self, value: *const u32) -> u32 {
            unsafe { *value }
        }

        pub fn new(title: &str) -> Self {
            Self {
                details: Details {
                    title: title.into(),
                    width: px(8.),
                },
                items: vec![Details {
                    title: "item".into(),
                    width: px(8.),
                }],
                optional: Some(Details {
                    title: "optional".into(),
                    width: px(8.),
                }),
                state: State::Text {
                    value: "state".into(),
                },
                secret: 42,
            }
        }

        pub fn title(&self) -> &str {
            &self.details.title
        }
        pub fn width(&mut self, width: Pixels) {
            self.details.width = width;
        }
        pub fn apply<T>(&self, f: impl FnOnce(&str) -> T) -> T {
            f(self.title())
        }

        #[cfg(any())]
        pub fn absent_method(&self) -> &str {
            &self.absent
        }
    }

    #[cfg(any())]
    impl Card {
        pub fn absent_impl(&self) -> usize {
            0
        }
    }

    impl RenderOnce for Card {
        fn render(self, _: &mut Window, _: &mut App) -> impl IntoElement {
            let title = self.details.title;
            div()
                .w(self.details.width)
                .h(px(8.))
                .debug_selector(move || title.clone().into())
        }
    }

    pub enum State {
        Text {
            value: String,
        },
        Count {
            value: u32,
        },
        Empty,
        #[cfg(any())]
        Absent {
            value: bool,
        },
    }

    pub struct Generic<T> {
        pub value: T,
    }

    impl<T: Clone> Generic<T> {
        pub fn duplicate(&self) -> T {
            self.value.clone()
        }
    }

    impl Generic<u32> {
        pub fn specialized(&self) -> usize {
            self.value as usize
        }
    }
    impl<U> Generic<Vec<U>> {
        pub fn specialized(&self) -> usize {
            self.value.len()
        }
    }

    pub trait Titled {
        fn title(&self) -> &str;
        fn rename(&mut self, title: &str);
    }

    pub trait QueryRole {
        fn set_query_width(&mut self, width: Pixels);
    }

    #[derive(gpui::Element)]
    pub struct DerivedRoleElement {
        #[element]
        pub(super) inner: Div,
    }

    impl QueryRole for DerivedRoleElement {
        fn set_query_width(&mut self, width: Pixels) {
            self.inner.style().size.width = Some(width.into());
        }
    }

    #[derive(gpui::Element)]
    pub struct GenericDerivedRoleElement<T> {
        #[element]
        pub(super) inner: Div,
        pub(super) value: T,
    }

    impl<T> QueryRole for GenericDerivedRoleElement<T> {
        fn set_query_width(&mut self, width: Pixels) {
            self.inner.style().size.width = Some(width.into());
        }
    }

    pub struct AliasedGenericRoleComponent<T> {
        pub value: T,
        pub width: Pixels,
    }

    impl<T> QueryRole for AliasedGenericRoleComponent<T> {
        fn set_query_width(&mut self, width: Pixels) {
            self.width = width;
        }
    }

    impl<T: 'static> AuthoredComponent for AliasedGenericRoleComponent<T> {
        fn render(self, _: &mut Window, _: &mut App) -> impl IntoElement {
            let _ = self.value;
            div()
                .w(self.width)
                .h(px(8.))
                .debug_selector(|| "aliased generic role".into())
        }
    }

    impl Titled for Card {
        fn title(&self) -> &str {
            self.title()
        }
        fn rename(&mut self, title: &str) {
            self.details.title = title.into();
        }
    }

    pub trait Payload {
        type Item;
        fn payload(&mut self) -> &mut Self::Item;
    }

    impl Payload for Card {
        type Item = String;
        fn payload(&mut self) -> &mut Self::Item {
            &mut self.details.title
        }
    }

    pub trait ParentRole {
        type Name;
        fn name(&self) -> &Self::Name;
    }
    pub trait ChildRole: ParentRole {
        fn rename(&mut self, name: &str);
    }
    impl ParentRole for Card {
        type Name = String;
        fn name(&self) -> &String {
            &self.details.title
        }
    }
    impl ChildRole for Card {
        fn rename(&mut self, name: &str) {
            self.details.title = name.into();
        }
    }
    // These methods are valid native Rust but cannot participate in dyn dispatch.
    pub trait Factory {
        fn make(&self) -> impl Copy;
    }
    impl Factory for Card {
        fn make(&self) -> impl Copy {
            self.secret
        }
    }
    pub trait ScalarRole {
        fn scalar(&self) -> u32;
        fn generic<T>(&self, value: T) -> T
        where
            Self: Sized,
        {
            value
        }
        async fn asynchronous(&self)
        where
            Self: Sized,
        {
        }
    }
    impl ScalarRole for Card {
        fn scalar(&self) -> u32 {
            self.secret
        }
    }

    pub struct ExistingNames {
        pub title: String,
    }
    impl ExistingNames {
        pub fn fields(&self) -> &str {
            &self.title
        }
        pub fn methods(&self) -> usize {
            self.title.len()
        }
    }

    // Generic associated types remain ordinary Rust when selecting a concrete value.
    pub trait Borrowed {
        type Text<'a>
        where
            Self: 'a;
        fn text(&self) -> Self::Text<'_>;
    }

    impl Borrowed for Card {
        type Text<'a> = &'a str;
        fn text(&self) -> Self::Text<'_> {
            self.title()
        }
    }
}

#[test]
fn one_opt_in_describes_native_rust_fields_variants_and_methods() {
    use model::{Card, Details, Generic, State};
    let mut card = Card::new("card");
    let title = Card::fields().details.then(Details::fields().title);
    *ValueMut::new(&mut card).at(title).unwrap() = "typed".into();
    assert_eq!(Card::methods().title.call(&card), "typed");
    assert_eq!(Card::methods().apply.call(&card, str::len), 5);
    Card::methods().width.call(&mut card, px(24.));
    assert_eq!(card.details.width, px(24.));

    let mut value = ValueMut::new(&mut card);
    value
        .field("items")
        .unwrap()
        .index(0)
        .unwrap()
        .field("title")
        .unwrap()
        .downcast_mut::<String>()
        .unwrap()
        .push('!');
    value
        .field("optional")
        .unwrap()
        .index(0)
        .unwrap()
        .field("title")
        .unwrap()
        .downcast_mut::<String>()
        .unwrap()
        .push('!');
    assert!(value.field("secret").is_none());
    assert!(value.field("absent").is_none());
    assert_eq!(card.items[0].title, "item!");
    assert_eq!(card.optional.as_ref().unwrap().title, "optional!");

    let mut state = State::Count { value: 7 };
    assert_eq!(Value::new(&state).variant(), Some("Count"));
    *ValueMut::new(&mut state)
        .field("value")
        .unwrap()
        .downcast_mut::<u32>()
        .unwrap() = 11;
    assert!(matches!(state, State::Count { value: 11 }));
    assert!(State::variant_fields().text.value.get(&state).is_none());
    let _ = State::Empty;

    let generic = Generic {
        value: String::from("generic"),
    };
    assert_eq!(
        Generic::<String>::methods().duplicate.call(&generic),
        "generic"
    );
    assert_eq!(
        Generic::<u32>::methods()
            .specialized
            .call(&Generic { value: 7 }),
        7
    );
    assert_eq!(
        Generic::<Vec<u8>>::methods()
            .specialized
            .call(&Generic { value: vec![1, 2] }),
        2
    );
    assert_eq!(
        Value::new(&generic)
            .at(Generic::<String>::fields().value)
            .unwrap(),
        "generic"
    );

    let mut value = ValueMut::new(&mut card);
    value
        .cast_mut::<dyn model::Titled>()
        .unwrap()
        .rename("role");
    assert_eq!(value.downcast_ref::<Card>().unwrap().title(), "role");
}

#[test]
fn generated_paths_compose_through_borrowed_types() {
    use model::{BorrowedDetails, BorrowedOwner};
    let before = String::from("borrowed before");
    let after = String::from("borrowed after");
    let mut owner = BorrowedOwner {
        details: BorrowedDetails { text: &before },
    };
    let path = BorrowedOwner::fields()
        .details
        .then(BorrowedDetails::fields().text);
    assert_eq!(*path.get(&owner).unwrap(), before);
    *path.get_mut(&mut owner).unwrap() = &after;
    assert_eq!(*path.get(&owner).unwrap(), after);
}

#[test]
fn descriptor_traits_preserve_user_methods_and_native_dyn_rules() {
    use gpui::reflection::{fields, methods};
    use model::{Card, ChildRole, ExistingNames, ScalarRole};
    let mut existing = ExistingNames {
        title: "native".into(),
    };
    fields::<ExistingNames>()
        .title
        .get_mut(&mut existing)
        .push('!');
    assert_eq!(existing.fields(), "native!");
    assert_eq!(methods::<ExistingNames>().methods.call(&existing), 7);

    let mut card = Card::new("parent");
    let mut value = ValueMut::new(&mut card);
    let child = value.cast_mut::<dyn ChildRole<Name = String>>().unwrap();
    assert_eq!(child.name(), "parent");
    child.rename("child");
    assert_eq!(value.cast_mut::<dyn ScalarRole>().unwrap().scalar(), 42);
    let number = 17;
    // SAFETY: `number` is a live initialized u32.
    assert_eq!(unsafe { Card::methods().read.call(&card, &number) }, 17);
}

#[gpui::test]
fn native_callbacks_and_field_selectors_edit_components_before_render(cx: &mut TestAppContext) {
    use model::{Borrowed, Card, Details};
    let visual = cx.add_empty_window();
    visual.draw(Default::default(), size(px(300.), px(100.)), |_, _| {
        div()
            .select(Select::children().class("plain"), |card: &mut PlainCard| {
                card.0 = px(16.)
            })
            .select(Select::children().class("native"), |card: &mut Card| {
                assert_eq!(card.text(), "native");
                card.width(px(24.));
            })
            .select(
                Select::children()
                    .class("path")
                    .field(Card::fields().details.then(Details::fields().width)),
                |width| *width = px(32.),
            )
            .select(
                Select::children().where_field(
                    Card::fields().details.then(Details::fields().title),
                    |title| title == "filtered",
                ),
                |card| card.width(px(40.)),
            )
            .inspect(Select::children().class("dynamic"), |mut value| {
                *value
                    .field("details")
                    .unwrap()
                    .field("width")
                    .unwrap()
                    .downcast_mut::<Pixels>()
                    .unwrap() = px(48.);
            })
            .select(
                Select::children()
                    .class("role")
                    .where_field(
                        Card::fields().details.then(Details::fields().title),
                        |title| title == "role",
                    )
                    .role::<dyn model::Titled>(),
                |label| {
                    label.rename("role-edited");
                },
            )
            .child(PlainCard(px(8.), "plain").class("plain"))
            .child(Card::new("native").class("native"))
            .child(Card::new("path").class("path"))
            .child(Card::new("filtered"))
            .child(Card::new("dynamic").class("dynamic"))
            .child(Card::new("role").class("role"))
            .select(Select::children().class("styled").style(), |style| {
                style.size.width = Some(px(56.).into());
            })
            .child(
                div()
                    .size(px(8.))
                    .class("styled")
                    .debug_selector(|| "styled".into()),
            )
            .select(
                Select::children()
                    .class("view")
                    .view(|card: &mut PlainCard| card as &mut dyn WidthView),
                |view| *view.width() = px(64.),
            )
            .child(PlainCard(px(8.), "view").class("view"))
            .select(
                Select::children()
                    .class("custom-view")
                    .component::<PlainView>(),
                |view| {
                    view.0 = px(72.);
                },
            )
            .child(PlainView(px(8.)).class("custom-view"))
            .into_any_element()
    });
    for (name, width) in [
        ("plain", 16.),
        ("custom-view", 72.),
        ("native", 24.),
        ("path", 32.),
        ("filtered", 40.),
        ("dynamic", 48.),
    ] {
        assert_eq!(visual.debug_bounds(name).unwrap().size.width, px(width));
    }
    assert_eq!(
        visual.debug_bounds("role-edited").unwrap().size.width,
        px(8.)
    );
    assert_eq!(visual.debug_bounds("styled").unwrap().size.width, px(56.));
    assert_eq!(visual.debug_bounds("view").unwrap().size.width, px(64.));
}

#[gpui::test]
fn native_role_selection_discovers_derived_element_schemas_before_use(cx: &mut TestAppContext) {
    let visual = cx.add_empty_window();
    visual.draw(Default::default(), size(px(100.), px(100.)), |_, _| {
        div()
            .select(
                Select::children()
                    .class("aliased-generic-role")
                    .role::<dyn model::QueryRole>(),
                |role| role.set_query_width(px(40.)),
            )
            .select(
                Select::children()
                    .class("derived-role")
                    .role::<dyn model::QueryRole>(),
                |role| role.set_query_width(px(24.)),
            )
            .select(
                Select::children()
                    .class("generic-derived-role")
                    .role::<dyn model::QueryRole>(),
                |role| role.set_query_width(px(32.)),
            )
            .child(
                model::DerivedRoleElement {
                    inner: div()
                        .w(px(8.))
                        .h(px(8.))
                        .debug_selector(|| "derived role".into()),
                }
                .class("derived-role"),
            )
            .child(
                model::AliasedGenericRoleComponent {
                    value: 11u32,
                    width: px(8.),
                }
                .class("aliased-generic-role"),
            )
            .child(
                model::GenericDerivedRoleElement {
                    inner: div()
                        .w(px(8.))
                        .h(px(8.))
                        .debug_selector(|| "generic derived role".into()),
                    value: 7u32,
                }
                .class("generic-derived-role"),
            )
            .into_any_element()
    });

    assert_eq!(
        visual.debug_bounds("derived role").unwrap().size.width,
        px(24.)
    );
    assert_eq!(
        visual
            .debug_bounds("aliased generic role")
            .unwrap()
            .size
            .width,
        px(40.)
    );
    assert_eq!(
        visual
            .debug_bounds("generic derived role")
            .unwrap()
            .size
            .width,
        px(32.)
    );
}

#[cfg(value_query_escape)]
fn selected_borrow_cannot_escape() {
    let mut saved = None;
    let _ = div().select(Select::children(), move |card: &mut PlainCard| {
        saved = Some(card)
    });
}

#[cfg(value_query_wrong_field)]
fn selected_field_has_its_exact_type() {
    let _ = div().select(
        Select::children().field(model::Details::fields().title),
        |_: &mut u32| {},
    );
}

#[cfg(value_query_wrong_root)]
fn field_filters_preserve_the_root_type() {
    let _ = Select::children()
        .where_field(model::Card::fields().details, |_| true)
        .where_field(model::Details::fields().title, |_| true);
}

#[cfg(value_query_alias)]
fn field_borrows_cannot_alias() {
    let mut card = model::Card::new("alias");
    let mut value = ValueMut::new(&mut card);
    let first = value.field("details").unwrap();
    let second = value.field("details").unwrap();
    drop((first, second));
}

#[cfg(value_query_unsafe_method)]
fn method_handles_preserve_unsafe() {
    let card = model::Card::new("unsafe");
    let _ = model::Card::methods().read.call(&card, std::ptr::null());
}

#[cfg(value_query_borrowed_escape)]
fn composed_borrow_cannot_escape<'a>(owner: &model::BorrowedOwner<'a>) -> &'static &'a str {
    model::BorrowedOwner::fields()
        .details
        .then(model::BorrowedDetails::fields().text)
        .get(owner)
        .unwrap()
}

#[cfg(value_query_borrowed_alias)]
fn composed_borrows_cannot_alias(owner: &mut model::BorrowedOwner<'_>) {
    let path = model::BorrowedOwner::fields()
        .details
        .then(model::BorrowedDetails::fields().text);
    let first = path.get_mut(owner).unwrap();
    let second = path.get_mut(owner).unwrap();
    drop((first, second));
}

#[cfg(value_schema_wrong_field_root)]
fn schema_fields_retain_their_root_proof() {
    let _ = gpui::reflection::Schema::<model::Details>::new(
        vec![
            model::Card::fields()
                .details
                .into_schema(gpui::reflection::Type::of::<model::Details>),
        ],
        None,
    );
}

#[cfg(value_schema_wrong_role_root)]
fn schema_roles_retain_their_root_proof() {
    let role = gpui::reflection::Role::<model::Card, dyn model::Titled>::new(|card| card);
    let _ = gpui::reflection::Schema::<model::Details>::with_roles(
        vec![],
        None,
        vec![role.into_schema()],
    );
}

#[cfg(value_schema_wrong_describe_root)]
fn describe_retains_its_root_proof() {
    struct Wrong;
    impl gpui::reflection::Describe for Wrong {
        fn build_type() -> gpui::reflection::Schema<Self> {
            gpui::reflection::Schema::<model::Details>::new(vec![], None)
        }
    }
}

#[cfg(value_query_private_method)]
fn descriptors_preserve_method_privacy() {
    let card = model::Card::new("private");
    let _ = model::Card::methods().private_method.call(&card);
}
