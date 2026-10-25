use super::*;
use crate::reflection::test_fixtures::{self, TestComponent, TestElement, TestValue};
use crate::{
    AnyElement, App, AppContext, Bounds, Context, Div, Element, ElementId, Empty, GlobalElementId,
    InspectorElementId, InteractiveElement, IntoElement, LayoutId, MouseButton, ParentElement,
    Pixels, Render, Select, SelectableElement, StatefulInteractiveElement, StyleRefinement, Styled,
    TestApp, Window, div, hsla, point, px, rgb,
};
use std::{
    any::{Any, TypeId},
    cell::{Cell, RefCell},
    panic,
    rc::Rc,
    sync::{
        Barrier, LazyLock,
        atomic::{AtomicUsize, Ordering},
    },
    thread,
};

const TEXT_LABEL: &str = "body";

#[test]
fn tuple_reflections_compose_groups_and_append_into_one_buffer() {
    let a = ReflectedTrait::new("a", TypeId::of::<u8>);
    let b = ReflectedTrait::new("b", TypeId::of::<u16>);
    let c = ReflectedTrait::new("c", TypeId::of::<u32>);
    let d = ReflectedTrait::new("d", TypeId::of::<u64>);
    let e = ReflectedTrait::new("e", TypeId::of::<i8>);
    let f = ReflectedTrait::new("f", TypeId::of::<i16>);
    let g = ReflectedTrait::new("g", TypeId::of::<i32>);
    let h = ReflectedTrait::new("h", TypeId::of::<i64>);

    assert_eq!((a, b).reflected_requirements().len(), 2);
    assert_eq!((a, b, c).reflected_requirements().len(), 3);
    assert_eq!((a, b, c, d).reflected_requirements().len(), 4);
    assert_eq!((a, b, c, d, e).reflected_requirements().len(), 5);
    assert_eq!((a, b, c, d, e, f).reflected_requirements().len(), 6);
    assert_eq!((a, b, c, d, e, f, g).reflected_requirements().len(), 7);
    assert_eq!((a, b, c, d, e, f, g, h).reflected_requirements().len(), 8);
}

#[test]
fn builtin_access_flags_merge_as_a_lattice() {
    type StyledInteractive =
        <Access<On, Off, Off, Off> as AccessUnion<Access<Off, On, Off, Off>>>::Output;
    type WithParent = <StyledInteractive as AccessUnion<Access<Off, Off, Off, On>>>::Output;

    fn has_styled<Access: HasStyled>() {}
    fn has_interactive<Access: HasInteractive>() {}
    fn has_parent<Access: HasParent>() {}

    has_styled::<WithParent>();
    has_interactive::<WithParent>();
    has_parent::<WithParent>();
}

mod text {
    #[gpui_macros::reflect_trait]
    pub trait Text {
        fn read<'element>(&'element self, label: &str) -> &'element str;
        fn edit(&mut self, label: &str) -> &mut String;
        fn append(&mut self, characters: impl IntoIterator<Item = char>);
        fn formatter(&'_ self) -> fn(&str) -> &str;

        fn content(&self) -> &str {
            self.read("body")
        }

        fn revise(&mut self) -> &mut String {
            let content = self.edit("body");
            content.push('?');

            content
        }

        #[reflect(wrapper_default)]
        fn suffix(&mut self, suffix: impl AsRef<str>) {
            self.edit("body").push_str(suffix.as_ref());
        }

        #[reflect(wrapper_default)]
        fn wrapper_label(&self) -> &'static str {
            "wrapper"
        }

        #[cfg(all())]
        #[cfg_attr(any(), cfg(any()))]
        fn configured(&self) -> &str {
            self.content()
        }

        #[cfg(any())]
        fn unavailable_direct(&self) -> UnavailableType;

        #[cfg_attr(all(), cfg_attr(all(), cfg(any()), allow(dead_code)))]
        fn unavailable_nested(&self) -> UnavailableType {
            unreachable!()
        }

