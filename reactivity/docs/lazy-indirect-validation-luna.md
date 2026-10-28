# Portable graphics cut: defer indirect-validation shader construction

**Recommendation.** Move the existing IndirectValidation owner from eager Device::new construction to a per-device one-time cell initialized when Core first creates a buffer with BufferUsages::INDIRECT. Keep indirect validation enabled exactly under today’s policy and preserve the pipeline-layout flag from that policy. This removes a whole, portable pair of internal WGSL→Naga→HAL shader/pipeline constructions from device creation on devices that never create indirect buffers; it does not disable validation, remove Naga from the package graph, change GPUI’s public API, or add an application platform binding. On devices that use indirect buffers, it moves the same validation machinery to that buffer-creation call.

This is the strongest small structural cut found in the current WGPU stack. The exact source already has a natural first-use point and the public INDIRECT buffer creation path is where buffer-specific validation bind groups must exist. Making the pipelines lazy on first indirect command would require a broader retrofit for buffers already created. The first-indirect-buffer version should be the Sol implementation slice.

## Audit boundary and measured claims

The source pin is /root/gpui-ce3 HEAD 06b15c1835291b40b6bbc426b8a5eee72cc2a35a. The vendored wgpu-core and wgpu-hal are published 30.0.1, upstream commit 40f4a34ebaf56f9a046231f54125ad046239d3f3; see reactivity/vendor/wgpu-core/UPSTREAM.json and reactivity/vendor/wgpu-hal/GPUI-PATCHES.md for published-archive hashes and local patch provenance. This was a bounded source audit only: no builds, measurements, or source changes.

At this pin, first-party reactivity/crates/gpu and reactivity/crates/gpui have no BufferUsages::INDIRECT, draw_indirect, draw_indexed_indirect, or dispatch_workgroups_indirect use. This means the proposed first-use cell stays empty in the current direct-draw compositor. It does not establish a time, RSS, GPU-memory, or cross-device measurement. The structural count is exact in source: when the capability gate is enabled, Core currently builds one validation compute module/pipeline for dispatch and one for draws during device construction.

This gate is commonly active: wgpu-types 30.0.1’s from-build-config defaults include VALIDATION_INDIRECT_CALL for both debug and release; the runtime GPUI instance at native.rs:488 uses the environment-aware constructor, so WGPU_VALIDATION_INDIRECT_CALL can change it. The capability/downlevel/limit checks still decide whether the policy Option exists. Do not describe the work as unconditional on every device.

## Why this is a whole-work cut

reactivity/vendor/wgpu-core/src/device/resource.rs:501-518 enables validation when the instance flag VALIDATION_INDIRECT_CALL is set, the adapter has both INDIRECT_EXECUTION and COMPUTE_SHADERS, and max_storage_buffers_per_shader_stage >= 2. If enabled, IndirectValidation::new is called before the Core Device struct is returned.

That constructor in reactivity/vendor/wgpu-core/src/indirect_validation/mod.rs:26-60 creates Dispatch, then Draw. Each has its own shader module and compute pipeline. dispatch.rs:41-131, 133-225, 227-275 formats WGSL with the device workgroup limit, parses and validates it with Naga, creates a HAL module and pipeline/layouts, and a small destination buffer/group. draw.rs:60-149, 522-577, 580-626 parses/validates the included draw WGSL, creates its HAL module, bind-group layouts, pipeline layout, and compute pipeline. Its buffer pools begin empty; draw/metadata pool buffers are allocated only when a draw-validation pass later needs them (draw.rs:190-240).

For devices without the enabling capability or instance flag, the existing code already skips this work. For enabled direct-only devices, the proposed cell would additionally skip both Naga frontend/validation calls and all of these HAL shader/pipeline/layout creations for the device’s lifetime. It keeps the indirect-validation implementation for future or third-party Core clients.

