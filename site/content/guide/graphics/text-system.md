+++
title = "Text system: fonts, shaping, layout"
description = "Look beneath rendered text: font selection, shaping, measurement, and glyphs."
weight = 26
aliases = ["/graphics/text-system.html"]
[extra]
category = "GRAPHICS"
legacy_source = "gpui-ce-docs/build/html/graphics/text-system.html"
+++

**Text system** is the font-to-pixels pipeline. It turns your strings plus font choices into positioned glyphs you can paint ([crates/gpui/src/text_system.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/text_system.rs)). You describe text, GPUI shapes it, then you paint the result.

```rust
// Ask once for a font id, then reuse it every frame.
// Resolving per frame wastes work, so hold onto this id.
let font = gpui::font("Zed Plex Sans").bold(); // family + weight in one breath
let id: FontId = cx.text_system().resolve_font(&font); // `text_system.rs:149`
let metrics: FontMetrics = cx.text_system().font_metrics(id); // ascent, descent, gaps
```

You sit on top of a sandwich: **TextSystem** is the shared cache, **WindowTextSystem** is the per-window shaper ([crates/gpui/src/text_system.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/text_system.rs)), and **PlatformTextSystem** is the OS backend ([crates/gpui/src/platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform.rs)). You talk to the first two. The OS layer stays behind the curtain.

## Fonts and metrics

**Font** is a descriptor, not a loaded file. It names a family plus weight and style ([crates/gpui/src/text_system.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/text_system.rs)). Build it with `font()` ([crates/gpui/src/text_system.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/text_system.rs)), then add `.bold()` or `.italic()` like you mean it.

Weights are plain numbers: **FontWeight** wraps an `f32` ([crates/gpui/src/text_system.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/text_system.rs)), from `THIN` (100) through `BLACK` (900). Style is **FontStyle**, normal or italic or oblique ([crates/gpui/src/text_system.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/text_system.rs)).

```rust
// Register your bundled bytes once at startup, then list what you have.
// add_fonts takes anything that looks like font data.
cx.text_system().add_fonts(font_bytes); // `text_system.rs:103`
let names = cx.text_system().all_font_names(); // `text_system.rs:89`
cx.text_system().prewarm_fonts(); // `text_system.rs:174`, warm caches pre-paint
```

|  |  |
| --- | --- |
| Call | What it gives you |
| `resolve_font` | Descriptor turns into a reusable `FontId` |
| `add_fonts` | Embedded bytes join the registry |
| `prewarm_fonts` | System caches warm up before first paint |
| `advance` / `ascent` / `cap_height` | Per-size numbers in `text_system.rs:188–293` |

Table 22: Font calls you reach for most days.

> **Tip.** Resolve once per font and keep the `FontId`. Call `prewarm_fonts` before first paint and your first frame stays smooth.

## Shaping pipeline

**Shaping** maps characters to positioned glyphs. Your input is text plus **TextRun** values, each pairing a byte range with a font ([crates/gpui/src/text_system.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/text_system.rs)). Your output is a **LineLayout**, a list of **ShapedRun** values holding **ShapedGlyph** values ([crates/gpui/src/text_system/line_layout.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/text_system/line_layout.rs), `:33`, `:42`).

The pipeline runs in three hops. `shape_line` merges your decoration runs, then calls `layout_line` ([crates/gpui/src/text_system.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/text_system.rs)), which asks the frame cache, which asks the platform on a miss ([crates/gpui/src/text_system/line_layout.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/text_system/line_layout.rs)). You never call the middle hop by hand.

```rust
// Single visual line in, positioned glyphs out.
// Runs say "these bytes use this font" — byte offsets, not glyph counts.
let shaped: ShapedLine = window.text_system().shape_line(
    "Hello".into(), // single line only, no `\n` allowed here
    font_size, // a `Pixels` value like `px(14.)`
    &[text_run], // your `TextRun` slices over the string
    None, // `force_width` grid, or `None` for natural spacing
); // `text_system.rs:423`
```

Need paragraphs? Reach for `shape_text` instead ([crates/gpui/src/text_system.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/text_system.rs)). It splits on `\n`, wraps at your width, and hands back wrapped lines. Shape per visual line, not per document, and your editor stays snappy.

> **Pitfall.** Indexes are UTF-8 byte offsets, not glyph counts. `ShapedGlyph.index`, `TextRun.len`, and `index_for_x` all speak bytes (`line_layout.rs:42`). Split a multibyte character and your cursor lands mid-glyph.

