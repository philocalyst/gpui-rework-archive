Full static default-instance specialization, qualified independently from Swash-removal work.

Base: `2fefe2d26692e7839231318a71dc4055a694f456`. Implementation: `486e5462909e9825913d00e506a910fc7bc3c3bd`.
Only the immutable primary bundled face changes. The full original variable asset,
OFL attribution and caller-font/default-instance tests are preserved. The normal
library embeds the derived font only; source packages retain both assets.

Generation and license provenance are in `../../assets/README.md` and
`../../assets/generate-default-font.py`. The verified fontTools 4.67.0 wheel
reproduced the exact 646,160-byte output and SHA-256. No runtime transformation,
new production dependency, allocator or unsafe code was introduced.

Qualification used genuine `rustc 1.101.0-nightly (7189d39d9 2026-10-22)`,
`source /tmp/gpui-native-env.sh`, then `source /tmp/gpui-nightly-env.sh`, jobs 1,
separate owned target directories and the exact root `CLIPPY_CONF_DIR` policy.
`RUSTC_BOOTSTRAP`, `RUSTFLAGS` and encoded Rust flags were unset. Builds and runs
had separate finite watchdogs; exact limits, hashes and all skipped cells are in
`qualification.json`.

- All four cmap subtables are byte-identical. The independent ttf-parser oracle
  compares exact glyph IDs for every Unicode scalar and all 4,515 glyph names
  and raw bounding boxes.
- All 4,515 Skrifa outlines have identical command tags and exact f32 coordinate
  bits at physical sizes 1, 7.25, 16, 20.5, 63.75 and 256. Advances and left side
  bearings match at every size; font-wide metrics match. Identical commands also
  preserve the bounds traversal used by Canvas.
- All 27,090 Swash glyph/size masks have identical placement and coverage.
  Independent Rustybuzz checks glyph IDs, clusters, unsafe-break flags,
  advances and offsets for ligature/kerning, scripts, marks and controls.
- The copied public fixture produced exactly 285,940,280 bytes in both builds,
  SHA-256 `5f17488c73478c4d7271d39f783a8e15cb72c60a8e32ee18a72bf444923f7c39`,
  including geometry, wraps, bidi, carets, hit tests, selections and both public
  shaping modes. Baseline and candidate used the same physical source paths,
  locked dependencies and compiler flags.
- 432 additional bundled scenes, including mixed fallback scripts, heavy marks,
  ligatures, wraps and interactive layouts, produced byte-identical SDR and
  linear HDR sRGB/P3 pixels: 138,240,000 bytes, SHA-256
  `b4ab85bcc1397d4fc6c4e7ae49822dd82ec2aef6a543b1ffe01733b1d3a1b355`.
- Regenerating coverage from the derived font and unchanged fallbacks produces
  the identical 195-record/585-byte certificate. The exhaustive certificate
  test passed against the actual bundled assets.
- Every source GPOS/GDEF Device reference is a VariationIndex (`0x8000`):
  20,890 GPOS references and 7 GDEF references. There are no ppem Device
  corrections or FeatureVariations. The candidate has no Device references.
  Raw table hashes and retained naming/license records are in `font-audit.json`.
  FontTools sets overlap flags in 4,480 glyphs; coordinates, contours and all
  other point flags are unchanged. Independent outlines and masks establish
  the observable equivalence at the tested sizes.

The ordinary uninstrumented release `cpu` example changed as follows:

| Observable | Original | Derived | Delta |
| --- | ---: | ---: | ---: |
| ELF file bytes | 10,539,016 | 9,136,064 | -1,402,952 |
| Allocated section bytes, including padding/BSS | 9,725,132 | 8,320,212 | -1,404,920 |
| `.rodata` bytes | 6,487,856 | 5,084,920 | -1,402,936 |
| `.text` bytes | 2,620,311 | 2,620,311 | 0 |

Exact payload census finds the original primary once in baseline and zero times
in candidate; the derived primary occurs once in candidate. Both fallback fonts
remain single copies. Runtime dependency trees are identical. Compiler work counts
and target reuse are recorded separately, without a compile-time speed claim.

A separate allocation harness uses the existing allocation-counter development
dependency. In its one-service cold shape cohort, requested allocations decrease
408 to 405, total bytes 299,580 to 298,140 and peak bytes 175,048 to 172,296.
Retained layout bytes stay 824; TextLayout/Glyph/FontFace headers stay 56/16/8.
Cohorts 2/8 scale the shape allocation reduction; prepare allocations, mask
payload and output digests are unchanged. Those cohorts run sequentially in each
process; the later init net counts include releasing the prior Weak control
block. This does not establish RSS, startup or latency improvements.

Full all-target/all-feature gates passed: 203 tests across 42 binaries, with four
existing ignored measurement/exhaustive cells; two doctests; strict Clippy with
`-D warnings`; and formatting. No requested cell timed out. Initial harness
failures are retained: Rustybuzz structs require field comparisons, and comparing
a custom primary against a bundled fallback set is an invalid equivalence test.
The corrected primary-only pixel oracle and separate matched bundled builds
cover those contracts without changing product behavior or oracle tolerances.

Negative control: moving only glyph A's first x coordinate from 545 to 546 caused
the exact command oracle to fail at gid 36, size 16, exit 101. Restoring the exact
candidate asset and rerunning all four differential tests passed. Source guards
matched all 11,068 materialized files before/after qualification, including root
`clippy.toml`; no source writes occurred while compilers/tests read the tree.

Raw logs, ELF files, sourceguard manifest, both full oracle outputs and the copied
fixture remain under `/tmp/gpui-default-font-sol-evidence`,
`/tmp/gpui-default-font-oracle-sol` and the log paths in `qualification.json`.
These are finite local observations. OpenType Sanitizer was unavailable; the
independent parser/runtime gates above provide validation. No RSS, startup,
latency, platform-wide pixel or future axis-selection claim is made.
