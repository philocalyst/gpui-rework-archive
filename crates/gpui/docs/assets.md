# Load assets without blocking a frame

A bundled icon, a remote photograph, and a video frame need different loading
paths. Start with what the application already owns: a name, encoded bytes,
decoded pixels, or a GPU handle. Then choose where to keep the result and who
will request a redraw when it arrives.

## Register bundled bytes

[`AssetRegistry`](crate::AssetRegistry) maps application-defined names to bytes.
Register a small, fixed resource directly:

```rust
use gpui::AssetRegistry;
use std::borrow::Cow;

let icon = br#"<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16">
    <path d="M3 8 L7 12 L13 4" fill="none" stroke="black"/>
</svg>"#;
let mut assets = AssetRegistry::default();
assets.insert("icons/check.svg", Cow::Borrowed(icon.as_slice()))?;

assert_eq!(assets.load("icons/check.svg").as_deref(), Some(icon.as_slice()));
assert!(assets.load("./icons/check.svg").is_none());
# Ok::<(), gpui::DuplicateAssetPath>(())
```

Pass the registry to [`Application::with_assets`](crate::Application::with_assets)
before starting the app. An [`svg`](crate::svg) with the path
`icons/check.svg` can then find those bytes. The registry neither reads files
nor normalizes names: `icons/check.svg` and `./icons/check.svg` are distinct
keys. A duplicate insertion returns an error and preserves the first entry.

Registering font bytes here does not install a font face in the text system.
Load those bytes and call [`TextSystem::add_fonts`](crate::TextSystem::add_fonts)
before measuring text. The [text chapter](crate::_documentation::text) follows
font selection through shaping and painting.

For a collection with its own discovery and loading rules, implement
[`AssetSource`](crate::AssetSource). Its `list` method supplies registry keys;
its `load` method must accept those same keys. Converting a source into a
registry creates deferred entries. With the `embedded-assets` feature,
the registry's `iter_embed` method adapts a `rust_embed::RustEmbed` collection
instead.

> [!WARNING]
> Deferred registry loading is synchronous. An
> [`AssetEntry::OnDemand`](crate::AssetEntry::OnDemand) callback runs inside
> each `AssetRegistry::load` call, and its result is not memoized there.
> Preload bytes needed during a frame, or use the asynchronous resource path
> below. “On demand” does not mean “on a background thread.”

## Choose an image source

[`img`](crate::img) accepts several inputs. Their types decide what work
remains:

| Input | Meaning | Work before painting |
| --- | --- | --- |
| `"images/cover.png"` | A key in the app's registry | Load the bytes and decode them |
| `PathBuf::from("images/cover.png")` | A filesystem path | Read the file and decode it |
| A URL string | A remote resource | Fetch through the app's HTTP client and decode |
| `Arc<Image>` | Encoded bytes with an explicit format | Decode the bytes |
| `Arc<RenderImage>` | Decoded BGRA frames | Upload pixels as needed by the renderer |
| A custom loading closure | A caller-owned result | Poll the closure; the caller supplies completion notification |

Strings that parse as URLs select the URI path; other strings select embedded
registry keys. Use a `Path` or `PathBuf` explicitly for a file. Creating an
[`Image`](crate::Image) stores encoded bytes; it does **not** decode them.
[`RenderImage`](crate::RenderImage) holds decoded frames. The
[`ImageSource`](crate::ImageSource) reference describes each conversion.

Remote resources need a client installed with
[`Application::with_http_client`](crate::Application::with_http_client).
The default client rejects requests. GPUI's small
[`HttpClient`](crate::http_client::HttpClient) interface returns a complete
response body; the concrete transport must supply the application's timeout,
redirect, and response-size policy.

