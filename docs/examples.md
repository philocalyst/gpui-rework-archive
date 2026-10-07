# GPUI examples

The 31 examples are organized by the GPUI idea they teach. Start with `learn` for the component and input model, use `gallery` for reusable rendering cases, and use `platform` for operating-system integration. The remaining `text`, `bench`, and `view_example` targets cover text internals, paint workloads, and a composed editor. Run a native window with `scripts/gpui-example <name>` or `cargo run -p gpui-ce --example <name>`.

Most visual lessons also accept `--capture [--output DIR] [--samples N] [--baseline DIR]`. Capture mode uses the same typed scenario view and named state changes as the native window, then writes a CPU-rendered report without opening an OS window. The default output is `target/gpui-examples/<scenario-id>`. `--baseline` adds pixel and scene comparisons to that report. This path is useful on headless builders; it does not replace the native-only checks called out below. Capture mode is available for `actions_and_keybinds`, `animation`, `async_tasks`, `corner_smoothing`, `creating_components`, `custom_drawing`, `data_table`, `direction`, `gif_viewer`, `hello_world`, `image_loading`, `inline_layout`, `interaction`, `input_states`, `layout`, `pattern`, `paths_bench`, `render_effects`, `shadows`, `svg`, `text`, `text_system`, `uniform_list`, and `view_example`.

The deterministic suite lives in `gpui_ce_test::gallery`. Its typed scenario builders are also used by the matching examples, so a checkpoint's view, viewport, input, and simulated time have one definition. Run `scripts/gpui-test list` and `scripts/gpui-test run` for the shared registry: default/narrow/2x/fractional text, effects, five animation times, flexible layout, dispatched focus/selection/disclosure/scroll input, embedded media, virtualized overlap, and task cancellation/restart. The standalone examples add interaction checkpoints for actions, counters, table sorting/selection, and focus.

## Learn

| Example | Purpose | States to exercise | Requirements |
| --- | --- | --- | --- |
| `actions_and_keybinds` | Binds typed actions to Space and Backspace. | Capture checks increment and reset; manual: focus loss and platform shortcut behavior. | Keyboard input. |
| `animation` | Compares `Animation`, sampled `Motion`, keyed transitions, and style transitions. | Capture dispatches Play/restart and hover; asserts Motion at 0%, 50%, and 100%, and checks keyed bounce progress. Manual: press and replay the bounce. | Pointer input for manual controls. |
| `async_tasks` | Runs, cancels, restarts, and completes foreground work from a background result. | Shared deterministic task checkpoints cover late-result suppression and result 42. | The native view uses a real timer. |
| `corner_smoothing` | Exposes rounded-corner smoothing and radius controls. | Capture changes smoothing by pointer input and verifies radius clamping at minimum width; manual: explore minimum/maximum radius and height. | Pointer input. |
| `creating_components` | Compares element-local state, parent-owned props, and entity-owned state in three counter cards. | Headless test clicks each ownership model, redraws the parent, and resets independently. | Pointer input in the native view. |
| `custom_drawing` | Paints canvas primitives and vector paths, with pointer-driven drawing. | Capture draws a real stroke, then clears it; manual: pointer movement, path geometry, and resize. | Pointer input for drawing. |
| `direction` | Shows direction-aware layout and spacing. | Capture shows both directions; manual: inspect mirrored order and spacing. | None. |
| `haptic_feedback` | Queries haptic support and triggers feedback patterns. | Manual: supported pattern and slider increments. | Haptic-capable Mac trackpad; unsupported platforms return no-op results. |
| `interaction` | One short lesson for click data, hover state, conditional/group styles, mouse events, focus, and drag/drop. | Capture dispatches click, hover, mouse down/up, forward/reverse Tab, and a real drag/drop; it checks the preview, payload, and cleanup. Manual: pointer coordinates and hover feel. | Pointer and keyboard input for native exploration. |
| `keyring` | Reads and writes credentials through GPUI's platform API. | Manual: set, read, delete, and missing-entry behavior. | OS keyring service; the example writes a demo credential. |
| `layout` | Uses flexible rows and wrapping content. | Shared fixed viewport; manual: resize to narrow and wide widths. | None. |
| `text` | Adds uppercase/tracking and capitalization examples to the shared wrapping, underline, and mixed-script view. | Capture uses this native lesson view; shared suite separately checks narrow wrapping and scale factors. | Bundled sample fonts. |
| `uniform_list` | Renders 2,000 virtual rows with overlapping decoration. | Shared viewport; manual: scroll to top, middle, and end and check stable row identity. | Scroll input. |

