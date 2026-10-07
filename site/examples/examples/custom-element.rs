#[path = "../src/support.rs"]
mod support;

// ## Choose the three phase states {#phases}
// A swatch needs one layout node and one paint quad. [`Element`] exposes the
// three frame phases directly: request a layout node, prepare geometry after
// bounds are known, then record paint commands. Use it when [`canvas`] or
// ordinary styled elements do not provide enough control. `RequestLayoutState`
// is empty here; `PrepaintState` carries the quad from prepaint into paint.
//
// [`IntoElement`] is the conversion expected by `.child`. Returning `Self`
// avoids wrapping this value because `Swatch` already implements the low-level
// [`Element`] contract.

use gpui::{
    App, AppContext, Bounds, Context, Element, ElementId, GlobalElementId, Hsla,
    InspectorElementId, IntoElement, LayoutId, PaintQuad, Pixels, Render, Style, Window, div, fill,
    hsla, prelude::*, px, rgb,
};

struct Swatch {
    color: Hsla,
}

impl IntoElement for Swatch {
    type Element = Self;

    fn into_element(self) -> Self {
        self
    }
}

// ## Measure, prepare, then paint {#draw}
// [`Window::request_layout`] registers a 192-by-96 logical-pixel size with the
// layout engine and returns a frame-local `LayoutId`. The engine resolves
// that request against the parent's constraints; `prepaint` receives the
// resulting bounds and prepares a filled quad. `paint` records that quad via
// [`Window::paint_quad`]. A requested size is a layout input, not a guarantee
// that every parent constraint will preserve it.
//
// The element has no interaction or retained state, so `id` returns `None`.
// Both phase states belong to this draw and are discarded afterward; neither
// `LayoutId` nor these state values identify an element on the next frame. For
// state that must persist, return a stable `ElementId` and use
// [`Window::with_element_state`] with the global ID GPUI passes into the phases.

impl Element for Swatch {
    type RequestLayoutState = ();
    type PrepaintState = PaintQuad;

    fn id(&self) -> Option<ElementId> {
        None
    }

    fn source_location(&self) -> Option<&'static std::panic::Location<'static>> {
        None
    }

    fn request_layout(
        &mut self,
        _id: Option<&GlobalElementId>,
        _inspector: Option<&InspectorElementId>,
        window: &mut Window,
        cx: &mut App,
    ) -> (LayoutId, ()) {
        let mut style = Style::default();
        style.size.width = px(192.).into();
        style.size.height = px(96.).into();
        (window.request_layout(style, [], cx), ())
    }

    fn prepaint(
        &mut self,
        _id: Option<&GlobalElementId>,
        _inspector: Option<&InspectorElementId>,
        bounds: Bounds<Pixels>,
        _layout: &mut (),
        _window: &mut Window,
        _cx: &mut App,
    ) -> PaintQuad {
        fill(bounds, self.color)
    }

    fn paint(
        &mut self,
        _id: Option<&GlobalElementId>,
        _inspector: Option<&InspectorElementId>,
        _bounds: Bounds<Pixels>,
        _layout: &mut (),
        quad: &mut PaintQuad,
        window: &mut Window,
        _cx: &mut App,
    ) {
        window.paint_quad(quad.clone());
    }
}

// ## Compose it with ordinary elements {#compose}
// The parent centers the swatch and a label. Its [`Render`] method creates a
// new element value on each render, which is normal: the element value carries
// this frame's work, while its stable ID would be needed for retained element
// state. Change the requested size or color and compare the resolved rectangle
// with its painted fill.
//
// A custom element also has to register the accessibility and hit-testing
// behavior it needs; painting a shape does not create either one. This
// decorative swatch needs neither. Prefer [`canvas`] for custom painting alone:
// it already provides the phase handoff while your callbacks supply geometry
// and drawing.

struct SwatchView;

impl Render for SwatchView {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .size_full()
            .flex()
            .flex_col()
            .items_center()
            .justify_center()
            .gap_4()
            .bg(rgb(0xf7f6f2))
            .text_color(rgb(0x202b29))
            .child(Swatch {
                color: hsla(0.43, 0.62, 0.22, 1.),
            })
            .child("One layout node, one prepared quad")
    }
}

fn component(_window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<SwatchView> {
    cx.new(|_| SwatchView)
}

pub fn main() {
    support::run(component);
}
