+++
aliases = ["elements/media.html", "guide/elements/media/", "guide/system/assets-http/", "system/assets-http.html"]
title = "Load assets and images"
description = "Separate bundled paths, asynchronous loading, and cache ownership."
weight = 70
+++

An `AssetSource` lists and loads named resources. `AssetRegistry` stores the
result under the exact keys you supply; it does not canonicalize paths, join
components, or read the filesystem by itself. Register stable application names
such as `icons/save.svg`, then resolve them through the app's asset setup rather
than exposing a developer's home directory as part of the UI contract.

## Bundle or fetch

Preload small resources that are needed immediately or must work offline. Use
on-demand assets when loading can wait, but remember that an
`AssetRegistry::load` call invokes its loader synchronously: a loader that does
I/O can block the caller. Put remote work behind the HTTP client or image
loader's asynchronous path instead of calling a blocking loader while building
a frame.

For images, a path or URI becomes `ImageSource::Resource` and goes through
`ImageAssetLoader`. Already decoded `RenderImage` and CPU `Image` values skip
resource loading. A custom source is polled by its owner and must represent
pending work as `None`, a completed image as `Some(Ok(..))`, and a terminal
failure as `Some(Err(..))`. Handle that failure in the element's fallback UI;
an image element can exist before its data is ready. An optional loading element
appears only after a 200 ms delay, so fast loads do not flash a placeholder.
Animated images request more frames only while their window is active and
reduced motion is off.

For a complete application, run the repository's `image_loading` example:

```sh
cargo run --example image_loading
```

It shows local sources and async loading through the example asset setup. When
it fails, inspect whether the key is registered, whether the source returned
bytes, and whether decoding succeeded; these are different failure points.
The smaller [drawing walkthrough](@/examples/drawing.md) records primitives
directly and needs no asset source.

## Choose a cache owner

A cache provider determines which descendants share pending loads and decoded
results. Place `image_cache(...)` around the subtree that should share them, or
pass a cache explicitly to an image. `retain_all(id)` stores an entity-backed
cache in retained element state under that stable ID; it reuses a pending task,
notifies the current view when loading finishes, and drops renderer images when
the cache entity is released. Keep the provider identity stable across frames
so the cache lifetime follows the subtree.

SVGs choose one source (`path`, `external_path`, or raw `data`) and decode when
painted. The selected source must be valid; a transform changes the rendered
SVG but leaves layout bounds and its hitbox unchanged. `SurfaceSource` is a
separate platform/GPU interop path with variants gated by target and features,
not a general replacement for loading an image resource.

The [`AssetSource`](https://docs.rs/gpui-ce/0.2.2/gpui/trait.AssetSource.html),
[`ImageSource`](https://docs.rs/gpui-ce/0.2.2/gpui/enum.ImageSource.html), and
[`Svg`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Svg.html) references describe
those boundaries and their errors.