        #[cfg_attr(all(), cfg(any()))]
        fn unavailable(&mut self) -> UnavailableType;
    }
}

mod branches {
    use crate::reflection::tests::text;

    #[gpui_macros::reflect_trait]
    pub trait Left: text::Text {
        fn decorate(mut self, suffix: impl AsRef<str>) -> Self
        where
            Self: Sized,
        {
            self.edit("body").push_str(suffix.as_ref());

            self
        }
    }

    #[gpui_macros::reflect_trait]
    pub trait Right: text::Text {}
}

#[gpui_macros::reflect_trait]
trait Composite: branches::Left + branches::Right + crate::Styled + crate::ParentElement {}

#[gpui_macros::reflect_trait(membership)]
trait PaintSource {}

#[derive(gpui_macros::Reflect, Default)]
#[reflect(Composite, text::Text, crate::Styled, PaintSource)]
struct Card {
    text: String,
    calls: Rc<Cell<usize>>,
    style: StyleRefinement,
    children: Vec<AnyElement>,
}

impl text::Text for Card {
    fn read<'element>(&'element self, _label: &str) -> &'element str {
        &self.text
    }

    fn edit(&mut self, _label: &str) -> &mut String {
        self.calls.set(self.calls.get() + 1);

        &mut self.text
    }

    fn append(&mut self, characters: impl IntoIterator<Item = char>) {
        self.text.extend(characters);
    }

    fn formatter(&'_ self) -> fn(&str) -> &str {
        |value| value
    }
}

#[derive(Default)]
struct Panel<State> {
    card: Card,
    text_style: crate::TextStyleRefinement,
    state: State,
}

impl<State: 'static> Reflect for Panel<State> {
    fn build_reflection() -> Vec<ReflectedImplementation<Self>> {
        let mut implementations = Vec::new();
        Composite.__register::<Self>(&mut implementations);
        PaintSource.__register::<Self>(&mut implementations);

        implementations
    }
}

impl PaintSource for Card {}

impl<State> PaintSource for Panel<State> {}

impl<State> text::Text for Panel<State> {
    fn read<'element>(&'element self, label: &str) -> &'element str {
        text::Text::read(&self.card, label)
    }

    fn edit(&mut self, label: &str) -> &mut String {
        text::Text::edit(&mut self.card, label)
    }

    fn append(&mut self, characters: impl IntoIterator<Item = char>) {
        text::Text::append(&mut self.card, characters);
    }

    fn formatter(&'_ self) -> fn(&str) -> &str {
        text::Text::formatter(&self.card)
    }

    fn content(&self) -> &str {
        "panel override"
    }

    fn revise(&mut self) -> &mut String {
        self.card.text.push('!');

        &mut self.card.text
    }

    fn suffix(&mut self, _suffix: impl AsRef<str>) {
        panic!("explicit wrapper defaults must not dispatch concrete overrides");
    }

    fn wrapper_label(&self) -> &'static str {
        "concrete"
    }
}

impl<State> branches::Left for Panel<State> {}

impl<State> branches::Right for Panel<State> {}

impl<State> Composite for Panel<State> {}

impl<State> Styled for Panel<State> {
    fn style(&mut self) -> &mut StyleRefinement {
        &mut self.card.style
    }

    fn text_style(&mut self) -> &mut crate::TextStyleRefinement {
        &mut self.text_style
    }
}

impl<State> ParentElement for Panel<State> {
    fn extend(&mut self, elements: impl IntoIterator<Item = AnyElement>) {
        self.card.children.extend(elements);
    }
}

impl branches::Left for Card {
    fn decorate(mut self, suffix: impl AsRef<str>) -> Self {
        self.text.push_str("concrete builder ");
        self.text.push_str(suffix.as_ref());

        self
    }
}

impl branches::Right for Card {}

impl Composite for Card {}

impl Styled for Card {
    fn style(&mut self) -> &mut StyleRefinement {
        &mut self.style
    }
}

