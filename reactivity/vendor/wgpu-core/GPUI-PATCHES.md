# Static SPIR-V source provenance

The complete published wgpu-core 30.0.1 archive is imported unchanged in
`c27929d153`. UPSTREAM.json records the registry archive checksum, upstream VCS
revision and a SHA-256 for every published file. Both licenses and normalized and
original manifests/lock are retained. Subsequent authored changes are separate
from those upstream bytes.

The optional `shader-artifacts` feature propagates to HAL. Its hidden unsafe
Global static entry point accepts `&'static [u32]` directly, constructs the normal
borrowed passthrough descriptor for tracing, and passes static provenance only to
private common resource construction. Ordinary borrowed/owned Cow SPIR-V is never
promoted to static. Common checks reject destroyed devices, missing enabled
PASSTHROUGH_SHADERS and non-Vulkan static input before HAL. Existing registry,
error handling, metadata and Arc leases remain shared. No driver error is turned
into an admission miss or a successful checked-WGSL retry.

Tracing, when enabled and active, serializes the exact static SPIR-V through the
existing passthrough action. That optional observation can copy bytes and allocate
trace records; normal runtime does neither for the source. Replay uses the existing
ordinary Raw passthrough path, preserving shader behavior but not this static
source ownership optimization. Core's module Arc stores HAL's static recipe;
render/compute pipeline leases retain it exactly as they retained Raw before.
This pinned Core exposes no ray pipeline construction; HAL's separate ray path
is audited as synchronous with a null deferred operation.
No descriptor or non-static source borrow is retained.

Vendoring makes an upstream `expect(unused)` on MutexGuard::saved visible to the
workspace compiler's unfulfilled_lint_expectations warning (registry dependencies
were lint-capped). It becomes `allow(unused)` without changing the field, Drop,
locking or runtime behavior. This one-line compiler compatibility delta is charged.

# Lazy indirect validation

The existing enabled-policy Option now contains the existing cross-platform
OnceCellOrLock alias and a cached Result<Box<IndirectValidation>, DeviceError>.
Device construction records policy without constructing the internal dispatch or
draw validation shaders/pipelines. The first normal or imported INDIRECT buffer
initializes them; successful buffers still require their validation groups.
Pipeline-layout INDIRECT_BUILTIN_UPDATE remains keyed to policy before first use.
Execution reads only initialized state, and Device/DrawResources destruction never
initializes it. This keeps Naga and all backend validation paths available.

Initialization failure moves from device request to first INDIRECT buffer creation.
The existing constructor's Lost mapping is retained, cached, and delivered through
the live device's loss callback after the cell initializer has returned. The loss
callback runs after its mutex is released, allowing user reentry. A lost per-buffer
group allocation also delivers device loss while retaining its existing buffer
error wrapper; per-buffer OOM remains recoverable.

A stack-only Pending guard explicitly destroys unpublished HAL acquisitions in
reverse dependency order on error or Rust unwind. It covers both constructors,
Dispatch-success/Draw-failure, the first of two source groups, draw pool buffers,
and normal/imported user buffers plus preceding timestamp groups. Import takes
ownership by value; its HAL accounting is entered before fallible setup so failure
can destroy the transferred wrapper exactly once. Backend ownership semantics
remain in HAL. Qualification, baseline counts, and scope limits are recorded
separately in reactivity/evidence/lazy-indirect.
