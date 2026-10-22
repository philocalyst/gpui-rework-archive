# Experimental first-constructor offline shader control

This opt-in `gpui_gpu/offline-shader` experiment removes runtime Naga frontend,
interface reflection and SPIR-V generation from the admitted compositor
constructor. It keeps checked owned WGSL for other devices and remains **off by
default**. Driver shader/pipeline compilation and device creation remain. This
is an allocation, ownership and correctness experiment on llvmpipe, with no CPU
timing, hardware GPU-time or GPU-memory improvement claim.

## Frozen sources and controls

- `6bbb661465`: public `first.rs` fixture frozen before implementation, with the
  original WGSL renderer. Both reference and experiment request exactly the same
  optional PASSTHROUGH_SHADERS feature on the same real Vulkan adapter.
- `10ad2a388f`: full two-entry artifact losing control. Actual HAL enables
  SEPARATE_ENTRY_POINTS unconditionally; conservative admission therefore always
  falls back. It adds two error-scope requests/96 bytes without removing compiler
  work. Its generated output and measurements are preserved separately.
- `ead997a2ad`: per-stage artifact control before the destroyed-device fix. Its
  43/44 result is preserved, not relabelled as successful final evidence.
- `4cf0dacbda`: both routes use the existing checked
  `pipeline.get_bind_group_layout(0)` certificate inside the error scope. Without
  it, an already-destroyed device can yield an invalid pipeline while ignoring
  creation errors. No new validity API or device-lost callback takeover was added.
- `8418bfc87a`: admission/error/bounds qualification before selected-entry
  compaction. Its 5,664-byte vertex module and measurements remain prior controls.
- **`bea848dbe4`**: last shipping source change. Host generation mirrors HAL's
  selected-entry `process_overrides` compaction; vertex output becomes 880 bytes.
- **`0981fdccae`**: final qualification source, adding only provenance/docs and
  the public context-first-drop and live-driver-heap fixtures. Shipping source
  remains exactly `bea848dbe4`. Full hashes are in `final/*source.txt`.

No rebasing occurred during the frozen gates. Root's later Auto blank-scene
deferral and temporary-stage RAII repair are independent changes, absent here.
The evidence commit adds no shipping source. `working-status-before-evidence.txt`
records only this untracked evidence directory. Binary hashes identify every
preserved executable; no old control is retagged as final.

## Admission and unsafe boundary

The GPU crate consumes a sealed, backend-neutral vendor Device profile. Vendor
WGPU alone checks enabled PASSTHROUGH_SHADERS/backend; vendor HAL reads the exact
live Device's Naga options and actual enabled extension where needed. Adapter
support is only an optional-feature request hint, never Device authority. The
hint and both enabled/missing-feature profile queries allocate zero Rust bytes;
the discarded `Adapter::get_info().backend` hint allocated three requests/65
bytes. No instance, device, driver load or resource is constructed by either
query. GPUI gains no OS/vendor/raw-HAL branch or retained field.

Revision two binds four buffer/image Restrict-or-Unchecked profiles to this
private generated family. Local indices stay Restrict, loop bounding and integer
division checks stay enabled, and there is no coordinate adjustment. Vulkan
already uses a negative-height viewport. The actual llvmpipe Device admits
profile zero; the other three profiles receive build/reparse/validator proof,
but were not forced onto incompatible hardware as a runtime test.

The generator consumes the exact typed wgsl-rs output, pins Naga 30.0.1 to WGPU 30,
and validates source and strict SPIR-V reparse. It checks the complete stage and
resource interface, readonly usage, dynamic strides, struct member offsets,
minimum sizes, capabilities and descriptor decorations. It emits the exact
ascending six-entry BGL and explicit PL together with the artifacts. Each context
mints a fresh BGL; checked pipeline lookup then provides the fresh retained
layout certificate used by State identity. Caller layouts/bytes/profile bits
cannot enter this private constructor.

All eight per-stage/profile files pass pinned `spirv-val --target-env vulkan1.0`.
All four vertex files must be byte-identical before deduplication. SPIR-V 1.0
storage buffers emit SPV_KHR_storage_buffer_storage_class; this is the sole
permitted extension, backed by the actually enabled device extension below
SPIR-V 1.3 and promoted core support above it. The report's initial no-extension
and full-module assumptions are corrected in its implementation addendum.
Lower-version output is not byte equivalence to HAL output.

