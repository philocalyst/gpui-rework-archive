//! Traits commonly needed to build an element tree.
//!
//! Import `gpui::prelude::*` to bring style, children, interaction, and component
//! methods into scope. Constructors and application types are still named
//! imports:
//!
//! ```rust
//! use gpui::{div, prelude::*, text};
//!
//! let panel = div().flex().p_4().child(text!("Ready"));
//! ```
//!
//! [`AppContext`](crate::AppContext) and [`TaskExt`](crate::TaskExt) are imported
//! anonymously: their extension methods are available without occupying those
//! names. Import either trait by name when a generic bound needs to name it.

pub use crate::{
    AppContext as _, BorrowAppContext, Context, Element, InteractiveElement, IntoElement,
    ParentElement, Refineable, Render, RenderOnce, StatefulInteractiveElement, Styled, StyledImage,
    TaskExt as _, VisualContext, util::FluentBuilder,
};
