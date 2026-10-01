# Rich text documents and ranges

This note describes a small document foundation for GPUI text inputs and future
rich-text clients. The foundation is a persistent UTF-8 text document, an edit
description, and a generic range set. It deliberately leaves document meaning to
ordinary typed Rust values in the client.

The current work is a foundation, not a complete editor. The immutable
`RichText` element is a read-only adapter over GPUI's `StyledText`; an element ID
exposes the full string as one accessibility label. The separate `rich_text()`
input constructor uses the editable text-state path. There is no rich document
accessibility tree, inline widget or source-to-display projection, collaborative
editing, or virtualized paragraph layout engine. Those features can use the
document and range seams when they are built.

## Text document

Store the document as a `SumTree<TextChunk>` using GPUI's existing persistent
B+ tree in `crates/gpui_sum_tree`. Each chunk owns an `Arc<str>` (shared UTF-8
text), targeted at about 2 KiB. This makes a pair of boundary chunks at most
about 4 KiB before seam rechunking. The tree already stores
`Arc`-owned nodes, summarizes every node, seeks by summary dimensions, and can
return a prefix or suffix while sharing untouched subtrees. Its production
branching factor is up to 12 entries per node. This gives GPUI a text-specific
summary without adding a second balancing implementation or a new dependency.
Initial construction scans and copies the input into these chunk allocations.
`from_shared_string` chunks a borrowed view and copies each chunk into its own
`Arc<str>`, so it is not a zero-copy conversion.

The summary records UTF-8 byte length, UTF-16 code-unit length, and the number of
LF characters. These dimensions answer the common conversions and line seeks by
descending through the tree and scanning one bounded chunk. The stored text and
edit ranges use UTF-8 byte offsets, which match Rust string slices. A caller that
provides a UTF-16 position can seek by the UTF-16 summary and convert within the
selected chunk. The current `byte_to_utf16` treats a byte offset inside a scalar
as after that scalar; `utf16_to_byte` rounds a position inside a surrogate pair
forward to the next scalar boundary. Text edit ranges themselves require UTF-8
character boundaries.

LF count treats `\n` as the line delimiter, as the current editable-text line
operations do. If bare `\r` should also delimit a line while CRLF remains one
break, summarize both CR and LF, track whether a left summary ends in CR and a
right summary begins in LF, and subtract one break when those summaries join.
Grapheme and word counts are not simple additive dimensions. Correct grapheme
boundaries depend on context across chunks, and word movement has its own Unicode
rules. `Document` navigation now uses `GraphemeCursor` across indexed chunks for
grapheme movement, and line summaries/ranges for line movement. Word movement
scans copied line slices until it finds a word, so it avoids flattening the
whole document but can still inspect a long line or several lines. This does not
claim constant-time grapheme or word navigation; an exact composable grapheme
summary would need to retain boundary state, as described in Xi's discussion.

An edit replaces a UTF-8 range in four steps:

1. Seek to the start offset with left bias and split the tree there. Complete
   subtrees before the offset are reused; only a chunk crossed by the offset is
   divided at its UTF-8 character boundary.
2. Split the remaining tree by the removed byte length. Drop that middle tree
   from the new root; an older snapshot still owns it if history needs it.
3. Divide inserted text at UTF-8 character boundaries into chunks no larger
   than the chunk cap.
4. Join prefix, inserted chunks, and suffix. At each join, remove the last
   prefix chunk and first suffix chunk, concatenate that pair, divide the seam
   text into target-sized chunks, and append the remaining shared subtrees.
   Never keep empty chunks.

With the current cursor contract, the split can start with
`cursor.slice(&offset, Bias::Left)`. It shares whole subtrees whose summaries
end before the offset and stops at the first chunk that contains or ends at the
offset. The cursor position gives that chunk's start; split its string at the
local byte offset, advance past the original item, then take the shared suffix.
At an edge, one of the two chunk fragments is empty and is omitted.

That seam repair prevents repeated one-character edits from leaving one tiny
chunk per keystroke. The current implementation splits the tree twice to isolate
the removed range, then joins prefix, insertion, and suffix through two
normalized appends. Each append copies a bounded seam (the two neighboring
chunks, at most about 4 KiB with the current target size) and retains the outer
subtrees. Tree paths are copied while unrelated subtrees remain shared. For `C`
chunks, seeks and split/append paths follow the B+ tree height; boundary checks
scan at most a chunk, and insertion construction is proportional to `I`, the
inserted byte count. A batch repeats this splice work for each replacement in
reverse order; it does not currently combine all edits into one tree walk.
These are bounds for text-tree operations, not layout or all editing
operations. Exact allocation counts and timing depend on the current
`SumTree` split/append paths and should be measured against real editing traces.

