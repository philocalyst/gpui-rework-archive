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
/// Use [`App::fetch_asset`] to schedule and cache a request, or
/// [`Window::use_asset`](crate::Window::use_asset) to start or poll it while
/// drawing a view. When calling [`load`](Self::load) directly, the caller must
/// arrange polling, caching, and completion notification for the returned future.
///
/// The app cache identifies a request by this asset type and the source's hash.
/// Include all choices that affect the result in the source key. For example,
/// include a revision when a resource can change without changing its path.
/// Completed results remain cached until explicitly removed, including errors.
/// Return a `Result` as `Output` when the UI needs to distinguish a failed load
/// from a pending one. Use `Arc` for large outputs or errors that should be
/// shared cheaply.
///
/// `load` receives a temporary mutable [`App`] to obtain services before
/// returning its future. The method itself runs on the requesting thread;
/// put expensive work inside the future. The future must be `'static` and
/// `Send`, so it cannot keep that app borrow across an await point.
///
/// # Example: delay an image load
///
/// Compose a timer and the existing image loader without borrowing the app
/// across either operation. Both the resource and delay belong to the key,
/// so requests with different delays are distinct:
///
/// ```
/// use gpui::{App, Asset, ImageAssetLoader, ImageCacheError, RenderImage, Resource};
/// use std::{sync::Arc, time::Duration};
///
/// #[derive(Clone, Hash)]
/// struct ImageRequest {
///     resource: Resource,
///     delay: Duration,
/// }
///
/// struct DelayedImage;
///
/// impl Asset for DelayedImage {
///     type Source = ImageRequest;
///     type Output = Result<Arc<RenderImage>, ImageCacheError>;
///
///     fn load(source: ImageRequest, cx: &mut App)
///         -> impl Future<Output = Self::Output> + Send + 'static
///     {
///         let timer = cx.background_executor().timer(source.delay);
///         let image = ImageAssetLoader::load(source.resource, cx);
///         async move {
///             timer.await;
///             image.await
///         }
///     }
/// }
/// ```
///
/// The future for `image` is constructed immediately and first polled after
/// the timer completes. This direct call to `ImageAssetLoader::load` does not
/// create a second cache entry for the underlying image. The complete
/// `image_loading` example adds loading and error replacements and a retry
/// action; run it with `cargo run --example image_loading`. The
/// [assets chapter](crate::_documentation::assets) connects registration,
/// decoding, cache ownership, and redraws.
pub trait Asset: 'static {
    /// The key used to identify one load request.
    ///
    /// [`App::fetch_asset`] stores its hash together with this asset's type.
    /// The cache does not compare complete source values after hashing them.
    type Source: Clone + Hash + Send;

    /// The value delivered when loading finishes.
    ///
    /// Clones are returned to consumers of the same cached task. An error is
    /// an ordinary cached output when this type is a `Result`.
    type Output: Clone + Send;

    /// Constructs the owned future that will load `source`.
    ///
    /// Obtain services from `cx` now; keep I/O and expensive computation inside
    /// the future. This method does not itself spawn or cache the future.
    fn load(
        source: Self::Source,
        cx: &mut App,
    ) -> impl Future<Output = Self::Output> + Send + 'static;
}

/// An [`Asset`] adapter that logs failed `Result` loads before returning the result unchanged.
///
/// This is useful when a load failure should appear in logs and still reach the requesting UI.
/// It does not turn an error into a fallback value or consume the error.
/// `AssetLogger<T>` is a distinct asset type from `T`, so their requests occupy
/// separate entries in [`App::fetch_asset`]'s cache. Use the same choice
/// consistently when loading and removing a request.
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
