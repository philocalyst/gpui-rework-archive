set -euo pipefail
source /tmp/gpui-native-env.sh
source /tmp/gpui-nightly-env.sh
export CARGO_TARGET_DIR=/tmp/gpui-text-composition-sol-target
export CARGO_BUILD_JOBS=2
export GPUI_SPIRV_VAL=/nix/store/z5hs3p3inrq3w8cv71jycz7l4y3ny5xk-spirv-tools-1.4.363.0/bin/spirv-val
export XDG_RUNTIME_DIR=/tmp/gpui-text-composition-sol-runtime
py=/nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3
pin=4c9f4a2b514f784319c0239812eb444c2081b3c2
base=("$py" /tmp/gpui-run-frozen-gate-root.py --source /tmp/gpui-text-composition-sol --pin "$pin" --timeout 3600 --scope .cargo --scope clippy.toml --scope Cargo.toml --scope Cargo.lock --scope rust-toolchain.toml --scope reactivity/Cargo.toml --scope reactivity/Cargo.lock --scope reactivity/rust-toolchain.toml --scope reactivity/crates --scope reactivity/vendor)
features=gpui/x11,gpui_canvas/parallel,gpui_gpu/vulkan-tests,gpui_gpu/offline-shader
"${base[@]}" --out /tmp/gpui-text-composition-sol-focused-build -- cargo test --manifest-path reactivity/Cargo.toml -p gpui_canvas --all-features --test text_composition --no-run --message-format=json
"${base[@]}" --out /tmp/gpui-text-composition-sol-focused-execute-guard -- "$py" /tmp/gpui-text-composition-run-artifacts.py --build /tmp/gpui-text-composition-sol-focused-build --out /tmp/gpui-text-composition-sol-focused-artifacts --per-binary-seconds 300
"${base[@]}" --out /tmp/gpui-text-composition-sol-final-strict-v2 -- cargo clippy --manifest-path reactivity/Cargo.toml -p gpui_canvas -p gpui_gpu -p gpui --all-targets --features "$features" -- -D warnings
"${base[@]}" --out /tmp/gpui-text-composition-sol-final-docs -- cargo test --manifest-path reactivity/Cargo.toml -p gpui_canvas -p gpui_gpu -p gpui --doc --features "$features"
"${base[@]}" --out /tmp/gpui-text-composition-sol-final-scalar -- cargo test --manifest-path reactivity/Cargo.toml -p gpui_canvas --no-default-features --lib --test clipping --test gradients --test text_composition