Cloning a document snapshot clones its `Arc<DocumentData>` handle rather than
all text; clones of the same snapshot also share its lazy flattened-string
cache. A non-noop edit creates new document data and advances that branch's
revision, while unchanged chunk subtrees remain shared. Undo can therefore
retain prior snapshots cheaply, but removed text remains allocated while any
snapshot refers to it. The current editable-text history keeps up to 1,000
entries per undo/redo stack and groups adjacent simple insertions for 300 ms;
this entry-count cap is not a byte budget. Trimming snapshots releases chunks
no longer shared elsewhere. Restoring
a history snapshot also restores its original document revision, while the
editable state maintains a separate generation for layout and transactions.
Document revisions are per-branch generations, not globally unique snapshot
IDs: independently edited clones can have the same revision. Caches shared
across document lineages need snapshot identity as well as a revision. `Arc`
sharing is an implementation detail, not content identity: equal text may occur
at many positions, and a hash of its bytes must not stand in for a stable range
or document ID.

### Contiguous text compatibility

`UnicodeTextStorage::content_utf8()` returns `&str`, so a tree-backed storage
needs a compatibility view for callers that require one contiguous string. The
current document data has a per-snapshot `OnceLock<SharedString>` and fills it
by concatenating the chunks on first access. That first access costs `O(N)` and
retains another document-sized allocation; later access to the same snapshot is
`O(1)`. Clones of the same snapshot share that cache. An edit creates new
document data with an empty cache.

The cache makes interop convenient, but it does not make every whole-document
caller incremental. If a render or navigation path asks for the flat string
after every edit, it pays `O(N)` on every revision and can erase the benefit of
the rope.
The `Document` methods for UTF-16 conversion, line lookup, and slicing use
summary seeks, bounded chunk scans, or only the requested copied range. The
`UnicodeTextStorage` implementation routes UTF-8/UTF-16 conversion and caret
navigation through those document methods. Grapheme movement uses
`GraphemeCursor` across chunk boundaries; line movement uses the line index;
word movement scans copied line slices until it finds a word. These paths avoid
flattening the whole document, though word movement can still copy and scan a
long line or several lines. The old string-backed storage remains appropriate
for small inputs.

## Generic ranges

`RangeSet<T>` keeps caller-owned typed payloads such as selections, diagnostics,
search matches, links, or syntax captures. A `Span<T>` has UTF-8 byte endpoints,
an insertion affinity at each endpoint, and the payload. Spans remain in stable
authoring order; a secondary index orders their indices by `(start, end,
authoring order)` for hit testing. Point annotations are explicit and remain
queryable at their byte position.

The current static `RichText` value holds shared contiguous text plus a
`RangeSet<InlineStyle>`. `InlineStyle` stores optional GPUI text properties;
overlapping spans compose property by property, with the last authoring span
that sets a property taking precedence. A byte-range sweep lowers those spans
to native `TextRun`s and joins adjacent runs with equal resolved style. This is
a useful text-rendering projection, but it does not rewrite the source or
insert display-only content. The large editable `Document` remains its own text
representation rather than pretending every document is a static builder value.

The current set stores immutable shared span and start-order arrays, plus a
segment tree whose nodes record the last byte position each span can hit. A
span's payload is also `Arc`-shared. Cloning a set is `O(1)` and rebuilding its
indexes sorts the spans, so construction, `with`, `concat`, and non-noop mapping
cost `O(R log R)` plus endpoint mapping. Here `R` is the number of spans.

A hit or overlap query binary-searches the span-start boundary, then traverses
only segment-tree nodes whose maximum hit position can reach the query. The
iterator emits results in coordinate order. This avoids scanning a long prefix
just because one early span is long. A simple worst-case bound is
`O(log R + K log R)` for `K` returned spans, and it can reach `O(R)` when most
spans match; this representation does not claim `O(log R + K)` for all cases.

The plain byte offsets make edit mapping easy to understand, while moving later
ranges still takes work. `map_through` maps both endpoints of every span and
rebuilds the indexes; even a one-range edit therefore visits all `R` spans. The
precomputed change groups let each endpoint map in `O(log(M + 1))` time for `M`
edit groups, after which sorting and rebuilding the indexes costs `O(R log R)`. A
no-op can share all range storage after validating the endpoints. Mapped spans
share their `Arc<T>` payloads, but the new coordinate arrays and segment tree
are rebuilt. There are no stable document anchors or lazy suffix shifts yet. A
balanced text tree does not make this array-backed range map logarithmic. It is
a reasonable first shape for modest annotation sets; change it only when range
counts and edit traces justify an anchor map or a path-copying interval tree.