HAL's fixed pipeline choices were audited: empty constants, enabled workgroup
initialization, no workgroup variables, overrides, varyings, binding arrays,
fragment-depth output, ray/task/mesh operations or subgroup use. The nonempty
binding map is identity for the exact ascending entries; other stage temporary
options are inert for this interface. Changing these facts or typed source
requires regenerating and reviewing the proof. No guard is removed because a
host bound appears sufficient.

There are **three authored unsafe sites**: two vendor-local immutable borrowed
HAL queries and one private GPU passthrough call site invoked twice, once per
stage. Build helper code is safe Rust. Default GPU builds retain
`forbid(unsafe_code)`; the optional build uses crate-level deny with a local
allow only on the private artifact module. Static aligned u32 arrays avoid
runtime conversion, copying or immutable hash scanning. Hashes and independent
validation are build/evidence work. Shader, pipeline, validation, internal and
OOM errors propagate; they never trigger a successful WGSL retry.

## First owner: Rust allocation scope

`first.rs` constructs one owner on an already-created Device. It includes the
entire Context or Renderer, including initial window buffers/atlas State where
applicable. Device/Queue/Adapter/Instance observers are equal and outside this
thread-local Rust allocator scope. Printed holder sizes include the Option.

| Constructor | Requests | Requested bytes | Retained bytes | Peak live bytes | Owner/holder header |
|---|---:|---:|---:|---:|---:|
| WGSL Context | 7,833 | 2,188,947 | 365,318 | 741,089 | 48/48 |
| artifact Context | 68 | 9,572 | 7,906 | 8,010 | 48/48 |
| WGSL Renderer | 7,891 | 2,194,752 | 370,323 | 741,089 | 888/888 |
| artifact Renderer | 126 | 15,377 | 12,911 | 12,911 | 888/888 |

State stays 840 bytes and native Candidate stays 1,000 bytes; no owner fields,
global cache or second device tree are added. Both first-owner captures include
the canonical registered BGL operation: against the invalid `ead` control it
costs two requests/64 requested bytes/32 retained bytes. It is necessary for the
destroyed-device error contract.

Summing the construction and owner-Drop Rust scopes leaves 404 more bytes/three
net allocations on the raw route (Context 2,640 versus 2,236 bytes net, Renderer
6,088 versus 5,684). This is a measured scope residual with external Device/
Instance observers alive, not a precise post-poll retained-heap reading or proof
of its allocation origins: polling occurs outside these Rust allocator scopes.
It is charged, not hidden by equal headers. The context-first
State probe retains its BGL authority but no shader/pipeline after Context drop;
`artifact-lifetime.txt` and `default-lifetime.txt` record the complete observed
resource counters/drop allocations, including maintenance effects. HAL's
inherited texture counter reports zero while the initial atlas is live and −1
after drop on both routes; its byte/view counters remain useful, but this signed
counter must not be presented as a literal native texture inventory.

Compiled optional feature with no enabled PASSTHROUGH_SHADERS falls back to WGSL:
7,893 requests/2,194,848 bytes, exactly two scope requests/96 bytes above default,
with equal retained/peak bytes. Feature-off WGSL reproduces the original
7,891/2,194,752/370,323/741,089 result exactly. The optional fallback overhead is
a real cost of this control.

Actual x86_64 release prologues are archived, with no timing interpretation:
`first::main` reserves the same 2,032-byte frame; Context's poll closure frame
increases 440→584 bytes. This is partial stack accounting, not an async-future
size or maximum stack-depth claim. No per-draw refcount or frame-path logic is
added.

## Native objects and driver-inclusive host heap

Matched-feature HAL counters begin with the same internal device validation
resources. Context adds one render pipeline/PL/BGL on each route. WGSL adds one
HAL Intermediate shader owner; artifact adds two Raw shader owners. These
counters count wrappers, so source and DHAT distinguish their native payload:
checked compilation creates two temporary VkShaderModule objects and destroys
them after successful pipeline compilation; raw modules retain two native
VkShaderModule objects through core pipeline shader leases. Both return to the
same shader/pipeline/layout baseline after owner drop and polling.

