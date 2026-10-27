# Retained GPU output experiment

**Disposition: unadopted local experiment.** Exact tested pixels and native integration pass. Exploratory software-Vulkan timings show large gains for expensive sparse scenes, and losses for flat and full-damage scenes. There was no preregistered performance acceptance protocol; no production or competitor speed claim follows. See [integration review](ROOT-REVIEW.md) and the [architecture investigation](../../docs/architecture-against-zgx.md).

## Sources and organization

| Role | Source and location |
| --- | --- |
| Integrated archive baseline | `cc193f85f5766c90a0677631c70c54c1eec4da1d`, `origin/wt/gpui-ce3` |
| Candidate implementation and benchmark | `690a00cade`, branch `local/architecture-performance`, `/home/user/gpui-architecture-local` |
| Measurement harness freeze | `715603431b`; same library/example source as `690a00cade` |
| Full-render control | Existing `Renderer`, separate instance/device resources, same example executable and Canvas workload |
| Deliberate faulty repair | `92562a1f74`, branch `local/retained-negative`, `/home/user/gpui-retained-negative` |
| Investigated competitor | ZGX `a3678578980ef239058c557338ef9c544d356b0c`, `/home/user/zgx-reference-local` |

No archive branch was merged or pushed. Native wiring in this candidate is for composed experimentation; it is not an adoption decision. Existing full-render APIs and behavior remain available. Application APIs are unchanged; `gpui_gpu` gains additive `RetainedRenderer` and `RetainedStats` exports.

The [qualification record](qualification.json) lists exact commands, source pins and scopes. [Input hashes](qualification/inputs-before.json) and their [verification](qualification/inputs-verified.json) cover 1,544 source/configuration/resource inputs, including vendors. [External artifacts](external-artifacts.json) identify local executables; those large binaries are not copied into git. [Raw runs](raw/paired/metadata.json) identify the measured binary, environment, compiler platform and command. The [clean rebuild](qualification/rebuild-identity.json) rebuilt the GPU library and reproduced that executable byte-for-byte. [Shader receipts](qualification/shader-identity.json) verify the generated compositor and new copy shader inside it.

## Mechanism and oracle

The renderer retains one texture, repairs Canvas's conservative damage with the existing full compositor under a scissor, then copies the image to a fresh presentation target. Repair and copy share one command encoder/submission. The full renderer remains the independent pixel oracle. An exposure redraw performs only the copy; it still submits and touches the full target.

The private native bridge qualifies damage using `(window namespace, acknowledged source epoch)`. Unknown predecessors, foreign windows, resize, failed preparation and invalidated packets cannot authorize partial repair. Coalesced candidates use the existing accumulated Canvas damage; slot patching still requires its exact preceding packet. An alpha or proof-class change retains the established full-preparation fallback. No swapchain buffer-age assumption, new unsafe code, or mutable shared window state is introduced.

Three new public GPU tests cover exact full-render parity through movement/removal, fresh targets, resize, failed preparation, mode changes, transparent overlap, text, images, transforms, color slots, all 256 sRGB channel codes and HDR. The native paint oracle also checks a different window with a colliding numeric source epoch. Existing platform tests exercise the composed host path. This is the exercised corpus, not universal backend parity.

## Exploratory measurements

Five fresh processes each ran five scenes. Each cell has ten warmups and sixty measured pairs, alternating full/retained order. The dataset contains **1,500 measured pairs** (3,000 measured renderer submissions). Warmups and initial/final exact-pixel checks run in the executable but are not emitted as raw rows. No frames/cells were dropped or retried. The earlier [probe](raw/probe.csv) is separate and excluded from these summaries.

Every scene is 512×256 SDR. The sparse edit is an 8×12 color slot whose conservative damage is 10×14: **140 compositor pixels versus 131,072**, plus a 131,072-pixel copy. The text case contains 24 text placements; overlap contains eight translucent rounded layers. Full damage changes the window-sized background. Exposure keeps the scene unchanged. Initialization, font shaping and scene construction are outside steady-state timing. Both alternatives validate equal initial and final GPU bytes. The benchmark retains no CPU output image.

Environment: Linux x86_64, Mesa 25.2.8 llvmpipe/LLVM 20.1.2, four llvmpipe workers, Rust nightly-2026-10-23, default Cargo release profile. This is a shared VM with background capture/filesystem services, not an isolated machine. Compilation was stopped during the timing series. These are **submission plus device-poll wall times**, not GPU timestamps, process CPU time, display latency or ZGX comparisons.

| Cell | Median candidate/control ratio across five process medians | Process ratio range | Result |
| --- | ---: | ---: | --- |
| Flat sparse edit | 1.1491 | 1.0316–1.2334 | Slower |
| Text sparse edit | 0.05555 | 0.04418–0.06220 | Faster in this software-driver condition |
| Translucent overlap sparse edit | 0.01661 | 0.01581–0.01849 | Faster in this software-driver condition |
| Text full-window edit | 1.0222 | 1.0081–1.0528 | Slower |
| Text exposure redraw | 0.03382 | 0.03193–0.04038 | Faster in this software-driver condition |

