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

Each Taffy node owns its GPUI metadata in one `NodeContext`: vertical alignment,
the CE-only inline display override, published inline content/fragments, an
optional measurement, and its claim epoch. Ordinary display and position come
from Taffy's canonical style. A single persistent ID vector tracks live nodes;
new nodes append once, while subtree reuse stamps existing contexts without
adding duplicate IDs. At frame end, stale epochs are pruned and their contexts
are cleared before Taffy removes the nodes, avoiding Taffy 0.13's context-slot
leak. Stale IDs are collected in the existing layout scratch buffer and removed
in reverse creation order: parents are created after children, so this avoids
repeated scans of a parent's child vector. Epochs alone decide which nodes live;
the removal order only reduces cleanup work. Frame-bound measurement IDs use a
per-frame vector because each request creates a distinct node; finishing a
frame drops only the callback from its context, leaving node metadata intact.

Absolute snapped bounds and unrounded device-pixel origins share one sparse
per-frame geometry record. Repeated layout and inline placement use the same
subtree invalidation path; the separate computed-root set stays sparse because
only explicit layout roots enter it. Raw origins use `ScaledPixels` so their
device-pixel coordinate space remains explicit through parent accumulation.

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
the callback before that frame's arena is cleared. List and uniform-list
measurements use this path because they may close over mutable list state or
user callbacks. Built-in text and inline layout use the private retainable path
only for owned, stable measurement data. That callback receives only
`&WindowTextSystem`, not `Window` or `App`, and therefore cannot create entity
or global dependencies during layout. Taffy nodes that leave the retained tree
have their full context cleared before removal.

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

The final focused checks passed: the retained oracle had **6 passed, 1
ignored**, the inline filter had **3 passed**, the snapping filter had **6
passed** (including its expected-panic case), and the wide-sibling reparenting
lifecycle test passed. The full no-default-feature core suite had **391 passed,
2 ignored**. The full workspace test run passed its unit, integration, and doc
tests; its GPUI core run had **393 passed, 2 ignored**. Workspace Clippy passed
with warnings denied.

```sh
CARGO_TARGET_DIR=/tmp/gpui-ce-retention-view-target cargo test -p gpui-ce --no-default-features --lib retained_
CARGO_TARGET_DIR=/tmp/gpui-ce-retention-view-target cargo test -p gpui-ce --no-default-features --lib taffy::tests::pruning_wide_stale_parent_preserves_reparented_child
CARGO_TARGET_DIR=/tmp/gpui-ce-retention-view-target cargo test -p gpui-ce --no-default-features --lib inline
CARGO_TARGET_DIR=/tmp/gpui-ce-retention-view-target cargo test -p gpui-ce --no-default-features --lib snap
CARGO_TARGET_DIR=/tmp/gpui-ce-retention-view-target cargo test -p gpui-ce --no-default-features --lib
cargo test --workspace --no-fail-fast --locked
cargo clippy --workspace --all-targets --locked -- -D warnings
git diff --check
```

Inspector/stacker compiled, formatting and diff checks passed, and the Metal
oracle matched all 14 incremental/full-refresh frame comparisons with its
clean/dirty render-counter checks passing. Workspace documentation generation
completed with existing unrelated documentation warnings. The Parley rendering
integration command exited 0; AppKit shutdown suppressed the normal test
footer.

```sh
cargo check -p gpui-ce --no-default-features --features inspector,stacker --lib --locked
cargo doc --workspace --no-deps --locked
cargo fmt --all -- --check
cargo run -p gpui_ce_macos --example retention_pixels --features test-support --target-dir /tmp/gpui-ce-retention-pixels-target
GPUI_RUN_RENDERING_TESTS=1 cargo test -p gpui_ce_platform --test parley_render --locked
```

Scene finish/recording measurements are in
[scene-performance.md](scene-performance.md). Retained natural-update CPU
timings below use the natural-only workload; the two-draw forced-refresh
diagnostic is not presented as the baseline/candidate performance result.

### Retained rendering CPU workload

These are four alternating runs of the same debug test-profile workload on the
baseline and V4 candidate. The test command requests `--no-default-features`,
but both debug binaries' effective GPUI feature fingerprint included `default`,
`wayland`, `windows-manifest`, and `x11` (workspace/dev-dependency feature
unification appears to re-enable them). Each case uses 60 panels × 64 labels,
with 20 warmups and 40 measured samples. The host was an Apple M3 Pro (11
cores, 36 GiB, arm64 Darwin), with three active users and reported load
averages of 14.72 / 15.24 / 12.78. Times are milliseconds, shown as mean /
median. Our GPUI builds and profiling jobs were idle during both measured
profiles; unrelated user builds and background work were active.

| Run | Revision | Clean | One dirty | All dirty | Panel renders (clean / one / all) |
| --- | --- | ---: | ---: | ---: | ---: |
| 1 | Baseline | 190.920 / 176.992 | 182.650 / 172.151 | 271.935 / 222.906 | 3660 / 3660 / 3660 |
| 1 | V4 candidate | 15.388 / 14.904 | 16.794 / 16.396 | 265.644 / 256.579 | 60 / 120 / 3660 |
| 2 | Baseline | 212.688 / 194.628 | 216.634 / 189.793 | 240.554 / 213.881 | 3660 / 3660 / 3660 |
| 2 | V4 candidate | 15.720 / 15.031 | 18.934 / 18.690 | 243.518 / 227.854 | 60 / 120 / 3660 |

