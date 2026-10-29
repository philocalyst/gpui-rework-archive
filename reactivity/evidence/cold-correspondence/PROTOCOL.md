# Cold correspondence emitted at live reconciliation

Parent e2cc1712443473c0d8a15224141c85a538647518; shipping baseline remains
b2d48370d75482e300befd81d4f0bcbbedd560c7. Closed paint result NOT ADMITTED,
single1024=1.103170. Preserve the326-byte outside-group corruption; correspondence
is identity/position information, not dependency or resource authority.

Emit ordered old/new correspondence runs while the existing reconciliation loop
already consumes each admitted node. No post-hoc old/new snapshots or extra
identity registry to derive the encoding. Reuse existing identities and actual
previous_index only when reconciliation accepts that identity. Run payload is
old_start/new_start/len; new literals use an explicit absent-old sentinel. Runs
may fragment under reorder; report actual counts and allocated capacities.

Canonical cold record is24 bytes: existing u64 identity, packed u64 links
(parent/ordinal/handler), u32 content, u32 component scope. Compare raw canonical
records, absolute-parent blocks, and otherwise identical relative-parent blocks.
Relative displacement replaces only parent bits; every other bit roundtrips.
Use bounded32-record column bit packing with exact unsigned bases/widths and raw
block escape. Tiny<=8 records uses raw storage. Charge container headers, block
directories, capacities, correspondence runs, literals, bounded decode scratch,
new encoded data, old retained versions and temporary producer storage. Count
logical record changes separately from bytes of complete blocks rebuilt and
metadata written. A shifted block boundary can erase tuple-level rewrite savings.

This is a test-only shadow representation experiment, not removal of the existing
Node Vec. Include that live raw mirror in actual retained/peak accounting; show
hypothetical replacement storage separately. No GPU upload, coherent shared
memory, producer-locality, latency, adoption or ZGX claim. Description,
reconciliation, identity-index rebuild, layout and paint work remain charged.

Exact decoding must cover all cold fields, tiny0..8 and block boundaries,
max-width/high-entropy values, repeated records, inserted/removed identities,
keyed reorder fragmentation, unkeyed reminting and stale/foreign correspondence
rejection. Preserve old/new correspondence endpoints without promoting them to
paint/resource authority. Test-only code may retain alternative control stores;
report each alternative separately and combined instrumentation storage honestly.

Re-run the existing live structural fixture with decoder equality asserted inside
reconciliation, and its raw CPU/full-GPU pixel oracles and outside-group mutant.
No new timing campaign. First decision: encoded storage/rewrite costs versus
unchanged total producer work; determine whether the next representation step is
justified. GPU emission extents and incremental dependency/resource closure stay
subsequent work. All changes remain local.
