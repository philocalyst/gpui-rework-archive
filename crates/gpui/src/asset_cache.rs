//! Traits and keys for asynchronous application asset loading.
//!
//! An [`Asset`] describes how a source key becomes a cloneable output. GPUI owns the cache and
//! schedules the future through the application; implementations should keep source keys cheap to
//! clone and avoid borrowing from the [`App`] passed to [`Asset::load`].

use crate::{App, SharedString, SharedUri};
use futures::{Future, TryFutureExt};

use std::fmt::Debug;
use std::hash::{BuildHasher, Hash};
use std::marker::PhantomData;
use std::path::{Path, PathBuf};
use std::sync::Arc;

/// Where an asset can be obtained.
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

/// Describes an asynchronously loaded, cloneable asset type.
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

/// An [`Asset`] adapter that logs failed `Result` loads before returning them unchanged.
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
