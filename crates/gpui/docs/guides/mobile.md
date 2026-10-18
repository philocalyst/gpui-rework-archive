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

The APK is written to `examples/mobile/android/app/build/outputs/apk/debug/app-debug.apk`. On Linux, the repository packaging entrypoint is `examples/mobile/android/build.sh`; it builds and strips the native libraries, preserves unstripped libraries and debug symbols, and assembles the APK. It requires `ANDROID_NDK_HOME`, `RUSTC`, and the Android SDK environment described above. Set `GPUI_BUILD_RUNNER` only when the build must run through a configured external runner.

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

The runner defaults to emulator-5554 and checks the emulator ABI and minimum API. It temporarily changes the default IME, accessibility service, and rotation settings, then restores their previous values where the OS exposes them; an unset preference may be normalized to its default. Use a disposable emulator if you cannot allow those settings to be changed during the test.

The Java InputConnection proxy keeps an immutable text/selection snapshot for synchronous IME queries. It queues edits for the GPUI owner thread rather than calling into GPUI while the IME holds framework locks. Native UTF-16 selection and composition ranges are converted at the text-input boundary. On API 30 and later the host receives typed keyboard insets through the platform inset-animation path. On API 26–29 the host uses `SOFT_INPUT_ADJUST_PAN` and a legacy visible-display-frame observer. It measures the visible frame relative to the window’s screen origin so pan displacement is not counted as keyboard occlusion, publishes keyboard occlusion separately from stable safe-area insets, and clears stale geometry on an explicit hidden-IME notification.

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

`GpuiPlatformView.ViewFactory.create` and its `dispose` callback run on Android's UI thread. Rust requests view creation synchronously with a bounded wait; factory work must stay short and must not wait on the GPUI thread. The sample `GpuiInputActivity` does not bind the optional platform-view bridge. A custom Activity host that uses this bridge must call `GpuiPlatformView.bindActivity(this)` on the UI thread after `super.onCreate(...)`, then call `GpuiPlatformView.unbindActivity(this)` on the UI thread before `super.onDestroy()`. Unbinding clears the overlay and invalidates pending creations so bridge-owned views do not retain a destroyed Activity. Unknown or unregistered view types fail creation rather than producing placeholder video, camera, or map content.

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
IOS_ACCEPTANCE_CONFIGURATION=Release \
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

### Android

The current acceptance APK is bound to source checkpoint
`9043c8f31d039dcfabf71456b45a18c30b398977` (tree
`69b31c92dee9101e9d38608077150ecb172c2949`). Product APK SHA-256:
`5e07577d3b25422a5b4fe0f6f4d5b6ce2475dbed0112c5cb80a95449a52dc961`.
AndroidTest APK SHA-256:
`55eba964d66d78195bbe8662e19e57393f9b5df29b15f4d9c28050a39745f75e`.
The test-only IME APK SHA-256 is
`0c00c866ccd4decc77da75a7d055beb156c2b06bf0a7bcbc1ac845746b56595b`.
The Java host source SHA-256 is
`4851a3e7dc3e50d0c624cffb9ef276cd65db46478047e887edddf534ec8dc07e`.
All packaged native libraries match the previously validated a7 product
libraries byte-for-byte; this APK did not rebuild Rust, WGSL, or Cargo inputs.
The runner SHA-256 is
`c9a4e1e8d55cb778899d4a7183ba689b3b4cac45091749465fb6fae0a81f584e`.

| Emulator API | Strict acceptance | Native lifecycle instrumentation |
| --- | --- | --- |
| 26 | Pass | Pass |
| 29 | Pass | Pass |
| 34 | Pass | Pass |
| 36 | Pass | Pass |

API 26, 29, and 34 strict runs passed on x86_64 emulators, including IME
composition and UTF-16 editing, explicit hide and keyboard Back, rotation,
background/resume, Activity font-scale recreation, touch/scroll, fresh launch,
and crash/ANR scanning. API 36 also passed. These are emulator results,
not physical-device Android validation. Per-API logs, APK hashes, and static
verification are preserved under
`evidence/android-final-9043c8f/`; the exact emulator configurations and
runner invocations are recorded there. API 26 and 29 install commands reported success but no pulled APK hashes were saved; API 34 and 36 pulled app, test, and helper APK hashes match the recorded artifacts. The first API 34 stale-signer attempt is excluded; the passing run followed uninstall and reinstall.

The final device attempt to execute the native test ELF exited 127 because
the pushed executable was not found, so no native assertion pass is claimed.
The earlier 134/134 native test result is historical and separate.

The runner regression suite passed 28/28. Runner source SHA-256:
`c9a4e1e8d55cb778899d4a7183ba689b3b4cac45091749465fb6fae0a81f584e`; test
source SHA-256:
`e98a0ab722ba67a0c6fcb0d8fac505e4586f1e584f8dae46b414455b8dfdad49`. Log:
`evidence/android-final-6e6db89/font-scale-runner-tests-v7.log`, SHA-256
`2c8f548e102b52f58d24f18c8a190514bb377fc9bf4dd2ee70c0f3aea5080548`.

To run the acceptance flow against a built app and test-only IME on a connected
emulator, use the repository runner from the checkout root:

```sh
python3 scripts/android_acceptance.py \
  examples/mobile/android/app/build/outputs/apk/debug/app-debug.apk \
  --ime-apk examples/mobile/android/acceptance-ime/app/build/outputs/apk/debug/app-debug.apk \
  --serial emulator-5554 \
  --artifacts target/android-acceptance
```

The test APK and helper IME are separate from the product APK. The runner
temporarily changes the default IME, accessibility service, rotation, and
font-scale settings, then restores their previous values where the OS exposes them; an unset preference may be normalized to its default. Use a disposable
emulator if you cannot allow those settings to be changed during the test.

### iOS

The iOS app-level acceptance suite passed 7/7 unflagged Release XCUITests on
source checkpoint `a7e52d69e33f01ef5f1e7bfa37a950f5c774297f`. The unsigned
arm64 device package build passed, but it was not installed or run on a physical
device. The evidence mirror is
`evidence/ios-validation/final-a7e52d69e33f01ef5f1e7bfa37a950f5c774297f/`,
bundle SHA-256
`581550e4fc44408bf92a2741cf5a83fb6649298b714cc2df90363500a52a5051`. The
implementation requires iOS 15 or newer.

The suite uses real UIKit keyboard input and text interaction: Pinyin candidate
composition, emoji entry, word selection by double-tap and replacement using a
native keyboard key, and caret hit testing with text padding, horizontal scroll,
and UTF-16 offsets. It also checks keyboard insets in portrait/landscape,
rotation, background/resume, and fresh relaunch. The runner defaults to the
tested Release configuration; set
`IOS_ACCEPTANCE_CONFIGURATION` to select another Xcode configuration. Run it on
macOS with a booted simulator and Chinese (Simplified) Pinyin enabled:

```sh
IOS_ACCEPTANCE_CONFIGURATION=Release \
IOS_SIMULATOR_UDID="SIMULATOR_UUID" \
  ./examples/mobile/ios/run-app-acceptance.sh
```

These results describe the recorded simulator/emulator setups. They do not
claim physical-device GPU support, VoiceOver spoken focus, multi-window iOS
scene support, or universal IME behavior across untested keyboards and OS
versions.
