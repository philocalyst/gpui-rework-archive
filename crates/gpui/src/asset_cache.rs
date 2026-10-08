//! Typed asynchronous application resources.
//!
//! [`crate::Asset`] describes how one cloneable source key becomes a cloneable output. The application
//! supplies the cache and schedules the future returned by [`crate::Asset::load`]; an implementation
//! should keep the key cheap to clone and capture owned data rather than borrowing from [`crate::App`].
//! This is the asynchronous resource path. [`crate::AssetRegistry`] is a separate byte registry
//! whose on-demand callbacks run synchronously.
//!
//! The typical flow is: choose a source key such as [`crate::Resource::Uri`] or [`crate::Resource::Embedded`],
//! request it with [`crate::App::fetch_asset`], and await the shared task in a
//! foreground task that updates the owning entity. The app retains the cached
//! request; dropping one caller's shared task does not cancel it. During
//! rendering, [`crate::Window::use_asset`] polls the cache and arranges a
//! notification for the view that starts the request. The associated `Output` is
//! cloneable because the app cache can share the completed value among consumers. Errors remain
//! part of the output type—for example `Result<T, E>`—and [`crate::AssetLogger`] can log a failed result
//! while preserving it for the UI to handle.
//!
//! [`crate::Resource`] is only a family of source-key shapes. A URI is not fetched by this enum, a path
//! is not read until the asset's loader does so, and an embedded key needs an implementation that
//! knows how to resolve its name.

use crate::{App, SharedString, SharedUri};
use futures::{Future, TryFutureExt};

use std::fmt::Debug;
use std::hash::{BuildHasher, Hash};
use std::marker::PhantomData;
use std::path::{Path, PathBuf};
use std::sync::Arc;

/// Common source-key forms for an asset implementation.
///
/// This enum describes a location; it does not perform I/O or guarantee that a resource exists.
#[derive(Debug, PartialEq, Eq, Hash, Clone)]
pub enum Resource {
    /// A URI resolved by the application's resource loader.
    Uri(SharedUri),
    /// A filesystem path. The path is not read until the associated asset loads.
    Path(Arc<Path>),
    /// A logical key for bytes embedded in the application.
    Embedded(SharedString),
}

impl From<SharedUri> for Resource {
    fn from(value: SharedUri) -> Self {
        Self::Uri(value)
    }
}

impl From<PathBuf> for Resource {
    fn from(value: PathBuf) -> Self {
        Self::Path(value.into())
    }
}

impl From<Arc<Path>> for Resource {
    fn from(value: Arc<Path>) -> Self {
        Self::Path(value)
    }
}

/// Maps a cheap, cloneable source key to an asynchronously loaded, cloneable output.
///
/// GPUI owns scheduling and caching. `load` receives a temporary mutable [`App`] only to obtain
/// application services while constructing the future; the future must be `'static` and
/// `Send`, so it cannot retain a borrow of that app. Represent expected failure in `Output`,
/// commonly as `Result<OutputValue, Error>`, so the caller can present or recover from it.
pub trait Asset: 'static {
    /// The key used to identify one load request.
    type Source: Clone + Hash + Send;

    /// The value delivered when loading finishes.
    type Output: Clone + Send;

    /// Start loading `source` using application services.
    fn load(
        source: Self::Source,
        cx: &mut App,
    ) -> impl Future<Output = Self::Output> + Send + 'static;
}

/// An [`Asset`] adapter that logs failed `Result` loads before returning the result unchanged.
///
/// This is useful when a load failure should appear in logs and still reach the requesting UI.
/// It does not turn an error into a fallback value or consume the error.
pub enum AssetLogger<T> {
    #[doc(hidden)]
    _Phantom(PhantomData<T>, &'static dyn crate::seal::Sealed),
}

impl<T, R, E> Asset for AssetLogger<T>
where
    T: Asset<Output = Result<R, E>>,
    R: Clone + Send,
    E: Clone + Send + Debug,
{
    type Source = T::Source;

    type Output = T::Output;

    fn load(
        source: Self::Source,
        cx: &mut App,
    ) -> impl Future<Output = Self::Output> + Send + 'static {
        let load = T::load(source, cx);
        load.inspect_err(|e| log::error!("Failed to load asset: {:?}", e))
    }
}

/// Hash `data` with GPUI's fast, non-cryptographic hasher.
///
/// Use this for in-process cache keys and IDs, never for security decisions or persistent formats.
pub fn hash<T: Hash>(data: &T) -> u64 {
    collections::FxBuildHasher.hash_one(data)
}
