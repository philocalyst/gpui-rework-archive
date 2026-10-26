# 09 — Text: an inline formatting context, not a styled string

Status: **normative text contract**. Public spellings that belong on the ladder live in
[07 §19](07-the-ladder.md). Color of glyphs and decorations is [runtime/color.md](runtime/color.md).
Selection, IME, and FlowIndex remain [06](06-cross-cutting.md). Per-glyph kinetic typography remains
a wall ([05 §14.1](05-one-register.md)). Implementation substrate: **Parley** (Linebender) —
its shaping/bidi/styled-run pipeline and inline-box runs are the placeholder seam this
contract requires; the T-gates bind the contract regardless of substrate, and Parley gaps
(hanging punctuation, wrap-style tuning) are upstream work or documented schema holes, never
overlays.

The law:

> **Text is one inline formatting context.** Glyphs, spacing, decorations, and replaced atoms
> occupy the same line boxes, share the same caret/hit-test, and damage through the same
> obligation mask. A chip is a placeholder in that context. It is never an overlay.

That un-walls hole 13. The missing piece was never reactivity. It was a text-system contract
GPUI does not have yet: placeholder runs, a decorating-box model, and a style schema that can
name every CSS text effect without dumping eighty fields onto every `div`.

---

## 0 · What ships today (honest)

[`TextStyle`](../../crates/gpui/src/style.rs) is a flat bag:

| Present | Missing vs CSS |
|---|---|
| color, background_color | fill as `Background` (gradient / clip-text), stroke, mix-blend, text-shadow |
| family, fallbacks, size, weight, style, `FontFeatures` | stretch, optical-sizing, variations, kerning, synthesis, `font-variant-*`, `font-palette`, `font-size-adjust` |
| line_height, letter_spacing | word-spacing, text-indent, hanging-punctuation, line-padding, text-autospace, CJK `text-spacing-trim`, tab-size, leading-trim |
| underline (thickness, color, wavy), strikethrough (thickness, color) | overline; solid/double/dotted/dashed; offset; position; skip-ink / skip-spaces / skip-box; emphasis marks; spelling/grammar decorations as layers |
| white_space: normal \| nowrap | pre / pre-wrap / pre-line / break-spaces; Level 4 collapse/trim/wrap longhands |
| text_overflow truncate start/middle/end, line_clamp | `text-wrap: balance \| pretty \| stable`, hyphens, word-break, line-break, overflow-wrap, orphans/widows |
| text_align: left \| center \| right | start/end, justify, text-align-last, text-justify |
| text_transform (byte-length preserving) | presentation mapping table for editors; `full-width` / `full-size-kana` |
| — | writing-mode, direction, unicode-bidi, text-orientation, ruby |
| — | inline padding/margin, vertical-align, first-line / first-letter |
| — | **placeholder / object-replacement runs** |

[`DecorationRun`](../../crates/gpui/src/text_system/line.rs) is color + background + underline +
strikethrough on a UTF-8 byte range. There is no placeholder run, no decoration *layer*, no
skip-ink, no shadow. Shaping already carries `letter_spacing` on `FontRun`. Line height is a
single metric applied after wrap — not CSS's strut / leading-trim model.

That is a code editor's paint bag, stretched into a UI toolkit. It is not CSS Text.

---

## 1 · Three style sheets, one IFC

CSS looks like one `style=` attribute. It is not. Mixing paragraph wrap policy into a bold run
is how GPUI's `TextStyle` got stuck. Split the schema the way the modules already split:

| Sheet | Lives on | Invalidates | Examples |
|---|---|---|---|
| **Font / shape** | character / mark | reshape | family, size, weight, features, variations, stretch, kerning, `text-transform`, writing-mode, orientation |
| **Paragraph / wrap** | block / IFC root | rewrap, realign | white-space, wrap-style, hyphens, word/line-break, indent, hanging-punct, tab-size, align, justify, line-height, autospace |
| **Paint / decoration** | decorating box *or* mark | repaint (skip-ink may sample glyph coverage) | fill, stroke, shadow, underline family, emphasis, run background |

