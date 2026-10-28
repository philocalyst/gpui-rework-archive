# Lazy Core indirect-validation ownership

Implementation: `30ea379b24660c63c6601e0cdee21bc3e1437c36`.
Control: `06b15c1835291b40b6bbc426b8a5eee72cc2a35a`.
WGPU Core/HAL: vendored 30.0.1, upstream
`40f4a34ebaf56f9a046231f54125ad046239d3f3`; the existing vendor provenance
records the published archives. This archive does not change product source.

Device creation keeps today's instance/capability policy but defers its two
internal indirect-validation WGSL/Naga/HAL stacks to setup of the first
normal/imported INDIRECT buffer. Pipeline layouts retain
INDIRECT_BUILTIN_UPDATE from policy before initialization. Current first-party
GPUI/GPU code uses direct calls and does not create INDIRECT buffers. This cut
retains Naga, checked application WGSL and every backend's validation machinery.
The external-texture/default-buffer setup is unchanged.

## Matched native allocation and HAL counts

Three control/candidate pairs produced identical counts in every repetition.
`summary.json` contains parsed results; `checks/counts-{baseline,variant}-*.log`
contains raw output. The control is extracted from its exact Git pin and uses the
same locked dependency graph, delegated HAL probe and allocator instrumentation.

Measurement spans Core `create_device_from_hal`: Device + Queue creation and late
queue setup, after instance/adapter discovery and HAL device open. Backend is
Vulkan on llvmpipe, Mesa 26.1.4 / LLVM 21.1.8. Compiler is Rust 1.97.1 / LLVM
22.1.6. Counts use Core std + wgsl + vulkan + noop without trace. The constructing
thread's System allocator is observed; fixed TLS storage tracks allocation
pointers without allocating in the observation callback. The probe's fixed TLS
storage and the preallocated event arrays are outside the measured interval.
Driver/libc allocations, GPU allocations, process RSS and elapsed time are outside
this measurement. No timing campaign was performed for this cut.

| Constructor observation | Control | Lazy |
| --- | ---: | ---: |
| Rust allocation/reallocation calls | 1,608 | 39 |
| Rust requested bytes | 474,723 | 6,026 |
| Rust deallocation/reallocation calls | 1,380 | 2 |
| Rust freed bytes | 399,797 | 468 |
| New Rust bytes still live at return | 74,926 | 5,558 |
| Freed bytes from before observation | 0 | 0 |
| `size_of::<Device>()` | 1,344 | 1,104 |

Requested bytes fall 98.73%, retained new bytes 92.58%, allocation calls 97.57%,
and Device size by 240 bytes. These percentages describe this constructor and
allocator scope, not overall application memory or startup time.

| Successful native constructor HAL calls | Control | Lazy |
| --- | ---: | ---: |
| Shader module | 2 | 0 |
| Compute pipeline | 2 | 0 |
| Pipeline layout | 2 | 0 |
| Bind-group layout | 6 | 1 |
| Buffer | 4 | 3 |
| Bind group | 1 | 0 |
| Fence / command encoder | 1 / 1 | 1 / 1 |

Exactly 13 validation HAL acquisitions leave the direct-only constructor. Each
explicitly destroyed HAL object is accounted for; command encoders use their
own Drop implementation. The probe delegates to real Vulkan and tracks boxed
native-HAL handle identity. It does not intercept Vulkan driver entry points.

| Buffer observation | Control calls / requested / retained new bytes | Lazy calls / requested / retained new bytes |
| --- | ---: | ---: |
| Direct buffer | 7 / 488 / 488 | 7 / 488 / 488 |
| First INDIRECT buffer | 17 / 840 / 600 | 1,587 / 469,569 / 70,000 |
| Repeated INDIRECT buffer | 14 / 768 / 528 | 14 / 768 / 528 |

