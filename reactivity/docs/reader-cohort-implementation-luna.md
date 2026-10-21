# The smallest honest Reader/cohort seam

Read-only implementation/research audit, 2026-10-21. Sources inspected in the active cleanroom under `/root/gpui-ce3/reactivity`; no production source was changed for this report. The recommendation is a narrow one-input, one-question implementation slice, not an immediate general async DAG.

## Decision

Ship a typed Library search question as the first Reader proof: one explicit `Source<Library, Query>` input, one immutable bounded worker snapshot, one latest-wins request gate, one `Remote<SearchCompletion>` lane, and one typed `QuestionState<ResultIds, SearchError>` retained by the Library owner. Keep the result state private behind a scoped `Reader`/boundary facade if the public API is introduced in this slice. Do not expose general `.map_async` until moving, revocation, cohort semantics, and heterogeneous static registration have passed this real use.

For this first question, input authority should be the tuple

```text
{ owner lifetime, producer/site incarnation, request ticket,
  input Source<FieldId>, Signal<Revision>, conservative coarse-owner epoch,
  policy generation }
```

The `Signal` revision detects edits made through the same source instance; it is only a local mutation hint. Add a **separate checked `coarse_owner_epoch`** as the conservative replacement barrier: arbitrary `Win::update` can replace a `Signal` with a new instance whose revision starts at zero, so it must supersede outstanding questions even when values compare equal. This over-invalidates on unrelated arbitrary owner edits, an acceptable first-slice price. Exact typed edits to an unrelated source should not cancel the question. Do not compare `Runtime::source_epoch` directly: it increments for every typed operation too, so that would cancel on unrelated exact edits. `A → B → A` advances the ticket even when the final input value equals the first.

The key design economy is to reuse existing typed boundaries instead of installing a parallel observer graph: freeze the one declared input after source admission, move one bounded snapshot to a worker, return one owned completion through `Remote<T>`, and run the same typed admission check in the owner turn. There is no per-`Signal` atomic, graph-node allocation, boxed future, erased payload, retained app pointer, or cross-thread owner borrow. The first implementation pays only for the declared question and its mounted producer.

## Exact starting point and gaps

The active state crate has an inline `Signal<T> { value, Revision(u32) }`; `DerefMut` checked-increments the local revision before returning `&mut T`, even for a no-op edit or unwind. Serde restores a fresh revision-zero signal. Thus `(FieldId, Revision)` is useful only while that source instance is known to persist. `Win::set` uses a typed `Source` route, while arbitrary `Win::update` has only owner-grain authority and can replace fields. `Runtime::operation` increments a checked `source_epoch` only after the edit callback returns normally, then runs the source barrier. A presentation failure does not undo a successful source edit.

`Remote<T>` is already the right transport primitive for a typed completion: bounded `sync_channel`, owned payload return on `Full`/`Closed`, no application callback on the producer, a unique inbox staged by the owner, static `Lane<T,F,L>` dispatch, and a fair count-budgeted drain. It is a FIFO stream, not a Reader: it has no request/input stamps, latest-wins policy, outcome state, byte quota, or graph edges. Its capacity is message count and the staging ring can retain another capacity of messages; a large `Vec` payload is not byte-bounded by the channel.

`RequestGate` already implements owner-scope revocation, checked producer/ticket generations, and consume-once latest request admission. It documents that callers must call `begin` on every frozen-input/policy change, including `A → B → A`, but it explicitly neither carries nor validates source versions. Its `RequestStamp` is 32 B on 64-bit systems and clones one `Arc` token; owner token allocation is once per owner lifetime. That is a sensible correctness primitive, but not a graph or cohort implementation.

The gap is therefore precise: there is no `Reader<T>` declaration in the active source tree, no committed typed relation from a question to its source input, no frozen source-version tuple in the request record, no outcome slot retaining Ready/Pending/Fault, and no source change hook that starts/restarts that producer. `Sources::scan` reads registered revisions, but this is a baseline scan rather than a Reader dependency graph. `Sources<M>` currently erases cold source/component descriptors behind `Box<dyn Field>` and `Box<dyn ComponentSchema>`; “no dynamic dispatch” cannot mean no `dyn` anywhere. It can and should mean no per-producer `Box<dyn Producer>` or `Box<dyn Any>` result. Executor task allocation is separate and must be counted rather than denied.

