//! Typed GPUI views with owner-relative sources and coherent retained output.
//!
//! Native hosting is an adapter over this same runtime. `Win::demo` uses its
//! ordinary input, layout, text, presentation and inspection paths without an OS
//! window. This implementation is under construction; see the crate README for
//! the supported surface and integration gates.
#![forbid(unsafe_code)]

#[cfg(test)]
extern crate self as gpui;

mod application;
mod component;
mod element;
mod identity;
mod image;
mod list;
#[cfg(feature = "native-core")]
mod native;
pub mod property;
mod reader;
mod remote;
mod runtime;
mod scroll;
pub mod semantic;
mod shared_text;
pub mod source;
mod style;
mod style_port;

pub use application::{Application, DemoApplication};
pub use component::Component;
pub use element::{
    ChildSeq, El, Element, IntoHandler, PropertyChange, Role, button, checkbox, column, div, label,
    property_action, row, text, text_input,
};
pub use gpui_canvas::{
    AlphaMode, CaretAffinity, ColorConfig, ColorSpace, Image, ImageKey, ImagePixels, ImageProfile,
    ImageSampling, OutputProfile, PixelFormat, SdrMapping, TextOffset, TextPosition, TextSelection,
    oklch,
};
pub use gpui_reactivity_core::{Affine, Point, Rect};
pub use gpui_reactivity_state::{Handoff, Signal};
pub use identity::Target;
pub use image::image;
pub use list::{ItemKey, ItemSource, ListError, ListId, ListViewport, uniform_list};
#[cfg(feature = "native-core")]
pub use native::{NativeError, PresentedFrame, RendererKind, RendererPolicy, Window};
pub use reader::{
    Cancellation, CompleteError, Completion, Failure, InputVersion, QuestionExecutor,
    QuestionFault, QuestionInfo, QuestionInput, QuestionInputs, QuestionStats, QuestionStatus,
    QuestionTask, Questions, Reader, ReaderKey, StartError,
};
pub use remote::{Delivery, DeliveryError, Inbox, Remote, SendError};
#[doc(hidden)]
pub use remote::{Lane, LaneSet};
pub use runtime::{
    Action, ActionKind, Actions, Commit, Counters, Error, Key, ListInfo, ListItemInfo, Part,
    PointerEvent, PointerSession, PresentationToken, Query, SemanticSnapshot, SetError, Snapshot,
    SnapshotNode, TextGeometry, Win, WindowOptions,
};
pub use scroll::{
    Axis, ScrollDelta, ScrollDirection, ScrollError, ScrollOffset, ScrollUnit, ScrollViewport,
};
pub use semantic::SemanticText;
pub use source::{BindError, FieldAction, FieldId, IntoText, Source, Sources, TextValue};
#[doc(hidden)]
pub use style::FlexRecipe;
pub use style::{Align, Color, Flex, Flow, IntoLength, Justify, Style, rgb};
pub use style_port::{IntoProp, PropInput};

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
        Action, ActionKind, Affine, Align, AlphaMode, Axis, Color, Component, El, Element, FieldId,
        Flex, Flow, Handoff, Image, ImageProfile, ImageSampling, Inbox, ItemKey, ItemSource,
        Justify, Key, ListId, Point, PointerEvent, PointerSession, Rect, Remote, ScrollDelta,
        ScrollOffset, Signal, Source, Sources, Target, View, Win, button, checkbox, column, div,
        image, label, oklch, rgb, row, text, text_input, uniform_list,
    };
}
