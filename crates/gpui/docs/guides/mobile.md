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

### Embedding Android native views

The Android bridge uses hybrid composition: native Android views are positioned in an overlay above the `NativeActivity` surface. They cannot be interleaved arbitrarily with GPUI GPU content. A platform view type must be registered on both sides with the same name. Register the Rust bridge factory during Android application initialization. This target-specific example is illustrative and is not compiled as a Linux GPUI doctest:

```rust,ignore
use gpui_mobile::{
    android::platform_view::AndroidPlatformViewFactory,
    platform_view::PlatformViewRegistry,
};

PlatformViewRegistry::global().register(
    "web_view",
    Box::new(AndroidPlatformViewFactory::new("web_view")),
);
```

The Java bridge provides `container`, `webview`, and `web_view` factories. Other types, including video, camera, and map views, require an application-provided Android factory:

```java
GpuiPlatformView.registerViewFactory("video_player", (activity, params) ->
    new MyVideoView(activity, params));
```

`GpuiPlatformView.ViewFactory.create` and its `dispose` callback run on Android's UI thread. Rust requests view creation synchronously with a bounded wait; factory work must stay short and must not wait on the GPUI thread. The sample `GpuiInputActivity` binds the Activity in `onCreate` and unbinds it in `onDestroy`; a custom host must follow the same bind/unbind lifecycle so static overlay views do not retain a destroyed Activity. Unknown or unregistered view types fail creation rather than producing placeholder video, camera, or map content.

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

## Validated release configurations

The current Android acceptance matrix is bound to the product app SHA-256
`1ecf3f5915150372edf7e93d0745f1590216029dacf2ff4f4d38c066b17e2f25`, Android
source checkpoint `11a71ada`, and runner SHA-256
`286e1f01f436d030ceed89dc336897da4147e666a1b22524ac5608cba42f1a92`. The
matching AndroidTest APK is `50e3f8ad6922ce2b4a4a5a476e2cc1d1df0999ffe2c3a6206c199e073b823854`;
the test-only IME APK is
`4cbb883f81995f3ddf62179a20dfed567851039fbfa8c9d23f9d1673c0874df7`. All three
APKs have signer SHA-256
`bedc415e4a37986a64f383fe69cf0a9216934142fba5d65ba792f0a8c3b9b85a`.

| Emulator API | Strict acceptance | Native-view probe |
| --- | --- | --- |
| 26 | Pass | Pass |
| 29 | Pass | Pass |
| 34 | Pass | Pass |
| 36 | Pass | Pass |

The full run matrix and evidence paths are in
`final-sync/evidence/android/refresh-resume-11a71ad/final-matrix-report.md`.
API 36 passed with the resolved ANGLE/SwiftShader GLES mode launched as
`-gpu swangle -feature -Vulkan -accel on`; the earlier API 36 Lavapipe lane
failed its post-rotation keyboard-visibility assertion and is kept as a
separate configuration result. API 26, 29, and 34 used the recorded emulator
configurations in the same evidence directory. These are x86_64 emulator
results, not physical-device GPU results.

To run the acceptance flow against a built app and test-only IME on a connected
emulator, use the repository runner from the checkout root:

```sh
python3 scripts/android_acceptance.py \
  examples/mobile/android/app/build/outputs/apk/debug/app-debug.apk \
  --ime-apk examples/mobile/android/acceptance-ime/app/build/outputs/apk/debug/app-debug.apk \
  --serial emulator-5554 \
  --artifacts target/android-acceptance
```

The test APK and helper IME are separate from the product APK. API 36 emulator
renderer selection matters: preserve the resolved renderer from the evidence,
not only the requested `-gpu` option.

The iOS app-level acceptance suite passed 7/7 unflagged Release XCUITests on
source checkpoint `ac997d31662b8aa370acb729e64192f422b7cf77` (tree
`e1b6ef748b40c236a1cc3b728fb48e4024450647`). Its portable artifact archive SHA-256
is `6409cf9d203a7c06e803af5781c648105ba79ae1acd33510d6ac42b97a84ac74`; the
portable manifest SHA-256 is
`123ca4c8fd12da798703f924f5273d2842d821881fbd185dc75049a2b6e69244`. The app
was validated in the simulator. The arm64 device executable is unsigned and
was compile/package checked only; there is no physical-device runtime result.
The implementation requires iOS 15 or newer.

The suite uses real UIKit keyboard input and text interaction: Pinyin candidate
composition, emoji entry, word selection by double-tap and replacement using a
native keyboard key, and caret hit testing with text padding, horizontal scroll,
and UTF-16 offsets. It also checks keyboard insets in portrait/landscape,
rotation, background/resume, and fresh relaunch. Run it on macOS with a booted
simulator and Chinese (Simplified) Pinyin enabled:

```sh
IOS_SIMULATOR_UDID="SIMULATOR_UUID" \
  ./examples/mobile/ios/run-app-acceptance.sh
```

These results describe the recorded simulator/emulator setups. They do not
claim physical-device GPU support, VoiceOver spoken focus, multi-window iOS
scene support, or universal IME behavior across untested keyboards and OS
versions.
