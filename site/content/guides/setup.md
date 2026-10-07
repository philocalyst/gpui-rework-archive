+++
aliases = ["getting-started.html", "getting-started/first-app.html", "guide/getting-started/", "guide/getting-started/first-app/"]
title = "Set up your platform"
description = "Install the Rust toolchain and native libraries required to open a window."
weight = 10
+++

The walkthroughs use the APIs in this checkout. Clone the repository, enter it,
and use Rust 1.95 or newer. Check the crate's `rust-version` when changing revisions.

```sh
git clone https://github.com/gpui-ce/gpui-ce.git
cd gpui-ce
rustup component add rustfmt clippy
```

## macOS

Install [Xcode](https://developer.apple.com/xcode/) and its macOS components.
Launch Xcode once, then select it as the active developer directory:

```sh
xcode-select --install
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

Change the path if Xcode lives elsewhere. The default native renderer uses Metal.
See Apple's [command line tools guide](https://developer.apple.com/documentation/xcode/installing-the-command-line-tools).

## Linux and FreeBSD

Enable `wayland`, `x11`, or both on `gpui_ce_platform`. The downloaded walkthrough
projects enable both. On Debian or Ubuntu, install the development libraries:

```sh
sudo apt-get update
sudo apt-get install -y build-essential pkg-config \
  libxkbcommon-dev libxkbcommon-x11-dev libwayland-dev libx11-dev \
  libxcb-shape0-dev libxcb-xfixes0-dev libxcb-randr0-dev libxcb-xinput-dev \
  libegl1-mesa-dev libgles2-mesa-dev libglib2.0-dev libfontconfig-dev
```

Use your distribution's equivalents on other systems. Native examples need a
graphical session and a supported GPU backend. Headless scenario tests have a
separate [testing workflow](@/guides/testing.md).

## Windows

Use the MSVC Rust toolchain, Visual Studio C++ build tools, and a Windows SDK.
Microsoft's [Rust setup guide](https://learn.microsoft.com/en-us/windows/dev-environment/rust/setup)
explains the installer choices. Run Cargo from a shell that can find the toolchain.

## Check one window

```sh
cargo run --manifest-path site/examples/Cargo.toml --bin first-window
```

Expect a window containing “Hello, GPUI”. Closing the last walkthrough window
quits the application. If the build fails, read the first compiler error before
changing the example. A linker or system-library error usually belongs to the
platform setup; a missing GPUI method often means a [version mismatch](@/reference/versions.md).
