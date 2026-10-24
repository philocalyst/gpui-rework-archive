# Unicode paragraphs, one retained glyph layout

Canvas now uses scoped Parley/Parley Engine 0.12.0 / HarfRust 0.12.0 planning with
Fontique 0.12.0 and ICU4X 2.3.0 analysis/data. Direct outline admission uses
Skrifa 0.49.0. [The migration ledger](evidence/parley-012.md) records dependency
constraints and the rebased repairs. One planner session is borrowed
for the complete runtime text pass. Fontique has `shared:false` and
`system_fonts:false`; there is no system-font scan or persistent planner.
Rustybuzz 0.20.1 is a dev-only independent shaping oracle. The production parser
admission uses pinned ttf-parser 0.25.1 directly.

Paragraph splitting preserves original UTF-8 offsets. CRLF is one separator;
CR, LF, NEL and paragraph separator start a new bidi paragraph, including empty
and trailing paragraphs. Line separator stays inside its bidi paragraph.
Parley performs script/bidi analysis, shaping and Unicode line breaking within
each paragraph. An atomic shaping cluster can overflow the supplied width.
The original source is neither rewritten nor retained in a second document.

The transient Parley layout is lowered immediately into the existing canonical
glyph positions. No Parley layout or second glyph/run authority survives.
`Glyph` remains 16 bytes: a private typed one-byte font slot and one-byte simple
tail length use its former padding. `TextLayout` grows from 48 to 56 bytes on
x86_64: an immutable font-set lease replaces the old numeric font identity, and
one optional boxed-details pointer is added. Simple primary-font, single-line
LTR labels need no details allocation. Reordering, multiple lines/runs, a long
tail or nonempty zero-glyph source takes the cold details path. Long graphemes
are not rejected to fit the byte-sized fast representation.

The immutable font set contains one primary and at most two bundled fallback
leases. Subsets are shared within the pass; old layouts retain their exact
fonts when the planner is dropped or later text chooses another subset.
Fallback is based on actual cmap coverage, including inherited marks, not a
script whitelist. Missing coverage returns `MissingGlyph`; it never silently
publishes glyph zero. Custom primary fonts currently have no automatic fallback.
The bundled assets cover Latin, Greek, Cyrillic, Devanagari, Arabic and Hebrew;
this is not a claim of coverage for every Unicode scalar. Fonts and OFL
provenance are in [assets](assets/README.md), [Arabic](assets/arabic/README.md)
and [Hebrew](assets/hebrew/README.md).

Bundled coverage now uses a checked-in 585-byte certificate: 195 maximal
intervals encode the exact three font-presence bits. An exhaustive Unicode test
compares it with the production parser against the immutable assets. Printable
ASCII and CR/LF are certified; a shared Fearless SIMD/Fallback classifier emits
only controls and non-ASCII leading bytes for ordered validation. Custom fonts
retain ordinary cmap validation through the same iterator boundary. The
[integration ledger](../../evidence/bundled-coverage/README.md) records exact
oracles, fault controls, code/section/frame costs and the rejected callback
formulation. Regenerate the table with the `coverage_table` example when
changing a bundled font. This does not change fallback selection or errors.

Painting resolves the private slot against that layout's immutable leases.
Raster keys include exact face identity, glyph and physical size, so equal IDs
from different faces cannot alias. Cache eviction and later font-set selection
do not invalidate old scene masks or layouts. The raster hash key grows from
the old eight-byte `(glyph,size)` pair to the existing sixteen-byte `GlyphKey`;
its measured preparation cost is included below. No font Arc is cloned per
glyph placement.

## Typed interaction foundation and limits

`TextOffset` denotes an original UTF-8 byte, distinct from glyph indices or
UTF-16 units. Borrowed `GlyphRun` and `TextLine` expose original source ranges,
direction, font lease and geometry. `shape_interactive` additionally freezes
real planner cursor geometry at ICU grapheme boundaries for both upstream and
downstream affinity. Equal destinations are stored once. Ordinary shaping has
no caret map. A byte inside UTF-8, a combining grapheme or CRLF has no legal
destination; the API returns `None` rather than snapping it. `TextSelection`
validates endpoints in that layout only; it is not a document revision token.

