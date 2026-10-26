# Comparison and Final Recommendation

The four approaches are useful probes, not four implementation choices. Rechecking current zgui,
Floem, Xilem, Leptos, Haalka, Jonmo, PanGui, Lilt, Taffy, browser tooling, and GPUI's actual lifecycle invalidated important parts
of every first draft. The final plan is [03-hybrid-plan.md](03-hybrid-plan.md).

## What survives

| Exploration | Keep | Reject or narrow |
|---|---|---|
| A — signals on GPUI | Copyable typed state keys, owner scopes, generic property installation, host-driven flush, legacy entity bridge | Property patching cannot be built on frame-arena elements plus `with_element_state`; retention must land first. No owning/refcounted public signal wrapper and no unmeasured `10–100x` promise. |
| B — branded world | Phase capability contexts, local `!Send` storage, keys that require authority to resolve, and mandatory internal branded arena views after generational-id validation | No public `'ui` lifetime through every app/window/callback, process-global/TLS runtime, ambient key reads, or separately paired read/write projections. No claim that multi-callback focus/drag protocols become purely session typed. |
| C — attribute graph | Retained nodes, per-property dependencies, equality cutoff, explicit structural reconciliation, persistent layout/scene state | No universal MVCC, type-level durability lattice, or source-compatibility claim between old signals and versioned state. Background snapshots are opt-in. |
| D — compiled UI | `tw!` literal proc macro, compile-fail diagnostics, possible later sugar over explicit primitives | No macro-first runtime, token-only claim of complete dependency inference, or requirement that arbitrary builder chains const-fold. |

## High-level API models considered

### 1. Reinvoke-and-diff

State change calls application/view logic again and diffs a new typed tree against retained widgets
(Xilem/SwiftUI-shaped). This makes structure natural and plain Rust values easy, but ordinary
property updates still pay view construction/diff unless memoized. It remains the structural-region
algorithm, not the normal property-update algorithm.

### 2. Reactive holes in a retained tree

A component runs once and closures/signals update selected attributes (zgui/Leptos-shaped). This has
excellent update locality but makes static versus live spelling a semantic hazard if raw closures
are overloaded. GPUI adopts the mechanics with one sealed `Property<T>` installation surface and
explicit `show`/`switch`/keyed structure.

### 3. Retained widgets with message/update methods

Each widget owns state and handles typed update messages (Floem/Elm-shaped). It gives control and
good custom-widget performance, but propagating arbitrary derived values becomes boilerplate. GPUI
keeps retained node update slots beneath a compositional state graph.

### 4. ECS components plus signal systems

Properties are ECS components and reactive tasks mutate entities (Haalka/Bevy-shaped). It has strong
ownership/query tooling but would duplicate GPUI's entity and rendering model and can scatter phase
invalidation across systems. The plan borrows owner cleanup and stable identity, not an ECS rewrite.

### 5. Snapshot/MVCC state

Every read occurs in a versioned snapshot and writers merge/apply records (Compose-shaped). This is
valuable with concurrent writers and speculative computation, but a single UI writer already gets
coherent frames from phase barriers. GPUI exposes explicit immutable background snapshots with
version/conflict policies instead of taxing every state value.

### 6. Macro/compiler-owned components

A macro rewrites reads, writes, slots, keys, and skip groups (Compose/Svelte-shaped). Stable proc
macros see syntax, not resolved program semantics. A small literal parser such as `tw!` is robust;
general component rewriting is optional and last, after explicit primitives are proven.

## The selected hybrid

```text
plain Rust component, mounted once
          |
          +-- constant Property ------------------------+
          +-- direct generated field key -> typed port -+
          +-- sealed opaque expression -> circuit slab -+
          +-- fixed/dynamic user derive -> graph -------+
          +-- delta list/text -> specialized operator --+
          +-- show/switch/keyed -> structural reconcile |
                                                       v
retained node + owner arena
  -> exact obligation / dirty-child summaries
  -> persistent Taffy / hit index / accessibility
  -> retained scene fragments + sum-tree order
  -> spatial damage + persistent renderer target
  -> bulk FramePacket frontend + per-operation capabilities
  -> optional stable GPU-slot range patches / native media imports
```

The order is load-bearing: retained identity precedes direct reactive bindings. Otherwise the
runtime merely optimizes values on elements that the next frame discards.

