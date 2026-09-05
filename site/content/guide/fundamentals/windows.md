+++
title = "Windows"
description = "Open a window, configure its bounds, and give it a root view that can respond to change."
weight = 7
aliases = ["/fundamentals/windows.html"]
[extra]
category = "FUNDAMENTALS"
legacy_source = "gpui-ce-docs/build/html/fundamentals/windows.html"
+++

A **window** is an OS surface plus a root view. You describe the surface with `WindowOptions`, then build the content with a closure. Use `WindowOptions` in app code; `WindowParams` is the lower-level struct handed to the platform.

A **root view** is the entity returned by `build_root_view`. It owns the window’s element tree. Every window has exactly one.

```rust
// open_window creates the platform surface, builds the root view, and
// draws once, all before returning. The `?` covers platform rejection.
// WindowBounds::centered sizes the window and lets the OS pick the spot.
cx.open_window(
    WindowOptions {
        window_bounds: Some(WindowBounds::centered(size, cx)),
        ..Default::default()
    },
    // This closure runs once per window. Return the root Entity<V>.
    |window, cx| cx.new(|cx| RootView::new(window, cx)),
)?;
```

## Opening a window

`App::open_window(options, build_root_view)` creates the platform window, builds the root view, draws once, and returns a typed `WindowHandle<V>` ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)). The closure receives `&mut Window` and `&mut App`.

- The closure must return `Entity<V>` where `V: Render`.
- Failures (unsupported kind, platform rejection) surface as `anyhow::Result`.
- The first draw happens synchronously inside `open_window`, so the handle never points at an undrawn window.
- `WindowHandle<V>` upgrades to `AnyWindowHandle` for untyped storage.

That synchronous first draw is load-bearing. The source calls it out: on Windows the frame callback can lose the race, and returning an undrawn window trips an assert on empty dispatch-tree nodes ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)). When `Window::new` fails, the reserved window slot is removed and the error returns.

```rust
// The typed handle borrows the root view through any context.
// into() erases the type when you must store mixed windows together.
let handle: WindowHandle<RootView> = cx.open_window(
    WindowOptions::default(),
    |window, cx| cx.new(|cx| RootView::new(window, cx)),
)?;
let any: AnyWindowHandle = handle.into();
```

Headless tests use `HeadlessAppContext::open_window(size, build_root)`. It forces hidden, unfocused windows with origin at zero.

## Options, size, and title

`WindowOptions` is the portable surface description ([crates/gpui/src/platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform.rs)). Inactive windows throttle to about 30 fps through `inactive_frame_interval` ([crates/gpui/src/platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform.rs)).

Key `WindowOptions` fields:

- `window_bounds: Option<WindowBounds>` — initial state and restore size.
- `titlebar: Option<TitlebarOptions>` — title and transparency.
- `focus: bool` (default `true`) and `show: bool` (default `true`).
- `kind: WindowKind` (default `Normal`).
- `is_movable`, `is_resizable`, `is_minimizable` (all default `true`).
- `display_id`, `app_id`, `window_min_size`, `window_decorations`.
- `window_background` — opaque, transparent, blurred, or Mica on Windows 11.

`WindowBounds` has three states: `Windowed(bounds)`, `Maximized(bounds)`, and `Fullscreen(bounds)` ([crates/gpui/src/platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform.rs)). Each carries the restore size. `WindowBounds::centered(size, cx)` centers a window of the given size ([crates/gpui/src/platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform.rs)).

`TitlebarOptions` holds `title`, `appears_transparent`, and macOS `traffic_light_position` ([crates/gpui/src/platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform.rs)). `Window::set_window_title` renames a live window ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)).

```rust
// A fully spelled window: placed at (100, 100), sized 800x600, titled.
// px() lifts raw floats into device-independent pixels. size() pairs them.
// ..Default::default() keeps every other field at its portable default.
WindowOptions {
    window_bounds: Some(WindowBounds::Windowed(Bounds {
        origin: point(px(100.0), px(100.0)),
        size: size(px(800.0), px(600.0)),
    })),
    titlebar: Some(TitlebarOptions {
        title: Some("My App".into()),
        ..Default::default()
    }),
    window_min_size: Some(size(px(400.0), px(300.0))),
    ..Default::default()
}
```

## Kinds: popup, dialog, and layer shell

`WindowKind` selects the surface role ([crates/gpui/src/platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform.rs)):