## Minimal typed implementation

Use an application-level typed input/output pair first:

```rust,ignore
struct SearchInput {
    query: SmallBoundedString,        // or bounded owned String at first
    catalog: Arc<SearchIndex>,        // immutable snapshot/lease
    input_version: SearchInputVersion,
}

struct SearchInputVersion {
    source: FieldId,
    revision: Revision,
    coarse_owner_epoch: u64,
    policy_generation: u64,
}

struct SearchCompletion {
    stamp: RequestStamp,               // owner, site/producer, ticket
    input_version: SearchInputVersion,
    outcome: Result<Arc<[TrackId]>, SearchError>,
}

enum QuestionState<T, E> {
    Empty,
    Ready(T),
    Pending { ticket: u64, previous: Option<T> },
    Fault { error: E, previous: Option<T> },
}
```

For search, instantiate `T = Arc<[TrackId]>`; the state owns one handle, while views borrow it. Measure the concrete enum layout before freezing it. Preserve the semantic distinction: Pending/Fault is the current logical result, while `previous` is an explicitly stale presentation candidate. A boundary may elect to keep it with loading/error chrome; stale must not be reported as Ready at the new input version.

The completion cannot be an ordinary `with_inbox(inbox, |model, message| ...)` callback if the `RequestGate` lives with framework runtime state: the callback sees only `&mut M`, not the gate, and moving the gate into the app would turn framework delivery authority into an application route field. The minimum framework seam is a statically typed `QuestionSlot<M, I, O, E, Freeze, Start>` installed beside the existing typed lane (or nested as a monomorphized question-set type). It owns the gate, current input version and outcome; typed projections freeze/apply under the owner borrow, while the worker closure only receives owned data. A heterogeneous question set must remain a static typed chain/tuple or use a documented cold descriptor boundary; do not erase each live producer or result into `Box<dyn Any>`.

The turn order for one question is:

1. A typed query edit commits through the existing owner operation. After normal callback return, freeze the selected query and immutable catalog lease while the owner is exclusively borrowed. Bound query bytes and result count/page size. Do not retain `&Library` or `&Signal` in the work item.
2. Advance the question ticket and install `Pending { previous }` as an owner state transition. The worker receives only `SearchInput + RequestStamp + Remote<SearchCompletion>`; it never reads or mutates the owner.
3. On completion, the existing bounded lane stages the owned message. In a later owner turn compare owner/site/ticket **and** the explicit `SearchInputVersion` against current authority. Only on full match, consume admission and move the result into `Ready` or a typed domain `Fault` in the same owner operation. Stale completion is dropped with a stale counter. Framework worker panic/closed service/queue exhaustion is framework Fault, not a fabricated `SearchError`.
4. If description/presentation fails after the completion operation committed, retain the accepted `QuestionState` for recovery. Do not consume a ticket and drop its value in a presentation draft.
5. On a newer query or owner-coarse edit, start a new ticket. Cancellation is best-effort resource control; stamp admission is the correctness guarantee.

If runtime hooks are needed, add one typed `QuestionSpec<I,O,E,F>` registration that is monomorphized with the owner/application type, analogous to `Win<M,L>`'s nested static inbox lane. Keep only compact site/version state for a mounted live question. Avoid a vector of boxed producer values and avoid retaining a closure per node. Do not add a field to every `Signal`; unused sources must pay zero. The executor may allocate its own task/future representation; report that separately and do not add a second framework-owned erased future wrapper. If a productively composable `Reader` cannot be represented without heterogeneous erasure, stop at this first typed question instead of hiding `Box<dyn Fn>` behind a generic spelling.

The input boundary needs one explicit policy for arbitrary `Win::update`: conservatively advance the separate checked `coarse_owner_epoch` and supersede every mounted question owned by that model. Typed `Source` operations can later invalidate only subscribers to that field. This preserves correctness through source replacement without making all exact field edits invalidate all search work. It is a known over-invalidation case, not an exact dependency graph claim. Reusing `source_epoch` would also be safe but needlessly cancels after every typed edit; if a second counter is deferred, document and measure that broader invalidation instead.