The range set supplies ordering and overlap queries, not a universal rich-text
model. A client can use a closed Rust enum or distinct typed range sets for its
own semantics. `ChangeSet` validates a batch against one UTF-8 source value and
maps endpoints using `Affinity::Before` or `Affinity::After`. A `ChangeSet` built from a
`Document` is bound to that exact snapshot; a text-backed change set checks document
content when applied. All ranges in a batch refer to the original source;
overlapping replacements and duplicate insertions at the same byte position
are rejected. Changes with the same start are mapped as one group. At an
adjacent-edit boundary, the left replacement is applied before affinity is
evaluated for the change starting at that position.

`ChangeSet::new` accepts contiguous text, retains a shared source value, sorts
and validates the edits, and scans the source for its UTF-16 length. With `N`
source bytes, `M` changes, and `I` inserted bytes, it costs
`O(N + I + M log(M + 1))` before application. `ChangeSet::for_document`
instead reads length and character boundaries from the document summary and copies only the
removed ranges needed for undo/no-op detection; it does not flatten the full
source. For `C` chunks, bounded chunk size `B`, `D` removed bytes, and `I`
inserted bytes, that builder costs
`O(M log(M + 1) + M(log(C + 1) + B) + D + I)` in the current implementation.
Both forms precompute position-map groups, so mapping an endpoint costs
`O(log(M + 1))` plus one document boundary lookup when the source is a document.
The standalone contiguous `apply_to` helper still copies the full source
(`O(N + I)` for inserted byte count `I`); document-native application should
use the persistent splice path. There is no mandatory schema,
plugin runtime, or parser dependency. A client can build a chunk-aware Tree-sitter
input adapter over the document and reuse a previous syntax tree after passing
the corresponding edit description; parser ownership and syntax policy stay
with the client. Regex search has a similar boundary: a high-level search over `&str`
needs a contiguous view, while `regex-automata` exposes byte-at-a-time DFA
transitions that a client can carry across chunks. Such a scanner must preserve
automaton and match context between chunks and apply end-of-input handling only
at the document end; resetting at every chunk would miss cross-boundary matches.
No regex engine is integrated into the document. Inline widgets and embedded
objects also remain future types carried by a client-defined annotation or
document layer.

## Layout boundary

The text tree can find logical lines and their byte ranges. The read-only rich
text bridge can lower inline styles into GPUI text runs; a client can also
project separate typed range layers there without making theme colors or parser
captures part of the source document. Those text runs do not change displayed
text. Hiding Markdown delimiters, showing inlays, or replacing source text with
an inline widget needs a separate source-to-display map and is future work.

The tree cannot predict wrapped visual height from text length alone: shaping
also depends on width, font, style, and annotations. Normal editable-text layout
reads logical line ranges directly from the document and clips persistent
formatting and transient decorations to each paragraph. It composes transient
decorations after persistent styles, so explicitly set decoration properties
take precedence on overlaps. Its paragraph cache retains deduplicated entries
for the current layout only; a completed changed
layout replaces that cache, so old revisions are not kept alive by layout.
Each cache entry holds paragraph text and an `Arc<WrappedLine>`. A content/style
fingerprint narrows lookup; exact key and chunk-by-chunk text comparison guard
against a hash collision. A cache miss copies that paragraph and calls
`shape_text`. When a non-truncating layout key is unchanged, the prior layout
returns early before range validation or paragraph work, so caret-only changes
do not revisit paragraphs.
If an edit requested caret scrolling, that early path can recompute the pending
scroll offset from the cached line segments and current caret without reshaping;
when the layout key changed, it computes the offset from the newly built lines.

After a document or layout-key change, the normal path still visits each
paragraph up to the configured line-clamp limit, clips its styles, hashes its
text bytes, and checks matching cache entries against the exact key and text.
This reads unchanged paragraph bytes again and can scan a cache hit once for its
fingerprint and once for exact text equality. Unchanged paragraphs with the
same shaping inputs reuse their `WrappedLine`; paragraphs whose text or
paragraph-local shaping key changed allocate a line slice and go through
`shape_text` again.
The layout then rebuilds the complete `TextLineSegment` vector and total height
for the laid-out content. A cold un-clamped paragraph cache therefore sends
every paragraph through `shape_text`; GPUI's separate text-system cache may
still reuse matching wrapped-line layouts. Prepaint binary-searches the segment
vector by vertical position and paints only visible lines, but retained line
and height data still grows with the whole document. Explicit width truncation
also keeps GPUI's contiguous text helper: it copies the full document into a
string and lays it out as a whole, without using the paragraph cache. The cache
reduces repeated shaping after
localized edits; it does not make cold layout or explicit truncation
viewport-bounded.

A future large-document path could add a visual row-count or height index and
shape visible paragraphs first. That index must be invalidated when text, width,
font, or relevant annotations change. This remains separate work. Accessibility
projections, inline widgets, and collaboration are also outside the current
implementation and should not be inferred from this document model.

