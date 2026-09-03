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

/// An image cache element, all its child img elements will use the cache specified by this element.
/// Note that this could as simple as passing an `Entity<T: ImageCache>`
pub fn image_cache(image_cache_provider: impl ImageCacheProvider) -> ImageCacheElement {
    ImageCacheElement {
        image_cache_provider: Box::new(image_cache_provider),
        style: StyleRefinement::default(),
        children: SmallVec::default(),
    }
}

/// A dynamically typed image cache, which can be used to store any image cache
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
    /// Load an image given a resource
    /// returns the result of loading the image if it has finished loading, or None if it is still loading
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

/// An image cache element.
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

/// An image loading task associated with an image cache.
pub type ImageLoadingTask = Shared<Task<Result<Arc<RenderImage>, ImageCacheError>>>;

/// An image cache item
pub enum ImageCacheItem {
    /// The associated image is currently loading
    Loading(ImageLoadingTask),
    /// This item has loaded an image.
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
    /// Attempt to get the image from the cache item.
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

/// An object that can handle the caching and unloading of images.
/// Implementations of this trait should ensure that images are removed from all windows when they are no longer needed.
pub trait ImageCache: 'static {
    /// Load an image given a resource
    /// returns the result of loading the image if it has finished loading, or None if it is still loading
    fn load(
        &mut self,
        resource: &Resource,
        window: &mut Window,
        cx: &mut App,
    ) -> Option<Result<Arc<RenderImage>, ImageCacheError>>;
}

/// An object that can create an ImageCache during the render phase.
/// See the ImageCache trait for more information.
pub trait ImageCacheProvider: 'static {
    /// Called during the request_layout phase to create an ImageCache.
    fn provide(&mut self, _window: &mut Window, _cx: &mut App) -> AnyImageCache;
}

impl<T: ImageCache> ImageCacheProvider for Entity<T> {
    fn provide(&mut self, _window: &mut Window, _cx: &mut App) -> AnyImageCache {
        self.clone().into()
    }
}

/// An implementation of ImageCache, that uses an LRU caching strategy to unload images when the cache is full
pub struct RetainAllImageCache(HashMap<u64, ImageCacheItem>);

impl fmt::Debug for RetainAllImageCache {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("HashMapImageCache")
            .field("num_images", &self.0.len())
            .finish()
    }
}

impl RetainAllImageCache {
    /// Create a new image cache.
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

    /// Load an image from the given source.
    ///
    /// Returns `None` if the image is loading.
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

    /// Clear the image cache.
    pub fn clear(&mut self, window: &mut Window, cx: &mut App) {
        for (_, mut item) in std::mem::replace(&mut self.0, HashMap::new()) {
            if let Some(Ok(image)) = item.get() {
                cx.drop_image(image, Some(window));
            }
        }
    }

    /// Remove the image from the cache by the given source.
    pub fn remove(&mut self, source: &Resource, window: &mut Window, cx: &mut App) {
        let hash = hash(source);
        if let Some(mut item) = self.0.remove(&hash)
            && let Some(Ok(image)) = item.get()
        {
            cx.drop_image(image, Some(window));
        }
    }

    /// Returns the number of images in the cache.
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

/// Constructs a retain-all image cache that uses the element state associated with the given ID.
pub fn retain_all(id: impl Into<ElementId>) -> RetainAllImageCacheProvider {
    RetainAllImageCacheProvider { id: id.into() }
}

/// A provider struct for creating a retain-all image cache inline
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

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{AnyWindowHandle, Context, ImageSource, Render, TestAppContext, Window, img};
    use image::{Frame, ImageBuffer, Rgba};
    use smallvec::SmallVec;
    use std::{cell::RefCell, collections::HashMap, rc::Rc};

    /// A cache that memoizes one synthetic image per resource, counting how many
    /// times a resource actually needs a fresh load (i.e. was not already cached).
    struct CountingImageCache {
        source_loads: Rc<RefCell<HashMap<String, usize>>>,
        images: HashMap<String, Arc<RenderImage>>,
    }

