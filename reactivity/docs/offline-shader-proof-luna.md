# Vulkan-first offline shader proof

Read-only research, 2026-10-22. Audited repository snapshot: 8ea8b9d76abb76717bd84fc28a5d471ce69f5ed3. No production files were changed and no build, test, timing, or GPU run was performed.

Implementation disposition: keep all platform-specific artifact admission and
effective-device queries inside the vendored WGPU/HAL boundary. The application
renderer may consume a sealed backend-neutral admission result; it must not grow
OS/vendor dispatch or treat advertised adapter features as enabled device
guarantees. The all-Restrict profile below is an experimental control; matching
the existing hot-path guards remains a separate acceptance obligation. Neither
this report nor build-time WGSL generation implements raw artifact admission.

## Finding

A Vulkan-only raw SPIR-V path is technically feasible for this single typed-WGSL shader. It can remove runtime WGSL parsing, Naga validation/reflection, and Naga-to-SPIR-V writing, and it can avoid retaining the full reflected WGPU interface. It cannot remove Vulkan shader-module creation or driver render-pipeline compilation. The existing renderer also creates the device separately; this path does not reduce request_device work.

The safe admission boundary is narrow: generate the artifact from the exact build-time output of the typed WGSL source, validate it offline, give WGPU an explicit pipeline layout, and call passthrough only for a Vulkan Device that has PASSTHROUGH_SHADERS enabled and whose artifact manifest/profile matches. Every other backend/device uses the existing checked WGSL path. A build-time or pre-call admission failure selects WGSL. A runtime WGPU validation, driver, or device error must be reported to the caller; silently retrying WGSL after such an error would hide a shader/device failure.

