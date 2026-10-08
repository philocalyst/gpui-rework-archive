//! Asset bytes and decoded image frames used by GPUI.
//!
//! There are two related but distinct layers. [`crate::AssetRegistry`] maps application-defined path
//! keys to bytes, either already available or provided by a [`crate::AssetEntry::OnDemand`] loader.
//! [`crate::AssetSource`] is a compatibility adapter for discovering such entries; its list and load
//! methods do not define a path syntax or normalize names. For typed asynchronous resources, see
//! [`crate::Asset`], which asks the application to load a cloneable output from a source key.
//!
//! The image decoder turns bytes into [`image::Frame`] values, and [`crate::RenderImage`] gives the
//! renderer decoded BGRA frames with per-frame delays. Asset registration/loading happens before
//! image decoding; decoding does not occur in [`crate::RenderImage::new`], which accepts frames that are
//! already decoded. SVG bytes follow a separate parse-then-rasterize path through
//! [`crate::SvgRenderer`].
//!
//! Keep asset keys stable and choose loading policy by when work is safe:
//!
//! * Use preloaded or embedded bytes when loading must not block a frame.
//! * Use [`crate::AssetEntry::OnDemand`] for deferred synchronous loading only when the caller can
//!   tolerate the loader's latency. [`crate::AssetRegistry::load`] invokes it inline.
//! * Use [`crate::Asset`] when loading is asynchronous and should be scheduled by GPUI. The
//!   returned shared task lets callers await the result while the app retains
//!   the cached request. See [`crate::App::fetch_asset`] for ownership and
//!   [`crate::Window::use_asset`] for rendering-time polling.
//!
//! Duplicate paths are errors from [`crate::AssetRegistry::insert`] and are accumulated by
//! [`crate::AssetRegistry::extend`]. A missing key returns `None`; it is distinct from an I/O error
//! returned by a [`crate::AssetSource`] implementation. The convenience iterators on `AssetSource`
//! currently log or suppress source errors as they adapt the source into registry entries, so
//! use direct `load` when the caller must handle those errors.
//!
//! ```
//! use std::borrow::Cow;
//! use gpui::AssetRegistry;
//!
//! let mut assets = AssetRegistry::default();
//! assets.insert("icons/check.svg", Cow::Borrowed(b"<svg/>".as_slice()))?;
//! let bytes = assets.load("icons/check.svg").expect("registered asset");
//! assert_eq!(bytes.as_ref(), b"<svg/>");
//! # Ok::<(), gpui::DuplicateAssetPath>(())
//! ```

use crate::{DevicePixels, Pixels, Result, SharedString, Size, size};
use gpui_util::ResultExt;
use smallvec::SmallVec;

use image::{Delay, EncodableLayout, Frame};
use std::{
    borrow::Cow,
    collections::BTreeMap,
    fmt,
    hash::Hash,
    sync::{
        Arc,
        atomic::{AtomicUsize, Ordering::SeqCst},
    },
};

