# Direct lazy Cephal cache handles

Source `31e38bc00e` is based on `36921e2c42`, with Cephal perf/cold-layout
20c4c494. NodeCache already wraps an optional boxed private inner; the adapter
now stores that handle directly instead of allocating another box around it.
Removed, reused and newly cheap slots reset to a fresh empty handle. The shared
empty cache is gone, so hidden and speculative bookkeeping belongs to its node.

The readonly vendor addition NodeCache::allocated_bytes reports actual inner
and spill payload, zero for never-allocated handles, excluding the handle,
allocator headers and RSS. The adapter renames cache_inline_bytes to
cache_heap_bytes and sums those real payloads. Vendor provenance records the
small local addition; cache equations, eviction and query policy are unchanged.
On this x86_64 build the handle is8 bytes, inner360 bytes, spill584 bytes.
The first three size answers retain360 bytes; the fourth reaches944. clear
retains those allocations. Flat LayoutTree is656 bytes; its lane keeps an8-byte
handle per slot. This is a payload ledger, not a complete memory/RSS claim.

## Complete public-owner control

The unchanged public unicode_text_measure example runs three fresh processes
for each of0/1/1000 labels and each variant. Every source/executable guard
passes; initial and edited BGRX hashes match exactly across all18 processes.
Node, draw and measure counts match. Timing columns remain raw but are not used
for claims. The original executable is root's immutable369 control; its exact
build command and clean tracked-source state come from the parent's explicit
attestation, not a retroactively captured prebuild status or feature file.

Mount changes are0labels:-8 retained/total/peak bytes and no allocation-call
change;1label:-24 bytes and2 fewer calls;1000labels:-8016 bytes and1001 fewer
calls. At1000 labels retained payload changes1197300 to1189284, peak1324476
to1316460, total requested5404020 to5396004, calls15701 to14700. Render/edit
allocation records match exactly. This is about8KB on the1.2MB owner fixture;
it is not a large RSS or speed result. Later OOF storage adds its own header
and must be measured separately; this evidence does not include that stage.

## Correctness and preserved counterexample

Core verify-cache tests:31 passed. Full vendored upstream verify-cache gate:
59 passed,15 ignored, including the new private-payload regression. Strict
release core all-target Clippy passes. Full raw logs are retained.

The independent fresh vendor-owned oracle reproduces a real old-adapter bug:
move a previously visible20x10 leaf into the second of two newly hidden sibling
containers. Their shared empty cache carries the first sibling's hidden mark,
so the original adapter skips zeroing the second subtree and leaves20x10
instead of0x0. The exact regression fails the original adapter with exit101
and passes the flat adapter. That original-adapter control includes the same
readonly vendor-accounting addition; vendor layout equations are unchanged.
Both failure and success logs and source guards are retained, not relabeled.

source-pins.json, owner-results.json and build JSON connect source commits,
executable hashes, raw pixel paths and all allocation rows. Raw original and
candidate executables and BGRX outputs remain at the recorded /tmp paths.
No native UI, hardware, cross-platform, timing or GPU residency result is
claimed. Parley12, zbus6, build-time WGSL and later main integrations are not
part of this369-based comparison.
