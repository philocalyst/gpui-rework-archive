# Static SPIR-V recipes with stage-owned Vulkan modules

The shipping source and test fixtures are frozen at
`a871fc6fa924f31bf08fe2a51248930025582da1`. The optional offline-shader feature
remains off by default. This slice removes the compositor's two retained native
shader-module payloads while preserving its reusable Core shader leases. It adds
no extension requirement, application platform binding, global cache, source
copy/hash, additional Arc or per-stage Box. Driver pipeline compilation remains.
Each later pipeline use deliberately recreates its native shader modules.

The exact published Core import is the separate `c27929d153` commit. Its 86
published files, licenses, manifests, lock and VCS record remain independently
verifiable with `vendor/wgpu-core/UPSTREAM.json`. Commit `4a5bf18ec3` applies exactly
root's `ffb4b8f58035330f4034a6891ec87de6574195c0` Vulkan device.rs ownership delta
without removing this branch's artifact-policy query. The final source builds
on the clean optional candidate `2dc03c126a81426336724174e8f5d695b6416bc7`.

Earlier artifact qualification stays at runtime source `bea848dbe4` and final
host-proof refinement `db73d4f1cc`; their evidence was not overwritten or
relabeled. The Raw comparison below executes the preserved, hash-checked bea
binary again. Current WGSL and static captures both execute frozen a871 binaries.

## Ownership and safety boundary

The hidden unsafe `Device::create_shader_module_static_spirv` in vendor WGPU's
`shader_artifact.rs` accepts a real `&'static [u32]`. Its native Core forwarding
method sends typed label/entry-point/words arguments directly to Core Global.
Only the existing result/error-sink/CoreShaderModule wrapping is shared with
ordinary passthrough. WGPU does not construct and clone another multi-backend
source descriptor for this route.

Core Global builds the ordinary borrowed SPIR-V descriptor itself, for identical
registry and trace behavior, then passes static provenance to a private common
resource constructor. That constructor retains the existing valid-device,
enabled PASSTHROUGH_SHADERS, backend, entry-point metadata and error handling.
Non-Vulkan static input returns NotCompiledForBackend before HAL. None is reserved
for unavailable native Core dispatch; missing features, lost/destroyed devices,
unsupported Core backends and driver errors remain normal error-scope results.
They never trigger successful WGSL retry. The compositor's existing checked
canonical-BGL lookup still rejects an invalid disposed-device pipeline.

The feature propagates WGPU -> Core -> HAL. With it absent, the new HAL enum
variants, static ingress and static-only branches/parameters compile out. Exact
Cargo graphs verify this and the continued absence of optional SHA2/host SPIR-V
frontend from the default host library closure. Checked WGSL and target/runtime
Naga remain available. The original adapter hint, exact live Device codegen
profile, private artifact family, interface proof and enabled guards remain.
All eight compositor SPIR-V files, generated Rust/layout data, manifest and WGSL
are byte-identical to the previous frozen artifacts.

Static storage proves source lifetime only. Both public ingress methods remain
unsafe; shader validity, ABI/interface compatibility and omitted runtime checks
still require the existing passthrough proof. The private GPU call site's proof
is unchanged. New unsafe forwarding blocks preserve that caller contract; no
transmute, raw-slice lifetime extension or new raw Vulkan operation is added.
Recipe creation does not validate native shader code. Native module creation and
driver validation failures are deferred to pipeline construction, which must
remain covered by error scopes. Empty recipe compilation information is not a
validation certificate.

| Owner | Ordinary SPIR-V | Static SPIR-V |
|---|---|---|
| Core ShaderModule Arc | HAL Raw native handle | HAL borrowed static slice |
| Public shader handle dropped while pipeline lives | pipeline retains Arc/native module | pipeline retains Arc/recipe |
| Each pipeline stage | borrows reusable Raw handle | creates one uniquely owned native module |
| Pipeline creation success/error/unwind | does not consume Raw | CompiledStage destroys temporary module |
| Final shader lease drop | destroys Raw exactly once | no native module to destroy |

Core pipeline descriptors clone/resolve registered IDs to Arc leases. Core's
compute state retains `_shader_module`; render pipelines move resolved stage Arcs
into `_shader_modules`, including vertex/task/mesh/fragment variants. Descriptor
borrows are never retained. HAL's enum stores the static slice directly. Core's
existing Box/Arc metadata ownership stays; no additional source allocation is
introduced. Tracing is the explicit exception: an active trace serializes/copies
source bytes through the existing passthrough action. Six actual trace actions
capture exactly the same vertex/fragment/compute bytes for static and Raw sources.
The action carries no static-lifetime provenance, so ordinary replay uses Raw
ownership and retains its native-module cost. Replay execution was not tested.

