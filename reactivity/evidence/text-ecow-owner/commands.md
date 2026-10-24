All Cargo commands run from the isolated owner worktree, with the native and nightly environment files sourced, CARGO_BUILD_JOBS=2 and CARGO_TARGET_DIR=/tmp/gpui-text-ecow-owner-sol-target. Source pin65c1152f25ec1f139ef874ca89ccd2eb59cc45da was immutable during the final gate.

```sh
cargo test -p gpui_canvas --release --manifest-path reactivity/Cargo.toml --no-run --message-format=json
cargo test -p gpui_gpu --release --manifest-path reactivity/Cargo.toml --features vulkan-tests --test render --no-run --message-format=json
cargo test -p gpui --release --manifest-path reactivity/Cargo.toml --test presentation --test text_geometry --test text_cache --test paint_patch --test text_selection --test text_selection_compound --test paint_slots --no-run --message-format=json
cargo clippy -p gpui_canvas -p gpui_gpu -p gpui --release --manifest-path reactivity/Cargo.toml --all-targets --features gpui_gpu/vulkan-tests -- -D warnings
cargo test -p gpui_canvas --release --manifest-path reactivity/Cargo.toml --doc
```

Cargo artifact JSON identifies frozen executable paths; artifacts.json records their hashes. frozen-matrix.py executes them. native-gate/command.json records the exact final guarded invocation. run-frozen-gate.py and extract-assembly.py preserve the gate and assembly extractor used. Source-count ledgers record exact helper/Tokei/tool hashes.

The standalone producer probe uses its own pinned Cargo manifest/lock. The Miri fixture copies the shipping glyph_buffer module byte-for-byte (miri-equivalence.json) and defines only its identical constants/PackedGlyph fields around it. miri-seeds.py preserves the16 focused guarded invocations; miri-full.log is the additional full4-test strict-provenance pass. The negative control is an isolated fixture clone with only the recorded patch; shipping source stays frozen.
