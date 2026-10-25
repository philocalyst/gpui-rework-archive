# One acknowledged transition

The native bridge can lower a bounded set of changed P entries without retaining
another semantic tree. AccessKit still owns its complete native tree. This is
an optimization of publication, not an incremental renderer or a replacement
for the shared public `Part`/`perform` contract.

The collector is installed only after native activation. It compares entries in
the existing presentation walk using disjoint old-P and candidate fields. The
one reused index vector is private, capped at 4,096 entries, and exposed only
after the matching actual acknowledgement. A failed newer preparation does not
discard an older coherent prepared scene. Its descriptor becomes untrusted and
that scene's eventual acknowledgement uses full projection.

Each descriptor has exact base and target stamps: window namespace through the
token, acknowledged sequence, P epoch and physical size. The bridge must have
the exact base and the owner must still expose the exact target. Missing acknowledged,
overwritten or post-prepare-patched transitions use the full path.
Focus remains live but must belong to current P; every update includes it.

Sparse eligibility also requires identical preorder identities, parent indices,
entry count and synthetic child shape. Changes to text, supported actions, full
original geometry, names, descriptions and frozen list positions are compared
exactly, without a hash. Native-only input TextRuns and exceptional renamed-text
Labels are replaced with their owning node. Every replacement includes all
unchanged native properties and the full ordered child list. Container child
lists are reconstructed by a borrowed preorder scan, with no retained index.
Window-size changes replace the synthetic window root through the full path.

Identity metadata edits use the existing logical identity map as a P-index hint,
verify exact identity, then fall back to a one-entry P scan if necessary. Field
metadata edits use existing nonvisual fanout destination indices, each verified
against the exact P identity before comparing frozen names. One mismatched hint
forces full projection; there is no new map or scan per destination. Multiple
ports at one site are deduplicated before publication. All-metadata publications
initially use full projection. None of these paths reads newer logical list
metadata for older P.

## Costs and limits

The accessibility build adds an 8-byte optional observer pointer per runtime,
besides the existing 8-byte acknowledged sequence. Headless/AT-disabled builds
omit both. Inactive native observation allocates nothing and performs no
comparison or conversion walk. Active observation allocates one 96-byte box and
one lazily grown vector (at most 16,384 payload bytes); deactivation drops both.
No node or presented-entry size changes. No history accumulates.

Sparse conversion is not O(1) end to end. Current focus uses a verified logical
index hint and scans P only on mismatch; absent focus returns the root. Common
field/inspector collection follows verified hints plus existing name lookups,
while a mismatched inspector hint scans P. Active visual preparation compares
nodes before it can discover topology/cap fallback.
A changed container may require a subtree scan to restore its child list. Dense
changes, scrolling and missed updates can lose relative to an unobserved owner.
The cap bounds retained index storage, not total native update allocation or
upstream OS/AT event traffic.

## Reproduction

The ignored fixture emits CSV rows for actual owner operations, full and sparse
projection, and projection followed by Consumer replacement. Owner cases pair
inactive/active observation on the same fixture size. The 100K-source scrolling
fixture exposes 27 P entries; it does not materialize all source rows. Projection
cases use one leaf change in 1K, 10K and 100K P entries. Repeated Consumer timings
replace an identical payload after warmup; they measure replacement overhead,
not screen-reader event delivery or an arbitrary changed-value workload.

```sh
cargo test --release -p gpui --features x11 --lib \
  native::accessibility::transitions::sparse_transition_measurements \
  -- --ignored --exact --nocapture --test-threads=1
cargo test -p gpui --features x11 --lib \
  native::accessibility::transitions -- --test-threads=1
```

Allocation counters report requested bytes, not RSS: `total_bytes` is allocation
churn, `net_bytes` is net retained change across the operation, and `peak_bytes`
is the maximum additional live requested bytes. Projection output is dropped
inside the measured operation; its peak includes its live payload, while its
net is zero. Steady owner turns reuse the descriptor's warmed vector, whose
retained capacity is reported separately. Timing samples exclude the allocation
instrumentation call. Percentiles are nearest-rank across 31 serialized samples.

The independent Consumer oracle checks every node's complete schema, full
physical bounds, parent/children and focus against a fresh full projection. It
covers 100K P, leaf and container edits, geometry, synthetic shape changes,
source edits, frozen list count/index updates, same-S scroll, same-size DPI,
resize, same-token new P epoch, missed updates, deactivation, exact namespace,
repeated acknowledgement, failed newer preparation and pending metadata.
The actual native AT-SPI Todo activation/edit/action/reactivation test and the
no-session-bus presentation test must also pass. Consumer/schema proof does not
substitute for VoiceOver/UIA/Orca or whole-process AT memory/latency evidence.

