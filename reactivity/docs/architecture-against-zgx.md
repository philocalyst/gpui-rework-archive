# GPUI architecture experiments against ZGX

Continuation: the [active local campaign register](../evidence/architecture-campaign/README.md) records subsequent isolated experiments, including rejected witness replay, sparse text publication and owned text planning. The original retained-output findings below remain unchanged.

Keep the clean-room GPUI public API and exclusive window ownership. The next gains should come from removing complete-scene work after small edits, rather than compressing already small nodes further. Start with retained GPU output, then retained text/scene segments and composition-only transforms. Preserve the existing full-rebuild paths as independent oracles.

The local retained-output experiment is **unadopted**. It passes the exercised pixel and native integration checks and substantially reduces software-Vulkan work for sparse expensive scenes. Simple flat and full-damage cases regress. Neither these exploratory timings nor ZGX's published upstream-GPUI comparison establishes that this clean-room GPUI outperforms ZGX.

## Scope and source identity

The archive's active implementation is `reactivity/`, as directed by root `AGENTS.md`; `crates/gpui*` is a reference. The baseline is archive commit `cc193f85f5766c90a0677631c70c54c1eec4da1d` (`origin/wt/gpui-ce3`, original prod SHA `d464b7de9e`). Its application API already differs from upstream Zed GPUI. This work preserves the **archived clean-room API**, not source compatibility between those two frameworks.

The implementation is confined to branch `local/architecture-performance` in `/home/user/gpui-architecture-local`. The deliberate fault is on `local/retained-negative` in `/home/user/gpui-retained-negative`. The original archive-index checkout and all remote refs are unchanged. Nothing was pushed.

