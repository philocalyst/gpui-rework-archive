#[path = "../src/support.rs"]
mod support;

// ## Choose the three phase states {#phases}
// A swatch needs one layout node and one paint quad. Implement [`Element`]
// when you need to own that handoff instead of using a styled div or canvas.
// `RequestLayoutState` carries nothing here; `PrepaintState` carries the quad
// assembled after the layout engine assigns bounds.
//
// [`IntoElement`] makes the swatch usable as a child. It returns the swatch
// itself because this type already implements the low-level element contract.

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
// [`Window::request_layout`] registers a 192-by-96 logical-pixel rectangle.
// The resolved bounds arrive at `prepaint`, which turns them into a filled
// quad. `paint` records that prepared quad through [`Window::paint_quad`].
//
// The element has no interaction or retained state, so `id` returns `None`.
// The phase states belong to this draw, not to the next frame. For retained
// state, return a stable ID and use [`Window::with_element_state`] with the
// global ID GPUI passes into these methods.

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
// The parent centers the swatch and a label. Its [`Render`] implementation
// creates a new swatch each time it runs. Change the requested width or color
// and run again: layout controls the size, while paint supplies the pixels.
//
// A custom element also owns any accessibility and input behavior it needs.
// This decorative swatch has neither. Prefer [`canvas`] when custom painting
// alone is sufficient; it already implements these phase methods for you.

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
