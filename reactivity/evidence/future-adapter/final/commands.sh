set -e
source /tmp/gpui-native-env.sh
export CARGO_TARGET_DIR=/root/gpui-future-target CARGO_BUILD_JOBS=2
cargo clippy --offline --locked -p gpui -p gpui_reactivity_core -p gpui_gpu -p gpui_canvas --features gpui/desktop,gpui/x11,gpui/wayland,gpui_canvas/parallel,gpui_gpu/vulkan-tests,cephal/verify-cache --all-targets -- -D warnings > /tmp/future-final-strict.log 2>&1
cargo test --offline --locked -p gpui --no-default-features --lib reader:: -- --nocapture --test-threads=1 > /tmp/future-final-headless-ledger.log 2>&1
cargo test --offline --locked -p gpui --no-default-features --test question_input_cost --test questions --no-run --message-format=json > /tmp/future-final-candidate-ordinary.jsonl 2> /tmp/future-final-candidate-ordinary-build.log
DISPLAY=:113 cargo test --offline --locked -p gpui --features desktop,x11,wayland,gpui_canvas/parallel,cephal/verify-cache --lib native_future_cancellation_and_result_wake_without_unrelated_input -- --ignored --nocapture --test-threads=1 > /tmp/future-final-native.log 2>&1
cargo test --offline --locked -p gpui_reactivity_ownership_lab --features loom --test question_mailbox > /tmp/future-final-loom.log 2>&1
RUSTC_BOOTSTRAP=1 cargo check --offline --locked -p gpui --features desktop,gpui_canvas/parallel --all-targets --target aarch64-apple-darwin -Zbuild-std=std,panic_abort > /tmp/future-final-apple.log 2>&1
RUSTC_BOOTSTRAP=1 cargo check --offline --locked -p gpui --features desktop,gpui_canvas/parallel --all-targets --target x86_64-pc-windows-msvc -Zbuild-std=std,panic_abort > /tmp/future-final-msvc.log 2>&1
export CARGO_TARGET_DIR=/root/gpui-future-release-target
cargo test --offline --locked --manifest-path /root/gpui-future-control-baseline/reactivity/Cargo.toml -p gpui --no-default-features --release --test question_input_cost --no-run --message-format=json > /tmp/future-release-baseline.jsonl 2> /tmp/future-release-baseline-build.log
/nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3 evidence/future-adapter/capture-artifact.py /tmp/future-release-baseline.jsonl /tmp/future-control-baseline /root/gpui-future-control-baseline
cargo test --offline --locked --manifest-path /root/gpui-future-sol/reactivity/Cargo.toml -p gpui --no-default-features --release --test question_input_cost --no-run --message-format=json > /tmp/future-release-candidate.jsonl 2> /tmp/future-release-candidate-build.log
/nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3 evidence/future-adapter/capture-artifact.py /tmp/future-release-candidate.jsonl /tmp/future-control-candidate /root/gpui-future-sol