For constructor + first INDIRECT buffer, totals are 1,625 / 475,563 / 75,526
versus 1,626 / 475,595 / 75,558. The cold owner adds exactly one 272-byte Box;
the Device shrinks 240 bytes, leaving +32 bytes and one allocation for an
indirect-using device at these observation boundaries. Both first-use intervals
free zero preexisting bytes. Repeated use frees 280 preexisting bytes on both
controls; its retained-new count must not be confused with its 248-byte net
delta. Tracking overflow is zero throughout. No new draw pool is introduced.

## Error and ownership contract

The outer Option remains policy; initialized cell contents remain state. The
shared existing OnceCellOrLock alias supplies std/no_std/wasm behavior. Result is
cached, including setup failure. A returned setup error keeps the constructor's
existing Lost mapping and now invalidates the live device at first INDIRECT
buffer creation, rather than failing the original device request. Later normal
buffer creation fails its validity check before HAL allocation.

The sticky error is published before calling Device::lose. The lost callback is
taken under its mutex and invoked after that mutex is released. Tests inspect the
published cell inside user code and reenter buffer creation and registration.
Exact-once means a consumed registered FnOnce: existing callback re-registration,
concurrent loss, destroy and poll policy is retained, without a new CAS policy.
Per-buffer group errors keep IndirectValidationBindGroup; Lost also delivers
live-device loss, while per-buffer OOM remains recoverable. A public WGPU
validation scope stays empty for DeviceLost, and its registered loss callback
fires. `poll(Poll)` can return QueueEmpty after loss and is not a validity oracle.

Pending is a stack-only ownership guard. Every acquired dispatch/draw HAL object
is guarded before the next acquisition, and reverse stack order releases its
dependents first on returned error or Rust unwind. A complete Dispatch is guarded
while Draw is built. Source-group setup protects the first group if the second
fails. Draw-pool setup protects the buffer if group creation fails. User-buffer
setup protects the buffer and preceding timestamp group until transfer.

Imported HAL handles are taken by value at the public WGPU API, boxed by Core's
Global, and have no handle-return error channel. Core must dispose the transferred
wrapper on failure. HAL add_raw_buffer accounting therefore precedes fallible
setup and balances HAL destroy_buffer on success or failure. Vulkan/Metal/DX12/
GLES all add/subtract this accounting; noop has no counter. HAL continues to
choose native ownership behavior: Vulkan External releases its drop callback and
leaves the caller's VkBuffer/memory owned by the caller; RawHandle and Managed
retain their existing native destruction rules. The native import test retains a
real initialized caller-owned buffer and transfers an External wrapper. Each of
15 setup failures invokes that wrapper's callback once, then the caller separately
destroys its original owner. No native ownership rule is recreated in Core.

Device drop consumes only an already initialized successful cell. DrawResources
never initializes it, retains its Device Arc while buffers are leased, and returns
pool entries before final device disposal. The ready-state checks at actual
indirect execution retain the successful-buffer invariant.

## Qualification and limits

`qualification.rs` and `pool-qualification.rs` provide 12 focused Core-private
tests. `proxy.rs` is mechanically generated DynDevice delegation over the existing
noop/real Vulkan HAL, with acquisition faults and identity accounting; it is not
a replacement fake Device. Coverage includes:

- Direct-only and disabled flag/downlevel/limit policies, pre-init layout flags,
  empty-owner drop, repeated use, and eight concurrent successful first buffers.
- Every one of 16 user-buffer/validator/group acquisition stages, returned Lost
  and Rust unwind, on both noop and Vulkan. Construction unwinds release partial
  owners and permit retry according to OnceCell/OnceLock semantics.
- All 15 imported-buffer setup failure stages on noop and Vulkan; draw-pool
  buffer/group failure and unwind; real pool return before last Device drop.
- Sticky errors, eight simultaneous failing first uses on both backends, original
  FnOnce consumption, no later HAL retry, OOM classification, and a user loss
  callback that itself unwinds.
- Successful public CreateBuffer trace-action replay into fresh noop Core devices:
  direct actions leave the cell empty; indirect actions initialize it. Failed
  setup publishes no successful action or internal shader/pipeline trace actions.

