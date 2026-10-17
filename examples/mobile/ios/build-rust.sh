#!/usr/bin/env bash
set -euo pipefail

ios_dir="$(cd "$(dirname "$0")" && pwd)"
repo_root="$(cd "$ios_dir/../../.." && pwd)"
manifest="$repo_root/examples/mobile/Cargo.toml"
configuration="${1:-Debug}"
platform="${2:-iphonesimulator}"
toolchain="${RUST_TOOLCHAIN:-1.95.0}"
python_bin="${PYTHON_BIN:-/usr/bin/python3}"
package_root="${IOS_PACKAGE_DIR:-$repo_root/target/ios-packages}"

case "$platform" in
  iphonesimulator)
    rust_target="aarch64-apple-ios-sim"
    sign_simulator=1
    ;;
  iphoneos)
    rust_target="aarch64-apple-ios"
    sign_simulator=0
    ;;
  *)
    echo "Unsupported platform '$platform'; expected iphonesimulator or iphoneos." >&2
    exit 2
    ;;
esac

if ! rustup target list --installed --toolchain "$toolchain" | grep -Fxq "$rust_target"; then
  echo "Rust target '$rust_target' is not installed for toolchain '$toolchain'." >&2
  echo "Install it with: rustup target add --toolchain $toolchain $rust_target" >&2
  exit 1
fi

profile=debug
cargo_args=()
if [[ "$configuration" == "Release" ]]; then
  profile=release
  cargo_args+=(--release)
elif [[ "$configuration" != "Debug" ]]; then
  echo "Unsupported configuration '$configuration'; expected Debug or Release." >&2
  exit 2
fi

mkdir -p "$package_root"
build_log="$(mktemp "$package_root/cargo-$rust_target-$profile.XXXXXX.log")"
echo "Building canonical GPUI iOS example for $rust_target ($configuration, Rust $toolchain)"
if ! IPHONEOS_DEPLOYMENT_TARGET=15.0 cargo +"$toolchain" build \
  --locked \
  --manifest-path "$manifest" \
  --package gpui-ce-mobile-example \
  --bin gpui-ce-mobile-example-ios \
  --target "$rust_target" \
  --message-format=json-render-diagnostics \
  "${cargo_args[@]}" 2>&1 | tee "$build_log"; then
  echo "Cargo build failed; full output is in $build_log" >&2
  exit 1
fi

if [[ ! -x "$python_bin" ]]; then
  echo "Python executable not found: $python_bin (set PYTHON_BIN to a CPython executable)." >&2
  exit 1
fi
if ! "$python_bin" -c 'import platform, sys; sys.exit(0 if platform.python_implementation() == "CPython" else 1)'; then
  echo "Python executable is not CPython: $python_bin (set PYTHON_BIN to a CPython executable)." >&2
  exit 1
fi

executable="$("$python_bin" - "$build_log" <<'PY'
import json
import sys

name = "gpui-ce-mobile-example-ios"
executables = []
with open(sys.argv[1], encoding="utf-8") as output:
    for line in output:
        try:
            event = json.loads(line)
        except json.JSONDecodeError:
            continue
        target = event.get("target", {})
        if (
            event.get("reason") == "compiler-artifact"
            and target.get("name") == name
            and "bin" in target.get("kind", [])
            and event.get("executable")
        ):
            executables.append(event["executable"])
if len(executables) != 1:
    sys.exit(f"Expected one {name} executable in Cargo output, found {len(executables)}")
print(executables[0])
PY
)"
app_dir="$package_root/$rust_target/$profile/GpuiMobile.app"
mkdir -p "$app_dir"
cp "$executable" "$app_dir/gpui-ce-mobile-example-ios"
cp "$ios_dir/Info.plist" "$app_dir/Info.plist"

if [[ "$sign_simulator" == 1 ]]; then
  # Simulator ad-hoc signing uses no team, account, certificate, or keychain.
  codesign --force --sign - --timestamp=none "$app_dir"
fi

echo "Packaged iOS app: $app_dir"
echo "Cargo log: $build_log"
if [[ "$sign_simulator" == 0 ]]; then
  echo "Device output is unsigned; installation requires a separately authorized signing setup."
fi
