+++
aliases = ["elements/text-input.html", "elements/text.html", "graphics/text-system.html", "guide/elements/text-input/", "guide/elements/text/", "guide/graphics/text-system/"]
title = "Preserve text boundaries"
description = "Distinguish byte offsets, graphemes, shaping clusters, and native input ranges."
weight = 80
+++

A Rust string is UTF-8. Text layout indices generally refer to its bytes, not
to a count of displayed characters. Native text input contracts can use UTF-16
ranges. Convert where the input contract requires it.

## Do not slice at an arbitrary offset

A byte index must lie on a UTF-8 boundary before it can slice a string. A valid
byte boundary can still lie inside a user-visible grapheme, such as a base
letter followed by combining marks. Use grapheme-aware movement for selection
and editing; do not increment a byte index to move one character.

[Unicode Standard Annex #29](https://www.unicode.org/reports/tr29/) defines text
segmentation. [Text shaping](https://en.wikipedia.org/wiki/Complex_text_layout)
adds another layer: the font and script can map several scalars to a cluster
of glyphs. Glyph positions do not supply a replacement string-index scheme.

## Give wrapping a constraint

The [text walkthrough](@/examples/text.md) constrains a paragraph and changes
its size and line height. Text styling is inherited by children. Mixed-style
runs must cover the intended UTF-8 range with valid boundaries.

Font fallback depends on the faces available to the platform. A missing glyph
is a resource problem even when the string and layout code are valid. The
browser previews bundle a Latin font; they do not promise complete script or
emoji coverage.

## Map a pointer to the shaped text

The [hit-testing walkthrough](@/examples/text-hit-testing.md) shares the layout
from `StyledText`, maps a pointer position to a byte index, and paints a cluster
marker at the corresponding position. Pixel queries use window coordinates and
require measurement and prepaint to have finished. Querying them while building
the element tree is too early.

`TextLayout::index_for_position` distinguishes a cluster hit from the nearest
visual edge outside a line. Keeping that distinction lets a link require a real
hit while a selection drag can continue beyond the line. Cluster positions also
have soft-wrap and bidirectional-text behavior; a display marker supplies only
part of an editor's caret policy.

## Start an editor from its state and input contract

The checkout's `gpui_ce_elements::editable_text` module supplies single-line
`text_input` and multiline `text_area` elements. Both use `EditableTextState` for
text, selection, composition, and undo history; `UnicodeTextStorage` defines
the storage boundary. Read those APIs locally with:

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
> Validate both the string boundary and the editor's movement policy. A valid
> UTF-8 byte boundary can still split a combining sequence. Native composition
> ranges may use UTF-16, so carry out the required conversion at the input boundary.
