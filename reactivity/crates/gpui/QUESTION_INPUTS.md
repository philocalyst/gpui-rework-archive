# Declared question input families

`Questions::question` accepts a `Source`, an earlier `Reader` from the same plan,
or a pair. Larger families nest pairs; there is no fixed public tuple-arity
limit or generated registration macro.

```rust,ignore
let (plan, rows) = Questions::new().question(
    (Library::QUERY, Library::DESCENDING),
    |(query, descending)| freeze_ordered(query, *descending, count),
    move |input, completion| worker.start(input, completion),
)?;
let (plan, caption) = plan.question(
    rows,
    |rows| rows.summary(),
    move |input, completion| service.start(input, completion),
)?;
```

The model forwards inert `Reader<T>` keys. Question slots, versions, execution
closures, and readiness remain in the exclusively owned static lane chain. A
Source family borrows registered values; an earlier Reader borrows only its
current Ready payload through the existing checked borrowed `Any` seam. Input
resolution and diagnostic visitation use static generic dispatch. There is no
per-dependency vector, allocation, refcount, boxed producer, future, or result.
The existing cold `Sources` registration and `Reader.project` descriptor erasure
still have their previously documented costs.

A declaration rejects a foreign or non-earlier Reader before mounting. Pending
and Fault may retain a previous value for display; that value never becomes a
fresh worker input. A blocked question records the observed revision/readiness
pack and cancels its previous logical request. Reobserving an unchanged pack
neither freezes nor starts work. Blocking and retrying may advance the logical
ticket without launching a physical completion. A dependency fault borrows the
upstream failure when projected; it does not clone or erase-own the domain error.

Each question retains a concrete inline version pack: Source revision, Reader
ticket plus status, or a nested tuple. Source identities are already in typed
input handles. Checked coarse-owner and retry counters remain per question.
Every changed declared cohort mints a new request stamp, including A→B→A and
replacement discovered by a coarse owner operation. Exact unrelated fields do
not cancel the question. A matching completion revalidates the entire current
pack and readiness before consuming request admission. The transport carries
only its independent owner/site/ticket stamp and typed result; duplicating the
version pack in each work item and completion is unnecessary.

`QuestionInfo.input` is the single-Source convenience: it is None for a pair or
Reader family, and when no valid observed Source pack remains (for example after
a binding rejection). Use
`Win::visit_question_inputs` for every member of the observed declared family,
in order. Its callback receives Source versions or Reader key/ticket/status
records; it does not receive payloads or worker authority. This describes direct
declared inputs, not a flattened transitive graph.

Earlier lanes settle first. In a frozen delivery batch, ordinary model callbacks
first commit and refresh inputs; upstream completions then admit before their
dependents are refreshed. A dependent's sealed old completion is checked only
after that refresh. It is rejected as stale, its physical credit is retired, and
the latest snapshot may start once. Synchronous new completions cannot enter the
already sealed batch. There is no view description or semantic publication
between upstream admission and dependent settlement. The normal single owner
barrier publishes afterwards; presentation failure retains accepted answers.

Transport `received` and `applied` count actual sealed terminals and admitted
messages/faults. Derived readiness/fault propagation is not another consumed
message. A checked rejection still retires each sealed physical lease. The
existing one-cap mailbox, borrowed cancellation, bounded latest frozen input,
atomic close and shutdown protocol are unchanged. A running canceled worker
continues to occupy its one physical credit until it terminates.

This is a static earlier-only dependency DAG, not dynamic tracking, memoization,
output equality cutoff, arbitrary cross-owner dependencies, or a complete cohort
reader graph. Admission checks scan declared family members. Resolving Reader
keys scans the earlier static lane chain, so larger chains can cost more than
linear time overall. The intended first use is a small declared family, not a
claim that arbitrarily large graphs are free.

## Measured storage controls

Rust 1.97.1, x86-64, default features, `u64` input/output and `Infallible` error.
The baseline is commit `724ece73cb`; allocator values are requested bytes, not
allocator usable size or RSS. `Questions` includes its inline lane and plan header.

| Record | One-source baseline | Input-family implementation |
| --- | ---: | ---: |
| One-source plan | 384 B | 328 B |
| Bound question set | 376 B | 320 B |
| Completion handle | 72 B | 40 B |
| Response controller | 96 B | 64 B |
| Cold plan allocations | 2 / 152 B | 2 / 120 B |
| Reader key | 16 B | 16 B |
| Reader projection description | 2 / 88 B | 2 / 88 B |

The family implementation's two-source plan is 368 B, three nested sources 416 B.
Their inline revision packs are respectively 8 B and 12 B, with optional observed
packs 12 B and 16 B. One source's optional pack is 8 B. A Reader version is 16 B
(ticket plus readiness); a Reader-plus-Source dependent adds one 80 B allocation
for its controller, sharing the plan's scope. The complete two-question plan in
that fixture is 656 B. These values include concrete closures and error/result
types used by the test; larger owned inputs and results still enlarge the owner.
An unused empty plan allocates nothing. No field was added to Win's default empty
lane, Runtime, Signal, node, or presented sheet.

The savings come from removing duplicate worker/work-item `InputVersion` records,
not from packing revisions, weakening admission, or returning borrowed snapshots.
The diagnostic `InputVersion` remains 32 B for compatibility. The owned work item
for `u64` is 40 B. Dependency failure stores only a marker; keys already live in
the typed inputs and the observed pack identifies the fault. The outcome enum in
the measured fixture is 24 B. Allocation and type ledgers are executable unit tests
in `reader.rs` and `reader/question.rs`; the Library still allocates its one capped
128-ID result vector and explicitly opts into one 256 KiB-stack worker service.
