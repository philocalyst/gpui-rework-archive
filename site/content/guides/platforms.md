+++
aliases = ["fundamentals/windows.html", "guide/fundamentals/windows/", "guide/platforms/backends/", "guide/platforms/overview/", "platforms/backends.html", "platforms/overview.html"]
title = "Choose a platform backend"
description = "Keep the core, window platform, text system, and renderer on one revision."
weight = 100
+++

The `gpui` crate defines the application, view, input, layout, and scene APIs.
`gpui_ce_platform` selects the native OS implementation; `gpui_ce_web` supplies
the browser implementation for Wasm targets. Keep these crates on one checkout
revision: the platform implements the traits that core calls and carries the
renderer, text system, and OS services that make those calls concrete.

## Native application setup

macOS uses AppKit and Metal by default, with an opt-in WGPU path. Windows uses
Win32 and DirectX. Linux and FreeBSD select Wayland, X11, or both through the
platform crate's features. The text system uses Parley across these backends,
but font discovery and native input services still come from the target OS.

A `WindowOptions` value is a request to the selected platform, which may reject
or constrain a feature. Before relying on transparency, screen capture, shell
integration, decorations, or another native capability, check the method's
target/feature gates and handle its failure result. The
[setup guide](@/guides/setup.md) lists build prerequisites; the
[window guide](@/guides/windows.md) explains handles and root lifetime.

## Browser application setup

The web backend owns one document canvas and one normal top-level GPUI window.
Each documentation preview runs in an iframe, so each preview has its own
application, focus path, and canvas. Opening several previews does not create
several windows in one GPUI web application.

The browser renderer needs JavaScript, WebAssembly, and a supported graphics
backend. It tries WebGPU and can fall back to WebGL2. Browser APIs govern
clipboard permissions, installed/bundled fonts, input methods, and worker
availability; native service behavior should not be assumed. The compiled
walkthrough preview runs GPUI in Wasm. The editable Miri runtime is a separate
path; it is browser-portable only when compilation and interpretation both run
inside WebAssembly, so do not infer that capability from a working preview.

Read the [platform explanation](https://docs.rs/gpui-ce/0.2.2/gpui/_documentation/platforms/index.html)
for crate boundaries and features. Read the method contract for a particular
native operation; an OS name in a support table is not a guarantee for every
operation.
