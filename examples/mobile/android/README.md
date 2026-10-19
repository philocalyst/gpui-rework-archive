# Android example

A NativeActivity app that runs the view in `examples/mobile/src/lib.rs` on GPUI's Android
backend, `gpui_mobile`. It targets Android 8 (API 26) and newer, on arm64-v8a and x86_64.

## Build and run

You need Java 17, the Android SDK with platform and build tools 36, an NDK in
`ANDROID_NDK_HOME`, [`cargo-ndk`](https://github.com/bbqsrc/cargo-ndk), and the Rust targets
`aarch64-linux-android` and `x86_64-linux-android`.

```sh
examples/mobile/android/build.sh
adb install examples/mobile/android/app/build/outputs/apk/debug/app-debug.apk
```

## How the app starts

`GpuiInputActivity` loads the native library named in the manifest, and NativeActivity calls its
`android_main`. That hands the app to `run_native_activity`, which creates the platform and runs
GPUI on the Activity's thread until Android destroys the Activity:

```rust,ignore
#[unsafe(no_mangle)]
pub fn android_main(app: android_activity::AndroidApp) {
    gpui_mobile::android::jni::run_native_activity(app, |cx| {
        // Open windows here, as in any GPUI app.
    });
}
```

A configuration change that relaunches the Activity retires the old session's windows and
callbacks before the new one starts, so late callbacks from the old Activity are ignored.

## Emoji

Android 13 and newer ship an emoji font with COLRv1 color glyphs, which GPUI's rasterizer can't
draw. The app bundles Noto Color Emoji with bitmap glyphs in `app/src/main/assets/fonts` and
stores it uncompressed in the APK, so GPUI maps it in place instead of copying it at startup.
