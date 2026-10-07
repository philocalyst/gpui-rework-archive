//! Platform text input for the focused interpreted GPUI window.
use crate::renderer::InputHandler;
use gpui::*;
use gpui_codepen_guest::{Frame, InputMessage, TextEdit};
use std::{ops::Range, sync::Arc};
pub(crate) struct TextProxy {
    pub frame: Arc<Frame>,
    pub origin: Point<Pixels>,
    pub input: InputHandler,
}
impl TextProxy {
    fn edit(&self, edit: TextEdit, window: &mut Window, cx: &mut App) {
        (self.input)(InputMessage::Text(edit), window, cx);
    }
    fn offset(&self, bounds: Bounds<Pixels>) -> Bounds<Pixels> {
        Bounds {
            origin: bounds.origin + self.origin,
            ..bounds
        }
    }
}
impl gpui::InputHandler for TextProxy {
    fn selected_text_range(
        &mut self,
        ignore_disabled: bool,
        _: &mut Window,
        _: &mut App,
    ) -> Option<UTF16Selection> {
        let state = self.frame.text.as_ref()?;
        if ignore_disabled || state.accepts_input {
            state.selection.clone()
        } else {
            None
        }
    }
    fn marked_text_range(&mut self, _: &mut Window, _: &mut App) -> Option<Range<usize>> {
        self.frame.text.as_ref()?.marked.clone()
    }
    fn text_for_range(
        &mut self,
        range: Range<usize>,
        adjusted: &mut Option<Range<usize>>,
        _: &mut Window,
        _: &mut App,
    ) -> Option<String> {
        let state = self.frame.text.as_ref()?;
        let start = range.start.max(state.range.start);
        let end = range.end.min(state.range.end);
        if end < start {
            return None;
        }
        let a = utf16_to_utf8_offset(&state.text, start - state.range.start);
        let b = utf16_to_utf8_offset(&state.text, end - state.range.start);
        *adjusted = Some(
            (state.range.start + utf8_to_utf16_offset(&state.text, a))
                ..(state.range.start + utf8_to_utf16_offset(&state.text, b)),
        );
        Some(state.text.get(a..b)?.into())
    }
    fn replace_text_in_range(
        &mut self,
        range: Option<Range<usize>>,
        text: &str,
        window: &mut Window,
        cx: &mut App,
    ) {
        self.edit(
            TextEdit::Replace {
                range,
                text: text.into(),
            },
            window,
            cx,
        );
    }
    fn replace_and_mark_text_in_range(
        &mut self,
        range: Option<Range<usize>>,
        text: &str,
        selection: Option<Range<usize>>,
        window: &mut Window,
        cx: &mut App,
    ) {
        self.edit(
            TextEdit::Mark {
                range,
                text: text.into(),
                selection,
            },
            window,
            cx,
        );
    }
    fn unmark_text(&mut self, window: &mut Window, cx: &mut App) {
        self.edit(TextEdit::Unmark, window, cx);
    }
    fn set_selected_text_range(&mut self, range: Range<usize>, window: &mut Window, cx: &mut App) {
        self.edit(TextEdit::Select { range }, window, cx);
    }
    fn bounds_for_range(
        &mut self,
        range: Range<usize>,
        _: &mut Window,
        _: &mut App,
    ) -> Option<Bounds<Pixels>> {
        let state = self.frame.text.as_ref()?;
        if state.selection.as_ref().is_some_and(|s| s.range == range) {
            return state.selection_bounds.map(|b| self.offset(b));
        }
        if range.is_empty()
            && state.selection.as_ref().is_some_and(|s| {
                range.start
                    == if s.reversed {
                        s.range.start
                    } else {
                        s.range.end
                    }
            })
        {
            return state.caret_bounds.map(|b| self.offset(b));
        }
        None
    }
    fn character_index_for_point(
        &mut self,
        _: Point<Pixels>,
        _: &mut Window,
        _: &mut App,
    ) -> Option<usize> {
        None
    }
    fn element_bounds(&mut self, _: &mut Window, _: &mut App) -> Option<Bounds<Pixels>> {
        self.frame
            .text
            .as_ref()?
            .element_bounds
            .map(|b| self.offset(b))
    }
    fn text_length_utf16(&mut self, _: &mut Window, _: &mut App) -> Option<usize> {
        self.frame.text.as_ref()?.length
    }
    fn accepts_text_input(&mut self, _: &mut Window, _: &mut App) -> bool {
        self.frame
            .text
            .as_ref()
            .is_some_and(|state| state.accepts_input)
    }
    fn text_input_editable_range(&mut self, _: &mut Window, _: &mut App) -> Option<Range<usize>> {
        self.frame.text.as_ref()?.editable_range.clone()
    }
    fn prefers_ime_for_printable_keys(&mut self, _: &mut Window, _: &mut App) -> bool {
        self.frame
            .text
            .as_ref()
            .is_some_and(|state| state.prefers_ime)
    }
    fn text_input_configuration(&mut self, _: &mut Window, _: &mut App) -> TextInputConfiguration {
        self.frame
            .text
            .as_ref()
            .map(|state| state.configuration.clone())
            .unwrap_or_default()
    }
}
