# Monotonic caret source-order preflight: first producer proof

Production pin: `1d5bc3061cce3beb3c4857102ed651da501b5cfd`.
Final test/harness pin: `e62473aa21a244e32edeb97d863e1a5796577bc8`.
The audited algorithm remains db7281e1cd76d130952cdbb6f3ea5d062b69af9f;
7eb75ab3971e76f645cb9316a3b1f8b9d7644270 only bounds the tiny-branch prepass.
The report identifier9acc229788a8585a5fa10b315226063a2b90f16df49155bb61a82394c44fbab7
is its SHA-256, not a Git commit.

No Parley, Engine or Canvas production bytes changed in this proof. The test
executes exact vendor production modules in a standalone private test overlay;
it exposes no test-only public API. The crates.io archive's normal unit root
references unpublished parley_dev fixtures, so the overlay replaces only that
test-module root and adds this private test. Its manifest removes unused dev
dependencies and their peniko feature references. `qualified.json` records all
copied hashes, font hashes, actual executable hash and test source.

The frozen executable `/tmp/gpui-monotonic-span-proof-bin` passed one targeted
test across396 actual shaped layouts and2468 lines:344 visual run permutations,
629 occurrences of an already-seen run on a later line,144 empty/synthetic edge
runs,396 inline boxes, and maximum shaped-run span33. Every retained text-run
identity span equalled its count: no duplicate or interior hole. Empty runs were
single-text-run lines; empty runs beside other text runs were not observed and
are not claimed. The source proof below covers edge filtering independently.
The test checks that identity scatter restores ordered, nonoverlapping public
grapheme byte ranges across lines. It does not yet test a streaming producer,
geometry bits, error order or allocation/performance improvements.

## Why the span is bounded

1. shape/mod.rs visits every ShapedText run in ascending identity order.
   LayoutData::process_shaped_run unconditionally appends one TextRun item per
   shaped run. Inline boxes have a separate index domain and are excluded.
2. commit_line consumes a contiguous interval of those source items. Every
   interior text run retains its original nonempty shaped range. Only its first
   or last text run can have a boundary override; the start-at/end filter can
   remove an edge, which cannot introduce an interior identity hole.
3. Bidi reorders only the resulting LineItemData permutation. Stored usize
   identity survives; public Run::index is the visual item position and is not
   a source key. The test explicitly distinguishes both domains.
4. finish_line's synthetic trailing empty run is the only text item on that
   otherwise empty line, so its span is1 even when it reuses a prior identity.

Thus one reusable16B `RunSlot { item_position: usize, origin: f32 }` per maximal
line identity span can recover source order without a comparison sort. The test
uses actual line data, wrapping, all-character style splits, mixed bidi/isolates,
ligature and combining text, hard/trailing breaks, width0 and in/out-of-flow boxes.

## Reviewed seam (not implemented in this proof)

```rust,ignore
pub fn try_for_each_pair<E>(
    layout: &Layout<B>,
    offsets: impl IntoIterator<Item = usize>,
    width: f32,
    visit: impl FnMut(usize, Option<[BoundingBox; 2]>) -> ControlFlow<E>,
) -> Option<ControlFlow<E>>;
```

A complete source-range/entry-count preflight runs before any callback. Outer
None is the old constructor's InvalidFont admission; callback Break is a caller
error after that preflight. Preserve empty-layout exemptions, empty interval
bounds without overlap updates, accepted gaps, and ordinary snapping. Keep the
old indexed path for source lengths above u32::MAX and all random queries.
Canvas's <=8-boundary branch remains direct.

Emission reuses the run slots with exact visual f32 origins. LTR uses forward
prefix additions. RTL stores one run's visual f32 offsets in reusable scratch,
then reads them in source order without reverse subtraction. Use ordinary cursor
fallback at source/run/line/hardbreak boundaries and gaps; only proved contiguous
same-run edges share a rectangle. Repeated requested offsets work; decreasing
requests explicitly switch the remainder to the ordinary direct path. Preserve
whole f64 BoundingBox conversion and all finite checks in Canvas before appending
packed stops. No InvalidFont discovery may occur after the first callback.

A later separately pinned Shared/Split/Snapped result experiment may transport
that common-edge proof into Canvas. The first correctness control keeps the
Option<pair> seam. No enum or performance winner is claimed here.

## Reproduce

From this worktree, with the recorded toolchain/environment and an unused output
path (the preparer refuses to overwrite one):

```sh
python3 reactivity/evidence/monotonic-caret-span/prepare.py \
  --repo /root/gpui-monotonic-caret-stream \
  --ref 1d5bc3061cce3beb3c4857102ed651da501b5cfd \
  --output /tmp/gpui-caret-span-replay
cp reactivity/evidence/monotonic-caret-span/fixture.lock /tmp/gpui-caret-span-replay/Cargo.lock
CARGO_TARGET_DIR=/tmp/gpui-caret-span-replay-target CARGO_BUILD_JOBS=2 \
CARGO_ENCODED_RUSTFLAGS='' cargo test --offline --locked \
  --manifest-path /tmp/gpui-caret-span-replay/Cargo.toml \
  --no-default-features --features std --lib producer_line_run_span -- --nocapture
```

The standalone lock differs from the workspace only in three optional/foreign
package versions listed in qualified.json. None appears in the actual normal
Linux/std dependency graph (`dependencies.log`). Initial manifest/lock setup
failures remain raw records, not producer failures. Production source hashes
were verified before and after the passing test. No timing campaign ran.

All authored evidence code is charged in `lines.json`:66 Python code lines plus
186 Rust fixture code lines. Shipping source delta is zero at this stage; the
test support is not omitted from the source ledger merely because it is outside
library/src. Later shipping/allocator/assembly controls must be pinned separately.
