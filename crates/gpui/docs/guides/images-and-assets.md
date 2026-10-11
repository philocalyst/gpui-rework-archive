# Show images and icons

Use [`img`] for raster and full-color images, and [`svg`] for single-color
icons that take their color from the text color. Both load their data in the
background, so you can give them a placeholder and an error fallback.

## Choose a source for `img`

[`img`] takes anything that converts to an [`ImageSource`]. The kind of source
decides where the bytes come from:

| Source | Example | Loaded from |
| --- | --- | --- |
| A string that parses as a URL | `img("https://example.com/logo.png")` | The HTTP client |
| Any other string | `img("images/logo.png")` | The [`AssetRegistry`] of the app |
| A `PathBuf` or `&Path` | `img(path)` | The file system, relative to the working directory |
| An [`Image`] in an `Arc` | `img(Arc::new(Image::from_bytes(..)))` | Bytes you already have |
| A [`RenderImage`] in an `Arc` | `img(render_image)` | Nothing, it is decoded already |

URLs go through the app's HTTP client, which you set with
`Application::with_http_client`. Without one, requests fail and the error
fallback is shown. The web `gpui_platform` constructors set a client; the native
ones do not.

```rust
# use gpui::*;
let remote = img("https://example.com/avatar.png");
let bundled = img("images/logo.png");
let local = img(std::path::PathBuf::from("assets/banner.jpg"));
```

Building the element starts no work. The first time the element is laid out, it
starts the load, which finishes on a background thread. Until then the element
has no size of its own unless you give it one.

## Embed image bytes

When the bytes are already in your program, such as a file included with
`include_bytes!`, wrap them in an [`Image`]. Pass the [`ImageFormat`], which
tells the decoder how to read them. This example uses a small inline SVG so it
can run as a doctest:

```rust
# use gpui::*;
# use std::sync::Arc;
const DOT: &[u8] = b"<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 8 8\"><circle cx=\"4\" cy=\"4\" r=\"4\" fill=\"#2563eb\"/></svg>";

let dot = Arc::new(Image::from_bytes(ImageFormat::Svg, DOT.to_vec()));
let icon = img(dot.clone()).size(px(96.));
```

[`Image::from_bytes`] takes the bytes by value and hashes them to get an ID. Two
images with the same bytes share one decoded copy. SVG bytes are rendered in
full color through the same path, with [`ImageFormat::Svg`].

## Size and fit the image

An image with no width or height uses its natural size. Set one dimension and
the other follows the aspect ratio. Set both and [`StyledImage::object_fit`]
decides how the picture fills the box, using [`ObjectFit`]:

- [`ObjectFit::Contain`] (the default) scales to fit inside, with empty space.
- [`ObjectFit::Cover`] scales to fill, cropping the overflow.
- [`ObjectFit::Fill`] stretches to the box and ignores the aspect ratio.
- [`ObjectFit::ScaleDown`] is `Contain`, but never enlarges past natural size.
- [`ObjectFit::None`] keeps natural size and crops to the box.

```rust
# use gpui::*;
let avatar = img("images/avatar.png")
    .size(px(48.))
    .rounded_full()
    .object_fit(ObjectFit::Cover);

let disabled_logo = img("images/logo.png").size(px(120.)).grayscale(true);
```

## Show a placeholder while loading, and a fallback on error

[`StyledImage::with_loading`] takes a closure that builds a placeholder. It
appears only if the image is still loading after 200 milliseconds
(`LOADING_DELAY`), so fast loads never flash. [`StyledImage::with_fallback`]
takes a closure for when the load fails. Failures include a missing asset, an
HTTP status other than success, and bytes that do not decode:

```rust
# use gpui::*;
let photo = img("https://example.com/photo.jpg")
    .size(px(240.))
    .with_loading(|| {
        div()
            .size(px(240.))
            .bg(rgb(0xe5e7eb))
            .into_any_element()
    })
    .with_fallback(|| {
        div()
            .size(px(240.))
            .flex()
            .items_center()
            .justify_center()
            .child("Image unavailable")
            .into_any_element()
    });
```

