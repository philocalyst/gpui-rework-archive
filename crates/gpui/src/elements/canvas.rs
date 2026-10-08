use refineable::Refineable as _;

use crate::{
    App, Bounds, Element, ElementId, GlobalElementId, InspectorElementId, IntoElement, Pixels,
    Style, StyleRefinement, Styled, Window,
};

/// Draws custom geometry in a box sized by ordinary layout.
///
/// Use a canvas for a chart, a selection marker, or other drawing that needs
/// the space layout assigned. Prefer [`div`](crate::div) for ordinary styled
/// boxes, and implement [`Element`] when you need custom measurement or child
/// layout. A canvas is a leaf: its drawing has no intrinsic size. Give it a
/// width and height, or use `size_full` inside a parent with a resolved size.
///
/// # Prepare geometry, then paint it
///
/// Both callbacks receive the resolved bounds in window-local logical
/// [`Pixels`]. Add `bounds.origin` to canvas-local positions; do not multiply
/// them by the display scale. The callbacks have different jobs:
///
/// - `prepaint` runs after layout. Prepare geometry or insert a
///   [`Hitbox`](crate::Hitbox), and return the data the next phase needs.
/// - `paint` receives that value as `T`. Record drawing with methods such as
///   [`Window::paint_quad`] or [`Window::paint_path`], and register this
///   frame's input listeners. These calls record a scene for the renderer;
///   they do not provide a GPU drawing context.
///
/// This swatch prepares an inset rectangle in prepaint and consumes it in
/// paint. Moving the parent moves the swatch, because the rectangle starts
/// from the assigned origin rather than the window's origin:
///
/// ```
/// use gpui::{Bounds, Context, IntoElement, Render, Window, canvas, div, fill,
///            point, prelude::*, px, rgb, size};
///
/// struct Swatch;
/// impl Render for Swatch {
///     fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
///         div().p(px(12.)).child(
///             canvas(
///                 |bounds, _, _| {
///                     let inset = Bounds::new(
///                         bounds.origin + point(px(8.), px(8.)),
///                         size((bounds.size.width - px(16.)).max(px(0.)),
///                              (bounds.size.height - px(16.)).max(px(0.))),
///                     );
///                     fill(inset, rgb(0x155b50))
///                 },
///                 |_, quad, window, _| window.paint_quad(quad),
///             ).w(px(120.)).h(px(48.))
///         )
///     }
/// }
/// # let mut app = gpui::TestApp::new();
/// # let mut window = app.open_window(|_, _| Swatch);
/// # window.draw();
/// # window.update(|_, window, _| {
/// #     let quad = window.painted_quads().into_iter()
/// #         .find(|quad| quad.background == rgb(0x155b50).into()).unwrap();
/// #     assert_eq!(quad.bounds, Bounds::new(point(px(20.), px(20.)), size(px(104.), px(32.)))
/// #         .scale(window.scale_factor()));
/// # });
/// ```
///
/// `T` belongs to this frame. Keep data that must survive another render on
/// the view or an entity. Both callbacks are [`FnOnce`]: build a new canvas
/// in each [`Render::render`](crate::Render::render) or
/// [`RenderOnce::render`](crate::RenderOnce::render) call. The canvas does not
/// schedule another frame; notify the owning view when its drawing data changes.
///
/// # Clipping and interaction
///
/// A layout box does not clip drawing. Apply [`Window::with_content_mask`]
/// in both phases when drawing and hitboxes must share a clip. The
/// [clipped-control test](https://gpui-ce.github.io/book/testing.html#check-clipping-and-input-together)
/// demonstrates the geometry and checks input outside the visible region.
/// A surrounding `div().overflow_hidden()` can supply that mask instead.
///
/// A canvas supplies no hitbox, focus target, or accessibility node by itself.
/// For a clickable shape, usually put it inside a named, focusable div and use
/// [`on_click`](crate::StatefulInteractiveElement::on_click) there. For custom
/// pointer handling, insert a hitbox in prepaint, then pass it to paint and
/// filter [`Window::on_mouse_event`] with it. That listener does not perform
/// hit testing for you. See [`Canvas`] for its style boundary and the
/// [drawing walkthrough](https://gpui-ce.github.io/examples/drawing/#paint)
/// for a complete program you can edit.
// docs:examples:begin
#[doc = include_str!("../docs/examples/gpui-canvas.md")]
// docs:examples:end
pub fn canvas<T>(
    prepaint: impl 'static + FnOnce(Bounds<Pixels>, &mut Window, &mut App) -> T,
    paint: impl 'static + FnOnce(Bounds<Pixels>, T, &mut Window, &mut App),
) -> Canvas<T> {
    Canvas {
        prepaint: Some(Box::new(prepaint)),
        paint: Some(Box::new(paint)),
        style: StyleRefinement::default(),
    }
}

