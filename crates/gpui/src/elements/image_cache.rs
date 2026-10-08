use crate::{
    AnyElement, AnyEntity, App, AppContext, Asset, AssetLogger, Bounds, Element, ElementId, Entity,
    GlobalElementId, ImageAssetLoader, ImageCacheError, InspectorElementId, IntoElement, LayoutId,
    ParentElement, Pixels, RenderImage, Resource, Style, StyleRefinement, Styled, Task, Window,
    hash,
};

use futures::{FutureExt, future::Shared};
use refineable::Refineable;
use smallvec::SmallVec;
use std::{collections::HashMap, fmt, sync::Arc};

/// Build a subtree whose [`crate::img`] elements share one image-cache provider.
///
/// The provider may be an `Entity<T>` where `T: ImageCache`; loading can remain pending across
/// frames, while completed results are reused by descendants.
/// Use [`retain_all`] for a cache owned by a stable element ID, or retain an
/// [`Entity<RetainAllImageCache>`] yourself when several subtrees share it.
///
/// ```
/// use gpui::{image_cache, img, retain_all, ParentElement};
///
/// let gallery = image_cache(retain_all("gallery-images"))
///     .child(img("images/cover.png"))
///     .child(img("images/diagram.png"));
/// ```
///
/// This element supplies layout and cache scope. For a painted background,
/// clipping, or interaction, put it inside a [`crate::div`]. An individual
/// image's [`crate::Img::image_cache`] setting overrides this scope.
pub fn image_cache(image_cache_provider: impl ImageCacheProvider) -> ImageCacheElement {
    ImageCacheElement {
        image_cache_provider: Box::new(image_cache_provider),
        style: StyleRefinement::default(),
        children: SmallVec::default(),
    }
}

/// A shared, type-erased image-cache handle for generic element code.
///
/// Convert an [`Entity<T>`] where `T: ImageCache` with `.into()`. Cloning this
/// handle retains the same cache entity and its entries; it does not copy the
/// cached images. Keep the concrete entity too when the owner needs
/// provider-specific operations such as [`RetainAllImageCache::remove`].
#[derive(Clone)]
pub struct AnyImageCache {
    image_cache: AnyEntity,
    load_fn: fn(
        image_cache: &AnyEntity,
        resource: &Resource,
        window: &mut Window,
        cx: &mut App,
    ) -> Option<Result<Arc<RenderImage>, ImageCacheError>>,
}

impl<I: ImageCache> From<Entity<I>> for AnyImageCache {
    fn from(image_cache: Entity<I>) -> Self {
        Self {
            image_cache: image_cache.into_any(),
            load_fn: any_image_cache::load::<I>,
        }
    }
}

impl AnyImageCache {
    /// Poll the cache for `resource`.
    ///
    /// Returns `None` while loading is pending, or the provider's image or
    /// error result. Retention, retries, and completion notifications are the
    /// provider's responsibility, as described by [`ImageCache::load`].
    pub fn load(
        &self,
        resource: &Resource,
        window: &mut Window,
        cx: &mut App,
    ) -> Option<Result<Arc<RenderImage>, ImageCacheError>> {
        (self.load_fn)(&self.image_cache, resource, window, cx)
    }
}

mod any_image_cache {
    use super::*;

    pub(crate) fn load<I: 'static + ImageCache>(
        image_cache: &AnyEntity,
        resource: &Resource,
        window: &mut Window,
        cx: &mut App,
    ) -> Option<Result<Arc<RenderImage>, ImageCacheError>> {
        let image_cache = image_cache.clone().downcast::<I>().unwrap();
        image_cache.update(cx, |image_cache, cx| image_cache.load(resource, window, cx))
    }
}

/// A layout container that supplies an image cache to descendants.
///
/// Construct it with [`image_cache`]. Its [`Styled`] settings affect layout;
/// it does not paint its own background, border, or shadow.
pub struct ImageCacheElement {
    image_cache_provider: Box<dyn ImageCacheProvider>,
    style: StyleRefinement,
    children: SmallVec<[AnyElement; 2]>,
}

impl ParentElement for ImageCacheElement {
    fn extend(&mut self, elements: impl IntoIterator<Item = AnyElement>) {
        self.children.extend(elements)
    }
}

impl Styled for ImageCacheElement {
    fn style(&mut self) -> &mut StyleRefinement {
        &mut self.style
    }
}

impl IntoElement for ImageCacheElement {
    type Element = Self;

    fn into_element(self) -> Self::Element {
        self
    }
}

impl Element for ImageCacheElement {
    type RequestLayoutState = SmallVec<[LayoutId; 4]>;
    type PrepaintState = ();

    fn id(&self) -> Option<ElementId> {
        None
    }

    fn source_location(&self) -> Option<&'static core::panic::Location<'static>> {
        None
    }

