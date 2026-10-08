//! Editable text controls for GPUI applications.
//!
//! Use [`editable_text::text_input`] for a single-line field and
//! [`editable_text::text_area`] for multiline input. Both keep their value, selection,
//! composition, and undo history in an [`editable_text::EditableTextState`] entity.
//! The [`editable_text`] module shows how to install the keymap, own that entity, and
//! respond to edits. Styling comes from GPUI's [`Styled`](gpui::Styled) trait.
//!
//! For static labels and paragraphs, use GPUI's [`StyledText`](gpui::StyledText) instead.
//! The [text chapter](https://gpui-ce.github.io/book/text.html) explains where display
//! text, editable fields, and a custom document editor need different state and layout.

pub mod editable_text;
