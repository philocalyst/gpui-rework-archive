use gpui::{
    App, Div, InteractiveElement, IntoElement, ParentElement, Pixels, RenderOnce, Select,
    SelectableElement, Styled, TestAppContext, Window, div, px, reflection::Capability, size,
};

#[cfg(query_wrong_capability_receiver)]
use gpui::reflection::{Reflect, ReflectedImplementation};

#[derive(gpui::IntoElement)]
struct SampleComponent {
    width: Pixels,
}

impl RenderOnce for SampleComponent {
    fn render(self, _window: &mut Window, _cx: &mut App) -> impl IntoElement {
        div()
            .w(self.width)
            .h(px(12.))
            .debug_selector(|| "component-root".into())
    }
}

type Card = Div;

trait Lens {
    type Value;

    fn value(&mut self) -> &mut Self::Value;
}

struct TextLens(String);

impl Lens for TextLens {
    type Value = String;

    fn value(&mut self) -> &mut Self::Value {
        &mut self.0
    }
}

struct PrimaryLens;
struct SecondaryLens;

const PRIMARY_LENS: Capability<dyn Lens<Value = String>, PrimaryLens> =
    Capability::new("PrimaryLens");
const SECONDARY_LENS: Capability<dyn Lens<Value = String>, SecondaryLens> =
    Capability::new("SecondaryLens");

#[cfg(query_capability_key_coercion)]
type StaticKey = fn(&'static str);
#[cfg(query_capability_key_coercion)]
type ForAllKey = for<'a> fn(&'a str);

#[cfg(query_capability_key_coercion)]
fn capability_key_cannot_widen(capability: Capability<(), StaticKey>) -> Capability<(), ForAllKey> {
    capability
}

#[cfg(query_concrete_target_coercion)]
fn concrete_target_type_cannot_widen() {
    let _selection: gpui::Select<gpui::NoReflectedTraits, gpui::ConcreteTarget<fn(&'static str)>> =
        gpui::Select::children().of::<fn(&str)>();
}

#[derive(gpui::Element)]
#[reflect(
    capability(PRIMARY_LENS => |card| &mut card.primary),
    capability(SECONDARY_LENS => |card| &mut card.secondary)
)]
struct CapabilityCard {
    #[element(style, children)]
    inner: Div,
    primary: TextLens,
    secondary: TextLens,
}

impl CapabilityCard {
    fn new() -> Self {
        Self {
            inner: div(),
            primary: TextLens("primary".into()),
            secondary: TextLens("secondary".into()),
        }
    }
}

// The lifecycle root and the fields supplying builders need not have the same type.
// In particular, Empty does not implement Styled or ParentElement.
#[derive(gpui::Element)]
struct SplitDelegates<Root, Appearance, Content> {
    #[element]
    root: Root,
    #[style(delegate)]
    appearance: Appearance,
    #[children(delegate)]
    content: Content,
}

struct ChildList(Vec<gpui::AnyElement>);

impl ParentElement for ChildList {
    fn extend(&mut self, elements: impl IntoIterator<Item = gpui::AnyElement>) {
        self.0.extend(elements);
    }
}

#[test]
fn generic_builder_bounds_follow_their_delegated_fields() {
    let mut element = SplitDelegates {
        root: gpui::Empty,
        appearance: div(),
        content: ChildList(Vec::new()),
    }
    .w(px(37.))
    .child(div())
    .into_any_element();
    let mut view = element
        .reflect_mut((gpui::Styled, gpui::ParentElement))
        .unwrap();
    assert_eq!(view.style().size.width, Some(px(37.).into()));
    assert_eq!(
        view.downcast_ref::<SplitDelegates<gpui::Empty, Div, ChildList>>()
            .unwrap()
            .content
            .0
            .len(),
        1
    );
}

fn borrow_reflected_element_mutably() {
    let mut element = div().into_any_element();
    let reflected = element
        .reflect_mut((gpui::Styled, gpui::ParentElement))
        .expect("Div reflects both fluent traits");
    reflected.w(px(16.)).child(div());
}

