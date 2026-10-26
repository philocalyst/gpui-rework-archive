# Performance Contract and Competitive Gates

This document defines what “surpass zgui, Floem, Xilem, Leptos, Haalka/Jonmo, and Slint” can
honestly mean.
Architecture can establish a performance ceiling and rule out classes of work; it cannot guarantee
a speedup before comparable implementations run on the same machine, renderer, content, and build
profile.

## 1. Verified competitive baseline

The audit is pinned to upstream commits so these statements remain checkable:

| Project | Commit/release audited | Relevant current behavior | Bar this plan must clear |
|---|---|---|---|
| [zgui architecture](https://github.com/zortax/zgui/blob/41727c1b7de2239642378d0a47ed8b302e6ce9c0/docs/guide/architecture.md) / [performance](https://github.com/zortax/zgui/blob/41727c1b7de2239642378d0a47ed8b302e6ce9c0/docs/performance.md) | `41727c1b7de2239642378d0a47ed8b302e6ce9c0` | Retains document, computed styles, Taffy box tree, shaped paragraphs, paint chunks, hit-test index, and rendered pixels; tracks damage and publishes generated performance gates | No clean-tree traversal; persistent pixels; sub-millisecond local interactions; equally strong counters and leak/park checks |
| [Floem `dyn_stack`](https://github.com/lapce/floem/blob/778bb5f2aa08429e579ee2e6ac97e84fbf18b618/src/views/dyn_stack.rs) / [`virtual_stack`](https://github.com/lapce/floem/blob/778bb5f2aa08429e579ee2e6ac97e84fbf18b618/src/views/virtual_stack.rs) | `778bb5f2aa08429e579ee2e6ac97e84fbf18b618` | Retained `ViewId` tree, reactive effects, persistent per-view Taffy nodes, keyed `dyn_stack`, and variable-extent virtualization | Match its direct property updates and mature list ergonomics while avoiding whole-vector scans on the scalable path |
| [Xilem architecture](https://github.com/linebender/xilem/blob/7fe469d6bd1ddc486d406a6eb4f9e776b5ffe34d/xilem/ARCHITECTURE.md) | `7fe469d6bd1ddc486d406a6eb4f9e776b5ffe34d` | Typed `View`/`ViewSequence` build-rebuild-teardown protocol with in-place element mutation; memoization prunes eager view construction | Preserve typed structural diff strengths while eliminating normal-state whole-view regeneration |
| [Leptos](https://github.com/leptos-rs/leptos/tree/fa1b92d187d0e50b281574ea6785b5c302216e13) | `fa1b92d187d0e50b281574ea6785b5c302216e13` | Mature signals, keyed iteration, resources, owner scopes, web DOM updates, and an explicit `LocalStorage` option beside sync storage | Match reactive composition while making the native UI-local path the default and avoiding the static-vs-reactive closure trap |
| [Haalka text input](https://github.com/databasedav/haalka/blob/86dba4552f8d317097503b80d9c6b496b3f0f169/src/text_input.rs) | `86dba4552f8d317097503b80d9c6b496b3f0f169` | Retained Bevy ECS UI with static/reactive builder pairs and working text-input integration | Match retained ownership and cleanup with one destination-driven property surface and stronger native text state |
| [Jonmo child builder](https://github.com/databasedav/jonmo/blob/db1acb70fe417f6fdbfdaa542d6820ea91385dff/src/builder.rs) | `db1acb70fe417f6fdbfdaa542d6820ea91385dff` | Signal-vector diffs can move existing children; `UpdateAt` remounts a child and `Replace` remounts all | Specify resident-key value update independently from structural move/remount semantics |
| [Slint reactivity](https://docs.slint.dev/latest/docs/slint/guide/language/concepts/reactivity/) / [1.17.1 changelog](https://github.com/slint-ui/slint/blob/master/CHANGELOG.md) | `1.17.1` (2026-07-07) | Its UI language provides automatically tracked, compiler-enforced pure property bindings and compiler optimization opportunities unavailable to opaque host-Rust closures | Approach its specialized property constants with generated GPUI ports/direct slabs while retaining ordinary Rust, dynamic dependency escape hatches, and comparable feature behavior |
| [PanGui](https://www.pangui.io/) | site audited 2026-08-12; closed alpha | Demonstrates arbitrary node-relative position/size, root overlays, layout-mode blending, direct draw buffers/commands, and injected/testable input; current public material is C# and not a reproducible benchmark | Match the expressiveness through a retained sparse placement graph, portals, typed canvas/render passes, and real input injection without treating its claims as performance evidence |
| [Lilt](https://github.com/cyypherus/lilt) / [`Animated`](https://docs.rs/lilt/latest/lilt/struct.Animated.html) | `0.8.1` documentation audited | Small stable-Rust transition value sampled as a function of time, including interruption, delay/repeat/auto-reverse and asymmetric easing; not a full spring/keyframe/layout/GPU system | Preserve its cadence-independent interruption UX while adding dense springs/keyframes/gesture/FLIP, destination obligations, retained GPU lanes, and deterministic clocks |
| [Rosin](https://github.com/sailbrush/rosin) | repository audited 2026-08 | Leptos-inspired `Var` reactivity with panic-consistent updates, retained reuse behind an immediate-feel builder, CSS hot reload, and a Subform/Flutter-style single-pass layout claiming ~2.3x Taffy on 10k nodes in ~1.8 ms | Treat its single-pass layout number as a standing challenge through the layout-adapter seam: if persistent Taffy cannot match it on the layout workloads, the seam exists precisely to replace the engine without changing the public vocabulary |

The zgui checkout's generated `docs/performance.md` is especially important. It reports roughly
202 µs median hover crossings, 44 µs translation-only scroll frames, and 1.02 ms recycle frames for
its own pinned workload, while also showing several current kitchen-sink regressions. Those numbers
are evidence of its implementation on its hardware—not portable promises and not directly
comparable to GPUI until the same workload and renderer are ported.

## 2. Where this design can win

The concrete mechanism plan for clearing the zgui bar — the presentation-resident input loop
(hover/scroll resolved against the published epoch with zero turns and zero Rust), predictive
layer warming at gesture start, SoA interned patch queues with GPU range application, tile-based
damage compaction, zero-alloc steady-state turns, tape dedup, and layout memo/short-circuits — is
specified per-proposal with mechanisms, honest limits, and CI gates (each with a non-vacuity
half) in [runtime/fastpath.md](runtime/fastpath.md). Everything there is kernel-internal: no
proposal adds a public spelling. The load-bearing risk is named there too: fast-lane
classification must be conservative (escalate unless proven epoch-local) and counter-backed.

The retained plan has credible advantages, each paired with a measurement:

| Architectural advantage | Expected effect | Required proof |
|---|---|---|
| UI-local `!Send + !Sync` graph | No locks/atomics on local state reads, dependency tracking, or queue operations | Same-thread signal/memo microbench and end-to-end input latency versus a thread-safe configuration |
| Two-word `Copy`, `!Send + !Sync` keys | Passing/capturing fields has no clone, refcount, runtime lookup, or subscription cost; resolving requires an explicit capability | Size/alignment assertions, generated-code inspection, compile tests for unconditional `Copy`/`!Send`, stale/runtime mismatch diagnostics, and usability fixtures versus current `cx` spelling |
| Sealed generic `Property<T>` installer | Literals/keys/expressions use one destination method, while mount-time deforestation avoids a universal value enum, box, or retained generic expression | Compile/usability tests, MIR/assembly inspection for common expressions, blueprint compile/code-size gates, zero allocation for constants |
| Effectless direct-field sink slabs | Common field-to-port changes avoid parent routing, a per-property user closure, effect, task, lock, or general graph node | Wire bytes/allocations and mount/update latency by lowering stratum; direct path targets zero per-wire heap allocations after slab growth |
| Contiguous direct field cells | A generated field is already an ordinary source slot; no parent notification, projection node, mask routing, or sibling invalidation | Exact-field versus aggregate draft counters, slot/fanout bytes, and identical-output oracle |
| Sparse two-epoch publication | Logical and presentation faults cannot expose half-mutated state/tree/geometry without copying the clean world | Overlay/shadow bytes, copied records, pins, epoch swaps, dense promotion, fault-at-every-stage oracle, and queued-input latency |
| Direct field-to-obligation map | Paint-only changes cannot enter layout; semantics/event-only changes avoid paint | Per-phase counters remain zero in mutation matrix tests |
| True resident-key updates | One row value can change without O(n) reconcile or remount | 100k-row update counter and preserved state/focus assertions |
| Persistent Taffy with reasoned dirt | Layout visits the dependency closure, not the whole window | nodes-visited and nodes-measured slopes for leaf, intrinsic-size, and root-constraint cases |
| Sparse placement graph | Arbitrary cross-node anchors update only placement descendants and keep normal flow acyclic | anchor-chain depth/fanout slopes, scroll/transform cost, cycle/fallback correctness, paint-hit-a11y epoch agreement |
| Sum-tree text and fragment order | O(log n + changed range) splice/order work | large document edit and large scene reorder slopes |
| Dedicated text-field state | Model echo does not reset cursor/IME; an edit reshapes only its true shaping dependency range—potentially the paragraph, never unrelated paragraphs | correctness fixtures plus text bytes/lines/paragraphs shaped counters |
| CSS-complete IFC + placeholder atoms | Chips wrap/copy/speak as line boxes; spacing/decoration changes emit the declared obligation (paint vs wrap); paragraph isolation holds with atoms | 09 T0–T7; place_in chip is a gate failure |
| Tagged `Color`, extended-linear composite, negotiated surface | Palette swap is paint-only; Oklab mix matches CPU/GPU; a CMS can target one open working contract; default SDR pays no float/HDR/profile/pass tax | color.md C0–C10; cross-backend Oklab/ICC/extended-range goldens; surface bytes/attachments/passes/pipelines |
| Explicit priority lanes | Input/animation work is not queued behind idle derivations | p99 input-to-present latency under saturated idle work |
| Palette-token indirection | A global palette swap can update compact resources and indexed damage without rewriting every consumer property/GPU instance | 10k-consumer swap, opacity-class promotion, damaged area, upload bytes, and equivalent-output oracle |
| Dense time-sampled motion lanes | Thousands of timed/spring/keyframe/gesture tracks share one clock sample and compact typed-port batches rather than thousands of graph effects | 10k active-track phase matrix, interruption/cadence oracle, CPU/GPU work, p99, and final-value oracle |
| Retained canvas/temporal shader graph | Custom graphics can patch typed uniforms/buffer/scene ranges and opt into history/velocity/compute without abandoning damage, resource lifetime, or tooling; absent graphs allocate/dispatch nothing | range/upload bytes, hazards, history generations/budget, attachment/pass counts, readback bounds, pipeline cache/hot reload, device-loss rebuild, damage oracle |
| Shared inspector/test snapshot protocol | Role-based deterministic tests and deep inspection observe exactly the retained epochs users interact with | inspector-disabled overhead, snapshot/delta throughput, locator/actionability races, trace size, reference-renderer determinism |
| Adaptive order/spatial/dense paths | Sparse damage avoids order-tree scans while dense updates retain contiguous throughput | candidate false-positive ratio and sparse-to-dense crossover curves with hysteresis/thrash counters |
| Optional stable GPU slots/range uploads | A small retained change can patch declared GPU ranges without re-encoding/uploading unrelated primitives | dirty/upload bytes, slot churn, fence lifetime, device-loss rebuild, and backend-tier fallback |
| Thresholded immutable stage snapshots | Large text/style/fragment batches can use cores without putting locks in local state | crossover curves, join wait, snapshot bytes, stale discard rate, total CPU/energy |
| Fused typed work edges | One input/output declaration replaces separately configured snapshot, sender, destination state, task, generation, and apply closure; `Send + 'static` is confined to data/callables that actually cross a worker boundary | direct comparison against manual transport for allocations, bytes, freeze copies, wakes, latency, cancellation, and stale-result correctness |
| GPUI entity interoperability | Existing application models need not be cloned into a second global store | allocation/clone counters on migrated Zed-shaped screens |
| Sealed invertible `Delta` + DAG/tracks | Cmd-Z, selective undo, Sudden Termination, and inspector time-travel share one algebra; non-history owners pay zero | H0–H10: tax, oracle, serialisation, composer, selective conflict, IME, canvas scale, collab origin, routing, secrets, panic atomicity |

These are reasons to expect a higher ceiling, not a license to claim victory. zgui already has many
of the same retained optimizations, so beating it will likely come from locality, GPUI's existing
text/sum-tree assets, careful constant factors, and fewer abstractions on the local path.

## 3. Counter contract

Counters are part of the architecture. They are compiled in for tests/profile builds and compiled
out or sampled cheaply in normal release builds. A duration can be noisy; a work count should be
deterministic.

### Reactive and ownership

- state writes, exact versus wildcard deltas, direct/static/dynamic lowerings, distinct dirty nodes,
  computations run/skipped, edges added/removed;
- pending/published logical revisions, presentation epochs, discarded drafts, overlay/shadow bytes,
  pinned epochs, dense promotions, queued-input delay, feedback writes/relayout rounds/cap exhaustion,
  and after-publication effect transactions;
- live and peak property-wire slab bytes, per-stratum mount/update allocations, direct sink runs/skips,
  shared-computed fanout, observer unlink/tombstone/compaction work;
- equality cutoffs, structural regions reconciled, owners mounted/unmounted;
- queued and coalesced wakes, settle iterations, work-budget exhaustion;
- live nodes/owners/effects/work edges/tasks, freeze bytes, work generations/cancellations,
  stale completions rejected, and completions applied;

### Traversal and style

- nodes marked, dirty-child maintenance steps, nodes visited per phase;
- style fields resolved, variant slots merged, style values unchanged;
- accidental root walks and fallback-island rebuilds.

### Layout and text

- Taffy nodes restyled, measured, and laid out;
- layout passes reaching root and geometry-observation passes;
- placement edges visited/resolved/skipped, coordinate transforms, collision fallbacks, constraint
  iterations/faults, and anchor cycles/removals;
- paragraphs/lines/bytes shaped, lines rebroken, cache hits and evictions.

### Scene, input, and accessibility

- fragments rebuilt/replayed/translated/retired;
- primitive bytes encoded/uploaded and bounds/order-tree operations;
- hit entries updated/moved/reinserted and wholesale index rebuilds;
- accessibility adds/updates/reparents/removes and full-tree fallbacks;
- drag sessions started/committed/cancelled, capture changes, target validations/rebases/rejections,
  portal handoffs, pinned rows, keyboard/a11y operations, and pending-validation duration;
- damage rectangles, damaged pixels, overlap contributors replayed, full-damage promotions,
  retained-target valid area/misses, and transform-copy fallbacks.
- spatial candidates queried/accepted, false-positive count/area, sparse/dense promotions, and
  promotion/demotion hysteresis events.
- canvas scene/range rebuilds, shader uniform/storage uploads, pass/resource hazards, pipeline cache
  hits/misses/compile time, hot-reload failures, and custom-pass damage promotions.
- media acquisition/encoded/decoded/resident bytes, stage/cache hits and evictions, decode variants,
  animated/video queue bytes and duration, seeks, late/repeated/dropped frames, import path, plane/
  RGBA copy count and bytes, color conversions, stale-generation rejects, and protected-path denial;

### Renderer and event loop

- draw calls, uploads, atlas hits/evictions/rerasterization;
- frames requested/submitted/presented/skipped and skip reason;
- in-flight frame packets, pinned bytes/resources, fence retirement delay, and recovery reuploads;
- stable primitive-slot writes/reuses/retirements, dirty/upload byte ranges, backpressure turns,
  coalesced packets, and contiguous fallback packets;
- frontend capability decisions and fallback reasons, packet/pass/range lowerings, native import
  leases, device-generation rejects, staging-ring pressure, fence-retired media frames, and full
  replay/reacquisition after device loss;
- idle turns/wakes, timer deadlines, late frames, input-to-present marks.
- motion programs activated/sampled/interrupted/completed, lane bytes, velocity preserves/resets,
  layout-transition fallbacks, and clock deadlines;
- inspector snapshot/delta bytes/time, query/actionability retries, trace bytes, highlighted nodes,
  and inspector-disabled fast-path checks.

### Developer performance

- clean `cargo check`, incremental check after a component edit, optimized build, and test-link time;
- peak rustc memory, monomorphized item count, binary size, and generated-code size;
- rust-analyzer completion/diagnostic latency on representative component files;
- proc-macro expansion time and expansion size for `tw!`/optional component tooling.

Every “work avoided” counter has a paired “work performed” counter and a non-vacuity test that
drives both paths. Live-object gauges are sampled before and after churn to reveal leaks.

## 4. Reference workloads

All reference workloads run headless for deterministic work counts and on at least one real GPU for
latency, presentation, and upload behavior. Inputs use a deterministic clock and recorded event
trace. Release builds use pinned features and allocator. Raw samples, machine metadata, commit,
renderer, and thermal/power state are stored with the result.

1. **Idle/park.** A static window for 60 seconds. Zero frames after exposure settles, zero node
   visits, bounded memory, no polling wake.
2. **Counter locality.** One text value among 10,000 static siblings. One write recomputes one
   derived chain, reshapes/repaints the label only, and leaves layout zero when digit width is fixed.
3. **Hover storm.** Pointer crosses rows at 120/240 Hz. At most old/new row interaction styles,
   fragments, and damage change. Stationary-pointer style changes update the hit result correctly.
4. **Scrolling split.** Measure translation-only frames separately from row recycle frames. The
   translation path performs zero restyle/relayout/re-encode for eligible content and damages only
   the exposed band; recycle cost scales with entering/leaving rows.
5. **100k keyed table.** Independent cases: value update, insert, remove, move, sort-key update,
   filter predicate change, and full replacement. Validate row identity, selection, focus, and
   state. Plot work against total N and changed K.
6. **Variable-height virtual list.** Correct anchoring under late measurement, expansion above the
   viewport, rapid fling, focus/IME pinning, and one extremely tall row.
7. **Editor.** Large rope, single-character edit, multi-cursor batch, syntax-style update, wrap-width
   resize, font change, model echo during IME, and undo/redo. Include one enormous soft-wrapped/bidi
   paragraph to expose the legitimate worst-case reflow. Track shaped bytes and p99 latency.
8. **Kitchen sink.** Menus, overlays, focus traversal, text input, images, animation, drag/drop,
   tooltips, accessibility, and resize in one app. This catches hidden global passes.
9. **Animation tiers.** Color, isolated opacity, transform, placement, layout, and structural
   transition. Each must enter only its required phases.
10. **Churn and teardown.** Open/close windows and mount/unmount resource-heavy views repeatedly;
    late tasks complete after teardown. All live gauges return to baseline.
11. **Cold/warm start.** Separate process cold start, first window, first glyph/image, and warm
    window. Retention must not trade interactive speed for unacceptable startup or resident memory.
12. **Adversarial graph.** Deep chains, wide fanout, diamonds, dynamic edge rewiring, equality
    firebreaks, effect cycle, and starvation pressure.
13. **Developer loop.** A representative small app and large workspace are checked from clean and
    after edits to component body, style literal, generic control, and schema. Store compiler timing,
    memory, binary size, and rust-analyzer sampling. Compare explicit and macro-assisted spelling.
14. **Capability ergonomics.** Compile the counter and editor examples as API tests. Assert that
    state/field keys are unconditionally `Copy`, `!Send + !Sync`, and exactly the declared two-word
    representation; passing/capturing/sealed composition needs no context, while dereferencing has
    no ambient method. `Scope`, `Update`, inferred dynamic `Read`, advanced phase callbacks, and worker
    selection are the only capabilities. Compile-fail attempts to call `state.get/set`, resolve a key
    in layout/paint, use a local key on a worker, write a read-only derived key, or retain a phase
    capability. `update.published(derived)` must not execute a dirty derived node, while
    `update.read(derived)` may demand-stabilize it and `update.before(source)` remains semantically distinct.
15. **Property lowering matrix.** Measure constants, direct scalar/generated-field state,
    sealed static circuits, arbitrary fixed-input maps, and shared dynamic derivations separately at mount
    and update. Record allocations, retained bytes, instructions/time, and work counters. Run direct
    source fanout at 0, 1, and 1,000 sinks; run one shared computed at 1 and 1,000 sinks; churn
    100,000 property wires through mount/unmount and require owner cleanup to return gauges to baseline.
16. **Direct-field precision and drafts.** Apply an exact field edit and an equivalent aggregate
    draft to the same generated group. The exact case writes one cell and reaches only its fanout;
    the aggregate case remains correct and visibly broader. Panic every draft policy and assert the
    published source/derived/structure/port epoch is byte-for-byte unchanged.
17. **Specialized bulk paths.** Swap a palette used by 10,000 paint consumers, including an
    opacity-class promotion; sample 10,000 animation tracks by tier; sweep dirty density from one
    node to the full scene. Store the sparse/dense crossover and ensure hysteresis prevents mode
    thrash.
18. **Spatial and renderer pressure.** Measure spatial candidates/true contributors for clustered,
    overlapping, filtered, and adversarial scenes. Stall renderer fences under repeated mutation;
    assert hard bounds on in-flight versions and pinned bytes, correct damage union, backpressure,
    device-loss recovery, and contiguous fallback.
19. **Reactive competitor constants.** Port the property-lowering matrix to zgui's UI-local/`LocalStorage`
    configuration and to an equivalent Slint 1.17.1 component, in addition to each project's normal
    recommended path. Separate property propagation from renderer costs, then run the end-to-end
    equivalent-feature workload so a microbenchmark cannot hide downstream work.
20. **Protocol, publication, and fault matrix.** Drive a transaction through tracked computation,
    structure, newly introduced properties, sinks, logical publication, after-publication effects,
    presentation staging, and declared geometry feedback. Inject panic/budget/device failure after
    every step. Assert no partial logical epoch, no partial interaction/presentation epoch, exact
    source revision semantics, pinned-owner safety, and the declared coordinate-input queue/retry
    behavior. Exercise same-slot recursive borrow, different-field nesting, feedback-cap exhaustion,
    dense promotion, and draft unwind for every supported draft policy.
21. **Collection threshold and predicate matrix.** Sweep through and around `N_vec`, verifying
    vector versus tree complexity labels, hysteresis, and crossover selection. Compare a sealed
    field-aware predicate/key with an arbitrary closure: the former may update one row; the latter
    must record wildcard invalidation/rebuild instead of claiming O(log N).
22. **Typed work-edge matrix.** Compare `scope.compute/resource/action` with the manual
    snapshot/sender/task/apply baseline for mount bytes, allocations, wakes, freeze copies, and
    completion latency. Exercise latest/reliable/coalescing policies, owner teardown, stale
    completion, cancellation-safe async I/O, non-preemptible and token-cancellable CPU work, worker/
    freeze panic, retry, source-owner dominance, request/generation wrap, and tuple input frozen from
    one pending logical view. Validate every completion stamp and ensure an obsolete result cannot
    clear a newer request's pending/error state.
    Compile-fail local keys/borrows crossing the worker boundary; unit-test each work function with
    no UI runtime.
23. **Retained drag protocol.** Pointer and keyboard moves within/across groups and windows preserve
    keyed owner state and never expose an index. Exercise capture loss, Escape, source/target
    teardown, virtualization pins, preview portals, accessibility announcements, stale-order
    rebase/reject, async validation races, cross-window handoff, and external-drag separation. Count
    hit tests, portal remounts, pinned rows, order operations, damaged area, and pending duration.
24. **Arbitrary placement graph.** Chain and fan out anchors across unrelated subtrees, portals,
    transforms, nested scrolling, writing direction, scale and safe areas. Remove/change anchors
    during dispatch and exit motion; inject a mutual cycle and an unsatisfied local constraint group.
    Assert sparse edge visits, explicit fallback, and identical paint/hit/accessibility geometry in
    one presentation epoch.
25. **Motion semantics.** Sample timed, spring, keyframe, gesture, FLIP and shader-uniform motion at
    60 Hz, 120 Hz and irregular timestamps. Interrupt every tier, preserve/reset spring velocity,
    toggle reduced motion/background suspension, and compare with a scalar from-scratch oracle.
    Sweep 1–100k active programs and record lane crossover, allocations and phase obligations.
26. **Canvas/shader/temporal render graph.** Patch one uniform, one storage range, one mesh range and
    a full canvas; exercise clip/blend/backdrop damage, pass hazards, pipeline churn, invalid hot
    reload, oversized input, stalled fences and device loss. Run current→history→compute→composite
    at 1x/1⁄2x/1⁄4x, including dropped-frame generation, resize/profile reset, optional velocity,
    occlusion and bounded readback. Compare retained scene/output to the software/pass oracle,
    require bounded resource versions/uploads, and prove a graphless scene has zero temporal
    resources/attachments/passes/frame requests.
27. **Inspector and integration harness.** With inspection disabled, prove no added hot-path node
    allocation or traversal. With it enabled, measure full snapshot/delta/query/highlight throughput
    and bounded history/trace size. Race locator resolution with remount, overlays and animation;
    require semantic actionability and real hit routing. Replay the same input/work/clock trace twice
    under pinned fonts/reference rendering and require identical epochs, scene, a11y, events and pixels.
28. **Generic image pipeline.** Load identical bytes from an embedded asset, filesystem path, plain
    URL request, customized HTTP request, in-memory buffer and application provider. After
    acquisition, require the same parse/decode/variant/residency decisions and pixels. Exercise
    progressive and truncated input, validators/`Vary`/redirect/no-store/auth partitioning, source
    replacement races, visibility priority, scale changes, huge tiled images, SVG, ICC/orientation,
    cache collisions, eviction and device loss. Animated GIF/WebP/AVIF must remain inside a decoded
    byte/time window under stalled presentation; compare startup and peak memory against eager-all-
    frames decode.
29. **Video/import/frontend matrix.** Feed deterministic RGBA, NV12 and three-plane frames through
    software upload and every native import capability on Metal, DirectX and wgpu where available.
    Exercise crop/orientation/aspect, full/limited range, 601/709/2020 matrices, SDR/HDR transfer,
    pause/rate/loop/seek, A/V drift, occlusion, decoder/renderer backpressure, protected content,
    stalled fences, surface/device loss and decoder-pool exhaustion. On the proven fast path require
    zero CPU pixel copies and zero extra full-frame GPU copies; on fallback require an exact reason
    and counted bytes. A one-frame advance must patch one media resource/fragment and its damage,
    with zero fixed-geometry layout, unrelated graph work or whole-scene re-encoding.
30. **Backend frontend equivalence.** Replay the same recorded `FramePacket` stream through the
    reference, Metal, DirectX and wgpu frontends. Sweep every independent capability bit rather than
    one global tier, including `SdrSrgb8` and preferred/required `ExtendedSrgb16`. Run the color.md
    ICC/negative/>1/reference-white/display-move/tone-map corpus; require equivalent retained
    scene/color results, bounded packet/resource pins, per-operation fallback, no per-primitive
    dynamic dispatch in profiles, and full recovery from a device-generation change. Compare
    whole-`Scene` legacy submission against range/delta lowering to prove that frontend abstraction
    did not erase the intended CPU/upload wins. The SDR run must keep surface bytes, attachments,
    pass count, lazy pipeline creation and clean-frame work equal to a build with extended/CMS
    features unused.
31. **History / undo algebra.** Non-`History` owners: zero track-arena bytes under a 10k-click
    script (H0). Sealed-delta oracle: apply/invert/redo against a checkpoint for List, Replace,
    TextEdit, Chrome/Grid, Stroke (H1). Composer: type / Cmd-Z / type / Send / Cmd-Z restores
    the draft / Cmd-Shift-Z restores Send (H3). Selective: rename A then move B, `undo_node(rename)`
    keeps the move; add-column then move-into-it `Conflict`s with both nodes named (H4). IME
    composition open: Cmd-Z cancels composition and does not apply a document inverse (H5).
    Canvas: 100k strokes, undo last = one `ListDelta`, one damage region, track memory O(tagged
    strokes) not O(samples) (H6). FileStore: kill after a tagged Point, relaunch, cursor and
    meta restore; Silent in-flight drag does not resurrect (H2). Collaboration: remote inserts
    do not appear on the local track; transform conflict is `Conflict`, not clobber (H7).
    Routing: inspector vs document vs chrome union (H8). Secrets never appear in snapshot bytes
    (H9). Panic inside `commit` publishes nothing (H10). Count deltas captured/tagged/coalesced,
    arena bytes, fsync count, transform/conflict reasons. Compare against an NSUndoManager-shaped
    closure baseline on serialisation size and recover-after-kill (the closure baseline must
    *fail* recover — that is the point).

## 5. Gates by milestone

Exact latency thresholds must be calibrated on dedicated CI hardware, but semantic work gates are
fixed now.

### Correctness gates

- deterministic screenshots and event/a11y traces match the legacy path for ported fixtures;
- no stale handle, late resource completion, or duplicate key corrupts another owner;
- no paint observes an unsettled graph or half-applied structural transaction;
- geometry feedback may write only sealed layout-feedback cells with no route into general
  properties/derived/structure/style/effects, and either converges inside its cap or drops the
  presentation draft with a trace;
- a failed source/derived/structure/port draft never advances the logical epoch; a presentation fault
  preserves the prior coherent interaction/frame while retaining the already published logical epoch;
- IME, focus, pointer capture, drag, and accessibility survive legal virtualization/reorders;
- placement, paint, hit testing and accessibility publish one geometry revision; missing/cyclic
  anchors take the declared fallback without a partial presentation;
- motion at the same timestamp is cadence-independent, interruption is continuous under its declared
  velocity policy, and reduced motion reaches the same logical target;
- shader/pass validation, device loss, and invalid hot reload cannot expose half-updated resources;
- a stale media source/seek/device generation cannot publish pixels or release a newer request's
  pending state; imported planes remain owned through GPU completion and return exactly once;
- image/video crop, orientation and color conversion match the reference policy; protected media is
  never exposed through readback, inspector transport or an unsupported custom pass;
- inspector/test input uses real routing and a snapshot never resolves a stale generation;
- damage promotion is conservative: artifacts are never accepted as a performance trade;
- undo/redo is an ordinary transaction with `Origin::Undo`/`Redo`: IME echo rules hold,
  two-way controls do not journal the restoration, FileStore recover-after-kill restores
  tagged nodes only, and a `Conflict` from selective undo names both nodes.

### Complexity gates

- idle work is O(0) after settling;
- a paint-only leaf update performs zero style-tree traversal and zero layout;
- a resident-key update to non-membership/non-order fields is independent of total row count except
  expected O(1) key lookup; a sealed field-aware filter/sort-key update in the promoted tree tier
  is O(log N) plus affected movement/layout;
- a structural list splice is O(log N + K + affected order/layout), not O(N), on `KeyedList`;
- O(log N) collection claims apply only after the measured tree crossover; vector-tier and arbitrary
  predicate/sort work remain explicitly O(N)/wildcard and are not reported as scalable wins;
- offscreen unpinned virtual rows have zero property observers and zero paint fragments;
- translation-only scroll is independent of total document size;
- one anchor movement is proportional to its placement descendants, not the full layout/tree;
- one canvas uniform/range edit does not rebuild unrelated scene ops or render passes;
- a warm static image schedules no acquisition/decode/upload work; a video frame update is
  proportional to its resource patch and intersecting damage, while decoded queues and caches stay
  within byte/time budgets under backpressure;
- an unsupported media import falls back for that resource without globally demoting unrelated
  retained rendering, and backend selection adds no per-primitive virtual dispatch;
- inspector-disabled complexity and allocations match the non-instrumented retained path;
- live memory after churn returns to a statistically stable baseline;
- a non-`History` owner performs zero history work per write (H0); a journaled `List` op
  allocates at most one small-object node per *tagged* gesture, not per mutation; linear
  undo/redo is O(delta apply) and uses the ordinary publish/damage path; selective undo is
  O(later tagged nodes × transform), not O(document); 100k-stroke undo is one `ListDelta`.

### Competitive gates

For each ported competitor workload, run both binaries in randomized A/B order on the same machine,
resolution, refresh target, font set, content, backend where possible, and optimization settings.
Report median, p95, p99, max, allocations, resident memory, work counters, damaged pixels, upload
bytes, and energy when available.

“Surpasses” requires all of the following, not one favorable median. “No feature reduction” means
equivalent behavior inside each ported workload; it does not require GPUI to reproduce every API or
CSS feature in a competitor's full inventory:

- no correctness or feature reduction;
- no worse asymptotic work slope on any locality workload;
- lower p50 **and** p99 input-to-present for the target workload, outside noise confidence;
- no material regression in cold start or steady memory without an explicit accepted trade;
- no material regression in incremental compile/rust-analyzer latency or binary size without an
  explicit accepted trade and a non-generic escape hatch;
- no hidden work migration from CPU to upload bandwidth, GPU passes, background threads, or later
  recycle frames;
- results reproduced on two hardware classes before marketing language is used.

The counter fixture specifically requires `static_circuit_evals=1`, `sink_patches=1`, and
`dynamic_computed_runs=0`; it must not relabel a sealed circuit evaluation as a direct sink run.

zgui is the primary retained competitor. Floem is the primary Rust-native reactive/list competitor;
Xilem is the structural diff competitor; Leptos is the API/reactive-graph competitor; Haalka/Jonmo
is the retained ECS and diff-stream correctness competitor; Slint is the compiler-specialized
property-graph and compile-time purity competitor. Web DOM results are reported separately because
browser layout/rendering is not the same backend.

## 6. Failure criteria

Stop and redesign a layer if any of these persist after profiling:

- dirty-node discovery walks the clean tree;
- reactive bookkeeping costs more than the avoided stage work on common leaf updates;
- retained metadata or caches grow without enforceable budgets;
- keyed updates remount resident rows or virtualization breaks platform text/focus protocols;
- damage bookkeeping routinely collapses to full-surface work;
- the compatibility island becomes the dominant implementation rather than a migration boundary;
- a proc macro is required to obtain the promised runtime complexity.

The point of this contract is to make an ambitious design disprovable early. If a chosen mechanism
fails, keep the locality, UX, and integration goals and replace the mechanism.
