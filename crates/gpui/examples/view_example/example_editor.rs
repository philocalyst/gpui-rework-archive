//! Editing state shared by the single-line input and multiline text area.
//!
//! The string lives in a separate entity, so a form can retain its value without
//! owning the editor. This entity keeps the selection, IME composition, focus,
//! and blink task. The custom element in `paint` supplies the same shaped layout
//! to painting and platform geometry queries.
//!
//! Navigation here follows logical grapheme order; Home and End address the
//! whole buffer. An editor with visual bidirectional navigation or soft wrapping
//! should retain affinity-aware carets and use `ShapedTextLayout::selection_movement`.

use std::ops::Range;
use std::sync::Arc;
use std::time::Duration;

use gpui::{
    App, Bounds, Context, ElementInputHandler, Entity, EntityInputHandler, FocusHandle, Focusable,
    InteractiveElement, LayoutId, MouseButton, PaintQuad, Pixels, Point, ShapedText, SharedString,
    Subscription, Task, UTF16Selection, Window, fill, hsla, point, prelude::*, px, relative, size,
    utf8_to_utf16_offset, utf16_to_utf8_offset,
};
use unicode_segmentation::*;

use crate::{Backspace, Delete, End, Home, Left, Right};

pub struct Editor {
    /// The form's mutable UTF-8 buffer. External edits must notify this entity.
    pub value: Entity<String>,
    /// Keyboard focus, shared with the surrounding input element.
    pub focus_handle: FocusHandle,
    /// Active selection end as a UTF-8 byte offset.
    pub cursor: usize,
    selection_anchor: usize,
    marked_range: Option<Range<usize>>,
    last_value: String,
    painted: Option<PaintedText>,
    pub cursor_visible: bool,
    _blink_task: Task<()>,
    _subscriptions: Vec<Subscription>,
}

struct PaintedText {
    text: Arc<ShapedText>,
    origin: Point<Pixels>,
    line_height: Pixels,
}

impl Editor {
    /// Create the buffer and editor together, starting with a caret at byte zero.
    pub fn new(text: impl Into<String>, window: &mut Window, cx: &mut Context<Self>) -> Self {
        let value = cx.new(|_| text.into());
        Self::over(value, window, cx)
    }

    /// Edit an existing buffer, observing its notifications for external changes.
    ///
    /// Replacing the buffer externally ends composition and clamps both selection
    /// ends to valid UTF-8 boundaries. It does not preserve positions through edits.
    pub fn over(value: Entity<String>, window: &mut Window, cx: &mut Context<Self>) -> Self {
        let focus_handle = cx.focus_handle().tab_stop(true);
        let last_value = value.read(cx).clone();

        let focus_sub = cx.on_focus(&focus_handle, window, |this, _window, cx| {
            this.start_blink(cx);
        });
        let blur_sub = cx.on_blur(&focus_handle, window, |this, _window, cx| {
            this.stop_blink(cx);
        });

        // Internal edits update last_value before notifying. A different value
        // therefore came from another owner and invalidates our composition.
        let value_sub = cx.observe(&value, |this, value, cx| {
            let content = value.read(cx);
            if content != &this.last_value {
                this.marked_range = None;
                this.last_value.clone_from(content);
                this.painted = None;
            }
            this.cursor = clamp_boundary(content, this.cursor);
            this.selection_anchor = clamp_boundary(content, this.selection_anchor);
            cx.notify();
        });

        Self {
            value,
            focus_handle,
            cursor: 0,
            selection_anchor: 0,
            marked_range: None,
            last_value,
            painted: None,
            cursor_visible: false,
            _blink_task: Task::ready(()),
            _subscriptions: vec![focus_sub, blur_sub, value_sub],
        }
    }

    /// Copy the current buffer. Read `value` directly when a borrow is sufficient.
    pub fn text(&self, cx: &App) -> String {
        self.value.read(cx).clone()
    }

