use gpui::reflection::Capability;
use gpui::{
    AnyElement, Div, IntoElement, ParentElement, RenderOnce, Select, SelectableElement, Styled,
    div, rgb,
};

trait Draggable {
    fn payload(&mut self) -> &mut Option<String>;
}

const DRAG: Capability<dyn Draggable> = Capability::new("Draggable");

// A durable element can expose a plain object-safe trait view through an ordinary
// typed projection. No trait attribute macro is needed.
#[derive(gpui::Element)]
#[reflect(capability(DRAG => |card| card))]
struct Card {
    #[element(style, children)]
    root: Div,
    payload: Option<String>,
}

impl Draggable for Card {
    fn payload(&mut self) -> &mut Option<String> {
        &mut self.payload
    }
}

// Scenario 1: ordinary styled descendants.
fn styled_descendant(root: impl IntoElement) -> impl IntoElement {
    root.select_mut(
        Select::descendants().class("button").reflects(gpui::Styled),
        |element| {
            let _ = element.bg(rgb(0x123456));
        },
    )
}

// Scenario 2: a concrete query lends the post-conversion Card without reflection.
fn typed_custom(element: AnyElement, payload: String) -> impl IntoElement {
    div()
        .child(element)
        .select_mut(Select::this().class("card").of::<Card>(), move |card| {
            card.payload = Some(payload.clone())
        })
}

// Scenario 3: generic elements get a schema for each concrete monomorphization.
#[derive(gpui::Element)]
struct GenericCard<T: 'static> {
    #[element(style, children)]
    root: Div,
    value: T,
}

fn generic_concrete_query(root: impl IntoElement) -> impl IntoElement {
    root.select_mut(Select::descendants().of::<GenericCard<String>>(), |card| {
        card.value.push('!')
    })
}

// Scenario 4: a borrowed custom trait view through a keyed capability handle.
fn custom_trait_view(element: AnyElement) -> impl IntoElement {
    div()
        .child(element)
        .select_mut(Select::this().capability(DRAG), |draggable| {
            *draggable.payload() = Some("selected".into())
        })
}

// Scenario 5: tuple composition and fluent `.and(...)` replace repeated `reflects`.
fn multiple_capabilities(element: AnyElement) -> impl IntoElement {
    div().child(element).select_mut(
        Select::this()
            .reflects((gpui::Styled, gpui::ParentElement))
            .and(DRAG),
        |mut element| {
            *element.capability(DRAG).payload() = Some("styled and draggable".into());
            let _ = element.bg(rgb(0x111111));
        },
    )
}

struct Notice {
    label: String,
}

impl Notice {
    fn prefix(&mut self, prefix: &str) {
        self.label.insert_str(0, prefix);
    }
}

impl RenderOnce for Notice {
    fn render(self, _window: &mut gpui::Window, _cx: &mut gpui::App) -> impl IntoElement {
        div().class("notice-root").child(self.label)
    }
}

// Scenario 6: the component wrapper and rendered root are separate selector nodes.
fn component_boundary(root: impl SelectableElement) -> impl IntoElement {
    root.select_mut(
        Select::descendants().class("notice").component::<Notice>(),
        |notice| notice.prefix("[urgent] "),
    )
    .select_mut(
        Select::descendants()
            .class("notice-root")
            .reflects(gpui::Styled),
        |root| {
            let _ = root.bg(rgb(0xabcdef));
        },
    )
}

fn main() {}