## Bound memory and overload behavior

`Remote::bounded(C)` bounds message count, not bytes. Pair it with a hard maximum query/input size, bounded result page/count, maximum active jobs per question, and a bound on immutable catalog leases. Budget queue + staging + worker-held payloads + committed current/previous outcomes together. A question returning all 250K library IDs is not bounded merely because it sends one message; return a capped page plus total count, or keep a stable shared index and return a bounded ID page.

The queue-full path must not leave the current request pending forever. For the initial implementation either size a dedicated lane to the declared maximum number of concurrent completions and assert that invariant, or retry/backpressure on a worker thread while preserving payload ownership. `try_send(Full(payload))` must be handled; silently dropping the newest completion is incorrect. Do not block the UI owner. Native callbacks remain inert. Physical cancellation does not guarantee a future cannot still produce a completion.

Measured cost ledger before any optimization claim:

- one existing bounded channel/staging allocation per typed lane, plus the existing wake token under `native`;
- one `Arc<OwnerState>` allocation per owner scope, not per request; the 32-byte request stamp carries one Arc and three u64s;
- one frozen input lease/owned bounded query per active request, one bounded output page per completion, and at most the declared worker/queue/staging/previous-result caps;
- no async storage for a model with no declared/used question; no extra atomics/word in each `Signal`; no per-query allocation in the owner thread after capacities and string/page buffers warm, to be proven by the allocator gate;
- task/runtime executor costs and cancellation-retained storage must be reported separately from GPUI owner and message costs.

`Arc<SearchIndex>` is only justified if the index is immutable for the lease lifetime. If mutable catalog updates require cloning the whole index, use a revisioned immutable index page or a DB snapshot/connection rather than disguising a deep copy as a cheap Arc. The existing Hummingbird path uses an in-memory search index for query and an `Arc<Vec<Identifier>>` result list; its table realizes visible rows plus bounded prefetch, so full UI row entity creation is not an appropriate first result payload.

## Why not begin with a general graph

Salsa's red-green model is the best fit for version validation: tracked functions record field/query reads; revisions validate dependencies; equal outputs can be backdated so downstream consumers need not rerun. Its published 0.28.5 docs also make two costs explicit: each input field has its own dependency identity, but a setter marks the field changed without equality; interned/memoized values remain until database drop unless LRU/identity lifecycle is chosen. That gives useful mechanics, not a drop-in UI model: its database uses interior runtime tables, retained memo history and macro-generated typed ingredients, whereas this cleanroom requires one exclusive owner, no per-producer erased values, bounded completion payloads, and presentation cohorts across async boundaries. Start with explicit typed inputs and equality at the destination; add graph memo verification only after the Library workload identifies repeated derivations that pay for edge storage.

Bevy 0.19.1's `ComponentTicks` is a close comparison for mutation stamps: mutable dereference is conservatively changed, and the system compares actual values when needed. Bevy's 0.19 migration guide says the render phase's full visible-entity tick scan became a bottleneck and was replaced with change lists. The transferable removal is not “put a change tick in every GPUI field”; it is a measured, opt-in dirty-source list at a sparse subscription boundary. Bevy pays companion tick storage throughout ECS and controls mutation APIs; this cleanroom's inline Signal has no such per-field table and arbitrary owner edits have intentionally conservative impact. A per-Signal dirty link would lose for mostly unwired short-lived fields.

Adapton's PLDI 2014 demanded computation graph is useful for one further constraint: recompute only demanded values and distinguish inner incremental state from the outer observer. Its graph/history and name matching have their own retention costs. Apply demand to Reader installation/parking (no graph node before a consumer asks; remove its edges when unobserved), not to every `view` closure or every scalar. DBSP's differential-dataflow lineage gives a related delta idea, but the full stream algebra would be excessive for a one-search question. First measure whether Hummingbird's search really needs repeated incremental updates or simply a bounded asynchronous query and virtualized results.

## Correctness cases before API freeze

