//! Standalone retained-tree foundation. No renderer, application runtime, or platform host.
#![forbid(unsafe_code)]

pub mod damage;
pub mod geometry;
pub mod inspect;
#[cfg(feature = "layout")]
pub mod layout;
pub mod spatial;
pub mod tree;

pub use damage::Damage;
pub use geometry::{Affine, CoordinateSpace, Geometry, MappedBounds, Point, Rect};
pub use spatial::SpatialTree;
pub use tree::{NodeId, NodeIdRange, NodeKind, Tree, TreeError};
