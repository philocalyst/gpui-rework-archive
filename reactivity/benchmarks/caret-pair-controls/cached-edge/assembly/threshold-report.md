# Linked audit: ninth-boundary threshold build

This is a read-only assembly check of the v3 threshold executable, not a timing report. I used the installed `/nix/store/m59w5gavjx8db0ay3m1yzbw02l54109b-clang-wrapper-21.1.8/bin/{objdump,nm}` explicitly. The full linked `<gpui_canvas::text::planner::Planner>::shape` disassembly is `/tmp/gpui-caret-pair-assembly-luna-v3-threshold-shape.dis` (SHA-256 `1f313ac61bb7b582f82d7aadb5cebdaf5b643df6ef8fef0bcf2ccbc0110010e0`).

The binary is `/tmp/gpui-caret-pair-controls-v3/threshold`, 8,325,536 bytes, SHA-256 `c790f7fc3ee947a0697fb98c98b1e675ade7edd25827d8e038c8d005ab6d0f20`, built from source `7eb75ab3971e76f645cb9316a3b1f8b9d7644270`. The immediately preceding indexed candidate is `/tmp/gpui-caret-pair-controls-v3/candidate`, 8,325,328 bytes, SHA-256 `6fb63a3d033288be0bf6e9c0b3628a89c96793ddf44a562344b9d90ff7da977f`, source `db7281e1cd76d130952cdbb6f3ea5d062b69af9f`. Their source diff for Canvas `planner.rs` is exactly the threshold expression: `.count() > 8` became `.nth(8).is_some()`.

In the linked threshold `Planner::shape` body, the prepass calls ICU's `RuleBreakIterator::next` nine times (addresses `0x68051f` through `0x6805d5`). Each missing result branches to the direct path; after the ninth result, only `Some` reaches `CursorGeometry::new` at `0x680615`. The large-map path then creates a fresh segment iterator for the real stop loop. Thus the binary confirms early termination at the ninth boundary; it does not fuse the detection and output passes.

The direct path is still present in the same linked body. At `0x6807cd` it calls `Cursor::from_byte_index` for upstream, compares the returned index against the source byte, then calls `Cursor::geometry` at `0x68080a` when admitted. The downstream branch repeats that ordinary cursor construction/geometry at `0x6808b6` and `0x680904`. The indexed path instead calls `CursorGeometry::geometries_at` at `0x68078b`. The only source change from `db728` is the prepass predicate, so this does not alter the direct-edge behavior.

For code/stack accounting, threshold `.text` is `0x11e358` bytes versus `0x11e298` for the `db728` candidate (+192 bytes); `.rodata` is unchanged at `0x6209d0`. The linked `Planner::shape` symbol is `0x3a2f` bytes versus `0x396b` (+196 bytes). The threshold and candidate prologues both reserve `0x1000 + 0x1d8` bytes (4,568 bytes) of explicit stack frame; the `nth(8)` change adds no frame. These are whole-function sizes, not an allocation or cycle attribution. The complete executable is +208 bytes.

For context only, the baseline executable is 8,323,208 bytes (SHA-256 `9a8ff5ee3614eda6c896f075766be19915f376ee3387a59546ce545dfcd6dec4`) from source `879476dd0bf391e8482dddea61271bb775b4f639`. It has a different set of source changes, so its total size or frame is not attributable to the threshold edit.

No timing, allocation, or runtime-performance conclusion follows from this disassembly.
