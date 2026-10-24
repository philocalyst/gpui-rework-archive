# Reproduction and provenance

All Cargo commands used `/tmp/gpui-text-blocks-sol-target`, `CARGO_BUILD_JOBS=2`, and these toolchain setup files:

```sh
source /tmp/gpui-native-env.sh
source /tmp/gpui-nightly-env.sh
```

Control source is the isolated `/tmp/gpui-text-blocks-control` worktree at `4ee08a32def2ca70371c1764a0153a57053ae0e4`; its shipping source was not modified. Identical measurement test sources were copied into its Canvas and GPU test targets. Candidate shipping source is `bbe0c2058c2b3812e0ae8e251db68c329be7734a` in `/tmp/gpui-text-blocks-sol`. Main was never edited by this work.

Build and qualification commands, run from the corresponding `reactivity` directory:

```sh
cargo test -p gpui_canvas --release --no-run --message-format=json
cargo test -p gpui_canvas --release --test text_run_probe -- --nocapture
cargo test -p gpui_gpu --release --features vulkan-tests --test render --no-run --message-format=json
cargo test -p gpui --release --test presentation --test text_geometry --test text_cache --test paint_patch --test text_selection --test text_selection_compound --test paint_slots --no-run --message-format=json
cargo test -p gpui_canvas --release --no-default-features --test text_transaction --test prepared_scene --test render --test dpi
cargo test -p gpui_canvas --release --doc
cargo clippy -p gpui_canvas -p gpui_gpu -p gpui --release --all-targets --features gpui_gpu/vulkan-tests -- -D warnings
```

Executable paths were read from Cargo's `compiler-artifact` JSON, copied into private artifact directories, hashed, and executed with `--test-threads=1 --nocapture`. Artifact manifests record exact binary hashes; frozen test logs and `result.json` record each exit. Local immutable binaries remain under `/tmp/gpui-text-blocks-{control,final,runtime,final-gpu}-artifacts`. The small `run-frozen.py` helper is archived here. Vulkan used the supplied llvmpipe loader/driver configuration from the native environment file; no remote runtime or timings were used.

The real negative controls were built and run using:

```sh
cargo test -p gpui_canvas --release --lib packed_owner_is_shared_only_when_the_scene_needs_a_retained_run -- --nocapture
cargo test -p gpui_canvas --release --test text_transaction mixed_script_paint_selection_density_transform_and_scroll_keep_canonical_output -- --nocapture
```

Each applied exactly its archived patch to the frozen candidate source, produced exit101 at its intended assertion, and was restored before positive qualification. The final16B width counterfactual applied `witness16.patch`, ran the same release `text_run_probe`, and was restored. `source-gate.json` and `final-source.json.gz` record the restored final source. Final code qualification did not depend on uncommitted source edits.

Actual shipping-source counts use Main's unmodified tool and the supplied helpers:

```sh
/nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3 /root/gpui-ce3/reactivity/tools/core_lines.py --ref 4ee08a32def2ca70371c1764a0153a57053ae0e4 --helper /tmp/gpui-inventory-sol-target/release/inventory-rust --tokei /tmp/gpui-qualified-tokei-root/bin/tokei
/nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3 /root/gpui-ce3/reactivity/tools/core_lines.py --ref bbe0c2058c2b3812e0ae8e251db68c329be7734a --helper /tmp/gpui-inventory-sol-target/release/inventory-rust --tokei /tmp/gpui-qualified-tokei-root/bin/tokei
```

`extract-assembly.py` uses the exact supplied binutils paths and demangled symbol bounds. Assembly is stored as `.txt`; JSON records function sizes and mnemonic counts. These selected functions and explicit outlined callees are not a complete application instruction-size accounting. GPU packet counters are actual renderer statistics; benchmark timestamps are diagnostic only and carry no latency conclusion.
