# 01 — The Problem: What GPUI's Update Model Costs Today

Status: current-substrate audit and problem statement. The architectural answer is
[03-hybrid-plan.md](03-hybrid-plan.md). Counts and file references below are pinned to the audited
commit and must be refreshed before implementation work uses them as a baseline.

Everything in this document is grounded in a source-level audit of this repo
([00-research/03-gpui-internals.md](00-research/03-gpui-internals.md)); file:line references
point at the code as of commit `b172d695cd`.

## The model in five sentences

All entity state lives in a single app-owned `EntityMap` (`Box<dyn Any>` values keyed by
`EntityId`); an `Entity<T>` handle is an `Rc`-like refcounted pointer that grants no access
without a live `&App`/`Context<T>`, and mutation works by **lease** — the value is physically
removed from the map for the duration of an `update` closure, so any reentrant access hits an
empty slot and panics at runtime. Change propagation is coarse and two-layered: `cx.notify()`
either directly marks a whole window dirty (if the entity was read during that window's last
render — tracked by diffing a global read-set around render, not by a static graph) or queues an
`Effect::Notify` drained by `flush_effects` at the end of every `App::update` transaction.
Rendering is whole-window: any notify marks the window dirty, and `draw_roots` reconstructs the
**entire element tree from the root** — re-running `Render::render()` for every non-cached view,
reallocating every element in the frame arena, and rebuilding the whole Taffy layout tree from
scratch. The only finer-grained mechanism is the opt-in `.cached(style)` wrapper, which checks a
single per-entity `dirty_views` flag to skip-or-redo an entire subtree. There is no signal, memo,
derived-value, or per-field dependency tracking anywhere in the codebase.

In the *Build Systems à la Carte* taxonomy (Mokhov, Mitchell, Peyton Jones — see
[00-research/05-papers-crossdomain.md](00-research/05-papers-crossdomain.md) §7.5), this is the
crudest possible cell: **dirty bit, restarting scheduler, whole-window granularity.**

## The pain points

1. **Runtime-only exclusivity.** Double-lease and read-while-updating are panics
   (`"cannot update {type} while it is already being updated"`, `app/entity_map.rs:206-212`),
   discovered at runtime, often only on the code path a test didn't cover. Rust's whole premise —
   aliasing checked at compile time — is re-implemented as a dynamic check and paid for on every
   access. The retained plan does not claim that a public generative lifetime can replace every
   dynamic entity/window handle; it uses phase capabilities and contained internal proofs while
   improving runtime diagnostics for the irreducibly dynamic cases.

2. **Coarsest-possible invalidation.** One keystroke in one text field re-renders every visible
   view in the window, rebuilds the full Taffy tree, and reallocates the element arena. The
   framework's own answer, `.cached()`, is manual, whole-subtree, and easy to invalidate
   accidentally.

3. **Styles are recomputed from scratch, three times per element per frame.** The refinement
   chain (`div.rs:3273-3393`) runs during layout, prepaint, and paint with zero memoization.
   The `Cascade<S: Refineable>` type in `gpui_refineable` — which is exactly a priority-slot
   merge container — exists and is unused for `Style`.

4. **Dependency discovery is a diff, not a graph.** "Which entities does this window depend on"
   is computed by recording every entity read during render and diffing the set afterwards
   (`app.rs:1097-1140`). It is whole-render-granular, rebuilt every frame, and invisible to the
   type system.

5. **The `cx` surface.** The audit found 203 occurrences of `&mut Context<T>` / `&mut App` /
   `&mut Window` across
   278 public functions in the five core app/entity files. Every helper function, every event
   handler, every async continuation threads a context parameter whose only job is to reach the
   one true `App`. Some of that is ceremony; some is an important explicit capability and runtime
   identity. The plan narrows contexts by phase rather than pursuing “no `cx`” as a goal.

6. **Stringly element state.** Cross-frame element state is keyed by `GlobalElementId` paths of
   author-assigned `ElementId`s. Collisions corrupt state silently (documented in
   `view.rs:182-195`); duplicates panic.