    impl CountingImageCache {
        fn key(resource: &Resource) -> String {
            match resource {
                Resource::Embedded(path) => path.to_string(),
                Resource::Path(path) => path.display().to_string(),
                Resource::Uri(uri) => uri.to_string(),
            }
        }

        fn image_for(key: &str) -> Arc<RenderImage> {
            let (width, height) = if key.contains("wide") {
                (20, 10)
            } else {
                (10, 10)
            };
            let frame = Frame::new(ImageBuffer::from_pixel(width, height, Rgba([0, 0, 0, 0])));
            Arc::new(RenderImage::new(SmallVec::from_elem(frame, 1)))
        }
    }

    impl ImageCache for CountingImageCache {
        fn load(
            &mut self,
            resource: &Resource,
            _window: &mut Window,
            _cx: &mut App,
        ) -> Option<Result<Arc<RenderImage>, ImageCacheError>> {
            let key = Self::key(resource);
            if !self.images.contains_key(&key) {
                *self
                    .source_loads
                    .borrow_mut()
                    .entry(key.clone())
                    .or_default() += 1;
                self.images.insert(key.clone(), Self::image_for(&key));
            }
            Some(Ok(self.images[&key].clone()))
        }
    }

    struct ImageCacheTestView {
        cache: Entity<CountingImageCache>,
        resource: Rc<RefCell<Resource>>,
    }

    impl Render for ImageCacheTestView {
        fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
            image_cache(self.cache.clone())
                .child(img(ImageSource::Resource(self.resource.borrow().clone())))
        }
    }

    fn sprite_width(window: AnyWindowHandle, cx: &mut TestAppContext) -> f32 {
        let scale_factor = cx
            .update_window(window, |_, window, _| window.scale_factor())
            .unwrap();
        cx.update_window(window, |_, window, _| {
            window
                .rendered_frame
                .scene
                .polychrome_sprites
                .last()
                .map(|sprite| sprite.bounds.size.width.0)
                .unwrap_or_default()
        })
        .unwrap()
            / scale_factor
    }

    #[gpui::test]
    fn same_input_is_cached_and_changed_input_repaints(cx: &mut TestAppContext) {
        let source_loads = Rc::new(RefCell::new(HashMap::new()));
        let resource = Rc::new(RefCell::new(Resource::Embedded("small".into())));
        let window = cx.add_window({
            let source_loads = source_loads.clone();
            let resource = resource.clone();
            move |_, cx| ImageCacheTestView {
                cache: cx.new(|_| CountingImageCache {
                    source_loads,
                    images: HashMap::new(),
                }),
                resource,
            }
        });
        let window: AnyWindowHandle = window.into();

        // Frame 1: the resource is loaded and painted.
        cx.update_window(window, |_, window, cx| {
            window.draw(cx).clear(cx);
        })
        .unwrap();
        assert_eq!(source_loads.borrow()["small"], 1, "first draw loads once");
        assert_eq!(sprite_width(window, cx), 10.0);

        // Frame 2: unchanged input hits the cache, no repaint of the source.
        cx.update_window(window, |_, window, cx| {
            window.draw(cx).clear(cx);
        })
        .unwrap();
        assert_eq!(
            source_loads.borrow()["small"],
            1,
            "unchanged input must not reload"
        );
        assert_eq!(sprite_width(window, cx), 10.0);

        // Frame 3: a changed input forces a fresh load and a different render.
        *resource.borrow_mut() = Resource::Embedded("wide".into());
        cx.update_window(window, |_, window, cx| {
            window.draw(cx).clear(cx);
        })
        .unwrap();
        assert_eq!(
            source_loads.borrow()["wide"],
            1,
            "changed input loads again"
        );
        assert_eq!(sprite_width(window, cx), 20.0, "repaint reflects new size");

        // Frame 4: returning to the original input is still served from the cache.
        *resource.borrow_mut() = Resource::Embedded("small".into());
        cx.update_window(window, |_, window, cx| {
            window.draw(cx).clear(cx);
        })
        .unwrap();
        assert_eq!(
            source_loads.borrow()["small"],
            1,
            "re-visiting an input must reuse the cached result"
        );
        assert_eq!(sprite_width(window, cx), 10.0);
    }
}
