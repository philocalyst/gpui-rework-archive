use crate::editable_text::{
    BLINK_INTERVAL_500MS, Caret, EditableTextState, TabBehavior,
    actions::{DEFAULT_INPUT_CONTEXT, EditableTextActionElement, EditableTextActionHandler},
    layout::{EditableTextLayoutResult, EditableTextLayoutState, TextLineSegment},
};
use gpui::{
    App, Bounds, CursorStyle, DefiniteLength, DispatchPhase, Display, Element, ElementId,
    ElementInputHandler, Entity, FocusHandle, Focusable, Hitbox, HitboxBehavior, Hsla,
    InteractiveElement, Interactivity, IntoElement, LayoutId, MouseButton, MouseDownEvent,
    MouseMoveEvent, MouseUpEvent, PaintQuad, Pixels, Point, SharedString, Size,
    StatefulInteractiveElement, Style, StyleRefinement, Styled, TextAlign, TextLayout, WeakEntity,
    Window, WrappedLine, fill, point, px, relative, size,
};
use palette::IntoColor;
use smallvec::SmallVec;
use std::{cell::RefCell, ops::Range, rc::Rc, sync::Arc, time::Duration};

/// Creates a text input element.
/// See [`EditableTextElement`] for usage.
///
/// By default it is multiline, and therefore this is semantically equivalent to [`text_area`].
#[track_caller]
pub fn editable_text(id: impl Into<ElementId>) -> EditableTextElement {
    let mut this = EditableTextElement {
        interactivity: Interactivity::default(),
        state_entity: Rc::new(RefCell::new(WeakEntity::new_invalid())),
        supports_multiline: true,
        placeholder: None,
        accepts_input: true,
        colors: EditableTextColors::default(),
        caret_blink_interval: None,
        caret_width: px(2.),
        caret_height: relative(1.).into(),
        tab_behavior: TabBehavior::default(),
    };
    this.interactivity.element_id = Some(id.into());

    this = this.key_context(DEFAULT_INPUT_CONTEXT);
    this.register_actions();

    this
}

/// Creates a singleline text input element.
/// See [`EditableTextElement`] for usage.
#[track_caller]
pub fn text_input(id: impl Into<ElementId>) -> EditableTextElement {
    editable_text(id).multiline(false)
}

/// Creates a multiline text input element.
/// See [`EditableTextElement`] for usage.
#[track_caller]
pub fn text_area(id: impl Into<ElementId>) -> EditableTextElement {
    editable_text(id).multiline(true)
}

/// An input field which users can type text into.
pub struct EditableTextElement {
    interactivity: Interactivity,
    // Populated on first render with an entity stored/attached to the view.
    // This reference is shared with the action handlers, which are processed between renders
    // and therefore cannot otherwise access state attached to the view.
    state_entity: Rc<RefCell<WeakEntity<EditableTextState>>>,
    supports_multiline: bool,
    placeholder: Option<SharedString>,
    accepts_input: bool,
    colors: EditableTextColors,
    caret_blink_interval: Option<Duration>,
    caret_width: Pixels,
    caret_height: DefiniteLength,
    tab_behavior: TabBehavior,
}

/// EditableText styling that goes beyond what Style/StyleRefinement supports
struct EditableTextColors {
    /// Color of the placeholder text when the storage is empty.
    /// Could be reconceived as a refinement of text_color when the field is empty
    placeholder: Hsla,
    /// Color of the selection box.
    /// Could be driven by platform-provided styling?
    selection: Hsla,
    /// Color of the caret / text cursor
    caret: Hsla,
    /// Color of IME marked underlines
    ime_underline: Hsla,
}
impl Default for EditableTextColors {
    fn default() -> Self {
        use palette::RgbHue;
        const WHITE_50PC: Hsla = Hsla::new_const(RgbHue::new(0.), 0., 1., 0.5);
        const WHITE_70PC: Hsla = Hsla::new_const(RgbHue::new(0.), 0., 1., 0.7);
        // approx rgb(38 79 120) or oklch(41.9% 0.0829 250.4)
        const LIGHT_NAVY_BLUE_50PC: Hsla = Hsla::new_const(RgbHue::new(210.), 0.519, 0.31, 0.5);
        Self {
            placeholder: WHITE_50PC,
            selection: LIGHT_NAVY_BLUE_50PC,
            caret: gpui::white(),
            ime_underline: WHITE_70PC,
        }
    }
}

