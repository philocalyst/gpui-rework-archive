# Consuming line-break checkpoint controls

The final A correctness source remains 86dd5861429522a2ce4dd8c0edb3a6f3483a7d04.
These producer controls start from the independently qualified usize query source
6654378606c052bb39c9338e85441e98b5b86835 and add the test-only bundled-font
registry guard. They do not incorporate the separate intrinsic-measurement map
suppression control. No timing or foreign-runtime result is claimed here.

A Linux/glibc LD_PRELOAD diagnostic brackets the existing first-C allocation
fixture's stdout, without production hooks. Of its 33,917 calls/26,285,158 B,
33,511 calls/67,022 B come from BreakerState's derived clone of a two-byte
contributed Vec on each break_next checkpoint. The stack leads through
break_remaining, break_all_lines and canonical interactive shaping into Cephal
intrinsic measurement. The independent allocation_counter bracket reports
33,912 calls/26,284,998 B; the profiler includes five small reporting allocations
(160 B). It is diagnostic attribution, not an exact retained-memory or timing
measurement; malloc/calloc/realloc are covered and aligned-only allocation is
not. Static aggregation is bounded at 4,096 stacks, with no bucket overflow.
The full raw stack log, interposer source and dominant source resolution are
retained. This disproves the proposed per-glyph raster/resource explanation.

Two separate formulations preserve the same public producer algorithm:

* Reuse control 25afef52bcdc1ec569d2168cc2a0314e540f5215 (complete test pin bd8319039a5f40c606158da7799f0b75152ef5c5)
  manually implements BreakerState clone_from to reuse checkpoint Vec storage.
  It retains the checkpoint work and may hold the maximum checkpoint capacities
  until paragraph completion. Its extra field-by-field clone maintenance is
  charged as a losing control.
* Batch source bb0c9eecdd771cde820ec28d924be406c961282f (complete test pin
  09680e2a313dbf6ecb25e92c8243cd7c2bb75ba3) removes that work entirely from
  consuming break_remaining. Public break_next still saves its original
  checkpoint before the single shared private break body. The batch loop uses
  the same readiness assertion/body/custom-out-of-flow policy. No flag, new
  cache, generic boolean specialization or second line-breaking algorithm is
  introduced. Public revert/revert_to remain unchanged. finish and Drop compute
  final line/dimension state without reading prev_state; only public revert
  observes prev_state, and the consumed batch cannot invoke it afterward.

The production-API fixtures compare batch, incremental, public revert,
external saved-state revert, partial incremental→batch and maximum-height
repair. They compare source ranges, all line-metric bits, glyph IDs/source/
position bits, inline-box order/kind/geometry/baseline bits, and complete layout
width/full-width/height/constraint bits. Cases include zero width, zero line
height, TOP-aligned larger text, empty/trailing/consecutive separators, CRLF,
U+2028, bidi isolates, Arabic/Hebrew, combining marks, ZWJ, and in-flow/custom
out-of-flow inline boxes. NaN width retains the existing caught assertion.
Immutable raw registered font bytes avoid the unrelated bundled-ID registry
lifetime test; no production testing API was added.

| First-C owner fixture | Allocations | Requested bytes | Peak extra | Retained |
|---|---:|---:|---:|---:|
| A 24 B stop map | 33,912 | 26,284,982 | 15,569,616 | 2,262,476 |
| Reuse checkpoint | 401 | 26,217,960 | 15,569,616 | 2,262,476 |
| Batch without checkpoints | 399 | 26,217,956 | 15,569,616 | 2,262,476 |

The A table uses its default-feature ledger; the separately profiled full-feature
A artifact has +16 requested/retained bytes from its runtime feature layout.
Do not mix those feature-qualified values. The batch cut leaves all retained
geometry and the large transient producer storage unchanged. Its old-P/new-C
fixture is 357 allocations; old-P/old-C/failed-L is 354; old-C ACK allocates zero
and releases the same 1,655,232 B. These are allocation/work results, not a speedup
claim. The next controls still need to address 24 B stops, growth slack and
always-interactive intrinsic maps separately.

An initial batch command reused a common Cargo target and accidentally ran the
reuse artifact (same package source/version fingerprint collision). Its log is
explicitly rejected, preserved, and excluded from every gate/result. Fresh
source controls use distinct targets /tmp/gpui-text-reuse-target and
/tmp/gpui-text-batch-target. Final manifests pin source, tracked source hashes,
command, features and executable SHA-256; immutable binaries stay outside Git.

At complete test pin 09680e2a313dbf6ecb25e92c8243cd7c2bb75ba3, full
Canvas+parallel passes 190 cases/4 ignored; default GPUI library/public/doctests
pass 453 cases/8 ignored. Strict default-feature all-target GPUI+Canvas Clippy
passes. The independent full-feature A native/foreign campaign remains pinned
to its own source; it is not retagged as this producer control. Final allocation
ledgers are rerun from the guarded immutable binaries at
/tmp/gpui-text-producer-controls/{batch,reuse}/{gpui,gpui_canvas}; results.json
also records the executable digests of the full public gates. The shipping
first-party core stays 29,110 code lines including 13 build lines; producer/vendor
and archived diagnostic code are outside that scope and separately charged.