Default state is UI-thread local. Cross-thread one-result work normally uses
`compute/resource/action`; raw sender/snapshot plumbing is the stream/service escape hatch. Two-word
`Copy`, `!Send + !Sync` keys own nothing and have no ambient read/write methods;
`Scope`, `Update`, or inferred dynamic `Read` supplies the runtime and authority when storage is
actually accessed. Generated model bundles expose direct field keys with member syntax, and builder
expressions are deforested at mount using a sealed generic installer plus stable precise
`use<…>` captures. Editable destinations consume one key (`text_editor(document)`,
`checkbox(todo.done)`), not separate value/binding calls. Phase contexts constrain APIs
without exporting a viral brand. Structural operations are
keyed and have specified reset/keep-alive behavior. Arbitrary placement, text input, virtualization,
work, motion, generic staged image/video media, canvas/shaders, inspection, and deterministic testing are first-class retained
protocols rather than examples assumed to generalize from a counter.

## Why this is the long-lived choice

- The public vocabulary is independent of graph storage, order structure, renderer, and macro
  strategy, so internals can change after profiling.
- Correctness has full recompute/full damage fallbacks while incremental results are validated.
- Stable Rust is enough for every required semantic; nightly features are optional experiments.
- GPUI's valuable existing assets—entities, builder styling, text caches, sum trees, custom paint,
  and platform integrations—remain usable.
- Performance is defined by phase/work/latency/memory gates in [performance.md](performance.md), so
  the project can replace a clever mechanism that fails without abandoning its goals.

## Precise competitive hypothesis

| Reference | What it already does well | What this design must add to win rather than imitate |
|---|---|---|
| zgui | End-to-end retained document/layout/paint/hit state, damage, persistent pixels, and strong locality instrumentation | Refcount-free keys, direct field-cell fanout, mount-time expression deforestation, sparse atomic logical/presentation publication, diff-native resident updates, palette/vector-animation specialization, and later stable GPU range patches—then prove lower p50 and p99 on identical workloads |
| Floem | Retained ids/layout, direct reactive updates, keyed stacks, and variable-height virtualization | Avoid whole-vector work on the scalable lane, preserve resident-row identity on value updates, and carry locality through damage/pixels/text |
| Xilem | Strong typed build/rebuild/teardown and structural sequence mutation | Keep those strengths inside explicit structural regions while ordinary property changes perform no view regeneration/diff |
| Leptos | Mature compositional signals, owners, resources, and keyed iteration | Make local native storage and explicit thread crossing the default; give retained ports/layout/damage first-class typed consequences |
| Haalka/Jonmo | Retained ECS ownership, reactive builder coverage, vector diffs, and working text integration | One literal/reactive surface, exact resident-key updates instead of remount-on-`UpdateAt`, and native IME/text revisions without general ECS work for leaf ports |
| Slint | Compiler-owned pure bindings and a highly specialized generated property path | Approach its constants with generated ports/direct slabs while preserving ordinary host Rust and an explicit dynamic-computation escape hatch; treat its compiler specialization as a serious constant-factor bar |
| PanGui | Unusually flexible node-relative position/size, overlays, layout blending, direct graphics commands, and injectable input | Match the expressive results with a sparse retained placement graph, portals, typed canvas/render passes, and deterministic real input routing; do not treat its closed-alpha C# claims as comparative benchmark evidence |
| Lilt | Small stable-Rust transition values with cadence-independent sampling and natural interruption | Preserve the plain time-sampled UX while adding dense springs/keyframes/gesture/FLIP, destination-aware invalidation, shader/uniform lanes, injected clocks, and retained owner lifetime |
| Browser devtools/Playwright | Deep multi-tree inspection, node highlighting, semantic locators, actionability, auto-retry, traces and screenshots | Expose the actual retained epochs through one opt-in snapshot/delta protocol shared by inspector and `UiTest`, with no shadow UI or direct-callback test shortcuts |

Renderer and media comparisons are deliberately end-to-end. GPUI's Metal, DirectX and wgpu
frontends must consume the same immutable packet/resource protocol while retaining native allocation,
binding and external-plane specialization. Static-path and HTTP images must converge after
acquisition; animated images must beat eager-all-frame retention in startup and peak memory; video
must prove bounded decode and counted zero-/one-copy behavior. These are workloads 28–30 in
[performance.md](performance.md). Until they pass alongside the locality suite, the plan predicts a
higher ceiling than zgui and the other references—it does not claim measured superiority.

These are hypotheses about removed work, not benchmark results. The property-lowering matrix and equivalent-
feature end-to-end gates in [performance.md](performance.md) are allowed to reject any mechanism,
including one that appears more advanced in the type signatures.

See [migration.md](migration.md) for the dependency order and exit criteria. See
[00-research/06-competitive-update.md](00-research/06-competitive-update.md) for the pinned
competitive corrections.
