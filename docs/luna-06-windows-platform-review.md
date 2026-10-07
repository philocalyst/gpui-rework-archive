# Luna 06: window and Windows platform documentation review

## Scope and read inventory

Reviewed every public method declaration in `Window` (`window.rs`, both `impl Window` blocks) and every method in the public `Platform`, `PlatformDisplay`, `PlatformWindow`, `PlatformTextSystem`, `PlatformAtlas`, and `InputHandler` traits. The audit checked the individual contracts for window creation and state, root replacement and handles, frame scheduling and presentation, focus and dispatch, layout and hit-testing, painting, accessibility, native window controls, display geometry, optional backend capabilities, text shaping, atlas resources, and IME operations. Implementations were read for the edited contracts and the phase-, coordinate-, lifetime-, and error-sensitive paths called out below.

Also reviewed `WindowId`, `WindowHandle`, `AnyWindowHandle`, `DispatchEventResult`, `ContentMask`, paint-quad constructors, `WindowOptions`, and `WindowParams`. Cross-checked implementations especially for `draw`, `present`, `on_next_frame`, `with_element_state`, offset and mask scopes, `transact`, autoscroll, layout and hitbox creation, input listener registration, `snap_bounds`, `cover_bounds`, `paint_quad`, `paint_scene`, and `compute_ime_candidate_bounds`.

The internal `PlatformDispatcher` trait is `#[doc(hidden)]` and explicitly not public API; it was inspected but not broadened. Test-only visual/threaded dispatcher code and diagnostics were left to their assigned owner.
- `crates/gpui/src/platform/app_menu.rs`, `keyboard.rs`, `keystroke.rs`, `layer_shell.rs`, `popup.rs`, `screen_capture.rs`, `screen_capture/windows.rs`, and `windows_screen_capture.rs`.
- Native or renderer consumers checked for behavior: `crates/gpui_windows/src/window.rs` and `events.rs`; `crates/gpui_linux/src/linux/wayland/window.rs`, `popup.rs`, and `client.rs`; `crates/gpui_linux/src/linux/x11/window.rs` and `client.rs`; `crates/gpui_macos/src/window.rs`, `platform.rs`, and `screen_capture.rs`; `crates/gpui_web/src/window.rs`; `crates/gpui/src/platform/test/window.rs`; and `crates/gpui_wgpu/src/wgpu_renderer/surfaces/windows.rs`.

No tests or builds were run, and no generated example include blocks were changed.

## Documentation corrections and locations

- `crates/gpui/src/platform.rs`: `InputHandler::bounds_for_range` had called its output “screen coordinates.” The editable-text implementation returns element-layout coordinates, and Windows scales the window-local caret origin before passing it to IMM. The docs now define range bounds and hit-test points as logical, window-local coordinates, with no screen-origin or device-pixel conversion by handlers. `PlatformWindow::update_ime_position` now describes the same input space and the backend conversion responsibility.
- `crates/gpui/src/platform.rs`: added lifecycle and callback-thread guidance to `ScreenCaptureSource`/`ScreenCaptureStream`, documented capture metadata resolution in device pixels, and documented the public payload field of `ScreenCaptureFrame`. The native macOS and Windows capture outputs are driven by capture callbacks; callers should send UI work to the foreground executor. Stream drop stops the Windows capture session.
- `crates/gpui/src/platform/screen_capture.rs`: removed a stale Wayland portal description. This module is only compiled on Windows with `screen-capture`; its current implementation enumerates Windows monitors on a worker thread and reports enumeration or stream-start errors separately.
- `crates/gpui/src/platform/windows_screen_capture.rs`: clarified that the frame owns a COM reference to the D3D11 texture and clones retain it, rather than describing the texture as borrowed from the callback frame. The dimensions and timestamp units agree with the implementation and `windows-capture` dependency (device pixels and 100-nanosecond units).
- `crates/gpui/src/platform/keystroke.rs`: replaced the stale parser syntax note with actual accepted modifier aliases, uppercase-key behavior, the test-only `->character` suffix, and the trailing-hyphen spelling. Corrected helper documentation where `command()` and `command_shift()` actually set the platform modifier, and `control_shift()` sets Control+Shift. Added guidance for choosing mapper-backed or raw wrappers.
- `crates/gpui/src/platform/keyboard.rs`: expanded the mapper contract to distinguish matching data from layout-specific display/equivalent data.
- `crates/gpui/src/platform/app_menu.rs`: clarified declarative menu dispatch, native-role limitations, and owned menu readback.
- `crates/gpui/src/window.rs`: clarified typed handle read-method selection and documented `ElementId` stability and use for retained state. Existing window docs already explain that handles do not own windows, stale handles fail after close/root replacement, element state is frame-retained by stable global ID, layout coordinates are logical pixels, and painting is phase-bound.
- `crates/gpui/src/window.rs`: the method audit sharpened the difference between additive and absolute prepaint offsets; documented the frame records rolled back by `transact` and the external/entity side effects it does not undo; described autoscroll requests as logical, window-local, frame-scoped geometry; and made layout IDs, layout bounds, and hitboxes explicitly frame-local. It also clarified tab-group ordering, the current-view render-stack precondition, image-cache scope, input listener phases/lifetime, weak entity capture in helper handlers, vetoable native close behavior, and logical coordinates in the direct painting APIs.
- `crates/gpui/src/platform.rs`: the method audit specified global logical coordinates for display rectangles, content-relative coordinates for pointer position, the `on_input` result flags, resize callback units, picker cancellation/error outcomes, URL registration/dispatch relationships, menu callback roles, and asynchronous credential failures. Optional methods were checked individually against their `None`, `false`, ready-task, default-value, or no-op implementations.

