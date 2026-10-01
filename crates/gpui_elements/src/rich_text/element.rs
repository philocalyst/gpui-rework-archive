//! GPUI element bridge for immutable rich text.

use super::RichText;
use gpui::{
    App, AppContext, Bounds, CursorStyle, DispatchPhase, Element, ElementId, Hitbox,
    HitboxBehavior, IntoElement, LayoutId, MouseButton, MouseDownEvent, MouseMoveEvent,
    MouseUpEvent, StyledText, Window,
};
use std::{cell::Cell, rc::Rc};

/// A read-only rich text value that delegates shaping and painting to GPUI's `StyledText`.
///
/// Construct this through [`IntoElement`] on a finished [`RichText`]. Inline styles are lowered
/// against the current inherited GPUI text style each time layout is requested, so parent style
/// refinements and font changes are reflected on every frame.
pub struct RichTextElement {
    rich_text: RichText,
    id: Option<ElementId>,
    styled_text: Option<StyledText>,
    click_byte_listener: Option<ClickByteListener>,
    hover_byte_listener: Option<HoverByteListener>,
}

type ClickByteListener = Box<dyn Fn(RichTextClick, MouseUpEvent, &mut Window, &mut App) + 'static>;
type HoverByteListener =
    Box<dyn Fn(Option<usize>, MouseMoveEvent, &mut Window, &mut App) + 'static>;

/// UTF-8 byte boundaries under the mouse-down and mouse-up positions of a text click.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct RichTextClick {
    /// The byte boundary under the mouse-down position.
    pub down_byte: usize,
    /// The byte boundary under the mouse-up position.
    pub up_byte: usize,
}

#[derive(Default)]
struct RichTextInteractionState {
    mouse_down_byte: Rc<Cell<Option<usize>>>,
    hovered_byte: Rc<Cell<Option<usize>>>,
}

impl RichTextElement {
    /// Gives this text element an accessibility label node and stable interaction identity.
    ///
    /// Interactive rich text requires a stable ID because GPUI stores its interaction state by
    /// element ID. Set it with `.id(...)` anywhere in the builder chain when adding listeners.
    pub fn id(mut self, id: impl Into<ElementId>) -> Self {
        self.id = Some(id.into());
        self
    }

    /// Calls `listener` when a primary click starts and ends over text glyphs in this element.
    ///
    /// The click payload contains UTF-8 byte boundaries under both positions. The mouse-down and
    /// mouse-up must both land in this element's hitbox and over shaped text. Consumers can use
    /// both offsets to check that a click began and ended in the same range of their own
    /// [`crate::rich_text::RangeSet`].
    ///
    /// This listener requires a stable ID set with [`Self::id`].
    pub fn on_click_byte(
        mut self,
        listener: impl Fn(RichTextClick, MouseUpEvent, &mut Window, &mut App) + 'static,
    ) -> Self {
        self.click_byte_listener = Some(Box::new(listener));
        self
    }

    /// Calls `listener` when the pointer moves to a different text byte or leaves shaped text.
    ///
    /// The optional offset is a UTF-8 byte boundary in the original text. It is `None` when the
    /// pointer leaves the element or falls outside the shaped text. Wrapped lines are mapped
    /// through GPUI's text layout, so the result remains an original-text byte offset.
    ///
    /// This listener requires a stable ID set with [`Self::id`].
    pub fn on_hover_byte(
        mut self,
        listener: impl Fn(Option<usize>, MouseMoveEvent, &mut Window, &mut App) + 'static,
    ) -> Self {
        self.hover_byte_listener = Some(Box::new(listener));
        self
    }

    fn is_interactive(&self) -> bool {
        self.click_byte_listener.is_some() || self.hover_byte_listener.is_some()
    }
}

impl IntoElement for RichText {
    type Element = RichTextElement;

    fn into_element(self) -> Self::Element {
        RichTextElement {
            rich_text: self,
            id: None,
            styled_text: None,
            click_byte_listener: None,
            hover_byte_listener: None,
        }
    }
}

impl IntoElement for RichTextElement {
    type Element = Self;

    fn into_element(self) -> Self::Element {
        self
    }
}

impl Element for RichTextElement {
    type RequestLayoutState = ();
    type PrepaintState = Option<Hitbox>;

    fn id(&self) -> Option<ElementId> {
        self.id.clone()
    }

    fn source_location(&self) -> Option<&'static std::panic::Location<'static>> {
        None
    }

