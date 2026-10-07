# Luna 09: native backend review

## Changes in this pass

- Reworked [`crates/gpui/docs/platforms.md`](../crates/gpui/docs/platforms.md) into a backend guide with a working native startup example, target and renderer matrix, Cargo feature behavior, compositor selection, browser startup, per-backend headless limits, callback thread rules, borrowed native-handle guidance, and capability/error handling.
- Expanded the facade constructor documentation in [`crates/gpui_platform/src/gpui_platform.rs`](../crates/gpui_platform/src/gpui_platform.rs) to match how each constructor behaves in this checkout, including initialization failures, main-thread requirements, browser startup, and the macOS-only off-screen renderer.
- Corrected the `current_platform` documentation in [`crates/gpui_linux/src/linux.rs`](../crates/gpui_linux/src/linux.rs): backend connection and setup failures can panic because this API returns `Rc<dyn Platform>` rather than a `Result`.
- Documented the public Calloop channel types in [`crates/gpui_linux/src/linux/dispatcher.rs`](../crates/gpui_linux/src/linux/dispatcher.rs). The re-exported sender currently has no public send method; this note describes the exported API without changing its behavior.
- Completed a method-by-method review of each local `Platform` implementation. The guide now records cross-platform differences for app activation and visibility, native prompts and file dialogs, URL registration, auxiliary executables, thermal state, haptics, capture, menus, recent documents, and GPU requirements. It also warns that two Windows visibility methods panic.

## Source-backed findings and coordinates

