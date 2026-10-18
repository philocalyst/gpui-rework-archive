# Build for iOS and Android

Use the same GPUI view code with the platform backend selected for the target. Android and iOS have separate native hosts and build pipelines; a successful Rust compile does not prove that a device can present frames or that its IME and lifecycle callbacks work.

## Choose the platform backend

The target-aware `gpui_ce_platform` package selects the backend on mobile targets:

| Target | Backend | Native host |
| --- | --- | --- |
| Android | `gpui_ce_mobile`, imported as `gpui_mobile` | Android NativeActivity in the shared example; the crate also exposes a host-driven Activity integration. |
| iOS | `gpui_ce_ios`, imported as `gpui_ios` | UIKit and Metal. `gpui_ce_apple` provides shared Apple renderer and CoreText support. |

Put application UI and state in ordinary GPUI views. Keep JNI, UIKit, surfaces, lifecycle events, and text-input protocol handling in the platform host. The shared example is under `examples/mobile`. The iOS backend currently supports one connected `UIWindowScene`; it does not support multiple simultaneous scenes.

## Android prerequisites and build

Install an Android SDK with platform and build tools 36, an Android NDK, a JDK supported by the checked-in Gradle wrapper, Rust 1.95 or newer, and cargo-ndk. Set ANDROID_SDK_ROOT and ANDROID_NDK_HOME for your SDK installation. The example declares minSdk 26, targets SDK 36, and packages arm64-v8a and x86_64 libraries.

From the repository root, build the Rust native libraries and assemble the APK:

```sh
cargo ndk -t arm64-v8a -t x86_64 -P 26 \
  -o examples/mobile/android/app/src/main/jniLibs \
  build -p gpui-ce-mobile-example --lib --release

(
  cd examples/mobile/android
  ./gradlew --no-daemon \
    -Pandroid.aapt2FromMavenOverride="$ANDROID_SDK_ROOT/build-tools/36.0.0/aapt2" \
    assembleDebug
)
```

The APK is written to examples/mobile/android/app/build/outputs/apk/debug/app-debug.apk. The repository helper `examples/mobile/build.sh android` also packages this example in the configured Android build environment; its build step expects ANDROID_NDK_HOME and RUSTC.

To run the accessibility, touch, scroll, IME, rotation, background/resume, and relaunch acceptance flow on an x86_64 emulator, first build the test-only IME fixture:

```sh
cd examples/mobile/android
./gradlew --no-daemon \
  -Pandroid.aapt2FromMavenOverride="$ANDROID_SDK_ROOT/build-tools/36.0.0/aapt2" \
  -p acceptance-ime assembleDebug
cd ../../..
python3 scripts/android_acceptance.py \
  examples/mobile/android/app/build/outputs/apk/debug/app-debug.apk \
  --ime-apk examples/mobile/android/acceptance-ime/app/build/outputs/apk/debug/app-debug.apk
```

The runner defaults to emulator-5554 and checks the emulator ABI and minimum API. It temporarily changes the default IME, accessibility service, and rotation settings, then restores their previous values. Use a disposable emulator if you cannot allow those settings to be changed during the test.

The Java InputConnection proxy keeps an immutable text/selection snapshot for synchronous IME queries. It queues edits for the GPUI owner thread rather than calling into GPUI while the IME holds framework locks. Native UTF-16 selection and composition ranges are converted at the text-input boundary. On API 30 and later the host receives typed keyboard insets; on API 26–29 it estimates the keyboard region from the visible display frame.

## iOS prerequisites and build

Build on macOS with Xcode and its command-line tools selected. The checked-in script uses Rust 1.95.0 by default and targets iOS 15 or newer. Install its Rust targets with:

```sh
rustup target add --toolchain 1.95.0 aarch64-apple-ios aarch64-apple-ios-sim
```

Set `RUST_TOOLCHAIN` if you use another installed toolchain; install both targets for that toolchain.

Build an arm64 simulator app bundle:

```sh
IOS_PACKAGE_DIR="$PWD/target/ios-packages" \
  ./examples/mobile/ios/build-rust.sh Debug iphonesimulator
```

Build an arm64 device-target app bundle:

```sh
IOS_PACKAGE_DIR="$PWD/target/ios-packages" \
  ./examples/mobile/ios/build-rust.sh Release iphoneos
```

The simulator bundle is ad-hoc signed and needs no developer account. The device-target bundle is unsigned; installing it requires a separately configured local signing setup. The build script does not change Xcode signing accounts or keychain state.

Run the app-level XCUITest against a booted iPhone simulator:

```sh
IOS_SIMULATOR_UDID="SIMULATOR_UUID" \
  ./examples/mobile/ios/run-app-acceptance.sh
```

Enable Chinese (Simplified) Pinyin in the simulator keyboard settings before the IME composition test. The suite records an xcresult bundle, build log, and screenshots under `target/ios-app-acceptance`. The separate native `text_input` Cargo test checks the UIKit text-input protocol; it is not a substitute for running the app-level suite.

## Insets, text input, and lifecycle

Read system safe area and keyboard geometry from [`Window::insets()`](crate::Window::insets). They are separate edges; [`WindowInsets::effective()`](crate::WindowInsets::effective) gives the larger edge on each side and is useful for content padding:

```rust
use gpui::{Pixels, Window, px};

fn bottom_content_padding(window: &Window) -> Pixels {
    window.insets().effective().bottom + px(12.)
}
```

The `ime` edge represents the keyboard area. Use it when the UI needs to report or animate keyboard-specific geometry; use `effective()` when content must avoid whichever system region is larger. Values are in GPUI Pixels, so do not multiply by Android display density again.

On Android, the host must forward surface creation/destruction, Activity resume/pause, touch, keys, and InputConnection events through one supported entry path. The host-driven API documents the ordering requirements in `gpui_mobile::android::host`. The `surface_destroyed` callback waits up to two seconds for the render thread to release the surface. If it times out, it logs an error and returns, so a stuck render thread is not guaranteed to have released the surface before the framework continues teardown. On iOS, UIKit owns the window and scene lifecycle; the backend converts UIKit touch, keyboard-frame, and text-input events into GPUI events and updates.

See [Accept text input](crate::_documentation::guides::text_input), [Manage focus](crate::_documentation::guides::focus), [Make your app accessible](crate::_documentation::guides::accessibility), and [Platform capabilities](crate::_documentation::platforms) for application-level behavior. A package build or emulator test does not establish physical-device GPU support, VoiceOver spoken focus, or support for every host lifecycle.
