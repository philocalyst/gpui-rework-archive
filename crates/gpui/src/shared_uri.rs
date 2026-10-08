use derive_more::{Deref, DerefMut};

use crate::SharedString;

/// Cheaply cloneable URI text used as an asset or resource key.
///
/// This wrapper preserves the spelling and storage behavior of [`SharedString`].
/// It does not parse, validate, normalize, or resolve a URI. Equality and hashing
/// compare the stored text, so equivalent URI spellings can be distinct cache
/// keys. Apply any normalization before constructing the key when requests
/// should share a cached result.
///
/// ```
/// use gpui::{Resource, SharedUri};
///
/// let avatar: SharedUri = "https://example.test/avatar.png".into();
/// assert_eq!(avatar.as_ref(), "https://example.test/avatar.png");
/// let different_spelling: SharedUri = "https://EXAMPLE.test/avatar.png".into();
/// assert_ne!(avatar, different_spelling);
///
/// let source: Resource = avatar.into();
/// assert!(matches!(source, Resource::Uri(_)));
/// ```
///
/// Constructing this value or converting it to [`Resource::Uri`](crate::Resource::Uri)
/// starts no network work. Fetching belongs to an [`Asset`](crate::Asset)
/// implementation or the application's [`HttpClient`](crate::http_client::HttpClient).
/// The [assets chapter](crate::_documentation::assets) explains source keys,
/// cached requests, and rendering-time notification.
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