/// Compatibility interface for listing and loading application asset paths.
///
/// Prefer inserting entries directly into [`AssetRegistry`] when the application already has
/// the paths and bytes. A source is useful when it owns a discoverable path set. `load` and
/// `list` return errors, but [`Self::iter_preloaded`] and [`Self::iter_ondemand`] are convenience
/// adapters that cannot report those errors to their iterator consumer: the former skips failed
/// entries, and the latter logs load errors when a deferred entry is requested.
pub trait AssetSource: 'static + Send + Sync {
    /// Load the exact source-specific path, returning `None` when it is absent.
    ///
    /// Return `Err` for an access or decoding problem. This path is interpreted by the source;
    /// GPUI does not normalize or join it.
    fn load(&self, path: &str) -> Result<Option<Cow<'static, [u8]>>>;

    /// List asset names under a source-specific path.
    ///
    /// The returned names become registry keys, so they must match the strings accepted by
    /// [`Self::load`]. GPUI does not impose whether this list is recursive.
    fn list(&self, path: &str) -> Result<Vec<SharedString>>;

    /// Iterates over all paths (via [`Self::list`]) and loads each asset in turn (via [`Self::load`]),
    /// yielding an iterator over all assets that were loaded successfully.
    /// Output can be provided directly to [`AssetRegistry::extend`].
    fn iter_preloaded(&self) -> Box<dyn Iterator<Item = (SharedString, AssetEntry)> + '_> {
        let paths = self.list("").unwrap_or_default();
        let iter = paths.into_iter().filter_map(move |path| {
            let entry = AssetEntry::from(self.load(&path).ok().flatten()?);
            Some((path, entry))
        });
        Box::new(iter)
    }

    /// Iterates over all paths (via [`Self::list`]) and constructs an [`AssetEntry::OnDemand`],
    /// which calls [`Self::load`] on this shared source when a path is requested.
    /// Output can be provided directly to [`AssetRegistry::extend`].
    fn iter_ondemand(self: Arc<Self>) -> Box<dyn Iterator<Item = (SharedString, AssetEntry)>> {
        use gpui_util::ResultExt;
        let paths = self.list("").unwrap_or_default();
        let iter = paths.into_iter().map(move |path| {
            // constructing OnDemand for loading assets from shared:Arc only when they are requested
            let entry = AssetEntry::from({
                let source = self.clone();
                let path = path.clone();
                move || source.load(path.as_str()).log_err().flatten()
            });
            (path, entry)
        });
        Box::new(iter)
    }
}

impl AssetSource for () {
    fn load(&self, _path: &str) -> Result<Option<Cow<'static, [u8]>>> {
        Ok(None)
    }

    fn list(&self, _path: &str) -> Result<Vec<SharedString>> {
        Ok(vec![])
    }
}

/// Loaded asset bytes that may be borrowed from static storage or owned.
pub type AssetData = Cow<'static, [u8]>;
/// A thread-safe callback that loads an asset on demand.
///
/// Returning `None` means that the asset is unavailable. The callback has no error channel and
/// may perform synchronous I/O, so use it only when missing data can be represented as `None` and
/// the caller can tolerate its latency.
pub type FnAssetLoader = Arc<dyn Fn() -> Option<AssetData> + 'static + Send + Sync>;
/// The storage policy for one [`AssetRegistry`] entry.
///
/// `PreLoaded` bytes are available immediately. `OnDemand` invokes its loader synchronously on
/// each call to [`AssetRegistry::load`]; the registry does not memoize the callback result.
pub enum AssetEntry {
    /// The bytes are already available, either borrowed from the binary or owned by the registry.
    PreLoaded(AssetData),
    /// Invoke the loader when the path is requested.
    OnDemand(FnAssetLoader),
}
impl From<AssetData> for AssetEntry {
    fn from(value: AssetData) -> Self {
        Self::PreLoaded(value)
    }
}
impl<F> From<F> for AssetEntry
where
    F: Fn() -> Option<AssetData> + 'static + Send + Sync,
{
    fn from(value: F) -> Self {
        Self::OnDemand(Arc::new(value))
    }
}

/// Returned when multiple assets are registered to the [`AssetRegistry`] with the same path.
///
/// The conflicting path is included in the formatted error; this type does not expose a separate
/// path accessor.
#[derive(thiserror::Error, Debug)]
#[error("An asset with the pathkey {0:?} already exists")]
pub struct DuplicateAssetPath(SharedString);

/// Collection of named byte assets used by GPUI services such as [`crate::SvgRenderer`].
///
/// Registry keys are opaque application-defined strings. `AssetRegistry` does not join path
/// components, canonicalize separators, or read the filesystem. Build it from an iterator or
/// insert entries explicitly; converting an [`AssetSource`] creates deferred entries from the
/// source's listed paths. A requested path not present in the registry returns `None`.
#[derive(Default)]
pub struct AssetRegistry {
    entries: BTreeMap<SharedString, AssetEntry>,
}

impl<T: AssetSource + 'static> From<T> for AssetRegistry {
    fn from(value: T) -> Self {
        let shared: Arc<dyn AssetSource> = Arc::new(value);
        Self::from(shared)
    }
}