## Capture on this implementation

The captures below precede source-qualified text cohorts and the focus-hint
refinement. Their descriptor was 80 bytes; the current 96-byte descriptor adds
two monotonic field-authority bounds. Their timings are historical controls,
not rerun results for the later implementation. The current
[text authority evidence](../../evidence/native-text-selection/README.md) records
actual sparse discovery visits, allocations and full-tree oracles separately.

[Final CSV](evidence/accessibility-transitions.csv),
[storage ledger](evidence/accessibility-transition-storage.csv), and the
[initial all-P field-scan capture](evidence/accessibility-transitions-initial.csv)
retain the complete samples' summary counters and percentiles. Captured on
x86-64 Linux in the shared container, Rust 1.97.1, release optimization, after
coordinating a quiet CPU window; one batch of 31 samples per case, inactive
then active. These are qualified microbenchmarks, not randomized process pairs,
whole-process RSS or an end-to-end native/screen-reader latency claim.

| Operation | Inactive p50 | Active p50 | Active p95 / p99 |
|---|---:|---:|---:|
| 10K P field owner turn | 0.55 µs | 0.60 µs | 0.73 / 0.74 µs |
| 10K P inspector owner turn | 0.27 µs | 0.41 µs | 0.41 / 0.44 µs |
| 10K P geometry owner turn | 4.562 ms | 5.214 ms | 5.367 / 5.582 ms |
| 1K P dense owner turn | 0.612 ms | 0.669 ms | 0.842 / 0.866 ms |
| 100K-source scroll, 27 P | 47.84 µs | 47.82 µs | 52.72 / 53.96 µs |

The active geometry comparison tax was 14.3% in the 10K case. Dense 1K was
9.3% slower. The 10K dense inactive/active medians reversed (6.864/6.173 ms),
and the initial scroll capture also reversed; these are measurement variation,
not work-elimination claims. Both cases still use full native fallback. No
extra steady owner-turn allocations were measured for active observation after
warming its vector, but its retained storage remains charged separately.

The initial implementation scanned all P names for each field publication:
553 µs at 10K P. Reusing verified destination hints reduced the final active
field owner turn to 0.60 µs; a failed hint deliberately uses full projection.
The separate initial CSV preserves that losing design rather than hiding it.

| 100K P lowering | Converted nodes | p50 / p95 / p99 | Peak requested bytes |
|---|---:|---:|---:|
| Full projection | 100,001 | 22.69 / 23.12 / 23.25 ms | 31,449,031 |
| Leaf projection | 1 | 68.75 / 78.27 / 80.23 µs | 328 |
| Full projection + Consumer | 100,001 | 77.72 / 80.66 / 82.40 ms | 34,791,096 |
| Leaf projection + Consumer | 1 | 73.62 / 83.60 / 90.11 µs | 328 |

This source fixture exposes ordinary named/interactive divs. It does not
represent text shaping, complex geometry or a complete Library interaction.
The full projector and sparse projector share canonical node lowering, but the
correctness oracle compares independently constructed Consumer trees.

The measured model-independent `Runtime<()>` header is 2,344 bytes in this
accessibility build: eight more than its base, with no per-node size increase
(`Node` 128 bytes, P entry 80 bytes). Inactive descriptor payload is zero.
After dense 1K, the active observer held 80 + 4,096 bytes (999 indices after
port deduplication). Dense 10K crossed the collection cap, cleared its entries,
and retained 80 + 16,384 bytes for reuse. Deactivation releases that payload.
The underlying allocator may have additional metadata and size-class overhead.

Validation on the final hint implementation: 81 library tests passed (8 explicit
native/measurement tests ignored by default), strict X11 + Wayland all-target
Clippy passed, and the actual private-bus AT-SPI Todo proof plus the no-session-
bus CPU-presentation proof passed. The headless build's 60 tests also passed;
it omits the observer state. Existing Consumer tests include stale native action
IDs, session cancellation and callback saturation; the descriptor adds no new
action routing or public identity scheme.

Capture base: `b20a627b08`, with this transition patch. Release test-binary SHA-256:
`2380fb83bc8dcb6ae7f1aacf1feecf3c304372e5babc3a134e9ac41f82e8121a`.
The fresh native proof used Xvfb `:93`, the Nix AT-SPI 2.60.6 launcher and
`bash tools/test_atspi.sh "$GPUI_AT_SPI_LAUNCHER"`; it does not require a GPU.