The lazy seam is already present at resource.rs:1347-1375: create_indirect_validation_bind_groups returns immediately for non-INDIRECT usage, then currently reads the device validator and creates two buffer-specific groups. It is called by both normal buffer creation (resource.rs:1120-1121) and imported-HAL buffer creation (:1309-1315). Initializing the device validator immediately after the usage early-out, before BindGroups::new, covers both routes and guarantees successful indirect buffers have the groups they need.

## Recommended representation and policy split

Use the existing alias in reactivity/vendor/wgpu-core/src/lib.rs:230-233, rather than introducing a new lock or platform binding:

    // Policy enabled means the cell exists. Cell contents mean initialized.
    pub(crate) indirect_validation:
        Option<OnceCellOrLock<Result<Box<IndirectValidation>, DeviceError>>>,

OnceCellOrLock is core::cell::OnceCell without Core’s std feature and std::sync::OnceLock with it. Use get_or_init(|| IndirectValidation::new(...).map(Box::new)); DeviceError is Clone at device/mod.rs:341-350, so callers can return a cloned cached error. A Box is a cold allocation only on the first enabled INDIRECT use and can shrink the always-present Device field compared with inline Option<IndirectValidation>; measure size_of::<Device>() and the actual allocator before selecting it. This avoids a separate per-device owner/header, global cache, per-frame lookup state, or std-only lock. Core already uses the same alias for the late-created timestamp normalizer (resource.rs:277-280, 561-562). The ordinary wasm WebGPU backend does not use this Core path; WebAssembly Core is optional for WebGL and unconditional for Emscripten in wgpu/Cargo.toml.orig:247-272. The alias remains the right cfg boundary for those Core builds. Do not add std::sync directly or make an assumption about wasm atomics.

The outer Option must continue to encode the enabled policy, separate from cell initialization. In particular, resource.rs:3954-3965 adds INDIRECT_BUILTIN_UPDATE to pipeline layouts when validation policy is enabled. Keep this true before the cell is initialized: some application pipeline layouts are created before the first indirect buffer. The same policy check appears in command/bundle/render indirect paths (for example command/bundle.rs:1178,1464, command/render.rs:3308); preserve behavior. Runtime code that actually dereferences validation machinery should use the initialized cell after the invariant that an indirect buffer was successfully created.

The affected Core callsite map is:

- Policy is computed and the current eager constructor is called in device/resource.rs:501-518; the field is declared at :276 and Device::drop disposes it at :321-323.
- Normal and imported-HAL buffers both pass through create_indirect_validation_bind_groups at :1120-1121 and :1309-1315. The helper’s non-INDIRECT bypass is :1354-1356; put initialization immediately after it.
- Pipeline-layout policy is read at :3954-3965. Preserve it based on the outer Option, never on whether the cell has initialized.
- Actual compute-indirect dispatch reads Dispatch at command/compute.rs:1081-1129. Render-pass draw validation checks the validator at command/render.rs:2750-2761; indirect render draws gather validation resources at :3308-3316. Bundle paths gate indirect-buffer use at command/bundle.rs:1178,1464 and use DrawResources/DrawBatcher at :1301-1302.
- Command-buffer owners are initialized with DrawResources at command/mod.rs:831,861,940. The owner itself is defined and drops pooled entries at indirect_validation/draw.rs:780-804.
- The Core Global trace records a successful public CreateBuffer after Device buffer creation at device/global.rs:145-181.

There is a different eager internal object not covered by this slice: device/resource.rs:483-494 creates default_external_texture_params_buffer, late_init_resources_with_queue writes it at :646-659, and external-texture binding uses it at :3386-3392. It has a queue/pending-write lifecycle and should get its own trigger/error audit; do not bundle it into indirect-validation initialization. zero_buffer, empty_bgl, and timestamp-normalizer initialization likewise serve separate paths.

Suggested flow:

