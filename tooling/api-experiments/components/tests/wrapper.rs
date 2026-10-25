use gpui::{
    AnyElement, App, AppContext, Bounds, Context, Element, GlobalElementId, InspectorElementId,
    InteractiveElement, IntoElement, LayoutId, ParentElement, Pixels, Render, Select,
    SelectableElement, StatefulInteractiveElement, Styled, TestAppContext, Window, div, px,
    reflection::Reflect,
};
use std::sync::atomic::{AtomicUsize, Ordering};

#[gpui::reflection::reflect_trait]
trait ComponentValue {
    fn value<'a>(&'a mut self) -> &'a mut usize;
}

trait ComponentRender: Sized + 'static {
    fn render(self, window: &mut Window, cx: &mut App) -> AnyElement;
}

/// Prototype for a derive-generated outer component element.
#[derive(Reflect)]
#[reflect(ComponentValue)]
struct Component<C> {
    component: Option<C>,
    rendered: Option<AnyElement>,
}

impl<C> Component<C> {
    fn new(component: C) -> Self {
        Self {
            component: Some(component),
            rendered: None,
        }
    }
}

impl<C: ComponentRender + ComponentValue> IntoElement for Component<C> {
    type Element = Self;
    fn into_element(self) -> Self {
        self
    }
}

impl<C: ComponentValue> ComponentValue for Component<C> {
    fn value<'a>(&'a mut self) -> &'a mut usize {
        self.component.as_mut().expect("before render").value()
    }
}

impl<C: ComponentRender + ComponentValue> Element for Component<C> {
    type RequestLayoutState = <AnyElement as Element>::RequestLayoutState;
    type PrepaintState = <AnyElement as Element>::PrepaintState;

    fn reflection(&self) -> &'static gpui::reflection::ElementReflection {
        <Self as Reflect>::reflection()
    }

    fn id(&self) -> Option<gpui::ElementId> {
        None
    }
    fn source_location(&self) -> Option<&'static std::panic::Location<'static>> {
        None
    }

    fn request_layout(
        &mut self,
        id: Option<&GlobalElementId>,
        inspector_id: Option<&InspectorElementId>,
        window: &mut Window,
        cx: &mut App,
    ) -> (LayoutId, Self::RequestLayoutState) {
        let rendered = self
            .component
            .take()
            .expect("rendered once")
            .render(window, cx);
        self.rendered = Some(rendered);
        Element::request_layout(
            self.rendered.as_mut().unwrap(),
            id,
            inspector_id,
            window,
            cx,
        )
    }

    fn prepaint(
        &mut self,
        id: Option<&GlobalElementId>,
        inspector_id: Option<&InspectorElementId>,
        bounds: Bounds<Pixels>,
        state: &mut Self::RequestLayoutState,
        window: &mut Window,
        cx: &mut App,
    ) -> Self::PrepaintState {
        Element::prepaint(
            self.rendered.as_mut().unwrap(),
            id,
            inspector_id,
            bounds,
            state,
            window,
            cx,
        )
    }

    fn paint(
        &mut self,
        id: Option<&GlobalElementId>,
        inspector_id: Option<&InspectorElementId>,
        bounds: Bounds<Pixels>,
        state: &mut Self::RequestLayoutState,
        prepaint: &mut Self::PrepaintState,
        window: &mut Window,
        cx: &mut App,
    ) {
        Element::paint(
            self.rendered.as_mut().unwrap(),
            id,
            inspector_id,
            bounds,
            state,
            prepaint,
            window,
            cx,
        )
    }
}

static RENDERS: AtomicUsize = AtomicUsize::new(0);

struct Probe {
    value: usize,
}
impl ComponentValue for Probe {
    fn value<'a>(&'a mut self) -> &'a mut usize {
        &mut self.value
    }
}
impl ComponentRender for Probe {
    fn render(self, _window: &mut Window, _cx: &mut App) -> AnyElement {
        RENDERS.fetch_add(1, Ordering::SeqCst);
        div()
            .w(px((self.value * 8) as f32))
            .h(px(8.))
            .debug_selector(|| "probe".into())
            .into_any_element()
    }
}