    fn start_blink(&mut self, cx: &mut Context<Self>) {
        self.cursor_visible = true;
        self._blink_task = Self::spawn_blink_task(cx);
    }

    fn stop_blink(&mut self, cx: &mut Context<Self>) {
        self.cursor_visible = false;
        self._blink_task = Task::ready(());
        cx.notify();
    }

    fn spawn_blink_task(cx: &mut Context<Self>) -> Task<()> {
        cx.spawn(async move |this, cx| {
            loop {
                cx.background_executor()
                    .timer(Duration::from_millis(500))
                    .await;
                let result = this.update(cx, |editor, cx| {
                    editor.cursor_visible = !editor.cursor_visible;
                    cx.notify();
                });
                if result.is_err() {
                    break;
                }
            }
        })
    }

    fn reset_blink(&mut self, cx: &mut Context<Self>) {
        self.cursor_visible = true;
        self._blink_task = Self::spawn_blink_task(cx);
    }

    fn selection(&self) -> Range<usize> {
        self.selection_anchor.min(self.cursor)..self.selection_anchor.max(self.cursor)
    }

    fn move_to(&mut self, cursor: usize, cx: &mut Context<Self>) {
        self.cursor = cursor;
        self.selection_anchor = cursor;
        self.marked_range = None;
        self.reset_blink(cx);
        cx.notify();
    }

    fn select_at(
        &mut self,
        point: Point<Pixels>,
        extend: bool,
        window: &mut Window,
        cx: &mut Context<Self>,
    ) {
        window.focus(&self.focus_handle, cx);
        let Some(offset) = self.character_index_for_point(point, window, cx) else {
            return;
        };
        self.cursor = utf16_to_utf8_offset(self.value.read(cx), offset);
        if !extend {
            self.selection_anchor = self.cursor;
        }
        self.marked_range = None;
        self.reset_blink(cx);
        cx.notify();
    }

    fn replacement_range(&self, range: Option<Range<usize>>, content: &str) -> Range<usize> {
        range
            .map(|range| utf16_range(content, range))
            .unwrap_or_else(|| {
                self.marked_range
                    .clone()
                    .unwrap_or_else(|| self.selection())
            })
    }

    fn replace(&mut self, range: Range<usize>, text: &str, cx: &mut Context<Self>) {
        self.value.update(cx, |value, cx| {
            value.replace_range(range.clone(), text);
            self.last_value.clone_from(value);
            cx.notify();
        });
        self.cursor = range.start + text.len();
        self.selection_anchor = self.cursor;
        self.marked_range = None;
        self.painted = None;
        self.reset_blink(cx);
        cx.notify();
    }

    pub fn left(&mut self, _: &Left, _: &mut Window, cx: &mut Context<Self>) {
        let content = self.text(cx);
        let selection = self.selection();
        let cursor = if selection.is_empty() {
            previous_boundary(&content, self.cursor)
        } else {
            selection.start
        };
        self.move_to(cursor, cx);
    }

    pub fn right(&mut self, _: &Right, _: &mut Window, cx: &mut Context<Self>) {
        let content = self.text(cx);
        let selection = self.selection();
        let cursor = if selection.is_empty() {
            next_boundary(&content, self.cursor)
        } else {
            selection.end
        };
        self.move_to(cursor, cx);
    }

    pub fn home(&mut self, _: &Home, _: &mut Window, cx: &mut Context<Self>) {
        self.move_to(0, cx);
    }

    pub fn end(&mut self, _: &End, _: &mut Window, cx: &mut Context<Self>) {
        self.move_to(self.text(cx).len(), cx);
    }

    pub fn backspace(&mut self, _: &Backspace, _: &mut Window, cx: &mut Context<Self>) {
        let content = self.text(cx);
        let mut range = self.selection();
        if range.is_empty() {
            range.start = previous_boundary(&content, self.cursor);
        }
        self.replace(range, "", cx);
    }

