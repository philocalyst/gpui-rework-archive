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
