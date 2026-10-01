//! Composable text documents, atomic edits, and typed annotations.
//!
//! Rich text and plain inputs share GPUI's existing editing, selection, and IME
//! primitives. Formats and application semantics remain ordinary Rust code.

#![doc = include_str!("../../../docs/rich-text-guide.md")]

mod changes;
mod document;
mod element;
mod inline;
mod navigation;
mod ranges;

pub use changes::*;
pub use document::*;
pub use element::*;
pub use inline::*;
pub use ranges::*;