impl EditableTextElement {
    /// Assigns the underlying state of this element, which should persist across multiple frames.
    /// The user should either create the entity once or utilize `Window::use_keyed_state`
    /// to create an entity intrinsicly linked to the element.
    /// If no state is configured, one will be linked to this element on first render via `Window::use_keyed_state`.
    pub fn state(self, state: WeakEntity<EditableTextState>) -> Self {
        *self.state_entity.borrow_mut() = state;
        self
    }

    /// Configures whether the field supports multiple lines of text.
    /// Disabling this prevents actions like `enter` and navigating up and down.
    ///
    /// Incoming newlines are removed from single-line fields, including pasted and IME text.
    pub fn multiline(mut self, enabled: bool) -> Self {
        self.supports_multiline = enabled;
        self
    }

    /// Assigns the text that should be displayed when storage of the element is empty.
    pub fn placeholder(mut self, text: impl Into<SharedString>) -> Self {
        self.placeholder = Some(text.into());
        self
    }

    /// Configures whether the element can accept input (effectively means "is the element currently enabled").
    pub fn accepts_input(mut self, enabled: bool) -> Self {
        self.accepts_input = enabled;
        self
    }

    /// Configures whether Tab inserts `\t` or moves focus through the window's tab stops.
    /// The default remains inserting a tab character for compatibility.
    pub fn tab_behavior(mut self, behavior: TabBehavior) -> Self {
        self.tab_behavior = behavior;
        self
    }

    /// Sets the blinking interval of the caret.
    pub fn caret_blink_interval(mut self, duration: Duration) -> Self {
        self.caret_blink_interval = Some(duration);
        self
    }

    /// Sets the blinking interval of the caret to 500ms
    pub fn caret_blink_interval_500ms(self) -> Self {
        self.caret_blink_interval(BLINK_INTERVAL_500MS)
    }

    /// Sets the color of the placeholder text which is rendered when the element's stored text is empty.
    ///
    /// Cannot be refined via [`StyleRefinement`](gpui::StyleRefinement) due to limitations in the fields of [`Style`](gpui::Style).
    pub fn placeholder_color(mut self, color: impl IntoColor<Hsla>) -> Self {
        self.colors.placeholder = color.into_color();
        self
    }

    /// Sets the width of the caret / text-cursor.
    pub fn caret_w(mut self, width: impl Into<Pixels>) -> Self {
        self.caret_width = width.into();
        self
    }

    /// Sets the height of the caret / text-cursor.
    ///
    /// Relative lengths are resolved against the current line height. The default is
    /// `relative(1.)`, which makes the caret as tall as the line.
    pub fn caret_h(mut self, height: impl Into<DefiniteLength>) -> Self {
        self.caret_height = height.into();
        self
    }

    /// Sets the color of the box highlighting selected text.
    ///
    /// Cannot be refined via [`StyleRefinement`](gpui::StyleRefinement) due to limitations in the fields of [`Style`](gpui::Style).
    pub fn selection_color(mut self, color: Hsla) -> Self {
        self.colors.selection = color;
        self
    }

    /// Sets the color of the caret / text-cursor.
    ///
    /// Cannot be refined via [`StyleRefinement`](gpui::StyleRefinement) due to limitations in the fields of [`Style`](gpui::Style).
    pub fn caret_color(mut self, color: Hsla) -> Self {
        self.colors.caret = color;
        self
    }

    /// Sets the color of the underlines rendered underneath text being editted/marked by InputMethodEditors
    /// (for writing Chinese, Japanese, and Korean utf-16).
    ///
    /// Cannot be refined via [`StyleRefinement`](gpui::StyleRefinement) due to limitations in the fields of [`Style`](gpui::Style).
    pub fn marked_color(mut self, color: Hsla) -> Self {
        self.colors.ime_underline = color;
        self
    }
}

#[cfg(test)]
mod mouse_hit_test_tests {
    use super::*;
    use crate::editable_text::StringStorage;
    use gpui::{Context, Modifiers, Render, TestAppContext, Window, point, prelude::*};

    struct InputView {
        state: Entity<EditableTextState>,
    }

