# Scoped coverage-table cache

This follow-up compares against Unicode commit `af0fdb837a`. It changes only
the scoped coverage check: parse the primary `ttf_parser::Face` once, copy its
borrowed cmap descriptor, then discard the full face. The descriptor borrows
the external `FontFace` already borrowed by `TextShaper`. The two fallback cmap
descriptors are initialized together on first actual primary coverage miss and
borrow immutable static font bytes. No font lease, heap container, shared cache
or retained layout field is added. All descriptors disappear with the scoped
planner.

Lookup preserves `Face::glyph_index`'s Unicode filter, subtable order and first
`Some` result. The outer coverage check still rejects glyph zero. This matters
for format 13: it can return `Some(GlyphId(0))`, stopping lookup before a later
Unicode subtable with a nonzero mapping. Skipping that zero would change the
existing admission behavior.

The exhaustive independent oracle compares the private cached lookup to the
unchanged dependency `Face::glyph_index` for every Unicode scalar in six
fixtures: all three bundled fonts, a font without cmap, competing custom
Unicode/non-Unicode subtables, and the format-13 zero-priority case. These are
6,672,384 exact comparisons, including noncharacters and supplementary planes;
surrogate code points are not Rust Unicode scalars. The custom fixtures change
only the cmap directory entry/data in a copied font and create no GPUI font
IDs, avoiding interference with bundled-font lifetime/concurrency tests.

The cache does not change shaping, fallback selection, font ownership, glyph
geometry or resource admission. In particular, it does not fix the documented
HarfRust hostile-font transient-memory gap. Rendering still uses the same
canonical glyph and immutable font-set representation.

## Storage and validation

On the measured x86-64 target, rustc's type-layout output reports the scoped
planner growing from 2240 to 2344 bytes. Each `Cmap` is 32 bytes; the primary
view plus the optional pair of fallback views adds 104 bytes to the existing
planner Box, without a new allocation. `TextShaper` remains 16 bytes and
`TextLayout` remains 56 bytes. The full dependency `Face` is 2776 bytes with
this feature set; none is retained by this cache. These sizes are recorded in
`cached-cmap-types.csv`, not assumed portable across architectures/features.

Type inspection used `RUSTC_BOOTSTRAP=1 cargo rustc --release -p gpui_canvas
--lib -- -Zprint-type-sizes`; the candidate inspection additionally used
`-Ccodegen-units=1` to force fresh type output. The benchmark executables were
saved before those type-only builds and use ordinary Cargo release codegen.
Their exact hashes/file sizes are in `cached-cmap-binaries.csv`.

The complete structured oracle is equal across all 1,979,265 bytes for 324
layouts, including glyph/font/source/position bits, run and line fields, and
every byte/affinity caret result. Both outputs have SHA-256
`9e01faee6e4863822c24352e71d94b5ed33a856e853e83c2250cf4c2449cf15f`.
Final parallel Canvas tests, debug and release exhaustive lookup tests, the
two public Unicode owner/recovery tests and strict Canvas+GPUI all-target
Clippy pass. Temporary local logs:

- `/tmp/gpui-cmap-canvas.log`
- `/tmp/gpui-cmap-release.log`
- `/tmp/gpui-cmap-owner.log`
- `/tmp/gpui-cmap-clippy.log`
- `/tmp/gpui-cmap-types-baseline.log`
- `/tmp/gpui-cmap-types-candidate.log`

## Paired whole-operation observations

`cached-cmap.csv` retains all 396 rows from eleven alternating fresh-process
pairs, pinned to CPU 2 on the same Ryzen 7 3700X as the Unicode evidence. The
baseline and candidate use identical existing measurement examples and one
scoped shaper per pass. Before timing, `measure-text.py` compares every Canvas
output byte plus actual owner initial/edited output bytes for 1 and 1000
labels. Those complete comparisons passed. The common-label fixture uses its
four existing Latin strings; this is not a multilingual performance claim.

Median absolute observations:

| Operation | Baseline | Cached cmap | Observed change |
| --- | ---: | ---: | ---: |
| One label, cold pass | 198.55 µs | 189.87 µs | −4.4% |
| One label, warm pass | 9.37 µs | 8.74 µs | −6.7% |
| 1000 labels, cold pass | 9.200 ms | 8.839 ms | −3.9% |
| 1000 labels, warm pass | 8.928 ms | 8.499 ms | −4.8% |
| Owner, 1000 labels, mount | 13.063 ms | 12.368 ms | −5.3% |
| Owner, 1000 labels, edit | 12.209 ms | 11.622 ms | −4.8% |
| Owner, one label, edit | 87.04 µs | 87.92 µs | +1.0% |
| Owner, 1000 labels, render | 4.157 ms | 4.157 ms | unchanged |

All eleven pairs improved the 1000-label warm, owner mount and owner edit
operations, with median within-pair changes of −4.96%, −5.39% and −4.63%.
No speedup is inferred for rendering, which uses no coverage lookup. Retained
requested bytes and allocation counts are identical throughout. Cold planner
construction adds exactly 104 peak requested bytes; a prewarmed planner is
outside the warm-phase allocation counter and still owns that extra storage
until its scope ends. No per-label memory is added.

The unchanged textless owner mount also varied systematically: 86.95→63.56 µs,
despite identical 5636 retained bytes/5796 peak bytes/34 allocations and no
planner construction. The linked executable/code-page/cold-path observation
therefore cannot be attributed to this cache. The one-label owner mount's
428.44→326.61 µs change is likewise not claimed as a coverage-cache benefit.
The small single-label edit loss remains visible above. These controls, the
raw rows and the per-binary pins are retained rather than turning every timing
movement into a causal speed claim. There is no new native floor/launch claim.

Reproduce from `reactivity`, building the same three examples in both source
trees and saving the ordinary-release executables before any type-only build:

```sh
cargo build --release -p gpui_canvas -p gpui --example text_shaping \
  --example text_oracle --example unicode_text_measure
python3 crates/canvas/measure-text.py \
  --baseline-canvas /tmp/gpui-cmap-baseline-binaries/text_shaping \
  --candidate-canvas /tmp/gpui-cmap-candidate-binaries/text_shaping \
  --baseline-owner /tmp/gpui-cmap-baseline-binaries/unicode_text_measure \
  --candidate-owner /tmp/gpui-cmap-candidate-binaries/unicode_text_measure \
  --rounds 11 --output cached-cmap.csv
cargo test -p gpui_canvas --features parallel
cargo test --release -p gpui_canvas --lib cached_cmaps_match_face
cargo test -p gpui --test unicode_text
cargo clippy -p gpui_canvas -p gpui --all-targets -- -D warnings
```

The root verifier and peer builds/captures were paused during the 4.2-second
capture. Requested-byte accounting has the same exclusions as the original
Unicode fixture; it is not allocator usable size, stack size or RSS.
