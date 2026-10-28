# db728 caret-pair source and release-code audit

Audit target: `/tmp/gpui-caret-pair-root`, pinned commit `db7281e1cd76d130952cdbb6f3ea5d062b69af9f`. I read the committed source with `git show <commit>:<path>` and did not edit the checkout or run builds. The parent reports the full Canvas suite passed at this pin (193 cases/docs, 4 ignored, 28 harnesses); I did not rerun it.

## Source correctness

The direct-offset path in `reactivity/vendor/parley/src/editing/geometry.rs:43-76,94-128` looks correct. Construction assigns an entry to every visible cluster, fills its half-open `text_range()` byte span, and rejects overlapping ranges. At an interior byte `b`, distinct mapped owners for `b-1` and `b` therefore prove that the previous range ends at `b` and the next starts at `b`. Equal line and run path fields plus direction-correct adjacent visual indices prove the pair shares one run edge. This makes `b` the source cluster start used by `Cluster::from_byte_index` (`vendor/parley/src/layout/cluster.rs:51-58`) and preserves cursor canonicality.

The selected x coordinate is exactly the already-recorded producer recurrence, without recomputing or assuming positive advances: for LTR the next visual entry is immediately after the previous entry and its stored `offset` is the result of the constructor's `offset += cluster.advance()` (`geometry.rs:48-56`); for RTL the previous logical neighbor is immediately after the next visual entry and its stored offset is that same recurrence result. Signed zero, zero/negative advance, and rounding therefore flow through the stored f32 words. `line_cursor_rect` is the extracted arithmetic from `cursor_rect` (`editing/cursor.rs:414-439`): line metrics, f32 `line_x + width`, then f64 conversion are unchanged. The independent oracle compares all four resulting f64 words across source bytes and widths, including `-0.0`, negative width, and a very large width.

Hard-break handling is not accidentally bypassed. `geometry_with` (`cursor.rs:301-325`) makes an upstream hard-break cluster defer to the downstream one. When the shared path applies, both clusters are on the same line/run and at one recurrence edge: if the previous cluster is a hard break, both geometries select the next cluster; if the next is a hard break, its leading edge and the previous cluster's trailing edge are the same stored recurrence result. A hard break at an explicit line transition fails the same-line condition and uses the fallback. Soft-wrap and bidi/run transitions likewise fail the shared-path guard.

The new fallback (`geometry.rs:130-160`) keeps the original upstream cursor admission test before returning a pair. At byte zero, `from_source_cluster` forces Downstream for a present cluster; at EOF/missing next cluster, it returns the same Upstream text endpoint for both requested affinities (`cursor.rs:25-45`). Thus `same_edge = byte == 0 || next.is_none()` is sufficient. Other cases still compute Downstream separately. Cluster references are borrowed for both affinity evaluations; no `Cluster` ownership or map-index assumption was added.

I found no unsafe code, unchecked caller-byte indexing, or definite behavior bug. The exact test exercises empty text, UTF-8-interior offsets, grapheme/ligature/combining/ZWJ content, bidi, line breaks, wraps, alignments, 0/22 line heights, negative spacing, and all source byte offsets plus `usize::MAX`. It does not synthesize custom `NaN`/infinite/negative-zero cluster advances. The stored recurrence is exact for ordinary finite advances and preserves signed-zero bits by construction; NaN payload bit identity across separately executed floating-point additions is not established here and should not be claimed from this oracle.

One small hot-path branch opportunity remains unmeasured: the code resolves the line/run and direction before checking visual adjacency (`geometry.rs:106-116`). It might reject nonadjacent neighbours earlier by checking whether either global entry order differs by exactly one, then test the direction-specific order once the run is known. This is only a source-level candidate; the current linked path and branch census should decide whether such a rewrite is worthwhile.

## Probe-only path census

A separate, un-applied patch is at `/tmp/gpui-caret-pair-census-db728.patch` (SHA-256 `0eeb88813b90671207dc0cced577d39d1ae737f56c10253c4d5b64ff63bf9972`). It adds call-local counters to the existing Canvas real-font oracle: shared LTR, shared RTL, byte-zero/text-length endpoint fallback, and other fallback. It uses the same `shared_edge` decision path and emits only one aggregate line. It is not intended for timing and must be applied only in a separate checkout rooted at db728, then discarded. I did not apply, compile, or execute it.