    impl Render for InputView {
        fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
            text_input("mouse-hit-test")
                .state(self.state.downgrade())
                .w(px(300.))
                .h(px(48.))
                .p(px(12.))
        }
    }

    fn input_view<'a>(
        cx: &'a mut TestAppContext,
        text: &str,
    ) -> (Entity<InputView>, &'a mut gpui::VisualTestContext) {
        cx.update(crate::init);
        let text = text.to_owned();
        let (view, cx) = cx.add_window_view(move |_, cx| InputView {
            state: cx.new(|cx| EditableTextState::new(StringStorage::from(text), cx)),
        });
        cx.update(|window, _| window.activate());
        cx.run_until_parked();
        (view, cx)
    }

    #[gpui::test]
    fn clicking_text_midpoint_places_caret_at_midpoint_despite_padding(cx: &mut TestAppContext) {
        let text = "clicking the middle should place the caret here";
        let (view, cx) = input_view(cx, text);
        cx.simulate_click(point(px(160.), px(24.)), Modifiers::none());

        let caret = cx.update(|_, app| view.read(app).state.read(app).caret_pos());
        assert!(
            caret > 8 && caret < text.len() - 8,
            "caret was at byte {caret}"
        );
    }

    #[gpui::test]
    fn queued_window_point_places_caret_after_the_field_is_first_laid_out(cx: &mut TestAppContext) {
        cx.update(crate::init);
        let text = "the first click position survives entering edit mode";
        let text_for_view = text.to_owned();
        let (view, cx) = cx.add_window_view(move |_, cx| {
            let state = cx.new(|cx| {
                let mut state = EditableTextState::new(StringStorage::from(text_for_view), cx);
                state.place_caret_at_window_position(point(px(160.), px(24.)), cx);
                state
            });
            InputView { state }
        });
        cx.update(|window, _| window.activate());
        cx.run_until_parked();

        let caret = cx.update(|_, app| view.read(app).state.read(app).caret_pos());
        assert!(
            caret > 8 && caret < text.len() - 8,
            "queued click placed caret at byte {caret}"
        );
    }

    #[gpui::test]
    fn mouse_selection_uses_utf8_boundaries_and_supports_shift_click_and_drag(
        cx: &mut TestAppContext,
    ) {
        let text = "a🙂bcdefghijklmnopqrstuvwxyz";
        let (view, cx) = input_view(cx, text);

        let anchor = point(px(36.), px(24.));
        cx.simulate_click(anchor, Modifiers::none());
        let anchor_caret = cx.update(|_, app| view.read(app).state.read(app).caret_pos());
        assert!(text.is_char_boundary(anchor_caret));

        cx.simulate_click(point(px(125.), px(24.)), Modifiers::shift());
        let shifted_caret = cx.update(|_, app| view.read(app).state.read(app).caret_pos());
        assert!(shifted_caret > anchor_caret);
        assert!(text.is_char_boundary(shifted_caret));

        cx.simulate_mouse_down(anchor, gpui::MouseButton::Left, Modifiers::none());
        let target = point(px(180.), px(24.));
        cx.simulate_mouse_move(target, Some(gpui::MouseButton::Left), Modifiers::none());
        cx.simulate_mouse_move(target, Some(gpui::MouseButton::Left), Modifiers::none());
        cx.simulate_mouse_up(target, gpui::MouseButton::Left, Modifiers::none());
        let dragged_caret = cx.update(|_, app| view.read(app).state.read(app).caret_pos());
        assert!(dragged_caret > anchor_caret);
        assert!(text.is_char_boundary(dragged_caret));
    }
}

impl InteractiveElement for EditableTextElement {
    fn interactivity(&mut self) -> &mut Interactivity {
        &mut self.interactivity
    }
}

// forced implementation since the API for the element doesnt use Stateful<Element>
impl StatefulInteractiveElement for EditableTextElement {}

impl Styled for EditableTextElement {
    fn style(&mut self) -> &mut StyleRefinement {
        &mut self.interactivity.base_style
    }
}

impl IntoElement for EditableTextElement {
    type Element = Self;
    fn into_element(self) -> Self::Element {
        self
    }
}

impl EditableTextActionElement<EditableTextState> for EditableTextElement {
    fn state_entity_rc(&self) -> &Rc<RefCell<WeakEntity<EditableTextState>>> {
        &self.state_entity
    }
}

struct PrelayoutState {
    state: Entity<EditableTextState>,
    prev_layout_state: EditableTextLayoutState,
    storage_version: u16,
    show_placeholder: bool,
    text: Option<SharedString>,
    placeholder_color: Hsla,
    supports_multiline: bool,
    accepts_input: bool,
}

#[doc(hidden)]
pub struct LayoutState {
    state: Entity<EditableTextState>,
    caret: Entity<Caret>,
}

struct InteractivityPrepaint {
    hitbox: Option<Hitbox>,
    scroll_offset: Point<Pixels>,
    inner_bounds: Bounds<Pixels>,
    caret_visible: bool,
}

/// Internal type containing prepaint information used to paint the element
#[doc(hidden)]
pub struct PrepaintState {
    interactivity: InteractivityPrepaint,
    focus_handle: FocusHandle,
    elements: PrepaintElements,
}

