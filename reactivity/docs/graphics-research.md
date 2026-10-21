# Graphics research: fewer pixels, fewer passes, no false “zero-render” claims

**Research snapshot:** 2026-10-20. This is an architecture and source audit, not an implementation claim. Upstream status can change; source links below pin code where possible. Benchmark numbers attributed to authors are not independent reproductions. “Zero work” here means no scene traversal / raster / allocation when there is no visual change; a changed visible pixel still has to reach a presentable image or a retained compositor surface.

## Finding

The strongest unifier is to classify a change by the *visual invariant it preserves* and choose the cheapest representation that remains correct. A transform-only change can preserve local geometry and reuse a retained compositor surface; paint-only can preserve path coverage and update a paint slot; a local geometric edit invalidates only the changed geometry’s spatial footprint; a backdrop effect can invalidate pixels behind it even when its own geometry is fixed. This gives one typed change protocol with different execution lanes, rather than a universal “redraw everything” lane or a universal SDF/compute renderer.

The runtime already describes immutable scene epochs, typed impact classes, sparse updates, local transform slots, negotiated renderer capabilities, premultiplied linear extended-sRGB composition, and a CPU reference renderer ([07-platform.md](inputs/final/07-platform.md), [08-runtime.md](inputs/final/08-runtime.md), [fastpath.md](inputs/runtime/fastpath.md)). A graphics backend should consume those decisions in batches. It should not re-walk application state, allocate per primitive, or invent a second invalidation graph.

## Four viable end-to-end formulations

| Formulation | Retained representation | Changed-frame work | Best fit | Hard boundary |
|---|---|---|---|---|
| **A. Compositor-owned visual tree** | Native visual/layer nodes, immutable local content surfaces, per-instance transform/opacity/clip | Commit K changed node properties; compositor reuses unchanged surfaces | Scrolling, transforms, independent native windows, static complex content | Platform-specific layer limits/semantics; backdrop effects and ordered translucent groups can force recomposition |
| **B. Sparse analytic strips** | Local paths + flattened edges + tile bins + compressed full-coverage runs and boundary coverage | Regenerate touched strips, composite touched pixels, upload only changed strip/paint data where supported | Sparse vector UI, scalable glyph outlines, software fallback | Fractional transforms change edge coverage; filters and wide clips expand regions; offscreen/presentation coherence still matters |
| **C. Compute scene scan** | Compact immutable commands/paths, count/scan buffers, tile worklists and raster output | Dispatch count/scan/fine raster for affected cohort/tiles | Highly dynamic vector scenes, large overlapping path workloads, compute-capable GPU | Dispatch/setup and prefix-scan costs, capacity overflow, compute-unavailable devices, allocation discipline |
| **D. Glyph/shape implicit field + exact refinement** | Cached SDF/MSDF or analytic implicit parameters, local edge list, hinted bitmap fallback | Cheap field evaluation for clear interior/exterior; exact edge evaluation only in ambiguous footprint | Reused glyphs/icons over size and transform ranges, large decorative type | Distance-field error, corners/topology, tiny text hinting, atlas churn; exact refinement must handle adversarial outlines |

These can coexist behind one scene protocol. A native layer can contain sparse-strip-rendered content; a GPU renderer can use a glyph field for regular glyphs and exact outline coverage for difficult glyphs; CPU reference can use scanline/analytic coverage. Selection belongs to retained content class and backend capability, not app code. Do not compile every option into the no-GPU/default path as compulsory memory.

### A. Native retained compositor surfaces

Keep a tree of `VisualId -> {content lease, local transform, opacity, clip, z/order}`. A transform or opacity update changes a small visual record and leaves local pixels intact. An immutable template can be shared by instances, while each window owns only instance state; the native compositor owns actual desktop composition. This is the best path for moving a static subtree without CPU path rasterization or a new app-owned full-frame target.