7. **Ambient globals with no init-order enforcement.** `cx.global::<T>()` panics with
   `"no global registered of type {type}"` — a runtime crash for a mistake (using a subsystem
   before initializing it) that a type system can trivially make unrepresentable
   (see the typestate sketch in [00-research/04-rust-frontier.md](00-research/04-rust-frontier.md) §7.4).

8. **Phase invariants vanish in release builds.** "This method can only be called during paint"
   is a `debug_assert!` over a runtime `DrawPhase` enum (`window.rs:1282` ff). In a release
   binary the invariant is enforced by nothing at all.

9. **The reactive-closure footgun doesn't exist here — because nothing is reactive.** Every
   framework surveyed shares one silent bug (`{signal.get()}` vs `{move || signal.get()}`);
   GPUI's version is worse: *all* reads are the frozen kind, and freshness is recovered by brute
   force (re-render everything).

10. **Media ownership is fragmented across widgets, caches, scenes, and backends.** `ImageSource`
    switches among resources, decoded images and a `Window`/`App` closure; animated formats retain
    decoded frame vectors; `ImageCacheItem` manually polls a shared task; and `SurfaceSource`/
    `PaintSurface` expose a macOS pixel buffer or a type-erased wgpu texture in core UI types.
    `PlatformWindow::draw(&Scene)` then hands each backend the monolithic scene. This provides no
    common byte/time budget, source-generation protocol, renderer import lease, or generic path from
    embedded/file/HTTP/provider acquisition through decode and device residency. The detailed audit
    is [00-research/09-render-frontends-and-media.md](00-research/09-render-frontends-and-media.md).

## What the seams give us

The same audit found eight integration seams (03-gpui-internals.md, "integration seams") that
make this tractable rather than a rewrite-from-orbit. The load-bearing ones:

- `#[derive(Refineable)]` already mechanically enumerates every style field → the natural place
  to emit per-field dirty bits/generation counters.
- `.cached()` + `dirty_views` + `DispatchTree::reuse_subtree` is a mature, tested compatibility
  oracle and a source of reuse semantics. It is still whole-subtree reuse, not the final retained
  property model.
- `Window::with_element_state` is a useful cross-frame auxiliary-state slot. It does **not** retain
  the frame-arena element, its Taffy node, or all downstream records, so a signal cannot patch those
  destinations after the frame ends. Retained nodes must land before direct property bindings.
- The `Effect` enum / `flush_effects` loop is extensible and already provides batching, dedup,
  and reentrancy handling.
- `accessed_entities` read-set recording is a (coarse) tracking scaffold that can be narrowed
  from entity-level to signal-level without changing the trigger mechanism.
- New crates can isolate graph/style/benchmark machinery, but the retained identity, persistent
  layout, dispatch, scene, and damage work necessarily changes `crates/gpui` core. Given the
  greenfield mandate, correctness and architecture outrank minimizing that diff; `gpui_web`,
  headless, and GPU backends remain conformance targets.
- The existing Metal Core Video path proves native-plane rendering is viable, while the DirectX and
  wgpu surface paths expose the portability gap. They become backend implementations of one typed
  import/fence contract rather than platform variants carried through the core scene.

## The revised bar

"Fine-grained" means per-property and per-structural-region at the authoring layer, but it must hold
all the way down: bounded dirty traversal, persistent layout, incremental text, retained dispatch
and accessibility, fragment reuse, and damaged-pixel presentation. Per-glyph reactive nodes remain
unnecessary; text uses rope/range/line granularity.

Current zgui already implements a deeply retained and instrumented pipeline, while Floem already
has retained views, persistent Taffy nodes, keyed stacks, and variable-extent virtualization. The
bar is therefore not “add signals” or “avoid a full render function.” It is the correctness,
complexity, tail-latency, allocation, memory, and damage contract in
[performance.md](performance.md), verified against pinned competitor revisions in
[00-research/06-competitive-update.md](00-research/06-competitive-update.md).

## Greenfield implication

Compatibility is a bounded island, not the architecture. Major refactoring is justified where the
current frame arena, full Taffy clear, rebuilt dispatch/accessibility state, or scene lifecycle
prevents a truthful retained fast path. The migration plan keeps full recompute as a comparison
oracle until each incremental layer proves parity, then removes first-party reliance on the legacy
path.
