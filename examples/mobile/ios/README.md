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

The app-level suite passed 7/7 unflagged Release XCUITests at source checkpoint
`ac997d31662b8aa370acb729e64192f422b7cf77` (tree
`e1b6ef748b40c236a1cc3b728fb48e4024450647`). The mirrored artifact archive has
SHA-256 `6409cf9d203a7c06e803af5781c648105ba79ae1acd33510d6ac42b97a84ac74`;
its path-independent portable manifest has SHA-256
`123ca4c8fd12da798703f924f5273d2842d821881fbd185dc75049a2b6e69244`.
The simulator app executable hash is
`9aa5b92cf853642522fe6ad5a5a8fbd1be4a4eff65d41c694055560d820d5919`. The
arm64 device executable hash is
`9d0868f5478f4242def9def5bf1f8bcc58fa7a90befa14fac9d2a7d551bad38c`; it is
unsigned and was compile/package checked, not run on a physical device.

The suite covers real Pinyin composition/candidate selection, native emoji
input, UIKit double-tap word selection and keyboard replacement, caret hit
testing with padding and horizontal scrolling, UTF-16 selection, rotation,
keyboard inset geometry, background/resume, and process relaunch. Run it with a
booted iPhone simulator and Chinese (Simplified) Pinyin enabled:

```sh
IOS_SIMULATOR_UDID="SIMULATOR_UUID" ./examples/mobile/ios/run-app-acceptance.sh
```

The backend targets iOS 15 or newer. No physical-device runtime, VoiceOver
spoken-focus, or multi-window scene result is claimed. Device installation
requires a separately configured signing setup; the project does not choose a
team or modify keychain state.