The main performance caveat is now source-proven: WGPU 30's Vulkan HAL selects Naga buffer=Unchecked only when robust_buffer_access2 is enabled, and image_load=Unchecked when effective robust_image_access is enabled. Otherwise it uses Restrict. index is always Restrict. A fixed all-Restrict artifact is a portable candidate, but can add bounds-check code on devices where the current checked-WGSL path delegates those categories to hardware. Vulkan's robustness guide explicitly warns robustness can cost runtime performance. Do not claim the fixed artifact is byte-equivalent or free of GPU cost. See the [pinned WGPU 30.0.1 Vulkan policy](https://github.com/gfx-rs/wgpu/blob/v30.0.1/wgpu-hal/src/vulkan/adapter.rs#L2645-L2867), local [HAL policy](/root/gpui-ce3/reactivity/vendor/wgpu-hal/src/vulkan/adapter.rs:2838), and the [Vulkan robustness guide](https://docs.vulkan.org/guide/latest/robustness.html).

## Exact shader interface

The typed source declares one group, six scalar bindings, and two graphics entry points. The local source is [shader.rs](/root/gpui-ce3/reactivity/crates/gpu/src/shader.rs:8); renderer-side resource creation is [renderer.rs](/root/gpui-ce3/reactivity/crates/gpu/src/renderer.rs:356).

| API group/binding | WGSL declaration | Explicit WGPU layout, fragment visibility | minimum binding size | Vulkan set/binding when entries are emitted in ascending order |
|---|---|---|---:|---|
| 0/0 | uniform Globals: viewport vec4<u32>, clear vec4<f32>, mapping vec4<f32> | Uniform buffer; no dynamic offset | 48 bytes | 0/0 |
| 0/1 | storage runtime array of vec4<u32>, WORDS | Read-only storage buffer | 16 bytes | 0/1 |
| 0/2 | storage runtime array of vec2<u32>, TILES | Read-only storage buffer | 8 bytes | 0/2 |
| 0/3 | storage runtime array of u32, INDICES | Read-only storage buffer | 4 bytes | 0/3 |
| 0/4 | texture_2d<f32>, MASKS | D2 float texture, filterable=false, multisampled=false | not applicable | 0/4 |
| 0/5 | storage runtime array of Correction { x: vec4<f32>, y: vec4<f32> }, CORRECTIONS | Read-only storage buffer | 32 bytes | 0/5 |

The dynamic-array minimums follow Naga 30's type sizing rule: a dynamically-sized array has at least one element for pipeline-time footprint calculation; the element strides here are 16, 8, 4, and 32 bytes. [Pinned Naga type sizing](https://github.com/gfx-rs/wgpu/blob/v30.0.1/naga/src/proc/type_methods.rs#L246-L300) and [WGPU auto-layout derivation](https://github.com/gfx-rs/wgpu/blob/v30.0.1/wgpu-core/src/validation.rs#L780-L827) establish these values. MASKS is only loaded with textureLoad at mip 0; there is no sampler, so the inferred float texture is non-filterable. The backing atlas is R8Unorm and D2. WGPU's existing test already asserts the host DrawData/Globals/Correction sizes and offsets and checks the shader has four storage bindings: [renderer ABI test](/root/gpui-ce3/reactivity/crates/gpu/src/renderer.rs:1245).

Use one explicit BindGroupLayout with entries 0 through 5 in increasing order, fragment visibility, no binding arrays, and the types/minimums above; then one PipelineLayout with that sole layout in group 0 and no push constants. Both vertex and fragment are in the same SPIR-V module. The vertex stage reads no resource; its only array access is POINTS[vertex_index], and current draw is 0..3. The pipeline entry-point names are exactly vertex and fragment. There are no samplers or storage images.

HAL does not preserve arbitrary API binding numbers as the physical Vulkan numbers: it iterates layout entries, assigns dense native binding numbers, and records an API-to-native map. Pipeline layout then emits descriptor_set equal to the group index and the mapped binding. With this exact ascending contiguous API list the map is identity, giving set 0/binding 0..5; emit entries in this order and assert SPIR-V decorations and generated reflection against that layout. See [pinned HAL descriptor mapping](https://github.com/gfx-rs/wgpu/blob/v30.0.1/wgpu-hal/src/vulkan/device.rs#L1411-L1452) and [pipeline binding-map construction](https://github.com/gfx-rs/wgpu/blob/v30.0.1/wgpu-hal/src/vulkan/device.rs#L1617-L1645).

With DeviceDescriptor defaults, this interface uses one uniform, four storage buffers, and one sampled texture in the fragment stage, below WGPU's baseline per-stage counts. The largest ordinary GPU buffers are also source-capped: up to 4 Mi references = 16 MiB of indices; at most about 1.05 Mi grid cells = 8 MiB of tile ranges; draw/correction records fit the renderer's fixed caps; image payload and its draw prefix are checked against the device's max storage binding and buffer sizes. The exact generated BGL remains a runtime-validated WGPU object, but passthrough does not reflect the SPIR-V and therefore cannot cross-check the shader's descriptors against it.

## Reproducible artifact profile

The generator must consume exactly the output of wgsl-rs from the current typed source, the same source that build.rs writes as ui.wgsl. Do not hand-maintain a second shader or manually write SPIR-V. Pin the generator to Naga 30.0.1, matching WGPU, and make its options explicit rather than inheriting Naga defaults.

A conservative first artifact can use this fixed profile:

| Naga SPIR-V option | Set to | Reason |
|---|---|---|
| target version | SPIR-V 1.0; validate with Vulkan 1.0 target environment | Lowest Vulkan core target; no optional extension/capability is needed by the present shader, subject to generator validation |
| capabilities | explicit WGPU Vulkan core baseline only: Shader, Matrix, Sampled1D, Image1D, ImageQuery, DerivativeControl, StorageImageExtendedFormats | Same baseline list WGPU 30 Vulkan HAL begins with; generator must fail if emitted code needs anything outside the selected set |
| writer flags | empty plus FORCE_POINT_SIZE; do not set ADJUST_COORDINATE_SPACE | WGPU HAL does not set Y adjustment for its SPIR-V writer; Vulkan HAL flips viewport height. Naga's own default does set Y adjustment and would risk a double flip. This shader has no varying or fragment-depth interface |
| index policy | Restrict | Matches WGPU Vulkan for local array/vector/matrix indices |
| buffer policy | Restrict | Safe on every Vulkan adapter; does not assume robustness |
| image_load policy | Restrict | Safe on every Vulkan adapter; does not assume robustness |
| binding-array policy | Unchecked | Shader has no binding arrays; retain this only with a reflection assertion |
| force_loop_bounding | true | The source contains intentionally non-literal tile-reference loops |
| emit_int_div_checks | true | Match WGPU's defined WGSL division behavior |
| fake_missing_bindings | false | Missing resource bindings must fail generation |
| binding_map | explicit identity map for group 0, bindings 0..5 | No inferred/fake physical descriptors |
| workgroup-zero initialization | same deterministic mode as WGPU or Polyfill | No workgroup variables exist, so the choice must be inert; assert this fact |

WGPU 30's Vulkan options choose a SPIR-V version from the Vulkan API version, set a constrained capability list, and use the robustness policy described above. A conservative SPIR-V 1.0 artifact intentionally targets lower than the newer variants WGPU may emit; that is a portability choice, not byte-equivalence. The same HAL emits FORCE_POINT_SIZE and selects LABEL_VARYINGS based on Qualcomm, while starting with no coordinate-adjustment flag; this shader has no varyings, so the vendor label choice is inert. The Vulkan HAL's negative viewport-height convention is visible in [command.rs](/root/gpui-ce3/reactivity/vendor/wgpu-hal/src/vulkan/command.rs:859). Naga writer options/defaults are [pinned here](https://github.com/gfx-rs/wgpu/blob/v30.0.1/naga/src/back/spv/mod.rs#L995-L1150); bounds-policy semantics are [pinned here](https://github.com/gfx-rs/wgpu/blob/v30.0.1/naga/src/proc/index.rs#L35-L145). In particular, Restrict maps an invalid index to an arbitrary in-bounds index; it is not defined as clamp-to-zero. For valid renderer-produced packets, all these paths should be in bounds. Do not claim identical behavior on corrupted packet contents.

For each generated profile, CI should:

1. Generate WGSL from the typed source and verify it equals the existing generated shader bytes.
2. Parse and validate WGSL with Naga 30.0.1 under WGPU-equivalent validation flags and the baseline feature/limit contract.
3. Run Naga's SPIR-V writer with every option fixed as above; assert the module has exactly the two expected entry points, both expected stages, only group 0 bindings 0..5, descriptor decorations matching the generated BGL manifest, no optional SPIR-V capabilities, and no storage writes or resource classes absent from the typed source.
4. Parse the output back with Naga's strict SPIR-V frontend and validate it; run a pinned Khronos SPIRV-Tools spirv-val with --target-env vulkan1.0. SPIRV-Tools itself states its validator is incomplete/one-sided: passing it is a legality check, not proof of host indexing, WGPU layout agreement, driver acceptance, or pixel parity. [Khronos SPIRV-Tools v2026.0 README](https://github.com/KhronosGroup/SPIRV-Tools/blob/v2026.0/README.md) and [validator CLI source](https://github.com/KhronosGroup/SPIRV-Tools/blob/v2026.0/tools/val/val.cpp).
5. Emit a manifest with typed-WGSL hash, Naga version, target environment, writer options, entry point/interface list, binding-layout hash, and artifact hash. Do not run spirv-opt unless its exact version/pass list is pinned and all validation and render gates are rerun.

SPIR-V 1.0 is a Vulkan-only artifact. The ordinary WGPU ShaderSource::SpirV path is not a shortcut: WGPU parses that input with Naga's SPIR-V frontend, validates it, reflects it, and gives Naga IR to HAL. Only create_shader_module_passthrough bypasses those steps. The current gpui_gpu Cargo.toml does not enable WGPU's spirv frontend feature, and enabling it would add a runtime parser without solving the elimination goal. The WGPU core source shows both routes and that passthrough stores entry-point names but no reflected resource interface: [pinned normal and passthrough paths](https://github.com/gfx-rs/wgpu/blob/v30.0.1/wgpu-core/src/device/resource.rs#L2363-L2595). The public passthrough method is unsafe and requires PASSTHROUGH_SHADERS: [pinned Device API](https://github.com/gfx-rs/wgpu/blob/v30.0.1/wgpu/src/api/device.rs#L190-L205), [feature contract](https://github.com/gfx-rs/wgpu/blob/v30.0.1/wgpu-types/src/features.rs#L1345-L1360). The convenience include_spirv_raw! macro hardcodes one entry name, main, so this two-entry-point graphics module needs a manually built ShaderModuleDescriptorPassthrough.

## Robustness tiers: the safe route past added guards

There are two valid artifact formulations:

**Strict single artifact.** Use the all-Restrict profile above and fall back to checked WGSL where passthrough is unavailable. This is the smallest vendor change and does not rely on an adapter robustness guarantee. It can add resource-index guards to the hot fragment path on adapters where WGPU's ordinary Vulkan path uses hardware robustness. Keep it experimental until the GPU gate passes.

**Per-device effective-policy artifacts.** Generate four artifacts for the combinations of buffer and image-load policy, with index always Restrict and loops/division checked. At runtime select the variant only from the effective policy enabled on the exact WGPU Device. This mirrors WGPU 30's Vulkan policy and should avoid extra Naga buffer/image guards when HAL already selects Unchecked. It is safer and more portable than app checks on vendor IDs, OS, raw Vulkan extension names, or merely supported-adapter features. Do not infer this profile from PASSTHROUGH_SHADERS: that feature only authorizes the raw shader API.

WGPU currently exposes no public Device property for the private robustness choice. HAL's Vulkan private capability is authoritative: device creation enables robustness2/image-robustness with those booleans, then the Naga options select Unchecked from them. The smallest backend-neutral vendor seam is a Device query like ShaderAccessRobustness { storage_buffer_access: bool, image_load_access: bool }, populated from the actual enabled codegen policy at Device creation. Other HALs return false/unsupported. App code then asks the WGPU Device for the effective policy; it does not inspect OS or vendor identity. A more generic design would expose the exact Naga bounds policy profile, but that would make a low-level translator detail part of WGPU's public API. The two booleans are sufficient for this six-binding shader.

This profile query must mean what WGPU code generation used, not what the physical adapter advertised as supported. It cannot promise the same OOB result as Restrict: Vulkan robust image loads return zero when out of range, while Restrict chooses an arbitrary valid index; robustness2 buffer size alignment can also define an aligned checked range. Thus use the unchecked-category artifact only when that exact effective profile is reported, preserve valid-packet host bounds, and retain the checked WGSL fallback. Vulkan's [robust buffer/image feature specification](https://docs.vulkan.org/spec/latest/chapters/shaders.html) and [robustness2 feature structure](https://docs.vulkan.org/refpages/latest/refpages/source/VkPhysicalDeviceRobustness2FeaturesKHR.html) show why support and enabled guarantees are distinct.

The per-device policy version also belongs in the artifact manifest. If WGPU changes policy or stops enabling a guarantee, the old profile is rejected before the unsafe call and ordinary WGSL is selected. The first Sol experiment should not add an application API that lets callers claim a robustness bit.

## Host index and loop proof ledger

The shader contains real dynamic indexing: WORDS in draw/image decoders, TILES per fragment, INDICES inside per-tile loops, CORRECTIONS for transform residuals, local vector and POINTS array indexing, and a textureLoad from MASKS. The two non-literal loops iterate range.x..range.y. Naga's forced loop bounding only ensures generated loops are bounded; it does not prove the host range is within INDICES. The packet proof still belongs to CPU admission.

| Shader resource/index family | Existing host bound in source | Remaining contract to carry into artifact tests |
|---|---|---|
| WORDS draw/group records | MAX_DRAWS=65,536; inline draws use six vec4 words; compact groups use five common plus two per placement, with 5+2n <= 6n for n>=2; paint bank is capped at 2*MAX_DRAWS. Static assertions keep record/bank address lanes below the high-bit tag. Image payload is capped at 64 MiB; image starts, cumulative word counts, and required GPU buffer size are checked in renderer/images.rs. | Verify packed tags, common offsets, color-bank prefix and appended image base in a generated ABI test; the decoder trusts private host-produced addresses and has no packet pre-scan. The existing code's word_count+bank_words reserve expression is unchecked, but current MAX_DRAWS/bank constants and static slot assertion keep it below roughly 526K words. Preserve those caps or make the addition checked when changing them. |
| TILES | Renderer rejects zero or >16,384 dimensions and >16 Mi pixels; columns and rows are ceil(dim/16), each <=1,024, so tile count <=1,048,576. Target dimensions must equal the scene. Vulkan's negative viewport height preserves WGPU's fragment position convention. | Test all four target edges and partial final tiles; prove viewport.z equals columns and target is the expected full view. Bounds-checking guards against an invalid tile index but does not prove the tile formula matches the allocated ranges. |
| INDICES and tile loops | bin_draw checked-adds each draw's intersected tile count and caps cumulative references at 4 Mi; ranges and reverse-built references are private; total cursor values therefore fit u32 and reference positions fit the allocated array. | Add adversarial tests for empty, one-reference/uniform sentinel, maximum cursor, banked and ordinary packets, ordering, and packed draw addresses. Preserve the private-constructor boundary. The shader comment that CSR is bounded is a statement of this host invariant, not an independent shader proof. |
| CORRECTIONS | Host starts with element zero and deduplicates inverse/clip residuals; one correction index is attached to a group/placement. Group count is bounded by admitted draws. | Make the implicit correction_count <= draw_count+1 relation a generated assertion and exercise every correction read including clip-equality paths. |
| MASKS and textureLoad | Atlas starts at 1x1, grows only to MAX_ATLAS_SIDE=2,048, is R8Unorm D2; atlas packing provides x/y/width/height and glyph cells clamp to the mask dimensions before atlas offset. | Assert every packed rectangle lies within atlas dimensions and exercise 1x1, growth/repack, border texels, and max side. This is the only sampled image descriptor; image assets themselves are packed into WORDS. |
| local indexing / POINTS | index policy remains Restrict; vertex draw range is exactly 0..3 and POINTS has three entries. Packed RGBA selection uses index&3, always 0..3. | Keep the vertex range and vector-lane tests coupled to shader hash. No host resource guarantee replaces local-index guards. |
| Affine and image domains | Canvas constructors validate finite nonnegative rectangles and clips, skip empty rectangles, and create prepared geometry privately. GPU validate_draw checks bounds against target, narrows the inverse to finite f32, rejects singular matrices, caps arithmetic magnitude, checks image scale/dimensions, and constrains error. Image constructors cap each side at 16,384 and each image at 4 Mi pixels; a scene caps aggregate image bytes at 64 MiB. Shader image texels clamp to image dimensions. | Exercise smallest positive rects, near-singular affine maps, negative/signed zero, nextafter boundaries, packed dimensions, nearest/bilinear image edges, rounded-image flags, and correction branches. Existing bounds are strong source constraints, not a formal all-floating-point proof. |
| Grouped material class | compact_group rejects rounded-image groups by inspecting the first placement. Current Canvas groups are only text glyph runs; fill/shape/image builders emit singleton groups, so every placement in an eligible group is glyph mask/solid text. | This is an implicit cross-crate invariant. Assert/test that every placement in a grouped range has the permitted material, or encode the class in PreparedGroup before changing grouping. Otherwise first-placement-only admission can produce a record decoder/layout mismatch. |

These bounds establish why ordinary accepted scenes should be in range; they do not establish that bypassing WGPU validation is safe for arbitrary shader bytes. No untrusted packets enter Renderer: PreparedScene fields are private and the renderer constructs the CSR and WORDS arrays itself. The remaining proof debt is preserving that cross-file private-constructor contract through typed shader changes. Keep runtime guards in the generated SPIR-V even if a future correctness argument says valid packets never trigger them.

The costly guard domain is the fragment path: dynamic resource indices occur under a per-fragment shader, sixteen sample evaluations, and per-tile draw loops. Source alone cannot say whether Naga's checks are hoisted, folded, or costly on a given driver. This is why the all-Restrict CPU win is not enough to accept it.

## Fallback and device lifecycle

1. At device selection, use the WGPU backend identity and enabled Device features. For the artifact route require backend Vulkan, PASSTHROUGH_SHADERS in device.features(), an artifact compiled for the current manifest/profile, and the exact explicit-layout hash. If the adapter cannot enable PASSTHROUGH_SHADERS, request the ordinary default device and use WGSL. The feature is backend-capability agnostic; the SPIR-V backend check is still necessary.
2. Before calling the unsafe method, reject any missing artifact, profile mismatch, shader hash/layout mismatch, backend mismatch, or absent feature and continue through the current checked create_shader_module(Wgsl(...)) path. The WGPU include_spirv_raw! helper is not enough because it records only main; construct the descriptor with vertex and fragment names and zero workgroup sizes.
3. Create explicit BGL/PL and pipeline under error scopes. If WGPU or the driver reports shader/pipeline validation, internal, or OOM failure, propagate it. Do not convert an error into a successful WGSL retry. This keeps artifact admission errors distinct from device errors.
4. A lost device invalidates that module, layout, pipeline, buffers, and bind groups together. Rebuild on a new Device and re-evaluate backend, enabled passthrough, and enabled robustness profile. Do not carry the old profile through recovery.

The path can be contained in a private constructor such as VulkanShaderArtifact::admit(device, manifest) returning a sealed enum, so arbitrary caller bytes never reach the unsafe call. It is not a global cache; current shared-device/window ownership work remains separate.

## Alternatives and smallest Sol slice

| Design | Work removed on first renderer | Safety/portability | Decision |
|---|---|---|---|
| Fixed Restrict SPIR-V via passthrough | WGPU/Naga runtime WGSL parse, validator, reflection, SPIR-V generation, retained reflected interface | Valid Vulkan 1.0 core artifact with all explicit bounds guards; explicit layout needed. Adds possible fragment bounds code on robust devices. Still driver module/pipeline work. | Smallest experiment. Gate on GPU parity/perf; not default on a CPU-only win. |
| Four SPIR-V policy variants plus a WGPU effective-robustness query | Same frontend/compiler work; matches HAL's current buffer/image guard choices per Device | Vulkan-only ABI addition to WGPU; variant selected from enabled Device policy, not adapter IDs. Extra artifact bytes/build work, and hardware OOB behavior still differs from Restrict. | Use if strict artifact fails hot-path gate. Strongest path to remove frontend without adding guards where WGPU omits them. |
| Prebuilt Naga IR through ShaderSource::Naga | WGSL source parsing only | Safe WGPU validation/reflection/backend path stays. WGPU Cargo naga-ir feature is currently off; serialization/deserialization or generated IR builder can reintroduce startup allocations and retained metadata. | Correct control experiment. Reject if module materialization erases parser savings; it does not meet full elimination. |
| ShaderSource::SpirV | Avoids WGSL parse only if source was generated earlier | WGPU still parses SPIR-V into Naga IR, validates, reflects, and calls HAL. The current crate does not enable WGPU's spirv feature. | Not an elimination route. |

The smallest Sol implementation slice is a feature-gated Vulkan artifact path using the exact typed source, explicit six-entry BGL, full two-entry-point SPIR-V module, and fixed all-Restrict profile; it falls back before the unsafe WGPU call when the feature, backend, or manifest is unavailable. Keep the current checked WGSL path as the reference. Do not include robustness-profile variants in the first change unless the strict version fails the GPU regression gate; if it does, add only the WGPU Device policy query and four mechanically generated combinations.

## Falsifiable gates

Keep the metrics separate:

- **Build/ABI gate:** exact typed WGSL hash and Naga version; Naga source and output validation; Vulkan 1.0 SPIR-V validation; descriptor reflection, entry point, binding, stride and min-size assertions; compile/link and artifact size recorded. Any optional capability, missing binding, source/layout mismatch, or validator failure rejects the artifact and selects checked WGSL before passthrough.
- **First-window CPU gate:** compare first Renderer::new on an already-created Vulkan Device against the current checked WGSL path. Record WGSL parse, Naga validator/reflection, Naga SPIR-V writer, shader-module call, pipeline call, requested Rust allocations/bytes, and median CPU time separately. Measure request_device in a different row: raw SPIR-V cannot remove it. Existing frozen fixture in the parent report found 7,892 Rust allocations / 2.19 MB requested during Renderer::new and about 86 ms on llvmpipe; that is a software-driver observation, excludes device setup, and is not new evidence for this slice. The existing suggested acceptance gate is at least 20% lower requested runtime bytes and at least 10% lower first-renderer construction CPU on a real supported Vulkan target. Record host build time and final artifact/binary size separately.
- **Frame correctness and bounds gate:** exact pixel parity with all existing 40 Vulkan oracle cases, plus adversarial boundary cases from the ledger, resource cap and target mismatch rejection. Compare only renderer-produced accepted packets for exact output parity; separately verify rejection/robustness behavior for invalid host inputs without relying on undefined Vulkan outputs. No MAX_DRAWS, MAX_PIXELS, atlas, image-byte, tile-reference, or target-limit regression.
- **Frame performance gate:** compare per-frame GPU time on actual supported Vulkan adapters, separately from startup CPU. No repeatable regression beyond the agreed noise budget for the strict profile. If Restrict guards regress, reject that profile for those devices and test an exact HAL-profile variant; do not “win” by reducing pixel/sample/draw dispatch or disabling bounds guards.
- **Failure gate:** unsupported backend/feature/artifact profile uses WGSL; shader/pipeline/device errors remain surfaced; device loss rebuilds all GPU objects and re-admits against the new Device. No build or hardware result is claimed here.

## Source references

The code seams above point to current local files. Primary upstream sources are pinned where WGPU/Naga version matters:

- [WGPU 30.0.1 core module parse, validate, reflect, passthrough](https://github.com/gfx-rs/wgpu/blob/v30.0.1/wgpu-core/src/device/resource.rs#L2363-L2595)
- [WGPU 30.0.1 shader source and passthrough descriptor](https://github.com/gfx-rs/wgpu/blob/v30.0.1/wgpu/src/api/shader_module.rs#L173-L237)
- [WGPU 30.0.1 unsafe Device passthrough API](https://github.com/gfx-rs/wgpu/blob/v30.0.1/wgpu/src/api/device.rs#L190-L205)
- [WGPU 30.0.1 passthrough feature contract](https://github.com/gfx-rs/wgpu/blob/v30.0.1/wgpu-types/src/features.rs#L1345-L1360)
- [WGPU 30.0.1 explicit-layout and min-size validation](https://github.com/gfx-rs/wgpu/blob/v30.0.1/wgpu-core/src/validation.rs#L780-L827)
- [WGPU 30.0.1 Vulkan writer configuration](https://github.com/gfx-rs/wgpu/blob/v30.0.1/wgpu-hal/src/vulkan/adapter.rs#L2645-L2870)
- [WGPU 30.0.1 Vulkan descriptor binding remap](https://github.com/gfx-rs/wgpu/blob/v30.0.1/wgpu-hal/src/vulkan/device.rs#L1411-L1452)
- [Naga 30.0.1 SPIR-V writer options](https://github.com/gfx-rs/wgpu/blob/v30.0.1/naga/src/back/spv/mod.rs#L995-L1180)
- [Naga 30.0.1 bounds policies](https://github.com/gfx-rs/wgpu/blob/v30.0.1/naga/src/proc/index.rs#L35-L145)
- [Vulkan shader robustness specification](https://docs.vulkan.org/spec/latest/chapters/shaders.html)
- [Vulkan robustness guide](https://docs.vulkan.org/guide/latest/robustness.html)
- [Vulkan robustness2 feature enablement](https://docs.vulkan.org/refpages/latest/refpages/source/VkPhysicalDeviceRobustness2FeaturesKHR.html)
- [Khronos SPIRV-Tools v2026.0 README](https://github.com/KhronosGroup/SPIRV-Tools/blob/v2026.0/README.md), [validator CLI](https://github.com/KhronosGroup/SPIRV-Tools/blob/v2026.0/tools/val/val.cpp)

