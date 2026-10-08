use gpui::{
    App, AppContext, Bounds, Context, Element, ElementId, GlobalElementId, Hsla,
    InspectorElementId, IntoElement, LayoutId, PaintQuad, Pixels, Render, Style, Window, div, fill,
    hsla, prelude::*, px, rgb, text,
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
            .child(text!("One layout node, one prepared quad"))
    }
}

fn component(_window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<SwatchView> {
    cx.new(|_| SwatchView)
}