Candidate clean-frame medians were about **11.9× and 12.9× lower** than their
paired baselines; one-dirty medians were about **10.5× and 10.2× lower**. The
all-dirty candidate medians were **15.1% and 6.5% slower**, respectively. The
render counts show that clean and one-dirty cases avoid panel renders, while
all-dirty still renders every panel and retains overhead. This debug-profile
result is separate from the optimized profile below.

Provenance: baseline source `c6b17e616a35271183ab49f0da1890ee81953a99`;
candidate source based on `c808b9b179bd947ef567016333b875cb1bcec0eb`, with
`scene.rs` SHA-256
`cc7fbc5309d18c22d57d77940883e0aaf7359ae506590818d431815b75bd5928`, `taffy.rs`
SHA-256 `3a14d409845a24c60a090710d2c45046df75e05ce3cfe136956d1c513f112370`, and
`window.rs` SHA-256
`be6eba4e65d68d92418855985faf7c4e3a1d9de67e99d5a960d591a7244f160c`; identical
workload source SHA-256
`a5907975608041c3a3f6bb24ce41aca70ec8c8585cc2b68567221f984bac24ff`; baseline
binary SHA-256 `3a1f3d2b06a46452f747679f1d0c962e6c4d6211b94dc8a84e11145c28bc3197`;
candidate binary SHA-256
`d625617b9ed288fb321a15b686c793046524d6a579e838fd2c6ff66d82051697`. Run-log
SHA-256 values, in table order, are:

| Log | SHA-256 |
| --- | --- |
| Baseline run 1 | `f8cb4d01f2b8eda031f40424591b27cf935c6455a9a2a167787ba5becebc6c34` |
| Candidate run 1 | `ab980eb119ea50edd558c14055d18e3253dda741eb17a3d6f636ae1901c8cba3` |
| Baseline run 2 | `8173eab2d49b187b57f4cb31468150137b9e525d54f66aa17f34905235ce28de` |
| Candidate run 2 | `c7cb808cdc150255b61a8b090be4e593f260dc83b991305eef8de4ebde20bc39` |

### Optimized test-profile results

The same workload and source were also built with
`CARGO_PROFILE_TEST_OPT_LEVEL=3` (optimized code with debuginfo) and measured
with the same command and alternating order. The effective GPUI feature
fingerprint again included `default`, `wayland`, `windows-manifest`, and `x11`,
despite requesting `--no-default-features`. Times are milliseconds, shown as
mean / median.

```sh
CARGO_PROFILE_TEST_OPT_LEVEL=3 GPUI_BENCH_NATURAL_ONLY=1 CARGO_TARGET_DIR=/tmp/gpui-ce-retention-target \
  cargo test -p gpui-ce --no-default-features --lib --locked \
  retention_workload::retained_rendering_cpu_workload -- --ignored --nocapture
```

| Run | Revision | Clean | One dirty | All dirty | Panel renders (clean / one / all) |
| --- | --- | ---: | ---: | ---: | ---: |
| 1 | Baseline | 29.656 / 29.310 | 41.299 / 33.904 | 140.287 / 120.129 | 3660 / 3660 / 3660 |
| 1 | V4 candidate | 2.196 / 1.799 | 4.574 / 4.736 | 71.765 / 63.858 | 60 / 120 / 3660 |
| 2 | Baseline | 32.750 / 31.977 | 36.473 / 32.289 | 57.433 / 52.403 | 3660 / 3660 / 3660 |
| 2 | V4 candidate | 0.973 / 0.913 | 1.429 / 1.403 | 62.426 / 58.232 | 60 / 120 / 3660 |

Optimized clean-frame medians were about **16.3× and 35.0× faster** than their
paired baselines; one-dirty medians were about **7.2× and 23.0× faster**. The
all-dirty result was inconsistent: the candidate median was **46.8% lower** in
pair 1 and **11.1% higher** in pair 2. Do not infer a stable all-dirty speedup
or parity from these two pairs. Three users and unrelated builds were active;
after pair 2, reported host load averages were 29.18 / 61.44 / 45.87.

The optimized binaries used the same baseline and V4 source revisions and
workload hash listed above. Their binary SHA-256 values were baseline
`ab92266887acbd3e9a541682d91e7f2fcdb87714a93f729ffb1effa00bb89f9b` and
candidate `168988a0351682bfc5783352c08b82a2b4ebd2040a388d3f2dcbc7d3d8999ca7`.
Log SHA-256 values, in table order, are:

| Log | SHA-256 |
| --- | --- |
| Baseline run 1 | `80d02337bd243fc7511db713dfcc73b676021557d416cf33438a984f953abd0d` |
| Candidate run 1 | `de869e107d1fe62fea4242a208d70f08d4d5b300df842d94e7c45a05536074da` |
| Baseline run 2 | `d4ae46ff7e16733e0a9954e3e0fe3365aef243c3fb26d8aae0fe97812b100cb0` |
| Candidate run 2 | `b4ef5f9ce10d26cace6ee74d1c5f2fcc3ff7931a6501be8f289a336f869f8cc9` |
