# Platforms

GPUI runs on macOS, Windows, Linux and in web browsers. The [`App`] API is the
same everywhere; `gpui_platform::application()` picks the right backend for the
target you build for. This page describes what each backend uses underneath and
what it supports.

## Rendering and input

| | macOS | Windows | Linux | Web |
| --- | --- | --- | --- | --- |
| Windows | AppKit | Win32 | Wayland or X11 | One `<canvas>` filling the page |
| GPU | Metal | Direct3D 11 | wgpu (Vulkan or OpenGL) | wgpu (WebGPU, or WebGL2 as a fallback) |
| Text layout | Parley | Parley | Parley | Parley |
| Glyph rendering | Core Text | DirectWrite | Swash | Swash |
| Fonts | System fonts and fonts you add | System fonts and fonts you add | System fonts and fonts you add | Only fonts you add |
| Input methods (IME) | Yes | Yes | Wayland `text-input-v3`, X11 XIM | Yes, through a hidden text area |
| Touch and gestures | Trackpad gestures | Touchpad pan and zoom | Wayland and X11 touch | Pointer and touch events |
| Accessibility | AccessKit | AccessKit | AccessKit (AT-SPI) | Not yet |
| Multiple windows | Yes | Yes | Yes | No |

Text is laid out the same way everywhere, by [Parley](https://github.com/linebender/parley),
so line breaks and measurements match across platforms. Glyphs are rasterized
by each platform's own font renderer where there is one, so text looks native.

On Linux, GPUI chooses the windowing system at startup: Wayland if
`WAYLAND_DISPLAY` is set, otherwise X11 if `DISPLAY` is set. Build with the
`wayland` and `x11` features of `gpui_platform` to support both; at least one is
required. FreeBSD uses the Linux backends and is not tested in CI.

## Platform services

| | macOS | Windows | Linux | Web |
| --- | --- | --- | --- | --- |
| Clipboard | Text and images | Text and images | Text and images | Text and images; read asynchronously |
| Application menus | Menu bar | Stored, not drawn | Not available | Not available |
| Dock or taskbar menu | Dock menu | Jump list | Not available | Not available |
| File dialogs | Yes | Yes | XDG desktop portal | Not available |
| System notifications | Yes | Yes | Freedesktop notifications | Not available |
| Credential storage | Keychain | Yes | Secret Service | Not available |
| Open URLs and files | Yes | Yes | Yes | URLs only |
| Haptic feedback | Force Touch trackpads | Not available | Not available | Not available |
| Screen capture | ScreenCaptureKit, with `screen-capture` | Windows Graphics Capture, with `screen-capture` | Not available | Not available |
| Transparent or blurred windows | Yes | Yes, including Mica | Transparency; blur on KDE | Not available |
| Layer-shell surfaces | No | No | Wayland, with `WindowKind::LayerShell` | No |

Methods for services a platform lacks still exist. They do nothing, return an
error, or return `None`, as their documentation describes, so code that uses them
compiles everywhere.

## The web

On the web, a GPUI app is one window drawn into a canvas that fills the page.
Some differences matter when you write portable code:

* Browsers don't let GPUI see system fonts. Add the fonts your app uses with
  [`TextSystem::add_fonts`] before you draw text.
* There is no file system. Load images and other assets from bytes or URLs.
* Window size, position and title bar options are ignored: the canvas fills the
  page.
* Unless you build with WebAssembly threads and serve the page with cross-origin
  isolation, background work runs on the main thread.
* Reading the clipboard is asynchronous: use
  [`App::read_from_clipboard_async`], because [`App::read_from_clipboard`]
  always returns `None`.

[Run on the web](crate::_documentation::guides::web) shows how to build and serve
an app.

## System requirements

* **macOS:** Xcode and its command line tools, for the Metal shader compiler.
* **Windows:** the MSVC toolchain and a Windows SDK. GPUI needs Direct3D 11
  feature level 11.0.
* **Linux:** a few development packages for Wayland, X11, xkbcommon and
  fontconfig; [start a project](crate::_documentation::guides::start_a_project)
  lists them. A Vulkan or OpenGL driver is needed at run time.
* **Web:** a browser with WebGPU or WebGL2.

GPUI needs Rust 1.95 or newer.

## Platform-specific features

These features of the `gpui` and `gpui_platform` crates enable code for
particular platforms:

| Feature | Effect |
| --- | --- |
| `wayland`, `x11` | The Linux windowing backends. Both are on by default in `gpui`. |
| `windows-manifest` | Embeds an application manifest in Windows executables. On by default. |
| `screen-capture` | Screen capture on macOS and Windows. |
| `macos-wgpu` (on `gpui_platform`) | Draws macOS windows with wgpu instead of Metal, so they can show your own wgpu textures. |
| `custom-gpu` | An API for drawing into a window with your own wgpu code. |

The [crate features](crate#crate-features) table lists all of GPUI's features.
