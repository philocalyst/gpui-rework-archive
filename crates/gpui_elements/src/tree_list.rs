//! A virtualized, keyboard-accessible tree list with stable IDs, selection,
//! expansion, and optional editable labels.
//!
//! The model is deliberately separate from the widget: implement [`TreeModel`]
//! for the application's data (or a shared interior-mutable wrapper), and give
//! the widget a label adapter. The core projection and selection types are also
//! public for applications that need to reuse tree behavior outside this view.

pub mod animation;
mod dnd;
mod drag;
mod element;
mod model;
mod selection;
mod state;

pub use dnd::*;
pub use drag::*;
pub use element::*;
pub use model::*;
pub use selection::*;
pub use state::*;

#[cfg(test)]
mod tests;
#[cfg(test)]
mod virtualization_tests;