Windows DirectComposition documents an atomic retained visual tree, shared visual/device relationships, and transforms ([architecture](https://learn.microsoft.com/en-us/windows/win32/directcomp/architecture-and-components), [transforms](https://learn.microsoft.com/en-us/windows/win32/directcomp/transforms)). That proves a useful Windows-specific capability, not a portable abstraction with identical costs. Core Animation offers retained layers, but `CAMetalLayer` is a pool of drawable textures; its `presentsWithTransaction` controls synchronous alignment with Core Animation transactions and may introduce waits ([CAMetalLayer](https://developer.apple.com/documentation/quartzcore/cametallayer), [presentsWithTransaction](https://developer.apple.com/documentation/quartzcore/cametallayer/presentswithtransaction)). Wayland surfaces are compositor-managed surfaces, but protocol damage is a repaint hint, not a guarantee of no composition work. A Vulkan image from one swapchain is not automatically a reusable cross-window layer.

**Memory model.** If a retained content surface is `W×H×b` bytes, it costs `WHb` once per distinct local content image, plus compositor metadata and any buffering the OS allocates. Each instance costs its transform/opacity/clip record (often tens to hundreds of bytes, backend-dependent), not another full image, only if sharing is actually supported. At 3840×2160, RGBA8 is 33,177,600 bytes = 31.64 MiB for one image. A 3-image presentation queue is 94.9 MiB before depth/MSAA/temporary attachments. Retained layers save repeated app raster work; they do not make pixels or scanout free.

**Correctness limits.** Layer boundaries can alter group opacity and blend semantics: opacity on a group is not generally equal to multiplying each child’s opacity when overlaps exist. A blur of backdrop content is explicitly dependent on pixels underneath. Rounded clips, shadows, and filters need inflated bounds and layer-local coordinate correctness. Thousands of tiny native layers can cost more metadata/compositor scheduling than one batched texture. Keep layers as an earned/predictable optimization, budgeted per window; demote to batched draw commands when churn, layer count, or memory exceeds measured limits. Cross-window content sharing must be an immutable GPU resource lease with adapter/device generation and fences; each window still has its own presentation surface. A resource cannot be freed or rewritten until all submitted queues that read it have completed.

### B. Sparse strip renderer (CPU preprocessing, CPU or conventional GPU fine stage)

Represent each path in local coordinates; flatten curves with a bounded geometric tolerance; bin edges into tiles; produce compact horizontal coverage strips. Store exact coverage only at path boundaries and represent interior full-coverage runs compactly. The upstream Vello architecture describes this shared sparse-strip family as `vello_cpu` plus `vello_gpu`; `vello_gpu` rasterizes/composites via vertex+fragment pipelines and does not require compute. The original compute-centric `vello` is explicitly experimental and separated under `research/` ([pinned Vello architecture, commit `7d70631ac848925972c85171dc064a803003f796`](https://github.com/linebender/vello/blob/7d70631ac848925972c85171dc064a803003f796/ARCHITECTURE.md)). The names “hybrid” and “GPU” have shifted across releases; pin a crate/revision rather than infer architecture from package branding.

Let `E` be flattened edges, `R` tile-edge references after binning, `S` emitted strips, `B` boundary pixels, `T` touched tiles, `P` output pixels. A rough persistent/workspace ledger is:

```text
path template      ~ (edge bytes × E) + path/paint metadata
tile references   ~ ref_bytes × R             (often 4–8 bytes each)
strip descriptors ~ desc_bytes × S             (often 8–16 bytes each)
boundary coverage ~ B bytes (u8 coverage) or B×4 (float coverage)
paint/instance    ~ per-node/per-instance slots; shared geometry excludes paint
present image     ~ P × bytes_per_pixel        (8-bit RGBA=4; RGBA16F=8)
```

Rebuilding a frame is approximately `O(E_changed + R_changed + S_changed + B_touched + P_touched)`, not `O(P×E)` per path, if cached strips survive. A pure color change can preserve strips. Integer translation may reuse strips by relocating tile coordinates. Fractional translation, scale, rotation, changed device scale, fill rule, or AA mode changes coverage and must either re-bin/refine or use a documented approximation. Y translation is particularly awkward for multi-row strips. Caches must key by all coverage-affecting inputs, while keeping paint out of the geometry key.

Vello’s own thesis says sparse strips can reduce dense intermediate work; it also documents a sequential/coarse stage that limited thread scaling and small-tile waste, and it cautions that parts of the thesis describe a shared project and may be outdated ([2025 thesis](https://ethz.ch/content/dam/ethz/special-interest/infk/inst-pls/plf-dam/documents/StudentProjects/MasterTheses/2025-Laurenz-Thesis.pdf)). This is a plausible architecture, not proof it wins all UI workloads. The project’s own tracking design calls out sorting/binning and tile size as perf risks ([issue #670](https://github.com/linebender/vello/issues/670)); viewport/filter-bound bugs demonstrate why filter expansion must precede culling ([issue #1304](https://github.com/linebender/vello/issues/1304)). Benchmark its repository workloads and this project’s own controls/text/media/filter scenarios.

### C. Compact command stream + compute scan

Encode the scene once into immutable path/draw/transform/resource records. For a changed cohort, emit compact changed records into bounded buffers; count segments/tiles, prefix-scan counts into work offsets, then rasterize per tile and composite. This replaces serial per-path or per-tile work with parallel stages. Vello’s research renderer and the primary papers on massively parallel path rendering motivate this family; arbitrary pixel queries need more machinery than simple scanline spans ([Gan et al., 2014 paper](https://w3.impa.br/~diego/publications/GanEtAl14.pdf); [Nehab & Hoppe, 2008](https://www.microsoft.com/en-us/research/wp-content/uploads/2008/08/NehHop08.pdf)).

For `E` edges, `R` tile-edge references, `T` active tiles, and `P_t` touched pixels, storage is approximately:

```text
immutable scene:     E×edge_bytes + commands×command_bytes + shared resources
prefix-scan scratch: counters + offsets ≈ O(E+T), often several u32/u64 arrays
tile worklists:      R×ref_bytes, plus overflow/capacity counters
render targets:      P×bpp for each live attachment (RGBA8=4, RGBA16F=8)
```

Work is `O(E+R+T+P_t)` plus dispatch and scan stages. It can remove CPU fine raster and amortize GPU parallelism, but it does not remove uploads, dispatch, synchronization, output pixels, or the serial cost hidden in building scene bins. Preallocate a measured high-water capacity, use count/scan/fill passes and a bounded overflow flag, and have a tested fallback; never silently truncate edges or allocate unbounded GPU buffers in a frame. Do not dispatch for an idle window. On systems without compute, route to CPU sparse strips / a fragment backend. Compute gets selected only when counters show that its extra fixed cost is repaid.

### D. Implicit fields with exact-edge refinement (proposed hybrid)

Use a distance field as a *conservative classifier*, not as unquestioned pixel truth. For an exact signed distance `d` (1-Lipschitz), samples at points `x_i` with known absolute error at most `ε` give a conservative interval at query point `x`:

```text
lower(x) = max_i (sample_i - ε - |x-x_i|)
upper(x) = min_i (sample_i + ε + |x-x_i|)
```

The true distance is in `[lower, upper]` (intersect tighter bounds from all samples). For an entire pixel region `Q`, extend the interval by the maximum distance from the query point to Q. If the interval proves the whole pixel exterior/interior, emit coverage 0/1; otherwise refine against the local exact edge list and compute coverage. This bound can be loose; bilinear interpolation is not itself an error certificate. Quantization, texel filtering, atlas mipmapping, and transform metrics must be included in `ε`. A field generated from low-resolution rasterization has no universal subpixel feature guarantee. The proposed benefit is “exact where uncertain, cheap where proven,” and must be benchmarked against simply evaluating the nearby edge list.

MSDF stores edge-colored distances in multiple channels to retain sharp corners better than a scalar SDF, but edge coloring/overlaps and small features remain failure modes. Chlumsky’s thesis and `msdfgen` are the primary origin/source ([thesis](https://media.mcfarlaneaviation.com/documents/documents/f8-dp-2015-chlumsky-viktor-thesis.pdf), [pinned project source](https://github.com/Chlumsky/msdfgen)); a 2026 follow-on study reports feature loss under two texels in its tested method, a useful adversarial result rather than a universal threshold ([Hlynka & Mould, 2026](https://cs.uwaterloo.ca/~dvogel/gi2026/papers/1009a.pdf)). Tiny text needs grid fitting/hinting and font-specific stem behavior: outline rendering and SDF do not reproduce hinted bitmap rasterization merely by increasing shader precision. Preserve a hinted grayscale/LCD raster fallback for low ppem, and test per-font/per-scale. GPU-only high-resolution Slug evaluates glyph outlines with pixel coverage methods, not a generic open drop-in renderer; its published algorithm is a primary description, but code/license, product availability, and measured integration cost must be checked separately ([Lengyel, I3D 2018](https://www.terathon.com/i3d2018_lengyel.pdf)).

## Algorithms are alternative work representations, not quality labels

* **Analytic area / edge coverage:** exact or approximated integration of shape coverage over pixel footprint. Reduces multi-sample shading and avoids tessellation cracks; requires stable winding/topology, careful curve/clip intersection, and correct premultiplied-alpha coverage. A sample of the signed distance followed by `smoothstep` is not exact area coverage for arbitrary curvature, corners, narrow strokes, or transformed pixels.
* **Tile/strip / scanline:** group geometry spatially, sort/bin, evaluate only relevant edges. Great when edge/pixel coherence makes work sparse; sorting, pathological overdraw, variable-length per-tile lists and tile overcoverage can dominate. Prefix scans are a work assignment primitive, not a free optimization. Levien’s Vulkan scan prototype is valuable research but its own benchmark (64M integers on a GTX 1080) is not UI renderer evidence ([article](https://raphlinus.github.io/gpu/2020/04/30/prefix-sum.html)).
* **Loop–Blinn implicit curves:** map Bézier control-hull triangles and evaluate implicit equations in a fragment shader for resolution-independent curve edges. This is elegant for curve evaluation but does not by itself solve arbitrary filled-path winding, self intersections, Boolean clipping, or coverage of all boundaries; those need correct decomposition/region topology. See the primary paper ([Loop & Blinn, 2005](https://www.microsoft.com/en-us/research/wp-content/uploads/2005/01/p1000-loop.pdf)) and GPU Gems exposition ([chapter 25](https://developer.nvidia.com/gpugems/gpugems3/part-iv-image-effects/chapter-25-rendering-vector-art-gpu)). Treat it as a curve primitive, not an entire UI renderer.
* **MSAA / tessellation:** simple hardware paths but incur sample bandwidth/storage at high AA, and triangulation can crack or become temporally unstable. Pathfinder’s design audit records rejected alternatives and their constraints; that is author engineering evidence, not an independent theorem ([pinned Pathfinder wiki snapshot](https://github.com/servo/pathfinder/wiki/Related-approaches)).
* **SDF/MSDF:** amortize glyph raster across scale, but trade exact edge placement and small-feature fidelity for texture sampling. Use scale-aware fallback and field error accounting.
* **Exact glyph outline (Slug-style):** edge coverage from glyph outlines in GPU pipelines; avoids a fixed-resolution atlas, but fragment edge-list work, font hinting, rasterization conventions and licensing/integration are still material. No algorithm wins every ppem or glyph.

## Damage, render-graph pruning, compositing, and surfaces

Dirty regions are a correctness proof obligation: every changed output pixel must be included, along with every dependency region that can influence it. Propagate regions through a retained effect graph:

```text
source geometry / image delta
  -> transform to output-space bounds
  -> intersect with clip / occlusion domain
  -> dilate for blur/shadow kernel support; offset for shadow
  -> expand for displacement or sampling footprint
  -> add backdrop dependencies from underlying scene in affected region
  -> merge/coalesce by tile cost, then render/replay only those tiles
```

For a Gaussian blur, mathematically infinite support must be truncated to a stated tail-error bound (e.g. kernel radius tied to sigma and permitted visual error), not assumed to stop at an arbitrary radius. A changed pixel behind backdrop blur can change the blur output in the overlay. Blend nodes that read destination pixels establish dependencies. An opaque node with alpha exactly one can cut lower dependencies within its exact coverage; partial alpha cannot. If dependency expansion reaches the full window, full repaint is the correct result. Pool scratch tile memory by render-graph lifetimes and alias only non-overlapping lifetimes; no per-frame `Vec` allocation.

Premultiplied linear source-over is `(Cs + (1−αs)Cd, αs + (1−αs)αd)`. It is associative under ideal arithmetic but not commutative; rounding, transfer functions and finite formats matter. Keep painter order for translucent UI, masks, blend modes and group opacity. Front-to-back/depth reordering is valid only for regions proven opaque and semantically order-independent. A 2D depth buffer does not make UI reordering correct. Coverage multiplies fragment alpha and premultiplied color consistently; do not antialias in gamma-encoded color.

### Damage-aware presentation does not erase output-buffer costs

At 3840×2160, one RGBA8 output is 31.64 MiB; RGBA16F is 63.28 MiB. Two or three swap images cost roughly 63.3/94.9 MiB RGBA8 per window, often plus a depth/MSAA target, blur intermediates, atlas and compositor-owned buffers. A persistent full-size offscreen image costs another 31.64 MiB RGBA8 (or 63.28 MiB RGBA16F); add it only when its retained-content benefit beats its memory/bandwidth cost. A tile cache allocates less when sparse, but a full presentable image/scanout buffer remains. Measure RSS *and* GPU allocation/committed/peak residency: virtual mappings, driver allocations and compositor surfaces are not all reflected in process RSS.

Presentation support differs materially:

* **Vulkan:** `VK_KHR_incremental_present` lets an app report modified rectangles; a zero-sized rect may hint that no pixels changed, but the engine *may* use it and must still honor semaphore waits. It is optional and backend/driver/presentation-engine dependent ([Khronos extension spec](https://registry.khronos.org/VulkanSC/specs/1.0-extensions/man/html/VK_KHR_incremental_present.html)). It describes presentation damage, not whether the application must render a coherent swapchain image.
* **DXGI:** `Present1` dirty rectangles can reduce presentation work, with strict contract: update every reported pixel and do not update outside the rects. Backbuffer age/coherence must be tracked; stale backbuffers need previous coherent content copied before partial drawing ([DXGI parameters](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/ns-dxgi1_2-dxgi_present_parameters), [flip model guide](https://learn.microsoft.com/en-us/windows/win32/direct3ddxgi/dxgi-1-2-presentation-improvements)). Dirty rects are not a license to draw only the changed widgets into an arbitrary stale buffer.
* **Wayland:** surface damage tells the compositor which buffer content changed; compositor scheduling/composition remains its decision. Track buffer age when supported by the chosen EGL/Vulkan path, and repair accumulated damage in the acquired buffer. Do not mistake `wl_surface.damage_buffer` for guaranteed scanout savings ([Wayland surface protocol](https://wayland.freedesktop.org/docs/html/apa.html)).
* **Metal/Core Animation:** CAMetalLayer supplies a limited drawable pool (`maximumDrawableCount`); releasing a drawable promptly matters. Apple documents asynchronous presentation by default and synchronous transaction presentation as a separate choice with a scheduling wait ([CAMetalLayer docs](https://developer.apple.com/documentation/quartzcore/cametallayer), [transaction docs](https://developer.apple.com/documentation/quartzcore/cametallayer/presentswithtransaction)). No portable CAMetalLayer damage rectangle should be assumed.
* **wgpu:** portable `SurfaceTexture` presentation exposes configure/acquire/submit/present and frame latency configuration, but no general damage-region contract in its public surface API at the audited source. Use a native shim only behind negotiated capability; cite and pin the actual wgpu version before claiming a backend supports it ([surface source](https://github.com/gfx-rs/wgpu/blob/trunk/wgpu/src/api/surface.rs)).

## Shared immutable content, local spaces, typed changes, multiple windows

Keep one immutable `ShapeTemplate` / `GlyphRunTemplate` / `ImageLease` keyed by content revision, with per-instance `{window, transform, opacity, clip, paint_slots}`. Geometry caches key on all coverage-changing inputs (scale class, fractional phase where relevant, fill rule, stroke expansion, AA contract), not color. Paint changes update material/slot data; transform changes first try compositor transform; layout/shape changes invalidate local geometry and affected world bounds. Filter changes invalidate effect dependencies. These become typed changes feeding one lane classifier; unsupported capability routes fall back to the next correct lane.

For windows on the same GPU device, immutable textures/geometry can be shared at the renderer level. Give each resource a device-generation lease; each queue submission records a use fence, and eviction waits until all windows/queues retire it. A window swapchain image is not the shared asset. When windows span adapters or device recreation, reupload from a retained CPU/encoded source or regenerate. CPU memory “shared mapping,” GPU heap aliasing, and zero-copy import are different mechanisms and need separate evidence. OS virtual memory demand paging can reduce resident physical pages for untouched mappings, but it does not make cold page faults free or guarantee that GPU/driver surfaces are demand-paged; report virtual, resident, committed, GPU-local and shared allocations separately.

## Ben Joffe’s weekday article: a method, not a renderer trick

Joffe’s 2026 article starts from a simple, maintainable modulo implementation, then derives specialized formulations for narrower domains/architectures, checks asserted ranges exhaustively, inspects machine code, and benchmarks latency versus throughput on named CPUs. It explains that replacing division/remainder with constants, multiply-high/shift/correction can expose faster target instructions, while a narrow domain can permit a different formulation. Its benchmark table is author-produced scalar data and the article explicitly distinguishes it from independent replication ([article and test repository](https://www.benjoffe.com/fast-day-of-week)).

Transfer the *discipline*: (1) state the exact semantic domain and invariant; (2) reformulate work into a cheaper representation; (3) prove bounds/correctness and exhaustively test finite domains or fuzz continuous cases; (4) inspect generated machine code; (5) benchmark representative hardware and workloads, including latency and throughput; (6) retain the clear baseline and dispatch only where evidence supports it. For rendering, the analogous reformulation is to replace “test every primitive at every pixel” with tile-local edge lists, conservative interval rejection, retained native transforms, or prefix-scan assignment. There is no logical connection between weekday arithmetic and SDF; borrowing its bit tricks would be cargo cult. The key transferable insight is mathematical recoding plus proof, assembly inspection and reproducible measurement.

## Reject or constrain these seductive optimizations

1. **“No repaint on idle” by keeping an extra full-window image always:** wrong memory default. First compose directly to the presentation target where the backend supports it; retain subtrees selectively and account their full surface bytes. An extra offscreen pays for itself only when it avoids enough raster/composition and has a bounded lifetime/budget.
2. **Always use MSDF/SDF for all text:** reject as a default. Tiny hinted UI text, narrow stems, acute corners, hinting, subpixel positioning and font-specific raster conventions can visibly regress. Use proof/scale gates, exact edge fallback, hinted bitmap at low ppem, and per-font goldens.
3. **Use `smoothstep(distance)` as exact antialiasing:** reject. It is an approximation whose effective pixel footprint depends on derivatives, orientation, curvature, transform and distance-field error. Bound error or use actual area/coverage in ambiguous pixels.
4. **One giant layer per widget:** reject. It multiplies surfaces, state switches and compositor bookkeeping; promote only independently moving/coherently retained subtrees under a memory/cadence budget.
5. **Depth-sort all UI for overdraw:** reject for translucent painter-ordered content; only exact opaque regions may occlude/reorder. Alpha, masks and group isolation establish order dependencies.
6. **Trust dirty rectangles to preserve arbitrary backbuffer pixels:** reject. DXGI explicitly requires current pixels in reported rectangles, and swapchain images may be stale. Track age/history or reconstruct the damaged region completely.
7. **Compute is automatically faster / `vello` means production:** reject. Vello’s current architecture distinguishes mature CPU, GPU sparse-strip and experimental compute paths. Measure the target scene, device, startup and idle costs; use fallback for compute-less targets.
8. **Texture/page sharing means free cross-window memory:** reject. Sharing avoids duplicate content uploads/storage only with a compatible device/resource model. Synchronization, fences, device loss, format/color space and each window’s distinct present images remain.

## Adversarial correctness matrix

| Case | What breaks a shortcut | Required policy/test |
|---|---|---|
| Overlapping alpha / group opacity | Noncommutative painter order; layer isolation changes result | Premultiplied linear reference goldens; blend order retained; test fractional alpha overlaps |
| Blur, shadow, backdrop | Damage expands and reads prior scene pixels; cull-before-expand loses edges | Dependency-region propagation, bounded kernel tail error; viewport-edge, occlusion and scroll tests |
| Tiny text / LCD | Hinting, phase, stem and subpixel channel order differ from outline/SDF | Hinted fallback; 8–20 ppem, fractional x/y, all scale factors and RGB/BGR phase captures |
| Rotation / nonuniform scale | Local raster coverage/field metric changes; cache aliasing | Transform-aware bounds/field gradients; subpixel translation/rotation and anisotropic scaling fuzz |
| HDR / wide gamut | 8-bit SDR cache clamps or encodes in wrong space | Scene-linear premultiplied reference, tagged surface, unclamped HDR test, single final encode/tone map |
| Clipped/self-intersecting paths | Curve triangulation/implicit primitive loses winding or clip intersection | Nonzero/even-odd, self-intersection, nested clip, extreme coordinates and negative offscreen bounds |
| True 3D / perspective | 2D affine edge bounds/occlusion no longer valid | Separate 3D path/depth semantics and perspective-correct field bounds; never silently reuse affine proof |
| Swapchain age / resize / device loss | Accumulated damage or cache handles refer to old resources | First-frame/full repaint, resize/full invalidation, generation-tagged leases and recovery goldens |
| Very long edge lists / huge coords | Buffer overflow, u16 coordinate truncation, O(E×pixels) blowup | Checked capacity + overflow fallback; checked integer ranges; adversarial path stress and memory cap |

## Measurement plan and acceptance criteria

**Baselines:** reference CPU renderer (pixel correctness), present-target full redraw, typed damage full-scene replay, sparse strips, native retained transforms, and any compute experiment. Same scene protocol and visual outputs; compare each path against reference within a declared per-format tolerance.

**Scenes:** 1) no-op idle (no events); 2) pointer hover across dense rows; 3) 10k-row scroll with stationary chrome; 4) static complex vector tree + one color change; 5) transform-only repeated animation; 6) 10k glyph stress at ppem 8/10/12/16/24/48 with diacritics/Arabic/combining marks; 7) corner-heavy and self-intersecting paths; 8) overlapping translucent layers; 9) backdrop blur/large shadows crossing viewport edges; 10) HDR gradient + alpha; 11) two visible windows sharing glyph/image content; 12) resize, minimize/restore, occlusion and device-loss recovery.

**Measure separately:** cold startup (process + first visible frame), warm p50/p95/p99 UI build and GPU time, CPU cycles/instructions/cache misses, bytes uploaded, dispatch/draw count, primitive/edge/tile/boundary counts, damage area, allocation count, mapped/resident/committed CPU bytes, GPU peak/live bytes per window, present wait and frame latency. Idle gate: no frame request, worker wake, allocation, GPU dispatch or changed upload for unchanged visual state after initial present, except platform-required housekeeping. Start gate: no optional atlas/renderer allocations until first use; report first-frame latency and bytes. Count offscreen targets and tile/swapchain images explicitly.

**A/B toggles:** tile sizes (4×4, 8×8, 16×16); strip vs exact per-pixel edge list; CPU vs fragment vs compute; field cache resolutions/channels and conservative refinement; hinted bitmap threshold; damage rectangle coalescing; render directly to swap image vs one retained offscreen; native layer promotion threshold; worker count 1 vs pool; full redraw vs buffer-age accumulated repair. Repeat warmed trials on Intel/AMD/NVIDIA desktop, Apple Silicon, integrated graphics, and Mesa/Wayland where available. Attribute author-reported numbers separately from local reproducible runs; include device/driver/backend/build flags and confidence intervals.

**Accept an optimization only when** it preserves the reference matrix, has explicit overflow/error fallback, reduces p99 work or bytes on at least one target workload without breaching memory/idle/startup budgets, and has a counter showing when the fast path activates/falls back. Do not optimize a synthetic isolated kernel at the cost of first frame, power/idle wakeups, quality or cross-platform capability.

## Primary references and source identity

* Vello repository `linebender/vello`, architecture snapshot commit [`7d70631ac848925972c85171dc064a803003f796`](https://github.com/linebender/vello/commit/7d70631ac848925972c85171dc064a803003f796) (retrieved 2026-10-20); see the pinned [architecture](https://github.com/linebender/vello/blob/7d70631ac848925972c85171dc064a803003f796/ARCHITECTURE.md), [Sparse Strips tracking issue](https://github.com/linebender/vello/issues/670), and [2025 CPU thesis](https://ethz.ch/content/dam/ethz/special-interest/infk/inst-pls/plf-dam/documents/StudentProjects/MasterTheses/2025-Laurenz-Thesis.pdf).
* Gan et al., “Massively-Parallel Vector Graphics,” 2014, [paper](https://w3.impa.br/~diego/publications/GanEtAl14.pdf). Nehab & Hoppe, “Random-Access Rendering of General Vector Graphics,” 2008, [paper](https://www.microsoft.com/en-us/research/wp-content/uploads/2008/08/NehHop08.pdf).
* Loop & Blinn, “Resolution Independent Curve Rendering using Programmable Graphics Hardware,” 2005, [paper](https://www.microsoft.com/en-us/research/wp-content/uploads/2005/01/p1000-loop.pdf); Lengyel, “GPU-Centered Font Rendering Directly from Glyph Outlines,” I3D 2018, [paper](https://www.terathon.com/i3d2018_lengyel.pdf).
* Chlumsky, MSDF thesis (2015) [PDF](https://media.mcfarlaneaviation.com/documents/documents/f8-dp-2015-chlumsky-viktor-thesis.pdf), [`msdfgen` source](https://github.com/Chlumsky/msdfgen); Hlynka & Mould, “Multi-Colour Distance Fields,” Graphics Interface 2026 [paper](https://cs.uwaterloo.ca/~dvogel/gi2026/papers/1009a.pdf).
* Ben Joffe, weekday reformulation article (first released 2026-08-17, updated 2026-08-20), [article](https://www.benjoffe.com/fast-day-of-week), [test/benchmark code](https://github.com/benjoffe/fast-world-calendars).
* Khronos [VK_KHR_incremental_present](https://registry.khronos.org/VulkanSC/specs/1.0-extensions/man/html/VK_KHR_incremental_present.html); Microsoft [DXGI dirty rect contract](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/ns-dxgi1_2-dxgi_present_parameters) and [presentation guidance](https://learn.microsoft.com/en-us/windows/win32/direct3ddxgi/dxgi-1-2-presentation-improvements); Wayland [surface protocol](https://wayland.freedesktop.org/docs/html/apa.html); Apple [CAMetalLayer](https://developer.apple.com/documentation/quartzcore/cametallayer).