Vulkan `compile_stage` validates the CString before native module creation and
calls the existing create helper with label None for static words. No naming
allocation/failure occurs after obtaining that handle and before installing the
borrowed CompiledStage cleanup owner. Remaining flag/descriptor construction is
infallible. Earlier stage guards survive later-stage, render-pass, pipeline and
unwind exits. Raw selects no temporary owner. No new self-referential pNext graph
or inline module-create structure is introduced.

The same compile-stage owner covers compute, standard render and task/mesh render.
HAL ray generation/miss guards remain in their lexical scope; hit-stage guards
remain in their Vec. Moving those guards does not move CString backing storage.
Ray creation passes a null deferred operation and completes synchronously. Any
future deferred operation must retain all stage data/guards until completion.
This pinned Core exposes no ray-pipeline construction; ray/task/mesh ownership
was source-audited, not exercised on capable hardware.

Concurrent static reads introduce no shared mutable recipe state. Each call owns
its separate native handles. Static lifetime does not waive Vulkan host or cache
synchronization duties. HAL creates its own caches with default flags; it does
not add EXTERNALLY_SYNCHRONIZED cache creation here. Existing cache use/export/
merge/import duties remain with HAL/callers. The exercised compositor and public
fixture use cache None. No concurrent shared-cache result is claimed.

## Actual native calls and failure controls

The 139-line test-only Vulkan layer observes actual returned handles and injects
selected Vulkan OOM results. It is absent from allocator and DHAT measurements.
Each injection uses a fresh process/Device because Core intentionally loses a
Device after HAL OOM. Logs and exact multiset destruction checks are archived in
`checks/native-results.json` and `checks/native-*.log`. Successful calls reach the
real llvmpipe driver; injected failures return at the observed dispatch boundary.

| Phase | Module create requests | Created/destroyed | Pipeline requests | Native modules live afterward |
|---|---:|---:|---:|---:|
| Three static shader recipes | 0 | 0/0 | 0 | 0 |
| First render pipeline | 2 | 2/2 | 1 graphics | 0 |
| Second render from same recipes | 2 | 2/2 | 1 graphics | 0 |
| Four concurrent render pipelines | 8 | 8/8 | 4 graphics | 0 |
| Three compute pipelines from one recipe | 3 | 3/3 | 3 compute | 0 |
| First module-create failure | 1 | 0/0 | 0 | 0 |
| Second module-create failure | 2 | 1/1 | 0 | 0 |
| Graphics-pipeline failure | 2 | 2/2 | 1 graphics | 0 |
| Compute module/pipeline failure | 1 | 0/0 or 1/1 | 0 or 1 compute | 0 |
| Three ordinary Raw shaders | 3 | 3/0 | 0 | 3 |
| Raw reuse: two render + four concurrent render + three compute | 0 | 0/0 | 9 | 3 |
| Raw public shader handles dropped, pipelines retained | 0 | 0/0 | 0 | 3 |
| Last Raw pipeline leases dropped | 0 | 0/3 | 0 | 0 |

Raw pipeline OOM preserves both native modules until their shader owners drop.
Missing enabled features and an enabled Noop backend produce normal validation
scope errors and zero native module calls. A distinct copied-HAL unit artifact
checks borrowed-stage success, early return after one/two stages, Rust unwind and
Raw nonownership through fake Vulkan dispatch. Its standalone lock is archived
separately from the shipping workspace graph. Stage layout remains 72 bytes
versus the pre-RAII 80-byte representation. No panic is induced across a C ABI.
The scope is module ownership, not a full upstream partial-pipeline failure audit.

A second generated, test-only metadata observer records actual Device creation
parameters for the Raw and static constructors. Their enabled base/extension
feature values and extension lists match exactly. The requested Instance API is
1.3.0; llvmpipe reports physical API 1.4.354, Mesa 26.1.4 / LLVM 21.1.8, vendor
65541/device 0 and pipeline-cache UUID `32362e312e3461616161616161616161`.
VK_EXT_robustness2 is enabled with robustBufferAccess2/robustImageAccess2 both 1,
matching admitted profile zero. All observed pipeline-cache handles are null.
No maintenance5/GPL enablement or inline path is added. Header declarations used
by the observer, including beta declarations, do not enable Device features.
Full base-feature values, pNext values, extension names, source/header/tool hashes
and logs are retained. This observer is also absent from heap measurements.

## Matched allocation and driver-inclusive host heap

