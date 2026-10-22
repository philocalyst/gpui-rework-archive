# Cold out-of-flow records over one generational tree

Source d8f40d7126 follows flat-cache source31e38bc00e and evidence3dde6834ed,
from main36921e2c42 / Cephal perf/cold-layout20c4c494. This control predates
later main Parley12, zbus6 and build-time WGSL integration. Records use complete
arena-qualified NodeIds and borrowed Cephal traits; the retained GPUI tree is
the only topology. Placements and viewport placements are never retained.
Speculative writes cannot mutate real records. Structural invalidation clears
only recorded ancestor holders before retirement/reparenting, queuing those
holders for recompute; unrelated query answers survive. Ordinary style and
measurement changes keep the existing scheduler route. Empty record ownership
is released after computation or structural invalidation. Broad whole-forest
cache eviction was rejected before implementation because it would erase
unrelated answers on every ordinary edit.

## Correctness and work budgets

Both normal and cephal/verify-cache core release suites pass39 tests (4unit,
19layout,13tree,3lifecycle), none ignored. Strict all-target release Clippy
passes. Fixtures independently rebuild a fresh vendor-owned tree: nonparent
absolute/fixed paths through static bridges with block/flex/grid, containing
block changes, former forest roots, hide/unhide, reparent/remove/reused slots,
160 randomized lifecycle edits, generation rollover and speculative isolation.
A measurement panic poisons the adapter as specified; no recovery API is
claimed. Complete logs preserve intermediate syntax/lint failures and a real
budget failure under verify-cache: that policy deliberately recomputes shortcut
answers through measurement callbacks. We do not alter or hide those counters.
Correctness runs in both policies; strict physical budgets use normal policy.

The external core driver reuses the test fixture through public LayoutTree APIs,
with1000 measured row leaves and an optional nested OOF tooltip. Its fixed
callback is synthetic, not Parley. Three fresh processes per plain/OOF mode
pass a new cold oracle after every phase. OOF text edits make4 measurements /
5 computed nodes; style edits0/2 with1003 cache hits; placement edits0/2;
reparent0/5 with1004 hits. The test budgets cap these operations explicitly.
Raw CSVs and source/executable fingerprints are retained. These are work and
allocation counts, not elapsed-time results.

## Ordinary public GPUI list

The external public driver uses Win::recording, uniform_list and ItemSource
with1000 Unicode labels and13 realized rows. Mount, scroll to490, one visible
row500 text edit, row500 width/background edit and return scroll each compare
all pixels with an independently constructed eager visible-row View. Three
fresh processes per variant pass every oracle and paired BGRX hash. Both text
and style edits retain2 measured calls,1 layout and1 source operation.

The flat control consumer was built with exact31e38bc00e core/layout.rs while
all other compiled production sources match31; then d8 source was restored.
New uncompiled tests/evidence remained, so this is not claimed to be a clean
full Git31 checkout. Build JSON identifies the actual rlibs and executable;
immutable copies remain under the recorded /tmp paths. No target aliases are
used as proof of source identity.

The d8 correctness implementation has a real cold tax. List mount changes
retained61218 ->63138, total269805 ->271085, peak112148 ->114068, calls656 ->658.
Scroll/return each request1272 more bytes and2 more allocations with unchanged
retained/peak. Text-edit allocation rows are identical; style requests1120
fewer bytes /3 fewer allocations. We do not describe this public-list case as
a memory improvement. allocation-counter tracks requested payload, excluding
allocator metadata and RSS; raw timing columns elsewhere are not used.

## Exact cold-tax diagnosis

On this x86_64 toolchain NodeId is16 bytes, AbsoluteContext96, OofEntry40,
BTreeMap24 and LayoutTree664. allocation-counter's independent type ledger
shows24 bytes for the boxed map and1248 bytes for its first leaf. Insertions
1 through11 share that leaf; insertion12 requests2592 bytes across2 nodes.
The toolchain's own btree/node.rs declares capacity11. A16-entry vector is640B.

Valgrind3.27.1 Massif runs the unchanged frozen public d8 executable and all its
pixel oracles pass. Actual stacks tie the1248-byte B-tree leaf and24-byte box
to Engine::set_absolute_context, and640-byte vector to flex::finish_children.
The complete raw141MB capture is retained compressed plus selected unmodified
stack excerpts. This is diagnostic instrumentation, not timing or allocator-
metadata evidence. The public mount delta reconciles exactly:
8-byte owner field +24-byte box +1248-byte leaf +640-byte entries retained by
its record =1920 retained bytes. Requested delta is8+24+1248=1280 because the
entries vector was already constructed by the old adapter, then discarded.
No record is elided: direct-parent records also participate in scheduler replay.
This source remains frozen as the control for any separate representation fix.

## Existing complete-owner floor control

The unchanged unicode_text_measure example runs0/1/1000 labels three fresh
processes each. Every initial/edited BGRX hash matches the preserved original369
control (see prior flat-cache evidence for parent build attestation and limits).
At0 labels the d8 header restores the original floor exactly:5748 retained,
6976 total,5908 peak,34 calls. At1label retained14582 vs original14598 and295
vs297 calls. At1000 retained1189292 vs1197300, peak1316468 vs1324476,
total5396012 vs5404020 and14700 vs15701 calls:8008 fewer bytes and1001 fewer
calls. It costs8 bytes over flat31 in each case. Render/edit allocation rows
match. These labels do not exercise cold OOF record storage; the public list
above does and its tax is reported separately.

Raw source/build/rlib/executable fingerprints, CSVs, fixture sources, logs and
pixel-hash manifests are included. Binaries and raw BGRX files remain at the
immutable /tmp paths listed in manifests. No native UI, GPU, cross-platform,
speed or RSS claim is made by this stage.
