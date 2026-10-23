# Feature-admitted default external-texture parameters

Shipping source: `504458c250`. Control: `4de6a23d70bbd3babae6902fc877cb900fb20599`.
WGPU Core/HAL remain vendored 30.0.1 at upstream
`40f4a34ebaf56f9a046231f54125ad046239d3f3`.

The Device owns the default external-texture uniform only when its requested
features include `EXTERNAL_TEXTURE`. This is an `Option<Box<dyn DynBuffer>>`,
which has the same 16-byte layout as the former ManuallyDrop owner. Enabled
feature devices retain the existing eager allocation, upload, queue ordering,
error conversion and destruction order. Feature-disabled devices skip both the
208-byte uniform and its 208-byte staging upload. The zero buffer, empty BGL,
timestamp machinery and indirect-validation policy are unchanged. No lazy state,
new error, queue upgrade, mapping policy, dependency or public API is added.

The only shipping file changes from 4603 to 4615 Rust code lines under tokei
15.0.0 (no blank lines, comments or test module in that file): +12 vendored lines.
First-party core is unchanged. Private probes, delegation and evidence are
separate from that bill.

## Admission proof

Device features are the effective DeviceDescriptor.required_features, including
for imported HAL devices. Normal requests first filter/validate those requested
features; both paths use Device::new and the same late queue setup. Adapter
support alone never allocates this owner. GPUI's normal device request is empty;
its offline-artifact hint requests PASSTHROUGH_SHADERS only.

The sole owning nonempty Core BGL constructor is
Device::create_bind_group_layout_impl. Both explicit and inferred layouts call
it, and its ExternalTexture entry requires EXTERNAL_TEXTURE before HAL creation.
Pipeline get-layout clones a validated existing layout or constructs an empty
layout. Invalid layouts also have empty entries. There is no imported BGL API.
Bind-group creation checks layout validity and same-device ownership before its
sole private TextureView-to-ExternalTexture binding caller. That caller's expect
expresses this established feature/owner invariant and performs no HAL work.
Real ExternalTexture objects continue to own their separately described params.

Trace Init retains required_features. The focused trace check inspects Init and
replays a rejected explicit ExternalTexture layout action through the same
constructor on a fresh feature-disabled device. This is narrow action replay;
this vendor does not contain a full command-trace playback executor.

## Matched constructor observations

Three repetitions per variant/backend agree exactly. Measurement spans Core's
imported-device constructor, including Device, Queue and late initialization,
after adapter discovery and HAL open. Both variants use the same delegated real
HAL device/encoder observers and allocator, locked graph, compiler, profile,
features, config and actual rustflags. The selected test artifacts are explicitly
fresh:false, copied and hashed before any subsequent clean/source switch.
Actual fingerprint equality is recorded in summary.json. Rust 1.97.1 / LLVM
22.1.6 and std + wgsl + vulkan + noop were used, without trace for these counts.

The current thread's System allocator records requested layouts in fixed TLS
storage. Native driver/libc allocations, usable allocator classes, process RSS,
VRAM and elapsed time are outside this observation. Event/map/copy/byte arrays
are preallocated outside the interval; callbacks use no observation allocation.
One delegated encoder wrapper allocation is charged on both variants. These
are instrumented constructor counts, not overall application memory.

| Native Vulkan constructor | Control | Feature cut |
| --- | ---: | ---: |
| Rust allocation/reallocation calls | 43 | 33 |
| Rust requested bytes | 6159 | 4512 |
| Rust free/reallocation calls | 2 | 1 |
| Rust freed requested bytes | 468 | 128 |
| New Rust bytes live at return | 5691 | 4384 |
| Freed preexisting bytes / observer overflow | 0 / 0 | 0 / 0 |
| Device bytes | 1104 | 1104 |
| HAL buffers acquired during constructor | 3 | 1 |
| Default-param staging copies | 1 | 0 |

Noop gives 33 to 23 allocations, 1052709 to 1051152 requested bytes, and
528005 to 526864 retained new bytes. Its large zero-buffer CPU backing remains
charged on both variants. The native environment pins Mesa's lvp ICD; this is
software Vulkan, not a hardware-GPU measurement. Native HAL buffer requests are
208 bytes each; native allocation placement and size are not measured.

The same feature-enabled noop path uploads exactly 208 bytes once, to the exact
retained default uniform. Matrix, transform, transfer-function, dimensions,
plane-count and padding values are checked. It creates a bind group from a
returned pipeline layout after the last Queue owner has been dropped, without
new buffers or initialization. Successful device/resource disposal balances all
tracked explicit HAL handle identities; native encoders retain their own Drop.

## Failure limits

The feature-disabled branch skips faults targeted at default uniform creation,
staging creation and staging mapping, including injected Rust unwinds, on both
noop and real Vulkan. Enabled Lost and OOM errors retain their old request-device
error variants and point of failure. The baseline and candidate both retain
three raw HAL handles when default allocation fails before Device ownership,
and one staging raw handle when its mapping fails. Staging allocation failure
balances all acquired handles. These are inherited cleanup defects, explicitly
asserted and recorded as limits rather than successful cleanup claims. This
patch does not expand into generic constructor/staging ownership repair.

A rejected harness attempt expected late OOM to return Lost; the existing
handler invalidates Device and returns OutOfMemory. That oracle was corrected.
An unsourced manual binary invocation lacked the Vulkan loader/ICD environment;
its failed adapter-discovery run is also retained. Neither failed attempt is
included in the matched constructor table.

## Qualification and reproduction

The private module is injected only while compiling the standalone Core test
unit, then restored together with its original Cargo.lock in finally cleanup.
The frozen executable runs after restoration. The probe delegates to actual
noop/Vulkan resources and intercepts the existing dynamic interfaces; it does
not replace Core ownership with a mirror implementation. Upload bytes are read
while the staging mapping remains valid, before the delegated unmap. The uniform
is never mapped with unsupported usage.

```sh
source /tmp/gpui-native-env.sh
unset RUSTFLAGS CARGO_ENCODED_RUSTFLAGS
python3 reactivity/evidence/external-params/qualify.py --baseline --counts
python3 reactivity/evidence/external-params/qualify.py --counts
python3 reactivity/evidence/external-params/qualify.py
```

The script refuses to overwrite an existing result directory. It uses jobs 1
and its own target directory. Baseline extraction is pinned to the control
commit and carries the identical private observer; only the old field accessor
and old expected constructor counts differ. Existing original lockfiles are
restored. Product source remains free of test hooks and generated delegation.
The complete Core test unit passes 71 tests, including the six focused tests.
First-party gpui_gpu passes 10 library and 46 Vulkan render tests with offline
shaders enabled, and strict Clippy passes over all gpui_gpu targets with those
features. Core Linux no-default wgsl+noop, wasm WebGL, Apple Metal and MSVC DX12 checks
pass. These are Rust checks; no foreign SDK link or foreign execution is claimed.
Actual fingerprints preserve target flags, including Windows slim errors and
static CRT. Unrestricted strict Clippy reports the same 30 inherited diagnostics
in both variants with identical repository configuration: 26 result_large_err,
2 collapsible_match and 2 enum_variant_names. Scoped deny-warnings passes with
only those categories allowed. The initial /tmp baseline lint run failed to
discover repository clippy.toml and reported 28; it is preserved as a rejected
configuration control, followed by the corrected matched run.

Enabled external-feature execution is tested with delegated noop; native Vulkan
covers feature-disabled construction, ownership and fault skipping. No native
Metal/DX12 external-texture rendering or full trace playback is claimed. No
timing campaign has been run. Shipping integration remains with the parent.
