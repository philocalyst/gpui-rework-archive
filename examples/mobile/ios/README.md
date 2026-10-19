# iOS example

A UIKit app that runs the view in `examples/mobile/src/lib.rs` on GPUI's iOS backend,
`gpui_ios`, which draws with Metal. `examples/mobile/examples/ios.rs` is the whole app: it opens
the window on the platform that `gpui_platform` selects. It targets iOS 15 and newer.

## Build and run

You need Xcode and the Rust target `aarch64-apple-ios-sim` for the simulator, or
`aarch64-apple-ios` for a device.

```sh
examples/mobile/ios/build-rust.sh Debug iphonesimulator
xcrun simctl install booted target/aarch64-apple-ios-sim/debug/GpuiMobile.app
xcrun simctl launch booted dev.gpui.mobile.example
```

The simulator build is ad-hoc signed. A device build is left unsigned; sign it with your own
identity to install it.

`Info.plist` registers GPUI's scene delegate. The backend supports one connected
`UIWindowScene` at a time.