/// Converts the provided [`AssetSource`] into a fresh [`AssetRegistry`] where all entries in
/// the asset source are loaded [OnDemand](AssetEntry::OnDemand) via [`AssetSource::iter_ondemand`].
impl From<Arc<dyn AssetSource>> for AssetRegistry {
    fn from(value: Arc<dyn AssetSource>) -> Self {
        let mut assets = Self::default();
        let _ = assets.extend(value.iter_ondemand());
        assets
    }
}

/// Builds a registry from path-entry pairs.
///
/// Duplicate path errors are logged and ignored during collection; the first inserted entry
/// remains in the registry. Use [`AssetRegistry::extend`] when the caller needs those errors.
impl<KeyType, ValueType> FromIterator<(KeyType, ValueType)> for AssetRegistry
where
    KeyType: AsRef<str>,
    ValueType: Into<AssetEntry>,
{
    fn from_iter<T: IntoIterator<Item = (KeyType, ValueType)>>(iter: T) -> Self {
        iter.into_iter()
            .fold(Self::default(), |mut assets, (key, value)| {
                assets.insert(key.as_ref(), value).log_err();
                assets
            })
    }
}

impl AssetRegistry {
    /// Inserts a single static, preloaded, or deferred byte entry.
    ///
    /// The path is stored exactly as supplied. A duplicate key returns
    /// [`DuplicateAssetPath`] and leaves the existing entry in place. On-demand callbacks run
    /// synchronously when [`Self::load`] is called.
    pub fn insert(
        &mut self,
        path: impl Into<SharedString>,
        asset: impl Into<AssetEntry>,
    ) -> Result<(), DuplicateAssetPath> {
        let path = path.into();
        if self.entries.contains_key(&path) {
            return Err(DuplicateAssetPath(path));
        }
        self.entries.insert(path, asset.into());
        Ok(())
    }

    /// Returns bytes for an exact path key, invoking an on-demand loader inline if necessary.
    ///
    /// `None` means the key is absent or its loader returned no asset. A loader that performs
    /// I/O can block the calling thread; do not call it from latency-sensitive rendering work.
    pub fn load<'this>(&'this self, path: impl AsRef<str>) -> Option<Cow<'this, [u8]>> {
        match self.entries.get(path.as_ref())? {
            AssetEntry::PreLoaded(Cow::Borrowed(data)) => Some(Cow::Borrowed(data)),
            AssetEntry::PreLoaded(Cow::Owned(data)) => Some(Cow::Borrowed(data.as_bytes())),
            AssetEntry::OnDemand(loader) => loader(),
        }
    }

    /// Inserts every path-entry pair, continuing after duplicate keys.
    ///
    /// The first entry for a key remains in place. Returns `Ok(())` when every
    /// insertion succeeds; otherwise logs and returns all duplicate-key
    /// errors. Successful insertions remain even when the method returns `Err`.
    pub fn extend<IterType, KeyType, EntryType>(
        &mut self,
        into_iter: IterType,
    ) -> Result<(), Vec<DuplicateAssetPath>>
    where
        IterType: IntoIterator<Item = (KeyType, EntryType)>,
        KeyType: AsRef<str>,
        EntryType: Into<AssetEntry>,
    {
        let mut result = Ok(());
        for (path_key, into_entry) in into_iter.into_iter() {
            if let Err(err) = self.insert(path_key.as_ref(), into_entry.into()) {
                gpui_util::log_err(&err);
                result = Err({
                    let mut errs: Vec<DuplicateAssetPath> = result.err().unwrap_or_default();
                    errs.push(err);
                    errs
                });
            }
        }
        result
    }

    /// Creates an iterator over paths and embedded asset bytes from a
    /// [`rust_embed::RustEmbed`] type.
    ///
    /// RustEmbed supplies file names separately from their bytes, so this method resolves each name
    /// with `T::get`. Names that no longer resolve are skipped. The iterator can be passed to
    /// [`Self::extend`].
    #[cfg(feature = "embedded-assets")]
    pub fn iter_embed<T: rust_embed::RustEmbed>()
    -> impl Iterator<Item = (Cow<'static, str>, AssetEntry)> + 'static {
        T::iter().filter_map(|path| {
            let file = T::get(path.as_ref())?;
            Some((path, AssetEntry::PreLoaded(file.data)))
        })
    }
}

