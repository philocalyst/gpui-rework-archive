# Platforms, features, and versions

The core `gpui-ce` package exposes the `gpui` Rust library. The platform facade
is the `gpui_ce_platform` package, usually renamed to `gpui_platform` in
`Cargo.toml`. Renderer and text backends are separate crates.

Choose these packages from the same release or Git revision. A compatible
package name does not make source from a newer checkout compatible with an
older published release.

## Native windows

| Platform | Window system | Rendering |
| --- | --- | --- |
| macOS | AppKit | Metal by default; WGPU is an opt-in backend. |
| Windows | Win32 | DirectX. |
| Linux / FreeBSD | Wayland and/or X11 | The configured GPU backend. |

Linux and FreeBSD applications enable at least one window-system feature on
the platform crate. Build prerequisites and exact commands live in the
[setup guide](https://gpui-ce.github.io/guides/setup/).

Window options are requests to the selected platform. Not every platform
supports each decoration, capture, background, or shell operation. The specific
method documents its capability and failure behavior. Avoid interpreting a
successful local build as evidence that a native operation exists on another OS.

## Browser windows

The web platform compiles the GPUI application to WebAssembly and paints through
its browser graphics backend. It does not replace a GPUI view with a semantic
HTML approximation. The backend currently supports one window per document;
the documentation uses a separate iframe for each preview.

The browser has its own focus, permissions, clipboard, font availability, and
threading constraints. A native example that requests a desktop service may
need a browser-specific alternative. A shared `Render` implementation can still
use the same layout and event logic on both platforms.

## Development features

`test-support` exposes controlled app contexts and scheduling for tests.
`bench-support` adds benchmarking support; `bench` remains a compatibility
alias. `profiler` enables profiling utilities. `hot-patching` enables the native
Subsecond integration and is experimental.

Hot patching applies to supported native debug builds. It cannot run in a WASM
preview or a release build. Some edits require a restart, particularly changes
outside the patched entry points. See the
[live editing guide](https://gpui-ce.github.io/guides/live-editing/) for the
separate native hot-patching, browser compilation, and Miri workflows.
