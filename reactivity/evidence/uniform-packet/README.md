The [uniform-packet experiment](unadopted/README.md) replaces the resident-word
prototype's tagged records and per-run writes. It remains unadopted: exact
readbacks pass, but matched linked code grows and timing has not been qualified.

The [coverage frontier](coverage-frontier/README.md) adds borrowed SIMD word
comparison and sample-invariant/opaque-prefix work elimination. It preserves
the actual signed-zero failure and subsequent exact readbacks, final fallback,
offline and cross-platform checks, and the full source/linked-code bill.
It also remains unadopted pending matched performance gates.
