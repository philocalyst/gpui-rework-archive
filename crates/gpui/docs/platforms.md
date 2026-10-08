# Platform selection and native backends

GPUI separates application and view code from the operating-system services that create windows,
dispatch events, shape text, and present scenes. Most applications should depend on `gpui` and
`gpui_platform`, then let the platform facade select the implementation for the compile target.
The facade package is named `gpui_ce_platform` in Cargo and imported as `gpui_platform`; the
backend packages follow the same pattern (`gpui_ce_linux`, `gpui_ce_macos`, and
`gpui_ce_windows`). Choose all GPUI packages from the same release or Git revision. A matching
crate name does not make different source revisions compatible.

## Start an application

For a native application, use the platform facade and open a window from the application callback:

```rust,no_run
use gpui::{App, AppContext as _, Empty, WindowOptions};

fn main() {
    gpui_platform::application().run(|cx: &mut App| {
        cx.open_window(WindowOptions::default(), |_, cx| cx.new(|_| Empty))
            .expect("open the first window");
    });
}
```

`application()` creates the selected platform and returns an ordinary
[`Application`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Application.html). `run` owns the native
event loop; the closure is the place to initialize app state, register callbacks, and open initial
windows. The [shared example startup](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/examples/shared/prelude.rs)
shows a slightly fuller version with menus, assets, window bounds, and closing behavior. See the
[setup guide](https://gpui-ce.github.io/guides/setup/) for build prerequisites and commands.

## Choose a backend

| Target | Native window system | Text and rendering setup | Selection and constraints |
| --- | --- | --- | --- |
| macOS | AppKit | GPUI's Parley-backed text system; Metal renderer by default. Enable `macos-wgpu` on `gpui_platform` to use WGPU instead. | Construct the platform on the AppKit main thread. `MacPlatform::new` panics without a main-thread marker. Anchored native popup windows are currently rejected so GPUI can use an in-window popover fallback. |
| Windows | Win32 | Parley shaping with a DirectWrite glyph rasterizer; DirectX renderer. | `WindowsPlatform::new` returns an error if OLE, DirectX, or DirectWrite initialization fails. |
| Linux and FreeBSD | Wayland or X11 | Parley with system fonts when either display backend is enabled; WGPU rendering. | `gpui_linux` enables both `wayland` and `x11` by default. The facade exposes the same switches as `wayland` and `x11`; compositor selection follows the process environment. |
| WebAssembly | Browser document and canvas | Parley without system fonts; WGPU selects WebGPU or WebGL2. | One top-level GPUI window per document. Browser permissions, fonts, graphics support, and threading rules apply. |

On Linux and FreeBSD, the platform checks `ZED_HEADLESS` first. Otherwise a non-empty
`WAYLAND_DISPLAY` selects Wayland when that feature is compiled in; `DISPLAY` selects X11 when
Wayland was not selected. With neither display variable, it creates the headless client. The
environment test does not verify that a compositor is reachable: the current constructor returns
`Rc<dyn Platform>` rather than `Result`, and failed Wayland or X11 initialization can panic. Set
`ZED_HEADLESS` to any value to force the headless client. When using `gpui_linux` directly with
its default features disabled, make sure the target environment selects a backend that remains
enabled.

## Cargo features

The platform facade has no default features of its own. Its optional features are:

| Feature | Effect |
| --- | --- |
| `wayland`, `x11` | Forward the matching Linux/FreeBSD backend feature. `gpui_linux` enables both by default and the platform facade currently depends on it with those defaults, so a normal facade dependency includes both. These flags are useful when enabling a backend through the facade, but do not turn off a backend enabled elsewhere in the dependency graph. |
| `macos-wgpu` | Use WGPU for macOS windows instead of the default Metal renderer. Applications that share GPUI's GPU device for custom controls also need `gpui_wgpu`'s `custom-gpu` feature. |
| `screen-capture` | Enable the supported native capture APIs. The platform trait still reports unsupported or unavailable capture on targets without an implementation. |
| `test-support`, `bench-support` | Enable test contexts or benchmark support. These are development features, not requirements for application startup. |
| `font-kit` | Forward the macOS crate's `font-kit` feature. The font-kit dependency is unconditional in this checkout, so enabling the feature does not change backend selection. |

Features are additive across a Cargo dependency graph. Disabling a feature on one declaration
cannot remove a feature enabled by another dependency. Inspect the resolved feature graph when a
Linux build includes an unexpected backend. `bench` is a compatibility alias for `bench-support`
on `gpui` itself; the platform facade exposes `bench-support`.

## Headless operation

[`gpui_platform::headless()`](https://docs.rs/gpui-ce-platform/0.1.0/gpui_platform/fn.headless.html)
constructs the selected platform in its headless mode. Treat this as a way to run selected
application and scheduling code without a normal desktop session, not as a promise that every
backend provides off-screen drawing or native services:

- Linux/FreeBSD use a synthetic display and windows. A headless window has no native window or
  display handle; it discards submitted scenes and does not drive frame callbacks.
- Windows skips DirectX device creation but still initializes OLE and DirectWrite. It is useful
  for text and app logic that does not require GPU-backed windows.
- macOS still requires the AppKit main thread and keeps its native text services. Its headless
  event-loop path differs from normal AppKit launch, and should not be treated as a portable
  off-screen window implementation.
- WebAssembly always constructs a browser platform. The facade's `headless` argument does not
  provide a browser-free runtime.

The test/benchmark-only `current_headless_renderer()` is available when `test-support` or
`bench-support` is enabled. In this checkout it returns a renderer only on macOS. A backend's
headless application mode and an off-screen renderer are separate capabilities.

`background_executor()` also constructs a headless platform to obtain its executor. It can have
backend initialization and thread costs; cache the returned executor if you need it more than
once. On macOS, call it on the main thread.

## Browser startup

On `wasm32`, `application()` selects WebGPU with automatic fallback to WebGL2. Call `web_init()`
from the `wasm_bindgen` start function before creating the application to install panic hooks and
logging. Use `application_with_web_backend(WebBackendPreference::WebGpu)` or `WebGl` to require a
specific graphics backend, and use `single_threaded_web()` when the application must not enable
worker-thread support. The graphics context is initialized lazily; the first window open can fail
while initialization is pending, or when the browser cannot create the requested backend. The
[web example](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_web/examples/hello_web/main.rs)
shows browser startup and explicit backend selection.

The browser platform has no native OS window manager, and a shared GPUI view does not become a
semantic HTML tree. Clipboard, file dialogs, notifications, fonts, and input are constrained by
browser APIs and permissions. Add application fonts through `cx.text_system()` because the web
text system starts without system fonts. A browser preview is useful for shared layout and input
logic; it does not validate native window chrome, compositor behavior, OS dialogs, or native GPU
integration.

## Threading, callbacks, and native handles

The backend owns its event loop. GPUI invokes platform operations on the UI thread; work submitted
through `BackgroundExecutor` may run elsewhere, while `ForegroundExecutor` serializes work with
the platform loop. On macOS, AppKit operations must stay on the main thread. On Linux, Wayland
and X11 connections and their callbacks are serviced by the owning event loop. On Windows, the
Win32 message loop dispatches native window callbacks. Do not move a `Window`, native window
object, or callback that captures UI-thread state to a background task.

Platform callback setters connect operating-system events to GPUI and run on the UI thread. For
foreign-function interfaces, treat callback context pointers as borrowed for the lifetime defined
by the native API: keep their backing state alive until callbacks are unregistered and no callback
is in flight. Copy data that must outlive a callback. Do not retain a pointer supplied by an OS
callback, or call UI APIs from an arbitrary native worker thread; schedule that work on the
foreground executor.

[`Window::window_handle()`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Window.html#method.window_handle)
returns GPUI's typed window identity. `Window` also exposes the borrowed
`raw_window_handle::HasWindowHandle` and `HasDisplayHandle` views for integrations that need native
interop. Their returned handles are tied to the borrow; do not keep their raw pointers after that
borrow ends. A headless backend may return `HandleError::NotSupported`, so check the result before
entering platform-specific code. See the [`raw-window-handle` API](https://docs.rs/raw-window-handle/0.6/raw_window_handle/)
for the lifetime contract.

Use [`Window::viewport_size`](crate::Window::viewport_size) for layout and drawing
inside a window. [`Window::bounds`](crate::Window::bounds) reports backend window
geometry; its origin and decoration coverage depend on the window system.
Wayland does not provide an ordinary top-level window's global desktop position,
and a browser canvas has no desktop window rectangle. For persistence, use
[`Window::window_bounds`](crate::Window::window_bounds), which also carries
restoration state such as fullscreen or maximized. Keep these values separate
from element bounds, whose origin is inside the window's drawable area.

## Appearance, backdrops, and document state

[`Window::appearance`](crate::Window::appearance) reports the platform's light,
dark, or vibrant appearance. It does not apply a theme. Choose colors in the
application and observe appearance changes when the theme should follow the
system. The [`colors`](crate::colors) module supplies a small palette and
explains how to install and observe it.

[`Window::set_background_appearance`](crate::Window::set_background_appearance)
instead requests transparency or a native backdrop, such as blur. The desktop
and renderer determine which effects are available. An opaque background
painted by the root view covers whatever is behind it, even when the native
window supports transparency.

Document state is a third concern. On macOS,
[`Window::set_window_edited`](crate::Window::set_window_edited) updates the
unsaved-changes indicator in the window controls, and
[`set_document_path`](crate::Window::set_document_path) associates a represented
filename with the window. Other supplied native backends ignore these requests.
Keep the document's actual path and modified flag on its model. Changing native
chrome neither notifies that model nor saves its contents. Install a
[`Window::on_window_should_close`](crate::Window::on_window_should_close)
callback if closing requires a save or discard decision; return `false` while
that decision is pending.

## Wait for a prompt without blocking the window

[`Window::prompt`](crate::Window::prompt) returns a receiver. Await it in a
foreground task, then reacquire the window to apply the answer. This example
confirms every native close request; an editor would install the same pattern
around its unsaved-document check:

```rust,no_run
use gpui::{App, PromptButton, PromptLevel, Window};
use std::{cell::Cell, rc::Rc};

fn confirm_before_close(window: &Window, cx: &App) {
    let pending = Rc::new(Cell::new(false));
    window.on_window_should_close(cx, move |window, cx| {
        if pending.replace(true) {
            return false; // A decision is already in progress.
        }
        let answer = window.prompt(
            PromptLevel::Warning,
            "Close this window?",
            Some("Unsaved changes will be discarded."),
            &[
                PromptButton::cancel("Keep editing"),
                PromptButton::ok("Discard changes"),
            ],
            cx,
        );
        let pending = pending.clone();
        window.spawn(cx, async move |cx| {
            let discard = matches!(answer.await, Ok(1));
            // The window can close through another route while we wait.
            let _ = cx.update(|window, _| {
                pending.set(false);
                if discard {
                    window.remove_window();
                }
            });
        }).detach();
        false // Veto this request while the task waits for an answer.
    });
}
```

The answer is an index into the supplied slice, so cancellation and discard
have explicit meanings here. A dropped response channel also keeps the window
open. Detaching the task lets it finish after the close-request callback returns;
dropping an ordinary [`Task`](crate::Task) would cancel that wait. If the window
has already gone, the final update fails and there is no close decision left to
apply. [`Window::remove_window`](crate::Window::remove_window) removes it directly
after approval, without asking the same close callback again.

With the default builder, macOS and Windows use native dialogs; the other
supplied window backends use the in-window fallback. Set
[`App::set_prompt_builder`](crate::App::set_prompt_builder) to choose the
built-in fallback or your own view on every target. Custom views report an
answer by emitting [`PromptResponse`](crate::PromptResponse) after attachment
through [`PromptHandle::with_view`](crate::PromptHandle::with_view).

In-window prompts replace one another rather than forming a stack. Guard an
outstanding decision as above when several requests should share it. A late
response from a replaced view cannot dismiss the current prompt. When the
current prompt answers, GPUI restores the focus target selected before the
first prompt; it does not activate the native window.

Native keyboard conventions differ. Use at most one `Ok` and one `Cancel`
answer, name each consequence clearly, and test the native dialog on the
platform you ship. See [`PromptButton`](crate::PromptButton) and
[`FallbackPromptRenderer`](crate::FallbackPromptRenderer) for role and keyboard
details. The [testing chapter](https://gpui-ce.github.io/book/testing.html)
separates testing the decision from checking the operating-system dialog.

## Capability and error behavior

The common platform traits describe capabilities, but individual operating systems do not
implement every service the same way. For example, Linux's application-level
hide/activate operations are no-ops, while its window-level visibility and
activation operations have separate implementations. macOS rejects anchored
popup windows. The browser backend reports an unsupported error for the native
path-picker contract; a browser file input instead provides files without
ordinary desktop filesystem paths.
Some operations return an error or a task that resolves to an error; others use an optional
result, invoke a fallback, or intentionally do nothing. Check the method contract and handle its
unsupported result in shared application code. Do not infer support from a successful build or
from a no-op that is silent.

The platform-level popup, layer-shell, and screen-capture APIs are target- or feature-gated. Layer
shell is only exposed for Linux builds with the Wayland feature. Screen capture currently has
native frame representations on macOS and Windows, gated by `screen-capture`; the default platform
trait reports unavailable on other targets. Consult the [`Platform`](crate::Platform) trait
and the specific operation's return type for the behavior your app needs.

These native `Platform` methods have notable target-specific behavior in this checkout:

| Method or service | Linux/FreeBSD | macOS | Windows |
| --- | --- | --- | --- |
| `activate`, `hide`, `hide_other_apps`, `unhide_other_apps` | All four are no-ops. | Uses AppKit application activation and visibility APIs. | `activate` and `hide` are no-ops. `hide_other_apps` and `unhide_other_apps` currently panic because they call `unimplemented!()`. |
| `PlatformWindow::prompt` | Wayland, X11, and headless windows return `None`; GPUI must render its own prompt. | Opens an AppKit alert. | Opens a Win32 task dialog. |
| `prompt_for_paths`, `prompt_for_new_path`, `can_select_mixed_files_and_dirs` | Uses the desktop file chooser portal when a window backend is enabled. Cancel returns `Ok(None)`; missing portal or other request failures return an error. The portal does not select files and folders together. | Uses `NSOpenPanel`/`NSSavePanel`; cancel returns `Ok(None)`. Mixed file and folder selection is supported. | Uses native file dialogs; cancel returns `Ok(None)`. Mixed file and folder selection is not supported. |
| `register_url_scheme` | Returns a task with an unsupported error. | Requires macOS 12 or later and an installed, bundled app; the task reports registration errors. | Returns a task with an unsupported error. |
| `path_for_auxiliary_executable` | Returns an unsupported error. | Looks up the named executable in the app bundle and errors if it is absent. | Returns an unsupported error. |
| `thermal_state`, `on_thermal_state_change`, haptics | Always reports `Nominal`, ignores thermal callbacks, and uses the trait's unsupported haptic defaults. | Reads system thermal state and registers change notifications. Haptics are reported available outside headless mode; AppKit may silently ignore them on hardware without haptic feedback. | Always reports `Nominal`, ignores thermal callbacks, and uses the trait's unsupported haptic defaults. |
| Screen capture | The shared trait reports unavailable. | Requires `screen-capture` and macOS 12.3 or later. | Requires `screen-capture`; the backend reports support when compiled with it. |
| Menus and recent documents | Stores the app menu model. Dock-menu and recent-document calls do nothing. | Installs the app menu and Dock menu and adds recent documents to AppKit's list. | Stores the app menu model and supports Windows jump-list updates. |
| `set_gpu_requirements` | Wayland and X11 accept `gpui_wgpu::WgpuDeviceRequirements`; headless mode ignores the request. | Accepts that type only with `macos-wgpu`; the default Metal renderer ignores it. | Uses the trait's no-op default. |

Treat `hide_other_apps` and `unhide_other_apps` as unsafe to call on Windows until the backend
implements them: unlike the other unsupported operations above, they panic instead of returning a
capability result. Most other service methods either return an error/task, return `None`, use a
fallback, or silently do nothing as shown. For window-level behavior, see the individual
[`PlatformWindow`](https://docs.rs/gpui-ce/0.2.2/gpui/trait.PlatformWindow.html) method contract.
Call `set_gpu_requirements` before opening the first window, as required by the shared trait; the
backend implementations store requirements for renderer setup.

## Development features

`test-support` exposes controlled app contexts and scheduling for tests. `bench-support` adds
benchmark support. `profiler` enables profiling utilities. `hot-patching` enables the experimental
native Subsecond integration; it does not run in WASM previews or release builds, and changes
outside patched entry points can require a restart. See the
[live editing guide](https://gpui-ce.github.io/guides/live-editing/) for native hot patching,
browser compilation, and Miri workflows.
