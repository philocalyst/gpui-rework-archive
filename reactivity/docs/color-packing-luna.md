# Lossless 16-byte author `Color`: range proof and bit-pack spike

Read-only audit of `/root/gpui-ce3/reactivity` working tree on 2026-10-21. No production code was changed. The proposition is promising, but it is an exact-storage representation change—not an image codec—and it still needs a native paired benchmark before adoption.

## Decision and exact domain

The improved prefix representation is sufficient for every color admitted by the current `gpui_canvas::Color` constructors, including signed zero, subnormals, negative/out-of-gamut and HDR values, all five author spaces, and the current alpha range. This supersedes the earlier idea of applying one shared 95-bit RGB lane to every color: that route needed matrix and libm bounds for authored sRGB/P3/Oklch values. The prefix code stores sRGB, Display P3, and linear Display P3 RGB as their original 96 bits, and only compresses the two spaces whose bounds follow directly from constructor checks: Linear sRGB and Oklch. That removes the portable-`powf` proof hole without adding a rejection check.

`Color::new` first rejects non-finite channels, alpha outside `[0,1]`, and (for Oklch) lightness outside `[0,1]` or negative chroma; it wraps Oklch hue into `[0,360)`. It then accepts only if each `linear_rgb()` component is finite and has magnitude at most `1e20`. The fields are private, and the public const constructors create bounded sRGB values, so there is no other author-color ingress. Keep that validation on the original `[f32;4]` plus `ColorSpace`, then pack only after it passes. The prefix representation does not require changing the accepted set or conversion operation order.

The prefix code needs only these direct domain facts from the actual implementation:

| Space | Existing validation guarantees | Storage lane |
|---|---|---|
| sRGB, Display P3, linear Display P3 | All four source values are finite; no RGB range restriction is imposed independently of the working conversion | Preserve raw RGB f32 words; no matrix/powf inverse bound needed |
| Linear sRGB | `linear_rgb()` is the source RGB directly, then the constructor rejects any component with `abs() > 1e20`. Thus stored values are finite and strictly below `2^67`; the largest admitted biased exponent is at most 193 | Three 24-bit sign+mantissa payloads and one base-199 exponent code (0..=198) |
| Oklch | L is checked in `[0,1]`; C is finite and `C < 0` is rejected; hue is normalized by `wrap_hue` into `[0,360)` | Preserve raw L/C words; store the low 31 bits of normalized hue because its sign is always zero |

No numerical bound on accepted Oklch chroma is needed: preserve all 32 raw C bits, including admitted `-0.0` (`C < 0` is false for negative zero). Preserve raw L too. `wrap_hue` canonicalizes negative zero and multiples of 360 to positive zero, then returns a finite f32 in `[0,360)`, so the normalized hue sign bit is always zero and its low 31 bits are a complete encoding. Alpha alone uses a 30-bit unit code: positive `[0,1]` encodings occupy `0..=0x3f800000`, with `0x3f800001` representing admitted `-0.0`.

This is exactly why the new prefix route is stronger: no argument about P3 inverse matrices, transfer-function monotonicity, trigonometric accuracy, or a maximum admitted Oklch C is required to encode those spaces. The only compressed RGB space is directly bounded by the check on its own channels. Keep constructor validation unchanged and perform no new range rejection.

## Bit budget and independent round-trip check

Use the top two bits as a prefix and, only for prefix `11`, inspect bit 95:

```text
00: sRGB
01: Display P3
10: Linear Display P3
11 + bit95=0: Linear sRGB
11 + bit95=1: Oklch
```

The direct encodings are distinguished by the top two bits. In the two compressed encodings, bit 95 is available as a discriminator: Linear sRGB's base-199 exponent fits bits 72–94, while Oklch uses bit 95 as its tag. This uses a one-bit discriminator rather than a variable-length tag and gives every space the same alpha lane.

The payload lanes are:

- **sRGB / Display P3 / linear Display P3**: raw RGB words in bits 0–95; alpha code in bits 96–125; two-bit tag in bits 126–127. There is no coefficient reconstruction or range assumption for these color spaces.
- **Linear sRGB**: three 24-bit sign+mantissa RGB payloads in bits 0–71; base-199 exponent integer in bits 72–94; bit 95 is zero; alpha code in bits 96–125; top bits `11`. `199^3 = 7,880,599 < 2^23`, so all exponent triples 0–198 fit. `e = (er * 199 + eg) * 199 + eb`; this space alone needs the proven exponent cap, which follows directly from its `linear_rgb()` path and `1e20` limit.
- **Oklch**: raw L bits 0–31; raw C bits 32–63; post-wrap hue's low 31 bits in bits 64–94; bit 95 is one; alpha code in bits 96–125; top bits `11`. The omitted hue sign bit is zero after existing normalization, while L/C signed zero is retained directly.