The normal public fixture constructs one owner on an already-created Device.
Device/Queue/Adapter/Instance observers remain outside the Rust allocator scope.
Current static measurements match the prior Raw artifact route exactly:

| Constructor | Rust requests | Requested bytes | Retained bytes | Peak bytes | Owner header |
|---|---:|---:|---:|---:|---:|
| Current WGSL Context | 7,833 | 2,188,947 | 365,318 | 741,098 | 48 |
| Current static Context | 68 | 9,572 | 7,906 | 8,010 | 48 |
| Current WGSL Renderer | 7,891 | 2,194,752 | 370,323 | 741,098 | 888 |
| Current static Renderer | 126 | 15,377 | 12,911 | 12,911 | 888 |

Feature-compiled/no-enabled-passthrough fallback remains two requests/96 requested
bytes above feature-off WGSL, with equal retained/peak bytes. Current checked WGSL
peak is 9 bytes above the prior frozen source's 741,089; the independent RAII
repair moves the fragment CString before compiler work. Requests and retained
bytes still match. Normal owner drop/poll returns shader/pipeline/layout counters
to baseline. Summed construction/Drop Rust scopes still leave 404 more bytes and
three net allocations on static than WGSL (Context 2,640 versus 2,236; Renderer
6,088 versus 5,684), matching the prior Raw control. External observers remain and
polling occurs outside those scopes; this residual is charged, not presented as a
precise post-poll heap attribution. HAL shader counters count wrappers and therefore still report two
additional static recipes while live. The inherited texture counter still reports
zero with the atlas live and -1 after drop; it is not a literal texture inventory.

DHAT 3.27.1 runs deliberately exit with Renderer and external graphics observers
alive. They are live-owner snapshots, not leak tests. Same actual adapter,
PASSTHROUGH_SHADERS request, cache None and MESA_SHADER_CACHE_DISABLE=true are used.
No native test layer is loaded. Raw reference binary hashes match the prior
archive. `heap-summary.json` keeps whole-process and constructor-stack subsets
separate; truncated deep stacks can omit subset allocations.

| Cache-disabled DHAT live owner | Current WGSL | Prior Raw | Current static |
|---|---:|---:|---:|
| Whole-process requested bytes/blocks | 114,706,268 / 96,008 | 112,547,233 / 88,273 | 112,492,769 / 88,161 |
| Whole-process global peak bytes/blocks | 43,141,606 / 12,829 | 42,784,282 / 11,967 | 42,784,266 / 11,966 |
| Retained host bytes/blocks | 42,276,551 / 9,385 | 41,953,519 / 8,523 | 41,919,139 / 8,521 |
| Direct constructor module allocated bytes/blocks | 34,360 / 2 | 34,380 / 2 | 34,380 / 2 |
| Direct constructor module retained bytes/blocks | 0 / 0 | 34,380 / 2 | 0 / 0 |

The static route retires exactly **34,380 host bytes / two native module blocks**
relative to Raw, with exactly the same whole-process retained reduction. Compared
with current checked WGSL, it retains **357,412 fewer host bytes / 864 fewer
blocks**, reconciling with the Rust owner retention difference now that the two
native module blocks retire. Matching constructor Naga stacks retain 358,524
bytes/866 blocks on WGSL and zero on static; internal Device validation compiler
work remains outside that constructor. Other requested/peak differences are reported, not
attributed solely to ownership; compiler/process state can affect them. This is
malloc/realloc host heap, excluding mappings, RSS, GPU/device memory. No startup,
CPU, hardware GPU-time or speed claim follows. Reuse incurs additional native
module creates, as the call table shows.

## Source, binary, artifacts and build cost

Syn test stripping plus Tokei counts the full changed shipping Rust files:
**+160 non-test/comment/blank lines** for this seam, GPU -5 and vendor +165.
The one expect-to-allow upstream lint compatibility edit has zero net lines but
is an authored change. Vendoring exposes that otherwise lint-capped upstream
unfulfilled expectation; locking, saved guard field and Drop stay unchanged.
The independent root RAII delta is -36 lines. Relative to the historical 649-line
optional candidate, the combined historical net is 649 - 36 + 160 = **773**;
this arithmetic does not absorb the newly vendored upstream package.

Published Core is separately charged: 386,299 archive bytes, 1,960,873 unpacked
bytes in 86 files, 53,972 text physical lines including 51,703 Rust physical lines.
The import adds its per-file UPSTREAM record separately. Manifests/provenance,
public fixture, independent minimal generator, locks, generated probe arrays,
139-line native layer, generated 427-line metadata observer and all evidence
scripts/data are separately charged in `nonshipping-costs.json`; none disappear
into the shipping-code delta.

