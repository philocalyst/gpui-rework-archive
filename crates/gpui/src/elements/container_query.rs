//! An element whose contents are chosen from its resolved size.
//!
//! The callback runs after the container's own layout has been resolved. Its returned subtree is
//! laid out inside those bounds and cannot influence the container's size, so size the container
//! explicitly with [`Styled`](crate::Styled) methods when the parent does not provide a definite
//! size.

use refineable::Refineable as _;

use crate::{
    AnyElement, App, AvailableSpace, Bounds, Element, ElementId, GlobalElementId,
    InspectorElementId, IntoElement, LayoutId, Pixels, Size, Style, StyleRefinement, Styled,
    Window, relative,
};

/// Chooses a subtree after the container's size is known.
///
/// Use this when a component needs a different structure in a narrow pane:
/// for example, a compact toolbar instead of a row of labeled actions. The
/// callback receives this container's resolved size in logical [`Pixels`],
/// not the window size. A sidebar can therefore adapt independently of the
/// window containing it. For one structure that only needs flexible sizing,
/// ordinary [`Div`](crate::Div) layout is sufficient.
///
/// The query fills its parent by default, equivalent to `size_full`. Use
/// [`Styled`] to change that request. Its callback runs during prepaint, then
/// GPUI lays out the returned subtree with that size as definite available
/// space and places it at the query's origin. The subtree cannot determine
/// the query's size: it did not exist when the parent performed layout.
///
/// # Change content at a width boundary
///
/// This view selects its compact label and color below 240 logical pixels.
/// At the boundary it selects the full version. Resize the containing pane
/// to change the choice on the next render:
///
/// ```
/// use gpui::{Context, IntoElement, Render, Window, container_query, div,
///            prelude::*, px, rgb};
///
/// struct Adaptive;
/// impl Render for Adaptive {
///     fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
///         container_query(|size, _, _| {
///             if size.width < px(240.) {
///                 div().size_full().bg(rgb(0x155b50)).child("Compact")
///             } else {
///                 div().size_full().bg(rgb(0x315ac6)).child("Full labels")
///             }
///         })
///     }
/// }
/// # let mut app = gpui::TestApp::new();
/// # let mut window = app.open_window(|_, _| Adaptive);
/// # for (width, color) in [(239., 0x155b50), (240., 0x315ac6), (480., 0x315ac6)] {
/// #     window.simulate_resize(gpui::size(px(width), px(96.)));
/// #     window.draw();
/// #     window.update(|_, window, _| {
/// #         let quad = window.painted_quads().into_iter()
/// #             .find(|quad| quad.background == rgb(color).into()).unwrap();
/// #         assert_eq!(quad.bounds.size, gpui::size(px(width), px(96.)).scale(window.scale_factor()));
/// #     });
/// # }
/// ```
///
/// # Sizing, style, and state
///
/// > [!WARNING]
/// > Give the query a resolved size through its parent or its own style.
/// > An auto-sized parent cannot discover the size of content created only
/// > after layout. The callback's definite available space also does not clip
/// > an oversized child; use a surrounding `div().overflow_hidden()` when needed.
///
/// Style on the query controls layout only. Paint the background, border, or
/// shadow on a surrounding div or on the subtree returned by the callback.
/// Put inherited text styling and opacity there too; the query does not apply
/// its own paint or text-style scope.
///
/// The callback is [`FnOnce`]. Construct a new query when the view renders,
/// and retain application state outside it. For a child present in both
/// layouts, keep its ID stable. For state that must survive removing the
/// child in one layout, use a longer-lived entity. Replacing a branch does
/// not transfer one child's state to another. See
/// [element identity](crate::_ownership_and_data_flow#give-retained-element-state-an-identity)
/// and the [layout chapter](crate::_documentation::layout).
pub fn container_query<E>(
    render: impl 'static + FnOnce(Size<Pixels>, &mut Window, &mut App) -> E,
) -> ContainerQuery
where
    E: IntoElement,
{
    let mut base_style = StyleRefinement::default();
    base_style.size.width = Some(relative(1.).into());
    base_style.size.height = Some(relative(1.).into());

    ContainerQuery {
        render: Some(Box::new(|size, window, cx| {
            render(size, window, cx).into_any_element()
        })),
        style: base_style,
    }
}

/// A layout box that constructs its contents from its resolved size.
///
/// Create it with [`container_query`]. The box is a leaf in its parent's layout;
/// during prepaint it creates and lays out a separate child subtree. Its
/// [`Styled`] implementation sets layout inputs, without painting decoration,
/// clipping content, or establishing inherited text styling.
///
/// The constructor documents the size dependency, width-boundary example,
/// and state-ownership rules. Use [`canvas`](crate::canvas) when only drawing
/// depends on the resolved bounds, rather than the choice of child elements.
pub struct ContainerQuery {
    render: Option<Box<dyn FnOnce(Size<Pixels>, &mut Window, &mut App) -> AnyElement>>,
    style: StyleRefinement,
}

impl Element for ContainerQuery {
    type RequestLayoutState = ();
    type PrepaintState = Option<AnyElement>;

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
    ) -> (LayoutId, Self::RequestLayoutState) {
        let mut style = Style::default();
        style.refine(&self.style);
        let layout_id = window.request_layout(style, [], cx);
        (layout_id, ())
    }

    fn prepaint(
        &mut self,
        _id: Option<&GlobalElementId>,
        _inspector_id: Option<&InspectorElementId>,
        bounds: Bounds<Pixels>,
        _request_layout: &mut Self::RequestLayoutState,
        window: &mut Window,
        cx: &mut App,
    ) -> Option<AnyElement> {
        let render = self.render.take()?;
        let mut child = render(bounds.size, window, cx);
        child.layout_as_root(bounds.size.map(AvailableSpace::Definite), window, cx);
        child.prepaint_at(bounds.origin, window, cx);
        Some(child)
    }

    fn paint(
        &mut self,
        _id: Option<&GlobalElementId>,
        _inspector_id: Option<&InspectorElementId>,
        _bounds: Bounds<Pixels>,
        _request_layout: &mut Self::RequestLayoutState,
        prepaint: &mut Self::PrepaintState,
        window: &mut Window,
        cx: &mut App,
    ) {
        if let Some(child) = prepaint {
            child.paint(window, cx);
        }
    }
}

impl IntoElement for ContainerQuery {
    type Element = Self;

    fn into_element(self) -> Self::Element {
        self
    }
}

impl Styled for ContainerQuery {
    fn style(&mut self) -> &mut StyleRefinement {
        &mut self.style
    }
}
