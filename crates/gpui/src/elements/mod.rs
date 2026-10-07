//! Built-in elements for composing GPUI interfaces.
//!
//! [`div`](crate::div) is the general container: it combines style, children, accessibility, and
//! interaction. Use [`list`](crate::list) or [`uniform_list`](crate::uniform_list) for large
//! scrollable collections, [`crate::text!`] for text layout, and [`canvas`](crate::canvas)
//! when a small custom paint callback is enough. The examples site connects API pages to runnable
//! walkthroughs, including [visible list ranges](https://gpui-ce.github.io/examples/lists/#visible-range)
//! and [custom paint](https://gpui-ce.github.io/examples/drawing/#paint).

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