    pub fn delete(&mut self, _: &Delete, _: &mut Window, cx: &mut Context<Self>) {
        let content = self.text(cx);
        let mut range = self.selection();
        if range.is_empty() {
            range.end = next_boundary(&content, self.cursor);
        }
        self.replace(range, "", cx);
    }

    pub fn insert_newline(&mut self, cx: &mut Context<Self>) {
        self.replace(self.selection(), "\n", cx);
    }
}

fn clamp_boundary(content: &str, offset: usize) -> usize {
    let mut offset = offset.min(content.len());
    while !content.is_char_boundary(offset) {
        offset -= 1;
    }
    offset
}

fn utf16_range(content: &str, range: Range<usize>) -> Range<usize> {
    let start = utf16_to_utf8_offset(content, range.start);
    let end = utf16_to_utf8_offset(content, range.end);
    start.min(end)..start.max(end)
}

fn previous_boundary(content: &str, offset: usize) -> usize {
    content
        .grapheme_indices(true)
        .rev()
        .find_map(|(idx, _)| (idx < offset).then_some(idx))
        .unwrap_or(0)
}

fn next_boundary(content: &str, offset: usize) -> usize {
    content
        .grapheme_indices(true)
        .find_map(|(idx, _)| (idx > offset).then_some(idx))
        .unwrap_or(content.len())
}

impl Focusable for Editor {
    fn focus_handle(&self, _cx: &App) -> FocusHandle {
        self.focus_handle.clone()
    }
}

impl EntityInputHandler for Editor {
    fn text_for_range(
        &mut self,
        range_utf16: Range<usize>,
        actual_range: &mut Option<Range<usize>>,
        _window: &mut Window,
        cx: &mut Context<Self>,
    ) -> Option<String> {
        let content = self.text(cx);
        let range = utf16_range(&content, range_utf16);
        actual_range.replace(
            utf8_to_utf16_offset(&content, range.start)..utf8_to_utf16_offset(&content, range.end),
        );
        Some(content[range].to_string())
    }

    fn selected_text_range(
        &mut self,
        _ignore_disabled_input: bool,
        _window: &mut Window,
        cx: &mut Context<Self>,
    ) -> Option<UTF16Selection> {
        let content = self.text(cx);
        let selection = self.selection();
        Some(UTF16Selection {
            range: utf8_to_utf16_offset(&content, selection.start)
                ..utf8_to_utf16_offset(&content, selection.end),
            reversed: self.cursor < self.selection_anchor,
        })
    }

    fn marked_text_range(
        &self,
        _window: &mut Window,
        cx: &mut Context<Self>,
    ) -> Option<Range<usize>> {
        let content = self.value.read(cx);
        self.marked_range.as_ref().map(|range| {
            utf8_to_utf16_offset(content, range.start)..utf8_to_utf16_offset(content, range.end)
        })
    }

    fn unmark_text(&mut self, _window: &mut Window, cx: &mut Context<Self>) {
        self.marked_range = None;
        cx.notify();
    }

    fn replace_text_in_range(
        &mut self,
        range_utf16: Option<Range<usize>>,
        new_text: &str,
        _window: &mut Window,
        cx: &mut Context<Self>,
    ) {
        let content = self.text(cx);
        let range = self.replacement_range(range_utf16, &content);
        self.replace(range, new_text, cx);
    }

    fn replace_and_mark_text_in_range(
        &mut self,
        range_utf16: Option<Range<usize>>,
        new_text: &str,
        new_selected_range_utf16: Option<Range<usize>>,
        _window: &mut Window,
        cx: &mut Context<Self>,
    ) {
        let content = self.text(cx);
        let range = self.replacement_range(range_utf16, &content);
        let start = range.start;
        self.replace(range, new_text, cx);
        if !new_text.is_empty() {
            self.marked_range = Some(start..start + new_text.len());
        }
        if let Some(selection) = new_selected_range_utf16 {
            // These offsets are relative to the inserted text, not the document.
            self.selection_anchor = start + utf16_to_utf8_offset(new_text, selection.start);
            self.cursor = start + utf16_to_utf8_offset(new_text, selection.end);
        }
    }

