//! Ordered input for a remote GPUI window, including the platform IME contract.
use gpui::*;
use serde::{Deserialize, Serialize};
use std::ops::Range;

#[derive(Clone, Debug, Serialize, Deserialize)]
pub enum InputMessage {
    Event(PlatformInput),
    Text(TextEdit),
}
impl From<PlatformInput> for InputMessage {
    fn from(value: PlatformInput) -> Self {
        Self::Event(value)
    }
}
#[derive(Clone, Debug, Serialize, Deserialize)]
pub enum TextEdit {
    Replace {
        range: Option<Range<usize>>,
        text: String,
    },
    Mark {
        range: Option<Range<usize>>,
        text: String,
        selection: Option<Range<usize>>,
    },
    Unmark,
    Select {
        range: Range<usize>,
    },
}
#[derive(Clone, Debug, PartialEq, Serialize, Deserialize)]
pub struct TextContext {
    pub text: String,
    pub range: Range<usize>,
    pub selection: Option<UTF16Selection>,
    pub marked: Option<Range<usize>>,
    pub caret_bounds: Option<Bounds<Pixels>>,
    pub selection_bounds: Option<Bounds<Pixels>>,
    pub element_bounds: Option<Bounds<Pixels>>,
    pub length: Option<usize>,
    pub editable_range: Option<Range<usize>>,
    pub configuration: TextInputConfiguration,
    pub accepts_input: bool,
    pub prefers_ime: bool,
}
#[cfg(feature = "interpreter")]
pub(crate) fn capture(handler: &mut PlatformInputHandler) -> TextContext {
    let selection = handler.selected_text_range(true);
    let marked = handler.marked_text_range();
    let length = handler.text_length_utf16();
    let end = length.unwrap_or_else(|| selection.as_ref().map_or(0, |s| s.range.end));
    let mut range = None;
    let text = handler
        .text_for_range(0..end, &mut range)
        .unwrap_or_default();
    TextContext {
        text,
        range: range.unwrap_or(0..end),
        caret_bounds: handler.ime_candidate_bounds(),
        selection_bounds: selection
            .as_ref()
            .and_then(|s| handler.bounds_for_range(s.range.clone())),
        selection,
        marked,
        element_bounds: handler.element_bounds(),
        length,
        editable_range: handler.text_input_editable_range(),
        configuration: handler.query_text_input_configuration(),
        accepts_input: handler.query_accepts_text_input(),
        prefers_ime: handler.query_prefers_ime_for_printable_keys(),
    }
}
