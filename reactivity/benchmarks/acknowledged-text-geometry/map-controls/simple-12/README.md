# Source-derived 12-byte caret-stop control

Production source 8dab33c15bbe3ea20e7e1bde3a22eb0daf10eb4a starts from the separate
24 B capacity trim ca1b0b6f42. It stores byte:u32, x:f32 and the original affinity
mask (12 B including padding), rather than a 24 B byte/Rect/mask record. Existing
source-owned line ranges reconstruct exact caret top/height. Equal producer
rectangles retain upstream geometry even for a requested downstream alias.
The one-pixel width preserves the producer's f32 addition before f64 subtraction;
large x can produce zero width. No quantization, byte/line narrowing, retained
index, new geometry tree or Runtime/Node/Presented/header growth is introduced.
The producer still validates every original Rect and uses its original merging
policy before retaining x. Layout56, Details80, Node40, Presented80, TextSite80,
Part16, Prepared40 and Runtime1824 remain unchanged on the measured64bit build.

Before mutation, source8c6e8141f7a2e33430109b4de109f56d71933dd5 pins a direct
Parley cursor-geometry bit oracle on the24B map. It computes original widened
coordinates independently, including original upstream signed-zero merge bits.
The exact source line comes from Parley cluster paths, not caret y. Actual
wrapped zero/small line-height, empty/consecutive/trailing CRLF/U+2028, bidi and
both-affinity cases pass before and after compression. Finite arithmetic cases
cover signed zero, subnormals, adjacent floats, cancellation and extreme
magnitudes. The precompression executable is frozen separately. The release
oracle also passes4/4. This is not Consumer↔P agreement using one shared decoder.

At complete test pin bc0e6b989524529c2cb681054cc479a15936e5a7, full Canvas+parallel
passes192 cases/4 ignored, bounded ordinary GPUI library and11 public suites
pass194 cases/5 ignored, and strict default-feature all-target Canvas+GPUI
Clippy passes. These cover query, geometry, selection, compound selection,
Unicode, immutable text, semantics, presentation, DPI, pointer and text cache.
No new native-protocol/foreign-runtime qualification is claimed for this memory
control; A's source-pinned campaign remains separate. The shipping core is
29,126 code lines including13 build lines (+16 versus the consuming-break base).
Archived support/assembly code is separately counted by the full inventory.

| ASCII32KiB,33,513stops | 24B trimmed | 12B trimmed |
|---|---:|---:|
| Geometry capacity bytes | 853,464 | 451,308 |
| Scoped retained bytes | 1,377,888 | 975,732 |
| Scoped requested bytes | 8,859,024 | 6,884,052 |
| Scoped peak live bytes | 7,001,412 | 5,821,764 |
| First-C owner retained bytes | 1,493,924 | 1,091,768 |
| First-C owner requested bytes | 27,022,268 | 23,474,480 |
| First-C owner peak extra bytes | 15,569,616 | 13,603,536 |
| Old-P/new-C additional retained bytes | 885,192 | 482,136 |

The initial24trim/12trim memory pair used identical repository-root rustflags
(symbol-mangling-version=v0, tokio_unstable). The earlier producer baseline was
invoked from/root without that repository configuration. Raw artifacts retain
their exact identities; a separate explicit-cleared-flags recapture qualifies
the combined memory ledger. The explicit empty-rustflags recapture now reproduces
every numerical field exactly; its own frozen binaries/fingerprints are included. Do not silently treat different command directories
as equivalent build provenance. No intrinsic-map suppression is included here.

The query cost is a real loss. Matched release controls use identical public
selection_queries example, package lock, features, toolchain and cleared
repository config (both invoked from/root). Seven alternating pairs on CPU0,
with source/binary guards before each process, produce identical signatures.
The timed body excludes shaping and first-query warmup. Actual192/194 correctness
gates are independent of these short matched microbenchmarks. For27,000bytes/
5,401lines, median nanoseconds/query are:

| Query | 24B trimmed | 12B trimmed | Ratio |
|---|---:|---:|---:|
| Hit first | 73.4 | 108.7 | 1.48 |
| Hit last | 127.4 | 154.2 | 1.21 |
| Previous visual | 276.2 | 427.9 | 1.55 |
| Local selection | 160.2 | 255.5 | 1.59 |
| Whole selection | 967,422 | 1,291,936 | 1.34 |

The15byte/4line fixture also slows22–64%. These are observed local query costs,
not a whole-app throughput prediction. All raw140records, complete selected
query/driver bodies, linked section sizes and guards are retained. The selected
body sum grows7,219→7,717B and linked.text1,174,408→1,174,680B. Driver wrappers
alone stay27/27/52B; the new267B stop_bounds and681B interval closure are included,
so moving work out of larger callers is not presented as elimination.

Initial source12 still calls caret_bounds for membership-only caret_line and
validates_selection. Its possible bounds panic keeps geometry reconstruction
live even where only membership is needed. A later private checked-stop seam can
eliminate that work; this source/raw loss remains an immutable control. The
necessary caret geometry query still adds a source-line search, and intervals
add one such search per start. Do not call this a zero-cost compression winner.

The actual pre-encoding census shows only group1(mask3) and group2(mask1,mask2)
on the admitted ASCII, ligature, paragraph, bidi/isolate, combining/ZWJ and
long-grapheme corpus; all exclusive counts are zero. A first census correctly
rejected public width0 (InvalidWidth), and bundled fonts reject the emoji woman
(MissingGlyph). Both failed fixture attempts are preserved. The final census
uses admitted1px widths, reports emoji rejection explicitly, and exercises
Latin/Arabic ZWJ text. It does not claim a shaped emoji map or universal affinity
shape proof; the8B proposal must keep a whole-map general fallback.