Plus one layout object that is not a style field:

| Object | Lives on | Invalidates | Examples |
|---|---|---|---|
| **Atom / placeholder** | one U+FFFC in the stream | rewrap + child layout | width, height, baseline, `vertical-align`, side bearings, atomic break, skip-decoration |

Each field in the generated schema declares the same obligation metadata as
[style/README.md](style/README.md): `shape | wrap | align | paint | composite | hit | a11y`.
A color change does not reshape. A tracking change does. An underline-offset change does not
wrap. `font-size` does. Skip-ink samples coverage at paint; it does not change advances.

**Do not put all of this on `Styled`.** Fluent methods exist for the Tailwind 80% (§7). The
rest is schema fields, set by `refine_text` / `mark` / paragraph builders. Adding
`.text_decoration_skip_ink_all()` as a public method is a failure of taste, not completeness.

---

## 2 · The CSS coverage map

This is the completeness contract. "Support the full range of effects CSS can provide" means
every row is either **fluent**, **schema**, **later**, or a named **wall** — never an
undocumented overlay hack.

### 2.1 Fonts ([CSS Fonts 4](https://www.w3.org/TR/css-fonts-4/))

| Property | Status | Obligation | Notes |
|---|---|---|---|
| `font-family`, `font-size`, `font-weight`, `font-style` | fluent (exists) | shape | Generic families are first-class: `Family::Sans \| Serif \| Mono \| Ui \| Emoji \| Math` (Bevy `FontCx` / CSS Fonts 4). Then a named face or `asset!(…)`. Fallback lists stay schema. Type scale is `rems()` (root `font_size: rems(1.)`, Slint `relative-font-size`). |
| `font-feature-settings` | fluent `font_features` (exists) | shape | Keep OpenType tags; add named helpers `tabular_nums`, `oldstyle_nums`, `ligatures(false)` |
| `font-fallbacks` | schema (exists) | shape | |
| `font-stretch` / `font-width` | schema | shape | Needed for variable fonts even if nobody writes `condensed` |
| `font-optical-sizing` | schema | shape | Default `auto`; `opsz` axis follows `font-size` |
| `font-variation-settings` | schema | shape | Arbitrary axes; `wght`/`ital`/`wdth`/`opsz` prefer the high-level properties |
| `font-kerning` | schema | shape | `auto \| normal \| none` |
| `font-synthesis` | schema | shape | Fake bold/italic policy; default allow |
| `font-variant-caps/numeric/east-asian/ligatures/alternates/emoji` | schema + a few fluent (`tabular_nums`, `small_caps`) | shape | Lower to features; do not invent a second feature API |
| `font-size-adjust` | later | shape | |
| `font-palette` | later | paint | COLRv1; needed for emoji palettes in dark mode |
| `font-language-override` | later | shape | |
| `-webkit-font-smoothing` | not a CSS property; **platform policy** | paint | macOS dilation already exists and is luminance-keyed ([color](runtime/color.md) §6) |

### 2.2 Spacing and indent ([CSS Text 4](https://drafts.csswg.org/css-text-4/) §8–9)

This is the section the current API most under-sells. Spacing is not "letter-spacing plus
line-height." It is a stack of independent adjustments applied **after shaping**, in a fixed
order, some of which hang *outside* the measure.