impl Element for EditableTextElement {
    type RequestLayoutState = LayoutState;
    type PrepaintState = PrepaintState;

    fn id(&self) -> Option<ElementId> {
        self.interactivity.element_id.clone()
    }

    fn source_location(&self) -> Option<&'static std::panic::Location<'static>> {
        self.interactivity.source_location()
    }

    fn request_layout(
        &mut self,
        global_id: Option<&gpui::GlobalElementId>,
        inspector_id: Option<&gpui::InspectorElementId>,
        window: &mut Window,
        cx: &mut App,
    ) -> (gpui::LayoutId, Self::RequestLayoutState) {
        let entity = self.find_or_create_state(window, cx);
        entity.update(cx, |state, _| state.tab_behavior = self.tab_behavior);
        let focus_out_subscription = entity.read(cx).focus_out_subscription.is_none();
        if focus_out_subscription {
            let focus_handle = entity.read(cx).focus_handle(cx);
            let weak_state = entity.downgrade();
            let subscription = window.on_focus_out(&focus_handle, cx, move |_, _, cx| {
                let _ = weak_state.update(cx, |state, cx| state.emit_blur(cx));
            });
            entity.update(cx, |state, _| {
                state.focus_out_subscription = Some(subscription)
            });
        }
        let caret = self.find_or_create_caret(&entity, window, cx);

        if let Some(duration) = self.caret_blink_interval.take()
            && caret.read(cx).blink_interval() != duration
        {
            caret.update(cx, |caret, _cx| caret.set_blink_interval(duration));
        }

        // Read new state information from the underlying entity.
        // Block-wrapped so that the state being read is dropped before continuing.
        let (prelayout, next_scroll_offset) = {
            let state = entity.read(cx);
            let show_placeholder = state.as_str().is_empty();
            let text = match show_placeholder {
                false => Some(SharedString::from(state.as_str())),
                true => self.placeholder.clone(),
            };

            let prelayout = PrelayoutState {
                state: entity.clone(),
                prev_layout_state: state.layout_data.state,
                show_placeholder,
                storage_version: state.version(),
                text,
                placeholder_color: self.colors.placeholder,
                supports_multiline: self.supports_multiline,
                accepts_input: self.accepts_input,
            };
            (prelayout, state.layout_data.next_scroll_offset)
        };

        // Update the scroll offset of the element when the user's caret goes out of scope.
        if let Some(scroll_offset) = next_scroll_offset {
            self.interactivity
                .set_scroll_offset(global_id, window, -scroll_offset);

            // Clear scroll_layout here in the very likely event that we wont need to
            // recompute layout, in which case the layout result isnt rebuilt during `perform_text_layout`.
            entity.update(cx, |state, _cx| {
                state.layout_data.next_scroll_offset = None;
            });
        }

        let layout_id = self.interactivity.request_layout(
            global_id,
            inspector_id,
            window,
            cx,
            |style, window, cx| {
                window.with_text_style(style.text_style().cloned(), move |window| {
                    let text_layout_id = prelayout.perform_text_layout(window);
                    window.request_layout(style.clone(), Some(text_layout_id), cx)
                })
            },
        );

        (
            layout_id,
            LayoutState {
                state: entity,
                caret,
            },
        )
    }

