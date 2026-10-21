# Unicode shaping evidence

These are local Linux observations, not a cross-platform performance guarantee.
The implementation and limits are described in [TEXT.md](../TEXT.md).

Baseline: commit `146cd9912d`, with the same measurement examples and native
Library presentation-marker instrumentation as the candidate. The baseline
uses one scoped Rustybuzz parser for the whole label pass, matching its runtime
integration. Neither side reparses that parser for every label. Candidate
source-file hashes are in `unicode-source.csv`; the sorted path plus NUL plus
raw file-digest aggregate is
`72e12adf473037e135e1e51958617a6b9fae7946069305cd8c78f8e8d80bacda`.
That manifest covers changed Rust, manifests, lockfile, Python and font files;
it excludes documentation and CSV output. `unicode-binaries.csv` independently
pins every final measured executable and its ELF section sizes.

The final datasets are:

- `unicode-text.csv`: 396 rows, eleven alternating fresh-process pairs for
  0/1/1000 labels in Canvas and actual recording owners. Complete CPU pixel
  bytes are compared before collecting timings. Primitive allocation counters
  report requested thread-local bytes/capacities, not RSS or allocator usable
  size. Font admission, model/output vectors and outer layout vectors outside
  the primitive phase remain excluded; owner mount and native observations
  charge their actual paths.
- `unicode-native.csv`: 66 rows, eleven alternating fresh-process pairs for
  Empty, Workbench and the 250K-item Library. `x11-minimal --cpu --startup`
  explicitly disables AT. The marker follows real native submission and exact
  presentation acknowledgement; it does not measure scanout. Resident data
  comes from `/proc` 100 ms after that marker. The historical column
  `main_to_present_us` starts at observer attachment, after model/window
  construction; `spawn_to_present_us` includes that construction.
- `unicode-carets.csv`: five observations for each of four near-32-KiB samples,
  measuring complete plain and opt-in mapped shaping. Plain runs first; warmer
  shared font/data pages can benefit the second stage. Small apparent timing
  gains are not attributed to caret construction.
- `unicode-data.csv`: exact linked payload matches against pinned ICU sources
  and font bytes, including absent payloads and match counts.

The `unicode-full-word-*` and `unicode-data-full-word.csv` files preserve the
earlier implementation, which linked unused CJK word data and duplicate
fallback font bodies. They are historical observations, not the final floor.
The final Empty PSS increment is 194 KiB, versus 12 KiB in that earlier linked
binary. Final native Empty `.rodata` grows by 2,130,600 B and `.text` by
347,872 B; file size grows by 2,666,384 B. Linked pages and shared-page
accounting prevent assigning every resident byte to a single dependency.

## Reproduction

Measured on a Ryzen 7 3700X (16 logical CPUs), Rust 1.97.1, ordinary Cargo
release profile, warm OS caches, fresh processes pinned to CPU 2. Builds and
other team captures were stopped during each capture. There is no cache
eviction or hardware GPU timestamp claim. The local toolchain was
`/nix/store/lynmg3kdpdz41r84nafwzi2n5nss50pq-rust-1.97.1-with-components-2026-07-16/bin`.
Run the following from `reactivity` in each source tree, using distinct Cargo
target directories, then copy the resulting executables into stable baseline
and candidate directories:

```sh
cargo build --release -p gpui_canvas --example text_shaping \
  --example text_interaction --example text_oracle
cargo build --release -p gpui --example unicode_text_measure
cargo build --release -p gpui --features x11-minimal \
  --example empty --example workbench --example library
python3 crates/canvas/measure-text.py \
  --baseline-canvas /tmp/gpui-unicode-baseline-target/release/examples/text_shaping \
  --candidate-canvas /tmp/gpui-text-probe-target/release/examples/text_shaping \
  --baseline-owner /tmp/gpui-unicode-baseline-target/release/examples/unicode_text_measure \
  --candidate-owner /tmp/gpui-text-probe-target/release/examples/unicode_text_measure \
  --rounds 11 --output text.csv
python3 crates/canvas/measure-text-native.py \
  --baseline /tmp/gpui-unicode-native-baseline \
  --candidate /tmp/gpui-unicode-native-candidate \
  --rounds 11 --output native.csv
```

The native capture used an isolated Xvfb display `:0`, 1280×800×24,
`-nolisten tcp -ac`, with the X11 libraries configured by the local
`/tmp/gpui-native-env.sh` environment. It used no private AT bus. The separate
functional AT proof did use a private session and accessibility bus.

The default-on upstream-compatible word feature and the rendering-only feature
were compared by complete structured output, not hashes alone:

```sh
cargo run --release -p gpui_canvas --example text_oracle > rendering.oracle
cargo run --release -p gpui_canvas --features parley/word-boundaries \
  --example text_oracle > words.oracle
cmp rendering.oracle words.oracle
```

All 1,979,265 bytes matched across 324 layouts, including glyph/source/position
bits, run and line metadata, and every byte/affinity caret result. Output SHA-256:
`9e01faee6e4863822c24352e71d94b5ed33a856e853e83c2250cf4c2449cf15f`.

## Validation record

Final local logs (temporary artifacts, not repository dependencies):

- `/tmp/gpui-unicode-canvas-final.log`: Canvas tests with parallel enabled.
- `/tmp/gpui-unicode-release-final.log`: 14 release Unicode tests.
- `/tmp/gpui-unicode-owner-final.log`: two public owner/port regressions.
- `/tmp/gpui-unicode-vulkan-final.log`: actual Vulkan mixed-script fallback,
  density and reflection conformance after feature trimming. All 19 Vulkan
  tests also passed before the subsequent word/index trim.
- `/tmp/gpui-unicode-clippy-final.log`: strict combined X11+Wayland all-target
  Clippy for the changed first-party crates.
- `/tmp/gpui-unicode-native-final.log`: actual X11 keyboard, acknowledgement
  and complete native-fetch/CPU pixel oracle.
- `/tmp/gpui-unicode-atspi-final.log`: actual AT-SPI activation, mixed-script
  SetTextContents/GetText, invocation and reactivation.
- `/tmp/gpui-parley-final-clusters.log`: pinned vendor mapper regression.

Public GPUI tests passed before the final word/index trim; the relevant public
Unicode tests, actual native/AT/Vulkan proofs and strict all-target checks were
repeated afterward. Existing cross-platform adapter coverage is separate from
these Linux Unicode proofs.

Retained output remains capped at 32768 glyphs after planner construction.
This is not a transient hostile-font heap limit: HarfRust's private per-buffer
limit can reach 8,388,608 entries at the source cap, and multiple runs can hold
expanded output before final admission. Current coverage also reparses the
primary borrowed TTF face for each label. A cached borrowed face and tighter
transient resource admission are explicit follow-ups, not claimed benefits of
this frozen implementation.