    fn a11y_role(&self) -> Option<gpui::accesskit::Role> {
        self.id.as_ref().map(|_| gpui::accesskit::Role::Label)
    }

    fn write_a11y_info(&self, node: &mut gpui::accesskit::Node) {
        node.set_value(self.rich_text.as_str().to_owned());
    }

    fn request_layout(
        &mut self,
        global_id: Option<&gpui::GlobalElementId>,
        inspector_id: Option<&gpui::InspectorElementId>,
        window: &mut Window,
        cx: &mut App,
    ) -> (LayoutId, Self::RequestLayoutState) {
        assert!(
            !self.is_interactive() || self.id.is_some(),
            "interactive RichTextElement requires a stable `.id(...)`"
        );
        let runs = self.rich_text.text_runs(&window.text_style());
        let mut styled_text = StyledText::new(self.rich_text.shared_string()).with_runs(runs);
        let (layout_id, state) = <StyledText as Element>::request_layout(
            &mut styled_text,
            global_id,
            inspector_id,
            window,
            cx,
        );
        self.styled_text = Some(styled_text);
        (layout_id, state)
    }

    fn prepaint(
        &mut self,
        global_id: Option<&gpui::GlobalElementId>,
        inspector_id: Option<&gpui::InspectorElementId>,
        bounds: Bounds<gpui::Pixels>,
        request_layout: &mut Self::RequestLayoutState,
        window: &mut Window,
        cx: &mut App,
    ) -> Self::PrepaintState {
        let styled_text = self
            .styled_text
            .as_mut()
            .expect("request_layout must run before prepaint");
        <StyledText as Element>::prepaint(
            styled_text,
            global_id,
            inspector_id,
            bounds,
            request_layout,
            window,
            cx,
        );
        self.is_interactive()
            .then(|| window.insert_hitbox(bounds, HitboxBehavior::Normal))
    }

