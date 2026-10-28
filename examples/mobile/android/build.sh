#!/usr/bin/env bash
# Builds the Android example's native library for arm64-v8a and x86_64, then a debug APK.
set -euo pipefail
cd "$(dirname "$0")"
: "${ANDROID_NDK_HOME:?set ANDROID_NDK_HOME to an Android NDK}"

cargo ndk -t arm64-v8a -t x86_64 -P 26 -o app/src/main/jniLibs \
    build -p gpui-ce-mobile-example --lib --release
./gradlew assembleDebug
