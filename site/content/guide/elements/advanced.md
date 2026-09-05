+++
title = "Popups, overlays, motion, queries"
description = "Place overlays and deferred elements where the interface needs them, beyond ordinary flow."
weight = 20
aliases = ["/elements/advanced.html"]
[extra]
category = "ELEMENTS"
legacy_source = "gpui-ce-docs/build/html/elements/advanced.html"
+++

Four escape hatches for jobs plain boxes cannot do. Popups that stick, paint that jumps queue, motion without a framework, subtrees that read their room ([crates/gpui/src/elements/anchored.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/anchored.rs)). Each costs something. Spend on purpose.

## Popups that stick

```rust
div()
    // `anchored()` starts a popup. `.anchor` pins a corner.
    // `TopLeft` means the popup grows from its top-left point.
    .child(anchored().anchor(gpui::Anchor::TopLeft).child("tooltip"))
```

`anchored()` builds an `Anchored` (`anchored.rs:27`). Aim with `.anchor` (`anchored.rs:40`), `.position` (`anchored.rs:47`), and `.offset` (`anchored.rs:54`). Choose the coordinate space with `.position_mode` (`anchored.rs:62`). Keep popups on screen with `.snap_to_window` (`anchored.rs:68`) or `.snap_to_window_with_margin` (`anchored.rs:74`). Fit behavior is `AnchoredFitMode` (`anchored.rs:243`).

Offsets cut before the safety net. A big offset folds into the bounds first (`anchored.rs:270`), and only then does overflow flipping run. Push too far and `SwitchAnchor` quietly flips your popup to the far corner. Nudge small. Test near edges.

> **Tip.** Margins grow on some platforms. `snap_to_window_with_margin` adds the window `client_inset` (`anchored.rs:182`), so a 10px margin reads larger beside Wayland title bars.

## Paint later, on top

```rust
div()
    // `deferred` paints its child after its siblings. Menus win naturally.
    // `.with_priority(10)` orders overlays. Bigger numbers paint on top.
    .child(deferred(div().child("overlay")).with_priority(10))
```

`deferred(child)` (`deferred.rs:7`) jumps the paint queue. `.with_priority` (`deferred.rs:25`) settles ties. Equal priorities keep tree order, since the sort is stable. Nesting caps at depth 10 before a hard panic (`window.rs:3338`). Menus and drag ghosts earn this. Ordinary overlap does not.

## Motion, no framework

```rust
div()
    // `Animation::new` starts a 300ms timed element.
    // `.repeat()` loops it. `.with_easing` shapes the curve.
    .child(Animation::new(std::time::Duration::from_millis(300)).repeat().with_easing(easing::ease_in_out))
```

`Animation::new(duration)` (`animation.rs:33`) starts the clock. `.repeat` (`animation.rs:44`) loops freely. `.repeat_synced` (`animation.rs:50`) locks phase to a shared clock in `u64` nanoseconds (`animation.rs:422`). That ordering keeps phase exact after 300 days of uptime. `.with_easing` (`animation.rs:60`) and `.with_max_fps` (`animation.rs:69`) shape it. Easing helpers sit alongside: `linear` (`animation.rs:508`), `quadratic` (`animation.rs:513`), `ease_in_out` (`animation.rs:518`), `ease_out_quint` (`animation.rs:528`), `bounce` (`animation.rs:533`), `pulsating_between` (`animation.rs:544`).

## Queries that rebuild

```rust
div()
    // `container_query` hands the child its available size.
    // The closure returns the variant that fits: narrow or wide.
    // Prefer plain flex for pages. Save this for component edges.
    .child(container_query(my_element, |_size, _window, _cx| my_narrow_variant))
```

`container_query(element, layout)` (`container_query.rs:33`) rebuilds its child from the available size. The closure is `FnOnce` and rebuilds every layout pass (`container_query.rs:91`). That is full mount work per size change, not a cheap diff. Cards and panels at component boundaries earn it. Page-level responsiveness belongs in flex.

> **Pitfall.** Sprinkling `deferred` on every floating pixel. Priorities war and overlays flicker. Reserve `deferred` for true overlays. Solve the rest with tree order and `anchored`.

Where next? Let popups take typing (`text-input`), or list their long contents (`lists`).

## Sources

- Anchored: [crates/gpui/src/elements/anchored.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/anchored.rs), `anchored.rs:27`, `anchored.rs:40`, `anchored.rs:47`, `anchored.rs:54`, `anchored.rs:62`, `anchored.rs:68`, `anchored.rs:74`, `anchored.rs:243`, offset ordering at `anchored.rs:270`, inset math at `anchored.rs:182`
- Deferred: `deferred.rs:7`, `deferred.rs:16`, `deferred.rs:25`, nesting cap at `window.rs:3338`
- Animation: `animation.rs:15`, `animation.rs:33`, `animation.rs:44`, `animation.rs:50`, `animation.rs:60`, `animation.rs:69`, nanos math at `animation.rs:422`, easing at `animation.rs:508-544`
- Container query: `container_query.rs:33`, `container_query.rs:91`