    fn paint(
        &mut self,
        global_id: Option<&gpui::GlobalElementId>,
        inspector_id: Option<&gpui::InspectorElementId>,
        bounds: Bounds<gpui::Pixels>,
        request_layout: &mut Self::RequestLayoutState,
        prepaint: &mut Self::PrepaintState,
        window: &mut Window,
        cx: &mut App,
    ) {
        let is_interactive = self.is_interactive();
        let styled_text = self
            .styled_text
            .as_mut()
            .expect("request_layout must run before paint");
        if !is_interactive {
            return <StyledText as Element>::paint(
                styled_text,
                global_id,
                inspector_id,
                bounds,
                request_layout,
                &mut (),
                window,
                cx,
            );
        }

        let global_id = global_id.expect("interactive rich text requires a stable `.id(...)`");
        let hitbox = prepaint
            .as_ref()
            .expect("interactive rich text must have a hitbox from prepaint")
            .clone();
        let text_layout = styled_text.layout().clone();
        let click_listener = self.click_byte_listener.take();
        let hover_listener = self.hover_byte_listener.take();
        let current_view = window.current_view();

        window.with_element_state::<RichTextInteractionState, _>(global_id, |state, window| {
            let state = state.unwrap_or_default();
            let mouse_down_byte = state.mouse_down_byte.clone();
            let hovered_byte = state.hovered_byte.clone();

            if let Some(click_listener) = click_listener {
                let down_hitbox = hitbox.clone();
                let down_layout = text_layout.clone();
                let down_byte = mouse_down_byte.clone();
                window.on_mouse_event(move |event: &MouseDownEvent, phase, window, _cx| {
                    if phase == DispatchPhase::Bubble {
                        let byte = if event.button == MouseButton::Left
                            && down_hitbox.is_hovered(window)
                        {
                            down_layout.index_for_position(event.position).ok()
                        } else {
                            None
                        };
                        down_byte.set(byte);
                        if byte.is_some() {
                            window.refresh();
                        }
                    }
                });

                let up_hitbox = hitbox.clone();
                let up_layout = text_layout.clone();
                let up_byte = mouse_down_byte;
                window.on_mouse_event(move |event: &MouseUpEvent, phase, window, cx| {
                    if phase != DispatchPhase::Bubble {
                        return;
                    }
                    if let Some(down_byte) = up_byte.take() {
                        window.refresh();
                        if event.button == MouseButton::Left
                            && up_hitbox.is_hovered(window)
                            && let Ok(byte) = up_layout.index_for_position(event.position)
                        {
                            click_listener(
                                RichTextClick {
                                    down_byte,
                                    up_byte: byte,
                                },
                                event.clone(),
                                window,
                                cx,
                            );
                        }
                    }
                });

                if hitbox.is_hovered(window)
                    && text_layout
                        .index_for_position(window.mouse_position())
                        .is_ok()
                {
                    window.set_cursor_style(CursorStyle::PointingHand, &hitbox);
                }
            } else {
                mouse_down_byte.set(None);
            }

            if let Some(hover_listener) = hover_listener {
                let hover_hitbox = hitbox.clone();
                let hover_layout = text_layout.clone();
                let hover_byte = hovered_byte;
                window.on_mouse_event(move |event: &MouseMoveEvent, phase, window, cx| {
                    if phase != DispatchPhase::Bubble {
                        return;
                    }
                    let current = hover_byte.get();
                    let updated = if hover_hitbox.is_hovered(window) {
                        hover_layout.index_for_position(event.position).ok()
                    } else {
                        None
                    };
                    if current != updated {
                        hover_byte.set(updated);
                        hover_listener(updated, event.clone(), window, cx);
                        cx.notify(current_view);
                    }
                });
            } else {
                hovered_byte.set(None);
            }

            <StyledText as Element>::paint(
                styled_text,
                Some(global_id),
                inspector_id,
                bounds,
                request_layout,
                &mut (),
                window,
                cx,
            );
            ((), state)
        });
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::rich_text::{Affinity, RangeSet, Span};
    use gpui::{
        Context, Modifiers, ParentElement, Render, Styled, TestAppContext, TextLayout, div, point,
        px,
    };
    use std::{cell::RefCell, rc::Rc};

    struct LayoutCaptureElement {
        inner: RichTextElement,
        layout: Rc<RefCell<Option<TextLayout>>>,
    }

    impl IntoElement for LayoutCaptureElement {
        type Element = Self;

        fn into_element(self) -> Self::Element {
            self
        }
    }

    impl Element for LayoutCaptureElement {
        type RequestLayoutState = ();
        type PrepaintState = Option<Hitbox>;

        fn id(&self) -> Option<ElementId> {
            <RichTextElement as Element>::id(&self.inner)
        }

        fn source_location(&self) -> Option<&'static std::panic::Location<'static>> {
            None
        }

        fn request_layout(
            &mut self,
            global_id: Option<&gpui::GlobalElementId>,
            inspector_id: Option<&gpui::InspectorElementId>,
            window: &mut Window,
            cx: &mut App,
        ) -> (LayoutId, Self::RequestLayoutState) {
            let result = self
                .inner
                .request_layout(global_id, inspector_id, window, cx);
            *self.layout.borrow_mut() = Some(
                self.inner
                    .styled_text
                    .as_ref()
                    .expect("RichTextElement builds StyledText during layout")
                    .layout()
                    .clone(),
            );
            result
        }

        fn prepaint(
            &mut self,
            global_id: Option<&gpui::GlobalElementId>,
            inspector_id: Option<&gpui::InspectorElementId>,
            bounds: Bounds<gpui::Pixels>,
            request_layout: &mut Self::RequestLayoutState,
            window: &mut Window,
            cx: &mut App,
        ) -> Self::PrepaintState {
            self.inner
                .prepaint(global_id, inspector_id, bounds, request_layout, window, cx)
        }

        fn paint(
            &mut self,
            global_id: Option<&gpui::GlobalElementId>,
            inspector_id: Option<&gpui::InspectorElementId>,
            bounds: Bounds<gpui::Pixels>,
            request_layout: &mut Self::RequestLayoutState,
            prepaint: &mut Self::PrepaintState,
            window: &mut Window,
            cx: &mut App,
        ) {
            self.inner.paint(
                global_id,
                inspector_id,
                bounds,
                request_layout,
                prepaint,
                window,
                cx,
            );
        }
    }

    struct InteractiveTextView {
        text: RichText,
        layout: Rc<RefCell<Option<TextLayout>>>,
        clicks: Rc<RefCell<Vec<RichTextClick>>>,
        hovered_bytes: Rc<RefCell<Vec<Option<usize>>>>,
        links: RangeSet<&'static str>,
    }

    impl Render for InteractiveTextView {
        fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
            let clicks = self.clicks.clone();
            let hovered_bytes = self.hovered_bytes.clone();
            let links = self.links.clone();
            let inner = self
                .text
                .clone()
                .into_element()
                .id("interactive-rich-text")
                .on_click_byte(move |click, _event, _window, _cx| {
                    let down_target = links.hit(click.down_byte).next().map(|span| *span.value());
                    let up_target = links.hit(click.up_byte).next().map(|span| *span.value());
                    if down_target.is_some() && down_target == up_target {
                        clicks.borrow_mut().push(click);
                    }
                })
                .on_hover_byte(move |byte, _event, _window, _cx| {
                    hovered_bytes.borrow_mut().push(byte);
                });
            // A column stretches this single text child to the constrained width. The
            // line-wrapper fixture below has explicit word boundaries; a narrow, unbroken
            // token can overflow as one word without creating a wrapped line.
            div()
                .flex_col()
                .w(px(72.))
                .whitespace_normal()
                .child(LayoutCaptureElement {
                    inner,
                    layout: self.layout.clone(),
                })
        }
    }

