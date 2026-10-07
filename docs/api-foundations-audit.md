# Foundations API documentation audit

This pass reviewed the public Rust interfaces in the supporting crates that
underpin GPUI collections, scheduling, path handling, shared strings, and Tokio
integration. The implementation remains the authority; the edits describe
observable ownership, ordering, summary, cancellation, and error behavior.

| Crate | Public declarations read | Contract work |
| --- | ---: | --- |
| `gpui_scheduler` | 84 | Added deterministic test-run and clock semantics, task cancellation and readiness contracts, executor backing, and Tokio-style task handle terminology. |
| `gpui_collections` | 27 | Documented hash aliases and every borrowed `VecMap` entry insertion operation, including insertion-order behavior. |
| `gpui_sum_tree` | 107 | Documented ordered map/set operations, filtered cursors, seek positions, and the map range/update contracts. Existing summary and dimension docs were retained where accurate. |
| `gpui_path` | 80 | Documented platform style predicates, splitting, prefix behavior, owned relative-path mutation, and absolute-path conversion/error boundaries. |
| `gpui_shared_string` | 4 | Existing ownership and conversion docs were read and retained. |
| `gpui_tokio` | 6 | Documented the adapter namespace and the configured-runtime panic boundary. |

## Contract notes

`TestScheduler::run` drains currently runnable work without moving time;
`run_with_clock_advancement` additionally advances to pending timers. This
distinction matters when a test wants to prove that a timer is still pending.
Task handles cancel on drop and detach transfers completion ownership to the
scheduler. Tokio adapters apply the same cancellation relationship to Tokio's
abort handle, while `handle` requires prior initialization.

`TreeMap` and `TreeSet` retain ascending key order. Range removal is half-open,
`closest` is less-than-or-equal, and `iter_from` starts at the first key not
less than its argument. `SumTree` dimensions and summaries remain the source of
truth for cursor positions; the cursor must be sought or moved before item
inspection.

Relative paths are normalized, UTF-8, and stored with `/` separators. Absolute
path constructors reject relative input; platform parsing is explicit through
`PathStyle`. `VecMap` is insertion ordered and intentionally linear, making it
appropriate for small maps rather than a general hash-map replacement.

No executable code, signatures, tests, generated docs, Cargo metadata, builds,
commits, or pushes were changed. The remaining unexpanded implementation
details are private node balancing and scheduler queue internals; their public
effects are covered by the contracts above.
