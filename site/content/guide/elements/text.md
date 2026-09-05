+++
title = "Text: plain, styled, clickable"
description = "Put words on the screen, from a simple string to styled and interactive text."
weight = 17
aliases = ["/elements/text.html"]
[extra]
category = "ELEMENTS"
legacy_source = "gpui-ce-docs/build/html/elements/text.html"
+++

If `div` is the box, text is the voice inside it. A plain string becomes a `Text` on its own ([crates/gpui/src/elements/text.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/text.rs)). Reach for `StyledText` when one line wears several outfits. Reach for `InteractiveText` when words must answer clicks.

```rust
div()
    // A bare string auto-converts into `Text`. No constructor needed.
    // This is the everyday label. Stop here unless styling calls.
    .child("plain string becomes Text")
```

A `Div` holds boxes. Text holds shaped glyphs. The two meet through `.child(...)`, never through inheritance.

## Three levels up

|  |  |  |
| --- | --- | --- |
| Type | Reach for it when | Key API |
| `Text` | one label, one style | `with_id` (`text.rs:104`) |
| `StyledText` | mixed fonts and colors | `StyledText::new` (`text.rs:402`), `with_runs` (`text.rs:527`) |
| `InteractiveText` | clickable spans | `InteractiveText::new` (`text.rs:1228`) |

Table 6: The text ladder. Climb only as high as you need.

```rust
use gpui::{StyledText, TextRun};
// One string, several runs: each run restyles a byte range.
// `len: 5` counts UTF-8 bytes, not chars. "hello" is 5 bytes here.
// `..Default::default()` keeps every other style field untouched.
let styled = StyledText::new("hello world")
    .with_runs(vec![TextRun {
        len: 5,
        font_weight: gpui::FontWeight::BOLD,
        ..Default::default()
    }]);
```

Runs are byte math with a tripwire. `with_runs` slices with `text.get(run.len..)` and asserts the byte totals exactly cover the string (`text.rs:527`). Slice mid-character in a multi-byte string and the render garbles. Count bytes, not glyphs.

Highlights paint ranges a second way. `with_highlights` (`text.rs:434`) takes byte ranges over a default style. `with_default_highlights` (`text.rs:419`) fills the gaps instead. Pick one: each asserts the other is absent, but only under `debug_assert`. Release builds stay silent and the second call wins.

> **Tip.** Keep runs sorted and on char boundaries. `compute_runs` (`text.rs:454`) fills gaps with byte subtraction, so unsorted ranges underflow. Debug asserts check boundaries. Release trusts you.

## Measure then place

`TextLayout` answers geometry questions after shaping. Ask it where things landed, not where you hope they land.

|  |  |
| --- | --- |
| Question | Method |
| which char sits under the mouse? | `index_for_position` (`text.rs:1050`) |
| where does char `i` draw? | `position_for_index` (`text.rs:1084`) |
| which line holds char `i`? | `line_layout_for_index` (`text.rs:1115`) |
| every line? | `line_layouts` (`text.rs:1138`) |
| how big? how tall? | `bounds` (`text.rs:1150`), `line_height` (`text.rs:1155`) |

Table 7: Geometry questions and the query that answers each.

One cache rule saves you pain. A layout once truncated is always re-measured (`text.rs:933`). Truncated width poisons intrinsic sizing, so GPUI throws it away rather than reuse it. Measure once per content change and cache the `TextLayout`. Never measure during layout to size the parent.

Interactive spans hang events off state. `on_click` (`text.rs:1242`), `on_hover` (`text.rs:1261`), and `tooltip` (`text.rs:1270`) live on the interactive element. The state owns the id, so hand one to `InteractiveText::new`.

> **Pitfall.** Measuring text inside layout to decide the parent size. Every frame re-shapes, every frame thrashes. Measure once per content change, cache the `TextLayout`, size from your view data.

Where next? Give words a home they can edit (`text-input`), or pictures beside them (`media`).

## Sources

- `Text`, `with_id`: [crates/gpui/src/elements/text.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/text.rs), `text.rs:104`
- `StyledText::new`, highlights, font overrides: `text.rs:402`, `text.rs:419`, `text.rs:434`, `text.rs:489`, `text.rs:527`
- Layout queries: `text.rs:1050`, `text.rs:1084`, `text.rs:1115`, `text.rs:1138`, `text.rs:1150`, `text.rs:1155`
- Interactive: `text.rs:1219`, `text.rs:1228`, `text.rs:1242`, `text.rs:1261`, `text.rs:1270`
- Cache invalidation on truncation: `text.rs:933`