    #[gpui::test]
    fn interactions_report_wrapped_utf8_offsets_and_clear_hover_outside_text(
        cx: &mut TestAppContext,
    ) {
        let text = RichText::new()
            .text("é aa bbbbbb cccccc dddddd eeee ffff")
            .finish();
        let text_contents = text.as_str().to_owned();
        let links = RangeSet::new([Span::new(
            "é ".len()..text_contents.len(),
            Affinity::Before,
            Affinity::After,
            "example-link",
        )]);
        let layout = Rc::new(RefCell::new(None));
        let clicks = Rc::new(RefCell::new(Vec::new()));
        let hovered_bytes = Rc::new(RefCell::new(Vec::new()));
        let (_view, window) = cx.add_window_view({
            let layout = layout.clone();
            let clicks = clicks.clone();
            let hovered_bytes = hovered_bytes.clone();
            let links = links.clone();
            move |_, _| InteractiveTextView {
                text,
                layout,
                clicks,
                hovered_bytes,
                links,
            }
        });

        let shaped_layout = layout
            .borrow()
            .as_ref()
            .expect("RichTextElement layout was captured")
            .clone();
        let first_line_y = shaped_layout
            .position_for_index(0)
            .expect("text has an initial position")
            .y;
        let (hit_position, expected_byte) = (0..=text_contents.len())
            .filter(|&byte| text_contents.is_char_boundary(byte))
            .find_map(|byte| {
                let position = shaped_layout.position_for_index(byte)?;
                if position.y <= first_line_y {
                    return None;
                }
                let position = position + point(px(1.), shaped_layout.line_height() / 2.);
                shaped_layout
                    .index_for_position(position)
                    .ok()
                    .map(|hit| (position, hit))
            })
            .expect("narrow layout wraps text and exposes a glyph on the next line");
        assert!(expected_byte >= "é ".len());
        assert!(text_contents.is_char_boundary(expected_byte));

        window.simulate_mouse_move(hit_position, None, Modifiers::none());
        assert_eq!(hovered_bytes.borrow().last(), Some(&Some(expected_byte)));

        let first_position = shaped_layout
            .position_for_index(0)
            .expect("text has an initial glyph")
            + point(px(1.), shaped_layout.line_height() / 2.);
        let first_byte = shaped_layout
            .index_for_position(first_position)
            .expect("the first glyph has a hit-testable byte");
        assert!(links.hit(first_byte).next().is_none());

        // A drag from plain text into the link range reaches the callback with both source
        // coordinates, allowing the consumer-owned range set to reject the activation.
        window.simulate_mouse_down(first_position, MouseButton::Left, Modifiers::none());
        window.simulate_mouse_up(hit_position, MouseButton::Left, Modifiers::none());
        assert!(clicks.borrow().is_empty());

        window.simulate_mouse_down(hit_position, MouseButton::Left, Modifiers::none());
        window.simulate_mouse_up(hit_position, MouseButton::Left, Modifiers::none());
        assert_eq!(
            clicks.borrow().as_slice(),
            [RichTextClick {
                down_byte: expected_byte,
                up_byte: expected_byte,
            }]
        );

        let bounds = shaped_layout.bounds();
        let outside_text = (1..100)
            .map(|step| {
                point(
                    bounds.left() + bounds.size.width * (step as f32 / 100.),
                    first_line_y + shaped_layout.line_height() / 2.,
                )
            })
            .find(|position| {
                bounds.contains(position) && shaped_layout.index_for_position(*position).is_err()
            })
            .expect("the first wrapped line has whitespace outside its shaped glyphs");
        window.simulate_mouse_move(outside_text, None, Modifiers::none());
        assert_eq!(hovered_bytes.borrow().last(), Some(&None));
    }
}
