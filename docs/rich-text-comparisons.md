# Rich text architecture comparisons

Status checked 2026-09-26. This is a comparison of reusable editor ideas, not a
claim that GPUI already has a complete document editor. In particular, plain
text editing, syntax highlighting, semantic rich text, and a Notion-like block
editor are different layers.

## CodeMirror 6: state, transactions, and extensions

CodeMirror is the closest reference for a small composable core. Its current
`@codemirror/state` package is version 6.7.6 (tagged 2026-09-22), maintained on
the author's self-hosted forge after the [GitHub repository was archived and
moved](https://github.com/codemirror/state) in April 2026. The
[current state source](https://code.haverbeke.berlin/codemirror/state),
[EditorState](https://code.haverbeke.berlin/codemirror/state/src/branch/main/src/state.ts),
[transactions and effects](https://code.haverbeke.berlin/codemirror/state/src/branch/main/src/transaction.ts),
[range sets](https://code.haverbeke.berlin/codemirror/state/src/branch/main/src/rangeset.ts),
[text tree](https://code.haverbeke.berlin/codemirror/state/src/branch/main/src/text.ts),
and the [API reference](https://codemirror.net/docs/ref/) are the sources used
here. I verified the current version from the maintained forge with a shallow
clone and `git log -1`: commit `651084c` is dated 2026-09-22 and says “Mark
version 6.7.6”; the latest tag is `6.7.6`.

`EditorState` is an immutable value containing a `Text` document, selection,
and extension-managed state fields. An update creates a `Transaction`; the
transaction carries a batch of changes, an optional new selection, effects and
annotations. `ChangeSet` stores inserted text, while its lighter `ChangeDesc`
describes positional changes and maps selections or ranges. Extensions provide
type-parameterized state slots (`StateField`), configuration (`Facet`), and
reconfiguration. The view package consumes this state and limits DOM rendering
to visible ranges. Decorations are view data mapped through document changes,
not part of a language-specific syntax tree.

Useful ideas for GPUI are the explicit old-document coordinate space for a
batch, a separate position map, endpoint affinity, and a way for annotations to
follow edits. CodeMirror's `RangeSet` is an immutable, chunked tree with mapping,
range iteration, and change comparison. The state/view split also gives a clear
boundary: a format parser can own its syntax state, while a renderer consumes
style and decoration ranges.

CodeMirror positions use JavaScript string offsets (UTF-16 code units), while
GPUI's editing ranges are UTF-8 byte offsets. The API's main papercut is
coordinate discipline. By default, multiple
transaction specs all use the initial document's coordinates; `sequential`
changes that rule, while selection and effect positions refer to the resulting
document. The API supports this explicitly, but callers must keep track of
which snapshot every position belongs to. Range endpoint behavior also takes
several knobs (`startSide`, `endSide`, point behavior, and map mode), because
"stick to inserted text" has no single correct answer for every annotation.
GPUI can make these semantics explicit with Rust types and one affinity per
endpoint. CodeMirror's design does not imply that mapping is free: its range
tree reduces work for local changes by sharing unaffected chunks; rescanning or
rebuilding every annotation after every keystroke would lose that property.

## ProseMirror: semantic documents and steps

ProseMirror is a richer model. Its persistent document is a tree of nodes
constrained by a schema; transforms produce steps and position maps, and a
transaction carries document edits, selection, stored marks, and metadata.
Plugin state is derived when a transaction is applied. `DecorationSet` stores
view-only marks and widgets and maps them through the transaction. See the
[system guide](https://prosemirror.net/docs/guide/) and
[reference manual](https://prosemirror.net/docs/ref/).

This is a strong pattern for semantic editors: schemas make block structure and
valid content explicit, while steps preserve an edit trail for history and
collaboration. It is too much policy for GPUI's base text platform. Markdown,
AsciiDoc, source code, and a semantic page editor do not share one valid-node
schema. Start with text plus typed, client-owned annotations; a semantic editor
can later add its own block tree and validated commands above that layer.
ProseMirror positions count structural node boundaries as well as text, so its
positions are not interchangeable with GPUI UTF-8 byte offsets.

## Lexical: immutable snapshots with a rich node model

Lexical keeps committed editor states immutable and batches edits in an update
callback against a pending state. Nodes have keys and node types; registered
transforms normalize dirty nodes, while commands and listeners connect editing
behavior to the view. Its [editor state guide](https://lexical.dev/docs/concepts/editor-state),
[node transforms guide](https://lexical.dev/docs/concepts/transforms), and
[headless package](https://github.com/facebook/lexical/tree/main/packages/lexical-headless)
show how format behavior can be composed without requiring a browser view.

The useful lesson is to make updates a single boundary and retain snapshots
cheaply. Lexical's keyed, mutable-during-update node model and transform runtime
are a deliberate editor framework, not a minimal text-storage abstraction.
GPUI should not need node keys, a command bus, or transform scheduling merely to
render styled ranges or host a Markdown input.

## Flutter: keep IME state together; keep style in the renderer

Flutter represents editable text as `TextEditingValue`: text, selection, and
the current IME composing range travel together. Its controller documentation
warns that changing composing state from a listener can cause an IME feedback
loop. For display, `TextSpan` trees carry text and inherited styles into
`RichText`. See [`TextEditingValue`](https://api.flutter.dev/flutter/services/TextEditingValue-class.html),
[`TextEditingController`](https://api.flutter.dev/flutter/widgets/TextEditingController-class.html),
and [`TextSpan`](https://api.flutter.dev/flutter/painting/TextSpan-class.html).

This separation fits GPUI well: keep composition and selection in the existing
input state, then project annotation ranges into styled runs for the existing
text layout. A style span is a rendering instruction; by itself it does not
define document semantics, editing transactions, or history.

Ranges over source text also do not create a source-to-display mapping. Coloring
code tokens can preserve source positions directly. Hiding Markdown delimiters,
showing completion text inline, or inserting an interactive widget needs an
additional projection that maps cursor and hit-test positions between source
and display. Keep that projection as a later, explicit layer; inline style alone
does not provide it.

## Rust text storage: chunk access must be part of the contract

[Ropey](https://github.com/cessen/ropey) demonstrates the practical Rust rope
surface: snapshots share data, positions can be expressed as Unicode scalar
indices, line operations are indexed, and clients can iterate chunks without
flattening the document. [Xi's rope design](https://github.com/xi-editor/xi-editor/blob/master/docs/docs/crdt-details.md)
shows how summaries make line and other metrics composable across a tree.
Ropey's scalar coordinate is different from GPUI's existing UTF-8 byte
selection offsets and OS-facing UTF-16 positions, so conversion policy must be
explicit.

GPUI's current [`UnicodeTextStorage`](../crates/gpui_elements/src/editable_text/storage.rs)
requires `content_utf8() -> &str`. That is convenient for small inputs, but a
tree-backed implementation must flatten to satisfy it; repeated use after each
edit can turn an otherwise local edit into whole-document work. Its default
UTF-8/UTF-16 conversion methods also scan the contiguous text. A large-document
backend needs chunk iteration and summary-based byte, UTF-16, and line lookup
alongside the compatibility string path. The input layer already owns selection
and IME composition, so a new document backend should plug into that state
rather than introduce a second keyboard and IME implementation.

## A small GPUI core

The current API has a persistent UTF-8 [`Document`](../crates/gpui_elements/src/rich_text/document.rs)
backed by GPUI's `SumTree`. Its summaries index byte length, UTF-16 code-unit
length, and LF-delimited lines; chunk iteration and native navigation avoid
flattening for those operations. Each snapshot has a revision, and cloning it is
cheap. `as_str()` remains available for compatibility and caches one flat
`SharedString` per revision.

[`ChangeSet`](../crates/gpui_elements/src/rich_text/changes.rs) validates a
multi-edit batch against one exact snapshot, checks UTF-8 boundaries, maps
positions using `Before` or `After` affinity, and applies all edits atomically.
Document transactions can also carry a post-edit [`Selection`](../crates/gpui_elements/src/rich_text/ranges.rs).
[`RangeSet<T>`](../crates/gpui_elements/src/rich_text/ranges.rs) stores
client-owned typed annotations and maps them through those edits. Its public
payloads can represent persistent formatting, diagnostics, links, syntax, or
search results without requiring a shared content schema.

[`RichText`](../crates/gpui_elements/src/rich_text/inline.rs) and
`RichTextBuilder` provide styled text values. `InlineStyle` composes properties
per range and lowers them into coalesced GPUI `TextRun`s. `RichTextElement`
delegates shaping and painting to `StyledText` and reports UTF-8 byte locations
for click and hover callbacks. The existing
[`EditableTextState`](../crates/gpui_elements/src/editable_text/state.rs) uses
`Document` by default, can initialize from `RichText`, maps persistent styles
through edits, and exposes atomic text/style dispatch. It continues to own
selection, IME composition, focus, and keyboard editing. `from_rich_text()` and
`rich_text_snapshot()` provide the current import/readback bridge.

Undo and redo now share a snapshot history for text edits and formatting.
[`HistorySnapshot`](../crates/gpui_elements/src/editable_text/history.rs)
contains the persistent document, inline styles, and selection; undo restores
that complete value through the storage snapshot bridge. The current history
has a fixed capacity and default typing/IME grouping. A configurable history
policy or extension system is future work.

This is a flat text document with inline styles, not a semantic block model.
It does not currently parse Markdown or AsciiDoc, hide source delimiters,
provide code-language services, or define block schemas and embedded widgets.
Ranges can color source text, but changed display content requires a separate
source-to-display mapping. A Notion-like editor can use this core while owning
its own block tree, serialization, code-block language state, and editing
commands.

The editable layout now slices and shapes logical paragraphs through the native
document API, and caches shaped paragraphs so unchanged lines can be reused
across document snapshots. Normal editing therefore does not flatten the full
document. A cold layout or a change to layout inputs still scans the document's
paragraphs and keeps one line segment per paragraph; a viewport height index
and visible-paragraph-only layout remain future work. Explicit truncation and
`as_str()` use the compatibility string path, which costs `O(N)` the first time
it is requested for each revision. Range mapping rebuilds its interval index,
and uncached inline-run lowering sweeps the relevant ranges, so workloads with
very large annotation sets should be measured before adding more indexing
machinery. For implementation details, see the
[`rich-text-architecture` note](rich-text-architecture.md).
