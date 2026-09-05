+++
title = "Utilities: which tool for which job"
description = "A guide to the smaller tools that support everyday application work."
weight = 32
aliases = ["/system/utilities.html"]
[extra]
category = "SYSTEM"
legacy_source = "gpui-ce-docs/build/html/system/utilities.html"
+++

Small crates, one problem each. **Utilities** here means the narrow helpers around GPUI’s core: shared text, small maps, layered config, timers, channels, and builder chains. Reach for the narrowest crate that fits, and your compile times will thank you.

|  |  |  |
| --- | --- | --- |
| Job | Crate and entry | What you should know |
| cheap shared text | `SharedString` (`gpui_shared_string.rs:15`) | wraps `SmolStr`; clones skip allocation |
| small ordered map | `VecMap` (`vecmap.rs:18`) | beats `HashMap` under  32 entries; `entry` API for upserts |
| ordered map with cursors | `TreeMap` (`tree_map.rs:7`) | B-tree over `SumTree`; `closest` finds neighbors (`tree_map.rs:124`) |
| layered config | `Refineable` (`refineable.rs:29`) | `refined` overlays a `Refinement`; `Cascade` merges layers (`refineable.rs:80`) |
| timers and dispatch | `LocalExecutor` (`executor.rs:31`) | `timer` sleeps (`executor.rs:165`); `block_on` waits (`executor.rs:119`) |
| deterministic tests | `TestScheduler` (`test_scheduler.rs:34`) | `advance_clock` moves fake time (`test_scheduler.rs:450`) |
| priority channel | `PriorityQueueSender` (`queue.rs:136`) | `send(priority, item)` orders work (`queue.rs:145`) |
| builder chains | `FluentBuilder` (`util.rs:11`) | adds `opt()`-style chaining to any type |

Table 41: One job, one tool — pick the narrowest row that fits.

## Sum tree as index cards

Picture a stack of index cards. Each card summarizes its pile with one total. An edit touches a single pile, then updates its card upward. Totals stay fresh without recounting the whole stack — that is `SumTree`, and `TreeMap` rides on top of it.

```rust
// Good: one keystroke touches O(log n) nodes; summaries recompute upward.
map.insert(key, value); // `TreeMap::insert` at `tree_map.rs:75`
map.insert_or_replace(key, value); // same path, returns the old value (`tree_map.rs:79`)
// Need the nearest key at or below yours? Ask the cursor, not a scan.
let neighbor = map.closest(&key); // `Option<(&K, &V)>` at `tree_map.rs:124`
```

`SharedString` deserves a second look. It wraps `SmolStr` ([crates/gpui_shared_string/gpui_shared_string.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_shared_string/gpui_shared_string.rs)), so short strings live inline with no heap trip, and cloning shares instead of copying. Use it for labels, paths, and keys you pass around every frame.

> **Tip.** Under  32 entries, `VecMap` wins over `HashMap`. Above that, or when you need neighbor lookups, graduate to `TreeMap`.

Layered config follows one verb: `refined`. A base value plus a `Refinement` overlay produces a new value without mutating either ([crates/gpui_refineable/src/refineable.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_refineable/src/refineable.rs)). Stack several overlays in a `Cascade` and the topmost set field wins ([crates/gpui_refineable/src/refineable.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_refineable/src/refineable.rs)). Think theme defaults, then user settings, then per-window overrides.

```rust
// sketch — not API
// Good: base theme refined by user prefs, merged through a cascade.
// let look = theme.refined(user_prefs); // base untouched, overlay applied
// Anti-pattern: cloning whole configs per window instead of layering.
```

> **Pitfall.** Grab-bag helpers tempt you daily. `measure` (`lib.rs:158`) and `defer` (`lib.rs:528`) live in `gpui_ce_util`, and Zed ports live in `gpui_zed_util` — but prefer the narrow crate above first so your dependencies stay honest.

Where next? Spawn work on the right executor (`system-async-executor`), then fake its clock in tests (`system-testing`).

## Sources

- `SharedString`: [crates/gpui_shared_string/gpui_shared_string.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_shared_string/gpui_shared_string.rs)
- `VecMap`: [crates/gpui_collections/src/vecmap.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_collections/src/vecmap.rs)
- `TreeMap`, `insert`, `closest`: [crates/gpui_sum_tree/src/tree_map.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_sum_tree/src/tree_map.rs), [crates/gpui_sum_tree/src/tree_map.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_sum_tree/src/tree_map.rs), [crates/gpui_sum_tree/src/tree_map.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_sum_tree/src/tree_map.rs)
- `Refineable::refined`, `Cascade`: [crates/gpui_refineable/src/refineable.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_refineable/src/refineable.rs), [crates/gpui_refineable/src/refineable.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_refineable/src/refineable.rs)
- `LocalExecutor`, `timer`, `block_on`: [crates/gpui_scheduler/src/executor.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_scheduler/src/executor.rs), [crates/gpui_scheduler/src/executor.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_scheduler/src/executor.rs), [crates/gpui_scheduler/src/executor.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_scheduler/src/executor.rs)
- `TestScheduler`, `advance_clock`: [crates/gpui_scheduler/src/test_scheduler.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_scheduler/src/test_scheduler.rs), [crates/gpui_scheduler/src/test_scheduler.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_scheduler/src/test_scheduler.rs)
- `PriorityQueueSender::send`: [crates/gpui/src/queue.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/queue.rs)
- `FluentBuilder`: [crates/gpui/src/util.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/util.rs)
- `measure`, `defer`: [crates/gpui_ce_util/src/lib.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_ce_util/src/lib.rs), [crates/gpui_ce_util/src/lib.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_ce_util/src/lib.rs)