For the 30-bit alpha code, use raw positive f32 bits through `0x3f800000`, with `0x3f800001` representing negative zero. This alpha lane is bits 96–125 in all five spaces. L and C require no sentinel encoding.

The full payload remains a `[u32;4]`: size 16, alignment 4. It avoids a stored `u128`, whose 16-byte alignment can change enclosing layouts. The Oklch path is word-aligned; direct colors are almost just their four original words, with the uniform alpha code and top tag altering the fourth word. Prefix parsing and compact lanes are integer-only.

The earlier scalar oracle exercised all `199^3` base-199 exponent triples and remains applicable to the Linear sRGB subcodec. Its prefix/tag and Oklch-sentinel checks were for the superseded layout and do not validate this word-aligned design. The present bit-budget/domain proof is independent; require the production source agent's current codec tests to cover all five tags, Oklch L/C signed zero, normalized hue `-0`, `360`, near-360 and large finite inputs, alpha `-0`, and the Linear sRGB discriminator boundary. Do not treat the historical oracle as evidence for the new bit placement.

An x86_64 Rust 1.97.1 `-O` assembly first pass for base-199 exponent decode showed no integer `div`: LLVM lowered quotient/remainder by 199 and 39,601 to constant-multiply-high plus shifts/subtracts. It emitted three wide multiplies and a handful of shifts/subtracts for the three decoded exponent digits. Under the prefix scheme, this cost is limited to `channels()` on Linear sRGB; direct color spaces need only raw word reads and Oklch only needs word reads plus hue-sign reconstruction. This favors the new split, but is not a speed claim. Benchmark actual access patterns before adopting.

## Required semantic compatibility

- Keep constructor validation and the exact f64 conversion operation order on unpacked input; pack only on successful construction. Only the Linear sRGB sublane relies on a restricted exponent; its direct `linear_rgb()` path and existing `1e20` check provide that range after admission. Do not extend this exponent limit to the direct-prefix spaces or add new constructor rejection.
- Reconstruct the original normalized channel bits exactly. Oklch hue is the normalized hue existing `Color::new` stores; do not restore the caller’s out-of-range input angle.
- Preserve `PartialEq` semantics. Derived float equality treats `+0.0` and `-0.0` as equal, while a raw packed-word compare does not. Use raw equality as the fast path and, on mismatch, compare decoded channels with ordinary float `==` plus the space. Do not implement `Eq` or `Hash` as an incidental consequence.
- Preserve the existing `Debug` shape (`Color { channels: [...], space: ... }`) with a custom formatter over decoded channels; deriving `Debug` on the word array changes public output.
- Encode/decode the five `ColorSpace` variants with explicit matches, not enum layout assumptions. Keep alpha `-0.0` through its reserved code; preserve L/C signed zero and every admitted RGB sign-zero bit.
- Retain const support for `rgb`, `rgba`, and built-in colors. Current Rust supports const `f32::to_bits`; check any exact MSRV and const-evaluation constraints in the real crate.

## Where the retained bytes actually change

Current `Color` is 20 bytes (four f32 channels plus the 4-byte enum). `[u32;4]` makes it 16 bytes/alignment 4. In the current GPUI `Style`, foreground and background are both inline `Color`, so the expected `Style` size falls from 96 to 88 bytes; the current `Node` size falls from 136 to 128 bytes. The repository already asserts the current Color and Node sizes. This saves 8 retained bytes per runtime node (and also shrinks each in-memory `El` style while a view description is being built).

Do not count a Canvas draw-record win: `Canvas::clear` and draw methods immediately convert `Color` to premultiplied `[f32;4]`; `Common.color` and the retained paint commands store those 16-byte working samples already. The packed author `Color` helps the API value and GPUI node style, while raster/pixel buffers remain unchanged. The win is consequently workload dependent and is not “every pixel gets smaller.”

Style interning is a separate candidate, not a free multiplier. The 96-byte GPUI author `Style` is inline in each Node, but Cephal already interns its different 288-byte layout `Style` in `StyleTable`; a new GPUI table would be a second index/table and adds hash lookup to node creation/property mutation. At `N` nodes and `U` distinct styles, replacing the node’s 96-byte style with a 4-byte ID saves about `92N` bytes before table costs, but each unique 96-byte key plus refcounts/hash/chains/table capacity costs more than 96 bytes. All-unique styles lose; a default-heavy distribution may win. It must reclaim/reuse on last release (Cephal’s `StyleTable` does this for layout styles) and must be measured against the existing Cephal table rather than counted as if the latter vanished. Packed Color is the bounded lower-risk baseline: an exact 8 bytes/node with no style table or extra hash path.