    fn prepaint(
        &mut self,
        global_id: Option<&gpui::GlobalElementId>,
        inspector_id: Option<&gpui::InspectorElementId>,
        bounds: Bounds<Pixels>,
        request_layout: &mut Self::RequestLayoutState,
        window: &mut Window,
        cx: &mut App,
    ) -> Self::PrepaintState {
        // should reflect the text content layout size of the stored text,
        // so that scrolling can take it into account during prepaint.
        let (content_size, focus_handle) = {
            let state = request_layout.state.read(cx);
            let content_size = state.layout_data.state.size.unwrap_or_else(|| bounds.size);
            let focus_handle = state.focus_handle(cx);
            (content_size, focus_handle)
        };

        let is_focused = focus_handle.is_focused(window);
        let caret_visible = request_layout
            .caret
            .update(cx, |caret, cx| caret.update_focus(is_focused, cx));
        window.set_focus_handle(&focus_handle, cx);

        let prepaint = self.interactivity.prepaint(
            global_id,
            inspector_id,
            bounds,
            content_size,
            window,
            cx,
            |style, scroll_offset, hitbox, window, cx| {
                let hitbox =
                    hitbox.or_else(|| Some(window.insert_hitbox(bounds, HitboxBehavior::Normal)));
                let inner_bounds = {
                    let padding = style
                        .padding
                        .to_pixels(bounds.size.into(), window.rem_size());

                    let mut bounds = bounds;
                    bounds.origin += point(padding.left, padding.top);
                    bounds.size.width -= padding.left + padding.right;
                    bounds.size.height -= padding.top + padding.bottom;
                    bounds
                };
                request_layout.state.update(cx, |state, _cx| {
                    // while gpui tracks scroll_offset with negative values,
                    // this is converted into positive for usage with bounds
                    state.layout_data.scroll_bounds =
                        Bounds::new(-scroll_offset, inner_bounds.size);
                });
                InteractivityPrepaint {
                    hitbox,
                    scroll_offset,
                    inner_bounds,
                    caret_visible,
                }
            },
        );

        // A caller can request caret placement before the field exists in the tree (for example,
        // when a tree row enters rename mode on the same click). Resolve it only after the new
        // text layout, inner bounds, and scroll offset are available.
        let pending_caret_position = request_layout
            .state
            .update(cx, |state, _| state.take_pending_caret_position());
        if let Some(window_position) = pending_caret_position {
            let text_position =
                window_position - (prepaint.inner_bounds.origin + prepaint.scroll_offset);
            let line_height = window.line_height();
            request_layout.state.update(cx, |state, cx| {
                state.place_caret_at_pixel_point(text_position, line_height, cx);
            });
        }

        let state = request_layout.state.read(cx);
        let elements = PrepaintElements::build_elements(
            state,
            &prepaint,
            &self.colors,
            self.caret_width,
            self.caret_height,
            window,
        );

        PrepaintState {
            interactivity: prepaint,
            focus_handle,
            elements,
        }
    }

    fn paint(
        &mut self,
        global_id: Option<&gpui::GlobalElementId>,
        inspector_id: Option<&gpui::InspectorElementId>,
        bounds: Bounds<Pixels>,
        request_layout: &mut Self::RequestLayoutState,
        prepaint: &mut Self::PrepaintState,
        window: &mut Window,
        cx: &mut App,
    ) {
        if let Some(hitbox) = &prepaint.interactivity.hitbox {
            window.set_cursor_style(CursorStyle::IBeam, hitbox);
        }

        let accepts_input = self.accepts_input;
        let hitbox = prepaint.interactivity.hitbox.clone();
        let perform_paint = |style: &Style, window: &mut Window, cx: &mut App| {
            if style.display == Display::None {
                return;
            }

            // Register event listeners to the window for the next frame
            if accepts_input {
                Self::process_frame_events(prepaint, bounds, &request_layout.state, window, cx);
            }

            // Actually draw the elements we constructed during prepaint
            let line_h = window.line_height();
            for PrepaintLine { line, point, align } in prepaint.elements.lines.drain(..) {
                let _ = line.paint(point, line_h, align, Some(bounds), window, cx);
            }
            for quad in prepaint.elements.ime_marked.drain(..) {
                window.paint_quad(quad);
            }
            for quad in prepaint.elements.selection.drain(..) {
                window.paint_quad(quad);
            }
            if let Some(quad) = prepaint.elements.caret.take() {
                window.paint_quad(quad);
            }
        };

        self.interactivity.paint(
            global_id,
            inspector_id,
            bounds,
            hitbox.as_ref(),
            window,
            cx,
            perform_paint,
        );
    }
}

impl EditableTextElement {
    fn find_or_create_state(&self, window: &mut Window, cx: &mut App) -> Entity<EditableTextState> {
        if let Some(entity) = self.state_entity.borrow().upgrade() {
            return entity;
        }
        let Some(element_id) = self.interactivity.element_id.clone() else {
            unimplemented!("all input elements must be assigned an id")
        };

        let state = EditableTextState::use_keyed(element_id, window, cx);
        // store a reference to the entity owned by the element for access in action handlers
        *self.state_entity_rc().borrow_mut() = state.downgrade();
        state
    }

    fn find_or_create_caret(
        &self,
        state: &Entity<EditableTextState>,
        window: &mut Window,
        cx: &mut App,
    ) -> Entity<Caret> {
        let Some(element_id) = self.interactivity.element_id.clone() else {
            unimplemented!("all input elements must be assigned an id")
        };

        window.use_keyed_state(element_id, cx, |_window, cx| {
            let mut caret = Caret::default();
            caret.subscribe_to(state, cx);
            caret
        })
    }

