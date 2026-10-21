# Pinned Parley cluster and run-boundary repairs

Upstream Parley0.11.1 from crates.io, source commit
`eea3503dd6cf17130cbb07348e0ff2c918300e94` (`parley` directory).
Archive SHA-256:
`22d2ff88bd3f7d68d1d9b09c7e6209f9a8e8c05088295140a2bcf2e9b17038c5`.
The Apache2.0/MIT licenses and original/normalized manifests are included.
No unsafe code or new dependency is added by this patch.

One valid grapheme `a` followed by512 combining acute accents exposes three
connected limitations in the released crate:

- `shape::fill_cluster_in_place`, `CharCluster`, `Form`, and `Mapper` store the
  contributing-character count in `u8`. It overflows in debug and wraps in
  release. Those counts and the local mapped count now use `usize`, matching
  the owned character slice's length. Normalization's separate `Form.len`
  remains `u8`: that storage is statically a two-character array.
- Mapper's32-entry scratch array silently truncates iteration via `zip`. Keep
  the inline32-entry fast case; allocate exactly the character count for longer
  clusters. Both normalized forms contain at most two characters and fit the
  inline scratch. Coverage scoring and glyph-ID writes now visit the whole
  cluster, including a missing final character.
- `ClusterData.glyph_len` truncates the shaped count to `u8`;255 also collides
  with its inline-single-glyph marker. Store the existing `u32` count directly,
  and use `u32::MAX` for the inline marker in both readers. The source count
  already uses `u32` glyph offsets. Canvas admits at most 32768 source bytes and
  32768 retained output glyphs. HarfRust's private limit is
  `max(input_scalars × 256, 65536)` per buffer (at most 8,388,608
  entries at Canvas’s source cap), below the new reserved cluster marker.
  Multiple runs can retain expansion before Canvas checks the paragraph’s final
  output count. This is not a whole-layout scratch/heap budget; hostile-font
  transient-memory admission remains a separate gap, not a 32768-glyph bound.
  This patch does not claim to remove every upstream whole-document `u32` size limit.

Other narrow fields were audited: `ClusterData.text_len` is the UTF-8 length of
one scalar (at most4), not the entire grapheme; `text_offset:u16` is relative to
its shaped source run. Canvas's entire source-byte cap is32768, so this offset
cannot truncate. Source scalar indices and glyph offsets already use `u32`.
No new Unicode-specific source rejection is introduced.

The complete public glyph/byte/position regression is
`crates/canvas/tests/unicode.rs`, run in both debug and release. It compares
Parley/HarfRust output to independently shaped Rustybuzz output, including the
512-accent grapheme, and checks both original-byte caret endpoints.
`analysis/cluster.rs` also tests counts1,2,31,32,33,254,255,256,513, including a
missing character past the old scratch/count boundaries.

To run that private mapper regression:

```sh
python3 vendor/parley/check-clusters.py
```

The published archive omits `parley_dev`, which upstream's separate test module
imports. This helper suppresses that module in a temporary copy only; it does
not alter production source or the local regression. Its dependencies must be
cached for the helper's explicit `--offline` run. The new public Canvas tests
run through the normal workspace without that packaging workaround.

## Run-relative cluster boundaries

A mixed Latin ZWJ / Arabic combining / bidi-isolate fixture wrapped at20px
produced a line ending at byte2 inside the initial three-byte ZWJ. The source
clusters themselves were correct; the line breaker consumed a cluster from the
next font/bidi run. `Run::get` now bounds indices to the selected run/line
fragment before accessing the global cluster array. The ligature-continuation
loop in `break_next_line_or_box` now subtracts that run’s global start before
calling the run-relative getter. All other getter callers already use relative
indices. This changes no glyph shaping or source representation.

The public regression checks three minimized/mixed sources at widths1/10/20/80,
UTF-8 ranges, both affinities at every grapheme boundary, and equality of the
complete shaped `(source byte, glyph ID)` multiset against unwrapped output.
A deterministic100-case mixed-script/paragraph/isolate test also compares plain
and interactive lowering and checks every original-byte grapheme destination.

Ligature flags are assigned in visual order. The line breaker walks logical
order, so RTL groups must consume components followed by the glyph-bearing
start, rather than LTR start followed by components. The same regression at
width1 exposed a split Arabic base/mark and changed source clusters. The loop
now consumes the complete group in either direction, and the RTL boundary test
uses logical continuation semantics. The conservation check applies to these
specific atomic-cluster fixtures in this planner; it is not a universal claim
that all fonts or line-shaping algorithms preserve glyph IDs after wrapping.

## Optional word analysis, preserving line and grapheme behavior

The new `word-boundaries` feature is enabled by default. `accesskit` also enables
it. The normal upstream default therefore retains its word navigation, editor,
selection and word-span behavior. Disabling it removes the word-boundary
analysis and the public word-navigation/editor/selection APIs that require that
analysis; those APIs do not remain available with silently incorrect answers.
Line segmentation still uses the original complex-script dictionary constructor
when `complex-scripts` is enabled. Bidi, normalization, grapheme analysis,
shaping, line breaks and visual cursor geometry are unchanged.

Canvas opts out because it exposes no word-navigation or word-span API. Exact
output comparison against the word-enabled build covers 324 layouts including
all glyph/slot/source/position bits, line/run fields and every byte/affinity
caret result. `Boundary::Word` is consumed only by the gated word APIs; shaping
and line breaking do not treat it as a line boundary. The CJK *word* dictionary
is absent from the linked rendering-only profile. All four SA *line*
dictionaries remain present; disabling `complex-scripts` was rejected because
that would change line breaking for supported caller-supplied fonts.

## Scoped bulk cursor geometry

`CursorGeometry` borrows one immutable layout and constructs a transient index:
16 bytes per shaped cluster and four bytes per document byte. It records visual
prefixes once with exactly the original `visual_offset` f32 operation order,
and maps each covered source byte to its original cluster path. Duplicate,
out-of-range or reserved-domain indices fail construction. No persistent field
is added to Layout, Run, Cluster or Cursor. Geometry and affinity decisions use
the existing Cursor policy; only source/prefix lookup changes. The ordinary
Cursor methods remain the direct reference path.

Canvas builds this index only for an explicitly requested interaction map with
more than eight grapheme destinations. At most eight direct queries perform a
fixed bounded number of original scans, avoiding an index for a single huge
combining grapheme. Both construction paths are linear in admitted source size.
The map and index are not installed on ordinary labels or GPUI inputs.

The independent direct-Cursor oracle checks every byte (including multibyte
interiors, endpoints and out-of-range offsets), both affinities and all four
geometry f64 bits across empty layouts, CRLF, hard/soft line endings, inline
boxes, mixed bidi/RTL ligatures, long combining sequences and 1000 ASCII bytes.
The old 32 KiB bulk ASCII construction took about 2.25 seconds in an absolute
diagnostic; the indexed version took about 19 milliseconds including shaping.
This is a cold bulk operation with its full transient allocation charged, not
a claim of constant-time shaping, a one-caret-query win or live editor latency.