## What other implementations teach us

| Implementation | Useful idea | Tradeoff relevant to GPUI |
| --- | --- | --- |
| Zed / GPUI `SumTree` | Persistent B+ tree, composable summaries, multi-dimension seek, shared prefix/suffix | The balancing and structural sharing already exist here; a text adapter needs only chunks, summaries, and splice logic. |
| Xi rope | Monoid summaries make line and other derived information update with changed paths | Boundary-sensitive metrics such as graphemes require more than adding two counts. |
| CodeMirror `Text` and `RangeSet` | Immutable chunked text and range layers reuse unaffected values | Its JavaScript string coordinates are UTF-16 code units. Range mapping walks chunks and shares untouched chunk contents; persistence does not make all mapping logarithmic. |
| VS Code piece tree | Append buffers plus a red-black tree with line metadata work well for mutable editing | Their measurements found line retrieval and piece accumulation mattered in practice; edit complexity alone did not identify the hottest path. |
| Ropey and crop | Rust B-tree ropes expose chunks and line/offset APIs instead of requiring one string; crop also offers cheap Arc-backed snapshots and optional UTF-16 metrics | Ropey exposes scalar-oriented as well as byte APIs; crop centers UTF-8 byte offsets. GPUI's OS-facing UTF-16 API makes dual byte/UTF-16 summaries useful. Both are relevant comparison points, but introducing either would duplicate the existing `SumTree` role. |
| JumpRope | Skip-list nodes with local gap buffers and a write-buffer wrapper favor edit locality and batched adjacent writes | Its mutable, Unicode-scalar-indexed API and probabilistic balancing differ from this snapshot-oriented B+ tree. Its published editing-trace results are specific to those traces and hardware; GPUI should profile its own renderer and history workload. |

No published microbenchmark transfers directly to GPUI's workloads or renderer.
The initial chunk target and cap are tuning choices. Measure single-character
typing, replacement and deletion, paste, large-document load, line and UTF-16
lookup, snapshot retention, and cold/warm layout separately. In particular,
record flatten bytes and paragraph shaping work so the compatibility path does
not hide a whole-document cost. Microsoft's piece-tree report is a useful
warning: its author found that line retrieval, rather than insert/delete, was
the hottest method after integration, and that a growing piece count made line
lookup slower. Those timings describe VS Code and its runtime; they are a reason
to profile GPUI's call paths, not a prediction of GPUI latency. JumpRope also
publishes editing-trace comparisons for skip-list-plus-gap-buffer storage, but
the workloads and environments differ from this codebase.
The local [benchmark harness](../crates/gpui_elements/benches/rich_text.rs)
separates clone/edit cost from legacy flattening, batches spaced edits, tests
mixed-Unicode and line lookups, lowers 1,000 overlapping styles, and measures
range mapping/query and headless editable-state dispatch. Separate CPU frame
cases cover cold layout, warm redraw, localized edits, and width/style
invalidation with `NoopTextSystem`; they exclude real font shaping and GPU
presentation. Run-specific measurements and caveats live in the
[verification report](rich-text-verification.md). These workloads do not establish
a speedup over other editors or predict native frame rate.

## Further reading

- The local [document](../crates/gpui_elements/src/rich_text/document.rs),
  [navigation](../crates/gpui_elements/src/rich_text/navigation.rs), and
  [range set](../crates/gpui_elements/src/rich_text/ranges.rs) implementations,
  plus [GPUI's SumTree](../crates/gpui_sum_tree/src/sum_tree.rs) and
  [cursor slicing](../crates/gpui_sum_tree/src/cursor.rs).
- [Xi Rope Science, part 1: MapReduce for text](https://xi-editor.io/xi-editor/docs/rope_science_01.html)
  and [part 3: Grapheme cluster boundaries](https://xi-editor.io/xi-editor/docs/rope_science_03.html).
- [CodeMirror's current state repository](https://code.haverbeke.berlin/codemirror/state)
  contains its immutable text tree and range set (the former GitHub mirror is
  archived).
- [VS Code's text-buffer reimplementation and measurements](https://code.visualstudio.com/blogs/2018/03/23/text-buffer-reimplementation).
- [Ropey](https://github.com/cessen/ropey), [crop](https://docs.rs/crop/latest/crop/),
  and [JumpRope](https://docs.rs/jumprope/latest/jumprope/).
- [Tree-sitter's incremental parse and chunked input API](https://github.com/tree-sitter/tree-sitter/blob/master/lib/include/tree_sitter/api.h).
- [`regex-automata`'s DFA byte-transition interface](https://docs.rs/regex-automata/latest/regex_automata/dfa/trait.Automaton.html).