    fn process_frame_events(
        prepaint: &PrepaintState,
        bounds: Bounds<Pixels>,
        entity: &Entity<EditableTextState>,
        window: &mut Window,
        cx: &mut App,
    ) {
        let inner_bounds = prepaint.interactivity.inner_bounds;
        // Text layout and painting are relative to the padded inner bounds. Convert mouse
        // positions into that same coordinate space before applying the scroll offset.
        let to_local_position = -(inner_bounds.origin + prepaint.interactivity.scroll_offset);

        let ime_handler = ElementInputHandler::new(inner_bounds, entity.clone());
        window.handle_input(&prepaint.focus_handle, ime_handler, cx);

        window.on_mouse_event({
            let focus_handle = prepaint.focus_handle.clone();
            let state = entity.clone();
            move |event: &MouseDownEvent, phase, window, cx| {
                if phase != DispatchPhase::Bubble {
                    return;
                }
                if !bounds.contains(&event.position) {
                    return;
                }
                if event.button != MouseButton::Left {
                    return;
                }

                cx.stop_propagation();
                window.focus(&focus_handle, cx);

                let text_position = event.position + to_local_position;
                state.update(cx, |state, cx| {
                    state.on_mouse_down(event, text_position, window, cx);
                });
            }
        });
        window.on_mouse_event({
            let state = entity.clone();
            move |event: &MouseUpEvent, phase, window, cx| {
                if phase != DispatchPhase::Bubble {
                    return;
                }
                if event.button != MouseButton::Left {
                    return;
                }

                state.update(cx, |state, cx| {
                    state.on_mouse_up(event, window, cx);
                });
            }
        });
        window.on_mouse_event({
            let state = entity.clone();
            move |event: &MouseMoveEvent, phase, window, cx| {
                if phase != DispatchPhase::Bubble {
                    return;
                }

                let text_position = event.position + to_local_position;
                state.update(cx, |state, cx| {
                    state.on_mouse_move(event, text_position, window, cx);
                });
            }
        });
    }
}

impl PrelayoutState {
    fn perform_text_layout(self, window: &mut Window) -> LayoutId {
        // NOTE: Loosely mirrors TextLayout::layout
        let text_style = window.text_style();
        let font_size = text_style.font_size.to_pixels(window.rem_size());
        let line_height = window.pixel_snap(
            text_style
                .line_height
                .to_pixels(font_size.into(), window.rem_size()),
        );

        let color = match self.show_placeholder {
            false => text_style.color,
            true => self.placeholder_color,
        };

        let text = self.text.unwrap_or_default();

        window.request_measured_layout(
            Default::default(),
            // This is invoked sometime in the near future (before prepaint but not immediately),
            // so we avoid doing any pre-emptive work until the layout engine is ready.
            move |known_dimensions, available_space, window, cx| {
                let runs = vec![gpui::TextRun {
                    len: text.len(),
                    font: text_style.font(),
                    color,
                    background_color: None,
                    underline: None,
                    strikethrough: None,
                    letter_spacing: None,
                }];

                let wrap_width = TextLayout::evaluate_wrap_width(
                    &text_style.white_space,
                    known_dimensions,
                    available_space,
                );

                let truncation =
                    TextLayout::evaluate_overflow(&text_style, known_dimensions, available_space);

                if let Some(size) = self.prev_layout_state.size
                    && (wrap_width.is_none() || wrap_width == self.prev_layout_state.wrap_width)
                    && truncation.width.is_none()
                    && self.storage_version == self.prev_layout_state.last_seen_storage_version
                {
                    return size;
                }

                let (text, runs) = TextLayout::apply_truncation(
                    text.clone(),
                    &text_style,
                    font_size,
                    line_height,
                    wrap_width,
                    &truncation,
                    &runs,
                    window,
                    cx,
                );
                let text_len = text.len();

                let wrapped_lines = window
                    .text_system()
                    .shape_text(text, font_size, &runs, wrap_width, text_style.line_clamp)
                    .unwrap_or_default();

                // Build the size of the text and convert the wrapped_lines into
                // lines that will be cached in state and painted.
                let mut size: Size<Pixels> = Size::default();
                let mut pos_y = 0;
                let mut line_start = 0;
                let mut lines = Vec::with_capacity(wrapped_lines.len());
                for line in wrapped_lines {
                    let line_size = line.size(line_height);
                    size.height += line_size.height;
                    size.width = size.width.max(line_size.width).ceil();

                    let mut line_len = line.len();
                    if line_len < text_len {
                        // to offset for new-line characters that are
                        // omitted from WrappedLine range
                        line_len += 1;
                    }

                    let segment = TextLineSegment {
                        text_range: line_start..line_start + line_len,
                        wrapped_line: Some(Arc::new(line)),
                        pos_y,
                    };
                    line_start += line_len;
                    pos_y += segment.row_count();
                    lines.push(segment);
                }

                let layout_data = EditableTextLayoutResult {
                    supports_multiline: self.supports_multiline,
                    accepts_input: self.accepts_input,
                    // updated during prepaint
                    scroll_bounds: Bounds::default(),
                    state: EditableTextLayoutState {
                        wrap_width,
                        size: Some(size),
                        last_seen_storage_version: self.storage_version,
                    },
                    lines,
                    line_height,
                    next_scroll_offset: None,
                };

                // Update the state for use in prepaint, paint, and action handlers.
                // request_measured_layout caches this scope for processing later
                // between layout and prepaint, so we cant just copy/move these values to the outer scope.
                self.state.update(cx, move |state, _cx| {
                    state.layout_data = layout_data;
                });

                size
            },
        )
    }
}

