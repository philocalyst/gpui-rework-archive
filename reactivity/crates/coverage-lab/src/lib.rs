//! Conservative analytic coverage certificates and ordered tile-work elimination.
//! No renderer/GPU/backend integration, distance atlas or true area AA is claimed.
#![forbid(unsafe_code)]
mod geometry;
mod math;
mod planner;
pub use geometry::{Affine, Class, Point, Primitive, Rect, Shape, Space};
pub use planner::{Color, Operation, Plan, RenderError, Stats, render_direct};