Pixels already in a video buffer or GPU render target belong on a
[`surface`](crate::surface). Read
[GPU compositing](crate::_documentation::drawing#composite-an-image-already-owned-by-the-gpu)
before choosing a backend-specific source. A surface has different device,
format, lifetime, and capture constraints from a decoded image.

## Tint an SVG icon

[`svg`](crate::svg) paints a single-color alpha mask. Give it a layout size
and a tint through `text_color`; the SVG's original RGB colors are discarded.
The icon registered above can be displayed with:

```rust
use gpui::{prelude::*, px, rgb, svg};

let check = svg()
    .path("icons/check.svg")
    .size(px(16.))
    .text_color(rgb(0x155b50));
```

[`Svg::path`](crate::Svg::path) selects a registry key, even when the string looks like a file path
or URL. [`Svg::external_path`](crate::Svg::external_path) reads a native file on
the background executor; [`Svg::data`](crate::Svg::data) copies bytes already
in memory. Parsing and rasterization happen during an uncached paint in all
three cases. The element has no loading or error replacement. Use `img` for
asynchronous decoding, failure UI, or a multicolor SVG illustration.

The SVG's own dimensions do not size the element. Its assigned width sets the
raster scale, preserving aspect ratio, and the raster is centered in its box.
Use an enclosing content mask if a tall icon must stop at that box's edge.
[`Svg::with_transformation`](crate::Svg::with_transformation) can rotate or
translate the painting while leaving layout and its hitbox in place. SVG text
uses [`SvgRenderer`](crate::SvgRenderer)'s font database, separately from fonts
registered with the ordinary text system.

## Reserve space and show failure

A resource-backed image can be pending when its element is laid out. Give it
dimensions when the surrounding layout should remain stable:

```rust
use gpui::{img, div, prelude::*, px};

fn cover() -> impl IntoElement {
    img("images/cover.png")
        .id("cover")
        .w(px(240.))
        .h(px(160.))
        .with_loading(|| div().child("Loading cover…").into_any_element())
        .with_fallback(|| div().child("Cover unavailable").into_any_element())
}
```

The stable ID retains the loading timer between frames. Without an ID, the
loading replacement is not shown. With one, it appears only after 200 ms, so
quick loads do not flash a placeholder. The fallback appears when loading or
decoding returns an error. Neither replacement retries the load by itself.

The default fit is [`ObjectFit::Contain`](crate::ObjectFit::Contain), which
shows the whole image and leaves unused space when the aspect ratios differ.
`Cover` fills the box and crops the image at its edges. Both preserve the
source's aspect ratio. Animated resources need a stable ID too; they advance
while their window is active and reduced motion is off.

## Give the cache an owner

Without an image-cache provider, resource-backed images use the app's typed
asset cache. That cache lasts until its entries are explicitly removed or the
app is released. Use an image-cache provider when the images should follow a
smaller subtree's lifetime:

```rust
use gpui::{image_cache, img, retain_all, prelude::*};

let gallery = image_cache(retain_all("gallery-images"))
    .flex()
    .gap_2()
    .child(img("images/cover.png"))
    .child(img("images/diagram.png"));
```

[`retain_all`](crate::retain_all) retains a
[`RetainAllImageCache`](crate::RetainAllImageCache) entity under that element
identity. Keep the ID and its containing element path stable to reuse pending
loads and completed results across renders. Give sibling cache scopes distinct
IDs. Retain a cache entity on the view instead when independent subtrees must
share it, and pass clones to their [`image_cache`](crate::image_cache)
containers or individual [`Img::image_cache`](crate::Img::image_cache) settings.

The retain-all provider uses its own cache rather than the app's typed asset
cache. Both keep failed results as well as successful ones. Neither keeps
retrying a failed request. For a retry, remove the entry from the cache that
actually owns it, then notify the view:

| Owner | Remove one request |
| --- | --- |
| App's image-resource cache | [`ImageSource::remove_asset`](crate::ImageSource::remove_asset) |
| A `RetainAllImageCache` entity | [`RetainAllImageCache::remove`](crate::RetainAllImageCache::remove) |
| A custom image loader | Update the caller's state according to its retry policy |

Removing an app-cache entry does not clear a provider's entry. Removing a
provider entry also drops that completed image's renderer uploads; clearing
the provider does the same for all its entries. When the cache entity is
released, its release observer drops its completed images from the renderers.
An outstanding load waiter can still finish after removal, so cache eviction
is not a cancellation guarantee.

> [!NOTE]
> The image element and built-in provider arrange completion notification for
> the view that creates their pending cache entry. Other independently rendered
> views sharing it need an explicit invalidation path. Prefetching through
> `App::fetch_asset` also creates an entry, but arranges no view notification;
> a later `Window::use_asset` call does not add one to an existing request.

## Load a typed resource

[`Asset`](crate::Asset) handles asynchronous resources beyond images. Its
source is a cloneable, hashable key; its output is a cloneable result. Capture
the needed app services in `load`, then return an owned, `Send` future.
[`App::fetch_asset`](crate::App::fetch_asset) schedules that future on the
background executor and shares it by asset type and source hash. A request
for the same typed key reuses the task, including its completed error, until
[`App::remove_asset`](crate::App::remove_asset) evicts it.

The asset type is part of that key. An `img` using the app cache requests
[`ImgResourceLoader`](crate::ImgResourceLoader), an
[`AssetLogger`](crate::AssetLogger) wrapper around `ImageAssetLoader`.
Prefetch with that alias when the image should reuse the app request.
Loading `ImageAssetLoader` directly creates a separate entry; passing the
resulting `Arc<RenderImage>` to `img` reuses the pixels instead. Neither app
request populates an image-cache provider's separate storage.

During rendering, [`Window::use_asset`](crate::Window::use_asset) returns
`None` while pending and the output when ready. It arranges completion
notification for the request that creates the cache entry. Outside rendering,
await the shared task returned by `fetch_asset`, update the owner, and notify
the view. The [scheduling chapter](crate::_documentation::scheduling) explains
how to retain that task and reject results that arrive after a newer request.

The repository's `image_loading` example implements an asset whose key chooses
a delay and a deliberate failure:

```sh
cargo run --example image_loading
```

Its three samples expose the ready, pending, and failed states. Click a sample
to remove its typed cache entry and load it again. Read
[`Asset::load`](crate::Asset::load),
[`StyledImage::with_loading`](crate::StyledImage::with_loading), and
[`StyledImage::with_fallback`](crate::StyledImage::with_fallback) alongside it.
When an image is missing, check the source choice, byte loading, decoding,
cache owner, and completion notification in that order. Each is a different
place for the request to stop.
