# The PR Plan: Migrating the GPUI Codebase Itself

This is the PR-granular companion to [migration.md](migration.md) Part II. Part II says *what*
each phase delivers and gates; this file says **in which pull request**, against the crates that
actually exist in this repo (`crates/gpui`, `gpui_elements`, `gpui_media`, `gpui_scheduler`,
`gpui_wgpu` + platform crates, `gpui_macros`, `gpui_sum_tree`, `gpui_collections`). Public
vocabulary is [07-the-ladder.md](07-the-ladder.md); high-perf mechanisms are
[runtime/fastpath.md](runtime/fastpath.md); undo is [08-history.md](08-history.md); text is
[09-text.md](09-text.md).

Numbers are sequencing, not a promise of exactly one PR each — a large entry may land as a
stack, but its **exit criterion is indivisible**: the stack merges when the criterion holds.

## Rules for every PR

1. **Green main, always.** Every PR compiles, passes existing tests, and ships behind the
   current public surface until its track's flip PR. New machinery enters as
   `#[doc(hidden)]`/crate-private or under the `retained` cargo feature; nothing leaks a public
   spelling before its surface PR.
2. **Oracle before optimization.** A mechanism PR that skips work must land *with* (or after)
   the from-scratch oracle it is checked against, and with its counters. A perf PR without a
   counter delta in its description does not merge.
3. **One concept per PR.** If the diff needs two sections of 07 to review, split it.
4. **Deletions are their own PRs**, gated on the product flips (Track 12) — mechanism PRs never
   delete the legacy path they bypass.
5. **Gates as CI jobs.** Each L-gate (07 §13) lands as a named CI job in the PR marked ⛩ and is
   required thereafter.
6. **The zero-tax law** ([runtime/fastpath.md](runtime/fastpath.md)): high-perf machinery must
   be pay-per-declaration, strictly-replacing, or idle-lane-preemptible — the floor never pays
   for the ceiling. Every Track-10 PR ships a **floor-tax benchmark**: tier-0 workloads
   (idle/park, plain-`T` counter, a no-`Signal` screen, first-mount) before/after, within
   noise or improved, or the PR is rejected regardless of its promoted-path wins.
7. **Memory is a counter** ([runtime/memory.md](runtime/memory.md)): PRs that add retained
   state ship bytes-per-node/row/window deltas; steady-state allocation stays zero (M0) and
   the ledger stays complete (M2) from the PR that introduces each pool.

Parallelization: Tracks 0–3 are the substrate spine and are mostly serial. Track 4 (kernel)
starts after PR 10. Tracks 5–9 fan out after PR 40 and proceed in parallel. Track 10
(fast-path) starts only after the flip (PR 88) proves the semantics. Track 11 runs beside 5–9.
Track 12 interleaves from PR 60 on.

---

## Track 0 — Contracts, determinism, and the measuring stick (Phase 0)

- **PR 1 — Conformance fixture harness.** Headless capture of layout/paint/input/focus/a11y for
  a fixed screen set under `crates/gpui/src/app/test_app.rs` + `visual_test_context.rs`;
  screenshot + tree baselines stored. *Exit:* re-running on main is byte-stable.
- **PR 2 — Deterministic clock and input traces.** One injected clock through
  `gpui_scheduler`; recorded pointer/key traces replay identically. *Exit:* two runs of every
  fixture produce identical frame sequences.
- **PR 3 — `UiSnapshot` v0 + `UiTest`.** Snapshot schema over the *current* tree reusing the
  a11y debug capture (`src/a11y`); injected input API. *Exit:* fixtures rewritten on
  `UiSnapshot` assertions, not ad-hoc queries.
- **PR 4 — Counter registry + frame trace.** `src/profiler` gains the counter vocabulary from
  [performance.md](performance.md) §3 with a no-op release build. *Exit:* counters prove
  non-vacuity on one fixture (a hover that claims 2 rows shows 2).
- **PR 5 — Benchmark runners.** Idle, counter, hover storm, scroll split, keyed table, editor,
  kitchen sink, churn workloads (performance.md §4) as `cargo bench` targets. *Exit:* current
  GPUI baseline stored in-repo.
- **PR 6 — Competitor ports pinned.** zgui/Floem/Xilem fixtures ported per performance.md §1,
  with commit pins. *Exit:* their numbers reproduce on the bench machine.
- **PR 7 — trybuild + lint harness.** Empty compile-error corpus wired into CI (the future L2
  home); the in-tree lint crate skeleton (`gpui_lints`). *Exit:* one dummy trybuild fixture
  runs.