struct PrepaintLine {
    line: Arc<WrappedLine>,
    point: Point<Pixels>,
    align: TextAlign,
}

const STACK_ALLOCATED_LINES: usize = 100usize;
const STACK_ALLOCATED_QUADS_SELECTION: usize = 20usize;
const STACK_ALLOCATED_QUADS_IME_MARKED: usize = 2usize;

#[derive(Default)]
struct PrepaintElements {
    lines: SmallVec<[PrepaintLine; STACK_ALLOCATED_LINES]>,
    selection: SmallVec<[PaintQuad; STACK_ALLOCATED_QUADS_SELECTION]>,
    ime_marked: SmallVec<[PaintQuad; STACK_ALLOCATED_QUADS_IME_MARKED]>,
    caret: Option<PaintQuad>,
}

impl PrepaintElements {
    fn build_quads(
        offset_corners: Vec<(Point<Pixels>, Point<Pixels>)>,
        origin: Point<Pixels>,
        color: Hsla,
    ) -> impl Iterator<Item = PaintQuad> {
        offset_corners
            .into_iter()
            .map(move |(offset_start, offset_end)| {
                let bounds = Bounds::from_corners(origin + offset_start, origin + offset_end);
                fill(bounds, color)
            })
    }

    fn build_elements(
        state: &EditableTextState,
        prepaint: &InteractivityPrepaint,
        colors: &EditableTextColors,
        caret_width: Pixels,
        caret_height: DefiniteLength,
        window: &mut Window,
    ) -> PrepaintElements {
        let InteractivityPrepaint {
            hitbox: _,
            scroll_offset,
            inner_bounds,
            caret_visible,
        } = prepaint;

        let caret_pos = state.caret_pos();
        let selection = state.selected_range();
        let ime_range = state.marked_range();

        let mut elements = PrepaintElements::default();

        let line_height = window.line_height();
        let is_range_contained_by_range =
            |text_range: &Range<usize>, containing_range: &Range<usize>| {
                if text_range.is_empty() {
                    containing_range.start <= text_range.start
                        && containing_range.end > text_range.start
                } else {
                    containing_range.end > text_range.start
                        && containing_range.start < text_range.end
                }
            };
        let mut caret_point = None::<Point<Pixels>>;
        for segment in &state.layout_data.lines {
            let line_distance_from_top = segment.pos_y * line_height;
            let line_y = line_distance_from_top + scroll_offset.y;
            let line_bottom = line_y + line_height * segment.row_count() as f32;
            let line_visible = line_bottom >= Pixels::ZERO && line_y <= inner_bounds.size.height;
            if !line_visible {
                continue;
            }

            if let Some(wrapped) = &segment.wrapped_line {
                let point = inner_bounds.origin + point(scroll_offset.x, line_y);
                elements.lines.push(PrepaintLine {
                    line: wrapped.clone(),
                    point,
                    align: TextAlign::Left,
                });
            }

            let segment_is_empty = segment.text_range.is_empty();

            if is_range_contained_by_range(&segment.text_range, &selection) {
                if segment_is_empty {
                    const EMPTY_LINE_SELECTION_WIDTH: Pixels = px(6.);
                    elements.selection.push(fill(
                        Bounds::from_corners(
                            inner_bounds.origin + point(Pixels::ZERO, line_y),
                            inner_bounds.origin
                                + point(EMPTY_LINE_SELECTION_WIDTH, line_y + line_height),
                        ),
                        colors.selection,
                    ));
                } else {
                    let offset_corners = build_quad_over_text(
                        &selection,
                        segment,
                        line_y,
                        line_height,
                        Pixels::ZERO,
                    );
                    elements.selection.extend(PrepaintElements::build_quads(
                        offset_corners,
                        inner_bounds.origin,
                        colors.selection,
                    ));
                }
            }

            if !segment_is_empty && let Some(ime_range) = &ime_range {
                if !ime_range.is_empty()
                    && is_range_contained_by_range(&segment.text_range, &ime_range)
                {
                    const MARKED_TEXT_UNDERLINE_THICKNESS: f32 = 2.0;
                    let underline_thickness = px(MARKED_TEXT_UNDERLINE_THICKNESS);
                    let underline_offset = line_height - underline_thickness;

                    let offset_corners = build_quad_over_text(
                        &ime_range,
                        segment,
                        line_y,
                        line_height,
                        underline_offset,
                    );
                    elements.ime_marked.extend(PrepaintElements::build_quads(
                        offset_corners,
                        inner_bounds.origin,
                        colors.ime_underline,
                    ));
                }
            }

            let is_cursor_in_line = segment.contains_position(caret_pos, true);
            if is_cursor_in_line && let Some(wrapped) = &segment.wrapped_line {
                let local_offset = caret_pos.saturating_sub(segment.text_range.start);
                let caret_px = wrapped
                    .position_for_index(local_offset, line_height)
                    .unwrap_or_default();
                caret_point = Some(caret_px + point(scroll_offset.x, line_y));
            }
        }

        if *caret_visible && let Some(caret_point) = caret_point {
            let caret_height = caret_height.to_pixels(line_height.into(), window.rem_size());
            let vertical_offset = (line_height - caret_height) / 2.;
            let quad = fill(
                Bounds::new(
                    inner_bounds.origin + caret_point + point(Pixels::ZERO, vertical_offset),
                    size(caret_width, caret_height),
                ),
                colors.caret,
            );
            elements.caret = Some(quad);
        }

        elements
    }
}

