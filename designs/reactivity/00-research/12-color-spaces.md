# 12 — GPUI color and color-space audit

Research for [runtime/color.md](../runtime/color.md). File paths are as of the audit (2026-08).

## Verdict

GPUI is an **Hsla-first, gamma-encoded sRGB UI** that ships **Oklab only as a 2-stop gradient
mix mode**. There is no Display P3, Rec.2020, HDR, ICC, Lab/LCH/HWB/Oklch value type, or WCAG
contrast helper. The three backends disagree on transfer functions and on whether
`hsla_to_rgba` is linear.

For a professional image/drawing host, the destination should not be “sRGB or P3.” The portable
high-fidelity contract is a **premultiplied linear extended-sRGB working surface**, normally backed
by float16. Extended sRGB keeps fixed D65/sRGB primaries while allowing negative and greater-than-one
components, so an application color-management system can transform arbitrary source profiles into
one stable renderer contract without GPUI learning every monitor gamut. The tagged platform surface
then lets the compositor map that contract to the actual display. This is opt-in: making every
window float16 would double its color-buffer bandwidth/storage and is not zero-cost.

## New issue and implementation evidence

- [zed#9057](https://github.com/zed-industries/zed/issues/9057) (2024) reports theme hex values not
  reproducing exactly after the current `Rgba`/`Hsla` path and macOS capture. It proves that exact
  round-trip and tagged-output fixtures are missing; it does not by itself prove whether the final
  one-code-value discrepancy is CPU conversion, framebuffer quantization, display conversion, or
  the color picker's profile interpretation.
- [zed#8293](https://github.com/zed-industries/zed/issues/8293) asks for authored P3 theme colors.
  That requires tagged authoring colors *and* a non-clamping working/presentation path; relabeling
  existing sRGB triples as P3 changes their meaning and is not color management.
- [zed#48835](https://github.com/zed-industries/zed/pull/48835) proposes an application setting
  that tags the existing macOS `BGRA8Unorm` layer as sRGB, Display P3, or untagged. It does not change
  the framebuffer format, ingest ICC profiles, transform pixels, or implement Windows/Linux, and it
  reuses the gradient-interpolation `ColorSpace` enum as a presentation space. It is a useful proof
  that `CAMetalLayer.colorspace` is the platform seam, but it is not the long-term pipeline.
- [zed discussion #62795](https://github.com/zed-industries/zed/discussions/62795) proposes an
  opt-in float16 surface tagged extended sRGB. That is the right direction and correctly calls out
  bandwidth as the reason for opt-in. Its “no shader changes” route preserves today's encoded-light
  blending, however; this plan instead combines the extended-sRGB surface with the already-adopted
  linear-light compositing correction.
- Flutter's [wide-gamut issue](https://github.com/flutter/flutter/issues/55092) and
  [Impeller implementation](https://github.com/flutter/engine/pull/39111) are the closest shipping
  precedent: opt-in first, wider render/image storage, convert tagged images into a common extended
  sRGB representation, configure the platform layer, then make it default only after gradients,
  save-layers, screenshots, and compatibility are covered. The implementation also demonstrates why
  “wide gamut” is a whole-pipeline property rather than a layer tag.

The platform vocabulary supports this abstraction without hard-coding P3 as the working space.
Windows documents `DXGI_FORMAT_R16G16B16A16_FLOAT` plus
`DXGI_COLOR_SPACE_RGB_FULL_G10_NONE_P709` as its scRGB/Advanced Color path; Vulkan exposes
`VK_COLOR_SPACE_EXTENDED_SRGB_LINEAR_EXT`; Apple exposes extended-sRGB Core Graphics spaces on a
`CAMetalLayer`. Availability still varies by compositor, output, alpha mode, and backend, so GPUI
must negotiate `Prefer`/`Require` and report the realized contract.

| Candidate | Result | Decision |
|---|---|---|
| untagged device RGB | looks vivid on some screens but has no stable color meaning | reject |
| 8-bit sRGB | correct common SDR default; clips wide gamut/HDR and quantizes gradients | retain as zero-tax default |
| 8/10-bit Display P3 | useful output format, but bakes one current display gamut into GPUI | fallback/backend detail, not working contract |
| float16 nonlinear extended sRGB with today's shaders | preserves range but also preserves encoded-light blending errors | migration experiment only |
| float16 **linear** extended sRGB | open gamut basis, correct blend space, CMS-friendly, natural HDR headroom | adopt when requested |

“Extended” and “HDR” are not synonyms. Negative linear-sRGB coordinates are needed to represent
some ordinary wide-gamut SDR colors; values above SDR white provide numeric headroom but become HDR
only under a reference-white/luminance and presentation policy. Likewise, the framebuffer is not a
professional document's storage format: applications may retain source-profiled integer/f16/f32 or
special channels and convert the composited view into GPUI's working surface.

## Public types

[`crates/gpui/src/color.rs`](../../../crates/gpui/src/color.rs):

| Type | Role |
|---|---|
| `Rgba` | `r,g,b,a` in 0…1, treated as sRGB channel numbers |
| `Hsla` | `h,s,l,a` in 0…1 — canonical paint color |
| `ColorSpace` | `Srgb \| Oklab` — interpolation for gradients only |
| `Background` | Solid / linear gradient / slash / checkerboard |
| `LinearColorStop` | `Hsla` + percentage; **exactly two** stops |

No `Srgba`, `LinearRgb`, `Oklch`, `Oklab` (as a value), `Lab`, `Lch`, `Hwb`, `DisplayP3`.

CPU conversions: classic HSL ↔ RGB; `Rgba::blend` / `Hsla::blend` = straight-α over in encoded
RGB; hex parse. `Lerp` is channel-wise on `Rgba`, not `Hsla`.

Theme: [`colors.rs`](../../../crates/gpui/src/colors.rs) — eight `Rgba` hex roles, light/dark.

## Conversion graph (what actually runs)

```
hex / rgb() / rgba()
        │
        ▼
      Rgba  ◄────────────►  Hsla     style, TextStyle, shadows, borders
                                 │
                                 ▼
              Background { solid: Hsla, colors[2], color_space }
                                 │
        ┌────────────────────────┼────────────────────────┐
        ▼                        ▼                        ▼
   Metal shaders            HLSL shaders              WGSL shaders
   BGRA8Unorm               B8G8R8A8_UNORM            Bgra8Unorm
   (no *_sRGB)              (no *_SRGB)               (prefer non-sRGB)
```

## Backend disagreements

**Metal** (`gpui_macos/src/shaders.metal` ~950–977): `srgb_to_linear = pow(c, 2.2)`; Oklab
path decodes then uses Bottosson matrices.

**HLSL** (`gpui_windows/src/shaders.hlsl` ~124–131): the **names are swapped** —
`linear_to_srgb` is `pow(2.2)` (decode) and `srgb_to_linear` is `pow(1/2.2)` (encode).
`srgb_to_oklab` calls the wrongly named `srgb_to_linear` → Windows Oklab gradients diverge
from Mac.

**WGSL** (`gpui_wgpu/src/shaders.wgsl` ~209–421): piecewise IEC sRGB; comments claim
`hsla_to_rgba` returns linear; solids skip that round-trip; Srgb gradient mix encodes,
mixes, decodes.

HSL→RGB math is the same classic conversion on all three (gamma-domain numbers). The
comments do not agree with the math.

## Compositing

- Quads / underlines / Mac mono glyphs: straight α, `SrcAlpha / OneMinusSrcAlpha`.
- Paths / blur: premultiplied (`One / OneMinusSourceAlpha`).
- Subpixel text (Win/wgpu): dual-source blend; transparent LCD text is not meaningful
  (`directx_renderer.rs` ~2002). Subpixel is disabled if the window background is not opaque.
- Emoji / images: premultiplied atlas, often un-premultiplied on upload (`swap_rgba_pa_to_bgra`).
- Gradients: triangular dither ±2/255 RGB (Metal/HLSL). Exactly two stops.
- No `mix-blend-mode`. `over()` is for border AA only.
- No linear-light blending for general UI. A DirectX comment that FL≥9_3 “blends in linear
  space” refers to optional sRGB render targets; GPUI uses non-sRGB `B8G8R8A8_UNORM`.

## Text raster vs tint

Shared: atlas keyed on subpixel variant, scale, emoji, dilation; paint tints with `Hsla`.

- **macOS:** grayscale atlas; luminance-keyed dilation (`glyph_dilation_for_color`); no
  ClearType gamma in the fragment shader. `CAMetalLayer` is `BGRA8Unorm`; no
  `colorspace` / EDR API wired.
- **Windows:** DirectWrite subpixel + `IDWriteRenderingParams` gamma →
  `get_gamma_correction_ratios` (MS Terminal tables in `gpui/src/platform.rs`).
- **wgpu/Linux:** cosmic-text subpixel when dual-source exists; `ZED_FONTS_GAMMA` overrides.

## Gaps vs CSS Color 4 / 5

Present: `hsl()`, hex, gradient `in oklab` (broken cross-backend).

Absent: typed `srgb` / `srgb-linear`, `oklch` as a color, `lab`/`lch`/`hwb`, `display-p3` /
`rec2020`, `color-mix()`, relative color, `contrast-color()`, HDR (`rec2100-pq`/`hlg`),
N-stop gradients, polar hue longer/shorter.

## Tests

Hex deserialize and Background opacity in `color.rs`; `Rgba` lerp; visual
`examples/legacy/gradient.rs`. **No** golden for HSL↔RGB, Oklab round-trip, cross-backend
gradients, or WCAG.

## Key files

| Path | Why |
|---|---|
| `crates/gpui/src/color.rs` | Public types and CPU conversions |
| `crates/gpui/src/colors.rs` | Default eight-role palette |
| `crates/gpui/src/style.rs` / `styled.rs` / `lerp.rs` | Style API; sRGB channel lerp |
| `crates/gpui/src/window.rs` / `scene.rs` | Paint → GPU ABI |
| `crates/gpui/src/platform.rs` | MS Terminal gamma tables |
| `crates/gpui_macos/src/shaders.metal` | Mac paint + Oklab |
| `crates/gpui_macos/src/text_system.rs` | Dilation / CG color spaces |
| `crates/gpui_windows/src/shaders.hlsl` + `alpha_correction.hlsl` | D3D paint + ClearType |
| `crates/gpui_wgpu/src/shaders.wgsl` + `shaders_subpixel.wgsl` | Linux/web |

## Implications for the retained design

Recorded as decisions in [runtime/color.md](../runtime/color.md): tagged `Color`, linear
extended-sRGB working space, opt-in float16 surfaces, application/CMS profile transforms, shared
shader math, HLSL fix, tokens as paint-only, contrast helpers, and destination-tagged `Scene`.
`Hsla`/`Rgba` stay as constructors. Application style chains never name the internal linear type.
