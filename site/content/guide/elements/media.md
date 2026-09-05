+++
title = "Pictures and paint: image, SVG, canvas, surface"
description = "Work with images, vector assets, and custom drawing surfaces inside an element tree."
weight = 18
aliases = ["/elements/media.html"]
[extra]
category = "ELEMENTS"
legacy_source = "gpui-ce-docs/build/html/elements/media.html"
+++

Four tools, four jobs. `Img` shows assets, `Svg` draws vectors, `canvas` paints once, `Surface` hosts foreign pixels ([crates/gpui/src/elements/img.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/img.rs)). Pick by what the pixels are, not by habit.

## Images that share

```rust
div()
    // `img` takes an asset path, URI, or raw image data.
    // `ImageSource` (`img.rs:42`) names the three shapes.
    .child(img("assets/logo.png"))
```

`img(source)` builds an `Img` (`img.rs:201`). Supported extensions come from `Img::extensions` (`img.rs:212`). One gallery wants one cache, not one cache per picture.

|  |  |
| --- | --- |
| Need | API |
| share one cache across images | `.image_cache(&entity)` (`img.rs:230`) |
| scope a cache over a subtree | `image_cache(provider)` (`image_cache.rs:15`) |
| keep everything, simplest store | `retain_all(id)` (`image_cache.rs:330`) |
| evict one asset | `remove_asset` (`img.rs:577`) |

Table 4: Cache APIs. Hoist one cache above the gallery.

Caches nest like shadows, not blends. Each `image_cache` element pushes onto a stack (`window.rs:5027`). `Img` reads the innermost entry (`img.rs:311`). A nested cache fully hides the outer one for its subtree. Hoist a single `retain_all` cache above the gallery and share it with `.image_cache(&entity)`.

> **Tip.** One cache entity above the image grid, shared by every `img`. Decoding once beats decoding per frame, and your scroll stays smooth.

## Vectors that reshape

```rust
div()
    // `svg()` starts empty. `.path` points at a bundled asset.
    // `.external_path` reads a file. `.data` takes raw bytes.
    .child(svg().path("assets/icon.svg"))
```

`svg()` builds an `Svg` (`svg.rs:27`). Load with `.path` (`svg.rs:40`), `.external_path` (`svg.rs:46`), or `.data` (`svg.rs:53`). Reshape with `.with_transformation` (`svg.rs:66`).

Here is the trap worth memorizing. `Transformation::scale` (`svg.rs:232`), `translate` (`svg.rs:241`), and `rotate` (`svg.rs:250`) each build a fresh transform from zero. They never compose. Tune pieces with `with_scaling`, `with_translation`, `with_rotation` (`svg.rs:260`). Order stays fixed too: scale always runs before rotate (`svg.rs:277`).

## Paint once, host pixels

```rust
div().child(canvas(
    // Prepaint runs first. Compute a value and carry it forward.
    // Here `42u32` stands in for measured state. Real code returns sizes.
    |_bounds, _window, _cx| 42u32,
    // Paint runs second. Spend the carried state on drawing.
    // `state` is the `42u32` above. Nothing survives past this call.
    |_bounds, state, _window, _cx| { let _ = state; },
))
```

`canvas(prepaint, paint)` (`canvas.rs:10`) is the low-level paint hatch. Both closures are `FnOnce` and stored as `Option` (`canvas.rs:24`). Each is `.take()`n during its phase and gone after. The element paints once and never re-renders. Need reusable drawing? Implement `Element` instead.

```rust
div()
    // `surface` hosts video frames and platform textures.
    // `.object_fit` decides how pixels sit inside the bounds.
    .child(surface(my_source).object_fit(gpui::ObjectFit::Contain))
```

`surface(source)` builds a `Surface` (`surface.rs:91`) from a `SurfaceSource` (`surface.rs:22`). `.object_fit` (`surface.rs:101`) controls scaling. Static assets belong in `img`. Moving pixels belong here.

> **Pitfall.** A fresh image cache per picture, or none at all. Decodes repeat and frames hitch. Hoist one cache above the gallery and hand it to every `img` with `.image_cache(&entity)`.

Where next? Line pictures into very long families (`lists`), or label them with words (`text`).

## Sources

- `img`, `ImageSource`, extensions: [crates/gpui/src/elements/img.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/img.rs), `img.rs:192`, `img.rs:201`, `img.rs:212`
- Cache wiring and stack: `img.rs:230`, `img.rs:311`, `img.rs:577`, `image_cache.rs:15`, `image_cache.rs:330`, `window.rs:5027`
- SVG: `svg.rs:16`, `svg.rs:27`, `svg.rs:40`, `svg.rs:46`, `svg.rs:53`, `svg.rs:66`, `svg.rs:232`, `svg.rs:241`, `svg.rs:250`, `svg.rs:260`, `svg.rs:277`
- Canvas: `canvas.rs:10`, `canvas.rs:24`; Surface: `surface.rs:22`, `surface.rs:84`, `surface.rs:91`, `surface.rs:101`