## Hash cache reuse

Editors reshape the same lines every frame. The hash variants skip that repeat work ([crates/gpui/src/text_system.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/text_system.rs), `:832`). They probe an allocation-free cache keyed by `(hash, len)`, and they only build the real string on a miss.

```rust
// Same line, sixtieth frame in a row — skip the shaping bill.
// On a cache hit the returned text is empty by design, so never read `.text`.
let shaped = window.text_system().shape_line_by_hash(
    hash, // `u64` of your line content, you compute it
    "Hello".into(), // materialized only on a miss, empty on a hit
    font_size, // must match the cached size to hit
    &[text_run], // must match the cached runs to hit
    None, // same `force_width` you shaped with
); // `text_system.rs:474`
```

Behind the curtain sit four maps per frame: plain lines, wrapped lines, plus hash-keyed twins ([crates/gpui/src/text_system/line_layout.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/text_system/line_layout.rs)). Each frame swaps current into previous and clears forward (`line_layout.rs:559`). That two-frame rhythm is why stable hashes win big in lists and editors.

One more kindness: `force_width` snaps glyphs to a cell grid for terminal-style columns, and it lifts combining marks onto their base glyph instead of stranding them in a fresh cell (`line_layout.rs:849`). Your accented characters stay glued where they belong.

> **Tip.** Prefer the `_by_hash` variants in editors and lists. Hash the line once, pass it down, and watch re-layout vanish on unchanged rows.

## Painting lines

**ShapedLine** paints itself ([crates/gpui/src/text_system/line.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/text_system/line.rs)). Call `paint` for glyphs and `paint_background` for the highlight wash behind them ([crates/gpui/src/text_system/line.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/text_system/line.rs), `:108`). Wrapped text uses **WrappedLine** with the same pair of verbs ([crates/gpui/src/text_system/line.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/text_system/line.rs)).

```rust
// Paint the wash first, then the glyphs on top.
// Origin is where your line starts, height is your line box.
shaped.paint_background(origin, line_height, &style, &mut window, cx); // `line.rs:108`
shaped.paint(origin, line_height, &style, &mut window, cx); // `line.rs:83`
```

Hit-testing lives on `LineLayout`: `index_for_x` finds the byte index under your cursor, `closest_index_for_x` snaps to the nearest one, `x_for_index` reverses the trip (`crates/gpui/src/text_system/line_layout.rs:58–126`). Glyph layout ignores background-color splits when coalescing **FontRun** values ([crates/gpui/src/text_system.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/text_system.rs)), while decoration painting still honors them. Same line, two views, each correct for its job.

> **Pitfall.** Do not read `.text` after `shape_line_by_hash`. Hits return an empty string on purpose (`text_system.rs:523`). Keep your own copy of the line content.

Where next? Give your lines a home in boxes (`../elements/div.html`), a frame in the scene (`./scene-rendering.html`), or motion between states (`./animation.html`).

## Sources

- `TextSystem`: [crates/gpui/src/text_system.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/text_system.rs); `add_fonts`: `text_system.rs:103`; `resolve_font`: `text_system.rs:149`; `prewarm_fonts`: `text_system.rs:174`
- Metrics helpers: `text_system.rs:188–293`; `WindowTextSystem`: `text_system.rs:390`; `shape_line`: `text_system.rs:423`; `shape_line_by_hash`: `text_system.rs:474`
- `shape_text`: `text_system.rs:544`; `layout_line`: `text_system.rs:683`; `layout_line_by_hash`: `text_system.rs:832`
- `LineLayout`: `text_system/line_layout.rs:16`; `ShapedRun`: `line_layout.rs:33`; `ShapedGlyph`: `line_layout.rs:42`; hit-test: `line_layout.rs:58–126`; `FontRun`: `line_layout.rs:877`
- `ShapedLine`: `text_system/line.rs:43`; `paint`: `line.rs:83`; `paint_background`: `line.rs:108`; `WrappedLine`: `line.rs:267`
- `PlatformTextSystem`: [crates/gpui/src/platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform.rs); `Font`: `text_system.rs:1102`; `font()`: `text_system.rs:1128`
- `FontWeight`: `text_system.rs:936`; `FontStyle`: `text_system.rs:1018`; `TextRun`: `text_system.rs:1036`
