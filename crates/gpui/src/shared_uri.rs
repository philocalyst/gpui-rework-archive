//! Cheaply cloneable URI text used as an asset and resource key.
//!
//! `SharedUri` preserves the caller's spelling. It does not parse, canonicalize, validate, or
//! resolve a URI; use the target service to apply those policies.

use derive_more::{Deref, DerefMut};

use crate::SharedString;

/// A shared string that is intended to contain a URI.
///
/// The wrapper documents intent at API boundaries while retaining [`SharedString`] comparison,
/// hashing, and dereferencing behavior.
#[derive(Deref, DerefMut, Default, PartialEq, Eq, Hash, Clone)]
pub struct SharedUri(SharedString);

impl std::fmt::Debug for SharedUri {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        self.0.fmt(f)
    }
}

impl std::fmt::Display for SharedUri {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.0.as_ref())
    }
}

impl<T: Into<SharedString>> From<T> for SharedUri {
    fn from(value: T) -> Self {
        Self(value.into())
    }
}
