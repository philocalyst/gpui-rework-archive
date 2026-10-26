# GPUI Retained Reactivity Design

This packet proposes a retained, fine-grained GPUI architecture on stable Rust. It is intentionally
greenfield at the substrate and compatible at explicit boundaries.

> **The consolidated final proposal lives in [final/](final/)** — twelve documents
> (constitution, statutes, runtime model, gate registry, roadmap) synthesized from the whole
> pass series and adversarially reviewed. Read `final/00-model.md` first. Everything below —
> the numbered passes 01–19, the research surveys, and the runtime experiment docs — is the
> decision record and evidence base behind it; where a pass and `final/` disagree, `final/`
> wins (its `00-model.md §9` records every deliberate conflict resolution).

## Read in this order

1. [07-the-ladder.md](07-the-ladder.md) — **the normative public surface**: one spelling, four
   prices (`T` / `Signal<T>` / `List<T>` / `Entity<T>`), the star/ampersand read law
   (`Deref`/`DerefMut` on cells: a starred read is recorded and rung-0, an ampersand is a live
   wire, a write never compiles in `view`), the routing law, protocols, motion,
   windows, history, canvas/media/placement/shaders, text (§19), the closed macro law, the
   competitive steelman, and the closed-holes map (feedback 1–3). Where anything else
   disagrees, 07 wins.
2. [01-problem.md](01-problem.md) — the audited cost and lifecycle of current GPUI.
3. [02-principles.md](02-principles.md) — invariants and honest limits.
4. [05-one-register.md](05-one-register.md) — the proofs and rationale behind 07: the triad,
   the no-skip proof, sealed-trait machinery, pockets, walls, gates.
5. [06-cross-cutting.md](06-cross-cutting.md) — the protocol catalog (selection, grids, trees,
   docking, gestures, container queries, live regions, theme).
6. [08-history.md](08-history.md) — **undo/redo/persistence as the `gpui_history` crate** over
   the kernel's delta log (07 §15 owns the split): CoreObject's capture-vs-tag split encoded as
   library traits; a revision DAG plus activity tracks; selective undo, Sudden Termination,
   collaboration origins. Closures never enter the journal; the kernel never links it.
7. [09-text.md](09-text.md) — **text**: CSS-complete inline formatting (spacing, decorations,
   fill/stroke, wrap, writing-mode) plus placeholder atoms so inline chips are line boxes, not
   overlays. Hole 13 is this contract, not a reactivity wall.
8. [performance.md](performance.md) — what “surpass” means and how it is proven.
9. [migration.md](migration.md) — Part I: the concept map for existing GPUI apps; Part II:
   dependency order, exit gates, and fallback removal.
10. [10-from-cx.md](10-from-cx.md) — **why `cx` is gone**: where it was actually more
    expressive (cross-entity peek/poke, constructor-time subscribe, async fan-out, globals,
    entity→window reverse lookup), the hardest Zed-shaped ports (editor triangle, workspace
    items, collaboration, settings/keymap), how references exist without a context (fields,
    wires, slots, `Target`, mount-path events, tasks), and the typing / data-structure
    decisions as they stand after 07.
11. [pr-plan.md](pr-plan.md) — **the PR-by-PR migration of the GPUI codebase itself**: 12
   tracks, ~100 sequenced PRs against the real crates (`gpui`, `gpui_elements`, `gpui_media`,
   `gpui_scheduler`, `gpui_wgpu`, `gpui_macros`, …), from conformance fixtures and the
   `LegacyView` island through the kernel, surface, text/history/motion tracks, up to the
   fastpath mechanisms — with flip points and where each L-gate becomes a required CI job.