| Property | Status | Obligation | What it actually does |
|---|---|---|---|
| `letter-spacing` | fluent (exists) | wrap | Extra space **between typographic character units**, after HarfBuzz. Not kern. Not applied inside an atom. Hanging glyphs still receive it. |
| `word-spacing` | fluent + schema | wrap | Extra space on word-separator advances (`U+0020` and other Zs after collapse). Justification *adds more* on top. |
| `line-height` | fluent (exists) | wrap / align | CSS strut: half-leading above/below the content box, not "multiply after wrap and hope." See §3. |
| `line-padding` | schema | wrap | Start/end padding *of each line box*, used by CJK and by hanging-punct interaction. |
| `text-indent` | fluent `indent` | wrap | Length, `%`, `hanging`, `each-line`. Inherited. Reset on inner IFC roots (inline-block / atom containers). |
| `hanging-punctuation` | schema `hanging_punct` | wrap | `none \| first \| last \| force-end \| allow-end` (combinable). Hangable glyphs are **not measured for fit or alignment**; they are ink overflow unless the field is editable, in which case they may be scrollable overflow. Padding on the inline edge prevents hanging. |
| `tab-size` | schema | wrap | Number of spaces or a length. Only meaningful with `white-space` that preserves tabs. |
| `text-autospace` | schema | wrap | Insert/remove space between CJK and non-CJK. Off by default for code; on for prose via a paragraph role. |
| `text-spacing-trim` | schema | wrap | CJK punctuation fullwidth → halfwidth at line edges / adjacent pairs. |
| `text-spacing` | shorthand | wrap | Autospace + trim. |
| leading-trim / `text-box` | schema | wrap | Trim leading at the first/last line so a heading sits on the grid. CSS Inline 3. Needs **font-metrics** (cap-height, x-height, ascent, descent) at the used size — Slint `font-metrics`. Same metrics align `icon()` to a label's cap-height. |

**Order of operations** (matches CSS Text 4 §2.3, simplified):

1. Transform (`text-transform`, `word-space-transform`) — presentation only; see §8.
2. White-space collapse / trim / tab expansion.
3. Shape (HarfBuzz / Core Text / DirectWrite / cosmic-text) with features, variations, kerning.
4. Letter-spacing, word-spacing, autospace, spacing-trim.
5. Line breaking (including hyphenation and wrap-style). Atoms are unbreakable unless marked
   otherwise.
6. Hanging punctuation + indent applied to the chosen breaks.
7. Alignment / justification (distributes *additional* space; does not undo hanging).
8. Paint.

Kerning is inside step 3. Tracking is step 4. They must not be implemented as the same kern
attribute. (macOS currently shoves letter-spacing through `kCTKernAttributeName`. That is a
known lie; it breaks with ligatures and RTL.)

**Atoms and spacing.** A placeholder has `margin-inline` (side bearings) in the IFC, not CSS
margin on a sibling `div`. Letter-spacing does not apply across the object-replacement
character. Word-spacing does not. Justification may add space *around* an atom according to
`text-justify` (inter-word: yes if the atom sits on a word boundary; inter-character: no).

### 2.3 White space, wrapping, hyphenation (CSS Text 4 §4–6)

| Property | Status | Obligation |
|---|---|---|
| `white-space` shorthand | fluent: `whitespace_normal/nowrap/pre/pre_wrap` | wrap |
| `white-space-collapse`, `white-space-trim`, `text-wrap-mode` | schema longhands | wrap |
| `text-wrap-style`: `auto \| balance \| pretty \| stable \| avoid-orphans` | fluent `text_balance` / `text_pretty` / `text_stable` | wrap |
| `word-break`, `line-break`, `overflow-wrap` | schema | wrap |
| `hyphens`, `hyphenate-character`, `hyphenate-limit-chars` | schema | wrap |
| `wrap-before/after/inside` | later | wrap |
| `line-clamp` / `max-lines` / block-ellipsis | fluent `line_clamp` (exists) | wrap + paint |
| `text-overflow` | fluent (exists) | paint |

`text-wrap: stable` is required for contenteditable: lines above the caret must not reflow
while the user types. `balance` is for titles (UA may limit to N lines). `pretty` is a quality
hint, never a layout-mode fork with a different public type.

Hyphenation requires a locale on the paragraph (`lang`). No locale → `hyphens: auto` is a
no-op, not English-by-default.

### 2.4 Alignment and justification (CSS Text 4 §7)

| Property | Status | Obligation |
|---|---|---|
| `text-align`: `start \| end \| left \| right \| center \| justify \| match-parent` | fluent; add `text_start/end/justify` | align |
| `text-align-last` | schema | align |
| `text-justify`: `auto \| none \| inter-word \| inter-character` | schema | align |
| `vertical-align` on inlines and atoms | schema + atom builder | align |

Logical `start`/`end` follow `direction`. Physical `left`/`right` stay for code editors that
want them regardless of bidi.

