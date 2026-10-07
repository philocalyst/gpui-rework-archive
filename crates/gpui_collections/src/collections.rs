//! Small collection aliases used throughout GPUI.
//!
//! The hash aliases use the fast, deterministic hashers expected by in-process UI
//! data structures. They are implementation conveniences, not a stable wire format.

/// Fast hash map alias used throughout GPUI.
pub type HashMap<K, V> = FxHashMap<K, V>;
/// Fast hash set alias used throughout GPUI.
pub type HashSet<T> = FxHashSet<T>;
/// Insertion-ordered map using GPUI's fast hasher.
pub type IndexMap<K, V> = indexmap::IndexMap<K, V, rustc_hash::FxBuildHasher>;
/// Insertion-ordered set using GPUI's fast hasher.
pub type IndexSet<T> = indexmap::IndexSet<T, rustc_hash::FxBuildHasher>;
/// Hash map keyed by [`std::any::TypeId`].
pub type TypeIdHashMap<V> =
    std::collections::HashMap<std::any::TypeId, V, gpui_util::TypeIdHashBuilder>;
/// Hash set keyed by [`std::any::TypeId`].
pub type TypeIdHashSet = std::collections::HashSet<std::any::TypeId, gpui_util::TypeIdHashBuilder>;

pub use indexmap::Equivalent;
pub use rustc_hash::{FxBuildHasher, FxHashMap, FxHashSet, FxHasher};
pub use std::collections::*;

pub mod vecmap;
#[cfg(test)]
mod vecmap_tests;
