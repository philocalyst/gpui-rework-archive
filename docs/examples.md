# GPUI examples

Examples are grouped by the idea they teach: `learn` is the short learning path, `gallery` keeps focused reference demos, `text` covers text-system inspection, `platform` demonstrates native integration, and `bench` contains stress and performance views. Cargo targets use short topic names, so launch examples with `scripts/gpui-example <name>` or `cargo run -p gpui-ce --example <name>`.

The deterministic gallery lives in `gpui_ce_test::gallery`. Its `LayoutScenario`, `TextScenario`, `EffectsScenario`, `AnimationScenario`, `InteractionScenario`, `MediaScenario`, and `StressScenario` views are also used by the matching `layout`, `text`, `blur`/`render_effects`, `animation`, `input_states`, `svg`, and `uniform_list` examples. Run captures from the repository root with `scripts/gpui-test list` and `scripts/gpui-test run`. The registry covers default, narrow, 2x, and fractional-DPI text; layered effects; five animation clock checkpoints (0, 300, 600, 900, and 1200 ms); flexible layout; input-dispatched selection, disclosure, focus, and scrolling; embedded SVG/raster media; and a virtualized overlap-heavy list.

The table marks shared cases as automated. Other targets remain manual-only in the current registry; those rows name the states that merit later deterministic cases. Platform notes are part of each example's purpose: a CPU-rendered capture does not replace checks against an operating system service, input device, display server, or window manager.

