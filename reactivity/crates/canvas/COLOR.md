# Color and HDR byte contract

Use `oklch(l,c,h)?` for opaque authoring colors, or
`Color::oklch(l,c,h,a)?` for transparency. L and alpha must be finite in [0,1];
chroma must be finite and nonnegative. Hue must be finite, in degrees, and wraps
into [0,360). This Rust constructor rejects invalid ranges rather than applying
CSS parser clamping. All converted working channels must remain within ±1e20.
Oklch components remain in the 20-byte tagged `Color`; the neutral defaults
BLACK, WHITE and TRANSPARENT also use Oklch. `rgb(hex)` and byte RGB/RGBA
constructors continue to author sRGB.

Oklch converts through D65 OKLab and XYZ into extended linear sRGB before
premultiplication and source-over. Out-of-gamut negative channels survive.
No display gamut mapping is applied during author conversion. Neutral Oklch is
exactly L³ in each working RGB channel. For scene highlights use the explicit
`Color::linear_srgb` or `linear_display_p3` constructors: Oklch's L≤1 authoring
range is not an HDR highlight container. Conversion of HDR RGB into Oklch can
therefore return `InvalidColor`; it never silently clamps L.

`ColorConfig::linear_hdr(OutputProfile::DisplayP3,203.0)?` selects an eight-byte
RGBA16Float buffer. Every pixel contains R,G,B,A in that order, each encoded as
**little-endian IEEE binary16**, with **premultiplied, linear-light** RGB in the
selected sRGB or Display P3 primaries and D65 white. A value of linear neutral
1 represents `reference_white_nits` cd/m², default 203; this is interpretation
metadata and never rescales samples. `ColorConfig::metadata()` supplies exact
primary chromaticities, D65 [0.3127,0.3290], linear transfer, alpha association,
reference white and numeric conversion policy. `bytes_per_pixel()` is 8 for
this format and 4 for RGBA8. Consumers must inspect format and metadata.

The float output preserves negative channels and values above one, applies
neither the sRGB transfer nor an SDR tone/gamut mapper, and uses the named
`FloatRangePolicy::FiniteSaturate` storage conversion: round to nearest with
ties to even, including subnormals, and saturate magnitudes above 65504 to
signed 65504. This numeric storage limit is **not** clipping to a display gamut.
It happens only after composition/profile conversion, so large positive and
negative contributions can cancel first. Infinities are never written; NaN
would violate the validated finite compositor invariant and asserts internally.
Alpha follows the same binary16 rounding; valid scenes have alpha in [0,1].
Profile conversion stays f64 until binary16 rounding to avoid double rounding.
SDR Reinhard mapping together with RGBA16Float is rejected; `mapping: Clip` is
the compatibility default and selects no SDR mapper for float output.

RGBA8 retains its existing premultiplied sRGB-transfer output in selected
primaries and its explicit Clip/Reinhard SDR mapping. Float metadata and bytes
do not by themselves enable an HDR monitor, negotiate an OS swapchain or imply
PQ/HLG/Rec.2020 output. A native presenter must honor this contract and perform
any additional display negotiation or conversion explicitly.

Conversions follow the [CSS Color 4 matrices (9 October 2026 draft)](https://www.w3.org/TR/2026/CRD-css-color-4-20261009/#color-conversion-code).
Independent tests compare the XYZ route against [Björn Ottosson's published
direct linear-sRGB Oklab formula](https://bottosson.github.io/posts/oklab/#converting-from-linear-srgb-to-oklab).
The default 203 cd/m² convention follows the [CSS Color HDR diffuse-white
example (8 October 2026 working draft)](https://www.w3.org/TR/2026/WD-css-color-hdr-1-20261008/#valdef-color-rec2100-linear);
our selectable sRGB/P3 primaries are not Rec.2100 primaries.
The [OpenEXR half format](https://openexr.com/en/latest/TechnicalIntroduction.html#the-half-data-type)
also documents the binary16 storage model. No new dependency or unsafe code is
used. Tests cover every 63,488 finite half bit pattern, every adjacent positive
half midpoint plus/minus one f64 ulp on both signs, signed zero, subnormals,
overflow, channel byte order, alpha, and independent color reference values.
