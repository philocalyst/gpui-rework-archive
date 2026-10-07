+++
aliases = ["getting-started.html", "getting-started/first-app.html", "guide/getting-started/", "guide/getting-started/first-app/"]
title = "Set up your platform"
description = "Install the Rust toolchain and native libraries required to open a window."
weight = 10
+++

The walkthroughs use this checkout's development APIs. The core crate currently
requires Rust 1.95 or newer; confirm `rust-version` after changing revisions.
Clone the repository and install the Rust components used by the project:

```sh
git clone https://github.com/gpui-ce/gpui-ce.git
cd gpui-ce
rustup component add rustfmt clippy
```

## macOS

Install [Xcode](https://developer.apple.com/xcode/) and its macOS components,
then launch Xcode once to finish setup. Select it as the active developer
directory and verify the selected path:

```sh
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
xcode-select -p
```

Change the path if Xcode lives elsewhere. The standalone Command Line Tools
package is not the same selection as the full Xcode developer directory. GPUI's
default native renderer uses Metal. See Apple's
[command line tools guide](https://developer.apple.com/documentation/xcode/installing-the-command-line-tools).

## Linux and FreeBSD

The downloaded walkthrough project enables both `wayland` and `x11` features
on `gpui_ce_platform`, so its native build may need headers for both backends.
On Debian or Ubuntu, install the development libraries:

```sh
sudo apt-get update
sudo apt-get install -y build-essential pkg-config \
  libxkbcommon-dev libxkbcommon-x11-dev libwayland-dev libx11-dev \
  libxcb-shape0-dev libxcb-xfixes0-dev libxcb-randr0-dev libxcb-xinput-dev \
  libegl1-mesa-dev libgles2-mesa-dev libglib2.0-dev libfontconfig-dev
```

Use your distribution's package equivalents on other systems. A successful
compile does not provide a display server: to open the example, start a Wayland
or X11 session and use a supported GPU backend. Controlled app tests have a
separate [testing workflow](@/guides/testing.md) and do not require this window.

## Windows

Use the MSVC Rust toolchain, Visual Studio C++ build tools, and a Windows SDK.
Microsoft's [Rust setup guide](https://learn.microsoft.com/en-us/windows/dev-environment/rust/setup)
explains the installer choices. Run Cargo from PowerShell or a developer shell
that can find the MSVC linker and Windows SDK.

## Check one window

```sh
cargo run -p gpui-documentation-examples --example first-window
```

Expect a window containing “Hello, GPUI”. Closing the last walkthrough window
quits this example application. If the build fails, first classify the error:
a missing header or linker library points to native prerequisites; a missing
GPUI method usually means the source and dependency revisions differ. See the
[version guide](@/reference/versions.md) before changing the code to match an
older API.