fn build_quad_over_text(
    containing_range: &Range<usize>,
    segment: &TextLineSegment,
    line_y: Pixels,
    line_height: Pixels,
    offset_y: Pixels,
) -> Vec<(Point<Pixels>, Point<Pixels>)> {
    let Some(wrapped) = &segment.wrapped_line else {
        return vec![];
    };

    let line_start = segment.text_range.start;
    let line_end = segment.text_range.end;

    let subrange_start = containing_range.start.max(line_start) - line_start;
    let subrange_end = containing_range.end.min(line_end) - line_start;

    let start_pos = wrapped
        .position_for_index(subrange_start, line_height)
        .unwrap_or_default();
    let end_pos = wrapped
        .position_for_index(subrange_end, line_height)
        .unwrap_or_else(|| {
            let last_line_y = line_height * (segment.row_count() - 1) as f32;
            point(wrapped.width(), last_line_y)
        });

    let start_visual_line = (start_pos.y / line_height).floor() as usize;
    let end_visual_line = (end_pos.y / line_height).floor() as usize;

    if start_visual_line == end_visual_line {
        vec![(
            point(start_pos.x, line_y + start_pos.y + offset_y),
            point(end_pos.x, line_y + start_pos.y + line_height),
        )]
    } else {
        let line_width = wrapped.width();
        let middle_lines = (start_visual_line + 1)..end_visual_line;
        let mut quad_corners = Vec::with_capacity(middle_lines.end - middle_lines.start + 2);

        quad_corners.push((
            point(start_pos.x, line_y + start_pos.y + offset_y),
            point(line_width, line_y + start_pos.y + line_height),
        ));

        // Middle visual lines
        for visual_line in (start_visual_line + 1)..end_visual_line {
            let y = line_height * visual_line as f32;
            quad_corners.push((
                point(Pixels::ZERO, line_y + y + offset_y),
                point(line_width, line_y + y + line_height),
            ));
        }

        // Last visual line
        quad_corners.push((
            point(Pixels::ZERO, line_y + end_pos.y + offset_y),
            point(end_pos.x, line_y + end_pos.y + line_height),
        ));

        quad_corners
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use gpui::rgba;

    #[test]
    fn custom_placeholder_color_and_caret_size() {
        let color = rgba(0x33669980);
        let input = editable_text("i")
            .placeholder_color(color)
            .caret_w(px(3.))
            .caret_h(relative(0.5));
        assert_eq!(input.colors.placeholder, color.into_color());
        assert_eq!(input.caret_width, px(3.));
        assert_eq!(
            input.caret_height.to_pixels(px(20.).into(), px(16.)),
            px(10.)
        );
    }
}