- `Normal` — an ordinary application window.
- `PopUp` — floats above everything; use sparingly.
- `AnchoredPopup(PopupOptions)` — parent-anchored menu, dropdown, or tooltip.
- `Floating` — floats above its parent window.
- `Dialog` — blocks its parent until dismissed.
- `LayerShell(LayerShellOptions)` — Wayland-only overlay, dock, or wallpaper surface.

`AnchoredPopup` positions relative to the parent. Its size comes from `WindowOptions::window_bounds`, but the origin is ignored. `PopupOptions` carries `parent`, `anchor_rect`, `anchor`, `gravity`, `constraint_adjustment`, `offset`, and `grab` ([crates/gpui/src/platform/popup.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform/popup.rs)). Platforms without a native implementation reject it with `PopupNotSupportedError`.

> **Pitfall.** Grabbing popups behave like menus: they take focus and dismiss on outside press ([crates/gpui/src/platform/popup.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform/popup.rs)). Open them from a mouse-down handler, never from click. By click time the triggering press is over, so the grab is refused.

`LayerShellOptions` carries `namespace`, `layer`, `anchor`, `exclusive_zone`, `margin`, and `keyboard_interactivity`. The variant only exists on Linux with the `wayland` feature, and platforms without the `zwlr_layer_shell_v1` protocol reject it. Only mention layer shell on Wayland builds.

## Working with many windows

`App::windows()` lists all open windows ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)). `App::active_window()` returns the OS-focused window ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)). `App::window_stack()` returns front-to-back order when the platform supports it, else `None` ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)).

|  |  |
| --- | --- |
| **Type** | **Responsibility** |
| `App` | Owns the window list; opens windows; quits on last close. |
| `AppContext` | Trait for `update_window` and `with_window` access. |
| `Window` | Per-window draw, focus, input, and frame callbacks. |
| `WindowHandle<V>` | Typed reference to one window’s root view. |

Table 12: Who owns windows, and who borrows them.

Update a window through the context, not by holding `&mut Window`. `with_window` finds the window through the entity’s tracked mapping and returns `None` when the entity has no current window ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)).

```rust
// By handle: full access to root view, window, and app. Fallible.
// By entity: runs against the entity's current window. Returns None
// when the entity belongs to no window, so missing windows stay quiet.
cx.update_window(any_handle, |root_view, window, cx| {
    // set_window_title renames the live OS surface in place.
    window.set_window_title("New title");
})?;

// with_window skips windows entirely when the entity is windowless.
cx.with_window(entity_id, |window, cx| {
    // refresh dirties the whole window for the next frame.
    window.refresh();
});
```

`Window::refresh` marks the window dirty for the next frame ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)). It no-ops mid-draw, so notifies during draw defer instead of corrupting the scene. `Window::remove_window` only sets a `removed` flag ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)). The real teardown runs when the update finishes: handles drop, invalidators detach, and tracked entities unmap ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)). Closing the last window quits unless `QuitMode` says otherwise.

> **Tip.** Close with `ctrl-W` per window, quit with `cmd-Q` for the app. Wire both: one calls `remove_window`, the other calls `App::quit`.

```
open_window -> draw once -> handle returned
  -> update_window / with_window -> refresh (dirty)
  -> remove_window -> teardown -> maybe quit
```

## Sources

- [crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs) (`windows`), `:1283` (`window_stack`), `:1302` (`active_window`), `:1309` (`open_window`), `:1319` (synchronous first draw), `:1918` (`with_window`), `:1934` (`update_window_id` teardown)
- [crates/gpui/src/gpui.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/gpui.rs) (`AppContext`), `:234` (`update_window`)
- [crates/gpui/src/platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform.rs) (`WindowOptions`), `:2075` (`inactive_frame_interval`), `:2117` (`WindowParams`), `:2175` (`WindowBounds`), `:2203` (`centered`), `:2238` (`TitlebarOptions`), `:2252` (`WindowKind`)
- [crates/gpui/src/platform/popup.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform/popup.rs) (`PopupOptions`), `:39` (grab rule)
- [crates/gpui/src/platform/layer_shell.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform/layer_shell.rs) (`LayerShellOptions`)
- [crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs) (`refresh`), `:2051` (`remove_window`), `:2597` (`set_window_title`)
- [crates/gpui/src/app/headless_app_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/headless_app_context.rs) (headless `open_window`)