    fn bounds_for_range(
        &mut self,
        range_utf16: Range<usize>,
        bounds: Bounds<Pixels>,
        _window: &mut Window,
        cx: &mut Context<Self>,
    ) -> Option<Bounds<Pixels>> {
        let content = self.value.read(cx);
        let painted = self.painted.as_ref()?;
        if painted.text.text.as_ref() != content.as_str() {
            return None;
        }
        let range = utf16_range(content, range_utf16);
        if !range.is_empty() {
            // Platform candidate UI needs one rectangle. For a range crossing
            // visual rows, use its first rectangle rather than a tall union.
            let mut selected = painted
                .text
                .selection_bounds(range.clone(), painted.line_height);
            if let Some(rect) = selected.first_mut() {
                rect.origin += bounds.origin;
                return Some(*rect);
            }
        }
        let caret = painted
            .text
            .visual_position_for_byte_index(range.start, painted.line_height)?;
        Some(Bounds::new(
            bounds.origin + caret,
            size(px(1.), painted.line_height),
        ))
    }

    fn character_index_for_point(
        &mut self,
        point: Point<Pixels>,
        _window: &mut Window,
        cx: &mut Context<Self>,
    ) -> Option<usize> {
        let content = self.value.read(cx);
        let painted = self.painted.as_ref()?;
        if painted.text.text.as_ref() != content.as_str() {
            return None;
        }
        let offset = painted
            .text
            .closest_byte_index_for_pixel_point(point - painted.origin, painted.line_height)
            .unwrap_or_else(|edge| edge);
        Some(utf8_to_utf16_offset(content, offset))
    }

    fn set_selected_text_range(
        &mut self,
        range_utf16: Range<usize>,
        _window: &mut Window,
        cx: &mut Context<Self>,
    ) {
        let content = self.value.read(cx);
        self.selection_anchor = utf16_to_utf8_offset(content, range_utf16.start);
        self.cursor = utf16_to_utf8_offset(content, range_utf16.end);
        self.reset_blink(cx);
        cx.notify();
    }

    fn text_length_utf16(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> Option<usize> {
        Some(self.value.read(cx).encode_utf16().count())
    }
}

#[path = "example_editor/paint.rs"]
mod paint;

/// Route editing actions and primary-pointer caret placement to the shared editor.
///
/// Shift-click extends the selection. The enclosing element supplies focus
/// tracking and the `TextInput` key context used by the example's bindings.
pub fn standard_actions<E: InteractiveElement>(editor: Entity<Editor>) -> impl FnOnce(E) -> E {
    move |element| {
        element
            .on_action({
                let editor = editor.clone();
                move |a: &Left, window, cx| editor.update(cx, |e, cx| e.left(a, window, cx))
            })
            .on_action({
                let editor = editor.clone();
                move |a: &Right, window, cx| editor.update(cx, |e, cx| e.right(a, window, cx))
            })
            .on_action({
                let editor = editor.clone();
                move |a: &Home, window, cx| editor.update(cx, |e, cx| e.home(a, window, cx))
            })
            .on_action({
                let editor = editor.clone();
                move |a: &End, window, cx| editor.update(cx, |e, cx| e.end(a, window, cx))
            })
            .on_action({
                let editor = editor.clone();
                move |a: &Backspace, window, cx| {
                    editor.update(cx, |e, cx| e.backspace(a, window, cx))
                }
            })
            .on_action({
                let editor = editor.clone();
                move |a: &Delete, window, cx| editor.update(cx, |e, cx| e.delete(a, window, cx))
            })
            .on_mouse_down(MouseButton::Left, move |event, window, cx| {
                editor.update(cx, |editor, cx| {
                    editor.select_at(event.position, event.modifiers.shift, window, cx)
                });
            })
    }
}

#[cfg(all(test, feature = "test-support"))]
#[path = "example_editor/tests.rs"]
mod tests;
