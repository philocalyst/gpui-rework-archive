# GPUI CE iOS acceptance app

The iOS target is a native Rust executable built on the canonical Zed-derived
`gpui_ios` UIKit/Metal backend. Its entry point is
`examples/ios.rs`; it opens the same `open_main_window` acceptance UI used by
the Android example. There is no separate longbridge UIKit bridge or Swift
application lifecycle in the active build path.

## Prerequisites

Use macOS with Xcode and command line tools, Rust 1.95.0 or newer, and the
`aarch64-apple-ios` and `aarch64-apple-ios-sim` standard-library targets.
The build script does not install toolchains, choose a signing team, access a
developer account, or change keychain state.

## Build and package

From this directory, build and package an arm64 simulator app:

```sh
IOS_PACKAGE_DIR=/path/to/artifacts ./build-rust.sh Debug iphonesimulator
```

For a device-target Rust executable and unsigned app bundle:

```sh
IOS_PACKAGE_DIR=/path/to/artifacts ./build-rust.sh Release iphoneos
```

The simulator app receives an ad-hoc signature, which uses no team or signing
identity. The device app remains unsigned; installing it requires a separately
authorized local signing setup. Build logs and packages are retained under the
selected output directory.

The Info.plist registers the native GPUI scene delegate, supports iPhone and
iPad orientations, and permits iPad split sizing. The current backend accepts
one connected `UIWindowScene`; multiple simultaneous scenes are unsupported.

## Validation status

A Cargo target build checks compilation and packaging only. Simulator install,
launch, lifecycle, touch, IME, VoiceOver, and iPad multitasking checks must be
recorded separately against the matching Xcode simulator runtime. Device
runtime validation requires a physical device and separately authorized code
signing.