    fn request_layout(
        &mut self,
        _id: Option<&GlobalElementId>,
        _inspector_id: Option<&InspectorElementId>,
        window: &mut Window,
        cx: &mut App,
    ) -> (LayoutId, Self::RequestLayoutState) {
        let image_cache = self.image_cache_provider.provide(window, cx);
        window.with_image_cache(Some(image_cache), |window| {
            let child_layout_ids = self
                .children
                .iter_mut()
                .map(|child| child.request_layout(window, cx))
                .collect::<SmallVec<_>>();
            let mut style = Style::default();
            style.refine(&self.style);
            let layout_id = window.request_layout(style, child_layout_ids.iter().copied(), cx);
            (layout_id, child_layout_ids)
        })
    }

    fn prepaint(
        &mut self,
        _id: Option<&GlobalElementId>,
        _inspector_id: Option<&InspectorElementId>,
        _bounds: Bounds<Pixels>,
        _request_layout: &mut Self::RequestLayoutState,
        window: &mut Window,
        cx: &mut App,
    ) -> Self::PrepaintState {
        for child in &mut self.children {
            child.prepaint(window, cx);
        }
    }

    fn paint(
        &mut self,
        _id: Option<&GlobalElementId>,
        _inspector_id: Option<&InspectorElementId>,
        _bounds: Bounds<Pixels>,
        _request_layout: &mut Self::RequestLayoutState,
        _prepaint: &mut Self::PrepaintState,
        window: &mut Window,
        cx: &mut App,
    ) {
        let image_cache = self.image_cache_provider.provide(window, cx);
        window.with_image_cache(Some(image_cache), |window| {
            for child in &mut self.children {
                child.paint(window, cx);
            }
        })
    }
}

/// A shared loading task whose clones deliver the same image or error result.
///
/// Holding a clone keeps the underlying task alive. Polling can complete it,
/// but does not by itself notify a view.
pub type ImageLoadingTask = Shared<Task<Result<Arc<RenderImage>, ImageCacheError>>>;

/// A pending or completed image-cache entry, including cached failures.
pub enum ImageCacheItem {
    /// A request that has not yet been observed as complete by [`Self::get`].
    Loading(ImageLoadingTask),
    /// A completed request, containing either the decoded image or its failure.
    Loaded(Result<Arc<RenderImage>, ImageCacheError>),
}

impl std::fmt::Debug for ImageCacheItem {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let status = match self {
            ImageCacheItem::Loading(_) => &"Loading...".to_string(),
            ImageCacheItem::Loaded(render_image) => &format!("{:?}", render_image),
        };
        f.debug_struct("ImageCacheItem")
            .field("status", status)
            .finish()
    }
}

impl ImageCacheItem {
    /// Polls once and returns the completed result, if available.
    ///
    /// A completed task replaces `Loading` with `Loaded`, including on error.
    /// Later calls clone that result. This does not block or schedule a redraw.
    pub fn get(&mut self) -> Option<Result<Arc<RenderImage>, ImageCacheError>> {
        match self {
            ImageCacheItem::Loading(task) => {
                let res = task.now_or_never()?;
                *self = ImageCacheItem::Loaded(res.clone());
                Some(res)
            }
            ImageCacheItem::Loaded(res) => Some(res.clone()),
        }
    }
}

/// Loads and retains renderer images for resource-backed [`crate::img`] elements.
///
/// Return `None` while a request is pending and `Some(result)` after it has completed. A cache
/// implementation owns the policy for sharing requests, retaining results, and releasing renderer
/// resources. When an image is no longer needed, [`App::drop_image`] removes
/// its sprite-atlas uploads from all windows; dropping the `Arc` alone does
/// not explicitly evict those uploads.
pub trait ImageCache: 'static {
    /// Polls or starts loading `resource` and returns a completed result, if available.
    ///
    /// Return `None` while pending. Arrange a notification for the view that
    /// needs the result; `Img` does not poll continuously just because this
    /// method returned `None`. An implementation may cache errors or retry
    /// them, but should document that policy. Avoid blocking I/O here: this
    /// method is called during layout and paint.
    fn load(
        &mut self,
        resource: &Resource,
        window: &mut Window,
        cx: &mut App,
    ) -> Option<Result<Arc<RenderImage>, ImageCacheError>>;
}

/// Supplies the cache used by a subtree of image elements.
///
/// GPUI asks for a cache during both layout and paint, then installs it for
/// descendants during that phase. Return the same cache on both calls when
/// those phases should share requests and results. An [`Entity<T>`] provider
/// reuses its entity; [`retain_all`] retains one by element identity.
pub trait ImageCacheProvider: 'static {
    /// Return the cache for the current subtree.
    fn provide(&mut self, _window: &mut Window, _cx: &mut App) -> AnyImageCache;
}

impl<T: ImageCache> ImageCacheProvider for Entity<T> {
    fn provide(&mut self, _window: &mut Window, _cx: &mut App) -> AnyImageCache {
        self.clone().into()
    }
}

/// An image cache that keeps each requested resource until it is removed, cleared, or released.
///
/// This cache does not evict entries automatically. Use [`clear`](Self::clear) or [`remove`](Self::remove)
/// when the retained resources should be released earlier than the cache entity's lifetime.
/// Requests are keyed by the resource's hash, and failures remain cached too.
/// Choose [`retain_all`] for a cache retained by element identity or
/// [`Self::new`] for a cache entity explicitly owned by the view.
pub struct RetainAllImageCache(HashMap<u64, ImageCacheItem>);

