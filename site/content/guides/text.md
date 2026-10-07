+++
aliases = ["elements/text-input.html", "elements/text.html", "graphics/text-system.html", "guide/elements/text-input/", "guide/elements/text/", "guide/graphics/text-system/"]
title = "Preserve text boundaries"
description = "Distinguish byte offsets, graphemes, shaping clusters, and native input ranges."
weight = 80
+++

A Rust `str` is UTF-8, so GPUI `TextLayout` indices are byte offsets into the
original string. A byte offset answers “where in this encoded string?”; it
does not count Unicode scalar values, user-perceived graphemes, shaped clusters,
or glyphs. Some native text-input APIs express ranges as UTF-16 code units.
Convert only at that platform boundary and retain the unit expected by each API.

## Do not slice at an arbitrary offset

A byte index must lie on a UTF-8 boundary before it can slice a string. Even a
valid boundary can split a user-perceived grapheme, such as a base letter from
its combining accent. A grapheme can also map to more than one shaped cluster,
or one cluster to several glyphs. For selection and cursor movement, apply a
grapheme-aware policy; do not add one to a byte index to move one character.

[Unicode Standard Annex #29](https://www.unicode.org/reports/tr29/) defines text
segmentation. [Text shaping](https://en.wikipedia.org/wiki/Complex_text_layout)
adds another layer: the font and script can map several scalars to a cluster
of glyphs. Glyph positions do not supply a replacement string-index scheme.

## Give wrapping a constraint

The [text walkthrough](@/examples/text.md) constrains a paragraph and changes
its font size, line height, and wrapping width. Text style is inherited from
the parent. `StyledText::with_runs` describes byte ranges in the UTF-8 string;
check that run boundaries are valid and that the ranges cover the intended
text before shaping.

Font fallback depends on the faces available to the platform. A missing glyph
is a resource problem even when the string and layout code are valid. The
browser previews bundle a Latin font; they do not promise complete script or
emoji coverage.

## Map a pointer to the shaped text

The [hit-testing walkthrough](@/examples/text-hit-testing.md) shares the
`TextLayout` from `StyledText`, maps a window-space pointer position to a byte
index, then maps that index back to a window-space point for a marker. These
queries require measurement and prepaint to have populated bounds; calling them
while constructing the tree panics because no shaped geometry is available.

`TextLayout::index_for_position` returns `Ok(byte_index)` for a text hit and
`Err(byte_index)` for the nearest visual edge outside a line. A link can accept
only `Ok`; a drag selection can use either branch. The index selects a shaped
cluster start, not an editor caret: soft wraps, bidirectional text, grapheme
movement, affinity, selection, composition, and undo each need additional
policy.

## Start an editor from its state and input contract

The checkout's `gpui_ce_elements::editable_text` module supplies single-line
`text_input` and multiline `text_area` elements. Use these when their editing
model fits; `EditableTextState` owns text, selection, composition, and undo
history, while `UnicodeTextStorage` defines storage access. Read and run the
local example before substituting a display-only `Text` element for an editor:

```sh
cargo doc -p gpui_ce_elements --no-deps --open
cargo run -p gpui_ce_elements --example editable_text
```

For an editor assembled from lower-level input and paint operations, run
`cargo run --example view_example`. Its implementation lives in
[`example_editor.rs`](https://github.com/philocalyst/gpui-ce/blob/593f99f88aa5b17aea0f2f2a0076b747b4f76340/crates/gpui/examples/view_example/example_editor.rs),
with painting in
[`example_editor/paint.rs`](https://github.com/philocalyst/gpui-ce/blob/593f99f88aa5b17aea0f2f2a0076b747b4f76340/crates/gpui/examples/view_example/example_editor/paint.rs).

> [!WARNING]
> Validate both string boundaries and movement policy. A valid UTF-8 byte
> boundary can still split a combining sequence. Native composition ranges may
> use UTF-16; convert at the input boundary and do not store UTF-16 offsets as
> though they were Rust string byte indices.
