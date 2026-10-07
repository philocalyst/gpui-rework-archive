# Native platform API documentation audit

This audit covers the native support crates, excluding the core `gpui` interfaces and the WGPU
renderer partition:

- `gpui_linux`: `src/gpui_linux.rs`, `src/linux.rs`, `src/linux/character_palette.rs`,
  `dispatcher.rs`, `headless.rs`, `headless/client.rs`, `headless/window.rs`, `keyboard.rs`,
  `platform.rs`, `system_notifications.rs`, `wayland.rs`, all `wayland/*.rs`, `x11.rs`, all
  `x11/*.rs`, and `xdg_desktop_portal.rs`.
- `gpui_windows`: every source file under `src/`, including the Win32 window, DirectWrite,
  DirectX, clipboard, keyboard, dispatcher, display, shell, settings, notifications, and
  direct-manipulation modules.
- `gpui_macos`: every source file under `src/`, including AppKit windows, display links,
  pasteboard, keyboard, haptics, notifications, text services, screen capture, and platform
  lifecycle modules.
- `gpui_apple`: `src/gpui_apple.rs`, `src/metal_atlas.rs`, and `src/metal_renderer.rs`.

## Review ledger

The mechanical inventory found 138 `pub` declarations in Linux sources, 21 in Windows sources,
103 in macOS sources, and 22 in Apple sources. Most Linux, Windows, and macOS declarations are
inside private implementation modules or are raw OS FFI bindings; they are not application-facing
despite Rust's syntactic `pub`. The exported platform constructors and shared Metal renderer are
the supported surface.

This pass improved the exported native entry points and the shared Metal renderer with contracts
for thread affinity, headless behavior, borrowed native pointers, drawable sizing, transparency,
Core Animation transaction presentation, and fallible platform construction. It also removed
duplicate crate-level prose in the macOS and Apple roots.

The source remains authoritative for OS-specific details that cannot be compiled on the current
host. Raw AppKit, Win32, X11, Wayland, CoreVideo, and CoreFoundation symbols retain their SDK
names and are intentionally not wrapped in application-level prose. Their remaining missing-doc
inventory is therefore implementation-facing FFI rather than a user-facing GPUI API.

## Remaining limitations

The platform files still contain target-gated helper structs and generated or SDK-shaped fields
whose documentation would duplicate the native headers. A future target-aware rustdoc pass should
check those warnings on macOS and Windows hosts, especially Objective-C display-link callbacks,
Wayland serial lifetimes, X11 selection ownership, Win32 COM initialization, and DirectX device
loss. This pass did not change executable code, ABI declarations, or renderer behavior.
