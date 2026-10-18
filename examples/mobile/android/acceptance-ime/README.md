# Android acceptance IME

This module is a test-only companion APK. It is not a dependency of the mobile example and must not be packaged into the product APK. It supplies a deterministic `InputMethodService` and `AccessibilityService` for emulator acceptance runs:

- `AcceptanceImeService` sends actual `setComposingText`, `commitText`, `setSelection`, and `deleteSurroundingText` calls to the focused editor.
- `AcceptanceAccessibilityService` sends Android `ACTION_SET_TEXT` and UTF-16 `ACTION_SET_SELECTION` actions to the node identified by content description `Editor` or view id `acceptance.editor`.
- `ImeCommandReceiver` accepts explicit test commands only within the companion package. The Python runner verifies each command result and resulting accessible value.

Build it with the pinned Android Gradle wrapper and SDK 36 toolchain from the Android example directory:

```sh
cd examples/mobile/android
bash ./gradlew --no-daemon \
  -Pandroid.aapt2FromMavenOverride="$ANDROID_SDK_ROOT/build-tools/36.0.0/aapt2" \
  -p acceptance-ime assembleDebug
```

Then build the product example, boot an x86_64 emulator with API 34 or newer, and run:

```sh
scripts/android_acceptance.py \
  path/to/gpui-ce-mobile-example.apk \
  --ime-apk examples/mobile/android/acceptance-ime/app/build/outputs/apk/debug/app-debug.apk
```

The runner defaults to package `dev.gpui.mobile.example`, component `dev.gpui.mobile.GpuiInputActivity`, and emulator `emulator-5554`. It restores the device's prior default IME, accessibility-service list, accessibility-enabled flag, and rotation settings when the test completes.

## Recorded runtime matrix

The latest strict acceptance matrix is recorded in
`final-sync/evidence/android/refresh-resume-11a71ad/final-matrix-report.md`.
It passed on API 26, 29, 34, and 36 x86_64 emulators, including the native-view
instrumentation probe. Product app SHA-256:
`1ecf3f5915150372edf7e93d0745f1590216029dacf2ff4f4d38c066b17e2f25`;
AndroidTest APK:
`50e3f8ad6922ce2b4a4a5a476e2cc1d1df0999ffe2c3a6206c199e073b823854`;
acceptance IME APK:
`4cbb883f81995f3ddf62179a20dfed567851039fbfa8c9d23f9d1673c0874df7`.
The runner was `scripts/android_acceptance.py` SHA-256
`286e1f01f436d030ceed89dc336897da4147e666a1b22524ac5608cba42f1a92`.
The app was built from source checkpoint `11a71ada` plus the approved Android
`window.rs` overlay (SHA-256
`52cadb2058ff787d3cd0e2c8645fe8f2471089c9f548a33853e29f90d2097886`); that
exact source state is committed as
`58748acf200778474ae334a670b43b592172de0b`. API 36's successful configuration
resolved to ANGLE/SwiftShader GLES with
`-gpu swangle -feature -Vulkan -accel on`. Its failed Lavapipe run is retained
as a separate configuration diagnostic; do not combine it with the passing
swangle receipt.

The runner command from the repository root is:

```sh
python3 scripts/android_acceptance.py \
  path/to/gpui-ce-mobile-example.apk \
  --ime-apk examples/mobile/android/acceptance-ime/app/build/outputs/apk/debug/app-debug.apk \
  --serial emulator-5554 \
  --artifacts target/android-acceptance
```

These are emulator results, not physical-device certification. A fresh run
must retain the APK hashes, exact runner/source inputs, API level, resolved
graphics backend, and per-stage output directory.
