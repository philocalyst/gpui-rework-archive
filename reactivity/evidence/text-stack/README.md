# One owned text result, measurement without output storage

Root reviewed and composed the known-width measurement, packed glyph owner and
direct outline slices at `826ecb675f8b5beb61261d54e0a6945f1328051f`.
`library-source-equivalence.json` checks all 132 library source files against
that qualified source. Main's independently reproduced static default font and
its evidence are preserved. The larger common-eight/stride experiment remains
unadopted; its favorable allocation result does not offset its unresolved code,
frame and implementation costs.

`TextShaper::measure` uses the same validated Unicode planner without retaining
glyphs, font-set leases or interaction geometry. Width-only measurements make
available height unobservable at the callback boundary; known heights remain
part of the cache question. One concrete Cephal adapter serves both modes.
The runtime may seed a vacant layout at its first known width, then preserves
that interactive layout through other probes. Final placement checks width and
font size before publishing its geometry. The separate producer's representative
Hummingbird measurement capture reduced 191 plans to 117 plans and 87 metric
queries, including 30 interactive plans. Its cold/warm allocation counts fell
2353→1335 and 2340→1322. Those are operation scopes, not application latency or
whole-window memory bounds.

Each canonical glyph now occupies 12 bytes: a checked 17-bit glyph/font code and
15-bit original source cluster share one word; x and frozen baseline retain
their original f32 bits. This keeps all primary u16 glyph IDs and the checked
domains of the two immutable fallback faces. The public decoded `Glyph` remains
16 bytes. `TextLayout::glyphs()` intentionally becomes a borrowed, cloneable,
double-ended, exact-size value iterator; callers explicitly collect when they
need an array. No expanded glyph mirror survives. The bounded document length
moves into the allocation owner, deleting the simple-tail encoding and its
tail-only details/COW paths. Ordinary simple long-grapheme layouts may now return
None from `geometry()`; `shape_interactive` still requests the complete map.
Run, line, caret and selection operations keep their canonical source authority.

The unique owner is 16 bytes and restores the original Vec pointer, initialized
length and **actual capacity** once at drop. Admission checks precede ownership
transfer; failed admission returns the unchanged Vec. Its narrow unsafe module
exposes immutable borrowed access and explicitly requires PackedGlyph Send/Sync.
The isolated exact-module Miri qualifications and actual capacity/clone faults
remain scoped in the packed producer dossier; full-Canvas Miri is not claimed.
On the qualified 64-bit build TextLayout is 48 bytes and the runtime TextSite is
72 bytes, down from 56 and 80. These overlapping headers must not be added to
operation allocation totals.

Raster misses now draw through Skrifa once to validate the original control hull
and record the path consumed by Zeno. Ordinary glyphs need no second decoder;
accepted complex paths deliberately replay after a bounded speculative spill.
Empty contours retain their contribution to bounds without storing fill edges.
Production Swash and its duplicate font raster key disappear; Swash remains a
dev-only independent mask oracle. Fontique still owns its separate parser
dependency. The producer's normal linked text fell 741,472 bytes; the raster
function itself grew and several rejected/zero-area inputs allocated more.
`outline-producer-report.json` retains the complete unfavorable bill. Root's
composed fix additionally borrows warm raster scratch through preflight errors,
so rejecting an outline cannot discard the preceding successful backend/masks.

Root's combined release default library tests passed 838 cases with 13 ignored;
fallback Canvas passed 211 with three ignored; native X11 GPUI passed 648 with
35 ignored. Strict repository-policy default, fallback and native checks passed.
The later source-equivalent composition passed 31 documentation tests and
Apple aarch64 / Windows MSVC compile-only checks. Selected-package formatting
and the dependent Hummingbird locked/offline metadata check passed.
Frozen build/test commands, source guards and results are archived separately.
The counter reports **31,616** non-test, non-comment core lines, **+298** from
Main 5381: independently recounted on Main `ca746715bb`. The scope is six
shipping libraries plus their build script, excluding apps,
vendors, tests, examples and evidence. No future line-count projection is used.

The unchanged original full Debug oracle comparison failed, and remains failed:
the public Glyph Debug output no longer includes private `simple_tail_bytes`.
Root independently removed only that named field from the original GLYPHS/RUN
records: all 2,120,032 removals are explicit. The resulting 239,299,576 bytes,
1,120 cases and 2,240 metric records equal the candidate exactly, SHA-256
`60377199d272756f50a892c1dcc8968497bf6df3cc977610843e7c26856cd332`.
No glyph, numerical, error, caret or selection field was normalized. The raw
failed comparison, schema review and separate semantic comparison remain here.

The complete original finite campaign also contains stale Hummingbird lockfile
failures. The later Files composition has separate app test deadlines and a
nightly atomic deprecation failure under investigation. These are not a passing
whole-campaign or application-port claim. Files, fresh-schema work, vertical text
navigation and the renderer's newly exposed axis-boundary correction remain
separate from this text adoption until their own review and gates finish.
No speed, startup, RSS, cross-platform execution or zgui superiority is inferred
from these static layouts, allocation scopes or functional suites.
