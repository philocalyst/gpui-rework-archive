set -euo pipefail
source /tmp/gpui-native-env.sh
source /tmp/gpui-nightly-env.sh
export CARGO_TARGET_DIR=/tmp/gpui-hummingbird-compose-root-target
export CARGO_BUILD_JOBS=2
export GPUI_SPIRV_VAL=/nix/store/z5hs3p3inrq3w8cv71jycz7l4y3ny5xk-spirv-tools-1.4.363.0/bin/spirv-val
export XDG_RUNTIME_DIR=/tmp/gpui-clips-gradient-root-runtime
mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR"
read -r pin < <(git -c safe.directory=/tmp/gpui-clips-gradient-root -C /tmp/gpui-clips-gradient-root rev-parse HEAD)
py=/nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3
base=("$py" /tmp/gpui-run-frozen-gate-root.py --source /tmp/gpui-clips-gradient-root --pin "$pin" --timeout 2400 --scope .cargo --scope clippy.toml --scope reactivity/Cargo.toml --scope reactivity/Cargo.lock --scope reactivity/rust-toolchain.toml --scope reactivity/crates --scope reactivity/vendor)
"${base[@]}" --out /tmp/gpui-clips-gradient-root-final-build -- cargo test --manifest-path reactivity/Cargo.toml -p gpui_canvas -p gpui_gpu -p gpui --lib --tests --features gpui/x11,gpui_gpu/vulkan-tests,gpui_gpu/offline-shader --no-run --message-format=json
"${base[@]}" --out /tmp/gpui-clips-gradient-root-final-execute-guard -- "$py" /tmp/gpui-run-cargo-test-artifacts-root.py --build /tmp/gpui-clips-gradient-root-final-build --out /tmp/gpui-clips-gradient-root-final-artifacts --per-binary-seconds 300
"${base[@]}" --out /tmp/gpui-clips-gradient-root-final-strict -- cargo clippy --manifest-path reactivity/Cargo.toml -p gpui_canvas -p gpui_gpu -p gpui --all-targets --features gpui/x11,gpui_gpu/vulkan-tests,gpui_gpu/offline-shader -- -D warnings
"${base[@]}" --out /tmp/gpui-clips-gradient-root-final-docs -- cargo test --manifest-path reactivity/Cargo.toml -p gpui_canvas -p gpui_gpu -p gpui --doc --features gpui/x11,gpui_gpu/offline-shader
"${base[@]}" --out /tmp/gpui-clips-gradient-root-final-scalar -- cargo test --manifest-path reactivity/Cargo.toml -p gpui_canvas --no-default-features --lib gradient