### 2.5 Decorations ([CSS Text Decor 4](https://drafts.csswg.org/css-text-decor-4/))

GPUI's underline-on-the-run is the wrong model. CSS paints decorations from a **decorating
box**. A paragraph that is underlined stays underlined under a nested red span; the span may
change *color of text*, not the underline's existence, unless it sets `text-decoration` itself
(and even then skip-ink / skip-box interact).

| Property | Status | Obligation |
|---|---|---|
| `text-decoration-line`: underline, overline, line-through, plus spelling/grammar | fluent + layers | paint |
| `text-decoration-style`: solid, double, dotted, dashed, wavy | fluent (solid/wavy exist; add the rest) | paint |
| `text-decoration-color`, `thickness` | fluent (exists) | paint |
| `text-underline-offset`, `text-underline-position` | fluent `underline_offset`, schema position | paint |
| `text-decoration-skip-ink`: `auto \| none \| all` | schema | paint (coverage) |
| `text-decoration-skip-spaces`, `skip-box`, `skip-self`, `skip-inset` | schema | paint |
| `text-emphasis-style/color/position` | schema | paint + a little wrap (emphasis may grow line box) |
| `text-shadow` | fluent `text_shadow` (list) | paint; ink overflow |
| `::spelling-error` / `::grammar-error` | decoration *kinds*, not pseudos | paint |

**Layers, not flags.** Find-in-page, composition underline, link underline, spelling wavy, and
a user highlight can all cover the same bytes. They stack in a documented order (document
style < semantic highlight < IME < selection < find). A `DecorationRun` becomes an interval
tree of layers, not a single optional underline.

Skip-ink: interrupt the decoration where it would intersect glyph ink, with a small pad.
`all` is the CJK-friendly force. Atoms with `skip-box` punch a hole in ancestor decorations
across their placeholder width (the CSS reason chips don't wear the paragraph's underline
unless you ask).

### 2.6 Fill, stroke, clip-text, blend

CSS gets these from Fill/Stroke, `background-clip: text`, and `filter` / `mix-blend-mode`.
They are **paint on the glyph coverage**, not extra elements.

| Effect | Status | Obligation |
|---|---|---|
| Solid fill (`color`) | fluent (exists) | paint |
| Gradient / pattern fill | schema `fill: Background` | paint |
| `background-clip: text` | `fill` from an ancestor background; same primitive | paint |
| Text stroke (`-webkit-text-stroke` / `stroke`) | schema `stroke: Stroke { width, color, join }` | paint; ink overflow |
| `paint-order` fill vs stroke | schema | paint |
| `text-shadow` | §2.5 | paint |
| Per-run `opacity` / `fade_out` | schema (HighlightStyle already has fade_out) | paint / composite |
| `mix-blend-mode` on a text box | later (composite isolation) | composite |
| Per-glyph animated fill | **wall** 05 §14.1 | — |

Stroke wider than hairline is ink overflow. It does not change wrap. A title with a 4px
stroke still breaks at the same points as the unstroked text.

### 2.7 Writing mode, bidi, ruby

| Property | Status | Obligation |
|---|---|---|
| `direction`, `unicode-bidi` | schema | shape + wrap |
| `writing-mode`: `horizontal-tb \| vertical-rl \| vertical-lr` | schema | shape + wrap + layout axis |
| `text-orientation` | schema | shape |
| `text-combine-upright` | later | shape |
| CSS Ruby | later | wrap (own line boxes) |

Vertical text is a real product need (CJK UI, spine labels), not a curiosity. It flips the
IFC's inline axis; Taffy sees a different `writing-mode` on the block. Atoms in vertical text
use the same placeholder metrics with axes swapped.

### 2.8 First-line, first-letter, inline boxes

