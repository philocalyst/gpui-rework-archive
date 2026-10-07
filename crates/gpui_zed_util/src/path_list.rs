//! Ordered, deduplicated collections of paths.
//!
//! `PathList` stores paths in canonical lexical order and retains a separate permutation for the
//! caller's input order. Equality and hashing ignore that presentation order; use `ordered_paths`
//! when the original sequence matters.

use std::{
    hash::{Hash, Hasher},
    path::{Path, PathBuf},
    sync::Arc,
};

use crate::paths::SanitizedPath;
use itertools::Itertools;
use serde::{Deserialize, Serialize};

/// A list of absolute paths, with an associated display order.
///
/// Two `PathList` values are considered equal if they contain the same paths,
/// regardless of the order in which those paths were originally provided.
///
/// The paths can be retrieved in the original order using `ordered_paths()`.
#[derive(Default, Debug, Clone)]
/// A set of paths with a stable display order and an explicit ordering index.
pub struct PathList {
    /// The paths, in lexicographic order.
    paths: Arc<[PathBuf]>,
    /// The order in which the paths were provided.
    ///
    /// See `ordered_paths()` for a way to get the paths in the original order.
    order: Arc<[usize]>,
}

impl PartialEq for PathList {
    fn eq(&self, other: &Self) -> bool {
        self.paths == other.paths
    }
}

impl Eq for PathList {}

impl Hash for PathList {
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.paths.hash(state);
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
/// Serializable representation of a [`PathList`].
pub struct SerializedPathList {
    /// Paths serialized in lexical order.
    pub paths: String,
    /// Serialized permutation describing display order.
    pub order: String,
}

impl PathList {
    /// Build a path list, retaining the input paths and their original order.
    pub fn new<P: AsRef<Path>>(paths: &[P]) -> Self {
        let mut indexed_paths: Vec<(usize, PathBuf)> = paths
            .iter()
            .enumerate()
            .map(|(ix, path)| (ix, SanitizedPath::new(path).into()))
            .collect();
        indexed_paths.sort_by(|(_, a), (_, b)| a.cmp(b));
        let order = indexed_paths.iter().map(|e| e.0).collect::<Vec<_>>().into();
        let paths = indexed_paths
            .into_iter()
            .map(|e| e.1)
            .collect::<Vec<_>>()
            .into();
        Self { order, paths }
    }

    /// Return whether the list contains no paths.
    pub fn is_empty(&self) -> bool {
        self.paths.is_empty()
    }

    /// Returns a new `PathList` with the given path removed.
    /// Return a copy with every occurrence of `path_to_remove` omitted.
    pub fn without_path(&self, path_to_remove: &Path) -> PathList {
        let paths: Vec<PathBuf> = self
            .ordered_paths()
            .filter(|p| p.as_path() != path_to_remove)
            .cloned()
            .collect();
        PathList::new(&paths)
    }

    /// Get the paths in lexicographic order.
    /// Borrow the stored paths in storage order.
    pub fn paths(&self) -> &[PathBuf] {
        self.paths.as_ref()
    }

    /// Get the paths in the lexicographic order.
    /// Clone the stored paths into an atomically shareable slice.
    pub fn paths_owned(&self) -> Arc<[PathBuf]> {
        self.paths.clone()
    }

    /// Get the order in which the paths were provided.
    /// Borrow the indexes that define the display order.
    pub fn order(&self) -> &[usize] {
        self.order.as_ref()
    }

    /// Get the paths in the original order.
    /// Iterate over paths in display order.
    pub fn ordered_paths(&self) -> impl Iterator<Item = &PathBuf> {
        self.order
            .iter()
            .zip(self.paths.iter())
            .sorted_by_key(|(i, _)| **i)
            .map(|(_, path)| path)
    }

    /// Return whether display order is already lexical path order.
    pub fn is_lexicographically_ordered(&self) -> bool {
        self.order.iter().enumerate().all(|(i, &j)| i == j)
    }