This does not implement native range selection, selection painting, IME/preedit,
language/variation authoring, discretionary-hyphen insertion, vertical writing,
color glyphs or OS font discovery. Native `Key::Text` still excludes controls;
CRLF can enter through the existing typed source/SetValue path. Native scalar
backspace remains the existing behavior, not a new grapheme-aware editor.
Tabs and unsupported C0 controls remain explicit errors. Missing CJK/emoji
coverage is a font-policy error, not an artificial script rejection.

The existing admission caps remain: 32 KiB source bytes, 32K retained output
glyphs, 16 MiB supplied font input, author font size up to 512 and physical
raster size up to 4096. Output count is checked only after a paragraph's planner
build. Preflight sums existing raw line-scoped cluster lengths without grouping
positioned runs or adding a count field; the [count ledger](../../evidence/raw-glyph-count/README.md)
retains exact output/error controls and code/frame costs. HarfRust's private
per-buffer limit is `max(input_scalars × 256, 65536)`;
at this source cap one such buffer can reach 8,388,608 entries. This is not a
whole-layout scratch or heap budget: multiple shaped runs can retain their
expansion before Canvas checks the final count. Hostile-font transient-memory
admission remains an explicit gap requiring a configurable dependency budget
or earlier bounded/fallible planning. No 32K-scratch safety claim is made.
The [pinned minimal upstream patch](../../vendor/parley/GPUI-PATCHES.md) repairs
overflow/truncation for long graphemes, bounds run-relative cluster access and
keeps logical RTL ligature groups atomic during wrapping. Source range checks
remain enabled after lowering.

## Actual correctness gates

`tests/unicode.rs` checks explicit mixed-direction visual orders, mixed scripts,
isolates/overrides, all requested grapheme destinations, original CRLF bytes,
line-vs-paragraph separator direction, missing coverage, font-set lifetimes,
cache eviction and a 512-accent grapheme in debug and release. Independent
Rustybuzz output checks glyph IDs, exact source clusters and relative positions
for Latin/ligatures/Greek/Cyrillic/Devanagari/Arabic/Hebrew and the long grapheme.
A custom variable-font default-instance regression checks shaping and raster
use the same instance. Font metric totals may differ from the previous planner
by a few f32 ULPs; font-quality tests bound that explicitly while retaining exact
mask-dimension and independent mask-quality checks.

Three minimized wrapped ligature fixtures and 100 deterministic mixed-script,
paragraph, mark, ZWJ and isolate combinations validate source ranges, glyph
coverage and both byte affinities. The fixture-specific glyph conservation
oracle is not a universal contract that all fonts/line shapers preserve glyph
IDs after wrapping. Scoped CPU pools of 1/2/4 workers produce exact pixels.
All 20 actual Vulkan tests pass, including mixed Unicode fallback at fractional
raster density and reflected transforms, exact optimized/reference GPU pixels
and the existing bounded CPU/GPU rounding oracle.

Public GPUI tests edit the real String source/Input ports without rerunning the
owner view, retain the Input Target, compare every pixel with a freshly mounted
owner, and preserve old pixels after missing coverage before recovery. The
ignored native test drives the real X11 host keyboard route, waits for actual
presentation acknowledgement, then compares the complete fetched X11 surface
with the owner's CPU pixels. The private-bus AT-SPI test performs real
SetTextContents/GetText using Greek/Hebrew/Arabic, invokes a button and tests
reactivation. CRLF/non-BMP schema correctness does not imply missing font
coverage or native IME capability. No VoiceOver/UIA execution was added here.

```sh
cargo test -p gpui_canvas --features parallel
cargo test --release -p gpui_canvas --test unicode
cargo test -p gpui --tests --features x11
cargo test -p gpui_gpu --features vulkan-tests --test render
cargo clippy -p gpui -p gpui_canvas -p gpui_gpu --all-targets \
  --features gpui/x11,gpui/wayland,gpui_canvas/parallel,gpui_gpu/vulkan-tests -- -D warnings

# Real X11 display; no GPU initialization in this test.
cargo test -p gpui --features x11 --lib \
  native_unicode_keyboard_and_surface_match_complete_cpu_pixels -- --ignored --nocapture
# tools/test_atspi.sh also needs the AT-SPI bus launcher, as documented in GPUI.
cargo run --release -p gpui --features x11 --example unicode -- --cpu
```

