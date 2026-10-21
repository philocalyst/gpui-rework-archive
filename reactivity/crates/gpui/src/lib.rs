//! Typed GPUI views with owner-relative sources and coherent retained output.
//!
//! Native hosting is an adapter over this same runtime. `Win::demo` uses its
//! ordinary input, layout, text, presentation and inspection paths without an OS
//! window. This implementation is under construction; see the crate README for
//! the supported surface and integration gates.
#![forbid(unsafe_code)]

mod component;
mod element;
mod identity;
pub mod property;
mod runtime;
pub mod source;
mod style;

pub use component::Component;
pub use element::{
    ChildSeq, El, Element, IntoHandler, button, column, div, label, row, text, text_input,
};
pub use gpui_canvas::{ColorConfig, ColorSpace, OutputProfile, PixelFormat, SdrMapping};
pub use gpui_reactivity_core::{Affine, Point, Rect};
pub use gpui_reactivity_state::{Handoff, Signal};
pub use identity::Target;
pub use runtime::{
    Commit, Counters, Error, PresentationToken, SetError, Snapshot, SnapshotNode, Win,
    WindowOptions,
};
pub use source::{BindError, FieldAction, FieldId, IntoText, Source, Sources, TextValue};
pub use style::{Color, Flex, Flow, IntoLength, Style, rgb};

/// A component describes ordinary borrowed operands. No mutable runtime or
/// ambient frame is available in this method.
pub trait View {
    fn view(&self) -> El<'_>;

    /// Optional explicit source declarations. Plain views require no schema.
    /// Declaring sources adds fine-grained control/field operations without
    /// changing the view's constructor/branching language.
    fn sources() -> Sources<Self>
    where
        Self: Sized,
    {
        Sources::new()
    }
}

pub mod prelude {
    pub use crate::{
        Affine, Color, Component, El, Element, FieldId, Flex, Flow, Handoff, Point, Rect, Signal,
        Source, Sources, Target, View, Win, button, column, div, label, rgb, row, text, text_input,
    };
}
