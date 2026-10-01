# Composable rich text

The public foundation lives in `gpui_ce_elements::rich_text`. It connects small,
immutable rich text values to the same editing, selection, IME, and shaping path
used by `text_input` and `text_area`.

Four primitives carry the design:

| Primitive | Responsibility |
| --- | --- |
| `Document` | Persistent UTF-8 text snapshots, indexed lines and UTF-16 conversion |
| `ChangeSet` / `Transaction` | Validated atomic edits and position mapping |
| `RangeSet<T>` | Client-owned typed annotations with endpoint affinity |
| `InlineStyle` / `RichText` | Composable formatting lowered to native GPUI text runs |

There is no mandatory parser, schema, extension registry, or language model.
Markdown, AsciiDoc, code tokens, links, diagnostics, and search matches can keep
their own typed state and produce ranges over the same document.

## Build a reusable fragment

```rust
use gpui_ce_elements::rich_text::{InlineStyle, RichText};

let emphasis = RichText::new()
    .span("small rituals", InlineStyle::default().bold())
    .finish();

let note = RichText::new()
    .text("Keep ")
    .append(emphasis)
    .text(". Write café and 東京 naturally.")
    .finish();
```

A finished `RichText` is an ordinary GPUI child. Its styles resolve against the
parent's inherited text style during layout. Appending a fragment preserves its
annotations. Adjacent equal runs coalesce before shaping; range boundaries do
not force independent glyph layouts.

Styles compose property by property. A later color range can overlap a bold
range without removing its font weight. `clear_background`, `clear_underline`,
and `clear_strikethrough` explicitly remove inherited decorations; omitted
properties inherit. `clear_color` and `clear_font_family` restore the base GPUI
style. `.color(...)` replaces the foreground; `.highlight(native_highlight)`
uses GPUI's highlight color blending.

Scopes borrow the builder and apply their style before styles authored inside
the scope:

```rust
use gpui_ce_elements::rich_text::{InlineStyle, RichText};
let note = RichText::new()
    .styled(InlineStyle::default().bold(), |text| {
        text.push_text("A ")
            .push_span("small ritual", InlineStyle::default().italic());
    })
    .finish();
assert_eq!(note.as_str(), "A small ritual");
```

## Edit through the existing input

Initialize state once with `EditableTextState::use_keyed_rich_text`, then attach
it to an ordinary `text_area`. Initial formatting is part of the initial value,
not an undo operation.

```rust
use gpui::{App, ElementId, IntoElement, Window};
use gpui_ce_elements::{
    editable_text::{EditableTextState, text_area},
    rich_text::{InlineStyle, RichText},
};

fn note_editor(window: &mut Window, cx: &mut App) -> impl IntoElement {
    let id = ElementId::from("note");
    let state = EditableTextState::use_keyed_rich_text(
        id.clone(), window, cx,
        |_, _| RichText::new()
            .text("A ")
            .span("living note", InlineStyle::default().italic())
            .finish(),
    );
    text_area(id).state(state.downgrade())
}
```

`format_selection` adds persistent formatting. `.decorations(...)` on the input
adds a temporary style layer after stored formatting, suitable for syntax or
search overlays. Temporary decorations do not enter document history. A
read-only input uses `.accepts_input(false)` and can still provide selection and
hit testing.

For display without editor state, take `state.rich_text_snapshot()` and use the
result as an ordinary child. Text and authored marks stay together; the snapshot
does not include temporary syntax or search decorations.
This presentation snapshot requests a contiguous string, cached once per text
snapshot by the default `Document` backend. Keep native document queries in hot
editing paths when a flat presentation value is unnecessary.

```rust
use gpui::{App, Entity, IntoElement, ParentElement, div};
use gpui_ce_elements::editable_text::EditableTextState;

fn note_reader(state: &Entity<EditableTextState>, cx: &App) -> impl IntoElement {
    div().child(state.read(cx).rich_text_snapshot())
}
```

Compose headings, paragraphs, tasks, and code blocks with native GPUI containers.
Each block can choose its inherited font, spacing, controls, and editing policy.
The same rich-text value initializes an editor or renders directly in a reader;
neither requires a separate markup representation. A document application owns
its block model and cross-block commands above these primitives.

For rich paste or a command that inserts a fragment, use `replace_rich_text`.
It maps surrounding formatting, appends the fragment's marks, and places the
caret after the fragment in one undoable operation. Imported explicit properties
win; omitted properties inherit the mapped destination formatting.

```rust
use gpui::Context;
use gpui_ce_elements::{
    editable_text::EditableTextState,
    rich_text::{ChangeError, InlineStyle, RichText},
};

fn insert_emphasis(
    state: &mut EditableTextState,
    cx: &mut Context<EditableTextState>,
) -> Result<(), ChangeError> {
    let range = state.selection().range();
    let fragment = RichText::new()
        .span("a new thought", InlineStyle::default().italic())
        .finish();
    state.replace_rich_text(range, fragment, cx)
}
```

## Prepare an atomic edit

All replacement ranges refer to the original UTF-8 snapshot. An explicitly
supplied selection refers to the resulting document. Preparing a batch validates
bounds, scalar boundaries, overlap, and selection before application.