impl fmt::Debug for RetainAllImageCache {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("HashMapImageCache")
            .field("num_images", &self.0.len())
            .finish()
    }
}

impl RetainAllImageCache {
    /// Create an entity-backed cache and release its renderer images when the entity is dropped.
    #[inline]
    pub fn new(cx: &mut App) -> Entity<Self> {
        let e = cx.new(|_cx| RetainAllImageCache(HashMap::new()));
        cx.observe_release(&e, |image_cache, cx| {
            for (_, mut item) in std::mem::replace(&mut image_cache.0, HashMap::new()) {
                if let Some(Ok(image)) = item.get() {
                    cx.drop_image(image, None);
                }
            }
        })
        .detach();
        e
    }

    /// Load a resource once and reuse its pending task or completed result on later calls.
    ///
    /// Returns `None` while the task is pending and caches both images and
    /// failures. The first request records the current view; completion
    /// notifies that view on the window's next frame. Later callers reuse the
    /// entry without registering additional completion notifications. When
    /// independently rendered views share this cache, arrange notifications
    /// for those consumers too.
    pub fn load(
        &mut self,
        source: &Resource,
        window: &mut Window,
        cx: &mut App,
    ) -> Option<Result<Arc<RenderImage>, ImageCacheError>> {
        let hash = hash(source);

        if let Some(item) = self.0.get_mut(&hash) {
            return item.get();
        }

        let fut = AssetLogger::<ImageAssetLoader>::load(source.clone(), cx);
        let task = cx.background_executor().spawn(fut).shared();
        self.0.insert(hash, ImageCacheItem::Loading(task.clone()));

        let entity = window.current_view();
        window
            .spawn(cx, {
                async move |cx| {
                    _ = task.await;
                    cx.on_next_frame(move |_, cx| {
                        cx.notify(entity);
                    });
                }
            })
            .detach();

        None
    }

    /// Removes every pending or completed entry.
    ///
    /// Completed images are also removed from all windows' sprite atlases.
    /// Pass the currently borrowed window so it is included. Detached load
    /// waiters can still finish after removal; this is not a cancellation API.
    /// Notify the owning view separately to redraw or request the images again.
    pub fn clear(&mut self, window: &mut Window, cx: &mut App) {
        for (_, mut item) in std::mem::replace(&mut self.0, HashMap::new()) {
            if let Some(Ok(image)) = item.get() {
                cx.drop_image(image, Some(window));
            }
        }
    }

    /// Removes one entry, allowing the next request to load it again.
    ///
    /// A completed image is also removed from all windows' sprite atlases,
    /// including `window`. Removing a pending entry does not cancel its
    /// detached completion waiter. Notify the view separately to retry a
    /// failed image or update the display.
    pub fn remove(&mut self, source: &Resource, window: &mut Window, cx: &mut App) {
        let hash = hash(source);
        if let Some(mut item) = self.0.remove(&hash)
            && let Some(Ok(image)) = item.get()
        {
            cx.drop_image(image, Some(window));
        }
    }

    /// Counts pending loads and completed entries, including failures.
    pub fn len(&self) -> usize {
        self.0.len()
    }

    /// Returns true if the cache is empty.
    pub fn is_empty(&self) -> bool {
        self.0.is_empty()
    }
}

impl ImageCache for RetainAllImageCache {
    fn load(
        &mut self,
        resource: &Resource,
        window: &mut Window,
        cx: &mut App,
    ) -> Option<Result<Arc<RenderImage>, ImageCacheError>> {
        RetainAllImageCache::load(self, resource, window, cx)
    }
}

/// Supplies a retain-all cache stored under a stable element ID.
///
/// Pass the provider to [`image_cache`]. Reuse `id` on subsequent renders to
/// retain the cache; changing the ID creates another cache. The ID is scoped
/// by the current element path, so give sibling cache scopes distinct IDs.
/// Entries live until explicitly removed or the retained cache entity is
/// released. Use a cache entity directly for sharing across independent scopes.
pub fn retain_all(id: impl Into<ElementId>) -> RetainAllImageCacheProvider {
    RetainAllImageCacheProvider { id: id.into() }
}

/// An element-state provider created by [`retain_all`].
pub struct RetainAllImageCacheProvider {
    id: ElementId,
}

impl ImageCacheProvider for RetainAllImageCacheProvider {
    fn provide(&mut self, window: &mut Window, cx: &mut App) -> AnyImageCache {
        window
            .with_global_id(self.id.clone(), |global_id, window| {
                window.with_element_state::<Entity<RetainAllImageCache>, _>(
                    global_id,
                    |cache, _window| {
                        let mut cache = cache.unwrap_or_else(|| RetainAllImageCache::new(cx));
                        (cache.clone(), cache)
                    },
                )
            })
            .into()
    }
}
