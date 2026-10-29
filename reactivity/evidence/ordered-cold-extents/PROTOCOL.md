# Ordered immutable cold extents emitted by live reconciliation

Parent8714afdf2e81803693172acd981127d521f478a1. No adoption of the previous cold
codec; paint stays NOT ADMITTED (single1024=1.103170), A/B unchanged. Existing
semantic identity/remint rules, raw Node Vec and raw renderer remain authorities.
The326-byte outside-group damage and704-byte cold-equality/paint-change witnesses
remain constraints. No new paint, timing or broad rendering campaign.

Implement an actual ordered store sharing immutable encoded block extents across
current/retained old logical versions. Keep the previous four-column block codec
unchanged to isolate extent preservation. Compare absolute and relative parent
interpretations; neither is preselected. Existing raw canonical and fixed ordinal
block controls remain. No new semantic identity registry or snapshot-derived
producer adapter. Every new cold row is received in the live reconciliation loop.

A reusable row must retain identity and match all encoded cold fields under the
candidate interpretation. An extent is a contiguous slice of one immutable
block; adjacent slices coalesce only when the same block and physical adjacency
permit it. Partial reuse splits descriptors, not payload. New/changed rows encode
new blocks of at most32 records; flushing before a reused extent may make small
blocks, which is charged. Old block leases remain immutable through every reader.
Run correspondence by itself is never permission to reuse the bytes.

Each ordered piece carries its logical start, physical offset and length; random
rank lookup uses the ordered directory. Charge prefix/descriptor maintenance and
lookup comparisons. A cached piece cursor may skip a directory search only when
its actual extent contains the requested old rank. No global identity/rank repair
is hidden. All producer records, old decodes, comparisons, new block bytes,
retained payload, directory capacities, lease/header overhead and scratch count.

Predeclare a fragmentation escape: if piece count exceeds2*ceil(N/32)+2, compact
through the implemented new ordered store into fresh32-record blocks, counting
all decoding/re-encoding/directory work and discarded staging. Tiny<=8 uses raw
storage, with all remaining metadata still charged. This is not a claim that raw
payload fallback fixes total tiny overhead. Preserve the permutation adversary;
report when saved payload becomes descriptor work or a full compaction.

Retain current plus two old logical versions in the bounded experiment; also
check an explicitly held older reader remains exact after owner history retires
it. These are CPU immutable leases, not GPU fences. Count unique shared blocks
once, every live version directory, Arc allocation/control bytes, and temporary
old+new+compaction ownership. Measure/verify control overhead independently.
No resource table, shader or GPU submission consumes this representation yet.

Run the existing live structural fixture with exact reconstructed cold equality
against raw controls and independent CPU/full-GPU pixel oracles. Record sizes
4/32/256 unrelated siblings and insert/remove/keyed reorder/unkeyed reminting;
include the existing32-record permutation and codec tiny/entropy boundaries.
Observe live producer allocations separately from post-update diagnostics.
Description/reconciliation/index/layout/paint can still be O(N): extent reuse is
a representation result only. The raw mirror remains charged. Decide from actual
retained and produced/copied bytes, not hypothetical descriptor publication.
All changes remain local; no shipping, timing, shared-memory or ZGX claim.
