# Approach C — Retained Attribute Graph plus Universal MVCC

Status: **substrate winner, state-model correction required**. Retained properties and structural
fallback are central to the final plan. Universal MVCC and type-level durability are not. See
[../../03-hybrid-plan.md](../../03-hybrid-plan.md).

## Original hypothesis

Retain every element/property, wire dynamic attributes into a dependency graph, reconcile typed
views only for structural changes, and version all state through Compose-like snapshots. Durability
would be a type parameter distinguishing theme/session/volatile inputs.

This correctly identifies the performance substrate and incorrectly makes its concurrency and
scheduling machinery universal.

## What survives

- Stable retained nodes and owner lifetimes.
- One binding per dynamic property with equality cutoff.
- Explicit structural reconciliation as the fallback for tree-shape changes.
- Persistent Taffy nodes, retained dispatch/a11y/hit-test records, and retained paint fragments.
- Direct mapping from property fields to downstream obligations.
- A UI-thread graph with reverse dependencies and glitch-free settle.
- Optional immutable snapshots for selected background work.

## Why universal MVCC is rejected

The UI has one writer. Events and graph settle happen on the UI thread; paint reads only after the
transaction commits. That phase protocol already ensures coherent frames. Version chains on every
value would add allocation/storage, old-record retention, reclamation, retry, and merge semantics to
the common local path.

Background sort/filter/parse work needs an owned consistent input and a policy when the result is
stale. The final API snapshots only selected revisioned values and returns an owned result tagged
with those revisions. The application chooses accept-latest, reject, rebase, or merge. This retains
the useful concurrency property without pretending every UI value has a meaningful generic merge.

MVCC may still be appropriate inside a document model that already needs concurrent editing. It is
then application state feeding GPUI, not a requirement of `State<T>`.

## Why type-level durability is rejected

Reverse edges already answer which computations observe a changed source. A mouse write cannot
visit a theme-only computation because there is no path from the mouse node to it. Adding
`State<T, Durable>` infects generic state/value/component signatures, and dynamic computations whose
inputs change would need complicated type erasure or conservative lowering.

Runtime priority lanes solve the separate problem—what ready work is urgent. Revisions and
observation solve reattachment. Devtools can flag broad fanout and always-dirty nodes. No durability
lattice is necessary in the core type system.

## Correct retained model

```text
local State/Computed graph
  -> retained property slots
  -> obligation lattice
  -> persistent layout / input / accessibility
  -> retained fragments and damage
  -> renderer capability tier

show/switch/keyed structural sources
  -> reconcile retained owner/node ranges
  -> wire/unwire property observers
```

This is retained-first. GPUI's current `with_element_state` is not sufficient because it does not
retain frame-arena elements or layout nodes. `Render::render()` does not merely “run less often” by
adding an attribute graph; legacy rendering must be hosted in a retained island while new components
mount once.

## Examples

The examples remain useful illustrations of per-attribute behavior and large-table ambitions, but
their snapshot and durability types are not target API:

- [examples/counter.rs](examples/counter.rs)
- [examples/data_table.rs](examples/data_table.rs)

Use `State<T>`, runtime lanes, `KeyedList`, and explicit selected-value snapshots when translating
them to the final plan.
