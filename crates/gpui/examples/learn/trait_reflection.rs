//! Run with `cargo run -p gpui-ce --example trait_reflection`.
//!
//! Reflection uses the concrete element after conversion. Default components and
//! animation wrappers keep their own receiver. Stateful `Div` builders preserve their
//! ID and state; a custom element opts into stateful interaction explicitly.
//!
//! `CardElement` uses the aggregate `Element` derive to delegate lifecycle and builder
//! traits to `Stateful<Div>` and binds the ordinary `Draggable` trait to the component type.

use gpui::{
    AnyElement, App, ElementId, IntoElement, RenderOnce, SharedString, Stateful, Window, div,
    prelude::*,
    px,
    reflection::{self, Reflect},
    rgb,
};

pub(crate) trait Draggable {
    fn drag_payload<'a>(&'a mut self) -> &'a mut Option<SharedString>;
}

pub(crate) const DRAG: reflection::Capability<dyn Draggable> =
    reflection::Capability::new("Draggable");

#[derive(gpui::Element)]
#[reflect(capability(DRAG => |card| card))]
pub(crate) struct CardElement {
    #[element(style, children, interactive, stateful)]
    inner: Stateful<gpui::Div>,
    pub(crate) drag_payload: Option<SharedString>,
}

impl CardElement {
    #[track_caller]
    pub(crate) fn new(element_id: impl Into<ElementId>) -> Self {
        Self {
            inner: div().id(element_id),
            drag_payload: None,
        }
    }
}

impl Draggable for CardElement {
    fn drag_payload<'a>(&'a mut self) -> &'a mut Option<SharedString> {
        &mut self.drag_payload
    }
}

#[derive(IntoElement, Reflect, Default)]
#[reflect(capability(DRAG => |icon| icon))]
pub(crate) struct Icon {
    drag_payload: Option<SharedString>,
}

impl Draggable for Icon {
    fn drag_payload(&mut self) -> &mut Option<SharedString> {
        &mut self.drag_payload
    }
}

impl RenderOnce for Icon {
    fn render(self, _window: &mut Window, _cx: &mut App) -> impl IntoElement {
        div().size(px(24.)).bg(rgb(0x4a90d9))
    }
}

pub(crate) fn set_drag_payload(element: &mut AnyElement, payload: impl Into<SharedString>) {
    assert!(element.implements_trait(DRAG));

    *DRAG
        .get_mut(element)
        .expect("Draggable is bound to CardElement")
        .drag_payload() = Some(payload.into());
}

pub(crate) fn main() {
    let mut card = CardElement::new("card")
        .w(px(240.))
        .h(px(80.))
        .role(accesskit::Role::Button)
        .aria_label("Draggable card")
        .child(div().size(px(24.)))
        .into_any_element();
    set_drag_payload(&mut card, "card-data");

    println!("CardElement traits:");

    for reflected_trait in card.reflected_traits() {
        println!("  {}", reflected_trait.name);
    }

    println!(
        "Payload after reflected mutation: {:?}",
        card.downcast_mut::<CardElement>().unwrap().drag_payload
    );

    let icon = Icon::default().into_any_element();
    let stateful_div = div().id("ordinary-card").into_any_element();

    println!(
        "ViewElement<Icon> Draggable: {}",
        icon.implements_trait(DRAG)
    );
    println!(
        "ViewElement<Icon> Styled: {}",
        icon.implements_trait(gpui::Styled)
    );
    println!(
        "Div StatefulInteractiveElement: {}",
        stateful_div.implements_trait(gpui::StatefulInteractiveElement)
    );
}