1. Leave the capability test in Device construction, but store Some(OnceCellOrLock::new()) rather than constructing IndirectValidation; otherwise store None.
2. In create_indirect_validation_bind_groups, first keep the existing non-INDIRECT early return. If the policy cell is Some, call its initializer with the exact existing constructor parameters, then create this buffer’s BindGroups.
3. Preserve the Core error if lazy validation setup fails; never return empty groups or let an indirect buffer proceed unvalidated.
4. In dispatch/draw execution, read the ready Ok(IndirectValidation) from the cell. Reaching those paths with no initialized validator is an invariant violation worth a clear checked error/assert in the Core layer, not a silent fallback.
5. In Device::drop, inspect the cell without initializing it; dispose only a successful value. Do not initialize during close.

Caching the Result means a construction error is sticky for that device and is not retried on every attempted indirect buffer. This matches the once-per-device construction intent and avoids repeated Naga/driver work, but changes where a formerly device-request-fatal error appears: it now invalidates the first indirect buffer and is returned through the existing buffer error path. The current IndirectValidation::new deliberately logs and maps any Dispatch/Draw creation failure to DeviceError::Lost; keep that fail-closed contract for the first slice. Transient-OOM retry would require a different cross-cfg synchronization state/API; do not quietly retry or ignore errors without an explicit follow-up design.

The boxed cold-owner form is preferred for the first size comparison: current inline Option<IndirectValidation> versus Option<OnceCellOrLock<Result<Box<IndirectValidation>, DeviceError>>>. The Option/OnceCell field remains in every enabled Device, but only users that actually create an INDIRECT buffer allocate the Box. Verify the net Device-size change and actual constructor requested/retained bytes; do not count the Box as a free win. Ensure Device::drop consumes and disposes the boxed validator exactly once. The desired narrow design still has one policy Option and no separate DrawResources owner/header.

## Mandatory failure and lifetime work

**Fix partial-construction cleanup before making this recoverable.** Completed Dispatch and Draw owners have explicit dispose(device) methods (dispatch.rs:350-370, draw.rs:~480-519), and Core explicitly invokes them on successful Device drop (resource.rs:321-323). HAL dynamic resources also have explicit destroy_* operations (wgpu-hal/src/dynamic/device.rs:20-26,64-93); dropping their boxed trait objects is not the native destroy call. Today a partial Dispatch::new/Draw::new error unwinds local boxes, and IndirectValidation::new can finish Dispatch then fail Draw. At eager device construction, the surrounding failed Device request tears down its raw device. After moving this to a live Device’s buffer call, that raw device remains alive, so simply reusing the ? paths can leak already-created native HAL objects.

Use a staged builder/guard that records each successfully created object and destroys in dependency-safe reverse order on every returned error and Rust unwind; transfer the completed objects into Dispatch/Draw only at commit. Audit both helpers independently and the Dispatch-success/Draw-failure case. Do not claim C-driver longjmp/panic safety; HAL APIs return errors across Rust calls. Also audit the user buffer already created before create_indirect_validation_bind_groups at resource.rs:1103-1121: a newly earlier failure can leave that local HAL buffer unowned. On the normal path, explicitly destroy it on failure before returning; on create_buffer_from_hal, honor its transferred-handle ownership and destroy/return ownership consistently. The latter is an existing explicit error edge and deserves a regression. If buffer group creation fails after validator success, destroy any first group created before the second failed, as BindGroups::new currently uses ? after the first allocation (indirect_validation/mod.rs:65-88).

Other ownership cases:

