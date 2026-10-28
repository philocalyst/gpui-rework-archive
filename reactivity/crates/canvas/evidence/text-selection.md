# Borrowed text selection geometry

Spike source: `76fd0b4662`, based on `05af5841e1`. Integration parent:
`f11425bac2`. The integration additionally corrects distant hits as described
below; original spike counts/gates remain labelled separately.

This source slice adds ordinary `TextLayout::position_at`, `selection_rects`,
`previous_visual`, and `next_visual` queries. They consume the existing optional
interactive map. Shaping without interaction keeps the same representation.
No editor state, per-node field, cached selection rectangle, or shaped tree is
introduced. These queries are the common geometry surface for native input,
accessibility, and callers' ordinary tests; they do not depend on a testing API.

Each pair of adjacent distinct legal byte offsets owns a source interval.
The downstream start and upstream end give that interval's visual endpoints.
Source ownership survives bidi reordering, while the existing line table owns
vertical placement. Hits choose an interval side and its source affinity.
Selection traverses source intervals and merges consecutive touching rectangles;
it can emit separate rectangles for a logically contiguous bidi selection.
Callbacks run only after both endpoints validate. Opposite-affinity endpoints
at the same byte remain a collapsed selection.

Physical arrows skip equal-geometry aliases, then continue at the adjacent
visual line's opposite edge. This is an explicit physical-arrow policy, not a
claim to implement platform-specific bidi word/paragraph movement. Hard breaks
remain atomic source intervals, including CRLF. A selected hard break uses a
quarter-em marker extending from its source trailing edge; that marker is this
API's paint policy, not a claimed match to Parley's newline marker width.

## Source-affinity correction

The pinned substrate is Parley 0.11.1 (`Cargo.toml` and the workspace path patch
to `vendor/parley`). Its old `Cursor::geometry` chose visual neighbours and
then asked whether the visual predecessor ended a line. With
`"abc אבג 123 xyz"`, 18 px type and width 55, the actual source line ranges are
`0..4`, `4..11`, `11..15`, `15..18`. Byte 11's downstream caret incorrectly
appeared on line 1, while its upstream caret incorrectly appeared on line 0.
Consequently Parley selection geometry for `0..11` omitted line 1 completely.

The local vendor correction attaches downstream to the logically following
cluster's leading edge and upstream to the logically preceding cluster's
trailing edge. Hard-break and empty-layout endpoints retain their next-line
and empty-line handling. Direct `Cursor` queries and the borrowed bulk
`CursorGeometry` index use the same helper. No layout/run/cluster/cursor field
is added. The independent wrapped-line regression requires byte 11 upstream
at the left edge of line 1 and downstream at the left edge of line 2; it does
not derive those expected lines from either geometry implementation.

## Byte and work ledger

| Item | Added retained bytes |
| --- | ---: |
| Application/node/text layout/glyph headers | 0 |
| Cold interaction map and existing stops | 0 |
| Additional glyph/cluster/run/line mirrors | 0 |
| Selection/hit/motion query caches | 0 |

`TextLayout` remains 56 B and `Glyph` remains 16 B on this target. Queries use
borrowed iterators and fixed local state; the allocation counter observes zero
allocations over 50 repeated hit, motion, and selection callback cycles on a
real mixed-script wrapped layout. Caller callbacks may allocate independently.

There is a deliberate CPU cost for retaining no second topology: with S caret
stops, L lines, B hard breaks, and R runs, a complete query costs
O(S log L + B log R + R) in the worst case. Hard-break direction searches touch
each affected line's run slice; those slices are disjoint. Physical motion may
make a second scan to enter another line. No SIMD or latency improvement is
claimed for this correctness slice. It supplies the canonical source/geometry
mapping on which a measured batched classification kernel can operate later.

## Correctness gates and limits

`tests/selection.rs` uses the bundled actual Noto fonts and checks every legal
source subrange in Latin ligatures, combining marks, Hebrew/Arabic mixed bidi,
isolates/RLO, Indic, wrapped and unwrapped text. It compares the output union
to real Parley `Selection::geometry` and independently to source-owned visual
clusters with advances summed without any cursor geometry query. The union
comparison checks line, vertical bounds, holes, and duplicate coverage with
floating-point edge tolerance; it does not claim bit-identical rectangle
segmentation.

Independent fixtures also check known UAX9 visual character order, physical
arrow edge order, exact soft-wrap source ownership, CRLF interiors, RTL/LTR
break markers, empty paragraphs, reversed/collapsed selections, nonfinite
points, missing interaction maps, and callback atomicity for invalid endpoints.
The existing full Canvas suite passed after the source-affinity correction;
the final interaction changes are covered by the focused seven-test suite.
The default minimal library check and strict all-target Clippy with the
parallel feature also pass on the final source commit.

The source delta from `05af5841e1` counts every changed non-test Rust file,
including the vendor substrate: 269 added lines, 24 removed, net +245. The new
integration tests add 415 lines, and the manifest adds one development-only
Parley feature entry so tests can call its real selection API. There are no
example, executable, Python, or other implementation helper additions. These
counts exclude this evidence document.

Reproduce from `reactivity`:

```sh
cargo test -p gpui_canvas
cargo test -p gpui_canvas --test selection
cargo check -p gpui_canvas --lib
cargo clippy -p gpui_canvas --all-targets --features parallel -- -D warnings
```

The default-feature strict Clippy command encounters the existing
`only_used_in_recursion` diagnostic on `canvas.rs`'s `parallel` parameter;
enabling the implemented parallel branch avoids that unrelated diagnostic.

This is selection geometry and physical grapheme motion, not a complete web
editor. Selection-aware replacement, pointer capture/drag autoscroll, word
segmentation/tailoring, native UTF-16 conversion, IME, and undo are subsequent
owner/protocol work. No corresponding behavior is claimed by these tests.

## Integration review: distance cancellation

The spike subtracts f32 interval edges from the pointer coordinate. For a finite
point at `f32::MAX`, those distances all round to the same value: hitting `abc`
incorrectly chooses byte 1 instead of byte 3. Physical left motion from the
start of a later line also uses such a distant point and inherits this error.
The preserved failing regression is in `evidence/text-selection-integration`.

The integration instead orders candidate edges directly: retain the nearest
interval before and after the point, or choose the containing interval. Only a
bounded gap/interval needs a midpoint comparison, computed from the f32 edges
in f64. No distant subtraction, cache, allocation or retained field is needed.
The additional independent regression covers extreme finite hits in LTR/RTL
and mixed bidi text, plus cross-line physical motion in both directions.

All eight selection tests, strict parallel all-target Canvas Clippy, and the
complete release parallel Canvas suite pass on the integrated source. Exact
source hashes, counts and unmodified compressed logs accompany that evidence.