Both closures return an [`AnyElement`]. Each one is called again on every layout
where it is shown, so keep them cheap.

## Draw icons with `svg`

[`svg`] paints the alpha channel of an SVG as a mask, filled with the element's
text color. That makes it the right tool for icons that follow the theme. It
takes its file from one of three places:

- [`Svg::path`] names an asset in the [`AssetRegistry`], as `img` does with
  asset paths.
- [`Svg::external_path`] reads a file from the file system.
- [`Svg::data`] takes the bytes directly, which suits an icon you include with
  `include_bytes!`.

```rust
# use gpui::*;
const STAR: &[u8] = b"<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 8 8\"><rect width=\"8\" height=\"8\"/></svg>";

let search_icon = svg()
    .path("icons/search.svg")
    .size(px(16.))
    .text_color(rgb(0x2563eb));

let star = svg()
    .data(STAR)
    .size(px(16.))
    .text_color(rgb(0xf59e0b));
```

Use [`img`] instead when the SVG has colors you want to keep, because the mask
drops them. [`Svg::with_transformation`] rotates, scales or moves the rendering
without changing layout.

## Register assets with the app

Asset paths are looked up in an [`AssetRegistry`], which you give the app with
[`Application::with_assets`]. Paths are plain keys with no leading slash. Build a
registry with [`AssetRegistry::insert`], giving each entry bytes that are
static, loaded, or loaded on demand:

```rust
# use gpui::*;
# use std::borrow::Cow;
let mut assets = AssetRegistry::default();
assets
    .insert(
        "icons/star.svg",
        Cow::Borrowed(
            &b"<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 8 8\"><rect width=\"8\" height=\"8\"/></svg>"[..],
        ),
    )
    .unwrap();

assert!(assets.load("icons/star.svg").is_some());
assert!(assets.load("icons/missing.svg").is_none());
```

Then pass the registry to the application builder:

```rust,no_run
# use gpui::*;
# fn assets() -> AssetRegistry { AssetRegistry::default() }
fn main() {
    gpui_platform::application()
        .with_assets(assets())
        .run(|_cx: &mut App| {
            // Open windows here. Images and icons load the assets above.
        });
}
```

To bundle a whole folder into the binary, enable the `embedded-assets` feature of
`gpui` and add `rust-embed` to your own crate. Derive `RustEmbed` for a type that
points at the folder, then load it with [`AssetRegistry::iter_embed`] and
[`AssetRegistry::extend`]. Paths are the file names relative to that folder.

## Cache images

Images are cached by source. The first `img` that uses a URL, path or asset
starts the load, and later `img` elements with the same source reuse the
decoded result. The cache is app-wide and keeps entries until you remove them,
which [`ImageSource::remove_asset`] does for one source.

To control when a group of images is released, wrap it in [`image_cache`] with a
[`retain_all`] provider. Images inside it that load from a URL, path or asset use
a cache that lives as long as the element's state does, so they are freed when
the group disappears. Images built from bytes with [`Image`] always use the
app-wide cache.

```rust
# use gpui::*;
let gallery = image_cache(retain_all("gallery")).children(
    (0..3).map(|ix| {
        img(format!("https://example.com/photos/{ix}.jpg"))
            .size(px(120.))
            .into_any_element()
    }),
);
```

If you write your own [`ImageCache`], attach it to a single image with
[`Img::image_cache`].

## Animated images

GIF images and animated WebP images decode into frames, and [`img`] plays them
in a loop. This holds for images loaded from a URL, path or asset name. An
animated WebP passed as [`Image`] bytes shows its first frame. While the window
is active and [`App::reduce_motion`] is false, the element requests the next
frame itself. Still images, and other animated formats, show their first frame.

## See also

- [Images example](crate::_documentation::examples::images), which shows object
  fit, byte sources and tinted icons. Run it with `cargo run --example images`.
- [Text](crate::_documentation::guides::text) for placing icons next to labels.
- [Custom drawing](crate::_documentation::guides::custom_drawing) for drawing an
  image inside a `canvas` with [`Window::paint_image`].
- [Accessibility](crate::_documentation::guides::accessibility) for alternative
  text on images that carry meaning.