- **Concurrent buffer creation:** OnceLock::get_or_init/Core OnceCell allows one initializer; callers then create their own per-buffer groups. Test simultaneous first indirect buffers and verify one validator owner, no duplicate leaked modules/pipelines, and distinct groups. The initializer makes direct HAL calls, not recursive Core buffer calls. Keep pipeline cache None; no external/shared cache synchronization claim is implied.
- **Repeated use:** validator pipelines persist once per Core Device and are reused for subsequent indirect buffers/commands. Existing draw metadata/destination pools remain unchanged and are returned by DrawResources; this proposal adds no new pool.
- **DrawResources:** draw.rs:780-804 always creates a command-buffer DrawResources with an Arc<Device> and empty Vecs. Existing per-command buffer Vecs do not allocate while empty. Its Drop (draw.rs:787-794) returns nonempty entries to the validator. With a cell, it must use get(): uninitialized means the vectors are empty and nothing needs release; successful means return entries; a cached error cannot own entries. Its Arc keeps Device alive until resource return, so Device Drop runs afterward.
- **Device and Buffer Drop:** Device Drop must dispose only an initialized successful validator before destroying raw device resources. Buffer Drop continues to own/dispose per-buffer validation groups with the same validator policy. A buffer holding an Arc<Device> already prevents premature Device teardown.
- **Trace/replay:** device/global.rs:145-181 records a public CreateBuffer only after Core buffer creation succeeds. Internal validation modules/pipelines are not separate public trace actions. Replaying a successful trace containing an indirect buffer will therefore hit the same first-INDIRECT initialization path; failed attempts are not recorded as successful buffer creation. No trace schema or replay-only shader ownership should be added. Verify an indirect trace/replay case and a direct-only trace.

There is an error-timing change to test with error scopes. If lazy validator construction propagates with the existing From<DeviceError> conversion, the first indirect buffer returns CreateBufferError::Device(DeviceError::Lost); per-buffer bind-group errors keep the existing CreateBufferError::IndirectValidationBindGroup wrapper (resource.rs:1133-1153). Do not conflate those causes. The invalid buffer remains contagious through normal Core resource assignment (device/global.rs:145-181). Neither missing setup nor driver failure may be converted into an empty group. The existing indirect Core constructor’s errors are device-lost by design, so this reports that failure policy at the first point it is needed.

## Cross-platform scope and non-goals

This cell sits above HAL, so it removes the same unreachable initialization path across Core-backed Vulkan, Metal, DX12, and GLES clients while leaving each backend’s actual indirect validation intact.

- Vulkan: defer the WGSL→Naga→SPIR-V path and internal compute-pipeline creation. No change to the separate app static-SPIR-V recipe or Vulkan shader-module lifetime.
- Metal: defer Naga translation and driver library/function/pipeline work for these internal modules.
- DX12: defer Naga HLSL/DXIL and compute PSO work. WGPU 30.0.1’s backend is D3D12; this is not a DX11 or DX9 implementation.
- GLES: defer Naga GLSL and driver shader compile/link/pipeline work.
- Browser WebGPU: not this Core path; it has its own backend. Do not suggest adding browser platform code for this cut.

The normal default WGSL compositor and checked shader path are unchanged. This does not establish that the standalone runtime Naga dependency can be removed. Core’s internal validator shaders are part of why wgpu enables Core’s wgsl feature on native targets (wgpu/Cargo.toml.orig:233-240); removing that feature requires a different validated internal-shader path. wgpu-core and wgpu-hal still depend on Naga for the wider WGSL/profile/backend surface. The app’s optional offline shader artifacts are a separate, already documented candidate: reactivity/evidence/static-shader/README.md and consumer-build-proposal.md pin the Vulkan-only static SPIR-V source at a871fc6fa924f31bf08fe2a51248930025582da1 and explicitly state that host WGSL validation and runtime Naga fallback remain. That candidate must not be presented as a portable universal shader blob.

A later backend-specific artifact slice could consider borrowed immutable DXIL to remove the current DX12 HAL’s byte clones, with ABI/profile admission and exact device shader-model requirements. That is not necessary for this portable eager-work cut. Keep any later artifacts behind WGPU/HAL-owned types, retain checked WGSL fallback, and never infer target support from an artifact file existing. No DX11 claim follows from Microsoft’s HLSL shader-model documentation.

## Smallest Sol slice and required evidence

The code slice should touch only Core device policy/state, its lazy initializer and error cleanup, indirect-buffer setup, the execution lookups, and focused Core tests. Do not change GPUI or introduce app-side backend switches. Keep the outer policy Option so no added per-device owner is needed when the capability is disabled; avoid introducing a separate DrawResources cell/header.

Before adoption, tests should exercise:

