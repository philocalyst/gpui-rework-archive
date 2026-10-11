//! Element library written alongside gpui to be as unopinionated as possible while still providing fundamental components.

pub mod editable_text;
pub mod paint_snapshot;
pub mod tree_list;

/// Register the default component key bindings once during application setup.
///
/// This enables editing actions for standalone text fields and tree-list rename
/// fields. Register application-specific overrides after calling this function.
pub fn init(cx: &mut gpui::App) {
    use editable_text::actions::{DEFAULT_INPUT_CONTEXT, default_bindings};

    cx.bind_keys(default_bindings().as_keybindings(Some(DEFAULT_INPUT_CONTEXT)));
}
