//! Editable text fields built from GPUI elements.
//!
//! This module provides a single-line [`text_input`] and multiline [`text_area`], both
//! backed by [`EditableTextState`]. Use these controls for forms, search boxes, and short messages.
//! They are not a document editor: the default [`StringStorage`] rebuilds a shared text snapshot
//! after mutations, and history is limited to one field with bounded patch entries.
//!
//! `EditableTextState` owns text, selection, composition, focus, and undo history. The element
//! displays that state and handles input. Keep the entity on an owning view when its contents must
//! survive removing the field; use keyed state when its lifetime should follow the field instead.
//! Pass a downgraded handle to [`EditableTextElement::state`] in either case.
//!
//! GPUI stores selection positions as UTF-8 byte offsets. The web platform converts browser and
//! IME UTF-16 positions at its input boundary; custom [`UnicodeTextStorage`] implementations must
//! expose valid UTF-8 slices and implement UTF-16 length consistently. A byte offset is not a
//! Unicode scalar count or a grapheme count. Use [`EditableTextState::nav_linear`] for
//! character/word movement and [`EditableTextState::move_to`] when you already have a byte offset.
//!
//! # Install the keyboard bindings
//!
//! Each field registers its action handlers and the [`actions::DEFAULT_INPUT_CONTEXT`] key context.
//! Install the bindings once during application setup, before opening the window:
//!
//! ```
//! use gpui_ce_elements::editable_text::actions::{DEFAULT_INPUT_CONTEXT, default_bindings};
//!
//! # fn setup(cx: &mut gpui::App) {
//! cx.bind_keys(default_bindings().as_keybindings(Some(DEFAULT_INPUT_CONTEXT)));
//! # }
//! ```
//!
//! Without a matching keymap, pointer interaction and platform text input can still work while
//! editing commands such as arrow navigation and undo do not. See [`actions`] for the defaults
//! and how the native and browser shortcut sets differ.
//!
//! # Choose the field and its layout
//!
//! `text_input` disables multiline navigation and newline keyboard insertion. It strips CR and LF
//! from user-entered paste and IME text, but programmatic `emplace` can still set multiline content.
//! For multiline input use `text_area`. Size, wrapping, overflow, padding, and borders come from
//! GPUI's [`Styled`](gpui::Styled) methods. Give scrolling a bounded dimension: an unconstrained
//! field can grow with its contents instead of overflowing.
//!
//! A search field can keep one line and scroll horizontally:
//!
//! ```
//! use gpui::{prelude::*, px};
//! use gpui_ce_elements::editable_text::text_input;
//!
//! let search = text_input("search")
//!     .placeholder("Search")
//!     .w(px(240.))
//!     .whitespace_nowrap()
//!     .overflow_x_scroll();
//! ```
//!
//! A message field can wrap and scroll vertically once it reaches its maximum height:
//!
//! ```
//! use gpui::{prelude::*, px};
//! use gpui_ce_elements::editable_text::text_area;
//!
//! let message = text_area("message")
//!     .placeholder("Write a message")
//!     .w(px(320.))
//!     .min_h(px(96.))
//!     .max_h(px(240.))
//!     .whitespace_normal()
//!     .overflow_y_scroll();
//! ```
//!
//! # Own the value and react to edits
//!
//! Create the state and its subscription once in the owning view's constructor. Retain the
//! [`Subscription`](gpui::Subscription) with that view. Rebuilding the element then reuses the
//! same state and does not add another event listener:
//!
//! ```
//! use gpui::{Context, Entity, IntoElement, Render, Subscription, Window, prelude::*};
//! use gpui_ce_elements::editable_text::{
//!     EditableTextState, StringStorage, TextChanged, text_input,
//! };
//!
//! struct Search {
//!     input: Entity<EditableTextState>,
//!     _changes: Subscription,
//! }
//!
//! impl Search {
//!     fn new(cx: &mut Context<Self>) -> Self {
//!         let input = cx.new(|cx| EditableTextState::new(StringStorage::default(), cx));
//!         let changes = cx.subscribe(&input, |_search, input, _: &TextChanged, cx| {
//!             println!("Current query: {}", input.read(cx).as_str());
//!             cx.notify();
//!         });
//!         Self { input, _changes: changes }
//!     }
//! }
//!
//! impl Render for Search {
//!     fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
//!         text_input("search")
//!             .state(self.input.downgrade())
//!             .w(gpui::px(240.))
//!             .whitespace_nowrap()
//!             .overflow_x_scroll()
//!     }
//! }
//! ```
//!
//! [`TextChanged`] is a notification after mutation, with no text snapshot in its payload.
//! Reading the state in its callback gives the current value, which can include later edits from
//! the same app update. Undo, redo, and provisional IME composition also publish changes. The event
//! does not mean the user has finished editing, and it cannot reject an edit. Debounce expensive
//! searches and validate application rules before submitting the value.
//! Use [`EditableTextState::emplace`] for programmatic replacement; it also emits `TextChanged`.
//!
//! # Let a field retain its own state
//!
//! For a field whose contents should disappear when it is removed, create keyed state while
//! rendering. The initializer runs only when that state is first created:
//!
//! ```
//! use gpui::{App, ElementId, IntoElement, RenderOnce, Window};
//! use gpui_ce_elements::editable_text::{EditableTextState, StringStorage, text_input};
//!
//! struct SearchField;
//! impl RenderOnce for SearchField {
//!     fn render(self, window: &mut Window, cx: &mut App) -> impl IntoElement {
//!         let id = ElementId::from("search");
//!         let state = EditableTextState::use_keyed_init(id.clone(), window, cx, |_, _| {
//!             StringStorage::from("initial query")
//!         });
//!         text_input(id).state(state.downgrade())
//!     }
//! }
//! ```
//!
//! The key must match the element's ID and be stable within its parent identity scope. Omitting
//! `.state(...)` also creates keyed state, initially empty. The explicit form gives you a handle
//! to read, update, or subscribe to. Keyed state survives consecutive frames, including reused
//! cached drawing; it does not preserve the value across removing and later recreating the field.
//! See [`Window::use_keyed_state`](gpui::Window::use_keyed_state) for the retention rules.
//!
//! # Focus, composition, and limits
//!
//! The state owns the field's [`FocusHandle`](gpui::FocusHandle) and implements
//! [`Focusable`](gpui::Focusable). Use that handle for normal GPUI focus tracking. Selection is
//! cleared on blur; there is no separate field-level "editing finished" event. A focused caret is
//! steady by default; [`caret_blink_interval_500ms`](EditableTextElement::caret_blink_interval_500ms)
//! enables blinking.
//!
//! Platform text input supports [input method editors](https://en.wikipedia.org/wiki/Input_method),
//! including in-progress composition. Storage and selection use UTF-8 bytes; the platform bridge
//! converts UTF-16 ranges at the input boundary. Custom [`UnicodeTextStorage`] must expose a valid
//! contiguous `&str` and update its version on every mutation. Custom storage can change mutation
//! costs, but the field still rebuilds a whole-value shared snapshot after content changes.
//!
//! [`with_max_bytes`](EditableTextState::with_max_bytes) rejects an oversized replacement as a
//! whole and emits [`TextLimitExceeded`]. The unit is UTF-8 bytes, not visible characters. This
//! includes programmatic `emplace`; it does not truncate a value that already exceeds the limit.
//!
//! The field contributes a text-input role, text value, and selection to GPUI's accessibility
//! tree when it is active. Give it an application-appropriate accessible name. Platform delivery
//! and the browser backend's limitations are described in
//! [GPUI's accessibility chapter](https://gpui-ce.github.io/book/accessibility.html).
//!
//! > [!WARNING]
//! > The default Tab action inserts a tab, including in `text_input`; it does not move to the next
//! > form control. Replace that binding when your form uses Tab for focus traversal. Password
//! > masking, PageUp/PageDown navigation, and an application-provided edit interception hook are
//! > not implemented.
//!
//! Run `cargo run -p gpui_ce_elements --example editable_text` from the repository for a complete
//! native example, including keymap installation and window setup.
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
pub use history::*;
pub use state::*;
pub use storage::*;
