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

For selection, composition, undo, and caret movement, see the editable-text
crate's API and the repository `view_example` application. A text display
element alone does not implement an editor.