/// A layout leaf whose callbacks prepare and paint custom content.
///
/// Construct it with [`canvas`]. `T` is the value returned by prepaint and
/// consumed by paint, such as a [`PaintQuad`](crate::PaintQuad), a prepared
/// path, or a [`Hitbox`](crate::Hitbox). It is not retained between renders.
/// The element has no children or stable [`ElementId`] of its own; put
/// persistent state on an entity or implement [`Element`] when the element
/// itself needs an identity and retained state.
///
/// # Style boundary
///
/// [`Styled`] sets the canvas's layout and box decoration. [`Style::paint`]
/// draws that decoration around the paint callback: the background precedes
/// it and the border follows it. Callback bounds cover the complete layout
/// box; padding does not turn them into content-box coordinates.
///
/// > [!WARNING]
/// > The canvas does not apply its own overflow mask, opacity, or inherited
/// > text-style scope. Put those properties on a surrounding [`Div`](crate::Div),
/// > or establish the required window scopes explicitly in the callbacks.
/// > For example, apply `overflow_hidden` to the parent when custom drawing
/// > must stop at its edge. Setting it on the canvas alone does not crop paint.
///
/// The [`canvas`] documentation explains callback timing, coordinates,
/// sizing, and input. The [custom-element walkthrough](https://gpui-ce.github.io/examples/custom-element/)
/// shows how to take over the complete element lifecycle when those two
/// callbacks are insufficient.
pub struct Canvas<T> {
    prepaint: Option<Box<dyn FnOnce(Bounds<Pixels>, &mut Window, &mut App) -> T>>,
    paint: Option<Box<dyn FnOnce(Bounds<Pixels>, T, &mut Window, &mut App)>>,
    style: StyleRefinement,
}

impl<T: 'static> IntoElement for Canvas<T> {
    type Element = Self;

    fn into_element(self) -> Self::Element {
        self
    }
}

impl<T: 'static> Element for Canvas<T> {
    type RequestLayoutState = Style;
    type PrepaintState = Option<T>;

    fn id(&self) -> Option<ElementId> {
        None
    }

    fn source_location(&self) -> Option<&'static core::panic::Location<'static>> {
        None
    }

    fn request_layout(
        &mut self,
        _id: Option<&GlobalElementId>,
        _inspector_id: Option<&InspectorElementId>,
        window: &mut Window,
        cx: &mut App,
    ) -> (crate::LayoutId, Self::RequestLayoutState) {
        let mut style = Style::default();
        style.refine(&self.style);
        let layout_id = window.request_layout(style.clone(), [], cx);
        (layout_id, style)
    }

    fn prepaint(
        &mut self,
        _id: Option<&GlobalElementId>,
        _inspector_id: Option<&InspectorElementId>,
        bounds: Bounds<Pixels>,
        _request_layout: &mut Style,
        window: &mut Window,
        cx: &mut App,
    ) -> Option<T> {
        Some(self.prepaint.take().unwrap()(bounds, window, cx))
    }

    fn paint(
        &mut self,
        _id: Option<&GlobalElementId>,
        _inspector_id: Option<&InspectorElementId>,
        bounds: Bounds<Pixels>,
        style: &mut Style,
        prepaint: &mut Self::PrepaintState,
        window: &mut Window,
        cx: &mut App,
    ) {
        let prepaint = prepaint.take().unwrap();
        style.paint(bounds, window, cx, |window, cx| {
            (self.paint.take().unwrap())(bounds, prepaint, window, cx)
        });
    }
}

impl<T> Styled for Canvas<T> {
    fn style(&mut self) -> &mut crate::StyleRefinement {
        &mut self.style
    }
}