#[gpui::test]
fn consumer_reflection_and_selector_queries_render(cx: &mut TestAppContext) {
    borrow_reflected_element_mutably();
    let mut capability_card = CapabilityCard::new().into_any_element();
    {
        let mut lenses = capability_card
            .reflect_mut((PRIMARY_LENS, SECONDARY_LENS))
            .expect("the card registers both keyed lenses");
        lenses.capability(PRIMARY_LENS).value().push_str("-first");
        lenses
            .capability(SECONDARY_LENS)
            .value()
            .push_str("-second");
        lenses.capability(PRIMARY_LENS).value().push_str("-again");
    }
    let capability_card = capability_card.downcast_ref::<CapabilityCard>().unwrap();
    assert_eq!(capability_card.primary.0, "primary-first-again");
    assert_eq!(capability_card.secondary.0, "secondary-second");

    let visual = cx.add_empty_window();

    visual.draw(Default::default(), size(px(200.), px(100.)), |_, _| {
        {
            div()
                .map_selected(
                    Select::children()
                        .class("tuple-query")
                        .reflects((gpui::Styled, gpui::ParentElement)),
                    |mut element| element.w(px(24.)).child(div()),
                )
                .map_selected(
                    Select::children()
                        .class("chained-query")
                        .reflects(gpui::Styled)
                        .and(gpui::ParentElement),
                    |mut element| element.w(px(32.)),
                )
                .select_mut(
                    Select::children().class("concrete-card").of::<Card>(),
                    |card: &mut Card| {
                        card.style().size.width = Some(px(40.).into());
                    },
                )
                .select_mut(
                    Select::children()
                        .class("authored-component")
                        .component::<SampleComponent>(),
                    |component: &mut SampleComponent| component.width = px(48.),
                )
                .child(
                    div()
                        .class("tuple-query")
                        .size(px(8.))
                        .debug_selector(|| "tuple-query".into()),
                )
                .child(
                    div()
                        .class("chained-query")
                        .size(px(8.))
                        .debug_selector(|| "chained-query".into()),
                )
                .child(
                    div()
                        .class("concrete-card")
                        .size(px(8.))
                        .debug_selector(|| "concrete-card".into()),
                )
                .child(SampleComponent { width: px(8.) }.class("authored-component"))
        }
        .into_any_element()
    });

    assert_eq!(
        visual.debug_bounds("tuple-query").unwrap().size.width,
        px(24.)
    );
    assert_eq!(
        visual.debug_bounds("chained-query").unwrap().size.width,
        px(32.)
    );
    assert_eq!(
        visual.debug_bounds("concrete-card").unwrap().size.width,
        px(40.)
    );
    assert_eq!(
        visual.debug_bounds("component-root").unwrap().size.width,
        px(48.)
    );
}

#[gpui::reflection::reflect_trait]
trait CustomCapability {
    fn value(&self) -> usize;
}

#[gpui::reflection::reflect_trait(membership)]
trait MembershipOnly {
    fn hidden_value(&self) -> usize;
}

#[cfg(query_fake_builtin_styled)]
#[gpui::reflection::reflect_trait(builtin = styled)]
trait FakeStyled {}

#[cfg(query_wrong_capability_receiver)]
struct WrongCapabilityReceiver;

#[cfg(query_wrong_capability_receiver)]
impl Reflect for WrongCapabilityReceiver {
    fn build_reflection() -> Vec<ReflectedImplementation<Self>> {
        vec![PRIMARY_LENS.bind::<TextLens>(|lens| lens)]
    }
}

#[cfg(query_missing_builtin)]
fn missing_builtin_trait_is_rejected() {
    use gpui::InteractiveElement;

    let mut element = div().into_any_element();
    let mut reflected = element.reflect_mut(gpui::Styled).unwrap();
    let _ = reflected.interactivity();
}

#[cfg(query_unknown_with)]
fn unknown_custom_trait_is_rejected() {
    let mut element = div().into_any_element();
    let mut reflected = element
        .reflect_mut((gpui::Styled, gpui::ParentElement))
        .unwrap();
    reflected.with(CustomCapability, |view| view.value());
}

#[cfg(query_membership_no_methods)]
fn membership_token_grants_no_callable_methods() {
    let mut element = div().into_any_element();
    let reflected = element.reflect_mut(MembershipOnly).unwrap();
    let _ = reflected.hidden_value();
}

#[cfg(query_borrow_escape)]
fn borrowed_query_cannot_escape_its_element() {
    let reflected;
    {
        let mut element = div().into_any_element();
        reflected = element
            .reflect_mut((gpui::Styled, gpui::ParentElement))
            .unwrap();
    }
    drop(reflected);
}

#[cfg(query_borrow_alias)]
fn borrowed_query_cannot_alias_another_mutable_query() {
    let mut element = div().into_any_element();
    let mut first = element
        .reflect_mut((gpui::Styled, gpui::ParentElement))
        .unwrap();
    let mut second = element
        .reflect_mut((gpui::Styled, gpui::ParentElement))
        .unwrap();
    first.w(px(1.));
    second.w(px(2.));
}

#[cfg(query_borrow_clone)]
fn borrowed_query_cannot_be_cloned_into_an_alias() {
    fn require_clone<Type: Clone>(_value: Type) {}

    let mut element = div().into_any_element();
    let reflected = element
        .reflect_mut((gpui::Styled, gpui::ParentElement))
        .unwrap();
    require_clone(reflected);
}