Historical (kept as decision record; do not learn API spellings from them):
[03-hybrid-plan.md](03-hybrid-plan.md), [04-less-is-more.md](04-less-is-more.md) (still normative
*below* the authoring seam: pipeline, turn protocol, retained machinery), and
[examples.md](examples.md) (03-era sketches; current examples live in 07 §5 / §11 / §15 / §16 / §19
and the migrated GPUI screens in [examples/](examples/) (`hello_world`, `app`, `text`,
`transition`, `blur`, `haptic`, `animation`, `image`, `image_slice`, `pointer_follow`,
`docking`, `example_input`, `identity`, Typeahead, kanban-shaped
interactive demos).

Detailed contracts:

- [runtime/scheduler.md](runtime/scheduler.md)
- [runtime/fastpath.md](runtime/fastpath.md) — the zgui-and-beyond mechanism plan: the
  presentation-resident input loop, predictive layer warming, SoA patch queues, damage
  compaction, zero-alloc turns, tape dedup, layout fast paths — all kernel-internal, each
  with a gated, non-vacuous CI claim
- [runtime/datastructures.md](runtime/datastructures.md) — the measured, adopted
  representations for every fundamental structure (Signal cell at 4 B overhead, packed
  niche-free `Slot`, flattened SoA display store, contiguous List + slot directory, tape
  spans, CSR-cached subscribers, hasher mandate), with the runnable experiment lab noted
- [runtime/memory.md](runtime/memory.md) — minimal footprint and zero steady-state
  allocation across the whole pipeline: state inline in owner structs, transient elements,
  reused arenas with learned size classes, the memory ledger, history spill, M-gates
- [runtime/collections.md](runtime/collections.md)
- [runtime/media.md](runtime/media.md)
- [runtime/color.md](runtime/color.md) — tagged author colors, linear extended-sRGB working light,
  opt-in float16/HDR surfaces, an application/CMS profile boundary, tokens, and the
  Metal/HLSL/wgpu transfer-function split
- [style/README.md](style/README.md)

The four [approaches](approaches/) are preserved design explorations. Their READMEs now state which
parts were selected and which claims were rejected. Their Rust files are syntax sketches, not code
that compiles against current GPUI.

The original source surveys live in [00-research](00-research/). The latest focused updates are the
[competitive audit](00-research/06-competitive-update.md) and the
[async/interaction UX survey](00-research/07-async-and-interaction-ux.md). The focused
[placement/motion/rendering/tooling survey](00-research/08-placement-motion-rendering-tooling.md)
records the PanGui, Lilt, Web Animations/View Transitions, Motion values, Shading Motion,
browser-devtools, Playwright, and shader-validation implications. The
[renderer frontend/media audit](00-research/09-render-frontends-and-media.md) connects current GPUI
image/surface ownership to native Metal, DirectX, wgpu and WebGPU constraints. The
[elegance / fast-path survey](00-research/10-elegance-and-fast-paths.md) is the research that
[05-one-register.md](05-one-register.md) absorbed: closures-as-scopes, `impl Element + '_`,
staged writes, effects, and zero-cost 03 paths (verified on rustc 1.97.1). Application code
never writes `use<..>`. The
[higher-tier cross-cutting survey](00-research/10-cross-cutting-higher-tier.md) mines shipping
systems for upgrades to [06-cross-cutting.md](06-cross-cutting.md) that 06's four projections
still underspecify. The
[history and competitive steelman](00-research/11-history-and-competitive.md) records the
EtoileUI/CoreObject, Yjs/Lexical, Rosin, Ripple/React, Solid 2, and Svelte 5 sources that
[08-history.md](08-history.md) and [07 §17](07-the-ladder.md) absorbed. The
[color-space audit](00-research/12-color-spaces.md) is the source for
[runtime/color.md](runtime/color.md). The
[Iced / Slint / Bevy / GPUI type audit](00-research/13-iced-slint-bevy-gpui-deep.md)
is the source for 07 §17.5 / §17.8 / §17.9's second pass: 9-slice and tiled images,
viewport units, sash leeway, Flickable delayed-arm, pointer as a placement port, and
the GPUI internals (`deferred`, `HitboxBehavior`, `StyleRefinement`) we already had.

## Decision in one paragraph

Retain window nodes, owners, layout, input/accessibility state, scene fragments, spatial damage
index, and renderer damage first. Then use one copyable, generational `State<T>` key and a sealed
compile-time `Property<T>` installation protocol. Generated models expose ordinary typed field keys,
not public field enums or projection objects; mount deforests temporary Rust expression types into
constants, direct field slabs, sealed circuits, fixed/dynamic derived slots, structural regions, or
typed delta operators. Keep branding and frame typestate inside contained arena/phase operations.
Keys own nothing and cannot dereference themselves: `Scope` creates/initializes, `Update` reads and
stages rollback-safe writes, and an inferred dynamic `Read` records arbitrary dependencies. This
removes handle cloning, refcounts, ambient runtime lookup, and forbidden-phase snapshot reads at
once; no process-global or TLS-selected runtime is introduced. Cross threads normally through one
typed `compute/resource/action` work edge that owns freezing, cancellation, revisions, and delivery;
raw messages remain a stream/service escape hatch. Preserve GPUI's fluent styling and entity
integration; make arbitrary anchor placement, text editing, keyed virtualization, callback-free
keyed drop mutation, resources, palette-aware styles, time-sampled motion lanes, retained canvas/
shader passes, generic staged image/video acquisition, native renderer imports, a web-grade
inspector protocol, deterministic integration testing, instrumentation, and cache budgets
first-class. Treat full
recompute/full damage as correctness oracles during rollout, not the normal architecture.

Every host turn drafts write-incapable tracked computations, structure, introduced properties, and
compact sinks, then atomically publishes one logical epoch. Effects run afterward and can start a
new update wave. A separate sparse presentation draft performs style, layout, sealed bounded
geometry feedback, hit/a11y/prepaint/paint/composite, then atomically publishes the coherent
interaction/presentation epoch before submission. This ordering is normative in
[03-hybrid-plan.md](03-hybrid-plan.md) and [runtime/scheduler.md](runtime/scheduler.md).
