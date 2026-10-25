# Parley 0.12.0 local repairs

`Run::glyph_count` sums the existing line-scoped raw shaped-cluster lengths,
without grouping positioned runs, placing glyphs or retaining a count field. The
engine already stores one for inline glyphs at its sole cluster constructor;
its count accessor now returns that field directly, including the inline case.
This preserves the release elimination of GlyphRunIter's debug-only count sum.
Placement, raw glyph iteration, reserve policy and whole-paragraph output-limit
error order remain unchanged. No run, paragraph or retained layout grows.

Published crate: `https://static.crates.io/crates/parley/parley-0.12.0.crate`.
Archive SHA-256: `61bd0c0c1737f0b3d3726dc06b225083af213b61913e4fbae1670613a106c6ce`.
Upstream commit: `6e1143dda817360dd3a2a64f9133c6e5dfabd881`, directory `parley`.
MIT/Apache licenses, original/normalized manifests and VCS metadata accompany
the complete source. The workspace uses its root lock and path patches.

`CursorGeometry` remains a transient borrow over one layout. Its entries now
hold the 0.12 character-based ClusterPath and exact visual f32 prefix; a byte
table selects an entry. Capacity is 16 bytes per source scalar plus four bytes
per source byte, discarded after lowering. Resolving an entry's path uses the
engine's atom search; only byte-to-entry/prefix lookup is constant time. No field
is added to Layout, Run, Cluster, Cursor or Canvas's retained line/stop tables.

Direct Cursor geometry and the indexed helper share the source-affinity rule:
upstream uses the logical predecessor's trailing edge, downstream the logical
successor's leading edge, and a hard break resolves to the next line. A visual
predecessor cannot steal source ownership at bidi soft wraps. The byte11
regression for `abc אבג 123 xyz` retains its independent line oracle.

`Run::glyph_source_ranges` borrows the engine's finer shaped-cluster ranges.
Public 0.12 clusters span full graphemes and cannot alone preserve each glyph's
original source cluster. The iterator adds no retained map and follows the
existing visual glyph order, including RTL runs. Two glyph-count consumers
accept the widened engine count; see the engine's accompanying patch ledger.

Canvas lowers the union of new content/line-box bounds, exactly matching the
cursor's vertical bounds, and suppresses implicit variable-weight synthesis for
its explicit default font instances through Fontique's metadata override.
The removed 0.11 word-boundaries feature is not recreated: current upstream
analysis/editor behavior stays enabled. Old feature-comparison measurements
remain historical and do not describe this 0.12 binary.

Consuming-batch checkpoint elimination: break_remaining calls the same private
line-break body without snapshotting prev_state. Its consumed iterator cannot
call revert after the batch, and the body/finish never reads prev_state. Public
break_next keeps the original checkpoint/revert contract. A shared readiness
check preserves done/invalid-width behavior; no retained flag, duplicate break
algorithm, generic boolean specialization or additional cache is introduced.

`CursorGeometry::geometries_at` uses the existing byte map to prove source
adjacency, then checks exact visual adjacency within one run and line. The cached
f32 prefix already contains the common edge, so that branch constructs no
Cluster or Cursor. It shares the original line/width rectangle arithmetic.
Endpoints, gaps and other boundaries retain canonical cursor policy in a
separate fallback. Private cursor helpers borrow Cluster values, avoiding large
Copy staging. Layout, cursor and retained map layouts do not change; there is no
additional allocation, worker state, unsafe code or persistent cache.


SOURCE-ONLY width-storage mechanical cut (uncompiled/unqualified): LayoutData
owns explicit WidthData line buffers, computed metrics and alignment/indent
state. Readers and original breaker use those exact fields; LineLayout::swap
borrows only WidthData. There is no arithmetic, new breaker, sharing, cache,
Arc, Deref, unsafe, runtime reuse or Canvas format change. Inline-box placement
remains outside WidthData; general immutable width views are NOT implemented.
Ordinary Layout::clone still deep-clones both halves and clear still drops font
references while retaining emptied vector capacities. The detached A/B/A test
moves width buffers, compares cold original LayoutData and checks all ten
shape-array addresses. The previously omitted test_layout module is registered.
Standalone vendor tests inherit a packaging blocker: tests/utils/fonts.rs names
parley_dev, absent from this published Cargo.toml. No new dependency or lock was
silently resolved here. Canvas paragraph-reuse tests remain the ordinary
workspace gate; standalone vendor tests need their original dev fixture restored
and frozen separately before execution. No tests or timings have been run.


