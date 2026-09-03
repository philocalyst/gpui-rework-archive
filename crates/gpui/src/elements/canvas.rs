use refineable::Refineable as _;

use crate::{
    App, Bounds, Element, ElementId, GlobalElementId, InspectorElementId, IntoElement, Pixels,
    Style, StyleRefinement, Styled, Window,
};

/// Construct a canvas element with the given paint callback.
/// Useful for adding short term custom drawing to a view.
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

/// A canvas element, meant for accessing the low level paint API without defining a whole
/// custom element
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

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{ParentElement, Styled, TestAppContext, div, point, px, size};
    use std::{cell::Cell, rc::Rc};

    fn canvas_with_counters(
        paint_count: Rc<Cell<usize>>,
        prepaint_bounds: Rc<Cell<Bounds<Pixels>>>,
    ) -> Canvas<()> {
        canvas(
            move |bounds, _, _| prepaint_bounds.set(bounds),
            move |_, _, _, _| paint_count.set(paint_count.get() + 1),
        )
        .size_full()
    }

    #[gpui::test]
    fn canvas_paint_callback_receives_bounds_and_fires_once_per_draw(cx: &mut TestAppContext) {
        let window = cx.add_empty_window();
        let paint_count = Rc::new(Cell::new(0));
        let prepaint_bounds = Rc::new(Cell::new(Bounds::default()));

        window.draw(point(px(0.), px(0.)), size(px(120.), px(60.)), {
            let paint_count = paint_count.clone();
            let prepaint_bounds = prepaint_bounds.clone();
            move |_, _| canvas_with_counters(paint_count, prepaint_bounds)
        });

        assert_eq!(
            paint_count.get(),
            1,
            "paint must fire during the first draw"
        );
        assert_eq!(prepaint_bounds.get().origin, point(px(0.), px(0.)));
        assert_eq!(prepaint_bounds.get().size, size(px(120.), px(60.)));

        // A fresh canvas element is built per frame, so a second draw re-runs
        // both callbacks against the new frame's bounds.
        window.draw(point(px(10.), px(20.)), size(px(50.), px(40.)), {
            let paint_count = paint_count.clone();
            let prepaint_bounds = prepaint_bounds.clone();
            move |_, _| canvas_with_counters(paint_count, prepaint_bounds)
        });

        assert_eq!(paint_count.get(), 2, "paint must fire on every draw");
        assert_eq!(prepaint_bounds.get().origin, point(px(10.), px(20.)));
        assert_eq!(prepaint_bounds.get().size, size(px(50.), px(40.)));
    }

    #[gpui::test]
    fn multiple_canvases_paint_independently(cx: &mut TestAppContext) {
        let window = cx.add_empty_window();
        let left_paints = Rc::new(Cell::new(0));
        let right_paints = Rc::new(Cell::new(0));
        let left_bounds = Rc::new(Cell::new(Bounds::default()));
        let right_bounds = Rc::new(Cell::new(Bounds::default()));

        window.draw(point(px(0.), px(0.)), size(px(200.), px(100.)), {
            let left_paints = left_paints.clone();
            let right_paints = right_paints.clone();
            let left_bounds = left_bounds.clone();
            let right_bounds = right_bounds.clone();
            move |_, _| {
                div()
                    .flex()
                    .size_full()
                    .child(canvas_with_counters(left_paints, left_bounds))
                    .child(canvas_with_counters(right_paints, right_bounds))
            }
        });

        assert_eq!(left_paints.get(), 1);
        assert_eq!(right_paints.get(), 1);
        assert_eq!(left_bounds.get().size, size(px(100.), px(100.)));
        assert_eq!(right_bounds.get().size, size(px(100.), px(100.)));
        assert_eq!(left_bounds.get().origin, point(px(0.), px(0.)));
        assert_eq!(right_bounds.get().origin, point(px(100.), px(0.)));

        // Each canvas keeps its own callbacks; painting one side again does not
        // re-run the other side's closure.
        let draw_left_paints = left_paints.clone();
        window.draw(
            point(px(0.), px(0.)),
            size(px(200.), px(100.)),
            move |_, _| {
                div()
                    .flex()
                    .size_full()
                    .child(canvas_with_counters(draw_left_paints, left_bounds))
            },
        );

        assert_eq!(left_paints.get(), 2);
        assert_eq!(right_paints.get(), 1);
    }
}
