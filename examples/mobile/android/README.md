# Android example

The Android example is a NativeActivity backed by the shared mobile example. Its package is `dev.gpui.mobile.example`, it supports API 26 and newer, and the packaging build includes arm64-v8a and x86_64. The current NDK strip-tool path targets Linux x86_64; the documented packaging flow is for Linux/NixOS.

## Requirements

Use Java 17, Android SDK platform and Build Tools 36, NDK 29.0.14206865, the Android Rust standard libraries for both ABIs, and `cargo-ndk`. The build script requires `ANDROID_NDK_HOME`, `ANDROID_SDK_ROOT`, and `RUSTC` from that environment. The Gradle wrapper pins Gradle 9.4.1 and the project pins AGP 9.1.0.

## Build app, instrumentation, and test IME

Enter the Nix/toolchain shell from the repository root. Export one shared Android user home and Gradle user home inside that shell before running any of the three builds. This prevents the shell or helper project working directory from selecting a different debug signing key.

```sh
cd /path/to/gpui-ce
nix develop /path/to/android-toolchain --command bash -c '
  set -euo pipefail
  export ANDROID_USER_HOME="$PWD/.android"
  export GRADLE_USER_HOME="$PWD/.gradle-android"
  # Set this only in environments that require the shared compile-lock wrapper.
  # export GPUI_BUILD_RUNNER=/absolute/path/to/env/dev

  bash examples/mobile/android/build.sh

  cd examples/mobile/android
  if [ -n "${GPUI_BUILD_RUNNER:-}" ]; then
    "$GPUI_BUILD_RUNNER" env -u LD_LIBRARY_PATH bash ./gradlew --no-daemon -Pandroid.aapt2FromMavenOverride="$ANDROID_SDK_ROOT/build-tools/36.0.0/aapt2" assembleDebug assembleDebugAndroidTest
  else
    env -u LD_LIBRARY_PATH bash ./gradlew --no-daemon -Pandroid.aapt2FromMavenOverride="$ANDROID_SDK_ROOT/build-tools/36.0.0/aapt2" assembleDebug assembleDebugAndroidTest
  fi

  cd acceptance-ime
  if [ -n "${GPUI_BUILD_RUNNER:-}" ]; then
    "$GPUI_BUILD_RUNNER" env -u LD_LIBRARY_PATH bash ../gradlew --no-daemon -Pandroid.aapt2FromMavenOverride="$ANDROID_SDK_ROOT/build-tools/36.0.0/aapt2" assembleDebug
  else
    env -u LD_LIBRARY_PATH bash ../gradlew --no-daemon -Pandroid.aapt2FromMavenOverride="$ANDROID_SDK_ROOT/build-tools/36.0.0/aapt2" assembleDebug
  fi
'
```

`GPUI_BUILD_RUNNER` is optional and must be an absolute executable path when set. The main build script routes only its Cargo and Gradle commands through that helper; without it, commands run directly. Enter `nix develop` outside the compile-lock wrapper. Do not wrap the entire Nix invocation with the helper.

The main build script defaults `ANDROID_USER_HOME` and `GRADLE_USER_HOME` to the repository-root `.android/` and `.gradle-android/`. Explicit nonempty values are preserved. For repeatable signing, export both homes to the same repository-root paths before all app, instrumentation, and helper builds.

If either home changes, run `clean` in both Gradle projects before rebuilding app, instrumentation, and helper APKs under the new shared homes. Verify all three signing-certificate SHA-256 values match before installing/running instrumentation or acceptance. Keep the existing `.android/debug.keystore` if an installed app must remain upgrade-compatible.

## NativeActivity session and input lifetime

Use `run_native_activity(app, launch)` for the standard NativeActivity entry. For a custom entry, migrate from the old `init_platform(&app) -> &'static Arc<AndroidPlatform>` result: it now returns `Result<NativeSessionGuard, String>`. Handle initialization failure, retain the guard on the Android owner thread for the entire GPUI application run, and get an owned platform with `guard.platform() -> Option<Arc<AndroidPlatform>>`. For example:

```rust
use android_activity::AndroidApp;
use gpui_mobile::android::jni;

fn run_custom(app: AndroidApp, launch: impl FnOnce(&mut gpui::App) + 'static) -> Result<(), String> {
    let session = jni::init_platform(&app)?;
    let platform = session
        .platform()
        .ok_or_else(|| "NativeActivity platform is unavailable".to_owned())?;
    gpui::Application::with_platform(platform.into_rc()).run(launch);
    // Keep session in scope until Application::run returns on this thread.
    Ok(())
}
```

The guard is intentionally neither `Send` nor `Sync`; dropping it retires the Activity runtime. NativeActivity and host-driven Android startup are mutually exclusive while either runtime is active.

Each Activity creation owns a fresh session generation. On configuration relaunch, the old native loop retires its windows and callbacks while the GPUI application is still alive; the session guard's later cleanup is an idempotent fallback. JNI callbacks and frame wakes from a retired session fail closed instead of targeting its replacement. Closing a native window is terminal for that handle: an escaped `Arc<AndroidWindow>` cannot reopen the surface or register new callbacks, and its renderer/GPU resources are released on the owning thread. Surface loss through `term_window` is different; the same live window may initialize again when Android supplies a new surface.

The scoped JNI helper now has the signature `activity<'local>(&mut jni::Env<'local>) -> Result<JObject<'local>, String>`; it needs a mutable environment to create a local reference protected by the live session. `platform() -> Option<Arc<AndroidPlatform>>` now returns an owned Arc rather than the old static reference. `android_app() -> Option<AndroidApp>` keeps its cloned-handle signature and is available only for the active NativeActivity session. Deprecated `activity_as_ptr()` is host-only and returns a host Activity pointer; NativeActivity integrations should use the scoped helper. The public five-argument `AndroidWindow::new` constructor remains available. In NativeActivity mode it captures the active session, validates that the supplied native window belongs to it, and uses that session's dispatcher; host mode continues to use the caller-provided dispatcher. Prefer platform-managed window creation for normal applications.

The public `on_key_event` callback retains its legacy behavior. Native input-queue Back is delivered synchronously on the owner thread so a GPUI Escape handler can consume it; if it propagates, Android receives the unhandled Back and may finish the Activity. Ordinary keys remain on the existing queued path. On API 33 and newer, the Java `OnBackInvokedCallback` handles system Back and IME dismissal before Activity finish; it does not route through the GPUI Escape callback.