/// A process-local identifier for a decoded image.
#[derive(Copy, Clone, Debug, Eq, PartialEq, Ord, PartialOrd, Hash)]
pub struct ImageId(pub usize);

/// Identifies one frame of one [`RenderImage`] in a sprite-atlas request.
///
/// Use the image's process-local [`ImageId`] and a zero-based frame index. This key is meaningful
/// only while that decoded image remains available in the process.
#[derive(PartialEq, Eq, Hash, Clone)]
pub struct RenderImageParams {
    /// The image to draw.
    pub image_id: ImageId,
    /// The zero-based animation frame to draw.
    pub frame_index: usize,
}

/// Decoded image frames in the renderer's BGRA byte order.
///
/// A value can contain multiple frames. Out-of-range frame queries return an empty/default value;
/// callers that need to distinguish a missing frame can compare `frame_index` with
/// [`Self::frame_count`]. The ID is process-local and identifies this decoded image for renderer
/// cache requests; it is not a persistent asset key. Frame dimensions are device pixels, while
/// display sizing additionally accounts for the image scale factor.
pub struct RenderImage {
    /// The ID associated with this image
    pub id: ImageId,
    /// The scale factor of this image on render.
    pub(crate) scale_factor: f32,
    data: SmallVec<[Frame; 1]>,
}

impl PartialEq for RenderImage {
    fn eq(&self, other: &Self) -> bool {
        self.id == other.id
    }
}

impl Eq for RenderImage {}

impl RenderImage {
    /// Create an image from already-decoded frames.
    ///
    /// This does not decode encoded file bytes. New images start with a scale factor of `1.0` and
    /// receive a process-local [`ImageId`]. An empty frame collection is allowed.
    pub fn new(data: impl Into<SmallVec<[Frame; 1]>>) -> Self {
        static NEXT_ID: AtomicUsize = AtomicUsize::new(0);

        Self {
            id: ImageId(NEXT_ID.fetch_add(1, SeqCst)),
            scale_factor: 1.0,
            data: data.into(),
        }
    }

    /// Return a frame's raw BGRA pixel bytes, if the frame exists.
    ///
    /// The slice borrows from this `RenderImage`; its validity is tied to `self`.
    pub fn as_bytes(&self, frame_index: usize) -> Option<&[u8]> {
        self.data
            .get(frame_index)
            .map(|frame| frame.buffer().as_raw().as_slice())
    }

    /// Return a frame's dimensions in device pixels, or a zero size if the frame is absent.
    pub fn size(&self, frame_index: usize) -> Size<DevicePixels> {
        self.data
            .get(frame_index)
            .map(|frame| {
                let (width, height) = frame.buffer().dimensions();
                size(width.into(), height.into())
            })
            .unwrap_or_default()
    }

    /// Get the size of this image, in pixels for display, adjusted for the scale factor.
    pub(crate) fn render_size(&self, frame_index: usize) -> Size<Pixels> {
        self.size(frame_index)
            .map(|v| (v.0 as f32 / self.scale_factor).into())
    }

    /// Return the duration for which a frame should be displayed.
    ///
    /// Missing frames use a 100 ms fallback. Existing frames keep the delay
    /// supplied by their decoder, including zero-duration delays.
    pub fn delay(&self, frame_index: usize) -> Delay {
        self.data
            .get(frame_index)
            .map(|frame| frame.delay())
            .unwrap_or(Delay::from_numer_denom_ms(100, 1))
    }

    /// Return the number of decoded frames. Compare an index with this count before relying on
    /// [`Self::size`] or [`Self::as_bytes`] to distinguish a missing frame from an empty result.
    pub fn frame_count(&self) -> usize {
        self.data.len()
    }
}