`native/` executes actual Vulkan compute and render commands. Its application
compute pipeline/layout exists before the first INDIRECT buffer. Direct dispatch
plus valid indirect dispatch and rejected oversized dispatch read back 4. Direct
and indirect triangle draws read back red; unsupported nonzero first-instance
indirect draw leaves the cleared pixel black. A direct-only run reads back 1.
Both native disk traces are archived in `traces/`; full native command-trace replay
was not run because this vendored crate does not include a trace-player executor.
The narrower buffer-action replay directly tests the initialization seam.

First-party gpui_gpu passes 9 library tests and all 45 Vulkan render tests, plus
strict Clippy over all targets. Core strict Clippy under identical repository
clippy.toml reports the same 30 existing diagnostics in both controls: 26
result_large_err, 2 collapsible_match and 2 enum_variant_names. A scoped run
allowlists precisely those categories and denies all other warnings; it passes.
No lint allowances or upstream lint fixes were added to product source.

Core checks pass for Linux std, its no-default-features wgsl+noop alias, wasm32
WebGL, x86_64 Apple Metal, and x86_64 MSVC DX12. Cross targets use build-std from
the provided Rust sources. `cross-flags.json` records actual fingerprints: Windows
retains windows_slim_errors/crt-static, and Apple/wasm retain repository generic
flags. These are compile checks, without runtime or final-link validation on those
platforms. The Core no_std alias check is not a claim that the whole dependency
graph runs without std or on a freestanding target. Ordinary browser WebGPU uses
its own backend and is outside this Core path. C-driver longjmp/native crash
recovery is outside the Rust guard contract.

## Reproduction

Use a separate checkout and target directory. Run the runners serially: they
append private cfg(test) modules/copy the matched lock and restore source/lock
bytes in finally blocks. Product source contains neither hook nor fault switch.
The public-loss runner temporarily injects one constructor-entry error solely
for testing WGPU's callback routing, then restores it.

```sh
source /tmp/gpui-native-env.sh
unset RUSTFLAGS CARGO_ENCODED_RUSTFLAGS
export CARGO_BUILD_JOBS=2
export CARGO_TARGET_DIR=/tmp/gpui-lazy-indirect-repro-target
python3 reactivity/evidence/lazy-indirect/qualify.py
python3 reactivity/evidence/lazy-indirect/qualify.py --baseline
python3 reactivity/evidence/lazy-indirect/qualify.py --counts
python3 reactivity/evidence/lazy-indirect/qualify-public-loss.py
mkdir -p /tmp/gpui-lazy-indirect-repro-trace
cargo run --locked --manifest-path reactivity/evidence/lazy-indirect/native/Cargo.toml -- /tmp/gpui-lazy-indirect-repro-trace
cargo test --locked --manifest-path reactivity/Cargo.toml -p gpui_gpu --features vulkan-tests --lib --test render
cargo clippy --locked --manifest-path reactivity/Cargo.toml -p gpui_gpu --all-targets --features vulkan-tests -- -D warnings
```

Python 3.13 was used. Retain the repository .cargo/config.toml, and leave global
RUSTFLAGS/CARGO_ENCODED_RUSTFLAGS unset for cross checks so target-specific flags
are honored. Standalone Core checks pass a patch for the local vendor/wgpu-hal;
wgsl,vulkan,noop are the count features, while functional trace tests add
trace,replay. Cross checks use `RUSTC_BOOTSTRAP=1 cargo check -Z
build-std=std,panic_abort --target <target>` with wgsl,metal / wgsl,dx12 /
wgsl,webgl respectively. The no-default-features check uses wgsl,noop.

The implementation changes six vendor Rust files: 231 added, 46 removed physical
lines (net +185), plus 27 provenance lines. First-party Rust source changes are
zero. Tests, generated delegation, drivers, locks, raw logs and traces here are
separate evidence, not product code or runtime dependencies. No startup/frame
speedup, RSS reduction, whole-stack removal or portable shader-blob claim follows
from this archive.
