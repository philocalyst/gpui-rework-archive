+++
aliases = ["elements/media.html", "guide/elements/media/", "guide/system/assets-http/", "system/assets-http.html"]
title = "Load assets and images"
description = "Separate bundled paths, asynchronous loading, and cache ownership."
weight = 70
+++

An `AssetSource` resolves application asset paths. An `AssetRegistry` combines
sources under explicit prefixes. Prefer stable names such as `icons/save.svg`
inside the application rather than paths into a developer's home directory.

## Bundle or fetch

Bundle resources that must exist without a network connection. Use the
application's HTTP client for remote resources and handle its failure path.
A remote image can remain pending or fail; the UI should not assume that
rendering its element means the bytes have arrived.

For a complete application, run the repository's `image_loading` example:

```sh
scripts/gpui-example run image_loading
```

It shows local image sources and asynchronous loading through the example
asset setup. The smaller [drawing walkthrough](@/examples/drawing.md) records
primitives directly and does not load an asset.

## Choose a cache owner

A cache's provider and scope determine which views share an image resource and
when it can be released. Recreating a provider on every render can discard that
relationship. Keep the cache where its lifetime matches the resource's use.

SVG sources have a similar boundary: the element selects a source and resolves
it through the asset system, while rasterization and painting follow their own
contracts. A paint transform does not necessarily change the element's hitbox.

The [`AssetSource`](https://docs.rs/gpui-ce/0.2.2/gpui/trait.AssetSource.html),
[`ImageSource`](https://docs.rs/gpui-ce/0.2.2/gpui/enum.ImageSource.html), and
[`Svg`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Svg.html) references describe
those boundaries and their errors.