impl fmt::Debug for RenderImage {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("ImageData")
            .field("id", &self.id)
            .field("size", &self.data.first().map(|f| f.buffer().dimensions()))
            .finish()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use smallvec::SmallVec;

    #[test]
    fn empty_render_image_does_not_panic() {
        let image = RenderImage::new(SmallVec::new());
        assert_eq!(image.frame_count(), 0);
        assert_eq!(image.size(0), Size::default());
        assert_eq!(image.as_bytes(0), None);
        assert_eq!(image.render_size(0), Size::default());
        assert_eq!(image.delay(0), Delay::from_numer_denom_ms(100, 1));
        let _ = format!("{image:?}");
    }

    fn example_assets() -> Vec<(&'static str, AssetData)> {
        vec![
            ("asset0", Cow::Owned(vec![0u8])),
            ("asset1", Cow::Owned(vec![1u8])),
            ("asset2", Cow::Owned(vec![2u8])),
            ("asset3", Cow::Owned(vec![3u8])),
        ]
    }

    fn test_load_from(registry: &AssetRegistry) {
        for (key, value) in example_assets() {
            let loaded = registry.load(key).map(|cow| cow.to_vec());
            assert_eq!(loaded, Some(value.to_vec()));
        }
    }

    struct StubAssetSource;
    impl AssetSource for StubAssetSource {
        fn load(&self, path: &str) -> Result<Option<Cow<'static, [u8]>>> {
            for (key, data) in example_assets() {
                if key == path {
                    return Ok(Some(data));
                }
            }
            unimplemented!()
        }

        fn list(&self, _path: &str) -> Result<Vec<SharedString>> {
            Ok(example_assets()
                .into_iter()
                .map(|(key, _)| key.into())
                .collect())
        }
    }

    #[test]
    fn test_from_assetsource() {
        let assets = AssetRegistry::from(StubAssetSource);
        test_load_from(&assets);
    }

    #[test]
    fn test_from_arc_assetsource() {
        let arc: Arc<dyn AssetSource> = Arc::new(StubAssetSource);
        let assets = AssetRegistry::from(arc);
        test_load_from(&assets);
    }

    #[test]
    fn test_fromiter_assetdata() {
        let assets = AssetRegistry::from_iter(example_assets());
        test_load_from(&assets);
    }

    #[test]
    fn test_fromiter_assetentry() {
        let assets = AssetRegistry::from_iter(
            example_assets()
                .into_iter()
                .map(|(key, value)| (key, AssetEntry::from(value)))
                .chain(std::iter::once((
                    "asset6",
                    AssetEntry::OnDemand(Arc::new(|| Some(AssetData::Owned(vec![6u8])))),
                ))),
        );
        test_load_from(&assets);
        assert_eq!(
            assets.load("asset6").map(|cow| cow.to_vec()),
            Some(vec![6u8])
        );
    }

    #[test]
    fn test_insert() {
        let mut assets = AssetRegistry::default();
        for (key, value) in example_assets() {
            let result = assets.insert(key, value);
            assert!(result.is_ok());
        }
        test_load_from(&assets);
    }

    #[test]
    fn test_extend() {
        let mut assets = AssetRegistry::default();
        let result = assets.extend(
            example_assets()
                .into_iter()
                .map(|(key, value)| (key, AssetEntry::PreLoaded(value))),
        );
        assert!(result.is_ok());
        test_load_from(&assets);
    }

    #[test]
    fn test_extend_assetsource_preloaded() {
        let mut assets = AssetRegistry::default();
        let result = assets.extend(StubAssetSource.iter_preloaded());
        assert!(result.is_ok());
        test_load_from(&assets);
    }

    #[test]
    fn test_extend_assetsource_ondemand() {
        let mut assets = AssetRegistry::default();
        let result = assets.extend(Arc::new(StubAssetSource).iter_ondemand());
        assert!(result.is_ok());
        test_load_from(&assets);
    }
}
