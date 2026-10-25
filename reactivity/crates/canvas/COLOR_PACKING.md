# Exact author-color storage

`Color` stores the same admitted author values in 16 bytes, aligned to four,
using four ordinary `u32` words. Constructors, color spaces, conversion order,
working-domain validation, const palettes/getters, debug fields and float
comparison semantics are preserved. This changes author storage, not pixel
formats or rendering precision. It has measurable arithmetic costs; the
measurement section records the losses as well as the memory savings.

## Why the representation covers the complete domain

Validation still runs on the original `[f32; 4]` and `ColorSpace` before packing.
It rejects non-finite components and alpha outside `[0,1]`, checks Oklch L/C,
normalizes hue, and evaluates the unchanged f64 conversion with the existing
`1e20` working cutoff. There is no additional range guard. In particular,
encoded RGB/P3 admission does not depend on an inverse matrix or a portable
accuracy bound for `powf`, `sin_cos` or cube operations.

Bits 96–125 always contain alpha. Positive alpha's raw binary32 bits span
`0..=0x3f800000`; the unused code `0x3f800001` preserves negative zero. The two
highest bits select these payloads:

| Prefix | Bits 0–95 |
| --- | --- |
| `00`, sRGB | All three raw binary32 words |
| `01`, Display P3 | All three raw binary32 words |
| `10`, linear Display P3 | All three raw binary32 words |
| `11`, bit 95 = 0, linear sRGB | Three sign/mantissa payloads plus a base-199 exponent triple |
| `11`, bit 95 = 1, Oklch | Raw L and C words, followed by hue's 31 non-sign bits |

Linear sRGB is the only exponent-coded space. Its conversion simply widens the
original coefficients to f64, so the existing working cutoff directly proves
`abs(component) <= 1e20 < 2^67`. Its biased exponents are therefore at most 193;
the codec reserves digits through 198.
Sign plus mantissa requires 24 bits/channel, or 72 bits; the exponent triple
`(er * 199 + eg) * 199 + eb` fits 23 bits because `199^3 = 7,880,599 < 2^23`.
That leaves bit 95 clear. Negative/subnormal values and signed zero keep every
original bit. This proof does not require transcendental arithmetic.

Oklch's existing `wrap_hue` returns finite nonnegative hue, mapping negative zero
and a rounded 360 back to positive zero. Thus its hue sign bit is unused and can
hold the discriminator. Its L and C remain raw, including their accepted negative
zeros. Packing never sees the pre-normalization hue. No L/C exponent restriction,
sentinel or inverse color-matrix estimate is required.

Packing writes the four `u32` words directly. Lane-crossing left shifts
intentionally discard the high part after its continuation is assigned to the
next word. The production decoder divides only bounded `u32` values by the
constant 199. A separate test-only reference decodes the complete bitstream as
`u128` and independently divides by `199²` to check every exponent triple. The code allocates nothing, uses no unsafe code,
color lookup table/codebook, registry or per-color metadata. These words are private runtime
storage, not a new persisted or network format.

## Compatibility and verification

`PartialEq` first compares all four words and otherwise compares decoded float
components and space. The fallback preserves `+0 == -0` without canonicalizing
stored author bits. It does not introduce integer `Eq` or `Hash`. The common
word-equality path is inlined; the float fallback is outlined to keep the whole
decoder out of every style comparison. `Debug` retains
`Color { channels: [...], space: ... }`.

The frozen 20-byte implementation in `tests/support/legacy_color.rs` comes from
`a847d85f45`, including its separate conversion matrices and arithmetic. Tests
compare admission errors, every decoded component bit, alpha, debug output,
all 25 source/target space pairs and working output. They include 20,480 random
input tuples plus signed-zero, subnormal, HDR, non-finite, alpha and direct-cutoff
neighbors. Separate codec tests enumerate all 7,880,599 exponent triples with
varying mantissas/signs against both decoders, and exercise arbitrary raw RGB words, raw Oklch L/C,
nonnegative hue bits and alpha sentinels. Tests that bypass admission are private
codec proofs, not additional public constructor forms.

Actual CPU output is compared byte for byte against independently converted
legacy working colors across sRGB/P3 SDR and both linear HDR profiles, with
fractional/sheared source-over. The complete CPU/parallel suite runs unchanged.
The real Vulkan suite also runs, including all five author layouts through SDR
and HDR readback. That additional fixture retains the renderer's precision
budget (one byte or one binary16 code); it does not claim universal CPU/GPU byte
parity. The 48-label release binary's 921,615-byte PPM export was also identical
between the baseline and packed executables.

## Layout and allocation ledger

Measured on x86_64 Linux with Rust 1.97.1:

| Type | Previous | Packed |
| --- | ---: | ---: |
| `Color` | 20 B | 16 B |
| `Option<Color>` | 20 B | 20 B |
| `Style` (two colors) | 96 B | 88 B |
| retained GPUI `Node` | 136 B | 128 B |
| `El` | 184 B | 176 B |
| `DraftNode` | 160 B | 152 B |
| `Presented` | 88 B | 88 B |
| `Canvas` header | 544 B | 544 B |
| Canvas run common / placement | 80 B / 32 B | 80 B / 32 B |
| GPU working RGBA | 16 B | 16 B |