    /// Decode a serialized list, repairing invalid indexes by using storage order.
    pub fn deserialize(serialized: &SerializedPathList) -> Self {
        let mut paths: Vec<PathBuf> = if serialized.paths.is_empty() {
            Vec::new()
        } else {
            serialized.paths.split('\n').map(PathBuf::from).collect()
        };

        let mut order: Vec<usize> = serialized
            .order
            .split(',')
            .filter_map(|s| s.parse().ok())
            .collect();

        if !paths.is_sorted() || order.len() != paths.len() {
            order = (0..paths.len()).collect();
            paths.sort();
        }

        Self {
            paths: paths.into(),
            order: order.into(),
        }
    }

    /// Encode this list without changing its path or display order.
    pub fn serialize(&self) -> SerializedPathList {
        use std::fmt::Write as _;

        let mut paths = String::new();
        for path in self.paths.iter() {
            if !paths.is_empty() {
                paths.push('\n');
            }
            paths.push_str(&path.to_string_lossy());
        }

        let mut order = String::new();
        for ix in self.order.iter() {
            if !order.is_empty() {
                order.push(',');
            }
            write!(&mut order, "{}", *ix).unwrap();
        }
        SerializedPathList { paths, order }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_path_list() {
        let list1 = PathList::new(&["a/d", "a/c"]);
        let list2 = PathList::new(&["a/c", "a/d"]);

        assert_eq!(list1.paths(), list2.paths(), "paths differ");
        assert_eq!(list1.order(), &[1, 0], "list1 order incorrect");
        assert_eq!(list2.order(), &[0, 1], "list2 order incorrect");

        // Same paths in different order are equal (order is display-only).
        assert_eq!(
            list1, list2,
            "same paths with different order should be equal"
        );

        let list1_deserialized = PathList::deserialize(&list1.serialize());
        assert_eq!(list1_deserialized, list1, "list1 deserialization failed");

        let list2_deserialized = PathList::deserialize(&list2.serialize());
        assert_eq!(list2_deserialized, list2, "list2 deserialization failed");

        assert_eq!(
            list1.ordered_paths().collect_array().unwrap(),
            [&PathBuf::from("a/d"), &PathBuf::from("a/c")],
            "list1 ordered paths incorrect"
        );
        assert_eq!(
            list2.ordered_paths().collect_array().unwrap(),
            [&PathBuf::from("a/c"), &PathBuf::from("a/d")],
            "list2 ordered paths incorrect"
        );
    }

    #[test]
    fn test_path_list_ordering() {
        let list = PathList::new(&["b", "a", "c"]);
        assert_eq!(
            list.paths(),
            &[PathBuf::from("a"), PathBuf::from("b"), PathBuf::from("c")]
        );
        assert_eq!(list.order(), &[1, 0, 2]);
        assert!(!list.is_lexicographically_ordered());

        let serialized = list.serialize();
        let deserialized = PathList::deserialize(&serialized);
        assert_eq!(deserialized, list);

        assert_eq!(
            deserialized.ordered_paths().collect_array().unwrap(),
            [
                &PathBuf::from("b"),
                &PathBuf::from("a"),
                &PathBuf::from("c")
            ]
        );

        let list = PathList::new(&["b", "c", "a"]);
        assert_eq!(
            list.paths(),
            &[PathBuf::from("a"), PathBuf::from("b"), PathBuf::from("c")]
        );
        assert_eq!(list.order(), &[2, 0, 1]);
        assert!(!list.is_lexicographically_ordered());

        let serialized = list.serialize();
        let deserialized = PathList::deserialize(&serialized);
        assert_eq!(deserialized, list);

        assert_eq!(
            deserialized.ordered_paths().collect_array().unwrap(),
            [
                &PathBuf::from("b"),
                &PathBuf::from("c"),
                &PathBuf::from("a"),
            ]
        );
    }
}