## Adoption gate and adversarial cases

Do not merge based on the bit budget alone. A real candidate should pass:

1. Exact layout assertions: `Color == 16` bytes/alignment 4, GPUI `Style == 88`, runtime `Node == 128`; also check `Option<Color>` and all enclosing hot records, not only the leaf type.
2. Existing and new constructor tests for every space: Linear sRGB values at the direct `1e20` working-channel cutoff and adjacent f32 values; positive and negative HDR; sRGB and P3 values around the current converted-working-RGB `1e20` cutoff; Oklch hue at `-0`, `360`, near `360`, `f32::MAX` and `-f32::MAX`; chroma near the accepted/rejected frontier across several hues; alpha `-0`, alpha subnormals, 1, `next_up(1)`, infinities and NaNs. Compare accepted/rejected results with the current implementation, and compare `channels().map(f32::to_bits)` for all accepted cases. This checks the old constructor boundary; it does not make an inverse-matrix bound part of the packed representation.
3. A property/fuzz oracle over all spaces that proves pack/decode bit identity for every constructor success; the exhaustive exponent-triple test above remains a small independent codec test. Test float equality and exact Debug strings for signed-zero variants.
4. Compare baseline/candidate allocations and live bytes in 100k-node mostly-default, mixed style, and all-unique style workloads; also `El` construction and mutation. Expected structural win is exactly 8 bytes per Node and 8 bytes per `Style`; do not include Canvas `Common.color` or pixel working buffers.
5. Benchmark direct `Color` methods and actual consumers: `channels`, `alpha`, `space`, `to_linear_srgb`, `convert`, style equality/property updates, and canvas color submission. The current Canvas path expands to working floats immediately, so a representation that reduces retained bytes but slows every conversion may lose. Inspect release assembly for x86_64 and an ARM64 target, then gate on end-to-end UI workloads and no unexplained regression in color-heavy views.

Lose cases to include explicitly: small windows where 8 B/node is noise; views that mutate/read Color frequently; style-unique pages where no interning pays; Canvas-only users where author Color is immediately expanded; and targets where constant-divide lowering is worse than the x86_64 first pass. No claim is made about native HDR negotiation, image compression, GPU pixel formats, or rendering precision changes.

## Primary sources read

- Current implementation: [local `crates/canvas/src/color.rs`](/root/gpui-ce3/reactivity/crates/canvas/src/color.rs) (especially `Color::new`, `linear_rgb`, matrix constants, and `wrap_hue`); the current size assertion is at line 804. The proposal is based on this implementation’s admitted domain, not a guessed CSS range.
- The user-supplied method source, [Ben Joffe, “A faster way to calculate the day of the week”](https://www.benjoffe.com/fast-day-of-week), read through its range-compression/multiply-and-shift sections. It motivates treating a bounded domain as a coding opportunity; its benchmark wins are specific to its weekday kernels. My x86_64 disassembly check is necessary because compiler lowering for divisor 199 is a separate question.
- [Khronos OpenGL 3.0 specification](https://registry.khronos.org/OpenGL/specs/gl/glspec30.pdf), §§2.1.3–2.1.4 and §3.9.1. R11F_G11F_B10F uses unsigned 5-bit exponents and 5–6 mantissa bits; RGB9_E5 clamps negatives and quantizes to 9-bit mantissas with a shared exponent. These are lossy GPU/storage formats, so they cannot replace author `Color` while preserving all f32 channel bits and negative RGB.
- [Radiance picture format, Greg Ward](https://radsite.lbl.gov/radiance/refer/Notes/picture_format.html). RGBE stores three 8-bit mantissas and one common exponent (at most four bytes per pixel); its common-exponent quantization is an image-storage tradeoff, not a bit-exact four-channel f32 object encoding.
- [OpenEXR Technical Introduction](https://openexr.com/en/latest/TechnicalIntroduction.html), “PXR24” and “The half Data Type.” Half is exact only for values already representable as half; PXR24 intentionally rounds FLOAT to 24 significant bits. Neither is a lossless encoding of arbitrary admitted binary32 author components.
- [Rust `f64::powf` documentation](https://doc.rust-lang.org/stable/core/primitive.f64.html#method.powf) labels precision unspecified and platform dependent. The improved prefix route avoids relying on an inverse transfer bound for color representability.
- Local Cephal source: `vendor/cephal/src/owned/styles.rs` (`StyleTable::intern/release`), `crates/core/src/layout.rs` (existing layout ownership), and GPUI `crates/gpui/src/style.rs`, `runtime.rs`, and `element.rs` (author style layout and use).
