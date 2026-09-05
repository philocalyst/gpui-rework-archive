+++
title = "Geometry and color"
description = "Work with the typed geometry and color vocabulary used throughout the rendering system."
weight = 27
aliases = ["/graphics/geometry-color.html"]
[extra]
category = "GRAPHICS"
legacy_source = "gpui-ce-docs/build/html/graphics/geometry-color.html"
+++

**Geometry** is points, sizes, and boxes generic over unit. Every shape carries its unit in the type ([crates/gpui/src/geometry.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/geometry.rs)), so a pixel value never sneaks into a device-pixel slot by accident. Pick your unit, and the compiler walks with you.

```rust
// Points locate, sizes measure, bounds combine both.
// The `_` types are units — mix them and the compiler stops you kindly.
let origin = Point::new(px(8.), px(16.)); // a spot in `Pixels`
let size = Size::new(px(100.), px(20.)); // a width plus a height
let b = Bounds::new(origin, size); // spot + measure = a box `geometry.rs:811`
let inner = b.inset(px(2.)); // shrink all sides by 2 `geometry.rs:1097`
```

Start in layout with **Pixels**, the logical `f32` unit ([crates/gpui/src/geometry.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/geometry.rs)). Paint with **ScaledPixels**, which folds in the display scale ([crates/gpui/src/geometry.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/geometry.rs)). The backend finally snaps to **DevicePixels**, whole physical pixels ([crates/gpui/src/geometry.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/geometry.rs)). Type sizes round out the family: **Rems** scale with your root font size ([crates/gpui/src/geometry.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/geometry.rs)).

## Boxes and edges

**Bounds** is origin plus size ([crates/gpui/src/geometry.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/geometry.rs)). It answers the questions you ask all day: do we overlap, where do we meet, what holds us both.

```rust
// Union grows to hold both boxes, contains tests one point.
// `intersects` asks cheaply, `intersect` hands back the overlap box.
let both = b.union(&other); // smallest box holding both `geometry.rs:1180`
let hit = b.contains(&point); // half-open test, right edge excluded `geometry.rs:1463`
let overlap = b.intersect(&other); // shared region, maybe empty `geometry.rs:1138`
if overlap.is_empty() { return; } // zero-size means no overlap `geometry.rs:1619`
```

|  |  |
| --- | --- |
| Call | When you reach for it |
| `from_corners` / `centered_at` | Build from corners or center it (`geometry.rs:847`, `:877`) |
| `intersects` / `intersect` | `bool` check is cheap, box return draws (`:960`, `:1138`) |
| `dilate` / `inset` / `extend` | Grow, shrink, or push per edge (`:1062`, `:1097`, `:1072`) |
| `map_origin` / `map_size` | Nudge position or measure alone (`geometry.rs:1564`) |
| `center` / `at_anchor` | Place a child with no arithmetic (`geometry.rs:485–493`) |

Table 19: Bounds calls you use weekly.

Edges and corners finish the vocabulary. **Edges** holds per-side insets like padding ([crates/gpui/src/geometry.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/geometry.rs)), built with `Edges::all` or `zero` (`crates/gpui/src/geometry.rs:1815–1940`). **Corners** holds per-corner radii ([crates/gpui/src/geometry.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/geometry.rs)), built with `Corners::all` ([crates/gpui/src/geometry.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/geometry.rs)), and `clamp_radii_for_quad_size` keeps fat radii inside small boxes ([crates/gpui/src/geometry.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/geometry.rs)).

> **Tip.** Keep hot layout in `Pixels` and convert once at paint. Check `is_empty` before painting and you skip backend work for free.

## Unit ladder

Conversions are explicit, and each rung rounds differently. That difference bites, so learn it once here.

```rust
// Each rung has one job: scale, then optionally snap to whole pixels.
// `scale` never rounds, `to_device_pixels` always does.
let scaled: Bounds<ScaledPixels> = b.scale(factor); // `* factor`, no rounding `geometry.rs:1693`
let device: Bounds<DevicePixels> = b.to_device_pixels(factor); // `* factor`, then round `geometry.rs:1701`
let back: Bounds<Pixels> = device.to_pixels(factor); // divide back, may not round-trip `geometry.rs:1714`
```

|  |  |  |
| --- | --- | --- |
| Trip | Code | Rounding |
| `Pixels` to `ScaledPixels` | `scale(factor)` at `geometry.rs:2828` | None, pure multiply |
| `Pixels` to `DevicePixels` | `to_device_pixels` at `geometry.rs:1701` | Rounds to nearest `i32` |
| `ScaledPixels` to `DevicePixels` | `From` at `geometry.rs:3129` | Ceils upward, not round |
| `Rems` to `Pixels` | `to_pixels(rem_size)` at `geometry.rs:3242` | None, multiply by root size |

