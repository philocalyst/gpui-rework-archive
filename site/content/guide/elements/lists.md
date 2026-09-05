+++
title = "Lists that stay fast"
description = "Keep long collections responsive by drawing the items that matter to the current viewport."
weight = 19
aliases = ["/elements/lists.html"]
[extra]
category = "ELEMENTS"
legacy_source = "gpui-ce-docs/build/html/elements/lists.html"
+++

Two virtualized lists. Only the visible rows render ([crates/gpui/src/elements/list.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/list.rs)). A 10,000-row list costs about as much as the screenful you see. Pick by row shape, not by mood.

```rust
// Every row shares one height, so pick `uniform_list`.
// `"chat"` is the identity. `state` is the scroll handle.
// `1000` is the row count. The closure draws only the visible range.
div().child(uniform_list("chat", state, 1000, |_view, range, _w, _cx| {
    // `range` names exactly the rows on screen. Draw those, nothing more.
    // `into_any_element()` erases row types so they can mix in one `Vec`.
    range.map(|ix| div().child(format!("row {ix}")).into_any_element()).collect()
}))
```

## Which list wins

|  |  |  |
| --- | --- | --- |
| Situation | Pick | Why |
| every row same height | `uniform_list` (`uniform_list.rs:22`) | one measurement serves all rows |
| mixed heights | `list` (`list.rs:24`) | measures each row alone |
| chat pinned to newest | `List` + `FollowMode` | tail-follow built in |

Table 2: Same heights go uniform. Mixed heights go `List`.

`ListState::new(item_count, alignment, overdraw)` (`list.rs:314`) backs `list`. Mutations travel through `splice` (`list.rs:503`) for edits, `reset` (`list.rs:355`) for wholesale replacement, and `remeasure` (`list.rs:400`) plus `remeasure_items` (`list.rs:412`) when sizes change. `measure_all` (`list.rs:336`) and `with_uniform_item_height` (`list.rs:347`) tune measuring.

Overdraw has a quiet contract. Trailing-overdraw rows get measured but never laid out (`list.rs:1062`). Their heights steady the scrollbar while staying invisible. Keep render closures pure. Side effects still fire for rows nobody sees.

> **Tip.** Streaming chat? Call `remeasure` freely. A pending scroll rebases against user scrolls (`list.rs:848`), so a late remeasure never yanks the view back.

## Scroll with intent

|  |  |
| --- | --- |
| Need | API |
| reveal row `i` | `scroll_to_reveal_item` (`list.rs:677`) |
| jump to end | `scroll_to_end` (`list.rs:603`) |
| nudge by pixels | `scroll_by` (`list.rs:565`) |
| bounds of row `i` | `bounds_for_item` (`list.rs:711`) |
| uniform: go to row | `scroll_to_item` (`uniform_list.rs:150`) |
| uniform: watch from elsewhere | `.track_scroll(&handle)` (`uniform_list.rs:683`) |

Table 3: Scroll verbs. Reveal, jump, nudge, inspect.

Tail behavior belongs to `List`. `set_follow_mode` (`list.rs:617`) engages it. `pause_following_tail` (`list.rs:646`) rests it. `is_following_tail` (`list.rs:652`) reports it. `is_scrolled_to_end` lives on both lists (`list.rs:484`, `uniform_list.rs:241`).

Two sizing edges bite. A width change wipes every cached height (`list.rs:1543`). The next frames re-measure from scratch. And `uniform_list` samples a single row by default (`uniform_list.rs:658`). Pick the sample with `with_width_from_item` (`uniform_list.rs:622`). A tall header sampled as the norm stretches every row.

Sizing knobs round it out: `with_sizing_behavior` (`list.rs:46`, `uniform_list.rs:628`), `with_decoration` (`uniform_list.rs:653`), `y_flipped` (`uniform_list.rs:690`). Strategies live in `ScrollStrategy` (`uniform_list.rs:84`).

> **Pitfall.** Rendering all rows as plain `div` children. Mounts crawl and scroll janks past a few hundred rows. Move rows into `list` or `uniform_list` and draw only the visible range.

Where next? Float menus over your rows (`advanced`), or let rows take typing (`text-input`).

## Sources

- `list`, `ListState`, mutations: [crates/gpui/src/elements/list.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/list.rs), `list.rs:54`, `list.rs:314`, `list.rs:336`, `list.rs:347`, `list.rs:355`, `list.rs:400`, `list.rs:412`, `list.rs:503`
- Scroll and follow: `list.rs:484`, `list.rs:565`, `list.rs:603`, `list.rs:617`, `list.rs:646`, `list.rs:652`, `list.rs:677`, `list.rs:711`
- Overdraw contract: `list.rs:1062`; scroll rebase: `list.rs:848`; width invalidation: `list.rs:1543`
- `uniform_list`: `uniform_list.rs:22`, `uniform_list.rs:58`, `uniform_list.rs:80`, `uniform_list.rs:84`, `uniform_list.rs:150`, `uniform_list.rs:241`, `uniform_list.rs:622`, `uniform_list.rs:628`, `uniform_list.rs:653`, `uniform_list.rs:683`, `uniform_list.rs:690`
