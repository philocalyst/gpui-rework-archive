use crate::editable_text::{
    BLINK_INTERVAL_500MS, Caret, EditableTextState,
    actions::{DEFAULT_INPUT_CONTEXT, EditableTextActionElement, EditableTextActionHandler},
    layout::{
        EditableTextLayoutKey, EditableTextLayoutResult, EditableTextLayoutState,
        ParagraphLayoutCache, ParagraphLayoutCacheBuilder, ParagraphLayoutKey, TextLineSegment,
    },
};
use crate::rich_text::{Document, InlineStyle, RangeSet};
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
        decorations: RangeSet::default(),
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

/// Creates an editable element intended for composing rich text.
///
/// It uses the same selection, input, IME, and storage path as [`text_input`] and [`text_area`].
#[track_caller]
pub fn rich_text(id: impl Into<ElementId>) -> EditableTextElement {
    editable_text(id)
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
    /// Transient presentation ranges supplied by the element's owner.
    decorations: RangeSet<InlineStyle>,
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

    /// Adds transient text styles, such as syntax colors, diagnostics, and links.
    ///
    /// These ranges are part of the text layout and paint cache key. They do not change persistent
    /// formatting or participate in undo history.
    pub fn decorations(mut self, decorations: RangeSet<InlineStyle>) -> Self {
        self.decorations = decorations;
        self
    }

    /// Configures whether the field supports multiple lines of text.
    /// Disabling this prevents actions like `enter` and navigating up and down.
    ///
    /// In single-line mode, incoming user text has newline characters removed. Programmatic
    /// document transactions can still insert newline characters.
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
    paragraph_cache: ParagraphLayoutCache,
    document: Document,
    storage_revision: u64,
    pending_scroll_to_caret: bool,
    show_placeholder: bool,
    placeholder_text: Option<SharedString>,
    placeholder_color: Hsla,
    persistent_styles: RangeSet<InlineStyle>,
    decorations: RangeSet<InlineStyle>,
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
        let caret = self.find_or_create_caret(&entity, window, cx);

        if let Some(duration) = self.caret_blink_interval.take()
            && caret.read(cx).blink_interval() != duration
        {
            caret.update(cx, |caret, _cx| caret.set_blink_interval(duration));
        }

        // Read new state information from the underlying entity.
        // Block-wrapped so that the state being read is dropped before continuing.
        let (prelayout, next_scroll_offset, pending_scroll_to_caret) = {
            let state = entity.read(cx);
            let show_placeholder = state.len_bytes() == 0;
            let placeholder_text = show_placeholder.then(|| self.placeholder.clone()).flatten();
            let source_document = state.document_snapshot();
            let decorations = if show_placeholder {
                RangeSet::default()
            } else {
                self.decorations.clone()
            };
            let persistent_styles = if show_placeholder {
                RangeSet::default()
            } else {
                state.inline_styles().clone()
            };
            let document = if let Some(placeholder) = &placeholder_text {
                Document::from_shared_string(placeholder.clone())
            } else {
                source_document
            };

            let prelayout = PrelayoutState {
                state: entity.clone(),
                prev_layout_state: state.layout_data.state.clone(),
                paragraph_cache: state.layout_data.paragraph_cache.clone(),
                document,
                show_placeholder,
                storage_revision: state.revision(),
                pending_scroll_to_caret: state.pending_scroll_to_caret(),
                placeholder_text,
                placeholder_color: self.colors.placeholder,
                persistent_styles,
                decorations,
                supports_multiline: self.supports_multiline,
                accepts_input: self.accepts_input,
            };
            (
                prelayout,
                state.layout_data.next_scroll_offset,
                state.pending_scroll_to_caret(),
            )
        };

        // Update the scroll offset of the element when the user's caret goes out of scope.
        if let Some(scroll_offset) = next_scroll_offset.filter(|_| !pending_scroll_to_caret) {
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
                    state.layout_data.inner_bounds = inner_bounds;
                });
                InteractivityPrepaint {
                    hitbox,
                    scroll_offset,
                    inner_bounds,
                    caret_visible,
                }
            },
        );

        // If layout was first requested before the element had viewport bounds, resolve the
        // pending caret after prepaint has supplied those bounds and schedule one more frame.
        let pending_scroll = {
            let state = request_layout.state.read(cx);
            let scroll_bounds = state.layout_data.scroll_bounds;
            if state.pending_scroll_to_caret() && !scroll_bounds.is_empty() {
                Some((
                    scroll_bounds,
                    state.layout_data.lines.clone(),
                    state.layout_data.line_height,
                    state.layout_data.state.size.unwrap_or(content_size),
                    state.caret_pos(),
                ))
            } else {
                None
            }
        };
        if let Some((scroll_bounds, lines, line_height, content_size, caret_pos)) = pending_scroll {
            let next_scroll_offset = scroll_offset_for_layout_caret(
                &lines,
                caret_pos,
                line_height,
                scroll_bounds,
                content_size,
            );
            request_layout.state.update(cx, move |state, state_cx| {
                state.layout_data.next_scroll_offset = next_scroll_offset;
                state.clear_pending_scroll_to_caret();
                if next_scroll_offset.is_some() {
                    state_cx.notify();
                }
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
        let line_h = request_layout.state.read(cx).layout_data.line_height;
        let perform_paint = |style: &Style, window: &mut Window, cx: &mut App| {
            if style.display == Display::None {
                return;
            }

            // Register event listeners to the window for the next frame
            if accepts_input {
                Self::process_frame_events(prepaint, bounds, &request_layout.state, window, cx);
            }

            // Paint inline backgrounds first so the selection and glyphs remain readable.
            for PrepaintLine { line, point, align } in &prepaint.elements.lines {
                let _ = line.paint_background(
                    *point,
                    line_h,
                    *align,
                    Some(prepaint.interactivity.inner_bounds),
                    window,
                    cx,
                );
            }
            for quad in prepaint.elements.selection.drain(..) {
                window.paint_quad(quad);
            }
            for PrepaintLine { line, point, align } in prepaint.elements.lines.drain(..) {
                let _ = line.paint(
                    point,
                    line_h,
                    align,
                    Some(prepaint.interactivity.inner_bounds),
                    window,
                    cx,
                );
            }
            for quad in prepaint.elements.ime_marked.drain(..) {
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

        let mut base_text_style = text_style.clone();
        base_text_style.color = color;

        let document = self.document;
        let persistent_styles = self.persistent_styles;
        let decorations = self.decorations;
        let previous_paragraph_cache = self.paragraph_cache;
        let previous_layout = self.prev_layout_state;
        let state = self.state;
        let storage_revision = self.storage_revision;
        let pending_scroll_to_caret = self.pending_scroll_to_caret;
        let is_placeholder = self.show_placeholder;
        let placeholder_text = self.placeholder_text;
        let supports_multiline = self.supports_multiline;
        let accepts_input = self.accepts_input;

        window.request_measured_layout(
            Default::default(),
            // This is invoked sometime in the near future (before prepaint but not immediately),
            // so we avoid doing any pre-emptive work until the layout engine is ready.
            move |known_dimensions, available_space, window, cx| {
                let wrap_width = TextLayout::evaluate_wrap_width(
                    &text_style.white_space,
                    known_dimensions,
                    available_space,
                );

                let truncation =
                    TextLayout::evaluate_overflow(&text_style, known_dimensions, available_space);

                let cache_key = EditableTextLayoutKey {
                    storage_revision,
                    wrap_width,
                    truncation_width: truncation.width,
                    truncation_affix: truncation.affix.clone(),
                    truncation_source: truncation.source,
                    is_placeholder,
                    placeholder_text: placeholder_text.clone(),
                    text_style: text_style.clone(),
                    text_color: color,
                    persistent_styles: persistent_styles.clone(),
                    decorations: decorations.clone(),
                    font_size,
                    line_height,
                    supports_multiline,
                };

                // Check the full layout key before lowering inline ranges or reading paragraph
                // text. Caret, focus, and selection changes therefore leave shaped lines alone.
                if let Some(size) = previous_layout.size
                    && truncation.width.is_none()
                    && previous_layout.cache_key.as_ref() == Some(&cache_key)
                {
                    if pending_scroll_to_caret {
                        let (next_scroll_offset, has_viewport) = {
                            let state = state.read(cx);
                            let scroll_bounds = state.layout_data.scroll_bounds;
                            (
                                (!scroll_bounds.is_empty())
                                    .then(|| {
                                        scroll_offset_for_layout_caret(
                                            &state.layout_data.lines,
                                            state.caret_pos(),
                                            state.layout_data.line_height,
                                            scroll_bounds,
                                            size,
                                        )
                                    })
                                    .flatten(),
                                !scroll_bounds.is_empty(),
                            )
                        };
                        state.update(cx, move |state, state_cx| {
                            state.layout_data.next_scroll_offset = next_scroll_offset;
                            if has_viewport {
                                state.clear_pending_scroll_to_caret();
                            }
                            if next_scroll_offset.is_some() {
                                state_cx.notify();
                            }
                        });
                    }
                    state.update(cx, move |state, _cx| {
                        state.layout_data.accepts_input = accepts_input;
                        state.layout_data.supports_multiline = supports_multiline;
                    });
                    return size;
                }

                // Validate and combine annotation layers only when a layout input changed.
                // Cloning and equality-checking their Arc-backed source sets above stays cheap on
                // unchanged frames; persistent formatting remains below transient decorations.
                let valid_decorations = if decorations.validate_document(&document).is_ok() {
                    decorations.clone()
                } else {
                    RangeSet::default()
                };
                let mut next_paragraph_cache = ParagraphLayoutCacheBuilder::default();

                let mut size: Size<Pixels> = Size::default();
                let mut pos_y = 0usize;
                let mut lines = Vec::with_capacity(document.line_count());

                if truncation.width.is_some() {
                    // The overflow helper currently accepts one contiguous string. Keep its
                    // established behavior for explicit truncation, while the normal editor path
                    // below stays on native document line slices and never flattens the document.
                    let inline_styles = persistent_styles.concat(&valid_decorations);
                    let text = SharedString::from(document.slice(0..document.len_bytes()));
                    let runs = inline_styles
                        .text_runs(&text, &base_text_style)
                        .unwrap_or_else(|_| vec![base_text_style.to_run(text.len())]);
                    let (text, runs) = TextLayout::apply_truncation(
                        text,
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
                    let mut line_start = 0usize;
                    for line in wrapped_lines {
                        let line_size = line.size(line_height);
                        size.height += line_size.height;
                        size.width = size.width.max(line_size.width).ceil();
                        let mut line_len = line.len();
                        if line_len < text_len {
                            // Wrapped lines omit the LF separator from their text range.
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
                } else {
                    let mut remaining_rows = text_style.line_clamp;
                    for line_index in 0..document.line_count() {
                        if remaining_rows == Some(0) {
                            break;
                        }
                        let text_range = document
                            .line_range(line_index)
                            .expect("line index is within document line count");
                        let local_persistent_styles = persistent_styles
                            .clipped(text_range.clone())
                            .unwrap_or_default();
                        let local_decorations = valid_decorations
                            .clipped(text_range.clone())
                            .unwrap_or_default();
                        let local_styles = local_persistent_styles.concat(&local_decorations);
                        let paragraph_key = ParagraphLayoutKey {
                            base_text_style: base_text_style.clone(),
                            inline_styles: local_styles.clone(),
                            font_size,
                            wrap_width,
                            line_clamp: remaining_rows,
                            truncation_width: truncation.width,
                            truncation_affix: truncation.affix.clone(),
                            truncation_source: truncation.source,
                            is_placeholder,
                            placeholder_text: placeholder_text.clone(),
                        };
                        let fingerprint = ParagraphLayoutCache::fingerprint(
                            &paragraph_key,
                            &document,
                            &text_range,
                        );

                        let current_match = next_paragraph_cache.get(
                            fingerprint,
                            &paragraph_key,
                            &document,
                            &text_range,
                        );
                        let wrapped = if let Some(wrapped) = current_match {
                            wrapped
                        } else if let Some(wrapped) = previous_paragraph_cache.get(
                            fingerprint,
                            &paragraph_key,
                            &document,
                            &text_range,
                        ) {
                            next_paragraph_cache.insert(
                                fingerprint,
                                paragraph_key.clone(),
                                wrapped.text.clone(),
                                wrapped.clone(),
                            );
                            wrapped
                        } else {
                            let text = SharedString::from(document.slice(text_range.clone()));
                            let runs = local_styles
                                .text_runs(&text, &base_text_style)
                                .unwrap_or_else(|_| vec![base_text_style.to_run(text.len())]);
                            let Some(line) = window
                                .text_system()
                                .shape_text(
                                    text.clone(),
                                    font_size,
                                    &runs,
                                    wrap_width,
                                    remaining_rows,
                                )
                                .unwrap_or_default()
                                .into_iter()
                                .next()
                            else {
                                break;
                            };
                            let wrapped = Arc::new(line);
                            next_paragraph_cache.insert(
                                fingerprint,
                                paragraph_key.clone(),
                                text,
                                wrapped.clone(),
                            );
                            wrapped
                        };

                        let line_size = wrapped.size(line_height);
                        size.height += line_size.height;
                        size.width = size.width.max(line_size.width).ceil();
                        let row_count = wrapped.wrap_boundaries().len() + 1;
                        if let Some(remaining) = &mut remaining_rows {
                            *remaining = remaining.saturating_sub(row_count);
                        }
                        let has_newline = line_index + 1 < document.line_count();
                        let segment = TextLineSegment {
                            text_range: text_range.start..text_range.end + usize::from(has_newline),
                            wrapped_line: Some(wrapped),
                            pos_y,
                        };
                        pos_y += segment.row_count();
                        lines.push(segment);
                    }
                }

                let (scroll_bounds, inner_bounds, caret_pos) = {
                    let state = state.read(cx);
                    (
                        state.layout_data.scroll_bounds,
                        state.layout_data.inner_bounds,
                        state.caret_pos(),
                    )
                };
                let has_viewport = !scroll_bounds.is_empty();
                let next_scroll_offset = (pending_scroll_to_caret && has_viewport)
                    .then(|| {
                        scroll_offset_for_layout_caret(
                            &lines,
                            caret_pos,
                            line_height,
                            scroll_bounds,
                            size,
                        )
                    })
                    .flatten();

                let layout_data = EditableTextLayoutResult {
                    supports_multiline,
                    accepts_input,
                    // Keep the previous viewport geometry until the next prepaint refreshes it.
                    scroll_bounds,
                    inner_bounds,
                    state: EditableTextLayoutState {
                        size: Some(size),
                        cache_key: Some(cache_key),
                    },
                    lines: lines.into(),
                    paragraph_cache: next_paragraph_cache.finish(),
                    line_height,
                    next_scroll_offset,
                };

                // Update the state for use in prepaint, paint, and action handlers.
                // request_measured_layout caches this scope for processing later
                // between layout and prepaint, so we cant just copy/move these values to the outer scope.
                let should_notify_for_scroll = next_scroll_offset.is_some();
                state.update(cx, move |state, state_cx| {
                    state.layout_data = layout_data;
                    if pending_scroll_to_caret && has_viewport {
                        state.clear_pending_scroll_to_caret();
                    }
                    if should_notify_for_scroll {
                        state_cx.notify();
                    }
                });

                size
            },
        )
    }
}

fn scroll_offset_for_layout_caret(
    lines: &[TextLineSegment],
    caret_pos: usize,
    line_height: Pixels,
    scroll_bounds: Bounds<Pixels>,
    content_size: Size<Pixels>,
) -> Option<Point<Pixels>> {
    if scroll_bounds.is_empty() {
        return None;
    }
    let candidate = lines.get(
        lines
            .partition_point(|segment| segment.text_range.start <= caret_pos)
            .saturating_sub(1),
    );
    let segment = candidate
        .filter(|segment| segment.contains_position(caret_pos, false))
        .or_else(|| candidate.filter(|segment| segment.contains_position(caret_pos, true)))?;
    let point = point(Pixels::ZERO, segment.pos_y * line_height)
        + segment
            .position_for_index(caret_pos, line_height)
            .unwrap_or_default();
    let caret_bottom = point.y + line_height;
    if point.x >= scroll_bounds.left()
        && point.x <= scroll_bounds.right()
        && point.y >= scroll_bounds.top()
        && caret_bottom <= scroll_bounds.bottom()
    {
        return None;
    }

    let mut offset = scroll_bounds.origin;
    if point.x < scroll_bounds.left() {
        offset.x = point.x;
    }
    if point.y < scroll_bounds.top() {
        offset.y = point.y;
    }
    if point.x > scroll_bounds.right() {
        offset.x += point.x - scroll_bounds.right();
    }
    if caret_bottom > scroll_bounds.bottom() {
        offset.y += caret_bottom - scroll_bounds.bottom();
    }
    offset.x = offset.x.clamp(
        Pixels::ZERO,
        (content_size.width - scroll_bounds.size.width).max(Pixels::ZERO),
    );
    offset.y = offset.y.clamp(
        Pixels::ZERO,
        (content_size.height - scroll_bounds.size.height).max(Pixels::ZERO),
    );
    (offset != scroll_bounds.origin).then_some(offset)
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

        let line_height = state.layout_data.line_height;
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
        let lines = &state.layout_data.lines;
        let document_top = -scroll_offset.y;
        let document_bottom = inner_bounds.size.height - scroll_offset.y;
        let first_visible = lines.partition_point(|segment| {
            line_height * ((segment.pos_y + segment.row_count()) as f32) < document_top
        });
        let after_last_visible =
            lines.partition_point(|segment| line_height * segment.pos_y as f32 <= document_bottom);
        for segment in &lines[first_visible..after_last_visible] {
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