| Group | Example | What it demonstrates | Coverage and states to exercise | Requirements |
| --- | --- | --- | --- | --- |
| Learn | `interactive_elements` | Click count, callback-driven hover, raw mouse position/events, and drag data/drop feedback. | Manual: single/double/triple-click counts, hover enter/leave, pressed colors and coordinates, drag preview and accepted drop. | Pointer input. |
| Learn | `actions_and_keybinds` | Registering actions and binding shortcuts. | Manual: Space increments; Backspace resets; focus and shortcut dispatch. | Keyboard input. |
| Learn | `uniform_list` | Virtualized rendering of 2,000 stable rows with overlapping cell decoration. | Automated: deterministic initial list viewport; useful future cases are top, middle, and end offsets plus row identity. | Scroll input. |
| Learn | `creating_components` | One reusable counter card backed by element-local `use_state`, parent props in `RenderOnce`, or an entity-backed `Render`. | Manual: click each counter independently and verify its value survives redraws; compare ownership and lifetime. | Pointer input. |
| Learn | `layout` | Flexible sidebar/content layout and wrapping tiles. | Automated: fixed viewport; useful future cases are narrow and wide layouts. | None. |
| Learn | `styling` | Pointer/focus states, conditional choice and badge styles, parent-to-child group hover, and appearance colors. | Manual: hover and press buttons, Tab through focus rings, inspect the selected/disabled branches, and compare both themes. | Pointer and keyboard input. |
| Learn | `async_tasks` | Foreground/background tasks, progress, cancellation, and detaching. | Manual: progress updates, cancellation, completion and UI responsiveness. | Waits for the example's task timers. |
| Learn | `custom_drawing` | Canvas painting, paths, and pointer-driven drawing. | Manual: path geometry, pointer movement, and resize behavior. | Pointer input. |
| Learn | `animation` | A repeated easing animation using GPUI's animation wrapper. | Automated: 0/300/600/900/1200 ms clock checkpoints. | None. |
| Learn | `text` | Wrapping, inline highlights, colored wavy underline, and mixed scripts. | Automated: default and narrow viewports; useful future cases are line breaks and fallback glyph changes. | Bundled example fonts. |
| Learn | `transitions` | Keyed bounce reset and declarative style transitions in one view. | Manual: initial position, restarted bounce, hover growth, and active color. | Pointer input. |
| Learn | `motion_showcase` | Labeled motion controls and timeline previews. | Manual: preset selection, playback and scrub positions. | Pointer input. |
| Learn | `haptic_feedback` | Haptic capability checks and slider feedback. | Manual: supported patterns and slider increments. | Haptic-capable Mac trackpad; calls are no-ops elsewhere. |
| Learn | `blur` | Clip boundaries, nested filters, opacity, gradients, paths, and paint order. | Automated: fixed layered-effects view; useful future cases are filter nesting depth and overlap order. | None. |
| Learn | `corner_smoothing` | Interactive rounded-corner smoothing and radius controls. | Manual: radius, smoothing, width, and height extremes. | Pointer input. |
| Learn | `keyring` | Store, read, and delete credentials through the platform API. | Manual: each operation, missing credentials, and a custom Linux/FreeBSD label. | OS keyring service; stored credentials are written by the demo. |
| Learn | `border_and_shadow_backgrounds` | Gradient backgrounds with border, drop-shadow, and inset-shadow combinations. | Manual: compare gradient directions, alpha, and combined shadows. | None. |
| Learn | `direction` | Layout direction and direction-aware spacing. | Manual: left-to-right and right-to-left arrangements. | None. |
| Gallery | `hello_world` | A minimal window and first rendered component. | Manual: startup, appearance, and closing the final window. | None. |
| Gallery | `inline_layout` | Inline composition and element sizing. | Manual: wrapping and alignment at narrow window sizes. | None. |
| Gallery | `input_states` | Focus-visible tab stops, item selection, tree disclosure, and tracked scrolling. | Automated: real pointer clicks select and collapse; scroll-wheel input moves labeled rows and reports actual scroll offset. | Keyboard, pointer, and scroll input. |
| Gallery | `on_window_close_quit` | Quit behavior after the last window closes. | Manual: close one of several windows, then close the final window. | Window close interaction. |
| Gallery | `render_effects` | Clipping, nested filters, opacity, gradients, paths, and layer order. | Automated: fixed layered-effects scene. | None. |
| Gallery | `image_loading` | Asset-backed image loading and image parameters. | Manual: local asset success, parameterized failure, and sizing. | Uses files under `examples/gallery/rendering/image`; paths are manifest-relative. |
| Gallery | `gif_viewer` | Animated GIF decoding and frame display. | Manual: frame progression, loop boundary, and resize. | Bundled GIF asset; image decoder. |
| Gallery | `svg` | Inline monochrome SVG and procedural raster in rounded clipped frames. | Automated: shared media view with SVG transformation and raster clipping. | Self-contained; no external files. |
| Gallery | `window` | Window options and multiple-window composition. | Manual: open, focus, resize, and close each window. | Native window manager. |
| Gallery | `window_positioning` | Initial window placement and position updates. | Manual: centered/offset placement and monitor-boundary behavior. | Native display geometry. |
| Gallery | `window_shadow` | Custom window-shadow appearance. | Manual: shadow edges, corners, and resize. | Native window compositor. |
| Gallery | `layer_shell` | Linux layer-shell window integration. | Manual: layer, anchor, and exclusive-zone behavior. | Linux Wayland compositor with layer-shell support. |
| Platform | `system_notifications` | Send, replace, dismiss, and respond to notifications. | Manual: delivery, replacement, dismissal, and response action. | Native notification service. |
| Platform | `window_movable` | Move a window from a custom drag region. | Manual: drag initiation, release, and screen edges. | Native window manager and pointer input. |
| Platform | `window_visibility` | Hide and show a native window; supports a `--smoke` cycle. | Manual: visible/hidden transitions and focus restoration. | Native window manager. |
| Text | `text_system` | Font fallback, shaping, inline highlights, and text metrics. | Manual: mixed scripts, font features, line wrapping, and fallback selection. | Bundled IBM Plex, Lilex, and Noto sample fonts. |
| Text | `text_transform_preview` | Preview text-transform variants. | Manual: each transform and mixed-case inputs. | None. |
| Bench | `data_table` | A larger sortable and scrollable data table. | Manual: sorting, row selection, and scrolling; timing is workload-dependent. | Pointer and scroll input. |
| Bench | `paths_bench` | Large vector-path paint workload. | Manual: compare frame time at each path-density setting. | GPU/window renderer; results depend on hardware. |
| Bench | `pattern` | Repeated pattern fills and alignment. | Manual: pattern spacing, scale, and color. | None. |
| Bench | `shadow` | A large set of shadow configurations. | Manual: compare blur/spread/offset combinations and rendering cost. | GPU/window renderer; results depend on hardware. |
| View composition | `view_example` | A reusable editor composed into single-line input and text-area views. | Manual: typing, cursor movement, selection, newlines, and shared text state. | Keyboard input; clipboard behavior depends on the platform. |

`image_loading` and `gif_viewer` use bundled resources through paths rooted at `CARGO_MANIFEST_DIR`; they do not depend on the shell's current directory. The shared media case embeds its SVG and generates its raster pixels in Rust. Text fixtures are embedded at compile time from `gpui_test/assets/fonts`.
