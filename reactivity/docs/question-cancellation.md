# Cooperative cancellation during Library search

`Completion::run_cancellable` adds one borrowed capability to the existing
worker helper:

```rust
completion.run_cancellable(input, |input, cancellation| {
    search_cancellable(input, |_| cancellation.is_cancelled())
})?;
```

The callback returns `Some(Result<T, E>)` to publish an owned answer, or `None`
to abandon this physical completion. `Cancellation<'_>` borrows the controller's
current-ticket atomic and stores the launched ticket. It carries no UI access,
allocation or additional Arc lease. Its lifetime prevents escape into a detached
thread or storage that outlives the compute callback. Ordinary scoped threads
may borrow it while the callback remains active.

The existing `run(input, compute)` remains available. It delegates to the same
panic/cancellation core and wraps its ordinary result in `Some`, so the two
helpers do not maintain separate terminal-publication protocols.

Cancellation is advisory. A current `None` becomes the existing `Abandoned`
fault; a superseded `None` frees physical credit without faulting the newest
Pending request. A returned answer is still validated against the source input,
coarse/policy generation, owner and consume-once ticket. An unrelated exact
source edit does not change the hint. Owner close cancels the hint and rejects
publication; code that ignores cancellation receives the same owned result back
from `CompleteError::Closed`. A worker panic remains `WorkerPanicked` rather than
a domain error or owner quarantine.

The Library worker checks at the beginning, every 128 tracks, and after the last
batch. It discards a partial result on cancellation and releases the old cap,
allowing the next ordinary owner delivery turn to dispatch the latest coalesced
query. It retains the existing 256-byte frozen UTF-8 query, fixed stack title
buffer and at most 128 result IDs. No per-track String is created. A cancelled
scan can still own its one 1 KiB result reservation until that scan returns;
the hint does not forcibly stop a stalled executor or forgotten cap.

Public owner tests pause a real scan at track 128, supersede its source, and
verify that credit stays occupied until the worker exits. The old scan processes
128 tracks instead of 250,000, then current query `Track 000042` produces exactly
ID 42 using the same scan and admission path. Other tests distinguish current
and superseded abandonment, cooperative cancellation after an unrelated exact
edit, worker panic, and close with an ignored hint. Compiler-failure examples
reject token escape and detached thread capture. A private allocation/lease
ledger checks the callback adds zero allocations and no controller Arc clone.

This improves obsolete-work latency; it does not change the O(catalogue size)
cost of a current full search or provide a general asynchronous query graph.

The quiet paired fixture measures cancellation-to-latest-dispatch latency at
8.434 ms when the worker ignores the hint and 29.611 µs with cooperative polling.
It stops obsolete work after 128 rather than 250,000 tracks. The current-query
remaining-scan control measures 8.384 → 8.463 ms (+0.94%); that losing observation
is retained. This fixture excludes the owner source edit, initial 128-track
prefix, latest query execution and native presentation. Exact method, raw rows,
artifact hashes and limitations are in `question-cancellation-evidence.txt` and
`question-cancellation-cost.csv`.