SOURCE-ONLY borrowed read seam (uncompiled/unqualified), following the separate
width-storage control: LayoutData owns ParagraphData plus WidthData; original
builder/breaker/editing field accesses route explicitly, without reassociation
or arithmetic changes. LayoutRead has private fields and pairs borrows only
from the same ordinary Layout. Line/Run carry that pair; derived Cluster logical
and visual navigation uses it. The original line byte binary search is moved
once into the facade and Layout delegates; no duplicate policy is introduced.
Ordinary Layout remains sole owner, including font refs and inline-box mutable
placement. clear/build/break cannot occur while a derived borrowed view remains
live. Public Clone still deep-clones owners; read clones copy only references.
No Arc, unsafe, mutation escape, resource cache or runtime shape reuse exists.
Line/Run and derived stack/iterator types carry an additional reference; actual
size/code/stack costs must be measured and can reject this representation.
Existing Canvas packing, scene leases and font-free geometry are unchanged.
No old Canvas scene now owns ParagraphData, and no new immutable owned width
view or owner/view retirement protocol is claimed. New compile-fail examples
cover clear/rebreak with live read views. The test-only Canvas oracle emits
identical raw output words on the separate frozen control and candidate and
prices public reader type sizes, avoiding a common-path-only oracle claim.

SOURCE-ONLY immutable paragraph / borrowed independent width prototype, based on
corrected17d5ac1 (uncompiled/unqualified): all inline-box declaration+placement
storage moves into WidthData; ordinary Layout clear/build/clone and inline-box
APIs keep the same fields/ordering and still use the original breaker body.
BreakTarget borrows ParagraphData immutably plus exclusive WidthData. The three
text-box helpers borrow only ParagraphData; line commit/hanging whitespace read
the same paired facade. No arithmetic, shaping, boundary or error-order formula
is replaced. Public incremental BreakLines still commits partial output on Drop.

Doc-hidden experimental ShapedParagraph consumes only an unboxed/unaligned
Layout, moving existing shape arrays without cloning and preserving indent.
Unsupported conversion returns the unchanged Layout. It has no Clone/mutable
API. WidthView borrows that owner and owns fresh width buffers; another B/A
cannot mutate live A. Only the consuming original batch breaker constructs a
view; its builder cannot escape. Optional widths accept positive finite/None;
unsupported widths return None outside GPUI. No Canvas/runtime path calls these
APIs. There is no cache, Arc, unsafe, new canonical Canvas representation or
published owner lease. Existing old Canvas scene/geometry resources are unchanged.

This is actual source-level one-shape/multiple-width reuse, NOT an executed reuse
or speedup result. New Canvas tests compare simultaneous A/B/A raw line/glyph/
source/font/run/frozen line words against fresh original builds, preserve old A
after dropping B, and drop planner/font-context scratch before width creation.
They preserve nonzero indent and reject unsupported widths/conversions. The
new views do NOT expose CursorGeometry/caret APIs, so full interaction parity
is explicitly NOT established. New owner/view-drop compile_fail examples require
the intended move-while-borrowed reason (typically E0505). Existing mutating-
Layout examples instead concern E0502. Rustdoc must execute them on stable.

Ordinary cold paths share the rewritten BreakTarget: same-source cold equality
alone cannot qualify the adapter. The unchanged88-record frozen oracle plus a
new108-record ordinary public-API box/alignment/cursor dump must compare exactly
between corrected17d5ac1 and this source. Both are mandatory before considering
prototype tests. The latter covers all3 box kinds, baseline/top/bottom placement,
Start/Center/Justify, two widths/texts and every-byte both-affinity f64 rectangles.

Peak/retained capacity, font/source retirement, aggregate budgets, canonical
fragment metadata after WidthData retirement, malformed/expanding-font first-
error order and final runtime P/C/ACK/IME authority remain unimplemented gates.
Each live WidthView adds its whole line buffers; owner keeps original raw shape
capacity/fonts. BreakLines/reader/iterator stack and code costs must be priced.
No smaller representation, bounded engine cache, shipping qualification, CPU,
raster/upload/native-present or latency claim follows from this prototype.