```rust
use gpui_ce_elements::rich_text::{Document, Selection};

let mut document = Document::new("hello café");
let old = document.clone();
let transaction = document.transaction()
    .replace(0..5, "Hello")
    .replace(document.len_bytes()..document.len_bytes(), "!")
    .selection(Selection::new(12, 12))
    .build()?;
document.apply(&transaction)?;
assert_eq!(old.as_str(), "hello café");
assert_eq!(document.as_str(), "Hello café!");
# Ok::<(), gpui_ce_elements::rich_text::ChangeError>(())
```

Document transactions are bound to the exact snapshot, including forked
snapshots with the same numeric revision. Reapplying one after the document
changes fails. Selection stores an anchor and a head, preserving direction
without a reversed Rust range.
A caret defaults to `After` at both endpoints, keeping it after typed text;
nonempty selections include insertions at both range boundaries by default.

For a live input, start with `state.transaction()` and commit with
`state.dispatch(&transaction, cx)`. That builder additionally binds the
transaction to the field and its text/formatting generation. Moving the caret
alone does not invalidate it: an explicit post-edit selection takes effect at
commit, while an omitted selection maps the current selection through the edits.

`dispatch_with_styles` accepts the complete persistent style set in post-edit
coordinates. Text, selection, and formatting commit as one undo operation. All
coordinates are checked before any of them changes:

```rust
use gpui::Context;
use gpui_ce_elements::{
    editable_text::EditableTextState,
    rich_text::{Affinity, ChangeError, InlineStyle, RangeSet, Selection, Span},
};

fn replace_with_heading(
    state: &mut EditableTextState,
    cx: &mut Context<EditableTextState>,
) -> Result<(), ChangeError> {
    let transaction = state.transaction()
        .replace(0..state.len_bytes(), "Hello")
        .selection(Selection::new(5, 5))
        .build()?;
    let styles = RangeSet::new([Span::new(
        0..5, Affinity::Before, Affinity::After,
        InlineStyle::default().bold(),
    )]);
    state.dispatch_with_styles(&transaction, styles, cx)
}
```

## Keep semantics typed

An annotation's payload can be any Rust value. The generic range index shares
payloads through mapping without requiring `T: Clone`.

```rust
use gpui_ce_elements::rich_text::{Affinity, Document, RangeSet, Span};

struct LinkTarget { url: String }
let document = Document::new("Read the guide");
let links = RangeSet::try_new(&document, [Span::new(
    9..14, Affinity::After, Affinity::Before,
    LinkTarget { url: "https://example.com/guide".into() },
)])?;
assert_eq!(links.hit(10).next().unwrap().value().url,
           "https://example.com/guide");
# Ok::<(), gpui_ce_elements::rich_text::RangeError>(())
```

The range set does not retain a document or revision. Keep it paired with its
source snapshot and map it through that snapshot's `ChangeSet`. For asynchronous
parsing in an editor, capture `EditableTextState::revision()` and discard results
if that field's revision has changed before installing decorations. This editor
generation advances through undo and redo; a bare `Document` revision is local
to its snapshot branch.

`Before` stays before inserted text at an endpoint; `After` stays after it.
Formatting that grows around typing typically uses `Before` at its start and
`After` at its end. A diagnostic that should exclude boundary insertions can use
the opposite affinities. Deleted nonempty annotations drop when their endpoints
collapse or cross. Explicit point annotations remain useful for pending
formatting and source anchors.

For read-only text, `.into_element().id("links").on_click_byte(...)` exposes a
typed `RichTextClick` with mouse-down and mouse-up byte offsets. Capture a
`RangeSet<LinkTarget>` in that callback and require both offsets to hit the same
link before activating it. This keeps link targets and diagnostic metadata out
of the style model. `.on_hover_byte(...)` reports `Some(byte)` over shaped text
and `None` outside it; both callbacks use the same wrapped layout as painting.

## Run the studio

```sh
cargo run -p gpui_ce_wgpu --features test-support --example rich_text_studio
```

Render the same GPUI view without opening a window:

```sh
cargo run -p gpui_ce_wgpu --features test-support --example rich_text_studio -- \
  --headless --size 1280 820 --output /tmp/gpui-rich-text-studio.png
```

Add `--read` to start with the read-only page. The native window also has an
Edit/Read toggle.

The studio is a Notion-style WYSIWYG page with editable headings, formatted
paragraphs, task rows, and a code block. Its Edit/Read toggle renders the same
current content and authored marks through ordinary rich-text children. Code
colors use a small token adapter; no production syntax or markup parser is bundled.

## Performance and extension boundaries

Cloning a `Document` or `RangeSet` shares immutable storage. Native document
edits, line queries, and byte/UTF-16 conversion use the summarized text tree.
`Document::as_str()` and `shared_string()` are contiguous compatibility views:
their first call per snapshot costs a full-document copy. Prefer `chunks`,
`slice`, and indexed line queries in hot paths.

Generic range mapping currently visits every annotation and rebuilds its
coordinate index; it is not logarithmic merely because text storage is a tree.
Cold text layout can visit every paragraph. Inline widgets, hidden markup,
inlays, folding, collaboration, and a rich accessibility document tree need
additional projections; coloring source ranges does not provide them.

See [the architecture](rich-text-architecture.md),
[implementation comparisons](rich-text-comparisons.md), and
[verification results](rich-text-verification.md) for the measured behavior and
remaining boundaries.