1. **A→B→A:** request A1; publish B; publish A2; deliver A1 last. A1 is stale even though the current query equals A. Only A2 settles.
2. **Source replacement:** query Signal revision 4; arbitrary owner update replaces it with a new revision-zero Signal with the same string; old completion must fail on coarse-owner epoch/incarnation.
3. **Unrelated typed source:** change a theme/source with exact field identity. It must not cancel a question whose frozen input tuple excludes it.
4. **Owner lifecycle:** close/remount the same diagnostic owner/site; a queued old completion cannot be admitted by reused numeric owner/site/ticket values.
5. **Input/policy:** same query value but explicit retry or sort/filter policy change creates a new ticket/policy generation; changed frozen tuple never validates by `PartialEq` alone.
6. **Presentation failure:** accepted completion commits to the outcome slot, then view/layout fails. Retry presents that result without reaccepting or losing it.
7. **Domain vs framework failure:** DB `NotFound` becomes typed domain Fault; worker panic, executor shutdown, full queue and revoked owner remain distinct framework faults with provenance.
8. **Capacity and shutdown:** saturate queue, close inbox with queued payload, panic the owner during one callback, then verify every rejected/undelivered payload is returned/dropped under stated ownership policy and no request remains falsely Pending.
9. **No hidden app borrow:** compile-fail a frozen input that tries to retain `&Library` or `&Signal`; worker API accepts only `Send + 'static` owned snapshots or declared immutable leases.
10. **Cohort reveal:** one question refreshing while another independent source changes. The boundary displays `previous + current unrelated value`, never a mixed new-query/old-result pair labelled current. If two questions are later grouped under one boundary, reveal waits for the declared group, not accidental scheduling order.
11. **Fault recovery / cancellation:** failed attempt reads a changed prerequisite, then the next query succeeds; old result remains stale-only and the failure boundary heals once. Cancelled work that still returns is harmless.
12. **Fair batch:** arrivals during callback wait until the next owner turn; finite drain re-arms when more remain. Input-priority work is not starved by a completion flood.

## Benchmark gate and losing cases

Use the real Library query path with a fixed 250K-track index and deterministic worker latency/results; compare synchronous full scan, current standalone `Remote` delivery, and the typed question. Run repeated input traces: 1000 keystrokes at 8–12 Hz, alternating short and long queries, filter/sort changes, owner replacement, burst of stale completions, and one cold mount/remount. Record:

- p50/p95/p99 query-to-visible-result and input-turn latency; owner callback maximum duration;
- number/bytes of catalog rows scanned, source descriptors scanned, search jobs started/cancelled/completed, accepted/stale completion counts, and queue high-water;
- owner-thread allocations and allocated bytes per keypress / completion after warm-up; queue, staging, frozen input, previous result and result-page high-water bytes;
- retained live node/edge/question bytes with zero consumers, one consumer, and a parked/remounted consumer; ensure a never-used question has zero dynamic graph records;
- end-to-end result equivalence against synchronous search, stable result ordering, and exactly zero stale admissions across randomized delays.

Adopt a later graph optimization only if, against this application trace, it removes a counted scan/evaluation/alloc, preserves full-recompute oracle output, and does not add unexplained owner-turn or input-latency regression. The first typed question should have zero per-keypress owner-thread allocations after warm-up and no job/result queue growth beyond configured caps. Compare baseline values on the target platform rather than assuming Bevy/Salsa ratios transfer.

It loses when search is cheap enough to run synchronously under the measured owner budget; the question gets no consumers; all queries produce unique huge result lists; users type faster than a slow DB can finish and strict latest-wins cancels useful work; immutable index snapshots become expensive copies; or the storage/edge metadata dominates a tiny Library model. In those cases use the existing synchronous `Source`/owner path, demand-only producer installation, capped pagination, or a plain bounded `Remote` service with explicit state instead of an unearned generic Reader graph.

## Source audit references

Local implementation references (all are the active source paths):

