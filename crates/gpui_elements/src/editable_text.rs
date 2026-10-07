//! Editable text fields built from GPUI elements.
//!
//! This module provides a single-line [`text_input`] and multiline [`text_area`], both
//! backed by [`EditableTextState`]. Use these controls for forms, search boxes, and short messages.
//! They are not a document editor: the default [`StringStorage`] rebuilds a shared text snapshot
//! after mutations, and history is limited to one field with bounded patch entries.
//!
//! `EditableTextState` owns text, selection, composition, and focus. Keep that entity alive across
//! renders with [`EditableTextState::use_keyed`] or initialize custom storage with
//! [`EditableTextState::use_keyed_init`], then pass its downgraded handle to
//! [`EditableTextElement::state`]. User edits emit [`TextChanged`]; use `emplace` for programmatic
//! replacement. That event is after the change, so validate or normalize external input before
//! calling `emplace` rather than treating it as an interception hook.
//!
//! GPUI stores selection positions as UTF-8 byte offsets. The web platform converts browser and
//! IME UTF-16 positions at its input boundary; custom [`UnicodeTextStorage`] implementations must
//! expose valid UTF-8 slices and implement UTF-16 length consistently. A byte offset is not a
//! Unicode scalar count or a grapheme count. Use [`EditableTextState::nav_linear`] for
//! character/word movement and [`EditableTextState::move_to`] when you already have a byte offset.
//!
//! # Field choice and layout
//!
//! `text_input` disables multiline navigation and newline keyboard insertion. It strips CR and LF
//! from user-entered paste and IME text, but programmatic `emplace` can still set multiline content.
//! For multiline input use `text_area`; add `whitespace_normal()` when you want wrapping. These
//! functions only configure text behavior; apply GPUI style and overflow properties to size and
//! scroll the field. `overflow_x_scroll` is useful for a nowrap input; use wrapping and usually
//! vertical scroll for a message area.
//!
//! # Basic form field
//!
//! ```
//! # use gpui::{App, AppContext, ElementId, IntoElement, RenderOnce, Window};
//! # use gpui_ce_elements::editable_text::{EditableTextState, StringStorage, text_input};
//! struct SearchField;
//! impl RenderOnce for SearchField {
//!     fn render(self, window: &mut Window, cx: &mut App) -> impl IntoElement {
//!         let id = ElementId::from("search");
//!         let state = EditableTextState::use_keyed_init(id.clone(), window, cx, |_, _| {
//!             StringStorage::from("initial query")
//!         });
//!         text_input(id)
//!             .state(state.downgrade())
//!             .placeholder("Search")
//!             .whitespace_nowrap()
//!             .overflow_x_scroll()
//!     }
//! }
//! ```
//!
//! The equivalent browser elements are [`<input>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/input)
//! and [`<textarea>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/textarea).
//! Both constructors return [`EditableTextElement`]. It supports:
//! - navigating via keyboard & mouse (by character, word, line, and document)
//! - highlight selection via keyboard & mouse (holding shift, double/triple click mouse, mouse drag)
//! - text input through an Input Method Editor (IME), including composition-based scripts
//! - inserting newlines (`\n`) and tabs (`\t`)
//! - cut/copy/paste
//! - caret / text cursor that can blink
//! - simple undo/redo within a single field
//!
//! For all input actions, see documentation in the [`actions`] module.
//!
//! Storage and history use UTF-8 byte ranges. [`StringStorage`] is a simple default for fields; a
//! long document can provide a custom [`UnicodeTextStorage`] that avoids repeatedly materializing
//! the whole document string. Custom storage must update its `version` whenever its content changes.
//!
//! Unlike other elements, editable text internally owns its [`FocusHandle`](gpui::FocusHandle).
//! This is required due to limitations of the [`Interactivity`](gpui::Interactivity) api and
//! that a user cannot interact with a text-input field if it cannot be focused.
//!
//! ### Usage Samples
//!
//! A single-line text input with a fixed width and text that does not wrap
//! (overflow text is clipped and does not scroll).
//! ```
//! # use gpui::prelude::*;
//! # fn test() -> gpui_ce_elements::editable_text::EditableTextElement {
//! use gpui_ce_elements::editable_text::text_input;
//! text_input("my_input")
//!     .placeholder("empty text")
//!     .w_5()
//!     .min_h_auto()
//!     .whitespace_nowrap()
//! # }
//! ```
//!
//! A single-line text input with a flexible width and text that does not wrap, but will scroll if overflowing.
//! ```
//! # use gpui::{prelude::*, Hsla};
//! # fn test() -> gpui_ce_elements::editable_text::EditableTextElement {
//! use gpui_ce_elements::editable_text::text_input;
//! text_input("my_input")
//!     .placeholder("empty text")
//!     .border_1().rounded_lg().border_color(gpui::white()) // has a border
//!     .p_2() // padding between the text and border
//!     .min_w_10().max_w_128()
//!     .min_h_auto()
//!     .whitespace_nowrap()
//!     .overflow_x_scroll()
//! # }
//! ```
//!
//! A multi-line text area with flexible height, wrapping text, and scrolling overflow on both axes.
//! ```
//! # use gpui::{prelude::*, Hsla};
//! # fn test() -> gpui_ce_elements::editable_text::EditableTextElement {
//! use gpui_ce_elements::editable_text::text_area;
//! text_area("message")
//!     .placeholder("empty text")
//!     .border_1().rounded_lg().border_color(gpui::white()) // has a border
//!     .p_2() // padding between the text and border
//!     .min_w_10().max_w_128()
//!     .min_h_24().max_h_128()
//!     .whitespace_normal() // default
//!     .overflow_y_scroll()
//! # }
//! ```
//!
//! The user-inputted text can be accessed via event callbacks on the element.
//! There is no dedicated "editing finished" event. Subscribe to [`TextChanged`] for each content
//! update and debounce expensive work when appropriate. `EditableTextState` clears selection on
//! blur, but does not emit a separate focus-lost event for the field.
//! ```
//! # use gpui::{prelude::*, App, Entity, Window, AppContext, ElementId};
//! # fn test(window: &mut Window, cx: &mut App) -> gpui_ce_elements::editable_text::EditableTextElement {
//! use gpui_ce_elements::editable_text::{text_input, EditableTextState, TextChanged};
//!
//! // A unique id to the editable text element within the outer scope.
//! let id = ElementId::from("my_input");
//!
//! // Find or lazily create the state entity backing the element.
//! // Then attach the entity to the element, thereby keeping it alive across consecutive frames.
//! let state = EditableTextState::use_keyed(id.clone(), window, cx);
//!
//! // This will trigger on every character input or other mutation to the underlying string
//! cx.subscribe(&state, |state, _: &TextChanged, cx| {
//! 	println!("{:?}", state.read(cx).as_str());
//! }).detach();
//!
//! // Using state explicitly attaches the state we already have attached to the ElementId.
//! text_input(id).state(state.downgrade())
//! # }
//! ```
//!
//! You can configure the default value of the editable text by using [`use_keyed_init`]:
//! ```
//! # use gpui::{prelude::*, App, Entity, Window, AppContext, ElementId};
//! # use gpui_ce_elements::editable_text::{text_input, EditableTextState, StringStorage};
//! # fn test(window: &mut Window, cx: &mut App) -> gpui_ce_elements::editable_text::EditableTextElement {
//! let id = ElementId::from("my_input");
//!
//! // The function parameter will only be called when the state is created/initialized.
//! // All successive renders across consecutive frames will re-use the existing state.
//! let _state = EditableTextState::use_keyed_init(id.clone(), window, cx,
//!     |_window, _cx| StringStorage::from("this is some default text content"));
//!
//! // Its also plausible to omit the state function call. The element will try to find the state
//! // according to its id (which we are trusting here was guaranteed to be at that id above).
//! // Despite this functionality, its recommended that callers which construct a state explicitly
//! // provide it to the element, at least for clarity and debugging.
//! text_input(id)
//! # }
//! ```
//!
//! To use a blinking caret, you can use one of the templated functions:
//! ```
//! # use gpui::{prelude::*, App, Entity, Window, AppContext, ElementId};
//! # fn test(window: &mut Window, cx: &mut App) -> gpui_ce_elements::editable_text::EditableTextElement {
//! use gpui_ce_elements::editable_text::{text_input};
//! let id = ElementId::from("my_input");
//! text_input(id)
//!     .caret_blink_interval_500ms()
//!     // or use the parameterized one, e.g. 200ms
//!     .caret_blink_interval(std::time::Duration::from_millis(200))
//! # }
//! ```
//!
//! or construct a caret entity with a blinking interval when constructing the state:
//! ```
//! # use gpui::{prelude::*, App, Entity, Window, AppContext, ElementId};
//! # fn test(window: &mut Window, cx: &mut App) -> gpui_ce_elements::editable_text::EditableTextElement {
//! use gpui_ce_elements::editable_text::{text_input, EditableTextState, TextChanged, Caret};
//! let id = ElementId::from("my_input");
//!
//! let state = EditableTextState::use_keyed(id.clone(), window, cx);
//!
//! // Ensure the caret exists, linked to the input element by id.
//! window.use_keyed_state(id.clone(), cx, |window, cx| {
//!     // using the default interval of 500ms
//!     let mut caret = Caret::default().with_blink_interval_500ms();
//!     // ensures the caret receives events from the input state during typing & other actions
//!     caret.subscribe_to(&state, cx);
//!     caret
//! });
//!
//! text_input(id).state(state.downgrade())
//! # }
//! ```
//!
//! Full-text examples can be found in the [examples folder](https://github.com/gpui-ce/gpui-ce/tree/main/crates/gpui_elements/examples)
//!
//! ### Current limits
//!
//! There is no application-provided sanitation or validation hook. The built-in input path strips
//! CR and LF from single-line paste/IME edits and enforces the optional byte limit, but it does not
//! apply other application rules. PageUp and PageDown navigation, password masking, and
//! screen-reader text support are also not implemented. Tab inserts a tab by default instead of
//! moving focus to another control.
//!
//! For default key bindings and action overrides, see [`actions`]. For browser virtual-keyboard
//! and UTF-16 mirror behavior, see [`gpui_ce_web`](https://docs.rs/gpui_ce_web).
//!

pub mod actions;
mod caret;
mod element;
mod history;
mod layout;
mod state;
mod storage;

pub use caret::*;
pub use element::*;
pub use state::*;
pub use storage::*;
