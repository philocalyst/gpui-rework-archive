# Retained view rendering

Ordinary `Entity<T>` and `AnyView` elements retain layout and draw work across
frames when their inputs are unchanged. Hand-written `ViewElement::new` wrappers
remain fresh, even when they expose an entity ID, because their parent may supply
new props without notifying that entity. This is an internal optimization: it
adds no public cache-control API and does not change the `Render` contract.

## Ownership and validity

Each retained mount owns one private `ViewElementState`, keyed by its global
element path plus a mount occurrence. Repeated mounts of the same entity
therefore keep independent layout and replay ranges. The state keeps a typed
layout record and moves through `NeedsPrepaint`, `Prepared`, and `Painted`
output states. Only a completed `Painted` output can be replayed, so partial
frames cannot advertise ranges that were never recorded. It retains the Taffy
root, render dependencies, and frame-relative ranges; it never retains the
rendered `AnyElement` tree.

During layout, a clean view claims its existing Taffy subtree and lets Taffy
compute it under the new parent constraints. A view rebuilds when its entity or
an observed entity is dirty, an observed global revision changed, its layout
environment changed, it contains frame-bound measurement, or it was marked
frame-bound by an active style transition or detached-layout repair. Entity
reads are captured with nested scopes that merge transitively; a parent thus
observes dependencies read by child views and shared models without a separate
subscriber graph. Global access is tracked by type and revision. Clearing test
globals advances affected revisions and invalidates cached readers while
preserving the API's silent observer behavior.

The layout key conservatively includes the full window environment: viewport,
scale and `rem` size, text style, opacity, image-cache identity, content mask,
pointer position, focus, active and accessibility state, and input modality.
Prepaint also checks bounds and stores a second environment snapshot only when
its inherited state differs from the layout baseline. A cache miss in prepaint
can render a fresh detached tree at the parent's assigned size; temporary root
dimensions are restored immediately. If that reparents nested retained layout
nodes, the current cached owners rebuild on the next frame so the canonical
Taffy tree is reconnected before reuse.

Prepaint and paint output is replayed from typed frame ranges. Replaying a
parent rebases nested view ranges only when they lie inside the copied source
range; deferred output keeps its own ranges and is rebased when that output is
replayed. The scene's renderer vectors remain the canonical primitive storage;
paint operations carry typed indices and stable source order rather than
duplicating each primitive into painted and sorted lanes. Accessibility stores
only each view's direct root node IDs; one canonical previous tree supplies
node data, focus metadata, bounds, debug provenance, and leased action
listeners when a view is replayed. Deferred draws capture roots after late
prepaint and use the same replay path, preserving button roles and callbacks.
Their lazily memoized `Rc<[GlobalElementId]>` owner path is restored around both
late prepaint and paint. Reads from those phases are merged into retained owner
states after frame-state migration, so a deferred element can depend on an
entity or global even when it has no ordinary layout or render read. The same
late merge carries frame-bound flags, and owner scopes include every cached
ancestor, so validity uses exact membership rather than prefix scans.

## Measured layout lifetime

The public `Window::request_measured_layout` accepts arbitrary `'static`
closures, but the closure can still capture memory owned by the current frame
arena. Such measurements are frame-bound: their owners rebuild, and Taffy drops
the callback context before that frame's arena is cleared. List and uniform-list
measurements use this path because they may close over mutable list state or
user callbacks. Built-in text and inline layout use the private retainable path
only for owned, stable measurement data. That callback receives only
`&WindowTextSystem`, not `Window` or `App`, and therefore cannot create entity
or global dependencies during layout. Taffy nodes that leave the retained tree
have their callback context cleared before removal.

The test-only `VisualTestContext::draw` path accepts a root from its caller
instead of using the window root. It refreshes before laying out that supplied
element and releases frame-bound measurement contexts before clearing the
element arena, matching the normal draw path's freshness and lifetime rules.

## Verification

Run the deterministic retained/full-refresh oracle and lifecycle checks with:

```sh
cargo test -p gpui-ce --no-default-features --lib retained_
```

The ignored CPU workload measures clean, one-dirty, and all-dirty histories.
Use `GPUI_BENCH_NATURAL_ONLY=1` for the baseline/candidate comparison: the same
fixture and sample loop are copied into the c6b17e baseline checkout. Without
that variable, each sample also forces a full refresh; that two-draw path is a
correctness/performance diagnostic, not a natural-update timing comparison.
Both modes report medians without thresholds:

```sh
GPUI_BENCH_NATURAL_ONLY=1 CARGO_TARGET_DIR=/tmp/gpui-ce-retention-view-target \
  cargo test -p gpui-ce --no-default-features --lib \
  retention_workload::retained_rendering_cpu_workload -- --ignored --nocapture
```

## Validation record

The deterministic retained suite passed **6 tests** with **1 ignored**. The
full GPUI core suite passed **387 tests** with **1 ignored**:

```sh
CARGO_TARGET_DIR=/tmp/gpui-ce-retention-view-target cargo test -p gpui-ce --no-default-features --lib retained_
CARGO_TARGET_DIR=/tmp/gpui-ce-retention-view-target cargo test -p gpui-ce --no-default-features --lib
```

Workspace Clippy passed with warnings denied, the `inspector,stacker` GPUI
configuration compiled, and workspace docs generated (with existing unrelated
documentation warnings). The final full workspace unit, integration, and doc
tests also passed; the default-feature GPUI core run had **389 passed** and
**1 ignored** (the separate `--no-default-features` run above had 387 passed):

```sh
cargo test --workspace --no-fail-fast --locked
cargo clippy --workspace --all-targets --locked -- -D warnings
cargo check -p gpui-ce --no-default-features --features inspector,stacker --lib --locked
cargo doc --workspace --no-deps --locked
cargo fmt --all -- --check
```

The real Metal pixel oracle passed **14 exact incremental/full-refresh frame
comparisons**. The seeded Parley fixture also checks retained text and inline
layout against forced refresh; GPUI's opt-in Parley rendering integration test
also passed:

```sh
cargo run -p gpui_ce_macos --example retention_pixels --features test-support --target-dir /tmp/gpui-ce-retention-pixels-target
GPUI_RUN_RENDERING_TESTS=1 cargo test -p gpui_ce_platform --test parley_render --locked
```

Natural-update CPU timings and Scene finish/recording timings are recorded
separately in the shared performance report once the final interleaved runs
complete; the two-draw forced-refresh diagnostic is not presented as the
baseline/candidate performance result.