## Gallery

| Example | Purpose | States to exercise | Requirements |
| --- | --- | --- | --- |
| `hello_world` | Small first window with text and color swatches. | Manual: startup, appearance, and closing the final window. | None. |
| `image_loading` | Uses a delayed embedded asset loader to show ready, visible loading placeholder, failure, and retry states. | Capture asserts pending, ready plus delayed placeholder, fallback, and eviction/retry-pending cache states. | Embedded app-icon image and decoder. |
| `inline_layout` | Places atomic GPUI elements in flowing text. | Capture covers natural wrapping; manual: inspect line breaks at narrower widths. | None. |
| `input_states` | Demonstrates tab stops, focus-visible styling, selection, tree disclosure, and a scroll handle. | Shared suite dispatches real click and scroll input, checks focus, tree state, and offset. | None for capture; keyboard/pointer/scroll for native exploration. |
| `render_effects` | Reuses the shared clipping, opacity, gradient, path, and nested-filter view. | Shared fixed-view effects capture; inspect overlap and filter boundaries. | None. |
| `svg` | Embeds monochrome SVG and procedural raster data, then clips and transforms both. | Shared media view is self-contained and deterministic. | None. |
| `gif_viewer` | Decodes an embedded GIF once and lets the image element advance on dispatcher time. | Capture compares the rendered start, midpoint, and full-cycle frames: midpoint differs while the loop frame matches the start. Manual: resize and inspect the loop. | Bundled GIF decoder. |

## Text and composition

| Example | Purpose | States to exercise | Requirements |
| --- | --- | --- | --- |
| `text_system` | Inspects shaping, fallback, font features, highlights, and line metrics. | Capture records all seven compact reference sections; manual: mixed scripts, wrapping, fallback selection, and feature changes. | Embedded IBM Plex, Lilex, and Noto sample fonts. |
| `view_example` | Composes a reusable editor into single-line input and text-area views. | Capture records the shared editor composition; headless tests exercise typing, cursor movement, Unicode boundary clamping, and sibling isolation. | Keyboard input; clipboard behavior depends on the platform. |

## Paint and data workloads

| Example | Purpose | States to exercise | Requirements |
| --- | --- | --- | --- |
| `data_table` | A deterministic 10,000-row virtual table with four sortable columns and a separate company field. | Capture sorts both directions, preserves row selection across a sort, and scrolls to deep virtual rows. | Pointer and scroll input. |
| `paths_bench` | Paints a cached 16×16 grid of concave fills, curves, strokes, and gradients. | Capture covers 256 bounded paths; compare repeated runs on the same renderer for timing. | CPU capture is portable; native frame timing depends on hardware. |
| `pattern` | Compares pattern spacing and alignment with flat and gradient fills. | Capture covers aligned and mismatched pattern steps. | None. |
| `shadows` | One compact gallery for offset, blur, spread, inset, stacked, and gradient-backed shadows. | Capture covers the full representative matrix. | None. |

## Native platform integration

| Example | Purpose | Manual checks | Requirements |
| --- | --- | --- | --- |
| `windows` | Opens and repositions windows with varied bounds, kinds, visibility, and focus. | Manual: compare placement across displays and native kind/titlebar behavior. The platform probe covers visibility, activation/focus, redraw, viewport resize, scene readback, and closing multiple windows. | Native window manager and display geometry. |
| `window_shadow` | Demonstrates custom shadow around a client-decorated window. | Shadow edges, corner clipping, resize hit-testing. | Native compositor and window manager. |
| `window_movable` | Compares native titlebar dragging with app-owned drag regions. | Drag initiation, release, and screen edges. | Native window manager and pointer input. |
| `layer_shell` | Configures a Linux layer-shell window. | Layer, anchor, and exclusive-zone behavior. | Wayland compositor with layer-shell support. |
| `system_notifications` | Sends, replaces, dismisses, and responds to notifications. | Delivery and action behavior. | Native notification service. |

The lesson-level counter, focus, table, layout, text, media, effects, animation, task, and interaction scenarios use deterministic views rather than screenshots copied from separate fixtures. Image and GIF bytes are embedded at compile time, so capture and launch work from any current directory. `scripts/gpui-test platform` automates native visibility, activation and focus, redraw, exact viewport resize, scene readback, and closing two windows. Placement across real displays, compositor behavior, custom window shadows, titlebar movement, layer shell, keyrings, haptics, notifications, and other OS services still need platform-specific manual checks.