Table 20: The unit ladder and where rounding enters.

> **Pitfall.** Two roads lead to device pixels and they disagree on halves. `to_device_pixels` rounds (`0.5` snaps to nearest), while `ScaledPixels` converts with ceil (`0.5` snaps up). Pick one road per pipeline or your borders shimmer by a pixel.

## Rgba and Hsla

**Rgba** is light as the screen shows it, red-green-blue plus alpha. **Hsla** is light as humans tune it, hue-saturation-lightness plus alpha ([crates/gpui/src/color.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/color.rs)). Most style APIs take `Hsla`, so convert at the boundary and stay there.

```rust
// Hex in, tunable color out — then fade by multiplying, not by setting.
// `opacity(0.6)` keeps 60% of whatever alpha you already had.
let accent = gpui::rgb(0x0b5fff); // opaque sRGB `color.rs:10`
let overlay = gpui::rgba(0x00000080); // alpha rides in the low byte `color.rs:19`
let text: Hsla = gpui::rgb_to_hsla(accent); // cross the boundary once `color.rs:28`
let faded = text.opacity(0.6); // alpha `*=` 0.6, see `color.rs:205`
```

Helpers cover the rest: `hsla(h, s, l, a)` takes hue as a `0–1` circle fraction ([crates/gpui/src/color.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/color.rs)), named constructors give you `black`, `white`, `red`, `green`, `blue`, `yellow`, and the transparent pair (`crates/gpui/src/color.rs:68–108`). **Background** covers fills beyond flat color: gradients, slashes, checkerboards ([crates/gpui/src/color.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/color.rs), `:329–367`).

> **Pitfall.** `opacity` multiplies, never sets. Fading an already-faint `alpha 0.5` by `0.5` lands at `0.25`, not `0.5`. Start from opaque when you want exact alphas.

## System colors

**Colors** is the default palette ([crates/gpui/src/colors.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/colors.rs)). It holds eight slots: text, selected text, background, disabled, selected, border, separator, container. Pick the set by appearance and paint from it.

```rust
// Read once per render, share across every element that frame.
// Per-element lookups repeat the same answer and waste your budget.
let c = Colors::for_appearance(&window); // light or dark by window `colors.rs:37`
let global: &Arc<Colors> = Colors::get_global(cx); // app-wide set `colors.rs:73`
```

**DefaultColors** exposes the same slots per element ([crates/gpui/src/colors.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/colors.rs)), **DefaultAppearance** selects light or dark ([crates/gpui/src/colors.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/colors.rs)), and **GlobalColors** overrides the app-wide set ([crates/gpui/src/colors.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/colors.rs)).

> **Tip.** Read `get_global` once per render and thread the reference down. Stay in `Hsla` end to end — converting `Rgba` per element per frame is pure overhead.

Where next? Paint these boxes into the scene (`./scene-rendering.html`), write words inside them (`./text-system.html`), or move them gently (`./animation.html`).

## Sources

- `Point`: [crates/gpui/src/geometry.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/geometry.rs); `Size`: `geometry.rs:411`; `Bounds`: `geometry.rs:752`; `Bounds::new`: `geometry.rs:811`
- `from_corners`: `geometry.rs:847`; `centered_at`: `geometry.rs:877`; `intersects`: `geometry.rs:960`; `dilate`: `geometry.rs:1062`; `intersect`: `geometry.rs:1138`
- `union`: `geometry.rs:1180`; `contains`: `geometry.rs:1463`; `is_empty`: `geometry.rs:1619`; `scale`: `geometry.rs:1693`, `geometry.rs:2828`
- `to_device_pixels`: `geometry.rs:1701`; `to_pixels`: `geometry.rs:1714`; `Edges`: `geometry.rs:1748`; `Corners`: `geometry.rs:2256`
- `Pixels`: `geometry.rs:2675`; `DevicePixels`: `geometry.rs:2980`; `ScaledPixels`: `geometry.rs:3073`; `Rems`: `geometry.rs:3236`
- `rgb` / `rgba` / `hsla`: [crates/gpui/src/color.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/color.rs), `:19`, `:49`; named colors: `color.rs:68–108`; `ColorExt::opacity`: `color.rs:205`; `Background`: `color.rs:281`
- `Colors`: [crates/gpui/src/colors.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/colors.rs); `for_appearance`: `colors.rs:37`; `get_global`: `colors.rs:73`; `GlobalColors`: `colors.rs:80`