Normal `x11`/`wayland`/desktop profiles retain native accessibility. The
`x11-minimal` native measurements below explicitly disable AT to isolate this
text change; they do not price the separate stock Linux AT threads/D-Bus costs.

## Paired common-label measurements

Baseline is source `146cd9912d`; candidate is the original Unicode integration. Both use the same
benchmark operations, label strings and rendering sizes, and borrow one parser
for the entire 1/1000-label pass. That measured Unicode coverage check parsed a
borrowed primary ttf-parser Face view per string. The subsequent
[cached-cmap integration](evidence/cached-cmap.md) retains only borrowed coverage
table descriptors in the scoped planner, with an exhaustive independent oracle
and separate paired measurements; its results are not added to these timings.
Release binaries were built with Rust 1.97.1 on
Linux x86_64, Ryzen 7 3700X. Eleven fresh-process pairs alternate order, pinned
to CPU2 after stopping other owned build/capture work. OS caches are warm;
there is no claim of a cold-cache or hard latency guarantee. Before capture,
the complete common-label baseline/candidate BGRX output bytes matched for
Canvas and both initial/edited owner frames at counts 1 and 1000.

[Raw stages](evidence/unicode-text.csv) include all allocation/latency rows,
including losses. Times below are medians of the 11 runs, not a portable speed
claim. Requested thread-local allocation counts exclude allocator rounding,
RSS, preallocated output/model/outer-layout Vec storage and other threads.
The cold planner phase begins after FontFace admission. Warm phases retain a
reused planner; their small additional scratch high-water is released on drop.

| Operation | Baseline | Unicode | Change |
| --- | ---: | ---: | ---: |
| One label, cold planner | 238.06 µs | 196.37 µs | −17.5% |
| One label, reused planner | 9.26 µs | 8.47 µs | −8.5% |
| 1000 labels, cold pass | 10.91 ms | 9.09 ms | −16.7% |
| 1000 labels, reused planner | 10.65 ms | 8.73 ms | −18.0% |
| 1000 labels, Canvas prepare | 1.312 ms | 1.373 ms | **+4.6%** |
| 1000-label recording owner mount | 14.79 ms | 12.85 ms | −13.1% |
| 1000-label owner edit | 13.91 ms | 11.91 ms | −14.4% |
| 1000-label owner CPU raster | 5.914 ms | 5.923 ms | +0.2% |

One-label cold planner peak drops 238,720→46,676 requested bytes (357→201
allocations), while its retained glyph/font-set increment grows 128→168 bytes.
The one 40-byte immutable FontSet allocation is shared by the pass. Warm single
label retains the same 128 glyph bytes, with 23→9 allocations.

The 1000-label owner mount retains 1,796,611→1,804,915 requested bytes (+8,304),
principally the eight-byte larger layout headers. Peak new requested bytes drop
2,113,235→1,931,987, allocations 27,192→14,803. Edit peak grows
472,155→480,155 bytes: that loss is retained. The owner describes and shapes all
1000 labels, while the 640×480 viewport paints only visible rows; this is an
unvirtualized owner fixture, not a 1000-label-on-screen benchmark. Canvas's
1000-placement fixture separately records its actual glyph/draw work.

Textless recording Canvas allocation is exactly zero in both versions. The
textless owner allocation ledger is identical (mount 5,636 retained / 5,796 peak
requested bytes, 34 allocations). Its microsecond time differences are noisy
and do not establish a textless speed change. No ASCII second planner was kept:
the one Unicode planner has measured common-label costs and avoids two semantic
paths.

Reproduce with identical example sources copied to the baseline worktree:

