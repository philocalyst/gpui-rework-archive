# Exact RTL count successor, not yet qualified

Shipping source **d54bde3736**, parent evidence archive faecfafda2, preserves the
no-reserve shipping control **8d81d28bc4**. The only production change is three
lines in the shared walk: after clearing the RTL buffer, the partial const ADMIT
specialization reserves run.len() slots before the visual prefix loop. The
atomic const-false path keeps its existing maximum pre-reservation and adds no
new count.

Run::len uses the existing Character.grapheme_start flag scan. No new map,
retained field, source-range preflight, segmentation or prefix arithmetic is
introduced. Normal Vec::reserve preserves reuse across later increasing runs;
first4500-slot capacity is expected to be4500 rather than8192. This is arithmetic
from the reservation contract, not a measured successor allocation result.

Compilation is on hold under root coordination because other native links are
saturating host I/O. All passing focused tests in the parent directory belong
only to8d81. Actual count codegen, scalar/vector behavior, allocations, complete
owner transcript and successor qualification remain pending. No successor
assembly, test pass, speed result or adoption is claimed.

The source bill for the six shipping libraries remains30448 non-test code lines
(`core-lines.json`). Vendor geometry adds three code lines to542, becoming545;
the authored total delta from indexed1d5 is451 shipping code lines. This source
bill is separate from pending compiler-generated code and retained space costs.

## Qualified narrow results (later capture, exact d54 source)

The subsequent narrow batch passed18 focused private tests, the complete Canvas
pair/packed Stop oracle (94,176 accepted /41,760 snapped /11,096 distinct), and a
same-binary index/atomic/partial scoped allocation check over10 cases. The exact
source guards421 and required release artifacts fresh:false are recorded in
build-input-guard.json and release-metadata.json. Fourteen absolute complete
TextLayout allocation rows are saved; no timings were run.

The actual root config SHA46b48c4505d0c06d229d14f1a819ea294ce2e81ed2c870aefae812dd9e36d295
injects v0 mangling and tokio_unstable. Historical frozen control fingerprints
have rustflags:[], so they are NOT matched compiler controls for this capture.
actual-fingerprints.json records the difference; old binary labels are unchanged.

The frozen complete Canvas binary is /tmp/gpui-caret-transaction-bin/d54-caret-pair-measure,
SHA1e5d6ca473ccd97fdec8b91893e5724fd7a66434ac934c12153da20b9fffb9a4.
The independent minimal public-API codegen binary is /tmp/gpui-caret-transaction-bin/d54-codegen,
SHA5810fa7772b34d2a680b89d4d8ca0401f80c8e5b485bfb9f65ffdca0fd3763ad.

Actual count_graphemes is306B: scalar byte loads and integer adds, unrolled four
characters with a scalar remainder. No SIMD or popcount is emitted. The176B
flag_count wrapper resolves the run's shaped slice before calling that counter.
Only the forced flag_count wrapper references the counter in the minimal atomic
client; the const-false walk adds no counter call. The atomic API's Result::expect
retains a21B CursorGeometryRestart Debug formatter. The Canvas partial binary has
no formatter symbol. A static impossible-state panic cleanup is therefore worth
pricing separately; d54 remains frozen as the pre-cleanup control.

The scoped allocation matrix prices the tradeoff honestly.32KiB ASCII index
requests655360B, atomic and partial0B. Wrapped RTL index367200B; atomic2calls/172B
and partial3calls/204B. Mixed index417600B; atomic2calls/132B and partial2calls/136B.
The partial reserve strategy is not a universal allocation win over the old
atomic stream. All variants produce identical geometry checksums and retain0B
of the scoped lookup; retained TextLayout costs are in the separate complete
layout rows. Native83/owner capture remains pending.

Vendor Clippy produced exactly the three previously archived baseline warnings
(two collapsible_if and one pre-existing Cursor::from_byte_index doc spelling).
The suspected TextLayout doc warning did not occur; no new warning is claimed.
The existing full initial stock-font failures remain in the parent archive.