- [`Signal` local revision and checked `DerefMut`](/root/gpui-ce3/reactivity/crates/state/src/signal.rs:1)
- [`Source` typed field descriptor and source operation](/root/gpui-ce3/reactivity/crates/gpui/src/source.rs:39)
- [`Sources` cold type-erased descriptor and scan](/root/gpui-ce3/reactivity/crates/gpui/src/source.rs:403)
- [`Win::update` and `Win::set`](/root/gpui-ce3/reactivity/crates/gpui/src/runtime.rs:785)
- [`Runtime::operation` commit/epoch barrier](/root/gpui-ce3/reactivity/crates/gpui/src/runtime.rs:1240)
- [`Remote<T>` bounded queue and payload-preserving `Full`/`Closed`](/root/gpui-ce3/reactivity/crates/gpui/src/remote.rs:24)
- [`RequestGate` owner/ticket stamp and caller-owned input validation obligation](/root/gpui-ce3/reactivity/crates/state/src/request.rs:115)
- [Reactivity graph boundary and Reader input freezing](/root/gpui-ce3/reactivity/REACTIVITY.md:14)
- [Concurrency payload and queue requirements](/root/gpui-ce3/reactivity/CONCURRENCY.md:1)
- [Original Reader and cohort statutes](/root/designs/reactivity/final/05-async.md:21)
- [Current Hummingbird source audit at pinned upstream commit](/root/gpui-ce3/reactivity/docs/hummingbird-source-audit-luna.md:1)

Primary external sources read (links point at the implementation/docs actually consulted):

- [Salsa 0.28.5 crate docs](https://docs.rs/salsa/0.28.5/salsa/) (read 2026-10-21): per-field input dependencies, Copy IDs, tracked query read recording, output equality/backdating, and memo retention. [Salsa `maybe_changed_after` source, 0.28.5](https://docs.rs/salsa/0.28.5/src/salsa/function/maybe_changed_after.rs.html) shows memo validation checks and re-execution path. This is a mechanics comparison, not a recommendation to adopt Salsa's database.
- [Bevy ECS change tick source, tag v0.19.1](https://github.com/bevyengine/bevy/blob/v0.19.1/crates/bevy_ecs/src/change_detection/tick.rs), read directly: relative tick-age logic and component tick representation. [Bevy 0.19 migration guide, “Change lists”](https://bevy.org/learn/migration-guides/0-18-to-0-19/) describes replacing a full visible-entity tick scan after it became a bottleneck; [Bevy 0.19 release notes](https://bevy.org/news/bevy-0-19/) reports the render specialization/queuing work reduction. This is direct evidence for benchmarked sparse-dirty lists at that call site, not an all-systems speed guarantee.
- Matthew Hammer et al., [“Adapton: Composable, Demand-Driven Incremental Computation,” PLDI 2014](https://matthewhammer.org/adapton/adapton-pldi2014.pdf), read paper abstract and demanded-graph/observer sections: demand can avoid work not observed, but the system retains graph identities and incremental state. Transfer only the install/park-on-demand idea, then measure the storage tax.
- [Hummingbird pinned search model](https://github.com/hummingbird-player/hummingbird/blob/e15e8ba0ef6ff5445294030d373e3c8ccc7d780c/src/ui/search/model.rs#L40-L145), [async resource](https://github.com/hummingbird-player/hummingbird/blob/e15e8ba0ef6ff5445294030d373e3c8ccc7d780c/src/ui/components/async_resource.rs#L21-L130), and [virtualized table](https://github.com/hummingbird-player/hummingbird/blob/e15e8ba0ef6ff5445294030d373e3c8ccc7d780c/src/ui/components/table.rs#L47-L162) at commit `e15e8ba0ef6ff5445294030d373e3c8ccc7d780c` (2026-10-20): the actual application has async search/resources and realizes visible rows with prefetch rather than materializing every row. The exact source audit and limitations are recorded in the linked local report.
- [DBSP, PVLDB 16(7), 2023](https://docs.feldera.com/vldb23.pdf), read introduction/derivative sections: relational operators can propagate data deltas instead of recomputing full outputs. The lineage is relevant to a future large changing catalogue, but its operator/state machinery is a losing first implementation for one bounded search question.

## Explicit deviations from the future public statutes

This first application slice is intentionally narrower than the final public model: one typed source tuple, one question site, and one reveal boundary; no arbitrary async closure composition, no dynamic read tracking, no overlapping cohort join, and no guarantee of preserving pending prior values across every boundary. It is enough to test the actual Reader borrow/freeze/admission seam on Library. Expand to typed source tuples and joined cohorts only after this exact slice passes the tests and its costs are measured; do not relabel the limited slice as the complete generic `Reader<T>` implementation.
