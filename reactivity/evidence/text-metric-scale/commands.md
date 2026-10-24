All Cargo commands source /tmp/gpui-native-env.sh then /tmp/gpui-nightly-env.sh, use jobs2 and the released /tmp/gpui-text-blocks-sol-target. Shipping source remains7c9fc3cf775544d4082fe7c6ce3e0bb8a3a0a407.

The exact all-feature command (initial failure preserved, one successful retry):
```sh
export GPUI_SPIRV_VAL=/nix/store/z5hs3p3inrq3w8cv71jycz7l4y3ny5xk-spirv-tools-1.4.363.0/bin/spirv-val
cargo test -p gpui_canvas -p gpui_gpu --release --locked --manifest-path reactivity/Cargo.toml --all-features --lib --tests --no-run --message-format=json
```

Matched default controls and candidate:
```sh
cargo test -p gpui_canvas --release --locked --manifest-path reactivity/Cargo.toml --test text_run_probe --test text_metric_scale_probe --no-run --message-format=json
cargo test -p gpui_gpu --release --locked --manifest-path reactivity/Cargo.toml --features vulkan-tests --test render --no-run --message-format=json
```

Artifact paths/hashes are recorded in matched-artifacts.json and allfeature-artifacts.json. Frozen binaries execute with --test-threads=1 --nocapture. allfeature-gate/command.json records the exact guarded invocation; allfeature-matrix.py, run-frozen-gate.py and extract-assembly.py preserve the orchestration used. Negative reciprocal tests were compiled directly by the same rustc -O --test and actually executed; the patch and failure log are preserved.