impl ParentElement for Card {
    fn extend(&mut self, elements: impl IntoIterator<Item = AnyElement>) {
        self.children.extend(elements);
    }
}

macro_rules! element_impl {
        ($name:ty $(, [$($generics:tt)*])? $(, reflection $reflection:expr)?) => {
            impl $(<$($generics)*>)? IntoElement for $name {
                type Element = Self;

                fn into_element(self) -> Self {
                    self
                }
            }

            impl $(<$($generics)*>)? Element for $name {
                type RequestLayoutState = ();
                type PrepaintState = ();

                $(fn reflection(&self) -> &'static ElementReflection {
                    $reflection
                })?

                fn id(&self) -> Option<ElementId> {
                    None
                }

                fn source_location(&self) -> Option<&'static panic::Location<'static>> {
                    None
                }

                fn request_layout(
                    &mut self,
                    _id: Option<&GlobalElementId>,
                    _inspector_id: Option<&InspectorElementId>,
                    _window: &mut Window,
                    _cx: &mut App,
                ) -> (LayoutId, ()) {
                    unreachable!()
                }

                fn prepaint(
                    &mut self,
                    _id: Option<&GlobalElementId>,
                    _inspector_id: Option<&InspectorElementId>,
                    _bounds: Bounds<Pixels>,
                    _request_layout: &mut (),
                    _window: &mut Window,
                    _cx: &mut App,
                ) {
                    unreachable!()
                }

                fn paint(
                    &mut self,
                    _id: Option<&GlobalElementId>,
                    _inspector_id: Option<&InspectorElementId>,
                    _bounds: Bounds<Pixels>,
                    _request_layout: &mut (),
                    _prepaint: &mut (),
                    _window: &mut Window,
                    _cx: &mut App,
                ) {
                    unreachable!()
                }
            }
        };
    }

