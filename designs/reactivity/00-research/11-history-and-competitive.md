# 11 — History systems and competitive DX (research snapshot)

Research date: 2026-08-16. Descriptive findings; recommendations are absorbed into
[08-history.md](../08-history.md) and [07-the-ladder.md](../07-the-ladder.md) §15–§17.

## Why this note exists

07's first draft closed hole 10 with "one journal, lanes, focus picks." That is the right
*routing* idea and the wrong *model*: it still sounds like several stacks glued together.
The quote that actually specifies the model is Quentin Mathe on EtoileUI / CoreObject
([thread context via the user](https://github.com/etoile/EtoileUI)): NSUndoManager captured
blocks because Sudden Termination needed *some* persistence, and blocks do not serialise.
CoreObject had the model track prior states **and transitions** (redo, rebase) and the UI
decide which of those were the undo *button*.

This note is the source survey behind encoding that split as Rust traits, plus the
competitive DX steals from Rosin, Ripple/React, Solid 2, and Svelte 5.

## History systems

### EtoileUI / CoreObject

- Docs: [README](https://etoileos.com/dev/api/CoreObject/README.html),
  [API overview](https://etoileos.com/dev/api/CoreObject/APIOverview.html),
  [COUndoTrack](https://etoileos.com/dev/api/CoreObject/COUndoTrack.html),
  [COTrack](https://etoileos.com/dev/api/CoreObject/_COTrack.html),
  [COEditingContext](https://etoileos.com/dev/api/CoreObject/COEditingContext.html).
- Two-level history: revision graph per document (git-like) + undo track per activity.
- Commands are object-graph patches, never new Command classes per action.
- `undoNode:` / `redoNode:` = selective undo (invert one past node, keep later work).
- Persistent, checksummed, tree-structured undo; cheap copy; union view of tracks;
  per-user tracks for collaboration.
- Coalescing is `beginCoalescing` / `endCoalescing` on the track (we rephrase as the
  gesture token so the bracket cannot leak across frames).

**Take:** capture vs tag; DAG + tracks; selective as transform-and-commit, not rewrite;
serialisable values; checksums; union routing.

**Leave:** SQLite OODB as the UI runtime; pervasive UUID metamodel.

### NSUndoManager / Core Data

- [Undo Manager](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/UndoArchitecture/Articles/UndoManager.html).
- Groups by run-loop cycle; inverse is registered *by performing it on a proxy*;
  redo is whatever the undo just registered. Not serialisable. Sudden Termination
  is why this hurts.

**Take:** grouping-by-gesture as the *default tagger*.

**Leave:** blocks; inverse-by-performing; two stacks that destroy the future.

### Yjs UndoManager / Lexical

- [Y.UndoManager](https://docs.yjs.dev/api/undo-manager);
  [Lexical collaboration](https://facebook-lexical.mintlify.app/guides/collaboration).
- `trackedOrigins`: undo *your* edits, not the peer's.
- `captureTimeout` + `stopCapturing` for typing coalesce.
- Stack-item `meta` restores cursor/scroll, which is not the document.

**Take:** origins, typing pause, barrier, meta-as-presentation, collaborative undo as
an external track over a shared document.

**Leave:** CRDT as the GPUI kernel (editor crate plugs into `Delta::transform`).

### Others

- ProseMirror: barrier on selection change; `addToHistory: false` = Silent / `.ephemeral()`.
- Immer patches: store forward+inverse, not the whole state. Same shape as our node.
- git: DAG, revert-not-reset for selective. Users must not *think* in commits.
- Isaac Ha's ["You Don't Know Undo/Redo"](https://dev.to/isaachagoel/you-dont-know-undoredo-4hol):
  bubbling transpose as the fallback when `transform` is identity-or-conflict.
- Max Liani, ["Undo, the art of"](https://maxliani.wordpress.com/2021/09/01/undo-the-art-of-part-1/):
  restore directly-reachable data exactly; derived state recomputes.

03 §1.6 and 04 §12 already pointed here; 08 is the encoding that fits 07 (`&mut` ops,
no `Update` token, sealed `ListDelta`).

## Competitive DX (what they do better)

### Rosin ([sailbrush/rosin](https://github.com/sailbrush/rosin))

Immediate-feel builder, retained reuse, Leptos-shaped `Var` / `WeakVar`, CSS + Fluent
hot-reload, `id!()` call-site identity, Miri + concurrency permutation tests,
panic-consistent updates. Built for a 2D animation app (Sailbrush) — canvas-native.
Published single-pass layout number is the standing challenge in
[performance.md](../performance.md).

**Steal:** permutation tests, file hot-reload without remount, panic-consistency of
the arena, `Option` on dead handles (we already call this 07 §10).

**Refuse:** everything-in-a-`Var`; CSS as the only style surface; dylib hot-reload
as a product promise.

### Ripple / TSRX / React

- [Ripple](https://www.ripple-ts.com/docs/guide/reactivity),
  [TSRX](https://tsrx.dev/features), React Compiler / `useOptimistic` / `useTransition`.
- Lazy destructuring so taking a field apart does not snapshot it.
- Reactive collections that look like the host language's collections.
- Library DX: props are values + callbacks; package not generic over reactivity.
- Compiler memoization without changing the mental model (React); async-in-the-graph
  (Solid 2); honesty-at-rest (Svelte 5 `$state`).

**Steal:** `IntoWire` must not snapshot at a helper boundary; `List` looks like `Vec`;
controlled/uncontrolled constructors; optimistic as a flag on a tagged apply;
`Task::idle` as `startTransition`.

**Refuse:** a custom UI language in Rust; auto-tracked anonymous signals; MaybeSignal.

### Solid 2 / Svelte 5 / Vue Vapor

- [Solid 2.0 RC](https://www.solidjs.com/blog/solid-2-0-rc-the-big-reveal): async is a
  property of the graph.
- Svelte 5 runes: reactivity lives where `$state` lives, including outside components.
- Vue Vapor / alien-signals: opt-in no-VDOM.

**Steal:** types-at-rest (already the ladder); Task-as-graph; wires as Vapor.

**Refuse:** runes that make `view` mutate; fine-grained-by-default as the floor.

### Retained / structural peers

zgui (pipeline bar), Xilem (structural-diff bar, lens tax refused), Floem (list
ergonomics), Slint (compiler constants; missing tree/selection is 06's job),
Makepad (shader hot-reload), PanGui (placement expressiveness), Lilt (interruption).
Decisions in 07 §17.5.

## Encoding decision (so this note has a conclusion)

Four traits (`Delta`, `History`, `Track`, `TrackScope`) and two enums (`Tag`, `Origin`).
The ladder's sealed ops *are* the `Delta` impls. `impl History` is the opt-in. Focus
selects a track. Closures never enter the journal. That is CoreObject in Rust, without
an object database.
