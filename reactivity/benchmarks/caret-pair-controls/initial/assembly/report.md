# Linked caret-pair assembly audit

Scope: read-only disassembly and size inspection of the two frozen x86-64 release executables named in `/tmp/gpui-caret-pair-controls-v2/metadata.json`. No builds, source edits, timings, or cycle/speed claims were made. `baseline` is commit `879476dd0bf391e8482dddea61271bb775b4f639` in `/tmp/gpui-caret-pair-baseline-root/reactivity`; `candidate` is commit `d74fc223e799956c1e21997dd7eec88abe8aff39` in `/tmp/gpui-caret-pair-root/reactivity`. Both are the `caret_pair_measure` release example (`opt-level=3`, debuginfo 0, default + simd features, overflow checks off) with `-C symbol-mangling-version=v0 --cfg tokio_unstable`.

Binary SHA-256 and lengths, checked against metadata:

| Variant | SHA-256 | Bytes |
|---|---|---:|
| Baseline | `9a8ff5ee3614eda6c896f075766be19915f376ee3387a59546ce545dfcd6dec4` | 8,323,208 |
| Candidate | `9304e0d52969ed2b387406ef5a7c5d312aecb3c7f2ad6c4d8aa46feae81557c0` | 8,325,432 |
| Metadata JSON | `84020f4defef8f1703c3f5ea1b38441652d1850b029273db557a8dbfdc27203c` | — |

The linked `.text` section grows from `0x11dcf8` (1,170,680 bytes) to `0x11e448` (1,172,552 bytes), +1,872 bytes. `.rodata` changes from `0x6209d0` (6,425,040 bytes) to `0x6209c0` (6,425,024 bytes), −16 bytes. The full executable grows +2,224 bytes. These are binary-size observations only.

## Linked operation and code-shape findings

The existing linked `Cursor::geometry_with`, `Cursor::from_byte_index`, cursor-geometry callback, and `cursor_rect` have the same symbol sizes in both executables: respectively `0x1e9` (489), `0xb7` (183), `0x339` (825), and `0x138` (312) bytes. The candidate does not shrink those functions.

The new candidate helper `CursorGeometry::geometries_at` is `0x824` (2,084) bytes and has a separately emitted `Cursor::geometry_with` closure of `0x310` (784) bytes. It performs the source-index cluster lookups, checks byte/range/line/run/direction and hard-break conditions, then checks actual visual adjacency. On the same-edge path it calls the geometry callback once and returns the shared rectangle for both affinities. That path avoids constructing/querying the downstream Cursor and avoids one downstream geometry callback. On fallback it keeps both affinity queries/callbacks, so the helper adds the lookup/predicate path without removing a geometry query there.

`geometries_at` is not inlined into `Planner::shape`; the caller makes a normal call with an out-pointer for the optional pair. The caller reserves stack storage for the two 32-byte boxes and presence state. `geometries_at` has a `0x478` (1,144-byte) frame; the callback closure has a `0xe8` (232-byte) frame; `cursor_rect` reserves `0x38` (56 bytes). These are separate frames, not an additive peak-stack estimate. The helper also emits multiple calls to `memcpy` with size `0x88` (136 bytes) while staging cluster/cursor state. That is concrete copy traffic in this executable; the source representation makes it plausible these are large cluster values, but this audit does not attribute every copy to a specific Rust type. The same-edge optimization therefore trades duplicate downstream work on a subset of boundaries for index lookup, proof branches, pair-result handling, a sizable non-inlined helper, and visible value staging.

For `<= 8` boundaries, candidate `append_carets` uses a new `0xf8` (248-byte) array-map closure with a `0x1c0` (448-byte) frame. It still calls `Cursor::from_byte_index` per affinity and follows the normal geometry path, so this path does not remove the second affinity query. Baseline also makes both affinity queries with its inline loop. Candidate `Planner::shape` is 244 bytes smaller (`0x3a46` versus `0x3b3a`), but helper and closure are additional separately emitted text; this is a linked code-shape comparison, not a net-operation or speed claim. The unchanged callback body and lack of inlining limit what can be concluded about the whole call path.

Raw linked evidence is saved in this directory: `baseline-sections.txt`, `candidate-sections.txt`, baseline/candidate symbol listings and function excerpts, `candidate-geometries-at.asm`, `candidate-planner-shape.asm`, `candidate-append-caret-closure.asm`, and `candidate-threshold-prepass-excerpt.asm`. All came from the frozen executables above. The audit tools were explicit Nix-store executables `/nix/store/m59w5gavjx8db0ay3m1yzbw02l54109b-clang-wrapper-21.1.8/bin/objdump` and `/nix/store/m59w5gavjx8db0ay3m1yzbw02l54109b-clang-wrapper-21.1.8/bin/nm`; both report GNU Binutils 2.46.

## Separate threshold-prepass elimination

At the pinned candidate source `reactivity/crates/canvas/src/text/planner.rs:447`, indexed geometry selection begins with `segmenter.segment_str(content).count() > 8`. The same worktree locks ICU4X `icu_segmenter` 2.3.0 (checksum `82d07aafccd67af15d02512a6adf5896fbc5ed00f2e99b471d2efa14016db3db`). Its `GraphemeClusterSegmenter::segment_str` returns `GraphemeClusterBreakIterator`; the wrapper's `Iterator::next` delegates to the rule-break iterator (`/root/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/icu_segmenter-2.3.0/src/grapheme.rs:68-77,286-288`). Neither layer supplies a custom `count`/`nth`. For this finite iterator, `count() > 8` and `nth(8).is_some()` have identical truth values: at least nine returned boundary offsets exist. `count()` consumes every offset; `nth(8)` needs at most nine returned offsets to identify the `>8` case. The later caret loop still scans every boundary, and font/control admission is elsewhere in `Planner`; this prepass selects the implementation only.

Treat this as a separate control, apart from pair-path changes. With eight or fewer returned offsets it must still exhaust the iterator. A very long single grapheme also cannot exit early while proving the count is at most eight: ICU must advance to the end/termination. ICU's empty-string special case returns one boundary at zero. The bounded claim is early termination of the threshold prepass once the ninth boundary is returned, not a general Unicode segmentation shortcut.

## Next attribution gate

The assembly establishes only that the current same-edge path omits one downstream geometry query. It does not show how often real input takes that path or whether it wins end-to-end. The 136-byte staging copies and large helper frame justify a separate borrowed-cluster or direct-offset source control; inspect its linked release code after implementation, then use path counts and isolated paired timings. Do not infer performance from this binary's code size or predicate alone.
