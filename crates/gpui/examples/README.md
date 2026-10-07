# GPUI examples

Start with `hello_world`, then explore a lesson in `learn/`. Each target teaches one idea; related visual cases share a window instead of repeating application setup.

```sh
cargo run -p gpui-ce --example hello_world
cargo run -p gpui-ce --example interaction
cargo test -p gpui-ce --examples --features test-support
```

From another directory, pass the workspace manifest:

```sh
cargo run --manifest-path /path/to/gpui-ce/Cargo.toml --example animation
```

Media and sample fonts are embedded, so the compiled examples also work when
started from another directory. The [walkthroughs](../../../site/content/examples/_index.md)
are ordinary examples in their own package:

```sh
cargo run -p gpui-documentation-examples --example counter
```

## Find an example

| Directory | Targets | What to explore |
| --- | --- | --- |
| `learn/` | `actions_and_keybinds`, `interaction` | Typed actions and pointer events; typed drag payloads and preview cleanup. |
| `learn/` | `creating_components` | Element-local, parent-owned, and entity-owned counters side by side. |
| `learn/` | `animation` | Repeating animation, sampled motion, keyed replay, and style transitions. |
| `learn/` | `async_tasks` | Start, cancel, restart, and finish background work. |
| `learn/` | `layout`, `direction`, `uniform_list` | Flexible layout, direction-aware spacing, and virtual rows. |
| `learn/` | `text`, `custom_drawing`, `corner_smoothing` | Typography, canvas/path drawing, and interactive corner controls. |
| `platform/` | `haptic_feedback`, `keyring` | Device feedback and OS credentials; require the corresponding native services. |
| `gallery/basics/` | `hello_world` | A small first window and standard close behavior. |
| `gallery/interaction/` | `input_states`, `inline_layout` | Selection, disclosure, keyboard focus, scrolling, and inline wrapping. |
| `gallery/rendering/` | `render_effects` | Clipping, opacity, gradients, paths, nested filters, and backdrop blur. |
| `gallery/rendering/` | `image_loading`, `gif_viewer`, `svg` | Delayed loading, failure/retry, animated images, and clipped vector/raster media. |
| `stress/` | `data_table` | 10,000 virtual rows, sorting, and selection by row identity. |
| `stress/` | `paths_bench`, `pattern`, `shadows` | Cached geometry and representative paint workloads. These are demos, not a benchmark runner. |
| `text/` | `text_system` | Shaping, fallback, font features, highlights, and line metrics. |
| `view_example/` | `view_example` | Shared editor state composed into inputs, text areas, and cursor readouts. |
| `platform/` | `windows`, `window_shadow`, `window_movable`, `layer_shell`, `system_notifications` | Native window behavior and OS integration. Layer shell requires a compatible Wayland compositor. |

## Read and test a lesson

The target's `.rs` file contains its view and native entry point. Larger examples put reusable widgets or painting code in a sibling directory: `corner_smoothing/slider.rs`, `custom_drawing/primitives.rs`, and `view_example/example_editor/paint.rs`. `shared/` holds the small launch helper and embedded media source.

Behavior tests live beside their lessons in `tests.rs` and use GPUI's existing `TestAppContext`, input simulation, and dispatcher clock. They exercise real event routing, independent counter ownership, drag/drop cleanup, animation restart, table sorting, task cancellation, and Unicode editing. They run without a GPU or OS window. Run one target while editing:

```sh
cargo test -p gpui-ce --example interaction --features test-support
```

Native paint appearance, animated GIF playback, compositor behavior, display placement, notifications, keyrings, and haptics still need manual checks.

## Consolidated targets

`interactive_elements`, `focus_visible`, `tab_stop`, `tree`, and `scrollable` are covered by `interaction` and `input_states`. `motion_showcase`, `transitions`, and `style_transitions` are covered by `animation`. `gradient`, `opacity`, and `blur` are covered by `render_effects`; styling is demonstrated in the lessons that use it. `text_transform_preview` is covered by `text`. The old disk-dependent `image` demo is replaced by embedded media in `svg`, `image_loading`, and `gif_viewer`. `shadow` and `border_and_shadow_backgrounds` became `shadows`. Window positioning, visibility, and close behavior are demonstrated by `windows` and the shared launcher.