| Feature | Status | Notes |
|---|---|---|
| `::first-line` | schema layer on the paragraph | Style only (font/paint/spacing that doesn't change the box tree). Applied to the first line box after wrap. |
| `::first-letter` | later | Can float and clusters punctuation; it *does* change the box tree. |
| Inline padding / border / margin | schema on marked ranges and on atoms | Creates unbreakable extra at edges; hanging-punct is disabled across that padding. |
| `box-decoration-break` | later | |

---

## 3 · Line boxes, leading, and the strut

Current GPUI: wrap, then `height = line_height * line_count`, and vertically center glyphs in
that slab (`padding_top = (line_height - ascent - descent) / 2` in `text_system.rs`). That is
a reasonable editor row. It is not CSS.

CSS inline layout:

- Each line box has a **strut** from the paragraph's font + `line-height`.
- Inlines contribute their own content area + half-leading, then `vertical-align`.
- Atoms contribute a placeholder content area + alignment (baseline, middle, text-top, …).
- `text-box-trim` / leading-trim can cut the half-leading on the first and last line so type
  sits on a baseline grid.

v1 implementation that still matches CSS for the cases we ship:

1. Paragraph `line-height` sets the strut (length or unitless multiplier × font-size).
2. A run with a larger font grows that line; a smaller font does not shrink it below the strut
   (CSS normal).
3. Atoms align to the alphabetic baseline by default; `InlineAlign::Middle | TextTop | Sub |
   Super | Offset(Px)` are explicit.
4. Leading-trim is opt-in on headings (`leading_trim(TextBox::TrimBoth)`).

Do not expose "line height means row pitch in a code editor" as a second API. The editor crate
sets `line-height` to a length, uses a monospace strut, and skips trim. Same schema.

---

## 4 · Atoms: object replacement, not overlays

Every mature engine uses U+FFFC plus a placeholder run: Qt `QTextObjectInterface`, Flutter
`WidgetSpan` / `PlaceholderStyle`, SkParagraph `PlaceholderStyle`, AppKit
`NSTextAttachmentViewProvider`, Android `ReplacementSpan`, Lexical `DecoratorNode`, CodeMirror
`Decoration.replace` + `atomicRanges`.

### 4.1 Metrics

```rust,ignore
struct Placeholder {
    width: Px,
    height: Px,
    /// Distance from the placeholder bottom to the alphabetic baseline.
    baseline: Px,
    align: InlineAlign,       // Baseline | Middle | TextTop | TextBottom | Super | Sub | Offset(Px)
    break_mode: AtomBreak,    // Atomic (default) | BreakAfter
    /// Inline-axis bearings. Letter-spacing does not apply inside.
    pad_inline: (Px, Px),
    skip_decoration: bool,    // text-decoration-skip-box
}
```

The child's layout size *is* the placeholder. If the child is an `Entity`, skip-view still
applies; the IFC only needs the size/baseline. A paint-only chip update does not rewrap.

### 4.2 Identity and recycling

Atoms are `List` slots when the document is a `List<Inline>`. Same ladder as rows: identity is
the slot, not a `.key()`. A `Vec<Inline>` of chips is a located error naming `List`, same as
identity widgets in anonymous rows.

Machine-rate: do not mount new `View` trees at 120 Hz inside a paragraph. Recycle the atom
view; or make presence a property (a chip that always exists and whose `opacity`/`max_width`
is wired). Same softening as 07's structure wall.

### 4.3 Hit-test, caret, selection

- One document offset per atom (the replacement character).
- Caret cannot land *inside* the atom; it lands before or after.
- Selection may include the atom; copy asks the atom for a payload (`text/plain` fallback,
  optional richer).
- FlowIndex counts the replacement as one unit (06).
- IME never composes inside an atom.
- Nested native text fields inside an atom are a puncture: one Selectable, platform IME/undo
  for that pocket (07 §18.2). Don't do this in v1 if you can avoid it.

### 4.4 Forbidden

`place_in` / overlay to fake a mention chip. Absolutely positioned labels on top of a shaped
string will miss wrap, bidi, skip-ink, copy, and VoiceOver. That is the hole 13 anti-pattern.

---

## 5 · Documents, marks, and the two authoring modes

### 5.1 Simple UI text (no document)

```rust,ignore
text("Settings")
    .text_sm()
    .text_muted()
    .tracking_tight()
    .underline()
    .underline_offset(2)
```

This is today's `Styled` path. The element *is* the IFC root. No `List`, no atoms. Completeness
comes from the schema (§2) behind the fluent subset (§7). A string is the content of `text` /
`button` / other text leaves — not `IntoChildren` for `div` (07 §2).

### 5.2 Rich inline (chips, mixed styles)

The document is ordinary ladder state. The view does not wrap every word in a span.

```rust,ignore
enum Piece {
    Text(String),
    Mention(UserId),
    Emoji(EmojiId),
}

impl View for Composer {
    fn view(&self) -> impl Element + '_ {
        rich(&self.pieces)
            .atom(Composer::chip)
            .align(TextAlign::Start)
            .wrap(Wrap::Pretty)
    }
}

impl Composer {
    fn chip(&self, piece: &Piece) -> Option<impl Element + '_> {
        match piece {
            Piece::Mention(id) => Some(mention_pill(&self.users[id]).atomic().skip_decoration()),
            Piece::Emoji(id) => Some(emoji_atom(*id)),
            Piece::Text(_) => None, // kernel paints text
        }
    }
}
```

`.atom(ViewFn)` is `.children(&list, Row::view)` for the IFC: one mapper, `None` means "this
slot is text, not a view." `Piece::Text` may still carry marks via a side table:

```rust,ignore
self.pieces.mark(range, Mark::emphasis().color(accent));
self.pieces.mark(range, Mark::underline());
```

Marks are interval annotations, not a span tree. Nested HTML-style `<b><i>…` is a serialization
problem for HTML export, not a runtime tree. (Lexical's mistake to avoid: decorator nodes and
text nodes as one recursive element tree that the UI framework diffs.)

### 5.3 Editor crate

A code/prose editor owns a rope + a style map + a decoration map (syntax, diagnostics, find,
selection). It is a consumer of this contract, not a second text system. History for typing
stays in the editor crate; `gpui_history` wraps it as a Track (08). The kernel never sees
NSAttributedString.

The byte-offset law remains: **document UTF-8 indices are the coordinate system.** Presentation
transforms (`text-transform`, bidi display reordering, hyphenation character) keep a mapping
table so hit-test and caret do not drift. Today's "uppercase but preserve UTF-8 length" is a
lossy approximation of that law; the mapping table is the honest version.

---

## 6 · Pipeline

```text
document + marks + atoms
        │
        ▼
   [transform / collapse / tabs]     presentation, mapping table
        │
        ▼
   [shape]                           font / features / variations / bidi
        │
        ▼
   [measure atoms]                   child layout → Placeholder
        │
        ▼
   [space]                           tracking, word-spacing, autospace, trim
        │
        ▼
   [wrap]                            breaks, hyphens, wrap-style, indent, hang
        │
        ▼
   [align / justify]
        │
        ▼
   [paint]                           decoration layers, skip-ink, fill/stroke/shadow
                                     then glyph coverage, then atoms
```

Damage:

- A mark that only changes fill → paint the glyph range.
- Tracking / font-size / atom size → rewrap that paragraph (not the document).
- Paragraph wrap-style → rewrap that paragraph.
- Skip-ink / underline-offset → paint.
- macOS font smoothing dilation depends on luminance ([color](runtime/color.md)): a *large*
  lightness change may miss the atlas key and reshape glyphs. Count it. Do not reshape on
  every tint.

Paragraph isolation is the unit of text work. 07 §18.2 already says this.

---

## 7 · Fluent surface (the 80%)

Add these. Stop before the schema becomes a method soup.

**Already there:** size/weight/italic, color, text background, underline / line-through,
decoration color / wavy / thickness, family, features, line-height, letter-spacing, align
left/center/right, truncate, line-clamp, whitespace normal/nowrap, text-transform.

**Add:**

| Method | CSS |
|---|---|
| `tracking_tighter/tight/normal/wide/widest` | letter-spacing scale (keep `letter_spacing(px)`) |
| `word_spacing(Px)` | word-spacing |
| `indent(Length)` / `indent_hanging(Length)` | text-indent |
| `text_start` / `text_end` / `text_justify` | text-align |
| `underline_offset(Px)` | text-underline-offset |
| `text_decoration_dotted/dashed/double` | text-decoration-style |
| `text_shadow(Shadow)` | text-shadow |
| `tabular_nums` / `lining_nums` / `small_caps` | font-variant-numeric/caps |
| `hyphens_auto` / `hyphens_none` | hyphens |
| `text_balance` / `text_pretty` / `text_stable` | text-wrap-style |
| `whitespace_pre` / `whitespace_pre_wrap` | white-space |
| `fill(Background)` | gradient text |
| `stroke(Px, Color)` | text-stroke |

**Do not add as fluent:** skip-ink, hanging-punctuation, autospace, spacing-trim, emphasis,
writing-mode, hyphenate-limit, text-align-last, font-variation axes, first-line. Those are
schema / paragraph builder methods (`p(...).hanging_punct(Hang::First | Hang::Last)`).

---

## 8 · Editor and a11y laws that constrain the CSS

1. **Indices are document bytes**, not display clusters. Transforms, hyphenation, and bidi
   produce a mapping, not a second string that APIs accept.
2. **IME owns a third range** on the focused atom (07 §18.2). Decoration layers must reserve
   a slot for the composition underline.
3. **Copy** materialises a `StaticRange` at the turn boundary. Atoms contribute replacement
   text. Off-screen copy goes through FlowIndex, bounded.
4. **VoiceOver/NVDA:** the IFC is one static text node plus embedded atoms as children, in
   reading order. A chip without an accessible name is a gate failure. Do not expose U+FFFC.
5. **Secret fields:** redacted deltas (H9); no subpixel atlas sharing across privacy
   boundaries.
6. **`text-transform` in an editor** is a view-of-document, not a buffer mutation. The current
   length-preserving Unicode hack stays as a *fallback* for the simple `Styled` path where
   there is no mapping table because there is no editor.

---

## 9 · What remains a wall

- **Per-glyph kinetic typography** (05 §14.1). Run-level animated *fill* (a gradient that
  moves, a color mark that transitions) is not that wall. Per-glyph scatter is.
- **`::first-letter` as a float.** Later.
- **Ruby.** Later.
- **CSS fragmentation / print page-breaks.** Later (Qt's `QTextFrame` lesson: don't start here).
- **Web-font download FSM.** Media-shaped, not text-shaped; reuse [runtime/media.md](runtime/media.md).
- **Mounting new atom `View` trees at machine rate.** Recycle or presence-as-property.

Hole 13 is no longer a reactivity wall. It is T1 below.

---

## 10 · Gates

- **T0 — Schema completeness.** Every row in §2 is fluent, schema, later, or wall. Tests
  enumerate fields and check obligation metadata (same as style/README).
- **T1 — Placeholder IFC.** A paragraph with text + two chips wraps, copies, selects, and
  speaks correctly across bidi and a soft wrap between chips. Screenshot oracle. No
  `place_in`.
- **T2 — Decorating box.** Paragraph underline continues under a color mark and skips a
  `skip_decoration` chip; skip-ink does not collide with descenders on a fixture font.
- **T3 — Spacing stack.** letter-spacing, word-spacing, indent, hanging-punct, and
  justify-inter-word compose; a hanging period is ink overflow (no scrollbar) in a read-only
  paragraph and scrollable in an editor fixture.
- **T4 — Wrap styles.** `stable` does not reflow lines above the caret under typing; `balance`
  on a 3-line title matches a pinned screenshot.
- **T5 — Fill/stroke/shadow.** Gradient fill and hairline stroke do not change wrap; damage
  is paint-only.
- **T6 — Paragraph isolation.** An edit in paragraph *k* of N does not reshape *k±1*
  (existing 07 law, now with atoms).
- **T7 — Cross-backend paint.** Skip-ink, wavy, and text-shadow goldens on Mac / Win / wgpu
  with stated perceptual tolerance (color encoding is runtime/color.md C3).

WPT CSS Text / Text Decor subsets are oracles where they don't assume the CSS box tree. We
are not a browser; we are claiming the *effects*, not `display: inline` as a general layout
mode.
