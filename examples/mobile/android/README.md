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