## Pinned consumer references

References were read at `target/zed-documentation-reference` commit `da0a7a78cf296a6d8a75894f46b71a8e7f19cb2f` and `target/hummingbird-documentation-reference` commit `2e1ee5f1c8d415ef7f835801fe368ab4106035b5`. These checkouts are clean. They are separate pinned trees, so their call sites are usage evidence, not a claim that their GPUI source or API version matches this checkout.

Useful Zed usage paths:

- `crates/gpui/src/app.rs` and `crates/gpui/src/app/context.rs`: window creation and generic/typed context access.
- `crates/workspace/src/persistence.rs` near the window-restoration test: restore a typed `WindowHandle` asynchronously and inspect it with `read_with`.
- `crates/terminal_view/src/terminal_view.rs` near `add_display_only_terminal`: update through `WindowHandle` while supplying the live `Window` and app context.
- `crates/settings/src/keymap_file.rs` near `find_binding_in_entries`: parse configured strokes and wrap them with `KeybindingKeystroke::new_with_mapper`.
- `crates/gpui/examples/set_menus.rs`: application menu construction with action and system-menu entries; `crates/gpui/src/app.rs` forwards `App::set_menus` to the platform with its keymap.
- `crates/gpui/src/app/test_context.rs` around `simulate_keystrokes`: parsed keystrokes are used to drive deterministic input tests.

Useful Hummingbird usage paths:

- `src/ui/settings.rs` and `src/ui/app.rs`: retain typed handles, find an existing window by `downcast`, and defer focus/update operations through `WindowHandle::update`; configure new windows with `WindowOptions` and logical-pixel bounds.
- `src/ui/components/menus_builder.rs`: build application-level `Menu` values and pass them through `App::set_menus`.
- `src/services/controllers.rs` and `src/services/controllers/windows.rs`: borrow the live window's raw native handle for external media-controller integration. This is a separate, shorter-lived native-handle borrow than storing a GPUI `WindowHandle`.
- `Cargo.toml`: Hummingbird depends on a separate `gpui-unofficial` shim, which reinforces the version-parity caveat.

## Remaining review notes for root

- The method-by-method source pass found no unresolved contract ambiguity in the edited `Window`, `Platform`, `PlatformDisplay`, or `PlatformWindow` comments. The remaining uncertainty is backend-dependent runtime support: for example, whether a compositor exposes a work area, honors a layer-shell request, supports moving tabs, allows picker cancellation after a receiver is dropped, or can report GPU/device state. The docs identify those capabilities as optional or best-effort rather than asserting uniform behavior.
- `PlatformTextSystem` and `PlatformAtlas` method contracts were read alongside their API types. Text metrics use font-system units unless a parameter is explicitly `Pixels`; font IDs are local to the text system, and atlas tiles belong to one renderer/window. No native implementation parity guarantee is implied for Zed or Hummingbird.

- Screen capture has two exposed layers: common capture traits in `platform.rs`, and the feature-gated public `screen_capture` module currently for Windows. macOS sources enter through its backend `Platform::screen_capture_sources`; the generic module docs should not be generalized to that backend-specific API without checking the intended public design.
- `ScreenCaptureFrame` has target-dependent payloads: Windows uses `WindowsScreenCaptureFrame`; macOS uses a CoreVideo image buffer; unsupported or feature-disabled configurations use `()`. Consumers that need native texture details must use the Windows-specific frame API and gate their code accordingly.
- `WindowParams` is the resolved backend boundary; app code normally sets `WindowOptions`. Native coordinates, decorations, popup placement, layer-shell behavior, IME conversion, and optional services remain backend-specific. The shared trait defaults identify unsupported capabilities, but a caller should still handle `None`, `false`, or no-op results where applicable.
- The popup and layer-shell prose and examples were already concrete and consistent with current Wayland implementations. Popup size comes from `WindowOptions` while its origin is ignored; the anchor rectangle stays parent-window-local and the compositor resolves final placement. Layer-shell margins use top/right/bottom/left ordering, and exclusive-zone values are logical pixels converted by the Wayland backend.
- Paint helpers use logical window coordinates, apply the current element offset and display scale while building the scene, and intersect with the active content mask. `paint_scene` uses the source-to-destination scale ratio, translates to the destination origin, clips to the destination and ancestor mask, and does not stretch to the destination size. Input routing is not imported with a scene.
- Suggested root review: check intra-doc links after integrating all parallel edits and check the `PlatformWindow` optional defaults against each backend's current implementation. The Zed and Hummingbird references are useful call-site evidence, not compatibility tests for this checkout.
