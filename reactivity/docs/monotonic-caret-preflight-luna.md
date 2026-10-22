# Monotonic caret emission: exact preflight audit

## Scope and pin

This is a read-only source audit of the existing monotonic caret-stream proposal, using the frozen cleanroom commit `db7281e1cd76d130952cdbb6f3ea5d062b69af9f` in `/tmp/gpui-caret-pair-root`. Every Parley/Canvas citation below is from `git show db7281e1cd76d130952cdbb6f3ea5d062b69af9f:<path>`; no files were changed and no build or timing run was done. The existing report `/tmp/gpui-monotonic-caret-stream-luna.md` remains unchanged.

## Finding

For the actual Canvas caller, Parley can validate the exact source ranges that the current `CursorGeometry::new` would index, before invoking any visitor, with one linear preflight over visible logical clusters and a reusable per-line run-order table. The proof is conditional on the source byte length being at most `u32::MAX`; the Canvas caller already imposes a much smaller 32 KiB limit before shaping. A general Parley entry point must preserve an exact fallback for longer layouts because its stored character byte offsets are `u32` casts and can wrap.

The preflight must enumerate **line-scoped public grapheme `Cluster`s**, not shaped glyph clusters and not full shaped runs. That matches the existing index exactly and handles ligature continuations, hard breaks, style/font splits, and line splits. The visitor must not be called until the complete preflight passes.

## Why the validation order is sound

`CursorGeometry::new` first rejects shaped-character or line counts above `u32::MAX` (`reactivity/vendor/parley/src/editing/geometry.rs:32-36`). It then creates one entry for each visible cluster, obtains `cluster.text_range()`, checks that the range is a valid subslice of the byte-owner vector, and rejects if any byte already has an owner (`:43-75`). For non-empty layouts it also checks that each entry index converts to `u32` (`:58-66`). Empty layouts skip range and entry-index checks (`:58-66`). These are the precise `InvalidFont` conditions a replacement preflight has to preserve; gaps are accepted.

The public cluster range is a grapheme range derived from original `Character` source positions, not a glyph range (`reactivity/vendor/parley/src/layout/cluster.rs:158-163`; `reactivity/vendor/parley_engine/src/shape/data.rs:15-38`). Shaped clusters and graphemes can differ, including ligatures (`shape/data.rs:129-141`), while `Run::clusters()` explicitly walks logical graphemes (`layout/run.rs:383-460`). The grapheme iterator advances through increasing character indices (`parley_engine/src/shape/atom.rs:654-713`), so public cluster byte intervals are ordered within one source run when the stored byte offsets have not wrapped.

Shaping stores source characters in source order. `ShapedText::push_run` enumerates `text[range.byte_range].char_indices()` and records each byte start (`parley_engine/src/shape/shaped_text.rs:325-347`). It deliberately forces a grapheme boundary at every shaped-run start because itemization can split a grapheme (`:344-347`), producing adjacent, disjoint source intervals rather than a cluster crossing runs. HarfRust clusters can cover several graphemes, but `Run::clusters()` still emits those graphemes individually; a ligature continuation does not duplicate its source bytes.

Shaped runs are inserted into layout items in ascending shaped-run order, with inline boxes interleaved (`reactivity/vendor/parley/src/shape/mod.rs:193-245`; `layout/data.rs:292-300, 374-379`). The line breaker consumes that item sequence, commits line items from a contiguous source item range, and carries the exact cluster endpoint to the next line (`layout/line_break.rs:1063-1067, 1700-1716, 1836-1850`). Each line’s `LineItemData` preserves the original shaped-run index (`layout/data.rs:149-165`; populated at `line_break.rs:1776-1782`). Mixed-direction reordering happens only after those source ranges are computed, and permutes the line-item slice without changing the stored run identity or ranges (`line_break.rs:1811-1819`). Lines themselves are appended as line-breaking advances through source (`:903-945`).

This also covers the main adversaries:

- **Bidi:** visual run order is not source order, but stored shaped-run indices restore source run order; within each run use `clusters()`, never `visual_clusters()`.
- **Line wrapping and hard breaks:** line ranges are split on atoms; a run carried to the next line starts at the prior line’s cluster end. An explicit newline cluster belongs to the prior line; a trailing empty line’s synthetic run has an empty cluster range (`line_break.rs:1734-1768, 1836-1847, 1489-1536`).
- **Style/font/itemization splits and ligatures:** the run-start grapheme reset makes cluster intervals disjoint even when a grapheme was split by itemization; shaped glyph-cluster overlap is irrelevant because the old map indexes public grapheme ranges.
- **Inline boxes:** their line items carry dummy `0..0` ranges and no clusters (`line_break.rs:1718-1727`); skip them in validation, but include them in the later visual-origin pass because their widths affect subsequent runs.
- **Missing font coverage:** shaped text may omit source characters when a font selector fails (`shape/shaped_text.rs:221-226`). That creates gaps, which the existing byte map accepts. Do not require that ranges cover all source bytes.
- **Zero-length ranges:** `get_mut(start..start)` accepts an in-bounds empty range and its overlap scan is empty. Check bounds/inversion, but do not compare an empty range against `previous_end` or update `previous_end` from it.

For already sorted, valid half-open intervals, the byte-map overlap condition is exactly `start < previous_nonempty_end`. The validator should check `start <= end` and `end <= text_len` before overlap logic, then ignore empty intervals for overlap. Because it returns immediately on first overlap, maintaining the end of the previous non-empty interval is sufficient; a maximum end is also harmless. This gives the same accept/reject result as scanning every byte of the old owner vector.

## Run order without comparison sorting

A comparator sort by source start would work for the bounded caller, but costs `O(sum R_line log R_line)` and repeats in the emission pass. There is a simpler linear scatter key already in the line data: `LineItemData.index` is the original shaped-run index. A per-line reusable scratch vector can be indexed by `shaped_run_index - min_shaped_run_index`, with a sentinel for holes. The source item interval is contiguous; all interior text runs are retained by `commit_line`, and only the split-range guard on its first/last text run can filter an edge (`line_break.rs:1700-1746`). Thus the index span is proportional to that line’s text-run count, plus at most those edge slots. Use the explicit stored `usize` identity, not `Run::index()` (visual position) or the `u32` fields inside `ClusterPath`.

For preflight, fill slots with line-item positions, iterate slots in ascending shaped-run index, and scan each run’s logical clusters. Keep one `previous_end` across lines. For emission, perform the ordinary visual pass over line items to compute each run’s origin with the existing operation order; store the line-item position and origin in the same slots; then visit slots in ascending source run order. If the implementation does not want to rely on the contiguous-item-span proof, retain a per-line comparison sort as a simpler fallback and price it honestly as `O(C + sum R_line log R_line)`.

## Exact range and overflow caveat

The source-order proof does not make range validation redundant. `CharCluster::fill` casts source byte offsets to `u32` (`reactivity/vendor/parley_engine/src/shape/cluster.rs:392-455`), and `ShapedText::push_run` independently casts `range.byte_range.start + byte_offset` to `u32` (`shape/shaped_text.rs:325-334`). `LayoutData::text_len` is `usize` (`reactivity/vendor/parley/src/layout/data.rs:191-202`). The existing character-count and line-count guards do not establish that a multibyte source string is shorter than 4 GiB. After a wrap, logical source order can have decreasing stored byte starts; a running-end validator would then be unsound and could miss the exact overlap the old map rejects.

The cleanroom Canvas path is safe without a new admission restriction: `reactivity/crates/canvas/src/text.rs:31-32` sets `MAX_TEXT` to 32 KiB and `shape_mode` rejects `text.len() > MAX_TEXT` before calling the planner (`:292-315`). For a general Parley method, branch to the unchanged `CursorGeometry::new`/random-index path when `layout.text_len() > u32::MAX`; do not strengthen or rewrite the existing constructor’s semantics. This avoids changing how the old API handles wrapped offsets and preserves its own `None` result before any callback.

On the bounded path, retain the exact preflight order:

1. Check `characters.len() <= u32::MAX` and `layout.len() <= u32::MAX` first, matching the constructor.
2. If `text_len == 0`, skip range and per-entry-index checks, matching its explicit empty-layout branch.
3. Count every visible cluster (including clusters with empty byte ranges) and check each would-be entry index with `u32::try_from(count)` before advancing the count. The old constructor pushes an entry for every cluster before it performs range checks.
4. For every non-empty layout range, reproduce the `get_mut(range)` admission rule: `start <= end` and `end <= text_len`. Empty intervals still require those bounds checks.
5. Reject non-empty interval overlap using the source-ordered running end.

