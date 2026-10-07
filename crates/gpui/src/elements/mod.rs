//! Built-in elements for composing GPUI interfaces.
//!
//! Choose an element by the work it owns:
//!
//! - [`div`](crate::div) is the general styled container for child layout, clipping, accessibility,
//!   and pointer/keyboard interaction.
//! - [`list`](crate::list) virtualizes rows with varying heights; [`uniform_list`](crate::uniform_list)
//!   uses one measured row height to lay out a large fixed-height collection efficiently.
//! - [`crate::text!`], [`StyledText`], and [`InteractiveText`] cover inherited text, styled runs,
//!   and text-range pointer behavior.
//! - [`canvas`](crate::canvas) adds custom painting when style can provide the layout; implement
//!   [`Element`](crate::Element) for custom measurement or phase behavior.
//! - [`img`](crate::img), [`svg`](crate::svg), and [`surface`](crate::surface) paint image-like
//!   resources or platform surfaces.
//! - [`anchored`](crate::anchored), [`container_query`](crate::container_query), and
//!   [`deferred`](crate::deferred) change when content is positioned or selected in the frame.
//! - [`AnimationExt`] retains time or spring state under an element ID while rebuilding its child.
//!
//! See the [rendering guide](crate::_documentation::rendering) for component choice, phase order,
//! identity, and list sizing. Runnable walkthroughs include [visible list ranges](https://gpui-ce.github.io/examples/lists/#visible-range),
//! [custom paint](https://gpui-ce.github.io/examples/drawing/#paint), and [custom elements](https://gpui-ce.github.io/examples/custom-element/).

mod anchored;
mod animation;
mod canvas;
mod container_query;
mod deferred;
mod div;
mod image_cache;
mod img;
mod list;
mod surface;
mod svg;
mod text;
mod uniform_list;

pub use anchored::*;
pub use animation::*;
pub use canvas::*;
pub use container_query::*;
pub use deferred::*;
pub use div::*;
pub use image_cache::*;
pub use img::*;
pub use list::*;
pub use surface::*;
pub use svg::*;
pub use text::*;
pub use uniform_list::*;