```sh
cargo build --release -p gpui_canvas --example text_shaping \
  -p gpui --example unicode_text_measure
python3 crates/canvas/measure-text.py \
  --baseline-canvas /path/to/baseline/text_shaping \
  --candidate-canvas /path/to/candidate/text_shaping \
  --baseline-owner /path/to/baseline/unicode_text_measure \
  --candidate-owner /path/to/candidate/unicode_text_measure \
  --rounds 11 --output text.csv
```

## Linked data and optional bulk geometry

Exact byte matching against the pinned generated ICU source attributes the
initial full-word build's 4,432,040-byte `.rodata` increase as follows:

| Added payload | Bytes |
| --- | ---: |
| ICU CJK word dictionary | 2,007,110 |
| ICU four complex-script line/word dictionaries | 1,773,076 |
| Arabic/Hebrew font arrays, initially duplicated across codegen units | 534,712 |
| Remaining tables, rules, normalization, strings/alignment/metadata | 117,142 |

There is no LSTM/`auto` feature and no system-font backend enabled. Both were
already excluded; calling all of this data "bidi tables" would be incorrect.
The [exact payload ledger](evidence/unicode-data-full-word.csv) records offsets,
instances and source hashes. `attribute-text-data.py` decodes the original Rust
byte literals and finds the complete bytes in the ELF; it does not infer size
from mangled names or assume every linked array is resident.

The following feature, payload and timing results are historical Parley 0.11.1
captures. Parley 0.12 removed the local `word-boundaries` feature; current
upstream word analysis remains enabled. These rows and feature commands do not
describe or measure the current 0.12 binary.

That earlier rendering profile omitted unused word-boundary analysis through a
new default-on vendor feature. Parley's normal defaults and its `accesskit`
feature retain word support. When disabled, its word-navigation/editor/selection
APIs are unavailable at compile time. Canvas exposes none of those APIs. Bidi,
normalization, line segmentation, shaping and visual/grapheme caret behavior
are preserved; the full-word and rendering-only binaries produced identical
1,979,265-byte structured oracle outputs across 324 layouts (actual full-byte
comparison). All four complex-script line dictionaries remain. Disabling those
or cooking a narrower script repertoire would change caller-font behavior and
was rejected. A custom runtime data provider or lossless compressed dictionary
would need a separate owned-data/lifetime and CPU/heap study; it is not a free
feature toggle.

Named immutable font arrays also remove the duplicate payloads, preserving
all font bytes exactly. [Final payload matches](evidence/unicode-data.csv) show
one copy per face, no CJK word dictionary and one copy of each of the four line
dictionaries. Native `.rodata` overhead falls to 2,130,600 bytes before any
later application-specific linking. The font byte counts are fixed by the
pinned assets and checked by Rust array types.

```sh
cargo run --release -p gpui_canvas --example text_oracle > /tmp/rendering.oracle
cargo run --release -p gpui_canvas --features parley/word-boundaries \
  --example text_oracle > /tmp/words.oracle
cmp /tmp/rendering.oracle /tmp/words.oracle
python3 crates/canvas/attribute-text-data.py /path/to/native/empty
```

Repeated direct upstream Cursor queries made the opt-in 32 KiB ASCII map take
about 2.25 seconds in a diagnostic. Bulk construction now borrows a transient
index: 16 bytes per cluster plus four bytes per source byte, released before
returning the canonical layout. Every byte/affinity result is bit-identical to
the direct Cursor oracle, including inline boxes, line ends and RTL ligatures.
At most eight destinations use a bounded number of direct scans, so one huge
combining grapheme avoids allocating a useless per-byte index. Both branches
are linear in source length; ordinary shaping does not count destinations or
construct an index. The retained optional stop Vec's capacity is charged in the
raw allocation ledger, not just its logical length.

The `text_interaction` example measures complete cold shaping plus requested
maps for ASCII, Hebrew, Arabic ligatures and combining sequences up to the
source limit, and checks both affinities at every legal grapheme boundary.
It is an absolute bulk-operation diagnostic, not a native editing benchmark:

```sh
cargo run --release -p gpui_canvas --example text_interaction -- 32768 ascii
# Also: rtl, ligature, combining. The reported byte length is actual UTF-8 size.
```