On this llvmpipe run, DHAT directly attributes **34,380 retained bytes / two blocks**
to vk_common_CreateShaderModule under the artifact constructor:880+112 and
33,276+112 bytes. WGSL's corresponding 34,360 bytes / two blocks are temporary and
retain zero after construction. Reusable Raw handles are not consumed after
first compilation. Removing this cost requires a separate lifetime-safe static
SPIR-V/native-stage formulation; it is not implemented here.

`driver-retained.rs` deliberately exits before owner and external graphics
observer destructors, allowing DHAT's end snapshot to measure the live owner.
It is not a leak test, RSS or GPU memory reading. `first.rs` remains the ordinary
drop control. Final matched driver captures explicitly disable Mesa disk shader
cache (`MESA_SHADER_CACHE_DISABLE=true`); earlier inherited-cache controls remain
archived and are not used as cold-work evidence. See `dhat-summary.json` and raw
profiles for all whole-process and matching-stack subset values. Deep truncated
stacks can be omitted from subsets; whole-process values include device setup,
driver compiler and process state. No mapped/driver-device memory is counted.

| Cache-disabled DHAT, live owner | WGSL | artifact |
|---|---:|---:|
| Whole-process allocated bytes/blocks | 114,691,548 / 95,992 | 112,547,233 / 88,273 |
| Whole-process global peak bytes/blocks | 43,141,606 / 12,829 | 42,784,266 / 11,966 |
| Retained host bytes/blocks before destructors | 42,276,551 / 9,385 | 41,953,519 / 8,523 |

The **323,032-byte retained reduction** reconciles exactly with 357,412 fewer
retained Rust bytes minus 34,380 new retained native-module bytes. The large
common device/driver floor remains. Matching constructor stacks retain
358,524 bytes/866 blocks of Naga allocations on WGSL and zero on the artifact
route; Naga work for internal device validation remains outside that constructor.
The constructor-stack subset is not the whole process.

The inherited Intermediate error-path cleanup gap is also explicit: before
Root's independent RAII repair, driver pipeline failure can return through `?`
before manual temporary-module cleanup, and a later-stage failure can strand an
earlier temporary. This frozen slice neither induces that driver failure nor
fixes it. Raw shader leases retain their normal destruction ownership on errors.

## Source, artifacts, binary and host cost

Syn test spans plus Tokei 15 count GPU/src **and build.rs**, including all host
helper code under src. Shipping GPU code rises 2,421→2,972 comment-free non-test
lines: **+551**, including 454 host-proof/generator lines and 52 private artifact
lines. Vendor changes separately add **65** lines, for **616 authored shipping
code lines total**, plus manifests/locks/provenance, tests, benchmark helpers and
this evidence. No relocation or first-party-only reduction claim is made.

The generated Rust data is additionally charged in `artifact-and-linked-bytes.json`.
Eight emitted SPIR-V files total 141,704 bytes; five unique compiled word arrays
total **139,064 bytes**. Four vertex outputs are 880 bytes each, fragments 33,276 /
33,436 /35,656 /35,816 bytes. WGSL fallback remains linked. Raw files, word-source
gzip and manifests retain independent hashes. Build output may also contain
unused older full-module files from losing controls; those are cache history,
not linked current artifacts.

The generated Rust word/layout data itself is 4,369 physical lines/388,611 bytes,
charged separately from the 616 authored shipping-code lines, and archived
losslessly as `ui-artifacts.rs.gz` rather than hidden in the host helper count.

The frozen first fixture binary grows 6,836,376→7,038,680 bytes (**+202,304**).
Feature-off current binary is 6,838,208 bytes (**+1,832** versus frozen baseline),
despite equal allocation behavior. Section sizes and all binary hashes are
archived; no binary-size win is claimed.

Optional host-only dependencies are pinned Naga 30.0.1 with SPIR-V input/output
and SHA2=0.11.1 without defaults. SHA2's published archive checksum is
47d7069beb7d6ac7b9acd1039986e73443f24234f41074da099d6f994ac9ad19;
resolved transitives/checksums are archived. Default build unit graphs prove
SHA2 and host SPIR-V frontend absent; target/runtime Naga features remain equal.
Default already used wgsl-rs's Naga WGSL validation/output; it is not advertised
as a compiler-free default build.