1. Enabled-policy Device creation with zero calls to internal shader creation/pipeline creation, then first INDIRECT buffer creates exactly one dispatch+draw validator set; further INDIRECT buffers reuse it.
2. Non-INDIRECT buffers never initialize it. Disabled flag/downlevel/limit policy never initializes it, preserves current unvalidated-disabled behavior, and keeps pipeline layout flags false.
3. Enabled policy keeps INDIRECT_BUILTIN_UPDATE on layouts created before lazy initialization.
4. Concurrent first buffer requests produce one initialized validator and separate buffer bind groups.
5. Fault injection at every shader, BGL, pipeline-layout, pipeline, internal buffer, bind-group and user-buffer stage destroys each successfully created HAL handle exactly once; retry/error-cache policy is explicit. Include a Rust unwind after acquisition using the local guard if the harness permits it.
6. First create-buffer failure reports the chosen DeviceLost error shape in the expected error scope and does not publish/trace a valid buffer. A later cached failure behaves deterministically. Verify imported-HAL buffer ownership on failure.
7. Device drop before initialization does not invoke init. Drop after success disposes validator modules/pipelines/layouts/buffers/groups once. Drop after cached error does not invoke cleanup on absent resources. A live DrawResources keeps Device alive and returns any pool entries before final disposal.
8. Direct-only trace/replay does not initialize; indirect-buffer trace/replay initializes when replaying that buffer, with no new trace action.

Do not claim a speedup from the structural deletion. The necessary reportable results are actual Core allocator call counts/bytes and native create/destroy counts for a matched enabled direct-only Device, then for the first and repeated INDIRECT buffers, on at least one backend. For portability, compile/test the no-std alias configuration and wasm Core configurations available in the project; source inspection alone does not establish those target gates.

### Primary-source links

- WGPU Core 30.0.1 published crate and upstream pin: [crates.io source archive](https://static.crates.io/crates/wgpu-core/wgpu-core-30.0.1.crate); [upstream repository at the recorded commit](https://github.com/gfx-rs/wgpu/tree/40f4a34ebaf56f9a046231f54125ad046239d3f3/wgpu-core).
- WGPU HAL 30.0.1 at the same upstream commit: [published archive](https://static.crates.io/crates/wgpu-hal/wgpu-hal-30.0.1.crate); [upstream HAL source](https://github.com/gfx-rs/wgpu/tree/40f4a34ebaf56f9a046231f54125ad046239d3f3/wgpu-hal).
- WGPU 30.0.1 instance flags and Core feature wiring: [versioned wgpu-types source](https://docs.rs/wgpu-types/30.0.1/src/wgpu_types/instance.rs.html); [versioned wgpu manifest](https://docs.rs/crate/wgpu/30.0.1/source/Cargo.toml.orig).
- Vulkan module and pipeline ownership rules: [Vulkan shader-module guide](https://docs.vulkan.org/guide/latest/ways_to_provide_spirv.html); [vkDestroyShaderModule reference](https://docs.vulkan.org/refpages/latest/refpages/source/vkDestroyShaderModule.html).
- Metal precompiled library input: [Apple makeLibrary(data:)](https://developer.apple.com/documentation/metal/mtldevice/makelibrary%28data%3A%29); that API is a backend-specific library route, not a portable WGPU artifact format.
- D3D12 consumes DXIL/DXBC bytecode through pointer/length descriptors: [D3D12_SHADER_BYTECODE](https://learn.microsoft.com/en-us/windows/win32/api/d3d12/ns-d3d12-d3d12_shader_bytecode); [shader-model availability](https://learn.microsoft.com/en-us/windows/win32/direct3dhlsl/dx-graphics-hlsl-models).
- Desktop OpenGL SPIR-V is not a GLES portability path: [ARB_gl_spirv](https://registry.khronos.org/OpenGL/extensions/ARB/ARB_gl_spirv.txt). WGPU’s current GLES shader route is GLSL, as pinned in wgpu-hal/src/gles/device.rs.

These external references explain the native APIs. The recommendation and all callsite/lifetime conclusions above come from the exact local vendor source at the stated root commit, not from assuming a backend or extension is enabled.