No code path after the first visitor call may discover an `InvalidFont` condition. The layout is immutably borrowed throughout, so a complete first pass over the exact visible clusters gives the second pass a stable source. Reserve any per-line slots and maximum RTL offset scratch after preflight and before the first callback if the API wants all recoverable work before output mutation.

## Work and scratch accounting

This is a formulation cost model, not a measurement or speed claim.

| Representation | Transient payload on a 64-bit target |
|---|---:|
| Existing `CursorGeometry` entry capacity | `16 * shaped_character_count` bytes (`ClusterPath` plus `f32` offset) |
| Existing source-byte owner vector | `4 * text_len` bytes |
| Proposed reusable `RunSlot { item_position: usize, origin: f32 }` table | `16 * max_per_line_shaped_run_span` bytes, with one local `Vec` header |
| Proposed exact RTL visual-offset scratch | `4 * max_RTL_run_grapheme_count` bytes, with one local `Vec` header |

The source-declared current capacities imply 655,360 payload bytes for 32 KiB ASCII before vector headers (`geometry.rs:11-15, 38-42`); this is arithmetic from the fields and `with_capacity`, not a measured allocation. The candidate adds a full validation walk of the visible clusters before the emission walk. It must also redo the per-line visual run-origin traversal for emission; reusable source-order slots replace, rather than eliminate, run identity ordering. At each run boundary retain `origin += run.advance()`; within a run retain exact `f32` `offset += cluster.advance()` recurrence. For RTL, source order is opposite visual order, so store visual offsets for one RTL run and reverse them to align with `run.clusters()`. Do not reconstruct them by subtracting advances from the run end: floating-point subtraction is not the inverse of the producer’s rounded addition sequence.

In practical Canvas use, `MAX_TEXT=32768` caps total source bytes and therefore total grapheme count. The worst RTL scratch is bounded by one such run, but remains a variable allocation, not a zero-cost assumption. Tiny one-run labels incur a local slots vector and possibly no RTL payload; keep the existing direct `<=8`-boundary branch so those cases do not pay the scratch setup.

## Callback/result seam

The method that owns preflight should also own callback sequencing. A streaming iterator that yields `Result<Stop, InvalidFont>` can yield valid stops and then fail on a later overlap, violating the no-partial-callback requirement. A simple typed signature using only standard types is:

```rust
fn try_for_each_caret_pair<E>(
    layout: &Layout<()>,
    offsets: impl IntoIterator<Item = usize>,
    width: f32,
    visit: impl FnMut(usize, Option<[BoundingBox; 2]>) -> core::ops::ControlFlow<E>,
) -> Option<core::ops::ControlFlow<E>>
```

`None` means the complete layout preflight failed (`InvalidFont`); the visitor was never called. `Some(ControlFlow::Break(e))` means the preflight passed and the caller stopped with its concrete error (Canvas can use `Error::InvalidGeometry`). `Some(ControlFlow::Continue(()))` means complete success. The callback’s `Option` pair preserves the indexed API’s existing “this boundary cannot be represented here; skip it” behavior. This adds no generic error trait or new cross-crate error hierarchy. A named two-variant error enum is also viable if maintainers prefer explicit variants over the nested `Option<ControlFlow<E>>` contract; a callback-error-only `Result` without an outer preflight state is insufficient.

The caller should append stops to its local plan only after finite-geometry checks. If it returns `Break(Error::InvalidGeometry)`, the already validated traversal can stop immediately and the enclosing planner drops its partial local result on the error path. Invalid font/range state always wins because it was decided before the first callback, just as `CursorGeometry::new` currently runs before the loop in `planner.rs:443-452`.

## Recommendation and limits

The preflight is source-grounded and exact for the Canvas caller’s existing 32 KiB text domain. For a general Parley visitor, preserve old behavior with the unchanged indexed constructor when `text_len > u32::MAX`. Use line-scoped logical graphemes, a reusable source-run-identity slot table, and an explicit range/overlap preflight before callbacks. The strongest unverified implementation detail is the bounded per-line slot-span property under edge-only empty split runs; validate that with an adversarial vendor fixture before implementation. Also include fixtures for mixed bidi runs, fallback/style splits inside graphemes, ligature continuations, wrapped same-run slices, in-flow/out-of-flow inline boxes, newline plus trailing empty line, missing-font gaps, zero-length ranges, overlapping ranges, and out-of-bounds ranges. No performance conclusion follows until a later separately attributed build and benchmark.