element_impl!(Card);
element_impl!(Panel<State>, [State: 'static], reflection <Self as Reflect>::reflection());

fn card() -> Card {
    Card {
        text: "hello".into(),
        ..Default::default()
    }
}

fn admit<Traits>(element: AnyElement, traits: Traits) -> Option<ReflectedElement<Traits::Group>>
where
    Traits: ReflectedTraits,
{
    let requirements = traits.reflected_requirements();

    if !requirements
        .iter()
        .all(|requirement| element.reflection().satisfies(*requirement))
    {
        return None;
    }

    Some(ReflectedElement::new(element))
}

fn transform<Traits>(element: AnyElement, traits: Traits) -> AnyElement
where
    Traits: ReflectedTraits,
    ReflectedElement<Traits::Group>: Composite,
{
    let mut element = admit(element, traits).unwrap();
    let label = TEXT_LABEL;

    assert_eq!(text::Text::read(&element, label), "hello");
    text::Text::edit(&mut element, label).push(' ');

    let borrowed = String::from("world");
    let formatter = text::Text::formatter(&element);

    assert_eq!(formatter(&borrowed), "world");
    text::Text::append(&mut element, borrowed.chars());

    branches::Left::decorate(element, "!")
        .bg(rgb(0x123456))
        .invisible()
        .child(Empty)
        .into_any_element()
}

#[test]
fn forwards_methods_and_owned_builders_through_inherited_groups() {
    let concrete = branches::Left::decorate(card(), "!");

    assert_eq!(concrete.text, "helloconcrete builder !");

    for combined in [false, true] {
        let card = card();
        let calls = card.calls.clone();
        let element = card.into_any_element();

        let mut element = if combined {
            transform(
                element,
                trait_set![
                    Composite,
                    text::Text,
                    branches::Left,
                    crate::Styled,
                    crate::ParentElement,
                    Composite,
                ],
            )
        } else {
            transform(element, Composite)
        };

        let card = element.downcast_mut::<Card>().unwrap();

        assert_eq!(card.text, "hello world!");
        assert_eq!(calls.get(), 2);
        assert!(card.style.background.is_some());
        assert_eq!(card.style.visibility, Some(crate::Visibility::Hidden));
        assert_eq!(card.children.len(), 1);
    }
}

#[test]
fn dispatches_defaults_and_overrides_through_one_diamond_group() {
    let color = hsla(0.5, 0.5, 0.5, 1.0);

    for (overrides, content, revised) in [
        (false, "hello", "hello?"),
        (true, "panel override", "hello!"),
    ] {
        let original = if overrides {
            Panel {
                card: card(),
                state: String::from("manual"),
                ..Default::default()
            }
            .into_any_element()
        } else {
            card().into_any_element()
        };

        let mut element = admit(
            original,
            trait_set![PaintSource, Composite, text::Text, PaintSource, Composite],
        )
        .unwrap();

        assert_eq!(text::Text::content(&element), content);
        assert_eq!(text::Text::configured(&element), content);
        assert_eq!(text::Text::revise(&mut element), revised);
        assert_eq!(text::Text::wrapper_label(&element), "wrapper");
        text::Text::suffix(&mut element, " suffix");

        let mut element = element.text_color(color).into_any_element();
        let (card, text_color) = if overrides {
            let panel = element.downcast_mut::<Panel<String>>().unwrap();

            assert_eq!(panel.state, "manual");

            (&panel.card, panel.text_style.color)
        } else {
            let card = element.downcast_mut::<Card>().unwrap();

            (&*card, card.style.text.color)
        };

        assert_eq!(card.text, format!("{revised} suffix"));
        assert_eq!(text_color, Some(color));
    }
}

#[test]
fn records_inheritance_and_deduplicates_concrete_implementations() {
    let descriptor = ReflectionToken::reflected_trait(Composite);
    let parents = (descriptor.supertraits)();

    assert_eq!(parents.len(), 4);
    assert_eq!(
        (parents[0].supertraits)(),
        &[ReflectionToken::reflected_trait(text::Text)],
    );
    assert_eq!(
        (parents[1].supertraits)(),
        &[ReflectionToken::reflected_trait(text::Text)],
    );

    let traits = Card::reflected_traits();
    assert_eq!(traits.len(), 7);
    assert!(traits.contains(&descriptor));
    assert!(traits.contains(&ReflectionToken::reflected_trait(text::Text)));

    let metadata = <Card as Reflect>::reflection();
    let requirements = Composite.reflected_requirements();
    let combined = trait_set![Composite, text::Text].reflected_requirements();

    assert_eq!(requirements.len(), 6);
    assert_eq!(combined.len(), 6);
    assert!(
        requirements
            .iter()
            .all(|requirement| requirement.is_callable() && metadata.satisfies(*requirement))
    );
    assert!(
        combined
            .iter()
            .all(|requirement| requirements.contains(requirement))
    );

    let mixed = trait_set![PaintSource, Composite, text::Text, PaintSource, Composite]
        .reflected_requirements();

    assert_eq!(mixed.len(), 7);
    assert_eq!(mixed[0], PaintSource.requirement());
    assert!(!mixed[0].is_callable());
    assert!(
        mixed
            .iter()
            .all(|requirement| metadata.satisfies(*requirement))
    );
    assert_eq!(PaintSource.requirements(), vec![PaintSource.requirement()]);

    for wrong_table in [false, true] {
        let mut implementations = <Card as Reflect>::build_reflection();
        let inherited = implementations
            .iter_mut()
            .find(|implementation| implementation.descriptor == text::Text.reflected_trait())
            .unwrap();
        inherited.methods = wrong_table.then(|| Box::new(123usize) as Box<dyn Any + Send + Sync>);

        let incomplete = ElementReflection::build::<Card>(implementations);

        assert!(incomplete.has_adapter(Composite));
        assert!(incomplete.satisfies(PaintSource.requirement()));
        assert!(!incomplete.has_adapter(text::Text));
        assert!(
            !mixed
                .iter()
                .all(|requirement| incomplete.satisfies(*requirement))
        );
    }
}

#[test]
fn transparent_erasure_preserves_concrete_identity() {
    fn reflected<Token: ReflectionToken>(
        element: AnyElement,
        _token: Token,
    ) -> ReflectedElement<Token::Group> {
        ReflectedElement::new(element)
    }

    for route in 0..7 {
        let mut element = div().id("original").child(Empty).into_any_element();
        let metadata = element.reflection();
        let original = element.downcast_mut::<Div>().unwrap() as *mut Div;
        let reflected = reflected(element, crate::InteractiveElement);
        let mut element = match route {
            0 => reflected.into_any_element(),
            1 => reflected.into_any(),
            2 => reflected.into_element().into_any(),
            3 => reflected.id("renamed").into_any_element(),
            4 => reflected.id("renamed").into_any(),
            5 => reflected.id("renamed").into_element().into_any(),
            _route => reflected.into_any_element().into_any(),
        };

        let expected_id = if (3..6).contains(&route) {
            "renamed"
        } else {
            "original"
        };

        let concrete = element.downcast_mut::<Div>().unwrap();

        assert_eq!(concrete as *mut Div, original);
        assert_eq!(Element::id(concrete), Some(ElementId::from(expected_id)));
        assert_eq!(element.reflected_type_id(), TypeId::of::<Div>());
        assert!(std::ptr::eq(metadata, element.reflection()));
    }
}

struct ComponentView {
    use_component: bool,
    hovers: Rc<RefCell<Vec<bool>>>,
    clicks: Rc<Cell<usize>>,
}

fn configure_component<Target>(
    element: Target,
    hovers: Rc<RefCell<Vec<bool>>>,
    clicks: Rc<Cell<usize>>,
) -> Target
where
    Target: Styled + ParentElement + StatefulInteractiveElement,
{
    let element = element
        .w(px(160.))
        .h(px(80.))
        .bg(rgb(0x123456))
        .role(accesskit::Role::Button)
        .accessibility_id("card")
        .aria_label("Test element")
        .on_hover(move |hovered, _window, _cx| hovers.borrow_mut().push(*hovered))
        .on_click(move |_event, _window, _cx| clicks.set(clicks.get() + 1))
        .child(
            div()
                .id("child")
                .size(px(24.))
                .role(accesskit::Role::Image)
                .aria_label("Child"),
        );

    StatefulInteractiveElement::a11y_synthetic_children(element, |builder| {
        let node_id = builder.synthetic_node_id("payload");
        let mut node = accesskit::Node::new(accesskit::Role::Label);
        node.set_label("Payload");
        assert!(builder.push_child(node_id, node));
    })
}

impl Render for ComponentView {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        let hovers = self.hovers.clone();
        let clicks = self.clicks.clone();

        let element = if self.use_component {
            TestElement::new("card")
                .class("card")
                .map_selected(
                    Select::this().class("card").reflects(trait_set![
                        test_fixtures::TestValue,
                        crate::Styled,
                        crate::ParentElement,
                        crate::StatefulInteractiveElement,
                    ]),
                    move |mut element| {
                        *element.value() = 41;
                        test_fixtures::set_value(&mut element.element, 42);
                        assert_eq!(*element.value(), 42);

                        configure_component(element, hovers.clone(), clicks.clone())
                    },
                )
                .into_any_element()
        } else {
            configure_component(div().id("card"), hovers, clicks).into_any_element()
        };

        div()
            .flex()
            .flex_col()
            .child(element)
            .child(TestComponent::default())
    }
}

#[test]
fn component_selectors_preserve_mutations_state_and_accessibility() {
    let mut app = TestApp::new();
    let hovers = Rc::new(RefCell::new(Vec::new()));
    let clicks = Rc::new(Cell::new(0));
    let mut window = app.open_window({
        let hovers = hovers.clone();
        let clicks = clicks.clone();

        move |_window, _cx| ComponentView {
            use_component: false,
            hovers,
            clicks,
        }
    });
    let handle = window.handle().into();
    app.update(|cx| {
        cx.update_window(handle, |_view, window, cx| {
            window.set_a11y_forced(true);
            window.draw(cx).clear(cx);
        })
        .unwrap();
    });

    let inspect_tree = |window: &Window| {
        let tree = window.a11y_tree().unwrap();
        let node_by_label = |label: &str| {
            tree.nodes
                .iter()
                .find(|(_node_id, node)| node.label() == Some(label))
                .unwrap()
        };
        let (card_id, card) = node_by_label("Test element");
        let (child_id, _child) = node_by_label("Child");
        let (payload_id, _payload) = node_by_label("Payload");

        assert_eq!(card.author_id(), Some("card"));
        assert_eq!(card.role(), accesskit::Role::Button);
        assert_eq!(card.label(), Some("Test element"));
        assert!(card.children().contains(child_id));
        assert!(card.children().contains(payload_id));
        assert_eq!(
            window.a11y_node_bounds(*card_id).unwrap().size,
            crate::size(px(160.), px(80.))
        );
        assert_eq!(
            window.a11y_node_bounds(*child_id).unwrap().size,
            crate::size(px(24.), px(24.))
        );

        (*card_id, *child_id, *payload_id)
    };
    let direct_ids = window.update(|_view, window, _cx| inspect_tree(window));

    window.simulate_mouse_move(point(px(80.), px(40.)));
    assert_eq!(*hovers.borrow(), [true]);

    for use_component in [true, true, false] {
        window.update(|view, _window, cx| {
            view.use_component = use_component;
            cx.notify();
        });
        app.update(|cx| {
            cx.update_window(handle, |_view, window, cx| {
                window.draw(cx).clear(cx);
                assert_eq!(inspect_tree(window), direct_ids);
            })
            .unwrap();
        });
        assert_eq!(*hovers.borrow(), [true]);
        window.simulate_click(point(px(80.), px(40.)), MouseButton::Left);
    }

    assert_eq!(clicks.get(), 3);
    window.simulate_mouse_move(point(px(200.), px(100.)));
    assert_eq!(*hovers.borrow(), [true, false]);
}

#[test]
fn provider_publishes_one_owner_and_recovers_from_initialization_failures() {
    const WORKERS: usize = 8;
    static BARRIER: LazyLock<Barrier> = LazyLock::new(|| Barrier::new(WORKERS));
    static BUILDS: AtomicUsize = AtomicUsize::new(0);
    static DROPS: AtomicUsize = AtomicUsize::new(0);
    static LINKED_BUILDS: AtomicUsize = AtomicUsize::new(0);

    struct Concurrent;
    struct TrackedTable;
    struct Panicking;
    struct Recursive;
    struct Nested;
    struct Conflicting;
    struct Linked;
    struct WrongLinked;
    struct DemandOnly;

    impl Reflect for Linked {
        fn build_reflection() -> Vec<ReflectedImplementation<Self>> {
            LINKED_BUILDS.fetch_add(1, Ordering::SeqCst);

            Vec::new()
        }
    }

    inventory::submit! {
        ReflectionRegistration {
            type_id: || TypeId::of::<Linked>(),
            reflection: <Linked as Reflect>::reflection,
        }
    }

    inventory::submit! {
        ReflectionRegistration {
            type_id: || TypeId::of::<WrongLinked>(),
            reflection: <Linked as Reflect>::reflection,
        }
    }

    impl Drop for TrackedTable {
        fn drop(&mut self) {
            DROPS.fetch_add(1, Ordering::SeqCst);
        }
    }

    fn registration<Receiver: 'static, Table: Any + Send + Sync>(
        methods: Option<Table>,
    ) -> ReflectedImplementation<Receiver> {
        ReflectedImplementation::__new(
            crate::Styled.reflected_trait(),
            methods.map(|methods| Box::new(methods) as Box<dyn Any + Send + Sync>),
        )
    }

    fn assert_panics<Result>(action: impl FnOnce() -> Result) {
        assert!(panic::catch_unwind(panic::AssertUnwindSafe(action)).is_err());
    }

    fn concurrent() -> Vec<ReflectedImplementation<Concurrent>> {
        BUILDS.fetch_add(1, Ordering::SeqCst);
        BARRIER.wait();

        vec![registration(Some(TrackedTable))]
    }

    fn recursive() -> Vec<ReflectedImplementation<Recursive>> {
        metadata_for::<Nested>(|| {
            metadata_for::<Recursive>(recursive);

            Vec::new()
        });

        Vec::new()
    }

    assert_eq!(LINKED_BUILDS.load(Ordering::SeqCst), 0);
    assert!(linked_metadata_for::<()>().descriptors().is_empty());
    assert_eq!(LINKED_BUILDS.load(Ordering::SeqCst), 0);
    assert!(std::ptr::eq(
        linked_metadata_for::<Linked>(),
        <Linked as Reflect>::reflection()
    ));
    assert_eq!(LINKED_BUILDS.load(Ordering::SeqCst), 1);
    assert_panics(linked_metadata_for::<WrongLinked>);

    let descriptor = crate::Styled.reflected_trait();
    metadata_for::<DemandOnly>(|| {
        vec![ReflectedImplementation::__new(
            crate::Styled.reflected_trait(),
            None,
        )]
    });
    assert!(linked_metadata_for::<DemandOnly>().descriptors().is_empty());
    assert_eq!(registered_traits(TypeId::of::<DemandOnly>()), &[descriptor]);

    let normalized = ElementReflection::build::<Concurrent>(
        [None, Some(1usize), None]
            .into_iter()
            .map(registration)
            .collect(),
    );
    let descriptor_only =
        ElementReflection::build::<Concurrent>(vec![registration::<Concurrent, usize>(None)]);

    assert_eq!(normalized.descriptors(), &[descriptor]);
    assert_panics(|| {
        ElementReflection::build::<Concurrent>(
            [Some(1usize), Some(2usize)]
                .into_iter()
                .map(registration)
                .collect(),
        )
    });
    assert!(normalized.satisfies(ReflectionRequirement {
        descriptor,
        adapter_type: Some(TypeId::of::<usize>()),
    }));

    let callers = (0..WORKERS)
        .map(|_idx| thread::spawn(|| metadata_for::<Concurrent>(concurrent)))
        .collect::<Vec<_>>();
    let entries = callers
        .into_iter()
        .map(|caller| caller.join().unwrap())
        .collect::<Vec<_>>();

    assert!(entries.iter().all(|entry| std::ptr::eq(*entry, entries[0])));
    assert_eq!(BUILDS.load(Ordering::SeqCst), WORKERS);
    assert_eq!(DROPS.load(Ordering::SeqCst), WORKERS - 1);

    for metadata in [&normalized, &descriptor_only, entries[0]] {
        assert!(metadata.implements_trait(descriptor));
        assert!(metadata.satisfies(descriptor.requirement()));
        assert!(!metadata.implements_trait(crate::Styled));
        assert!(!metadata.has_adapter(crate::Styled));
        assert!(!metadata.satisfies(crate::Styled.requirement()));
    }

    assert_panics(|| entries[0].validate_receiver(TypeId::of::<Nested>()));
    assert_panics(|| metadata_for::<Panicking>(|| panic!("factory panic")));
    assert_panics(|| metadata_for::<Recursive>(recursive));
    assert_panics(|| {
        metadata_for::<Conflicting>(|| {
            vec![
                registration(Some(1usize)),
                registration(Some(String::new())),
            ]
        })
    });

    for entry in [
        metadata_for::<Panicking>(Vec::new),
        metadata_for::<Recursive>(|| {
            metadata_for::<Nested>(Vec::new);

            Vec::new()
        }),
        metadata_for::<Conflicting>(Vec::new),
    ] {
        assert!(entry.descriptors().is_empty());
        assert!(entry.concrete_type().is_some());
    }

    assert!(INITIALIZING.with(|stack| stack.borrow().is_empty()));
}