## Linked release audit

I inspected only the frozen binaries under `/tmp/gpui-caret-pair-controls-v3/`, using `/nix/store/m59w5gavjx8db0ay3m1yzbw02l54109b-clang-wrapper-21.1.8/bin/{nm,objdump}` (GNU Binutils 2.46). No build, execution, or timing was performed in this audit.

| Executable | Source pin | SHA-256 | Bytes | `.text` bytes | `.rodata` bytes | `Planner::shape` bytes |
|---|---|---|---:|---:|---:|---:|
| baseline | `879476dd0bf391e8482dddea61271bb775b4f639` | `9a8ff5ee3614eda6c896f075766be19915f376ee3387a59546ce545dfcd6dec4` | 8,323,208 | 1,170,680 | 6,425,040 | 15,162 |
| prior candidate (`initial`) | `d74fc223e799956c1e21997dd7eec88abe8aff39` | `9304e0d52969ed2b387406ef5a7c5d312aecb3c7f2ad6c4d8aa46feae81557c0` | 8,325,432 | 1,172,552 | 6,425,024 | 14,918 |
| db728 candidate | `db7281e1cd76d130952cdbb6f3ea5d062b69af9f` | `6fb63a3d033288be0bf6e9c0b3628a89c96793ddf44a562344b9d90ff7da977f` | 8,325,328 | 1,172,120 | 6,425,040 | 14,699 |

These are binary/code-size observations, not runtime estimates. Relative to the previous candidate, db728 is 104 bytes smaller overall and 432 bytes smaller in `.text`, with `.rodata` +16 bytes. Relative to baseline it is +2,120 total bytes and +1,440 `.text`; the `Planner::shape` symbol itself is 463 bytes smaller. The binaries came from the same recorded release example configuration in the frozen metadata; binary hashes were independently rechecked.

The candidate `CursorGeometry::geometries_at` symbol is 472 bytes with a 168-byte stack frame (`candidate-geometries-at.asm`). It has no `Cursor::from_byte_index`, `Cursor::geometry_with`, or `memcpy` call on this common helper. The assembled shared path checks both byte-owner indices and bounds, equal line/run, resolves the line item and run direction, tests directional adjacency, calls one 125-byte closure that constructs the rect from the cached offset and line metrics, then writes the same 32-byte box twice. This is direct evidence of the intended operation removal at the linked-code level, not evidence about cycles or frequency.

The `#[inline(never)]` fallback is a separate 1,251-byte symbol with a 504-byte frame. Its specialized `geometry_with` callback is 1,064 bytes with a 96-byte frame. Neither fallback function nor its callback has an emitted `memcpy` call. The prior candidate had a 2,084-byte `geometries_at`, a 1,144-byte frame, and seven `memcpy` calls in that function. The new split successfully keeps the common helper frame separate from fallback staging; source borrowing also removes those large staging-copy calls from these geometry functions. The fallback remains substantial code and stack, so this is a bounded code-shape win for the hot symbol, not whole-function deletion.

`Planner::shape` in db728 has a 4,568-byte local frame (including a 4 KiB stack probe), unchanged in size from the prior candidate. On the `<=8` path it still emits two direct `Cursor::from_byte_index` calls and two direct `Cursor::geometry` calls. The array-map closure emitted by the prior candidate is absent; this matches the restored explicit loop. The threshold prepass remains `segment_str(content).count() > 8`; no `.nth(8)` control is included here. There is a 584-byte `memcpy` call elsewhere inside `Planner::shape` (at 0x67f1dd), outside the extracted caret branch; this audit does not attribute it.

The raw source-addressed evidence is saved beside this report:

- `candidate-geometries-at.asm`
- `candidate-boundary-geometries.asm`
- `candidate-boundary-callback.asm`
- `candidate-planner-shape.asm`
- `initial-geometries-at.asm`
- `baseline-planner-shape.asm` and `initial-planner-shape.asm`
- `relevant-symbols.txt`, `*-symbols.txt`, and `sections.txt`

No path-frequency count has been run yet; the temporary probe is the next bounded evidence step. Do not reuse prior v2 executable output for db728 or infer cycle savings from the disassembly.