[Every process and raw sample](raw/paired/summary.json) includes host submission separately. [Per-process p50/p95/p99](raw/paired/quantiles.json) uses conventional median and nearest-rank tails. Sixty observations make p99 equal the maximum. These descriptive tails are not preregistered pass/fail gates. No aggregate is used to hide a losing cell.

## Correctness qualification

| Check | Result | Evidence |
| --- | --- | --- |
| GPUI with ordinary X11/accessibility features, tests and doctests | 775 passed, 38 ignored | [log](qualification/gpui-tests.log) |
| GPU units and software Vulkan render tests | 10 + 58 passed | [log](qualification/gpu-tests.log) |
| Strict all-target GPUI and GPU Clippy | Passed | [GPUI](qualification/gpui-clippy.log), [GPU](qualification/gpu-clippy.log) |
| Actual private X11 Todo/native script | One test passed, including paint, edits, pointer, resize, inspector and handoff | [log](qualification/native-x11.log) |
| Missing-repair mutant | Pixel assertion fails; 0 passed/1 failed | [log](qualification/negative-control.log) |

Counts overlap with earlier runs; they are not added together. Ordinary native unit tests include AccessKit projection, but this dossier does not claim a fresh AT-SPI client run or physical Mac/Windows validation. The mutant keeps copying but erases nonempty repair damage; its failing exact-pixel assertion demonstrates the new oracle detects stale content.

## Cost ledger

The repository's `tools/core_lines.py` with Syn and Tokei 15 counts **35,863 → 36,191**, **+328 shipping lines** across the seven libraries/build scripts. [Baseline](static/baseline-lines.json), [candidate](static/candidate-lines.json). Tests, examples and evidence are excluded. There are no manifest dependency, lockfile or vendor changes; the example stanza is additive.

One owned image adds 524,288 format bytes at this benchmark size; general storage is `width × height × bytes_per_pixel`, excluding driver alignment/metadata. HDR uses eight bytes per pixel. The wrapper adds a backing owner, pipeline/bind group and counters; retained capacity, first-use allocations, allocator overhead and process RSS/PSS remain unqualified. Headless owners that do not create this renderer gain no framebuffer.

The new literal copy shader is separately identified in [shader receipts](qualification/shader-identity.json); the original compositor shader remains unchanged. The joint benchmark executable is 15,290,712 bytes, with [GNU size output](static/binary-size.txt). It contains both alternatives and is **not** a before/after application binary-size delta. Function stack deltas, generated native shader/driver memory, cold initialization and teardown costs remain unmeasured.

## Failures and missing evidence

Earlier development attempts are preserved in git, but their temporary logs did not survive the environment restart. The conversation recorded: a fixture calling `fill_rect` with a slot instead of `fill_rect_slot`; a test command run from the legacy root; a readback fixture missing the result unwrap; an incorrect 25-pixel assertion corrected to Canvas's existing 49-pixel conservative bound; an exact test filter matching zero tests; and Tokei 12 failing to classify WGSL. These were corrected without weakening pixel equality, changing production damage or accepting the zero-test result. The refreshed logs above replace those attempts for qualification, not as fabricated reproductions of their original output.

The missing-repair mutant and all measured regressions remain visible. There is no preregistered speed threshold, continuous quiet-host audit, stored per-frame pixel archive, cold-start benchmark, peak/process-memory result, instruction profile or two-hardware-class comparison. Therefore this dossier does not pass the repository's adoption/public-parity gates. A new frozen campaign must address those gaps before any shipping or ZGX-ranking claim.

## Reproduction

Use a clean candidate checkout and its pinned toolchain. Keep target directories distinct from baseline and mutant builds, and freeze source before starting. From `reactivity/`:

```sh
cargo test --locked -p gpui --features x11 --target-dir /new/target-native
cargo test --locked -p gpui_gpu --features vulkan-tests --lib --test render \
  --target-dir /new/target-gpu -- --test-threads=1
cargo build --locked --release -p gpui_gpu --features vulkan-tests \
  --example retained --target-dir /new/target-release
LP_NUM_THREADS=4 XDG_RUNTIME_DIR=/existing/private/runtime \
  VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/lvp_icd.json \
  python3 evidence/retained-output-local/measure.py \
  --binary /new/target-release/release/examples/retained \
  --source .. --output /new/never-used-results --repeats 5 --frames 60
```

Physical-GPU qualification uses the existing `gpu-tests` profile instead of `vulkan-tests`; it refuses a software adapter. A real display is required for the native script. The measurement runner preserves failed process outputs and rejects wrong row counts, unexpected damage/copy bytes and executable changes. `verify.py` independently checks the packaged evidence, hashes and summaries; it does not convert this exploratory series into an adoption result.