The [long-source ledger](evidence/unicode-carets.csv) retains five complete cold
shaping/map observations per sample, including allocation capacities. Each
process measures plain then interactive shaping with fresh parser sessions;
page/font data may be warmer in the second phase, so small timing improvements
are not attributed to adding caret work. Median absolute times and peak new
requested bytes are:

| Actual UTF-8 bytes / sample | Plain | With map | Map peak requested | Map retained requested |
| --- | ---: | ---: | ---: | ---: |
| 32,768 ASCII | 15.43 ms | 19.05 ms | 6,468,564 B | 2,097,464 B |
| 32,758 Hebrew | 22.77 ms | 23.54 ms | 6,160,080 B | 1,269,144 B |
| 32,767 Arabic ligatures | 33.97 ms | 33.10 ms | 7,885,768 B | 1,011,336 B |
| 32,767 combining sequence | 14.23 ms | 14.05 ms | 3,257,272 B | 262,536 B |

The combining sequence uses only its two legal grapheme endpoints and therefore
allocates no index. Its retained increment over plain shaping is 240 bytes.
The ASCII index alone costs 655,360 transient bytes; its complete peak above
also includes planner scratch, glyphs, details and the stop Vec's capacity.

## Actual native floor and first submission

[Final native rows](evidence/unicode-native.csv) are eleven alternating fresh
process pairs on the same isolated Xvfb display, CPU2, `--cpu --startup`, built
with `x11-minimal`. Each marker follows real native submission and exact P
acknowledgement. RSS/PSS/anonymous memory and page faults are read 100ms later.
The marker timer begins when the observer is attached, after model/window
construction; the historical column name `main_to_present_us` does not include
that earlier construction. Spawn-to-marker does include it. No process build,
GPU initialization, AT session, compositor memory or monitor scanout is counted
as an application success/performance result.

| Native example | Spawn→ack baseline / Unicode | PSS baseline / Unicode | Anonymous baseline / Unicode |
| --- | ---: | ---: | ---: |
| Empty | 30.885 / 30.956 ms | 7,364 / 7,558 KiB | 1,520 / 1,496 KiB |
| Workbench | 33.876 / 33.317 ms | 10,298 / 10,734 KiB | 1,812 / 1,624 KiB |
| Library, 250K app items | 75.441 / 57.267 ms | 14,920 / 15,348 KiB | 5,896 / 5,740 KiB |

All samples have one application thread and zero major faults. Native empty
PSS increases 194 KiB in the final linked build despite zero text allocations;
it is not called free. The earlier full-word/anonymous-font capture observed
only a 12 KiB empty PSS difference, demonstrating that linked-page layout and
shared-page accounting matter. Both [initial rows](evidence/unicode-full-word-native.csv)
and [initial shaping rows](evidence/unicode-full-word-text.csv) are retained;
they are not substituted for the final floor. Memory snapshots are observations
in this environment, not exact attribution of every RSS page to one dependency.
The Library's roughly four-megabyte catalogue metadata is app-owned on both
sides and remains charged.

```sh
cargo build --release -p gpui --features x11-minimal \
  --example empty --example workbench --example library
python3 crates/canvas/measure-text-native.py \
  --baseline /path/to/baseline/examples --candidate /path/to/candidate/examples \
  --rounds 11 --output native.csv
```

`library --startup` installs the same real feedback marker as other examples;
normal interactive runs install no observer. This instrumentation is identical
on both sides. [Binary pins and ELF sections](evidence/unicode-binaries.csv)
separate `.text`, `.rodata`, writable sections and whole file size; GNU `size`'s
combined "text" column must not be mistaken for instruction bytes alone.

Font ownership also has a small fixed cost: the explicit bundled-fallback policy
adds eight bytes of alignment to each FontData header (48 instead of 40 bytes;
64 instead of 56 requested bytes including the Arc counters). There are at most
three bundled face records, and the weak registries can retain their small Arc
allocations after the final strong lease drops. The 1000-label mount ledger
includes this eight-byte primary-face increase, its shared 40-byte FontSet,
the 8000 added layout-header bytes and the larger raster-key table.