No new allocation or retained index accompanies packing. The measured 1,001-node
mount saves exactly 8,008 live bytes; 10,001 nodes save exactly 80,008 bytes for
both repeated and unique authored styles. Allocation counts are unchanged.
This is an eight-byte retained-node saving, not an eight-byte-per-pixel saving.
The tiny two-node mount saves only 16 bytes; native/driver/font/AT floors dominate
small windows. Whole-process RSS is reported separately and is not inferred from
the type sizes.

## Measurement

Final measurements are in `evidence-color-packing.csv`; the earlier cross-word
compact-alpha decoder's paired capture is retained in
`evidence-color-packing-prior.csv`. The latter is an earlier layout, not the
implementation in this source. The final decoder makes Oklch word-aligned and
alpha uniform across all five spaces.

The benchmark uses five alternating fresh-process baseline/candidate pairs,
release builds from the same source base and identical benchmark code, on the
same machine without competing compile/benchmark jobs. `color_cost` records
primitive operations plus actual repeated/unique-style recording mounts;
`first_frame` mounts the public Todos/Graphics models and renders BGRX;
`cpu` and `parallel` run the existing real scene fixtures. Parallel workers are
0/1/2/4/8 with serial digest checks. These are wall-clock measurements, not GPU
timestamps. Native Todos explicitly uses ReferenceCpu and the `x11-minimal`
AT-disabled diagnostic profile, under Xvfb. Its startup sample ends at the actual
successful presentation callback; process memory comes from `smaps_rollup` just
after that callback. This does not measure an active screen reader, discrete GPU,
OS HDR negotiation or compositor memory.

Median values from the final aligned layout capture:

| Primitive (ns/color) | Channels, previous → packed | Working conversion, previous → packed |
| --- | ---: | ---: |
| Srgb | 2.033 → 2.047 (+0.7%) | 55.232 → 43.494 (-21.3%) |
| DisplayP3 | 2.026 → 2.044 (+0.9%) | 71.801 → 68.069 (-5.2%) |
| LinearDisplayP3 | 2.030 → 2.045 (+0.7%) | 16.460 → 18.923 (+15.0%) |
| LinearSrgb | 2.034 → 6.300 (+209.7%) | 15.205 → 7.105 (-53.3%) |
| Oklch | 2.035 → 2.302 (+13.1%) | 31.653 → 41.706 (+31.8%) |

Across the five spaces the by-value equality loop remains about 4.56 → 8.61 ns (+89%); release assembly confirms its word-equal branch is an inlined 16-byte SIMD compare. Uniform alpha reads are about 2.03 ns in both versions. Space reads cost roughly 0.25–0.6 ns more. These losses include copying/spill/ABI effects of the explicit `black_box` value loop; they are not hidden by the structural saving.

| Actual mount | Preparation µs, previous → packed | Newly retained bytes, previous → packed |
| --- | ---: | ---: |
| 1,000 repeated style rows | 1,535.844 → 1,492.683 (-2.8%) | 1,000,788 → 992,780 |
| 10,000 repeated style rows | 15,754.339 → 15,511.784 (-1.5%) | 10,234,212 → 10,154,204 |
| 1,000 unique style rows | 937.401 → 916.611 (-2.2%) | 422,820 → 414,812 |
| 10,000 unique style rows | 9,743.465 → 10,260.887 (+5.3%) | 5,014,212 → 4,934,204 |

| Public application / CPU fixture | Previous → packed µs |
| --- | ---: |
| todos, prepare, all 10 iterations/process | 1,271.000 → 1,267.500 (-0.3%) |
| todos, raster, all 10 iterations/process | 1,747.500 → 1,789.000 (+2.4%) |
| graphics, prepare, all 10 iterations/process | 3,254.500 → 3,226.500 (-0.9%) |
| graphics, raster, all 10 iterations/process | 5,560.500 → 5,718.500 (+2.8%) |
| flat, tile proofs on | 179.744 → 179.624 (-0.1%) |
| opaque_overlap, tile proofs on | 20.580 → 20.580 (+0.0%) |
| alpha_overlap, tile proofs on | 54.091 → 54.241 (+0.3%) |
| sheared, tile proofs on | 3,244.932 → 3,329.394 (+2.6%) |
| labels, tile proofs on | 17,150.650 → 17,150.890 (+0.0%) |
| boundary_dense, tile proofs on | 5.322 → 5.472 (+2.8%) |

The CPU reference mode with proofs disabled slows by 2.1–3.7% in flat/overlap/shear/boundary fixtures; labels are +0.2%. The 10K unique-style mount is a repeatable losing case (+5.3%) despite saving 80,008 retained bytes. Native CPU first acknowledgement is 16,077.000 → 16,042.000 (-0.2%) µs. No general CPU performance improvement is claimed.

