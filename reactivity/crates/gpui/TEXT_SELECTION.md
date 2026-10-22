# Text selection and editing

`Win::selection`, `select`, `replace`, `type_text`, and `backspace` operate on
the ordinary live input target. UTF-8 offsets must be extended-grapheme
boundaries in the current logical source. Explicit ranges address the current
source; they do not bind a previously observed document revision. Reversed
ranges are accepted. Invalid endpoints fail before changing source or selection.

Typing replaces the current range. Backspace removes the range, or the complete
preceding grapheme at a caret, including a CRLF or emoji ZWJ sequence. Edits can
join graphemes across the replacement: the resulting caret moves to the first
boundary at or after the inserted end in the complete resulting string. For
example, deleting the Control in `a\u{0001}\u{0301}` produces `a\u{0301}` with
the caret after that entire grapheme. Accessibility `SetValue` replaces the full
current source through this same writer and post-admission reconciliation.

An input without an active selection reports a collapsed caret at its end.
Logical selection queries and edits remain available after a presentation
failure. An admitted source edit retains its new logical selection even if its
glyphs cannot be presented; backspace can repair it. Rejected writes preserve
the previous state. Failed source reconciliation revokes selection authority.
The post-admission caret intent runs before equal-output and metadata-only
early returns, so replacing a selected range by identical bytes still collapses
the range correctly.

Pointer press places a caret; movement extends a pressed input's selection,
including beyond the input within the window. Leaving, cancellation, wheel, or
release consumes that press. Visual left/right keys use the canonical shaped
caret map; Shift preserves the anchor. A non-Shift arrow collapses a range to
the physical left/right endpoint, GPUI's explicit policy. Geometry operations
require an acknowledged current presentation; they cannot combine new source
with old coordinates. Logical `select` does not change keyboard focus.
This includes selection-only pending frames: a drag movement received before
acknowledgement is rejected and needs a fresh movement after acknowledgement.

Selection backgrounds and focused collapsed carets are real scene commands.
Both use the input's transform, text padding, and clip. Caret ink follows the
same shared foreground paint row as its glyphs, so color-source updates retain
the ordinary paint-bank fast path. Native pointer moves request redraw when
they publish a changed selection; idle moves remain idle.

On 64-bit targets there is one 40-byte cold `Editing` allocation per active
window and one 8-byte optional slot in the already cold `Metadata`. The same
allocation is reused when activation moves between inputs. A one-word
immutable text lease, node identity, and source field qualify retained offsets
and prevent allocator-address reuse from reviving old authority. External text
or field replacement revokes the stored range. No fields were added to
`Runtime`, `Node` (40 bytes), or `TextSite` (80 bytes).

Only the active input requests caret geometry in its existing single shaped
layout. Switching inputs releases the previous caret map; ordinary glyph
storage and placement survive. There is no second retained shaped tree or
per-grapheme interaction index. Logical validation and edit repair scan ICU's
grapheme boundaries; replacement copies the current source string. Geometry
queries retain Canvas's byte partitions and allocation-free interval traversal.
Activation can reshape once to add the interaction map. These costs are real;
this slice makes no new SIMD or constant-time editing claim.

This is a usable selection foundation, with explicit remaining browser-level
work: IME composition, clipboard and word-selection commands, vertical/preferred
column navigation, selection autoscroll, caret blinking, cross-window capture,
and accessibility UTF-16 range actions. AccessKit range actions remain
unadvertised; `SetValue` continues to use the proven position-free authority.
