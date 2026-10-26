# 06 — Competitive Update: Retention, Lists, and the 2026 Bar

This is a source-level update to the earlier survey. It records what was checked after the first
draft and corrects assumptions that would otherwise make the final recommendation too weak. See
[../03-hybrid-plan.md](../03-hybrid-plan.md) for the resulting architecture.

## Audit pins

| Project | Commit |
|---|---|
| zgui | `41727c1b7de2239642378d0a47ed8b302e6ce9c0` |
| Floem | `778bb5f2aa08429e579ee2e6ac97e84fbf18b618` |
| Xilem | `7fe469d6bd1ddc486d406a6eb4f9e776b5ffe34d` |
| Leptos | `fa1b92d187d0e50b281574ea6785b5c302216e13` |
| Haalka | `86dba4552f8d317097503b80d9c6b496b3f0f169` (`0.7.1`) |
| Jonmo | `db1acb70fe417f6fdbfdaa542d6820ea91385dff` |
| Slint | `1.17.1` release (2026-07-07; official language/runtime documentation) |

Haalka examples `key_values_sorted`, `nested_lists`, and `calculator` were also checked on stable
Rust. This verifies that the inspected APIs are not dead sketches.

## zgui changes the target

Current zgui is not simply a signal wrapper that rebuilds a scene. Its architecture documentation
and implementation retain:

- the document, computed styles, Taffy box tree, shaped paragraphs, and fragment geometry;
- per-fragment paint recordings and persistent renderer buffers;
- a damage set and a composed target whose pixels outside damage survive;
- hit-test state with in-place move/reinsert paths;
- exact/range dirty-child summaries to skip clean siblings;
- per-frame work counters, latency traces, live gauges, non-vacuity checks, and generated performance
  bands.

Its frame settles reactivity between queued events, bounds geometry-observation feedback, replays
unchanged paint records, and parks when no event/deadline needs work. Its current generated
performance file reports strong hover and scroll locality, even while honestly recording several
kitchen-sink regressions.

Therefore these claims from the first draft are invalid:

- adding signals alone is enough to beat zgui;
- retained paint fragments alone are a differentiator;
- “no per-frame element rebuild” alone establishes the highest performance ceiling;
- a performance plan without traversal, damage, GPU, idle, leak, and tail-latency counters is
  competitive.

The final plan treats zgui's current retained pipeline as the minimum serious comparison. GPUI's
potential differentiators are its local-state specialization, uniform literal/reactive value API,
true resident-key row updates, sum-tree/text substrate, explicit phase classification, dedicated
native text state, and priority/concurrency boundary—not the word “retained.”

## Floem is stronger on lists and persistent layout than assumed

Current Floem has a retained `ViewId` tree and persistent Taffy nodes. `dyn_stack` diffs keyed
sequences and preserves view/scope identity for resident keys. `virtual_stack` supports fixed,
per-item, and measured-first extents and persists a prefix-sum extent model. Its styles and custom
views can request layout or paint directly.

The remaining opportunity is not “invent keyed lists.” It is to separate:

- an O(n) convenience reconcile over `Vec<T>`;
- a diff-native keyed store for large collections;
- structural key sequence changes;
- updates to the value already resident at a key;
- virtualization pinning for focus, IME, drag, pointer capture, and accessibility.

## Xilem remains the structural-diff reference

Xilem's `View` protocol explicitly separates `build`, `rebuild`, `teardown`, and `message`, while
`ViewSequence` and element splices mutate retained elements in place. Its architecture notes that
the view tree is normally evaluated eagerly when application logic runs; `Memoize` prunes pure
subtrees.

The useful lesson is typed structural composition and explicit teardown—not a requirement to
recreate all view values after ordinary property changes. The hybrid plan uses Xilem-shaped
reconciliation only inside structural regions.

## Haalka and Jonmo expose important semantic traps

Haalka currently uses retained Bevy ECS entities and Jonmo-backed signals. Its builder surface often
has distinct static and reactive methods. Child/list subscriptions are owned and cleaned up when
entities despawn. Its text input includes a model-echo guard so an external binding does not blindly
reset the cursor after a local edit.

Jonmo's signal-vector behavior is especially instructive:

- `Move` moves the existing child;
- `UpdateAt` despawns and recreates the child;
- `Replace` despawns all children.

A diff stream therefore does not imply keyed identity. The final collection contract specifies
move, resident-key update, and replacement independently.

Haalka also shows why text input cannot be treated as a plain string binding. GPUI needs a
first-class text-field state with selection, composition, edit origin, and revisions. Similarly,
viewport callbacks are not a complete virtualizer: retained focus/IME/drag state needs explicit pin
rules.

## Leptos remains an API and ownership reference

Leptos supplies mature owner scopes, signals, keyed `For`, selectors, and resources. It also
demonstrates tradeoffs that need not be inherited by a native UI:

- thread-capable state imposes synchronization/storage choices on local work;
- static and reactive values often have visibly similar but semantically different spellings;
- owner/disposal behavior and async completion need excellent diagnostics;
- a signal containing a vector is not automatically a per-row reactive collection.

The final plan keeps the compositional wins, makes the local graph the default, and puts `Send` at a
message/snapshot boundary.

## Slint is the compiler-specialized property reference

Slint 1.17.1's language makes property expressions reactive by default and enforces purity in
binding contexts. Because its compiler owns that language, it can specialize bindings and optimize
properties in ways a Rust proc macro cannot safely infer across arbitrary resolved host-language
calls. It is therefore a stronger constant-factor comparison for GPUI's generated typed ports and
sealed static circuits than a general dynamic signal graph alone.

The trade is expressiveness and integration: GPUI keeps ordinary Rust and must route opaque or
branch-dependent host code through an explicit dynamic computation. It should not claim to
statically prove such code pure. The credible target is to approximate Slint's common direct
property path with compact generated descriptors and UI-local slabs, while retaining the dynamic
escape hatch and measuring both paths separately.

## Corrections to frontier-Rust claims

The mechanisms explored in the original alternatives remain useful in narrower roles, but several
cannot carry the public architecture:

- a generative brand can prove arena separation inside a callback, but public brands become viral
  and do not hide cleanly inside dynamically stored windows/callbacks;
- phase capability types work well at framework entry points, without branding every stored value;
- session-typed values cannot enforce a protocol whose next step arrives in an unrelated later
  callback unless a runtime state machine still owns the durable state;
- dynamic dependency cycles are discovered when computations record edges, not at arbitrary state
  writes;
- type-level durability duplicates reverse-edge information and infects generic APIs;
- universal MVCC is unnecessary for a single UI writer and creates record retention, merge, and
  reclamation costs; explicit background snapshots provide the useful part;
- a proc macro can parse `tw!` on stable Rust, but cannot safely infer arbitrary typed program
  semantics from tokens; it must bail out to runtime tracking around opaque calls;
- arbitrary fluent builder chains are not guaranteed const-evaluable. Retention removes their
  per-frame cost without depending on such a claim.

## Conclusion

The competitive bar is a fully retained, damage-aware, instrumented native pipeline with excellent
lists, text, async ownership, and authoring ergonomics. The final design can plausibly exceed that
bar, but only a same-machine workload port can verify it. That verification contract is in
[../performance.md](../performance.md).
