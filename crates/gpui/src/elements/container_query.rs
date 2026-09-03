//! A container query element, in the spirit of CSS container queries.
//! The element's own size is determined solely by its style and the space
//! offered by its parent.

use refineable::Refineable as _;

use crate::{
    AnyElement, App, AvailableSpace, Bounds, Element, ElementId, GlobalElementId,
    InspectorElementId, IntoElement, LayoutId, Pixels, Size, Style, StyleRefinement, Styled,
    Window, relative,
};

/// Construct a container query element with the given render callback.
/// The callback receives the size the element was assigned during layout and
/// returns the contents to display within it.
///
/// By default the element fills its parent (equivalent to `.size_full()`);
/// use the [`Styled`] methods to size it differently. Because the contents
/// don't exist until after layout, they cannot influence the element's size.
///
/// # Example
///
/// ```
/// # use gpui::{container_query, div, px, IntoElement, ParentElement};
/// container_query(|size, _window, _cx| {
///     if size.width < px(240.) {
///         div().child("Narrow layout")
///     } else {
///         div().child("Wide layout")
///     }
/// });
/// ```
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

/// A container query element, created with [`container_query`].
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

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{TestAppContext, div, point, px, size};
    use std::{cell::Cell, rc::Rc};

    #[gpui::test]
    fn width_threshold_selects_variants(cx: &mut TestAppContext) {
        // The render callback observes the size assigned during layout, so the
        // element can branch on a width threshold the way CSS container queries do.
        let cases = [(200.0, "narrow"), (240.0, "wide"), (400.0, "wide")];
        for (width, expected) in cases {
            let window = cx.add_empty_window();
            let selected = Rc::new(Cell::new(""));
            let selected_for_render = selected.clone();
            window.draw(
                point(px(0.), px(0.)),
                size(px(width), px(50.)),
                move |_, _| {
                    container_query(move |size, _, _| {
                        selected_for_render.set(if size.width < px(240.) {
                            "narrow"
                        } else {
                            "wide"
                        });
                        div().size_full()
                    })
                },
            );

            assert_eq!(
                selected.get(),
                expected,
                "width {width}px should select the {expected} variant"
            );
        }
    }
}
