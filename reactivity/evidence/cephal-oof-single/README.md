# Single-record cold ownership, with measured promotion cost

Source d0608d5fd6 is a representation refinement over frozen OOF source
d8f40d7126 and its evidence e10e7aeb42. These controls all remain based on
main36921e2c42 / Cephal perf/cold-layout20c4c494. Later main dependency and
shader integrations are outside this comparison.

The complete record stays authoritative. A boxed Empty/Single/Many enum keeps
one record directly in the cold allocation and promotes to the same BTreeMap
only on a second distinct live holder. Replacement, temporary take/reinsert
and borrowed lookup preserve the original scheduler contract. Many never
automatically demotes, even when temporarily empty; existing successful-
compute and structural invalidation boundaries release empty owner storage.
There is no new retained tree, index, per-node header, placement cache, unsafe
code, public application knob or production executor.

On this Linux x86_64 Rust1.97.1 build the enum is112 bytes (the compiler uses a
niche), not an estimated120. LayoutTree stays664 bytes, with one8-byte optional
cold owner handle and no cold allocation until the first record. The old map
requires24 boxed header bytes +1248 bytes for its first leaf. A Single holder
therefore saves1160 bytes and one allocation. Promoted Many pays88 extra box
bytes. These sizes are target/compiler measurements, not ABI promises.

The independent ledger includes the exact extracted shipping enum/impl, with
byte equality checked against the frozen source. It measures112 bytes/1call
for the cold box; Single insert, replacement, take/reinsert each allocate0;
second-holder promotion requests1248 bytes/1leaf. Holders3..11 add0; holder12
requests2592 bytes/2nodes, as before. After removing down to one then taking
and reinserting the last holder, Many allocates0; it retains its leaf rather
than oscillating representations. This isolates representation costs from
record-owned entry vectors and layout/query work.

## Ordinary public GPUI list

The public driver, manifest and lock are unchanged from the frozen d8 control.
It uses ordinary Win/ItemSource/uniform_list with1000 Unicode rows and13
realized rows. Three fresh processes per old/new variant run mount, scroll,
one visible text edit, one width/background edit and return. Each phase passes
a separate eager-view all-pixel oracle; every paired pixel hash matches. Work
counters match exactly: text/style each2 measures,1 layout,1 source operation.

Mount changes d8 -> Single:

| requested payload metric | d8 BTree owner | Single owner | delta |
|---|---:|---:|---:|
| retained bytes |63138|61978|-1160|
| total requested bytes |271085|269925|-1160|
| peak new bytes |114068|112908|-1160|
| allocation calls |658|657|-1|

Scroll/return also request1160 fewer bytes and one fewer call, with unchanged
retained/peak. Text/style allocation rows are identical. Against flat31 (which
lacks general OOF replay records), Single still retains760 extra bytes:
8 owner +112 cold box +640 entries. Requested mount tax is120 bytes/1call;
those640 entry bytes were already constructed and discarded by flat31.
This improves the new correctness implementation's tax; it does not erase it.
Direct-parent records are retained because they participate in scheduler replay.

Actual Valgrind3.27.1 Massif stacks from the unchanged frozen new executable
confirm112 bytes at Engine::set_absolute_context and no AbsoluteContext BTree
leaf in this fixture. The full raw14MB trace is compressed intact, with its
hash and pre/post executable guards; all public pixel oracles pass under the
profiler too. The old full141MB trace and stacks remain in preceding evidence.
Profiler wall time is not used as a performance result.

## Multiple holders, bounded edits and the empty-owner floor

The1000-row core fixture uses a synthetic measurement callback and fresh vendor-
owned cold oracle after every phase. Three fresh processes per mode/variant
have identical work counters and pass all strict normal-policy edit budgets.
Plain mode allocation rows are identical. Three-holder OOF compute pays88 extra
retained/total/peak bytes, with2047 calls unchanged. Text/style/placement
allocation rows match. Reparent requests88 extra bytes (2368 ->2456), retained0,
peak192 and11 calls unchanged: structural invalidation releases and rebuilds
its cold owner, so the larger Many box is charged again. This cost is retained
in the raw rows and is not presented as a multi-holder memory improvement.

The unchanged unicode_text_measure driver runs0/1/1000 labels three fresh
processes each. All initial/edited pixel hashes match the preserved d8 and
original369 controls. All allocation/work rows match d8 after excluding raw
nanoseconds;0 labels remain5748 retained /6976 total /5908 peak /34 calls.
At1000 labels it retains the previous stage's8008-byte and1001-call saving
versus original369. These label trees do not allocate OOF records. Raw timing
columns are retained without making timing claims.

## Correctness gates and emitted-code charge

Both normal and cephal/verify-cache release core suites pass41 tests:5unit,
20layout,13tree,3lifecycle, none ignored. The new owner test covers same-holder
replacement without promotion, exact allocation identity through take/reinsert,
second-holder promotion and non-demotion. A48-root fixture crosses multiple
B-tree nodes, removes/reuses capabilities, changes containing blocks and checks
each surviving forest against a fresh vendor-owned tree before removing all
holders. Previous nonparent/fixed/absolute, randomized lifecycle, rollover,
speculation and poison authority tests remain. Strict release all-target core
Clippy passes. The defaultSIMD GPUI headless library gate passes127 tests with
5 ignored. Logs contain the exact ignored test names; no native/GPU claim follows.

The unchanged public consumer executable grows6680 bytes; linked .text grows
2880 bytes. Raw sections and executable/rlib hashes are included. This is a
small structural allocation tradeoff, not a startup/CPU-speed or RSS result.
Requested payload excludes allocator metadata. No compile-time comparison is
claimed. The first external copy helper omitted executable mode and the capture
stopped with PermissionError; that raw setup failure is preserved, the helper
now preserves mode, and the complete105-row guarded capture was rerun.

results.json connects frozen source/executable hashes,105 raw rows, full pixel
hash references, work equality and pre/post guards. Build JSON records actual
features and rlibs; source-pins.json also checks the extracted ledger code.
Raw executables/rlibs and BGRX files remain at recorded immutable /tmp paths.
Prior evidence preserves all unsuccessful d8 formulations and diagnostics.
