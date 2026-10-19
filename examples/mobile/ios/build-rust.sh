#!/usr/bin/env bash
# Builds the iOS example and packages it as an app bundle.
# usage: build-rust.sh [Debug|Release] [iphonesimulator|iphoneos]
set -euo pipefail
cd "$(dirname "$0")"

case "${2:-iphonesimulator}" in
  iphonesimulator) target=aarch64-apple-ios-sim ;;
  iphoneos) target=aarch64-apple-ios ;;
  *) echo "usage: $0 [Debug|Release] [iphonesimulator|iphoneos]" >&2; exit 2 ;;
esac
profile=debug
release=""
if [[ "${1:-Debug}" == Release ]]; then
  profile=release
  release=--release
fi

IPHONEOS_DEPLOYMENT_TARGET=15.0 cargo build $release -p gpui-ce-mobile-example \
  --bin gpui-ce-mobile-example-ios --target "$target"

output="${CARGO_TARGET_DIR:-../../../target}/$target/$profile"
app="$output/GpuiMobile.app"
mkdir -p "$app"
cp "$output/gpui-ce-mobile-example-ios" Info.plist "$app/"
# The simulator runs ad-hoc signed apps. A device needs your own signing identity.
if [[ "$target" == aarch64-apple-ios-sim ]]; then
  codesign --force --sign - --timestamp=none "$app"
fi
echo "$app"