#[gpui::test]
fn component_identity_is_available_to_selector_then_consumed_once() {
    let cx = &mut TestAppContext::single();
    RENDERS.store(0, Ordering::SeqCst);
    let visual = cx.add_empty_window();
    visual.draw(
        Default::default(),
        gpui::size(px(100.), px(100.)),
        |_, _| {
            div()
                .map_selected(
                    Select::children().class("probe").reflects(ComponentValue),
                    |mut element| {
                        *ComponentValue::value(&mut element) += 1;
                        element.into_any_element()
                    },
                )
                .child(Component::new(Probe { value: 2 }).class("probe"))
                .into_any_element()
        },
    );
    assert_eq!(visual.debug_bounds("probe").unwrap().size.width, px(24.));
    assert_eq!(RENDERS.load(Ordering::SeqCst), 1);
}

#[test]
fn borrowed_component_fields_remain_available_until_render_and_are_consumed_once() {
    struct Borrowed<'a> {
        value: &'a mut usize,
    }
    // This intentionally demonstrates the RenderOnce/static boundary: the component itself
    // may borrow, but the GPUI component element cannot be 'static unless it owns the data.
    fn borrow<'a>(value: &'a mut usize) -> Borrowed<'a> {
        Borrowed { value }
    }
    let mut value = 4;
    let borrowed = borrow(&mut value);
    *borrowed.value += 1;
    assert_eq!(value, 5);
}

#[derive(gpui::Element)]
#[reflect(ComponentValue)]
struct DerivedCard {
    #[element(stateful)]
    #[style(delegate)]
    #[interactivity(delegate)]
    #[children(delegate)]
    inner: gpui::Stateful<gpui::Div>,
    value: usize,
}

impl ComponentValue for DerivedCard {
    fn value<'a>(&'a mut self) -> &'a mut usize {
        &mut self.value
    }
}

static SELECTED_DERIVED_VALUE: AtomicUsize = AtomicUsize::new(0);

#[gpui::test]
fn element_derive_reflects_outer_node_and_forwards_accessibility() {
    let cx = &mut TestAppContext::single();
    SELECTED_DERIVED_VALUE.store(0, Ordering::SeqCst);

    struct Root;
    impl Render for Root {
        fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
            div()
                .map_selected(
                    Select::children()
                        .class("derived-card")
                        .reflects(ComponentValue),
                    |mut element| {
                        *ComponentValue::value(&mut element) += 1;
                        SELECTED_DERIVED_VALUE
                            .store(*ComponentValue::value(&mut element), Ordering::SeqCst);
                        element.into_any_element()
                    },
                )
                .child(
                    DerivedCard {
                        inner: div()
                            .id("derived-card")
                            .role(gpui::accesskit::Role::Button)
                            .aria_label("Derived card"),
                        value: 4,
                    }
                    .w(px(40.))
                    .h(px(24.))
                    .class("derived-card"),
                )
        }
    }

    let window = cx.add_window(|_, _| Root);
    cx.update_window(window.into(), |_root, window, cx| {
        window.set_a11y_forced(true);
        window.draw(cx).clear(cx);
    })
    .unwrap();

    assert_eq!(SELECTED_DERIVED_VALUE.load(Ordering::SeqCst), 5);
    cx.update_window(window.into(), |_root, window, _cx| {
        let tree = window.a11y_tree().expect("forced accessibility tree");
        let (_, node) = tree
            .nodes
            .iter()
            .find(|(_, node)| node.label() == Some("Derived card"))
            .expect("delegated accessible card");
        assert_eq!(node.role(), gpui::accesskit::Role::Button);
    })
    .unwrap();
}

#[derive(gpui::Element)]
struct GenericDerived<E> {
    #[element(style, children, interactive, stateful)]
    inner: E,
    value: usize,
}

impl<E> ComponentValue for GenericDerived<E> {
    fn value<'a>(&'a mut self) -> &'a mut usize {
        &mut self.value
    }
}

#[allow(dead_code)]
fn generic_derived<E>(inner: E) -> impl IntoElement
where
    E: Element
        + Styled
        + ParentElement
        + InteractiveElement
        + gpui::StatefulInteractiveElement
        + 'static,
{
    GenericDerived { inner, value: 0 }
        .w(px(8.))
        .child(div().size(px(4.)))
        .on_click(|_, _, _| {})
}
