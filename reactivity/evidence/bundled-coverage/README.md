# Certified bundled coverage and exceptional-scalar scanning

Production commit `f0859ea215e637befd76a56471d99658ac495b45` adopts the exact
eight changed files from `023e584a0504c05e7db33c887de980671f096257`, over production
base `2b52030aed8344ed9c5f6dcf54b2ba19acf8ddf4`. The intervening Main commits
changed documentation and evidence. [The review](review.json) records the gates,
costs and limits; [the archive index](file-index.json) preserves input hashes and
deterministic compressed payloads. [External artifacts](external-artifacts.json)
retain the actual executables, full disassemblies and redundant oracle outputs
by path, length and SHA-256. They are not reconstructed replacements.

## Work removed

The three immutable bundled font assets have 195 maximal intervals of identical
coverage. Each three-byte little-endian record contains a 21-bit inclusive end
and three font-presence bits; starts follow implicitly from the preceding end.
The complete certificate is **585 bytes**. Primary coverage wins; otherwise all
applicable fallback bits are retained. The terminal record reaches U+10FFFF.
Lookup uses safe `as_chunks::<3>()` and `partition_point`; there is no asserted
fixed number of comparisons. Custom primary fonts retain their parsed cmap and
existing missing-glyph behavior. This removes the two fallback cmap headers
from the planner; the inline optional primary cmap remains.

The certificate proves printable ASCII and CR/LF coverage. One Fearless
SIMD/Fallback kernel classifies sixteen input bytes at a time; only controls and
non-ASCII leading bytes become ordered validation events. UTF-8 continuation
bytes cannot create duplicate events. A padded local tail and safe string
slices preserve boundaries. The ordinary planner loop retains error order,
ignorable handling and fallback policy. Custom fonts use the same iterator
interface over ordinary characters. There is no unsafe code, new allocation,
dependency, text rewrite or retained input copy in this change.

Regenerate the certificate from the actual font assets, from `reactivity`:

```sh
cargo run -p gpui_canvas --example coverage_table -- crates/canvas/assets/font-coverage.bin
```

The generator is a development example, not runtime code or a build script.
Updating a bundled font requires regenerating the certificate and passing its
exhaustive test; no unchecked external table is accepted.

## Correctness and controls

On genuine rustc 1.101.0-nightly, the selected source passes **188 tests** across
40 harnesses, with three ignored, under both ordinary and no-default-feature
Canvas builds. Strict all-target lint passes in both configurations using the
tracked repository Clippy policy. All 2,215 present compiler/source inputs match
before and after each gate. Apple ARM and Windows MSVC library source checks
pass; these are cross-compilation checks, not native execution.

Tests compare certificate lookup with the exact production font parser for
every Unicode scalar. Classifier tests cover every ASCII value and position,
lengths through 65 bytes, every Unicode scalar straddling a sixteen-byte
boundary, mixed scripts, event order and first-error behavior. They exercise
Fallback, baseline SIMD and available native SIMD implementations.

The existing public text fixture produces byte-identical layout, shaping,
selection and error output for **1,120 cases / 2,240 result records**:
285,940,280 bytes with SHA-256
`5f17488c73478c4d7271d39f783a8e15cb72c60a8e32ee18a72bf444923f7c39`.
Its executable and source/dependency identities are guarded across execution.
This oracle does not establish GPU performance or all GPU pixels.

Two deliberately broken copies are retained. Flipping one primary-coverage
bit fails the exhaustive Unicode test; changing the SIMD continuation predicate
fails the Unicode-boundary test. The certificate control compiles the unchanged
production decoder with a local certificate include and the exact production
fonts. It is a focused standalone control, not public-library execution. Initial
direct compiler attempts using only thin-RLIB metadata or only an rmeta failed;
the successful invocation supplies both rmeta and rlib explicitly. Initial
strict checks also exposed two real test lints; their repairs and the original
diagnostics are preserved.

## Exact costs and rejected boundaries

The public fixture was rebuilt at the same physical path with the same genuine
compiler, dependencies and flags for each formulation. Original frozen ELFs,
all section bills, symbols, disassembly and unwind records remain indexed.

| Matched selected artifact | Change from baseline |
| --- | ---: |
| Whole `.text` | −1,632 B |
| Whole `.rodata`, including the certificate | +832 B |
| All allocated sections, including padding | +4 B |
| Shaping function code | 15,119 → 13,544 B |
| Shaping maximum observed RSP CFA offset | 4,656 → 3,056 B |
| New event-iterator `next` | 508 B code, 80 B maximum observed RSP CFA |
| Shipping core, excluding tests/comments/examples | 31,232 → 31,321 lines |

The first callback formulation reduced whole executable code by 960 bytes but
grew the shaping frame to 4,800 bytes and added an outlined callback; it was
rejected. Its iterator successor reduced whole code by 1,824 bytes but grew the
shaping frame to 4,848 bytes. Composing that iterator with the certificate gives
the selected result above. The extra iterator boundary is charged separately;
static frame records are not a dynamic stack-peak measurement.

This slice makes no timing, RSS, measured heap delta or framework-superiority
claim. It does not remove all font parsing, shaping, outline decoding or
transient hostile-font budgets. The separate packed-glyph owner, cached glyph
count and single-outline raster prototypes are not included in this adoption.
