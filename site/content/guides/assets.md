+++
aliases = ["elements/media.html", "guide/elements/media/", "guide/system/assets-http/", "system/assets-http.html"]
title = "Load assets and images"
description = "Choose a source, reserve space, and give loads and retries a cache owner."
weight = 70
+++

<!-- Mirrored from crates/gpui/docs/assets.md; edit that source. -->

A bundled icon, a remote photograph, and a video frame need different loading
paths. Start with what the application already owns: a name, encoded bytes,
decoded pixels, or a GPU handle. Then choose where to keep the result and who
will request a redraw when it arrives.

## Register bundled bytes

[`AssetRegistry`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.AssetRegistry.html) maps application-defined names to bytes.
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

Pass the registry to [`Application::with_assets`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Application.html#method.with_assets)
before starting the app. An [`svg`](https://docs.rs/gpui-ce/0.2.2/gpui/fn.svg.html) with the path
`icons/check.svg` can then find those bytes. The registry neither reads files
nor normalizes names: `icons/check.svg` and `./icons/check.svg` are distinct
keys. A duplicate insertion returns an error and preserves the first entry.

Registering font bytes here does not install a font face in the text system.
Load those bytes and call [`TextSystem::add_fonts`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.TextSystem.html#method.add_fonts)
before measuring text. The [text chapter](https://gpui-ce.github.io/book/text.html) follows
font selection through shaping and painting.

For a collection with its own discovery and loading rules, implement
[`AssetSource`](https://docs.rs/gpui-ce/0.2.2/gpui/trait.AssetSource.html). Its `list` method supplies registry keys;
its `load` method must accept those same keys. Converting a source into a
registry creates deferred entries. With the `embedded-assets` feature,
the registry's `iter_embed` method adapts a `rust_embed::RustEmbed` collection
instead.

> [!WARNING]
> Deferred registry loading is synchronous. An
> [`AssetEntry::OnDemand`](https://docs.rs/gpui-ce/0.2.2/gpui/enum.AssetEntry.html#variant.OnDemand) callback runs inside
> each `AssetRegistry::load` call, and its result is not memoized there.
> Preload bytes needed during a frame, or use the asynchronous resource path
> below. “On demand” does not mean “on a background thread.”

## Choose an image source

[`img`](https://docs.rs/gpui-ce/0.2.2/gpui/fn.img.html) accepts several inputs. Their types decide what work
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
[`Image`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Image.html) stores encoded bytes; it does **not** decode them.
[`RenderImage`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.RenderImage.html) holds decoded frames. The
[`ImageSource`](https://docs.rs/gpui-ce/0.2.2/gpui/enum.ImageSource.html) reference describes each conversion.

Remote resources use the app's installed
[`HttpClient`](https://docs.rs/gpui-ce/0.2.2/gpui/http_client/trait.HttpClient.html). On WebAssembly,
[`gpui_platform::application()`](https://gpui-ce.github.io/book/platforms.html#browser-startup)
installs the browser's Fetch adapter. Remote
servers must permit cross-origin access through
[CORS](https://fetch.spec.whatwg.org/#http-cors-protocol) when the resource's
origin differs from the page's. Native applications start with a client
that rejects requests: install a transport with
[`Application::with_http_client`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Application.html#method.with_http_client).
Core [`Application::with_platform`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Application.html#method.with_platform) and
`gpui_platform::headless()` also leave
that rejecting default in place.

The interface returns a complete body. The image loader rejects non-success
HTTP statuses before decoding; other consumers must check the status
themselves. Timeouts, redirects, and byte limits belong to the transport.
Changing the client with [`App::set_http_client`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.App.html#method.set_http_client)
does not restart existing requests or evict cached results. Use the
[retry procedure below](#retry-a-cached-failure) when a load must run again.

Pixels already in a video buffer or GPU render target belong on a
[`surface`](https://docs.rs/gpui-ce/0.2.2/gpui/fn.surface.html). Read
[GPU compositing](https://gpui-ce.github.io/book/drawing.html#composite-an-image-already-owned-by-the-gpu)
before choosing a backend-specific source. A surface has different device,
format, lifetime, and capture constraints from a decoded image.

## Tint an SVG icon

[`svg`](https://docs.rs/gpui-ce/0.2.2/gpui/fn.svg.html) paints a single-color alpha mask. Give it a layout size
and a tint through `text_color`; the SVG's original RGB colors are discarded.
The icon registered above can be displayed with:

```rust
use gpui::{prelude::*, px, rgb, svg};

let check = svg()
    .path("icons/check.svg")
    .size(px(16.))
    .text_color(rgb(0x155b50));
```

[`Svg::path`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Svg.html#method.path) selects a registry key, even when the string looks like a file path
or URL. [`Svg::external_path`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Svg.html#method.external_path) reads a native file on
the background executor; [`Svg::data`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Svg.html#method.data) copies bytes already
in memory. Parsing and rasterization happen during an uncached paint in all
three cases. The element has no loading or error replacement. Use `img` for
asynchronous decoding, failure UI, or a multicolor SVG illustration.

The SVG's own dimensions do not size the element. Its assigned width sets the
raster scale, preserving aspect ratio, and the raster is centered in its box.
Use an enclosing content mask if a tall icon must stop at that box's edge.
[`Svg::with_transformation`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Svg.html#method.with_transformation) can rotate or
translate the painting while leaving layout and its hitbox in place. SVG text
uses [`SvgRenderer`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.SvgRenderer.html)'s font database, separately from fonts
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

The default fit is [`ObjectFit::Contain`](https://docs.rs/gpui-ce/0.2.2/gpui/enum.ObjectFit.html#variant.Contain), which
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

[`retain_all`](https://docs.rs/gpui-ce/0.2.2/gpui/fn.retain_all.html) retains a
[`RetainAllImageCache`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.RetainAllImageCache.html) entity under that element
identity. Keep the ID and its containing element path stable to reuse pending
loads and completed results across renders. Give sibling cache scopes distinct
IDs. Retain a cache entity on the view instead when independent subtrees must
share it, and pass clones to their [`image_cache`](https://docs.rs/gpui-ce/0.2.2/gpui/fn.image_cache.html)
containers or individual [`Img::image_cache`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Img.html#method.image_cache) settings.

### Retry a cached failure

The retain-all provider uses its own cache rather than the app's typed asset
cache. Both keep failed results as well as successful ones. Neither keeps
retrying a failed request. For a retry, remove the entry from the cache that
actually owns it, then notify the view:

| Owner | Remove one request |
| --- | --- |
| App's image-resource cache | [`ImageSource::remove_asset`](https://docs.rs/gpui-ce/0.2.2/gpui/enum.ImageSource.html#method.remove_asset) |
| A `RetainAllImageCache` entity | [`RetainAllImageCache::remove`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.RetainAllImageCache.html#method.remove) |
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

[`Asset`](https://docs.rs/gpui-ce/0.2.2/gpui/trait.Asset.html) handles asynchronous resources beyond images. Its
source is a cloneable, hashable key; its output is a cloneable result. Capture
the needed app services in `load`, then return an owned, `Send` future.
[`App::fetch_asset`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.App.html#method.fetch_asset) schedules that future on the
background executor and shares it by asset type and source hash. A request
for the same typed key reuses the task, including its completed error, until
[`App::remove_asset`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.App.html#method.remove_asset) evicts it.

The asset type is part of that key. An `img` using the app cache requests
[`ImgResourceLoader`](https://docs.rs/gpui-ce/0.2.2/gpui/type.ImgResourceLoader.html), an
[`AssetLogger`](https://docs.rs/gpui-ce/0.2.2/gpui/enum.AssetLogger.html) wrapper around `ImageAssetLoader`.
Prefetch with that alias when the image should reuse the app request.
Loading `ImageAssetLoader` directly creates a separate entry; passing the
resulting `Arc<RenderImage>` to `img` reuses the pixels instead. Neither app
request populates an image-cache provider's separate storage.

During rendering, [`Window::use_asset`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Window.html#method.use_asset) returns
`None` while pending and the output when ready. It arranges completion
notification for the request that creates the cache entry. Outside rendering,
await the shared task returned by `fetch_asset`, update the owner, and notify
the view. The [scheduling chapter](https://gpui-ce.github.io/book/scheduling.html) explains
how to retain that task and reject results that arrive after a newer request.

The repository's `image_loading` example implements an asset whose key chooses
a delay and a deliberate failure:

```sh
cargo run --example image_loading
```

Its three samples expose the ready, pending, and failed states. Click a sample
to remove its typed cache entry and load it again. Read
[`Asset::load`](https://docs.rs/gpui-ce/0.2.2/gpui/trait.Asset.html#tymethod.load),
[`StyledImage::with_loading`](https://docs.rs/gpui-ce/0.2.2/gpui/trait.StyledImage.html#method.with_loading), and
[`StyledImage::with_fallback`](https://docs.rs/gpui-ce/0.2.2/gpui/trait.StyledImage.html#method.with_fallback) alongside it.
When an image is missing, check the source choice, byte loading, decoding,
cache owner, and completion notification in that order. Each is a different
place for the request to stop.