- `gpui_platform::application` chooses `current_platform(false)` on native targets and automatic WebGPU selection on WebAssembly ([facade source](../crates/gpui_platform/src/gpui_platform.rs#L20), feature wiring in [Cargo.toml](../crates/gpui_platform/Cargo.toml#L16)). Windows construction returns an error, macOS construction requires `MainThreadMarker`, and Linux/FreeBSD initialization unwraps connection/setup in the selected client. The guide therefore describes startup as fallible and does not promise a `Result` from the facade ([guide](../crates/gpui/docs/platforms.md#L11), [Linux selection](../crates/gpui_linux/src/linux.rs#L35), [macOS constructor](../crates/gpui_macos/src/platform.rs#L236), [Windows constructor](../crates/gpui_windows/src/platform.rs#L121)).
- Linux/FreeBSD selection uses `ZED_HEADLESS`, then a non-empty `WAYLAND_DISPLAY`, then `DISPLAY`, then headless; selection only considers compiled features and does not test connection health ([`guess_compositor`](../crates/gpui/src/platform.rs#L118), [Linux current_platform](../crates/gpui_linux/src/linux.rs#L35)). The new guide records both precedence and the panic limitation ([guide](../crates/gpui/docs/platforms.md#L42)).
- `gpui_platform` has no facade defaults, but it depends on `gpui_linux` with workspace defaults, and `gpui_linux` defaults to both window systems. The facade's `wayland` and `x11` features only forward features; they do not remove features enabled transitively ([facade Cargo.toml](../crates/gpui_platform/Cargo.toml#L16), [Linux Cargo.toml](../crates/gpui_linux/Cargo.toml#L16)). The guide makes that additive behavior explicit ([guide](../crates/gpui/docs/platforms.md#L50)).
- Linux headless mode uses a synthetic 1920-by-1080 display, provides no native handles, drops scenes, and installs no frame callbacks ([headless client](../crates/gpui_linux/src/linux/headless/client.rs#L14), [headless window](../crates/gpui_linux/src/linux/headless/window.rs#L26)). Windows headless construction skips DirectX device creation while retaining DirectWrite and OLE ([Windows platform](../crates/gpui_windows/src/platform.rs#L118)). macOS remains AppKit-main-thread-bound and uses a different `CFRunLoopRun` path for headless mode ([macOS platform](../crates/gpui_macos/src/platform.rs#L232), [run](../crates/gpui_macos/src/platform.rs#L519)); its window path is still a native AppKit window implementation, so the guide avoids promising portable off-screen windows. The facade's `current_headless_renderer` is gated behind test/bench support and returns a Metal renderer only on macOS ([facade](../crates/gpui_platform/src/gpui_platform.rs#L116)).
- The browser text system starts without system fonts, WebGPU initialization is lazy and `Auto` falls back to WebGL2, and browser windows are constrained to one top-level window per document ([web platform](../crates/gpui_web/src/platform.rs#L41), [graphics setup](../crates/gpui_web/src/platform.rs#L213), [web window error](../crates/gpui_web/src/platform.rs#L84)). The guide links the local hello-web example for the start hook and backend selection ([guide](../crates/gpui/docs/platforms.md#L92), [example](../crates/gpui_web/examples/hello_web/main.rs#L432)).
- The shared `Platform` contract says platform work is on the UI thread, background work can run elsewhere, and window callbacks are installed through `PlatformWindow` ([platform traits](../crates/gpui/src/platform.rs#L173), [`PlatformWindow`](../crates/gpui/src/platform.rs#L959)). `Window` delegates `HasWindowHandle` and `HasDisplayHandle` to its platform window; headless windows return `HandleError::NotSupported` ([window delegation](../crates/gpui/src/window.rs#L7983), [headless handles](../crates/gpui_linux/src/linux/headless/window.rs#L42)). The guide warns about UI-thread callbacks and borrowed raw handles ([guide](../crates/gpui/docs/platforms.md#L110)).
- The examples use `gpui_platform::application().run(...)` as the normal app boundary ([shared prelude](../crates/gpui/examples/shared/prelude.rs#L47), [editable text example](../crates/gpui_elements/examples/editable_text.rs#L51)). Hummingbird uses `gpui_platform::current_platform()` and runs the resulting application in its UI startup path ([pinned Hummingbird `src/ui/app.rs`](https://github.com/hummingbird-player/hummingbird/blob/2e1ee5f1c8d415ef7f835801fe368ab4106035b5/src/ui/app.rs#L13), [run call](https://github.com/hummingbird-player/hummingbird/blob/2e1ee5f1c8d415ef7f835801fe368ab4106035b5/src/ui/app.rs#L373)).
- The Linux dispatcher module is private but its public items are glob-re-exported by the crate. `PriorityQueueCalloopReceiver::new` creates a Calloop event source, while the sender's `send` method is private; external callers can hold/drop the sender but cannot enqueue items ([`linux.rs`](../crates/gpui_linux/src/linux.rs#L1), [dispatcher API](../crates/gpui_linux/src/linux/dispatcher.rs#L160)). This is an API-shape concern for a future API pass, not changed here.
- The exported `Platform` implementations were compared method-by-method with the shared trait. Windows `hide_other_apps` and `unhide_other_apps` call `unimplemented!()` and panic; Linux returns successfully while doing nothing for the four app visibility methods; Windows also silently ignores `activate` and `hide` ([Windows](../crates/gpui_windows/src/platform.rs#L539), [Linux](../crates/gpui_linux/src/linux/platform.rs#L342), [shared trait contract](../crates/gpui/src/platform.rs#L187)). The guide calls out this distinction rather than describing every unsupported operation as harmless.
- Other documented differences come from local method bodies: Linux/FreeBSD uses the desktop file chooser portal and cannot select files and folders in one request ([Linux dialogs](../crates/gpui_linux/src/linux/platform.rs#L400)); macOS uses AppKit panels, supports mixed selection, and gates URL registration on macOS 12+, a bundle ID, and installation ([macOS platform](../crates/gpui_macos/src/platform.rs#L760)); Windows uses shell dialogs but cannot select mixed files and folders, and returns immediate errors for URL registration and auxiliary executables ([Windows platform](../crates/gpui_windows/src/platform.rs#L613)). Capture, thermal feedback, haptics, menus, and GPU requirements were checked in their corresponding `Platform` overrides and feature gates ([Mac haptics](../crates/gpui_macos/src/haptic_feedback.rs#L10), [screen capture](../crates/gpui_macos/src/platform.rs#L651), [Linux GPU requirements](../crates/gpui_linux/src/linux/wayland/client.rs#L1060)). GPU requirements must be set before the first window is opened ([shared trait](../crates/gpui/src/platform.rs#L468)).

## Exported API coverage

The native public surface was enumerated from each crate root, including public declarations re-exported from private modules:

- `gpui_platform` exports `Platform`, application/platform constructors, and WebAssembly-only backend helpers. Each exported function was checked against its target-specific implementation and feature gate.
- `gpui_linux` exports `current_platform` and glob-re-exports the Calloop dispatcher module. The receiver's `new()` and `calloop::EventSource` implementation were read, as were the sender surface, `Drop`, and associated error type.
- `gpui_macos` exports `MacPlatform`; its public inherent constructor and every `Platform` override were reviewed. Other backend modules are private and are not external crate API.
- `gpui_windows` exports `WindowsPlatform`; its public inherent constructor and every `Platform` override were reviewed. Other backend modules are private and are not external crate API.

The review checked the full local `Platform` override lists for executor and text setup, event-loop lifecycle, displays and windows, GPU setup, prompts, filesystem and URL services, callbacks, notifications, menus, thermal/haptic support, credentials, clipboard, keyboard, and cursor behavior. The guide focuses on differences that change caller decisions; unchanged shared contracts remain in the linked API reference. It did not exhaustively review every private `PlatformWindow` method or rendering, clipboard, and input helper.

## Pinned reference repositories

These sources were used as examples of architecture and startup usage only. Local source above is authoritative for behavior.

- Zed documentation reference: commit [`da0a7a78cf296a6d8a75894f46b71a8e7f19cb2f`](https://github.com/zed-industries/zed/tree/da0a7a78cf296a6d8a75894f46b71a8e7f19cb2f). Read `crates/gpui_platform/src/gpui_platform.rs`, `crates/gpui_linux/src/linux.rs`, `crates/gpui_linux/src/linux/dispatcher.rs`, and the opening sections of `crates/gpui_macos/src/platform.rs` and `crates/gpui_windows/src/platform.rs`. The facade and Linux implementation illustrate keeping app code independent of platform selection and selecting Linux backends from the environment. Their implementations differ from this checkout; no behavioral claims above were copied from them.
- Hummingbird documentation reference: commit [`2e1ee5f1c8d415ef7f835801fe368ab4106035b5`](https://github.com/hummingbird-player/hummingbird/tree/2e1ee5f1c8d415ef7f835801fe368ab4106035b5). Read `src/main.rs` and `src/ui/app.rs`. Its app startup initializes `current_platform`, configures the application, and enters `Application::run`, which informed the practical startup example.

## Files read

Local files read for API and implementation review:

- `Cargo.toml`
- `crates/gpui/docs/platforms.md`
- `crates/gpui/src/gpui.rs`
- `crates/gpui/src/platform.rs`
- `crates/gpui/src/window.rs`
- `crates/gpui_platform/Cargo.toml`
- `crates/gpui_platform/src/gpui_platform.rs`
- `crates/gpui_linux/Cargo.toml`
- `crates/gpui_linux/src/gpui_linux.rs`
- `crates/gpui_linux/src/linux.rs`
- `crates/gpui_linux/src/linux/dispatcher.rs`
- `crates/gpui_linux/src/linux/platform.rs`
- `crates/gpui_linux/src/linux/headless.rs`
- `crates/gpui_linux/src/linux/headless/client.rs`
- `crates/gpui_linux/src/linux/headless/window.rs`
- `crates/gpui_linux/src/linux/wayland/client.rs`
- `crates/gpui_linux/src/linux/wayland/window.rs`
- `crates/gpui_linux/src/linux/x11/client.rs`
- `crates/gpui_linux/src/linux/x11/window.rs`
- `crates/gpui_macos/Cargo.toml`
- `crates/gpui_macos/src/gpui_macos.rs`
- `crates/gpui_macos/src/platform.rs`
- `crates/gpui_macos/src/window.rs`
- `crates/gpui_macos/src/wgpu_renderer.rs`
- `crates/gpui_macos/src/haptic_feedback.rs`
- `crates/gpui_windows/Cargo.toml`
- `crates/gpui_windows/src/gpui_windows.rs`
- `crates/gpui_windows/src/platform.rs`
- `crates/gpui_windows/src/window.rs`
- `crates/gpui_web/src/platform.rs`
- `crates/gpui_web/examples/hello_web/main.rs`
- `crates/gpui/examples/shared/prelude.rs`
- `crates/gpui_elements/examples/editable_text.rs`

Reference files read are listed under the pinned repositories above.

## OS-specific items not verified in this pass

- No macOS, Windows, Wayland, or X11 runtime session was available for validating visual behavior, GPU driver availability, native dialogs, permissions, compositor-specific protocols, or OS event ordering.
- The guide's platform matrix is based on the checked-in constructors and trait implementations, not a compatibility promise for every OS version, desktop environment, GPU, or browser.
- No build, test, or platform runtime checks were run, per the task scope.
