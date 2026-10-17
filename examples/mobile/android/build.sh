#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -- "$script_dir/../../.." && pwd)"
cd "$repo_root"
: "${ANDROID_NDK_HOME:?Enter tooling/android Nix shell first}"
: "${RUSTC:?Enter tooling/android Nix shell first}"
export CARGO_TARGET_DIR="${CARGO_TARGET_DIR:-$(cd "$repo_root/.." && pwd)/target}"
"/home/miles/reactivity-port/env/dev" cargo ndk -t arm64-v8a -t x86_64 -P 26 -o "$script_dir/app/src/main/jniLibs" build -p gpui-ce-mobile-example --lib --release

# AGP Maven strip tools are not runnable on the Nix host. Use the pinned NDK
# strip tool on staged jniLibs copies, keeping full originals and separate
# debug-symbol sidecars in evidence for native crash diagnosis.
llvm_bin="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin"
llvm_strip="$llvm_bin/llvm-strip"
llvm_objcopy="$llvm_bin/llvm-objcopy"
llvm_readelf="$llvm_bin/llvm-readelf"
unstripped_dir="${ANDROID_UNSTRIPPED_DIR:-$(cd "$repo_root/.." && pwd)/evidence/android/unstripped/$(date -u +%Y%m%dT%H%M%SZ)}"
mkdir -p "$unstripped_dir"
for abi in arm64-v8a x86_64; do
    abi_dir="$script_dir/app/src/main/jniLibs/$abi"
    mkdir -p "$unstripped_dir/$abi"
    for library in libgpui_mobile.so libgpui_ce_mobile_example.so; do
        source="$abi_dir/$library"
        cp -- "$source" "$unstripped_dir/$abi/$library"
        "$llvm_objcopy" --only-keep-debug "$source" "$unstripped_dir/$abi/$library.debug"
        "$llvm_strip" --strip-unneeded "$source"
        "$llvm_objcopy" --add-gnu-debuglink="$unstripped_dir/$abi/$library.debug" "$source"
    done
done
if ! "$llvm_readelf" --dyn-syms "$script_dir/app/src/main/jniLibs/arm64-v8a/libgpui_ce_mobile_example.so" | grep -q ANativeActivity_onCreate; then
    echo "stripped NativeActivity library lost ANativeActivity_onCreate" >&2
    exit 1
fi
(cd "$unstripped_dir" && sha256sum arm64-v8a/* x86_64/* > SHA256SUMS)
echo "Unstripped Android libraries and symbols preserved at $unstripped_dir"
cd "$script_dir"
/home/miles/reactivity-port/env/dev env -u LD_LIBRARY_PATH bash ./gradlew --no-daemon -Pandroid.aapt2FromMavenOverride="$ANDROID_SDK_ROOT/build-tools/36.0.0/aapt2" assembleDebug