- **PR 8 — Panic-free lint baseline.** `unwrap`/`expect`/indexing denied in `crates/gpui`
  non-test code (07 §10); existing violations allowed-listed with a burn-down file. *Exit:*
  allow-list only shrinks (CI enforces).

## Track 1 — Retained identity and ownership (Phase 1)

- **PR 9 — Per-window `NodeArena`.** Generational node arena + owner tree beside the current
  `entity_map.rs`; nothing uses it yet. *Exit:* loom/Miri clean on the arena.
- **PR 10 — Node storage layout.** Hot header slabs, kind-segregated property slabs, cold side
  records, adaptive child/dirty-set reps (builds on `src/arena.rs`). *Exit:* size assertions +
  churn gauges return to baseline on synthetic mount/unmount.
- **PR 11 — Branded arena views.** Internal branded read/write capabilities over the arena;
  compile-fail coverage for escape/alias misuse (into the PR 7 corpus). *Exit:* the negative
  tests fail to compile with the right spans.
- **PR 12 — Mount/unmount transactions.** Explicit transactions + deferred reclamation epoch.
  *Exit:* cleanup-exactly-once and late-callback-harmless tests.
- **PR 13 — Stable protocol ids.** Handler, focus, IME, a11y, semantic ids on retained nodes
  (subsumes today's `ElementId` plumbing in `element.rs` without removing it). *Exit:*
  duplicate-id diagnosis is located.
- **PR 14 — `LegacyView` island.** The retained tree hosts current `Render` output; the age
  boundary of 07 §6, both directions. This is the single most load-bearing PR in the plan:
  it is what makes everything after incremental. *Exit:* one existing example runs unchanged
  *inside* a retained root.
- **PR 15 — Inspector v0.** Node/owner inspector + live-object gauges over the arena
  (`src/inspector.rs`). *Exit:* gauges match test-side counts.
- **PR 16 — Snapshot hooks.** `UiSnapshot` reads the retained tree when present. *Exit:*
  fixture parity between legacy and island-hosted runs.

## Track 2 — Persistent layout, dispatch, a11y (Phase 2)

- **PR 17 — Persistent Taffy lifecycle.** `src/taffy.rs` keeps nodes across frames; style and
  children become patch ops. *Exit:* mutation corpus matches from-scratch relayout oracle.
- **PR 18 — Write-free measurement.** `LayoutCx`/`GeometryCx` split; custom measure cannot
  reach write/structure APIs (compile-fail into the corpus). *Exit:* reentrancy fixtures.
- **PR 19 — Reasoned layout dirt.** Dirty-child summaries; layout visits the dependency
  closure. *Exit:* nodes-visited slope gate on the bench matrix.
- **PR 20 — Retained event routing + focus order.** `key_dispatch.rs`/`tab_stop.rs` move onto
  retained ids. *Exit:* focus traversal fixtures byte-match legacy.
- **PR 21 — Incremental hit index.** Spatial index updated by patches, not rebuilt per frame
  (extends `bounds_tree.rs`). *Exit:* scroll translation rebuilds nothing (counter).
- **PR 22 — A11y deltas.** Publish accessibility diffs, not trees. *Exit:* platform a11y
  fixtures (start of the L4 corpus).
- **PR 23 — `PlacementGraph`.** Sparse anchors, transforms, collision/safe-area, located cycle
  diagnostics (07 §16.3). *Exit:* anchored-popover tracking fixtures; cycles name the chain.
- **PR 24 — Bounded geometry feedback.** The sealed feedback loop + delayed-arm rule
  (07 §18.1, Flickable lesson). *Exit:* feedback cannot exceed its declared cap (fixture).

## Track 3 — Retained scene and damage (Phase 3)

- **PR 25 — Immutable scene fragments.** Per-node fragments + resource refs replacing rebuilt
  `scene.rs` output for retained nodes. *Exit:* visual equivalence under randomized change.
- **PR 26 — Order sum-tree.** Localized splice/move of paint order (`gpui_sum_tree`). *Exit:*
  splice cost is O(log n) on the 100k fixture.
- **PR 27 — Damage index + transform-only path.** Spatial damage queried before replay;
  translation is a transform. *Exit:* idle submits nothing; scroll damages the exposed band
  only (counters).
- **PR 28 — Renderer frontend boundary.** Bulk packet protocol over `gpui_wgpu` + platform
  renderers; capability tiers; no `Any` in scene records. *Exit:* reference/Metal/wgpu consume
  the same recorded packets.
- **PR 29 — FramePacket lifetime.** Bounded in-flight versions, fences own resources,
  backpressure, device/surface-loss recovery. *Exit:* stalled-fence and device-loss fixtures.
- **PR 30 — Persistent GPU slots.** Stable primitive/glyph slots + dirty-range uploads behind a
  capability tier. *Exit:* repeated patches reuse slots (counter), uploads are sub-range.
- **PR 31 — Retained canvas node + pass contract.** `impl Canvas` internals: declared bounds,
  damage, hazards, pipeline cache, WGSL validation (`#[gpu_shader]` in `gpui_macros`).
  *Exit:* uniform patch does not rebuild the node (start of L7).
- **PR 32 — Full-damage kill switches.** Per-window forced full layout/hit/a11y/scene/damage
  fallbacks as diagnostics. *Exit:* bisecting a seeded stale-pixel bug with them works.
- **PR 33 — ⛩ Phase-3 gate job.** Damage/idle/translation gates required in CI from here on.

## Track 4 — The reactive kernel (Phase 4; the heart)

- **PR 34 — Intern table.** Per-window dense slot interner (intern-on-wire, 07 §1); cells get
  slots on first bind; patches are indexes. Crate-private. *Exit:* slot reuse/compaction
  fuzz + Miri.
- **PR 35 — `Signal<T>` core.** The cell type: `Deref`/`DerefMut`, publish-on-`deref_mut`,
  `share`/`reader`/`SignalRef`, `.ephemeral()`, `!Clone`, descriptors as inert values. No
  element consumes it yet. *Exit:* the §1 semantics as unit tests; the four view-write
  negatives in the trybuild corpus (borrow-checker diagnostics verified — the mock-crate
  verification from the design review becomes real fixtures).
- **PR 36 — Describe frame + read-set recording.** The kernel-internal frame pointer; starred
  reads during describe record `(owner, cell)`; read-sets diffed per describe
  (subscribe/unsubscribe). *Exit:* demote-law tests — a starred read re-describes its owner on
  publish; a handler read records nothing.
- **PR 37 — The dirty law.** Owner re-describe triggers exactly (a) handler ran, (b) recorded
  read's cell published, (c) structure changed (07 §1). *Exit:* the law as a property test over
  random turn scripts; freshness oracle (G4).
- **PR 38 — Ports + consumer cutoff.** Wired sinks for text/style/presence slots; every
  consumer retains its last value and drops no-op publishes. *Exit:* `*open = true` twice
  patches once; port patch runs zero describes (counters).
- **PR 39 — The tape.** Describe-output diffing with span hashes; unchanged output patches
  nothing. *Exit:* re-describing an unchanged owner is measured µs and zero patches.
- **PR 40 — Turn protocol.** Handler transaction → logical epoch publish → effects → presentation
  epoch, on `gpui_scheduler`; two-epoch fault injection. *Exit:* the two atomic barriers hold
  under injected panics (scheduler.md oracle).
- **PR 41 — `List<T>` + `Slot<T>`.** Sealed delta ops, generational slots, read-only
  `Deref<[T]>`, `.keyed_by`. `gpui_collections` hosts it. *Exit:* splice-only updates on the
  keyed bench; slot transfer across containers.
- **PR 42 — Projections + kernel dedup.** `.project` (single + tuple sources), no
  auto-tracking, no `Memo` (deleted — derived values are methods at the floor); identical
  capture-free projections (same sources + ZST closure type) share one computation.
  *Exit:* projection recomputes only on source publish (counter); two ports wiring the
  same fn item compute once (counter); a capturing closure is priced per-port and
  attributed; shadow-freedom tests (`Signal<Option<T>>::map` reaches `Option::map`).
- **PR 43 — Regions.** `.then`/`.when`/`.switch` internals: closure reruns as mini-describes
  with their own read-sets. *Exit:* region rerun does not re-describe the owner; nested
  region granularity test.
- **PR 44 — Effects sink + entity reach.** `self.spawn`/`emit`/`announce`/`haptic` into the
  per-handler dispatcher sink; located error outside a turn; journal inspectable. Plus the
  reach verbs (07 §3): `Entity<T>: Deref` to committed state (turn-ambient; never
  `DerefMut` — the write fix-it names `send`; a describe-time deref records an
  entity-grain dep; ports may wire another entity's cells directly),
  `entity.send(Verb.with(args))` (FIFO-queued routed dispatch, same
  turn, pre-describe; dead receiver attributed), and the `Win` context param. Constructor-
  created `Task` fields park and auto-start at mount (no lifecycle trait). *Exit:* tests
  drain the sink and cannot distinguish spawn from field assignment; a `send` chain of
  three entities settles in one turn in deterministic order; an entity deref outside a
  turn is a located error; a parked constructor Task starts exactly once at mount (07 §3).
- **PR 45 — `Task` + completion routing + observation streams.** `Task::run`/`Task::stream`,
  drop-cancel, completions routed by receiver TypeId with the future's `Output`; delivery
  policies (`Latest`/`Coalesce`/`Reliable`); `Task::blocking(data, work, then)`;
  `Reader<T>` is `Send` with `.latest()` (triple-buffered committed snapshot); and the two
  named observation verbs of 07 §6.4 — `entity.on_change(Self::handler)` (any commit, no
  payload, peek via `Deref`) and typed `entity.on(Self::handler)` (`Emitter` event) — plus the
  field-grain form `derived.on_change(Self::handler)` over an equality-gated derived wire
  (delivers the new value; the LSP-on-language-change shape, examples/derived_observe.rs).
  Neither verb returns a handle: each link parks at construction and arms/tears-down at
  mount/unmount against the owning entity (receiver type names the owner). *Exit:*
  stale-completion and drop-cancel races; unmount tears down every link with no stored
  `Subscription`; any-change deliveries coalesce per turn and derived `on_change` fires only
  when the gate reports a change; `.latest()` never observes a torn epoch under a write storm.
- **PR 46 — Writeback commit.** Crate-private two-way writeback (the one runtime phase flag
  consumer). *Exit:* controlled-input echo fixtures.
- **PR 47 — Arrangements.** Incremental filter/sort with field-aware sealed forms + wildcard
  fallback, priced by counters. *Exit:* one-row update gate for sealed forms; wildcard is
  visibly attributed.
- **PR 48 — Kernel delta log.** The per-turn op log (`ListDelta`, `Replace`, text/dock deltas),
  `Origin`, gesture token — the seam `gpui_history` will consume (07 §15). Off by default.
  *Exit:* replaying a session's log reproduces state (time-travel smoke test).

## Track 5 — The public surface (Phase 5-adjacent; 07 §2/§3/§5/§8/§9/§10)

- **PR 49 — Sealed boundary traits.** `IntoChildren`, `IntoWire`, `IntoPresence`/`IntoSwitch`,
  `Property<Length/Color/Brush>`, `IntoEditable` with `#[diagnostic::on_unimplemented]` texts.
  *Exit:* the L2 fix-it texts snapshot-tested.
- **PR 50 — Constructor children + text leaves.** `column((a,b))`, `div(())`, `text(...)`-only
  strings; `.child`/`.children` retained. *Exit:* `"str"`-as-child negatives in the corpus.
- **PR 51 — New style literals.** `.w(300)` ints-as-px, `rgb(0xRRGGBB)`+`.alpha`, `vw/vh/vmin/
  vmax`, `.pipe`, `Brush` gradients, `.look(..)` recipes. Legacy `px()/rgba()` untouched until
  Track 12. *Exit:* packed-alpha negative; contrast gate on role pairs.
- **PR 52 — Handler routing.** Receiver-TypeId routing, context params (`Slot`, `Drop`),
  `.with` binding triad, pair-form disambiguation. *Exit:* the routing matrix as fixtures;
  ambiguity negatives.
- **PR 53 — Event bubbling.** `Emit<E>` + `.on(Host::method)`; uncaught-inert attribution.
  *Exit:* missing-ancestor negative; bubbling fixtures.
- **PR 54 — Presence + hide.** The trio on `bool`/`Signal`; `.open()` ports on
  popup/overlay/disclosure. *Exit:* L1 fixture set v0 (`then` compiled against both rungs).
- **PR 55 — Identity, focus, shortcuts.** `Copy` `Target<K>` fields (minted at construction,
  bind once per describe with `#[track_caller]` on `.target(..)`, double-bind located error,
  parked claims when unbound — 07 §2; no id enum, no derive on app structs), `focuses`/
  `.focus_default()`/`focus_scope`, `Key`/`Chord` values + `.shortcut` on controls,
  `gpui::export` remap seam. Replaces consumption of `action.rs`/`keymap` for new-surface
  code. *Exit:* identity.rs example compiles-as-fixture; `"cmd-q"` negative.
- **PR 55b — The state-holding test driver + inspector target panel.** `Ui<Root>:
  DerefMut<Target = Root>` — tests read/write real state with the app's own spellings and
  act via Copy targets (`ui.click(ui.find)`, two-phase borrows), sealed K-typed action
  signatures, per-action re-resolve with actionability waits, auto-settle,
  `ui.state(&entity)` hop, `ui.role(Button, "Find")` semantic locators (also the external
  driver protocol; `.alias` stability override; `ui.publish` for cross-process handles),
  the inspector's target panel (bind-site `#[track_caller]` label, bound element, claim
  history incl. parked reasons), snapshot goldens (`expect_snapshot`/`expect_snapshot_of`
  scoped by target bounds), deterministic `filmstrip` motion goldens with reduced-motion
  variants, inspector write-back edits journaled as `Origin::Inspector`, and delta-log
  watchpoints (07 §16.5). *Exit:* the §16.5 test script runs verbatim; a
  wrong-K action is a compile error in the corpus; a parked focus claim shows its reason
  row; a filmstrip interruption test reproduces byte-identically across two runs.
- **PR 56 — Typestate inputs.** `NeedsWriter`, two-constructor components
  (`::new`/`::bound`), `text_input` at the port layer (`gpui_elements`). *Exit:* inert-input
  negative; controlled/uncontrolled fixtures.
- **PR 57 — Overlay family.** `dialog`/`popup`/`sheet`/`hover_card` + `Placement`/`Dismiss`
  values over the PlacementGraph; hover-intent sessions. *Exit:* overlay protocol fixtures
  incl. `BlockMouseExceptScroll`.
- **PR 58 — Windows as elements.** `gpui::run(view)`, `self.open(kind, view)`,
  `window(kind, &entity)`, `WindowSpec` builder, title/bounds ports, `on_close` writer.
  Wraps today's `window.rs`/platform spawn paths. *Exit:* §8 fixtures; N-viewports-shared-
  entity demo.
- **PR 59 — Fallibility surface.** `Miss` reasons, delivery revalidation, absence-as-state on
  every lookup; the L5 fuzz harness. *Exit:* ⛩ **L5** required (zero panics under churn).
- **PR 60 — ⛩ L1 + L2 required.** Promotion-invariance CI (view sources compiled against both
  rungs, star-insertion whitelist) and the full compile-error corpus become required jobs.

## Track 6 — Collections at scale (Phase 5)

- **PR 61 — `virtual_list`.** Anchoring, variable extents, retention reasons (focus/IME/drag
  pins). *Exit:* 100k matrix; no scroll jump on variable heights.
- **PR 62 — Row recycling + presence-as-property rows.** Pooled unmounted rows bind live slots
  (07 §18.7). *Exit:* 120 Hz splice of recycled rows holds frame budget.
- **PR 63 — Drag world.** Typed `Drag<P>`, `Drop<..>` context including `Take<T>` in-hand
  delivery (revalidate-and-remove at dispatch, restore-on-drop, gesture-shared journal tags),
  keyboard/a11y operation, cross-window handoff. *Exit:* drag never exposes an index;
  capture-loss races; a bailed handler restores the `Take` and journals nothing.
- **PR 64 — `.on_reach` + edge hysteresis.** *Exit:* fling fuzz under the L3 counter.
- **PR 65 — `List::scene()`.** Datum consumption: spatial-index hit + semantic provider a11y
  (07 §15.2). *Exit:* 100k-datum hover = index query + overlay (counters).
- **PR 66 — Grid protocol.** `Editing<CellRef>` sessions, treegrid deferral honored. *Exit:*
  formula-bar second-view fixture.

## Track 7 — Text on Parley (Phase 6 text; 09)

- **PR 67 — Parley substrate.** `text_system` shaping/bidi/styled-runs move to Parley behind
  the existing text APIs. *Exit:* text fixtures byte-match or diffs are triaged as
  improvements.
- **PR 68 — IFC + placeholder atoms.** U+FFFC inline boxes; `rich(..).atom(..)`; chips are
  line boxes. *Exit:* T1 (a `place_in` chip is a gate failure).
- **PR 69 — CSS-complete inline styles.** Spacing, decorations, fill/stroke, wrap,
  writing-mode; leading-trim via font-metrics. *Exit:* T-gate suite; ⛩ **L9** (with color.md's
  C-gates).
- **PR 70 — `Editor` + IME.** `gpui_elements/editable_text` re-based on the retained field:
  cursor/selection ports, InputHandler parity, revision-aware model binding. *Exit:* platform
  IME fixtures; ⛩ **L4** (combobox certification with active-descendant + IME).
- **PR 71 — Shaping cache + fixed-advance counters.** (fastpath §9, safe early: pure cache.)
  *Exit:* editor shaped-bytes stay in edit range; counter workload layout == 0 with tabular
  nums.

## Track 8 — History as a crate (07 §15, 08)

- **PR 72 — `gpui_history` crate.** Track/DAG/tagging over the PR 48 delta log; `impl History`
  trait; `MainHistory`; Cmd-Z routing helpers. *Exit:* the kanban two-line mesh proof as a
  test; H0–H3.
- **PR 73 — Selective undo + conflicts.** Transform-or-`Conflict`, slot-keyed O(1) transforms.
  *Exit:* H4–H7.
- **PR 74 — FileStore + Sudden Termination.** Library-side fsync, recover-after-kill. *Exit:*
  kill fixtures; H8–H10.
- **PR 75 — ⛩ L6 symbol audit.** CI proves `gpui` links zero history/persistence symbols.

## Track 9 — Motion and compositor tiers (Phase 6 motion; 07 §4.2)

- **PR 76 — Timeline/effect/playback core + dense lanes.** `animate`, tween/Bezier/keyframes,
  delay/fill/iteration/direction/rate/pause/seek/cancel, `Replace` plus reviewed `Add`/`Accumulate`,
  and time/scroll/gesture/media/test timelines lower to kind-segregated property lanes. This
  replaces new uses of `transition.rs`/`with_animation`. *Exit:* identical-time 60/120/irregular-Hz
  oracle; 10k warm tracks allocate zero, write no source and run no owner/effect; unused feature has
  no lane/clock subscriber.
- **PR 77 — Springs, decay, interruption, and gesture handoff.** Physical state/velocity with
  bounded deterministic stepping, presented-sample retarget, preserve/reset velocity, explicit
  `jump`, release velocity, reduced-motion/background/deadline policy. *Exit:* interruption is
  continuous and final values agree across cadence, pause/resume, reversal, and missed frames.
- **PR 78 — Structural presentation host.** Commit logical state first; capture bounded old/new
  spans for enter/exit/FLIP/hero, with proxy/crossfade/reflow fallbacks and no stale hit/a11y/focus.
  *Exit:* removal, supersession, failure, reduced motion, and byte/time-lease fuzz.
- **PR 79 — Earned layers + motion obligations.** Destination metadata routes paint/composite/
  placement/layout/shader/structure work; cadence-divergence hysteresis promotes under a VRAM
  budget and only demotes composite→paint. Inspector explains every promotion/fallback. *Exit:* L3
  counters, presence/control-flow obligations, budget fuzz, and no layer for an inactive motion.

## Track 10 — The super-high-perf mechanisms ([runtime/fastpath.md](runtime/fastpath.md))

Sequenced *after* the flip (PR 88): correctness first, then the fast lane over proven
semantics. Order = leverage × dependency. **Every PR in this track is bound by rule 6 (the
zero-tax law): its description must include the floor-tax benchmark table**, and PR 102's
required job runs the floor-tax suite permanently beside the competitive workloads.

- **PR 90 — SoA patch queues + range application** (fastpath §3). Per-kind SoA slot arrays,
  sort/dedup/scatter, coalesced sub-range GPU uploads over PR 30's slots. *Exit:* zero-alloc
  steady patches; upload bytes sublinear on the fanout sweep.
- **PR 91 — Damage compaction** (fastpath §4). Tile bitset + interval coalescing + density
  promotion. *Exit:* hover damage == two rects exactly; checkerboard fuzz bounded.
- **PR 92 — Zero-alloc steady-state turns** (fastpath §5). Reset-not-free arenas everywhere,
  steady-state detector, debug alloc-counter. *Exit:* `allocations == 0` on
  hover/scroll/counter after warmup; churn high-water returns to baseline.
- **PR 93 — `PresentationResolver`** (fastpath §1a). The epoch-published resolver: hit index,
  precomputed variant deltas, scroll table; no graph handles; seqlock swap. Read-only — no
  consumer yet. *Exit:* resolver contents proven equal to slow-path resolution on a trace
  (differential test).
- **PR 94 — Fast-lane hover.** Compositor-side crossing resolution: variant delta replay +
  two-rect damage + recomposite; conservative escalation. *Exit:* ⛩ fastpath §1e gate —
  `logical_epochs == 0` on the crossing trace **and** the non-vacuity half (a discrete
  handler escalates); p50/p99 under the ported zgui 202 µs.
- **PR 95 — Fast-lane scroll.** Offset-slot updates, clamp/overscroll, composite-layer
  transform path, `.on_reach` threshold minting with hysteresis, mid-gesture epoch rebase.
  *Exit:* translation scroll O(1) in document size; under the ported 44 µs; rebase fuzz.
- **PR 96 — Predictive layer warming** (fastpath §2). `Predicted(PanStart|MotionStart|OnFrame)`
  promotion reasons, warm-hold demotion, eviction ranking. *Exit:* first scroll/animation
  frame is transform-only; thrash counter bounded; static elements never warm.
- **PR 97 — Tape dedup + SIMD diff** (fastpath §6). Span-hash intern with mandatory memcmp
  confirm; shared pictures with per-instance overlays. *Exit:* 10k identical rows lower once;
  collision fuzz rejects false reuse.
- **PR 98 — Layout fast paths** (fastpath §7). Leaf-metric short-circuit, `(style_hash,
  constraint)` memo validated by the relayout oracle, parallel intrinsic sizing threshold.
  *Exit:* memo hits proven by oracle; counter workload layout == 0.
- **PR 99 — Layout-adapter seam decision.** Run the Rosin 10k fixture; if persistent Taffy
  loses, land the single-pass solver behind the seam with Taffy fallback for unsupported
  subtrees. *Exit:* ⛩ **L8** required (incl. hot-reload-no-remount and Miri on the arena).
- **PR 100 — Frame pipelining + latency lanes** (fastpath §8). N+1 describe under N's fence;
  input lane bypass; deadline drops counted. *Exit:* p99 input-to-present under saturated
  animation stays sub-frame; two-epoch oracle across pipelined stages.
- **PR 101 — Atlas warming + speculative pre-describe** (fastpath §9b/§10; lowest confidence,
  strictly idle-lane). *Exit:* speculation is preempted to zero under input saturation;
  first-crossing latency improves.
- **PR 102 — ⛩ Competitive gate required.** The ported zgui workloads (scroll/hover/recycle/
  idle) must beat-or-match on two hardware classes in CI-tracked benches; regressions block.

## Track 11 — Media, canvas, shaders, color (Phases 3/6 surfaces)

- **PR 80 — Media pipeline.** `gpui_media`: staged acquisition, decode/variant/residency
  caches, `image(..)` source polymorphism, 9-slice/tile/atlas/crop/flip, `.tint`/`.colorize`,
  `Fit`/sampling/`.decorative()`. *Exit:* acquisition convergence fixtures; adapter from
  `ImageSource`.
- **PR 81 — Video + native planes.** Bounded demux/decode, A/V clock, seek generations,
  external-plane imports with counted fallbacks. *Exit:* zero-copy proof or counted fallback.
- **PR 82 — Canvas public surface.** `impl Canvas` + `canvas(&field)` element, `on_frame`
  ephemeral lane, `List<Stroke>` undo integration. *Exit:* ⛩ **L7** (uniform patch, pan/zoom
  transform, device loss, decode-queue bounds, anchor-cycle naming, video frame patch).
- **PR 83 — Filters, typed passes, and wired uniforms.** `.filter`/`.backdrop`/`.shader(MyFx)` +
  `#[gpu_shader]`-derived `::new(wires)`; retained render DAG, declared bounds/resources/hazards,
  tier forcing, and composite-side pointer/clock/motion uniforms. *Exit:* signal or motion uniform =
  one range patch; invalid hazards are located; a11y invisibility test.
- **PR 83a — Temporal resources + optional scene attachments.** Typed ping-pong history,
  successful-submit generation swap, first/resize/profile/device reset, downsample coordinates,
  history budgets, and lazy color/depth/id/known-velocity attachments from retained transforms.
  *Exit:* dropped frames never publish history; a graphless UI has zero extra attachments/resources/
  passes/pipelines/frame requests.
- **PR 83b — Motion-shading proof crate.** Optional `gpui_motion_fx` recipes for frame difference,
  decay, approximate flow, compact blobs/SDF overlay, and velocity blur plus bounded async readback.
  *Exit:* the 07 §15.2.1 chain stays retained and range-patched; inferred/known motion, aliasing,
  disocclusion, resize, occlusion and readback backpressure fixtures pass.
- **PR 84 — Tagged `Color` + one generated working math.** Extended-linear-sRGB
  `WorkingColor`, linear premultiplied blend, all intermediate-layer kinds, token pairs, and Oklch
  seed generator as an optional helper across CPU/Metal/HLSL/WGSL. The default output remains
  `SdrSrgb8`. *Exit:* color.md C0–C5 plus default byte/pass/pipeline counters unchanged.
- **PR 84a — Negotiated extended surface.** `Prefer/Require(SurfaceColor::ExtendedSrgb16)`;
  Metal float16 + extended-linear tag/EDR, DirectX float16 + scRGB/Advanced Color, advertised
  wgpu/Vulkan/Wayland path or explicit final-transform fallback; realized format/tag/headroom and
  live display migration. *Exit:* C6–C7/C9–C10 and no silent P3 relabeling.
- **PR 84b — Application color-management boundary.** Profile-tagged media/document inputs,
  optional CMS capability, cached CPU/GPU LUT transforms, rendering intent/proofing, PQ/HLG
  reference-white normalization, explicit SDR tone/gamut map, and tagged capture/export.
  *Exit:* C8–C10; malformed profiles and unsupported required surfaces are typed failures.
- **PR 85 — `path` leaf + corner shapes + morphing.** SVG-command element with viewBox,
  `corner_shape(Squircle)`, `path().morph(..)` on motion lanes. *Exit:* mismatched-command
  morph negative; icon fixtures.
- **PR 86 — `debug_draw` overlay.** Gizmo-style dev instrumentation on the inspector layer,
  compiled out of release. *Exit:* zero release symbols (audit like L6).

## Track 12 — Product flips and deletions (Phase 8)

- **PR 87 — Examples migrated.** Every `designs/reactivity/examples/*.rs` sketch becomes a
  compiled example; first-party demo screens (counter/settings → overlays → table → editor →
  workspace) per Part II's difficulty ladder, each recording legacy-island percentage. *Exit:*
  screens run on the retained surface end-to-end.
- **PR 88 — ⛩ The default flip.** `retained` feature becomes default-on; docs and templates
  teach the 07 surface; migration.md Part I ships in rustdoc. Legacy remains available.
  *Exit:* no first-party screen regresses its stored fixtures/benches.
- **PR 89 — Deprecation pass.** `cx.notify`, `EventEmitter`/`subscribe`, `actions!`/
  `bind_keys`/keymap strings, `with_element_state`, `WindowOptions`, `px()`-mandatory
  builders, packed `rgba`, `with_animation` marked deprecated with fix-it messages naming the
  07 spelling (the migration table as compiler output). *Exit:* deprecation messages
  snapshot-tested.
- **PR 103 — Legacy removals, staged.** One subsystem per PR, each gated on zero first-party
  usage and a released compatibility window: element-state store, old scene rebuild path, old
  keymap dispatch, `subscription.rs` observer machinery, legacy animation. *Exit per PR:*
  symbol audit shows the deleted path is gone; islands still work via PR 14's seam until the
  final removal.
- **PR 104 — Kill-switch narrowing.** PR 32's forced-full fallbacks reduced to real
  platform/device recovery cases. *Exit:* a release build cannot enable diagnostic fallbacks.

---

## Flip points and gate placement (summary)

| Milestone | After PR | Meaning |
|---|---|---|
| Island era begins | 14 | new and old coexist entity-granularly |
| Kernel semantics proven | 48 | ladder nouns exist, no public surface yet |
| Surface complete | 60 | L1/L2/L5 required; libraries can be written |
| Feature-complete parity | 86 | text/history/motion/media/windows all gated |
| **Default flip** | 88 | 07 is what GPUI *is* |
| zgui beaten in CI | 102 | fast lane + warming + SoA + damage + zero-alloc |
| Legacy gone | 103–104 | one architecture remains |

The high-value early wins the sequencing protects: PR 14 (islands) makes every later PR safe;
PRs 35–39 (Signal/describe-frame/tape) deliver the DX story long before any perf claim; PRs
72–75 (history) and 67–70 (Parley text) are user-visible flagships that need only the kernel,
not the fast path; and the entire Track 10 is *optional until proven* — the flip at PR 88 does
not wait for it, because the ladder's floor (µs re-describe + tape) already has to meet the
Phase 3 gates to get there.
