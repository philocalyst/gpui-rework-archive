+++
aliases = ["fundamentals/windows.html", "guide/fundamentals/windows/", "guide/platforms/backends/", "guide/platforms/overview/", "platforms/backends.html", "platforms/overview.html"]
title = "Choose a platform backend"
description = "Keep the core, window platform, text system, and renderer on one revision."
weight = 100
+++

Use `gpui_ce_platform` to select the native backend, or `gpui_ce_web` to provide
a browser platform. The core `gpui` library keeps the view and state APIs
independent of that selection.

## Native application setup

macOS uses AppKit and Metal by default. Windows uses Win32 and DirectX.
Linux and FreeBSD select Wayland, X11, or both through platform features.
The current text system uses the shared Parley backend.

A window option is a request to that platform. Check its API before relying on
transparency, capture, shell integration, decorations, or another native
capability. The [setup guide](@/guides/setup.md) covers build prerequisites.

## Browser application setup

The web backend supports one GPUI window per document. Each documentation
preview gets an iframe, which isolates its window and focus. Multiple previews
are separate applications rather than multiple windows in one application.

The browser renderer needs JavaScript, WebAssembly, and the supported graphics
backend. Platform services retain their browser constraints: clipboard access,
font availability, permissions, and threading are not identical to native
services.

Read the [platform explanation](https://docs.rs/gpui-ce/0.2.2/gpui/_documentation/platforms/index.html)
for crate boundaries and features. Read the method contract for a particular
native operation; an OS name in a support table is not a guarantee for every
operation.