The compositor's existing five unique aligned arrays still contain **139,064
static word bytes**; WGSL fallback remains linked. The separate minimal native
fixture contains 1,004 SPIR-V bytes, plus its generated Rust text. In matched
counts-on release fixtures, static `first` is 7,042,904 bytes versus current WGSL
6,845,504 (+197,400), and prior Raw 7,046,664 (-3,760). These are fixture binaries
with explicit graph/hash attribution, not a shipping application size result.

The complete current host build-executable/proc-macro ancestor closure is
252,618,900 logical file bytes by default and 301,796,977 optional: **+49,178,077**.
Keeping both configurations adds 106,571,013 new/replacement bytes while
57,392,936 superseded bytes remain. Graphs include every host ancestor, not just
direct dependencies; target/runtime Naga still exists, and default host WGSL
validation/output already uses Naga via wgsl-rs. These are logical file sizes,
not physical cache blocks/RSS or cold-build duration. The external spirv-val
requirement and its tool bytes remain. A later consumer-build artifact proposal
is recorded in `consumer-build-proposal.md`; no part is implemented in a871.

## Qualification and reproduction

The 21 primary recorded gates and independent harness results all use a871:

- Optional: 46 actual Vulkan pixel cases, 10 GPU units, 4 presentation cases.
- Default: 45 actual Vulkan cases, 9 GPU units, 4 presentation cases.
- Strict all-target GPU Clippy with/without the feature; strict trace/Noop native
  fixture Clippy; four actual host interface-proof rejection tests.
- Eight compositor and three minimal SPIR-V files pass pinned spirv-val Vulkan1.0.
- Nine actual native call/failure cases, faithful active trace and a separate
  fake-dispatch stage ownership/unwind case.
- Apple AArch64 and Windows MSVC desktop+parallel+offline all-target build-std
  checks. These compile fallback branches and do not execute Metal/DX12.
- Both actual X11 early-rejection/worker-retained-window-close and ordinary Todo
  presentation/edit/pointer/resize/inspection tests. Owned display 156 and its
  runtime directory were retired.

Existing pixel tolerances remain; no blanket floating-point bit equality claim
is made. Runtime artifact profile zero is exercised; other profile outputs retain
the previous mechanical proof/validation but are not forced onto incompatible
hardware. No ray/task/mesh hardware qualification is claimed.

`checks/source.json` pins every tracked crate/vendor/manifest and fixture source
byte, with before/after guards. Test and fixture binaries come from actual Cargo
compiler artifacts, are copied to owned paths, and are hash-checked around
execution. Separate HAL/host proof graphs are archived explicitly. Unit graphs
prove exact feature gating. Tools, headers, actual device parameters, commands,
raw profiles and per-run records retain independent hashes. Prior frozen evidence
is unchanged. Diagnostic build/test durations in logs are not performance data.

Representative commands from reactivity after sourcing `/tmp/gpui-native-env.sh`,
setting CARGO_BUILD_JOBS=2, an owned CARGO_TARGET_DIR and the pinned GPUI_SPIRV_VAL:

```sh
cargo test --offline --locked --release -p gpui_gpu --all-targets --features vulkan-tests,offline-shader
cargo test --offline --locked --release -p gpui_gpu --all-targets --features vulkan-tests
cargo clippy --offline --locked --release -p gpui_gpu --all-targets --features vulkan-tests,offline-shader -- -D warnings
RUSTC_BOOTSTRAP=1 cargo check --offline --locked -p gpui --all-targets --features desktop,gpui_canvas/parallel,gpui_gpu/offline-shader --target aarch64-apple-darwin -Zbuild-std=std,panic_abort
RUSTC_BOOTSTRAP=1 cargo check --offline --locked -p gpui --all-targets --features desktop,gpui_canvas/parallel,gpui_gpu/offline-shader --target x86_64-pc-windows-msvc -Zbuild-std=std,panic_abort
```

The evidence drivers retain the exact local paths/commands and can be copied into
an isolated a871 checkout for reproduction. `archive.py unpack` restores packed
raw captures losslessly; `packed-originals.json` records original bytes/hashes.
Frozen-source gate drivers intentionally reject another HEAD. Failed preliminary
or harness-setup controls remain separate: missing spirv-val environment, an
unfrozen trace cfg race, several OOMs incorrectly attempted on one already-lost
Device, a missing host-proof fragment fixture, an overbroad host-feature assertion
that mixed a Naga build executable with its host library, and missing beta header
declarations in the metadata observer. Corrected final gates change no a871
shipping/test source. None of those diagnostic controls is retagged as passing.