The complete host ancestor closure (build executables, proc-macros and their
libraries/metadata) occupies 252,618,670 logical file bytes by default versus
301,794,619 with the feature: **+49,175,949** for one configuration. Keeping both
configurations adds 105,415,893 bytes of new/replacement files while 56,239,944
bytes of older variants remain; the incremental local cache is not just the net.
This includes Naga feature-unified wgsl-rs variants and all hashing transitives,
not only direct deps. Current host build executable grows 8,250,080→12,010,056
bytes; the earlier baseline 8,249,856-byte executable is separately pinned.
These are logical file sizes, not physical disk usage, loaded RSS or host
compile speed. External spirv-val/tool derivation bytes are additional costs.

## Qualified gates and reproduction

- Artifact feature: 46 Vulkan integration cases (all 44 originals plus two new
  cases), 10 GPU units and 4 presentation tests pass. The original oracle uses its
  existing tolerances; targeted four-edge cases compare exactly. No blanket
  bit-identical claim is made for all floating-point pixels.
- Default: 45 Vulkan cases, 9 GPU units and 4 presentation tests pass with the
  feature absent. Strict all-target GPU Clippy passes with/without feature;
  strict standalone fixture Clippy includes the final measurement helpers.
- Three actual host-proof rejection fixtures pass: changed binding, writable
  storage and altered SPIR-V descriptor set. Artifact revision/missing-variant
  rejection occurs before passthrough; real missing-feature fallback, restrictive
  storage-binding failure and destroyed-device behavior are exercised.
- Host bounds cover MAX_REFERENCES/overflow without partial mutation, tile-end
  indexing, last atlas row/overflow, four viewport edges and partial tiles,
  maximal extents, target mismatch, and the existing image/group/affine/paint
  suite. 16,384-edge geometry still correctly returns Precision; empty maximum
  targets render. The atlas last-row fixture validates packing/upload admission,
  not a real maximum-size font glyph's pixels.
- Apple AArch64 and Windows MSVC desktop+parallel+offline all-target build-std
  checks pass. They compile fallback branches; they do not run AppKit/DX12 or
  establish Vulkan hardware timing. Both actual X11 tests pass: early unsupported
  target/worker-retained-window close and ordinary Todo presentation/edit/pointer/
  resize/inspection. The owned display 147 and runtime directory were retired.

Representative commands, from reactivity/, after sourcing the documented native
environment and exporting CARGO_BUILD_JOBS=2, own CARGO_TARGET_DIR and
GPUI_SPIRV_VAL to the pinned tool in tools.json:

```sh
cargo test --offline --locked --release -p gpui_gpu --all-targets --features vulkan-tests,offline-shader
cargo clippy --offline --locked --release -p gpui_gpu --all-targets --features vulkan-tests,offline-shader -- -D warnings
cargo test --offline --locked --release -p gpui_gpu --all-targets --features vulkan-tests
cargo build --offline --locked --release --manifest-path benchmarks/gpu-owner/Cargo.toml --bin first --features offline-shader
cargo build --offline --locked --release --manifest-path benchmarks/gpu-owner/Cargo.toml --bin first
bash evidence/offline-shader/run-native.sh
```

`final/{default,artifact}-unit-graph.json` come from `cargo build --unit-graph
-Zunstable-options` with RUSTC_BOOTSTRAP=1; artifact JSONL comes from matched
`cargo build --message-format=json` commands. `capture-evidence.py` regenerates
ledgers from these exact graphs, files and profiles, checking all artifact hashes
and rerunning spirv-val. The source/paths and versioned Nix tool hashes are
explicit; spirv-val reports 2026.4 with an unknown upstream build hash. No
spirv-opt pass is used. `SHA256SUMS` checks the committed evidence. Raw failed
controls and diagnostic build durations are retained without performance claims.
`pack-evidence.py` losslessly gzips bulky DHAT/generated data and log files with
trailing whitespace; `packed-originals.json` retains their original byte counts
and hashes. Use gzip decompression to read those raw captures. Regenerating
ledgers followed by packing preserves this archive convention.