The ZGX source inspected is `a3678578980ef239058c557338ef9c544d356b0c`, checked out separately at `/home/user/zgx-reference-local`. Its [architecture](https://github.com/zeronsh/zgx/blob/a3678578980ef239058c557338ef9c544d356b0c/docs/architecture.md) describes mounted bindings, separate layout/paint/composition invalidation, retained output, damage culling, and fixed-size layout boundaries. Its published [GPUI comparison](https://zgx.zeron.sh/performance/gpui) concerns upstream GPUI and GPUI Fast on an Apple Silicon Mac. Do not transplant its ranking to this archived clean-room implementation or to Linux software Vulkan.

## Prior work worth preserving

These are historical results at their own pinned sources, not additive speedups for today's composition.

| Existing experiment | Useful result | Architectural lesson |
| --- | --- | --- |
| [Direct paint bindings](../evidence/paint-coupling/README.md) and [integrated paint](../evidence/core-paint-integration/README.md) | Typed source updates reach shared paint slots without rerunning the whole view; native bridge checks the complete-scene predecessor | Extend precise destinations and stable packets, keeping arbitrary model edits on the coarse fallback |
| [Software repair](../crates/gpui/RETAINED_DAMAGE.md) | Historical moving-caret prepare+raster 21.64 ms to 206.7 µs, over 1,001 commands | Pixels already rendered are worth retaining; old/new support and destination validity must be proven |
| [Packed children](../evidence/packed-children/README.md) | Nodes 40 to 24 bytes; 10K-child declaration 13 allocations/5,766,464 requested bytes to one/1,760,000 | Keep compact topology and exact child sizing; further packing is not the dominant update bottleneck |
| [Sparse accessibility](../crates/gpui/SPARSE_ACCESSIBILITY.md) | Historical 100K-leaf projection and consumer replacement about 77.7 ms to 73.6 µs for one field | Use verified source/identity hints instead of a full comparison, while preserving acknowledged authority |
| [Frontier and text integration](../evidence/frontier-text-integration/README.md) | Ancestor state follows depth; shared text geometry/leases remove repeated work | Retain immutable resources once, borrow during traversal, avoid per-node scratch mirrors |
| [Uniform packet rejection](../evidence/uniform-packet/failed-gpu-campaign/README.md) and [legacy packet rejection](../evidence/uniform-packet/legacy-timing/ROOT-REVIEW.md) | Exact pixels and better aggregate completion time still failed host/per-cell regression rules | A large aggregate win does not justify adopting a candidate with failing regimes |

The same principle appears in [Chromium's compositor architecture](https://chromium.googlesource.com/chromium/src/+/main/docs/how_cc_works.md): property trees separate transforms, clips and effects, and rasterized content can survive composition changes. That supports exploring separate property and content updates; it does not justify introducing Chromium's threading or object model into GPUI.

## Implemented experiment

`RetainedRenderer` owns a texture alongside the existing `Renderer`. A frame repairs conservative integer damage using the existing compositor and then copies that image to a newly acquired target. Both passes share one encoder and one submission. Unchanged exposure frames only copy. Application `View`, `Signal`, `Source`, input, layout and acknowledgement APIs are unchanged; the lower-level GPU crate gains an additive wrapper and work counters. The original full renderer remains callable and is the pixel oracle.

The native bridge supplies a **window-qualified acknowledged epoch**, not a bare source number. The backing image must match that predecessor before damage is usable. Coalesced candidates carry the union already maintained by Canvas. A missing predecessor, foreign window, resize, failed scene preparation or invalidated packet forces full reconstruction. The swapchain image is always treated as fresh; no platform preservation contract is assumed. Transparent damage reconstructs all contributors in paint order. There is no new unsafe code or mutable shared owner.

The added texture costs width × height × format bytes, beyond wgpu/driver allocation overhead: 524,288 bytes at 512×256 SDR, about 7.91 MiB at 1920×1080 SDR, and twice that for RGBA16F. A copy still touches every target pixel. Shader sample work is reduced; native bandwidth is not reduced to damage. Startup gains, whole-process memory gains and input-to-display latency gains are not established.

## What to implement next

| Priority | Internal change | Why it can matter against ZGX | Compatibility and acceptance condition |
| --- | --- | --- | --- |
| 1 | Select direct versus retained output from complete compositing and copy cost | This experiment exposes a large sparse-scene opportunity and a real flat-scene loss | No app change. Preregister a new crossover campaign, including cold allocation, full damage, tiny targets, SDR/HDR and physical GPUs. Do not choose a threshold from these five scenes and call it qualified |
| 2 | Retain independently replaceable text/paint segments keyed by existing stable identity | Direct text bindings currently clear shaping and enter `present_walk`, which rebuilds the complete presentation and command stream; ZGX updates affected retained nodes | Keep `text(&signal)` and existing coarse `View` fallback. Store segment ownership and epoch once, patch only proven sinks, retain predecessor leases through acknowledgement. Differentially test text, selection, IME, clips, failed newer preparation and semantic publication |
| 3 | Accumulate bounded typed paint-slot changes across coalesced source edits | `SlotTransition` currently carries one transition; skipped token gaps rebuild the GPU packet even when only independent colors changed | No app change. A bounded transaction must compose against one certified predecessor, deduplicate last writes, preserve alpha/proof-class admission, and fall back on capacity or authority mismatch |
| 4 | Separate composition-space changes from layout and content regeneration | `present_walk` currently flattens world geometry; translating a group need not reshape every label or rebuild every primitive | Reuse existing transform/scroll setters. Use shared transform/clip descriptors or measured layer boundaries. Preserve operation order for floating-point transforms, exact input/IME/a11y epochs and old/new damage; no algebraic reassociation without proof |
| 5 | Track bounded disjoint damage using existing 16-pixel tile organization | One bounding rectangle makes unrelated changes repaint the space between them | Compare small rect lists, touched tile words and row runs using the existing damage register. Include marking, merge, submission and full-surface fallback costs; avoid overlapping alpha repairs and unbounded fragmentation |
| 6 | Broaden layout containment and viewport reuse only when constraints prove independence | Fixed containers and scrolling rows are ZGX strengths; GPUI already bounds uniform lists to the viewport | Skip only when parent sizing, baseline, flex, percentage and intrinsic dependencies are satisfied. A fixed width/height alone is not a blanket proof for the full Cephal contract. Variable-height lists require a separate feature slice |

The likely winning combination is precise source-to-sink invalidation, stable retained scene segments, reusable GPU pixels and cheap composition changes. This is an architectural hypothesis grounded in the two implementations, not a measured overall ranking. ZGX's documented flat-child scans, absolute subtree bounds and deep clipped-ancestor work are useful adversarial cases for a future shared workload, not reasons to omit ordinary shallow apps.

## Experiment disposition and next gates

Follow [EXPERIMENTS](../EXPERIMENTS.md), [TESTING](../TESTING.md) and root `AGENTS.md`. The accompanying [dossier](../evidence/retained-output-local/README.md) separates sources, implementation, exact checks, raw measurements, costs, deliberate fault and unresolved gates.

The initial runs are exploratory, without preregistered speed thresholds. Report all cells and per-process tails. No acceptance threshold is being retroactively assigned. Prior temporary logs were lost when the environment restarted; the refreshed checks and raw runs are preserved locally, and the earlier failure history is explicitly described rather than reconstructed as original logs.

A production adoption decision still needs cold-start and retained/peak memory accounting, a preregistered workload matrix including streaming/layout/scrolling and full damage, instruction/CPU and p50/p95/p99 presentation endpoints, the existing public platform gates, and equivalent ZGX ports on at least two hardware classes. Do not pool Mac figures from the website with this software-Vulkan run. Freeze that next campaign before measuring it, keep every losing cell, and preserve the full renderer until the replacement passes its gates.
