use derive_more::{Deref, DerefMut};

use crate::SharedString;

/// A URI held in a [`SharedString`], so cloning it doesn't copy the text.
///
/// The text is not checked. Converting a `SharedUri` into an [`ImageSource`](crate::ImageSource)
/// always fetches it as a URL, which skips the check that a plain `&str` gets. See that type for
/// how strings are read.
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