| Parallel fixture | Serial previous → packed µs | Four workers previous → packed µs | Eight workers previous → packed µs |
| --- | ---: | ---: | ---: |
| flat | 180.800 → 190.968 (+5.6%) | 70.857 → 72.429 (+2.2%) | 60.055 → 60.719 (+1.1%) |
| large_flat | 1,540.551 → 1,624.779 (+5.5%) | 474.831 → 460.580 (-3.0%) | 325.297 → 339.274 (+4.3%) |
| labels | 17,108.169 → 16,940.075 (-1.0%) | 4,699.695 → 4,542.081 (-3.4%) | 2,889.684 → 2,780.101 (-3.8%) |
| shear | 3,225.835 → 3,157.763 (-2.1%) | 974.698 → 959.431 (-1.6%) | 584.146 → 601.737 (+3.0%) |
| boundary | 17.987 → 17.122 (-4.8%) | 18.648 → 20.683 (+10.9%) | 22.706 → 21.966 (-3.3%) |

Parallel wall time includes scheduling and fixed pool costs; the worst reported final delta is the small boundary fixture at four workers (+10.9%), while worker count two on large flat is +5.9%. All serial/parallel and legacy/packed digest values match for these fixtures; the independent CPU pixel oracles provide exact byte comparisons rather than relying solely on hashes.

| Native process memory after first CPU acknowledgement (KiB) | Previous → packed |
| --- | ---: |
| Rss | 12,624 → 13,020 |
| Pss | 11,026 → 11,434 |
| Private_Dirty | 2,668 → 2,672 |
| Anonymous | 1,800 → 1,804 |

Native RSS/PSS increases here rather than falling; the retained eight-byte-node saving does not establish a process cold-floor win. This capture does not isolate code-page placement, allocator/page rounding, font pages or X11 library residency, so the RSS delta is not attributed wholly to the packed object. Both versions disable AT for this diagnostic capture. Active AccessKit/Linux adapter costs belong to the separate accessible-native ledger.

The primitive loop passes `Color` by value through `black_box`, so its timings
include representation-dependent copying, spills and ABI effects. A larger
percentage on a 2 ns accessor is not a whole-application prediction. Conversely,
measured regressions in real mounts/renders are retained, not erased by the
structural saving. No general rendering-speed or native-RSS win is claimed.

To reproduce, build `color_cost`, `first_frame`, `cpu`, `parallel` and `workbench`
from `a847d85f45` plus the same `color_cost.rs` benchmark, save those release
executables, then build this revision and save its executables in a second
directory. Use `gpui` features `x11-minimal` and `gpui_canvas/parallel` for both.
From a real X11 test environment run:

```sh
python3 crates/canvas/tools/measure_color.py /path/to/baseline /path/to/packed results.csv
cargo test -p gpui_canvas --features parallel
cargo test -p gpui
cargo test -p gpui_gpu --features vulkan-tests --test render
```

The Vulkan command requires a configured adapter and fails if one is unavailable.
The capture script runs native executables and requires an X11 display; it does
not silently replace native presentation with a detached renderer.

Release disassembly from the actual `color_cost` production calls is recorded in
`evidence-color-packing-asm.txt`. `alpha_only` masks word 3 and checks its sentinel;
`space_only` examines the prefix and, for `11`, the discriminator bit. Neither
performs RGB reconstruction. The Linear sRGB channel branch contains reciprocal
multiply/shift/subtract sequences, with no `div`, `idiv`, or wide-division helper.
The same production source was also compiled to AArch64 macOS assembly; its
constant divisions use `umull`/shift/`msub`, while alpha/space remain independent
of RGB reconstruction. That code-generation check does not execute on Apple
hardware; ARM timing remains a separate verification target.


After capture, packing was rewritten from constant-shift `u128` assembly to
explicit four-word lane assignments for readability. The rebuilt
`color_cost::main`, the three accessor wrappers and Linear sRGB/P3/Oklch
constructors have identical normalized machine instructions (excluding
relocations/comments) before and after that cleanup. No timing run was repeated
for this representation-equivalent cleanup. Final executable hashes are recorded
below to distinguish the captured build from the final source build; ELF text
sizes differ by -12 B (`color_cost`) and +8 B (`workbench`), including padding.

| Executable | Captured aligned build SHA-256 | Final direct-word build SHA-256 |
| --- | --- | --- |
| `color_cost` | `d9cc343d6afdd88465f2ebd42f6fe295c5e70ebcba4012408f59b82ae7354588` | `1b97e39b23c59a94adc1fbe9c1fd8bb3116fcce88a71f73a25b3096c8110ffac` |
| `workbench` | `551a93d2ccc1caa91b2c2eb0e1a0d95aa3487e51ff33e20c9ddf043fa2dd0fbf` | `e9f4fdcecc41657a31ae8e07fec5849abc5c344b55849c10fd77e2f700549ff1` |
